
var CurRow=0
function BodyLoadHandler() {
  
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) {obj.onclick=BUpdate_click;}
	obj=document.getElementById("BDelete");
	if (obj) {obj.onclick=BDelete_click;}
	var obj=document.getElementById("UserName");
	if (obj) obj.onchange=UserName_Change;
	var obj=document.getElementById("GroupName");
	if (obj) obj.onchange=GroupName_Change;
    var obj=document.getElementById("LocName");
    if (obj) obj.onchange=LocName_Change;
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}    
function BUpdate_click(){
	Update(0);
}
function BDelete_click(){
	Update(1);
}
/*function Update(Type){
	var UserID="",GroupID="",LocID="",Method="";  
    var obj=document.getElementById("UserID");
	if (obj) UserID=obj.value;
	if (UserID==""){
		alert("����Ա����Ϊ��");
		websys_setfocus("UserName");
		return false;
	}
	var obj=document.getElementById("LocID");
	if (obj) LocID=obj.value;
	if (LocID==""){
		alert("���Ҳ���Ϊ��");
		websys_setfocus("LocName");
		return false;
	}
	var obj=document.getElementById("GroupID");
	if (obj) GroupID=obj.value;
	if (GroupID==""){
		alert("��ȫ�鲻��Ϊ��");
		websys_setfocus("GroupName");
		return false;
	}
	var obj=document.getElementById("Method");
	if (obj) Method=obj.value;
	if (Method==""){
		alert("û���������ݲ����ķ���");
		return false;
	}
	var ret=cspRunServerMethod(Method,UserID,LocID,GroupID,Type);
	location.reload();
}*/
function Update(Type){
	var UserID="",GroupID="",LocID="",Method=""; 
    var obj=document.getElementById("UserID");
	if (obj) UserID=obj.value;
	var obj=document.getElementById("LocID");
	if (obj) LocID=obj.value;
	var obj=document.getElementById("GroupID");
	if (obj) GroupID=obj.value;
	
	if(Type=="1")
	{
		if (CurRow==0) 
		{
		alert("����ѡ��Ҫɾ���ļ�¼");
		return false;
		}
	
	}
	
	if(Type=="0")
	{
		if (UserID==""){
		alert("����Ա����Ϊ��");
		websys_setfocus("UserName");
		return false;
		}
	
		if (LocID==""){
		alert("���Ҳ���Ϊ��");
		websys_setfocus("LocName");
		return false;
		}
	
		if (GroupID==""){
		alert("��ȫ�鲻��Ϊ��");
		websys_setfocus("GroupName");
		return false;
		}
	}
	
	var obj=document.getElementById("Method");
	if (obj) Method=obj.value;
	if (Method==""){
		alert("û���������ݲ����ķ���");
		return false;
	}
	
	var ret=cspRunServerMethod(Method,UserID,LocID,GroupID,Type);
	location.reload();
}

function UserName_Change(){
	var obj=document.getElementById("UserID");
	if (obj) obj.value="";
}
function GroupName_Change(){
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
}
function LocName_Change(){
	var obj=document.getElementById("LocID");
	if (obj) obj.value="";
}
function UserLookUp(value){
	//UserID  UserName
	if (value=="") return;
	var arrStr=value.split("^")
	var obj=document.getElementById("UserID");
	if (obj) obj.value=arrStr[1];
	var obj=document.getElementById("UserName");
	if (obj) obj.value=arrStr[0];
}
function GroupLookUp(value){
	if (value=="") return;
	var arrStr=value.split("^")
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=arrStr[1];
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=arrStr[0];
}
function LocLookUp(value){
	if (value=="") return;
	var arrStr=value.split("^")
	var obj=document.getElementById("LocID");
	if (obj) obj.value=arrStr[1];
	var obj=document.getElementById("LocName");
	if (obj) obj.value=arrStr[0];
}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var objtbl=document.getElementById("tDHCPEChartAssign");
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurRow)
	{	    
	    CurRow=0;
	}else{

		CurRow=selectrow;
	}
	ShowCurRecord(CurRow);
	var UserID="",GroupID="",LocID="",Method="";  
    var obj=document.getElementById("UserID");
	if (obj) UserID=obj.value;
	var obj=document.getElementById("LocID");
	if (obj) LocID=obj.value;
	var obj=document.getElementById("GroupID");
	if (obj) GroupID=obj.value;
	if (CurRow==0){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEChartAssignDetail&UserID=&LocID=&GroupID=";
	}else{
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEChartAssignDetail&UserID="+UserID+"&LocID="+LocID+"&GroupID="+GroupID;
	}
	parent.frames["DHCPEChartAssignDetail"].location.href=lnk;
}
function ShowCurRecord(CurRecord) {
	
	var selectrow=CurRecord;
	//վ����� ��ʾ
	FromTableToItem("UserID","TUserID",selectrow);  


	//վ������(����) ��ʾ
	FromTableToItem("UserName","TUserName",selectrow);  

	//վ������λ�� ��ʾ
	FromTableToItem("LocID","TLocID",selectrow);  

	//˳�� ��ʾ
	FromTableToItem("LocName","TLocName",selectrow);  

	//���� ��ʾ ��ѡ��
	FromTableToItem("GroupID","TGroupID",selectrow);

	//��¼���� ����ʾ
	FromTableToItem("GroupName","TGroupName",selectrow);
}
function FromTableToItem(Dobj,Sobj,selectrow) {
	var SelRowObj;
	var obj;
	var LabelValue="";
	obj=document.getElementById(Dobj);
    if (!(obj)) { return null; }
	if (selectrow==0) obj.value="";
	SelRowObj=document.getElementById(Sobj+'z'+selectrow);
	
   	if (!(SelRowObj)) { 
   	return null; }
	LabelValue=SelRowObj.tagName.toUpperCase();
   	
   	
   	if ("LABEL"==LabelValue) {		
		obj.value=trim(SelRowObj.innerText);
		return obj;
	}
	
	if ("INPUT"==LabelValue) {
		LabelValue=SelRowObj.type.toUpperCase();
		
		if ("CHECKBOX"==LabelValue) {
			obj.checked=SelRowObj.checked;
			return obj;
		}
		
		if ("HIDDEN"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}
		
		if ("TEXT"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}

		obj.value=SelRowObj.type+trim(SelRowObj.value);
		return obj;
	}

}
document.body.onload = BodyLoadHandler;
