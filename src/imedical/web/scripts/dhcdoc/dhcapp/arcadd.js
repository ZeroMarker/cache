/// Descript: 检查医嘱维护
/// Creator : sufan
/// Date    : 2017-02-07
var editRow = ""; editTRow = ""; var ArcColumns="";
var ArcUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail';
var ExecArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
var TarArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
var ReqArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
/// 页面初始化函数
function initPageDefault(){
	var hospComp = GenHospComp("DHC_AppArcAdd"); //Doc_APP_Arcmastrelmain
	hospComp.jdata.options.onSelect  = function(){
		$("#code,#desc").val("");
		commonQuery();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		initArcItemList();       ///  初始页面DataGrid检查医嘱列表
		initButton();          ///  页面Button绑定事件
		initColumns();
	}
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
///检查项目,部位列表 
function initArcItemList(){
	
	/// 执行标志
	var ExecFlageditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:ExecArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ExecFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ExecCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	
	/// 计费标志
	var TarFlageditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:TarArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'TarFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'TarCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	
	
	/// 申请标志
	var ReqFlageditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:ReqArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ReqFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ReqCode'});
				$(ed.target).val(option.value); 
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
		{field:'ArcDr',title:'医嘱项ID',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'AraArcCode',title:'医嘱项代码',width:180,editor:textEditor},
		{field:'AraArcDesc',title:'医嘱项',width:240,editor:textEditor},
		{field:'ExecCode',title:'ExecCode',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'ExecFlag',title:'按部位生成执行记录',width:180,align:'center',hidden:true,editor:ExecFlageditor},
		{field:'TarCode',title:'TarCode',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'TarFlag',title:'按部位累加收费',width:160,align:'center',editor:TarFlageditor},
		{field:'ReqCode',title:'ReqCode',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'ReqFlag',title:'自动生成申请(仅检查/检验申请)',width:200,align:'center',editor:ReqFlageditor},
		{field:"AraRowId",title:'ID',hidden:true,editor:textEditor}
	]];
	
	///  定义datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#arcItemList").datagrid('endEdit', editRow); 
            } 
            $("#arcItemList").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  //设置回车事件
            editRow = rowIndex;
        }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue()
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcAdd&MethodName=QueryExaArc&HospID="+HospID;
	new ListComponent('arcItemList', columns, uniturl, option).Init(); 
}


/// 页面 Button 绑定事件
function initButton(){
	
	///  增加检查项目,部位
	$('#arctb a:contains("新增")').bind("click",insertArcRow);
	
	///  保存检查项目,部位
	$('#arctb a:contains("保存")').bind("click",saveExecArc);
	
	///  删除检查项目,部位
	$('#arctb a:contains("删除")').bind("click",deleteArcRow);
	
	///回车事件 sufan   2016/08/03
	$('#desc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var HospID=$HUI.combogrid('#_HospList').getValue()
			var unitUrl = ArcUrl + "&Input="+$('#desc').val()+"&HospID="+HospID;
			/// 调用医嘱项列表窗口
			//new ListComponentWin($('#desc'), "", "600px", "" , unitUrl, ArcColumns, setArcCurrEditRowCellVal).init();
		}
	});
	
	 // 查找按钮绑定单击事件
	$('#find').bind('click',function(event){
         commonQuery(); //调用查询
    })
    
	//重置按钮绑定单击事件
	$('#reset').bind('click',function(event){
		$('#code').val("");
		$('#desc').val("");
		commonQuery(); //调用查询
	})		
}

///查询按钮医嘱项响应函数
function setArcCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#desc').focus().select();  ///设置焦点 并选中内容
		return;
	}
	$('#desc').val(rowObj.itmDesc);  /// 医嘱项
}

/// 插入检查项目部位行
function insertArcRow(){
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#arcItemList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {AraRowId:'', ArcDr:'', AraArcDesc:'', TarCode:'N',TarFlag:'N',ReqCode:'Y',ReqFlag:'Y'}
	});
	$("#arcItemList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
	
	var rows = $("#arcItemList").datagrid('getRows');
	if (rows.length != "0"){
		dataGridBindEnterEvent(0);  //设置回车事件
	}
}
///保存检查项目部位
function saveExecArc(){
	
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);
	}
	var rowsData = $("#arcItemList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var HospID=$HUI.combogrid('#_HospList').getValue()
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].ArcDr=="")||(rowsData[i].AraArcDesc=="")){
			$.messager.alert("提示","医嘱项不能为空！"); 
			return false;
		}
		var tmp=rowsData[i].AraRowId+"^"+rowsData[i].ArcDr+"^"+rowsData[i].AraArcDesc+"^"+rowsData[i].ExecCode+"^"+ rowsData[i].TarCode +"^"+ rowsData[i].ReqCode+"^"+HospID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCAPPArcAdd","SaveExaArc",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("提示","保存成功!"); 
			$('#arcItemList').datagrid('reload'); //重新加载
		}
		if(jsonString=="-1"){
			$.messager.alert("提示","数据重复!"); 
			$('#arcItemList').datagrid('reload'); //重新加载
		}
	});
}

/// 删除
function deleteArcRow(){
	
	var rowsData = $("#arcItemList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPArcAdd","DeleteArcAdd",{"AraRowId":rowsData.AraRowId},function(jsonString){
					$('#arcItemList').datagrid('reload'); //重新加载
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
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#arcItemList").datagrid('getEditor',{index:index, field:'AraArcDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var HospID=$HUI.combogrid('#_HospList').getValue()
			var unitUrl = ArcUrl + "&Input="+$(ed.target).val()+"&HospID="+HospID;
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	});
}

/// 给当前编辑列赋值(检查项目)
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#arcItemList').datagrid('getEditors', editRow);
		///检查项目
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///设置焦点 并选中内容
		return;
	}
	/// 项目名称
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'AraArcDesc'});
	$(ed.target).val(rowObj.itmDesc);
	/// 项目名称ID
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ArcDr'});		
	$(ed.target).val(rowObj.itmID);
	/// 项目代码
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'AraArcCode'});		
	$(ed.target).val(rowObj.itmCode);
}
/// 按医嘱项或代码查询函数
function commonQuery() 
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var param=code+"^"+desc;
	var HospID=$HUI.combogrid('#_HospList').getValue()
	$('#arcItemList').datagrid('load',{params:param,HospID:HospID}); 
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
