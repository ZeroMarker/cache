var PageLogicObj={
	m_OrdInfoAuditTab:""
}
$(function(){
	//初始化
	Init();
	InitEvent();
})
function Init(){
	PageLogicObj.m_OrdInfoAuditTab=InitOrdInfoAuditTab();
}
function InitEvent(){
	$("#btnFind").click(function(){
		$("#OrdInfoAuditTab").datagrid('reload');
	});
	$("#SearchPatNo").keydown(function(e){
		if(e.which == 13 || event.which == 9){
			var PatNo = $('#SearchPatNo').val();
			if (PatNo == "") return;
			if (PatNo.length<10) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#SearchPatNo').val(PatNo);
			$("#OrdInfoAuditTab").datagrid('reload');
		}
	})
}
function InitOrdInfoAuditTab(){
	var columns = [[
		{field:'ApplyId',checkbox:true},
		{field:'ApplyUser',title:'申请人',width:100},
		{field:'ApplyDate',title:'申请日期',width:90},
		{field:'ApplyTime',title:'申请时间'},
		{field:'PatInfo',title:'患者信息'},
		{field:'LimitOldOrdInfo',title:'原费别限制用药信息'},
		{field:'LimitNewOrdInfo',title:'目标费别限制用药信息列'},
		{field:'ApplyInfoDetail',title:'申请修改信息'},
		
    ]]
	return $HUI.datagrid("#OrdInfoAuditTab", {
		fit : true,
		border : false,
		striped : true,
		width : 'auto', //
		singleSelect : false,
		fitColumns : false,
		rownumbers:false,
		pagination : true,  
		headerCls:'panel-header-gray',
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocDataChangeApply",
			QueryName : "GetApplyInfoList"
		},
		onBeforeLoad:function(param){
			$("#OrdInfoAuditTab").datagrid('unselectAll');
			param = $.extend(param,{SearchPatNo:$("#SearchPatNo").val(),SearchTableName:ServerObj.ApplyTableName,StartDate:$("#StartDate").datebox('getValue'),EndDate:$("#EndDate").datebox('getValue')});
		},
		columns :columns,
		toolbar:[{
				text:'审核',
				iconCls: 'icon-ok',
				handler: function() {
		            PassApply();
		        }
			},{
				text:'拒绝',
				iconCls: 'icon-no',
				handler: function() {
		            RefuseApply();
		        }
			},'-',{
				text:'取消申请',
				iconCls: 'icon-cancel',
				handler: function() {
		            CancelApply();
		        }
			}
		]
	});
}

function CancelApply(){
	var selected = PageLogicObj.m_OrdInfoAuditTab.getSelections();
	if ((!selected)||(selected=="")) {
		$.messager.alert("提示","请选择需要取消申请的记录！","info")
		return false;
	}
	var ApplyIds = [];
	for (var i=0; i < selected.length; i++) {
		ApplyIds.push(selected[i].ApplyId);
	}
	var result = tkMakeServerCall("web.DHCDocDataChangeApply","CancelApplyMulti", ApplyIds.join("^"),session['LOGON.USERID']);
	if (result != 0) {
		$.messager.alert('提示','取消申请失败！');
		return false;
	}
	$("#OrdInfoAuditTab").datagrid('reload');
	$.messager.popover({msg: '取消申请成功！',type:'success',timeout: 1000});	
}
function RefuseApply(){
	var selected = PageLogicObj.m_OrdInfoAuditTab.getSelections();
	if ((!selected)||(selected=="")) {
		$.messager.alert("提示","请选择需要拒绝申请的记录！","info")
		return false;
	}
	var ApplyIds = [];
	for (var i=0; i < selected.length; i++) {
		ApplyIds.push(selected[i].ApplyId);
	}
	ShowInputReason();
	function ShowInputReason(){
		$.messager.prompt('提示信息', '请输入拒绝申请原因', function(reason){
			if (reason){
				var result = tkMakeServerCall("web.DHCDocDataChangeApply","RefuseApplyMulti", ApplyIds.join("^"),session['LOGON.USERID'],reason);
				if (result != 0) {
					$.messager.alert('提示','拒绝申请失败！');
					return false;
				}
				$("#OrdInfoAuditTab").datagrid('reload');
				$.messager.popover({msg: '拒绝申请成功！',type:'success',timeout: 1000});	
			}else if(reason==""){
				$.messager.alert("提示","请输入拒绝申请原因！","info",function(){
					ShowInputReason();
				});
				return false;
			}
		});
		$(".messager-input").focus();
	}
}
function PassApply(){
	var selected = PageLogicObj.m_OrdInfoAuditTab.getSelections();
	if ((!selected)||(selected=="")) {
		$.messager.alert("提示","请选择需要审核的记录！","info")
		return false;
	}
	var ApplyIds = [];
	for (var i=0; i < selected.length; i++) {
		ApplyIds.push(selected[i].ApplyId);
	}
	var result = tkMakeServerCall("web.DHCDocDataChangeApply","PassApplyMulti", ApplyIds.join("^"),session['LOGON.USERID']);
	if (result != 0) {
		$.messager.alert('提示','审核失败！'+result,"error");
		return false;
	}
	$("#OrdInfoAuditTab").datagrid('reload');
	$.messager.popover({msg: '审核成功！',type:'success',timeout: 1000});
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}