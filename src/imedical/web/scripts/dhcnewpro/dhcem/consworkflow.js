/// Creator: qqa
/// CreateDate: 2019-12-09
//  Descript: 会诊工作流定义

var editRow=0;itmEditRow=0; itmAutEditRow=0,preEditRow=0; //当前编辑行号
var dataArrayNew = [{"value":"G","text":'安全组'}, {"value":"L","text":'科室'}, {"value":"U","text":'人员'}]; //hxy 2017-12-14
var dataArray = [{"value":"1","text":'安全组'}, {"value":"2","text":'科室'}, {"value":"3","text":'人员'}]; //, {"value":"4","text":'全院'}
var Active = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
//var tabsid="";
$(function(){
	///多院区设置
	MoreHospSetting("DHC_EmConsWorkFlow");
	
	initDatagrid();
	
   	initMethod();
   	
})

///多院区设置
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = findMainTable;
}

function initDatagrid(){
	
	// 编辑格
	var texteditor={
		type: 'validatebox',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	/// 医院
	var hospEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCEMNurExecFormSet&MethodName=GetHospDs",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			},onChange:function(newValue,oldValue){
				if(newValue==""){
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospID'});
					$(ed.target).val(""); 	
				}
			}
	
		}
	}
	
	// 定义columns
	var columns=[[
		{field:"Code",title:'代码',width:150,editor:texteditor},
		{field:'Desc',title:'描述',width:250,editor:texteditor},
		{field:"ID",title:'ID',width:70,align:'center',hidden:true},
		{field:'HospID',title:'HospID',width:100,editor:texteditor,hidden:true,align:'center'},
		{field:'HospDesc',title:'医院',width:200,editor:hospEditor,hidden:true,align:'center'}
	]];
	
	var HospID = $HUI.combogrid("#_HospList").getValue();
	
	var params = "^^"+HospID;
	
	// 定义datagrid
	$('#main').datagrid({
		title:'会诊工作流配置-工作量定义',
		url:$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListMain&Params="+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	$("#main").datagrid('endEdit', editRow); 
			}
            $("#main").datagrid('beginEdit', rowIndex);
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
			
			$('#mainItm').datagrid("load",{"Params":rowData.ID});
			$('#consPre').datagrid("load",{"Params":rowData.ID});
			$('#mainItmAut').datagrid("load",{"Params":""});
        }
	});	
	
	/// 医院
	var statusEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=GetStatusList&HospID="+LgHospID,
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#mainItm").datagrid('getEditor',{index:editRow,field:'Status'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#mainItm").datagrid('getEditor',{index:editRow,field:'StatusDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	// 定义columns  joe
	var columns=[[  
		{field:"Status",title:'状态',width:310,editor:statusEditor},
		{field:"StatusDr",title:'状态',width:110,editor:texteditor,hidden:true},
		{field:'pri',title:'优先级',width:300,hidden:true,
				formatter:function(value,rec,index){
					var a = '<a href="#" mce_href="#" class="img icon-up" onclick="upclick(\''+ index + '\')"></a> ';
					var b = '<a href="#" mce_href="#" class="img icon-down" onclick="downclick(\''+ index + '\')"></a> ';
					return a+b;  
                    }  
		},
		{field:'OrderNo',title:'顺序号',width:130,hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// 定义datagrid
	$('#mainItm').datagrid({
		title:'工作流项目',
		url:$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListMainItm",
		fit:true,
		rownumbers:true,
		columns:columns,
		order:'asc',
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            $("#mainItm").datagrid('beginEdit', rowIndex); 
            itmEditRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
 			$('#mainItmAut').datagrid("load",{"Params":rowData.ID});
	    },
	  onLoadSuccess: function (data) {
	        
        }
	});
	

	//设置其为可编辑
	var editPoint={
		type: 'combobox',     //设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			required:true,
			mode:'remote',  //必须设置这个属性 2017-08-01 cy 修改下拉框模糊检索
			url: '',
			onSelect:function(option){
				var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PointID'});
				$(ed.target).val(option.value);  //设置科室ID
				var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);  //设置科室Desc
			}
		}
	}
	
	// 定义columns joe
	var columnqx=[[
		{field:"ItmDr",title:'ItmDr',width:90,align:'center',hidden:true},
		{field:"ParRefDr",title:'ParRefDr',width:90,align:'center',hidden:true},
		{field:'TypeID',title:'TypeID',width:90,editor:'text',hidden:true},
		{field:"Type",title:'类型',width:110,editor:texteditor,
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					data:dataArrayNew,  //dataArray hxy 2017-12-14
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //设置容器高度自动增长
					required:true,
					onSelect:function(option){
						///设置类型值
						var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'TypeID'});
						$(ed.target).val(option.value);  //设置科室ID
					
						var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Type'});
						$(ed.target).combobox('setValue', option.text);  //设置科室Desc
						
						///设置PointID 
						var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PointID'});
						$(ed.target).val("");
						var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Pointer'});
						var HospID = $HUI.combogrid("#_HospList").getValue();
						var url=$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListPointer&Type="+option.value+"&InHospID="+HospID;
						$(ed.target).combobox('setValue',"");  
						$(ed.target).combobox('reload',url);
					}  
				}
			}
		},
		{field:'Pointer',title:'指向',width:300,editor:editPoint},
		{field:'PointID',title:'PointID',width:130,editor:'text',hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// 定义datagrid
	$('#mainItmAut').datagrid({
		title:'权限设置',
		url:$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListMainItmAut",
		fit:true,
		rownumbers:true,
		columns:columnqx,  //乔庆澳
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((itmAutEditRow != "")||(itmAutEditRow == "0")) {
	            
            	$("#mainItmAut").datagrid('endEdit', itmAutEditRow);
			}
            $("#mainItmAut").datagrid('beginEdit', rowIndex); 
            itmAutEditRow = rowIndex; 
            
            ///设置PointID 
			var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'TypeID'});
			var TypeID = $(ed.target).val();
			var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Pointer'});
			
			var HospID = $HUI.combogrid("#_HospList").getValue();
			var url=$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListPointer&Type="+TypeID+"&InHospID="+HospID;  
			$(ed.target).combobox('reload',url);
        }
	});
	
	
	var funEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCEMConsPreCon&MethodName=GetPreList&HospID="+LgHospID,
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#consPre").datagrid('getEditor',{index:preEditRow,field:'Fun'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#consPre").datagrid('getEditor',{index:preEditRow,field:'FunDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	
	// 定义columns  joe
	var columns=[[  
		{field:"Fun",title:'表达式',width:310,editor:funEditor},
		{field:"FunDr",title:'表达式ID',width:110,editor:texteditor,hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// 定义datagrid
	$('#consPre').datagrid({
		title:'',
		url:$URL+"?ClassName=web.DHCEMConsPreCon&MethodName=QryListPreCon",
		fit:true,
		rownumbers:true,
		columns:columns,
		order:'asc',
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	   		if ((preEditRow != "")||(preEditRow == "0")) {
            	$("#consPre").datagrid('endEdit', preEditRow); 
			}
            $("#consPre").datagrid('beginEdit', rowIndex);
           preEditRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	        
	    },
	  onLoadSuccess: function (data) {
	        
        }
	});
	
}

function initMethod(){
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
   
    $('#mainItmInsert').bind('click',itmInsertRow); 
    $('#mainItmDelet').bind('click',itmDeletRow);
    $('#mainItmSave').bind('click',itmSave);	
    
    //按钮绑定事件
    $('#itmAutInsert').bind('click',itmAutInsertRow); 
    $('#itmAutDelet').bind('click',itmAutDeletRow);
    $('#itmAutSave').bind('click',itmAutSaveRow);
    
    $('#preInsert').bind('click',insertPreRow); 
    $('#preDelet').bind('click',deletePreRow);
    $('#preSave').bind('click',savePreRow);
    
    $("#find").bind('click',findMainTable);
}

// 插入新行
function insertRow()
{	
	if(editRow>0){
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#main").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")||(rows[i].EventType=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}		
	} 
	
	var HospID = $HUI.combogrid("#_HospList").getValue();
	$("#main").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: '',HospID:HospID,HospDesc:HospID}
	});
	
	$("#main").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMConsWorkFlow","delete",{"ID":rowsData.ID},function(jsonString){
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

// 保存编辑行
function saveRow()
{
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rows = $("#main").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}		
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].HospID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//保存数据
	runClassMethod("web.DHCEMConsWorkFlow","save",{"mParam":rowstr},function(jsonString){

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


// 查询
function findEventtype()
{
	//var adrEventType=$('#eventtype').val();
	//lvpeng(改)  2017-12-05 
	var adrEventType=$('#eventtype').combobox('getText')=="全部"?"":$('#eventtype').combobox('getText');  //屈年鹏  2016-07-14
	var params=adrEventType;
	$('#main').datagrid('load',{params:params}); 
}

// 插入新行
function itmInsertRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","请选中左侧主记录！"); 
		return false;
	}
	
	if(itmEditRow>0){
		
		$("#mainItm").datagrid('endEdit', itmEditRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#mainItm").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
	} 
	$("#mainItm").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	
	$("#mainItm").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	itmEditRow=0;
}

// 删除选中行
function itmDeletRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	var mID = rowsData.ID;
	var rowsData = $("#mainItm").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMConsWorkFlow","deleteItm",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#mainItm').datagrid('load',{Params:mID}); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function itmSave()
{
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","请选中左侧主记录！"); 
		return false;
	}
	var mID = rowsData.ID;
	
	if(itmEditRow>=0){
		$("#mainItm").datagrid('endEdit', itmEditRow);
	}
	var rows = $("#mainItm").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(mID==""){
			$.messager.alert("提示","请选择一条主数据!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+mID+"^"+rows[i].StatusDr;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$")
	
	//保存数据
	runClassMethod("web.DHCEMConsWorkFlow","saveItm",{"mParam":rowstr},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','状态重复,请核实后再试！','warning'); //hxy 2020-03-12 原:代码
			return;	
		}/*else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}*/
		$('#mainItm').datagrid('load',{Params:mID}); //重新加载
	})
	
}

// 插入新行
function itmAutInsertRow()
{
	
	if(itmAutEditRow>="0"){
		
		$("#mainItmAut").datagrid('endEdit', itmAutEditRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#mainItmAut").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
	} 
	$("#mainItmAut").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',TypeID:'',PointID: ''}
	});
	$("#mainItmAut").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	itmAutEditRow=0;
}


// 删除选中行
function itmAutDeletRow()
{
	
	var rowsData = $("#mainItm").datagrid('getSelected'); //选中要删除的行
	var mItmID = rowsData.ID;
	var rowsData = $("#mainItmAut").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMConsWorkFlow","deleteItmAut",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#mainItmAut').datagrid('load',{Params:mItmID}); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
	
}

// 保存编辑行
function itmAutSaveRow()
{
	
	var rowsData = $("#mainItm").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","请选中授权项目！"); 
		return false;
	}
	var mItmID = rowsData.ID;
	
	if(itmAutEditRow>="0"){
		$("#mainItmAut").datagrid('endEdit', itmAutEditRow);
	}

	var rows = $("#mainItmAut").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		if(mItmID==""){
			$.messager.alert("提示","请选择需要授权的项目!"); 
			return false;
		}
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		
		var tmp=rows[i].ID+"^"+mItmID+"^"+rows[i].TypeID+"^"+rows[i].PointID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	
	//保存数据
	runClassMethod("web.DHCEMConsWorkFlow","saveAutItm",{"mParam":rowstr},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#mainItmAut').datagrid('load',{Params:mItmID}); //重新加载
	})
	
}

function findMainTable(){
	var mainCode=$("#mainCode").val();
	var mainDesc = $("#mainDesc").val();
	var HospID = $HUI.combogrid("#_HospList").getValue();
	
	var params = mainCode+"^"+mainDesc+"^"+HospID;
	$('#main').datagrid("load",{"Params":params});
	$('#mainItm').datagrid("load",{"Params":""});
	$('#mainItmAut').datagrid("load",{"Params":""});
	$('#consPre').datagrid("load",{"Params":""});
	return;
}




// 插入新行
function insertPreRow()
{	
	if(preEditRow>0){
		$("#consPre").datagrid('endEdit', preEditRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#consPre").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Fun=="")||(rows[i].FunDr=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}		
	} 
	$("#consPre").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		
		index: 0, // 行数从0开始计算
		row: {ID: '',Fun:'',FunDr: ''}
	});
	
	$("#consPre").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	preEditRow=0;
}

// 删除选中行
function deletePreRow()
{
	var rowsData = $("#consPre").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMConsPreCon","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#consPre').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function savePreRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","请选中左侧主记录！"); 
		return false;
	}
	var mID = rowsData.ID;
	
	if(preEditRow>="0"){
		$("#consPre").datagrid('endEdit', preEditRow);
	}
	
	var rows = $("#consPre").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Fun=="")||(rows[i].FunDr=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}		
		var tmp=rows[i].ID+"^"+mID+"^"+rows[i].FunDr;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//保存数据
	runClassMethod("web.DHCEMConsPreCon","save",{"mParam":rowstr},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#consPre').datagrid('reload'); //重新加载
	})
}

var eventwfitmdg;
//上移
function upclick(index)
{
     var newrow=parseInt(index)-1 
	 var curr=$("#mainItm").datagrid('getData').rows[index];
	 var currowid=curr.ID;
	 var currordnum=curr.OrderNo;
	 var up =$("#mainItm").datagrid('getData').rows[newrow];
	 var uprowid=up.ID;
     var upordnum=up.OrderNo;

	 var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
     SaveUp(input);
	 mysort(index, 'up', 'eventwfitmdg');
	
}
//下移
function downclick(index)
{

	 var newrow=parseInt(index)+1 ;
	 var curr=$("#mainItm").datagrid('getData').rows[index];
	 var currowid=curr.ID;
	 var currordnum=curr.OrderNo;
	 var down =$("#mainItm").datagrid('getData').rows[newrow];
	 var downrowid=down.ID;
     var downordnum=down.OrderNo;

	 var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
     SaveUp(input);
	 mysort(index, 'down', 'eventwfitmdg');
}
function SaveUp(input)
{
	 $.post(url+'?action=UpdEventWorkFlowItmNum',{"input":input},function(data){
	});
	 
}
function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}
//检查编辑行是否编辑完全 2018-07-18 cy
function CheckEdit(id,index){
	var flag=0;
	var editors = $('#'+id).datagrid('getEditors', index); 
	for (i=0;i<editors.length;i++){
		if(((editors[i].type=="validatebox")&&(editors[i].target.val()==""))|| ((editors[i].type=="text")&&(editors[i].target.val()==""))||((editors[i].type=="combobox")&&(editors[i].target.combobox('getText')==""))){
			flag=-1;
			return flag;	
		}
	}
	return flag; 
} 
//YN转换是否
function formatLink(value,row,index){
	if (value=='Y'){
		return '是';
	} else {
		return '否';
	}
}


