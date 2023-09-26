
var CurRow=0
var tForm="tDHCPERigsterWinSet"
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
	var obj=document.getElementById("UserID");
	if (obj) var UserID=obj.value;
	
		
	if (UserID=="") {
		obj=document.getElementById("TUserIdz"+CurRow);
		if(CurRow==0){
			alert("操作员不能为空");
			return false;
		}
		else{
			if (obj) var UserID=obj.value;
			}
		
		}
	
	var Flag=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","RigsterWinSet",UserID,1,"Set");
	if (Flag==0){
		alert("保存成功!")
	}
	location.reload();
}
function BRemove()
{
	var Flag=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","RigsterWinSet",UserID,0,"Move");
	if (Flag==0){
		alert("保存成功!")
	}
	location.reload();
	
}
function BDelete_click(){
	var tbl=document.getElementById("tForm");
	obj=document.getElementById("TUserIdz"+CurRow);
	if (obj) var UserID=obj.value;
	if(CurRow==0)
	{
		alert("请先选择要删除的记录");
	    return false;
	}

	
	var Flag=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","RigsterWinSet",UserID,0,"Move");
	if (Flag==0){
		alert("删除成功!")
	}
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
}

document.body.onload = BodyLoadHandler;

