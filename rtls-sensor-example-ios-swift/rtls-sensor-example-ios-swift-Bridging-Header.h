//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <stdint.h>

#define COREAIOT_NUMBER_OF_SERVICE_UUIDS 13

uint16_t *coreaiot_generate_service_uuids(uint16_t id, uint8_t alarm,
                                          uint8_t battery);
