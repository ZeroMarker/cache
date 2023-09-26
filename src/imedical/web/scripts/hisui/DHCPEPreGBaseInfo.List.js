
//名称	DHCPEPreGBaseInfo.List.js
//功能	团体基本信息维护
//组件	DHCPEPreGBaseInfo.List 	
//创建	2018.10.09
//创建人  xy


function BodyLoadHandler() {
	var obj;
 
	obj=document.getElementById("BNew");
	if (obj){ obj.onclick=BNew_click; }
 	
}
function BNew_click(){
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreGBaseInfo.Edit";
	websys_lu(lnk,false,'width=800,height=335,hisui=true,title=团体基本信息维护')
	
	
}
document.body.onload = BodyLoadHandler;
