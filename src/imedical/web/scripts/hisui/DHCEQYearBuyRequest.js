//------------------------------------------------------------
//modified by GR2014-10-24 缺陷号3221
//设备采购申请-年度采购申请审批-批量新增多条明细的采购申请审批时，执行成功但提示"xx申请单号以上单据操作失败!",除第一条明细外，其余审核数量自动清空
//修改：将属于同一主表的明细记录同时执行审核操作
//-------------------------------------------------------------------------
var SelectedRow = 0;
var rowid=0;
var Component="tDHCEQYearBuyRequest"
function BodyLoadHandler() 
{
	initButtonWidth();  //add by lmm 2018-09-05 hisui改造：修改按钮长度
	InitUserInfo();
	InitPage();
	KeyUp("RequestLoc")
	Muilt_LookUp("RequestLoc")
	//add 20191012 by zy 判断按钮是否可用
	var Action=getElementValue("Action")
	if (Action=="BuyReq_Assign")
	{
		$("#BExecute").linkbutton({text:"派单"})
	}
	// add by zx 2019-09-16 
	if ((Action=="BuyReq_Research")||(Action=="BuyReq_Decision"))
	{
		hiddenObj("BExecute",true);
	}
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

///add by zy 2018-10-19
///hisui改造：增加可编辑列表
var editFlag="undefined";
var SelectedRow = -1;
var rowid=0;
$('#'+Component).datagrid({
	onSelect: function (rowIndex, rowData) {	//单击行结束编辑
		if (editFlag!="undefined") 
		{
	    	jQuery('#'+Component).datagrid('endEdit', editFlag);
	    	//EditRowColor();
	    	editFlag="undefined";
	    }
    },
})
//modified by zy ZY0223 2020-04-17
//这个函数不需要定义
/*
//add 20191012 by zy 批量处理方式改变
function SelectRowHandler(index,rowdata)	{	//双击行开始编辑
	//var Value=$('#'+Component).datagrid('getColumnOption','TApproveInfo');
	//Value.editor={type:'validatebox'};
	//var Value=$('#'+Component).datagrid('getColumnOption','TApproveNum');
	//Value.editor={type:'validatebox'};
	//var Value=$('#'+Component).datagrid('getColumnOption','TRejectReason');
	//Value.editor={type:'validatebox'};
	//modified by ZY0222 2020-04-16
	//var Value=$('#'+Component).datagrid('getColumnOption','TOperator');
	//Value.editor={type: 'checkbox',options:{on:'Y',off:'N'}}
	if (editFlag!="undefined")
	{
    	jQuery('#'+Component).datagrid('endEdit', editFlag);
    	editFlag="undefined"
	}
    jQuery('#'+Component).datagrid('beginEdit', index);
    editFlag =index;
}
*/
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
///modified by ZY0201  
function BFind_Click()
{
	/*
	var Flag=GetChkElementValue("ApproveFlag")
	if (Flag==false)
	{
		Flag=0
	}
	else
	{
		Flag=1
	}
	*/
	var Flag=getValueById("ApproveFlag")
	if (!$(this).linkbutton('options').disabled){
			$('#tDHCEQYearBuyRequest').datagrid('load',{
				ComponentID:getValueById("GetComponentID"),
				PrjName:getValueById("PrjName"),
				RequestNo:getValueById("RequestNo"),
				StartDate:$('#StartDate').datebox("getValue"),
				EndDate:$('#EndDate').datebox("getValue"),
				BRYear:getValueById("BRYear"),
				RequestLocDR:getValueById("RequestLocDR"),
				ApproveRole:getValueById("ApproveRole"),
				ApproveFlag:Flag,
				Action:getValueById("Action"),
				ManageLocDR:getValueById("ManageLocDR")
				});
		}
}
//add by wl 2020-06-03 WL0066   界面元素获取 
function GetVData()
{
	var val="^GetComponentID="+GetElementValue("GetComponentID");
	val=val+"^PrjName="+GetElementValue("PrjName");
	val=val+"^RequestNo="+GetElementValue("RequestNo");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^BRYear="+GetElementValue("BRYear");
	val=val+"^RequestLocDR="+GetElementValue("RequestLocDR");
	val=val+"^ApproveRole="+GetElementValue("ApproveRole");	
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	//messageShow("","","",GetElementValue("StartDate"))
	val=val+"^ApproveFlag="+GetElementValue("ApproveFlag");
	val=val+"^Action="+GetElementValue("Action");
	val=val+"^ManageLocDR="+GetElementValue("ManageLocDR");
	return val;
}

function BExport_Click()
{
	//add by wl 2020-06-03 WL0066  公共方法导出,原有的导出保留
	var ObjTJob=$('#tDHCEQYearBuyRequest').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	PrintDHCEQEquipNew("YearBuyRequest",1,TJob,GetVData())
	return;
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	//var TJob=getColumnValue(0,"TJob","tDHCEQYearBuyRequest")
	var TJob=""
	var Rows = $('#'+Component).datagrid('getRows');
	var RowCount=Rows.length
	if(RowCount<=0){
		jQuery.messager.alert("没有待保存数据");
		return;
	}
	else
	{
		TJob=Rows[0].TJob
	}
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
		messageShow("","","",e.message);
	}
}

function BSelectAll_Click()
{
	var obj=document.getElementById("BSelectAll")
	if (obj.innerText=="全选(当前页)")
	{
		obj.innerText="反选(当前页)"
		var flag="Y"
	}
	else
	{
		obj.innerText="全选(当前页)"
		var flag="N"
	}
	var Rows = $('#'+Component).datagrid('getRows');
	var RowCount=Rows.length
	for (var i=0;i<RowCount;i++)
	{
		Rows[i].TOperator=flag
	}
}
function BExecute_Click()
{
	//add 20191012 by zy 批量审核方式改变
	batchApprove()
	return
	var ErrorStr=""
	var Rows = $('#'+Component).datagrid('getRows');
	var RowCount=Rows.length
	if(RowCount<=0){
		jQuery.messager.alert("没有待保存数据");
		return;
	}
	var Count=0
	for (var i=0;i<RowCount;i++)
	{
		$('#'+Component).datagrid('endEdit',i);	//modified by czf 20190116
		var TOperator=Rows[i].TOperator
		if (TOperator=="Y")
		{
			Count=Count+1
			//未输入数量
			var ApproveNum=Rows[i].TApproveNum
			var RejectReason=Rows[i].TRejectReason
			var ApproveInfo=Rows[i].TApproveInfo
			var RequestNum=Rows[i].TRequestNum
			if (ApproveNum=="")
			{
				alertShow("["+Rows[i].TName+"] 未输入审批数量!")
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
				alertShow("["+Rows[i].TName+"] 请输入拒绝原因!")
				SetFocus("TRejectReasonz"+i)
				return
			}
			//数量不为0,未输入审批意见的
			if ((ApproveNum!=0)&&(ApproveInfo==""))
			{
				alertShow("["+Rows[i].TName+"] 请输入审批意见!")
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
	for (var i=0;i<=RowCount-1;i++)		//Modify DJ 2015-09-07 DJ0160
	{
		///modified by zy ZY0176 hisui改造
		InitEditFields(Rows[i].TApproveSet,CurRole)
		var TOperator=Rows[i].TOperator
		if (TOperator=="Y")
		{
			ApproveNum=Rows[i].TApproveNum
			var RoleStep=Rows[i].TRoleStep
			var combindata=Rows[i].TRowID;
			combindata=combindata+"^"+curUserID;
			combindata=combindata+"^"+Rows[i].TCancelToFlow;
			combindata=combindata+"^"+Rows[i].TApproveInfo;
			combindata=combindata+"^";
			combindata=combindata+"^"+Rows[i].TRejectReason;
			//审核
			if (ApproveNum!=0)
			{
				///modified by zy ZY0176 hisui改造
			  	//var objtbl=document.getElementById('tDHCEQYearBuyRequest');
			  	var objtbl=$('#tDHCEQYearBuyRequest')
				var EditFieldsInfo=ApproveEditFieldsInfo(objtbl,i);
				if (EditFieldsInfo=="-1") return;
				/*
				for(var j=i+1;j<RowCount;j++)                                  //modified by GR2014-10-24 begin 缺陷号3221
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
				}  */    											//modified by GR2014-10-24 end 缺陷号3221
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
		messageShow("","","",ErrorStr+"以上单据操作失败!")
	}
	///modified by zy ZY0176 hisui改造
	window.location.reload();
}

function GetRequestLoc(value)
{
	GetLookUpID("RequestLocDR",value);
}
//add 20191012 by zy 批量审核
function batchApprove()
{
	var Rows = $('#'+Component).datagrid('getRows');
	//modified by zy 20191025 ZY0194
	///add by zy 2019-10-21 点查找之后对象丢失
	if (typeof(Rows) === 'undefined')
	{
		messageShow("","","","请刷新界面后勾选要操作的数据!")
		return;
	}
	var RowCount=Rows.length;
	if(RowCount<=0){
		messageShow("","","","没有待处理数据!")
		return;
	}
	var Count=0
	var RowIDs=""
	var BuyReqNos=""
	for (var i=0;i<RowCount;i++)
	{
		$('#'+Component).datagrid('endEdit',i);	//modified by czf 20190116
		var TOperator=Rows[i].TOperator;
		if (TOperator=="1"||TOperator=="Y") //modified by csj 20191023
		{
			Count=Count+1
			if (RowIDs=="")
			{
				RowIDs=Rows[i].TRowID;
			}
			else
			{
				RowIDs=RowIDs+","+Rows[i].TRowID;
			}
		}
		$('#'+Component).datagrid('beginEdit',i); //add by zx 2019-09-16
	}
	if(Count==0){
		messageShow("","","","请勾选需要处理的数据!")
		return;
	}
	var Action=getElementValue("Action");
	var CurRole=getElementValue("ApproveRole");
	url="dhceq.em.buyrequestassign.csp?&Action="+Action+"&RowIDs="+RowIDs+"&CurRole="+CurRole;
	//alertShow(url)
	showWindow(url,"处理意见","","","icon-w-paper","modal","","","small",reloadGrid);
}

//add by zx 2019-06-01 批量修改后刷新列表数据
function reloadGrid()
{
	$('#'+Component).datagrid('reload');
}

document.body.onload = BodyLoadHandler;
