/**
@author: wanghc
//@date: 2012/3/17
//@desc: 增加一种图表类型
*/
var f=document.fDHCCsp_Edit_Profile;
function UpdateClickHandler(e){
	setParameters()
	return update1_click()
}
function setParameters()
{
	var cspNameValue = "";
	var cspRefreshTypeValue = "";
	var workflowValue = "";
	if (f.cspName){cspNameValue = f.cspName.value;}
	if (f.cspRefreshType){cspRefreshTypeValue = f.cspRefreshType.checked == true ? 1 : 0;}
	if (f.workflow){workflowValue = f.workflow.value;}
	f.PPParameters.value= cspNameValue + "^" + cspRefreshTypeValue+"^"+workflowValue;
}
function LookUpDHCCspProfileName(val){
	var ary = val.split("^");
	f.elements['ID'].value=ary[1];
	var evt;
	var gp = document.getElementById('getParams')
	if(document.createEvent){
		evt = document.createEvent("MouseEvents");
		evt.initMouseEvent("change", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
		 gp.dispatchEvent(evt);
	}else{	//ie6,ie7,ie8
		evt = document.createEventObject();
		gp.fireEvent("onchange",evt);
	}
}
function LookUpWorkflow(val){
	var ary = val.split("^");	
	//f.elements['workflowid'].value = ary[1];
	f.elements['cspName'].value = "websys.csp?TWKFL="+ary[1]+"&TWKFLI="
}
function getParams_changehandler(encmeth){
	if (cspRunServerMethod(encmeth,'AddParams',f.elements['ID'].value))	{
	}
}
function AddParams(str){
	var arr = str.split("^");
	if(f.cspName) {
		f.cspName.value = arr[0];
		if(arr.length>2) f.workflow.value = arr[2];
		else f.workflow.value="";
	}
	if (arr[1] == 1) {f.cspRefreshType.checked = true;} else {f.cspRefreshType.checked=false;}
	
}
