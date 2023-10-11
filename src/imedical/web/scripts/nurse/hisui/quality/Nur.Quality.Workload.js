var GV = {
	currentHOSPID: session['LOGON.HOSPID'],
	tableName: "Nur_IP_Quality.WorkFlowConfig"
}
var currentCTLOCID = session['LOGON.CTLOCID']
var currentUSERID = session['LOGON.USERID']
var currentUSERNAME = session['LOGON.USERNAME']
var currentWARDID = (session['LOGON.WARDID']==undefined)? "" : session['LOGON.WARDID']
$(function() {
    initUI()
})

function initUI(){
    initSearchForm();
    initWorkloadTable();
}
function initSearchForm(){
    function filter(q, row) {
        var opts = $(this).combobox('options');
        var text = row[opts.textField];
        var pyjp = getPinyin(text).toLowerCase();
        if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
            return true;
        }
        return false;
    }
    /**科室 */
    $('#inputWardID').combobox({
        disabled: (currentWARDID != "" ? true : false ),
        valueField: 'ID',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getLocs&parameter1=W&parameter2=' + GV.currentHOSPID + "&parameter3=" + GV.tableName,
        filter: filter,
        onLoadSuccess: function (params) {
	        if (currentWARDID != "")
            {
                $(this).combobox('setValue', session['LOGON.CTLOCID'])
            }
        }
    })

    /**出院时间 */
    $('#inputOutHopStartDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))
    $('#inputOutHopEndDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))

    /**查询 */
    $('#searchBtn').on('click',function(){
        //searchBtn()
        initWorkloadTable()
    })
    
    /*导出*/
    $("#exportBtn").on('click',function(){
	    exportBtn()
	})
}
function initWorkloadTable(){
    getColumns(function(data){
        var columns = []
        var columnsData = eval(data)
        columnsData.unshift({ field: 'userName', title: '护士', width: 100, align:'center' })
        columns.push(columnsData)
        $('#workloadTable').datagrid({
            url: LINK_CSP + '?className=Nur.Quality.Service.Workload&methodName=getWorkloadRecList',
            method: 'post',
            loadMsg: $g("数据装载中......"),
            rownumbers: true,
            nowrap: false,
            striped: true,
            fitColumns: false,
            autoRowHeight: true,
            singleSelect: false,
            showHeader: true,
            columns: columns,
            onBeforeLoad: function(param) {
                param.parameter1 = $('#inputOutHopStartDate').datebox('getValue');
                param.parameter2 = $('#inputOutHopEndDate').datebox('getValue');
                param.parameter3 = $('#inputWardID').combobox('getValue');
                param.parameter4 = GV.currentHOSPID;
            },
            // pagination: true,
            // pageSize: 20,
            // pageList: [10, 20, 50],
            // pagePosition: 'bottom'
        })
    })
}

/**查询按钮 */
function searchBtn(){
    $('#workloadTable').datagrid('load');
}

function getColumns(callback){
    runClassMethod("Nur.Quality.Service.AppraiseEmrConfig","getWorkloadConfig",
    {
	    parameter1: ($('#inputWardID').combobox('getValue') !="" ? $('#inputWardID').combobox('getValue') : currentCTLOCID),
	    parameter2: GV.currentHOSPID
	    
	},
    function(data){
        callback(data)
    })
}

/*导出按钮*/
function exportBtn(){
	$('#workloadTable').datagrid('toExcel',
		{name:$g("导出的数据.xls"),
		 parseDataFun: function(data){
			 var data=$cm({
        		ClassName: 'Nur.Quality.Service.Workload',
        		MethodName: 'getWorkloadRecList',
        		ResultSetType: "array",
       			StartDate: $('#inputOutHopStartDate').datebox('getValue'),
       			EndDate: $('#inputOutHopEndDate').datebox('getValue'),
       			WardID: $('#inputWardID').combobox('getValue'),
       			HospId: GV.currentHOSPID
    		},false)
    		return data
		 }
		})
	/*
	 $cm({
        ClassName: 'Nur.Quality.Service.Workload',
        MethodName: 'getWorkloadRecList',
        ResultSetType: "array",
       	StartDate: $('#inputOutHopStartDate').datebox('getValue'),
       	EndDate: $('#inputOutHopEndDate').datebox('getValue'),
       	WardID: $('#inputWardID').combobox('getValue')
    },function(jsonData){
		var jsonData=jsonData
		debugger;
        var xls = new ActiveXObject ("Excel.Application");
        var xlBook = xls.Workbooks.Add;
        var xlSheet = xlBook.Worksheets(1);
    
        var cols = $('#workloadTable').datagrid('options').columns[0];
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
        var fname = xls.Application.GetSaveAsFilename("导出的xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
        xlBook.SaveAs(fname); 
        xlBook.Close(); 
        xls.Quit();     
        xls=null;
        xlBook=null; 
        xlSheet=null;
    });
    */
}
