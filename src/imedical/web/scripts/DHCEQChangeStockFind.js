///Modified By HZY 2011-10-08 HZY0013
///修改函数:BodyLoadHandler , GetHref , InitPage , BPrint_Click
///增加函数:GetToLoc , SetValues , GetEquipType , ChangeType_Change
///--------------------------------
///修改: ZY 2009-11-17 ZY0017
///修改函数BPrint_Click
///描述:导出时保存路径的设置
/// -------------------------------
function BodyLoadHandler(){	
   	//modified by cjt 20230211 需求号3220786 UI页面改造
   	initPanelHeaderStyle();
	InitPage();
	ChangeType_Change();
	SetValues();	//Add By HZY 2011-10-08 HZY0013
    initButtonWidth(); //HISUI改造-修改按钮展示样式	add by kdf 2018-09-04

}

///Add By HZY 2011-10-08 HZY0013
function SetValues()
{
	SetElement("ChangeType",GetElementValue("ChangeTypeDR"))
	SetElement("SubChangeType",GetElementValue("SubChangeTypeDR"))
}


function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}


///Modified By HZY 2011-10-10 HZY0013
///Desc:添加'变动主类型'变化响应事件的初始化 .
function InitPage()
{
	KeyUp("StoreLoc^Equip^ToLoc^EquipType");
	Muilt_LookUp("StoreLoc^Equip^ToLoc^EquipType");
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;

    //var obj=document.getElementById("BFind");
	//if (obj) obj.onclick=BFind_Click;
	
	// HISUI改造-修改下拉列表的选中事件 add by kdf  2018-09-04 begin
	$('#ChangeType').combobox('options').onSelect = function (){
		ChangeType_Change();
		} 
	// HISUI改造-add by kdf  2018-09-04 end	
}

function BFind_Click()
{
	
	var ChangeType=GetElementValue("ChangeType");
	var SubChangeType=GetElementValue("SubChangeType");
	var StartDate=GetElementValue("StartDate");	
	var EndDate=GetElementValue("EndDate");
	
	val="&ChangeType="+ChangeType+"&SubChangeType="+SubChangeType+"&StartDate="+StartDate+"&EndDate="+EndDate ;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQChangeStockFind"+val; ////HISUI改造 更换csp modified by kdf 2018-09-04
}
/// modified by ZY0303 20220614 2676079
///Add By HZY 2011-10-09 HZY0013
///Desc:'变动主类型'变化事件的响应函数 .
function ChangeType_Change()
{
	if (GetElementValue("ChangeType")=="")
	{
		SetElement("SubChangeType","");
		SetElement("SubChangeTypeDR","");
		return;
	}
	else
	{
		
		SetElement("ChangeTypeDR",GetElementValue("ChangeType"));	
		var obj=document.getElementById("SubChangeType");	
		if (obj)
		{
			SetElement("SubChangeType","");
			SetElement("SubChangeTypeDR","");
			//add by zx 2018-10-12 combobox数据集改变
	        var ChangeType=GetElementValue("ChangeType");
			if (ChangeType=="1")
			{	
				var cbox = $HUI.combobox("#SubChangeType",{
				  valueField:'id', textField:'text', multiple:false, selectOnNavigation:false,panelHeight:"auto",
				  data:[
					  {id:'0',text:'库房分配'}
					  ,{id:'1',text:'科室调拨'}
					  ,{id:'3',text:'科室退库'}
				  ],
				  editable:false,
				  onSelect:function(row){
					  SetElement("SubChangeTypeDR",row.id);
				},
			  });
			}
			else if(ChangeType=="3")
			{
				var cbox = $HUI.combobox("#SubChangeType",{
				  valueField:'id', textField:'text', multiple:false, selectOnNavigation:false,panelHeight:"auto",
				  data:[
	//				  {id:'1',text:'退货'}
	//				  ,{id:'2',text:'报废'}  modify hly 2019/09/30
					  {id:'3',text:'调拨'}
					  ,{id:'4',text:'盘亏'}
					  ,{id:'5',text:'出售'}
					  ,{id:'6',text:'捐赠'}
					  ,{id:'7',text:'其他'}
				  ],
				 editable:false,
				 onSelect:function(row){
					  SetElement("SubChangeTypeDR",row.id);
				},
			  });
			}
			else
			{
				var cbox = $HUI.combobox("#SubChangeType",{
				  valueField:'id', textField:'text', multiple:false, selectOnNavigation:false,panelHeight:"auto",
				  data:[
				  ],
				  editable:false,
				  onSelect:function(row){
					  SetElement("SubChangeTypeDR",row.id);
				},
			  });
			}
			
			return;
		}
	}
}

//add by sjh 2020-06-04 SJH0024   界面元素获取 
function GetVData()
{	
	var val="^GetComponentID="+GetElementValue("GetComponentID");
	val=val+"^GetChangeStockDetail="+GetElementValue("GetChangeStockDetail");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^EquipDR="+GetElementValue("EquipDR");
	val=val+"^StoreLocDR="+GetElementValue("StoreLocDR");
	val=val+"^FromLocDR="+GetElementValue("FromLocDR");	
	val=val+"^ToLocDR="+GetElementValue("ToLocDR");
	val=val+"^ChangeTypeDR="+GetElementValue("ChangeTypeDR");
	val=val+"^SubChangeTypeDR="+GetElementValue("SubChangeTypeDR");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	return val;
}
///add by mwz 20220117 mwz0057
function BPrint_Click()
{
	var ObjTJob=$('#tDHCEQChangeStockFind').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		// MZY0119	2563540		2022-04-07
		if (!CheckColset("ChangeStock"))
		{
			messageShow('popover','alert','提示',"导出数据列未设置!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQChangeStockExport.raq&CurTableName=ChangeStock&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		BPrintExcel_Click();
	}
	
}
/// Modified By HZY 2011-10-10 HZY0013
/// Desc:增加5个导出打印的字段,并调整了打印模板 DHCEQChangeStock.xls .
/// ----------------------------------
///Creator:ZY  2009-03-19 ZY0017
///打印导出功能
function BPrintExcel_Click()
{
	//0            1              2                 3          4              5               6                 7             8               9          10            11            12                  13                14
	//TRowID_"^"_TEquipDR_"^"_TStoreLocDR_"^"_TFromToLoc_"^"_TSourceID_"^"_TChangeType_"^"_TChangeDate_"^"_TAuditUserDR_"^"_TAuditDate_"^"_TEquip_"^"_TStoreLoc_"^"_TAuditUser_"^"_TChangeTypeDR_"^"_TParSourceID_"^"_TBillChangeDate
	//var encmeth=GetElementValue("GetPath");
	//if (encmeth=="") return;
	//var	TemplatePath=cspRunServerMethod(encmeth);
	
	//var ObjTJob=document.getElementById("TJobz1");
	//if (ObjTJob)  TJob=ObjTJob.value;
	
	//HISUI改造-修改TJob取值获取不到的问题 begin add by kdf 2018-09-07
	var ObjTJob=$('#tDHCEQChangeStockFind').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	//HISUI改造-修改TJob取值获取不到的问题  end add by kdf 2018-09-07
	
	if (TJob=="")  return;
	//add by sjh 2020-06-04 SJH0024  公共方法导出,原有的导出保留
	PrintDHCEQEquipNew("ChangeStock",1,TJob,GetVData())
	return;
	var encmeth=GetElementValue("GetChangeStockDetail");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);

	var PageRows=43 //每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //总页数-1
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQChangeStock.xls";
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
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
			    var OneDetail=cspRunServerMethod(encmeth,l,TJob);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
				//Modified By QW20190312 BUG:846347
			    var StoreLoc=OneDetailList[10]
			    var FromLoc=OneDetailList[3]
		    	//End By By QW20190312 BUG:846347
		    	//Start Modified By HZY 2011-10-10 HZY0013
		    	xlsheet.cells(j,1)=OneDetailList[9];
		    	xlsheet.cells(j,2)=OneDetailList[16];
		    	xlsheet.cells(j,3)=OneDetailList[19];
		    	xlsheet.cells(j,4)=OneDetailList[15];
		    	xlsheet.cells(j,5)=OneDetailList[20];
		    	xlsheet.cells(j,6)=OneDetailList[22];
		    	xlsheet.cells(j,7)=OneDetailList[5];
		    	xlsheet.cells(j,8)=StoreLoc;
		    	xlsheet.cells(j,9)=FromLoc;
		    	xlsheet.cells(j,10)=FormatDate(OneDetailList[6]);
		    	//End Modified By HZY 2011-10-10 HZY0013
			}
			
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
			xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(j+1,5)="制表人:"
			xlsheet.cells(j+1,6)=curUserName
	    	//xlsheet.printout; //打印输出
			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
			alertShow('保存成功,保存路径:'+savepath);	//Add By HZY 2011-10-10 HZY0013
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
function GetStoreLoc(value)
{
	GetLookUpID("StoreLocDR",value);
}

///Add By HZY 2011-10-08 HZY0013
function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}
///Add By HZY 2011-10-08 HZY0013
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}

function GetEquip(value)
{
	GetLookUpID("EquipDR",value);
}
document.body.onload = BodyLoadHandler;
