from random import randint as rInt

# Generate list of random four numbers
arr = [(rInt(1, 10), rInt(1, 10), rInt(1, 10), rInt(1, 10)) for _ in range(1000)]

# Create dictionary with keys of different types of rectangles
rectangles = {
    "square": [],
    "rectangle": [],
    "parallelogram": [],
    "trapezoid": [],
    "None": []
}

# Fill the lists at all keys of the dictionary using elements of the arr list
for a, b, c, d in arr:
    if a == b == c == d:
        rectangles["square"].append((a, b, c, d))
    elif a == c and b == d:
        rectangles["rectangle"].append((a, b, c, d))
    elif a == c or b == d:
        rectangles["parallelogram"].append((a, b, c, d))
    else:
        rectangles["trapezoid"].append((a, b, c, d))
    rectangles["None"].append((a, b, c, d))
    
# Calculate the number of elements on each list and output the appropriate result
for shape, values in rectangles.items():
    print(f"{shape}: {len(values)}")
