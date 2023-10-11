/**
 * copyord.js
 * 
 * Copyright (c) 2021-2022 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2021-01-18
 * 
 * 
 */
var PGObject = {
	
}

$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox();
}

function InitEvent () {
	$("#Save").click(Save_Handle)
	$("#Clean").click(Clean_Handle)
}

function InitCombox() {
	
	//��ȫ����Ȩ
	var recItemTmpl='\
		<div class="authgroup" title="���Ƶ�������Ŀ��[${desc}]" data-id="${id}" id="authgroup-${id}"><span>${desc}</span><span class="Delete" title="�Ƴ�">&times;</span></div>\
	';
	$.template('template', recItemTmpl);
	$('#auth-groups').on('click','.Delete',function(){
		$(this).parent().remove();
	})
	$('#AuthGroup').combogrid({
		width:300,
		panelWidth:300,
		panelHeight:300,
		showHeader:false,
		disabled:false,
		delay: 500,
		mode: 'remote',
		defaultFilter:4,
		queryParams:{ClassName:"web.PilotProject.DHCDocPilotProject",QueryName: "FindProject",desc:""},  //��ΪBSP.GRPHOSP.SRV.SSGroup
		url: $URL,
		idField: 'TPPRowId',
		textField: 'TPPDesc',
		onBeforeLoad:function(param){
			param = $.extend(param,{PPDesc:param.q});
			param.Flag=ServerObj.InHosp
			param.Exp="^^^^"+ServerObj.InHosp
			return true;
		},
		onHidePanel:function(){
			var row=$('#AuthGroup').combogrid("grid").datagrid("getSelected");
			if(row&&(row.TPPRowId>0)){
				var temp={id:row.TPPRowId,desc:row.TPPCode+" "+row.TPPDesc};
				insertAuthGroup(temp);
				$('#AuthGroup').combogrid('clear');
			}
		},	
		columns: [[{field:'TPPCode',title:'��Ŀ���',width:100},{field:'TPPDesc',title:'������Ŀ',width:200},{field:'TPPRowId',title:'TPPRowId',align:'right',hidden:true,width:0}]],
		pagination:false
		,lazy:true
	});
	
	
	
	return false;
	PGObject.m_Stage = $HUI.combobox("#PPFPrjStage", {
		url:$URL+"?ClassName=web.PilotProject.Extend.Stage&QueryName=QryStage&PrjDR="+ServerObj.PPRowId+"&ResultSetType=array",
		valueField:'id',
		textField:'stageDesc',
		//required:true,
		blurValidValue:true
	});
	
}

function insertAuthGroup(obj){
	if (obj.id == ServerObj.PPRowId) {
		$.messager.alert("��ʾ","���ܸ�������","warning")
		return false;
	}
	if($("#authgroup-"+obj.id).length>0) return;
	$.tmpl('template', obj).appendTo('#auth-groups');
}

function Clean_Handle() {
	$('#auth-groups').empty();	
}

function Save_Handle () {
	
	var authinfo="";
	$('.authgroup').each(function(i){
		if(i==0) authinfo=$(this).data('id');
		else  authinfo=authinfo+","+$(this).data('id');
	})
	
	if (authinfo == "") {
		$.messager.alert("��ʾ","��ѡ���Ƶ���һ��Ŀ��","warning")
		return false;
	}
	
	var ExpStr = session['LOGON.USERID']+"^"+session['LOGON.CTLOCID'];
	
	$.messager.confirm("��ʾ", "�����ڵĽ׶ν��Զ���������ȷ�ϼ���ô��",function (r) {
		if (r) {
			$m({
					ClassName: "web.PilotProject.CFG.FindGCP",
					MethodName: "CopyAllFreeOrder",
					FromPrj:ServerObj.PPRowId,
					ToPrj: authinfo,
					ExpStr:ExpStr,
					dataType:"text"
				},function(result){
					result = result.split("^")
					if (result[0]>=0) {
						$.messager.alert("��ʾ","���Ƴɹ���","info",function () {
							websys_showModal("hide");
							//websys_showModal('options').CallBackFunc();
							websys_showModal("close");	
						})
						return false;
					} else {
						$.messager.alert("��ʾ","����ʧ�ܣ�","warning")
						return false;
					}
			});

		
		}
		
	});
	
	
	
}
