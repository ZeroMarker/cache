var param = "";
var agree=0;
$(document).ready(function() {
			 initParams();
			 initChart();
})

//��ȡ����
function initParams()
{
		param = decodeURI(getParam("params"));
		
}

///��ʼ��ehart
function initChart()
{
	runClassMethod("web.DHCCKBAudit","QueryAudit",{"rows":"30","page":"1","params":param},function(jsonString){
		initheiChart(jsonString)
	},'json','false')	
}

function  initheiChart(data){	

var myChart = echarts.init(document.getElementById('LocCharts'));

var option = {
    color: ['#33FF66', '#006699', '#CC6666', '#e5323e'],
    tooltip: {
        trigger: 'axis',
        axisPointer: {
            type: 'shadow'
        }
    },
    legend: {
        data: ['֪ʶ��ľ���', '������ҩ�Ĳ���', 'ҽԺ�����⾭����ҩ', 'ҽԺ�Ĵ����÷�']
    },
    toolbox: {
        show: true,
        orient: 'vertical',
        left: 'right',
        top: 'center',
        feature: {
            mark: {show: true},
            dataView: {show: true, readOnly: false},
            magicType: {show: true, type: ['line', 'bar', 'stack', 'tiled']},
            restore: {show: true},
            saveAsImage: {show: true}
        }
    },
    xAxis: [
        {
            type: 'category',
            axisTick: {show: false},
            data:data.date
        }
    ],
    yAxis: [
        {
            type: 'value'
        }
    ],
    series: [ 
        {
            name: '֪ʶ��ľ���',
            type: 'bar',
            barGap: 0,
            label: {
					show: true,
					position: 'inside',
					color:'black'
			},
            data:data.ReposNum
        },
        {
            name: '������ҩ�Ĳ���',
            type: 'bar',
            label: {
					show: true,
					position: 'inside',
					color:'black'
			},
            data:data.AnEmpSup
            
        },
        {          
            name: 'ҽԺ�����⾭����ҩ',
            type: 'bar',
            label: {
					show: true,
					position: 'inside',
					color:'black'
			},
            data:data.SpeExpHosp
        },
        {
            name: 'ҽԺ�Ĵ����÷�',
            type: 'bar',
            data:data.WrongHosp,
            label: {
					show: true,
					position: 'inside',
					color:'black'
			},
        }
    ]
}
    
   // ʹ�ø�ָ�����������������ʾͼ��
   myChart.setOption(option);
}
function getParam(paramName){
	
    var paramValue = "";
    var isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1){
        //arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");

        var i = 0;
        while (i < arrSource.length && !isFound){
            if (arrSource[i].indexOf("=") > 0){
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase()){
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        } 
    }
   return paramValue;
}