/**
 * 模块		: 定价规则维护
 * 编写日期	: 2022-05-31
 * 编写人	: yangsj
 */
 
var hospWidth = 330;
var TABLENAME = 'DHC_MarkRule';  // 子表 DHC_MarkRuleAdd

var GRIDID_M = 'gridMarkRule';
var GRIDID_D = 'gridItm';
var GRIDBARID_M = '#gridMarkRuleBar';
var GRIDBARID_D = '#gridItmBar';
var APINAME = 'PHA.IN.MarkInfo.Api';

$(function () {
	InitHosp();		// 初始化医院
    InitDict();    	// 初始化字典
    InitGrid();    	// 初始化表格
    setTimeout("Query()", 500);
});

function InitHosp(){
    var hospComp = GenHospComp(TABLENAME, '', { width: hospWidth });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        InitDict();
        Query();
        
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: TABLENAME,
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitDict(){}

function InitGrid(){
	InitGridMarkRule();
	InitGridItm();
}


function InitGridMarkRule(){
	var columns = [
        [
            { field: 'mrId', 		title: 'mrId', 			hidden: true },
            { field: 'mrCode', 		title: '代码',  		align: 'left',		width: 80,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'mrDesc', 		title: '名称',  		align: 'left',		width: 100,		editor: {type: 'validatebox',options: {required: true}}},  
        	{ field: 'minRp', 		title: '规则下限',  	align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4})},  
            { field: 'maxRp', 		title: '规则上限',  	align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4})},  
            { field: 'margin', 		title: '加成率',  		align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4})},  
            { field: 'mPrice', 		title: '加成额',  		align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4})},  
            { field: 'maxMargin', 	title: '最高加成率',  	align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4})},  
            { field: 'maxMPrice', 	title: '最高加成额',  	align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4})},  
        	{ field: 'sdId', 		title: '小数规则',  	align: 'left',		width: 120,		descField: 'sdDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					loadRemote: true,
					url: PHA_IN_STORE.DecimalRule().url,
					onBeforeLoad: function (param) {
						param.hospId = PHA_COM.Session.HOSPID;
					}
				}),
                formatter: function (value, row, index) {
                    return row.sdDesc;
                }
            },  
            { field: 'mtId', 		title: '定价类型',  	align: 'left',		width: 120,		descField: 'mtDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					loadRemote: true,
					url: PHA_IN_STORE.MarkType().url,
					onBeforeLoad: function (param) {
						param.hospId = PHA_COM.Session.HOSPID;
					}
				}),
                formatter: function (value, row, index) {
                    return row.mtDesc;
                }},  
        	{ field: 'useFlag', 	title: '使用',  		align: 'left',		width: 60,		editor: PHA_GridEditor.CheckBox({})	, formatter: PHA_GridEditor.CheckBoxFormatter},
            { field: 'remark', 		title: '备注',  		align: 'left',		width: 100,		editor: {type: 'validatebox',options: {}}},  
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryMarkRule',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        //idField: 'mrId',
        columns: columns,
        toolbar: GRIDBARID_M, 
        btoolbar:[{
			xtype:'label',
			text:$g("售价计算规则：如果不维护[定价规则明细],则售价=进价*(1+加成率)+加成额"),
			align:'center'
		}],
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData){
	        if (!PHA_GridEditor.EndCheck(GRIDID_M)) return;
	        QueryItm();
        },
		onDblClickCell: function (index, field, value) {
		    if (!PHA_GridEditor.EndCheck(GRIDID_M)) return;
			PHA_GridEditor.Edit({
				gridID : GRIDID_M,
				index  : index,
				field  : field,
				forceEnd : true
			});
		}
	    
	    
    };
    PHA.Grid(GRIDID_M, dataGridOption);
}

function InitGridItm(){
	var columns = [
        [
            { field: 'mraId', 		title: 'mraId', 		hidden: true },
            { field: 'mraCode', 	title: '代码',  		align: 'left',		width: 80,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'mraDesc', 	title: '名称',  		align: 'left',		width: 100,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'minRp', 		title: '下限',  		align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4,required: true})},  
            { field: 'maxRp', 		title: '上限',  		align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4,required: true})},  
        	{ field: 'margin', 		title: '加成率',  		align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4})},
        	{ field: 'useFlag', 	title: '使用',  		align: 'left',		width: 60,		editor: PHA_GridEditor.CheckBox({})	, formatter: PHA_GridEditor.CheckBoxFormatter},
            { field: 'remark', 		title: '备注',  		align: 'left',		width: 100,		editor: {type: 'validatebox',options: {}}},  
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryMarkRuleItm',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        //idField: 'mraId',
        columns: columns,
        toolbar: GRIDBARID_D,
        btoolbar:[{
			xtype:'label',
			text:$g('若维护了[定价规则明细],则使用阶梯加成规则：售价=阶梯1部分金额*(1+阶梯1加成率)+阶梯2部分金额*(1+阶梯2加成率)+阶梯3部分金额*(1+阶梯3加成率)+...'),
			align:'center'
		}],
  
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData){
	        if (!PHA_GridEditor.EndCheck(GRIDID_D)) return;
        },
	    onDblClickCell: function (index, field, value) {
		    if (!PHA_GridEditor.EndCheck(GRIDID_D)) return;
			PHA_GridEditor.Edit({
				gridID : GRIDID_D,
				index  : index,
				field  : field,
				forceEnd : true
			});
		}
    };
    PHA.Grid(GRIDID_D, dataGridOption);
}


function Query(){
	$('#' + GRIDID_D).datagrid('loadData', []);
	$('#' + GRIDID_M).datagrid('query', {
        pJson : JSON.stringify({hospId:PHA_COM.Session.HOSPID}),
    });
}
function QueryItm(){
	var mrId = GetMrId();
	if(!mrId){
		PHA.Msg('alert', '请选择一条规则记录！');
	    return;
	}
	$('#' + GRIDID_D).datagrid('query', {
        pJson : JSON.stringify({mrId:mrId}),
    });
}


function Clear(){
	$('#' + GRIDID_M).datagrid('loadData', []);
}

function Add(){
	PHA_GridEditor.Add({
		gridID   : GRIDID_M,
		field    : 'mrCode',
		checkRow : true,
		rowData  : {
			useFlag : 'Y'
		}
	});
}
function Addi(){
	var mrId = GetMrId();
	if(!mrId){
		PHA.Msg('alert', '请选择一条规则记录！');
	    return;
	}
	PHA_GridEditor.Add({
		gridID   : GRIDID_D,
		field    : 'mraCode',
		checkRow : true,
		rowData  : {
			len : 2,
			useFlag : 'Y'
		}
	});
}

function GetMrId(){
	var gridSelect = $('#' + GRIDID_M).datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.mrId;
    return '';
}

function Save(){
	if (!PHA_GridEditor.EndCheck(GRIDID_M)) return;
    var gridChanges = $('#' + GRIDID_M).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert', '没有需要保存的数据！');
	    return;
    }
    var pJson = {
	    hospId : PHA_COM.Session.HOSPID,
	    rows   : gridChanges
    } 
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'SaveMarkRule',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				Query();
			}
        }
    )
}


function Savei(){
	if (!PHA_GridEditor.EndCheck(GRIDID_D)) return;
    var gridChanges = $('#' + GRIDID_D).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert', '没有需要保存的数据！');
	    return;
    }
    var mrId = GetMrId();
	if(!mrId){
		PHA.Msg('alert', '请选择一条规则记录！');
	    return;
	}
    var pJson = {
	    mrId   : mrId,
	    hospId : PHA_COM.Session.HOSPID,
	    rows   : gridChanges
    } 
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'SaveMarkRuleItm',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryItm();
			}
        }
    )
}

function Delete(){
	var gridSelect = $('#' + GRIDID_M).datagrid('getSelected');
    if (!gridSelect) {
	    PHA.Msg('alert' ,'请选择需要删除的记录！');
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var mrId = gridSelect.mrId || '';
            if (mrId == '') {
                var rowIndex = $('#' + GRIDID_M).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID_M).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            mrId  : mrId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeleteMarkRule',
			            pJson   : JSON.stringify(pJson),
			        },
			        function (retData) {
				        if (PHA.Ret(retData)) {
							Query();
						}
			        }
			    )
            }
        }
    });
}



function Deletei(){
	var gridSelect = $('#' + GRIDID_D).datagrid('getSelected');
    if (!gridSelect) {
	    PHA.Msg('alert' ,'请选择需要删除的记录！');
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var mraId = gridSelect.mraId || '';
            if (mraId == '') {
                var rowIndex = $('#' + GRIDID_D).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID_D).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            mraId  : mraId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeleteMarkRuleItm',
			            pJson   : JSON.stringify(pJson),
			        },
			        function (retData) {
				        if (PHA.Ret(retData)) {
							QueryItm();
						}
			        }
			    )
            }
        }
    });
}

