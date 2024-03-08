#
# Cross Platform Makefile
# Compatible with MSYS2/MINGW, Ubuntu 14.04.1 and Mac OS X
#
# You will need GLFW (http://www.glfw.org):
# debian linux:
#   apt-get install libglfw-dev
# manjaro linux:
#   pamac install glfw-x11
# Mac OS X:
#   brew install glfw
# MSYS2:
#   pacman -S --noconfirm --needed mingw-w64-x86_64-toolchain mingw-w64-x86_64-glfw
#

CXX = aarch64-linux-gnu-g++

# expected compiler aarch64-linux-gnu-g++

EXE = loadTester
IMGUI_DIR = imgui
TP_DIR = thread_pool
ENDLESS_TH_M_DIR = endlessThMngr
AARCH64_INCLUDE_DIR = aarch64_lib_include

SOURCES = main.cpp K3Buffer.cpp K3Proc.cpp K3Key.cpp imgui_thread.cpp
SOURCES += $(TP_DIR)/thread_pool.cpp
SOURCES += $(ENDLESS_TH_M_DIR)/endless_th_manager.cpp
SOURCES += $(IMGUI_DIR)/imgui.cpp $(IMGUI_DIR)/imgui_demo.cpp $(IMGUI_DIR)/imgui_draw.cpp $(IMGUI_DIR)/imgui_tables.cpp $(IMGUI_DIR)/imgui_widgets.cpp
SOURCES += $(IMGUI_DIR)/backends/imgui_impl_glfw.cpp $(IMGUI_DIR)/backends/imgui_impl_opengl2.cpp
OBJS = $(addsuffix .o, $(basename $(notdir $(SOURCES))))
UNAME_S := $(shell uname -s)

CXXFLAGS = -std=c++14 -pthread -I$(IMGUI_DIR) -I$(IMGUI_DIR)/backends -I$(IMGUI_DIR)/include -I$(TP_DIR) -I$(ENDLESS_TH_M_DIR) -I$(AARCH64_INCLUDE_DIR)
CXXFLAGS += -g -Wall -Wformat

# another possible flag -mfpu=neon-fp-armv8
AARCH64_CXXFLAGS = -march=armv8-a -Wl,--verbose
# --verbose
# -z nodefaultlib Specify that the dynamic loader search for dependencies of this object should ignore any default library search paths. This means it will not use those on the target when running the application.
# 
AARCH64_LD_FLAGS = -A elf64-little -Bstatic -L./libs_aarch64 -L./libs_aarch64/libXCB -lm -lc -lstdc++ -lglfw3 -lGL -lXxf86vm -lglapi -ldrm -lX11 -lxcb-glx -lxcb -lX11-xcb -lxcb-dri2 -lXext -lXfixes -lXxf86vm -lxcb-shm -lxcb-dri3 -lxcb-present -lxcb-sync -lxshmfence -lxcb-xfixes -lexpat -lXau -lXdmcp -Wl,-rpath,./usr/lib -l:libc.so.6 -l:libstdc++.so.6 --verbose

CXXFLAGS += $(AARCH64_CXXFLAGS)
CFLAGS = $(CXXFLAGS)

MESSAGE = $(EXE) built for AARCH64

##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------

%.o:%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o:$(IMGUI_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o:$(IMGUI_DIR)/backends/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o:$(TP_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o:$(ENDLESS_TH_M_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

all: $(EXE)
	@echo $(MESSAGE)

$(EXE): $(OBJS)
	$(CXX) -o $@ $^ $(AARCH64_LD_FLAGS)

clean:
	rm -f $(OBJS)

clobber:
	rm -f $(EXE)
