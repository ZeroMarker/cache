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
var patNode, saveFlag = true;
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
var myChart, dateformat;
$('#bloodGlucose').datagrid({
    singleSelect: true,
    onClickRow: function(rowIndex, rowData) {
        $(this).datagrid('unselectRow', rowIndex);
    }
});
if ('undefined'==typeof HISUIStyleCode) {
	var HISUIStyleCode="blue";
}
var unfoldFlag = true; //评估项树展开标识
$(function() {
    init();
    if (EpisodeID) {
        patNode = {
            episodeID: EpisodeID
        }
        var inHospDate = $cm({
            ClassName: 'Nur.NIS.Service.Base.Patient',
            MethodName: 'GetInHospDateTime',
            dataType: "text",
            EpisodeID: EpisodeID
        }, false);
        patNode.inHospDate=inHospDate
        selectPatient(0, patNode)
    }
});
$('#wardPatientSearchBox').searchbox({
    searcher: function(value) {
        getBGPatients();
    }
});
// 初始化
function init() {
    // 获取日期格式
    var res = $cm({
        ClassName: 'Nur.NIS.Service.System.Config',
        MethodName: 'GetSystemConfig'
    }, false);
    dateformat = res.dateformat;
    $('#endDate').datebox('setValue', formatDate(new Date()));
    $('#startDate').datebox('setValue', dateCalculate(new Date(), -6));
    var items = [
        { text: $g('本人'), id: '1', selected: true },
        { text: $g('本科'), id: '2' }
    ]
    if (!IsStandardEdition) {
        items.push({ text: $g('内分泌虚拟病房'), id: '3' })
    }
    $("#redkw").keywords({
        singleSelect: true,
        labelCls: 'red',
        items: items,
        onClick: function(v) {
            getBGPatients();
        }
    });
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
        hospDR: session["LOGON.HOSPID"]
    }, function(data) {
        data = data.rows;
        console.log(data);
        bgConfigData = data;
        data.map(function(e) {
            e.VSDesc=$g(e.VSDesc);
            bgConfig[e.VSId] = e;
            bgConfig[e.VSCode] = e.VSId;
            var item = '<td class="r-label"><input class="hisui-checkbox bgItem" type="checkbox"  data-id="' + e.id + '"  data-options="onCheckChange:bgCfgChange" label="' + e.VSDesc + '" id="' + e.VSCode + '"></td>';
            var item1 = '<td class="r-label"><input class="hisui-checkbox bgItem" type="checkbox"  data-id="' + e.id + '"  data-options="onCheckChange:bgCfgChangeModal" label="' + e.VSDesc + '" id="' + e.VSCode + '"></td>';
            $("#bgConfig tr").append(item);
            $("#bgConfigModal tr").append(item1);
            $("#bgConfig tr td:eq(-1) input,#bgConfigModal tr td:eq(-1) input").checkbox({
                label: e.VSDesc,
                value: e.id,
                checked: true
            });
        })
        count++;
    });
    if (!IsStandardEdition) {
        // 获取血糖预警配置
        $cm({
            ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
            QueryName: 'GetBGWarn',
            rows: 999999999999999,
            hospDR: session["LOGON.HOSPID"]
        }, function(data) {
            data = data.rows;
            console.log(data);
            warnCondition = data.filter(function(e) {
                return 'W' == e.type; //取警示的数据
            });
            warnCondition.map(function(e, i) {
                if ('W' == e.type) { //取警示的数据
                    var item = '<span class="severity" onclick="toggleStatus(this,' + i + ');"><i class="dot" style="background: ' + e.color + ';"></i>' + e.name + '</span>';
                    $("#bgWarn tr td:eq(0)").append(item);
                    var detail = '<p><i class="dot" style="background: ' + e.color + ';"></i><span>' + e.variableDesc + ' ' + e.docMeasureDetail + '</span></p>';
                    $("#bgWarn .helpDetail").append(detail);
                }
            })
            if ($("#bgWarn .helpDetail>p").length<4) {
                $("#bgWarn .helpDetail").addClass('short');
            } else {
                $("#bgWarn .helpDetail").removeClass('short');
            }
            count++;
        });
    } else {
        count++;
    }
    var timer = setInterval(function() {
        if (count > 1) {
            clearInterval(timer);
            getBGPatients();
            if (!IsShowPatList) getBGRecordByDays();
        }
    }, 30);
	if ('lite'==HISUIStyleCode) { //极简
		$('.eduExeStyle').append('#bgWarn tr td span {height: 16px;vertical-align: top;}');
		$('.eduExeStyle').append('body{background-color: #f5f5f5;}');
	}
	if (IsShowPatList) {
		$('.eduExeStyle').append('.ctcContent{width: calc(100% - 450px)!important;}');
	}
}
// 获取测过血糖的病人
function getBGPatients() {
    if (!IsShowPatList) return;
    var type = $("#redkw").keywords('getSelected')[0];
    console.log(type);
    var keyword = $('#wardPatientSearchBox').searchbox('getValue');
    saveFlag = false;
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'getBGPatients',
        Type: type.id,
        keyword: keyword,
        page: page,
        pageSize: pageSize,
        hospDR: session["LOGON.HOSPID"]
    }, function(res) {
        $('#patients').datagrid({
            data: res,
            pageSize: pageSize
        }).datagrid("getPager").pagination({
            onSelectPage: function(p, size) {
                page = p;
                pageSize = size;
                if (saveFlag) {
                    console.log(p, size);
                    getBGPatients();
                } else {
                    saveFlag = true;
                }
            },
            onRefresh: function(p, size) {
                console.log(p, size);
                page = p;
                pageSize = size;
                getBGPatients();
            },
            onChangePageSize: function(size) {
                console.log(size);
                page = 1;
                pageSize = size;
                getBGPatients();
            }
        }).pagination('select', page);;
    });
}
function selectPatient(index, row) {
    console.log($('#endDate'));
    $('#endDate').datebox('setValue', formatDate(new Date()));
    var inHospDate = row.inHospDate.split(' ')[0] || dateCalculate(new Date(), -6);
    var halfYearAgo = dateCalculate(new Date(), -6);
    var startOpt = $("#startDate").datebox('options');
    startOpt.minDate = inHospDate;
    var day = inHospDate;
    if (new Date(standardizeDate(inHospDate)) < new Date(standardizeDate(halfYearAgo))) {
        day = halfYearAgo;
    }
    $('#startDate').datebox('setValue', day);
    var episodeId = row.episodeID;
    if(IsShowPatInfoBannner) InitPatInfoBanner(episodeId);
    // $('.patframe').attr('src','websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.Banner&PatientID='+row.personID+'&EpisodeID='+row.episodeID);
    getBGRecordByDays();
}
// 设置日期选择框禁用值
function setDateboxOption(flag) {
    var now = new Date();
    var startDate = $("#startDate").datebox('getValue'),
        endDate = $("#endDate").datebox('getValue');
    if (1 == flag) {
        var halfYearLate = formattingDate(dateCalculate(new Date(standardizeDate(startDate)), 183));
        if (halfYearLate < endDate) {
            $("#endDate").datebox('setValue', halfYearLate)
            endDate = halfYearLate;
        }
    } else {
        var halfYearAgo = formattingDate(dateCalculate(new Date(standardizeDate(endDate)), -6));
        if (halfYearAgo > startDate) {
            $("#startDate").datebox('setValue', halfYearAgo)
            startDate = halfYearAgo;
        }
    }
    var startOpt = $("#startDate").datebox('options'),
        endOpt = $("#endDate").datebox('options');
    if (!startDate || !endDate) return;
    startOpt.maxDate = endDate;
    endOpt.minDate = startDate;
    endOpt.maxDate = endOpt.formatter(now);
}

function bgCfgChange(e, v) {
    console.log(arguments);
    if (v) {
        bgConfigData.map(function(e) {
            v = v && $("#bgConfig #" + e.VSCode).checkbox('getValue');
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
            $("#bgConfig #" + e.VSCode).checkbox('setValue', v);
        })
        timeouter = setTimeout(function() {
            saveFlag = true;
        }, 300);
        getBGRecordByDays();
    }
}

function bgCfgChangeModal(e, v) {
    console.log(arguments);
    if (v) {
        bgConfigData.map(function(e) {
            v = v && $("#bgConfigModal #" + e.VSCode).checkbox('getValue');
        })
    }
    if (saveFlag) {
        getBGRecordData();
    }
    saveFlag = false;
    $("#bgConfigModal #checkAll").checkbox('setValue', v);
    timeouter = setTimeout(function() {
        saveFlag = true;
    }, 50);
}

function checkAllBGModal(e, v) {
    if (saveFlag) {
        saveFlag = false
        bgConfigData.map(function(e) {
            $("#bgConfigModal #" + e.VSCode).checkbox('setValue', v);
        })
        timeouter = setTimeout(function() {
            saveFlag = true;
        }, 300);
        getBGRecordData();
    }
}
// 切换选中的状态
function toggleStatus(obj, i) {
    console.log(arguments);
    var pbgColor = $(obj).css('background-color'),
        cbgColor = $(obj).find('i').css('background-color');
    console.log(pbgColor);
    console.log(cbgColor);
    if ('rgb(255, 255, 255)' == pbgColor) {
        $(obj).css({
            background: cbgColor,
            color: pbgColor
        }).find('i').css('background', pbgColor);
        filterIndex.push(i);
    } else {
        $(obj).css({
            background: cbgColor,
            color: 'black'
        }).find('i').css('background', pbgColor);
        filterIndex.splice(filterIndex.indexOf(i), 1);
    }
    console.log(filterIndex);
    getBGRecordByDays();
}
// 标准化日期
function standardizeDate(day) {
    var y = dateformat.indexOf('YYYY');
    var m = dateformat.indexOf('MM');
    var d = dateformat.indexOf('DD');
    var str = day.slice(y, y + 4) + '/' + day.slice(m, m + 2) + '/' + day.slice(d, d + 2);
    return str;
}
// 格式化日期
function formattingDate(day) {
    var s = dateformat || 'YYYY-MM-DD';
    var y = s.indexOf('YYYY');
    var m = s.indexOf('MM');
    var d = s.indexOf('DD');
    s = s.replace('YYYY', day.substr(y, 4));
    s = s.replace('MM', day.substr(m, 2));
    s = s.replace('DD', day.substr(d, 2));
    return s;
}
// 获取某些天的血糖记录
function getBGRecordByDays() {
    var episodeId=IsShowPatList?'':EpisodeID;
    var days = [];
    var startDate = $("#startDate").datebox('getValue'),
        endDate = $("#endDate").datebox('getValue');
    // while((new Date(standardizeDate(startDate))).valueOf()<=(new Date(standardizeDate(endDate))).valueOf()){
    //    days.push(startDate);
    //    startDate=formattingDate(dateCalculate(new Date(standardizeDate(startDate)), 1));
    // }
    while ((new Date(standardizeDate(startDate))).valueOf() <= (new Date(standardizeDate(endDate))).valueOf()) {
        days.push(endDate);
        endDate = formattingDate(dateCalculate(new Date(standardizeDate(endDate)), -1));
    }
    var obsDrs = [];
    var keys = Object.keys(bgConfig);
    keys.map(function(e) {
        var v = $("#bgConfig #" + bgConfig[e].VSCode).checkbox('getValue');
        if (v) obsDrs.push(e);
    })
    if (!episodeId) {
        episodeId = $('#patients').datagrid('getSelected').episodeID;
        if (!episodeId) return;
    }
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'getBGRecordByDays',
        EpisodeIDs: JSON.stringify([episodeId]),
        Dates: JSON.stringify(days),
        ObsDrs: JSON.stringify(obsDrs),
        DocFlag: 'Y'
    }, function(data) {
        if (filterIndex.length) { //过滤
            for (var k = 0; k < data.length; k++) {
                var d = data[k],
                    flag = true;
                for (var m = 0; m < bgConfigData.length; m++) {
                    var vscode = bgConfigData[m].VSCode,
                        vsId = bgConfigData[m].VSId;
                    var value = d[vscode];
                    if (('' === value) || ('undefined' == typeof value) || isNaN(parseFloat(value))) continue;
                    var values = value.toString().split('/');
                    for (var n = 0; n < values.length; n++) {
                        value = values[n];
                        for (var j = 0; j < filterIndex.length; j++) {
                            var i = filterIndex[j];
                            if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                            var condition = value + warnCondition[i].condition;
                            condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                            if (!eval(condition)) continue;
                            flag = false;
                            break;
                        }
                    }
                }
                if (flag) {
                    data.splice(k, 1);
                    k--;
                }
            }
        }
        bgData = JSON.parse(JSON.stringify(data));
        var columnWidth = 130;
        columns = [{ field: "date", title: '日期' }]
        bgConfigData.map(function(e) {
            var v = $("#bgConfig #" + e.VSCode).checkbox('getValue');
            if (v) {
                var title = $g(e.VSDesc);
                if (e.startTime&&e.showTime) {
                    title += "<br>" + e.startTime + "~" + e.endTime;
                }
                columns.push({
                    field: e.VSCode,
                    title: title,
                    width: 100,
                    editor: { type: 'text' },
                    styler: function(value, row, index) {
                        if (('' === value) || ('undefined' == typeof value) || isNaN(parseFloat(value))) return;
                        if (value.toString().includes('/')) value = parseFloat(value);
                        var vsId = bgConfig[e.VSCode];
                        if (filterIndex.length) {
                            for (var j = 0; j < filterIndex.length; j++) {
                                var i = filterIndex[j];
                                if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                                var condition = value + warnCondition[i].condition;
                                condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                                if (!eval(condition)) continue;
                                return 'color:' + warnCondition[i].color + ';';
                            }
                            return 'color:transparent;';
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
                        var vsId = bgConfig[e.VSCode],
                            vsNote = row[e.VSCode + '_Measure'];
                        if (value.toString().includes('/')) {
                            console.log(value);
                            var values = value.toString().split('/');
                            var string = ""
                            var len = values.length - 1;
                            var cnt = 0,
                                againFlag = 0;
                            for (var j = 0; j <= len; j++) {
                                var value = values[j];
                                if (('' === value) || ('undefined' == typeof value) || isNaN(parseFloat(value))) continue;
                                var flag = true;
                                if (filterIndex.length && !againFlag) {
                                    for (var k = 0; k < filterIndex.length; k++) {
                                        var i = filterIndex[k];
                                        if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                                        var condition = value + warnCondition[i].condition;
                                        condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                                        if (!eval(condition)) continue;
                                        if (j < len) {
                                            string += '<span style="color:' + warnCondition[i].color + ';">' + value + '/</span>';
                                        } else {
                                            string += '<span style="color:' + warnCondition[i].color + ';">' + value + '</span>';
                                        }
                                        flag = false;
                                        cnt++;
                                    }
                                }
                                if (!filterIndex.length || againFlag) {
                                    for (var i = 0; i < warnCondition.length; i++) {
                                        if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                                        var condition = value + warnCondition[i].condition;
                                        condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                                        if (!eval(condition)) continue;
                                        if (j < len) {
                                            string += '<span style="color:' + warnCondition[i].color + ';">' + value + '/</span>';
                                        } else {
                                            string += '<span style="color:' + warnCondition[i].color + ';">' + value + '</span>';
                                        }
                                        flag = false;
                                    }
                                    if (flag) {
                                        if (j < len) {
                                            string += '<span style="color:black;">' + value + '/</span>';
                                        } else {
                                            string += '<span style="color:black;">' + value + '</span>';
                                        }
                                    }
                                }
                                if (cnt > 0) {
                                    j = -1;
                                    againFlag = 1
                                    string = "";
                                    cnt = 0;
                                }
                            }
                            return string;
                        } else {
                            var flag = true;
                            if (filterIndex.length) {
                                for (var k = 0; k < filterIndex.length; k++) {
                                    var i = filterIndex[k];
                                    if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                                    var condition = value + warnCondition[i].condition;
                                    condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                                    if (!eval(condition)) continue;
                                    // if (('Y' == warnCondition[i].retestFlag) && !value.toString().includes('/')) {
                                    //     var str = '<a href="javascript:void(0);" name="retestBG" data-id="' + row[e.VSCode + '_Id'] + '" data-vscode="' + e.VSCode + '" data-index="' + i + '" class="easyui-linkbutton" ></a>'
                                    //     return value + str;
                                    // }
                                    flag = false;
                                }
                            } else {
                                for (var i = 0; i < warnCondition.length; i++) {
                                    if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
                                    var condition = value + warnCondition[i].condition;
                                    condition = condition.replace(/\|\|/g, '||' + value).replace(/\&\&/g, '&&' + value)
                                    if (!eval(condition)) continue;
                                    // if (('Y' == warnCondition[i].retestFlag) && !value.toString().includes('/')) {
                                    //     var str = '<a href="javascript:void(0);" name="retestBG" data-id="' + row[e.VSCode + '_Id'] + '" data-vscode="' + e.VSCode + '" data-index="' + i + '" data-rowindex="' + index + '" class="easyui-linkbutton" ></a>'
                                    //     return value + str;
                                    // }
                                    flag = false;
                                }
                            }
                            return value;
                        }
                    }
                });
                var num = 0;
                data.map(function(el) {
                    if ('RBS' == e.VSCode) {
                        if ('undefined' != typeof el['RBS']) {
                            num += el['RBS'].toString().split('/').length;
                        }
                    } else {
                        if ('undefined' != typeof el[e.VSCode]) num++;
                    }
                })
            }
        })
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
        $('#bloodGlucose').datagrid({
            columns: [columns],
            data: { total: data.length, rows: data },
            onLoadSuccess: function(data) {
                // $("a[name='retestBG']").map(function(index, elem) {
                //     var id = $(this).data('id'),
                //         vscode = $(this).data('vscode'),
                //         index = $(this).data('index'),
                //         rowindex = $(this).data('rowindex');
                //     $(elem).linkbutton({ plain: true, size: 'small', onClick: retestBG(id, vscode, index, rowindex), iconCls: 'icon-verify' });
                // });
                var $td = $("#bloodGlucose").prev().find('.datagrid-body>table tr>td');
                $td.mouseenter(function(event) {
                    var field = $(this).attr('field');
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
                            content += $g("用法：") + row['usage' + flag].split('；')[i] + '<br>';
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
                            if (values[i]==parseFloat(values[i])) {
                                content += $g("血糖值：") + values[i] + 'mmol/L<br>';
                            } else {
                                content += $g("血糖值：") + values[i] + '<br>';
                            }
                            content += $g("录入人：") + row[field + '_Nurse'].split('/')[i] + '<br>';
                            if (!IsStandardEdition) {
                                content += $g("处理措施：") + (row[field + '_Measure'] || '').split('/')[i] + '<br>';
                            }
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
            }
        });
    });
}

function retestBG(tmpId, tmpCode, tmpIndex, tmpRowIndex) {
    var id = tmpId,
        vscode = tmpCode,
        index = tmpIndex,
        rowindex = tmpRowIndex;
    return function() {
        showRetestModal(id, vscode, index, rowindex, 'Y');
    }
}

function showRetestModal(id, vscode, i, rowindex, verifyFlag) {
    console.log(arguments);
    console.log(bgData);
    var spliter = String.fromCharCode(13);
    measures = warnCondition[i].nurseMeasureDetail.split(spliter);
    if (measures.length) {
        $("#measure").empty();
        measures.map(function(e) {
            var item = '<input class="hisui-checkbox measureItem" type="checkbox" label="' + e + '" id="' + e + '">';
            $("#measure").append(item);
            $("#measure input:eq(-1)").checkbox({
                label: e,
                value: e,
                checked: false
            });
        })
    }
    retestObj = {
        retestFlag: warnCondition[i].retestFlag,
        itemDr: bgConfig[vscode],
        episodeID: parseInt(id),
        verify: verifyFlag,
        date: bgData[rowindex - 1].date,
    }
    console.log(retestObj);
    openRetestModal("复测血糖");
}
// 保存血糖记录
function saveBGData(index) {
    var allRow = $('#bloodGlucose').datagrid('getRows');
    console.log(allRow);
    for (var i = 1; i < allRow.length; i++) {
        $('#bloodGlucose').datagrid('endEdit', i);
    }
    //取修改过的行集合
    var rows = $('#bloodGlucose').datagrid('getChanges');
    console.log(rows);
    console.log(bgData);
    var data = [];
    for (var i = 0; i < rows.length; i++) {
        for (var j = 0; j < bgData.length; j++) {
            if (rows[i].date == bgData[j].date) {
                var keys = Object.keys(rows[i]);
                for (var k = 0; k < keys.length; k++) {
                    if (rows[i][keys[k]] !== bgData[j][keys[k]]) {
                        var vsId = bgConfig[keys[k]];
                        if (!vsId) continue;
                        var value = rows[i][keys[k]]; //血糖值
                        console.log(value);
                        // 校验血糖值
                        if ('' !== value) {
                            if (!value || (parseFloat(value) != value)) {
                                return $.messager.popover({ msg: $g("血糖值只能输入数字！"), type: 'alert' });
                            }
                            if ((parseFloat(value) < parseFloat(bgConfig[vsId].errorLow)) || (parseFloat(value) > parseFloat(bgConfig[vsId].errorHigh))) {
                                return $.messager.popover({ msg: $g("血糖值超出错误值范围！"), type: 'alert' });
                            }
                        }
                        data.push({
                            itemDr: vsId,
                            value: value,
                            episodeID: rows[i].episodeID,
                            date: rows[i].date,
                            rowId: rows[i][keys[k] + '_Id'] || ''
                        });
                    }
                }
            }
        }
    }
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'saveSingleVitalSign',
        dataType: "text",
        data: JSON.stringify(data[0])
    }, function(data) {
        if (parseInt(data) >= 0) {
            getBGRecordByDays();
            $.messager.popover({ msg: $g("保存成功！"), type: 'success' });
        } else {
            $.messager.popover({ msg: $g("保存失败！"), type: 'alert' });
        }
    });
}
// 模态框关闭后事件
$("#retestModal").dialog({
    onClose: getBGRecordByDays
});

function openRetestModal(title) {
    $('#retestModal').dialog("open");
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

function saveObsRow() {
    if ((!retestObj.rowId) && (($('#obsTable').datagrid('getRows').length > 1) && ('RBS' != bgConfig[retestObj.itemDr].VSCode))) {
        return $.messager.popover({ msg: $g("请选中行编辑！"), type: 'alert' });
    }
    retestObj.time = $("#testTime").timespinner('getValue');
    if (!retestObj.time) {
        return $.messager.popover({ msg: $g("请选择时间！"), type: 'alert' });
    }
    var value = $("#bgValue").val();
    // 校验血糖值
    if ('' !== value) {
        if (!value || (parseFloat(value) != value)) {
            return $.messager.popover({ msg: $g("血糖值只能输入数字！"), type: 'alert' });
        }
        if ((parseFloat(value) < parseFloat(bgConfig[retestObj.itemDr].errorLow)) || (parseFloat(value) > parseFloat(bgConfig[retestObj.itemDr].errorHigh))) {
            return $.messager.popover({ msg: $g("血糖值超出错误值范围！"), type: 'alert' });
        }
    }
    retestObj.value = value;
    var m = [];
    measures.map(function(e) {
        if ($("#bgConfig #" + e).checkbox('getValue')) m.push(e);
    })
    // 校验措施是否必选
    if (('Y' == retestObj.retestFlag) && !m.length) {
        return $.messager.popover({ msg: $g("请选择处理措施！"), type: 'alert' });
    }
    retestObj.note = m.join(';');
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'saveSingleVitalSign',
        dataType: "text",
        data: JSON.stringify(retestObj)
    }, function(data) {
        if (parseInt(data) >= 0) {
            getObsTableData();
            $.messager.popover({ msg: $g("保存成功！"), type: 'success' });
        } else {
            $.messager.popover({ msg: $g("保存失败！"), type: 'alert' });
        }
    });
}

function clearObsRow() {
    var elObj = $('#obsTable');
    var rows = elObj.datagrid('getRows');
    if (!rows.length) return $.messager.popover({ msg: '无数据可清空！', type: 'alert' });
    var delIDs = [],
        reminder = "";
    reminder = $g("是否要清空以下数据？");
    rows.map(function(e) {
        delIDs.push(e.Id);
    });
    $.messager.confirm($g("删除"), reminder, function(r) {
        if (r) {
            $cm({
                ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
                MethodName: 'delVitalSign',
                dataType: "text",
                IDs: JSON.stringify(delIDs)
            }, function(data) {
                console.log(data);
                if (0 == data) {
                    $.messager.popover({ msg: $g('清空成功！'), type: 'success' });
                    getObsTableData()
                    retestObj.rowId = "";
                    $("#bgValue").val('');
                    $("#measure input").checkbox('setValue', false);
                    retestObj.verify = '';
                } else {
                    $.messager.popover({ msg: data, type: 'alert' });
                }
            });
        }
    });
}

function removeObsRow() {
    var elObj = $('#obsTable');
    var row = elObj.datagrid('getSelected');
    if (!row) return $.messager.popover({ msg: $g('请先选择要删除的行！'), type: 'alert' });
    var rows = elObj.datagrid('getRows');
    var delIDs = [],
        reminder = "";
    if (("RBS" == row.vsCode) || ('Y' == row.retest)) {
        delIDs.push(row.Id);
        reminder = $g("确定要删除选中的数据？");
    } else {
        reminder = $g("删除原始血糖值（若有复测血糖也将同步删除），是否继续？");
        rows.map(function(e) {
            delIDs.push(e.Id);
        });
    }
    $.messager.confirm($g("删除"), reminder, function(r) {
        if (r) {
            $cm({
                ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
                MethodName: 'delVitalSign',
                dataType: "text",
                IDs: JSON.stringify(delIDs)
            }, function(data) {
                console.log(data);
                if (0 == data) {
                    $.messager.popover({ msg: $g('删除成功！'), type: 'success' });
                    getObsTableData()
                    retestObj.rowId = "";
                    $("#bgValue").val('');
                    $("#measure input").checkbox('setValue', false);
                    retestObj.verify = '';
                } else {
                    $.messager.popover({ msg: data, type: 'alert' });
                }
            });
        }
    });
}

function selectObsRow(index, row) {
    retestObj.verify = row.retest || '';
    retestObj.rowId = row.Id;
    $("#testTime").timespinner('setValue', row.Time); //赋值
    $("#bgValue").val(row.value);
    $("#measure input").checkbox('setValue', false);
    notes = row.Note ? row.Note.split(';') : [];
    notes.map(function(e) {
        $("#" + e).checkbox('setValue', true);
    })
}

function getObsTableData() {
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'getBGRecordByDayAndObsDr',
        episodeID: retestObj.episodeID,
        date: retestObj.date,
        obsDr: retestObj.itemDr
    }, function(data) {
        data.map(function (d,i) {
          var measures=d.Measure.split(';');
          measures.map(function (m,j) {
            measures[j]=$g(m);          
          })
          data[i].Measure=measures.join(";");
        });
        $('#obsTable').datagrid('loadData', data);
    });
}

function openBGTrendChart() {
    $("#assessStartDate").datebox('setValue', $("#startDate").datebox('getValue'))
    $("#assessEndDate").datebox('setValue', $("#endDate").datebox('getValue'))
    var innerWidth = window.innerWidth - 100;
    var innerHeight = window.innerHeight - 100;
    $('#adrsCurveModal').dialog({
        width: innerWidth,
        height: innerHeight,
    }).dialog("open");
    $("#adrsGradeCurve").css({
        width: innerWidth - 23 + "px",
        height: innerHeight - ('lite'==HISUIStyleCode?141:145) - 40 + 'px'
    })
    getBGRecordData();
}
// 获取某些天的血糖记录
function getBGRecordData() {
    var days = [];
    var startDate = $("#assessStartDate").datebox('getValue'),
        endDate = $("#assessEndDate").datebox('getValue');
    while ((new Date(standardizeDate(startDate))).valueOf() <= (new Date(standardizeDate(endDate))).valueOf()) {
        days.push(startDate);
        startDate = dateCalculate(new Date(standardizeDate(startDate)), 1);
    }
    var obsDrs = [];
    var keys = Object.keys(bgConfig);
    keys.map(function(e) {
        var v = $("#bgConfigModal #" + bgConfig[e].VSCode).checkbox('getValue');
        if (v) obsDrs.push(e);
    })
    var episodeId = EpisodeID||$('#patients').datagrid('getSelected').episodeID;
    if (!episodeId) return;
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'getBGRecordByDays',
        EpisodeIDs: JSON.stringify([episodeId]),
        Dates: JSON.stringify(days),
        ObsDrs: JSON.stringify(obsDrs),
        DocFlag: 'Y'
    }, function(data) {
        var series = [], legend = [];
        var trendType=parseInt($('input[name="trendType"]:checked').val());
        if (trendType) {
            for (var i = 0; i < data.length; i++) {
              var v = data[i], dayData = [];
              var keys = Object.keys(v);
              keys.map(function (k) {
                if (k.includes("_Time")) {
                  var code = k.split("_Time")[0];
                  var vsDesc = bgConfig[bgConfig[code]].VSDesc;
                  if (legend.indexOf(vsDesc)<0) {
                    legend.push(vsDesc);
                    series.push({
                      name: vsDesc,
                      code: code,
                      type: 'line',
                      connectNulls: true,
                      // areaStyle: {},
                      emphasis: {
                        focus: 'series'
                      },
                      data: []
                    })
                  }
                  for (var j = 0; j < series.length; j++) {
                    if (code==series[j].code) {
                      // series[j].data[i]=v[code];
                        if (v[code].indexOf('/')<0) {
                            series[j].data[i]={
                            time: v[k],
                            nurse: v[code+'_Nurse'],
                            value:v[code]
                            };
                        } else {
                            var times=v[k].split('/');
                            var values=v[code].split('/');
                            series[j].data[i]={
                            times: v[k],
                            time: times[times.length-1],
                            nurse: v[code+'_Nurse'],
                            values:v[code],
                            value:values[values.length-1]
                            };
                        }
                      break;
                    }
                  }
                }
              });
            }
            var vsDescs=[];
            bgConfigData.map(function (b) {
              vsDescs.push(b.VSDesc);
            })
            // dayData = 
            legend.sort(function (a, b) {
              return vsDescs.indexOf(a) - vsDescs.indexOf(b);
            });
            series.push({
              type:'line',
              markLine:{
                silent:'true', //图形是否不响应和触发鼠标事件，默认为 false，即响应和触发鼠标事件
                data:[{
                  yAxis:16.6
                }],
                label:{
                  show:true,
                  color:'black',
                  fontSize:14,
                  formatter:16.6
                },
                lineStyle:{
                  color:'red',
                  // type:"scrollDataIndex"
                },
              }
            });
            series.push({
              type:'line',
              markLine:{
                silent:'true', //图形是否不响应和触发鼠标事件，默认为 false，即响应和触发鼠标事件
                data:[{
                  yAxis:3.9
                }],
                label:{
                  show:true,
                  color:'black',
                  fontSize:14,
                  formatter:3.9
                },
                lineStyle:{
                  color:'blue',
                  // type:"scrollDataIndex"
                },
              }
            });
        } else {
            for (var i = 0; i < data.length; i++) {
                var v = data[i],
                    dayData = [];
                legend.push(v.date);
                var keys = Object.keys(v);
                keys.map(function(k) {
                    if (k.includes('_Time')) {
                        var code = k.split('_Time')[0];
                        if (v[code].includes('/')) {
                            var values = v[code].split('/');
                            for (var j = 0; j < values.length; j++) {
                                var time = v[k].split('/')[j];
                                dayData.push({
                                    date: v.date,
                                    time: time,
                                    value: ['2021-03-13 ' + time, values[j]],
                                    nurse: v[code + '_Nurse'].split('/')[j]
                                })
                            }
                        } else {
                            dayData.push({
                                date: v.date,
                                time: v[k],
                                value: ['2021-03-13 ' + v[k], v[code]],
                                nurse: v[code + '_Nurse']
                            })
                        }
                    }
                })
                dayData = dayData.sort(function(a, b) {
                    return new Date(a.value[0]).valueOf() - new Date(b.value[0]).valueOf()
                })
                series.push({
                    name: v.date,
                    type: 'line',
                    connectNulls: true,
                    data: dayData
                })
            }
            series.unshift({
                name: '',
                type: 'line',
                data: [{
                    date: '',
                    time: '00:00',
                    value: ['2021-03-13 00:00', 3.9],
                    nurse: ''
                }],
                markLine: {
                    data: [
                        { type: 'average', name: '' }
                    ],
                    lineStyle: {
                        // type:'solid',
                        color: {
                            type: 'linear',
                            x: 0,
                            y: 0,
                            x2: 0,
                            y2: 1,
                            colorStops: [{
                                offset: 0,
                                color: 'blue' // 0% 处的颜色
                            }, {
                                offset: 1,
                                color: 'blue' // 100% 处的颜色
                            }]
                        }
                    }
                }
            });
            series.push({
                name: '',
                type: 'line',
                data: [{
                    date: '',
                    time: '24:00',
                    value: ['2021-03-13 23:59', 16.6],
                    nurse: ''
                }],
                markLine: {
                    data: [
                        { type: 'average', name: '' }
                    ],
                    lineStyle: {
                        // type:'solid',
                        color: {
                            type: 'linear',
                            x: 0,
                            y: 0,
                            x2: 0,
                            y2: 1,
                            colorStops: [{
                                offset: 0,
                                color: 'red' // 0% 处的颜色
                            }, {
                                offset: 1,
                                color: 'red' // 100% 处的颜色
                            }]
                        }
                    }
                }
            });
        }
        // 基于准备好的dom，初始化echarts实例
        // $("#adrsGradeCurve").empty();
        if (!myChart) {
            myChart = echarts.init(document.getElementById('adrsGradeCurve'));
        } else {
            myChart.clear();
        }
        var blanks = [];
        console.log($('#adrsGradeCurve').width());
        var len = Math.floor(($('#adrsGradeCurve').width() * 26 - 2092) / 285);
        console.log(len);
        var chartTitle=$g("血糖趋势图");
        for (var i = len+(5-chartTitle.length)/2; i >= 0; i--) {
            blanks.push(' ');
        }
        // 指定图表的配置项和数据
        var option = {
            title: {
                text: chartTitle + blanks.join(''),
                x: 'right',
                y: 'top',
                textAlign: 'left',
                padding: [8, 0, 0, 0]
            },
            tooltip: {
                trigger: 'item',
                formatter: function(v, i) {
                    if (trendType) {
                      if (!v.data) return;
                      var content = "";
                      content += $g("录入日期：") + v.name + "<br>";
                      content += $g("采集时间：") + (v.data.times||v.data.time) + "<br>";
                      if (v.value == parseFloat(v.value)) {
                        content += $g("血糖值：") + (v.data.values||v.value) + "mmol/L<br>";
                      } else {
                        content += $g("血糖值：") + v.value + "<br>";
                      }
                      content += $g("录入人：") + v.data.nurse + "<br>";
                      return content;
                    } else {
                      if (!v.data.value[1]) return;
                      var content = "";
                      content += $g("录入日期：") + v.data.date + "<br>";
                      content += $g("采集时间：") + v.data.time + "<br>";
                      if (v.data.value[1] == parseFloat(v.data.value[1])) {
                        content += $g("血糖值：") + v.data.value[1] + "mmol/L<br>";
                      } else {
                        content += $g("血糖值：") + v.data.value[1] + "<br>";
                      }
                      content += $g("录入人：") + v.data.nurse + "<br>";
                      return content;
                    }
                }
            },
            legend: {
                data: legend,
                x: 'center',
                y: 'top',
                padding: [35, 20, 0, 0]
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            toolbox: {
                feature: {
                    saveAsImage: {}
                }
            },
            xAxis: trendType?{
              type: 'category',
              boundaryGap: false,
              data: days
            }:{
              type: "time",
              interval: 3 * 3600 * 1000,
              boundaryGap: false,
              axisLabel: {
                formatter: function (value, index) {
                  var date = new Date(value);
                  return date.toString().split(" ")[4].slice(0, 5);
                },
              },
              splitLine: {
                show: false,
              },
            },
            yAxis: {
                type: 'value',
                min: 0.0,
                max: 22.2,
                data: [0, 3.9, 7, 10, 13.9, 16.6, 22.2],
                splitLine: {
                    lineStyle: {
                        color: "#d9d9d9",
                        width: 0.8,
                        opacity: 0.4
                    }
                }
            },
            series: series
        };
        // 使用刚指定的配置项和数据显示图表。
        console.log(JSON.stringify(option));
        myChart.setOption(option);
    });
}

function updateDomSize() {
    var innerHeight = window.innerHeight;
    $('#patientList').panel('resize', {
        height: innerHeight - 93
    });
    $('#adrsPanel').panel('resize', {
        height: innerHeight -(IsShowPatInfoBannner?49:9)
    });
    $('#patients').datagrid('resize', {
        height: innerHeight - 78
    })
    var height = innerHeight -(IsShowPatInfoBannner?40:0)- (IsStandardEdition ? 121 : 160);
    console.log(IsStandardEdition);
    console.log(height);
    if ($('#bloodGlucose').length) {
        setTimeout(function() {
            $('#bloodGlucose').datagrid('resize', {
                height: height
            })
        }, 300);
    }
}
window.addEventListener("resize", updateDomSize)