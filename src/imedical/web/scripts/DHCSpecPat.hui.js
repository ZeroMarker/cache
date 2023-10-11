var PageLogicObj={
	m_DHCPatListDataGrid:"",
	m_DHCPatListTypeDataGrid:"",
	m_PatListTypeDataGrid:""
};
$(function(){
	Init();
	InitEvent();
	DHCPatListDataGridLoad();
});
function Init(){
	InitDate();
	PageLogicObj.m_DHCPatListDataGrid=InitDHCPatListDataGrid();
	$(document.body).bind("keydown",BodykeydownHandler)
	InitPatListType();
	InitCache();
}
function InitEvent(){
	$('#BFind').click(DHCPatListDataGridLoad)
	$('#BClear').click(ClearData)
	$("#BType").click(BTypeClickHandler);
	$("#BExport").click(function() {
		ExportSpecPatDataToExcel()
	})
	$("#BExportSet").click(function() {
		OpenSettingsWin()
	})
	$("#BImport").click(OpenImportWin)
}
function InitDate(){
	$('#StartDate').datebox('setValue', ServerObj.MCurrDate);
    $('#EndDate').datebox('setValue', ServerObj.CurrDate);
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        //e.preventDefault(); 
        return false;  
    }  
}

function InitPatListType(){
	var cbox = $HUI.combobox("#PatListType", {
		url:$URL+"?ClassName=web.DHCSpecPat&QueryName=FindPatListType&ResultSetType=array",
		valueField:'RowId',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;
		},
		onSelect: function (record) {
			// console.log(record);
		},
		onLoadSuccess:function(data){
			if (data.length>=1){
				// 没必要，避免第一次加载页面时，重复多次调用
				// DHCPatListDataGridLoad();
			}
		}
	});
}

function InitDHCPatListDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddClickHandle("");}
    },{
        text: '修改',
        iconCls: 'icon-save',
        handler: function() { AddClickHandle("U");}
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() { DeleteClickHandle();}
    },{
        text: '置为无效',
        iconCls: 'icon-update',
        handler: function() { UpdateClickHandle();}
    },{
	    id:'tip',
        text: '使用说明',
        iconCls: 'icon-help'
    }];
	var Columns=[[
		{field:'TSPRowId',hidden:true,title:''},
		{field:'TPatName',title:'患者姓名',width:130},
		{field:'TPatIDCard',title:'身份证号',width:300},
		{field:'TPatNote',title:'备注',width:300},
		{field:'TPatListType',title:'患者类型',width:300},
		{field:'TStDate',title:'有效开始日期',width:300},
		{field:'TEndDate',title:'有效截止日期',width:300},
		{field:'TCreateUser',title:'添加人',width:300},
		{field:'TUpdateUser',title:'更新人',width:300}
    ]]
	var DHCPatListDataGrid=$("#DHCPatListTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 50,
		pageList : [50,100,200],
		idField:'TSPRowId',
		columns :Columns,
		toolbar:toobar,
		onClickCell:function(index, field,value){
			if(field=="ApptPatName"){
				//ShowPatAppInfo(index);
			}
		},
		onSelect: function (index, row){
			$("#PatName").val(row.TPatName);
			$("#PatIDCard").val(row.TPatIDCard);
			$("#PatNote").val(row.TPatNote);
			$('#StartDate').datebox('setValue', row.TStDate);	
    		$('#EndDate').datebox('setValue', row.TEndDate);
    		$HUI.combobox("#PatListType").setValue(row.TPatListTypeId);
		},
		onUnselect:function(index, row){
			ClearData(0);
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_DHCPatListDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_DHCPatListDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_DHCPatListDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		},onLoadSuccess:function(data) {
			// 重新Init，有点浪费性能（目前没找到更好的办法）
			InitTip()
		}
	}); 
	return DHCPatListDataGrid;
}

function DHCPatListDataGridLoad(){
	var PatName=$("#PatName").val();
	var PatIDCard=$("#PatIDCard").val();
	var PatListType=$HUI.datebox("#PatListType").getValue();
	var SttDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	$.q({
	    ClassName : "web.DHCSpecPat",
	    QueryName : "FindPatList",
	    SttDate:SttDate,
	    EndDate:EndDate,
		PatName:PatName,
	    PatIDCard:PatIDCard,
	    PatListType:PatListType,
	    Pagerows:PageLogicObj.m_DHCPatListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DHCPatListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_DHCPatListDataGrid.datagrid('clearSelections'); 
		PageLogicObj.m_DHCPatListDataGrid.datagrid('clearChecked'); 
	}); 
}

function AddClickHandle(type){
	if (!CheckDataValid()) return false;
	var row=PageLogicObj.m_DHCPatListDataGrid.datagrid("getSelected");
	var InSPRowId = "";
	var sucMsg = "";
	var errMsg = "";
	if (type=="U") {
		if ((!row)||(row.length==0)){
			$.messager.alert("提示","请选择一条需要更新的记录!","info");
			return false;
		} else {
			InSPRowId = row.TSPRowId
			sucMsg = "更新记录成功!";
			errMsg = "更新记录失败!";
		}
	} else {
		sucMsg = "新增记录成功!";
		errMsg = "新增记录失败!";
	}
	var PatName=$("#PatName").val();
	var PatIDCard=$("#PatIDCard").val();
	var PatNote=$("#PatNote").val();
	var PatListType=$HUI.combobox("#PatListType").getValue();
	var SttDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	$.cm({
		ClassName:"web.DHCSpecPat",
		MethodName:"InsertPatList",
		PatName:PatName,
		PatIDCard:PatIDCard,
		PatNote:PatNote,
		PatListType:PatListType,
		SttDate:SttDate,
		EndDate:EndDate,
		UserID:session['LOGON.USERID'],
		InSPRowId:InSPRowId,
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.show({title:"提示",msg: sucMsg});
			PageLogicObj.m_DHCPatListDataGrid.datagrid('uncheckAll');
			ClearData();
		}else{
			$.messager.alert("提示",errMsg + rtn,"error");
			return false;
		}
	});
}

function DeleteClickHandle(){
	var row=PageLogicObj.m_DHCPatListDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的记录!","info");
		return false;
	}
	var SPRowId=row.TSPRowId;
	$.messager.confirm("删除", "确认要删除本条记录？", function (r) {
		if (r) {
			$.cm({
				ClassName:"web.DHCSpecPat",
				MethodName:"DeletePatList",
				SPRowId:SPRowId
			},function(ret){
				if(ret==0) {
					$.messager.show({title:"提示",msg:"删除成功"});
					ClearData();
		 		}else{
			   		$.messager.alert("提示","删除失败,错误信息:"+ret,"error");
			   		return false;
		   		}
			})
		}
	})
}

function UpdateClickHandle(){
	var row=PageLogicObj.m_DHCPatListDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要更新的记录!","info");
		return false;
	}
	var SPRowId=row.TSPRowId;
	var TEndDate=row.TEndDate;
	$.cm({
		ClassName:"web.DHCSpecPat",
		MethodName:"UpdatePatList",
		SPRowId:SPRowId,
		UserID:session['LOGON.USERID'],
		dataType:"text"
	},function(ret){
		if(ret==0) {
			$.messager.show({title:"提示",msg:"修改成功"});
	 		ClearData();
 		}else{
	   		$.messager.alert("提示","修改失败,错误信息:"+ret,"error");
	   		return false;
   		}
	})
}

function CheckDataValid(){
	var PatName=$("#PatName").val();
	if (!PatName) {
		$.messager.alert("提示","姓名不能为空!","info",function(){
			$("#PatName").focus()
		});
		return false;
	}
	var PatIDCard=$("#PatIDCard").val();
	if (PatIDCard!=""){
		var myIsID=DHCWeb_IsIdCardNo(PatIDCard);
		if (!myIsID){
			websys_setfocus("PatIDCard");
			return false;
		}
	}else{
		$.messager.alert("提示","身份证号不能为空!","info",function(){
			$("#PatIDCard").focus()
		});
		return false;
	}
	var PatListType=$HUI.combobox("#PatListType").getValue();
	if (!PatListType){
		$.messager.alert("提示","请选择患者类型!");
		return false;
	}
	return true;
}

function ClearData(reload){
	$("#PatName,#PatIDCard,#PatNote").val("");
	$('#StartDate').datebox('setValue', ServerObj.MCurrDate);	
    $('#EndDate').datebox('setValue', ServerObj.CurrDate);
    $HUI.combobox("#PatListType").setValue("");
	if (reload != 0) {
    	DHCPatListDataGridLoad()
    }
}

function BTypeClickHandler(){
	$("#PatListTypeCode,#PatListTypeName,#PatListTypeExecuteCode").val("");
	$("#PatListType-dialog").dialog("open");
	if (PageLogicObj.m_PatListTypeDataGrid=="") {
		PageLogicObj.m_PatListTypeDataGrid=PatListTypeTabDataGrid();
	}
	PatListTypeDataGridLoad()
}

function PatListTypeTabDataGrid(){
	var AppinfoColumns=[[ 
		{field:'RowId',hidden:true,title:''},
		{field:'Code',title:'代码',width:100},
		{field:'Desc',title:'类型',width:150},
		{field:'ExecCode',title:'管控执行代码',width:300}
    ]]
    var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddTypeClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() { DeleteTypeClickHandle();}
    },{
        text: '更新',
        iconCls: 'icon-cancel',
        handler: function() { UpdateTypeClickHandle();}
    }];
	var PatListTypeDataGrid=$("#PatListTypeTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 15,
		pageList : [15,50],
		idField:'RowId',
		toolbar:toobar,
		columns :AppinfoColumns,
		onSelect:function(index, row){
			$("#PatListTypeCode").val(row["Code"]);
			$("#PatListTypeName").val(row["Desc"]);
			$("#PatListTypeExecuteCode").val(row["ExecCode"]);
		}
	}); 
	return PatListTypeDataGrid;	
}
function PatListTypeDataGridLoad(){
	$.q({
	    ClassName : "web.DHCSpecPat",
	    QueryName : "FindPatListType",
	    Pagerows:PageLogicObj.m_PatListTypeDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_PatListTypeDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_PatListTypeDataGrid.datagrid('clearSelections'); 
		PageLogicObj.m_PatListTypeDataGrid.datagrid('clearChecked'); 
	}); 	
}
function UpdateTypeClickHandle(){
	var rows=PageLogicObj.m_PatListTypeDataGrid.datagrid("getSelected");
	if (!rows) {
		$.messager.alert("提示","请选择行","error");
		return false;
	}
	var PatListTypeCode=$("#PatListTypeCode").val();
	var PatListTypeName=$("#PatListTypeName").val();
	var PatListTypeExecuteCode=$("#PatListTypeExecuteCode").val();
	if (PatListTypeCode==""){
		$.messager.alert("提示","代码不能为空","error");
		return false;
	}
	if (PatListTypeName==""){
		$.messager.alert("提示","描述不能为空","error");
		return false;
	}
	$.cm({
		ClassName:"web.DHCSpecPat",
		MethodName:"InsertPatListType",
		RowID:rows["RowId"],
		Code:PatListTypeCode,
		Desc:PatListTypeName,
		ExecuteCode:PatListTypeExecuteCode,
		dataType:"text"		
	},function(ret){
		if(ret==0) {
			$.messager.alert("提示","更新成功","info");
	 		PatListTypeDataGridLoad();
	 		$("#PatListTypeCode,#PatListTypeName,#PatListTypeExecuteCode").val("");
	 		InitPatListType();
 		}else{
	   		$.messager.alert("提示","修改失败,错误信息:"+ret);
	   		return false;
   		}
	})
}
function AddTypeClickHandle(){
	var PatListTypeCode=$("#PatListTypeCode").val();
	var PatListTypeName=$("#PatListTypeName").val();
	var PatListTypeExecuteCode=$("#PatListTypeExecuteCode").val();
	if (PatListTypeCode==""){
		$.messager.alert("提示","代码不能为空","error");
		return false
	}
	if (PatListTypeName==""){
		$.messager.alert("提示","描述不能为空","error");
		return false
	}
	$.cm({
		ClassName:"web.DHCSpecPat",
		MethodName:"InsertPatListType",
		RowID:"",
		Code:PatListTypeCode,
		Desc:PatListTypeName,
		ExecuteCode:PatListTypeExecuteCode,
		dataType:"text"		
	},function(ret){
		if(ret==0) {
			$.messager.alert("提示","新增成功","info");
	 		PatListTypeDataGridLoad();
	 		$("#PatListTypeCode,#PatListTypeName,#PatListTypeExecuteCode").val("");
	 		InitPatListType();
 		}else{
	   		$.messager.alert("提示","修改失败,错误信息:"+ret);
	   		return false;
   		}
	})
}
function DeleteTypeClickHandle(){
	var selrow=PageLogicObj.m_PatListTypeDataGrid.datagrid('getSelected');
	var rows=PageLogicObj.m_PatListTypeDataGrid.datagrid('getData');
	if (selrow==null){
		$.messager.alert("提示","请选择一行","error");
	   	return false;
	}
	var RowID=selrow.RowId
	$.messager.confirm("删除", "确认要删除本条记录？", function (r) {
		if (r) {
			$.cm({
				ClassName:"web.DHCSpecPat",
				MethodName:"DeletePatListType",
				RowID:RowID,
				dataType:"text"		
			},function(ret){
				if(ret==0) {
					$.messager.alert("提示","删除成功","info");
					$("#PatListTypeCode,#PatListTypeName,#PatListTypeExecuteCode").val("");
					PatListTypeDataGridLoad();
					InitPatListType();
				}else{
					$.messager.alert("提示","删除失败,错误信息:"+ret,"error");
					return false;
				}
			})
		}
	})
}

function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>特殊患者管理使用说明</li>" + 
		'<li>1、该页面区别于HIS主索引管理，主要用来录入特殊(比如扶贫,慢病)类型的患者，可以在类型设置中增加不同类型。</li>' +
		'<li>2、导入说明：</li>'+
			'<li>单击界面按钮“EXCEL导入”，在打开的导入界面可以下载Excel导入模板；依赖基础平台 HISUI “导出Excel”功能支持</li>'+
			'<li>第一行为列名:1.患者姓名 | 2.身份证号 | 3.患者类型 | 4.备注 | 5.开始日期</li>'+
			'<li>患者类型需要和类型设置中类型描述保持完全一致</li>'+
			'<li>实际导入数据从第二行开始</li>'+
		"</ul>" 
	$("#tip").popover({
		width:800,
		trigger:'hover',
		content:_content
	});
}

function ExportSpecPatDataToExcel() {
	// 有选中数据清除选中，避免只导出选中的那条数据
	var selectRow = PageLogicObj.m_DHCPatListDataGrid.datagrid('getSelected')
	if (selectRow != null) {
		PageLogicObj.m_DHCPatListDataGrid.datagrid('unselectAll');
	}
	var excelName = "医生站特殊患者数据统计"
	var setPageName = "DocSpecPatExport"
	var PatName=$("#PatName").val();
	var PatIDCard=$("#PatIDCard").val();
	var PatListType=$HUI.datebox("#PatListType").getValue();
	var SttDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var data = $cm({
	    ClassName : "web.DHCSpecPat",
	    QueryName : "FindPatList",
	    SttDate:SttDate,
	    EndDate:EndDate,
		PatName:PatName,
	    PatIDCard:PatIDCard,
	    PatListType:PatListType,
	    Pagerows:PageLogicObj.m_DHCPatListDataGrid.datagrid("options").pageSize,rows:99999
	},false)
	if (data.rows.length == 0) {
		$.messager.alert("提示","无需要导出的有效记录！","info");
		PageLogicObj.m_DHCPatListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',data)
		return
	} else {
		PageLogicObj.m_DHCPatListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',data)
		PageLogicObj.m_DHCPatListDataGrid.datagrid('clearSelections')
		PageLogicObj.m_DHCPatListDataGrid.datagrid('clearChecked')
	}
	
	$cm({
		ResultSetType: "ExcelPlugin",  		// 表示通过DLL生成Excel，可支持IE与Chrome系。Chrome系浏览器请安装中间件
		// ResultSetTypeDo:"Print",    		// 默认Export，可以设置为：PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\表示固定文件路径, "Self"表示用户导出时选择保存路径，默认保存到桌面
		ExcelName: excelName,
		PageName: setPageName,	
		ClassName: "web.DHCSpecPat",
		QueryName: "FindPatList",
		SttDate: SttDate,
	    EndDate: EndDate,
		PatName: PatName,
	    PatIDCard: PatIDCard,
	    PatListType: PatListType,
	    rows:99999
	},function(data){
		$.messager.popover({
			msg: '导出Excel成功，请留意任务栏！',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
}

function OpenSettingsWin() {
	var title = "医生站特殊患者导出数据配置"
	var setPageName = "DocSpecPatExport"
	var url = "websys.query.customisecolumn.csp?CONTEXT=Kweb.DHCSpecPat:FindPatList&PAGENAME="+ setPageName +"&PREFID=0"
	websys_showModal({
		url: url,
		title: title
	})
}

function OpenImportWin() {
	var className = "web.DHCSpecPat"
	var methodName = "ImportData"
	var url = "dhcdoc.common.excel.import.csp?mClassName=" + className + "&mMethodName=" + methodName
	url += "&mShowExcelDetail=1&mHospId="
	websys_showModal({
		url: url,
		title:'特殊患者管理Excel导入',
		callbackFun: DHCPatListDataGridLoad
	})
}