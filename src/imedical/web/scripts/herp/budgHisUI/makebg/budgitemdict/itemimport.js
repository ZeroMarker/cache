addimportFun = function() {
    ///////////////////配置项编码///////////////////////
    var hospid = session['LOGON.HOSPID'];
    var userid = session['LOGON.USERID'];
    var $importwin;
    $importwin = $('#importwin').window({
        title: 'Excel导入',
        width: 480,
        height: 250,
        top: ($(window).height() - 250) * 0.5,
        left: ($(window).width() - 480) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-w-import',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose: function() { //关闭关闭窗口后触发
            $('#excelpath').filebox("clear");
            $('#budgItemTree').treegrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $importwin.window('open');
    $("#importSave").click(function() {
        var filelist = $('#excelpath').filebox("files");
        if (filelist.length == 0) {
            $.messager.popover({
                msg: '请选择要导入的Excel!',
                type: 'info',
                showType: 'show',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                    top: 10
                }
            });
            return
        }
        // showMask();
        var file = filelist[0];
        var reader = new FileReader();
        reader.readAsBinaryString(file);
        reader.onload = function(e) {
            if (reader.result) { reader.content = reader.result; }
            //In IE browser event object is null
            var data = e ? e.target.result : reader.content;
            wb = XLSX.read(data, {
                type: 'binary'
            });
            var json = to_json(wb)
                //          console.log(json);
            if (json.total < 2) {
                $.messager.popover({
                    msg: '要导入的Excel没有数据!',
                    type: 'info',
                    showType: 'show',
                    style: {
                        "position": "absolute",
                        "z-index": "9999",
                        left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                        top: 10
                    }
                });
                return
            } else {
                var errormsg = "",
                    data = "",
                    dataStr = "";
                for (i = 1; i <= json.total - 1; i++) {
                    var tmp = ""
                    var Year = json.rows[i].BID_Year == undefined ? tmp : json.rows[i].BID_Year;
                    var Code = json.rows[i].BID_Code == undefined ? tmp : json.rows[i].BID_Code;
                    var SuperCode = json.rows[i].BID_SuperCode == undefined ? tmp : json.rows[i].BID_SuperCode;
                    var Name = json.rows[i].BID_Name == undefined ? tmp : json.rows[i].BID_Name;
                    var NameAll = json.rows[i].BID_NameAll == undefined ? tmp : json.rows[i].BID_NameAll;
                    var Level = json.rows[i].BID_Level == undefined ? tmp : json.rows[i].BID_Level;
                    var TypeCodeFirst = json.rows[i].BID_TypeCodeFirst == undefined ? tmp : json.rows[i].BID_TypeCodeFirst;
                    var TypeCode = json.rows[i].BID_TypeCode == undefined ? tmp : json.rows[i].BID_TypeCode;
                    var Spell = json.rows[i].BID_Spell == undefined ? tmp : json.rows[i].BID_Spell;
                    var Direction = json.rows[i].BID_Direction == undefined ? tmp : json.rows[i].BID_Direction;
                    var IsLast = json.rows[i].BID_IsLast == undefined ? tmp : json.rows[i].BID_IsLast;
                    var IsSpecial = json.rows[i].BID_IsSpecial == undefined ? tmp : json.rows[i].BID_IsSpecial;
                    var SubjClassMT = json.rows[i].BID_SubjClassMT == undefined ? tmp : json.rows[i].BID_SubjClassMT;
                    var SubjClassPay = json.rows[i].BID_SubjClassPay == undefined ? tmp : json.rows[i].BID_SubjClassPay;
                    var IsCash = json.rows[i].BID_IsCash == undefined ? tmp : json.rows[i].BID_IsCash;
                    var SubjClassCostType = json.rows[i].BID_SubjClassCostType == undefined ? tmp : json.rows[i].BID_SubjClassCostType;
                    var UseRange = json.rows[i].BID_UseRange == undefined ? tmp : json.rows[i].BID_UseRange;
                    var IdxType = json.rows[i].BID_IdxType == undefined ? tmp : json.rows[i].BID_IdxType;
                    var EditMod = json.rows[i].BID_EditMod == undefined ? tmp : json.rows[i].BID_EditMod;
                    var EditMeth = json.rows[i].BID_EditMeth == undefined ? tmp : json.rows[i].BID_EditMeth;
                    var IsCarry = json.rows[i].BID_IsCarry == undefined ? tmp : json.rows[i].BID_IsCarry;
                    var ProperyType = json.rows[i].BID_ProperyType == undefined ? tmp : json.rows[i].BID_ProperyType;
                    var IsCalc = json.rows[i].BID_IsCalc == undefined ? tmp : json.rows[i].BID_IsCalc;
                    var Formula = json.rows[i].BID_Formula == undefined ? tmp : json.rows[i].BID_Formula;
                    var FormulaDesc = json.rows[i].BID_FormulaDesc == undefined ? tmp : json.rows[i].BID_FormulaDesc;
                    var IsResult = json.rows[i].BID_IsResult == undefined ? tmp : json.rows[i].BID_IsResult;
                    var CalUnitDR = json.rows[i].BID_CalUnitDR == undefined ? tmp : json.rows[i].BID_CalUnitDR;
                    var IsNew = json.rows[i].BID_IsNew == undefined ? tmp : json.rows[i].BID_IsNew;
                    var ProjDuTYD = json.rows[i].BID_ProjDuTYD == undefined ? tmp : json.rows[i].BID_ProjDuTYD;
                    var AuDepdrOne = json.rows[i].BID_AuDepdrOne == undefined ? tmp : json.rows[i].BID_AuDepdrOne;
                    var AuDepdrTwo = json.rows[i].BID_AuDepdrTwo == undefined ? tmp : json.rows[i].BID_AuDepdrTwo;
                    var IsGovBuy = json.rows[i].BID_IsGovBuy == undefined ? tmp : json.rows[i].BID_IsGovBuy;
                    var UpperLimitBudgValue = json.rows[i].BID_UpperLimitBudgValue == undefined ? tmp : json.rows[i].BID_UpperLimitBudgValue;
                    var count = "";
                    count = i + 2;
                    if (Name != "" & Spell == "") {
                        Spell = makePy(Name);
                    }
                    if (Year == "" || Code == "" || SuperCode == "" || Name == "" || NameAll == "" || Level == "" || TypeCodeFirst == "" || TypeCode == "" || !(IsLast == 0 || IsLast == 1) || UseRange == "" || EditMod == "" || IsResult == "") {
                        if (errormsg == "") {
                            errormsg = count;

                        } else {
                            errormsg = errormsg + "、" + count;
                        }
                    } else {
                        if (Level == 1) { SuperCode = "00" }
                        dataStr = "|" + hospid + "|" + Year + "|" + Code + "|" + SuperCode + "|" + Name + "|" + NameAll + "|" + Level + "|" + TypeCodeFirst + "|" + TypeCode +
                            "|" + Spell + "|" + Direction + "|" + IsLast + "|" + IsSpecial + "|" + SubjClassMT + "|" + SubjClassPay + "|" + IsCash + "|" + SubjClassCostType +
                            "|" + UseRange + "|" + IdxType + "|" + EditMod + "|" + EditMeth + "|" + IsCarry + "|" + ProperyType + "|" + IsCalc + "|" + Formula +
                            "|" + FormulaDesc + "|" + IsResult + "|" + CalUnitDR + "|" + ProjDuTYD + "|" + AuDepdrOne + "|" + AuDepdrTwo + "|" + IsGovBuy + "|" + UpperLimitBudgValue + "|" + count
                        if (data == "") {
                            data = dataStr;
                        } else {
                            data = data + "^" + dataStr;
                            if ((count - 2) % 300 == 0) {
                                data = data + "&&"
                            }
                        }
                    }
                }
                if (errormsg != "") {
                    $.messager.popover({
                        msg: '第' + errormsg + '行数据不完整',
                        type: 'error',
                        showType: 'show',
                        style: {
                            "position": "absolute",
                            "z-index": "9999",
                            left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                            top: 10
                        }
                    });
                    return
                } else {
                    var dataarry = data.split("&&");
                    var len = dataarry.length;
                    for (j = 0; j <= len - 1; j++) {
                        $.m({
                                ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
                                MethodName: 'ExcelImport',
                                data: dataarry[j]
                            },
                            function(Data) {
                                var num = j + 1;
                                if (Data == 0) {
                                    $.messager.popover({
                                        msg: '第' + num + '批记录导入成功！',
                                        type: 'success',
                                        showType: 'show',
                                        style: {
                                            "position": "absolute",
                                            "z-index": "9999",
                                            left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                                            top: 10
                                        }
                                    });
                                } else {
                                    $.messager.popover({
                                        msg: Data,
                                        type: 'error',
                                        showType: 'show',
                                        style: {
                                            "position": "absolute",
                                            "z-index": "9999",
                                            left: document.body.scrollLeft / 2 + document.documentElement.scrollLeft / 2,
                                            top: 10
                                        }
                                    });
                                }
                            }
                        );
                    }

                }
            }
            // hideMask();
        }


        function to_json(workbook) {
            //取 第一个sheet 数据
            var jsonData = {};
            var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);
            jsonData.rows = result;
            jsonData.total = result.length
            return jsonData //JSON.stringify(jsonData);
        };

    });
    //关闭 
    $("#importClose").unbind('click').click(function() {
        $importwin.window('close');
    });

};