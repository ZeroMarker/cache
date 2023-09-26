function BodyLoadHandler() {
$('BtnAdd').onclick=BtuAdd_Click;
$('BtnDelete').onclick = BtnDelete_Click;
$('BtnClear').onclick=BtnClear_Click
$('BtnUpdate').onclick=BtnUpdate_Click
}
function LookUpAUR(str)
{
	var AUR=str.split("^");
	var obj=document.getElementById("AIAURID");
	obj.value=AUR[1];
}

function BtuAdd_Click(){
	var rtn=CheckNull();
    if (!rtn){
	    return false;
    } 
	var AICode=DHCC_GetElementData("AICode")
	var AIDesc=DHCC_GetElementData("AIDesc")
	var AIAURID=DHCC_GetElementData("AIAURID")
	var AIFlag=DHCC_GetElementData("AIFlag")
	var AINote=DHCC_GetElementData("AINote")
	if(AIFlag==true){var Flag="Y"}
	else  {var Flag="N"}
	if (AIAURID==""){
		alert("关联目的为空，请重新选择")
		return;
		}
	if ((AINote!="")&&(AINote.length>30)){
		alert("备注字符不可超过30个字符");
		return;
		}
	var ParseInfo=AICode+"^"+AIDesc+"^"+AIAURID+"^"+Flag+"^"+AINote
   // alert(ParseInfo);
   var BtnAddClass=$('BtnAddClass');
   if (BtnAddClass) {var encmeth=BtnAddClass.value} else {var encmeth=''};
   var returnvalue=cspRunServerMethod(encmeth,ParseInfo);
   if(returnvalue==100)alert("代码重复");
   else if(returnvalue==0) alert("添加成功");
   else alert("添加失败")
   var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCAntIndicationsCon";
   location.href=lnk
	
}
function BtnDelete_Click()
{
	
	var ID=DHCC_GetElementData("ID")
	if (ID=="") 
	{
		alert("未选中数据")
		return false
	}
	var BtnDeleteclass=$('BtnDeleteClass');
if (BtnDeleteclass) {var encmeth=BtnDeleteclass.value} else {var encmeth=''};
var returnvalue=cspRunServerMethod(encmeth,ID);
 if(returnvalue==0) alert("删除成功");
 else(alert("删除失败"))
var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCAntIndicationsCon";
   location.href=lnk
}
function BtnUpdate_Click(){
    var obj=document.getElementById('ID')
	if(obj) ID=obj.value;
	if(ID=="")
	{
		alert('请选择一项') 
		return;
	}
	//CheckNull();
	if(!CheckNull()) return false; //add by qp 2014-04-24
	var AICode=DHCC_GetElementData("AICode")
	var AIDesc=DHCC_GetElementData("AIDesc")
	var AIAURID=DHCC_GetElementData("AIAURID")
	var AIFlag=DHCC_GetElementData("AIFlag")
	var AINote=DHCC_GetElementData("AINote")
	if(AIFlag==true){var Flag="Y"}
	else  {var Flag="N"}
	if (AIAURID==""){
		alert("关联目的为空，请重新选择")
		return;
		}
	if ((AINote!="")&&(AINote.length>30)){
		alert("备注字符不可超过30个字符");
		return;
		}
	var ParseInfo=ID+"^"+AICode+"^"+AIDesc+"^"+AIAURID+"^"+Flag+"^"+AINote
   var BtnAddClass=$('BtnUpdateClass');
   if (BtnAddClass) {var encmeth=BtnAddClass.value} else {var encmeth=''};
   var returnvalue=cspRunServerMethod(encmeth,ParseInfo);
    if(returnvalue==0) alert("更新成功");
   else alert("更新失败")
   var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCAntIndicationsCon";
   location.href=lnk
	
}
function BtnClear_Click()
{
	$('ID').value = '';
  $('AICode').value = '';
  $('AIDesc').value = '';
  $('AIAUR').value = '';
  $('AIAURID').value = '';
  $('AIFlag').checked = false;
  $('AINote').value = '';
}
var SelectedRow = 0;
function SelectRowHandler()
{
	BtnClear_Click()
	var eSrc=window.event.srcElement;
	var objtbl=$('tDHCAntIndicationsCon');
	if(!objtbl)
	{
	   objtbl=$('tDHCAntIndicationsCon0');
	}
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;	
	if (!selectrow) return;
	
   var ID=$('ID');

   var AICode=$('AICode');

 var AIDesc=$('AIDesc');
 
  var AIAUR=$('AIAUR');

 var AIAURID=$('AIAURID');

 var AIFlag=$('AIFlag');

 var AINote=$('AINote');
		
var Sel_AID=$('AIDz'+selectrow);

var Sel_AAICode=$('AAICodez'+selectrow);

var Sel_AAIDesc=$('AAIDescz'+selectrow);
var Sel_AAIAURID=$('AAIAURIDz'+selectrow);
var Sel_AAIAUR=$('AAIAURz'+selectrow);

var Sel_AAIFlag=$('AAIFlagz'+selectrow);

var Sel_AAINote=$('AAINotez'+selectrow);

	if (rowObj.className != 'clsRowSelected')
	{
	//$('BtnUpdate').disabled=true;	
	//$('BtnClear').disabled=true;	
ID.value = '';

AICode.value = '';

AIDesc.value = '';
AIAURID.value='';

AIAUR.value = '';

AIFlag.checked = false;

AINote.value = '';
	SelectedRow = 0;
	}
	else
	{
	//$('BtnUpdate').disabled=false;	
	//$('BtnClear').disabled=false;	
ID.value = Sel_AID.value;
AIAURID.value=Sel_AAIAURID.value;
AICode.value = Sel_AAICode.innerText;
AIDesc.value = Sel_AAIDesc.innerText;
AIAUR.value=Sel_AAIAUR.innerText;
if(Sel_AAIFlag.innerText=="Y") AIFlag.checked=true
else AIFlag.checked=false
AINote.value=Sel_AAINote.innerText;	
SelectedRow = selectrow;
	}


}
//验证必填字段
function CheckNull(){

if ($('AICode').value=="")
{
	alert("代码必须输入");
	$('AICode').focus();
	return false;
}	

if ($('AIDesc').value=="")
{
	alert("描述必须输入");
	$('AIDesc').focus();
	return false;
}	
if ($('AIAUR').value=="")
{
	alert("关联抗生必须输入");
	$('AIAUr').focus();
	return false;
}	
	return true;
}
document.body.onload = BodyLoadHandler;