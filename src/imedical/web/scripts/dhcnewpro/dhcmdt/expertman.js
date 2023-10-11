//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2020-08-18
// 描述:	   MDT专家管理JS
//===========================================================================================

var editRow = -1;
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
		
/// 页面初始化函数
function initPageDefault(){
	init(); //ylp 初始化医院 //20230222
	InitParams();      /// 初始华参数
	InitComponents();  /// 初始化界面组件
	InitMainList();    /// 初始化交班列表
	InitMethod();
}
function init(){
	
	hospComp = GenHospComp("DHC_EmConsDicType");  //hxy 2020-05-27 st //2020-05-31 add
	hospComp.options().onSelect = function(){///选中事件
		$("#main").datagrid('reload',{GropHospID:hospComp.getValue()});
	}

	$('#queryBTN').on('click',function(){
		$("#main").datagrid('reload',{GropHospID:hospComp.getValue()});
	 })
		
}
function InitMethod(){
	window.onresize = function(){
	   $HUI.datagrid("#main").resize();
	}
}

/// 初始化页面参数
function InitParams(){
	
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
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			required:true,
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'prvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'prvTp'});
				$(ed.target).combobox('setValue', option.text);
				
			}
		}
	}
	
	/// 性别
	var SexEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			url:$URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTSex"+"&MWToken="+websys_getMWToken(),
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'userSex'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'sexID'});
				$(ed.target).val(option.value); 
			} 
	
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
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'actCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'actDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	/// 科室
	var LocEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:"",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onShowPanel:function(){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospID'});
				var hospID = $(ed.target).val();
				///设置级联指针
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'locDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTDicItem&MethodName=jsonParDicItem&mCode=OutLoc&HospID="+ hospID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			},
			onSelect:function(option){
				///设置类型值
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'locDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'locID'});
				$(ed.target).val(option.value); 
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
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospID'});
				$(ed.target).val(option.value); 
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'locDesc'});
				$(ed.target).combobox('setValue', "");
			} 
	
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'userCode',title:'工号',width:100,align:'center',editor:textEditor},
		{field:'userName',title:'姓名',width:200,align:'left',editor:textEditor},
		{field:'sexID',title:'性别ID',width:160,align:'left',editor:textEditor,hidden:true},
		{field:'userSex',title:'性别',width:100,align:'center',editor:SexEditor},
		{field:'prvTpID',title:'职称ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'prvTp',title:'职称',width:160,editor:PrvTpEditor,align:'center'},
		{field:'idCard',title:'身份证号',width:160,align:'left',editor:textEditor},
		{field:'locID',title:'外院科室ID',width:160,align:'left',editor:textEditor,hidden:true},
		{field:'locDesc',title:'外院科室',width:260,align:'left',editor:LocEditor},
		{field:'OutHosp',title:'外院名称',width:160,align:'left'},
		{field:'phone',title:'联系电话',width:120,align:'left',editor:textEditor},
		{field:'actCode',title:'actCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'actDesc',title:'启用',width:90,editor:activeEditor,align:'center'},
		{field:'hospID',title:'hospID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'hospDesc',title:'医院',width:200,editor:HospEditor,hidden:true,align:'center'}
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
	
            if ((editRow != -1)||(editRow == "0")) {
	            if (!$("#main").datagrid('validateRow', editRow)) return false;
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
		onLoadSuccess:function(data){

		}
	};
	/// 就诊类型
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCMDTExpertMan&MethodName=JsQryExpMan&GropHospID="+hospComp.getValue()+"&MWToken="+websys_getMWToken();
	new ListComponent('main', columns, uniturl, option).Init(); 
}

/// 保存编辑行
function saveRow(){
	
	if (!$("#main").datagrid('validateRow', editRow)){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	
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
		
		if((rowsData[i].userCode=="")||(rowsData[i].userName=="")){
			$.messager.alert("提示","工号或姓名不能为空!"); 
			return false;
		}
		if(rowsData[i].hospID==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}
		var tmp = rowsData[i].ID +"^"+ rowsData[i].userCode +"^"+ rowsData[i].userName +"^"+ rowsData[i].sexID +"^"+ rowsData[i].prvTpID;
		    tmp = tmp +"^"+ rowsData[i].idCard +"^"+ rowsData[i].locID +"^"+ rowsData[i].phone +"^"+ rowsData[i].actCode +"^"+ rowsData[i].hospID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTExpertMan","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','工号重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','姓名重复,请核实后再试！','warning');
			return;
		}
		$('#main').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if ((editRow != -1)||(editRow == "0")) {
		if (!$("#main").datagrid('validateRow', editRow)){
			$("#main").datagrid('selectRow', editRow).datagrid('beginEdit', editRow);
			return false;
		}
	}
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', userCode:'', userName:'', sexID:'', userSex:'', prvTpID:'', prvTp:'', special:'', idCard:'', locID:'', locDesc:'', phone:'', actCode:'Y', actDesc:'是', hospID:LgHospID, hospDesc:LgHospID}
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
				runClassMethod("web.DHCMDTExpertMan","delete",{"ID":rowsData.ID},function(jsonString){
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