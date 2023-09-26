document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	var obj;   
	obj=document.getElementById("DoRegNo");
	if (obj){ obj.onkeydown=DoRegNo_keydown; }
	
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	
	
	obj=document.getElementById("BSendMessage");
	if (obj){ obj.onclick=BSendMessage_click; }
	obj=document.getElementById("BSaveContent");
	if (obj){ obj.onclick=BSaveContent_click; }
	//alert('sz')
	obj=document.getElementById("GroupName");
	if (obj){ obj.onchange=GroupName_change; }
	websys_setfocus("DoRegNo"); 
}
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
/*
function BFind_click(){
	
	
	var obj;
	var iRegNo="";
	var iStartDate="";
	var iEndDate="";
	var iNoFetchReport="";
	var iHadSendMessage="";
	var iIFOLD=""
	var iVIPLevel=""
	
	obj=document.getElementById("DoRegNo");
	if (obj){ 
		iRegNo=obj.value;
		//if (iRegNo.length<8 && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo); }
	}
	//alert(iRegNo)
	obj=document.getElementById("StartDate");
	if (obj){ iStartDate=obj.value; }
	
	
	obj=document.getElementById("EndDate");
	if (obj){ iEndDate=obj.value; }
	
	
	obj=document.getElementById("NoFetchReport");
	if (obj){ iNoFetchReport=obj.value; }
	
	
	obj=document.getElementById("HadSendMessage");
	if (obj){ iHadSendMessage=obj.value; }
	
	
	obj=document.getElementById("IFOLD");
	if (obj && obj.checked) {iIFOLD="Y"}
	else {iIFOLD="N"}
	//alert(iIFOLD)
	
	obj=document.getElementById("VIPLevel");
	if (obj){ iVIPLevel=obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESendReportMessage"
			+"&StartDate="+iStartDate
			+"&EndDate="+iEndDate
			+"&RegNo="+iRegNo
			+"&NoFetchReport="+iNoFetchReport
			+"&HadSendMessage="+iHadSendMessage
			+"&IFOLD="+iIFOLD
			+"&VIPLevel="+iVIPLevel+""
			;
	
	location.href=lnk;
	
	
	
	
	
	//alert('sa')
	var obj=document.getElementById("Content");
	obj.innerText="aa"
	
	}
*/
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
	//alert('d')
	var encmeth="";
	var Content="";
	var Type="RP"
	var obj=document.getElementById("SendMessageClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("Content");
	if (obj) Content=obj.value;
	var objtbl=document.getElementById('tDHCPESendReportMessage');	//取表格元素?名称
	var rows=objtbl.rows.length;
	var ErrRows="";
	var NullTelRows="";
	var ErrTelRows="";
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSendMessagez"+i);
		if (obj&&obj.checked){
			var obj=document.getElementById("TIDz"+i);
			if (obj) var ID=obj.value;
			var obj=document.getElementById("TRegNoz"+i);
			if (obj) var RegNo=obj.innerText;
			var obj=document.getElementById("TTelz"+i);
			if (obj) var TTel=obj.value;
			trim(TTel)
			if (TTel==""){
				NullTelRows=NullTelRows+"^"+i;
				continue;
			}
			if (!isMoveTel(TTel)){
				ErrTelRows=ErrTelRows+"^"+i;
				continue;
			}
			//alert(ID)
			var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+Content;
			
			var ret=cspRunServerMethod(encmeth,Type,InfoStr);
			if (ret!=0){
				ErrRows=ErrRows+"^"+i;
			}else{
				var obj=document.getElementById("TSendMessagez"+i);
				if (obj) obj.checked=false;
				var obj=document.getElementById("THadSendMessagez"+i);
				if (obj) obj.innerText="待发送";
			}
		}
	}
	if ((ErrRows!="")||(NullTelRows!="")||(ErrTelRows!="")){
		if (ErrRows!="")alert("错误行号:"+ErrRows);
		if (NullTelRows!="")alert("电话为空的行号:"+NullTelRows);
		if (ErrTelRows!="")alert("手机号码错误的行号:"+NullTelRows);
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