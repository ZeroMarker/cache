document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	var obj;   
	obj=document.getElementById("DoRegNo");
	if (obj){ obj.onkeydown=DoRegNo_keydown; }
	var obj=document.getElementById("AutoSend");
	if (obj.checked)
	{
		websys_setfocus("DoRegNo"); 
	}
	obj=document.getElementById("GDesc");
	if (obj) obj.onchange=GDesc_change;
}
function GDesc_change()
{
	var obj=document.getElementById("GID");
	if (obj) obj.value="";
}
function AfterSelectGroup(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	
	var obj=document.getElementById("GID");
	if (obj) obj.value=Arr[1];
}
function CacleSendAudit()
{
	//alert("hello");
	var eSrc=window.event.srcElement;
	var UserID=session['LOGON.USERID'];
	//alert(eSrc.id)
	if (!confirm("您即将取消粘贴！是否继续？")) return false;
	var Ret=tkMakeServerCall("web.DHCPE.FetchReport","CacleSendAudit",eSrc.id);
	//alert('a')
	if (Ret=="0")
	{
		BFind_click();
		return false;
	}
	alert("取消失败"+Ret+"");



}
function SendAudit()
{
	var eSrc=window.event.srcElement;
	var UserID=session['LOGON.USERID'];
	var obj=document.getElementById("SendAuditClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,"",UserID,"0",eSrc.id);
	//alert("ret:"+ret)
	var Arr=ret.split("^");
	if (Arr[0]=="0"){
		BFind_click();
		return false;
	}
	if (Arr[0]=="-2")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="此人已经收表"+EnterKey;
		if (Arr[1]!=""){
			AlertInfo=AlertInfo+"未完成项目:"+Arr[1]+EnterKey+"是否继续操作";
		}else{
			AlertInfo=AlertInfo+"是否继续操作";
		}
		if (!confirm(AlertInfo)) return false;
	}
	if (Arr[0]=="-3")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="未完成项目:"+Arr[1]+EnterKey+"是否继续操作";
		if (!confirm(AlertInfo)) return false;
	}
	var ret=cspRunServerMethod(encmeth,"",UserID,"1",eSrc.id);
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		alert(Arr[1]);
		return false;
	}
	BFind_click();
}
function DoRegNo_keydown(e)
{
	var Key=websys_getKey(e);
	
	if ((9==Key)||(13==Key)) {
		var obj=document.getElementById("DoRegNo");
		var encmeth="",RegNo="";
		if (obj) { 
			RegNo=obj.value;
		if(RegNo!="") {
			RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
			obj.value=RegNo;
		 }
		}
		if (RegNo=="") return false;
		//BFind_click();
		//return false;
		
		var obj=document.getElementById("AutoSend");
			if (obj&&obj.checked)  {
				
			var UserID=session['LOGON.USERID'];
			var obj=document.getElementById("SendAuditClass");
			if (obj) encmeth=obj.value;
			var ret=cspRunServerMethod(encmeth,RegNo,UserID,"","");
			var Arr=ret.split("^");
			if (Arr[0]=="0"){
				BFind_click();
				return false;
			}
			if (Arr[0]=="-1")
			{
				alert(Arr[1]);
				return false;
			}
			if (Arr[0]=="-2")
			{
				var EnterKey=String.fromCharCode(13);
				var AlertInfo="此人已经收表"+EnterKey;
				if (Arr[1]!=""){
					AlertInfo=AlertInfo+"未完成项目:"+Arr[1]+EnterKey+"是否继续操作";
				}else{
					AlertInfo=AlertInfo+"是否继续操作";
				}
				if (!confirm(AlertInfo)) return false;
			}
			if (Arr[0]=="-3")
			{
				var EnterKey=String.fromCharCode(13);
				var AlertInfo=Arr[1]+EnterKey+"是否继续操作";
				if (!confirm(AlertInfo)) return false;
			}
			var ret=cspRunServerMethod(encmeth,RegNo,UserID,"1","");
			var Arr=ret.split("^");
			if (Arr[0]!="0"){
				alert(Arr[1]);
				return false;
			}
			BFind_click();
		}
		else{
			//40689111
			return;
			var tobj=document.getElementById('tDHCPESendAudit')
			if (tobj) { var rows=tobj.rows.length; }
			if (rows<2){return false;}
			else {
					
			var obj=document.getElementById("TPAADMz1")	
			if (obj) var PaAdm=obj.value;
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPENewDiagnosis"
			+"&EpisodeID="+PaAdm
			+"&OnlyRead=Y"
			;
			var wwidth=800;
			var wheight=600;
			var xposition = (screen.width - wwidth) / 2;
			var yposition = (screen.height - wheight) / 2;
			var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
			window.open(lnk,"_blank",nwin)	
			}			
		}
		
	}
}