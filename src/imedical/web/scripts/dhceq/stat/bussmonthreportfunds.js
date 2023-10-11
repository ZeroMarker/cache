$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initLookUp(); 				//初始化放大镜
	initBussType();
	initEquipType();
	initLocGroupType();
	initButton();
	initButtonWidth();
    MonthBox('pMonthStr');
	//var arr=getElementValue("EquipTypeIDs").split(",");
	//$('#EquipType').combogrid('setValues', arr);
}
function initBussType()
{
	$HUI.combogrid('#pBussType',{
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Stat.DHCEQMonthReport",
	        QueryName:"BussTypeList"
	    },
	    idField:'TRowID',
		textField:'TDesc',
	    multiple: true,
	    rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TDesc',title:'全选',width:400},
	        {field:'TCode',title:'代码',width:150},
	    ]]
	});
}
function initEquipType()
{
	$HUI.combogrid('#pEquipType',{
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'全选',width:150},
	        //{field:'TCode',title:'代码',width:150},
	    ]]/*,
	    onSelect:function(e){
		    alert("onSelect:")
			//setElement("IEquipTypeIDs",$(this).combogrid("getValues"));
		}/*,
		onClickRow:function(index, row){
			alert("onClickRow")
			//setElement("IEquipTypeIDs",$(this).combogrid("getValues"));
		}*/
	});
}
function initLocGroupType()
{
	$HUI.combogrid('#pLocGT',{
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTLocType",
	        QueryName:"GetLocType",
	        GroupCode:"02"
	    },
	    idField:'TID',
		textField:'TLocType',
	    multiple: true,
	    rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TLocType',title:'全选',width:150},
	        //{field:'TCode',title:'代码',width:150},
	    ]]
	});
}
function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	if(elementID=="pUseLoc") {setElement("pUseLocDR",rowData.TRowID)}
	//else if(elementID=="pEquipType") {setElement("pEquipTypeDR",rowData.TRowID)}
	else if(elementID=="pFundsType") {setElement("pFundsTypeDR",rowData.TRowID)}
	else if(elementID=="pHospital") {setElement("pHospitalDR",rowData.TRowID)}
}
function BFind_Clicked()
{
	var ColTColor=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","902001");
	var DataColor=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","902002");
	var SumColor=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","902003");
	var Colorstr="&ColTColor="+ColTColor+"&DataColor="+DataColor+"&SumColor="+SumColor;
	var ReportFileName=jQuery("#ReportFileName").val();
	var PrintFlag=getElementValue("PrintFlag");
	var PrintStr=""
	//setElement("EquipTypeIDs",$("#pEquipType").combogrid("getValues"));
	var lnk="&MonthStr="+getElementValue("pMonthStr");
	lnk=lnk+"&BussTypeIDs="+$("#pBussType").combogrid("getValues");
	lnk=lnk+"&LocDR="+getElementValue("pUseLocDR");
	lnk=lnk+"&LocGT="+$("#pLocGT").combogrid("getValues");		// MZY0096	2102394,2102406,2102494		2021-09-16
	lnk=lnk+"&EquipTypeIDs="+$("#pEquipType").combogrid("getValues");
	lnk=lnk+"&FundsTypeDR="+getElementValue("pFundsTypeDR");
	lnk=lnk+"&HospID="+getElementValue("pHospitalDR");
	lnk=lnk+"&QXType="+getElementValue("QXType");
	lnk=lnk+"&AccountShape="+getElementValue("AccountShape");
	
	if (PrintFlag==2) PrintStr="&PrintFlag=1";
	
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+PrintStr+Colorstr;
}
