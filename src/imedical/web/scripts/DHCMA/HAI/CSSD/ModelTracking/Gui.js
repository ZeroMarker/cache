//器械追溯查询 
//页面Gui
var objScreen = new Object();
function InitAssRateWin(){
	var obj = objScreen;
    var objSttDate = '';
	var objEndDate = '';	
    //获取数据	
    //医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital", $.LOGON.HOSPID);
	var aDateType=$('#SendDate').val();
	// 日期初始赋值
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);	
	
	
	var aBarCode = $("#txtRegNo").val();
	var aBatchNumberS=$("#textBatchNum").val();
	var aPatNo = $("#txtPapmiNo").val();
	
	
	obj.dtDateFrom = $('#StartDate').datebox('setValue', DateFrom);    // 日期初始赋值
	obj.dtDateTo = $('#EndDate').datebox('setValue', Common_GetDate(new Date()));
	var aDateFrom=$('#StartDate').datebox('getValue');
	var aDateTo=$('#EndDate').datebox('getValue');

    obj.gridAssRate = $HUI.datagrid("#AssessRate",{
		fit:true,
        title:'消毒器械追踪',
        toolbar:'#ToolBar',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'BarDesc',title:'消毒包名',width:150,align:'center',},
			{ field: 'BarCode', title: '器械条码', width: 190, align: 'center',},
            { field: 'BatchG', title: '灭菌锅号', width: 80, align: 'center', },
            {field: 'BatchNum', title: '灭菌锅次', width: 160, align: 'center',},
            { field: 'PatName', title: '病人', width: 160, align: 'center' },
            { field: 'PatNo', title: '登记号', width: 140, align: 'center', },
			{ field: 'LocDr', title: '绑定(使用)科室', width: 140, align: 'center' ,},
            { field: 'Send', title: '发放时间', width: 170, align: 'center' },
			{ field: 'SendUser', title: '发放人', width: 120, align: 'center' },
			{field:'Clean',title:'清洗时间',width:170,align:'center'},
			{field:'CleanUser',title:'清洗人',width:120,align:'center'},
			{field:'Steril',title:'灭菌时间',width:170,align:'center'},
			{field:'SterilUser',title:'灭菌人',width:120,align:'center'},
			{field:'Back',title:'回收时间',width:170,align:'center'},
			{ field: 'BackUser', title: '回收人', width: 120, align: 'center' }
		]],
		toolbar:[
			    {
			        text: '打印', id: 'btnPrint', iconCls: 'icon-print', handler: function () {
			            obj.btnPrint();
			        }
			    },
                { 
                    text: '导出', id: 'btnExport', iconCls: 'icon-save', handler: function () {
                        obj.btnexport();
                    }
                }],
        onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
   
	InitAssRateWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


