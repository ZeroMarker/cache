$(function(){
	Init();
});
function Init(){
	$HUI.tabs("#config-tabs",{
		onSelect:function(title,index){
			if(index==0){
				$("iframe").attr("src","opadm.dhcopregpowerconfig.hui.csp");
			}else if(index==1){
				$("iframe").attr("src","opadm.dhcopschedulepowerconfig.hui.csp");
			}else if(index==2){
				$("iframe").attr("src","opadm.dhcoprespowerconfig.hui.csp");
			}
		}
	});
}