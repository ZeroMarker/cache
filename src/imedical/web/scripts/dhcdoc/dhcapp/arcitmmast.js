/// Descript: 检查分类关联医嘱项维护
/// Creator : qunianpeng
/// Date    : 2017-03-19

var catID = "", editRow = "",  ArcColumns="";
var ArcUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail';
var FrostArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];


/// 页面初始化函数
function initPageDefault(){
	
	InitDefault();			/// 初始化界面默认信息
	initArcItemList();	 	///	初始页面DataGrid医嘱项关联表
	initButton();           ///  页面Button绑定事件	
	initColumns();			/// 初始化datagrid列
}

///初始化界面默认信息
function InitDefault(){
	catID=getParam("itmmastid");  ///医嘱项ID
}

/// 初始化datagrid列
function initColumns(){
	ArcColumns = [[
	    {field:'itmDesc',title:'医嘱项名称',width:220},
	    {field:'itmCode',title:'医嘱项代码',width:100},
	    {field:'itmPrice',title:'单价',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];
}


/// 页面 Button 绑定事件
function initButton(){	

	///  增加医嘱项
	$('#insertarcitm').bind("click",insertArcItmRow);
	
	///  保存医嘱项
	$('#savearcitm').bind("click",saveArcItmRow);
	
	///  删除医嘱项
	$('#deletearcitm').bind("click",deleteArcItmRow);	

}

//检查项目,部位列表 
function initArcItemList(){	
	
	/// 冰冻标志
	var FrostFlageditor={			/// 设置其为可编辑
		type: 'combobox',			/// 设置编辑格式
		options: {
			data:FrostArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",		/// 设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'FrostFlag'});
				$(ed.target).combobox('setValue', option.value);  //设置是否可用
				$(ed.target).combobox('setText', option.text);
				//var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ReqCode'});
				//$(ed.target).val(option.value); 
			} 
		}
	}
	/// 文本编辑格
	var textEditor={
		type: 'text',			/// 设置编辑格式
		options: {
			required: true  	/// 设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'ArcDr',title:'医嘱项ID',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'ArcCode',title:'医嘱项代码',width:150,align:'center',editor:textEditor},
		{field:'ArcDesc',title:'医嘱项',width:240,align:'center',editor:textEditor},
		{field:'FrostFlag',title:'冰冻标志',width:100,align:'center',editor:FrostFlageditor},		
		{field:"AcRowId",title:'ID',hidden:true,editor:textEditor}
	]];
	
	///  定义datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {	/// 双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#arcItemList").datagrid('endEdit', editRow); 
            } 
            $("#arcItemList").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  			/// 设置回车事件
            editRow = rowIndex;
        },
         onClickRow:function(rowIndex, rowData){	        
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,CatID)}});
			
	    },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcCat&MethodName=QueryCatLinkArcItm&ItmId="+catID;	
	new ListComponent('arcItemList', columns, uniturl, option).Init(); 
}

/// 插入医嘱项
function insertArcItmRow()
{
	if (catID == ""){
		$.messager.alert("提示","请选择一个选项!"); 
		return;	
	}	
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);	/// 结束编辑，传入之前编辑的行
	}
	 
	$("#arcItemList").datagrid('insertRow', {			/// 在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, 										/// 行数从0开始计算
		row: { ArcDr:'', ArcDesc:'',FrostFlag:'Y'}
	});
	$("#arcItemList").datagrid('beginEdit', 0);			/// 开启编辑并传入要编辑的行
	editRow=0;	
	
	var rows = $("#arcItemList").datagrid('getRows');
	if (rows.length != "0"){
		dataGridBindEnterEvent(0);  					/// 设置回车事件
	}
}

///保存医嘱项
function saveArcItmRow(){
	
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);
	}
	var rowsData = $("#arcItemList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if ((rowsData.ArcDr=="")||(rowsData[i].ArcDr==""))
		{
			$.messager.alert("提示","请选择医嘱项!");
			return false;
		} 
		var tmp=rowsData[i].AcRowId  +"^"+ rowsData[i].ArcDr +"^"+ catID +"^"+ rowsData[i].FrostFlag;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCAPPArcCat","SaveLinkArc",{"params":params},function(jsonString){
		if (jsonString == "0"){
			$.messager.alert('提示','保存成功！');
		}
		if (jsonString=="-11")
		{
			$.messager.alert('提示','该医嘱项已关联相同分类，请重新选择！');
			}
		$('#arcItemList').datagrid('reload'); 	/// 重新加载
	});
}
/// 删除
function deleteArcItmRow(){
	
	var rowsData = $("#arcItemList").datagrid('getSelected');					/// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	/// 提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPArcCat","DelCatLinkArcItm",{"AcRowId":rowsData.AcRowId},function(jsonString){
					$('#arcItemList').datagrid('reload'); 						/// 重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 给医嘱项绑定回车事件
function dataGridBindEnterEvent(index){
	
	var editors = $('#arcItemList').datagrid('getEditors', index);
	/// 检查项目名称
	var workRateEditor = editors[2];
	workRateEditor.target.focus();  		/// 设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#arcItemList").datagrid('getEditor',{index:index, field:'ArcDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var HospID=LgHospID;
			if (parent.GetSelHospId) HospID=parent.GetSelHospId();
			var unitUrl = ArcUrl + "&Input="+$(ed.target).val()+"&HospID="+HospID;
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), input, "500px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	});
}
/// 给当前编辑列赋值(医嘱项目)
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#arcItemList').datagrid('getEditors', editRow);
		///检查项目
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  /// 设置焦点 并选中内容
		return;
	}
	/// 项目名称
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ArcDesc'});
	$(ed.target).val(rowObj.itmDesc);
	/// 项目名称ID
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ArcDr'});		
	$(ed.target).val(rowObj.itmID);
	/// 项目代码
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ArcCode'});		
	$(ed.target).val(rowObj.itmCode);
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })