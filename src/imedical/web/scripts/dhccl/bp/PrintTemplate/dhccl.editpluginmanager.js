/**
 * 编辑框管理器
 * @param {*} opts 
 */


function EditPluginManager(opts) {
    this.pluginList = [];
    this.formulaData = [];

    this.sheetContext = opts.sheetContext;
    this.readonly = opts.readonly;
    this.operAppData = null;
    this.operDatas = null;
    this.signatureList = null;
    this.init();
}

EditPluginManager.prototype = {
    constructor: EditPluginManager,

    init: function () {
        this.operAppData = this.sheetContext.getCommonConstData();
        this.operDatas = this.sheetContext.getUserFillData();
        this.signatureList = this.sheetContext.getSignatureData();
    },

    setEditPluginList: function(editPluginInfoList){
        var $this = this;
        for(var i = 0; i < editPluginInfoList.length; i++){
            if($("#" + editPluginInfoList[i].code).length == 0){
                var editPluginInfo = $.extend({}, editPluginInfoList[i], {
                    onValueChanged: function(plugin){
                        $this.calculateFormula();
                    },
                    getUserFillData: function(){
                        return $this.getFormOperDatas();
                    }
                });
                var editPlugin = new EditPlugin(editPluginInfo);
                this.addEditPlugin(editPlugin);
            }
        }
    },

    addEditPlugin: function (editPlugin) {
        this.pluginList.push(editPlugin);

        if (editPlugin.areaItem.Formula) {
            this.formulaData.push({
                FormulaCode: editPlugin.areaItem.Code,
                FormulaDesc: editPlugin.areaItem.Formula
            });
        }

        if(this.readonly){
            editPlugin.disable();
        }

        //手术申请数据
        var value = this.operAppData[editPlugin.code];
        if (this.operAppData.hasOwnProperty(editPlugin.code) && editPlugin.areaItem) {
            editPlugin.dataSource = "OperSchedule";
            editPlugin.setValue(value);
            editPlugin.disable();
        } else if (editPlugin.areaItem && editPlugin.areaItem.ValueFromSchedule) {
            value = this.operAppData[editPlugin.areaItem.ValueFromSchedule];
            if (value) {
                editPlugin.dataSource = "OperData";
                editPlugin.setValue(value);
            }
        }

        //用户填写数据
        var operData = this.getOperDataByCode(editPlugin.code);
        if (editPlugin.areaItem && !editPlugin.areaItem.Group) {
            if (operData) {
                editPlugin.dataSource = "OperData";
                editPlugin.originalValue = operData.DataValue;
                editPlugin.RowId = operData.RowId;
                editPlugin.setValue(operData.DataValue);
            }
            if (!editPlugin.getValue() && editPlugin.areaItem.DefaultValue && editPlugin.editType != "checkbox") {
                editPlugin.dataSource = "OperData";
                editPlugin.originalValue = editPlugin.areaItem.DefaultValue;
                editPlugin.setValue(editPlugin.areaItem.DefaultValue);
            }
        }

        if (editPlugin.editType == "checkbox" && editPlugin.areaItem.Group) {
            var checkboxGroupOperData = this.getOperDataByCode(editPlugin.areaItem.Group);
            if (checkboxGroupOperData) {
                var groupValue = checkboxGroupOperData.DataValue;
                var rowId = checkboxGroupOperData.RowId;
                var groupValueArray = groupValue.split(',');
                if (editPlugin.areaItem.Desc && groupValueArray.indexOf(editPlugin.areaItem.Desc) >= 0) {
                    editPlugin.setValue(editPlugin.areaItem.Desc);
                    editPlugin.RowId = rowId;
                    editPlugin.originalValue = groupValue;
                } else if (editPlugin.areaItem.Code && groupValueArray.indexOf(editPlugin.areaItem.Code) >= 0) {
                    editPlugin.setValue(editPlugin.areaItem.Code);
                    editPlugin.RowId = rowId;
                    editPlugin.originalValue = groupValue;
                } else {
                    editPlugin.RowId = rowId;
                    editPlugin.setValue("");
                }
            }
        }

        //签名数据
        var signValue = this.getSignValueByCode(editPlugin.code);
        if (editPlugin.areaItem && signValue) {
            if (editPlugin.editType == "signature"){
                editPlugin.dataSource = "Signature";
                editPlugin.setValue(signValue);
            }

            if (editPlugin.editType == "imgsign"){
                editPlugin.dataSource = "imgsign";
                var base64Str = this.sheetContext.getSignImageByCode(editPlugin.code);
                editPlugin.setValue(base64Str);
            }
        }

        //checkbox设置默认值
        if (editPlugin.editType == "checkbox"){
            if(this.operDatas && editPlugin.areaItem.DefaultValue){
                if (this.operDatas.length == 0) {
                    editPlugin.setValue(editPlugin.areaItem.Desc ? editPlugin.areaItem.Desc : editPlugin.areaItem.Code);
                }
            }
        }
    },

    getEditPluginByCode: function (code) {
        for (var i = 0; i < this.pluginList.length; i++) {
            if (this.pluginList[i].code == code) {
                return this.pluginList[i];
            }
        }
        return null;
    },

    setValues: function () {
        this.operDatas = this.sheetContext.getUserFillData();
        if(this.operDatas == null) return;
        for (var i = 0; i < this.pluginList.length; i++) {
            var editPlugin = this.pluginList[i];
            var operData = this.getOperDataByCode(editPlugin.code);
            if (editPlugin.areaItem && operData && !editPlugin.areaItem.Group) {
                editPlugin.dataSource = "OperData";
                editPlugin.originalValue = operData.DataValue;
                editPlugin.RowId = operData.RowId;
                editPlugin.setValue(operData.DataValue);
            }

            if (editPlugin.editType == "checkbox" && editPlugin.areaItem.Group) {
                var checkboxGroupOperData = this.getOperDataByCode(editPlugin.areaItem.Group);
                if (checkboxGroupOperData) {
                    var groupValue = checkboxGroupOperData.DataValue;
                    var rowId = checkboxGroupOperData.RowId;
                    var groupValueArray = groupValue.split(',');
                    if (editPlugin.areaItem.Desc && groupValueArray.indexOf(editPlugin.areaItem.Desc) >= 0) {
                        editPlugin.setValue(editPlugin.areaItem.Desc);
                        editPlugin.RowId = rowId;
                        editPlugin.originalValue = groupValue;
                    } else if (editPlugin.areaItem.Code && groupValueArray.indexOf(editPlugin.areaItem.Code) >= 0) {
                        editPlugin.setValue(editPlugin.areaItem.Code);
                        editPlugin.RowId = rowId;
                        editPlugin.originalValue = groupValue;
                    } else {
                        editPlugin.RowId = rowId;
                        editPlugin.setValue("");
                    }
                }
            }
        }
    },

    getSignValueByCode: function (code) {
        var value = "";
        if (this.signatureList && this.signatureList.length > 0) {
            for (var i = 0; i < this.signatureList.length; i++) {
                var signature = this.signatureList[i];
                var signCode = signature.SignCode;
                var fullName = signature.FullName;
                if (signCode == code) {
                    value = fullName;
                    break;
                }
            }
        }
        return value;
    },

    getOperDataByCode: function (code) {
        for (var i = 0; i < this.operDatas.length; i++) {
            if (this.operDatas[i].DataItem == code) {
                return this.operDatas[i];
            }
        }
        return null;
    },

    getValueByCode: function(code){
        var value = "";
        if(this.operAppData){
            value = this.operAppData[code];
        }
        if(!value && this.operDatas){
            var operData = this.getOperDataByCode(code);
            if (operData) value = operData.DataValue;
        }
        return value;
    },

    saveOperDatas: function (onSave) {
        var $this = this;

        var operDatas = this.getFormOperDatas();
        if (!operDatas || !operDatas.length || operDatas.length <= 0) {
            $.messager.alert("提示", "无需要保存数据!", "info");
            return;
        }

        this.sheetContext.saveUserFillData(operDatas, function(result){
            $this.setValues();
            if(onSave) onSave(result);
        })
    },

    checkRequired: function () {
        for (var i = 0; i < this.pluginList.length; i++) {
            var plugin = this.pluginList[i];
            if (!plugin.validate()) {
                $.messager.alert("提示", plugin.areaItem.Desc + " 不能为空！", "error");
                return false;
            }
        }
        return true;
    },

    getFormOperDatas: function () {
        var formOperDatas = [];
        for (var i = 0; i < this.pluginList.length; i++) {
            var plugin = this.pluginList[i];
            var nowValue = plugin.getValue();
            if(nowValue.indexOf(String.fromCharCode(2)) >= 0){
                $.messager.alert(plugin.areaItem.Desc+"含有特殊字符！请重新填写！")
                return [];
            }

            if(nowValue.indexOf('\t') >= 0){
                nowValue = nowValue.replace(/[\t]+/g,'    ');
            }
            
            if (plugin.dataSource == "OperSchedule") continue;
            if (plugin.editType == "imgsign") continue;
            if (plugin.editType == "signature") continue;
            if (plugin.editType == "checkbox" && plugin.areaItem.Group) continue;
            if (plugin.editType == "qrCode") continue;
            if (this.operAppData[plugin.code]) continue;

            var rowId = plugin.RowId;
            var originalValue = plugin.originalValue;
            var dataNote = "";
            if (plugin.editType == "combobox") dataNote = plugin.getPrintValue();
            
            if (originalValue || nowValue) {
                formOperDatas.push({
                    rowId: rowId,
                    code: plugin.code,
                    desc: plugin.areaItem.Desc,
                    value: nowValue,
                    score: "",
                    dataNote: dataNote
                });
            }
        }

        var groupList = this.getGroupCodeList();
        for (var i = 0; i < groupList.length; i++) {
            var groupCode = groupList[i];
            var groupValue = this.getGroupCheckboxValue(groupCode);
            var rowId = groupValue.rowId;
            var nowValue = groupValue.value;

            formOperDatas.push({
                rowId: rowId,
                code: groupCode,
                desc: "",
                value: nowValue,
                score: "",
                dataNote: ""
            });
        }

        return formOperDatas;
    },

    getValueObject: function () {
        var valueObject = $.extend({}, this.operAppData);
        if(this.operDatas){
            for(var i = 0; i < this.operDatas.length; i++){
                var operData = this.operDatas[i];
                if(!valueObject.hasOwnProperty(operData.DataItem)){
                    valueObject[operData.DataItem] = operData.DataValue;
                }
            }
        }

        for (var i = 0; i < this.pluginList.length; i++) {
            var plugin = this.pluginList[i];
            var dataValue = plugin.getPrintValue();
            valueObject[plugin.code] = dataValue;
        }
        return valueObject;
    },

    showCurrentPageEditPlugin: function (currentPageNo) {
        for (var i = 0; i < this.pluginList.length; i++) {
            var plugin = this.pluginList[i];
            if (plugin.pageNo == currentPageNo) {
                plugin.show();
            } else {
                plugin.hide();
            }
        }
    },

    getGroupCodeList: function () {
        var groupList = [];
        for (var i = 0; i < this.pluginList.length; i++) {
            var plugin = this.pluginList[i];
            if (plugin.editType == "checkbox" && plugin.areaItem.Group) {
                if (groupList.indexOf(plugin.areaItem.Group) == -1) {
                    groupList.push(plugin.areaItem.Group);
                }
            }
        }
        return groupList;
    },

    getGroupCheckboxValue: function (groupCode) {
        var valArray = [];
        var rowId = "";
        for (var i = 0; i < this.pluginList.length; i++) {
            var plugin = this.pluginList[i];
            if (plugin.editType == "checkbox" && plugin.areaItem.Group == groupCode) {
                rowId = plugin.RowId;
                if (plugin.getValue()) {
                    if (plugin.areaItem.Desc) valArray.push(plugin.areaItem.Desc);
                    else if (plugin.areaItem.Code) valArray.push(plugin.areaItem.Code);
                }
            }
        }

        return {
            rowId: rowId,
            value: valArray.join(',')
        };
    },

    clearAllPlugin: function () {
        for (var i = 0; i < this.pluginList.length; i++) {
            this.pluginList[i].clear();
            this.pluginList[i].RowId = "";
        }
    },

    disableAllPlugin: function () {
        for (var i = 0; i < this.pluginList.length; i++) {
            this.pluginList[i].disable();
        }
    },

    enableAllPlugin: function () {
        for (var i = 0; i < this.pluginList.length; i++) {
            this.pluginList[i].enable();
        }
    },

    calculateFormula: function () {
        try {
            if (this.formulaData && this.formulaData.length > 0) {
                for (var i = 0; i < this.formulaData.length; i++) {
                    var formulaCode = this.formulaData[i].FormulaCode;
                    var formulaDesc = this.formulaData[i].FormulaDesc;
                    if (formulaCode == "" || formulaDesc == "") continue;
                    var result = this.calculateFields(formulaDesc);
                    var targetPlugin = this.getEditPluginByCode(formulaCode);
                    if (targetPlugin) {
                        targetPlugin.setValue(result);
                    }
                }
            }
        } catch (error) {
            console.error(error)
        }
    },

    /**
     * 计算多字段的值
     */
    calculateFields: function (formula) {
        var result = '';
        if (formula) {
            var reg = /{\S*?}/g;
            var matches = formula.matchRegAll(reg); //[...formula.matchAll(reg)];
            var length = matches.length;
            var match, field, value;
            var start = 0,
                end = 0,
                offset = 0;
            for (var i = 0; i < length; i++) {
                match = matches[i];
                field = match[0].slice(1, match[0].length - 1);
                value = '';
                var editPlugin = this.getEditPluginByCode(field);
                value = editPlugin.getScoreValue();
                start = match.index;
                end = start + match[0].length;
                formula = formula.slice(0, start + offset) + value + formula.slice(end + offset, formula.length);
                offset += value.length - field.length - 2;
            }
            result = execMathExpress(formula) + '';
            return result;
        }

        /**
         * 计算带括号的数学公式
         * 递归算法
         */
        function execMathExpress(formula) {
            var bracketReg = /\([\(,\S,\)]*\)/g;
            var matches = formula.matchRegAll(bracketReg);

            var length = matches.length;
            var match, formulaFragment, value;
            var start = 0,
                end = 0,
                offset = 0;
            for (var i = 0; i < length; i++) {
                match = matches[i];
                formulaFragment = match[0].slice(1, match[0].length - 1);
                value = '1';
                if (formulaFragment) {
                    if (formula.match(bracketReg)) value = execMathExpress(formulaFragment);
                    else value = simplyMathExpress(formulaFragment);
                }
                start = match.index;
                end = start + match[0].length;
                formula = formula.slice(0, start + offset) + value + formula.slice(end + offset, formula.length);
                offset += value.length - formulaFragment.length - 2;
            }

            return simplyMathExpress(formula);
        }

        /**
         * 计算简单数学公式,
         * 先只考虑顺序执行,后续有需要可以添加括号及执行优先级
         */
        function simplyMathExpress(formula) {
            var result = 0;
            var operatorReg = /[\-,\+,\*,\/,\%]/g;
            var matches = formula.matchRegAll(operatorReg); //[...formula.matchAll(operatorReg)];
            var length = matches.length;
            var start = 0,
                end = 0,
                value = 0;

            if (length > 0) result = Number(formula.slice(0, matches[0].index));
            for (var i = 0; i < length; i++) {
                match = matches[i];
                start = match.index + 1;
                end = i < length - 1 ? matches[i + 1].index : formula.length;
                value = Number(formula.slice(start, end));;

                switch (match[0]) {
                    case '+':
                        result = result + value;
                        break;
                    case '-':
                        result = result - value;
                        break;
                    case '*':
                        result = result * value;
                        break;
                    case '\/':
                        result = result / value;
                        break;
                    case '\%':
                        result = result % value;
                        break;
                    default:
                        result = result + value;
                        break;
                }
            }

            return result;
        }
    }
}

String.prototype.matchRegAll = function (regex) {
    if (!regex instanceof RegExp) return [];

    var subject = this,
        match,
        matches = [];

    while (match = regex.exec(subject)) {
        var zeroLengthMatch = !match[0].length;
        if (zeroLengthMatch && regex.lastIndex > match.index)
            regex.lastIndex--;
        if (zeroLengthMatch)
            regex.lastIndex++;
        else matches.push(match);
    }

    return matches;
}