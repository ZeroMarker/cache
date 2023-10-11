/*
 * @Author: 基础数据平台-范文凯
 * @Date:   2019-08-14 
 * @Last Modified by:   admin
 * @Last Modified time: 2019-08-14
 * @描述:数据处理工厂 糖尿病主要相关诊断频次占比图
 */
var init = function() {
    $('#main').hide();
    //搜索回车事件
    $('#TextGen').keyup(function(event) {
        if (event.keyCode == 13) {
            searchFunLibData();
        }
    });
    //类型查询框
    $("#TextDiaSort").combobox({
        valueField: 'id',
        textField: 'text',
        panelWidth: 150,
        data: [{
            id: '1',
            text: '住院'
        }, {
            id: '2',
            text: '出院'
        }, {
            id: '3',
            text: '门急诊'
        }, {
            id: '4',
            text: '语料库'
        }, {
            id: '5',
            text: '临床用语'
        }, {
            id: '6',
            text: '临床习惯用语'
        }, {
            id: '7',
            text: 'HIS诊断'
        }, {
            id: '9',
            text: '深圳地区术语'
        }, {
            id: '8',
            text: '全部'
        }],
        value: '8',
        onSelect: function(record) {
            searchFunLibData("");
        }
    });
    //查询按钮
    $('#hispartsearch').click(function(e) {
        searchFunLibData("")
    });
    //清屏
    $('#hispartRefresh').click(function(e) {
        clearLeftData();
    });
    //清屏方法
    clearLeftData = function() {
        $('#main').hide();
        $('#div-img').show();
        $('#TextGen').val('');
    };
    //查询方法
    searchFunLibData = function() {
        $('#div-img').hide();
        $('#main').show();
        var diag1 = $('#TextGen').val();
        //调用数据处理工厂的接口，返回值为按频次排好序的诊断。
        $cm({
            ClassName: "web.DHCBL.MKB.MKBStructuredData",
            MethodName: "GetNewList",
            diag: diag1,
            sort: "0",
            match: "A",
            rows: "10",
            page: "1"
        }, function(jsonData) {
            var XData = [];
            var YData = [];
            for (i = 0; i < 8; i++) {
                XData.push(jsonData.rows[i].MKBSDDiag);
                YData.push(jsonData.rows[i].sumloc)
            }
            //取排名第八的诊断的条数，作为入参，调用后台接口，返回值为，剩余诊断的总条数。
            var num = jsonData.rows[7].sumloc;
            var newdata = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "GetDiabetesFreq", diag1, num);
            var titlenamearr = newdata.split(",");
            loadechart(XData, YData, titlenamearr)
        });
    }
    var loadechart = function(XData, YData, titlenamearr) {
        var length = titlenamearr.length
        var myChart = echarts.init(document.getElementById('main'));
        var option = {
            title: {
                text: '开立诊断占比图',
                subtext: '频次前八',
                x: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b}: {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                x: 'left',
                data: [XData[0], XData[1], XData[2], XData[3], XData[4], XData[5], XData[6], XData[7], titlenamearr[length - 2]],
                formatter: function(name) {
                    var index = 0;
                    var clientlabels = [XData[0], XData[1], XData[2], XData[3], XData[4], XData[5], XData[6], XData[7],titlenamearr[length - 2]];
                    var clientcounts = [YData[0], YData[1], YData[2], YData[3], YData[4], YData[5], YData[6], YData[7],titlenamearr[length - 1]];
                    var total = 0;
                    var pct = 0;
                    for (var i = 0; i < clientcounts.length; i++) {
                        total += parseInt(clientcounts[i]);
                    }
                    clientlabels.forEach(function(value, i) {
                        if (value == name) {
                            index = i;
                            pct = (parseInt(clientcounts[index])/total*100).toFixed(2)
                        }
                    });
                    return name + "  " +pct+"%"+" "+"("+clientcounts[index]+")";
                }
            },
            toolbox: {
                show: true,
                feature: {
                    mark: {
                        show: true
                    },
                    dataView: {
                        show: true,
                        readOnly: true
                    },
                    magicType: {
                        show: true,
                        type: ['pie', 'line']
                    },
                    restore: {
                        show: true
                    },
                    saveAsImage: {
                        show: true
                    }
                }
            },
            series: [{
                name: '开立诊断',
                type: 'pie',
                radius: ['53%', '70%'],
                avoidLabelOverlap: false,
                label: {
                    normal: {
                        show: false,
                        position: 'center',
                        formatter: "{b}({d}%)"
                    },
                    emphasis: {
                        show: true,
                        textStyle: {
                            fontSize: '25',
                            fontWeight: 'bold'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        show: false
                    }
                },
                data: [{
                    value: YData[0],
                    name: XData[0]
                }, {
                    value: YData[1],
                    name: XData[1]
                }, {
                    value: YData[2],
                    name: XData[2]
                }, {
                    value: YData[3],
                    name: XData[3]
                }, {
                    value: YData[4],
                    name: XData[4]
                }, {
                    value: YData[5],
                    name: XData[5]
                }, {
                    value: YData[6],
                    name: XData[6]
                }, {
                    value: YData[7],
                    name: XData[7]
                }, {
                    value: titlenamearr[length - 1],
                    name: titlenamearr[length - 2]
                }]         
            }]
        };
        myChart.setOption(option, true);
    }
}
$(init);