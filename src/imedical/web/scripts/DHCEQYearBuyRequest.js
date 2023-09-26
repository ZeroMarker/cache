//------------------------------------------------------------
//modified by GR2014-10-24 缺陷号3221
//设备采购申请-年度采购申请审批-批量新增多条明细的采购申请审批时，执行成功但提示"xx申请单号以上单据操作失败!",除第一条明细外，其余审核数量自动清空
//修改：将属于同一主表的明细记录同时执行审核操作
//-------------------------------------------------------------------------
var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitUserInfo();
	InitPage();
	KeyUp("RequestLoc")
	Muilt_LookUp("RequestLoc")
	var Flag=GetChkElementValue("ApproveFlag")
	if (Flag==false)
	{
		DisableBElement("BExecute",false)
	}
	else
	{
		DisableBElement("BExecute",true)
	}
}

function InitPage()
{
	var obj=document.getElementById("BFind"); //查找
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BExport"); //导出
	if (obj) obj.onclick=BExport_Click;
	var obj=document.getElementById("BSelectAll"); //全选
	if (obj) obj.onclick=BSelectAll_Click;
	var obj=document.getElementById("BExecute"); //执行
	if (obj) obj.onclick=BExecute_Click;
}

function BFind_Click()
{
	var Flag=GetChkElementValue("ApproveFlag")
	if (Flag==false)
	{
		Flag=0
	}
	else
	{
		Flag=1
	}
	var val="&PrjName="+GetElementValue("PrjName");
	val=val+"&RequestNo="+GetElementValue("RequestNo");
	val=val+"&StartDate="+GetElementValue("StartDate")
	val=val+"&EndDate="+GetElementValue("EndDate")
	val=val+"&BRYear="+GetElementValue("BRYear")
	val=val+"&RequestLocDR="+GetElementValue("RequestLocDR")
	val=val+"&RequestLoc="+GetElementValue("RequestLoc")
	val=val+"&ApproveRole="+GetElementValue("ApproveRole")
	val=val+"&ApproveFlag="+Flag
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQYearBuyRequest"+val;
}

function BExport_Click()
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetOneYearBuyRequest");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	
	var PageRows=43 //每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQYearBuyRequest.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows
		    	}
	    	}
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
			    var OneDetail=cspRunServerMethod(encmeth,l,TJob);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[1];
		    	xlsheet.cells(j,2)=GetShortName(OneDetailList[15],"-");
		    	xlsheet.cells(j,3)=FormatDate(OneDetailList[4]);
		    	xlsheet.cells(j,4)=OneDetailList[5];
		    	xlsheet.cells(j,5)=OneDetailList[3];
		    	xlsheet.cells(j,6)=OneDetailList[6];
		    	xlsheet.cells(j,7)=OneDetailList[7];
		    	xlsheet.cells(j,8)=OneDetailList[9];
		    	xlsheet.cells(j,9)=OneDetailList[10];
		    	xlsheet.cells(j,10)=OneDetailList[11];
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,10)="第"+(i+1)+"页("+"共"+(Pages+1)+"页)"
			xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(j+1,8)="制表人:"
			xlsheet.cells(j+1,9)=curUserName
	    	//xlsheet.printout; //打印输出
			var savepath=GetFileName();  //Modified By ZY 2009-11-17 ZY0017
			xlBook.SaveAs(savepath);   //Modified By ZY 2009-11-17 ZY0017
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function BSelectAll_Click()
{
	var obj=document.getElementById("BSelectAll")
	if (obj.innerText=="全选(当前页)")
	{
		obj.innerText="反选(当前页)"
		var flag=1
	}
	else
	{
		obj.innerText="全选(当前页)"
		var flag=0
	}
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQYearBuyRequest');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		selobj.checked=flag;
	}
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQYearBuyRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			Count=Count+1
		}
	}
	var obj=document.getElementById("BSelectAll")
	if (Count==(Rows-1))
	{
		obj.innerText="反选(当前页)"
	}
	else
	{
		obj.innerText="全选(当前页)"
	}
}

function GetAuditData(ID)
{
	var ValueList="";
	ValueList=GetElementValue("TRowIDz"+ID);
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("TCancelToFlowz"+ID);
	ValueList=ValueList+"^"+GetElementValue("TApproveInfoz"+ID);
  	ValueList=ValueList+"^";
	ValueList=ValueList+"^"+GetElementValue("TRejectReasonz"+ID);
	
	return ValueList;
}
function BExecute_Click()
{
	//是否有选择记录
	var ErrorStr=""
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tDHCEQYearBuyRequest');
	var Rows=Objtbl.rows.length;
	var Count=0
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			Count=Count+1
			//未输入数量
			var ApproveNum=GetElementValue("TApproveNumz"+i)
			var RejectReason=GetElementValue("TRejectReasonz"+i)
			var ApproveInfo=GetElementValue("TApproveInfoz"+i)
			var RequestNum=GetElementValue("TRequestNumz"+i)
			if (ApproveNum=="")
			{
				alertShow("["+GetElementValue("TNamez"+i)+"] 未输入审批数量!")
				SetFocus("TApproveNumz"+i)
				return
			}
			
			if (isNaN(ApproveNum))
			{
				alertShow("请输入正确的审批数量!")
				return
			}
			else
			{
				if ((ApproveNum*1)>(RequestNum*1))
				{
					alertShow("审批数量不能大于申请数量!")
					return
				}
			}
			//数量为0,未输入拒绝原因
			if ((ApproveNum==0)&&(RejectReason==""))
			{
				alertShow("["+GetElementValue("TNamez"+i)+"] 请输入拒绝原因!")
				SetFocus("TRejectReasonz"+i)
				return
			}
			//数量不为0,未输入审批意见的
			if ((ApproveNum!=0)&&(ApproveInfo==""))
			{
				alertShow("["+GetElementValue("TNamez"+i)+"] 请输入审批意见!")
				SetFocus("TApproveInfoz"+i)
				return
			}
		}
	}
	if (Count==0)
	{
		alertShow("未选择执行记录!")
		return
	}
	//开始执行
	var CurRole=GetElementValue("ApproveRole");
  	if (CurRole=="") return;
  	var encmeth=GetElementValue("AuditData");
  	if (encmeth=="") return;
  	var encmeth1=GetElementValue("CancelSubmitData");
  	if (encmeth1=="") return;
	for (var i=1;i<=Rows-1;i++)		//Modify DJ 2015-09-07 DJ0160
	{
		InitEditFields(GetElementValue("TApproveSetz"+i),CurRole)
		var selobj=document.getElementById('TOperatorz'+i);
		if (selobj.checked)
		{
			ApproveNum=GetElementValue("TApproveNumz"+i)
			var RoleStep=GetElementValue("TRoleStepz"+i);
			var combindata=GetAuditData(i);
			//审核
			if (ApproveNum!=0)
			{
			  	var objtbl=document.getElementById('tDHCEQYearBuyRequest');
				var EditFieldsInfo=ApproveEditFieldsInfo(objtbl,i);
				if (EditFieldsInfo=="-1") return;
				for(var j=i+1;j<Rows;j++)                                  //modified by GR2014-10-24 begin 缺陷号3221
				{
					var selobjj=document.getElementById('TOperatorz'+j);
					if (selobjj.checked)
					{
						if (GetElementValue("TRowIDz"+i)==GetElementValue("TRowIDz"+j))		//Modify DJ 2015-09-07 DJ0160
						{
							if (""==GetElementValue("TApproveNumz"+j))
							{
								alertShow("["+GetElementValue("TNamez"+j)+"] 未输入审批数量!")
								SetFocus("TApproveNumz"+j)
								return
							}
							else
							{
								var EditFieldsInfotemp=ApproveEditFieldsInfo(objtbl,j);
								if (EditFieldsInfotemp=="-1") return;
								EditFieldsInfo=EditFieldsInfo+"@"+EditFieldsInfotemp
							}
						}
						else
						{
							i=j-1		//Modify DJ 2015-09-07 DJ0160
							break
						}
					}
				}      											//modified by GR2014-10-24 end 缺陷号3221
				var rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
			}
			else //取消提交
			{
				var rtn=cspRunServerMethod(encmeth1,combindata,CurRole);
			}
			var list=rtn.split("^");
			if (list[0]=="-1")
			{
				if (ErrorStr=="")
				{
					ErrorStr=list[1]
				}
				else
				{
					ErrorStr=ErrorStr+","+list[1]
				}
			}
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr+"以上单据操作失败!")
	}
	BFind_Click();
}

function GetRequestLoc(value)
{
	GetLookUpID("RequestLocDR",value);
}


document.body.onload = BodyLoadHandler;
