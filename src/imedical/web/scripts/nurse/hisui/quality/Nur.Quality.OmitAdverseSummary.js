var summaryChart;
$(function() {
    initUI()
})

function initUI(){

    initSearchForm();  //初始化查询
    initGrid();        //初始化表格
    initLinkWindow(); //初始化关联的窗口
    initCharsWindow(); //初始化图表弹框
}

function initSearchForm()
{

    function filter(q, row) {
        var opts = $(this).combobox('options');
        var text = row[opts.textField];
        var pyjp = getPinyin(text).toLowerCase();
        if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
            return true;
        }
        return false;
    }

    //上报查询时间
    $('#startDate').datebox('setValue', (new Date()).before(3).Format("yyyy-MM-dd"))
    $('#endDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))

    //关联状态
    $('#summaryType').combobox({
        valueField: 'value',
        textField: 'label',
        data: [{
            label: $g('按病区'),
            value: 'W',
            selected:true  
        },{
            label: $g('按事件'),
            value: 'E'
        }],
        onSelect:function(record){
            var selectValue = record.value
            if (selectValue == "W")
            {
                $('#summaryDataTable').datagrid("hideColumn","event")
                $('#summaryDataTable').datagrid("showColumn","wardDesc").datagrid("getColumnOption", "wardDesc").title = $g("病区");
                $('#summaryDataTable').datagrid();
                $('#summaryEventRange').combobox("setValues","")
                $('#summaryLoc').css("display","block")
                $('#summaryEvent').css("display","none")

            }else if(selectValue == "E")
            {
                $('#summaryDataTable').datagrid("hideColumn","wardDesc")
                $('#summaryDataTable').datagrid("showColumn","event").datagrid("getColumnOption", "event").title = $g("事件");
                $('#summaryDataTable').datagrid();
                $('#summaryRange').combobox("setValues","")
                $('#summaryLoc').css("display","none")
                $('#summaryEvent').css("display","block")
            }
            searchBtn_click()
        }
    })


    /**上报科室 */
    $('#summaryRange').combobox({
        valueField: 'ID',
        textField: 'desc',
        multiple: true,
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getLocs&parameter1=W&parameter2='+session['LOGON.HOSPID']+"&parameter3=Nur_IP_Quality.OmitAdverseConfig",
        filter: filter,
        onLoadSuccess: function (params) {
	        // $(this).combobox('setValues', [session['LOGON.CTLOCID']])
            // $(this).combobox('setValue', session['LOGON.CTLOCID'])
        }
    })

     /**事件 */
     $('#summaryEventRange').combobox({
        valueField: 'id',
        textField: 'desc',
        multiple: true,
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getEventListInterface&parameter1=',
        filter: filter,
    })


    $('#searchBtn').on("click",function(){
        searchBtn_click()
    })
    
    $('#resetBtn').on("click",function(){
        $('#summaryRange').combobox("setValues",[])
        $('#summaryEventRange').combobox("setValues",[])
    })




}

function initGrid()
{
    $('#summaryDataTable').datagrid({
        url: $URL,
        queryParams:{
            ClassName: 'Nur.Quality.Service.OmitAdverse',
            QueryName: 'getOmitAdverseSummaryList',
            StartDate: $('#startDate').datebox('getValue'),
            EndDate: $('#endDate').datebox('getValue'),
            Type: $('#summaryType').combobox('getValue'),
            Range: JSON.stringify($('#summaryRange').combobox('getValues')),
            HospId: session['LOGON.HOSPID']
        },
        method: 'post',
        loadMsg: $g("数据装载中......"),
        nowrap: false,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'wardDesc', title: '病区', width: 110, align:'left', hidden:false },
            { field: 'event', title: '事件', width: 110, align:'left',hidden: true, },
            { field: 'suspectNum', title: '疑似数', width: 70, align:'left'},
            { field: 'reportNum', title: '上报数', width: 120, align:'left' },
            { field: 'difference', title: '差值', width: 80, align:'left' },
            { field: 'linkNum', title: '已关联组', width: 80, align:'left' },
            { field: 'allID', title: 'allID', width: 80, align:'left',hidden:true },
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        toolbar:[
        {
            iconCls: 'icon-img',
            text: $g("图表"),
            style: {
                'margin': '0px'
            },
            handler: function() {
              $('#summaryCharts').window("open")
            }
        }],
        onLoadSuccess: function(data){
            var rows = data.rows

            var option = {
                legend: {},
                tooltip: {},
                dataset: {
                    dimensions: ['product', $g("预警值"), $g("上报值")],
                    source: []
                },
                xAxis: {type: 'category'},
                yAxis: {},
                series: [
                    {type: 'bar'},
                    {type: 'bar'}
                ]
            };

            // {product: 'Matcha Latte', '2015': 43.3, '2016': 85.8, '2017': 93.7},
            // {product: 'Milk Tea', '2015': 83.1, '2016': 73.4, '2017': 55.1},
            // {product: 'Cheese Cocoa', '2015': 86.4, '2016': 65.2, '2017': 82.5},
            // {product: 'Walnut Brownie', '2015': 72.4, '2016': 53.9, '2017': 39.1}

            for (var index=0, length=rows.length; index < length; index++)
            {
                var single = {}
                single["product"] = rows[index].wardDesc
                single[$g("预警值")] = rows[index].suspectNum
                single[$g("上报值")] = rows[index].reportNum
                option.dataset.source.push(single)
            }
        
            summaryChart.setOption(option);
        },
        onClickRow: function(rowIndex, rowData){
            //debugger
            if ($('#panel').layout('panel','east').panel("options").collapsed)
            {
                $('#panel').layout('expand','east');
            }
            detailShow(rowData.allID)
        }
    })



    $('#summaryDetailTable').datagrid({
        loadMsg: $g("数据装载中......"),
        nowrap: false,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'wardDesc', title: '病区', width: 130, align:'left' },
            { field: 'regNo', title: '登记号', width: 90, align:'left' },
            { field: 'bedCode', title: '床号', width: 50, align:'left'},
            { field: 'patName', title: '姓名', width: 80, align:'left' },
            { field: 'sex', title: '性别', width: 50, align:'left' },
            { field: 'age', title: '年龄', width: 50, align:'left' },
            { field: 'event', title: '事件', width: 80, align:'left' },
            { field: 'suspectDateTime', title: '疑似发生时间', width: 120, align:'left' },
            { field: 'reportDateTime', title: '事件上报时间', width: 120, align:'left' },
            { field: 'consumeTime', title: '耗时', width: 50, align:'left' },
            { field: 'omitID', title: 'omitID', width: 50, align:'left',hidden:true },
            { field: 'eventID', title: 'eventID', width: 50, align:'left',hidden:true },
            { field: 'episodeID', title: 'episodeID', width: 50, align:'left',hidden:true },
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        toolbar: '#tb',
        // toolbar:[{
        //     iconCls: 'icon-export',
        //     text: '导出',
        //     handler: function() {

        //     }
        // }, 
        // {
        //     iconCls: 'icon-paper-link',
        //     text: '手动关联',
        //     handler: function() {
              
        //     }
        // }],
    })

    $('#summaryDetailType').combobox({
        valueField: 'value',
        textField: 'label',
        data: [{
            label: $g("全部"),
            value: 'A'
        },{
            label: $g("已关联"),
            value: 'Y'
        },{
            label: $g("未关联"),
            value: 'N'
        }],
        onSelect:function(record){
            var selectValue = record.value
            var queryParams = $('#summaryDetailTable').datagrid("options").queryParams
            queryParams.Type = $("#summaryDetailType").combobox("getValue")
            $('#summaryDetailTable').datagrid("options").queryParams = queryParams
    		$('#summaryDetailTable').datagrid("load")
        }
    })


    $('#linkBtn').on("click",function(){
        var selectRow = $('#summaryDetailTable').datagrid('getSelected')
        if (selectRow == null)
        {
            $.messager.popover({msg: $g("请选中一条"),type:'error',timeout: 1000});
            return
        }
        runClassMethod("Nur.Quality.Service.OmitAdverse","getOmitAdverseDetailList",{parameter1: selectRow.omitID,parameter2: $("#summaryDetailType").combobox("getValue")},function(data){
            var data = data[0]
            $('#patName').val(data.patName)
            $('#regNo').val(data.regNo)
            $('#bedCode').val(data.bedCode)
            $('#wardDesc').val(data.wardDesc)
            $('#insertDateTime').val(data.suspectDateTime)
            $('#event').val(data.event)
            needLinkRecShow(selectRow.eventID,selectRow.episodeID,selectRow.omitID)
            $('#toLinkWindow').window("open")
        })
    })
     
     $('#cancelLinkBtn').on("click",function(){
        var selectRow = $('#summaryDetailTable').datagrid('getSelected')
        if (selectRow == null)
        {
            $.messager.popover({msg: $g("请选中一条"),type:'error',timeout: 1000});
            return
        }
        if (selectRow.reportDateTime == "")
        {
            $.messager.popover({msg: $g("未关联,不能取消关联"),type:'error',timeout: 1000});
            return
        }
        runClassMethod("Nur.Quality.Service.OmitAdverse","cancelLink",{parameter1: selectRow.omitID},function(data){
            if (data=="0")
       		{
	       		$.messager.popover({msg: $g("取消成功"),type:'success',timeout: 1000});
	       		$('#summaryDetailTable').datagrid("reload")
	       		$('#summaryDataTable').datagrid("reLoad")
	       	}
        })
    })
    
}

/**
 * 初始化关联的窗口
 */
function initLinkWindow(){
	
	 $('#summaryNeedLinkTable').datagrid({
        loadMsg: $g("数据装载中......"),
        nowrap: false,
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'reportDateTime', title: '上报时间', width: 120, align:'center' },
            { field: 'consumeTime', title: '时差', width: 120, align:'center' },
            { field: 'reportUser', title: '报告人', width: 50, align:'center'},
            { field: 'id', title: 'id', width: 50, align:'center',hidden:true },
        ]],
        pagination: true,
        pagePosition: 'bottom',
    })
	
    $('#toLinkWindow').window({
        width: 500,
        height: 450,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g("关联"),
        iconCls:'icon-w-paper'
    })
    
    $('#linkSaveBtn').on("click",function(){
	    var selectDetailRow = $('#summaryDetailTable').datagrid('getSelected')
        if (selectDetailRow == null)
        {
            $.messager.popover({msg: $g("请选中一条"),type:'error',timeout: 1000});
            return
        }
        var selectLinkRow = $('#summaryNeedLinkTable').datagrid('getSelected')
        if (selectLinkRow == null)
        {
            $.messager.popover({msg: $g("请选中一条"),type:'error',timeout: 1000});
            return
        }
        
        runClassMethod("Nur.Quality.Service.OmitAdverse","toLinkRec",{parameter1: selectDetailRow.omitID, parameter2: selectLinkRow.id},function(data){
       		if (data=="0")
       		{
	       		$.messager.popover({msg: $g("关联成功"),type:'success',timeout: 1000});
	       		$('#summaryDetailTable').datagrid("reload")
	       		$('#summaryDataTable').datagrid("reLoad")
	       		$('#toLinkWindow').window("close")
	       	}
        })
        
        
	})
	
	$('#linkCloseBtn').on("click",function(){
	    $('#toLinkWindow').window("close")
	})
}
/**
 * 初始化图标弹窗
 * 
 */
function initCharsWindow(){
    $('#summaryCharts').window({
        width: 1000,
        height: 650,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g("图表"),
        iconCls:'icon-w-paper'
    })

    summaryChart = echarts.init(document.getElementById('charts'));

}

/**
 * 点击查询调用的方法
 */
function searchBtn_click()
{
    var queryParams = $('#summaryDataTable').datagrid("options").queryParams
    queryParams.StartDate = $('#startDate').datebox('getValue')
    queryParams.EndDate = $('#endDate').datebox('getValue')
    queryParams.Type = $('#summaryType').combobox('getValue')
    queryParams.Range= (($('#summaryType').combobox('getValue') == "W") ? JSON.stringify($('#summaryRange').combobox('getValues')) : JSON.stringify($('#summaryEventRange').combobox('getValues')) )
    $('#summaryDataTable').datagrid("options").queryParams = queryParams
    $('#summaryDataTable').datagrid("load")
    $('#panel').layout('collapse','east');
    $('#summaryDetailTable').datagrid("loadData",[])
    
}
/**
 * 双击列表查询明细
 * 
 * @param {any} allID  id串
 */
function detailShow(allID)
{
    $('#summaryDetailTable').datagrid("options").url = $URL
    $('#summaryDetailTable').datagrid("options").queryParams = {
        ClassName: 'Nur.Quality.Service.OmitAdverse',
        QueryName: 'getOmitAdverseDetailList',
        IdList: allID,
        Type: $("#summaryDetailType").combobox("getValue")
    }
    $('#summaryDetailTable').datagrid("options").method = 'post'
    $('#summaryDetailTable').datagrid("load")

}

/*
* 点击关联按钮，获取按照开始和结束时间获取上报的信息
*/
function needLinkRecShow(eventID,episodeID,omitID)
{
	$('#summaryNeedLinkTable').datagrid("options").url = LINK_CSP + "?className=Nur.Quality.Service.Comm&methodName=getEventNumInterface"
    $('#summaryNeedLinkTable').datagrid("options").onBeforeLoad=function(param) {
            param.parameter1 = $('#startDate').datebox('getValue');
            param.parameter2 =  $('#endDate').datebox('getValue');
            param.parameter3 = "";
            param.parameter4 = eventID;
            param.parameter5 = episodeID;
            param.parameter6 = "data";
            param.parameter7 = omitID;
    }
    $('#summaryNeedLinkTable').datagrid("options").method = 'post'
    $('#summaryNeedLinkTable').datagrid("load")
}