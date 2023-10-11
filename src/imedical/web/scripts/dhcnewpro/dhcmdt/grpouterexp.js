//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2020-08-18
// 描述:	   MDT病种关联院外专家JS
//===========================================================================================

var editRow = "";
var grpID = "";
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
		
/// 页面初始化函数
function initPageDefault(){

	InitParams();      /// 初始华参数
	InitComponents();  /// 初始化界面组件
	InitMainList();    /// 初始化列表
}

/// 初始化页面参数
function InitParams(){
	
	var rowData = parent.$("#main").datagrid("getSelected");
	if (rowData == null) {
		return;
	}
	grpID = rowData.ID;   /// MDT小组ID
}

/// 初始化界面组件
function InitComponents(){
	

}

/// 初始化加载交班列表
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
	
	var rowData = parent.$("#main").datagrid("getSelected");
	var HospID = rowData.HospID;  
	
	// 外院专家
	var OutExpEditor = {
		type:'combogrid',
		options:{
			required : true,
			id:'ID',
			fitColumns:false,
			fit: true,//自动大小
			pagination : true,
			panelWidth:580,
			textField:'userName', 
			mode:'remote',
			url:$URL+'?ClassName=web.DHCMDTExpertMan&MethodName=JsQryExpMan&GropHospID='+HospID+"&MWToken="+websys_getMWToken(),
			columns:[[
				{field:'ID',title:'ID',width:100,hidden:true},
				{field:'userCode',title:'工号',width:100,align:'center'},
				{field:'userName',title:'姓名',width:160,align:'left'},
				{field:'userSex',title:'性别',width:60,align:'center'},
				{field:'prvTp',title:'职称',width:100,align:'center'},
				{field:'locDesc',title:'科室',width:160,align:'left'},
				{field:'phone',title:'联系电话',width:100,align:'left'},
				{field:'hospDesc',title:'医院',width:200,align:'center',hidden:true}
			]],
			onSelect:function(rowIndex, rowData) {
				fillValue(rowIndex, rowData);
			}	
		}
	};
	
	///  定义columns
	var columns=[[
		{field:'grpID',title:'grpID',width:100,hidden:true},
		{field:'ID',title:'ID',width:100},
		{field:'userID',title:'userID',width:100,hidden:true,editor:textEditor},
		{field:'userCode',title:'工号',width:100,align:'center',editor:textEditor},
		{field:'userName',title:'姓名',width:160,align:'left',editor:OutExpEditor},
		{field:'userSex',title:'性别',width:100,align:'center',editor:textEditor},
		{field:'prvTp',title:'职称',width:100,align:'center',editor:textEditor},
		{field:'locDesc',title:'科室',width:160,align:'left'},
		{field:'outHosp',title:'医院',width:160,align:'left'},
		{field:'phone',title:'联系电话',width:120,align:'left'},
		{field:'hospDesc',title:'医院',width:200,align:'center',hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		headerCls:'panel-header-gray',
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){

		},
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
            
			SetCellDisEnable(editRow); /// 设置列不可编辑

        },
		onLoadSuccess:function(data){

		}
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=JsQryGrpOutExp&Parref="+ grpID+"&MWToken="+websys_getMWToken();
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
		
		if(rowsData[i].userID==""){
			$.messager.alert("提示","专家不能为空!"); 
			return false;
		}
		var tmp = rowsData[i].ID +"^"+ rowsData[i].grpID +"^"+ rowsData[i].userID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTGroup","saveOutExp",{"mParam":mListData},function(jsonString){

		if (jsonString == "-1"){
			$.messager.alert('提示','专家重复,请核实后再试！','warning');
			return;	
		}else if (jsonString != 0){
			$.messager.alert('提示','保存失败！','warning');
			return;
		}
		$('#main').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	var rowData = parent.$("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择MDT小组!");
		return;
	}
	var ID = rowData.ID;   /// MDT小组ID

	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].userCode == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {grpID:ID, ID:'', userID:'', userCode:'', userName:'', userSex:'', prvTp:'', special:'', idCard:'', locDesc:'', phone:'',hospDesc:''}
	});
	$("#main").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
	
	SetCellDisEnable(editRow); /// 设置列不可编辑
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTGroup","deleteOutExp",{"ID":rowsData.ID},function(jsonString){
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

/// 调用取值函数
function fillValue(rowIndex, rowData){
		
	if (rowData == null) return;
	/// 专家ID
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'userID'});
	$(ed.target).val(rowData.ID);
	/// 工号
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'userCode'});
	$(ed.target).val(rowData.userCode);
	/// 姓名
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'userName'});
	$(ed.target).val(rowData.userName);
	/// 性别
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'userSex'});
	$(ed.target).val(rowData.userSex);
	/// 职称
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'prvTp'});
	$(ed.target).val(rowData.prvTp);
}

/// 设置列不可编辑
function SetCellDisEnable(rowIndex){
	
	SetDisEnable(rowIndex, "userSex");   /// 设置列不可编辑
	SetDisEnable(rowIndex, "prvTp");     /// 设置列不可编辑
	SetDisEnable(rowIndex, "userCode");  /// 设置列不可编辑
}

/// 设置列不可编辑
function SetDisEnable(rowIndex, fieldName){
	
	// 得到单元格对象,index指哪一行,field跟定义列的那个一样
	var cellEdit = $("#main").datagrid('getEditor', {index:rowIndex, field:fieldName});
	cellEdit.target.prop('readonly',true); // 设值文本框对象只读
}

//扩展 datagrid combogrid 属性的editor 2016-07-24
$(function(){
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
})
/// 自动设置页面布局
function onresize_handler(){
	
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })