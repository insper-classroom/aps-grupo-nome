-- Elementos de Sistemas
-- by Luciano Soares
-- ALU.vhd

-- Unidade Lógica Aritmética (ULA)
-- Recebe dois valores de 16bits e
-- calcula uma das seguintes funções:
-- X+y, x-y, y-x, 0, 1, -1, x, y, -x, -y,
-- X+1, y+1, x-1, y-1, x&y, x|y
-- De acordo com os 6 bits de entrada denotados:
-- zx, nx, zy, ny, f, no.
-- Também calcula duas saídas de 1 bit:
-- Se a saída == 0, zr é definida como 1, senão 0;
-- Se a saída <0, ng é definida como 1, senão 0.
-- a ULA opera sobre os valores, da seguinte forma:
-- se (zx == 1) então x = 0
-- se (nx == 1) então x =! X
-- se (zy == 1) então y = 0
-- se (ny == 1) então y =! Y
-- se (f == 1) então saída = x + y
-- se (f == 0) então saída = x & y
-- se (no == 1) então saída = !saída
-- se (out == 0) então zr = 1
-- se (out <0) então ng = 1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
	port (
			x,y:   in STD_LOGIC_VECTOR(15 downto 0); -- entradas de dados da ALU
			zx:    in STD_LOGIC;                     -- zera a entrada x
			nx:    in STD_LOGIC;                     -- inverte a entrada x
			zy:    in STD_LOGIC;                     -- zera a entrada y
			ny:    in STD_LOGIC;                     -- inverte a entrada y
			f:     in STD_LOGIC;                     -- se 0 calcula x & y, senão x + y
			no:    in STD_LOGIC;                     -- inverte o valor da saída
			zr:    out STD_LOGIC;                    -- setado se saída igual a zero
			ng:    out STD_LOGIC;                    -- setado se saída é negativa
			saida: out STD_LOGIC_VECTOR(15 downto 0) -- saída de dados da ALU
	);
end entity;

architecture rtl of ALU is
  signal x0, x1, y0, y1   : STD_LOGIC_VECTOR(15 downto 0);
  signal and_out, add_out : STD_LOGIC_VECTOR(15 downto 0);
  signal f_out, out_pre   : STD_LOGIC_VECTOR(15 downto 0);
begin
  x0 <= (others => '0') when zx = '1' else x;
  y0 <= (others => '0') when zy = '1' else y;

  x1 <= not x0 when nx = '1' else x0;
  y1 <= not y0 when ny = '1' else y0;

  and_out <= x1 and y1;
  add_out <= std_logic_vector(unsigned(x1) + unsigned(y1));

  f_out <= and_out when f = '0' else add_out;

  out_pre <= not f_out when no = '1' else f_out;

  saida <= out_pre;
  zr    <= '1' when out_pre = (out_pre'range => '0') else '0';
  ng    <= out_pre(15);
end architecture;
