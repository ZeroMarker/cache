///DHCPEPreIEndanger.Item

var CurRow=0
function BodyIni()
{
	var obj;
	obj=document.getElementById("BAddItem");
	if (obj) obj.onclick=BAddItem_Click;
	SetEndisabled();
}
function SetEndisabled()
{
	var objtbl=document.getElementById('tDHCPEPreIEndanger_Item');	//取表格元素?名称
	var rows=objtbl.rows.length;
	var obj,ItemFlag=0;
	//取选中的ID串
	for (var i=1;i<rows;i++)
	{
			obj=document.getElementById("TNeedFlagz"+i);
			if (obj&&obj.checked){
				tbl.rows[i].style.background="#FF8247"
		}
	}
}
function BAddItem_Click()
{
	var ID="",encmeth="",PreIADM="",UserID="",PreOrAdd="",SetsID="";
	var obj=document.getElementById("InsertItemClass");
	if (obj) encmeth=obj.value;
	obj=document.getElementById("PreIADM");
	if (obj) PreIADM=obj.value;
	UserID=session['LOGON.USERID'];
	obj=document.getElementById("PreOrAdd");
	if (obj) PreOrAdd=obj.value;
	
	
	var objtbl=document.getElementById('tDHCPEPreIEndanger_Item');	//取表格元素?名称
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TNeedFlagz"+i);
		if (obj&&obj.checked){
			obj=document.getElementById("ArcimIDz"+i);
			if (obj){
				ID=obj.value;
				obj=document.getElementById("TSetsIDz"+i);
				if (obj) SetsID=obj.value;
				var flag=cspRunServerMethod(encmeth,PreIADM, "PERSON",PreOrAdd,ID, SetsID,UserID)
				if (flag=="Notice"){
					alert("已审核,加人加项需取消审核!"+(i+1));
					return false;
				}
				if (flag!="") {
					alert(t['ErrSave']+":"+flag);
					return false;
				}
			}
		}
	}
	parent.opener.location.reload();
	parent.close();
}
//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
document.body.onload = BodyIni;