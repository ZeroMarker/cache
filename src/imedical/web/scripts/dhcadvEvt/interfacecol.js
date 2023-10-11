/// author:     sufan
/// date:       2020-02-20
/// descript:   不良事件表单元素对照界面JS

var editRow = "",HospDr="";
$(function(){
    InitHosp(); 	//初始化医院 多院区改造 cy 2021-04-09
	InitdgMainList();		//初始化对照关系列表
	
	initBlButton();			//初始化界面按钮事件
})
// 初始化医院 多院区改造 cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvInterfaceCol"); 
	HospDr=hospComp.getValue(); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///选中事件
		HospDr=hospComp.getValue();
		search(); 
	}
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
	
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:"HospDr",title:'医院id',width:90,align:'center',hidden:true},
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'代码',width:180,editor:textEditor},
		{field:'Desc',title:'描述',width:200,editor:textEditor},
		
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
	var uniturl = $URL+"?ClassName=web.DHCADVInterfaceCol&MethodName=QueryIntCol&param="+"&HospDr="+HospDr;
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
		
		if(rowsData[i].Code==""){
			$.messager.alert("提示","代码不能为空!"); 
			return false;
		}
		if(rowsData[i].Desc==""){
			$.messager.alert("提示","描述不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc+"^"+rowsData[i].HospDr;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");
	
	//保存数据
	runClassMethod("web.DHCADVInterfaceCol","SaveIntCol",{"params":params},function(jsonString){

		if ((jsonString == -1)||(jsonString == -3)){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
		}
		if ((jsonString == -2)||(jsonString == -4)){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
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
		row: {ID:'', Code:'', Desc:'',HospDr:HospDr}
	});
	$("#dgMainList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#dgMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCADVInterfaceCol","DelIntCol",{"AFCRowID":rowsData.ID},function(jsonString){
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
	var param=code+"^"+desc;
	$('#dgMainList').datagrid('load',{params:param,HospDr:HospDr}); 
}

///重置
function reset()
{
	$('#code').val("");
	$('#desc').val("");
	$('#dgMainList').datagrid('load',{param:"",HospDr:HospDr});
}
