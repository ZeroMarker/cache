
var Columns=getCurColumnsInfo('BA.G.BenefitSummary.BenefitSummaryFind','','','')
jQuery(document).ready(function()
{
	initUserInfo();
    //initMessage(""); //��ȡ����ҵ����Ϣ
    //initLookUp(); //��ʼ���Ŵ�
	//defindTitleStyle(); 
    //initButton(); //��ť��ʼ��
    //initButtonWidth();
    //setEnabled(); //��ť����
	$HUI.datagrid("#tDHCEQBenefitSummaryFind",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSBenefitSummary",
	        	QueryName:"GetBenefitSummary",
				pYear:getElementValue("Year"),
				pUserDR:"",
		},
    	border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddGridData();}
			}
		],
		columns:Columns,
		pagination:true,
		pageSize:15,
		pageNumber:15,
		pageList:[15,30,45,60,75]
	});
	}
)

function AddGridData()
{
	var url='dhceq.ba.benefitsummary.csp?';
	showWindow(url,"ҽ���豸ʹ�����۱���","","","icon-w-paper","modal","","","small");
}