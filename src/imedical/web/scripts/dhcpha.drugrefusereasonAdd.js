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
		alert("���벻��Ϊ�գ�")
		return;
	}
  	if (Desc=="")
	{
		alert("���Ʋ���Ϊ�գ�")
		return;
	}
	var obj=document.getElementById("mUpdateRefReason")
	if (obj) exe=obj.value;
    else exe=""
    
    var result=cspRunServerMethod(exe,Rowid,Code,Desc)
    if (result==-1)
    {
	    alert("�����Ѿ����ڣ�")
		return;
    }
    else if (result==-2)
    {
	    alert("�����Ѿ����ڣ�")
		return;
    }
    else if (result==-100)
    {
	    alert("���´���")
		return;
    }
	opener.location.reload();   //ˢ��
	window.close();
}
function Exit()
{window.close();}

document.body.onload=BodyLoadHandler