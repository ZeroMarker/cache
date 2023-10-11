/**
 * 模块:   静脉配伍审核
 * 编写日期: 2018-02-11
 * 编写人:   yunhaibao
 */
var PIVAS_OEAUDIT_NS = function () {
    var SessionLoc = session['LOGON.CTLOCID'];
    var SessionUser = session['LOGON.USERID'];
    var SessionGroup = session['LOGON.GROUPID'];
    var PivasWayCode = tkMakeServerCall('web.DHCSTPIVAS.Common', 'PivasWayCode');
    var FormulaId = '';
    var ChangeViewNum = 1;
    var PersonSameFields = '[field=patNo],[field=patName],[field=bedNo],[field=wardLocDesc],[field=exceedReasonDesc]';
    var SameRowsHanlder = PIVAS.Grid.SameRows('gridOrdItem', PersonSameFields);

    InitDict();
    InitGridWard();
    InitTreePat();
    InitGridOrdItem();
    InitTreeGridReason();
    $('#btnFind').on('click', function () {
        $('#gridWard').datagrid('clear');
        $('#treePat').tree('loadData', []);
        if (Get.CurTab() == 'pat') {
            QueryPat();
        } else {
            Query();
        }
    });
    $('#btnFindDetail').on('click', QueryDetail);
    $('#btnAuditOk').on('click', function () {
        // 审核通过
        AuditOk('SHTG');
    });
    $('#btnAuditNo').on('click', function () {
        // 审核拒绝
        AuditNoShow('SHJJ');
    });
    $('#btnPhaRemark').on('click', function () {
        // 药师备注
        AuditRemarkShow();
    });
    $('#btnWinAuditRemark').on('click', function () {
        AuditRemark();
    });
    $('#btnCancelAudit').on('click', CancelAudit);
    $('#btnAnalyPresc').on('click', AnalyPresc); //合理用药
    $('#btnPrBroswer').on('click', PrbrowserHandeler);
    $('#txtPatNo').searchbox({
        prompt: $g('请输入登记号...'),
        width: 250,
        searcher: function () {
            var patNo = $('#txtPatNo').searchbox('getValue');
            patNo = PIVAS.FmtPatNo(patNo);
            $('#txtPatNo').searchbox('setValue', patNo);
            QueryPat();
        }
    });
    $('#btnAuditRecord').on('click', AuditRecordLog);
    $('#btnChangeView').on('click', ChangeView);
    $('#btnWinAuditNo').on('click', AuditNo);
    $('.pivas-full').on('click', function (e) {
        $(e.target).attr('src').indexOf('cancel') > 0 ? PIVAS.ExitFull() : PIVAS.FullScreen();
        $('.pivas-full').toggle();
    });
    $('.js-btn-toggle').on('click', function () {
        $('.js-btn-toggle').toggle();
        $(this)[0].id === 'btnCollapseAll' ? $('#treePat').tree('collapseAll') : $('#treePat').tree('expandAll');
    });
    //$("#btnMedTips").on("click", MedicineTips)
    InitPivasSettings();
    $('.dhcpha-win-mask').remove();

    function InitDict() {
        // 审核状态
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPassStat',
                Type: 'PassStat'
            },
            {
                editable: false
            }
        );
        $('#cmbPassStat').combobox('setValue', 1);
        // 审核结果
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPassResult',
                Type: 'PassResult'
            },
            {
                editable: false
            }
        );
        $('#cmbPassResult').combobox('setValue', '');
        // 护士审核
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbNurAudit',
                Type: 'NurseResult'
            },
            {
                editable: false
            }
        );
        $('#cmbNurAudit').combobox('setValue', 1);
        // 配液大类
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPivaCat',
                Type: 'PivaCat'
            },
            {}
        );
        // 科室组
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbLocGrp',
                Type: 'LocGrp'
            },
            {}
        );
        // 病区
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbWard',
                Type: 'Ward'
            },
            {}
        );
        // 医嘱优先级
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPriority',
                Type: 'Priority'
            },
            {
                width: 150
            }
        );
        // 集中配制
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbWorkType',
                Type: 'PIVAWorkType'
            },
            {}
        );
        // 药品
        PIVAS.ComboGrid.Init(
            {
                Id: 'cmgIncItm',
                Type: 'IncItm'
            },
            {
                width: 275
            }
        );
    }

    //初始化病区列表
    function InitGridWard() {
        //定义columns
        var columns = [
            [
                {
                    field: 'select',
                    checkbox: true
                },
                {
                    field: 'ward',
                    title: 'ward',
                    hidden: true
                },
                {
                    field: 'wardDesc',
                    title: '病区',
                    width: 200
                },
                {
                    field: 'cnt',
                    title: '合计',
                    width: 50,
                    align: 'right'
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            pagination: false,
            fitColumns: true,
            fit: true,
            rownumbers: false,
            columns: columns,
            queryOnSelect: false,
            toolbar: [],
            onClickRow: function (rowIndex, rowData) {
                CurWardID = rowData.ward;
                CurAdm = '';
            },
            singleSelect: false,
            selectOnCheck: true,
            checkOnSelect: true,
            onLoadSuccess: function (data) {
                $('#gridOrdItem').datagrid('clear');
                $(this).datagrid('uncheckAll');
                if (LoadInputStr !== '') {
                    if (data.total > 0) {
                        $(this).datagrid('checkAll');
                        $('#btnFindDetail').click();
                        LoadInputStr = '';
                    }
                }
            },
            onClickCell: function (rowIndex, field, value) {
                if (field == 'wardDesc') {
                    $(this).datagrid('options').queryOnSelect = true;
                }
            },
            onSelect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').queryOnSelect == true) {
                    $(this).datagrid('options').queryOnSelect = false;
                    QueryDetail();
                }
            },
            onUnselect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').queryOnSelect == true) {
                    $(this).datagrid('options').queryOnSelect = false;
                    QueryDetail();
                }
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridWard', dataGridOption);
    }

    function InitTreePat() {
        $('#treePat').tree({
            formatter: function (node) {
                if (node.children) {
                    return '<div style="line-height:35px;font-weight:bold">' + node.text + '</div>';
                } else {
                    var data = node.text;
                    var htmlArr = [];
                    htmlArr.push('<div style="line-height:35px;">');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:50px;overflow:hidden">' + '<span style="visibility:hidden">1</span>' + data.bedNo + '</div>');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:100px;padding-left:5px;overflow:hidden">' + data.patNo + '</div>');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:60px;padding-left:5px;overflow:hidden">' + data.patName + '</div>');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:40px;text-align:right;font-weight:bold">' + data.cnt + '</div>');
                    htmlArr.push('</div>');
                    return htmlArr.join('');
                }
            },
            lines: true,
            autoNodeHeight: true,
            onClick: function (node) {
                QueryDetail();
            },
            onLoadSuccess: function (node, data) {
                $('#btnCollapseAll').css('display') === 'none' ? $('#treePat').tree('collapseAll') : $('#treePat').tree('expandAll');

                if (data[0] != null) {
                    var firstNode = $('#treePat').tree('find', data[0].id);
                    var firstChildNode = $('#treePat').tree('getChildren', firstNode.target);
                    //debugger ;
                    $('#treePat').tree('select', firstChildNode[0].target);
                    QueryDetail();
                }

                /*
                var selectNode = $('#treePat').tree("getSelected");             
                if (selectNode != null){
                    $('#treePat').tree("select",selectNode.target)
                }
                */
            }
            //          onExpand:function(){
            //              var roots = $(this).tree('getRoots');
            //              if (roots.length > 0){
            //                  var flag = ''
            //                  roots.forEach(function(rowData){
            //                      if (rowData.state === 'open'){
            //                          flag = 'open'
            //                      }
            //                  })
            //                  if (flag === 'open' && $('#btnCollapseAll').css('display') === 'none'){
            //                      $('.js-btn-toggle').toggle();
            //                  }
            //              }
            //          }
        });
    }

    function QueryPat() {
        var pJson = Get.QueryParams();
        pJson.patNo = $('#txtPatNo').searchbox('getValue');
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                MethodName: 'GetPatTreeData',
                rows: 9999,
                page: 1,
                pJsonStr: JSON.stringify(pJson)
            },
            false
        );

        setTimeout(function () {
            $('#treePat').tree('loadData', rowsData);
        }, 100);
    }

    //初始化明细列表
    function InitGridOrdItem() {
        //定义columns
        var columnspat = [
            [
                {
                    field: 'gridOrdItemSelect',
                    checkbox: true
                },
                {
                    field: 'msgId',
                    title: 'msgId',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'tipsType',
                    title: '合理',
                    width: 45,
                    halign: 'left',
                    align: 'center',
                    hidden: false,
                    formatter: function (value, row, index) {
                        if (value == 'normal') {
                            // 正常 #16BBA2
                            return '<img src = "../scripts/pharmacy/images/warning0.gif" style="width:15px">';
                            return '<img src = "../scripts/pharmacy/common/image/order-pass-ok.png" >';
                        } else if (value == 'warn') {
                            // 警示 #FF6356
                            return '<img src = "../scripts/pharmacy/images/warning1.gif" >';
                            return '<img src = "../scripts/pharmacy/common/image/order-pass-warn.png" >';
                        } else if (value == 'forbid') {
                            //严重 black
                            return '<img src = "../scripts/pharmacy/images/warning2.gif" >';
                            return '<img src = "../scripts/pharmacy/common/image/order-pass-error.png" >';
                        }
                        return '';
                    }
                },
                {
                    field: 'warnInfo',
                    title: '提醒',
                    width: 100,
                    formatter: function (value, row, index) {
                        var retArr = [];
                        if (row.nurSeeDesc.indexOf('拒绝') >= 0) {
                            retArr.push('<div class="pivas-grid-div" style="color:white;">护士拒绝</div>');
                        }
                        if (row.exceedReasonDesc !== '') {
                            retArr.push('<div class="pivas-grid-div" style="color:white;">' + '有超量原因' + '</div>');
                        }
                        if (row.patSpec !== '') {
                            retArr.push('<div class="pivas-grid-div" style="color:white">' + '特殊人群' + '</div>');
                        }
                        if (retArr.length > 0) {
                        }
                        return retArr.join('');
                    },
                    styler: function (value, row, index) {
                        if (row.nurSeeDesc.indexOf('拒绝') >= 0) {
                            return 'background-color: #ff5252';
                        }
                        if (row.exceedReasonDesc !== '') {
                            return 'background-color: #ff5252';
                        }
                        if (row.patSpec !== '') {
                            return 'background-color: #ff793e';
                        }
                    }
                },
                {
                    field: 'passResultDesc',
                    title: '审核结果',
                    width: 75,
                    styler: function (value, row, index) {
	                    if (value == '' || typeof value == 'undefined' || value == null) {
		                    return '';
		                }
                        var passResult = row.passResult;

                        if (passResult == 'Y') {
                            return { class: 'pha-pivas-state-pass' };
                        } else if (passResult == 'N' || passResult == 'NY') {
                            return { class: 'pha-pivas-state-refuse' };
                        } else if (passResult == 'NA') {
                            return { class: 'pha-pivas-state-appleal' };
                        } else if (row.nurSeeDesc.indexOf('拒绝') >= 0) {
                            return { class: 'pha-pivas-state-refuse' };
                        }
                    }
                },
                {
                    field: 'phaOrdRemark',
                    title: '药师标注',
                    width: 100
                },
                {
                    field: 'bedNo',
                    title: '床号',
                    width: 75
                },
                {
                    field: 'patNo',
                    title: '登记号',
                    width: 100,
                    formatter: function (value, row, index) {
                        var qOpts = "{AdmId:'" + row.adm + "'}";
                        return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({modal:true},' + qOpts + ')">' + value + '</a>';
                    }
                },
                {
                    field: 'patName',
                    title: '姓名',
                    width: 75
                },
                {
                    field: 'pivaCatDesc',
                    title: '类型',
                    width: 50,
                    align: 'center',
                    formatter: function (value, row, index) {
                        return '<a class="pha-grid-a">' + value + '</a>';
                    }
                },
                {
                    field: 'drugsArr',
                    title: '药品信息',
                    width: 300,
                    formatter: PIVAS.Grid.Formatter.InciGroup
                },
                {
                    field: 'dosage',
                    title: '剂量',
                    width: 75,
                    align: 'right',
                    formatter: PIVAS.Grid.Formatter.DosageGroup
                },
                {
                    field: 'qtyUom',
                    title: '数量',
                    width: 50,
                    align: 'right',
                    formatter: PIVAS.Grid.Formatter.QtyUomGroup
                },
                {
                    field: 'ordRemark',
                    title: '医嘱备注',
                    width: 75,
                    formatter: PIVAS.Grid.Formatter.OrdRemarkGroup
                },
                {
                    field: 'freqDesc',
                    title: '频次',
                    width: 60
                },
                {
                    field: 'instrucDesc',
                    title: '用法',
                    width: 80
                },
                {
                    field: 'priDesc',
                    title: '医嘱优先级',
                    width: 90,
                    align: 'center'
                },

                {
                    field: 'patSex',
                    title: '性别',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'patAge',
                    title: '年龄',
                    width: 75,
                    hidden: true
                },
                {
                    field: 'patWeight',
                    title: '体重',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'patHeight',
                    title: '身高',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'diagDesc',
                    title: '诊断',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'exceedReasonDesc',
                    title: '疗程超量原因',
                    width: 100,
                    hidden: false
                },
                {
                    field: 'patSpec',
                    title: '特殊人群',
                    width: 100,
                    hidden: false
                },
                {
                    field: 'doctorName',
                    title: '医生',
                    width: 80
                },
                {
                    field: 'oeoriDateTime',
                    title: '开医嘱时间',
                    width: 120
                },
                {
                    field: 'wardLocDesc',
                    title: '病区',
                    width: 125
                },
                {
                    field: 'nurSeeDesc',
                    title: '医嘱处理',
                    width: 75
                },
                {
                    field: 'mOeori',
                    title: '主医嘱',
                    width: 100,
                    hidden: false
                },
                {
                    field: 'adm',
                    title: '就诊',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'analysisData',
                    title: '分析结果',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'doseDate',
                    title: '用药日期',
                    width: 75,
                    hidden: true
                },
                {
                    field: 'dateMOeori',
                    title: '主医嘱Id+日期',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'wardPat',
                    title: '病区患者分组',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'altCnt',
                    title: '病区患者分组',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'nurSeeFlag',
                    title: '医嘱处理',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'passResultStat',
                    title: '审核状态',
                    width: 200,
                    hidden: true
                },
                {
                    field: 'sameFlag',
                    title: 'sameFlag',
                    width: 70,
                    hidden: true,
                    styler: function (value, row, index) {
                        if (value === 'Y') {
                            return {
                                class: 'pivas-person-toggle'
                            };
                        }
                    }
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            fitColumns: false,
            singleSelect: false,
            selectOnCheck: false,
            checkOnSelect: false,
            rownumbers: false,
            nowrap: true,
            columns: columnspat,
            pageSize: 100,
            pageList: [100, 300, 500],
            pagination: true,
            toolbar: '#gridOrdItemBar',
            loadFilter: PIVAS.Grid.LoadFilter,
            onLoadSuccess: function () {
                var $grid = $(this);
                SameRowsHanlder.Hide();
                $grid.datagrid('loaded');
                $(this).datagrid('options').checking = '';
                $(this).datagrid('uncheckAll');
                $(this).datagrid('scrollTo', 0);
                GridOrdItemCellTip();
            },
            rowStyler: PIVAS.Grid.RowStyler.PersonAlt,
            onClickRow: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PIVAS.Grid.ClearSelections(this.id);
                $(this).datagrid('selectRow', rowIndex);
                SameRowsHanlder.ShowRow(rowIndex);
                $(this).datagrid('options').checking = '';
            },

            onCheck: function (rowIndex, rowData) {},
            onUncheck: function (rowIndex, rowData) {},
            onClickCell: function (rowIndex, field, value) {
                if (field == 'pivaCatDesc') {
                    if (FormulaId != '') {
                        var mOeori = $(this).datagrid('getRows')[rowIndex].mOeori;
                        PIVASPASSTPN.Init({
                            Params: mOeori + '^' + FormulaId,
                            Field: 'pivaCatDesc',
                            ClickField: field
                        });
                    } else {
                        $.messager.alert('提示', $g('获取不到审核指标公式</br>请于审核指标公式查看是否维护公式</br>请于参数设置查看是否维护需要使用的指标公式'), 'warning');
                    }
                } else if (field == 'tipsType') {
                    PHA_PASS.PDSS.ShowMsg({
                        msgId: $(this).datagrid('getRows')[rowIndex].msgId
                    });
                }
            },
            onDblClickCell: function (rowIndex, field, value) {
                return;
                // 暂屏蔽
                if (field != 'incDesc') {
                    return;
                }
                var rowData = $(this).datagrid('getRows')[rowIndex];
                if (PIVAS.VAR.PASS == 'DHC') {
                    /// 东华知识库说明书简写
                    var userInfo = SessionUser + '^' + SessionLoc + '^' + SessionGroup;
                    var incDesc = rowData.incDesc;
                    DHCSTPHCMPASS.MedicineTips({
                        Oeori: rowData.oeori,
                        UserInfo: userInfo,
                        IncDesc: incDesc
                    });
                }
            },
            groupField: 'wardPat',
            groupFormatter: function (value, rows) {
                var rowData = rows[0];
                // 病人基本信息 / 医嘱信息 /
                var viewDiv = '';
                var patDiv = '';
                var ordDiv = '';
                var wardDiv = '';
                patDiv += '<div id="grpViewPat" class="grpViewPat" style="padding-left:0px">';
                patDiv += '<div >' + rowData.patNo + '</div>';
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.bedNo + '</div>';
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patName + '</div>';
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patSex + '</div>';
                if (rowData.patAge != '') {
                    patDiv += '<div>/</div>';
                    patDiv += '<div>' + rowData.patAge + '</div>';
                }
                if (rowData.patWeight != '') {
                    patDiv += '<div>/</div>';
                    patDiv += '<div>' + rowData.patWeight + '</div>';
                }
                if (rowData.patHeight != '') {
                    patDiv += '<div>/</div>';
                    patDiv += '<div>' + rowData.patHeight + '</div>';
                }
                patDiv += '</div>';
                wardDiv += '<div id="grpViewWard" class="grpViewWard">';
                wardDiv += '<div>' + rowData.wardLocDesc + '</div>';
                wardDiv += '</div>';
                viewDiv += '<div id="grpViewBase" class="grpViewBase">' + wardDiv + patDiv + '</div>';
                return viewDiv;
            }
        };
        PIVAS.Grid.Init('gridOrdItem', dataGridOption);
    }
    function LoadAuditReasonTree() {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                MethodName: 'GetAuditReasonTreeStore',
                Params: '',
                HospId: session['LOGON.HOSPID']
            },
            function (data) {
                $('#treeReason').tree('loadData', data);
            }
        );
    }
    function InitTreeGridReason() {
        $('#treeReason').tree({
            lines: true,
            autoNodeHeight: true,
            lines: true,
            checkbox: true,
            onSelect: function (node) {},
            onLoadSuccess: function (node, data) {}
        });
    }

    ///查询
    function Query() {
        var pJson = Get.QueryParams();
        $('#gridWard').datagrid('options').url = $URL;
        $('#gridWard').datagrid('query', {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            QueryName: 'WardData',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999
        });
    }

    ///查询医嘱
    function QueryDetail() {
        var pJson = Get.QueryParams();
        var wardArr = Get.WardChecked();
        var adm = Get.AdmSelected();
        if (wardArr.length === 0 && adm === '') {
            $('#gridOrdItem').datagrid('clear');
            return;
        }
        pJson.wardStr = wardArr.join(',');
        pJson.adm = adm;

        var $grid = $('#gridOrdItem');
        PIVAS.Grid.PageHandler($grid);
        $grid.datagrid('loading');
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                QueryName: 'OrderData',
                pJsonStr: JSON.stringify(pJson),
                rows: 9999,
                page: 1
            },
            false
        );
        setTimeout(function () {
            $grid.datagrid('loadData', rowsData);
        }, 100);
    }

    /// 配伍审核通过
    function AuditOk(passType) {
        var dateMOeoriStr = GetDateMainOeoriStr();
        if (dateMOeoriStr == '') {
            DetailAlert('SHTG');
            return;
        }
        PIVAS.Progress.Show({
            type: 'save',
            interval: 1000
        });
        $.m(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                MethodName: 'PivasPass',
                dateMOeoriStr: dateMOeoriStr,
                userId: SessionUser,
                passType: passType
            },
            function (passRet) {
                PIVAS.Progress.Close();
                var passRetArr = passRet.split('^');
                var passVal = passRetArr[0];
                var passInfo = passRetArr[1];
                if (passVal == 0) {
                } else {
                    $.messager.alert('提示', passInfo, 'warning');
                    return;
                }
                QueryDetail();
            }
        );
    }

    /// 配伍审核拒绝弹窗
    function AuditNoShow(passType) {
        if (PivasWayCode == '') {
            $.messager.alert('提示', $g('请先维护配伍审核原因'), 'warning');
            return;
        }
        var dateMOeoriStr = GetDateMainOeoriStr();
        if (dateMOeoriStr == '') {
            DetailAlert('SHJJ');
            return;
        }
        $('#reasonSelectDiv')
            .window({
                title: $g('审核拒绝原因选择')
            })
            .dialog('open');
        LoadAuditReasonTree();
    }

    /// 拒绝
    function AuditNo() {
        var winTitle = $('#reasonSelectDiv').panel('options').title;
        var passType = 'SHJJ';
        var checkedNodes = $('#treeReason').tree('getChecked');
        if (checkedNodes.length == 0) {
            $.messager.alert('提示', $g('请选择原因'), 'warning');
            return '';
        }
        var reasonStr = '';
        for (var nI = 0; nI < checkedNodes.length; nI++) {
            var reasonId = checkedNodes[nI].id;
            if (reasonId == 0) {
                continue;
            }
            // 只要叶子节点
            if (checkedNodes[nI].isLeaf === 'Y') {
                reasonStr = reasonStr == '' ? reasonId : reasonStr + '!!' + reasonId;
            }
        }
        var reasonNotes = $('#txtReasonNotes').val();
        var reasonData = reasonStr + '|@|' + reasonNotes;
        var dateMOeoriStr = GetDateMainOeoriStr();
        // 同步,不需遮罩
        var passRet = tkMakeServerCall('web.DHCSTPIVAS.OeAudit', 'PivasPass', dateMOeoriStr, SessionUser, passType, reasonData);
        var passRetArr = passRet.split('^');
        var passVal = passRetArr[0];
        var passInfo = passRetArr[1];
        if (passVal == 0) {
            $('#reasonSelectDiv').dialog('close');
        } else {
            $.messager.alert('提示', passInfo, 'warning');
            return;
        }
        QueryDetail();
        $('#txtReasonNotes').val('');
    }

    ///取消配伍审核
    function CancelAudit() {
        var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked') || '';
        if (gridOrdItemChecked == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请勾选需要取消审核的记录'),
                type: 'alert'
            });
            return;
        }
        var dateMOeoriArr = [];
        for (var i = 0; i < gridOrdItemChecked.length; i++) {
            var checkedData = gridOrdItemChecked[i];
            var passResultStat = checkedData.passResultStat;

            if (passResultStat == '') {
                continue;
            }
            var dateMOeori = checkedData.dateMOeori;
            if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
                dateMOeoriArr.push(dateMOeori);
            }
        }
        var dateMOeoriStr = dateMOeoriArr.join('^');
        if (dateMOeoriStr == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('没有需要取消审核的记录'),
                type: 'alert'
            });
            return;
        }
        var conditionHtml = $g('您确认取消审核?');
        $.messager.confirm($g('温馨提示'), conditionHtml, function (r) {
            if (r) {
                var cancelRet = tkMakeServerCall('web.DHCSTPIVAS.OeAudit', 'CancelPivasPassMulti', dateMOeoriStr, SessionUser);
                var cancelRetArr = cancelRet.toString().split('^');
                var cancelVal = cancelRetArr[0] || '';
                if (cancelVal == '-1') {
                    $.messager.alert('提示', cancelRetArr[1], 'warning');
                }
                QueryDetail();
            }
        });
    }

    /// 病例浏览
    function PrbrowserHandeler() {
        var gridSelect = $('#gridOrdItem').datagrid('getSelected');
        if (gridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请先选中记录'),
                type: 'alert'
            });
            return;
        }
        PIVAS.ViewEMRWindow({}, gridSelect.adm);
    }

    /// 获取选择的主医嘱串
    function GetDateMainOeoriStr() {
        var dateMOeoriArr = [];
        var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
        for (var i = 0; i < gridOrdItemChecked.length; i++) {
            var checkedData = gridOrdItemChecked[i];
            var passResultStat = checkedData.passResultStat;
            // 处理过不再处理
            if (passResultStat != '') {
                continue;
            }
            var dateMOeori = checkedData.dateMOeori;
            if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
                dateMOeoriArr.push(dateMOeori);
            }
        }
        return dateMOeoriArr.join('^');
    }

    function ClearGrid() {}

    function AuditRecordLog() {
        var gridSelect = $('#gridOrdItem').datagrid('getSelected');
        if (gridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请先选中记录'),
                type: 'alert'
            });
            return;
        }
        var dateMOeori = gridSelect.dateMOeori;
        PIVAS.AuditRecordWindow({
            dateMOeori: dateMOeori
        });
    }

    /// 初始化默认条件
    function InitPivasSettings() {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Settings',
                MethodName: 'GetAppProp',
                userId: session['LOGON.USERID'],
                locId: session['LOGON.CTLOCID'],
                appCode: 'OeAudit'
            },
            function (jsonData) {
                $('#dateStart').datebox('setValue', jsonData.OrdStDate);
                $('#dateEnd').datebox('setValue', jsonData.OrdEdDate);
                PIVAS.VAR.PASS = jsonData.Pass;
                var FormulaDesc = jsonData.Formula;
                if (jsonData.MaxDrugCnt > 2) {
                    PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
                }

                FormulaId = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetDIIIdByDesc', FormulaDesc);
                if (jsonData.GroupView == 'Y') {
                    ChangeView();
                }
                if (PIVAS.VAR.PASS === 'DHC') {
                    PHA_UTIL.LoadJS(['../scripts/dhcnewpro/dhcckb/pdss.js'], function () {});
                }
            }
        );
    }

    function AnalyPresc() {
        if (PIVAS.VAR.PASS == 'DHC') {
            if ($('#gridOrdItem').datagrid('getRows').length === 0) {
                return;
            }
            $('#gridOrdItem').datagrid('loading');
            setTimeout(function () {
                PHA_PASS.PDSS.Analysis(
                    {
                        gridId: 'gridOrdItem',
                        mOeoriField: 'dateMOeori'
                    },
                    function (retData) {
                        for (var i = 0, length = retData.length; i < length; i++) {
                            var iData = retData[i];
                            $('#gridOrdItem').datagrid('updateRow', {
                                index: iData.index,
                                row: iData.row
                            });
                        }
                        $('#gridOrdItem').datagrid('loaded');
                        SameRowsHanlder.Hide();
                    }
                );
            }, 500);

            return;
            DHCSTPHCMPASS.PassAnalysis({
                GridId: 'gridOrdItem',
                MOeori: 'dateMOeori',
                GridType: 'EasyUI',
                Field: 'analysisResult',
                CallBack: GridOrdItemCellTip
            });
        } else if (PIVAS.VAR.PASS == 'DT') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('大通接口未开放,请联系相关产品组调试接口'),
                type: 'alert'
            });
            return;
            StartDaTongDll();
            DaTongPrescAnalyse();
        } else if (PIVAS.VAR.PASS == 'MK') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('美康接口未开放,请联系相关产品组调试接口'),
                type: 'alert'
            });
            return;
            MKPrescAnalyse();
        } else {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('无此类型合理用药接口,请检查药品系统管理->参数设置->配液中心->合理用药参数'),
                type: 'alert'
            });
            return;
        }
    }

    /// 明细表格celltip
    function GridOrdItemCellTip() {
        PIVAS.Grid.CellTip({
            TipArr: ['ordRemark']
        });
        PIVAS.Grid.CellTip({
            TipArr: ['patNo'],
            ClassName: 'web.DHCSTPIVAS.Common',
            MethodName: 'PatBasicInfoHtml',
            TdField: 'mOeori'
        });
        PIVAS.Grid.CellTip({
            TipArr: ['warnFlag'],
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            MethodName: 'WarnFlagInfoHtml',
            TdField: 'dateMOeori'
        });
    }

    function ChangeView() {
        var hsMethod = '';
        var showView = '';
        if (ChangeViewNum % 2 == 1) {
            hsMethod = 'hideColumn';
            showView = groupview;
        } else {
            hsMethod = 'showColumn';
            showView = $.fn.datagrid.defaults.view;
        }
        var gridOpts = $('#gridOrdItem').datagrid('options');
        $('#gridOrdItem').datagrid(hsMethod, 'patNo');
        $('#gridOrdItem').datagrid(hsMethod, 'patName');
        $('#gridOrdItem').datagrid(hsMethod, 'bedNo');
        $('#gridOrdItem').datagrid(hsMethod, 'wardLocDesc');
        $('#gridOrdItem').datagrid('options').view = showView;
        QueryDetail();
        ChangeViewNum++;
    }

    /// 详细提示,对应通过\拒绝,当未勾选时进入
    function DetailAlert(auditType) {
        var dateMOeoriArr = [];
        var shtgArr = [];
        var shjjArr = [];
        var hsjjArr = [];
        var hswclArr = [];
        var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
        for (var i = 0; i < gridOrdItemChecked.length; i++) {
            var checkedData = gridOrdItemChecked[i];
            var passResultStat = checkedData.passResultStat;
            var passResult = checkedData.passResult;
            var dateMOeori = checkedData.dateMOeori;
            var nurSeeFlag = checkedData.nurSeeFlag;
            var warnFlag = checkedData.warnFlag;
            // 处理过不再处理
            if (passResultStat == '') {
                if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
                    dateMOeoriArr.push(dateMOeori);
                }
            } else if (passResult == 'Y') {
                if (shtgArr.indexOf(dateMOeori) < 0) {
                    shtgArr.push(dateMOeori);
                }
            } else if (passResult == 'N' || passResult == 'NY') {
                if (shjjArr.indexOf(dateMOeori) < 0) {
                    shjjArr.push(dateMOeori);
                }
            }
            if (nurSeeFlag == 'N') {
                if (hsjjArr.indexOf(dateMOeori) < 0) {
                    hsjjArr.push(dateMOeori);
                }
            }
        }
        var msgInfo = $g('请先选择记录');
        if (auditType == 'SHTG') {
            if (shjjArr.length > 0) {
                msgInfo = $g('请先取消审核');
            } else if (shtgArr.length > 0) {
                msgInfo = $g('您选择的记录已审核通过');
            }
        } else if (auditType == 'SHJJ') {
            if (shtgArr.length > 0) {
                msgInfo = $g('请先取消审核');
            } else if (shjjArr.length > 0) {
                msgInfo = $g('您选择的记录已审核拒绝');
            }
        }
        if (hsjjArr.length > 0) {
            msgInfo = $g('您选择的记录需要护士先处理医嘱');
        }
        if (hswclArr.length > 0) {
            msgInfo = $g('您选择的记录护士尚未处理医嘱');
        }
        DHCPHA_HUI_COM.Msg.popover({
            msg: msgInfo,
            type: 'alert'
        });
    }
    function AuditRemarkShow() {
        var gridSelect = $('#gridOrdItem').datagrid('getSelected');
        if (gridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请选中需要标注的记录'),
                type: 'alert'
            });
            return;
        }
        $('#phaMarkDiv').dialog('open');
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                MethodName: 'GetPivasRemark',
                dateMOeoriStr: gridSelect.dateMOeori
            },
            function (retData) {
                $('#conOrdRemark').val(retData.orderRemark || '');
                $('#conExeRemark').val(retData.executeRemark || '');
                $('#conLabelRemark').val(retData.labelRemark || '');
            }
        );
    }
    /// 标注无限制,按选择行,可能在勾选过程中标注某一条医嘱
    function AuditRemark() {
        var gridSelect = $('#gridOrdItem').datagrid('getSelected');
        var rowIndex = $('#gridOrdItem').datagrid('getRows').indexOf(gridSelect);
        var dateMOeori = gridSelect.dateMOeori;
        var ordRemark = $('#conOrdRemark').val();
        var exeRemark = $('#conExeRemark').val();
        var labelRemark = $('#conLabelRemark').val();
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                MethodName: 'PivasRemark',
                dateMOeoriStr: dateMOeori,
                userId: SessionUser,
                ordRemark: ordRemark,
                exeRemark: exeRemark,
                labelRemark: labelRemark,
                dataType: 'text'
            },
            function (passRet) {
                var passRetArr = passRet.split('^');
                var passVal = passRetArr[0];
                var passInfo = passRetArr[1];
                if (passVal == 0) {
                    DHCPHA_HUI_COM.Msg.popover({
                        msg: $g('标注成功'),
                        type: 'success'
                    });

                    var retRowData = $.cm(
                        {
                            ClassName: 'web.DHCSTPIVAS.OeAudit',
                            MethodName: 'GetRowData',
                            dateMOeori: dateMOeori
                        },
                        false
                    );
                    $('#gridOrdItem').datagrid('updateRow', {
                        index: rowIndex,
                        row: retRowData
                    });
                    $('#phaMarkDiv').dialog('close');
                } else {
                    $.messager.alert('提示', passInfo, 'warning');
                }
            }
        );
    }
    var Get = {
        QueryParams: function () {
            var pJson = {};
            pJson.loc = SessionLoc;
            pJson.wardStr = $('#cmbWard').combobox('getValue') || '';
            pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || '';
            pJson.startDate = $('#dateStart').datebox('getValue') || '';
            pJson.endDate = $('#dateEnd').datebox('getValue') || '';
            pJson.cat = $('#cmbPivaCat').combobox('getValue') || '';
            pJson.workType = $('#cmbWorkType').combobox('getValue') || '';
            pJson.priority = $('#cmbPriority').combobox('getValue') || '';
            pJson.passStat = $('#cmbPassStat').combobox('getValue') || '';
            pJson.passResult = $('#cmbPassResult').combobox('getValue') || '';
            pJson.inci = $('#cmgIncItm').combogrid('getValue') || '';
            pJson.nurAudit = $('#cmbNurAudit').combobox('getValue') || '';
            pJson.phaMark = $('#chkPhaMark').checkbox('getValue') === true ? 'Y' : '';
            return pJson;
        },
        CurTab: function () {
            var tabID = $('#tabsOne').tabs('getSelected').panel('options').id;
            return tabID === 'tabWard' ? 'ward' : 'pat';
        },
        WardChecked: function () {
            var retArr = [];
            if (this.CurTab() === 'pat') {
                return retArr;
            }
            var gridChecked = $('#gridWard').datagrid('getChecked');
            for (var i = 0; i < gridChecked.length; i++) {
                retArr.push(gridChecked[i].ward);
            }
            return retArr;
        },
        AdmSelected: function () {
            var adm = '';
            if (this.CurTab() === 'ward') {
                return adm;
            }
            var treeSel = $('#treePat').tree('getSelected');
            if (treeSel === null) {
                return adm;
            }
            adm = treeSel.text.adm || '';
            return adm;
        },
        PogChecked: function () {
            var retArr = [];
            var origRows = $('#gridOrdExe').datagrid('getData').originalRows;
            if (typeof origRows === 'undefined') {
                return retArr;
            }
            var len = origRows.length;
            for (var i = 0; i < len; i++) {
                var rowData = origRows[i];
                if (rowData.check === 'Y') {
                    retArr.push(origRows[i].pog);
                }
            }
            return retArr;
        }
    };
    // 针对药学首页的处理
    if (LoadInputStr !== '') {
        setTimeout(function () {
            var LoadInputArr = LoadInputStr.split('#');
            $('#dateStart').datebox('setValue', PIVAS.GetDate(LoadInputArr[0]));
            $('#dateEnd').datebox('setValue', PIVAS.GetDate(LoadInputArr[1]));
            $('#cmbPassStat').combobox('setValue', 3);
            $('#btnFind').click();
        }, 500);
    }
    // 针对消息窗口的处理
    if (LoadPatNo != '') {
        $('#tabsOne').tabs('select', 1);
        setTimeout(function () {
            InitParams();
            $('#txtPatNo').searchbox('setValue', LoadPatNo);
            QueryPat();
        }, 1000);
    }
    function InitParams() {
        if (LoadOrdItmId == '') {
            return;
        }
        var retVal = tkMakeServerCall('PHA.COM.Method', 'GetOrdItmInfoForTipMess', LoadOrdItmId);
        if (retVal != '{}') {
            var retJson = JSON.parse(retVal);
            var ordDate = retJson.ordDate;
            $('#dateStart').datebox('setValue', ordDate);
        }
    }
};
$(PIVAS_OEAUDIT_NS);