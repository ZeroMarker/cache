/**
 * ģ��:סԺҩ��
 * ��ģ��:סԺҩ��-ҽ�����
 * createdate:2016-08-25
 * creator:yunhaibao
 */
 var MONITOR_PROP_STR=tkMakeServerCall("web.DHCINPHA.InfoCommon", "GetMonitorPropStr", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
 var MONITOR_PROP_ARR=MONITOR_PROP_STR.split("^");
 DHCPHA_CONSTANT.URL.THIS_URL = ChangeCspPathToAll("dhcpha.outpha.outmonitor.save.csp");
 DHCPHA_CONSTANT.DEFAULT.APPTYPE = "IA";
 DHCPHA_CONSTANT.DEFAULT.PASS = MONITOR_PROP_ARR[0];
 DHCPHA_CONSTANT.DEFAULT.RePassNeedCancel = MONITOR_PROP_ARR[1];
 DHCPHA_CONSTANT.VAR.TIMER = "";
 DHCPHA_CONSTANT.VAR.TIMERSTEP = 30000;
 DHCPHA_CONSTANT.VAR.SELECT = "";
 DHCPHA_CONSTANT.VAR.TAB = "#div-ward-condition"; // ��¼��ǰtab
 var PatientInfo = {
     adm: 0,
     patientID: 0,
     episodeID: 0,
     admType: "I",
     prescno: 0,
     orditem: 0,
     wardid: 0
 };
 $(function () {
     /* ��ʼ����� start*/
     var daterangeoptions = {
         singleDatePicker: true
     }
 
     $("#date-start").dhcphaDateRange(daterangeoptions);
     $("#date-end").dhcphaDateRange(daterangeoptions);
     InitPhaLoc(); //ҩ������
     InitPhaWard(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID); //����
     InitPhaLocGrp(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID); //������
     InitGridWard();
     InitGridWardPat();
     InitGridAdm();
     InitGridOrdDetail();
     InitIPMonitorTab(); //��ҳ��tab
     InitIPOrderModalTab(); //ҽ�������չ��Ϣtab
     $("#monitor-condition").children().not("#div-ward-condition").hide();
     /* ��ʼ����� end*/
     /* ��Ԫ���¼� start*/
     //�ǼǺŻس��¼�
     $('#txt-patno').on('keypress', function (event) {
         if (window.event.keyCode == "13") {
             var patno = $.trim($("#txt-patno").val());
             if (patno != "") {
                 var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                 $(this).val(newpatno);
                 QueryIPMonitor();
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
     $("#btn-find").on("click", QueryIPMonitor);
     $("#btn-prepresc").on("click", ViewIPOrderAddInfo);
     $("#btn-viewlog").on("click", ViewIPOrderMonitorLog);
     $("#btn-pass").on("click", PassIPOrder);
     $("#btn-refuse").on("click", RefuseIPOrder);
     $("#btn-analysis").on("click", PrescAnalyse) //��������
     $("#btn-redir-return").on("click", function () {
         var lnk = ChangeCspPathToAll("dhcpha/dhcpha.inpha.returnbyreq.csp");
         websys_createWindow(lnk, "��ҩ", "width=95%,height=75%");
         //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-35)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=95,left=3,location=no") ;
     });
     $("#btn-autorefresh").on("click", AutoRefreshMonitor)
     /* �󶨰�ť�¼� end*/
     ;
     InitBodyStyle();
 })
 window.onload = function () {
     if (LoadPatNo != "") {
         setTimeout("QueryByPatNo()",500);
     } else if (gDateRange!="") {
         setTimeout("QueryByDate()",500);
     } else {
         // �˵�����
         QueryIPMonitor();
     }
 }
function InitParams(){
    if(LoadOrdItmId==""){return;}
    var retVal=tkMakeServerCall("PHA.COM.Method","GetOrdItmInfoForTipMess",LoadOrdItmId);
    if(retVal!="{}"){
        var retJson=JSON.parse(retVal)
        var ordDate=retJson.ordDate;
         $("#date-start").data('daterangepicker').setStartDate(ordDate);
         $("#date-start").data('daterangepicker').setEndDate(ordDate);
    }
}
 //��ʼ����table
 function InitGridWard() {
     var columns = [{
             header: '����',
             index: 'warddesc',
             name: 'warddesc',
             width: 200
         },
         {
             header: 'wardid',
             index: 'wardid',
             name: 'wardid',
             width: 200,
             hidden: true
         }
     ];
     var jqOptions = {
         colModel: columns, //��
         url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=GetWardListData&style=jqGrid', //��ѯ��̨ 
         height: DhcphaJqGridHeight(1, 2) - parseFloat($("#tab-ipmonitor").outerHeight()) - 20, //IPMonitorCanUseHeight()-40-40-5,
         multiselect: false,
         viewrecords: false,
         datatype: 'local',
         pager: "#jqGridPager1", //��ҳ�ؼ���id  
         onSelectRow: function (id, status) {
             var id = $(this).jqGrid('getGridParam', 'selrow');
             if (id) {
                 var selrowdata = $(this).jqGrid('getRowData', id);
                 var wardid = selrowdata.wardid;
                 InitPatientInfo();
                 PatientInfo.wardid = wardid;
                 QueryIPMonitorOrdDetail();
             }
         },
         loadComplete: function () {
             var grid_records = $(this).getGridParam('records');
             if (grid_records == 0) {
                 $("#grid-orderdetail").clearJqGrid();
             } else {
                 $(this).jqGrid('setSelection', 1);
             }
         }
     };
     $('#grid-wardlist').dhcphaJqGrid(jqOptions);
 }
 //��ʼ��������table
 function InitGridWardPat() {
     var columns = [{
             header: '�ǼǺ�',
             index: 'patid',
             name: 'patid',
             width: 90
         },
         {
             header: '����',
             index: 'patloc',
             name: 'patloc',
             width: 160,
             align: 'left'
         },
         {
             header: '����',
             index: 'bedno',
             name: 'bedno',
             width: 80
         },
         {
             header: 'adm',
             index: 'adm',
             name: 'adm',
             width: 80,
             hidden: 'true'
         },
         {
             header: 'papmi',
             index: 'papmi',
             name: 'papmi',
             width: 80,
             hidden: true
         }
     ];
     var jqOptions = {
         colModel: columns, //��
         url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=GetAdmTreeData&style=jqGrid', //��ѯ��̨  
         height: DhcphaJqGridHeight(1, 2) - parseFloat($("#tab-ipmonitor").outerHeight()) - 20,
         multiselect: false,
         viewrecords: false,
         pager: "#jqGridPager2", //��ҳ�ؼ���id
         onSelectRow: function (id, status) {
             var id = $(this).jqGrid('getGridParam', 'selrow');
             if (id) {
                 var selrowdata = $(this).jqGrid('getRowData', id);
                 InitPatientInfo();
                 PatientInfo.adm = selrowdata.adm;
                 PatientInfo.patientID = selrowdata.papmi;
                 PatientInfo.allOrd = 1;
                 QueryIPMonitorOrdDetail();
             }
         },
         loadComplete: function () {
             var grid_records = $(this).getGridParam('records');
             if (grid_records == 0) {
                 $("#grid-orderdetail").clearJqGrid();
             } else {
                 $(this).jqGrid('setSelection', 1);
             }
         }
     };
     $('#grid-wardpatlist').dhcphaJqGrid(jqOptions);
 }
 //��ʼ���˾���table
 function InitGridAdm() {
     var columns = [{
             header: 'adm',
             index: 'adm',
             name: 'adm',
             width: 80,
             hidden: true
         },
         {
             header: '����',
             index: 'currward',
             name: 'currward',
             width: 140,
             align:'left'
         },
         {
             header: '����',
             index: 'currbed',
             name: 'currbed',
             width: 100,
             align:'left'
         },
         {
             header: 'ҽ��',
             index: 'currdoc',
             name: 'currdoc',
             width: 100,
             align:'left'
         },
         {
             header: '����ʱ��',
             index: 'admdate',
             name: 'admdate',
             width: 155
         },
         {
             header: '�������',
             index: 'admloc',
             name: 'admloc',
             width: 150,
             align:'left'
         },
         {
             header: 'papmi',
             index: 'papmi',
             name: 'papmi',
             width: 80,
             hidden: true
         }
     ];
     var jqOptions = {
         colModel: columns, //��
         url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=GetAdmDs&style=jqGrid', //��ѯ��̨    
         height: DhcphaJqGridHeight(1, 1) - parseFloat($("#tab-ipmonitor").outerHeight()) - 10,
         multiselect: false,
         onSelectRow: function (id, status) {
             var id = $(this).jqGrid('getGridParam', 'selrow');
             if (id) {
                 var selrowdata = $(this).jqGrid('getRowData', id);
                 InitPatientInfo();
                 PatientInfo.adm = selrowdata.adm;
                 PatientInfo.patientID = selrowdata.papmi;
                 PatientInfo.allOrd = 0;
                 QueryIPMonitorOrdDetail();;
             }
         },
         loadComplete: function () {
             var grid_records = $(this).getGridParam('records');
             if (grid_records == 0) {
                 $("#grid-orderdetail").clearJqGrid();
             } else {
                 $(this).jqGrid('setSelection', 1);
             }
         }
     };
     $('#grid-admlist').dhcphaJqGrid(jqOptions);
 }
 //��ʼ��ҽ����ϸtable
 function InitGridOrdDetail() {
     var columns = [{
             header: '������ҩ',
             index: 'druguse',
             name: 'druguse',
             width: 65,
             formatter: druguseFormatter
         },
         {
             header: 'ע����Ŀ',
             index: 'warningmsg',
             name: 'warningmsg',
             width: 75
         },
         {
             header: '��˽��',
             index: 'result',
             name: 'result',
             width: 75,
             cellattr: addPassStatCellAttr
         },
         {
             header: '�ǼǺ�',
             index: 'patid',
             name: 'patid',
             width: 100
         },
         {
             header: '����',
             index: 'patname',
             name: 'patname',
             width: 100,
             align: 'left'
         },
         {
             header: 'adm',
             index: 'adm',
             name: 'adm',
             hidden: true
         },
         {
             header: 'ҩƷ����',
             index: 'incidesc',
             name: 'incidesc',
             width: 250,
             align: 'left',
             formatter: function (cellvalue, options, rowObject) {
                 if (DHCPHA_CONSTANT.DEFAULT.PASS != "") {
                     return "<a onclick=\"DrugTips()\" style='cursor:pointer;' class='pha-med-book'>" + cellvalue + "</a>";
                 } else {
                     return cellvalue;
                 }
             }
         },
         {
             header: '����',
             index: 'dosage',
             name: 'dosage',
             width: 100,
             align: 'left'
         },
         {
             header: 'Ƶ��',
             index: 'freq',
             name: 'freq',
             width: 100,
             align: 'left'
         },
         {
             header: '���',
             index: 'spec',
             name: 'spec',
             width: 100,
             hidden: true
         },
         {
             header: '�÷�',
             index: 'instruc',
             name: 'instruc',
             width: 100,
             align: 'left'
         },
         {
             header: '����',
             index: 'qty',
             name: 'qty',
             width: 50,
             align: 'right'
         },
         {
             header: '��λ',
             index: 'uomdesc',
             name: 'uomdesc',
             width: 60,
             align: 'left'
         },
         {
             header: '����',
             index: 'form',
             name: 'form',
             width: 100,
             align: 'left'
         },
         {
             header: 'ҽ�����ȼ�',
             index: 'ordpri',
             name: 'ordpri',
             width: 80
         },
         {
             header: '����ҩ��',
             index: 'basflag',
             name: 'basflag',
             width: 70
         },
         {
             header: 'ҽ��',
             index: 'doctor',
             name: 'doctor',
             width: 100
         },
         {
             header: 'ҽ������ʱ��',
             index: 'orddate',
             name: 'orddate',
             width: 155
         },
         {
             header: 'ҽ����ע',
             index: 'remark',
             name: 'remark',
             width: 80
         },
         {
             header: '���',
             index: 'diagDesc',
             name: 'diagDesc',
             width: 400,
             align:"left"
 //            ,
 //            formatter: function (cellvalue, options, rowdata) {
 //                return '<div style="white-space: nowrap;">' + cellvalue + '</div>';
 //            }
         },
         {
             header: '������ҵ',
             index: 'manf',
             name: 'manf',
             width: 150,
             align: 'left',
             hidden: true
         },
         {
             header: '����',
             index: 'price',
             name: 'price',
             width: 60,
             align: 'right',
             formatter: 'number',
             formatoptions: {
                 decimalPlaces: 4
             },
             hidden: true
         },
         {
             header: '���',
             index: 'amt',
             name: 'amt',
             width: 80,
             align: 'right',
             hidden: true
         },
         {
             header: 'orditem',
             index: 'orditem',
             name: 'orditem',
             hidden: true
         },
         {
             header: 'mainflag',
             index: 'mainflag',
             name: 'mainflag',
             hidden: true
         },
         {
             header: 'colorflag',
             index: 'colorflag',
             name: 'colorflag',
             hidden: true
         },
         {
             header: 'moeori',
             index: 'moeori',
             name: 'moeori',
             hidden: true
         },
         {
             header: 'adm',
             index: 'adm',
             name: 'adm',
             hidden: true
         },
         {
             header: 'papmi',
             index: 'papmi',
             name: 'papmi',
             hidden: true
         },
         {
             header: '����������',
             index: 'druguseresult',
             name: 'druguseresult',
             width: 65,
             hidden: true
         }
     ];
     var jqOptions = {
         colModel: columns, //��
         url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=FindIPOrdDetailDs&style=jqGrid', //��ѯ��̨   
         height: DhcphaJqGridHeight(1, 2),
         multiselect: true,
         shrinkToFit: false,
         datatype: 'local',
         pager: "#jqGridPager", //��ҳ�ؼ���id  
         onSelectRow: function (id, status) {
             if (DHCPHA_CONSTANT.VAR.SELECT != "") {
                 return;
             }
             if (id) {
                 var selrowdata = $(this).jqGrid('getRowData', id);
                 PatientInfo.adm = selrowdata.adm;
                 PatientInfo.patientID = selrowdata.papmi;
             }
             DHCPHA_CONSTANT.VAR.SELECT = 1; //�˴��д��Ľ�,20160829yunhaibao
             SelectLinkOrder(id)
             DHCPHA_CONSTANT.VAR.SELECT = "";
         },
         onCellSelect: function (rowIndex, iCol, cellcontent, e) {
             var field = $(this).jqGrid('getGridParam', 'colModel')[iCol].index;
             if (field != "druguse") {
                 return
             }
             var content = $(this).jqGrid('getRowData', rowIndex).druguseresult;
             DHCSTPHCMPASS.AnalysisTips({
                 Content: content
             })
         }
     };
     $('#grid-orderdetail').dhcphaJqGrid(jqOptions);
 }
 
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
         $("#sel-phalocgrp").val("");
         InitPhaLocGrp($(this).val());
         $("#sel-phaward").val("");
         InitPhaWard($(this).val());
     });
 }
 
 function InitPhaWard(locid) {
     var selectoption = {
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
             "?action=GetWardLocDsByRecLoc&style=select2"+"&reclocId="+ locid,
         placeholder: $g("����")+"..."
     }
     $("#sel-phaward").dhcphaSelect(selectoption)
 }
 
 function InitPhaLocGrp(locid) {
     var selectoption = {
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
             '?action=GetLocGroupDs&style=select2&locId=' + locid,
         placeholder: $g("������")+"..."
     }
     $("#sel-phalocgrp").dhcphaSelect(selectoption)
 }
 //��ȡ����
 function GetIPMonitorParams() {
     var phaloc = $("#sel-phaloc").val();
     var phaward = $("#sel-phaward").val();
     if (phaward == null) {
         phaward = "";
     }
     var phalocgrp = $("#sel-phalocgrp").val();
     if (phalocgrp == null) {
         phalocgrp = "";
     }
     var startdate = $("#date-start").val();
     var enddate = $("#date-end").val();
     var daterange = startdate + "^" + enddate;
     var tmpphaward = PatientInfo.wardid;
     if (tmpphaward != 0) {
         phaward = tmpphaward;
     }
     var chkaudit = "";
     if ($("#chk-audit").is(':checked')) {
         chkaudit = 1;
     }
     var chkout = "";
     if ($("#chk-outdrug").is(':checked')) {
         chkout = true;
     }
     if ($("#chk-refuse").is(':checked')) {
         chkaudit = 2;
     }
     var params = daterange + "^" + phaloc + "^" + phaward + "^" + chkout + "^" + chkaudit + "^" + phalocgrp + '^' + LoadAppealFlag;
     return params;
 }
 //��ѯ
 function QueryIPMonitor() {
     InitPatientInfo();
     var params = GetIPMonitorParams();
     if (DHCPHA_CONSTANT.VAR.TAB == "#div-ward-condition") {
         $("#grid-wardlist").setGridParam({
             page: 1,
             datatype: 'json',
             postData: {
                 'input': params
             }
         }).trigger("reloadGrid");
     }
     if (DHCPHA_CONSTANT.VAR.TAB == "#div-wardpat-condition") {
         $("#grid-wardpatlist").setGridParam({
             page: 1,
             datatype: 'json',
             postData: {
                 'input': params
             }
         }).trigger("reloadGrid");
     }
     if (DHCPHA_CONSTANT.VAR.TAB == "#div-patno-condition") {
         var patno = $("#txt-patno").val();
         $("#grid-admlist").setGridParam({
             page: 1,
             datatype: 'json',
             postData: {
                 'RegNo': patno
             }
         }).trigger("reloadGrid");
     }
     return true
 }
 //��ѯδ���ҽ��
 function QueryIPMonitorOrdDetail() {
     if ((PatientInfo.adm == 0) && (PatientInfo.wardid == 0)) return;
     if (DHCPHA_CONSTANT.VAR.TAB == "#div-ward-condition") {
         PatientInfo.adm = 0;
     }
     var params = PatientInfo.adm + "^" + GetIPMonitorParams();
     $("#grid-orderdetail").setGridParam({
         page: 1,
         datatype: 'json',
         postData: {
             'input': params
         }
     }).trigger("reloadGrid");
 }
 
 //ҽ�������չ��Ϣmodal
 function ViewIPOrderAddInfo() {
     var grid_records = $("#grid-orderdetail").getGridParam('records');
     if (grid_records == 0) {
         dhcphaMsgBox.alert($g("��ǰ����������"));
         return;
     }
     var selectid = $("#grid-orderdetail").jqGrid('getGridParam', 'selrow');
     if (selectid == null) {
         dhcphaMsgBox.alert($g("����ѡ����Ҫ�鿴�ļ�¼"));
         return;
     }
     //$("#modal-prescinfo").find(".modal-dialog").css({height:"200px"});
     $("#modal-prescinfo").modal('show');
 }
 //�鿴��־
 function ViewIPOrderMonitorLog() {
     var grid_records = $("#grid-orderdetail").getGridParam('records');
     if (grid_records == 0) {
         dhcphaMsgBox.alert($g("��ǰ����������"));
         return;
     }
     var selectid = $("#grid-orderdetail").jqGrid('getGridParam', 'selrow');
     if (selectid == null) {
         dhcphaMsgBox.alert($g("����ѡ����Ҫ�鿴�ļ�¼"));
         return;
     }
     var selectdata = $('#grid-orderdetail').jqGrid('getRowData', selectid);
     var orditm = selectdata.orditem;
     var logoptions = {
         id: "#modal-monitorlog",
         orditm: orditm,
         fromgrid: "#grid-orderdetail",
         fromgridselid: selectid
     };
     InitOutMonitorLogBody(logoptions)
 }
 //ע��modaltab�¼�
 function InitIPOrderModalTab() {
     $("#ul-monitoraddinfo a").on('click', function () {
         var adm = PatientInfo.adm;
         var prescno = PatientInfo.prescno;
         var zcyflag = PatientInfo.zcyflag;
         var patientID = PatientInfo.patientID;

        /* MaYuqiang 20220517 ��������Ϣ����ͷ�˵����������ý��洮���� */
        var menuWin = websys_getMenuWin();  // ���ͷ�˵�Window����
        if (menuWin){       
            var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
            if((frm) &&(frm.EpisodeID.value != adm)){
                if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails();  //���ͷ�˵������в��������Ϣ
                frm.EpisodeID.value = adm; 
                frm.PatientID.value = patientID;
            }
        }

         var tabId = $(this).attr("id")
         if (tabId == "tab-allergy") {
             $('iframe').attr('src', ChangeCspPathToAll('dhcdoc.allergyenter.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + "&IsOnlyShowPAList=Y");
 
         }
         if (tabId == "tab-risquery") {
             $('iframe').attr('src', ChangeCspPathToAll('dhcapp.inspectrs.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm);
         }
         if (tabId == "tab-libquery") {
             $('iframe').attr('src', ChangeCspPathToAll('dhcapp.seepatlis.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&NoReaded=' + '1');
         }
         if (tabId == "tab-eprquery") {
             
             $('iframe').attr('src', ChangeCspPathToAll('emr.browse.manage.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + session['LOGON.CTLOCID']);
             // v8.4֮ǰ
             //$('iframe').attr('src', ChangeCspPathToAll('emr.interface.browse.episode.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + session['LOGON.CTLOCID']);
         }
         if (tabId == "tab-orderquery") {
             $('iframe').attr('src', ChangeCspPathToAll('ipdoc.patorderview.csp') + '?EpisodeID=' + adm + '&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
             //$('iframe').attr('src', ChangeCspPathToAll('oeorder.opbillinfo.csp'+'?EpisodeID=' +adm)); 
         }
         if (tabId == "tab-beforeindrug") {
             $('iframe').attr('src', ChangeCspPathToAll('dhcpha.comment.othmedquery.csp') + '?EpisodeID=' + adm);
         }
     })
 
     $('#modal-prescinfo').on('show.bs.modal', function () {
         $("#modal-prescinfo .modal-dialog").width($(window).width() * 0.9);
         $("#modal-prescinfo .modal-body").height($(window).height() * 0.85);
         var tmpiframeheight = $(window).height() * 0.85 -
             $("#modal-prescinfo .modal-header").height() -
             $("#modal-prescinfo #ul-monitoraddinfo").height() -
             50
         $("#ifrm-outmonitor").height(tmpiframeheight)
         $('iframe').attr('src', ChangeCspPathToAll("dhcpha.comment.queryorditemds.csp") + "?EpisodeID=" + PatientInfo.adm);
         var selectid = $("#grid-orderdetail").jqGrid('getGridParam', 'selrow');
         var selectdata = $('#grid-orderdetail').jqGrid('getRowData', selectid);
         var patoptions = {
             id: "#dhcpha-patinfo",
             orditem: selectdata.orditem
         };
         AppendPatientOrdInfo(patoptions);
         var tabId = $(this).attr("id");
         if (tabId != "tab-allergy") {
             $("#tab-allergy").click()
         }
     })
     $("#modal-prescinfo").on("hidden.bs.modal", function () {
         //$(this).removeData("bs.modal");
     });
     $("#tab-viewpresc").hide();
 }
 //���ͨ��
 function PassIPOrder() {
     var selectids = $("#grid-orderdetail").jqGrid('getGridParam', 'selarrrow');
     if (selectids == "") {
         dhcphaMsgBox.alert($g("����ѡ����Ҫ��˵ļ�¼"));
         return;
     }
     var canpass = 0;
     canpassi = 0;
     var i = 0;
     $.each(selectids, function () {
         var rowdata = $('#grid-orderdetail').jqGrid('getRowData', this);
         var rowresult = rowdata.result;
         canpassi = canpassi + 1;
         if (rowresult == "�ܾ�(����)") {
             canpass = "2"
             return false; //false �˳�ѭ��
         }
         if (DHCPHA_CONSTANT.DEFAULT.RePassNeedCancel==="Y"){
             if (rowresult==="ͨ��" || rowresult=="�ܾ�"){
                 canpass = "3"
                 return false; //false �˳�ѭ��         
             }
         }
     })
     if (canpass == 2) {
         dhcphaMsgBox.alert("��ѡ��ĵ�" + canpassi + "���Ѿܾ�(����),�����ٴ����ͨ�� !");
         return;
     }
     if (canpass == 3) {
         dhcphaMsgBox.alert("��ѡ��ĵ�" + canpassi + "���Ѵ���,����ֱ�Ӳ���,����ȡ��!");
         return;
     }
     var orditem = "";
     var ret = "Y";
     var reasondr = "";
     var advicetxt = "";
     var factxt = "";
     var phnote = "";
     var guser = session['LOGON.USERID'];
     var ggroup = session['LOGON.GROUPID'];
     var i = 0;
     var mOeoriArr = [];
     $.each(selectids, function () {
         var rowdata = $('#grid-orderdetail').jqGrid('getRowData', this);
         var moeori = rowdata.moeori;
         if (mOeoriArr.indexOf(moeori) >= 0) {
             return true;
         }
         mOeoriArr.push(moeori);
         var input = ret + "^" + guser + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + ggroup + "^" + moeori;
         var input = input + "^" + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
         SaveCommontResult(reasondr, input)
     });
     QueryIPMonitorOrdDetail();
 
 }
 //��˾ܾ�
 function RefuseIPOrder() {
     var grid_records = $("#grid-orderdetail").getGridParam('records');
     if (grid_records == 0) {
         dhcphaMsgBox.alert($g("����ϸ����"));
         return;
     }
     var selectid = $("#grid-orderdetail").jqGrid('getGridParam', 'selrow');
     if ((selectid == "") || (selectid == null)) {
         dhcphaMsgBox.alert($g("����ѡ����Ҫ�ܾ��ļ�¼"));
         return;
     }
 
     var orditmstr = "";
     var selectdata = $('#grid-orderdetail').jqGrid('getRowData', selectid);
     var selectids = $("#grid-orderdetail").jqGrid('getGridParam', 'selarrrow');
     var idslen = selectids.length;
     var mainoeori = selectdata.moeori;
     var canrefuse = "";
     for (var i = 0; i < idslen; i++) {
         var tmprowdata = $('#grid-orderdetail').jqGrid('getRowData', selectids[i]);
         var tmpmoeori = tmprowdata.moeori;
         if (tmpmoeori != mainoeori) {
             dhcphaMsgBox.alert($g("ÿ��ֻ��ѡ��һ����¼�ܾ�"));
             return;
         }
         var iaresult = tmprowdata.result;
         if (iaresult == "�ܾ�(����)") {
             canrefuse = 2;
             break;
         }
         var warnmsg=tmprowdata.warningmsg;
         if (warnmsg.indexOf("��ʿ�ܾ�")>=0){
             canrefuse = 3;
             break;
         }
         if (DHCPHA_CONSTANT.DEFAULT.RePassNeedCancel==="Y"){
             if (iaresult==="ͨ��" || iaresult==="�ܾ�"){
                 canrefuse = 4;
                 break;     
             }
         }
         var orditm = tmprowdata.orditem;
         if (mainoeori == tmpmoeori) {
             if (orditmstr == "") {
                 orditmstr = orditm
             } else {
                 orditmstr = orditmstr + "^" + orditm
             }
         }
     }
    
     if (canrefuse == 2) {
         dhcphaMsgBox.alert($g("��ѡ��ļ�¼�Ѿ��ܾ�(����)"));
         return;
     }
     if (canrefuse == 3) {
         dhcphaMsgBox.alert($g("��ѡ��ļ�¼�Ѿ���ʿ�ܾ�"));
         return;
     }
     if (canrefuse == 4) {
         dhcphaMsgBox.alert($g("��ѡ��ļ�¼�Ѵ���,����ֱ�Ӳ���,����ȡ��"));
         return;
     }
     var dispedRet = tkMakeServerCall("web.DHCSTCNTSIPMONITOR", "IfOrderDisped", mainoeori);
     if (dispedRet == "Y") {
         dhcphaMsgBox.alert($g("��ѡ��ļ�¼�Ѿ���ҩ"));
         return;
     }
     var waycode = DHCPHA_CONSTANT.DEFAULT.INPHAWAY;
     ShowPHAPRASelReason({
         wayId:waycode,
         oeori:orditmstr,
         prescNo:"",
         selType:"OEORI"
     },SaveCommontResultEX,{orditm:orditm});
 }
 
 function SaveCommontResultEX(reasonStr,origOpts){
     if (reasonStr==""){
         return;
     }
     var retarr = reasonStr.split("@");
     var ret = "N";
     var reasondr = retarr[0];
     var advicetxt = retarr[2];
     var factxt = retarr[1];
     var phnote = retarr[3];
     var User = session['LOGON.USERID'];
     var grpdr = session['LOGON.GROUPID'];
     var input = ret + "^" + User + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + grpdr + "^" + origOpts.orditm;
     var input = input + "^" + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
     SaveCommontResult(reasondr, input);    
 }
 
 //���ͨ��/�ܾ�
 function SaveCommontResult(reasondr, input) {
     $.ajax({
         url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=SaveItmResultIPMo&Input=' + encodeURI(input) + '&ReasonDr=' + reasondr,
         type: 'post',
         success: function (data) {
             var retjson = eval("(" + data + ")");
             if (retjson.retvalue == 0) {
                 QueryIPMonitorOrdDetail();
                 if (top && top.HideExecMsgWin) {
                     top.HideExecMsgWin();
                 }
             } else {
                 dhcphaMsgBox.alert(retjson.retinfo);
                 return
             }
         },
         error: function () {}
     })
 }
 //��������
 function PrescAnalyse() {
     var passType = DHCPHA_CONSTANT.DEFAULT.PASS;
     if (passType == "") {
         dhcphaMsgBox.alert($g("δ���ô��������ӿڣ����ڲ�������-סԺҩ��-������ҩ������ҵ�������Ӧ������ҵ"));
         return;
     }
     if (passType == "DHC") {
         // ����֪ʶ��
         DHCSTPHCMPASS.PassAnalysis({
             GridId: "grid-orderdetail",
             MOeori: "moeori",
             PrescNo: "",
             GridType: "JqGrid",
             Field: "druguse",
             ResultField: "druguseresult"
         });
     } else if (passType == "MK") {
         dhcphaMsgBox.alert($g("�ӿ���δ����"));
         // ����
         //MKPrescAnalyse(); 
     } else if (passType == "YY") {
         dhcphaMsgBox.alert($g("�ӿ���δ����"));
     }
 }
 
 ///ҩ����ʾ
 function DrugTips() {
     var passType = DHCPHA_CONSTANT.DEFAULT.PASS;
     if (passType == "") {
         dhcphaMsgBox.alert($g("δ����ҩ��ӿڣ����ڲ�������-סԺҩ��-������ҩ������ҵ�������Ӧ������ҵ"));
         return;
     }
     var $td = $(event.target).closest("td");
     var rowid = $td.closest("tr.jqgrow").attr("id");
     var selectdata = $('#grid-orderdetail').jqGrid('getRowData', rowid);
     var incDesc = $.jgrid.stripHtml(selectdata.incidesc);
     var orditm = selectdata.orditem;
     if (passType == "DHC") {
         // ����֪ʶ��
         var userInfo = session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'];
         DHCSTPHCMPASS.MedicineTips({
             Oeori: orditm,
             UserInfo: userInfo,
             IncDesc: incDesc
         })
     } else if (passType == "MK") {
         //dhcphaMsgBox.alert("�ӿ���δ����")
         // ����
         MKPrescTips(orditm); 
     } else if (passType == "YY") {
         dhcphaMsgBox.alert($g("�ӿ���δ����"))
     }
 
 }
 
 function InitIPMonitorTab() {
     $("#tab-ipmonitor a").on('click', function () {
         ;
         var tabId = $(this).attr("id");
         var tmpTabId = "#div-" + tabId.split("-")[1] + "-condition";
         $(tmpTabId).show();
         $("#monitor-condition").children().not(tmpTabId).hide();
         DHCPHA_CONSTANT.VAR.TAB = tmpTabId;
         QueryIPMonitor();
     })
 
 }
 
 function AutoRefreshMonitor() {
     if ($("#btn-autorefresh").attr('code') === 'stopRefresh') {
         $("#btn-autorefresh").css("color", "#727272");
         $("#btn-autorefresh").children("i").css("color", "#999999");
         $("#btn-autorefresh").children("strong").css("color", "#727272");
         $("#btn-autorefresh").children("strong").text($g("�Զ�ˢ��"));
         $("#btn-autorefresh").attr('code','startRefresh')
         clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
     } else {
         $("#btn-autorefresh").css("color", "#40A2DE");
         $("#btn-autorefresh").children("i").css("color", "#40A2DE");
         $("#btn-autorefresh").children("strong").css("color", "#40A2DE");
         $("#btn-autorefresh").children("strong").text($g("ֹͣˢ��"));
         $("#btn-autorefresh").attr('code','stopRefresh')
         DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryIPMonitor();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
     }
 }
 //����ҽ��ѡ��
 function SelectLinkOrder(id) {
     var selrowdata = $("#grid-orderdetail").jqGrid('getRowData', id);
     var detailrows = $("#grid-orderdetail").getGridParam('records');
     var mainoeori = selrowdata.moeori;
     for (var i = 1; i <= detailrows; i++) {
         var tmprowdata = $('#grid-orderdetail').jqGrid('getRowData', i);
         if (id == i) {
             continue;
         }
         var tmpmoeori = tmprowdata.moeori;
         if (mainoeori == tmpmoeori) {
             $("#grid-orderdetail").jqGrid("setSelection", i);
         }
     }
     DHCPHA_CONSTANT.VAR.SELECT = "";
 }
 
 function InitPatientInfo() {
     PatientInfo = {
         adm: 0,
         patientID: 0,
         episodeID: 0,
         admType: "I",
         prescno: 0,
         orditem: 0,
         wardid: 0
     };
 }
 
 function InitBodyStyle() {
     $("#grid-orderdetail").setGridWidth("");
     $("#div-wardpat-condition .ui-pg-selbox").hide();
     $("#div-ward-condition .ui-pg-selbox").hide();
 }
 
 function addPassStatCellAttr(rowId, val, rawObject, cm, rdata) {
     if (val.indexOf("ͨ��")>=0) {
         return "class=dhcpha-record-passed";
     } else if (val.indexOf("�ܾ�")>=0) {
         return "class=dhcpha-record-refused";
     } else if (val.indexOf("����")>=0) {
         return "class=dhcpha-record-appeal";
     } else if (val.indexOf("�ܾ�(����)")>=0) {
         return "class=dhcpha-record-reaccept";
     } else {
         return "";
     }
 }
 
 //��ʽ����
 function druguseFormatter(cellvalue, options, rowdata) {
     if (cellvalue == undefined) {
         cellvalue = "";
     }
     var imageid = "";
     if (cellvalue == "0") {
         imageid = "warning0.gif";
     } else if (cellvalue == "1") {
         imageid = "yellowlight.gif";
     } else if (cellvalue == "2") {
         imageid = "warning2.gif"
     } else if (cellvalue == "3") {
         imageid = "warning3.gif"
     } else if (cellvalue == "4") {
         imageid = "warning4.gif"
     }
     if (imageid == "") {
         return cellvalue;
     }
     //return '<img src="'+DHCPHA_CONSTANT.URL.PATH+'/scripts/pharmacy/images/'+imageid+'" alt="' + cellvalue + '" ></img>'
     return '<img src="'+DHCPHA_CONSTANT.URL.PATH+'/scripts/pharmacy/images/' + imageid + '" ></img>'
 }
 /***********************������� start  ****************************/
 function MKPrescAnalyse() {
     var detailrows = $("#grid-orderdetail").getGridParam('records');
     if (detailrows == 0) {
         dhcphaMsgBox.alert($g("ҽ����ϸ������"));
         return;
     }
 
     for (var i = 1; i <= detailrows; i++) {
         var tmprowdata = $('#grid-orderdetail').jqGrid('getRowData', i);
         var moeori = tmprowdata.moeori
         var myrtn = HLYYPreseCheck(moeori, 0);
         var newdata = {
             druguse: myrtn
         };
         $("#grid-orderdetail").jqGrid('setRowData', i, newdata);
     }
 }
 
 
 function HLYYPreseCheck(moeori, flag) {
     var XHZYRetCode = 0 //������鷵�ش���
 
     MKXHZY1(moeori, flag);
     //��Ϊͬ������,ȡ��McPASS.ScreenHighestSlcode
     //��Ϊ�첽����,����ûص���������.
     //ͬ���첽ΪMcConfig.js MC_Is_SyncCheck true-ͬ��;false-�첽
     XHZYRetCode = McPASS.ScreenHighestSlcode;
     return XHZYRetCode
 }
 
 function MKXHZY1(moeori, flag) {
     MCInit1(moeori);
     HisScreenData1(moeori);
     MDC_DoCheck(HIS_dealwithPASSCheck, flag);
 }
 
 function MCInit1(moeori) {
     var PrescStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetOrderMainInfo", moeori);
     var prescdetail = PrescStr.split("^")
     var pass = new Params_MC_PASSclient_In();
     pass.HospID = prescdetail[0];
     pass.UserID = prescdetail[1];
     pass.UserName = prescdetail[2];
     pass.DeptID = prescdetail[3];
     pass.DeptName = prescdetail[4];
     pass.CheckMode = "zyyf" //MC_global_CheckMode;
     MCPASSclient = pass;
 }
 
 function HIS_dealwithPASSCheck(result) {
     if (result > 0) {} else {}
     return result;
 }
 
 
 function HisScreenData1(moeori) {
     var Orders = "";
     var Para1 = ""
     var PrescMStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetOrderMainInfo", moeori);
     var PrescMInfo = PrescMStr.split("^")
     //var Orders=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
     var Orders = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetOrdDetailByMOrder", moeori);
     if (Orders == "") {
         return;
     }
     var DocName = PrescMInfo[2];
     var EpisodeID = PrescMInfo[5];
     if ((EpisodeID == "") || (EpisodeID == undefined)) {
         return
     }
     var ret = tkMakeServerCall("web.DHCDocHLYYMK", "GetPrescInfo", EpisodeID, Orders, DocName);
     var TempArr = ret.split(String.fromCharCode(2));
     var PatInfo = TempArr[0];
     var MedCondInfo = TempArr[1];
     var AllergenInfo = TempArr[2];
     var OrderInfo = TempArr[3];
     var PatArr = PatInfo.split("^");
 
 
     var ppi = new Params_MC_Patient_In();
     ppi.PatCode = PatArr[0]; // ���˱���
     ppi.InHospNo = PatArr[11]
     ppi.VisitCode = PatArr[7] // סԺ����
     ppi.Name = PatArr[1]; // ��������
     ppi.Sex = PatArr[2]; // �Ա�
     ppi.Birthday = PatArr[3]; // ��������
 
     ppi.HeightCM = PatArr[5]; // ���
     ppi.WeighKG = PatArr[6]; // ����
     ppi.DeptCode = PatArr[8]; // סԺ����
     ppi.DeptName = PatArr[12]
     ppi.DoctorCode = PatArr[13]; // ҽ��
     ppi.DoctorName = PatArr[9]
     ppi.PatStatus = 1
     ppi.UseTime = PatArr[4]; // ʹ��ʱ��
     ppi.CheckMode = MC_global_CheckMode
     ppi.IsDoSave = 1
     MCpatientInfo = ppi;
     var arrayDrug = new Array();
     var pri;
     var OrderInfoArr = OrderInfo.split(String.fromCharCode(1));
     //alert(OrderInfo)
     McRecipeCheckLastLightStateArr = new Array();
     for (var i = 0; i < OrderInfoArr.length; i++) {
         var OrderArr = OrderInfoArr[i].split("^");
         //����core�ģ�������core���ر�Ƶ�Ψһ��ţ�����ĵ�div��idҲӦ�ú���������
         drug = new Params_Mc_Drugs_In();
 
         drug.Index = OrderArr[0]; //ҩƷ���
         drug.OrderNo = OrderArr[0]; //ҽ����
         drug.DrugUniqueCode = OrderArr[1]; //ҩƷ����
         drug.DrugName = OrderArr[2]; //ҩƷ����
         drug.DosePerTime = OrderArr[3]; //��������
         drug.DoseUnit = OrderArr[4]; //��ҩ��λ      
         drug.Frequency = OrderArr[5]; //��ҩƵ��
         drug.RouteCode = OrderArr[8]; //��ҩ;������
         drug.RouteName = OrderArr[8]; //��ҩ;������
         drug.StartTime = OrderArr[6]; //����ʱ��
         drug.EndTime = OrderArr[7]; //ͣ��ʱ��
         drug.ExecuteTime = ""; //ִ��ʱ��
         drug.GroupTag = OrderArr[10]; //������
         drug.IsTempDrug = OrderArr[11]; //�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
         drug.OrderType = 0; //ҽ������� 0-����(Ĭ��);1-������;2-��ͣ��;3-��Ժ��ҩ
         drug.DeptCode = PrescMInfo[7].split("-")[1]; //�������ұ���
         drug.DeptName = PrescMInfo[4]; //������������
         drug.DoctorCode = PrescMInfo[6]; //����ҽ������
         drug.DoctorName = PrescMInfo[2]; //����ҽ������
         drug.RecipNo = ""; //������
         drug.Num = OrderArr[15]; //ҩƷ��������
         drug.NumUnit = OrderArr[16]; //ҩƷ����������λ          
         drug.Purpose = 0; //��ҩĿ��(1Ԥ����2���ƣ�3Ԥ��+����, 0Ĭ��)  
         drug.OprCode = ""; //�������,���Ӧ������,��','����,��ʾ��ҩΪ�ñ�Ŷ�Ӧ��������ҩ
         drug.MediTime = ""; //��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
         drug.Remark = ""; //ҽ����ע 
         arrayDrug[arrayDrug.length] = drug;
 
     }
     McDrugsArray = arrayDrug;
     var arrayAllergen = new Array();
     var pai;
     var AllergenInfoArr = AllergenInfo.split(String.fromCharCode(1));
     for (var i = 0; i < AllergenInfoArr.length; i++) {
         var AllergenArr = AllergenInfoArr[i].split("^");
 
         var allergen = new Params_Mc_Allergen_In();
         allergen.Index = i; //���  
         allergen.AllerCode = AllergenArr[0]; //����
         allergen.AllerName = AllergenArr[1]; //����  
         allergen.AllerSymptom = AllergenArr[3]; //����֢״ 
 
         arrayAllergen[arrayAllergen.length] = allergen;
     }
     McAllergenArray = arrayAllergen;
     //����״̬������
     var arrayMedCond = new Array();
     var pmi;
     var MedCondInfoArr = MedCondInfo.split(String.fromCharCode(1));
     for (var i = 0; i < MedCondInfoArr.length; i++) {
         var MedCondArr = MedCondInfoArr[i].split("^");
 
         var medcond;
         medcond = new Params_Mc_MedCond_In();
         medcond.Index = i; //������
         medcond.DiseaseCode = MedCondArr[0]; //��ϱ���
         medcond.DiseaseName = MedCondArr[1]; //�������
         medcond.RecipNo = ""; //������
         arrayMedCond[arrayMedCond.length] = medcond;
 
     }
     var arrayoperation = new Array();
     McOperationArray = arrayoperation;
 }
 
 
 // ����ҩ����ʾ
 function MKPrescTips(orditm){
     if((orditm=="")||(orditm==null)){
           dhcphaMsgBox.alert($g("����ѡ����Ҫ�鿴�ļ�¼"));
         return;
     }
     var ordInfoStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface","GetOrderMainInfo",oeori)
     var ordData = ordInfoStr.split("^")
     var inciCode = ordData[8]
     var inciDesc = ordData[9]
     var prescNo = ordData[10]
     var cyFlag =  ordInfo[11]      //��ҩ��־
     MCInit1(prescNo);
     HisQueryData(inciCode,inciDesc);
     if (cyFlag == "Y"){
         MDC_DoRefDrug(24)  
     }
     else {
         MDC_DoRefDrug(11)
     }
     
 }
 
 function HisQueryData(inciCode,inciDesc) {
     
      var drug = new Params_MC_queryDrug_In();
     drug.ReferenceCode = inciCode;     //ҩƷ���
     drug.CodeName = inciDesc;          //ҩƷ����
     MC_global_queryDrug = drug;
 } 
 
 /***********************������� end  ****************************/

///  ����չʾʱ�����յǼǺŲ�ѯ
function QueryByPatNo(){
    // ��Ϣ����
     $("#txt-patno").val(LoadPatNo);
     InitParams();
     $("#tab-patno").click();
     QueryIPMonitor();
}

///  ����չʾʱ���������ڲ�ѯ
function QueryByDate(){
    // ��Ϣ����
     var stDate=gDateRange.split(",")[0];
     stDate = FormatDateT(stDate);
     var endDate=gDateRange.split(",")[1];
     endDate = FormatDateT(endDate);
     $("#date-start").data('daterangepicker').setStartDate(stDate);
     $("#date-start").data('daterangepicker').setEndDate(endDate);
     QueryIPMonitor();
}