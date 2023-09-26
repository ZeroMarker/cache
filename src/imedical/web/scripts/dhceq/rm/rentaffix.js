var Columns=getCurColumnsInfo('RM.G.Rent.Affix','','','');
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	$HUI.datagrid("#tDHCEQRentAffix",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSStoreMove",
			QueryName:"GetStoreMoveList",
			StoreMoveID:getElementValue("SMRowID")
		},
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
	    columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
		onLoadSuccess:function(){}
	});
}

function onClickRow(index)
{
	
}