
/// bianshuai
/// 2016-03-22
/// 药品拆零

var editRow = "";
var url="dhcpha.clinical.action.csp";
var tdrPurArray = [{"value":"10","text":'自动分包机'}, {"value":"20","text":'中转盒'}, {"value":"30","text":'窗口分包给患者'}, {"value":"40","text":'DTA'}];
$(function(){
	
	//初始化界面默认信息
	InitTinyDrugRegDefault();
	
	//初始化咨询信息列表
	InitTinyDrugRegDetList();
	
	//初始化界面按钮事件
	InitTinyWidgetListener();
})

///初始化界面默认信息
function InitTinyDrugRegDefault(){
	
	/**
	 * 拆零日期
	 */
	$("#tdrDate").datebox("setValue", formatDate(0));
	//$("#tdrTime").val(""); //拆零时间
	
	/**
	 * 拆零科别
	 */
	var tdrDeptCombobox = new ListCombobox("tdrDept",url+'?action=QueryConDept','');
	tdrDeptCombobox.init();
	
	$("#tdrDept").combobox("setValue",LgCtLocID);
	
	/**
	 * 拆零人员
	 */
	var tdrUserCombobox = new ListCombobox("tdrUser",url+'?action=GetDeptUser&LgLocID='+LgCtLocID,'',{});
	tdrUserCombobox.init();
	
	$("#tdrUser").combobox("setValue",LgUserID);
	
		
	/**
	 * 拆零后置于
	 */
	var tdrPurDescCombobox = new ListCombobox("tdrPurDesc",'',tdrPurArray,{panelHeight:"auto"});
	tdrPurDescCombobox.init();
}

/// 界面元素监听事件
function InitTinyWidgetListener(){

	$("a:contains('增加空行')").bind("click",insertRow);
	$("a:contains('查询单据')").bind("click",findTindy);
	$("a:contains('取消完成')").bind("click",cancelTdrComFlag);
	$("a:contains('删除')").bind("click",DelTdrNo);
	$("a:contains('保存')").bind("click",saveRow);
	$("a:contains('设置完成')").bind("click",setTdrComFlag);
	$("a:contains('清空')").bind("click",clrCurrUI);
	
	$('#menu').menu({    
	    onClick:function(item){    
	       if (item.name == "delDet"){
		       delTdrItm();
		   }
	    }    
	});
}

///初始化病人列表
function InitTinyDrugRegDetList(){

	//设置其为可编辑
	var manfEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			url: url+"?action=QueryManf",
			onSelect:function(option){
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrManfID'});
				$(ed.target).val(option.value);  //设置产地ID
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrManf'});
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
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrUomID'});
				$(ed.target).val(option.value);  //设置单位ID
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrUom'});
				$(ed.target).combobox('setValue', option.text);  //设置单位Desc
			},
			onShowPanel:function(option){
				LoadUomComboboxData();
			}
		}
	}
	
	//设置其为可编辑
	var tdrPurEditor={
		type: 'combobox',//设置编辑格式
		options: {
			data:tdrPurArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrPurCode'});
				$(ed.target).val(option.value);  //设置拆零后置于ID
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrPurDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置拆零后置于Desc
			}
		}
	}
	
	//设置其为可编辑
	var tdrBatExpEditor={
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			url: "",
			onSelect:function(option){
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrBatID'});
				$(ed.target).val(option.value);  //设置批号ID
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrBatNo'});
				$(ed.target).combobox('setValue', option.text.split("~")[0]);  //设置批号
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrBatNoH'});
				$(ed.target).val(option.text.split("~")[0]);  //设置批号
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrExpDate'});
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
		{field:'tdrInciCode',title:'代码',width:100,editor:textEditor},
		{field:'tdrInciDesc',title:'药品名称',width:260,editor:textEditor},
		{field:'tdrInci',title:'tdrInci',width:100,editor:textEditor,hidden:true},
		{field:'tdrManfID',title:'tdrManfID',width:100,editor:textEditor,hidden:true},
		{field:'tdrManf',title:'产地',width:190,editor:manfEditor},
		{field:'tdrPurCode',title:'tdrPurCode',width:120,editor:textEditor,hidden:true},
		{field:'tdrPurDesc',title:'拆零后置于',width:120,editor:tdrPurEditor,hidden:true},
		{field:'tdrBatNo',title:'批号',width:140,editor:tdrBatExpEditor},
		{field:'tdrBatNoH',title:'批号(手填)',width:120,editor:textEditor},
		{field:'tdrExpDate',title:'效期',width:100,editor:textEditor},
		{field:'tdrQty',title:'拆零数量',width:100,editor:NumberEditor},
		{field:'tdrBatID',title:'tdrBatID',width:120,editor:textEditor,hidden:true},
		{field:'tdrUomID',title:'tdrUomID',width:120,editor:textEditor,hidden:true},
		{field:'tdrUom',title:'单位',width:100,editor:uomEditor},
		{field:'tdrMacSitNum',title:'药位号',width:100,editor:textEditor},
		{field:'tdrSpec',title:'规格',width:100,editor:textEditor},
		{field:'tdrItmID',title:'tdrItmID',width:100,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'拆零明细',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
	    	if ($('#tdrChkFlag').is(':checked')){
				 $.messager.alert('提示','拆零单据已核对完成,不能进行编辑！','warning');
				 return;
			}
	
			if ($('#tdrComFlag').is(':checked')){
				 $.messager.alert('提示','拆零单据已完成,不能进行编辑！','warning');
				 return;
			}
            if ((editRow != "")||(editRow == "0")) { 
                $("#tdrDetList").datagrid('endEdit', editRow); 
            } 
            $("#tdrDetList").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  //设置回车事件
            editRow = rowIndex;
        },
		onRowContextMenu: function (e, rowIndex, rowData){
			e.preventDefault();
			$("#tdrDetList").datagrid("selectRow",rowIndex);
			$('#menu').menu('show', {    
			    left: e.pageX,
			    top: e.pageY
			}); 
		}
	};
		
	var tdrDetListComponent = new ListComponent('tdrDetList', columns, '', option);
	tdrDetListComponent.Init();

	/**
	 * 初始化显示横向滚动条
	 */
	//initScroll("#tdrDetList");
}

/// 给datagrid绑定回车事件
function dataGridBindEnterEvent(index){
	
	var editors = $('#tdrDetList').datagrid('getEditors', index);
	///药品名称
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrInciDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var mydiv = new UIDivWindow($(ed.target), input, setCurrEditRowCellVal);
		    //var mydiv = new UIDivWindow($("#consPatMedNo"));
            mydiv.init();
		}
	});
	
	///批号
	var workRateEditor = editors[7];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrBatNo'});
			if ($(ed.target).val() == ""){
				return;
			}
			var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrExpDate'});
			//$(ed.target).datebox().next('span').find('input').focus()
			$(ed.target).focus();
		}
	});
	
	///效期
	/*
	var workRateEditor = editors[8];
	$(workRateEditor.target).datebox().next('span').find('input').bind('keydown', function(e){
		if (e.keyCode == 13) {
			setTinyUIFocus("tdrExpDate");
		}
	});
	*/
	var workRateEditor = editors[9];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			setTinyUIFocus("tdrExpDate");
		}
	});
	
	///拆零数量
	var workRateEditor = editors[10];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrQty'});
			if ($(ed.target).val() == ""){
				return;
			}
			setTinyUIFocus("tdrQty");   //insertRow();
		}
	});
	
	///药位号
	var workRateEditor = editors[14];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			insertRow();
		}
	});
	/*
	var editors = $('#tdrDetList').datagrid('getEditors', index);
	for (var i=0; i<editors.length; i++){
		var workRateEditor = editors[i];
		if (i == 0){
			workRateEditor.target.focus();  ///设置焦点
		}
		workRateEditor.target.bind('keydown', function(e){
			if (e.keyCode == 13) {
					var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrInciDesc'});		
				
					var input = $(ed.target).val();
					alert(input)
				//var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrInciDesc'});		
				
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
		var editors = $('#tdrDetList').datagrid('getEditors', editRow);
		///药品名称
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///设置焦点 并选中内容
		return;
	}
	///药品代码
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInciCode'});
	$(ed.target).val(rowObj.InciCode);
	///药品名称
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInciDesc'});		
	$(ed.target).val(rowObj.InciDesc);
	///药品名称ID
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInci'});		
	$(ed.target).val(rowObj.InciDr);
	///规格
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrSpec'});		
	$(ed.target).val(rowObj.Spec);
	///产地ID
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrManfID'});		
	$(ed.target).val(rowObj.Manfdr);
	///产地
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrManf'});		
	$(ed.target).combobox("setValue",rowObj.Manf);
	/*
	///单位ID
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUomID'});		
	$(ed.target).val(rowObj.PuomDr);
	///单位
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUom'});
	$(ed.target).combobox("setValue",rowObj.PuomDesc);
	*/
	///单位ID
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUomID'});		
	$(ed.target).val(rowObj.BuomDr);
	///单位
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUom'});
	$(ed.target).combobox("setValue",rowObj.BuomDesc);
						
	///设置级联指针
	LoadUomComboboxData();
	
	///设置级联指针
	LoadBatExpComboboxData();

	setTinyUIFocus("tdrInciDesc","");
}

/// 加载单位列表
function LoadUomComboboxData(){
	
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInci'});
	if ($(ed.target).val() == ""){ return;}
	var unitUrl=url + '?action=QueryUom&inci=' + $(ed.target).val();
	
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUom'});
	$(ed.target).combobox('reload',unitUrl);
}

/// 加载批号效期列表
function LoadBatExpComboboxData(){
	
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInci'});
	if ($(ed.target).val() == ""){ return;}
	var unitUrl=url + '?action=QueryBatExp&LocID=' +  LgCtLocID +'&Inci=' + $(ed.target).val();

	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrBatNo'});
	$(ed.target).combobox('reload',unitUrl);
}

/// 设置界面元素焦点
function setTinyUIFocus(lastEl, nextEl){
	var nextField = "";
	switch(lastEl){
	    case "tdrInciDesc":
			nextField="tdrBatNo";
			break;
	    case "tdrManf":
			nextField="tdrBatNo";
			break;
		case "tdrBatNo":
			nextField="tdrExpDate";
			break;
		case "tdrExpDate":
			nextField="tdrQty";
			break;
		case "tdrQty":
			nextField="tdrMacSitNum";
			break;
		default:
			nextField="";
	}
	if (nextField == ""){return;}
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:nextField});
	if (nextField == "tdrManf"){
		//$(ed.target).combobox().next('span').find('input').focus()
	}else{
		$(ed.target).focus().select();
	}
}
/// 插入新行
function insertRow(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据已核对完成,不允许修改！','warning');
		 return;
	}
	
	if ($('#tdrComFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据已完成,请先"取消"后,再操作！','warning');
		 return;
	}
	
	if(editRow >= "0"){
		$("#tdrDetList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	var rows = $("#tdrDetList").datagrid('getRows');
	if (rows.length != "0"){
		if (rows[rows.length - 1].tdrInci == ""){
			 $("#tdrDetList").datagrid('beginEdit', rows.length - 1);
			 dataGridBindEnterEvent(rows.length - 1);  //设置回车事件
             editRow = rows.length - 1;
			 return;
		}
	}
	/*
	$("#tdrDetList").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {tdrInciDesc: '',tdrSpec:'',tdrManf: '',tdrBatNo: '',tdrExpDate: ''}
	});
	
	$("#tdrDetList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	dataGridBindEnterEvent(0);  //设置回车事件
	editRow=0;
	
	*/
	///追加
	$("#tdrDetList").datagrid('appendRow',{
		tdrInciDesc: '',tdrSpec:'',tdrManf: '',tdrBatNo: '',tdrExpDate: ''});

	var currRowIndex = $("#tdrDetList").datagrid("getRows").length - 1;
	$("#tdrDetList").datagrid('beginEdit', currRowIndex);//开启编辑并传入要编辑的行
	dataGridBindEnterEvent(currRowIndex);  //设置回车事件
	editRow = currRowIndex;

}

// 删除选中行
function deleteRow(){
	
	var rows = $("#tdrDetList").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdrPatImpoInfo',{"params":rows[0].ID}, function(data){
					$('#tdrDetList').datagrid('reload'); //重新加载
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
		$("#tdrDetList").datagrid('endEdit', editRow);
	}

	var rows = $("#tdrDetList").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	/**
	 *拆零单据主信息
	 */
	
	///拆零科别
	var tdrDeptID = $("#tdrDept").combobox("getValue");
	///拆零人员
	var tdrUser = $("#tdrUser").combobox("getValue");
	///拆零后置于
	var tdrPurCode = $("#tdrPurDesc").combobox("getValue");
	if (tdrPurCode == ""){
		$.messager.alert("提示:","<font style='font-size:20px;color:red;'>拆零目的不能为空！</font>");
		return;
	}
	var tdrMListData = tdrDeptID +"^"+ tdrUser +"^"+ tdrPurCode;
	
	///拆零单据明细信息
	var ListData = [];
	for(var i=0;i<rows.length;i++){
		
		if (rows[i].tdrInci != ""){
			var tmp = trsUndefinedToEmpty(rows[i].tdrItmID) +"^"+ rows[i].tdrInci +"^"+ rows[i].tdrManfID +"^"+ rows[i].tdrBatID;
			tmp = tmp +"^"+ rows[i].tdrQty  +"^"+ rows[i].tdrUomID +"^"+ rows[i].tdrBatNoH +"^"+ rows[i].tdrExpDate +"^"+ rows[i].tdrMacSitNum;
			ListData.push(tmp);
		}
	}
	var tdrDListData = ListData.join(RowDelim);
	
	var tdrID = $('#tdrID').val(); ///单据ID

	//保存数据
	$.post(url+'?action=saveTindy',{"tdrID":tdrID, "tdrMListData":tdrMListData, "tdrDListData":tdrDListData},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode > 0){
			$.messager.alert("提示:","保存成功！");
			setCurrTdrNoUI(jsonTdrObj.ErrorCode);
		}else{
			$.messager.alert("提示:","提交失败,错误原因："+jsonTdrObj.ErrorMessage);
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

/// 查找拆零单据
function findTindy(){
	createFindTindyDrugRegWin(setCurrTdrNoUI);
}

/// 查询回调函数
function setCurrTdrNoUI(tdrID){
	
	/*
	setCurrCompEditable();  /// 设置当前控件编辑状态
	
	$('#tdrID').val(rowData.tdrID);  ///单据ID
	$('#tdrNo').val(rowData.tdrNo);  ///单号

	$('#tdrComFlag').attr("checked",(rowData.tdrComFlag == "是"? true:false)); ///完成
	$('#tdrChkFlag').attr("checked",(rowData.tdrChkFlag == "是"? true:false));  ///核对
	$('#tdrDate').datebox("setValue",rowData.tdrCDate); ///日期
	$('#tdrTime').val(rowData.tdrCTime);  ///时间
	$('#tdrDept').combobox("setValue",rowData.tdrDeptID); ///科室
	$('#tdrUser').combobox("setValue",rowData.tdrUserID); ///人员
	$('#tdrPurDesc').combobox("setValue",rowData.tdrPurCode); ///拆零目的
	*/

	/// 查询数据
	$.post(url+'?action=GetTdrInfo',{"tdrID":tdrID},function(jsonString){

		var jsonTdrObj = jQuery.parseJSON(jsonString);

		$('#tdrID').val(jsonTdrObj.tdrID);  ///单据ID
		$('#tdrNo').val(jsonTdrObj.tdrNo);  ///单号

		$('#tdrComFlag').attr("checked",(jsonTdrObj.tdrComFlag == "是"? true:false)); ///完成
		$('#tdrChkFlag').attr("checked",(jsonTdrObj.tdrChkFlag == "是"? true:false));  ///核对
		$('#tdrDate').datebox("setValue",jsonTdrObj.tdrCDate); ///日期
		$('#tdrTime').val(jsonTdrObj.tdrCTime);  ///时间
		$('#tdrDept').combobox("setValue",jsonTdrObj.tdrDeptID); ///科室
		$('#tdrUser').combobox("setValue",jsonTdrObj.tdrUserID); ///人员
		$('#tdrPurDesc').combobox("setValue",jsonTdrObj.tdrPurCode); ///拆零目的
	});
	
	/// 拆零药品明细
	$('#tdrDetList').datagrid({
		url:url+'?action=QueryTdrNoDetList',
		queryParams:{
			tdrID : tdrID}
	});
}

/// 设置当前控件编辑状态
function setCurrCompEditable(){
	
	$('#tdrNo').attr("disabled",true);
	$('#tdrDate').datebox({"disabled":true});
	$('#tdrTime').attr("disabled",true);
	$('#tdrDept').combobox({"disabled":true});
	$('#tdrUser').combobox({"disabled":true});
	$('#tdrPurDesc').combobox({"disabled":true});
}

/// 清空
function clrCurrUI(){
	
	///刷新界面
	///location.reload();
	$('#tdrNo').attr("disabled",false);
	$('#tdrDate').datebox({"disabled":false});
	$('#tdrTime').attr("disabled",false);
	$('#tdrDept').combobox({"disabled":false});
	$('#tdrUser').combobox({"disabled":false});
	$('#tdrPurDesc').combobox({"disabled":false});
	
	///初始化值
	$('#tdrID').val("");  ///单据ID
	$('#tdrNo').val("");  ///单号
	$('#tdrComFlag').attr("checked",false); ///完成
	$('#tdrChkFlag').attr("checked",false);  ///核对
	$("#tdrDate").datebox("setValue", formatDate(0));
	$('#tdrTime').val("");  ///时间
	$("#tdrDept").combobox("setValue",LgCtLocID);
	$("#tdrUser").combobox("setValue",LgUserID);
	$('#tdrPurDesc').combobox("setValue",""); ///拆零目的

	///清空datagrid 
	$('#tdrDetList').datagrid('loadData', {total:0,rows:[]}); 
}

/// 确认完成
function setTdrComFlag(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据已核对完成！','warning');
		 return;
	}
	
	if ($('#tdrComFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据已完成！','warning');
		 return;
	}
	var tdrID = $('#tdrID').val(); ///单据ID

	//保存数据
	$.post(url+'?action=SetTindyComFlag',{"tdrID":tdrID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$('#tdrComFlag').attr("checked",true);
			$.messager.alert("提示:","设置成功！");
		}else{
			$.messager.alert("提示:","设置失败,错误原因："+jsonTdrObj.ErrorMessage);
		}
	});
}

/// 取消完成
function cancelTdrComFlag(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据已核对完成,不允许进行此操作！','warning');
		 return;
	}
	
	if (!$('#tdrComFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据未完成,不需要"取消"！','warning');
		 return;
	}
	var tdrID = $('#tdrID').val(); ///单据ID

	//保存数据
	$.post(url+'?action=CancelTindyComFlag',{"tdrID":tdrID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$('#tdrComFlag').attr("checked",false);
			$.messager.alert("提示:","取消成功！");
		}else{
			$.messager.alert("提示:","取消失败,错误原因："+jsonTdrObj.ErrorMessage);
		}
	});
}

/// 删除单据
function DelTdrNo(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据已核对完成,不允许"删除"！','warning');
		 return;
	}
	
	if ($('#tdrComFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据未完成,不允许"删除"！','warning');
		 return;
	}
	var tdrID = $('#tdrID').val(); ///单据ID

	//保存数据
	$.post(url+'?action=DelTindy',{"tdrID":tdrID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$.messager.alert("提示:","删除成功！");
			clrCurrUI();
		}else{
			$.messager.alert("提示:","删除失败,错误原因："+jsonTdrObj.ErrorMessage);
		}
	});
}


/// 删除明细项目
function delTdrItm(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据已核对完成,不允许"删除"！','warning');
		 return;
	}
	
	if ($('#tdrComFlag').is(':checked')){
		 $.messager.alert('提示','拆零单据已完成,不允许"删除"！','warning');
		 return;
	}
	
	var rowData = $("#tdrDetList").datagrid('getSelected'); //选中行
	if (trsUndefinedToEmpty(rowData.tdrItmID) == ""){
		var selectedRowIndex = $("#tdrDetList").datagrid('getRowIndex',rowData);
		$("#tdrDetList").datagrid('deleteRow',selectedRowIndex);
		return;
	}

	//保存数据
	$.post(url+'?action=delTdrItm',{"tdrItmID":rowData.tdrItmID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$.messager.alert("提示:","删除成功！");
			$("#tdrDetList").datagrid("reload");
		}else{
			$.messager.alert("提示:","删除失败,错误原因："+jsonTdrObj.ErrorMessage);
		}
	});
}