var Rowid
var Code
var Desc;

function BodyLoadHandler()
{
	var obj=document.getElementById("Update")
	if (obj) obj.onclick=Update;
	var obj=document.getElementById("Cancel")
	if (obj) obj.onclick=Exit;
}

function Update()
{ 
	var Rowid="";
	var Code="";
	var Desc="";
	var obj=document.getElementById("Rowid")
	if (obj) Rowid=obj.value;
	var objCode=document.getElementById("Code")
	if (objCode) Code=objCode.value;
	var objDesc=document.getElementById("Desc")
	if (objDesc) Desc=objDesc.value;
	if (Code=="")
	{
		alert("代码不能为空！")
		return;
	}
  	if (Desc=="")
	{
		alert("名称不能为空！")
		return;
	}
	var obj=document.getElementById("mUpdateRefReason")
	if (obj) exe=obj.value;
    else exe=""
    
    var result=cspRunServerMethod(exe,Rowid,Code,Desc)
    if (result==-1)
    {
	    alert("代码已经存在！")
		return;
    }
    else if (result==-2)
    {
	    alert("名称已经存在！")
		return;
    }
    else if (result==-100)
    {
	    alert("更新错误！")
		return;
    }
	opener.location.reload();   //刷新
	window.close();
}
function Exit()
{window.close();}

document.body.onload=BodyLoadHandler