import sys

if len(sys.argv) != 2:
    print("Usage: {} <filename>".format(sys.argv[0]))
    sys.exit(1)  # Exit with error code

try:
    with open(sys.argv[1], "r") as file:
        N = int(file.readline().strip())
        S = list(map(int, file.readline().strip().split()))
except FileNotFoundError:
    print("Error opening file.")
    sys.exit(1)  # Exit with error code

total_sum = sum(S)
min_diff = total_sum
left_index = 0
current_sum = 0
diff = total_sum

for right_index in range(N):
    current_sum += S[right_index]  # move the right index
    diff = total_sum - 2 * current_sum

    # If the difference is positive, we keep adding to the subsequence
    if diff > 0:
        if diff < min_diff:
            min_diff = diff
    # If the difference is negative, we need to remove elements from the subsequence
    elif diff < 0:
        if abs(diff) < min_diff:
            min_diff = abs(diff)
        while diff < 0 and left_index < right_index:
            current_sum -= S[left_index]
            left_index += 1
            diff = total_sum - 2 * current_sum
            if abs(diff) < min_diff:
                min_diff = abs(diff)
    if diff == 0:
        min_diff = 0
        break

print(min_diff)