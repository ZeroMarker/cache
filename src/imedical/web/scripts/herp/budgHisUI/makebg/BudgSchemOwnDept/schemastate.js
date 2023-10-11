schemastatefun = function (schemAuditDR, userdr, schemDr) {
	var $statewin;
    $statewin = $('#StateWin').window({
        title: '方案状态明细',
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
        resizable: true
    });
    $statewin.window('open');    
    //取消 
    $("#StateClose").unbind('click').click(function(){
        $statewin.window('close');
    });	
    StateColumns=[[  
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'serialnumber',title:'执行序号',width:100},
                {field:'deptdesc',title:'执行科室',width:120,hidden: true},
                {field:'cherker',title:'执行人',width:120},
                {field:'execprocedesc',title:'执行过程描述',width:200},
                {field:'execresult',title:'执行结果',width:100},
                {field:'execdate',title:'执行时间',width:200},
                {field:'desc',title:'审批意见',width:200}
            ]];
    var StateGrid = $HUI.datagrid("#StateGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemAuditWideHos",
            MethodName:"Liststate",
            userdr      : userdr,
            SchemAuditDR : schemAuditDR,
            SchemDr :   schemDr   
        },
        fitColumns: true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:StateColumns         
    });    
				
};
