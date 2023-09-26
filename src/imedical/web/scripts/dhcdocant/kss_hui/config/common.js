/**
 * dhcant.kss.config.common.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-06-26
 * 
 */
(function(window, undefined){
	var DHCANTConfig = {};
	window.DHCANTConfig = DHCANTConfig;
	$.extend(DHCANTConfig, {
		setDefaultType: function (obj,type) {
			if (type=="PARAMATER") {
				obj.defaultType="PARAMATER";
				obj.defaultParCode="PARA";
			} else if (type=="SMANYCONSULT") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="SMANYCONSULT";
			} else if (type=="PSTATUS") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="PSTATUS";
			} else if (type=="LABWAY") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="LABWAY";
			} else if (type=="FUNCFG") {
				obj.defaultType="CFGPARA";
				obj.defaultParCode="FUNCFG";
			} else if (type=="NOAUTHDOC") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="NOAUTHDOC";
			} else if (type=="SUPERPARA") {
				obj.defaultType="SUPERPARA";
				obj.defaultParCode="PARA";
			} else if (type=="BASECFG") {
				obj.defaultType="BASEPARA";
				obj.defaultParCode="BASECFG";
			} else if (type=="PTYPE") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="PTYPE";
			} else if (type=="CONDOCGRADE") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="CONDOCGRADE";
			} else {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode=type;
			}
			return true;
		}
	});	
})(window);