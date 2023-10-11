
//var Columns=getCurColumnsInfo('BA.G.BenefitSummary.BenefitSummaryFind','','','')
jQuery(document).ready(function()
{
	initUserInfo();
    //initMessage(""); //��ȡ����ҵ����Ϣ
    //initLookUp(); //��ʼ���Ŵ�
	//defindTitleStyle(); 
    //initButton(); //��ť��ʼ��
    //initButtonWidth();
    //setEnabled(); //��ť����
	$HUI.datagrid("#tDHCEQGatherDataList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSUseRecord",
	        	QueryName:"GatherDataList",
				SourceType:getElementValue("SourceType"),
				SourceID:getElementValue("SourceID"),
				InitYear:getElementValue("InitYear"),
		},
    	border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		columns:[[
			{field:'TMonthStr',title:'�·�',width:150,align:'center'},
			{field:'TFlag',title:'�Ѳɱ��',width:80,align:'center'},
			{field:'Opt',title:'�ɼ�����',width:100,align:'center',formatter:detailOperation},
		]],
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48,60]
	});
	}
)

function detailOperation(value,row,index)
{
	var TMonthStr=row.TMonthStr;
	TMonthStr=TMonthStr.replace("-","");
	var TFlag=row.TFlag;
	var btn=""
	if (TFlag=="N") btn='<a href="#" class="hisui-linkbutton hover-dark" onclick="javascript:gatherData('+TMonthStr+')">'+'�ɼ�'+'</a>';
	return btn;
}

function gatherData(MonthStr)
{
	MonthStr=MonthStr.toString()
	MonthStr=MonthStr.slice(0, 4) + "-" + MonthStr.slice(4)
	var SourceType=getElementValue("SourceType")
	var SourceID=getElementValue("SourceID")
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUseRecord","GatherData",SourceType,SourceID,MonthStr)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	if (jsonData.SQLCODE==0)
	{
		var InitYear=getElementValue("InitYear");
		var SourceType=getElementValue("SourceType");
		var SourceID=getElementValue("SourceID");
		var val="&InitYear="+InitYear+"&SourceType="+SourceType+"&SourceID="+SourceID;
		var url="dhceq.ba.gatherdata.csp?"+val;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}