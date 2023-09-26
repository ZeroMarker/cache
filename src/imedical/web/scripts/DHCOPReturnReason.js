
document.body.onload = BodyLoadHandler;
var SelectedRow = 0;
function BodyLoadHandler() 
{
	var obj=document.getElementById("Add");
	if(obj) obj.onclick=Add_click;
	var obj=document.getElementById("Update");
	if(obj) obj.onclick=Update_click;
	var obj=document.getElementById("Delete");
	if(obj) obj.onclick=Delete_click;
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOPReturnReason');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('Code');
	var obj1=document.getElementById('Desc');
	var obj2=document.getElementById('RowID');
	var obj3=document.getElementById('DateFrom');
	var obj4=document.getElementById('DateTo');
	if (SelectedRow!=selectrow)
	{ 
		SelectedRow=selectrow
        var SelRowObj=document.getElementById('TCodez'+selectrow);
		var SelRowObj1=document.getElementById('TDescz'+selectrow);
		var SelRowObj2=document.getElementById('TRTRowIDz'+selectrow);
		var SelRowObj3=document.getElementById('TDateFromz'+selectrow);
		var SelRowObj4=document.getElementById('TDateToz'+selectrow);
		obj.value=SelRowObj.innerText;
		obj1.value=SelRowObj1.innerText;
		obj2.value=SelRowObj2.value;
		obj3.value=SelRowObj3.innerText;
		obj4.value=SelRowObj4.innerText;
		}
	else
	{   var CurDate=document.getElementById('CurDate').value
	    SelectedRow=0;
		obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value=CurDate;
		obj4.value="";
	}
}

function Update_click()
{
	var Rtn=CheckData()
	if (!Rtn){return}
	var code=document.getElementById("Code").value;
	var desc=document.getElementById("Desc").value;
	var obj=document.getElementById('RowID');
	if (obj){RowID=obj.value}
	if (RowID==""){alert("请选中有效行更新");retun;}
	var DateTo=document.getElementById("DateTo").value;
	var DateFrom=document.getElementById("DateFrom").value;
	var returnvalue=tkMakeServerCall("web.DHCOPReturnReason","UpdateData",RowID,code,desc,DateFrom,DateTo);
	if (returnvalue==0){
		alert("更新成功");
		Find_click();
	}else{
		alert("更新失败,"+returnvalue);
	}
	
 }
 
function Delete_click()
{
   var obj=document.getElementById('RowID');
   if (obj){RowID=obj.value}
   if (RowID==""){alert("请选中有效行");retun;}
   var returnvalue=tkMakeServerCall("web.DHCOPReturnReason","DeleteData",RowID);
   if (returnvalue==0){alert("删除成功")}
   else{alert("删除失败")}
   document.getElementById("Code").value="";
   document.getElementById("Desc").value="";
   Find_click();
 }
 function CheckData()
 {
	var code=document.getElementById("Code").value;
	code=code.replace(/\s/ig,'');
	if (code==""){alert("请输入退号原因编码");return false}
	var desc=document.getElementById("Desc").value;
	desc=desc.replace(/\s/ig,'');
	if (desc==""){alert("请输入退号原因描述");return false}
	return true

 }
 
function Add_click()
{
	var code=document.getElementById("Code").value;
	code=code.replace(/\s/ig,'');
	var desc=document.getElementById("Desc").value;
	desc=desc.replace(/\s/ig,'');
	var DateTo=document.getElementById("DateTo").value;
	var DateFrom=document.getElementById("DateFrom").value;
	var Rtn=CheckData()
	if (!Rtn){return}
	var returnvalue=tkMakeServerCall("web.DHCOPReturnReason","AddData",code,desc,DateFrom,DateTo);
	if (returnvalue==0){
	  alert("增加成功") 
	  Find_click();
	}else {
		alert("增加失败,"+returnvalue)
	}
	
}
