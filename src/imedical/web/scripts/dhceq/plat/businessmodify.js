$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	defindTitleStyle();
	initButton(); //按钮初始化
    initButtonWidth();
	initBussType();
	setRequiredElements("BussType^BussNo");
}
function initBussType()
{
	$HUI.combobox('#BussType',{
		valueField:'busscode',
		textField:'text',
		panelHeight:"auto",
		data:[{
			busscode: '21',
			text: '入库'
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
        	loadData(bussType,bussNo);
        	loadInStockListData(bussNo);
        break;
        default:
        break;
	}
}

function loadData(bussType,bussNo)
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","GetBusinessMain",bussType,bussNo)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE==-9012) {messageShow('','','',"入库单号不存在!",'',function(){reloadPage();});} // Modify by zx 2020-03-31BUG ZX0082
	else if(jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
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
		border:false,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    columns:[[
	    	{field:'TRowID',title:'TRowID',hidden:true},
			{field:'TOpt',title:'操作',width:80,align:'center',formatter:function(value,rec){
                	var btn = '<a href="#" class="hisui-linkbutton hover-dark" onclick="javascript:editBusinessList('+rec.TRowID+')">修改</a>';  
                	return btn;  
           		}
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
			{field:'TRemark',title:'备注',width:100,align:'center'} 	       
	    ]]
	});
}

function editBusinessList(BussID)
{
	var bussType=getElementValue("BussType");
	var url="dhceq.plat.businessmodifylist.csp?BussType="+bussType+"&BussID="+BussID;
	showWindow(url,"业务明细修改","","6row","icon-w-paper","modal","","","middle"); //modify by lmm 2020-06-05 UI
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
    window.location.href= url;
}