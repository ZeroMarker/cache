/*
 *模块:住院药房
 *子模块:住院药房-申请单退药
 *createdate:2016-08-30
 *creator:yunhaibao
 */
 DHCPHA_CONSTANT.VAR.RequestStatus = 'P';
 DHCPHA_CONSTANT.VAR.requestIDStr = '';
 $(function () {
     /* 初始化插件 start*/
     var daterangeoptions = {
         singleDatePicker: true
     };
     $('#date-start').dhcphaDateRange(daterangeoptions);
     $('#date-end').dhcphaDateRange(daterangeoptions);
     SetDefaultDate();
     InitPhaLoc(); //药房科室
     InitPhaWard(); //病区
     InitSelType(); // 查询类型
     InitGridReq();
     InitGridReqDetail();
     InitGridReqTotal();
     /* 初始化插件 end*/
     /* 表单元素事件 start*/
     //登记号回车事件
     $('#txt-val').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var selType = $('#sel-type').val();
            var selVal = $('#txt-val').val();
            /* 登记号回车 */
            if (selType == "1"){
                var patno = $.trim(selVal);
                if (patno != '') {
                    var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                    $(this).val(newpatno);
                    var patoptions = {
                        id: '#dhcpha-patinfo',
                        gettype: 'patno',
                        input: newpatno
                    };
                    AppendPatientBasicInfo(patoptions);
                }
            } else if(selType == "3"){  /* 床号回车 */
                var phaward = $('#sel-phaward').val() || '';
                if ((phaward == "")&&(selVal !== "")){
                    dhcphaMsgBox.alert($g("请先选择病区信息再按照床号查询"));
                }
                var newpatno = selVal
                var patoptions = {
                    id: '#dhcpha-patinfo',
                    gettype: 'patno',
                    input: ''
                };
                AppendPatientBasicInfo(patoptions);
            } else if(selType == "2"){    /* 姓名回车 */
            var patoptions = {
                id: '#dhcpha-patinfo',
                gettype: 'patno',
                input: ''
            };
            AppendPatientBasicInfo(patoptions);
            };
        }
    });
     
    $("#sel-type").change(function(){
        $('#txt-val').val('');
    });

     //屏蔽所有回车事件
     $('input[type=text]').on('keypress', function (e) {
         if (window.event.keyCode == '13') {
             return false;
         }
     });
     /* 表单元素事件 end*/
 
     /* 绑定按钮事件 start*/
     $('#chk-specloc').on('ifChanged', InitPhaWard);
     $('#btn-find').on('click', QueryRequest);
     $('#btn-return').on('click', function(){
         CACert('PHAIPReturn',DoReturn)     
     });
     $('#btn-refuse').on('click', DoRefuse);
     $('#btn-cancelrefuse').on('click', DoCancelRefuse);
     $('#btn-clear').on('click', ClearCondition);
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
     
     /* 绑定按钮事件 end*/
     $('#grid-reqdetail').setGridWidth('');
     ResizeReturnByReq();
     InitRefuseReasonModal();
     if ((LoadStartDate !== "")&&(LoadEndDate !== "")&&(LoadStartDate !== "undefined")&&(LoadEndDate !== "undefined")){
        QueryRequest();
    }
 });
 
 //初始申请单table
 function InitGridReq() {
     var columns = [
         {
             header: '申请单号',
             index: 'TReqNo',
             name: 'TReqNo',
             width: 230
         },
         {
             header: '申请日期',
             index: 'TReqDate',
             name: 'TReqDate',
             width: 90
         },
         {
             header: '病区/特殊科室',
             index: 'TWard',
             name: 'TWard',
             width: 100
         },
         {
             header: '申请人',
             index: 'TReqOper',
             name: 'TReqOper',
             width: 90
         },
         {
            header: '床号',
            index: 'TBedNo',
            name: 'TBedNo',
            width: 50
        }
     ];
     var jqOptions = {
         datatype: 'local',
         colModel: columns, //列
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryReqListForReturn&style=jqGrid', //查询后台
         height: DhcphaJqGridHeight(1, 2) - 10,
         multiselect: true,
         pager: '#jqGridPager1', //分页控件的id
         emptyrecords: '',
         recordtext: '',
         onSelectRow: function (id, status) {
             var chkRowRet = CheckReqRowData(id);
             if (chkRowRet == false) {
                 $('#grid-reqlist').jqGrid('setSelection', id, false);
                 return;
             }
             QueryReqDetail();
         },
         onSelectAll: function (aRowids, status) {
            var $grid = $('#grid-reqlist');
            var wardArr=[]
            var selArr = $grid.jqGrid('getGridParam', 'selarrrow');
            for (var i = 1 , len = selArr.length; i <= len;i++){
                var row = $grid.jqGrid('getRowData', i);
                var wardDesc = row.TWard;
                if(wardArr.indexOf(wardDesc) < 0){
                    wardArr.push(wardDesc)
                }
                
            }
            
            var wardLen = wardArr.length;
            if (wardLen>1){
                dhcphaMsgBox.alert('您选择了 '+wardLen+' 个病区/特殊科室的记录'+'</br>'+wardArr.join('</br>'));
            }    
            QueryReqDetail();
         }
     };
     $('#grid-reqlist').dhcphaJqGrid(jqOptions);
 }

 
 //初始药品明细table
 function InitGridReqDetail() {
     var columns = [
         {
             name: 'TRegNo',
             index: 'TRegNo',
             header: '登记号',
             width: 100
         },
         {
             name: 'TBedNo',
             index: 'TBedNo',
             header: '床号',
             width: 80
         },
         {
             name: 'TName',
             index: 'TName',
             header: '姓名',
             width: 80
         },
         {
             name: 'TDesc',
             header: '名称',
             width: 250,
             align: 'left'
         },
         {
             name: 'TUom',
             index: 'TDesc',
             header: '单位',
             width: 75
         },
         {
             name: 'TRetQty',
             header: '退药数量',
             width: 80,
             align: 'right',
             editable: true,
             cellattr: addTextCellAttr
         },
         {
             name: 'TQty',
             header: '申请数量',
             width: 80
         },
         {
             name: 'TReturnqty',
             index: 'TQty',
             header: '已退数量',
             width: 80
         },
         {
             name: 'TSurqty',
             index: 'TSurqty',
             header: '未退数量',
             width: 80
         },
         {
             name: 'TReqDate',
             index: 'TReqDate',
             header: '申请日期',
             width: 90
         },
         {
             name: 'TReqTime',
             index: 'TReqTime',
             header: '申请时间',
             width: 75
         },
         {
             name: 'TStatus',
             index: 'TStatus',
             header: '状态',
             width: 80,
             formatter: function (cellvalue, options, rowObject) {
                 var status = rowObject.TReqStatus;
                 var refundStatus = rowObject.TRefundStatus;
                 var statusDiv = "<div style='background:white;color:black;padding-left:8px;border-bottom:1px dashed #cccccc;'>" + status + '</div>';
                 if (status == '退药完成') {
                     statusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                 } else if (status == '部分退药') {
                     statusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                 }
                 var refundStatusDiv = "<div style='background:white;color:black;padding-left:8px;'>" + refundStatus + '</div>';
                 if (refundStatus == '退费完成') {
                     refundStatusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;">' + refundStatus + '</div>';
                 } else if (refundStatus == '部分退费') {
                     refundStatusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;">' + refundStatus + '</div>';
                 }
                 return '<div style="margin:0px -8px;font-weight:bold;">' + statusDiv + refundStatusDiv + '</div>';
             }
         },
         {
             name: 'TReqStatus',
             index: 'TReqStatus',
             header: '退药状态',
             width: 80,
             hidden: true
         },
         {
             name: 'TRefundStatus',
             index: 'TRefundStatus',
             header: '退费状态',
             width: 80,
             hidden: true
         },
         {
             name: 'TRetReason',
             index: 'TRetReason',
             header: '退药原因',
             width: 80
         },
         {
             name: 'TPrescNo',
             index: 'TPrescNo',
             header: '处方号',
             width: 130
         },
         {
             name: 'TRefuseData',
             index: 'TRefuseData',
             header: '拒绝退药信息',
             width: 200,
             align: 'left'
         },
 
         {
             name: 'TOECPRCode',
             index: 'TOECPRCode',
             header: '医嘱优先级代码',
             width: 90,
             hidden: true
         },
         {
             name: 'TEncryptLevel',
             index: 'TEncryptLevel',
             header: '病人密级',
             width: 80,
             hidden: true
         },
         {
             name: 'TPatLevel',
             index: 'TPatLevel',
             header: '病人级别',
             width: 80,
             hidden: true
         },
         {
             name: 'Tpid',
             index: 'Tpid',
             header: 'Tpid',
             width: 60,
             hidden: true
         },
         {
             name: 'Tretrqrowid',
             index: 'Tretrqrowid',
             header: 'Tretrqrowid',
             width: 60,
             hidden: true
         },
         {
             name: 'TDEPTDR',
             index: 'TDEPTDR',
             header: 'TDEPTDR',
             width: 60,
             hidden: true
         },
         {
             name: 'TDodis',
             index: 'TDodis',
             header: 'TDodis',
             width: 60,
             hidden: true
         },
         {
             name: 'TBEDDR',
             index: 'TBEDDR',
             header: 'TBEDDR',
             width: 60,
             hidden: true
         },
         {
             name: 'TADMDR',
             index: 'TADMDR',
             header: 'TADMDR',
             width: 60,
             hidden: true
         },
         {
             name: 'TADMLOCDR',
             index: 'TADMLOCDR',
             header: 'TADMLOCDR',
             width: 60,
             hidden: true
         },
         {
             name: 'TRECLOCDR',
             index: 'TRECLOCDR',
             header: 'TRECLOCDR',
             width: 60,
             hidden: true
         },
         {
             name: 'TRetPartFlag',
             index: 'TRetPartFlag',
             header: 'TRetPartFlag',
             width: 60,
             hidden: true
         },
         {
             name: 'TCode',
             index: 'TCode',
             header: 'TCode',
             width: 60,
             hidden: true
         },
         {
             name: 'TCyFlag',
             index: 'TCyFlag',
             header: '草药处方标志',
             width: 60,
             hidden: true
         },
         {
             name: 'TPivas',
             index: 'TPivas',
             header: '配液标志',
             width: 60,
             hidden: true
         },
         {
             name: 'TMDodis',
             index: 'TMDodis',
             header: '主打包Id',
             width: 60,
             hidden: true
         }
     ];
     var jqOptions = {
         datatype: 'local',
         colModel: columns, //列
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryReqDetail&style=jqGrid', //查询后台
         height: DhcphaJqGridHeight(2, 2) * 0.5,
         multiselect: true,
         shrinkToFit: false,
         rowNum: 9999,
         loadComplete: function () {
             var grid_records = $(this).getGridParam('records');
             if (grid_records == 0) {
                 //QueryRequest();
                 $('#grid-reqtotal').clearJqGrid();
             } else {
                 var ids = $('#grid-reqdetail').getDataIDs();
                 for (var k = 0; k < ids.length; k++) {
                     var curRowData = $('#grid-reqdetail').jqGrid('getRowData', ids[k]);
                     if (curRowData.TCyFlag == 'Y') {
                         $(this).jqGrid('setSelection', k + 1);
                     }
                 }
                 QueryReqTotal();
             }
             LastEditSel = '';
         },
         onSelectRow: function (id, status) {
             var iddata = $('#grid-reqdetail').jqGrid('getRowData', id);
             var prescyflag = iddata.TCyFlag;
             var pivasFlag = iddata.TPivas;
             if (prescyflag == 'Y') {
                 var prescNo = iddata.TPrescNo;
                 var rowIds = $('#grid-reqdetail').jqGrid('getDataIDs');
                 for (var k = 0; k < rowIds.length; k++) {
                     var curRowData = $('#grid-reqdetail').jqGrid('getRowData', rowIds[k]);
                     var tmpPrescNo = curRowData['TPrescNo'];
                     var curChk = $('#' + rowIds[k] + '').find(':checkbox');
                     if (prescNo == tmpPrescNo && id != k + 1) {
                         $('#grid-reqdetail').jqGrid('setSelection', k + 1, false);
                     }
                 }
                 return;
             }
             if (pivasFlag == 'Y') {
                 var mDodis = iddata.TMDodis;
                 var rowIds = $('#grid-reqdetail').jqGrid('getDataIDs');
                 for (var k = 0; k < rowIds.length; k++) {
                     var curRowData = $('#grid-reqdetail').jqGrid('getRowData', rowIds[k]);
                     var tmpMDodis = curRowData['TMDodis'];
                     var curChk = $('#' + rowIds[k] + '').find(':checkbox');
                     if (mDodis == tmpMDodis && id != k + 1) {
                         $('#grid-reqdetail').jqGrid('setSelection', k + 1, false);
                     }
                 }
                 return;
             }
             if (JqGridCanEdit == false && LastEditSel != '' && LastEditSel != id) {
                 $('#grid-reqdetail').jqGrid('setSelection', LastEditSel);
                 return;
             }
             if (LastEditSel != '' && LastEditSel != id) {
                 $(this).jqGrid('saveRow', LastEditSel);
             }
             $(this).jqGrid('editRow', id, {
                 oneditfunc: function () {
                     $editinput = $(event.target).find('input');
                     $editinput.focus();
                     $editinput.select();
                     $editinput.unbind().on('keyup', function (e) {
                         $editinput.val(ParseToNum($editinput.val()));
                     });
                     $('#' + id + '_TRetQty').on('focusout || mouseout', function () {
                         var iddata = $('#grid-reqdetail').jqGrid('getRowData', id);
                         var retpartflag = iddata.TRetPartFlag;
                         var reqstatus = iddata.TReqStatus;
                         var refundstatus = iddata.TRefundStatus;
                         var surqty = iddata.TSurqty;
                         if (retpartflag == '0') {
                             dhcphaMsgBox.message('第' + id + '行存在附加医嘱项目,不允许修改退药数量!');
                             $('#grid-reqdetail').jqGrid('restoreRow', id);
                             JqGridCanEdit = true; // restore 后,应为允许表格编辑状态
                             return false;
                         }
                         if (parseFloat(this.value * 1000) > parseFloat(surqty * 1000)) {
                             dhcphaMsgBox.message('第' + id + '行退药数量大于未退数量!');
                             $('#grid-reqdetail').jqGrid('restoreRow', id);
                             JqGridCanEdit = true;
                             return false;
                         }
                         if (this.value.toString().indexOf('.') >= 0) {
                             // 有小数的处理,申请数有小数才能写小数
                             if (surqty.toString().indexOf('.') < 0) {
                                 dhcphaMsgBox.message('第' + id + '行退药数量不能为小数!');
                                 $('#grid-reqdetail').jqGrid('restoreRow', id);
                                 JqGridCanEdit = true;
                                 return false;
                             }
                         }
                         /*
                          if (reqstatus=="部分退药"&&refundstatus=="退费完成"){
                              dhcphaMsgBox.message("第"+id+"行已经提前退费,不允许修改退药数量!")
                              $("#grid-reqdetail").jqGrid('restoreRow',id);
                              JqGridCanEdit=false
                              return false;
                          }
                          */
                         //$("#grid-reqdetail").jqGrid('saveRow', id);
                         JqGridCanEdit = true;
                         return true;
                     });
                 }
             });
             LastEditSel = id;
         }
     };
     $('#grid-reqdetail').dhcphaJqGrid(jqOptions);
     PhaGridFocusOut('grid-reqdetail');
 }
 //初始单品汇总table
 function InitGridReqTotal() {
     var columns = [
         {
             name: 'Tdesc',
             index: 'Tdesc',
             header: '药品名称',
             width: 250,
             align: 'left'
         },
         {
             name: 'Tuom',
             index: 'Tuom',
             header: '单位',
             width: 75
         },
         {
             name: 'Treqqty',
             index: 'Treqqty',
             header: '申请数量',
             width: 80
         },
         {
             name: 'Treturnedqty',
             index: 'Treturnedqty',
             header: '已退数量',
             width: 80
         },
         {
             name: 'TSurqty',
             index: 'TSurqty',
             header: '未退数量',
             width: 80
         },
         {
             name: 'Tform',
             index: 'Tform',
             header: '剂型',
             width: 100
         },
         {
             name: 'Tmanf',
             index: 'Tmanf',
             header: '生产企业',
             width: 150
         },
         {
             name: 'Tprice',
             index: 'Tprice',
             header: '单价',
             width: 100,
             align: 'right'
         },
         {
             name: 'Tamount',
             index: 'Tamount',
             header: '金额',
             width: 100,
             align: 'right'
         }
     ];
     var jqOptions = {
         datatype: 'local',
         rowNum: 9999,
         colModel: columns, //列
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryReqTotal&style=jqGrid', //查询后台
         height: DhcphaJqGridHeight(2, 2) * 0.5 - 3,
         multiselect: false
     };
     $('#grid-reqtotal').dhcphaJqGrid(jqOptions);
 }
 
 function InitPhaLoc() {
     var selectoption = {
         allowClear: false,
         url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetStockPhlocDs&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
         placeholder: '退药科室...'
        };
     $('#sel-phaloc').dhcphaSelect(selectoption);
     var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
     $('#sel-phaloc').append(select2option);
     $('#sel-phaloc').on('select2:select', function (event) {
         InitPhaWard();
     });
 }
 
 function InitPhaWard() {
     if ($('#chk-specloc').is(':checked')) {
         var selectloc = $('#sel-phaloc').val();
         var params = selectloc + '^' + '1';
         var selectoption = {
             url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetWardListByDocFlag&style=select2&params=' + params,
             placeholder: $g('特殊科室')+'...' 
         };
     } else {
         var selectoption = {
             url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetWardListByDocFlag&style=select2',
             placeholder: $g('病区')+'...' 
         };
     }
     $('#sel-phaward').val('');
     $('#sel-phaward').dhcphaSelect(selectoption);
 }

 /* 定义查询类型 */
 function InitSelType(){
    var data = [
        { id: "1", text: $g("登记号") },
        { id: "2", text: $g("姓名") },
        { id: "3", text: $g("床号") }
    ];
    var selectoption = {
        data:data,
        width:90,
        allowClear: false,
        minimumResultsForSearch: Infinity,
        placeholder: $g('查询类型')+'...' 
    };
    $('#txt-val').val('');
    $('#sel-type').dhcphaSelect(selectoption);  
 }
 //查询申请单列表
 function QueryRequest() {
     var params = GetRequestParams();
     $('#grid-reqlist')
         .setGridParam({
             datatype: 'json',
             postData: {
                 params: params
             }
         })
         .trigger('reloadGrid');
     $('#grid-reqdetail').clearJqGrid();
     $('#grid-reqtotal').clearJqGrid();
 }
 
 //获取条件
 function GetRequestParams() {
     var phaloc = $('#sel-phaloc').val() || '';
     var phaward = $('#sel-phaward').val() || '';
     var daterange = $('#date-start').val() + '^' + $('#date-end').val();
     var speclocflag = $('#chk-specloc').is(':checked') ? 1 : '';
     //var patno = $('#txt-patno').val();
     var patno = "",patName = "",bedNo = "";
     var selType = $('#sel-type').val();
     var selval = $('#txt-val').val();
     if (selType == "1"){
         var patno = selval;
     }
     else if (selType == "3"){
         if ((phaward == "")&&(selval !== "")){
            dhcphaMsgBox.alert($g("请先选择病区信息再按照床号查询"));
            return false; 
         }
         var bedNo = selval;
         var patoptions = {
            id: '#dhcpha-patinfo',
            gettype: 'patno',
            input: ''
         };
         AppendPatientBasicInfo(patoptions);
     }
     else if (selType == "2"){
         var patName = selval;
         var patoptions = {
            id: '#dhcpha-patinfo',
            gettype: 'patno',
            input: ''
         };
         AppendPatientBasicInfo(patoptions);
     }
     var advrefundflag = $('#chk-advrefund').is(':checked') ? 'Y' : '';
     var refuseFlag = $('#chk-refuse').is(':checked') ? 'Y' : 'N';
     var otherStr = patName + "," + bedNo;
     var paramsArr = [daterange, phaloc, phaward, patno, speclocflag, DHCPHA_CONSTANT.VAR.RequestStatus, advrefundflag, refuseFlag, otherStr];
     return paramsArr.join('^');
 }
 //查询申请单药品明细
 function QueryReqDetail() {
     var params = '';
     var selectids = $('#grid-reqlist').jqGrid('getGridParam', 'selarrrow');
     $.each(selectids, function () {
         var rowdata = $('#grid-reqlist').jqGrid('getRowData', this);
         var reqno = rowdata.TReqNo;
         if (params == '') {
             params = reqno;
         } else {
             params = params + '^' + reqno;
         }
     });
     var reqStatus = $('#chk-refuse').is(':checked') ? 'Refuse' : 'Prove';
     $('#grid-reqdetail')
         .setGridParam({
             datatype: 'json',
             postData: {
                 params: params + '|@|' + reqStatus
             }
         })
         .trigger('reloadGrid');
     JqGridCanEdit = true;
 }
 //查询申请单单品汇总
 function QueryReqTotal() {
     var firstrowdata = $('#grid-reqdetail').jqGrid('getRowData', 1); //获取第一行数据
     var params = firstrowdata.Tpid;
     $('#grid-reqtotal')
         .setGridParam({
             datatype: 'json',
             postData: {
                 params: params
             }
         })
         .trigger('reloadGrid');
 }
 //执行退药
 function DoReturn() {
     if (DhcphaGridIsEmpty('#grid-reqdetail') == true) {
         return;
     }
     var selectids = $('#grid-reqdetail').jqGrid('getGridParam', 'selarrrow');
     if (selectids == '' || selectids == null) {
         dhcphaMsgBox.alert($g('请先选中需要退药的记录'));
         return;
     }
     dhcphaMsgBox.confirm($g('是否确认【退药】?'), ConfirmReturn);
 }
 
 function ConfirmReturn(result) {
     if (result == true) {
         ExecuteReturn();
     } else {
         return;
     }
 }
 
 function ExecuteReturn() {
     var selectids = $('#grid-reqdetail').jqGrid('getGridParam', 'selarrrow');
     var canpass = 0;
     (canpassi = 0), (returnstr = '');
     $.each(selectids, function () {
         var rowdata = $('#grid-reqdetail').jqGrid('getRowData', this);
         if (CheckOneRowData(this) == false) {
             canpass = 1;
             return false;
         }
         var retqty = $.trim(rowdata['TRetQty']);
         var surqty = $.trim(rowdata['TSurQty']);
         var reqitmrowid = $.trim(rowdata['Tretrqrowid']); //申请子表id
         if (retqty == '') {
             dhcphaMsgBox.alert('第' + this + '行数量不允许为空!');
             canpass = 1;
             return false;
         }
         if (retqty == 0) {
             dhcphaMsgBox.alert('第' + this + '行数量不允许为0!');
             canpass = 1;
             return false;
         }
         var tmpreturndata = reqitmrowid + '^' + retqty;
         if (returnstr == '') {
             returnstr = tmpreturndata;
         } else {
             returnstr = returnstr + ',' + tmpreturndata;
         }
     });
     if (canpass != 0) {
         return;
     }
     if (returnstr == '') {
         dhcphaMsgBox.alert($g('请勾选需要退药的数据'));
         return;
     }
     var firstrowdata = $('#grid-reqdetail').jqGrid('getRowData', 1);
     var reclocdr = firstrowdata['TRECLOCDR'];
     if (reclocdr == '') {
         dhcphaMsgBox.alert($g('医嘱接收科室为空'));
         return;
     }
     var executeret = tkMakeServerCall('web.DHCSTPHARETURN', 'ExecReturnByReq', '', '', reclocdr, DHCPHA_CONSTANT.SESSION.GUSER_ROWID, '', returnstr);
     var retarr = executeret.split(',');
     var retID = '';
     if (retarr[0] == 'failure') {
         if (retarr[1] == -3) {
             dhcphaMsgBox.alert($g('不允许退药:退药数量超过发药数量,或未发药'));
         } else if (retarr[1] == -2) {
             dhcphaMsgBox.alert($g('存在申请记录已经退药或拒绝退药!'));
         } else if (retarr[1] == -4) {
             dhcphaMsgBox.alert($g('患者已最终结算,不允许退药,请联系结算处'));
         } else if (retarr[1] == -5) {
             dhcphaMsgBox.alert($g('保存退药明细失败,错误代码:') + retarr[1], 'error');
         } else if (retarr[1] == -6) {
             dhcphaMsgBox.alert($g('更新申请单状态失败,错误代码:') + retarr[1], 'error');
         } else if (retarr[1] == -7) {
             dhcphaMsgBox.alert($g('审核退药单失败,错误代码:') + retarr[1]);
         } else if (retarr[1] == -10) {
             dhcphaMsgBox.alert($g('有附加收费项目执行记录不允许部分退药'));
         } else if (retarr[1] == -11) {
             dhcphaMsgBox.alert($g('不允许退药:已经中途结算,不能退药!'));
         } else if (retarr[1] == -100) {
             dhcphaMsgBox.alert($g('您选择的退药申请已被删除，无法退药'));
         } else if (retarr[1] != 0) {
             dhcphaMsgBox.alert($g('退药失败,错误代码:') + retarr[1], 'info');
         }
         return;
     } else {
         retID = retarr[1];
         QueryReqDetail();
         DHCPHA_CONSTANT.VAR.requestIDStr = retID;
         dhcphaMsgBox.confirm($g('退药成功!是否【打印】?'), ConfirmReturnPrint);
     }
 }
 
 function ConfirmReturnPrint(result) {
     if (result == true) {
         var paramsStr="^"+session['LOGON.CTLOCID']+"^^"+session['LOGON.HOSPID']
         var selPrintTypeFlag=tkMakeServerCall("web.DHCST.Common.AppCommon","GetAppPropValue","DHCSTPHARETURN","SelPrintTypeAfter",paramsStr)
         if (selPrintTypeFlag=="Y") {
             $('#modal-returnprinttype').modal('show');
         }else {
            PrintReturnCom(DHCPHA_CONSTANT.VAR.requestIDStr, '');
            DHCPHA_CONSTANT.VAR.requestIDStr = '';
         }
     }
     //DHCPHA_CONSTANT.VAR.requestIDStr = '';
 }
 //验证单行数据合法
 function CheckOneRowData(rowid) {
     var selecteddata = $('#grid-reqdetail').jqGrid('getRowData', rowid);
     var retpartflag = selecteddata['TRetPartFlag'];
     var retqty = selecteddata['TRetQty'];
     var surqty = selecteddata['TSurqty'];
     var incicode = selecteddata['TCode'];
     var diffqty = parseFloat(retqty) - parseFloat(surqty);
     if (retpartflag == '0') {
         dhcphaMsgBox.alert('第' + rowid + '行记录有附加收费项目，不允许修改退药数量!');
         return false;
     } else if (retqty < 0) {
         dhcphaMsgBox.alert('第' + rowid + '行退药数量不允许为负数!');
         return false;
     } else if (parseFloat(diffqty) > 0) {
         dhcphaMsgBox.alert('第' + rowid + '行退药数量不能大于未退数量!');
         return false;
     } else if (isNaN(retqty)) {
         dhcphaMsgBox.alert('第' + rowid + '行退药数量应为正数!');
         return false;
     }
     var refrefuseflag = tkMakeServerCall('web.DHCST.ARCALIAS', 'GetRefReasonByCode', incicode);
     if (refrefuseflag != '') {
         if (refrefuseflag.split('^')[3] != '') {
             dhcphaMsgBox.alert('第' + rowid + '行药品' + refrefuseflag.split('^')[1] + ',在药品基础数据中目前为不可退药状态,不能申请!</br>不可退药原因:' + refrefuseflag.split('^')[3]);
             return false;
         }
     }
     return true;
 }
 
 //验证主记录是否合法
 function CheckReqRowData(rowId) {
     var selectIds = $('#grid-reqlist').jqGrid('getGridParam', 'selarrrow');
     if (selectIds != '') {
         var idData = $('#grid-reqlist').jqGrid('getRowData', rowId);
         var idWard = idData.TWard;
         for (var i = 0; i < selectIds.length; i++) {
             var selectId = selectIds[i];
             var rowData = $('#grid-reqlist').jqGrid('getRowData', selectId);
             var rowWard = rowData.TWard;
             if (idWard != rowWard) {
                 dhcphaMsgBox.alert($g('请选择相同病区进行退药!'), 'warning');
                 return false;
             }
         }
     }
     return true;
 }
 
 function ClearCondition() {
     InitPhaLoc(); 
     $('#sel-type').select2('val','1');

     $('#txt-val').val('');
     if ($('#patInfo')) {
         $('#patInfo').remove();
     }
     $('#sel-phaward').empty();
     $('#chk-specloc').iCheck('uncheck');
     $('#chk-advrefund').iCheck('uncheck');
     $('#chk-refuse').iCheck('uncheck');
     /*
     $('#date-start').data('daterangepicker').setStartDate(new Date());
     $('#date-start').data('daterangepicker').setEndDate(new Date());
     $('#date-end').data('daterangepicker').setStartDate(new Date());
     $('#date-end').data('daterangepicker').setEndDate(new Date());
     */
     SetDefaultDate();
     $('#grid-reqlist').clearJqGrid();
     $('#grid-reqdetail').clearJqGrid();
     $('#grid-reqtotal').clearJqGrid();
     JqGridCanEdit = true;
 }
 
 function PhaGridFocusOut(gridid) {
     $('#' + gridid).on('mouseleave', function (e) {
         if (e.relatedTarget) {
             var $related = $('#' + gridid).find(e.relatedTarget);
             if ($related.length <= 0 && LastEditSel != '') {
                 $('#' + gridid).jqGrid('saveRow', LastEditSel);
             }
         }
     });
 }
 
 window.onresize = ResizeReturnByReq;
 function ResizeReturnByReq() {
     var wardtitleheight = $('#gview_grid-reqlist .ui-jqgrid-hbox').height();
     var wardheight = DhcphaJqGridHeight(1, 1) - wardtitleheight; //+32
     var reqdetailheight = DhcphaJqGridHeight(2, 2) / 2; //+ 17
     $('#grid-reqlist').setGridHeight(wardheight).setGridWidth('');
     $('#grid-reqdetail').setGridHeight(reqdetailheight).setGridWidth('');
     $('#grid-reqtotal').setGridHeight(reqdetailheight).setGridWidth('');
 }
 
 /** ============================================= */
 /** 拒绝退药 */
 function DoRefuse() {
     if (DhcphaGridIsEmpty('#grid-reqdetail') == true) {
         return;
     }
     var selectids = $('#grid-reqdetail').jqGrid('getGridParam', 'selarrrow');
     if (selectids == '' || selectids == null) {
         dhcphaMsgBox.alert($g('请先选中需要拒绝退药的记录'));
         return;
     }
     dhcphaMsgBox.confirm($g('是否确认【拒绝退药】?'), function (result) {
         if (result === true) {
             $('#modal-inpharefusereason').modal('show');
         }
     });
 }
 function InitRefuseReasonModal() {
     $('#modal-inpharefusereason').on('show.bs.modal', function () {
         var option = {
             url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=GetRetRefuseReason&style=select2' + '&HospId=' + DHCPHA_CONSTANT.SESSION.GHOSP_ROWID,
             minimumResultsForSearch: Infinity,
             width: 400,
             allowClear: false
         };
         $('#sel-refusereason').dhcphaSelect(option);
         $('#sel-refusereason').empty();
     });
     $('#btn-refusereason-sure').on('click', function () {
         var refusereason = $('#sel-refusereason').val();
         if (refusereason == '' || refusereason == null) {
             dhcphaMsgBox.alert($g('请选择拒绝退药的原因!'));
             return;
         }
         $('#modal-inpharefusereason').modal('hide');
         ExecuteRefuse(refusereason);
     });
 }
 function ExecuteRefuse(reason) {
     var selIDs = $('#grid-reqdetail').jqGrid('getGridParam', 'selarrrow');
     var reqiArr = [];
     for (var i = 1, len = selIDs.length; i <= len; i++) {
         var row = $('#grid-reqdetail').jqGrid('getRowData', i);
         var reqi = row.Tretrqrowid;
         reqiArr.push(reqi + '^' + reason + '^' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
     }
     var ret = tkMakeServerCall('web.DHCSTPHARETURN', 'RefuseRequest', reqiArr.join(','));
     var retArr = ret.split('^');
     if (retArr[0] < 0) {
         dhcphaMsgBox.alert(retArr[1]);
         return;
     } else {
         QueryReqDetail();
     }
 }
 function DoCancelRefuse() {
     if (DhcphaGridIsEmpty('#grid-reqdetail') == true) {
         return;
     }
     var selectids = $('#grid-reqdetail').jqGrid('getGridParam', 'selarrrow');
     if (selectids == '' || selectids == null) {
         dhcphaMsgBox.alert($g('请先选中需要取消拒绝退药的记录'));
         return;
     }
     dhcphaMsgBox.confirm($g('是否确认【取消拒绝】?'), function (result) {
         if (result === true) {
             ExecuteCancelRefuse();
         }
     });
 }
 function ExecuteCancelRefuse() {
     var selIDs = $('#grid-reqdetail').jqGrid('getGridParam', 'selarrrow');
     var reqiArr = [];
     for (var i = 1, len = selIDs.length; i <= len; i++) {
         var row = $('#grid-reqdetail').jqGrid('getRowData', i);
         var reqi = row.Tretrqrowid;
         reqiArr.push(reqi + '^' + '' + '^' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
     }
     var ret = tkMakeServerCall('web.DHCSTPHARETURN', 'CancelRefuseRequest', reqiArr.join(','));
     var retArr = ret.split('^');
     if (retArr[0] < 0) {
         dhcphaMsgBox.alert(retArr[1]);
         return;
     } else {
         QueryReqDetail();
     }
 }
 
function SetDefaultDate() {
    //console.log(LoadStartDate +","+ LoadEndDate)
    if ((LoadStartDate !== "")&&(LoadEndDate !== "")&&(LoadStartDate !== "undefined")&&(LoadEndDate !== "undefined")){
        var pStartDate = FormatDateT(LoadStartDate)
        var pEndDate = FormatDateT(LoadEndDate)
        $("#date-start").data('daterangepicker').setStartDate(pStartDate);
        $("#date-start").data('daterangepicker').setEndDate(pStartDate);
        $("#date-end").data('daterangepicker').setStartDate(pEndDate);
        $("#date-end").data('daterangepicker').setEndDate(pEndDate);
    }
    else {
        var gHospID = session['LOGON.HOSPID'];
        var gLocId = session['LOGON.CTLOCID'];
        var gGroupId = session['LOGON.GROUPID'];
        var gUserID = session['LOGON.USERID'];
        var params = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID
        var defalutStDate = tkMakeServerCall("web.DHCST.Common.AppCommon","GetAppPropValue","DHCSTPHARETURN","ReqDefaultStDate",params)
        defalutStDate='t-'+defalutStDate
        var tmpstartdate = FormatDateT(defalutStDate)
        $("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
        $("#date-start").data('daterangepicker').setEndDate(tmpstartdate);
    }
    
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
    var retIdStr=DHCPHA_CONSTANT.VAR.requestIDStr
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
    DHCPHA_CONSTANT.VAR.requestIDStr='';
}