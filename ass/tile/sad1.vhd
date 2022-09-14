process(clk,reset) is
begin
    if(reset='1')then
        i_PM_pixel   <= (others => '0');
        i_PM_x_dest  <= (others => '0');
        i_PM_y_dest  <= (others => '0');
        i_PM_step    <= (others => '0');
        i_PM_frame   <= (others => '0');
        i_PM_x_orig  <= (others => '0');
        i_PM_y_orig  <= (others => '0');
        i_PM_fb      <= '0';  
        i_PM_req <= '0';
        oc_PM_ack <= '0';
        mode <= 0;
    elsif(rising_edge(clk))then
        case mode is
            when 0 =>
                if(oc_PM_new_msg='1')then
                    if(i_PM_ack='0' and i_PM_req='0')then
                        i_PM_pixel   <= oc_PM_pixel ;
                        i_PM_x_dest  <= oc_PM_x_dest;
                        i_PM_y_dest  <= oc_PM_y_dest;
                        i_PM_step    <= oc_PM_step  ;
                        i_PM_frame   <= oc_PM_frame ;
                        i_PM_x_orig  <= oc_PM_x_orig;
                        i_PM_y_orig  <= oc_PM_y_orig;
                        i_PM_fb      <= oc_PM_fb    ;
                        i_PM_req     <= '1';
                        oc_PM_ack    <='1';
                        mode <= 1;
                    end if;
                end if;
             when 1 =>
                if(i_PM_ack='1' )then 
                 i_PM_req <= '0';
                 aux1<='1';
              end if;
   
              if(oc_PM_new_msg='0')then
                oc_PM_ack<='0';
                 aux2<='1';

              end if;
              
              if(aux1='1' and aux2 ='1')then 
              mode<=0;
                aux1<='0';
               aux2<='0';
              end if;
            when others =>
        
        end case;
        end if;


end process;