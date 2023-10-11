/*
 * FileName: dhcbill.conf.childextracharge.js
 * Author: tangzf
 * Date: 2020-07-27
 * Description: 儿童加收项维护
 */
var GV = {
	SELECTEDINDEX : -1,
	EDITINDEX : -1
};

$(function () {
	init_dg();
	
	// 收费项目
	init_TarItem();
	
	// 规则
	init_Rule();
});

/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field: 'RuleDesc', title: '规则', width: 150, editor: {
					type: 'combobox',
					options: {
						valueField: 'RowId',
						textField: 'RuleDesc',
						editable:false,
						url: $URL,
						onBeforeLoad:function(param) {
							param.ClassName = 'BILL.CFG.COM.ChildExtraChargeCom';
							param.QueryName = 'QueryRules';
							param.ResultSetType = "array";
							param.Code = "";
							param.Desc = "";
							param.HospId = PUBLIC_CONSTANT.SESSION.HOSPID;
						},
						onSelect: function(rec) {
							var row = $("#dg").datagrid("getRows")[GV.EDITINDEX];
							if (row) {
								row.RuleId = rec.RowId;
							}
						}
					}
				}
			},
			{field: 'TarDesc', title: '收费项目名称', width: 150, editor: {
					type: 'combobox',
					options: {
						panelHeight: 200,
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLFIND&QueryName=FindTarItem&ResultSetType=array',
						mode: 'remote',
						method: 'get',
						delay: 500,
						blurValidValue: true,
						valueField: 'rowid',
						textField: 'desc',
						onBeforeLoad: function (param) {
							if (!param.q) {
								return false;
							}
							$.extend(param, {
								code: "",                           //项目代码
								desc: "",                           //项目名称 根据输入数据查询
								alias: param.q,                     //别名
								str: '',                //入参串
								HospID: PUBLIC_CONSTANT.SESSION.HOSPID    //医院ID
							});
							return true;
					 	},
						onSelect: function (rec) {
							var row = $("#dg").datagrid("getRows")[GV.EDITINDEX];
							if (row) {
								row.TarId = rec.rowid;
							}
						}
					}
				}},
			{field: 'ActStartDate', title: '有效开始日期', width: 150,
				editor: {
					type: 'datebox'
				}
			},
			{field: 'ActEndDate', title: '有效结束日期', width: 150,
				editor: {
					type: 'datebox'
				}
			},
			{field: 'Rate', title: '加收比例', width: 150,
				editor: {
					type: 'text'
				}
			},
			{field: 'Amt', title: '加收价格', width: 150, align: 'right',
				editor: {
					type: 'text'
				}
			},
			{field: 'RuleCode', title: 'RuleCode', width: 150, hidden: true},
			{field: 'RuleId', title: 'RuleId', width: 150, hidden: true},
			{field: 'TarId', title: 'TarId', width: 150, hidden: true},
			{field: 'RowId', title: 'RowId', width: 150, hidden: true}
		]];

	// 初始化DataGrid
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		columns: dgColumns,
		toolbar: '#tToolBar',
		onLoadSuccess:function(data){
			GV.SELECTEDINDEX = -1;
			GV.EDITINDEX = -1;
		},
		onSelect:function(index,rowData){
			GV.SELECTEDINDEX = index;
		},
		onUnselect:function(index,rowData){
			GV.SELECTEDINDEX = -1;
		}
	});
}

/*
 * 
 */
function init_Rule(){
	$('#Rule').combobox({
		valueField: 'RowId',
		textField: 'RuleDesc',
		url: $URL,
		onBeforeLoad:function(param){
			param.ClassName = 'BILL.CFG.COM.ChildExtraChargeCom';
			param.QueryName = 'QueryRules';
			param.ResultSetType = 'array';
			param.HospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

/*
 * 收费项目
 */
function init_TarItem(){
	$('#TarItem').combobox({
		valueField: 'rowid',
		textField: 'desc',
		url: $URL + '?ClassName=DHCBILLConfig.DHCBILLFIND&QueryName=FindTarItem&ResultSetType=array',
		mode: 'remote',
		method: 'get',
		onBeforeLoad: function (param) {
			if (!param.q) {
				return false;
			}
			$.extend(param, {
				code: "",                           //项目代码
				desc: "",                           //项目名称 根据输入数据查询
				alias: param.q,                     //别名
				str: '',                //入参串
				HospID: PUBLIC_CONSTANT.SESSION.HOSPID    //医院ID
			});
			return true;
	 	}
	})
}

/*
 * 加载数据
 */ 
function initLoadGrid() {
    var queryParams = {
	    ClassName: 'BILL.CFG.COM.ChildExtraChargeCom',
	    QueryName: 'QueryAll',
	    Rule: getValueById('Rule'),
	    TarItem: getValueById('TarItem'),
	    HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	};
    loadDataGridStore('dg', queryParams);
}

/*
 * 新增
 */
$('#BtnAdd').bind('click', function () {
	BeginEdit();
});

function BeginEdit(){
	if(GV.SELECTEDINDEX > -1 && GV.EDITINDEX !=-1){
		$.messager.alert('提示','只能操作一条数据','info');
		return;		
	}
	if(GV.SELECTEDINDEX != GV.EDITINDEX && GV.EDITINDEX > -1 ){
		$.messager.alert('提示','一次只能修改一条数据','info');
		return;		
	}
	
	$('#dg').datagrid('insertRow',{
		index: 0,	// index start with 0
		row: {
			RuleDesc: '',
			TarCode: '',
			TarDesc: '',
			ActStartDate: '',
			ActEndDate: '',
			RuleCode: '',
			TarId: '',
			RowId: '',
			Rate: 0,
			Amt : 0,
			RuleId : ''
		}
	});
	$('#dg').datagrid('beginEdit', 0);
	GV.SELECTEDINDEX = 0;
	GV.EDITINDEX = 0;
}

$('#BtnUpdate').bind('click', function () {
	if(GV.SELECTEDINDEX < 0){
		$.messager.alert('提示', '请选择一条数据', 'info');
		return;		
	}
	
	if(GV.SELECTEDINDEX != GV.EDITINDEX && GV.EDITINDEX > -1 && GV.EDITINDEX !=-1){
		$.messager.alert('提示', '一次只能修改一条数据', 'info');
		return;		
	}
	$('#dg').datagrid('beginEdit', GV.SELECTEDINDEX);
	GV.EDITINDEX = GV.SELECTEDINDEX;
});

/*
 * save
 */
$('#BtnSave').bind('click', function () {
	if(GV.SELECTEDINDEX < 0){
		$.messager.alert('提示','请选择要保存的记录','info');
		return;		
	}
	try {
		$('#dg').datagrid('acceptChanges');
		$('#dg').datagrid('selectRow', GV.EDITINDEX);
		var selRow = $('#dg').datagrid('getSelected');
		var reg = /^[0-9]*$/;
		var reg1 = /^[0-9]+(.[0-9]{2})?$/
		if((!reg1.test(formatAmt(selRow.Rate))) || (!reg.test(selRow.Amt))&&(!reg1.test(formatAmt(selRow.Amt)))){
			$.messager.alert('错误', '请输入有效值', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if(selRow.Rate < 0 || selRow.Rate >1){
			$.messager.alert('错误', '加收比例不能小于0或者大于1', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if(selRow.Rate == 0 && selRow.Amt == 0){
			$.messager.alert('错误', '加收金额、加收比例不能同时为0', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if(selRow.Amt < 0) {
			$.messager.alert('错误', '加收金额不能小于0', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if(selRow.RuleId == '') {
			$.messager.alert('错误', '规则不能为空', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if(selRow.TarId == '') {
			$.messager.alert('错误', '收费项目不能为空', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if (selRow.ActStartDate == '') {
			$.messager.alert('错误', '开始日期不能为空', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		var tmpStDate = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", selRow.ActStartDate);
		if (selRow.ActEndDate != "") {
			var tmpEndDate = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", selRow.ActEndDate);
			if (tmpStDate > tmpEndDate) {
				$.messager.alert('错误', '开始日期不能大于结束日期', 'error');
				$('#dg').datagrid('beginEdit', GV.EDITINDEX);
				return;
			}
		}
		var inputStr = selRow.RowId + "^" + selRow.TarId + "^" + selRow.RuleId + "^" + selRow.ActStartDate + "^" + selRow.ActEndDate + "^" + formatAmt(selRow.Rate) + "^" + formatAmt(selRow.Amt) + "^" + PUBLIC_CONSTANT.SESSION.HOSPID
		var rtn = tkMakeServerCall("BILL.CFG.COM.ChildExtraChargeCom", "Insert", inputStr);
		if(rtn.split('^')[0] != 0) {
			$.messager.alert('提示', "保存失败:" + rtn.split('^')[1], 'error');
			initLoadGrid();
			return;
		}
		$.messager.alert('提示', "保存成功", 'info',function(){
			initLoadGrid();
		});
	}catch(e){
	}
});

/*
* 文件夹选择框
* tangzf 2019-08-09
* input: funOpt : 回调方法   调用成功以后给回调方法传入  界面选择的路径 
* output: 			
*/
function FileOpenWindow(funOpt) {
    try {
        if (typeof funOpt != 'function') {
            $.messager.alert('提示', '传入的方法未定义', 'info');
            return;
        }
        if ($('#FileWindowDiv').length == 0) {
            $('#FileWindowDiv').empty();
            $FileWindowDiv = $("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
            $("body").append($FileWindowDiv);
            $FileWindow = $("<input id='FileWindow' type='file' name='upload'/>");
            $("#FileWindowDiv").append($FileWindow);
            
            $("#FileWindow").on('input', function (e) {
                var FilePath = $('#FileWindow').val();
                FilePath = FilePath.replace("fakepath\\","");
                funOpt(FilePath);
            });
        }
        $('#FileWindow').val("");
        $('#FileWindow').select();
        $(".FileWindow input").click();
    } catch (error) {
        $.messager.alert('提示','dhcinsu.common.js中方法:FileOpenWindow()发生错误:' + error,'info');
    }
}

/*
 * 导入
 */
$('#BtnImport').bind('click', function () {
	var filePath = FileOpenWindow(importFun);
});

function importFun(filePath){
	try{
		if (filePath == "") {
		    $.messager.alert('提示', '请选择文件', 'error');
		    return;
	    }

	    var ErrMsg="";     //错误数据
	    var errRowNums=0;  //错误行数
	    var sucRowNums=0;  //导入成功的行数
	    
		xlApp = new ActiveXObject("Excel.Application"); 
		xlBook = xlApp.Workbooks.open(filePath); 
		xlBook.worksheets(1).select(); 
	    var xlsheet = xlBook.ActiveSheet;
	    
	    var rows=xlsheet.usedrange.rows.count;
	    var columns=xlsheet.usedRange.columns.count;
	    var i,j,k;

		for(i=2;i<=rows;i++){
			var pym="";
			
			var TmpList=new Array();
	        TmpList[0]="";
	        var InString="";
			for (j=1;j<=columns;j++){
				TmpList[j]=xlsheet.Cells(i,j).text;
			}
						
			for(k=1;k<TmpList.length;k++){
				if (InString == ""){
					InString=TmpList[k];
				}else{
					InString=InString+"^"+TmpList[k];
				}
				
			}
			InString =  "^" +  InString;
 	        var savecode=tkMakeServerCall("BILL.CFG.COM.ChildExtraChargeCom", "Insert", InString).split('^')[0];
			if(savecode==null || savecode==undefined) savecode=-1;
			if(eval(savecode)>=0){
				sucRowNums=sucRowNums+1;
		
			}else{
				errRowNums=errRowNums+1; 
				if(ErrMsg==""){
					ErrMsg=i;
				}else{
					ErrMsg=ErrMsg+"\t"+i;
				}
			}
		}
		
		if(ErrMsg==""){
			$.messager.alert('提示', '数据正确导入完成', 'info');
		}else{
			var tmpErrMsg="成功导入【"+sucRowNums+"/"+(rows-1)+"】条数据";
			tmpErrMsg=tmpErrMsg+"失败数据行号如下：\n\n"+ErrMsg;
			$.messager.alert('提示', tmpErrMsg, 'error');   
		}
		initLoadGrid();
	}
	catch(e){
		$.messager.alert('提示', "导入时发生异常：ErrInfo：" + e.message, 'error');
	}
	finally{
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}	
}

/*
 * 删除
 */
$('#BtnDelete').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.RowId != "") {
			$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
				if (r) {
					var inputStr = selected.RowId;
					var rtn=tkMakeServerCall("BILL.CFG.COM.ChildExtraChargeCom", "Delete", inputStr);
					if (rtn != 0){
						$.messager.alert('提示', "删除失败" + rtn, 'error');
						return;
					}
					$.messager.alert('提示', "删除成功", 'info',function(){
						initLoadGrid();
					});
				}
			});
		}
	} else {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
	}
});

/*
 * 查询
 */
$('#BtnFind').bind('click', function () {
	FindClick();
});

/*
 * 查询
 */
function FindClick() {
	initLoadGrid();
}

function selectHospCombHandle(){
	$('#Rule').combobox('clear');
	$('#Rule').combobox('reload');
	$('#TarItem').combobox('clear');
	$('#TarItem').combobox('reload');
	initLoadGrid();
}