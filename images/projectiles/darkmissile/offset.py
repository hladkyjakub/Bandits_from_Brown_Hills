from PIL import Image
import numpy as np

def offset_tile_ne(image_path, output_path):
    """
    Offsets a single tile to the northeast position, with enough canvas space
    for a theoretical flower pattern.
    
    Args:
        image_path (str): Path to input image
        output_path (str): Path to save the result
    """
    # Open and convert image to RGBA
    img = Image.open(image_path).convert('RGBA')
    
    # Wesnoth's measurements
    TILE_WIDTH = 72
    TILE_HEIGHT = 72
    HEX_HORIZONTAL_SPACING = 54  # Distance between hex centers horizontally
    HEX_VERTICAL_SPACING = 72    # Distance between hex centers vertically
    
    # Calculate output size to fit theoretical flower pattern
    OUTPUT_WIDTH = TILE_WIDTH * 4  # Space for 3 tiles wide plus margin
    OUTPUT_HEIGHT = TILE_HEIGHT * 4  # Space for 3 tiles high plus margin
    
    # Create new image
    new_img = Image.new('RGBA', (OUTPUT_WIDTH, OUTPUT_HEIGHT), (0, 0, 0, 0))
    
    # Initial center position
    center_x = OUTPUT_WIDTH // 2
    center_y = OUTPUT_HEIGHT // 2
    
    # Place initial tile at center
    paste_x = int(center_x - TILE_WIDTH//2)
    paste_y = int(center_y - TILE_HEIGHT//2)
    new_img.paste(img, (paste_x, paste_y), img)
    
    # Create offset image
    offset_img = Image.new('RGBA', (OUTPUT_WIDTH, OUTPUT_HEIGHT), (0, 0, 0, 0))
    
    # Calculate NE offset
    offset_x = HEX_HORIZONTAL_SPACING  # Move right by one hex
    offset_y = -HEX_VERTICAL_SPACING//2  # Move up by half hex
    
    # Apply offset
    offset_img.paste(new_img, (offset_x, offset_y), new_img)
    
    # Save result
    offset_img.save(output_path, 'PNG')
    return offset_img

# Example usage
if __name__ == "__main__":
    offset_tile_ne("darkmissile-ne.png", "tile_offset_ne.png")
