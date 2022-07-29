#include <stdint.h>
#include <stdbool.h>


//este é o riscv_1 (manda mensagem)

#define getvalue 0x0000000E
#define write_op 0x00000001
#define read_op  0x00000010


#define reg_leds (*(volatile uint32_t*)0x03000000)

#define riscv_read (*(volatile uint32_t*)0x04000000)
#define riscv_write (*(volatile uint32_t*)0x05000000)


#define data (*(volatile uint32_t*)0x00010000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)


void send_message(uint32_t x);
void read_message(void);
void putchar(char c);
void print(const char *p);
void print_dec(uint32_t v);

void main(){
reg_uart_clkdiv=868;

data=0;
while(1)
{
data=0;
send_message(data);
print_dec(data);
for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);

data=15;
send_message(data);
print_dec(data);

for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);
}
//return 0;
}
void send_message(uint32_t x)
{
    riscv_write = x<<1;
    x = x | write_op;
}
void read_message(void)
{
    data = riscv_read>>1;
}

void putchar(char c)
{
	if (c == '\n')
		putchar('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchar(*(p++));
}

void print_dec(uint32_t v)
{

	if      (v >= 900) { putchar('9'); v -= 900; }
	else if (v >= 800) { putchar('8'); v -= 800; }
	else if (v >= 700) { putchar('7'); v -= 700; }
	else if (v >= 600) { putchar('6'); v -= 600; }
	else if (v >= 500) { putchar('5'); v -= 500; }
	else if (v >= 400) { putchar('4'); v -= 400; }
	else if (v >= 300) { putchar('3'); v -= 300; }
	else if (v >= 200) { putchar('2'); v -= 200; }
	else if (v >= 100) { putchar('1'); v -= 100; }

	if      (v >= 90) { putchar('9'); v -= 90; }
	else if (v >= 80) { putchar('8'); v -= 80; }
	else if (v >= 70) { putchar('7'); v -= 70; }
	else if (v >= 60) { putchar('6'); v -= 60; }
	else if (v >= 50) { putchar('5'); v -= 50; }
	else if (v >= 40) { putchar('4'); v -= 40; }
	else if (v >= 30) { putchar('3'); v -= 30; }
	else if (v >= 20) { putchar('2'); v -= 20; }
	else if (v >= 10) { putchar('1'); v -= 10; }

	if      (v >= 9) { putchar('9'); v -= 9; }
	else if (v >= 8) { putchar('8'); v -= 8; }
	else if (v >= 7) { putchar('7'); v -= 7; }
	else if (v >= 6) { putchar('6'); v -= 6; }
	else if (v >= 5) { putchar('5'); v -= 5; }
	else if (v >= 4) { putchar('4'); v -= 4; }
	else if (v >= 3) { putchar('3'); v -= 3; }
	else if (v >= 2) { putchar('2'); v -= 2; }
	else if (v >= 1) { putchar('1'); v -= 1; }
	else putchar('0');
}

