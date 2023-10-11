/// CF.BSP.CA.SignModelParam.js
var ClassName = "CF.BSP.CA.DTO.SignModel";
var init = function(){
	var SMCodeVal = $("#SMCode").val();
	var cfgJson = $("#SMCfgJson").val();
	if (cfgJson!="") {try{eval("cfgJson="+cfgJson);}catch(e){cfgJson="";}}
	if (cfgJson==""){
		cfgJson = {
			isHeaderMenuOpen:true,
			signUserType:"",
			notLoadCAJs:0,
			forceOpenSure:0 // UKEYSURELIST
		}
	}
	setValueById("notLoadCAJs",cfgJson.notLoadCAJs);
	setValueById("signUserType",cfgJson.signUserType);
	setValueById("isHeaderMenuOpen",cfgJson.isHeaderMenuOpen);
	setValueById("forceOpenSure",cfgJson.forceOpenSure);
	setValueById("isEnablePatientSign",cfgJson.isEnablePatientSign);
	$("#Save").click(function(){
		var data = {};
		var id = getValueById("SMID");
		if (id>0){
			$cm($.extend({
				ClassName:ClassName,
				MethodName:"Update",
				"dto.entiy.id":id,
				"dto.entiy.SMCfgJson":'{"notLoadCAJs":'+(getValueById("notLoadCAJs")?"1":"0")
				+',"signUserType":"'+getValueById("signUserType")+'\"'
				+',"isHeaderMenuOpen":'+getValueById("isHeaderMenuOpen")
				+',"forceOpenSure":'+(getValueById("forceOpenSure")?1:0)
				+',"isEnablePatientSign":'+getValueById("isEnablePatientSign")
				+"}"
			},data),defaultCallBack)
		}else{
			$.messager.popover({msg: 'È±Ê§ID',type:'alert',timeout: 2000});
			return ;
		}
	});
	$(window).on('beforeunload',function(){
		opener.$("#Find").click();
	});
	var SMDescVal = $("#SMDesc").val();
	$(".defaulttitle").text("¡¾"+SMDescVal+"¡¿CAÇ©Ãû²ÎÊýÅäÖÃ");
}
$(init);