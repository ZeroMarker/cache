/// 会诊申请病历授权
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var TakType=1;     //授权类型
/// 页面初始化函数
function initPageDefault(){

	initPageMainGrid();		  /// 授权列表datagrid
    initPageItemGrid();		  /// 授权历史datagrid
}

/// 页面DataGrid初始定义已选列表
function initPageMainGrid(){
	
	/// 编辑格
	var numbereditor={
		type: 'numberbox',//设置编辑格式
		options: {
			required: true, //设置编辑规则属性
			validType:'number'
		}
	}
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var TakOrdArr = [{"value":"1","text":$g('病历')}, {"value":"2","text":$g('医嘱')}];
	//设置其为可编辑
	var TakOrdEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: TakOrdArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				TakType =option.value;
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#main").datagrid('getEditor',{index:modRowIndex,field:'TakOrdFlag'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#main").datagrid('getEditor',{index:modRowIndex,field:'TakOrd'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
				$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			}
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'chk',checkbox:true,width:260,align:'center',hidden:true},
		{field:'itmID',title:'itmID',width:100,hidden:true},
		{field:'LocID',title:'科室ID',width:100,hidden:true},
		{field:'LocDesc',title:'科室',width:260},
		{field:'UserID',title:'医生ID',width:100,hidden:true},
		{field:'UserName',title:'医生',width:100},
		{field:'TakFlag',title:'TakFlag',width:100,hidden:true},
		{field:'TakTime',title:'授权时间(小时)',width:120,editor:numbereditor,align:'center'},
		{field:'TakOrdFlag',title:'TakOrdFlag',editor:texteditor,width:100,hidden:true},
		{field:'TakOrd',title:'权限名称',editor:TakOrdEditor,width:100,formatter:SetCellTakOrd},
		{field:'OperButton',title:'操作',width:140,align:'center',formatter:SetCellOperLink}
	]];
	
	///  定义datagrid
	var option = {
		toolbar:[],//hxy 2023-02-08 st
		title:$g("授权列表"),
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',//ed
		fitColumn:true,
		rownumbers:false,
		singleSelect:false,
		pagination:false,
		fit:false,
	    onLoadSuccess: function (data) { //数据加载完毕事件
			/// 开启行编辑     /// 2016-12-14 bianshuai 开启多行编辑
			var rowsData=$("#main").datagrid('getRows');
			$.each(rowsData, function(rowIndex, selItem){
				$("#main").datagrid('beginEdit', rowIndex);
				var ed=$("#main").datagrid('getEditor',{index:rowIndex,field:'TakOrd'});
				$(ed.target).combobox('setValue', $g($(ed.target).combobox('getValue')));  //设置Desc
				return;
				//$("#main").datagrid("selectRow", rowIndex); //根据索引选中该行		
			})
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsCstEmrAutItem&CstID="+CstID+"&TakType="+TakType;
	new ListComponent('main', columns, uniturl, option).Init();
}

/// 列操作按钮
function SetCellOperLink(value, rowData, rowIndex){
	
	var html = "";
	if (rowData.TakFlag == "N"){
		html = "<a href='#' class='icon-accept a-icon' onclick='OpenAuthorize("+rowIndex+")'>"+"</a>"; //$g('开启')+ hxy 2023-02-08 ui让用图标
	}else{
		html = "<a href='#' class='icon-no a-icon' onclick='CloseAuthorize("+rowIndex+")'>"+"</a>"; //$g('关闭')+ hxy 2023-02-08 ui让用图标
	}
    return html;
}

/// 列操作按钮
function SetCellTakOrd(value, rowData, rowIndex){
	
	var res = "";
	if (rowData.TakOrd == "医嘱"){
		res = $g('医嘱');
	}else{
		res = $g('病历');
	}
    return res;
}

/// 开启授权
function OpenAuthorize(rowIndex){
	
	$("#main").datagrid('endEdit', rowIndex);
	var rowData=$("#main").datagrid('getData').rows[rowIndex];
	if((rowData.LocID=="")||(rowData.LocID==undefined)){
		$.messager.alert("提示:","授权科室不能为空！","warning");
		$("#main").datagrid('beginEdit', rowIndex);
		return;
	}

	if(rowData.TakTime==0){
		$.messager.alert("提示:","时间必须为大于0的整数","warning");
		$("#main").datagrid('beginEdit', rowIndex);
		return;
	}
		
	if(rowData.TakTime>720){ //hxy 2021-05-17 200000000时日期$zd报错
		$.messager.alert("提示:","请检查授权时间(小时)合理性，已超30天","warning");
		$("#main").datagrid('beginEdit', rowIndex);
		return;
	}
	
	if(rowData.TakOrdFlag==1){
		var TakEmrAutMsg = isPopEmrAut();
		/// 验证病人是否允许会诊授权
		if (TakEmrAutMsg != ""){
			$.messager.alert("提示:",TakEmrAutMsg,"warning");
			$("#main").datagrid('beginEdit', rowIndex);
			return;	
		}
	}
	
	var mListData = EpisodeID +"^"+ rowData.itmID +"^"+ LgUserID +"^"+ rowData.LocID +"^"+ rowData.UserID +"^"+ rowData.TakTime +"^"+ rowData.TakOrdFlag;
	
	runClassMethod("web.DHCEMConsult","InsEmrAutMas",{"mListData":mListData},function(jsonString){

		if (jsonString == -2){
			$.messager.alert("提示:","开启授权失败，失败原因:当前病人此次就诊没有病历，请核实！","warning");
			$("#main").datagrid('beginEdit', rowIndex);
			return;
		}
		
		if (jsonString < 0){
			$.messager.alert("提示:","开启授权失败，失败原因:"+jsonString,"warning");
			$("#main").datagrid('beginEdit', rowIndex);
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","开启授权成功","warning");
			$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			$("#item").datagrid("reload");
		}
	},'',false)
}

/// 关闭授权
function CloseAuthorize(rowIndex){
	$("#main").datagrid('endEdit', rowIndex);
	var rowData=$("#main").datagrid('getData').rows[rowIndex];
	runClassMethod("web.DHCEMConsult","ClsCstEmrAut",{"EpisodeID":EpisodeID, "itmID":rowData.itmID,"TakType":rowData.TakOrdFlag},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","开启授权，失败原因:"+jsonString,"warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","关闭授权成功","warning");
			$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			$("#item").datagrid("reload");
		}
	},'',false)
}

/// 页面DataGrid初始定义已选列表
function initPageItemGrid(){
	
	///  定义columns
	var columns=[[
		{field:'TakFlag',title:'状态',width:100,align:'center',formatter:SetCellColor},
		{field:'LocDesc',title:'科室',width:260},
		{field:'mUser',title:'医生',width:100},
		{field:'TakOrd',title:'权限描述',width:100,align:'center',formatter:SetCellTakOrd},
		{field:'StartDate',title:'授权开始日期',width:120,align:'center'},
		{field:'StartTime',title:'授权开始时间',width:120,align:'center'},
		{field:'EndDate',title:'授权结束日期',width:120,align:'center'},
		{field:'EndTime',title:'授权结束时间',width:120,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		toolbar:[],//hxy 2023-02-08 st
		border:true,
		title:$g("授权历史"),
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',//ed
		fitColumn:false,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		fit:true
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsEmrAutDet&CstID="+CstID;
	new ListComponent('item', columns, uniturl, option).Init();
}

/// 列颜色设置
function SetCellColor(value, rowData, rowIndex){
	
	var fontColor = (value == "Y"?"green":"red");
	var html = "<span style='color:"+ fontColor +";font-weight:bold;'>"+ (value == "Y"?$g("生效中"):$g("授权结束")) +"</span>";
    return html;
}


/// 开启授权
function OpenEmrAut(){
	
	/// 结束编辑
	var rows=$("#main").datagrid('getRows');
	$.each(rows, function(index, rowData){
		$("#main").datagrid('endEdit', index); 
	})
	var mListArr = [];
	var rows = $("#main").datagrid('getSelections');
	
	if((rows[0].LocID=="")||(rows[i].LocID==undefined)){
		$.messager.alert("提示:","授权科室不能为空！","warning");
		return;
	}
	
	if(rows[0].TakTime==0){
		$.messager.alert("提示:","时间必须为大于0的整数","warning");
		return;
	}
	
	if(rows[0].TakOrdFlag==1){
		var TakEmrAutMsg = isPopEmrAut();
		/// 验证病人是否允许会诊授权
		if (TakEmrAutMsg != ""){
			$.messager.alert("提示:",TakEmrAutMsg,"warning");
			return;	
		}
	}
	
	for(var i=0; i<rows.length; i++){
		if (rows[i].TakFlag == "N"){
			mListArr.push(EpisodeID +"^"+ rows[i].itmID +"^"+ LgUserID +"^"+ rows[i].LocID +"^"+ rows[i].UserID +"^"+ rows[i].TakTime +"^"+ rows[i].TakOrdFlag);
		}
	}
	var mListData = mListArr.join("#");
	if (mListData == ""){
		$.messager.alert("提示:","请选择待开启记录后重试！","warning");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","InvEmrAutMas",{"mListData":mListData},function(jsonString){
		
		if (jsonString < 0){
			$.messager.alert("提示:","开启授权，失败原因:"+jsonString,"warning");
			return;
		}
		
		if (jsonString == 0){
			$.messager.alert("提示:","开启授权成功","warning");
			$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			$("#item").datagrid("reload");
		}
	},'',false)
}

/// 关闭授权
function CloseEmrAut(){
	
	var mListArr = [];
	
	var rows=$("#main").datagrid('getRows');
	$.each(rows, function(index, rowData){
		$("#main").datagrid('endEdit', index); 
	})
	
	var rows = $("#main").datagrid('getSelections');
	
	for(var i=0; i<rows.length; i++){
		if (rows[i].TakFlag == "Y"){
			mListArr.push(EpisodeID +"^"+ rows[i].itmID+"^"+rows[i].TakOrdFlag);
		}
	}
	var mListData = mListArr.join("#");
	if (mListData == ""){
		$.messager.alert("提示:","请选择待关闭记录后重试！","warning");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","ClsCstEmrAutMas",{"mListData":mListData},function(jsonString){

		if (jsonString < 0){
			$.messager.alert("提示:","关闭授权，失败原因:"+jsonString,"warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","关闭授权成功","warning");
			$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			$("#item").datagrid("reload");
		}
	},'',false)
}

/// 验证病人是否允许会诊授权
function isPopEmrAut(){
	
	var TakMsg = "";
	runClassMethod("web.DHCEMConsInterface","isPopEmrAut",{"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			TakMsg = jsonString;
		}
	},'',false)
	return TakMsg
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })