/**
 * ����:	 סԺ�ƶ�ҩ��-ȡҩ��ҩ
 * ��д��:	 yunhaibao
 * ��д����: 2020-04-29
 */
var OPERATEUSERID = ""
 $(function () {
    PHA_IP_DRAWDISP_NS();
});
var PHA_IP_DRAWDISP_NS = function () {
    // �ռ����
    var PHA_IP_DRAWDISP = {
        WardFlag: (session['LOGON.WARDID'] || '') != '' ? 'Y' : 'N',
        DefaultData: [
            {
                conStartDate: 't',
                conEndDate: 't',
                conPhaLoc: (session['LOGON.WARDID'] || '') != '' ? '' : session['LOGON.CTLOCID']
            }
        ],
        RowStyler: function (rowIndex, rowData) {
            var needDispQty = rowData.needDispQty;
            var realDispQty = rowData.realDispQty;
            if (needDispQty > realDispQty) {
                return 'background-color:#FFE0EA';
            } else if (needDispQty < realDispQty) {
                return 'background-color:#C8F6F1';
            }
        }
    };

    // ��ʼ��
    InitDict();
    InitGridDraw();
    InitGridDrawInc();
    InitGridDrawOrder();

    // �¼�
    $('#btnFind').on('click', QueryDraw);
    $('#btnClean').on('click', Clean);
    $('#conUser').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            SetConUser();
        }
    });
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
        }
    });
    
    $('#btnDisp').on('click', DispHandler)

    PHA.SetVals(PHA_IP_DRAWDISP.DefaultData);

    // ����
    function InitDict() {
        PHA.ComboBox('conPhaLoc', {
            url: PHA_STORE.Pharmacy('IP').url,
            panelHeight: 'auto',
            onLoadSuccess: function (data) {
                if (PHA_IP_DRAWDISP.WardFlag != 'Y') {
                    $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
                }
            },
            onSelect: function () {}
        });
        PHA.ComboBox('conWardLoc', {
            url: PHA_STORE.WardLoc().url
        });
    }
    function InitGridDraw() {
        var columns = [
            [
                {
                    field: 'phdw',
                    title: '��ҩ��ID',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'wardLoc',
                    title: '����ID',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'wardLocDesc',
                    title: '����',
                    width: 150,
                    formatter: function (value, row, index) {
                        return '<div style="overflow:hidden;white-space: normal;">' + value + '</div>';
                    }
                },
                {
                    field: 'phdwNo',
                    title: '��ҩ����',
                    width: 150
                },
                {
                    field: 'completeDateTime',
                    title: '��ҩʱ��',
                    width: 155
                },
                {
                    field: 'completeUserName',
                    title: '��ҩ��',
                    width: 100
                },
                {
                    field: 'connectNo',
                    title: '��������',
                    width: 150
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            pagination: false,
            columns: columns,
            fitColumns: false,
            toolbar: '#gridDrawBar',
            onSelect: function (rowIndex, rowData) {
                QueryDrawInc();
                QueryDrawOrder();
            },
            onLoadSuccess: function () {
                $('#gridDrawInc').datagrid('clear');
                $('#gridDrawOrder').datagrid('clear');
            }
        };
        PHA.Grid('gridDraw', dataGridOption);
    }

    function InitGridDrawInc() {
        var columns = [
            [
//                {
//                    field: 'status',
//                    title: '״̬',
//                    width: 100
//                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
                    width: 250,
                    formatter: function (value, row, index) {
                        return '<div class="phaip-grid-cell-wrap">' + value + '</div>';
                    }
                },
                {
                    field: 'realDispQty',
                    title: 'ʵ��',
                    align: 'center',
                    width: 60
                },
                {
                    field: 'reqQty',
                    title: '����',
                    align: 'center',
                    width: 60
                },
                {
                    field: 'drawQty',
                    title: '��ҩ',
                    align: 'center',
                    width: 60
                },
                {
                    field: 'refQty',
                    title: '�ܾ�',
                    align: 'center',
                    width: 60
                },
                {
                    field: 'cancelQty',
                    title: '����',
                    align: 'center',
                    width: 60,
                    hidden: true
                },
                {
                    field: 'backQty',
                    title: '����',
                    align: 'center',
                    width: 60,
                    hidden: true
                },
                {
                    field: 'spec',
                    title: '���',
                    width: 70
                },
                {
                    field: 'manfDesc',
                    title: '������ҵ',
                    width: 150
                },
                {
                    field: 'stkBinDesc',
                    title: '��λ',
                    width: 140
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            pagination: false,
            columns: columns,
            fitColumns: false
        };
        PHA.Grid('gridDrawInc', dataGridOption);
    }
    function InitGridDrawOrder() {
        var columns = [
            [
//                {
//                    field: 'status',
//                    title: '״̬',
//                    width: 100
//                },
                {
                    field: 'docLocDesc',
                    title: '��������',
                    width: 100
                },
                {
                    field: 'bedNo',
                    title: '����',
                    width: 60
                },
                {
                    field: 'patNo',
                    title: '�ǼǺ�',
                    width: 100
                },
                {
                    field: 'patName',
                    title: '����',
                    width: 100
                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
                    width: 250,
                    formatter: function (value, row, index) {
                        return '<div class="phaip-grid-cell-wrap">' + value + '</div>';
                    }
                },
                {
                    field: 'realDispQty',
                    title: 'ʵ��',
                    align: 'center',
                    width: 60
                },
                {
                    field: 'reqQty',
                    title: '����',
                    align: 'center',
                    width: 60
                },
                {
                    field: 'drawQty',
                    title: '��ҩ',
                    align: 'center',
                    width: 60
                },
                {
                    field: 'refQty',
                    title: '�ܾ�',
                    align: 'center',
                    width: 60
                },
                {
                    field: 'cancelQty',
                    title: '����',
                    align: 'center',
                    width: 60,
                    hidden: true
                },
                {
                    field: 'backQty',
                    title: '����',
                    align: 'center',
                    width: 60,
                    hidden: true
                },
                {
                    field: 'uomDesc',
                    title: '��λ',
                    width: 60
                },
                {
                    field: 'dosage',
                    title: '����',
                    width: 100
                },
                {
                    field: 'freqDesc',
                    title: 'Ƶ��',
                    width: 60
                },
                {
                    field: 'instruDesc',
                    title: '�÷�',
                    width: 100
                },
                {
                    field: 'doseDateTime',
                    title: '��ҩʱ��',
                    width: 155
                },
                {
                    field: 'spec',
                    title: '���',
                    width: 70
                },
                {
                    field: 'manfDesc',
                    title: '������ҵ',
                    width: 150,
                    formatter: function (value, row, index) {
                        return '<div class="phaip-grid-cell-wrap">' + value + '</div>';
                    }
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            pagination: true,
            columns: columns,
            fitColumns: false,
            pageSize: 100,
            pageList: [100, 300, 500]
        };
        PHA.Grid('gridDrawOrder', dataGridOption);
    }

    function QueryDraw() {
        var pJson = GetQueryParamsJson();
        if (pJson.loc === '') {
            PHA.Popover({
                msg: '��ѡ��ҩ��',
                type: 'alert'
            });
            return;
        }

        $('#gridDraw').datagrid('options').url = $URL;
        $('#gridDraw').datagrid('query', {
            ClassName: 'PHA.IP.DrawDisp.Query',
            QueryName: 'PHDraw',
            pJsonStr: JSON.stringify(pJson),
            rows: 999
        });
    }

    // ��ѯ������JSON
    function GetQueryParamsJson() {
        var retJson = {
            wardLoc: $('#conWardLoc').combobox('getValue') || '',
            loc: $('#conPhaLoc').combobox('getValue') || '',
            startDate: $('#conStartDate').datebox('getValue') || '',
            endDate: $('#conEndDate').datebox('getValue') || '',
            startTime: $('#conStartTime').timespinner('getValue') || '',
            endTime: $('#conEndTime').timespinner('getValue') || '',
            connectNo: $('#conConnectNo').val().trim(),
            patNo: '',
            drawNo: $('#conDrawNo').val().trim()
        };
        return retJson;
    }

    function QueryDrawInc() {
        var gridSel = $('#gridDraw').datagrid('getSelected');
        if (gridSel === null) {
            $('#gridDrawInc').datagrid('clear');
            $('#gridDrawOrder').datagrid('clear');
            return;
        }
        var pJson = {
            phdwStr: gridSel.phdw
        };
        $('#gridDrawInc').datagrid('options').url = $URL;
        $('#gridDrawInc').datagrid('query', {
            ClassName: 'PHA.IP.DrawDisp.Query',
            QueryName: 'PHDrawInc',
            pJsonStr: JSON.stringify(pJson),
            rows: 999
        });
    }
    function QueryDrawOrder() {
        var gridSel = $('#gridDraw').datagrid('getSelected');
        if (gridSel === null) {
            $('#gridDrawInc').datagrid('clear');
            $('#gridDrawOrder').datagrid('clear');
            return;
        }
        var pJson = {
            phdwStr: gridSel.phdw
        };
        $('#gridDrawOrder').datagrid('options').url = $URL;
        $('#gridDrawOrder').datagrid('query', {
            ClassName: 'PHA.IP.DrawDisp.Query',
            QueryName: 'PHDrawOrder',
            pJsonStr: JSON.stringify(pJson)
        });
    }
    function SetConUser() {
        var userCode = $('#conUser').val();
        if (userCode === '') {
            $('#conUserName,#conUserLoc').val('');
            OPERATEUSERID = ""
            return;
        }

        var retJson = $.cm(
            {
                ClassName: 'PHA.IP.COM.Method',
                MethodName: 'GetUserDataByCode',
                userCode: userCode,
                hosp: session['LOGON.HOSPID']
            },
            false
        );
        var userName = retJson.userName || '';
        if ((userName === "")||(userName.length <= 0)) {
            PHA.Popover({
                msg: '���Ĺ�������,���ʵ����������',
                type: 'alert'
            });
        }
        $('#conUserName').val(userName);
        var userId = retJson.user || '';
        OPERATEUSERID = userId
    }

    function Clean() {
        PHA.DomData('.js-con-data', {
            doType: 'clear'
        });
        $('#conUser').val('');
        $('#conUserName').val('');
        OPERATEUSERID = "";
        $('#gridDraw,#gridDrawOrder,#gridDrawInc').datagrid('clear');
        PHA.SetVals(PHA_IP_DRAWDISP.DefaultData);
    }
	function DispHandler() {
	    var gridSel = $('#gridDraw').datagrid('getSelected');
	    if (gridSel === null) {
	        PHA.Popover({
	            msg: '����ѡ����Ҫ��ҩ�ļ�¼',
	            type: 'alert'
	        });
	        return;
	    }
        if (OPERATEUSERID === '') {
            PHA.Popover({
	            msg: '����¼����ҩ�˹���',
	            type: 'alert'
	        });
	        return;
        }

	    var pJson = {
	        phdw: gridSel.phdw,
	        user: OPERATEUSERID     // session['LOGON.USERID']
	    };
        $.messager.confirm($g('��ܰ��ʾ'), $g('��ȷ�Ϸ�ҩ��?'), function (r) {
            if (r) {
			    var retJson = $.cm(
			        {
			            ClassName: 'PHA.IP.Data.Api',
			            MethodName: 'HandleInAll',
			            pClassName: 'PHA.IP.DrawDisp.Save',
			            pMethodName: 'DispHandler',
			            pJsonStr: JSON.stringify([pJson])
			        },
			        false
			    );
			    if (retJson.success === 'N') {
			        var msg = PHAIP_COM.DataApi.Msg(retJson);
			        PHA.Alert('��ʾ', msg, 'warning');
			    } else {
			        $('#gridDraw').datagrid('reload');
			    }
            }
        });
	    
	}

};
