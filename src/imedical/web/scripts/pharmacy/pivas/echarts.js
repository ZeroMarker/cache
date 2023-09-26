$(function() {
    $("#btnSave").on("click", MakeBasicCharts)
        // MakeBasicCharts()


});

function MakeBasicCharts() {
    var myChart = echarts.init(document.getElementById('echarts1'));
    var option = {
        title: {
            text: 'TPN����'
        },
        tooltip: {},
        legend: {},
        radar: {
            indicator: [
                { name: '������', max: 200 },
                { name: '������', max: 200 },
                { name: 'þ����', max: 200 },
                { name: '������', max: 200 },
                { name: 'һ����', max: 200 },
                { name: '������', max: 200 }
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
            text: '�����״�ͼ'
        },
        tooltip: { show: true },
        radar: {
            indicator: [
                { name: 'ƻ��', max: 6500 },
                { name: '����', max: 16000 },
                { name: '����', max: 30000 },
                { name: '���ܹ�', max: 38000 },
                { name: '�㽶', max: 52000 },
                { name: '��', max: 25000 }
            ],
            radius: 200 //�뾶���ɷŴ��С�״�ͼ 
        },
        series: [{
            //name : 'ˮ��', 
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
            alert("ͼ����������ʧ����!");
            myChart.hideLoading();
            console.log(errorMsg)
        }
    });
}