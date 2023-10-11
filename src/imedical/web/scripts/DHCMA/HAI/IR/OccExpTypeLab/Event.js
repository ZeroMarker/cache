//职业暴露类型->血清学检查计划->Event
function InitExpTypeLabWinEvent(obj) {
    //初始化信息
    obj.LoadEvent = function (args) {
        //添加
        $('#btnAdd').on('click', function () {
            obj.LayerEdit();        //打开编辑框
            obj.layer("");          //初始化编辑框
        });
        //编辑
        $('#btnEdit').on('click', function () {
            var rowData = obj.gridExpTypeLab.getSelected();
            obj.LayerEdit();        //打开编辑框
            obj.layer(rowData);     //初始化编辑框
        });
        //删除
        $('#btnDelete').on('click', function () {
            obj.btnDelete_click();
        });
        //保存
        $('#btnSave').on('click', function () {
            obj.btnSave_click();
        });
        //关闭
        $('#btnClose').on('click', function () {
            $HUI.dialog('#LayerEdit').close();
        });
    }
    //选中类型
    obj.gridExpTypeLab_onSelect = function () {
        var rowData = obj.gridExpTypeLab.getSelected();
        if ($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID = "";    //点击置空
        if (rowData["ID"] == obj.RecRowID) {    //取消选中
            $("#btnAdd").linkbutton("enable");
            $("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
            obj.RecRowID = "";
            obj.gridExpTypeLab.clearSelections();
        } else {    //选中行
            obj.RecRowID = rowData["ID"];
            $("#btnAdd").linkbutton("disable");
            $("#btnEdit").linkbutton("enable");
            $("#btnDelete").linkbutton("enable");
        }
    }
    //保存
    obj.btnSave_click = function () {
        var ErrorStr = "";
        var Desc = $('#txtDesc').val();
        var IndNo = $('#txtIndNo').val();
        var Days = $('#txtDays').val();
        var Resume = $('#txtResume').val();
        var LabItemDr = $('#cboLabItem').combobox('getValue');
        var IsActive = $('#chkActive').checkbox('getValue') ? '1' : '0';

        if (Desc == '') {
            $.messager.alert("错误提示", "检查时机不允许为空!", 'info');
            return;
        }
        if (Days == '') {
            $.messager.alert("错误提示", "时间间隔不允许为空!", 'info');
            return;
        }

        var SubID = (obj.RecRowID ? obj.RecRowID.split("||")[1] : '');

        var InputStr = Parref;
        InputStr += "^" + SubID;
        InputStr += "^" + Desc;
        InputStr += "^" + IndNo;
        InputStr += "^" + Days;
        InputStr += "^" + IsActive;
        InputStr += "^" + Resume;
		InputStr += "^" + LabItemDr;
        var flg = $m({
            ClassName: "DHCHAI.IR.OccExpTypeLab",
            MethodName: "Update",
            aInputStr: InputStr,
            aSeparete: "^"
        }, false);
        if (parseInt(flg) <= 0) {
            $.messager.alert("错误提示", "参数错误!", 'info');
        } else {
            $HUI.dialog('#LayerEdit').close();
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
            obj.gridExpTypeLab.reload();//刷新当前页
        }
    }
    //删除
    obj.btnDelete_click = function () {
        var rowDataID = obj.gridExpTypeLab.getSelected()["ID"];
        if (rowDataID == "") {
            $.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
            return;
        }
        $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
            if (r) {
                var flg = $m({
                    ClassName: "DHCHAI.IR.OccExpTypeLab",
                    MethodName: "DeleteById",
                    aId: rowDataID
                }, false);
                if (parseInt(flg) > -1) {
                    $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                    obj.RecRowID = ""
                    obj.gridExpTypeLab.reload();    //刷新当前页
                } else {
                    if (parseInt(retval) == '-2') {
                        $.messager.alert("错误提示", "检查时机重复!", 'info');
                    } else {
                        $.messager.alert("错误提示", "保存失败!", 'info');
                    }
                }
            }
        });
    }
    // 弹出职业暴露->血清学计划编辑
    obj.LayerEdit = function () {
        $('#LayerEdit').show();
        $HUI.dialog('#LayerEdit', {
            title: "血清检查计划",
            iconCls: 'icon-w-paper',
            modal: true,
            isTopZindex: true
        })
    }
    //血清检查计划窗体-初始化
    obj.layer = function (rowData) {
        if (rowData) {
            obj.RecRowID = rowData["ID"];     //记录点击ID
            var BTDesc = rowData["BTDesc"];
            var BTIndNo = rowData["BTIndNo"];
            var BTDays = rowData["BTDays"];
            var Resume = rowData["Resume"];
            var IsActive = rowData["IsActive"];
            IsActive = (IsActive == "1" ? true : false)

            $('#txtDesc').val(BTDesc);
            $('#txtIndNo').val(BTIndNo);
            $('#txtDays').val(BTDays);
            $('#txtResume').val(Resume);
            $('#cboLabItem').combobox('setValue',rowData["LabItemDr"]);
			$('#cboLabItem').combobox('setText',rowData["LabItem"]);
            $('#chkActive').checkbox('setValue', IsActive);
        } else {
            obj.RecRowID = "";
            $('#txtDesc').val("");
            $('#txtIndNo').val("");
            $('#txtDays').val("");
            $('#txtResume').val("");
            $('#cboLabItem').combobox('clear');
            $('#chkActive').checkbox('setValue', false);
        }
        obj.LayerEdit();
    }
    //摘要点击事件
    obj.OpenView = function (aEpisodeID) {
        var t = new Date();
        t = t.getTime();
        var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen&t=" + t;
        websys_showModal({
            url: strUrl,
            title: '医院感染集成视图',
            iconCls: 'icon-w-paper',
            width: '95%',
            height: '95%'
        });
    }
}