var PageLogicObj={
	m_RowId:"",
	m_ClassName:"web.DHCDocUpdateLog",
	m_AddFlag:0
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
	InitLookup();
}
function InitEvent(){
	//定义新增按钮事件
	$("#Save").bind("click",SaveClick)
	$("#BFind").bind("click",DataListLoad)
}
function InitDataGrid(){
	var Columns=[[    
        {field:'ID',title : '',width : 1,hidden:true},
		{field:'ClassName', title: '类名',  width:200,sortable: true, resizable: true},
		{field:'ClassProperty',title : '属性名', width:200,sortable: true, resizable: true},
        {field:'ClassPropertyDesc',title : '属性描述', width:200,sortable: true, resizable: true},
		{field:'ClassPropertyIndex',title : '属性序号', width:200,sortable: true, resizable: true},
		{field:'PropertyLinkName',title : '指针索引描述', width:200,sortable: true, resizable: true}
	]];
	var dataGrid=$("#DataList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		idField:'RowID',
		columns :Columns,
		toolbar: [
		{
			iconCls: 'icon-add ',
			text:'新增',
			handler: function(){
				$("#ClassName").lookup("enable");
				$("#ClassProperty").lookup("enable");
				clear();
				$("#Win").dialog("open");
				$("#Win").dialog("center");
				PageLogicObj.m_AddFlag=1;
			}
		},{
			iconCls: 'icon-write-order',
			text:'修改',
			handler: function(){
				if(PageLogicObj.m_RowId==""){
					$.messager.alert("提示", "请选择要修改的数据", 'info');
					return 
				}
				DataGridSelect(PageLogicObj.m_RowId)
				$("#Win").dialog("open");
				$("#Win").dialog("center");
				PageLogicObj.m_AddFlag=0;
			}
		},{
			iconCls: 'icon-cancel',
			text:'删除',
			handler: function(){
				DeleteClick()
			}
		}],
		onDblClickRow:function(index, rowData){
			PageLogicObj.m_RowId=rowData["ID"]
			DataGridSelect(PageLogicObj.m_RowId)
			$("#Win").dialog("open")
			$("#Win").dialog("center")
		},
		onSelect:function(index,rowData){
			PageLogicObj.m_RowId=rowData["ID"]
		}
	});
	dataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return dataGrid;
}
function DataListLoad(){
	$.cm({
	    ClassName : PageLogicObj.m_ClassName,
	    QueryName : "FindUPLSClassProperty",
		ClsName:$("#ClassListSearch").combobox("getValue"),
	    rows:99999
	},function(GridData){
		$("#DataList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		$("#DataList").datagrid("clearSelections")
	});
}
function InitComboBox(){
	///初始化 设备类型 
	$.cm({
			ClassName:PageLogicObj.m_ClassName,
			QueryName:"UPLSClassList",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#ClassListSearch", {
					valueField: 'ClassName',
					textField: 'ClassName', 
					editable:true,
					data: GridData["rows"]
			 });
	});
}
function PropertyLinkNameLoad(){
	var SubClassUserName=tkMakeServerCall(PageLogicObj.m_ClassName,"PropertyLinkClassNameNew",$("#ClassNameId").val(),$("#ClassPropertyId").val())
	$.cm({
			ClassName:PageLogicObj.m_ClassName,
			QueryName:"SelectPropertyNew",
			ClsName:SubClassUserName,
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#PropertyLinkName", {
					valueField: 'propertyName',
					textField: 'propertyName', 
					editable:true,
					data: GridData["rows"]
			 });
	});
}
function InitLookup(){
	$("#ClassName").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:'ClassName',
            textField:'ClassName',
            columns:[[  
                {field:'ClassName',title:'类名',width:250}
            ]],
			pagination:true,
			panelWidth:300,
			panelHeight:300,
			isCombo:true,
			minQueryLen:1,
			delay:'500',
			queryOnSameQueryString:true,
			queryParams:{ClassName: PageLogicObj.m_ClassName,QueryName: 'FindClass'},
			onBeforeLoad:function(param){
				var desc=param['q'];
				if (desc=="") return false;
				param = $.extend(param,{ClsName:desc});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#ClassNameId").val(rowData["ClassName"])
				//ClassPropertyLoad()
            }
    });
	$("#ClassProperty").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:'propertyField',
            textField:'propertyField',
            columns:[[  
                {field:'propertyField',title:'属性名',width:250}
            ]],
			pagination:true,
			panelWidth:300,
			panelHeight:300,
			isCombo:true,
			minQueryLen:0,
			delay:'500',
			queryOnSameQueryString:true,
			queryParams:{ClassName: PageLogicObj.m_ClassName,QueryName: 'SelectPropertyNew'},
			onBeforeLoad:function(param){
				var desc=param['q'];
				//if (desc=="") return false;
				var ClsName=$("#ClassNameId").val()
				param = $.extend(param,{ClsName:ClsName,Desc:desc});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#ClassPropertyId").val(rowData["propertyName"])
				//ClassPropertyLoad()
				//PropertyLinkNameLoad()
            }
    });
	$("#PropertyLinkName").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:'propertyName',
            textField:'propertyName',
            columns:[[  
                {field:'propertyName',title:'指针索引描述',width:250}
            ]],
			pagination:true,
			panelWidth:300,
			panelHeight:300,
			isCombo:true,
			minQueryLen:0,
			delay:'500',
			queryOnSameQueryString:true,
			queryParams:{ClassName: PageLogicObj.m_ClassName,QueryName: 'SelectPropertyNew'},
			onBeforeLoad:function(param){
				var desc=param['q'];
				//if (desc=="") return false;
				var ClsName=tkMakeServerCall(PageLogicObj.m_ClassName,"PropertyLinkClassNameNew",$("#ClassNameId").val(),$("#ClassPropertyId").val())
				param = $.extend(param,{ClsName:ClsName,Desc:desc});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#PropertyLinkName").val(rowData["propertyName"])
            }
    });
}
function SaveData(RowId){
	if(!CheckData()) return 
	var dataJson={};
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
			}
			DataListLoad()
			clear()
			$("#Win").dialog("close")
		}else if(txtData=="-100"){
			$.messager.alert("提示", "数据保存失败!记录重复!", 'info');
		}else{
			$.messager.alert("提示", "数据保存失败!", 'info');
		}
	});
}
function CheckData(){
	var ClassName=$("#ClassName").lookup("getText");
	if(ClassName==""){
		$.messager.alert("提示", "类名不能为空", 'info');
		return false 
	}
	var ClassProperty=$("#ClassProperty").val()
	if(ClassProperty==""){
		$.messager.alert("提示", "属性名不能为空", 'info');
		return false 
	}
	var ClassNameId=$("#ClassNameId").val()
	if(ClassNameId==""){
		$.messager.alert("提示", "类名不能为空", 'info');
		return false 
	}
	var ClassPropertyId=$("#ClassPropertyId").val()
	if(ClassPropertyId==""){
		$.messager.alert("提示", "属性名不能为空", 'info');
		return false 
	}
	return true
}
function SaveClick(){
	if (PageLogicObj.m_AddFlag==1) {
		SaveData("");
	}else{
		SaveData(PageLogicObj.m_RowId);
	}
}
function DeleteClick(){
	if(PageLogicObj.m_RowId==""){
		$.messager.alert("提示", "请选择要删除的记录", 'info');
		return 
	}
	$m({
		ClassName:PageLogicObj.m_ClassName,
		MethodName:"DeleteUPLSProperty",
		UPLSRowId:PageLogicObj.m_RowId
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
		if(RowId!=""){
			$("#ClassNameId").val($("#ClassName").lookup("getText"));
			$("#ClassPropertyId").val($("#ClassProperty").lookup("getText"));
			$("#ClassName").lookup("disable");
			$("#ClassProperty").lookup("disable");
		}
	});
}
///根据元素的classname获取元素值
function getValue(id){
	if(id=="") return ""
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
	}else if(className.indexOf("lookup-text")>=0){
		$("#"+id).lookup("setText",val)
		$("#"+id+"Id").val(val)
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
	UPLSClassName:"ClassName",
	UPLSClassProperty:"ClassProperty",
	UPLSClassPropertyIndex:"",
	UPLSClassPropertyDescription:"ClassPropertyDesc",
	UPLSClassPropertyLink:"PropertyLinkName"
}