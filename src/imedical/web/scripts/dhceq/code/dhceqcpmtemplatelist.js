/***************************
//文件名：        dhceqcpmtemplatelist.js
//文件功能描述:   PM模板明细维护
//创建人:         H_Haiman   HHM0032
//创建时间:       2016-01-13
//描述:           
//修改人:         
//修改时间；      
//修改描述:    
//***************************/

//全局变量
/************************************/
var SelectedRowID = 0;
var preRowID=0;  
var RowID=0   //全局变量 用于处理选中行
//处理DR取值，选中行
var ElementObj={
	RID:"",
	Note:"",
	DefaultVal:"",
	Sort:"",
	TemplateDR:initPageID()[0].split("=")[1],	//modified by csj 2020-02-24 需求号：1191838 修正
	TType:initPageID()[1].split("=")[1],	//modified by csj 2020-02-24 需求号：1191838 修正
	TName:"",//initPageName(),
	TCaption:"",
	
	MaintItemDR:"",
	MItem:"",
	
	MaintItemCatDR:"",
	MItemCat:"",
	
	ClearData:function(){
		this.RID="";
		//this.TemplateDR="";
		//this.TType="";
		//this.TName="";
		//this.TCaption="";
		//this.MaintItemDR="";
		//this.MItem="";
		//this.MaintItemCatDR="";
		//this.MItemCat="";
		this.Note="";
		this.DefaultVal="";
		this.Sort="";
	}
}
//*************************************

//界面入口
jQuery(document).ready(function(){
	setTimeout("initDocument();", 50);
});
function initDocument(){
	//add by lmm 2020-04-27 1289831
	setRequiredElements("MaintItem^Sort")	
	initMessage();	
	initPanel();
	initPMTemplateListData();	
	//modify by lmm 2020-04-03
	defindTitleStyle();}

//
function initPanel() {
	initTopPanel();
	initPMTemplateListPanel();
	//modify by lmm 2020-04-27
	//initMaintItemPanel();   
	initLookUp();
}
//初始化查询头面板
function initTopPanel(){
	jQuery("#BAdd").linkbutton({
		 iconCls: 'icon-w-add'
	});
	jQuery("#BUpdate").linkbutton({
		iconCls: 'icon-w-save'
	});
	jQuery("#BDel").linkbutton({
		iconCls: 'icon-w-close'
	});
	jQuery("#BAdd").on("click",BAddClick);
	jQuery("#BUpdate").on("click", BUpdateClick);
	jQuery("#BDel").on("click",BDelClick);	
}

//modified by csj 2020-02-24 返回查询参数数组
function initPageID(){
	var str=window.location.search.substr(1);
	var tmp=str.split('&');	
	return tmp;
}
//*************************************
// MZY0076	2021-05-25
//列表面板
function initPMTemplateListPanel(){
	jQuery('#tPMTemplateList').datagrid({
		columns:[[
			{field:'TRowID',title:'RowID',width:50,hidden:true},
			{field:'TName',title:'模板名称',align:'center',width:100},
			{field:'TCaption',title:'模板标题',align:'center',width:100,hidden:true},
			{field:'TType',title:'类型',align:'center',width:80},
			{field:'TItemCat',title:'项目大类',align:'center',width:100}, 
			{field:'TItemCode',title:'项目编码'},
			{field:'TItem',title:'项目'},
			{field:'TNote',title:'明细注释',align:'center',width:100},
			{field:'TDefaultVal',title:'明细默认值',align:'center',width:100},
			{field:'TSort',title:'排序',align:'center',width:100},
		]],
    	fitColumns: true,
    	singleSelect:true,
    	loadMsg:'数据加载中……',
    	pagination:true,
		pageSize:20,
		pageNumber:1,
		pageList:[20,40,60,80,100], 
    	rownumbers: true,  //如果为true，则显示一个行号列
		onBeforeLoad: function(param) {
			//目的是为了防止loadData时，设置url加载两次
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadSuccess:function(data){},
		onLoadError: function() {
			jQuery.messager.alert("错误", "加载列表错误.");
		},
		onSelect:onSelectRow
	});
}

//加载项目下拉列表
function initMaintItemPanel(){
	jQuery('#MaintItem').combogrid({
		panelWidth:500,
    	singleSelect:true,
    	loadMsg:'数据加载中……',
    	pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50], 
    	rownumbers: true,  //如果为true，则显示一个行号列
    	idField:'TRowID',
		textField:'TMIDesc',
		columns:[[
				{field:'TRowID',title:'ID',align:'center',width:30,hidden:true},
				{field:'TMICode',title:'代码',align:'center',width:60},
		        {field:'TMIDesc',title:'项目',align:'center',width:100},		    
		       	{field:'TMICaption',title:'标题',align:'center',width:100},
		        {field:'TMICDesc',title:'项目大类',align:'center',width:100},
		]],
		onLoadSuccess:function(data){},
		onLoadError:function() {jQuery.messager.alert("错误", "加载项目列表失败!");},
		onChange: function(newValue, oldValue){},
		onSelect: function(rowIndex, rowData) {ElementObj.MaintItemDR=rowData.TRowID},//获取下拉列表的RowID
		keyHandler:{
			query:function(){},
			enter:function(){ComboGridKeyEnter(vElementID);},
		 	up:function(){ComboGridKeyUp(vElementID);},
			down:function(){ComboGridKeyDown(vElementID);},
			left:function(){},
			right:function(){}
		}
	});	
	jQuery('#TDMaintItem').focusin(function(){initMaintItemData()});
}


//*************************************
//加载面板数据
function initPMTemplateListData(){
	var queryParams = new Object();
	var ClassName = "web.DHCEQ.Code.DHCEQCPMTemplateList";
	var QueryName = "PMTemplateList";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 =ElementObj.TemplateDR; 
	queryParams.ArgCnt =1;	
	loadDataGridStore("tPMTemplateList", queryParams);
}

//加载项目下拉列表数据
function initMaintItemData(){
	var queryParams = new Object();
	var ClassName = "web.DHCEQ.Code.DHCEQCPMTemplateList";
	var QueryName = "GetMaintItem";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 =ElementObj.TType;	//modified by csj 2020-02-24 需求号：1191838
	queryParams.ArgCnt =1;
	loadComboGridStore("MaintItem", queryParams);	
}

//**************************************
//按钮函数
//新增
function BAddClick(){
	if (checkMustItemNull()) return;	//add by lmm 2020-04-27 1289831
	var data=""
	var Note=jQuery('#Note').val();
	var Sort=jQuery('#Sort').val();
	var DefaultVal=jQuery('#DefaultVal').val();
	data=""+"^"+ElementObj.TemplateDR+"^"+ElementObj.MaintItemDR+"^"+Note+"^"+Sort+"^"+DefaultVal
	resultData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplateList','SaveData',data,'2');
	//messageShow("","","",resultData)
	if(resultData<0){
		if(resultData==-3001){
			alertShow('排序数据有重复！');
			return;
		}
		alertShow('新增失败！')
	}
	else{
		jQuery('#tPMTemplateList').datagrid("reload");
		Clear();
	}
}

//
function BUpdateClick(){
	//begin add by jyp 2018-03-12 544700
	if((RowID=="")||(RowID==0)){         
		alertShow('请选择一条数据!');         
		return true;
	}
	//End add by jyp 2018-03-12 544700
	if (checkMustItemNull()) return;	//add by lmm 2020-04-27 1289831
	var data=""
	var Note=jQuery('#Note').val();
	var Sort=jQuery('#Sort').val();
	var DefaultVal=jQuery('#DefaultVal').val();
	data=ElementObj.RID+"^"+ElementObj.TemplateDR+"^"+ElementObj.MaintItemDR+"^"+Note+"^"+Sort+"^"+DefaultVal
	resultData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplateList','SaveData',data,'2');
	//messageShow("","","",resultData)
	if(resultData<0){
		if(resultData==-3001){
			alertShow('排序数据有重复！');
			return;
		}		
		alertShow('更新失败！');
	}
	else{
		jQuery('#tPMTemplateList').datagrid("reload");
		Clear();
	}
}

//
function BDelClick(){
	//add by lmm 2020-04-27 1289852
     var selected=jQuery('#tPMTemplateList').datagrid('getSelected');
     if (!selected)
     {
	     alertShow('未选中数据！')
	     return;
	    }
	//add by lmm 2020-04-27 1289852
	var truthBeTold = window.confirm("确定要删除吗？");//279878  Add By BRB 2016-11-14 增加点击删除弹出提示框
    if (!truthBeTold) return;//279878  Add By BRB 2016-11-14  增加点击删除弹出提示框 
	if(RowID!=0){
		var returnData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplateList','SaveData',RowID,'1')	
		if(returnData<0){
			alertShow('删除失败！')
		}
		else{
				jQuery('#tPMTemplateList').datagrid("reload");
				Clear();
			}
	}
	else{
		alertShow('请选择一行进行操作！');
	}
}
function Clear(){
	jQuery('#TType').combogrid('setValue','');
	jQuery('#Note').val('');
	jQuery('#Sort').val('');
	jQuery('#DefaultVal').val('');
	jQuery('#MaintItem').combogrid('setValue',''); //add by lmm 2018-03-13 553376
}
function CheckEmpty(){
	if(jQuery('#MaintItem').combogrid('getValue')==0){
		alertShow('项目不能为空!');
		return true;
	}
	if(jQuery('#Sort').val()==""){
		alertShow('排序不能为空!')
		return true;
	}
	return false;
}
//**************************************
//处理行事件函数



//
//选中行处理
//modify by lmm 2020-04-27
function onSelectRow(rowIndex, rowData){
     var selected=jQuery('#tPMTemplateList').datagrid('getSelected');
     if (selected)
     {  
        var SelectedRowID=selected.TRowID;
        if(preRowID!=SelectedRowID)
        {
	        RowID=selected.TRowID ;   //全局变量
	        var Obj=fillData(selected.TRowID);

			setElement("MaintItem",Obj.MItem)			
			setElement("Note",Obj.Note)			
			setElement("DefaultVal",Obj.DefaultVal)			
			setElement("Sort",Obj.Sort)
			
            preRowID=SelectedRowID;
         }
         else
         {
	       	RowID=0;
	       	ElementObj.ClearData();
			setElement("MaintItem","")			
			setElement("Note","")			
			setElement("DefaultVal","")			
			setElement("Sort","")							        		
            SelectedRowID = 0;
            preRowID=0;
            jQuery('#tPMTemplateList').datagrid('unselectAll');	// MZY0096	2134929		2021-09-16
         }
     }	
}
//**************************************
//获取页面数据函数
function GetPageValue(type){
	var MaintItem=jQuery('#MaintItem').combogrid('getValue');
	var Note=jQuery('#Note').val();
	var DefaultVal=jQuery('#DefaultVal').val();
	var Sort=jQuery('#Sort').val();
}
function fillData(rowid){
	if(rowid==""){return;}
	var resultData=tkMakeServerCall('web.DHCEQ.Code.DHCEQCPMTemplateList','GetPMTemplateListByID',rowid);
	data=resultData.split('^');
	ElementObj.RID=data[0];
	ElementObj.Note=data[1];
	ElementObj.DefaultVal=data[2];
	ElementObj.Sort=data[3];
	ElementObj.TemplateDR=data[4];
	ElementObj.TType=data[5];
	ElementObj.TName=data[6];
	ElementObj.TCaption=data[7];
	ElementObj.MaintItemDR=data[8];
	ElementObj.MItem=data[9];
	ElementObj.MaintItemCatDR=data[10];
	ElementObj.MItemCat=data[11];
	return ElementObj;
}
//**************************************
//加载控件数据
/**
/**
*加载DataGrid数据
*/
function loadDataGridStore(DataGridID, queryParams){
	window.setTimeout(function(){
		var jQueryGridObj = jQuery("#" + DataGridID);
		jQuery.extend(jQueryGridObj.datagrid("options"),{
			//url : './dhceq.jquery.combo.easyui.csp',
			url:'dhceq.jquery.csp',
			queryParams : queryParams
		});
		jQueryGridObj.datagrid("load");
	},0);
}
/**
*加载ComboGrid数据
*/
function loadComboGridStore(ComboGridID, queryParams) {
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// 获取数据表格对象
	var opts = grid.datagrid("options");
	//opts.url='./dhceq.jquery.grid.easyui.csp';
	opts.url='dhceq.jquery.csp';    
	grid.datagrid('load', queryParams);
}

//add by lmm 2020-04-27 
function setSelectValue(vElementID,rowData)
{
	if (vElementID=="MaintItem")
	{
		setElement("MaintItem",rowData.TDesc)
	}
	//setElement(vElementID+"DR",rowData.TRowID);
	ElementObj.MaintItemDR=rowData.TRowID
}
function clearData(vElementID)
{
	//setElement(vElementID+"DR","");	
	ElementObj.MaintItemDR=""
}
