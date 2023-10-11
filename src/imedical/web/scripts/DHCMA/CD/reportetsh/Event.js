function InitReportWinEvent(obj) {
	obj.LoadEvent = function(){
		obj.DisplayRepInfo();
		obj.InitRepPowerByStatus(ReportID);
		obj.RelationToEvents(); // 按钮监听事件
		top.$("#WinModalEasyUI").empty();		
	}	
	
	
	$HUI.radio("[name='radInjuryReason']",{  
		onChecked:function(e,value){
			var InjuryReason = Common_RadioLabel("radInjuryReason");   //当前选中的值
			if (InjuryReason==$g("其他")) {	
				$('#OtherReason').removeAttr("disabled");
			}else{
				$('#OtherReason').val("");
				$('#OtherReason').attr('disabled','disabled');
			}
		}
	});
	$HUI.radio("[name='radInjuryplace']",{  
		onChecked:function(e,value){
			var Injuryplace = Common_RadioLabel("radInjuryplace");   //当前选中的值
			if (Injuryplace==$g("其他")) {	
				$('#OtherPlace').removeAttr("disabled");
			}else{
				$('#OtherPlace').val("");
				$('#OtherPlace').attr('disabled','disabled');
			}
		}
	});
	
	$HUI.radio("[name='radInjuryActivity']",{  
		onChecked:function(e,value){
			var InjuryActivity = Common_RadioLabel("radInjuryActivity");   //当前选中的值
			if (InjuryActivity==$g("其他")) {	
				$('#OtherActivity').removeAttr("disabled");
			}else{
				$('#OtherActivity').val("");
				$('#OtherActivity').attr('disabled','disabled');
			}
		}
	});
	$HUI.radio("[name='radIsWillfully']",{  
		onChecked:function(e,value){
			var IsWillfully = Common_RadioLabel("radIsWillfully");   //当前选中的值
			if (IsWillfully==$g("其他")) {	
				$('#OtherWillfully').removeAttr("disabled");
			}else{
				$('#OtherWillfully').val("");
				$('#OtherWillfully').attr('disabled','disabled');
			}
		}
	});
	$HUI.radio("[name='radCaregiverStatus']",{  
		onChecked:function(e,value){
			var CaregiverStatus = Common_RadioLabel("radCaregiverStatus");   //当前选中的值
			if (CaregiverStatus==$g("其他")) {	
				$('#OtherStatus').removeAttr("disabled");
			}else{
				$('#OtherStatus').val("");
				$('#OtherStatus').attr('disabled','disabled');
			}
		}
	});
	
	$HUI.radio("[name='radInjure']",{  
		onChecked:function(e,value){
			var Injure = Common_RadioLabel("radInjure");   //当前选中的值
			if (Injure==$g("其他")) {	
				$('#Otherinjure').removeAttr("disabled");
			}else{
				$('#Otherinjure').val("");
				$('#Otherinjure').attr('disabled','disabled');
			}
		}
	});
	$HUI.radio("[name='radInjurePalce']",{  
		onChecked:function(e,value){
			var InjurePalce = Common_RadioLabel("radInjurePalce");   //当前选中的值
			if (InjurePalce==$g("其他")) {	
				$('#OtherInjurePalce').removeAttr("disabled");
			}else{
				$('#OtherInjurePalce').val("");
				$('#OtherInjurePalce').attr('disabled','disabled');
			}
		}
	});
	$HUI.radio("[name='radInjureSystem']",{  
		onChecked:function(e,value){
			var InjureSystem = Common_RadioLabel("radInjureSystem");   //当前选中的值
			if (InjureSystem==$g("其他")) {	
				$('#OtherInjureSystem').removeAttr("disabled");
			}else{
				$('#OtherInjureSystem').val("");
				$('#OtherInjureSystem').attr('disabled','disabled');
			}
		}
	});
	$HUI.radio("[name='radInjuryEnd']",{  
		onChecked:function(e,value){
			var InjuryEnd = Common_RadioLabel("radInjuryEnd");   //当前选中的值
			if (InjuryEnd==$g("其他")) {	
				$('#OtherEnd').removeAttr("disabled");
			}else{
				$('#OtherEnd').val("");
				$('#OtherEnd').attr('disabled','disabled');
			}
		}
	});
	
	
	
	
	//显示按钮操作权限 根据报告状态与操作权限控制
		obj.InitRepPowerByStatus = function(ReportID){		
		$('#btnSave').hide();
		$('#btnPrint').hide();
		$('#btnCanCheck').hide();
		$('#btnExport').hide();
		$('#btnDelete').hide();
		$('#btnCheck').hide();
		$('#btnCancle').hide();
		$('#btnSaveTemp').hide();
		$('#btnReturn').hide();
		
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
				$('#btnCheck').show();
				$('#btnExport').show();
				$('#btnPrint').show();
				$('#btnCancle').show();
				if(LocFlag==1){$('#btnReturn').show();}
				break;
			case "2" : // 审核
				$('#btnCanCheck').show();
				$('#btnPrint').show();
				$('#btnExport').show();
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
		if (tDHCMedMenuOper['Check']!=1) {//没有审核权限，隐藏审核按钮
			$('#btnCheck').hide();
			$('#btnCanCheck').hide();
		}
		if (tDHCMedMenuOper['Check']) {
			$('#btnDelete').hide();
		}
		// 医生站不能审核
		if (LocFlag=="0"){
			$('#btnCheck').hide();
			$('#btnCanCheck').hide();
		}
		$('#btnExport').hide();
	}
	//显示数据
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			
			$('#HospNumber').val(ServerObj.ETSHDefaultHospNo);                   // 监测医院编号
			$('#EnterUser').val(DocName);                //报告医生
			$('#CRReportOrgan').val(HospDesc);                                //报告单位  
			$('#EnterDate').datebox('setValue',Common_GetDate(new Date()));  //报告日期
			$('#cboCRReportLoc').combobox('setValue',LocID);                    //报卡科室
			$('#cboCRReportLoc').combobox('setText',LocDesc);   
			if(PatientID!=""){
				var objPat = $cm({                  
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				$('#txtPatName').val(objPat.PatientName);                  // 姓名
				$('#txtSex').val(objPat.Sex);                              // 性别
				$('#txtPatCardNo').val(objPat.PersonalID);                 // 身份证号
				$('#txtBirthDay').datebox('setValue',objPat.Birthday);     // 生日
				$('#cboNation').combobox('setValue',objPat.Nation);        //民族
			
				if (ServerObj.CurrAddress) {// 现地址
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
		    var objETSH = $m({                  
				ClassName:"DHCMed.CD.CRReportETSH",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var objPat = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			var arrETSH=objETSH.split("^");
			var arrPat=objPat.split("^");
			console.log(arrPat);
			$('#HospNumber').val(arrETSH[0]);
			Common_SetRadioValue("RadLocType",arrETSH[1].split(CHR_1)[0]);
			$('#CardNo').val(arrETSH[2]);
			$('#txtPatName').val(arrPat[4]);
			$('#txtPatCardNo').val(arrPat[11]);
			$('#txtSex').val(arrPat[6]);
			$('#txtBirthDay').datebox('setValue',arrPat[7]);  
			$('#Height').val(arrETSH[3]);
			$('#Weight').val(arrETSH[4]);
			$('#cboNation').combobox('setValue',arrPat[13].split(CHR_1)[0]);             
			$('#cboNation').combobox('setText',arrPat[13].split(CHR_1)[1]);
			$('#cboSchool').combobox('setValue',arrETSH[5].split(CHR_1)[0]);             
			$('#cboSchool').combobox('setText',arrETSH[5].split(CHR_1)[1]);
			$('#cboRegister').combobox('setValue',arrETSH[6].split(CHR_1)[0]);             
			$('#cboRegister').combobox('setText',arrETSH[6].split(CHR_1)[1]);
			$('#cboFather').combobox('setValue',arrETSH[7].split(CHR_1)[0]);             
			$('#cboFather').combobox('setText',arrETSH[7].split(CHR_1)[1]);
			$('#cboMather').combobox('setValue',arrETSH[8].split(CHR_1)[0]);             
			$('#cboMather').combobox('setText',arrETSH[8].split(CHR_1)[1]);
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
			$('#InjuryHappenTime').datetimebox('setValue',arrETSH[9]);  
			$('#AdmTime').datetimebox('setValue',arrETSH[10]);  
			Common_SetRadioValue("radInjuryReason",arrETSH[11].split(CHR_1)[0]);
			$('#OtherReason').val(arrETSH[12]);
			Common_SetRadioValue("radInjuryplace",arrETSH[13].split(CHR_1)[0]);
			$('#OtherPlace').val(arrETSH[14]);
			Common_SetRadioValue("radInjuryActivity",arrETSH[15].split(CHR_1)[0]);
			$('#OtherActivity').val(arrETSH[16]);
			Common_SetRadioValue("radIsWillfully",arrETSH[17].split(CHR_1)[0]);
			$('#OtherWillfully').val(arrETSH[18]);
			Common_SetRadioValue("radIsDrink",arrETSH[19].split(CHR_1)[0]);
			Common_SetRadioValue("radIsCaregiver",arrETSH[20].split(CHR_1)[0]);
			Common_SetRadioValue("radCaregiverType",arrETSH[21].split(CHR_1)[0]);
			Common_SetRadioValue("radCaregiverStatus",arrETSH[22].split(CHR_1)[0]);
			$('#OtherStatus').val(arrETSH[23]);
			Common_SetRadioValue("radInjure",arrETSH[24].split(CHR_1)[0]);
			$('#Otherinjure').val(arrETSH[25]);
			Common_SetRadioValue("radInjurePalce",arrETSH[26].split(CHR_1)[0]);
			$('#OtherInjurePalce').val(arrETSH[27]);
			Common_SetRadioValue("radInjureSystem",arrETSH[28].split(CHR_1)[0]);
			$('#OtherInjureSystem').val(arrETSH[29]);
			$('#PTSScore').val(arrETSH[30]);
			Common_SetRadioValue("radAirwayStatus",arrETSH[31].split(CHR_1)[0]);
			Common_SetRadioValue("radSBP",arrETSH[32].split(CHR_1)[0]);
			Common_SetRadioValue("radCentralSystem",arrETSH[33].split(CHR_1)[0]);
			Common_SetRadioValue("radOpenWound",arrETSH[34].split(CHR_1)[0]);
			Common_SetRadioValue("radFracture",arrETSH[35].split(CHR_1)[0]);
			Common_SetRadioValue("radInjurySeverity",arrETSH[36].split(CHR_1)[0]);
			$('#InjuryDiag').val(arrETSH[37]);
			Common_SetRadioValue("radInjuryEnd",arrETSH[38].split(CHR_1)[0]);
			$('#OtherEnd').val(arrETSH[39]);
			
			$('#CRReportOrgan').val(arrRep[6]);
			$('#cboCRReportLoc').combobox('setValue',arrRep[3]);
			$('#cboCRReportLoc').combobox('setText',arrRep[4]);
			$('#EnterUser').val(arrRep[5]);
			$('#EnterDate').datebox('setValue',arrRep[7]);
			
			
			
		}
	};
	//得到报告数据
	obj.GetRepData = function (step) {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"ETSH";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3作废
		InputStr=InputStr+"^"+$.trim($('#cboCRReportLoc').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#EnterUser').val());
		InputStr=InputStr+"^"+$.trim($('#CRReportOrgan').val());
		InputStr=InputStr+"^"+$('#EnterDate').datebox('getValue');
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		return InputStr;
	}
	
	obj.GetETSHData = function () {
		// Common_RadioValue
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+$.trim($('#HospNumber').val());                  // 监测医院编号
		InputStr=InputStr+"^"+Common_RadioValue("RadLocType");    			   // 就诊科室类型
		InputStr=InputStr+"^"+$.trim($('#CardNo').val());                  	   // 卡片编号
		InputStr=InputStr+"^"+$.trim($('#Height').val());                      // 身高
		InputStr=InputStr+"^"+$.trim($('#Weight').val());                      // 体重
		InputStr=InputStr+"^"+$.trim($('#cboRegister').combobox('getValue'));  // 户籍
		InputStr=InputStr+"^"+$.trim($('#cboSchool').combobox('getValue'));    // 就学情况
		InputStr=InputStr+"^"+$.trim($('#cboFather').combobox('getValue'));    // 父亲教育程度
		InputStr=InputStr+"^"+$.trim($('#cboMather').combobox('getValue'));    // 母亲教育程度
		InputStr=InputStr+"^"+$('#InjuryHappenTime').datetimebox('getValue');  // 伤害发生时间
		InputStr=InputStr+"^"+$('#AdmTime').datetimebox('getValue');  		   // 患者就诊时间
		InputStr=InputStr+"^"+Common_RadioValue("radInjuryReason");    		   // 伤害发生原因
		InputStr=InputStr+"^"+$.trim($('#OtherReason').val());                 // 其他原因
		InputStr=InputStr+"^"+Common_RadioValue("radInjuryplace");    		   // 伤害发生地点
		InputStr=InputStr+"^"+$.trim($('#OtherPlace').val());                  // 其他发生地点
		InputStr=InputStr+"^"+Common_RadioValue("radInjuryActivity");    	   // 伤害发生时活动
		InputStr=InputStr+"^"+$.trim($('#OtherActivity').val());               // 其他活动
		InputStr=InputStr+"^"+Common_RadioValue("radIsWillfully");    	   	   // 是否故意
		InputStr=InputStr+"^"+$.trim($('#OtherWillfully').val());              // 其他故意
		InputStr=InputStr+"^"+Common_RadioValue("radIsDrink");    	   	   	   // 伤者饮酒情况
		InputStr=InputStr+"^"+Common_RadioValue("radIsCaregiver");    	   	   // 是否有看护人在场
		InputStr=InputStr+"^"+Common_RadioValue("radCaregiverType");    	   // 受伤时看护人类别
		InputStr=InputStr+"^"+Common_RadioValue("radCaregiverStatus");    	   // 受伤时看护人状态
		InputStr=InputStr+"^"+$.trim($('#OtherStatus').val());                 // 其他看护人状态
		InputStr=InputStr+"^"+Common_RadioValue("radInjure");    	   	   	   // 伤害性质
		InputStr=InputStr+"^"+$.trim($('#Otherinjure').val());                 // 其他伤害性质
		InputStr=InputStr+"^"+Common_RadioValue("radInjurePalce");    	   	   // 伤害部位
		InputStr=InputStr+"^"+$.trim($('#OtherInjurePalce').val());            // 其他伤害部位
		InputStr=InputStr+"^"+Common_RadioValue("radInjureSystem");    	   	   // 伤害累及系统
		InputStr=InputStr+"^"+$.trim($('#OtherInjureSystem').val());           // 其他累及系统
		InputStr=InputStr+"^"+$.trim($('#PTSScore').val());          		   // 儿童创伤评分
		InputStr=InputStr+"^"+Common_RadioValue("radAirwayStatus");    	   	   // 气道状态
		InputStr=InputStr+"^"+Common_RadioValue("radSBP");    	   	   		   // 收缩期血压
		InputStr=InputStr+"^"+Common_RadioValue("radCentralSystem");    	   // 中枢神经系统
		InputStr=InputStr+"^"+Common_RadioValue("radOpenWound");    	   	   // 开放性伤口
		InputStr=InputStr+"^"+Common_RadioValue("radFracture");    	   	   	   // 骨折
		InputStr=InputStr+"^"+Common_RadioValue("radInjurySeverity");    	   // 伤害严重程度
		InputStr=InputStr+"^"+$.trim($('#InjuryDiag').val());          		   // 伤害临床诊断
		InputStr=InputStr+"^"+Common_RadioValue("radInjuryEnd");    	   	   // 伤害结局
		InputStr=InputStr+"^"+$.trim($('#OtherEnd').val());           		   // 其他伤害结局
		return InputStr;	
	}
	
	obj.GetPatData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+"";            
		InputStr=InputStr+"^"+"";            
		InputStr=InputStr+"^"+"";            
		InputStr=InputStr+"^"+$.trim($('#txtPatName').val());
		InputStr=InputStr+"^"+"";  
		InputStr=InputStr+"^"+$.trim($('#txtSex').val());    
		InputStr=InputStr+"^"+$('#txtBirthDay').datebox('getValue');   
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+$.trim($('#txtPatCardNo').val());
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+$.trim($('#cboNation').combobox('getValue'));  //民族
		InputStr=InputStr+"^"+"";  
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+"";   
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+$.trim($('#cboCurrProvince').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCurrCity').combobox('getValue')); 
		InputStr=InputStr+"^"+$.trim($('#cboCurrCounty').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCurrVillage').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCurrRoad').val());  //25
		InputStr=InputStr+"^"+$.trim($('#txtCurrAddress').val());
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
		$('#btnExport').on("click", function(){
			obj.btnExport_click(); 
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
		var RepData = obj.GetRepData(4);
		var ETSHData= obj.GetETSHData();
		var PatData = obj.GetPatData();
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:ETSHData,
			PatInfo:PatData,
			ExtraInfo:obj.ReportID
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("草稿数据保存错误!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("草稿数据保存成功！<br>请及时完善儿童伤害卡信息!"), 'info');
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
	//保存
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData = obj.GetRepData(1);
		var ETSHData= obj.GetETSHData();
		var PatData = obj.GetPatData();
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:ETSHData,
			PatInfo:PatData,
			ExtraInfo:obj.ReportID
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
		console.log(ReturnStr);
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
	//作废
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
	//审核
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
	/*obj.btnExport_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("错误","请先做【上报】操作", 'error');
			return;
		}
		var ExportStr=obj.ReportID;
		ExportStr=ExportStr+"^"+session['LOGON.USERID'];
		ExportStr=ExportStr+"^"+session['LOGON.CTLOCID'];
		ExportStr=ExportStr+"^"+"EXPORT";
		
		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"ExportReport",
			aInput:ExportStr,
			separete:"^"
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert("错误","报告导出失败!"+ret, 'error');
			return;
		}else{
			var fileName="DHCMA_CD_PrintReportETSH.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
			DHCCPM_RQPrint(fileName);
		}
	};*/
	obj.btnPrint_click = function(){
		
		if (obj.ReportID==""){
			$.messager.alert($g("提示"),$g("打印失败！找不到这份报告") , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintCDETSHReport");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.cd.lodopetsh.csp?ReportID="+obj.ReportID);
		LODOP.PRINT();			//直接打印
	};
	obj.btnCancle_click = function(){
		websys_showModal('close');
	};
	
	//检查规范
	obj.CheckReport = function(){
		var errStr = "";
		if (Common_RadioValue("RadLocType") == "") {
			errStr += $g("就诊科室类型不允许为空!<br>");		
		}

		if ($.trim($('#txtPatName').val()) == "") {
			errStr += $g("姓名不允许为空!<br>");		//病人姓名
		}
		if ($.trim($('#txtSex').val()) == "") {
			errStr += $g("性别不允许为空!<br>");		//性别
		}
		if ($('#txtBirthDay').datebox('getValue') == "") {
			errStr += $g("出生日期不允许为空!<br>");		//生日
		}
		if ($.trim($('#cboNation').combobox('getValue')) == "") {
			errStr += $g("请选择民族!<br>");		//民族
		}
		if ($.trim($('#cboRegister').combobox('getValue')) == "") {
			errStr += $g("请选择户籍!<br>");		// 户籍
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			errStr += $g("身份证号不能为空!<br>");		//身份证号
		}
		// 身份证格式验证	
		if ($.trim($('#txtPatCardNo').val()) != ""){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test($.trim($('#txtPatCardNo').val())))) {
				errStr += $g('输入的身份证号格式不符合规定！请重新输入!<br>');
			}
		}
		if ($.trim($('#cboCurrProvince').combobox('getValue')) == "") {
			errStr += $g("请选择目前居住地址省!<br>");		//省
		}
		if ($.trim($('#cboCurrCity').combobox('getValue')) == "") {
			errStr += $g("请选择目前居住地址市!<br>");		//市
		}
		if ($.trim($('#cboCurrCounty').combobox('getValue')) == "") {
			errStr += $g("请选择目前居住地址县!<br>");		//县
		}
		if ($.trim($('#cboCurrVillage').combobox('getValue')) == "") {
			errStr += $g("请选择目前居住地址街道!<br>");		//街道
		}
		if ($.trim($('#txtCurrRoad').val()) == "") {
			errStr += $g("目前居住地址村不允许为空!<br>");		//村
		}  
		if ($.trim($('#txtCurrAddress').val()) == "") {
			errStr += $g("目前居住详细地址不允许为空!<br>");		//详细地址		
		} 
		if ($('#InjuryHappenTime').datetimebox('getValue') == "") {
			errStr += $g("伤害发生时间不允许为空!<br>");		// 伤害发生时间		
		} 
		if ($('#AdmTime').datetimebox('getValue') == "") {
			errStr += $g("患者就诊时间不允许为空!<br>");		// 患者就诊时间		
		} 
		var InjuryDateTime = $('#InjuryHappenTime').datetimebox('getValue');
		var AdmDateTime = $('#AdmTime').datetimebox('getValue');
		var NowDate = Common_GetDate(new Date());   //  当前日期
		var NowTime = Common_GetCurrDateTime(new Date());   //  当前时间
		
		var InjuryDate 	= InjuryDateTime.split(" ")[0];
		var InjuryTime 	= InjuryDateTime.split(" ")[1];
		var AdmDate 	= AdmDateTime.split(" ")[0];
		var AdmTime 	= AdmDateTime.split(" ")[1];
		
		if (Common_CompareDate(InjuryDate,NowDate)>0){
			errStr += $g("伤害发生日期不允许大于当前日期!<br>");
		}
		if ((InjuryDate==NowDate)&&(Common_CompareTime(InjuryTime,NowTime)>0)){
			errStr += $g("伤害发生日期等于当前日期,但伤害发生时间不能大于当前时间!<br>");
			
		}
		if (Common_CompareDate(AdmDate,NowDate)>0){
			errStr += $g("就诊日期不允许大于当前日期!<br>");
		}
		if ((AdmDate==NowDate)&&(Common_CompareTime(AdmDate,NowTime)>0)){
			errStr += $g("就诊日期等于当前日期,但就诊时间不能大于当前时间!<br>");
			
		}
		
		if (Common_CompareDate(InjuryDate,AdmDate)>0){
			errStr += $g("伤害发生日期不允许大于就诊日期!<br>");
		}
		if ((InjuryDate==AdmDate)&&(Common_CompareTime(InjuryTime,AdmTime)>0)){
			errStr += $g("伤害发生日期等于就诊日期,但伤害发生时间不能大于就诊时间!<br>");
			
		}
		
		
		if(errStr != "") {
			$.messager.alert($g("提示"), errStr, 'info');
			return false;
		}
		return true;
	}

}


