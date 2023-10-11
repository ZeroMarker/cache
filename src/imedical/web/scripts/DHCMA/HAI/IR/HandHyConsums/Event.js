//页面Event
function InitHandHyConsumsWinEvent(obj) {
	obj.LoadEvent = function(args){ 
		obj.refreshHHConsumst();
	};
    //院区点击事件
    $HUI.combobox('#cboHospital', {
        onSelect: function (data) {
            obj.cboLoction = Common_ComboToLoc("cboLoction", data.ID, "", "", ""); //初始化病区
        }
    });
    //院区点击事件
    $HUI.combobox('#cboHospitalEdit', {
        onSelect: function (data) {
            obj.cboLoction = Common_ComboToLoc("cboLoctionEdit", data.ID, "", "", ""); //初始化病区
        }
    });
    //查询
    $('#btnQuery').click(function (e) {
        obj.refreshHHConsumst();
    });
    //登记
    $('#btnEdit').click(function (e) {
        $('#LayerEdit').show();     //显示页面
        obj.layer("");
    });
    //删除
    $('#btnDelete').click(function (e) {
        obj.btnDelete_click();
    });
    //导出
    $('#btnExport').click(function (e) {
		 var rows = $('#gridHHConsums').datagrid("getRows");
		 if (rows.length<=0){
			$.messager.alert("提示", "无数据,不允许导出", 'info');
			return;
		}
        $('#gridHHConsums').datagrid('toExcel', '手卫生用品消耗登记.xls');   //导出
    });
    //保存
    $('#btnSave').click(function (e) {
        obj.btnSave_click();
    });
    //关闭
    $('#btnClose').click(function (e) {
        $HUI.dialog('#LayerEdit').close();
    });
    //选中手卫生用品消耗登记
    obj.gridHHConsums_onSelect = function () {
        var rowData = obj.gridHHConsums.getSelected();
        if ($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID = "";    //点击置空
        if (rowData["ID"] == obj.RecRowID) {    //取消选中
            $("#btnDelete").linkbutton("disable");
            obj.RecRowID = "";
            obj.gridHHConsums.clearSelections();
        } else {    //选中行
            obj.RecRowID = rowData["ID"];
            $("#btnDelete").linkbutton("enable");
        }
    }//保存
    obj.btnSave_click = function () {
        var ErrorStr = "";

		var HosID = $('#cboHospitalEdit').combobox('getValue');
        var LocID = $('#cboLoctionEdit').combobox('getValue');
        var ProductDr = $('#cboProduct').combobox('getValue');
        var ObsDate = $('#dtDate').combobox('getValue');
        var Consumption = $('#txtConsum').val(); 
        var Recipient = $('#txtRecipient').val();
        var Resume = $('#txtResume').val();
        var IsActive = $('#chkIsActive').checkbox('getValue') ? '1' : '0';

        var ErrorStr = "";
		if (HosID == '') {
            $.messager.alert("提示", "院区不允许为空!", 'info');
            return;
        }
        if (LocID == '') {
            $.messager.alert("提示", "科室/病区不允许为空!", 'info');
            return;
        }
        if (ProductDr == '') {
            $.messager.alert("提示", "手卫生用品不允许为空!", 'info');
            return;
        }
		if (ObsDate == '') {
            $.messager.alert("提示", "日期不允许为空!", 'info');
            return;
        }
        if (Consumption == '') {
            $.messager.alert("提示", "消耗量不允许为空!", 'info');
            return;
        }
        if (Recipient == '') {
            $.messager.alert("提示", "领用人不允许为空!", 'info');
            return;
        }

        var InputStr = obj.RecRowID;
        InputStr += "^" + LocID;
        InputStr += "^" + ObsDate;
        InputStr += "^" + ProductDr;
        InputStr += "^" + Consumption;
        InputStr += "^" + Recipient;
        InputStr += "^" + "";
        InputStr += "^" + "";
        InputStr += "^" + $.LOGON.USERID;
        InputStr += "^" + IsActive;
        InputStr += "^" + Resume;

        var flg = $m({
            ClassName: "DHCHAI.IR.HandHyConsums",
            MethodName: "Update",
            aInputStr: InputStr,
            aSeparete: "^"
        }, false);
        if (parseInt(flg) <= 0) {
            $.messager.alert("提示", "保存失败!", 'info');
        } else {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
            $HUI.dialog('#LayerEdit').close();
            obj.refreshHHConsumst();//刷新当前页
        }
    }
    //删除
    obj.btnDelete_click = function () {
        var rowDataID = obj.gridHHConsums.getSelected()["ID"];
        if (rowDataID == "") {
            $.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
            return;
        }
        $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
            if (r) {
                var flg = $m({
                    ClassName: "DHCHAI.IR.HandHyConsums",
                    MethodName: "DeleteById",
                    aId: rowDataID
                }, false);
                if ((parseInt(flg) == -1)) {
                    $.messager.alert("错误提示", "删除数据错误!", 'info');
                } else if ((parseInt(flg) == -2)) {
                    $.messager.alert("错误提示", '该记录已被"手卫生用品消耗登记表"引用，不能删除!', 'info');
                } else if ((parseInt(flg) >= 0)) {
                    $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                    obj.RecRowID = ""
                    //obj.gridHHConsums.reload();//刷新当前页
                    obj.refreshHHConsumst();
                }
            }
        });
    }
    //手卫生用品消耗登记表刷新（前台刷新）
    obj.refreshHHConsumst = function () {
        var HospID = $('#cboHospital').combobox('getValue');
        var LocID = $('#cboLoction').combobox('getValue');
        var DateFrom = $('#dtDateFrom').combobox('getValue');
        var DateTo = $('#dtDateTo').combobox('getValue');

        if (DateFrom == "") {
            $.messager.alert("提示", "开始日期不能为空!", 'info');
            return;
        }
        else if (DateTo == "") {
            $.messager.alert("提示", "结束日期不能为空!", 'info');
            return;
        }
        else if (Common_CompareDate(DateFrom, DateTo)==1) {
            $.messager.alert("提示", "开始日期不能大于当前日期!", 'info');
            return;
        }
        $cm ({
		    ClassName:"DHCHAI.IRS.HandHyConsumsSrv",
			QueryName:"QryHHConsums",
            aHospID: HospID,
            aLocID: LocID,
            aDateFrom: DateFrom,
            aDateTo: DateTo,
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridHHConsums').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
		/*
        obj.gridHHConsums.load({
            ClassName: "DHCHAI.IRS.HandHyConsumsSrv",
            QueryName: "QryHHConsums",
            aHospID: HospID,
            aLocID: LocID,
            aDateFrom: DateFrom,
            aDateTo: DateTo
        })*/
    }
    // 弹出手卫生用品消耗量编辑
    obj.LayerEdit = function () {
        $HUI.dialog('#LayerEdit', {
            title: "手卫生用品消耗量编辑",
            iconCls: 'icon-w-paper',
            modal: true,
            isTopZindex: true
        })
    }
    //手卫生用品维护窗体-初始化
    obj.layer = function (rowData) {
        //初始化编辑框
        var HospID = $('#cboHospital').combobox('getValue');
	    obj.cboLoctionEdit = Common_ComboToLoc("cboLoctionEdit",HospID, "", "", ""); //初始化病区
        if (rowData) {
            obj.RecRowID = rowData["ID"];     //记录点击ID
			var LocID = rowData["LocDr"];
            var Product = rowData["ProductDr"];
            var Date = rowData["ObsDate"];
            var Consum = rowData["ConsuSum"];
            var Recipient = rowData["Recipient"];
            var Resume = rowData["Resume"];
            var IsActive = rowData["IsActive"];
            IsActive = (IsActive == "1" ? true : false)
            $("#cboHospitalEdit").combobox('setValue',HospID )
            $('#cboLoctionEdit').combobox('setValue',LocID);
            $('#cboProduct').combobox('setValue',Product);
            $('#dtDate').datebox('setValue', Date);
            $('#txtConsum').val(Consum);
            $('#txtRecipient').val(Recipient);
            $('#txtResume').val(Resume);
            $('#chkIsActive').checkbox('setValue', IsActive);
        } else {
            obj.RecRowID = "";
            $("#cboHospitalEdit").combobox('clear')
            $('#cboLoctionEdit').combobox('setValue', '');
            $('#cboProduct').combobox('setValue', '');
            $('#txtConsum').val("");
            $('#txtRecipient').val("");
            $('#txtResume').val("");
            $('#chkIsActive').checkbox('setValue', true);
        }
        obj.LayerEdit();
    }
}