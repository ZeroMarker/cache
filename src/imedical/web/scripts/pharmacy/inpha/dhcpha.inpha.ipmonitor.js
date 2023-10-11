/**
 * 模块:住院药房
 * 子模块:住院药房-医嘱审核
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
 DHCPHA_CONSTANT.VAR.TAB = "#div-ward-condition"; // 记录当前tab
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
     /* 初始化插件 start*/
     var daterangeoptions = {
         singleDatePicker: true
     }
 
     $("#date-start").dhcphaDateRange(daterangeoptions);
     $("#date-end").dhcphaDateRange(daterangeoptions);
     InitPhaLoc(); //药房科室
     InitPhaWard(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID); //病区
     InitPhaLocGrp(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID); //科室组
     InitGridWard();
     InitGridWardPat();
     InitGridAdm();
     InitGridOrdDetail();
     InitIPMonitorTab(); //主页面tab
     InitIPOrderModalTab(); //医嘱审核扩展信息tab
     $("#monitor-condition").children().not("#div-ward-condition").hide();
     /* 初始化插件 end*/
     /* 表单元素事件 start*/
     //登记号回车事件
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
     //屏蔽所有回车事件
     $("input[type=text]").on("keypress", function (e) {
         if (window.event.keyCode == "13") {
             return false;
         }
     })
     /* 表单元素事件 end*/
 
     /* 绑定按钮事件 start*/
     $("#btn-find").on("click", QueryIPMonitor);
     $("#btn-prepresc").on("click", ViewIPOrderAddInfo);
     $("#btn-viewlog").on("click", ViewIPOrderMonitorLog);
     $("#btn-pass").on("click", PassIPOrder);
     $("#btn-refuse").on("click", RefuseIPOrder);
     $("#btn-analysis").on("click", PrescAnalyse) //处方分析
     $("#btn-redir-return").on("click", function () {
         var lnk = ChangeCspPathToAll("dhcpha/dhcpha.inpha.returnbyreq.csp");
         websys_createWindow(lnk, "退药", "width=95%,height=75%");
         //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-35)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=95,left=3,location=no") ;
     });
     $("#btn-autorefresh").on("click", AutoRefreshMonitor)
     /* 绑定按钮事件 end*/
     ;
     InitBodyStyle();
 })
 window.onload = function () {
     if (LoadPatNo != "") {
         setTimeout("QueryByPatNo()",500);
     } else if (gDateRange!="") {
         setTimeout("QueryByDate()",500);
     } else {
         // 菜单进入
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
 //初始病区table
 function InitGridWard() {
     var columns = [{
             header: '病区',
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
         colModel: columns, //列
         url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=GetWardListData&style=jqGrid', //查询后台 
         height: DhcphaJqGridHeight(1, 2) - parseFloat($("#tab-ipmonitor").outerHeight()) - 20, //IPMonitorCanUseHeight()-40-40-5,
         multiselect: false,
         viewrecords: false,
         datatype: 'local',
         pager: "#jqGridPager1", //分页控件的id  
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
 //初始病区病人table
 function InitGridWardPat() {
     var columns = [{
             header: '登记号',
             index: 'patid',
             name: 'patid',
             width: 90
         },
         {
             header: '病区',
             index: 'patloc',
             name: 'patloc',
             width: 160,
             align: 'left'
         },
         {
             header: '床号',
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
         colModel: columns, //列
         url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=GetAdmTreeData&style=jqGrid', //查询后台  
         height: DhcphaJqGridHeight(1, 2) - parseFloat($("#tab-ipmonitor").outerHeight()) - 20,
         multiselect: false,
         viewrecords: false,
         pager: "#jqGridPager2", //分页控件的id
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
 //初始病人就诊table
 function InitGridAdm() {
     var columns = [{
             header: 'adm',
             index: 'adm',
             name: 'adm',
             width: 80,
             hidden: true
         },
         {
             header: '病区',
             index: 'currward',
             name: 'currward',
             width: 140,
             align:'left'
         },
         {
             header: '床号',
             index: 'currbed',
             name: 'currbed',
             width: 100,
             align:'left'
         },
         {
             header: '医生',
             index: 'currdoc',
             name: 'currdoc',
             width: 100,
             align:'left'
         },
         {
             header: '就诊时间',
             index: 'admdate',
             name: 'admdate',
             width: 155
         },
         {
             header: '就诊科室',
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
         colModel: columns, //列
         url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=GetAdmDs&style=jqGrid', //查询后台    
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
 //初始化医嘱明细table
 function InitGridOrdDetail() {
     var columns = [{
             header: '合理用药',
             index: 'druguse',
             name: 'druguse',
             width: 65,
             formatter: druguseFormatter
         },
         {
             header: '注意项目',
             index: 'warningmsg',
             name: 'warningmsg',
             width: 75
         },
         {
             header: '审核结果',
             index: 'result',
             name: 'result',
             width: 75,
             cellattr: addPassStatCellAttr
         },
         {
             header: '登记号',
             index: 'patid',
             name: 'patid',
             width: 100
         },
         {
             header: '姓名',
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
             header: '药品名称',
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
             header: '剂量',
             index: 'dosage',
             name: 'dosage',
             width: 100,
             align: 'left'
         },
         {
             header: '频次',
             index: 'freq',
             name: 'freq',
             width: 100,
             align: 'left'
         },
         {
             header: '规格',
             index: 'spec',
             name: 'spec',
             width: 100,
             hidden: true
         },
         {
             header: '用法',
             index: 'instruc',
             name: 'instruc',
             width: 100,
             align: 'left'
         },
         {
             header: '数量',
             index: 'qty',
             name: 'qty',
             width: 50,
             align: 'right'
         },
         {
             header: '单位',
             index: 'uomdesc',
             name: 'uomdesc',
             width: 60,
             align: 'left'
         },
         {
             header: '剂型',
             index: 'form',
             name: 'form',
             width: 100,
             align: 'left'
         },
         {
             header: '医嘱优先级',
             index: 'ordpri',
             name: 'ordpri',
             width: 80
         },
         {
             header: '基本药物',
             index: 'basflag',
             name: 'basflag',
             width: 70
         },
         {
             header: '医生',
             index: 'doctor',
             name: 'doctor',
             width: 100
         },
         {
             header: '医嘱开单时间',
             index: 'orddate',
             name: 'orddate',
             width: 155
         },
         {
             header: '医嘱备注',
             index: 'remark',
             name: 'remark',
             width: 80
         },
         {
             header: '诊断',
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
             header: '生产企业',
             index: 'manf',
             name: 'manf',
             width: 150,
             align: 'left',
             hidden: true
         },
         {
             header: '单价',
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
             header: '金额',
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
             header: '合理分析结果',
             index: 'druguseresult',
             name: 'druguseresult',
             width: 65,
             hidden: true
         }
     ];
     var jqOptions = {
         colModel: columns, //列
         url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=FindIPOrdDetailDs&style=jqGrid', //查询后台   
         height: DhcphaJqGridHeight(1, 2),
         multiselect: true,
         shrinkToFit: false,
         datatype: 'local',
         pager: "#jqGridPager", //分页控件的id  
         onSelectRow: function (id, status) {
             if (DHCPHA_CONSTANT.VAR.SELECT != "") {
                 return;
             }
             if (id) {
                 var selrowdata = $(this).jqGrid('getRowData', id);
                 PatientInfo.adm = selrowdata.adm;
                 PatientInfo.patientID = selrowdata.papmi;
             }
             DHCPHA_CONSTANT.VAR.SELECT = 1; //此处有待改进,20160829yunhaibao
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
     $("#sel-phaloc").append(select2option); //设默认值,没想到好办法,yunhaibao20160805
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
         placeholder: $g("病区")+"..."
     }
     $("#sel-phaward").dhcphaSelect(selectoption)
 }
 
 function InitPhaLocGrp(locid) {
     var selectoption = {
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
             '?action=GetLocGroupDs&style=select2&locId=' + locid,
         placeholder: $g("科室组")+"..."
     }
     $("#sel-phalocgrp").dhcphaSelect(selectoption)
 }
 //获取条件
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
 //查询
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
 //查询未审核医嘱
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
 
 //医嘱审核扩展信息modal
 function ViewIPOrderAddInfo() {
     var grid_records = $("#grid-orderdetail").getGridParam('records');
     if (grid_records == 0) {
         dhcphaMsgBox.alert($g("当前界面无数据"));
         return;
     }
     var selectid = $("#grid-orderdetail").jqGrid('getGridParam', 'selrow');
     if (selectid == null) {
         dhcphaMsgBox.alert($g("请先选中需要查看的记录"));
         return;
     }
     //$("#modal-prescinfo").find(".modal-dialog").css({height:"200px"});
     $("#modal-prescinfo").modal('show');
 }
 //查看日志
 function ViewIPOrderMonitorLog() {
     var grid_records = $("#grid-orderdetail").getGridParam('records');
     if (grid_records == 0) {
         dhcphaMsgBox.alert($g("当前界面无数据"));
         return;
     }
     var selectid = $("#grid-orderdetail").jqGrid('getGridParam', 'selrow');
     if (selectid == null) {
         dhcphaMsgBox.alert($g("请先选中需要查看的记录"));
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
 //注册modaltab事件
 function InitIPOrderModalTab() {
     $("#ul-monitoraddinfo a").on('click', function () {
         var adm = PatientInfo.adm;
         var prescno = PatientInfo.prescno;
         var zcyflag = PatientInfo.zcyflag;
         var patientID = PatientInfo.patientID;

        /* MaYuqiang 20220517 将患者信息传至头菜单，避免引用界面串患者 */
        var menuWin = websys_getMenuWin();  // 获得头菜单Window对象
        if (menuWin){       
            var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
            if((frm) &&(frm.EpisodeID.value != adm)){
                if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails();  //清除头菜单上所有病人相关信息
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
             // v8.4之前
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
 //审核通过
 function PassIPOrder() {
     var selectids = $("#grid-orderdetail").jqGrid('getGridParam', 'selarrrow');
     if (selectids == "") {
         dhcphaMsgBox.alert($g("请先选中需要审核的记录"));
         return;
     }
     var canpass = 0;
     canpassi = 0;
     var i = 0;
     $.each(selectids, function () {
         var rowdata = $('#grid-orderdetail').jqGrid('getRowData', this);
         var rowresult = rowdata.result;
         canpassi = canpassi + 1;
         if (rowresult == "拒绝(接受)") {
             canpass = "2"
             return false; //false 退出循环
         }
         if (DHCPHA_CONSTANT.DEFAULT.RePassNeedCancel==="Y"){
             if (rowresult==="通过" || rowresult=="拒绝"){
                 canpass = "3"
                 return false; //false 退出循环         
             }
         }
     })
     if (canpass == 2) {
         dhcphaMsgBox.alert("您选择的第" + canpassi + "条已拒绝(接受),不能再次审核通过 !");
         return;
     }
     if (canpass == 3) {
         dhcphaMsgBox.alert("您选择的第" + canpassi + "条已处理,不能直接操作,请先取消!");
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
 //审核拒绝
 function RefuseIPOrder() {
     var grid_records = $("#grid-orderdetail").getGridParam('records');
     if (grid_records == 0) {
         dhcphaMsgBox.alert($g("无明细数据"));
         return;
     }
     var selectid = $("#grid-orderdetail").jqGrid('getGridParam', 'selrow');
     if ((selectid == "") || (selectid == null)) {
         dhcphaMsgBox.alert($g("请先选择需要拒绝的记录"));
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
             dhcphaMsgBox.alert($g("每次只能选择一条记录拒绝"));
             return;
         }
         var iaresult = tmprowdata.result;
         if (iaresult == "拒绝(接受)") {
             canrefuse = 2;
             break;
         }
         var warnmsg=tmprowdata.warningmsg;
         if (warnmsg.indexOf("护士拒绝")>=0){
             canrefuse = 3;
             break;
         }
         if (DHCPHA_CONSTANT.DEFAULT.RePassNeedCancel==="Y"){
             if (iaresult==="通过" || iaresult==="拒绝"){
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
         dhcphaMsgBox.alert($g("您选择的记录已经拒绝(接受)"));
         return;
     }
     if (canrefuse == 3) {
         dhcphaMsgBox.alert($g("您选择的记录已经护士拒绝"));
         return;
     }
     if (canrefuse == 4) {
         dhcphaMsgBox.alert($g("您选择的记录已处理,不能直接操作,请先取消"));
         return;
     }
     var dispedRet = tkMakeServerCall("web.DHCSTCNTSIPMONITOR", "IfOrderDisped", mainoeori);
     if (dispedRet == "Y") {
         dhcphaMsgBox.alert($g("您选择的记录已经发药"));
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
 
 //审核通过/拒绝
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
 //处方分析
 function PrescAnalyse() {
     var passType = DHCPHA_CONSTANT.DEFAULT.PASS;
     if (passType == "") {
         dhcphaMsgBox.alert($g("未设置处方分析接口，请在参数设置-住院药房-合理用药生产企业中添加相应生产企业"));
         return;
     }
     if (passType == "DHC") {
         // 东华知识库
         DHCSTPHCMPASS.PassAnalysis({
             GridId: "grid-orderdetail",
             MOeori: "moeori",
             PrescNo: "",
             GridType: "JqGrid",
             Field: "druguse",
             ResultField: "druguseresult"
         });
     } else if (passType == "MK") {
         dhcphaMsgBox.alert($g("接口尚未开放"));
         // 美康
         //MKPrescAnalyse(); 
     } else if (passType == "YY") {
         dhcphaMsgBox.alert($g("接口尚未开放"));
     }
 }
 
 ///药典提示
 function DrugTips() {
     var passType = DHCPHA_CONSTANT.DEFAULT.PASS;
     if (passType == "") {
         dhcphaMsgBox.alert($g("未设置药典接口，请在参数设置-住院药房-合理用药生产企业中添加相应生产企业"));
         return;
     }
     var $td = $(event.target).closest("td");
     var rowid = $td.closest("tr.jqgrow").attr("id");
     var selectdata = $('#grid-orderdetail').jqGrid('getRowData', rowid);
     var incDesc = $.jgrid.stripHtml(selectdata.incidesc);
     var orditm = selectdata.orditem;
     if (passType == "DHC") {
         // 东华知识库
         var userInfo = session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'];
         DHCSTPHCMPASS.MedicineTips({
             Oeori: orditm,
             UserInfo: userInfo,
             IncDesc: incDesc
         })
     } else if (passType == "MK") {
         //dhcphaMsgBox.alert("接口尚未开放")
         // 美康
         MKPrescTips(orditm); 
     } else if (passType == "YY") {
         dhcphaMsgBox.alert($g("接口尚未开放"))
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
         $("#btn-autorefresh").children("strong").text($g("自动刷新"));
         $("#btn-autorefresh").attr('code','startRefresh')
         clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
     } else {
         $("#btn-autorefresh").css("color", "#40A2DE");
         $("#btn-autorefresh").children("i").css("color", "#40A2DE");
         $("#btn-autorefresh").children("strong").css("color", "#40A2DE");
         $("#btn-autorefresh").children("strong").text($g("停止刷新"));
         $("#btn-autorefresh").attr('code','stopRefresh')
         DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryIPMonitor();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
     }
 }
 //关联医嘱选中
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
     if (val.indexOf("通过")>=0) {
         return "class=dhcpha-record-passed";
     } else if (val.indexOf("拒绝")>=0) {
         return "class=dhcpha-record-refused";
     } else if (val.indexOf("申诉")>=0) {
         return "class=dhcpha-record-appeal";
     } else if (val.indexOf("拒绝(接受)")>=0) {
         return "class=dhcpha-record-reaccept";
     } else {
         return "";
     }
 }
 
 //格式化列
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
 /***********************美康相关 start  ****************************/
 function MKPrescAnalyse() {
     var detailrows = $("#grid-orderdetail").getGridParam('records');
     if (detailrows == 0) {
         dhcphaMsgBox.alert($g("医嘱明细无数据"));
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
     var XHZYRetCode = 0 //处方检查返回代码
 
     MKXHZY1(moeori, flag);
     //若为同步处理,取用McPASS.ScreenHighestSlcode
     //若为异步处理,需调用回调函数处理.
     //同步异步为McConfig.js MC_Is_SyncCheck true-同步;false-异步
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
     ppi.PatCode = PatArr[0]; // 病人编码
     ppi.InHospNo = PatArr[11]
     ppi.VisitCode = PatArr[7] // 住院次数
     ppi.Name = PatArr[1]; // 病人姓名
     ppi.Sex = PatArr[2]; // 性别
     ppi.Birthday = PatArr[3]; // 出生年月
 
     ppi.HeightCM = PatArr[5]; // 身高
     ppi.WeighKG = PatArr[6]; // 体重
     ppi.DeptCode = PatArr[8]; // 住院科室
     ppi.DeptName = PatArr[12]
     ppi.DoctorCode = PatArr[13]; // 医生
     ppi.DoctorName = PatArr[9]
     ppi.PatStatus = 1
     ppi.UseTime = PatArr[4]; // 使用时间
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
         //传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
         drug = new Params_Mc_Drugs_In();
 
         drug.Index = OrderArr[0]; //药品序号
         drug.OrderNo = OrderArr[0]; //医嘱号
         drug.DrugUniqueCode = OrderArr[1]; //药品编码
         drug.DrugName = OrderArr[2]; //药品名称
         drug.DosePerTime = OrderArr[3]; //单次用量
         drug.DoseUnit = OrderArr[4]; //给药单位      
         drug.Frequency = OrderArr[5]; //用药频次
         drug.RouteCode = OrderArr[8]; //给药途径编码
         drug.RouteName = OrderArr[8]; //给药途径名称
         drug.StartTime = OrderArr[6]; //开嘱时间
         drug.EndTime = OrderArr[7]; //停嘱时间
         drug.ExecuteTime = ""; //执行时间
         drug.GroupTag = OrderArr[10]; //成组标记
         drug.IsTempDrug = OrderArr[11]; //是否临时用药 0-长期 1-临时
         drug.OrderType = 0; //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
         drug.DeptCode = PrescMInfo[7].split("-")[1]; //开嘱科室编码
         drug.DeptName = PrescMInfo[4]; //开嘱科室名称
         drug.DoctorCode = PrescMInfo[6]; //开嘱医生编码
         drug.DoctorName = PrescMInfo[2]; //开嘱医生姓名
         drug.RecipNo = ""; //处方号
         drug.Num = OrderArr[15]; //药品开出数量
         drug.NumUnit = OrderArr[16]; //药品开出数量单位          
         drug.Purpose = 0; //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
         drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
         drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
         drug.Remark = ""; //医嘱备注 
         arrayDrug[arrayDrug.length] = drug;
 
     }
     McDrugsArray = arrayDrug;
     var arrayAllergen = new Array();
     var pai;
     var AllergenInfoArr = AllergenInfo.split(String.fromCharCode(1));
     for (var i = 0; i < AllergenInfoArr.length; i++) {
         var AllergenArr = AllergenInfoArr[i].split("^");
 
         var allergen = new Params_Mc_Allergen_In();
         allergen.Index = i; //序号  
         allergen.AllerCode = AllergenArr[0]; //编码
         allergen.AllerName = AllergenArr[1]; //名称  
         allergen.AllerSymptom = AllergenArr[3]; //过敏症状 
 
         arrayAllergen[arrayAllergen.length] = allergen;
     }
     McAllergenArray = arrayAllergen;
     //病生状态类数组
     var arrayMedCond = new Array();
     var pmi;
     var MedCondInfoArr = MedCondInfo.split(String.fromCharCode(1));
     for (var i = 0; i < MedCondInfoArr.length; i++) {
         var MedCondArr = MedCondInfoArr[i].split("^");
 
         var medcond;
         medcond = new Params_Mc_MedCond_In();
         medcond.Index = i; //诊断序号
         medcond.DiseaseCode = MedCondArr[0]; //诊断编码
         medcond.DiseaseName = MedCondArr[1]; //诊断名称
         medcond.RecipNo = ""; //处方号
         arrayMedCond[arrayMedCond.length] = medcond;
 
     }
     var arrayoperation = new Array();
     McOperationArray = arrayoperation;
 }
 
 
 // 美康药典提示
 function MKPrescTips(orditm){
     if((orditm=="")||(orditm==null)){
           dhcphaMsgBox.alert($g("请先选择需要查看的记录"));
         return;
     }
     var ordInfoStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface","GetOrderMainInfo",oeori)
     var ordData = ordInfoStr.split("^")
     var inciCode = ordData[8]
     var inciDesc = ordData[9]
     var prescNo = ordData[10]
     var cyFlag =  ordInfo[11]      //草药标志
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
     drug.ReferenceCode = inciCode;     //药品编号
     drug.CodeName = inciDesc;          //药品名称
     MC_global_queryDrug = drug;
 } 
 
 /***********************美康相关 end  ****************************/

///  链接展示时，按照登记号查询
function QueryByPatNo(){
    // 消息进入
     $("#txt-patno").val(LoadPatNo);
     InitParams();
     $("#tab-patno").click();
     QueryIPMonitor();
}

///  链接展示时，按照日期查询
function QueryByDate(){
    // 消息进入
     var stDate=gDateRange.split(",")[0];
     stDate = FormatDateT(stDate);
     var endDate=gDateRange.split(",")[1];
     endDate = FormatDateT(endDate);
     $("#date-start").data('daterangepicker').setStartDate(stDate);
     $("#date-start").data('daterangepicker').setEndDate(endDate);
     QueryIPMonitor();
}