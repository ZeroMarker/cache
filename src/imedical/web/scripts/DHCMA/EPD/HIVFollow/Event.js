function InitReportWinEvent(obj) {
	obj.LoadEvent = function(){
		obj.LoadListInfo();
		obj.RelationToEvents (); // 按钮监听事件 
		obj.DisplayRepInfo();
		obj.InitRepPowerByStatus(ReportID);		
	}

	//显示按钮操作权限 根据报告状态与操作权限控制
	obj.InitRepPowerByStatus = function(ReportID){	
		$('#btnSave').hide();
		$('#btnPrint').hide();
		$('#btnCancle').hide();
		$('#btnDelete').hide();
		$('#btnExport').hide();           //隐藏导出按钮
	
	    if (ReportID) { //存在报告
	    	$('#btnSave').linkbutton({text:$g('修改报卡')});
			$('#btnSave').show();
			$('#btnDelete').show();
			$('#btnExport').show();
			//$('#btnPrint').show();
			$('#btnCancle').show();
	    }else {   //无报告
		    $('#btnSave').show();
			$('#btnCancle').show();
	    }
	}
	obj.cboFollowStatus_select = function(){
		var FollowStatus=$('#cboFollowStatus').combobox('getText');
		if (FollowStatus==$g('随访')) {
			$('#cboReasons').combobox("disable");
			$('#txtFollowTimes').removeAttr("disabled");
			$('#cboReasons').combobox("clear");
		}else if(FollowStatus==$g("失访")){
			$('#cboReasons').combobox("enable");
			$('#txtFollowTimes').attr('disabled','disabled');
			$('#txtFollowTimes').val('');
			//$('#cboIsCustody').combobox("disable");
		}else {
			$('#cboReasons').combobox("disable");
			$('#txtFollowTimes').attr('disabled','disabled');
			$('#cboReasons').combobox("clear");
			$('#txtFollowTimes').val('');
			//$('#cboIsCustody').combobox("disable");
		}
	}
	
	
	//主要死因
	/*obj.cboDeathReason_select = function(){
		var DeathReason=$('#cboDeathReason').combobox('getText');
		if (DeathReason=='艾滋病相关疾病死亡') {
			$('#cbgDeathReasonHIV').checkbox('enable');
			$('#cbgDeathReasonOthers').checkbox('disable');
		}else if(DeathReason=='艾滋病无关死亡'){
			$('#cbgDeathReasonHIV').checkbox('disable');
			$('#cbgDeathReasonOthers').checkbox('enable');
		}else{
			$('#cbgDeathReasonHIV').checkbox('disable');
			$('#cbgDeathReasonOthers').checkbox('disable');
		}
	}
	
	obj.chkNeverHIVTest_check = function(){
		var HIVTest=Common_GetValue('chkNeverHIVTest');$('#cbgDeathReasonSource').combobox('getText');
		if (HIVTest){
			Common_SetValue('txtLastHIVTestDate',"");
			Common_SetDisabled("txtLastHIVTestDate",true);
		}else{
			Common_SetDisabled("txtLastHIVTestDate",false);
		}
	}
	//是否死亡
	obj.cboIsDead_select = function(){
		var IsDead=$('#cboIsDead').combobox('getText');
		if (IsDead=='是') {
			$('#txtDeathDate').datebox("enable");
			$('#cboDeathStage').combobox("enable");
			$('#cboDeathPlace').combobox("enable");
			$('#cboDeathReason').combobox("enable");
			$('#cbgDeathReasonSource').checkbox('enable');
		}else {
			$('#txtDeathDate').datebox("disable");
			$('#cboDeathStage').combobox("disable");
			$('#cboDeathPlace').combobox("disable");
			$('#txtDeathOtherPlace').attr('disabled','disabled');
			$('#cbgDeathReasonSource').checkbox('disable');
			$('#txtDeathOtherSource').attr('disabled','disabled');
			$('#cboDeathReason').combobox("disable");
			$('#cbgDeathReasonHIV').checkbox('disable');
			$('#cbgDeathReasonOthers').checkbox('disable');
		}
	}
	//死亡地点
	obj.cboDeathPlace_select = function(){
		var DeathPlace=$('#cboDeathPlace').combobox('getText');
		if (DeathPlace=='其他地点') {
			$('#txtDeathOtherPlace').removeAttr("disabled");
		}else {
			$('#txtDeathOtherPlace').attr('disabled','disabled');
		}
	}*/
	//显示数据
	obj.DisplayRepInfo = function(){
		
		var objPatient = $cm({                  
			ClassName:"DHCMed.Base.Patient",
			MethodName:"GetObjById",
			PAPMIRowId:PatientID
		},false);
		var arrEPDInfo=obj.arrEPDInfo
		$('#txtPatName').val(objPatient.PatientName);               //患者姓名
		//$('#txtPatSex').val(objPatient.Sex);                        //性别
		$('#txtParentName').val(arrEPDInfo[1]);          //患儿家长姓名
		$('#txtPhoneNo').val(objPatient.Telephone);             //联系电话
		$('#txtAddress').val(arrEPDInfo[3]);             //现在住址
		//alert(0)
		if(obj.ReportID==""){
			if (arrEPDInfo[4]==$g("居民身份证号")){
				//$('#txtPatNo').val(arrEPDInfo[5])                //身份证号
			}
			return;
		}else{
			var objReport = $cm({                  
				ClassName:"DHCMed.EPD.CaseFollow",
				MethodName:"GetObjById",
				ID:obj.ReportID
			},false);
			var objAllDate = $m({                  
				ClassName:"DHCMed.EPD.CaseFollow",
				MethodName:"GetDateById",
				aId:obj.ReportID
			},false);
			var DateArr=objAllDate.split("^")
			if(!!objReport.FollowNo){                       //编号
				$('#txtFollowNo').val(objReport.FollowNo);
			}
			//alert(1)
			if(!!objReport.FollowText1){                       //身份证号
				//$('#txtPatNo').val(objReport.FollowText1);
			}else{
				if (arrEPDInfo[4]==$g("居民身份证号")){
					//$('#txtPatNo').val(arrEPDInfo[5]);                
				}
			}
			//alert(objReport.FollowStatus)
			var objDic1 = $cm({                  
				ClassName:"DHCMed.SS.Dictionary",
				MethodName:"GetObjById",
				id:objReport.FollowStatus
			},false);
			if(objDic1!=""){
				$('#txtFollowTimes').val(objReport.FollowTimes);
				$('#cboFollowStatus').combobox('setValue',objReport.FollowStatus);
				$('#cboFollowStatus').combobox('setText',objDic1.Description);
				obj.cboFollowStatus_select();
			}
			if(objReport.IsCustody!=undefined){
				var objDic2 = $cm({                  
					ClassName:"DHCMed.SS.Dictionary",
					MethodName:"GetObjById",
					id:objReport.IsCustody
				},false);
			//if(objDic2!=""){
				//$('#cboIsCustody').combobox('setValue',objReport.IsCustody);
				//$('#cboIsCustody').combobox('setText',objDic2.Description);
			//}
				}
			//alert(2)
			if(objReport.Reasons!=undefined){
					var objDic3 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.Reasons
					},false);
					if(objDic3!=""){
						$('#cboReasons').combobox('setValue',objDic3.Description);
					}
				}
			/*var objDic4 = $cm({                  
				ClassName:"DHCMed.SS.Dictionary",
				MethodName:"GetObjById",
				id:objReport.IsHIVTest
			},false);*/
			//alert()
			//$HUI.radio('#cbgIsHIVTest'+objReport.IsHIVTest).setValue(true);
			//if(objDic4!=undefined){
				//$HUI.radio('#chkNeverHIVTest'+(objReport.NeverHIVTest==1?true:false)).setValue(true);      //
				//$('#txtLastHIVTestDate').datebox('setValue',DateArr[0]);  
				//$('#txtFirstHIVTestDate').datebox('setValue',DateArr[1]);  
				//$('#txtHIVTestTimes').val(objReport.HIVTestTimes);
			//}
			/*var objDic5 = $cm({                  
				ClassName:"DHCMed.SS.Dictionary",
				MethodName:"GetObjById",
				id:objReport.IsDead
			},false);
			if(objDic5!=undefined){
				$('#cboIsDead').combobox('setValue',objReport.IsDead);
				$('#cboIsDead').combobox('setText',objDic5.Description);
				obj.cboIsDead_select();
				$('#txtDeathDate').datebox('setValue',DateArr[2]);
			}
			if(objReport.DeathStage!=undefined){
				var objDic6 = $cm({                  
					ClassName:"DHCMed.SS.Dictionary",
					MethodName:"GetObjById",
					id:objReport.DeathStage
				},false);
				if(objDic6!=""){
					$('#cboDeathStage').combobox('setValue',objReport.DeathStage);
					$('#cboDeathStage').combobox('setText',objDic6.Description);
				}
			}
			if(objReport.DeathPlace!=undefined){
				var objDic7 = $cm({                  
					ClassName:"DHCMed.SS.Dictionary",
					MethodName:"GetObjById",
					id:objReport.DeathPlace
				},false);
				if(objDic7!=""){
					$('#cboDeathPlace').combobox('setValue',objReport.DeathPlace);
					$('#cboDeathPlace').combobox('setText',objDic7.Description);
					obj.cboDeathPlace_select();
					$('#txtDeathOtherPlace').val(objReport.DeathOtherPlace);
				}
			}
			var arrSourceRowID = $m({                  
				ClassName:"DHCMed.EPD.CaseFollow",
				MethodName:"GetFieldById",
				aId:obj.ReportID,
				aFieldName:"DeathReasonSource"
			},false);
			if(arrSourceRowID!=""){
				for (var len=0; len < arrSourceRowID.split(',').length;len++) { 
					var valueCode = arrSourceRowID.split(',')[len];
					$('#cbgDeathReasonSource'+valueCode).checkbox('setValue', (valueCode!="" ? true:false));              
				}             
			}
			//$('#txtDeathOtherSource').val(objReport.DeathOtherSource);
			if(objReport.DeathReason!=undefined){
					var objDic8 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.DeathReason
					},false);
					if(objDic8!=""){
						//$('#cboDeathReason').combobox('setValue',objReport.DeathReason);
						//$('#cboDeathReason').combobox('setText',objDic8.Description);
						//obj.cboDeathReason_select();
					}
				}
	
			var arrReasonHIVRowID = $m({                  
				ClassName:"DHCMed.EPD.CaseFollow",
				MethodName:"GetFieldById",
				aId:obj.ReportID,
				aFieldName:"DeathReasonHIV"
			},false);
			if(arrReasonHIVRowID!=""){
				for (var len=0; len < arrReasonHIVRowID.split(',').length;len++) { 
					var valueCode = arrReasonHIVRowID.split(',')[len];
					$('#cbgDeathReasonHIV'+valueCode).checkbox('setValue', (valueCode!="" ? true:false));              
				}             
			}
			var arrReasonOthersRowID = $m({                  
				ClassName:"DHCMed.EPD.CaseFollow",
				MethodName:"GetFieldById",
				aId:obj.ReportID,
				aFieldName:"DeathReasonOthers"
			},false);
			if(arrReasonOthersRowID!=""){
				for (var len=0; len < arrReasonOthersRowID.split(',').length;len++) { 
					var valueCode = arrReasonOthersRowID.split(',')[len];
					$('#cbgDeathReasonOthers'+valueCode).checkbox('setValue', (valueCode!="" ? true:false));              
				}             
			}*/
			//alert(22)
			var arrHIVRowID = $m({                  
				ClassName:"DHCMed.EPD.CaseFollow",
				MethodName:"GetFieldById",
				aId:obj.ReportID,
				aFieldName:"HIVManifestation"
			},false);
			if(arrHIVRowID!=""){
				for (var len=0; len < arrHIVRowID.split(',').length;len++) { 
					var valueCode = arrHIVRowID.split(',')[len];
					$('#cboHIVManifestation'+valueCode).checkbox('setValue', (valueCode!="" ? true:false));              
				}             
				//$HUI.radio('#cboHIVManifestation'+arrHIVRowID).setValue(true);
			}
			//alert(3)
			var objDic9 = $cm({                  
				ClassName:"DHCMed.SS.Dictionary",
				MethodName:"GetObjById",
				id:objReport.CourseStage
			},false);
			if(objDic9!=""){
				$('#cboCourseStage').combobox('setValue',objReport.CourseStage);
				$('#cboCourseStage').combobox('setText',objDic9.Description);
				$('#txtHIVDate').datebox('setValue',DateArr[3]);  
			}
			if(objReport.SpouseSituation!=undefined){
				var objDic10 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.SpouseSituation
					},false);
					if(objDic10!=""){
						$('#cboSpouseSituation').combobox('setValue',objReport.SpouseSituation);
						$('#cboSpouseSituation').combobox('setText',objDic10.Description);
					}
				}
			if(objReport.SpouseHIV!=undefined){
					var objDic11 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.SpouseHIV
					},false);
					if(objDic11!=""){
						$('#cboSpouseHIV').combobox('setValue',objReport.SpouseHIV);
						$('#cboSpouseHIV').combobox('setText',objDic11.Description);
					}
				}
				$('#txtSpouseHIVDate').datebox('setValue',DateArr[4]);
				$('#txtSpouseCaseNo').val(objReport.SpouseCaseNo);
				//$('#txtChildren').val(objReport.Children);
				//$('#txtChildren1').val(objReport.Children1);
				//$('#txtChildren2').val(objReport.Children2);
				//$('#txtChildren3').val(objReport.Children3);
				//$('#txtChildren4').val(objReport.Children4);
				/*if(objReport.HIVSurvey1!=undefined){
					var objDic12 = $cm({                  
							ClassName:"DHCMed.SS.Dictionary",
							MethodName:"GetObjById",
							id:objReport.HIVSurvey1
						},false);
						if(objDic12!=""){
							$('#cboHIVSurvey1').combobox('setValue',objReport.HIVSurvey1);
							$('#cboHIVSurvey1').combobox('setText',objDic12.Description);
						}
					}*/
				if(objReport.HIVSurvey2!=undefined){
					var objDic13 = $cm({                  
							ClassName:"DHCMed.SS.Dictionary",
							MethodName:"GetObjById",
							id:objReport.HIVSurvey2
						},false);
						if(objDic13!=""){
							$('#cboHIVSurvey2').combobox('setValue',objReport.HIVSurvey2);
							$('#cboHIVSurvey2').combobox('setText',objDic13.Description);
							//$('#txtHIVSurvey2No').val(objReport.HIVSurvey2No);
						}
					}
					//alert(4)
				/*if(objReport.HIVSurvey3!=undefined){
					var objDic14 = $cm({                  
							ClassName:"DHCMed.SS.Dictionary",
							MethodName:"GetObjById",
							id:objReport.HIVSurvey3
						},false);
						if(objDic14!=""){
							$('#cboHIVSurvey3').combobox('setValue',objReport.HIVSurvey3);
							$('#cboHIVSurvey3').combobox('setText',objDic14.Description);
						}
					}
				if(objReport.HIVSurvey4!=undefined){
					var objDic15 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVSurvey4
					},false);
					if(objDic15!=""){
						$('#cboHIVSurvey4').combobox('setValue',objReport.HIVSurvey4);
						$('#cboHIVSurvey4').combobox('setText',objDic15.Description);
						$('#txtHIVSurvey4No').val(objReport.HIVSurvey4No);
					}
				}
			if(objReport.HIVSurvey5!=undefined){
				var objDic16 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVSurvey5
					},false);
					if(objDic16!=""){
						$('#cboHIVSurvey5').combobox('setValue',objReport.HIVSurvey5);
						$('#cboHIVSurvey5').combobox('setText',objDic16.Description);
						$('#txtHIVSurvey5No').val(objReport.HIVSurvey5No);
						$('#txtHIVSurvey5No1').val(objReport.HIVSurvey5No1);
					}
				}
				if(objReport.HIVSurvey6!=undefined){
					var objDic17 = $cm({                  
							ClassName:"DHCMed.SS.Dictionary",
							MethodName:"GetObjById",
							id:objReport.HIVSurvey6
						},false);
						if(objDic17!=""){
							$('#cboHIVSurvey6').combobox('setValue',objReport.HIVSurvey6);
							$('#cboHIVSurvey6').combobox('setText',objDic17.Description);
							$('#txtHIVSurvey6No').val(objReport.HIVSurvey6No);
						}
					}
				if(objReport.HIVSurvey7!=undefined){
					var objDic18 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVSurvey7
					},false);
					if(objDic18!=""){
						$('#cboHIVSurvey7').combobox('setValue',objReport.HIVSurvey7);
						$('#cboHIVSurvey7').combobox('setText',objDic18.Description);
					}
				}
				if(objReport.IsHIVSurvey7!=undefined){
					var objDic19 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.IsHIVSurvey7
					},false);
					if(objDic19!=""){
						$('#cbgIsHIVSurvey7').combobox('setValue',objReport.IsHIVSurvey7);
						$('#cbgIsHIVSurvey7').combobox('setText',objDic19.Description);
					}
				}
			if(objReport.HIVSurvey8a!=undefined){
					var objDic20 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVSurvey8a
					},false);
					if(objDic20!=""){
						$('#cboHIVSurvey8a').combobox('setValue',objReport.HIVSurvey8a);
						$('#cboHIVSurvey8a').combobox('setText',objDic20.Description);
						$('#txtHIVSurvey8aNo1').val(objReport.HIVSurvey8aNo1);
						$('#txtHIVSurvey8aNo2').val(objReport.HIVSurvey8aNo2);
					}
				}
				if(objReport.HIVSurvey8!=undefined){
					var objDicHIVSurvey8 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVSurvey8
					},false);
					if(objDicHIVSurvey8!=""){
						$('#cboHIVSurvey8').combobox('setValue',objReport.HIVSurvey8);
						$('#cboHIVSurvey8').combobox('setText',objDicHIVSurvey8.Description);
					}
				}
			if(objReport.HIVSurvey8b!=undefined){
					var objDic21 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVSurvey8b
					},false);
					if(objDic21!=""){
						$('#cboHIVSurvey8b').combobox('setValue',objReport.HIVSurvey8b);
						$('#cboHIVSurvey8b').combobox('setText',objDic21.Description);
					}
				}
			if(objReport.HIVSurvey8c!=undefined){
					var objDic22 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVSurvey8b
					},false);
					if(objDic22!=""){
						$('#cboHIVSurvey8c').combobox('setValue',objReport.HIVSurvey8b);
						$('#cboHIVSurvey8c').combobox('setText',objDic22.Description);
					}
				}*/
			var arrHIVSurvey9RowID = $m({                  
				ClassName:"DHCMed.EPD.CaseFollow",
				MethodName:"GetFieldById",
				aId:obj.ReportID,
				aFieldName:"HIVSurvey9"
			},false);
			//alert(arrHIVSurvey9RowID)
			if(arrHIVSurvey9RowID!=""){
				    var arr=arrHIVSurvey9RowID.split(",")
				    //alert(arr)
				    //$('#cboHIVSurvey9').val(arr).trigger('change')
					var DicHIVSurveydesc = $m({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetDicDesc",
						id:arrHIVSurvey9RowID
					},false);
					var arr1=DicHIVSurveydesc.split(",")
					//alert(arrHIVSurvey9RowID+"^"+DicHIVSurveydesc)
					if(DicHIVSurveydesc!=""){
						$('#cboHIVSurvey9').combobox('setValues',arr);
						$('#cboHIVSurvey9').combobox('setText',arr1);
					}
			}
            //alert(5)
			if(objReport.HIVSurvey10!=undefined){
				var objDic25 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVSurvey10
					},false);
					if(objDic25!=""){
						$('#cboHIVSurvey10').combobox('setValue',objReport.HIVSurvey10);
						$('#cboHIVSurvey10').combobox('setText',objDic25.Description);
					}
				}
			if(objReport.IsHIVSurvey10!=undefined){
				var objDic26 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.IsHIVSurvey10
					},false);
					if(objDic26!=""){
						$('#cboIsHIVSurvey10').combobox('setValue',objReport.IsHIVSurvey10);
						$('#cboIsHIVSurvey10').combobox('setText',objDic26.Description);
					}
				}
				//alert(objReport.HIVPatBelong)
				if ((objReport.HIVPatBelong!="")&&(objReport.HIVPatBelong!=undefined)){
					var objDic22 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVPatBelong
					},false);
					//alert(objDic22)
					if((objDic22!="")&&(objDic22!=undefined)){
						$('#cboPatBelong').combobox('setValue',objReport.HIVPatBelong);
						$('#cboPatBelong').combobox('setText',objDic22.Description);
					}
				}
				if ((objReport.HIVTreatment!="")&&(objReport.HIVTreatment!=undefined)){
					var objDic23 = $cm({                  
						ClassName:"DHCMed.SS.Dictionary",
						MethodName:"GetObjById",
						id:objReport.HIVTreatment
					},false);
					//alert(objDic22)
					if((objDic23!="")&&(objDic23!=undefined)){
						$('#cboHIVTreatment').combobox('setValue',objReport.HIVTreatment);
						$('#cboHIVTreatment').combobox('setText',objDic23.Description);
					}
				}
				//alert(6)
				/*if(objReport.IsHIVSurvey11!=undefined){
					var objDic27 = $cm({                  
							ClassName:"DHCMed.SS.Dictionary",
							MethodName:"GetObjById",
							id:objReport.IsHIVSurvey11
						},false);
						if(objDic27!=""){
							$('#cboIsHIVSurvey11').combobox('setValue',objReport.IsHIVSurvey11);
							$('#cboIsHIVSurvey11').combobox('setText',objDic27.Description);
						}
					}*/
				//$('#txtIsHIVSurvey11No').val(objReport.IsHIVSurvey11No);
				//$('#txtCD4TestTimes').val(objReport.CD4TestTimes);
				$('#txtCD4TestResult').val(objReport.CD4TestResult);
				//alert(7)
				$('#txtCD4TestDate').datebox('setValue',DateArr[5]);
				//$('#txtCD4TestUnit').val(objReport.CD4TestUnit);
				$('#txtSurveyOrgan').val(objReport.SurveyOrgan);
				$('#txtSurveyName').val(objReport.SurveyName);
				
				$('#txtSurveyDate').datebox('setValue',DateArr[6]);
				//alert(8)
				$('#txtComments').val(objReport.Comments);
				
				$('#txtViralloadTestResult').val(objReport.ViralloadTestResult);
				//$('#txtViralloadTestDate').val(objReport.ViralloadTestDate);
			   // alert(DateArr[7])
				$('#txtViralloadTestDate').datebox('setValue',DateArr[7]);
				$('#txtposmonCaseNo').val(objReport.posmonCaseNo);
				$('#txtposmonTestUnit').val(objReport.posmonTestUnit);
				$('#txtHIVrelevance').val(objReport.HIVrelevance);
				//alert(7)
				
				
		}
	};
	//得到报告数据
	obj.GetRepData = function (step) {
		debugger;
		//alert($('#cboHIVSurvey9').combobox('getValues'))
		var inputStr=obj.ReportID;
		//报告标题
		inputStr=inputStr+"^"+$('#txtFollowNo').val();
		inputStr=inputStr+"^"+$('#cboFollowStatus').combobox('getValue');
		inputStr=inputStr+"^"+$('#txtFollowTimes').val();
		inputStr=inputStr+"^"+""                                       //$('#cboIsCustody').combobox('getValue');
		inputStr=inputStr+"^"+$('#cboReasons').combobox('getValue');
		//基本信息
		inputStr=inputStr+"^"+""	//Common_GetValue('txtPatName');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtPatSex');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtParentName');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtPatNo');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtPhoneNo');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtAddress');
		//HIV检测信息
		inputStr=inputStr+"^"+""      //Common_RadioValue('cbgIsHIVTest');
		inputStr=inputStr+"^"+(Common_GetValue('chkNeverHIVTest') ? 1 : 0); //Common_GetValue('chkNeverHIVTest');
		inputStr=inputStr+"^"+""      //$('#txtLastHIVTestDate').datebox('getValue'); 
		inputStr=inputStr+"^"+""       //$('#txtFirstHIVTestDate').datebox('getValue'); 
		inputStr=inputStr+"^"+""      //$('#txtHIVTestTimes').val();
		//死亡个案
		inputStr=inputStr+"^"+""    //$('#cboIsDead').combobox('getValue');
		inputStr=inputStr+"^"+""    //$('#txtDeathDate').datebox('getValue'); 
		inputStr=inputStr+"^"+""    //$('#cboDeathStage').combobox('getValue');
		inputStr=inputStr+"^"+""    //$('#cboDeathPlace').combobox('getValue');
		inputStr=inputStr+"^"+""    //$('#txtDeathOtherPlace').val();
		inputStr=inputStr+"^"+""    //Common_CheckboxValue('cbgDeathReasonSource');
		inputStr=inputStr+"^"+""    //$('#txtDeathOtherSource').val();
		inputStr=inputStr+"^"+""    //$('#cboDeathReason').combobox('getValue');
		inputStr=inputStr+"^"+""    //Common_CheckboxValue('cbgDeathReasonHIV');
		inputStr=inputStr+"^"+""    //Common_CheckboxValue('cbgDeathReasonOthers');
		//临床表现
		inputStr=inputStr+"^"+Common_CheckboxValue('cboHIVManifestation');
		//HIV调查
		inputStr=inputStr+"^"+$('#cboCourseStage').combobox('getValue');
		inputStr=inputStr+"^"+$('#txtHIVDate').datebox('getValue'); 
		inputStr=inputStr+"^"+$('#cboSpouseSituation').combobox('getValue');
		inputStr=inputStr+"^"+$('#cboSpouseHIV').combobox('getValue');
		inputStr=inputStr+"^"+$('#txtSpouseHIVDate').datebox('getValue'); 
		inputStr=inputStr+"^"+$('#txtSpouseCaseNo').val();
		inputStr=inputStr+"^"+""      //$('#txtChildren').val();
		inputStr=inputStr+"^"+""      //$('#txtChildren1').val();
		inputStr=inputStr+"^"+""      //$('#txtChildren2').val();
		inputStr=inputStr+"^"+""      //$('#txtChildren3').val();
		inputStr=inputStr+"^"+""      //$('#txtChildren4').val();
		inputStr=inputStr+"^"+""      //$('#cboHIVSurvey1').combobox('getValue');
		inputStr=inputStr+"^"+$('#cboHIVSurvey2').combobox('getValue');
		inputStr=inputStr+"^"+""      //$('#txtHIVSurvey2No').val();
		inputStr=inputStr+"^"+""      //$('#cboHIVSurvey3').combobox('getValue');
		inputStr=inputStr+"^"+""      //$('#cboHIVSurvey4').combobox('getValue');
		inputStr=inputStr+"^"+""      //$('#txtHIVSurvey4No').val();
		inputStr=inputStr+"^"+""      //$('#cboHIVSurvey5').combobox('getValue');
		inputStr=inputStr+"^"+""       //$('#txtHIVSurvey5No').val();
		inputStr=inputStr+"^"+""       //$('#txtHIVSurvey5No1').val();
		inputStr=inputStr+"^"+""       //$('#cboHIVSurvey6').combobox('getValue');
		inputStr=inputStr+"^"+""       //$('#txtHIVSurvey6No').val();
		inputStr=inputStr+"^"+""       //$('#cboHIVSurvey7').combobox('getValue');
		inputStr=inputStr+"^"+""       //$('#cbgIsHIVSurvey7').combobox('getValue');;
		inputStr=inputStr+"^"+""       //$('#cboHIVSurvey8').combobox('getValue');
		inputStr=inputStr+"^"+""       //$('#cboHIVSurvey8a').combobox('getValue');
		inputStr=inputStr+"^"+""       //$('#txtHIVSurvey8aNo1').val();
		inputStr=inputStr+"^"+""       //$('#txtHIVSurvey8aNo2').val();
		inputStr=inputStr+"^"+""       //$('#cboHIVSurvey8b').combobox('getValue');
		inputStr=inputStr+"^"+""       //$('#cboHIVSurvey8c').combobox('getValue');
		inputStr=inputStr+"^"+$('#cboHIVSurvey9').combobox('getValues');
		inputStr=inputStr+"^"+$('#cboIsHIVSurvey10').combobox('getValue');
		inputStr=inputStr+"^"+$('#cboHIVSurvey10').combobox('getValue');
		inputStr=inputStr+"^"+""       //$('#cboIsHIVSurvey11').combobox('getValue');
		inputStr=inputStr+"^"+""       //$('#txtIsHIVSurvey11No').val();
		//CD4检测
		inputStr=inputStr+"^"+""       //$('#txtCD4TestTimes').val();
		inputStr=inputStr+"^"+$('#txtCD4TestResult').val();
		inputStr=inputStr+"^"+$('#txtCD4TestDate').datebox('getValue'); 
		inputStr=inputStr+"^"+""       //$('#txtCD4TestUnit').val();
		//随访信息
		inputStr=inputStr+"^"+$('#txtSurveyOrgan').val();
		inputStr=inputStr+"^"+$('#txtSurveyName').val();
		inputStr=inputStr+"^"+$('#txtSurveyDate').datebox('getValue'); 
		inputStr=inputStr+"^"+$('#txtComments').val();
		inputStr=inputStr+"^"+PatientID;
		inputStr=inputStr+"^"+EpisodeID;
		inputStr=inputStr+"^"+""       //$('#txtPatNo').val();    //身份证号
		inputStr=inputStr+"^"+obj.arrEPDInfo[0];
		inputStr=inputStr+"^"+$('#cboPatBelong').combobox('getValue');
		inputStr=inputStr+"^"+$('#txtHIVrelevance').val();
		inputStr=inputStr+"^"+$('#txtViralloadTestResult').val();
		inputStr=inputStr+"^"+$('#txtViralloadTestDate').datebox('getValue');
		inputStr=inputStr+"^"+$('#txtposmonCaseNo').val();
		inputStr=inputStr+"^"+$('#txtposmonTestUnit').val();
		inputStr=inputStr+"^"+$('#cboHIVTreatment').combobox('getValue');
		
		
		return inputStr;
	}
	

	// 按钮触发事件
	obj.RelationToEvents = function() {
		// ****************************** ↓↓↓ 单选、多选事件
		/*$HUI.checkbox("[name='cbgDeathReasonSource']",{  //死因信息收集来源
			onChecked:function(e,value){
				var value = $(e.target).attr("label");   //当前选中的值
				if (value=='其他信息来源') {	
					$('#txtDeathOtherSource').removeAttr("disabled");
				}
			},onUnchecked :function(e,value){
				var value = $(e.target).attr("label");
				if (value=='其他信息来源') {	
					$('#txtDeathOtherSource').attr('disabled','disabled');
					$('#txtDeathOtherSource').val('');
				}
			}
		});
		$HUI.radio("[name='cbgIsHIVTest']",{  //本次被诊断为HIV阳性以前是否还做过HIV监测
			onChecked:function(e,value){
				var value = $(e.target).attr("label");   //当前选中的值
				if (value=='是') {	
					$('#chkNeverHIVTest').checkbox('enable');
					$('#txtLastHIVTestDate').datebox("enable");
					$('#txtFirstHIVTestDate').datebox("enable");
					$('#txtHIVTestTimes').removeAttr("disabled");			
				}else{
					$('#chkNeverHIVTest').checkbox('disable');
					$('#txtLastHIVTestDate').datebox("disable");
					$('#txtFirstHIVTestDate').datebox("disable");
					$('#txtHIVTestTimes').attr('disabled','disabled');	
				}
			}
		});*/
		// ****************************** ↑↑↑ 单选、多选事件
		$("#cboFollowStatus").combobox({		
			onSelect:function(){		
				obj.cboFollowStatus_select(); 
			}	
		});
		/*$("#cboIsDead").combobox({		
			onSelect:function(){		
				obj.cboIsDead_select(); 
			}	
		})
		$("#cboDeathPlace").combobox({		
			onSelect:function(){		
				obj.cboDeathPlace_select(); 
			}	
		})
		$("#cboDeathReason").combobox({		
			onSelect:function(){		
				obj.cboDeathReason_select(); 
			}	
		})*/
		$('#btnSave').on("click", function(){
			obj.btnSave_click(); 
		});
		$('#btnDelete').on("click", function(){
			obj.btnDelete_click(); 
		});
		/*$('#btnCheck').on("click", function(){
			obj.btnCheck_click(); 
		});*/
		$('#btnExport').on("click", function(){
			obj.btnExport_click(); 
		});
		$('#btnPrint').on("click", function(){
			obj.btnPrint_click(); 
		});
		$('#btnCancle').on("click", function(){
			obj.btnCancle_click(); 
		});
	}	
	//保存
	obj.btnSave_click = function(){

		if (obj.CheckReport() != true) return;
		var InputStr=obj.GetRepData();
		var ret = $m({                  
			ClassName:"DHCMed.EPD.CaseFollow",
			MethodName:"Update",
			aInput:InputStr,
			aSeparate:"^"
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("数据保存错误!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("数据保存成功!"), 'info');
			obj.ReportID=ret;
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	};
	//删除
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("还未上报!"), 'error');
			return;
		}
		$.messager.confirm($g("提示"),$g("删除操作会直接删除本报告，删除后将不可再查询到，请确认是否删除?"),function(r){
			if(r){
				var DeleteStr=obj.ReportID;
				var ret = $m({                  
					ClassName:"DHCMed.EPD.CaseFollow",
					MethodName:"DeleteById",
					aId:DeleteStr
				},false);
				if(parseInt(ret)<=0){
					$.messager.alert($g("错误"),$g("删除失败!")+ret, 'error');
					return;
				}else{
					$.messager.alert($g("提示"),$g("报告删除成功!"), 'info');  //报告删除为物理删除
					websys_showModal('close');
					return;
				}
			}
		});
	};
	//导出
	obj.btnExport_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'error');
			return;
		}
		var ReportID=obj.ReportID
		var strFileName=ReportID
		//ExportDataToExcel(ReportID,strFileName)
		var fileName="DHCMA_EPD_PrintHIVFollow.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
		DHCCPM_RQPrint(fileName);
		/*var ExportStr=obj.ReportID;
		var ret = $m({                  
			ClassName:"DHCMed.EPD.CaseFollow",
			MethodName:"ExportReport",
			aInput:ExportStr,
			separete:"^"
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert("错误","报告导出失败!"+ret, 'error');
			return;
		}else{
			var cArguments=obj.ReportID;
			$.messager.alert("提示","导出待写", 'info');
		}*/
	};
	//打印
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'error');
			return;
		}
		var ReportID=obj.ReportID
		//var strFileName=ReportID+"打印"
		//PrintDataToExcel(ReportID,strFileName);
		var fileName="{DHCMA_EPD_PrintHIVFollow.raq(aReportID="+obj.ReportID+")}";
		DHCCPM_RQDirectPrint(fileName);
	};
	
	obj.btnCancle_click = function(){
		websys_showModal('close');
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //关闭
		
	};
	
	//检查规范
	obj.CheckReport = function(){
		var errStr = "";
		/*var patCardId = $("#txtPatNo").val()
		if ($.trim(patCardId) != ""){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test(patCardId))) {
				errStr += "输入的身份证号格式不符合规定！)"+")"+"<br>";		//身份证号
			}
		}*/
		if ($.trim($('#cboFollowStatus').combobox('getValue')) == "") {
			var ss = $.trim($('#cboFollowStatus').combobox('getValue'));
			debugger;
			errStr += $g("随访状态不允许为空!")+"<br>";		//随访状态
		}
		/*if ($('#cboIsDead').combobox('getValue') == "") {
			errStr += "是否死亡不允许为空!)"+"<br>";		//是否死亡
		}*/
		if ($('#cboCourseStage').combobox('getValue') == "") {
			errStr += $g("病程阶段不允许为空!")+"<br>";		//病程阶段
		}
		if ($('#txtHIVDate').datebox('getValue') == "") {
			errStr += $g("艾滋病确诊日期不允许为空!")+"<br>";		//艾滋病确诊日期		
		} 
		if ($('#txtSurveyDate').datebox('getValue') == "") {
			errStr += $g("随访日期不允许为空!")+"<br>";		//随访日期		
		} 
		if ($('#txtHIVDate').datebox('getValue') > $('#txtSurveyDate').datebox('getValue')) {
			errStr += $g("艾滋病确诊日期不能大于随访日期!")+"<br>";		
		}
		if ($('#txtSurveyName').val() == "") {
			errStr += $g("随访人不允许为空!")+"<br>";		//随访人
		}
		if ($('#txtSurveyOrgan').val() == "") {
			errStr += $g("随访单位不允许为空!")+"<br>";		//随访单位
		}
		/*if (Common_RadioValue('cbgIsHIVTest') == "") {
			errStr += "本次被诊断为HIV阳性以前是否还做过HIV监测不允许为空!)"+"<br>";		    //本次被诊断为HIV阳性以前是否还做过HIV监测		
		}
		if (Common_CheckboxValue('cboHIVManifestation') == "") {
			errStr += "过去6个月有无以下艾滋病相关临床表现不允许为空!)"+"<br>";		//过去6个月有无以下艾滋病相关临床表现
		}*/
		var NowDate = Common_GetDate(new Date());
		var txtHIVDate = $('#txtHIVDate').datebox('getValue');
		var txtSurveyDate = $('#txtSurveyDate').datebox('getValue');
		var txtCD4TestDate = $('#txtCD4TestDate').datebox('getValue');
		var txtSpouseHIVDate = $('#txtSpouseHIVDate').datebox('getValue');
		//var txtLastHIVTestDate = $('#txtLastHIVTestDate').datebox('getValue');
		//var txtDeathDate = $('#txtDeathDate').datebox('getValue');
		//var txtFirstHIVTestDate = $('#txtFirstHIVTestDate').datebox('getValue');
		if (Common_CompareDate(txtHIVDate,NowDate)>0) {
			errStr += $g("艾滋病确诊日期不允许大于当前日期!")+"<br>";			
		}
		if (Common_CompareDate(txtSurveyDate,NowDate)>0) {
			errStr += $g("随访日期不允许大于当前日期!")+"<br>";			
		}
		if (Common_CompareDate(txtCD4TestDate,NowDate)>0) {
			errStr += $g("检测日期不允许大于当前日期!")+"<br>";
		}
		if (Common_CompareDate(txtSpouseHIVDate,NowDate)>0) {
			errStr += $g("检测日期不允许大于当前日期!<br>");
		}
		/*if (Common_CompareDate(txtLastHIVTestDate,NowDate)>0) {
			errStr += '最后一次HIV检测为阴性的日期不允许大于当前日期!<br>';			
		}
		if (Common_CompareDate(txtDeathDate,NowDate)>0) {
			errStr += '死亡日期不允许大于当前日期!<br>';			
		}
		if (Common_CompareDate(txtFirstHIVTestDate,NowDate)>0) {
			errStr += '第一次HIV检测为阳性的日期不允许大于当前日期!<br>';			
		}*/
		if(errStr != "")
		{
			$.messager.alert($g("提示"), errStr, 'info');
			return false;
		}
		return true;
	}

}


