$(function(){
	Init();
});
function Init(){
	$HUI.tabs("#config-tabs",{
		onSelect:function(title,index){
            var src="";
			if(index==0){
				src="opadm.dhcopregpowerconfig.hui.csp";
			}else if(index==1){
				src="opadm.dhcopschedulepowerconfig.hui.csp";
			}else if(index==2){
				src="opadm.dhcoprespowerconfig.hui.csp";
			}else if(index==3){
				src="opadm.dhcopregsetconfig.hui.csp";
			}
            if(src!=""){
                src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
                $("iframe").attr("src",src);
            }
		}
	});
}