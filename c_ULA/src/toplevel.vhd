--
-- Elementos de Sistemas - Aula 5 - Logica Combinacional
-- Rafael . Corsi @ insper . edu . br
--
-- Arquivo exemplo para acionar os LEDs e ler os bottoes
-- da placa DE0-CV utilizada no curso de elementos de
-- sistemas do 3s da eng. da computacao

----------------------------
-- Bibliotecas ieee       --
----------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------
-- Entrada e saidas do bloco
----------------------------
entity TopLevel is
	port(
		SW      : in  std_logic_vector(9 downto 0);
		LEDR    : out std_logic_vector(9 downto 0);
    HEX0     : out std_logic_vector(6 downto 0);
    HEX1     : out std_logic_vector(6 downto 0);
    HEX2     : out std_logic_vector(6 downto 0);
    HEX3     : out std_logic_vector(6 downto 0)

	);
end entity;

----------------------------
-- Implementacao do bloco --
----------------------------
architecture rtl of TopLevel is

--------------
-- signals
--------------

  signal x : std_logic_vector(15 downto 0) := x"0003"; 
  signal y : std_logic_vector(15 downto 0) := x"0005";
  signal saida: std_logic_vector(15 downto 0);
  signal overflow: std_logic; -- Sinal de Overflow


--------------
-- component
--------------
  component alu is
    port (
			x,y:   in STD_LOGIC_VECTOR(15 downto 0);
			zx:    in STD_LOGIC;
			nx:    in STD_LOGIC;
			zy:    in STD_LOGIC;
			ny:    in STD_LOGIC;
			f:     in STD_LOGIC;
			no:    in STD_LOGIC;
			zr:    out STD_LOGIC;
			ng:    out STD_LOGIC;
			saida: out STD_LOGIC_VECTOR(15 downto 0);
			overflow: out STD_LOGIC;
			direcao: in std_logic;
			size: in STD_LOGIC_VECTOR(2 downto 0)
	);
  end component;

  component sevenseg is
    port (
      bcd  : in  STD_LOGIC_VECTOR(3 downto 0);
      leds : out STD_LOGIC_VECTOR(6 downto 0)
  );
  end component;
  
---------------
-- implementacao
---------------
begin

  u1 : alu port map(x => x, y => y, zx => SW(0), nx => SW(1), zy => SW(2), ny => SW(3), f => SW(4), no => SW(5), zr => LEDR(1), ng => LEDR(2), saida => saida, overflow => LEDR(0), direcao => SW(6), size => SW(9 downto 7));
  d1 : sevenseg port map (bcd => saida (3 downto 0), leds => HEX0);
  d2 : sevenseg port map (bcd => saida (7 downto 4), leds => HEX1);
  d3 : sevenseg port map (bcd => saida (11 downto 8), leds => HEX2);
  d4 : sevenseg port map (bcd => saida (15 downto 12), leds => HEX3);
end rtl;
