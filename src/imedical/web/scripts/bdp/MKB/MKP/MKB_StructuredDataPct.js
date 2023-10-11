/*
 * @Author: 基础数据平台-范文凯
 * @Date:   2019-08-13 
 * @Last Modified by:   admin
 * @Last Modified time: 2019-08-13 
 * @描述:医用知识库数据处理工厂数据占比图
 */
var init = function() {
    //数据来源后台方法生成数组
    var hosArrary = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "ArrayForKeyWords");
    var hosArr = hosArrary.split("^");
    /*var array = new Array()
    for (var i=0;i<hosArr.length;i++){
        var ObjStr =  hosArr[i]
        ObjStr = eval('('+ ObjStr +')');
        array.push(ObjStr)
        //console.log('ObjStr')
    }
    console.log(array)*/
    var hosArr = eval('(' + hosArr + ')');
    //alert(hosArr)
    //数据来源关键字
    $('#datasource').keywords({
        singleSelect: true,
        labelCls: 'blue',
        items: [{
            text: "数据来源",
            type: "chapter",
            items: hosArr
        }],
        onClick: function(item) {
            //console.log(item.id);
            var data = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "GetSDDataNum" ,item.id);
            var titlenamearr = data.split(",");
            var data1 = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "Test",item.id);
            var titlenamearr1 = data1.split(",");
            loadechart(titlenamearr);
            loadechart2(titlenamearr1);
        }
    })
    /*//数据来源下拉框.combobox
    $('#datasource').combobox({
        url: $URL + "?ClassName=web.DHCBL.MKB.MKBEChartsInterface&QueryName=DataSource&ResultSetType=array",
        valueField: 'ID',
        textField: 'MKBSTBDesc',
        //mode:'remote',
        panelWidth: 165,
        value: '1',
    });
    //下拉框内容改变时触发事件
    $('#datasource').combobox({
        onSelect: function(value) {
            var data = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "GetSDDataNum" ,value.ID);
            var titlenamearr = data.split(",");
            var data1 = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "Test",value.ID);
            var titlenamearr1 = data1.split(",");
            loadechart(titlenamearr);
            loadechart2(titlenamearr1);
        }
    });*/
    //调用后台接口， 返回值为“value，value，value” 三个类型的数值
    var data = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "GetSDDataNum", hosArr[0].id);
    var titlenamearr = data.split(",");
    var data1 = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "Test", hosArr[0].id);
    var titlenamearr1 = data1.split(",");
    //图1 
    loadechart = function(titlenamearr) {
        var myChart = echarts.init(document.getElementById('main'));
        var option = {
            backgroundColor: '#FFFFFF',
            title: {
                text: '结构化诊断占比图',
                left: 'center',
                top: 20,
                textStyle: {
                    color: '#282C34'
                }
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                left: 'right',
                data: ['结构化诊断未匹配', 'ICD编码未匹配', '全匹配'],
                padding:[30,100,0,0]
            },
            series: [{
                name: '本地医学知识库',
                type: 'pie',
                radius: '55%',
                center: ['50%', '50%'],
                data: [{
                    value: titlenamearr[0],
                    name: '结构化诊断未匹配'
                }, {
                    value: titlenamearr[1],
                    name: 'ICD编码未匹配'
                }, {
                    value: titlenamearr[2],
                    name: '全匹配'
                }].sort(function(a, b) {
                    return a.value - b.value;
                }),
                label: {
                    normal: {
                        formatter: "{b} : {c} ({d}%)",
                        textStyle: {
                            color: 'rgba(0, 0, 0, 0.8)',
                            fontSize: '15'
                        }
                    }
                },
                itemStyle: {
                    emphasis: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }]
        };
        myChart.setOption(option, true);
    }
    //图2
    loadechart2 = function(titlenamearr) {
        var myChart = echarts.init(document.getElementById('main1'));
        var option = {
            backgroundColor: '#FFFFFF',
            title: {
                text: '结构化诊断个数占比图',
                left: 'center',
                top: 20,
                textStyle: {
                    color: '#282C34'
                }
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                left: 'right',
                data: ['结构化诊断1对1', '结构化诊断1对2', '结构化诊断1对3', '其他'],
                padding:[30,100,0,0]
            },
            series: [{
                name: '本地医学知识库',
                type: 'pie',
                radius: '55%',
                center: ['50%', '60%'],
                data: [{
                    value: titlenamearr[0],
                    name: '结构化诊断1对1'
                }, {
                    value: titlenamearr[1],
                    name: '结构化诊断1对2'
                }, {
                    value: titlenamearr[2],
                    name: '结构化诊断1对3'
                }, {
                    value: titlenamearr[3],
                    name: '其他'
                }],
                label: {
                    normal: {
                        formatter: "{b} : {c} ({d}%)",
                        textStyle: {
                            color: 'rgba(0, 0, 0, 0.8)',
                            fontSize: '15'
                        }
                    }
                },
                itemStyle: {
                    emphasis: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }]
        };
        myChart.setOption(option, true);
    }
    //
    loadechart(titlenamearr);
    loadechart2(titlenamearr1);
}
$(init);