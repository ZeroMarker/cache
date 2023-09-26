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
	//显示数据
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			
			$('#txtCRReportUser').val(session['LOGON.USERNAME']);                //报告医生
			$('#txtCRReportOrgan').val(HospDesc);                                //报告单位
			$('#txtCRReportDate').datebox('setValue',Common_GetDate(new Date()));  //报告日期
			$('#cboCRReportLoc').combobox('setValue',LocID);                    //报卡科室
			$('#cboCRReportLoc').combobox('setText',LocDesc);                            
				
			if(PatientID!=""){
				var objPat = $cm({                  
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				$('#txtPatientNo').val(objPat.PapmiNo);                  //登记号
				$('#txtPatName').val(objPat.PatientName);                 //姓名
				$('#txtPatSex').val(objPat.Sex);                          //性别
				var PersonalIDType=objPat.PersonalIDType;				//证件类型
				if(PersonalIDType!="居民身份证"){
					$('#txtPatCardNo').val("");     
				}
				else{
					$('#txtPatCardNo').val(objPat.PersonalID);                //身份证号
				}
				
				$('#txtBirthDay').datebox('setValue',objPat.Birthday);     //生日
				//$('#cboCRMZ').combobox('setValue',objPat.Nation);          //民族
				$('#txtJTDH').val(objPat.Telephone);                       //联系电话
				$('#txtGZDW').val(objPat.WorkAddress);                     //工作单位
				$('#txtAdress1').val(objPat.Address);                      //家庭住址1
				$('#txtAdress2').val(objPat.Address);                      //家庭住址2
				
				var AgeY=objPat.Age;
				var AgeM=objPat.AgeMonth;
				var AgeD=objPat.AgeDay;
				if (AgeY>0){
					$('#txtPatAge').val(objPat.Age);
					$('#cboPatAgeDW').combobox('setValue','岁');
				}else if(AgeM>0){
					$('#txtPatAge').val(objPat.AgeMonth);
					$('#cboPatAgeDW').combobox('setValue','月');
				}else {
					$('#txtPatAge').val(objPat.AgeDay);
					$('#cboPatAgeDW').combobox('setValue','天');
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
				
				if (ServerObj.DicInfo) {// 字典赋值
				    var NationInfo = ServerObj.DicInfo.split("^")[1];
				    var EducationInfo = ServerObj.DicInfo.split("^")[5];
				    var OccupationInfo = ServerObj.DicInfo.split("^")[3];
				
					$('#cboCRMZ').combobox('setValue',((NationInfo.split(",")[0]) ? NationInfo.split(",")[0]:''));            //民族		     	    $('#cboNation').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:'')); 
		     		$('#cboCRMZ').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:''));            //民族		     	    $('#cboNation').combobox('setText',((NationInfo.split(",")[0]) ? NationInfo.split(",")[2]:'')); 
		     		$('#cboCRWH').combobox('setValue',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[0]:''));            //民族
		     	    $('#cboCRWH').combobox('setText',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[2]:'')); 
		     	
					$('#cboCRZY').combobox('setValue',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[0]:''));        //职业
		     	    $('#cboCRZY').combobox('setText',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[2]:''));  
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
			
		    var objTNB = $m({                  
				ClassName:"DHCMed.CD.CRReportTNB",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			
			var objPat = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			var arrTNB=objTNB.split("^");
			var arrPat=objPat.split("^");
			
			$('#txtCRKPBH').val(arrTNB[0]);
			$('#txtPatientNo').val(arrPat[3]);
			$('#txtPatName').val(arrPat[4]);
			$('#txtPatCardNo').val(arrPat[11]);
			$('#txtPatSex').val(arrPat[6]);
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
		
			//职业与具体工种联动赋值处理
			$HUI.combobox('#cboCRZY',{
				onLoadSuccess:function(){   
					var data=$(this).combobox('getData');
					for(i=0;i<data.length;i++){
						if (data[i]['DicRowId']==arrPat[16].split(CHR_1)[0]) {
							obj.CRGZ = "CDGZ"+data[i]['DicCode'];
						}	
					}
				}
			});
			$('#txtPatAge').val(patAge);
			$('#cboPatAgeDW').combobox('setValue',patAgeDW);
			$('#txtBirthDay').datebox('setValue',arrPat[7]);                          //出生日期
			$('#cboCRZY').combobox('setValue',arrPat[16].split(CHR_1)[0]);
			$('#cboCRZY').combobox('setText',arrPat[16].split(CHR_1)[1]);
			$('#cboCRGZ').combobox('setValue',arrPat[17].split(CHR_1)[0]);    //工种
			$('#cboCRGZ').combobox('setText',arrPat[17].split(CHR_1)[1]);    //工种
			$('#cboCRMZ').combobox('setValue',arrPat[13].split(CHR_1)[0]);             //民族
			$('#cboCRMZ').combobox('setText',arrPat[13].split(CHR_1)[1]);
			
			$('#txtJTDH').val(arrPat[12]); 
			$('#txtGZDW').val(arrPat[21]);                                            //工作单位
			$('#cboCRWH').combobox('setValue',arrPat[15].split(CHR_1)[0]);             //文化
			$('#cboCRWH').combobox('setText',arrPat[15].split(CHR_1)[1]);  
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
			
			$('#cboCRZDLX').combobox('setValue',arrTNB[1].split(CHR_1)[0]);       //糖尿病类型
			$('#cboCRZDLX').combobox('setText',arrTNB[1].split(CHR_1)[1]);
			$('#cboCRZD').lookup('setText',arrTNB[2].split(CHR_1)[1]);            //诊断
			obj.ZDID = arrTNB[2].split(CHR_1)[0];
			$('#txtCRZDICD').val(arrTNB[3]);
			for (var len=0; len < arrTNB[4].split(',').length;len++) {            //并发症
				var valueCode = arrTNB[4].split(',')[len];
				$('#cbgCRBFZ'+valueCode).checkbox('setValue', (valueCode!=''? true : false));              
			}
			for (var len=0; len < arrTNB[5].split(',').length;len++) {  
				var valueCode = arrTNB[5].split(',')[len];
				$('#cbgCRWHYS'+valueCode).checkbox('setValue',(valueCode!=''? true : false));             
			}
			$('#txtCRTZ').val(arrTNB[6]);                                          //体重
			$('#txtCRSG').val(arrTNB[7]);     
			for (var len=0; len < arrTNB[8].split(',').length;len++) {             //家族史
				var valueCode = arrTNB[8].split(',')[len];
				$('#cbgCRJZS'+valueCode).checkbox('setValue',(valueCode!=''? true : false));
			}
			$('#txtCRRS').val(arrTNB[9]);
			$('#txtCRZDDate').datebox('setValue',arrTNB[10]);     //诊断日期
			$('#txtCRSWRQ').datebox('setValue',arrTNB[11]);  
			$('#cboCRSWYY').combobox('setValue',arrTNB[12].split(CHR_1)[0]); //死亡原因
			$('#cboCRSWYY').combobox('setText',arrTNB[12].split(CHR_1)[1]);
			$('#txtCRJTSWYY').val(arrTNB[13]);
			$('#txtCRSYICD').val(arrTNB[14]);
			$('#cboCRSWZD').lookup('setText',arrTNB[15].split(CHR_1)[1]);   //死亡诊断
			obj.SWZD = arrTNB[15].split(CHR_1)[0];
			for (var len=0; len < arrTNB[16].split(',').length;len++) {  
				var valueCode = arrTNB[16].split(',')[len];
				$('#cbgCRLCBX'+valueCode).checkbox('setValue',(valueCode!=''? true : false));            
			}                      
			$('#txtCRQTLCBX').val(arrTNB[17]);
			$('#cboCRZGZDDW').combobox('setValue',arrTNB[18].split(CHR_1)[0]);
			$('#cboCRZGZDDW').combobox('setText',arrTNB[18].split(CHR_1)[1]);
			$('#txtCRZYJCQK1').val(arrTNB[19]);
			$('#txtCRZYJCQK2').val(arrTNB[20]);
			$('#txtCRZYJCQK3').val(arrTNB[21]);
			$('#txtCRZYJCQK4').val(arrTNB[22]);
			$('#txtCRZYJCQK5').val(arrTNB[23]);
			$('#txtCRZYJCQK6').val(arrTNB[24]);
			$('#txtCRZYJCQK7').val(arrTNB[25]);
			$('#txtCRZYJCQK8').val(arrTNB[26]);
			$('#txtCRZYJCQK9').val(arrTNB[27]);
			
			$('#txtCRReportOrgan').val(arrRep[6]);
			$('#cboCRReportLoc').combobox('setValue',arrRep[3]);
			$('#cboCRReportLoc').combobox('setText',arrRep[4]);
			$('#txtCRReportUser').val(arrRep[5]);
			$('#txtCRReportDate').datebox('setValue',arrRep[7]);
			
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
		InputStr=InputStr+"^"+"TNB";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3作废
		InputStr=InputStr+"^"+$.trim($('#cboCRReportLoc').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCRReportUser').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRReportOrgan').val());
		InputStr=InputStr+"^"+$('#txtCRReportDate').datebox('getValue');
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		return InputStr;
	}
	
	obj.GetTNBData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+$.trim($('#txtCRKPBH').val());                  //编号
		InputStr=InputStr+"^"+$.trim($('#cboCRZDLX').combobox('getValue'));   //糖尿病类型
		InputStr=InputStr+"^"+obj.ZDID;        //诊断 存ID
		var cboCRZD = $.trim($('#cboCRZD').lookup('getText')); 
		InputStr=InputStr+"^"+$.trim($('#txtCRZDICD').val());
		InputStr=InputStr+"^"+Common_CheckboxValue('cbgCRBFZ');
		InputStr=InputStr+"^"+Common_CheckboxValue('cbgCRWHYS');
		InputStr=InputStr+"^"+$.trim($('#txtCRTZ').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRSG').val());
		InputStr=InputStr+"^"+Common_CheckboxValue('cbgCRJZS');           //10
		InputStr=InputStr+"^"+$.trim($('#txtCRRS').val());
		
		InputStr=InputStr+"^"+$('#txtCRZDDate').datebox('getValue');
		InputStr=InputStr+"^"+$.trim($('#cboCRSWYY').combobox('getValue'));
		InputStr=InputStr+"^"+$('#txtCRSWRQ').datebox('getValue');
		InputStr=InputStr+"^"+$.trim($('#txtCRSYICD').val());                          //15
		InputStr=InputStr+"^"+$.trim($('#txtCRJTSWYY').val());
		InputStr=InputStr+"^"+obj.SWZD;
		InputStr=InputStr+"^"+Common_CheckboxValue('cbgCRLCBX');
		InputStr=InputStr+"^"+$.trim($('#txtCRQTLCBX').val());
		InputStr=InputStr+"^"+$.trim($('#cboCRZGZDDW').combobox('getValue'));               //20 最高诊断单位
		InputStr=InputStr+"^"+$.trim($('#txtCRZYJCQK1').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRZYJCQK2').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRZYJCQK3').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRZYJCQK4').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRZYJCQK5').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRZYJCQK6').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRZYJCQK7').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRZYJCQK8').val());
		InputStr=InputStr+"^"+$.trim($('#txtCRZYJCQK9').val());		
		return InputStr;	
	}
	
	obj.GetPatData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+$.trim($('#txtPatientNo').val());            //3
		InputStr=InputStr+"^"+$.trim($('#txtPatName').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatCardNo').val()); //5
		InputStr=InputStr+"^"+$.trim($('#txtPatSex').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatAge').val());
		InputStr=InputStr+"^"+$.trim($('#cboPatAgeDW').combobox('getValue')); 
		InputStr=InputStr+"^"+$('#txtBirthDay').datebox('getValue');
		InputStr=InputStr+"^"+$.trim($('#cboCRZY').combobox('getValue'));   //职业10
		InputStr=InputStr+"^"+$.trim($('#cboCRMZ').combobox('getValue'));  //民族
		InputStr=InputStr+"^"+$.trim($('#cboCRGZ').combobox('getValue'));  //工种
		InputStr=InputStr+"^"+$.trim($('#txtJTDH').val());
		InputStr=InputStr+"^"+$.trim($('#txtGZDW').val());
		InputStr=InputStr+"^"+$.trim($('#cboProvince1').combobox('getValue'));//15
		InputStr=InputStr+"^"+$.trim($('#cboCity1').combobox('getValue')); 
		InputStr=InputStr+"^"+$.trim($('#cboCounty1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboVillage1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCUN1').val());   
		InputStr=InputStr+"^"+$.trim($('#txtAdress1').val());//20
		InputStr=InputStr+"^"+$.trim($('#cboProvince2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCity2').combobox('getValue')); 
		InputStr=InputStr+"^"+$.trim($('#cboCounty2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboVillage2').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCUN2').val());  //25
		InputStr=InputStr+"^"+$.trim($('#txtAdress2').val());
		InputStr=InputStr+"^"+$.trim($('#cboCRWH').combobox('getValue'));    //文化
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
	//保存
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var TNBData=obj.GetTNBData();
		var PatData=obj.GetPatData();
		var ExtraData=obj.GetExtraData();
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:TNBData,
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
	//作废
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
	//审核
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
			//var flg=ExportDataToExcel("","","糖尿病报告卡("+$.trim($('#txtPatName').val())+")",cArguments);
			var fileName="DHCMA_CD_PrintReportTNB.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
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
			$.messager.alert("错误","打印打印失败!"+ret, 'error');
			return;
		}else{
			//var cArguments=obj.ReportID;
			//var flg=PrintDataToExcel("","","糖尿病报告卡("+$.trim($('#txtPatName').val())+")",cArguments);
			var fileName="{DHCMA_CD_PrintReportTNB.raq(aReportID="+obj.ReportID+")}";
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
		if ($.trim($('#txtPatientNo').val()) == "") {
			errStr += "登记号不允许为空!<br>";		//登记号
		}

		if ($.trim($('#txtPatName').val()) == "") {
			errStr += "姓名不允许为空!<br>";		//病人姓名
		}
		if ($.trim($('#txtPatSex').val()) == "") {
			errStr += "性别不允许为空!<br>";		//性别
		}
		if ($.trim($('#txtPatAge').val()) == "") {
			errStr += "年龄不允许为空!<br>";		//年龄
		}
		if ($('#txtBirthDay').datebox('getValue') == "") {
			errStr += "出生日期不允许为空!<br>";		//生日
		}
		if ($.trim($('#cboCRMZ').combobox('getValue')) == "") {
			errStr += "请选择民族!<br>";		//民族
		}
		if ($.trim($('#cboCRZY').combobox('getValue')) == "") {
			errStr += "请选择职业!<br>";		//职业
		}
		if ($.trim($('#cboCRGZ').combobox('getValue')) == "") {
			errStr += "请选择具体工种!<br>";		//具体工种
		}
		if ($.trim($('#txtJTDH').val()) == "") {
			errStr += "电话不允许为空!<br>";		//电话
		}
		if ($.trim($('#cboCRWH').combobox('getValue')) == "") {
			errStr += "请选择文化不允许为空!<br>";		//文化
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			errStr += "身份证号!<br>";		//身份证号
		}
		// 身份证格式验证	
		if ($.trim($('#txtPatCardNo').val()) != ""){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test($.trim($('#txtPatCardNo').val())))) {
				errStr += '输入的身份证号格式不符合规定！请重新输入!<br>';
			}
		}
		if ($.trim($('#cboProvince1').combobox('getValue')) == "") {
			errStr += "请选择目前居住地址省!<br>";		//省
		}
		if ($.trim($('#cboCity1').combobox('getValue')) == "") {
			errStr += "请选择目前居住地址市!<br>";		//市
		}
		if ($.trim($('#cboCounty1').combobox('getValue')) == "") {
			errStr += "请选择目前居住地址县!<br>";		//县
		}
		if ($.trim($('#cboVillage1').combobox('getValue')) == "") {
			errStr += "请选择目前居住地址街道!<br>";		//街道
		}
		if ($.trim($('#txtCUN1').val()) == "") {
			errStr += "目前居住地址村不允许为空!<br>";		//村
		}  
		if ($.trim($('#txtAdress1').val()) == "") {
			errStr += "目前居住详细地址不允许为空!<br>";		//详细地址		
		}  
		if ($.trim($('#cboProvince2').combobox('getValue')) == "") {
			errStr += "请选择常住户口地址省!<br>";		//省
		}
		if ($.trim($('#cboCity2').combobox('getValue')) == "") {
			errStr += "请选择常住户口地址市!<br>";		//市
		}
		if ($.trim($('#cboCounty2').combobox('getValue')) == "") {
			errStr += "请选择常住户口地址县!<br>";		//县
		}
		if ($.trim($('#cboVillage2').combobox('getValue')) == "") {
			errStr += "请选择常住户口地址街道!<br>";		//街道
		}
		if ($.trim($('#txtCUN2').val()) == "") {
			errStr += "常住户口地址村不允许为空!<br>";		//村
		}  
		if ($.trim($('#txtAdress2').val()) == "") {
			errStr += "常住户口详细地址不允许为空!<br>";		//详细地址		
		}  
		
		if ($.trim($('#txtCRZDICD').val()) == "") {
			errStr += "ICD编码不允许为空!<br>";		//ICD编码
		}  
		if ($.trim($('#cboCRZDLX').combobox('getValue')) == "") {
			errStr += "请选择糖尿病类型!<br>";		//糖尿病类型
		}
		if ($.trim($('#cboCRZGZDDW').combobox('getValue')) == "") {
			errStr += "请选择最高诊断单位!<br>";		//最高诊断单位
		}
		if (($.trim($('#cboCRZD').lookup('getText')) == "")||(obj.ZDID=="")) {
			errStr += "诊断允许为空，请选择诊断!<br>";		//诊断
		}
		if (Common_CheckboxValue('cbgCRBFZ') == "") {
			errStr += "并发症不允许为空!<br>";		//并发症
		}
		if (Common_CheckboxValue('cbgCRLCBX') == "") {
			errStr += "临床表现不允许为空!<br>";		//临床表现
		}

		if ($.trim($('#txtCRReportOrgan').val()) == "") {
			errStr += "报卡单位不允许为空!<br>";		//报卡单位
		}  
		if ($('#txtCRZDDate').datebox('getValue') == "") {
			errStr += "诊断日期不允许为空!<br>";		//诊断日期
		}	
		var NowDate = Common_GetDate(new Date());
		var txtCRZDDate = $('#txtCRZDDate').datebox('getValue');
		var txtCRSWRQ = $('#txtCRSWRQ').datebox('getValue');
	
		if (Common_CompareDate(txtCRZDDate,NowDate)>0) {
			errStr += '诊断日期不允许大于当前日期!<br>';			
		}
		if (Common_CompareDate(txtCRZDDate,txtCRSWRQ)>0) { 
			errStr += '死亡日期不能小于诊断日期!<br>';
		}
		if (Common_CompareDate(txtCRSWRQ,NowDate)>0) { 
			errStr += '死亡日期不允许大于当前日期!<br>';
		}		
		
		if(errStr != "") {
			$.messager.alert("提示", errStr, 'info');
			return false;
		}
		return true;
	}

}


