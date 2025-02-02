from PIL import Image
import numpy as np
from pathlib import Path
import os

def create_direction_frames(base_img, output_folder, direction, y_offset=15):
    """
    Creates animation frames for a specific direction.
    Frames are named 0000.png, 0001.png, etc.
    
    Args:
        base_img: PIL Image object
        output_folder: Where to save frames
        direction: One of 'n', 'ne', 'nw', 's', 'se', 'sw'
        y_offset: Vertical offset from center
    """
    MOVE_FRAMES = 9
    FADE_FRAMES = 12
    TOTAL_FRAMES = MOVE_FRAMES + FADE_FRAMES
    
    # Wesnoth measurements
    TILE_WIDTH = 72
    TILE_HEIGHT = 72
    HEX_HORIZONTAL_SPACING = 54
    HEX_VERTICAL_SPACING = 72
    
    # Calculate output size
    OUTPUT_WIDTH = TILE_WIDTH * 4
    OUTPUT_HEIGHT = TILE_HEIGHT * 4
    
    # Base center position
    base_center_x = OUTPUT_WIDTH // 2
    base_center_y = OUTPUT_HEIGHT // 2
    
    # Initial position with offset
    start_x = base_center_x - TILE_WIDTH//2
    start_y = base_center_y - TILE_HEIGHT//2 + y_offset
    
    # Movement calculations based on direction
    movements = {
        'n':  (0, -HEX_VERTICAL_SPACING),
        'ne': (HEX_HORIZONTAL_SPACING, -HEX_VERTICAL_SPACING//2),
        'nw': (-HEX_HORIZONTAL_SPACING, -HEX_VERTICAL_SPACING//2),
        's':  (0, HEX_VERTICAL_SPACING),
        'se': (HEX_HORIZONTAL_SPACING, HEX_VERTICAL_SPACING//2),
        'sw': (-HEX_HORIZONTAL_SPACING, HEX_VERTICAL_SPACING//2)
    }
    
    dx, dy = movements[direction]
    
    # Create directory if it doesn't exist
    dir_path = os.path.join(output_folder, direction)
    os.makedirs(dir_path, exist_ok=True)
    
    # Generate frames
    for frame in range(TOTAL_FRAMES):
        frame_img = Image.new('RGBA', (OUTPUT_WIDTH, OUTPUT_HEIGHT), (0, 0, 0, 0))
        
        if frame < MOVE_FRAMES:
            progress = frame / (MOVE_FRAMES - 1)
            progress = 0.5 - 0.5 * np.cos(progress * np.pi)
            
            current_x = start_x + int(dx * progress)
            current_y = start_y + int(dy * progress)
            
            frame_img.paste(base_img, (int(current_x), int(current_y)), base_img)
            
        else:
            fade_frame = frame - MOVE_FRAMES
            fade_progress = fade_frame / (FADE_FRAMES - 1)
            
            final_x = start_x + dx
            final_y = start_y + dy
            
            faded_img = base_img.copy()
            data = np.array(faded_img)
            data[..., 3] = data[..., 3] * (1 - fade_progress)
            faded_img = Image.fromarray(data)
            
            frame_img.paste(faded_img, (int(final_x), int(final_y)), faded_img)
        
        # Save frame with new naming convention (0000.png, 0001.png, etc.)
        frame_path = os.path.join(dir_path, f'{frame:04d}.png')
        frame_img.save(frame_path, 'PNG')

def create_all_directions(output_folder="missile_frames"):
    """
    Creates animation frames and GIFs for all six directions.
    Corrected flipping logic for SE and SW directions.
    """
    # Load base images
    n_img = Image.open("darkmissile-n.png").convert('RGBA')
    ne_img = Image.open("darkmissile-ne.png").convert('RGBA')
    
    # Create flipped versions for other directions
    # For SE: First flip NE horizontally, then vertically
    se_img = ne_img.transpose(Image.FLIP_LEFT_RIGHT)
    # For SW: First flip NE horizontally, then vertically
    sw_img = ne_img.transpose(Image.FLIP_LEFT_RIGHT).transpose(Image.FLIP_TOP_BOTTOM)
    # For S: flip N vertically
    s_img = n_img.transpose(Image.FLIP_TOP_BOTTOM)
    # For NW: flip NE horizontally
    nw_img = ne_img.transpose(Image.FLIP_LEFT_RIGHT)
    
    # Generate frames for each direction
    directions = {
        'n': n_img,
        'nw': nw_img,
        'ne': ne_img,
        's': s_img,
        'se': se_img,
        'sw': sw_img
    }
    
    for direction, img in directions.items():
        create_direction_frames(img, output_folder, direction)
        create_gif(os.path.join(output_folder, direction), 
                  f"darkmissile-{direction}.gif")

def create_gif(frame_folder, output_gif):
    """
    Creates GIF from frames.
    """
    frames = []
    for i in range(21):  # 9 movement + 12 fade frames
        frame_path = os.path.join(frame_folder, f'{i:04d}.png')
        frames.append(Image.open(frame_path))
    
    frames[0].save(
        output_gif,
        save_all=True,
        append_images=frames[1:],
        duration=[17]*9 + [17]*12,
        loop=0,
        optimize=False
    )

if __name__ == "__main__":
    create_all_directions()
