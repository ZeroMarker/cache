function InitReportWinEvent(obj) {
	obj.LoadEvent = function(){
		obj.LoadListInfo();
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
		$('#btnExport').hide();
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
				$('#btnSaveTemp').show();
				$('#btnSave').show();
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
		$('#btnExport').hide();
	}
	
	obj.DisplayRepInfo = function(){
		var GXBZD = "";
		var NCZZD = "";
		var TNBZD = "";
		if(obj.ReportID==""){
			$('#txtCRReportUser').val(DocName);
			$('#txtCRReportOrgan').val(HospDesc);
			$('#txtCRReportDate').datebox('setValue',Common_GetDate(new Date()));
			$('#cboCRReportLoc').combobox('setValue',LocID);                    //报卡科室
			$('#cboCRReportLoc').combobox('setText',LocDesc);                            
					
			if(PatientID!=""){
				var objPat = $cm({                  
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				
				$('#txtMZH').val(objPat.OutPatientMrNo);
				$('#txtZYH').val(objPat.InPatientMrNo);
				$('#txtPatName').val(objPat.PatientName);
				$('#txtPatSex').val(objPat.Sex);
				$('#txtBirthDay').datebox('setValue',objPat.Birthday);
				var PersonalIDType=objPat.PersonalIDType;				//证件类型
				if(PersonalIDType!=$g("居民身份证")){
					$('#txtPatCardNo').val("");     
				}
				else{
					$('#txtPatCardNo').val(objPat.PersonalID);                //身份证号
				}
				//$('#cboCRMZ').combobox('setValue',objPat.Nation);  //民族需手工选择    
				$('#txtLXDH').val(objPat.Telephone);
				$('#txtGZDW').val(objPat.WorkAddress);
				
				var AgeY=objPat.Age;
				var AgeM=objPat.AgeMonth;
				var AgeD=objPat.AgeDay;
				if (AgeY>0){
					$('#txtPatAge').val(objPat.Age);
					$('#cboPatAgeDW').combobox('setValue',$g('岁'));
				}else if(AgeM>0){
					$('#txtPatAge').val(objPat.AgeMonth);
					$('#cboPatAgeDW').combobox('setValue',$g('月'));
				}else if(AgeD>0){
					$('#txtPatAge').val(objPat.AgeDay);
					$('#cboPatAgeDW').combobox('setValue',$g('天'));
				}else{
					$('#txtPatAge').val($g("未知"));
					$('#cboPatAgeDW').combobox('setValue','');
				}
				
				if (ServerObj.CurrAddress) {// 现地址
					$('#cboProvince1').combobox('setValue',ServerObj.CurrAddress.split("^")[0]);                    
					$('#cboProvince1').combobox('setText',ServerObj.CurrAddress.split("^")[1]);                  
					$('#cboCity1').combobox('setValue',ServerObj.CurrAddress.split("^")[2]);                    
					$('#cboCity1').combobox('setText',ServerObj.CurrAddress.split("^")[3]);                  
					$('#cboCounty1').combobox('setValue',ServerObj.CurrAddress.split("^")[4]);                    
					$('#cboCounty1').combobox('setText',ServerObj.CurrAddress.split("^")[5]);                  
					$('#cboVillage1').combobox('setValue',ServerObj.CurrAddress.split("^")[6]);                    
					$('#cboVillage1').combobox('setText',ServerObj.CurrAddress.split("^")[7]);                  
					$('#txtCUN1').val(ServerObj.CurrAddress.split("^")[8]);    
					$('#txtAdress1').val(ServerObj.PatCurrAddress);
				}	

				if (ServerObj.RegAddress) {// 户籍地址
					$('#cboProvince2').combobox('setValue',ServerObj.RegAddress.split("^")[0]);                    
					$('#cboProvince2').combobox('setText',ServerObj.RegAddress.split("^")[1]);                  
					$('#cboCity2').combobox('setValue',ServerObj.RegAddress.split("^")[2]);                    
					$('#cboCity2').combobox('setText',ServerObj.RegAddress.split("^")[3]);                  
					$('#cboCounty2').combobox('setValue',ServerObj.RegAddress.split("^")[4]);                    
					$('#cboCounty2').combobox('setText',ServerObj.RegAddress.split("^")[5]);                  
					$('#cboVillage2').combobox('setValue',ServerObj.RegAddress.split("^")[6]);                    
					$('#cboVillage2').combobox('setText',ServerObj.RegAddress.split("^")[7]);                  
					$('#txtCUN2').val(ServerObj.RegAddress.split("^")[8]);    
					$('#txtAdress2').val(ServerObj.PatRegAddress);
				}
				
				if (ServerObj.DicInfo) {// 字典赋值
				    var NationInfo = ServerObj.DicInfo.split("^")[1];
				   	var EducationInfo = ServerObj.DicInfo.split("^")[5];
				    var OccupationInfo = ServerObj.DicInfo.split("^")[3];
				
					$('#cboCRMZ').combobox('setValue',((NationInfo.split(",")[0]) ? NationInfo.split(",")[0]:''));            //民族		     	    $('#cboNation').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:'')); 
		     		$('#cboCRMZ').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:''));            //民族		     	    $('#cboNation').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:'')); 
		     		$('#cboEducation').combobox('setValue',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[0]:''));            //民族
		     	    $('#cboEducation').combobox('setText',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[2]:'')); 
		     		$('#cboCRZY').combobox('setValue',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[0]:''));        //职业
		     	    $('#cboCRZY').combobox('setText',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[2]:''));  
				}									
			}
		}else{
			var objRep = $m({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false);
	
		    var objMBBK = $m({                  
				ClassName:"DHCMed.CD.CRReportMBBK",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			
			var objPat = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			var arrMBBK=objMBBK.split("^");
			var arrPat=objPat.split("^");
		 
			$('#txtMZH').val(arrPat[1]);
			$('#txtZYH').val(arrPat[2]);
			$('#txtPatName').val(arrPat[4]);
			$('#txtPatCardNo').val(arrPat[11]);
			$('#txtPatSex').val(arrPat[6]);
			var patAge="";
			var patAgeDW="";
			if(arrPat[8]!=""){
				patAge=arrPat[8];
				patAgeDW=$g("岁");
			}else if(arrPat[9]!=""){
				patAge=arrPat[9];
				patAgeDW=$g("月");
			}else if(arrPat[10]!=""){
				 if(arrPat[10]!=$g("未知")){
					patAge=arrPat[10];
					patAgeDW=$g("天");
				 }else{
					 patAge=arrPat[10];
					 patAgeDW="";
				 }
			}
			$('#txtPatAge').val(patAge);
			$('#cboPatAgeDW').combobox('setValue',patAgeDW);
			$('#txtBirthDay').datebox('setValue',arrPat[7]);
			$('#cboEducation').combobox('setValue',arrPat[15].split(CHR_1)[0]);
			$('#cboEducation').combobox('setText',arrPat[15].split(CHR_1)[1]);
			$('#cboCRZY').combobox('setValue',arrPat[16].split(CHR_1)[0]);
			$('#cboCRZY').combobox('setText',arrPat[16].split(CHR_1)[1]);
			$('#cboCRMZ').combobox('setValue',arrPat[13].split(CHR_1)[0]);
			$('#cboCRMZ').combobox('setText',arrPat[13].split(CHR_1)[1]);
			$('#txtLXDH').val(arrPat[20]);
			$('#txtGZDW').val(arrPat[21]);
	
			$('#cboProvince1').combobox('setValue',arrPat[23].split(CHR_1)[0]);
			$('#cboProvince1').combobox('setText',((arrPat[23].indexOf(CHR_1)>-1) ? arrPat[23].split(CHR_1)[1] : ''));
			$('#cboCity1').combobox('setValue',arrPat[24].split(CHR_1)[0]);
			$('#cboCity1').combobox('setText',((arrPat[24].indexOf(CHR_1)>-1) ? arrPat[24].split(CHR_1)[1] : ''));
			$('#cboCounty1').combobox('setValue',arrPat[25].split(CHR_1)[0]);
			$('#cboCounty1').combobox('setText',((arrPat[25].indexOf(CHR_1)>-1) ? arrPat[25].split(CHR_1)[1] : ''));
			$('#cboVillage1').combobox('setValue',arrPat[26].split(CHR_1)[0]);
			$('#cboVillage1').combobox('setText',((arrPat[26].indexOf(CHR_1)>-1) ? arrPat[26].split(CHR_1)[1] : ''));	
			$('#txtCUN1').val(arrPat[27]);
		
			$('#cboProvince2').combobox('setValue',arrPat[29].split(CHR_1)[0]);
			$('#cboProvince2').combobox('setText',((arrPat[29].indexOf(CHR_1)>-1) ? arrPat[29].split(CHR_1)[1] : ''));
			$('#cboCity2').combobox('setValue',arrPat[30].split(CHR_1)[0]);
		    $('#cboCity2').combobox('setText',((arrPat[30].indexOf(CHR_1)>-1) ? arrPat[30].split(CHR_1)[1] : ''));
			$('#cboCounty2').combobox('setValue',arrPat[31].split(CHR_1)[0]);
			$('#cboCounty2').combobox('setText',((arrPat[31].indexOf(CHR_1)>-1) ? arrPat[31].split(CHR_1)[1] : ''));
			$('#cboVillage2').combobox('setValue',arrPat[32].split(CHR_1)[0]);
			$('#cboVillage2').combobox('setText',((arrPat[32].indexOf(CHR_1)>-1) ? arrPat[32].split(CHR_1)[1] : ''));
			$('#txtCUN2').val(arrPat[33]);
			
			$('#txtCRReportOrgan').val(arrRep[6]);
			$('#cboCRReportLoc').combobox('setValue',arrRep[3]);
			$('#cboCRReportLoc').combobox('setText',arrRep[4]);
			$('#txtCRReportUser').val(arrRep[5]);
			$('#txtCRReportDate').datebox('setValue',arrRep[7]);
			
			$('#txtCRKPBH').val(arrMBBK[0]);
			if (arrMBBK[1].split(CHR_1)[0]) {
				$HUI.radio('#radBGKLXList'+arrMBBK[1].split(CHR_1)[0]).setValue(true); //报卡类型
			}
			$('#txtFBRQ').datebox('setValue',Common_FormatDate(arrMBBK[2]));
			if (arrMBBK[3].split(CHR_1)[0]) {
				$HUI.radio('#radSFFBRQGJList'+arrMBBK[3].split(CHR_1)[0]).setValue(true); //发病日期为估计
			}
			$('#txtQZRQ').datebox('setValue',arrMBBK[4]);
			$('#txtCRSWRQ').datebox('setValue',arrMBBK[5]);
			$('#txtCRJTSWYY').val(arrMBBK[7]);
			
			for (var len=0; len < arrMBBK[10].split(',').length;len++) {         
				var valueCode = arrMBBK[10].split(',')[len];
				$('#chkCRZDYJList'+valueCode).checkbox('setValue', (valueCode!="" ? true:false));                //诊断依据
			}     
			$('#cboCRZDDW').combobox('setValue',arrMBBK[11].split(CHR_1)[0]);
			$('#cboCRZDDW').combobox('setText',arrMBBK[11].split(CHR_1)[1]);
			$('#cboCRGXBZDList').combobox('setValue',arrMBBK[12].split(CHR_1)[0]);  //冠心病诊断
			$('#cboCRGXBZDList').combobox('setText',arrMBBK[12].split(CHR_1)[1]);
			$('#cboCRNCZZDList').combobox('setValue',arrMBBK[13].split(CHR_1)[0]);   //脑卒中诊断
			$('#cboCRNCZZDList').combobox('setText',arrMBBK[13].split(CHR_1)[1]);
			$('#cboCRTNBZDList').combobox('setValue',arrMBBK[14].split(CHR_1)[0]);  //糖尿病诊断
			$('#cboCRTNBZDList').combobox('setText',arrMBBK[14].split(CHR_1)[1]);
		
			obj.CRGZZDID = arrMBBK[17].split(CHR_1)[0];
			obj.CRZDMCID = arrMBBK[16].split(CHR_1)[0];
			$('#cboCRGZZD').lookup('setText',arrMBBK[17].split(CHR_1)[1]);
			$('#cboCRZDMC').lookup('setText',arrMBBK[16].split(CHR_1)[1]);
			$('#txtCRZDBM').val(arrMBBK[16].split(CHR_1)[2]);
			$('#txtCRGZZDICD').val(arrMBBK[17].split(CHR_1)[2]);
			$('#txtCRYFBW').val(arrMBBK[20]);
			$('#txtCRJFBW').val(arrMBBK[21]);
			$('#txtCRBLXLX').val(arrMBBK[22]);
			Common_SetValue("txtCRYFBW",arrMBBK[20]);
			Common_SetValue("txtCRJFBW",arrMBBK[21]);
		    if (arrMBBK[24].split(CHR_1)[0]) {
				$HUI.radio('#radCRSBWZList'+arrMBBK[24].split(CHR_1)[0]).setValue(true);    //报告科室位置
		    }
		}
	};
	
	obj.GetRepData = function (step) {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"MBBK";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3作废
		InputStr=InputStr+"^"+$.trim($('#cboCRReportLoc').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCRReportUser').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRReportOrgan').val());
		InputStr=InputStr+"^"+$('#txtCRReportDate').datebox('getValue');
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		
		return InputStr;
	}
	
	obj.GetMBBKData = function () {
		var InputStr=obj.ReportID;
		
		InputStr=InputStr+"^"+$.trim($('#txtCRKPBH').val());
		InputStr=InputStr+"^"+Common_RadioValue('radBGKLXList');
		InputStr=InputStr+"^"+$('#txtFBRQ').datebox('getValue');
		InputStr=InputStr+"^"+Common_RadioValue('radSFFBRQGJList');
		InputStr=InputStr+"^"+$('#txtQZRQ').datebox('getValue');
		InputStr=InputStr+"^"+$('#txtCRSWRQ').datebox('getValue');
		InputStr=InputStr+"^"+$.trim($('#txtCRJTSWYY').val());
		InputStr=InputStr+"^"+Common_CheckboxValue('chkCRZDYJList');
		InputStr=InputStr+"^"+$.trim($('#cboCRZDDW').combobox('getValue'));
		
		InputStr=InputStr+"^"+$.trim($('#cboCRGXBZDList').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCRNCZZDList').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCRTNBZDList').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCRZDBM').val());
		InputStr=InputStr+"^"+ obj.CRZDMCID;
		InputStr=InputStr+"^"+ obj.CRGZZDID;
		InputStr=InputStr+"^"+$.trim($('#txtCRYFBW').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRJFBW').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRBLXLX').val());
		InputStr=InputStr+"^"+Common_RadioValue('radCRSBWZList');

		return InputStr;
	}
	
	obj.GetPatData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+$.trim($('#txtMZH').val());
		InputStr=InputStr+"^"+$.trim($('#txtZYH').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatName').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatSex').val());
		InputStr=InputStr+"^"+$('#txtBirthDay').datebox('getValue');
		InputStr=InputStr+"^"+$.trim($('#cboCRMZ').combobox('getValue'));  
		InputStr=InputStr+"^"+$.trim($('#txtPatAge').val());
		InputStr=InputStr+"^"+$.trim($('#cboPatAgeDW').combobox('getValue'));   
		InputStr=InputStr+"^"+$.trim($('#cboEducation').combobox('getValue'));  
		InputStr=InputStr+"^"+$.trim($('#cboCRZY').combobox('getValue'));  
		InputStr=InputStr+"^"+$.trim($('#txtPatCardNo').val());
		InputStr=InputStr+"^"+$.trim($('#txtLXDH').val());
		InputStr=InputStr+"^"+$.trim($('#txtGZDW').val());
		
		InputStr=InputStr+"^"+$.trim($('#cboProvince1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCity1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCounty1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboVillage1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCUN1').val());   
		InputStr=InputStr+"^"+$.trim($('#cboProvince2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCity2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCounty2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboVillage2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCUN2').val());  
		
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
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var MBBKData=obj.GetMBBKData();
		var PatData=obj.GetPatData();
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:MBBKData,
			PatInfo:PatData
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
	// 草稿
	obj.btnSaveTemp_click = function(){
		var RepData=obj.GetRepData(4);
		var MBBKData=obj.GetMBBKData();
		var PatData=obj.GetPatData();
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:MBBKData,
			PatInfo:PatData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("草稿数据保存错误!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("草稿数据保存成功！<br>请及时完善慢病报卡信息"), 'info');
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
	obj.btnExport_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'error');
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
			$.messager.alert($g("错误"),$g("报告导出失败!")+ret, 'error');
			return;
		}else{
			//var cArguments=obj.ReportID;
			//var flg=ExportDataToExcel("","","慢性病报病卡("+$.trim($('#txtPatName').val())+")",cArguments);
			var fileName="DHCMA_CD_PrintReportMBBK.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
			DHCCPM_RQPrint(fileName);
		}
	};
	obj.btnPrint_click = function(){
		if (obj.ReportID==""){
			$.messager.alert($g("提示"),$g("打印失败！找不到这份报告") , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintCDMBBKReport");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.cd.lodopmbbk.csp?ReportID="+obj.ReportID);
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
		
		if (Common_RadioValue('radBGKLXList') == "") {
			errStr += $g("报告类型不允许为空!<br>");		//报告类型		
		}  
		if ($.trim($('#txtPatName').val()) == "") {
			errStr += $g("患者姓名不允许为空!<br>");		//患者姓名
		}
		if ($.trim($('#txtPatSex').val()) == "") {
			errStr += $g("性别不允许为空!<br>");		    //性别
		}
		if ($.trim($('#txtPatAge').val()) == "") {
			errStr += $g("年龄不允许为空!<br>");		    //年龄
		}
		if ($('#txtBirthDay').datebox('getValue') == "") {
			errStr += $g("出生日期不允许为空!<br>");		//出生日期		
		}  	
		if ($.trim($('#cboCRZY').combobox('getValue')) == "") {
			errStr += $g("请选择职业!<br>");		//职业
		}
		if ($.trim($('#cboEducation').combobox('getValue')) == "") {
			errStr += $g("请选择文化程度!<br>");		//文化程度
		}
		if ($.trim($('#txtLXDH').val()) == "") {
			errStr += $g("电话不允许为空!<br>");		  //联系电话
		}  
		if ($.trim($('#txtPatCardNo').val()) == "") {
			errStr += $g("身份证号不允许为空!<br>");		//身份证号
		}
		if ($.trim($('#txtPatCardNo').val()) != ""){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test($.trim($('#txtPatCardNo').val())))) {
				errStr += $g('输入的身份证号格式不符合规定！请重新输入!<br>');
			}
		}
		//电话号码格式验证 !(/^([0-9]{3,4}-)?[0-9]{7,8}$/.test(phone))
		if ($.trim($('#txtLXDH').val()) != ""){
			if (!(/^1[3456789]\d{9}$/.test($.trim($('#txtLXDH').val())))) {
				errStr += $g('输入的电话号码格式不符合规定！请重新输入!<br>');
			}
		}
		if ($.trim($('#cboProvince1').combobox('getValue')) == "") {
			errStr += $g("请选择户口地址省!<br>");		//省
		}
		if ($.trim($('#cboCity1').combobox('getValue')) == "") {
			errStr += $g("请选择户口地址市!<br>");		//市
		}
		if ($.trim($('#cboCounty1').combobox('getValue')) == "") {
			errStr += $g("请选择户口地址县!<br>");		//县
		}
		if ($.trim($('#cboVillage1').combobox('getValue')) == "") {
			errStr += $g("请选择户口地址乡!<br>");      //乡
		}
		if ($.trim($('#txtCUN1').val()) == "") {
			errStr += $g("户口地址村不允许为空!<br>");		        //村
		}  
		if ($.trim($('#cboProvince2').combobox('getValue')) == "") {
			errStr += $g("请选择现地址省!<br>");		//省
		}
		if ($.trim($('#cboCity2').combobox('getValue')) == "") {
			errStr += $g("请选择现地址市!<br>");		//市
		}
		if ($.trim($('#cboCounty2').combobox('getValue')) == "") {
			errStr += $g("请选择现地址县!<br>");		//县
		}
		if ($.trim($('#cboVillage2').combobox('getValue')) == "") {
			errStr += $g("请选择现地址乡!<br>");      //乡
		}
		if ($.trim($('#txtCUN2').val()) == "") {
			errStr += $g("现地址村不允许为空!<br>");		        //村
		}  
		if ($.trim($('#txtGZDW').val()) == "") {
			errStr += $g("工作单位不允许为空!<br>");		        //工作单位
		}  
		if ($.trim($('#cboCRZDDW').combobox('getValue')) == "") {
			errStr += $g("请选择诊断单位!<br>");      //诊断单位
		}
		
		if (Common_CheckboxValue('chkCRZDYJList') == "") {
			errStr += $g("诊断依据不允许为空!<br>");		//危险行为		
		}  
		if ($.trim($('#txtCRReportOrgan').val()) == "") {
			errStr += $g("现地址村不允许为空!<br>");		        //村
		}  
		if ($('#txtQZRQ').datebox('getValue') == "") {
			errStr += $g("确诊日期不允许为空!<br>");		//诊断日期		
		} 
		if (Common_RadioValue('radSFFBRQGJList') == "") {
			errStr += $g("发病日期为估计不允许为空!<br>");		//种类数量		
		}  		
		if (Common_RadioValue('radCRSBWZList') == "") {
			errStr += $g("报告科室所属位置不允许为空!<br>");		//种类数量		
		}  
		
		var NowDate = Common_GetDate(new Date());
		var txtQZRQ = $('#txtQZRQ').datebox('getValue');
		var txtCRSWRQ = $('#txtCRSWRQ').datebox('getValue');
		var txtFBRQ = $('#txtFBRQ').datebox('getValue');
		if (Common_CompareDate(txtQZRQ,NowDate)>0) {
			errStr += $g('确诊日期不允许大于当前日期!<br>');			
		}
		if (Common_CompareDate(txtFBRQ,txtQZRQ)>0) { 
			errStr += $g('发病日期不允许大于确诊日期!<br>');
		}
		if (Common_CompareDate(txtQZRQ,txtCRSWRQ)>0) { 
			errStr += $g('死亡日期必须大于确诊日期!<br>');
		}
		if (Common_CompareDate(txtCRSWRQ,NowDate)>0) { 
			errStr += $g('死亡日期不允许大于当前日期!<br>');
		}
		
		var CRGXBZD=$.trim($('#cboCRGXBZDList').combobox('getValue'));
		var CRNCZZD=$.trim($('#cboCRNCZZDList').combobox('getValue'));
		var CRTNBZD=$.trim($('#cboCRTNBZDList').combobox('getValue'));
		var CRZDMC=$.trim($('#cboCRZDMC').lookup('getText'));
		
		if ((CRGXBZD=="")&&(CRNCZZD=="")&&(CRTNBZD=="")&&(obj.CRZDMCID=="")) {
			errStr +=$g('冠心病、脑卒中、糖尿病、肿瘤诊断至少选择一项！');
		}
		if (obj.CRZDMCID!=""){
			var CRYFBW	= $.trim($('#txtCRYFBW').val());
			var CRBLXLX	= $.trim($('#txtCRBLXLX').val());
			var CRJFBW	= $.trim($('#txtCRJFBW').val());
			if (CRYFBW==""){
				errStr +=$g('已选择肿瘤病例，原发部位不能为空！');
			}
			if (CRBLXLX==""){
				errStr +=$g('已选择肿瘤病例，病理类型不能为空！');
			}
			if (CRJFBW==""){
				errStr +=$g('已选择肿瘤病例，继发部位不能为空！');
			}
		}
		var BGKLX=Common_RadioLabel('radBGKLXList');
		if ((BGKLX.indexOf($g('更正'))>-1)&&($.trim($('#cboCRGZZD').lookup('getText'))=='')) {
			errStr +=$g('报告类型为“更正”时需填写更正病名');
		}
		if((BGKLX.indexOf($g('死亡'))>-1)&&(($('#txtCRSWRQ').datebox('getValue')=="")||($.trim($('#txtCRJTSWYY').val())==""))) {
			errStr +=$g('报告类型为“死亡”时需填写死亡日期和死亡原因');
		}

		if(errStr != "") {
			$.messager.alert($g("提示"), errStr, 'info');
			return false;
		}
		return true;
	}
}


