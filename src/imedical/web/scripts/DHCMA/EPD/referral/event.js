function InitReportWinEvent(obj) {
	obj.LoadEvent = function(args)
    { 
		$("#btnSave").on("click",obj.btnSave_click);
		$("#btnDelete").on("click",obj.btnDelete_click);
		$("#btnCheck").on("click",obj.btnCheck_click);
		$("#btnExport").on("click",obj.btnExport_click);
		$("#btnPrint").on("click",obj.btnPrint_click);
		$("#btnCancle").on("click",obj.btnCancle_click);
		 //界面显示
		obj.DisplayRepInfo();   //数据
		obj.InitRepPowerByStatus(obj.ReportID);  //按钮
  	};
	
	//显示按钮操作权限 根据报告状态与操作权限控制
	obj.InitRepPowerByStatus = function(ReportID){	
		$('#btnSave').hide();		  
		$('#btnPrint').hide();	      
		$('#btnExport').hide();	  
		$('#btnDelete').hide();      
		$('#btnCheck').hide();	      // 审核按钮
		$('#btnCancle').hide();       // 删除按钮
		
		obj.RepStatusCode=	$m({      //返回报告状态代码            
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"GetRepStatus",
			aRepID:ReportID
		},false);
     	switch (obj.RepStatusCode) {
			case "" : // 无报告 只能上报
				$('#btnSave').show();	
				$('#btnCancle').show();       // 删除按钮
				break;
			case "1" : // 待审
				$('#btnSave').linkbutton({text:'修改报卡'});
				$('#btnSave').show();		  
				$('#btnPrint').show();	      
				$('#btnExport').show();	      
				$('#btnCheck').show();  
				$('#btnDelete').show();            // 审核按钮
				$('#btnCancle').show(); 
				break;
			case "2" : // 审核
				$('#btnPrint').show();	      
				$('#btnExport').show();	 
				$('#btnCancle').show();
				break;
			case "3" : // 删除
				$('#btnCancle').show();
				break;
		}
		$('#btnExport').hide();	    //隐藏导出按钮
	}
	//显示报卡
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			var strInfo=$m({         
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"GetInfoByEPD",
			aEpisodeID:EpisodeID
		},false); 
			var arrInfo=strInfo.split("^");
			$("#txtPatName").val(arrInfo[0]);
			$("#txtPatSex").val(arrInfo[1]);
			$("#txtPatAge").val(arrInfo[2]);
			$("#txtPatMrNo").val(arrInfo[3]);
			$("#txtPatAddress").val(arrInfo[4]);
			$("#txtPatPhoneNo").val(arrInfo[5]);
			$("#txtFamilyName").val(arrInfo[6]);
			$("#txtWorkAddress").val(arrInfo[7]);
		}else{
			var strRep=$m({         
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"GetStringById",
			id:obj.ReportID,
			lagCode:session['LOGON.LANGCODE']
		},false); 
			var arrRep=strRep.split("^");
			$("#txtPatName").val(arrRep[0]);
			$("#txtPatSex").val(arrRep[1]);
			$("#txtPatAge").val(arrRep[2]);
			$("#txtPatMrNo").val(arrRep[3]);
			$("#txtPatAddress").val(arrRep[4]);
			$("#txtPatPhoneNo").val(arrRep[5]);
			$("#txtFamilyName").val(arrRep[6]);
			$("#txtWorkAddress").val(arrRep[7]);
			$("#cboReferralReason").combobox("setValue",arrRep[8]);
			$("#txtReferralHosp").val(arrRep[9]);
			$("#txtReferralDoc").val(arrRep[10]);
			$("#txtReferralDate").datebox("setValue",arrRep[11]);
			$("#txtReferralAdd").val(arrRep[12]);
			$("#txtReferralPhone").val(arrRep[13]);
			$("#cboPatReferralHosp").combobox("setValue",arrRep[14]);
		}
	};
	//组装数据
	obj.GetRepData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+$("#txtPatName").val();
		InputStr=InputStr+"^"+$("#txtPatSex").val();
		InputStr=InputStr+"^"+$("#txtPatAge").val();
		InputStr=InputStr+"^"+$("#txtPatMrNo").val();
		InputStr=InputStr+"^"+$("#txtPatAddress").val();
		InputStr=InputStr+"^"+$("#txtPatPhoneNo").val();
		InputStr=InputStr+"^"+$("#txtFamilyName").val();
		InputStr=InputStr+"^"+$("#txtWorkAddress").val();
		InputStr=InputStr+"^"+$("#cboReferralReason").combobox("getValue");
		InputStr=InputStr+"^"+$("#txtReferralHosp").val();
		InputStr=InputStr+"^"+$("#txtReferralDoc").val();
		InputStr=InputStr+"^"+$("#txtReferralDate").datebox("getValue");
		InputStr=InputStr+"^"+$("#txtReferralAdd").val();
		InputStr=InputStr+"^"+$("#txtReferralPhone").val();
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+$("#cboPatReferralHosp").combobox("getValue");
		
		return InputStr;
	}
	obj.checkRepData=function(){
		var CheckStr=""
		
		if (!$("#txtPatAddress").val()){
			CheckStr="居住详细地址不能为空!<br>";
		}
		if (!$("#txtPatPhoneNo").val()){
			CheckStr="患者联系电话不能为空!<br>"
		}
		if ($("#txtPatPhoneNo").val() != ""){
			if (!(/^1[3456789]\d{9}$/.test($("#txtPatPhoneNo").val()))) {
				CheckStr += '输入的患者电话号码格式不符合规定！请重新输入!<br>';
			}
		}
		if (!$("#txtFamilyName").val()){
			CheckStr="家属姓名不能为空!<br>"
		}
		if (!$("#txtWorkAddress").val()){
			CheckStr="工作单位不能为空!<br>"
		}
	
		if (!$("#cboReferralReason").combobox("getValue")){
			CheckStr="转诊原因不能为空!<br>"
		}
		if (!$("#txtReferralAdd").val()){
			CheckStr="地址不能为空!"
		}
		if (!$("#txtReferralPhone").val()){
			CheckStr="转诊单位电话不能为空!"
		}
		if ($("#txtReferralPhone").val() != ""){
			if (!(/^1[3456789]\d{9}$/.test($("#txtReferralPhone").val()))) {
				CheckStr += '输入的转诊单位电话格式不符合规定！请重新输入!<br>';
			}
		}
		if (!$("#cboPatReferralHosp").combobox("getValue")){
			CheckStr="请病人到某个医院不能为空!"
		}
		if(CheckStr != "")
		{
			$.messager.alert("提示", CheckStr, 'info');
			return false;
		}
		return true;
	}
	//上报(保存)
	obj.btnSave_click = function(){
		var flag=obj.checkRepData();
		if (flag !=true){
			return;
		}
		var RepData=obj.GetRepData();
		RepData=RepData+"^"+1+"^"+session['LOGON.USERID'];
		
		var ret=$m({                
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"Update",
			aInput:RepData,
			separete:"^"
		},false); 
		
		if(parseInt(ret)<=0){
			$.messager.alert("错误","数据保存错误!"+ret);
			return;
		}else{
			$.messager.alert("提示","数据保存成功!");
			obj.ReportID=ret;
			obj.InitRepPowerByStatus(obj.ReportID);  //按钮
		}
	};
	//删除
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("错误","还未上报!");
			return;
		}
		$.messager.confirm("提示","请确认是否删除?",function(btn){
			if(btn){
				var DeleteStr=obj.ReportID;
				DeleteStr=DeleteStr+"^"+3
				var ret=$m({                
					ClassName:"DHCMed.EPD.ReferralRep",
					MethodName:"ChangeReport",
					aInput:DeleteStr,
					separete:"^"
				},false);
				if(parseInt(ret)<=0){
					$.messager.alert("错误","删除失败!"+ret);
					return;
				}else{
					$.messager.alert("提示","报告删除成功!");
					obj.InitRepPowerByStatus(obj.ReportID); 
					obj.btnCancle_click();
				}
			}
		});
	};
	//审核
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("错误","请先做【上报】操作");
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+2
		var ret=$m({                
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"ChangeReport",
			aInput:CheckStr,
			separete:"^"
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert("错误","报告审核失败!"+ret);
			return;
		}else{
			$.messager.alert("提示","报告审核成功!");
			obj.InitRepPowerByStatus(obj.ReportID);  //按钮
		}
	};
	//导出
	obj.btnExport_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("错误","请先做【上报】操作");
			return;
		}
		var cArguments=obj.ReportID;
		//var flg=ExportDataToExcel("","","肺结核病人转诊单("+$("#txtPatName").val()+")",cArguments);
		var fileName="DHCMA_EPD_PrintReportReferral.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
		DHCCPM_RQPrint(fileName);
		
	};
	//打印
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("错误","请先做【上报】操作");
			return;
		}
		var cArguments=obj.ReportID;
		//var flg=PrintDataToExcel("","","肺结核病人转诊单("+$("#txtPatName").val()+")",cArguments);
		/*var fileName="{DHCMA_EPD_PrintReportReferral.raq(aReportID="+obj.ReportID+")}";
		DHCCPM_RQDirectPrint(fileName);*/
		var fileName="DHCMA_EPD_PrintReportReferral.raq&aReportID="+obj.ReportID;
		DHCCPM_RQPrint(fileName);
	};
	//退出
	obj.btnCancle_click = function(){
		websys_showModal('close');
	};
}