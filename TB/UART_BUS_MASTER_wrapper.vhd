library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.pkgTYPEDEF.all;

entity UART_BUS_MASTER_wrapper is
    port(
    i_CLK           :in  std_logic;
    i_RST_p         :in  std_logic;
    i_UART_RX       :in  std_logic;
    o_UART_TX       :out std_logic
    );
end entity;

architecture RTL of UART_BUS_MASTER_wrapper is
    signal bus_cmd :typBusCommand;
    signal bus_ack :std_Logic_vector(BUS_DAT_WIDTH - 1 downto 0);
begin

u_UART_BUS_MASTER:entity work.UART_BUS_MASTER
port map
(i_CLK      =>i_CLK
,i_RST_p    =>i_RST_p
,i_UART_RX  =>i_UART_RX
,o_UART_TX  =>o_UART_TX
,o_BUS_CMD  =>bus_cmd
,i_BUS_ACK  =>bus_ack
);
u_LOCAL_BUS_REGISTER:entity work.LOCAL_BUS_REGISTER
generic map
(REG_ADDRESS_BASE =>x"A"
)port map
(i_CLK      =>i_CLK
,i_RST_p    =>i_RST_p
,i_BUS_CMD  =>bus_cmd
,o_BUS_ACK  =>bus_ack
);


end architecture;