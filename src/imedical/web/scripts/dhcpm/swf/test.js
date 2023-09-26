//����store  
var chartStore = new Ext.data.JsonStore({  
      root:'data',  
      fields:[  
        {  
          //�ƺ���bug,labelfunction������,���Լ�����һ��field����x���ǩ  
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
  
//��������  
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
  
//��������  
chartStore.loadData(obj);  

var chartWin = new Ext.Window({  
      title:'::��24Сʱ�澯�ֲ�ͼ��::',  
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
          
        //����tip����  
        tipRenderer : function(chart, record){  
          var startTime = record.get('startTime').format('y-m-d H:i');  
          var endTime = record.get('endTime').format('y-m-d H:i');  
          var str = String.format('��ʼʱ��:{0}\n����ʱ��:{1}\n�澯��:{2}\n�¼���:{3}',startTime,endTime,record.get('alarmCount'),record.get('eventCount'))  
          return str;  
        },  
        //��������ͼ��,һ������״ͼ,һ��������ͼ  
        series: [{  
            type: 'column',  
            displayName: '�¼�����',  
            xField: 'label',  
            yField: 'eventCount',  
            style: {  
              color:0x99BBE8,  
              size: 20  
            }  
        },{  
            type:'line',  
            displayName: '�澯',  
            xField: 'label',  
            yField: 'alarmCount',  
            style: {  
              color: 0x15428B  
            }  
        }],  
        //����ͼ����ʽ  
        chartStyle: {  
          //��֪��Ϊɶû�������ͼʾ  
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
 