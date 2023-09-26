/**
 * 模块:     排批规则维护-其他规则
 * 编写日期: 2018-04-12
 * 编写人:   yunhaibao
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
            placeholder: '配液中心...',
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
                    msg: '请先选择配液中心',
                    type: 'alert'
                });
                return;
            }
            if (Loaded != '') {
                $.messager.confirm('提示', '您确认修改规则吗?', function (r) {
                    if (r) {
                        Save();
                    }
                });
            }
        }
    });
});

//保存
function Save() {
    var locId = $('#cmbPivaLoc').combobox('getValue');
    if (locId == '') {
        $.messager.alert('提示', '配液中心为空', 'info');
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
        $.messager.alert('提示', saveInfo, 'warning');
        return;
    } else if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'error');
        return;
    }
}

//加载信息
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
