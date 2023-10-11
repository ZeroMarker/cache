var preRowID=0
var t=[]             //add hly 20190724
t[-3003]="数据重复"  //add hly 20190724
var columns=getCurColumnsInfo('RM.L.Rent.PriceType','','',''); //获取列定义
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//初始化查询头面板
function initTopPanel()
{
	defindTitleStyle();
	initButton(); //按钮初始化
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	initButtonWidth();
	initMessage("");   //Modefied by zc 2018-12-21  zc0047  修改弹出提示undefined
	setRequiredElements("PTCode^PTDesc")
	setEnabled();		//按钮控制
	initDHCEQSCPriceType();			//初始化表格
}
///初始化按钮状态
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
///选中行按钮状态
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}	
function OnclickRow()
{
	var selected=$('#tDHCEQSCPriceType').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			setElement("PTRowID",selectedRowID);
			setElement("PTCode",selected.TCode);
			setElement("PTDesc",selected.TDesc);
			setElement("PTRemark",selected.TRemark);
			preRowID=selectedRowID;
			UnderSelect()
		}
		else
		{
			ClearElement();
			$('#tDHCEQSCPriceType').datagrid('unselectAll');
			selectedRowID = 0;
			preRowID=0;
			setEnabled()
		}
	}
}
function ClearElement()
{
	setElement("PTRowID","");
	setElement("PTCode","");
	setElement("PTDesc","");
	setElement("PTRemark","");
}
function BFind_Clicked()
{
	initDHCEQSCPriceType()
}

function BAdd_Clicked()
{
	if(getElementValue("PTRowID")!=""){$.messager.alert('提示','新增失败,你可能选中一条记录！','warning');return;}
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTPriceType","SaveData",data,"2");
	jsonData=eval('(' + jsonData + ')')
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","新增成功！");
	var url="dhceq.rm.pricetype.csp";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
function BSave_Clicked()
{
	if(getElementValue("PTRowID")==""){$.messager.alert('提示','更新失败,你要选中一条记录！','warning');return;}
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTPriceType","SaveData",data,"2");
	jsonData=eval('(' + jsonData + ')')
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","更新成功");
	var url="dhceq.rm.pricetype.csp";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
function BDelete_Clicked()
{
	if(getElementValue("PTRowID")==""){$.messager.alert('提示','请选中一条需要删除的记录！','warning');return;}
	messageShow("confirm","info","提示",t[-9203],"",DeleteData,"")

}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTPriceType","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","删除成功！");
	var url="dhceq.rm.pricetype.csp";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
function initDHCEQSCPriceType()
{
	$HUI.datagrid("#tDHCEQSCPriceType",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.RM.CTPriceType",
	        QueryName:"GetPriceType",
	        Code:getElementValue("PTCode"),
			Desc:getElementValue("PTDesc"),
	    },
	    fie:true,
	    singleSelect:true,
		fitColumns:true,
		rownumbers:true,  //modefied by zc0107 2021-11-14 增加行号属性
		pagination:true,
    	columns:columns,
		onClickRow:function(rowIndex,rowData){OnclickRow();},

});
}
