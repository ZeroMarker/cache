
/// date:      2021-09-01
/// descript:  审核状态字典维护

var editRow = ""; editDRow = ""; editPRow = "",hospData=[];
var hosp="";
/// 页面初始化函数
function initPageDefault(){
	
	// 初始化医院
	init();
	
	///初始化弹出界面下拉框列表
	InitCombobox()
	
	//初始化字典类型列表
	InitMainList();
	
	//初始化字典项目列表
	InitItemList();
	
	//初始化界面按钮事件
	InitWidListener();
	
	///初始化字典属性列表
	InitDetailList();
	
	///初始化树形配置
	InitTreeList();
}

/// 界面元素监听事件
function InitWidListener(){
	$('#queryBTN').on("click",function(){
		$("#main").datagrid('reload',{params:hosp});
		$('#item').datagrid('reload',{mID:0});
		$("#detail").datagrid('reload',{mID:0});
	});
	$('#tab').tabs({ //hxy 2021-03-22 tab点击刷新数据    
		 onSelect:function(title){    
		 		$('#item').datagrid('reload'); //重新加载
		 		$('#detail').datagrid('loadData', { total: 0, rows: [] }); //重新加载
				$("#tree").treegrid('reload'); //重新加载
		    }    
		}); 
	
}

function init(){
	runClassMethod("web.DHCEMConsultCom","JsonHosp",{},function(data){
		hospData=data;
		$("#_HospList").combobox({
			data:hospData,
			valueField:'value',
			textField:'text',
			onSelect:function(option){
				hosp = option.value
				$("#main").datagrid('reload',{params:hosp});
				$('#item').datagrid('reload',{mID:0});
				$("#detail").datagrid('reload',{mID:0});
			},
		})
		$("#_HospList").combobox("select",hospData[0].value);
		$("#HospArr").combobox({
			data: hospData, //HospArrN
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长	
		})
	});
}

///初始化弹出界面下拉框列表
function InitCombobox(){
	var ActFlagArr = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
	
	$("#Active").combobox({
		data: ActFlagArr,
		valueField: "value",
		textField: "text",
		panelHeight:"auto",  //设置容器高度自动增长	
	})
	
	$("#ParList").combobox({
		//url:$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=QryEmConsItemArray",
		valueField: "value",
		textField: "text",
		panelHeight:200,  //设置容器高度自动增长	
	})

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
	
	var ActFlagArr = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
	//设置其为可编辑
	var activeEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	/// 医院
	var HospEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'代码',width:300,editor:textEditor},
		{field:'Desc',title:'描述',width:300,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'启用',width:148,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'HospDesc',title:'医院',width:200,editor:HospEditor,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'字典类型',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){        
	        /// 字典项目列表
			$("#item").datagrid('reload',{mID:rowData.ID});
			/// 字典项目树列表
			$("#tree").treegrid('reload',{mID:rowData.ID});
			///字典属性列表
			$("#detail").datagrid('reload',{mID:0});
	    }
	};
	var uniturl = "dhcapp.broker.csp?ClassName=web.DHCPRESCDicType&MethodName=QryPrescDicType";
	new ListComponent('main', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!",'info');
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!",'info'); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!",'info'); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCPRESCDicType","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#main').datagrid('reload'); //重新加载
		$('#item').datagrid('reload'); //重新加载
		$("#tree").treegrid('reload');
		
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
	
	var HospDr=$("#_HospList").combobox("getValue")
	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'是', HospID:HospDr, HospDesc:''}
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
				runClassMethod("web.DHCPRESCDicType","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#main').datagrid('reload'); //重新加载
					$()
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
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
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
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'ActCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'ActDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'mID',title:'mID',width:100,hidden:true},
		{field:'Code',title:'代码',width:300,editor:textEditor},
		{field:'Desc',title:'描述',width:300,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'启用',width:216,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'字典项目',
		//nowrap:false,
		headerCls:'panel-header-gray',
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
	        console.log(rowData.ID);
	        var mID = rowData.ID;    
	        /// 字典项目属性列表
			$("#detail").datagrid('reload',{mID:mID});
	    }
	};
	
	var uniturl = "dhcapp.broker.csp?ClassName=web.DHCPrescDicItem&MethodName=QryPrescDicItem";
	new ListComponent('item', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}

	var rowsData = $("#item").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!",'info');
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!",'info'); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +"^"+ rowsData[i].mID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCPrescDicItem","save",{"mParam":mListData},function(jsonString){

		if (jsonString == "0"){
			$.messager.alert('提示','保存成功！','success');
				
		}else if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#item').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertItmRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择字典类型!");
		return;
	}
	var ID = rowData.ID;           /// 主项目ID
	var HospID = rowData.HospID;   /// 医院ID
	
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
		row: {mID:ID, ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'是', HospID:HospID}
	});
	$("#item").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editDRow=0;
}

/// 删除选中行
function deleteItmRow(){
	var  titleStr="该节点不含有子节点，确定删除吗？"
	var rowsData = $("#item").datagrid('getSelected'); //选中要删除的行
	var children=$("#tree").treegrid("getChildren",rowsData.ID);
	if(children.length>0){
		titleStr="该节点含有子节点，会一并删除，确定删除吗？"
		}
	IDStr=rowsData.ID;
	for(i=0;i<children.length;i++){
         IDStr=IDStr+"^"+children[i].ID
        }
	if (rowsData != null) {
		$.messager.confirm("提示", titleStr, function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCPrescDicItem","treeDelete",{"IDStr":IDStr},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('提示','包含已使用项目，不允许删除！','warning');
					}else if (jsonString < 0){
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

///初始化属性列表
function InitDetailList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
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
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'ActCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'ActDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'mID',title:'mID',width:100,hidden:true},
		{field:'Code',title:'代码',width:300,editor:textEditor},
		{field:'Desc',title:'名称',width:300,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'启用',width:216,editor:activeEditor}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'字典属性',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editPRow != "")||(editPRow == "0")) { 
                $("#detail").datagrid('endEdit', editPRow); 
            } 
            $("#detail").datagrid('beginEdit', rowIndex); 
            editPRow = rowIndex;
        }
	};
	
	var uniturl = "dhcapp.broker.csp?ClassName=web.DHCPrescDicItemProp&MethodName=QryPrescDicItemProp";
	new ListComponent('detail', columns, uniturl, option).Init();
}

/// 保存编辑行
function saveDetRow(){
	
	if(editPRow>="0"){
		$("#detail").datagrid('endEdit', editPRow);
	}

	var rowsData = $("#detail").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!",'info');
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!",'info'); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].mID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");
	console.log(mListData);
	//保存数据
	runClassMethod("web.DHCPrescDicItemProp","save",{"mParam":mListData},function(jsonString){

		if (jsonString == "0"){
			$.messager.alert('提示','保存成功！','success');
			
		}else if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#detail').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertDetRow(){
	
	var rowData = $("#item").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择字典项目!",'info');
		return;
	}
	var ID = rowData.ID;           /// 主项目ID
	
	if(editPRow >= "0"){
		$("#detail").datagrid('endEdit', editPRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#detail").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#detail').datagrid('selectRow',0);
			$("#detail").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#detail").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {mID:ID, ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'是'}
	});
	$("#detail").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editPRow=0;
}

/// 删除选中行
function deleteDetRow(){
	
	var rowsData = $("#detail").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCPrescDicItemProp","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#detail').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}



function InitTreeList(){
		/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:70,hidden:true},
		{field:'Code',title:'代码',width:300},
		{field:'Desc',title:'描述',width:300},
		{field:'ActDesc',title:'启用',width:216}
	]];
	var uniturl = $URL+"?ClassName=web.DHCPrescDicItem&MethodName=QryPrescDicItem&mID=0&IsTreeGrid=1";
	//var uniturl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=QryEmConsItem&mID=0&IsTreeGrid=1";
	$('#tree').treegrid({
		url:uniturl,
		idField:'ID',
		treeField:'Code',
		fit:true,
		border:false,
		columns:columns,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            
        },
        onClickRow:function(rowIndex, rowData){       
	       
	    }
	});
}
//保存
function treeItmSave(){
	
	var rowData = $("#main").treegrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择字典类型!",'info');
		return;
	}
	var mID = rowData.ID;           /// 主项目ID
	var HospID = rowData.HospID;   /// 医院ID
	var ID = $("#tID").val();
	var Code = $("#Code").val();
	var Desc = $("#Desc").val();
	var ParID = $("#ParList").combobox("getValue");
	var flag=$("#flag").val();
	if(ParID==0){
		ParID="";
	}
	var ActCode = $("#Active").combobox("getValue");
	if(ActCode==undefined){
		ActCode="";
	}
	if((Code=="")||(Desc=="")){
		$.messager.alert("提示","代码或描述不能为空!",'info'); 
		return false;
	}
	if(flag==1){
		ID=""
		}
	
	var mListData=ID +"^"+ Code +"^"+ Desc +"^"+ ActCode +"^"+ HospID +"^"+ mID +"^"+ ParID;

	//保存数据
	runClassMethod("web.DHCPrescDicItem","treeItmSave",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		
		
		$("#treeOpPanel").window('close');
		$("#tree").treegrid('reload',{mID:mID});
	})
}

/// 插入新行
function insertTreeRow(){
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择字典类型!",'info');
		return;
	}
	
	var mID = rowData.ID;           /// 字典类型ID
	//var HospID = rowData.HospID;   /// 医院ID
	var tID="";
	var treeRowData = $("#tree").treegrid("getSelected");
	if (treeRowData != null) {
		tID = treeRowData.ID;
	}
//	var ret=serverCall("web.DHCEMConsDicItem","isExOrEqual",{'tID':tID,'mID':mID}); //hxy 2020-08-13 st
//	if(ret=="-1"){
//		tID="";
//	}//ed
//	$("#tID").val("");
	loadTreePanelData(mID,tID,"","","",1);  ///弹出面板加载数据
	
	$("#treeOpPanel").window({
		title:"根节点增加",
	}).window('open');
	
	
}

/// 删除选中行
function deleteTreeRow(){
	var IDStr=""
	var titleStr="该节点不含有子节点，您确定要删除该节点吗？"
	var rowsData = $("#tree").treegrid('getSelected'); //选中要删除的行
	var children=$("#tree").treegrid("getChildren",rowsData.ID);
	if(children.length>0){
		titleStr="该节点含有子节点，会一并删除，确定删除吗？"
		}
	IDStr=rowsData.ID;
	for(i=0;i<children.length;i++){
         IDStr=IDStr+"^"+children[i].ID
        }
    
	if (rowsData != null) {
		$.messager.confirm("提示", titleStr, function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCPrescDicItem","treeDelete",{"IDStr":IDStr},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('提示','包含已使用项目，不允许删除！','warning');
					}else if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}else if (jsonString==0){ //hxy 2021-03-22
						$.messager.alert('提示','删除成功！','success');
					}
					$("#tree").treegrid('reload');
					$('#item').datagrid('reload'); //重新加载 hxy 2021-03-22 add st
					$('#detail').datagrid('reload'); //重新加载 ed
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
///修改选中节点
function updTreeRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择字典类型!",'info');
		return;
	}
	var treeRowData = $("#tree").treegrid("getSelected");
	if (treeRowData == null) {
		$.messager.alert("提示","请先选择一条数据!",'info');
		return;
	}

	var mID = rowData.ID;           /// 主项目ID
	var tID = treeRowData.ID;
	var HospID = rowData.HospID;   /// 医院ID
	var Code = treeRowData.Code;
	var Desc = treeRowData.Desc;
	var ParID = treeRowData._parentId;
	var ActCode=treeRowData.ActCode //hxy 2020-08-12
//	var ret=serverCall("web.DHCEMConsDicItem","isExCsID",{'tID':tID}); //hxy 2020-08-12 st
//	if(ret=="-1"){
//		$.messager.alert("提示","请先选择一条数据!");
//		return;
//	}//ed
	
	$("#tID").val(tID);
	
	loadTreePanelData(mID,ParID,Code,Desc,ActCode,"");  ///增加面板增加数据 //hxy 2020-08-12 add ActCode   
	
	$("#treeOpPanel").window({
		title:"修改",
	}).window('open');
	
}
///弹出面板加载数据
function loadTreePanelData(mID,tID,code,desc,ActCode,flag){
	$("#Code").val(code);
	$("#Desc").val(desc);
	$("#flag").val(flag);  //增加标志位，判断增加还是修改
	var url = $URL+"?ClassName=web.DHCPrescDicItem&MethodName=QryPrescDicItemArray&mID="+mID;
	$("#ParList").combobox("reload",url);
	$("#ParList").combobox("setValue",tID);
	$("#Active").combobox("setValue",ActCode); //"Y" //hxy 2020-08-12 change ActCode
	if(code==""){ //hxy 2020-08-13 新增默认Y
		$("#Active").combobox("setValue","Y")
	}
	
	$("#tree").treegrid('reload',{mID:mID});
}
/// 复制 2021-06-25
function copyRow(){
	var rowsData = $("#main").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert("提示","请选择字典类型!",'info');
		return;	
	}
	$('#copyWin').dialog("open");
}

/// 保存复制 2021-06-25
function saveCopy(){
	var rowsData = $("#main").datagrid('getSelected');
	var HospDr=$HUI.combobox("#HospArr").getValue();
	if((HospDr=="")||(HospDr==undefined)){
		$.messager.alert("提示","请选择医院!",'info');
		return;	
	}
	runClassMethod("web.DHCPrescDicItem","SaveCopy",{"ID":rowsData.ID,"Code":rowsData.Code,"Hosp":HospDr},function(jsonString){
		if (jsonString == -1){
			$.messager.alert('提示','此字典类型已有，无需复制！','warning');
		}else if (jsonString < 0){
			$.messager.alert('提示','复制失败！','warning');
		}else if (jsonString==0){ 
			$.messager.alert('提示','复制成功！','success');
			$('#copyWin').dialog("close");
		}
	})
	
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
