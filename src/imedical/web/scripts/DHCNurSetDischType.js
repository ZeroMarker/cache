//DHCNurSetDischType.JS
function BodyLoadHandler()
{
	var objGetDischSet=document.getElementById("GetDischSet");
	//alert(objGetDischSet.value)
	if ((objGetDischSet)&&(objGetDischSet.value!=""))
	{
		var DischSetStr=objGetDischSet.value.split("@");
		var objCanDisch=document.getElementById("CanDisch");
		if((objCanDisch)&&(DischSetStr[0]=="Y")) objCanDisch.checked=true;
		var objTransDiscon=document.getElementById("TransDiscon");
		if((objTransDiscon)&&(DischSetStr[1]=="Y")) objTransDiscon.checked=true;
		var objTakeDisDrug=document.getElementById("TakeDisDrug");
		if((objTakeDisDrug)&&(DischSetStr[2]=="Y")) objTakeDisDrug.checked=true;
		var objDiagType=document.getElementById("DiagType");
		if((objDiagType)&&(DischSetStr[3]!="")) {
			 addlistoption(objDiagType,DischSetStr[3],"^");
		}
		var objMustDisconArcim=document.getElementById("MustDisconArcim");
		if((objMustDisconArcim)&&(DischSetStr[4]!="")) {
			 addlistoption(objMustDisconArcim,DischSetStr[4],"^");
		}
		var objNeedOrdCat=document.getElementById("NeedOrdCat");
		if((objNeedOrdCat)&&(DischSetStr[5]!="")) {
			 addlistoption(objNeedOrdCat,DischSetStr[5],"^");
		}
		var objNeedTransOrdCat=document.getElementById("NeedTransOrdCat");
		if((objNeedTransOrdCat)&&(DischSetStr[6]!="")) {
			 addlistoption(objNeedTransOrdCat,DischSetStr[6],"^");
		}
		var objSelOrdDep=document.getElementById("SelOrdDep");
		if((objSelOrdDep)&&(DischSetStr[7]!="")) {
			 addlistoption(objSelOrdDep,DischSetStr[7],"^");
		}
		var objTransLocWardRelation=document.getElementById("TransLocWardRelation");
		if((objTransLocWardRelation)&&(DischSetStr[8]=="Y")) objTransLocWardRelation.checked=true;
		var objLongUnnewExec=document.getElementById("LongUnnewExec");
		if((objLongUnnewExec)&&(DischSetStr[9]=="Y")) objLongUnnewExec.checked=true;	
		var objUnNeedOrdSubCat=document.getElementById("UnNeedOrdSubCat");
		if((objUnNeedOrdSubCat)&&(DischSetStr[10]!="")) {
			 addlistoption(objUnNeedOrdSubCat,DischSetStr[10],"^");
		}
	}
	var obj=document.getElementById('add');
	if (obj) {obj.onclick=add_click;}
	var obj=document.getElementById('update');
	if (obj) {obj.onclick=update_click;}
	var obj=document.getElementById('del');
	if (obj) {obj.onclick=del_click;}
	var obj=document.getElementById('save');
	if (obj) {obj.onclick=save_click;}
	var obj=document.getElementById('DiagType');
	if (obj) {obj.ondblclick=DiagType_Dblclick;}
	var obj=document.getElementById('MustDisconArcim');
	if (obj) {obj.ondblclick=MustDisconArcim_Dblclick;}
	var obj=document.getElementById('NeedOrdCat');
	if (obj) {obj.ondblclick=NeedOrdCat_Dblclick;}
	var obj=document.getElementById('NeedTransOrdCat');
	if (obj) {obj.ondblclick=NeedTransOrdCat_Dblclick;}	
	var obj=document.getElementById('SelOrdDep');
	if (obj) {obj.ondblclick=SelOrdDep_Dblclick;}	
	var obj=document.getElementById('UnNeedOrdSubCat');
	if (obj) {obj.ondblclick=UnNeedOrdSubCat_Dblclick;}
}
function add_click() 
{
  var mthadd=document.getElementById("mthadd").value;
  var txtNo=document.getElementById("txtNo").value;
  var txtAbnormalStat=document.getElementById("txtAbnormalStat").value;
  var txtAlertItem="N";
  var objTxtAlertItem=document.getElementById("txtAlertItem");
  if (objTxtAlertItem.checked==true) txtAlertItem="Y";
  var txtAbnormalSeq=document.getElementById("txtAbnormalSeq").value
  if ((txtNo=="")||(txtAbnormalStat=="")||(txtAlertItem=="")||(txtAbnormalSeq==""))
  {
  	alert (t['alert:null']);
  	return false;
  }
  var res=cspRunServerMethod(mthadd,txtNo,txtAbnormalStat+"^"+txtAlertItem+"^"+txtAbnormalSeq)
  if (res==0){
	    alert(t['alert:success']);
  }
  else
  {
		alert(t['alert:error']);
  }
  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetDischType";
  window.location.href=lnk; 

}
function update_click()
{
  var mthupdate=document.getElementById("mthupdate").value;
  var selrow=document.getElementById("selrow").value;
  if (selrow=="") return;
  var oldNo=document.getElementById("Noz"+selrow).innerText;
  var txtNo=document.getElementById("txtNo").value;
  var txtAbnormalStat=document.getElementById("txtAbnormalStat").value;
  var txtAlertItem="N";
  var objTxtAlertItem=document.getElementById("txtAlertItem");
  if (objTxtAlertItem.checked==true) txtAlertItem="Y";
  var txtAbnormalSeq=document.getElementById("txtAbnormalSeq").value
  if ((txtNo=="")||(txtAbnormalStat=="")||(txtAlertItem=="")||(txtAbnormalSeq==""))
  {
  	alert (t['alert:null']);
  	return false;
  }
  //alert(oldNo+"!"+txtNo+"!"+txtAbnormalStat+"^"+txtAlertItem+"^"+txtAbnormalSeq)
  var res=cspRunServerMethod(mthupdate,oldNo,txtNo,txtAbnormalStat+"^"+txtAlertItem+"^"+txtAbnormalSeq)
  if (res==0)
  {
	alert(t['alert:success']);
  }
  else
  {
    alert(t['alert:error']);
  }
  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetDischType";
  window.location.href=lnk; 

}
function del_click() 
{
    var mthdel=document.getElementById("mthdel").value;
    var selrow=document.getElementById("selrow").value;
    if (selrow=="") return;
    var No=document.getElementById("Noz"+selrow).innerText;
    var res=cspRunServerMethod(mthdel,No);
    if (res==0)
    {
	    alert(t['alert:success']);
	}
	else
	{
		alert(t['alert:error']);
	}
  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetDischType";
  window.location.href=lnk; 
}
function save_click() 
{
	var mthsave=document.getElementById("mthsave").value;
  	var objCanDisch=document.getElementById("CanDisch");
	if((objCanDisch)&&(objCanDisch.checked==true)) var CanDisch="Y";
	else  var CanDisch="N";
	var objTransDiscon=document.getElementById("TransDiscon");
	if((objTransDiscon)&&(objTransDiscon.checked==true)) var TransDiscon="Y";
	else  var TransDiscon="N";
	var objTakeDisDrug=document.getElementById("TakeDisDrug");
	if((objTakeDisDrug)&&(objTakeDisDrug.checked==true)) var TakeDisDrug="Y";
	else  var TakeDisDrug="N";
	var objDiagType=document.getElementById("DiagType");
	if(objDiagType) var DiagType=getListData("DiagType");
	else var DiagType="";
	var objMustDisconArcim=document.getElementById("MustDisconArcim");
	if(objMustDisconArcim) var MustDisconArcim=getListData("MustDisconArcim");
	else var MustDisconArcim="";
	var objNeedOrdCat=document.getElementById("NeedOrdCat");
	if(objNeedOrdCat) var NeedOrdCat=getListData("NeedOrdCat");
	else var NeedOrdCat="";
	var objNeedTransOrdCat=document.getElementById("NeedTransOrdCat");
	if(objNeedTransOrdCat) var NeedTransOrdCat=getListData("NeedTransOrdCat");
	else var NeedTransOrdCat="";
	var objSelOrdDep=document.getElementById("SelOrdDep");
	if(objSelOrdDep) var SelOrdDep=getListData("SelOrdDep");
	else var SelOrdDep="";
	var objTransLocWardRelation=document.getElementById("TransLocWardRelation");
	if((objTransLocWardRelation)&&(objTransLocWardRelation.checked==true)) var TransLocWardRelation="Y";
	else  var TransLocWardRelation="N";
	var objLongUnnewExec=document.getElementById("LongUnnewExec");
	if((objLongUnnewExec)&&(objLongUnnewExec.checked==true)) var LongUnnewExec="Y";	
	else var LongUnnewExec="N";
	var objUnNeedOrdSubCat=document.getElementById("UnNeedOrdSubCat");
	if(objUnNeedOrdSubCat) var UnNeedOrdSubCat=getListData("UnNeedOrdSubCat");
	else var UnNeedOrdSubCat="";
	//alert(CanDisch+"!"+TransDiscon+"!"+TakeDisDrug+"!"+DiagType+"!"+MustDisconArcim+"!"+NeedOrdCat+"!"+NeedTransOrdCat+"!"+SelOrdDep+"!"+TransLocWardRelation+"!"+LongUnnewExec+"!"+UnNeedOrdSubCat);
  	var res=cspRunServerMethod(mthsave,CanDisch+"!"+TransDiscon+"!"+TakeDisDrug+"!"+DiagType+"!"+MustDisconArcim+"!"+NeedOrdCat+"!"+NeedTransOrdCat+"!"+SelOrdDep+"!"+TransLocWardRelation+"!"+LongUnnewExec+"!"+UnNeedOrdSubCat)
  	if (res==0){
	    alert(t['alert:success']);
  	}
  	else
  	{
		alert(t['alert:error']);
  	}
  	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetDischType";
  	window.location.href=lnk; 
}
function getListData(elementName)
{
	var retString
	retString=""
	var listObj=document.getElementById(elementName);
	if(listObj){
		for (var i=0;i<listObj.options.length;i++)
   		{
	   		if (listObj.options[i].value!="")
	   		{
		   		if(retString==""){
			   		retString=listObj.options[i].value
		   		}else{
			   		retString=retString+"^"+listObj.options[i].value
		   		}
	   		}
		}
	}
	return retString
}
 function SelectRowHandler()
 {
    var selrow=document.getElementById("selrow");
    selrow.value=DHCWeb_GetRowIdx(window);
    var No=document.getElementById("Noz"+selrow.value).innerText;
    var AbnormalStat=document.getElementById("AbnormalStatz"+selrow.value).innerText;
    var AlertItem=document.getElementById("AlertItemz"+selrow.value).innerText;
    var AbnormalSeq=document.getElementById("AbnormalSeqz"+selrow.value).innerText;

    var txtNo=document.getElementById("txtNo");
    var txtAbnormalStat=document.getElementById("txtAbnormalStat");
    var txtAlertItem=document.getElementById("txtAlertItem");
    var txtAbnormalSeq=document.getElementById("txtAbnormalSeq");
    
    txtNo.value=No;
    txtAbnormalStat.value=AbnormalStat;
    if (AlertItem=="Y") txtAlertItem.checked=true;
    else txtAlertItem.checked=false;
    txtAbnormalSeq.value=AbnormalSeq;
 }
 
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
function addlistoption(selobj,resStr,del)
{
    var resList=new Array();
    var tmpList=new Array();
    selobj.options.length=0;
    resList=resStr.split(del);
    //alert (selobj.length);
    for (i=0;i<resList.length;i++)
    {
	    tmpList=resList[i].split("!")
	    selobj.add(new Option(tmpList[1],tmpList[0]));
	}
}
function GetMRDiagType(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("MRDiagType");
	if(obj){
		addListRow("DiagType",strValue);
		obj.value=""
	}
}
function GetARCIMDesc(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("ARCIMDesc");
	if(obj){
		addListRow("MustDisconArcim",strValue);
		obj.value=""
	}
}

function GetDischOrdCat(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("DischOrdCat");
	if(obj){
		addListRow("NeedOrdCat",strValue);
		obj.value=""
	}
}
function GetTranOrdCat(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("TranOrdCat");
	if(obj){
		addListRow("NeedTransOrdCat",strValue);
		obj.value=""
	}
}
function GetOrdDep(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("OrdDep");
	if(obj){
		addListRow("SelOrdDep",strValue);
		obj.value=""
	}
}
function GetSelOrdSubCat(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("SelOrdSubCat");
	if(obj){
		addListRow("UnNeedOrdSubCat",strValue);
		obj.value=""
	}
}
function addListRow(elementName,dataValue)
{
	var itemValue=dataValue;  //dataValue.split("^");
	var listObj=document.getElementById(elementName);
	if(listObj){
		for (var i=0;i<listObj.options.length;i++)
   		{
	   		if (listObj.options[i].value==dataValue[1]){
		   		alert(t['alert:sameItem']);
		   		return;
	   		}
		}
	}
    var objSelected = new Option(itemValue[0], itemValue[1]);
	listObj.options[listObj.options.length]=objSelected;
}

function DiagType_Dblclick()
{
	list_Dublclick("DiagType");
}
function MustDisconArcim_Dblclick()
{
	list_Dublclick("MustDisconArcim");
}

function NeedOrdCat_Dblclick()
{
	list_Dublclick("NeedOrdCat");
}

function NeedTransOrdCat_Dblclick()
{
	list_Dublclick("NeedTransOrdCat");
}
function SelOrdDep_Dblclick()
{
	list_Dublclick("SelOrdDep");
}
function UnNeedOrdSubCat_Dblclick()
{
	list_Dublclick("UnNeedOrdSubCat");
}
function list_Dublclick(elementName)
{
  var listObj=document.getElementById(elementName);
  var objSelected=listObj.selectedIndex;
  listObj.remove(objSelected) ;
}

document.body.onload = BodyLoadHandler;
