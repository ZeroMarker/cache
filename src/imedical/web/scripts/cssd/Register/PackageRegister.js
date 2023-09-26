
//删除登记过的标签
function Del(index) {
    $('#RegData').datagrid('selectRow', index); // 关键在这里
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
                        title: '登记号',
                        width: 100
                    }, {
                        field: 'PatName',
                        title: '病人',
                        width: 100
                    }, {
                        field: 'PatLoc',
                        title: '科室',
                        width: 100
                    }, {
                        field: 'label',
                        title: '标签',
                        width: 100
                    }, {
                        field: 'packageName',
                        title: '包名',
                        width: 100
                    }, {
                        field: 'CountNurseDr',
                        title: '操作人',
                        width: 100
                    }, {
                        field: 'CountNurseTime',
                        title: '操作时间',
                        width: 100
                    }, {
                        field: 'rowid',
                        title: '操作',
                        align: 'center',
                        hidden: true
                    }, {
                        field: 'opt',
                        title: '操作',
                        width: 100,
                        formatter: function (val, row, index) {
                            var btn = '<a href="#"   class="Del" onclick=Del(' + index + ') >删除</a>';
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
