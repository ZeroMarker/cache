var opl=opdoc.lib.ns("opdoc.recadm.config");
opl.view=(function(){
	function Init(){
		$HUI.tabs("#config-tabs",{
			onSelect:function(title,index){
				if(title=="������Ϣչʾ"){
					$("iframe").attr("src","opdoc.patientinfoconfig.csp");
				}else if(title=="����������Ϣչʾ"){
					$("iframe").attr("src","opdoc.streamlineconfig.csp");
				}else if(title=="���﹦������ť����"){
					$("iframe").attr("src","opdoc.treatstatusconfigmain.csp");
				}else if(title=="��ӡĿ¼��Ϣ����"){
					$("iframe").attr("src","opdoc.treatprintmainconfig.csp");
				}else if(title=="���Ӳ�����Ϣ����"){
					$("iframe").attr("src","opdoc.emrshowinfoconfig.csp");
				}
			}
		});
	}
	return {
		"Init":Init
	}
})();