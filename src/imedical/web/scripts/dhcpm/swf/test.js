//定义store  
var chartStore = new Ext.data.JsonStore({  
      root:'data',  
      fields:[  
        {  
          //似乎有bug,labelfunction不好用,就自己处理一个field来当x轴标签  
          name:'label',  
          mapping:'endTime',  
          convert:function(v,record){  
            return Date.parseDate(v, 'Y-m-d H:i:s').format('H:i');  
          }  
        },  
        {name:'startTime',type:'date',dateFormat:'Y-m-d H:i:s'},  
        {name:'endTime',type:'date',dateFormat:'Y-m-d H:i:s'},  
        {name:'alarmCount',type:'int'},  
        {name:'eventCount',type:'int'}  
      ],  
      sortInfo:{field: 'startTime', direction: 'ASC'}  
    });  
  
//测试数据  
var obj={  
        startTime:'2009-06-22 01:00:00',  
        endTime:'2009-06-23 01:00:00',  
        interval:60,  
        data:[  
          {startTime:'2009-06-22 01:00:00',endTime:'2009-06-22 02:00:00',alarmCount:02,eventCount:15},  
          {startTime:'2009-06-22 02:00:00',endTime:'2009-06-22 03:00:00',alarmCount:03,eventCount:0},  
          {startTime:'2009-06-22 03:00:00',endTime:'2009-06-22 04:00:00',alarmCount:04,eventCount:15},  
          {startTime:'2009-06-22 04:00:00',endTime:'2009-06-22 05:00:00',alarmCount:15,eventCount:25},  
          {startTime:'2009-06-22 05:00:00',endTime:'2009-06-22 06:00:00',alarmCount:06,eventCount:15},  
          {startTime:'2009-06-22 06:00:00',endTime:'2009-06-22 07:00:00',alarmCount:0,eventCount:20},  
          {startTime:'2009-06-22 07:00:00',endTime:'2009-06-22 08:00:00',alarmCount:0,eventCount:0},  
          {startTime:'2009-06-22 08:00:00',endTime:'2009-06-22 09:00:00',alarmCount:09,eventCount:15},  
          {startTime:'2009-06-22 09:00:00',endTime:'2009-06-22 10:00:00',alarmCount:10,eventCount:15},  
          {startTime:'2009-06-22 10:00:00',endTime:'2009-06-22 11:00:00',alarmCount:11,eventCount:25},  
          {startTime:'2009-06-22 11:00:00',endTime:'2009-06-22 12:00:00',alarmCount:12,eventCount:75},  
          {startTime:'2009-06-22 12:00:00',endTime:'2009-06-22 13:00:00',alarmCount:13,eventCount:12},  
          {startTime:'2009-06-22 13:00:00',endTime:'2009-06-22 14:00:00',alarmCount:14,eventCount:10},  
          {startTime:'2009-06-22 14:00:00',endTime:'2009-06-22 15:00:00',alarmCount:45,eventCount:60},  
          {startTime:'2009-06-22 15:00:00',endTime:'2009-06-22 16:00:00',alarmCount:16,eventCount:25},  
          {startTime:'2009-06-22 16:00:00',endTime:'2009-06-22 17:00:00',alarmCount:17,eventCount:8},  
          {startTime:'2009-06-22 17:00:00',endTime:'2009-06-22 18:00:00',alarmCount:18,eventCount:47},  
          {startTime:'2009-06-22 18:00:00',endTime:'2009-06-22 19:00:00',alarmCount:29,eventCount:35},  
          {startTime:'2009-06-22 19:00:00',endTime:'2009-06-22 20:00:00',alarmCount:20,eventCount:15},  
          {startTime:'2009-06-22 20:00:00',endTime:'2009-06-22 21:00:00',alarmCount:21,eventCount:10},  
          {startTime:'2009-06-22 21:00:00',endTime:'2009-06-22 22:00:00',alarmCount:22,eventCount:5},  
          {startTime:'2009-06-22 22:00:00',endTime:'2009-06-22 23:00:00',alarmCount:53,eventCount:15},  
          {startTime:'2009-06-22 23:00:00',endTime:'2009-06-23 00:00:00',alarmCount:24,eventCount:33},  
          {startTime:'2009-06-23 00:00:00',endTime:'2009-06-23 01:00:00',alarmCount:11,eventCount:0}  
        ]  
      }  
  
//载入数据  
chartStore.loadData(obj);  

var chartWin = new Ext.Window({  
      title:'::近24小时告警分布图表::',  
      layout:'fit',  
      closeAction:'hide',  
      plain: true,  
      height:300,  
      width:1000,  
      items:[{  
        xtype:'linechart',  
        url: 'charts.swf',  
        store:chartStore,  
        //xField: 'label',  
        //yField:'alarmCount',  
          
        //定义tip内容  
        tipRenderer : function(chart, record){  
          var startTime = record.get('startTime').format('y-m-d H:i');  
          var endTime = record.get('endTime').format('y-m-d H:i');  
          var str = String.format('开始时间:{0}\n结束时间:{1}\n告警数:{2}\n事件数:{3}',startTime,endTime,record.get('alarmCount'),record.get('eventCount'))  
          return str;  
        },  
        //定义两个图表,一个是柱状图,一个是折线图  
        series: [{  
            type: 'column',  
            displayName: '事件个数',  
            xField: 'label',  
            yField: 'eventCount',  
            style: {  
              color:0x99BBE8,  
              size: 20  
            }  
        },{  
            type:'line',  
            displayName: '告警',  
            xField: 'label',  
            yField: 'alarmCount',  
            style: {  
              color: 0x15428B  
            }  
        }],  
        //定义图表样式  
        chartStyle: {  
          //不知道为啥没出来这个图示  
          legend:{  
            display: "top"  
          },  
          xAxis: {  
            color: 0x69aBc8,  
            majorTicks: {color: 0x69aBc8, length:4},  
            minorTicks: {color: 0x69aBc8, length: 2},  
            majorGridLines:{size: 1, color: 0xeeeeee}  
          },  
          yAxis: {  
            color: 0x69aBc8,  
            majorTicks: {color: 0x69aBc8, length: 4},  
            minorTicks: {color: 0x69aBc8, length: 2},  
            majorGridLines: {size: 1, color: 0xdfe8f6}  
          }  
        }  
      }]  
    });  
 