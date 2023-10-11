function InitReportWinEvent(obj) {
	
	obj.LoadEvent = function(){
		obj.DisplayRepInfo();
		obj.InitRepPowerByStatus(ReportID);
		obj.RelationToEvents(); // 按钮监听事件 
		top.$("#WinModalEasyUI").empty();
	}	
	//显示按钮操作权限 根据报告状态与操作权限控制
		obj.InitRepPowerByStatus = function(ReportID){		
		$('#btnSave').hide();
		$('#btnPrint').hide();
		$('#btnCanCheck').hide();
		$('#btnDelete').hide();
		$('#btnCheck').hide();
		$('#btnCancle').hide();
		$('#btnReturn').hide();
		$('#btnSaveTemp').hide();
		
		obj.RepStatusCode = $m({                  
			ClassName:"DHCMed.CDService.Service",
			MethodName:"GetReportStatus",
			aReportID:ReportID
		},false);
		
     	switch (obj.RepStatusCode) {
			case "" : // 无报告 只能上报
				$('#btnSave').show();
				$('#btnSaveTemp').show();
				$('#btnCancle').show();
				break;
			case "1" : // 待审
				$('#btnSave').linkbutton({text:$g('修改报卡')});
				$('#btnSave').show();
				$('#btnDelete').show();
				if (LocFlag==1){
					$('#btnCheck').show();
					$('#btnReturn').show();
				}
				$('#btnPrint').show();
				$('#btnCancle').show();
				break;
			case "2" : // 审核
				if (LocFlag==1){
					$('#btnCanCheck').show();
				}
				$('#btnPrint').show();
				$('#btnCancle').show();
				break;
			case "3" : // 作废
				$('#btnCancle').show();
				break;
			case "4" : // 草稿
				$('#btnSaveTemp').show();
				$('#btnSave').show();
				$('#btnCancle').show();
				break;
			case "5" : // 退回
				$('#btnSave').linkbutton({text:$g('修改报卡')});
				$('#btnSaveTemp').show();
				$('#btnDelete').show();
				$('#btnSave').show();
				$('#btnCancle').show();
				break;
		}
		
		if (tDHCMedMenuOper['Submit']!=1) {//没有提交权限，隐藏保存按钮
			$('#btnSave').hide();
		}
		if (tDHCMedMenuOper['Check']!=1) { //没有审核权限，隐藏审核按钮
			$('#btnCheck').hide();
			$('#btnCanCheck').hide();
		}
		if (tDHCMedMenuOper['Check']) {
			$('#btnDelete').hide();
		}
	}
	
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			$('#txtDoctor').val(DocName);
			$('#cboCRReportLoc').combobox('setValue',LocID);                    //报卡科室
			$('#cboCRReportLoc').combobox('setText',LocDesc);                  
			$('#txtOrgan').val(HospDesc);
			$('#dtRepDate').datebox('setValue',Common_GetDate(new Date()));
			if(PatientID!=""){
				var objPat = $cm({                  
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				// 初始化患者类型
				var PatStatus = $m({                  
					ClassName:"DHCMed.CD.CRReportGXY",
					MethodName:"GetPatStatusByPaadm",
					aPatientID:PatientID
				},false);
				$('#PatStatus').val(PatStatus);
				
				$('#txtRegNo').val(objPat.PapmiNo);
				$('#txtPatName').val(objPat.PatientName);
				$('#txtSex').val(objPat.Sex);
				var PersonalIDType=objPat.PersonalIDType;				//证件类型
				if(PersonalIDType!=$g("居民身份证")){
					$('#txtPatCardNo').val("");     
				}
				else{
					$('#txtPatCardNo').val(objPat.PersonalID);                //身份证号
				}
			    $('#txtBirthDay').datebox('setValue',objPat.Birthday); 
				var AgeY=objPat.Age;
				var AgeM=objPat.AgeMonth;
				var AgeD=objPat.AgeDay;
				if (AgeY>0){
					$('#txtAge').val(objPat.Age);
					$('#cboPatAgeDW').combobox('setValue',$g('岁'));
				}else if(AgeM>0){
					$('#txtAge').val(objPat.AgeMonth);
					$('#cboPatAgeDW').combobox('setValue',$g('月'));
				}else {
					$('#txtAge').val(objPat.AgeDay);
					$('#cboPatAgeDW').combobox('setValue',$g('天'));
				}
				if (ServerObj.CurrAddress) { // 现地址
					$('#cboCurrProvince').combobox('setValue',ServerObj.CurrAddress.split("^")[0]);                    
					$('#cboCurrProvince').combobox('setText',ServerObj.CurrAddress.split("^")[1]);                  
					$('#cboCurrCity').combobox('setValue',ServerObj.CurrAddress.split("^")[2]);                    
					$('#cboCurrCity').combobox('setText',ServerObj.CurrAddress.split("^")[3]);                  
					$('#cboCurrCounty').combobox('setValue',ServerObj.CurrAddress.split("^")[4]);                    
					$('#cboCurrCounty').combobox('setText',ServerObj.CurrAddress.split("^")[5]);                  
					$('#cboCurrVillage').combobox('setValue',ServerObj.CurrAddress.split("^")[6]);                    
					$('#cboCurrVillage').combobox('setText',ServerObj.CurrAddress.split("^")[7]);                  
					$('#txtCurrRoad').val(ServerObj.CurrAddress.split("^")[8]);    
					$('#txtCurrAddress').val(ServerObj.PatCurrAddress);
					if (session['LOGON.LANGCODE']=="EN"){
						$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText'));
					}
				}			
			}
		}else{
			var objRep = $m({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false);
		    var objGXY = $m({                  
				ClassName:"DHCMed.CD.CRReportGXY",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var objPat = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			var arrGXY=objGXY.split("^");
			var arrPat=objPat.split("^");
			
			// 患者基本信息
			$('#txtRegNo').val(arrPat[3]);
			$('#txtPatName').val(arrPat[4]);
			$('#txtSex').val(arrPat[6]);
			$('#txtBirthDay').datebox('setValue',arrPat[7]);
			$('#txtPatCardNo').val(arrPat[11]);
			var patAge="";
			var patAgeDW="";
			if(arrPat[8]!=""){
				patAge=arrPat[8];
				patAgeDW=$g("岁");
			}else if(arrPat[9]!=""){
				patAge=arrPat[9];
				patAgeDW=$g("月");
			}else{
				patAge=arrPat[10];
				patAgeDW=$g("天");
			}
			$('#txtAge').val(patAge);
			$('#cboPatAgeDW').combobox('setValue',patAgeDW);
			$('#cboNation').combobox('setValue',arrPat[13].split(CHR_1)[0]);
			$('#cboNation').combobox('setText',((arrPat[13].indexOf(CHR_1)>-1) ? arrPat[13].split(CHR_1)[1] : ''));
			$('#cboCurrProvince').combobox('setValue',arrPat[29].split(CHR_1)[0]);
			$('#cboCurrProvince').combobox('setText',((arrPat[29].indexOf(CHR_1)>-1) ? arrPat[29].split(CHR_1)[1] : ''));
			$('#cboCurrCity').combobox('setValue',arrPat[30].split(CHR_1)[0]);
		    $('#cboCurrCity').combobox('setText',((arrPat[30].indexOf(CHR_1)>-1) ? arrPat[30].split(CHR_1)[1] : ''));
			$('#cboCurrCounty').combobox('setValue',arrPat[31].split(CHR_1)[0]);
			$('#cboCurrCounty').combobox('setText',((arrPat[31].indexOf(CHR_1)>-1) ? arrPat[31].split(CHR_1)[1] : ''));
			$('#cboCurrVillage').combobox('setValue',arrPat[32].split(CHR_1)[0]);
			$('#cboCurrVillage').combobox('setText',((arrPat[32].indexOf(CHR_1)>-1) ? arrPat[32].split(CHR_1)[1] : ''));
			$('#txtCurrRoad').val(arrPat[33]);
			$('#txtCurrAddress').val(arrPat[34]);
			
			// 报告信息
			$('#cboCRReportLoc').combobox('setValue',arrRep[3]);
			$('#cboCRReportLoc').combobox('setText',arrRep[4]);
			$('#txtDoctor').val(arrRep[5]);
			$('#txtOrgan').val(arrRep[6]);
			$('#dtRepDate').datebox('setValue',arrRep[7]);
			
			// 高血压报卡信息
			$('#txtKPBH').val(arrGXY[0]);
			$('#PatStatus').val(arrGXY[1]);
			$('#txtFamilyCount').val(arrGXY[2]);
			for (var len=0; len < arrGXY[3].split(',').length;len++) {       
				var valueCode = arrGXY[3].split(',')[len];
				$('#chkRelations'+valueCode).checkbox('setValue',(valueCode!=""?true:false));           //诊断依据
			}
			obj.CRGXYZDID = arrGXY[4].split(CHR_1)[0];
			$('#cboCRGXYZD').lookup('setText',arrGXY[4].split(CHR_1)[1]);
			$('#txtCRGXYZDICD').val(arrGXY[5]);
			$('#txtWeight').val(arrGXY[6]);
			$('#txtHeight').val(arrGXY[7]);
			for (var len=0; len < arrGXY[8].split(',').length;len++) {       
				var valueCode = arrGXY[8].split(',')[len];
				$('#chkSymptoms'+valueCode).checkbox('setValue',(valueCode!=""?true:false));           //诊断依据
			}
			$('#txtSSY').val(arrGXY[9]);
			$('#txtSZY').val(arrGXY[10]);
			$('#txtHeartRate').val(arrGXY[11]);
			$('#txtResume').val(arrGXY[12]);
		
		}
	};
	
   obj.GetRepData = function (step) {
		
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"GXY";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3作废
		InputStr=InputStr+"^"+$.trim($('#cboCRReportLoc').combobox('getValue')); //session['LOGON.CTLOCID'];
		InputStr=InputStr+"^"+$.trim($('#txtDoctor').val());
		InputStr=InputStr+"^"+$.trim($('#txtOrgan').val());
		InputStr=InputStr+"^"+$('#dtRepDate').datebox("getValue"); 
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+"";	 			//更新日期	11
		InputStr=InputStr+"^"+"";	 			//更新时间	12
		InputStr=InputStr+"^"+"0";	 			//审核标记	13
		InputStr=InputStr+"^"+"";	 			//审核人	14
		InputStr=InputStr+"^"+"";	 			//审核日期	15
		InputStr=InputStr+"^"+"";	 			//审核时间	16
		InputStr=InputStr+"^"+"0";	 			//导出标记	17
		InputStr=InputStr+"^"+"";	 			//导出人	18
		InputStr=InputStr+"^"+"";	 			//导出日期	19
		InputStr=InputStr+"^"+"";	 			//导出时间	20
		InputStr=InputStr+"^"+"";	 			//备注		21
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];	//更新科室		22
      
		return InputStr;
	}
	
	obj.GetGXYData = function () {
	
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+$.trim($('#txtKPBH').val());                  // 编号
		InputStr=InputStr+"^"+$.trim($('#PatStatus').val());                // 患者类型
		InputStr=InputStr+"^"+$.trim($('#txtFamilyCount').val());           // 家庭成员人数
		InputStr=InputStr+"^"+Common_CheckboxValue('chkRelations');   	 	// 有高血压史的成员
		InputStr=InputStr+"^"+ obj.CRGXYZDID;								// 高血压诊断ID
		InputStr=InputStr+"^"+$.trim($('#txtCRGXYZDICD').val());            // 高血压诊断ICD
		InputStr=InputStr+"^"+$.trim($('#txtWeight').val());          	  	// 身高
		InputStr=InputStr+"^"+$.trim($('#txtHeight').val());           	 	// 体重
		InputStr=InputStr+"^"+Common_CheckboxValue('chkSymptoms');   	 	// 症状
		InputStr=InputStr+"^"+$.trim($('#txtSSY').val());           	 	// 收缩压
		InputStr=InputStr+"^"+$.trim($('#txtSZY').val());           	 	// 舒张压
		InputStr=InputStr+"^"+$.trim($('#txtHeartRate').val());           	// 心率
		InputStr=InputStr+"^"+$.trim($('#txtResume').val());           	 	// 其他
		return InputStr;
	}
	
	obj.GetPatData = function () {
		var Age	  = $.trim($('#txtAge').val());                       //年龄
		var AgeDW = $.trim($('#cboPatAgeDW').combobox('getValue'));	  //年龄单位
		var NLS,NLY,NLT="";
		if(AgeDW==$g("岁")){
			NLS=Age;
			NLY="";
			NLT="";
		}else if(AgeDW==$g("月")){
			NLY=Age;
			NLT="";
			NLS="";
		}else{
			NLT=Age;
			NLY="";
			NLS="";
		}
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;   //2
		InputStr = InputStr+"^"+"";	                    					//CRMZH3
		InputStr = InputStr+"^"+"";	                    					//CRZYH4
		InputStr = InputStr+"^"+$.trim($('#txtRegNo').val());						//CRDJH5
		InputStr = InputStr+"^"+$.trim($('#txtPatName').val());						//CRXM6
		InputStr = InputStr+"^"+"";	                                        //CRJZXM7
		InputStr = InputStr+"^"+$.trim($('#txtSex').val());;	                    //CRXB8
		InputStr = InputStr+"^"+$('#txtBirthDay').datebox('getValue');	    //CRCSRQ9
		InputStr = InputStr+"^"+NLS;	                                    //CRNLS10
		InputStr = InputStr+"^"+NLY;	                                    //CRNLY11
		InputStr = InputStr+"^"+NLT;	                                    //CRNLT12
		InputStr = InputStr+"^"+$.trim($('#txtPatCardNo').val());;	                //CRSFZH13
		InputStr = InputStr+"^"+"";	                                        //CRJTDH14
		InputStr = InputStr+"^"+$.trim($('#cboNation').combobox('getValue')); // CRMZ15 民族
		InputStr = InputStr+"^"+"";	    //CRHYZK16
		InputStr = InputStr+"^"+"";	//CRWHCD17
		InputStr = InputStr+"^"+"";	//CRZY18
		InputStr = InputStr+"^"+"";	    //CRGZ19
		InputStr = InputStr+"^"+"";	                                        //CRLXR20
		InputStr = InputStr+"^"+"";	                                        //CRYBRGX21
		InputStr = InputStr+"^"+"";	                    //CRLXDH22
		InputStr = InputStr+"^"+"";	                    //CRGZDW23
		InputStr = InputStr+"^"+""; //$.trim($('#cboPatHJ').combobox('getValue'));;	    //CRHJ24
		InputStr = InputStr+"^"+"";	//CRHJDZS25
		InputStr = InputStr+"^"+"";      //CRHJDZS226
		InputStr = InputStr+"^"+"";    //CRHJDZX27
		InputStr = InputStr+"^"+"";	//CRHJDZX228
		InputStr = InputStr+"^"+"";                     //CRHJDZC29
		InputStr = InputStr+"^"+"";	                //CRHJDZXX30
		InputStr = InputStr+"^"+$.trim($('#cboCurrProvince').combobox('getValue'));	//CRCZDZS31
		InputStr = InputStr+"^"+$.trim($('#cboCurrCity').combobox('getValue'));     //CRCZDZS232
		InputStr = InputStr+"^"+$.trim($('#cboCurrCounty').combobox('getValue'));   //CRCZDZX33
		InputStr = InputStr+"^"+$.trim($('#cboCurrVillage').combobox('getValue'));	//CRCZDZX234
		InputStr = InputStr+"^"+$.trim($('#txtCurrRoad').val());                    //CRCZDZC35
		InputStr = InputStr+"^"+$.trim($('#txtCurrAddress').val());	                //CRCZDZXX36
		return InputStr;
	}
	
	// 按钮触发事件
	obj.RelationToEvents = function() {
		$('#btnSave').on("click", function(){
			obj.btnSave_click(); 
		});
		$('#btnSaveTemp').on("click", function(){
			obj.btnSaveTemp_click();
		});
		$('#btnDelete').on("click", function(){
			obj.btnDelete_click(); 
		});
		$('#btnCheck').on("click", function(){
			obj.btnCheck_click(); 
		});
		$('#btnCanCheck').on("click", function(){	//取消审核
			obj.btnCanCheck_click(); 		
		});
		$('#btnPrint').on("click", function(){
			obj.btnPrint_click(); 
		});
		$('#btnCancle').on("click", function(){
			obj.btnCancle_click(); 
		});
		$('#btnReturn').on("click", function(){
			$.messager.prompt($g("退回"), $g("请输入退回原因!"), function (r) {
				if (r){
					obj.btnReturn_click(r); 
				}else if(r==""){
					$.messager.alert($g("提示"),$g("退回原因不能为空!"), 'info');
				}	
			});
		});
	}	
	// 草稿
	obj.btnSaveTemp_click = function(){
		var RepData=obj.GetRepData(4);
		var GXYData=obj.GetGXYData();
		var PatData=obj.GetPatData();
		var ExtraData="";
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:GXYData,
			PatInfo:PatData,
			ExtraInfo:ExtraData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("草稿数据保存错误!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("草稿数据保存成功！<br>请及时完善高血压信息!"), 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus(obj.ReportID);
			//追加隐藏元素，用于强制报告保存失败时作废诊断
			top.$("#WinModalEasyUI").append("<input type='hidden' id='flag' value='1'>");
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:obj.ReportID
		        });
		    	history.pushState("", "", Url);
		        return;
			}
		}
	};
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var GXYData=obj.GetGXYData();
		var PatData=obj.GetPatData();
		var ExtraData="";
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:GXYData,
			PatInfo:PatData,
			ExtraInfo:ExtraData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("数据保存错误!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("数据保存成功!"), 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus(obj.ReportID);
			//追加隐藏元素，用于强制报告保存失败时作废诊断
			top.$("#WinModalEasyUI").append("<input type='hidden' id='flag' value='1'>");
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:obj.ReportID
		        });
		    	history.pushState("", "", Url);
		        return;
			}
		}
	};
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("还未上报!"), 'error');
			return;
		}
		$.messager.confirm($g("提示"),$g("请确认是否作废?"),function(r){
			if(r){
				var DeleteStr=obj.ReportID;
				DeleteStr=DeleteStr+"^"+3
				DeleteStr=DeleteStr+"^"+session['LOGON.USERID'];
				DeleteStr=DeleteStr+"^"+session['LOGON.CTLOCID'];
				DeleteStr=DeleteStr+"^"+"DELETE";
				var ret = $m({                  
					ClassName:"DHCMed.CD.CRReport",
					MethodName:"DeleteReport",
					aInput:DeleteStr,
					separete:"^"
				},false);
			
				if(parseInt(ret)<=0){
					$.messager.alert($g("错误"),$g("作废失败!")+ret, 'error');
					return;
				}else{
					$.messager.alert($g("提示"),$g("报告作废成功!"), 'info');
					obj.InitRepPowerByStatus(obj.ReportID);
				}
			}
		});
	};
	// 退回
	obj.btnReturn_click = function(r){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'info');
			return;
		}
		var ReturnStr=obj.ReportID;
		ReturnStr=ReturnStr+"^"+5
		ReturnStr=ReturnStr+"^"+session['LOGON.USERID'];
		ReturnStr=ReturnStr+"^"+session['LOGON.CTLOCID'];
		ReturnStr=ReturnStr+"^"+"RETURN";
		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"ReturnReport",
			aInput:ReturnStr,
			separete:"^",
			aReason:r
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("退回失败!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("退回成功!"), 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	}
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'info');
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+2
		CheckStr=CheckStr+"^"+session['LOGON.USERID'];
		CheckStr=CheckStr+"^"+session['LOGON.CTLOCID'];

		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"CheckReport",
			aInput:CheckStr,
			separete:"^"
		},false);
				
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("报告审核失败!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("报告审核成功!"), 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	};
	//取消审核
	obj.btnCanCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'info');
			return;
		}
		var CanCheckStr=obj.ReportID;
		CanCheckStr=CanCheckStr+"^"+1
		CanCheckStr=CanCheckStr+"^"+session['LOGON.USERID'];
		CanCheckStr=CanCheckStr+"^"+session['LOGON.CTLOCID'];
		CanCheckStr=CanCheckStr+"^"+"CANCHECK";

		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"CanCheckReport",
			aInput:CanCheckStr,
			separete:"^"
		},false);
				
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("取消审核失败!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("取消审核成功!"), 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	}
	
	
	obj.btnPrint_click = function(){
		if (obj.ReportID==""){
			$.messager.alert($g("提示"),$g("打印失败！找不到这份报告") , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintCDGXYReport");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，1为双面打印，0为单面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，1为双面打印，0为单面打印)
		LodopPrintURL(LODOP,"dhcma.cd.lodopgxy.csp?ReportID="+obj.ReportID);
		LODOP.PRINT();			//直接打印
	};
	obj.btnCancle_click = function(){
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //关闭
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
	};
	
	//检查规范
	obj.CheckReport = function(){
		var errStr = "";

		if ($.trim($('#txtPatName').val()) == "") {
			errStr += $g("病人姓名不允许为空!<br>");		//病人姓名
		}
		if ($.trim($('#txtSex').val()) == "") {
			errStr += $g("性别不允许为空!<br>");		//性别
		}
		if ($.trim($('#txtAge').val()) == "") {
			errStr += $g("年龄不允许为空!<br>");		//年龄
		}
		if ($.trim($('#cboNation').combobox('getValue')) == "") { //民族
			errStr += $g("请选择民族!<br>");		
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			errStr += $g("身份证号不允许为空!<br>");		//身份证号
		}
		// 身份证格式验证	
		if ($.trim($('#txtPatCardNo').val()) != ""){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test($.trim($('#txtPatCardNo').val())))) {
				errStr += $g('输入的身份证号格式不符合规定！请重新输入!<br>');
			}
		}
		
		if ($.trim($('#cboCurrProvince').combobox('getValue')) == "") { //省
			errStr += $g("请选择居住地址省!<br>");		
		}
		if ($.trim($('#cboCurrCity').combobox('getValue')) == "") {
			errStr += $g("请选择居住地址市!<br>");		//市
		}
		if ($.trim($('#cboCurrCounty').combobox('getValue')) == "") {
			errStr += $g("请选择居住地址县!<br>");		//县
		}
		if ($.trim($('#cboCurrVillage').combobox('getValue')) == "") {
			errStr += $g("请选择居住地址乡/镇!<br>");		//乡/镇
		}
		if ($.trim($('#txtCurrRoad').val()) == "") {
			errStr += $g("居住地址村不允许为空!<br>");		//村
		}
		if ($.trim($('#txtCurrAddress').val()) == "") {
			errStr += $g("居住地址详细地址不允许为空!<br>");		//详细地址		
		} 
		if ($.trim(Common_CheckboxValue('chkSymptoms')) == "") {
			errStr += $g("请选择症状!<br>");		//详细地址		
		}
		
		if ($.trim($('#txtOrgan').val()) == "") {
			errStr += $g("确诊医院不允许为空!<br>");		//确诊医院
		} 
		
	
		if(errStr != "") {
			$.messager.alert($g("提示"), errStr, 'info');
			return false;
		}
		return true;
	}

}


