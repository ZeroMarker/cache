
jQuery(document).ready(function()
{
	initUserInfo();
    initMessage("InStock"); //获取所有业务消息
	defindTitleStyle(); 
   	//setEnabled(); //按钮控制
	$HUI.datagrid("#DHCEQContractListEquip",{
		url:$URL,
		queryParams:{
	    	ClassName:"web.DHCEQContractNew",
	       	QueryName:"ContractListEquip",
			SourceType:getElementValue("SourceType"),
			SourceID:getElementValue("SourceID"),
		},
		border:false,
		fit:true,
		striped : true,
	   	cache: false,
		columns:getCurColumnsInfo('CON.G.Contract.EquipList','','',''),
		singleSelect:false,
		pagination:false,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
})