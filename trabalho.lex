    //Código por: Gabriel Inagaki Marcelino e Luis Felipe Shimabucoro Furilli

CHAR [a-zA-Z]
NUM [0-9]
SIGN "+"|"-"|"*"|"/"|"%"
DSIGN "++"|"--"|"**"
EOU "&&"|"||"
VAR {CHAR}[_a-zA-Z0-9]*
INV {NUM}[_a-zA-Z]*
ATRIB =
SC ;
ABREPAR "("
FECHAPAR ")"
ABRECOL "["
FECHACOL "]"
ABRECHAVE "{"
FECHACHAVE "}"
COMP "<"|">"|"<="|">="|"=="|"!="
COMM ","|"."

%{
#include <stdio.h>
#include "parser.h"
%}

    //CHAR: caracteres de a até z e A até Z (CHARacter)
    //NUM: NUMeros de 0 até 9
    //SIGN: operadores matematicos (SIGNal)
    //DSIGN: operadores matematicos duplos, pra somatorio e etc
    //VAR: nomes de VARiáveis
    //INV: nomes INVálidos de variáveis
    //ATRIB: sinal de ATRIBuição
    //SC: SemiColon (ponto e vírgula)
    //ABRE/FECHA: Sinais que normalmente estão supostos a serem pareados com seus opostos
    //COMP: COMParadores
    //COMM: COMMa de vírgula, são separadores

%%

[ /t/n/r]
\n                  {num_linha++;}
for                 {printf("palavra reservada(%s)", yytext); return FOR;}
main                {printf("palavra reservada(%s)", yytext); return MAIN;}
if                  {printf("palavra reservada(%s)", yytext); return IF;}
else                {printf("palavra reservada(%s)", yytext); return ELSE;}
int                 {printf("int(%s)\n", yytext); return INT;}
float               {printf("float(%s)\n", yytext); return FLOAT;}
double              {printf("double(%s)\n", yytext); return DOUBLE;}
long                {printf("long(%s)\n", yytext); return LONG;}
{SC}                {printf("\tfim de linha(%s)\n", yytext); return SC;}
{ATRIB}             {printf(" equivale a(%s) ", yytext); return ATRIB;}
😋                  {printf("\nentrada invalida(%s) ", yytext); return INV;}
{VAR}               {printf("var(%s) ", yytext); return VAR;}
{COMP}              {printf("comparador(%s)", yytext); return COMP;}
{NUM}+              {printf("int(%s) ", yytext); return NUM;}
{NUM}+"."{NUM}+     {printf("float(%s) ", yytext); return NUM;}
{SIGN}              {printf(" operador(%s) ", yytext); return SIGN;}
{DSIGN}             {printf(" operador duplo(%s) ", yytext); return DSIGN;}
{ABREPAR}           {printf("abre parenteses(%s) ", yytext); return ABREPAR;}
{FECHAPAR}          {printf("fecha parenteses(%s) ", yytext); return FECHAPAR;}
{ABRECOL}           {printf("abre colchetes(%s) ", yytext); return ABRECOL;}
{FECHACOL}          {printf("fecha colchetes(%s) ", yytext); return FECHACOL;}
{ABRECHAVE}         {printf("abre chaves(%s) ", yytext); return ABRECHAVE;}
{FECHACHAVE}        {printf("fecha chaves(%s) ", yytext); return FECHACHAVE;}
{EOU}               {printf("e/ou(%s) ", yytext); return EOU;}
{COMM}              {printf(" separador(%s)", yytext); return COMM;}
{INV}               {printf("\nentrada invalida(%s) ", yytext); return INV;}
.                   {printf("\nentrada invalida(%s) ", yytext); return INV;}

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