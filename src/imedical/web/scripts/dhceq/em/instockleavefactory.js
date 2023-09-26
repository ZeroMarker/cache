	
$(function(){
	initDocument();

});

function initDocument()
{
	//Modified BY ZY0198 调整参数的顺序
	$HUI.datagrid("#DHCEQLeavfactoryNum",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSInStock",
			QueryName:"GetLeaveFactoryNum",
			SourceType:getElementValue("SourceType"),
			SourceID:getElementValue("SourceID"),
		},
		columns:[[  
                  {field:'LeavefactoryNo',title:'出厂编号',width:150},
                ]],
	    fit:true,
		fitColumns:true,   //add by lmm 2020-06-02
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
		pagination:true,
		pageSize:20,
		pageList:[10,20,30,40,50]
	});
}