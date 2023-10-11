schemastatefun = function (schemAuditDR, userdr, schemDr,Establishflag,ItemCode) {
	var $statewin;
    $statewin = $('#StateWin').window({
        title: '编制审核状态',
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
    $statewin.css("display", "block");

    $statewin.window('open');    
        
    
    StateColumns=[[  
                {
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'drowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'darowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'curstep',
	                title:'过程',
	                align:'center',
	                width:80
                },{
	                field:'stepno',
	                title:'审批顺序号',
	                align:'center',
	                width:120
                },{
	                field:'deptdesc',
	                title:'执行科室',
	                width:120,
	                hidden: true
                },{
	                field:'cherker',
	                title:'执行人',
	                width:140
                },{
	                field:'execprocedesc',
	                title:'执行过程描述',
	                width:200
                },{
	                field:'execresult',
	                title:'执行结果',
	                align:'center',
	                width:100,
	                styler:cellStyler
                },{
	                field:'execdate',
	                title:'执行时间',
	                width:200
                },{
	                field:'desc',
	                title:'审批意见',
	                width:200
                },{
	                field:'adjustno',
	                title:'调整顺序号',
	                width:120,
	                hidden: true
                }
            ]];
    var StateGrid = $HUI.datagrid("#StateGrid",{
        url:$URL,
        queryParams:{
            ClassName :"herp.budg.hisui.common.CommMethod",
            MethodName :"CheckState",
            userdr      : userdr,
            SchemAuditDR : schemAuditDR,
            SchemDr :   schemDr, 
            Establishflag : Establishflag,
            ItemCode : ItemCode 
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
    
    function cellStyler(value,row,index){
			if (value =="待审"){
				return 'background-color:#ee4f38;color:#FFFFFF';
			}
		}
	   
	$.m({
			ClassName: 'herp.budg.hisui.common.CommMethod',
			MethodName: 'isControl'
		},
			function (array) {
			if (array[0]==0) {
				$('#StateGrid').datagrid('hideColumn', 'curstep');
			}else{
				$('#StateGrid').datagrid('showColumn', 'curstep');
				}})		
};
