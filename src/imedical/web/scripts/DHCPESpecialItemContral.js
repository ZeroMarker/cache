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
		alert("用户不能为空");
		return false;
	 }

	var ret="";
	if(UserID!="")
	{
	
	var ret=tkMakeServerCall("web.DHCPE.SpecialItemContral","AddSpecialItemContralUser",UserID);
	if(ret="0"){alert("增加成功")};
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
		alert("请先选择要删除的记录");
		return false;
	 }

	var ret="";
	if(UserID!="")
	{
	var ret=tkMakeServerCall("web.DHCPE.SpecialItemContral","DelSpecialItemContralUser",UserID);
	if(ret="0"){alert("删除成功")};
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
	//站点编码 显示
	FromTableToItem("UserID","TUserID",selectrow);  


	//站点描述(名称) 显示
	//FromTableToItem("UserName","TUserName",selectrow);  

	//站点所在位置 显示
	//FromTableToItem("LocID","TLocID",selectrow);  

	//顺序 显示
	//FromTableToItem("LocName","TLocName",selectrow);  

	//激活 显示 单选框
	//FromTableToItem("GroupID","TGroupID",selectrow);

	//记录编码 不显示
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