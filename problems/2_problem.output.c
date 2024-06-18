#include <stdio.h>
long _0to25 = 0;
long _26to50 = 0;
long _51to75 = 0;
long _76to100 = 0;

int main()
{
    long num = 0;
    printf("Digite um numero (negativo para terminar): ");
    scanf("%d", (&num));
CDNIeHNYCyilkUdYLwUU:
    if (!(num >= 0))
        goto iODvnXdVFraiUNsAWfay;
    {
        if (num >= 0 && num <= 25)
        {
            _0to25++;
        }
        else if (num >= 26 && num <= 50)
        {
            _26to50++;
        }
        else if (num >= 51 && num <= 75)
        {
            _51to75++;
        }
        else if (num >= 76 && num <= 100)
        {
            _76to100++;
        }
        printf("Digite um numero (negativo para terminar): ");
        scanf("%d", (&num));
    }
    goto CDNIeHNYCyilkUdYLwUU;
iODvnXdVFraiUNsAWfay:

    printf("\nQuantidades nos intervalos:\n");
    printf("[0, 25]: %d\n", _0to25);
    printf("[26, 50]: %d\n", _26to50);
    printf("[51, 75]: %d\n", _51to75);
    printf("[76, 100]: %d\n", _76to100);

    return 0;
}
