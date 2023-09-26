var SelectedRow = 0;
function BodyLoadHandler() {
	var obj=document.getElementById('BtnDelete');
	if (obj) {obj.onclick=Deleteclick;}
	var obj=document.getElementById('BtnSave');
	if (obj) {obj.onclick=Saveclick;}
}

function Saveclick(){
	var GroupDesc=document.getElementById('SSUserGroup').value;
    GroupDesc=cTrim(GroupDesc,0)
    if (GroupDesc=="") {
		alert("安全组不能为空！");
		return;
		}
	var RowID=document.getElementById('GroupID').value;	
	RowID=cTrim(RowID,0)
	if(RowID=="")
	{
		alert("安全组不能为空！");
		return;
	}
    var myForceReturn=document.getElementById('ForceReturn');
    if(myForceReturn.checked){
	    myForceReturn = "Y";
   	}else{
	    myForceReturn = "N";
	}
	var InString=RowID+"^"+myForceReturn;
	var Ins=document.getElementById('SaveGroupMethod');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,InString)=="0") {
		//alert("增加成功！");
		window.location.reload();                ///从新加载页面
	}
	else{
		alert("增加失败！")
	}
}

function LookUpGroupSelect(value){
	var myArr=value.split("^");
	DHCC_SetElementData("GroupID",myArr[1]);
	DHCC_SetElementData("SSUserGroup",myArr[0]);
}
	
function Deleteclick()	
{
	var GroupDesc=document.getElementById('SSUserGroup').value;
    GroupDesc=cTrim(GroupDesc,0)
    if (GroupDesc=="") {
		alert("安全组不能为空！");
		return;
	}
	
	var RowID=document.getElementById('GroupID').value;	
	RowID=cTrim(RowID,0)
	if(RowID=="")
	{
		alert("安全组不能为空！");
		return;
	}
    var InString=RowID;
	var Ins=document.getElementById('DeleteGroupMethod');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,InString)=="0") {
		//alert("更新成功！");
		window.location.reload();                ///从新加载页面
	}
	else{
		alert("删除失败！")
	}

}

	
function SelectRowHandler()	{  
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOPForceCancelReg');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;	
	if (selectrow!=SelectedRow){
		var obj=document.getElementById('SSUserGroup');
		//alert(obj.value);
		if (obj){
			var SelRowObj=document.getElementById('TSSGroupz'+selectrow);
			if(SelRowObj)obj.value=SelRowObj.innerText;	
		}
		
		var obj=document.getElementById('ForceReturn');
		if (obj){
			var SelRowObj=document.getElementById('TForceReturnz'+selectrow);
			if(SelRowObj.innerText=="是"){
				obj.checked=true;
			}else{
				obj.checked=false;
			}
		}	
		var obj=document.getElementById('GroupID');
		var SelRowObj=document.getElementById('TGroupIDz'+selectrow);
		if(SelRowObj)obj.value=SelRowObj.value;
		SelectedRow=selectrow;			
	}
	else {
		SelectedRow=0;
		var obj=document.getElementById('SSUserGroup');
		if (obj){
			obj.value="";	
		}
		var obj=document.getElementById('GroupID');
		if (obj){
			obj.value="";	
		}
		var obj=document.getElementById('ForceReturn');
		if (obj){
			obj.checked=false;
		}
	}	
}

//****************************************************************
// Description: sInputString 为输入字符串?iType为类型?分别为
// 0 - 去除前后空格; 1 - 去前导空格; 2 - 去尾部空格
//****************************************************************
function cTrim(sInputString,iType)
{
  var sTmpStr = ' '
  var i = -1

  if(iType == 0 || iType == 1)
  {
     while(sTmpStr == ' ')
     {
       ++i
       sTmpStr = sInputString.substr(i,1)
     }
     sInputString = sInputString.substring(i)
  }

  if(iType == 0 || iType == 2)
  {
    sTmpStr = ' '
    i = sInputString.length
    while(sTmpStr == ' ')
    {
       --i
       sTmpStr = sInputString.substr(i,1)
    }
    sInputString = sInputString.substring(0,i+1)
  }
  return sInputString
}


document.body.onload = BodyLoadHandler;

