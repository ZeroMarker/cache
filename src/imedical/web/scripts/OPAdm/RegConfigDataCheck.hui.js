$(function(){
	Init();
});
function Init(){
	$HUI.tabs("#config-tabs",{
		onSelect:function(title,index){
            var src="";
			if(title=="资源监测情况"){
				src="opadm.resconfigdatacheck.hui.csp";
			}else if(title=="诊区诊室监测情况"){
				src="alloc.exaborroomconfigdatacheck.hui.csp";
			}
            if(src!=""){
                src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
                $("iframe").attr("src",src);
            }
		}
	});
}