var selectedRowID = "";	//取当前选中的组件设备记录ID
var t=[]             //add hly 20190724
t[-3003]="数据重复"  //add hly 20190724
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
	initButtonWidth();
	initButton(); //按钮初始化
	jQuery('#BAdd').on("click", BAdd_Clicked);
	defindTitleStyle();
	initMessage("");  
	initLookUp(); //初始化放大镜
	initPMTTypeData()
	setRequiredElements("PMTLMaintItemDR_MIDesc^PMTLSort")
	setEnabled();		//按钮控制
	initDHCEQPMTemplateList();			//初始化表格
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
function initPMTTypeData()
{
	var PMTType = $HUI.combobox('#PMTType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '1',
				text: '保养'
			},{
				id: '2',
				text: '检查'
			},{
				id: '3',
				text: '维修'
			}]
	});
}
function BAdd_Clicked()
{
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SavePMTemplateList",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","新增成功！");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplatelist.csp?&PMTLTemplateDR="+getElementValue("PMTLTemplateDR")},50);
}
function BSave_Clicked()
{	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SavePMTemplateList",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","更新成功");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplatelist.csp?&PMTLTemplateDR="+getElementValue("PMTLTemplateDR")},50);
}
function BDelete_Clicked()
{
	if(getElementValue("PMTLRowID")==""){$.messager.alert('提示','请选中一条需要删除的记录！','warning');return;}
	messageShow("confirm","info","提示",t[-9203],"",DeleteData,"")
}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SavePMTemplateList",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","删除成功！");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplatelist.csp?&PMTLTemplateDR="+getElementValue("PMTLTemplateDR")},50);
}	
function BFind_Clicked()
{
	initDHCEQPMTemplateList()
}
function initDHCEQPMTemplateList()
{
	$HUI.datagrid("#tDHCEQPMTemplateList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTPMTemplate",
	        QueryName:"PMTemplateList",
	        TemplateDR:getElementValue("PMTLTemplateDR"),
			MaintItemDR:getElementValue("PMTLMaintItemDR")
	    },
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
    	columns:[[
    		{field:'PMTLRowID',title:'RowID',width:50,hidden:true},
			{field:'TName',title:'模板名称',align:'center',width:100},
			{field:'TCaption',title:'模板标题',align:'center',width:100,hidden:true},
			{field:'TType',title:'类型',align:'center',width:80},
			{field:'TItemCat',title:'项目大类',align:'center',width:100}, 
			{field:'TItemCode',title:'项目编码'},
			{field:'PMTLMaintItemDR',title:'PMTLMaintItemDR',width:50,hidden:true},
			{field:'PMTLMaintItemDR_MIDesc',title:'项目'},
			{field:'PMTLNote',title:'明细注释',align:'center',width:100},
			{field:'PMTLDefaultVal',title:'明细默认值',align:'center',width:100},
			{field:'PMTLSort',title:'排序',align:'center',width:100}, 
    	]],
		onClickRow:function(rowIndex,rowData){fillData(rowData);},

});
}
function fillData(rowData)
{
	if(selectedRowID!=rowData.PMTLRowID)
	{
		setElementByJson(rowData);
		selectedRowID=rowData.PMTLRowID;
		setElement("PMTLRowID",selectedRowID);
		UnderSelect();
	}
	else
	{
		ClearElement();
		$('#tDHCEQPMTemplateList').datagrid('unselectAll');
		selectedRowID="";
		setEnabled()
	}
	
}
function ClearElement()
{
	setElement("PMTLRowID","");
	setElement("PMTLMaintItemDR","");
	setElement("PMTLMaintItemDR_MIDesc","");
	setElement("PMTLNote","");
	setElement("PMTLDefaultVal","");
	setElement("PMTLSort","");
}
//选择框选择事件
function setSelectValue(elementID,rowData)
{
	if(elementID=="PMTLMaintItemDR_MIDesc") 
	{
		setElement("PMTLMaintItemDR",rowData.TRowID)
		setElement("PMTLMaintItemDR_MIDesc",rowData.TDesc)
	}
}

//hisui.common.js错误纠正需要
function clearData(str)
{
	setElement(str.split("_")[0],"")	//modified by csj 20190828
} 