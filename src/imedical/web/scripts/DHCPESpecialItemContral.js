///DHCPESpecialItemContral.js
var CurRow=0
function BodyLoadHandler() {
  
	var obj;
	//alert('d')
	obj=document.getElementById("BADD");
	if (obj) {obj.onclick=ADD_click;}
	obj=document.getElementById("BDelete");
	if (obj) {obj.onclick=BDelete_click;}
	var obj=document.getElementById("UserName");
	if (obj) 
	{
		obj.onchange=UserName_Change;
		obj.onkeydown=UserName_keydown;
	}

	
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}
function UserName_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
       return false;
	}
}
function UserName_Change(){
	var obj=document.getElementById("UserID");
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
function ADD_click()
{
	var obj=document.getElementById("UserName")
	if(obj) {var UserName=obj.value;}
	
	var obj=document.getElementById("UserID")
	if(obj) {var UserID=obj.value;}
	if (""==UserID) {
		alert("�û�����Ϊ��");
		return false;
	 }

	var ret="";
	if(UserID!="")
	{
	
	var ret=tkMakeServerCall("web.DHCPE.SpecialItemContral","AddSpecialItemContralUser",UserID);
	if(ret="0"){alert("���ӳɹ�")};
	}
	else {return;}
	location.reload();
	
	}
	
function BDelete_click()
{
	var obj=document.getElementById("UserName")
	if(obj) {var UserName=obj.value;}
	
	var obj=document.getElementById("UserID")
	if(obj) {var UserID=obj.value;}
	
	if (""==UserID) {
		alert("����ѡ��Ҫɾ���ļ�¼");
		return false;
	 }

	var ret="";
	if(UserID!="")
	{
	var ret=tkMakeServerCall("web.DHCPE.SpecialItemContral","DelSpecialItemContralUser",UserID);
	if(ret="0"){alert("ɾ���ɹ�")};
	}
	else {return;}
	location.reload();
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
	
	if (CurRow==0){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESpecialItemContralDetail&UserID=";
	}else{
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESpecialItemContralDetail&UserID="+UserID;
	}
	//alert('11')
	//alert(parent.frames)
	parent.frames["DHCPESpecialItemContralDetail"].location.href=lnk;
	var obj=document.getElementById("UserID")
	if(obj) {var UserID=obj.value;}
	//alert(UserID)
}
function ShowCurRecord(CurRecord) {
	
	var selectrow=CurRecord;
	//վ����� ��ʾ
	FromTableToItem("UserID","TUserID",selectrow);  


	//վ������(����) ��ʾ
	//FromTableToItem("UserName","TUserName",selectrow);  

	//վ������λ�� ��ʾ
	//FromTableToItem("LocID","TLocID",selectrow);  

	//˳�� ��ʾ
	//FromTableToItem("LocName","TLocName",selectrow);  

	//���� ��ʾ ��ѡ��
	//FromTableToItem("GroupID","TGroupID",selectrow);

	//��¼���� ����ʾ
	//FromTableToItem("GroupName","TGroupName",selectrow);
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
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}   
	
	
document.body.onload = BodyLoadHandler;