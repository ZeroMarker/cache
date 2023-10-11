/// author:    bianshuai
/// date:      2019-04-16
/// descript:  MDT疑难病种分组维护
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var editRow = ""; editDRow = ""; editPRow = "",editCRow=0,editURow =0,editARow=0;
/// 页面初始化函数
function initPageDefault(){
	
	init(); //ylp 初始化医院 //20230222
	//初始化字典类型列表
	InitMainList();
	
	//初始化字典项目列表
	InitItemList();
	
	//初始化界面按钮事件
	InitWidListener();
	
	///初始化字典属性列表
	InitDetailList();
	
	///初始化医嘱字典表
	InitConsOrdList();
	
	InitConsPurList();
	
	InitAppUserList();
	
	InitAppUserAutList();
	
	///初始化MDT反馈次数维护列表 xiaowenwu 2020-03-05
	InitFeedbackNumList();
	
	/// 页面 tabs
	InitPageTabs();
}
function init(){
	
	hospComp = GenHospComp("DHC_EmConsDicType");  //hxy 2020-05-27 st //2020-05-31 add
	hospComp.options().onSelect = function(){///选中事件
		$("#main").datagrid('reload',{params:hospComp.getValue()});
	}

	$('#queryBTN').on('click',function(){
		$("#main").datagrid('reload',{params:hospComp.getValue()});
	 })
		
}

/// 界面元素监听事件
function InitWidListener(){
	
}

/// 页面 tabs
function InitPageTabs(){
	
	$('#tag_id').tabs({ 
		onSelect:function(title){
			switch (title){
				case "外院专家":
					if ($("#tab_req").attr("src") == "") $("#tab_req").attr('src',$("#tab_req").attr("data-src"));
					break;
				default:
					return;
			}
		}
	}); 
}

///初始化字典类型列表
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
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActDesc'});
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
			editable:false,
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetHospDs"+"&MWToken="+websys_getMWToken(),
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'代码',width:100,editor:textEditor},
		{field:'Desc',title:'描述',width:150,editor:textEditor},
		{field:'Addr',title:'会诊地点',width:150,editor:textEditor},
		{field:'Notes',title:'备注',width:150,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'启用',width:80,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'HospDesc',title:'医院',width:200,editor:HospEditor,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        	        
	        /// 成员科室列表
			$("#item").datagrid('reload',{ID:rowData.ID});
			
			/// 科室号别列表
			$("#detail").datagrid('reload',{mID:rowData.ID});
			
			/// 医嘱设置
			$("#consOrd").datagrid('reload',{mID:rowData.ID});
			
			/// 模板设置
			$("#consPur").datagrid('reload',{mID:rowData.ID});
			
			/// 申请权限设置
			$("#consAppUser").datagrid('reload',{GropID:rowData.ID});
			
			$("#consAppUserAut").datagrid('reload',{DARowID:0});
			
			$("#feedbackNum").datagrid('reload',{mID:rowData.ID});
			
			/// 外院专家
			frames[0].window.location.reload()
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=QryGroup"+"&params="+hospComp.getValue()+"&MWToken="+websys_getMWToken();
	new ListComponent('main', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!","warning"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!","warning"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID+"^"+rowsData[i].Addr+"^"+rowsData[i].Notes;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTGroup","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
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
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'是', HospID:hospComp.getValue(), HospDesc:'',Notes:''}
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
				runClassMethod("web.DHCMDTGroup","delete",{"ID":rowsData.ID},function(jsonString){
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

///初始化字典项目列表
function InitItemList(){
	
	/**
	 * 文本编辑格
	 */
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID']+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocID'});
				$(ed.target).val(option.value);
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'UserID'});
				$(ed.target).val("");
				
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
			}
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
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///设置级联指针
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	
	// 科室成员
	var UserEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			//url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonUser",
			url: "",
			valueField: "value", 
			textField: "text",
			//editable:false,
			mode:'remote',
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				$(ed.target).combobox('setValue', option.text);
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTp",
					UserID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
					var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocID'});
				    var LocID = $(ed.target).val();
				});
				
			},
			onShowPanel:function(){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocUser&LocID="+ LocID+"&PrvTpID="+PrvTpID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	var TempArr = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
	//设置其为可编辑
	var ContractEditor ={
		type: 'combobox',     //设置编辑格式
		options: {
			data: TempArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'ContactsID'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'ContactsFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'mID',title:'mID',width:100,hidden:true},
		{field:'LocID',title:'LocID',width:100,editor:textEditor,hidden:true},
		{field:'LocDesc',title:'科室',width:220,editor:LocEditor},
		{field:'UserID',title:'UserID',width:100,editor:textEditor,hidden:true},
		{field:'User',title:'科室成员',width:140,editor:UserEditor},
		{field:'PrvTpID',title:'职称ID',width:100,editor:textEditor,hidden:true},
		{field:'PrvTp',title:'职称',width:160,editor:PrvTpEditor,hidden:false},
		{field:'ContactsID',title:'ContactsID',width:100,editor:textEditor,hidden:true},
		{field:'ContactsFlag',title:'联络人标识',width:100,editor:ContractEditor}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editDRow != "")||(editDRow == "0")) { 
                $("#item").datagrid('endEdit', editDRow); 
            } 
            $("#item").datagrid('beginEdit', rowIndex); 
            editDRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        	        
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=QryGroupItm&ID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('item', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}

	var rowsData = $("#item").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].LocID=="")||(rowsData[i].PrvTpID=="")){
			$.messager.alert("提示","科室或职称不能为空!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].mID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].PrvTpID +"^"+ rowsData[i].UserID +"^"+ rowsData[i].ContactsID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTGroup","saveItm",{"mParam":mListData},function(jsonString){

		if (jsonString == "-1"){
			$.messager.alert('提示','科室人员重复,请核实后再试！','warning');
			return;	
		}else if (jsonString == "-2"){
			$.messager.alert('提示','联络人重复,请核实后再试！','warning');
			return;
		}
		$('#item').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertItmRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择MDT小组!");
		return;
	}
	var ID = rowData.ID;   /// MDT小组ID
	
	if(editDRow >= "0"){
		$("#item").datagrid('endEdit', editDRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#item").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#item').datagrid('selectRow',0);
			$("#item").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#item").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {mID:ID, ID:'', LocID:'', LocDesc:'', UserID:'', User:'', ContactsID:'', ContactsFlag:'N'}
	});
	$("#item").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editDRow=0;
}

/// 删除选中行
function deleteItmRow(){
	
	var rowsData = $("#item").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTGroup","deleteItem",{"ID":rowsData.ID},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('提示','此项目已使用，不允许删除！','warning');
					}else if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#item').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}


///初始化属性列表
function InitDetailList(){
	
	/**
	 * 文本编辑格
	 */
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
			url: '',
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocID'});
				$(ed.target).val(option.value);
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvID'});
				$(ed.target).val("");
			},
			onShowPanel:function(){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'HospID'});
				var HospID = $(ed.target).val();
				///设置级联指针
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocDesc'});
				var unitUrl=$URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+HospID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	// 资源号别
	var PrvEditor = {  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			//editable:false,
			onSelect:function(option){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvID'});
				$(ed.target).val(option.value);
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///设置级联指针
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=jsonLocCare&LocID="+ LocID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'mID',title:'mID',width:100,hidden:true},
		{field:'LocID',title:'LocID',width:100,editor:textEditor,hidden:true},
		{field:'LocDesc',title:'科室',width:220,editor:LocEditor},
		{field:'PrvID',title:'PrvID',width:100,editor:textEditor,hidden:true},
		{field:'PrvDesc',title:'号别',width:220,editor:PrvEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editPRow != "")||(editPRow == "0")) { 
                $("#detail").datagrid('endEdit', editPRow); 
            } 
            $("#detail").datagrid('beginEdit', rowIndex); 
            editPRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTCareProv&MethodName=QryCareProv&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('detail', columns, uniturl, option).Init();
}


///初始化属性列表
function InitConsOrdList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 资源号别
	var ArciEditor = {  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#consOrd").datagrid('getEditor',{index:editCRow,field:'ArciID'});
				$(ed.target).val(option.value);
				var ed=$("#consOrd").datagrid('getEditor',{index:editCRow,field:'Arci'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#consOrd").datagrid('getEditor',{index:editCRow,field:'Arci'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTOrdConfig&MethodName=ListArci"+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'mID',title:'mID',width:100,hidden:false},
		{field:'ArciID',title:'ArciID',width:100,editor:textEditor,hidden:true},
		{field:'Arci',title:'会诊医嘱',width:220,editor:ArciEditor},
		{field:'ArciNum',title:'数量',width:100,editor:textEditor}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editCRow != "")||(editCRow == "0")) { 
                $("#consOrd").datagrid('endEdit', editCRow); 
            } 
            $("#consOrd").datagrid('beginEdit', rowIndex); 
            editCRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTOrdConfig&MethodName=QryList&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('consOrd', columns, uniturl, option).Init();
}

///初始化属性列表
function InitAppUserList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 人员类型
	var TypeEditor = {  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'PointerID'});
				$(ed.target).val("");
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Pointer'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'TypeID'});
				$(ed.target).val(option.value);
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Type'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Type'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTDocAppAut&MethodName=JsonListAutType"+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	
	// 类型列表
	var PointerEditor = {  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'PointerID'});
				$(ed.target).val(option.value);
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'TypeID'});
				var TypeID=$(ed.target).val();
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Pointer'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTDocAppAut&MethodName=JsonListAutPointer&TypeID="+TypeID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Type',title:'类型',width:150,hidden:false,editor:TypeEditor},
		{field:'TypeID',title:'类型ID',width:100,editor:textEditor,hidden:true},
		{field:'Pointer',title:'指针',width:250,editor:PointerEditor},
		{field:'PointerID',title:'指针ID',width:100,editor:textEditor,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		onClickRow:function(rowIndex, rowData){
			$("#consAppUserAut").datagrid("load",{DARowID:rowData.ID});
		},
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editURow != "")||(editURow == "0")) { 
                $("#consAppUser").datagrid('endEdit', editURow); 
            } 
            $("#consAppUser").datagrid('beginEdit', rowIndex); 
            editURow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTDocAppAut&MethodName=QryDocAutItm&GropID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('consAppUser', columns, uniturl, option).Init();
}


///初始化属性列表
function InitAppUserAutList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 授权类型
	var DicItmEditor = {  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#consAppUserAut").datagrid('getEditor',{index:editARow,field:'DicItmID'});
				$(ed.target).val(option.value);
				var ed=$("#consAppUserAut").datagrid('getEditor',{index:editARow,field:'DicItm'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#consAppUserAut").datagrid('getEditor',{index:editARow,field:'DicItm'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonListDitItm&DicCode=AppAut&LgParams="+LgParams+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'DicItm',title:'授权类型',width:450,hidden:false,editor:DicItmEditor},
		{field:'DicItmID',title:'授权类型ID',width:100,editor:textEditor,hidden:true},
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		pagination:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		onClickRow:function(rowIndex, rowData){
			
		},
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editARow != "")||(editARow == "0")) { 
                $("#consAppUserAut").datagrid('endEdit', editARow); 
            } 
            $("#consAppUserAut").datagrid('beginEdit', rowIndex); 
            editARow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTDocAppAut&MethodName=QryDocAutDicItm&DARowID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('consAppUserAut', columns, uniturl, option).Init();
}
/// 保存编辑行
function saveDetRow(){
	
	if(editPRow>="0"){
		$("#detail").datagrid('endEdit', editPRow);
	}

	var rowsData = $("#detail").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].LocID=="")||(rowsData[i].UserID=="")){
			$.messager.alert("提示","科室或号别不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].mID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].PrvID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTCareProv","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#detail').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertDetRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择病种分组!","warning");
		return;
	}
	var ID = rowData.ID;           /// 主项目ID
	var HospID = rowData.HospID;   /// 医院ID
	
	if(editPRow >= "0"){
		$("#detail").datagrid('endEdit', editPRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#detail").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#detail').datagrid('selectRow',0);
			$("#detail").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	if (rowsData.length >= 1) {
		$.messager.alert("提示","已维护号别，请删除再新增","warning");
		return;
	}
	
	$("#detail").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {mID:ID, ID:'', LocID:'', LocDesc:'', PrvID:'', PrvDesc:'', HospID:HospID}
	});
	$("#detail").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editPRow=0;
}

/// 删除选中行
function deleteDetRow(){
	
	var rowsData = $("#detail").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTCareProv","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#detail').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}


/// 插入新行
function insertOrdRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择病种分组!","warning");
		return;
	}
	var ID = rowData.ID;           /// 主项目ID
	var HospID = rowData.HospID;   /// 医院ID
	
	if(editCRow >= "0"){
		$("#consOrd").datagrid('endEdit', editCRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#consOrd").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#consOrd').datagrid('selectRow',0);
			$("#consOrd").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#consOrd").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {mID:ID, ID:'', ArciID:'', Arci:''}
	});
	$("#consOrd").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editCRow=0;
}

/// 删除选中行
function deleteOrdRow(){
	
	var rowsData = $("#consOrd").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTOrdConfig","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#consOrd').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}


/// 保存编辑行
function saveOrdRow(){
	
	if(editCRow>="0"){
		$("#consOrd").datagrid('endEdit', editCRow);
	}

	var rowsData = $("#consOrd").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].LocID=="")||(rowsData[i].UserID=="")){
			$.messager.alert("提示","科室或号别不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].mID +"^"+ rowsData[i].ArciID+"^"+rowsData[i].ArciNum ;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTOrdConfig","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
	
		$("#consOrd").datagrid('reload');
	})
}


///yzy
///初始化属性列表
function InitConsPurList(){
	
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
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Pointer',title:'mID',width:100,hidden:true},
		{field:'Title',title:'标题',width:100,editor:textEditor},
		{field:'Text',title:'标题内容',width:220,editor:textEditor},
		
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editPRow != "")||(editPRow == "0")) { 
                $("#consPur").datagrid('endEdit', editPRow); 
            } 
            $("#consPur").datagrid('beginEdit', rowIndex); 
            editPRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTemp&MethodName=QryOpiTemp&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('consPur', columns, uniturl, option).Init();
}

/// 保存编辑行
function saveconsPurRow(){
	
	if(editPRow>="0"){
		$("#consPur").datagrid('endEdit', editPRow);
	}

	var rowsData = $("#consPur").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((trim(rowsData[i].Title) == "")||(trim(rowsData[i].Text) == "")){
			$.messager.alert("提示","标题或内容不能为空!",'warning'); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Pointer +"^"+ rowsData[i].Title +"^"+ rowsData[i].Text;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTemp","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#consPur').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertconsPurRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择病种分组!","warning");
		return;
	}
	var ID = rowData.ID;           /// 主项目ID
	
	
	if(editPRow >= "0"){
		$("#consPur").datagrid('endEdit', editPRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#consPur").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].MTTitles == ""){
			$('#consPur').datagrid('selectRow',0);
			$("#consPur").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#consPur").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {Pointer:ID, ID:'', Title:'', Text:'',}
	});
	$("#consPur").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editPRow=0;
}

/// 删除选中行
function deleteconsPurRow(){
	
	var rowsData = $("#consPur").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTemp","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#consPur').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 插入新行
function insertAppUserRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择病种分组!","warning");
		return;
	}
	var ID = rowData.ID;           /// 主项目ID
	var HospID = rowData.HospID;   /// 医院ID
	
	if(editURow >= "0"){
		$("#consAppUser").datagrid('endEdit', editURow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#consAppUser").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].TypeID == ""){
			$('#consAppUser').datagrid('selectRow',0);
			$("#consAppUser").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#consAppUser").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'',Pointer:'', PointerID:'', Type:'', TypeID:''}
	});
	$("#consAppUser").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editURow=0;
}


/// 删除选中行
function deleteAppUserRow(){
	
	var rowsData = $("#consAppUser").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTDocAppAut","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#consAppUser').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 保存编辑行
function saveAppUserRow(){
	
	if(editURow>="0"){
		$("#consAppUser").datagrid('endEdit', editURow);
	}
	
	var rowData = $("#main").datagrid("getSelected");
	var GropID = rowData.ID;           /// 主项目ID

	var rowsData = $("#consAppUser").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}

	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].TypeID=="")||(rowsData[i].PointerID=="")){
			$.messager.alert("提示","类型或指针值不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ GropID +"^"+ rowsData[i].TypeID +"^"+ rowsData[i].PointerID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTDocAppAut","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-2"))){
			$.messager.alert('提示','记录重复,请核实后再试！','warning');
			return;	
		}
	
		$("#consAppUser").datagrid('reload');
	})
}


/// 插入新行
function insertAppAutRow(){
	
	var rowData = $("#consAppUser").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择授权人员!","warning");
		return;
	}
	var ID = rowData.ID;           /// 主项目ID
	
	if(editARow >= "0"){
		$("#consAppUserAut").datagrid('endEdit', editARow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#consAppUserAut").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].TypeID == ""){
			$('#consAppUserAut').datagrid('selectRow',0);
			$("#consAppUserAut").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#consAppUserAut").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'',DicItm:'', DicItmID:''}
	});
	$("#consAppUserAut").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editARow=0;
}


/// 删除选中行
function deleteAppAutRow(){
	
	var rowsData = $("#consAppUserAut").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTDocAppAut","deleteAut",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#consAppUserAut').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 保存编辑行
function saveAppAutRow(){
	
	if(editARow>="0"){
		$("#consAppUserAut").datagrid('endEdit', editARow);
	}
	
	var rowData = $("#consAppUser").datagrid("getSelected");
	var AppUserID = rowData.ID;           /// 主项目ID

	var rowsData = $("#consAppUserAut").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}

	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].DicItmID==""){
			$.messager.alert("提示","授权类型不能为空！"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ AppUserID +"^"+ rowsData[i].DicItmID ;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTDocAppAut","saveAut",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
	
		$("#consAppUserAut").datagrid('reload');
	})
}

///初始化MDT反馈次数维护列表 xiaowenwu 2020-03-05
function InitFeedbackNumList(){
	
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
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'mID',title:'mID',width:100,hidden:true,align:'center'},
		{field:'MDTimes',title:'次数',width:100,editor:textEditor,align:'center'},
		{field:'MDInterval',title:'间隔时间(天)',width:100,editor:textEditor,align:'center'},
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editPRow != "")||(editPRow == "0")) { 
                $("#feedbackNum").datagrid('endEdit', editPRow); 
            } 
            $("#feedbackNum").datagrid('beginEdit', rowIndex); 
            editPRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTFolUpTimes&MethodName=QryFolUpTimes&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('feedbackNum', columns, uniturl, option).Init();
}

/// 插入新行 xiaowenwu 2020-03-05
function insertFeeRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择病种分组!","warning");
		return;
	}
	var ID = rowData.ID;           /// 主项目ID
	var HospID = rowData.HospID;   /// 医院ID
	
	if(editCRow >= "0"){
		$("#feedbackNum").datagrid('endEdit', editCRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#feedbackNum").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#feedbackNum').datagrid('selectRow',0);
			$("#feedbackNum").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#feedbackNum").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {mID:ID, ID:'', MDTimes:'', MDInterval:''}
	});
	$("#feedbackNum").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editCRow=0;
}

/// 删除选中行 xiaowenwu 2020-03-05
function deleteFeeRow(){
	
	var rowsData = $("#feedbackNum").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTFolUpTimes","remove",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#feedbackNum').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}


/// 保存编辑行 xiaowenwu 2020-03-05
function saveFeeRow(){
	
	if(editCRow>="0"){
		$("#feedbackNum").datagrid('endEdit', editCRow);
	}

	var rowsData = $("#feedbackNum").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].MDTimes=="")||(rowsData[i].MDInterval=="")){
			$.messager.alert("提示","随访次数或时间间隔不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].mID +"^"+ rowsData[i].MDTimes+"^"+ rowsData[i].MDInterval;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTFolUpTimes","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
	
		$("#feedbackNum").datagrid('reload');
	})
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
