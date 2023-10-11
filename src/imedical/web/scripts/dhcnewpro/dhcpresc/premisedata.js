/// Creator:yuliping
/// CreateDate: 2022-06-09
//  Descript: 审方前置条件

var editRow=0;itmEditRow=0; itmAutEditRow=0,preEditRow=0, editDRow=-1; //当前编辑行号
var Active = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
var patTypeArray = [{"value":"O","text":'门诊'}, {"value":"E","text":'急诊'}, {"value":"I","text":'住院 '}]; //  2021-01-21
var TypeLimit ="Constant"

//var tabsid="";
var valueEditor={}
$(function(){
	
	initDatagrid();
	
   	initMethod();
   	
})


function initDatagrid(){
	$("#HospList").combobox({
		url:$URL+"?ClassName=web.DHCPRESCPremiseName&MethodName=GetHospDs",
		})
	// 编辑格
	var texteditor={
		type: 'text'//设置编辑格式
	}
	
	/// 医院
	var hospEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			required: true,
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCPRESCPremiseName&MethodName=GetHospDs",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hosp'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospId'});
				$(ed.target).val(option.value); 
			},onChange:function(newValue,oldValue){
				if(newValue==""){
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospId'});
					$(ed.target).val(""); 	
				}
			}
	
		}
	}
		/// 医院
	var moduleEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			required: true,
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCPRESCPremiseName&MethodName=ListCaseData",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'module'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'moduleId'});
				$(ed.target).val(option.value); 
			}
	
		}
	}
	var activeEditor = {
			type: 'combobox',//设置编辑格式
			options: {
			required: true,
			valueField: "value", 
			textField: "text",
			data:Active
			}
		}
	// 定义columns
	var columns=[[
		{field:"code",title:'名称',width:150,editor:{type:'validatebox',options:{required:true}}},
		{field:'hospId',title:'HospID',width:100,editor:texteditor,hidden:true,align:'center'},
		{field:'hosp',title:'医院',width:230,editor:hospEditor},
		{field:'module',title:'模块',width:100,editor:moduleEditor},
		{field:'moduleId',title:'模块',width:200,hidden:true,editor:texteditor},
		{field:'active',title:'是否可用',width:100,editor:activeEditor,formatter:getActive},
		{field:"Id",title:'Id',width:70,align:'center',hidden:true},

	]];
	
	var HospID = $HUI.combogrid("#HospList").getValue();
	
	var params = "^"+HospID;
	function getActive(value)
	{
			if(value=="Y")
			{
				return "是"	
			}else if(value=="N")
			{
				return "否"		
			}
	}
	
	// 定义datagrid
	$('#main').datagrid({
		title:'前提名称定义',
		url:$URL+"?ClassName=web.DHCPRESCPremiseName&MethodName=ListData&Params="+params,
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
			$('#mainItm').datagrid("load",{"ID":rowData.Id});
			$('#mainItmAut').datagrid("load",{"ID":""});
        }
	});	
	/// 字典
	var statusEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			required: true,
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCPRESCPremiseDic&MethodName=ListDataCombox",
			//required:true,
			panelHeight:350,  //设置容器高度自动增长 //  2020-08-11 "auto"->350
			onSelect:function(option){
				///设置类型值
				var ed=$("#mainItm").datagrid('getEditor',{index:editRow,field:'Dic'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#mainItm").datagrid('getEditor',{index:editRow,field:'DicDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	var OpEditor={
		type: 'combobox',//设置编辑格式
		options: {
			required: true,
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":'等于'}, {"value":"N","text":'不等于'}]
		}
		}
	// 定义columns  joe
	var columns=[[  
		{field:"NameDr",title:'名称指针',width:30,editor:texteditor,hidden:true},
		{field:"Dic",title:'字典',width:260,editor:statusEditor},
		{field:"DicDr",title:'字典ID',width:100,editor:texteditor,hidden:true},
		{field:"PPNOp",title:'运算符',width:260,editor:OpEditor,
				formatter:function(value,rec,index){
					if(value=="Y"){
						return "等于";
					}else if(value=="N"){
						return "不等于";
					}else{
						return "";
						}
                    }  
		},
		{field:"type",title:'type',width:30,editor:texteditor,hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',editor:texteditor,hidden:true}
	]];
	
	// 定义datagrid
	$('#mainItm').datagrid({
		title:'前提定义',
		url:$URL+"?ClassName=web.DHCPRESCPremiseNode&MethodName=ListData",
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
 			$('#mainItmAut').datagrid("load",{"ID":rowData.ID});
 			runClassMethod("web.DHCPRESCPremiseDic","getUrl",{"Id":rowData.DicDr},function(ret){
	 			setEditor(ret)
	 			},"text")
 			
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
			mode:'remote',  
			url: '',
			onSelect:function(option){
				var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PointID'});
				$(ed.target).val(option.value);  //设置科室ID
				var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);  //设置科室Desc
			}
		}
	}
	
	// 定义columns 
	var columnqx=[[
		{field:"PPDNodeDr",title:'PPDNodeDr',width:90,hidden:true},
		{field:"PPDValue",title:'描述/指针（开始日期）',width:120,editor:valueEditor},
		{field:'PPDNameDr',title:'PPDNameDr',width:90,editor:'text',hidden:true},
		{field:"PPDName",title:'名称',width:110,hidden:true},
		{field:'PPDLimit',title:'结束范围',width:120,editor:texteditor},
		{field:'PPDStTime',title:'开始时间',width:100,editor:texteditor},
		{field:'PPDEdTime',title:'结束时间',width:100,editor:texteditor},
		{field:'PPDType',title:'类型',width:90,editor:'text'},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// 定义datagrid
	$('#mainItmAut').datagrid({
		title:'权限设置',
		url:$URL+"?ClassName=web.DHCPRESCPremiseData&MethodName=ListData",
		fit:true,
		rownumbers:true,
		columns:columnqx,  //
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            $("#mainItmAut").datagrid('beginEdit', rowIndex); 
            itmAutEditRow = rowIndex; 
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
    
    $('#itmAutInsert').bind('click',itmAutInsertRow); 
    $('#itmAutDelet').bind('click',itmAutDeletRow);
    $('#itmAutSave').bind('click',itmAutSaveRow);
    
    $('#find').bind('click',queryMain);
    
    $('#mainCode').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            queryMain(); //调用查询
        }
    });
    
}

//前提字典表取维护的下拉数据
function setEditor(url){
	
	var mainData = $("#main").datagrid("getSelected");
	var hospId = mainData.hospId;
	// 编辑格
	var texteditor={
		type: 'text'//设置编辑格式
	}
		
	var dateEditor={
		type: 'datebox'//设置编辑格式
		
	}
	var timeEditor={
		type: 'timespinner'//设置编辑格式
		}
	if(url=="Time"){
		TypeLimit="TimeInputLimit"
		var valueEditor=dateEditor;			//开始日期
		var endLimitEditor = dateEditor; //结束范围 结束日期
	}else{
		TypeLimit ="Constant"
		var endLimitEditor =texteditor;
		var valueEditor={
			type: 'combobox',     //设置编辑格式
			options: {
				valueField: "value",
				textField: "text",
				required:true,
				url:$URL+"?ClassName="+url+"&hospId="+hospId,
				mode:'remote',  
					onSelect:function(option){
					var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PPDValue'});
					$(ed.target).val(option.text);  //设置科室ID
					var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PPDValueId'});
					$(ed.target).val(option.value);  //设置科室ID
				}

			}
		}
	}

		var columnqx=[[
		{field:"PPDNodeDr",title:'PPDNodeDr',width:90,hidden:true},
		{field:"PPDValueId",title:'PPDValueId',width:90,hidden:true,editor:texteditor},
		{field:"PPDValue",title:'描述/指针（开始日期）',width:160,editor:valueEditor},
		{field:'PPDNameDr',title:'PPDNameDr',width:90,editor:'text',hidden:true},
		{field:"PPDName",title:'名称',width:100,hidden:true},
		{field:'PPDLimit',title:'结束范围',width:120,editor:texteditor},
		{field:'PPDStTime',title:'开始时间',width:100,editor:timeEditor},
		{field:'PPDEdTime',title:'结束时间',width:100,editor:timeEditor},
		{field:'PPDType',title:'类型',width:80,editor:'text'},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// 定义datagrid
	$('#mainItmAut').datagrid({
		columns:columnqx,  
	})
}
// 插入新行
function insertRow()
{	
	if(editRow>=0){ //  2020-08-11 =
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#main").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")||(rows[i].EventType=="")){
			$.messager.alert("提示","有必填项未填写，请核实!",'info'); 
			return false;
		}		
	} 
	
	var HospID = $HUI.combogrid("#HospList").getValue();
	$("#main").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		
		index: 0, // 行数从0开始计算
		row: {Id: '',code:'',hospId:LgHospID,hosp:LgHospID,module:'',moduleId:''}
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
				runClassMethod("web.DHCPRESCPremiseName","delete",{"ID":rowsData.Id},function(jsonString){
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
///查询前提条件名称
function queryMain()
{
	var mainCode = $('#mainCode').val();
	var hospId = $('#HospList').combobox('getValue');
	var params=mainCode+"^"+hospId;
	$('#main').datagrid('load',{Params:params});
	
}
// 保存编辑行
function saveRow()
{	
	if(editRow>=0){ 
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
		
	}
	var rows = $("#main").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!",'warning');
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].code=="")){
			$.messager.alert("提示","有必填项未填写，请核实!",'warning'); 
			return false;
		}		
		var tmp=rows[i].code+"^"+rows[i].hospId+"^"+rows[i].moduleId+"^"+rows[i].active+"^"+rows[i].Id;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//保存数据
	runClassMethod("web.DHCPRESCPremiseName","save",{"params":rowstr},function(jsonString){

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

// 插入新行
function itmInsertRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","请选中左侧主记录！",'warning'); 
		return false;
	}
	if(itmEditRow>=0){ //  2020-08-11 =
		$("#mainItm").datagrid('endEdit', itmEditRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#mainItm").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Name=="")){
			$.messager.alert("提示","有必填项未填写，请核实!",'warning'); 
			return false;
		}
	} 
	$("#mainItm").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Dic:'',PPNOp:''}
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
				runClassMethod("web.DHCPRESCPremiseNode","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}else{
						$.messager.alert('提示','删除成功！','success');
					}

					$('#mainItm').datagrid('reload'); //重新加载
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
		$.messager.alert("提示","请选中左侧主记录！",'warning'); 
		return false;
	}
	var mID = rowsData.Id;
	if((itmEditRow!=="")&&(itmEditRow>=0)){
		$("#mainItm").datagrid('endEdit', itmEditRow);
	}
	var rows = $("#mainItm").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!",'warning');
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(mID==""){
			$.messager.alert("提示","请选择一条主数据!",'warning'); 
			return false;
		}
		
		if((rows[i].DicDr=="")||(rows[i].PPNOp=="")){
			$.messager.alert("提示","有必填项未填写，请核实!！",'warning'); 
			return false;
		}
		
		var tmp=mID+"^"+rows[i].DicDr+"^"+rows[i].PPNOp+"^"+rows[i].ID ; //  2020-08-05 rows[i].Status
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$")
	
	//保存数据
	runClassMethod("web.DHCPRESCPremiseNode","save",{"params":rowstr},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','该前提重复，请重新录入！','warning'); 
			return;	
		}else{
			$.messager.alert('提示',"保存成功",'success')
			}/*else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}*/
		$('#mainItm').datagrid('load',{"ID":mID}); //重新加载
	})
	
}

// 插入新行
function itmAutInsertRow()
{
	var rowsData = $("#mainItm").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示","请先选择前提！",'warning'); 
		return false;
	}
	
	if(itmAutEditRow>="0"){
		
		$("#mainItmAut").datagrid('endEdit', itmAutEditRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#mainItmAut").datagrid('getChanges');
	/*for(var i=0;i<rows.length;i++)
	{
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("提示","有必填项未填写，请核实!",'warning'); 
			return false;
		}
	} */
	$("#mainItmAut").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',PPDValue:'',PPDType:TypeLimit}
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
				runClassMethod("web.DHCPRESCPremiseData","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#mainItmAut').datagrid('load',{ID:mItmID}); //重新加载
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
		$.messager.alert("提示","请选中授权项目！",'warning'); 
		return false;
	}
	var mItmID = rowsData.ID;
	var NameDr= rowsData.NameDr;
	if(itmAutEditRow>="0"){
		$("#mainItmAut").datagrid('endEdit', itmAutEditRow);
	}

	var rows = $("#mainItmAut").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!",'warning');
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		if(mItmID==""){
			$.messager.alert("提示","请选择需要编辑的前提!",'warning'); 
			return false;
		}
		if((rows[i].PPDType=="")||($.trim(rows[i].PPDValue)=="")){
			$.messager.alert("提示","有必填项未填写，请核实!",'warning'); 
			return false;
		}
		if(rows[i].PPDType=="Constant"){
			rows[i].PPDValue = rows[i].PPDValueId;
		}
		var tmp=mItmID+"^"+rows[i].PPDValue+"^"+NameDr+"^"+rows[i].PPDLimit+"^"+rows[i].PPDStTime+"^"+rows[i].PPDEdTime+"^"+rows[i].PPDType+"^"+rows[i].ID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//保存数据
	runClassMethod("web.DHCPRESCPremiseData","save",{"params":rowstr},function(jsonString){

		if (jsonString >= "0"){
			$.messager.alert('提示','保存成功！','success');
		}else if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#mainItmAut').datagrid('load',{ID:mItmID}); //重新加载
	})
	
}


//datagrid 时间控件编辑器扩展
$.extend($.fn.datagrid.defaults.editors, {
    timespinner: {
        init: function (container, options) {
            var input = $('<input class = "easyui-timespinner" style="width:90px;"/>').appendTo(container);
            var options={
	            onChange:function(value){
		            $(this).timespinner('setValue', value);
		            }
	            }
            input.timespinner(options);
            return input
        },
        getValue: function (target) {
            var val = $(target).timespinner('getValue');
            return val;
        },
        setValue: function (target, value) {
	        
            $(target).timespinner('setValue', value);
        },
        resize: function (target, width) {
            var input = $(target);
            if ($.boxModel == true) {
                input.resize('resize', width - (input.outerWidth() - input.width()));
            } else {
                input.resize('resize', width);
            }
        }
    }
});
