$(function() {
    $("#btnSave").on("click", MakeBasicCharts)
        // MakeBasicCharts()


});

function MakeBasicCharts() {
    var myChart = echarts.init(document.getElementById('echarts1'));
    var option = {
        title: {
            text: 'TPN分析'
        },
        tooltip: {},
        legend: {},
        radar: {
            indicator: [
                { name: '钠离子', max: 200 },
                { name: '钾离子', max: 200 },
                { name: '镁离子', max: 200 },
                { name: '钙离子', max: 200 },
                { name: '一价阳', max: 200 },
                { name: '二价阳', max: 200 }
            ]
        },
        series: [{
            type: 'radar',
            index: 0,
            data: [{
                    value: [70, 133, 100, 150, 140, 160]
                },
                {
                    value: [10, 133, 100, 150, 140, 160]
                },
                {
                    value: [30, 133, 100, 150, 140, 160]
                }
            ]
        }]
    };
    myChart.setOption(option);
}

function MakeECharts() {
    var myChart = echarts.init(document.getElementById('echarts'));
    option = {
        title: {
            text: '基础雷达图'
        },
        tooltip: { show: true },
        radar: {
            indicator: [
                { name: '苹果', max: 6500 },
                { name: '西瓜', max: 16000 },
                { name: '葡萄', max: 30000 },
                { name: '哈密瓜', max: 38000 },
                { name: '香蕉', max: 52000 },
                { name: '桃', max: 25000 }
            ],
            radius: 200 //半径，可放大放小雷达图 
        },
        series: [{
            //name : '水果', 
            name: '',
            value: '',
            type: 'radar',
            data: []
        }]
    };
    return
    $.ajax({
        url: "dhcpha.pivas.radar.action.csp?action=GetList",
        type: "post",
        dataType: "json",
        async: false,
        cache: false,
        success: function(data) {
            var len = data.rows.length
                /*for(var i=0;i<len;i++){
			    if(data.rows[i].name){
				    var tmp=data.rows[i]
				}
			}*/

            alert(data.rows)
            myChart.setOption({
                series: [{ type: 'radar', data: data.rows }]
            });
        },
        error: function(errorMsg) {
            alert("图表请求数据失败啦!");
            myChart.hideLoading();
            console.log(errorMsg)
        }
    });
}