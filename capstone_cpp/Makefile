

CC=/usr/bin/g++
FLAGS += -lpthread -lopencv_core -lopencv_highgui -L/usr/lib/uv4l/uv4lext/armv6l -luv4lext -Wl,-rpath,'/usr/lib/uv4l/uv4lext/armv6l'

BUILDDIR = bin/

SRC = main.cpp \
	ACTION_Module.cpp \
	AI_Module.cpp \
	cam_Module.cpp \
	doLocalPlan.cpp \
	shared_Data.cpp \
	net_Layer.cpp

OUT = ai

OBJ = ${SRC:.cpp=.o}

all: $(OUT)

$(OUT): $(OBJ)
	mkdir -p $(BUILDDIR)
	$(CC) $(FLAGS) -o $(BUILDDIR)$(OUT) $(OBJ)
	
clean:
	rm -fr $(BUILDDIR) \
		*.o \
		*.?! \
	
