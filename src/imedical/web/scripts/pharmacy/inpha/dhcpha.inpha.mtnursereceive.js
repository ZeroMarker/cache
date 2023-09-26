/*
模块:		移动药房
子模块:		移动药房-病区护士签收
Creator:	hulihua
CreateDate:	2016-10-24
*/
DhcphaTempBarCode="";
$(function(){
	/*初始化插件 start*/
	InitGridPhBoxReceive();	
	/*初始化插件 end*/
	//物流箱号回车事件
	$('#txt-phboxno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			QueryPhBoxInfo();	 
		}     
	});
	
	//工号回车事件
	$('#txt-usercode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			if($('#txt-usercode').val().trim()==""){
				return;	
			}
			ExecuteSure();
		}    		 
	});
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
	
	/* 绑定按钮事件 start*/
	$("#a-help").popover({
		animation:true,
		placement:'bottom',
		trigger: 'hover',
		html:true,
		content:'<div style="width:300px;">*温馨提示*</br>请先扫描物流箱号,再扫描工号哦~</div>' //
	});
	/* 绑定按钮事件 end*/
	
	//查询登录用户当天的签收数量
	QueryDayRecBoxCount();
	document.onkeydown=OnKeyDownHandler;
})

//初始化物流箱信息table
function InitGridPhBoxReceive(){
	var columns=[
		{header:'TPhbID',index:'TPhbID',name:'TPhbID',width:30,hidden:true},
	    {header:'箱号',index:'TPhbNo',name:'TPhbNo',width:60},
		{header:'箱数',index:'TPhbNum',name:'TPhbNum',width:30},
		{header:'药房交接人',index:'TUserPhHand',name:'TUserPhHand',width:60},
		{header:'药房交接日期',index:'TDatePhHand',name:'TDatePhHand',width:60},
		{header:'药房交接时间',index:'TTimePhHand',name:'TTimePhHand',width:60},
		{header:'物流人员',index:'TUserLogistics',name:'TUserLogistics',width:60},
		{header:'病区核对人',index:'TUserWardChk',name:'TUserWardChk',width:60},
		{header:'病区核对日期',index:'TDateWardChk',name:'TDateWardChk',width:60},
		{header:'病区核对时间',index:'TTimeWardChk',name:'TTimeWardChk',width:60}
	    
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseReceive.NurseReceiveQuery&MethodName=GetInPhBoxInfo',	
	    height: DispConfirmCanUseHeight(),
	    shrinkToFit:true
	};
	$("#grid-phboxinfo").dhcphaJqGrid(jqOptions);
}
//查询物流箱信息
function QueryPhBoxInfo(){
	DhcphaTempBarCode="";
	var boxno=$.trim($("#txt-phboxno").val());
	if (boxno!=''){
		var retValue=tkMakeServerCall("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","CheckBoxNoStatue",boxno,gLocId);
		var retCode=retValue.split("^")[0];
		var retMessage=retValue.split("^")[1];
		if(retCode<0){
			dhcphaMsgBox.alert(retMessage);
		}else{
			var params=boxno;
			$("#grid-phboxinfo").setGridParam({
				postData:{
					'params':params
				}
			}).trigger("reloadGrid"); 
			$("#txt-usercode").focus();         
		}			
	}
	else{
		dhcphaMsgBox.alert("物流箱号为空,请核实!"); 
	}
	$("#txt-phboxno").val("");
}
//验证用户信息并执行确认
function ExecuteSure(){
	DhcphaTempBarCode="";
	var usercode=$.trim($("#txt-usercode").val());
	var grid_records = $("#grid-phboxinfo").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("当前界面无物流箱信息数据,请先扫描物流箱号！");
		$("#txt-usercode").val("");
		$("#txt-phboxno").val("");
		return;
	}
	if (usercode==""){
		dhcphaMsgBox.alert("签收工牌号不能为空!");
		$("#txt-usercode").val("");
		$("#txt-phboxno").val("");
		return;
	}
	var retValue= tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserIdByLogCode",usercode);
	if(retValue==0){
		dhcphaMsgBox.alert("所输入的工牌号在HIS中没有维护,请核实!");
		$("#txt-usercode").val("");
		return;
	}
	else{
		var firstrowdata = $("#grid-phboxinfo").jqGrid("getRowData", 1); //获取第一行数据
		var phbrow=firstrowdata.TPhbID;			
		if ((phbrow=="")||(phbrow==undefined)){
			dhcphaMsgBox.alert("请联系工程师验证程序是否存在问题!");
			return;
		}
		var userdr=retValue;
		var params=phbrow+"^"+userdr;
		var retval=tkMakeServerCall("web.DHCINPHA.MTNurseReceive.SqlDbNurseReceive","UpdatePHBoxInfo",params); 
		$("#grid-phboxinfo").setGridParam({
			postData:{
				'params':phbrow
			}
		}).trigger("reloadGrid");
		var  tmpnum=parseFloat($("#lbl-recboxcount").text())+1;
        $("#lbl-recboxcount").text(tmpnum)
		$("#txt-phboxno").val("");  
        $("#txt-usercode").val(""); 
	}        	 
}

function QueryDayRecBoxCount(){
	var usercode=$.trim($("#txt-usercode").val());
	var retval=tkMakeServerCall("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetUserRcBoxCount",gUserID,usercode,gLocId); 
	$("#lbl-recboxcount").text(retval);
	$("#txt-phboxno").focus();
}

function ClearConditons(){
	$("#txt-phboxno").val("");  
	$("#txt-usercode").val("");  
	$("#grid-phboxinfo").jqGrid("clearGridData");
	DhcphaTempBarCode="";	
}

//本页面table可用高度
function DispConfirmCanUseHeight(){
	var height1=parseFloat($("[class='container-fluid dhcpha-containter']").height());
	var height2=parseFloat($("[class='panel-heading']").outerHeight());
	var height3=parseFloat($("#firstrow").outerHeight());
	var height4=parseFloat($(".div_content").css("margin-top"));
	var height5=parseFloat($(".div_content").css("margin-bottom"));
	var height6=parseFloat($(".dhcpha-row-split").outerHeight());
	var tableheight=height1-height5-height3-height2-height4-height6-DhcphaGridTrHeight
	return tableheight;
}

function CheckTxtFocus(){
	var txtfocus1=$("#txt-phboxno").is(":focus");
	var txtfocus2=$("#txt-usercode").is(":focus")
	if ((txtfocus1!=true)&(txtfocus2!=true)){
		return false;
	}
	return true;	
}

//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler(){
	if (CheckTxtFocus()!=true){
		if (event.keyCode==13){
			if (DhcphaTempBarCode.length>10){
				$("#txt-phboxno").val(DhcphaTempBarCode);
				QueryPhBoxInfo();
			}else{
				if(DhcphaTempBarCode==""){
					return;	
				}
				$("#txt-usercode").val(DhcphaTempBarCode);
				if ($("#grid-phboxinfo").getGridParam('records')>0){
					ExecuteSure();
				}
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode)
		}
	}
}