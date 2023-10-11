/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-21 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-08-23 09:11:49
* @描述:医用知识库数据统计
*/
var DATA_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBDataStatistics&pClassMethod=CalAllData";
var init=function()
{
   var columns =[[
        {field:'Type',title:'类别',sortable:true,width:100},
        {field:'PageName',title:'界面名称',sortable:true,width:100},
        {field:'Data',title:'数据总量',sortable:true,width:100},
        {field:'WeekData',title:'本周增长数量',sortable:true,width:100},
        {field:'MonthData',title:'本月增长数量',sortable:true,width:100}
       //{field:'ICDRowId',title:'rowid',sortable:true,width:100,hidden:true},
    ]];
    var datagrid = $HUI.datagrid("#datagrid",{
        //url:DATA_ACTION_URL,
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBDataStatistics",
            QueryName:"CalDataList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'Type',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data)
        {
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onClickRow:function(index,row)
        {  
            loadechart(row.PageName,row.Data)    	
        }		
    });
    /*********************************************折线图*******************************************/
    loadechart=function(nameT,numberT)
    {
        // 基于准备好的dom，初始化echarts图表
        var myChart = echarts.init(document.getElementById("main"));
        var option = {
            title : {
                text: '医用知识库数据统计',
                subtext: '单位/条'
            },
            tooltip : {
                trigger: 'axis'
            },
            legend: {
                //data:['诊断学_临床实用诊断','鉴别诊断']
                data:[nameT]
            },
            //右上角工具条
            toolbox: {
                show : true,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {show: true, type: ['line', 'bar']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    boundaryGap : false,
                    data : ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']
                }
            ],
            yAxis : [
                {
                    type : 'value',
                    axisLabel : {
                        //formatter: '{value} 条'
                        formatter: '{value}'
                    }
                }
            ],
            series : [
                {
                    name:nameT,
                    type:'line',
                    data:[0, 0, 0, 0, 0, 0, 0,numberT,0,0,0,0],
                    markPoint : {
                        data : [
                            {type : 'max', name: '最大值'},
                            {type : 'min', name: '最小值'}
                        ]
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    }
                }/*,
                {
                    name:'鉴别诊断',
                    type:'line',
                    data:[1, -2, 2, 5, 3, 2, 0],
                    markPoint : {
                        data : [
        //                        {name : '周最低', value : -2, xAxis: 1, yAxis: -1.5}
                            {type : 'min', name: '周最低'}
                        ]
                    },
                    markLine : {
                        data : [
                            {type : 'average', name : '平均值'}
                        ]
                    }
                }*/
            ]
        };
        // 为echarts对象加载数据
        myChart.setOption(option);
    }
    loadechart('',0); 
}
$(init);
