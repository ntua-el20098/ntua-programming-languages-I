#include <iostream>
#include <vector>
#include <cmath>
#include <cstdio>

using namespace std;



int main(int argc, char *argv[])
{
    int N;
  
    if (argc != 2) {
        printf("Usage: %s <filename>\n", argv[0]);
        return 1; // Exit with error code
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        printf("Error opening file.\n");
        return 1; // Exit with error code
    }

    if(fscanf(file, "%d", &N)){
        // Do nothing
    }

    vector<int> S(N);
    int sum = 0;
    // Read in the array, calculate sum, and prefix sum
    for (int i = 0; i < N; ++i)
    {
        if(fscanf(file, "%d", &S[i])){
            // Do nothing
        }
        sum += S[i];
    }

    fclose(file);

    const int total_sum = sum;
    int min_diff = total_sum;
    int left_index = 0;
    int current_sum = 0;
    int diff=total_sum;

    for (int right_index = 0; right_index < N; right_index++)
    {
        current_sum += S[right_index]; // move the right index
        diff = total_sum - 2 * current_sum;

        // If the difference is positive, we keep adding to the subsequence
        if (diff > 0)
        {
            if (diff < min_diff)
            {
                min_diff = diff;
            }
        }
        // If the difference is negative, we need to remove elements from the subsequence
        else if (diff < 0)
        {
            if (abs(diff) < min_diff)
            {
                min_diff = abs(diff);
            }
            while (diff < 0 && (left_index < right_index))
            {
                current_sum -= S[left_index++];
                diff = total_sum - 2 * current_sum;
                if (abs(diff) < min_diff)
                {
                    min_diff = abs(diff);
                }
            }
        }
        if (diff == 0)
        {
            min_diff = 0;
            break;
        }
    }

    cout << min_diff << endl;
    return 0;
}