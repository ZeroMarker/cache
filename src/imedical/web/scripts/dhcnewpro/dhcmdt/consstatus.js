/// author:    bianshuai
/// date:      2016-04-11
/// descript:  会诊申请状态字典维护
var LgHospID = session['LOGON.HOSPID'];    /// 医院ID
var LgHospDesc = session['LOGON.HOSPDESC'];  /// 医院
var editRow = ""; editDRow = "";
$(function(){
    
    //初始化医院 多院区改造 ylp 2023-02-23
    InitHosp(); 

	//初始化界面默认信息
	InitDefault();
	
	//初始化咨询信息列表
	InitDetList();
	
	//初始化界面按钮事件
	InitWidListener();
})
   
 //初始化医院 多院区改造 ylp 2023-02-23
function InitHosp(){
	hospComp = GenHospComp("DHC_MDTConsStatus"); 
	HospDr=hospComp.getValue(); //cy 2021-04-09
	hospComp.options().onSelect = function(){///选中事件
		HospDr=hospComp.getValue(); //cy 2021-04-09
		
		$("#dgMainList").datagrid('reload',{params:HospDr});
		
	}
	$('#queryBTN').on('click',function(){
		$("#dgMainList").datagrid('reload',{params:hospComp.getValue()});
	 })
	$("#_HospBtn").bind('click',function(){
		var rowData = $("#dgMainList").datagrid('getSelected');
		if (!rowData){
			$.messager.alert("提示","请选择一行！");
			return false;
		}
		GenHospWin("DHC_MDTConsStatus",rowData.ID);
	})
	

}

///初始化界面默认信息
function InitDefault(){

}

/// 界面元素监听事件
function InitWidListener(){

	$("div#tb a:contains('新增')").bind("click",insertRow);
	$("div#tb a:contains('删除')").bind("click",deleteRow);
	$("div#tb a:contains('保存')").bind("click",saveRow);
	
}

///初始化病人列表
function InitDetList(){
	
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
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActDesc'});
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
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetHospDs"+"&MWToken="+websys_getMWToken(),
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	// 上一状态编辑格
	var SupStateEditor={
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			multiple:true,
			enterNullValueClear:false,
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=GetListMdtStatus&HospID="+LgHospID+"&MWToken="+websys_getMWToken(),
			blurValidValue:true,
			onChange:function() {
				///设置类型值
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'SupState'});
				var SupStateArr=$(ed.target).combobox('getValues');
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'SupStateID'});
				$(ed.target).val(SupStateArr.join(","));	
			},
			onShowPanel:function(){
				
			}		   
		}
	}
	
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'代码',width:100,editor:textEditor},
		{field:'Desc',title:'描述',width:200,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'是否可用',width:100,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'HospDesc',title:'医院',width:300,editor:HospEditor,hidden:true},
		{field:'SupState',title:'上一状态',width:300,editor:SupStateEditor},
		{field:'SupStateID',title:'上一状态ID',width:100,editor:textEditor,hidden:true},
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		//title:'会诊申请状态字典',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            editRow = rowIndex;
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'SupStateID'});
            var SupStateArr=$(ed.target).val().split(",");
            var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'SupState'});
			$(ed.target).combobox('setValues',SupStateArr);
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsStatus&MethodName=QryEmConsStatus"+"&params="+hospComp.getValue()+"&MWToken="+websys_getMWToken();
	var dgMainListComponent = new ListComponent('dgMainList', columns, uniturl, option);
	dgMainListComponent.Init();

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
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +
				"^"+rowsData[i].SupStateID;
		
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTConsStatus","save",{"mParam":params},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
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
		if (rowsData[0].Code == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'是', HospID:hospComp.getValue(), HospDesc:""}
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
				runClassMethod("web.DHCMDTConsStatus","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('提示','此项已和医嘱项绑定,不能删除！','warning');
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