/// author:    qqa
/// date:      2018-07-04
/// descript:  会诊申请关联医嘱项

var editRow = ""; editDRow = "";
$(function(){
    //初始化医院 hxy 2020-05-28
    InitHosp(); 
    
	//初始化界面默认信息
	InitDefault();
	
	//初始化咨询信息列表
	InitDetList();
	
	//初始化界面按钮事件
	InitWidListener();
})

function InitHosp(){
	hospComp = GenHospComp("DHC_EmConsOrdConfig");  //hxy 2020-05-28 st
	hospComp.options().onSelect = function(){///选中事件
		Query();
	}//ed
}

///初始化界面默认信息
function InitDefault(){
	/*$('#hospDrID').combobox({ //hxy 2019-11-28 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto',
		onSelect:function(option){
		}
	 }) //ed*/ //hxy 2020-05-28 注释
}

/// 界面元素监听事件
function InitWidListener(){

	$("div#tb a:contains('新增')").bind("click",insertRow);
	$("div#tb a:contains('删除')").bind("click",deleteRow);
	$("div#tb a:contains('保存')").bind("click",saveRow);
	
}

///初始化病人列表
function InitDetList(){
	/*
	 * 定义columns
	 */
	var columns=[[
		{field:'ECOCRowID',title:'ID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ECOCHosp',title:'医院',width:100,editor:hospEditor,hidden:true}, //hxy 2019-12-24 //2020-05-28 hidden
		{field:'ECOCHospDr',title:'医院ID',width:80,editor:'text',hidden:true}, //hxy 2019-12-24
		{field:'ECOCLoc',title:'会诊科室',width:100,editor:LocEditor,align:'center'},
		{field:'ECOCLocID',title:'科室ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCArci',title:'会诊医嘱',width:100,editor:ArciEditor,align:'center'},
		{field:'ECOCArciID',title:'医嘱ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCType',title:'会诊类型',width:100,editor:TypeEditor,align:'center'},
		{field:'ECOCTypeID',title:'类型ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCProTp',title:'职称',width:100,editor:PrvTpEditor,align:'center'},
		{field:'ECOCProTpID',title:'职称ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCProp',title:'会诊性质',width:100,editor:PropEditor,align:'center'},
		{field:'ECOCPropID',title:'会诊性质ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'ECOCInsType',title:'生成方式',width:100,editor:InsertTypeEditor,align:'center'},
		{field:'ECOCInsTypeID',title:'方式ID',width:100,editor:textEditor,align:'center',hidden:true},
	]];
	
	$HUI.datagrid("#dgMainList",{
		url: $URL+"?ClassName=web.DHCEMConsOrd&MethodName=QryEmConsOrd&params="+hospComp.getValue(), //hxy 2020-05-28 &params="+hospComp.getValue()
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		//title:'会诊申请关联医嘱项',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }	
	})
	

}

/// 保存编辑行
function saveRow(){
	
	if((editRow >= 0)||(editRow == "")){
		$("#dgMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].ECOCLocID==="")){
			$.messager.alert("提示","科室不能为空");     
			return false;
		}
		
		if((rowsData[i].ECOCArciID==="")){
			$.messager.alert("提示","会诊医嘱不能为空");     
			return false;
		}
		
		if((rowsData[i].ECOCTypeID==="")){
			$.messager.alert("提示","会诊类型不能为空");     
			return false;
		}
		/*
		if((rowsData[i].ECOCProTpID==="")){
			$.messager.alert("提示","职称不能为空");     
			return false;
		}
		*/
		if((rowsData[i].ECOCInsTypeID==="")){
			$.messager.alert("提示","生成方式不能为空");     
			return false;
		}
		
		
	
		var tmp=rowsData[i].ECOCRowID+"^"+rowsData[i].ECOCLocID +"^"+ rowsData[i].ECOCArciID +"^"+ rowsData[i].ECOCTypeID +"^"+ rowsData[i].ECOCProTpID +"^"+ rowsData[i].ECOCInsTypeID +"^"+ rowsData[i].ECOCPropID;
		tmp=tmp+"^"+rowsData[i].ECOCHosp+"^"+rowsData[i].ECOCHospDr; //hxy 2019-12-24
		tmp=tmp+"^"+rowsData[i].ECOCProTp+"^"+rowsData[i].ECOCProp; //hxy 2020-03-02 职称描述^性质描述
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCEMConsOrd","Save",{"Params":params},function(string){
	
		if (string==1){
			$.messager.alert('提示','数据重复,请核实后再试！','error');	
		}
		
		if (string==0){
			$.messager.alert('提示','保存成功！','info');
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
	
	var HospDr=hospComp.getValue(); //hxy 2020-05-28
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ECOCRowID:'', ECOCLoc:'', ECOCLocID:'', ECOCArci:'', ECOCArciID:'', ECOCType:'', ECOCTypeID:'', ECOCProTp:'', ECOCProTpID:'', ECOCInsType:'', ECOCInsTypeID:'',ECOCHosp:HospDr,ECOCHospDr:HospDr} //hxy 2019-12-24 ,ECOCHosp:LgHospID,ECOCHospDr:LgHospID //2020-05-28 LgHospID->HospDr
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
				runClassMethod("web.DHCEMConsOrd","Delete",{"ID":rowsData.ECOCRowID},function(jsonString){
					if (jsonString != 0){
						$.messager.alert('提示','删除失败！','info');
					}
					$('#dgMainList').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','info');
		 return;
	}
}

/// 文本编辑格
var textEditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}
	
// 科室编辑格
var LocEditor={  //设置其为可编辑
	type: 'combobox',//设置编辑格式
	options: {
		url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsLoc",
		valueField: "value", 
		textField: "text",
		mode:'remote',
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLoc'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLocID'});
			$(ed.target).val(option.value);
		},
		onShowPanel:function(){ //hxy 2019-12-24 st
			/*var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHospDr'}); 
			var HospID=$(ed.target).val(); 
			if(HospID==undefined){HospID=""}
			if(HospID==""){
				$.messager.alert('提示',"请先选择医院!");
				return;
			}*/ //hxy 2020-05-28 注释
	        //var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsLoc&HospID="+hospComp.getValue(); //hxy 2020-05-28 原：HospID
	        var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsLocNew&HospID="+hospComp.getValue(); //hxy 2020-09-22
	        var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLoc'});
			$(ed.target).combobox('reload', url);
		}, //ed
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLocID'});
				$(ed.target).val("");
			}
		}
	}
}

// 职称编辑格
var PrvTpEditor={  //设置其为可编辑
	type: 'combobox',//设置编辑格式
	options: {
		url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTpBak",
		valueField: "value", 
		textField: "text",
		editable:true,
		enterNullValueClear:false,
		//panelHeight:"auto",  //设置容器高度自动增长
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProTp'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProTpID'});
			$(ed.target).val(option.value);
		},
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProTpID'});
				$(ed.target).val("");
			}
		}
	}
}

// 医嘱编辑格
var ArciEditor={  //设置其为可编辑
	type: 'combobox',//设置编辑格式
	options: {
		//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsArci", //hxy 2019-12-24
		valueField: "value", 
		textField: "text",
		mode:'remote',
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArci'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArciID'});
			$(ed.target).val(option.value);
		},
		onShowPanel:function(){ //hxy 2019-12-24 st
			/*var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHosp'}); 
			var HospID=$(ed.target).combobox('getValue'); //ed
			if(isNaN(HospID)){ //hxy 2020-03-04
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHospDr'}); 
				var HospID=$(ed.target).val(); 
			}//ed
			if(HospID==undefined){HospID=""}
			if(HospID==""){
				$.messager.alert('提示',"请先选择医院!");
				return;
			}*/
	        var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsArci&HospID="+hospComp.getValue(); //hxy 2020-05-28
	        var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArci'});
			$(ed.target).combobox('reload', url);
		}, //ed
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArciID'});
				$(ed.target).val("");
			}
		}
	}
}


// 生成方式编辑格
var InsertTypeEditor={  //设置其为可编辑
	type: 'combobox',//设置编辑格式
	options: {
		//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=QryEmConsInsType",
		valueField: "value", 
		textField: "text",
		mode:'remote',
		data:[
			{value:"A",text:"申请产生"},
			{value:"E",text:"完成产生"}
		],
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCInsType'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCInsTypeID'});
			$(ed.target).val(option.value);
		},
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCInsTypeID'});
				$(ed.target).val("");
			}
		}
	}
}


// 会诊类型
var TypeEditor={  //设置其为可编辑
	type: 'combobox',//设置编辑格式
	options: {
		valueField: "value", 
		textField: "text",
		mode:'remote',
		/*data:[
			{value:"I",text:"院内会诊"},
			{value:"O",text:"院外会诊"}
		],*/
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCType'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCTypeID'});
			$(ed.target).val(option.value);
			
		},
		onShowPanel:function(){ //hxy 2021-02-27 st
	        var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonAllCstType&HospID="+hospComp.getValue() //+"&Ord=Y";
	        var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCType'});
			$(ed.target).combobox('reload', url);
		}, //ed
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCTypeID'});
				$(ed.target).val("");
			}
		}
	}
}

// 会诊性质
var PropEditor = {  //设置其为可编辑
	type: 'combobox',//设置编辑格式
	options: {
		//url: $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=CNAT&HospID="+session['LOGON.HOSPID'], //hxy 2020-05-28 注释
		valueField: "value", 
		textField: "text",
		mode:'remote',
		enterNullValueClear:false,
		onSelect:function(option){
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProp'});
			$(ed.target).combobox ("setValue",option.text);
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCPropID'});
			$(ed.target).val(option.value);
			
		},
		onShowPanel:function(){ //hxy 2020-05-28 st
	        var url = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=CNAT&HospID="+hospComp.getValue();
	        var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCProp'});
			$(ed.target).combobox('reload', url);
		}, //ed
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCPropID'});
				$(ed.target).val("");
			}
		}
	}
}

//医院 //hxy 2019-12-24
var hospEditor={  //设置其为可编辑
	type: 'combobox',//设置编辑格式
	options: {
		url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
		valueField: "value", 
		textField: "text",
		required:true,
		editable:false, 
		panelHeight:"auto", //设置容器高度自动增长
		onSelect:function(option){
			var Hosped=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHosp'});
			$(Hosped.target).val(option.text);  //设置医院
			var HospIDed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCHospDr'});
			$(HospIDed.target).val(option.value);  //设置医院ID
			
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLoc'});
			$(ed.target).combobox("setValue","");
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCLocID'});
			$(ed.target).val("");
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArci'});
			$(ed.target).combobox("setValue","");
			var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ECOCArciID'});
			$(ed.target).val("");
		}
	}
}

//查询 //hxy 2019-12-24
function Query()
{
	var hospDrID=hospComp.getValue(); //hxy 2020-05-28 原：$('#hospDrID').combobox('getValue');  
	if(hospDrID==undefined){hospDrID=""}               
	var params=hospDrID;
    $('#dgMainList').datagrid('load',{params:params}); 		
}