
var editFlag="undefined";
var SelectRowID="";
var Columns=getCurColumnsInfo('EM.G.PaymentNotice.PaymentNoticeFind','','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage("PaymentNotice"); //获取所有业务消息
    initLookUp();
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"LocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("LocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	defindTitleStyle();
  	initButton();
  	initEvent();
  	setEnabled(); //按钮控制
    initButtonWidth();
	$HUI.datagrid("#tDHCEQPaymentNoticeFind",{
	    url:$URL,
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSPaymentNotice",
	        	QueryName:"GetPaymentNotice",
				PaymentNoticeNo:getElementValue("PaymentNoticeNo"),
				InvoiceNo:getElementValue("InvoiceNo"),
				LocDR:getElementValue("LocDR"),
				Status:getElementValue("Status"),
				ProviderDR:getElementValue("PNProviderDR"),
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate")
			},
			fitColumns: true,
			striped: false,
			rownumbers: true,  //如果为true则显示一个行号列
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			onLoadSuccess:function(){
			}
	});
}

function initEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj)
	{
		jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
		jQuery("#BAdd").on("click", BAdd_Clicked);
	}
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQPaymentNoticeFind",{
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSPaymentNotice",
	        	QueryName:"GetPaymentNotice",
				PaymentNoticeNo:getElementValue("PaymentNoticeNo"),
				InvoiceNo:getElementValue("InvoiceNo"),
				LocDR:getElementValue("LocDR"),
				Status:getElementValue("Status"),
				ProviderDR:getElementValue("PNProviderDR"),
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate")
			},
			rownumbers: true,  //如果为true则显示一个行号列
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}
function BAdd_Clicked()
{
	var url= 'dhceq.em.paymentnotice.csp?';
	showWindow(url,"设备付款通知单新增","","","icon-w-paper","modal","","","large",refreshWindow)
}
function setEnabled()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '4',text: '全部'},{id: '0',text: '新增'},{id: '2',text: '审核'},{id: '3',text: '作废'}],
		onSelect : function(){}
	});
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="LocDR_CTLOCDesc") {setElement("LocDR",rowData.TRowID)}
	else if(elementID=="PNProviderDR_VDesc") {setElement("PNProviderDR",rowData.TRowID)}
}
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}