var Columns=getCurColumnsInfo('BA.G.ResourceAllot','','','')
var SelectedRow=-1
jQuery(document).ready(function()
{
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	defindTitleStyle();
	initUserInfo();
    initMessage("ba"); //modified by ZY0288 2021-12-30
    initLookUp(); //初始化放大镜
    initElementData();
	initButton();
	initEvent();
	setEnabled(false)
	//modified by ZY 2690645 20220808
    setRequiredElements("RALoc^RAYear^RAMonth^RAResourceType^RAAmount^RARate^RAAllotAmount^RAAllotMode") 
	initDateGrid();
}

function initDateGrid()
{
	var LocDR=getElementValue("RALocDR")
	var ResourceTypeDR=getElementValue("RAResourceTypeDR")
	var Year=getElementValue("RAYear")
	var Month=getElementValue("RAMonth")
	$HUI.datagrid("#tDHCEQResourceAllot",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.BUSResourceAllot",
			QueryName:"GetResourceAllot",
			LocDR:LocDR,
			ResourceTypeDR:ResourceTypeDR,
			Year:Year,
			Month:Month,
		},
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列。
	    columns:Columns,
		pagination:true,
		onClickRow:function(rowIndex,rowData){onClickRow(rowIndex,rowData);},
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}
function onClickRow(rowIndex,rowData)
{
	if (SelectedRow==rowIndex)	
	{
		setElement("RARowID",""); 
		setElement("RALocDR",""); 
		setElement("RALoc",""); 
		setElement("RAYear",""); 
		setElement("RAMonth",""); 
		setElement("RAResourceTypeDR",""); 
		setElement("RAResourceType",""); 
		setElement("RAAmount",""); 
		setElement("RARate",""); 
		setElement("RAAllotAmount",""); 
		setElement("RAAllotMode",""); 
		setElement("RATotal",""); 
		setElement("RAStatus",""); 
		setElement("RARemark",""); 
		setElement("RAHold1",""); 
		setElement("RAHold2",""); 
		setElement("RAHold3",""); 
		setElement("RAHold4",""); 
		setElement("RAHold5",""); 
		SelectedRow=-1;
		setEnabled(false);
	}
	else
	{
		setElement("RARowID",rowData.RARowID); 
		setElement("RALocDR",rowData.RALocDR); 
		setElement("RALoc",rowData.RALoc); 
		setElement("RAYear",rowData.RAYear); 
		setElement("RAMonth",rowData.RAMonth); 
		setElement("RAResourceTypeDR",rowData.RAResourceTypeDR); 
		setElement("RAResourceType",rowData.RAResourceType); 
		setElement("RAAmount",rowData.RAAmount); 
		setElement("RARate",rowData.RARate); 
		setElement("RAAllotAmount",rowData.RAAllotAmount); 
		setElement("RAAllotMode",rowData.RAAllotMode);
		setElement("RATotal",rowData.RATotal); 
		setElement("RAStatus",rowData.RAStatus); 
		setElement("RARemark",rowData.RARemark); 
		setElement("RAHold1",rowData.RAHold1); 
		setElement("RAHold2",rowData.RAHold2); 
		setElement("RAHold3",rowData.RAHold3); 
		setElement("RAHold4",rowData.RAHold4); 
		setElement("RAHold5",rowData.RAHold5); 
		SelectedRow=rowIndex;
		setEnabled(true);
	}
}
function setEnabled(isselected)
{
	//disableElement("BSave",isselected);
	disableElement("BDelete",!isselected);
	disableElement("BSubmit",!isselected);
	//disableElement("BFind",isselected);
}
function initElementData()
{
	var RAAllotMode = $HUI.combobox('#RAAllotMode',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '1',
				text: '原值'
			},{
				id: '2',
				text: '收入'
			},{
				id: '3',
				text: '工作量'
			}]
	});
	jQuery("#RAAmount").change(function(){
		getRAAllotAmountValue()
		});
	jQuery("#RARate").change(function(){
		getRAAllotAmountValue()
		});
	
}
function getRAAllotAmountValue()
{
	var RAAmount=getElementValue("RAAmount")
	var RARate=getElementValue("RARate")/100
	setElement("RAAllotAmount",RAAmount*RARate)
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
	/*
	if(vElementID=="EquipType")
	{
		setElement("StatCatDR","")
		setElement("StatCat","")
	}
	*/
}
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	if (getElementValue("RAResourceTypeDR")=="")
	{
		alertShow("资源类型ID不能为空!")
		return
	}
	var RAYear=getElementValue("RAYear")
	if ((RAYear<2015)||(RAYear>2100))
	{
		alertShow("年度不规范,请修改(例:2021)!")
		return
	}
	var RAMonth=getElementValue("RAMonth")
	if ((RAMonth<0)||(RAMonth>12))
	{
		alertShow("月份不规范,请修改(1--12)!")
		return
	}
	var data=getInputList();
	data=JSON.stringify(data);
	disableElement("BSave",true)
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",data,"1");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.ba.resourceallot.csp?"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
	    disableElement("BSave",false)	//add by csj 2020-03-10 保存失败后启用
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
///modified by ZY 2853221 20220818
function BDelete_Clicked()
{
    ///modified by ZY0301 20220523
    var RAStatus=getElementValue("RAStatus")
    if (RAStatus>0)
    {
        alertShow("提示信息:记录已经提交,不能删除!");
        return
    }
    
    messageShow("confirm","info","提示","是否确定删除数据?","",function(){
            var RARowID=getElementValue("RARowID")
            var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",RARowID,"0");
            jsonData=JSON.parse(jsonData)
            if (jsonData.SQLCODE==0)
            {
                var url="dhceq.ba.resourceallot.csp?"
                if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
					url += "&MWToken="+websys_getMWToken()
				}
                window.location.href= url;
            }
            else
            {
                alertShow("错误信息:"+jsonData.Data);
                return
            }
        },function(){
        return;
    },"确定","取消");
    
}
function BSubmit_Clicked()
{
	var RARowID=getElementValue("RARowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",RARowID,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.ba.resourceallot.csp?"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BFind_Clicked()
{
	initDateGrid()
}

function initEvent()
{
	jQuery("#BImport").linkbutton({iconCls: 'icon-w-import'});
	jQuery("#BImport").on("click", BImport_Click);
}


function BImport_Click()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
}
//modified by ZY0302 20220601
function BImport_Chrome()
{
	var RowInfo=EQReadExcel('','','资源分配');
	RowInfo=RowInfo[0]
	if ((RowInfo=="")||(RowInfo.length<=1))		//add by czf 20200611 1342552 begin		//czf 20200811 1456821
	{
		alertShow("没有数据导入！")
		return 0;
	}
	var Error=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
		var Col=0;
		var UseLoc=trim(RowInfo[Row-1][Col++]);
		var Year=trim(RowInfo[Row-1][Col++]);
		var Month=trim(RowInfo[Row-1][Col++]);
		var ResourceType=trim(RowInfo[Row-1][Col++]);
		var Amount=trim(RowInfo[Row-1][Col++]);
		var Rate=trim(RowInfo[Row-1][Col++]);
		var AllotAmount=trim(RowInfo[Row-1][Col++]);
		var AllotMode=trim(RowInfo[Row-1][Col++]);	///1,2,3
		var Total=trim(RowInfo[Row-1][Col++]);
		if (UseLoc!="")
		{
			UseLoc=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",UseLoc);
			if (UseLoc=="")
			{
				alertShow("第"+Row+"行 使用部门的信息不正确:"+UseLoc);
				return 0;
			}
		}
		if (ResourceType!="")
		{
			ResourceType=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCResourceType",ResourceType);
			if (ResourceType=="")
			{
				alertShow("第"+Row+"行 设备资源类型的信息不正确:"+ResourceType);
				return 0;
			}
		}
		//var datas=[]
		var data={}
		data["RALocDR"]=UseLoc
		data["RAYear"]=Year
		data["RAMonth"]=Month
		data["RAResourceTypeDR"]=ResourceType
		data["RAAmount"]=Amount
		data["RARate"]=Rate
		data["RAAllotAmount"]=AllotAmount
		data["RAAllotMode"]=AllotMode
		data["RATotal"]=Total
		//datas.push(data)
		data=JSON.stringify(data);
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",data,"1");
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE<0)
		{
			Error="第"+Row+"行信息导入失败!!!"+jsonData.Data
			alertShow(Error);
			Row=RowInfo.length+1
		}
	}
	if (Error=="")
	{
		messageShow('alert','info','提示','导入资源分配信息操作完成!请核对相关信息.','',importreload,'');		
	}
}
function importreload()
{
	window.location.reload();
}
//modified by ZY0302 20220601
function BImport_IE()
{
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets("资源分配");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var UseLoc=trim(xlsheet.cells(Row,Col++).text);
		var Year=trim(xlsheet.cells(Row,Col++).text);
		var Month=trim(xlsheet.cells(Row,Col++).text);
		var ResourceType=trim(xlsheet.cells(Row,Col++).text);		//czf 20200811
		var Amount=trim(xlsheet.cells(Row,Col++).text);
		var Rate=trim(xlsheet.cells(Row,Col++).text);
		var AllotAmount=trim(xlsheet.cells(Row,Col++).text);
		var AllotMode=trim(xlsheet.cells(Row,Col++).text);
		var Total=trim(xlsheet.cells(Row,Col++).text);
		if (UseLoc!="")
		{
			UseLoc=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",UseLoc);
			if (UseLoc=="")
			{
				alertShow("第"+Row+"行 使用部门的信息不正确:"+UseLoc);
				return 0;
			}
		}
		if (ResourceType!="")
		{
			ResourceType=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCResourceType",ResourceType);
			if (ResourceType=="")
			{
				alertShow("第"+Row+"行 设备资源类型的信息不正确:"+ResourceType);
				return 0;
			}
		}
		//var datas=[]
		var data={}
		data["RALocDR"]=UseLoc
		data["RAYear"]=Year
		data["RAMonth"]=Month
		data["RAResourceTypeDR"]=ResourceType
		data["RAAmount"]=Amount
		data["RARate"]=Rate
		data["RAAllotAmount"]=AllotAmount
		data["RAAllotMode"]=AllotMode
		data["RATotal"]=Total
		//datas.push(data)
		data=JSON.stringify(data);
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSResourceAllot","SaveData",data,"1");
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE<0)
		{
			alertShow("第"+i+"行 <"+xlsheet.cells(i,4).text+"> 信息导入失败!!"+jsonData.Data);;
		}
	}
	xlsheet.Quit;
	xlsheet=null;
	xlBook.Close (savechanges=false);
	xlApp=null;
	alertShow("导入资源分配信息操作完成!请核对相关信息.");
	window.location.reload();
}
