/*
* @Author: 基础数据平台-石萧伟
* @Date:   2019-06-12 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2019-06-12 15:41:35
* @描述:医用知识库数据监控
*/
var init=function()
{
    var date=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDefaultDate");
    var titlenamearr=date.split("^");//取进一个星期的时间
    var NameData = [];
    var columns =[[
        {field:'Name',title:'用户',sortable:true,width:100},
        {field:'Num',title:'数据量',sortable:true,width:100}
    ]];
    var datagrid = $HUI.datagrid("#datagrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBDataMonitor",
            MethodName:"GetList",
            start:titlenamearr[0],
            end:titlenamearr[1]
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'Name',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data)
        {
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
            var XData = [];
            var YData = [];
            for(i = 0 ; i<data.rows.length ; i++){
                XData.push(data.rows[i].Name);
                YData.push(data.rows[i].Num)
            }
            NameData = XData;
            loadechart(XData,YData)
        },
        //单击后，获取该用户的Name，作为入参，调用后台方法，返回该用户时间范围内每一天的数据量，然后加载Echarts--fwk
        onClickRow: function(index) {
            var UserName = NameData[index]
            //alert(UserName)
            var begindate = $("#begin_date").datebox('getValue');
            var op = $('#TextType').combobox('getValue');
            var enddate = $("#end_date").datebox('getValue');
            
            //var UserName = "Demo Group";
            var data = tkMakeServerCall("web.DHCBL.MKB.MKBEChartsInterface", "NumInterface", op, UserName, begindate, enddate);
            var titlenamearr1 = data.split(" ");
            var X1Data = [];
            var Y1Data = [];
            var length = (titlenamearr1.length) / 2
            for (i = 0; i < length; i++) {
                X1Data.push(titlenamearr1[i]);
                Y1Data.push(titlenamearr1[length + i]);
            }
            loadnewechart(X1Data, Y1Data) //loadechart(row.PageName,row.Data)      */ //fwk添加
        }		
    });
    $("#begin_date").datebox('setValue',titlenamearr[0]); 
	$('#end_date').datebox('setValue', titlenamearr[1]);
    //类型下拉框
    $("#TextType").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'',text:'全部'},
            {id:'A',text:'新增'},
            {id:'U',text:'修改'},
            {id:'D',text:'删除'}
        ],
        value:''
    })
    //查询
    $('#btnsearch').click(function(e){
        var begindate = $("#begin_date").datebox('getValue');
        var enddate = $("#end_date").datebox('getValue');
        if ((begindate>enddate)&&(enddate!="")&&(begindate!=""))
         {
            $.messager.alert('错误提示','开始日期需小于结束日期!','error');
            return;
         }
        var op =  $('#TextType').combobox('getValue')  
        $('#datagrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBDataMonitor",
            MethodName:"GetList",
            start:begindate,
            end:enddate,
            op:op
        });

    })
    //清屏
    $('#btnrefresh').click(function(e){
        $("#begin_date").datebox('setValue',titlenamearr[0]); 
        $('#end_date').datebox('setValue', titlenamearr[1]);
        $('#TextType').combobox('setValue','')  
        $('#datagrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBDataMonitor",
            MethodName:"GetList",
            start:titlenamearr[0],
            end:titlenamearr[1]
        });     
    })


    /****************************************详细数据开始****************************************** */
    var MKBFlag = 1;
    var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataChangeLog&pClassMethod=GetList&MKBFlag="+MKBFlag;
    var columns =[[
            {field:'ClassNameDesc',title:'功能描述',width:160},
            {field:'TableName',title:'表名称',width:160,hidden:true}, 
            {field:'ClassName',title:'类名称',width:180,hidden:true},
            {field:'ObjectReference',title:'对象ID',width:80,hidden:true},
            {field:'ObjectDesc',title:'对象描述',width:150}, 
            {field:'UpdateUserName',title:'操作人',width:50,hidden:true},
            {field:'OperateType',title:'操作类型',width:50,
                formatter:function(v,row,index){  
                      if(v=='A'){return '添加';}
                      if(v=='U'){return '修改';}
                      if(v=='D'){return '删除';}
                  }}, 
            {field:'IpAddress',title:'操作人IP',width:120,hidden:true}, 
            {field:'UpdateUserDR',title:'操作人ID',width:80,hidden:true},
            {field:'UpdateDate',title:'操作日期',width:100},
            {field:'UpdateTime',title:'操作时间',width:100}, 
            {field:'ID',title:'ID',hidden:true}
        ]];
    var detailedgrid = $HUI.datagrid("#detailedgrid",{
        fitColumns:true,//允许表格自动缩放，以适应父容器
        //url: QUERY_ACTION_URL  ,     
        //queryParams:{'MKBFlag':MKBFlag}, 
        //method:'get',
        ClassTableName:'User.BDPDataChangeLog',
        SQLTableName:'BDP_DataChangeLog',
        idField:'ID',
        dataType: 'json',
        fixRowNumber:true, //列号 自适应宽度
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        pagination:true,//分页控件  
        singleSelect:true,
        columns:columns  ,
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
            $(this).datagrid('columnMoving');
        },
        onClickRow:function(rowIndex,row)
        {
        },
        onDblClickRow:function(rowIndex, field, value)
        {         
        }, 
	});

    /****************************************详细数据结束***************************************** */
    /*********************************************折线图*******************************************/
    var loadechart=function(XData,YData)
    {
        // 基于准备好的dom，初始化echarts图表
        var myChart = echarts.init(document.getElementById("main"));
        var option = {
            title : {
                text: '医用知识库数据监控',
                subtext: '单位/条'
            },
            tooltip : {
                trigger: 'axis',       axisPointer: {
                    type: 'cross',
                    label: {
                        backgroundColor: '#283b56'
                    }
                }
            },
            legend: {
                //data:['诊断学_临床实用诊断','鉴别诊断']
                data:['数据量']
            },
            //右上角工具条
            toolbox: {
                show : true,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {show: true, type: ['bar', 'line']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    boundaryGap : true,
                    data : XData,
                    axisLabel:{
                        interval:0
                    }
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
                    name:'数据量',
                    type:'bar',
                    data:YData,
                    /*markPoint : {
                        data : [
                            {type : 'max', name: '最大值'},
                            {type : 'min', name: '最小值'}
                        ]
                    },*/
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    },
                    itemStyle: {
                        normal: {
                            color:'#40a2de',
                            label: {
                                show: true, //开启显示
                                position: 'top', //在上方显示
                                textStyle: { //数值样式
                                    color: 'black',
                                    fontSize: 16
                                }
                            }
                        }
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
        myChart.on('click',function(params){
            //console.log(params.value)
            
            var begindate = $("#begin_date").datebox('getValue');
            var enddate = $("#end_date").datebox('getValue');
            var op =  $('#TextType').combobox('getValue'); //类型
            var name = $.trim(params.name);
            $('#detailed_div').show();	
            var detailediv = $HUI.dialog("#detailed_div",{
                iconCls:'icon-w-paper',
                resizable:true,
                title:name+'-'+$('#TextType').combobox('getText')+"共"+params.value+"条",
                modal:true
            });	

            options={};
            options.url="../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataChangeLog&pClassMethod=GetList";
            options.queryParams={
                datefrom:begindate,
                dateto:enddate,
                UserDR:name,
                OperateTypeD: op,
                MKBFlag:'1'
            }	
            
            $('#detailedgrid').datagrid(options);	
            $('#detailedgrid').prev().find('div.datagrid-body').prop('scrollTop',0); 
            /*$('#detailedgrid').datagrid('load',  { 
                datefrom:begindate,
                dateto:enddate,
                UserDR:name,
                OperateTypeD: op
            });*/            
        });
    }
    // fwk add*************************每日维护数据图开始***************************************************
    var loadnewechart = function(X1Data, Y1Data) {
        var myChart = echarts.init(document.getElementById("main1"));
        option = {
            title: {
                text: '用户数据维护变化监控',
                subtext: '单位/条'
            },
            legend: {
                data: ['数据量']
            },
            tooltip: {
                trigger: 'axis'
            },
            xAxis: {
                type: 'category',
                data: X1Data,
                /*axisLabel:{
                    interval:0,
                    rotate:40
                }*/
            },
            yAxis: {
                type: 'value'
            },
            series: [{
                name: '数据量',
                data: Y1Data,
                type: 'line',
                smooth: true,
                markLine: {
                    data: [{
                        type: 'average',
                        name: '平均值'
                    }]
                },
                itemStyle: {
                    normal: {
                        color:'#40a2de',
                        label: {
                            show: true, //开启显示
                            position: 'top', //在上方显示
                            textStyle: { //数值样式
                                color: 'black',
                                fontSize: 16
                            }
                        }
                    }
                }
            }]
        };
        myChart.setOption(option);
    };
}
$(init);
