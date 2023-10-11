billstatefun = function (rowid, BillCode, billtype) {
	var $statewin;
    $statewin = $('#BillState').window({
        title: '报销单编制审核状态',
        iconCls: 'icon-w-paper',
        width: 900,
        height: 500,
        top: ($(window).height() - 500) * 0.5,
        left: ($(window).width() - 900) * 0.5,
        shadow: true,
        modal: true,
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true
    });

    $statewin.window('open');    
        
    function cellStyler(value,row,index){
			if (value =="待审"){
				return 'background-color:#ee4f38;color:#FFFFFF';
			}
		}
    StateColumns=[[  
                {
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'stp',
	                title:'审批顺序',
	                align:'center',
	                width:80
                },{
	                field:'apllyname',
	                title:'操作人',
	                width:160
                },{
	                field:'deptname',
	                title:'科室',
	                width:120
                },{
	                field:'ChkResult',
	                title:'操作结果',
	                align:'center',
	                width:90,
	                styler:cellStyler
                },{
	                field:'ChkProcDesc',
	                title:'过程描述',
	                width:260
                },{
	                field:'DateTime',
	                title:'执行时间',
	                width:200,
                },{
	                field:'desc',
	                title:'审批意见',
	                width:180
                },{
	                field:'Billtype',
	                title:'单据类型',
	                width:200,
	                hidden: true
                }
            ]];
    var StateGrid = $HUI.datagrid("#StateGrid",{
        url:$URL,
        queryParams:{
            ClassName :"herp.budg.hisui.udata.uBudgFundApply",
            MethodName :"ListState",
			FundBillDR: rowid, 
			billtype:  billtype       
			},
        fitColumns: true,
        //striped : true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:StateColumns
    }); 
    
    
	
	$("#StateClose").click(function(){$statewin.window('close');})
   
};
