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
	initMessage(""); //��ȡ����ҵ����Ϣ  Modiedy by zc0056 20200204
	showBtnIcon('BFind',false); //modified by LMH 20230202 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	initSourceTypeData();
	defindTitleStyle();
	setRequiredElements("SourceType");
	initDHCEQRiskEvaluateSoucre();			//��ʼ�����

}
function initSourceTypeData()
{
	var SourceType = $HUI.combobox('#SourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '0',
				text: '�豸����'
			},{
				id: '1',
				text: '�豸����'
			},{
				id: '2',
				text: '�豸��'
			},{
				id: '3',
				text: '�豸'
			}]
});
}	
function BFind_Clicked()
{
	if (checkMustItemNull()) return;
	initDHCEQRiskEvaluateSoucre()
}
function initDHCEQRiskEvaluateSoucre()
{
	$HUI.datagrid("#tDHCEQRiskEvaluateSoucre",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.BUSEvaluate",
	        QueryName:"GetRiskEvaluateSoucre",
	        SourceType:getElementValue("SourceType"),
			Desc:getElementValue("Desc"),
	    },
	    singleSelect:true,
		//fitColumns:true,	//modified by LMH 20230202  ����ʱĬ���������
		//modified by LMH 20230202  ����ʱĬ����������޸��п��,�����ѯ��������ʾ��ȫ����
    	columns:[[
			{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
			{field:'TSourceType',title:'TSourceType',width:0,align:'center',hidden:true},
			{field:'TSourceTypeDesc',title:'��Դ����',width:80,align:'center'},
			{field:'TName',title:'����',width:120,align:'center'},
			{field:'TCode',title:'����',width:80,align:'center'},
			{field:'TOpt',title:'����',width:100,align:'center',formatter: detailOperation},
		]],
		pagination:true,
    	pageSize:15,
    	pageNumber:1,
    	pageList:[15,30,45,60,75]  
});
}
function detailOperation(value,row,index)
{
	var result=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate","GetRecentRiskEvaluate",row.TSourceType,row.TRowID);
    var str= "dhceq.em.riskevaluate.csp?&ReadOnly=0&SourceType="+row.TSourceType+"&SourceID="+row.TRowID+"&Name="+row.TName+"&RowID="+result ; 
	var width=""
	var height="19row"
	var icon="icon-paper"
	var title="ҽ���豸���յȼ�����"	
	var btn='<A onclick="showWindow(&quot;'+str+'&quot;,&quot;'+title+'&quot;,&quot;'+width+'&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#"><span class="icon-paper" style="display:inline-block;height:24px;width:24px;"></span></A>'  // modfied by yh 2020-02-17 1161616
	return btn;
}
