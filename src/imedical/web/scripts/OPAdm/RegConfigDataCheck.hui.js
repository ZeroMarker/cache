$(function(){
	Init();
});
function Init(){
	$HUI.tabs("#config-tabs",{
		onSelect:function(title,index){
			if(title=="资源监测情况"){
				$("iframe").attr("src","opadm.resconfigdatacheck.hui.csp");
			}else if(title=="诊区诊室监测情况"){
				$("iframe").attr("src","alloc.exaborroomconfigdatacheck.hui.csp");
			}
		}
	});
}