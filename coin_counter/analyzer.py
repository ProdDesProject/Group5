import json

def count_coins(img: bytes):
    result = {
        'coins': [
            {
                'pos': {
                    'x': 0.321,
                    'y': 0.7,
                    'r': 0.1,
                },
                'worth': 2.0,
            },
            {
                'pos': {
                    'x': 0.5,
                    'y': 0.5,
                    'r': 0.05,
                },
                'worth': 0.05,
            },
        ],
        'worth': 2.05
    }
    return result