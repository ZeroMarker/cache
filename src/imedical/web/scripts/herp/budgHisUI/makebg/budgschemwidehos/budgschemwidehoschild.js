ChildFun = function(Id)
{		
	var $Childwin;
    $Childwin = $('#ChildWin').window({
        title: '前置方案列表',
        width: 550,
        height: 350,
        top: ($(window).height() - 350) * 0.5,
        left: ($(window).width() - 550) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-w-paper',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true
    });
    $Childwin.window('open');    
    
    ChildColumns=[[  
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'bsmcode',title:'方案编号',width:60},
                {field:'bsmname',title:'方案名称',width:180},
                {field:'bsmorderby',title:'编制顺序',width:60}
            ]];
    var ChildGrid = $HUI.datagrid("#ChildGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemWideHos",
            MethodName:"ListChild",
            Id 		  : Id      
        },
        fitColumns: true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:ChildColumns         
    });    

};