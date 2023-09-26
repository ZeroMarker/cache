/// author:    yangyongtao
/// date:      2019-09-16
/// descript:  预约时段维护

var editRow = ""; editDRow = "";
var ActFlagArr = [{"value":"Y","text":"是"},{"value":"N","text":"否"}];
var ModuleArr = [{"value":"Doc","text":"医生班次"},{"value":"Nur","text":"护士班次"}];  /// ,{"value":"Inf","text":"输液预约"}

$(function(){
	///多院区设置
	MoreHospSetting("DHC_EmTimeInterval");

	/// 初始化界面默认信息
	InitDefault();
	
	/// 初始化查询信息列表
	InitDetList();
	
	/// 初始化界面按钮事件
	InitWidListener();
})

///多院区设置
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = ReloadMainTable;
}

/// 初始化界面默认信息
function InitDefault(){

}

/// 界面元素监听事件
function InitWidListener(){

	$('div#tb a:contains("新增")').bind("click",insertRow);
	$('div#tb a:contains("删除")').bind("click",deleteRow);
	$('div#tb a:contains("保存")').bind("click",saveRow);
	
}

/// 初始化查询信息列表
function InitDetList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor = {
		type:'text',		//设置编辑格式
		options:{
			required:true	//设置编辑规则属性
		}
	}
	
	/**
	 * 时间编辑格
	 */
	var sttimeEditor = {	//设置其为可编辑
		type:'combobox',	//设置编辑格式
		options:{
			valueField:'value',
			textField:'text',
			mode:'remote',
			url:$URL +"?ClassName=web.DHCEMTimeInterval&MethodName=jsonTimes",
			required:true,
			editable:false,
			//panelHeight:'auto',  //设置容器高度自动增长
			onSelect:function(option){
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'StartTime'});
				$(ed.target).val(option.value);					//设置value
			} 	
		}
	}
	
	var endtimeEditor = {	//设置其为可编辑
		type:'combobox',	//设置编辑格式
		options:{
			valueField:'value',
			textField:'text',
			mode:'remote',
			url:$URL +"?ClassName=web.DHCEMTimeInterval&MethodName=jsonTimes",
			required:true,
			editable:false,
			//panelHeight:'auto',  //设置容器高度自动增长
			onSelect:function(option){
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'EndTime'});
				$(ed.target).val(option.value);					//设置value
			}
		}
	}
	
	/**
	 * combobox编辑格
	 */
	var activeEditor = {
		type:'combobox',	//设置编辑格式
		options:{
			data:ActFlagArr,
			valueField:'value',
			textField:'text',
			panelHeight:'auto',		//设置容器高度自动增长
			onSelect:function(option){
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);					//设置value
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'ActDesc'});
				$(ed.target).combobox('setValue',option.text);	//设置Desc
			}
		}
	}
	
	var HospEditor = {		//设置其为可编辑
		/// 类别
		type:'combobox',	//设置编辑格式
		options:{
			valueField:'value',
			textField:'text',
			url:$URL +"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:'auto',  //设置容器高度自动增长
			onSelect:function(option){
				/// 设置类型值
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value);
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue',option.text);
			} 	
		}
	}
		
	/**
	 * combobox编辑格
	 */
	var ModuleEditor = {
		type:'combobox',	//设置编辑格式
		options:{
			data:ModuleArr,
			valueField:'value',
			textField:'text',
			panelHeight:'auto',		//设置容器高度自动增长
			onSelect:function(option){
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'ModuleID'});
				$(ed.target).val(option.value);					//设置value
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'Module'});
				$(ed.target).combobox('setValue',option.text);	//设置Desc
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns = [[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'代码',width:100,editor:textEditor},
		{field:'Desc',title:'描述',width:200,editor:textEditor},
		{field:'StartTime',title:'开始时间',width:150,editor:sttimeEditor},
		{field:'EndTime',title:'结束时间',width:150,editor:endtimeEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'是否可用',width:100,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'HospDesc',title:'医院',width:300,editor:HospEditor,hidden:true},
		{field:'ModuleID',title:'ModuleID',width:100,editor:textEditor,hidden:true},
		{field:'Module',title:'模块',width:120,editor:ModuleEditor}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		//title:'预约资源维护',
		//nowrap:false,
		singleSelect:true,
	    onDblClickRow:function(rowIndex, rowData){	//双击选择行编辑
            if ((editRow != "")||(editRow == "0")){
                $('#dgMainList').datagrid('endEdit',editRow);
            }
            $('#dgMainList').datagrid('beginEdit',rowIndex);
            editRow = rowIndex;
        }
	};
	var params="";
	var hospID = $HUI.combogrid("#_HospList").getValue();
	params = hospID;
	var uniturl = $URL +"?ClassName=web.DHCEMTimeInterval&MethodName=QryEmTimeInterval&Params="+params;
	var dgMainListComponent = new ListComponent('dgMainList',columns,uniturl,option);
	dgMainListComponent.Init();
	
}

/// 保存编辑行
function saveRow(){
	
	if (editRow >= "0"){
		$('#dgMainList').datagrid('endEdit',editRow);
	}

	var rowsData = $('#dgMainList').datagrid('getChanges');
	if (rowsData.length <= 0){
		$.messager.alert("提示","没有待保存数据！","warning");
		return;
	}
	var dataList = [];
	for (var i = 0;i < rowsData.length;i ++){
		
		if ((rowsData[i].Code == "")||(rowsData[i].Desc == "")){
			$.messager.alert("提示","代码或描述不能为空！","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		if ((rowsData[i].StartTime == "")||(rowsData[i].EndTime == "")){
			$.messager.alert("提示","开始时间或结束时间不能为空！","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		if (rowsData[i].HospID == ""){
			$.messager.alert("提示","医院不能为空！","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		if (rowsData[i].StartTime >= rowsData[i].EndTime){
			$.messager.alert("提示","开始时间不能大于或等于结束时间！","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		if (rowsData[i].ModuleID == ""){
			$.messager.alert("提示","模块不能为空！","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		
		var tmp = rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].StartTime;
		tmp = tmp +"^"+ rowsData[i].EndTime +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +"^"+ rowsData[i].ModuleID;
		dataList.push(tmp);
	}
	
	var params = dataList.join("$$");

	/// 保存数据
	runClassMethod("web.DHCEMTimeInterval","save",{"mParam":params},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert("提示","代码重复，请核实后再试！","warning");
		}
		else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert("提示","描述重复，请核实后再试！","warning");
		}
		else if (jsonString == "-5"){
			$.messager.alert("提示","时间段有重复，请核实后再试！","warning");
		}
		else if (jsonString == "0"){
			$.messager.alert("提示","保存成功！","info");
			$('#dgMainList').datagrid('reload');	//重新加载
		}
		else{
			$.messager.alert("提示","保存失败，失败原因："+jsonString,"error");
		}
	})
}

/// 插入新行
function insertRow(){
	
	if (editRow >= "0"){
		$('#dgMainList').datagrid('endEdit',editRow);	//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $('#dgMainList').datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);	//开启编辑并传入要编辑的行
			return;
		}
	}
	var hospID = $HUI.combogrid("#_HospList").getValue();
	
	$('#dgMainList').datagrid('insertRow',{
		index:0,	//行数从0开始计算
		row:{ID:"",Code:"",Desc:"",ActCode:"Y",ActDesc:"是",HospID:hospID,HospDesc:hospID}
	});
	$('#dgMainList').datagrid('beginEdit',0);			//开启编辑并传入要编辑的行
	editRow = 0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $('#dgMainList').datagrid('getSelected');	//选中要删除的行
	if (rowsData == null){
		$.messager.alert("提示","请选择要删除的项！","warning");
		return;
	}
	if(rowsData.ID==""){
		$('#dgMainList').datagrid('deleteRow',0);
		return;
	}
	
	$.messager.confirm("提示","您确定要删除这些数据吗？",function(res){		//提示是否删除
		if (res){
			runClassMethod("web.DHCEMTimeInterval","delete",{"ID":rowsData.ID},function(jsonString){
				if (jsonString == 0){
					$.messager.alert("提示","删除成功！","info");
					$('#dgMainList').datagrid('reload'); 		//重新加载
				}
				else{
					$.messager.alert("提示","删除失败，失败原因："+ jsonString,"error");
				}
			})
		}
	});
}

function ReloadMainTable(){
	var params="";
	var hospID = $HUI.combogrid("#_HospList").getValue();
	params = hospID;
	
	
	$HUI.datagrid('#dgMainList').load({
		Params:params
	})
	return ;
}