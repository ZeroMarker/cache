$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	defindTitleStyle();
	initButton(); //按钮初始化
    //initButtonWidth();
	initBussType();
	setRequiredElements("BussType^BussNo");
	jQuery("#BModify").on("click", BModify_Clicked);
	jQuery("#BOCModify").on("click", BModify_Clicked);
	///modified by ZY0252  20210301
	jQuery("#BCONModify").on("click", BModify_Clicked);
}
///modified by ZY0252  20210301
function initBussType()
{
	$HUI.combobox('#BussType',{
		valueField:'busscode',
		textField:'text',
		panelHeight:"auto",
		data:[{
			busscode: '21',
			text: '入库'
		},{
			busscode: '11',
			text: '验收'
		},{
			busscode: '94',
			text: '合同'
		}]
	});
}
function BFind_Clicked()
{
	var bussType=getElementValue("BussType");
	var bussNo=getElementValue("BussNo");
	if (bussType=="")
	{
		messageShow('alert','error','提示',"业务类型不能为空!")
		return
	}
	if (bussNo=="")
	{
		messageShow('alert','error','提示',"业务单号不能为空!")
		return
	}
	$('#BusinessContent').layout('remove','north');
	switch (bussType) {
        case "21":
        	$('#BusinessMain').hide();
        	$("#InStockInfo").show();
        	$("#OpenCheckInfo").hide();
        	$("#ContractInfo").hide();	///modified by ZY0252  20210301
        	loadData(bussType,bussNo);
        	loadInStockListData(bussNo);
        	break;
        case "11":
        	$('#BusinessMain').hide();
        	$("#InStockInfo").hide();
        	$("#OpenCheckInfo").show();
        	$("#ContractInfo").hide();	///modified by ZY0252  20210301
        	loadData(bussType,bussNo);
        	break;
        case "94":
        	$('#BusinessMain').hide();
        	$("#InStockInfo").hide();
        	$("#OpenCheckInfo").hide();
        	$("#ContractInfo").show();
        	loadData(bussType,bussNo);
        	loadContractListData(bussNo);
        	break;
        default:break;
	}
}

function loadData(bussType,bussNo)
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","GetBusinessMain",bussType,bussNo)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE==-9012) {messageShow('','','',"单号不存在!",'',function(){reloadPage();});} // Modify by zx 2020-03-31BUG ZX0082
	else if(jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	if (bussType=="11")
	{
		var OpenCheckListObj=jsonData.Data.OpenCheckList
		setElementByJson(OpenCheckListObj);
	}
	var DCRRowID=getElementValue("DCRRowID")		//modified by czf 2020-08-18 begin
	var DCRStatus=getElementValue("DCRStatus")
	if (DCRRowID!="")
	{
		if (DCRStatus==0) 
		{
			if (bussType=="21") jQuery("#BModify").linkbutton({text:'待提交'});
			else if (bussType=="11") jQuery("#BOCModify").linkbutton({text:'待提交'});
			else if (bussType=="94") jQuery("#BCONModify").linkbutton({text:'待提交'});	///modified by ZY0252  20210301
		}
		else if (DCRStatus==1)
		{
			if (bussType=="21") jQuery("#BModify").linkbutton({text:'待确认'});
			else if (bussType=="11") jQuery("#BOCModify").linkbutton({text:'待确认'});
			else if (bussType=="94") jQuery("#BCONModify").linkbutton({text:'待确认'});	///modified by ZY0252  20210301
		}
	}
	else
	{
		if (bussType=="21") jQuery("#BModify").linkbutton({text:'修改申请'});	//modified by czf 2020-08-18 end
		else if (bussType=="11") jQuery("#BOCModify").linkbutton({text:'修改申请'});
		else if (bussType=="94") jQuery("#BCONModify").linkbutton({text:'修改申请'});	///modified by ZY0252  20210301
	}
}

function loadInStockListData(bussNo)
{
	$HUI.datagrid("#DHCEQBusinessList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBBusinessModify",
			QueryName:"GetInStockList",
			InStockNo:bussNo
		},
		fit:true,		//1994847 czf 2021-07-07
		fitColumns:true,
		border:false,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    columns:[[
	    	{field:'TRowID',title:'TRowID',hidden:true},
			{field:'TOpt',title:'操作',width:80,align:'center',formatter:function(value,rec){
					var btn = '<a href="#" class="hisui-linkbutton hover-dark" onclick="javascript:editBusinessList(\''+rec.TRowID+'\',\''+rec.TDCRRowID+'\');" >';		//modified by czf 2020-08-18 begin
                	if (rec.TDCRRowID!="")
                	{
                		if (rec.TDCRStatus=="0") btn=btn+'待提交</a>';
                		else if (rec.TDCRStatus=="1") btn=btn+'待确认</a>';
	                }
                	else btn=btn+'修改申请</a>';
                	return btn;  
           		}		//modified by czf 2020-08-18 end
			} ,
	    	{field:'TEquipName',title:'设备名称',width:180,align:'center'},
	    	{field:'TModel',title:'规格型号',width:160,align:'center'},
			{field:'TQuantityNum',title:'数量',width:100,align:'center'},
			{field:'TUnit',title:'单位',width:100,align:'center'},
			{field:'TOriginalFee',title:'原值',tooltip:'a tooltip',width:100,align:'center'},
			{field:'TTotal',title:'总金额',width:100,align:'center'},
			{field:'TManuFactory',title:'生产厂家',width:160,align:'center'},
			{field:'TStatCat',title:'设备类型',width:120,align:'center'},
			{field:'TEquipCat',title:'设备分类',width:120,align:'center'},
			{field:'TInvoiceNos',title:'发票号',width:120,align:'center'},
			{field:'THold5',title:'经费来源',width:120,align:'center'},
			{field:'TLimitYearsNum',title:'使用年限',width:100,align:'center'},
			{field:'TRemark',title:'备注',width:100,align:'center'},
			{field:'TDCRRowID',title:'TDCRRowID',hidden:true},		//modified by czf 2020-08-18 begin
			{field:'TDCRStatus',title:'TDCRStatus',hidden:true},	       
	    ]],
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,50]
	});
}

function editBusinessList(BussID,DCRRowID)
{
	var bussType=getElementValue("BussType");
	var url="dhceq.plat.businessmodifylist.csp?BussType="+bussType+"&BussID="+BussID+"&DCRRowID="+DCRRowID+"&WaitAD="+getElementValue("WaitAD")+"&Type="+getElementValue("Type");
	showWindow(url,"业务明细修改","","13row","icon-w-paper","modal","","","middle"); 
}

/// add by zx 2019-08-30
/// 保存按钮回调事件
function setValueByEdit(id,value)
{
	//alertShow(value)
	//setElement("id",value);
	BFind_Clicked();
}

/// add by zx 2020-03-31 BUG ZX0082
/// 描述: 界面刷新处理
function reloadPage()
{
	url="dhceq.plat.businessmodify.csp?"
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
    window.location.href= url;
}

function BModify_Clicked()
{
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var DCRRowID=getElementValue("DCRRowID");
	if (bussType=="21")
	{
		var url="dhceq.plat.busmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID+"&WaitAD="+getElementValue("WaitAD")+"&Type="+getElementValue("Type");
		showWindow(url,"入库单修改","","12row","icon-w-paper","modal","","","small"); 
	}
	else if (bussType=="11")
	{
		var url="dhceq.plat.opencheckmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID+"&WaitAD="+getElementValue("WaitAD")+"&Type="+getElementValue("Type");
		showWindow(url,"验收单修改","","","icon-w-paper","modal","","","large"); 
	}
	///modified by ZY0252  20210301
	else if (bussType=="94")
	{
		var url="dhceq.plat.modifycontract.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID+"&WaitAD="+getElementValue("WaitAD")+"&Type="+getElementValue("Type");
		showWindow(url,"合同单修改","","","icon-w-paper","modal","","","large"); 
	}
}
///modified by ZY0252  20210301
function loadContractListData(bussNo)
{
	$HUI.datagrid("#DHCEQContractBusinessList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBBusinessModify",
			QueryName:"GetContractList",
			ContractNo:bussNo
		},
		fit:true,		//1994847 czf 2021-07-07
		border:false,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    columns:[[
	    	{field:'TRowID',title:'TRowID',hidden:true},
			{field:'TOpt',title:'操作',width:80,align:'center',formatter:function(value,rec){
					var btn = '<a href="#" class="hisui-linkbutton hover-dark" onclick="javascript:editContractList(\''+rec.TRowID+'\',\''+rec.TDCRRowID+'\');" >';		//modified by czf 2020-08-18 begin
                	if (rec.TDCRRowID!="")
                	{
                		if (rec.TDCRStatus=="0") btn=btn+'待提交</a>';
                		else if (rec.TDCRStatus=="1") btn=btn+'待确认</a>';
	                }
                	else btn=btn+'修改申请</a>';
                	return btn;  
           		}		//modified by czf 2020-08-18 end
			} ,
	    	{field:'TEquipName',title:'设备名称',width:180,align:'center'},
	    	{field:'TModel',title:'规格型号',width:160,align:'center'},
			{field:'TQuantityNum',title:'数量',width:100,align:'center'},
			{field:'TOriginalFee',title:'原值',tooltip:'a tooltip',width:100,align:'center'},
			{field:'TTotal',title:'总金额',width:100,align:'center'},
			{field:'TContractArriveDate',title:'合同到货日期',width:160,align:'center'},
			{field:'TArriveQuantityNum',title:'到货数量',width:120,align:'center'},
			{field:'TRemark',title:'备注',width:100,align:'center'},
			{field:'TDCRRowID',title:'TDCRRowID',hidden:true},
			{field:'TDCRStatus',title:'TDCRStatus',hidden:true},	       
	    ]],
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12]
	});
}
///modified by ZY0252  20210301
function editContractList(BussID,DCRRowID)
{
	var bussType=getElementValue("BussType");
	var url="dhceq.plat.modifycontractlist.csp?BussType="+bussType+"&BussID="+BussID+"&DCRRowID="+DCRRowID+"&WaitAD="+getElementValue("WaitAD")+"&Type="+getElementValue("Type");
	showWindow(url,"业务明细修改","","13row","icon-w-paper","modal","","","middle"); 
}