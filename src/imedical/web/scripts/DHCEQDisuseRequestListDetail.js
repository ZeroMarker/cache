/// DHCEQDisuseRequestListDetail.js
/// Mozy0074 2011-12-21
var RecoverFlag=""
function BodyLoadHandler()
{
	initUserInfo(); //modify by mwz 20210423 MWZ0047
	InitPage();
	SetStatus();
	fillData();
	initKeywords();	//Add by QW2021518 BUG:QW0111 增加状态进度
	RefreshData();
	initButtonWidth();	//modified by czf 20180827 HISUI改造
	initButtonColor();		//初始化极简积极按钮颜色   add by jyp 2023-02-06
	initPanelHeaderStyle();  //初始化极简面板标题样式    add by jyp 2023-02-06
	//HiddenTableIcon("DHCEQDisuseRequestListDetail","TDRRowID","TDetail");
	if (GetElementValue("RecoverFlag")!=1)		//modifed by czf 2021-01-14 CZF0129
	{
		HiddenObj("BCancelAudit",1)
		$('#tDHCEQDisuseRequestListDetail').datagrid('hideColumn', 'TCheckFlag'); 	//隐藏选择框列	
	}
	$('#tDHCEQDisuseRequestListDetail').datagrid('options').view.onAfterRender = ReLoadGrid;
}

function ReLoadGrid()
{
	creatToolbar();
	fixTGrid();
}

function InitPage()
{
	Muilt_LookUp("RequestLoc^UserLoc^EquipType^ApproveRole^IsPrint^Hospital");  //回车选择 Modied By QW20210629 BUG:QW0131 院区	
	KeyUp("RequestLoc^UserLoc^EquipType^ApproveRole^IsPrint^Hospital"); //清空选择 Modied By QW20210629 BUG:QW0131 院区
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BSaveExcel");
	if (obj) obj.onclick=BSaveExcel_Click;
	var obj=document.getElementById("BCancelAudit");		//Modified by QW20200319 Bug:QW0048 取消报废
	if (obj) obj.onclick=BCancelAudit_Click;
	//Add By QW20210629 BUG:QW0131 院区 begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	//Add By QW20210629 BUG:QW0131 院区 end
}

///需求号：723930 add  by kdf 2018-10-29 隐藏合计行的图标
var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender;
$.extend($.fn.datagrid.defaults.view, {
            onAfterRender: function(target){
                onAfterRender.call(this, target);
	           	HiddenTableIcon("DHCEQDisuseRequestListDetail","TDRRowID","TApprovals");
	         
            }
});

function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"));
}
function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"dept=RequestLoc="+GetElementValue("RequestLocDR")+"^";
	val=val+"dept=UserLoc="+GetElementValue("UserLocDR")+"^";
	val=val+"equiptype=EquipType="+GetElementValue("EquipTypeDR")+"^";
	val=val+"isprint=IsPrint="+GetElementValue("IsPrintDR")+"^";  //Add By QW20210429 BUG:QW0102
	val=val+"hos=Hospital="+GetElementValue("HospitalDR")+"^"; //Add By QW20210629 BUG:QW0131 院区
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}
function RefreshData()
{

	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Click();
}

function BFind_Click()
{
	// Modified By QW20200218 begin BUG:QW0041 测试需求:报废权限限制	
	var val="&vData="+GetVData()+"&QXType=&RecoverFlag="+GetElementValue("RecoverFlag")+"&TMENU="+GetElementValue("TMENU"); //modified by sjh SJH0028 2020-06-23
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestListDetail"+val
	// Modified By QW20200218 begin BUG:QW0041 测试需求:报废权限限制
}

function GetVData()
{
	var	val="^RequestNo="+GetElementValue("RequestNo");
	val=val+"^InStockNo="+GetElementValue("InStockNo");
	val=val+"^Equip="+GetElementValue("Equip");
	val=val+"^No="+GetElementValue("No");
	val=val+"^MinPrice="+GetElementValue("MinPrice");
	val=val+"^MaxPrice="+GetElementValue("MaxPrice");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^RequestLoc="+GetElementValue("RequestLoc");	
	val=val+"^RequestLocDR="+GetElementValue("RequestLocDR");
	val=val+"^UserLoc="+GetElementValue("UserLoc");
	val=val+"^UserLocDR="+GetElementValue("UserLocDR");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^EquipType="+GetElementValue("EquipType");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"^ApproveRole="+GetElementValue("ApproveRole");
	val=val+"^ApproveRoleDR="+GetElementValue("ApproveRoleDR");
	val=val+"^ApproveDate="+GetElementValue("ApproveDate");
	val=val+"^ApproveEndDate="+GetElementValue("ApproveEndDate");
	val=val+"^IsPrintDR="+GetElementValue("IsPrintDR");  //Add By QW20210429 BUG:QW0102
	val=val+"^ActionItemString="+getKeywordsData();		//Add By QW2021518 BUG:QW0111  状态进度 Begin
	val=val+"^HospitalDR="+GetElementValue("HospitalDR");   //Add By QW20210629 BUG:QW0131 院区
	return val;
}

function GetRequestLoc(value)
{
	GetLookUpID("RequestLocDR",value);
}
function GetUserLoc(value)
{
	GetLookUpID("UserLocDR",value);
}
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}

// 20140409  Mozy0125
function GetApproveRole(value)
{
	GetLookUpID("ApproveRoleDR",value);
}

function BSaveExcel_Click()
{
	var ObjTJob=$('#tDHCEQDisuseRequestListDetail').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		if (!CheckColset("DisuseRequestDetail"))
		{
			messageShow('popover','alert','提示',"导出数据列未设置!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQDisuseListExport.raq&CurTableName=DisuseRequestDetail&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
	}
	else
	{
		BExportByExcel()
	}
}

//Excel导出
function BExportByExcel()
{
	if (GetElementValue("ChromeFlag")=="1")
	{
		BSaveExcel_Chrome()
	}
	else
	{
		BSaveExcel_IE()
	}
}

function BSaveExcel_Chrome()
{
	var Node="DisuseRequestDetail";
	var encmeth=GetElementValue("GetTempDataRows");
	var currentobj=$("#tDHCEQDisuseRequestListDetail").datagrid('getRows');
	if (currentobj) {var TJob=currentobj[0]['TJob'];} 
	if (TJob=="")  return;
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	var PageRows=TotalRows; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
    var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var TemplatePath=cspRunServerMethod(encmeth);
    var Template=TemplatePath+"DHCEQRequestListDetail.xls";
	var encmeth=GetElementValue("GetTempData");
	var AllListInfo=new Array();
	for (var i=0;i<=Pages;i++)
	{
    	var OnePageRow=PageRows;
    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
    	for (var k=1;k<=OnePageRow;k++)
    	{
	    	var l=i*PageRows+k
	    	// modified by sjh SJH0044 2021-01-21 替换类组中出现的逗号 start
	    	var OneDetails=cspRunServerMethod(encmeth,Node,TJob,l);
	    	var OneDetail =OneDetails.replace(",","，");
	    	var OneDetailList=OneDetail.split("^");
	    	// modified by sjh SJH0044 2021-01-21  end
	    	AllListInfo.push(OneDetail)
    	}
	}
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var NewFileName=filepath(FileName,"\\","\\\\")
	var NewFileName=NewFileName.substr(0,NewFileName.length-4)
	
	//Chorme浏览器兼容性处理
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="xlApp = new ActiveXObject('Excel.Application');"
	Str +="for (var i=0;i<="+Pages+";i++){"
	Str +="xlBook = xlApp.Workbooks.Add('"+Template+"');"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="xlsheet.PageSetup.TopMargin=0;"
	Str +="var OnePageRow="+PageRows+";"
	Str +="if ((i=="+Pages+")&&("+ModRows+"!=0)) OnePageRow="+ModRows+";"
	Str +="xlsheet.cells.replace('[Hospital]','"+curSSHospitalName+"');" //modify by mwz 20210415 MWZ0046 
	Str +="for (var k=1;k<=OnePageRow;k++){"
	Str +="var l=i*"+PageRows+"+k;"
	Str +="var AllListInfoStr='"+AllListInfo+"';"
	Str +="var AllListInfo=AllListInfoStr.split(',');"
	Str +="var OneDetailList=AllListInfo[l-1].split('^');"
	Str +="var j=k+3;"
	Str +="xlsheet.Rows(j).Insert();"
	Str +="var col=1;"
	Str +="xlsheet.cells(j,col++)=OneDetailList[0];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[1];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[2];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[3];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[4];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[5];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[6];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[7];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[8];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[9];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[10];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[11];}"
	Str +="xlsheet.Rows(j+1).Delete();"
	Str +="var printpage='';"
	Str +="if (i>0) {printpage='_'+i;}"
	Str +="var savefile='"+NewFileName+"'+printpage+'.xls';"
	Str +="xlBook.SaveAs(savefile);"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;}"
	Str +="xlApp=null;"
	Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn = 0;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
    alertShow("导出完成!");
}
//modify by wl 2019-12-24 WL0036 Hisui改造
function BSaveExcel_IE()
{
	var Node="DisuseRequestDetail";
	var encmeth=GetElementValue("GetTempDataRows");
	var currentobj=$("#tDHCEQDisuseRequestListDetail").datagrid('getRows');
	if (currentobj) {var TJob=currentobj[0]['TJob'];} 
	if (TJob=="")  return;
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	var PageRows=TotalRows; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
        var encmeth=GetElementValue("GetRepPath");
		if (encmeth=="") return;
		var TemplatePath=cspRunServerMethod(encmeth);
	    var Template=TemplatePath+"DHCEQRequestListDetail.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	//xlsheet.cells(2,1)=xlsheet.cells(2,1) //+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	xlsheet.cells.replace("[Hospital]",curHospitalName);    // add by sjh SJH0044 2021-01-21
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	// modified by sjh SJH0044 2021-01-21 替换类组中出现的逗号 start
	    		var OneDetails=cspRunServerMethod(encmeth,Node,TJob,l); 
	    		var OneDetail =OneDetails.replace(",","，");
	    		var OneDetailList=OneDetail.split("^");
		    	// modified by sjh SJH0044 2021-01-21  end
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
				//	0				1					2			3			4		   5			6				7				8			 9			10			 11
				//TRequestNo_"^"_TRequestDate_"^"_TRequestLoc_"^"_TUserLoc_"^"_TEquip_"^"_TNo_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TEquipType_"^"_TStatus_"^"_TUnit_"^"_TInStockNo
		    	xlsheet.cells(j,col++)=OneDetailList[0];
		    	xlsheet.cells(j,col++)=OneDetailList[1];
		    	xlsheet.cells(j,col++)=OneDetailList[2];
		    	xlsheet.cells(j,col++)=OneDetailList[3];
		    	xlsheet.cells(j,col++)=OneDetailList[4];
		    	xlsheet.cells(j,col++)=OneDetailList[5];
		    	xlsheet.cells(j,col++)=OneDetailList[6];
		    	xlsheet.cells(j,col++)=OneDetailList[7];
		    	xlsheet.cells(j,col++)=OneDetailList[8];
		    	xlsheet.cells(j,col++)=OneDetailList[9];
		    	xlsheet.cells(j,col++)=OneDetailList[10];
		    	xlsheet.cells(j,col++)=OneDetailList[11];
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
			//xlsheet.cells(2,1)="时间范围:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="制表人:"+curUserName

			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	       	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("导出完成!");
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
}

function BodyUnLoadHandler()
{
	//var encmeth=GetElementValue("KillTempGlobal");
	//cspRunServerMethod(encmeth,"DisuseRequestDetail");
}

//取消报废
//add by CZF0063 2020-02-24
//modified by czf 2021-01-14 CZF0129
function BCancelAudit_Click()
{
	var valRowIDs=""			
	var count=0;
	var rows = $('#tDHCEQDisuseRequestListDetail').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		if (getColumnValue(i,"TCheckFlag")==1)
		{
			if (valRowIDs!="") valRowIDs=valRowIDs+",";
			valRowIDs=valRowIDs+rows[i].TNo;
			count=count+1;
		}
	}
	if (count==0)
	{
		messageShow('alert','error','错误提示','请选择要取消报废的设备!');
	}
	else
	{
		messageShow("confirm","","","将对当前列表设备: "+valRowIDs+"取消报废,确定执行吗?","",ConfirmOpt);
	}
}

//modified by czf 2021-01-14 CZF0129
function ConfirmOpt()
{
	var ErrorStr=""
	var selectrow = $('#tDHCEQDisuseRequestListDetail').datagrid('getRows');
	for (var i = 0; i < selectrow.length; i++) 
	{
		if (getColumnValue(i,"TCheckFlag")==1)
		{
			var TRequestNo=selectrow[i]['TRequestNo'];
			var TEquipNo=selectrow[i]['TNo'];
			var TDRRowID=selectrow[i]['TDRRowID'];
			var Rtn=tkMakeServerCall("web.DHCEQBatchDisuseRequest","RecoverDisUseEquip",TDRRowID,TEquipNo)
			var RtnArr=Rtn.split("^")
			if(RtnArr[0]!=0) ErrorStr=TEquipNo+Rtn+","+ErrorStr
		}
	}
	if (ErrorStr!="")
	{
		alertShow(ErrorStr)
		return;
	}
	else
	{
		alertShow("取消报废成功!")
		var val="&vData="+GetVData()+"&QXType=&RecoverFlag="+GetElementValue("RecoverFlag")+"&TMENU="+GetElementValue("TMENU"); 
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			val += "&MWToken="+websys_getMWToken()
		}
		window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestListDetail"+val;
	}
}
//Add By QW20210326
function GetIsPrint(value)
{
	GetLookUpID("IsPrintDR",value);
}

//Add by QW2021518 BUG:QW0111 增加状态进度
function initKeywords()
{
	if(getElementValue("ActionItemString")!="")
	{ 
		var arr=new Array()
		var  CurData=getElementValue("ActionItemString");
		var SplitNumCode=",";
		arr= CurData.split(SplitNumCode);
		for(var i=0 ;i <arr.length;i++)
		{ 
			$("#ActionItemDetail").keywords("select",arr[i])
		}
	}
 }
///Add By QW2021518 BUG:QW0111 获取状态进度
function getKeywordsData()
{ 
	var SelectType=$("#ActionItemDetail").keywords("getSelected");
	var ActionItemString=""
	for (var j=0;j<SelectType.length;j++)
	{
		if(ActionItemString=="")
		{
			ActionItemString=SelectType[j].id
		}else
		{
			ActionItemString=ActionItemString+","+SelectType[j].id
		}
	}
	return ActionItemString;
	
}
///Add By QW2021518 BUG:QW0111 初始化状态进度
$(function(){
	initActionItem();
})


///Add By QW2021518 BUG:QW0111 初始化状态进度
function initActionItem()
{
	var ActionItem = [];
	var Vallist=tkMakeServerCall("web.DHCEQCommon","GetBussApproveFlow","34")
	Vallist=Vallist.replace(/\\n/g,"\n");
	
	ActionItem.push({text:'不限',id:'0'});
	var list=Vallist.split("&");
	for (var i=0;i<=list.length-1;i++)
	{
		var id=list[i].split(",")[0];
		var text=list[i].split(",")[2]
		ActionItem.push({text:text,id:id});
	}

    $("#ActionItemDetail").keywords({
	    	singleSelect:true,
	    	//Modify by zx 2021-07-07 BUG ZX0136 避免换行
	    	items:ActionItem
	});
}
//Add By QW20210629 BUG:QW0131 院区
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}

//czf 2022-06-06
//显示报废合计行
function creatToolbar()
{
	var Node="DisuseRequestDetail";
	var encmeth=GetElementValue("GetTempDataRows");
	var currentobj=$("#tDHCEQDisuseRequestListDetail").datagrid('getRows');
	if (currentobj.length>0)
	{
		var TJob=currentobj[0]['TJob'];
		if (TJob=="")  return;
		
		var Data = tkMakeServerCall("web.DHCEQDisuseRequestList","GetSumInfo",TJob); 
		$("#sumTotal").html(Data);
	} 
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
