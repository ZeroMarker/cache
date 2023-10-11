/// author:    bianshuai
/// date:      2018-08-28
/// descript:  科室亚专业/指症关联维护

var editRow = "";
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
/// 页面初始化函数
function initPageDefault(){
	
	
	///多院区设置
	MoreHospSetting("DHC_EmConsLocItm");
	
	//初始化列表
	InitMainList();
	
	//初始化界面按钮事件
	InitWidListener();
}

	///多院区设置
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = ReloadMainTable;
}


function ReloadMainTable(){
	var params="";
	var hospID = $HUI.combogrid("#_HospList").getValue();
	params = hospID;
	
	
	$HUI.datagrid('#main').load({
		Params:params
	})
	return ;
}

/// 界面元素监听事件
function InitWidListener(){
	
}

///初始化列表
function InitMainList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 科室编辑格
	var LocEditor = {
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			mode:'remote',
			enterNullValueClear:false,
			onSelect:function(option) {
				/// 科室ID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'LocID'});
				$(ed.target).val(option.value);

				/// 科室
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
			},onShowPanel:function(){
				var HospID = $HUI.combogrid("#_HospList").getValue();	 /// 院区
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'LocDesc'});
				//var unitUrl = $URL + "?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID;
				var unitUrl = $URL + "?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&HospID="+HospID+"&LType=CONSULT"; //hxy 2020-09-22
				$(ed.target).combobox('reload',unitUrl);
			}	   
		}
	}
	
	// 亚专业编辑格
	var MarEditor = {
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			onSelect:function(option) {
				/// 亚专业ID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MarID'});
				$(ed.target).val(option.value);
				/// 亚专业
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
			},onShowPanel:function(){
				var HospID = $HUI.combogrid("#_HospList").getValue();/// 院区
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MarDesc'});
				var unitUrl = $URL + "?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&HospID="+ HospID +"&mCode=MAR";
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	// 指针编辑格
	var ItmEditor = {
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			onSelect:function(option) {
				/// 指针ID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ItmID'});
				$(ed.target).val(option.value);
				/// 指针
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ItmDesc'});
				$(ed.target).combobox('setValue', option.text);
			},onShowPanel:function(){
				var HospID = $HUI.combogrid("#_HospList").getValue();/// 院区
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ItmDesc'});
				var unitUrl = $URL + "?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&HospID="+ HospID  +"&mCode=IND";
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'left'},
		{field:'LocID',title:'LocID',width:100,editor:textEditor,hidden:true},
		{field:'LocDesc',title:'科室',width:200,editor:LocEditor,align:'left'},
		{field:'MarID',title:'MarID',width:100,editor:textEditor,hidden:true},
		{field:'MarDesc',title:'亚专业',width:200,editor:MarEditor,align:'left'},
		{field:'ItmID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'ItmDesc',title:'指针',width:600,editor:ItmEditor,align:'left'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var HospID = $HUI.combogrid("#_HospList").getValue();
	var params=HospID;
	var uniturl = $URL+"?ClassName=web.DHCEMConsLocItem&MethodName=QryEmConsLocItem&Params="+params;
	new ListComponent('main', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}
	
	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].LocID == ""){
			$.messager.alert("提示","科室不能为空!"); 
			return false;
		}
		if(rowsData[i].MarID == ""){
			$.messager.alert("提示","亚专业不能为空!"); 
			return false;
		}
		if(rowsData[i].ItmID == ""){
			$.messager.alert("提示","指针不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].MarID +"^"+ rowsData[i].ItmID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCEMConsLocItem","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','数据重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','数据重复,请核实后再试！','warning');
			return;
		}
		$('#main').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}

	/// 检查第一行是否为空行
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if ((rowsData[0].LocID == "")||(rowsData[0].MarID=="")||(rowsData[0].ItmID=="")){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			$.messager.alert('提示','请编辑必填数据！','warning');
			return;
		}
	}

	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', ItmID:'', ItmDesc:''}
	});
	$("#main").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMConsLocItem","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#main').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })