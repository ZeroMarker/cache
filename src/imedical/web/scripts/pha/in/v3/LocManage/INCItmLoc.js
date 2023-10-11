/*
 *Description:科室药品信息维护
 */
var HospId = session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var groupId = session['LOGON.GROUPID'];
var locId = session['LOGON.CTLOCID'];
var INCITM_RowId = "";
var INCIL = "";
var APPName = "DHCSTLOCITMSTK"
var ParamProp = PHA_COM.ParamProp(APPName)

$(function () {
    InitDict(); // 初始化条件字典
    InitGrid(); // 初始化grid
    InitConditionFold();    //条件折叠
    
    //药房科室
    PHA_UX.ComboBox.Loc('cmbPhaLoc', {
	    onChange: function (newVal, oldVal) {
            
            LoadStkBinAndMagGrp();
            cleanGrid();
        }
    });
    
    if (locktype === 'all') {
        $('#cmbLockStore').combobox('setValue', 'A');
        setTimeout(function () { queryIncil(); }, 500);
    }
	
});

//条件折叠
function InitConditionFold(){
    $('.pha-con-more-less').toggle();
    $('.pha-con-more-less-link').toggle();
	$('.js-pha-con-toggle .panel-header, .pha-con-more-less').on('click', function (e) {
        $('.pha-con-more-less').toggle();
        $('.pha-con-more-less-link').toggle();
        $('#lyBody').layout('resize');
        $('#gridIncil').datagrid('getPanel').panel('resize');
    });
}

function InitDict() {
	$('#startDate').datebox('setValue', 't');
    $('#endDate').datebox('setValue', 't');
    PHA_UX.ComboBox.Loc('phaLoc', {});

    //类组
    PHA_UX.ComboBox.StkCatGrp('cmbStkGroup', {
		qParams: {
			LocId: PHA_UX.Get('cmbPhaLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
		,
		onChange: function (newVal, oldVal) {
            InitIncItmGrid(newVal);
        }
	});
 
   PHA_UX.ComboBox.StkCatGrp('stkGroup', {
		qParams: {
			LocId: PHA_UX.Get('phaLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
	/* 库存分类 */
	PHA_UX.ComboBox.StkCat('cmbStkCat', {
        qParams: {
            CatGrpId: PHA_UX.Get('cmbStkGroup')
        }
    });
    
    PHA.ComboBox('cmbIfHaveStore', {
        panelHeight: 'auto',
        editable: false,
        data: [{
                RowId: '0',
                Description: $g('全部')
            }, {
                RowId: '1',
                Description: $g('库存为零')
            }, {
                RowId: '2',
                Description: $g('库存为正')
            }, {
                RowId: '3',
                Description: $g('库存为负')
            }
        ],
    });
    PHA.ComboBox('cmbLockStore', {
        panelHeight: 'auto',
        editable: false,
        data: [{
                RowId: 'A',
                Description: $g('门诊/住院')
            }, {
                RowId: 'O',
                Description: $g('门诊')
            }, {
                RowId: 'I',
                Description: $g('住院')
            }
        ],
    });

    //药品名称combogrid
    var opts = $.extend({width: '160'}, PHA_STORE.INCItmForLoc('Y',locId,"",""), {
    });
    PHA.ComboGrid('cmbgridInci', opts);
  
    //科室货位
    PHA_UX.ComboBox.StkBinComb('cmbStkBinStore', {
		qParams: {
			LocId: PHA_UX.Get('cmbPhaLoc', session['LOGON.CTLOCID']),
		}
	});
	
	
    // 科室盘点组
    PHA.ComboBox('cmbLocMagStore', {
        url: PHA_STORE.LocManGrp(locId).url,
    });
     // 可用状态
    PHA.ComboBox('cmbUseState', {
        panelHeight: 'auto',
        editable: false,
        data: [
            {
                RowId: 'ALL',
                Description: $g('全部'),
            },
            {
                RowId: 'USE',
                Description: $g('可用'),
            },
            {
                RowId: 'NOTUSE',
                Description: $g('不可用'),
            },
        ],
    });
    
    
    
    ///-----批次条件---------------
    //是否有库存
    PHA.ComboBox('cmbIfHaveStorei', {
        panelHeight: 'auto',
        width: 100,
        editable: false,
        data: [{
                RowId: 0,
                Description: $g('全部'),
            }, {
                RowId: 1,
                Description: $g('有库存'),
            }, {
                RowId: 2,
                Description: $g('无库存'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });
    $('#cmbIfHaveStorei').combobox('setValue', "1");
    //是否有库存
    PHA.ComboBox('cmbIncilbState', {
        panelHeight: 'auto',
        width: 100,
        editable: false,
        data: [{
                RowId: 0,
                Description: $g('全部'),
            }, {
                RowId: 1,
                Description: $g('可用'),
            }, {
                RowId: 2,
                Description: $g('不可用'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });

    PHA.ComboBox('cmbIncilArcState', {
        panelHeight: 'auto',
        width: 100,
        editable: false,
        data: [{
                RowId: 0,
                Description: $g('全部'),
            }, {
                RowId: 1,
                Description: $g('可用'),
            }, {
                RowId: 2,
                Description: $g('不可用'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });
    
    GridCmbUomFlag = PHA.EditGrid.ComboBox(
        {
            tipPosition: 'top',
            data : [{
                RowId: 'Y',
                Description: $g('是')
            },
            {
                RowId: 'N',
                Description: $g('否')
            },
            {
                RowId: '',
                Description: $g('默认')
            }]
        }
    );
    
    InitIncItmGrid();
}

// 货位和盘点组和科室联动
function LoadStkBinAndMagGrp() {
    var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    $('#cmbLocMagStore').combobox('reload', PHA_STORE.LocManGrp(Loc).url);
    $('#cmbLocMagStore').combobox('setValue', "");

}
// 药品查询框受科室和类组的限制 需要联动查询
function InitIncItmGrid(newScg) {
	newScg = newScg || '';
    var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    var StkGroup = newScg ? newScg : $('#cmbStkGroup').combobox('getValue') || '';
    var opts = $.extend({width: '160'}, PHA_STORE.INCItmForLoc('Y', Loc, userId, StkGroup), {});
    PHA.ComboGrid('cmbgridInci', opts);
    /* 库存分类 */
	PHA_UX.ComboBox.StkCat('cmbStkCat', {
        qParams: {
            CatGrpId: newScg
        }
    });
}

function InitGrid() {
    InitGridIncil();
    InitgridIncilb();
    InitgridDispUom();
    InitgridStkBin();
}

function InitGridIncil() {
	
	var inciLmgEditor = PHA.EditGrid.ComboBox({
    tipPosition: "top",
    url: PHA_STORE.LocManGrp("").url,
    onBeforeLoad: function (param) {
        param.Loc = $('#cmbPhaLoc').combobox('getValue');
    }
    });

    var columns = [
        [ {
                field: 'spec',
                title: '规格',
                align: 'left',
                width: 50
            }, {
                field: 'manf',
                title: '生产企业',
                align: 'left',
                width: 100
            }, {
                field: 'pUom',
                title: 'pUom',
                align: 'center',
                width: 100,
                hidden: true
            }, {
                field: 'pUomDesc',
                title: '包装单位',
                align: 'center',
                width: 80
            }, {
                field: 'bUom',
                title: 'bUom',
                align: 'center',
                width: 100,
                hidden: true
            }, {
                field: 'bUomDesc',
                title: '基本单位',
                align: 'center',
                width: 80
            },{
                field: 'sp',
                title: '包装价格(售价)',
                align: 'right',
                width: 100
            }, {
                field: 'maxQty',
                title: '<font color=blue>'+$g("库存上限")+'</font>',
                align: 'right',
                width: 100,
                editor: {
                    type: 'numberbox'
                }
            }, {
                field: 'minQty',
                title: '<font color=blue>'+$g("库存下限")+'</font>',
                align: 'right',
                width: 100,
                editor: {
                    type: 'numberbox'
                }
            }, {
                field: 'stkQty',
                title: '库存数',
                align: 'right',
                width: 100,
                sortable:true
            }, {
                field: 'avaQty',
                title: '可用库存',
                align: 'right',
                width: 100,
                sortable:true
            }, {
                field: 'repQty',
                title: '<font color=blue>'+$g("标准库存")+'</font>',
                align: 'right',
                width: 80,
                editor: {
                    type: 'numberbox'
                }
            }, {
                field: 'repLev',
                title: '<font color=blue>'+$g("补货标准")+'</font>',
                align: 'right',
                width: 80,
                editor: {
                    type: 'numberbox'
                }
            }, {
                field: 'incsb',
                title: 'incsb',
                align: 'left',
                width: 100,
                hidden: true
            }, {
                field: 'spStkBin',
                title: '备用货位',
                align: 'left',
                width: 150,
                hidden: true
            }, {
                field: 'phcpoCode',
                title: '管制分类',
                align: 'left',
                width: 100
            }, {
                field: 'inciLmg',
                title: '<font color=blue>'+$g("盘点组")+'</font>',
                align: 'left',
                width: 100,
                descField: "inciLmgDesc",
                editor: inciLmgEditor,
                formatter: function (value, row, index) {
                    return row.inciLmgDesc
                }
            }, {
                field: 'lockFlag',
                title: '<font color=blue>'+$g("门诊加锁")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'InLockFlag',
                title: '<font color=blue>'+$g("住院加锁")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'pivaflag',
                title: '<font color=blue>'+$g("配液打包标志")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'manFlag',
                title: '<font color=blue>'+$g("管理药标志")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: '1',
                        off: '0'
                    }
                },
                formatter: function (value, row, index) {
                    if (value == '1') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            }, {
                field: 'planFlag',
                title: '<font color=blue>'+$g("自动采购标志")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'pivaflag',
                title: '<font color=blue>'+$g("是否配液标志")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'drugsendflag',
                title: '<font color=blue>'+$g("发药机标志")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'drugpackflag',
                title: '<font color=blue>'+$g("分包机标志")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'NotUseFlag',
                title: '不可用',
                align: 'center',
                width: 80,
                formatter:Checkformatter,
                sortable:true
            },{
                field: 'inPhPack',
                title: '<font color=blue>'+$g("住院发整包装")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'outPhPack',
                title: '<font color=blue>'+$g("取药/出院带药可发基本单位")+'</font>',
                align: 'left',
                width: 180,
                descField: "outPhPackDesc",
                editor: GridCmbUomFlag,
                formatter: function (value, row, index) {
                    return row.outPhPackDesc
                }
            }, {
                field: 'lockUser',
                title: '加锁人',
                align: 'left',
                width: 80
            }, {
                field: 'lockDate',
                title: '加锁日期',
                align: 'left',
                width: 125
            }, {
                field: 'lockTime',
                title: '加锁时间',
                align: 'left',
                width: 100
            }
        ],
    ];
    
    var frozenColumns = [
        [
            {
                field: 'incil',
                title: 'incil',
                align: 'left',
                width: 50,
                hidden: true
            }, {
                field: 'inci',
                title: 'inci',
                align: 'left',
                width: 50,
                hidden: true
            }, {
                field: 'inciCode',
                title: '代码',
                align: 'left',
                sortable: true,
                width: 100,
                sortable:true
            }, {
                field: 'inciDesc',
                title: '名称',
                align: 'left',
                sortable: true,
                width: 150,
                sortable:true
            }
        ],
    ];

    var dataGridOption = {
        rownumbers: true,
        pagination: true,
        gridSave:true,
        toolbar: '#gridIncilBar',
        nowrap: true,
        idField: 'Incil',
        columns: columns,
        exportXls: true,
        frozenColumns: frozenColumns,
        striped: true,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.INCItmLoc.Query',
            QueryName: 'LocItm',
            HospId: HospId,
            params: '',
            sortName: '',
            sortOrder: ''
        },
        onLoadSuccess: function (data) {
            $('#gridInclb').datagrid('clearSelections');
            $('#gridInclb').datagrid('clear');
            $('#gridDispUom').datagrid('clearSelections');
            $('#gridDispUom').datagrid('clear');
            $('#gridStkBin').datagrid('clearSelections');
            $('#gridStkBin').datagrid('clear');
        },
        onDblClickRow: function (rowIndex, rowData) {
            $('#gridIncil').datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
        },
        onSelect: function (rowIndex, rowData) {
            INCIL = rowData.incil;
            INCITM_RowId = rowData.inci;
            queryInclb(INCIL);
            QueryItmSktBin(INCIL);
            QueryDispUom(INCITM_RowId)
        },
        onBeforeLoad:function(param){
	    	$(this).datagrid("clearSelections");
	    },
	    onSortColumn:function(sort, order){
			   
		}
    };
    PHA.Grid('gridIncil', dataGridOption);
}

function Checkformatter(value, row, index) {
    if (value == 'Y') {
        return PHA_COM.Fmt.Grid.Yes.Chinese;
    } else {
        return PHA_COM.Fmt.Grid.No.Chinese;
    }
}

//初始化批次表格
function InitgridIncilb() {
    var columns = [
        [{
                field: 'Inclb',
                title: 'Inclb',
                align: 'center',
                width: 100,
                hidden: true
            }, {
                field: 'arcUseFlag',
                title: '医嘱可用',
                align: 'center',
                width: 100,
                formatter: ArcStatusFormatter
            }, {
                field: 'stkUseFlag',
                title: '库存可用',
                align: 'center',
                width: 100,
                formatter: StkStatusFormatter
            }, {
                field: 'BatNo',
                title: '批号',
                align: 'left',
                width: 100
            }, {
                field: 'ExpDate',
                title: '效期',
                align: 'left',
                width: 150,
                styler: StatuiStyler,
            }, {
                field: 'QtyUom',
                title: '库存',
                align: 'right',
                width: 100
            }, {
                field: 'DirtyQtyUom',
                title: '占用',
                align: 'right',
                width: 100
            }, {
                field: 'AvaQtyUom',
                title: '可用',
                align: 'right',
                width: 100
            }, {
                field: 'InclbResQtyUom',
                title: '在途',
                align: 'right',
                width: 100
            }, {
                field: 'BRp',
                title: '进价(基本)',
                align: 'right',
                width: 100
            }, {
                field: 'PRp',
                title: '进价(包装)',
                align: 'right',
                width: 100
            }, {
                field: 'BSp',
                title: '售价(基本)',
                align: 'right',
                width: 100
            }, {
                field: 'PSp',
                title: '售价(包装)',
                align: 'right',
                width: 100
            }, {
                field: 'PVenDesc',
                title: '经营企业',
                align: 'left',
                width: 150
            }, {
                field: 'PManf',
                title: '生产企业',
                align: 'left',
                width: 150
            }, {
                field: 'LockUser',
                title: '更新人',
                align: 'left',
                width: 80
            }, {
                field: 'LockDate',
                title: '更新时间',
                align: 'left',
                width: 180
            },
        ],
    ];
    var dataGridOption = {
        toolbar: '#gridInclbBar',
        gridSave: false,
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        striped: true,
        nowrap: false,
        idField: 'Inclb',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'LocItmStkBatch',
            Incil: '',
            ParamsJson: '',
            ExpDateWarnDays: ''
        },
        onLoadSuccess: function (data) {
            $('.hisui-switchboxarc').switchbox();
            $('.hisui-switchboxstk').switchbox();
        },
        onSelect: function (rowIndex, rowData) {},
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'notuseflag',
                });
            }
        },
    };
    PHA.Grid('gridInclb', dataGridOption);
}

function StatuiStyler(value, row, index) {
    var ExpStatus = row.ExpStatus
        switch (ExpStatus) {
        case 'WARN':
            colorStyle = 'background:#FF6565;color:white;';
            break;
        case 'OVERDUE':
            colorStyle = 'background:gray;color:white;';
            break;
        default:
            colorStyle = 'background:white;color:black;';
            break;
        }
        return colorStyle;
}

//自定医嘱项不可用列格式
function ArcStatusFormatter(value, rowData, rowIndex) {
    var Inclb = rowData.Inclb;
    var IndexString = JSON.stringify(rowIndex);
    var notUseflag = false;
    if (value == 'Y')
        notUseflag = true;
    return (
        "<div class=\"hisui-switchboxarc\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'是',offText:'否',checked:" +
        notUseflag +
        ",disabled:false,onSwitchChange:function(e, obj){UpdateArc(obj.value,'" +
        Inclb +
        "'," +
        IndexString +
        ",'" +
        value +
        '\')}"></div>');
}
//自定医嘱项不可用列格式
function StkStatusFormatter(value, rowData, rowIndex) {
    var Inclb = rowData.Inclb;
    var IndexString = JSON.stringify(rowIndex);
    var notUseflag = false;
    if (value == 'Y')
        notUseflag = true;
    return (
        "<div class=\"hisui-switchboxarc\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'是',offText:'否',checked:" +
        notUseflag +
        ",disabled:false,onSwitchChange:function(e, obj){UpdateStk(obj.value,'" +
        Inclb +
        "'," +
        IndexString +
        ",'" +
        value +
        '\')}"></div>');
}
//修改医嘱可用状态
function UpdateArc(objVal, Inclb, IndexString, value) {
    if (objVal)
        objVal = 'Y';
    else
        objVal = 'N';
    $.cm({
        ClassName: 'PHA.IN.LocItmStk.Save',
        MethodName: 'UpdateArcState',
        Inclb: Inclb,
        ArcUseFlag: objVal,
        User: userId,
    },
        function (retData) {
        if (!retData) {
            PHA.Popover({
                showType: 'show',
                msg: '修改医嘱可用状态成功',
                type: 'success'
            });
            queryInclb();
        } else
            PHA.Popover({
                showType: 'show',
                msg: '修改医嘱可用状态失败！ 错误描述' + retData.desc,
                type: 'alert',
            });
    });
}
//修改库存可用状态
function UpdateStk(objVal, Inclb, IndexString, value) {
    if (objVal)
        objVal = 'Y';
    else
        objVal = 'N';
    $.cm({
        ClassName: 'PHA.IN.LocItmStk.Save',
        MethodName: 'UpdateStkState',
        Inclb: Inclb,
        StkUseFlag: objVal,
        User: userId,
    },
        function (retData) {
        if (!retData) {
            PHA.Popover({
                showType: 'show',
                msg: '修改库存可用状态成功',
                type: 'success'
            });
            queryInclb();
        } else
            PHA.Popover({
                showType: 'show',
                msg: '修改库存可用状态失败！ 错误描述' + retData.desc,
                type: 'alert',
            });
    });
}
//查询科室药品信息
function queryIncil() {
    $('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    var Params = GetMainParams();
    $('#gridIncil').datagrid('query', {
        HospId: HospId,
        params: Params
    });
}
//查询批次数据
function queryInclb(Incil) {
    if (!Incil) {
        var gridSelect = $('#gridIncil').datagrid('getSelected') || '';
        var Incil = '';
        if (gridSelect)
            Incil = gridSelect.incil;
    }
    if (!Incil)
        return;
    var ParamsJson = JSON.stringify(GetBatchParamsJson());
    $('#gridInclb').datagrid('query', {
        Incil: Incil,
        ExpDateWarnDays: ParamProp.ExpDateWarnDays,
        ParamsJson: ParamsJson,
    });
}

function cleanGrid(){
	$('#gridIncil').datagrid('clearSelections');
    $('#gridIncil').datagrid('clear');
    $('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    $('#gridDispUom').datagrid('clearSelections');
    $('#gridDispUom').datagrid('clear');
    $('#gridStkBin').datagrid('clearSelections');
    $('#gridStkBin').datagrid('clear');
}

//清空
function clean() {
    $('#cmbPhaLoc').combobox('setValue', locId);
    $('#cmbStkCat').combobox('clear');
    $('#cmbIfHaveStore').combobox('clear');
    $('#cmbgridInci').combogrid('clear');
    $('#cmbImportFlag').combobox('clear');
    $('#cmbLockStore').combobox('clear')
	$('#cmbStkBinStore').combobox('clear')
	$('#cmbLocMagStore').combobox('clear')
    $('#cmbUseState').combobox('clear');
    $('#cmbIfHaveStorei').combobox('setValue', "1");
    $('#cmbIncilbState').combobox('setValue', "0");
    $('#cmbIncilArcState').combobox('setValue', "0");

    $('#gridIncil').datagrid('clearSelections');
    $('#gridIncil').datagrid('clear');
    $('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    $('#gridDispUom').datagrid('clearSelections');
    $('#gridDispUom').datagrid('clear');
    $('#gridStkBin').datagrid('clearSelections');
    $('#gridStkBin').datagrid('clear');

}
//main查询条件
function GetMainParams() {
    var PhaLoc = $('#cmbPhaLoc').combobox('getValue') || '';
    var LockType = $('#cmbLockStore').combobox('getValue') || '';
    var StkGroup = $('#cmbStkGroup').combobox('getValue') || '';
    var StkCat = $('#cmbStkCat').combobox('getValue') || '';
    var IfHaveStore = $('#cmbIfHaveStore').combobox('getValue') || '';

    var Inci = $('#cmbgridInci').combogrid('getValue') || '';
    var StkBin = $('#cmbStkBinStore').combobox('getValue') || '';
    var LocMagGrp = $('#cmbLocMagStore').combobox('getValue') || '';
    var UseState = $('#cmbUseState').combobox('getValue') || '';

    var RetParams = PhaLoc + "^" + userId + "^" + groupId + "^" + LockType + "^" + StkGroup + "^" + StkCat;
    RetParams = RetParams  + "^" + IfHaveStore + "^" + Inci + "^" + StkBin + "^" + LocMagGrp + "^" + UseState;
    return RetParams
}
//批次查询条件
function GetBatchParamsJson() {
    return {
        StkDate: "",
        IfHaveStorei: $('#cmbIfHaveStorei').combobox('getValue') || '',
        IncilbState: $('#cmbIncilbState').combobox('getValue') || '',
        IncilbArcState: $('#cmbIncilArcState').combobox('getValue') || '',
    };
}
//发药单位维护
function InitgridDispUom() {
    var ilduLoc = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: "top",
        url: PHA_STORE.Pharmacy().url
    });
    var ilduUom = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: "top",
        url: PHA_STORE.Url + "ClassName=PHA.IN.DHCIncilDispUom.Query&QueryName=InciUOM",
        onBeforeLoad: function (param) {
            param.QText = param.q;
            param.InciId = INCITM_RowId; ;
        }
    });
    var columns = [
        [{
                field: "ilduId",
                title: 'ilduId',
                width: 50,
                hidden: true
            }, {
                field: "ilduLoc",
                title: '药房',
                width: 200,
                descField: "ilduLocDesc",
                editor: ilduLoc,
                hidden: true,
                formatter: function (value, row, index) {
                    return row.ilduLocDesc
                }
            }, {
                field: "ilduLocDesc",
                title: '药房描述',
                width: 200,
                align: "left",
                hidden: true
            }, {
                field: "ilduUom",
                title: '单位',
                width: 200,
                descField: "ilduUomDesc",
                editor: ilduUom,
                formatter: function (value, row, index) {
                    return row.ilduUomDesc
                }
            }, {
                field: "ilduActive",
                title: '启用',
                align: "center",
                width: 120,
                editor: {
                    type: 'icheckbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter: function (value, row, index) {
                    if (value == "Y") {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            }, {
                field: "ilduStDate",
                title: '开始日期',
                width: 220,
                align: "left",
                editor: {
                    type: "datebox"
                }
            }, {
                field: "ilduEdDate",
                title: '结束日期',
                width: 220,
                align: "left",
                editor: {
                    type: "datebox"
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DHCIncilDispUom.Query',
            QueryName: 'DHCIncilDispUom',
            InciId: INCITM_RowId
        },
        onBeforeLoad: function (param) {
            param.PhLoc = $('#cmbPhaLoc').combobox('getValue');
        },
        pagination: false,
        columns: columns,
        gridSave: false,
        fitColumns: true,
        autoRowHeight: true,
        toolbar: [{
                iconCls: 'icon-add',
                text: '新增',
                handler: function () {
                    var Row = $('#gridIncil').datagrid('getSelected');
                    if (Row === null) {
                        PHA.Popover({
                            showType: "show",
                            msg: "请选中要添加单位的药品列表！",
                            type: 'alert'
                        });
                        return;
                    }
                    INCITM_RowId = Row.inci
                    if (INCITM_RowId == "") {
                        PHA.Popover({
                            msg: '没有选中药品,如果正在新增,请先保存',
                            type: 'alert'
                        });
                        return;
                    }
                    var loc = $('#cmbPhaLoc').combobox('getValue')
                    $("#gridDispUom").datagrid('addNewRow', {
	                    editField: "ilduLoc",
	                    defaultRow: {
	                        ilduActive: "Y",
	                        ilduLoc: loc
	                    }
                	});
               }
            }, {
                iconCls: 'icon-save',
                text: '保存',
                handler: function () {
                    var $grid = $("#gridDispUom");
                    if ($grid.datagrid('endEditing') == false) {
                        PHA.Popover({
                            msg: "请先完成必填项",
                            type: 'alert'
                        });
                        return;
                    }
                    var gridChanges = $grid.datagrid('getChanges');
                    var gridChangeLen = gridChanges.length;
                    if (gridChangeLen == 0) {
                        PHA.Popover({
                            msg: "没有需要保存的数据",
                            type: 'alert'
                        });
                        return;
                    }
                    var inputStrArr = [];
                    for (var i = 0; i < gridChangeLen; i++) {
                        var iData = gridChanges[i];
                        if ($grid.datagrid('getRowIndex', iData) < 0) {
                            continue;
                        }
                        var params = (iData.ilduId || "") + "^" + (iData.ilduLoc || "") + "^" + (iData.ilduUom || "") + "^" + (iData.ilduActive || "") + "^" + (iData.ilduStDate || "") + "^" + (iData.ilduEdDate || "");
                        inputStrArr.push(params)
                    }
                    var inputStr = inputStrArr.join("!!");
                    var saveRet = $.cm({
                        ClassName: "PHA.IN.DHCIncilDispUom.Save",
                        MethodName: "SaveMulti",
                        InciId: INCITM_RowId,
                        MultiDataStr: inputStr,
                        dataType: "text"
                    }, false);
                    var saveArr = saveRet.split('^');
                    var saveVal = saveArr[0];
                    var saveInfo = saveArr[1];
                    if (saveVal < 0) {
                        PHA.Alert('提示', saveInfo, saveVal);
                    } else {
                        PHA.Popover({
                            msg: "保存成功",
                            type: 'success',
                            timeout: 1000
                        });
                        $grid.datagrid("reload");
                    }
                }
            }, {
                iconCls: 'icon-cancel',
                text: '删除',
                handler: function () {
                    var $grid = $("#gridDispUom");
                    var gridSelect = $grid.datagrid("getSelected") || "";
                    if (gridSelect == "") {
                        PHA.Popover({
                            msg: "请先选择需要删除的记录",
                            type: 'alert'
                        });
                        return;
                    }
                    PHA.Confirm("删除提示", "您确认删除吗?", function () {
                        var ilduId = gridSelect.ilduId || "";
                        var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
                        if (ilduId != "") {
                            var saveRet = $.cm({
                                ClassName: "PHA.IN.DHCIncilDispUom.Save",
                                MethodName: "Delete",
                                IlduId: ilduId,
                                dataType: "text"
                            }, false);
                            var saveArr = saveRet.split('^');
                            var saveVal = saveArr[0];
                            var saveInfo = saveArr[1];
                            if (saveVal < 0) {
                                PHA.Alert('提示', saveInfo, saveVal);
                                return;
                            } else {
                                PHA.Popover({
                                    msg: "删除成功",
                                    type: 'success',
                                    timeout: 1000
                                });
                            }
                        }
                        $grid.datagrid("deleteRow", rowIndex);
                    });
                }
            }
        ],
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid("endEditing");
        },
        onDblClickCell: function (rowIndex, field, value) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
        }
    };
    PHA.Grid("gridDispUom", dataGridOption);
}
//查询药品货位
function QueryDispUom(Inci) {
    if (!Inci) {
        return
    }
    var LocId = $('#cmbPhaLoc').combobox('getValue') || '';
    if (LocId == "") {
        PHA.Popover({
            msg: "请选择药房",
            type: 'error',
            timeout: 1000
        });
        return;
    }
    $('#gridDispUom').datagrid('query', {
        InciId: Inci,
        PhLoc: LocId
    });
}
//货位维护
function InitgridStkBin() 
{    
    var columns = [
        [ 
        	{
                field: 'incil',
                title: 'incil',
                align: 'center',
                width: 100,
                hidden: true
            },{
                field: 'sbiId',
                title: 'sbiId',
                align: 'center',
                width: 100,
                hidden: true
            },{
	            field: 'sbId',
                title: '货位',
                width: 200,
                descField: 'sbDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					loadRemote: true,
					
					url: PHA_IN_STORE.StkBinComb('').url,
					onBeforeLoad: function (param) {
						var locId = $("#cmbPhaLoc").combobox('getValue');
						param.LocId = locId || '' ;
					}
				}),
                formatter: function (value, row, index) {
                    return row.sbDesc;
                }
	        }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        toolbar: '#gridStkBinBar',
        singleSelect: false,
        gridSave:false,
        columns: columns,
        fitColumns: false,
        pagination: false,
        queryParams: {
            ClassName: "PHA.IN.INCItmLoc.Query",
            QueryName: "QuerySbByIncil",
            Incil: ''
        },
        rownumbers: true,
        onSelect: function (rowIndex, rowData) {},
        onClickRow: function (rowIndex, rowData){
	        if (!PHA_GridEditor.EndCheck('gridStkBin')) return;
        },
	    onDblClickRow: function (rowIndex, rowData) {
		    if (!PHA_GridEditor.EndCheck('gridStkBin')) return;
		    var sbiId = rowData.sbiId;
		    if(!sbiId){
				PHA_GridEditor.Edit({
					gridID : 'gridStkBin',
					index  : rowIndex,
					field  : 'sbId',
					forceEnd : true
				});
		    }
		}
    }
    PHA.Grid("gridStkBin", dataGridOption);
}

//查询药品货位
function QueryItmSktBin(incil) {
    if (!incil) return;
    $('#gridStkBin').datagrid('query', {
        incil: incil
    });
}
//货位维护工具栏操作
//增加
function AddStkBin() {
	var Row = $('#gridIncil').datagrid('getSelected');
    if (Row === null) {
        PHA.Popover({
            showType: "show",
            msg: "请选中要添加货位的药品列表！",
            type: 'alert'
        });
        return;
    }
    incil = Row.incil

    PHA_GridEditor.Add({
		gridID: 'gridStkBin',
		field: 'sbId',
		data:{
			incil : incil
		}
	});
}
//保存
function SaveStkBin() {
    if (INCIL == "") {
        return;
    }
    var $grid = $("#gridStkBin");
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: "请先完成必填项",
            type: 'alert'
        });
        return;
    }
    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: "没有需要保存的数据",
            type: 'alert'
        });
        return;
    }
    var pJson = {
	    locId : $("#cmbPhaLoc").combobox('getValue'),
	    incil : INCIL,
	    rows  : gridChanges
    }
    $cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "SaveIncilSb",
        jsonParams: JSON.stringify(pJson),
        dataType: "text"
    }, function (ret) {
        if (ret == "0") {
            PHA.Popover({
                msg: "保存成功！",
                type: 'success',
                timeout: 1000
            });
            $('#gridStkBin').datagrid('reload')
            //$('#gridIncil').datagrid('reload');
        } else {
            PHA.Alert("提示", ret.split("^")[1], "error")
        }
    })
}
//删除
function DelStkBin() {
    var Selected = $("#gridStkBin").datagrid('getSelected');
    if (!Selected) {
        PHA.Popover({
            msg: "请先选择要删除的数据！",
            type: 'error',
            timeout: 1000
        });
        return;
    }
    var sbiId = Selected.sbiId;
    if (!sbiId){
	 	var rowIndex = $('#gridStkBin').datagrid('getRowIndex', Selected);
        $('#gridStkBin').datagrid('deleteRow', rowIndex); 
        return;  
    }
    
    $cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "DeleteIncilSb",
        sbiId: sbiId,
        dataType: "text"
    }, function (ret) {
        if (ret == 0) {
            PHA.Popover({
                msg: "删除成功！",
                type: 'success',
                timeout: 1000
            });
            $('#gridStkBin').datagrid('reload');
            //$('#gridIncil').datagrid('reload');
        } else {
            PHA.Alert("提示", ret.split("^")[1], "error")
        }
    })
}

function SaveInci(){    
	$('#gridIncil').datagrid('endEditing');
    var rowData = $("#gridIncil").datagrid('getChanges');
    $cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "Save",
        jsonParams: JSON.stringify(rowData),
        dataType: "text"
    }, function (ret) {
        if (ret == "0") {
            PHA.Popover({
                msg: "保存成功！",
                type: 'success',
                timeout: 1000
            });
            $('#gridIncil').datagrid('reload')
        } else {
            PHA.Alert("提示", ret.split("^")[1], "error")
        }
    })

 }
//数据导入模板下载
function downloadFile(){
	var title={
		locDesc:"科室名称",
		inciCode:"药品代码",
		inciDesc:"药品名称",
		//stkBin:"货位名称",
		maxQty:"库存上限",
		minQty:"库存下限"
	}
	var data=[
		{locDesc:'住院药房', inciCode:"XWY000002",inciDesc:"磷酸钠盐灌肠液(辉力)[133ml]",maxQty:"1000",minQty:"500"},   //stkBin:"西安01",
		{locDesc:'住院药房', inciCode:"XWY000003",inciDesc:"盐酸丁卡因胶浆(利宁)[5G]",maxQty:"5000",minQty:"500"},      //stkBin:"西安02",
		
	]
	var fileName="科室药品信息导入模板.xlsx"
	PHA_COM.ExportFile(title, data, fileName);
}
function uploadData(){
	var options = {
		charset:"tf-8", //'gb2312'
		suffixReg:/^(.xls)|(.xlsx)$/	
	}
	PHA_COM.ImportFile(options,readData)
}
function readData(data){
	var Len = data.length;
	var RowDelim = String.fromCharCode(1);
	var DataStr = "";
	for(var i=0;i<Len;i++){
		var RowData = data[i];
		var LocDesc = RowData.科室名称 || "";
		var InciCode = RowData.药品代码 || "";
		if(InciCode == ""){
			continue;
		}
		var InciDesc = RowData.药品名称 || "";
        var StkBin = "";                         //RowData.货位名称 || "";
		var MaxQty = RowData.库存上限 || "";
		var MinQty = RowData.库存下限 || "";
		var Detail = LocDesc+"^"+InciCode+"^"+InciDesc+"^"+StkBin+"^"+MaxQty+"^"+MinQty;
		if(DataStr==""){
			DataStr = Detail
		}else{
			DataStr = DataStr + RowDelim + Detail
		}
	}
	if(DataStr == ""){
		PHA.Alert("提示","没有需要保存的数据","error");
		return ;
	}
	$cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "ImportData",
        params: DataStr,
        dataType: "text"
    }, function (ret) {
	    if (ret == "0") {
		    $('#gridIncil').datagrid('reload')
			PHA.Alert("提示","导入成功！","success")
	    }
    else {
            PHA.Alert("提示", ret.split("^")[1], "error")
        }   
    })	
}

function creatLimts(){
	$('#creatLimtsConWin').dialog('open');	
}

function saveDataBtn(){
	var startDate = $('#startDate').datebox('getValue'); 	//起始日期
	var endDate = $('#endDate').datebox('getValue');  	//结束日期
	var maxlimt = $("#maxlimts").val();                		//上限系数
	var minlimt=  $("#minlimts").val();   					//下限系数

	if((maxlimt=="")||(maxlimt==null)||(maxlimt<=0)){
		PHA.Alert('提示', $g("请填写正确上限系数!"));
		return false;
	}
	if((minlimt=="")||(minlimt==null)||(minlimt<=0)){
		PHA.Alert('提示', $g("请填写正确下限系数!"));
		return false;
	}
	
	if(minlimt>maxlimt){
		PHA.Alert('提示', $g("上限系数不能小于下限系数!"));
		return false;
	}
	
	if (startDate == undefined || startDate.length <= 0) {
		PHA.Alert('提示', $g("请选择开始日期!"));
		return;
	}
	if (endDate == undefined || endDate.length <= 0) {
		PHA.Alert('提示', $g("请选择截止日期!"));
		return;
	}
	var phaLoc=$("#phaLoc").combobox('getValue');
	if (phaLoc == "" ) {
		PHA.Alert('提示', $g("请选择药房科室!"));
		return;
	}
	var stkgrp=$("#stkGroup").combobox('getValue');
    if (stkgrp == "" ) {
		PHA.Alert('提示', $g("请选择类组!"));
		return;
	}
	//业务类型
	var TransType='';
	var PFlag=($("#PFlag").checkbox('getValue')==true?'P':'');
	var YFlag=($("#YFlag").checkbox('getValue')==true?'Y':'');
	var FFlag=($("#FFlag").checkbox('getValue')==true?'F':'');
	var HFlag=($("#HFlag").checkbox('getValue')==true?'H':'');
	var TFlag=($("#TFlag").checkbox('getValue')==true?'T':'');
	var KFlag=($("#KFlag").checkbox('getValue')==true?'K':'');
	if(PFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+PFlag;
		}else{
			TransType=PFlag;
		}
	}
	if(YFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+YFlag;
		}else{
			TransType=YFlag;
		}
	}
	if(FFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+FFlag;
		}else{
			TransType=FFlag;
		}
	}
	if(HFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+HFlag;
		}else{
			TransType=HFlag;
		}
	}
	if(TFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+TFlag;
		}else{
			TransType=TFlag;
		}
	}
	if(KFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+KFlag;
		}else{
			TransType=KFlag;
		}
	}
	if (TransType == null || TransType.length <= 0) {
		PHA.Alert('提示', $g("请选择业务类型!"));
		return;
	}
	var inputstr = phaLoc + "^" + startDate + "^" + endDate + "^" + maxlimt + "^" + minlimt;
	inputstr = inputstr + "^" + stkgrp + "^" + TransType;
	$cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "AutoSetloclimqty",
        inputstr: inputstr,
        dataType: "text"
    }, function (ret) {
	    if(ret == 0){
		    $('#creatLimtsConWin').dialog('close');
	   		$('#gridIncil').datagrid('reload')
    		PHA.Alert("提示", "生成成功！","success")
    		
	    }else{
			PHA.Alert("提示", ret.split("^")[1], "error")  
		}
    })
}
/**
 * 关闭会话窗
 */
function closeNewWin(){
	$('#creatLimtsConWin').dialog('close');
}

function UpdateInPhUomWin(){
	$('#updateInPhUomWin').dialog('open');	
	InitGridDispCat();
	InitDictForUomWin();
}

function InitGridDispCat(){
 	var columns = [
    	[
    		{ field: 'tSelect', checkbox: true },
	        { field: 'rowID',	title: '类别ID',	hidden: true	},
	        { field: 'code',	title: '代码',		align: "left",	width: 100	},
	        { field: 'desc',	title: '名称',		align: "left",	width: 100	},
       	]
    ];
        var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IP.DispCat.Query',
            QueryName: 'DispCat',
            pJsonStr: JSON.stringify({ hosp: session['LOGON.HOSPID'] }),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: null,
        enableDnd: false,
        fitColumns: false,
        exportXls: false,
        singleSelect: false,
        gridSave:false
    };
    PHA.Grid('gridDispCat', dataGridOption);
}

function InitDictForUomWin(){
	
	PHA.ComboBox('uomComfigVal', {
		        data: []
		    }); 
	PHA.ComboBox('uomComfigDesc', {
		hight:'auto',
        data: [
            { RowId: 'inPhPack', 	Description:  $g('住院发整包装') },
            { RowId: 'outPhPack',	Description:  $g('取药/出院带药可发基本单位')  }
        ],
        onSelect: function (newVal, oldVal) {   
			var newId = newVal.RowId;
			var data = [
	            { RowId: 'Y', 	Description:  $g('是')  },
	            { RowId: 'N',	Description:  $g('否')  }
	        ] 
			if(newId == 'outPhPack'){
				data.push({ RowId: '', 	Description:  $g('默认')  })
			}
			PHA.ComboBox('uomComfigVal', {
		        data: data
		    }); 
　　  	}  
    });
}

function GetSelectDispCat(){
	var itmArr = [];
	var rows = $('#gridDispCat').datagrid('getChecked');
    if (rows.length === 0) return itmArr;
    for (var i=0; i < rows.length; i++) {
        var id = rows[i].rowID || '';
        if (id) itmArr.push(id);
    }
	return itmArr;
}

function UpdateInPhUom(){
	var dispCatArr = GetSelectDispCat();
	if(dispCatArr.length == 0){
		PHA.Msg('alert', '请选择发药类别');
		return;
	}
	var uomComfigDesc = $('#uomComfigDesc').combobox('getValue') || '';
	if(!uomComfigDesc){
		PHA.Msg('alert', '请选择配置描述');
		return;
	}
	var uomComfigVal = $('#uomComfigVal').combobox('getValue') || '';
	if((uomComfigDesc == 'inPhPack') && (!uomComfigVal)){
		PHA.Msg('alert', '请选择配置值');
		return;
	}
	var locId = $('#cmbPhaLoc').combobox('getValue') || '';
	var pJson = {
		dispCatArr 		: dispCatArr,
		locId 			: locId,
		uomComfigDesc 	: uomComfigDesc,
		uomComfigVal 	: uomComfigVal
	}
	pJson = JSON.stringify(pJson);
	
	$cm({
	        ClassName: "PHA.IN.INCItmLoc.Save",
	        MethodName: "UpdateIncilUomByDispCat",
	        pJson: pJson,
	        dataType: "text"
	    }, function (ret) {
		    if(ret == 0){
	    		PHA.Alert("提示", "保存成功！","success")
		    }else{
				PHA.Alert("提示", ret.split("^")[1], "error")  
		}
    });
	
}

function CloseInPhUom(){
	$('#updateInPhUomWin').dialog('close');	
}