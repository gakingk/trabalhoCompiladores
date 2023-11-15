    //Código por: Gabriel Inagaki Marcelino e Luis Felipe Shimabucoro Furilli

CHAR [a-zA-Z]
NUM [0-9]
SIGN "+"|"-"|"*"|"/"|"%"
VAR {CHAR}[_a-zA-Z0-9]*
INV {NUM}[_a-zA-Z]*
ATRIB =
SC ;
PAR "]"|"["|")"|"("|"}"|"{"
COMP "<"|">"|"<="|">="|"=="|"!="
COMM ","|"."

%{
#include <stdio.h>
%}

    //CHAR: caracteres de a até z e A até Z (CHARacter)
    //NUM: NUMeros de 0 até 9
    //SIGN: operadores matematicos (SIGNal)
    //VAR: nomes de VARiáveis
    //INV: nomes INVálidos de variáveis
    //ATRIB: sinal de ATRIBuição
    //SC: SemiColon (ponto e vírgula)
    //PAR: Sinais que normalmente estão supostos a serem PAReados com seus semelhantes
    //COMP: COMParadores
    //COMM: COMMa de vírgula, são separadores

%%

[ /t/n/r]
for                 {printf("palavra reservada(%s)", yytext);}
int                 {printf("palavra reservada(%s)", yytext);}
main                {printf("palavra reservada(%s)", yytext);}
float               {printf("palavra reservada(%s)", yytext);}
if                  {printf("palavra reservada(%s)", yytext);}
{SC}                {printf("\tfim de linha(%s)\n", yytext);}
{ATRIB}             {printf(" equivale a(%s) ", yytext);}
😋                  {printf("\nentrada invalida(%s) ", yytext);}
{VAR}               {printf("var(%s) ", yytext);}
{COMP}              {printf("comparador(%s)", yytext);}
{NUM}+              {printf("int(%s) ", yytext);}
{NUM}+"."{NUM}+     {printf("float(%s) ", yytext);}
{SIGN}              {printf(" operador(%s) ", yytext);}
{PAR}               {printf("par(%s) ", yytext);}
{COMM}              {printf(" separador(%s)", yytext);}
{INV}               {printf("\nentrada invalida(%s) ", yytext);}
.                   {printf("\nentrada invalida(%s) ", yytext);}

%%

    //[ /t/n/r]+: pra conseguir separar as palavras com /n
    //for;int;float;main: alguns exemplos de palavras reservadas
    //o + em {NUM}+ é pra aceitar números com mais de uma casa decimal
    //o . em {NUM}+"."{NUM}+ é pra simular um float
    //.+ é pra caso a entrada nao se encaixe em nenhum dos casos

int yywrap(){}
FILE *teste;
int main(){
    teste = fopen("teste.txt", "r");
    if (!teste){
        printf("Não foi possível abrir o arquivo");
        return -1;
    }
    yyin = teste;
  
    while(yylex());
    fclose(teste);
    printf("\n\n");

system("pause");
return(0);
}

    //yywrap: função que consolida as regras postas acima
    //yyin = teste: fazendo a entrada pro yylex ser o texto do arquivo
    //yylex(): função que chama as regras consolidadas