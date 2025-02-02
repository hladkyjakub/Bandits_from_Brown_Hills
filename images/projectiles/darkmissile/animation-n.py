from PIL import Image
import numpy as np
from pathlib import Path
import os

def create_movement_animation(image_path, output_folder):
    """
    Creates animation with 150ms movement followed by 200ms fade out,
    moving north (up) with 15px Y offset from center.
    
    Args:
        image_path (str): Path to input tile image
        output_folder (str): Folder to save animation frames
    """
    Path(output_folder).mkdir(parents=True, exist_ok=True)
    
    # Animation frames
    MOVE_FRAMES = 9
    FADE_FRAMES = 12
    TOTAL_FRAMES = MOVE_FRAMES + FADE_FRAMES
    
    # Y offset to move image down from center
    Y_OFFSET = 15
    
    # Open and convert image to RGBA
    img = Image.open(image_path).convert('RGBA')
    
    # Wesnoth's measurements
    TILE_WIDTH = 72
    TILE_HEIGHT = 72
    HEX_VERTICAL_SPACING = 72
    
    # Calculate output size
    OUTPUT_WIDTH = TILE_WIDTH * 4
    OUTPUT_HEIGHT = TILE_HEIGHT * 4
    
    # Base center position
    base_center_x = OUTPUT_WIDTH // 2
    base_center_y = OUTPUT_HEIGHT // 2
    
    # Initial position with offset
    start_x = base_center_x - TILE_WIDTH//2
    start_y = base_center_y - TILE_HEIGHT//2 + Y_OFFSET  # Add offset to move down
    
    # Generate all frames
    for frame in range(TOTAL_FRAMES):
        frame_img = Image.new('RGBA', (OUTPUT_WIDTH, OUTPUT_HEIGHT), (0, 0, 0, 0))
        
        if frame < MOVE_FRAMES:
            # Movement phase
            progress = frame / (MOVE_FRAMES - 1)
            progress = 0.5 - 0.5 * np.cos(progress * np.pi)  # ease in-out
            
            # For north movement, only Y changes (moving up = negative Y)
            current_x = start_x
            current_y = start_y + int((-HEX_VERTICAL_SPACING) * progress)  # Full tile up
            
            frame_img.paste(img, (int(current_x), int(current_y)), img)
            
        else:
            # Fade out phase
            fade_frame = frame - MOVE_FRAMES
            fade_progress = fade_frame / (FADE_FRAMES - 1)
            
            # Position for fade (final position from movement)
            final_x = start_x
            final_y = start_y - HEX_VERTICAL_SPACING
            
            # Create faded version of image
            faded_img = img.copy()
            data = np.array(faded_img)
            data[..., 3] = data[..., 3] * (1 - fade_progress)
            faded_img = Image.fromarray(data)
            
            frame_img.paste(faded_img, (int(final_x), int(final_y)), faded_img)
        
        frame_path = os.path.join(output_folder, f'frame_{frame:03d}.png')
        frame_img.save(frame_path, 'PNG')

def create_gif(frame_folder, output_gif):
    """
    Combines frames into an animated GIF.
    Movement: 150ms (9 frames)
    Fade out: 200ms (12 frames)
    """
    frames = []
    for i in range(21):  # 9 movement + 12 fade frames
        frame_path = os.path.join(frame_folder, f'frame_{i:03d}.png')
        frames.append(Image.open(frame_path))
    
    # Save as GIF
    frames[0].save(
        output_gif,
        save_all=True,
        append_images=frames[1:],
        duration=[17]*9 + [17]*12,  # 17ms per frame for both sequences
        loop=0,
        optimize=False
    )

# Example usage
if __name__ == "__main__":
    create_movement_animation("darkmissile-n.png", "n")
    create_gif("n", "movement_north.gif")
