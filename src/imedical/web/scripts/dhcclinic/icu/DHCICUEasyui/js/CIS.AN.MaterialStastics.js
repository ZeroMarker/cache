var operList={
    controlDatas:null
}

/**
 * 初始化页面
 */
function initPage()
{
   
    initConditionForm();
    initOperListGrid();
}

/**
 * 初始化查询条件表单
 */
function initConditionForm(){
    dhccl.parseDateFormat();
    var ret=dhccl.runServerMethod("web.DHCClinicCom","GetDateFormat");

	if(ret.result=="j/n/Y") var today=(new Date()).format("dd/MM/yyyy");
	else var today=(new Date()).format("yyyy-MM-dd");
    $("#DateFrom,#DateTo").datebox("setValue",today);

    $("#btnQuery").linkbutton({
        onClick:initOperListGrid
        //$("#MaterialData").datagrid("reload");
    });

   
    $("#btnPrint").linkbutton({
        onClick:btnPrint
    });

    //setQueryConditions();
}
function initOperListGrid(){
    $("#MaterialData").datagrid({
        fit:true,
       // title:"器械材料统计",
        headerCls:"panel-header-gray",
        iconCls:"icon-paper",
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200,300,400,500],
        remoteSort: false,
        checkbox: true,
        checkOnSelect:true,
        selectOnCheck:true,
        // singleSelect:true,
        //toolbar:"#operlistTool",
        columns:[
            [
            //opaId,room,ordno,Id,tcssdr,cssdpack,tnumber
               {field: "room", title: "术间", width: 70, sortable: true },
               {field: "ordno", title: "台次", width: 45, sortable: true },
               {field: "opaId", title: "手术id", width: 40, sortable: true },
               {field: "patName", title: "患者", width: 80, sortable: true },
               {field: "regNo", title: "登记号", width: 100, sortable: true },
               {field: "opName", title: "手术", width: 200, sortable: true },
               {field: "tcssdr", title: "tcssdr", hidden: true },
               {field: "Id", title: "Id", hidden: true },
               {field: "cssdpack", title: "材料包", width: 160, sortable: true },
               {field: "tnumber", title: "数量", width: 60, sortable: true}
               
            ]
        ],
        url:ANCSP.DataQuery,
        // rowStyler: function (index, row) {
        //     return "background-color:" + row.StatusColor + ";";
        // },
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperStatistics;
            param.QueryName="MaterialList";
            param.Arg1=$("#DateFrom").datebox('getValue');
	        param.Arg2=$("#DateTo").datebox('getValue');
	        param.Arg3=$("#IsShowDetail").checkbox('getValue')?"Y":"N";
            param.ArgCnt=3;
        },
        onSelect:function(rowIndex,rowData){
          
        },
        onUnselect:function(rowIndex,rowData){
     
        }
    });

}
//202003+dyl
function btnPrint()
{
    var rows=$("#MaterialData").datagrid("getRows");
    
    var canPrintRows=[];
    for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
        const row = rows[rowIndex];
        canPrintRows.push(row);
    }
    var firstRow=canPrintRows[0];
    
    var LODOP=getLodop();
    LODOP.SET_PRINT_MODE("PRINT_DUPLEX",2);
    LODOP.PRINT_INIT("MaterialStastics" );    //初始化表单
    LODOP.PRINT_INIT("手术材料统计单");
    // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "SSS");
    LODOP.SET_PRINT_PAGESIZE("1", 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(25, 250, 500, 40, "手术材料统计单");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
   
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(65, 60, "100%", 28,"日期"+$("#DateFrom").datebox('getValue'));
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(65, 700, "100%", 28,"");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(65, 500, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);


    
    var columns=[{field: "room", title: "术间", width: 60 ,uom:"pt"},
    {field: "ordno", title: "台次", width: 35 ,uom:"pt"},
    {field: "patName", title: "患者", width: 50 ,uom:"pt"},
    {field: "regNo", title: "登记号", width: 80 ,uom:"pt"},
    {field: "opName", title: "手术", width: 240 ,uom:"pt"},
    {field: "cssdpack", title: "材料包", width: 160 ,uom:"pt"},
    {field: "tnumber", title: "数量", width: 60,uom:"pt"}];
    var totalWidth=0;
    for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
        const element = columns[columnIndex];
        totalWidth+=element.width;
    }
    var htmlArr=[
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;} table{table-layout:fixed;}</style>",
        "<table style='"+totalWidth+"pt'><thead><tr>"
    ];
    for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
        const column = columns[columnIndex];
        htmlArr.push("<th width='"+column.width+column.uom+"'>"+column.title+"</th>");
    }

    htmlArr.push("</tr></thead><tbody>");

    for (var rowIndex = 0; rowIndex < canPrintRows.length; rowIndex++) {
        const row = canPrintRows[rowIndex];
        htmlArr.push("<tr>");
        for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
            const column = columns[columnIndex];
            htmlArr.push("<td>"+(row[column.field] || '')+"</td>");
        }
        htmlArr.push("</tr>");
    }
    htmlArr.push("</tbody></table>");
    LODOP.ADD_PRINT_TABLE(105, 10, totalWidth+"pt", "100%", htmlArr.join(""));
    LODOP.PREVIEW();
}
$(document).ready(initPage);