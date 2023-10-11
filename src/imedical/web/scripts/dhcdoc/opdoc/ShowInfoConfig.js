var opl=opdoc.lib.ns("opdoc.recadm.config");
opl.view=(function(){
	function Init(){
		$HUI.tabs("#config-tabs",{
			onSelect:function(title,index){
				var TokenParam=(typeof websys_getMWToken=='function')?("?MWToken="+websys_getMWToken()):"";
				if(title=="患者信息展示"){
					$("iframe").attr("src","opdoc.patientinfoconfig.csp"+TokenParam);
				}else if(title=="门诊流程信息展示"){
					//$("iframe").attr("src","opdoc.streamlineconfig.csp");
					$("iframe").attr("src","opdoc.workflow.config.csp"+TokenParam);
				}else if(title=="门诊功能区按钮配置"){
					//$("iframe").attr("src","opdoc.treatstatusconfigmain.csp");
					$("iframe").attr("src","dhcdoc.config.btnbar.csp"+TokenParam);
				}else if(title=="打印目录信息配置"){
					$("iframe").attr("src","opdoc.treatprintmainconfig.csp"+TokenParam);
				}else if(title=="电子病历信息配置"){
					$("iframe").attr("src","opdoc.emrshowinfoconfig.csp"+TokenParam);
				}
			}
		});
	}
	return {
		"Init":Init
	}
})();