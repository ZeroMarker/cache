$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initLookUp(); 				//初始化放大镜
	initEquipType();
	initFundsType();
	initButton();
	initButtonWidth();
    MonthBox('pMonthStr');
	//var arr=getElementValue("EquipTypeIDs").split(",");
	//$('#EquipType').combogrid('setValues', arr);
}

function initEquipType()
{
	$HUI.combogrid('#pEquipTypes',{
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
function initFundsType()
{
	$HUI.combogrid('#pFundsTypes',{
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Process.DHCEQFind",
	        QueryName:"FundsType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'全选',width:150},
	        //{field:'TCode',title:'代码',width:150},
	    ]]
	});
}
function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	if(elementID=="pUseLoc") {setElement("pUseLocDR",rowData.TRowID)}
	else if(elementID=="pEquipType") {setElement("pEquipTypeDR",rowData.TRowID)}
	else if(elementID=="pFundsType") {setElement("pFundsTypeDR",rowData.TRowID)}
	else if(elementID=="pHospital") {setElement("pHospitalDR",rowData.TRowID)}
	else if(elementID=="pLocGroupType") {setElement("pLocGroupTypeDR",rowData.TRowID)}
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
	var lnk=""
	lnk=lnk+"&pMonthStr="+getElementValue("pMonthStr");
	lnk=lnk+"&pUseLocDR="+getElementValue("pUseLocDR");
	lnk=lnk+"&pEquipNo="+getElementValue("pEquipNo");
	lnk=lnk+"&pEquipTypeDR="+getElementValue("pEquipTypeDR");
	lnk=lnk+"&pFundsTypeDR="+getElementValue("pFundsTypeDR");
	lnk=lnk+"&pHospitalDR="+getElementValue("pHospitalDR");
	lnk=lnk+"&pLocGroupTypeDR="+getElementValue("pLocGroupTypeDR");
	lnk=lnk+"&pEquipTypeIDs="+$("#pEquipTypes").combogrid("getValues").toString();
	lnk=lnk+"&pFundsTypeIDs="+$("#pFundsTypes").combogrid("getValues").toString();
	if (PrintFlag==2) PrintStr="&PrintFlag=1";
	
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+PrintStr+Colorstr;
}

/*function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&pMonthStr="+GetJQueryDate('#pMonthStr');
	lnk=lnk+"&pUseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&pEquipNo="+GlobalObj.EquipDR;
	lnk=lnk+"&pEquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&pFundsTypeDR="+GlobalObj.FundsTypeDR;
	lnk=lnk+"&pHosptailDR="+GlobalObj.HospitalDR;
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}*/
