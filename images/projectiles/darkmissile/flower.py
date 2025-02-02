from PIL import Image
import numpy as np

def create_hex_flower(image_path, output_path):
    """
    Creates a larger image containing 7 tiles in a hexagonal flower pattern.
    Uses correct Wesnoth hex grid measurements for proper alignment.
    
    Args:
        image_path (str): Path to input image
        output_path (str): Path to save the flower pattern image
    """
    # Open and convert image to RGBA to preserve transparency
    img = Image.open(image_path).convert('RGBA')
    
    # Wesnoth's tile measurements
    TILE_WIDTH = 72
    TILE_HEIGHT = 72
    HEX_HORIZONTAL_SPACING = 54  # Distance between hex centers horizontally
    HEX_VERTICAL_SPACING = 72    # Distance between hex centers vertically
    
    # Calculate output image size
    OUTPUT_WIDTH = TILE_WIDTH * 3
    OUTPUT_HEIGHT = TILE_HEIGHT * 3
    
    # Create new image with size for 7 tiles
    new_img = Image.new('RGBA', (OUTPUT_WIDTH, OUTPUT_HEIGHT), (0, 0, 0, 0))
    
    # Center position
    center_x = OUTPUT_WIDTH // 2
    center_y = OUTPUT_HEIGHT // 2
    
    # Define positions for all 7 tiles (center + 6 surrounding)
    # Format: (x_offset, y_offset)
    positions = [
        # Center
        (center_x, center_y),
        # Top
        (center_x, center_y - HEX_VERTICAL_SPACING),
        # Top Right
        (center_x + HEX_HORIZONTAL_SPACING, center_y - HEX_VERTICAL_SPACING//2),
        # Bottom Right
        (center_x + HEX_HORIZONTAL_SPACING, center_y + HEX_VERTICAL_SPACING//2),
        # Bottom
        (center_x, center_y + HEX_VERTICAL_SPACING),
        # Bottom Left
        (center_x - HEX_HORIZONTAL_SPACING, center_y + HEX_VERTICAL_SPACING//2),
        # Top Left
        (center_x - HEX_HORIZONTAL_SPACING, center_y - HEX_VERTICAL_SPACING//2),
    ]
    
    # Paste the tile in all positions
    for x, y in positions:
        # Offset by half tile size to center the tile on the hex center
        paste_x = int(x - TILE_WIDTH//2)
        paste_y = int(y - TILE_HEIGHT//2)
        new_img.paste(img, (paste_x, paste_y), img)
    
    # Save the result
    new_img.save(output_path, 'PNG')
    return new_img

# Example usage
if __name__ == "__main__":
    create_hex_flower("darkmissile-ne.png", "hex_flower_output.png")
