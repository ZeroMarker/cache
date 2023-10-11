function InitReportWinEvent(obj) {
	obj.LoadEvent = function(args)
    { 
		$("#btnSave").on("click",obj.btnSave_click);
		$("#btnDelete").on("click",obj.btnDelete_click);
		$("#btnCheck").on("click",obj.btnCheck_click);
		$("#btnExport").on("click",obj.btnExport_click);
		$("#btnPrint").on("click",obj.btnPrint_click);
		$("#btnCancle").on("click",obj.btnCancle_click);
		
		obj.InitRepPowerByStatus(obj.ReportID);  //按钮
		 //界面显示
		obj.DisplayRepInfo();   //数据
  	};
	
	//显示按钮操作权限 根据报告状态与操作权限控制
	obj.InitRepPowerByStatus = function(ReportID){	
		$('#btnSave').hide();		  
		$('#btnPrint').hide();	   
		$('#btnDelete').hide();      
		$('#btnCheck').hide();	      // 审核按钮
		$('#btnCancle').hide();       // 删除按钮
		
		obj.RepStatusCode=	$m({      //返回报告状态代码            
			ClassName:"DHCMed.EPD.HCVReferral",
			MethodName:"GetRepStatus",
			aRepID:ReportID
		},false);
     	switch (obj.RepStatusCode) {
			case "" : // 无报告 只能上报
				$('#btnSave').show();	
				$('#btnCancle').show();       // 删除按钮
				break;
			case "上报" : // 待审
				$('#btnSave').linkbutton({text:$g('修改报卡')});
				$('#btnSave').show();
				if (LocFlag==1){
					$('#btnPrint').show();      
					$('#btnCheck').show(); // 审核按钮 
					$('#btnDelete').show();  
				}		            
				$('#btnCancle').show(); 
				break;
			case "审核" : // 审核
				$('#btnPrint').show();	  
				$('#btnCancle').show();
				break;
			case "作废" : // 删除
				$('#btnCancle').show();
				break;
		}
		$('#btnExport').hide();	    //隐藏导出按钮
	}
	//显示报卡
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			var strInfo=$m({         
				ClassName:"DHCMed.EPD.HCVReferral",
				MethodName:"GetInfoByEPD",
				aEpisodeID:EpisodeID
			},false); 
			var arrInfo=strInfo.split("^");
			$("#txtPatName").val(arrInfo[0]);
			$("#txtPatSex").val(arrInfo[1]);
			$("#txtPersonalID").val(arrInfo[2]);
			$("#ReportDate").datebox("setValue",Common_GetDate(new Date()));
			$("#RefDoctor").val(DocName);
	 		$("#RefOrgName").val(HospDesc);
		}else{
			var strRep=$m({         
				ClassName:"DHCMed.EPD.HCVReferral",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false); 
			var arrRep=strRep.split("^");
			$("#RecHospName").val(arrRep[0]);
			$("#txtPatName").val(arrRep[1]);
			$("#txtPatSex").val(arrRep[2]);
			$("#txtPersonalID").val(arrRep[3]);
			Common_SetRadioValue("RadHCVDetection",arrRep[4].split(CHR_1)[0]);
			Common_SetRadioValue("RadExamPlan",arrRep[5].split(CHR_1)[0]);
			$("#OtherPlan").val(arrRep[6]);
			$("#RefTelPhone").val(arrRep[7]);
			$("#RefDoctor").val(arrRep[8]);
			$("#RefOrgName").val(arrRep[9]);
			$("#ReportDate").datebox("setValue",arrRep[10]);
			$("#Resume").val(arrRep[11]);
			$("#RepStatus").val(arrRep[12]);
		}
	};
	//组装数据
	obj.GetRepData = function (Status) {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+$("#RecHospName").val();
		InputStr=InputStr+"^"+$("#txtPatName").val();
		InputStr=InputStr+"^"+$("#txtPatSex").val();
		InputStr=InputStr+"^"+$("#txtPersonalID").val();
		InputStr=InputStr+"^"+Common_RadioValue("RadHCVDetection");
		InputStr=InputStr+"^"+Common_RadioValue("RadExamPlan");
		InputStr=InputStr+"^"+$("#OtherPlan").val();
		InputStr=InputStr+"^"+$("#RefTelPhone").val();
		InputStr=InputStr+"^"+$("#RefDoctor").val();
		InputStr=InputStr+"^"+$("#RefOrgName").val();
		InputStr=InputStr+"^"+$("#ReportDate").datebox("getValue");
		InputStr=InputStr+"^"+$("#Resume").val();
		InputStr=InputStr+"^"+Status;
		
		return InputStr;
	}
	obj.checkRepData=function(){
		var CheckStr=""
		if (!$("#RecHospName").val()){
			CheckStr=$g("接收医疗机构名称不能为空")+"!<br>";
		}
		if (!$("#RefTelPhone").val()){
			CheckStr=$g("转介单位联系电话不能为空")+"!<br>";
		}
		if (!$("#RefDoctor").val()){
			CheckStr=$g("转介医生不能为空")+"!<br>";
		}
		if (!$("#RefOrgName").val()){
			CheckStr=$g("转介单位不能为空")+"!<br>";
		}
		
		if(CheckStr != "")
		{
			$.messager.alert($g("提示"), CheckStr, 'info');
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
		var RepData=obj.GetRepData(1);
		var ret=$m({                
			ClassName:"DHCMed.EPD.HCVReferral",
			MethodName:"Update",
			aInput:RepData,
			separete:"^"
		},false); 
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("数据保存错误")+"!"+ret, 'info');
			return;
		}else{
			$.messager.alert($g("提示"),$g("数据保存成功")+"!", 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();   //数据
			obj.InitRepPowerByStatus(obj.ReportID);  //按钮
		}
	};
	// 作废
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("还未上报")+"!");
			return;
		}
		$.messager.confirm($g("提示"),$g("请确认是否作废")+"?",function(btn){
			if(btn){
				var Data=obj.GetRepData(3);
				var ret=$m({                
					ClassName:"DHCMed.EPD.HCVReferral",
					MethodName:"ChangeReport",
					aInput:Data,
					separete:"^"
				},false);
				if(parseInt(ret)<=0){
					$.messager.alert($g("错误"),$g("作废失败")+"!"+ret, 'info');
					return;
				}else{
					$.messager.alert($g("提示"),$g("报告作废成功")+"!", 'info');
					obj.ReportID=ret;
					obj.DisplayRepInfo();   //数据
					obj.InitRepPowerByStatus(obj.ReportID); 
				}
			}
		});
	};
	//审核
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"));
			return;
		}
		var Data=obj.GetRepData(2);
		var ret=$m({                
			ClassName:"DHCMed.EPD.HCVReferral",
			MethodName:"ChangeReport",
			aInput:Data,
			separete:"^"
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("报告审核失败")+"!"+ret, 'info');
			return;
		}else{
			$.messager.alert($g("提示"),$g("报告审核成功")+"!", 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();   //数据
			obj.InitRepPowerByStatus(obj.ReportID);  //按钮
		}
	};
	
	//打印
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"));
			return;
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintDHCMAEPDHCVREFReport");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.epd.lodophcvref.csp?ReportID="+obj.ReportID,"","20mm");
		LODOP.PRINT();			//直接打印
	};
	//退出
	obj.btnCancle_click = function(){
		websys_showModal('close');
	};
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          