/*
 * @Author: 基础数据平台-范文凯
 * @Date:   2019-08-19
 * @Last Modified by:   admin
 * @Last Modified time: 2019-08-19
 * @描述:数据处理工厂 每条诊断短语结构化结果条数
 */
var init = function() {
    //调用后台接口，返回值为(value,,,)1对1，1对2，1对3，以及其他的条数
    var data = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "Test");
    var titlenamearr = data.split(",");
    var loadechart = function(titlenamearr) {
        var myChart = echarts.init(document.getElementById('main1'));
        option = {
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
                left: 'left',
                data: ['结构化诊断1对1', '结构化诊断1对2', '结构化诊断1对3', '其他']
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
    loadechart(titlenamearr);
}
$(init);