var UserRowId
function BodyLoadHandler() {
	var obj=document.getElementById('BtnSave');
	if (obj) obj.onclick=Add_Click;
	UserRowId=session['LOGON.USERID']
	obj=document.getElementById('UserRowId');
	if (obj)
	{   obj.value=UserRowId  }
}
function Add_Click()
{   var CashToBank,AmtYBDZ
	var obj=document.getElementById('cash');
	if (obj)
	{   CashToBank=obj.value }
	else
	{   CashToBank=""        }
	if (CashToBank=="")
	{   alert("请输入预存金额")
	    return;
	}
	var obj=document.getElementById('AmtYBDZ');
	if (obj)
	{   AmtYBDZ=obj.value }
	else
	{   AmtYBDZ="0"        }
	var Date=document.getElementById('QueryDate').value;
	var GetCount=document.getElementById('GetCount');
	if (GetCount) {var encmeth=GetCount.value} else {var encmeth=''};
    var Count=cspRunServerMethod(encmeth,Date,UserRowId)
    
    if (Count>=2)
    {   alert("一天内最多预存两次现金.")
        return 
    }
    
    if (save) {var encmeth=save.value} else {var encmeth=''};
    var err=cspRunServerMethod(encmeth,UserRowId,CashToBank)
	var save=document.getElementById('save');
    if (save) {var encmeth=save.value} else {var encmeth=''};
    var err=cspRunServerMethod(encmeth,UserRowId,CashToBank,AmtYBDZ)
    if (err==0)
    {   alert("保存成功.")
        window.location.reload
    }
    else
    {   alert("保存失败."+"SQLCODE:"+err)
        return   }
}
document.body.onload=BodyLoadHandler