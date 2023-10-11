/// author:     sufan
/// date:       2020-02-20
/// descript:   不良事件表单元素对照界面JS

var editRow = "",HospDr="";
var ConArray = [{"value":"0","text":'统计'}, {"value":"1","text":'接口'}];

$(function(){
    InitHosp(); 	//初始化医院 多院区改造 cy 2021-04-09
	InitCombobox()			//初始化下拉框
	
	InitdgMainList();		//初始化对照关系列表
	
	initBlButton();			//初始化界面按钮事件
})
// 初始化医院 多院区改造 cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvDicContrast"); 
	HospDr=hospComp.getValue(); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///选中事件
		HospDr=hospComp.getValue();
		$("#formname").combobox('setValue',""); 
		search(); 
		var url='dhcapp.broker.csp?ClassName=web.DHCADVDicContrast&MethodName=jsonForm&HospID='+HospDr;
		$("#formname").combobox('reload',url);  
	}
}
///初始化下拉框数据
function InitCombobox()
{
	// 表单类型
	$('#formname').combobox({
		url:$URL+"?ClassName=web.DHCADVDicContrast&MethodName=jsonForm&HospID="+HospDr,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	
}
/// 界面元素监听事件
function initBlButton()
{

	///增加
	$("#insert").bind("click",insertRow);
	
	///删除
	$("#delete").bind("click",deleteRow);
	
	///保存
	$("#save").bind("click",saveRow);
	
	///查询
	$("#find").bind("click",search);
	
	///重置
	$("#reset").bind("click",reset);
}

///初始化病人列表
function InitdgMainList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var dicclonms = [[
	    {field:'DicField',title:'元素代码',width:120},
	    {field:'DicDesc',title:'元素描述',width:100}
	]];
	
	//类型
	var ConEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			data:ConArray,
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				///设置类型值
				/// 元素描述
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ConFlag'});
				$(ed.target).combobox('setValue', option.text);
				/// 元素代码
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ConFlagCode'});
				$(ed.target).val(option.value);
				///一下加载下拉grid数据
				 var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FieldDesc'});
				$ (ed.target).combogrid('grid').datagrid('load', {
					type:option.value,
					HospDr:HospDr
				});
				
				
			}
		}
	}
	
	/// 统计/接口元素
	var FieldEditor = {
		type:'combogrid',
		options:{
		    id:'DicField',
		    fitColumns:true,
		    fit: true,//自动大小  
			pagination : true,
			panelWidth:500,
			textField:'DicDesc',
			mode:'remote',
			url:$URL+'?ClassName=web.DHCADVDicContrast&MethodName=QueryAllFormItem&HospDr'+HospDr,
			columns:dicclonms,
			onSelect:function(rowIndex, rowData) {
				setAttrEditRowCellVal(rowData);
			},
			keyHandler: {  
	            query: function (keyword) {     //【动态搜索】处理 
					/// 元素代码
					var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ConFlagCode'});
					var type=$(ed.target).val();
					var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FieldDesc'});
					$ (ed.target).combogrid('grid').datagrid('load', {
						type:type,
						HospDr:HospDr,
						q:keyword
					});
					$(ed.target).combogrid("setValue", keyword);
	            }
			}
		}
	}
	
	/// 表单Combobox
	var FormEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVDicContrast&MethodName=jsonForm&HospID="+HospDr,
			mode:'remote',
			onSelect:function(option){
				///设置类型值
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormNameDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormNameCode'});
				$(ed.target).val(option.code);
				///设置级联指针
				var FormID=option.value;  //元素
				var FormDicDesced=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormFieldDesc'});
				$(FormDicDesced.target).combobox('setValue', "");
				var unitUrl=LINK_CSP+"?ClassName=web.DHCADVDicContrast&MethodName=jsonFormDic&FormID="+FormID;
				$(FormDicDesced.target).combobox('reload',unitUrl);
				var FormDicCodeed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormFieldCode'});
				$(FormDicCodeed.target).val("");
			}
		}
	}
	
	/// 字段Combobox
	var FormFieldEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonFormField",
			mode:'remote',
			onSelect:function(option){
				///设置类型值
				/// 元素描述
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormFieldDesc'});
				$(ed.target).combobox('setValue', option.text);
				/// 元素代码
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormFieldCode'});
				$(ed.target).val(option.code);
			}
		}
	}
	
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'ConFlagCode',title:'ConFlagCode',width:80,editor:textEditor,hidden:true},
		{field:'ConFlag',title:'统计/接口',width:120,editor:ConEditor},
		{field:'FieldCode',title:'统计/接口元素代码',width:130,editor:textEditor},
		{field:'FieldDesc',title:'统计/接口元素',width:180,editor:FieldEditor},
		{field:'FormNameCode',title:'表单代码',width:100,editor:textEditor,hidden:true},
		{field:'FormNameDesc',title:'表单名称',width:220,editor:FormEditor},
		{field:'FormFieldCode',title:'事件元素代码',width:120,editor:textEditor},
		{field:'FormFieldDesc',title:'事件元素',width:180,editor:FormFieldEditor},
		{field:'ConHsopDr',title:'ConHsopDr',width:100,hidden:true}
	]];
	/**
	 * 定义datagrid
	 */
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	      
	    }
	};
	var uniturl = $URL+"?ClassName=web.DHCADVDicContrast&MethodName=QueryDicContrast&param="+"&HospDr="+HospDr;
	new ListComponent('dgMainList', columns, uniturl, option).Init(); 
}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].FieldCode==""){
			$.messager.alert("提示","统计/接口元素代码不能为空!"); 
			return false;
		}
		if(rowsData[i].FormNameCode==""){
			$.messager.alert("提示","表单代码不能为空!"); 
			return false;
		}
		if(rowsData[i].FormFieldCode==""){
			$.messager.alert("提示","事件元素代码不能为空!"); 
			return false;
		}
		
		var tmp=rowsData[i].ID +"^"+ rowsData[i].FieldCode +"^"+ rowsData[i].FormNameCode +"^"+ rowsData[i].FormFieldCode +"^"+ rowsData[i].ConFlagCode+"^"+ rowsData[i].ConHospDr;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCADVDicContrast","saveDicContrast",{"ListData":params},function(jsonString){

		if (jsonString == "-1"){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
		}
		$('#dgMainList').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#dgMainList").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].aitCode == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', FieldCode:'', FieldDesc:'', FormNameCode:'', FormNameDesc:'',FormFieldCode:'', FormFieldDesc:'', FormDicCode:'', ConFlag:'',ConHospDr:HospDr}
	});
	$("#dgMainList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
	
	
	// 多院区改造 cy 2021-04-13 根据医院重新加载 表单名称下拉数据
	var FormNameDesced=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormNameDesc'});
	var url="dhcapp.broker.csp?ClassName=web.DHCADVDicContrast&MethodName=jsonForm&HospID="+HospDr;
	$(FormNameDesced.target).combobox('reload',url);  

}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#dgMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCADVDicContrast","DelContrast",{"ConId":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#dgMainList').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

///dg列赋值
function setAttrEditRowCellVal(rowObj)
{
	var ed=$("#dgMainList").datagrid('getEditor',{index:editRow, field:'FieldCode'});		
	$(ed.target).val(rowObj.DicField);
	var ed=$("#dgMainList").datagrid('getEditor',{index:editRow, field:'FieldDesc'});		
	$(ed.target).val(rowObj.DicDesc);
	
}

///查询
function search()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var formname=$("#formname").combobox('getValue');
	var param=code+"^"+desc+"^"+formname;
	$('#dgMainList').datagrid('load',{param:param,HospDr:HospDr}); 
}

///重置
function reset()
{
	$('#code').val("");
	$('#desc').val("");
	$("#formname").combobox('setValue',"");
	$('#dgMainList').datagrid('load',{param:"",HospDr:HospDr});
}
