$(function(){
	Init();
});
function Init(){
	$HUI.tabs("#config-tabs",{
		onSelect:function(title,index){
			if(title=="��Դ������"){
				$("iframe").attr("src","opadm.resconfigdatacheck.hui.csp");
			}else if(title=="�������Ҽ�����"){
				$("iframe").attr("src","alloc.exaborroomconfigdatacheck.hui.csp");
			}
		}
	});
}