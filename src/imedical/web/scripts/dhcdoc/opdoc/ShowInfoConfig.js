var opl=opdoc.lib.ns("opdoc.recadm.config");
opl.view=(function(){
	function Init(){
		$HUI.tabs("#config-tabs",{
			onSelect:function(title,index){
				var TokenParam=(typeof websys_getMWToken=='function')?("?MWToken="+websys_getMWToken()):"";
				if(title=="������Ϣչʾ"){
					$("iframe").attr("src","opdoc.patientinfoconfig.csp"+TokenParam);
				}else if(title=="����������Ϣչʾ"){
					//$("iframe").attr("src","opdoc.streamlineconfig.csp");
					$("iframe").attr("src","opdoc.workflow.config.csp"+TokenParam);
				}else if(title=="���﹦������ť����"){
					//$("iframe").attr("src","opdoc.treatstatusconfigmain.csp");
					$("iframe").attr("src","dhcdoc.config.btnbar.csp"+TokenParam);
				}else if(title=="��ӡĿ¼��Ϣ����"){
					$("iframe").attr("src","opdoc.treatprintmainconfig.csp"+TokenParam);
				}else if(title=="���Ӳ�����Ϣ����"){
					$("iframe").attr("src","opdoc.emrshowinfoconfig.csp"+TokenParam);
				}
			}
		});
	}
	return {
		"Init":Init
	}
})();