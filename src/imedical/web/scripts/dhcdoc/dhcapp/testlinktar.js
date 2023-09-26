/**
 *	检测项目与收费2017-09-27项关联维护
 *	sufan  
**/
var editRow = ""; editTRow = "";textEditor="";

/// 页面初始化函数
function initPageDefault(){

	initTestItemList();         ///  初始页面检测项目
	initItemTarList();			///	 初始页面收费项目	
	initBlButton();          	///  页面Button绑定事件
	
}

///检测项目列表 
function initTestItemList(){
	
	///  定义columns
	var columns=[[
		{field:'ATIRowID',title:'ATIRowID',width:100,hidden:true},
		{field:'ATICode',title:'ATICode',width:200,hidden:true},
		{field:'ATIDesc',title:'检测项目',width:300},
		{field:'HospDr',title:'HospDr',width:200,hidden:true},
		{field:"ActiveFlag",title:'ActiveFlag',hidden:true}
	]];
	
	///  定义datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
			$('#ItemTarList').datagrid('reload',{TsetItmID:rowData.ATIRowID});
	    }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTestLinkTar&MethodName=QueryTestItem&HospID='+LgHospID;
	new ListComponent('ItemList', columns, uniturl, option).Init(); 
}

function initItemTarList()
{
	
	var TaritemEditor={		//设置其为可编辑
		type: 'combogrid',	//设置编辑格式
		options:{
			required : true,
			id : 'ATLRowID',
			fitColumns : true,
			fit : true,//自动大小  
			pagination : true,
			panelWidth : 600,
			textField : 'desc',
			mode : 'remote',
			url : 'dhcapp.broker.csp?ClassName=web.DHCAPPPosLinkTar&MethodName=QueryTar',
			columns:[[
					{field:'tarId',hidden:true},
					{field:'code',title:'代码',width:60},
					{field:'desc',title:'名称',width:140},
					{field:'price',title:'收费项价格',width:40}
					]],
				onSelect:function(rowIndex, rowData) {
   					fillValue(rowIndex, rowData);
				}		   
			}
	}
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'ATLRowID',title:'ATLRowID',width:100,hidden:'true'},
		{field:'ItemDr',title:'检测项目ID',width:200,hidden:'true'},
		{field:'TarID',title:'收费项目ID',width:100,hidden:'true',editor:textEditor},
		{field:'TarCode',title:'收费项代码',width:100,align:'center',editor:textEditor},
		{field:'TarDesc',title:'收费项名称',width:200,align:'center',editor:TaritemEditor},
		{field:'TarQty',title:'数量',width:100,align:'center',editor:textEditor},
		{field:'Price',title:'价格',width:100,align:'center',editor:textEditor},
		{field:'StaDate',title:'开始日期',width:100,editor:{type:'datebox'},align:'center'},
		{field:"EndDate",title:'结束日期',width:100,editor:{type:'datebox'},align:'center'},
		{field:"UpdUserName",title:'更新用户',width:100,align:'center'},
		{field:"UpdDate",title:'更新日期',width:100,align:'center'},
		{field:"UpdTime",title:'更新时间',width:100,align:'center'}
	]];
	
	///  定义datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
        onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
        
		    var e = $("#ItemTarList").datagrid('getColumnOption', 'TarCode');
			e.editor = {};
			var e = $("#ItemTarList").datagrid('getColumnOption', 'TarDesc');
			e.editor = {};
			var e = $("#ItemTarList").datagrid('getColumnOption', 'TarQty');
			e.editor = {};
			var e = $("#ItemTarList").datagrid('getColumnOption', 'Price');
			e.editor = {};
			var e = $("#ItemTarList").datagrid('getColumnOption', 'StaDate');
			e.editor = {};
		    	
            if (editRow != ""||editRow == 0){ 
                $("#ItemTarList").datagrid('endEdit', editRow); 
            } 
            $("#ItemTarList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTestLinkTar&MethodName=QueryTarByItmID';
	new ListComponent('ItemTarList', columns, uniturl, option).Init(); 
}

///调用取值函数
function fillValue(rowIndex, rowObj){

	if (rowObj == null){
		var editors = $('#ItemTarList').datagrid('getEditors', editRow);
		///检查项目
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///设置焦点 并选中内容
		return;
	}
	if (typeof rowObj.desc != "undefined"){
		
		/// 项目名称
		var ed=$("#ItemTarList").datagrid('getEditor',{index:editRow, field:'TarDesc'});
		$(ed.target).val(rowObj.desc);
		
		/// 项目code
		var ed=$("#ItemTarList").datagrid('getEditor',{index:editRow, field:'TarCode'});		
		$(ed.target).val(rowObj.code);
		
		/// 项目名称ID
		var ed=$("#ItemTarList").datagrid('getEditor',{index:editRow, field:'TarID'});		
		$(ed.target).val(rowObj.tarId);
		
		/// 项目价格
		var ed=$("#ItemTarList").datagrid('getEditor',{index:editRow, field:'Price'});		
		$(ed.target).val(rowObj.price);
	}
}
/// 页面 Button 绑定事件
function initBlButton(){
	
	///  增加增加收费项
	$('#tartb a:contains("增加收费项")').bind("click",insertTarRow);
	
	///  保存增加收费项
	$('#tartb a:contains("保存")').bind("click",saveTar);
	
	///  删除增加收费项
	$('#tartb a:contains("删除")').bind("click",deleteTarRow);
}

/// 插入收费项
function insertTarRow(){

	var e = $("#ItemTarList").datagrid('getColumnOption','TarCode');
	e.editor = { type: 'text',options: {required: true}};
	
	var e = $("#ItemTarList").datagrid('getColumnOption','Price');
	e.editor = { type: 'text',options: {required: true}};
	
	var e = $("#ItemTarList").datagrid('getColumnOption','TarQty');
	e.editor = { type: 'text',options: {required: true}};
	
	var e = $("#ItemTarList").datagrid('getColumnOption','StaDate');
	e.editor = {type:'datebox'};
	
	var e = $("#ItemTarList").datagrid('getColumnOption','TarDesc');
	e.editor = {type:'combogrid',options:{
										required : true,
										id : 'ATLRowID',
										fitColumns : true,
										fit : true,//自动大小  
										pagination : true,
										panelWidth : 600,
										textField : 'desc',
										mode : 'remote',
										url : 'dhcapp.broker.csp?ClassName=web.DHCAPPPosLinkTar&MethodName=QueryTar',
										columns:[[
											{field:'tarId',hidden:true},
											{field:'code',title:'代码',width:60},
											{field:'desc',title:'名称',width:140},
											{field:'price',title:'收费项价格',width:40}
										]],
										onSelect:function(rowIndex, rowData) {
   											fillValue(rowIndex, rowData);
											}		   
										}
									};
	var rowsData = $("#ItemList").datagrid('getSelected'); //选中左边的检查项目、部位行
	if (rowsData == null){
		$.messager.alert("提示", "请选择检测项目！");
		return;
	}
	if(editRow>="0"){
		$("#ItemTarList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#ItemTarList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ATLRowID:'',TarDesc:'',ItemDr:rowsData.ATIRowID,TarQty:'1','StaDate':new Date().Format("yyyy-MM-dd")}
	});
	$("#ItemTarList").datagrid('beginEdit', 0);	//开启编辑并传入要编辑的行
	editRow=0;
}

///保存收费项
function saveTar(){
	
	if(editRow>="0"){
		$("#ItemTarList").datagrid('endEdit', editRow);
	}
	var rowsData = $("#ItemTarList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].TarDesc==""){
			$.messager.alert("提示","请编辑必填数据！"); 
			return false;
		}
		var tmp=rowsData[i].ATLRowID+"^"+rowsData[i].ItemDr+"^"+rowsData[i].TarID+"^"+rowsData[i].TarQty +"^"+ rowsData[i].StaDate +"^"+ rowsData[i].EndDate +"^"+ LgUserID;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCAPPTestLinkTar","SaveTestTar",{"params":params},function(jsonString){
		if(jsonString==0){
			//$.messager.alert("提示","保存成功!"); 
			$('#ItemTarList').datagrid('reload'); //重新加载
			//$('#ItemList').datagrid('reload'); //重新加载
		}
		if(jsonString==-11){
			$.messager.alert('提示','开始时间大于结束时间')
			$('#ItemTarList').datagrid('reload');
		}
		if(jsonString==-12){
			$.messager.alert('提示','结束日期早于今天')
			$('#ItemTarList').datagrid('reload');
		}
	});
}

/// 删除检查项目,部位选中行
function deleteTarRow(){

	var rowsData = $("#ItemTarList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPTestLinkTar","DelTestTar",{"ATLRowID":rowsData.ATLRowID},function(jsonString){
					$('#ItemTarList').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}	 

///如果是合计行,则不能编辑
function onClickRowDisc(index,row){
	if(row.TarCode=="合计:") return;
	CommonRowClick(index,row,"#arctardatagrid");
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

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
