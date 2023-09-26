/**
 * ģ��:     ��������ά��-��������
 * ��д����: 2018-04-12
 * ��д��:   yunhaibao
 */
var Loaded = '';
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaLoc',
            Type: 'PivaLoc'
        },
        {
            width: 200,
            placeholder: '��Һ����...',
            onSelect: function (rec) {
                Loaded = '';
                InitData(rec.RowId);
            },
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                        break;
                    }
                }
            }
        }
    );
    $HUI.radio("[type='radio']", {
        onChecked: function (e, value) {
            if ($('#cmbPivaLoc').combobox('getValue') === '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '����ѡ����Һ����',
                    type: 'alert'
                });
                return;
            }
            if (Loaded != '') {
                $.messager.confirm('��ʾ', '��ȷ���޸Ĺ�����?', function (r) {
                    if (r) {
                        Save();
                    }
                });
            }
        }
    });
});

//����
function Save() {
    var locId = $('#cmbPivaLoc').combobox('getValue');
    if (locId == '') {
        $.messager.alert('��ʾ', '��Һ����Ϊ��', 'info');
        return;
    }
    var bigFlag = $("input[name='radCubage']:checked").val() || 'N';
    var conFlag = $("input[name='radContinue']:checked").val() || 'Y';
    var params = locId + '^' + bigFlag + '^' + conFlag;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'SavePIVAOtherRule', params);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal == '-1') {
        $.messager.alert('��ʾ', saveInfo, 'warning');
        return;
    } else if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'error');
        return;
    }
}

//������Ϣ
function InitData(locId) {
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            MethodName: 'GetPIVAOtherRule',
            locId: locId
        },
        function (retData) {
            if (retData == '') {
                retData[0] = 'N';
                retData[1] = 'N';
            }
            var retArr = retData.split('^');
            $('#radCubageY').radio('setValue', retArr[0] == 'Y' ? true : false);
            $('#radCubageN').radio('setValue', retArr[0] == 'Y' ? false : true);
            $('#radContinueY').radio('setValue', retArr[1] == 'Y' ? true : false);
            $('#radContinueN').radio('setValue', retArr[1] == 'Y' ? false : true);
            Loaded = 1;
        }
    );
}
