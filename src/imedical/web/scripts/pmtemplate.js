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
	initPMTTypeData()
	setRequiredElements("PMTType^PMTName^PMTCaption")
	setEnabled();		//��ť����
	initDHCEQPMTemplate();			//��ʼ�����
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
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SaveData",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�����ɹ���");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplate.csp"},50);
}
function BSave_Clicked()
{	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SaveData",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","���³ɹ�");
	window.setTimeout(function(){window.location.href= "dhceq.plat.pmtemplate.csp"},50);
}
function BDelete_Clicked()
{
	if(getElementValue("PMTRowID")==""){$.messager.alert('��ʾ','��ѡ��һ����Ҫɾ���ļ�¼��','warning');return;}
	messageShow("confirm","info","��ʾ",t[-9203],"",DeleteData,"")
}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTPMTemplate","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","ɾ���ɹ���");
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
			{field:'TDetail',title:'��ϸ',algin:'center',width:25,formatter:DetailOperation},
    		{field:'PMTRowID',title:'RowID',width:50,hidden:true},    
        	{field:'PMTType',title:'����',align:'center',width:90,hidden:true},
        	{field:'PMTTypeDesc',title:'����',align:'center',width:45},
        	{field:'PMTName',title:'ģ��',align:'center',width:180},    
        	{field:'PMTCaption',title:'����',align:'center',width:180},     
        	{field:'PMTNote',title:'ע��',align:'center',width:100},
        	{field:'PMTFromDate',title:'��ʼ����',align:'center',width:70},
        	{field:'PMTToDate',title:'��������',align:'center',width:70},    
        	{field:'PMTRemark',title:'��ע',align:'center',width:100},   
        	{field:'TEquipRangeID',title:'TEquipRangeID',align:'center',width:75,hidden:true},   //Modefied  by zc0098 2021-1-29
			{field:'TPMRange',title:'ģ�巶Χ',algin:'center',width:40,formatter:RangeOperation}   //Modefied  by zc0098 2021-1-29
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
//�������¼�����
function DetailOperation(value,rowData,rowIndex)
{
	var str='';
	str+='<a onclick="btnDetail('+rowData.PMTRowID+')" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></a>'
	//str='<a href="javascript:void(0);" onlick=btnDetail('+rowData.TRowID+')><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></a>'
	return str;
}
//modified by csj 2020-02-17 ����ţ�1191838
function btnDetail(id)
{
    var str="PMTLTemplateDR="+id  //modified by csj 2020-02-24 ����ţ�1191838 ����
   	//window.open('dhceq.code.dhceqcpmtemplatelist.csp?'+str, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=900,height=700,left=100,top=20');	
	//modify by lmm 2020-04-03	
	showWindow('dhceq.plat.pmtemplatelist.csp?'+str,'PMģ����Ϣά��',"","","","modal","","","large")	//modified by csj 2020-02-28 ����ţ�1207883
}
//Modefied  by zc0098 2021-1-29
///������ģ�巶Χ������
function RangeOperation(value,rowData,rowIndex)
{
	var str='';
	str+='<a onclick="btnRangeDetail(&quot;'+rowData.PMTRowID+"&quot;,&quot;"+rowData.TEquipRangeID+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></a>'

	return str;
}

//Modefied  by zc0098 2021-1-29
///������ģ�巶Χ�е���
function btnRangeDetail(id,EquipRangeID)
{
	EquipRangeID=tkMakeServerCall("web.DHCEQ.Code.DHCEQCPMTemplate", "GetPMTemplateEquipRangeID",id);	// MZY0119	2574406		2022-04-07
    var str="&SourceType=3&SourceName=PMTemplate&SourceID="+id+"&EquipRangeDR="+EquipRangeID+"&vStatus=";  //ҳ����ת����ֵ��������
    showWindow('dhceq.plat.equiprange.csp?'+str,'PMģ�巶Χ�޶�',"","","","","","","",function (){location.reload();})	//modified by csj 2020-02-28 ����ţ�1207883		//czf 1776711 2021-03-03
}
