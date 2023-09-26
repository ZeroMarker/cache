
var editFlag="undefined";
var SelectRowID="";
var Columns=getCurColumnsInfo('BA.G.BenefitEquipList.EquipListFind','','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage("ba"); //获取所有业务消息
    initLookUp();
	defindTitleStyle(); 
  	initButton();
    initButtonWidth();
	$HUI.datagrid("#DHCEQBenefitEquipListFind",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.BA.BUSBenefitEquipList",
	        	QueryName:"GetBenefitEquipList",
				vEquipDR:"",
				QXType:getElementValue("QXType"),
				CLOCID:session['LOGON.CTLOCID']
			},
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

