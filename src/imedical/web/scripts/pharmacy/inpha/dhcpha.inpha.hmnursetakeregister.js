/*
模块:		草药房
子模块:		草药房-护士药房领取登记
Creator:	hulihua
CreateDate:	2018-01-17
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var registerid="";						//登记人
DhcphaTempBarCode="";
$(function(){
	/*初始化插件 start*/
	InitGridDispConfirm();	
	/*初始化插件 end*/
	//条码回车事件
	$('#txt-barcode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			AddBarPrescNo();	 
		}     
	});
	
	//工号回车事件
	$('#txt-usercode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetUserInfo();
		}    		 
	});
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(event){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
	
	$("button").on("keypress",function(e){
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
		content:'<div style="width:300px;">*温馨提示*</br>请先扫描条码,再扫描工号哦~</div>' 
	});
	/* 绑定按钮事件 end*/
	
	SetDefaultCode();
	$("#grid-recordregpresc").setGridWidth("")
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

///默认登录人为登记人
function SetDefaultCode(){
	registerid=gUserID;
	$('#recorduser').text(gUserName);
}

//初始化明细table
function InitGridDispConfirm(){
	var columns=[
		{header:'TPhac',index:'TPhac',name:'TPhac',width:20,hidden:true},
	    {header:'处方号',index:'TPrescNo',name:'TPrescNo',width:80},
	    {header:'开方科室',index:'TDoctorLoc',name:'TDoctorLoc',width:100,align:'left'},
		{header:'登记号',index:'TPatNo',name:'TPatNo',width:60},
		{header:'病人姓名',index:'TPatName',name:'TPatName',width:60},
		{header:'性别',index:'TSex',name:'TSex',width:60},
		{header:'年龄',index:'TPatAge',name:'TPatAge',width:30},
		{header:'付数',index:'TFactor',name:'TFactor',width:60},
		{header:'用法',index:'TInstruc',name:'TInstruc',width:60},
		{header:'煎药方式',index:'TCookType',name:'TCookType',width:60},
		{header:'登记状态',index:'TStatue',name:'TStatue',width:50,hidden:true},
		{header:'发药人',index:'TCollectUserName',name:'TCollectUserName',width:60},
		{header:'发药时间',index:'TCollectDate',name:'TCollectDate',width:120}  
	]; 
	var jqOptions={
		datatype:'local',
	    colModel: columns, //列	
	    height: DispConfirmCanUseHeight(),
	    shrinkToFit:true,
	    rownumbers:true,
		ondblClickRow:function(){
			DelBarPrescNo();
		}
	};
	$("#grid-recordregpresc").dhcphaJqGrid(jqOptions);
}

//增加处方列表信息！
function AddBarPrescNo(){
	var barcode=$.trim($("#txt-barcode").val());
	var dispgridrows=$("#grid-recordregpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-recordregpresc").jqGrid('getRowData',i);
		var tmpprescno=tmpselecteddata["TPrescNo"];
		if(tmpprescno==barcode){
			dhcphaMsgBox.alert("该处方已扫描!");
			$("#txt-barcode").val("");
			return false;	
		}
	}
	var ResutStr=tkMakeServerCall("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetPhaPrescByBarCode",barcode,DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	if((ResutStr<0)||(ResutStr=="")||(ResutStr==null)){
		if(ResutStr=="-1"){
			dhcphaMsgBox.alert("处方号为空!");	
		}else if(ResutStr=="-2"){
			dhcphaMsgBox.alert("该处方不存在!");
		}else if(ResutStr=="-3"){
			dhcphaMsgBox.alert("该处方还未到药房!");
		}else if(ResutStr=="-4"){
			dhcphaMsgBox.alert("该处方发药有问题!");
		}else if(ResutStr=="-5"){
			dhcphaMsgBox.alert("该处方已登记!");
		}else if(ResutStr=="-6"){
			dhcphaMsgBox.alert("该处方已退药!");
		}else if(ResutStr=="-11"){
			dhcphaMsgBox.alert("该处方非当前院区处方,请核实!");
		}else{
			dhcphaMsgBox.alert("处方信息有误,请核实!");	
		}
		$("#txt-barcode").val("");
		return false;
	}	
	var ResutStrArr=ResutStr.split(tmpSplit)
	var PrescNo=ResutStrArr[0];
	var PatNo=ResutStrArr[1];
	var PatName=ResutStrArr[2];
	var Sex=ResutStrArr[3];
	var PatAge=ResutStrArr[4];
	var Instruc=ResutStrArr[5];
	var Factor=ResutStrArr[6];
	var CookType=ResutStrArr[7];
	var DoctorLoc=ResutStrArr[8];
	var Statue=ResutStrArr[9];
	var CollectUserName=ResutStrArr[10];
	var CollectDate=ResutStrArr[11];
	var Phac=ResutStrArr[12];
	var datarow = {
		  TPhac:Phac,
		  TPrescNo: PrescNo,
		  TPatNo: PatNo,
		  TPatName: PatName,
		  TSex: Sex,
		  TPatAge:PatAge,
		  TFactor: Factor,
		  TInstruc: Instruc,
		  TCookType: CookType,
		  TDoctorLoc:DoctorLoc,
		  TStatue:Statue,
		  TCollectUserName:CollectUserName,
		  TCollectDate:CollectDate
	};
	//console.log(datarow)
	var id = $("#grid-recordregpresc").find("tr").length;
	var su = $("#grid-recordregpresc").jqGrid('addRowData',id, datarow);
	if (!su){
  		dhcphaMsgBox.alert("扫描失败，请核实！");
	}
	$("#txt-barcode").val("");
	DhcphaTempBarCode="";
	return false;
}

function DelBarPrescNo() {
	var id = $("#grid-recordregpresc").jqGrid('getGridParam', 'selrow');
	var su = $("#grid-recordregpresc").jqGrid('delRowData',id);
	if (!su){
		dhcphaMsgBox.alert("删除失败，请重新双击删除！");
	}
	return false; 
}

//验证用户信息并执行确认
function ExecuteSure(){
	DhcphaTempBarCode="";
	if ((registerid=="")||(registerid==null)){
		dhcphaMsgBox.alert("登记人不能为空!");
		return false;
	}
	var grid_records = $("#grid-recordregpresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("当前界面无处方数据,请先扫描处方条码！");
		$("#txt-barcode").val("");
		return false;
	}

	var firstrowdata = $("#grid-recordregpresc").jqGrid("getRowData", 1); //获取第一行数据
	var prescno=firstrowdata.TPrescNo;			
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("请联系信息中心验证程序是否存在问题!");
		return false;
	}
	var dispgridrows=$("#grid-recordregpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-recordregpresc").jqGrid('getRowData',i);
		var tmpphac=tmpselecteddata["TPhac"];
		var tmpprescno=tmpselecteddata["TPrescNo"];
		var SqlStr=tmpphac+tmpSplit+registerid+tmpSplit+tmpprescno;
		var retValue=tkMakeServerCall("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","SavePreReg",SqlStr);
		if(retValue!=0){
			var Msg=retValue.split("^")[1];
			dhcphaMsgBox.alert("记录&nbsp&nbsp<b><font color=#CC1B04 size=5 >"+tmpprescno+"</font></b>&nbsp&nbsp失败!<br/>"+Msg);
			continue;
		}
	}
	ClearConditons();
	return false;	 	       	 
}

///记录登记人的信息
function SetUserInfo(){
	var usercode=$.trim($("#txt-usercode").val());
	if(usercode==""){
		usercode=gUserCode;
	}
	if (usercode==""){
		dhcphaMsgBox.alert("工号有误!");
		return false;
	}
	var defaultinfo=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserDefaultInfo",usercode);
	if (defaultinfo==""){
		$('#recorduser').text("");
		$("#txt-usercode").val("")
		registerid = ""
		dhcphaMsgBox.alert("此工号不存在，请核实后重试!");
	}
	else {
		var ss=defaultinfo.split("^");
		registerid=ss[0];
		$('#recorduser').text(ss[2]);
		$("#txt-usercode").val("")
	}
	
	return false;		
}

function ClearConditons(){
	DhcphaTempBarCode="";
	$("#txt-barcode").val("");  
	$("#txt-usercode").val("");
	SetDefaultCode(); 
	$("#grid-recordregpresc").jqGrid("clearGridData");	
}
//本页面table可用高度
function DispConfirmCanUseHeight(){
	var height1=parseFloat($("[class='container-fluid dhcpha-containter']").height());
	var height2=parseFloat($("[class='panel-heading']").outerHeight());
	var height3=parseFloat($(".div_content").css("margin-top"));
	var height4=parseFloat($(".div_content").css("margin-bottom"));
	var height5=parseFloat($(".dhcpha-row-split").outerHeight());
	var tableheight=$(window).height()-height1-height4-height2-height3-height5-DhcphaGridTrHeight+40;
	return tableheight;
}

function CheckTxtFocus(){
	var txtfocus1=$("#txt-barcode").is(":focus");
	var txtfocus2=$("#txt-usercode").is(":focus")
	if ((txtfocus1!=true)&&(txtfocus2!=true)){
		return false;
	}
	return true;	
}

//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler(){
	
	if (CheckTxtFocus()!=true){
		if (event.keyCode==13){
			if (DhcphaTempBarCode.length>6){
				$("#txt-barcode").val(DhcphaTempBarCode);
				AddBarPrescNo();
			}else{
				$("#txt-usercode").val(DhcphaTempBarCode);
				if ($("#grid-recordregpresc").getGridParam('records')>0){
					ExecuteSure();
				}
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode)
		}
	}
}