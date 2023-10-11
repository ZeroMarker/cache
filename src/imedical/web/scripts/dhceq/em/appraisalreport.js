/// 设备鉴定报告
/// ../scripts/dhceq/em/appraisalreport.js
var EquipGlobalLen=95;

$(function()
{
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
    initMessage(""); 		//获取所有业务消息
    initLookUp(); 			//初始化放大镜
    initState();
    initCheckResult();
    initFrequencyUnit();
    setElement("CheckUserDR",curSSUserID);
	setElement("CheckUser",curUserName);
	
    defindTitleStyle();
    initButton(); 				//按钮初始化 
    //initButtonWidth();
    InitEvent();
    
    fillData(); 				//数据填充
    setEnabled(); 				//按钮控制
    initApproveButtonNew(); 	//初始化审批按钮
};

function InitEvent() //初始化
{
	/*
	if (jQuery("#BCancelSubmit").length>0)
	{
		jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
	}
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Clicked;*/
}

function fillData()
{
	var RowID=getElementValue("RowID");
	if ((RowID=="")||(RowID<1)) return;
	var ReturnList=tkMakeServerCall("web.DHCEQAppraisalReport","GetOneData",RowID);
	//alertShow(ReturnList)
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("^");
	var sort=41;
	//alertShow(ReturnList)
	setElement("Type",list[0]);
	setElement("EquipDR",list[1]);
	FillEquipInfo(list[1]);
	setElement("No",list[2]);
	setElement("Name",list[3]);
	setElement("UseLocDR",list[4]);
	setElement("UseLoc",list[sort+0]);
	setElement("LocationDR",list[5]);
	setElement("Location",list[sort+1]);
	setElement("DepreMonths",list[sort+17]);
	setElement("StateDR",list[7]);
	setElement("State",list[7]);	// MZY0154	3272542		2023-03-03
	setElement("CheckResult",list[8]);
	setElement("CheckContent",list[9]);
	setElement("MaintCounts",list[10]);
	setElement("FrequencyUnit",list[11]);
	setElement("PreviousMaintFee",list[12]);
	setElement("TotalFee",list[13]);
	setElement("Situation",list[14]);
	setElement("OtherSituation",list[15]);
	setElement("ReportDate",list[16]);
	setElement("CheckUserDR",list[17]);
	setElement("CheckUser",list[sort+5]);
	setElement("Phone",list[18]);
	setElement("Remark",list[19]);
	setElement("Status",list[20]);
	setElement("AuditUser",list[sort+6]);
	setElement("AuditDate",list[25]);
	setElement("AuditTime",list[26]);
	setElement("OriginalFee",list[35]);
	//setElement("Hold1",list[35]);
	//setElement("Hold2",list[36]);
	//setElement("Hold3",list[37]);
	//setElement("Hold4",list[38]);
	//setElement("Hold5",list[39]);
	
	//alertShow(list[sort+8])
	setElement("ApproveSetDR",list[sort+8]);
	setElement("NextRoleDR",list[sort+9]);
	setElement("NextFlowStep",list[sort+10]);
	setElement("ApproveStatus",list[sort+11]);
	setElement("ApproveRoleDR",list[sort+12]);
	setElement("CancelFlag",list[sort+13]);
	setElement("CancelToFlowDR",list[sort+14]);
}
function FillEquipInfo(EQDR)
{
	if ((EQDR=="")||(EQDR<1)) return;
	var result=tkMakeServerCall("web.DHCEQEquip","GetEquipByID","","",EQDR);
	result=result.replace(/\\n/g,"\n");
	var list=result.split("^");
	var sort=EquipGlobalLen;
	//alertShow(result)
	setElement("EquipDR",EQDR);
	setElement("Name",list[sort+36]);
	setElement("EquipNo",list[70]);
	setElement("FileNo",list[84]);
	setElement("Model",list[sort+0]);
	setElement("LeaveFactoryNo",list[9]);
	setElement("UseLocDR",list[18]);
	setElement("UseLoc",list[sort+7]);
	setElement("OriginalFee",list[26]);
	setElement("StartDate",list[43]);
	setElement("LimitYearsNum",list[30]);
	setElement("DepreMonths",list[sort+66]);
	setElement("PreviousMaintFee",list[sort+67]);
	setElement("LocationDR",list[71]);
	setElement("Location",list[sort+34]);
}
function setEnabled()
{
	var Status=getElementValue("Status");
	var WaitAD=getElementValue("WaitAD");
	setElement("ReadOnly",0);
	//alert("Status="+Status)
	if (Status!="0")
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		//hiddenObj("BDelete");
		//hiddenObj("BSubmit");
		if (Status!="")
		{
			disableElement("BSave",true);
			disableElement("BClear",true);
			//setElement("ReadOnly",1);
			//hiddenObj("BSave");
			//hiddenObj("BClear");
		}
	}
	//非建单据菜单,不可更新等操作单据
	if (WaitAD!="off")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BAdd",true);
		disableElement("BClear",true);
		//setElement("ReadOnly",1);	//非建单据菜单,设为只读
	}
	disableElement("BCancel",true);
	disableElement("BPrint",true);
	if (Status=="2")
	{
		disableElement("BCancel",false);
		if (jQuery("#BCancel").length>0)
		{
			//jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-paper'});
			jQuery("#BCancel").on("click", BCancel_Clicked);
		}
		disableElement("BPrint",false);
		if (jQuery("#BPrint").length>0)
		{
			//jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-paper'});
			jQuery("#BPrint").on("click", BPrint_Clicked);
		}
	}
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="Name")
	{
		FillEquipInfo(rowData.TRowID);
	}
	else if(elementID=="Location") {setElement("LocationDR",rowData.TRowID)}
}
/*
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
*/
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}

function BSave_Clicked()
{
	if (getElementValue("EquipNo")=="")
	{
		messageShow('alert','error','错误提示','设备信息异常,请重新选择设备!');
		return;
	}
	var plist=CombinData();
	var jsonData=tkMakeServerCall("web.DHCEQAppraisalReport","SaveData",plist);
	if (jsonData<0)
	{
		messageShow('alert','error','错误提示',"发生错误!");
	}
	else
    {
		//window.location.reload()
		var url="dhceq.em.appraisalreport.csp?&RowID="+jsonData+"&Type="+getElementValue("Type")+"&WaitAD="+getElementValue("WaitAD");	// MZY0141	2970183		2022-11-02
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
    }
}
function CombinData()
{
	var combindata=getElementValue("RowID");
	combindata=combindata+"^"+getElementValue("Type");
  	combindata=combindata+"^"+getElementValue("EquipDR");
  	//combindata=combindata+"^"+getElementValue("No");
	combindata=combindata+"^"+getElementValue("Name");
  	combindata=combindata+"^"+getElementValue("UseLocDR");
  	combindata=combindata+"^"+getElementValue("LocationDR");
  	combindata=combindata+"^"+getElementValue("DepreMonths");
  	combindata=combindata+"^"+getElementValue("State");
  	combindata=combindata+"^"+getElementValue("CheckResult");
	combindata=combindata+"^"+getElementValue("CheckContent");
  	combindata=combindata+"^"+getElementValue("MaintCounts");
  	combindata=combindata+"^"+getElementValue("FrequencyUnit");
  	combindata=combindata+"^"+getElementValue("PreviousMaintFee");
  	combindata=combindata+"^"+getElementValue("TotalFee");
  	combindata=combindata+"^"+getElementValue("Situation");
  	combindata=combindata+"^"+getElementValue("OtherSituation");
  	combindata=combindata+"^"+getElementValue("ReportDate");
  	combindata=combindata+"^"+getElementValue("CheckUserDR");
  	combindata=combindata+"^"+getElementValue("Phone");
  	combindata=combindata+"^"+getElementValue("Remark");
	combindata=combindata+"^"+getElementValue("RejectReason");
	combindata=combindata+"^"+getElementValue("OriginalFee");
	//combindata=combindata+"^"+getElementValue("Hold1");
	//combindata=combindata+"^"+getElementValue("Hold2");
	//combindata=combindata+"^"+getElementValue("Hold3");
	//combindata=combindata+"^"+getElementValue("Hold4");
	//combindata=combindata+"^"+getElementValue("Hold5");
	
  	return combindata;
}
function BDelete_Clicked()
{
	if (getElementValue("RowID")=="")
	{
		messageShow('alert','error','错误提示','没有数据!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQAppraisalReport","SaveData",getElementValue("RowID"),1);
	if (jsonData<0)
	{
		messageShow('alert','error','错误提示',"发生错误!");
	}
	else
    {
		//window.location.reload()
		var url="dhceq.em.appraisalreport.csp?&Type="+getElementValue("Type")+"&WaitAD="+getElementValue("WaitAD");		// MZY0141	2970183		2022-11-02
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
    }
}
function BSubmit_Clicked()
{
	if (getElementValue("RowID")=="")
	{
		messageShow('alert','error','错误提示','没有数据!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQAppraisalReport","SubmitData",getElementValue("RowID"));
	if (jsonData>0)
	{
	    //window.location.reload()
		var url="dhceq.em.appraisalreport.csp?&RowID="+jsonData+"&Type="+getElementValue("Type")+"&WaitAD="+getElementValue("WaitAD");	// MZY0141	2970183		2022-11-02
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',"发生错误!");
    }
}
function BCancelSubmit_Clicked()
{
	if (getElementValue("RowID")=="")
	{
		messageShow('alert','error','错误提示','没有数据!');
		return;
	}
	var combindata=GetValueList();
	var jsonData=tkMakeServerCall("web.DHCEQAppraisalReport","CancelSubmitData",combindata,getElementValue("CurRole"));
	if (jsonData>0)
	{
	    //window.location.reload()
		var url="dhceq.em.appraisalreport.csp?&RowID="+jsonData+"&Type="+getElementValue("Type")+"&WaitAD="+getElementValue("WaitAD");	// MZY0141	2970183		2022-11-02
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',"发生错误!");
    }
}
function BApprove_Clicked()
{
  	if (getElementValue("RowID")=="")
	{
		messageShow('alert','error','错误提示','没有数据!');
		return;
	}
	var combindata=GetValueList();
	var jsonData=tkMakeServerCall("web.DHCEQAppraisalReport","AuditData",combindata,getElementValue("CurRole"),getElementValue("RoleStep"),"");
	if (jsonData>0)
	{
	    //window.location.reload()
		var url="dhceq.em.appraisalreport.csp?&RowID="+jsonData+"&Type="+getElementValue("Type")+"&WaitAD="+getElementValue("WaitAD");	// MZY0141	2970183		2022-11-02
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',"发生错误!");
    }
}
function GetValueList()
{
	var combindata=getElementValue("RowID");
	combindata=combindata+"^"+getElementValue("RejectReason");
	combindata=combindata+"^"+curUserID;
	combindata=combindata+"^"+getElementValue("CancelToFlowDR");
	combindata=combindata+"^"+getElementValue("ApproveSetDR");
	return combindata
}

function BCancel_Clicked()
{
	if (getElementValue("RowID")=="")
	{
		messageShow('alert','error','错误提示','没有数据!');
		return;
	}
	messageShow("confirm","","","确认进行作废操作?","",ConfirmOpt,DisConfirmOpt);
}
function ConfirmOpt()
{
	var jsonData=tkMakeServerCall("web.DHCEQAppraisalReport","CancelData",getElementValue("RowID"));
	if (jsonData>0)
	{
	    //window.location.reload()
		var url="dhceq.em.appraisalreport.csp?&RowID="+jsonData+"&Type="+getElementValue("Type")+"&WaitAD="+getElementValue("WaitAD");	// MZY0141	2970183		2022-11-02
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',"发生错误!");
    }
}
function DisConfirmOpt()
{
}
function initState()
{
	var State = $HUI.combobox('#State',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '1',text: '正常'},{id: '2',text: '带病工作'},{id: '3',text: '停机'},{id: '4',text: '功能受限'}],
		onSelect : function(){}
	});
}
function initCheckResult()
{
	var CheckResult = $HUI.combobox('#CheckResult',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '0',text: '合格'},{id: '1',text: '不合格'}],
		onSelect : function(){}
	});
}
function initFrequencyUnit()
{
	var FrequencyUnit = $HUI.combobox('#FrequencyUnit',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '0',text: '周'},{id: '1',text: '月'},{id: '2',text: '季度'},{id: '3',text: '半年'},{id: '4',text: '年'}],
		onSelect : function(){}
	});
}
function BPrint_Clicked()
{ 
	var	ARRowId = getElementValue("RowID");
	var HOSPDESC = curSSHospitalName;
	var USERNAME = curUserName;
	var PrintFlag = getElementValue("PrintFlag");	 		//打印方式标志位 excel：0  润乾:1   
	var PreviewRptFlag = getElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1
	var filename = ""
	//Excel打印方式
	if(PrintFlag==0)  
	{
		PrintExcel();
	}
	//润乾打印
	if(PrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQAppraisalReport.raq(ARRowID="+ARRowId
		    +";USERNAME="+USERNAME
		    +";HOSPDESC="+HOSPDESC
		    +")}";
	        DHCCPM_RQDirectPrint(fileName);
		}
		
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQAppraisalReport.raq&ARRowID="+ARRowId
			+"&USERNAME="+USERNAME
			+"&HOSPDESC="+HOSPDESC
			DHCCPM_RQPrint(fileName);
		}
	}
}
function PrintExcel()
{
	var RowID=getElementValue("RowID");
	if ((RowID=="")||(RowID<1)) return;
	try 
    {
        var xlApp,xlsheet,xlBook;
	    xlApp = new ActiveXObject("Excel.Application");
		var Template=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")+"DHCEQAppraisalReport.xls";
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		
		var ReturnList=tkMakeServerCall("web.DHCEQAppraisalReport","GetOneData",RowID);
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		var list=ReturnList.split("^");
		var sort=41;
		
		xlsheet.cells.replace("[Hospital]",curSSHospitalName)
		var Row=2;
		xlsheet.cells(2,2)=list[2];
		Row=Row+1;
		xlsheet.cells(3,1)=xlsheet.cells(3,1)+list[sort+0];
		xlsheet.cells(3,2)=xlsheet.cells(3,2)+list[sort+5];
		xlsheet.cells(4,1)=xlsheet.cells(4,1)+list[3];
		xlsheet.cells(4,2)=xlsheet.cells(4,2)+list[18];
		xlsheet.cells(7,2)=xlsheet.cells(7,2)+list[sort+1];
		xlsheet.cells(9,2)=xlsheet.cells(9,2)+list[6];
		xlsheet.cells(10,1)=xlsheet.cells(10,1)+list[sort+2];
		xlsheet.cells(11,1)=xlsheet.cells(11,1)+list[sort+3];
		xlsheet.cells(12,1)=xlsheet.cells(12,1)+list[10]+" 次/"+list[sort+4];
		xlsheet.cells(13,1)=xlsheet.cells(13,1)+list[12];
		xlsheet.cells(13,2)=xlsheet.cells(13,2)+list[13];
		xlsheet.cells(15,1)=list[14];
		xlsheet.cells(17,1)=list[15];
		xlsheet.cells(18,1)=xlsheet.cells(18,1)+list[sort+6];
		xlsheet.cells(18,2)=xlsheet.cells(18,2)+ChangeDateFormat(list[25]);
		
		var result=tkMakeServerCall("web.DHCEQEquip","GetEquipByID","","",list[1]);
		result=result.replace(/\\n/g,"\n");
		var EQlist=result.split("^");
		//alertShow(result)
		var sort=EquipGlobalLen;
		xlsheet.cells(5,1)=xlsheet.cells(5,1)+EQlist[84];
		xlsheet.cells(5,2)=xlsheet.cells(5,2)+EQlist[70];
		xlsheet.cells(6,1)=xlsheet.cells(6,1)+EQlist[EquipGlobalLen];
		xlsheet.cells(6,2)=xlsheet.cells(6,2)+EQlist[9];
		xlsheet.cells(7,1)=xlsheet.cells(7,1)+ChangeDateFormat(EQlist[43]);
		xlsheet.cells(9,1)=xlsheet.cells(9,1)+EQlist[30]+" 年";
		
	    xlApp.Visible=true;
		xlsheet.PrintPreview();
		//xlsheet.cells(2,16)="第二联";
		//xlsheet.PrintPreview();
		
	    //xlBook.printout;
	    ///xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	}
	catch(e)
	{	 alertShow(e.message);	 }
	
	alertShow("操作完成!");
}
