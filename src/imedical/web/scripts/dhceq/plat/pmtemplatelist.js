var selectedRowID = "";	//ȡ��ǰѡ�е�����豸��¼ID
var t=[]             //add hly 20190724
t[-3003]="�����ظ�"  //add hly 20190724
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
//��ʼ����ѯͷ���
function initTopPanel()
{
	initButtonWidth();
	initButton(); //��ť��ʼ��
	jQuery('#BAdd').on("click", BAdd_Clicked);
	defindTitleStyle();
	initMessage("");  
	initLookUp(); //��ʼ���Ŵ�
	initPMTTypeData()
	setRequiredElements("PMTLMaintItemDR_MIDesc^PMTLSort")
	setEnabled();		//��ť����
	initDHCEQPMTemplateList();			//��ʼ�����
}
///��ʼ����ť״̬
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
///ѡ���а�ť״̬
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
				text: '����'
			},{
				id: '2',
				text: '���'
			},{
				id: '3',
				text: 'ά��'
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
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�����ɹ���");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplatelist.csp?&PMTLTemplateDR="+getElementValue("PMTLTemplateDR")},50);
}
function BSave_Clicked()
{	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SavePMTemplateList",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","���³ɹ�");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplatelist.csp?&PMTLTemplateDR="+getElementValue("PMTLTemplateDR")},50);
}
function BDelete_Clicked()
{
	if(getElementValue("PMTLRowID")==""){$.messager.alert('��ʾ','��ѡ��һ����Ҫɾ���ļ�¼��','warning');return;}
	messageShow("confirm","info","��ʾ",t[-9203],"",DeleteData,"")
}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SavePMTemplateList",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","ɾ���ɹ���");
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
			{field:'TName',title:'ģ������',align:'center',width:100},
			{field:'TCaption',title:'ģ�����',align:'center',width:100,hidden:true},
			{field:'TType',title:'����',align:'center',width:80},
			{field:'TItemCat',title:'��Ŀ����',align:'center',width:100}, 
			{field:'TItemCode',title:'��Ŀ����'},
			{field:'PMTLMaintItemDR',title:'PMTLMaintItemDR',width:50,hidden:true},
			{field:'PMTLMaintItemDR_MIDesc',title:'��Ŀ'},
			{field:'PMTLNote',title:'��ϸע��',align:'center',width:100},
			{field:'PMTLDefaultVal',title:'��ϸĬ��ֵ',align:'center',width:100},
			{field:'PMTLSort',title:'����',align:'center',width:100}, 
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
//ѡ���ѡ���¼�
function setSelectValue(elementID,rowData)
{
	if(elementID=="PMTLMaintItemDR_MIDesc") 
	{
		setElement("PMTLMaintItemDR",rowData.TRowID)
		setElement("PMTLMaintItemDR_MIDesc",rowData.TDesc)
	}
}

//hisui.common.js���������Ҫ
function clearData(str)
{
	setElement(str.split("_")[0],"")	//modified by csj 20190828
} 