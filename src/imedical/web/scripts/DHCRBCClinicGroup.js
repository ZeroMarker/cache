var SelectedRow = 0;
document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var obj=document.getElementById("BtnAdd")
	if (obj) obj.onclick=BtnAdd_click;
	
	var obj=document.getElementById("BtnUpdate")
	if (obj) obj.onclick=BtnUpdate_click;
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCRBCClinicGroup');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('CLGRPCode');
	var obj1=document.getElementById('CLGRPDesc');
	var obj2=document.getElementById('Rowid');
	var obj3=document.getElementById('BeginDate');
	var obj4=document.getElementById('EndDate');
	
	var SelRowObj=document.getElementById('TCLGRPCodez'+selectrow);
	var SelRowObj1=document.getElementById('TCLGRPDescz'+selectrow);
	var SelRowObj2=document.getElementById('TIDz'+selectrow);
	var SelRowObj3=document.getElementById('TBeginDatez'+selectrow);
	var SelRowObj4=document.getElementById('TEndDatez'+selectrow);
	if (SelectedRow!=selectrow){
		obj.value=SelRowObj.innerText;
		obj1.value=SelRowObj1.innerText;
		obj2.value=SelRowObj2.value;
		obj3.value=SelRowObj3.innerText;
		obj4.value=SelRowObj4.innerText;
		document.all.BtnAdd.readonly=false;
		SelectedRow=selectrow
		}
	else{
		obj.value='';
		obj1.value='';
		obj2.value='';
		obj3.value='';
		obj4.value='';
		document.all.BtnAdd.readonly=true;
		SelectedRow=0
	}
}
function BtnAdd_click(e)
{
	if(!ValidControl()) return false;

	var code=document.all.CLGRPCode.value;
	var name=document.all.CLGRPDesc.value;
	var begindate=document.all.BeginDate.value;
	var enddate=document.all.EndDate.value;
	var insertMethod=document.all.insert.value;
	var returnvalue=cspHttpServerMethod(insertMethod,code.trim(),name.trim(),begindate.trim(),enddate.trim());
	if(returnvalue=="1")
	{
		alert(t['addMsg']);
		ClearHiddenValue();
		BtnSearch_click();
	}
	else if(returnvalue=="2")
	{
		alert(t['codeExistMsg']);
		document.all.CLGRPCode.focus();
	}
	else
	{
		alert(t['addFailMsg']);
	}
	
}
function BtnUpdate_click(e)
{
	if(SelectedRow==0){
		alert("请选择一行")
		return
	}
	if(!ValidControl()) return false;
	var code=document.all.CLGRPCode.value;
	var name=document.all.CLGRPDesc.value;
	var id=document.all.Rowid.value;
	var begindate=document.all.BeginDate.value;
	var enddate=document.all.EndDate.value;
	
	var updateMethod=document.all.update.value;
	var returnvalue=cspHttpServerMethod(updateMethod,id,code.trim(),name.trim(),begindate.trim(),enddate.trim());
	if(returnvalue=="1")
	{
		alert(t['updateMsg']);
		ClearHiddenValue();
		BtnSearch_click();
	}
	else if(returnvalue=="2")
	{
		alert(t['codeExistMsg']);
		document.all.CLGRPCode.focus();
	}
	else
	{
		alert(t['updateFailMsg']);
	}
	
}

/*
document.all.BtnDelete.onclick=function()
{
	var id=document.all.Rowid.value;
	if(id!="")
	{
		if(confirm("你确定要删除吗？"))
		{
			var deleteMethod=document.getElementById("delete").value;
			if(cspHttpServerMethod(deleteMethod,id)=="1")
			{
				alert("删除成功！");
				ClearHiddenValue();
				BtnDelete_click();
			}
			else
			{
				alert("删除失败！");
			}
		
		}
	}
	else
	{
		alert("请选择要删除的专业组信息！");
	}
}
*/

function ValidControl()
{
	if(document.all.CLGRPCode.value.trim()=="")
	{
		alert(t['codeMsg']);
		document.all.CLGRPCode.focus();
		return false;
	}
	if(document.all.CLGRPDesc.value.trim()=="")
	{
		alert(t['descMsg']);
		document.all.CLGRPDesc.focus();
		return false;
	}
	var begindate=document.all.BeginDate.value;
	if(begindate==""){
		alert("开始日期不能为空");
		return false;
	}
	var enddate=document.all.EndDate.value;
	var Rtn=CompareDate(begindate,enddate)
	if (!Rtn){alert("请重新选择日期!");return Rtn}
	
	return true;
}
function ClearHiddenValue()
{
	document.all.CLGRPCode.value='';
	document.all.CLGRPDesc.value='';
}
String.prototype.trim = function()
{
    // 用正则表达式将前后空格
    // 用空字符串替代。
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
