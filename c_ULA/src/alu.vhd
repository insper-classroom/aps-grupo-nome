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

entity ALU is
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
end entity;

architecture  rtl OF ALU is

  component zerador16 IS
    port(z   : in STD_LOGIC;
         a   : in STD_LOGIC_VECTOR(15 downto 0);
         y   : out STD_LOGIC_VECTOR(15 downto 0)
    );
  end component;

  component inversor16 is
    port(z   : in STD_LOGIC;
         a   : in STD_LOGIC_VECTOR(15 downto 0);
         y   : out STD_LOGIC_VECTOR(15 downto 0)
    );
  end component;

  component Add16 is
    port(
      a   :  in STD_LOGIC_VECTOR(15 downto 0);
      b   :  in STD_LOGIC_VECTOR(15 downto 0);
      q   : out STD_LOGIC_VECTOR(15 downto 0)
    );
  end component;

  component And16 is
    port (
      a:   in  STD_LOGIC_VECTOR(15 downto 0);
      b:   in  STD_LOGIC_VECTOR(15 downto 0);
      q:   out STD_LOGIC_VECTOR(15 downto 0)
    );
  end component;

  component comparador16 is
    port(
      a   : in STD_LOGIC_VECTOR(15 downto 0);
      zr   : out STD_LOGIC;
      ng   : out STD_LOGIC
    );
  end component;

  component Mux16 is
    port (
      a:   in  STD_LOGIC_VECTOR(15 downto 0);
      b:   in  STD_LOGIC_VECTOR(15 downto 0);
      sel: in  STD_LOGIC;
      q:   out STD_LOGIC_VECTOR(15 downto 0)
    );
  end component;

  component barrelshifter16 is
    port (
      a:    in  STD_LOGIC_VECTOR(15 downto 0);
      dir:  in  std_logic;
      size: in  std_logic_vector(2 downto 0);
      q:    out STD_LOGIC_VECTOR(15 downto 0)
    );
  end component;

  SIGNAL zxout,zyout,nxout,nyout,andout,adderout,muxout,shift,precomp: std_logic_vector(15 downto 0);
  SIGNAL ov_int : std_logic;

begin

  U1: zerador16 port map(z => zx, a => x, y => zxout);
  U2: inversor16 port map(z => nx, a => zxout, y => nxout);
  U3: zerador16 port map(z => zy, a => y, y => zyout);
  U4: inversor16 port map(z => ny, a => zyout, y => nyout);
  U5: And16 port map(a => nxout, b => nyout, q => andout);

  U6: Add16 port map(a => nxout, b => nyout, q => adderout);
  -- overflow em soma de complemento de dois: só faz sentido quando f='1'
  ov_int <= ( (nxout(15) and nyout(15) and (not adderout(15))) or
              ((not nxout(15)) and (not nyout(15)) and adderout(15)) ) when f='1' else '0';

  U7: Mux16 port map(a => andout, b => adderout, sel => f, q => muxout);
  U8: barrelshifter16 port map(a => muxout, dir => direcao, size => size , q => shift);
  U9: inversor16 port map(z => no, a => shift, y => precomp);
  U10: comparador16 port map(a => precomp, zr => zr, ng => ng);

  saida <= precomp;
  overflow <= ov_int;

end architecture;
