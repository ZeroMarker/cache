document.body.onload = BodyLoadHandler;
var ComponentID="";
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("GetComponentID");
	if (obj) ComponentID=obj.value;
	obj=document.getElementById("BSendMessage");
	if (obj) obj.onclick=BSendMessage_click;
	
	obj=document.getElementById("ResultFlag");
	if (obj){
		obj.onchange=ResultFlag_change;
		if (obj.checked){
			obj=document.getElementById("HighRiskDesc");
			if (obj) obj.style.display='none';
			obj=document.getElementById("cHighRiskDesc");
			if (obj) obj.style.display='none';
			obj=document.getElementById("ld"+ComponentID+"iHighRiskDesc");
			if (obj) obj.style.display='none';		
		}else{
			obj=document.getElementById("ODDesc");
			if (obj) obj.style.display='none';
			obj=document.getElementById("cODDesc");
			if (obj) obj.style.display='none';
			obj=document.getElementById("ld"+ComponentID+"iODDesc");
			if (obj) obj.style.display='none';
		}
	}
	obj=document.getElementById("GroupDesc");
	if (obj) { obj.onchange=Group_Change; }
	obj=document.getElementById("ODDesc");
	if (obj) { obj.onchange=Detail_Change; }
	obj=document.getElementById("HighRiskDesc");
	if (obj) { obj.onchange=HighRiskDesc_Change; }
	
	Muilt_LookUp('GroupDesc'+'^'+'ODDesc'+'^'+'HighRiskDesc');
}
function BSendMessage_click()
{
	var encmeth="";
	var obj=document.getElementById("SendMessageClass");
	if (obj) encmeth=obj.value;
	var objtbl=document.getElementById('tDHCPEHighRiskQueryED');	//取表格元素?名称
	var rows=objtbl.rows.length;
	var ErrRows="";
	var NullTelRows="";
	var ErrTelRows="";
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSendz"+i);
		if (obj&&obj.checked){
			var obj=document.getElementById("TIDz"+i);
			if (obj) var ID=obj.value;
			var Arr=ID.split("^");
			var Type=Arr[1];
			ID=Arr[0];
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
			var obj=document.getElementById("TMessageTemplatez"+i);
			if (obj) var MessageTemplate=obj.value;
			var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
			var ret=cspRunServerMethod(encmeth,Type,InfoStr);
			if (ret!=0){
				ErrRows=ErrRows+"^"+i;
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
function HighRiskDesc_Change()
{
	var obj=document.getElementById("HighRiskID");
	if (obj) { obj.value=""; }
}
function Detail_Change()
{
	var obj=document.getElementById("ODDesc");
	if (obj) { obj.value=""; }
}
function Group_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
}
function ResultFlag_change()
{
	var obj;
	obj=document.getElementById("ResultFlag");
	if (obj.checked){
		obj=document.getElementById("HighRiskDesc");
		if (obj) obj.style.display='none';
		obj=document.getElementById("cHighRiskDesc");
		if (obj) obj.style.display='none';
		obj=document.getElementById("ld"+ComponentID+"iHighRiskDesc");
		if (obj) obj.style.display='none';
		obj=document.getElementById("ODDesc");
		if (obj) obj.style.display='';
		obj=document.getElementById("cODDesc");
		if (obj) obj.style.display='';
		obj=document.getElementById("ld"+ComponentID+"iODDesc");
		if (obj) obj.style.display='';	
	}else{
		obj=document.getElementById("ODDesc");
		if (obj) obj.style.display='none';
		obj=document.getElementById("cODDesc");
		if (obj) obj.style.display='none';
		obj=document.getElementById("ld"+ComponentID+"iODDesc");
		if (obj) obj.style.display='none';
		obj=document.getElementById("HighRiskDesc");
		if (obj) obj.style.display='';
		obj=document.getElementById("cHighRiskDesc");
		if (obj) obj.style.display='';
		obj=document.getElementById("ld"+ComponentID+"iHighRiskDesc");
		if (obj) obj.style.display='';
	}
	
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