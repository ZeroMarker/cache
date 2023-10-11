/**
 * @author wujiang
 */
if (!Array.prototype.includes) {
    Array.prototype.includes = function(elem) {
        if (this.indexOf(elem) < 0) {
            return false;
        } else {
            return true;
        }
    }
}
if (!String.prototype.includes) {
    String.prototype.includes = function(elem) {
        if (this.indexOf(elem) < 0) {
            return false;
        } else {
            return true;
        }
    }
}
/**  
 * layout方法扩展  
 * @param {Object} jq  
 * @param {Object} region  
 */
$.extend($.fn.layout.methods, {
    /**  
     * 面板是否存在和可见  
     * @param {Object} jq  
     * @param {Object} params  
     */
    isVisible: function(jq, params) {
        var panels = $.data(jq[0], 'layout').panels;
        var pp = panels[params];
        if (!pp) {
            return false;
        }
        if (pp.length) {
            return pp.panel('panel').is(':visible');
        } else {
            return false;
        }
    },
    /**  
     * 隐藏除某个region，center除外。  
     * @param {Object} jq  
     * @param {Object} params  
     */
    hidden: function(jq, params) {
        return jq.each(function() {
            var opts = $.data(this, 'layout').options;
            var panels = $.data(this, 'layout').panels;
            if (!opts.regionState) {
                opts.regionState = {};
            }
            var region = params;

            function hide(dom, region, doResize) {
                var first = region.substring(0, 1);
                var others = region.substring(1);
                var expand = 'expand' + first.toUpperCase() + others;
                if (panels[expand]) {
                    if ($(dom).layout('isVisible', expand)) {
                        opts.regionState[region] = 1;
                        panels[expand].panel('close');
                    } else if ($(dom).layout('isVisible', region)) {
                        opts.regionState[region] = 0;
                        panels[region].panel('close');
                    }
                } else {
                    panels[region].panel('close');
                }
                if (doResize) {
                    $(dom).layout('resize');
                }
            };
            if (region.toLowerCase() == 'all') {
                hide(this, 'east', false);
                hide(this, 'north', false);
                hide(this, 'west', false);
                hide(this, 'south', true);
            } else {
                hide(this, region, true);
            }
        });
    },
    /**  
     * 显示某个region，center除外。  
     * @param {Object} jq  
     * @param {Object} params  
     */
    show: function(jq, params) {
        return jq.each(function() {
            var opts = $.data(this, 'layout').options;
            var panels = $.data(this, 'layout').panels;
            var region = params;

            function show(dom, region, doResize) {
                var first = region.substring(0, 1);
                var others = region.substring(1);
                var expand = 'expand' + first.toUpperCase() + others;
                if (panels[expand]) {
                    if (!$(dom).layout('isVisible', expand)) {
                        if (!$(dom).layout('isVisible', region)) {
                            if (opts.regionState[region] == 1) {
                                panels[expand].panel('open');
                            } else {
                                panels[region].panel('open');
                            }
                        }
                    }
                } else {
                    panels[region].panel('open');
                }
                if (doResize) {
                    $(dom).layout('resize');
                }
            };
            if (region.toLowerCase() == 'all') {
                show(this, 'east', false);
                show(this, 'north', false);
                show(this, 'west', false);
                show(this, 'south', true);
            } else {
                show(this, region, true);
            }
        });
    }
});
$.extend($.fn.datagrid.methods, {
    editCell: function(jq, param) {
        return jq.each(function() {
            $(this).datagrid('endEdit', param.index);
            var opts = $(this).datagrid('options');
            var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
            for (var i = 0; i < fields.length; i++) {
                var col = $(this).datagrid('getColumnOption', fields[i]);
                col.editor1 = col.editor;
                // if (fields[i] != param.field){
                if (!param.field.includes(fields[i])) {
                    col.editor = null;
                }
            }
            $(this).datagrid('beginEdit', param.index);
            for (var i = 0; i < fields.length; i++) {
                var col = $(this).datagrid('getColumnOption', fields[i]);
                col.editor = col.editor1;
            }
        });
    }
});
var editBGCell = (function() {
    var oldFields;
    return function(fields, index) {
        if (fields) oldFields = fields;
        $('#bloodGlucose').datagrid('editCell', {
            index: index,
            field: oldFields || []
        });
    };
})();
var frm = dhcsys_getmenuform();
var hospComp, hospID, wardsData = [],
    docAdvicesObj = {};
var patNode, ctcRecordObj = {},
    subRecordObj = {},
    updateADRsFlag = true,
    treeTimer, backupIds = [],
    curModelType, fixRowNum, saveFlag = true;
var bgConfig = {},
    bgConfigData = []; //血糖配置信息
var columns = [],
    timeouter, bgData = [];
var warnCondition = [],
    filterIndex = []; //预警条件
var measures = []; //措施
var retestObj = {}; //修改血糖值或复测血糖值信息
var page = 1,
    pageSize = 20;
var myChart;
if ('undefined'==typeof HISUIStyleCode) {
	var HISUIStyleCode="blue";
}
$('#bloodGlucose').datagrid({
    singleSelect: true,
    // onClickRow: function (rowIndex, rowData) {
    // 	$(this).datagrid('unselectRow', rowIndex);
    // },
});
var unfoldFlag = true; //评估项树展开标识
$(function() {
    hospComp = GenHospComp("Nur_IP_BGTime", session["LOGON.USERID"] + '^' + session["LOGON.GROUPID"] + '^' + session["LOGON.CTLOCID"] + '^' + session["LOGON.HOSPID"]);
    hospID = hospComp.getValue();
    hospComp.options().onSelect = function(i, d) {
        hospID = d.HOSPRowId;
        docAdvicesObj = {};
        init();
    }
    init();
});
// 初始化
function init() {
    $('#endDate').datebox('setValue', formatDate(new Date()));
    // $('#startDate').datebox('setValue', formatDate(new Date()));
    $('#startDate').datebox('setValue', dateCalculate(new Date(), -6));
    $("#redkw").keywords({
        singleSelect: true,
        labelCls: 'red',
        items: [
            { text: $g('本人'), id: '1', selected: true },
            { text: $g('本科'), id: '2' },
            { text: $g('内分泌虚拟病房'), id: '3' }
        ],
        onClick: function(v) {
            console.log(v);
            $('#ward').combobox('clear');
            if (3 == v.id) {
                $('#bgLayout').layout('show', 'west');
                $('#ward').combo('disable');
                warnCondition.map(function(e, i) {
                    $("span.severity:eq(" + i + ")").html(e.name)
                })
                getWarningWards();
                $('#bloodGlucose').datagrid('loadData', { total: 0, rows: [] });
            } else {
                $('#ward').combo('enable');
                $('#bgLayout').layout('hidden', 'west');
                getBGRecordByDays();
            }
            toggleCollapse();
        },
        onUnselect: function(v) {
            console.log("你选择->");
            console.dir(v);
        },
        onSelect: function(v) {
            console.log("你取消选择->");
            console.dir(v);
        }
    });
    $('#bgLayout').layout('hidden', 'west');
    toggleCollapse();
    setDateboxOption();
    // 更新dom元素的大小
    updateDomSize();
    var count = 0;
    // 获取血糖采集时间配置
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
        QueryName: 'GetBGConfig',
        rows: 999999999999999,
        random: "Y",
        hospDR: hospID
    }, function(data) {
        data = data.rows;
        console.log(data);
        bgConfigData = data;
        $("#bgConfig tr td:gt(0)").remove();
        data.map(function(e) {
            bgConfig[e.VSId] = e;
            bgConfig[e.VSCode] = e.VSId;
            var item = '<td class="r-label"><input class="hisui-checkbox bgItem" type="checkbox"  data-id="' + e.id + '"  data-options="onCheckChange:bgCfgChange" label="' + e.VSDesc + '" id="' + e.VSCode + '"></td>';
            $("#bgConfig tr").append(item);
            $("#bgConfig tr td:eq(-1) input").checkbox({
                label: e.VSDesc,
                value: e.id,
                checked: true
            });
        })
        count++;
    });
    // 获取血糖预警配置
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
        QueryName: 'GetBGWarn',
        rows: 999999999999999,
        hospDR: hospID
    }, function(data) {
        data = data.rows;
        console.log(data);
        warnCondition = data.filter(function(e) {
            return 'R' == e.type; //取高危的数据
        });
        $("#bgWarn tr td:eq(0)").empty();
        $("#bgWarn .helpDetail").empty();
        warnCondition.map(function(e, i) {
            if ('R' == e.type) { //取高危的数据
                var item = '<span class="severity" onclick="toggleStatus(this,' + i + ');" style="color: ' + e.color + ';border: 1px solid ' + e.color + ';">' + e.name + '</span>';
                $("#bgWarn tr td:eq(0)").append(item);
                var detail = '<p><i class="dot" style="background: ' + e.color + ';"></i><span>' + e.variableDesc+' ' + e.docMeasureDetail + '</span></p>';
                $("#bgWarn .helpDetail").append(detail);
            }
        });
        count++;
    });
    // 获取病区列表
    $cm({
        ClassName: 'Nur.NIS.Service.Base.Ward',
        QueryName: 'GetallWardNew',
        rows: 999999999999999,
        bizTable: "Nur_IP_WardProGroup",
        hospid: hospID
    }, function(data) {
        data = data.rows;
        $('#ward').combobox('loadData', data);
        count++;
    });
    var timer = setInterval(function() {
        if (count > 2) {
            clearInterval(timer);
            if (frm) {
                patNode = {
                    episodeID: frm.EpisodeID.value,
                    patientID: frm.PatientID.value
                }
                console.log(patNode);
            }
            if (EpisodeID) {
                $cm({
                    ClassName: 'Nur.NIS.Service.Base.Patient',
                    MethodName: 'GetPatient',
                    EpisodeID: EpisodeID
                }, function (patInfo) {
                    $("#medicareNo").val(patInfo.medicareNo);
                    $("#patName").val(patInfo.name);
                    // $("#bedCode").val(patInfo.bedCode);
                    $("#startDate").datebox('setValue',patInfo.inHospDateTime.split(' ')[0])
                    if (session['LOGON.USERNAME']==patInfo.mainDoctor) {
                        $('#redkw li[id="1"]').click();
                    } else {
                        $('#redkw li[id="2"]').click();
                    }
                });
                $('#redkw').hide();
                $('#_HospList').parents('tr').hide();
                $('#adrsPanel>table:eq(0) tr table tr>td:gt(3):lt(8)').hide();
            }else{
                getBGRecordByDays();
            }
        }
    }, 30);
    var maskWidth = $(window).width();  
    var maskHeight = $(window).height();  
    var maskHtml = "<div id='maskLoading' class='panel-body' style='z-index:1000;position:absolute;left:0;width:100%!important;background: rgba(0,0,0,.2);";  
    maskHtml += "height:" + maskHeight + "px;top:0'>";  
    maskHtml += "<div class='panel-header panel=loading' style='position:absolute;cursor:wait;left:" + ((maskWidth / 2) - 100) + "px;top:" + (maskHeight / 2 - 50) + "px;width:150px!important;height:16px;";  
    maskHtml += "padding:10px 5px 10px 30px;font-size:12px;border:1px solid #ccc;background-color:white;border-radius: 4px;'>";  
    maskHtml += $g("页面加载中，请等待...");  
    maskHtml += "</div>";  
    maskHtml += "</div>";  
    $('body').append(maskHtml);  
	if ('lite'==HISUIStyleCode) { //极简
		$('.eduExeStyle').append('.helpInfo>.helpFlag>span.icon{height: 16px;vertical-align: middle;line-height: 9px;}');
		$('.eduExeStyle').append('body{background-color: #f5f5f5;}');
		$('.eduExeStyle').append('.layout-split-west{border-right-color:#FFF;}');
	}
}

function exportExcel() {
    $('#bloodGlucose').datagrid('toExcel', "血糖异常信息.xls");
}

function toggleCollapse() {
    var n = 0;
    var timer = setInterval(function() {
        n++;
        $('#bloodGlucose').datagrid('resize', {
            width: $('#layCenter').width()
        })
        if (n > 10) {
            clearInterval(timer);
        }
    }, 50);
}

function bgCfgChange(e, v) {
    console.log(arguments);
    if (v) {
        bgConfigData.map(function(e) {
            v = v && $("#" + e.VSCode).checkbox('getValue');
        })
    }
    if (saveFlag) {
        getBGRecordByDays();
    }
    saveFlag = false;
    $("#checkAll").checkbox('setValue', v);
    timeouter = setTimeout(function() {
        saveFlag = true;
    }, 50);
}

function checkAllBG(e, v) {
    if (saveFlag) {
        saveFlag = false
        bgConfigData.map(function(e) {
            $("#" + e.VSCode).checkbox('setValue', v);
        })
        timeouter = setTimeout(function() {
            saveFlag = true;
        }, 300);
        getBGRecordByDays();
    }
}
// 设置日期选择框禁用值
function setDateboxOption() {
    var now = new Date();
    var startDate = $("#startDate").datebox('getValue'),
        endDate = $("#endDate").datebox('getValue');
    var startOpt = $("#startDate").datebox('options'),
        endOpt = $("#endDate").datebox('options');
    if (!startDate || !endDate) return;
    startOpt.maxDate = endDate;
    endOpt.minDate = startDate;
    endOpt.maxDate = endOpt.formatter(now);
}
// 切换选中的状态
function toggleStatus(obj, i) {
    var pbgColor = $(obj).css('background-color'),
        cbgColor = $(obj).css('color');
    $(obj).css({
        background: cbgColor,
        color: pbgColor
    });
    if ('rgb(255, 255, 255)' == pbgColor) {
        filterIndex.push(i);
    } else {
        filterIndex.splice(filterIndex.indexOf(i), 1);
    }
    getBGRecordByDays();
}
// 获取警示病区分布
function getWarningWards() {
    var startDate = $("#startDate").datebox('getValue'),
        endDate = $("#endDate").datebox('getValue');
    var obsDrs = [];
    var keys = Object.keys(bgConfig);
    keys.map(function(e) {
        var v = $("#" + bgConfig[e].VSCode).checkbox('getValue');
        if (v) obsDrs.push(e);
    })
    var warnCond = [];
    for (var i = 0; i < warnCondition.length; i++) {
        var condition = '(M' + warnCondition[i].condition + ')';
        condition = condition.replace(/\|\|/g, ')||(M').replace(/\&\&/g, ')&&(M');
        warnCond.push({
            code: warnCondition[i].code,
            items: warnCondition[i].relatedBGItems.split(','),
            condition: condition,
        });
    }
    $('#maskLoading').fadeIn('fast');
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'getWarningWards',
        startDate: startDate,
        endDate: endDate,
        ObsDrs: JSON.stringify(obsDrs),
        hospDR: hospID,
        warnCond: JSON.stringify(warnCond)
    }, function(data) {
        $('#maskLoading').fadeOut('fast');
        var columns = [];
        for (var i = 0; i < warnCondition.length; i++) {
            (function() {
                var code = warnCondition[i].code;
                columns.push({
                    sortable: true,
                    field: code + '_warn',
                    title: warnCondition[i].name,
                    sorter: function(a, b) {
                        return a > b ? 1 : -1;
                    },
                    formatter: function(value, row, index) {
                        var c = code;
                        if (row[c + '_deal']) {
                            return row[c + '_deal'] + '/' + row[c + '_warn']
                        } else {
                            return row[c + '_warn']
                        }
                    }
                });
            })();
        }
        $('#warningWard').datagrid({
            remoteSort: false,
            frozenColumns: [
                [
                    { field: "wardDesc", title: '病区' }
                ]
            ],
            columns: [columns],
            data: { total: data.length, rows: data }
        });
        var innerHeight = window.innerHeight;
        $('#warningWard').datagrid('resize', {
            height: innerHeight - 231
        })
        $('#layWest').panel('resize', {
            height: innerHeight - 191
        });
    });
}

function selectWWRow(curInd, row) {
    $('#ward').combobox('setValue', row.wardId);
    page = 1;
    getBGRecordByDays();
}
// 获取某些天的血糖记录
function getBGRecordByDays(p) {
    if (p) page = 1;
    var type = $("#redkw").keywords('getSelected')[0];
    console.log(type);
    var startDate = $("#startDate").datebox('getValue'),
        endDate = $("#endDate").datebox('getValue');
    var obsDrs = [];
    var keys = Object.keys(bgConfig);
    keys.map(function(e) {
        var v = $("#" + bgConfig[e].VSCode).checkbox('getValue');
        if (v) obsDrs.push(e);
    })
    var mediNoKey = $("#medicareNo").val();
    var patNameKey = $("#patName").val();
    var bedCodeKey = $("#bedCode").val();
    var wardKey = $('#ward').combobox('getValue');
    saveFlag = false;
    var warnCond = [];
    if (filterIndex.length) {
        for (var j = 0; j < filterIndex.length; j++) {
            var i = filterIndex[j];
            var condition = '(M' + warnCondition[i].condition + ')';
            condition = condition.replace(/\|\|/g, ')||(M').replace(/\&\&/g, ')&&(M');
            warnCond.push({
                items: warnCondition[i].relatedBGItems.split(','),
                condition: condition,
            });
        }
    } else {
        for (var i = 0; i < warnCondition.length; i++) {
            var condition = '(M' + warnCondition[i].condition + ')';
            condition = condition.replace(/\|\|/g, ')||(M').replace(/\&\&/g, ')&&(M');
            warnCond.push({
                items: warnCondition[i].relatedBGItems.split(','),
                condition: condition,
            });
        }
    }
    var numCond = [];
    for (var i = 0; i < warnCondition.length; i++) {
        var condition = '(M' + warnCondition[i].condition + ')';
        condition = condition.replace(/\|\|/g, ')||(M').replace(/\&\&/g, ')&&(M');
        numCond.push({
            num: 0,
            name: warnCondition[i].name,
            items: warnCondition[i].relatedBGItems.split(','),
            condition: condition,
        });
    }
    $('#maskLoading').fadeIn('fast');
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'getBGRecordByRiskConditions',
        Type: type.id,
        startDate: startDate,
        endDate: endDate,
        ObsDrs: JSON.stringify(obsDrs),
        mediNoKey: mediNoKey,
        patNameKey: patNameKey,
        bedCodeKey: bedCodeKey,
        wardKey: wardKey,
        hospDR: hospID,
        page: page,
        pageSize: pageSize,
        warnCond: JSON.stringify(warnCond),
        numCond: JSON.stringify(numCond)
    }, function(res) {
        $('#maskLoading').fadeOut('fast');
        if ((res.total > 0) && !res.rows.length && (page > 1)) {
            page = 1
            getBGRecordByDays();
            return;
        }
        res.warnNum.map(function(e, i) {
            var s = $g(e.name);
            if (e.num > 0) s += '(' + e.num + ')';
            $("span.severity:eq(" + i + ")").text(s)
        })
        var data = res.rows;
        bgData = JSON.parse(JSON.stringify(data));
        var columnWidth = 130;
        columns = [
            { field: "diagnosis", title: '诊断' },
            { field: "wardDesc", title: '病区' },
            { field: "mainDoc", title: '主治医师' },
            { field: "date", title: '测量日期' },
            { field: "time", title: '测量时间' },
            {
                field: "itemDesc",
                title: '测量点',
                formatter: function(value, row, index) {
                    return $g(bgConfig[bgConfig[row.VSCode]].VSDesc);
                }
            }
        ];
        columns.push({
            field: "bgValue",
            title: '血糖值',
            styler: function(value, row, index) {
                if (('' === value) || ('undefined' == typeof value) || isNaN(parseFloat(value))) return;
                // if (value.toString().includes('/')) return;
                if (value.toString().includes('/')) value = parseFloat(value);
                var vsId = bgConfig[row.VSCode];
                if (filterIndex.length) {
                    for (var j = 0; j < filterIndex.length; j++) {
                        var i = filterIndex[j];
                        if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                        var condition = value + warnCondition[i].condition;
                        condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                        if (!eval(condition)) continue;
                        return 'color:' + warnCondition[i].color + ';';
                    }
                    // return 'color:transparent;';
                } else {
                    for (var i = 0; i < warnCondition.length; i++) {
                        if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                        var condition = value + warnCondition[i].condition;
                        condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                        if (!eval(condition)) continue;
                        return 'color:' + warnCondition[i].color + ';';
                    }
                }
            },
            formatter: function(value, row, index) {
                if (('' === value) || ('undefined' == typeof value) || isNaN(parseFloat(value))) return value;
                var vsId = bgConfig[row.VSCode],
                    vsNote = row[row.VSCode + '_Measure'];
                if (value.toString().includes('/')) {
                    var values = value.toString().split('/');
                    var string = ""
                    for (var j = 0; j < values.length; j++) {
                        var value = values[j];
                        if (('' === value) || ('undefined' == typeof value) || isNaN(parseFloat(value))) continue;
                        if (j > 0) string += '/';
                        var flag = true;
                        for (var i = 0; i < warnCondition.length; i++) {
                            if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                            var condition = value + warnCondition[i].condition;
                            condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                            if (!eval(condition)) continue;
                            string += '<span style="color:' + warnCondition[i].color + ';">' + value + '</span>';
                            flag = false;
                        }
                        if (flag) string += value;
                    }
                    return string;
                } else {
                    return value;
                }
            }
        });
        columns.push({
            field: 'reminder',
            title: '处理提示',
            formatter: function(value, row, index) {
                value = row.bgValue;
                if ('undefined' == typeof value) return;
                var vsId = bgConfig[row.VSCode];
                if (value.toString().includes('/')) {
                    var values = value.toString().split('/');
                } else {
                    var values = [value];
                }
                for (var j = 0; j < values.length; j++) {
                    var value = values[j];
                    if (('' === value) || ('undefined' == typeof value) || isNaN(parseFloat(value))) continue;
                    for (var i = 0; i < warnCondition.length; i++) {
                        if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                        var condition = value + warnCondition[i].condition;
                        condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                        if (!eval(condition)) continue;
                        return docFlag ? (warnCondition[i].docMeasureDetail || '') : (warnCondition[i].nurseMeasureDetail || '');
                        // return warnCondition[i].criticalReply||'';
                    }
                }
            }
        });
        columns.push({
            field: 'ltma',
            title: '降糖医嘱（长期）',
            formatter: function(value, row, index) {
                if (('' === value) || ('undefined' == typeof value)) return;
                var values = value.toString().split('；');
                var content = "";
                for (var i = 0; i < values.length - 1; i++) {
                    if (row['endDateTimeLong'].split('；')[i].includes(row.date)) {
                        content += '<span style="color: red;">' + values[i] + '；</span>';
                    } else {
                        content += values[i] + '；';
                    }
                }
                return content;
            }
        });
        columns.push({
            field: 'tmo',
            title: '降糖医嘱（临时）',
            formatter: function(value, row, index) {
                if (('' === value) || ('undefined' == typeof value)) return;
                var values = value.toString().split('；');
                var content = "";
                for (var i = 0; i < values.length - 1; i++) {
                    if (row['endDateTimeShort'].split('；')[i].includes(row.date)) {
                        content += '<span style="color: red;">' + values[i] + '；</span>';
                    } else {
                        content += values[i] + '；';
                    }
                }
                return content;
            }
        });
        columns.push({
            field: 'consultStatus',
            title: '会诊状态',
            formatter: function(value, row, index) {
                if (('' === value) || ('undefined' == typeof value)) return;
                if (1 == value) return $g('已提醒');
                if (2 == value) return $g('已申请');
                if (3 == value) return $g('已完成');
            }
        });
        var frozenColumns = [
            { field: "bedCode", title: '床号' },
            { field: "medicareNo", title: '病案号' },
            { field: "name", title: '姓名' },
            // {field: "blankGap", title:'空白占位',hidden:true},
            // {field: 'operate',title:'操作',formatter:function(value, row, index) {
            // 	return '<span class="icon icon-blue-edit" title="开立医嘱" onClick="makeAnOrder('+row.episodeID+');">&nbsp;</span> <span class="icon icon-paper-pen" title="会诊申请" onClick="consultApply('+row.episodeID+');">&nbsp;</span>';
            // }}
        ];
        frozenColumns.push({
            field: 'operate',
            title: '操作',
            formatter: function(value, row, index) {
                console.log(value, row, index);
                var keys = Object.keys(row),
                    obsId = '';
                for (var i = 0; i < keys.length; i++) {
                    if (keys[i].includes('_Id')) {
                        obsId = row[keys[i]];
                        break;
                    }
                }
                var str = "";
                if (0 == parseInt(row.oeordStatus)) str += '<span class="icon icon-doctor-green-pen" title="'+$g('开立医嘱')+'" onClick="makeAnOrder(' + row.episodeID + ',\'' + obsId + '\',\'' + row.date + '\',' + row.personID + ');">&nbsp;</span> ';
                if (!row.consultId) str += '<span class="icon icon-paper-pen" title="'+$g('会诊申请')+'" onClick="consultApply(' + row.episodeID + ',\'' + obsId + '\',\'' + row.date + '\');">&nbsp;</span>';
                if (3 == parseInt(row.consultStatus)) {
                    str += '<span class="icon icon-paste-board" title="'+$g('会诊报告')+'" onClick="consultReport(' + row.episodeID + ',' + row.personID + ',\'' + row.consultId + '\');">&nbsp;</span>';
                }
                if (3 == type.id) { //内分泌虚拟病房
                    if (0 == parseInt(row.consultStatus)) str = '<span class="icon icon-bell-blue" title="'+$g('会诊提醒')+'" onClick="consultReminder(' + row.episodeID + ',\'' + obsId + '\',\'' + row.date + '\',\'' + row.name + '\',event);">&nbsp;</span>';
                    if (1 == parseInt(row.consultStatus)) str = '';
                    if (2 == parseInt(row.consultStatus)) {
                        if (1 == parseInt(row.recvFlag)) {
                            str = '<span class="icon icon-paper-pen" title="'+$g('会诊意见')+'" onClick="consultOpinion(' + row.episodeID + ',\'' + row.consultId + '\');">&nbsp;</span>';
                        } else {
                            str = '';
                        }
                    }
                    if (3 == parseInt(row.consultStatus)) {
                        str = '<span class="icon icon-paste-board" title="'+$g('会诊报告')+'" onClick="consultReport(' + row.episodeID + ',' + row.personID + ',\'' + row.consultId + '\');">&nbsp;</span>';
                    }
                }
                return str;
                // return '<span class="icon icon-blue-edit" title="开立医嘱" onClick="makeAnOrder('+row.episodeID+',\''+obsId+'\',\''+row.date+'\');">&nbsp;</span> <span class="icon icon-paper-pen" title="会诊申请" onClick="consultApply('+row.episodeID+',\''+obsId+'\',\''+row.date+'\');">&nbsp;</span>';
            }
        });

        $('#bloodGlucose').datagrid({
            frozenColumns: [frozenColumns],
            pagination: true,
            columns: [columns],
            data: res,
            pageSize: pageSize,
            onLoadSuccess: function(data) {
                var $td = $("#bloodGlucose").prev().find('.datagrid-body>table tr>td');
                $td.mouseenter(function(event) {
                    var field = $(this).attr('field');
                    // if (!$("#"+field).checkbox('getValue')) return;
                    var rowIndex = $(this).parent().attr('datagrid-row-index');
                    var row = bgData[rowIndex],
                        value = row[field];
                    if (('' === value) || ('undefined' == typeof value)) return;
                    if (('ltma' == field) || ('tmo' == field)) {
                        var flag = 'Long';
                        if ('tmo' == field) flag = 'Short';
                        var values = value.toString().split('；');
                        var content = "";
                        for (var i = 0; i < values.length - 1; i++) {
                            if (i > 0) content += '<br>';
                            content += $g("医嘱名称：") + values[i] + '<br>';
                            content += $g("单次剂量：") + row['bolusDose' + flag].split('；')[i] + '<br>';
                            content += $g("用法：") + $g(row['usage' + flag].split('；')[i]) + '<br>';
                            content += $g("频次：") + row['freq' + flag].split('；')[i] + '<br>';
                            content += $g("开始日期：") + (row['startDateTime' + flag] || '').split('；')[i] + '<br>';
                            content += $g("停止日期：") + (row['endDateTime' + flag] || '').split('；')[i] + '<br>';
                        }
                    } else if ($("#bgConfig #" + field).checkbox('getValue')) {
                        var values = value.toString().split('/');
                        var content = "";
                        for (var i = 0; i < values.length; i++) {
                            if (i > 0) content += '<br>';
                            content += $g("录入时间：") + row.date + '<br>';
                            content += $g("采集时间：") + row[field + '_Time'].split('/')[i] + '<br>';
                            content += $g("血糖值：") + values[i] + 'mmol/L<br>';
                            content += $g("录入人：") + row[field + '_Nurse'].split('/')[i] + '<br>';
                            content += $g("处理措施：") + (row[field + '_Measure'] || '').split('/')[i] + '<br>';
                        }
                    } else {
                        return;
                    }
                    var placement = "bottom";
                    if (rowIndex > 8) placement = "top";
                    $(this).popover({ trigger: 'manual', placement: placement, content: content }).popover('show');
                }).mouseleave(function() {
                    if ($(this) && $(this).popover) {
                        try {
                            $(this).popover('hide');
                        } catch (e) {}
                    }
                });
                updateDomSize();
            }
        }).datagrid("getPager").pagination({
            onSelectPage: function(p, size) {
                page = p;
                pageSize = size;
                if (saveFlag) {
                    console.log(p, size);
                    getBGRecordByDays();
                } else {
                    saveFlag = true;
                }
            },
            onRefresh: function(p, size) {
                console.log(p, size);
                page = p;
                pageSize = size;
                getBGRecordByDays();
            },
            onChangePageSize: function(size) {
                console.log(size);
                page = 1;
                pageSize = size;
                getBGRecordByDays();
            }
        }).pagination('select', page);
    });
}
// 开立医嘱
function makeAnOrder(episodeID, obsId, obsDate,personID) {
    console.log(episodeID);
    console.log(obsId);
    console.log(obsDate);
    console.log(personID);
    if (frm) {
        frm.EpisodeID.value = episodeID;
        frm.PatientID.value = personID;
        frm.mradm.value = parseInt(obsId);
    }
    InitPatInfoBanner(episodeID);
    var innerWidth = window.innerWidth - 50;
    var innerHeight = window.innerHeight - 50;
    $('#retestModal').dialog({
        width: innerWidth,
        height: innerHeight,
    }).dialog("open");
    $HUI.dialog('#retestModal').setTitle('开立医嘱');
    $(".ctcAEPatBar").show();
	var url='oeorder.oplistcustom.new.csp?EpisodeID=' + episodeID + '&mradm=' + episodeID + '&forceRefresh=true&obsId=' + obsId + '&obsDate=' + obsDate;
    if ("undefined" != typeof websys_getMWToken) {
        url += "&MWToken=" + websys_getMWToken();
    }
    $("#retestModal iframe").css({
        'height': 'calc(100% - ' + $("#retestModal .ctcAEPatBar").height() + 'px)',
        'margin-top': '-5px'
    }).attr('src', url);
    var n = 0;
    var timer = setInterval(function() {
        $("#retestModal iframe").css({
            'height': 'calc(100% - ' + $("#retestModal .ctcAEPatBar").height() + 'px)',
        })
        n++;
        if (n > 10) {
            clearInterval(timer);
        }
    }, 100);
}
// 会诊申请
function consultApply(episodeID, obsId, obsDate) {
    console.log(episodeID);
    var innerWidth = window.innerWidth - 50;
    var innerHeight = window.innerHeight - 50;
    $('#retestModal').dialog({
        width: innerWidth,
        height: innerHeight,
    }).dialog("open");
    $HUI.dialog('#retestModal').setTitle('会诊申请');
    $(".ctcAEPatBar").hide();
	var url='dhcem.consultmain.csp?EpisodeID=' + episodeID + '&mradm=' + episodeID + '&forceRefresh=true&obsId=' + obsId + '&obsDate=' + obsDate;
    if ("undefined" != typeof websys_getMWToken) {
        url += "&MWToken=" + websys_getMWToken();
    }
    $("#retestModal iframe").css({
        'height': 'calc(100% - 4px)',
        'margin-top': 0
    }).attr('src', url);
}
// 填写会诊意见
function consultOpinion(episodeID, consultId) {
    console.log(episodeID);
    var innerWidth = window.innerWidth - 50;
    var innerHeight = window.innerHeight - 50;
    $('#retestModal').dialog({
        width: innerWidth,
        height: innerHeight,
    }).dialog("open");
    $HUI.dialog('#retestModal').setTitle('会诊意见');
    $(".ctcAEPatBar").hide();
    var url = 'dhcem.consultquery.csp?EpisodeID=' + episodeID + '&ConsultID=' + consultId;
    if ("undefined" != typeof websys_getMWToken) {
        url += "&MWToken=" + websys_getMWToken();
    }
    console.log(url);
    $("#retestModal iframe").css('height', 'calc(100% - 5px)').attr('src', url);
}
// 会诊报告
function consultReport(episodeID, personID, consultId) {
    console.log(episodeID);
    var innerWidth = window.innerWidth - 50;
    var innerHeight = window.innerHeight - 50;
    $('#retestModal').dialog({
        width: innerWidth,
        height: innerHeight,
    }).dialog("open");
    $HUI.dialog('#retestModal').setTitle('会诊意见');
    $(".ctcAEPatBar").hide();
    if (frm) {
        frm.EpisodeID.value = episodeID;
        frm.PatientID.value = personID;
        console.log(124);
    }
    //  CheckLinkDetails();
    var url = 'dhcem.consultquery.csp?Model=1&ShowType=1&EpisodeID=' + episodeID + '&ConsultID=' + consultId + '&PatientID=' + personID;
    if ("undefined" != typeof websys_getMWToken) {
        url += "&MWToken=" + websys_getMWToken();
    }
    console.log(url);
    $("#retestModal iframe").css('height', 'calc(100% - 5px)').attr('src', url);
}
// 会诊提醒
function consultReminder(episodeID, obsId, obsDate, name, e) {
    console.log(arguments)
    var mainDoc = $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'GetMainDoctorUserID',
        dataType: "text",
        EpisodeID: episodeID
    }, false);
    $cm({
        ClassName: 'websys.DHCMessageInterface',
        MethodName: 'Send',
        Context: $g("请为患者") + name + $g("开立会诊！"),
        ActionTypeCode: 1272,
        FromUserRowId: session["LOGON.USERID"],
        EpisodeId: episodeID,
        OrdItemId: '',
        ToUserRowId: mainDoc
    }, function(data) {
        if (data > 0) {
            $.messager.popover({ msg: $g("会诊提醒消息发送成功！"), type: 'success' });
            //写入记录
            $cm({
                ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
                MethodName: 'AddOrUpdateBGHandleRec',
                episodeID: episodeID,
                obsId: obsId,
                obsDate: obsDate,
                relatedId: '',
                type: 2
            }, function(data) {
                if (data > 0) {
                    $(e.target).hide();
                }
            });
        } else {
            $.messager.popover({ msg: $g("会诊提醒消息发送失败！"), type: 'alert' });
        }
    });
}

// 模态框关闭后事件
$("#retestModal").dialog({
    onClose: getBGRecordByDays
});

function openRetestModal(title) {
    var innerWidth = window.innerWidth - 50;
    var innerHeight = window.innerHeight - 50;
    $('#retestModal').dialog({
        width: innerWidth,
        height: innerHeight,
    }).dialog("open");
    $HUI.dialog('#retestModal').setTitle(title || '血糖');
    console.log(retestObj);
    $("#testDate").datebox('setValue', retestObj.date);
    if (retestObj.verify || !retestObj.time) {
        // 复测血糖，设置默认时间和可编辑
        $("#testTime").timespinner('setValue', (new Date()).toTimeString().slice(0, 5));
    } else {
        $("#testTime").timespinner('setValue', retestObj.time);
    }
    $("#bgValue").val(retestObj.value);
    getObsTableData();
}

function updateDomSize() {
    var innerHeight = window.innerHeight;
    $('#adrsPanel').panel('resize', {
        height: innerHeight - 9
    });
    $('#bloodGlucose').datagrid('resize', {
        height: innerHeight - (($('#_HospList').parents('tr').css('display')=='none')?151:191),
    })
    $('#bgLayout').css({
        height: innerHeight - 145 + 'px'
    }).layout('resize');
}
window.addEventListener("resize", updateDomSize)