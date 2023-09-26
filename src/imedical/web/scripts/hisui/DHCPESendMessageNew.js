var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BSend");
	if (obj) obj.onclick=BSend_click;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	obj=document.getElementById("HighRisk");
	if (obj){
		obj.onchange=HighRisk_onchange;
		obj.ondblclick=HighRisk_dblclick;
	}
}
function HighRisk_dblclick()
{
	var OrderItemID="",RealPAADM="";
	var obj=document.getElementById("OrderItemID");
	if (obj) OrderItemID=obj.value;
	var obj=document.getElementById("RealPAADM");
	if (obj) RealPAADM=obj.value;
	if ((OrderItemID=="")&&(RealPAADM=="")) return false;
	var url='websys.lookup.csp';
	url += "?ID=&CONTEXT=K"+"web.DHCPE.SendMessage:FindAdviceByOrder";
	url += "&P1="+websys_escape(OrderItemID);
	url += "&P2="+websys_escape(RealPAADM);
	url += "&TLUJSF=SetHighRiskInfo";
	websys_lu(url,1,'');
	return websys_cancel();
}
function SetHighRiskInfo(value)
{
	if (value=="") return false;
	obj=document.getElementById("HighRisk");
	if (obj) obj.value=value;
	HighRisk_onchange();
}
function HighRisk_onchange()
{
	var eSrc=document.getElementById("HighRisk");
	var HighRisk=eSrc.value;
	var obj=document.getElementById("TContent");
	var Content=obj.value;
	var Arr=Content.split("[");
	var Info1=Arr[0]
	var Content=Arr[1];
	var Arr=Content.split("]");
	var Info2=Arr[1];
	obj.value=Info1+"["+HighRisk+"]"+Info2;
}
function BSave_click(AlertFlag)
{
	var PAADM="",OrderItemID="",Detail="",encmeth="",ID="",obj;
	obj=document.getElementById("PAADM");
	if (obj) PAADM=obj.value;
	obj=document.getElementById("OrderItemID");
	if (obj) OrderItemID=obj.value;
	obj=document.getElementById("HighRisk");
	if (obj) 
	{
		Detail=obj.value;
       if(Detail==""){
			alert("高危信息不能为空")
			websys_setfocus("HighRisk");
			return false;
       }
		
	}
	var Str=PAADM+"^"+OrderItemID+"^"+Detail;
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	
	obj=document.getElementById("SaveHighRiskClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID,Str);
	if (ret>0){
		obj=document.getElementById("ID");
		if (obj) obj.value=ID;
		if (AlertFlag!=0){
			window.location.reload();
		}
	}else{
		messageShow("","","",ret)
	}
	return ret;
}
function BSend_click()
{
	var ID=BSave_click(0);
	var encmeth="",TTel="",MessageTemplate="";
	var obj=document.getElementById("SendMessageClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	var obj=document.getElementById("TTel");
	if (obj) TTel=obj.value;
	trim(TTel)
	if (TTel==""){
		alert("手机号码不能为空");
		return false;
	}
	if (!isMoveTel(TTel)){
		alert("手机号码不正确");
		return false;
	}
	var obj=document.getElementById("TContent");
	if (obj) 
	{ 
		MessageTemplate=obj.value;
	 	if(MessageTemplate==""){
			alert("短信内容不能为空")
			websys_setfocus("TContent");
			return false;
       }
	}

	
	var Arr=MessageTemplate.split("[");
	if (Arr.length>1){
		var Info1=Arr[0]
		var Content=Arr[1];
		var Arr=Content.split("]");
		var Info2=Arr[1];
	
		MessageTemplate=Info1+"["+Arr[0]+"]"+Info2;
	}
	
	var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
	var Type="HR"; //FreeSend
	var ret=cspRunServerMethod(encmeth,Type,InfoStr);
	if (ret!=0){
		alert("发送错误"+ret)
		return false;
	}else{
		var AllID=ID+"^HR";
		//messageShow("","","",AllID)
		var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveOtherRecord",AllID);
	
	}

	window.location.reload();
}
function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
///判断移动电话
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^0{0,1}13|15|18[0-9]{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPESendMessageNew');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var TabObj,obj;
	TabObj=document.getElementById("TSendFlagz"+selectrow);
	if (TabObj&&TabObj.checked) return false;
	TabObj=document.getElementById("TOrderItemIDz"+selectrow);
	if (TabObj){
		obj=document.getElementById("OrderItemID");
		if (obj){
			if (obj.value!=TabObj.value) return false;
		}
	}
	TabObj=document.getElementById("TIDz"+selectrow);
	obj=document.getElementById("ID");
	if (TabObj&&obj) obj.value=TabObj.value;
	TabObj=document.getElementById("TDetailz"+selectrow);
	obj=document.getElementById("HighRisk");
	if (TabObj&&obj) obj.value=TabObj.innerText;
}
document.body.onload = BodyLoadHandler;