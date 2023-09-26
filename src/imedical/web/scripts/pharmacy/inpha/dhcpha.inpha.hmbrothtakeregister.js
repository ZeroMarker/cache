/*
模块:		草药房
子模块:		草药房-护士揭药领取登记
Creator:	hulihua
CreateDate:	2018-01-17
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var brotakeregid="";						//揭药领取登记人
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
	$("#grid-medbroregpresc").setGridWidth("")
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

///默认登录人信息
function SetDefaultCode(){
	brotakeregid=gUserID;
	$('#recorduser').text(gUserName);
}


//初始化明细table
function InitGridDispConfirm(){
	var columns=[
		{header:'TPhmbiId',index:'TPhmbiId',name:'TPhmbiId',width:20,hidden:true},
	    {header:'处方号',index:'TPrescNo',name:'TPrescNo',width:80},
	    {header:'病区',index:'TWardLoc',name:'TWardLoc',width:120,align:'left'},
	    {header:'开方科室',index:'TDoctorLoc',name:'TDoctorLoc',width:100,align:'left'},
		{header:'登记号',index:'TPatNo',name:'TPatNo',width:60},
		{header:'病人姓名',index:'TPatName',name:'TPatName',width:60},
		{header:'性别',index:'TSex',name:'TSex',width:60},
		{header:'年龄',index:'TPatAge',name:'TPatAge',width:30},
		{header:'付数',index:'TFactor',name:'TFactor',width:60},
		{header:'应揭药日期',index:'TBrothDate',name:'TBrothDate',width:80},
		{header:'应揭袋数',index:'TUncovMedPocNum',name:'TUncovMedPocNum',width:60},
		{header:'条码号',index:'TBarCode',name:'TBarCode',width:120}  
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
	$("#grid-medbroregpresc").dhcphaJqGrid(jqOptions);
}

//增加揭药列表信息！
function AddBarPrescNo(){
	DhcphaTempBarCode="";
	var barcode=$.trim($("#txt-barcode").val());
	var dispgridrows=$("#grid-medbroregpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-medbroregpresc").jqGrid('getRowData',i);
		var tmpprescno=tmpselecteddata["TPrescNo"];
		if(tmpprescno==barcode){
			dhcphaMsgBox.alert("该处方已扫描!");
			$("#txt-barcode").val("");
			return false;	
		}
	}
	var ResutStr=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","GetMedBroPresByBarCode",barcode);
	var RetCode=ResutStr.split("^")[0];
	var RetMessage=ResutStr.split("^")[1];
	if((RetCode<0)||(RetCode=="")||(RetCode==null)){
		dhcphaMsgBox.alert(RetMessage);	
		$("#txt-barcode").val("");
		return false;
	}
	var ResutListStrArr=ResutStr.split("&&");
	for (i=0;i<ResutListStrArr.length;i++){
		var ResutStr=ResutListStrArr[i];
		var ResutStrArr=ResutStr.split(tmpSplit)
		var PrescNo=ResutStrArr[0];
		var PatNo=ResutStrArr[1];
		var PatName=ResutStrArr[2];
		var Sex=ResutStrArr[3];
		var PatAge=ResutStrArr[4];
		var Factor=ResutStrArr[5];
		var DoctorLoc=ResutStrArr[6];
		var WardLoc=ResutStrArr[7];
		var BrothDate=ResutStrArr[8];
		var BarCode=ResutStrArr[9];
		var UncovMedPocNum=ResutStrArr[10];
		var PhmbiId=ResutStrArr[11];
		var datarow = {
			  TPhmbiId:PhmbiId,
			  TPrescNo: PrescNo,
			  TPatNo: PatNo,
			  TPatName: PatName,
			  TSex: Sex,
			  TPatAge:PatAge,
			  TFactor:Factor,
			  TDoctorLoc:DoctorLoc,
			  TWardLoc:WardLoc,
			  TBrothDate: BrothDate,
			  TBarCode:BarCode,
			  TUncovMedPocNum:UncovMedPocNum
		};
		//console.log(datarow)
		var id = $("#grid-medbroregpresc").find("tr").length;
		var su = $("#grid-medbroregpresc").jqGrid('addRowData',id, datarow);
		if (!su){
	  		dhcphaMsgBox.alert("扫描失败，请核实！");
		}

	}

	$("#txt-barcode").val("");
	DhcphaTempBarCode="";
	return false;
}

function DelBarPrescNo() {
	var id = $("#grid-medbroregpresc").jqGrid('getGridParam', 'selrow');
	var su = $("#grid-medbroregpresc").jqGrid('delRowData',id);
	if (!su){
		dhcphaMsgBox.alert("删除失败，请重新双击删除！");
	}
	return false; 
}

//验证用户信息并执行确认
function ExecuteSure(){
	DhcphaTempBarCode="";
	if ((brotakeregid=="")||(brotakeregid==null)){
		dhcphaMsgBox.alert("揭药领取人不能为空!");
		return false;
	}
	var grid_records = $("#grid-medbroregpresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("当前界面无揭药数据,请先扫描揭药条码！");
		$("#txt-barcode").val("");
		return;
	}

	var firstrowdata = $("#grid-medbroregpresc").jqGrid("getRowData", 1); //获取第一行数据
	var prescno=firstrowdata.TPrescNo;			
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("请联系信息中心验证程序是否存在问题!");
		return false;
	}
	var dispgridrows=$("#grid-medbroregpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-medbroregpresc").jqGrid('getRowData',i);
		var tmpphmbiid=tmpselecteddata["TPhmbiId"];
		var tmpbarcode=tmpselecteddata["TBarCode"];
		var SqlStr=tmpphmbiid+tmpSplit+brotakeregid;
		var retValue=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","SaveNuresTakeData",SqlStr);
		if(retValue!=0){
			var Msg=retValue.split("^")[1];
			dhcphaMsgBox.alert("领取&nbsp&nbsp<b><font color=#CC1B04 size=5 >"+tmpbarcode+"</font></b>&nbsp&nbsp失败!<br/>"+Msg);
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
	brotakeregid=ss[0];
	$('#recorduser').text(ss[2]);
	$("#txt-usercode").val("")
	return false;		
}

function ClearConditons(){
	DhcphaTempBarCode="";
	$("#txt-barcode").val("");  
	$("#txt-usercode").val(""); 
	$("#grid-medbroregpresc").jqGrid("clearGridData");	
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
				if ($("#grid-medbroregpresc").getGridParam('records')>0){
					ExecuteSure();
				}
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode)
		}
	}
}