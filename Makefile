# Kastagne - build
#
#   make            build the SDL game (bin/kastagne) and the terminal version (bin/kastagne-txt)
#   make test       build and run the unit tests (pure game logic, no SDL needed)
#   make test-sdl   build the SDL smoke tests (need a display, an audio device and the assets)
#   make tools      build the hitbox viewer used to calibrate the sprite boxes
#   make docs       generate the Doxygen documentation in docs/api
#   make clean      remove build outputs

CXX      ?= g++
CXXFLAGS ?= -std=c++17 -Wall -g
CPPFLAGS += -Ilib -MMD -MP
SDL_LIBS  = -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer

BUILD = build
BIN   = bin

# Game logic: no SDL dependency
CORE_SRC = $(wildcard src/core/*/*.cpp) src/game/Game.cpp
# SDL front-end (rendering, input, audio)
SDL_SRC  = src/sdl/GameEngine.cpp src/sdl/SoundManager.cpp
# Terminal front-end (POSIX terminal)
TXT_SRC  = src/text/WinTxt.cpp

obj = $(patsubst %.cpp,$(BUILD)/%.o,$(1))
CORE_OBJ = $(call obj,$(CORE_SRC))
SDL_OBJ  = $(call obj,$(SDL_SRC))
TXT_OBJ  = $(call obj,$(TXT_SRC))

CORE_TESTS = Camera StateMachine Fighter Hud Stage Menu LoadingScene SelectScene BattleScene Game
TXT_TESTS  = WinTxt
SDL_TESTS  = GameEngine SoundManager
test_bin = $(addprefix $(BIN)/tests/test_,$(1))

.PHONY: all game game-txt test test-sdl tools docs clean

all: game game-txt

game: $(BIN)/kastagne
game-txt: $(BIN)/kastagne-txt

$(BIN)/kastagne: $(call obj,src/mainSDL.cpp) $(CORE_OBJ) $(SDL_OBJ)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(SDL_LIBS)

$(BIN)/kastagne-txt: $(call obj,src/mainTxt.cpp) $(TXT_OBJ)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $^ -o $@

# ---- Tests -----------------------------------------------------------------

test: $(call test_bin,$(CORE_TESTS) $(TXT_TESTS))
	@for t in $^; do echo "== $$t"; ./$$t || exit 1; done
	@echo "All tests passed."

test-sdl: $(call test_bin,$(SDL_TESTS))

$(call test_bin,$(CORE_TESTS)): $(BIN)/tests/test_%: $(BUILD)/tests/test_%.o $(CORE_OBJ)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $^ -o $@

$(call test_bin,$(TXT_TESTS)): $(BIN)/tests/test_%: $(BUILD)/tests/test_%.o $(TXT_OBJ)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $^ -o $@

$(call test_bin,$(SDL_TESTS)): $(BIN)/tests/test_%: $(BUILD)/tests/test_%.o $(CORE_OBJ) $(SDL_OBJ)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(SDL_LIBS)

# ---- Tools and docs --------------------------------------------------------

tools: $(BIN)/hitbox-viewer

$(BIN)/hitbox-viewer: $(BUILD)/tools/hitbox_viewer.o
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $^ -o $@ -lSDL2 -lSDL2_image

docs:
	doxygen docs/Doxyfile

# ---- Generic rules ---------------------------------------------------------

$(BUILD)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD) $(BIN) docs/api

-include $(shell find $(BUILD) -name '*.d' 2>/dev/null)
