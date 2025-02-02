#!/usr/bin/env python3
from PIL import Image
import os
import tkinter as tk
from tkinter import messagebox, simpledialog

def find_image_file(base_path):
    """Try to find the image file with common extensions."""
    extensions = ['.png', '.jpg', '.jpeg', '', '.bmp', '.PNG', '.JPG', '.JPEG', '.BMP']
    for ext in extensions:
        full_path = base_path + ext
        if os.path.exists(full_path):
            return full_path
    return None

def offset_image(input_path, output_path, offset_x, offset_y):
    """
    Offset an image by a fixed amount of pixels, cropping overflow.
    
    Args:
        input_path (str): Path to input image
        output_path (str): Path to save the processed image
        offset_x (int): Horizontal offset in pixels (positive = right)
        offset_y (int): Vertical offset in pixels (positive = down)
    """
    try:
        # Open the image
        with Image.open(input_path) as img:
            # Create new blank image with same size and mode
            new_img = Image.new(img.mode, img.size, (0, 0, 0, 0))
            
            # Calculate the actual area to copy
            width, height = img.size
            
            # Source coordinates (where to copy from)
            src_x = max(0, -offset_x)
            src_y = max(0, -offset_y)
            src_width = width - abs(offset_x)
            src_height = height - abs(offset_y)
            
            # Copy the portion of the image
            region = img.crop((src_x, src_y, src_x + src_width, src_y + src_height))
            new_img.paste(region, (max(0, offset_x), max(0, offset_y)))
            
            # Get the extension from input file
            _, ext = os.path.splitext(input_path)
            output_path_with_ext = output_path + (ext if ext else '.png')
            
            # Save the result
            new_img.save(output_path_with_ext)
            return True, ""
    except Exception as e:
        return False, str(e)

def process_directory(input_dir, offset_x, offset_y):
    """Process all numbered images in a directory."""
    # Create output directory if it doesn't exist
    os.makedirs(input_dir, exist_ok=True)
    
    success_count = 0
    errors = []
    
    # Process files named 1 through 6
    for i in range(1, 7):
        base_input_path = os.path.join(input_dir, str(i))
        base_output_path = os.path.join(input_dir, f"final-{i}")
        
        # Find the actual image file
        input_path = find_image_file(base_input_path)
        
        if input_path:
            success, error_msg = offset_image(input_path, base_output_path, offset_x, offset_y)
            if success:
                success_count += 1
            else:
                errors.append(f"Error processing image {i}: {error_msg}")
        else:
            errors.append(f"Could not find image {i} with any common extension")
    
    return success_count, errors

def main():
    # Initialize tkinter
    root = tk.Tk()
    root.withdraw()  # Hide the main window
    
    # Directory path
    directory = "/home/kuba/.var/app/org.wesnoth.Wesnoth/data/wesnoth/1.18/data/add-ons/Bandits_from_Brown_Hills/images/halo/dark-explosion"
    
    # Verify directory exists
    if not os.path.exists(directory):
        messagebox.showerror("Error", f"Directory not found:\n{directory}")
        return
        
    # Ask for offset values using dialog boxes
    offset_x = simpledialog.askinteger("Input", "Enter horizontal offset (pixels):", initialvalue=0)
    if offset_x is None:  # User clicked Cancel
        return
        
    offset_y = simpledialog.askinteger("Input", "Enter vertical offset (pixels):", initialvalue=0)
    if offset_y is None:  # User clicked Cancel
        return
    
    # Process images and get results
    success_count, errors = process_directory(directory, offset_x, offset_y)
    
    # Prepare detailed message
    message = f"Processing complete!\n\nSuccessfully processed: {success_count} images\n"
    if errors:
        message += f"\nErrors ({len(errors)}):\n" + "\n".join(errors)
    
    # Show completion message
    if errors:
        messagebox.showerror("Complete with Errors", message)
    else:
        messagebox.showinfo("Complete", message)

if __name__ == "__main__":
    main()
