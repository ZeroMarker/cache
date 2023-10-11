function InitICUReportWinEvent(obj) {
    obj.ReportID = RepID;

    obj.LoadEvent = function () {
        //初始化下拉菜单
        obj.cboIRPICCType = Common_ComboDicID('cboIRPICCType', 'ICUPICCIntubateType');
        obj.cboIRPICCCnt = Common_ComboDicID('cboIRPICCCnt', 'ICUPICCIntubateNum');
        obj.cboIRPICCPos = Common_ComboDicID('cboIRPICCPos', 'ICUPICCIntubateRegion');
        obj.cboIROperDoc = Common_ComboDicID('cboIROperDoc', 'ICUIntubateUserType');
        obj.cboIROperLoc = Common_ComboDicID('cboIROperLoc', 'ICUIntubatePlace');
        obj.cboIRInfSymptoms = Common_ComboDicID('cboIRInfSymptoms', 'ICUIntubateINFSymptom');

        obj.cboIRTypeV = Common_ComboDicID('cboIRVAPType', 'ICUVAPIntubateType');
        obj.cboIROperDocV = Common_ComboDicID('cboIROperDocV', 'ICUIntubateUserType');
        obj.cboIROperLocV = Common_ComboDicID('cboIROperLocV', 'ICUIntubatePlace');
        obj.cboIRInfSymptomsV = Common_ComboDicID('cboIRInfSymptomsV', 'ICUIntubateINFSymptom');

        obj.cboIRTypeU = Common_ComboDicID('cboIRUCType', 'ICUUCUrineBagType');
        obj.cboIROperDocU = Common_ComboDicID('cboIROperDocU', 'ICUIntubateUserType');
        obj.cboIROperLocU = Common_ComboDicID('cboIROperLocU', 'ICUIntubatePlace');
        obj.cboIRInfSymptomsU = Common_ComboDicID('cboIRInfSymptomsU', 'ICUIntubateINFSymptom');

        //初始化患者基本信息
        var PaadmInfo = $cm({
            ClassName: "DHCHAI.DPS.PAAdmSrv",
            QueryName: "QryAdmInfo",
            aEpisodeID: Paadm
        }, false);
        if (PaadmInfo.total > 0) {
            var AdmInfo = PaadmInfo.rows[0];

            $('#pRegNo').val(AdmInfo.PapmiNo);
            $('#pName').val(AdmInfo.PatName);
            $('#pNo').val(AdmInfo.MrNo);
            $('#pSex').val(AdmInfo.Sex);
            $('#pAge').val(AdmInfo.Age);
            $('#pAdmDate').val(AdmInfo.AdmDate);
            $('#pDisDate').val(AdmInfo.DischDate);

        }
        //初始化评分
        var RepInfo = $m({
            ClassName: "DHCHAI.IRS.INFReportSrv",
            MethodName: "GetICURepList",
            aRepID: RepID
        }, false);
        $('#APACHE').val(RepInfo.split("^")[5]);

        obj.refreshgridICUOE(Paadm, 0); //初始化医嘱
        obj.refreshPICC();  //刷新PICC
        obj.refreshVAP();   //刷新VAP
        obj.refreshUC();    //刷新UC

        var RepStatus = "";
        if (RepInfo.split("^")[1] == "保存") var RepStatus = 1;
        if (RepInfo.split("^")[1] == "提交") var RepStatus = 2;
        if (RepInfo.split("^")[1] == "审核") var RepStatus = 3;
        if (RepInfo.split("^")[1] == "删除") var RepStatus = 4;
        if (RepInfo.split("^")[1] == "审核") {
            $("#btnPICCAdd").linkbutton("disable");
            $("#btnPICCDel").linkbutton("disable");
            $("#btnVAPAdd").linkbutton("disable");
            $("#btnVAPDel").linkbutton("disable");
            $("#btnUCAdd").linkbutton("disable");
            $("#btnUCDel").linkbutton("disable");
        }
        if (RepInfo.split("^")[1] == "删除") {
            $("#btnPICCAdd").linkbutton("disable");
            $("#btnPICCDel").linkbutton("disable");
            $("#btnVAPAdd").linkbutton("disable");
            $("#btnVAPDel").linkbutton("disable");
            $("#btnUCAdd").linkbutton("disable");
            $("#btnUCDel").linkbutton("disable");
        }

        obj.InitButtons(RepStatus);
    }
    //更新按钮
    obj.InitButtons = function (RepStatus) {
        switch (RepStatus) {
            case 1:   //保存
                $('#btnSave').show();
                $('#btnSubmit').show();
                $('#btnCheck').hide();
                $('#btnDelete').show();
                break;
            case 2:    //提交
                $('#btnSave').hide();
                $('#btnSubmit').hide();
                $('#btnCheck').show();
                $('#btnDelete').show();
                break;
            case 3:    //审核
                $('#btnSave').hide();
                $('#btnSubmit').hide();
                $('#btnCheck').hide();
                $('#btnDelete').show();
                break;
            case 4:   //删除
                $('#btnSave').hide();
                $('#btnSubmit').hide();
                $('#btnCheck').hide();
                $('#btnDelete').hide();
                break;
            default:
                $('#btnSave').show();
                $('#btnSubmit').show();
                $('#btnCheck').hide();
                $('#btnDelete').hide();
                break;
        }
    }
    //刷新PICC
    obj.refreshPICC = function () {
        $("#gridPICC").datagrid("loading"); //加载中提示信息
        $cm({
            ClassName: 'DHCHAI.IRS.INFICUPICCSrv',
            QueryName: 'QryICUPICCByPaadm',
            ResultSetType: "array",
            aPaadm: Paadm,
            aLocDr: LocDr,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridPICC').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    //刷新VAP
    obj.refreshVAP = function () {
        $("#gridVAP").datagrid("loading"); //加载中提示信息
        $cm({
            ClassName: 'DHCHAI.IRS.INFICUVAPSrv',
            QueryName: 'QryICUVAPByPaadm',
            ResultSetType: "array",
            aPaadm: Paadm,
            aLocID: LocDr,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridVAP').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    //刷新UC
    obj.refreshUC = function () {
        $("#gridUC").datagrid("loading"); //加载中提示信息
        $cm({
            ClassName: 'DHCHAI.IRS.INFICUUCSrv',
            QueryName: 'QryICUUCByPaadm',
            ResultSetType: "array",
            aPaadm: Paadm,
            aLocID: LocDr,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridUC').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    //添加PICC
    $('#btnPICCAdd').on('click', function () {
        obj.SelectPICCData = "";    //清空数据
        $('#LayerPICC').show();
        obj.OpenLayerPICC();
    })
    // //删除PICC
    $("#btnPICCDel").click(function (e) {
        var selectObj = obj.gridPICC.getSelected();
        if (!selectObj) {
            $.messager.alert("提示", "请选择一行要删除的数据!", 'info');
            return;
        } else {
            var rowDataID = obj.gridPICC.getSelected()["ID"];
            var index = obj.gridPICC.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
            if (rowDataID == "") {
                $.messager.confirm("提示", "是否要删除：" + selectObj.IRPICCTypeDesc + " ?", function (r) {
                    if (r) {
                        obj.gridPICC.deleteRow(index);
                        obj.SelectPICCData = ""
                        obj.rowIndex=""
                    }
                });
            }
            else {
                $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
                    if (r) {
                        var flg = $m({
                            ClassName: "DHCHAI.IR.INFICUPICC",
                            MethodName: "DeleteById",
                            Id: rowDataID
                        }, false);
                        if ((parseInt(flg) == -1)) {
                            $.messager.alert("错误提示", "删除数据错误!", 'info');
                            return
                        } else {
                            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                            obj.SelectPICCData = ""
                            obj.rowIndex=""
                            obj.gridPICC.deleteRow(index);
                           // obj.refreshPICC();//刷新当前页
                        }
                    }
                });
            }
        }
    })
    //打开PICC编辑
    obj.OpenLayerPICC = function () {
        var rowData = obj.SelectPICCData;
        //var r = obj.RowIndex
        $HUI.dialog('#LayerPICC', {
            title: "中心静脉插管-编辑",
            iconCls: 'icon-w-paper',
            modal: true,
            isTopZindex: true
        })
        if (rowData != "") {
            var IRPICCType = rowData.IRPICCType;
            var IRPICCTypeDesc = rowData.IRPICCTypeDesc;
            $('#cboIRPICCType').combobox('setValue', IRPICCType);
            $('#cboIRPICCType').combobox('setText', IRPICCTypeDesc);

            var IRPICCCnt = rowData.IRPICCCnt;
            var IRPICCCntDesc = rowData.IRPICCCntDesc;
            $('#cboIRPICCCnt').combobox('setValue', IRPICCCnt);
            $('#cboIRPICCCnt').combobox('setText', IRPICCCntDesc);

            var IRPICCPos = rowData.IRPICCPos;
            var IRPICCPosDesc = rowData.IRPICCPosDesc;
            $('#cboIRPICCPos').combobox('setValue', IRPICCPos);
            $('#cboIRPICCPos').combobox('setText', IRPICCPosDesc);

            var IRIntuDate = rowData.IRIntuDate;
            var IRExtuDate = rowData.IRExtuDate;
            $('#txtIRIntuDate').datebox('setValue', IRIntuDate);
            $('#txtIRExtuDate').datebox('setValue', IRExtuDate);

            var IROperDoc = rowData.IROperDoc;
            var IROperDocDesc = rowData.IROperDocDesc;
            $('#cboIROperDoc').combobox('setValue', IROperDoc);
            $('#cboIROperDoc').combobox('setText', IROperDocDesc);

            var IROperLoc = rowData.IROperLoc;
            var IROperLocDesc = rowData.IROperLocDesc;
            $('#cboIROperLoc').combobox('setValue', IROperLoc);
            $('#cboIROperLoc').combobox('setText', IROperLocDesc);

            var IsActive = rowData["IRIsInf"];
            if (IsActive == "1") {
                $('#chkIRIsInf').checkbox('setValue', true);
            }
            else {
                $('#chkIRIsInf').checkbox('setValue', false);
                $('#txtIRInfDate').datebox('disable');
                $('#cboIRInfSymptoms').combobox('disable');
            }
            var IRInfDate = rowData.IRInfDate;
            $('#txtIRInfDate').datebox('setValue', IRInfDate);
            var IRInfSymptoms = rowData.IRInfSymptoms
            var IRInfSymptomsDesc = rowData.IRInfSymptomsDesc
            $('#cboIRInfSymptoms').combobox('setValue', IRInfSymptoms);
            $('#cboIRInfSymptoms').combobox('setText', IRInfSymptomsDesc);
        }
        else {
            $('#cboIRPICCType').combobox('setValue', '');
            $('#cboIRPICCCnt').combobox('setValue', '');
            $('#cboIRPICCPos').combobox('setValue', '');
            $('#txtIRIntuDate').datebox('setValue', '');
            $('#txtIRExtuDate').datebox('setValue', '');
            $('#cboIROperDoc').combobox('setValue', '');
            $('#cboIROperLoc').combobox('setValue', '');
            $('#chkIRIsInf').checkbox('setValue', false);
            $('#IRInfDate').datebox('setValue', '');
            $('#cboIRInfSymptoms').combobox('setValue', '');
            $('#txtIRInfDate').datebox('disable');
            $('#cboIRInfSymptoms').combobox('disable');
        }
    }
    //勾选是否感染
    $HUI.checkbox("[name='IRInfDate']", {
        onChecked: function (e, value) {
            $('#txtIRInfDate').combobox('enable');
            $('#txtIRInfDate').combobox('clear');
            $('#cboIRInfSymptoms').combobox('enable');
            $('#cboIRInfSymptoms').combobox('clear');
        },
        onUnchecked: function (e, value) {
            $('#txtIRInfDate').datebox('disable');
            $('#cboIRInfSymptoms').combobox('disable');
        }
    })
    $('#btnPICCSave').on('click', function () {
        var RowData = obj.SelectPICCData;
        var rowIndex = obj.rowIndex;
        var ID = (RowData ? RowData.ID : "");

        var IRPICCType = $('#cboIRPICCType').combobox('getValue');
        var IRPICCCnt = $('#cboIRPICCCnt').combobox('getValue');
        var IRPICCPos = $('#cboIRPICCPos').combobox('getValue');
        var IRIntuDate = $('#txtIRIntuDate').combobox('getValue');
        var IRExtuDate = $('#txtIRExtuDate').combobox('getValue');
        var IROperDoc = $('#cboIROperDoc').combobox('getValue');
        var IROperLoc = $('#cboIROperLoc').combobox('getValue');
        var IRIsInf = $('#chkIRIsInf').checkbox('getValue') ? '1' : '0';//是否有效
        var IRInfDate = $('#txtIRInfDate').combobox('getValue');
        var IRInfSymptoms = $('#cboIRInfSymptoms').combobox('getValue');
        var IRBacteria = "";  //病原体
        var UpdateUserDr = $.LOGON.USERID;   //$.LOGON.USERID

        var IRPICCTypeDesc = $('#cboIRPICCType').combobox('getText');
        var IRPICCCntDesc = $('#cboIRPICCCnt').combobox('getText');
        var IRPICCPosDesc = $('#cboIRPICCPos').combobox('getText');
        var IROperDocDesc = $('#cboIROperDoc').combobox('getText');
        var IROperLocDesc = $('#cboIROperLoc').combobox('getText');
        var IRInfSymptomsDesc = $('#cboIRInfSymptoms').combobox('getText');
        //日期校验
        if (IRIntuDate == "") {
            $.messager.alert("错误提示", "置管日期不可以为空!", 'info');
            return;
        }
        if (IRExtuDate == "") {
            $.messager.alert("错误提示", "拔管日期不可以为空!", 'info');
            return;
        }
        if (IRIntuDate > IRExtuDate) {
            $.messager.alert("错误提示", "拔管日期不能早于置管日期!", 'info');
            return;
        }
        //必填校验
        if (IRPICCType == "") {
            $.messager.alert("错误提示", "导管类型不可以为空!", 'info');
            return;
        }
        if (IRPICCCnt == "") {
            $.messager.alert("错误提示", "导管腔数不可以为空!", 'info');
            return;
        }
        if (IRPICCPos == "") {
            $.messager.alert("错误提示", "置管部位不可以为空!", 'info');
            return;
        }
        if (IROperDoc == "") {
            $.messager.alert("错误提示", "置管人员不可以为空!", 'info');
            return;
        }
        if (IROperLoc == "") {
            $.messager.alert("错误提示", "置管地点不可以为空!", 'info');
            return;
        }
        if ((IRIsInf == '1') && (!IRInfSymptoms)) {
            $.messager.alert("错误提示", "是否感染选择“是”时，必须填写感染症状!", 'info');
            return;
        }
        if ((IRIsInf == '1') && (!IRInfDate)) {
            $.messager.alert("错误提示", "是否感染选择“是”时，必须填写感染日期!", 'info');
            return;
        }
        var row = {
            ID: ID,
            IRPICCTypeDesc: IRPICCTypeDesc,
            IRPICCCntDesc: IRPICCCntDesc,
            IRPICCPosDesc: IRPICCPosDesc,
            IRIntuDate: IRIntuDate,
            IRExtuDate: IRExtuDate,
            IROperDocDesc: IROperDocDesc,
            IROperLocDesc: IROperLocDesc,
            IRIsInf: IRIsInf,
            IRInfDate: IRInfDate,
            IRInfSymptomsDesc: IRInfSymptomsDesc,
            IRPICCType: IRPICCType,
            IRPICCCnt: IRPICCCnt,
            IRPICCPos: IRPICCPos,
            IROperDoc: IROperDoc,
            IROperLoc: IROperLoc,
            IRInfSymptoms: IRInfSymptoms,
            IRBacteria: "",  //病原体
            UpdateUserDr: $.LOGON.USERID  //$.LOGON.USERID
        }
        if (parseInt(rowIndex) > -1) {  //修改
            obj.gridPICC.updateRow({  //更新指定行
                index: rowIndex,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
                row: row
            });
        } else {	//添加
            obj.gridPICC.appendRow(  //插入一个新行
                row
            );
        }
        $HUI.dialog('#LayerPICC').close();
    })
        //关闭PICC编辑
        $('#btnPICCClose').on('click', function () {
            $HUI.dialog('#LayerPICC').close();
        })

        //添加VAP
        $('#btnVAPAdd').on('click', function () {
            obj.SelectVAPData = "";    //清空数据
            $('#LayerVAP').show();
            obj.OpenLayerVAP();
        })
        // //删除VAP
        $("#btnVAPDel").click(function (e) {
            var selectObj = obj.gridVAP.getSelected();
            if (!selectObj) {
                $.messager.alert("提示", "请选择一行要删除的数据!", 'info');
                return;
            } else {
                var rowDataID = obj.gridVAP.getSelected()["ID"];
                var index = obj.gridVAP.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
                if (rowDataID == "") {
                    $.messager.confirm("提示", "是否要删除：" + selectObj.IRVAPTypeDesc + " ?", function (r) {
                        if (r) {     
                            obj.gridVAP.deleteRow(index);
                            obj.SelectVAPData = ""
                            obj.rowIndex=""
                        }
                    });
                }
                else {
                    $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
                        if (r) {
                            var flg = $m({
                                ClassName: "DHCHAI.IR.INFICUVAP",
                                MethodName: "DeleteById",
                                Id: rowDataID
                            }, false);
                            if ((parseInt(flg) == -1)) {
                                $.messager.alert("错误提示", "删除数据错误!", 'info');
                            } else {
                                $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                                obj.SelectVAPData = ""
                                obj.rowIndex=""
                                obj.gridVAP.deleteRow(index);
                               // obj.refreshVAP();//刷新当前页
                            }
                        }
                    });
                }
            }
        })
    //打开VAP编辑
    obj.OpenLayerVAP = function () {
        var rowData = obj.SelectVAPData;
        $HUI.dialog('#LayerVAP', {
            title: "呼吸机-编辑",
            iconCls: 'icon-w-paper',
            modal: true,
            isTopZindex: true
        })
        if (rowData != "") {
            var IRVAPType = rowData.IRVAPType;
            var IRVAPTypeDesc = rowData.IRVAPTypeDesc;
            $('#cboIRVAPType').combobox('setValue', IRVAPType);
            $('#cboIRVAPType').combobox('setText', IRVAPTypeDesc);

            var IRIntuDate = rowData.IRIntuDate;
            var IRExtuDate = rowData.IRExtuDate;
            $('#txtIRIntuDateV').datebox('setValue', IRIntuDate);
            $('#txtIRExtuDateV').datebox('setValue', IRExtuDate);

            var IROperDoc = rowData.IROperDoc;
            var IROperDocDesc = rowData.IROperDocDesc;
            $('#cboIROperDocV').combobox('setValue', IROperDoc);
            $('#cboIROperDocV').combobox('setText', IROperDocDesc);

            var IROperLoc = rowData.IROperLoc;
            var IROperLocDesc = rowData.IROperLocDesc;
            $('#cboIROperLocV').combobox('setValue', IROperLoc);
            $('#cboIROperLocV').combobox('setText', IROperLocDesc);

            var IsActive = rowData.IRIsInf;
            if (IsActive == "1") {
                $('#chkIRIsInfV').checkbox('setValue', true);
            }
            else {
                $('#chkIRIsInfV').checkbox('setValue', false);
                $('#txtIRInfDateV').datebox('disable');
                $('#cboIRInfSymptomsV').combobox('disable');
            }
            var IRInfDate = rowData.IRInfDate;
            $('#txtIRInfDateV').datebox('setValue', IRInfDate);
            var IRInfSymptoms = rowData.IRInfSymptoms
            var IRInfSymptomsDesc = rowData.IRInfSymptomsDesc
            $('#cboIRInfSymptomsV').combobox('setValue', IRInfSymptoms);
            $('#cboIRInfSymptomsV').combobox('setText', IRInfSymptomsDesc);
        }
        else {
            $('#cboIRVAPType').combobox('setValue', '');
            $('#txtIRIntuDateV').datebox('setValue', '');
            $('#txtIRExtuDateV').datebox('setValue', '');
            $('#cboIROperDocV').combobox('setValue', '');
            $('#cboIROperLocV').combobox('setValue', '');
            $('#chkIRIsInfV').checkbox('setValue', false);
            $('#IRInfDateV').datebox('setValue', '');
            $('#cboIRInfSymptomsV').combobox('setValue', '');
            $('#txtIRInfDateV').datebox('disable');
            $('#cboIRInfSymptomsV').combobox('disable');
        }
    }
        //勾选是否感染
        $HUI.checkbox("[name='IRInfDateV']", {
            onChecked: function (e, value) {
                $('#txtIRInfDateV').combobox('enable');
                $('#txtIRInfDateV').combobox('clear');
                $('#cboIRInfSymptomsV').combobox('enable');
                $('#cboIRInfSymptomsV').combobox('clear');
            },
            onUnchecked: function (e, value) {
                $('#txtIRInfDateV').datebox('disable');
                $('#cboIRInfSymptomsV').combobox('disable');
            }
        })
        //保存VAP
        $('#btnVAPSave').on('click', function () {
            var RowData = obj.SelectVAPData;
            var rowIndex = obj.rowIndex;
            var ID = (RowData ? RowData.ID : "");

            var IRVAPType = $('#cboIRVAPType').combobox('getValue');
            var IRVAPTypeDesc = $('#cboIRVAPType').combobox('getText');
            var IRIntuDate = $('#txtIRIntuDateV').combobox('getValue');
            var IRIntuDateDesc = $('#txtIRIntuDateV').combobox('getText');
            var IRExtuDate = $('#txtIRExtuDateV').combobox('getValue');
            var IRExtuDateDesc = $('#txtIRExtuDateV').combobox('getText');
            var IROperDoc = $('#cboIROperDocV').combobox('getValue');
            var IROperDocDesc = $('#cboIROperDocV').combobox('getText');
            var IROperLoc = $('#cboIROperLocV').combobox('getValue');
            var IROperLocDesc = $('#cboIROperLocV').combobox('getText');
            var IRIsInf = $('#chkIRIsInfV').checkbox('getValue') ? '1' : '0';//是否有效
            var IRInfDate = $('#txtIRInfDateV').combobox('getValue');
            var IRInfDateDesc = $('#txtIRInfDateV').combobox('getText');
            var IRInfSymptoms = $('#cboIRInfSymptomsV').combobox('getValue');
            var IRInfSymptomsDesc = $('#cboIRInfSymptomsV').combobox('getText');
            var IRBacteria = "";  //病原体
            var UpdateUserDr = $.LOGON.USERID;   //$.LOGON.USERID

            //日期校验
            if (IRIntuDate == "") {
                $.messager.alert("错误提示", "上机时间不可以为空!", 'info');
                return;
            }
            if (IRExtuDate == "") {
                $.messager.alert("错误提示", "脱机时间不可以为空!", 'info');
                return;
            }
            if (IRIntuDate > IRExtuDate) {
                $.messager.alert("错误提示", "脱机时间不能早于上机时间!", 'info');
                return;
            }
            //必填校验
            if (IRVAPType == "") {
                $.messager.alert("错误提示", "气管类型不可以为空!", 'info');
                return;
            }
            if (IROperDoc == "") {
                $.messager.alert("错误提示", "置管人员不可以为空!", 'info');
                return;
            }
            if (IROperLoc == "") {
                $.messager.alert("错误提示", "置管地点不可以为空!", 'info');
                return;
            }
            if ((IRIsInf == '1') && (!IRInfSymptoms)) {
                $.messager.alert("错误提示", "是否感染选择“是”时，必须填写感染症状!", 'info');
                return;
            }
            if ((IRIsInf == '1') && (!IRInfDate)) {
                $.messager.alert("错误提示", "是否感染选择“是”时，必须填写感染日期!", 'info');
                return;
            }

            var row = {
                ID: ID,
                IRVAPType: IRVAPType,
                IRVAPTypeDesc: IRVAPTypeDesc,
                IRIntuDate: IRIntuDate,
                IRIntuDateDesc: IRIntuDateDesc,
                IRExtuDate: IRExtuDate,
                IRExtuDateDesc: IRExtuDateDesc,
                IROperDoc: IROperDoc,
                IROperDocDesc: IROperDocDesc,
                IROperLoc: IROperLoc,
                IROperLocDesc: IROperLocDesc,
                IRIsInf: IRIsInf,
                IRInfDate: IRInfDate,
                IRInfDateDesc: IRInfDateDesc,
                IRInfSymptoms: IRInfSymptoms,
                IRInfSymptomsDesc: IRInfSymptomsDesc,
                IRBacteria: "",  //病原体
                UpdateUserDr: $.LOGON.USERID  //$.LOGON.USERID
            }
            if (parseInt(rowIndex) > -1) {  //修改
                obj.gridVAP.updateRow({  //更新指定行
                    index: rowIndex,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
                    row: row
                });
            } else {	//添加
                obj.gridVAP.appendRow(  //插入一个新行
                    row
                );
            }
            $HUI.dialog('#LayerVAP').close();
        })
        //关闭VAP编辑
        $('#btnVAPClose').on('click', function () {
            $HUI.dialog('#LayerVAP').close();
        })
        //添加UC
        $('#btnUCAdd').on('click', function () {
            obj.SelectUCData = "";    //清空数据
            $('#LayerUC').show();
            obj.OpenLayerUC();
        })
        $("#btnUCDel").click(function (e) {
            var selectObj = obj.gridUC.getSelected();
            if (!selectObj) {
                $.messager.alert("提示", "请选择一行要删除的数据!", 'info');
                return;
            } else {
                var rowDataID = obj.gridUC.getSelected()["ID"];
                var index = obj.gridUC.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
                if (rowDataID == "") {
                    $.messager.confirm("提示", "是否要删除：" + selectObj.IRUCTypeDesc + " ?", function (r) {
                        if (r) {
                            obj.gridUC.deleteRow(index);
                            obj.SelectUCData = ""
                            obj.rowIndex=""
                        }
                    });
                }
                else {
                    $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
                        if (r) {
                            var flg = $m({
                                ClassName: "DHCHAI.IR.INFICUUC",
                                MethodName: "DeleteById",
                                Id: rowDataID
                            }, false);
                            if ((parseInt(flg) == -1)) {
                                $.messager.alert("错误提示", "删除数据错误!", 'info');
                            } else {
                                $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                                obj.SelectUCData = ""
                                obj.rowIndex=""
                                obj.gridUC.deleteRow(index);
                               //obj.refreshUC();//刷新当前页
                            }
                        }
                    });
                }
            }
        })
    //打开UC编辑
    obj.OpenLayerUC = function () {
        var rowData = obj.SelectUCData;
        $HUI.dialog('#LayerUC', {
            title: "泌尿道插管-编辑",
            iconCls: 'icon-w-paper',
            modal: true,
            isTopZindex: true
        })
        if (rowData != "") {
            var IRUCType = rowData.IRUCType;
            var IRUCTypeDesc = rowData.IRUCTypeDesc;
            $('#cboIRUCType').combobox('setValue', IRUCType);
            $('#cboIRUCType').combobox('setText', IRUCTypeDesc);

            var IRIntuDate = rowData.IRIntuDate;
            var IRExtuDate = rowData.IRExtuDate;
            $('#txtIRIntuDateU').datebox('setValue', IRIntuDate);
            $('#txtIRExtuDateU').datebox('setValue', IRExtuDate);

            var IROperDoc = rowData.IROperDoc;
            var IROperDocDesc = rowData.IROperDocDesc;
            $('#cboIROperDocU').combobox('setValue', IROperDoc);
            $('#cboIROperDocU').combobox('setText', IROperDocDesc);

            var IROperLoc = rowData.IROperLoc;
            var IROperLocDesc = rowData.IROperLocDesc;
            $('#cboIROperLocU').combobox('setValue', IROperLoc);
            $('#cboIROperLocU').combobox('setText', IROperLocDesc);

            var IsActive = rowData.IRIsInf;
            if (IsActive == "1") {
                $('#chkIRIsInfU').checkbox('setValue', true);
            }
            else {
                $('#chkIRIsInfU').checkbox('setValue', false);
                $('#txtIRInfDateU').datebox('disable');
                $('#cboIRInfSymptomsU').combobox('disable');
            }
            var IRInfDate = rowData.IRInfDate;
            $('#txtIRInfDateU').datebox('setValue', IRInfDate);
            var IRInfSymptoms = rowData.IRInfSymptoms
            var IRInfSymptomsDesc = rowData.IRInfSymptomsDesc
            $('#cboIRInfSymptomsU').combobox('setValue', IRInfSymptoms);
            $('#cboIRInfSymptomsU').combobox('setText', IRInfSymptomsDesc);
        }
        else {
            $('#cboIRUCType').combobox('setValue', '');
            $('#txtIRIntuDateU').datebox('setValue', '');
            $('#txtIRExtuDateU').datebox('setValue', '');
            $('#cboIROperDocU').combobox('setValue', '');
            $('#cboIROperLocU').combobox('setValue', '');
            $('#chkIRIsInfU').checkbox('setValue', false);
            $('#IRInfDateU').datebox('setValue', '');
            $('#cboIRInfSymptomsU').combobox('setValue', '');
            $('#txtIRInfDateU').datebox('disable');
            $('#cboIRInfSymptomsU').combobox('disable');
        }
    }
        //勾选是否感染
        $HUI.checkbox("[name='IRInfDateU']", {
            onChecked: function (e, value) {
                $('#txtIRInfDateU').combobox('enable');
                $('#txtIRInfDateU').combobox('clear');
                $('#cboIRInfSymptomsU').combobox('enable');
                $('#cboIRInfSymptomsU').combobox('clear');
            },
            onUnchecked: function (e, value) {
                $('#txtIRInfDateU').datebox('disable');
                $('#cboIRInfSymptomsU').combobox('disable');
            }
        })
        //保存UC
        $('#btnUCSave').on('click', function () {
            var RowData = obj.SelectUCData;
            var rowIndex = obj.rowIndex;
            var ID = (RowData ? RowData.ID : "");

            var IRUCType = $('#cboIRUCType').combobox('getValue');
            var IRUCTypeDesc = $('#cboIRUCType').combobox('getText');
            var IRIntuDate = $('#txtIRIntuDateU').combobox('getValue');
            var IRIntuDateDesc = $('#txtIRIntuDateU').combobox('getText');
            var IRExtuDate = $('#txtIRExtuDateU').combobox('getValue');
            var IRExtuDateDesc = $('#txtIRExtuDateU').combobox('getText');
            var IROperDoc = $('#cboIROperDocU').combobox('getValue');
            var IROperDocDesc = $('#cboIROperDocU').combobox('getText');
            var IROperLoc = $('#cboIROperLocU').combobox('getValue');
            var IROperLocDesc = $('#cboIROperLocU').combobox('getText');
            var IRIsInf = $('#chkIRIsInfU').checkbox('getValue') ? '1' : '0';//是否有效
            var IRInfDate = $('#txtIRInfDateU').combobox('getValue');
            var IRInfDateDesc = $('#txtIRInfDateU').combobox('getText');
            var IRInfSymptoms = $('#cboIRInfSymptomsU').combobox('getValue');
            var IRInfSymptomsDesc = $('#cboIRInfSymptomsU').combobox('getText');
            var IRBacteria = "";  //病原体
            var UpdateUserDr = $.LOGON.USERID;   //$.LOGON.USERID

            //日期校验
            if (IRIntuDate == "") {
                $.messager.alert("错误提示", "插管日期不可以为空!", 'info');
                return;
            }
            if (IRExtuDate == "") {
                $.messager.alert("错误提示", "拔管日期不可以为空!", 'info');
                return;
            }
            if (IRIntuDate > IRExtuDate) {
                $.messager.alert("错误提示", "拔管日期不能早于插管日期!", 'info');
                return;
            }
            //必填校验
            if (IRUCType == "") {
                $.messager.alert("错误提示", "尿管类型不可以为空!", 'info');
                return;
            }
            if (IROperDoc == "") {
                $.messager.alert("错误提示", "置管人员不可以为空!", 'info');
                return;
            }
            if (IROperLoc == "") {
                $.messager.alert("错误提示", "置管地点不可以为空!", 'info');
                return;
            }
            if ((IRIsInf == '1') && (!IRInfSymptoms)) {
                $.messager.alert("错误提示", "是否感染选择“是”时，必须填写感染症状!", 'info');
                return;
            }
            if ((IRIsInf == '1') && (!IRInfDate)) {
                $.messager.alert("错误提示", "是否感染选择“是”时，必须填写感染日期!", 'info');
                return;
            }

            var row = {
                ID: ID,
                IRUCType: IRUCType,
                IRUCTypeDesc: IRUCTypeDesc,
                IRIntuDate: IRIntuDate,
                IRIntuDateDesc: IRIntuDateDesc,
                IRExtuDate: IRExtuDate,
                IRExtuDateDesc: IRExtuDateDesc,
                IROperDoc: IROperDoc,
                IROperDocDesc: IROperDocDesc,
                IROperLoc: IROperLoc,
                IROperLocDesc: IROperLocDesc,
                IRIsInf: IRIsInf,
                IRInfDate: IRInfDate,
                IRInfDateDesc: IRInfDateDesc,
                IRInfSymptoms: IRInfSymptoms,
                IRInfSymptomsDesc: IRInfSymptomsDesc,
                IRBacteria: "",  //病原体
                UpdateUserDr: $.LOGON.USERID  //$.LOGON.USERID
            }
            if (parseInt(rowIndex) > -1) {  //修改
                obj.gridUC.updateRow({  //更新指定行
                    index: rowIndex,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
                    row: row
                });
            } else {	//添加
                obj.gridUC.appendRow(  //插入一个新行
                    row
                );
            }
            $HUI.dialog('#LayerUC').close();
        })
        //关闭VAP编辑
        $('#btnUCClose').on('click', function () {
            $HUI.dialog('#LayerUC').close();
        })

        //8->ICU三管医嘱点击
        $("#btnICUAll").on('click', function () {
            $('#btnICUAll').css("background-color", "#dbedf9");
            $('#btnICUPICC').css("background-color", "white");
            $('#btnICUVAP').css("background-color", "white");
            $('#btnICUUC').css("background-color", "white");
            obj.refreshgridICUOE(Paadm, 0);
        })
        $("#btnICUPICC").on('click', function () {
            $('#btnICUAll').css("background-color", "white");
            $('#btnICUPICC').css("background-color", "#dbedf9");
            $('#btnICUVAP').css("background-color", "white");
            $('#btnICUUC').css("background-color", "white");
            obj.refreshgridICUOE(Paadm, 1);
        })
        $("#btnICUVAP").on('click', function () {
            $('#btnICUAll').css("background-color", "white");
            $('#btnICUPICC').css("background-color", "white");
            $('#btnICUVAP').css("background-color", "#dbedf9");
            $('#btnICUUC').css("background-color", "white");
            obj.refreshgridICUOE(Paadm, 2);
        })
        $("#btnICUUC").on('click', function () {
            $('#btnICUAll').css("background-color", "white");
            $('#btnICUPICC').css("background-color", "white");
            $('#btnICUVAP').css("background-color", "white");
            $('#btnICUUC').css("background-color", "#dbedf9");
            obj.refreshgridICUOE(Paadm, 3);
        })
        //患者医嘱明细
        obj.refreshgridICUOE = function (iPaAdm, iFlag) {
            $("#gridICUOE").datagrid("loading");
            $cm({
                ClassName: "DHCHAI.IRS.ICULogSrv",
                QueryName: "QryICUAdmOeItem",
                aPaAdm: iPaAdm,
                aFlag: iFlag,
                page: 1,
                rows: 999
            }, function (rs) {
                $('#gridICUOE').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
            });
        }

        //保存登记表
        $('#btnSave').on('click', function () {
            //APACHEⅡ评分
            var IRAPACHEScore = $('#APACHE').val();
            if ((IRAPACHEScore != "") && (IRAPACHEScore > 71)) {
                $.messager.alert("错误提示", "APACHEⅡ评分数据错误，请录入不大于71的0-9的数字!", 'info');
                return;
            }

            var ret = obj.RepSave("3", "1");
            if (parseInt(ret) > 0) {
                $.messager.alert("提示", "保存成功!", 'info');

                obj.InitButtons(1);
                return;
            }
            else {
                $.messager.alert("提示", "保存失败!", 'info');
            }
        })
        //提交登记表
        $('#btnSubmit').on('click', function () {
            //APACHEⅡ评分
            var IRAPACHEScore = $('#APACHE').val();
            if ((IRAPACHEScore != "") && (IRAPACHEScore > 71)) {
                $.messager.alert("错误提示", "APACHEⅡ评分数据错误，请录入不大于71的0-9的数字!", 'info');
                return;
            }
            var ret = obj.RepSave("3", "2");
            if (parseInt(ret) > 0) {
                $.messager.alert("提示", "提交成功!", 'info');

                obj.InitButtons(2);
            }
            else {
                $.messager.alert("提示", "提交失败!", 'info');
            }
        })
        //审核登记表
        $('#btnCheck').on('click', function () {
            //APACHEⅡ评分
            var IRAPACHEScore = $('#APACHE').val();
            if ((IRAPACHEScore != "") && (IRAPACHEScore > 71)) {
                $.messager.alert("错误提示", "APACHEⅡ评分数据错误，请录入不大于71的0-9的数字!", 'info');
                return;
            }

            var ret = obj.RepSave("3", "3");
            if (parseInt(ret) > 0) {
                $.messager.alert("提示", "审核成功!", 'info');

                obj.InitButtons(3);
            }
            else {
                $.messager.alert("提示", "审核失败!", 'info');
            }
        })
        //删除登记表
        $('#btnDelete').on('click', function () {
            //APACHEⅡ评分
            var IRAPACHEScore = $('#APACHE').val();
            if ((IRAPACHEScore != "") && (IRAPACHEScore > 71)) {
                $.messager.alert("错误提示", "APACHEⅡ评分数据错误，请录入不大于71的0-9的数字!", 'info');
                return;
            }
            $.messager.confirm("提示", "确认是否删除", function (r) {				
                if (r) {				
                  var ret = obj.RepSave("3", "4");
                  if (parseInt(ret) > 0) {
                      $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                      obj.InitButtons(4);
                      return;
                      
                  } else {
                      $.messager.alert("提示", "删除失败!", 'info');		
                  }
                }
              });
        })
        obj.RepSave = function (repType, repStatus) {
            var ID = obj.ReportID;

            //var Paadm = Paadm;
            var IRRepType = "3";   //ICU调查表类型
            var IRRepDate = "";
            var IRRepTime = "";     //报告时间
            var IRRepLocDr = LocDr;  //调查科室 ？= 当前科室 Data.LocID
            var IRRepUser = $.LOGON.USERID;   //$.LOGON.USERID
            var IRStatusDr = repStatus;
            var IRLinkDiags = "";   // 感染诊断
            var IRLinkICDs = "";    //疾病诊断
            var IRLinkLabs = "";    //IRLinkAntis
            var IRLinkAntis = "";
            var IRLinkOPSs = "";  //
            var IRLinkMRBs = "";
            var IRLinkInvOpers = "";  //
            var IRLinkPreFactDrs = ""; //易感因素
            var IRLinkICUUCs = "";  //

            var IRLinkICUVAPs = "";  //呼吸机

            var IRLinkICUPICCs = "";

            var IRDiagnosisBasis = ""; //诊断依据
            var IRDiseaseCourse = ""; //
            var IRInLocDr = "";  //入科来源
            var IROutLocDr = "";    //出科方向
            var IRInDate = ""; //入科时间
            var IROutDate = ""; //出科时间 

            var IROutIntubats = ""; //出ICU带管情况 List # 分割多个值
            var IROut48Intubats = ""; //出ICU48带管情况 list  # 分割多个值
            //APACHEⅡ评分
            var IRAPACHEScore = $('#APACHE').val();
            if (repType == "2") {

            }
            else if (repType == "3") {
                //PICC
                var rows = $('#gridPICC').datagrid('getRows');
                var IRLinkICUPICCs = "";
                for (var i = 0; i < rows.length; i++) {
                    var InputStr = rows[i].ID;
                    InputStr += "^" + Paadm;
                    InputStr += "^" + LocDr;
                    InputStr += "^" + rows[i].IRIntuDate;
                    InputStr += "^" + "";
                    InputStr += "^" + rows[i].IRExtuDate;
                    InputStr += "^" + "";
                    InputStr += "^" + rows[i].IRPICCType;
                    InputStr += "^" + rows[i].IRPICCCnt;
                    InputStr += "^" + rows[i].IRPICCPos;
                    InputStr += "^" + rows[i].IROperDoc;
                    InputStr += "^" + rows[i].IROperLoc;
                    InputStr += "^" + rows[i].IRIsInf;
                    InputStr += "^" + rows[i].IRInfDate;
                    InputStr += "^" + rows[i].IRInfSymptoms;
                    InputStr += "^" + rows[i].IRBacteria;
                    InputStr += "^" + rows[i].UpdateUserDr;
                    InputStr += "^" + 0;     //是否审核

                    var flg = $m({
                        ClassName: "DHCHAI.IR.INFICUPICC",
                        MethodName: "Update",
                        InStr: InputStr,
                        aSeparete: "^"
                    }, false);
                    if (parseInt(flg) <= 0) {
                        $.messager.alert("错误提示", " 中心静脉插管第" + i + 1 + "条数据保存失败!", 'info');
                        obj.gridPICC.deleteRow(  //删除一个新行
                            rows[i])
                        return
                    }
                    else {
                        if (IRLinkICUPICCs == "") {
                            IRLinkICUPICCs = rows[i].ID;
                        }
                        else {
                            IRLinkICUPICCs = IRLinkICUPICCs + "," + rows[i].ID;
                        }
                    }
                }
                //VAP
                var rows = $('#gridVAP').datagrid('getRows');
                var IRLinkICUVAPs = "";
                for (var i = 0; i < rows.length; i++) {
                    var InputStr = rows[i].ID;;
                    InputStr += "^" + Paadm;
                    InputStr += "^" + LocDr;
                    InputStr += "^" + rows[i].IRIntuDate;
                    InputStr += "^" + "";
                    InputStr += "^" + rows[i].IRExtuDate;
                    InputStr += "^" + "";
                    InputStr += "^" + rows[i].IRVAPType;
                    InputStr += "^" + rows[i].IROperDoc;
                    InputStr += "^" + rows[i].IROperLoc;
                    InputStr += "^" + rows[i].IRIsInf;
                    InputStr += "^" + rows[i].IRInfDate;
                    InputStr += "^" + rows[i].IRInfSymptoms;
                    InputStr += "^" + rows[i].IRBacteria;
                    InputStr += "^" + rows[i].UpdateUserDr;
                    InputStr += "^" + 0;     //是否审核

                    var flg = $m({
                        ClassName: "DHCHAI.IR.INFICUVAP",
                        MethodName: "Update",
                        InStr: InputStr,
                        aSeparete: "^"
                    }, false);
                    if (parseInt(flg) <= 0) {
                        $.messager.alert("错误提示", " 呼吸机第" + i + 1 + "条数据保存失败!", 'info');
                        obj.gridVAP.deleteRow(  //删除一个新行
                            rows[i])
                        return
                    }
                    else {
                        if (IRLinkICUVAPs == "") {
                            IRLinkICUVAPs = rows[i].ID;
                        }
                        else {
                            IRLinkICUVAPs = IRLinkICUVAPs + "," + rows[i].ID;
                        }
                    }
                }
                //UC
                var rows = $('#gridUC').datagrid('getRows');
                var IRLinkICUUCs = "";
                for (var i = 0; i < rows.length; i++) {
                    var InputStr = rows[i].ID;;
                    InputStr += "^" + Paadm;
                    InputStr += "^" + LocDr;
                    InputStr += "^" + rows[i].IRIntuDate;
                    InputStr += "^" + "";
                    InputStr += "^" + rows[i].IRExtuDate;
                    InputStr += "^" + "";
                    InputStr += "^" + rows[i].IRUCType;
                    InputStr += "^" + rows[i].IROperDoc;
                    InputStr += "^" + rows[i].IROperLoc;
                    InputStr += "^" + rows[i].IRIsInf;
                    InputStr += "^" + rows[i].IRInfDate;
                    InputStr += "^" + rows[i].IRInfSymptoms;
                    InputStr += "^" + rows[i].IRBacteria;
                    InputStr += "^" + rows[i].UpdateUserDr;
                    InputStr += "^" + 0;     //是否审核
                    var flg = $m({
                        ClassName: "DHCHAI.IR.INFICUUC",
                        MethodName: "Update",
                        InStr: InputStr,
                        aSeparete: "^"
                    }, false);
                    if (parseInt(flg) <= 0) {
                        $.messager.alert("错误提示", " 泌尿道插管第" + i + 1 + "条数据保存失败!", 'info');
                        obj.gridUC.deleteRow(  //删除一个新行
                            rows[i])
                        return;
                    }
                    else {
                        if (IRLinkICUUCs == "") {
                            IRLinkICUUCs = rows[i].ID;
                        }
                        else {
                            IRLinkICUUCs = IRLinkICUUCs + "," + rows[i].ID;
                        }
                    }

                }
            }
            var InputStr = ID;
            InputStr += "^" + Paadm;
            InputStr += "^" + IRRepType;
            InputStr += "^" + IRRepDate;
            InputStr += "^" + IRRepTime;
            InputStr += "^" + IRRepLocDr;
            InputStr += "^" + IRRepUser;  //
            InputStr += "^" + IRStatusDr;
            InputStr += "^" + IRLinkDiags;
            InputStr += "^" + IRLinkICDs;
            InputStr += "^" + IRLinkLabs;
            InputStr += "^" + IRLinkAntis;
            InputStr += "^" + IRLinkOPSs;
            InputStr += "^" + IRLinkMRBs;
            InputStr += "^" + IRLinkInvOpers;
            InputStr += "^" + IRLinkPreFactDrs;
            InputStr += "^" + IRLinkICUUCs;
            InputStr += "^" + IRLinkICUVAPs;
            InputStr += "^" + IRLinkICUPICCs;
            InputStr += "^" + IRInLocDr;
            InputStr += "^" + IROutLocDr;
            InputStr += "^" + IRInDate;
            InputStr += "^" + IROutDate;
            InputStr += "^" + IRAPACHEScore;
            InputStr += "^" + IROutIntubats;
            InputStr += "^" + IROut48Intubats;

            var retval = $m({
                ClassName: "DHCHAI.IRS.INFReportSrv",
                MethodName: "UpdateReport",
                aInputStr: InputStr,
                aSeparete: "^"
            }, false);

            obj.ReportID = retval;
            return retval;
        }

}