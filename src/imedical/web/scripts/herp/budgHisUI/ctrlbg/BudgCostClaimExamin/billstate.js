billstatefun = function(rowid){
    // console.log(rowid);
    var $BillState;
    $BillState = $('#BillState').window({
    	title: '单据状态明细',
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
    {field:'serialnumber',title:'序号',width:60},
    {field:'exectdept',title:'执行科室',align:'left',width:120},
    {field:'executor',title:'执行人',align:'left',width:120},
    {field:'execresult',title:'执行结果',align:'left',width:120},
    {field:'execprocedescr',title:'执行过程描述',align:'left',width:150},
    {field:'execdate',title:'执行时间',align:'right',width:150}
    ]];
    //定义表格
    var StateGrid = $HUI.datagrid("#StateGrid",{
    	url:$URL,
    	queryParams:{
    		ClassName:"herp.budg.hisui.udata.ubudgcostclaimapply",
    		MethodName:"Listbillstate",
    		rowid : rowid
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

};
