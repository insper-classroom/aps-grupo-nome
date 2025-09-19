library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity barrelshifter16 is
  port (
    a:    in  STD_LOGIC_VECTOR(15 downto 0);   -- input vector
    dir:  in  std_logic;                       -- 0=>left 1=>right
    size: in  std_logic_vector(2 downto 0);    -- shift amount
    q:    out STD_LOGIC_VECTOR(15 downto 0)    -- output vector (shifted)
  );
end entity;

architecture rtl of barrelshifter16 is
  signal s1, s2, s4, s8 : STD_LOGIC_VECTOR(15 downto 0);
begin
  s1 <= a(14 downto 0) & '0' when dir='0' else
        '0' & a(15 downto 1);

  s2 <= s1(13 downto 0) & "00" when dir='0' else
        "00" & s1(15 downto 2);

  s4 <= s2(11 downto 0) & x"0" when dir='0' else
        x"0" & s2(15 downto 4);

  s8 <= s4(7 downto 0) & x"00" when dir='0' else
        x"00" & s4(15 downto 8);

  q <= a  when size = "000" else
       s1 when size = "001" else
       s2 when size = "010" else
       s2 when size = "011" else
       s4 when size = "100" else
       s4 when size = "101" else
       s4 when size = "110" else
       s8;  -- "111"
end architecture;
