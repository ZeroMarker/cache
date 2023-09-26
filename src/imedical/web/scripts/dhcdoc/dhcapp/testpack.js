/** Descript  : 检测项目套餐及明细维护
 *  Creator   : sufan
 *  CreatDate : 2017-07-06
 */
var editRow = ""; 
var ActiveArray = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var TestPackID="" ;  ///检测项目套餐ID
var ArcUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail';
/// 页面初始化函数
function initPageDefault(){
	
	initPacklist();       	/// 初始页面DataGrid检测项目套餐表
	initPackItmlist();	 	///	初始页面DataGrid检测项目套餐表
	initButton();           /// 页面Button绑定事件
	initColumns();	
}

/// 初始化datagrid列
function initColumns(){
		
	ArcColumns = [[
	    {field:'itmDesc',title:'医嘱项名称',width:300},
	    {field:'itmCode',title:'医嘱项代码',width:100},
	    {field:'itmPrice',title:'单价',width:100},
		{field:'itmID',title:'itmID',width:80,hidden:true}
	]];
}

///检测项目套餐列表 
function initPacklist(){
	
	// 医院
	var Hospeditor={		//设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'HospDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// 是否可用
	var Flageditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:ActiveArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'ATPFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	// 检测分类
	var ItmCateditor={	
		type: 'combobox',	//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+'?ClassName=web.DHCAPPTestPack&MethodName=GetArcCat&HospID='+LgHospID,
			panelHeight:180,  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'CatDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'CatID'});
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
	// 定义columns
	var columns=[[
		{field:"ATPCode",title:'套餐代码',width:120,align:'center',editor:textEditor},
		{field:"ATPDesc",title:'套餐描述',width:120,align:'center',editor:textEditor},
		{field:"FlagCode",title:'FlagCode',width:80,hidden:'true',align:'center',editor:textEditor},
		{field:"ATPFlag",title:'是否可用',width:80,align:'center',editor:Flageditor},
		{field:"CatID",title:'分类ID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"CatDesc",title:'检测分类',width:140,align:'center',editor:ItmCateditor},
		{field:"HospDesc",title:'医院',width:180,align:'center',editor:Hospeditor},
		{field:"HospDr",title:'医院ID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"ATPRowID",title:'ID',width:20,hidden:'true',align:'center'}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#Packlist").datagrid('endEdit', editRow); 
            } 
            $("#Packlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
       onClickRow:function(rowIndex, rowData){
	    	TestPackID = rowData.ATPRowID ;
			$('#PackItmlist').datagrid('reload',{TestPackID: TestPackID});
	   }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTestPack&MethodName=QueryTestPack&HospID='+LgHospID;
	new ListComponent('Packlist', columns, uniturl, option).Init(); 
}

/// 页面 Button 绑定事件
function initButton(){
	
	///  增加检测项目
	$('#insert').bind("click",insertPackRow);
	
	///  保存检测项目
	$('#save').bind("click",savePackRow);
	
	///  删除检测项目
	$('#delete').bind("click",deletePackRow);
	
	///  增加套餐明细
	$('#insertItm').bind("click",insertItmRow);
	
	///  保存套餐明细
	$('#saveItm').bind("click",saveItmRow);
	
	///  删除套餐明细
	$('#deleteItm').bind("click",deleteItmRow);
	
	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findPacklist(); //调用查询
        }
    });
    
    // 查找套餐项目按钮绑定单击事件
    $('#find').bind('click',function(event){
         findPacklist(); //调用查询
    });
    
   	// 检测项目绑定回车事件
    $('#Itemdesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findPackItemlist(); //调用查询
        }
    });
    // 查找套餐项目明细按钮绑定单击事件
    $('#Itemfind').bind('click',function(event){
         findPackItemlist(); //调用查询
    });
    
    //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findPacklist(); //调用查询
    }); 
    
    //重置按钮绑定单击事件
    $('#resetitm').bind('click',function(event){
	    $('#Itemdesc').val("");
        findPackItemlist(); //调用查询
    }); 
}

/// 插入检查项目行
function insertPackRow(){

	if(editRow>="0"){
		$("#Packlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#Packlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ATPRowID:'',ATPCode:'',ATPDesc:'',FlagCode:'Y',ATPFlag:'Y',HospDr:LgHospID,HospDesc:LgHospID}
	});
    
	$("#Packlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
///保存检查项目
function savePackRow(){
	
	if(editRow>="0"){
		$("#Packlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#Packlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].ATPCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行代码为空！"); 
			return false;
		}
		if(rowsData[i].ATPDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行描述为空！"); 
			return false;
		}
		if(rowsData[i].CatDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行检查分类为空！"); 
			return false;
		}
		if(rowsData[i].HospDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"医院为为空！"); 
			return false;
		}
		var tmp=rowsData[i].ATPRowID +"^"+ rowsData[i].ATPCode +"^"+ rowsData[i].ATPDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].ATPFlag +"^"+ rowsData[i].CatID;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCAPPTestPack","SaveTestPack",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#Packlist').datagrid('reload'); //重新加载
	});
}

/// 删除
function deletePackRow(){
	
	var rowsData = $("#Packlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPTestPack","DeleteTestPack",{"ATPRowID":rowsData.ATPRowID},function(jsonString){
					$('#Packlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
// 查询套餐项目
function findPacklist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#Packlist').datagrid('load',{params:params}); 
}	 
////==========================================套餐明细维护=======================================================================
/// 初始化项目明细列表
function initPackItmlist()
{
	var Itemeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+'?ClassName=web.DHCAPPTestPack&MethodName=GetTestItem&HospID='+LgHospID,
			//required:true,
			panelHeight:"260",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#PackItmlist").datagrid('getEditor',{index:editRow,field:'TestItemDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#PackItmlist").datagrid('getEditor',{index:editRow,field:'TestItemID'});
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
	// 定义columns
	var columns=[[
		{field:"TestDesc",title:'医嘱项目',width:300,align:'center',editor:textEditor},
		{field:"TestQty",title:'数量',width:120,align:'center',editor:textEditor},
		{field:"TestID",title:'TestID',width:80,align:'center',editor:textEditor},
		{field:"TestPackItmID",title:'TestPackItmID',width:80,align:'center'}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    	var e = $("#PackItmlist").datagrid('getColumnOption', 'TestDesc');
			e.editor = {};
            if (editRow != ""||editRow == 0) { 
                $("#PackItmlist").datagrid('endEdit', editRow); 
            } 
            $("#PackItmlist").datagrid('beginEdit', rowIndex); 
            dataArcGridBindEnterEvent(rowIndex);  //设置回车事件
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTestPack&MethodName=QueryTestPackItm";
	new ListComponent('PackItmlist', columns, uniturl, option).Init();
}
/// 插入套餐明细
function insertItmRow()
{
	var rowsData = $("#Packlist").datagrid('getSelected');
	if (rowsData==null)
	{
		$.messager.alert("提示","请先选择检测项目套餐！"); 
		return false;
	}
	var e = $("#PackItmlist").datagrid('getColumnOption', 'TestDesc');
	e.editor = {type:'text'};
	
	if(editRow>="0"){
		$("#PackItmlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#PackItmlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {TestDesc:'',TestID:'',TestPackItmID:'',TestQty:'1'}
	});
    
	$("#PackItmlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
	
	dataArcGridBindEnterEvent(0);  //设置回车事件
}

///保存检测项目套餐明细
function saveItmRow(){
	
	var rowsData = $("#Packlist").datagrid('getSelected');
	var PackID=rowsData.ATPRowID;
	if(editRow>="0"){
		$("#PackItmlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#PackItmlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}

	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].TestItemDesc==""){
			$.messager.alert("提示","检测项目不能为空！"); 
			return false;
		}
		var tmp=rowsData[i].TestPackItmID +"^"+ PackID +"^"+ rowsData[i].TestDesc +"^"+ rowsData[i].TestID +"^"+ rowsData[i].TestQty;
		dataList.push(tmp);
		
	} 
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCAPPTestPack","InsTesItm",{"params":params},function(jsonString){
		
		if (jsonString == "0"){
			$.messager.alert('提示','保存成功！');
		}
		if (jsonString == "-11"){
			$.messager.alert('提示','检测项目关联重复！');
		}
		$('#PackItmlist').datagrid('reload'); //重新加载
	});
}
/// 删除
function deleteItmRow(){
	
	var rowsData = $("#PackItmlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPTestPack","DeleteTestPackItm",{"PackItmRowID":rowsData.TestPackItmID},function(jsonString){
					$('#PackItmlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
// 查询套餐明细
function findPackItemlist()
{
	var desc=$('#Itemdesc').val();
	$('#PackItmlist').datagrid('load',{ItemDesc:desc,TestPackID:TestPackID}); 
}

/// 给检查项目,部位datagrid绑定回车事件
function dataArcGridBindEnterEvent(index){
	
	var editors = $('#PackItmlist').datagrid('getEditors', index);
	/// 检查项目名称
	var workRateEditor = editors[0];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#PackItmlist").datagrid('getEditor',{index:index, field:'TestDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = ArcUrl + "&Input="+$(ed.target).val();
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), input, "550px", "" , unitUrl, ArcColumns, setCurrArcEditRowCellVal).init();
		}
	});
}

/// 给当前编辑列赋值(检查项目)
function setCurrArcEditRowCellVal(rowObj){
	
	if (rowObj == null){
		var editors = $('#PackItmlist').datagrid('getEditors', editRow);
		///检查项目
		var workRateEditor = editors[0];
		workRateEditor.target.focus().select();  ///设置焦点 并选中内容
		return;
	}
	
	/// 项目名称
	var ed=$("#PackItmlist").datagrid('getEditor',{index:editRow, field:'TestDesc'});
	$(ed.target).val(rowObj.itmDesc);
	/// 项目名称ID
	var ed=$("#PackItmlist").datagrid('getEditor',{index:editRow, field:'TestID'});		
	$(ed.target).val(rowObj.itmID);
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
