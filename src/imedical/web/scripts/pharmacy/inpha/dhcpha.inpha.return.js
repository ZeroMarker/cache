/** 
 * 模块:住院药房
 * 子模块:住院药房-直接退药
 * createdate:2016-08-30
 * creator:dinghongying
 */
 DHCPHA_CONSTANT.VAR.PHARET = "";
 $(function () {
     /* 初始化插件 start*/
     var daterangeoptions = {
         singleDatePicker: true
     }
     $("#date-start").dhcphaDateRange(daterangeoptions);
     $("#date-end").dhcphaDateRange(daterangeoptions);
     var cardoptions = {
         id: "#sel-cardtype"
     }
     InitPhaLoc();
     InitGridReturn();
     InitReturnModal();
     /* 初始化插件 end*/
     /* 表单元素事件 start*/
     //登记号回车事件
     $('#txt-patno').on('keypress', function (event) {
         if (window.event.keyCode == "13") {
             var patno = $.trim($("#txt-patno").val());
             if (patno != "") {
                 var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                 $(this).val(newpatno);
                 var patoptions = {
                     id: "#dhcpha-patinfo",
                     gettype: "patno",
                     input: newpatno
                 }
                 AppendPatientBasicInfo(patoptions);
                 QueryGridReturn();
             }
         }
     });
 
     //屏蔽所有回车事件
     $("input[type=text]").on("keypress", function (e) {
         if (window.event.keyCode == "13") {
             return false;
         }
     })
     /* 表单元素事件 end*/
     /* 绑定按钮事件 start*/
     $("#btn-return").on("click", function(){
         CACert('PHAIPReturn',DoReturn)   
     });    
     $("#btn-find").on("click", QueryGridReturn);
     $("#btn-clear").on("click", ClearConditions);
     $('#btn-print-sure').on('click',PrintSelType); 
     $('#modal-returnprinttype input[type=checkbox]').each(function () {
         $(this).on('ifClicked', function () {
             if ($(this).is(':checked')) {
                 //这插件的逻辑...
                 $(this).iCheck('uncheck'); //如果已选择，可以用iCheck取消选择
             } else {
                 $(this).iCheck('check'); //如果没选择，可以用iCheck美化选择
             }
             SetConditionCheck(this.id);
         });
     });
     $('#chk-prtdefault').iCheck('check');
     $("#btn-redir-return").on("click", function () {
         var lnk = ChangeCspPathToAll("dhcpha/dhcpha.inpha.returnbyreq.csp");
         window.open(lnk, "_target", "width=" + (document.body.clientWidth - 6) + ",height=" + (document.body.clientHeight - 30) + ",menubar=no,status=yes,toolbar=no,resizable=yes,top=90,left=3");
     })
     $("#btn-redir-returnquery").on("click", function () {
         var lnk = ChangeCspPathToAll("pha.ip.v4.query.return.csp");
         window.open(lnk, "_target", "width=" + (document.body.clientWidth - 6) + ",height=" + (document.body.clientHeight - 30) + ",menubar=no,status=yes,toolbar=no,resizable=yes,top=90,left=3");
     })
     /* 绑定按钮事件 end*/
     ;
     InitButtonStyle();
     ResizeReturn();
     $('#txt-patno').focus();
 })
 //初始化直接退药table
 function InitGridReturn() {
     var columns = [{
             header: '病区/特殊科室',
             index: 'TWard',
             name: 'TWard',
             width: 150,
             align: 'left'
         },
         {
             header: '登记号',
             index: 'TPaNo',
             name: 'TPaNo',
             width: 80
         },
         {
             header: '姓名',
             index: 'TPaName',
             name: 'TPaName',
             width: 70,
             hidden: true
         },
         {
             header: '床号',
             index: 'TBedNo',
             name: 'TBedNo',
             width: 70
         },
         {
             header: '药品名称',
             index: 'TDesc',
             name: 'TDesc',
             width: 175,
             align: 'left'
         },
         {
             header: '单位',
             index: 'TUom',
             name: 'TUom',
             width: 60
         },
         {
             header: '退药数量',
             index: 'TReturnQty',
             name: 'TReturnQty',
             width: 60,
             editable: true,
             cellattr: addTextCellAttr
         },
         {
             header: '可退数量',
             index: 'TDispQty',
             name: 'TDispQty',
             width: 60,
             align: 'right'
         },
         {
             header: '发药数量',
             index: 'TPhaDispQty',
             name: 'TPhaDispQty',
             width: 60,
             align: 'right'
         },
         {
             header: '申请数量',
             index: 'TRetReqQty',
             name: 'TRetReqQty',
             width: 60,
             align: 'right',
             hidden: true
         },
         {
             header: '批号',
             index: 'TBatchNo',
             name: 'TBatchNo',
             width: 80
         },
         {
             header: '退药价格',
             index: 'TReturnPrice',
             name: 'TReturnPrice',
             width: 60,
             align: 'right'
         },
         {
             header: '金额',
             index: 'TReturnAmt',
             name: 'TReturnAmt',
             width: 60,
             align: 'right'
         },
         {
             header: '处方号',
             index: 'TPrescNo',
             name: 'TPrescNo',
             width: 110
         },
         {
             header: '病人密级',
             index: 'TEncryptLevel',
             name: 'TEncryptLevel',
             width: 60,
             hidden: true
         },
         {
             header: '病人级别',
             index: 'TPatLevel',
             name: 'TPatLevel',
             width: 60,
             hidden: true
         },
         {
             header: '药品代码',
             index: 'TCode',
             name: 'TCode',
             width: 75,
             align: 'left'
         },
         {
             header: '药房Id',
             index: 'TRECLOCDR',
             name: 'TRECLOCDR',
             width: 60,
             hidden: true
         },
         {
             header: '打包主表Id',
             index: 'TDspid',
             name: 'TDspid',
             width: 60,
             hidden: true
         },
         {
             header: '打包子表Id',
             index: 'TDspSubId',
             name: 'TDspSubId',
             width: 75,
             hidden: true
         },
         {
             header: '发药孙表Id',
             index: 'TPhacItmLbId',
             name: 'TPhacItmLbId',
             width: 75,
             hidden: true
         },
         {
             header: '草药处方标志',
             index: 'TCyFlag',
             name: 'TCyFlag',
             width: 75,
             hidden: true
         }
     ];
     var jqOptions = {
         colModel: columns, //列
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryNeedReturn&style=jqGrid', //查询后台 
         height: DhcphaJqGridHeight(1, 1),
         datatype: "local",
         multiselect: true,
         onSelectRow: function (id, status) {
             var iddata = $('#grid-return').jqGrid('getRowData', id);
             var prescyflag = iddata.TCyFlag;
             if (prescyflag == "Y") {
                 var prescNo = iddata.TPrescNo;
                 var rowIds = $('#grid-return').jqGrid('getDataIDs');
                 for (var k = 0; k < rowIds.length; k++) {
                     var curRowData = $('#grid-return').jqGrid('getRowData', rowIds[k]);
                     var tmpPrescNo = curRowData['TPrescNo'];
                     var curChk = $("#" + rowIds[k] + "").find(":checkbox");
                     if ((prescNo == tmpPrescNo) && (id != (k + 1))) {
                         $("#grid-return").jqGrid('setSelection', k + 1, false);
                     }
                 }
                 return;
             }
             if ((JqGridCanEdit == false) && (LastEditSel != "") && (LastEditSel != id)) {
                 $("#grid-return").jqGrid('setSelection', LastEditSel);
                 return
             }
             if ((LastEditSel != "") && (LastEditSel != id)) {
                 $(this).jqGrid('saveRow', LastEditSel);
             }
             $(this).jqGrid("editRow", id, {
                 oneditfunc: function () {
                     $editinput = $(event.target).find("input");
                     $editinput.focus();
                     $editinput.select();
                     $editinput.unbind().on("keyup",function(e){
                         $editinput.val(ParseToNum($editinput.val()))
                     });
                     $("#" + id + "_TReturnQty").on("focusout || mouseout", function () {
                         var iddata = $('#grid-return').jqGrid('getRowData', id);
                         var dispedqty = iddata.TDispQty;
                         var dispid = iddata.TDspid;
                         if (this.value.toString().indexOf(".") >= 0) {
                             // 有小数的处理,发药数有小数才能写小数
                             if (dispedqty.toString().indexOf(".") < 0) {
                                 dhcphaMsgBox.message("第" + id + "行退药数量不能为小数!")
                                 $("#grid-return").jqGrid('restoreRow', id);
                                 JqGridCanEdit = true;
                                 return false
                             }
                         }
                         if (parseFloat(this.value * 1000) > parseFloat(dispedqty * 1000)) {
                             dhcphaMsgBox.message("第" + id + "行退药数量大于未退数量!")
                             $("#grid-return").jqGrid('restoreRow', id);
                             JqGridCanEdit = true;
                             return false;
                         }
                         JqGridCanEdit = true
                         return true
                     });
                 }
             });
             LastEditSel = id;
         }
     };
     $("#grid-return").dhcphaJqGrid(jqOptions);
     PhaGridFocusOut("grid-return");
 }
 //验证单行数据合法
 function CheckOneRowData(rowid) {
     var selecteddata = $("#grid-return").jqGrid('getRowData', rowid);
     var retqty = selecteddata["TReturnQty"];
     var dispedqty = selecteddata["TDispQty"];
     var dispid = selecteddata["TDspid"];
     var incicode = selecteddata["TCode"];
     var dspsubid = selecteddata["TDspSubId"];
     var phacitmlbid = selecteddata["TPhacItmLbId"];
     var diffqty = parseFloat(retqty) - parseFloat(dispedqty);
     if (retqty < 0) {
         dhcphaMsgBox.alert("第" + rowid + "行退药数量不允许为负数!");
         return false;
     } else if (parseFloat(diffqty) > 0) {
         dhcphaMsgBox.alert("第" + rowid + "行退药数量不能大于发药数量!");
         return false;
     } else if (isNaN(retqty)) {
         dhcphaMsgBox.alert("第" + rowid + "行退药数量应为正数!");
         return false;
     } else if (retqty == "") {
         dhcphaMsgBox.alert("第" + rowid + "行退药数量不能为空!");
         return false;
     } else if (retqty == 0) {
         dhcphaMsgBox.alert("第" + rowid + "行退药数量不能为0!");
         return false;
     } else {
         var allowret = tkMakeServerCall("web.DHCSTPHARETURN", "AllowReturnByPhacLb", phacitmlbid, parseFloat(retqty));
         if (allowret == "0") {
             dhcphaMsgBox.alert("第" + rowid + "行退药数量不能大于发药数量!");
             return false;
         }
         var checkpartret = tkMakeServerCall("web.DHCSTPHARETURN2", "GetRetParted", dispid, parseFloat(retqty));
         if (checkpartret == "0") {
             dhcphaMsgBox.alert("第" + rowid + "此记录有附加收费项目，不能部分退药!");
             return false;
         }
     }
     var refrefuseflag = tkMakeServerCall("web.DHCST.ARCALIAS", "GetRefReasonByCode", incicode);
     if (refrefuseflag != "") {
         if (refrefuseflag.split("^")[3] != "") {
             dhcphaMsgBox.alert("第" + rowid + "行药品" + refrefuseflag.split("^")[1] + ",在药品基础数据中目前为不可退药状态,不能申请!</br>不可退药原因:" + refrefuseflag.split("^")[3]);
             return false;
         }
     }
     return true
 }
 //初始化科室
 function InitPhaLoc() {
     var selectoption = {
         allowClear: false,
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
             "?action=GetStockPhlocDs&style=select2&groupId=" +
             DHCPHA_CONSTANT.SESSION.GROUP_ROWID
     }
     $("#sel-phaloc").dhcphaSelect(selectoption)
     var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
     $("#sel-phaloc").append(select2option); //设默认值,没想到好办法,yunhaibao20160805
     $('#sel-phaloc').on('select2:select', function (event) {
         //alert(event)
     });
 }
 //查询直接退药列表
 function QueryGridReturn() {
     var stdate = $("#date-start").val();
     var enddate = $("#date-end").val();
     var patno = $.trim($("#txt-patno").val());
     if (patno == "") {
         //dhcphaMsgBox.alert("请输入登记号!");
     }
     var returnlocrowid = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
     var params = stdate + "^" + enddate + "^" + patno + "^" + returnlocrowid;
     $("#grid-return").setGridParam({
         datatype: "json",
         postData: {
             'params': params
         }
     }).trigger("reloadGrid");
     JqGridCanEdit = true;
     return true
 }
 //退药
 function DoReturn() {
     var grid_records = $("#grid-return").getGridParam('records');
     if (grid_records == 0) {
         dhcphaMsgBox.alert($g("退药列表为空!"));
     } else {
         var selectids = $("#grid-return").jqGrid('getGridParam', 'selarrrow');
         if ((selectids == "") || (selectids == null)) {
             dhcphaMsgBox.alert($g("请先勾选需要退药的记录!"));
             return;
         }
         if (JqGridCanEdit == false) {
             JqGridCanEdit = true;
             return;
         }
         var selectids = $("#grid-return").jqGrid('getGridParam', 'selarrrow');
         var canreturn = true;
         var canRetCnt = 0;
         $.each(selectids, function () {
             if (CheckOneRowData(this) == false) {
                 canreturn = false;
                 return false;
             }
             canRetCnt++;
         });
         if (canreturn == false) {
             return;
         }
         /*
         if(canreturn==0){
             dhcphaMsgBox.alert("请核查，没有可退数据");
             return;
         }*/
         $("#modal-inpharetreason").modal('show');
     }
 }
 //执行退药
 function ExecuteReturn(returnreason) {
     var userid = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
     var selectids = $("#grid-return").jqGrid('getGridParam', 'selarrrow');
     var canreturn = true;
     var reclocdr = "";
     var returnstr = ""
     $.each(selectids, function () {
         if (CheckOneRowData(this) == false) {
             canreturn = false;
             return false;
         }
         var selrowdata = $("#grid-return").jqGrid('getRowData', this);
         var retqty = $.trim(selrowdata["TReturnQty"]);
         var dispedqty = $.trim(selrowdata["TDispQty"]);
         var dispId = selrowdata["TDspid"];
         var dspsubid = selrowdata["TDspSubId"];
         var phacitmlbid = selrowdata["TPhacItmLbId"];
         var tmpreturndata = dispId + "^" + retqty + "^" + returnreason + "^" + dspsubid + "^" + phacitmlbid;
         reclocdr = selrowdata["TRECLOCDR"];
         if ((retqty != "") && (retqty != 0)) {
             if (returnstr == "") {
                 returnstr = tmpreturndata;
             } else {
                 returnstr = returnstr + "," + tmpreturndata;
             }
         }
     })
     if (canreturn == false) {
         return;
     }
     var execret = tkMakeServerCall("web.DHCSTPHARETURN", "ExecReturn", reclocdr, userid, "", returnstr);
     var execretarr = execret.split("^");
     var retstatus = execretarr[0];
     var retvalue = execretarr[1];
     if (retstatus == "success") {
         DHCPHA_CONSTANT.VAR.PHARET = retvalue;
         QueryGridReturn();
         dhcphaMsgBox.confirm($g("退药成功!是否打印？"), ConfirmReturnPrint);
     } else {
         if (retvalue == -3) {
             dhcphaMsgBox.alert($g("存在药品退药数量 >  (发药数量 - 已退药数量),请刷新后核实!"));
         } else if (retvalue == -12) {
             dhcphaMsgBox.alert($g("存在执行记录状态不是停止执行或撤销执行的药品，不允许退药!"));
         } else if (retvalue == -9) {
             dhcphaMsgBox.alert($g("存在未退申请单，不允许再使用直接退药!"));
         } else if (retvalue == -4) {
             dhcphaMsgBox.alert($g("该患者已做完最终结算，不允许退药!"));
         } else if (retvalue == -11) {
             dhcphaMsgBox.alert($g("不允许退药:已经中途结算,不能退药!"));
         } else if (retvalue == -1) {
             dhcphaMsgBox.alert($g("执行退药失败,请检查退药数据是否无误，或者退药数量是否为0"));
         } else {
             dhcphaMsgBox.alert($g("执行退药失败,错误代码:") + retvalue);
         }
         return;
     }
 }
 
 function ConfirmReturnPrint(result) {
     if (result == true) {
         var paramsStr="^"+session['LOGON.CTLOCID']+"^^"+session['LOGON.HOSPID']
         var selPrintTypeFlag=tkMakeServerCall("web.DHCST.Common.AppCommon","GetAppPropValue","DHCSTPHARETURN","SelPrintTypeAfter",paramsStr)
         if (selPrintTypeFlag=="Y") {
             $('#modal-returnprinttype').modal('show');
         }else {
             PrintReturnCom(DHCPHA_CONSTANT.VAR.PHARET, "");
             DHCPHA_CONSTANT.VAR.PHARET = "";
         }
     } else {
         return;
     }
 }
 //清空
 function ClearConditions() {
     $("#txt-patno").val("");
     $("#txt-cardno").val("");
     $("#date-start").data('daterangepicker').setStartDate(new Date());
     $("#date-start").data('daterangepicker').setEndDate(new Date());
     $("#date-end").data('daterangepicker').setStartDate(new Date());
     $("#date-end").data('daterangepicker').setEndDate(new Date());
     $("#grid-return").clearJqGrid();
     JqGridCanEdit = true;
     if ($("#patInfo")) {
         $("#patInfo").remove()
     }
 }
 
 //初始化退药原因模型
 function InitReturnModal() {
     var locoption = {
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + "?action=GetInRetReason&Type=select2",
         minimumResultsForSearch: Infinity,
         width: 200
     }
     $("#sel-retreason").dhcphaSelect(locoption)
     //退药
     $('#modal-inpharetreason').on('show.bs.modal', function () {
         $("#sel-retreason ").empty();
     })
     $("#btn-retreason-sure").on("click", function () {
         var returnreason = $("#sel-retreason").val();
         if ((returnreason == "") || (returnreason == null)) {
             dhcphaMsgBox.alert($g("请选择退药原因"));
             return;
         }
         $("#modal-inpharetreason").modal('hide');
         ExecuteReturn(returnreason);
     });
 }
 
 function PhaGridFocusOut(gridid) {
     $("#" + gridid).on("mouseleave",function (e) {
         if (e.relatedTarget) {
             var $related = $("#" + gridid).find(e.relatedTarget);
             if ($related.length <= 0 && LastEditSel != "") {
                 $("#" + gridid).jqGrid('saveRow', LastEditSel);
             }
         }
     })
 }
 
 function SetConditionCheck(checkboxid) {
    var boolchecked = '';
    if ($('#' + checkboxid).is(':checked')) {
        boolchecked = '1';
    }
    if (boolchecked == '1') {
        if (checkboxid == 'chk-prtdefault') {
            $('#chk-prttotal').iCheck('uncheck');
            $('#chk-prtdetail').iCheck('uncheck');
        }
        if ((checkboxid == 'chk-prttotal')||(checkboxid == 'chk-prtdetail')) {
            $('#chk-prtdefault').iCheck('uncheck');
        }
    }
 }
 
 function PrintSelType() {
    var prtDefault="",prtTotal="",prtDetail=""
    if ($('#chk-prtdefault').is(':checked')) {
         prtDefault = 1;
    }
    if ($('#chk-prttotal').is(':checked')) {
         prtTotal = 1;
    }
    if ($('#chk-prtdetail').is(':checked')) {
         prtDetail = 1;
    }
    var retIdStr=DHCPHA_CONSTANT.VAR.PHARET
    if (prtDefault=="1") {
        PrintReturnCom(retIdStr,"","")
    }
    if (prtTotal=="1") {
        PrintReturnCom(retIdStr,"","Total")
    }
    if (prtDetail=="1") {
        PrintReturnCom(retIdStr,"","Detail")
    }
    $('#modal-returnprinttype').modal('hide');
    DHCPHA_CONSTANT.VAR.PHARET='';
}
 
 function InitButtonStyle() {}
 
 window.onresize = ResizeReturn;
 function ResizeReturn(){
     var returntitleheight = $("#gview_grid-return .ui-jqgrid-hbox").height();
     var returnheight = DhcphaJqGridHeight(1, 1) - returntitleheight + 40 ;  //
     $("#grid-return").setGridHeight(returnheight).setGridWidth("");
 }
