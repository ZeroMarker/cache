/**
 * FileName: dhcbill.conf.selfpay.test.js
 * Anchor: tangzf
 * Date: 2020-06-30
 * Description: 对外接口测试页面
 */
 var GV = {
	CLASSNAME:'BILL.CFG.COM.InterfaceTest',
	PageID:''
}
 $(function () {
	GV.PageID = tkMakeServerCall("web.DHCBillWebPage", "GetWebPageRowId", 'InterfaceTest');
	if(GV.PageID==""){
		$.messager.alert('提示','请配置：InterfaceTest第三方接口测试','info');
	}
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0)); 
	
	init_User();
	
	
	init_Business();
	
	init_dg();
	
	$HUI.linkbutton("#Done", {
		onClick: function () {
			CallMethod();
		}
	});
	$HUI.linkbutton("#Find", {
		onClick: function () {
			LoadDataGrid();
		}
	});
	
	$('#ParamType').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				"id":"I",
				"desc":"入参",
				selected:true
			},
			{
				"id":"O",
				"desc":"出参"	
			},
			{
				"id":"A",
				"desc":"全部"	
			}
			
		
		]	
	});
	
});
function init_User(){
	$HUI.combobox(('#UserCode'),{
		defaultFilter:'4',
		valueField: 'Code',
		textField: 'Desc',
		url:$URL,
		onSelect:function(){
		},
		onLoadSuccess:function(data){

		}
		,onBeforeLoad: function(param) {
			param.ClassName = 'INSU.COM.BaseData';
			param.QueryName= 'FindSSUser';
			param.HospId = session['LOGON.HOSPID'];
			param.ResultSetType = 'array';
			return true;
		}		
	})		
}
function CallMethod(){
	$("#Output").val("");
	var UserCode = getValueById('UserCode');
	if(UserCode==''){
		$.messager.alert('提示','操作员不能为空','info');
		return;	
	}
	var selectBusiness = $('#Business').combogrid('grid').datagrid('getSelected');
	if(!selectBusiness){
		$.messager.alert('提示','接口不能为空','info');
		return;	
	}
	var inutParam = $('#Input').val();
	if(inutParam==''){
		$.messager.alert('提示','入参不能为空','info');
		return;	
	}
	$.cm({
		ClassName:GV.CLASSNAME,
		MethodName:	"DoSelfPayInterfaceMethod",
		RequestStr : inutParam,
		Class : '',
		Method : '',
		User : UserCode,
		ExpStr: 'APPPay|' + selectBusiness.ConCode + '|' + PUBLIC_CONSTANT.SESSION.HOSPID
	},function (objScope){
		LoadDataGrid();
		$("#Output").val("");
		if(objScope){
			if(objScope.msg){
				$("#Output").val(objScope.msg);
			}else{
				$("#Output").val(objScope.result);
			}
		}
	})	
}
function init_dg(){
	$HUI.datagrid("#dg", {
		fit: true,
		border:false,
		nowrap: true,
		striped: true,
		pagination: true,
		singleSelect: true,
		collapsible: true,
		pageSize:30,
		pageList:[10,20,30],
		columns: [[
			{ title: '导航号', field: 'MsgInfoDr', width: 70, hidden: true },
			{ title: '业务类型代码', field: 'OutYWLX', width: 100 },
			{ title: '日志', field: 'OutMsg', width: 400, },
			{ title: '操作员工号', field: 'OutUserCode', width: 70 },
			{ title: '登记号', field: 'OutRegNo', width: 90 ,hidden:true},
			{ title: '姓名', field: 'OutPaName', width: 70,hidden:true },
			{ title: '医保号', field: 'OutInsuNo', width: 80 ,hidden:true},
			{ title: '就诊号', field: 'OutAdmDr', width: 70 ,hidden:true},
			{ title: '发票Dr', field: 'OutInvPrtDr', width: 60,hidden:true },
			{ title: '账单', field: 'OutPBDr', width: 70 ,hidden:true},
			{ title: '解决标记', field: 'OutSolveFlag', width: 80 ,hidden:true},
			{ title: '解决方法', field: 'OutResolvent', width: 400, hidden:true},
			{ title: '插入日期', field: 'OutDate', width: 90 },
			{ title: '插入时间', field: 'OutTime', width: 90 },
			{ title: '解决人', field: 'OutSolveUser', width: 80,hidden:true },
			{ title: '解决日期', field: 'OutSolveDate', width: 90,hidden:true },
			{ title: '解决时间', field: 'OutSolveTime', width: 90 ,hidden:true},
			{ title: '客户端IP', field: 'OutIPAdress', width: 70,hidden:true },
			{ title: 'MAC', field: 'OutIPMAC', width: 85,hidden:true },
			{ title: '客户端日期', field: 'OutCliDate', width: 90 ,hidden:true},
			{ title: '客户端时间', field: 'OutCliTime', width: 90,hidden:true },
			{ title: '产品线', field: 'ProductLine', width: 100 },
			{ title: '客户端名称', field: 'OutCliName', width: 80 ,hidden:true},
			{ title: '参数类型', field: 'TParamType', width: 80,formatter:function(val){
				return val == "I" ? "入参":"出参";	
			} }
			
		]],
		data:[],
		onSelect:function(index,rowData){
			setValueById('Output',rowData.OutMsg)
		}
	});
}
function LoadDataGrid(){
	var ParamType = getValueById('ParamType')
	if(ParamType == "A"){
		ParamType = ""; 
	}
	var param = {
		ClassName : 'web.INSUMsgInfo',
		QueryName: 'GetINMSGInfo',	
		StartDate : getValueById('StartDate'),
		EndDate : getValueById('EndDate'), 
		DateFlag : 'true', 
		ParamProductLine : getValueById('ProductLine'), 
		YWLX : $('#Business').combobox('getValue'), 
		HospId : PUBLIC_CONSTANT.SESSION.HOSPID, 
		PatNo : getValueById('PatNo'),
		UserCode:getValueById('UserCode'),		
		ExpStr: '|' + ParamType	
	}	
	loadDataGridStore('dg',param)
}
function init_Business(){
	$('#Business').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'ConCode',   
	    textField:'ConDesc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'web.DHCBillPageConf';
	      	param.QueryName = 'FindInterfaceTest';
	      	param.pageId = GV.PageID;
	      	param.site = 'HOSPITAL';
	      	param.code = '';
	      	param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;

	     },
		columns: [[{title: 'confId', field: 'confId', hidden: true},
				   {title: '代码', field: 'ConCode', width: 120},
				   {title: '名称', field: 'ConDesc', width: 120},
				   {title: '入参', field: 'Coninfo', width: 120}
			]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		},
		onSelect:function(index,data){
			BuildInutParam(index,data);
		}
	}); 
}
///
function BuildInutParam(index,data){
	$('#Input').val('');
	$('#Input').val(data.Coninfo);

}
