var columns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','N');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
var frozencolumns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','Y');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
//界面入口
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();
	initStatusData();		
}
//初始化查询头面板
function initTopPanel()
{
	initLookUp();
	singlelookup("StatCat","PLAT.L.StatCat","",GetStatCat)
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	initStatusData();
	initMessage("");
	defindTitleStyle();
	setRequiredElements("SnapShot")
	initDHCEQSnapEquipList();			//初始化表格
	$("#EquipType").lookup({
            onSelect:function(index,rowData){
	            setElement("EquipTypeDR",rowData.TRowID)
                singlelookup("StatCat","PLAT.L.StatCat","",GetStatCat)
            },
       });
}

function GetStatCat(item)
{
	setElement("StatCat",item.TName);			
	setElement("StatCatDR",item.TRowID);
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	if(vElementID=="SnapShot")
	{
		setElement(vElementID,item.TDate)
	}
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
	if(vElementID=="EquipType")
	{
		setElement("StatCatDR","")
		setElement("StatCat","")
	}
	if(vElementID=="SnapShot")
	{
		setElement(vElementID,"")
	}
}
///add by lmm 2017-06-28 394342 状态下拉框增加全部状态
function initStatusData()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '在库'
			},{
				id: '1',
				text: '启用'
			},{
				id: '2',
				text: '停用'
			}]
});
}
function initDHCEQSnapEquipList()
{
	$HUI.datagrid("#tDHCEQSnapEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSSnapShot",   //Modefied by zc0044 2018-11-22 修改query名称
	        QueryName:"GetEquipList",
	        vData:"^IsOut=N^IsDisused=N^",
	        SnapShotID:$('#SnapShotDR').val(),
	    },
	    border : false,
		striped : true,
	    cache: false,
		//fitColumns:true,
    	columns:columns, 
    	frozenColumns:frozencolumns,
		fit:true,
    	pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
    	toolbar:[
                {
                iconCls: 'icon-export',
                text:'导出',
                handler: function(){
                     BSaveExcel_Click();
                }},'----------',
                {
                iconCls: 'icon-set-col',
                text:'导出列设置',
                handler: function(){
                     BColSet_Click();
                }}],
		onLoadSuccess: function (data) {
			InitToolbarForAmountInfo();	
		},
});
}
/***************************************按钮调用函数*****************************************************/
function BFind_Clicked()
{
	if (checkMustItemNull()) return;
	var lnk=GetLnk()
	//lnk=lnk+"&SnapShotID="+GetElementValue("SnapShotDR");
	$HUI.datagrid("#tDHCEQSnapEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSSnapShot",  //Modefied by zc0044 2018-11-22 修改query名称
	        QueryName:"GetEquipList",
	        vData:lnk,
	        SnapShotID:$('#SnapShotDR').val(),
	    },
	    onLoadSuccess: function (data) {
			InitToolbarForAmountInfo();
		}
	    });
	jQuery('#tDHCEQSnapEquipList').datagrid('unselectAll')  
}
function GetLnk()
{
	var lnk="";
	lnk=lnk+"^No="+getElementValue("No");
	lnk=lnk+"^Name="+getElementValue("Name");
	lnk=lnk+"^EquipCatDR="+getElementValue("EquipCatDR");
	lnk=lnk+"^Code="+getElementValue("Code");
	lnk=lnk+"^UseLocDR="+getElementValue("UseLocDR");
	if (getElementValue("IncludeFlag")==true)
		lnk=lnk+"^IncludeFlag=1"
	else 
		lnk=lnk+"^IncludeFlag=0"
	lnk=lnk+"^MinValue="+getElementValue("MinValue");
	lnk=lnk+"^MaxValue="+getElementValue("MaxValue");
	lnk=lnk+"^FundsTypeDR="+getElementValue("FundsTypeDR");
	lnk=lnk+"^LocationDR="+getElementValue("LocationDR");
	lnk=lnk+"^BeginInStockDate="+GetJQueryDate('#BeginInStockDate');   
	lnk=lnk+"^EndInStockDate="+GetJQueryDate('#EndInStockDate');
	lnk=lnk+"^EquipTypeDR="+getElementValue("EquipTypeDR");
	lnk=lnk+"^StatCatDR="+getElementValue("StatCatDR");
	lnk=lnk+"^ProviderDR="+getElementValue("ProviderDR");
	lnk=lnk+"^ManuFactoryDR="+getElementValue("ManuFactoryDR");
	lnk=lnk+"^Status="+getElementValue("Status");
	lnk=lnk+"^InStockNo="+getElementValue("InStockNo");
	lnk=lnk+"^StoreMoveNo="+getElementValue("StoreMoveNo");
	lnk=lnk+"^QXType="+getElementValue("QXType");
	lnk=lnk+"^IsDisused=N";                ;
	lnk=lnk+"^IsOut=N";
	lnk=lnk+"^Chk=";	//未打印条码
	if (getElementValue("Chk")==true)
	{
		lnk=lnk+"1";
	} 
	if (getElementValue("CheckRentFlag")==true)
		lnk=lnk+"^CheckRentFlag=1"
	else 
		lnk=lnk+"^CheckRentFlag=0"
	return lnk
}
function BSaveExcel_Click() //导出
{	
	var vData=GetLnk();
	PrintDHCEQEquipNew("Equip",1,getElementValue("Job"),vData,"SnapEquipList",50);	//Mozy	914705	2019-5-27
	return
}
function BColSet_Click() //导出数据列设置
{
	var para="&TableName=Equip&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)   //modify by lmm 2020-06-05 UI
	//Modefidy by zc0046 修改弹窗在不同分辨率弹窗覆盖问题
	//Modefied by zc0044 2018-11-22 修改弹窗大小
}
// 台账明细菜单栏中显示合计信息
function InitToolbarForAmountInfo() {
	var Data = tkMakeServerCall("web.DHCEQ.EM.BUSSnapShot","GetEquipSumInfo",'');  //Modefied by zc0044 2018-11-22 修改调用方法名称
	$("#sumTotal").html(Data);	
}
