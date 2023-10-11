/**
 * 模块		: 科室请领关系
 * 编写日期	: 2022-05-30
 * 编写人	: yangsj
 */
 
var hospWidth = 225;
var searchboxWidth = 300;
var TABLENAME = 'CT_Loc';  //'DHCST_LocRelation'; 依附于科室新建的属性，都以科室表作为授权医院取值的参考。

var GRIDID = 'gridReqLoc';
var GRIDBARID = '#gridReqLocBar';
var APINAME = 'PHA.IN.Locreqrela.Api';

$(function () {
	InitHosp();		// 初始化医院
    InitDict();    	// 初始化字典
    InitGrid();    	// 初始化表格
    setTimeout('QueryLoc()', 500);
});

function InitHosp(){
    var hospComp = GenHospComp(TABLENAME, '', { width: hospWidth });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        InitDict();
        QueryLoc();
        
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
}

function InitDict(){
		$('.icon-help').popover({
			title:'提示',
			width:'400',
			content:$g('<b>交互关系</b>：选择\'互相申领\'则系统会自动生成两条请领关系，如果需要将\'互相申领\'改为\'单向申领\'请手动删除请领科室的请领关系。')
			
		});

	
	GridCmbEachRela = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        data : [
        	{
	        	RowId:'Each',
	        	Description : $g('互相申领')
	        },
	        {
	        	RowId:'Single',
	        	Description : $g('单向申领')
	        }
        ]
    });
    
    /// 已维护药品别名
    $('#txtAliasIn').searchbox({
	    searcher:function(value,name){
	    QueryInciIn();
	    },
	    width:searchboxWidth,
	    prompt:$g('别名模糊查询...')
	});
    
    /// 未维护药品别名
    $('#txtAliasOut').searchbox({
	    searcher:function(value,name){
	    QueryInciOut();
	    },
	    width:searchboxWidth,
	    prompt:$g('别名模糊查询...')
	});
}

function InitGrid(){
	InitGridLoc();
	InitGridStktkWin();
	InitGridInciIn();
	InitGridInciOut();
}

function InitGridLoc(){
	Loc_Com.Init('gridLoc', 'gridLocBar', QueryReqLoc)
}

function InitGridStktkWin(){
	var columns = [
        [
            { field: 'lrrId', 		title: 'lrrId', 			hidden: true },
            { field: 'recLocCode', 	title: '科室代码',  		width: 80,		align: 'left'	},  
            { field: 'recLocId',	title: '科室名称',			width: 120,	  	descField: 'recLocDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.CTLoc().url
				}),
                formatter: function (value, row, index) {
                    return row.recLocDesc;
                }
            },
            { field: 'eachRela', 	title: '交互关系', 		width: 80,		descField: 'eachRelaDesc', editor: GridCmbEachRela,
            	formatter: function (value, row, index) {
                    return row.eachRelaDesc;
                }
            },
            { field: 'eachRelaDesc', 	title: 'eachRelaDesc', 			hidden: true },
            { field: 'opertId', 		title: '转移出库类型',  	width: 100,		align: 'left',				descField: 'opertDesc',
                editor: PHA_GridEditor.ComboBox({
					tipPosition: 'top',
					url: PHA_IN_STORE.OperateType('O').url
				}),
                formatter: function (value, row, index) {
                    return row.opertDesc;
                }
            }, 
            { field: 'opertDesc', 		title: '转移出库类型描述',  hidden: true },
            
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryLocReqRela',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        //idField: 'lrrId',
        columns: columns,
        toolbar: GRIDBARID,  
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData){
	        if (!PHA_GridEditor.EndCheck(GRIDID)) return;
	        QueryInci();
        },
	    onDblClickCell: function (index, field, value) {
		    if (!PHA_GridEditor.EndCheck(GRIDID)) return;
		    
		    var gridSelect = $('#' + GRIDID).datagrid('getSelected') || '';
			var tt = $('#' + GRIDID).datagrid('getColumnOption', 'eachRela');
    		if (gridSelect.lrrId != '' && gridSelect.lrrId != undefined){
	    		tt.editor = {};
    		}
    		else {
	    		tt.editor = GridCmbEachRela;
    		}
    		
			PHA_GridEditor.Edit({
				gridID : GRIDID,
				index  : index,
				field  : field,
				forceEnd : true
			});
			
			
		}
    };
    PHA.Grid(GRIDID, dataGridOption);
}

//初始化已分类药品列表
function InitGridInciIn() {
    //定义columns
    var columns = [
        [
            // LCGII,InciCode,InciDesc
            { field: 'lrriId', title: 'lrriId', width: 100, hidden: true },
            {
                field: 'operate',
                title: '操作',
                width: 60,
                halign: 'center',
                align: 'center',
                formatter: statusFormatterDel,
            },
            { field: 'inciCode', title: '药品代码', width: 120, halign: 'center', align: 'left' },
            { field: 'inciDesc', title: '药品名称', width: 240, halign: 'center', align: 'left' },
            
        ],
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryInciIn',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: true,
        //fitColumns: true,
        fit: true,
        //idField: 'LCGII',
        rownumbers: true,
        columns: columns,
        nowrap: false,
        toolbar: '#InciInBar',
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function () {},
    };
    PHA.Grid('gridInciIn', dataGridOption);
}
//初始化未分类药品列表
function InitGridInciOut() {
    //定义columns
    var columns = [
        [
            // inci,incicode,incidesc
            { field: 'inci', title: 'inci', width: 100, hidden: true },
            {
                field: 'operate',
                title: '操作',
                width: 60,
                halign: 'center',
                align: 'center',
                formatter: statusFormatterAdd,
            },
            { field: 'inciCode', title: '药品代码', width: 120, halign: 'center', align: 'left' },
            { field: 'inciDesc', title: '药品名称', width: 240, halign: 'center', align: 'left' },
            
        ],
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryInciOut',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        toolbar: '#toolbar', //保持不改变高度
        pagination: true,
        fit: true,
        //idField: 'inci',
        rownumbers: true,
        columns: columns,
        toolbar: '#InciOutBar',
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function () {},
    };
    PHA.Grid('gridInciOut', dataGridOption);
}

function QueryLoc(){
	ClearGridArr(['gridReqLoc', 'gridInciIn', 'gridInciOut'])
	
	var locJsonStr = PHA.DomData('#gridLocBar', {
        doType: 'query',
        retType: 'Json'
    });
	var pJson = locJsonStr[0];
	pJson['hospId'] = PHA_COM.Session.HOSPID;
	pJson['groupId'] = session['LOGON.GROUPID'];
	
	$('#gridLoc').datagrid('query', {
        pJson : JSON.stringify(pJson),
    });
}

function QueryReqLoc(){
	var locId = GetLocId();
	if(!locId) return;
	
	ClearGridArr(['gridInciIn','gridInciOut'])
	$('#' + GRIDID).datagrid('query', {
        pJson : JSON.stringify({proLocId:locId}),
    });
}

function QueryInci(){
	QueryInciIn();
	QueryInciOut();
}

///查询已维护药品
function QueryInciIn() {
	var lrrId = GetLrrId();
	if(!lrrId) return;
	var alias = $('#txtAliasIn').searchbox('getValue')
	var pJson = {
		lrrId : lrrId,
		alias : alias
	}
    $('#gridInciIn').datagrid('query', {
        pJson : JSON.stringify(pJson),
    });
}

///查询未维护药品
function QueryInciOut() {
    var lrrId = GetLrrId();
	if(!lrrId) return;
	var alias = $('#txtAliasOut').searchbox('getValue')
	var pJson = {
		lrrId : lrrId,
        alias: alias,
        hospId : PHA_COM.Session.HOSPID
	}
    $('#gridInciOut').datagrid('query', {
        pJson : JSON.stringify(pJson),
    });
}


function Clear(){
	PHA.DomData('#gridLocBar', {
    	doType: 'clear',
	});
	$('#txtAliasIn').searchbox('clear');
	$('#txtAliasOut').searchbox('clear');
	ClearGridArr(['gridLoc', GRIDID, 'gridInciIn', 'gridInciOut'])
}

function Add(){
	var locId = GetLocId();
	if(!locId){
		PHA.Msg('alert', '请选择一个科室！');
	    return;
	}
	var tt = $('#' + GRIDID).datagrid('getColumnOption', 'eachRela');
	tt.editor = GridCmbEachRela;

	
	
	PHA_GridEditor.Add({
		gridID   : GRIDID,
		field    : 'recLocId',
		checkRow : true,
		rowData  : {
				eachRela : 'Each'
			}
	});
	
	
}

function GetLocId(){
	var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.locId;
    return '';
}


function GetLrrId(){
	var gridSelect = $('#gridReqLoc').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.lrrId;
    return '';
}

function Save(){
	PHA_GridEditor.GridFinalDone('#' + GRIDID, ['lrrId', 'recLocId']);
	
	if (!PHA_GridEditor.EndCheck(GRIDID)) return;
    var gridChanges = PHA_GridEditor.GetChangedRows('#' + GRIDID);
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert', '没有需要保存的数据！');
	    return;
    }
    var locId = GetLocId();
	if(!locId){
		PHA.Msg('alert', '请选择一个科室！');
	    return;
	}
    
    var pJson = {
	    proLocId : locId,
	    rows  : gridChanges
    }
    
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'SaveLocReqRela',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryReqLoc();
			}
        }
    )
}

function Delete(){
	var gridSelect = $('#' + GRIDID).datagrid('getSelected');
    if (!gridSelect) {
	    PHA.Msg('alert' ,'请选择需要删除的记录！');
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var lrrId = gridSelect.lrrId || '';
            if (lrrId == '') {
                var rowIndex = $('#' + GRIDID).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            lrrId  : lrrId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeleteLocReqRela',
			            pJson   : JSON.stringify(pJson),
			        },
			        function (retData) {
				        if (PHA.Ret(retData)) {
							QueryReqLoc();
						}
			        }
			    )
            }
        }
    });
}



function statusFormatterDel(value, rowData, rowIndex) {
    var lrriId = rowData.lrriId;
    return (
        '<span class="icon icon-cancel"  onclick="DelInci(\'' +
        lrriId +
        '\')">&ensp;</span>'
    );
}

function statusFormatterAdd(value, rowData, rowIndex) {
    var inci = rowData.inci
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddInci(\'' +
        inci +
        '\')">&ensp;</span>'
    );
}

/// 添加药品
function AddInci(inci) {
	var lrrId = GetLrrId();
	if(!lrrId){
		PHA.Msg('alert' ,'请选择一条请领科室记录！');
        return;
	}
    var pJson = {
        lrrId  : lrrId,
        inci   : inci,
        hospId : PHA_COM.Session.HOSPID
    }
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'AddInci',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryInci();
			}
        }
    )
}

/// 删除药品
function DelInci(lrriId) {
	if(!lrriId){
		PHA.Msg('alert' ,'请选择需要删除的记录！');
        return;
	}
    $.messager.confirm('确认对话框', '确定删除吗？', function (r) {
        if (r) {
	        var pJson = {
		        lrriId : lrriId,
		        hospId : PHA_COM.Session.HOSPID
	        }
        	PHA.CM(
		        {
		            pClassName : APINAME,  
		            pMethodName: 'DelInci',
		            pJson   : JSON.stringify(pJson),
		        },
		        function (retData) {
			        if (PHA.Ret(retData)) {
						QueryInci();
					}
		        }
		    )
        }
    });
}

function ClearGridArr(gridArr){
	var len = gridArr.length
	for (var i=0;i<len;i++){
		var gridId = gridArr[i];
		$('#' + gridId).datagrid('loadData', []);
	}
		
}