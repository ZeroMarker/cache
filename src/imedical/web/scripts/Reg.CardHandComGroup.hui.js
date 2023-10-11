var PageLogicObj={
	m_RowId:"",
	m_ClassName:"web.DHCBL.CARD.CardHardComGroup"
}
$(function(){
	//初始化
	Init()
	//事件初始化
	InitEvent()
	//注册配置加载数据
	DataListLoad()
})
function Init(){
	//初始化界面上ComboBox
	InitComboBox();
	InitDataGrid();
	InitCache();
}
function InitEvent(){
	//定义新增按钮事件
	$("#Add").bind("click",AddClick)
	$("#Update").bind("click",UpdateClick)
	$("#Bsearch").bind("click",DataListLoad)
	$("#BClear").bind("click",ClearClick)
	//$("#Delete").bind("click",DeleteClick)
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitDataGrid(){
	//,:%String,DefualtProvince:%String,:%String,:%String,:%String,:%String
	var Columns=[[    
        { field : 'ID',title : '',width : 1,hidden:true},
		{ field: 'Code', title: '设备代码',  width:200,sortable: true, resizable: true},
		{ field : 'Name',title : '设备名称', width:200,sortable: true, resizable: true},
        { field : 'Type',title : '设备类型', width:200,sortable: true, resizable: true}
	]];
	var dataGrid=$("#DataList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		idField:'RowID',
		columns :Columns,
		onSelect:function(index,rowData){
			if(rowData["ID"]==PageLogicObj.m_RowId){
				PageLogicObj.m_RowId=""
				clear()
				$("#DataList").datagrid("unselectRow",index)
				return 
			}
			PageLogicObj.m_RowId=rowData["ID"]
			DataGridSelect(rowData["ID"])
		}
	});
	dataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return dataGrid;
}
function DataListLoad(){
	$.cm({
	    ClassName : "web.DHCBL.CARD.CardHardComGroup",
	    QueryName : "SelectByCondition",
	    code:$("#Code").val(),
	    desc:$("#Desc").val(),
	    type:$("#Type").combobox('getValue'),
	    rows:99999
	},function(GridData){
		$("#DataList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		$("#DataList").datagrid("clearSelections")
	});
}
function InitComboBox(){
	///初始化 设备类型 
	$.cm({
			ClassName:"web.DHCBL.UDHCCommFunLibary",
			QueryName:"InitListObjectValueNew",
			ClassName1:"User.DHCCardHardComGroup",
			PropertyName:"CCGType",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#Type", {
					valueField: 'ValueList',
					textField: 'DisplayValue', 
					editable:true,
					data: GridData["rows"]
			 });
	});
}
function SaveData(RowId){
	if(!CheckData()) return 
	var dataJson={}
	$.each(FieldJson,function(name,value){
		var val=getValue(value)
		val='"'+val+'"'
		eval("dataJson."+name+"="+val)
	});
	var jsonStr=JSON.stringify(dataJson)
	$m({
		ClassName:PageLogicObj.m_ClassName,
		MethodName:"SaveByJson",
		RowId:RowId,
		JsonStr:jsonStr
	},function(txtData){
		if(txtData==0){
			if(RowId==""){
				$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
			}else{
				$.messager.popover({msg: '更新成功！',type:'success',timeout: 1000});
				PageLogicObj.m_RowId=""
			}
			clear()
			DataListLoad()
		}else if(txtData=="-100"){
			$.messager.alert("提示","该设备组已存在!");
		}
	});
}
function CheckData(){
	var Code=$("#Code").val()
	if(Code==""){
		$.messager.alert("提示", "设备类型代码不能为空", 'info');
		return false 
	}
	var Desc=$("#Desc").val()
	if(Desc==""){
		$.messager.alert("提示", "设备类型名称不能为空", 'info');
		return false 
	}
	var Type=$("#Type").combobox("getValue")
	if(Type==""){
		$.messager.alert("提示", "设备类型不能为空", 'info');
		return false 
	}
	
	return true
}
function AddClick(){
	SaveData("")
}
function UpdateClick(){
	if(PageLogicObj.m_RowId==""){
		$.messager.alert("提示", "请选择配置数据", 'info');
		return 
	}
	SaveData(PageLogicObj.m_RowId)
	
}
function DeleteClick(){
	if(PageLogicObj.m_RowId==""){
		$.messager.alert("提示", "请选择要删除的设备类型", 'info');
		return 
	}
	$m({
		ClassName:PageLogicObj.m_ClassName,
		MethodName:"Delete",
		rowid:PageLogicObj.m_RowId
	},function(txtData){
		if(txtData==0){
			$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
			DataListLoad()
			clear()
			PageLogicObj.m_RowId=""
		}
	});
}
function DataGridSelect(RowId){
	$.cm({
		ClassName:PageLogicObj.m_ClassName,
		MethodName:"GetDataJson",
		RowId:RowId,
		jsonFiledStr:JSON.stringify(FieldJson)
	},function(JsonData){
		if(JsonData!=""){
			$.each(JsonData,function(name,value){
				setValue(name,value)
			})
		}
	});
}
///根据元素的classname获取元素值
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-switchbox")>=0){
		var val=$("#"+id).switchbox("getValue")
		return val=(val?'Y':'N')
	}else if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		return $("#"+id).combobox("getValue")
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
///给元素赋值
function setValue(id,val){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		$("#"+id).val(val)
		return 
	}
	if(className.indexOf("hisui-switchbox")>=0){
		val=(val=="Y"?true:false)
		$("#"+id).switchbox("setValue",val)
	}else if(className.indexOf("hisui-combobox")>=0){
		$("#"+id).combobox("setValue",val)
	}else if(className.indexOf("hisui-datebox")>=0){
		$("#"+id).datebox("setValue",val)
	}else{
		$("#"+id).val(val)
	}
	return ""
}
///编辑窗口清屏
function clear(){
	$.each(FieldJson,function(name,value){
		setValue(value,"")
	})
}
//界面元素和表里字段对照 
var FieldJson={
	CCGCode:"Code",
	CCGDesc:"Desc",
	CCGType:"Type"
}
function ClearClick(){
	$("#Code,#Desc").val('');
	$("#Type").combobox('select','');
	PageLogicObj.m_RowId="";
	DataListLoad();
}