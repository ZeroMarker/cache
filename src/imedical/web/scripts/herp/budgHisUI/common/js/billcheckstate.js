billstatefun = function (rowid, BillCode, billtype) {
	var $statewin;
    $statewin = $('#BillState').window({
        title: '�������������״̬',
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
			if (value =="����"){
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
	                title:'����˳��',
	                align:'center',
	                width:80
                },{
	                field:'apllyname',
	                title:'������',
	                width:160
                },{
	                field:'deptname',
	                title:'����',
	                width:120
                },{
	                field:'ChkResult',
	                title:'�������',
	                align:'center',
	                width:90,
	                styler:cellStyler
                },{
	                field:'ChkProcDesc',
	                title:'��������',
	                width:260
                },{
	                field:'DateTime',
	                title:'ִ��ʱ��',
	                width:200,
                },{
	                field:'desc',
	                title:'�������',
	                width:180
                },{
	                field:'Billtype',
	                title:'��������',
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
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        rownumbers:true,//�к�
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:StateColumns
    }); 
    
    
	
	$("#StateClose").click(function(){$statewin.window('close');})
   
};
