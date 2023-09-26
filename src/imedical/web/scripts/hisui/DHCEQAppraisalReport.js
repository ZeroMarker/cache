/// DHCEQAppraisalReport.js
/// 设备鉴定报告

function BodyLoadHandler()
{
	InitUserInfo();
	InitPage();
	FillData();
	SetEnabled();
	InitApproveButton();
	initButtonWidth();
	KeyUp("Name^Location","N");
	Muilt_LookUp("Name^Location");
}
function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Clicked;
}
function FillData()
{
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(RowID<1)) return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	//alertShow(ReturnList)
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("^");
	var sort=41;
	//alertShow(ReturnList)
	SetElement("Type",list[0]);
	SetElement("EquipDR",list[1]);
	FillEquipInfo("^"+list[1]);
	SetElement("No",list[2]);
	SetElement("Name",list[3]);
	SetElement("UseLocDR",list[4]);
	SetElement("UseLoc",list[sort+0]);
	SetElement("LocationDR",list[5]);
	SetElement("Location",list[sort+1]);
	SetElement("DepreMonths",list[6]);
	SetElement("StateDR",list[7]);
	SetElement("State",list[sort+2]);
	SetElement("CheckResult",list[8]);
	SetElement("CheckContent",list[9]);
	SetElement("MaintCounts",list[10]);
	SetElement("FrequencyUnit",list[11]);
	SetElement("PreviousMaintFee",list[12]);
	SetElement("TotalFee",list[13]);
	SetElement("Situation",list[14]);
	SetElement("OtherSituation",list[15]);
	SetElement("ReportDate",list[16]);
	SetElement("CheckUserDR",list[17]);
	SetElement("CheckUser",list[sort+5]);
	SetElement("Phone",list[18]);
	SetElement("Remark",list[19]);
	SetElement("Status",list[20]);
	SetElement("AuditUser",list[sort+6]);
	SetElement("AuditDate",list[25]);
	SetElement("AuditTime",list[26]);
	SetElement("OriginalFee",list[35]);
	//SetElement("Hold1",list[35]);
	//SetElement("Hold2",list[36]);
	//SetElement("Hold3",list[37]);
	//SetElement("Hold4",list[38]);
	//SetElement("Hold5",list[39]);
	
	//alertShow(list[sort+5])
	SetElement("ApproveSetDR",list[sort+8]);
	SetElement("NextRoleDR",list[sort+9]);
	SetElement("NextFlowStep",list[sort+10]);
	SetElement("ApproveStatus",list[sort+11]);
	SetElement("ApproveRoleDR",list[sort+12]);
	SetElement("CancelFlag",list[sort+13]);
	SetElement("CancelToFlowDR",list[sort+14]);
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	SetElement("ReadOnly",0);
	//alertShow(WaitAD)
	if (Status!="0")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		if (Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BClear",true);
			//SetElement("ReadOnly",1);
		}
	}
	//非建单据菜单,不可更新等操作单据
	if (WaitAD!="off")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		DisableBElement("BClear",true);
		//SetElement("ReadOnly",1);	//非建单据菜单,设为只读
	}
	DisableBElement("BCancel",true);
	DisableBElement("BPrint",true);
	if (Status=="2")
	{
		DisableBElement("BCancel",false);
		var obj=document.getElementById("BCancel");
		if (obj) obj.onclick=BCancel_Clicked;
		DisableBElement("BPrint",false);
		var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	}
}
function FillEquipInfo(value)
{
	var val=value.split("^");
	if ((val[1]=="")||(val[1]<1)) return;
	var encmeth=GetElementValue("GetEquipInfo");
	if (encmeth=="")
	{
		alertShow("未设置查询方法!");
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',val[1]);
	result=result.replace(/\\n/g,"\n");
	var list=result.split("^");
	var sort=EquipGlobalLen;
	//alertShow(result)
	SetElement("EquipDR",val[1]);
	SetElement("Name",list[sort+36]);
	SetElement("EquipNo",list[70]);
	SetElement("FileNo",list[84]);
	SetElement("Model",list[sort+0]);
	SetElement("LeaveFactoryNo",list[9]);
	SetElement("UseLocDR",list[18]);
	SetElement("UseLoc",list[sort+7]);
	SetElement("OriginalFee",list[26]);
	SetElement("StartDate",list[43]);
	SetElement("LimitYearsNum",list[30]);
	SetElement("DepreMonths",list[sort+66]);
	SetElement("PreviousMaintFee",list[sort+67]);
	SetElement("LocationDR",list[71]);
	SetElement("Location",list[sort+34]);
}

function BUpdate_Clicked()
{
	if (CheckMustItemNull()) return;
	if (GetElementValue("EquipNo")=="")
	{
		alertShow("设备信息异常,请重新选择设备!");
		return;
	}
	var encmeth=GetElementValue("UpdateData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,plist);
	//alertShow(plist)
	if (result>0)
    {
		//添加操作成功是否提示
		ShowMessage();
		//location.reload();
	    var url=window.location.href 	//新窗口打开模态窗口,通过改变参数值解决预缓存问题
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=0&RowID='+result+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	    else 								window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=1&RowID='+result+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	}
    else
    {
	    alertShow(EQMsg(t["01"],result));
    }
}
function CombinData()
{
	var combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("Type");
  	combindata=combindata+"^"+GetElementValue("EquipDR");
  	//combindata=combindata+"^"+GetElementValue("No");
	combindata=combindata+"^"+GetElementValue("Name");
  	combindata=combindata+"^"+GetElementValue("UseLocDR");
  	combindata=combindata+"^"+GetElementValue("LocationDR");
  	combindata=combindata+"^"+GetElementValue("DepreMonths");
  	combindata=combindata+"^"+GetElementValue("StateDR");
  	combindata=combindata+"^";
  	if (typeof(GetElementValue("CheckResult")) != "undefined")
	{
	    combindata=combindata+GetElementValue("CheckResult");
	}
	combindata=combindata+"^"+GetElementValue("CheckContent");
  	combindata=combindata+"^"+GetElementValue("MaintCounts");
  	combindata=combindata+"^"+GetElementValue("FrequencyUnit");
  	combindata=combindata+"^"+GetElementValue("PreviousMaintFee");
  	combindata=combindata+"^"+GetElementValue("TotalFee");
  	combindata=combindata+"^"+GetElementValue("Situation");
  	combindata=combindata+"^"+GetElementValue("OtherSituation");
  	combindata=combindata+"^"+GetElementValue("ReportDate");
  	combindata=combindata+"^"+GetElementValue("CheckUserDR");
  	combindata=combindata+"^"+GetElementValue("Phone");
  	combindata=combindata+"^"+GetElementValue("Remark");
	combindata=combindata+"^"+GetElementValue("RejectReason");
	combindata=combindata+"^"+GetElementValue("OriginalFee");
	//combindata=combindata+"^"+GetElementValue("Hold1");
	//combindata=combindata+"^"+GetElementValue("Hold2");
	//combindata=combindata+"^"+GetElementValue("Hold3");
	//combindata=combindata+"^"+GetElementValue("Hold4");
	//combindata=combindata+"^"+GetElementValue("Hold5");
	
  	return combindata;
}
function BDelete_Clicked() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		alertShow(t['-3002']);
		return;
	}
	var truthBeTold = window.confirm(t['-4003']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("UpdateData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,1);
	//alertShow(result)
	if (result=="0")
    {
		var url=window.location.href;
		if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=0&WaitAD='+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	    else 								window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=1&WaitAD='+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	}
    else
    {
	    alertShow(t[result]+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	if (CheckMustItemNull()) return;
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth, GetElementValue("RowID"));
	if (rtn>0)
    {
	    var url=window.location.href 	//新窗口打开模态窗口,通过改变参数值解决预缓存问题
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=0&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	    else 								window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=1&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	}
    else
    {
	    if (isNaN(rtn))
	    {
		    alertShow(rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[rtn]+"   "+t["01"]);
	    }
    }
}
function BCancelSubmit_Clicked()
{
	if (CheckMustItemNull()) return;
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
  	var combindata=GetValueList();
	var rtn=cspRunServerMethod(encmeth, combindata, GetElementValue("CurRole"));
	if (rtn>0)
    {
	    var url=window.location.href 	//新窗口打开模态窗口,通过改变参数值解决预缓存问题
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=0&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	    else 								window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=1&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	}
    else
    {
	    if (isNaN(rtn))
	    {
		    alertShow(rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[rtn]+"   "+t["01"]);
	    }
    }
}
function BApprove_Clicked()
{
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('tDHCEQAppraisalReport');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
	//alertShow(rtn)
    if (rtn>0)
    {
   	    //window.location.reload();
	    var url=window.location.href 	//新窗口打开模态窗口,通过改变参数值解决预缓存问题
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=0&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	    else 								window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=1&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	}
    else
    {
	    if (isNaN(rtn))
	    {
		    alertShow(rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[rtn]+"   "+t["01"]);
	    }
    }
}
function GetValueList()
{
	var combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("RejectReason");
	combindata=combindata+"^"+session['LOGON.USERID'];
	combindata=combindata+"^"+GetElementValue("CancelToFlowDR");
	combindata=combindata+"^"+GetElementValue("ApproveSetDR");
	return combindata
}
/*function Clear()
{
	SetElement("RowID","");
	SetElement("No","");
	SetElement("UseLoc","");
	SetElement("State","");
	SetElement("CheckResult","");
	SetElement("MaintCounts","");
	SetElement("FrequencyUnit","");
	SetElement("Situation","");
	SetElement("OtherSituation","");
	SetElement("ReportDate","");
	SetElement("CheckUser","");
	SetElement("Phone","");
	SetElement("Remark","");
	//SetElement("Hold1","");
	//SetElement("Hold2","");
	//SetElement("Hold3","");
	//SetElement("Hold4","");
	//SetElement("Hold5","");
}*/
function GetStateID(value)
{
	GetLookUpID('StateDR',value);
}
function GetLocationID(value)
{
	var val=value.split("^");
	SetElement("LocationDR",val[0]);
	SetElement("Location",val[2]);
}
//作废
function BCancel_Clicked()
{
	var encmeth=GetElementValue("CancelData");
	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth, GetElementValue("RowID"));
	if (rtn>0)
    {
	    var url=window.location.href 	//新窗口打开模态窗口,通过改变参数值解决预缓存问题
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=0&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	    else 								window.location.href='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&killcache=1&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&Type="+GetElementValue("Type");
	}
    else
    {
	    if (isNaN(rtn))
	    {
		    alertShow(rtn+"   "+t["01"]);
	    }
	    else
	    {
		    alertShow(t[rtn]+"   "+t["01"]);
	    }
    }
}

//add by wl 2019-11-29 WL0013
function BPrint_Clicked()
{ 
	var	ARRowId = GetElementValue("RowID");
	var HOSPDESC = GetElementValue("GetHospitalDesc");
	var USERNAME = curUserName;
	var PrintFlag = GetElementValue("PrintFlag");	 //打印方式标志位 excel：0  润乾:1   
	var PreviewRptFlag = GetElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1
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
	try 
    {
	    var encmeth=GetElementValue("GetRepPath");
		if (encmeth=="") return;
		var	TemplatePath=cspRunServerMethod(encmeth);
        var xlApp,xlsheet,xlBook
	    xlApp = new ActiveXObject("Excel.Application");
		var	Template=TemplatePath+"DHCEQAppraisalReport.xls";
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		
		var RowID=GetElementValue("RowID");
		if ((RowID=="")||(RowID<1)) return;
		var obj=document.getElementById("fillData");
		if (obj){var encmeth=obj.value} else {var encmeth=""};
		var ReturnList=cspRunServerMethod(encmeth,RowID);
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		var list=ReturnList.split("^");
		var sort=41;
		
		xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
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
		
		var encmeth=GetElementValue("GetEquipInfo");
		if (encmeth=="")
		{
			alertShow("未设置查询方法!");
			return;
		}
		var result=cspRunServerMethod(encmeth,'','',list[1]);
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
function BClose_Click()
{
	//window.close();
	CloseWindow();
}

document.body.onload = BodyLoadHandler;
