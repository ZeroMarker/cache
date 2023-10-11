//scripts/pha/in/v3/DrugLimit/DrugLimit.js
/**
 * @模块:     限制用药
 * @编写日期: 2020-05-21
 * @编写人:   yangsj
 */

var HosId = session['LOGON.HOSPID'];
var UserId = session['LOGON.USERID'];
var ComBoxWidth = 260;
var lookUpWidth = 465;
$(function () {
    InitDictBegin(); // 初始化不会发生变化的元素
    InitDict(); // 初始化会联动的元素
    InitGrid(); // 初始化GIridescent
    //InitSplitCom();  // 拆分列表初始化
    InitCom(); // 组合列表初始化
    InitEvent(); // 绑定事件
});

function InitGrid() {
    InitgridPhcGe(); // 通用名列表
    InitgridArc(); // 医嘱项列表
    InitgridDrugProp(); // 药品属性列表
}

//不受医院下拉框影响的控件在此初始化
function InitDictBegin() {
    PHA.ComboBox('cmbHos', {
        url: PHA_STORE.CTHosNew().url,
        width: 313,
    });

    setTimeout('SetDefaultHos()', 100);
    
    // 借用处方预览的方式初始化 限制组合数据预览panel
    DEC_PRESC.Layout('comblist', { width: (window.screen.width-1000)/3.67, divId: 'tmpComPanel', title: $g('限制组合数据预览'), contentType: 'div' }); //限制组合数据预览panel
    $('.layout-button-left').trigger('click'); //默认折叠状态
}
function SetDefaultHos() {
    $('#cmbHos').combobox('setValue', HosId);

    ///这俩控件如果不延迟绑定事件的话，会被其他事件覆盖，只能延迟执行，并且要把原绑定事件都复制过来。不然绑定事件只能取一个
    $('#PHCGeneric').lookup({
        onSelect: function (rowIndex, rowData) {
            $('#gridPhcGe').datagrid('clearSelections');
            var idField = $('#PHCGeneric').lookup('options').idField;
            $('#PHCGeneric').lookup('setValue', rowData[idField]);
            $('#PHCDFUom').val("")
            queryList();
        },
    });
    $('#inciArcim').lookup({
        onSelect: function (rowIndex, rowData) {
            $('#gridArc').datagrid('clearSelections');
            var idField = $('#inciArcim').lookup('options').idField;
            $('#inciArcim').lookup('setValue', rowData[idField]);
            var PhcdUom=tkMakeServerCall("PHA.IN.DrugUseLimit.Query","GetPhcdUomByArc",rowData[idField])
            $('#PHCDFUom').val(PhcdUom)
            queryList();
        },
    });
}

function InitEvent() {
    // 当医院重新选择后，相关下拉框要重新初始化。重新初始化的方式是修改PHA_COM.Session.HOSPID的值为选中医院下拉框的值
    $('#cmbHos').combobox({
        onChange: function () {
            var hos = $('#cmbHos').combobox('getValue'); //取选中值
            PHA_COM.Session.HOSPID = hos;
            InitDict();
            cleanCondiTion(); // 清理条件
            cleanGird(); // 清理列表
    		cleanHtml(); // 清理预览
        }
    });
    $('#cmbDocLoc').combobox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#comAdmloc').combobox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#comAdmward').combobox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#comDoclevel').combobox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#comdoc').combobox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#comAdmtype').combobox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#comadmPayType').combobox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#comRegisteredType').combobox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#pamino').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patno = $.trim($('#pamino').val());
            if (patno != '') {
	            //允许填入多个登记号，以逗号分隔，Enter时自动补零
	            patno = patno.replace("，",",")
	            var patnoArr = patno.split(",")
	            var len = patnoArr.length
	            for (i=0;i<len;i++){
			        for(j=i+1;j<len;j++){
				        if(patnoArr[j]==patnoArr[i]||PHA_COM.FullPatNo(patnoArr[j])==patnoArr[i]){
					        PHA.Popover({ showType: 'show', msg: $g('登记号有重复！')+patnoArr[j], type: 'alert' });
					        return;
				        }
				        
			        }
		         patnoArr[i]=PHA_COM.FullPatNo(patnoArr[i])
	            }
                $(this).val(patnoArr.join(","));
            }
            EventUnite();
        }
    });
    $('#pamino').on('blur', function (event) {
        //登记号在丢失焦点时也处方预览事件(比如在删除置空登记号时使用)
        var patno = $.trim($('#pamino').val());
        if (patno != '') {
            $(this).val(PHA_COM.FullPatNo(patno));
        }
        //showTmpCombPanel();
        //EventUnite();
    });

    $('#qty').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            EventUnite();
        }
    });
    $('#qty').on('blur', function (event) {
	    //showTmpCombPanel();
        //EventUnite();
    });

    /// 审核医生主列表
    $('#TextProp').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var HosID = $('#cmbHos').combobox('getValue') || '';
            var TextProp = $('#TextProp').val();
            inputStr = HosID + '^' + TextProp;
            $('#gridDrugProp').datagrid('query', {
                inputStr: inputStr,
            });
        }
    });
     $('#QtyStartDate').datebox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#QtyEndDate').datebox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#ActiveStartDate').datebox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#ActiveEndDate').datebox({
        onChange: function () {
            EventUnite();
        },
    });
    $('#comCtrlLevel').combobox({
        onChange: function () {
            ShowPrompt();
        },
    });
}

///显示或隐藏提示信息
function ShowPrompt(){
	var CtrlLevel = $('#comCtrlLevel').combobox('getValue') || '';
	if(CtrlLevel!="提醒"){
        $('#promptDiv').hide();
        $('#prompt').val("");
	}
	else{
        $('#promptDiv').show();
	}
}

// 延迟调用getText方法，因为在下拉框选中事件触发时，下拉框还未给Desc赋值，此时不能用getText取值。
function EventUnite() {
    setTimeout('showTmpCombPanel()', 100);
}

function queryList() {
    $('#gridPhcGe').datagrid('clearSelections');
    $('#gridArc').datagrid('clearSelections');

    var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个院区！'), type: 'alert' });
        return null;
    }
    var phaLocId = $('#cmbPhaLoc').combobox('getValue') || '';
    //var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
    var ArcItm = '',
        PHCGe = '',
        inputStr = '';
    if (tabId == 'tabPHCGeLable') {
        PHCGe = $('#PHCGeneric').lookup('getValue') || '';
        inputStr = HosID + '^' + phaLocId + '^' + PHCGe;
        $('#gridPhcGe').datagrid('query', {
            inputStr: inputStr,
        });
    } else if (tabId == 'tabArcLable') {
        ArcItm = $('#inciArcim').lookup('getValue') || '';
        inputStr = HosID + '^' + phaLocId + '^' + ArcItm;
        $('#gridArc').datagrid('query', {
            inputStr: inputStr,
        });
    } else if (tabId == 'tabDrugPropLable') {
        var TextProp = $('#TextProp').val();
        inputStr = HosID + '^' + TextProp;
        $('#gridDrugProp').datagrid('query', {
            inputStr: inputStr,
        });
    }
    $('#gridCom').datagrid('clearSelections');
    $('#gridCom').datagrid('clear');
}
///删除主表数据  //已作废
function DeleteDUL() {
    //var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
    var DULId = '';
    if (tabId == 'tabPHCGeLable') {
        var gridSelect = $('#gridPhcGe').datagrid('getSelected') || '';
        if (gridSelect) DULId = gridSelect.DULRowId;
    } else if (tabId == 'tabArcLable') {
        var gridSelect = $('#gridArc').datagrid('getSelected') || '';
        if (gridSelect) DULId = gridSelect.DULRowId;
    }
    if (DULId == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选中一条数据！'), type: 'alert' });
        return;
    }

    PHA.Confirm($g('提示'), $g('您确认删除此' + tabTitle + $g('数据吗？')), function () {
        $.cm(
            {
                ClassName: 'PHA.IN.DrugUseLimit.Save',
                MethodName: 'DeleteDUL',
                DULRowid: DULId,
            },
            function (retData) {
                if (!retData) {
                    $('#gridCom').datagrid('clear');
                    queryList();
                    PHA.Popover({ showType: 'show', msg: $g('删除成功!'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('删除失败:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    });
}
function DeleteDULRow(DULId) {
    PHA.Confirm($g('提示'), $g('您确认删除此行数据吗？'), function () {
        $.cm(
            {
                ClassName: 'PHA.IN.DrugUseLimit.Save',
                MethodName: 'DeleteDUL',
                DULRowid: DULId,
            },
            function (retData) {
                if (!retData) {
                    $('#gridCom').datagrid('clear');
                    queryList();
                    PHA.Popover({ showType: 'show', msg: $g('删除成功!'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('删除失败:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    });
}

function deleteFormatter(value, rowData, rowIndex) {
    var DUlRowID = rowData.DULRowId;
    return (
        '<span class="icon icon-cancel"  onclick="DeleteDULRow(\'' +
        DUlRowID +
        '\')">&ensp;</span>'
    );
}

// 保存数据
function Save() {
    var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个医院！'), type: 'alert' });
        $('#cmbHos').combobox('showPanel');
        return;
    }
    var phaLocId = $('#cmbPhaLoc').combobox('getValue') || '';
    var admLoc = $('#comAdmloc').combobox('getValues') || '';
    //var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
    var DULId = '',
        ArcItm = '',
        PHCGe = '',
        PropDesc = '';
    if (tabId ==='tabPHCGeLable') {
        PHCGe = $('#PHCGeneric').lookup('getValue') || '';
        var gridSelect = $('#gridPhcGe').datagrid('getSelected') || '';
        if (gridSelect) DULId = gridSelect.DULRowId;
        if (!PHCGe && !DULId) {
            PHA.Popover({ showType: 'show', msg: $g('请选择一个处方通用名！'), type: 'alert' });
            return;
        }
    } else if (tabId ==='tabArcLable') {
        ArcItm = $('#inciArcim').lookup('getValue') || '';
        var gridSelect = $('#gridArc').datagrid('getSelected') || '';
        if (gridSelect) DULId = gridSelect.DULRowId;
        if (!ArcItm && !DULId) {
            PHA.Popover({ showType: 'show', msg: $g('请选择一个医嘱项！'), type: 'alert' });
            return;
        }
    } else if (tabId ==='tabDrugPropLable') {
        var gridSelect = $('#gridDrugProp').datagrid('getSelected') || '';
        if (gridSelect) {
            DULId = gridSelect.DULRowId;
            PropDesc = gridSelect.PropDesc;
        }
        if (!PropDesc && !DULId) {
            PHA.Popover({ showType: 'show', msg: $g('请选择一个药品属性！'), type: 'alert' });
            return;
        }
    }
    //alert(PHCGe+"$"+ArcItm+"$"+DULId);
    var DocLoc = $('#cmbDocLoc').combobox('getValues') || '';
    var Admloc = $('#comAdmloc').combobox('getValues') || '';
    var Admward = $('#comAdmward').combobox('getValues') || '';
    var Doclevel = $('#comDoclevel').combobox('getValues') || '';
    var doc = $('#comdoc').combobox('getValues') || '';
    var Admtype = $('#comAdmtype').combobox('getValues') || '';
    var admPayType = $('#comadmPayType').combobox('getValues') || '';
    var registeredType = $('#comRegisteredType').combobox('getValues') || '';
    
    var pamino = $('#pamino').val();
    var prompt = $('#prompt').val()
    var qty = $('#qty').val();
    
    var QtyStartDate 	= $('#QtyStartDate').datebox('getValue') || '';
    var QtyEndDate 		= $('#QtyEndDate').datebox('getValue') || '';
    var ActiveStartDate = $('#ActiveStartDate').datebox('getValue') || '';
    var ActiveEndDate 	= $('#ActiveEndDate').datebox('getValue') || '';

    if (qty != '' && (tabId != 'tabArcLable')) { 
        PHA.Popover({
            showType: 'show',
            msg: $g('只有医嘱项可以维护限制数量，处方通用名/药品属性不可以维护限制数量！'),
            type: 'alert',
        });
        return;
    }

    var CtrlLevel = $('#comCtrlLevel').combobox('getValue') || '';
    if (CtrlLevel == '') {
	    $('#comCtrlLevel').combobox('showPanel');
        PHA.Popover({ showType: 'show', msg: $g('请选择管控级别！'), type: 'alert',style: {
                            top: 200,
                            left: ''
                        } });
        return;
    }
    if(CtrlLevel==$g("提醒")&&prompt==""){
	    PHA.Popover({ showType: 'show', msg: $g('管控级别为提醒时需维护提醒信息！'), type: 'alert' });
        return;
    }
    
    if (qty != '' && CtrlLevel != '禁止' && CtrlLevel != '允许' ) {
        PHA.Popover({ showType: 'show', msg: $g('维护限制数量时管控级别必须为禁止/允许！'), type: 'alert' });
        return;
    }
    //alert(DocLoc+"#"+Admloc+"#"+Admward+"#"+Doclevel+"#"+doc+"#"+Admtype+"#"+admPayType+"#"+pamino+"#"+qty)
    if (
        DocLoc == '' &&
        Admloc == '' &&
        Admward == '' &&
        Doclevel == '' &&
        doc == '' &&
        Admtype == '' &&
        admPayType == '' &&
        registeredType == '' &&
        pamino == ''
    ) {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个限制条件！'), type: 'alert' });
        return;
    }
    var dataConDition =
        DocLoc +
        '#' +
        Admloc +
        '#' +
        Admward +
        '#' +
        Doclevel +
        '#' +
        doc +
        '#' +
        Admtype +
        '#' +
        admPayType +
        '#' +
        pamino +
        '#' +
        qty +
        '#' +
        QtyStartDate+
        '#' +
        QtyEndDate+
        '#' +
        ActiveStartDate+
        '#' +
        ActiveEndDate+
        '#' +
        prompt +
        '#' +
        registeredType;
    $.cm(
        {
            ClassName: 'PHA.IN.DrugUseLimit.Save',
            MethodName: 'Save',
            HosID: HosID,
            phaLocId: phaLocId,
            DULId: DULId,
            PHCGe: PHCGe,
            PropDesc: PropDesc,
            ArcItm: ArcItm,
            CtrlLevel: CtrlLevel,
            dataConDition: dataConDition,
            UserId: UserId,
            // HosID, phaLocId As %String, DULId, PHCGe, ArcItm, CtrlLevel, DocLoc As %String = "", Admloc = "", Admward = "", Doclevel = "", doc = "", Admtype = "", admPayType = "", pamino = "", qty = ""
        },
        function (retData) {
            if (retData.code == '0') {
                var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
                var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
                if (tabId === 'tabPHCGeLable')
                    var gridSelect = $('#gridPhcGe').datagrid('getSelected') || '';
                else if (tabId === 'tabArcLable')
                    var gridSelect = $('#gridArc').datagrid('getSelected') || '';
                else if (tabId === 'tabDrugPropLable') 
                    var gridSelect = $('#gridDrugProp').datagrid('getSelected') || '';
                var DULRowId = '';
                if (gridSelect) DULRowId = gridSelect.DULRowId;
                if (DULRowId == '') queryList();
                $('#gridCom').datagrid('query', {
                    inputStr: DULRowId,
                });
                if(DULRowId!="")   //如果为空时也刷新，会导致限制组合信息 下方丢失滚动条
                {
	                $('#tmpComPanel').html('');
	                setTimeout('CloseTmpCombPanel()', 500);  //在编辑完数量之后，blur时间会展开预览框一次。如果保存的关闭事件和blur同时触发，会导致预览框关闭，限制组合明细框没合拢
    				//$('.layout-button-left').trigger('click');
                }
                PHA.Popover({ showType: 'show', msg: retData.desc, type: 'success' });
            } else
                PHA.Popover({ showType: 'show', msg: $g('保存失败:') + retData.desc, type: 'alert' });
        }
    );
}

///删除组合
function DeleteComb() {
    var CombRowId = '';
    var gridSelect = $('#gridCom').datagrid('getSelected') || '';
    if (gridSelect) CombRowId = gridSelect.combRowid;
    if (!CombRowId) {
        PHA.Popover({ showType: 'show', msg: $g('请选中一个组合') + retData, type: 'alert' });
        return;
    }
    var CombName = gridSelect.CombName;
    PHA.Confirm($g('提示'), $g('您确认删除(') + CombName + ')?', function () {
        $.cm(
            {
                ClassName: 'PHA.IN.DrugUseLimit.Save',
                MethodName: 'DeleteComb',
                CombRowid: CombRowId,
            },
            function (retData) {
                if (!retData) {
                    var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
                    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
                    if (tabId === 'tabPHCGeLable')
                        var gridSelect = $('#gridPhcGe').datagrid('getSelected') || '';
                    else if (tabId === 'tabArcLable')
                        var gridSelect = $('#gridArc').datagrid('getSelected') || '';
                    else if (tabId === 'tabDrugPropLable') 
                        var gridSelect = $('#gridDrugProp').datagrid('getSelected') || '';
                    var DULRowId = '';
                    if (gridSelect) DULRowId = gridSelect.DULRowId;
                    if (DULRowId == '') return;
                    $('#gridCom').datagrid('query', {
                        inputStr: DULRowId,
                    });
                    PHA.Popover({ showType: 'show', msg: $g('删除成功!'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('删除失败:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    });
}

// 清理事件汇总
function clean() {
    cleanGird(); 		// 清理列表
    cleanCondiTion(); 	// 清理条件
    cleanHtml(); 		// 清理预览
    SetDefaultHos(); 	// 初始化各个控件
}

function cleanGird() {
    PHA.DomData('#PhcGeBar', { doType: 'clear' });
    PHA.DomData('#ArcBar', { doType: 'clear' });
    PHA.DomData('#TextPropBar', { doType: 'clear' });

    $('#cmbPhaLoc').combobox('clear');
	$('#gridDrugProp').datagrid('clearSelections');
	$('#gridDrugProp').datagrid('clear');
	$('#gridPhcGe').datagrid('clearSelections');
    $('#gridPhcGe').datagrid('clear');
    $('#gridArc').datagrid('clearSelections');
    $('#gridArc').datagrid('clear');
    $('#gridCom').datagrid('clearSelections');
    $('#gridCom').datagrid('clear');
    
}
function cleanCondiTion() {
    $('#cmbDocLoc').combobox('clear');
    $('#comAdmloc').combobox('clear');
    $('#comAdmward').combobox('clear');
    $('#comDoclevel').combobox('clear');
    $('#comdoc').combobox('clear');
    $('#comAdmtype').combobox('clear');
    $('#comadmPayType').combobox('clear');
    $('#comRegisteredType').datebox('clear');
    $('#pamino').val('');
    $('#qty').numberbox('setValue', "");
    $('#comCtrlLevel').combobox('clear');
    $('#QtyStartDate').datebox('clear');
    $('#QtyEndDate').datebox('clear');
    $('#ActiveStartDate').datebox('clear');
    $('#ActiveEndDate').datebox('clear');
    $('#prompt').val('');
    $('#promptDiv').hide();
    // 药学基本单位取选中医嘱项
    var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;    
    var ArcItm = '',phcdfBuom='';
    if (tabId === 'tabPHCGeLable') {
        ArcItm = $('#inciArcim').lookup('getValue') || '';
        if(ArcItm == ''){
	        var gridSelect = $('#gridArc').datagrid('getSelected') || '';
	        if (gridSelect) phcdfBuom = gridSelect.phcdfBuom;
        }
        else phcdfBuom=tkMakeServerCall("PHA.IN.DrugUseLimit.Query","GetPhcdUomByArc",ArcItm)
        $('#PHCDFUom').val(phcdfBuom)
    }
    else
    	$('#PHCDFUom').val("");
}
function cleanHtml() {
    $('#tmpComPanel').html('');
    $('.layout-button-left').trigger('click');
}

//btnClearCond 按钮对应方法
function btnClearCond() {
    cleanCondiTion(); 	// 清理条件
    cleanHtml(); 		// 清理预览
}

//初始化处方通用名列表
function InitgridPhcGe() {
    //DULRowId, PhcgCode,PhcgDesc,tmpActiveFlag
    var columns = [
        [
            { field: 'DULRowId', title: 'DULRowId', align: 'left', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('删除'),
                align: 'center',
                width: 35,
                formatter: deleteFormatter,
            },
            { field: 'PhcgCode', title: $g('代码'), align: 'left', width: 90 },
            { field: 'PhcgDesc', title: $g('处方通用名'), align: 'left', width: 170 },
            {
                field: 'ActiveFlag',
                title: $g('可用状态'),
                align: 'center',
                width: 70,
                formatter: statusFormatter,
            },
             {
                field: 'ALLNotUseFlag',
                title: $g('全部禁用'),
                align: 'center',
                width: 70,
                formatter: statusFormatterGeneAllNotUse,
                hidden: true
            }
        ],
    ];

    var dataGridOption = {
        fit: true,
        fitColumns: true,
        toolbar: '#PhcGeBar',
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'DULRowId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DrugUseLimit.Query',
            QueryName: 'QueryPHCGList',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
	        /*
            var pageSize = $('#gridPhcGe').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 && total <= pageSize) {
                $('#gridPhcGe').datagrid('selectRow', 0);
            }
            */
            $('.hisui-switchbox').switchbox();
            $('.hisui-switchboxGeneAllNotUse').switchbox();
        },
        onSelect: function (rowIndex, rowData) {
            $('.layout-button-left').trigger('click');
            var DULRowId = rowData.DULRowId;
            queryGridCom(DULRowId);
            $('#PHCDFUom').val("")
        },
    };
    PHA.Grid('gridPhcGe', dataGridOption);
}

//初始化医嘱项列表
function InitgridArc() {
    //DULRowId,ArcCode,ArcDesc,tmpActiveFlag
    var columns = [
        [
            { field: 'DULRowId', title: 'DULRowId', align: 'left', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('删除'),
                align: 'center',
                width: 35,
                formatter: deleteFormatter,
            },
            { field: 'ArcCode', title: $g('代码'), align: 'left', width: 90 },
            { field: 'ArcDesc', title: $g('医嘱项'), align: 'left', width: 170 },
            {
                field: 'ActiveFlag',
                title: $g('可用状态'),
                align: 'center',
                width: 70,
                formatter: statusFormatterArcActive,
            },
             {
                field: 'ALLNotUseFlag',
                title: $g('全部禁用'),
                align: 'center',
                width: 70,
                formatter: statusFormatterArcAllNotUse,
                hidden: true
            },
            { field: 'phcdfBuom', title: 'phcdfBuom', align: 'left', width: 80, hidden: true },
            
            
        ],
    ];
    var dataGridOption = {
        fit: true,
        fitColumns: true,
        toolbar: '#ArcBar',
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'DULRowId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DrugUseLimit.Query',
            QueryName: 'QueryARCList',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
	        /*  /// 去掉自动选中选中功能，原因:在clear gird时会触发一次onLoadSuccess事件。导致下方代码在clear时会执行一遍，限制组合信息无法清空
            var pageSize = $('#gridArc').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 && total <= pageSize) {
                $('#gridArc').datagrid('selectRow', 0);
            }
            */

            $('.hisui-switchboxarcactive').switchbox();
            $('.hisui-switchboxarcallnotuse').switchbox();
        },
        onSelect: function (rowIndex, rowData) {
            $('.layout-button-left').trigger('click');
            var DULRowId = rowData.DULRowId;
            queryGridCom(DULRowId);
            var phcdfBuom = rowData.phcdfBuom;
            $('#PHCDFUom').val(phcdfBuom)
        },
    };
    PHA.Grid('gridArc', dataGridOption);
}

//初始化药品属性列表
function InitgridDrugProp() {
    //DULRowId,PropCode,PropDesc,ActiveFlag
    var columns = [
        [
            { field: 'DULRowId', title: 'DULRowId', align: 'left', width: 80, hidden: true },
            { field: 'PropCode', title: $g('属性代码'), align: 'left', width: 90 },
            { field: 'PropDesc', title: $g('属性名称'), align: 'left', width: 180 },
            {
                field: 'ActiveFlag',
                title: $g('可用状态'),
                align: 'left',
                width: 90,
                formatter: statusFormatterProp,
            }, //
        ],
    ];
    var dataGridOption = {
        fit: true,
        toolbar: '#TextPropBar',
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'PropDesc',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DrugUseLimit.Query',
            QueryName: 'QueryDrugPropList',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
	        /*
            var pageSize = $('#gridDrugProp').datagrid('getPager').data('pagination').options
                .pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 && total <= pageSize) {
                $('#gridDrugProp').datagrid('selectRow', 0);
            }
			*/
            $('.hisui-switchboxprop').switchbox();
        },
        onSelect: function (rowIndex, rowData) {
            $('.layout-button-left').trigger('click');
            var DULRowId = rowData.DULRowId;
            queryGridCom(DULRowId);
        },
    };
    PHA.Grid('gridDrugProp', dataGridOption);
}

function queryGridCom(DULRowId){
	$('#gridCom').datagrid('clearSelections');
    $('#gridCom').datagrid('clear');
	$('#gridCom').datagrid('query', {
        inputStr: DULRowId,
    });
}

//自定义状态列格式
function statusFormatter(value, rowData, rowIndex) {
    var DUlRowID = rowData.DULRowId;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchbox\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'true' +
            ',disabled:false,onSwitchChange:function(e, obj){Update(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchbox\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'false' +
            ',disabled:false,onSwitchChange:function(e, obj){Update(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}

function statusFormatterArcActive(value, rowData, rowIndex) {
    var DUlRowID = rowData.DULRowId;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchboxarcactive\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'true' +
            ',disabled:false,onSwitchChange:function(e, obj){Update(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchboxarcactive\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'false' +
            ',disabled:false,onSwitchChange:function(e, obj){Update(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}
function statusFormatterGeneAllNotUse(value, rowData, rowIndex) {
    var DUlRowID = rowData.DULRowId;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchboxGeneAllNotUse\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'true' +
            ',disabled:false,onSwitchChange:function(e, obj){UpdateAllNotUse(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchboxGeneAllNotUse\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'false' +
            ',disabled:false,onSwitchChange:function(e, obj){UpdateAllNotUse(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}

function statusFormatterArcAllNotUse(value, rowData, rowIndex) {
    var DUlRowID = rowData.DULRowId;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchboxarcallnotuse\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'true' +
            ',disabled:false,onSwitchChange:function(e, obj){UpdateAllNotUse(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchboxarcallnotuse\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'false' +
            ',disabled:false,onSwitchChange:function(e, obj){UpdateAllNotUse(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}

function statusFormatterProp(value, rowData, rowIndex) {
    var DUlRowID = rowData.DULRowId;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchboxprop\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'true' +
            ',disabled:false,onSwitchChange:function(e, obj){Update(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else if (value == 'N') {
        return (
            "<div class=\"hisui-switchboxprop\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'false' +
            ',disabled:false,onSwitchChange:function(e, obj){Update(obj.value,' +
            DUlRowID +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}

function statusFormatteri(value, rowData, rowIndex) {
    var CombRowID = rowData.combRowid;
    var IndexString = JSON.stringify(rowIndex);
    if (value == '') return;

    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchboxi\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'true' +
            ",disabled:false,onSwitchChange:function(e, obj){Updatei(obj.value,'" +
            CombRowID +
            "'," +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchboxi\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'false' +
            ",disabled:false,onSwitchChange:function(e, obj){Updatei(obj.value,'" +
            CombRowID +
            "'," +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}

function Update(objVal, DULRowid, Index, value) {
    //PHA.Confirm($g('提示'), $g('您确认修改可用状态吗?'), function () {
    var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
    var ArcItm = '';
    var PHCGe = '';
    var inputStr = '';
    if (tabId === 'tabPHCGeLable') $grid = $('#gridPhcGe');
    else if (tabId === 'tabArcLable') $grid = $('#gridArc');
    else if (tabId === 'tabDrugPropLable') $grid = $('#gridDrugProp');
    if (objVal) value = 'N';
    else value = 'Y';
    var gridSelect = $grid.datagrid('getSelected') || '';
    $.cm(
        {
            ClassName: 'PHA.IN.DrugUseLimit.Save',
            MethodName: 'UpdateActive',
            DULRowid: DULRowid,
            ActiveFlag: value,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('修改可用状态成功'), type: 'success' });
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('修改可用状态失败！ 错误描述') + retData.desc,
                    type: 'alert',
                });
        }
    );
    //});
}



function UpdateAllNotUse(objVal, CombRowID, Index, value) {
        $grid = $('#gridCom');
        if (objVal) value = 'N';
        else value = 'Y';
        var gridSelect = $grid.datagrid('getSelected') || '';
        $.cm(
            {
                ClassName: 'PHA.IN.DrugUseLimit.Save',
                MethodName: 'UpdateAllNotUseFlag',
                DULRowid: CombRowID,
                AllNotUseFlag: value,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: $g('修改全部禁用状态成功'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('修改全部禁用状态失败！ 错误描述') + retData.desc,
                        type: 'alert',
                    });
            }
        );
}


function Updatei(objVal, CombRowID, Index, value) {
    //PHA.Confirm($g('提示'), $g('您确认修改可用状态吗?'), function () {
        $grid = $('#gridCom');
        if (objVal) value = 'N';
        else value = 'Y';
        var gridSelect = $grid.datagrid('getSelected') || '';
        $.cm(
            {
                ClassName: 'PHA.IN.DrugUseLimit.Save',
                MethodName: 'UpdateCombActive',
                CombRowid: CombRowID,
                ActiveFlag: value,
                UserId: UserId,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: $g('修改可用状态成功'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('修改可用状态失败！ 错误描述') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    //});
}

//初始组合明细
function InitCom() {
    var columns = [
        [
            // combRowid,combItmRowid,activeFlag,CtrlLevel,CombItmType,CombItmTypeVal,limitQty,combItmSign,Prompt
            { field: 'combRowid', title: 'DULCRowId', align: 'center', width: 80, hidden: true },
            {
                field: 'combItmRowid',
                title: 'DULCRowIdi',
                align: 'center',
                width: 80,
                hidden: true,
            },{
                field: 'deleteBut',
                title: $g('删除'),
                align: 'center',
                width: 50,
                formatter: deleteFormatteri,
            },
            { field: 'CombName', title: $g('组合'), align: 'center', width: 60 },
            {
                field: 'activeFlag',
                title: $g('可用状态'),
                align: 'center',
                width: 80,
                formatter: statusFormatteri,
            },
            
            { field: 'CtrlLevel', title: $g('管控级别'), align: 'center', width: 70 },
            {
                field: 'combItmSign',
                title: $g('组'),
                align: 'center',
                width: 40,
                formatter: PIVAS.Grid.Formatter.OeoriSign,
            },
            { field: 'CombItmType', title: $g('类型'), align: 'left', width: 80 },
            { field: 'CombItmTypeDesc', title: $g('值'), align: 'left', width: 200 },
            { field: 'UseQty', title: $g('月消耗数量'), align: 'right', width: 80 },
            { field: 'limitQty', title: $g('月限制数量'), align: 'right', width: 80 },
            { field: 'buomDesc', title: $g('单位'), align: 'center', width: 60 },
            // QtyStartDate,QtyEndDate,ActiveStartDate,ActiveEndDate
            { field: 'QtyStartDate', 	title: $g('消耗开始日期'), align: 'center', width: 95 },
            { field: 'QtyEndDate', 		title: $g('消耗结束日期'), align: 'center', width: 95 },
            { field: 'ActiveStartDate', title: $g('限制开始日期'), align: 'center', width: 95 },
            { field: 'ActiveEndDate', 	title: $g('限制结束日期'), align: 'center', width: 95 },
            { field: 'Prompt', 			title: $g('提醒信息'),	   align: 'left', 	width: 150 },
            { field: 'AddDate', 		title: $g('添加日期'),	   align: 'left', 	width: 100 },
            { field: 'Remark', 			title: $g('备注信息'),	   align: 'left', 	width: 150 },
            { field: 'UpdateDate', 		title: $g('更新日期'),	   align: 'left', 	width: 100 },
            { field: 'UpdateTime', 		title: $g('更新时间'),	   align: 'left', 	width: 100 },
            { field: 'UpdateUser', 		title: $g('操作人'),	   align: 'left', 	width: 100 }
            
        ],
    ];
    var dataGridOption = {
        fit: true,
        gridSave: false,
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'combItmRowid',
        toolbar: '#gridComBar',
        columns: columns,
        exportXls:false,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DrugUseLimit.Query',
            QueryName: 'QueryCombItm',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
            $('.hisui-switchboxi').switchbox();
        },
    };
    PHA.Grid('gridCom', dataGridOption);
}

function deleteFormatteri(value, rowData, rowIndex) {
    var combRowid = rowData.combRowid;
    var CombName = rowData.CombName;
    if (CombName) { 
        return (
			'<span class="icon icon-cancel"  onclick="DeleteCombi(\'' +
			combRowid +
            '\',\'' +
            CombName +
			'\')">&ensp;</span>'
		);
    }
    else return value;
}

function DeleteCombi(combRowid, CombName) {
    PHA.Confirm($g('提示'), $g('您确认删除(') + CombName + ')?', function () {
        $.cm(
            {
                ClassName: 'PHA.IN.DrugUseLimit.Save',
                MethodName: 'DeleteComb',
                CombRowid: combRowid,
            },
            function (retData) {
                if (!retData) {
                    var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
                    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
                    if (tabId === 'tabPHCGeLable')
                        var gridSelect = $('#gridPhcGe').datagrid('getSelected') || '';
                    else if (tabId === 'tabArcLable')
                        var gridSelect = $('#gridArc').datagrid('getSelected') || '';
                    else if (tabId === 'tabDrugPropLable') 
                        var gridSelect = $('#gridDrugProp').datagrid('getSelected') || '';
                    var DULRowId = '';
                    if (gridSelect) DULRowId = gridSelect.DULRowId;
                    if (DULRowId == '') return;
                    $('#gridCom').datagrid('query', {
                        inputStr: DULRowId,
                    });
                    PHA.Popover({ showType: 'show', msg: $g('删除成功!'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('删除失败:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    });
}

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
    //医嘱项lookup
    var opts = $.extend({}, PHA_STORE.ArcItmMast('Y'), {
        width: lookUpWidth,
    });
    PHA.LookUp('inciArcim', opts);
    //处方通用名lookup
    var opts = $.extend({}, PHA_STORE.PHCGeneric('Y'), {
        width: lookUpWidth,
    });
    PHA.LookUp('PHCGeneric', opts);

    //药房科室
    PHA.ComboBox('cmbPhaLoc', {
        url: PHA_STORE.Pharmacy('').url,
    });
    //医生科室
    PHA.ComboBox('cmbDocLoc', {
        url: PHA_STORE.DocLoc().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });

    //就诊科室
    PHA.ComboBox('comAdmloc', {
        url: PHA_STORE.DocLoc().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //病区
    PHA.ComboBox('comAdmward', {
        url: PHA_STORE.WardLoc().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //医生职称
    PHA.ComboBox('comDoclevel', {
        url: PHA_STORE.PositionalTitles().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    // 指定医生
    PHA.ComboBox('comdoc', {
        url: PHA_STORE.Doctor().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //就诊类型
    PHA.ComboBox('comAdmtype', {
        url: PHA_STORE.Admtype().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //费别
    PHA.ComboBox('comadmPayType', {
        url: PHA_STORE.PACAdmReason().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //挂号职称 
    PHA.ComboBox('comRegisteredType', {
        url: PHA_STORE.RegisteredType().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    comRegisteredType
    //管控级别
    PHA.ComboBox('comCtrlLevel', {
        url: PHA_STORE.CtrlLevel().url,
        width: ComBoxWidth,
        editable:false,
        panelHeight: 'auto'
    });
    /// 医嘱项复制医嘱项模糊检索
    $('#TextCopyArc').searchbox({
	    searcher:function(value,name){
	    QueryArcCopy(value);
	    },
	    width:473,
	    prompt:$g('医嘱项模糊检索...')
	});
	
	/// 处方通用名复制处方通用名模糊检索
    $('#TextCopyPhcg').searchbox({
	    searcher:function(value,name){
	    QueryPhcgCopy(value);
	    },
	    width:473,
	    prompt:$g('处方通用名模糊检索...')
    });
    
    $('#promptDiv').hide();

}
/// 关闭组合预览界面
function CloseTmpCombPanel() {
	$('.layout-button-left').trigger('click');	
}

/// 显示组合预览界面
function showTmpCombPanel() {
    $('.layout-button-right').trigger('click');
    //var DocLocId=$('#cmbDocLoc').combobox("getValues")||"";
    var DocLocDesc = $('#cmbDocLoc').combobox('getText') || '';
    var AdmlocDesc = $('#comAdmloc').combobox('getText') || '';
    var AdmwardDesc = $('#comAdmward').combobox('getText') || '';
    var DoclevelDesc = $('#comDoclevel').combobox('getText') || '';
    var docDesc = $('#comdoc').combobox('getText') || '';
    var AdmtypeDesc = $('#comAdmtype').combobox('getText') || '';
    var admPayTypeDesc = $('#comadmPayType').combobox('getText') || '';
    var registeredTypeDesc = $('#comRegisteredType').combobox('getText') || '';
    var pamino = $('#pamino').val();
    var qty = $('#qty').val();
    var QtyStartDate 	= $('#QtyStartDate').datebox('getValue') || '';
    var QtyEndDate 		= $('#QtyEndDate').datebox('getValue') || '';
    var ActiveStartDate = $('#ActiveStartDate').datebox('getValue') || '';
    var ActiveEndDate 	= $('#ActiveEndDate').datebox('getValue') || '';

    var comditionArr = [
        $g('医生科室'),
        $g('就诊科室'),
        $g('就诊病区'),
        $g('医生职称'),
        $g('指定医生'),
        $g('就诊类型'),
        $g('患者费别'),
        $g('挂号职称'),
        $g('登记号'),
        $g('限制数量'),
        $g('消耗开始'),
        $g('消耗结束'),
        $g('限制开始'),
        $g('限制结束')
    ];
    var descArr = [
        DocLocDesc,
        AdmlocDesc,
        AdmwardDesc,
        DoclevelDesc,
        docDesc,
        AdmtypeDesc,
        admPayTypeDesc,
        registeredTypeDesc,
        pamino,
        qty,
        QtyStartDate,
        QtyEndDate,
        ActiveStartDate,
        ActiveEndDate
    ];
    //计算最大行数
    var lenArr = [];
    existFlag = 0;
    var TotalArrSize = 1;
    (tmpDesc = ''), (tmpDescArr = []);
    for (var i = 0; i < 13; i++) {
        tmpDesc = descArr[i];
        var tmplen = 0;
        if (tmpDesc) {
            existFlag = 1;
            tmpDescArr = tmpDesc.split(',');
            descArr[i] = tmpDescArr;
            tmplen = tmpDescArr.length;
        }
        lenArr[i] = tmplen;
        if (tmplen) TotalArrSize *= tmplen;
    }
    if (existFlag == 0) 
    {
	    $('#tmpComPanel').html("");
	    return;
    }
    //组织组合数据以数据形式存储
    var totalArr = [];
    var subNum = TotalArrSize;
    for (var j = 0; j < 13; j++) {
        totalArr[j] = [];
        if (lenArr[j]) subNum = subNum / lenArr[j];
        else continue;
        var beginY = 0;
        for (var h = 0; h < TotalArrSize; h++) {
            totalArr[j][h] = '';
            if (h && !(h % subNum)) beginY++;
            if (beginY == lenArr[j]) beginY = 0;
            //alert(j+"#"+h+"#"+beginY+"#"+subNum)
            totalArr[j][h] = descArr[j][beginY];
        }
    }

    var htmlStr = '<table>'; //用列表形式对齐
    for (var i = 0; i < TotalArrSize; i++) {
        htmlStr += "<tr style='height:30px'>";
        for (var j = 0; j < 13; j++) {
            if (!lenArr[j]) continue;
            htmlStr =
                htmlStr +
                "<td><font color='#666666'>" +
                comditionArr[j] +
                '</font>' +
                ':' +
                totalArr[j][i] +
                '; </td>';
        }
        htmlStr += '</tr>';
        //htmlStr=htmlStr+"<br><hr style='border-top:1px solid #ccc;'  />"
    }
    htmlStr += '</table>';

    $('#tmpComPanel').html(htmlStr);

}

function QueryArcList()
{
	var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个院区！'), type: 'alert' });
        return null;
    }
    var phaLocId = $('#cmbPhaLoc').combobox('getValue') || '';
    ArcItm = $('#inciArcim').lookup('getValue') || '';
    inputStr = HosID + '^' + phaLocId + '^' + ArcItm;
    $('#gridArc').datagrid('query', {
        inputStr: inputStr,
    });
}

function QueryPhcgList()
{
	var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个院区！'), type: 'alert' });
        return null;
    }
    var phaLocId = $('#cmbPhaLoc').combobox('getValue') || '';
    PHCGe = $('#PHCGeneric').lookup('getValue') || '';
    inputStr = HosID + '^' + phaLocId + '^' + PHCGe;
    $('#gridPhcGe').datagrid('query', {
        inputStr: inputStr,
    });
}

///复制限制用药属性给其他的医嘱项/处方通用名
function Copy(){
	var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个院区！'), type: 'alert' });
        return null;
    }
    var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    var Rows = $('#gridCom').datagrid('getRows') || '';
    if (Rows.length == 0)
	{
		PHA.Popover({ showType: 'show', msg: $g('当前限制组合信息不能为空！'), type: 'alert' });
        return "";
	}
    
    //var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
    if (tabId === 'tabPHCGeLable'){
	    var gridSelect = $('#gridPhcGe').datagrid('getSelected') || '';
	    if(!gridSelect) {
			PHA.Popover({ showType: 'show', msg: $g('请选择一个处方通用名！'), type: 'alert' });
        	return ""; 
	    }
        InitDiagPhcgCopy(HosID,Loc)
    }
    else if (tabId === 'tabArcLable'){
	    var gridSelect = $('#gridArc').datagrid('getSelected') || '';
	    if(!gridSelect) {
			PHA.Popover({ showType: 'show', msg: $g('请选择一个医嘱项！'), type: 'alert' });
        	return ""; 
	    }
		InitDiagArcCopy(HosID,Loc)
    }
	else if (tabId === 'tabDrugPropLable')
	{
		PHA.Popover({ showType: 'show', msg: $g('药品属性不支持复制功能！'), type: 'alert' });
        return "";
	} 
}

function InitDiagArcCopy(HosID,Loc) {
	$('#TextCopyArc').searchbox("setValue","")
    $('#diagArcCopy')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            // arcimId,arcimCode,arcimDesc
            { field: 'arcimId', title: 'arcimId', align: 'left', width: 200, hidden: true },
            { field: 'opre', title: '操作', align: 'center', width: 50 , formatter:CopyFormatter},
            { field: 'arcimCode', title: '代码', align: 'left', width: 130 },
            { field: 'arcimDesc', title: '医嘱项', align: 'left', width: 280 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DrugUseLimit.Query',
            QueryName: 'QueryArcWithOutLimit',
            inputStr: "^"+HosID+"^"+Loc,

        },
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#gridArcCopyBar',
    };
    PHA.Grid('gridArcCopy', dataGridOption);
}

function InitDiagPhcgCopy(HosID,Loc) {
	$('#TextCopyPhcg').searchbox("setValue","")
    $('#diagPhcgCopy')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            // geneId,geneCode,geneName
            { field: 'geneId', title: 'geneId', align: 'left', width: 200, hidden: true },
            { field: 'opre', title: '操作', align: 'center', width: 50 , formatter:CopyFormatter},
            { field: 'geneCode', title: '代码', align: 'left', width: 130 },
            { field: 'geneName', title: '处方通用名', align: 'left', width: 280 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DrugUseLimit.Query',
            QueryName: 'QueryPhcgWithOutLimit',
            inputStr: "^"+HosID+"^"+Loc,

        },
        gridSave: false,
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#gridPhcgCopyBar',
    };
    PHA.Grid('gridPhcgCopy', dataGridOption);
}

function CopyFormatter(value, rowData, rowIndex) {
	var arcimId =rowData.arcimId || "";
	var geneId =rowData.geneId || "";
	return (
       "<a class=\"hisui-linkbutton\" data-options=\"iconCls:'icon-w-find'\" onclick=\"javascript:copyArc('"+arcimId+"','"+ geneId +"')\">" + $g('复制') + "</a>"
    ); 
}

function copyArc(arcimId,phcgId){
	var Data = GetCopyInfo()
	if (Data == "") return;
	Data.arcimId=arcimId;
	Data.phcgId=phcgId; 
	Data=JSON.stringify(Data)
	$.cm(
        {
            ClassName: 'PHA.IN.DrugUseLimit.Save',
            MethodName: 'CopyArcOrPhcg',
            ParamsJson: Data,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('复制成功'), type: 'success' });
                //var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
                var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
			    if (tabId === 'tabPHCGeLable'){
			        QueryPhcgCopy();
			        QueryPhcgList();
			    }
			    else if (tabId === 'tabArcLable'){
					QueryArcCopy();
					QueryArcList();
			    }
            } else
                PHA.Popover({ showType: 'show',msg: $g('复制失败！ 错误描述:') + retData.desc,type: 'alert',});
        }
    );
}

function GetCopyInfo()
{
    //var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
    if (tabId === 'tabPHCGeLable')
        var gridSelect = $('#gridPhcGe').datagrid('getSelected') || '';
    else if (tabId === 'tabArcLable')
        var gridSelect = $('#gridArc').datagrid('getSelected') || '';
    else if (tabId === 'tabDrugPropLable') {
	    PHA.Popover({ showType: 'show', msg: $g('药品属性不支持复制功能！'), type: 'alert' });
        return "";
    }
    if(!gridSelect) return "";
    
    if (gridSelect) {
		DULRowId = gridSelect.DULRowId || "";
		PhcgDesc = gridSelect.PhcgDesc || "";
		ArcDesc = gridSelect.PhcgDesc || "";
    }
    var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个院区！'), type: 'alert' });
        return null;
    }
    var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    var Data={
	    DULRowId:DULRowId,
	    ArcDesc:ArcDesc,
	    PhcgDesc:PhcgDesc,
	    HosID:HosID,
	    Loc:Loc
	    }
	return Data;
}

function QueryArcCopy(value){
	if(!value) value = $('#TextCopyArc').searchbox("getValue")
	var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个院区！'), type: 'alert' });
        return null;
    }
    var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    $('#gridArcCopy').datagrid('query', {
            inputStr: value+"^"+HosID+"^"+Loc
    });
}


function QueryPhcgCopy(value){
	if(!value) value = $('#TextCopyPhcg').searchbox("getValue")
	var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个院区！'), type: 'alert' });
        return null;
    }
    var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    $('#gridPhcgCopy').datagrid('query', {
            inputStr: value+"^"+HosID+"^"+Loc
    });
}

function updateCom(){
	var combRowid = GetULCItmRowId();
	if (!combRowid){
		PHA.Msg("alert","请选择一个组合");
		return;
	}
	$('#diagUpdateCom')
    .dialog({
        iconCls: 'icon-w-edit',
        modal: true,
        onBeforeClose: function () {},
    })
    .dialog('open');
    //初始化修改界面的表单，避免在进入界面时加载缓慢
    InitUpDict();
    InitUpEvent();
    ClearDiagUp();
    SetUpComInfo(combRowid);
}
function SetUpComInfo(combRowid){
	$.cm(
        {
            ClassName : 'PHA.IN.DrugUseLimit.Query',
            MethodName: 'GetUpCom',
            CombRowid : combRowid,
        },
        function (retData) {
            PHA.SetVals([retData]);
        }
    );	
}

function GetULCItmRowId(){
	var combRowid = ""
	var gridSelect = $('#gridCom').datagrid('getSelected') || '';
    if (gridSelect) combRowid = gridSelect.combRowid;  //combItmRowid
    return combRowid
}

function ClearDiagUp(){
	PHA.DomData("#diagUpdateCom", {
         doType: "clear"
    });
}

function InitUpDict(){
	//医生科室
    PHA.ComboBox('upDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: ComBoxWidth,
    });

    //就诊科室
    PHA.ComboBox('upAdmloc', {
        url: PHA_STORE.DocLoc().url,
        width: ComBoxWidth,
    });
    //病区
    PHA.ComboBox('upAdmward', {
        url: PHA_STORE.WardLoc().url,
        width: ComBoxWidth,
    });
    //医生职称
    PHA.ComboBox('upDoclevel', {
        url: PHA_STORE.PositionalTitles().url,
        width: ComBoxWidth,
    });
    // 指定医生
    PHA.ComboBox('updoc', {
        url: PHA_STORE.Doctor().url,
        width: ComBoxWidth,
    });
    //就诊类型
    PHA.ComboBox('upAdmtype', {
        url: PHA_STORE.Admtype().url,
        width: ComBoxWidth,
    });

    //费别
    PHA.ComboBox('upadmPayType', {
        url: PHA_STORE.PACAdmReason().url,
        width: ComBoxWidth,
    });

    //挂号职称
    PHA.ComboBox('uprgisteredType', {
        url: PHA_STORE.RegisteredType().url,
        width: ComBoxWidth,
    });

    //管控级别
    PHA.ComboBox('upCtrlLevel', {
        url: PHA_STORE.CtrlLevel().url,
        width: ComBoxWidth,
        editable:false,
        panelHeight: 'auto'
    });
}

function InitUpEvent(){
    $('#uppamino').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patno = $.trim($('#uppamino').val());
            if (patno != '') {
				patno = PHA_COM.FullPatNo(patno)
                $(this).val(patno);
            }
        }
    });
    
    $('#upCtrlLevel').combobox({
        onChange: function () {
            ShowUpPrompt();
        },
    });
}

///显示或隐藏提示信息
function ShowUpPrompt(){
	var CtrlLevel = $('#upCtrlLevel').combobox('getValue') || '';
	if(CtrlLevel!="提醒"){
		$('#upPromptDiv').hide()
		$('#upprompt').val("")
	}
	else{
		$('#upPromptDiv').show()
	}
}

function SaveUpCom(){
	var ParamsJson = PHA.DomData('#diagUpdateCom', {
        doType: 'query',
        retType: 'Json'
    });
    var CheckUpDataFlag = CheckUpData(ParamsJson[0])
    if(CheckUpDataFlag != ""){
	    PHA.Msg('alert', CheckUpDataFlag);
        return;
	}
	var CombRowid = ParamsJson[0].upCombRowid
    var DULRowId  = CombRowid.split("||")[0]
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $.cm(
        {
            ClassName: 'PHA.IN.DrugUseLimit.Save',
            MethodName: 'SaveUpCom',
            ParamsJson: ParamsJson,
            UserId: UserId,
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '保存成功!', type: 'success' });
				$('#gridCom').datagrid('query', {
                    inputStr: DULRowId,
                });
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.desc, type: 'alert' });
	            return
            }
        }
    );
}

function CheckUpData(ParamsJson){
    var CtrlLevel = ParamsJson.upCtrlLevel
    var qty		  = ParamsJson.upqty
    var prompt	  = ParamsJson.upprompt
    if (!CtrlLevel) {
	    $('#upCtrlLevel').combobox('showPanel');
        return '请选择管控级别';
    }
    //var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
    if (qty != '' && tabId != 'tabArcLable') {
        return '只有医嘱项可以维护限制数量，处方通用名/药品属性不可以维护限制数量！';
    }
    if(CtrlLevel=="提醒"&&prompt==""){
        return '管控级别为提醒时需维护提醒信息！';
    }
    
    if (qty != '' && CtrlLevel != '禁止' && CtrlLevel != '允许' ) {
        return '维护限制数量时管控级别必须为禁止/允许！';
    }
    return "";
}