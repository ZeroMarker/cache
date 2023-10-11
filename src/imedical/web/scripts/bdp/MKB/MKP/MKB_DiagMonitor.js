/*
* @Author: 基础数据平台-石萧伟
* @Date:   2019-06-24 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2019-06-12 15:41:35
* @描述:开立诊断数据监控
*/
var init=function()
{
    var orign = "User" // 按照什么显示
    var date=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDefaultDate");
    var titlenamearr=date.split("^");//取进一个星期的时间
    var columns =[[
        {field:'Id',title:'用户dr',sortable:true,width:100,hidden:true},
        {field:'Desc',title:'用户',sortable:true,width:100},
        {field:'Freq',title:'诊断次数',sortable:true,width:100}
    ]];
    var datagrid = $HUI.datagrid("#datagrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.SDSStructDiagnosLog",
            QueryName:"GetFreqList",
            datefrom:titlenamearr[0],
            dateto:titlenamearr[1],
            flag:orign
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'Id',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data)
        {
            var pageRows = $('#datagrid').datagrid('getRows');//获取当前页面数据
            console.log(pageRows);
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
            var XData = [];
            var YData = [];
            var ZData = [];
            var total = 0;//显示条数
            for(i = 0 ; i<pageRows.length ; i++){
                XData.push(pageRows[i].Desc);
                YData.push(pageRows[i].Freq);
                ZData.push(pageRows[i].Id);
                total = (total-0) + (pageRows[i].Freq-0)
            }
            loadechart(XData,YData,ZData);
            $('#totaldia').text(total);
        },
        onClickRow:function(index,row)
        {  
            //loadechart(row.PageName,row.Data)    	
        }		
    });
    $("#begin_date").datebox('setValue',titlenamearr[0]); 
	$('#end_date').datebox('setValue', titlenamearr[1]);
    //科室下拉框
    $("#TextType").combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.SDSStructDiagnosLog&QueryName=GetLocForCmb&ResultSetType=array",
        valueField:'locid',
        textField:'locdesc'
    })
    //查询
    $('#btnsearch').click(function(e){
        searchFunLib()

    })
    searchFunLib = function(){
        var begindate = $("#begin_date").datebox('getValue');
        var enddate = $("#end_date").datebox('getValue');
        var locid =  $('#TextType').combobox('getValue')  
        $('#datagrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.SDSStructDiagnosLog",
            QueryName:"GetFreqList",
            locid:locid,
            datefrom:begindate,
            dateto:enddate,
            flag:orign
        });
    }
    $('#onload_btn').click(function(e){
        DownLoadFile();
    })
    //点击下载按钮
    function DownLoadFile()
    {	
        var begindate = $("#begin_date").datebox('getValue');
        var enddate = $("#end_date").datebox('getValue');
        var locid =  $('#TextType').combobox('getValue')  
        var filename = tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnosLog","ExportDiagnosLog",locid,begindate,enddate,orign)        
        if(filename!=""){	
            //$.messager.progress('close');
            $(".load").attr("href","#");
            $(".load").removeAttr("download");
            $(".load").removeAttr("target");	
            filepath ="../scripts/bdp/MKB/DataExport/"+filename;
            $(".load").attr("href",filepath);
            $(".load").attr("download",filename);
            //判断浏览器是否支持a标签 download属性
            var isSupportDownload = 'download' in document.createElement('a');
            if(!isSupportDownload){
                var fileType = filename.split(".")[filename.split(".").length-1];
                if((fileType!="pdf")&&(fileType!="PDF")){
                    objIframe=document.createElement("IFRAME");
                    document.body.insertBefore(objIframe);
                    objIframe.outerHTML=   "<iframe   name=a1   style='width:0;hieght:0'   src="+$(".load").attr("href")+"></iframe>";
                    pic   =   window.open($(".load").attr("href"),"a1");
                    document.all.a1.removeNode(true)
                }else{
                    alert("此浏览器使用另存下载");
                    $(".load").attr("target","_blank");
                }
            }
        }else{
            $.messager.alert("提示","导出失败","error")
            //$.messager.progress('close');
        }

    }
    
    //清屏
    $('#btnrefresh').click(function(e){
        $("#begin_date").datebox('setValue',titlenamearr[0]); 
        $('#end_date').datebox('setValue', titlenamearr[1]);
        $('#TextType').combobox('setValue','')  
        $('#datagrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.SDSStructDiagnosLog",
            QueryName:"GetFreqList",
            locid:'',
            datefrom:titlenamearr[0],
            dateto:titlenamearr[1],
            flag:orign
        });   
    })
     //点击用户
     $('#userbtn').click(function(){
        $('#TextType').combobox('enable')
        typeForSee("User","用户")
     })
    //点击科室
    $('#locbtn').click(function(){
        $('#TextType').combobox('setValue','');
        $('#TextType').combobox('disable')
        typeForSee("Loc","科室")
    })
    var typeForSee = function(ori,desc){
        orign=ori
        var option = $('#datagrid').datagrid("getColumnOption", "Desc")
        option.title = desc;
        //$('#datagrid').datagrid('reload');
        $('#datagrid').datagrid();
        setTimeout(function(){
            searchFunLib();
        },100)
    }
    /****************************************详细数据开始****************************************** */
    //var MKBFlag = 1;
    //var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.MKB.SDSStructDiagnosLog&pClassMethod=GetDiagList&MKBFlag="+MKBFlag;
    var columns =[[
            {field:'SDSRowId',title:'id',width:160,hidden:true},
            {field:'SDSTermDR',title:'termdr',width:160,hidden:true}, 
            {field:'SDSDisplayName',title:'名称',width:150,
                formatter:function(value,row,index){
                    var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                    return content;
                }
            },
            
            {field:'UpdateLocDesc',title:'科室',width:100,
                formatter:function(value,row,index){
                    var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                    return content;
                }       
            },
            {field:'UpdateUserDesc',title:'操作人',width:150,
                formatter:function(value,row,index){
                    var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                    return content;
                }       
            },
            {field:'SDSNotes',title:'备注',width:150,
                formatter:function(value,row,index){
                    var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                    return content;
                }       
            },
            {field:'SDSOnsetDate',title:'发病日期',width:100},
            {field:'SDSOpenDate',title:'开立日期',width:100},
            {field:'SDSCureDate',title:'治愈日期',width:100}, 
            {field:'SDSLinkIcd',title:'关联icd',hidden:true},
            {field:'LinkIcdCode',title:'关联icd编码',width:100},
            {field:'LinkIcdDesc',title:'关联icd描述',width:100},
            {field:'SDSSequence',title:'顺序',width:100,hidden:true},    
            {field:'SDSWordDR',title:'指向术语',width:100,hidden:true},
            {field:'SDSWordDesc',title:'术语',width:100,
                formatter:function(value,row,index){
                    var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                    return content;
                }       
    
            },
            {field:'SDSSupplement',title:'诊断补充信息',width:100}, 
            {field:'SDSTagDR',title:'tagdr',width:50,hidden:true},
            {field:'SDSTag',title:'诊断标记',width:80}  
        ]];
    var detailedgrid = $HUI.datagrid("#detailedgrid",{
        fitColumns:true,//允许表格自动缩放，以适应父容器
        //url: QUERY_ACTION_URL  ,     
        //queryParams:{'MKBFlag':MKBFlag}, 
        //method:'get',
        //ClassTableName:'User.BDPDataChangeLog',
        //SQLTableName:'BDP_DataChangeLog',
        idField:'SDSRowId',
        //dataType: 'json',
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
    var loadechart=function(XData,YData,ZData)
    {
        // 基于准备好的dom，初始化echarts图表
        var myChart = echarts.init(document.getElementById("main"));
        var option = {
            title : {
                text: '开立诊断数据监控',
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
                }
            ]
        };
        // 为echarts对象加载数据
        myChart.setOption(option);
        myChart.on('click',function(params){
            
            var index = params.dataIndex;
            var id = ZData[index];
            var begindate = $("#begin_date").datebox('getValue');
            var enddate = $("#end_date").datebox('getValue');
            var locid =  $('#TextType').combobox('getValue'); //类型
            var name = $.trim(params.name);
            $('#detailed_div').show();	
            var detailediv = $HUI.dialog("#detailed_div",{
                //iconCls:'icon-updatelittle',
                resizable:true,
                title:name+'-'+$('#TextType').combobox('getText')+"共"+params.value+"条",
                modal:true
            });	

            /*options={};
            options.url="../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataChangeLog&pClassMethod=GetList";
            options.queryParams={
                datefrom:begindate,
                dateto:enddate,
                Id:name,
                OperateTypeD: op,
                MKBFlag:'1'
            }*/	
            options={};
			options.url=$URL;
			options.queryParams={
				ClassName:"web.DHCBL.MKB.SDSStructDiagnosLog",
				QueryName:"GetDiagList",
                id:id,
                locid:locid,
                datefrom:begindate,
                dateto:enddate,
                flag:orign
			}	
            $('#detailedgrid').datagrid(options);	
            $('#detailedgrid').prev().find('div.datagrid-body').prop('scrollTop',0);           
        });
    }

}
$(init);
