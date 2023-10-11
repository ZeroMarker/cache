$(function() {
    initUI()
})

function initUI(){
    initSearchForm();  //初始化查询
    initGrid();        //初始化表格
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
    $('#inputAppraiseStartDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))
    $('#inputAppraiseEndDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))

    //关联状态
    $('#inputStatusSelect').combobox({
        valueField: 'value',
        textField: 'label',
//        data: [{
//            label: $g("全部"),
//            value: 'A'
//        },{
//            label: $g("关联"),
//            value: 'Y'
//        },{
//            label: $g("未关联"),
//            value: 'N'
//        }]
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=GetLinkStatus'
    })

      /**事件类型 */
      $('#inpuEventSelect').combobox({
        valueField: 'id',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getEventListInterface&parameter1=&parameter2=' + session['LOGON.HOSPID'],
        filter: filter
    })


    /**上报科室 */
    $('#inputWardID').combobox({
        valueField: 'ID',
        textField: 'desc',
        multiple: true,
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getLocs&parameter1=W&parameter2='+session['LOGON.HOSPID']+"&parameter3=Nur_IP_Quality.OmitAdverseConfig",
        filter: filter,
        onLoadSuccess: function (params) {
            //$(this).combobox('setValues', [session['LOGON.CTLOCID']])
        }
    })
    $('#searchBtn').on("click",function(){
        var queryParams = $('#patOmitAdverseTable').datagrid("options").queryParams
        queryParams.StartDate = $('#inputAppraiseStartDate').datebox('getValue')
        queryParams.EndDate = $('#inputAppraiseEndDate').datebox('getValue')
        queryParams.Status = $('#inputStatusSelect').combobox('getValue')
        queryParams.Event = $('#inpuEventSelect').combobox('getValue')
        queryParams.AppLoc = JSON.stringify($('#inputWardID').combobox('getValues'))
        $('#patOmitAdverseTable').datagrid("options").queryParams = queryParams
        $('#patOmitAdverseTable').datagrid("load")
    })
    
     /**导出*/
    $('#exportBtn').on("click",function(){
	    exportExecel()
	})



}

function initGrid()
{
    $('#patOmitAdverseTable').datagrid({
        url: $URL,
        queryParams:{
            ClassName: 'Nur.Quality.Service.OmitAdverse',
            QueryName: 'getOmitAdverseList',
            StartDate: $('#inputAppraiseStartDate').datebox('getValue'),
            EndDate: $('#inputAppraiseEndDate').datebox('getValue'),
            Status: $('#inputStatusSelect').combobox('getValue'),
            Event: $('#inpuEventSelect').combobox('getValue'),
            AppLoc:  JSON.stringify($('#inputWardID').combobox('getValues')),
            HospId: session['LOGON.HOSPID']
        },
        method: 'post',
        loadMsg: $g('数据装载中......'),
        nowrap: false,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'regNo', title: '登记号', width: 90, align:'left' },
            { field: 'bedCode', title: '床号', width: 50, align:'left'},
            { field: 'patName', title: '姓名', width: 60, align:'left' },
            { field: 'sex', title: '性别', width: 40, align:'left' },
            { field: 'age', title: '年龄', width: 40, align:'left' },
            { field: 'wardDesc', title: '病区', width: 120, align:'left' },
            { field: 'status', title: '状态', width: 60, align:'left' },
            { field: 'event', title: '事件', width: 160, align:'left' },
            { field: 'linkBefore', title: '前置情况', width: 240, align:'left' },
            { field: 'linkCondition', title: '触发情况', width: 240,  align:'left' },      
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom'
    })
    
}


function exportExecel()
{
	$cm({
        ClassName: 'Nur.Quality.Service.OmitAdverse',
        QueryName: 'getOmitAdverseList',
        ResultSetType: "array",
       	StartDate: $('#inputAppraiseStartDate').datebox('getValue'),
        EndDate: $('#inputAppraiseEndDate').datebox('getValue'),
        Status: $('#inputStatusSelect').combobox('getValue'),
        Event: $('#inpuEventSelect').combobox('getValue'),
        AppLoc:  JSON.stringify($('#inputWardID').combobox('getValues')),
    },function(jsonData){
		var jsonData=jsonData
		debugger;
        var xls = new ActiveXObject ("Excel.Application");
        var xlBook = xls.Workbooks.Add;
        var xlSheet = xlBook.Worksheets(1);
    
        var cols = $('#patOmitAdverseTable').datagrid('options').columns[0];
        var colCount = cols.length;
    
    
        for(i=0;i <colCount;i++){ 
            xlSheet.Cells(1,i+1).value =cols[i].title;
            xlSheet.Cells(1,i+1).Font.Bold = true;
            xlSheet.Cells(1,i+1).Font.Size = 12;
            xlSheet.Columns(i+1).ColumnWidth = 10; 
            xlSheet.Cells(1,i+1).Borders.Weight = 2; 
        }
        

        var row =  2;
        for (var i=0;i<jsonData.length;i++) {
            var column = 1;
            
            for(j=0;j <colCount;j++){
	             xlSheet.Cells(row,column).value = jsonData[i][cols[j].field];
                 xlSheet.Cells(row,column).Borders.Weight = 2; 
             
                 xls.Selection.MergeCells = true;
                 xls.Selection.Borders.Weight = 2;
                 column++;
            }
            row ++;
        }
        var fname = xls.Application.GetSaveAsFilename($g("导出的xlsx"), "Excel Spreadsheets (*.xlsx), *.xlsx"); 
        xlBook.SaveAs(fname); 
        xlBook.Close(); 
        xls.Quit();     
        xls=null;
        xlBook=null; 
        xlSheet=null;
    });
}
