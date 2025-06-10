#!/bin/bash

# Example script to demonstrate the usage of menu_generator_v1.sh

# --- IMPORTANT ---
# Ensure that 'menu_generator_v1.sh' is in the same directory as this script,
# or provide the correct path to it.
# Make sure 'menu_generator_v1.sh' is executable if you were to run it directly,
# but here we are sourcing it, so it just needs to be readable.

# Source the script containing the generate_menu function
# If menu_generator_v1.sh is not in the current directory, adjust the path.
# For example: source /path/to/your/scripts/menu_generator_v1.sh
if [ -f ./menu_generator_v1.sh ]; then
    source ./menu_generator_v1.sh
else
    echo "Error: menu_generator_v1.sh not found. Please make sure it's in the current directory or update the path."
    exit 1
fi

echo "----------------------------------------------------"
echo "Example 1: Basic English Menu with default settings"
echo "----------------------------------------------------"
# Calling with only language and menu items. Colors and width will be default.
# The function will prompt for input and echo the selected index.
selected_index_en=$(generate_menu "en" "Open File,Save File,Edit Preferences,View Logs,Exit Program")
if [ $? -eq 0 ]; then # Check if generate_menu exited successfully
    echo "You selected option number: $selected_index_en"
    # You can then use if/elif/else or a case statement to act on the selection
    case "$selected_index_en" in
        1) echo "Action: Opening file...";;
        2) echo "Action: Saving file...";;
        3) echo "Action: Editing preferences...";;
        4) echo "Action: Viewing logs...";;
        5) echo "Action: Exiting program...";;
        *) echo "Action: No specific action defined for this selection.";;
    esac
else
    echo "Menu was exited or an error occurred in generate_menu."
fi
echo # Newline for better readability


echo "----------------------------------------------------"
echo "Example 2: Farsi Menu with custom colors and width"
echo "----------------------------------------------------"
# Parameters: lang, items, table_color, title_color, item_color, column_width
selected_index_fa=$(generate_menu "fa" "باز کردن فایل,ذخیره فایل,ویرایش تنظیمات,مشاهده گزارشات,خروج از برنامه" "bright_blue" "yellow" "bright_cyan" "40")
if [ $? -eq 0 ]; then
    echo "شما گزینه شماره زیر را انتخاب کردید: $selected_index_fa"
    # Acting on the Farsi menu selection
    case "$selected_index_fa" in
        1) echo "عملیات: در حال باز کردن فایل...";;
        2) echo "عملیات: در حال ذخیره فایل...";;
        3) echo "عملیات: در حال ویرایش تنظیمات...";;
        4) echo "عملیات: در حال مشاهده گزارشات...";;
        5) echo "عملیات: در حال خروج از برنامه...";;
        *) echo "عملیات: هیچ عملیات خاصی برای این انتخاب تعریف نشده است.";;
    esac
else
    echo "منو بسته شد یا خطایی در تابع generate_menu رخ داد."
fi
echo # Newline

echo "----------------------------------------------------"
echo "Example 3: Menu with fewer options and default language (English)"
echo "----------------------------------------------------"
selected_index_simple=$(generate_menu "" "Yes,No,Maybe") # "" for lang defaults to English
if [ $? -eq 0 ]; then
    echo "Your choice was index: $selected_index_simple"
    if [ "$selected_index_simple" == "1" ]; then
        echo "You chose Yes!"
    elif [ "$selected_index_simple" == "2" ]; then
        echo "You chose No!"
    elif [ "$selected_index_simple" == "3" ]; then
        echo "You chose Maybe!"
    fi
else
    echo "Menu interaction did not complete successfully."
fi
echo

echo "----------------------------------------------------"
echo "Example 4: Handling a scenario where menu items might be empty (Error case)"
echo "----------------------------------------------------"
echo "Calling generate_menu with an empty item string (should show an error from generate_menu):"
generate_menu "en" "" # This should trigger the internal error handling

echo
echo "Calling generate_menu with no items after parsing (should show an error from generate_menu):"
empty_items_var=""
generate_menu "en" "$empty_items_var" # This should also trigger the error

echo
echo "----------------------------------------------------"
echo "End of examples."
echo "Remember that the generate_menu function itself handles the input loop."
echo "It will echo the selected 1-based index, which you capture in a variable."
echo "----------------------------------------------------"
