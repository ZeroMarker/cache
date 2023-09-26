document.body.onload = DocumentLoadHandler;
var Selectedrow=0;
function DocumentLoadHandler()
{
	var obj;
	obj=document.getElementById("BSend");
	if (obj) obj.onclick=BSend_click;
	
}
function BSend_click()
{
	if (Selectedrow==0){
		alert("请选择待发送记录");
		return false;
	}
	var HandSend="未发送"
	var obj=document.getElementById("THadSendz"+Selectedrow);
	if (obj) HandSend=obj.innerText;
	if (HandSend=="已发送"){
		if (!confirm("病案已经发送过,是否再次发送")) return false;
	}
	var Name="";
	var obj=document.getElementById("TNamez"+Selectedrow);
	if (obj) Name=obj.innerText;
	if (!confirm("确实要发送'"+Name+"'的病历申请吗")) return false;
	var AdmID="";
	var obj=document.getElementById("TAdmIDz"+Selectedrow);
	if (obj) AdmID=obj.value;
	if (AdmID==""){
		alert("选择记录不正确,请重新选择");
		return false;
	}
	var ret=tkMakeServerCall("web.DHCOPSendMedicare","SendMedicare",AdmID);
	if (ret!=0){
		alert("发送申请失败");
	}else{
		alert("发送病历申请成功")
		location.reload();
	}
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOPSendMedicare');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (Selectedrow==selectrow){
		Selectedrow=0;
	}else{
		Selectedrow=selectrow;
	}
	
}