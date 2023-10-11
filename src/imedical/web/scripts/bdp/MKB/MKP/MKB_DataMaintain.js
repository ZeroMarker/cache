/*
 * @Author: 基础数据平台-范文凯
 * @Date:   2019-08-13 
 * @Last Modified by:   admin
 * @Last Modified time: 2019-08-13 
 * @描述:医用知识库维护数据占比图
 */
var init = function() {
    //调用后台接口，返回值为 “已匹配，未匹配,,,”
    var data = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "GetAllNum");   
    var titlenamearr = data.split(",");
    var loadechart = function(titlenamearr) {
        var myChart = echarts.init(document.getElementById('main'));
        var option = {
            title: {
                text: '各版本ICD结构化匹配占比图',
                x:'center',
                top:50,
                textStyle: {
                    fontSize: '24'
                }
            },
            legend: {
                x:'center',
                padding:[100,0,0,0]
            },
            tooltip: {
                // trigger:'item',
                //formatter: "{a}:({d}%)"
            },
            dataset: {
                source: [
                    ['匹配度', 'ICD-10 v6.01版', 'ICD (2015国家修订版)', 'ICD国家临床版1.1', 'ICD国家临床版2.0'],
                    ['结构化诊断已匹配', titlenamearr[0], titlenamearr[2], titlenamearr[4], titlenamearr[6]],
                    ['结构化诊断未匹配', titlenamearr[1], titlenamearr[3], titlenamearr[5], titlenamearr[7]]
                ]

            },
            series: [{
                type: 'pie',
                radius: 70,
                center: ['25%', '30%'],
                encode: {
                    itemName: '匹配度',
                    value: 'ICD-10 v6.01版'
                },
                name: 'ICD-10 v6.01版',
                label: {
                    normal: {
                        position: 'bottom',
                        formatter: '{a}: ({d}%)',
                        textStyle: {
                            fontSize: 15
                        }
                    }
                }
            }, {
                type: 'pie',
                radius: 70,
                center: ['75%', '30%'],
                encode: {
                    itemName: '匹配度',
                    value: 'ICD (2015国家修订版)'
                },
                name: 'ICD (2015国家修订版)',
                label: {
                    normal: {
                        position: 'bottom',
                        formatter: '{a}: ({d}%)',
                        textStyle: {
                            fontSize: 15
                        }
                    }
                }
            }, {
                type: 'pie',
                radius: 70,
                center: ['25%', '80%'],
                encode: {
                    itemName: '匹配度',
                    value: 'ICD国家临床版1.1'
                },
                name: 'ICD国家临床版1.1',
                label: {
                    normal: {
                        position: 'bottom',
                        formatter: '{a}: ({d}%)',
                        textStyle: {
                            fontSize: 15
                        }
                    }
                }
            }, {
                type: 'pie',
                radius: 70,
                center: ['75%', '80%'],
                encode: {
                    itemName: '匹配度',
                    value: 'ICD国家临床版2.0'
                },
                name: 'ICD国家临床版2.0',
                label: {
                    normal: {
                        position: 'bottom',
                        formatter: '{a}: ({d}%)',
                        textStyle: {
                            fontSize: 15
                        }
                    }
                }
            }]
        };
        myChart.setOption(option, true);
    }
    loadechart(titlenamearr);
}
$(init);