################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../ACTION_Module.cpp \
../AI_Module.cpp \
../cam_Module.cpp \
../doLocalPlan.cpp \
../main.cpp \
../net_Layer.cpp \
../shared_Data.cpp 

OBJS += \
./ACTION_Module.o \
./AI_Module.o \
./cam_Module.o \
./doLocalPlan.o \
./main.o \
./net_Layer.o \
./shared_Data.o 

CPP_DEPS += \
./ACTION_Module.d \
./AI_Module.d \
./cam_Module.d \
./doLocalPlan.d \
./main.d \
./net_Layer.d \
./shared_Data.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -I/usr/include/opencv -O0 -g3 -Wall -c -fmessage-length=0 -pthread -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


