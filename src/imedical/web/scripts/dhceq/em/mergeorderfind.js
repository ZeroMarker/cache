var SelectedRowID = 0;
var PreSelectedRowID = 0;
var editFlag="undefined";
var MergeOrdercolumns=getCurColumnsInfo('PLAT.G.MergeOrder.OrderDetail','','',''); 
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument(){
	
	defindTitleStyle(); 
	initLookUp();
	initButton();
	
	

	$HUI.datagrid("#mergeorderfinddatagrid",{   
    url:$URL, 
	idField:'TRowID', //主键   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    singleSelect:true,
	fitColumns:true,
	pagination:true,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSMergeOrder",
        QueryName:"GetMergeOrder",
        RequestNo:getElementValue("RequestNo"),
        MergeOrderNo:getElementValue("MergeOrderNo"),
        Equip:getElementValue("Equip"),
        UseLoc:getElementValue("UseLoc"),
        StartDate:getElementValue("StartDate"),
        EndDate:getElementValue("EndDate"),
        SourceType:getElementValue("SourceType"),
    },
	fitColumns:true,   //modify by lmm 2020-06-02
	columns:MergeOrdercolumns, 
	});

	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);

		
	
}	

function BAdd_Clicked()
{
	var url="dhceq.em.mergeorder.csp?&RowID=&SourceType="+getElementValue("SourceType")+"&SubType="+getElementValue("SubType")
	showWindow(url,"汇总申请","","","icon-w-paper","modal","","","large");  //modify by lmm 2020-06-05
}

//add by lmm 2017-08-22
//报废单查询
function BFind_Clicked()
{
	$HUI.datagrid("#mergeorderfinddatagrid",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSMergeOrder",
        QueryName:"GetMergeOrder",
        RequestNo:getElementValue("RequestNo"),
        MergeOrderNo:getElementValue("MergeOrderNo"),
        Equip:getElementValue("Equip"),
        UseLoc:getElementValue("UseLoc"),
        StartDate:getElementValue("StartDate"),
        EndDate:getElementValue("EndDate"),
        SourceType:getElementValue("SourceType"),
	    },
	});

}



function setSelectValue(vElementID,rowData)
{
	setElement(vElementID+"DR",rowData.TRowID)  
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}