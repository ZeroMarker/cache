/**
 * lend 病案借阅
 * 
 * Copyright (c) 2018-2021 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2021-09-09
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_WFIConfig :'',	 
	m_ToUserID 	:'',
    EpisodeIDs	:'',
	LendInfo	:'',
	row 		:''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	var tdateFrom	= Common_GetDate(-7,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#applyDateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#applyDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboGridToUser("cboApplyUser","");
	InitgridLendRequest();
	Common_ComboToDic("cboPurpose","LendPurpose",1,'');
	Common_ComboToLoc("cboLendLoc","","E",Logon.HospID,'I','');
	Common_ComboGridToUser("cboLendUser","");
}

function InitEvent(){
	$('#btnQry').click(function(){
		loadgridLendRequest();
	});
}

/**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 申请记录
 * DATE: 2021-09-11
 * NOTE: 包括方法：
 * TABLE: 
 */
// 初始化申请记录表格
function InitgridLendRequest(){
	var columns = [[
		{field:'LocDesc',title:'申请科室',width:100,align:'left'},
		{field:'UserDesc',title:'申请人',width:100,align:'left'},
		{field:'Unit',title:'医生资格证书号',width:100,align:'left'},
		{field:'RequestDate',title:'申请日期',width:100,align:'left'},
		{field:'LendTypeDesc',title:'借阅病历类型',width:100,align:'left'},
		{field:'LendPurposeDesc',title:'借阅目的',width:100,align:'left'},
		{field:'o',title:'操作',width:80,align:'left',
			formatter:function(value,row,index) {
            	var RequestID = row.ID;
				var VolCount = row.VolCount;
				globalObj.row=row;
				var desc = $g('借出');
               	return '<a href="#" class="grid-td-text-gray" onclick = showLendOut()>' + desc + '</a>';            
            }
		},
		{field:'VolCount',title:'申请病历数',width:80,align:'left',
			formatter:function(value,row,index) {
            	var RequestID = row.ID;
				var VolCount = row.VolCount;
               	return '<a href="#" class="grid-td-text-gray" onclick = showRequestVol(' + RequestID + ')>' + VolCount + '</a>';            
            }
		}
	]];
	var gridLendRequest =$HUI.datagrid("#gridLendRequest",{
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
		    ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
			QueryName:"QryLendRequest",
			aLendTypeID: ServerObj.PaperLendTypeID,
			aDateFrom:'',
			aDateTo:'',
			aStatusID:'',
			aHospID:'',
			aUserID:'',
			aLocID:''
	    },
		columns:columns
	});
	return gridLendRequest;
}

// 刷新申请记录数据
function loadgridLendRequest() {
	var ApplyUser = "";
	var objApplyUser = $('#cboApplyUser').combogrid('grid').datagrid('getSelected');
	if (objApplyUser!==null){
		var ApplyUser = objApplyUser.ID;
	}
	
	$("#gridLendRequest").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
			QueryName:"QryLendRequest",
			aLendTypeID: ServerObj.PaperLendTypeID,
			aDateFrom:$('#applyDateFrom').datebox('getValue'),
			aDateTo:$('#applyDateTo').datebox('getValue'),
			aStatusID:ServerObj.RquestStatusID,
			aHospID:$('#cboHospital').combobox('getValue'),
			aUserID:ApplyUser,
			aLocID:''
	})
	$('#gridLendRequest').datagrid('unselectAll');
}

/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 申请记录病历列表弹框
 * DATE: 2021-09-11
 * NOTE: 包括方法：
 * TABLE: 
 */
function showRequestVol(RequestID) {
	var Columns = [[
		{field: 'MrNo', title: '病案号', width: 100, align: 'left'},
		{field: 'PapmiNo', title: '登记号', width: 120, align: 'left'},
		{field: 'PatName', title: '姓名', width: 100, align: 'left'},
		{field: 'AdmTimes', title: '住院次数', width: 80, align: 'left'},
		{field: 'Sex', title: '性别', width: 80, align: 'left'},
		{field: 'Age', title: '年龄', width: 80, align: 'left'},
		{field: 'AdmDate', title: '入院日期', width: 150, align: 'left'},
		{field: 'DisDate', title: '出院日期', width: 150, align: 'left'},
		{field: 'AdmLoc', title: '入院科室', width: 150, align: 'left'},
		{field: 'DisLoc', title: '出院科室', width: 150, align: 'left'},
		{field:'VolStatusDesc',title:'病历状态',width:120,align:'left'}
	]];
	var gridRequestVol = $HUI.datagrid("#gridRequestVol", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 100,
		pageList:[100,200,500,1000],
		fitColumns:true,
	    url:$URL,
	    queryParams : {
		    ClassName : "MA.IPMR.SSService.VolLendRequestSrv",
			QueryName : "QryRequestVol",
			aRequestID : RequestID
	    },
	    columns : Columns
	});
	var RequestVolDialog = $('#RequestVolDialog').dialog({
	    title: '借阅病历列表',
		iconCls: 'icon-w-edit',
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
}

/**
 * NUMS: D003
 * CTOR: LIYI
 * DESC: 借出弹框
 * DATE: 2021-09-11
 * NOTE: 包括方法：
 * TABLE: 
 */
function showLendOut() {
	var row=globalObj.row;
	$("#txtRequestId").val(row.ID);
	$("#cboLendLoc").combobox('setValue',row.LocID);
	Common_SetComboGridToUserValue('#cboLendUser',row.UserDesc,row.UserID,row.UserDesc);
	$("#cboPurpose").combobox('setValue',row.LendPurposeIDs);
	$("#ExpBackDate").datebox('setValue',row.ExpBackDate);
	$("#txtResume").val(row.Resume);
	
	var columns = [[
		{field:'gVolSel_ck',title:'sel',checkbox:true},
		{field:'VolStatusDesc',title:'病历状态',width:80,align:'left'},
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'PatName',title:'姓名',width:80,align:'left'},
		{field: 'Sex', title: '性别', width: 60, align: 'left'},
		{field: 'Age', title: '年龄', width: 60, align: 'left'},
		{field: 'AdmDate', title: '入院日期', width: 90, align: 'left'},
		{field: 'DisDate', title: '出院日期', width: 90, align: 'left'},
		{field: 'DisLoc', title: '出院科室', width: 80, align: 'left'}
	]];
	var gridAdmList =$HUI.datagrid("#gridAdmList",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 100,
		fitColumns:false,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
			QueryName:"QryRequestVol",
			aRequestID : row.ID
	    },
		columns:columns,
		onLoadSuccess: function (data) {
			for (var i = 0; i < data.rows.length; i++) {
				if (data.rows[i].ProblemCode !== '1') {			// 根据ProblemCode让某些行不可选
					$("#divAdmList input:checkbox[name='gVolSel_ck']")[i].disabled = true;
				}
			} 
			$("#divAdmList .datagrid-header-check input").change( function() {
				var status = this.checked;
				$("#divAdmList input:checkbox[name='gVolSel_ck']").each(function(index, el){
					if (data.rows[index].ProblemCode!=='1')
					{
						this.checked=false;
						$("#gridAdmList").datagrid("unselectRow",index);
					}else{
						this.checked=true;
						$("#gridAdmList").datagrid("selectRow",index);
					}
				})
			});
		},
		onClickRow: function(rowIndex, rowData){
			if (rowData.ProblemCode!=='1'){
				$('#gridAdmList').datagrid('unselectRow', rowIndex)
			}
		}	
	});
	var LendOutDialog = $('#LendOutDialog').dialog({
	    title: '病案借出',
		iconCls: 'icon-w-edit',
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					LendOut();
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				closeLendOutDialog();
			}	
		}]
	});
}

function LendOut(){
	var lend_Id			= '';
	var lend_Loc		= $("#cboLendLoc").combobox('getValue');
	var lend_LocTel		= $("#txtLendLocTel").val();
	var objLendUser = $('#cboLendUser').combogrid('grid').datagrid('getSelected');
	var lend_User ='';
	if (objLendUser!==null){
		lend_User = objLendUser.ID;
	}
	var lend_UserTel	= $("#txtLendUserTel").val();
	
	var Purpose	= $('#cboPurpose').combobox('getValue');
	var ExpBackDate		= $('#ExpBackDate').datebox('getValue');
	var lend_Resume		= $("#txtResume").val();
	
	var selVolData	= $('#gridAdmList').datagrid('getSelections');
	if (!lend_Loc) {
		$.messager.popover({msg: '借阅科室必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!lend_LocTel) {
		$.messager.popover({msg: '科室电话必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!lend_User) {
		$.messager.popover({msg: '借阅人员必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!lend_UserTel) {
		$.messager.popover({msg: '借阅人电话必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!Purpose) {
		$.messager.popover({msg: '借阅目的必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!ExpBackDate) {
		$.messager.popover({msg: '预计归还日期必填！',type: 'alert',timeout: 1000});
		return
	}
	if (!selVolData.length) {
		$.messager.popover({msg: '请选择需要借出的病历！',type: 'alert',timeout: 1000});
		return
	}
	var LendInfo = lend_Id + "^";
		LendInfo += lend_Loc + "^";
		LendInfo += lend_LocTel + "^";
		LendInfo += lend_User + "^";
		LendInfo += lend_UserTel + "^";
		LendInfo += Purpose + "^";
		LendInfo += ExpBackDate + "^";
		LendInfo += lend_Resume;
	var EpisodeIDs = '';
	var MrTypeArr = [];
	for (var i = 0; i < selVolData.length; i++) {
		var selRowArray = selVolData[i];
		EpisodeIDs += ',' + selRowArray.EpisodeID;
		var MrTypeID = selRowArray.MrTypeID
		var isMrTypeInArr=0
		for (j=0;j<MrTypeArr.length;j++){
			if (MrTypeArr[j]==MrTypeID) isMrTypeInArr=1;
		}
		if (isMrTypeInArr==0) MrTypeArr.push(MrTypeID);
		
	}
	// 验证对应病案类型是否需要验证用户，只要其中一个类型有验证就需要验证
	var checkWorkFlowFlg = 0;
	var CheckUser = 0;
	for  (var i = 0; i < MrTypeArr.length; i++) {
		var rtn = $m({
			ClassName:"CT.IPMR.BT.WorkFItem",
			MethodName:"GetWFItemBySysOpera",
			aMrTypeID:MrTypeArr[i],
			aSysOpera:'H',
			aWorkSubFlow:'L'
		},false);
		if (rtn==''){
			checkWorkFlowFlg = 1;
		}else{
			rtn = JSON.parse(rtn);
			if (rtn.BWCheckUser==1) {
				globalObj.m_WFIConfig = {
					CheckUser	: rtn.BWCheckUser
				}
			}
		}
	}
	if (checkWorkFlowFlg==1) {
		$.messager.alert("提示", "工作流维护错误，请检查工作流配置!", 'info');
		return;
	}
	if (EpisodeIDs != '') EpisodeIDs = EpisodeIDs.substr(1,EpisodeIDs.length-1);
	globalObj.EpisodeIDs= EpisodeIDs;
	globalObj.LendInfo=LendInfo;
	SaveOpera(2,EpisodeIDs,LendInfo)
}

// 保存操作( 提交借阅调用 step=2,校验用户页面调用step=3)
function SaveOpera(Step){
	if (Step<3){
		if ((globalObj.m_WFIConfig.CheckUser == '1')&&(ServerObj.EnsSysConfig=='0')){	// 独立服务器部署不校验用户
			InitCheckUser();
			return;
		}
	}
	var flg = $m({
		ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		MethodName:"LendOutByRequest",
		aRequestID:$("#txtRequestId").val(),
		aEpisodeIDs:globalObj.EpisodeIDs,
		aLendInfo:globalObj.LendInfo,
		aUserID:Logon.UserID,
		aToUserID:globalObj.m_ToUserID
	},false);
	if (parseInt(flg) == 0) {
		globalObj.m_ToUserID='';
		closeLendOutDialog();
		loadgridLendRequest();
	}else{
		if (parseInt(flg) >0) {
			$("#gridAdmList").datagrid("reload", {
				ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
				QueryName:"QryRequestVol",
				aRequestID : $("#txtRequestId").val()
			})
			$.messager.alert("提示", '有'+parseInt(flg)+'份病历操作失败！', 'info');
			return;
		}
		
	}
}

function closeLendOutDialog(){
	$("#cboLendLoc").combobox('setValue','');
	$("#txtLendLocTel").val('');
	$("#cboLendUser").combobox('setValue','');
	$("#txtLendUserTel").val('');
	$("#cboPDFModel").combobox('setValue','');
	$("#cboPurpose").combobox('setValue','');
	$("#ExpBackDate").datebox('setValue','');
	$("#txtResume").val('');
	$("#gridAdmList").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		QueryName:"QryRequestVol",
		aRequestID : ''
	})
	$('#LendOutDialog').window("close");
}