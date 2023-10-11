//scripts/pha/in/v3/DrugLimit/DrugLimit.js
/**
 * @ģ��:     ������ҩ
 * @��д����: 2020-05-21
 * @��д��:   yangsj
 */

var HosId = session['LOGON.HOSPID'];
var UserId = session['LOGON.USERID'];
var ComBoxWidth = 260;
var lookUpWidth = 465;
$(function () {
    InitDictBegin(); // ��ʼ�����ᷢ���仯��Ԫ��
    InitDict(); // ��ʼ����������Ԫ��
    InitGrid(); // ��ʼ��GIridescent
    //InitSplitCom();  // ����б��ʼ��
    InitCom(); // ����б��ʼ��
    InitEvent(); // ���¼�
});

function InitGrid() {
    InitgridPhcGe(); // ͨ�����б�
    InitgridArc(); // ҽ�����б�
    InitgridDrugProp(); // ҩƷ�����б�
}

//����ҽԺ������Ӱ��Ŀؼ��ڴ˳�ʼ��
function InitDictBegin() {
    PHA.ComboBox('cmbHos', {
        url: PHA_STORE.CTHosNew().url,
        width: 313,
    });

    setTimeout('SetDefaultHos()', 100);
    
    // ���ô���Ԥ���ķ�ʽ��ʼ�� �����������Ԥ��panel
    DEC_PRESC.Layout('comblist', { width: (window.screen.width-1000)/3.67, divId: 'tmpComPanel', title: $g('�����������Ԥ��'), contentType: 'div' }); //�����������Ԥ��panel
    $('.layout-button-left').trigger('click'); //Ĭ���۵�״̬
}
function SetDefaultHos() {
    $('#cmbHos').combobox('setValue', HosId);

    ///�����ؼ�������ӳٰ��¼��Ļ����ᱻ�����¼����ǣ�ֻ���ӳ�ִ�У�����Ҫ��ԭ���¼������ƹ�������Ȼ���¼�ֻ��ȡһ��
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
    // ��ҽԺ����ѡ������������Ҫ���³�ʼ�������³�ʼ���ķ�ʽ���޸�PHA_COM.Session.HOSPID��ֵΪѡ��ҽԺ�������ֵ
    $('#cmbHos').combobox({
        onChange: function () {
            var hos = $('#cmbHos').combobox('getValue'); //ȡѡ��ֵ
            PHA_COM.Session.HOSPID = hos;
            InitDict();
            cleanCondiTion(); // ��������
            cleanGird(); // �����б�
    		cleanHtml(); // ����Ԥ��
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
	            //�����������ǼǺţ��Զ��ŷָ���Enterʱ�Զ�����
	            patno = patno.replace("��",",")
	            var patnoArr = patno.split(",")
	            var len = patnoArr.length
	            for (i=0;i<len;i++){
			        for(j=i+1;j<len;j++){
				        if(patnoArr[j]==patnoArr[i]||PHA_COM.FullPatNo(patnoArr[j])==patnoArr[i]){
					        PHA.Popover({ showType: 'show', msg: $g('�ǼǺ����ظ���')+patnoArr[j], type: 'alert' });
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
        //�ǼǺ��ڶ�ʧ����ʱҲ����Ԥ���¼�(������ɾ���ÿյǼǺ�ʱʹ��)
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

    /// ���ҽ�����б�
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

///��ʾ��������ʾ��Ϣ
function ShowPrompt(){
	var CtrlLevel = $('#comCtrlLevel').combobox('getValue') || '';
	if(CtrlLevel!="����"){
        $('#promptDiv').hide();
        $('#prompt').val("");
	}
	else{
        $('#promptDiv').show();
	}
}

// �ӳٵ���getText��������Ϊ��������ѡ���¼�����ʱ��������δ��Desc��ֵ����ʱ������getTextȡֵ��
function EventUnite() {
    setTimeout('showTmpCombPanel()', 100);
}

function queryList() {
    $('#gridPhcGe').datagrid('clearSelections');
    $('#gridArc').datagrid('clearSelections');

    var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��Ժ����'), type: 'alert' });
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
///ɾ����������  //������
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
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ�����ݣ�'), type: 'alert' });
        return;
    }

    PHA.Confirm($g('��ʾ'), $g('��ȷ��ɾ����' + tabTitle + $g('������')), function () {
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
                    PHA.Popover({ showType: 'show', msg: $g('ɾ���ɹ�!'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('ɾ��ʧ��:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    });
}
function DeleteDULRow(DULId) {
    PHA.Confirm($g('��ʾ'), $g('��ȷ��ɾ������������'), function () {
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
                    PHA.Popover({ showType: 'show', msg: $g('ɾ���ɹ�!'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('ɾ��ʧ��:') + retData.desc,
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

// ��������
function Save() {
    var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��ҽԺ��'), type: 'alert' });
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
            PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ������ͨ������'), type: 'alert' });
            return;
        }
    } else if (tabId ==='tabArcLable') {
        ArcItm = $('#inciArcim').lookup('getValue') || '';
        var gridSelect = $('#gridArc').datagrid('getSelected') || '';
        if (gridSelect) DULId = gridSelect.DULRowId;
        if (!ArcItm && !DULId) {
            PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��ҽ���'), type: 'alert' });
            return;
        }
    } else if (tabId ==='tabDrugPropLable') {
        var gridSelect = $('#gridDrugProp').datagrid('getSelected') || '';
        if (gridSelect) {
            DULId = gridSelect.DULRowId;
            PropDesc = gridSelect.PropDesc;
        }
        if (!PropDesc && !DULId) {
            PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��ҩƷ���ԣ�'), type: 'alert' });
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
            msg: $g('ֻ��ҽ�������ά����������������ͨ����/ҩƷ���Բ�����ά������������'),
            type: 'alert',
        });
        return;
    }

    var CtrlLevel = $('#comCtrlLevel').combobox('getValue') || '';
    if (CtrlLevel == '') {
	    $('#comCtrlLevel').combobox('showPanel');
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��ܿؼ���'), type: 'alert',style: {
                            top: 200,
                            left: ''
                        } });
        return;
    }
    if(CtrlLevel==$g("����")&&prompt==""){
	    PHA.Popover({ showType: 'show', msg: $g('�ܿؼ���Ϊ����ʱ��ά��������Ϣ��'), type: 'alert' });
        return;
    }
    
    if (qty != '' && CtrlLevel != '��ֹ' && CtrlLevel != '����' ) {
        PHA.Popover({ showType: 'show', msg: $g('ά����������ʱ�ܿؼ������Ϊ��ֹ/����'), type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ������������'), type: 'alert' });
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
                if(DULRowId!="")   //���Ϊ��ʱҲˢ�£��ᵼ�����������Ϣ �·���ʧ������
                {
	                $('#tmpComPanel').html('');
	                setTimeout('CloseTmpCombPanel()', 500);  //�ڱ༭������֮��blurʱ���չ��Ԥ����һ�Ρ��������Ĺر��¼���blurͬʱ�������ᵼ��Ԥ����رգ����������ϸ��û��£
    				//$('.layout-button-left').trigger('click');
                }
                PHA.Popover({ showType: 'show', msg: retData.desc, type: 'success' });
            } else
                PHA.Popover({ showType: 'show', msg: $g('����ʧ��:') + retData.desc, type: 'alert' });
        }
    );
}

///ɾ�����
function DeleteComb() {
    var CombRowId = '';
    var gridSelect = $('#gridCom').datagrid('getSelected') || '';
    if (gridSelect) CombRowId = gridSelect.combRowid;
    if (!CombRowId) {
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ�����') + retData, type: 'alert' });
        return;
    }
    var CombName = gridSelect.CombName;
    PHA.Confirm($g('��ʾ'), $g('��ȷ��ɾ��(') + CombName + ')?', function () {
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
                    PHA.Popover({ showType: 'show', msg: $g('ɾ���ɹ�!'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('ɾ��ʧ��:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    });
}

// �����¼�����
function clean() {
    cleanGird(); 		// �����б�
    cleanCondiTion(); 	// ��������
    cleanHtml(); 		// ����Ԥ��
    SetDefaultHos(); 	// ��ʼ�������ؼ�
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
    // ҩѧ������λȡѡ��ҽ����
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

//btnClearCond ��ť��Ӧ����
function btnClearCond() {
    cleanCondiTion(); 	// ��������
    cleanHtml(); 		// ����Ԥ��
}

//��ʼ������ͨ�����б�
function InitgridPhcGe() {
    //DULRowId, PhcgCode,PhcgDesc,tmpActiveFlag
    var columns = [
        [
            { field: 'DULRowId', title: 'DULRowId', align: 'left', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('ɾ��'),
                align: 'center',
                width: 35,
                formatter: deleteFormatter,
            },
            { field: 'PhcgCode', title: $g('����'), align: 'left', width: 90 },
            { field: 'PhcgDesc', title: $g('����ͨ����'), align: 'left', width: 170 },
            {
                field: 'ActiveFlag',
                title: $g('����״̬'),
                align: 'center',
                width: 70,
                formatter: statusFormatter,
            },
             {
                field: 'ALLNotUseFlag',
                title: $g('ȫ������'),
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

//��ʼ��ҽ�����б�
function InitgridArc() {
    //DULRowId,ArcCode,ArcDesc,tmpActiveFlag
    var columns = [
        [
            { field: 'DULRowId', title: 'DULRowId', align: 'left', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('ɾ��'),
                align: 'center',
                width: 35,
                formatter: deleteFormatter,
            },
            { field: 'ArcCode', title: $g('����'), align: 'left', width: 90 },
            { field: 'ArcDesc', title: $g('ҽ����'), align: 'left', width: 170 },
            {
                field: 'ActiveFlag',
                title: $g('����״̬'),
                align: 'center',
                width: 70,
                formatter: statusFormatterArcActive,
            },
             {
                field: 'ALLNotUseFlag',
                title: $g('ȫ������'),
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
	        /*  /// ȥ���Զ�ѡ��ѡ�й��ܣ�ԭ��:��clear girdʱ�ᴥ��һ��onLoadSuccess�¼��������·�������clearʱ��ִ��һ�飬���������Ϣ�޷����
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

//��ʼ��ҩƷ�����б�
function InitgridDrugProp() {
    //DULRowId,PropCode,PropDesc,ActiveFlag
    var columns = [
        [
            { field: 'DULRowId', title: 'DULRowId', align: 'left', width: 80, hidden: true },
            { field: 'PropCode', title: $g('���Դ���'), align: 'left', width: 90 },
            { field: 'PropDesc', title: $g('��������'), align: 'left', width: 180 },
            {
                field: 'ActiveFlag',
                title: $g('����״̬'),
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

//�Զ���״̬�и�ʽ
function statusFormatter(value, rowData, rowIndex) {
    var DUlRowID = rowData.DULRowId;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchbox\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchbox\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxarcactive\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxarcactive\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxGeneAllNotUse\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxGeneAllNotUse\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxarcallnotuse\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxarcallnotuse\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxprop\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxprop\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxi\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
            "<div class=\"hisui-switchboxi\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('��') + "',offText:'" + $g('��') + "',checked:" +
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
    //PHA.Confirm($g('��ʾ'), $g('��ȷ���޸Ŀ���״̬��?'), function () {
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
                PHA.Popover({ showType: 'show', msg: $g('�޸Ŀ���״̬�ɹ�'), type: 'success' });
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('�޸Ŀ���״̬ʧ�ܣ� ��������') + retData.desc,
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
                    PHA.Popover({ showType: 'show', msg: $g('�޸�ȫ������״̬�ɹ�'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('�޸�ȫ������״̬ʧ�ܣ� ��������') + retData.desc,
                        type: 'alert',
                    });
            }
        );
}


function Updatei(objVal, CombRowID, Index, value) {
    //PHA.Confirm($g('��ʾ'), $g('��ȷ���޸Ŀ���״̬��?'), function () {
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
                    PHA.Popover({ showType: 'show', msg: $g('�޸Ŀ���״̬�ɹ�'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('�޸Ŀ���״̬ʧ�ܣ� ��������') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    //});
}

//��ʼ�����ϸ
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
                title: $g('ɾ��'),
                align: 'center',
                width: 50,
                formatter: deleteFormatteri,
            },
            { field: 'CombName', title: $g('���'), align: 'center', width: 60 },
            {
                field: 'activeFlag',
                title: $g('����״̬'),
                align: 'center',
                width: 80,
                formatter: statusFormatteri,
            },
            
            { field: 'CtrlLevel', title: $g('�ܿؼ���'), align: 'center', width: 70 },
            {
                field: 'combItmSign',
                title: $g('��'),
                align: 'center',
                width: 40,
                formatter: PIVAS.Grid.Formatter.OeoriSign,
            },
            { field: 'CombItmType', title: $g('����'), align: 'left', width: 80 },
            { field: 'CombItmTypeDesc', title: $g('ֵ'), align: 'left', width: 200 },
            { field: 'UseQty', title: $g('����������'), align: 'right', width: 80 },
            { field: 'limitQty', title: $g('����������'), align: 'right', width: 80 },
            { field: 'buomDesc', title: $g('��λ'), align: 'center', width: 60 },
            // QtyStartDate,QtyEndDate,ActiveStartDate,ActiveEndDate
            { field: 'QtyStartDate', 	title: $g('���Ŀ�ʼ����'), align: 'center', width: 95 },
            { field: 'QtyEndDate', 		title: $g('���Ľ�������'), align: 'center', width: 95 },
            { field: 'ActiveStartDate', title: $g('���ƿ�ʼ����'), align: 'center', width: 95 },
            { field: 'ActiveEndDate', 	title: $g('���ƽ�������'), align: 'center', width: 95 },
            { field: 'Prompt', 			title: $g('������Ϣ'),	   align: 'left', 	width: 150 },
            { field: 'AddDate', 		title: $g('�������'),	   align: 'left', 	width: 100 },
            { field: 'Remark', 			title: $g('��ע��Ϣ'),	   align: 'left', 	width: 150 },
            { field: 'UpdateDate', 		title: $g('��������'),	   align: 'left', 	width: 100 },
            { field: 'UpdateTime', 		title: $g('����ʱ��'),	   align: 'left', 	width: 100 },
            { field: 'UpdateUser', 		title: $g('������'),	   align: 'left', 	width: 100 }
            
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
    PHA.Confirm($g('��ʾ'), $g('��ȷ��ɾ��(') + CombName + ')?', function () {
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
                    PHA.Popover({ showType: 'show', msg: $g('ɾ���ɹ�!'), type: 'success' });
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('ɾ��ʧ��:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    });
}

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
    //ҽ����lookup
    var opts = $.extend({}, PHA_STORE.ArcItmMast('Y'), {
        width: lookUpWidth,
    });
    PHA.LookUp('inciArcim', opts);
    //����ͨ����lookup
    var opts = $.extend({}, PHA_STORE.PHCGeneric('Y'), {
        width: lookUpWidth,
    });
    PHA.LookUp('PHCGeneric', opts);

    //ҩ������
    PHA.ComboBox('cmbPhaLoc', {
        url: PHA_STORE.Pharmacy('').url,
    });
    //ҽ������
    PHA.ComboBox('cmbDocLoc', {
        url: PHA_STORE.DocLoc().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });

    //�������
    PHA.ComboBox('comAdmloc', {
        url: PHA_STORE.DocLoc().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //����
    PHA.ComboBox('comAdmward', {
        url: PHA_STORE.WardLoc().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //ҽ��ְ��
    PHA.ComboBox('comDoclevel', {
        url: PHA_STORE.PositionalTitles().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    // ָ��ҽ��
    PHA.ComboBox('comdoc', {
        url: PHA_STORE.Doctor().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //��������
    PHA.ComboBox('comAdmtype', {
        url: PHA_STORE.Admtype().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //�ѱ�
    PHA.ComboBox('comadmPayType', {
        url: PHA_STORE.PACAdmReason().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    //�Һ�ְ�� 
    PHA.ComboBox('comRegisteredType', {
        url: PHA_STORE.RegisteredType().url,
        multiple: 'multiple',
        width: ComBoxWidth,
    });
    comRegisteredType
    //�ܿؼ���
    PHA.ComboBox('comCtrlLevel', {
        url: PHA_STORE.CtrlLevel().url,
        width: ComBoxWidth,
        editable:false,
        panelHeight: 'auto'
    });
    /// ҽ�����ҽ����ģ������
    $('#TextCopyArc').searchbox({
	    searcher:function(value,name){
	    QueryArcCopy(value);
	    },
	    width:473,
	    prompt:$g('ҽ����ģ������...')
	});
	
	/// ����ͨ�������ƴ���ͨ����ģ������
    $('#TextCopyPhcg').searchbox({
	    searcher:function(value,name){
	    QueryPhcgCopy(value);
	    },
	    width:473,
	    prompt:$g('����ͨ����ģ������...')
    });
    
    $('#promptDiv').hide();

}
/// �ر����Ԥ������
function CloseTmpCombPanel() {
	$('.layout-button-left').trigger('click');	
}

/// ��ʾ���Ԥ������
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
        $g('ҽ������'),
        $g('�������'),
        $g('���ﲡ��'),
        $g('ҽ��ְ��'),
        $g('ָ��ҽ��'),
        $g('��������'),
        $g('���߷ѱ�'),
        $g('�Һ�ְ��'),
        $g('�ǼǺ�'),
        $g('��������'),
        $g('���Ŀ�ʼ'),
        $g('���Ľ���'),
        $g('���ƿ�ʼ'),
        $g('���ƽ���')
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
    //�����������
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
    //��֯���������������ʽ�洢
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

    var htmlStr = '<table>'; //���б���ʽ����
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
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��Ժ����'), type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��Ժ����'), type: 'alert' });
        return null;
    }
    var phaLocId = $('#cmbPhaLoc').combobox('getValue') || '';
    PHCGe = $('#PHCGeneric').lookup('getValue') || '';
    inputStr = HosID + '^' + phaLocId + '^' + PHCGe;
    $('#gridPhcGe').datagrid('query', {
        inputStr: inputStr,
    });
}

///����������ҩ���Ը�������ҽ����/����ͨ����
function Copy(){
	var HosID = $('#cmbHos').combobox('getValue') || '';
    if (HosID == '') {
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��Ժ����'), type: 'alert' });
        return null;
    }
    var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    var Rows = $('#gridCom').datagrid('getRows') || '';
    if (Rows.length == 0)
	{
		PHA.Popover({ showType: 'show', msg: $g('��ǰ���������Ϣ����Ϊ�գ�'), type: 'alert' });
        return "";
	}
    
    //var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
    if (tabId === 'tabPHCGeLable'){
	    var gridSelect = $('#gridPhcGe').datagrid('getSelected') || '';
	    if(!gridSelect) {
			PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ������ͨ������'), type: 'alert' });
        	return ""; 
	    }
        InitDiagPhcgCopy(HosID,Loc)
    }
    else if (tabId === 'tabArcLable'){
	    var gridSelect = $('#gridArc').datagrid('getSelected') || '';
	    if(!gridSelect) {
			PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��ҽ���'), type: 'alert' });
        	return ""; 
	    }
		InitDiagArcCopy(HosID,Loc)
    }
	else if (tabId === 'tabDrugPropLable')
	{
		PHA.Popover({ showType: 'show', msg: $g('ҩƷ���Բ�֧�ָ��ƹ��ܣ�'), type: 'alert' });
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
            { field: 'opre', title: '����', align: 'center', width: 50 , formatter:CopyFormatter},
            { field: 'arcimCode', title: '����', align: 'left', width: 130 },
            { field: 'arcimDesc', title: 'ҽ����', align: 'left', width: 280 },
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
            { field: 'opre', title: '����', align: 'center', width: 50 , formatter:CopyFormatter},
            { field: 'geneCode', title: '����', align: 'left', width: 130 },
            { field: 'geneName', title: '����ͨ����', align: 'left', width: 280 },
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
       "<a class=\"hisui-linkbutton\" data-options=\"iconCls:'icon-w-find'\" onclick=\"javascript:copyArc('"+arcimId+"','"+ geneId +"')\">" + $g('����') + "</a>"
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
                PHA.Popover({ showType: 'show', msg: $g('���Ƴɹ�'), type: 'success' });
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
                PHA.Popover({ showType: 'show',msg: $g('����ʧ�ܣ� ��������:') + retData.desc,type: 'alert',});
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
	    PHA.Popover({ showType: 'show', msg: $g('ҩƷ���Բ�֧�ָ��ƹ��ܣ�'), type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��Ժ����'), type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��Ժ����'), type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ��Ժ����'), type: 'alert' });
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
		PHA.Msg("alert","��ѡ��һ�����");
		return;
	}
	$('#diagUpdateCom')
    .dialog({
        iconCls: 'icon-w-edit',
        modal: true,
        onBeforeClose: function () {},
    })
    .dialog('open');
    //��ʼ���޸Ľ���ı��������ڽ������ʱ���ػ���
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
	//ҽ������
    PHA.ComboBox('upDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: ComBoxWidth,
    });

    //�������
    PHA.ComboBox('upAdmloc', {
        url: PHA_STORE.DocLoc().url,
        width: ComBoxWidth,
    });
    //����
    PHA.ComboBox('upAdmward', {
        url: PHA_STORE.WardLoc().url,
        width: ComBoxWidth,
    });
    //ҽ��ְ��
    PHA.ComboBox('upDoclevel', {
        url: PHA_STORE.PositionalTitles().url,
        width: ComBoxWidth,
    });
    // ָ��ҽ��
    PHA.ComboBox('updoc', {
        url: PHA_STORE.Doctor().url,
        width: ComBoxWidth,
    });
    //��������
    PHA.ComboBox('upAdmtype', {
        url: PHA_STORE.Admtype().url,
        width: ComBoxWidth,
    });

    //�ѱ�
    PHA.ComboBox('upadmPayType', {
        url: PHA_STORE.PACAdmReason().url,
        width: ComBoxWidth,
    });

    //�Һ�ְ��
    PHA.ComboBox('uprgisteredType', {
        url: PHA_STORE.RegisteredType().url,
        width: ComBoxWidth,
    });

    //�ܿؼ���
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

///��ʾ��������ʾ��Ϣ
function ShowUpPrompt(){
	var CtrlLevel = $('#upCtrlLevel').combobox('getValue') || '';
	if(CtrlLevel!="����"){
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
	            PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
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
        return '��ѡ��ܿؼ���';
    }
    //var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
    var tabId = $('#tabPrt').tabs('getSelected').panel('options').id;
    if (qty != '' && tabId != 'tabArcLable') {
        return 'ֻ��ҽ�������ά����������������ͨ����/ҩƷ���Բ�����ά������������';
    }
    if(CtrlLevel=="����"&&prompt==""){
        return '�ܿؼ���Ϊ����ʱ��ά��������Ϣ��';
    }
    
    if (qty != '' && CtrlLevel != '��ֹ' && CtrlLevel != '����' ) {
        return 'ά����������ʱ�ܿؼ������Ϊ��ֹ/����';
    }
    return "";
}