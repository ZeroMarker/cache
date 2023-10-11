/**
 * ģ��:     ��Һ��������ͼ
 * ��д����: 2019-10-28
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];

$(function () {
    $("#dateStart").datebox("setValue", "t-30");
    $("#dateEnd").datebox("setValue", "t");
    $("#btnFind").on("click", Query);
    $(".dhcpha-win-mask").remove();
});

function Query() {
    var inputStr = SessionLoc + "^" + $("#dateStart").datebox("getValue") + "^" + $("#dateEnd").datebox("getValue");
    var tabTitleCode = $('#tabsOne').tabs('getSelected').panel('options').code;
    var className = "";
    var queryName = "";
    var eChartId = "";
    if (tabTitleCode == "������") {
        className = "web.DHCSTPIVAS.Charts.LinePS60";
        queryName = "QueryDateCnt";
        eChartId = "eChartPS60";
    } else if (tabTitleCode == "��ҩ��") {
        className = "web.DHCSTPIVAS.Charts.LineReturn";
        queryName = "QueryDateCnt"; 
        eChartId ="eChartReturn";
    } else if (tabTitleCode == "�����޸���") {
        className = "web.DHCSTPIVAS.Charts.LinePS3";
        queryName = "QueryDateCnt";   
        eChartId = "eChartPS3";
    }
    $.cm({
        ClassName: className,
        QueryName: queryName,
        InputStr: inputStr,
        ResultSetType: "array"
    }, function (retData) {

        // ת��Ϊechart����
        var xAxisData = [];
        var seriesData = [];
        var dataLen = retData.length;
        if (dataLen > 0) {
            $("#"+eChartId).removeClass("pha-pivas-no-data")
            var lineHtml='<div id="'+eChartId+"Chart"+'" style="width:100%;height:100%"></div>'
            $("#"+eChartId).html(lineHtml);
            for (var i = 0; i < dataLen; i++) {
                var data = retData[i];
                var xAxisVal = data.cnt;
                var seriesVal = data.calcuDate;
                xAxisData.push(xAxisVal);
                seriesData.push(seriesVal);
            }
            ShowEChart({
                xAxisData: xAxisData,
                seriesData: seriesData
            }, eChartId+"Chart");
        }else{
            $("#"+eChartId).html("");
            $("#"+eChartId).addClass("pha-pivas-no-data")
        }
    })
}

function ShowEChart(eData, eId) {
    var myChart = echarts.init(document.getElementById(eId));
    option = {
        tooltip : {
            trigger: 'axis',
            axisPointer: {
                type: 'cross',
                label: {
                    backgroundColor: '#6a7985'
                }
            }
        },
        xAxis: {
            type: 'category',
            data: eData.seriesData,
            axisLabel: {
                interval: 0,
                formatter: function (value) {
                    //x������ָ�Ϊ������ʾ
                    if (value.indexOf("/")>=0){
                        return value.split("/")[1] + "\n" + value.split("/")[0];
                    }
                    return value.split("-")[1] + "\n" + value.split("-")[2];
                }
            }
        },
        yAxis: {
            minInterval: 1,
            type: 'value'
        },
        series: [{
            data: eData.xAxisData,
            type: 'line',
            markLine: {
                data: [{
                    type: 'average',
                    name: 'ƽ��ֵ'
                }]
            }
        }]
    };
    myChart.setOption(option);

}
