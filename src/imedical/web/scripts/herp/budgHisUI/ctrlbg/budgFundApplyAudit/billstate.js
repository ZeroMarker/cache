BillStatefun = function (rowid,BillCode) {
	// console.log(rowid+"^"+BillCode);
    var statetitle = "单据号"+BillCode+"审核记录";    
	var $BillState;
    $BillState = $('#BillState').window({
        title: statetitle,
        width: 800,
        height: 400,
        top: ($(window).height() - 400) * 0.5,
        left: ($(window).width() - 800) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-save',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose:function(){ //关闭关闭窗口后触发
           $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $BillState.window('open');
    //列配置对象
    BillStaCol=[[  
        {field:'rowid',title:'ID',width:30,hidden: true},
        {field:'deptname',title:'执行科室',align:'left',width:80},
        {field:'apllyname',title:'执行人',align:'left',width:70},
        {field:'ChkResult',title:'执行结果',align:'left',width:60},
        {field:'ChkProcDesc',title:'执行过程描述',align:'left',width:80},
        {field:'DateTime',title:'执行时间',align:'right',width:120}
    ]];
    //定义表格
    var StateGrid = $HUI.datagrid("#StateGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.ubudgAuditFundApply",
            MethodName:"ListState",
            FundBillDR : rowid
        },            
        fitColumns: true,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: true, //为true时只允许选中一行,为false时多选   若注释掉，默认单选
        fit:true,
        pageSize:20,
        pageNumber:1,
        pagination:true,
        columns:BillStaCol,
        rowStyler: function(index,row){
            if(index%2==1){
                return 'background-color:#FAFAFA;';
            }
        }      
    });
    $("#StateClose").click(function(){$BillState.window('close');})

}
