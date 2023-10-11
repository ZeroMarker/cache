var columns=getCurColumnsInfo('PLAT.G.CT.MaintItem','','','');
var PreSelectedRowID = "";	//取当前选中的组件设备记录ID
//界面入口
jQuery(document).ready
(
	function()
	{
		initDocument();
	}
);
///初始化界面
function initDocument()
{
	defindTitleStyle(); //默认Style
	initMessage();
	initPage();			//放大镜及按钮初始化
	setEnabled();		//按钮控制
}
///初始化按钮状态
function setEnabled()
{
//	disableElement("BSave",true);
	disableElement("BDelete",true);
//	disableElement("BAdd",false);
}
///选中行按钮状态
function onSelect()
{
//	disableElement("BSave",false);
	disableElement("BDelete",false);
//	disableElement("BAdd",true);
}
//放大镜及按钮初始化
function initPage()
{
	initLookUp();		//初始化放大镜
	initMIType()
	jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BSave").on("click", BSave_Click);
	jQuery("#BDelete").linkbutton({iconCls: 'icon-w-close'});
	jQuery("#BDelete").on("click", BDelete_Click);
	jQuery("#BClear").linkbutton({iconCls: 'icon-w-clean'});
	jQuery("#BClear").on("click", BClear_Click);
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Click);
	initButtonWidth();
	initDatagrid();
	setRequiredElements("MICode^MIDesc^MIType^MIItemCat")
	
}
function initMIType(){
	$HUI.combobox("#MIType",{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[
			{id:'',text:''},
			{id:'1',text:'保养'},
			{id:'2',text:'检查'},
			{id:'3',text:'维修'}
		],
	});
}
//放大镜选取后执行方法
function setSelectValue(vElementID,rowData)
{
 	if (vElementID=="MIItemCat"){
	 	setElement("MIItemCatDR",rowData.TRowID)
	 	setElement("MIItemCat",rowData.TDesc)
	}
}
//查找按钮点击事件
function BFind_Click()
{
	$HUI.datagrid("#DHCEQCMaintItem",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.Plat.CTMaintItem",
			QueryName:"GetMaintItem",
	    	Code:getElementValue("MICode"),
	    	Desc:getElementValue("MIDesc"),  // add by mwz 20221228 mwz0066
	    	Type:getElementValue("MIType")  // add by mwz 20221228 mwz0066
		}
	});
}

function initDatagrid()
{
	$HUI.datagrid('#DHCEQCMaintItem',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTMaintItem",
			QueryName:"GetMaintItem",
			Code:"",
			Desc:""
		},
		onSelect:function(rowIndex,rowData){
			OnClickRow(rowIndex, rowData);
		},
		
		onLoadSuccess:function(data){

		},
		autoSizeColumn:true,
		fitColumns:true,
		fit:true,
		fitColumns:true,
		cache: false,
		border:false,  //modify by lmm 2020-04-02
		columns:columns,
		pagination:true,
		pageSize:10,
	    pageNumber:1,
	    pageList:[10,20,30,40,50],
		rownumbers:true,
		singleSelect:true,

	})	
}

function OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{
		var TTypeCode=""
		if(rowData.TType=='保养'){
			TTypeCode=1
		}else if(rowData.TType=='检查'){
			TTypeCode=2
		}else if(rowData.TType=='维修'){
			TTypeCode=3
		}
		setElement("RowID",rowData.TRowID);
		setElement("MICode",rowData.TCode);
		setElement("MIDesc",rowData.TDesc);
		setElement("MIRemark",rowData.TRemark);
//		setElement("MIInvalidFlag",rowData.TInvalidFlag=="Y"?true:false); modified by csj 20190612
		setElement("MIType",TTypeCode);
		setElement("MICaption",rowData.TCaption);
		setElement("MIItemCatDR",rowData.TItemCatDR);
		setElement("MIItemCat",rowData.TItemCatDesc);
		setElement("MIHold1",rowData.THold1);
		setElement("MIHold2",rowData.THold2);
		setElement("MIHold3",rowData.THold3);
		onSelect();
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Click();
		PreSelectedRowID=""
	}
	
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

function BSave_Click()
{
	if(checkMustItemNull()){return;}
	var val=Combindata();
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTMaintItem","SaveData",val,"");
	if (result<0) {
		if(result=="-3003"){
			messageShow("alert","error","错误提示","数据重复！")
			return
		}
		messageShow("alert","error","错误提示",result)
		return
	}
	messageShow("alert","success","提示","保存成功！");
	$HUI.datagrid('#DHCEQCMaintItem').reload(); 
	BClear_Click()
}
// MZY0096	2135243		2021-09-16	增加确认选项
function BDelete_Click()
{
		messageShow("confirm","","","确定要删除该记录吗？","",DeleteMaintItem,unDeleteMaintItem,"是","否");
}
function DeleteMaintItem()
{
	var val=Combindata();
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTMaintItem","SaveData",val,"1");
	if (result<0) {
		messageShow("alert","error","错误提示",result)
		return
	}
	messageShow("alert","success","提示","删除成功！");
	$HUI.datagrid('#DHCEQCMaintItem').reload(); 
	BClear_Click()
}
function unDeleteMaintItem()
{
}
function BClear_Click()
{
	setElement("RowID","");
	setElement("MICode","");
	setElement("MIDesc","");
	setElement("MIRemark","");
//	setElement("MIInvalidFlag",false); modified by csj 20190612
	setElement("MIType","");
	setElement("MICaption","");
	setElement("MIItemCatDR","");
	setElement("MIItemCat","");
	setElement("MIHold1","");
	setElement("MIHold2","");
	setElement("MIHold3","");
	setEnabled();
	PreSelectedRowID=""
}

function Combindata()
{
	var combindata=getElementValue("RowID");
	combindata=combindata+"^"+getElementValue("MICode") ;
	combindata=combindata+"^"+getElementValue("MIDesc") ;
	combindata=combindata+"^"+getElementValue("MIRemark") ;
	combindata=combindata+"^";	//modified by csj 20190612
	combindata=combindata+"^"+getElementValue("MIType") ;
	combindata=combindata+"^"+getElementValue("MICaption") ;
	combindata=combindata+"^"+getElementValue("MIItemCatDR") ;
	combindata=combindata+"^"+getElementValue("MIHold1") ;	
	combindata=combindata+"^"+getElementValue("MIHold2") ;
	combindata=combindata+"^"+getElementValue("MIHold3") ;
    return combindata;
}
