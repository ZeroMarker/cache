/**
 * ģ��:   �����������
 * ��д����: 2018-02-11
 * ��д��:   yunhaibao
 */
var PIVAS_OEAUDIT_NS = function () {
    var SessionLoc = session['LOGON.CTLOCID'];
    var SessionUser = session['LOGON.USERID'];
    var SessionGroup = session['LOGON.GROUPID'];
    var PivasWayCode = tkMakeServerCall('web.DHCSTPIVAS.Common', 'PivasWayCode');
    var FormulaId = '';
    var ChangeViewNum = 1;
    var PersonSameFields = '[field=patNo],[field=patName],[field=bedNo],[field=wardLocDesc],[field=exceedReasonDesc]';
    var SameRowsHanlder = PIVAS.Grid.SameRows('gridOrdItem', PersonSameFields);

    InitDict();
    InitGridWard();
    InitTreePat();
    InitGridOrdItem();
    InitTreeGridReason();
    $('#btnFind').on('click', function () {
        $('#gridWard').datagrid('clear');
        $('#treePat').tree('loadData', []);
        if (Get.CurTab() == 'pat') {
            QueryPat();
        } else {
            Query();
        }
    });
    $('#btnFindDetail').on('click', QueryDetail);
    $('#btnAuditOk').on('click', function () {
        // ���ͨ��
        AuditOk('SHTG');
    });
    $('#btnAuditNo').on('click', function () {
        // ��˾ܾ�
        AuditNoShow('SHJJ');
    });
    $('#btnPhaRemark').on('click', function () {
        // ҩʦ��ע
        AuditRemarkShow();
    });
    $('#btnWinAuditRemark').on('click', function () {
        AuditRemark();
    });
    $('#btnCancelAudit').on('click', CancelAudit);
    $('#btnAnalyPresc').on('click', AnalyPresc); //������ҩ
    $('#btnPrBroswer').on('click', PrbrowserHandeler);
    $('#txtPatNo').searchbox({
        prompt: $g('������ǼǺ�...'),
        width: 250,
        searcher: function () {
            var patNo = $('#txtPatNo').searchbox('getValue');
            patNo = PIVAS.FmtPatNo(patNo);
            $('#txtPatNo').searchbox('setValue', patNo);
            QueryPat();
        }
    });
    $('#btnAuditRecord').on('click', AuditRecordLog);
    $('#btnChangeView').on('click', ChangeView);
    $('#btnWinAuditNo').on('click', AuditNo);
    $('.pivas-full').on('click', function (e) {
        $(e.target).attr('src').indexOf('cancel') > 0 ? PIVAS.ExitFull() : PIVAS.FullScreen();
        $('.pivas-full').toggle();
    });
    $('.js-btn-toggle').on('click', function () {
        $('.js-btn-toggle').toggle();
        $(this)[0].id === 'btnCollapseAll' ? $('#treePat').tree('collapseAll') : $('#treePat').tree('expandAll');
    });
    //$("#btnMedTips").on("click", MedicineTips)
    InitPivasSettings();
    $('.dhcpha-win-mask').remove();

    function InitDict() {
        // ���״̬
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPassStat',
                Type: 'PassStat'
            },
            {
                editable: false
            }
        );
        $('#cmbPassStat').combobox('setValue', 1);
        // ��˽��
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPassResult',
                Type: 'PassResult'
            },
            {
                editable: false
            }
        );
        $('#cmbPassResult').combobox('setValue', '');
        // ��ʿ���
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbNurAudit',
                Type: 'NurseResult'
            },
            {
                editable: false
            }
        );
        $('#cmbNurAudit').combobox('setValue', 1);
        // ��Һ����
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPivaCat',
                Type: 'PivaCat'
            },
            {}
        );
        // ������
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbLocGrp',
                Type: 'LocGrp'
            },
            {}
        );
        // ����
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbWard',
                Type: 'Ward'
            },
            {}
        );
        // ҽ�����ȼ�
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPriority',
                Type: 'Priority'
            },
            {
                width: 150
            }
        );
        // ��������
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbWorkType',
                Type: 'PIVAWorkType'
            },
            {}
        );
        // ҩƷ
        PIVAS.ComboGrid.Init(
            {
                Id: 'cmgIncItm',
                Type: 'IncItm'
            },
            {
                width: 275
            }
        );
    }

    //��ʼ�������б�
    function InitGridWard() {
        //����columns
        var columns = [
            [
                {
                    field: 'select',
                    checkbox: true
                },
                {
                    field: 'ward',
                    title: 'ward',
                    hidden: true
                },
                {
                    field: 'wardDesc',
                    title: '����',
                    width: 200
                },
                {
                    field: 'cnt',
                    title: '�ϼ�',
                    width: 50,
                    align: 'right'
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            pagination: false,
            fitColumns: true,
            fit: true,
            rownumbers: false,
            columns: columns,
            queryOnSelect: false,
            toolbar: [],
            onClickRow: function (rowIndex, rowData) {
                CurWardID = rowData.ward;
                CurAdm = '';
            },
            singleSelect: false,
            selectOnCheck: true,
            checkOnSelect: true,
            onLoadSuccess: function (data) {
                $('#gridOrdItem').datagrid('clear');
                $(this).datagrid('uncheckAll');
                if (LoadInputStr !== '') {
                    if (data.total > 0) {
                        $(this).datagrid('checkAll');
                        $('#btnFindDetail').click();
                        LoadInputStr = '';
                    }
                }
            },
            onClickCell: function (rowIndex, field, value) {
                if (field == 'wardDesc') {
                    $(this).datagrid('options').queryOnSelect = true;
                }
            },
            onSelect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').queryOnSelect == true) {
                    $(this).datagrid('options').queryOnSelect = false;
                    QueryDetail();
                }
            },
            onUnselect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').queryOnSelect == true) {
                    $(this).datagrid('options').queryOnSelect = false;
                    QueryDetail();
                }
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridWard', dataGridOption);
    }

    function InitTreePat() {
        $('#treePat').tree({
            formatter: function (node) {
                if (node.children) {
                    return '<div style="line-height:35px;font-weight:bold">' + node.text + '</div>';
                } else {
                    var data = node.text;
                    var htmlArr = [];
                    htmlArr.push('<div style="line-height:35px;">');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:50px;overflow:hidden">' + '<span style="visibility:hidden">1</span>' + data.bedNo + '</div>');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:100px;padding-left:5px;overflow:hidden">' + data.patNo + '</div>');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:60px;padding-left:5px;overflow:hidden">' + data.patName + '</div>');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:40px;text-align:right;font-weight:bold">' + data.cnt + '</div>');
                    htmlArr.push('</div>');
                    return htmlArr.join('');
                }
            },
            lines: true,
            autoNodeHeight: true,
            onClick: function (node) {
                QueryDetail();
            },
            onLoadSuccess: function (node, data) {
                $('#btnCollapseAll').css('display') === 'none' ? $('#treePat').tree('collapseAll') : $('#treePat').tree('expandAll');

                if (data[0] != null) {
                    var firstNode = $('#treePat').tree('find', data[0].id);
                    var firstChildNode = $('#treePat').tree('getChildren', firstNode.target);
                    //debugger ;
                    $('#treePat').tree('select', firstChildNode[0].target);
                    QueryDetail();
                }

                /*
                var selectNode = $('#treePat').tree("getSelected");             
                if (selectNode != null){
                    $('#treePat').tree("select",selectNode.target)
                }
                */
            }
            //          onExpand:function(){
            //              var roots = $(this).tree('getRoots');
            //              if (roots.length > 0){
            //                  var flag = ''
            //                  roots.forEach(function(rowData){
            //                      if (rowData.state === 'open'){
            //                          flag = 'open'
            //                      }
            //                  })
            //                  if (flag === 'open' && $('#btnCollapseAll').css('display') === 'none'){
            //                      $('.js-btn-toggle').toggle();
            //                  }
            //              }
            //          }
        });
    }

    function QueryPat() {
        var pJson = Get.QueryParams();
        pJson.patNo = $('#txtPatNo').searchbox('getValue');
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                MethodName: 'GetPatTreeData',
                rows: 9999,
                page: 1,
                pJsonStr: JSON.stringify(pJson)
            },
            false
        );

        setTimeout(function () {
            $('#treePat').tree('loadData', rowsData);
        }, 100);
    }

    //��ʼ����ϸ�б�
    function InitGridOrdItem() {
        //����columns
        var columnspat = [
            [
                {
                    field: 'gridOrdItemSelect',
                    checkbox: true
                },
                {
                    field: 'msgId',
                    title: 'msgId',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'tipsType',
                    title: '����',
                    width: 45,
                    halign: 'left',
                    align: 'center',
                    hidden: false,
                    formatter: function (value, row, index) {
                        if (value == 'normal') {
                            // ���� #16BBA2
                            return '<img src = "../scripts/pharmacy/images/warning0.gif" style="width:15px">';
                            return '<img src = "../scripts/pharmacy/common/image/order-pass-ok.png" >';
                        } else if (value == 'warn') {
                            // ��ʾ #FF6356
                            return '<img src = "../scripts/pharmacy/images/warning1.gif" >';
                            return '<img src = "../scripts/pharmacy/common/image/order-pass-warn.png" >';
                        } else if (value == 'forbid') {
                            //���� black
                            return '<img src = "../scripts/pharmacy/images/warning2.gif" >';
                            return '<img src = "../scripts/pharmacy/common/image/order-pass-error.png" >';
                        }
                        return '';
                    }
                },
                {
                    field: 'warnInfo',
                    title: '����',
                    width: 100,
                    formatter: function (value, row, index) {
                        var retArr = [];
                        if (row.nurSeeDesc.indexOf('�ܾ�') >= 0) {
                            retArr.push('<div class="pivas-grid-div" style="color:white;">��ʿ�ܾ�</div>');
                        }
                        if (row.exceedReasonDesc !== '') {
                            retArr.push('<div class="pivas-grid-div" style="color:white;">' + '�г���ԭ��' + '</div>');
                        }
                        if (row.patSpec !== '') {
                            retArr.push('<div class="pivas-grid-div" style="color:white">' + '������Ⱥ' + '</div>');
                        }
                        if (retArr.length > 0) {
                        }
                        return retArr.join('');
                    },
                    styler: function (value, row, index) {
                        if (row.nurSeeDesc.indexOf('�ܾ�') >= 0) {
                            return 'background-color: #ff5252';
                        }
                        if (row.exceedReasonDesc !== '') {
                            return 'background-color: #ff5252';
                        }
                        if (row.patSpec !== '') {
                            return 'background-color: #ff793e';
                        }
                    }
                },
                {
                    field: 'passResultDesc',
                    title: '��˽��',
                    width: 75,
                    styler: function (value, row, index) {
	                    if (value == '' || typeof value == 'undefined' || value == null) {
		                    return '';
		                }
                        var passResult = row.passResult;

                        if (passResult == 'Y') {
                            return { class: 'pha-pivas-state-pass' };
                        } else if (passResult == 'N' || passResult == 'NY') {
                            return { class: 'pha-pivas-state-refuse' };
                        } else if (passResult == 'NA') {
                            return { class: 'pha-pivas-state-appleal' };
                        } else if (row.nurSeeDesc.indexOf('�ܾ�') >= 0) {
                            return { class: 'pha-pivas-state-refuse' };
                        }
                    }
                },
                {
                    field: 'phaOrdRemark',
                    title: 'ҩʦ��ע',
                    width: 100
                },
                {
                    field: 'bedNo',
                    title: '����',
                    width: 75
                },
                {
                    field: 'patNo',
                    title: '�ǼǺ�',
                    width: 100,
                    formatter: function (value, row, index) {
                        var qOpts = "{AdmId:'" + row.adm + "'}";
                        return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({modal:true},' + qOpts + ')">' + value + '</a>';
                    }
                },
                {
                    field: 'patName',
                    title: '����',
                    width: 75
                },
                {
                    field: 'pivaCatDesc',
                    title: '����',
                    width: 50,
                    align: 'center',
                    formatter: function (value, row, index) {
                        return '<a class="pha-grid-a">' + value + '</a>';
                    }
                },
                {
                    field: 'drugsArr',
                    title: 'ҩƷ��Ϣ',
                    width: 300,
                    formatter: PIVAS.Grid.Formatter.InciGroup
                },
                {
                    field: 'dosage',
                    title: '����',
                    width: 75,
                    align: 'right',
                    formatter: PIVAS.Grid.Formatter.DosageGroup
                },
                {
                    field: 'qtyUom',
                    title: '����',
                    width: 50,
                    align: 'right',
                    formatter: PIVAS.Grid.Formatter.QtyUomGroup
                },
                {
                    field: 'ordRemark',
                    title: 'ҽ����ע',
                    width: 75,
                    formatter: PIVAS.Grid.Formatter.OrdRemarkGroup
                },
                {
                    field: 'freqDesc',
                    title: 'Ƶ��',
                    width: 60
                },
                {
                    field: 'instrucDesc',
                    title: '�÷�',
                    width: 80
                },
                {
                    field: 'priDesc',
                    title: 'ҽ�����ȼ�',
                    width: 90,
                    align: 'center'
                },

                {
                    field: 'patSex',
                    title: '�Ա�',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'patAge',
                    title: '����',
                    width: 75,
                    hidden: true
                },
                {
                    field: 'patWeight',
                    title: '����',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'patHeight',
                    title: '���',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'diagDesc',
                    title: '���',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'exceedReasonDesc',
                    title: '�Ƴ̳���ԭ��',
                    width: 100,
                    hidden: false
                },
                {
                    field: 'patSpec',
                    title: '������Ⱥ',
                    width: 100,
                    hidden: false
                },
                {
                    field: 'doctorName',
                    title: 'ҽ��',
                    width: 80
                },
                {
                    field: 'oeoriDateTime',
                    title: '��ҽ��ʱ��',
                    width: 120
                },
                {
                    field: 'wardLocDesc',
                    title: '����',
                    width: 125
                },
                {
                    field: 'nurSeeDesc',
                    title: 'ҽ������',
                    width: 75
                },
                {
                    field: 'mOeori',
                    title: '��ҽ��',
                    width: 100,
                    hidden: false
                },
                {
                    field: 'adm',
                    title: '����',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'analysisData',
                    title: '�������',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'doseDate',
                    title: '��ҩ����',
                    width: 75,
                    hidden: true
                },
                {
                    field: 'dateMOeori',
                    title: '��ҽ��Id+����',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'wardPat',
                    title: '�������߷���',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'altCnt',
                    title: '�������߷���',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'nurSeeFlag',
                    title: 'ҽ������',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'passResultStat',
                    title: '���״̬',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'sameFlag',
                    title: 'sameFlag',
                    width: 70,
                    hidden: true,
                    styler: function (value, row, index) {
                        if (value === 'Y') {
                            return {
                                class: 'pivas-person-toggle'
                            };
                        }
                    }
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            fitColumns: false,
            singleSelect: false,
            selectOnCheck: false,
            checkOnSelect: false,
            rownumbers: false,
            nowrap: true,
            columns: columnspat,
            pageSize: 100,
            pageList: [100, 300, 500],
            pagination: true,
            toolbar: '#gridOrdItemBar',
            loadFilter: PIVAS.Grid.LoadFilter,
            onLoadSuccess: function () {
                var $grid = $(this);
                SameRowsHanlder.Hide();
                $grid.datagrid('loaded');
                $(this).datagrid('options').checking = '';
                $(this).datagrid('uncheckAll');
                $(this).datagrid('scrollTo', 0);
                GridOrdItemCellTip();
            },
            rowStyler: PIVAS.Grid.RowStyler.PersonAlt,
            onClickRow: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PIVAS.Grid.ClearSelections(this.id);
                $(this).datagrid('selectRow', rowIndex);
                SameRowsHanlder.ShowRow(rowIndex);
                $(this).datagrid('options').checking = '';
            },

            onCheck: function (rowIndex, rowData) {},
            onUncheck: function (rowIndex, rowData) {},
            onClickCell: function (rowIndex, field, value) {
                if (field == 'pivaCatDesc') {
                    if (FormulaId != '') {
                        var mOeori = $(this).datagrid('getRows')[rowIndex].mOeori;
                        PIVASPASSTPN.Init({
                            Params: mOeori + '^' + FormulaId,
                            Field: 'pivaCatDesc',
                            ClickField: field
                        });
                    } else {
                        $.messager.alert('��ʾ', $g('��ȡ�������ָ�깫ʽ</br>�������ָ�깫ʽ�鿴�Ƿ�ά����ʽ</br>���ڲ������ò鿴�Ƿ�ά����Ҫʹ�õ�ָ�깫ʽ'), 'warning');
                    }
                } else if (field == 'tipsType') {
                    PHA_PASS.PDSS.ShowMsg({
                        msgId: $(this).datagrid('getRows')[rowIndex].msgId
                    });
                }
            },
            onDblClickCell: function (rowIndex, field, value) {
                return;
                // ������
                if (field != 'incDesc') {
                    return;
                }
                var rowData = $(this).datagrid('getRows')[rowIndex];
                if (PIVAS.VAR.PASS == 'DHC') {
                    /// ����֪ʶ��˵�����д
                    var userInfo = SessionUser + '^' + SessionLoc + '^' + SessionGroup;
                    var incDesc = rowData.incDesc;
                    DHCSTPHCMPASS.MedicineTips({
                        Oeori: rowData.oeori,
                        UserInfo: userInfo,
                        IncDesc: incDesc
                    });
                }
            },
            groupField: 'wardPat',
            groupFormatter: function (value, rows) {
                var rowData = rows[0];
                // ���˻�����Ϣ / ҽ����Ϣ /
                var viewDiv = '';
                var patDiv = '';
                var ordDiv = '';
                var wardDiv = '';
                patDiv += '<div id="grpViewPat" class="grpViewPat" style="padding-left:0px">';
                patDiv += '<div >' + rowData.patNo + '</div>';
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.bedNo + '</div>';
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patName + '</div>';
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patSex + '</div>';
                if (rowData.patAge != '') {
                    patDiv += '<div>/</div>';
                    patDiv += '<div>' + rowData.patAge + '</div>';
                }
                if (rowData.patWeight != '') {
                    patDiv += '<div>/</div>';
                    patDiv += '<div>' + rowData.patWeight + '</div>';
                }
                if (rowData.patHeight != '') {
                    patDiv += '<div>/</div>';
                    patDiv += '<div>' + rowData.patHeight + '</div>';
                }
                patDiv += '</div>';
                wardDiv += '<div id="grpViewWard" class="grpViewWard">';
                wardDiv += '<div>' + rowData.wardLocDesc + '</div>';
                wardDiv += '</div>';
                viewDiv += '<div id="grpViewBase" class="grpViewBase">' + wardDiv + patDiv + '</div>';
                return viewDiv;
            }
        };
        PIVAS.Grid.Init('gridOrdItem', dataGridOption);
    }
    function LoadAuditReasonTree() {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                MethodName: 'GetAuditReasonTreeStore',
                Params: '',
                HospId: session['LOGON.HOSPID']
            },
            function (data) {
                $('#treeReason').tree('loadData', data);
            }
        );
    }
    function InitTreeGridReason() {
        $('#treeReason').tree({
            lines: true,
            autoNodeHeight: true,
            lines: true,
            checkbox: true,
            onSelect: function (node) {},
            onLoadSuccess: function (node, data) {}
        });
    }

    ///��ѯ
    function Query() {
        var pJson = Get.QueryParams();
        $('#gridWard').datagrid('options').url = $URL;
        $('#gridWard').datagrid('query', {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            QueryName: 'WardData',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999
        });
    }

    ///��ѯҽ��
    function QueryDetail() {
        var pJson = Get.QueryParams();
        var wardArr = Get.WardChecked();
        var adm = Get.AdmSelected();
        if (wardArr.length === 0 && adm === '') {
            $('#gridOrdItem').datagrid('clear');
            return;
        }
        pJson.wardStr = wardArr.join(',');
        pJson.adm = adm;

        var $grid = $('#gridOrdItem');
        PIVAS.Grid.PageHandler($grid);
        $grid.datagrid('loading');
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                QueryName: 'OrderData',
                pJsonStr: JSON.stringify(pJson),
                rows: 9999,
                page: 1
            },
            false
        );
        setTimeout(function () {
            $grid.datagrid('loadData', rowsData);
        }, 100);
    }

    /// �������ͨ��
    function AuditOk(passType) {
        var dateMOeoriStr = GetDateMainOeoriStr();
        if (dateMOeoriStr == '') {
            DetailAlert('SHTG');
            return;
        }
        PIVAS.Progress.Show({
            type: 'save',
            interval: 1000
        });
        $.m(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                MethodName: 'PivasPass',
                dateMOeoriStr: dateMOeoriStr,
                userId: SessionUser,
                passType: passType
            },
            function (passRet) {
                PIVAS.Progress.Close();
                var passRetArr = passRet.split('^');
                var passVal = passRetArr[0];
                var passInfo = passRetArr[1];
                if (passVal == 0) {
                } else {
                    $.messager.alert('��ʾ', passInfo, 'warning');
                    return;
                }
                QueryDetail();
            }
        );
    }

    /// ������˾ܾ�����
    function AuditNoShow(passType) {
        if (PivasWayCode == '') {
            $.messager.alert('��ʾ', $g('����ά���������ԭ��'), 'warning');
            return;
        }
        var dateMOeoriStr = GetDateMainOeoriStr();
        if (dateMOeoriStr == '') {
            DetailAlert('SHJJ');
            return;
        }
        $('#reasonSelectDiv')
            .window({
                title: $g('��˾ܾ�ԭ��ѡ��')
            })
            .dialog('open');
        LoadAuditReasonTree();
    }

    /// �ܾ�
    function AuditNo() {
        var winTitle = $('#reasonSelectDiv').panel('options').title;
        var passType = 'SHJJ';
        var checkedNodes = $('#treeReason').tree('getChecked');
        if (checkedNodes.length == 0) {
            $.messager.alert('��ʾ', $g('��ѡ��ԭ��'), 'warning');
            return '';
        }
        var reasonStr = '';
        for (var nI = 0; nI < checkedNodes.length; nI++) {
            var reasonId = checkedNodes[nI].id;
            if (reasonId == 0) {
                continue;
            }
            // ֻҪҶ�ӽڵ�
            if (checkedNodes[nI].isLeaf === 'Y') {
                reasonStr = reasonStr == '' ? reasonId : reasonStr + '!!' + reasonId;
            }
        }
        var reasonNotes = $('#txtReasonNotes').val();
        var reasonData = reasonStr + '|@|' + reasonNotes;
        var dateMOeoriStr = GetDateMainOeoriStr();
        // ͬ��,��������
        var passRet = tkMakeServerCall('web.DHCSTPIVAS.OeAudit', 'PivasPass', dateMOeoriStr, SessionUser, passType, reasonData);
        var passRetArr = passRet.split('^');
        var passVal = passRetArr[0];
        var passInfo = passRetArr[1];
        if (passVal == 0) {
            $('#reasonSelectDiv').dialog('close');
        } else {
            $.messager.alert('��ʾ', passInfo, 'warning');
            return;
        }
        QueryDetail();
        $('#txtReasonNotes').val('');
    }

    ///ȡ���������
    function CancelAudit() {
        var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked') || '';
        if (gridOrdItemChecked == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('�빴ѡ��Ҫȡ����˵ļ�¼'),
                type: 'alert'
            });
            return;
        }
        var dateMOeoriArr = [];
        for (var i = 0; i < gridOrdItemChecked.length; i++) {
            var checkedData = gridOrdItemChecked[i];
            var passResultStat = checkedData.passResultStat;

            if (passResultStat == '') {
                continue;
            }
            var dateMOeori = checkedData.dateMOeori;
            if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
                dateMOeoriArr.push(dateMOeori);
            }
        }
        var dateMOeoriStr = dateMOeoriArr.join('^');
        if (dateMOeoriStr == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('û����Ҫȡ����˵ļ�¼'),
                type: 'alert'
            });
            return;
        }
        var conditionHtml = $g('��ȷ��ȡ�����?');
        $.messager.confirm($g('��ܰ��ʾ'), conditionHtml, function (r) {
            if (r) {
                var cancelRet = tkMakeServerCall('web.DHCSTPIVAS.OeAudit', 'CancelPivasPassMulti', dateMOeoriStr, SessionUser);
                var cancelRetArr = cancelRet.toString().split('^');
                var cancelVal = cancelRetArr[0] || '';
                if (cancelVal == '-1') {
                    $.messager.alert('��ʾ', cancelRetArr[1], 'warning');
                }
                QueryDetail();
            }
        });
    }

    /// �������
    function PrbrowserHandeler() {
        var gridSelect = $('#gridOrdItem').datagrid('getSelected');
        if (gridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('����ѡ�м�¼'),
                type: 'alert'
            });
            return;
        }
        PIVAS.ViewEMRWindow({}, gridSelect.adm);
    }

    /// ��ȡѡ�����ҽ����
    function GetDateMainOeoriStr() {
        var dateMOeoriArr = [];
        var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
        for (var i = 0; i < gridOrdItemChecked.length; i++) {
            var checkedData = gridOrdItemChecked[i];
            var passResultStat = checkedData.passResultStat;
            // ��������ٴ���
            if (passResultStat != '') {
                continue;
            }
            var dateMOeori = checkedData.dateMOeori;
            if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
                dateMOeoriArr.push(dateMOeori);
            }
        }
        return dateMOeoriArr.join('^');
    }

    function ClearGrid() {}

    function AuditRecordLog() {
        var gridSelect = $('#gridOrdItem').datagrid('getSelected');
        if (gridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('����ѡ�м�¼'),
                type: 'alert'
            });
            return;
        }
        var dateMOeori = gridSelect.dateMOeori;
        PIVAS.AuditRecordWindow({
            dateMOeori: dateMOeori
        });
    }

    /// ��ʼ��Ĭ������
    function InitPivasSettings() {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Settings',
                MethodName: 'GetAppProp',
                userId: session['LOGON.USERID'],
                locId: session['LOGON.CTLOCID'],
                appCode: 'OeAudit'
            },
            function (jsonData) {
                $('#dateStart').datebox('setValue', jsonData.OrdStDate);
                $('#dateEnd').datebox('setValue', jsonData.OrdEdDate);
                PIVAS.VAR.PASS = jsonData.Pass;
                var FormulaDesc = jsonData.Formula;
                if (jsonData.MaxDrugCnt > 2) {
                    PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
                }

                FormulaId = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetDIIIdByDesc', FormulaDesc);
                if (jsonData.GroupView == 'Y') {
                    ChangeView();
                }
                if (PIVAS.VAR.PASS === 'DHC') {
                    PHA_UTIL.LoadJS(['../scripts/dhcnewpro/dhcckb/pdss.js'], function () {});
                }
            }
        );
    }

    function AnalyPresc() {
        if (PIVAS.VAR.PASS == 'DHC') {
            if ($('#gridOrdItem').datagrid('getRows').length === 0) {
                return;
            }
            $('#gridOrdItem').datagrid('loading');
            setTimeout(function () {
                PHA_PASS.PDSS.Analysis(
                    {
                        gridId: 'gridOrdItem',
                        mOeoriField: 'dateMOeori'
                    },
                    function (retData) {
                        for (var i = 0, length = retData.length; i < length; i++) {
                            var iData = retData[i];
                            $('#gridOrdItem').datagrid('updateRow', {
                                index: iData.index,
                                row: iData.row
                            });
                        }
                        $('#gridOrdItem').datagrid('loaded');
                        SameRowsHanlder.Hide();
                    }
                );
            }, 500);

            return;
            DHCSTPHCMPASS.PassAnalysis({
                GridId: 'gridOrdItem',
                MOeori: 'dateMOeori',
                GridType: 'EasyUI',
                Field: 'analysisResult',
                CallBack: GridOrdItemCellTip
            });
        } else if (PIVAS.VAR.PASS == 'DT') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('��ͨ�ӿ�δ����,����ϵ��ز�Ʒ����Խӿ�'),
                type: 'alert'
            });
            return;
            StartDaTongDll();
            DaTongPrescAnalyse();
        } else if (PIVAS.VAR.PASS == 'MK') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('�����ӿ�δ����,����ϵ��ز�Ʒ����Խӿ�'),
                type: 'alert'
            });
            return;
            MKPrescAnalyse();
        } else {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('�޴����ͺ�����ҩ�ӿ�,����ҩƷϵͳ����->��������->��Һ����->������ҩ����'),
                type: 'alert'
            });
            return;
        }
    }

    /// ��ϸ���celltip
    function GridOrdItemCellTip() {
        PIVAS.Grid.CellTip({
            TipArr: ['ordRemark']
        });
        PIVAS.Grid.CellTip({
            TipArr: ['patNo'],
            ClassName: 'web.DHCSTPIVAS.Common',
            MethodName: 'PatBasicInfoHtml',
            TdField: 'mOeori'
        });
        PIVAS.Grid.CellTip({
            TipArr: ['warnFlag'],
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            MethodName: 'WarnFlagInfoHtml',
            TdField: 'dateMOeori'
        });
    }

    function ChangeView() {
        var hsMethod = '';
        var showView = '';
        if (ChangeViewNum % 2 == 1) {
            hsMethod = 'hideColumn';
            showView = groupview;
        } else {
            hsMethod = 'showColumn';
            showView = $.fn.datagrid.defaults.view;
        }
        var gridOpts = $('#gridOrdItem').datagrid('options');
        $('#gridOrdItem').datagrid(hsMethod, 'patNo');
        $('#gridOrdItem').datagrid(hsMethod, 'patName');
        $('#gridOrdItem').datagrid(hsMethod, 'bedNo');
        $('#gridOrdItem').datagrid(hsMethod, 'wardLocDesc');
        $('#gridOrdItem').datagrid('options').view = showView;
        QueryDetail();
        ChangeViewNum++;
    }

    /// ��ϸ��ʾ,��Ӧͨ��\�ܾ�,��δ��ѡʱ����
    function DetailAlert(auditType) {
        var dateMOeoriArr = [];
        var shtgArr = [];
        var shjjArr = [];
        var hsjjArr = [];
        var hswclArr = [];
        var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
        for (var i = 0; i < gridOrdItemChecked.length; i++) {
            var checkedData = gridOrdItemChecked[i];
            var passResultStat = checkedData.passResultStat;
            var passResult = checkedData.passResult;
            var dateMOeori = checkedData.dateMOeori;
            var nurSeeFlag = checkedData.nurSeeFlag;
            var warnFlag = checkedData.warnFlag;
            // ��������ٴ���
            if (passResultStat == '') {
                if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
                    dateMOeoriArr.push(dateMOeori);
                }
            } else if (passResult == 'Y') {
                if (shtgArr.indexOf(dateMOeori) < 0) {
                    shtgArr.push(dateMOeori);
                }
            } else if (passResult == 'N' || passResult == 'NY') {
                if (shjjArr.indexOf(dateMOeori) < 0) {
                    shjjArr.push(dateMOeori);
                }
            }
            if (nurSeeFlag == 'N') {
                if (hsjjArr.indexOf(dateMOeori) < 0) {
                    hsjjArr.push(dateMOeori);
                }
            }
        }
        var msgInfo = $g('����ѡ���¼');
        if (auditType == 'SHTG') {
            if (shjjArr.length > 0) {
                msgInfo = $g('����ȡ�����');
            } else if (shtgArr.length > 0) {
                msgInfo = $g('��ѡ��ļ�¼�����ͨ��');
            }
        } else if (auditType == 'SHJJ') {
            if (shtgArr.length > 0) {
                msgInfo = $g('����ȡ�����');
            } else if (shjjArr.length > 0) {
                msgInfo = $g('��ѡ��ļ�¼����˾ܾ�');
            }
        }
        if (hsjjArr.length > 0) {
            msgInfo = $g('��ѡ��ļ�¼��Ҫ��ʿ�ȴ���ҽ��');
        }
        if (hswclArr.length > 0) {
            msgInfo = $g('��ѡ��ļ�¼��ʿ��δ����ҽ��');
        }
        DHCPHA_HUI_COM.Msg.popover({
            msg: msgInfo,
            type: 'alert'
        });
    }
    function AuditRemarkShow() {
        var gridSelect = $('#gridOrdItem').datagrid('getSelected');
        if (gridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('��ѡ����Ҫ��ע�ļ�¼'),
                type: 'alert'
            });
            return;
        }
        $('#phaMarkDiv').dialog('open');
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                MethodName: 'GetPivasRemark',
                dateMOeoriStr: gridSelect.dateMOeori
            },
            function (retData) {
                $('#conOrdRemark').val(retData.orderRemark || '');
                $('#conExeRemark').val(retData.executeRemark || '');
                $('#conLabelRemark').val(retData.labelRemark || '');
            }
        );
    }
    /// ��ע������,��ѡ����,�����ڹ�ѡ�����б�עĳһ��ҽ��
    function AuditRemark() {
        var gridSelect = $('#gridOrdItem').datagrid('getSelected');
        var rowIndex = $('#gridOrdItem').datagrid('getRows').indexOf(gridSelect);
        var dateMOeori = gridSelect.dateMOeori;
        var ordRemark = $('#conOrdRemark').val();
        var exeRemark = $('#conExeRemark').val();
        var labelRemark = $('#conLabelRemark').val();
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                MethodName: 'PivasRemark',
                dateMOeoriStr: dateMOeori,
                userId: SessionUser,
                ordRemark: ordRemark,
                exeRemark: exeRemark,
                labelRemark: labelRemark,
                dataType: 'text'
            },
            function (passRet) {
                var passRetArr = passRet.split('^');
                var passVal = passRetArr[0];
                var passInfo = passRetArr[1];
                if (passVal == 0) {
                    DHCPHA_HUI_COM.Msg.popover({
                        msg: $g('��ע�ɹ�'),
                        type: 'success'
                    });

                    var retRowData = $.cm(
                        {
                            ClassName: 'web.DHCSTPIVAS.OeAudit',
                            MethodName: 'GetRowData',
                            dateMOeori: dateMOeori
                        },
                        false
                    );
                    $('#gridOrdItem').datagrid('updateRow', {
                        index: rowIndex,
                        row: retRowData
                    });
                    $('#phaMarkDiv').dialog('close');
                } else {
                    $.messager.alert('��ʾ', passInfo, 'warning');
                }
            }
        );
    }
    var Get = {
        QueryParams: function () {
            var pJson = {};
            pJson.loc = SessionLoc;
            pJson.wardStr = $('#cmbWard').combobox('getValue') || '';
            pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || '';
            pJson.startDate = $('#dateStart').datebox('getValue') || '';
            pJson.endDate = $('#dateEnd').datebox('getValue') || '';
            pJson.cat = $('#cmbPivaCat').combobox('getValue') || '';
            pJson.workType = $('#cmbWorkType').combobox('getValue') || '';
            pJson.priority = $('#cmbPriority').combobox('getValue') || '';
            pJson.passStat = $('#cmbPassStat').combobox('getValue') || '';
            pJson.passResult = $('#cmbPassResult').combobox('getValue') || '';
            pJson.inci = $('#cmgIncItm').combogrid('getValue') || '';
            pJson.nurAudit = $('#cmbNurAudit').combobox('getValue') || '';
            pJson.phaMark = $('#chkPhaMark').checkbox('getValue') === true ? 'Y' : '';
            return pJson;
        },
        CurTab: function () {
            var tabID = $('#tabsOne').tabs('getSelected').panel('options').id;
            return tabID === 'tabWard' ? 'ward' : 'pat';
        },
        WardChecked: function () {
            var retArr = [];
            if (this.CurTab() === 'pat') {
                return retArr;
            }
            var gridChecked = $('#gridWard').datagrid('getChecked');
            for (var i = 0; i < gridChecked.length; i++) {
                retArr.push(gridChecked[i].ward);
            }
            return retArr;
        },
        AdmSelected: function () {
            var adm = '';
            if (this.CurTab() === 'ward') {
                return adm;
            }
            var treeSel = $('#treePat').tree('getSelected');
            if (treeSel === null) {
                return adm;
            }
            adm = treeSel.text.adm || '';
            return adm;
        },
        PogChecked: function () {
            var retArr = [];
            var origRows = $('#gridOrdExe').datagrid('getData').originalRows;
            if (typeof origRows === 'undefined') {
                return retArr;
            }
            var len = origRows.length;
            for (var i = 0; i < len; i++) {
                var rowData = origRows[i];
                if (rowData.check === 'Y') {
                    retArr.push(origRows[i].pog);
                }
            }
            return retArr;
        }
    };
    // ���ҩѧ��ҳ�Ĵ���
    if (LoadInputStr !== '') {
        setTimeout(function () {
            var LoadInputArr = LoadInputStr.split('#');
            $('#dateStart').datebox('setValue', PIVAS.GetDate(LoadInputArr[0]));
            $('#dateEnd').datebox('setValue', PIVAS.GetDate(LoadInputArr[1]));
            $('#cmbPassStat').combobox('setValue', 3);
            $('#btnFind').click();
        }, 500);
    }
    // �����Ϣ���ڵĴ���
    if (LoadPatNo != '') {
        $('#tabsOne').tabs('select', 1);
        setTimeout(function () {
            InitParams();
            $('#txtPatNo').searchbox('setValue', LoadPatNo);
            QueryPat();
        }, 1000);
    }
    function InitParams() {
        if (LoadOrdItmId == '') {
            return;
        }
        var retVal = tkMakeServerCall('PHA.COM.Method', 'GetOrdItmInfoForTipMess', LoadOrdItmId);
        if (retVal != '{}') {
            var retJson = JSON.parse(retVal);
            var ordDate = retJson.ordDate;
            $('#dateStart').datebox('setValue', ordDate);
        }
    }
};
$(PIVAS_OEAUDIT_NS);