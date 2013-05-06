#include <GL/gl.h>
#include <GL/glut.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "tabuleiro.c"

void initlights(void)
{
    GLfloat ambient[]  = {0.2, 0.2, 0.2, 1.0};
    GLfloat position[] = {-0.25, -0.25, -40.0, 1.0};
    GLfloat mat_diffuse[]   = {1.0, 1.0, 1.0, 1.0};
    GLfloat mat_specular[]  = {1.0, 1.0, 1.0, 1.0};
    GLfloat mat_shininess[] = {25.0};

    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);

    glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
    glLightfv(GL_LIGHT0, GL_POSITION, position);

    glMaterialfv(GL_FRONT, GL_DIFFUSE, mat_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
}

void display(void)
{

    glCallList(theDrawTab);

    distribuiPecas();

    if ((pressed) && (buracoOrigem < 255)) {
       desenhaPecaMouse();
    }

    glutSwapBuffers();

}

void init (void) 
{

/*  create a display list to function desenhaTabuleiro        */
    theDrawTab = glGenLists(1);
    glNewList(theDrawTab, GL_COMPILE);
       desenhaTabuleiro();
    glEndList();

/*  select clearing (background) color       */
    glClearColor (0.0, 0.0, 0.0, 0.0);

/*  initialize viewing values  */
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    glEnable(GL_COLOR_MATERIAL);

    initlights();       /* for lighted version only */

}

/* 
 *  Declare initial window size, position, and display mode
 *  (single buffer and RGBA).  Open window with "hello"
 *  in its title bar.  Call initialization routines.
 *  Register callback function to display graphics.
 *  Enter main loop and process events.
 */

void MouseMove(int x,int y)
{

  if (jogando) {
     Xglobal = x;
     Yglobal = y;

     display();
  };

}

void MousePoint(int button, int state, int x, int y)
{
  unsigned char fdj;

  if (jogando) {
    switch(state) {
    case GLUT_UP :
       pressed = 0;
       if(buracoOrigem < 255) {
	  buracoDestino = indexBuracoDestino(x,y);
	  if(buracoDestino < 255) {
	     buracoPula = vizinhoOcupado(buracoDestino);
	     if(buracoPula < 255) {
	        tabuleiro[buracoOrigem].status = 0;
		tabuleiro[buracoPula].status = 0;
		tabuleiro[tabuleiro[buracoOrigem].jogadas2[buracoDestino]].status = 
1;
		npecas--;
		fdj = fimdejogo();
		if (fdj) {
  		   if (fdj == 1) {
		      fprintf(stderr, "VOCE VENCEU!!!\n\n");
		   }
		   else {
		      fprintf(stderr, "VOCE PERDEU COM %d PECAS!!!\n\n",npecas);
		   };
		   jogando = 0;
		};
	     }
	     else {
	        tabuleiro[buracoOrigem].status = 1;
	     };
	  }
	  else {
	     tabuleiro[buracoOrigem].status = 1;
	  };
       };

       buracoOrigem = 255;
       buracoPula = 255;
       buracoDestino = 255;
       break;
    case GLUT_DOWN :
       pressed = 1;
       Xglobal = x;
       Yglobal = y;

       buracoOrigem = indexSelecionada(x,y);
       if (buracoOrigem < 255) {
	  tabuleiro[buracoOrigem].status = 2;
       };

    }

    display();

  };

}

void Keyb(unsigned char key, int x, int y) {

   if (!jogando) {
      if (((key >= 49) && (key <= 55)) || (key == 27)) {
	 if ((key >= 49) && (key <= 55)) {
	    tabul_config = key - 48;
	    inicia_tabul(tabul_config);
	    jogando = 1;
	    display();
	 }
	 else
	    exit(0);
      };
   };

};

int main(int argc, char** argv)
{

    if (argc > 1) {
       tabul_config = escolheconfiguracao(argv[1]);
       if (tabul_config == 0) {
	  fprintf(stderr, "\nSyntax :\n   restaum <configuracao>\n            
cruz\n            mais\n            lareira\n            seta\n            
piramide\n            diamante\n            paciencia 
(default)\n\n\n");
	  return 0;
       };
    }
    else tabul_config = 7;
    jogando = 1;

    /* Inicializa parametros do jogo */
    inicia_tabul(tabul_config);

    /* Funcoes graficas e chamadas para o gerenciamento do jogo */
    glutInit(&argc, argv);
    glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize (500, 500); 
    glutInitWindowPosition (100, 100);
    glutCreateWindow ("Resta Um");
    init ();
    glutDisplayFunc(display);
    glutMotionFunc(MouseMove);
    glutMouseFunc(MousePoint);
    glutKeyboardFunc(Keyb);
    glutMainLoop();
    return 0;   /* ISO C requires main to return int. */
}



--------------------------------------------------------------------------------

/* Definindo a estrutura de dados Posicao */

typedef struct {
  unsigned char status; /* 0 : vazio;
                           1 : ocupado;
			   2 : sendo movido;  */
  unsigned char njogs;   // numero de buracos alcancaveis. Maximo : 4
  char jogadas1[4]; /* o valor i contem o indice do buraco naquela 
direcao
		      -1 significa que o buraco eh inacessivel
		      esta variavel controla se o buraco pulado contem
		      uma peca */
  char jogadas2[4]; /* o valor i contem o indice do buraco naquela 
direcao
		      -1 significa que o buraco eh inacessivel
		      esta variavel controla se a peca pode pular o buraco */
  float c_x,c_y;   /* centro do buraco no tabuleiro   */

} tpBuraco;

tpBuraco tabuleiro[33];
unsigned char buracoOrigem,buracoPula,buracoDestino;
unsigned char pressed;
GLuint theDrawTab;
int Xglobal,Yglobal;
unsigned char npecas;
unsigned char tabul_config;
unsigned char jogando;

/*

  O tabuleiro tem o seguinte formato:

         1 1 1
         1 1 1
     1 1 1 1 1 1 1
     1 1 1 0 1 1 1
     1 1 1 1 1 1 1
         1 1 1
         1 1 1

  As posicoes do tabuleiro estao mapeadas em TpTabul da seguinte forma:


           00  01  02
           03  04  05
   06  07  08  09  10  11  12
   13  14  15  16  17  18  19
   20  21  22  23  24  25  26
           27  28  29
	   30  31  32

*/

/* Funcoes graficas do jogo */

/* Desenha as pecas do jogo no ponto (x,y) da janela */
void desenhaPeca (float x, float y) {

  glColor3f(0.15, 0.0, 0.0);

  glLoadIdentity(); 
  glTranslatef(x, y, 0.0);
  glutSolidSphere(0.06,6,6);

};

/* Desenha as bases das pecas no tabuleiro */
void desenhaBasePeca (float x, float y) {

  glColor3f(0.20, 0.65, 0.0); // base das pecas

  glLoadIdentity(); 
  glTranslatef(x, y, 0.5);
  glutSolidSphere(0.09,6,6);
};

/* Desenha o tabuleiro com as pecas */
void desenhaTabuleiro () {
   int i;
   int WW,HH;
   float n_x,n_y;

   /* clear all pixels  */
   glClear (GL_COLOR_BUFFER_BIT);

   /* Desenha suporte */
   glColor3f(0.0, 0.15, 0.15);
   glLoadIdentity(); 
   glTranslatef(0.0, 0.0, 0.0);
   glRectf(-0.375,-0.9,0.375,0.9);
   glRectf(-0.9,-0.375,0.9,0.375);

   /* Desenha buracos */
   desenhaBasePeca(0.0,0.0);   desenhaBasePeca(0.0,0.25);
   desenhaBasePeca(0.0,0.5);   desenhaBasePeca(0.0,0.75);
   desenhaBasePeca(0.0,-0.25);   desenhaBasePeca(0.0,-0.5);
   desenhaBasePeca(0.0,-0.75);   desenhaBasePeca(0.25,0.0);
   desenhaBasePeca(0.25,0.25);   desenhaBasePeca(0.25,0.5);
   desenhaBasePeca(0.25,0.75);   desenhaBasePeca(0.25,-0.25);
   desenhaBasePeca(0.25,-0.5);   desenhaBasePeca(0.25,-0.75);
   desenhaBasePeca(0.5,0.0);   desenhaBasePeca(0.5,0.25);
   desenhaBasePeca(0.5,-0.25);   desenhaBasePeca(0.75,0.0);
   desenhaBasePeca(0.75,0.25);   desenhaBasePeca(0.75,-0.25);
   desenhaBasePeca(-0.25,0.0);   desenhaBasePeca(-0.25,0.25);
   desenhaBasePeca(-0.25,0.5);   desenhaBasePeca(-0.25,0.75);
   desenhaBasePeca(-0.25,-0.25);   desenhaBasePeca(-0.25,-0.5);
   desenhaBasePeca(-0.25,-0.75);   desenhaBasePeca(-0.5,0.0);
   desenhaBasePeca(-0.5,0.25);   desenhaBasePeca(-0.5,-0.25);
   desenhaBasePeca(-0.75,0.0);   desenhaBasePeca(-0.75,0.25);
   desenhaBasePeca(-0.75,-0.25);

};

/* Desenha pecas no tabuleiro */
void distribuiPecas() {
   int i;

   for(i = 0; i < 33;i++)
      if(tabuleiro[i].status == 1)
	 desenhaPeca(tabuleiro[i].c_x,tabuleiro[i].c_y);

};

/* Desenha a peca arrastada pelo mouse */
void desenhaPecaMouse() {
   int WW,HH;
   float n_x,n_y;

   WW = glutGet(GLUT_WINDOW_WIDTH);
   HH = glutGet(GLUT_WINDOW_HEIGHT);

   n_x = (2 * ((float) Xglobal) / WW) - 1.0;
   n_y = -((2 * ((float) Yglobal) / HH) - 1.0);

   desenhaPeca(n_x,n_y);

};

/* Escreve msg na janela */
void msg(float x, float y, char *text, unsigned char n) {
    char p;
    
    puts(text);
    glColor3f(1.0, 1.0, 1.0);
    glPushMatrix();
    glTranslatef(x, y, 1.0);
    for (p = 0; p < n; p++) {
        glutStrokeCharacter(GLUT_STROKE_ROMAN, text[p]);
    };
    glPopMatrix();

    glFlush();
}

/* Fim das funcoes graficas do jogo */

/* Funcoes para o gerenciamento do jogo */

/* Preenche dados de um buraco */
void preencheData(int i,unsigned char njogs,char j1,char j2,char 
j3,char j4,char k1,char k2,char k3,char k4,float c_x, float c_y) {

   tabuleiro[i].status = 0;
   tabuleiro[i].njogs = njogs;
   tabuleiro[i].jogadas1[0] = k1;
   tabuleiro[i].jogadas1[1] = k2;
   tabuleiro[i].jogadas1[2] = k3;
   tabuleiro[i].jogadas1[3] = k4;
   tabuleiro[i].jogadas2[0] = j1;
   tabuleiro[i].jogadas2[1] = j2;
   tabuleiro[i].jogadas2[2] = j3;
   tabuleiro[i].jogadas2[3] = j4;
   tabuleiro[i].c_x = c_x;
   tabuleiro[i].c_y = c_y;

};

/* Preenche status de cada buraco de acordo com o jogo escolhido */
void preencheStatus(unsigned char op) {
   int i;

   for(i = 0;i < 33;i++) {
      tabuleiro[i].status = 0;
   };

   switch(op) {
   case 1 : // Cruz
      tabuleiro[4].status = 1;  tabuleiro[8].status = 1;
      tabuleiro[9].status = 1;  tabuleiro[10].status = 1;
      tabuleiro[16].status = 1; tabuleiro[23].status = 1;
      npecas = 6;
      break;
   case 2 : // Mais
      tabuleiro[4].status = 1;  tabuleiro[9].status = 1;
      tabuleiro[14].status = 1; tabuleiro[15].status = 1;
      tabuleiro[16].status = 1; tabuleiro[17].status = 1;
      tabuleiro[18].status = 1; tabuleiro[23].status = 1;
      tabuleiro[28].status = 1;
      npecas = 9;
      break;
   case 3 : // Lareira
      tabuleiro[0].status = 1;  tabuleiro[1].status = 1;
      tabuleiro[2].status = 1;  tabuleiro[3].status = 1;
      tabuleiro[4].status = 1;  tabuleiro[5].status = 1;
      tabuleiro[8].status = 1;  tabuleiro[9].status = 1;
      tabuleiro[10].status = 1; tabuleiro[15].status = 1;
      tabuleiro[17].status = 1;
      npecas = 11;
      break;
   case 4 : // Seta
      tabuleiro[1].status = 1;  tabuleiro[3].status = 1;
      tabuleiro[4].status = 1;  tabuleiro[5].status = 1;
      tabuleiro[7].status = 1;  tabuleiro[8].status = 1;
      tabuleiro[9].status = 1;  tabuleiro[10].status = 1;
      tabuleiro[11].status = 1; tabuleiro[16].status = 1;
      tabuleiro[23].status = 1; tabuleiro[27].status = 1;
      tabuleiro[28].status = 1; tabuleiro[29].status = 1;
      tabuleiro[30].status = 1; tabuleiro[31].status = 1;
      tabuleiro[32].status = 1;
      npecas = 17;
      break;
   case 5 : // Piramide
      tabuleiro[4].status = 1;  tabuleiro[8].status = 1;
      tabuleiro[9].status = 1;  tabuleiro[10].status = 1;
      tabuleiro[14].status = 1; tabuleiro[15].status = 1;
      tabuleiro[16].status = 1; tabuleiro[17].status = 1;
      tabuleiro[18].status = 1; tabuleiro[20].status = 1;
      tabuleiro[21].status = 1; tabuleiro[22].status = 1;
      tabuleiro[23].status = 1; tabuleiro[24].status = 1;
      tabuleiro[25].status = 1; tabuleiro[26].status = 1;
      npecas = 16;
      break;
   case 6 : // Diamante
      for(i = 0;i < 33;i++) {
         tabuleiro[i].status = 1;
      };
      tabuleiro[0].status = 0;  tabuleiro[2].status = 0;
      tabuleiro[6].status = 0;  tabuleiro[12].status = 0;
      tabuleiro[16].status = 0; tabuleiro[20].status = 0;
      tabuleiro[26].status = 0; tabuleiro[30].status = 0;
      tabuleiro[32].status = 0;
      npecas = 24;
      break;
   case 7 : // Paciencia
      for(i = 0;i < 33;i++) {
         tabuleiro[i].status = 1;
      };
      tabuleiro[16].status = 0;
      npecas = 32;
      break;
   }

};

/* Inicializa o tabuleiro*/
void inicia_tabul(unsigned char op) {

   /* preenche os dados de cada buraco */
   preencheData(0,2,2,8,-1,-1,1,3,-1,-1,-0.25,0.75);
   preencheData(1,1,9,-1,-1,-1,4,-1,-1,-1,0.0,0.75);
   preencheData(2,2,0,10,-1,-1,1,5,-1,-1,0.25,0.75);
   preencheData(3,2,5,15,-1,-1,4,8,-1,-1,-0.25,0.5);
   preencheData(4,1,16,-1,-1,-1,9,-1,-1,-1,0.0,0.5);
   preencheData(5,2,3,17,-1,-1,4,10,-1,-1,0.25,0.5);
   preencheData(6,2,8,20,-1,-1,7,13,-1,-1,-0.75,0.25);
   preencheData(7,2,9,21,-1,-1,8,14,-1,-1,-0.5,0.25);
   preencheData(8,4,0,6,10,22,3,7,9,15,-0.25,0.25);
   preencheData(9,4,1,7,11,23,4,8,10,16,0.0,0.25);
   preencheData(10,4,2,8,12,24,5,9,11,17,0.25,0.25);
   preencheData(11,2,9,25,-1,-1,10,18,-1,-1,0.5,0.25);
   preencheData(12,2,10,26,-1,-1,11,19,-1,-1,0.75,0.25);
   preencheData(13,1,15,-1,-1,-1,14,-1,-1,-1,-0.75,0.0);
   preencheData(14,1,16,-1,-1,-1,15,-1,-1,-1,-0.5,0.0);
   preencheData(15,4,3,13,17,27,8,14,16,22,-0.25,0.0);
   preencheData(16,4,4,14,18,28,9,15,17,23,0.0,0.0);
   preencheData(17,4,5,15,19,29,10,16,18,24,0.25,0.0);
   preencheData(18,1,16,-1,-1,-1,17,-1,-1,-1,0.5,0.0);
   preencheData(19,1,17,-1,-1,-1,18,-1,-1,-1,0.75,0.0);
   preencheData(20,2,6,22,-1,-1,13,21,-1,-1,-0.75,-0.25);
   preencheData(21,2,7,23,-1,-1,14,22,-1,-1,-0.5,-0.25);
   preencheData(22,4,8,20,24,30,15,21,23,27,-0.25,-0.25);
   preencheData(23,4,9,21,25,31,16,22,24,28,0.0,-0.25);
   preencheData(24,4,10,22,26,32,17,23,25,29,0.25,-0.25);
   preencheData(25,2,11,23,-1,-1,18,24,-1,-1,0.5,-0.25);
   preencheData(26,2,12,24,-1,-1,19,25,-1,-1,0.75,-0.25);
   preencheData(27,2,15,29,-1,-1,22,28,-1,-1,-0.25,-0.5);
   preencheData(28,1,16,-1,-1,-1,23,-1,-1,-1,0.0,-0.5);
   preencheData(29,2,17,27,-1,-1,24,28,-1,-1,0.25,-0.5);
   preencheData(30,2,22,32,-1,-1,27,31,-1,-1,-0.25,-0.75);
   preencheData(31,1,23,-1,-1,-1,28,-1,-1,-1,0.0,-0.75);
   preencheData(32,2,24,30,-1,-1,29,31,-1,-1,0.25,-0.75);

   /* Preenche o status inicial de cada buraco - depende do jogo 
escolhido  */
   
   preencheStatus(op);

   /* Inicializa variaveis */
   pressed = 0;
   buracoOrigem = 255;
   buracoPula = 255;
   buracoDestino = 255;
};

/* Calcula a distancia entre o ponteiro do mouse e o centro de cada 
buraco
   Devolve o indice para a peca selecionada,
   ou 255 se nenhuma foi selecionada */
unsigned char indexSelecionada(int x,int y) {

   unsigned char c = 255;
   unsigned char i;
   float minDist = 2.1;
   float Dist;
   int WW,HH;
   float n_x,n_y;


   WW = glutGet(GLUT_WINDOW_WIDTH);
   HH = glutGet(GLUT_WINDOW_HEIGHT);
   n_x = (2 * ((float) x) / WW) - 1.0;
   n_y = -((2 * ((float) y) / HH) - 1.0);

   for(i = 0;i < 33;i++) {
      Dist = sqrt(pow((n_x - tabuleiro[i].c_x),2.0) + pow((n_y - 
tabuleiro[i].c_y),2.0));
      if ((Dist < minDist) && (Dist < 0.09)) {
	 minDist = Dist;
	 c = i;
      };
   };

   if (c < 255)
      if (tabuleiro[c].status != 1)
	 c = 255;

   return c;
};

/* Calcula a distancia entre o ponteiro do mouse e o centro de cada 
buraco
   alcancavel pela peca em buracoOrigm
   Devolve o indice para o buraco escolhido
   ou 255 se nenhum foi selecionada */
unsigned char indexBuracoDestino(int x,int y) {

   unsigned char c;
   unsigned char i,kk,jj;
   float minDist;
   float Dist;
   int WW,HH;
   float n_x,n_y;
   unsigned char njogs;


   WW = glutGet(GLUT_WINDOW_WIDTH);
   HH = glutGet(GLUT_WINDOW_HEIGHT);
   n_x = (2 * ((float) x) / WW) - 1.0;
   n_y = -((2 * ((float) y) / HH) - 1.0);

   njogs = tabuleiro[buracoOrigem].njogs;
   minDist = 2.1;
   for(i = 0;i < njogs;i++) {
      kk = tabuleiro[buracoOrigem].jogadas2[i];
      Dist = sqrt(pow((n_x - tabuleiro[kk].c_x),2.0) + pow((n_y - 
tabuleiro[kk].c_y),2.0));
      if ((Dist < minDist) && (Dist < 0.09)) {
	 minDist = Dist;
	 c = i;
	 jj = kk;
      };
   };

   /* verifica se o buraco c nao estah ocupado. Se estiver, devolve 255 
*/
   if ((tabuleiro[jj].status != 0) || (minDist > 0.09))
      c = 255;

   return c;
};

/* Verifica se o buraco adjacente na direcao que a peca pulou esta 
ocupada */
unsigned char vizinhoOcupado(unsigned char i) {

   char j;

   j = tabuleiro[buracoOrigem].jogadas1[i];

   if (tabuleiro[j].status == 1)
      return j;
   else
      return 255;
};

/* Verifica se eh fim de jogo
   retorna : 
         0 : o jogo nao acabou
	 1 : o jogo acabou e o jogador venceu
	 2 : o jogo acabou e o jogador perdeu
*/
unsigned char fimdejogo() {

   unsigned char i,j,k;
   unsigned char njogs;
   unsigned bur1,bur2;

   if (npecas == 1)
      return 1;

   k = 0;
   i = 0;
   while ((i < 33) && (k == 0)) {
      if (tabuleiro[i].status == 1) { 
	 njogs = tabuleiro[i].njogs;
	 for(j = 0; j < njogs; j++) {
	    bur1 = tabuleiro[tabuleiro[i].jogadas1[j]].status;
	    bur2 = 1 - tabuleiro[tabuleiro[i].jogadas2[j]].status;
	    if ((bur1) && (bur2))
	       k++;
	 };
      };
      i++;
   };

   if (k)
      return 0;
   else
      return 2;

};

/* Verifica nome do tabuleiro e devolve codigo para configuracao */
unsigned char escolheconfiguracao(char *strr) {

   if (strcmp(strr,"help") == 0)
      return 0;
   if (strcmp(strr,"cruz") == 0)
      return 1;
   if (strcmp(strr,"mais") == 0)
      return 2;
   if (strcmp(strr,"lareira") == 0)
      return 3;
   if (strcmp(strr,"seta") == 0)
      return 4;
   if (strcmp(strr,"piramide") == 0)
      return 5;
   if (strcmp(strr,"diamante") == 0)
      return 6;

   return 7;

};

/* Fim das funcoes para o gerenciamento do jogo */

