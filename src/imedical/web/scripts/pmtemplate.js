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
	initPMTTypeData()
	setRequiredElements("PMTType^PMTName^PMTCaption")
	setEnabled();		//按钮控制
	initDHCEQPMTemplate();			//初始化表格
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
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SaveData",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","新增成功！");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplate.csp"},50);
}
function BSave_Clicked()
{	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SaveData",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","更新成功");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplate.csp"},50);
}
function BDelete_Clicked()
{
	if(getElementValue("PMTRowID")==""){$.messager.alert('提示','请选中一条需要删除的记录！','warning');return;}
	messageShow("confirm","info","提示",t[-9203],"",DeleteData,"")
}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","删除成功！");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplate.csp"},50);
}	
function BFind_Clicked()
{
	initDHCEQPMTemplate()
}
function initDHCEQPMTemplate()
{
	$HUI.datagrid("#tDHCEQPMTemplate",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTPMTemplate",
	        QueryName:"PMTemplate",
	        Type:getElementValue("PMTType"),
			Name:getElementValue("PMTName"),
			Caption:getElementValue("PMTCaption"),
			Note:getElementValue("PMTNote"),
			FromDate:getElementValue("PMTFromDate"),
			ToDate:getElementValue("PMTToDate")
	    },
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
    	columns:[[
			{field:'TDetail',title:'详细',algin:'center',width:25,formatter:DetailOperation},
    		{field:'PMTRowID',title:'RowID',width:50,hidden:true},    
        	{field:'PMTType',title:'类型',align:'center',width:90,hidden:true},
        	{field:'PMTTypeDesc',title:'类型',align:'center',width:45},
        	{field:'PMTName',title:'模板',align:'center',width:180},    
        	{field:'PMTCaption',title:'标题',align:'center',width:180},     
        	{field:'PMTNote',title:'注释',align:'center',width:100},
        	{field:'PMTFromDate',title:'开始日期',align:'center',width:70},
        	{field:'PMTToDate',title:'结束日期',align:'center',width:70},    
        	{field:'PMTRemark',title:'备注',align:'center',width:100},   
        	{field:'TEquipRangeID',title:'TEquipRangeID',align:'center',width:75,hidden:true},   //Modefied  by zc0098 2021-1-29
			{field:'TPMRange',title:'模板范围',algin:'center',width:40,formatter:RangeOperation}   //Modefied  by zc0098 2021-1-29
    	]],
		onClickRow:function(rowIndex,rowData){fillData(rowData);},

});
}
function fillData(rowData)
{
	if(selectedRowID!=rowData.PMTRowID)
	{
		setElementByJson(rowData);
		selectedRowID=rowData.PMTRowID;
		setElement("PMTRowID",selectedRowID);
		UnderSelect();
	}
	else
	{
		ClearElement();
		$('#tDHCEQPMTemplate').datagrid('unselectAll');
		selectedRowID="";
		setEnabled()
	}
	
}
function ClearElement()
{
	setElement("PMTRowID","");
	setElement("PMTType","");
	setElement("PMTName","");
	setElement("PMTCaption","");
	setElement("PMTNote","");
	setElement("PMTRemark","");
	setElement("PMTFromDate","");
	setElement("PMTToDate","");
}
//处理行事件函数
function DetailOperation(value,rowData,rowIndex)
{
	var str='';
	str+='<a onclick="btnDetail('+rowData.PMTRowID+')" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></a>'
	//str='<a href="javascript:void(0);" onlick=btnDetail('+rowData.TRowID+')><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></a>'
	return str;
}
//modified by csj 2020-02-17 需求号：1191838
function btnDetail(id)
{
    var str="PMTLTemplateDR="+id  //modified by csj 2020-02-24 需求号：1191838 修正
   	//window.open('dhceq.code.dhceqcpmtemplatelist.csp?'+str, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=900,height=700,left=100,top=20');	
	//modify by lmm 2020-04-03	
	showWindow('dhceq.plat.pmtemplatelist.csp?'+str,'PM模板信息维护',"","","","modal","","","large")	//modified by csj 2020-02-28 需求号：1207883
}
//Modefied  by zc0098 2021-1-29
///描述：模板范围列内容
function RangeOperation(value,rowData,rowIndex)
{
	var str='';
	str+='<a onclick="btnRangeDetail(&quot;'+rowData.PMTRowID+"&quot;,&quot;"+rowData.TEquipRangeID+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></a>'

	return str;
}

//Modefied  by zc0098 2021-1-29
///描述：模板范围列弹窗
function btnRangeDetail(id,EquipRangeID)
{
	EquipRangeID=tkMakeServerCall("web.DHCEQ.Code.DHCEQCPMTemplate", "GetPMTemplateEquipRangeID",id);	// MZY0119	2574406		2022-04-07
    var str="&SourceType=3&SourceName=PMTemplate&SourceID="+id+"&EquipRangeDR="+EquipRangeID+"&vStatus=";  //页面跳转，传值变量设置
    showWindow('dhceq.plat.equiprange.csp?'+str,'PM模板范围限定',"","","","","","","",function (){location.reload();})	//modified by csj 2020-02-28 需求号：1207883		//czf 1776711 2021-03-03
}
