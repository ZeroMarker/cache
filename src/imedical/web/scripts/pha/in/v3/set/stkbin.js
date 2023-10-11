/**
 * 模块:     科室货位码维护
 * 编写日期: 2022-03-31
 * 编写人:   yangshijie
 */
 
var searchboxWidth = 133 ; //模糊搜索框的宽度
var gridIdArr = ['', 'gridFirst', 'gridSecond', 'gridThird'];
var qTextArr = ['', $g('货架'), $g('层'), $g('列')];
var arrLen = gridIdArr.length;
var sbId = '';  //多级货位表在点击公用一个RowId

$(function () {
    InitDict();
    InitGrid();
    ImportHandler();
    BindBtnEvent();
    QueryLoc();
});
function BindBtnEvent(){
	PHA_EVENT.Bind('#btnImportWin', 'click', function(){ImportWin();});
	PHA_EVENT.Bind('#btnImportFile', 'click', function(){ImportFile();});
	PHA_EVENT.Bind('#btnExportFile', 'click', function(){ExportFile();});
}

//初始化数据
function InitSbData() {}

function InitDict() {
	/* 科室模糊查询 */
    $('#locQText').searchbox({
	    searcher:function(value,name){
	    QueryLoc();
	    },
		width: 182,
	    prompt:$g('科室模糊查询...')
	});
	
	/* 科室模糊查询 遍历定义 */
	for (i=1;i<arrLen;i++){
		$('#' + gridIdArr[i] + 'QText' ).searchbox({
			width:searchboxWidth,
		    searcher:function(value,name){
			    var searchboxId = this.id;
			    var searchboxId = searchboxId.replace(/(#)|(QText)/g, ''); 
			    var level = gridIdArr.indexOf(searchboxId);
		    	QueryStkbin(level);
		    },
		    prompt: qTextArr[i] + $g('模糊查询...')
		});
	}
	
	/* 药品模糊查询 */
    $('#useQText').searchbox({
	    searcher:function(value,name){
	    QueryUseDrug(sbId);
	    },
	    prompt:$g('药品模糊查询...')
	});
    $('#notUseQText').searchbox({
	    searcher:function(value,name){
	    QueryNotUseDrug(sbId);
	    },
	    prompt:$g('药品模糊查询...')
	});
	
	/* 货位下拉树 
	PHA.ComboTree('stkBinTree', {
        url: PHA_IN_STORE.StkBinTree().url
    });*/
     /* 货位下拉框 
    PHA.ComboBox('stkBinComb', {
        url: PHA_IN_STORE.StkBinComb().url,
    });*/
    /* 货架下拉框 
    PHA.ComboBox('stkBinRacks', {
        url: PHA_IN_STORE.StkBinRacks().url,
        multiple:true,
        rowStyle:'checkbox' //显示成勾选行形式
    });*/
	
	/* 帮助提示信息 */	
	var contentStr = "";
	// contentStr += $g("------------以下为用户读取------------");
	contentStr += $g("1.整个货位由三段组成，分别为，货架(货架号)，层(货架的哪一层)，列(一层的哪一列)，三段货位描述时尽量使用相同长度的字符串，方便货位显示对齐，如果长度固定为2，则1号货位维护成'01'")
	contentStr += "<br>" + $g("2.货位在维护时尽量用英文字符和数字组合来维护(方便货位的排序，汉字排序混乱)。可使用如：东A-01-01(东A货架，01层，01列)")
	contentStr += "<br>" + $g("3.货位在维护时尽量不要使用符号 尤其'-'和 ':',可能会造成货位显示混乱")
	contentStr += "<br>" + $g("4.货位的完成显示格式为 '货架-层-列'")
	//contentStr += "<br>" + $g("------------以下为开发读取------------")
	//contentStr += "<br>" + $g("1.界面提供三种货位下拉方式，1).树(不可填),2).下拉框(可填)，3).下拉框(仅货架号，在盘点时使用)")
	$(".icon-help").popover({title:'温馨提示',width:"400",content: contentStr});
	
	/*
	PHA_UX.ComboBox.Loc('phLocId');
	PHA_UX.ComboTree.stkBin('stkBinTree', {
		qParams: {
			LocId: PHA_UX.Get('phLocId', session['LOGON.CTLOCID'])
		}
	});
	*/
}

function InitDictRela(){
	return;
	var locId = GetLocId();
	if (!locId) return;
	$('#stkBinTree').combotree('clear');
    $('#stkBinTree').combotree('reload', PHA_STORE.StkBinTree(locId).url);
    $('#stkBinComb').combobox('reload', PHA_STORE.StkBinComb(locId).url);
    $('#stkBinRacks').combobox('reload', PHA_STORE.StkBinRacks(locId).url);
}


function InitGrid(){
	InitGridLoc();
	for (i=1;i<arrLen;i++){
		InitGridStkBin(i)
	}
	InitGridUseDrug();
	InitGridNotUseDrug();
}


/// ------------------- 查询方法---Start-----------------///
function QueryLoc(){
	Clear();
	var pJson = {
	    locQText:$('#locQText').searchbox('getValue') ,
	    hospId:PHA_COM.Session.HOSPID,
	    logLoc:PHA_COM.Session.CTLOCID,
	    groupId:PHA_COM.Session.GROUPID,
    }
	$('#gridLoc').datagrid('query', {
        pJsonStr : JSON.stringify(pJson),
    });
}

function QueryStkbin(level){
	/* 查询药品数据 */
	var parSbId = GetSbId(level - 1)
	QueryDrug(parSbId);
	
	ClearStkBin(level - 1);
	
	/* 查询货位信息 */
	if (level >= arrLen) return;
	var locId = GetLocId();
	var qText = GetQText(level)
	var pJson = {
		locId  : locId,
		qText  : qText,
		parSbId: parSbId,
		level  : level
	}
    $('#' + gridIdArr[level]).datagrid('query', {
        pJsonStr : JSON.stringify(pJson),
    });
}

function QueryStkbinNext(level){
	if(level >= arrLen) return;
	QueryStkbin(level + 1)
}

function QueryDrug(sbId){
	if(!sbId) return;
	QueryUseDrug(sbId);
	QueryNotUseDrug(sbId);
}

function QueryUseDrug(sbId){
	var qText = $('#useQText').searchbox('getValue')
	$('#gridUseDrug').datagrid('query', {
        pJsonStr : JSON.stringify({sbId:sbId,qText:qText}),
    });
}
function QueryNotUseDrug(sbId){
	var qText = $('#notUseQText').searchbox('getValue')
	$('#gridNotUseDrug').datagrid('query', {
        pJsonStr : JSON.stringify({sbId:sbId,qText:qText}),
    });
}

function GetLocId(){
	var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.RowId;
    return '';
}

function GetSbId(level){
	if (!level) return '';
	var gridSelect = $('#'+ gridIdArr[level]).datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.sbId;
    return '';
}

function GetQText(level){
	return $('#'+ gridIdArr[level] + 'QText').searchbox('getValue') 
}
/// =================== 查询方法 === End =================== ///
/// ------------------- 清除方法 --- Start-----------------///
function Clear()
{
	//ClearLoc();
	ClearStkBin(0);
}

function ClearLoc(){
    $('#gridLoc').datagrid('loadData', []);
}

function ClearStkBin(level){
	for (i=4;i>level;i--){
		var gridId = '#' + gridIdArr[i]
	    $(gridId).datagrid('loadData', []);
	    
	}
	ClearDrug();
}

function ClearDrug(){
	$('#gridUseDrug').datagrid('loadData', []);
	$('#gridNotUseDrug').datagrid('loadData', []);
}
/// =================== 清除方法 === End =================== ///


/// ------------------- 定义grid --- Start-----------------///

function InitGridLoc(){
	var columns = [
        [
            // RowId,Description
            { field: 'RowId', 			title: 'busiId', 		hidden: true },
            { field: 'Description', 	title: '科室名称', 		width: 50, 		align: 'left' },
        ]
    ];
    var pJson = {
	    locQText:'',
	    hospId:PHA_COM.Session.HOSPID,
	    logLoc:PHA_COM.Session.CTLOCID,
	    groupId:PHA_COM.Session.GROUPID,
    }
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.STORE.Com', 
            pMethodName: 'GetGroupDept',
            pPlug	   : 'datagrid',
            pJsonStr   : JSON.stringify(pJson),
        },
        exportXls: false,
        fitColumns: true,
        fit: true,
        columns: columns,
        pagination: false,
        toolbar: '#gridLocBar',
        onClickRow: function (rowIndex, rowData) {
	        ClearStkBin(2);
            QueryStkbin(1);
            InitDictRela();
        }
    };
    PHA.Grid('gridLoc', dataGridOption);
}

function InitGridStkBin(level) {
    var columns = [
        [
            // sbId,level,sbDesc
            { field: 'sbId', 	title: 'sbId', 		hidden: true },
            { field: 'level', 	title: 'level', 	hidden: true },
            { field: 'sbDesc', 	title: '描述', 		width: 50, 		align: 'left' ,
            	editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			},
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.StkBin.Api',
            pMethodName: 'QueryLevelStkBin',
            pPlug	   : 'datagrid',
            pJsonStr   : JSON.stringify({}),
        },
        gridSave: false,
        exportXls: false,
        fitColumns: true,
        fit: true,
        isCellEdit: false,
        columns: columns,
        pagination: false,
        toolbar: '#' + gridIdArr[level] + 'Bar',
        onClickRow: function (rowIndex, rowData) {
	        if (!PHA_GridEditor.EndCheck(gridIdArr[level])) return;
	        ClearStkBin(level + 1)
            QueryStkbinNext(level);
            sbId = rowData.sbId;
        },
        onDblClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		     	if (!PHA_GridEditor.EndCheck(gridIdArr[level])) return;
		        PHA_GridEditor.Edit({
					gridID: gridIdArr[level],
					index: rowIndex,
					field: 'sbDesc'
				});
            }
        }
    };
    PHA.Grid(gridIdArr[level], dataGridOption);
}

function InitGridUseDrug(){
	var columns = [
        [
            // sbiId,incil,inciCode,inciDesc,sbDesc
            { field: 'sbiId', 		title: 'sbiId', 		hidden: true },
            { field: 'incil', 		title: 'incil', 		hidden: true },
            { field: 'deleteBut',   title: '删除',          width: 59,			align: 'center',	formatter: deleteSbiFormatter,	frozencols:true	},
            { field: 'inciCode', 	title: '药品代码', 		width: 150, 		align: 'left' },
            { field: 'inciDesc', 	title: '药品名称', 		width: 250, 		align: 'left' },
            { field: 'sbDesc', 		title: '货位', 			width: 200, 		align: 'left' }
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.StkBin.Api', 
            pMethodName: 'QueryUseDurg',
            pPlug	   : 'datagrid',
            pJsonStr   : '{}',
        },
        gridSave:false,
        exportXls: false,
        fitColumns: false,
        fit: true,
        columns: columns,
        pagination: true,
        idField: 'sbiId',
        toolbar: '#gridUseDrugBar',
        onClickRow: function (rowIndex, rowData) {}
    };
    PHA.Grid('gridUseDrug', dataGridOption);
}

function deleteSbiFormatter(value, rowData, rowIndex) {
	    var sbiId = rowData.sbiId;
		return (
			'<span class="icon icon-cancel"  onclick="DeleteDrug(\'' +
			sbiId +
			'\')">&ensp;</span>'
		);
	}


function InitGridNotUseDrug(){
	var columns = [
        [
            // sbiId,incil,inciCode,inciDesc,sbDesc
            { field: 'incil', 		title: 'incil', 		hidden: true },
	        { field: 'addBut',      title: '添加',          width: 59,			align: 'center',	formatter: AddDrugFormatter,	frozencols:true	},
            { field: 'inciCode', 	title: '药品代码', 		width: 150, 		align: 'left' },
            { field: 'inciDesc', 	title: '药品名称', 		width: 250, 		align: 'left' },
            { field: 'sbDesc', 		title: '货位', 			width: 200, 		align: 'left' }
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.StkBin.Api', 
            pMethodName: 'QueryNotUseDurg',
            pPlug	   : 'datagrid',
            pJsonStr   : '{}',
        },
        gridSave:false,
        exportXls: false,
        fitColumns: false,
        fit: true,
        columns: columns,
        pagination: true,
        idField: 'incil',
        toolbar: '#gridNotUseDrugBar',
        onClickRow: function (rowIndex, rowData) {}
    };
    PHA.Grid('gridNotUseDrug', dataGridOption);
}

function AddDrugFormatter(value, rowData, rowIndex) {
    var incil = rowData.incil;
	return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddDrug(\'' +
        incil +
        '\')">&ensp;</span>'
    );
}

/// =================== 定义grid === End =================== ///

/// -------------------新增行 --- Start------------------------///
// 新增货位
function Add(level){
	if (!level){
		HA.Msg('alert' ,'货位等级不能为空！');
	    return;
	}
	var locId = GetLocId();
	var parSbId = GetSbId(level - 1);
	if (level == 1) {
		if((!locId)){
	    	PHA.Msg('alert' ,'请选择一个科室！');
	    	return;
		}
    }else if (!parSbId){
	    PHA.Msg('alert' ,'上一级货位为空！');
	    return;
    }
	PHA_GridEditor.Add({
		gridID: gridIdArr[level],
		field: 'sbDesc',
		checkRow: true
	});
}

/// =================新增行 === End ===================///

/// ---------------保存+删除 --- Start-----------------///
// 保存货位
function SaveSb(level) {
	if (!level){
		HA.Msg('alert' ,'货位等级不能为空！');
	    return;
	}
	var locId = GetLocId();
	var parSbId = GetSbId(level - 1);
	if (level == 1) {
		if((!locId)){
	    	PHA.Msg('alert' ,'请选择一个科室！');
	    	return;
		}
    }else if (!parSbId){
	    PHA.Msg('alert' ,'上一级货位为空！');
	    return;
    }
    if (!PHA_GridEditor.EndCheck(gridIdArr[level])) return;
    var gridChanges = $('#'+ gridIdArr[level]).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,'没有需要保存的数据！');
	    return;
    }
    var pJson = {
	    locId : locId,
	    parSbId : parSbId,
	    level : level,
	    rows  : gridChanges
    }
    PHA.CM(
        {
            pClassName : 'PHA.IN.StkBin.Api',  
            pMethodName: 'SaveSb',
            pJsonStr   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryStkbin(level);
			}
        }
    )
}

// 删除货位
function DeleteSb(level) {
	var gridId = '#' + gridIdArr[level]
	var gridSelect = $(gridId).datagrid('getSelected') || '';
    if (!gridSelect) {
        PHA.Msg('alert', '请选择一个货位' );
        return;
    }
    var sbId = gridSelect.sbId || '';
    if (sbId == '') {
        var rowIndex = $(gridId).datagrid('getRowIndex', gridSelect);
        $(gridId).datagrid('deleteRow', rowIndex);
        return;
    }
    var msgTitle = '您确定删除吗？'
    
   var retData = PHA.CM(
        {
            pClassName : 'PHA.IN.StkBin.Api',  
            pMethodName: 'CheckSbDurg',
            pJsonStr   : JSON.stringify({sbId: sbId}),
        },
        false
    );
    if (retData.code < 0) {
        PHA.Msg('alert', retData.msg );
        return;
    }
    else if (retData.data){
        msgTitle = '该货位上或者下级货位上已经维护药品，' + msgTitle;
    }
    $.messager.confirm('确认对话框', msgTitle, function (r) {
        if (r) {
            PHA.CM(
                {
                    pClassName : 'PHA.IN.StkBin.Api',  
		            pMethodName: 'DeleteSb',
		            pJsonStr   : JSON.stringify({sbId: sbId}),
                },
                function (retData) {
	                if (PHA.Ret(retData)) {
		                QueryStkbin(level);
		            } 
                }
            );
        }
    });	
}

// 删除药品
function DeleteDrug(sbiId) {
	if(!sbiId){
		PHA.Msg('alert', '请选择一个要药品' );
        return;
	}
	$.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            PHA.CM(
                {
                    pClassName : 'PHA.IN.StkBin.Api',  
		            pMethodName: 'DeleteDrug',
		            pJsonStr   : JSON.stringify({sbiId: sbiId}),
                },
                function (retData) {
	                if (PHA.Ret(retData)) {
		                QueryDrug(sbId);
		            } 
                }
            );
        }
    });
}
// 删除药品
function AddDrug(incil) {
	if(!incil){
		PHA.Msg('alert', '请选择一个药品' );
        return;
	}
    PHA.CM(
        {
            pClassName : 'PHA.IN.StkBin.Api',  
            pMethodName: 'AddDrug',
            pJsonStr   : JSON.stringify({incil: incil,sbId:sbId}),
        },
        function (retData) {
            if (PHA.Ret(retData)) {
                QueryDrug(sbId);
            } 
        }
    );

}

/// =====================保存+删除 === End ================///


function ImportWin(){
	PHA.DomData('#ExportWin', {doType: 'clear'});
	$('#ImportWin')
    .dialog({
        iconCls: 'icon-w-import',
        modal: true,
        onBeforeClose: function () {},
    })
    .dialog('open');
}


function ImportHandler() {
	$('#conFileBox').filebox({
		prompt: $g('请选择文件...'),
		buttonText: $g('选择'),
		width: 250,
		accept: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel'
	})
}

function ImportFile(){
	var filelist = $('#conFileBox').filebox('files');
	if (filelist.length == 0) {
		PHA.Msg('alert', '请先选择文件！' );
		return;
	}
	var file = filelist[0];
	PHA_COM.ReadExcel(file,function(xlsData){
		var pJson = JSON.stringify({rows: xlsData});
		var pJson = ReplaceStr(pJson);
		
		PHA.CM(
	        {
	            pClassName : 'PHA.IN.StkBin.Api',  
	            pMethodName: 'ImportFile',
	            pJson      : pJson,
	        },
	        function (retData) {
	            if (PHA.Ret(retData)) {
	                $('#ImportWin').dialog('close');
	            } 
	        }
	    );
	});
}

function ReplaceStr(str){
	var str = str.replace(/#科室名称#/g, 'locDesc');
	var str = str.replace(/#货架#/g, 'jia');
	var str = str.replace(/#层#/g, 'ceng');
	var str = str.replace(/#列#/g, 'lie');
	var str = str.replace(/#药品代码#/g, 'inciCode');
	var str = str.replace(/#药品名称#/g, 'inciDesc');
	return str;
}

function ExportFile(){
	var title={
		locDesc	 : '#科室名称#',
		jia		 : '#货架#',
		ceng	 : '#层#',
		lie		 : '#列#',
		inciCode : '#药品代码#',
		inciDesc : '#药品名称#',
	}
	var data = [
		{
			locDesc	 : '西药库',
			jia		 : '货1',
			ceng	 : '层1',
			lie		 : '',
			inciCode : 'XWY000002',
			inciDesc : '磷酸钠盐灌肠液(辉力)[133ml]',
		}, 
		{
			locDesc	 : '西药库',
			jia		 : '货2',
			ceng	 : '层2',
			lie		 : '列2',
			inciCode : 'XWY000003',
			inciDesc : '盐酸丁卡因胶浆(利宁)[5G]',
		}
	]
	var fileName='科室货位码导入模版.xlsx'
	PHA_COM.ExportFile(title, data, fileName);
}