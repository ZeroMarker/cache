/// author:    bianshuai
/// date:      2018-08-28
/// descript:  科室亚专业/指症关联维护

var editRow = "";
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
/// 页面初始化函数
function initPageDefault(){
	
	//初始化医院 hxy 2020-05-28
    InitHosp();
    
	//初始化列表
	InitMainList();
	
	//初始化界面按钮事件
	InitWidListener();
}

function InitHosp(){
	hospComp = GenHospComp("DHC_EmConsHosLoc");  //hxy 2020-05-28 st
	hospComp.options().onSelect = function(){///选中事件
		Query();
	}//ed
}

/// 界面元素监听事件
function InitWidListener(){
	
}

///初始化列表
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
	
	// 医院编辑格
	var HospEditor = {
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			//url: $URL + "?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+LgHospID, //hxy 2020-05-28 注释
			enterNullValueClear:false,
			onShowPanel:function(){ //hxy 2020-05-28 st
		        var url = $URL + "?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+hospComp.getValue();
		        var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmHosp'});
				$(ed.target).combobox('reload', url);
			}, //ed
			onSelect:function(option) {
				/// 医院ID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmHosID'});
				$(ed.target).val(option.value);
				/// 医院
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmHosp'});
				$(ed.target).combobox('setValue', option.text);
				
//				///设置级联指针
//				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmLoc'});
//				var unitUrl=$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=LOC&HospID="+LgHospID;
//				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	// 科室编辑格
	var LocEditor = {
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			url: '',
			enterNullValueClear:false,
			onSelect:function(option) {
				/// 科室ID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmLocID'});
				$(ed.target).val(option.value);
				/// 科室
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmLoc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				
				///设置级联指针
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'itmLoc'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=LOC&HospID="+hospComp.getValue(); //hxy 2020-05-28 原：LgHospID
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'itmHosID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'itmHosp',title:'医院',width:300,editor:HospEditor,align:'center'},
		{field:'itmLocID',title:'LocID',width:100,editor:textEditor,hidden:true},
		{field:'itmLoc',title:'科室',width:300,editor:LocEditor,align:'center'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=QryEmConsHosLoc&params="+hospComp.getValue(); //hxy 2020-05-28 &params="+hospComp.getValue()
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
		
		if(rowsData[i].itmHosID == ""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].itmHosID +"^"+ rowsData[i].itmLocID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCEMConsHosLoc","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','数据重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#main').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}

	/// 检查第一行是否为空行
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].itmHosID == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}

	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', itmHosID:'', itmHosp:'', itmLocID:'', itmLoc:''}
	});
	$("#main").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMConsHosLoc","delete",{"ID":rowsData.ID},function(jsonString){
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

function Query()
{
	var HospDr=hospComp.getValue();  
    $('#main').datagrid('load',{params:HospDr}); 		
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })