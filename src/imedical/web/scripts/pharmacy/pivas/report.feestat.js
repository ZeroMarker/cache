/**
 * ģ��:     ���÷���ͳ��
 * ��д����: 2018-05-29
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
$(function() {
    PIVAS.Session.More(session['LOGON.CTLOCID'])
    PIVAS.Date.Init({ Id: 'dateStart', LocId: "", Type: 'Start', QueryType: 'Data' });
    PIVAS.Date.Init({ Id: 'dateEnd', LocId: "", Type: 'End', QueryType: 'Data' });
    // ��Һ����
    PIVAS.ComboBox.Init({ Id: 'cmbPivaLoc', Type: 'PivaLoc' }, {
        editable: false,
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        }
    });
    $("#btnFind").on('click', Query)
    $("iframe").attr("src", PIVAS.RunQianBG);
    $(".dhcpha-win-mask").remove();
})

function Query() {
    var startDate = $("#dateStart").datebox("getValue");
    var endDate = $("#dateEnd").datebox("getValue");
    var chkRadioJObj = $("input[name='radioFee']:checked");
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue");
    var labelName = chkRadioJObj.attr("label");
    var raqName = "";
    if ((labelName == "") || (labelName == undefined)) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ��ѯ�ı�������", "warning");
        return;
    }
    if (labelName == "����������") {
        raqName = "DHCST_PIVAS_���÷���ͳ��_����������.raq";
    }
    var raqObj = {
        raqName: raqName,
        raqParams: {
            startDate: startDate,
            endDate: endDate,
            userName: session['LOGON.USERNAME'],
            pivaLoc: pivaLocId,
            hospDesc: PIVAS.Session.HOSPDESC,
            locDesc: PIVAS.Session.CTLOCDESC
        },
        isPreview: 1,
        isPath: 1
    };
    var raqSrc = PIVASPRINT.RaqPrint(raqObj)
    $("iframe").attr("src", raqSrc);
}