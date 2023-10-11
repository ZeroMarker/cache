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
	var successTip = "成功启用Mac准入控制",failTip="启用Mac准入控制失败";
	if (flag==0){successTip = "成功禁用Mac准入控制",failTip="禁用Mac准入控制失败";}	
	$cm({ClassName:"BSP.Lic.Entity",MethodName:"AccessMac",Flag:flag,dataType:'text'},function(rtn){
		if(rtn==1){
			$.messager.alert("提示",successTip);
			$("#accessMacGrid").datagrid("load");
		}else{
			$.messager.alert("失败",failTip);
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
	$("#PageContent table .defaulttitle").html('<a href="javascript:void(0);" onclick="openEntityLog(\''+LicUserOrHosp+'\');">【'+LicUserOrHosp+'】</a>的系统准入MAC维护');
	$("#Find").click(function(){
		$("#accessMacGrid").datagrid("load");
	});
	$("#PageContent table .listtitle").closest("table").find(".i-tableborder").append("<table id='accessMacGrid'/>");
	$("#accessMacGrid").mgrid({
		className:'BSP.Lic.BL.AccessMac',
		title:'', //'模块界面列表',
		editGrid:true,
		fit:false,
		height:400,
		activeColName:"Active",
		columns:[[
			{field:'ID',hidden:true},
			{field:"LicUserOrHosp",title:"服务系统",width:80,formatter:function(v){
				return v+"的系统";
				}
			},
			{field:"UserName",title:"准入人姓名",width:60,editor:{type:"text"}},
			{field:'UserMac',title:'准入Mac',width:200,editor:{type:'text'}},
			{field:'StartDate',title:'开始日期',width:150,editor:{type:'datebox'}},
			{field:'EndDate',title:'结束日期',width:150,editor:{type:'datebox'}},
			{field:'Active',title:'激活',width:50,editor:{type:'checkbox',options:{on:1,off:0}}},
			{field:'UpdUserName',title:'修改用户',width:110},
			{field:'UpdDate',title:'修改日期',width:110}
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
				$.messager.popover({msg:"准入人姓名不能为空！",type:'info'});
				return ;
			}
			if (!row.UserMac){
				$.messager.popover({msg:"准入人Mac不能为空！",type:'info'});
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
			$.messager.confirm("删除", "确定移除【"+row.UserName+"-"+row.UserMac+"】?", function (r) {
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
		title:"密码",
		closable:false,
		modal:true,
		content:"<table><tr style='height:20px'><td style='width:20px;'></td><td></td><td></td></tr><tr><td></td><td>超级密码</td><td><input type='password' class='textbox' id='pwsd'/></td></tr></table>",
		buttons:[{
			text:"确定",handler:function(){
				var pv = $('#pwsd').val();
				$cm({ClassName:"BSP.Lic.BL.AccessMac",MethodName:"MatchPassword",pwsd:pv,dataType:'text',_headers:{X_SYNC_HANDLER:1}},function(rtn){
					if (rtn==1){
						$("#pwsdDlg").dialog('close');
						initPage();
					}else{
						$('#pwsd').val('');
						$.messager.popover({msg:"密码错误",type:'info'});
					}
				});
			}
		}]
	});
	
}
$(init);