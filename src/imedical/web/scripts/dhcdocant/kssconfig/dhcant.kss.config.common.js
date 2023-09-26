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
			}
			if (type=="SMANYCONSULT") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="SMANYCONSULT";
			}
			if (type=="PSTATUS") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="PSTATUS";
			}
			if (type=="LABWAY") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="LABWAY";
			}
			if (type=="FUNCFG") {
				obj.defaultType="CFGPARA";
				obj.defaultParCode="FUNCFG";
			}
			if (type=="NOAUTHDOC") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="NOAUTHDOC";
			}
			if (type=="SUPERPARA") {
				obj.defaultType="SUPERPARA";
				obj.defaultParCode="PARA";
			}
			if (type=="BASECFG") {
				obj.defaultType="BASEPARA";
				obj.defaultParCode="BASECFG";
			}
			if (type=="PTYPE") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="PTYPE";
			}
			if (type=="CONDOCGRADE") {
				obj.defaultType="MINIPARAMATER";
				obj.defaultParCode="CONDOCGRADE";
			}
			return true;
		}
	});	
})(window);