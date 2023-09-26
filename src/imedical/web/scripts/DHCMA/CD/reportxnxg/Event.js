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
		
		obj.RepStatusCode = $m({                  
			ClassName:"DHCMed.CDService.Service",
			MethodName:"GetReportStatus",
			aReportID:ReportID
		},false);
		
     	switch (obj.RepStatusCode) {
			case "" : // 无报告 只能上报
				$('#btnSave').show();
				$('#btnCancle').show();
				break;
			case "1" : // 待审
				$('#btnSave').linkbutton({text:'修改报卡'});
				$('#btnSave').show();
				$('#btnDelete').show();
				$('#btnCheck').show();
				$('#btnExport').show();
				$('#btnPrint').show();
				$('#btnCancle').show();
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
		if(obj.ReportID==""){
			$('#txtDoctor').val(session['LOGON.USERNAME']);
			$('#cboCRReportLoc').combobox('setValue',LocID);                    //报卡科室
			$('#cboCRReportLoc').combobox('setText',LocDesc);                  
			$('#txtRepDW').val(HospDesc);
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
				var PersonalIDType=objPat.PersonalIDType;				//证件类型
				if(PersonalIDType!="居民身份证"){
					$('#txtPatCardNo').val("");     
				}
				else{
					$('#txtPatCardNo').val(objPat.PersonalID);                //身份证号
				}
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
				patAgeDW="岁";
			}else if(arrPat[9]!=""){
				patAge=arrPat[9];
				patAgeDW="月";
			}else{
				patAge=arrPat[10];
				patAgeDW="天";
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
			$('#txtLXDH').val(arrPat[20]);
			
			$('#dtRepDate').datebox('setValue',arrRep[7]);
			$('#txtSWRQ').datebox('setValue',arrXNXG[12]);
			$('#cboDeathReason').combobox('setValue',arrXNXG[13].split(CHR_1)[0]);
			$('#cboDeathReason').combobox('setText',arrXNXG[13].split(CHR_1)[1]);			
			$('#txtSWJTYY').val(arrXNXG[16]);
			$('#txtSWICD').val(arrXNXG[15]);
			
			obj.CRZD = arrXNXG[1].split(CHR_1)[0];
			$('#cboCRZD').lookup('setText',arrXNXG[1].split(CHR_1)[1]);
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
			$('#chkIsFB').checkbox('setValue',(arrXNXG[9]==1 ? true:false)); //是否首次发病
			for (var len=0; len < arrXNXG[6].split(',').length;len++) {       
				var valueCode = arrXNXG[6].split(',')[len];
				$('#radBSList'+valueCode).checkbox('setValue', (valueCode!=""?true:false));             //病史
			}
			$('#txtFBRQ').datebox('setValue',arrXNXG[7]);
			$('#txtQZRQ').datebox('setValue',arrXNXG[8]);
			$('#cboQZDW').combobox('setValue',arrXNXG[10].split(CHR_1)[0]);	
			$('#cboQZDW').combobox('setText',arrXNXG[10].split(CHR_1)[1]);	
			
			var DiagBase=arrXNXG[5].split(",");
			$('#cboLCZZ').combobox('setValue',DiagBase[0].split(CHR_1)[0]);
			$('#cboLCZZ').combobox('setText',DiagBase[0].split(CHR_1)[1]);
			$('#cboXGZY').combobox('setValue',DiagBase[1].split(CHR_1)[0]);
			$('#cboXGZY').combobox('setText',DiagBase[1].split(CHR_1)[1]);
			$('#cboXDT').combobox('setValue',DiagBase[2].split(CHR_1)[0]);
			$('#cboXDT').combobox('setText',DiagBase[2].split(CHR_1)[1]);
			$('#cboCT').combobox('setValue',DiagBase[3].split(CHR_1)[0]);
			$('#cboCT').combobox('setText',DiagBase[3].split(CHR_1)[1]);
			$('#cboXQM').combobox('setValue',DiagBase[4].split(CHR_1)[0]);
			$('#cboXQM').combobox('setText',DiagBase[4].split(CHR_1)[1]);
			$('#cboCGZ').combobox('setValue',DiagBase[5].split(CHR_1)[0]);
			$('#cboCGZ').combobox('setText',DiagBase[5].split(CHR_1)[1]);
			$('#cboNJY').combobox('setValue',DiagBase[6].split(CHR_1)[0]);
			$('#cboNJY').combobox('setText',DiagBase[6].split(CHR_1)[1]);
			$('#cboSJ').combobox('setValue',DiagBase[7].split(CHR_1)[0]);
			$('#cboSJ').combobox('setText',DiagBase[7].split(CHR_1)[1]);
			$('#cboNDT').combobox('setValue',DiagBase[8].split(CHR_1)[0]);
			$('#cboNDT').combobox('setText',DiagBase[8].split(CHR_1)[1]);
			$('#cboYSJC').combobox('setValue',DiagBase[9].split(CHR_1)[0]);
			$('#cboYSJC').combobox('setText',DiagBase[9].split(CHR_1)[1]);
			
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
		var GXBDiagID = $.trim($('#cboGXB').combobox('getValue')); //冠心病诊断
		var GXBDiagDesc = $.trim($('#cboGXB').combobox('getText'));
		var NZZDiagID = $.trim($('#cboNZZ').combobox('getValue')); //脑卒中诊断
		var NCZDiagDesc = $.trim($('#cboNZZ').combobox('getText')); 
		var DiagBase = $.trim($('#cboLCZZ').combobox('getValue'))+"#"+$.trim($('#cboXGZY').combobox('getValue'))+"#"+$.trim($('#cboXDT').combobox('getValue'))+"#"+$.trim($('#cboCT').combobox('getValue'))+"#"+$.trim($('#cboXQM').combobox('getValue'))+"#"+$.trim($('#cboCGZ').combobox('getValue'))+"#"+$.trim($('#cboNJY').combobox('getValue'))+"#"+$.trim($('#cboSJ').combobox('getValue'))+"#"+$.trim($('#cboNDT').combobox('getValue'))+"#"+$.trim($('#cboYSJC').combobox('getValue'));  //7 诊断依据
	
		var DiagInfo=obj.ReportID;
		DiagInfo=DiagInfo+"^"+$.trim($('#txtKPBH').val());  //2
		DiagInfo=DiagInfo+"^"+$.trim($('#cboBGKLX').combobox('getValue'));  //3报告卡类型
		DiagInfo=DiagInfo+"^"+obj.CRZD+","+$.trim($('#cboCRZD').lookup('getText'));  //4  诊断名称+诊断ID 
		DiagInfo=DiagInfo+"^"+$.trim($('#txtICD').val());   //5ICD
		
		if (GXBDiagID!=""){
			DiagInfo=DiagInfo+"^"+GXBDiagID+","+GXBDiagDesc+"-"+"GXB";	//诊断分类		6
		}else{
			DiagInfo=DiagInfo+"^"+NZZDiagID+","+NCZDiagDesc+"-"+"NCZ";	//诊断分类	    6
		}
	
		DiagInfo=DiagInfo+"^"+DiagBase;
		DiagInfo=DiagInfo+"^"+Common_CheckboxValue('radBSList');  //8病史
		DiagInfo=DiagInfo+"^"+$('#txtFBRQ').datebox('getValue');  //9发病日期
		DiagInfo=DiagInfo+"^"+$('#txtQZRQ').datebox('getValue');  //10确诊日期
		DiagInfo=DiagInfo+"^"+($('#chkIsFB').checkbox('getValue') ? 1 : 0);  //11是否首次发病
		DiagInfo=DiagInfo+"^"+$.trim($('#cboQZDW').combobox('getValue'));  //12确诊单位
		DiagInfo=DiagInfo+"^"+""   //13转归
		
		DiagInfo=DiagInfo+"^"+$('#txtSWRQ').datebox('getValue');  //14死亡日期
		DiagInfo=DiagInfo+"^"+$.trim($('#cboDeathReason').combobox('getValue'))+","+$.trim($('#cboDeathReason').combobox('getText')); //15死亡原因
		DiagInfo=DiagInfo+"^"+$.trim($('#txtSWICD').val());  //16死亡ICD
		DiagInfo=DiagInfo+"^"+$.trim($('#txtSWJTYY').val())  //17死亡具体原因
		DiagInfo=DiagInfo+"^"+Common_CheckboxValue('radSYZZList');  //18首要症状
		DiagInfo=DiagInfo+"^"+$.trim($('#txtBSZY').val());  //19病史摘要
		DiagInfo=DiagInfo+"^"+$.trim($('#cboSHTD').combobox('getValue'));  //20死后推断
		DiagInfo=DiagInfo+"^"+$.trim($('#cboSJJG').combobox('getValue'));  //21时间间隔
		DiagInfo=DiagInfo+"^"+obj.CRSWZD ;                         //22死亡诊断
	  
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
		InputStr = InputStr+"^"+"";	                    					//CRMZH
		InputStr = InputStr+"^"+"";	                    					//CRZYH
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
	}	
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
			$.messager.alert("错误","数据保存错误!"+ret, 'error');
			return;
		}else{
			$.messager.alert("提示","数据保存成功!", 'info');
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
			$.messager.alert("错误","还未上报!", 'error');
			return;
		}
		$.messager.confirm("提示","请确认是否作废?",function(r){
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
					$.messager.alert("错误","作废失败!"+ret, 'error');
					return;
				}else{
					$.messager.alert("提示","报告作废成功!", 'info');
					obj.InitRepPowerByStatus(obj.ReportID);
				}
			}
		});
	};
	
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("错误","请先做【上报】操作", 'info');
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
			$.messager.alert("错误","报告审核失败!"+ret, 'error');
			return;
		}else{
			$.messager.alert("提示","报告审核成功!", 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	};
	//取消审核
	obj.btnCanCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("错误","请先做【上报】操作", 'info');
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
			$.messager.alert("错误","取消审核失败!"+ret, 'error');
			return;
		}else{
			$.messager.alert("提示","取消审核成功!", 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	}
	
	obj.btnExport_click = function(){
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
			//var cArguments=obj.ReportID;
			//var flg=ExportDataToExcel("","","心脑血管事件报告卡(("+$.trim($('#txtPatName').val())+")",cArguments);
			var fileName="DHCMA_CD_PrintReportXNXG.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
			DHCCPM_RQPrint(fileName);
		}
	};
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
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
		}
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
			errStr += "请选择报卡类型!<br>";		//报卡类型
		}
		if ($.trim($('#txtPatName').val()) == "") {
			errStr += "病人姓名不允许为空!<br>";		//病人姓名
		}
		if ($.trim($('#txtSex').val()) == "") {
			errStr += "性别不允许为空!<br>";		//性别
		}
		if ($.trim($('#txtAge').val()) == "") {
			errStr += "年龄不允许为空!<br>";		//年龄
		}
		if ($.trim($('#cboNation').combobox('getValue')) == "") {
			errStr += "请选择民族!<br>";		//民族
		}
		if ($.trim($('#cboEducation').combobox('getValue')) == "") {
			errStr += "请选择文化!<br>";		//文化
		}
		if ($.trim($('#cboMarital').combobox('getValue')) == "") {
			errStr += "请选择婚姻情况!<br>";		//婚姻情况
		}
		if ($.trim($('#cboOccupation').combobox('getValue')) == "") {
			errStr += "请选择职业!<br>";		//职业
		}
		if ($.trim($('#cboCRGZ').combobox('getValue')) == "") {
			errStr += "请选择具体工种!<br>";		//具体工种
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			errStr += "身份证号不允许为空!<br>";		//身份证号
		}
		// 身份证格式验证	
		if ($.trim($('#txtPatCardNo').val()) != ""){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test($.trim($('#txtPatCardNo').val())))) {
				errStr += '输入的身份证号格式不符合规定！请重新输入!<br>';
			}
		}
		if ($.trim($('#txtLXDH').val()) == "") {
			errStr += "联系电话不允许为空!<br>";		//联系电话
		}else if (!Common_CheckPhone($.trim($('#txtLXDH').val()))){
			errStr += "联系电话格式有误!<br>";		//联系电话
		}
		if ($.trim($('#cboCurrProvince').combobox('getValue')) == "") { //省
			errStr += "请选择居住地址省!<br>";		
		}
		if ($.trim($('#cboCurrCity').combobox('getValue')) == "") {
			errStr += "请选择居住地址市!<br>";		//市
		}
		if ($.trim($('#cboCurrCounty').combobox('getValue')) == "") {
			errStr += "请选择居住地址县!<br>";		//县
		}
		if ($.trim($('#cboCurrVillage').combobox('getValue')) == "") {
			errStr += "请选择居住地址乡/镇!<br>";		//乡/镇
		}
		if ($.trim($('#txtCurrRoad').val()) == "") {
			errStr += "居住地址村不允许为空!<br>";		//村
		}
		if ($.trim($('#txtCurrAddress').val()) == "") {
			errStr += "居住地址详细地址不允许为空!<br>";		//详细地址		
		} 
		if ($.trim($('#cboRegProvince').combobox('getValue')) == "") { //省
			errStr += "请选择户口地址省!<br>";		
		}
		if ($.trim($('#cboRegCity').combobox('getValue')) == "") {
			errStr += "请选择户口地址市!<br>";		//市
		}
		if ($.trim($('#cboRegCounty').combobox('getValue')) == "") {
			errStr += "请选择户口地址县!<br>";		//县
		}
		if ($.trim($('#cboRegVillage').combobox('getValue')) == "") {
			errStr += "请选择户口地址乡/镇!<br>";		//乡/镇
		}
		if ($.trim($('#txtRegRoad').val()) == "") {
			errStr += "户口地址村不允许为空!<br>";		//村
		}
		if ($.trim($('#txtRegAddress').val()) == "") {
			errStr += "户口地址详细地址不允许为空!<br>";		//详细地址		
		}  
		
		if ((obj.CRZD=="")||($.trim($('#cboCRZD').lookup('getText'))) == "") {
			errStr += "诊断不允许为空,请选择诊断!<br>";		  //诊断
		}
		if (Common_RadioValue('radBSList') == "") {
			errStr += "病史不允许为空!<br>";		//病史	
		}   
		if ($('#txtFBRQ').datebox('getValue') == "") {
			errStr += "发病日期不允许为空!<br>";		//发病日期
		}
		if ($('#txtQZRQ').datebox('getValue') == "") {
			errStr += "确诊日期不允许为空!<br>";		//确诊日期
		}
		if ($.trim($('#cboQZDW').combobox('getValue')) == "") {
			errStr += "请选择确诊单位!<br>";		//确诊单位
		}
		if ($.trim($('#txtRepDW').val()) == "") {
			errStr += "报卡单位不允许为空!<br>";		//报卡单位
		} 
		if ($.trim($('#cboCGZ').combobox('getValue')) == "") {
			errStr += "请选择磁共振!<br>";		//磁共振
		}
		if ($.trim($('#cboXQM').combobox('getValue')) == "") {
			errStr += "请选择血清酶!<br>";		//血清酶
		}
		if ($.trim($('#cboXDT').combobox('getValue')) == "") {
			errStr += "请选择心电图!<br>";		//心电图
		}
		if ($.trim($('#cboCT').combobox('getValue')) == "") {
			errStr += "请选择CT!<br>";		//CT
		}
		if ($.trim($('#cboXGZY').combobox('getValue')) == "") {
			errStr += "请选择确诊单位!<br>";		//血管阴影
		}
		if ($.trim($('#cboLCZZ').combobox('getValue')) == "") {
			errStr += "请选择临床症状!<br>";		//临床症状
		}
		if ($.trim($('#cboNJY').combobox('getValue')) == "") {
			errStr += "请选择脑脊液!<br>";		//脑脊液
		}
		if ($.trim($('#cboSJ').combobox('getValue')) == "") {
			errStr += "请选择尸检!<br>";		//尸检
		}
		if ($.trim($('#cboNDT').combobox('getValue')) == "") {
			errStr += "请选择脑电图!<br>";		//脑电图
		}
		if ($.trim($('#cboYSJC').combobox('getValue')) == "") {
			errStr += "请选择医生检查!<br>";		//医生检查
		}
	
		var NowDate = Common_GetDate(new Date());
		var txtFBRQ = $('#txtFBRQ').datebox('getValue');
		var txtQZRQ = $('#txtQZRQ').datebox('getValue');
		var txtSWRQ = $('#txtSWRQ').datebox('getValue');
		if (Common_CompareDate(txtFBRQ,NowDate)>0) {
			errStr += '发病日期不允许大于当前日期!<br>';			
		}
		if (Common_CompareDate(txtQZRQ,NowDate)>0) {
			errStr += '确诊日期不允许大于当前日期!<br>';			
		}
		if ((txtSWRQ!="")&&(Common_CompareDate(txtSWRQ,NowDate)>0)) {
			errStr += '死亡日期不允许大于当前日期!<br>';
		}
		if (Common_CompareDate(txtQZRQ,txtSWRQ)>0) { 
			errStr += '死亡日期不能小于确诊日期!<br>';
		}
		if (Common_CompareDate(txtFBRQ,txtQZRQ)>0) { 
			errStr += '发病日期不能大于确诊日期!<br>';
		}
		if(errStr != "") {
			$.messager.alert("提示", errStr, 'info');
			return false;
		}
		return true;
	}

}


