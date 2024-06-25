#define BUF_SZ 50
static char buf[BUF_SZ];
const char *d_to_s(double v){snprintf(buf, BUF_SZ, "%f", v);return buf;}
const char *b_to_s(int v){return v ? "true" : "false";}
const char *i_to_s(long v){snprintf(buf, BUF_SZ, "%ld", v);return buf;}
const char *c_to_s(char v){snprintf(buf, BUF_SZ, "%c", v);return buf;}
//essa lib não será importada no compilador e, 
//mas sim colada no inicio do codigo compilado 
//caso haja necessidade de coersão de algum tipo primitivo para string