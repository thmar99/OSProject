ASM=nasm

SRC_DIR=src
BUILD_DIR=build

#Ensure build directory exists
#$(BUILD_DIR):
#	makdir -p $(Build_DIR)
																	# Setup for the img file
$(BUILD_DIR)/main.img: $(BUILD_DIR)/main.bin						# We're making a rule for the build/main.img item, requiring main.bin to work (will be created from asembly file)
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/main.img					# we're going to copy the items from main.bin to main.img
	truncate -s 1440k $(BUILD_DIR)/main.img							# to fill a random disk to 1.4MB of required size to be a valid disk, we truncate 1440K into the image object

																	# Setup for the bin file
$(BUILD_DIR)/main.bin: $(SRC_DIR)/main.s							# To get the binfile based on the main.s file
	$(ASM) $(SRC_DIR)/main.s -f bin -o $(BUILD_DIR)/main.bin		# Build a bin file from main.s with NASM and paste it to main.bin
