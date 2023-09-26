function BodyLoadHandler()
{     
	//ฟฦสา	
	/*var CtLocStr=DHCC_GetElementData('getCtLocStr');
	combo_CtLoc=dhtmlXComboFromStr("ctLocDesc",CtLocStr);
	combo_CtLoc.enableFilteringMode(true);
	combo_CtLoc.selectHandle=combo_CtLocKeydownhandler;
	combo_CtLoc.keyenterHandle=combo_CtLocKeyenterhandler;*/
		
	obj=document.getElementById("find");
	if (obj){obj.onclick=find_Click;}
	obj=document.getElementById("print");
	if (obj){obj.onclick=print_Click;}
}
/*function combo_CtLocKeydownhandler(){
  var obj=combo_CtLoc;
  var ctLocId=obj.getActualValue();
  var ctLocDesc=obj.getSelectedText();
  DHCC_SetElementData('ctLocId',ctLocId);
}
function combo_CtLocKeyenterhandler(e){
  try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
  if (keycode==13) {
    combo_CtLocKeydownhandler();
  }
}*/
function DHCC_GetElementData(ElementName){
  var obj=document.getElementById(ElementName);
  if (obj){
    if (obj.tagName=='LABEL'){
      return obj.innerText;
    }else{
      if (obj.type=='checkbox') return obj.checked;
      return obj.value;
    }
  }
  return "";
}
function DHCC_SetElementData(ElementName,value){
  var obj=document.getElementById(ElementName);
  if (obj){
    obj.value=value;
  }
  return "";
}
function find_Click()
{
	var fromDate=DHCC_GetElementData("fromDate")
	var toDate=DHCC_GetElementData("toDate")
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEmReg"+"&fromDate="+fromDate+"&toDate="+toDate;
	window.location=lnk;
}
function print_Click()
{
}
document.body.onload = BodyLoadHandler;	