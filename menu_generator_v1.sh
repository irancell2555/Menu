#!/bin/bash

# Function to generate a menu
#
# Parameters:
#   $1: Language (en/fa) - Default: en
#   $2: Menu items (comma-separated string) - e.g., "Item 1,Item 2,Item 3"
#   $3: Table color (e.g., "blue") - Default: "white"
#   $4: Title color (e.g., "red") - Default: "green"
#   $5: Item color (e.g., "yellow") - Default: "cyan"
#   $6: Column widths (comma-separated string of numbers) - e.g., "10,20"
#

# --- Configuration ---
DEFAULT_LANG="en"
DEFAULT_TABLE_COLOR="white" # ANSI color name or code
DEFAULT_TITLE_COLOR="green"
DEFAULT_ITEM_COLOR="cyan"
DEFAULT_COLUMN_WIDTHS="30" # Default width for a single column

# --- Color Definitions (ANSI Escape Codes) ---
declare -A COLORS=(
  ["black"]='[0;30m' ["red"]='[0;31m' ["green"]='[0;32m'
  ["yellow"]='[0;33m' ["blue"]='[0;34m' ["magenta"]='[0;35m'
  ["cyan"]='[0;36m' ["white"]='[0;37m'
  ["bright_black"]='[1;30m' ["bright_red"]='[1;31m' ["bright_green"]='[1;32m'
  ["bright_yellow"]='[1;33m' ["bright_blue"]='[1;34m' ["bright_magenta"]='[1;35m'
  ["bright_cyan"]='[1;36m' ["bright_white"]='[1;37m'
  ["nc"]='[0m' # No Color
)

# --- Language Strings ---
declare -A texts_en
texts_en["menu_title"]="Menu"
texts_en["select_option"]="Select an option (1-" # Number will be appended
texts_en["invalid_option"]="Invalid option. Please try again."
texts_en["exit_option"]="Exit" # Currently not used as an automatic menu item
texts_en["error_empty_items"]="Error: Menu items string cannot be empty."
texts_en["error_no_items"]="Error: No menu items provided."

declare -A texts_fa
texts_fa["menu_title"]="منو"
texts_fa["select_option"]="یک گزینه را انتخاب کنید (1-" # Number will be appended
texts_fa["invalid_option"]="گزینه نامعتبر است. لطفاً دوباره تلاش کنید."
texts_fa["exit_option"]="خروج" # Currently not used
texts_fa["error_empty_items"]="خطا: رشته موارد منو نمی تواند خالی باشد."
texts_fa["error_no_items"]="خطا: هیچ مورد منویی ارائه نشده است."

# --- Helper Functions ---

print_colored_text() {
  local text="$1"
  local color_name="$2"
  local color_code="${COLORS[$color_name]}"
  if [[ -n "$color_code" ]]; then
    echo -e "${color_code}${text}${COLORS[nc]}"
  else
    echo -e "${text}"
  fi
}

get_text() {
  local key="$1"
  local lang="$2"
  if [[ "$lang" == "fa" && -n "${texts_fa[$key]}" ]]; then
    echo "${texts_fa[$key]}"
  elif [[ -n "${texts_en[$key]}" ]]; then
    echo "${texts_en[$key]}"
  else
    echo "$key"
  fi
}

# --- Main Function Logic ---
generate_menu() {
  # Parse arguments
  local lang="${1:-$DEFAULT_LANG}"
  local menu_items_str="${2}"
  local table_color_name="${3:-$DEFAULT_TABLE_COLOR}"
  local title_color_name="${4:-$DEFAULT_TITLE_COLOR}"
  local item_color_name="${5:-$DEFAULT_ITEM_COLOR}"
  local column_widths_str="${6:-$DEFAULT_COLUMN_WIDTHS}"
  # Build number: Increment manually after significant changes.
  local build_number=1

  if [[ -z "$menu_items_str" ]]; then
    print_colored_text "$(get_text "error_empty_items" "$lang")" "red"
    return 1
  fi

  IFS=',' read -r -a menu_items <<< "$menu_items_str"
  IFS=',' read -r -a column_widths <<< "$column_widths_str"
  local num_items=${#menu_items[@]}

  if [[ "$num_items" -eq 0 ]]; then
    print_colored_text "$(get_text "error_no_items" "$lang")" "red"
    return 1
  fi

  local content_width=${column_widths[0]:-30}
  let "total_width = content_width + 4"

  local menu_title_text=$(get_text "menu_title" "$lang")
  local select_option_base_text=$(get_text "select_option" "$lang")
  local invalid_option_text=$(get_text "invalid_option" "$lang")
  # Append the range to the select_option text
  local select_option_text="${select_option_base_text}${num_items})"


  local border_char_h="─"
  local border_char_v="│"
  local border_corner_tl="╭"
  local border_corner_tr="╮"
  local border_corner_bl="╰"
  local border_corner_br="╯"
  local border_separator_l="├"
  local border_separator_r="┤"

  printf "%s" "$(print_colored_text "$border_corner_tl" "$table_color_name")"
  for ((i=0; i<content_width + 2; i++)); do printf "%s" "$(print_colored_text "$border_char_h" "$table_color_name")"; done
  printf "%s
" "$(print_colored_text "$border_corner_tr" "$table_color_name")"

  local title_padding_total=$((content_width - ${#menu_title_text}))
  local title_padding_before=$((title_padding_total / 2))
  local title_padding_after=$((title_padding_total - title_padding_before))
  printf "%s %*s%s%*s %s
"     "$(print_colored_text "$border_char_v" "$table_color_name")"     "$title_padding_before" ""     "$(print_colored_text "$menu_title_text" "$title_color_name")"     "$title_padding_after" ""     "$(print_colored_text "$border_char_v" "$table_color_name")"

  printf "%s" "$(print_colored_text "$border_separator_l" "$table_color_name")"
  for ((i=0; i<content_width + 2; i++)); do printf "%s" "$(print_colored_text "$border_char_h" "$table_color_name")"; done
  printf "%s
" "$(print_colored_text "$border_separator_r" "$table_color_name")"

  for i in "${!menu_items[@]}"; do
    local item_number=$((i + 1))
    local item_text="${menu_items[$i]}"
    if [[ -z "$item_text" ]]; then item_text=" "; fi
    local display_item="$item_number. $item_text"
    local current_item_length=${#display_item}
    local padding_needed=$((content_width - current_item_length))
    if (( padding_needed < 0 )); then padding_needed=0; fi

    printf "%s $(print_colored_text "%s" "$item_color_name")%*s %s
"       "$(print_colored_text "$border_char_v" "$table_color_name")"       "$display_item"       "$padding_needed" ""       "$(print_colored_text "$border_char_v" "$table_color_name")"
  done

  printf "%s" "$(print_colored_text "$border_corner_bl" "$table_color_name")"
  for ((i=0; i<content_width + 2; i++)); do printf "%s" "$(print_colored_text "$border_char_h" "$table_color_name")"; done
  printf "%s
" "$(print_colored_text "$border_corner_br" "$table_color_name")"

  # --- User Input Handling ---
  local choice
  while true; do
    # Display prompt, applying item_color_name to the prompt text itself.
    # The input from the user will not be colored by this.
    printf "%s " "$(print_colored_text "$select_option_text" "$item_color_name")"
    read choice

    # Validate if choice is a number
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
      print_colored_text "$invalid_option_text" "red"
      continue
    fi

    # Validate if choice is within range
    if (( choice >= 1 && choice <= num_items )); then
      # Return the 1-based index of the choice
      echo "$choice" # This is the output of the function if a valid choice is made
      return 0 # Success
    else
      print_colored_text "$invalid_option_text" "red"
    fi
  done
}
# Example Usage (for testing this script directly):
# To make the function available in another shell, you would source this file:
# source ./menu_generator_v1.sh
# And then you can call it and capture the output:
# selected_option=$(generate_menu "fa" "گزینه اول,گزینه دوم طولانی تر,گزینه سوم" "yellow" "blue" "magenta" "35")
# echo "انتخاب شما: $selected_option"
#
# selected_option_en=$(generate_menu "en" "Option 1,Option 2 is longer,Option 3" "green" "red" "cyan" "30")
# echo "You selected: $selected_option_en"
#
# selected_default=$(generate_menu "" "Default 1,Default 2")
# echo "Default selected: $selected_default"

# echo "menu_generator_v1.sh updated with user input handling."
# echo "Build: 1 (manual)"
EOF
