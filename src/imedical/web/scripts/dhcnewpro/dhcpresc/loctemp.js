/// author:    huanghongping
/// date:      2021-07-20
/// descript:  人员信息字典维护

var editRow = ""; editDRow = ""; editPRow = "";
/// 页面初始化函数
function initPageDefault(){
	
	//初始化人员信息管理
	InitMainList();
	
	//初始化人员信息
	InitItemList();
	
	//初始化界面按钮事件
	InitWidListener();
	
	
	
}
//初始化界面按钮事件
function InitWidListener(){
	 $("#ManageSearch").on('click',ManageSearch);
	
	
	}
///初始化字典类型列表
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
	var hhpEditor={
		type: 'combobox',
		options: {
			//data: [{"value":"男","text":'男'}, {"value":"女","text":'女'}, {"value":"未知性别","text":'保密'}, {"value":"未说明性别","text":'下次再填'}],
			url:$URL+"?ClassName=web.DHCINTManageCrud&MethodName=GetSex" ,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",
		}
		
		}
	var ActFlagArr = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
	//设置其为可编辑
	var activeEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			editable: false,
			panelHeight:"auto", //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'PLTFlagCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'PLTFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'RowID',title:'ID',width:50,hidden:true,align:'left'},
		{field:'PLTCode',title:'模板代码',width:130,editor:textEditor,align:'left'},
		{field:'PLTDesc',title:'模板名称',width:170,editor:textEditor,align:'left'},
//		{field:'PLTFlag',title:'是否可用',width:150,editor:{type:'numberbox'},hidden:false,align:'center'},
//		{field:'Sex',title:'性别',width:120,editor:hhpEditor,align:'center'},
//		{field:'Depart',title:'部门',width:180,editor:textEditor,align:'center'},
//		{field:'Address',title:'地址',width:230,editor:textEditor,align:'center'},
//		{field:'DateTime',title:'日期时间',width:160,editor:{type:'datetimebox'},align:'center'},
		{field:'PLTFlagCode',title:'PLTFlagCode',width:80,editor:textEditor,align:'left',hidden:true},		
		{field:'PLTFlag',title:'是否可用',width:80,editor:activeEditor,align:'left'},		
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		rownumbers:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        	        
	        /// 字典项目列表
			$("#item").datagrid('reload',{mID:rowData.RowID});
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCLocTemp&QueryName=GetAllTemplate&SearchStr=";
	new ListComponent('main', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!",'warning');
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PLTCode=="")||(rowsData[i].PLTDesc=="")||(rowsData[i].PLTFlag=="")){
			$.messager.alert("提示","含有未填写项,请填写完整!",'warning'); 
			return false;
	    }
		if(rowsData[i].PLTFlag.trim()=="是"){
		    rowsData[i].PLTFlag="Y"	
		}
		if(rowsData[i].PLTFlag.trim()=="否"){
			rowsData[i].PLTFlag="N"		
		}
		var tmp=rowsData[i].RowID +"^"+ rowsData[i].PLTCode +"^"+ rowsData[i].PLTDesc +"^"+
		 rowsData[i].PLTFlag;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");
	

	//保存数据
	runClassMethod("web.DHCPRESCLocTemp","TemplateSave",{"mParam":mListData},function(jsonString){

		if (jsonString == "-1"){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}
		if (jsonString == "-2"){
			$.messager.alert('提示','名称重复,请核实后再试！','warning');
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
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {RowID:'', PLTCode:'', PLTDesc:'', PLTFlagCode:'Y',PLTFlag:'是'}
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
				runClassMethod("web.DHCPRESCLocTemp","DeleteTemplate",{"ID":rowsData.RowID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#main').datagrid('reload'); //重新加载
					$('#item').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

///初始化字典项目列表
function InitItemList(){
	
	/**
	 * 文本编辑格
	 */
		var CtlocEditor={
		type: 'combobox',
		options: {
			url:$URL+"?ClassName=web.DHCPRESCDicScheme&MethodName=GetAllCTLoc&Hosp="+LgHospID  ,
			valueField: "ctloc",
			textField: "ctloc",
			mode:'remote',
			panelHeight:"300",
		}
		
		}
	
	var disableEditor={
          type:'textbox',
           options:{editable: false}
          
          }
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'mID',title:'模板id',width:100,hidden:true,align:'left'},
		{field:'LocCode',title:'科室代码',width:150,hidden:false,align:'left'},
		{field:'LocName',title:'科室名称',width:220,hidden:false,align:'left',editor:CtlocEditor},
		{field:'ID',title:'id',width:200,hidden:true,align:'left'},
//		{field:'Grade',title:'级别',width:150,editor:numberEditor},

		
		
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		rownumbers:false,
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	     	if ((editDRow != "")||(editDRow == "0")) { 
                $("#item").datagrid('endEdit', editDRow); 
            } 
            $("#item").datagrid('beginEdit', rowIndex); 
            editDRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        	        
	        
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCLocTemp&QueryName=GetAllPLCtLoc&mID=";
	new ListComponent('item', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}
	var rowData = $("#main").datagrid("getSelected");
	
	if(rowData ==null){
		$.messager.alert("提示","请选择科室模板!",'warning');
		return;
	}
	var mID = rowData.RowID;           /// 主项目ID
	var rowsData = $("#item").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!",'warning');
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].LocName==""){
			$.messager.alert("提示","科室不能为空!","warning"); 
			return false;
		}
		var tmp=rowsData[i].LocName+"^"+rowsData[i].id;
		dataList.push(tmp);
	}
//	
	var mListData=dataList.join("$$");
//
//	//保存数据
	runClassMethod("web.DHCPRESCLocTemp","SaveTempCtloc",{mID:mID,mParam:mListData},function(jsonString){
		if (jsonString == "-3"){
			$.messager.alert('提示','科室不能为空！','warning');
			return;	
		}
		
		if (jsonString == "-1"){
			$.messager.alert('提示','科室重复,请核实后再试！','warning');
			return;	
		}
		
		if (jsonString == "-2"){
			$.messager.alert('提示','该科室不存在,请核实后再试！','warning');
			return;	
		}
		$('#item').datagrid('reload'); //重新加载
	})
	
}

/// 插入新行
function insertItmRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择模板!","warning");
		return;
	}
	var ID = rowData.RowID;           /// 主项目ID
	
	
	if(editDRow >= "0"){
		$("#item").datagrid('endEdit', editDRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#item").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#item').datagrid('selectRow',0);
			$("#item").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#item").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {mID:ID, LocCode:'', LocName:'',id:''}
	});
	$("#item").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editDRow=0;
}

/// 删除选中行
function deleteItmRow(){
	
	var rowsData = $("#item").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCPRESCLocTemp","DeleteTempCtloc",{"ID":rowsData.ID},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#item').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
function ManageSearch(){
	var SearchStr=$("#Code").val()
	$("#main").datagrid('load',{SearchStr:SearchStr}); 
	$("#item").datagrid('reload',{mID:""});
	
}

/// JQuery 初始化页面
$(function(){
  

 initPageDefault(); 

 })


	