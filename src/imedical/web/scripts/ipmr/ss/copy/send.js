/**
 * send 病案复印发放
 * 
 * CREATED BY WHui 2021-12-01
 */

// 页面全局变量对象
var globalObj = {
    MrTypeID : '',
	WFItemID : '',
	BWItemID : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

//初始化
function Init(){
	var tdateFrom	= Common_GetDate(-7,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#dfDateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
    Common_ComboToMrType("cboMrType",ServerObj.MrClass);
    InitgridReqList();
    //loadgridReqList();
	getWFItem();
};
	
//事件初始化
function InitEvent(){
    $('#btnSend').click(function(){
		CopySend();
	});
	// 病案号|登记号|条码
    $('#txtNumber').bind('keyup', function(event) {                 
    　　if (event.keyCode == "13") {
            loadgridReqList();
    　　}
    });
    // 病案号|登记号|条码
    $('#txtNumber').bind('keyup', function(event) {                 
    　　if (event.keyCode == "13") {
            loadgridReqList();
    　　}
    });
    $('#btnQry').click(function(){
		loadgridReqList();
	});
};

 // 初始化待发放(装订状态)申请记录表格
 function InitgridReqList(){
	var columns = [[
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'DisLocDesc',title:'出院科室',width:100,align:'left'},
		{field:'DisDate',title:'出院日期',width:100,align:'left'},
		{field:'ClientName',title:'申请人',width:80,align:'left'},
		{field:'ClientRelationDesc',title:'与患者关系',width:100,align:'left'},
		{field:'IdentityCode',title:'证件号',width:180,align:'left'},
		{field:'RegDate',title:'登记日期',width:100,align:'left'},
		{field:'RegTime',title:'登记时间',width:80,align:'left'},
		{field:'LatestStatusDesc',title:'申请状态',width:80,align:'left'},
		{field:'PayStatus',title:'付费状态',width:100,align:'left'},
		{field:'Telephone',title:'联系电话',width:100,align:'left'},
		{field:'ContentDesc',title:'复印内容',width:180,align:'left'},
		{field:'CopyNum',title:'复印份数',width:80,align:'left'}

	]];
	var gridReqList =$HUI.datagrid("#gridReqList",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		     ClassName:"MA.IPMR.SSService.CopyRequestSrv",
			QueryName:"QryReqList",
			aHospID:$('#cboHospital').combobox('getValue'),
			aDateFrom:'',
			aDateTo:'',
			aMrTypeID:'',
			aStatusCode: '',
            aNumber:'',
			aCopyReqID:''
	    },
		columns:columns,
		onBeforeCheck:function(ind,row){
			if(row.PayStatusCode!=1){
				$.messager.popover({msg:'未缴费不允许选中',type:'error'})
				return false;
			} 
		}
	});
	return gridReqList;
}

function loadgridReqList(){
    var Number = $('#txtNumber').val();
    $("#gridReqList").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.CopyRequestSrv",
        QueryName:"QryReqList",
        aHospID:$('#cboHospital').combobox('getValue'),
		aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
		aDateFrom:$('#dfDateFrom').datebox('getValue'),
		aDateTo:$('#dfDateTo').datebox('getValue'),
        aStatusCode: ServerObj.ReqStatus,
        aNumber:Number,
        aCopyReqID:''
	})
	$('#gridReqList').datagrid('unselectAll');
	$('#txtNumber').val('');
}

// 发放
function CopySend(){
	var selData = $('#gridReqList').datagrid('getSelected');
	if (selData==null) {
		$.messager.popover({msg: '必须选中一条申请！',type: 'alert',timeout: 1000});
		return;
	}
	var SendStr	= selData.CopyReqID
	var StatusStr = ServerObj.PassCode + '^' +	// 申请表操作状态
					Logon.UserID + '^' +
					globalObj.WFItemID
	var flg = $m({
		ClassName:"MA.IPMR.SSService.CopyRequestSrv",
		MethodName:"SaveSendReg",
		aSendStr:SendStr,
		aStatusStr:StatusStr,
	},false);
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", flg.split('^')[1], 'error');
		return;
	}else{
		$.messager.popover({msg: '发放成功',type:'success',timeout: 1000});
		loadgridReqList();
	}
}

// 获取取工作流项目
function getWFItem(){
	$m({
		ClassName:"CT.IPMR.BT.MrType",
		MethodName:"GetMrType",
		aMrClass:ServerObj.MrClass,
		aHospitalID:Logon.HospID
	},function(rtn){
		if (rtn==''){
			$.messager.alert("提示", "工作流维护错误，请检查工作流配置!", 'info');
			return;
		}
		rtn = JSON.parse(rtn);
		var MrTypeID = rtn.ID;
		globalObj.MrTypeID = MrTypeID;
		if (MrTypeID=='') {
			$.messager.alert("提示", "获取病案类型失败!", 'info');
			return;
		}
		$m({
			ClassName:"CT.IPMR.BT.WorkFItem",
			MethodName:"GetWFItemBySysOpera",
			aMrTypeID:MrTypeID,
			aSysOpera:'C',
			aWorkSubFlow:''
		},function(rtn){
			if (rtn==''){
				$.messager.alert("提示", "获取工作流项目失败!", 'info');
				return;
			}
			rtn = JSON.parse(rtn);
			globalObj.BWItemID	= rtn.BWItem
			globalObj.WFItemID	= rtn.ID;
		});
	});
}