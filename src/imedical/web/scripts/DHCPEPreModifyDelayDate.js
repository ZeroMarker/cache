/// 名称	DHCPEPreModifyDelayDate.js
/// 创建时间		
/// 创建人		wrz
/// 主要功能   修改团体?个人的延期日期		
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成

function BodyLoadHandler() {

	var obj;
	
	//更新
	obj=document.getElementById("BOK");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById('BCancel')
	if (obj) {obj.onclick=Cancel_click;}

	
}
function Cancel_click()
{
	window.close();
}

function Update_click() {
	var obj,ID,Type,DelayDate,encmeth,Flag
	obj=document.getElementById('ID');
	if (obj) ID=obj.value;
	obj=document.getElementById('Type');
	if (obj) Type=obj.value;
	obj=document.getElementById('DelayDate');
	if (obj) DelayDate=obj.value;
	obj=document.getElementById('encmeth');
	if (obj) encmeth=obj.value
	if (DelayDate=="")
	{
		alert(t["01"]);
		return;
	}
	Flag=cspRunServerMethod(encmeth,ID,Type,DelayDate)
	if (Flag!=0)
	{
		alert(t["Err 01"]);
		return;
	}
	if (opener)
	{
		obj=opener.document.getElementById("DelayDate");
		if (obj) obj.value=DelayDate;
	}
	window.close();
}
document.body.onload = BodyLoadHandler;

