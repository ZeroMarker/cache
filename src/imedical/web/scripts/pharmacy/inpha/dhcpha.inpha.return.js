/** 
 * ģ��:סԺҩ��
 * ��ģ��:סԺҩ��-ֱ����ҩ
 * createdate:2016-08-30
 * creator:dinghongying
 */
 DHCPHA_CONSTANT.VAR.PHARET = "";
 $(function () {
     /* ��ʼ����� start*/
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
     /* ��ʼ����� end*/
     /* ��Ԫ���¼� start*/
     //�ǼǺŻس��¼�
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
 
     //�������лس��¼�
     $("input[type=text]").on("keypress", function (e) {
         if (window.event.keyCode == "13") {
             return false;
         }
     })
     /* ��Ԫ���¼� end*/
     /* �󶨰�ť�¼� start*/
     $("#btn-return").on("click", function(){
         CACert('PHAIPReturn',DoReturn)   
     });    
     $("#btn-find").on("click", QueryGridReturn);
     $("#btn-clear").on("click", ClearConditions);
     $('#btn-print-sure').on('click',PrintSelType); 
     $('#modal-returnprinttype input[type=checkbox]').each(function () {
         $(this).on('ifClicked', function () {
             if ($(this).is(':checked')) {
                 //�������߼�...
                 $(this).iCheck('uncheck'); //�����ѡ�񣬿�����iCheckȡ��ѡ��
             } else {
                 $(this).iCheck('check'); //���ûѡ�񣬿�����iCheck����ѡ��
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
     /* �󶨰�ť�¼� end*/
     ;
     InitButtonStyle();
     ResizeReturn();
     $('#txt-patno').focus();
 })
 //��ʼ��ֱ����ҩtable
 function InitGridReturn() {
     var columns = [{
             header: '����/�������',
             index: 'TWard',
             name: 'TWard',
             width: 150,
             align: 'left'
         },
         {
             header: '�ǼǺ�',
             index: 'TPaNo',
             name: 'TPaNo',
             width: 80
         },
         {
             header: '����',
             index: 'TPaName',
             name: 'TPaName',
             width: 70,
             hidden: true
         },
         {
             header: '����',
             index: 'TBedNo',
             name: 'TBedNo',
             width: 70
         },
         {
             header: 'ҩƷ����',
             index: 'TDesc',
             name: 'TDesc',
             width: 175,
             align: 'left'
         },
         {
             header: '��λ',
             index: 'TUom',
             name: 'TUom',
             width: 60
         },
         {
             header: '��ҩ����',
             index: 'TReturnQty',
             name: 'TReturnQty',
             width: 60,
             editable: true,
             cellattr: addTextCellAttr
         },
         {
             header: '��������',
             index: 'TDispQty',
             name: 'TDispQty',
             width: 60,
             align: 'right'
         },
         {
             header: '��ҩ����',
             index: 'TPhaDispQty',
             name: 'TPhaDispQty',
             width: 60,
             align: 'right'
         },
         {
             header: '��������',
             index: 'TRetReqQty',
             name: 'TRetReqQty',
             width: 60,
             align: 'right',
             hidden: true
         },
         {
             header: '����',
             index: 'TBatchNo',
             name: 'TBatchNo',
             width: 80
         },
         {
             header: '��ҩ�۸�',
             index: 'TReturnPrice',
             name: 'TReturnPrice',
             width: 60,
             align: 'right'
         },
         {
             header: '���',
             index: 'TReturnAmt',
             name: 'TReturnAmt',
             width: 60,
             align: 'right'
         },
         {
             header: '������',
             index: 'TPrescNo',
             name: 'TPrescNo',
             width: 110
         },
         {
             header: '�����ܼ�',
             index: 'TEncryptLevel',
             name: 'TEncryptLevel',
             width: 60,
             hidden: true
         },
         {
             header: '���˼���',
             index: 'TPatLevel',
             name: 'TPatLevel',
             width: 60,
             hidden: true
         },
         {
             header: 'ҩƷ����',
             index: 'TCode',
             name: 'TCode',
             width: 75,
             align: 'left'
         },
         {
             header: 'ҩ��Id',
             index: 'TRECLOCDR',
             name: 'TRECLOCDR',
             width: 60,
             hidden: true
         },
         {
             header: '�������Id',
             index: 'TDspid',
             name: 'TDspid',
             width: 60,
             hidden: true
         },
         {
             header: '����ӱ�Id',
             index: 'TDspSubId',
             name: 'TDspSubId',
             width: 75,
             hidden: true
         },
         {
             header: '��ҩ���Id',
             index: 'TPhacItmLbId',
             name: 'TPhacItmLbId',
             width: 75,
             hidden: true
         },
         {
             header: '��ҩ������־',
             index: 'TCyFlag',
             name: 'TCyFlag',
             width: 75,
             hidden: true
         }
     ];
     var jqOptions = {
         colModel: columns, //��
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryNeedReturn&style=jqGrid', //��ѯ��̨ 
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
                             // ��С���Ĵ���,��ҩ����С������дС��
                             if (dispedqty.toString().indexOf(".") < 0) {
                                 dhcphaMsgBox.message("��" + id + "����ҩ��������ΪС��!")
                                 $("#grid-return").jqGrid('restoreRow', id);
                                 JqGridCanEdit = true;
                                 return false
                             }
                         }
                         if (parseFloat(this.value * 1000) > parseFloat(dispedqty * 1000)) {
                             dhcphaMsgBox.message("��" + id + "����ҩ��������δ������!")
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
 //��֤�������ݺϷ�
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
         dhcphaMsgBox.alert("��" + rowid + "����ҩ����������Ϊ����!");
         return false;
     } else if (parseFloat(diffqty) > 0) {
         dhcphaMsgBox.alert("��" + rowid + "����ҩ�������ܴ��ڷ�ҩ����!");
         return false;
     } else if (isNaN(retqty)) {
         dhcphaMsgBox.alert("��" + rowid + "����ҩ����ӦΪ����!");
         return false;
     } else if (retqty == "") {
         dhcphaMsgBox.alert("��" + rowid + "����ҩ��������Ϊ��!");
         return false;
     } else if (retqty == 0) {
         dhcphaMsgBox.alert("��" + rowid + "����ҩ��������Ϊ0!");
         return false;
     } else {
         var allowret = tkMakeServerCall("web.DHCSTPHARETURN", "AllowReturnByPhacLb", phacitmlbid, parseFloat(retqty));
         if (allowret == "0") {
             dhcphaMsgBox.alert("��" + rowid + "����ҩ�������ܴ��ڷ�ҩ����!");
             return false;
         }
         var checkpartret = tkMakeServerCall("web.DHCSTPHARETURN2", "GetRetParted", dispid, parseFloat(retqty));
         if (checkpartret == "0") {
             dhcphaMsgBox.alert("��" + rowid + "�˼�¼�и����շ���Ŀ�����ܲ�����ҩ!");
             return false;
         }
     }
     var refrefuseflag = tkMakeServerCall("web.DHCST.ARCALIAS", "GetRefReasonByCode", incicode);
     if (refrefuseflag != "") {
         if (refrefuseflag.split("^")[3] != "") {
             dhcphaMsgBox.alert("��" + rowid + "��ҩƷ" + refrefuseflag.split("^")[1] + ",��ҩƷ����������ĿǰΪ������ҩ״̬,��������!</br>������ҩԭ��:" + refrefuseflag.split("^")[3]);
             return false;
         }
     }
     return true
 }
 //��ʼ������
 function InitPhaLoc() {
     var selectoption = {
         allowClear: false,
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
             "?action=GetStockPhlocDs&style=select2&groupId=" +
             DHCPHA_CONSTANT.SESSION.GROUP_ROWID
     }
     $("#sel-phaloc").dhcphaSelect(selectoption)
     var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
     $("#sel-phaloc").append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
     $('#sel-phaloc').on('select2:select', function (event) {
         //alert(event)
     });
 }
 //��ѯֱ����ҩ�б�
 function QueryGridReturn() {
     var stdate = $("#date-start").val();
     var enddate = $("#date-end").val();
     var patno = $.trim($("#txt-patno").val());
     if (patno == "") {
         //dhcphaMsgBox.alert("������ǼǺ�!");
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
 //��ҩ
 function DoReturn() {
     var grid_records = $("#grid-return").getGridParam('records');
     if (grid_records == 0) {
         dhcphaMsgBox.alert($g("��ҩ�б�Ϊ��!"));
     } else {
         var selectids = $("#grid-return").jqGrid('getGridParam', 'selarrrow');
         if ((selectids == "") || (selectids == null)) {
             dhcphaMsgBox.alert($g("���ȹ�ѡ��Ҫ��ҩ�ļ�¼!"));
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
             dhcphaMsgBox.alert("��˲飬û�п�������");
             return;
         }*/
         $("#modal-inpharetreason").modal('show');
     }
 }
 //ִ����ҩ
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
         dhcphaMsgBox.confirm($g("��ҩ�ɹ�!�Ƿ��ӡ��"), ConfirmReturnPrint);
     } else {
         if (retvalue == -3) {
             dhcphaMsgBox.alert($g("����ҩƷ��ҩ���� >  (��ҩ���� - ����ҩ����),��ˢ�º��ʵ!"));
         } else if (retvalue == -12) {
             dhcphaMsgBox.alert($g("����ִ�м�¼״̬����ִֹͣ�л���ִ�е�ҩƷ����������ҩ!"));
         } else if (retvalue == -9) {
             dhcphaMsgBox.alert($g("����δ�����뵥����������ʹ��ֱ����ҩ!"));
         } else if (retvalue == -4) {
             dhcphaMsgBox.alert($g("�û������������ս��㣬��������ҩ!"));
         } else if (retvalue == -11) {
             dhcphaMsgBox.alert($g("��������ҩ:�Ѿ���;����,������ҩ!"));
         } else if (retvalue == -1) {
             dhcphaMsgBox.alert($g("ִ����ҩʧ��,������ҩ�����Ƿ����󣬻�����ҩ�����Ƿ�Ϊ0"));
         } else {
             dhcphaMsgBox.alert($g("ִ����ҩʧ��,�������:") + retvalue);
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
 //���
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
 
 //��ʼ����ҩԭ��ģ��
 function InitReturnModal() {
     var locoption = {
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + "?action=GetInRetReason&Type=select2",
         minimumResultsForSearch: Infinity,
         width: 200
     }
     $("#sel-retreason").dhcphaSelect(locoption)
     //��ҩ
     $('#modal-inpharetreason').on('show.bs.modal', function () {
         $("#sel-retreason ").empty();
     })
     $("#btn-retreason-sure").on("click", function () {
         var returnreason = $("#sel-retreason").val();
         if ((returnreason == "") || (returnreason == null)) {
             dhcphaMsgBox.alert($g("��ѡ����ҩԭ��"));
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
