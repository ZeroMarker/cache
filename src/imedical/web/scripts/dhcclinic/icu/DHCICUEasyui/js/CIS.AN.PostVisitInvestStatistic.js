$(function(){
    $("#SchStartDate").datebox("setValue",(new Date()).format("yyyy-MM-dd"));
    $("#SchEndDate").datebox("setValue",(new Date()).format("yyyy-MM-dd"));
    $("#btnQuery").click(function(){
        $("#queryDatasBox").datagrid("reload");
    })
    $("#btnExport").click(function(){
        exportExcel();
    })
    
    var columns=[[
        {field:"PatName",title:"姓名",width:100},
        {field:"MedicareNo",title:"住院号",width:100},
        {field:"DeptDesc",title:"科室名称",width:120},
        {field:"AnaMethodDesc",title:"麻醉方法",width:120},
        {field:"Analgesia",title:"镇痛方式",width:120},
        {field:"SpecialCondition",title:"特殊情况",width:45,hidden:true},
        {field:"TreatMeasures",title:"处理措施",width:50,hidden:true},
        {field:"PCIAFormula",title:"镇痛泵配方",width:120},
        {field:"AnaDoctor",title:"麻醉医生",width:120}
    ]];
    $("#queryDatasBox").datagrid({
        fit:true,
        title:"术后随访汇总",
        headerCls:"panel-header-gray",
        iconCls:"icon-paper",
        rownumbers: true,
        pagination: true,
        pageSize: 300,
        pageList: [50, 100, 200,300,400,500],
        // remoteSort: false,
        // checkbox: true,
        // checkOnSelect:true,
        // selectOnCheck:true,
        // singleSelect:true,
        columns:columns,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperStatistics;
            param.QueryName="FindPostVisitInvest";
            param.Arg1=$("#SchStartDate").datebox("getValue");
            param.Arg2=$("#SchEndDate").datebox("getValue");
            param.ArgCnt=2;
        }
    });

    function exportExcel(){
        var datagridTitle=new Array();
        var fields=$("#queryDatasBox").datagrid("getColumnFields");
        for(var i=0;i<fields.length;i++){
            var option=$("#queryDatasBox").datagrid("getColumnOption",fields[i]);
            if(option.field!="checkItem"&&option.hidden!=true){
                datagridTitle.push(option);
            }
        }
        var printData = $("#queryDatasBox").datagrid("getData");
        if(printData && printData.rows && printData.rows.length>0){
            var dataRows=printData.rows;
            var xlsExcel,xlsBook,xlsSheet;
            var row=1;
            xlsExcel=new ActiveXObject("Excel.Application")
            xlsBook=xlsExcel.Workbooks.Add();
            xlsSheet=xlsBook.ActiveSheet;
            //打印表头
            for(var i=0;i<datagridTitle.length;i++){
                xlsSheet.cells(row,i+1)=datagridTitle[i].title
            }
            //打印数据
           for(var i=0;i<dataRows.length;i++){
                row++;
               for(var j=0;j<datagridTitle.length;j++){
                    var curData=dataRows[i][datagridTitle[j].field];
                    xlsSheet.cells(row,j+1)=curData;
               }
           }
           xlsExcel.Visible=true;
        }
     
    }


})
