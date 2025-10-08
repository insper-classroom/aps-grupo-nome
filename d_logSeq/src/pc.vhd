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



end architecture;





