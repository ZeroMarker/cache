var SelectedRow="undefined";
var GType=getElementValue("GType");
var Columns=getCurColumnsInfo('BA.G.Gather','','','')
var ColumnsList=getCurColumnsInfo('BA.G.GatherList','','','')
$(document).ready(function()
{
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  
	
});
function initDocument()
{
	initUserInfo();
    initMessage(""); //获取所有业务消息
    initLookUp(); //初始化放大镜
	defindTitleStyle(); 
    initButton(); //按钮初始化
    initPage(); //非通用按钮初始化
    initButtonWidth();
    setEnabled(true); //按钮控制
    initGatherList("")
	$HUI.datagrid("#tDHCEQGather",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSGather",
	        	QueryName:"Gather",
	        	Type:GType
		},
		rownumbers: true,  //如果为true，则显示一个行号列。
		fit:true,
	    singleSelect:true,
		fitColumns:false,    //modify by lmm 2018-11-07 734076
		pagination:true,
		striped : true,
	    cache: false,
		columns:Columns,
		onClickRow:function(rowIndex,rowData){SelectRowHandler(rowIndex,rowData);},
		
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}
function initPage()
{
	
	if (jQuery("#BExecte").length>0)
	{
		jQuery("#BExecte").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BExecte").on("click", BExecte_Clicked);
	}
	if (jQuery("#BContinue").length>0)
	{
		jQuery("#BContinue").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BContinue").on("click", BContinue_Clicked);
	}
}
function BSave_Clicked()
{
	if (getElementValue("GStartDate")=="")
	{
		alertShow("开始日期不能为空!")
		return
	}
	if (getElementValue("GEndDate")=="")
	{
		alertShow("结束日期不能为空!")		// MZY0126	2656178		2022-06-13
		return
	}
	setElement("GStatus",0);
	var data=getInputList();
	data=JSON.stringify(data);
	disableElement("BSave",true)
	
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSGather","SaveData",data,"0");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		disableElement("BSave",false);
		alertShow("保存成功!");
		url="dhceq.ba.gather.csp?"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
		return
	}
	else
    {
	    disableElement("BSave",false)
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	var GRowID=getElementValue("GRowID")
	if (GRowID=="")
	{
		alertShow("记录不能为空!")
		return
	}
	var GStatus=getElementValue("GStatus")
	if (GStatus!="0")
	{
		alertShow("记录不能删除!")
		return
	}
	setElement("GStatus",0);
	var data=getInputList();
	disableElement("BDelete",true)
	
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSGather","SaveData",GRowID,"1");
	jsonData=JSON.parse(jsonData);
	
	if (jsonData.SQLCODE==0)
	{
		disableElement("BDelete",false);
		alertShow("删除成功!");
		url="dhceq.ba.gather.csp?"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
		return
	}
	else
    {
	    disableElement("BDelete",false)
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BExecte_Clicked()
{
	if (getElementValue("GStartDate")=="")
	{
		alertShow("开始日期不能为空!")
		return
	}
	if (getElementValue("GEndDate")=="")
	{
		alertShow("结束不能为空!")
		return
	}
	setElement("GStatus",1);
	var data=getInputList();
	data=JSON.stringify(data);
	disableElement("BSave",true)
	
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSGather","SaveData",data,"0");
	jsonData=JSON.parse(jsonData);
	
	if (jsonData.SQLCODE==0)
	{
		disableElement("BSave",false);
		alertShow("保存成功!");
		url="dhceq.ba.gather.csp?"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
		return
	}
	else
    {
	    disableElement("BSave",false)
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BContinue_Clicked()
{
	if (getElementValue("GStartDate")=="")
	{
		alertShow("开始日期不能为空!")
		return
	}
	if (getElementValue("GEndDate")=="")
	{
		alertShow("结束不能为空!")
		return
	}
	setElement("GStatus",1);
	var data=getInputList();
	data=JSON.stringify(data);
	disableElement("BSave",true)
	
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSGather","SaveData",data,"0");
	jsonData=JSON.parse(jsonData);
	
	if (jsonData.SQLCODE==0)
	{
		disableElement("BSave",false);
		alertShow("保存成功!");
		url="dhceq.ba.gather.csp?"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
		return
	}
	else
    {
	    disableElement("BSave",false)
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}

function setEnabled(flag)
{
	var GStatus=getElementValue("GStatus")
	if (GStatus=="0")
	{
		disableElement("BSave",false);
		disableElement("BDelete",false);
		disableElement("BExecte",false);
		disableElement("BContinue",true);
	}else if (GStatus=="1")
	{
		disableElement("BDelete",true);
		disableElement("BExecte",true);
	}else if (GStatus=="2")
	{
		disableElement("BDelete",true);
		disableElement("BExecte",true);
		disableElement("BContinue",false);
	}
	else if (GStatus=="3")
	{
		disableElement("BDelete",true);
		disableElement("BExecte",true);
		disableElement("BContinue",true);
	}
	else
	{
		disableElement("BDelete",true);
		disableElement("BExecte",true);
		disableElement("BContinue",true);
	}
}
function SelectRowHandler(rowIndex,rowData)
{
	if (rowIndex==SelectedRow)
	{
		setElement("GRowID","");
		setElement("GStartDate","");
		setElement("GEndDate",""); 
		setElement("GStatus","");
		SelectedRow= "undefined";
		setEnabled(true)
	}
	else
	{
		setElementByJson(rowData);
		setEnabled(false)
		var GRowID=getElementValue("GRowID");
		SelectedRow=rowIndex
		initGatherList(GRowID)
	}
}

function initGatherList(GRowID)
{
	$HUI.datagrid("#tDHCEQGatherList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSGather",
	        	QueryName:"GatherList",
	        	GatherDR:GRowID
		},
		rownumbers: true,  //如果为true，则显示一个行号列。
		fit:true,
	    singleSelect:true,
		fitColumns:false,    //modify by lmm 2018-11-07 734076
		pagination:true,
		striped : true,
	    cache: false,
		columns:ColumnsList,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}
