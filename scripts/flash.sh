#!/bin/bash
# ESP32 Experiment Flasher - Pick an experiment to upload!

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
EXPERIMENTS_DIR="$PROJECT_DIR/experiments"
LAST_CHOICE_FILE="$PROJECT_DIR/.last-flash"

# Colors for fun!
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RESET='\033[0m'

echo ""
echo "   ========================================"
echo "      ESP32 Experiment Flasher"
echo "   ========================================"
echo ""

# Load last choice
LAST_EXP=""
LAST_FILE=""
if [ -f "$LAST_CHOICE_FILE" ]; then
    LAST_EXP=$(head -1 "$LAST_CHOICE_FILE" 2>/dev/null)
    LAST_FILE=$(tail -1 "$LAST_CHOICE_FILE" 2>/dev/null)
fi

# Find all experiments
EXPERIMENTS=()
for dir in "$EXPERIMENTS_DIR"/*/; do
    if [ -d "$dir" ]; then
        name=$(basename "$dir")
        # Check if it has .py files
        if ls "$dir"*.py &>/dev/null; then
            EXPERIMENTS+=("$name")
        fi
    fi
done

if [ ${#EXPERIMENTS[@]} -eq 0 ]; then
    echo "   No experiments found!"
    echo "   Create a folder in: $EXPERIMENTS_DIR"
    echo ""
    exit 1
fi

# Show experiment menu
echo "   Pick an experiment:"
echo ""

DEFAULT_EXP=1
for i in "${!EXPERIMENTS[@]}"; do
    num=$((i + 1))
    exp="${EXPERIMENTS[$i]}"

    # Count .py files
    py_count=$(ls "$EXPERIMENTS_DIR/$exp"/*.py 2>/dev/null | wc -l | tr -d ' ')

    # Mark default
    marker="  "
    if [ "$exp" = "$LAST_EXP" ]; then
        DEFAULT_EXP=$num
        marker="${YELLOW}*${RESET} "
    fi

    if [ "$py_count" -eq 1 ]; then
        file=$(basename "$EXPERIMENTS_DIR/$exp"/*.py)
        echo -e "   $marker${CYAN}$num)${RESET} $exp  ($file)"
    else
        echo -e "   $marker${CYAN}$num)${RESET} $exp  ($py_count programs)"
    fi
done

echo ""
echo -e "   ${YELLOW}*${RESET} = last used"
echo ""
read -p "   Enter number [$DEFAULT_EXP]: " choice

# Default to last choice
if [ -z "$choice" ]; then
    choice=$DEFAULT_EXP
fi

# Validate choice
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#EXPERIMENTS[@]} ]; then
    echo ""
    echo "   Invalid choice!"
    exit 1
fi

SELECTED_EXP="${EXPERIMENTS[$((choice - 1))]}"
SELECTED_PATH="$EXPERIMENTS_DIR/$SELECTED_EXP"

# Get .py files in selected experiment
PY_FILES=()
for f in "$SELECTED_PATH"/*.py; do
    if [ -f "$f" ]; then
        PY_FILES+=("$(basename "$f")")
    fi
done

SELECTED_FILE="${PY_FILES[0]}"

# If multiple files, ask which one
if [ ${#PY_FILES[@]} -gt 1 ]; then
    echo ""
    echo "   Pick a program from $SELECTED_EXP:"
    echo ""

    DEFAULT_FILE=1
    for i in "${!PY_FILES[@]}"; do
        num=$((i + 1))
        file="${PY_FILES[$i]}"

        marker="  "
        if [ "$SELECTED_EXP" = "$LAST_EXP" ] && [ "$file" = "$LAST_FILE" ]; then
            DEFAULT_FILE=$num
            marker="${YELLOW}*${RESET} "
        fi

        echo -e "   $marker${CYAN}$num)${RESET} $file"
    done

    echo ""
    read -p "   Enter number [$DEFAULT_FILE]: " file_choice

    if [ -z "$file_choice" ]; then
        file_choice=$DEFAULT_FILE
    fi

    if ! [[ "$file_choice" =~ ^[0-9]+$ ]] || [ "$file_choice" -lt 1 ] || [ "$file_choice" -gt ${#PY_FILES[@]} ]; then
        echo ""
        echo "   Invalid choice!"
        exit 1
    fi

    SELECTED_FILE="${PY_FILES[$((file_choice - 1))]}"
fi

# Save choice for next time
echo "$SELECTED_EXP" > "$LAST_CHOICE_FILE"
echo "$SELECTED_FILE" >> "$LAST_CHOICE_FILE"

# Upload!
echo ""
echo "   ----------------------------------------"
"$SCRIPT_DIR/upload.sh" "$SELECTED_PATH"
