#ifndef _COMPILER_H_
#define _COMPILER_H_

#include "opcode.h"

#define CODE  struct MinCode *code

struct MinCode *min_compiler(const char *filename);
void min_compiler_finish(CODE);
void min_compiler_dump(CODE);

void min_compile_lit(CODE, OBJ lit);
void min_compile_call(CODE, OBJ msg);
void min_compile_return(CODE);

#endif /* _COMPILER_H_ */