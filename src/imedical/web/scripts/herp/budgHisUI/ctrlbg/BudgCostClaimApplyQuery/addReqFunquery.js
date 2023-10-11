AddReqFun = function(applyCombo,data){
	var tmp=data;
	//初始化报销单窗口
	var $FAwin;
	$FAwin = $('#FundApplyWin').window({
	    title: '选择借款单',
	    width: 980,
	    height: 480,
	    top: ($(window).height() - 480) * 0.5,
	    left: ($(window).width() - 980) * 0.5,
	    shadow: true,
	    modal: true,
	    iconCls: 'icon-w-card',
	    closed: true,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    resizable: true,
	    onClose:function(){ //关闭关闭窗口后触发
           FADetailGrid.load({
                ClassName:"herp.budg.hisui.udata.uExpenseAccountDetail",
                MethodName:"ReqNoListDetail",
                mainId :    ""
            })
        }
	});
	$FAwin.window('open');
    // 申请年月的下拉框
    var AddYMboxObj = $HUI.combobox("#FAYMBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        }
    });	
    //查询函数
    var FindBtn= function()
    {
        var yearmonth = $('#FAYMBox').combobox('getValue'); // 申请年月
      	var billcode    = $('#BillBox').val(); // 借款单号
        var data = tmp+ "^" + yearmonth+ "^" +billcode;
        
        FundApplyGrid.load({
                ClassName:"herp.budg.hisui.udata.uExpenseAccountDetail",
                MethodName:"ReqNoList",
                data   :    data
            })
    }
    //点击查询按钮 
    $("#FABn").click(FindBtn);    
    //主表格列配置对象
    FAColumns=[[ 
        {field:'ckbox',checkbox:true},//复选框 
        {field:'rowid',title:'ID',width:30,hidden: true},
        {field:'BillCode',title:'申请单号',width:120}      
    ]];    
    //定义主表格
    var FundApplyGrid = $HUI.datagrid("#FundApplyGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uExpenseAccountDetail",
            MethodName:"ReqNoList",
            data :    data 
        },
        selectOnCheck: true, //选中行复选框勾选        
        fitColumns: true,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: true, //多选，为true时只允许选中一行   若注释掉，默认单选
        //pageSize:20,
        //pageList:[10,20,30,50,100], //页面大小选择列表
        //pagination:true,//分页
        fit:true,
        columns:FAColumns,
        // onClickRow: onClickRow,  //在用户点击一行的时候触发
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            var rowsData = $('#FundApplyGrid').datagrid('getRows');
            var data=rowsData[index];
            var rowid = data.rowid;
            FADetailGrid.load({
                ClassName:"herp.budg.hisui.udata.uExpenseAccountDetail",
                MethodName:"ReqNoListDetail",
                mainId :    rowid
            })
        },
        onDblClickCell: function(index,field,value){   //在用户双击一个单元格的时候触发
            var rowsData = $('#FundApplyGrid').datagrid('getRows');
            var data=rowsData[index];
            var rowid = data.rowid;
		    var billcode = data.BillCode;
		    str=rowid+"_"+billcode;
			applyCombo.val(str)
	        $FAwin.window('close');

        },
        toolbar: '#FundApplytb'       
    });	
    //明细表格列配置对象
    FADColumns=[[ 
        {field:'rowid',title:'ID',width:30,hidden: true},
        {field:'billdr',title:'主表ID',width:120,hidden: true},
        {field:'itemcode',title:'预算科目编码',width:120},
        {field:'itemname',title:'预算科目名称',width:140},
        {field:'balance',title:'目前预算结余',align:'right',width:100},
        {field:'reqpay',title:'报销申请',align:'right',width:70},
        {field:'actpay',title:'审批支付',align:'right',width:70}            
    ]];    
    //定义明细表格
    var FADetailGrid = $HUI.datagrid("#FADetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uExpenseAccountDetail",
            MethodName:"ReqNoListDetail",
            mainId :    "" 
        },
        selectOnCheck: true, //选中行复选框勾选        
        // fitColumns: true,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: true, //多选，为true时只允许选中一行   若注释掉，默认单选
        fit:true,
        columns:FADColumns
    });	

    $("#FAClose").click(function(){
        $FAwin.window('close');
    });
}