
var Columns=getCurColumnsInfo('BA.G.BenefitSummary.BenefitSummaryFind','','','')
jQuery(document).ready(function()
{
	initUserInfo();
    //initMessage(""); //获取所有业务消息
    //initLookUp(); //初始化放大镜
	//defindTitleStyle(); 
    //initButton(); //按钮初始化
    //initButtonWidth();
    //setEnabled(); //按钮控制
	$HUI.datagrid("#tDHCEQBenefitSummaryFind",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSBenefitSummary",
	        	QueryName:"GetBenefitSummary",
				pYear:getElementValue("Year"),
				pUserDR:"",
		},
    	border:'true',
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'新增',
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
	showWindow(url,"医疗设备使用评价报告","","","icon-w-paper","modal","","","small");
}