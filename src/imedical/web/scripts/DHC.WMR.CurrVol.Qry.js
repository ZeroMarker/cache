function InitFrom()
{
	DisplayWorkItems();
	DisplayMrType();
	
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=cmdQuery_click;}
	var obj=document.getElementById("StatusDr")
	if (obj){
		obj.onchange=Status_Change;
	}
}
function Status_Change(){
	var MrType=getElementValue("MrTypeDr");
	var DDlStatus=document.getElementById("StatusDr");
	if (DDlStatus){
		var value=DDlStatus.options[DDlStatus.selectedIndex].value;	
	    var isLastStatus=tkMakeServerCall("web.DHCWMRVolumeCtl","IsLastStatus",MrType,value);
	    var cmdBatchUpdateObj=document.getElementById("cmdBatchUpdate");
		if (cmdBatchUpdateObj){
			    if (isLastStatus==1){
					 cmdBatchUpdateObj.style.visibility="hidden";
			    }else {
					 cmdBatchUpdateObj.style.visibility="visible";	   
				}
		 }
   }
}
function DisplayMrType()
{
	var DicRowid = GetParam(window,"MrType");
	var strMethod = document.getElementById("MethodGetDicItem").value;
	var ret = cspRunServerMethod(strMethod,DicRowid);
	if (ret=="") return;
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("MrTypeDr").value=tmpList[0];
		document.getElementById("txtMrType").value=tmpList[2];
	}
}

function DisplayWorkItems()
{
	var obj=document.getElementById("StatusDr");
	if (obj)
	{
		obj.size=1;
		obj.multiple=false;
		
		var ItemStr = GetParam(window,"ItemStr");
		if (ItemStr=="") return;
		obj.length=0;
		var tmpList=ItemStr.split("|");
		var strMethod = document.getElementById("MethodGetItemById").value;
		for (var i=0;i<tmpList.length;i++)
		{
			if (tmpList[i]=="") continue;
	    	var ret=cspRunServerMethod(strMethod,tmpList[i]);
	    	if (ret=="") continue;
	    	tmpListSub=ret.split("^");
	    	var objItm=document.createElement("OPTION");
			obj.options.add(objItm);
			objItm.innerText = tmpListSub[2];
			objItm.value = tmpListSub[0];
    		}
    		if (tmpList.length>0) (obj.selectedIndex=0);
	}
}

function cmdQuery_click()
{
	var StatusDr=getElementValue("StatusDr");
	var MrTypeDr=getElementValue("MrTypeDr");
	var OperStartDate=getElementValue("operStartDate");
	var OperEndDate=getElementValue("operEndDate");
	var argLocRowid=getElementValue("cLocRowid");		//add 2010-12-08
	var argWardRowid=getElementValue("cWardRowid");	//add 2010-12-08
	var PrintFlag="";
	var UserTo=getElementValue("UserTo");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.CurrVol.List"+"&MrTypeDr=" +MrTypeDr+ "&StatusDr=" +StatusDr+"&OperStartDate="+OperStartDate+"&OperEndDate="+OperEndDate +"&argLocRowid="+argLocRowid+"&argWardRowid="+argWardRowid+"&PrintFlag="+PrintFlag+"&Recipient="+UserTo;
    parent.RPbottom.location.href=lnk;
}
/*
function testPrint_click()
{
	var OperStartDate=getElementValue("operStartDate");
	var OperEndDate=getElementValue("operEndDate");
	//DHCCPM_RunQianComm
	//var  filename = '{FindInvDepNo.raq('+'StartDate='+OperStartDate+';EndDate='+OperEndDate+')}';
	//var filename="{DHCMedQryICDDXByAlias.raq(Alias=DD)}";
	//var filename="{DHCMedQryICDDXByAlias.raq(Alias=DD;)}";
	var filename="DHCMedDMReport.raq&reportId=3";
	//var filename="controltest.raq"
	DHCCPM_RQPrint(filename);
    //DHCCPM_RQDirectPrint(filename);
    ///alert(filename);
    //DHCCPM_RQDirectPrint(filename);
}
*/
///////////////////////add by liuxuefeng 2009-12-05///////Start///////////////////
function InitEvents()
{
	var obj=document.getElementById("cmdExport");
	if (obj) {obj.onclick=cmdExport_onclick;}
	var obj=document.getElementById("cmdPrint");
	if (obj) {obj.onclick=cmdPrint_onclick;}
	var obj=document.getElementById("cmdBatchUpdate");//add 2010-12-06
	if(obj) obj.onclick = cmdBatchUpdate;	//add 2010-12-06
	//add 2010-12-08
	var objLocDesc=document.getElementById("cLocDesc");
	if (objLocDesc){objLocDesc.onchange=LocDesc_onChange;}
	var objWardDesc=document.getElementById("cWardDesc");
	if (objWardDesc){objWardDesc.onchange=WardDesc_onChange;}
	var btnTest=document.getElementById("btnTestPrint");
	if (btnTest){btnTest.onclick=testPrint_click;}
	
}
function cmdExport_onclick()
{ 	
	var objLnk=parent.RPbottom;
	var MrTypeDr=GetParam(objLnk,"MrTypeDr");
	var StatusDr=GetParam(objLnk,"StatusDr");
	var OperStartDate=GetParam(objLnk,"OperStartDate");
	var OperEndDate=GetParam(objLnk,"OperEndDate");
	//add 2010-12-08
	var argLocRowid=GetParam(objLnk,"argLocRowid");
	var argWardRowid=GetParam(objLnk,"argWardRowid");
	var PrintFlag="Y";
	
	var cArguments=MrTypeDr+"^"+StatusDr+"^"+OperStartDate+"^"+OperEndDate+"^"+argLocRowid+"^"+argWardRowid+"^"+PrintFlag;
	//alert(cArguments);
	var flg=ExportDataToExcel("MethodGetServer","MethodGetData","DHCWMRCurrStatusList.xls",cArguments);
}

function cmdPrint_onclick()
{
	var objLnk=parent.RPbottom;
	var MrTypeDr=GetParam(objLnk,"MrTypeDr");
	var StatusDr=GetParam(objLnk,"StatusDr");
	var OperStartDate=GetParam(objLnk,"OperStartDate");
	var OperEndDate=GetParam(objLnk,"OperEndDate");
	//add 2010-12-08
	var argLocRowid=GetParam(objLnk,"argLocRowid");
	var argWardRowid=GetParam(objLnk,"argWardRowid");
	var PrintFlag="Y";
	
	var cArguments=MrTypeDr+"^"+StatusDr+"^"+OperStartDate+"^"+OperEndDate+"^"+argLocRowid+"^"+argWardRowid+"^"+PrintFlag;
	//alert(cArguments);
	var flg=PrintDataByExcel("MethodGetServer","MethodGetData","DHCWMRCurrStatusList.xls",cArguments);
}
window.onload=function(){
///////////////////////add by liuxuefeng 2009-12-05/////End/////////////////////
   InitFrom();
   InitEvents();	//add by liuxuefeng 2009-12-05
}
///////////////////////add by liuxuefeng 2010-12-06////Start////////////////////

function cmdBatchUpdate()
{
		if(window.confirm("是否批量执行此流通操作?") != true)
		{
			return false;
		}
		var objLnk=parent.RPbottom;
		var MrType=GetParam(objLnk,"MrTypeDr");
		var CurrStatus=GetParam(objLnk,"StatusDr");
		var UserID=session['LOGON.USERID'];
		var LocID=session['LOGON.CTLOCID'];
	    var objTable = parent.RPbottom.document.getElementById("tDHC_WMR_CurrVol_List"); 
	    var VolRowidStr="";
	    var objItm=null;
	    var VolRowid="";
	    if (objTable.rows.length<2) 
	    {
	  	  alert("请您首先选择条件进行查询!");
	  	  return false;
	    }
    for(var i = 1; i < objTable.rows.length; i ++)
    {
    		objItm=parent.RPbottom.document.getElementById("chkItemz" + i);
    		if (objItm.checked==true)
    		{
    			VolRowid=parent.RPbottom.document.getElementById("VolRowidz" + i).value;
    			VolRowidStr = VolRowidStr + VolRowid + "*";
    		}
    } 
  if (VolRowidStr=="")
  {
  	alert("请选择您要处理的病案卷项目!");
  	return false;
  }
	var ret=tkMakeServerCall("web.DHCWMRVolumeCtl","BatchUpdateVolStatus",MrType, CurrStatus, UserID, LocID, VolRowidStr);
	if (ret<0){
		alert("批量处理错误!");
	}else{
		alert("批量处理成功!");
	}
	parent.RPbottom.location.reload();
}

///////////////////add 2010-12-08/////////////////////////

function LookUpLocDesc(tmp)
{
	var tmpList=tmp.split("^");
	var objLocDesc=document.getElementById("cLocDesc");
	if (objLocDesc){objLocDesc.value=tmpList[0];}
	var objLocRowid=document.getElementById("cLocRowid");
	if (objLocRowid){objLocRowid.value=tmpList[1];}
}

function LookUpWardDesc(tmp)
{
	var tmpList=tmp.split("^");
	var objWardDesc=document.getElementById("cWardDesc");
	if (objWardDesc){objWardDesc.value=tmpList[0];}
	var objWardRowid=document.getElementById("cWardRowid");
	if (objWardRowid){objWardRowid.value=tmpList[1];}
}

function LocDesc_onChange()
{
	var objWardDesc=document.getElementById("cWardDesc");
	if (objWardDesc){objWardDesc.innerText="";}
	var objWardRowid=document.getElementById("cWardRowid");
	if (objWardRowid){objWardRowid.value="";}
	
	var objLocRowid=document.getElementById("cLocRowid");
	if (objLocRowid){objLocRowid.value="";}
}

function WardDesc_onChange()
{
	//var objWardDesc=document.getElementById("cWardDesc");
	//if (objWardDesc){objWardDesc.innerText="";}
	var objWardRowid=document.getElementById("cWardRowid");
	if (objWardRowid){objWardRowid.value="";}
}
