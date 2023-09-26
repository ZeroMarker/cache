/// author:    bianshuai
/// date:      2019-02-28
/// descript:  检查申请病理基础字典维护

var editRow = ""; editDRow = ""; editPRow = "";
/// 页面初始化函数
function initPageDefault(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Pisdictype",hospStr);
	hospComp.jdata.options.onSelect  = function(){
		InitMainList();
		InitItemList();
		InitWidListener();
		} 
	//初始化字典类型列表
	InitMainList();
	
	//初始化字典项目列表
	InitItemList();
	
	//初始化界面按钮事件
	InitWidListener();
	
}

/// 界面元素监听事件
function InitWidListener(){
	
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
	var activeActMapEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActMapCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActMapDesc'});
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
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'Code',title:'代码',width:100,editor:textEditor,align:'center'},
		{field:'Desc',title:'描述',width:150,editor:textEditor,align:'center'},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActDesc',title:'启用',width:80,editor:activeEditor,align:'center'},
		{field:'ActMapCode',title:'ActMapCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActMapDesc',title:'启用申请单授权',width:80,editor:activeActMapEditor,align:'center'},
		/*{field:'HospID',title:'HospID',width:100,hidden:true,align:'center'}, //editor:textEditor,
		{field:'HospDesc',title:'医院',width:200,align:'center'} //editor:HospEditor,*/
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
	        var HospID=$HUI.combogrid('#_HospList').getValue();	        
	        /// 字典项目列表
			$("#item").datagrid('reload',{mID:rowData.ID,HospID:HospID});
	    }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = $URL+"?ClassName=web.DHCAPPPisDicType&MethodName=QryPisDicType&HospID="+HospID;
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
	var HospID=2 ///字典类型为公有数据，字典项目为私有
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		/*if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}*/
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ HospID+"^"+ rowsData[i].ActMapCode;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCAPPPisDicType","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
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
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'是', HospID:'', HospDesc:''}
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
				runClassMethod("web.DHCAPPPisDicType","delete",{"ID":rowsData.ID},function(jsonString){
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
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'mID',title:'mID',width:100,hidden:true,align:'center'},
		{field:'Code',title:'代码',width:100,editor:textEditor,align:'center'},
		{field:'Desc',title:'描述',width:500,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActDesc',title:'启用',width:80,editor:activeEditor,align:'center'},
		{field:'HospID',title:'HospID',width:100,hidden:true,align:'center'}, //editor:textEditor,
		{field:'HospDesc',title:'医院',width:200,align:'center'} //editor:HospEditor,
		//{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'center'}
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
	        	        
	    }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = $URL+"?ClassName=web.DHCAPPPisDicItem&MethodName=QryPisDicItem&mID=0&HospID="+HospID;
	new ListComponent('item', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}

	var rowsData = $("#item").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		var HospID=$HUI.combogrid('#_HospList').getValue();
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ HospID +"^"+ rowsData[i].mID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCAPPPisDicItem","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
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
	
	var rowsData = $("#item").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPPisDicItem","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('提示','此项目已使用，不允许删除！','warning');
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
var m_ReBLMapDataGrid
function ConItemRow(){
	var rowsData = $("#item").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示", "请选择一个项目!", 'info');
		return 
	}
	$("#ReBLMap-dialog").dialog("open");
	$.cm({
			ClassName:"web.DHCDocAPPBL",
			QueryName:"FindBLType",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#BLMap", {
				editable:false,
				valueField: 'RowID',
				textField: 'BLTypeDesc', 
				data: GridData["rows"],
				onLoadSuccess:function(){
					$("#BLMap").combobox('select','');
				}
			 });
	});
	m_ReBLMapDataGrid=InitReBLMapDataGrid();
	LoadReBLMapDataGrid();
	}
function InitReBLMapDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {ConItemaddClickHandle();}
    }, {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {ConItemdelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'RowID',hidden:true,title:'RowID'},
		{field:'BLMapID',hidden:true,title:'BLMapID'},
		{field:'BLMapDesc',title:'申请单',width:100},
		{field:'Defalute',title:'是否默认',width:100}
    ]]
	var ReHospitalDataGrid=$("#ReBLMapTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'RowID',
		columns :Columns,
		toolbar:toobar
	}); 
	return ReHospitalDataGrid;
}
function LoadReBLMapDataGrid(){
	var rowsData = $("#item").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示", "请选择一个项目!", 'info');
		return 
	}
	var PisDicItem=rowsData.ID
	$.q({
	    ClassName : "web.DHCAppPisDicRelationBLMap",
	    QueryName : "FindRelationBLMap",
	    PisDicItem:PisDicItem,
	    Pagerows:m_ReBLMapDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		m_ReBLMapDataGrid.datagrid("unselectAll");
		m_ReBLMapDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function ConItemaddClickHandle(){
	var rowsData = $("#item").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示", "请选择一个项目!", 'info');
		return 
	}
	var PisDicItem=rowsData.ID
	var rowsData = $("#main").datagrid('getSelected');
	var PisDicType=rowsData.ID
	var PisBLmap=$("#BLMap").combobox("getValue")
	var PisDefulat="N";
	var ForRequest=$("#BLMapDef").prop("checked");
	if(ForRequest) PisDefulat="Y"
	$.cm({
		ClassName:"web.DHCAppPisDicRelationBLMap",
		MethodName:"InsertRelationBLMap",
		PisDicItem:PisDicItem,
		PisDicType:PisDicType,
		PisBLmap:PisBLmap,
		PisDefulat:PisDefulat,
		dataType:"text",
	},function(data){
		if (data==0) {
			$.messager.popover({msg: '增加成功!',type:'success',timeout: 1000});
			LoadReBLMapDataGrid();
		}else if(data>0) {
			$.messager.alert("提示","增加失败！记录重复!","info");
		}else{
			$.messager.alert("提示","增加失败！"+data,"info");
		}
	})
}
function ConItemdelectClickHandle(){
	var rowsData = m_ReBLMapDataGrid.datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示", "请选择一个项目!", 'info');
		return 
	}
	var RowID=rowsData.RowID
	$.cm({
		ClassName:"web.DHCAppPisDicRelationBLMap",
		MethodName:"DelectRelationBLMap",
		RowID:RowID,
		dataType:"text",
	},function(data){
		$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
		LoadReBLMapDataGrid();
	})
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
