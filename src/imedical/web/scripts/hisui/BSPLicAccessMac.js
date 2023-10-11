// BSPLicAccessMac.js
selectedTimeLineInd = 0;
$.extend($.fn.datagrid.defaults.view,{
	onAfterRender:function(target){
		var h = $(window).height();
		var offset = $(target).closest('.i-tableborder').offset();
		$(target).datagrid('resize',{height:parseInt(h-offset.top-18)});
	}
});
function openEntityLog(LicUserOrHosp){
	websys_lu('websys.default.hisui.csp?WEBSYS.TCOMPONENT=BSPLicEntityLog&UserOrHosp='+LicUserOrHosp);
};
function AccessCBClick(flag){
	var successTip = "�ɹ�����Mac׼�����",failTip="����Mac׼�����ʧ��";
	if (flag==0){successTip = "�ɹ�����Mac׼�����",failTip="����Mac׼�����ʧ��";}	
	$cm({ClassName:"BSP.Lic.Entity",MethodName:"AccessMac",Flag:flag,dataType:'text'},function(rtn){
		if(rtn==1){
			$.messager.alert("��ʾ",successTip);
			$("#accessMacGrid").datagrid("load");
		}else{
			$.messager.alert("ʧ��",failTip);
		}
	});

}
var initPage = function(){
	var LicInfo = $("#LicInfo").val();
	var LicInfoArr = LicInfo.split("^");
	var LicUserOrHosp = LicInfoArr[4];
	var VersionProp = LicInfoArr[10];
	if (VersionProp=="DV") {
		$("#EnableAccessCtrl").checkbox('disable');
	}
	$("#PageContent table .defaulttitle").html('<a href="javascript:void(0);" onclick="openEntityLog(\''+LicUserOrHosp+'\');">��'+LicUserOrHosp+'��</a>��ϵͳ׼��MACά��');
	$("#Find").click(function(){
		$("#accessMacGrid").datagrid("load");
	});
	$("#PageContent table .listtitle").closest("table").find(".i-tableborder").append("<table id='accessMacGrid'/>");
	$("#accessMacGrid").mgrid({
		className:'BSP.Lic.BL.AccessMac',
		title:'', //'ģ������б�',
		editGrid:true,
		fit:false,
		height:400,
		activeColName:"Active",
		columns:[[
			{field:'ID',hidden:true},
			{field:"LicUserOrHosp",title:"����ϵͳ",width:80,formatter:function(v){
				return v+"��ϵͳ";
				}
			},
			{field:"UserName",title:"׼��������",width:60,editor:{type:"text"}},
			{field:'UserMac',title:'׼��Mac',width:200,editor:{type:'text'}},
			{field:'StartDate',title:'��ʼ����',width:150,editor:{type:'datebox'}},
			{field:'EndDate',title:'��������',width:150,editor:{type:'datebox'}},
			{field:'Active',title:'����',width:50,editor:{type:'checkbox',options:{on:1,off:0}}},
			{field:'UpdUserName',title:'�޸��û�',width:110},
			{field:'UpdDate',title:'�޸�����',width:110}
		]],
		onBeforeLoad:function(param){
			param.UserName = $('#UserName').val();
			param.UserMac = $('#UserMac').val();
			param.LicUserOrHosp =LicUserOrHosp;
			//param.Active = $('#Active').prop("checked")?1:0;
		},
		insOrUpdHandler:function(row){
			var param ;
			if (!row.UserName){
				$.messager.popover({msg:"׼������������Ϊ�գ�",type:'info'});
				return ;
			}
			if (!row.UserMac){
				$.messager.popover({msg:"׼����Mac����Ϊ�գ�",type:'info'});
				return ;
			}
			if (row.ID==""){
				param = $.extend(this.insReq,{"dto.accessMac.id":""});
			}else{
				param = $.extend(this.updReq,{"dto.accessMac.id":row.ID});
			}
			$.extend(param,{
				"dto.accessMac.LicUserOrHosp":LicUserOrHosp,
				"dto.accessMac.UserName":row.UserName,
				"dto.accessMac.UserMac":row.UserMac,
				"dto.accessMac.StartDate":row.StartDate,
				"dto.accessMac.EndDate":row.EndDate,
				"dto.accessMac.Active":row.Active
				
			});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			var nowDate = $.fn.datebox.defaults.formatter(new Date());
			return {ID:"",LicUserOrHosp:LicUserOrHosp,UserName:"",UserMac:"",Active:1,StartDate:nowDate,EndDate:"",UpdUserName:"",UpdDate:""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ���Ƴ���"+row.UserName+"-"+row.UserMac+"��?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.accessMac.id":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
}
var init = function(){
	$('<div id="pwsdDlg"></div>').appendTo("BODY").dialog({
		width:300,
		height:200,
		title:"����",
		closable:false,
		modal:true,
		content:"<table><tr style='height:20px'><td style='width:20px;'></td><td></td><td></td></tr><tr><td></td><td>��������</td><td><input type='password' class='textbox' id='pwsd'/></td></tr></table>",
		buttons:[{
			text:"ȷ��",handler:function(){
				var pv = $('#pwsd').val();
				$cm({ClassName:"BSP.Lic.BL.AccessMac",MethodName:"MatchPassword",pwsd:pv,dataType:'text',_headers:{X_SYNC_HANDLER:1}},function(rtn){
					if (rtn==1){
						$("#pwsdDlg").dialog('close');
						initPage();
					}else{
						$('#pwsd').val('');
						$.messager.popover({msg:"�������",type:'info'});
					}
				});
			}
		}]
	});
	
}
$(init);