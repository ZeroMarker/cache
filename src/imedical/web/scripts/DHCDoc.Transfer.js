var SelectedRow = 0;
function BodyLoadHandler()
{     
	//科室	
	var DeptStr=DHCC_GetElementData('DeptStr');
	//alert(DeptStr)
	combo_DeptList=dhtmlXComboFromStr("DeptList",DeptStr);
	combo_DeptList.enableFilteringMode(true);
	combo_DeptList.selectHandle=combo_DeptListKeydownhandler;
	combo_DeptList.keyenterHandle=combo_DeptListKeyenterhandler;
	combo_DeptList.attachEvent("onKeyPressed",combo_DeptListKeyenterhandler)
  //医生
  combo_DocList=dhtmlXComboFromSelect("DocDesc");
    

  combo_DocList.selectHandle=combo_DocListKeydownhandler;
	combo_DocList.keyenterHandle=combo_DocListtKeyenterhandler;
  combo_DocList.attachEvent("onKeyPressed",combo_DocListtKeyenterhandler)
  SetDocStr(session['LOGON.CTLOCID'],"")
    
	
	obj=document.getElementById("SelectAll");
	if (obj){obj.onclick=SelectAll_Click;}
	obj=document.getElementById("BtUpdate");
	if (obj){obj.onclick=BtUpdate_Click;}
}
function combo_DeptListKeydownhandler(){
  var obj=combo_DeptList;
  var DepRowId=obj.getActualValue();
  var DepDesc=obj.getSelectedText();
  DHCC_SetElementData('DepRowId',DepRowId);
  // if(DepRowId!="")
  //{
	  combo_DocList.clearAll(true);
	  SetDocStr(DepRowId,"");
	  DHCC_SetElementData('DocRowId','');
 // }
  //else
  //{
//	  alert(t['alert:selectCtLoc'])
 // }
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
	DHCC_SetElementData('DocRowId',DocRowId);
}
function combo_DocListtKeyenterhandler(e){
  try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
  if (keycode==13) {
    combo_DocListKeydownhandler();
  }
}
function SetDocStr(DepRowId,MarkRowId)
{
	var obj=combo_DocList;
	var DocStr=""
	var EpisodeID=DHCC_GetElementData("EpisodeID")
	var objDoc=DHCC_GetElementData("GetDocStr");
	if(objDoc)
	{
		var DocStr=cspRunServerMethod(objDoc,DepRowId,EpisodeID);
	}
	//if(DocStr!="") 
	//{
		obj.addOptionStr(DocStr)
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
function SelectAll_Click()
{
  var obj=document.getElementById("SelectAll");
  var Objtbl=document.getElementById('tDHCDoc_Transfer');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('Selectz'+i);  
	selobj.checked=obj.checked;  
	}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCDoc_Transfer');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var ReferralLink='Selectz'+selectrow;
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	if (eSrc.id==ReferralLink)	{
		if(selobj.checked==true){selobj.checked=false;}
		else{selobj.checked=true;}
	}
	var selobj=document.getElementById('Selectz'+selectrow);
	if(selobj.checked==true){selobj.checked=false;}
	else{
		for (var i=1;i<rows;i++)
    {
			var selobj=document.getElementById('Selectz'+i); 
			if((selobj.checked==true)&&(i!=selectrow)){
				//alert("每次请选择一行!");
				//return;
			}	
		}
		var selobj=document.getElementById('Selectz'+selectrow);
		selobj.checked=true;
		var DepRowId=DHCC_GetElementData("DepRowId")
		if (DepRowId==""){
			/*alert("请先选择科室");
			SelectedRow=0;
			var selobj=document.getElementById('Selectz'+selectrow);
			selobj.checked=false;
			return;*/
		}
		var MarkDr="";
		var MarkDrObj=document.getElementById('MarkDrz'+selectrow);
		if (MarkDrObj)MarkDr=MarkDrObj.value;
		SetDocStr(DepRowId,MarkDr);
		
		SelectedRow = selectrow;
	}
	
	//SelectedRow = selectrow;
}
function BtUpdate_Click()
{
	var DocRowId=DHCC_GetElementData("DocRowId")
	var DepRowId=DHCC_GetElementData("DepRowId")
	//DepRowId=session['LOGON.CTLOCID']
	var UserID=DHCC_GetElementData("UserID")
	var GetCareDrByUserID=DHCC_GetElementData("GetCareDrByUserID")
	var CareId=cspRunServerMethod(GetCareDrByUserID,UserID);
	if(CareId==DocRowId)
	{
		alert(t['alert:Different'])
		return;
	}
	var AdmIdStr=DHCC_GetElementData("EpisodeID") //getAdmStr()
	if(DepRowId=="")
	{
		alert(t['alert:selectCtLoc'])
		return
	}
	if(DocRowId=="")
	{
		alert(t['alert:selectDoc'])
		return
	}
	if(AdmIdStr=="")
	{
		alert(t['alert:selectPatient'])
		return
	}
	if (SelectedRow==0)
	{
		//alert("请选择行!")
		//return
	}
	//alert(DepRowId+"^"+DocRowId+"^"+AdmIdStr)
	var objUpdate=DHCC_GetElementData("UpdateTransfer")
	var Ret=cspRunServerMethod(objUpdate,DepRowId,DocRowId,AdmIdStr);
	var RetArray=Ret.split("^")
	var RetString=""
	for(var i=0;i<RetArray.length;i=i+1)
	{
		var RetArrayArr=RetArray[i].split("!")
		if((RetArrayArr[1]!=0)||(RetArrayArr[2]!=0)||(RetArrayArr[3]!=0)||(RetArrayArr[4]!=0)||(RetArrayArr[5]!=0))
		{
			RetString=RetString+RetArrayArr[0]+" "
		}
		
	}
	//if (RetString!=""){alert(RetString);return}
	if (RetString!=""){
		RetString=RetString+",转诊失败!" //t['alert:failure']
		alert(RetString)
	}else{
		alert(t['alert:susccess'])
		window.close();
	}
	//alert(Ret);
	/*if(Ret!="")
	{
		alert("OK")
		window.close();
	}
	else
	{
		alert("error")	
	}
	window.location.reload()*/
}
function getAdmStr()
{
	var Objtbl=document.getElementById('tDHCDoc_Transfer');
    var retstr=""
    var Rows=Objtbl.rows.length;
    for (var i=1;i<Rows;i++)
    {
	var selobj=document.getElementById('Selectz'+i);  
	if(selobj.checked==true)
	{
		var AdmID=document.getElementById('AdmIDz'+i).innerText
		if(retstr=="")
		{
			retstr=AdmID
		}
		else
		{
			retstr=retstr+"^"+AdmID
		}
	}  
	}
	return retstr
}
document.body.onload = BodyLoadHandler;	