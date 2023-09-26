///添加: lmm 2016-12-09 
///描述:微信操作日志查询
/// -------------------------------
var preRowID=0
var GlobalObj = {
	UserDR : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="User") this.UserDR="";
	},
	ClearAll : function()
	{
		this.UserDR="";
	}
}

$(document).ready(function()
{
	initCombobox();
	initDocument();
	$('#tdhceqwchatoperationlogfind').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		fit:'true',
		queryParams:{
			ClassName:"web.DHCEQWChatUser",
			QueryName:"GetWChatOperationLog",
			Arg1:$("#LogType").combobox('getValue'),
			Arg2:$("#ChatID").val(),
			Arg3:GlobalObj.UserDR,
			Arg4:$("#StartDate").datebox("getText"),
			Arg5:$("#EndDate").datebox("getText"),
			Arg6:$("#MethodDesc").combobox('getValue'),
			ArgCnt:6
			},
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-search',
				text:'查询',
				handler:function(){FindGridData();}
			}
		],
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},  
			{field:'TLogTypeID',title:'日志类型ID',width:100,align:'center',hidden:true}, 
			{field:'TLogType',title:'日志类型',width:100,align:'center'},
			{field:'TChatID',title:'微信ID',width:50,align:'center'}, 
			{field:'TUserDR',title:'用户ID',width:50,align:'center',hidden:true}, 
			{field:'TUser',title:'用户',width:100,align:'center'},
			{field:'TGroupDR',title:'安全组ID',width:100,align:'center',hidden:true},
			{field:'TGroup',title:'安全组',width:100,align:'center'},
			{field:'TLocDR',title:'科室ID',width:100,align:'center',hidden:true},
			{field:'TLoc',title:'科室',width:100,align:'center'},
			{field:'TLogDate',title:'日志日期',width:120,align:'center'}, 
			{field:'TLogTime',title:'日志时间',width:120,align:'center'},
			{field:'TBindType',title:'绑定类型',width:55,align:'center'},
			{field:'TPermission',title:'许可',width:50,align:'center'},
			{field:'TMethodCode',title:'方法代码',width:55,align:'center'},
			{field:'TMethodDescC',title:'方法描述',width:270,align:'center'},
			{field:'TMethodDescE',title:'方法描述(类)',width:270,align:'center',hidden:true},
			]],
		onClickRow:function(rowIndex,rowData){OnclickRow();},
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75]
	});
	
});
function ClearElement()
{
	$('#RowID').val('');
	$('#LogType').combobox('setValue',"");
	$('#ChatID').val('');
	$('#UserDR').combogrid('setValue','');
	$('#UserDR').combogrid('setText','');
	$('#StartDate').datebox('setValue','');
	$('#EndDate').datebox('setValue','');
	$('#MethodDesc').combobox('setValue',"");

}

function initDocument()
{
	GlobalObj.ClearAll();
	initUserPanel();
	initUserData();
}

function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if (vElementID=="User") {initUserData();}
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="User") {GlobalObj.UserDR = CurValue;}
}


function FindGridData() 
{
	$('#tdhceqwchatoperationlogfind').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:'web.DHCEQWChatUser',
			QueryName:'GetWChatOperationLog',
			Arg1:$("#LogType").combobox('getValue'),
			Arg2:$("#ChatID").val(),
			Arg3:GlobalObj.UserDR,
			Arg4:$("#StartDate").datebox("getText"),
			Arg5:$("#EndDate").datebox("getText"),
			Arg6:$("#MethodDesc").combobox('getValue'),
			ArgCnt:6
		}
	});
}




function initCombobox()
{	
	jQuery("#StartDate").datebox("setText",jQuery("#CurDate").val());
	if (jQuery("#MethodDesc").prop("type")!="hidden")
	{
		jQuery("#MethodDesc").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: '全部'
			},{
				id: '0001',
				text: '扫描设备条码得到设备基本信息'
			},{
				id: '0002',
				text: '维修基础数据'
			},{
				id: '0003',
				text: '保存维修单'
			},{
				id: '0004',
				text: '自动保存维修对象'
			},{
				id: '0005',
				text: '待操作维修单据查询'
			},{
				id: '0006',
				text: '提交维修单'
			},{
				id: '0007',
				text: '维修受理,完成操作'
			},{
				id: '0008',
				text: '获取维修图片'
			},{
				id: '0010',
				text: '获取一个维修单据'
			},{
				id: '0011',
				text: '获取维修评价项目'
			},{
				id: '0012',
				text: '获取评价列表'
			},{
				id: '0013',
				text: '根据用户获取科室'
			},{
				id: '0014',
				text: '保存维修评价信息'
			},{
				id: '0015',
				text: '远程获取FTP信息'
			},{
				id: '0018',
				text: '获取单个设备维修单'
			},{
				id: '0019',
				text: '保存维修进度报告'
			},{
				id: '0020',
				text: '获取维修进度报告信息'
			},{
				id: '0021',
				text: '获取一个评价信息'
			},{
				id: '0022',
				text: '保存维修图片信息'
			},{
				id: '0023',
				text: '获取维修图片信息'
			},{
				id: '0024',
				text: '获取安全组可访问菜单代码'
			},{
				id: '0025',
				text: '维修待办列表'
			},{
				id: '0026',
				text: '紧急程度'
			},{
				id: '0027',
				text: '人员列表'
			},{
				id: '0028',
				text: '故障类型'
			},{
				id: '0029',
				text: '故障原因'
			},{
				id: '0030',
				text: '解决方法'
			},{
				id: '0031',
				text: '维修方式'
			},{
				id: '0032',
				text: '待办业务列表'
			},{
				id: '0033',
				text: '故障现象'
			},{
				id: '0034',
				text: '获取可编辑字段'
			},{
				id: '0035',
				text: '获取审批流类型'
			},{
				id: '0036',
				text: '获取可转向步骤'
			},{
				id: '0037',
				text: '获取审批流信息'
			},{
				id: '0038',
				text: '严重程度'
			},{
				id: '0039',
				text: '维修个人列表'
			},{
				id: '0040',
				text: '服务商'
			},{
				id: '0041',
				text: '维修结果'
			},{
				id: '0042',
				text: '验证登陆信息是否正确'
			},{
				id: '0043',
				text: '获取安全组登陆科室'
			},{
				id: '0044',
				text: '验证安全组是否正确'
			},{
				id: '0045',
				text: '绑定id'
			},{
				id: '0046',
				text: '检验用户微信是否绑定'
			},{
				id: '0047',
				text: '消息获取'
			},{
				id: '0048',
				text: 'FTP服务器下载'
			},{
				id: '0049',
				text: '维修人员信息'
			},{
				id: '0050',
				text: '维修配件增删改'
			},{
				id: '0051',
				text: '配件明细提交审核'
			},{
				id: '0052',
				text: '配件明细取消提交审核'
			},{
				id: '0053',
				text: '维修单配件列表信息'
			},{
				id: '0054',
				text: '生产厂商'
			},{
				id: '0055',
				text: '供应商'
			},{
				id: '0056',
				text: '配件类组'
			},{
				id: '0057',
				text: '配件项列表信息'
			},{
				id: '0058',
				text: '更新图片上传标志'
			},{
				id: '0059',
				text: '报表统计'
			},{
				id: '0060',
				text: '单条配件信息'
			},{
				id: '0061',
				text: '租赁设备信息'
			},{
				id: '0062',
				text: '租赁设备项'
			},{
				id: '0063',
				text: '获取租赁中心科室ID'
			},{
				id: '0064',
				text: '租赁调用SavaData方法'
			},{
				id: '0065',
				text: '根据ID获取租赁明细'
			},{
				id: '0066',
				text: '获取台账表设备信息'
			},{
				id: '0067',
				text: '租赁单据列表'
			},{
				id: '0068',
				text: '过滤已租赁未归还设备'
			},{
				id: '0069',
				text: '获取主界面菜单信息'
			},{
				id: '0070',
				text: '获取审批进度信息'
			},{
				id: '0071',
				text: '获取维修对象列表'
			}],
			
			onSelect: function() {}
		});
			}
	}

