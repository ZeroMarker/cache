 // DHCPEOccupationalInfo.hisui.js
 var init = function() {
     
     $("#PIADM_RowId").val(PreAdmId);
     
     
     $(document).ready(function() {
        $cm({
                     ClassName: "web.DHCPE.OccupationalDisease",
                     MethodName: "GetPreOccuInfo",
                     PreIADM: PreAdmId
                 }, function(jsonData) {
                     if (jsonData.code == "0") {
                         if (jsonData.msg != "") {
                             setValueById("Industry", jsonData.msg.Industry);
                             setValueById("Typeofwork", jsonData.msg.WorkType);
                             setValueById("WorkNo", jsonData.msg.JobNumber);
                             setValueById("AllWorkYear", jsonData.msg.WorkAgeY);
                             setValueById("AllWorkMonth", jsonData.msg.WorkAgeM);
                             setValueById("Category", jsonData.msg.OMEType);
                             SetHarmInfo(jsonData.msg.HarmInfo);
                         }
                     } else {
                         $.messager.alert("提示", jsonData.msg, "info");
                     }
                 });
        })
     
     
     // 基本信息
     $("#JBSave").click(function() {
         JBSave();
     });
     $("#JBNext").click(function() {
         JBNext();
     });
     // 职业史
     $("#ZYSave").click(function() {
         ZYSave();
     });
     $("#ZYDelete").click(function() {
         ZYDelete();
     });
     $("#ZYCancel").click(function() {
         ZYCancel();
     });
     $("#ZYNext").click(function() {
         ZYNext();
     });
     // 病史
     $("#BSSave").click(function() {
         BSSave();
     });
     $("#BSNext").click(function() {
         BSNext();
     });
     // 职业病史
     $("#ZYBSave").click(function() {
         ZYBSave();
     });
     $("#ZYBDelete").click(function() {
         ZYBDelete();
     });
     $("#ZYBCancel").click(function() {
         ZYBCancel();
     });
     $("#ZYBNext").click(function() {
         ZYBNext();
     });
     
     var ZYHistoryObj = $HUI.datagrid("#ZYHistory", {
         url: $URL,
         queryParams: {
             ClassName: "web.DHCPE.OccupationalDisease",
             QueryName: "FindOccuHistory",
             PreIADM: PreAdmId
         },
         pagination: true,
         displayMsg: "",
         pageSize: 20,
         fit: true,
         fitColumns: true,
         columns: [
             [
                 { field: 'TWorkTypeID', hidden: true, title: '工种id' },
                 { field: 'TProtectiveMeasureID', hidden: true, title: '防护id' },
                 { field: 'TStartDate', title: '开始日期' },
                 { field: 'TEndDate', title: '结束日期' },
                 { field: 'TWorkPlace', title: '工作单位' },
                 { field: 'TWorkDepartment', title: '部门' },
                 { field: 'TWorkShop', title: '车间' },
                 { field: 'TWorkTeam', title: '班组' },
                 { field: 'TWorkType', title: '工种' },
                 { field: 'TDailyWorkHours', title: '每日工时数' },
                 { field: 'THarmfulFactor', title: '接触危害' },
                 { field: 'TProtectiveMeasure', title: '防护措施' },
                 {
                     field: 'TRadiationFlag',
                     title: '放射史',
                     formatter: function(value, row, index) {
                         return value == "Y" ? "是" : "否";
                     }
                 },
                 { field: 'TRadiationType', title: '放射线种类' },
                 { field: 'TRadiationDose', title: '累积受照剂量' },
                 { field: 'TExRadHistory', title: '过量照射史' },
                 { field: 'TRemark', title: '备注' }
             ]
         ],
         onClickRow: function(rowIndex, rowData) {
             setValueById("StartDate", rowData.TStartDate);
             setValueById("EndDate", rowData.TEndDate);
             setValueById("WorkPlace", rowData.TWorkPlace);
             setValueById("WorkDepartment", rowData.TWorkDepartment);
             setValueById("WorkShop", rowData.TWorkShop);
             setValueById("ZYTypeofwork", rowData.TWorkTypeID);
             setValueById("DailyWorkHours", rowData.TDailyWorkHours);
             setValueById("HarmfulFactor", rowData.THarmfulFactor);
             setValueById("ProtectiveMeasure", rowData.TProtectiveMeasureID);
             setValueById("WorkTeam", rowData.TWorkTeam);
             setValueById("OHRadiationFlag", rowData.TRadiationFlag);

             if (rowData.TRadiationFlag != "Y") {
                 $('#OHRadiationType').attr("disabled", true);
                 $('#OHRadiationDose').attr("disabled", true);
                 $('#OHExRadHistory').attr("disabled", true);
             } else {
                 $('#OHRadiationType').attr("disabled", false);
                 $('#OHRadiationDose').attr("disabled", false);
                 $('#OHExRadHistory').attr("disabled", false);
             }
             setValueById("OHRadiationType", rowData.TRadiationType);
             setValueById("OHRadiationDose", rowData.TRadiationDose);
             setValueById("OHExRadHistory", rowData.TExRadHistory);
             setValueById("OHRemark", rowData.TRemark);
         }
     });

     var ZYBHistoryObj = $HUI.datagrid("#ZYBHistory", {
         url: $URL,
         queryParams: {
             ClassName: "web.DHCPE.OccupationalDisease",
             QueryName: "FindOccuDiseaseHistory",
             PreIADM: PreAdmId
         },
         pagination: true,
         displayMsg: "",
         pageSize: 20,
         fit: true,
         fitColumns: true,
         columns: [
             [
                 { field: 'TDiseaseDesc', width: '100', title: '病名' },
                 { field: 'TDiagnosisDate', width: '100', title: '诊断日期' },
                 { field: 'TDiagnosisPlace', width: '150', title: '诊断单位' },
                 { field: 'TProcess', width: '150', title: '治疗经过' },
                 { field: 'TReturn', width: '120', title: '归转' }
             ]
         ],
         onClickRow: function(rowIndex, rowData) {
             setValueById("DiseaseDesc", rowData.TDiseaseDesc);
             setValueById("DiagnosisDate", rowData.TDiagnosisDate);
             setValueById("DiagnosisPlace", rowData.TDiagnosisPlace);
             setValueById("Process", rowData.TProcess);
             setValueById("Return", rowData.TReturn);
         }
     });
     $("#ZYBTabItem").tabs({
         border: 1,
         onSelect: function(title, index) {
             if (title == $g('基本信息')) {
                 var RowId = $("#PIADM_RowId").val();
                 if (RowId == "") {
                     return false;
                 }
                 $cm({
                     ClassName: "web.DHCPE.OccupationalDisease",
                     MethodName: "GetPreOccuInfo",
                     PreIADM: RowId
                 }, function(jsonData) {
                     if (jsonData.code == "0") {
                         if (jsonData.msg != "") {
                             setValueById("Industry", jsonData.msg.Industry);
                             setValueById("Typeofwork", jsonData.msg.WorkType);
                             setValueById("WorkNo", jsonData.msg.JobNumber);
                             setValueById("AllWorkYear", jsonData.msg.WorkAgeY);
                             setValueById("AllWorkMonth", jsonData.msg.WorkAgeM);
                             setValueById("Category", jsonData.msg.OMEType);
                             SetHarmInfo(jsonData.msg.HarmInfo);
                         }
                     } else {
                         $.messager.alert("提示", jsonData.msg, "info");
                     }
                 });
             }
             if (title == $g('病史')) {
                 var RowId = $("#PIADM_RowId").val();
                 if (RowId == "") {
                     return false;
                 }
                 var Data = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetHisData", RowId);

                 if (Data == $g("无信息")) { return false; }
                 var Datas = Data.split("^");
                 setValueById("DHis", Datas[0]);
                 setValueById("DHome", Datas[1]);

                 setValueById("NowChild", Datas[2]);
                 setValueById("Abortion", Datas[3]);
                 setValueById("Prematurebirth", Datas[4]);
                 setValueById("DeadBirth", Datas[5]);
                 setValueById("AbnormalFetal", Datas[6]);

                 setValueById("SmokeHis", Datas[7]);
                 if (Datas[7] == $g("不吸烟")) {
                     $('#SmokeNo').attr("disabled", true);
                     $('#SmokeAge').attr("disabled", true);
                 }
                 setValueById("SmokeNo", Datas[8]);
                 setValueById("SmokeAge", Datas[9]);

                 setValueById("AlcolHis", Datas[10]);
                 if (Datas[10] == $g("不饮酒")) {
                     $('#AlcolNo').attr("disabled", true);
                     $('#Alcol').attr("disabled", true);
                 }
                 setValueById("AlcolNo", Datas[11]);
                 setValueById("Alcol", Datas[12]);

                 setValueById("FirstMenstrual", Datas[13]);
                 setValueById("Period", Datas[14]);
                 setValueById("Cycle", Datas[15]);
                 setValueById("MenoParseAge", Datas[16]);

                 setValueById("WeddingDate", Datas[17]);
                 setValueById("SpouseHarm", Datas[18]);
                 setValueById("SpouseHealth", Datas[19]);

                 return true;
             }
         }
     });

     
     //检查种类
     var CategoryObj = $HUI.combobox("#Category", {
         url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindCategory&ResultSetType=array",
         valueField: 'id',
         textField: 'Category'
     })

     //行业
     var IndustryObj = $HUI.combobox("#Industry", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindIndustry&ResultSetType=array",
         valueField: 'id',
         textField: 'Industry'
     })

     //工种
     var TypeofworkObj = $HUI.combobox("#Typeofwork", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindTypeofwork&ResultSetType=array",
         valueField: 'id',
         textField: 'Typeofwork'
     })

     //工种
     var ZYTypeofworkObj = $HUI.combobox("#ZYTypeofwork", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindTypeofwork&ResultSetType=array",
         valueField: 'id',
         textField: 'Typeofwork'
     })

     //防护措施
     var ProtectiveMeasureObj = $HUI.combobox("#ProtectiveMeasure", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindProtectiveMeasure&ResultSetType=array",
         valueField: 'id',
         textField: 'ProtectiveMeasure'
     })


     //接害因素
     var HarmInfoObj = $HUI.combotree("#HarmInfo", {
         url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&MethodName=GetHarmInfo&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
         checkbox: true,
         multiple: true,
         onlyLeafCheck: true
     });

     //饮酒史
     var AlcolHisObj = $HUI.combobox("#AlcolHis", {
         valueField: 'id',
         textField: 'text',
         selectOnNavigation: false,
         panelHeight: "auto",
         editable: false,
         data: [{ id: '不饮酒', text: '不饮酒' }, { id: '偶饮酒', text: '偶饮酒' }, { id: '经饮', text: '经常饮' }],
         onSelect: function(record) {
             if (record.id == "不饮酒") {
                 $('#AlcolNo').numberbox("setValue", "");
                 $('#AlcolNo').attr("disabled", true);
                 $('#Alcol').numberbox("setValue", "");
                 $('#Alcol').attr("disabled", true);
             } else {
                 $('#AlcolNo').attr("disabled", false);
                 $('#Alcol').attr("disabled", false);
             }
         }
     });

     //吸烟史
     var SmokeHisObj = $HUI.combobox("#SmokeHis", {
         valueField: 'id',
         textField: 'text',
         selectOnNavigation: false,
         panelHeight: "auto",
         editable: false,
         data: [{ id: '不吸烟', text: '不吸烟' }, { id: '偶吸烟', text: '偶吸烟' }, { id: '经吸', text: '经常吸' }],
         onSelect: function(record) {
             if (record.id == "不吸烟") {
                 $('#SmokeNo').numberbox("setValue", "");
                 $('#SmokeNo').attr("disabled", true);
                 $('#SmokeAge').numberbox("setValue", "");
                 $('#SmokeAge').attr("disabled", true);
             } else {
                 $('#SmokeNo').attr("disabled", false);
                 $('#SmokeAge').attr("disabled", false);
             }
         }
     });

     
     //放射史
     $HUI.combobox("#OHRadiationFlag", {
         valueField: 'id',
         textField: 'text',
         selectOnNavigation: false,
         panelHeight: "auto",
         editable: false,
         data: [{ id: 'N', text: '否' }, { id: 'Y', text: '是' }],
         onSelect: function(record) {
             if (record.id != "Y") {
                 $('#OHRadiationType').val("").attr("disabled", true);
                 $('#OHRadiationDose').val("").attr("disabled", true);
                 $('#OHExRadHistory').val("").attr("disabled", true);
             } else {
                 $('#OHRadiationType').attr("disabled", false);
                 $('#OHRadiationDose').attr("disabled", false);
                 $('#OHExRadHistory').attr("disabled", false);
             }
         },
         onLoadSuccess: function(data) {}
     });


 }
 // 获取危害因素 及 对应的接害工龄
 function GetHarmInfo() {
     // HarmInfo  HarmWorkYear  HarmWorkMonth
     var HarmInfoObj = $("input[comboname='HarmInfo']");
     var HarmWorkYearObj = $("input[numberboxname='HarmWorkYear']");
     var HarmWorkMonthObj = $("input[numberboxname='HarmWorkMonth']");

     var harmInfo = "",
         ErrInfo = "";
     $.each(HarmInfoObj, function(index, value) {
         var endanger = $(value).combotree("getValues").join(",");
         var workYear = $(HarmWorkYearObj[index]).numberbox("getValue");
         var workMonth = $(HarmWorkMonthObj[index]).numberbox("getValue");
         if (endanger != "" && workYear == "" && workMonth == "") {
             ErrInfo = "请填写危害因素对应的接害工龄！";
             $(HarmWorkYearObj[index]).numberbox({ required: true });
             $(HarmWorkMonthObj[index]).numberbox({ required: true });
             return false;
         } else if (endanger == "" && (workYear != "" || workMonth != "")) {
             ErrInfo = "请选择危害因素！";
             $(value).combotree({ required: true });
             return false;
         }
         if (endanger == "") return true;
         if (harmInfo == "") {
             harmInfo = endanger + "^" + workYear + "^" + workMonth;
         } else {
             harmInfo = harmInfo + "&" + endanger + "^" + workYear + "^" + workMonth;
         }
     });
     if (ErrInfo != "") return { code: "-1", msg: ErrInfo };
     else return { code: "0", msg: harmInfo };
 }

 // 设置危害因素 及 对应的接害工龄
 function SetHarmInfo(harmInfo) {
     if (harmInfo == "") return fasle;
     var harm = harmInfo.split("&");

     $(".DelEndangerInfo").parents("tr").remove();

     var len = harm.length;
     for (var i = 0; len > 1 && len > (i + 1); i++) {
         AddHarmInfo();
     }

     var HarmInfoObj = $("input[comboname='HarmInfo']");
     var HarmWorkYearObj = $("input[numberboxname='HarmWorkYear']");
     var HarmWorkMonthObj = $("input[numberboxname='HarmWorkMonth']");

     $.each(HarmInfoObj, function(index, value) {
         if (harm[index].split("^")[0] == "") return true;
         $(value).combotree("setValues", harm[index].split("^")[0].split(","));
         $(HarmWorkYearObj[index]).numberbox("setValue", harm[index].split("^")[1]);
         $(HarmWorkMonthObj[index]).numberbox("setValue", harm[index].split("^")[2]);
     });
 }

// 增加 危害因素及 接害工龄
function AddHarmInfo() {
    var HISUIStyleCode=tkMakeServerCall("websys.StandardTypeItem","GetIdFromCodeOrDescription","websys","HISUIDefVersion"); //判断是"炫彩"还是"极简"版本？
    var inpWid = "150px", numWid = "40px", colspan = "", padding_L = "";
    if ($('#ZYBTabItem').length > 0) {
        inpWid = "207px", numWid = "61px";
        colspan = "colspan=2"
        padding_L = " style='padding-left:10px;'";
    }
    
    var AddHtml = '<tr>' +
        '   <td></td>' +
        '   <td align="right"><label>接害因素</label></td>' +
        '   <td class="zy_td_padding"><input class="hisui-combotree" type="text" name="HarmInfo" style="width:' + inpWid + ';"/></td>'

        +
        '   <td align="right" class="zy_td_padding"><label>接害工龄</label></td>' +
        '   <td ' + colspan + ' class="zy_td_padding">' +
        '       <input class="hisui-numberbox textbox" data-options="min:0, max:65" type="text" name="HarmWorkYear" style="width:' + numWid + ';"/>' +
        '       <label>年</label>' +
        '       <input class="hisui-numberbox textbox" data-options="min:0, max:11" type="text" name="HarmWorkMonth" style="width:' + numWid + ';"/>' +
        '       <label>月</label>' +
        '       <a class="hisui-linkbutton DelEndangerInfo"' + padding_L + ' iconCls="icon-cancel" plain="true" onclick="DelHarmInfo(this)">'
        '   </td>';

    //AddHtml += '<td><a class="hisui-linkbutton" iconCls="icon-cancel" plain="true" onclick="DelHarmInfo(this)"></a>';
    AddHtml += '</tr>';
    $("#OccuBaseInfo tr:eq(-2)").after(AddHtml);
    $HUI.combotree("#OccuBaseInfo tr:eq(-2) input[name='HarmInfo']", {
        url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&MethodName=GetHarmInfo&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
        checkbox: true,
        multiple: true,
        onlyLeafCheck: true
    });
    $.parser.parse("#OccuBaseInfo tr:eq(-2)");
}

 // 删除当前行 危害因素及 接害工龄
 function DelHarmInfo(target) {
     $(target).parents("tr").remove();
 }
 
 
 function JBNext() {
     $('#ZYBTabItem').tabs('select', '职业史');
 }

 function ZYNext() {
     $('#ZYBTabItem').tabs('select', '病史');
 }



 function BSNext() {
     $('#ZYBTabItem').tabs('select', '职业病史');
 }

 function ZYCancel() {
     $("#ZYform").form("clear");
     $("#ZYHistory").datagrid('clearSelections');
 }

 function ZYBCancel() {
     $("#ZYBform").form("clear");
     $("#ZYBHistory").datagrid('clearSelections');
 }

 function ZYDelete() {
     var RowId = $("#PIADM_RowId").val();
     if (RowId == "") {
         $.messager.alert("提示", "请先预约！", "info");
         return false;
     }
     var row = $('#ZYHistory').datagrid('getSelected');
     if (row) {} else {
         $.messager.alert("提示", "未选中需要删除的记录！", "info");
         return;
     }
     $.messager.confirm("删除", "确定要删除记录吗?", function(r) {
         if (r) {
             var iPreIADM = getValueById("PIADM_RowId");

             var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetOccuHistory", iPreIADM);
             var oldinfostr = oldinfo.split("$")

             var row = $('#ZYHistory').datagrid('getSelected');

             if (row) {
                 var CurrentSel = $('#ZYHistory').datagrid('getRowIndex', row) + 1;
                 oldinfostr[CurrentSel - 1] = "";
                 var NowInfo = oldinfostr.join("$");
             } else {

                 $.messager.alert("提示", "未选中需要删除的记录！", "info");
                 return;
             }

             var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveOccuHistory", iPreIADM, NowInfo);
             var infoData = info.split("^");

             if (infoData[0] <= 0) {
                 $.messager.alert("提示", info, "info");
                 return;
             } else {
                 $("#ZYHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuHistory", PreIADM: iPreIADM });
                 ZYCancel();
             }
         } else {
             return;
         }
     });
 }

 function ZYBDelete() {
     var row = $('#ZYBHistory').datagrid('getSelected');
     if (row) {} else {
         $.messager.alert("提示", "未选中需要删除的记录！", "info");
         return;
     }
     $.messager.confirm("删除", "确定要删除记录吗?", function(r) {
         if (r) {
             var iPreIADM = getValueById("PIADM_RowId");

             var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetOccuDiseaseHistory", iPreIADM);
             var oldinfostr = oldinfo.split("$")

             var row = $('#ZYBHistory').datagrid('getSelected');
             if (row) {
                 var CurrentSel = $('#ZYBHistory').datagrid('getRowIndex', row) + 1;
                 oldinfostr[CurrentSel - 1] = "";
                 var NowInfo = oldinfostr.join("$");
             } else {
                 $.messager.alert("提示", "未选中需要删除的记录！", "info");
                 return;
             }

             var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveOccuDiseaseHistory", iPreIADM, NowInfo);
             var infoData = info.split("^");

             if (infoData[0] <= 0) {
                 $.messager.alert("提示", info, "info");
                 return;
             } else {
                 $("#ZYBHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuDiseaseHistory", PreIADM: iPreIADM });
                 ZYBCancel();
             }
         } else {
             return;
         }
     });
 }

 function ZYBSave() {
     var iDiseaseDesc = "",
         iDiagnosisDate = "",
         iDiagnosisPlace = "",
         iiProcess = "",
         iReturn = "",
         iIsRecovery = "",
         iPreIADM = "";

     var iDiseaseDesc = getValueById("DiseaseDesc"); // 病名
     if (iDiseaseDesc == "") {
         $.messager.alert("提示", "病名不能为空！", "info");
         return;
     }

     var iDiagnosisDate = getValueById("DiagnosisDate"); // 诊断日期
     if (iDiagnosisDate == "") {
         $.messager.alert("提示", "诊断日期不能为空！", "info");
         return;
     }

     var ret = tkMakeServerCall("web.DHCPE.OccupationalDisease", "DateOverNow", iDiagnosisDate);
     if (ret == 1) {
         $.messager.alert("提示", "诊断日期不能大于当前日期!", "info");
         return;
     }

     var iDiagnosisPlace = getValueById("DiagnosisPlace"); // 诊断单位
     var iProcess = getValueById("Process"); // 治疗经过
     var iReturn = getValueById("Return"); // 归转

     //var iIsRecovery = getValueById("IsRecovery");
     //if (iIsRecovery) { iIsRecovery = "1"; }
     //else { iIsRecovery = "0"; }

     var iPreIADM = getValueById("PIADM_RowId");

     var Instring = trim(iDiseaseDesc) +
         "^" + trim(iDiagnosisDate) +
         "^" + trim(iDiagnosisPlace) +
         "^" + trim(iProcess) +
         "^" + trim(iReturn);
     var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetOccuDiseaseHistory", iPreIADM);
     var oldinfostr = oldinfo.split("$");

     var row = $('#ZYBHistory').datagrid('getSelected');
     if (row) {
         var CurrentSel = $('#ZYBHistory').datagrid('getRowIndex', row) + 1;
         oldinfostr[CurrentSel - 1] = Instring;
         var NowInfo = oldinfostr.join("$");
     } else {
         var NowInfo = oldinfo + "$" + Instring;
     }

     var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveOccuDiseaseHistory", iPreIADM, NowInfo);
     var infoData = info.split("^");

     if (infoData[0] <= 0) {
         $.messager.alert("提示", info, "info");
         return;
     } else {
         $("#ZYBHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuDiseaseHistory", PreIADM: iPreIADM });
         ZYBCancel();
     }
 }

 function ZYSave() {
     var RowId = $("#PIADM_RowId").val();
     if (RowId == "") {
         $.messager.alert("提示", "请先预约！", "info");
         return false;
     }

     var iStartDate = "",
         iEndDate = "",
         iWorkPlace = "",
         iWorkDepartment = "",
         iWorkTeam = "";
     var iWorkType = "",
         iWorkShop = "",
         iHarmfulFactor = "",
         iDailyWorkHours = "",
         iProtectiveMeasure = "";
     var iOHRadiationFlag = "",
         iOHRadiationType = "",
         iOHRadiationDose = "",
         iOHExRadHistory = "",
         iOHRemark = "";
     var iPreIADM = "";

     var iStartDate = getValueById("StartDate");
     var iStartDate = tkMakeServerCall("web.DHCPE.OccupationalDisease", "DateChangeNum", iStartDate);
     if (iStartDate == "") {
         $.messager.alert("提示", "开始日期不能为空!", "info");
         return;
     }
     
     var iEndDate = getValueById("EndDate");
     var iEndDate = tkMakeServerCall("web.DHCPE.OccupationalDisease", "DateChangeNum", iEndDate);

     if ((iStartDate > iEndDate) && (iEndDate != "")) {
         $.messager.alert("提示", "开始日期不能大于结束日期!", "info");
         return;
     }

     var iOHRadiationFlag = getValueById("OHRadiationFlag"); // 放射史
     var iOHRadiationType = getValueById("OHRadiationType"); // 放射线种类
     if (iOHRadiationFlag == "Y" && iOHRadiationType == "") {
         $.messager.alert("提示", "放射史请填写放射线种类!", "info");
         return;
     }
     var iOHRadiationDose = getValueById("OHRadiationDose"); // 累积受照剂量
     if (iOHRadiationFlag == "Y" && iOHRadiationDose == "") {
         $.messager.alert("提示", "放射史请填写累积受照剂量!", "info");
         return;
     }

     var iWorkPlace = getValueById("WorkPlace");
     var iWorkDepartment = getValueById("WorkDepartment");
     var iWorkShop = getValueById("WorkShop");
     var iWorkTeam = getValueById("WorkTeam");
     var iWorkType = getValueById("ZYTypeofwork");
     var iDailyWorkHours = getValueById("DailyWorkHours");
     var iHarmfulFactor = getValueById("HarmfulFactor");
     var iProtectiveMeasure = getValueById("ProtectiveMeasure");

     var iOHExRadHistory = getValueById("OHExRadHistory"); // 过量照射史
     var iOHRemark = getValueById("OHRemark"); // 备注

     var iPreIADM = getValueById("PIADM_RowId");

     var Instring = trim(iStartDate) +
         "^" + trim(iEndDate) +
         "^" + trim(iWorkPlace) +
         "^" + trim(iWorkDepartment) +
         "^" + trim(iWorkShop) +
         "^" + trim(iWorkTeam) +
         "^" + trim(iWorkType) +
         "^" + trim(iDailyWorkHours) +
         "^" + trim(iHarmfulFactor) +
         "^" + trim(iProtectiveMeasure) +
         "^" + trim(iOHRadiationFlag) +
         "^" + trim(iOHRadiationType) +
         "^" + trim(iOHRadiationDose) +
         "^" + trim(iOHExRadHistory) +
         "^" + trim(iOHRemark);
     
     if (Instring == "^^^^^^^^^^^^^^") {
         $.messager.alert("提示", "职业史信息不能全是空！", "info");
         return;
     }
     var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetOccuHistory", iPreIADM);
     var oldinfostr = oldinfo.split("$");

     var row = $('#ZYHistory').datagrid('getSelected');
     if (row) {
         var CurrentSel = $('#ZYHistory').datagrid('getRowIndex', row) + 1;
         oldinfostr[CurrentSel - 1] = Instring;
         var NowInfo = oldinfostr.join("$");
     } else {
         var NowInfo = oldinfo + "$" + Instring;
     }

     var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveOccuHistory", iPreIADM, NowInfo);
     var infoData = info.split("^");

     if (infoData[0] <= 0) {
         $.messager.alert("提示", info, "info");
         return;
     } else {
         $("#ZYHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuHistory", PreIADM: iPreIADM });
         ZYCancel();
     }
 }

 function BSSave() {
     var DHis = getValueById("DHis");
     var DHome = getValueById("DHome");

     var SmokeHis = getValueById("SmokeHis");
     var SmokeNo = getValueById("SmokeNo");
     var SmokeAge = getValueById("SmokeAge");
     var AlcolHis = getValueById("AlcolHis");
     var AlcolNo = getValueById("AlcolNo");
     var Alcol = getValueById("Alcol");

     var FirstMenstrual = getValueById("FirstMenstrual");
     var Period = getValueById("Period");
     var Cycle = getValueById("Cycle");
     var MenoParseAge = getValueById("MenoParseAge");

     var NowChild = getValueById("NowChild");
     var Abortion = getValueById("Abortion");
     var Prematurebirth = getValueById("Prematurebirth");
     var DeadBirth = getValueById("DeadBirth");
     var AbnormalFetal = getValueById("AbnormalFetal");

     var WeddingDate = getValueById("WeddingDate");
     var WeddingDate = tkMakeServerCall("web.DHCPE.OccupationalDisease", "DateChangeNum", WeddingDate);

     var SpouseHarm = getValueById("SpouseHarm");
     var SpouseHealth = getValueById("SpouseHealth");

     var iPreIADM = getValueById("PIADM_RowId");

     var Instring1 = trim(SmokeHis) + "^" + trim(SmokeNo) + "^" + trim(SmokeAge);
     var info1 = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetListDataByData", Instring1);

     var Instring2 = trim(AlcolHis) + "^" + trim(AlcolNo) + "^" + trim(Alcol);
     var info2 = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetListDataByData", Instring2);


     var Instring3 = trim(FirstMenstrual) + "^" + trim(Period) + "^" + trim(Cycle) + "^" + trim(MenoParseAge);
     var info3 = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetListDataByData", Instring3);

     var Instring4 = trim(NowChild) + "^" + trim(Abortion) + "^" + trim(Prematurebirth) + "^" + trim(DeadBirth) + "^" + trim(AbnormalFetal);
     var info4 = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetListDataByData", Instring4);

     // var Instring5 = trim(WeddingDate) + "^" + trim(SpouseHarm) + "^" + trim(SpouseHealth);
     // var info5 = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring5);
     var Instring5 = trim(WeddingDate) + "$" + trim(SpouseHarm) + "$" + trim(SpouseHealth);
     var info5 = Instring5;

     var Instring = trim(DHis) +
         "^" + trim(DHome) +
         "^" + trim(info1) +
         "^" + trim(info2) +
         "^" + trim(info3) +
         "^" + trim(info4) +
         "^" + trim(info5);

     var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveDiseaseHistory", iPreIADM, Instring);
     var infoData = info.split("^");

     if (infoData[0] <= 0) {
         $.messager.alert("提示", info, "info");
         return;
     } else {
         $.messager.alert("提示", "更新成功", "success");
     }
 }

 function JBSave() {
     var Strings = "";
     var PreIADM = getValueById("PIADM_RowId");
     if (PreIADM == "") {
         $.messager.alert("提示", "请先预约！", "info");
         return false;
     }

     var AllWorkYear = getValueById("AllWorkYear"); // 总工龄
     var AllWorkMonth = getValueById("AllWorkMonth");
     if (AllWorkYear == "" && AllWorkMonth == "") {
         $.messager.alert("提示", "请输入总工龄，无则输入0！", "info");
         return;
     }

     var Category = getValueById("Category"); // 检查种类
     if (Category == "") {
         $.messager.alert("提示", "请选择检查种类！", "info");
         return;
     }

     var EndangerInfo = GetHarmInfo(); // $("#HarmInfo").combotree("getValues");

     if (EndangerInfo.code != "0") {
         $.messager.alert("提示", OccuStr.msg, "info");
         return;
     } else if (EndangerInfo.msg == "") {
         $.messager.alert("提示", "请选择接害因素及接害工龄！", "info");
         return;
     }
     var EndangerStr = EndangerInfo.msg

     var Industry = getValueById("Industry"); // 行业
     var Typeofwork = getValueById("Typeofwork"); // 工种
     var WorkNo = getValueById("WorkNo"); // 工号

     var OccuStr = Industry + "^" + Typeofwork + "^" + WorkNo + "^" + Category + "^" + AllWorkYear + "^" + AllWorkMonth;

     $cm({
         ClassName: "web.DHCPE.OccupationalDisease",
         MethodName: "UpdPreOccuInfo",
         PreIADM: PreIADM,
         OccStr: OccuStr,
         EndangerStr: EndangerStr
     }, function(jsonData) {
         if (jsonData.code == "0") {
             $.messager.alert("提示", "更新成功", "success");
         } else {
             $.messager.alert("提示", jsonData.msg, "info");
         }
     });
 }
function trim(s) {
     if ("" == s) { return ""; }
     var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
     return (m == null) ? "" : m[1];
 }
  $(init);