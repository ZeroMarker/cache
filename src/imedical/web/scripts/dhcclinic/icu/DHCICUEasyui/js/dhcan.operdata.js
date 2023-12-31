var operDataManager = {
    initFormData: function(patFormCallBack, checkChangeCallBack) {
        // 加载和显示手术申请数据
        var appData = operDataManager.getOperAppData();
        if (patFormCallBack) {
            patFormCallBack(appData);
        }

        // 加载和显示OperData数据
        var operDatas = operDataManager.getOperDatas();
        operDataManager.setFormOperDatas(operDatas);

        // 设置编辑权限
        operDataManager.setPermissions();

        this.checkChangeCallBack = checkChangeCallBack;
    },
    reloadPatInfo:function(patFormCallBack){
        if(patFormCallBack){
            var appData=operDataManager.getOperAppData();
            
            patFormCallBack(appData);
        }
    },
    checkboxCheckChange: function(e, value) {
        var curCheckItem = $(this);
        var formItem = $(this).attr("data-formitem");
        if (!formItem || formItem === "") return;
        var checkSelector = "#" + $(this).attr("id");
        var dataSelector = "#" + formItem;

        if (value === false) {
            operDataManager.setFormDataValue(formItem, $(this).attr("id"), value);
            if (operDataManager.checkChangeCallBack) {
                operDataManager.checkChangeCallBack();
            }
            return;
        }

        var multiChoice = $(dataSelector).attr("data-multiple") === "N" ? false : true;
        if (multiChoice === true) return;
        var groupSelector = "input[data-formitem='" + formItem + "']";
        var checkLabel = $(this).attr("label");
        if (!checkLabel || checkLabel === "") {
            checkLabel = $(this).attr("value");
        }
        $(groupSelector).each(function(index, item) {
            var curLabel = $(this).attr("label");
            if (!curLabel || curLabel === "") {
                curLabel = $(this).attr("value");
            }
            if (curLabel !== checkLabel) {
                $(this).checkbox("setValue", false);
            }
        });
        operDataManager.setFormDataValue(formItem, $(this).attr("id"), value);
        if (operDataManager.checkChangeCallBack) {
            operDataManager.checkChangeCallBack();
        }
    },
    /**
     * 一组checkbox，其中一个checkbox选中状态发生变化时，自动设置其他checkbox选中状态。
     * 单选：如果该checkbox选中，那么其他checkbox去除选中状态。
     * 多选：不做限制。
     */
    setCheckChange: function() {
        $("input[type='checkbox']").each(function(index, item) {
            var dataFormItem = $(this).attr("data-formitem");
            if ($(this).hasClass("hisui-checkbox") && dataFormItem && dataFormItem !== "") {
                $(this).checkbox("options").onCheckChange = operDataManager.checkboxCheckChange;
            }
        });
    },

    initCheckStatus: function(operData) {
        if (!operData || !operData.DataItem || operData.DataItem === "") return;
        var idSelector = "#" + operData.DataItem;
        $(idSelector).val(operData.DataValue);
        var checkSelector = "input[data-formitem='" + operData.DataItem + "']";
        if ($(idSelector).length <= 0 || $(checkSelector).length <= 0) return;
        var compareValue = "," + operData.DataValue + ",";
        $(checkSelector).each(function(index, item) {
            var curLabel = $(this).attr("label");
            if (!curLabel || curLabel === "") {
                curLabel = $(this).attr("value");
            }
            var curValue = "," + curLabel + ",";
            var checked = compareValue.indexOf(curValue) >= 0;
            if ($(this).hasClass(Controls.CheckBox)) {
                $(this).checkbox("setValue", checked);
                $(this).checkbox("options").checked = checked;
            } else if ($(this).hasClass(Controls.Radio)) {
                $(this).radio("setValue", checked);
                $(this).radio("options").checked = checked;
            }
        });
    },

    setPermissions: function() {
        var permissionGroup = null,
            permission = null;
        for (var i = 0; i < permissionGroups.length; i++) {
            permissionGroup = permissionGroups[i];
            if (permissionGroup.groupName === session.GroupDesc) {
                operDataManager.permissionGroup = permissionGroup;
                for (var j = 0; j < permissionGroup.permissions.length; j++) {
                    permission = permissionGroup.permissions[j];
                    if (permission.moduleCode === session.ModuleCode) {
                        if(permission.NeedPermissionAttr && permission.NeedPermissionAttr==="Y"){
                            operDataManager.enableSpecicalControls(permission);
                        }else{
                            this.disableEditControls(permission.enableControls);
                        }
                        
                    }
                }
            }
        }
    },

    /**
     * 获取Jquery控件的值
     * @param {object} jqueryObj - jquery对象
     * @param {string} className - jquery控件的类名
     * @author chenchangqing 20180526
     */
    getControlValue: function(jqueryObj) {
        var ret = "",
            opts = null;
        if (jqueryObj.hasClass(Controls.ComboBox)) {
            opts = jqueryObj.combobox("options");
            if (opts.multiple === true) {
                var valueArr = jqueryObj.combobox("getValues");
                ret = valueArr.toString();
            } else {
                ret = jqueryObj.combobox("getValue");
            }
        } else if (jqueryObj.hasClass(Controls.CheckBox)) {
            var checkValue = jqueryObj.checkbox("getValue");
            var label = jqueryObj.attr("label");
            label = (!label || label === "") ? jqueryObj.attr("value") : label;
            ret = checkValue ? label : "";
        } else if (jqueryObj.hasClass(Controls.Radio)) {
            var checkValue = jqueryObj.radio("getValue");
            var label = jqueryObj.attr("label");
            label = (!label || label === "") ? jqueryObj.attr("value") : label;
            ret = checkValue ? label : "";
        } else if (jqueryObj.hasClass(Controls.DateBox)) {
            ret = jqueryObj.datebox("getValue");
        } else if (jqueryObj.hasClass(Controls.DateTimeBox)) {
            ret = jqueryObj.datetimebox("getValue");
        } else if (jqueryObj.hasClass(Controls.ValidateBox)) {
            ret = jqueryObj.val();
        } else if (jqueryObj.hasClass(Controls.NumberBox)) {
            ret = jqueryObj.numberbox("getValue");
        } else if (jqueryObj.hasClass(Controls.TimeSpinner)) {
            ret = jqueryObj.timespinner("getValue");
        } else {
            ret = jqueryObj.val();
        }

        return ret;
    },

    setControlValue: function(jqueryObj, dataValue) {
        if (jqueryObj.hasClass(Controls.ComboBox)) {
            jqueryObj.combobox("setValue", dataValue);
        } else if (jqueryObj.hasClass(Controls.CheckBox)) {
            var curLabel = jqueryObj.attr("label");
            if (!curLabel || curLabel === "") {
                curLabel = jqueryObj.attr("value");
            }
            jqueryObj.checkbox("setValue", curLabel == dataValue);
            jqueryObj.checkbox("options").checked = (curLabel == dataValue);
        } else if (jqueryObj.hasClass(Controls.Radio)) {
            var curLabel = jqueryObj.attr("label");
            if (!curLabel || curLabel === "") {
                curLabel = jqueryObj.attr("value");
            }
            jqueryObj.radio("setValue", curLabel == dataValue);
            jqueryObj.radio("options").checked = (curLabel == dataValue);
        } else if (jqueryObj.hasClass(Controls.DateBox)) {
            jqueryObj.datebox("setValue", dataValue);
        } else if (jqueryObj.hasClass(Controls.DateTimeBox)) {
            jqueryObj.datetimebox("setValue", dataValue);
        } else if (jqueryObj.hasClass(Controls.ValidateBox)) {
            jqueryObj.val(dataValue);
        } else if (jqueryObj.hasClass(Controls.NumberBox)) {
            jqueryObj.numberbox("setValue", dataValue);
        } else if (jqueryObj.hasClass(Controls.TimeSpinner)) {
            jqueryObj.timespinner("setValue", dataValue);
        } else {
            jqueryObj.val(dataValue);
        }
    },

    disableEditControls: function(ignoreSelector) {
        $("." + Controls.ValidateBox).attr("disabled", true);
        $("." + Controls.DateBox).datebox("disable");
        $("." + Controls.DateTimeBox).datetimebox("disable");
        $("." + Controls.TimeSpinner).timespinner("disable");
        $("." + Controls.CheckBox).checkbox("disable");
        $("." + Controls.LinkButton).linkbutton("disable");
        $("." + Controls.NumberBox).numberbox("disable");
        $("." + Controls.SearchBox).searchbox("disable");
        $("." + Controls.Combo).combo("disable");
        $("." + Controls.ComboBox).combobox("disable");
        // $("#" + Controls.SwitchBox).switchbox("disable");
        $("." + Controls.FileBox).filebox("disable");
        $("." + Controls.Radio).radio("disable");
        $("input[type='text']").attr("disabled", true);

        this.setControlsAbleStatus(ignoreSelector, "enable");
    },

    enableSpecicalControls:function(permission){
        $(permission.enableControls).each(function(index,item){
            var readOnly=$(this).attr("readOnly");
            if(readOnly){
                $(this).removeAttr("readOnly");
            }
        });
        operDataManager.setControlsAbleStatus(permission.enableControls,"enable");
    },

    disableSelectedControls: function(selector) {
        this.setControlsAbleStatus(selector, "disable");
    },

    setControlsAbleStatus: function(selector, ableStatus) {
        $(selector).each(function(index, el) {
            if ($(this).hasClass(Controls.ValidateBox)) {
                $(this).attr("disabled", ableStatus === "disable");
            } else if ($(this).hasClass(Controls.DateBox)) {
                $(this).datebox(ableStatus);
            } else if ($(this).hasClass(Controls.DateTimeBox)) {
                $(this).datetimebox(ableStatus);
            } else if ($(this).hasClass(Controls.TimeSpinner)) {
                $(this).timespinner(ableStatus);
            } else if ($(this).hasClass(Controls.CheckBox)) {
                $(this).checkbox(ableStatus);
            } else if ($(this).hasClass(Controls.LinkButton)) {
                $(this).linkbutton(ableStatus);
            } else if ($(this).hasClass(Controls.NumberBox)) {
                $(this).numberbox(ableStatus);
            } else if ($(this).hasClass(Controls.SearchBox)) {
                $(this).searchbox(ableStatus);
            } else if ($(this).hasClass(Controls.Combo)) {
                $(this).combo(ableStatus);
            } else if ($(this).hasClass(Controls.SwitchBox)) {
                $(this).switchbox(ableStatus);
            } else if ($(this).hasClass(Controls.ComboBox)) {
                $(this).combobox(ableStatus);
            } else if ($(this).hasClass(Controls.FileBox)) {
                $(this).filebox(ableStatus);
            } else if ($(this).hasClass(Controls.Radio)) {
                $(this).radio(ableStatus);
            } else {
                if (ableStatus === "enable") {
                    $(this).removeAttr("disabled");
                } else {
                    $(this).attr("disabled", true);
                }

            }
        });
    },

    getControlAbleStatus: function(jqueryObj) {
        var ret = true;
        if (jqueryObj.hasClass(Controls.ValidateBox)) {
            ret = jqueryObj.attr("disabled") !== "true";
        } else if (jqueryObj.hasClass(Controls.DateBox)) {
            ret = jqueryObj.datebox("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.DateTimeBox)) {
            ret = jqueryObj.datetimebox("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.TimeSpinner)) {
            ret = jqueryObj.timespinner("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.CheckBox)) {
            //ret=jqueryObj.checkbox("options").disabled===false;
            ret = jqueryObj.parent().hasClass("disabled") === false;
        } else if (jqueryObj.hasClass(Controls.LinkButton)) {
            ret = jqueryObj.linkbutton("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.NumberBox)) {
            ret = jqueryObj.numberbox("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.SearchBox)) {
            ret = jqueryObj.searchbox("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.Combo)) {
            ret = jqueryObj.combo("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.SwitchBox)) {
            ret = jqueryObj.switchbox("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.ComboBox)) {
            ret = jqueryObj.combobox("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.FileBox)) {
            ret = jqueryObj.filebox("options").disabled === false;
        } else if (jqueryObj.hasClass(Controls.Radio)) {
            //ret=jqueryObj.radio("options").disabled===false;
            ret = jqueryObj.parent().hasClass("disabled") === false;
        }
        return ret;
    },

    setFormDataValue: function(formItemSelector, checkBoxId, checkValue) {
        var dataValue = null;
        var valueArr = [];
        var scoreArr = [];
        var checkSelector = "input[data-formitem='" + formItemSelector + "']";
        if ($(checkSelector).length > 0) {
            $(checkSelector).each(function(checkInd, checkItem) {
                if ($(checkItem).attr("id") !== checkBoxId || checkValue === false) return;
                if (valueArr.length > 0) valueArr.push(splitchar.comma);
                if (scoreArr.length > 0) scoreArr.push(splitchar.comma);
                var curLabel = $(checkItem).attr("label");
                if (!curLabel || curLabel === "") {
                    curLabel = $(checkItem).attr("value");
                }
                valueArr.push(curLabel);
                if ($(checkItem).attr("data-score")) {
                    scoreArr.push($(checkItem).attr("data-score"))
                }
            });
            dataValue = valueArr.join(splitchar.empty);
            $("#" + formItemSelector).attr("data-value", dataValue);
            $("#" + formItemSelector).attr("data-score", scoreArr.join(splitchar.empty));
        }

    },

    isDataIntegrity:function(clsSelector){
        var ret=true;
        operDataManager.reloadPatInfo();
        if (this.operScheduleData && this.operScheduleData.OperStatusCode==="Stop"){
            return ret;
        }
        $(clsSelector).each(function(index,el){
            var selector = "#" + $(el).attr("id");
            var enabled=operDataManager.getOperDataAbleStatus(selector);
            if(enabled===false) return;
            var required=$(selector).attr("data-required");
            if(required!=="Y"){
                return;
            }
            
            var dataRowId=$(selector).attr("data-rowid");
            var dataValue=$(selector).attr("data-value");
            var dataScore=$(selector).attr("data-score");
            if((dataRowId && dataRowId!=="") && ((dataValue && dataValue!=="") || (dataScore && dataScore!==""))) return;

            var hasDirtyValue=operDataManager.existsDirtyValue(selector);
            if(hasDirtyValue) return;
            ret=false;
        });
        return ret;
    },

    isDataIntegrityNew:function(clsSelector){
        var ret=true,messages=[];
        operDataManager.reloadPatInfo();
        if (this.operScheduleData && this.operScheduleData.OperStatusCode==="Stop"){
            return ret;
        }
        $(clsSelector).each(function(index,el){
            var selector = "#" + $(el).attr("id");
            var enabled=operDataManager.getOperDataAbleStatus(selector);
            if(enabled===false) return;
            var required=$(selector).attr("data-required");
            if(required!=="Y"){
                return;
            }
            
            var dataRowId=$(selector).attr("data-rowid");
            var dataValue=$(selector).attr("data-value");
            var dataScore=$(selector).attr("data-score");
            var dataMsg=$(selector).attr("data-msg");
            if((dataRowId && dataRowId!=="") && ((dataValue && dataValue!=="") || (dataScore && dataScore!==""))) return;

            var hasDirtyValue=operDataManager.existsDirtyValue(selector);
            if(hasDirtyValue) return;
            ret=false;
            messages.push("未选择"+dataMsg);
        });
        var message="";
        if(messages.length>0){
            message=messages.join(",");
        }
        return {integrity:ret,message:message};
    },

    existsDirtyValue:function(selector){
        var ret=false;
        var valueArr = [];
        var dataValue = null;
        var enabled = operDataManager.getControlAbleStatus($(selector));
        if (enabled === false) return;
        var checkSelector = "input[data-formitem='" + $(selector).attr("id") + "']";
        if ($(checkSelector).length > 0) {
            var controlEnabled;
            $(checkSelector).each(function(checkInd, checkItem) {
                enabled = operDataManager.getControlAbleStatus($(checkItem));
                if (enabled === false)
                {
                    controlEnabled=false;
                    return;
                }
                var checkValue = false;
                if ($(checkItem).hasClass("hisui-checkbox")) {
                    checkValue = $(checkItem).checkbox("getValue");
                } else if ($(checkItem).hasClass("hisui-radio")) {
                    checkValue = $(checkItem).radio("getValue");
                }
                if (!checkValue) return;
                if (valueArr.length > 0) valueArr.push(splitchar.comma);
                var curLabel = $(checkItem).attr("label");
                if (!curLabel || curLabel === "") {
                    curLabel = $(checkItem).attr("value");
                }
                
                valueArr.push(curLabel);
            });
            if(controlEnabled===false) return;
            dataValue = valueArr.join(splitchar.empty);
        } else {
            dataValue = operDataManager.getControlValue($(selector));
        }
        var dataControl=$(selector).attr("data-control");
        if(dataControl && dataControl==="N"){
            dataValue=$(selector).attr("data-value");
        }
        var dataScore = $(selector).attr("data-score");
        var operDataId = $(selector).attr("data-rowid");
        // 如果不是已保存过的数据，且数据值或分数值为空，那么不保存
        if ((!operDataId || operDataId === "") && (!dataValue || dataValue === "") && (!dataScore || dataScore === ""))
        {
            ret=false;
            return ret;
        }
        return true;
    },

    getOperDataAbleStatus:function(selector){
        var ret=operDataManager.getControlAbleStatus($(selector));
        var checkSelector = "input[data-formitem='" + $(selector).attr("id") + "']";
        if ($(checkSelector).length > 0) {
            $(checkSelector).each(function(checkInd, checkItem) {
                var enabled = operDataManager.getControlAbleStatus($(checkItem));
                if (enabled === false)
                {
                    ret=false;
                }
            });
        }
        return ret;
    },

    getFormOperDatas: function(clsSelector) {
        var valueArr = [];
        var dataValue = null;
        var operDatas = [];
        $(clsSelector).each(function(index, el) {
            valueArr.length = 0;
            dataValue = null;
            var selector = "#" + $(el).attr("id");
            var enabled = operDataManager.getControlAbleStatus($(selector));
            if (enabled === false) return;
            var checkSelector = "input[data-formitem='" + $(el).attr("id") + "']";
            if ($(checkSelector).length > 0) {
                var controlEnabled;
                $(checkSelector).each(function(checkInd, checkItem) {
                    enabled = operDataManager.getControlAbleStatus($(checkItem));
                    if (enabled === false)
                    {
                        controlEnabled=false;
                        return;
                    }
                    var checkValue = false;
                    if ($(checkItem).hasClass("hisui-checkbox")) {
                        checkValue = $(checkItem).checkbox("getValue");
                    } else if ($(checkItem).hasClass("hisui-radio")) {
                        checkValue = $(checkItem).radio("getValue");
                    }
                    if (!checkValue) return;
                    if (valueArr.length > 0) valueArr.push(splitchar.comma);
                    var curLabel = $(checkItem).attr("label");
                    if (!curLabel || curLabel === "") {
                        curLabel = $(checkItem).attr("value");
                    }
                    
                    valueArr.push(curLabel);
                });
                if(controlEnabled===false) return;
                dataValue = valueArr.join(splitchar.empty);
            } else {
                dataValue = operDataManager.getControlValue($(el));
            }
            var dataControl=$(selector).attr("data-control");
            if(dataControl && dataControl==="N"){
                dataValue=$(selector).attr("data-value");
            }
            var dataScore = $(el).attr("data-score");
            var operDataId = $(el).attr("data-rowid");
            // 如果不是已保存过的数据，且数据值或分数值为空，那么不保存
            if ((!operDataId || operDataId === "") && (!dataValue || dataValue === "") && (!dataScore || dataScore === "")) return;
            operDatas.push({
                RowId: $(el).attr("data-rowid"),
                RecordSheet: session.RecordSheetID,
                DataItem: $(el).attr("id"),
                DataValue: dataValue,
                UpdateUserID: session.UserID,
                ClassName: ANCLS.Model.OperData,
                DataScore: dataScore ? dataScore : ""
            });
        });

        return operDatas;
    },

    setFormOperDatas: function(operDatas) {
        if (!operDatas || operDatas.length <= 0) return;
        $.each(operDatas, function(index, operData) {
            if (!operData.DataItem || operData.DataItem === "") return;
            if ($("input[data-formitem='" + operData.DataItem + "']").length > 0) {
                operDataManager.initCheckStatus(operData);
            } else {
                operDataManager.setControlValue($("#" + operData.DataItem), operData.DataValue);
            }
            $("#" + operData.DataItem).attr("data-rowId", operData.RowId);
            $("#" + operData.DataItem).attr("data-value", operData.DataValue);
            $("#" + operData.DataItem).attr("data-score", operData.DataScore ? operData.DataScore : "");
            if ($("#" + operData.DataItem).hasClass("sign-img")){
                $("#" + operData.DataItem).attr("src",operData.DataValue);
            }
        });
    },

    saveOperDatas: function(selector) {
        var operDataSelector = (selector && selector != "") ? selector : ".operdata";
        
        var operDatas = operDataManager.getFormOperDatas(operDataSelector);
        if (!operDatas || !operDatas.length || operDatas.length <= 0) return;
        var jsonData = dhccl.formatObjects(operDatas);
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData,
            ClassName:ANCLS.BLL.OperData,
            MethodName:"SaveOperDatas"
        }, function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                var operDatas = operDataManager.getOperDatas();
                operDataManager.setFormOperDatas(operDatas);
            });
        });
    },

    saveSignedDatas: function(selector, signedData, successfn) {
        signedData.ClassName = ANCLS.Model.Signature;
        signedData.RecordSheet = session.RecordSheetID;
        var operDataSelector = (selector && selector != "") ? selector : ".operdata";
        
        var operDatas = operDataManager.getFormOperDatas(operDataSelector);
        if (!operDatas || !operDatas.length || operDatas.length <= 0) return false;
        var signedDatas = [];
        signedDatas.push(signedData);
        for (var i = 0; i < operDatas.length; i++) {
            signedDatas.push(operDatas[i]);
        }
        var jsonData = dhccl.formatObjects(signedDatas);
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData,
            ClassName: ANCLS.BLL.OperData,
            MethodName: "SaveSignedDatas"
        }, function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                var operDatas = operDataManager.getOperDatas();
                operDataManager.setFormOperDatas(operDatas);
                if (successfn) {
                    successfn({
                        signImage: signedData.SignImageData
                    });
                }
            });
        });

        return true;
    },

    getOperAppData: function() {
        var operAppDataArr = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.OperScheduleList,
            QueryName: "FindOperScheduleList",
            Arg1: "",
            Arg2: "",
            Arg3: "",
            Arg4: session.OPSID,
            ArgCnt: 4
        }, "json");
        var appData = null;
        if (operAppDataArr && operAppDataArr.length && operAppDataArr.length > 0) {
            appData = operAppDataArr[0];
        }
        this.operScheduleData=appData;
        return appData;
    },

    getOperDatas: function() {
        var operDatas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.OperData,
            QueryName: "FindOperDataBySheet",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        }, "json");
        return operDatas;
    },


    getChecked: function(elementID) {
        return $("#" + elementID).checkbox("getValue") ? "checked" : "";
    },

    printCount:function(recordSheetId,moduleCode,alertMsg){
        var count=dhccl.runServerMethod(ANCLS.BLL.PrintLog,"GetPrintCount",recordSheetId,moduleCode);
        if(alertMsg && alertMsg===true && Number(count)>0){
            // $.messager.alert("提示","表单已打印"+count+"次。");
            alert("表单已打印"+count+"次。");
        }
        return count;
    },
    savePrintLog:function(recordSheetId,moduleCode,userId){
        var jsonData = dhccl.formatObjects([{
            RecordSheet:recordSheetId,
            Type:moduleCode,
            PrintUser:userId,
            ClassName:ANCLS.Model.PrintLog,
            RowId:""
        }]);
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData
        }, function(data) {
            
        });
    }
}