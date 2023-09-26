var CurRow=0
function BodyIni()
{
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Click;
}
function BSave_Click()
{
	var IDs="",encmeth="",PreIADM="",PreOrAdd="";
	var objtbl=document.getElementById('tDHCPEPreIEndangerList');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	//取选中的ID串
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSelectz"+i);
		if (obj&&obj.checked){
			obj=document.getElementById("EDIDz"+i);
			if (obj){
				var ID=obj.value;
				if (IDs==""){
					IDs=ID;
				}else{
					IDs=IDs+"^"+ID;
				}
			}
		}
	}
	obj=document.getElementById("SaveClass");
	if (obj){
		encmeth=obj.value;
		obj=document.getElementById("PreIADM");
		if (obj) PreIADM=obj.value;
		obj=document.getElementById("PreOrAdd");
		if (obj) PreOrAdd=obj.value;
		var ret=cspRunServerMethod(encmeth,PreIADM,IDs)
		if (ret=="0"){//成功
			parent.frames('right').location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIEndanger.Item&PreIADM='+PreIADM+"&PreOrAdd="+PreOrAdd;
		}else{//失败
			alert(ret);
		}
	}
}
//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
document.body.onload = BodyIni;