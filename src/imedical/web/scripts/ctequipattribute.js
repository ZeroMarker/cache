var columns=getCurColumnsInfo('PLAT.G.CT.EquipAttribute','','','');
$.extend($.fn.datagrid.defaults.view,{
	onAfterRender:function(target){	
	var h = $(window).height();
	var offset = $(target).closest('.datagrid').offset();
	$(target).datagrid('resize',{height:parseInt(h-offset.top-13)});
	}
}); 
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
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
///选中行按钮状态
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}
//放大镜及按钮初始化
function initPage()
{
	jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BSave").on("click", BSave_Clicked);
	jQuery("#BDelete").linkbutton({iconCls: 'icon-w-close'});
	jQuery("#BDelete").on("click", BDelete_Clicked);
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Clicked);
	initButtonWidth();
	initMaindatagrid();
	setRequiredElements("EACode^EAName")
}
//查找按钮点击事件
function BFind_Clicked()
{
	$HUI.datagrid("#maindatagrid",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.Plat.CTEquipAttribute",
	    	QueryName:"GetEquipAttributeData",
	    	Code:getElementValue("EACode"),	//add by csj 20191202
	    	Name:getElementValue("EAName")	//add by csj 20191202
		}
	});
}
//加载主GRID
function initMaindatagrid()
{
	$(function(){
		$HUI.datagrid('#maindatagrid',{
			url:$URL,
			queryParams:{
        		ClassName:"web.DHCEQ.Plat.CTEquipAttribute",
        		QueryName:"GetEquipAttributeData",
    		},
			onSelect:function(rowIndex,rowData){
				fillData_OnClickRow(rowIndex, rowData);
			},
			
			onLoadSuccess:function(data){

			},
			//autoSizeColumn:false,
			//fitColumns:true,
			fitColumns:true,
			cache: false,
			columns:columns,
			//idField:'id',
			pagination:true,
			pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
			//rownumbers:true,
			singleSelect:true,
			//width:500,
			//height:330,
		})
	})		
}
///点击行事件
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{
		setElement("EARowID",rowData.TRowID);
		setElement("EACode",rowData.TCode);
		setElement("EAName",rowData.TName);
		setElement("EAGroup",rowData.TGroup);
		setElement("EARemark",rowData.TRemark);

		UnderSelect();
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Clicked();
		PreSelectedRowID=""
	}
	
}

//////////////////////////////////业务处理函数/////////////////////////////////////////////

///Creator: jyp
///CreatDate: 2018-10-09
///Description: 数据新增方法
function BAdd_Clicked()
{
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTEquipAttribute","SaveData",data,"2");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","新增成功！");
	var url="dhceq.plat.ctequipattribute.csp";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}

///Creator: jyp
///CreatDate: 2018-10-09
///Description: 数据保存方法
function BSave_Clicked()
{
	if(checkMustItemNull()){return;}

	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTEquipAttribute","SaveData",data,"");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","修改成功！");
	var url="dhceq.plat.ctequipattribute.csp";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
///Creator: jyp
///CreatDate: 2018-10-09
///Description: 数据删除方法
function BDelete_Clicked()
{
	//modified by wy 2021-9-14 2144478
	messageShow("confirm","info","提示","是否删除该信息？","",BDelete,function(){
		return;
		});	

}
function BDelete()
{ 
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTEquipAttribute","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	else {messageShow("alert","success","提示","删除成功！");}
	var url="dhceq.plat.ctequipattribute.csp";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},300);  //modified by wy 2021-9-6 2144478
}
//清空按钮触发事件，取消选中行触发事件
function BClear_Clicked()
{
	setElement("EARowID","");
	setElement("EACode","");
	setElement("EAName","");
	setElement("EAGroup","");
	setElement("EARemark","");

	setEnabled();
	PreSelectedRowID=""
}
