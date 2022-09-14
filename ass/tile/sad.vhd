process(clk,reset) is
begin
    if(reset='1')then
        signal_i_PM_pixel   <= (others => '0');
        signal_i_PM_x_dest  <= (others => '0');
        signal_i_PM_y_dest  <= (others => '0');
        signal_i_PM_step    <= (others => '0');
        signal_i_PM_frame   <= (others => '0');
        signal_i_PM_x_orig  <= (others => '0');
        signal_i_PM_y_orig  <= (others => '0');
        signal_i_PM_fb      <= '0';  
        signal_i_PM_req <= '0';
        input_ack <= '0';
        mode_router <= forward;

    elsif(rising_edge(clk))then
        case mode_router is
            when forward =>
                if(signal_t_PM_req='1')then

                            signal_i_PM_pixel      <= (others => '0');
                            signal_i_PM_x_dest     <= (others => '0');
                            signal_i_PM_y_dest     <= (others => '0');
                            signal_i_PM_step       <= (others => '0');
                            signal_i_PM_frame      <= (others => '0');
                            signal_i_PM_x_orig     <= (others => '0');
                            signal_i_PM_y_orig     <= (others => '0');
                            signal_i_PM_fb         <= '0';
                            signal_i_PM_req        <= '0';
                            input_ack              <= '1';                           
                            addra<= '0' & signal_t_PM_y_dest;                                               
                            mode_router<=normal_mode;
                end if;
             
             
                    
             when normal_mode =>
             if(signal_i_PM_ack='0' and signal_t_PM_req='0')then
                          if(doa_ok='1')then
                                signal_i_PM_pixel<=doa;
                                signal_i_PM_x_dest <=  signal_t_PM_x_dest ;
                                signal_i_PM_y_dest <=  signal_t_PM_y_dest ;
                                signal_i_PM_step   <=  signal_t_PM_step   ;
                                signal_i_PM_frame  <=  signal_t_PM_frame  ;
                                signal_i_PM_x_orig <=  signal_t_PM_x_orig ;
                                signal_i_PM_y_orig <=  signal_t_PM_y_orig ;
                                signal_i_PM_fb<='1';      
                               -- ena<='0';          
                                signal_i_PM_req        <= '1';
                                input_ack              <= '1';                                  
                                mode_router<=handshake;                        
                          end if;
              end if;    
               

                
             when handshake =>
             if(output_ack='1')then
                    signal_i_PM_pixel      <= (others => '0');
                    signal_i_PM_x_dest     <= (others => '0');
                    signal_i_PM_y_dest     <= (others => '0');
                    signal_i_PM_step       <= (others => '0');
                    signal_i_PM_frame      <= (others => '0');
                    signal_i_PM_x_orig     <= (others => '0');
                    signal_i_PM_y_orig     <= (others => '0');
                    signal_i_PM_fb         <= '0';
                    signal_i_PM_req        <= '0';
                    input_ack              <='0';
                    mode_router            <= forward;
            end if;
                    
            when others =>
            
        end case;
    end if;

end process;
  