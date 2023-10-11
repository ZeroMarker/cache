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
				$('#btnSave').show();
				$('#btnCancle').show();
				$('#btnDelete').show();
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
	
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			$('#txtDoctor').val(DocName);
			$('#cboCRReportLoc').combobox('setValue',LocID);                    //报卡科室
			$('#cboCRReportLoc').combobox('setText',LocDesc);                  
			$('#txtRepDW').val(ServerObj.XNXGReportOrgan);	// 报告单位
			$('#dtRepDate').datebox('setValue',Common_GetDate(new Date()));
			if(PatientID!=""){
				var objPat = $cm({                  
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				$('#txtRegNo').val(objPat.PapmiNo);
				$('#txtPatName').val(objPat.PatientName);
				$('#txtSex').val(objPat.Sex);
				$('#txtMZH').val(objPat.OpPatMrNo);
				$('#txtZYH').val(objPat.InPatMrNo);	 // 住院号
				var PersonalIDType=objPat.PersonalIDType;				//证件类型
				var CardTypeID = $m({                  
					ClassName:"DHCMed.CD.CRReportXNXG",
					MethodName:"GetObjByTypeDesc",
					argTypeCode:"CRCardType",
					argDesc:PersonalIDType
				},false);
				// 对照成功,有值时才赋值
				if(CardTypeID!=""){
					$('#cboCardType').combobox('setValue',CardTypeID);                    
					$('#cboCardType').combobox('setText',PersonalIDType); 
				}
				$('#txtPatCardNo').val(objPat.PAPMIDVAnumber);          // 证件号
				
				$('#txtLXDH').val(objPat.Telephone);
			    $('#txtBirthDay').datebox('setValue',objPat.Birthday); 
			
				var AgeY=objPat.Age;
				var AgeM=objPat.AgeMonth;
				var AgeD=objPat.AgeDay;
				if (AgeY>0){
					$('#txtAge').val(objPat.Age);
					$('#cboPatAgeDW').combobox('setValue','岁');
				}else if(AgeM>0){
					$('#txtAge').val(objPat.AgeMonth);
					$('#cboPatAgeDW').combobox('setValue','月');
				}else {
					$('#txtAge').val(objPat.AgeDay);
					$('#cboPatAgeDW').combobox('setValue','天');
				}
				if (DiagnosDr) {
					var DiagnosInfo = $m({                  
						ClassName:"DHCMed.Base.MRDiagnose",
						MethodName:"GetStringById",
						DiaId:DiagnosDr
					},false);
					if(DiagnosInfo) {
						var ICD = DiagnosInfo.split("^")[12];
						var ICDDesc =DiagnosInfo.split("^")[13];
						$('#cboCRZD').lookup('setText',ICDDesc);
						$('#txtICD').val(ICD); 	
					}	
				}
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

				if (ServerObj.RegAddress) {// 户籍地址
					$('#cboRegProvince').combobox('setValue',ServerObj.RegAddress.split("^")[0]);                    
					$('#cboRegProvince').combobox('setText',ServerObj.RegAddress.split("^")[1]);                  
					$('#cboRegCity').combobox('setValue',ServerObj.RegAddress.split("^")[2]);                    
					$('#cboRegCity').combobox('setText',ServerObj.RegAddress.split("^")[3]);                  
					$('#cboRegCounty').combobox('setValue',ServerObj.RegAddress.split("^")[4]);                    
					$('#cboRegCounty').combobox('setText',ServerObj.RegAddress.split("^")[5]);                  
					$('#cboRegVillage').combobox('setValue',ServerObj.RegAddress.split("^")[6]);                    
					$('#cboRegVillage').combobox('setText',ServerObj.RegAddress.split("^")[7]);                  
					$('#txtRegRoad').val(ServerObj.RegAddress.split("^")[8]);    
					$('#txtRegAddress').val(ServerObj.PatRegAddress);
					if (session['LOGON.LANGCODE']=="EN"){
						$('#txtRegAddress').val($('#cboRegProvince').combobox('getText')+$('#cboRegCity').combobox('getText')+$('#cboRegCounty').combobox('getText')+$('#cboRegVillage').combobox('getText'));
					}
				}
				if (ServerObj.DicInfo) {// 字典赋值
				    var NationInfo = ServerObj.DicInfo.split("^")[1];
				    var MaritalInfo = ServerObj.DicInfo.split("^")[4];
				   	var EducationInfo = ServerObj.DicInfo.split("^")[5];
				    var OccupationInfo = ServerObj.DicInfo.split("^")[3];
				
					$('#cboNation').combobox('setValue',((NationInfo.split(",")[0]) ? NationInfo.split(",")[0]:''));            //民族		     	    $('#cboNation').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:'')); 
		     		$('#cboNation').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:''));            //民族		     	    $('#cboNation').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:'')); 
		   
				    $('#cboMarital').combobox('setValue',((MaritalInfo.split(",")[0]) ? MaritalInfo.split(",")[0]:''));            //民族
		     	    $('#cboMarital').combobox('setText',((MaritalInfo.split(",")[0]) ? MaritalInfo.split(",")[2]:'')); 
		     		$('#cboEducation').combobox('setValue',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[0]:''));            //民族
		     	    $('#cboEducation').combobox('setText',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[2]:'')); 
		     	
					$('#cboOccupation').combobox('setValue',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[0]:''));        //职业
		     	    $('#cboOccupation').combobox('setText',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[2]:''));  
				    //职业与工种一致直接赋值
				  	obj.CRGZ = "CDGZ"+OccupationInfo.split(",")[1];			 
		    		obj.cboCRGZ = Common_ComboToDic("cboCRGZ",obj.CRGZ,"",LogonHospID);	
                   	var CRGZInfo = $m({                  
						ClassName:"DHCMed.SSService.DictionarySrv",
						MethodName:"GetDicByDesc",
						argType:obj.CRGZ,
						argDesc:OccupationInfo.split(",")[2],
						argIsActive:1
					},false);
				  	$('#cboCRGZ').combobox('setValue',((OccupationInfo.split(",")[0]) ? CRGZInfo.split("^")[0]:''));     //工种
					$('#cboCRGZ').combobox('setText',((OccupationInfo.split(",")[0]) ? CRGZInfo.split("^")[2]:''));    //工种	   					
				}	
				
				
				var XNXGDiagnosisUnitID = $m({                  
					ClassName:"DHCMed.SSService.DictionarySrv",
					MethodName:"GetIDByTypeDesc",
					argHosID:"",
					argTypeCode:"CRZGZDDW",
					argDesc:ServerObj.XNXGDiagnosisUnit
				},false);
				$('#cboQZDW').combobox('setValue',XNXGDiagnosisUnitID);	
				$('#cboQZDW').combobox('setText',ServerObj.XNXGDiagnosisUnit);	
				var XNXGLevelID = $m({                  
					ClassName:"DHCMed.SSService.DictionarySrv",
					MethodName:"GetIDByTypeDesc",
					argHosID:"",
					argTypeCode:"XNXGLevel",
					argDesc:ServerObj.XNXGUnitLevel
				},false);
				$('#cboLevel').combobox('setValue',XNXGLevelID);    // 单位级别
				$('#cboLevel').combobox('setText',ServerObj.XNXGUnitLevel);    
								
			}
		}else{
			var objRep = $m({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false);
		    var objXNXG = $m({                  
				ClassName:"DHCMed.CD.CRReportXNXG",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var objPat = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			var arrXNXG=objXNXG.split("^");
			var arrPat=objPat.split("^");
			$('#txtMZH').val(arrPat[1]);
			$('#txtZYH').val(arrPat[2]);	 // 住院号
			$('#txtKPBH').val(arrXNXG[0]);
			$('#txtRegNo').val(arrPat[3]);
			$('#cboBGKLX').combobox('setValue',arrXNXG[18].split(CHR_1)[0]);
			$('#cboBGKLX').combobox('setText',arrXNXG[18].split(CHR_1)[1]);
			$('#txtPatName').val(arrPat[4]);
			$('#txtSex').val(arrPat[6]);
			$('#txtBirthDay').datebox('setValue',arrPat[7]);
			$('#txtPatCardNo').val(arrPat[11]);
			$('#cboNation').combobox('setValue',arrPat[13].split(CHR_1)[0]);
			$('#cboNation').combobox('setText',arrPat[13].split(CHR_1)[1]);
		
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
			//职业与具体工种联动赋值处理
			$HUI.combobox('#cboOccupation',{
				onLoadSuccess:function(){   
					var data=$(this).combobox('getData');
					for(i=0;i<data.length;i++){
						if (data[i]['DicRowId']==arrPat[16].split(CHR_1)[0]) {
							obj.CRGZ = "CDGZ"+data[i]['DicCode'];
						}	
					}
				}
			});
			
			$('#cboMarital').combobox('setValue',arrPat[14].split(CHR_1)[0]);
			$('#cboEducation').combobox('setValue',arrPat[15].split(CHR_1)[0]);
			$('#cboOccupation').combobox('setValue',arrPat[16].split(CHR_1)[0]);
		
			$('#cboMarital').combobox('setText',arrPat[14].split(CHR_1)[1]);
			$('#cboEducation').combobox('setText',arrPat[15].split(CHR_1)[1]);
			$('#cboOccupation').combobox('setText',arrPat[16].split(CHR_1)[1]);
			$('#txtCompany').val(arrPat[21]);
		    $('#cboCRGZ').combobox('setValue',arrPat[17].split(CHR_1)[0]);    //工种
			$('#cboCRGZ').combobox('setText',arrPat[17].split(CHR_1)[1]);    //工种		
				
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
			if (session['LOGON.LANGCODE']=="EN"){
				$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText'));
			}
			$('#cboRegProvince').combobox('setValue',arrPat[23].split(CHR_1)[0]);
			$('#cboRegProvince').combobox('setText',((arrPat[23].indexOf(CHR_1)>-1) ? arrPat[23].split(CHR_1)[1] : ''));
			$('#cboRegCity').combobox('setValue',arrPat[24].split(CHR_1)[0]);
			$('#cboRegCity').combobox('setText',((arrPat[24].indexOf(CHR_1)>-1) ? arrPat[24].split(CHR_1)[1] : ''));
			$('#cboRegCounty').combobox('setValue',arrPat[25].split(CHR_1)[0]);
			$('#cboRegCounty').combobox('setText',((arrPat[25].indexOf(CHR_1)>-1) ? arrPat[25].split(CHR_1)[1] : ''));
			$('#cboRegVillage').combobox('setValue',arrPat[26].split(CHR_1)[0]);
			$('#cboRegVillage').combobox('setText',((arrPat[26].indexOf(CHR_1)>-1) ? arrPat[26].split(CHR_1)[1] : ''));	
			$('#txtRegRoad').val(arrPat[27]);
			$('#txtRegAddress').val(arrPat[28]);
			if (session['LOGON.LANGCODE']=="EN"){
				$('#txtRegAddress').val($('#cboRegProvince').combobox('getText')+$('#cboRegCity').combobox('getText')+$('#cboRegCounty').combobox('getText')+$('#cboRegVillage').combobox('getText'));
			}
			$('#txtLXDH').val(arrPat[20]);
			
			$('#dtRepDate').datebox('setValue',arrRep[7]);
			$('#txtSWRQ').datebox('setValue',arrXNXG[12]);
			$('#cboDeathReason').combobox('setValue',arrXNXG[13].split(CHR_1)[0]);
			$('#cboDeathReason').combobox('setText',arrXNXG[13].split(CHR_1)[1]);			
			$('#txtSWJTYY').val(arrXNXG[16]);
			$('#txtSWICD').val(arrXNXG[15]);
			
			obj.CRZD = arrXNXG[34].split(CHR_1)[0];
			//$('#cboCRZD').lookup('setText',arrXNXG[1].split(CHR_1)[1]);
			$('#cboCRZD').lookup('setValue',arrXNXG[34].split(CHR_1)[0]);
			$('#cboCRZD').lookup('setText',arrXNXG[34].split(CHR_1)[1]);
			$('#txtICD').val(arrXNXG[2]); 
			for (var len=0; len < arrXNXG[19].split(',').length;len++) {       
				var valueCode = arrXNXG[19].split(',')[len];
				$('#radSYZZList'+valueCode).checkbox('setValue',(valueCode!=""?true:false));           //首要症状
			}
			
			$('#cboSHTD').combobox('setValue',arrXNXG[20].split(CHR_1)[0]);
			$('#cboSHTD').combobox('setText',arrXNXG[20].split(CHR_1)[1]);
			$('#cboSJJG').combobox('setValue',arrXNXG[21].split(CHR_1)[0]);
			$('#cboSJJG').combobox('setText',arrXNXG[21].split(CHR_1)[1]);
			obj.CRSWZD = arrXNXG[22].split(CHR_1)[0];
			$('#cboCRSWZD').lookup('setText',arrXNXG[22].split(CHR_1)[1]);
			if(arrXNXG[3].split("-")[1]=="GXB"){
				$('#cboGXB').combobox('setValue',arrXNXG[4].split(CHR_1)[0]);
				$('#cboGXB').combobox('setText',arrXNXG[4].split(CHR_1)[1]);
				//  打开报告 如果诊断分类是冠心病 控制脑卒中首要症状不可选
			    $('input[type=checkbox][name=radSYZZList]').checkbox('disable');
			}
			if(arrXNXG[3].split("-")[1]=="NCZ"){
				$('#cboNZZ').combobox('setValue',arrXNXG[4].split(CHR_1)[0]);
				$('#cboNZZ').combobox('setText',arrXNXG[4].split(CHR_1)[1]);
			}
			
			Common_SetRadioValue("radIsFirstAttck",arrXNXG[9].split(CHR_1)[0])  
			//$('#radIsFirstAttck').checkbox('setValue',(arrXNXG[9]==1 ? true:false)); //是否首次发病
			for (var len=0; len < arrXNXG[6].split(',').length;len++) {       
				var valueCode = arrXNXG[6].split(',')[len];
				$('#radBSList'+valueCode).checkbox('setValue', (valueCode!=""?true:false));             //病史
			}
			$('#txtFBRQ').datebox('setValue',arrXNXG[7]);
			$('#txtQZRQ').datebox('setValue',arrXNXG[8]);
			$('#cboQZDW').combobox('setValue',arrXNXG[10].split(CHR_1)[0]);	
			$('#cboQZDW').combobox('setText',arrXNXG[10].split(CHR_1)[1]);	
			
			var DiagBaseDrs = arrXNXG[5];
			for (var len=0; len < DiagBaseDrs.length;len++) {  // 诊断依据 
				var value = DiagBaseDrs.split(',')[len];
				$('#chkDiagList'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
			
			$('#cboCRReportLoc').combobox('setValue',arrRep[3]);
			$('#cboCRReportLoc').combobox('setText',arrRep[4]);
			$('#txtDoctor').val(arrRep[5]);
			$('#txtRepDW').val(arrRep[6]);
			$('#txtBSZY').val(arrXNXG[17]);
			
			if ((arrPat[16].split(CHR_1)[0])&&(!obj.CRGZ)){
				var DicCls = $m({                  
					ClassName:"DHCMed.SS.Dictionary",
					MethodName:"GetStringById",
					id:arrPat[16].split(CHR_1)[0],
					separete:"^"
				},false);
				if (!DicCls) return;
			   
				obj.CRGZ= "CDGZ"+DicCls.split("^")[1];
				obj.cboCRGZ = Common_ComboToDic("cboCRGZ",obj.CRGZ,"",LogonHospID);  //工种 
				$('#cboCRGZ').combobox('setValue',arrPat[17].split(CHR_1)[0]);    //工种
				$('#cboCRGZ').combobox('setText',arrPat[17].split(CHR_1)[1]);    //工种		  
			}
			$('#cboRepProvince').combobox('setValue',arrXNXG[23].split(CHR_1)[0]);    // 报卡省
			$('#cboRepProvince').combobox('setText',arrXNXG[23].split(CHR_1)[1]);    
			$('#cboRepCity').combobox('setValue',arrXNXG[24].split(CHR_1)[0]);    // 报卡市
			$('#cboRepCity').combobox('setText',arrXNXG[24].split(CHR_1)[1]);    
			$('#cboRepCounty').combobox('setValue',arrXNXG[25].split(CHR_1)[0]);    // 报卡县
			$('#cboRepCounty').combobox('setText',arrXNXG[25].split(CHR_1)[1]);    		
			$('#cboCardType').combobox('setValue',arrXNXG[26].split(CHR_1)[0]);    // 证件类型
			$('#cboCardType').combobox('setText',arrXNXG[26].split(CHR_1)[1]);
			
			Common_SetRadioValue("radIsLiveSixMonth",arrXNXG[27].split(CHR_1)[0])  // 六个月   
			$('#cboLevel').combobox('setValue',arrXNXG[28].split(CHR_1)[0]);    // 单位级别
			$('#cboLevel').combobox('setText',arrXNXG[28].split(CHR_1)[1]);    
			$('#cboOutCome').combobox('setValue',arrXNXG[29].split(CHR_1)[0]);    // 转归
			$('#cboOutCome').combobox('setText',arrXNXG[29].split(CHR_1)[1]); 
			
			Common_SetRadioValue("radCureMethod",arrXNXG[30].split(CHR_1)[0])  
			Common_SetRadioValue("radApoplexyType",arrXNXG[31].split(CHR_1)[0])  
			Common_SetRadioValue("radSCD",arrXNXG[32].split(CHR_1)[0])  
			Common_SetRadioValue("radInfer",arrXNXG[33].split(CHR_1)[0])  
			Common_SetRadioValue("radBiochemicalMark",arrXNXG[35].split(CHR_1)[0])  
			Common_SetRadioValue("radReissue",arrXNXG[36].split(CHR_1)[0])  
			
		}
	};
	
   obj.GetRepData = function (step) {
		
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"XNXG";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3作废
		InputStr=InputStr+"^"+$.trim($('#cboCRReportLoc').combobox('getValue')); //session['LOGON.CTLOCID'];
		InputStr=InputStr+"^"+$.trim($('#txtDoctor').val());
		InputStr=InputStr+"^"+$.trim($('#txtRepDW').val());
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
	
	obj.GetXNXGData = function () {
	
		var DiagInfo=obj.ReportID;
		DiagInfo=DiagInfo+"^"+$.trim($('#txtKPBH').val());  //2
		DiagInfo=DiagInfo+"^"+$.trim($('#cboBGKLX').combobox('getValue'));  //3报告卡类型
		DiagInfo=DiagInfo+"^"+obj.CRZD;  //4  诊断ID 
		DiagInfo=DiagInfo+"^"+$.trim($('#txtICD').val());   //5ICD
		DiagInfo=DiagInfo+"^"+""   // 6 诊断分类
		DiagInfo=DiagInfo+"^"+Common_CheckboxValue("chkDiagList");  //7 诊断依据
		DiagInfo=DiagInfo+"^"+"";  //8病史
		DiagInfo=DiagInfo+"^"+$('#txtFBRQ').datebox('getValue');  //9发病日期
		DiagInfo=DiagInfo+"^"+$('#txtQZRQ').datebox('getValue');  //10确诊日期
		DiagInfo=DiagInfo+"^"+Common_RadioValue("radIsFirstAttck");  //11是否首次发病
		DiagInfo=DiagInfo+"^"+$.trim($('#cboQZDW').combobox('getValue'));  //12确诊单位
		DiagInfo=DiagInfo+"^"+""   //13转归
		
		DiagInfo=DiagInfo+"^"+$('#txtSWRQ').datebox('getValue');  //14死亡日期
		//DiagInfo=DiagInfo+"^"+$.trim($('#cboDeathReason').combobox('getValue'))+","+$.trim($('#cboDeathReason').combobox('getText')); //15死亡原因
		DiagInfo=DiagInfo+"^"+"";  //15死亡原因
		DiagInfo=DiagInfo+"^"+$.trim($('#txtSWICD').val());  //16死亡ICD
		DiagInfo=DiagInfo+"^"+$.trim($('#txtSWJTYY').val())  //17死亡具体原因
		DiagInfo=DiagInfo+"^"+"";  //18首要症状
		DiagInfo=DiagInfo+"^"+"";  //19病史摘要
		DiagInfo=DiagInfo+"^"+"";  //20死后推断
		DiagInfo=DiagInfo+"^"+"";  //21时间间隔
		DiagInfo=DiagInfo+"^"+obj.CRSWZD;                         //22死亡诊断
		
		DiagInfo=DiagInfo+"^"+$.trim($('#cboRepProvince').combobox('getValue'));  // 报卡省
		DiagInfo=DiagInfo+"^"+$.trim($('#cboRepCity').combobox('getValue'));  		// 报卡市
		DiagInfo=DiagInfo+"^"+$.trim($('#cboRepCounty').combobox('getValue'));  // 报卡县
		DiagInfo=DiagInfo+"^"+$.trim($('#cboCardType').combobox('getValue'));  // 证件类型
		DiagInfo=DiagInfo+"^"+Common_RadioValue("radIsLiveSixMonth"); 			 // 是否居住六个月以上
		DiagInfo=DiagInfo+"^"+$.trim($('#cboLevel').combobox('getValue'));  // 单位级别
		DiagInfo=DiagInfo+"^"+$.trim($('#cboOutCome').combobox('getValue'));  // 转归
		
		DiagInfo=DiagInfo+"^"+Common_RadioValue("radCureMethod"); 		 // 治疗措施
		DiagInfo=DiagInfo+"^"+Common_RadioValue("radApoplexyType"); 	 // 脑卒中类型
		DiagInfo=DiagInfo+"^"+Common_RadioValue("radSCD"); 			 // 心源性猝死
		DiagInfo=DiagInfo+"^"+Common_RadioValue("radInfer"); 			 // 推断
		DiagInfo=DiagInfo+"^"+Common_RadioValue("radBiochemicalMark");  // 生化标志物
		DiagInfo=DiagInfo+"^"+Common_RadioValue("radReissue") ; 		 // 补发
		return DiagInfo;
	}
	
	obj.GetPatData = function () {
		var Age	  = $.trim($('#txtAge').val());                       //年龄
		var AgeDW = $.trim($('#cboPatAgeDW').combobox('getValue'));	  //年龄单位
		var NLS,NLY,NLT="";
		if(AgeDW=="岁"){
			NLS=Age;
			NLY="";
			NLT="";
		}else if(AgeDW=="月"){
			NLY=Age;
			NLT="";
			NLS="";
		}else{
			NLT=Age;
			NLY="";
			NLS="";
		}
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr = InputStr+"^"+$.trim($('#txtMZH').val());	                //CRMZH
		InputStr = InputStr+"^"+$.trim($('#txtZYH').val());	                //CRZYH   update by chenrui 20211206
		InputStr = InputStr+"^"+$.trim($('#txtRegNo').val());						//CRDJH
		InputStr = InputStr+"^"+$.trim($('#txtPatName').val());						//CRXM
		InputStr = InputStr+"^"+"";	                                        //CRJZXM
		InputStr = InputStr+"^"+$.trim($('#txtSex').val());;	                    //CRXB
		InputStr = InputStr+"^"+$('#txtBirthDay').datebox('getValue');	    //CRCSRQ
		InputStr = InputStr+"^"+NLS;	                                    //CRNLS
		InputStr = InputStr+"^"+NLY;	                                    //CRNLY
		InputStr = InputStr+"^"+NLT;	                                    //CRNLT
		InputStr = InputStr+"^"+$.trim($('#txtPatCardNo').val());;	                //CRSFZH
		InputStr = InputStr+"^"+"";	                                        //CRJTDH
		InputStr = InputStr+"^"+$.trim($('#cboNation').combobox('getValue'));	    //CRMZ
		InputStr = InputStr+"^"+$.trim($('#cboMarital').combobox('getValue'));	    //CRHYZK
		InputStr = InputStr+"^"+$.trim($('#cboEducation').combobox('getValue'));	//CRWHCD
		InputStr = InputStr+"^"+$.trim($('#cboOccupation').combobox('getValue'));	//CRZY
		InputStr = InputStr+"^"+$.trim($('#cboCRGZ').combobox('getValue'));;	    //CRGZ
		InputStr = InputStr+"^"+"";	                                        //CRLXR
		InputStr = InputStr+"^"+"";	                                        //CRYBRGX
		InputStr = InputStr+"^"+$.trim($('#txtLXDH').val());	                    //CRLXDH
		InputStr = InputStr+"^"+$.trim($('#txtCompany').val());	                    //CRGZDW
		InputStr = InputStr+"^"+"";	                                        //CRHJ
		InputStr = InputStr+"^"+$.trim($('#cboRegProvince').combobox('getValue'));	//CRHJDZS
		InputStr = InputStr+"^"+$.trim($('#cboRegCity').combobox('getValue'));      //CRHJDZS2
		InputStr = InputStr+"^"+$.trim($('#cboRegCounty').combobox('getValue'));    //CRHJDZX
		InputStr = InputStr+"^"+$.trim($('#cboRegVillage').combobox('getValue'));	//CRHJDZX2
		InputStr = InputStr+"^"+$.trim($('#txtRegRoad').val());                     //CRHJDZC
		InputStr = InputStr+"^"+$.trim($('#txtRegAddress').val());	                //CRHJDZXX
		InputStr = InputStr+"^"+$.trim($('#cboCurrProvince').combobox('getValue'));	//CRCZDZS
		InputStr = InputStr+"^"+$.trim($('#cboCurrCity').combobox('getValue'));     //CRCZDZS2
		InputStr = InputStr+"^"+$.trim($('#cboCurrCounty').combobox('getValue'));   //CRCZDZX
		InputStr = InputStr+"^"+$.trim($('#cboCurrVillage').combobox('getValue'));	//CRCZDZX2
		InputStr = InputStr+"^"+$.trim($('#txtCurrRoad').val());                    //CRCZDZC
		InputStr = InputStr+"^"+$.trim($('#txtCurrAddress').val());	                //CRCZDZXX  
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
			$.messager.prompt($g("退回"), $g("请输入退回原因")+"!", function (r) {
				if (r){
					obj.btnReturn_click(r); 
				}else if(r==""){
					$.messager.alert($g("提示"),$g("退回原因不能为空")+"!", 'info');
				}			
			});
		});
	}	
	// 草稿
	obj.btnSaveTemp_click = function(){
		var RepData=obj.GetRepData(4);
		var XNXGData=obj.GetXNXGData();
		var PatData=obj.GetPatData();
		var ExtraData="";
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:XNXGData,
			PatInfo:PatData,
			ExtraInfo:ExtraData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("草稿数据保存错误")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("草稿数据保存成功")+"！<br>"+$g("请及时完善心脑血管卡信息")+"!", 'info');
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
		var XNXGData=obj.GetXNXGData();
		var PatData=obj.GetPatData();
		var ExtraData="";
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:XNXGData,
			PatInfo:PatData,
			ExtraInfo:ExtraData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("数据保存错误")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("数据保存成功")+"!", 'info');
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
			$.messager.alert($g("错误"),$g("退回失败")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("退回成功")+"!", 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	}
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("还未上报")+"!", 'error');
			return;
		}
		$.messager.confirm($g("提示"),$g("请确认是否作废")+"?",function(r){
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
					$.messager.alert($g("错误"),$g("作废失败")+"!"+ret, 'error');
					return;
				}else{
					$.messager.alert($g("提示"),$g("报告作废成功")+"!", 'info');
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
			$.messager.alert($g("错误"),$g("报告审核失败")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("报告审核成功")+"!", 'info');
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
			$.messager.alert($g("错误"),$g("取消审核失败")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("取消审核成功")+"!", 'info');
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
			$.messager.alert($g("错误"),$g("报告导出失败")+"!"+ret, 'error');
			return;
		}else{
			//var cArguments=obj.ReportID;
			//var flg=ExportDataToExcel("","","心脑血管事件报告卡(("+$.trim($('#txtPatName').val())+")",cArguments);
			var fileName="DHCMA_CD_PrintReportXNXG.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
			DHCCPM_RQPrint(fileName);
		}
	};
	obj.btnPrint_click = function(){
		if (obj.ReportID==""){
			$.messager.alert($g("提示"),$g("打印失败")+"！"+$g("找不到这份报告") , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintCDXNXGReport");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.cd.lodopxnxg.csp?ReportID="+obj.ReportID);
		LODOP.PRINT();			//直接打印
		
		/*if(obj.ReportID==""){
			$.messager.alert("错误","请先做【上报】操作", 'error');
			return;
		}
		var PrintStr=obj.ReportID;
		PrintStr=PrintStr+"^"+session['LOGON.USERID'];
		PrintStr=PrintStr+"^"+session['LOGON.CTLOCID'];
		PrintStr=PrintStr+"^"+"PRINT";
		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"ExportReport",
			aInput:PrintStr,
			separete:"^"
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert("错误","报告打印失败!"+ret, 'error');
			return;
		}else{
			//var cArguments=obj.ReportID;
			//var flg=PrintDataToExcel("","","心脑血管事件报告卡("+$.trim($('#txtPatName').val())+")",cArguments);
			var fileName="{DHCMA_CD_PrintReportXNXG.raq(aReportID="+obj.ReportID+")}";
			DHCCPM_RQDirectPrint(fileName);
		}*/
	};
	obj.btnCancle_click = function(){
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //关闭
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
	};
	
	//检查规范
	obj.CheckReport = function(){
		var errStr = "";

		if ($.trim($('#cboBGKLX').combobox('getValue')) == "") {
			errStr += $g("请选择报卡类型!")+"<br>";		//报卡类型
		}
		if ($.trim($('#cboRepProvince').combobox('getValue')) == "") {
			errStr += $g("请选择报卡单位省!")+"<br>";		//报卡省
		}
		if ($.trim($('#cboRepCity').combobox('getValue')) == "") {
			errStr += $g("请选择报卡单位市!")+"<br>";		//报卡市
		}
		if ($.trim($('#cboRepCounty').combobox('getValue')) == "") {
			errStr += $g("请选择报卡单位县!")+"<br>";		//报卡县
		}
		if ($.trim($('#txtPatName').val()) == "") {
			errStr += $g("病人姓名不允许为空!")+"<br>";		//病人姓名
		}
		if ($.trim($('#txtSex').val()) == "") {
			errStr += $g("性别不允许为空!")+"<br>";		//性别
		}
		if ($.trim($('#txtAge').val()) == "") {
			errStr += $g("年龄不允许为空!")+"<br>";		//年龄
		}
		if ($.trim($('#cboNation').combobox('getValue')) == "") {
			errStr += $g("请选择民族!")+"<br>";		//民族
		}
		if ($.trim($('#cboEducation').combobox('getValue')) == "") {
			errStr += $g("请选择文化!")+"<br>";		//文化
		}
		if ($.trim($('#cboMarital').combobox('getValue')) == "") {
			errStr += $g("请选择婚姻情况!")+"<br>";		//婚姻情况
		}
		if ($.trim($('#cboOccupation').combobox('getValue')) == "") {
			errStr += $g("请选择职业!")+"<br>";		//职业
		}
		if ($.trim($('#cboCRGZ').combobox('getValue')) == "") {
			errStr += $g("请选择具体工种!")+"<br>";		//具体工种
		}
		if ($.trim($('#cboCardType').combobox('getValue')) == ""){
			errStr += $g("证件类型不允许为空!")+"<br>";		//证件类型
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			errStr += $g("身份证号不允许为空!")+"<br>";		//身份证号
		}
		// 身份证格式验证	
		if (($.trim($('#cboCardType').combobox('getText')).indexOf("身份证")>-1)&&($.trim($('#txtPatCardNo').val()) != "")){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test($.trim($('#txtPatCardNo').val())))) {
				errStr += $g('输入的身份证号格式不符合规定')+'！'+$g('请重新输入!')+'<br>';
			}
		}
		if ($.trim($('#txtLXDH').val()) == "") {
			errStr += $g("联系电话不允许为空!")+"<br>";		//联系电话
		}else if (!Common_CheckPhone($.trim($('#txtLXDH').val()))){
			errStr += $g("联系电话格式有误!")+"<br>";		//联系电话
		}
		if ($.trim($('#cboCurrProvince').combobox('getValue')) == "") { //省
			errStr += $g("请选择居住地址省!")+"<br>";		
		}
		if ($.trim($('#cboCurrCity').combobox('getValue')) == "") {
			errStr += $g("请选择居住地址市!")+"<br>";		//市
		}
		if ($.trim($('#cboCurrCounty').combobox('getValue')) == "") {
			errStr += $g("请选择居住地址县!")+"<br>";		//县
		}
		if ($.trim($('#cboCurrVillage').combobox('getValue')) == "") {
			errStr += $g("请选择居住地址乡/镇!")+"<br>";		//乡/镇
		}
		if ($.trim($('#txtCurrRoad').val()) == "") {
			errStr += $g("居住地址村不允许为空!")+"<br>";		//村
		}
		if ($.trim($('#txtCurrAddress').val()) == "") {
			errStr += $g("居住地址详细地址不允许为空!")+"<br>";		//详细地址		
		} 
		if ($.trim($('#cboRegProvince').combobox('getValue')) == "") { //省
			errStr += $g("请选择户口地址省!")+"<br>";		
		}
		if ($.trim($('#cboRegCity').combobox('getValue')) == "") {
			errStr += $g("请选择户口地址市!")+"<br>";		//市
		}
		if ($.trim($('#cboRegCounty').combobox('getValue')) == "") {
			errStr += $g("请选择户口地址县!")+"<br>";		//县
		}
		if ($.trim($('#cboRegVillage').combobox('getValue')) == "") {
			errStr += $g("请选择户口地址乡/镇!")+"<br>";		//乡/镇
		}
		if ($.trim($('#txtRegRoad').val()) == "") {
			errStr += $g("户口地址村不允许为空!")+"<br>";		//村
		}
		if ($.trim($('#txtRegAddress').val()) == "") {
			errStr += $g("户口地址详细地址不允许为空!")+"<br>";		//详细地址		
		}  
		
		if ((obj.CRZD=="")||($.trim($('#cboCRZD').lookup('getText'))) == "") {
			errStr += $g("诊断不允许为空,请选择诊断!")+"<br>";		  //诊断
		}
		if ($.trim($('#cboCRZD').lookup('getText')).indexOf('心绞痛') > -1) {
			if (Common_RadioValue("radCureMethod") == '') {
				errStr += $g("诊断为")+$.trim($('#cboCRZD').lookup('getText'))+$g("，请选择心绞痛治疗措施!")+"<br>";		//心绞痛治疗措施
			}
		}
		if ($.trim($('#cboCRZD').lookup('getText')).indexOf('脑卒中') > -1) {
			if (Common_RadioValue("radApoplexyType") == '') {
				errStr += $g("诊断为")+$.trim($('#cboCRZD').lookup('getText'))+$g("，请选择脑卒中类型!")+"<br>";		//脑卒中类型
			}
		}
		if ($.trim($('#cboCRZD').lookup('getText')).indexOf('心源性猝死') > -1) {
			if (Common_RadioValue("radSCD") == '') {
				errStr += $g("诊断为")+$.trim($('#cboCRZD').lookup('getText'))+$g("，请选择心源性猝死类型!")+"<br>";		//心源性猝死类型
			}
		}
		
		if ($('#txtFBRQ').datebox('getValue') == "") {
			errStr += $g("发病日期不允许为空!")+"<br>";		//发病日期
		}
		if ($('#txtQZRQ').datebox('getValue') == "") {
			errStr += $g("确诊日期不允许为空!")+"<br>";		//确诊日期
		}
		if ($.trim($('#cboQZDW').combobox('getValue')) == "") {
			errStr += $g("请选择确诊单位!")+"<br>";		//确诊单位
		}
		if ($.trim($('#txtRepDW').val()) == "") {
			errStr += $g("报卡单位不允许为空!")+"<br>";		//报卡单位
		} 
		
		if((Common_CheckboxLabel("chkDiagList").indexOf("生化标志物")!=-1)&&(Common_CheckboxValue("radBiochemicalMark")=="")){
			errStr += $g("诊断依据选择生化标志物,请选择下方的生化标志物!")+"<br>";		
		}
		if ($.trim($('#cboOutCome').combobox('getText')) == "死亡") {
			if(!$('#txtSWRQ').datebox('getValue')){
				errStr += $g("转归为死亡,死亡日期不允许为空!")+"<br>";		
			}
			if($('#cboCRSWZD').lookup('getText')==""){
				errStr += $g("转归为死亡,死亡诊断不允许为空!")+"<br>";		
			}
			if(!$('#txtSWJTYY').val()){
				errStr += $g("转归为死亡,死亡具体原因不允许为空!")+"<br>";		
			}
		}
	
		var NowDate = Common_GetDate(new Date());
		var txtFBRQ = $('#txtFBRQ').datebox('getValue');
		var txtQZRQ = $('#txtQZRQ').datebox('getValue');
		var txtSWRQ = $('#txtSWRQ').datebox('getValue');
		if (Common_CompareDate(txtFBRQ,NowDate)>0) {
			errStr += $g('发病日期不允许大于当前日期!')+'<br>';			
		}
		if (Common_CompareDate(txtQZRQ,NowDate)>0) {
			errStr += $g('确诊日期不允许大于当前日期!')+'<br>';			
		}
		if ((txtSWRQ!="")&&(Common_CompareDate(txtSWRQ,NowDate)>0)) {
			errStr += $g('死亡日期不允许大于当前日期!')+'<br>';
		}
		if (Common_CompareDate(txtQZRQ,txtSWRQ)>0) { 
			errStr += $g('死亡日期不能小于确诊日期!')+'<br>';
		}
		if (Common_CompareDate(txtFBRQ,txtQZRQ)>0) { 
			errStr += $g('发病日期不能大于确诊日期!')+'<br>';
		}
		if(errStr != "") {
			$.messager.alert($g("提示"), errStr, 'info');
			return false;
		}
		return true;
	}

}

