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
	initButtonWidth();  // add by jyp 2023-02-06
	

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
        QXType:getElementValue("QXType"), //Add By QW20201223 BUG: QW0085 增加入参  begin
        Type:getElementValue("Type"),
        WaitAD:getElementValue("WaitAD"),
        StatusDR:getElementValue("StatusDR"), //Add By QW20201223 BUG: QW0085 增加入参 end 
         Ejob:getElementValue("Job")  //Add By QW20210429 BUG:QW0102 增加入参
    },
	fitColumns:true,   //modify by lmm 2020-06-02
	columns:MergeOrdercolumns, 
	toolbar:[{}],   //Add By QW20210429 BUG: QW0102 增加工具栏合计  begin
	onLoadSuccess:function(data){
		InitToolbarForAmountInfo();
	}
	});
	//Add By QW20201223 BUG: QW0085 报废汇总批量审核 隐藏按钮  begin
	var KindFlag=getElementValue("KindFlag"); 
	if (KindFlag=="1")
	{
		hiddenObj("BAdd",true);
	}
	//Add By QW20201223 BUG: QW0085 报废汇总批量审核 end

		
	
}	

// Add By QW20210429 BUG:QW0102 菜单栏中显示合计信息
function InitToolbarForAmountInfo() {
	var Data = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder","GetEquipSumInfo",getElementValue("Job"));  
	$("#sumTotal").html(Data);	
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
        QXType:getElementValue("QXType"), //Add By QW20201223 BUG: QW0085 增加入参  begin
        Type:getElementValue("Type"),
        WaitAD:getElementValue("WaitAD"),
        StatusDR:getElementValue("StatusDR"), //Add By QW20201223 BUG: QW0085 增加入参 end 
        Ejob:getElementValue("Job")  //Add By QW20210429 BUG:QW0102 增加入参
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
