/*
模块:		草药揭药
子模块:		草药揭药-颗粒剂数据采集
Creator:	hulihua
CreateDate:	2018-01-18
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var grancollectid="";						//采集人
DhcphaTempBarCode="";
$(function(){
	/*初始化插件 start*/
	InitMedBatNo();				//揭药批次
	InitGridGranPresc();	
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
	$("#grid-medbroregpresc").setGridWidth("")
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

///默认登录人信息
function SetDefaultCode(){
	grancollectid=gUserID;
	$('#recorduser').text(gUserName);
}

///初始化揭药批次
function InitMedBatNo(){
	var data = [
	 { id: 1, text: '第一批' },
	 { id: 2, text: '第二批' }
	 ];
	var selectoption={
	  data: data,
      width:'8em',
      allowClear:false,
      minimumResultsForSearch: Infinity
	};
	$("#sel-medbatno").dhcphaSelect(selectoption);			
}

//初始化颗粒剂处方table
function InitGridGranPresc(){
	var columns=[
		{header:'TPhac',index:'TPhac',name:'TPhac',width:30,hidden:true},
	    {header:'处方号',index:'TPrescNo',name:'TPrescNo',width:80},
	    {header:'开方科室',index:'TDoctorLoc',name:'TDoctorLoc',width:120,align:'left'},
		{header:'登记号',index:'TPatNo',name:'TPatNo',width:60},
		{header:'病人姓名',index:'TPatName',name:'TPatName',width:60},
		{header:'性别',index:'TSex',name:'TSex',width:60},
		{header:'年龄',index:'TPatAge',name:'TPatAge',width:30},
		{header:'付数',index:'TFactor',name:'TFactor',width:60},
		{header:'用法',index:'TInstruc',name:'TInstruc',width:60},
		{header:'煎药方式',index:'TCookType',name:'TCookType',width:60}  
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
	$("#grid-medbrogranpresc").dhcphaJqGrid(jqOptions);
}

//增加揭药列表信息！
function AddBarPrescNo(){
	DhcphaTempBarCode="";
	var barcode=$.trim($("#txt-barcode").val());
	var dispgridrows=$("#grid-medbrogranpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-medbrogranpresc").jqGrid('getRowData',i);
		var tmpprescno=tmpselecteddata["TPrescNo"];
		if(tmpprescno==barcode){
			dhcphaMsgBox.alert("该处方已扫描!");
			$("#txt-barcode").val("");
			return false;	
		}
	}
	var ResutStr=tkMakeServerCall("web.DHCINPHA.HMNurseReceive.NurseReceiveQuery","GetGranPresByBarCode",barcode, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
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
			dhcphaMsgBox.alert("该处方不是颗粒剂!");
		}else if(ResutStr=="-6"){
			dhcphaMsgBox.alert("该处方已经被采集!");
		}else if(ResutStr=="-7"){
			dhcphaMsgBox.alert("该处方非本院区处方,请核实!");
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
	var Phac=ResutStrArr[9];
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
		TDoctorLoc:DoctorLoc
	};
	var id = $("#grid-medbrogranpresc").find("tr").length;
	var su = $("#grid-medbrogranpresc").jqGrid('addRowData',id, datarow);
	if (!su){
  		dhcphaMsgBox.alert("扫描失败，请核实！");
	}
	$("#txt-barcode").val("");
	DhcphaTempBarCode="";
	return false;
}

function DelBarPrescNo() {
	var id = $("#grid-medbrogranpresc").jqGrid('getGridParam', 'selrow');
	var su = $("#grid-medbrogranpresc").jqGrid('delRowData',id);
	if (!su){
		dhcphaMsgBox.alert("删除失败，请重新双击删除！");
		return false;
	} 
}

//验证用户信息并执行确认
function ExecuteSure(){
	DhcphaTempBarCode="";
	if ((grancollectid=="")||(grancollectid==null)){
		dhcphaMsgBox.alert("工号不能为空!");
		return false;
	}
	var medbatno=$('#sel-medbatno').val();
	if((medbatno=="")||(medbatno==null)){
		dhcphaMsgBox.alert("请先选择颗粒剂揭药批次！");
		return false;
	}
	var grid_records = $("#grid-medbrogranpresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("当前界面无颗粒剂处方数据,请先扫描颗粒剂条码！");
		$("#txt-barcode").val("");
		return false;
	}
	
	var firstrowdata = $("#grid-medbrogranpresc").jqGrid("getRowData", 1); //获取第一行数据
	var prescno=firstrowdata.TPrescNo;			
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("请联系工程师验证程序是否存在问题!");
		return false;
	}
	var dispgridrows=$("#grid-medbrogranpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-medbrogranpresc").jqGrid('getRowData',i);
		var tmpphac=tmpselecteddata["TPhac"];
		var tmpprescno=tmpselecteddata["TPrescNo"];
		var SqlStr=tmpphac+tmpSplit+grancollectid+tmpSplit+medbatno;
		var retValue=tkMakeServerCall("web.DHCINPHA.HMNurseReceive.NurseReceiveQuery","SaveGranCollectData",SqlStr);
		if(retValue!=0){
			var Msg=retValue.split("^")[1];
			dhcphaMsgBox.alert("领取&nbsp&nbsp<b><font color=#CC1B04 size=5 >"+tmpprescno+"</font></b>&nbsp&nbsp失败!<br/>"+Msg);
			continue;
		}
	}
	ClearConditons();
	return false;	 	       	 
}

///记录领取人的信息
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
	var ss=defaultinfo.split("^");
	grancollectid=ss[0];
	$('#recorduser').text(ss[2]);
	$("#txt-usercode").val("")
	return false;		
}

function ClearConditons(){
	DhcphaTempBarCode="";
	$("#txt-barcode").val("");  
	$("#txt-usercode").val(""); 
	$("#grid-medbrogranpresc").jqGrid("clearGridData");	
	$("#sel-medbatno").val("");
	InitMedBatNo();				//揭药批次
	SetDefaultCode();
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
				if ($("#grid-medbrogranpresc").getGridParam('records')>0){
					ExecuteSure();
				}
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode)
		}
	}
}