
/// bianshuai
/// 2016-04-02
/// 麻精药品销毁登记

var editRow = "";
var url="dhcpha.clinical.action.csp";
$(function(){
	
	//初始化界面默认信息
	InitDefault();
	
	//初始化咨询信息列表
	InitDetList();
	
	//初始化界面按钮事件
	InitWidListener();
})

///初始化界面默认信息
function InitDefault(){
	
	/**
	 * 申请日期
	 */
	$("#ddrDate").datebox("setValue", formatDate(0));
	//$("#ddrTime").val(""); //申请时间
	
	/**
	 * 申请科别
	 */
	var ddrDeptCombobox = new ListCombobox("ddrDept",url+'?action=QueryConDept','');
	ddrDeptCombobox.init();
	
	$("#ddrDept").combobox("setValue",LgCtLocID);
	
	/**
	 * 申请人员
	 */
	var ddrUserCombobox = new ListCombobox("ddrUser",url+'?action=GetDeptUser&LgLocID='+LgCtLocID,'',{panelHeight:"auto"});
	ddrUserCombobox.init();
	
	$("#ddrUser").combobox("setValue",LgUserID);
	
		
	/**
	 * 接收科别
	 */
	var ddrToLocCombobox = new ListCombobox("ddrToLoc",url+'?action=QueryConDept','');
	ddrToLocCombobox.init();

}

/// 界面元素监听事件
function InitWidListener(){

	$("a:contains('增加空行')").bind("click",insertRow);
	$("a:contains('查询单据')").bind("click",findTindy);
	$("a:contains('取消完成')").bind("click",cancelComFlag);
	$("a:contains('删除')").bind("click",DelddrNo);
	$("a:contains('保存')").bind("click",saveRow);
	$("a:contains('设置完成')").bind("click",setComFlag);
	$("a:contains('清空')").bind("click",clrCurrUI);
	
	$('#menu').menu({    
	    onClick:function(item){    
	       if (item.name == "delDet"){
		       delddrItm();
		   }
	    }    
	});
}

///初始化病人列表
function InitDetList(){

	//设置其为可编辑
	var manfEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			url: url+"?action=QueryManf",
			onSelect:function(option){
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrManfID'});
				$(ed.target).val(option.value);  //设置产地ID
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrManf'});
				$(ed.target).combobox('setValue', option.text);  //设置产地Desc
			}
		}
	}
	
	//设置其为可编辑
	var uomEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			url: "",
			onSelect:function(option){
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrUomID'});
				$(ed.target).val(option.value);  //设置单位ID
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrUom'});
				$(ed.target).combobox('setValue', option.text);  //设置单位Desc
			},
			onShowPanel:function(option){
				LoadUomComboboxData();
			}
		}
	}
	
	//设置其为可编辑
	var ddrBatExpEditor={
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			width:"200px",
			url: "",
			onSelect:function(option){
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrBatID'});
				$(ed.target).val(option.value);  //设置批号ID
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrBatNo'});
				$(ed.target).combobox('setValue', option.text.split("~")[0]);  //设置批号
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrExpDate'});
				//$(ed.target).datebox("setValue", option.text.split("~")[1]);  //设置效期
				$(ed.target).val(option.text.split("~")[1]);  //设置效期
			},
			onShowPanel:function(option){
				LoadBatExpComboboxData();
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ddrInciCode',title:'代码',width:100,editor:textEditor},
		{field:'ddrInciDesc',title:'药品名称',width:260,editor:textEditor},
		{field:'ddrInci',title:'ddrInci',width:100,editor:textEditor,hidden:true},
		{field:'ddrManfID',title:'ddrManfID',width:100,editor:textEditor,hidden:true},
		{field:'ddrManf',title:'产地',width:200,editor:manfEditor},
		{field:'ddrBatNo',title:'批号',width:140,editor:ddrBatExpEditor},
		{field:'ddrExpDate',title:'效期',width:145,editor:textEditor},
		{field:'ddrQty',title:'退货数量',width:120,editor:NumberEditor},
		{field:'ddrBatID',title:'ddrBatID',width:120,editor:textEditor,hidden:true},
		{field:'ddrUomID',title:'ddrUomID',width:120,editor:textEditor,hidden:true},
		{field:'ddrUom',title:'单位',width:120,editor:uomEditor},
		{field:'ddrSpec',title:'规格',width:120,editor:textEditor},
		{field:'ddrRemark',title:'备注',width:200,editor:textEditor},
		{field:'ddrItmID',title:'ddrItmID',width:100,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'退货申请明细',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
	    	if ($('#ddrChkFlag').is(':checked')){
				 $.messager.alert('提示','申请单据已核对完成,不能进行编辑！','warning');
				 return;
			}
	
			if ($('#ddrComFlag').is(':checked')){
				 $.messager.alert('提示','申请单据已完成,不能进行编辑！','warning');
				 return;
			}
            if ((editRow != "")||(editRow == "0")) { 
                $("#ddrDetList").datagrid('endEdit', editRow); 
            } 
            $("#ddrDetList").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  //设置回车事件
            editRow = rowIndex;
        },
		onRowContextMenu: function (e, rowIndex, rowData){
			e.preventDefault();
			$("#ddrDetList").datagrid("selectRow",rowIndex);
			$('#menu').menu('show', {    
			    left: e.pageX,
			    top: e.pageY
			}); 
		}
	};
		
	var ddrDetListComponent = new ListComponent('ddrDetList', columns, '', option);
	ddrDetListComponent.Init();

	/**
	 * 初始化显示横向滚动条
	 */
	//initScroll("#ddrDetList");
}

/// 给datagrid绑定回车事件
function dataGridBindEnterEvent(index){
	
	var editors = $('#ddrDetList').datagrid('getEditors', index);
	///药品名称
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrInciDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var mydiv = new UIDivWindow($(ed.target), input, setCurrEditRowCellVal);
		    //var mydiv = new UIDivWindow($("#consPatMedNo"));
            mydiv.init();
		}
	});
	
	///批号
	/*
	var workRateEditor = editors[5];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrBatNo'});
			if ($(ed.target).val() == ""){
				return;
			}
			var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrExpDate'});
			//$(ed.target).datebox().next('span').find('input').focus()
			$(ed.target).focus();
		}
	});
	*/
	///效期
	/*
	var workRateEditor = editors[6];
	$(workRateEditor.target).datebox().next('span').find('input').bind('keydown', function(e){
		if (e.keyCode == 13) {
			setTinyUIFocus("ddrExpDate");
		}
	});
	*/
	/*
	var workRateEditor = editors[6];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			setTinyUIFocus("ddrExpDate");
		}
	});
	*/
	///销毁数量
	var workRateEditor = editors[7];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrQty'});
			if ($(ed.target).val() == ""){
				return;
			}
			insertRow();
		}
	});
	/*
	var editors = $('#ddrDetList').datagrid('getEditors', index);
	for (var i=0; i<editors.length; i++){
		var workRateEditor = editors[i];
		if (i == 0){
			workRateEditor.target.focus();  ///设置焦点
		}
		workRateEditor.target.bind('keydown', function(e){
			if (e.keyCode == 13) {
					var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrInciDesc'});		
				
					var input = $(ed.target).val();
					alert(input)
				//var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrInciDesc'});		
				
				//var input = $(ed.target).val();
				//setTinyUIFocus();
			}
		});
	}
	*/
}

/// 给当前编辑列赋值
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#ddrDetList').datagrid('getEditors', editRow);
		///药品名称
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///设置焦点 并选中内容
		return;
	}
	///药品代码
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInciCode'});
	$(ed.target).val(rowObj.InciCode);
	///药品名称
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInciDesc'});		
	$(ed.target).val(rowObj.InciDesc);
	///药品名称ID
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInci'});		
	$(ed.target).val(rowObj.InciDr);
	///规格
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrSpec'});		
	$(ed.target).val(rowObj.Spec);
	///产地ID
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrManfID'});		
	$(ed.target).val(rowObj.Manfdr);
	///产地
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrManf'});		
	$(ed.target).combobox("setValue",rowObj.Manf);
	///单位ID
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrUomID'});		
	$(ed.target).val(rowObj.PuomDr);
	///单位
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrUom'});
	$(ed.target).combobox("setValue",rowObj.PuomDesc);
						
	///设置级联指针
	LoadUomComboboxData();
	
	///设置级联指针
	LoadBatExpComboboxData();

	setTinyUIFocus("ddrInciDesc","");
}

/// 加载单位列表
function LoadUomComboboxData(){
	
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInci'});
	if ($(ed.target).val() == ""){ return;}
	var unitUrl=url + '?action=QueryUom&inci=' + $(ed.target).val();
	
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrUom'});
	$(ed.target).combobox('reload',unitUrl);
}

/// 加载批号效期列表
function LoadBatExpComboboxData(){
	
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInci'});
	if ($(ed.target).val() == ""){ return;}
	var unitUrl=url + '?action=QueryBatExp&LocID=' +  LgCtLocID +'&Inci=' + $(ed.target).val();

	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrBatNo'});
	$(ed.target).combobox('reload',unitUrl);
}

/// 设置界面元素焦点
function setTinyUIFocus(lastEl, nextEl){
	var nextField = "";
	switch(lastEl){
	    case "ddrInciDesc":
			nextField="ddrBatNo";
			break;
	    case "ddrManf":
			nextField="ddrBatNo";
			break;
		case "ddrBatNo":
			nextField="ddrExpDate";
			break;
		case "ddrExpDate":
			nextField="ddrQty";
			break;
		default:
			nextField="";
	}
	if (nextField == ""){return;}
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:nextField});
	if (nextField == "ddrManf"){
		//$(ed.target).combobox().next('span').find('input').focus()
	}else{
		$(ed.target).focus().select();
	}
}
/// 插入新行
function insertRow(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('提示','申请单据已核对完成,不允许修改！','warning');
		 return;
	}
	
	if ($('#ddrComFlag').is(':checked')){
		 $.messager.alert('提示','申请单据已完成,请先"取消"后,再操作！','warning');
		 return;
	}
	
	if(editRow >= "0"){
		$("#ddrDetList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	var rows = $("#ddrDetList").datagrid('getRows');
	if (rows.length != "0"){
		if (rows[rows.length - 1].ddrInci == ""){
			 $("#ddrDetList").datagrid('beginEdit', rows.length - 1);
			 dataGridBindEnterEvent(rows.length - 1);  //设置回车事件
             editRow = rows.length - 1;
			 return;
		}
	}
	/*
	$("#ddrDetList").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ddrInciDesc: '',ddrSpec:'',ddrManf: '',ddrBatNo: '',ddrExpDate: ''}
	});
	
	$("#ddrDetList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	dataGridBindEnterEvent(0);  //设置回车事件
	editRow=0;
	
	*/
	///追加
	$("#ddrDetList").datagrid('appendRow',{
		ddrInciDesc: '',ddrSpec:'',ddrManf: '',ddrBatNo: '',ddrExpDate: ''});

	var currRowIndex = $("#ddrDetList").datagrid("getRows").length - 1;
	$("#ddrDetList").datagrid('beginEdit', currRowIndex);//开启编辑并传入要编辑的行
	dataGridBindEnterEvent(currRowIndex);  //设置回车事件
	editRow = currRowIndex;

}

// 删除选中行
function deleteRow(){
	
	var rows = $("#ddrDetList").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdrPatImpoInfo',{"params":rows[0].ID}, function(data){
					$('#ddrDetList').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#ddrDetList").datagrid('endEdit', editRow);
	}

	var rows = $("#ddrDetList").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	/**
	 *申请单据主信息
	 */

	///申请科别
	var ddrDeptID = $("#ddrDept").combobox("getValue");
	///销毁人员
	var ddrUser = $("#ddrUser").combobox("getValue");
	
	///接收科室
	var ddrToLoc = $("#ddrToLoc").combobox("getValue");
	
	if (ddrToLoc == ""){
		$.messager.alert("提示:","<font style='font-size:20px;color:red;'>接收科室不能为空！</font>");
		return;
	}
	var ddrMListData = ddrDeptID +"^"+ ddrUser +"^"+ ddrToLoc ;

	///申请单据明细信息
	var ListData = [];
	for(var i=0;i<rows.length;i++){
		
		if (rows[i].ddrInci != ""){
			var tmp = trsUndefinedToEmpty(rows[i].ddrItmID) +"^"+ rows[i].ddrInci +"^"+ rows[i].ddrManfID +"^"+ rows[i].ddrBatID;
			tmp = tmp +"^"+ rows[i].ddrQty  +"^"+ rows[i].ddrUomID +"^"+ rows[i].ddrBatNo +"^"+ rows[i].ddrExpDate+"^"+ rows[i].ddrRemark;
			ListData.push(tmp);
		}
	}
	var ddrDListData = ListData.join(RowDelim);

	var ddrID = $('#ddrID').val(); ///单据ID

	//保存数据
	$.post(url+'?action=saveDrgReq',{"ddrID":ddrID, "ddrMListData":ddrMListData, "ddrDListData":ddrDListData},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode > 0){
			$.messager.alert("提示:","保存成功！");
			setCurrddrNoUI(jsonddrObj.ErrorCode);
		}else{
			$.messager.alert("提示:","提交失败,错误原因："+jsonddrObj.ErrorMessage);
		}
	});
}

// 文本编辑格
var textEditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 数字编辑格
var NumberEditor={
	type: 'numberbox',//设置编辑格式
	options: {
		//required: true //设置编辑规则属性
	}
}

// 日期编辑格
var dateEditor={
	type: 'datebox',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

/// 查找销毁单据
function findTindy(){
	createDesDrugReqWin(setCurrddrNoUI);
}

/// 查询回调函数
function setCurrddrNoUI(ddrID){
	
	/// 查询数据
	$.post(url+'?action=GetReqMainInfo',{"ddrID":ddrID},function(jsonString){

		var jsonddrObj = jQuery.parseJSON(jsonString);

		$('#ddrID').val(jsonddrObj.ddrID);  ///单据ID
		$('#ddrNo').val(jsonddrObj.ddrNo);  ///单号
		$('#ddrComFlag').attr("checked",(jsonddrObj.ddrComFlag == "是"? true:false)); ///完成
		$('#ddrChkFlag').attr("checked",(jsonddrObj.ddrChkFlag == "是"? true:false));  ///核对
		$('#ddrDate').datebox("setValue",jsonddrObj.ddrCDate); ///日期
		$('#ddrTime').val(jsonddrObj.ddrCTime);  ///时间
		$('#ddrDept').combobox("setValue",jsonddrObj.ddrDeptID); ///科室
		$('#ddrUser').combobox("setValue",jsonddrObj.ddrUserID); ///人员
		$('#ddrToLoc').combobox("setValue",jsonddrObj.ddrToLocDesc); ///接收科室
		$('#ddrRemark').combobox("setValue",jsonddrObj.ddrRemarkCode); ///备注
	});
	
	/// 销毁药品明细
	$('#ddrDetList').datagrid({
		url:url+'?action=QueryReqNoDetList',
		queryParams:{
			ddrID : ddrID}
	});
}

/// 设置当前控件编辑状态
function setCurrCompEditable(){
	
	$('#ddrNo').attr("disabled",true);
	$('#ddrDate').datebox({"disabled":true});
	$('#ddrTime').attr("disabled",true);
	$('#ddrDept').combobox({"disabled":true});
	$('#ddrUser').combobox({"disabled":true});
	$('#ddrToLoc').combobox({"disabled":true});
}

/// 清空
function clrCurrUI(){
	
	///刷新界面
	///location.reload();
	$('#ddrNo').attr("disabled",false);
	$('#ddrDate').datebox({"disabled":false});
	$('#ddrTime').attr("disabled",false);
	$('#ddrDept').combobox({"disabled":false});
	$('#ddrUser').combobox({"disabled":false});
	$('#ddrToLoc').combobox({"disabled":false});
	
	///初始化值
	$('#ddrID').val("");  ///单据ID
	$('#ddrNo').val("");  ///单号
	$('#ddrComFlag').attr("checked",false); ///完成
	$('#ddrChkFlag').attr("checked",false);  ///核对
	$("#ddrDate").datebox("setValue", formatDate(0));
	$('#ddrTime').val("");  ///时间
	$("#ddrDept").combobox("setValue",LgCtLocID);
	$("#ddrUser").combobox("setValue",LgUserID);
	$('#ddrToLoc').combobox("setValue",""); ///接收科室

	///清空datagrid 
	$('#ddrDetList').datagrid('loadData', {total:0,rows:[]}); 
}

/// 确认完成
function setComFlag(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('提示','销毁单据已核对完成！','warning');
		 return;
	}
	
	if ($('#ddrComFlag').is(':checked')){
		 $.messager.alert('提示','销毁单据已完成！','warning');
		 return;
	}
	var ddrID = $('#ddrID').val(); ///单据ID

	//保存数据
	$.post(url+'?action=SetReqComFlag',{"ddrID":ddrID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$('#ddrComFlag').attr("checked",true);
			$.messager.alert("提示:","设置成功！");
		}else{
			$.messager.alert("提示:","设置失败,错误原因："+jsonddrObj.ErrorMessage);
		}
	});
}

/// 取消完成
function cancelComFlag(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('提示','销毁单据已核对完成,不允许进行此操作！','warning');
		 return;
	}
	
	if (!$('#ddrComFlag').is(':checked')){
		 $.messager.alert('提示','销毁单据未完成,不需要"取消"！','warning');
		 return;
	}
	var ddrID = $('#ddrID').val(); ///单据ID

	//保存数据
	$.post(url+'?action=CancelReqComFlag',{"ddrID":ddrID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$('#ddrComFlag').attr("checked",false);
			$.messager.alert("提示:","取消成功！");
		}else{
			$.messager.alert("提示:","取消失败,错误原因："+jsonddrObj.ErrorMessage);
		}
	});
}

/// 删除单据
function DelddrNo(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('提示','销毁单据已核对完成,不允许"删除"！','warning');
		 return;
	}
	
	if ($('#ddrComFlag').is(':checked')){
		 $.messager.alert('提示','销毁单据未完成,不允许"删除"！','warning');
		 return;
	}
	var ddrID = $('#ddrID').val(); ///单据ID

	//保存数据
	$.post(url+'?action=DelReq',{"ddrID":ddrID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$.messager.alert("提示:","删除成功！");
			clrCurrUI();
		}else{
			$.messager.alert("提示:","删除失败,错误原因："+jsonddrObj.ErrorMessage);
		}
	});
}


/// 删除明细项目
function delddrItm(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('提示','销毁单据已核对完成,不允许"删除"！','warning');
		 return;
	}
	
	if ($('#ddrComFlag').is(':checked')){
		 $.messager.alert('提示','销毁单据已完成,不允许"删除"！','warning');
		 return;
	}
	
	var rowData = $("#ddrDetList").datagrid('getSelected'); //选中行
	if (trsUndefinedToEmpty(rowData.ddrItmID) == ""){
		var selectedRowIndex = $("#ddrDetList").datagrid('getRowIndex',rowData);
		$("#ddrDetList").datagrid('deleteRow',selectedRowIndex);
		return;
	}

	//保存数据
	$.post(url+'?action=delReqItm',{"ddrItmID":rowData.ddrItmID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$.messager.alert("提示:","删除成功！");
			$("#ddrDetList").datagrid("reload");
		}else{
			$.messager.alert("提示:","删除失败,错误原因："+jsonddrObj.ErrorMessage);
		}
	});
}