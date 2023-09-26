
//名称	DHCPESendReportMessage.js
//功能	报告已完成
//组件  DHCPESendReportMessage	
//创建	2018.09.11
//创建人  xy

document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	var obj;   
	obj=document.getElementById("DoRegNo");
	if (obj){ obj.onkeydown=DoRegNo_keydown; }
	
	//查询
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }

	//撤销
	obj=document.getElementById("BCancelFetch");
	if (obj){ obj.onclick=BCancelFetch_click; }

	//发送短信
	obj=document.getElementById("BSendMessage");
	if (obj){ obj.onclick=BSendMessage_click; }
	
	obj=document.getElementById("BSaveContent");
	if (obj){ obj.onclick=BSaveContent_click; }
	
	obj=document.getElementById("GroupName");
	if (obj){ obj.onchange=GroupName_change; }
	
	initButtonWidth();
	
	websys_setfocus("DoRegNo"); 
	
	
}

function BCancelFetch_click()
{ 
    var objtbl = $("#tDHCPESendReportMessage").datagrid('getRows');
    if(selectrow=="-1"){
		alert("请选择待撤销的人");
		return false;
		}
	var ID=objtbl[selectrow].TID;
	if(ID==""){
		alert("请选择待撤销的人");
		return false;
		}
	obj=document.getElementById("CancelFetchClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID,"C");
	var Arr=ret.split("^")
	if (Arr[0]==0){
		alert("撤销成功")
		BFind_click();
	}else{
		alert(Arr[1])
	}
}

var selectrow=-1; 
function SelectRowHandler(index,rowdata) {
	
	
	var objtbl = $("#tDHCPESendReportMessage").datagrid('getRows');
    var rows=objtbl.length;
	selectrow=index;
	if(index==selectrow)
	{ 
 		
	}else
	{
		selectrow=-1;
		
	}


}

/*
function CancelFetch(e)
{
	var ID="";encmeth="",obj;
	ID=e.id;
	obj=document.getElementById("CancelFetchClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID,"C");
	var Arr=ret.split("^")
	if (Arr[0]==0){
		BFind_click();
	}else{
		alert(Arr[1])
	}
}
*/

function GroupName_change()
{
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
}
function SelectGroup(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=Arr[0];
}

function BFind_click(){
	
	
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=getValueById("DoRegNo");
	if (iRegNo.length<RegNoLength&&iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	
	iStartDate=getValueById("StartDate");
	
	iEndDate=getValueById("EndDate");
	
	iVIPLevel=getValueById("VIPLevel");
	
	iGroupID=getValueById("GroupID");
	
	iGroupName=getValueById("GroupName");
	
	iNoFetchReport=getValueById("NoFetchReport");
	if(iNoFetchReport){iNoFetchReport=1;}
	else{iNoFetchReport=0}
	
	iHadSendMessage=getValueById("HadSendMessage");
	if(iHadSendMessage){iHadSendMessage=1}
	else{iHadSendMessage=0}
	
	iIFOLD=getValueById("IFOLD");
	if(iIFOLD){iIFOLD=1}
	else{iIFOLD=0}
	
	
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPESendReportMessage"
			+"&StartDate="+iStartDate
			+"&EndDate="+iEndDate
			+"&RegNo="+iRegNo
			+"&NoFetchReport="+iNoFetchReport
			+"&HadSendMessage="+iHadSendMessage
			+"&IFOLD="+iIFOLD
			+"&VIPLevel="+iVIPLevel
			+"&GroupID="+iGroupID
			+"&GroupName="+iGroupName
			;
	
	location.href=lnk;
	

	
	}

function BSaveContent_click()
{
	var encmeth="",Content="";
	var Type="Report"
	var obj=document.getElementById("SaveContentClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("Content");
	if (obj) Content=obj.value;
	var ret=cspRunServerMethod(encmeth,Type,Content);
	alert("OVER");
}
function BSendMessage_click()
{
	
	var encmeth="";
	var Content="";
	var Type="RP"
	var obj=document.getElementById("SendMessageClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("Content");
	if (obj) Content=obj.value;

	 var objtbl = $("#tDHCPESendReportMessage").datagrid('getRows');
    var rows=objtbl.length;

	var ErrRows="";
	var NullTelRows="";
	var ErrTelRows="";
	for (var i=0;i<rows;i++)
	{
		var SendMessage=getCmpColumnValue(i,"TSendMessage","DHCPESendReportMessage")
		if (SendMessage=="1"){
			 var ID=objtbl[i].TID;
			 var RegNo=objtbl[i].TRegNo;
			 var TTel=objtbl[i].TTel;		   
			 trim(TTel);
			if (TTel==""){
				NullTelRows=NullTelRows+",第"+(i+1)+"行";
				continue;
			}
			if (!isMoveTel(TTel)){
				ErrTelRows=ErrTelRows+",第"+(i+1)+"行"; 
				continue;
			}
			
			var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+Content;
			
			var ret=cspRunServerMethod(encmeth,Type,InfoStr);
			
			if (ret!=0){
				ErrRows=ErrRows+",第"+(i+1)+"行";
			}else{
				 
				var obj=document.getElementById("TSendMessagez"+i);
				if (obj) obj.checked=false;
				var obj=document.getElementById("THadSendMessagez"+i);
				if (obj) obj.innerText="待发送";
			}
		}
	}
	if ((ErrRows!="")||(NullTelRows!="")||(ErrTelRows!="")){
		if (ErrRows!=""){$.messager.alert("提示","错误行: "+ErrRows,"info");}
		if (NullTelRows!=""){$.messager.alert("提示","电话号码为空的行: "+NullTelRows,"info");}
		if (ErrTelRows!=""){$.messager.alert("提示","电话号码错误的行: "+ErrTelRows,"info");}

	}else{
		BFind_click();
	}
	
}
function DoRegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		var obj=document.getElementById("DoRegNo");
		var encmeth="",RegNo="";
		if (obj) RegNo=obj.value;
		if (RegNo=="") return false;
		var obj=document.getElementById("FetchReportClass");
		if (obj) encmeth=obj.value;
		var ret=cspRunServerMethod(encmeth,RegNo,"C");
		var Arr=ret.split("^");
		if (Arr[0]!=0){
			alert(Arr[1]);
			return false;
		}
		//window.location.reload();
		BFind_click();
	}
}
function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
///判断移动电话
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^1(3|4|5|8)\d{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}