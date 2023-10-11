var columns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','N');  ///add by lmm 2018-11-08 742946
var frozencolumns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','Y');  ///add by lmm 2018-11-08 742946
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle();
	///modify by lmm 2018-11-08 742946 修改datagrid方法调用 
		$HUI.datagrid("#maintlimitequipdatagrid",{   
	    url:$URL, 
		idField:'TRowID', //主键   //add by lmm 2018-10-23  767099
	    border : false,
		//striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
		queryParams:{
		        ClassName:"web.DHCEQ.EM.BUSEquip",
		        QueryName:"GetEquipList",
		        //modify by lmm 2019-08-05 932337
		        //midofy by lmm 2020-03-17 1226721
		        Data:"^FacilityFlag=2^ClassFlag=N^IsOut=N^IsDisused=N^FilterFlag=Y^UseLocDRStr="+getElementValue("LocStr")+"^EquipTypeDRStr="+getElementValue("EquipTypeStr")+"^EquipDRStr="+getElementValue("EquipStr")+"^StatCatDRStr="+getElementValue("StatCatStr")+"^MastitemDRStr="+getElementValue("MastitemStr")+"^ComputerFlag="+getElementValue("ComputerFlag"),   //modify by lmm 2019-05-30 919160
		        ReadOnly:'',
		        Ejob:getElementValue("Job"),  //add by lmm 2020-01-16 1174455
		 },
		//fitColumns:true,
		pagination:true,
    	columns:columns,
    	frozenColumns:frozencolumns,
    	
	});

	$('#maintlimitequipdatagrid').datagrid('hideColumn','TUnit');
	//add by lmm 2020-06-05 UI
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TStoreLoc');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TProviderHandler');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TProviderTel');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TQuantity');

	$('#maintlimitequipdatagrid').datagrid('hideColumn','TOriginalFee');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TManuFactory');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TProvider');
	//$('#maintlimitequipdatagrid').datagrid('hideColumn','TFileNo');   //modify by lmm 2020-06-05 UI
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TDisplayStatus');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TStoreLoc');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TProviderHandler');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TProviderTel');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TManuFactoryNo');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TManuFactoryDate');
	//$('#maintlimitequipdatagrid').datagrid('hideColumn','TCommonName');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TDepreMethod');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TLimitYearsNum');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TNetRemainFee');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TDepreTotalFee');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TBuyType');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TPurposeType');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TPurchaseType');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TTransAssetDate');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TStartDate');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TOrigin');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TCheckDate');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TCountry');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TCk');
			
}

