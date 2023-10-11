/// author:    bianshuai
/// date:      2018-06-20
/// descript:  会诊申请MDT小组字典维护

var editRow = ""; editDRow = "";
TypeCode="";
var TypeFlagArr = [{"value":"NUR","text":'护士专科组'}, {"value":"DOC","text":'医师大科'}]; //hxy 2021-06-18
/// 页面初始化函数
function initPageDefault(){
	//初始化医院 hxy 2020-05-28
	InitHosp();
	
	//初始化咨询信息列表
	InitMainList();
	
	//初始化咨询信息列表
	InitItemList();
	
	//初始化界面按钮事件
	InitWidListener();
}

function InitHosp(){
	hospComp = GenHospComp("DHC_EmConsultGroup");  //hxy 2020-05-12 st
	hospComp.options().onSelect = function(){///选中事件
		query();
	}//ed
}

/// 界面元素监听事件
function InitWidListener(){
	
}

///初始化病人列表
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
			url:$URL+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
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
		
	// 科室成员
	var TLeaderEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonUser",
			url: "",
			valueField: "value", 
			textField: "text",
			//editable:false,
			mode:'remote',
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeaderID'});
				$(ed.target).val(option.value);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeader'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'Type'}); //hxy 2021-06-28 st
				var Type=$(ed.target).val();
				if(Type==""){
					$.messager.alert("提示","请选择类型!");
					return;
				} //ed

				///设置级联指针
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeader'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonUser&HospID="+hospComp.getValue()+"&Type="+Type; //hxy 2020-05-28 &HospID="+hospComp.getValue()
				$(ed.target).combobox('reload',unitUrl);
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeaderID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	//类型设置其为可编辑 //hxy 2021-06-18
	var typeEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			required: true,
			data: TypeFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			editable:false,
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TypeDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
				
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeaderID'});
				$(ed.target).val("");
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeader'});
				$(ed.target).combobox('setValue', "");
			}
		}
	}

	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'left'}, //hxy 2020-04-30 左对齐
		{field:'Code',title:'代码',width:100,editor:textEditor,align:'left'},
		{field:'Desc',title:'描述',width:140,editor:textEditor,align:'left'},
		{field:'Type',title:'类型',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'TypeDesc',title:'类型',width:110,editor:typeEditor,align:'left'},
		{field:'TLeaderID',title:'TLeaderID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'TLeader',title:'组长',width:100,editor:TLeaderEditor,align:'left'},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'ActDesc',title:'是否可用',width:80,editor:activeEditor,align:'left'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'HospDesc',title:'医院',width:200,editor:HospEditor,align:'left',hidden:true} //hxy 2020-05-28 hidden
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'会诊科室组维护-专科组/大科', //hxy 2020-04-30 st
		headerCls:'panel-header-gray', 
		border:true,
		iconCls:'icon-paper',//ed
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
	    	//注意要在开启行编辑之**前**完成设置editor为空的操作 2021-06-21
	    	var ee = $('#main').datagrid('getColumnOption', 'TypeDesc');
	    	if(rowData.ID!=""){			
				ee.editor={};    
	        }else{
				ee.editor=typeEditor;
		    }
	    	
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        TypeCode=rowData.Type;
	        /// MDT小组成员列表
			var uniturl = $URL+"?ClassName=web.DHCEMConsultGroup&MethodName=QryConsultGroupItm&ID="+rowData.ID;
			$("#item").datagrid({url:uniturl});
			if(rowData.Type=="DOC"){ //hxy 2021-06-18
				$('#item').datagrid('hideColumn', 'User');
				$('#item').datagrid('hideColumn', 'ContactsFlag');
				$('#item').datagrid('hideColumn', 'DefFlag');
			}else{
				$('#item').datagrid('showColumn', 'User');
				$('#item').datagrid('showColumn', 'ContactsFlag');
				$('#item').datagrid('showColumn', 'DefFlag');
				
			}
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsultGroup&MethodName=QryConsultGroup&params="+hospComp.getValue();
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
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}
		if((rowsData[i].Type=="DOC")&&(rowsData[i].TLeaderID=="")){ //hxy 2021-06-18
			$.messager.alert("提示","医师大科请选择组长!"); 
			return false;
		}
		
		var TLeaderID=rowsData[i].TLeaderID; //hxy 2020-09-22 st
		if(rowsData[i].TLeader==""){
			TLeaderID="";
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +"^"+ TLeaderID +"^"+ rowsData[i].Type; //hxy 2020-09-22 rowsData[i]. //ed
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCEMConsultGroup","Save",{"mListData":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#main').datagrid('reload'); //重新加载
		$('#item').datagrid('loadData',{total:0,rows:[]}); //hxy 2021-06-21
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
	
	var HospDr=hospComp.getValue(); //hxy 2020-05-28
	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'是', HospID:HospDr, HospDesc:'',TypeDesc:''} //hxy 2020-05-28 HospID:''
	});
	
	//注意要在开启行编辑之**前**完成设置editor为空的操作 2021-06-21
	var ee = $('#main').datagrid('getColumnOption', 'TypeDesc');
	ee.editor={
		type: 'combobox',     //设置编辑格式
		options: {
			required: true,
			data: TypeFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			editable:false,
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TypeDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
				
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeaderID'});
				$(ed.target).val("");
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeader'});
				$(ed.target).combobox('setValue', "");
			}
		}
	};
	
	$("#main").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMConsultGroup","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('提示','此项已和医嘱项绑定,不能删除！','warning');
					}
					$('#main').datagrid('reload'); //重新加载
					$('#item').datagrid('loadData',{total:0,rows:[]}); //hxy 2021-06-21
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

///初始化病人列表
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
			//url: $URL +"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+session['LOGON.HOSPID'], //hxy 2020-05-28 注释
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
				/*
				///设置级联指针
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocUser&LocID="+ option.value;
				$(ed.target).combobox('reload',unitUrl);
				*/
			},
			onShowPanel:function(){ //hxy 2020-06-04
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocDesc'});
				//var unitUrl=$URL +"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+hospComp.getValue();
				var LType="CONSULTWARD"; //hxy 2021-06-10 st
				var rowData = $("#main").datagrid("getSelected");
				if(rowData.Type=="DOC"){
					LType="CONSULT";
				}
				var unitUrl=$URL +"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&HospID="+hospComp.getValue()+"&LType="+LType; //hxy 2020-09-21 //ed
				//var unitUrl=$URL +"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&HospID="+hospComp.getValue()+"&LType=CONSULTWARD"; //hxy 2020-09-21 //ed
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	// 科室成员
	var UserEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonUser",
			url: "",
			valueField: "value", 
			textField: "text",
			//required: true, //hxy 2020-09-23
			//editable:false,
			mode:'remote',
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///设置级联指针
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocUser&LocID="+ LocID +"&Type=NURSE"+"&HospID="+hospComp.getValue();
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
	
	//设置其为可编辑
	var DefEditor ={
		type: 'combobox',     //设置编辑格式
		options: {
			data: TempArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'DefFlagID'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'DefFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'left'}, //hxy 2020-04-30 左对齐
		{field:'MasID',title:'MasID',width:100,hidden:true,align:'left'},
		{field:'LocID',title:'LocID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'LocDesc',title:'科室',width:220,editor:LocEditor,align:'left'},
		{field:'UserID',title:'UserID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'User',title:'人员',width:140,editor:UserEditor,align:'left'},
		{field:'ContactsID',title:'ContactsID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'ContactsFlag',title:'联络人标志',width:100,editor:ContractEditor,align:'left'},
		{field:'DefFlagID',title:'DefFlagID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'DefFlag',title:'默认标志',width:100,editor:DefEditor,align:'left'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'专科组成员科室/大科科室', //hxy 2020-04-30 st
		headerCls:'panel-header-gray', 
		border:true,
		iconCls:'icon-paper',//ed
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editDRow != "")||(editDRow == "0")) { 
                $("#item").datagrid('endEdit', editDRow); 
            } 
            $("#item").datagrid('beginEdit', rowIndex); 
            editDRow = rowIndex;
        }
	};
	
	var uniturl = ""; //$URL+"?ClassName=web.DHCEMConsultGroup&MethodName=QryConsultGroupItm";
	new ListComponent('item', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}

	var rowsData = $("#item").datagrid('getChanges');
	var allRowData = $("#item").datagrid('getData').rows;
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	/*var allHasUserID="";
	for(var i=0;i<allRowData.length;i++){		///判断重复人员
		if((allRowData[i].UserID!="")&&(allHasUserID.indexOf("^"+allRowData[i].UserID+"^")!=-1)){
			$.messager.alert("提示","存在重复的人员信息，重复人员："+allRowData[i].User); 
			return false;	
		}
		allHasUserID==""?allHasUserID="^"+allRowData[i].UserID+"^":allHasUserID=allRowData[i].UserID+"^";
	}*/
	
	var  dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].LocID==""){
			$.messager.alert("提示","科室不能为空!"); 
			return false;
		}
		if((rowsData[i].UserID=="")&&(TypeCode=="NUR")){
			$.messager.alert("提示","人员不能为空!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].MasID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].UserID +"^"+ rowsData[i].ContactsID +"^"+ rowsData[i].DefFlagID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCEMConsultGroup","SaveItem",{"mListData":mListData},function(jsonString){
		
		if (jsonString == "-1"){ //hxy 2020-08-11
			$.messager.alert('提示','人员重复,请核实后再试！','warning');
			return;	
		}
		if (jsonString == "-2"){ //hxy 2021-06-18
			$.messager.alert('提示','科室重复,请核实后再试！','warning');
			return;	
		}
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#item').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertItmRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择专科小组!");
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
		row: {MasID:ID, ID:'', LocID:'', LocDesc:'', UserID:'', User:'', ContactsID:'', ContactsFlag:''}
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
				runClassMethod("web.DHCEMConsultGroup","deleteItem",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('提示','此项已和医嘱项绑定,不能删除！','warning');
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

function query(){
	var HospDr=hospComp.getValue();
	var Type = $HUI.combobox("#typeBox").getValue(); //hxy 2021-06-18
	$("#main").datagrid( { 
		url:$URL+"?ClassName=web.DHCEMConsultGroup&MethodName=QryConsultGroup&params="+HospDr+"^"+Type
	})
	$('#item').datagrid('loadData',{total:0,rows:[]});
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })