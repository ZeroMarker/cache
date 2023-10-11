//公共模板类型->项目定义->Event
function InitExpTypeExtWinEvent(obj) {
    //初始化信息
    obj.LoadEvent = function (args) {
        //添加
        $('#btnAdd').on('click', function () {
            obj.LayerEdit();        //打开编辑框
            obj.layer("");          //初始化编辑框
        });
        //编辑
        $('#btnEdit').on('click', function () {
            var rowData = obj.gridOccExpTypeExt.getSelected();
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
    obj.gridOccExpTypeExt_onSelect = function () {
        var rowData = obj.gridOccExpTypeExt.getSelected();
        if ($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID = "";    //点击置空
        if (rowData["ID"] == obj.RecRowID) {    //取消选中
            $("#btnAdd").linkbutton("enable");
            $("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
            obj.RecRowID = "";
            obj.gridOccExpTypeExt.clearSelections();
        } else {    //选中行
            obj.RecRowID = rowData["ID"];
            $("#btnAdd").linkbutton("disable");
            $("#btnEdit").linkbutton("enable");
            $("#btnDelete").linkbutton("enable");
        }
    }
    //保存
    obj.btnSave_click = function () {
        var OccCode = $('#txtCode').val();
        var OccDesc = $('#txtDesc').val();
        var OccExtType = $('#cboExtType').combobox('getValue');
        var OccDatType = $('#cboDatType').combobox('getValue');
        var OccDicType = $('#cboDicType').combobox('getValue');
        var IsActive = $('#chkIsActive').checkbox('getValue') ? '1' : '0';

        if (OccCode == '') {
            $.messager.alert("错误提示", "代码不允许为空!", 'info');
            return;
        }
        if (OccDesc == '') {
            $.messager.alert("错误提示", "描述不允许为空!", 'info');
            return;
        }
        if (OccExtType == '') {
            $.messager.alert("错误提示", "项目分类不允许为空!", 'info');
            return;
        }


        var InputStr = Parref;
        var SubID = (obj.RecRowID ? obj.RecRowID.split("||")[1] : '');
        InputStr += "^" + SubID;
        InputStr += "^" + OccCode;
        InputStr += "^" + OccDesc;
        InputStr += "^" + OccExtType;
        InputStr += "^" + OccDatType;
        InputStr += "^" + OccDicType;
        InputStr += "^" + IsActive;

        var flg = $m({
            ClassName: "DHCHAI.IR.ComTempDefExt",
            MethodName: "Update",
            aInputStr: InputStr,
            aSeparete: "^"
        }, false);
        if (parseInt(flg) <= 0) {
           if(flg=="-2"){
	            $.messager.alert("提示", "保存失败，代码不能重复！", 'info');
		    }
		    else{
			    $.messager.alert("提示", "保存失败！", 'info');
			}
        } else {
            $HUI.dialog('#LayerEdit').close();
            $.messager.alert("提示", "保存成功！", 'info');
            obj.gridOccExpTypeExt.reload();//刷新当前页
        }
    }
    //删除
    obj.btnDelete_click = function () {
        var rowDataID = obj.gridOccExpTypeExt.getSelected()["ID"];
        if (rowDataID == "") {
            $.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
            return;
        }
        $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
            if (r) {
                var flg = $m({
                    ClassName: "DHCHAI.IR.ComTempDefExt",
                    MethodName: "DeleteById",
                    aId: rowDataID
                }, false);
                if ((parseInt(flg) < 0)) {
                    $.messager.alert("错误提示", "删除数据错误!", 'info');
                } else {
                    $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                    obj.RecRowID = ""
                    obj.gridOccExpTypeExt.reload();//刷新当前页
                }
            }
        });
    }
    // 弹出公共模板类型->项目定义编辑
    obj.LayerEdit = function () {
        $('#LayerEdit').show();
        $HUI.dialog('#LayerEdit', {
            title: "公共模板项目编辑",
            iconCls: 'icon-w-paper',
            modal: true,
            isTopZindex: true
        })
    }
    //公共模板类型->项目定义初始化
    obj.layer = function (rowData) {
        if (rowData) {
            obj.RecRowID = rowData["ID"];     //记录点击ID
            var Code = rowData["Code"];
            var Desc = rowData["Desc"];
            var TypeID = rowData["TypeID"];
            var TypeDesc = rowData["TypeDesc"];
            var DatID = rowData["DatID"];
            var DatDesc = rowData["DatDesc"];
            var DicID = rowData["DicID"];
            var DicDesc = rowData["DicDesc"];
            var IsActive = rowData["IsRequired"];
            IsActive = (IsActive == "1" ? true : false)

            $('#txtCode').val(Code);
            $('#txtDesc').val(Desc);
            $('#cboExtType').combobox('setValue', TypeID);
            $('#cboExtType').combobox('setText', TypeDesc);
            $('#cboDatType').combobox('setValue', DatID);
            $('#cboDatType').combobox('setText', DatDesc);
            $('#cboDicType').combobox('setValue', DicID);
            $('#cboDicType').combobox('setText', DicDesc);
            $('#chkIsActive').checkbox('setValue', IsActive);
        } else {
            obj.RecRowID = "";
            $('#txtCode').val('');
            $('#txtDesc').val('');
            $('#cboExtType').combobox('setValue', "");
            $('#cboExtType').combobox('setText', "");
            $('#cboDatType').combobox('setValue', "");
            $('#cboDatType').combobox('setText', "");
            $('#cboDicType').combobox('setValue', "");
            $('#cboDicType').combobox('setText', "");
            $('#chkIsActive').checkbox('setValue', false);
        }
        obj.LayerEdit();
    }
}