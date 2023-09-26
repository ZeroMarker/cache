function BodyLoadHandler() {
$('Save').onclick=BtuSave_Click;
}

function BtuSave_Click(){
	var rtn=CheckNull();
    if (!rtn){
	    return false;
    } 
    var AOTID=DHCC_GetElementData("AOTID")
	var AOTCode=DHCC_GetElementData("AOTCode")
	var AOTDesc=DHCC_GetElementData("AOTDesc")
	var AOTActive=DHCC_GetElementData("AOTActive")
	var AOTNote=DHCC_GetElementData("AOTNote")
	if(AOTActive==true){var Flag="Y"}
	else  {var Flag="N"}
	var ParseInfo=AOTID+"^"+AOTCode+"^"+AOTDesc+"^"+Flag+"^"+AOTNote
   var SaveClass=$('SaveClass');
   if (SaveClass) {var encmeth=SaveClass.value} else {var encmeth=''};
   var returnvalue=cspRunServerMethod(encmeth,ParseInfo);
   if(returnvalue==100)alert("代码重复");
   else if(returnvalue==0) alert("保存成功");
   else alert("添加失败")
   var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCAntOperaTime";
   location.href=lnk
	
}
function BtnClear_Click()
{
  $('AOTID').value = '';
  $('AOTCode').value = '';
  $('AOTDesc').value = '';
  $('AOTActive').checked = false;
  $('AOTNote').value = '';
}
var SelectedRow = 0;
function SelectRowHandler()
{
	BtnClear_Click()
	var eSrc=window.event.srcElement;
	var objtbl=$('tDHCAntOperaTime');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;	
	if (!selectrow) return;
	
   var AOTID=$('AOTID');
   var AOTCode=$('AOTCode');
   var AOTDesc=$('AOTDesc');
   var AOTActive=$('AOTActive');
   var AOTNote=$('AOTNote');
var Sel_AOTID=$('TIDz'+selectrow);

var Sel_AOTCode=$('TAOTCodez'+selectrow);
var Sel_AOTDesc=$('TAOTDescz'+selectrow);
var Sel_AOTActive=$('TAOTActivez'+selectrow);
var Sel_AOTNote=$('TAOTNotez'+selectrow);
	if (rowObj.className != 'clsRowSelected')
	{
	//$('BtnUpdate').disabled=true;	
	//$('BtnClear').disabled=true;	
     BtnClear_Click()

	}
	else
	{
	//$('BtnUpdate').disabled=false;	
	//$('BtnClear').disabled=false;	
AOTID.value = Sel_AOTID.value;
AOTCode.value = Sel_AOTCode.innerText;
AOTDesc.value = Sel_AOTDesc.innerText;
AOTNote.value=Sel_AOTNote.innerText;
if(Sel_AOTActive.innerText=="Y") AOTActive.checked=true
else AOTActive.checked=false	
	}
SelectedRow = selectrow;

}
//验证必填字段
function CheckNull(){

if ($('AOTCode').value=="")
{
	alert("代码必须输入");
	$('AOTCode').focus();
	return false;
}	

if ($('AOTDesc').value=="")
{
	alert("描述必须输入");
	$('AOTDesc').focus();
	return false;
}	
	return true;
}
document.body.onload = BodyLoadHandler;