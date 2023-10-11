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
		$('#btnHistroy').hide();
		$('#btnReturn').hide();
		
		obj.RepStatusCode = $m({      //返回报告状态代码            
			ClassName:"DHCMed.CDService.Service",
			MethodName:"GetReportStatus",
			aReportID:ReportID
		},false);
		
     	switch (obj.RepStatusCode) {
			case "" : // 无报告 只能上报
				$('#btnSaveTemp').show();
				$('#btnSave').show();
				$('#btnCancle').show();
				
				$('#btnHistroy').show();
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
		if (tDHCMedMenuOper['Check']!=1) { //没有审核权限，隐藏审核按钮
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
			
			$('#txtCRReportUser').val(DocName);                  //报告医生
			$('#txtCRReportOrgan').val(HospDesc);                                  //报告单位   
			$('#cboCRReportLoc').combobox('setValue',LocID);                    //报卡科室
			$('#cboCRReportLoc').combobox('setText',LocDesc);                            
			$('#txtCRReportDate').datebox('setValue',Common_GetDate(new Date()));  //报告日期
	        
	      	if(PatientID!=""){
				var PatientCls = $cm({                  
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				$('#txtPatientNo').val(PatientCls.PapmiNo);                   //登记号
				$('#txtPatName').val(PatientCls.PatientName);                 //姓名
				$('#txtPatSex').val(PatientCls.Sex);                          //性别
				var PersonalIDType=PatientCls.PersonalIDType;				//证件类型
				var CardTypeID = $m({                  
					ClassName:"DHCMed.CD.CRReportXNXG",
					MethodName:"GetObjByTypeDesc",
					argTypeCode:"CRCardType",
					argDesc:PersonalIDType
				},false);
				if (CardTypeID){
					$('#cboCardType').combobox('setValue',CardTypeID);                    
					$('#cboCardType').combobox('setText',PersonalIDType); 
				}
				$('#txtPatCardNo').val(PatientCls.PAPMIDVAnumber);          // 证件号
				
				$('#txtJTDH').val(PatientCls.Telephone);                      //联系电话
				$('#txtBirthDay').datebox('setValue',PatientCls.Birthday);    //生日
				var AgeY=PatientCls.Age;
				var AgeM=PatientCls.AgeMonth;
				var AgeD=PatientCls.AgeDay;
				if (AgeY>0){
					$('#txtPatAge').val(PatientCls.Age);
					$('#cboPatAgeDW').combobox('setValue',$g('岁'));
				}else if(AgeM>0){
					$('#txtPatAge').val(PatientCls.AgeMonth);
					$('#cboPatAgeDW').combobox('setValue',$g('月'));
				}else {
					$('#txtPatAge').val(PatientCls.AgeDay);
					$('#cboPatAgeDW').combobox('setValue',$g('天'));
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
					if (session['LOGON.LANGCODE']=="EN"){
						$('#txtAdress1').val($('#cboProvince1').combobox('getText')+$('#cboCity1').combobox('getText')+$('#cboCounty1').combobox('getText')+$('#cboVillage1').combobox('getText'));
					}
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
					if (session['LOGON.LANGCODE']=="EN"){
						$('#txtAdress2').val($('#cboProvince2').combobox('getText')+$('#cboCity2').combobox('getText')+$('#cboCounty2').combobox('getText')+$('#cboVillage2').combobox('getText'));
					}
				}
				if (ServerObj.DicInfo) {// 字典赋值
				    var NationInfo = ServerObj.DicInfo.split("^")[1];
				    var MaritalInfo = ServerObj.DicInfo.split("^")[4];
				   	var EducationInfo = ServerObj.DicInfo.split("^")[5];
				    var OccupationInfo = ServerObj.DicInfo.split("^")[3];
				 
				    $('#cboCRMZ').combobox('setValue',((NationInfo.split(",")[0]) ? NationInfo.split(",")[0]:''));            //民族
		     	    $('#cboCRMZ').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:'')); 
		     		$('#cboMarital').combobox('setValue',((MaritalInfo.split(",")[0]) ? MaritalInfo.split(",")[0]:''));            //民族
		     	    $('#cboMarital').combobox('setText',((MaritalInfo.split(",")[0]) ? MaritalInfo.split(",")[2]:'')); 
		     		$('#cboEducation').combobox('setValue',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[0]:''));            //民族
		     	    $('#cboEducation').combobox('setText',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[2]:'')); 
		     	
					$('#cboCRZY').combobox('setValue',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[0]:''));        //职业
		     	    $('#cboCRZY').combobox('setText',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[2]:''));  
				    //职业与工种一致直接赋值
				  	obj.CRGZ = OccupationInfo.split(",")[1];			 
		    		obj.cboCRGZ = Common_ComboToDic("cboCRGZ","CDGZ"+obj.CRGZ,"",LogonHospID);	
                   	var CRGZInfo = $m({                  
						ClassName:"DHCMed.SSService.DictionarySrv",
						MethodName:"GetDicByDesc",
						argType:"CDGZ"+obj.CRGZ,
						argDesc:OccupationInfo.split(",")[2],
						argIsActive:1
					},false);
				  	$('#cboCRGZ').combobox('setValue',((OccupationInfo.split(",")[0]) ? CRGZInfo.split("^")[0]:''));     //工种
					$('#cboCRGZ').combobox('setText',((OccupationInfo.split(",")[0]) ? CRGZInfo.split("^")[2]:''));    //工种	   					
				}				
			}
		}else{
		
			var ReportCls = $m({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false);
		    var ReportZLKCls = $m({                  
				ClassName:"DHCMed.CD.CRReportZLK",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			
			var PatientCls = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=ReportCls.split("^");
			var arrZLK=ReportZLKCls.split("^");
			var arrPat=PatientCls.split("^");
			$('#txtCRKPBH').val(arrZLK[0]);
			$('#txtPatientNo').val(arrPat[3]);
			$('#cboCRBQYGZBR').combobox('setValue',arrZLK[1].split(CHR_1)[0]);   //
			$('#cboCRBQYGZBR').combobox('setText',arrZLK[1].split(CHR_1)[1]);   //
			$('#txtPatName').val(arrPat[4]);
			$('#txtPatCardNo').val(arrPat[11]);
			$('#txtJTDH').val(arrPat[12]);
			$('#txtPatSex').val(arrPat[6]);
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
			$('#txtPatAge').val(patAge);
			$('#cboPatAgeDW').combobox('setValue',patAgeDW);
			$('#txtBirthDay').datebox('setValue',Common_FormatDate(arrPat[7]));                          //出生日期
		
			//职业与具体工种联动赋值处理
			$('#cboCRZY').combobox({
				onLoadSuccess:function(data){  
					var data=$(this).combobox('getData');
					for(i=0;i<data.length;i++){
						if (data[i]['DicRowId']==arrPat[16].split(CHR_1)[0]) {
							obj.CRGZ = "CDGZ"+data[i]['DicCode'];
						}	
					}
				}
			});
            
			$('#cboMarital').combobox('setValue',arrPat[14].split(CHR_1)[0]);
			$('#cboMarital').combobox('setText',arrPat[14].split(CHR_1)[1]);
			$('#cboEducation').combobox('setValue',arrPat[15].split(CHR_1)[0]);
			$('#cboEducation').combobox('setText',arrPat[15].split(CHR_1)[1]);
			$('#cboCRZY').combobox('setValue',arrPat[16].split(CHR_1)[0]);
			$('#cboCRZY').combobox('setText',arrPat[16].split(CHR_1)[1]);
		  	$('#cboCRGZ').combobox('setValue',arrPat[17].split(CHR_1)[0]);    //工种
			$('#cboCRGZ').combobox('setText',arrPat[17].split(CHR_1)[1]);    //工种	   	

			$('#cboCRMZ').combobox('setValue',arrPat[13].split(CHR_1)[0]);            //民族
		  	$('#cboCRMZ').combobox('setText',arrPat[13].split(CHR_1)[1]);            //民族
			$('#txtGZDW').val(arrPat[21]);                                            //工作单位
			$('#cboProvince1').combobox('setValue',arrPat[29].split(CHR_1)[0]);
			$('#cboProvince1').combobox('setText',((arrPat[29].indexOf(CHR_1)>-1) ? arrPat[29].split(CHR_1)[1] : ''));
			$('#cboCity1').combobox('setValue',arrPat[30].split(CHR_1)[0]);
		    $('#cboCity1').combobox('setText',((arrPat[30].indexOf(CHR_1)>-1) ? arrPat[30].split(CHR_1)[1] : ''));
			$('#cboCounty1').combobox('setValue',arrPat[31].split(CHR_1)[0]);
			$('#cboCounty1').combobox('setText',((arrPat[31].indexOf(CHR_1)>-1) ? arrPat[31].split(CHR_1)[1] : ''));
			$('#cboVillage1').combobox('setValue',arrPat[32].split(CHR_1)[0]);
			$('#cboVillage1').combobox('setText',((arrPat[32].indexOf(CHR_1)>-1) ? arrPat[32].split(CHR_1)[1] : ''));
			$('#txtCUN1').val(arrPat[33]);
			$('#txtAdress1').val(arrPat[34]);
			
			$('#cboProvince2').combobox('setValue',arrPat[23].split(CHR_1)[0]);
			$('#cboProvince2').combobox('setText',((arrPat[23].indexOf(CHR_1)>-1) ? arrPat[23].split(CHR_1)[1] : ''));
			$('#cboCity2').combobox('setValue',arrPat[24].split(CHR_1)[0]);
			$('#cboCity2').combobox('setText',((arrPat[24].indexOf(CHR_1)>-1) ? arrPat[24].split(CHR_1)[1] : ''));
			$('#cboCounty2').combobox('setValue',arrPat[25].split(CHR_1)[0]);
			$('#cboCounty2').combobox('setText',((arrPat[25].indexOf(CHR_1)>-1) ? arrPat[25].split(CHR_1)[1] : ''));
			$('#cboVillage2').combobox('setValue',arrPat[26].split(CHR_1)[0]);
			$('#cboVillage2').combobox('setText',((arrPat[26].indexOf(CHR_1)>-1) ? arrPat[26].split(CHR_1)[1] : ''));	
			$('#txtCUN2').val(arrPat[27]);
			$('#txtAdress2').val(arrPat[28]);
			
			//$('#txtCRZDBW').val(arrZLK[4]);                          //诊断部位
			//诊断部位 update 2019-02-21
			if (arrZLK[31]) {
				obj.CRZDBWID = arrZLK[31].split(CHR_1)[0]; 
				$('#cboCRZDBW').lookup('setText',arrZLK[31].split(CHR_1)[1]);       
			}
			obj.CRZD = arrZLK[2].split(CHR_1)[0];
			$('#cboCRZD').lookup('setText',arrZLK[2].split(CHR_1)[1]);       
			$('#txtCRZDICD').val(arrZLK[3]);
			//$('#txtCRBLXLX').val(arrZLK[6]);
			//病理类型 update 2019-02-21
			if (arrZLK[32]) {
				obj.CRBLXLXID = arrZLK[32].split(CHR_1)[0]; 
				$('#cboCRBLXLX').lookup('setText',arrZLK[32].split(CHR_1)[1]);       
			}
			//解剖学编码 update 2020-02-25
			if (arrZLK[33]) {
				obj.CRJPXBMID = arrZLK[33].split(CHR_1)[0]; 
				$('#cboJPXBM').lookup('setText',arrZLK[33].split(CHR_1)[1]);       
			}
			$('#txtCRBLH').val(arrZLK[7]);
			$('#txtCRZDRQ').datebox('setValue',arrZLK[13]);
			obj.CRYZD = arrZLK[22].split(CHR_1)[0];
			$('#cboCRYZD').lookup('setText',arrZLK[22].split(CHR_1)[1]);	
			$('#txtCRYZDRQ').datebox('setValue',arrZLK[24]);			
			$('#cboCRZGZDDW').combobox('setValue',arrZLK[17].split(CHR_1)[0]); 
			$('#cboCRZGZDDW').combobox('setText',arrZLK[17].split(CHR_1)[1]); 
			
			$('#txtCRSWRQ').datebox('setValue',arrZLK[25]);
			$('#txtCRSYICD').val(arrZLK[28]);
			$('#cboCRSWYY').combobox('setValue',arrZLK[26].split(CHR_1)[0]);
			$('#cboCRSWYY').combobox('setText',arrZLK[26].split(CHR_1)[1]); 
			$('#txtCRBSZY').val(arrZLK[29]);
			obj.CRSWZD = arrZLK[30].split(CHR_1)[0];
			$('#cboCRSWZD').lookup('setText',arrZLK[30].split(CHR_1)[1]); 
			for (var len=0; len < arrZLK[15].split(',').length;len++) {  
				var valueCode = arrZLK[15].split(',')[len];
				$('#cbgCRZDYJ'+valueCode).checkbox('setValue', (valueCode!="" ? true:false));              
			}
			$('#txtCRJTSWYY').val(arrZLK[27]);
			$('#cboCRFHCD').combobox('setValue',arrZLK[9].split(CHR_1)[0]); 
			$('#cboCRTNMFQT').combobox('setValue',arrZLK[10].split(CHR_1)[0]); 
			$('#cboCRTNMFQN').combobox('setValue',arrZLK[11].split(CHR_1)[0]); 
			$('#cboCRTNMFQM').combobox('setValue',arrZLK[12].split(CHR_1)[0]); 
			$('#cboCRFHCD').combobox('setText',arrZLK[9].split(CHR_1)[1]); 
			$('#cboCRTNMFQT').combobox('setText',arrZLK[10].split(CHR_1)[1]); 
			$('#cboCRTNMFQN').combobox('setText',arrZLK[11].split(CHR_1)[1]); 
			$('#cboCRTNMFQM').combobox('setText',arrZLK[12].split(CHR_1)[1]); 
			$('#txtCRReportUser').val(arrRep[5].split(",")[1]);
			obj.UserID = arrRep[5].split(",")[0];
			$('#cboCRReportLoc').combobox('setValue',arrRep[3]);
			$('#cboCRReportLoc').combobox('setText',arrRep[4]);
			$('#cboCardType').combobox('setValue',arrZLK[34].split(CHR_1)[0]); 
			$('#cboCardType').combobox('setText',arrZLK[34].split(CHR_1)[1]); 
			$('#ContactOne').val(arrZLK[35]);
			$('#RelationOne').combobox('setValue',arrZLK[36].split(CHR_1)[0]); 
			$('#RelationOne').combobox('setText',arrZLK[36].split(CHR_1)[1]);
			$('#PhoneOne').val(arrZLK[37]);
			$('#ContactTwo').val(arrZLK[38]);
			$('#RelationTwo').combobox('setValue',arrZLK[39].split(CHR_1)[0]); 
			$('#RelationTwo').combobox('setText',arrZLK[39].split(CHR_1)[1]);
			$('#PhoneTwo').val(arrZLK[40]);
			$('#ContactThr').val(arrZLK[41]);
			$('#RelationThr').combobox('setValue',arrZLK[42].split(CHR_1)[0]); 
			$('#RelationThr').combobox('setText',arrZLK[42].split(CHR_1)[1]);
			$('#PhoneThr').val(arrZLK[43]);
			$('#AttackDate').datebox('setValue',arrZLK[44]);
			$('#cboAction').combobox('setValue',arrZLK[45].split(CHR_1)[0]); 
			$('#cboAction').combobox('setText',arrZLK[45].split(CHR_1)[1]);
			$('#txtCRReportOrgan').val(arrRep[6]);
			$('#txtCRReportDate').datebox('setValue',arrRep[7]);
			
			
			if ((!obj.CRZDBWID)&&(arrZLK[4]))    {         //处理历史诊断部位
				$('#cboCRZDBW').bind('mouseover', function (e) {   //诊断部位
					$HUI.tooltip('#cboCRZDBW',{
						position:'top',
						content: $g('历史诊断部位：')+arrZLK[4]+' ；'+$g('请修改为新诊断部位类型。')
					}).show();	
				});
			}
				
			if ((!obj.CRBLXLXID)&&(arrZLK[6]))  {   //处理历史病理学类型
				$('#cboCRBLXLX').bind('mouseover', function (e) {   //病理学类型					
					$HUI.tooltip('#cboCRBLXLX',{
						position:'top',
						content: $g('历史病理学类型：')+arrZLK[6]+' ；'+$g('请修改为新病理学类型。')
					}).show();
					
				});
			}
			
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
		}
	};
	//得到报告数据
	obj.GetRepData = function (step) {
		
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"ZLK";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3作废
		InputStr=InputStr+"^"+$.trim($('#cboCRReportLoc').combobox('getValue'));
		if(obj.ReportID==""){
			InputStr=InputStr+"^"+session['LOGON.USERID'];
		}else{
			InputStr=InputStr+"^"+obj.UserID;
		}
		InputStr=InputStr+"^"+$.trim($('#txtCRReportOrgan').val());
		InputStr=InputStr+"^"+$('#txtCRReportDate').datebox('getValue');
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		return InputStr;
	}
	
	obj.GetZLKData = function () {
		var InputStr=obj.ReportID;
		
		InputStr=InputStr+"^"+$.trim($('#txtCRKPBH').val());                  //编号
		InputStr=InputStr+"^"+$.trim($('#cboCRBQYGZBR').combobox('getValue'));
		InputStr=InputStr+"^"+obj.CRZD;
		InputStr=InputStr+"^"+$.trim($('#txtCRZDICD').val());
		InputStr=InputStr+"^"+$.trim($('#cboCRZDBW').lookup('getText'));
		InputStr=InputStr+"^"+$.trim($('#cboCRBLXLX').lookup('getText'));
		InputStr=InputStr+"^"+$.trim($('#txtCRBLH').val());
		InputStr=InputStr+"^"+$('#txtCRZDRQ').datebox('getValue');
		InputStr=InputStr+"^"+obj.CRYZD;
		InputStr=InputStr+"^"+$('#txtCRYZDRQ').datebox('getValue');
		InputStr=InputStr+"^"+$.trim($('#cboCRZGZDDW').combobox('getValue'));
		InputStr=InputStr+"^"+$('#txtCRSWRQ').datebox('getValue');
		InputStr=InputStr+"^"+$.trim($('#txtCRSYICD').val());
		InputStr=InputStr+"^"+$.trim($('#cboCRSWYY').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCRBSZY').val());
		InputStr=InputStr+"^"+Common_CheckboxValue('cbgCRZDYJ');
		InputStr=InputStr+"^"+$.trim($('#txtCRJTSWYY').val());
		InputStr=InputStr+"^"+$.trim($('#cboCRTNMFQT').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCRTNMFQN').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCRTNMFQM').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCRFHCD').combobox('getValue'));
		InputStr=InputStr+"^"+obj.CRSWZD;
		InputStr=InputStr+"^"+obj.CRZDBWID;    //诊断部位
		InputStr=InputStr+"^"+obj.CRBLXLXID;   //病理类型
		InputStr=InputStr+"^"+obj.CRJPXBMID;   //解剖学编码  add 2020-02-25
		InputStr=InputStr+"^"+$.trim($('#cboCardType').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#ContactOne').val());
		InputStr=InputStr+"^"+$.trim($('#RelationOne').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#PhoneOne').val());
		InputStr=InputStr+"^"+$.trim($('#ContactTwo').val());
		InputStr=InputStr+"^"+$.trim($('#RelationTwo').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#PhoneTwo').val());
		InputStr=InputStr+"^"+$.trim($('#ContactThr').val());
		InputStr=InputStr+"^"+$.trim($('#RelationThr').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#PhoneThr').val());
		InputStr=InputStr+"^"+$('#AttackDate').datebox('getValue');
		InputStr=InputStr+"^"+$.trim($('#cboAction').combobox('getValue'));
		
		
		return InputStr;
	}
	
	obj.GetPatData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+$.trim($('#txtPatientNo').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatName').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatCardNo').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatSex').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatAge').val());
		InputStr=InputStr+"^"+$.trim($('#cboPatAgeDW').combobox('getValue')); 
		InputStr=InputStr+"^"+$('#txtBirthDay').datebox('getValue');
		InputStr=InputStr+"^"+$.trim($('#cboCRZY').combobox('getValue'));  
		InputStr=InputStr+"^"+$.trim($('#cboCRMZ').combobox('getValue')); 
		InputStr=InputStr+"^"+$.trim($('#cboCRGZ').combobox('getValue'));  
		InputStr=InputStr+"^"+$.trim($('#txtJTDH').val());
		InputStr=InputStr+"^"+$.trim($('#txtGZDW').val());
		InputStr=InputStr+"^"+$.trim($('#cboProvince1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCity1').combobox('getValue')); 
		InputStr=InputStr+"^"+$.trim($('#cboCounty1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboVillage1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCUN1').val());   
		InputStr=InputStr+"^"+$.trim($('#txtAdress1').val());
		InputStr=InputStr+"^"+$.trim($('#cboProvince2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCity2').combobox('getValue')); 
		InputStr=InputStr+"^"+$.trim($('#cboCounty2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboVillage2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCUN2').val());  
		InputStr=InputStr+"^"+$.trim($('#txtAdress2').val());
		
		InputStr=InputStr+"^"+$.trim($('#cboEducation').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboMarital').combobox('getValue'));
		return InputStr;
	}
	
	obj.GetExtraData = function () {
		var InputStr=obj.ReportID;
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
		
		$('#btnHistroy').on("click", function(){
			obj.btnHistroy_click(); 
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
	//保存
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var ZLKData=obj.GetZLKData();
		var PatData=obj.GetPatData();
		var ExtraData=obj.GetExtraData();
 
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:ZLKData,
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
	// 草稿
	obj.btnSaveTemp_click = function(){
		var RepData=obj.GetRepData(4);
		var ZLKData=obj.GetZLKData();
		var PatData=obj.GetPatData();
		var ExtraData=obj.GetExtraData();
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:ZLKData,
			PatInfo:PatData,
			ExtraInfo:ExtraData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("草稿数据保存错误!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("草稿数据保存成功！")+"<br>"+$g("请及时完善肿瘤卡信息,否则将影响患者办理出院!"), 'info');
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
	//作废
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
			//var flg=ExportDataToExcel("","","肿瘤报告卡("+$('#txtPatName').val()+")",cArguments);
			var fileName="DHCMA_CD_PrintReportZLK.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
			DHCCPM_RQPrint(fileName);
		}
	};
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'error');
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
			$.messager.alert($g("错误"),$g("打印打印失败")+"!"+ret, 'error');
			return;
		}else{
			//var cArguments=obj.ReportID;
			//var flg=PrintDataToExcel("","","肿瘤报告卡("+$('#txtPatName').val()+")",cArguments);
			///var fileName="DHCMA_CD_PrintReportZLK.raq&aReportID="+obj.ReportID;
			///DHCCPM_RQPrint(fileName);
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintCDZLKInfo");		//打印任务的名称
			LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
			LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
			LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
			LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
			LodopPrintURL(LODOP,"dhcma.cd.lodopzlk.csp?ReportID="+obj.ReportID);
			LODOP.PRINT();			//直接打印
			
			
		}
	};
	obj.btnCancle_click = function(){
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //关闭
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
	};
	$('#winHistoryEdit').dialog({
		title: $g('肿瘤报卡历史数据 (双击一条数据即可)'),
		closed: true,
		modal: true,
		isTopZindex:false,
		buttons:[{
			text:$g('关闭'),
			handler:function(){
				$HUI.dialog('#winHistoryEdit').close();
			}
		}]
	});
	obj.btnHistroy_click = function(){
		$HUI.dialog('#winHistoryEdit').open();
		obj.gridHistoryList();
	};
	
	obj.gridHistoryList = function(){
		$("#gridHistoryList").datagrid("loading");	
		$cm ({
			ClassName:"DHCMed.CDService.QryService",
			QueryName:"QryZLKRepByPatientID",
			aPatientID:PatientID,
			aRepType:"ZLK",
			page:1,
			rows:99999
		},function(rs){
			$('#gridHistoryList').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);							
		});
	}
	// 双击编辑事件
	obj.gridHistoryList_onDbselect = function(rowIndex, rd){
		$HUI.dialog('#winHistoryEdit').close();
		obj.ReportID = rd.ReportID
		obj.DisplayRepInfo();
		setTimeout(function(){
			$('#txtCRKPBH').val("");
			$('#txtCRReportDate').datebox('setValue',Common_GetDate(new Date()));  //报告日期
			obj.ReportID=""
		},300)
	}
	//检查规范
	obj.CheckReport = function(){
		var errStr = "";
		if ($.trim($('#cboCRBQYGZBR').combobox('getValue')) == "") {
			errStr += $g("请选择填写病情已告知病人")+"!<br>";		//病情已告知病人
		}
		if ($.trim($('#txtPatName').val()) == "") {
			errStr += $g("姓名不允许为空")+"!<br>";		//姓名
		}
		if ($.trim($('#txtPatSex').val()) == "") {
			errStr += $g("性别不允许为空")+"!<br>";		//性别
		}
		if ($.trim($('#txtPatAge').val()) == "") {
			errStr += $g("年龄不允许为空")+"!<br>";		//年龄
		}
		if ($('#txtBirthDay').datebox('getValue') == "") {
			errStr += $g("出生日期不允许为空")+"!<br>";		//生日
		}
		
		if ($.trim($('#cboCRMZ').combobox('getValue')) == "") {
			errStr += $g("请选择民族")+"!<br>";		//民族
		}
		if ($.trim($('#cboEducation').combobox('getValue')) == "") {
			errStr += $g("请选择文化程度")+"!<br>";		//文化
		}
		if ($.trim($('#cboMarital').combobox('getValue')) == "") {
			errStr += $g("请选择婚姻状况")+"!<br>";		//婚姻
		}
		if ($.trim($('#cboCRZY').combobox('getValue')) == "") {
			errStr += $g("请选择职业")+"!<br>";		//职业
		}
		if ($.trim($('#cboCRGZ').combobox('getValue')) == "") {
			errStr += $g("请选择具体工种")+"!<br>";		//具体工种
		}
		if ($.trim($('#txtJTDH').val()) == "") {
			errStr += $g("电话不允许为空")+"!<br>";		//电话
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			errStr += $g("身份证号不允许为空")+"!<br>";		//身份证号
		}
		// 身份证格式验证		
		if (($('#cboCardType').combobox('getText').indexOf("身份证")>-1)&&($.trim($('#txtPatCardNo').val()) != "")){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test($.trim($('#txtPatCardNo').val())))) {
				errStr += $g('输入的身份证号格式不符合规定！请重新输入')+'!<br>';
			}
		}
		//电话号码格式验证 !(/^([0-9]{3,4}-)?[0-9]{7,8}$/.test(phone))
		if ($.trim($('#txtJTDH').val()) != ""){
			if (!(/^1[3456789]\d{9}$/.test($.trim($('#txtJTDH').val())))) {
				errStr += $g('输入的电话号码格式不符合规定！请重新输入')+'!<br>';
			}
		}
		if ($.trim($('#cboProvince1').combobox('getValue')) == "") {
			errStr += $g("请选择目前居住地址省")+"!<br>";		//省
		}
		if ($.trim($('#cboCity1').combobox('getValue')) == "") {
			errStr += $g("请选择目前居住地址市")+"!<br>";		//市
		}
		if ($.trim($('#cboCounty1').combobox('getValue')) == "") {
			errStr += $g("请选择目前居住地址县")+"!<br>";		//县
		}
		if ($.trim($('#cboVillage1').combobox('getValue')) == "") {
			errStr += $g("请选择目前居住地址街道")+"!<br>";		//街道
		}
		if ($.trim($('#txtCUN1').val()) == "") {
			errStr += $g("目前居住地址村不允许为空")+"!<br>";		//村
		}  
		if ($.trim($('#txtAdress1').val()) == "") {
			errStr += $g("目前居住详细地址不允许为空")+"!<br>";		//详细地址		
		}  
		if ($.trim($('#cboProvince2').combobox('getValue')) == "") {
			errStr += $g("请选择常住户口地址省")+"!<br>";		//省
		}
		if ($.trim($('#cboCity2').combobox('getValue')) == "") {
			errStr += $g("请选择常住户口地址市")+"!<br>";		//市
		}
		if ($.trim($('#cboCounty2').combobox('getValue')) == "") {
			errStr += $g("请选择常住户口地址县")+"!<br>";		//县
		}
		if ($.trim($('#cboVillage2').combobox('getValue')) == "") {
			errStr += $g("请选择常住户口地址街道")+"!<br>";		//街道
		}
		if ($.trim($('#txtCUN2').val()) == "") {
			errStr += $g("常住户口地址村不允许为空")+"!<br>";		//村
		}  
		if ($.trim($('#txtAdress2').val()) == "") {
			errStr += $g("常住户口详细地址不允许为空")+"!<br>";		//详细地址		
		}  
		if ($.trim($('#ContactOne').val()) == "") {
			errStr += $g("联系方式1的姓名不允许为空")+"!<br>";		// 联系人1		
		} 
		if ($.trim($('#RelationOne').combobox('getValue')) == "") {
			errStr += $g("联系人1与患者关系不允许为空")+"!<br>";		// 与患者关系		
		} 
		if ($.trim($('#PhoneOne').val()) == "") {
			errStr += $g("联系人1的联系电话不允许为空")+"!<br>";		// 联系电话		
		} 
		
		if (($.trim($('#PhoneOne').val()) != "")&&(!(/^1[3456789]\d{9}$/.test($.trim($('#PhoneOne').val()))))) {
			errStr += $g("联系人1的联系电话格式不正确,请重新输入")+"!<br>";		// 联系电话		
		}
		
		
		
		if ($.trim($('#txtCRZDICD').val()) == "") {
			errStr += $g("ICD编码不允许为空")+"!<br>";		//ICD编码
		}  
		if ($.trim($('#cboCRZGZDDW').combobox('getValue')) == "") {
			errStr += $g("请选择最高诊断单位")+"!<br>";		//最高诊断单位
		}
		
		if (($.trim($('#cboCRZD').lookup('getText')) == "")||(obj.CRZD =="")) {
			errStr += $g("诊断不允许为空,请选择诊断")+"!<br>";		//诊断
		}
		if (($.trim($('#cboCRYZD').lookup('getText')) != "")&&(obj.CRYZD =="")) {
			errStr += $g("请选择原诊断")+"!<br>";		//诊断
		}
		if (Common_CheckboxValue('cbgCRZDYJ') == "") {
			errStr += $g("诊断依据不允许为空")+"!<br>";		//诊断依据
		}
		if (($.trim($('#cboCRZDBW').lookup('getText')) == "")||(obj.CRZDBWID =="")) {
			errStr += $g("诊断部位不允许为空,请选择诊断部位")+"!<br>";		//诊断部位
		}
		
		if ($.trim($('#cboCRTNMFQT').combobox('getValue')) == "") {
			errStr += $g("请选择确认时期别T")+"!<br>";		// 确认时期别T!
		}
		if ($.trim($('#cboCRTNMFQN').combobox('getValue')) == "") {
			errStr += $g("请选择确认时期别N")+"!<br>";		// 确认时期别N!
		}
		if ($.trim($('#cboCRTNMFQM').combobox('getValue')) == "") {
			errStr += $g("请选择确认时期别M")+"!<br>";		// 确认时期别M!
		}
		if ($.trim($('#cboCRFHCD').combobox('getValue')) == "") {
			errStr += $g("请选择期别")+"!<br>";			// 期别
		}
		if ($('#AttackDate').datebox('getValue') == "") {
			errStr += $g("发病日期不允许为空")+"!<br>";	// 发病日期
		}
		if ($.trim($('#cboAction').combobox('getValue')) == "") {
			errStr += $g("请选择行为")+"!<br>";			// 行为
		}
		
		
		
		if ($.trim($('#txtCRReportOrgan').val()) == "") {
			errStr += $g("报卡单位不允许为空")+"!<br>";		//报卡单位
		}  
		if ($('#txtCRReportDate').datebox('getValue') == "") {
			errStr += $g("报卡日期不允许为空")+"!<br>";		//报卡日期
		}
		if ($.trim($('#txtCRZDICD').val()) == "") {
			errStr += $g("ICD编码不允许为空")+"!<br>";		//ICD编码
		}  
		if ($('#txtCRZDRQ').datebox('getValue') == "") {
			errStr += $g("诊断日期不允许为空")+"!<br>";		//诊断日期
		}
		
		var NowDate = Common_GetDate(new Date());
		var txtCRZDRQ = $('#txtCRZDRQ').datebox('getValue');
		var txtCRFBRQ = $('#AttackDate').datebox('getValue');
		if (Common_CompareDate(txtCRZDRQ,NowDate)>0) {
			errStr += $g('诊断日期不允许大于当前日期')+'!<br>';			
		}
		if (Common_CompareDate(txtCRFBRQ,txtCRZDRQ)>0) {
			errStr += $g('诊断日期不允许小于发病日期')+'!<br>';			
		}
		if (Common_CompareDate(txtCRZDRQ,NowDate)>0) {
			errStr += $g('诊断日期不允许大于当前日期')+'!<br>';			
		}
		var txtCRYZDRQ = $('#txtCRYZDRQ').datebox('getValue');
		if (Common_CompareDate(txtCRYZDRQ,NowDate)>0) {
			errStr += $g('原诊断日期不允许大于当前日期')+'!<br>';			
		}
		var txtCRSWRQ = $('#txtCRSWRQ').datebox('getValue');
		if (Common_CompareDate(txtCRSWRQ,NowDate)>0) {       //死亡日期不能大于当前日期
			errStr += $g('死亡日期不允许大于当前日期')+'!<br>';			
		}
		if (Common_CompareDate(txtCRZDRQ,txtCRSWRQ)>0) { 
			errStr += $g('死亡日期不能小于诊断日期')+'!<br>';
		}
		if (Common_CompareDate(txtCRYZDRQ,txtCRZDRQ)>0) { 
			errStr += $g('原诊断日期不能大于诊断日期')+'!<br>';
		}
		if(errStr != ""){
			$.messager.alert("提示",'<div style="min-height:20px;max-height:480px;overflow:auto">' + errStr + '</div>', 'info');
			return;	
		}
		return true;
	}

}


