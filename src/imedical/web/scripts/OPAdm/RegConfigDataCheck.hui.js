$(function(){
	Init();
});
function Init(){
	$HUI.tabs("#config-tabs",{
		onSelect:function(title,index){
            var src="";
			if(title=="��Դ������"){
				src="opadm.resconfigdatacheck.hui.csp";
			}else if(title=="�������Ҽ�����"){
				src="alloc.exaborroomconfigdatacheck.hui.csp";
			}
            if(src!=""){
                src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
                $("iframe").attr("src",src);
            }
		}
	});
}