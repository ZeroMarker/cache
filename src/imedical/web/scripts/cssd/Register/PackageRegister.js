
//ɾ���Ǽǹ��ı�ǩ
function Del(index) {
    $('#RegData').datagrid('selectRow', index); // �ؼ�������
    var row = $('#RegData').datagrid('getSelected');
    if (row) {
        $.cm({
            ClassName: "web.CSSDHUI.PackageRegister.PkgRegister",
            MethodName: "Delete",
            RowID: row.rowid
        }, function (txtData) {
            if (txtData.success == 0) {
                $('#RegData').datagrid('reload');
            }

        });
    }
}
var init = function () {
    var userCode = session['LOGON.USERCODE'];
    var userdr = session['LOGON.USERID'];
    var frm = dhcsys_getmenuform();
    var Adm = frm.EpisodeID.value;
        $.cm({
            ClassName: "web.CSSDHUI.PackageRegister.PkgRegister",
            MethodName: "ByAdmGetPatInfo",
            Adm: Adm
        }, function (jsonData) {
            if (jsonData.success == 0) {
                //alert(jsonData.rowid);
                var vs = jsonData.rowid.split('^');
                $('#RegNo').text(vs[0]);
                $('#patientname').text(vs[1]);
                $('#LocName').text(vs[2]);
                $('#Code').focus();
                MainGridObj.commonReload();
            } else {
                $UI.msg('alert', jsonData.msg);
                $('#Code').attr("disabled", "disabled");
                return;
            }

        });

    var MainGridObj = $UI.datagrid("#RegData", {
            url: $URL,
            queryParams: {
                ClassName: 'web.CSSDHUI.PackageRegister.PkgRegister',
                QueryName: 'GetPatientInfo',
                Adm: Adm
            },
            columns: [[{
                        field: 'RegNo',
                        title: '�ǼǺ�',
                        width: 100
                    }, {
                        field: 'PatName',
                        title: '����',
                        width: 100
                    }, {
                        field: 'PatLoc',
                        title: '����',
                        width: 100
                    }, {
                        field: 'label',
                        title: '��ǩ',
                        width: 100
                    }, {
                        field: 'packageName',
                        title: '����',
                        width: 100
                    }, {
                        field: 'CountNurseDr',
                        title: '������',
                        width: 100
                    }, {
                        field: 'CountNurseTime',
                        title: '����ʱ��',
                        width: 100
                    }, {
                        field: 'rowid',
                        title: '����',
                        align: 'center',
                        hidden: true
                    }, {
                        field: 'opt',
                        title: '����',
                        width: 100,
                        formatter: function (val, row, index) {
                            var btn = '<a href="#"   class="Del" onclick=Del(' + index + ') >ɾ��</a>';
                            return btn;
                        }
                    }

                ]],
            onLoadSuccess: function (data) {
                $(".Del").linkbutton({
                    text: '',
                    plain: true,
                    iconCls: 'icon-cancel'
                });
            }

        });

    $("#Code").keydown(function (e) {
        var curKey = e.which;
        if (curKey == 13) {
            if ($("#Code").val() != "") {
                $.cm({
                    ClassName: "web.CSSDHUI.PackageRegister.PkgRegister",
                    MethodName: "Insert",
                    Label: $("#Code").val(),
                    Adm: Adm,
                    UserId: userdr
                }, function (jsonData) {
                    if (jsonData.success == 0) {
                        $("#Code").val("");
                        $('#Code').focus();
                        MainGridObj.commonReload();
                    } else {
                        $UI.msg('alert', jsonData.msg);
                        $("#Code").val("");
                        $('#Code').focus();
                        return;
                    }

                });
            }
        }

    });
}
$(init);
