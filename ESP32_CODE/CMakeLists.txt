set(srcs "mqtt_handler.c" 
        "globals.c" 
        "rtmp_handler.c" 
        "rtmp_app_setting.c" 
        "main.c" 
        "rtmp_push_app.c" 
        "gw_modem.c" 
        "rfid_handler.c")
idf_component_register(SRCS ${srcs}
                    INCLUDE_DIRS include
                    EMBED_TXTFILES server_cert.pem)