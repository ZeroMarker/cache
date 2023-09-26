var objTRTmp=null;
var OnBlurColor='';
var OnFocusColor='#CCCCFF';
var BackColor0='#FFFFFF';
var BackColor1='#CCFFFF';
var SaveColor='#99CCFF';
var CommonLateColor='#FF0033';
var DeathLateColor='#CCFF00';
var IsActive="Yes"

//*******************************************************************************************
//清屏按钮操作
//*******************************************************************************************
function btnClear_onclick()
{
	var MrType=getElementValue("txtMrTypeID");
	var CurrFlow=getElementValue("cboWorkFlow");
	var CurrItem=getElementValue("cboWorkItem");
	var IsFinish=(getElementValue("chkFinish") ? "Y" : "N");
	var LocId=getElementValue("txtLocID");
	var WardId=getElementValue("txtWardID");
	var DateFrom=getElementValue("txtDateFrom");
	var DateTo=getElementValue("txtDateTo");
	var IsLocActive=GetParam(window,"IsLocActive");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Circul.MROP&MrType="+MrType+"&CurrFlow="+CurrFlow+"&CurrItem="+CurrItem+"&IsFinish="+IsFinish+"&LocId="+LocId+"&WardId="+WardId+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&IsLocActive="+IsLocActive;
	window.location.href=lnk;
}

//*******************************************************************************************
//查询按钮操作
//*******************************************************************************************
function btnQuery_onclick()
{
	if (document.getElementById("btnQuery").disabled==false)
	{
		QueryVolInfo();
	}
	if (document.getElementById("tDHC_WMR_Circul_MROP").rows.length>1)
	{
		document.getElementById("btnQuery").disabled=true;
		document.getElementById("chkFinish").disabled=true;
	}else{
		document.getElementById("btnQuery").disabled=false;
		document.getElementById("chkFinish").disabled=false;
	}
	if (getElementValue("chkFinish")==true)
	{
		setElementValue("chkSelAll",true);
		chkSelAll_onclick();
	}
}

function QueryVolInfo()
{
	var MrType=getElementValue("txtMrTypeID");
	var WorkFlow=getElementValue("cboWorkFlow");
	var WorkItem=getElementValue("cboWorkItem");
	var Loc=getElementValue("txtLocID");
	var Ward=getElementValue("txtWardID");
	var MrNo=getElementValue("txtMrNo");
	var BarCode=getElementValue("txtBarCode");
	var RegNo=getElementValue("txtRegNo");
	var IsFinish="N";
	if (getElementValue("chkFinish")==true)
	{
		IsFinish="Y";
		var DateFrom=getElementValue("txtDateFrom");
		var DateTo=getElementValue("txtDateTo");
	}else{
		IsFinish="N";
		var DateFrom="";
		var DateTo="";
	}
	
	var strMethod=getElementValue("MethodQryDischVol");
	var ret=cspRunServerMethod(strMethod,MrType,WorkFlow,WorkItem,IsFinish,Loc,Ward,MrNo,BarCode,RegNo,DateFrom,DateTo);
	var retList=ret.split("^");
	var JIndex=retList[0],CIndex=retList[1];
	if ((CIndex<1)||(CIndex=="undefined")) return;
	var strMethod=getElementValue("MethodGetDischVol");
	for (var ind=1;ind<=CIndex;ind++)
	{
		var ret=cspRunServerMethod(strMethod,JIndex,ind);
		AddDataToTable(ret);
	}
}

function AddDataToTable(Info)
{
	var tmpList=Info.split("^");
	if (tmpList.length>=17)
	{
		//MrTypeId^MrTypeDesc^MrNo^IPNo^RegNo^PatName^Paadm^Papmi^LocId^LocDesc^WardId^WardDesc^AdmDate^AdmTime^DischDate^DischTime^VolId^MainId
		var objTable = document.getElementById("tDHC_WMR_Circul_MROP");
		
		if (document.getElementById("VolIdzh"+tmpList[16]))
		{
			alert("编号:"+tmpList[16]+" 数据重复!");
			return;  //VolIdzh不允许重复
		}
		
		objTR=objTable.insertRow();
		objTR.setAttribute("noWrap",true);
		objTR.setAttribute("class","RowOdd");
		var i=objTable.rows.length-1;
		objTR.setAttribute("id","TR"+i);
		objTR.onclick=SetOnClickColor;
		
		var objTH=document.getElementsByTagName("TH");
		for (var Ind=1;Ind<objTH.length;Ind++)
		{
			
			var THDesc=objTH[Ind].innerText;
			var THDesc=THDesc.slice(0,-1);
			switch(THDesc)
			{
				case "选择":
					var tmpHTML='<input id="IsSelz'+i+'" name="IsSelz'+i+'" type="checkbox">';
					tmpHTML=tmpHTML+'<input id="VolIdzh'+tmpList[16]+'" name="VolIdzh'+tmpList[16]+'" type="hidden" value="">';
					tmpHTML=tmpHTML+'<input id="MainIdzh'+i+'" name="MainIdzh'+i+'" type="hidden" value="'+tmpList[17]+'">';
					tmpHTML=tmpHTML+'<input id="IsDeathzh'+i+'" name="IsDeathzh'+i+'" type="hidden" value="'+tmpList[18]+'">';
					tmpHTML=tmpHTML+'<input id="LateDayszh'+i+'" name="LateDayszh'+i+'" type="hidden" value="'+tmpList[19]+'">';
					var objCell = document.createElement("TD");
					objCell.innerHTML=tmpHTML;
					objTR.appendChild(objCell);
					break;
				case "编号":
					var objCell = document.createElement("TD");
					var str='<label id="VolIdz'+i+'" name="VolIdz'+i+'">'+tmpList[16]+'</label>';
					objCell.innerHTML=str;
					objTR.appendChild(objCell);
					break;
				case "病案类型":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="MrTypez'+i+'" name="MrTypez'+i+'">'+tmpList[1]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "登记号":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="RegNoz'+i+'" name="RegNoz'+i+'">'+tmpList[4]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "病案号":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="MrNoz'+i+'" name="MrNoz'+i+'">'+tmpList[2]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "就诊号":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="IPNoz'+i+'" name="IPNoz'+i+'">'+tmpList[3]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "姓名":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="PatNamez'+i+'" name="PatNamez'+i+'">'+tmpList[5]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "科室":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="AdmLocDescz'+i+'" name="AdmLocDescz'+i+'">'+tmpList[9]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "病区":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="WardDescz'+i+'" name="WardDescz'+i+'">'+tmpList[11]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "就诊日期":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="AdmDatez'+i+'" name="AdmDatez'+i+'">'+tmpList[12]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "就诊时间":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="AdmTimez'+i+'" name="AdmTimez'+i+'">'+tmpList[13]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "出院日期":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="DischDatez'+i+'" name="DischDatez'+i+'">'+tmpList[14]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "出院时间":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="DischTimez'+i+'" name="DischTimez'+i+'">'+tmpList[15]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "是否已故":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="IsDeathz'+i+'" name="IsDeathz'+i+'">'+tmpList[18]+'</label>';
					objTR.appendChild(objCell);
					break;
				case "病案状态":
					var objCell = document.createElement("TD");
					objCell.innerHTML='<label id="VolStaDescz'+i+'" name="VolStaDescz'+i+'">'+tmpList[21]+'</label>';
					objTR.appendChild(objCell);
					break;
				default:
					break;
			}
		}
		if ((tmpList[18]=="已故")&&(tmpList[19]!=="0")&&(tmpList[21]=="初始状态")){
			objTR.style.backgroundColor=DeathLateColor;
		}else if ((tmpList[18]!=="已故")&&(tmpList[19]!=="0")&&(tmpList[21]=="初始状态")){
			objTR.style.backgroundColor=CommonLateColor;
		}else if (i%2==0){
			objTR.style.backgroundColor=BackColor0;
		}else{
			objTR.style.backgroundColor=BackColor1;
		}
	}
}

function SetOnClickColor()
{
	if (objTRTmp!==this)
	{
		if (objTRTmp!==null)
		{
			objTRTmp.style.backgroundColor=OnBlurColor;
		}
		objTRTmp=this;
		OnBlurColor=this.style.backgroundColor;
		this.style.backgroundColor=OnFocusColor;
	}else{
		this.style.backgroundColor=OnBlurColor;
		objTRTmp=null;
	}
}

//*******************************************************************************************
//确认按钮操作
//*******************************************************************************************
function btnSave_onclick()
{
	if (objTRTmp!==null)
	{
		objTRTmp.style.backgroundColor=OnBlurColor;
		objTRTmp=null;
	}
	
	var objItemDtl=null;
	var objTable = document.getElementById("tDHC_WMR_Circul_MROP");
	for (var ind=1;ind<objTable.rows.length;ind++)
	{
		var VolId=getElementValue("VolIdz"+ind);
		if (VolId=="") continue;
		if ((getElementValue("IsSelz"+ind)==true)&&(document.getElementById("IsSelz"+ind).disabled==false))
		{
			if (objItemDtl==null) {objItemDtl=GetWorkItemDtl();}
			if (objItemDtl==null) return;
			var VolSta=VolId + "^" + "" + "^" + objItemDtl.WorkItemInfo;
			var FlowId = getElementValue("cboWorkFlow");
			var ItemId=objItemDtl.Rowid;
			var ItemDtl=objItemDtl.ItemDtlInfo;
			var strMethod = document.getElementById("MethodSaveOperation").value;
			var ret = cspRunServerMethod(strMethod,"1",FlowId,ItemId,"",VolId,VolSta,ItemDtl,"");
			
			if (getElementValue("chkPrintBarCode")==true)
			{
				var MrNo=getElementValue("MrNoz"+ind);
				var PatName=getElementValue("PatNamez"+ind);
				PrintMrBarCode(VolId,MrNo,PatName);
			}
			document.getElementById("TR"+ind).style.backgroundColor=SaveColor;
			document.getElementById("IsSelz"+ind).disabled=true;
		}
	}
}

function GetWorkItemDtl()
{
	var objTMP=new Object();
	objTMP.Rowid="";
	objTMP.ItemType="";
	objTMP.Desc="";
	objTMP.IsActive="N";
	objTMP.Resume="";
	objTMP.IsSysOper="N";
	objTMP.IsCheckUser="N";
	objTMP.IsRequest="N";
	objTMP.IsItemDtl="N";
	objTMP.SysOper=null;
	objTMP.CheckUser=null;
	objTMP.ItemDtlInfo="";
	objTMP.WorkItemInfo="";
	
	var ItmRowid=getElementValue("cboWorkItem");
	var strMethod = document.getElementById("MethodGetWorkItemById").value;
	var ret = cspRunServerMethod(strMethod,ItmRowid);
	var tmpList=ret.split("^");
	if (tmpList.length>=8)
	{
		objTMP.Rowid=tmpList[0];
		objTMP.ItemType=tmpList[1];
		objTMP.Desc=tmpList[2];
		objTMP.IsActive=tmpList[3];
		objTMP.Resume=tmpList[4];
		objTMP.IsCheckUser=tmpList[6];
		objTMP.IsRequest=tmpList[7];
		objTMP.IsItemDtl=tmpList[8];
		var strMethod = document.getElementById("MethodGetDicById").value;
		var retsub = cspRunServerMethod(strMethod,tmpList[5]);
		var tmpListSub=retsub.split("^");
		if (tmpListSub.length>=3)
		{
			objTMP.IsSysOper="Y";
			var objDic=new Object();
			objDic.Rowid=tmpListSub[0];
			objDic.Code=tmpListSub[1];
			objDic.Desc=tmpListSub[2];
			objTMP.SysOper=objDic;
		}
	}else{
		return null;
	}
	
	if (objTMP.IsItemDtl=="Y")
	{
		var objItmDtl=GetWorkItemDtlInfo(2);
		objTMP.ItemDtlInfo=SerializeDHCWMRMainStatusDtlArry(objItmDtl);
		if (objTMP.ItemDtlInfo=="") return null;
	}
	
	if (objTMP.IsCheckUser=="Y")
	{
		objTMP.CheckUser=ValidateUser(t["ValidateUser"]);
		if (objTMP.CheckUser==null) return null;
	}
	
	var UserFromId="",UserToId="";
	UserFromId=session['LOGON.USERID'];
	if (objTMP.CheckUser!==null){UserToId=objTMP.CheckUser.RowID;};
	objTMP.WorkItemInfo=objTMP.Rowid + "^" + UserFromId + "^" + "" + "^" + "" + "^" + UserToId;
	
	return objTMP
}

//GetWorkItemDtlInfo
//pos:position in the list
//1-mainStatus 2-volStatus
function GetWorkItemDtlInfo(flag)
{
	var strUrl = "dhc.wmr.workflow.extra.csp?";
	var objReturn = null;
	var arg = "MainStatusRowid=" + 
			"&VolStatusRowid=" + 
			"&WorkItemRowid=" + getElementValue("cboWorkItem") + 
			"&IsEdit=" + "Y" + 
			"&StatusFrom=" + 
			"&StatusTo=" + 
			"&ValidateUser=" + "N" + 
			"&MainRowid=" + 
			"&VolRowid=" + 
			"&flag=" + flag;
	
	objReturn = window.showModalDialog(strUrl + arg,"dialogWidth=300,dialogHeight=500");
	if(objReturn == null) {objReturn = new Array();}
	return objReturn;
}

//*******************************************************************************************
//打印按钮操作
//*******************************************************************************************
function btnPrint_onclick()
{
	var xlTitle=new Array(["登记号","病案号","姓名","科室","病区","出院日期","迟归天数","是否已故"]);
	var xlData=GetTableData();
	if (xlData.length>0)
	{
		var TemplatePath="";
		var strMethod = document.getElementById("MethodGetServerInfo").value;
		TemplatePath = GetWebConfig(strMethod).Path;
		if (TemplatePath==""){
			//alert(t['TemplatePath']);
			return;
		}else{
			var FileName=TemplatePath+"\\\DHCWMRCirculMROP.xls";
			//var FileName="http://172.22.6.101/trakcarelive/trak/med/results/template/\DHCWMRCirculMROP.xls"
			try {
				var xls = new ActiveXObject ("Excel.Application");
			}catch(e) {
				alert("创建Excel应用对象失败!");
				return;
			}
			xls.visible=false;
			
			var xlBook=xls.Workbooks.Add(FileName);
			var xlSheet=xlBook.Worksheets.Item(1);
			var xlCells=fillxlSheet(xlSheet,xlTitle,1,1);
			var xlCells=fillxlSheet(xlSheet,xlData,2,1);
			
			xlSheet.printout();
			xlSheet=null;
			xlBook.Close (savechanges=false);
			xls.Quit();
			xlSheet=null;
			xlBook=null;
			xls=null;
			idTmr=window.setInterval("Cleanup();",1);
		}
	}
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

function GetWebConfig(encmeth){
	var objWebConfig=new Object();
	if (encmeth!=""){
		ret=cspRunServerMethod(encmeth);
		if (ret!=""){
			var TempFileds=ret.split(String.fromCharCode(1));
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
		}
	}else{
		objWebConfig=null;
	}
	return objWebConfig;
}

function GetTableData()
{
	var TableData=new Array();
	var objTable = document.getElementById("tDHC_WMR_Circul_MROP");
	for (var ind=1;ind<objTable.rows.length;ind++)
	{
		if (getElementValue("IsSelz"+ind)==true)
		{
			var RegNo="'" + getElementValue("RegNoz"+ind);
			//var IPNo="'" + getElementValue("IPNoz"+ind);
			var MrNo="'" + getElementValue("MrNoz"+ind);
			var PatName="'" + getElementValue("PatNamez"+ind);
			var AdmLoc="'" + getElementValue("AdmLocDescz"+ind);
			var Ward="'" + getElementValue("WardDescz"+ind);
			var AdmDate="'" + getElementValue("AdmDatez"+ind);
			var AdmTime="'" + getElementValue("AdmTimez"+ind);
			var DischDate="'" + getElementValue("DischDatez"+ind);
			var DischTime="'" + getElementValue("DischTimez"+ind);
			var IsDeath="'" + getElementValue("IsDeathzh"+ind);
			var LateDays="'" + getElementValue("LateDayszh"+ind);
			//var RowData = new Array(RegNo,IPNo,PatName,AdmLoc,Ward,DischDate,LateDays,IsDeath);
			var RowData = new Array(RegNo,MrNo,PatName,AdmLoc,Ward,DischDate,LateDays,IsDeath);
			TableData.push(RowData);
		}
	}
	return TableData;
}

function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	if (Object.prototype.toString.call(cData)=="[object Array]")
	{
		for(var i=0; i<cData.length; ++i)
		{
			for(var j=0; j<cData[i].length; ++j)
			{
				cells(cRow+i,cCol+j).Value = cData[i][j];
				//cells(cRow+i,cCol+j).Borders.Weight = 1;
			}
		}
	}else{
		cells(cRow,cCol).Value = cData;
		//cells(cRow+i,cCol+j).Borders.Weight = 1;
	}
	return cells;
}

//*******************************************************************************************
//取消按钮操作
//*******************************************************************************************
function btnCancel_onclick()
{
	if (objTRTmp!==null)
	{
		objTRTmp.style.backgroundColor=OnBlurColor;
		objTRTmp=null;
	}
	
	var objItemDtl=null;
	var objTable = document.getElementById("tDHC_WMR_Circul_MROP");
	for (var ind=1;ind<objTable.rows.length;ind++)
	{
		var VolId=getElementValue("VolIdz"+ind);
		if (VolId=="") continue;
		if ((getElementValue("IsSelz"+ind)==true)&&(document.getElementById("IsSelz"+ind).disabled==false))
		{
			var FlowId = getElementValue("cboWorkFlow");
			var ItemId = getElementValue("cboWorkItem");
			var UserId = session['LOGON.USERID'];
			var strMethod = document.getElementById("MethodCancelOperation").value;
			var ret = cspRunServerMethod(strMethod,"1",FlowId,ItemId,"",VolId,UserId)
			document.getElementById("TR"+ind).style.backgroundColor=SaveColor;
			document.getElementById("IsSelz"+ind).disabled=true;
		}
	}
}

//*******************************************************************************************
//打印病案卷条码
//*******************************************************************************************
function btnPrintBarCode_onclick()
{
	if (objTRTmp!==null)
	{
		objTRTmp.style.backgroundColor=OnBlurColor;
		objTRTmp=null;
	}
	var objTable = document.getElementById("tDHC_WMR_Circul_MROP");
	for (var ind=1;ind<objTable.rows.length;ind++)
	{
		var VolId=getElementValue("VolIdz"+ind);
		if (VolId=="") continue;
		if ((getElementValue("IsSelz"+ind)==true)&&(document.getElementById("IsSelz"+ind).disabled==false))
		{
			var MrNo=getElementValue("MrNoz"+ind);
			var PatName=getElementValue("PatNamez"+ind);
			PrintMrBarCode(VolId,MrNo,PatName);
			document.getElementById("TR"+ind).style.backgroundColor=SaveColor;
			document.getElementById("IsSelz"+ind).disabled=true;
		}
	}
}
function PrintMrBarCode(VolId,MrNo,PatName)
{
	var objHosptial = GetcurrHospital("MethodGetDefaultHosp");
	if (VolId!=="")
	{
		var BarCode = "02" + formatString(VolId,11);
		var MrTypeDesc=getElementValue("txtMrTypeDesc");
		var ElseString = MrTypeDesc + "(卷)" + CHR_1 + MrNo + CHR_1 + PatName;
		if(BarCode!="")
		{
			var objPrinter = new ActiveXObject("DHCMedWebPackage.clsWMRBarCode")
			objPrinter.PrintWMRBarCode(objHosptial.MyHospitalCode, objHosptial.BarcodePrinter, BarCode, ElseString);
		}
	}
}

//*******************************************************************************************
//初始化
//*******************************************************************************************
function InitForm()
{
	DisplayMrType();
	DisplayLoc();
	DisplayWard();
	DisplayWorkFlow();
	DisplayWorkItem();
	DisplayIsFinish();
	
	InitEvent();
	chkFinish_onclick();
	
	WriteCAB();
}

function InitEvent()
{
	var obj=document.getElementById("cboWorkFlow");
	if (obj) {obj.onchange=cboWorkFlow_onchange;}
	var obj=document.getElementById("cboWorkItem");
	if (obj) {obj.onchange=cboWorkItem_onchange;}
	
	var obj=document.getElementById("txtLocDesc");
	if (obj) {obj.onchange=txtLocDesc_onchange;}
	var obj=document.getElementById("txtWardDesc");
	if (obj) {obj.onchange=txtWardDesc_onchange;}
	
	var obj=document.getElementById("chkFinish");
	if (obj) {obj.onclick=chkFinish_onclick;}
	var obj=document.getElementById("chkSelAll");
	if (obj) {obj.onclick=chkSelAll_onclick;}
	
	var obj=document.getElementById("btnQuery");
	if (obj) {obj.onclick=btnQuery_onclick;}
	var obj=document.getElementById("btnClear");
	if (obj) {obj.onclick=btnClear_onclick;}
	var obj=document.getElementById("btnSave");
	if (obj) {obj.onclick=btnSave_onclick;}
	var obj=document.getElementById("btnPrint");
	if (obj) {obj.onclick=btnPrint_onclick;}
	var obj=document.getElementById("btnCancel");
	if (obj) {obj.onclick=btnCancel_onclick;}
	var obj=document.getElementById("btnPrintBarCode");
	if (obj) {obj.onclick=btnPrintBarCode_onclick;}
	
	var obj=document.getElementById("txtMrNo");
	if (obj) {obj.onkeydown=txtMrNo_onkeydown;}
	var obj=document.getElementById("txtBarCode");
	if (obj) {obj.onkeydown=txtBarCode_onkeydown;}
	var obj=document.getElementById("txtRegNo");
	if (obj) {obj.onkeydown=txtRegNo_onkeydown;}
}


function DisplayWorkFlow()
{
	var obj=document.getElementById("cboWorkFlow");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.length=0;
		
		
		var MrTypeRowid = document.getElementById("txtMrTypeID").value;
		var UserGroupId = session['LOGON.GROUPID'];
		var strMethod = document.getElementById("MethodGetWorkFlowsByUserGroup").value;
		var ret = cspRunServerMethod(strMethod,MrTypeRowid,UserGroupId);
		if (ret=="") return;
		var tmpList=ret.split("$");
		for (var ind=0;ind<tmpList.length;ind++)
		{
			var tmpListSub=tmpList[ind].split("^");
			var objItm=document.createElement("OPTION");
			obj.options.add(objItm);
			objItm.innerText = tmpListSub[1];
			objItm.value = tmpListSub[0];
		}
		if (tmpList.length>0){obj.selectedIndex=0;}
		var CurrFlow=GetParam(window,"CurrFlow");
		if (CurrFlow!=="")
		{
			for (var i=0;i<obj.length;i++)
			{
				if (obj.options[i].value==CurrFlow)
				{
					obj.selectedIndex=i;
				}
			}
		}
	}
}

function DisplayWorkItem()
{
	var obj=document.getElementById("cboWorkItem");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.length=0;
		
		
		var WFlowRowid = getElementValue("cboWorkFlow");
		var UserGroupId = session['LOGON.GROUPID'];
		var strMethod = document.getElementById("MethodGetWorkItemsByUserGroup").value;
		var ret = cspRunServerMethod(strMethod,WFlowRowid,UserGroupId);
		if (ret=="") return;
		var tmpList=ret.split("$");
		for (var ind=0;ind<tmpList.length;ind++)
		{
			var tmpListSub=tmpList[ind].split("^");
			var objItm=document.createElement("OPTION");
			obj.options.add(objItm);
			objItm.innerText = tmpListSub[1];
			objItm.value = tmpListSub[0];
		}
		if (tmpList.length>0){obj.selectedIndex=0;}
		var CurrItem=GetParam(window,"CurrItem");
		if (CurrItem!=="")
		{
			for (var i=0;i<obj.length;i++)
			{
				if (obj.options[i].value==CurrItem)
				{
					obj.selectedIndex=i;
				}
			}
		}
	}
}

function DisplayLoc()
{
	document.getElementById("txtLocID").value="";
	document.getElementById("txtLocDesc").value="";
	var LocRowid = GetParam(window,"LocId");
	if (LocRowid=="")
	{
		if (GetParam(window,"IsLocActive")=="Y")
		{
			document.getElementById("txtLocDesc").disabled=false;
		}else{
			document.getElementById("txtLocDesc").disabled=true;
			if (LocRowid==""){LocRowid = session['LOGON.CTLOCID'];}
		}
	}
	if (LocRowid=="") return;
	var strMethod = document.getElementById("MethodGetLoc").value;
	var ret = cspRunServerMethod(strMethod,LocRowid);
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("txtLocID").value=tmpList[0];
		document.getElementById("txtLocDesc").value=tmpList[2];
	}
}

function DisplayWard()
{
	var WardRowid = GetParam(window,"WardId");
	if (WardRowid=="") return;
	var strMethod = document.getElementById("MethodGetWard").value;
	var ret = cspRunServerMethod(strMethod,WardRowid);
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("txtWardID").value=tmpList[0];
		document.getElementById("txtWardDesc").value=tmpList[2];
	}
}

function DisplayMrType()
{
	var DicRowid = document.getElementById("txtMrTypeID").value;
	var strMethod = document.getElementById("MethodGetDicById").value;
	var ret = cspRunServerMethod(strMethod,DicRowid);
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("txtMrTypeID").value=tmpList[0];
		document.getElementById("txtMrTypeDesc").value=tmpList[2];
	}
}

function DisplayIsFinish()
{
	var IsFinish=GetParam(window,"IsFinish");
	if (IsFinish=="Y")
	{
		setElementValue("chkFinish",true);
	}else{
		setElementValue("chkFinish",false);
	}
}

function LookUpLoc(str)
{
	var tmpLoc=str.split("^");
	var obj=document.getElementById("txtLocID");
	if (obj){
		if (tmpLoc.length>=0){
			obj.value=tmpLoc[0];
		}else{
			obj.value="";
		}
	}
	var obj=document.getElementById("txtLocDesc");
	if (obj){
		if (tmpLoc.length>=1){
			obj.value=tmpLoc[1];
		}else{
			obj.value="";
		}
	}
}

function LookUpWard(str)
{
	var tmpWard=str.split("^");
	var obj=document.getElementById("txtWardID");
	if (obj){
		if (tmpWard.length>=0){
			obj.value=tmpWard[0];
		}else{
			obj.value="";
		}
	}
	var obj=document.getElementById("txtWardDesc");
	if (obj){
		if (tmpWard.length>=1){
			obj.value=tmpWard[1];
		}else{
			obj.value="";
		}
	}
}

function txtLocDesc_onchange()
{
	if (document.getElementById("txtLocDesc").innerText=="")
	{
		var obj=document.getElementById("txtLocID");
		if (obj){obj.value="";}
	}
}

function txtWardDesc_onchange()
{
	if (document.getElementById("txtWardDesc").innerText=="")
	{
		var obj=document.getElementById("txtWardID");
		if (obj){obj.value="";}
	}
}

function chkFinish_onclick()
{
	if (getElementValue("chkFinish")==true)
	{
		document.getElementById("btnSave").disabled=true;
		document.getElementById("btnPrint").disabled=false;
		document.getElementById("btnCancel").disabled=false;
		document.getElementById("btnPrintBarCode").disabled=false;
		document.getElementById("txtDateFrom").disabled=false;
		document.getElementById("txtDateTo").disabled=false;
	}else{
		document.getElementById("btnSave").disabled=false;
		document.getElementById("btnPrint").disabled=true;
		document.getElementById("btnCancel").disabled=true;
		document.getElementById("btnPrintBarCode").disabled=true;
		document.getElementById("txtDateFrom").disabled=true;
		document.getElementById("txtDateTo").disabled=true;
	}
}

function cboWorkItem_onchange()
{
	btnClear_onclick();
}

function cboWorkFlow_onchange()
{
	DisplayWorkItem();
	btnClear_onclick();
}

function SetBarCodeLength()
{
	var obj=document.getElementById('txtBarCode');
	if (obj)
	{
		var BarCode=obj.value;
		var tmpCode=BarCode.slice(0,1);
		if (((tmpCode=="01")||(tmpCode=="02"))&&(BarCode.length>=13))
		{
			obj.value=BarCode;
		}else{
			obj.value="";
		}
	}
}

function txtMrNo_onkeydown()
{
	if(window.event.keyCode != 13) return;
	setElementValue("txtBarCode","");
	setElementValue("txtRegNo","");
	if (getElementValue("txtMrNo")=="") return;
	QueryVolInfo();
	setElementValue("txtMrNo","");
	document.getElementById("chkFinish").disabled=true;
	return false;
}

function txtRegNo_onkeydown()
{
	if(window.event.keyCode != 13) return;
	setElementValue("txtMrNo","");
	setElementValue("txtBarCode","");
	if (getElementValue("txtRegNo")=="") return;
	QueryVolInfo();
	setElementValue("txtRegNo","");
	document.getElementById("chkFinish").disabled=true;
	return false;
}

function txtBarCode_onkeydown()
{
	if(window.event.keyCode != 13) return;
	SetBarCodeLength();
	setElementValue("txtMrNo","");
	setElementValue("txtRegNo","");
	if (getElementValue("txtBarCode")=="") return;
	QueryVolInfo();
	setElementValue("txtBarCode","");
	document.getElementById("chkFinish").disabled=true;
	return false;
}

function chkSelAll_onclick()
{
	var SelFlg=getElementValue("chkSelAll");
	var objTable = document.getElementById("tDHC_WMR_Circul_MROP");
	for (var ind=1;ind<objTable.rows.length;ind++)
	{
		if (document.getElementById("IsSelz"+ind).disabled==false)
		{
			setElementValue("IsSelz"+ind,SelFlg);
		}
	}
}

function WriteCAB()
{
    var encmeth=document.getElementById("MethodGetWebPackage").value;
    var sObject=cspRunServerMethod(encmeth);
    var objTable = document.getElementsByTagName("TABLE")[0];
    if (objTable)
    {
    	objTable.rows[0].cells[0].appendChild(document.createElement(sObject));
    }
}

InitForm();