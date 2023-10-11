var editFlag="undefined";
var Columns=getCurColumnsInfo('BA.G.BenefitSummary.BenefitItemInfo','','','')
jQuery(document).ready(function()
{
	initUserInfo();
    initMessage("BA"); //��ȡ����ҵ����Ϣ
	//initLookUp();
	//defindTitleStyle();
	//fillData(); //�������
	//showFieldsTip();
    //setEnabled(); //��ť����
    initApproveButtonNew(); //��ʼ��������ť
    initButton();
	initButtonWidth();	
	$HUI.datagrid("#tDHCEQBenefititeminfo",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSBenefitSummary",
	        	QueryName:"GetBenefitItemInfo",
				UseContextDR:getElementValue("UCRowID")
		},
    	border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		columns:Columns,
	    onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    	if (editFlag!="undefined")
	    	{
                $('#tDHCEQBenefititeminfo').datagrid('endEdit', editFlag);
                editFlag="undefined"
            }
            else
            {
	            $('#tDHCEQBenefititeminfo').datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
	        }
        },
		toolbar:[
			{
				id:"save",
				iconCls:'icon-save',
				text:'����',
				handler:function(){SaveGridData();}
			}
			
		],
		pagination:true,
		pageSize:18,
		pageNumber:18,
		pageList:[18,36,54,72,90]
	});
	setEnabled()
	}
)
function SaveGridData()
{
	var dataList=""
	var rows = $('#tDHCEQBenefititeminfo').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.BIIScore=="")
		{
			alertShow("��"+(i+1)+"�з���Ϊ��!")
			return "-1"
		}
		if ((oneRow.BIIScore>oneRow.BIMaxScore)||(oneRow.BIIScore<oneRow.BIMinScore))
		{
			alertShow("��"+(i+1)+"�з������ڹ涨��Χ��!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
		}
	}
	if (dataList=="")
	{
		alertShow("������ϸ����Ϊ��!");
		return;
	}
	var UCRowID=getElementValue("UCRowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","SaveBenefitItemInfo",dataList,UCRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&UCRowID="+jsonData.Data
		url="dhceq.ba.benefititeminfo.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
		parent.opener.location.reload= 'dhceq.ba.benefitsummary.csp?RowID='+getElementValue("BenefitSummaryDR");
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
function setEnabled()
{
	var Status=getElementValue("Status")
	if (Status>0)
	{
		disableElement("save",true)
	}
}