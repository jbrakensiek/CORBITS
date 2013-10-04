#include "corbits.h"
#include <cstdio>
#include <cassert>

bool read(FILE* fin, int &len, input_orbit io[]) {
  for (len = 0; ; len++) {
    int a = fscanf (fin, "%lE,%lE,%lE,%lE,%lE,%lE,%lE,%d", &io[len].a,
	    &io[len].r_star, &io[len].r, &io[len].e,
	    &io[len].Omega, &io[len].omega, &io[len].i,
	    &io[len].use);
    if (a == EOF) {
      return true;
    }
    else if (a == NFIELDS) {
      if (len >= MAX) {
	fprintf (stderr, "Error: Exceeded limit of %d planets.\n", MAX);
	return false;
      }
    }
    else {
      fprintf (stderr, "Error: Unable to parse row %d\n", len);
      return false;
    }
  }
}

int main(int argc, char **argv) {
  if (argc != 1) {
    fprintf (stderr, "Error: Too many arguments.\n");
    return 1;
  }

  int len = 0;
  input_orbit io[MAX];

  if (!read(stdin, len, io)) {
    return -1;
  }
  
  sci_value prob = prob_of_transits_input_orbit(len, io);
  
  printf ("Probability: %e\n", prob.val);
  printf ("Positive Error: %e\n", prob.pos_err);
  printf ("Negative Error: %e\n", prob.neg_err);

  return 0;
}
