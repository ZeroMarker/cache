function BodyLoadHandler()
{    
	//科室	
	//var DeptStr=DHCC_GetElementData('DeptStr');
	//combo_DeptList=dhtmlXComboFromStr("WardList",DeptStr);
	//combo_DeptList.enableFilteringMode(true);
	//combo_DeptList.selectHandle=combo_DeptListKeydownhandler;
	//combo_DeptList.keyenterHandle=combo_DeptListKeyenterhandler;
	//combo_DeptList.attachEvent("onKeyPressed",combo_DeptListKeyenterhandler)
	
	var objDep=document.getElementById("WardList");
	if (objDep) {objDep.disabled=true;}
    //护士
    combo_DocList=dhtmlXComboFromSelect("NurseDesc");
    combo_DocList.selectHandle=combo_DocListKeydownhandler;
	combo_DocList.keyenterHandle=combo_DocListtKeyenterhandler;
    combo_DocList.attachEvent("onKeyPressed",combo_DocListtKeyenterhandler)
	
	//护士2
    combo_DocList2=dhtmlXComboFromSelect("NurseDesc2");
    combo_DocList2.selectHandle=combo_DocList2Keydownhandler;
	combo_DocList2.keyenterHandle=combo_DocList2Keyenterhandler;
    combo_DocList2.attachEvent("onKeyPressed",combo_DocList2Keyenterhandler)
    
	obj=document.getElementById("BtUpdate");
	if (obj){obj.onclick=BtUpdate_Click;}
	var GetWardNurseObj=DHCC_GetElementData("GetWardNurse");
	if(GetWardNurseObj)
	{
		var EpisodeIdVal=DHCC_GetElementData("EpisodeId");
		if (EpisodeIdVal!="")
		{
			var RetWardNurse=cspRunServerMethod(GetWardNurseObj,EpisodeIdVal);
			if(RetWardNurse!="")
			{
				var WardNurse=RetWardNurse.split("^");
				if(WardNurse[0]!="") DHCC_SetElementData('WardList',WardNurse[0])
				if(WardNurse[1]!="") DHCC_SetElementData('DepRowId',WardNurse[1])
				if(WardNurse[1]!="") SetDocStr(WardNurse[1])
				if(WardNurse[2]!="") DHCC_SetElementData('NurseDesc',WardNurse[2])
				if(WardNurse[3]!="") DHCC_SetElementData('NurRowId',WardNurse[3])
				if(WardNurse[4]!="") DHCC_SetElementData('NurseDesc2',WardNurse[4])
				if(WardNurse[5]!="") DHCC_SetElementData('NurRowId2',WardNurse[5])
			}
		}
	}
}
function combo_DeptListKeydownhandler(){
  var obj=combo_DeptList;
  var DepRowId=obj.getActualValue();
  var DepDesc=obj.getSelectedText();
  DHCC_SetElementData('DepRowId',DepRowId);
  if(DepRowId!="")
  {
	  SetDocStr(DepRowId);
  }
  else
  {
	  alert(t['alert:selectCtLoc'])
  }
}
function combo_DeptListKeyenterhandler(e){
  try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
  if (keycode==13) {
    combo_DeptListKeydownhandler();
  }
}
function combo_DocListKeydownhandler(){
	var obj=combo_DocList;
	var DocRowId=obj.getActualValue();
	var DocDesc=obj.getSelectedText();
	DHCC_SetElementData('NurRowId',DocRowId);
}
function combo_DocListtKeyenterhandler(e){
  try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
  if (keycode==13) {
    combo_DocListKeydownhandler();
  }
}
function combo_DocList2Keydownhandler(){
	var obj=combo_DocList2;
	var DocRowId=obj.getActualValue();
	var DocDesc=obj.getSelectedText();
	DHCC_SetElementData('NurRowId2',DocRowId);
}
function combo_DocList2Keyenterhandler(e){
  try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
  if (keycode==13) {
    combo_DocList2Keydownhandler();
  }
}
function SetDocStr(DepRowId)
{
	var obj=combo_DocList;
	var obj2=combo_DocList2;
	var DocStr=""
	var objNur=DHCC_GetElementData("GetNurStr");
	if(objNur)
	{
		var NurStr=cspRunServerMethod(objNur,DepRowId);
	}
	//if(DocStr!="") 
	//{
		obj.addOptionStr(NurStr);
		obj2.addOptionStr(NurStr)
	//}

}
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
function BtUpdate_Click()
{
	
	
	
	var type=tkMakeServerCall("Nur.DoctorOrderSheet","getCtcpType",session['LOGON.USERID'])
	if(type!="NURSE"){
		alert("医护人员不是NURSE,不能更新主管护士医生")
		return;
	}
	var EpisodeIdVal=DHCC_GetElementData("EpisodeId");
	var NurRowIdVal=DHCC_GetElementData("NurRowId");
	var NurRowIdVal2=DHCC_GetElementData("NurRowId2");
	var BtUpdateObj=DHCC_GetElementData("UpdateMainNurse");
	if(BtUpdateObj){
		if((EpisodeIdVal!="")&(NurRowIdVal!=""))
		{
			var RetStr=cspRunServerMethod(BtUpdateObj,EpisodeIdVal,NurRowIdVal,NurRowIdVal2);
			if(RetStr=="0")
			{
				alert(t["alert:Success"]);
				//return;
				//var lnk="epr.default.csp";
				//window.location=lnk;
			}
			else
			{
				alert(t["alert:False"])
			}
		}
		else
		{
			alert(t["alert:NoSelectUser"])
		}
	}
	
	 self.location.reload();
}

document.body.onload = BodyLoadHandler;	