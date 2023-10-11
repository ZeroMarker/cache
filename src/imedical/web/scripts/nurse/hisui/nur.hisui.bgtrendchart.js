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
var delimiter = String.fromCharCode(129);
var patNode, saveFlag = true;
var bgConfig = {},
    bgConfigData = []; //血糖配置信息
var myChart, dateformat;
var frm = dhcsys_getmenuform();


$(function() {
// 初始化
    if ((EpisodeID !== "")&&("Y"!=hidePageHeader)) {
        InitPatInfoBanner(EpisodeID)
    }
    // 获取日期格式
    var res = $cm({
        ClassName: 'Nur.NIS.Service.System.Config',
        MethodName: 'GetSystemConfig'
    }, false);
    dateformat = res.dateformat;
    // 获取血糖采集时间配置
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
        QueryName: 'GetBGConfig',
        rows: 999999999999999,
        random: "Y",
        hospDR: session["LOGON.HOSPID"]
    }, function(data) {
        console.log(data);
        data = data.rows;
        data.map(function(e, i) {
            data[i].symbol = e.specialChar.split(delimiter);
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
        bgConfigData = data;
        // if (frm) {
        //     patNode = {
        //         episodeID: frm.EpisodeID.value,
        //         patientID: frm.PatientID.value
        //     }
        //     getInHospDateTime(patNode.episodeID);
        // }
        // if (location.href.includes('EpisodeID=')) {
        //     getInHospDateTime(parseInt(location.href.split('EpisodeID=')[1]));
        // }
        openBGTrendChart();
    });
});
function setBGDateOption(flag) {
    var now = new Date();
    var beginday = $("#startDate").datebox('getValue'),
        finishday = $("#endDate").datebox('getValue');
    var startOpt = $("#startDate").datebox('options'),
        endOpt = $("#endDate").datebox('options');
    if (!beginday || !finishday) return;
    startOpt.maxDate = finishday;
    endOpt.minDate = beginday;
    endOpt.maxDate = endOpt.formatter(now);
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
function openBGTrendChart() {
    $("#startDate").datebox('setValue', startDate);
    $("#endDate").datebox('setValue', endDate);
    var innerWidth = window.innerWidth;
    var innerHeight = window.innerHeight;
    $(".curvePatBar").css('height', $(".curvePatBar .PatInfoItem").height() + 5 + 'px');
    console.log($(".curvePatBar").height());
    var delHeight=("Y"==hidePageHeader)?30:111;
    $("#adrsGradeCurve").css({
        width: innerWidth-23+"px",
        height: innerHeight - delHeight + 'px'
    })
    getBGRecordData();
}
// 获取某些天的血糖记录
function getBGRecordData() {
    var days = [];
    var beginday = ("Y"==hidePageHeader)?startDate:$("#startDate").datebox('getValue'),
        finishday = ("Y"==hidePageHeader)?endDate:$("#endDate").datebox('getValue');
    while ((new Date(standardizeDate(beginday))).valueOf() <= (new Date(standardizeDate(finishday))).valueOf()) {
        days.push(beginday);
        beginday = dateCalculate(new Date(standardizeDate(beginday)), 1);
    }
    var obsDrs = [];
    var keys = Object.keys(bgConfig);
    keys.map(function(e) {
        if (e==parseInt(e)) obsDrs.push(e);
    })
    var episodeId = EpisodeID || (patNode && patNode.episodeID);
    if (!episodeId) return;
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
        MethodName: 'getBGRecordByDays',
        EpisodeIDs: JSON.stringify([episodeId]),
        Dates: JSON.stringify(days),
        ObsDrs: JSON.stringify(obsDrs)
    }, function(data) {
        var series = [],
            legend = [];
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
        // 基于准备好的dom，初始化echarts实例
        if (!myChart) {
            myChart = echarts.init(document.getElementById('adrsGradeCurve'));
        } else {
            myChart.clear();
        }
        var blanks=[];
        console.log($('#adrsGradeCurve').width());
        var len=Math.floor(($('#adrsGradeCurve').width()*26-2092)/285);
        console.log(len);
        for (var i = len; i >= 0; i--) {
            blanks.push(' ');
        }
        // 指定图表的配置项和数据
        var option = {
            title: {
                text: '血糖趋势图'+blanks.join(''),
                x:'right',
                y:'top',
                textAlign:'left',
                padding:[8,0,0,0]
            },
            tooltip: {
                trigger: 'item',
                formatter: function(v, i) {
                    if (!v.data.value[1]) return;
                    var content = "";
                    content += "录入日期：" + v.data.date + '<br>';
                    content += "采集时间：" + v.data.time + '<br>';
                    content += "血糖值：" + v.data.value[1] + 'mmol/L<br>';
                    content += "录入人：" + v.data.nurse + '<br>';
                    return content;
                }
            },
            legend: {
                data: legend,
                x:'center',
                y:'top',
                padding:[35,20,0,0]
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
            xAxis: {
                type: 'time',
                interval: 3 * 3600 * 1000,
                boundaryGap: false,
                axisLabel: {
                    formatter: function(value, index) {
                        var date = new Date(value);
                        return date.toString().split(' ')[4].slice(0, 5);
                    }
                },
                splitLine: {
                    show: false
                }
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

function updateSbgTableSize() {
    // var n = 0;
    // var timer = setInterval(function() {
    //     var innerHeight = window.innerHeight;
    //     $('#adrsPanel').panel('resize', {
    //         height: innerHeight - $(".ctcAEPatBar").height() - 9
    //     });
    //     $('#bloodGlucose').datagrid('resize', {
    //         height: innerHeight - $(".ctcAEPatBar").height() - 110
    //     })
    //     n++;
    //     if (n > 6) {
    //         clearInterval(timer);
    //     }
    // }, 200);
}
window.addEventListener("resize", updateSbgTableSize)