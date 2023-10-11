/**
 * FileName: dhcbill.conf.selfpay.test.js
 * Anchor: tangzf
 * Date: 2020-06-30
 * Description: ����ӿڲ���ҳ��
 */
 var GV = {
	CLASSNAME:'BILL.CFG.COM.InterfaceTest',
	PageID:''
}
 $(function () {
	GV.PageID = tkMakeServerCall("web.DHCBillWebPage", "GetWebPageRowId", 'InterfaceTest');
	if(GV.PageID==""){
		$.messager.alert('��ʾ','�����ã�InterfaceTest�������ӿڲ���','info');
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
				"desc":"���",
				selected:true
			},
			{
				"id":"O",
				"desc":"����"	
			},
			{
				"id":"A",
				"desc":"ȫ��"	
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
		$.messager.alert('��ʾ','����Ա����Ϊ��','info');
		return;	
	}
	var selectBusiness = $('#Business').combogrid('grid').datagrid('getSelected');
	if(!selectBusiness){
		$.messager.alert('��ʾ','�ӿڲ���Ϊ��','info');
		return;	
	}
	var inutParam = $('#Input').val();
	if(inutParam==''){
		$.messager.alert('��ʾ','��β���Ϊ��','info');
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
			{ title: '������', field: 'MsgInfoDr', width: 70, hidden: true },
			{ title: 'ҵ�����ʹ���', field: 'OutYWLX', width: 100 },
			{ title: '��־', field: 'OutMsg', width: 400, },
			{ title: '����Ա����', field: 'OutUserCode', width: 70 },
			{ title: '�ǼǺ�', field: 'OutRegNo', width: 90 ,hidden:true},
			{ title: '����', field: 'OutPaName', width: 70,hidden:true },
			{ title: 'ҽ����', field: 'OutInsuNo', width: 80 ,hidden:true},
			{ title: '�����', field: 'OutAdmDr', width: 70 ,hidden:true},
			{ title: '��ƱDr', field: 'OutInvPrtDr', width: 60,hidden:true },
			{ title: '�˵�', field: 'OutPBDr', width: 70 ,hidden:true},
			{ title: '������', field: 'OutSolveFlag', width: 80 ,hidden:true},
			{ title: '�������', field: 'OutResolvent', width: 400, hidden:true},
			{ title: '��������', field: 'OutDate', width: 90 },
			{ title: '����ʱ��', field: 'OutTime', width: 90 },
			{ title: '�����', field: 'OutSolveUser', width: 80,hidden:true },
			{ title: '�������', field: 'OutSolveDate', width: 90,hidden:true },
			{ title: '���ʱ��', field: 'OutSolveTime', width: 90 ,hidden:true},
			{ title: '�ͻ���IP', field: 'OutIPAdress', width: 70,hidden:true },
			{ title: 'MAC', field: 'OutIPMAC', width: 85,hidden:true },
			{ title: '�ͻ�������', field: 'OutCliDate', width: 90 ,hidden:true},
			{ title: '�ͻ���ʱ��', field: 'OutCliTime', width: 90,hidden:true },
			{ title: '��Ʒ��', field: 'ProductLine', width: 100 },
			{ title: '�ͻ�������', field: 'OutCliName', width: 80 ,hidden:true},
			{ title: '��������', field: 'TParamType', width: 80,formatter:function(val){
				return val == "I" ? "���":"����";	
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
				   {title: '����', field: 'ConCode', width: 120},
				   {title: '����', field: 'ConDesc', width: 120},
				   {title: '���', field: 'Coninfo', width: 120}
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
