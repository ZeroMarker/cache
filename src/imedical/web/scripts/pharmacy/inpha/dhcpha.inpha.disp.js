/**
 * ģ��:		סԺҩ��
 * ��ģ��:	  	סԺҩ��-��ҩ
 * ��д����:	2016-09-02
 * ��д��:		yunhaibao
 */
DHCPHA_CONSTANT.VAR.TIMER = '';
DHCPHA_CONSTANT.VAR.TIMERSTEP = 30 * 1000;
DHCPHA_CONSTANT.VAR.SELECT = '';
DHCPHA_CONSTANT.VAR.DISPCATPID = tkMakeServerCall('web.DHCINPHA.Disp.Save', 'NewPid');
DHCPHA_CONSTANT.VAR.QUERYPID = '';
DHCPHA_CONSTANT.VAR.DISPCATARR = '';
DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE = '';
DHCPHA_CONSTANT.VAR.WARDIDSTR = '';
DHCPHA_CONSTANT.VAR.PARAMS = '';
DHCPHA_CONSTANT.VAR.MAC = '';
DHCPHA_CONSTANT.VAR.PRIORITY = '';
DHCPHA_CONSTANT.VAR.TAB = '#div-ward-condition'; // ��¼��ǰtab
DHCPHA_CONSTANT.VAR.DEFSELECTTYPE = []; // code1^code2
$(function () {
    InitPhaConfig(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    /* ��ʼ����� start*/
    var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
    InitPhaLoc(); //ҩ������
    InitPhaWard(); //����
    InitPhaLocGrp(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID); //������
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitDispType(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitGridDispWard();
    InitGridAdm();
    InitGridOrdTotal();
    InitGridOrdDetail();
    InitInDispTab(); //��ҳ��tab
    $('#monitor-condition').children().not('#div-ward-condition').hide();
    /* ��ʼ����� end*/
    /* ��Ԫ���¼� start*/
    //�ǼǺŻس��¼�
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patno = $.trim($('#txt-patno').val());
            if (patno != '') {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                QueryDispAdmList();
            }
        }
    });
    //�������лس��¼�
    $('input[type=text]').on('keypress', function (e) {
        if (window.event.keyCode == '13') {
            return false;
        }
    });
    /* ��Ԫ���¼� end*/

    /* �󶨰�ť�¼� start*/
    $('#a-change').on('click', ChangeDispQuery);
    $('#chk-timer').on('ifChanged', function () {
        if ($(this).is(':checked') == true) {
            DHCPHA_CONSTANT.VAR.TIMER = setInterval('QueryDispWardList();', DHCPHA_CONSTANT.VAR.TIMERSTEP);
        } else {
            clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
        }
    });
    $('#chk-localconfig').on('ifChanged', function () {
        SetLocalConfig();
    });
    $('#div-conditions input[type=checkbox]').each(function () {
        $(this).on('ifClicked', function () {
            if ($(this).is(':checked')) {
                //�������߼�...
                $(this).iCheck('uncheck'); //�����ѡ�񣬿�����iCheckȡ��ѡ��
            } else {
                $(this).iCheck('check'); //���ûѡ�񣬿�����iCheck����ѡ��
            }
            SetConditionCheck(this.id);
        });
    });
    $('#btn-find').on('click', QueryDispWardList);
    $('#btn-refuse').on('click', DoRefuse);
    $('#btn-disp').on('click', ConfirmDisp);
    $('#btn-finddetail').on('click', function () {
        KillDetailTmp();
        QueryInDispTotal('');
    });
    $('#btn-redir-return').on('click', function () {
        var lnk = 'dhcpha/dhcpha.inpha.returnbyreq.csp';
        websys_createWindow(lnk, '��ҩ', 'width=95%,height=75%');
        //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-30)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=90,left=3") ;
    });
    $('#btn-redir-dispquery').on('click', function () {
        var lnk = 'dhcpha/dhcpha.inpha.dispquery.csp';
        websys_createWindow(lnk, '�ѷ�ҩ��ѯ', 'width=95%,height=75%');
        //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-30)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=90,left=3,location=no") ;
    });
    /* �󶨰�ť�¼� end*/ InitRefuseReasonModal();
    InitBodyStyle();
    DHCPHA_CONSTANT.VAR.MAC = GetComputerValidMac();
});
window.onload = function () {
    setTimeout('QueryDispWardList()', 1000);
};
//��ʼ������ҩ���table
function InitGridDispWard() {
    var columns = getPhaLocDispType(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    var jqOptions = {
        colModel: columns, //��
        url: 'DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.Disp.Display&MethodName=JqGetDispWardCats',
        //url:DHCPHA_CONSTANT.URL.COMMON_INPHA_URL+'?action=QueryDispWardList&style=jqGrid', //��ѯ��̨
        height: DhcphaJqGridHeight(1, 1) - parseFloat($('#tab-ipmonitor').outerHeight()) - 10,
        multiselect: true,
        shrinkToFit: false,
        multiboxonly: false,
        datatype: 'local',
        rowNum: 9999,
        // pager: "#jqGridPager1", //��ҳ�ؼ���id
        onSelectAll: function () {
            QueryInDispTotal();
        },
        onSelectRow: function (id, status) {
            var id = $(this).jqGrid('getGridParam', 'selrow');
            KillDetailTmp();
            $('#grid-dispdetail').jqGrid('clearGridData');
            $('#grid-disptotal').jqGrid('clearGridData');
            if (id == null) {
                $('#grid-disptotal').clearJqGrid();
                $('#grid-dispdetail').clearJqGrid();
            } else {
                QueryInDispTotal();
            }
        },
        loadComplete: function () {
            $('#grid-wardlist input[type=checkbox]').each(function (index, el) {
                if (el.value != 'y' && el.value != 'on') {
                    //onΪǰ�߹�ѡ
                    el.disabled = true;
                }
                $(this).on('click', function () {
                    if (this.name == '') {
                        KillDetailTmp();
                        QueryInDispTotal('');
                    }
                });
            });
            var dispwardrowdata = $(this).jqGrid('getRowData');
            var dispwardgridrows = dispwardrowdata.length;
            //Ĭ�Ϸ�ҩ���
            var hasQT = '';
            if (dispwardgridrows > 0) {
                var dispWardColModel = $(this).jqGrid('getGridParam', 'colModel');
                for (var rowi = 1; rowi <= dispwardgridrows; rowi++) {
                    var rowidata = $(this).jqGrid('getRowData', rowi);
                    for (var coli = 1; coli < dispWardColModel.length; coli++) {
                        var tmpColObj = dispWardColModel[coli];
                        var tmpIndex = tmpColObj.index;
                        if (tmpIndex != 'TWardRowid' && tmpIndex != 'TWard') {
                            if (rowidata[tmpIndex] == 'Yes') {
                                if (DHCPHA_CONSTANT.VAR.PARAMS.split('^')[25] != 'Y') {
                                    $(this).setCell(rowi, tmpIndex, 'N');
                                }else{
									if (DHCPHA_CONSTANT.VAR.DEFSELECTTYPE.indexOf(tmpIndex)<0){
										$(this).setCell(rowi, tmpIndex, 'N');
									}			
								}
                                if (tmpIndex == 'QT') {
                                    // ����,Ĭ�ϲ���ѡ
                                    $(this).setCell(rowi, tmpIndex, 'N');
                                    hasQT = 'Y';
                                }
                            }
                        }
                    }
                }
            }
            if (hasQT == 'Y') {
                $('#grid-wardlist').setGridParam().showCol('QT');
            } else {
                $('#grid-wardlist').setGridParam().hideCol('QT');
            }
        }
    };
    $('#grid-wardlist').dhcphaJqGrid(jqOptions);
}
function getPhaLocDispType(phaLocId) {
    phaLocDispCat = '';
    var columns = new Array();
    var column = {
        name: 'TWardRowid',
        index: 'TWardRowid',
        header: 'TWardRowid',
        hidden: true
    };
    columns.push(column);
    column = {};
    column = {
        name: 'TWard',
        index: 'TWard',
        header: '����',
        align: 'left',
        width: 150
    };
    columns.push(column);
    column = {};
    var phaLocDispCat = '';
    var dispcatsstr = tkMakeServerCall('web.DHCSTPHALOC', 'GetPhaLocDispType', phaLocId);
    var dispcatsarr = dispcatsstr.split('^');
    var dispcatslength = dispcatsarr.length;
    var dispcatsi = 0;
    for (dispcatsi = 0; dispcatsi < dispcatslength; dispcatsi++) {
        column = {};
        var dispcatsdescarr = dispcatsarr[dispcatsi].split('@');
        var dispcatsdesc = dispcatsdescarr[1];
        if (dispcatsdesc == '') {
            continue;
        }
        var newdispcatdesc = dispcatsdesc.substring(0, 2) + '\t' + dispcatsdesc.substring(2, 4);
        if (dispcatsdesc.length > 4) {
            var newdispcatdesc = newdispcatdesc + '\t' + dispcatsdesc.substring(4, 6);
        }
        var dispcatscode = dispcatsdescarr[0];
        if (phaLocDispCat == '') {
            phaLocDispCat = dispcatscode;
        } else {
            phaLocDispCat = phaLocDispCat + '^' + dispcatscode;
        }
        column = {
            header: newdispcatdesc,
            index: dispcatscode,
            name: dispcatscode,
            width: 30,
            formatter: 'checkbox',
            //formatoptions: { value: "N:Disabled;Y:Enabled" },
            formatoptions: { disabled: false }
        };
        if (dispcatscode == 'QT') {
            column.hidden = false;
        }
        columns.push(column);
    }
    DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE = phaLocDispCat;
    return columns;
}

//��ʼ���˾���table
function InitGridAdm() {
    var columns = [
        { header: 'adm', index: 'Adm', name: 'Adm', width: 80, hidden: true },
        { header: '����', index: 'CurrWard', name: 'CurrWard', width: 120, align: 'left' },
        { header: '����', index: 'CurrentBed', name: 'CurrentBed', width: 60 },
        { header: '����ʱ��', index: 'AdmDate', name: 'AdmDate', width: 80 },
        { header: '�������', index: 'AdmLoc', name: 'AdmLoc', width: 120, hidden: true }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryDispAdmList&style=jqGrid', //��ѯ��̨
        height: DhcphaJqGridHeight(1, 1) - parseFloat($('#tab-ipmonitor').outerHeight()) - 10,
        multiselect: false,
        datatype: 'local',
        onSelectRow: function (id, status) {
            var id = $(this).jqGrid('getGridParam', 'selrow');
            if (id) {
                KillDetailTmp();
                QueryInDispTotal('');
            }
        }
    };
    $('#grid-admlist').dhcphaJqGrid(jqOptions);
}
//��ʼ����ҩ����table
function InitGridOrdTotal() {
    var columns = [
        { name: 'TPID', index: 'TPID', header: 'TPID', width: 150, align: 'left', hidden: true },
        { name: 'TCollStat', index: 'TCollStat', header: '״̬', width: 65, cellattr: addCollStatCellAttr },
        { name: 'TDesc', index: 'TDesc', header: 'ҩƷ����', width: 200, align: 'left', halign: 'left' },
        { name: 'TQty', name: 'TQty', header: '����', width: 60, align: 'right' },
        { name: 'TUom', name: 'TUom', header: '��λ', width: 60, align: 'left' },
        { name: 'TSp', name: 'TSp', header: '�ۼ�', width: 80, align: 'right' },
        { name: 'TAmt', name: 'TAmt', header: '���', width: 80, align: 'right' },
        { name: 'TQtyBed', name: 'TQtyBed', header: '����/����', width: 80, align: 'left' },
        { name: 'TBarcode', name: 'TBarcode', header: '���', width: 100, align: 'left' },
        { name: 'TManufacture', name: 'TManufacture', header: '����', width: 150, align: 'left' },
        { name: 'TDrugForm', name: 'TDrugForm', header: '����', width: 100, align: 'left' },
        { name: 'TIncstk', name: 'TIncstk', header: '��λ', width: 100, align: 'left' }
        //{name:"TGeneric",name:"TGeneric",header:'ͨ����',width:150,align:'left',hidden:true}
    ];
    var jqOptions = {
        colModel: columns, //��
        url: 'DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.Disp.Display&MethodName=JqGetDispTotal',
        //url:DHCPHA_CONSTANT.URL.COMMON_INPHA_URL+'?action=jsQueryInDisp&style=jqGrid&querytype=total', //��ѯ��̨
        height: DhcphaJqGridHeight(2, 1) - parseFloat($('#tab-ipmonitor').outerHeight()) - 40,
        multiselect: false,
        shrinkToFit: false,
        datatype: 'local',
        rowNum: 9999,
        // pager: "#jqGridPager", //��ҳ�ؼ���id
        onSelectRow: function (id, status) {},
        loadComplete: function () {
            if ($('#grid-disptotal').getGridParam('records') > 0) {
                var firstrowdata = $('#grid-disptotal').jqGrid('getRowData', 1);
                DHCPHA_CONSTANT.VAR.QUERYPID = firstrowdata.TPID;
            }
        }
    };
    $('#grid-disptotal').dhcphaJqGrid(jqOptions);
}
function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf('-') >= 0) {
        cellvalue = cellvalue.split('-')[1];
    }
    return cellvalue;
}
//��ʼ����ҩ��ϸtable
function InitGridOrdDetail() {
    var columns = [
        {
            name: 'TSelect',
            index: 'TSelect',
            header: '<a id="TDispSelect" href="#" onclick="SetSelectAll()">ȫ��</a>',
            width: 35,
            editable: true,
            align: 'center',
            edittype: 'checkbox',
            formatter: 'checkbox',
            formatoptions: { disabled: false }
        },
        { name: 'TPID', index: 'TPID', header: 'TPID', width: 180, hidden: true },
        { name: 'TCollStat', index: 'TCollStat', header: '״̬', width: 65, cellattr: addCollStatCellAttr, align: 'left' },
        { name: 'TAdmLoc', index: 'TAdmLoc', header: '����', width: 125, align: 'left' },
        { name: 'TBedNo', index: 'TBedNo', header: '����', width: 60, align: 'left' },
        { name: 'TUrgent', index: 'TUrgent', header: '�Ӽ�', width: 35, align: 'center', hidden: true },
        { name: 'TPaName', index: 'TPaName', header: '����', width: 80, align: 'left' },
        {
            name: 'TRegNo',
            index: 'TRegNo',
            header: '�ǼǺ�',
            width: 90,
            align: 'left',
            formatter: function (cellvalue, options, rowObject) {
                return '<a onclick="ViewSkinTestInfo()" style=\'text-decoration:underline;cursor:pointer;\'>' + cellvalue + '</a>';
            }
        },
        { name: 'TDesc', index: 'TDesc', header: 'ҩƷ����', width: 200, align: 'left' },
        { name: 'TQty', index: 'TQty', header: '����', width: 50, align: 'right' },
        { name: 'TUom', index: 'TUom', header: '��λ', width: 50, align: 'left' },
        { name: 'TDoseQty', index: 'TDoseQty', header: '����', width: 60, align: 'left' },
        { name: 'TFreq', index: 'TFreq', header: 'Ƶ��', width: 80, align: 'left' },
        { name: 'TInstruction', index: 'TInstruction', header: '�÷�', width: 80, align: 'left' },
        { name: 'TTimeAdd', index: 'TTimeAdd', header: '��ҩ����', width: 90, align: 'center' },
        { name: 'TTimeDosing', index: 'TTimeDosing', header: '�ַ�ʱ��', width: 125, align: 'left' },
        { name: 'TSalePrice', index: 'TSalePrice', header: '�ۼ�', width: 70, align: 'right' },
        { name: 'TAmt', index: 'TAmt', header: '���', width: 80, align: 'right' },
        { name: 'TDuration', index: 'TDuration', header: '�Ƴ�', width: 80, align: 'left' },
        { name: 'TBarcode', index: 'TBarcode', header: '���', width: 80, align: 'left' },
        { name: 'TManufacture', index: 'TManufacture', header: '������ҵ', width: 150, align: 'left' },
        { name: 'TGeneric', index: 'TGeneric', header: '����ͨ����', width: 150, align: 'left' },
        { name: 'TForm', index: 'TForm', header: '����', width: 100, align: 'left' },
        { name: 'TIncStk', index: 'TIncStk', header: '��λ', width: 100, align: 'left' },
        { name: 'TAge', index: 'TAge', header: '����', width: 60, align: 'left' },
        { name: 'Tsex', index: 'Tsex', header: '�Ա�', width: 60, align: 'left' },
        { name: 'TUserAdd', index: 'TUserAdd', header: '����ҽ��', width: 60, align: 'left', hidden: true },
        { name: 'TOrdStatus', index: 'TOrdStatus', header: 'ҽ��״̬', width: 65, align: 'center' },
        { name: 'TPhaCat', index: 'TPhaCat', header: '���ȼ�', width: 80, align: 'left' },
        { name: 'TDiagnose', index: 'TDiagnose', header: '���', width: 200, align: 'left',
			formatter: function(cellvalue, options, rowdata){
				return '<div style="white-space: nowrap;">'+cellvalue+'</div>';
			}	
		},
        { name: 'Taction', index: 'Taction', header: '��ע', width: 80, align: 'left' },
        { name: 'TAudited', index: 'TAudited', header: 'ҽ�����', width: 80, align: 'left' },
        { name: 'TPrescNo', index: 'TPrescNo', header: '������', width: 110, align: 'left' },
        { name: 'TEncryptLevel', index: 'TEncryptLevel', header: '�����ܼ�', width: 80, align: 'left' },
        { name: 'TPatLevel', index: 'TPatLevel', header: '���˼���', width: 80, align: 'left' },
        { name: 'Tcooktype', index: 'Tcooktype', header: '��ҩ��ʽ', width: 80, align: 'left', hidden: true },
        { name: 'Tseqno', index: 'Tseqno', header: 'ҽ������', width: 80, align: 'left' },
        { name: 'TInsuType', index: 'TInsuType', header: 'ҽ�����', width: 75, align: 'left' },
        { name: 'Tstr', index: 'Tstr', header: 'Tstr', width: 80, hidden: true },
        { name: 'TMainOrd', index: 'TMainOrd', header: 'TMainOrd', width: 80, hidden: true },
        { name: 'TDispIdStr', index: 'TDispIdStr', header: 'TDispIdStr', width: 80, hidden: true },
        { name: 'Toedis', index: 'Toedis', header: 'Toedis', width: 80, hidden: true },
        { name: 'TBatchNo', index: 'TBatchNo', header: '����', width: 80, hidden: true }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: 'DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.Disp.Display&MethodName=JqGetDispDetail',
        //url:DHCPHA_CONSTANT.URL.COMMON_INPHA_URL+'?action=jsQueryInDisp&querytype=detail&style=jqGrid', //��ѯ��̨
        height: DhcphaJqGridHeight(2, 2) - parseFloat($('#tab-ipmonitor').outerHeight()) - 48,
        multiselect: false,
        //multiboxonly:false,
        shrinkToFit: false,
        datatype: 'local',
        pager: '#jqGridPager1', //��ҳ�ؼ���id
        onSelectRow: function (id, status) {},
        loadComplete: function () {
            if ($('#grid-dispdetail').getGridParam('records') > 0) {
                var firstrowdata = $('#grid-dispdetail').jqGrid('getRowData', 1);
                DHCPHA_CONSTANT.VAR.QUERYPID = firstrowdata.TPID;
            }
            $('#grid-disptotal').clearJqGrid();
            $('#TDispSelect').text('ȫ��');
            AddjqGridCheckEvent();
        },
        onPaging: function (pgButton) {
            ReLoadAddPid();
        },
        gridComplete: function () {}
    };
    $('#grid-dispdetail').dhcphaJqGrid(jqOptions);
    $('#refresh_grid-dispdetail').hide(); //�˴�ˢ��������
}
function ViewSkinTestInfo() {
    $td = $(event.target).closest('td');
    var rowid = $td.closest('tr.jqgrow').attr('id');
    var selectdata = $('#grid-dispdetail').jqGrid('getRowData', rowid);
    var regNo = selectdata.TRegNo;
    var regNo = $.jgrid.stripHtml(regNo);
    ShowSkinTestWindow(regNo);
    /*
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.getskintest&RegNo="+regNo;
	websys_createWindow(lnk,"Ƥ�Լ�¼","width=95%,height=75%")
	window.open(lnk,"Ƥ�Լ�¼","height=300,width=400,menubar=no,status=yes,toolbar=no,resizable=yes,left=0,top=0") ;
	*/
}
function AddjqGridCheckEvent() {
    $('#grid-dispdetail input[type=checkbox]').each(function () {
        $(this).unbind(); //setrowdata��,click�¼�ʧЧ,ÿ�ζ���ȫ��
        $(this).on('click', function () {
            if (this.name == '') {
                $td = $(event.target).closest('td'); //֪���ĸ�Ԫ��,���ܶ�λ�ĸ�����
                var rowid = $td.closest('tr.jqgrow').attr('id');
                var selectdata = $('#grid-dispdetail').jqGrid('getRowData', rowid);
                Savetofitler(selectdata);
                SelectLinkOrder(selectdata);
            }
        });
    });
}
function SetSelectAll() {
    var tmpSelectFlag = '';
    if ($('#TDispSelect').text() == 'ȫѡ') {
        $('#TDispSelect').text('ȫ��');
        tmpSelectFlag = 'Y';
    } else {
        $('#TDispSelect').text('ȫѡ');
        tmpSelectFlag = 'N';
    }
    var selDspIdArr = [];
    var thisrecords = $('#grid-dispdetail').getGridParam('records');
    if (thisrecords > 0) {
        var ids = $('#grid-dispdetail').getDataIDs();
        for (var i = 0; i < ids.length; i++) {
            var rowData = $('#grid-dispdetail').jqGrid('getRowData', i + 1);
            var dspIdStr = rowData.TDispIdStr;
            selDspIdArr.push(dspIdStr);
            var newdata = {
                TSelect: tmpSelectFlag
            };
            $('#grid-dispdetail').jqGrid('setRowData', i + 1, newdata);
        }
        var tmpRowData = $('#grid-dispdetail').jqGrid('getRowData', 1);
        var pid = tmpRowData.TPID;
        var selDspIdStr = selDspIdArr.join('^');
        var selected = tmpSelectFlag == 'Y' ? 'D' : 'S';
        if (selDspIdStr != '') {
            tkMakeServerCall('web.DHCINPHA.Disp.Query', 'SaveToFilterMulti', pid, selDspIdStr, selected);
        }
    }

    AddjqGridCheckEvent();
}
function Savetofitler(selectrowdata) {
    //��ʱ���淢ҩʱû��ѡ���ҽ��Rowid
    var tdispstr = selectrowdata['TDispIdStr'];
    var tpid = selectrowdata['TPID'];
    var selected = selectrowdata['TSelect'];
    if (selected == 'Yes') {
        selected = 'D';
    } else {
        selected = 'S';
    }
    if (tpid != '' && tpid != undefined) {
        var saveret = tkMakeServerCall('web.DHCINPHA.Disp.Query', 'SaveToFilter', tpid, tdispstr, selected);
    }
}
//����ҽ��ѡ��
function SelectLinkOrder(selecteddata) {
    var tmpselect = selecteddata['TSelect'];
    var toedis = selecteddata['Toedis'];
    var orderlinkret = CheckOrderLink(toedis).split('%');
    var oeoricnt = orderlinkret[0];
    if (oeoricnt > 0) {
        var mainoeori = selecteddata['TMainOrd']; //��ҽ��id
        var dodisdate = selecteddata['TTimeAdd'];
        var mainindex = mainoeori + '^' + dodisdate;
        var quitflag = 0;
        var dispgridrows = $('#grid-dispdetail').getGridParam('records');
        for (var i = 1; i <= dispgridrows; i++) {
            var tmpselecteddata = $('#grid-dispdetail').jqGrid('getRowData', i);
            var tmpmainoeori = tmpselecteddata['TMainOrd'];
            var tmpdodisdate = tmpselecteddata['TTimeAdd'];
            var tmpmainindex = tmpmainoeori + '^' + tmpdodisdate;
            if (mainindex == tmpmainindex) {
                var newdata = {
                    TSelect: tmpselect
                };
                $('#grid-dispdetail').jqGrid('setRowData', i, newdata);
                //$("#grid-dispdetail").jqGrid('setCell',i,'TSelect',tmpselect,"",abc);
                var newselectdata = $('#grid-dispdetail').jqGrid('getRowData', i);
                Savetofitler(newselectdata);
                quitflag = 1;
            }
            if (quitflag == 1 && mainindex != tmpmainindex) {
                break;
            }
        }
    }
    AddjqGridCheckEvent();
}
//�ж��Ƿ�Ϊ����ҽ��
function CheckOrderLink(oedisstr) {
    var ret = tkMakeServerCall('web.DHCSTPCHCOLLS', 'CheckLinkOeord', oedisstr);
    return ret;
}

function ReLoadAddPid() {
    if ($('#grid-dispdetail').getGridParam('records') > 0) {
        var firstrowdata = $('#grid-dispdetail').jqGrid('getRowData', 1);
        var Pid = firstrowdata.TPID;
        $('#grid-dispdetail').setGridParam({
            datatype: 'json',
            page: 1,
            postData: {
                Pid: Pid
            }
        });
    }
}
function InitPhaLoc() {
    var selectoption = {
        minimumResultsForSearch: Infinity,
        allowClear: false,
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetStockPhlocDs&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID
    };
    $('#sel-phaloc').dhcphaSelect(selectoption);
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
    $('#sel-phaloc').append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        $('#sel-phalocgrp').empty();
        $('#sel-locinci').empty();
        InitPhaLocGrp($(this).val());
        InitThisLocInci($(this).val());
    });
}
function InitPhaWard() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetWardLocDs&style=select2',
        placeholder: '����...'
    };
    $('#sel-phaward').dhcphaSelect(selectoption);
}
function InitPhaLocGrp(locid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetLocGroupDs&style=select2&locId=' + locid,
        placeholder: '������...'
    };
    $('#sel-phalocgrp').dhcphaSelect(selectoption);
}
function InitPhaConfig(locRowId) {
    $.ajax({
        type: 'POST', //�ύ��ʽ post ����get
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetInPhaConfig&gLocId=' + locRowId, //�ύ������ �����ķ���
        data: '',
        success: function (value) {
            if (value != '') {
                SetPhaLocConfig(value);
            }
        },
        error: function () {
            alert('��ȡסԺҩ����������ʧ��!');
        }
    });
	DHCPHA_CONSTANT.VAR.DEFSELECTTYPE=tkMakeServerCall("web.DHCSTPHALOC","GetDefaultCatTypeStr",locRowId).split("^");
}
//����ҩ������
function SetPhaLocConfig(configstr) {
    DHCPHA_CONSTANT.VAR.PARAMS = configstr;
    var configarr = configstr.split('^');
    var startdate = configarr[2];
    var enddate = configarr[3];
    var notwardrequired = configarr[0];
    var auditneed = configarr[10];
    var retflag = configarr[11];
    var dispuserflag = configarr[17];
    var operaterflag = configarr[21];
    var aduitBillflag = configarr[22];
    var disptypelocalflag = configarr[23];
    var displayemyflag = configarr[24];
    var displayoutflag = configarr[25];
    var lsflag = configarr[26];
    var reqwardflag = configarr[27];
    var dispdefaultflag = configarr[28];
    var starttime = configarr[4];
    var endtime = configarr[5];
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    var timeReg = /^(([0-2][0-3])|([0-1][0-9])):[0-5][0-9]:[0-5][0-9]$/;
    if (!timeReg.test(starttime)) {
        starttime = '00:00:00';
    }
    if (!timeReg.test(endtime)) {
        endtime = '23:59:59';
    }
    $('#date-start')
        .data('daterangepicker')
        .setStartDate(startdate + ' ' + starttime);
    $('#date-start')
        .data('daterangepicker')
        .setEndDate(startdate + ' ' + starttime);
    $('#date-end')
        .data('daterangepicker')
        .setStartDate(enddate + ' ' + endtime);
    $('#date-end')
        .data('daterangepicker')
        .setEndDate(enddate + ' ' + endtime);
    if (retflag == 'Y') {
        $('#chk-reserve').iCheck('check');
    } else {
        $('#chk-reserve').iCheck('uncheck');
    }
    if (dispdefaultflag == '0') {
        $('#chk-shortord').iCheck('check');
    } else if (dispdefaultflag == '1') {
        $('#chk-longord').iCheck('check');
    } else {
        $('#chk-shortord').iCheck('uncheck');
        $('#chk-longord').iCheck('uncheck');
    }
    if (disptypelocalflag == 'Y') {
        $('#chk-localconfig').iCheck('check');
    }
    InitDispUserModal(DHCPHA_CONSTANT.VAR.PARAMS);
}

//��ѯ����ҩ����
function QueryDispWardList() {
    var startdatetime = $('#date-start').val();
    var enddatetime = $('#date-end').val();
    var startdate = startdatetime.split(' ')[0];
    var starttime = startdatetime.split(' ')[1];
    var enddate = enddatetime.split(' ')[0];
    var endtime = enddatetime.split(' ')[1];
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaLoc = '';
    }
    if (phaloc == '') {
        dhcphaMsgBox.alert('ҩ��������Ϊ��!');
        return;
    }
    var wardloc = $('#sel-phaward').val();
    if (wardloc == null) {
        wardloc = '';
    }
    var phalocgrp = $('#sel-phalocgrp').val();
    if (phalocgrp == null) {
        phalocgrp = '';
    }
    var priority = DHCPHA_CONSTANT.VAR.PRIORITY;
    var dispTypeStr = '';
    var dispTypeData = $('#sel-disptype').select2('data');
    if (dispTypeData != '') {
        for (var i = 0; i < dispTypeData.length; i++) {
            var dispType = dispTypeData[i].id;
            dispTypeStr = dispTypeStr == '' ? dispType : dispTypeStr + '^' + dispType;
        }
    }
    var params = startdate + '!!' + starttime + '!!' + enddate + '!!' + endtime + '!!' + phaloc + '!!' + wardloc + '!!' + phalocgrp + '!!' + priority + '!!' + dispTypeStr;
    $('#grid-wardlist')
        .setGridParam({
            datatype: 'json',
            page: 1,
            postData: {
                InputStr: params
            }
        })
        .trigger('reloadGrid');
    KillDetailTmp();
    $('#grid-disptotal').clearJqGrid();
    $('#grid-dispdetail').clearJqGrid();
}

//��ѯ�����¼
function QueryDispAdmList() {
    var patno = $('#txt-patno').val();
  	var phaloc = $('#sel-phaloc').val();
    var params = patno + '^DISP' + '^' + DHCPHA_CONSTANT.SESSION.GHOSP_ROWID;
    $('#grid-admlist')
        .setGridParam({
            datatype: 'json',
            page: 1,
            postData: {
                params: params
            }
        })
        .trigger('reloadGrid');
}

//��ѯ����ҩ�б�
function QueryInDispTotal(Pid) {
    if (Pid == undefined) {
        Pid = '';
    }
    if (Pid == '') {
        $('#grid-dispdetail').jqGrid('clearGridData');
        $('#grid-disptotal').jqGrid('clearGridData');
    }
    var params = GetQueryDispParams();
    if (params != '') {
        if ($('#div-detail').is(':hidden') == false) {
            $('#grid-dispdetail')
                .setGridParam({
                    datatype: 'json',
                    page: 1,
                    postData: {
                        InputStr: params,
                        Pid: Pid
                    }
                })
                .trigger('reloadGrid');
        } else {
            $('#grid-disptotal')
                .setGridParam({
                    datatype: 'json',
                    page: 1,
                    postData: {
                        InputStr: params,
                        Pid: Pid
                    }
                })
                .trigger('reloadGrid');
        }
    }
}
function GetQueryDispParams() {
    var pri = DHCPHA_CONSTANT.VAR.PRIORITY; //$("#priority").val();���Ʒ�ҩ���,20160905yunhaibao����
    var dispCats = '';
    (DHCPHA_CONSTANT.VAR.WARDIDSTR = ''), (adm = '');
    if (DHCPHA_CONSTANT.VAR.TAB == '#div-ward-condition') {
        var selectids = $('#grid-wardlist').jqGrid('getGridParam', 'selarrrow');
        if (selectids == '' || selectids == null) {
            //dhcphaMsgBox.alert("����ѡ����Ҫ��ҩ�Ĳ���!");
            $('#grid-disptotal').clearJqGrid();
            $('#grid-dispdetail').clearJqGrid();
            return '';
        }
        tkMakeServerCall('web.DHCINPHA.Disp.Global', 'KillSetTmpWardCats', DHCPHA_CONSTANT.VAR.DISPCATPID);
        $.each(selectids, function () {
            var selrowdata = $('#grid-wardlist').jqGrid('getRowData', this);
            var wardrowid = selrowdata.TWardRowid;
            if (DHCPHA_CONSTANT.VAR.WARDIDSTR == '') {
                DHCPHA_CONSTANT.VAR.WARDIDSTR = wardrowid;
            } else {
                DHCPHA_CONSTANT.VAR.WARDIDSTR = DHCPHA_CONSTANT.VAR.WARDIDSTR + '^' + wardrowid;
            }
            SaveCatList(selrowdata);
        });
        adm = '';
        dispCats = DHCPHA_CONSTANT.VAR.DISPCATARR + '#' + pri + '#' + DHCPHA_CONSTANT.VAR.DISPCATPID;
    } else if (DHCPHA_CONSTANT.VAR.TAB == '#div-patno-condition') {
        var selectid = $('#grid-admlist').jqGrid('getGridParam', 'selrow');
        if (selectid == '' || selectid == null) {
            dhcphaMsgBox.alert('����ѡ����Ҫ��ҩ�ľ����¼!');
            return '';
        }
        var selrowdata = $('#grid-admlist').jqGrid('getRowData', selectid);
        adm = selrowdata.Adm;
        DHCPHA_CONSTANT.VAR.WARDIDSTR = '';
        dispCats = DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE + '#' + pri;
    } else {
        dhcphaMsgBox.alert('��ˢ�½��������!');
        return '';
    }
    var startdatetime = $('#date-start').val();
    var enddatetime = $('#date-end').val();
    var startdate = startdatetime.split(' ')[0];
    var starttime = startdatetime.split(' ')[1];
    var enddate = enddatetime.split(' ')[0];
    var endtime = enddatetime.split(' ')[1];
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaloc = '';
    }
    if (phaloc == '') {
        dhcphaMsgBox.alert('ҩ��������Ϊ��!');
        return '';
    }
    var phalocgrp = $('#sel-phalocgrp').val();
    if (phalocgrp == null) {
        phalocgrp = '';
    }
    var incirowid = $('#sel-locinci').val();
    if (incirowid == null) {
        incirowid = '';
    }
    var ByWardFlag = '';
    var DoctorLocRowid = '';
    var NotAudit = '';
    var OutOrdFlag = 0,
        longOrdFlag = 0,
        shortOrdFlag = 0,
        isPackFlag = '',
        emOrdFlag = 'NOEmOrd',
        notifyOrd = '';
    if ($('#chk-outdrug').is(':checked')) {
        OutOrdFlag = 1;
    }
    if ($('#chk-longord').is(':checked')) {
        longOrdFlag = 1;
    }
    if ($('#chk-shortord').is(':checked')) {
        shortOrdFlag = 1;
    }
    if ($('#chk-pack').is(':checked')) {
        isPackFlag = 'ISPACK';
    }
    if ($('#chk-unpack').is(':checked')) {
        isPackFlag = 'NOPACK';
    }
    if ($('#chk-cyem').is(':checked')) {
        emOrdFlag = 'EmOrd';
    }
    if ($('#chk-notifyord').is(':checked')) {
        notifyOrd = 'Y';
    }

    var shortOrdFlagStr = shortOrdFlag + '||' + emOrdFlag + '||' + isPackFlag;
    var params =
        phaloc +
        '!!' +
        DHCPHA_CONSTANT.VAR.WARDIDSTR +
        '!!' +
        startdate +
        '!!' +
        enddate +
        '!!' +
        DHCPHA_CONSTANT.SESSION.GUSER_ROWID +
        '!!' +
        ByWardFlag +
        '!!' +
        longOrdFlag +
        '!!' +
        shortOrdFlagStr +
        '!!' +
        OutOrdFlag +
        '!!' +
        dispCats +
        '!!' +
        adm +
        '!!' +
        DoctorLocRowid +
        '!!' +
        NotAudit +
        '!!' +
        starttime +
        '!!' +
        endtime +
        '!!' +
        incirowid +
        '!!' +
        notifyOrd;
    return params;
}
// ��������
function SaveCatList(selecteddata) {
    var wardloc = selecteddata['TWardRowid'];
    var colModel = $('#grid-wardlist').jqGrid('getGridParam', 'colModel');
    var dispcatsstr = '';
    var collength = colModel.length;
    for (var columni = 0; columni < collength; columni++) {
        var colmodali = colModel[columni];
        var colnamei = colmodali.name;
        if (colnamei == 'TWardRowid' || colnamei == 'TWard' || colnamei == 'cb') {
            continue;
        }
        if (selecteddata[colnamei] == 'Yes') {
            if (dispcatsstr == '') {
                dispcatsstr = colnamei;
            } else {
                dispcatsstr = dispcatsstr + '^' + colnamei;
            }
        }
    }
    DHCPHA_CONSTANT.VAR.DISPCATARR = dispcatsstr;
    var savecatret = tkMakeServerCall('web.DHCINPHA.Disp.Query', 'SetTmpWardCats', wardloc, DHCPHA_CONSTANT.VAR.DISPCATARR, DHCPHA_CONSTANT.VAR.DISPCATPID);
}
//��ҩ
function ConfirmDisp() {
    if ($('#sp-title').text() == '��ҩ��ϸ') {
        if (DhcphaGridIsEmpty('#grid-dispdetail') == true) {
            return;
        }
    } else if ($('#sp-title').text() == '��ҩ����') {
        if (DhcphaGridIsEmpty('#grid-disptotal') == true) {
            return;
        }
    }
    if (DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE == '') {
        dhcphaMsgBox.alert('��ҩ���Ϊ��!');
        return;
    }
    dhcphaMsgBox.confirm('�Ƿ�ȷ�Ϸ�ҩ?', DoDisp);
}
function DoDisp(result) {
    $('[data-bb-handler]').attr('disabled', true);
    if (result == true) {
        $('.bootbox-body').text('���ڴ���ҩ...');
        var dispflag = '';
        //ȡ�Ƿ�¼�뷢ҩ������
        if (DHCPHA_CONSTANT.VAR.PARAMS != '') {
            var paramsarr = DHCPHA_CONSTANT.VAR.PARAMS.split('^');
            var dispuserflag = paramsarr[17];
            var operaterflag = paramsarr[21];
            if (dispuserflag == 'Y' || operaterflag == 'Y') {
                dispflag = 1;
                $('#modal-inphaphauser').modal('show');
            }
        }
        if (dispflag == '') {
            ExecuteDisp({});
        }
    }
}
function ExecuteDisp(dispoptions) {
    var pid = '';
    if ($('#sp-title').text() == '��ҩ��ϸ') {
        var firstrowdata = $('#grid-dispdetail').jqGrid('getRowData', 1);
        pid = firstrowdata.TPID;
    } else if ($('#sp-title').text() == '��ҩ����') {
        var firstrowdata = $('#grid-disptotal').jqGrid('getRowData', 1);
        pid = firstrowdata.TPID;
    }
    if (dispoptions.operateuser == undefined) {
        dispoptions.operateuser = '';
    }
    if (dispoptions.phauser == undefined) {
        dispoptions.phauser = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
    }
    var phaloc = $('#sel-phaloc').val();
    //�ж��Ƿ��ǰ��ǼǺŷ�ҩ,�����¼��ѡ���оͰ��ǼǺŷ�
    var admdispflag = '';
    if ($('#grid-admlist').getGridParam('records') > 0) {
        var admselrow = $('#grid-admlist').jqGrid('getGridParam', 'selrow');
        if (admselrow != '' && admselrow != null) {
            admdispflag = '1';
        }
    }

    //������ҩ
    catarr = DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE.split('^');
    var phacrowidStr = '';
    var wardArr = DHCPHA_CONSTANT.VAR.WARDIDSTR.split('^');
    // ���ǼǺŷ��Ż�ȡ����
    if (admdispflag != '') {
        var wardStr = tkMakeServerCall('web.DHCINPHA.Disp.Query', 'GetWardIdStrFromSaveSave', pid);
        if (wardStr == '') {
            dhcphaMsgBox.alert('���ǼǺŷ��Ż�ȡ��������');
            return;
        }
        wardArr = wardStr.toString().split('^');
    }
    for (var wardi = 0; wardi < wardArr.length; wardi++) {
        var wardid = wardArr[wardi];
        if (admdispflag == '') {
            var catstr = tkMakeServerCall('web.DHCINPHA.Disp.Query', 'GetTmpWardCats', DHCPHA_CONSTANT.VAR.DISPCATPID, wardid);
            catarr = catstr.split('^');
        }
        for (var cati = 0; cati < catarr.length; cati++) {
            var cat = catarr[cati];
            if (cat == '') {
                return;
            }
            var PhacRowid = SaveDispensing(cat, pid, phaloc, wardid, dispoptions.phauser, dispoptions.operateuser);

            if (PhacRowid > 0) {
                if (phacrowidStr != '') {
                    phacrowidStr = phacrowidStr + 'A' + PhacRowid;
                } else {
                    phacrowidStr = PhacRowid;
                }
            } else if (PhacRowid < 0) {
                alert('��ҩ���:' + GetDispCatNameByCode(cat) + ',' + PhacRowid);
            }
        }
    }
    if (phacrowidStr == '' || phacrowidStr == 0) {
        var cantDispInfo = tkMakeServerCall('web.DHCINPHA.Disp.Save', 'GetCantDispInfo', pid, 1);
        if (cantDispInfo == '') {
            dhcphaMsgBox.alert('δ����ҩƷ,�������ڷ�ҩ��ϸ�в����ԭ��');
        } else {
            dhcphaMsgBox.alert(cantDispInfo);
        }
        return;
    } else {
        tkMakeServerCall('web.DHCSTPCHCOLLS', 'GetCantDispInfo', pid, 0);
    }
    //�����Ժ��ҩ��
    if ($('#chk-outdrug').is(':checked')) {
        var pcods = tkMakeServerCall('web.DHCSTPCHCOLLOUT', 'CreateOutDrugRecords', phaloc, dispoptions.phauser, phacrowidStr);
    }
    //�����ҩ
    var resFlag = 'N';
    if ($('#chk-reserve').is(':checked')) {
        resFlag = 'Y';
    }
    var reserveret = tkMakeServerCall('web.DHCINPHA.Reserve', 'ExeResAfterDisp', phacrowidStr, DHCPHA_CONSTANT.SESSION.GUSER_ROWID, resFlag);
    //��ҩ��
    SendOrderToMachine(phacrowidStr);
    dhcphaMsgBox.confirm('�Ƿ��ӡ��', function (rtn) {
        $('[data-bb-handler]').attr('disabled', true);
        KillDetailTmp();
        if (rtn == true) {
            $('.bootbox-body').text('���ڴ�ӡ...');
            PrintReport(phacrowidStr, pid);
        }
        QueryDispWardList(); // ˢ����
    });
}

function SaveDispensing(dispcat, pid, phaLoc, wardid, colluser, operateuser) {
    if (colluser == '') {
        colluser = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
    }
    if (operateuser == '') {
        operateuser = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
    }
    var inputStr = phaLoc + '^' + wardid + '^' + dispcat + '^' + colluser + '^' + operateuser;
    var PhacRowid = tkMakeServerCall('web.DHCINPHA.Disp.Save', 'SaveData', pid, inputStr);
    //var PhacRowid=tkMakeServerCall("web.DHCSTPCHCOLLS","SAVEDATA","","",dispcat,pid,dispuser,operateuser,'',phaLoc,wardid) ;
    return PhacRowid;
}
//�ܾ���ҩ
function DoRefuse() {
    if ($('#sp-title').text() == '��ҩ����') {
        dhcphaMsgBox.alert('���л�����ҩ��ϸ���оܾ�!');
        return;
    }
    if (DhcphaGridIsEmpty('#grid-dispdetail') == true) {
        return;
    }
    var dispgridrows = $('#grid-dispdetail').getGridParam('records');
    var canrefuse = 0;
    for (var i = 1; i <= dispgridrows; i++) {
        var tmpselecteddata = $('#grid-dispdetail').jqGrid('getRowData', i);
        var tmpselect = tmpselecteddata['TSelect'];
        if (tmpselect != 'Yes') {
            continue;
        }
        canrefuse = 1;
        break;
    }
    if (canrefuse == 0) {
        dhcphaMsgBox.alert('��ѡ����Ҫ�ܾ���ҩ����ϸ!');
        return;
    }
    $('#modal-inpharefusedispreason').modal('show');
}
function ExecuteRefuse(refusereason) {
    var ordArr = new Array();
    var dispgridrows = $('#grid-dispdetail').getGridParam('records');
    for (var i = 1; i <= dispgridrows; i++) {
        var tmpselecteddata = $('#grid-dispdetail').jqGrid('getRowData', i);
        var tmpselect = tmpselecteddata['TSelect'];
        if (tmpselect != 'Yes') {
            continue;
        }
        var tmpdispidstr = tmpselecteddata['TDispIdStr'];
        if (!ordArr.contains(tmpdispidstr)) {
            ordArr.push(tmpdispidstr);
        }
    }
    tkMakeServerCall('web.DHCSTPCHCOLLS', 'InsertDrugRefuse', ordArr.join('^'), DHCPHA_CONSTANT.SESSION.GUSER_ROWID, refusereason);
    KillDetailTmp();
    QueryInDispTotal();
}
function InitInDispTab() {
    $('#tab-ipmonitor a').on('click', function () {
        var tabId = $(this).attr('id');
        var tmpTabId = '#div-' + tabId.split('-')[1] + '-condition';
        $(tmpTabId).show();
        $('#monitor-condition').children().not(tmpTabId).hide();
        DHCPHA_CONSTANT.VAR.TAB = tmpTabId;
        if (tabId != 'tab-patno') {
            $('#txt-patno').val('');
            if ($('#grid-admlist').getGridParam('records') > 0) {
                KillDetailTmp();
                $('#grid-admlist').clearJqGrid();
                $('#grid-disptotal').clearJqGrid();
                $('#grid-dispdetail').clearJqGrid();
                QueryInDispTotal('');
            }
        }
    });
}
//����ѡ
function SetConditionCheck(checkboxid) {
    if (checkboxid == 'chk-reserve') {
        return;
    }
    var boolchecked = '';
    if ($('#' + checkboxid).is(':checked')) {
        boolchecked = '1';
    }
    if (boolchecked == '1') {
        if (checkboxid == 'chk-outdrug') {
            $('#chk-longord').iCheck('uncheck');
            $('#chk-shortord').iCheck('uncheck');
        } else if (checkboxid == 'chk-longord') {
            $('#chk-outdrug').iCheck('uncheck');
            $('#chk-shortord').iCheck('uncheck');
        } else if (checkboxid == 'chk-shortord') {
            $('#chk-longord').iCheck('uncheck');
            $('#chk-outdrug').iCheck('uncheck');
        } else if (checkboxid == 'chk-pack') {
            $('#chk-unpack').iCheck('uncheck');
        } else if (checkboxid == 'chk-unpack') {
            $('#chk-pack').iCheck('uncheck');
        }
    } else {
        if (DHCPHA_CONSTANT.VAR.PARAMS.split('^')[26] == 'Y') {
            if (checkboxid == 'chk-longord' || checkboxid == 'chk-shortord') {
                if ($('#chk-longord').is(':checked') == false && $('#chk-shortord').is(':checked') == false && $('#chk-outdrug').is(':checked') == false) {
                    if (checkboxid == 'chk-longord') {
                        $('#chk-shortord').iCheck('check');
                    } else {
                        $('#chk-longord').iCheck('check');
                    }
                }
            }
        }
    }
    KillDetailTmp();
    QueryInDispTotal();
}

//��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: '#sel-locinci',
        locid: locrowid,
        width: '20em'
    };
    InitLocInci(locincioptions);
}
//��ʼ����ҩ���
function InitDispType(locrowid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetLocDispTypeDs&style=select2&locId=' + locrowid,
        allowClear: true,
        minimumResultsForSearch: Infinity,
        multiple: 'multiple',
        width: '935',
        placeholder: '��ҩ���...',
        closeOnSelect: false
    };
    $('#sel-disptype').dhcphaSelect(selectoption);
}
function ChangeDispQuery() {
    var Pid = '';
    if ($('#sp-title').text() == '��ҩ����') {
        $('#sp-title').text('��ҩ��ϸ');
        $('#div-total').hide();
        $('#div-detail').show();
        if ($('#grid-dispdetail').getGridParam('records') == 0) {
            if ($('#grid-disptotal').getGridParam('records') > 0) {
                var firstrowdata = $('#grid-disptotal').jqGrid('getRowData', 1);
                Pid = firstrowdata.TPID;
            }
            QueryInDispTotal(Pid);
        }
    } else {
        $('#sp-title').text('��ҩ����');
        $('#div-detail').hide();
        $('#div-total').show(); //ÿ�ε�����ܶ�Ҫ���»���
        if ($('#grid-dispdetail').getGridParam('records') > 0) {
            var firstrowdata = $('#grid-dispdetail').jqGrid('getRowData', 1);
            Pid = firstrowdata.TPID;
        }
        QueryInDispTotal(Pid);
    }
}

//���͵���ҩ��
function SendOrderToMachine(phacStr) {
    if (DHCPHA_CONSTANT.VAR.PARAMS != '') {
        var tmparr = DHCPHA_CONSTANT.VAR.PARAMS.split('^');
        var sendflag = tmparr[31];
        if (sendflag == 'Y') {
            phacArr = phacStr.split('A');
            var retString = '';
            for (var phaci = 0; phaci < phacArr.length; phaci++) {
                var phac = phacArr[phaci].split('B');
                var pharowid = phac[0];
                var sendret = tkMakeServerCall('web.DHCSTInterfacePH', 'SendOrderToMechine', pharowid);
                if (sendret != 0) {
                    var retString = sendret;
                    var senderr = 1;
                    if (senderr == '1') {
                        dhcphaMsgBox.alert('���Ͱ�ҩ��ʧ��,�������:' + retString, 'error');
                        return;
                    }
                }
            }
        }
    }
}
function GetDispCatNameByCode(catcode) {
    var dispcatname = tkMakeServerCall('web.DHCINPHA.InfoCommon', 'GetDispCatDescByCode', catcode);
    return dispcatname;
}

function PrintReport(phacstr, pid) {
    //PrintRep(phacstr,"",pid,"");
    var phacStr = phacstr.split('A').join('^');
    IPPRINTCOM.Print({
        phacStr: phacStr,
        otherStr: '',
        printType: '',
        reprintFlag: 'N',
        pid: pid
    });
}
//�ͻ�������ȡ���ȼ�
function SetLocalConfig() {
    var checkedflag = '';
    if ($('#chk-localconfig').is(':checked')) {
        if (DHCPHA_CONSTANT.VAR.MAC == '') {
            dhcphaMsgBox.alert('��ȡ����Mac��ַ,�����Ƿ��������վ��');
            return;
        }
        var phaloc = $('#sel-phaloc').val();
        var mac = '**' + DHCPHA_CONSTANT.VAR.MAC;
        var retval = tkMakeServerCall('web.DHCSTPHACONFIG', 'GetPhaLocConfigByLoc', phaloc, mac, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
        DHCPHA_CONSTANT.VAR.PRIORITY = retval;
    } else {
        DHCPHA_CONSTANT.VAR.PRIORITY = '';
    }
}

function InitRefuseReasonModal() {
    $('#modal-inpharefusedispreason').on('show.bs.modal', function () {
        var option = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetRefuseDispReason&style=select2',
            minimumResultsForSearch: Infinity,
            width: 200,
            allowClear: false
        };
        $('#sel-refusedispreason').dhcphaSelect(option);
        $('#sel-refusedispreason').empty();
    });
    $('#btn-refusereason-sure').on('click', function () {
        var refusereason = $('#sel-refusedispreason').val();
        if (refusereason == '' || refusereason == null) {
            dhcphaMsgBox.alert('��ѡ��ܾ���ҩԭ��!');
            return;
        }
        $('#modal-inpharefusedispreason').modal('hide');
        ExecuteRefuse(refusereason);
    });
}
//��ҩ��,��ҩ��ѡ��
function InitDispUserModal(params) {
    var paramsarr = params.split('^');
    var dispuserflag = paramsarr[17];
    var operaterflag = paramsarr[21];
    if (dispuserflag != 'Y') {
        $('#sel-phauser').closest('div').hide();
    }
    if (operaterflag != 'Y') {
        $('#sel-operateuser').closest('div').hide();
    }
    $('#modal-inphaphauser').on('show.bs.modal', function () {
        var option = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetInPhaUser&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + '&locId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
            //minimumResultsForSearch: Infinity,
            width: 200,
            allowClear: false
        };
        $('#sel-phauser').dhcphaSelect(option);
        $('#sel-phauser').empty();
        $('#sel-operateuser').dhcphaSelect(option);
        $('#sel-operateuser').empty();
    });
    $('#btn-phauser-sure').on('click', function () {
        var phauser = $('#sel-phauser').val();
        var operateuser = $('#sel-operateuser').val();
        if (dispuserflag == 'Y' && (phauser == '' || phauser == null)) {
            dhcphaMsgBox.alert('��ѡ��ҩ��!');
            return;
        }
        if (operaterflag == 'Y' && (operateuser == '' || operateuser == null)) {
            dhcphaMsgBox.alert('��ѡ���ҩ��!');
            return;
        }
        $('#modal-inphaphauser').modal('hide');
        var dispoptions = {
            phauser: phauser,
            operateuser: operateuser
        };
        ExecuteDisp(dispoptions);
    });
}
function InitBodyStyle() {
    $('#div-conditions').collapse('show');
    $('#div-conditions').on('hide.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - parseFloat($('#tab-ipmonitor').outerHeight()) - 40;
        tmpheight = tmpheight + $('#div-conditions').height();
        $('#grid-disptotal').setGridHeight(tmpheight);
    });
    $('#div-conditions').on('show.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - parseFloat($('#tab-ipmonitor').outerHeight()) - 40;
        $('#grid-disptotal').setGridHeight(tmpheight);
    });
    $('#grid-disptotal').setGridWidth(''); //yunhaibao20160906,��պ������ռ�,��֪��Ϊɶ
    $('#grid-dispdetail').setGridWidth('');
    $('#div-detail').hide();
    var wardtitleheight = $('#gview_grid-wardlist .ui-jqgrid-hbox').height();
    var wardheight = DhcphaJqGridHeight(1, 0) - parseFloat($('#tab-ipmonitor').outerHeight()) - wardtitleheight - 16;
    $('#grid-wardlist').setGridHeight(wardheight);
    $('#grid-wardlist').setGridWidth('');
}
function addCollStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val.indexOf('Ƿ��') >= 0) {
        return 'class=dhcpha-record-owefee';
    } else if (val.indexOf('��治��') >= 0) {
        return 'class=dhcpha-record-nostock';
    } else if (val.indexOf('��ֹ') >= 0) {
        return 'class=dhcpha-record-ordstop';
    } else {
        return '';
    }
}

function ShowSkinTestWindow(regNo) {
    var columns = [
        { header: 'ҽ������', index: 'Tarcimdesc', name: 'Tarcimdesc' },
        {
            header: 'Ƥ�Խ��',
            index: 'TskinTR',
            name: 'TskinTR',
            cellattr: function (rowId, val, rawObject, cm, rdata) {
                if (val.indexOf('��') >= 0) {
                    return " style='background-color:#ffe3e3;color:#ff3d2c;font-weight:bold;'";
                } else {
                    return '';
                }
            }
        },
        { header: '�ǼǺ�', index: 'TregNo', name: 'TregNo' }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=jsQuerySkinTest',
        height: '100%',
        autowidth: true,
        datatype: 'local'
    };
    $('#grid-skintest').dhcphaJqGrid(jqOptions);
    $('#modal-getskintest').on('shown.bs.modal', function () {
        $('#grid-skintest').setGridWidth($('#modal-getskintest .modal-body').width());
        $('#grid-skintest').HideJqGridScroll({ hideType: 'X' });
    });
    $('#grid-skintest')
        .setGridParam({
            datatype: 'json',
            page: 1,
            postData: {
                params: regNo
            }
        })
        .trigger('reloadGrid');
    $('#modal-getskintest').modal('show');
}
function KillDetailTmp() {
    var Pid = '';
    if ($('#sp-title').text() == '��ҩ����') {
        if ($('#grid-disptotal').getGridParam('records') > 0) {
            var firstrowdata = $('#grid-disptotal').jqGrid('getRowData', 1);
            Pid = firstrowdata.TPID;
        }
    } else {
        if ($('#grid-dispdetail').getGridParam('records') > 0) {
            var firstrowdata = $('#grid-dispdetail').jqGrid('getRowData', 1);
            Pid = firstrowdata.TPID;
        }
    }
    KillInDispTmp(Pid);
}
function KillInDispTmp(pid) {
    if (pid != '') {
        tkMakeServerCall('web.DHCINPHA.Disp.Global', 'KillQuerySave', pid);
    }
}
window.onbeforeunload = function () {
    // ɾ������ҩ����global
    tkMakeServerCall('web.DHCINPHA.Disp.Global', 'KillSetTmpWardCats', DHCPHA_CONSTANT.VAR.DISPCATPID);
    KillInDispTmp(DHCPHA_CONSTANT.VAR.QUERYPID);
};
