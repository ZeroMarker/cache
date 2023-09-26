var columns=getCurColumnsInfo('PLAT.G.CT.MaintItemCat','','','');
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
	initMICType()
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
	setRequiredElements("MICCode^MICDesc^MICType")
	
}
function initMICType(){
	$HUI.combobox("#MICType",{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[
			{id:'',text:''},
			{id:'1',text:'保养'},
			{id:'2',text:'检查'},
			{id:'3',text:'维修'}
		],
	});
}

//查找按钮点击事件
function BFind_Click()
{
	$HUI.datagrid("#DHCEQCMaintItemCat",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.Plat.CTMaintItemCat",
			QueryName:"GetMaintItemCat",
	    	Code:getElementValue("MICCode"),
	    	Desc:getElementValue("MICDesc")
		}
	});
}

function initDatagrid()
{
	$HUI.datagrid('#DHCEQCMaintItemCat',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTMaintItemCat",
			QueryName:"GetMaintItemCat",
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
		setElement("MICType",TTypeCode);
		setElement("MICCode",rowData.TCode);
		setElement("MICDesc",rowData.TDesc);
		setElement("MICRemark",rowData.TRemark);
//		setElement("MICInvalidFlag",rowData.TInvalidFlag=="Y"?true:false);modified by csj 20190612
		onSelect();
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Click();
		PreSelectedRowID=""
	}
	
}


function BSave_Click()
{
	if(checkMustItemNull()){return;}
	var val=Combindata();
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTMaintItemCat","SaveData",val,"");
	if (result<0) {
		messageShow("alert","error","错误提示",result)
		return
	}
	messageShow("alert","success","提示","保存成功！");
	$HUI.datagrid('#DHCEQCMaintItemCat').reload(); 
	BClear_Click()
}

function BDelete_Click()
{
	var val=Combindata();
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTMaintItemCat","SaveData",val,"1");
	if (result<0) {
		if(result=="-3003"){
			messageShow("alert","error","错误提示","数据重复！")
			return
		}
		messageShow("alert","error","错误提示",result)
		return
	}
	messageShow("alert","success","提示","删除成功！");
	$HUI.datagrid('#DHCEQCMaintItemCat').reload(); 
	BClear_Click()
}

function BClear_Click()
{
	setElement("RowID","");
	setElement("MICType","");
	setElement("MICCode","");
	setElement("MICDesc","");
	setElement("MICRemark","");
//	setElement("MICInvalidFlag",false);	modified by csj 20190612
	setEnabled();
	PreSelectedRowID=""
}

function Combindata()
{
	var combindata=getElementValue("RowID");
	combindata=combindata+"^"+getElementValue("MICType") ;
	combindata=combindata+"^"+getElementValue("MICCode") ;
	combindata=combindata+"^"+getElementValue("MICDesc") ;
	combindata=combindata+"^"+getElementValue("MICRemark") ;
//	combindata=combindata+"^"+getElementValue("MICInvalidFlag") ; modified by csj 20190612
    return combindata;
}
