//职业暴露类型->检验结果对照->Event
function InitExpTypeEpdWinEvent(obj) {
    //初始化信息
    obj.LoadEvent = function (args) {
        //添加
        $('#btnAdd').on('click', function () {
            obj.LayerEdit();
            obj.layer("");
        });
        //编辑
        $('#btnEdit').on('click', function () {
            var rowData = obj.gridOccExpTypeEpd.getSelected();
            obj.LayerEdit();
            obj.layer(rowData);
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
    obj.gridOccExpTypeEpd_onSelect = function () {
        var rowData = obj.gridOccExpTypeEpd.getSelected();
        if ($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID = "";    //点击置空
        if (rowData["ID"] == obj.RecRowID) {    //取消选中
            $("#btnAdd").linkbutton("enable");
            $("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
            obj.RecRowID = "";
            obj.gridOccExpTypeEpd.clearSelections();
        } else {    //选中行
            obj.RecRowID = rowData["ID"];
            $("#btnAdd").linkbutton("disable");
            $("#btnEdit").linkbutton("enable");
            $("#btnDelete").linkbutton("enable");
        }
    }
    //保存
    obj.btnSave_click = function () {
        var EpdTypeDr = $('#cboEpdType').combobox('getValue'); //暴露感染类型
        var BTDesc = $('#txtDesc').val(); //筛查规则描述
        var LabItemDr = $('#cboLabItem').combobox('getValue'); //检验项目
        var LabOperDr = $('#cboLabOperator').combobox('getValue'); //比较1
        var LabItemRst = $('#txtLabItemRst').val(); //阳性结果1		
        var LabItemDesc2 = $('#cboLabItem2').combobox('getValue');//检验项目2
        var LabOperDr2 = $('#cboLabOperator2').combobox('getValue'); //	
        var LabItemRst2 = $('#txtLabItemRst2').val();//阳性结果22
        var Note = $('#txtNote').val();//备注
        var IsActive = $('#chkIsActive').checkbox('getValue') ? '1' : '0';//是否有效

        if (EpdTypeDr == '') {
            $.messager.alert("错误提示", "感染类型为必选!", 'info');
            return;
        }
        if (BTDesc == '') {
            $.messager.alert("错误提示", "规则说明为必填!", 'info');
            return;
        }
        if (LabItemDr == '') {
            $.messager.alert("错误提示", "检验项目为必填!", 'info');
            return;
        }
        if (LabOperDr == '' || LabItemRst == '') {
            $.messager.alert("错误提示", "阳性结果为必填!", 'info');
            return;
        }
        var InStr = Parref;
        var SubID = (obj.RecRowID ? obj.RecRowID.split("||")[1] : '');
        InStr += "^" + SubID;
        InStr += "^" + EpdTypeDr;
        InStr += "^" + BTDesc;
        InStr += "^" + LabItemDr;
        InStr += "^" + LabOperDr;
        InStr += "^" + LabItemRst;
        InStr += "^" + LabItemDesc2;
        InStr += "^" + LabOperDr2;
        InStr += "^" + LabItemRst2;
        InStr += "^" + IsActive;
        InStr += "^" + Note;
        InStr += "^" + "";
        InStr += "^" + "";
        InStr += "^" + $.LOGON.USERID; // 处置人

        var flg = $m({
            ClassName: "DHCHAI.IR.OccExpTypeEpd",
            MethodName: "Update",
            InStr: InStr,
            aSeparete: "^"
        }, false);
        if (parseInt(flg) <= 0) {
            $.messager.alert("错误提示", "参数错误!", 'info');
            return;
        } else {
            $HUI.dialog('#LayerEdit').close();
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
            obj.gridOccExpTypeEpd.reload();//刷新当前页
        }
    }
    //删除
    obj.btnDelete_click = function () {
        var rowDataID = obj.gridOccExpTypeEpd.getSelected()["ID"];
        if (rowDataID == "") {
            $.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
            return;
        }
        $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
            if (r) {
                var flg = $m({
                    ClassName: "DHCHAI.IR.OccExpTypeEpd",
                    MethodName: "DeleteById",
                    aId: rowDataID
                }, false);
                if ((parseInt(flg) < 0)) {
                    $.messager.alert("错误提示", "删除数据错误!", 'info');
                } else {
                    $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                    obj.RecRowID = ""
                    obj.gridOccExpTypeEpd.reload();//刷新当前页
                }
            }
        });
    }
    // 弹出检验结果对照
    obj.LayerEdit = function () {
        $('#LayerEdit').show();
        $HUI.dialog('#LayerEdit', {
            title: "检验结果对照",
            iconCls: 'icon-w-paper',
            modal: true,
            isTopZindex: true
        })
    }
    //暴露感染筛查规则维护-初始化
    obj.layer = function (rowData) {
        if (rowData) {
            obj.RecRowID = rowData["ID"];     //记录点击ID
            var EpdTypeID = rowData["EpdTypeID"];
            var EpdTypeDesc = rowData["EpdTypeDesc"];
            $('#cboEpdType').combobox('setValue', EpdTypeID);
            $('#cboEpdType').combobox('setText', EpdTypeDesc);
            var BTDesc = rowData["BTDesc"];
            $('#txtDesc').val(BTDesc);
            var LabItemID = rowData["LabItemID"];
            var LabItemDesc = rowData["LabItemDesc"];
            $('#cboLabItem').combobox('setValue', LabItemID);
            $('#cboLabItem').combobox('setText', LabItemDesc);
            var LabOperID = rowData["LabOperID"];
            var LabOperator = rowData["LabOperator"];
            $('#cboLabOperator').combobox('setValue', LabOperID);
            $('#cboLabOperator').combobox('setText', LabOperator);
            var txtLabItemRst = rowData["LabItemRst"];
            $('#txtLabItemRst').val(txtLabItemRst);
            var LabItemID2 = rowData["LabItemID2"];
            var LabItemDesc2 = rowData["LabItemDesc2"];
            $('#cboLabItem2').combobox('setValue', LabItemID2);
            $('#cboLabItem2').combobox('setText', LabItemDesc2);
            var LabOperID2 = rowData["LabOperID2"];
            var LabOperator2 = rowData["LabOperator2"];
            $('#cboLabOperator2').combobox('setValue', LabOperID2);
            $('#cboLabOperator2').combobox('setText', LabOperator2);
            var txtLabItemRst2 = rowData["LabItemRst2"];
            $('#txtLabItemRst2').val(txtLabItemRst2);
            var IsActive = rowData["IsActive"];
            IsActive = (IsActive == "1" ? true : false);
            $('#chkIsActive').checkbox('setValue', IsActive);
            var txtNote = rowData["Note"];
            $('#txtNote').val(txtNote);
        } else {
            obj.RecRowID = "";
            $('#cboEpdType').combobox('setValue', '');
            $('#txtDesc').val("");
            $('#cboLabItem').combobox('setValue', '');
            $('#cboLabOperator').combobox('setValue', '');
            $('#txtLabItemRst').val("");
            $('#cboLabItem2').combobox('setValue', '');
            $('#cboLabOperator2').combobox('setValue', '');
            $('#txtLabItemRst2').val("");
            $('#chkIsActive').checkbox('setValue', false);
            $('#txtNote').val("");
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