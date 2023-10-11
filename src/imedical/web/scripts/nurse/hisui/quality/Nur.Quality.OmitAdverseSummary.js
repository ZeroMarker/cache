var summaryChart;
$(function() {
    initUI()
})

function initUI(){

    initSearchForm();  //��ʼ����ѯ
    initGrid();        //��ʼ�����
    initLinkWindow(); //��ʼ�������Ĵ���
    initCharsWindow(); //��ʼ��ͼ����
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

    //�ϱ���ѯʱ��
    $('#startDate').datebox('setValue', (new Date()).before(3).Format("yyyy-MM-dd"))
    $('#endDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))

    //����״̬
    $('#summaryType').combobox({
        valueField: 'value',
        textField: 'label',
        data: [{
            label: $g('������'),
            value: 'W',
            selected:true  
        },{
            label: $g('���¼�'),
            value: 'E'
        }],
        onSelect:function(record){
            var selectValue = record.value
            if (selectValue == "W")
            {
                $('#summaryDataTable').datagrid("hideColumn","event")
                $('#summaryDataTable').datagrid("showColumn","wardDesc").datagrid("getColumnOption", "wardDesc").title = $g("����");
                $('#summaryDataTable').datagrid();
                $('#summaryEventRange').combobox("setValues","")
                $('#summaryLoc').css("display","block")
                $('#summaryEvent').css("display","none")

            }else if(selectValue == "E")
            {
                $('#summaryDataTable').datagrid("hideColumn","wardDesc")
                $('#summaryDataTable').datagrid("showColumn","event").datagrid("getColumnOption", "event").title = $g("�¼�");
                $('#summaryDataTable').datagrid();
                $('#summaryRange').combobox("setValues","")
                $('#summaryLoc').css("display","none")
                $('#summaryEvent').css("display","block")
            }
            searchBtn_click()
        }
    })


    /**�ϱ����� */
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

     /**�¼� */
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
        loadMsg: $g("����װ����......"),
        nowrap: false,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'wardDesc', title: '����', width: 110, align:'left', hidden:false },
            { field: 'event', title: '�¼�', width: 110, align:'left',hidden: true, },
            { field: 'suspectNum', title: '������', width: 70, align:'left'},
            { field: 'reportNum', title: '�ϱ���', width: 120, align:'left' },
            { field: 'difference', title: '��ֵ', width: 80, align:'left' },
            { field: 'linkNum', title: '�ѹ�����', width: 80, align:'left' },
            { field: 'allID', title: 'allID', width: 80, align:'left',hidden:true },
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        toolbar:[
        {
            iconCls: 'icon-img',
            text: $g("ͼ��"),
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
                    dimensions: ['product', $g("Ԥ��ֵ"), $g("�ϱ�ֵ")],
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
                single[$g("Ԥ��ֵ")] = rows[index].suspectNum
                single[$g("�ϱ�ֵ")] = rows[index].reportNum
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
        loadMsg: $g("����װ����......"),
        nowrap: false,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'wardDesc', title: '����', width: 130, align:'left' },
            { field: 'regNo', title: '�ǼǺ�', width: 90, align:'left' },
            { field: 'bedCode', title: '����', width: 50, align:'left'},
            { field: 'patName', title: '����', width: 80, align:'left' },
            { field: 'sex', title: '�Ա�', width: 50, align:'left' },
            { field: 'age', title: '����', width: 50, align:'left' },
            { field: 'event', title: '�¼�', width: 80, align:'left' },
            { field: 'suspectDateTime', title: '���Ʒ���ʱ��', width: 120, align:'left' },
            { field: 'reportDateTime', title: '�¼��ϱ�ʱ��', width: 120, align:'left' },
            { field: 'consumeTime', title: '��ʱ', width: 50, align:'left' },
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
        //     text: '����',
        //     handler: function() {

        //     }
        // }, 
        // {
        //     iconCls: 'icon-paper-link',
        //     text: '�ֶ�����',
        //     handler: function() {
              
        //     }
        // }],
    })

    $('#summaryDetailType').combobox({
        valueField: 'value',
        textField: 'label',
        data: [{
            label: $g("ȫ��"),
            value: 'A'
        },{
            label: $g("�ѹ���"),
            value: 'Y'
        },{
            label: $g("δ����"),
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
            $.messager.popover({msg: $g("��ѡ��һ��"),type:'error',timeout: 1000});
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
            $.messager.popover({msg: $g("��ѡ��һ��"),type:'error',timeout: 1000});
            return
        }
        if (selectRow.reportDateTime == "")
        {
            $.messager.popover({msg: $g("δ����,����ȡ������"),type:'error',timeout: 1000});
            return
        }
        runClassMethod("Nur.Quality.Service.OmitAdverse","cancelLink",{parameter1: selectRow.omitID},function(data){
            if (data=="0")
       		{
	       		$.messager.popover({msg: $g("ȡ���ɹ�"),type:'success',timeout: 1000});
	       		$('#summaryDetailTable').datagrid("reload")
	       		$('#summaryDataTable').datagrid("reLoad")
	       	}
        })
    })
    
}

/**
 * ��ʼ�������Ĵ���
 */
function initLinkWindow(){
	
	 $('#summaryNeedLinkTable').datagrid({
        loadMsg: $g("����װ����......"),
        nowrap: false,
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'reportDateTime', title: '�ϱ�ʱ��', width: 120, align:'center' },
            { field: 'consumeTime', title: 'ʱ��', width: 120, align:'center' },
            { field: 'reportUser', title: '������', width: 50, align:'center'},
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
        title: $g("����"),
        iconCls:'icon-w-paper'
    })
    
    $('#linkSaveBtn').on("click",function(){
	    var selectDetailRow = $('#summaryDetailTable').datagrid('getSelected')
        if (selectDetailRow == null)
        {
            $.messager.popover({msg: $g("��ѡ��һ��"),type:'error',timeout: 1000});
            return
        }
        var selectLinkRow = $('#summaryNeedLinkTable').datagrid('getSelected')
        if (selectLinkRow == null)
        {
            $.messager.popover({msg: $g("��ѡ��һ��"),type:'error',timeout: 1000});
            return
        }
        
        runClassMethod("Nur.Quality.Service.OmitAdverse","toLinkRec",{parameter1: selectDetailRow.omitID, parameter2: selectLinkRow.id},function(data){
       		if (data=="0")
       		{
	       		$.messager.popover({msg: $g("�����ɹ�"),type:'success',timeout: 1000});
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
 * ��ʼ��ͼ�굯��
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
        title: $g("ͼ��"),
        iconCls:'icon-w-paper'
    })

    summaryChart = echarts.init(document.getElementById('charts'));

}

/**
 * �����ѯ���õķ���
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
 * ˫���б��ѯ��ϸ
 * 
 * @param {any} allID  id��
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
* ���������ť����ȡ���տ�ʼ�ͽ���ʱ���ȡ�ϱ�����Ϣ
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