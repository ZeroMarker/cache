
//����	DHCPEPreGBaseInfo.List.js
//����	���������Ϣά��
//���	DHCPEPreGBaseInfo.List 	
//����	2018.10.09
//������  xy


function BodyLoadHandler() {
	var obj;
 
	obj=document.getElementById("BNew");
	if (obj){ obj.onclick=BNew_click; }
 	
}
function BNew_click(){
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreGBaseInfo.Edit";
	websys_lu(lnk,false,'width=800,height=335,hisui=true,title=���������Ϣά��')
	
	
}
document.body.onload = BodyLoadHandler;
