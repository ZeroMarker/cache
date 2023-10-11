/// 库存查询
/// Creator:yangsj
/// CreateDate:2021-02-20

var HosId   = session['LOGON.HOSPID'];
var userId  = session['LOGON.USERID'];
var groupId = session['LOGON.GROUPID'];
var locId   = session['LOGON.CTLOCID'];

var cmbWidth = 230;
var cmbiWidth = 120;

$(function () {
    InitDict(); 			// 初始化条件字典
    InitGrid(); 			// 初始化grid
    InitBtn(); 				// 初始化按钮
    InitEvent(); 			// 初始化事件
    InitConditionFold();	// 条件折叠
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
	$('#StartDate').datebox('setValue', 't');
	$('#EndDate').datebox('setValue', 't');
    //药房科室
    PHA.ComboBox('cmbPhaLoc', {
        width: cmbWidth,
        url: PHA_STORE.GetGroupDept().url,
        onChange:function (newVal,oldVal) {
	        InitScg();
	        InitIncItmGrid();
        }
    });
    $('#cmbPhaLoc').combobox('setValue', locId);
    //类组
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
    PHA.ComboBox('cmbIfUse', {
        panelHeight: 'auto',
        editable: false,
        width: cmbWidth,
        data: [
            {
                RowId: 'ALL',
                Description: $g('全部'),
            },
            {
                RowId: 'ZEROUSE',
                Description: $g('零消耗'),
            },
            {
                RowId: 'NOTZERO',
                Description: $g('非零消耗'),
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
    // 管制分类
    PHA.ComboBox('cmbPoison', {
        width: cmbWidth,
        url: PHA_STORE.PHCPoison().url,
    });
    // 业务类型
    PHA.ComboBox('cmbBusinessType', {
        width: cmbWidth,
        multiple: 'multiple',
        url: PHA_STORE.BusinessType().url,
    });

    InitIncItmGrid();
}

// 类组默认值
function SetDefaultStkGroup(){
	var loc = $('#cmbPhaLoc').combobox('getValue') || '';
	var defaultScg = tkMakeServerCall("PHA.STORE.Org","GetDefaultScg",loc,userId)
	$('#cmbStkGroup').combobox('setValue',defaultScg)
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
function InitIncItmGrid()
{
	//药品名称lookup
	var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    var StkGroup = $('#cmbStkGroup').combobox('getValue') || '';
    var opts = $.extend({}, PHA_STORE.INCItmForLoc('Y',Loc,userId,StkGroup), {
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
            //INCIL,InciCode,InciDesc,StkCatDesc,PurUomDesc,BUomDesc,BegQty,BegQtyUom,BegRpAmt,BegSpAmt,EndQty,EndQtyUom,EndRpAmt,EndSpAmt,PlusQty,MinusQty
            { field: 'PlusQty', 	title: '增加数量', 			align: 'right', sortable: true,	width: 100 ,styler:QtyStyler},
            { field: 'MinusQty', 	title: '减少数量', 			align: 'right',sortable: true, 	width: 100 ,styler:QtyStyler},
            { field: 'BUom', 		title: '基本单位', 			align: 'center',width: 80 },
            { field: 'BegQtyUom', 	title: '期初库存', 			align: 'right', width: 120 },
            { field: 'BegRpAmt', 	title: '期初金额(进价)', 	align: 'right', width: 150 },
            { field: 'BegSpAmt', 	title: '期初金额(售价)', 	align: 'right', width: 150 },
            { field: 'EndQtyUom', 	title: '期末库存', 			align: 'right', width: 120 },
            { field: 'EndRpAmt', 	title: '期末金额(进价)', 	align: 'right', width: 150 },
            { field: 'EndSpAmt', 	title: '期末金额(售价)', 	align: 'right', width: 150 },
            { field: 'StkCatDesc', 	title: '库存分类', 			align: 'right', width: 150 },
           
        ],
    ];
    var frozenColumns = [
        [
            { field: 'INCIL',	 title: 'INCIL', align: 'left', width: 100, hidden: true },
            { field: 'InciCode', title: '代码', align: 'left',sortable: true, width: 100 },
            { field: 'InciDesc', title: '名称', align: 'left',sortable: true, width: 300 },
        ],
    ];

    var dataGridOption = {
        fit: true,
        gridSave: false,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridIncilBar',
        nowrap: false,
        idField: 'INCIL',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStkMove.Query',
            QueryName: 'LocItmStkMove',
            HospId: '',
            ParamsJson: '',
        },
        onLoadSuccess: function (data) {},
        onSelect: function (rowIndex, rowData) {
            queryMoveDetail();
        },
    };
    //InitMainOperate(); 移动到操作按钮上，此方法屏蔽
    PHA.Grid('gridIncil', dataGridOption);
}

function InitgridIncilb() {
    var columns = [
        [
            //"TrId","TrDate", "BatExp", "PurUom", "Sp","Rp","EndQty","EndQtyUom","TrQty", "TrQtyUom", "RpAmt", "SpAmt","TrNo","TrAdm","TrMsg","EndRpAmt", "EndSpAmt", "Vendor", "Manf","OperateUser","TypeFlag"
            { field: 'TrId', 		title: 'TrId', 				align: 'center', 	width: 100, hidden: true },
            { field: 'opre', 		title: '操作', 				align: 'center', 	width: 50 ,formatter:DetailOpreFormatter},
            { field: 'TrDate', 		title: '日期时间', 			align: 'center', 	width: 160 },
            { field: 'BatExp', 		title: '批号效期', 			align: 'right', 	width: 200 },
            { field: 'PurUom', 		title: '单位', 				align: 'center', 	width: 80 },
            { field: 'Sp', 			title: '售价', 				align: 'right', 	width: 100 },
            { field: 'Rp', 			title: '进价', 				align: 'right', 	width: 100 },
            { field: 'EndQtyUom', 	title: '结余数量', 			align: 'right', 	width: 100 },
            { field: 'TrQtyUom', 	title: '数量', 				align: 'right', 	width: 100 ,styler:QtyStyler},
            { field: 'RpAmt', 		title: '进价金额', 			align: 'right', 	width: 100 },
            { field: 'SpAmt', 		title: '售价金额', 			align: 'right', 	width: 100 },
            { field: 'TrNo', 		title: '处理号', 			align: 'left', 		width: 200 },
            { field: 'TrAdm', 		title: '处理信息', 			align: 'left', 		width: 100 },
            { field: 'TrMsg', 		title: '业务类型', 			align: 'left', 		width: 150 },
            { field: 'EndRpAmt', 	title: '结余金额(进价)', 	align: 'right',		width: 150 },
            { field: 'EndSpAmt', 	title: '结余金额(售价)', 	align: 'right',		width: 80 },
            { field: 'Vendor', 		title: '经营企业', 			align: 'left', 		width: 180 },
            { field: 'Manf', 		title: '生产企业', 			align: 'left', 		width: 180 },
            { field: 'OperateUser', title: '操作人', 			align: 'left', 		width: 180 },
            { field: 'TypeFlag', 	title: 'TypeFlag', 			align: 'left', 		width: 180, hidden:true},
        ],
    ];
    var dataGridOption = {
	    toolbar: '#gridMoveDetailBar',
        fit: true,
        gridSave: false,
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
            ClassName: 'PHA.IN.LocItmStkMove.Query',
            QueryName: 'LocItmStkMoveDetail',
            Incil: '',
            ParamsJson: '',
        },
        onLoadSuccess: function (data) {
        },
        onSelect: function (rowIndex, rowData) {
        },
        onDblClickRow: function (rowIndex, rowData) {
        },
    };
    PHA.Grid('gridMoveDetail', dataGridOption);
}

function QtyStyler(value, row, index)
{
     value=parseFloat(value)
	 if(value>0) return 'background:#51b80c;color:white;';
	 if(value<0) return 'background:#ee4f38;color:white;';
}


function DetailOpreFormatter(value, rowData, rowIndex) {
	var TrId = rowData.TrId;
	if ((TrId!="")&&(TrId!=undefined)&&(TrId!="QS"))
	return (
       "<a class=\"hisui-linkbutton\" data-options=\"iconCls:'icon-w-find'\" onclick=\"javascript:InitMoveInfoDetail(event,'"+TrId+"')\">操作</a>"
    ); 

}


function InitBtn() {}
function InitEvent() {}

function queryIncil() {
	$('#gridMoveDetail').datagrid('clearSelections');
    $('#gridMoveDetail').datagrid('clear');
    var ParamsJson = JSON.stringify(GetMainParamsJson());
    $('#gridIncil').datagrid('query', {
        HospId: HosId,
        ParamsJson: ParamsJson,
    });
}

function queryMoveDetail() {
	
    var gridSelect = $('#gridIncil').datagrid('getSelected') || '';
    var INCIL = '';
    if (gridSelect) INCIL = gridSelect.INCIL;
    if (!INCIL) return;
    var ParamsJson = JSON.stringify(GetDetailParamsJson());
    $('#gridMoveDetail').datagrid('query', {
	    INCIL:INCIL,
        HospId: HosId,
        ParamsJson: ParamsJson,
    });
}

function clean() {
	$('#cmbPhaLoc').combobox('setValue', locId);
    $('#StkDate').datebox('setValue', 't');
    SetDefaultStkGroup();
    $('#cmbStkCat').combobox('clear');
    $('#cmbPoison').combobox('clear');
    $('#cmbgridInci').lookup('clear');
    $('#cmbIfUse').combobox('clear');
    $('#genePHCCat').triggerbox('clear');
   	$('#cmbIfUse').combobox('clear');
    $('#chkManFlag').checkbox('setValue', false);
    $('#cmbBusinessType').checkbox('setValue', false);
    
    $('#gridIncil').datagrid('clearSelections');
    $('#gridIncil').datagrid('clear');
    $('#gridMoveDetail').datagrid('clearSelections');
    $('#gridMoveDetail').datagrid('clear');
    
}

function GetMainParamsJson() {
    return {
        PhaLoc		: $('#cmbPhaLoc').combobox('getValue') || '',
        StartDate	: $('#StartDate').datebox('getValue')|| '',
        EndDate		: $('#EndDate').datebox('getValue')|| '',
        StkGroup	: $('#cmbStkGroup').combobox('getValue') || '',
        StkCat		: $('#cmbStkCat').combobox('getValue') || '',
        Poison		: $('#cmbPoison').combobox('getValue') || '',
        Inci		: $('#cmbgridInci').lookup('getValue') || '',
        IfUse		: $('#cmbIfUse').combobox('getValue') || '',
        genePHCCat	: $('#genePHCCat').triggerbox('getValueId') || '',
        ManFlag		: $('#chkManFlag').is(':checked') ? 'Y' : 'N',
    };
}

function GetDetailParamsJson() {
    return {
        StartDate	: $('#StartDate').datebox('getValue')|| '',
        EndDate		: $('#EndDate').datebox('getValue')|| '',
        BusinessType: $('#cmbBusinessType').combobox('getValues').toString() || '',
        ShowRetAsp	: $('#chkShowRetAsp').is(':checked') ? 'Y' : 'N',
    };
}

function InitMoveInfoDetail(event,TrId) {
    var menuId = 'DetailMenu';
    var gridId = 'gridMoveDetail';
    var OperateArr = [
        'MoveDetailInfo',
    ];
    var OperateArrDesc = [
        '业务明细查询',
    ];
    var OperateLen = OperateArr.length;
    var html = '<div id=' +  menuId + ' class="hisui-menu" style=" display: none;">' ;
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
    $('#MoveDetailInfo').on('click', function () {
        MoveDetailInfo(TrId);
    });
 
}

function MoveDetailInfo(TrId) {
    $('#IntransInfoInciDesc').text('药品名称: ' );
    $('#diagBusinessDetail')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    // 主信息列表
    var columnsMain = [
        [
        	// propertyName,propertyVal
            { field: 'propertyName', 	title: '属性', 		align: 'left', width: 150 },
            { field: 'propertyVal', 	title: '属性值', 	align: 'left', width: 200 },
        ],
    ];
    var dataGridMainOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStkMove.Query',
            QueryName: 'BusinessMainInfo',
            TrId: TrId,
        },
        pagination: false,
        gridSave: false,
        columns: columnsMain,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
    };
    PHA.Grid('gridBusinessMainInfo', dataGridMainOption);
    var col=[];
    var coli=[];
    var JsonStr=tkMakeServerCall("PHA.IN.LocItmStkMove.Query","Costomcolumns",TrId)
	var prtJson=JSON.parse(JsonStr);
	var data=prtJson.data
	for (i=0;i<data.length;i++)
	{
		var h=i+1
		var field="Field"+h
		var DetailList=data[i]
		var datai={field:field, title:DetailList.title, align:DetailList.align, width:DetailList.width}
		coli[i]=datai
		
	}
	col[0]=coli;
	
    
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStkMove.Query',
            QueryName: 'BusinessDetail',
            TrId: TrId,
        },
        gridSave: false,
        pagination: true,
        columns: col,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
    };
    PHA.Grid('gridBusinessDetail', dataGridOption);
}
