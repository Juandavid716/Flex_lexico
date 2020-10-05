let	[A-Za-z]
dig	[0-9]
digs	{dig}+
id	({let}|"_")({let}|{dig}|"_")*

%{   
    #include<stdio.h>
%}

%%

{id} {printf("esto es una id");}
"+" {printf("signo suma");}
%%
int main()
{
    yyin = fopen( "texto.txt", "r" );
    yylex();
    return 0;
}