var Columns=getCurColumnsInfo('EM.G.BuyRequest.BuyRequestDetail','','','');

jQuery(function()
{
	setElement("StartDate",GetCurrentDate())
	
	initLookUp(); 				//初始化放大镜
	//modified by zy 20191025 ZY0194
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"ManageLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("ManageLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
   	defindTitleStyle();
    initButton(); 				//按钮初始化 
    //initButtonWidth();    //modify by txr 2023-03-09 UI
    InitEvent()
    initStatusData();
    initYearFlagData();
	
	$HUI.datagrid("#tDHCEQBuyRequestDetail",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSBuyRequest",
	        QueryName:"GetBuyRequestDetail",
			QXType:getElementValue("QXType"),	//czf 2021-09-02
			YearFlag:getElementValue("YearFlag"),
			Year:getElementValue("Year"),
			ManageLocDR:getElementValue("ManageLocDR"),
			RequestNo:getElementValue("RequestNo"),
			Status:getElementValue("Status"),
			StartDate:getElementValue("StartDate"),
			EndDate:getElementValue("EndDate"),
			UseLocDR:getElementValue("UseLocDR"),
			Name:getElementValue("Name")
		},
		rownumbers: true,  //如果为true则显示一个行号列
		singleSelect:true,
		fit:true,
		striped : true,
	    cache: false,
	    border:false,  //modify by lmm 2020-04-02 LMM0069
		fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
});
function InitEvent() //初始化事件
{
}
function initStatusData()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '新增'
			},{
				id: '1',
				text: '提交'
			},{
				id: '2',
				text: '审核'
			}]
	});
}
function initYearFlagData()
{
	var YearFlag = $HUI.combobox('#YearFlag',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: 'Y',
				text: '是'
			},{
				id: 'N',
				text: '否'
			}]
	});
}
function setSelectValue(elementID,rowData)
{
	//setElement(vElementID+"DR",rowData.TRowID)
	if(elementID=="ManageLocDR_CTLOCDesc") {setElement("ManageLocDR",rowData.TRowID)}
	else if(elementID=="UseLocDR_CTLOCDesc") {setElement("UseLocDR",rowData.TRowID)}
	else if(elementID=="Status") {setElement("StatusDR",rowData.TRowID)}
	else if(elementID=="YearFlag") {setElement("YearFlagDR",rowData.TRowID)}
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQBuyRequestDetail",{
	    url:$URL, 
	    queryParams:{
			ClassName:"web.DHCEQ.EM.BUSBuyRequest",
	        QueryName:"GetBuyRequestDetail",
			QXType:getElementValue("QXType"),
			YearFlag:getElementValue("YearFlag"),
			Year:getElementValue("Year"),
			ManageLocDR:getElementValue("ManageLocDR"),
			RequestNo:getElementValue("RequestNo"),
			Status:getElementValue("Status"),
			StartDate:getElementValue("StartDate"),
			EndDate:getElementValue("EndDate"),
			UseLocDR:getElementValue("UseLocDR"),
			Name:getElementValue("Name")
		}
	});
}
function BSaveExcel_Click() //导出
{
	var vData=GetData()
	var Job=$('#Job').val()
	PrintDHCEQEquipNew("ContractList",1,"",vData,"",100);
	return
}
function BColSet_Click() //导出数据列设置
{
	var para="&TableName=ContractList&SetType=0&SetID=0"
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	OpenNewWindow(url)
}
