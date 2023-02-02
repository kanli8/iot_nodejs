idf_component_register(SRCS "main.c"
                    "component/uart/uart_p.c"

                    "component/wifi/wifi_main.c"
                    "component/wifi/wifi_prov.c"
                    "component/wifi/wifi_prov_handlers.c"

                    "component/websocket/p_websocket.c"
                    
                    "component/eventloop/eventloop.c"

                    "component/sys/sys.c"
                    "component/util/util.c"
                    INCLUDE_DIRS ".")


