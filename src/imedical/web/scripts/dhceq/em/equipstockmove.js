////add by ZY0220 2020-04-14批量调科
var columns=getCurColumnsInfo('EM.G.StoreMove.BatchStoreMove','','','','N'); 
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by zx 2019-05-05 界面加载效果影藏 ZX0063
});
function initDocument()
{
	initUserInfo();
    initMessage("StockMove"); 
	setElement("SMFromLocDR",getElementValue("SMFromLocDR"));
	setElement("SMFromLocDR_CTLOCDesc",getElementValue("SMFromLoc"));
	setElement("SMToLocDR",getElementValue("SMToLocDR"));
	setElement("SMToLocDR_CTLOCDesc",getElementValue("SMToLoc"));
	defindTitleStyle();
	initLookUp();
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"SMFromLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("SMFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"SMToLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("SMToLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	initButton(); //按钮初始化
	initButtonWidth();
	setRequiredElements("SMFromLocDR_CTLOCDesc^SMToLocDR_CTLOCDesc"); //必填项
	setEnabled();
	//table数据加载
	$HUI.datagrid("#DHCEQEquipStockMove",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSStoreMove",
			QueryName:"GetBatchStockMove",
			SMRowIDs:getElementValue("SMRowIDs"),
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    toolbar:[
		    {
				iconCls: '',
	            text:'',
	            id:'add',
	        },'----------',],
	    columns:columns,
		fitColumns:true,   //modify by lmm 2020-06-04 UI
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10],
		onLoadSuccess:function(){
				creatToolbar();
			}
	});
};

//添加“合计”信息
function creatToolbar()
{
	var TotalFee=parseFloat(getElementValue("TotalFee"))
	var lable_innerText='总数量:'+getElementValue("Length")+'&nbsp;&nbsp;&nbsp;总金额:'+TotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
}

function setEnabled()
{
	var SMRowIDs=getElementValue("SMRowIDs")
	if (SMRowIDs!="")
	{
		disableElement("BSave",true);
	}
}

function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var SMFromLocDR=getElementValue("SMFromLocDR")
	var SMToLocDR=getElementValue("SMToLocDR")
	var RowIDs=getElementValue("RowIDs")
	var SMMoveType=getElementValue("SMMoveType")
	var jsonData = tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove", "BatchStockMove",SMFromLocDR,SMToLocDR,RowIDs,SMMoveType);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&SMRowIDs="+jsonData.Data
		val=val+"&RowIDs="+RowIDs
		val=val+"&SMToLocDR="+getElementValue("SMToLocDR")
		val=val+"&SMToLoc="+getElementValue("SMToLoc")
		val=val+"&QXType="+getElementValue("QXType")
		val=val+"&WaitAD="+getElementValue("WaitAD")
		val=val+"&CurRole="+getElementValue("CurRole")
		val=val+"&CancelOper="+getElementValue("CancelOper")
		var url="dhceq.em.equipstockmove.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }

}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
}