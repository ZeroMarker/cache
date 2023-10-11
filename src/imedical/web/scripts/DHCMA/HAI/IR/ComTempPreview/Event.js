﻿function InitReportWinEvent(obj) {
    //初始化报告信息
    obj.RegExt_Refresh = function () {
        //下拉菜单+日期置空
        var RegExtDataList = $cm({
            ClassName: "DHCHAI.IRS.ComTemplateDefSrv",
	        QueryName: "QryExpRegType",
	        aRegTypeID: RegTypeID,
            rows: 999
        }, false);
        if (RegExtDataList) {
            var arrDT = RegExtDataList.rows;
            for (var ind = 0; ind < arrDT.length; ind++) {
                var rd = arrDT[ind];
                if (!rd) continue;
                var ItemDr = rd.ID;
                var DataType = rd.DatCode;
                var ItemCode = rd.Code;

                var ItemID = parseInt(ItemCode);
                if (DataType == "DD") {
                    $("#" + ItemID).datebox('setValue', "");
                }
                if (DataType == "S") {
                    $("#" + ItemID).combobox('clear');
                }
            }
        }
        //加载报告填写内容
        var RegExtDataList = $cm({
            ClassName: "DHCHAI.IRS.ComTempRepSrv",
            QueryName: "QryExpExtInfo",
            aRepID: ReportID,
            rows: 999
        }, false);

        if (RegExtDataList != '') {
            if (RegExtDataList.total != 0) {
                var arrDT = RegExtDataList.rows;
                for (var ind = 0; ind < arrDT.length; ind++) {
                    var rd = arrDT[ind];
                    if (!rd) continue;

                    var DataType = rd.DataType;
                    var ItemCode = rd.Code;
                    var ResultID = rd.ResultID;
                    var ResultCode = rd.ResultCode;
                    var ResultDesc = rd.ResultDesc;
                    var ResultTxt = rd.ResultTxt;
                    var ResultList = rd.ResultList;

                    var ItemID = parseInt(ItemCode);
                    //单选字典+单选长字典+是否+有无
                    if ((DataType == "DS") || (DataType == "DSL") || (DataType == "B1") || (DataType == "B2")) {
                        if (!ResultID) continue;
                        $HUI.radio('#' + ItemID + ResultID).setValue(true);

                    }
                    //多选字典+多选长字典
                    if ((DataType == "DB") || (DataType == "DBL")) {
                        if (ResultList == "") continue;
                        var Len = ResultList.split(",").length;
                        for (var jnd = 0; jnd < Len; jnd++) {
                            var Result = ResultList.split(",")[jnd];

                            $('#' + ItemID + Result).checkbox('setValue', true)
                        }
                    }
                    //文本类型
                    if ((DataType == "T") || (DataType == "TL") || (DataType == "N0") || (DataType == "N1") || (DataType == "TB")) {
                        $('#' + ItemID).val(ResultTxt);
                    }
                    //日期类型
                    if (DataType == "DD") {
                        $('#' + ItemID).datebox('setValue', ResultTxt);
                    }
                    if (DataType == "S") {
                        if (!ResultID) continue;
                        $("#" + ItemID).combobox('setValue', ResultID);
                        $("#" + ItemID).combobox('setText', ResultDesc);
                    }
                        //单选字典
                    if (DataType == "DST") {
                        if (!ResultID) continue;
                         $HUI.radio('#' + ItemID + ResultID).setValue(true);
                         $('#' + ItemID + ResultID).next().next().val(ResultTxt);
                    }
                }
            }
        }
    }
    
    //保存报告信息
    obj.RegExt_Save = function () {
        //模块
        var RegExtDataList = $cm({
            ClassName: "DHCHAI.IRS.ComTemplateDefSrv",
	        QueryName: "QryExpRegType",
	        aRegTypeID: RegTypeID,
	        rows:999
        }, false);
        var InputRegExts = "";
        for (var ind = 0; ind < RegExtDataList.total; ind++) {
            var RegExtData = RegExtDataList.rows[ind];
            var RegExtCode = RegExtData.TypeCode;
            var DicID = RegExtData.TypeID;
			/*/ 报告大块信息？？？？
            var DicID = $m({
                ClassName: "DHCHAI.BT.Dictionary",
                MethodName: "GetIDByCode",
                aTypeCode: "BPItemType",
                aCode: RegExtCode,
                rows: 999
            }, false);*/
            if (DicID) {
                //职业暴露扩展项目
                var RegExtDicDataList = $cm({
                    ClassName: "DHCHAI.IRS.ComTemplateDefSrv",
                    QueryName: "QryComTempTypeExt",
                    aTypeID: RegTypeID,
                    aExtTypeID: DicID,
                    rows: 999
                }, false);
            } else {
                return false;
            }
            //加载具体信息
            if (RegExtDicDataList) {
                var arrDT = RegExtDicDataList.rows;
                for (var jnd = 0; jnd < arrDT.length; jnd++) {
                    var rd = arrDT[jnd];
                    if (!rd) continue;
                    var ItemDr = rd.ID;
                    var ItemCode = parseInt(rd.Code);
                    var ItemDesc = rd.Desc;
                    var DataType = rd.DatCode;
                    var Required = rd.IsRequired;
                    var ResultDr = '';
                    var ResultList = '';
                    var ResultTxt = '';
                    var ActUserDr = $.LOGON.USERID;
                    var TypeDesc = rd.TypeDesc;
                    var TypeCode = rd.TypeCode;

                    var ItemName = parseInt(ItemCode);
                    var ItemID = parseInt(ItemCode);
                    //单选+单选长字典+有无+是否
                    if ((DataType == "DS") || (DataType == "DSL") || (DataType == "B1") || (DataType == "B2")) {
                        ResultDr = Common_RadioValue(ItemName);
                    }
                    //多选+多选长字典
                    if ((DataType == "DB") || (DataType == "DBL")) {
                        $("input[name='" + ItemCode + "']:checked").each(function () {
                            ResultList = ResultList + $(this).val() + "#";
                        });
                        if (ResultList != "") { ResultList = ResultList.substring(0, ResultList.length - 1); }
                    }
                    //文本+长文本+大文本+数值+日期
                    if ((DataType == "T") || (DataType == "TL") || (DataType == "TB") || (DataType == "N0") || (DataType == "N1") || (DataType == "DD")) {
                        if (DataType == "DD") {								//日期
                            var ResultTxt = $("#" + ItemID).datebox('getValue');
                        }
                        else {
                            var ResultTxt = $("#" + ItemID).val();
                        }
                        //完整性判断
                        if ((ResultTxt != "") && (DataType == "N0")) {    	//整数类型   
                            var type = /(^[0-9]\d*$)/;
                            if (!type.test(ResultTxt)) {
                                $.messager.alert("提示", ItemDesc + "只允许输入0-9的数字!", 'info');
                                return false;
                            }
                        }
                        if ((ResultTxt != "") && (DataType == "N1")) {    	//小数类型
                            var regu = /^[0-9]+\.?[0-9]*$/; //小数
                            if (!regu.test(ResultTxt)) {
                                $.messager.alert("提示", ItemDesc + "只允许输入小数的数字!", 'info');
                                return false;
                            }
                        }
                        if ((ResultTxt != "") && (DataType == "DD")) {  	//日期类型
                            if (Common_GetDate(new Date()) < ResultTxt) {
                                $.messager.alert("提示", ItemDesc + "不能在当前日期之后!", 'info');
                                return false;
                            }
                        }
                    }
                    //下拉框
                    if (DataType == "S") {
                        var ResultDr = $("#" + ItemID).combobox('getValue');
                    }
                    if (DataType=="DST"){
                         $("input[name='"+ItemName+"']:checked").each(function(){
                              ResultDr = $(this).val(); 
                              
                              ResultTxt= $(this).next().next().val();
                        });
                        if ((Required == '1') && (ResultDr == "")&& (ResultTxt == "")){
                             $.messager.alert("提示", TypeDesc + '选项必填!', 'info');
                             return false;
                        }
                    }
                    //必选
                    if ((Required == '1') && ((ResultDr == "") && (ResultList == "") && (ResultTxt == ""))) {
                        $.messager.alert("提示", TypeDesc + '中的' + ItemDesc + '不允许为空!', 'info');
                        return false;
                    }
                    var TempRepID = $m({
                        ClassName: "DHCHAI.IR.ComTempRep",
                        MethodName: "GetIDByItemDr",
                        aRegTypeID: RegTypeID,
                        aReportID: ReportID,
                        aItemDr: ItemDr
                    }, false);
                    var InputRegExt = TempRepID;
                    InputRegExt = InputRegExt + "^" + RegTypeID;
                    InputRegExt = InputRegExt + "^" + ReportID;
                    InputRegExt = InputRegExt + "^" + ItemDr;		//关联项目
                    InputRegExt = InputRegExt + "^" + ItemDesc;
                    InputRegExt = InputRegExt + "^" + DataType;   //5
                    InputRegExt = InputRegExt + "^" + ResultDr;
                    InputRegExt = InputRegExt + "^" + ResultList;
                    InputRegExt = InputRegExt + "^" + ResultTxt;
                    InputRegExt = InputRegExt + "^" + '';
                    InputRegExt = InputRegExt + "^" + '';         //10
                    InputRegExt = InputRegExt + "^" + ActUserDr;
                    
                    InputRegExts = InputRegExts + "&" + InputRegExt;	 //保存多条
                }
            }
        }
        if (InputRegExts == "") {
            $.messager.alert("提示", '报告信息不能为空!', 'info');
            return "";
        }
        return InputRegExts;
    }
}

