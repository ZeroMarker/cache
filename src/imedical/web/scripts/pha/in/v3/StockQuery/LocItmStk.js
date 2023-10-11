/// 库存查询
/// Creator:yangsj
/// CreateDate:2021-02-20

var HosId   = session['LOGON.HOSPID'];
var userId  = session['LOGON.USERID'];
var groupId = session['LOGON.GROUPID'];
var locId   = session['LOGON.CTLOCID'];

var APPName="DHCSTLOCITMSTK"
var ParamProp = PHA_COM.ParamProp(APPName)
var cmbWidth  = 230;
var cmbiWidth = 120;
var arcActiveFlag = ParamProp.ArcActiveFlag == "Y" ? false : true 
var stkActiveFlag = ParamProp.StkActiveFlag == "Y" ? false : true 

$(function () {
    InitDict(); 			// 初始化条件字典
    InitGrid(); 			// 初始化grid
    InitBtn(); 				// 初始化按钮
    InitEvent(); 			// 初始化事件
    InitConditionFold();  	//条件折叠
    
});

//条件折叠
function InitConditionFold()
{
	var $lyBody = $('#lyBody');
	$('.pha-con-more-less').toggle();
    $('.pha-con-more-less-link').toggle();
	$lyBody.layout('panel', 'north').panel('resize', { height: 90 });
    $lyBody.layout('resize');
     $('.js-pha-con-toggle .panel-header, .pha-con-more-less').on('click', function (e) {
        $('.pha-con-more-less').toggle();
        $('.pha-con-more-less-link').toggle();
        var tHeight = $('.pha-con-more-less-link').css('display') === 'block' ? 175 : 95;
        $lyBody.layout('panel', 'north').panel('resize', { height: tHeight });
        $lyBody.layout('resize');
    });
}

function InitDict() {
	$('#StkDate').datebox('setValue', 't');
    //药房科室
    /*
    PHA.ComboBox('cmbPhaLoc', {
        width: cmbWidth,
        url: PHA_STORE.GetGroupDept().url,
        onChange:function (newVal,oldVal) {
	        InitScg();
	        InitIncItmGrid();
        }
    });
    $('#cmbPhaLoc').combobox('setValue', locId);
    */
    PHA_UX.ComboBox.Loc('cmbPhaLoc', {
	    width:cmbWidth,
	    onSelect:function(option){
	       var locId = option.RowId;
	       InitIncItmGrid(locId);
        }
	});
    
    //类组
    /*
    PHA.ComboBox('cmbStkGroup', {
        width: cmbWidth,
        onChange:function (newVal,oldVal) {
	        InitIncItmGrid();
	        if(!newVal) newVal=""
	        $('#cmbStkCat').combobox('clear');
        	$('#cmbStkCat').combobox('reload', PHA_STORE.INCStkCat().url + '&CatGrpId=' + newVal+ '&NeedScgFlag=' + "Y"  );
        },
        onLoadSuccess:function(){
	        SetDefaultStkGroup();
	        }
    });
    PHA.ComboBox('cmbStkCat', {
        width: cmbWidth,
        // url: PHA_STORE.INCStkCat().url
    });
    
    */
    
    PHA_UX.ComboBox.StkCatGrp('cmbStkGroup', {
		qParams: {
			width:cmbWidth,
			LocId: PHA_UX.Get('cmbPhaLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	PHA_UX.ComboBox.StkCat('cmbStkCat', {
        qParams: {
	        width:cmbWidth,
            CatGrpId: PHA_UX.Get('cmbStkGroup')
        }
    });
    PHA.ComboBox('cmbIfHaveStore', {
        panelHeight: 'auto',
        editable: false,
        width: cmbWidth,
        data: [
            {
                RowId: '0',
                Description: $g('全部'),
            },
            {
                RowId: '1',
                Description: $g('库存为零'),
            },
            {
                RowId: '2',
                Description: $g('库存为正'),
            },
            {
                RowId: '3',
                Description: $g('库存为负'),
            },
        ],
    });
    /*
    //药品名称lookup
    var opts = $.extend({}, PHA_STORE.INCItmForLoc('Y',locId,userId,""), {
        width: cmbWidth,
    });
    PHA.LookUp('cmbgridInci', opts);
    */

    //进口标志
    PHA.ComboBox('cmbImportFlag', {
        panelHeight: 'auto',
        width: cmbWidth,
        data: [
            {
                RowId: $g('国产'),
                Description: $g('国产'),
            },
            {
                RowId: $g('进口'),
                Description: $g('进口'),
            },
            {
                RowId: $g('合资'),
                Description: $g('合资'),
            },
        ],
    });
    //药学分类
    PHA.TriggerBox('genePHCCat', {
        width: cmbWidth,
        handler: function (data) {
            PHA_UX.DHCPHCCat('genePHCCat', {}, function (data) {
                $('#genePHCCat').triggerbox('setValue', data.phcCatDescAll);
                $('#genePHCCat').triggerbox('setValueId', data.phcCatId);
            });
        },
    });
    //医嘱子类
    PHA.ComboBox('cmbArcimItemCat', {
        width: cmbWidth,
        mode: 'remote',
        url: PHA_STORE.ARCItemCat().url,
    });
    // 管制分类
    PHA.ComboBox('cmbPoison', {
        width: cmbWidth,
        url: PHA_STORE.PHCPoison().url,
    });
    // 生产企业
    PHA.ComboBox('cmbManf', {
        width: cmbWidth,
        url: PHA_STORE.PHManufacturer().url,
    });
    // 剂型
    PHA.ComboBox('cmbForm', {
        width: cmbWidth,
        url: PHA_STORE.PHCForm().url,
    });
    // 医嘱项状态
    PHA.ComboBox('cmbArcStat', {
        panelHeight: 'auto',
        editable: false,
        width: cmbWidth,
        data: [
            {
                RowId: 0,
                Description: $g('全部'),
            },
            {
                RowId: 1,
                Description: $g('医嘱项截止'),
            },
            {
                RowId: 2,
                Description: $g('医嘱项在用'),
            },
        ],
    });
    // 可用状态
    PHA.ComboBox('cmbUseState', {
        panelHeight: 'auto',
        editable: false,
        width: cmbWidth,
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
        editable: false,
        width: cmbiWidth,
        data: [
            {
                RowId: 0,
                Description: $g('全部'),
            },
            {
                RowId: 1,
                Description: $g('有库存'),
            },
            {
                RowId: 2,
                Description: $g('无库存'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });
	$('#cmbIfHaveStorei').combobox('setValue',"1");
    //是否有库存
    PHA.ComboBox('cmbIncilbState', {
        panelHeight: 'auto',
        editable: false,
        width: cmbiWidth,
        data: [
            {
                RowId: 0,
                Description: $g('全部'),
            },
            {
                RowId: 1,
                Description: $g('可用'),
            },
            {
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
        editable: false,
        width: cmbiWidth,
        data: [
            {
                RowId: 0,
                Description: $g('全部'),
            },
            {
                RowId: 1,
                Description: $g('可用'),
            },
            {
                RowId: 2,
                Description: $g('不可用'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });
    
    
}

// 类组默认值
function SetDefaultStkGroup(){
	var loc = $('#cmbPhaLoc').combobox('getValue') || '';
	var defaultScg = tkMakeServerCall("PHA.STORE.Org","GetDefaultScg",loc,userId)
	$('#cmbStkGroup').combobox('setValue',defaultScg)
	// 用下面异步方式就报错，T_T
	/*
	$.cm({
            ClassName: 'PHA.STORE.Org',
            MethodName: 'GetDefaultScg',
            LocId: loc,
            UserId: userId,
        },
        function (retData) {
            if (retData=="") {
	            $('#cmbStkGroup').combobox('clear');
            } else {
                $('#cmbStkGroup').combobox('setValue',retData)
            }
        });
        */
}

// 类组受科室变化联动
function InitScg()
{
	var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
	$('#cmbStkGroup').combobox('reload', PHA_STORE.LocStkCatGroup().url + '&LocId='+Loc+'&UserId='+userId);
    //$('#cmbStkGroup').combobox('clear');  //如果这里使用clear。则不会触发#cmbStkGroup的onchange事件，也就不会触发库存分类的级联事件
    $('#cmbStkGroup').combobox('setValue',"");
    
}

// 药品查询框受科室和类组的限制 需要联动查询
function InitIncItmGrid(locId)
{
	//药品名称lookup
    var StkGroup = $('#cmbStkGroup').combobox('getValue') || '';
    var opts = $.extend({}, PHA_STORE.INCItmForLoc('Y',locId, userId, StkGroup), {
        width: cmbWidth,
    });
    PHA.LookUp('cmbgridInci', opts);
}

function InitGrid() {
    InitGridIncil();
    InitgridIncilb();
}

function InitGridIncil() {
    var columns = [
        [
            //Incil,Inci,InciCode,InciDesc,IncsbDesc,PurchCTUomDesc,BaseCTUomDesc,PurStockQty,StockQty,StkQtyUom,SalePrice,SpAmt,LastReailPrice,
            { field: 'IncsbDesc', title: '货位', align: 'left', width: 80 },
            { field: 'PurStockQty', title: '库存(包装单位)', align: 'right', width: 100 },
            { field: 'PUomDesc', title: '包装单位', align: 'center', width: 100 },
            { field: 'StockQty', title: '库存(基本单位)', align: 'right', width: 100 },
            { field: 'BUomDesc', title: '基本单位', align: 'center', width: 100 },
            { field: 'StkQtyUom', title: '库存(单位)', align: 'right', width: 100 },
            { field: 'DirtyQtyUom', title: '占用库存', align: 'right', width: 100 },
            { field: 'AvaQtyUom', title: '可用库存', align: 'right', width: 100 },
            //RpAmt,Spec,ManfDesc,OfficalCode,ManFlag,DirtyQtyUom,AvaQtyUom,ReservedQty,Gene,Form
            { field: 'ReservedQty', title: '在途数', align: 'right', width: 100 },
            { field: 'SalePrice', title: '零售价', align: 'right', width: 100 },
            { field: 'LastReailPrice', title: '最新进价', align: 'right', width: 100 },
            { field: 'SpAmt', title: '售价金额', align: 'right', width: 100 },
            { field: 'RpAmt', title: '进价金额', align: 'right', width: 100 },
            { field: 'Spec', title: '规格', align: 'left', width: 80 },
            { field: 'ManfDesc', title: '生产企业', align: 'left', width: 250 },
            { field: 'Gene', title: '处方通用名', align: 'left', width: 150 },
            { field: 'Form', title: '剂型', align: 'left', width: 80 },
            {
                field: 'ManFlag',
                title: '管理药',
                align: 'center',
                width: 60,
                formatter: function (value, row, index) {
                    if (value == '1') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return "";
                    }
                },
            },
            { field: 'InsuCode', title: '国家医保编码', align: 'left', width: 100 },
            { field: 'InsuDesc', title: '国家医保名称', align: 'left', width: 100 },
        ],
    ];
    var frozenColumns = [
        [
            { field: 'Incil', 	title: 'Incil', align: 'left', 		width: 100, hidden: true },
            { field: 'opre', 	title: '操作', 	align: 'center', 	width: 50 ,formatter:MianOpreFormatter},
            { field: 'InciCode', title: '代码', align: 'left',		sortable: true, width: 100 },
            { field: 'InciDesc', title: '名称', align: 'left',		sortable: true, width: 300 },
        ],
    ];

    var dataGridOption = {
	    gridSave:true,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridIncilBar',
        nowrap: false,
        idField: 'Incil',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'LocItmStk',
            HospId: '',
            ParamsJson: '',
        },
        onLoadSuccess: function (data) {},
        onSelect: function (rowIndex, rowData) {
            var Incil = rowData.Incil;
            queryInclb(Incil);
        },
    };
    //InitMainOperate(); 移动到操作按钮上，此方法屏蔽
    PHA.Grid('gridIncil', dataGridOption);
}

function InitgridIncilb() {
    var columns = [
        [
            //BatNo,Expire,ExpDate,BRp,PRp,Inclb,DirtyQtyUom,AvaQtyUom,PVenDesc,PManf,notuseflag,BSp,PSp,InclbResQtyUom,LockUser,LockDate,stknotuseflag
            { field: 'Inclb', title: 'Inclb', align: 'center', width: 100, hidden: true },
            { field: 'opre', title: '操作', align: 'center', width: 50 ,formatter:DetailOpreFormatter},
            {
                field: 'arcUseFlag',
                title: '医嘱可用',
                align: 'center',
                width: 100,
                formatter: ArcStatusFormatter,
                hidden: arcActiveFlag
            },
            {
                field: 'stkUseFlag',
                title: '库存可用',
                align: 'center',
                width: 100,
                formatter: StkStatusFormatter,
                hidden: stkActiveFlag
            },
            { field: 'BatNo', title: '批号', align: 'left', width: 100 },
            { field: 'ExpDate', title: '效期', align: 'left', width: 150 ,styler:StatuiStyler,},
            { field: 'QtyUom', title: '库存', align: 'right', width: 100 },
            { field: 'DirtyQtyUom', title: '占用', align: 'right', width: 100 },
            { field: 'AvaQtyUom', title: '可用', align: 'right', width: 100 },
            { field: 'InclbResQtyUom', title: '在途', align: 'right', width: 100 },
            { field: 'BRp', title: '进价(基本)', align: 'right', width: 100 },
            { field: 'PRp', title: '进价(包装)', align: 'right', width: 100 },
            { field: 'BSp', title: '售价(基本)', align: 'right', width: 100 },
            { field: 'PSp', title: '售价(包装)', align: 'right', width: 100 },
            { field: 'PVenDesc', title: '经营企业', align: 'left', width: 150 },
            { field: 'PManf', title: '生产企业', align: 'left', width: 150 },
            { field: 'LockUser', title: '更新人', align: 'left', width: 80 },
            { field: 'LockDate', title: '更新时间', align: 'left', width: 180 },
        ],
    ];
    var dataGridOption = {
	    toolbar: '#gridInclbBar',
        fit: true,
        gridSave:false,
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        nowrap: false,
        idField: 'Inclb',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'LocItmStkBatch',
            Incil: '',
            ParamsJson: '',
        },
        onLoadSuccess: function (data) {
            $('.hisui-switchboxarc').switchbox();
            $('.hisui-switchboxstk').switchbox();
        },
        onSelect: function (rowIndex, rowData) {
            /*var DULRowId = rowData.DULRowId;
            $('#gridCom').datagrid('query', {
                inputStr: DULRowId,
            });
            */
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'notuseflag',
                });
            }
        },
    };
    //InitDetailOperate(); 移动到操作按钮上，此方法屏蔽
    PHA.Grid('gridInclb', dataGridOption);
}

function StatuiStyler(value, row, index)
{
	var ExpStatus =row.ExpStatus
     switch (ExpStatus) {
         case 'WARN':
             colorStyle = 'background:#f1c516;color:white;';
             break;
         case 'OVERDUE':
             colorStyle = 'background:#ee4f38;color:white;';
             break;
         default:
             colorStyle = 'background:white;color:black;';
             break;
     }
     return colorStyle;
}


function MianOpreFormatter(value, rowData, rowIndex) {
	var Incil = rowData.Incil;
	var InciDesc = rowData.InciDesc;
	if ((Incil!="")&&(Incil!=undefined))
	return (
       "<a class=\"hisui-linkbutton\" data-options=\"iconCls:'icon-w-find'\" onclick=\"javascript:InitMainOperateNew(event,'"+Incil+"','"+InciDesc+"')\">操作</a>"
    ); 
    else  return ("");

}

function DetailOpreFormatter(value, rowData, rowIndex) {
	var Inclb = rowData.Inclb;
	if ((Inclb!="")&&(Inclb!=undefined))
	return (
       "<a class=\"hisui-linkbutton\" data-options=\"iconCls:'icon-w-find'\" onclick=\"javascript:InitDetailOperateNew(event,'"+Inclb+"')\">操作</a>"
    ); 

}

//自定医嘱项不可用列格式
function ArcStatusFormatter(value, rowData, rowIndex) {
    var Inclb = rowData.Inclb;
    var IndexString = JSON.stringify(rowIndex);
    var notUseflag = false;
    if (value == 'Y') notUseflag = true;
    return (
        "<div class=\"hisui-switchboxarc\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'是',offText:'否',checked:" +
        notUseflag +
        ",disabled:false,onSwitchChange:function(e, obj){UpdateArc(obj.value,'" +
        Inclb +
        "'," +
        IndexString +
        ",'" +
        value +
        '\')}"></div>'
    );
}

//自定医嘱项不可用列格式
function StkStatusFormatter(value, rowData, rowIndex) {
    var Inclb = rowData.Inclb;
    var IndexString = JSON.stringify(rowIndex);
    var notUseflag = false;
    if (value == 'Y') notUseflag = true;
    return (
        "<div class=\"hisui-switchboxarc\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'是',offText:'否',checked:" +
        notUseflag +
        ",disabled:false,onSwitchChange:function(e, obj){UpdateStk(obj.value,'" +
        Inclb +
        "'," +
        IndexString +
        ",'" +
        value +
        '\')}"></div>'
    );
}

function UpdateArc(objVal, Inclb, IndexString, value) {
    if (objVal) objVal = 'Y';
    else objVal = 'N';
    $.cm(
        {
            ClassName: 'PHA.IN.LocItmStk.Save',
            MethodName: 'UpdateArcState',
            Inclb: Inclb,
            ArcUseFlag: objVal,
            User: userId,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: '修改医嘱可用状态成功', type: 'success' });
                queryInclb();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: '修改医嘱可用状态失败！ 错误描述' + retData.desc,
                    type: 'alert',
                });
        }
    );
}

function UpdateStk(objVal, Inclb, IndexString, value) {
    if (objVal) objVal = 'Y';
    else objVal = 'N';
    $.cm(
        {
            ClassName: 'PHA.IN.LocItmStk.Save',
            MethodName: 'UpdateStkState',
            Inclb: Inclb,
            StkUseFlag: objVal,
            User: userId,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: '修改库存可用状态成功', type: 'success' });
                queryInclb();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: '修改库存可用状态失败！ 错误描述' + retData.desc,
                    type: 'alert',
                });
        }
    );
}

function InitBtn() {}
function InitEvent() {}

function queryIncil() {
	$('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    var ParamsJson = JSON.stringify(GetMainParamsJson());
    $('#gridIncil').datagrid('query', {
        HospId: HosId,
        ParamsJson: ParamsJson,
    });
}

function queryInclb(Incil) {
    if (!Incil) {
	    var gridSelect = $('#gridIncil').datagrid('getSelected') || '';
	    var Incil = '';
	    if (gridSelect) Incil = gridSelect.Incil;
    }
    if (!Incil) return;
    var ParamsJson = JSON.stringify(GetBatchParamsJson());
    $('#gridInclb').datagrid('query', {
        Incil: 			 Incil,
        ExpDateWarnDays: ParamProp.ExpDateWarnDays,
        ParamsJson: 	 ParamsJson,
    });
}

function clean() {
	$('#cmbPhaLoc').combobox('setValue', locId);
    $('#StkDate').datebox('setValue', 't');
    SetDefaultStkGroup();
    //$('#cmbStkGroup').combobox('clear');
    $('#cmbStkCat').combobox('clear');
    $('#cmbIfHaveStore').combobox('clear');
    $('#cmbgridInci').lookup('clear');
    $('#cmbImportFlag').combobox('clear');
    $('#genePHCCat').triggerbox('clear');
    $('#cmbArcimItemCat').combobox('clear');
    $('#cmbPoison').combobox('clear');
    $('#cmbManf').combobox('clear');
    $('#cmbForm').combobox('clear');
    $('#cmbArcStat').combobox('setValue',"0");
    $('#cmbUseState').combobox('clear');
    $('#chkManFlag').checkbox('setValue', false);
    $('#chkWithRes').checkbox('setValue', false);
    
    $('#cmbIfHaveStorei').combobox('setValue',"1");
    $('#cmbIncilbState').combobox('setValue',"0");
    $('#cmbIncilArcState').combobox('setValue',"0");
    
    $('#gridIncil').datagrid('clearSelections');
    $('#gridIncil').datagrid('clear');
    $('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    
}

function GetMainParamsJson() {
    return {
        PhaLoc: $('#cmbPhaLoc').combobox('getValue') || '',
        StkDate: $('#StkDate').datebox('getValue'),
        StkGroup: $('#cmbStkGroup').combobox('getValue') || '',
        StkCat: $('#cmbStkCat').combobox('getValue') || '',
        IfHaveStore: $('#cmbIfHaveStore').combobox('getValue') || '',
        Inci: $('#cmbgridInci').lookup('getValue') || '',
        ImportFlag: $('#cmbImportFlag').combobox('getValue') || '',
        genePHCCat: $('#genePHCCat').triggerbox('getValueId') || '',
        ArcimItemCat: $('#cmbArcimItemCat').combobox('getValue') || '',
        Poison: $('#cmbPoison').combobox('getValue') || '',
        Manf: $('#cmbManf').combobox('getValue') || '',
        Form: $('#cmbForm').combobox('getValue') || '',
        ArcStat: $('#cmbArcStat').combobox('getValue') || '',
        UseState: $('#cmbUseState').combobox('getValue') || '',
        ManFlag: $('#chkManFlag').is(':checked') ? 'Y' : 'N',
        WithRes: $('#chkWithRes').is(':checked') ? 'Y' : 'N',
    };
}

function GetBatchParamsJson() {
    return {
        StkDate: $('#StkDate').datebox('getValue') || '',
        IfHaveStorei: $('#cmbIfHaveStorei').combobox('getValue') || '',
        IncilbState: $('#cmbIncilbState').combobox('getValue') || '',
        IncilbArcState: $('#cmbIncilArcState').combobox('getValue') || '',
    };
}

function InitMainOperate() {
    var menuId = 'mainMenu';
    var gridId = 'gridIncil';
    var gParam = tkMakeServerCall('PHA.IN.LocItmStk.Query', 'GetParamProp', groupId, locId, userId);
    var gParamArr = gParam.split('^');
    var OperateArr = [
        'IntransInfo',
        'ClaerHospRes',
        'ClaerLocRes',
        'ClaerIncilRes',
        'LocStkSyn',
        'IncilStkSyn',
        'HospStkInfo',
        'ResInfo',
    ];
    var OperateArrDesc = [
        '台账信息查询',
        '全院在途数清除',
        '科室在途数清除',
        '科室单品在途数清除',
        '科室库存同步',
        '科室单品库存同步',
        '全院科室库存',
        '在途数查询',
    ];
    var OperateLen = OperateArr.length;
    var html =
        '<div id=' +
        menuId +
        ' class="hisui-menu" style=" display: none;">' +
        '<div id=' +
        menuId +
        '_export' +
        '>导出</div>';
    for (i = 0; i < OperateLen; i++) {
        if (gParamArr[i] == undefined || gParamArr[i] == 'Y') {
            var html = html + '<div id=' + OperateArr[i] + '>' + OperateArrDesc[i] + '</div>';
        }
    }
    html = html + '</div>';
    PHA.onRowContextMenu = function (e, rowIndex, rowData) {
        // 右键
        var incil = rowData.Incil || '';
        var InciDesc = rowData.InciDesc || '';
        if (incil == '') return;
        e.preventDefault(); //阻止向上冒泡
        if ($('#' + menuId).length > 0) {
            $('#' + menuId).remove();
        }
        $('body').append(html);
        $('#' + menuId).menu();
        $('#' + menuId).menu('show', {
            left: e.pageX,
            top: e.pageY,
        });
        $('#' + menuId + '_export').on('click', function () {
            PHA_COM.ExportGrid(gridId);
        });
        $('#IntransInfo').on('click', function () {
            IntransInfo(incil, InciDesc);
        });
        $('#ClaerHospRes').on('click', function () {
            ClaerHospRes();
        });
        $('#ClaerLocRes').on('click', function () {
            ClaerLocRes();
        });
        $('#ClaerIncilRes').on('click', function () {
            ClaerIncilRes(incil);
        });
        $('#LocStkSyn').on('click', function () {
            LocStkSyn();
        });
        $('#IncilStkSyn').on('click', function () {
            IncilStkSyn(incil);
        });
        $('#HospStkInfo').on('click', function () {
            HospStkInfo(incil, InciDesc);
        });
        $('#ResInfo').on('click', function () {
            ResInfo(incil, InciDesc);
        });
    };
}

function InitMainOperateNew(event,incil, InciDesc) {
    var menuId = 'mainMenu';
    var gridId = 'gridIncil';
    var gParam = tkMakeServerCall('PHA.IN.LocItmStk.Query', 'GetParamProp', groupId, locId, userId);
    var gParamArr = gParam.split('^');
    var OperateArr = [
        'IntransInfo',
        'ClaerHospRes',
        'ClaerLocRes',
        'ClaerIncilRes',
        'LocStkSyn',
        'IncilStkSyn',
        'HospStkInfo',
        'ResInfo',
    ];
    var OperateArrDesc = [
        '台账信息查询',
        '全院在途数清除',
        '科室在途数清除',
        '科室单品在途数清除',
        '科室库存同步',
        '科室单品库存同步',
        '全院科室库存',
        '在途数查询',
    ];
    var OperateLen = OperateArr.length;
    var html = '<div id=' +  menuId + ' class="hisui-menu" style=" display: none;">' ;
    for (i = 0; i < OperateLen; i++) {
        if (gParamArr[i] == undefined || gParamArr[i] == 'Y') {
            var html = html + '<div id=' + OperateArr[i] + '>' + OperateArrDesc[i] + '</div>';
        }
    }
    html = html + '</div>';
    if ($('#' + menuId).length > 0) {
        $('#' + menuId).remove();
    }
    $('body').append(html);
    $('#' + menuId).menu();
    $('#' + menuId).menu('show', {
        left: event.pageX,
        top: event.pageY,
    });
    $('#IntransInfo').on('click', function () {
        IntransInfo(incil, InciDesc);
    });
    $('#ClaerHospRes').on('click', function () {
        ClaerHospRes();
    });
    $('#ClaerLocRes').on('click', function () {
        ClaerLocRes();
    });
    $('#ClaerIncilRes').on('click', function () {
        ClaerIncilRes(incil);
    });
    $('#LocStkSyn').on('click', function () {
        LocStkSyn();
    });
    $('#IncilStkSyn').on('click', function () {
        IncilStkSyn(incil);
    });
    $('#HospStkInfo').on('click', function () {
        HospStkInfo(incil, InciDesc);
    });
    $('#ResInfo').on('click', function () {
        ResInfo(incil, InciDesc);
    });
  
}

function IntransInfo(incil, InciDesc) {
    $('#IntransInfoInciDesc').text('药品名称: ' + InciDesc);
    $('#IntransInfoIncil').text(incil);
    $('#IntransInfoStDate').datebox('setValue', 't');
    $('#IntransInfoEdDate').datebox('setValue', 't');
    $('#diagIntransInfo')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            { field: 'TrId', 		title: 'TrId', 			align: 'left', 	width: 100, hidden: true },
            { field: 'TrDate', 		title: '日期', 			align: 'left', 	width: 150 },
            { field: 'BatExp', 		title: '批号效期', 		align: 'left', 	width: 200 },
            { field: 'PurUom', 		title: '单位', 			align: 'center',width: 100 },
            { field: 'Sp', 			title: '售价', 			align: 'right', width: 100 },
            { field: 'Rp', 			title: '进价', 			align: 'right', width: 100 },
            { field: 'EndQtyUom', 	title: '结余数量', 		align: 'right', width: 100 },
            { field: 'TrQtyUom', 	title: '数量', 			align: 'right', width: 100 },
            { field: 'RpAmt', 		title: '进价金额', 		align: 'right', width: 100 },
            { field: 'SpAmt', 		title: '售价金额', 		align: 'right', width: 100 },
            { field: 'TrNo', 		title: '处理号', 		align: 'left', 	width: 200 },
            { field: 'TrAdm', 		title: '处理信息', 		align: 'left', 	width: 100 },
            { field: 'TrMsg', 		title: '业务类型', 		align: 'center',width: 100 },
            { field: 'EndRpAmt', 	title: '结余金额(进价)',align: 'right', width: 100 },
            { field: 'EndSpAmt', 	title: '结余金额(售价)',align: 'right', width: 100 },
            { field: 'Manf', 		title: '生产企业', 			align: 'left', 	width: 200 },
            { field: 'OperateUser', title: '操作人', 		align: 'left', 	width: 100 }
            
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'IntransInfo',
            INCIL: incil,
            StDate: $('#IntransInfoStDate').datebox('getValue'),
            EdDate: $('#IntransInfoEdDate').datebox('getValue'),
        },
        gridSave: false,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagIntransInfoBar',
    };
    PHA.Grid('gridIntransInfo', dataGridOption);
}
function queryIntransInfo() {
    $('#gridIntransInfo').datagrid('query', {
        INCIL: $('#IntransInfoIncil').text(),
        StDate: $('#IntransInfoStDate').datebox('getValue'),
        EdDate: $('#IntransInfoEdDate').datebox('getValue'),
    });
}

function ClaerHospRes() {
	PHA.Confirm('提示', '是否要清除全院在途数?', function () {
	    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'ClrResQtyHosp', HosId);
	    if (ret > 0) {
	        PHA.Popover({ showType: 'show', msg: '全院在途数清除成功', type: 'success' });
	    } else
	        PHA.Popover({
	            showType: 'show',
	            msg: '全院在途数清除失败！ 错误描述' + ret,
	            type: 'alert',
	        });
   });
}
function ClaerLocRes() {
	var locId = $('#cmbPhaLoc').combobox('getValue') || '';
	PHA.Confirm('提示', '是否要清除科室在途数?', function () {
	    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'ClrResQtyLoc', locId);
	    if (ret > 0) {
	        PHA.Popover({ showType: 'show', msg: '科室在途数清除成功', type: 'success' });
	        queryIncil();
	    } else
	        PHA.Popover({
	            showType: 'show',
	            msg: '科室在途数清除失败！ 错误描述' + ret,
	            type: 'alert',
	        });
	 });
}
function ClaerIncilRes(incil) {
	PHA.Confirm('提示', '是否要清除科室单品在途数?', function () {
	    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'ClrResQtyLocInci', incil);
	    if (ret > 0) {
	        PHA.Popover({ showType: 'show', msg: '科室单品在途数清除成功', type: 'success' });
	        queryIncil();
	    } else
	        PHA.Popover({
	            showType: 'show',
	            msg: '科室单品在途数清除失败！ 错误描述' + ret,
	            type: 'alert',
	        });
	});
}
function LocStkSyn() {
	var locId = $('#cmbPhaLoc').combobox('getValue') || '';
    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'SynIncilLoc', locId);
    if (ret > 0) {
        PHA.Popover({ showType: 'show', msg: '科室库存同步成功', type: 'success' });
        queryIncil();
    } else
        PHA.Popover({
            showType: 'show',
            msg: '科室库存同步成功失败！ 错误描述' + ret,
            type: 'alert',
        });
}
function IncilStkSyn(incil) {
    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'SynInciLocInci', incil);
    if (ret > 0) {
        PHA.Popover({ showType: 'show', msg: '科室单品库存同步成功', type: 'success' });
        queryIncil();
    } else
        PHA.Popover({
            showType: 'show',
            msg: '科室单品库存同步成功失败！ 错误描述' + ret,
            type: 'alert',
        });
}
function HospStkInfo(incil, InciDesc) {
    $('#HospStkInfoInciDesc').text('药品名称: ' + InciDesc);
    $('#diagHospStkInfo')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            { field: 'locDesc', title: '科室', align: 'left', width: 200 },
            { field: 'StockQtyUom', title: '库存', align: 'right', width: 220 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'HospStkInfo',
            INCIL: incil,
            Hosp: HosId,
        },
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagHospStkInfoBar',
    };
    PHA.Grid('gridHospStkInfo', dataGridOption);
}
function ResInfo(incil, InciDesc) {
    $('#ResInfoInciDesc').text('药品名称: ' + InciDesc);
    $('#diagResInfo')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            // INCIL,pointer,patNo,patName,orderDept,prescNo,resQty,uomDesc,oeDspDate,oeDspTime
            { field: 'gridDetailSelect', checkbox: true },
            { field: 'INCIL', title: 'INCIL', align: 'left', width: 200, hidden: true },
            { field: 'pointer', title: 'pointer', align: 'left', width: 220, hidden: true },
            { field: 'patNo', title: '登记号', align: 'left', width: 150 },
            { field: 'patName', title: '姓名', align: 'left', width: 100 },
            { field: 'orderDept', title: '医嘱科室', align: 'left', width: 150 },
            { field: 'prescNo', title: '处方号', align: 'left', width: 150 },
            { field: 'resQty', title: '剩余在途数', align: 'right', width: 100 },
            { field: 'uomDesc', title: '单位', align: 'center', width: 80 },
            { field: 'oeDspDate', title: '日期', align: 'left', width: 100 },
            { field: 'oeDspTime', title: '时间', align: 'left', width: 100 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'ResInfo',
            INCIL: incil,
            Hosp: HosId,
        },
        singleSelect: false,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagResInfoBar',
    };
    PHA.Grid('gridResInfo', dataGridOption);
}

function ClearRes() {
    var gridChecked = $('#gridResInfo').datagrid('getChecked');
    var CheckedLen = gridChecked.length;
    if (CheckedLen == 0) {
        PHA.Popover({ showType: 'show', msg: '请选中需要清除的在途明细', type: 'alert' });
        return;
    }
    var pointerStr = '',
        INCIL = '';
    for (var i = 0; i < CheckedLen; i++) {
        var pointer = gridChecked[i].pointer;
        INCIL = gridChecked[i].INCIL;
        pointerStr = pointerStr == '' ? pointer : pointerStr + '^' + pointer;
    }
    if (pointerStr == '') {
        PHA.Popover({ showType: 'show', msg: '无可删除的在途明细', type: 'alert' });
        return;
    }
    var ret = tkMakeServerCall('PHA.COM.Reserve', 'ClrReserveByPointerMulti', pointerStr);
    $('#gridResInfo').datagrid('query', {
        INCIL: INCIL,
        Hosp: HosId,
    });
}

function InitDetailOperate() {
    var menuId = 'detailMenu';
    var gridId = 'gridInclb';
    var OperateArr = ['BatchDirtyQty', 'BatchIntransInfo'];
    var OperateArrDesc = ['查看占用单据', '批次台账信息'];
    var OperateLen = OperateArr.length;
    var html =
        '<div id=' +
        menuId +
        ' class="hisui-menu" style=" display: none;">' +
        '<div id=' +
        menuId +
        '_export' +
        '>导出</div>';
    for (i = 0; i < OperateLen; i++) {
        var html = html + '<div id=' + OperateArr[i] + '>' + OperateArrDesc[i] + '</div>';
    }
    html = html + '</div>';
    PHA.onRowContextMenu = function (e, rowIndex, rowData) {
        // 右键
        var Inclb = rowData.Inclb || '';
        if (Inclb == '') return;
        e.preventDefault(); //阻止向上冒泡
        if ($('#' + menuId).length > 0) {
            $('#' + menuId).remove();
        }
        $('body').append(html);
        $('#' + menuId).menu();
        $('#' + menuId).menu('show', {
            left: e.pageX,
            top: e.pageY,
        });
         $('#' + menuId + '_export').on('click', function () {
            PHA_COM.ExportGrid(gridId);
        });
        
        $('#BatchDirtyQty').on('click', function () {
            BatchDirtyQty(Inclb);
        });
        $('#BatchIntransInfo').on('click', function () {
            BatchIntransInfo(Inclb);
        });
    };
}


function InitDetailOperateNew(event,Inclb) {
    var menuId = 'detailMenu';
    var gridId = 'gridInclb';
    var OperateArr = ['BatchDirtyQty', 'BatchIntransInfo'];
    var OperateArrDesc = ['查看占用单据', '批次台账信息'];
    var OperateLen = OperateArr.length;
    var html = '<div id=' + menuId + ' class="hisui-menu" style=" display: none;">' ;
    for (i = 0; i < OperateLen; i++) {
        var html = html + '<div id=' + OperateArr[i] + '>' + OperateArrDesc[i] + '</div>';
    }
    html = html + '</div>';
    if ($('#' + menuId).length > 0) {
        $('#' + menuId).remove();
    }
    $('body').append(html);
    $('#' + menuId).menu();
    $('#' + menuId).menu('show', {
        left: event.pageX,
        top: event.pageY,
    });    
    $('#BatchDirtyQty').on('click', function () {
        BatchDirtyQty(Inclb);
    });
    $('#BatchIntransInfo').on('click', function () {
        BatchIntransInfo(Inclb);
    });
}

function BatchDirtyQty(Inclb) {
    var InciDesc = '';
    var gridSelect = $('#gridIncil').datagrid('getSelected') || '';
    if (gridSelect) InciDesc = gridSelect.InciDesc;
    $('#BatchDirtyQtyInciDesc').text('药品名称: ' + InciDesc);
    $('#diagBatchDirtyQty')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            // rowid,trno,qty,uom,trdate
            { field: 'rowid', title: 'rowid', align: 'left', width: 200, hidden: true },
            {
                field: 'deleteBut',
                title: $g('删除'),
                align: 'center',
                width: 60,
                formatter: deleteFormatter,
            },
            { field: 'trno', title: '转移单号', align: 'left', width: 220 },
            { field: 'qty', title: '占用数量', align: 'left', width: 100 },
            { field: 'uom', title: '单位', align: 'left', width: 100 },
            { field: 'trdate', title: '单据日期', align: 'left', width: 150 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'BatchDirtyQty',
            INCLB: Inclb,
        },
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagBatchDirtyQtyBar',
    };
    PHA.Grid('gridBatchDirtyQty', dataGridOption);
}

function deleteFormatter(value, rowData, rowIndex) {
    var rowid = rowData.rowid;
    return (
        "<a href='#' onclick='DeleteIniti(\"" +
        rowid +
        "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>"
    );
}
function DeleteIniti(initi){
	PHA.Confirm('提示', '是否要删除该转移明细和占用数量?', function () {
        $.cm(
            {
                ClassName: 'web.DHCST.DHCINIsTrfItm',
                MethodName: 'Delete',
                initi: initi,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: '删除成功!', type: 'success' });
                    var gridSelect = $('#gridInclb').datagrid('getSelected') || '';
				    var Inclb = '';
				    if (gridSelect) Inclb = gridSelect.Inclb;
                    $('#gridBatchDirtyQty').datagrid('query', {
						INCLB: Inclb,
					});
                    queryInclb();
                } else{
	                if(retData=="-1"){
	                	PHA.Popover({ showType: 'show',  msg: $g("清除失败,出库单为完成状态!"),type: 'alert',});
					}else if(retData=="-2"){
						PHA.Popover({ showType: 'show',  msg: $g("清除失败,出库单为完成状态!"),type: 'alert',});
					}else if(retData=="-3"){
						PHA.Popover({ showType: 'show',  msg: $g("清除失败,出库单为完成状态!"),type: 'alert',});
					}else if(retData=="-4"){
						PHA.Popover({ showType: 'show',  msg: $g("清除失败,出库单为完成状态!"),type: 'alert',});
					}else{
						Msg.info("error", $g("清除失败,")+retData);
					}
                }
            }
        );
    });
}



function BatchIntransInfo(Inclb) {
    $('#BatchIntransInfoInclb').text(Inclb);
    $('#BatchIntransInfoStDate').datebox('setValue', 't');
    $('#BatchIntransInfoEdDate').datebox('setValue', 't');

    var InciDesc = '';
    var gridSelect = $('#gridIncil').datagrid('getSelected') || '';
    if (gridSelect) InciDesc = gridSelect.InciDesc;
    $('#BatchIntransInfoInciDesc').text('药品名称: ' + InciDesc);
    $('#diagBatchIntransInfo')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            // rowid,trno,qty,uom,trdate
            { field: 'TrId', 		title: 'TrId', 				align: 'left', 	width: 200, hidden: true },
            { field: 'TrDate', 		title: '日期', 				align: 'left', 	width: 180 },
            { field: 'TrMsg', 		title: '摘要', 				align: 'left', 	width: 100 },
            { field: 'TrQtyUom', 	title: '数量', 				align: 'right', width: 100 },
            { field: 'EndQtyUom', 	title: '结余数量', 			align: 'right', width: 100 },
            { field: 'PurUomRp', 	title: '进价', 				align: 'right', width: 100 },
            { field: 'PurUomSp', 	title: '售价', 				align: 'right', width: 100 },
            { field: 'TrQtyUom', 	title: '数量', 				align: 'right', width: 100 },
            { field: 'TrRpAmt', 	title: '进价金额', 			align: 'right', width: 100 },
            { field: 'TrSpAmt', 	title: '售价金额', 			align: 'right', width: 100 },
            { field: 'EndRpAmt', 	title: '结余进价金额', 		align: 'right', width: 100 },
            { field: 'EndSpAmt', 	title: '结余售价金额', 		align: 'left', 	width: 100 },
            { field: 'TrNo', 		title: '处理号', 			align: 'left', 	width: 150 },
            { field: 'TrAdm', 		title: '处理相关部门(人)', 	align: 'left', 	width: 150 },
            { field: 'OperateUser', title: '操作人', 			align: 'left', 	width: 150 },
            { field: 'TrMark', 		title: '备注', 				align: 'left', 	width: 150 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'BatchIntransInfo',
            INCLB: Inclb,
            StDate: $('#BatchIntransInfoStDate').datebox('getValue'),
            EdDate: $('#BatchIntransInfoEdDate').datebox('getValue'),
            HospId: HosId,
        },
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagBatchIntransInfoBar',
    };
    PHA.Grid('gridBatchIntransInfo', dataGridOption);
}

function queryBatchIntransInfo() {
    $('#gridBatchIntransInfo').datagrid('query', {
        INCIL: $('#BatchIntransInfoInclb').text(),
        StDate: $('#BatchIntransInfoStDate').datebox('getValue'),
        EdDate: $('#BatchIntransInfoEdDate').datebox('getValue'),
        HospId: HosId,
    });
}
