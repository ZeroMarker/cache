var Rowid
var Code
var Desc;
var currRow;

function BodyLoadHandler()
{
	var obj=document.getElementById("Update")
	if (obj) obj.onclick=Update;
	var obj=document.getElementById("Cancel")
	if (obj) obj.onclick=Exit;
	var obj=document.getElementById("Add")
	if (obj) obj.onclick=Add;
	var obj=document.getElementById("Delete")
	if (obj) obj.onclick=Delete;
}

function Update()
{ 
    
    var obj=document.getElementById("TRowid"+"z"+currRow)
    if (obj) Rowid=obj.value;
    if ((Rowid=="")||(Rowid==null)) {alert("����δȡ��ROWID");return;}  ///2014-12-20 ws
	var obj=document.getElementById("Code")
	if (obj) Code=obj.value;
	var obj=document.getElementById("Desc")
	if (obj) Desc=obj.value;

    if((Code=="")||(Desc==""))
    {
	    alert("���롢��������Ϊ�գ����飡");
	    return;
	}
    
	var obj=document.getElementById("mUpdateRetReason")
	if (obj) exe=obj.value;
    else exe=""

	var result=cspRunServerMethod(exe,Rowid,Code,Desc)
	if(result=="-1")
	{
		alert("����ʧ��!");
		return;
	}
	

    var result=cspRunServerMethod(exe,Rowid,Code,Desc)
	window.location.reload();   //ˢ��
	
}

function Add()
{ 

	var obj=document.getElementById("Code")
	if (obj) Code=obj.value;
	var obj=document.getElementById("Desc")
	if (obj) Desc=obj.value;
	
	//////////2014-12-20 ws
    if((Code=="")||(Desc==""))
    {
	    alert("���롢��������Ϊ�գ����飡");
	    return;
	}
	
	var obj=document.getElementById("mcheckbefup")
	if (obj) exe=obj.value;
    else exe=""
	var result=cspRunServerMethod(exe,"",Code,Desc)
	if(result!=0)
	{
		alert("ԭ���Ѵ��ڣ�����!");
		return;
	}
	///////////////////
	var obj=document.getElementById("mUpdateRetReason")
	if (obj) exe=obj.value;
    else exe=""
    
    var result=cspRunServerMethod(exe,"",Code,Desc)
	window.location.reload();   //ˢ��
	//window.close();
}
function Delete()
{
    var obj=document.getElementById("TRowid"+"z"+currRow)
    if (obj) Rowid=obj.value;
	if (Rowid=="") {alert("ɾ��δȡ��ROWID");return;}
	var obj=document.getElementById("mDeleteRetReason")
	if (obj) exe=obj.value;
    else exe=""
    var result=cspRunServerMethod(exe,Rowid)
    window.location.reload();
}
function SelectRowHandler()
{
	currRow=selectedRow(window)
	var objTReasonDesc=document.getElementById("TReasonDesc"+"z"+currRow)
	var objDesc=document.getElementById("Desc")
	if (objDesc) objDesc.value=objTReasonDesc.innerText;
	var objTReasonCode=document.getElementById("TReasonCode"+"z"+currRow)
	var objCode=document.getElementById("Code")
	if (objCode) objCode.value=objTReasonCode.innerText;

}
function Exit()
{window.close();}
document.body.onload=BodyLoadHandler