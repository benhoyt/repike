/* Rob Pike's original C matching code. */

#include <stdio.h>
#include <string.h>

// Forward references
int matchhere(char *regexp, char *text);
int matchstar(int c, char *regexp, char *text);

/* match: search for regexp anywhere in text */
int match(char *regexp, char *text)
{
    if (regexp[0] == '^')
        return matchhere(regexp+1, text);
    do {    /* must look even if string is empty */
        if (matchhere(regexp, text))
            return 1;
    } while (*text++ != '\0');
    return 0;
}

/* matchhere: search for regexp at beginning of text */
int matchhere(char *regexp, char *text)
{
    if (regexp[0] == '\0')
        return 1;
    if (regexp[1] == '*')
        return matchstar(regexp[0], regexp+2, text);
    if (regexp[0] == '$' && regexp[1] == '\0')
        return *text == '\0';
    if (*text!='\0' && (regexp[0]=='.' || regexp[0]==*text))
        return matchhere(regexp+1, text+1);
    return 0;
}

/* matchstar: search for c*regexp at beginning of text */
int matchstar(int c, char *regexp, char *text)
{
    do {    /* a * matches zero or more instances */
        if (matchhere(regexp, text))
            return 1;
    } while (*text != '\0' && (*text++ == c || c == '.'));
    return 0;
}

int main(int argc, char* argv[])
{
    if (argc < 2) {
        fprintf(stderr, "usage: match <regexp>  # prints matching lines from stdin\n");
        return 2;
    }
    char* regexp = argv[1];

    char line[256];
    int num = 0;
    while (fgets(line, sizeof(line), stdin)) {
        // Strip \r and \n from end of line
        char* end = line + strlen(line);
        if (end > line && end[-1] == '\n') {
            end--;
            *end = '\0';
        }
        if (end > line && end[-1] == '\r') {
            end--;
            *end = '\0';
        }

        if (match(regexp, line)) {
            puts(line);
            num++;
        }
    }
    return num==0 ? 1 : 0;
}
