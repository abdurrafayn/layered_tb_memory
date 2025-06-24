package typedefs;
//SystemVerilog: User-defined data types using enumerations
// ALU Operations
typedef enum logic [2:0] {HLT, SKZ, ADD, AND, XOR, LDA, STO, JMP} opcode_t;
endpackage : typedefs

