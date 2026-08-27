import struct

def create_simple_png(filename, width, height, color):
    """Create a simple PNG file"""
    import zlib
    
    # PNG signature
    png_sig = b'\x89PNG\r\n\x1a\n'
    
    # IHDR chunk
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0)
    ihdr_crc = zlib.crc32(b'IHDR' + ihdr_data) & 0xffffffff
    ihdr_chunk = struct.pack('>I', 13) + b'IHDR' + ihdr_data + struct.pack('>I', ihdr_crc)
    
    # IDAT chunk (image data)
    raw_data = b''
    for y in range(height):
        raw_data += b'\x00'  # filter type
        for x in range(width):
            raw_data += bytes(color)
    
    compressed = zlib.compress(raw_data, 9)
    idat_crc = zlib.crc32(b'IDAT' + compressed) & 0xffffffff
    idat_chunk = struct.pack('>I', len(compressed)) + b'IDAT' + compressed + struct.pack('>I', idat_crc)
    
    # IEND chunk
    iend_crc = zlib.crc32(b'IEND') & 0xffffffff
    iend_chunk = struct.pack('>I', 0) + b'IEND' + struct.pack('>I', iend_crc)
    
    with open(filename, 'wb') as f:
        f.write(png_sig + ihdr_chunk + idat_chunk + iend_chunk)

# Beige/tan color for hand (RGBA)
hand_color = (139, 125, 107, 255)
transparent = (0, 0, 0, 0)

# Create hand sprites
create_simple_png('hand-idle.png', 64, 64, hand_color)
create_simple_png('hand-walk.png', 64, 64, hand_color)
create_simple_png('hand-cast-fireball.png', 64, 64, hand_color)
create_simple_png('hand-cast-lightning.png', 64, 64, hand_color)
create_simple_png('hand-cast-frosttrap.png', 64, 64, hand_color)

# Create icon placeholders
create_simple_png('icon-lightning.png', 32, 32, (255, 255, 0, 255))
create_simple_png('icon-frosttrap.png', 32, 32, (100, 200, 255, 255))

# Create trap sprites
create_simple_png('frosttrap-glyph.png', 64, 64, (150, 220, 255, 200))
create_simple_png('frosttrap-burst.png', 64, 64, (200, 230, 255, 255))

print("Created placeholder sprites")
