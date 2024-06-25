#include <stdio.h>
#include <string.h>

void remove_content_inside_brackets(char* str) {
    int length = strlen(str);
    int write_pos = 0;
    int inside_brackets = 0;

    for (int i = 0; i < length; i++) {
        if (str[i] == '[') {
            inside_brackets = 1;
            str[write_pos++] = '[';
        } else if (str[i] == ']') {
            inside_brackets = 0;
            str[write_pos++] = ']';
        } else if (!inside_brackets) {
            str[write_pos++] = str[i];
        }
    }

    // Null-terminate the string at the new length
    str[write_pos] = '\0';
}

int main() {
    char str1[] = "[2][zat][7]";
    char str2[] = "[8][gads]";
    char str3[] = "[10]";
    char str4[] = "[abc][def][ghi][jkl]";

    remove_content_inside_brackets(str1);
    remove_content_inside_brackets(str2);
    remove_content_inside_brackets(str3);
    remove_content_inside_brackets(str4);

    printf("%s\n", str1);  // Output: "[][][]"
    printf("%s\n", str2);  // Output: "[][]"
    printf("%s\n", str3);  // Output: "[]"
    printf("%s\n", str4);  // Output: "[][][][]"

    return 0;
}
