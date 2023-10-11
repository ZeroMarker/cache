var PageLogicObj={
	m_OrdInfoAuditTab:""
}
$(function(){
	//��ʼ��
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
		{field:'ApplyUser',title:'������',width:100},
		{field:'ApplyDate',title:'��������',width:90},
		{field:'ApplyTime',title:'����ʱ��'},
		{field:'PatInfo',title:'������Ϣ'},
		{field:'LimitOldOrdInfo',title:'ԭ�ѱ�������ҩ��Ϣ'},
		{field:'LimitNewOrdInfo',title:'Ŀ��ѱ�������ҩ��Ϣ��'},
		{field:'ApplyInfoDetail',title:'�����޸���Ϣ'},
		
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
				text:'���',
				iconCls: 'icon-ok',
				handler: function() {
		            PassApply();
		        }
			},{
				text:'�ܾ�',
				iconCls: 'icon-no',
				handler: function() {
		            RefuseApply();
		        }
			},'-',{
				text:'ȡ������',
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
		$.messager.alert("��ʾ","��ѡ����Ҫȡ������ļ�¼��","info")
		return false;
	}
	var ApplyIds = [];
	for (var i=0; i < selected.length; i++) {
		ApplyIds.push(selected[i].ApplyId);
	}
	var result = tkMakeServerCall("web.DHCDocDataChangeApply","CancelApplyMulti", ApplyIds.join("^"),session['LOGON.USERID']);
	if (result != 0) {
		$.messager.alert('��ʾ','ȡ������ʧ�ܣ�');
		return false;
	}
	$("#OrdInfoAuditTab").datagrid('reload');
	$.messager.popover({msg: 'ȡ������ɹ���',type:'success',timeout: 1000});	
}
function RefuseApply(){
	var selected = PageLogicObj.m_OrdInfoAuditTab.getSelections();
	if ((!selected)||(selected=="")) {
		$.messager.alert("��ʾ","��ѡ����Ҫ�ܾ�����ļ�¼��","info")
		return false;
	}
	var ApplyIds = [];
	for (var i=0; i < selected.length; i++) {
		ApplyIds.push(selected[i].ApplyId);
	}
	ShowInputReason();
	function ShowInputReason(){
		$.messager.prompt('��ʾ��Ϣ', '������ܾ�����ԭ��', function(reason){
			if (reason){
				var result = tkMakeServerCall("web.DHCDocDataChangeApply","RefuseApplyMulti", ApplyIds.join("^"),session['LOGON.USERID'],reason);
				if (result != 0) {
					$.messager.alert('��ʾ','�ܾ�����ʧ�ܣ�');
					return false;
				}
				$("#OrdInfoAuditTab").datagrid('reload');
				$.messager.popover({msg: '�ܾ�����ɹ���',type:'success',timeout: 1000});	
			}else if(reason==""){
				$.messager.alert("��ʾ","������ܾ�����ԭ��","info",function(){
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
		$.messager.alert("��ʾ","��ѡ����Ҫ��˵ļ�¼��","info")
		return false;
	}
	var ApplyIds = [];
	for (var i=0; i < selected.length; i++) {
		ApplyIds.push(selected[i].ApplyId);
	}
	var result = tkMakeServerCall("web.DHCDocDataChangeApply","PassApplyMulti", ApplyIds.join("^"),session['LOGON.USERID']);
	if (result != 0) {
		$.messager.alert('��ʾ','���ʧ�ܣ�'+result,"error");
		return false;
	}
	$("#OrdInfoAuditTab").datagrid('reload');
	$.messager.popover({msg: '��˳ɹ���',type:'success',timeout: 1000});
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