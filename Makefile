#Grateful thanks to moonfruit, https://github.com/moonfruit/ethr.git
#Grateful thanks to lisaac, https://github.com/lisaac/luci-app-dockerman

include $(TOPDIR)/rules.mk

PKG_NAME:=ethr
PKG_VERSION:=1.0.0
PKG_MAINTAINER:=esirplayground <esirplayground@gmail.com>

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/esirplayground/ethr.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)

PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR)-$(PKG_SOURCE_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Network Measurement Tool for TCP, UDP & ICMP
	URL:=https://github.com/microsoft/ethr.git
	DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/$(PKG_NAME)/description
Microsoft ethr - A Comprehensive Network Measurement Tool for TCP, UDP & ICMP
endef

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/microsoft/ethr
GO_PKG_LDFLAGS:=-s -w

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/$(PKG_NAME)/config
config $(PKG_NAME)_INCLUDE_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config $(PKG_NAME)_INCLUDE_UPX
	bool "Compress executable files with UPX"
	default y
endef

ifeq ($(CONFIG_$(PKG_NAME)_INCLUDE_GOPROXY),y)
export GO111MODULE=on
export GOPROXY=https://goproxy.io
#export GGOPROXY=https://goproxy.baidu.com
endif

define Build/Prepare
	tar -xzvf $(DL_DIR)/$(PKG_SOURCE) -C $(BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(eval GO_PKG_BUILD_PKG:=$(GO_PKG))
	$(call GoPackage/Build/Configure)
	$(call GoPackage/Build/Compile)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/ethr $(1)/usr/bin/ethr
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call GoBinPackage,$(PKG_NAME)))
