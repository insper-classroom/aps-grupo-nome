-- Elementos de Sistemas
-- developed by Luciano Soares
-- file: PC.vhd
-- date: 4/4/2017

-- Contador de 16bits
-- if (reset[t] == 1) out[t+1] = 0
-- else if (load[t] == 1)  out[t+1] = in[t]
-- else if (inc[t] == 1) out[t+1] = out[t] + 1
-- else out[t+1] = out[t]

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity PC is
    port(
        clock     : in  STD_LOGIC;
        increment : in  STD_LOGIC;
        load      : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        input     : in  STD_LOGIC_VECTOR(15 downto 0);
        output    : out STD_LOGIC_VECTOR(15 downto 0) 
    );
end entity;

architecture arch of PC is

  signal muxOut     : std_logic_vector(15 downto 0);
  signal muxin0     : std_logic_vector(15 downto 0);
  signal outputReg  : std_logic_vector(15 downto 0);
  signal load_reg   : std_logic;
  signal sel_mux    : std_logic;

  signal inc_out    : std_logic_vector(15 downto 0); -- output do inc16
  signal after_inc  : std_logic_vector(15 downto 0); -- resultado do mux de incremento
  signal after_load : std_logic_vector(15 downto 0); -- resultado do mux de load
  signal next_value : std_logic_vector(15 downto 0); -- valor que vai para o registrador

  component Inc16 is
      port(
          a   :  in STD_LOGIC_VECTOR(15 downto 0);
          q   : out STD_LOGIC_VECTOR(15 downto 0)
          );
  end component;

  component Register16 is
      port(
          clock:   in STD_LOGIC;
          input:   in STD_LOGIC_VECTOR(15 downto 0);
          load:    in STD_LOGIC;
          output: out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component Mux16 is
		port (
			a:   in STD_LOGIC_VECTOR(15 downto 0);
			b:   in STD_LOGIC_VECTOR(15 downto 0);
			sel: in  STD_LOGIC;
			q:   out STD_LOGIC_VECTOR(15 downto 0)
            );
	end component;


  signal ZERO16 : std_logic_vector(15 downto 0) := (others => '0');

begin

  -- 1 Inc16: inc_out = outputReg + 1
  INC : Inc16
    port map(
      a => outputReg,
      q => inc_out
    );

  -- 2 Mux de incremento: after_inc = (increment='1') ? inc_out : outputReg
  MUX_INC : Mux16
    port map(
      a   => outputReg,
      b   => inc_out,
      sel => increment,
      q   => after_inc
    );

  -- 3 Mux de load: after_load = (load='1') ? input : after_inc
  MUX_LOAD : Mux16
    port map(
      a   => after_inc,
      b   => input,
      sel => load,
      q   => after_load
    );

  -- 4 Mux de reset: next_value = (reset='1') ? ZERO16 : after_load
  MUX_RESET : Mux16
    port map(
      a   => after_load,
      b   => ZERO16,
      sel => reset,
      q   => next_value
    );

  -- 5 Registrador: carrega next_value a cada clock.
  --    Aqui assumimos que o Register16 aceita load='1' para sempre carregar.
  REG : Register16
    port map(
      clock  => clock,
      input  => next_value,
      load   => '1',
      output => outputReg
    );

  -- Saída do PC
  output <= outputReg;

end architecture;

