
jQuery(document).ready(function()
{
	initUserInfo();
    initMessage("InStock"); //��ȡ����ҵ����Ϣ
	defindTitleStyle(); 
   	//setEnabled(); //��ť����
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