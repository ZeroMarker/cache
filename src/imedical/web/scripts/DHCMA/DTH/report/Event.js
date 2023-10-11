function InitReportWinEvent(obj) {
	
	obj.LoadEvent = function(){
		if (ReportID!=""){
			//已填报报告页面数据加载
			obj.InitRepByReportID();
		} else {
			//新建报告页面数据加载
			obj.InitRepByEpisodeID();
		}
		//控制是否允许修改病人基本信息 0：不允许  1： 允许
		if (obj.IsUpdatePatientInfo == 0) {  //不允许修改
			obj.UpdatePatientInfo();
		}else {
			$('#txtPatName').bind('change', function (e) {  //鼠标移动之后事件
				$('#txtName').val($('#txtPatName').val());
			});
			$('#txtSex').bind('change', function (e) {  //鼠标移动之后事件
				var PatSex = $('#txtSex').val();
				if (PatSex.indexOf("女") > -1) {
					$('#cboPregnancies').combobox('enable');
					$('#chkRepMaternal').checkbox('enable');
				}else {
					$('#cboPregnancies').combobox('disable','disable');
					$('#chkRepMaternal').checkbox('disable');
					$('#chkRepMaternal').checkbox('setValue','');
					$('#MaternalInfoDiv').css('display','none');
				}
				obj.GetChRepSex(PatSex);
			});
			
			$('#txtAge').bind('change', function (e) { //鼠标移动之后事件
				var PatAge = $('#txtAge').val();
				if ((PatAge.indexOf('岁')<0)&&(PatAge.indexOf('月')<0)&&(PatAge.indexOf('天')<0)&&(PatAge.indexOf('小时')<0)) {
					$.messager.alert("提示","请填写正确的年龄单位，如“岁”、“月”、“天”、“小时”!",'info');
					return;
				} else {
					$('#txtDeathAgeYear').val('');
					$('#txtDeathAgeMonth').val('');
					$('#txtDeathAgeDay').val('');
					$('#txtDeathAgeHour').val('');
					obj.GetChRepAge(PatAge);
				}
			});
		}
		//死亡编号手工输入还是自动生成 0 手工 1 自动
		if (DeathNoType==1){
			$('#txtDeathNo').attr('disabled','disabled'); 
		} 
		// 密级
		$('#txtPatLevel').val(obj.PatEncryptLevel.split('^')[1]);
		$('#txtEncryptLevel').val(obj.PatEncryptLevel.split('^')[3]);
		
		obj.InitRepPowerByStatus();
		 // 按钮监听事件
		obj.RelationToEvents (); 
		/// 根本死因根据dcba联动   add by chenr 2022-08-31
		$("#cboDReason,#cboCReason,#cboBReason,#cboAReason").bind('change', function (e) {
			setTimeout(function(){
					var TAReason = $.trim($('#cboAReason').lookup('getText'));
					var TBReason = $.trim($('#cboBReason').lookup('getText'));
					var TCReason = $.trim($('#cboCReason').lookup('getText'));
					var TDReason = $.trim($('#cboDReason').lookup('getText'));
					var TAReasonICD = $.trim($('#txtAReasonICD').val());
					var TBReasonICD = $.trim($('#txtBReasonICD').val()); 
					var TCReasonICD = $.trim($('#txtCReasonICD').val()); 
					var TDReasonICD = $.trim($('#txtDReasonICD').val()); 
					if(TDReason!="") {
						$('#cboBaseReason').lookup('setText',TDReason);
						$('#txtBaseReasonICD').val(TDReasonICD);
					}else if(TCReason!="") {
						$('#cboBaseReason').lookup('setText',TCReason);
						$('#txtBaseReasonICD').val(TCReasonICD);
					}else if(TBReason!="") {
						$('#cboBaseReason').lookup('setText',TBReason);
						$('#txtBaseReasonICD').val(TBReasonICD);
					}else if(TAReason!="") {
						$('#cboBaseReason').lookup('setText',TAReason);
						$('#txtBaseReasonICD').val(TAReasonICD);
					}
	            },500);
		})
	}	
	
    //新建报告页面初始化
	obj.InitRepByEpisodeID = function(){
		$('#chkRepMaternal').checkbox('disable');
		//判断是否新生儿
		if(obj.IsNewBorn == 1) {
			$('#chkNewBorn').checkbox('setValue',true);
		}
		
		var separate = CHR_1;
		var strPatInfo = $m({                  
			ClassName:"DHCMed.Base.Patient",
			MethodName:"GetStringById",
			aSeparete:'^',
			aEpisodeID:EpisodeID
		},false);
		var arrPatInfo = strPatInfo.split("^");
		if(arrPatInfo.length>0){
			$('#txtRegNo').val(arrPatInfo[1]);  //登记号
			if (obj.MrNo){
				$('#txtMrNo').val(obj.MrNo);
			} else {
				$('#txtMrNo').val(arrPatInfo[22]);  //病案号
			}
			var PatName = arrPatInfo[2];
			if (SSHospCode=='11-BJZYY') {
				//北京中医院不自动加载姓名，需要医生主动录入，上报时做一致性检查
			} else {
				$('#txtPatName').val(PatName);     //姓名
			}
			//判断是否无名氏
			if ((PatName.indexOf("无名") > -1)||(PatName.indexOf("未知") > -1)) {
				$('#chkJohnDoe').checkbox('setValue',true);
			}
			
			var Sex = arrPatInfo[3];
			$('#txtSex').val(Sex);   //性别
			if (Sex.indexOf("女") > -1) {
				$('#cboPregnancies').combobox('enable');
			}
			
			if (obj.CardInfo){            // 获取病人的有效证件号        
				var arrCardInfo = obj.CardInfo.split("^");
				var CardType = arrCardInfo[1];                       //证件类型ID
				var CardTypeDesc = arrCardInfo[2];                   //证件类型名称
				$('#cboCardType').combobox('setValue',CardType);     //证件类型ID
				$('#cboCardType').combobox('setText',CardTypeDesc);  //证件类型名称
				
				if (SSHospCode!='11-BJZYY') {
					$('#txtIdentify').val(arrCardInfo[0]);  //身份证号
				}           
			}
		
			$('#txtBirthday').datebox('setValue',arrPatInfo[4]);  //生日
			//根据死亡日期、时间计算年龄
			if (arrPatInfo[25]!="") {
				var Age = obj.GetPatAge(arrPatInfo[25],arrPatInfo[26]);		
			} else {
				var Age = obj.GetPatAge('','');
			}
			$('#txtAge').val(Age);
			
			if (Age.indexOf('岁')>-1) {  
				//var CurrAge = Age.replace("岁", "");
				var arrCurrAge = Age.split("岁"); 
				var CurrAge = arrCurrAge[0]; 
				if (CurrAge > 5) { 
					if (Sex=='女') {  //非5岁以下儿童、女性
						$('#chkRepMaternal').checkbox('enable');
					}
				}
			}
		    if (obj.IsChild == '1') {                                //5岁以下儿童副卡
				$('#ChindInfoDiv').removeAttr('style');
				$.parser.parse('#ChindInfoDiv'); 
				obj.LoadChildInfo();
				$('#txtName').val($('#txtPatName').val());
				obj.GetChRepSex(Sex);
				obj.GetChRepAge(Age);
			} 
			if (ServerObj.DicInfo) {// 字典赋值
			    var MaritalInfo = ServerObj.DicInfo.split("^")[4];
			    var EducationInfo = ServerObj.DicInfo.split("^")[5];
			    var OccupationInfo = ServerObj.DicInfo.split("^")[3];
			     //婚姻情况
				$('#cboMarital').combobox('setValue',((MaritalInfo.split(",")[0]) ? MaritalInfo.split(",")[0]:'')); 
				$('#cboMarital').combobox('setText',((MaritalInfo.split(",")[0]) ? MaritalInfo.split(",")[2]:'')); 				 
				//教育程度
				$('#cboEducation').combobox('setValue',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[0]:'')); 
				$('#cboEducation').combobox('setText',((EducationInfo.split(",")[0]) ? EducationInfo.split(",")[2]:'')); 
				//职业
				$('#cboOccupation').combobox('setValue',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[0]:'')); 
				$('#cboOccupation').combobox('setText',((OccupationInfo.split(",")[0]) ? OccupationInfo.split(",")[2]:'')); 
			}		
			var Marital = arrPatInfo[11];
			var Education = arrPatInfo[14];
			if ((arrPatInfo[6]>0)||(arrPatInfo[7]>0)||(arrPatInfo[5]<8)) { 
			   //婚姻情况
				$('#cboMarital').combobox('setValue',obj.MaritalInfo.split("^")[0]);
				$('#cboMarital').combobox('setText',obj.MaritalInfo.split("^")[2]);				 
				//教育程度
				$('#cboEducation').combobox('setValue',obj.EducationInfo.split("^")[0]);
				$('#cboEducation').combobox('setText',obj.EducationInfo.split("^")[2]);
			}
			
			$('#txtCountry').val(arrPatInfo[21]);                      //国家
			$('#txtNation').val(arrPatInfo[12]);                       //民族
			$('#txtCompany').val(arrPatInfo[15]);                      //公司
			$('#txtRegAddress').val(arrPatInfo[20]);                   //户籍地址
			$('#txtCurrAddress').val(arrPatInfo[20]);                  //生前地址
			$('#txtFamName').val(arrPatInfo[18]);                      //联系人姓名
			// 获取关系对应的ID
			var RelationID = $m({                  
				ClassName:"DHCMed.SSService.DictionarySrv",
				MethodName:"GetIDByTypeDesc",
				argHosID:"",
				argTypeCode:"DTHFamilyRelation",
				argDesc:arrPatInfo[16]
			},false);
			$('#cboFamRelation').combobox('setValue',RelationID);  //关系
			$('#cboFamRelation').combobox('setText',arrPatInfo[16]);  //关系
			$('#txtFamTel').val(arrPatInfo[19]);                       //电话
			$('#txtDeathDate').datebox('setValue',arrPatInfo[25]);
			$('#txtDeathTime').timespinner('setValue',arrPatInfo[26]);
			
			var ret = tkMakeServerCall("DHCMed.SSService.AreaDicSrv","GetAddress",arrPatInfo[20])
		    if (ret!=""){
			    var Addressret=ret.split("^");
			    $('#cboCurrProvince').combobox('setValue',Addressret[0]);
			    $('#cboCurrProvince').combobox('setText',Addressret[1]);
			    $('#cboCurrCity').combobox('setValue',Addressret[2]);
			    $('#cboCurrCity').combobox('setText',Addressret[3]);
			    $('#cboCurrCounty').combobox('setValue',Addressret[4]);
			    $('#cboCurrCounty').combobox('setText',Addressret[5]);
			    $('#cboCurrVillage').combobox('setValue',Addressret[6]);
			    $('#cboCurrVillage').combobox('setText',Addressret[7]);
			    $('#txtCurrRoad').val(Addressret[8])
		    }
		    var Regret = tkMakeServerCall("DHCMed.SSService.AreaDicSrv","GetAddress",ServerObj.RegAdress)
		    if (Regret!=""){
			    var RegAddressret=Regret.split("^");
			    $('#cboRegProvince').combobox('setValue',RegAddressret[0]);
			    $('#cboRegProvince').combobox('setText',RegAddressret[1]);
			    $('#cboRegCity').combobox('setValue',RegAddressret[2]);
			    $('#cboRegCity').combobox('setText',RegAddressret[3]);
			    $('#cboRegCounty').combobox('setValue',RegAddressret[4]);
			    $('#cboRegCounty').combobox('setText',RegAddressret[5]);
			    $('#cboRegVillage').combobox('setValue',RegAddressret[6]);
			    $('#cboRegVillage').combobox('setText',RegAddressret[7]);
			    $('#txtRegRoad').val(RegAddressret[8])
		    }
			//诊断单位 默认显示三级医院
			if (obj.DiagnoseUnit) {			
				$('#cboDiagnoseUnit').combobox('setValue',obj.DiagnoseUnit.split("^")[0]);
				$('#cboDiagnoseUnit').combobox('setText',obj.DiagnoseUnit.split("^")[2]);
			}
		}	
	}
	
	//重新加载病人基本信息
	obj.UpdatePatientInfo = function(){
		$('#chkNewBorn').checkbox('disable');
		$('#chkJohnDoe').checkbox('disable');
		$('#txtRegNo').attr('disabled','disabled');
		$('#txtMrNo').attr('disabled','disabled');
		
		if (SSHospCode=='11-BJZYY') {
			//北京中医院特殊情况处理
		} else {
			$('#txtPatName').attr('disabled','disabled');
			// 1:不可修改病人基本信息 证件号不为空时 证件号不可编辑
			if ($('#txtIdentify').val()!="") {
				$('#cboCardType').combobox('disable');
				$('#txtIdentify').attr('disabled','disabled');
			}
		}
		
		$('#txtSex').attr('disabled','disabled');
		$('#txtBirthday').datebox('disable');
		$('#txtAge').attr('disabled','disabled');
		$('#txtCountry').attr('disabled','disabled');
		//$('#txtNation').attr('disabled','disabled');  update 20200707  取消民族不可编辑
	}
	
	//死亡证页面初始化
	obj.InitRepByReportID = function(){
		$('#chkJohnDoe').checkbox('disable');
		$('#chkNewBorn').checkbox('disable');
		$('#chkRepMaternal').checkbox('disable');
		$('#txtSex').attr('disabled','disabled');  //已经保存的报告不允许修改性别
		var separate ="^";
		var retValue = $m({                  
			ClassName:"DHCMed.DTH.Report",
			MethodName:"GetStringById",
			id:ReportID,
			separate:"^"
		},false);
		var arrValue = retValue.split("^");
		$('#txtRegNo').val(arrValue[1]);
		$('#txtMrNo').val(arrValue[2]);
		$('#txtPatName').val(arrValue[3]);
		$('#txtSex').val(arrValue[4]);
		//孕产周期（妊娠期或终止妊娠42天内 是/否）
		if (arrValue[4].indexOf("女") > -1) {
			$('#cboPregnancies').combobox('enable');
			$('#cboPregnancies').combobox('setValue',arrValue[15].split(CHR_1)[0]);
			$('#cboPregnancies').combobox('setText',arrValue[15].split(CHR_1)[1]);
		}
		$('#txtIdentify').val(arrValue[5]);
		$('#txtBirthday').datebox('setValue',arrValue[6]);
		$('#txtAge').val(arrValue[7]);
		$('#txtCountry').val(arrValue[8]);
		$('#txtNation').val(arrValue[9]);
		$('#cboMarital').combobox('setValue',arrValue[10].split(CHR_1)[0]);
		$('#cboMarital').combobox('setText',arrValue[10].split(CHR_1)[1]);
		$('#cboEducation').combobox('setValue',arrValue[11].split(CHR_1)[0]);
		$('#cboEducation').combobox('setText',arrValue[11].split(CHR_1)[1]);
		$('#cboOccupation').combobox('setValue',arrValue[12].split(CHR_1)[0]);
		$('#cboOccupation').combobox('setText',arrValue[12].split(CHR_1)[1]);
		$('#txtCompany').val(arrValue[14]);
		$('#txtRegAddress').val(arrValue[16]);
		$('#txtCurrAddress').val(arrValue[17]);
		
	    $('#cboCurrProvince').combobox('setValue',arrValue[65].split(CHR_1)[0]);
		$('#cboCurrProvince').combobox('setText',((arrValue[65].indexOf(CHR_1)>-1) ? arrValue[65].split(CHR_1)[1] : ''));
		$('#cboCurrCity').combobox('setValue',arrValue[66].split(CHR_1)[0]);
		$('#cboCurrCity').combobox('setText',((arrValue[66].indexOf(CHR_1)>-1) ? arrValue[66].split(CHR_1)[1] : ''));
		$('#cboCurrCounty').combobox('setValue',arrValue[67].split(CHR_1)[0]);
		$('#cboCurrCounty').combobox('setText',((arrValue[67].indexOf(CHR_1)>-1) ? arrValue[67].split(CHR_1)[1] : ''));
		$('#cboCurrVillage').combobox('setValue',arrValue[77].split(CHR_1)[0]);
		$('#cboCurrVillage').combobox('setText',((arrValue[77].indexOf(CHR_1)>-1) ? arrValue[77].split(CHR_1)[1] : ''));
		
		$('#cboRegProvince').combobox('setValue',arrValue[78].split(CHR_1)[0]);
		$('#cboRegProvince').combobox('setText',((arrValue[78].indexOf(CHR_1)>-1) ? arrValue[78].split(CHR_1)[1] : ''));
		$('#cboRegCity').combobox('setValue',arrValue[79].split(CHR_1)[0]);
		$('#cboRegCity').combobox('setText',((arrValue[79].indexOf(CHR_1)>-1) ? arrValue[79].split(CHR_1)[1] : ''));
		$('#cboRegCounty').combobox('setValue',arrValue[80].split(CHR_1)[0]);
		$('#cboRegCounty').combobox('setText',((arrValue[80].indexOf(CHR_1)>-1) ? arrValue[80].split(CHR_1)[1] : ''));
		$('#cboRegVillage').combobox('setValue',arrValue[81].split(CHR_1)[0]);
		$('#cboRegVillage').combobox('setText',((arrValue[81].indexOf(CHR_1)>-1) ? arrValue[81].split(CHR_1)[1] : ''));
		
		$('#txtFamName').val(arrValue[18]);
		$('#cboFamRelation').combobox('setValue',arrValue[19].split(CHR_1)[0]);
		$('#cboFamRelation').combobox('setText',arrValue[19].split(CHR_1)[1]);
		$('#txtFamTel').val(arrValue[20]);
		$('#txtFamAddress').val(arrValue[21]);
	
		if(arrValue[22]!=""){
			var DeathNoArray = arrValue[22].split("-");
			var ShortDeathNo = DeathNoArray[1]+DeathNoArray[2];
			if(DeathNoArray[1]!=undefined){
				$('#txtDeathNo').val(ShortDeathNo);
			} else {
				$('#txtDeathNo').val(arrValue[22]);
			}
		}
		
		$('#txtDeathDate').datebox('setValue',arrValue[23]);
		$('#txtDeathTime').timespinner('setValue',arrValue[24]);
		$('#cboDeathPlace').combobox('setValue',arrValue[25].split(CHR_1)[0]);
		$('#cboDeathPlace').combobox('setText',arrValue[25].split(CHR_1)[1]);
		
		if ((SSHospCode=='11-BJZYY')||(SSHospCode=='11-AZ')) { //北京中医院、北京安贞医院 特殊情况处理
			//根本死因
			if (arrValue[26]!=""){ 
				$('#cboBaseReason').lookup('setText',arrValue[26]);
			}
			//根本死因ICD
			if (arrValue[27]!=""){
				$('#txtBaseReasonICD').val(arrValue[27]);
			}
			//损伤中毒
			if (arrValue[28]!=""){
				$('#cboDamage').lookup('setText',arrValue[28]);
			}
			//损伤中毒ICD
			if (arrValue[29]!=""){
				$('#txtDamageICD').val(arrValue[29]);
			}
		} else {
			//根本死因  如果根本死因为空则以dcba顺序取诊断
			if (arrValue[26]==""){  
				if(arrValue[36]!="") {
					$('#cboBaseReason').lookup('setText',arrValue[36]);
				}else if(arrValue[34]!="") {
					$('#cboBaseReason').lookup('setText',arrValue[34]);
				}else if(arrValue[32]!="") {
					$('#cboBaseReason').lookup('setText',arrValue[32]);
				}else if(arrValue[30]!="") {
					$('#cboBaseReason').lookup('setText',arrValue[30]);
				}
			} else {
				$('#cboBaseReason').lookup('setText',arrValue[26]);
			}
			
			//根本死因ICD
			if (arrValue[27]==""){
				if(arrValue[36]!="") {
					$('#txtBaseReasonICD').val(arrValue[57]);
				}else if(arrValue[34]!="") {
					$('#txtBaseReasonICD').val(arrValue[56]);
				}else if(arrValue[32]!="") {
					$('#txtBaseReasonICD').val(arrValue[55]);
				}else if(arrValue[30]!="") {
					$('#txtBaseReasonICD').val(arrValue[54]);
				}
			} else {
				$('#txtBaseReasonICD').val(arrValue[27]);
			}
			
			//损伤中毒
			if (arrValue[28]==""){
				$('#cboDamage').lookup('setText',arrValue[53]);
			} else {
				$('#cboDamage').lookup('setText',arrValue[28]);
			}
			//损伤中毒ICD
			if (arrValue[29]==""){
				$('#txtDamageICD').val(arrValue[58]);
			} else {
				$('#txtDamageICD').val(arrValue[29]);
			}
		}
		
		$('#cboAReason').lookup('setText',arrValue[30]);
		$('#txtAInterval').val(arrValue[31]);
		$('#cboBReason').lookup('setText',arrValue[32]);
		$('#txtBInterval').val(arrValue[33]);
		$('#cboCReason').lookup('setText',arrValue[34]);
		$('#txtCInterval').val(arrValue[35]);
		$('#cboDReason').lookup('setText',arrValue[36]);
		$('#txtDInterval').val(arrValue[37]);
		$('#cboOtherDiagnose').lookup('setText',arrValue[38]);
		$('#txtOtherDiagnoseInterval').val(arrValue[89]);
		$('#cboDiagnoseUnit').combobox('setValue',arrValue[39].split(CHR_1)[0]);
		$('#cboDiagnoseUnit').combobox('setText',arrValue[39].split(CHR_1)[1]);
		$('#cboDiagnoseBasis').combobox('setValue',arrValue[40].split(CHR_1)[0]);
		$('#cboDiagnoseBasis').combobox('setText',arrValue[40].split(CHR_1)[1]);
		
		$('#txtResume').val(arrValue[41]);
		var ExamMedical = arrValue[42].replace(/\s/g,"\n"); // 替换所有的空格为 换行字符"\n"
		$('#txtExamMedical').val(arrValue[42]);
		$('#txtExamName').val(arrValue[43]);
		$('#cboExamRelation').combobox('setValue',arrValue[44].split(CHR_1)[0]);
		$('#cboExamRelation').combobox('setText',arrValue[44].split(CHR_1)[1]);
		$('#txtExamTel').val(arrValue[45]);
		$('#txtExamDeathReason').val(arrValue[46]);
		$('#txtExamAddress').val(arrValue[47]);
		$('#txtExamUser').val(arrValue[48]);
		$('#txtExamDate').datebox('setValue',arrValue[49]);
		$('#cboDamageDiagnose').lookup('setText',arrValue[53]);
		
		$('#txtAReasonICD').val(arrValue[54]);
		$('#txtBReasonICD').val(arrValue[55]);
		$('#txtCReasonICD').val(arrValue[56]);
		$('#txtDReasonICD').val(arrValue[57]);
		$('#txtOtherDiagnoseICD').val(arrValue[86]);
		$('#txtDamageDiagnoseICD').val(arrValue[58]);
		$('#cboATime').combobox('setValue',arrValue[59].split(CHR_1)[0]);
		$('#cboBTime').combobox('setValue',arrValue[60].split(CHR_1)[0]);
		$('#cboCTime').combobox('setValue',arrValue[61].split(CHR_1)[0]);
		$('#cboDTime').combobox('setValue',arrValue[62].split(CHR_1)[0]);
		$('#cboATime').combobox('setText',arrValue[59].split(CHR_1)[1]);
		$('#cboBTime').combobox('setText',arrValue[60].split(CHR_1)[1]);
		$('#cboCTime').combobox('setText',arrValue[61].split(CHR_1)[1]);
		$('#cboDTime').combobox('setText',arrValue[62].split(CHR_1)[1]);
		$('#cboOtherDiagnoseTime').combobox('setValue',arrValue[90].split(CHR_1)[0]);
		$('#cboOtherDiagnoseTime').combobox('setText',arrValue[90].split(CHR_1)[1]);
		$('#cboCardType').combobox('setValue',arrValue[63].split(CHR_1)[0]);
		$('#cboCardType').combobox('setText',arrValue[63].split(CHR_1)[1]);
		$('#chkJohnDoe').checkbox('setValue',(arrValue[64]=='1'? true : false));
		$('#chkNewBorn').checkbox('setValue',(arrValue[91]=='1'? true : false));
	
		if (arrValue[72]!='') {
			$('#txtAFPReason').val('[' + arrValue[72] + ']' + arrValue[68]);
		} else {
			$('#txtAFPReason').val(arrValue[68]);
		}
		if (arrValue[73]!='') {
			$('#txtBFPReason').val('[' + arrValue[73] + ']' + arrValue[69]);
		} else {
			$('#txtBFPReason').val(arrValue[69]);
		}
		if (arrValue[74]!='') {
			$('#txtCFPReason').val('[' + arrValue[74] + ']' + arrValue[70]);
		} else {
			$('#txtCFPReason').val(arrValue[70]);
		}
		if (arrValue[75]!='') {
			$('#txtDFPReason').val('[' + arrValue[75] + ']' + arrValue[71]);
		} else {
			$('#txtDFPReason').val(arrValue[71]);
		}
		if (arrValue[87]!='') {
			$('#txtOtherDiagnoseFP').val('[' + arrValue[87] + ']' + arrValue[88]);
		} else {
			$('#txtOtherDiagnoseFP').val(arrValue[88]);
		}
		$('#txtRegRoad').val(arrValue[84]);
		$('#txtCurrRoad').val(arrValue[85]);
		$('#txtRegAddress').val($('#cboRegProvince').combobox('getText')+$('#cboRegCity').combobox('getText')+$('#cboRegCounty').combobox('getText')+$('#cboRegVillage').combobox('getText')+$('#txtRegRoad').val());
		$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText')+$('#txtCurrRoad').val());

		if (obj.IsChild == '1') {       //儿童
			$('#ChindInfoDiv').removeAttr('style');
			$.parser.parse('#ChindInfoDiv'); 
			obj.LoadChildInfo();
			obj.InitChRepByReportID();	
		}
	
		if (obj.MReportID > 0) {   //孕产妇
			$('#chkRepMaternal').checkbox('setValue',true);
			$('#MaternalInfoDiv').removeAttr('style');
			$.parser.parse('#MaternalInfoDiv'); 
			obj.LoadMaternalInfo();
			obj.InitMRepByReportID();
			obj.LoadMaternalEvent();
		}
		
	}
	
	//5岁以下儿童死亡证页面初始化
	obj.InitChRepByReportID = function(){
		var ret = $m({           //5岁以下儿童死亡证信息        
			ClassName:"DHCMed.DTHService.ReportChildSrv",
			MethodName:"GetReportString",
			aDthRepID:ReportID
		},false);
		var strSections = ret.split(CHR_1);
		var strFields = strSections[0].split("^");   
		
		// 是否补卡
		$('#chkIsReplenish').checkbox('setValue',(strFields[34]=='1'? true : false));
		// 姓名
		$('#txtName').val(strFields[4]);
		// 父亲姓名
		$('#txtFatherName').val(strFields[5]);
		// 母亲姓名
		$('#txtMotherName').val(strFields[6]);
		// 性别 1--男 2--女 3--性别不明
		var objDic = strFields[8].split(CHR_2);
		$('#cboSex').combobox('setValue',objDic[0]);
		$('#cboSex').combobox('setText',objDic[2]);
		// 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
		var objDic = strFields[10].split(CHR_2);
		$('#cboRegType').combobox('setValue', objDic[0]);
		$('#cboRegType').combobox('setText', objDic[2]);
		// 出生体重
		$('#txtWeight').val(strFields[11]);
		// 出生体重类别：1--测量 2--估计
		var objDic = strFields[12].split(CHR_2);
		$('#cboWeightType').combobox('setValue', objDic[0]);
		$('#cboWeightType').combobox('setText', objDic[2]);
		// 怀孕___周
		$('#txtPregnancyWeek').val(strFields[13]);
		// 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
		var objDic = strFields[14].split(CHR_2);
		$('#cboBirthdayPlace').combobox('setValue', objDic[0]);
		$('#cboBirthdayPlace').combobox('setText', objDic[2]);
		// 死亡年龄 年
		$('#txtDeathAgeYear').val(strFields[16]);
		// 死亡年龄 月
		$('#txtDeathAgeMonth').val(strFields[17]);
		// 死亡年龄 日
		$('#txtDeathAgeDay').val(strFields[18]);
		$('#txtDeathAgeHour').val(strFields[35]);
		// 死亡地点 1--医院 2--途中 3--家中
		var objDic = strFields[19].split(CHR_2);
		$('#cboDeathPosition').combobox('setValue', objDic[0]);
		$('#cboDeathPosition').combobox('setText', objDic[2]);
		// 死亡前治疗 1--住院 2--门诊 3--未治疗
		var objDic = strFields[20].split(CHR_2);
		$('#cboCareBeforeDeath').combobox('setValue', objDic[0]);
		$('#cboCareBeforeDeath').combobox('setText', objDic[2]);
		// 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
		var objDic = strFields[21].split(CHR_2);
		$('#cboDiagnoseLv').combobox('setValue', objDic[0]);
		$('#cboDiagnoseLv').combobox('setText', objDic[2]);
		// 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
		var objDic = strFields[22].split(CHR_2);
		$('#cboNotCareReason').combobox('setValue', objDic[0]);
		$('#cboNotCareReason').combobox('setText', objDic[2]);
		// 未治疗或未就医主要原因（需要注明原因）
		$('#txtNotCareReasonTxt').val(strFields[23]);
	  
		// 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
		var objDic = strFields[24].split(CHR_2);
		$('#cboChildDiagBasis').combobox('setValue', objDic[0]);
		$('#cboChildDiagBasis').combobox('setText', objDic[2]);
		// 分类编号 01-痢疾 02--败血症 03-麻疹 ...
		var objDic = strFields[25].split(CHR_2);
		$('#cboCategory').combobox('setValue', objDic[0]);
		$('#cboCategory').combobox('setText', objDic[2]);
		// ICD-10编码
		$('#txtICD10').val(strFields[26]);	
	}
	
	//初始孕产妇死亡登记副卡信息
	obj.InitMRepByReportID = function(){
		var ret = $m({           //初始孕产妇死亡登记副卡信息    
			ClassName:"DHCMed.DTHService.ReportMaternalSrv",
			MethodName:"GetReportString",
			aDthRepID:ReportID
		},false);
		var strFields = ret.split("^");		
		var objDic = strFields[6].split(CHR_2);
		$('#cboConProvince').combobox('setValue',objDic[0]);         // 常住址 省
		$('#cboConProvince').combobox('setText',((objDic.length>1) ? objDic[2] : ''));         // 常住址 省
	
		var objDic = strFields[7].split(CHR_2);
		$('#cboConCity').combobox('setValue',objDic[0]);             // 常住址 市
		$('#cboConCity').combobox('setText',((objDic.length>1) ? objDic[2] : ''));             // 常住址 市
		var objDic = strFields[8].split(CHR_2);
		$('#cboConCounty').combobox('setValue',objDic[0]);           // 常住址 县
		$('#cboConCounty').combobox('setText',((objDic.length>1) ? objDic[2] : ''));           // 常住址 县
		var objDic = strFields[9].split(CHR_2);
		$('#cboConVillage').combobox('setValue',objDic[0]);          // 常住址 乡
		$('#cboConVillage').combobox('setText',((objDic.length>1) ? objDic[2] : ''));          // 常住址 乡
		var objDic = strFields[11].split(CHR_2);
		$('#cboTempProvince').combobox('setValue',objDic[0]);        // 暂住址 省
		$('#cboTempProvince').combobox('setText',((objDic.length>1) ? objDic[2] : ''));        // 暂住址 省
		var objDic = strFields[12].split(CHR_2);
		$('#cboTempCity').combobox('setValue',objDic[0]);            // 暂住址 市
		$('#cboTempCity').combobox('setText',((objDic.length>1) ? objDic[2] : ''));            // 暂住址 市
		var objDic = strFields[13].split(CHR_2);
		$('#cboTempCounty').combobox('setValue',objDic[0]);          // 暂住址 县
		$('#cboTempCounty').combobox('setText',((objDic.length>1) ? objDic[2] : ''));          // 暂住址 县
		var objDic = strFields[14].split(CHR_2);
		$('#cboTempVillage').combobox('setValue',objDic[0]);          // 暂住址 乡
		$('#cboTempVillage').combobox('setText',((objDic.length>1) ? objDic[2] : ''));          // 暂住址 乡
	    
		var objDic = strFields[16].split(CHR_2);
		$('#cboMRegType').combobox('setValue', objDic[0]);           // 户口
		$('#cboMRegType').combobox('setText', objDic[2]);            // 户口
		var objDic = strFields[17].split(CHR_2);
		$('#cboIsPlan').combobox('setValue', objDic[0]);             // 计划内外
		$('#cboIsPlan').combobox('setText', objDic[2]);              // 计划内外		
		//$('#txtMAge').val(strFields[18]);                          // 年龄	
		var objDic = strFields[19].split(CHR_2);
		$('#cboNation').combobox('setValue', objDic[0]);             //民族	
		$('#cboNation').combobox('setText', objDic[2]);              //民族	
		var objDic = strFields[20].split(CHR_2);
		$('#cboMEducation').combobox('setValue', objDic[0]);         // 文化程度
		$('#cboMEducation').combobox('setText', objDic[2]);          // 文化程度
		var objDic = strFields[21].split(CHR_2);
		$('#cboFamilIncome').combobox('setValue', objDic[0]);   	 // 家庭年人均收入
		$('#cboFamilIncome').combobox('setText', objDic[2]);   	     // 家庭年人均收入
		var objDic = strFields[22].split(CHR_2);
		$('#cboConType').combobox('setValue', objDic[0]);            // 居住地区
		$('#cboConType').combobox('setText', objDic[2]);             // 居住地区
		$('#txtPreTimes').val(strFields[23]); 	                     // 孕次
		$('#txtProTimes').val(strFields[24]);                        // 产次
		$('#txtLaborTimes').val(strFields[25]);                      // 人工流产、引产次
		
		var objMenDic = strFields[51].split(CHR_2);
		if (objMenDic[0]) {
			Common_SetRadioValue("radLastMenList",objMenDic[0])		  // 末次月经类型
			//$HUI.radio('#radLastMenList'+objMenDic[0]).setValue(true);               // 末次月经类型
			$('#dtLastMenDate').datebox('disable');
		}
		if (strFields[26]) {
			$('#dtLastMenDate').datebox('setValue',strFields[26]);       // 末次月经
			$('input[type=radio][name=radLastMenList]').radio('disable');
		}
		var objDeliDic = strFields[52].split(CHR_2);
		if (objDeliDic[0])  {
			Common_SetRadioValue("radDeliDateList",objDeliDic[0])		  // 分娩时间分类
			//$HUI.radio('#radDeliDateList'+objDeliDic[0]).setValue(true);         // 分娩时间分类
			$('#dtDeliveryDate').datebox('disable');
			$('#txtDeliveryTime').numberspinner('disable');
		}
		if(strFields[27]) {
			$('#dtDeliveryDate').datebox('setValue',strFields[27]);      // 分娩日期
			$('input[type=radio][name=radDeliDateList]').radio('disable');
		}
		$('#txtDeliveryTime').val(strFields[28]);                     // 分娩时间
		$('#dtMDeathDate').datebox('setValue',strFields[29]);         // 死亡日期
		$('#txtMDeathTime').val(strFields[30]);                       // 死亡时间
	
		var objDic = strFields[31].split(CHR_2);
		Common_SetRadioValue("radDeliveryPosList",objDic[0])		  // 分娩地点
		//if (objDic[0]) $HUI.radio('#radDeliveryPosList'+objDic[0]).setValue(true);  // 分娩地点
		var objDic = strFields[32].split(CHR_2);
		Common_SetRadioValue("radDeathPosList",objDic[0])		  // 死亡地点
		//if (objDic[0]) $HUI.radio('#radDeathPosList'+objDic[0]).setValue(true);     // 死亡地点
		var objDic = strFields[33].split(CHR_2);
		Common_SetRadioValue("radDeliveryWayList",objDic[0])		  // 分娩方式
		//if (objDic[0]) $HUI.radio('#radDeliveryWayList'+objDic[0]).setValue(true);  //分娩方式
		var objDic = strFields[34].split(CHR_2);
		$('#cboIsNewWay').combobox('setValue', objDic[0]);           // 新法接生
		$('#cboIsNewWay').combobox('setText', objDic[2]);            // 新法接生
		var objDic = strFields[35].split(CHR_2);                     
		$('#cboDeliveryer').combobox('setValue', objDic[0]);         //接生者
		$('#cboDeliveryer').combobox('setText', objDic[2]);          //接生者
		var objDic = strFields[36].split(CHR_2);                     
		$('#cboIsPreCheck').combobox('setValue', objDic[0]);  		 // 产前检查
		$('#cboIsPreCheck').combobox('setText', objDic[2]);  		 // 产前检查
		$('#txtPregWeek').val(strFields[37]);   	                 // 初检孕周
		$('#txtPregCheckTime').val(strFields[38]);                   // 产检次数
		                                                             
		var objDic = strFields[39].split(CHR_2);                     
		$('#cboMDiagnoseBasis').combobox('setValue', objDic[0]);     //死因诊断依据
		$('#cboMDiagnoseBasis').combobox('setText', objDic[2]);      //死因诊断依据
		var objDic = strFields[53].split(CHR_2);                     
		$('#cboMCategory').combobox('setValue', objDic[0]);          //死因分类
		if (strFields[29]){
			var MCategoryId =  objDic[2].split(CHR_1)[0];
		}else{
			var MCategoryId =  objDic[2];
		}
	    $('#cboMCategory').combobox('setText', MCategoryId);           //死因分类
		var objDic = strFields[40].split(CHR_2);
		Common_SetRadioValue("radProResultList",objDic[0])		  // 省级医疗保健机构评审结果
		//if (objDic[0]) $HUI.radio('#radProResultList'+objDic[0]).setValue(true);    //省级医疗保健机构评审结果
		var objDic = strFields[41].split(CHR_2);                     
		//if (objDic[0]) $HUI.radio('#radProReasonList'+objDic[0]).setValue(true);    // 省级 影响死亡的主要因素
		Common_SetRadioValue("radProReasonList",objDic[0])		  // 省级 影响死亡的主要因素
		var objDic = strFields[42].split(CHR_2);                     
		//if (objDic[0]) $HUI.radio('#radConResultList'+objDic[0]).setValue(true);  	 //国家级评审结果
		Common_SetRadioValue("radConResultList",objDic[0])		  // 国家级评审结果
		var objDic = strFields[43].split(CHR_2);
        //if (objDic[0]) $HUI.radio('#radConReasonList'+objDic[0]).setValue(true); 	 // 国家 影响死亡的主要因素  
		Common_SetRadioValue("radConReasonList",objDic[0])		  // 国家 影响死亡的主要因素  		
	}
	
	//显示按钮操作权限 根据报告状态与操作权限控制
	obj.InitRepPowerByStatus = function(){
		$('#btnSaveTmp').hide();
		$('#btnReport').hide();
		$('#btnCheckOne').hide();
		$('#btnCheckTwo').hide();
		$('#btnUnCheck').hide();
		$('#btnPrintOne').hide();
		$('#btnGrantOne').hide();
		$('#btnPrintThree').hide();
		$('#btnGrantThree').hide();
		$('#btnDel').hide();
		$('#btnReturn').hide();
		$('#btnPrintChild').hide();
		$('#btnPrintMaternal').hide();
	
		//获取报告状态
		obj.RepStatusCode = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetReportStatus",
			reportId:ReportID
		},false);
	   
	    //加载报告状态
	    objStatus = obj.DicManage('DTHRunningState',obj.RepStatusCode);
		
		obj.RepStatusDesc = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetReportStatusDesc",
			reportId:ReportID
		},false);
	    $('#RepStatus').text(obj.RepStatusDesc);
		
		switch (obj.RepStatusCode) {
			case "" : // 无报告 只能暂存、上报
				 $('#btnSaveTmp').show();
				 $('#btnReport').show();
				break;
			case "1" : // 待审
				 $('#btnReport').linkbutton({text:'修改报卡'});
				 $('#btnReport').show();
				 $('#btnDel').show();
				 $('#btnCheckOne').show();
				 $('#btnPrintThree').show();
				 $('#btnGrantThree').show();
				 $('#btnReturn').show();
				//待审状态允许首联打印
				if (SSHospCode=='11-BJZYY') {       //北京中医院
					 $('#btnPrintOne').show();
					 $('#btnGrantOne').show();
				} else if (SSHospCode=='37-QYFY'){  //青医附院
					 $('#btnPrintOne').show();
					 $('#btnGrantOne').show();
				} else if (SSHospCode == '11-AZ') {	//安贞医院·
					 $('#btnPrintOne').show();
					 $('#btnGrantOne').show();
				}
				 $('#btnPrintChild').show();
				 $('#btnPrintMaternal').show();
				break;
			case "2" : //编码(病案室/统计室)
				 $('#btnCheckOne').show();
				 $('#btnCheckTwo').show();
				 $('#btnPrintThree').show();
				 $('#btnGrantThree').show();
				 $('#btnPrintOne').show();
				 $('#btnGrantOne').show();
				 $('#btnReturn').show();
				 $('#btnPrintChild').show();
				 $('#btnPrintMaternal').show();
				break;
			case "3" : //审核(预防保健科)
				 $('#btnPrintThree').show();
				 $('#btnGrantThree').show();
				 $('#btnPrintOne').show();
				 $('#btnGrantOne').show();
				 $('#btnPrintChild').show();
				 $('#btnPrintMaternal').show();
				 $('#btnUnCheck').show();
				break;
			case "9" : // 退回
				 $('#btnReport').linkbutton({text:'修改报卡'});
				 $('#btnReport').show();
				 $('#btnDel').show();
				break;
			case "6" : // 草稿
				 $('#btnSaveTmp').show();
				 $('#btnReport').show();
				 $('#btnDel').show();
				break;
			case "5" : // 作废
				break;
		}
		//已打印次数
		var inputStr=ReportID + CHR_1 + 2;
		var retPrintNumValue = obj.GetPrintNum(inputStr,CHR_1);
		if (retPrintNumValue=="") retPrintNumValue=0;
		// 执行过打印之后，不可以取消审核 add by chenrui 20230418
		if (retPrintNumValue>=1){
			$('#btnUnCheck').hide();
			$('#btnReturn').hide();
		}
		if (tDHCMedMenuOper['Report']!=1) {
			 $('#btnReport').hide();
			 $('#btnSaveTmp').hide();
		}
		if (tDHCMedMenuOper['CheckOne']!=1) {
			 $('#btnCheckOne').hide();
		}
		if (tDHCMedMenuOper['CheckTwo']!=1) {
			 $('#btnCheckTwo').hide();
		}
		if (tDHCMedMenuOper['CheckTwo']!=1) {	// 没有审核权限，隐藏取消审核按钮
			 $('#btnUnCheck').hide();
		}
		if (tDHCMedMenuOper['PrintOne']!=1) {
			 $('#btnPrintOne').hide();
		}
		if (tDHCMedMenuOper['PrintThree']!=1) {
			 $('#btnPrintThree').hide();
		}
		if (tDHCMedMenuOper['GrantThree']!=1) {
			 $('#btnGrantThree').hide();
		}
		if (tDHCMedMenuOper['GrantOne']!=1) {
			 $('#btnGrantOne').hide();
		}
		if (tDHCMedMenuOper['Del']!=1){
			 $('#btnDel').hide();
		}
		if (tDHCMedMenuOper['Return']!=1){
			 $('#btnReturn').hide();
		}
		if (!$('#chkRepMaternal').checkbox('getValue')) {
			$('#btnPrintMaternal').hide();
		}
		var chReportID = $m({                  
			ClassName:"DHCMed.DTH.ChildReport",
			MethodName:"GetRepIDByDthID",
			DthRepID:ReportID
		},false);
		if (!chReportID) {
			$('#btnPrintChild').hide();
		}	
		//只有编码、审核权限才可看到根本死因及损伤中毒及ICD编码
		if ((tDHCMedMenuOper['CheckOne']==1)||(tDHCMedMenuOper['CheckTwo']==1)){
			$('#BaseReason-tr').removeAttr("style");
			$('#BaseReasonL-tr').removeAttr("style");
		}
		
		//待审状态、三联打印后不允许修改病人基本信息、调查记录
		if (obj.RepStatusCode=="1") {
			
			var inputStr=ReportID + CHR_1 + 2;
			//已打印次数
			var retPrintNumValue = obj.GetPrintNum(inputStr,CHR_1);
		
			if (retPrintNumValue=="") retPrintNumValue=0;
			if (retPrintNumValue>=obj.PrintValue){ //允许打印次数
				//病人基本信息
				$('#txtRegNo').attr('disabled','disabled'); 
				$('#txtMrNo').attr('disabled','disabled'); 
				$('#txtPatName').attr('disabled','disabled'); 
				$('#txtIdentify').attr('disabled','disabled'); 
				$('#txtSex').attr('disabled','disabled'); 
				$('#txtBirthday').datebox('disable');  
				$('#txtAge').attr('disabled','disabled'); 
				$('#txtCountry').attr('disabled','disabled'); 
				$('#txtNation').attr('disabled','disabled'); 
				$('#cboCardType').combobox('disable');
				$('#cboMarital').combobox('disable');
				$('#cboEducation').combobox('disable');
				$('#cboOccupation').combobox('disable');
				$('#cboWorkType').combobox('disable');
				$('#txtCompany').attr('disabled','disabled'); 
				
				if ($.trim($('#cboRegProvince').combobox('getValue')) != '') $('#cboRegProvince').combobox('disable');
				if ($.trim($('#cboRegCity').combobox('getValue')) != '') $('#cboRegCity').combobox('disable');
				if ($.trim($('#cboRegCounty').combobox('getValue')) != '') $('#cboRegCounty').combobox('disable');
				if ($.trim($('#cboRegVillage').combobox('getValue')) != '') $('#cboRegVillage').combobox('disable');
				if ($.trim($('#txtRegRoad').val()) != '') $('#txtRegRoad').attr('disabled','disabled'); 
				if ($.trim($('#cboCurrProvince').combobox('getValue')) != '') $('#cboCurrProvince').combobox('disable');
				if ($.trim($('#cboCurrCity').combobox('getValue')) != '') $('#cboCurrCity').combobox('disable');
				if ($.trim($('#cboCurrCounty').combobox('getValue')) != '') $('#cboCurrCounty').combobox('disable');
				if ($.trim($('#cboCurrVillage').combobox('getValue')) != '') $('#cboCurrVillage').combobox('disable');
				if ($.trim($('#txtCurrRoad').val()) != '') $('#txtCurrRoad').attr('disabled','disabled'); 

				$('#txtFamName').attr('disabled','disabled'); 
				$('#cboFamCardType').combobox('disable');
				$('#txtFamIdentify').attr('disabled','disabled'); 
				$('#cboFamRelation').combobox('disable');
				$('#txtFamTel').attr('disabled','disabled'); 
				$('#txtFamAddress').attr('disabled','disabled'); 
				$('#txtDeathDate').datebox('disable'); 
				$('#txtDeathTime').attr('disabled','disabled'); 
				$('#cboDeathPlace').combobox('disable');
				$('#cboPregnancies').combobox('disable');
				//调查记录
				$('#txtExamMedical').attr('disabled','disabled'); 
				$('#txtExamName').attr('disabled','disabled'); 
				$('#cboExamRelation').combobox('disable');
				$('#txtExamTel').attr('disabled','disabled'); 
				$('#txtExamDeathReason').attr('disabled','disabled'); 
				$('#txtExamAddress').attr('disabled','disabled'); 
				$('#txtExamUser').attr('disabled','disabled'); 
				$('#txtExamDate').datebox('disable'); 
			}
		}
	}
	
	//死亡证数据完整性校验方法
	obj.CheckRepData = function(){
		var errInfo = '';
		if (SSHospCode=='11-BJZYY') {
			//北京中医院检查病人基本信息（报告内容与病人基本信息【姓名、身份证号】一致性检查）
			var strPatInfo = $m({                  
				ClassName:"DHCMed.Base.Patient",
				MethodName:"GetStringById",
				aSeparete:CHR_1,
				aEpisodeID:EpisodeID
			},false);
			var arrPatInfo = strPatInfo.split(CHR_1);

			if(arrPatInfo.length>0){
				var basePatName  = arrPatInfo[2];
				var baseCardType = arrPatInfo[24];
				var baseIdentify = arrPatInfo[8];
				var CardType = $.trim($('#cboCardType').combobox('getValue'));
				var Identify = $.trim($('#txtIdentify').val());
				var PatName  = $.trim($('#txtPatName').val());
				if (basePatName != '') {
					if (basePatName != PatName){
						 errInfo =$g("建卡处病人姓名【") + basePatName + $g("】与死亡证中病人姓名【")+PatName+$g("】不一致，请核实!")+"<br>";
					}
				}
				if ((baseCardType.indexOf('身份证')>-1)&&((baseCardType.indexOf('身份证')>-1)||(baseCardType.indexOf('户口簿')>-1))) {
					if(baseIdentify!=Identify){
						errInfo +=$g("建卡处病人身份证号【")+baseIdentify+$g("】与报告中病人身份证号【")+Identify+$g("】不一致，请核实!");
					}
				}
			}
			if (errInfo!="") return errInfo;
		} else {
			//其他医院暂时不做检查
		}
		//友谊医院身份号不能和以前填过的报告中的号码重复
		if (SSHospCode=='11-YY') {
			var Identify = $.trim($('#txtIdentify').val());    //身份证
			var IdentifyFlag = $m({                  
				ClassName:"DHCMed.DTHService.ReportSrv",
				MethodName:"CheckIdentify",
				Identify:Identify,
				Identify:EpisodeID
			},false);
			if(IdentifyFlag==1){
				 $.messager.alert("提示", "身份证号重复，请核实后再上报！", 'info');
				 return
			}
		}
		var PatName = $.trim($('#txtPatName').val());
		if (PatName=="") errInfo += $g("姓名不允许为空!")+"<br>";
		if (PatName.indexOf('无名氏')>-1) {
			errInfo=obj.CheckDeathDate();	//无名氏验证死亡日期、时间	
			return errInfo;
		} else {
			errInfo +=obj.CheckDeathDate();//验证死亡日期、时间	
		}
		var Sex = $.trim($('#txtSex').val());
		if (Sex=="") errInfo += $g("性别不允许为空!")+"<br>";
		var Age = $.trim($('#txtAge').val());
		if (Age=="") errInfo += $g("年龄不允许为空!")+"<br>";
		var Birthday = $('#txtBirthday').datebox('getValue');
		if (Birthday=="") errInfo += $g("出生日期不允许为空!")+"<br>";
		var Country = $.trim($('#txtCountry').val());
		if (Country=="") errInfo += $g("国家或地区不允许为空!")+"<br>";
		var Nation = $.trim($('#txtNation').val());
		if (Nation=="") errInfo += $g("民族不允许为空!")+"<br>";
		var CardType = $.trim($('#cboCardType').combobox('getValue'));
		if (CardType=="") errInfo += $g("证件类型不允许为空!")+"<br>";
		var Identify = $.trim($('#txtIdentify').val());
		if (Identify=="") errInfo += $g("证件号码不允许为空!")+"<br>";
		var Marital = $.trim($('#cboMarital').combobox('getValue'));
		if (Marital=="") errInfo += $g("请选择婚姻状况!")+"<br>";
		var Education = $.trim($('#cboEducation').combobox('getValue'));
		if (Education=="") errInfo += $g("请选择文化程度!")+"<br>";
		var Occupation = $.trim($('#cboOccupation').combobox('getValue'));
		if (Occupation=="") errInfo += $g("请选择职业!")+"<br>";
		var Company = $.trim($('#txtCompany').val());
		if (Company=="") errInfo += $g("工作单位不允许为空!")+"<br>";

		var CardTypeDesc = $.trim($('#cboCardType').combobox('getText'));
		if ((CardTypeDesc=="港澳通行证")||(CardTypeDesc=="台湾通行证")){
			var RegAddress = $.trim($('#txtRegRoad').val());
			if (RegAddress=="") errInfo += $g("证件类型为港澳通行证或台湾通行证，请填写详细地址到户籍地址村(小区)")+"<br>";
			var CurrAddress = $.trim($('#txtCurrRoad').val());
			if (CurrAddress=="") errInfo += $g("证件类型为港澳通行证或台湾通行证，请填写详细地址到生前住址村(小区)")+"<br>";	
		}else{
			var RegProvince = $.trim($('#cboRegProvince').combobox('getValue'));
			if (RegProvince=="") errInfo += $g("请选择户籍地址省")+"<br>";
			var RegCity = $.trim($('#cboRegCity').combobox('getValue'));
			if (RegCity=="") errInfo += $g("请选择户籍地址市")+"<br>";
			var RegCounty = $.trim($('#cboRegCounty').combobox('getValue'));
			if (RegCounty=="") errInfo += $g("请选择户籍地址县")+"<br>";
			var RegVillage = $.trim($('#cboRegVillage').combobox('getValue'));
			if (RegVillage=="") errInfo += $g("请选择户籍地址乡(街道)")+"<br>";
			var RegAddress = $.trim($('#txtRegRoad').val());
			if (RegAddress=="") errInfo += $g("户籍地址村(小区)不允许为空")+"<br>";
			var CurrProvince = $.trim($('#cboCurrProvince').combobox('getValue'));
			if (CurrProvince=="") errInfo += $g("请选择生前住址省")+"<br>";
			var CurrCity = $.trim($('#cboCurrCity').combobox('getValue'));
			if (CurrCity=="") errInfo += $g("请选择生前住址市")+"<br>";
			var CurrCounty = $.trim($('#cboCurrCounty').combobox('getValue'));
			if (CurrCounty=="") errInfo += $g("请选择生前住址县")+"<br>";
			var CurrVillage = $.trim($('#cboCurrVillage').combobox('getValue'));
			if (CurrVillage=="") errInfo += $g("请选择生前住址乡(街道)")+"<br>";
			var CurrAddress = $.trim($('#txtCurrRoad').val());
			if (CurrAddress=="") errInfo += $g("生前住址村(小区)不允许为空")+"<br>";	
		}		
		
		//手工录入死亡编号，则死亡编号不许为空!
		var DeathNo = $.trim($('#txtDeathNo').val());
		if((DeathNoType == 0) && (DeathNo.trim() == "")) errInfo = errInfo + $g("死亡证明书编号不允许为空!")+"<br>";
		
		if(Sex=="女") {
			var Pregnancies = $.trim($('#cboPregnancies').combobox('getValue'));
			if (Pregnancies=="") errInfo += $g("妊娠期或终止妊娠42天内不允许为空!")+"<br>";
		}
		var FamName = $.trim($('#txtFamName').val());
		if (FamName=="") errInfo += $g("家属姓名不允许为空!")+"<br>";
		var FamTel = $.trim($('#txtFamTel').val());
		if (FamTel=="") errInfo += $g("联系电话不允许为空!")+"<br>";
		if ($.trim($('#txtFamTel').val()) != ""){
			if (!(/^1[3456789]\d{9}$/.test($.trim($('#txtFamTel').val())))) {
				errInfo += $g("输入的联系电话格式不符合规定！请重新输入!")+"<br>";
			}
		}
		var FamRelation = $.trim($('#cboFamRelation').combobox('getValue'));
		if (FamRelation=="") errInfo += $g("与死者关系不允许为空!")+"<br>";
		var FamAddr = $.trim($('#txtFamAddress').val());
		if (FamAddr=="") errInfo += $g("家属住址或工作单位不允许为空!")+"<br>";
		if (SSHospCode=='11-BJZYY') {
			var FamCardType = $.trim($('#cboFamCardType').combobox('getValue'));
			if (FamCardType=="") errInfo += $g("家属证件类型不允许为空!")+"<br>";
			var FamIdentify = $.trim($('#txtFamIdentify').val());
			if (FamIdentify=="") errInfo += $g("家属证件号码不允许为空!")+"<br>";
		}
		var AReason = $.trim($('#cboAReason').lookup('getText'));
		var BReason = $.trim($('#cboBReason').lookup('getText'));
		var CReason = $.trim($('#cboCReason').lookup('getText'));
		var DReason = $.trim($('#cboDReason').lookup('getText'));
		var AReasonICD = $.trim($('#txtAReasonICD').val());
		var BReasonICD = $.trim($('#txtBReasonICD').val()); 
		var CReasonICD = $.trim($('#txtCReasonICD').val()); 
		var DReasonICD = $.trim($('#txtDReasonICD').val()); 
		if ((AReason=="")&&(BReason=="")&&(CReason=="")&&(DReason=="")){
			errInfo += $g("至少填写(a)直接导致死亡的疾病或情况!")+"<br>";
		} 
		if ((AReason!='')&&(AReasonICD=='')) {
			errInfo += '(a)'+$g("直接导致死亡的疾病或情况请录入标准诊断!")+"<br>";
		}
		if ((BReason!='')&&(BReasonICD=='')) {
			errInfo += '(b)'+$g("直接导致死亡的疾病或情况请录入标准诊断!")+"<br>";
		}
		if ((CReason!='')&&(CReasonICD=='')) {
			errInfo += '(c)'+$g("直接导致死亡的疾病或情况请录入标准诊断!")+"<br>";
		}
		if ((DReason!='')&&(DReasonICD=='')) {
			errInfo += '(d)'+$g("直接导致死亡的疾病或情况请录入标准诊断!")+"<br>";
		}
		if ((AReason=="")&&((BReason!="")||(CReason!="")||(DReason!=""))) {
			errInfo += '(a)'+$g("直接导致死亡的疾病或情况不允许为空!")+"<br>";
		}
		if ((BReason=="")&&((CReason!="")||(DReason!=""))) {
			errInfo += '(b)'+$g("引起(a)的疾病或情况不允许为空!")+"<br>";
		}
		if ((CReason=="")&&(DReason!="")) {
			errInfo += '(c)'+$g("引起(b)的疾病或情况不允许为空!")+"<br>";
		}
		if (AReason!=""){
			var AInterval = $.trim($('#txtAInterval').val());
			var ATime = $.trim($('#cboATime').combobox('getValue'));
			if(AInterval==""){
				errInfo += '(a)'+$g("诊断时间间隔不允许为空!")+"<br>";
			}
			if(ATime==""){
				errInfo += '(a)'+$g("诊断时间单位不允许为空!")+"<br>";
			}
		}
		if (BReason!=""){
			var BInterval = $.trim($('#txtBInterval').val());
			var BTime = $.trim($('#cboBTime').combobox('getValue'));
			if(BInterval==""){
				errInfo += '(b)'+$g("诊断时间间隔不允许为空!")+"<br>";
			}
			if(BTime==""){
				errInfo += '(b)'+$g("诊断时间单位不允许为空!")+"<br>";
			}
		}
		if (CReason!=""){
			var CInterval = $.trim($('#txtCInterval').val());
			var CTime = $.trim($('#cboCTime').combobox('getValue'));
			if(CInterval==""){
				errInfo += '(c)'+$g("诊断时间间隔不允许为空!")+"<br>";
			}
			if(CTime==""){
				errInfo += '(c)'+$g("诊断时间单位不允许为空!")+"<br>";
			}
		}
		if (DReason!=""){
			var DInterval = $.trim($('#txtDInterval').val());
			var DTime = $.trim($('#cboDTime').combobox('getValue'));;
			if(DInterval==""){
				errInfo += '(d)'+$g("诊断时间间隔不允许为空!")+"<br>";
			}
			if(DTime==""){
				errInfo += '(d)'+$g("诊断时间单位不允许为空!")+"<br>";
			}
		}
		var DamageDiagnose = $.trim($('#cboDamageDiagnose').lookup('getText'));           //损伤中毒诊断
		var DamageDiagnoseICD = $.trim($('#txtDamageDiagnoseICD').val());  
		if ((DamageDiagnose!='')&&(DamageDiagnoseICD=='')) {
			errInfo += $g("损伤中毒诊断请录入标准诊断!")+"<br>";
		}
		var OtherDiagnose = $.trim($('#cboOtherDiagnose').lookup('getText'));
        var OtherDiagnoseICD = $.trim($('#txtOtherDiagnoseICD').val());
		if ((OtherDiagnose!='')&&(OtherDiagnoseICD=='')) {
			errInfo += $g("其他诊断请录入标准诊断!")+"<br>";
		}
		if (OtherDiagnose!=""){
			var OtherDiagnoseInterval = $.trim($('#txtOtherDiagnoseInterval').val());
			var OtherDiagnoseTime = $.trim($('#cboOtherDiagnoseTime').combobox('getValue'));
			if(OtherDiagnoseInterval==""){
				errInfo += $g("其他诊断时间间隔不允许为空!")+"<br>";
			}
			if(OtherDiagnoseTime==""){
				errInfo += $g("其他诊断时间单位不允许为空!")+"<br>";
			}
		}
		var DiagnoseUnit = $.trim($('#cboDiagnoseUnit').combobox('getValue'));
		if (DiagnoseUnit=="") errInfo += $g("诊断单位不允许为空!")+"<br>";
		var DiagnoseBasis = $.trim($('#cboDiagnoseBasis').combobox('getValue'));
		if (DiagnoseBasis=="") errInfo += $g("诊断依据不允许为空!")+"<br>";
		var cboDeathPlace = $.trim($('#cboDeathPlace').combobox('getValue'));
		if (cboDeathPlace==""){
			errInfo += $g("死亡地点不允许为空!")+"<br>";
		} else {
			var DeathPlaceDesc = $.trim($('#cboDeathPlace').combobox('getText'));    //死亡地点
			var ExamMedical = $.trim($('#txtExamMedical').val());          //死者生前病史及症状体征
			var ExamDeathReason = $.trim($('#txtExamDeathReason').val());  //死因推断
			var ExamName = $.trim($('#txtExamName').val());	//被调查者
			var ExamRelation = $.trim($('#cboExamRelation').combobox('getValue')); //与死者关系
			var ExamTel = $.trim($('#txtExamTel').val()); //联系电话
			var ExamAddress = $.trim($('#txtExamAddress').val()); //联系地址
			var ExamUser = $.trim($('#txtExamUser').val()); //调查者
			var ExamDate = $('#txtExamDate').datebox('getValue'); //调查日期
			if (ExamTel != ""){
				if (!(/^1[3456789]\d{9}$/.test(ExamTel))) {
					errInfo += $g("调查记录中输入的联系电话格式不符合规定！请重新输入!")+"<br>";
				}
			}
			if ((DeathPlaceDesc!="医疗卫生机构(急诊)")&&(DeathPlaceDesc!="医疗卫生机构(病房)")){
				if((ExamMedical=="")||(ExamDeathReason=="")){
				   errInfo += $g("死亡地点不在医疗卫生机构的患者，死者生前病史及症状体征和死因推断不允许为空!")+"<br>";
				}
				if (ExamName == "") {
					errInfo += $g("死亡地点不在医疗卫生机构的患者，被调查者不允许为空!")+"<br>";
				}
				if (ExamRelation == "") {
					errInfo += $g("死亡地点不在医疗卫生机构的患者，与死者关系不允许为空!")+"<br>";
				}
				if (ExamTel == "") {
					errInfo += $g("死亡地点不在医疗卫生机构的患者，联系电话不允许为空!")+"<br>";
				}
				if (ExamTel != "") {
					if (!(/^1[3456789]\d{9}$/.test($.trim(ExamTel)))) {
						errInfo += $g("死亡地点不在医疗卫生机构的患者，联系电话格式不符合规定！请重新输入!")+"<br>";
					}
				} 
				if (ExamAddress == "") {
					errInfo += $g("死亡地点不在医疗卫生机构的患者，联系地址不允许为空!")+"<br>";
				}
				if (ExamUser == "") {
					errInfo += $g("死亡地点不在医疗卫生机构的患者，调查者不允许为空!")+"<br>";
				}
				if (ExamDate == "") {
					errInfo += $g("死亡地点不在医疗卫生机构的患者，调查日期不允许为空!")+"<br>";
				}
			}
		}
		
		//时间间隔转换成分钟
		//根据时间间隔，检查诊断填写顺序是否正确
		var Atim=0,Btim=0,Ctim=0,Dtim=0;
		var AInterval = $.trim($('#txtAInterval').val());             //时间间隔
		var ATime = $.trim($('#cboATime').combobox('getValue'));                  //时间单位
		var BInterval = $.trim($('#txtBInterval').val());             //时间间隔
		var BTime = $.trim($('#cboBTime').combobox('getValue'));                  //时间单位
		var CInterval = $.trim($('#txtCInterval').val());             //时间间隔
		var CTime = $.trim($('#cboCTime').combobox('getValue'));                  //时间单位
		var DInterval = $.trim($('#txtDInterval').val());             //时间间隔
		var DTime = $.trim($('#cboDTime').combobox('getValue'));                  //时间单位
		var ATimeCode=obj.GetDataById(ATime);  //时间单位代码
		var BTimeCode=obj.GetDataById(BTime);  //时间单位代码
		var CTimeCode=obj.GetDataById(CTime);  //时间单位代码
		var DTimeCode=obj.GetDataById(DTime);  //时间单位代码
		if (ATimeCode!=""){
		   if (ATimeCode==1) {Atim=AInterval*365*24*60}
		   if (ATimeCode==2) {Atim=AInterval*30*24*60}
		   if (ATimeCode==3) {Atim=AInterval*24*60}
		   if (ATimeCode==4) {Atim=AInterval*60}
		   if (ATimeCode==5) {Atim=AInterval*1}
		}
		if (BTimeCode!=""){
		   if (BTimeCode==1) {Btim=BInterval*365*24*60}
		   if (BTimeCode==2) {Btim=BInterval*30*24*60}
		   if (BTimeCode==3) {Btim=BInterval*24*60}
		   if (BTimeCode==4) {Btim=BInterval*60}
		   if (BTimeCode==5) {Btim=BInterval*1}
		}
		if (CTimeCode!=""){
		   if (CTimeCode==1) {Ctim=CInterval*365*24*60}
		   if (CTimeCode==2) {Ctim=CInterval*30*24*60}
		   if (CTimeCode==3) {Ctim=CInterval*24*60}
		   if (CTimeCode==4) {Ctim=CInterval*60}
		   if (CTimeCode==5) {Ctim=CInterval*1}
		}
		if (DTimeCode!=""){
		  if (DTimeCode==1) {Dtim=DInterval*365*24*60}
		  if (DTimeCode==2) {Dtim=DInterval*30*24*60}
		  if (DTimeCode==3) {Dtim=DInterval*24*60}
		  if (DTimeCode==4) {Dtim=DInterval*60}
		  if (DTimeCode==5) {Dtim=DInterval*1}
		}
		if (Atim>Btim&&Btim!="0"){
			errInfo += "'(a)直接导致死亡的疾病或情况'与'(b)引起(a)的疾病或情况',顺序填写有误!";
		} else if (Ctim!="0"&&Btim>Ctim){
			errInfo += "'(b)引起(a)的疾病或情况'与'(c)引起(b)的疾病或情况',顺序填写有误!";
		} else if ((Ctim!="0"&&Dtim!="0")&&(Ctim>Dtim)){
			errInfo += "'(c)引起(b)的疾病或情况'与'(d)引起(c)的疾病或情况',顺序填写有误!";
		} else if (Ctim!="0"&&Atim>Ctim){
			errInfo += "'(a)直接导致死亡的疾病或情况'与'(c)引起(b)的疾病或情况',顺序填写有误!";
		} else if (Dtim!="0"&&Atim>Dtim){
			errInfo += "'(a)直接导致死亡的疾病或情况'与'(d)引起(c)的疾病或情况',顺序填写有误!";
		} else if (Dtim!="0"&&Btim>Dtim){
			errInfo += "'(b)引起(a)的疾病或情况'与'(d)引起(c)的疾病或情况',顺序填写有误!";
		}
		
		//增加职业控制工作单位
		var occupationArray = obj.OccupationList.split("~");		
		var OccupationValue = $.trim($('#cboOccupation').combobox('getText'));
		var Company = $.trim($('#txtCompany').val());
		if((occupationArray!="")&&(OccupationValue!="")){
			for (var i = 0; i < occupationArray.length; i ++) {
				var occupation = occupationArray[i] ;
				if (OccupationValue == occupation) {
					if ((Company=="") || (Company == "无")) {
						errInfo += $g("职业为:")+OccupationValue+$g(',工作单位不允许为空或者"无"!');
					}
				}
			}
		}
		if ($('#chkRepMaternal').checkbox('getValue')) {
			var ConProvince   = $.trim($('#cboConProvince').combobox('getValue'));
			var ConCity       = $.trim($('#cboConCity').combobox('getValue'));
			var ConCounty     = $.trim($('#cboConCounty').combobox('getValue'));
			var ConVillage    = $.trim($('#cboConVillage').combobox('getValue'));
			if ((ConProvince=="")||(ConCity=="")||(ConCounty=="")||(ConVillage=="")) {
				errInfo += $g("常住地省市县乡(街道)不允许为空!")+"<br>";
			}
			var TempProvince  = $.trim($('#cboTempProvince').combobox('getValue'));
			var TempCity      = $.trim($('#cboTempCity').combobox('getValue'));
			var TempCounty    = $.trim($('#cboTempCounty').combobox('getValue'));
			var TempVillage   = $.trim($('#cboTempVillage').combobox('getValue'));
			if ((TempProvince=="")||(TempCity=="")||(TempCounty=="")||(TempVillage=="")) {
				errInfo += $g("现住地省市县乡(街道)不允许为空!")+"<br>";
			}
			var MRegType      = $.trim($('#cboMRegType').combobox('getValue'));
			if (MRegType=="") {
				errInfo += $g("户口不允许为空!")+"<br>";
			}
			var IsPlan        = $.trim($('#cboIsPlan').combobox('getValue'));
			if (IsPlan=="") {
				errInfo += $g("计划内外不允许为空!")+"<br>";
			}
			var Nation        = $.trim($('#cboNation').combobox('getValue'));
			if (Nation=="") {
				errInfo += $g("孕产妇死亡副卡民族不允许为空!")+"<br>";
			}
			var Education     = $.trim($('#cboMEducation').combobox('getValue'));
			if (Education=="") {
				errInfo += $g("孕产妇死亡副卡文化程度不允许为空!")+"<br>";
			}
			var FamilIncome   = $.trim($('#cboFamilIncome').combobox('getValue'));
			if (FamilIncome=="") {
				errInfo += $g("家庭人均收入不允许为空!")+"<br>";
			}
			var ConType       = $.trim($('#cboConType').combobox('getValue'));
			if (ConType=="") {
				errInfo += $g("居住地区不允许为空!")+"<br>";
			}
			var PreTimes      = $.trim($('#txtPreTimes').val());
			var ProTimes      = $.trim($('#txtProTimes').val());
			var LaborTimes    = $.trim($('#txtLaborTimes').val());
			if ((PreTimes=="")||(ProTimes=="")||(LaborTimes=="")) {
				errInfo += $g("产次，产次，人工流产、引产次不允许为空!")+"<br>";
			}
			var DeliPosition  = Common_CheckboxValue('radDeliveryPosList');
			if (DeliPosition=="") {
				errInfo += $g("分娩地点不允许为空!")+"<br>";
			}
			var DeathPosition = Common_CheckboxValue('radDeathPosList');
			if (DeathPosition=="") {
				errInfo += $g("死亡地点不允许为空!")+"<br>";
			}
			var DeliveryWay   = Common_CheckboxValue('radDeliveryWayList');
			if (DeliveryWay=="") {
				errInfo += $g("分娩方式不允许为空!")+"<br>";
			}
			var IsNewWay      = $.trim($('#cboIsNewWay').combobox('getValue'));
			if (IsNewWay=="") {
				errInfo += $g("是否新法接生不允许为空!")+"<br>";
			}
			var Deliveryer    = $.trim($('#cboDeliveryer').combobox('getValue'));
			if (Deliveryer=="") {
				errInfo += $g("接生者不允许为空!")+"<br>";
			}
			var IsPreCheck    = $.trim($('#cboIsPreCheck').combobox('getValue'));
			if (IsPreCheck=="") {
				errInfo += $g("是否产前检查不允许为空!")+"<br>";
			} 
			if ($('#cboIsPreCheck').combobox('getText')=='有'){
				var PregWeek      = $.trim($('#txtPregWeek').val());
				var PregCheckTime = $.trim($('#txtPregCheckTime').val());
				if ((PregWeek=="")||(PregCheckTime=="")) {
					errInfo += $g("产前检查初检孕周、产检次数不允许为空!")+"<br>";
				}
			}
			var MDiagnoseBasis = $.trim($('#cboMDiagnoseBasis').combobox('getValue'));
			if (MDiagnoseBasis=="") {
				errInfo += $g("死因诊断依据不允许为空!")+"<br>";
			}
			var MCategory     = $.trim($('#cboMCategory').combobox('getValue'));
			if (MCategory=="") {
				errInfo += $g("死因分类不允许为空!")+"<br>";
			}
			var LastMenList   = Common_CheckboxValue('radLastMenList');
			var LastMenDate   = $('#dtLastMenDate').datebox('getValue');
			if ((LastMenList=="")&&(LastMenDate=="")) {
				errInfo += $g("末次月经时间不允许为空!")+"<br>";	
			}
			var DeliDateList   = Common_CheckboxValue('radDeliDateList');
			var DeliveryDate  = $('#dtDeliveryDate').datebox('getValue'); 
			var DeliveryTime  = $.trim($('#txtDeliveryTime').val());
			if (((DeliDateList=="")&&(DeliveryDate==""))||((DeliveryDate!="")&&(DeliveryTime==""))) {
				errInfo += $g("分娩时间不允许为空!")+"<br>";	
			}
			
			if((DeliveryTime>23)||(DeliveryTime<0)){
				errInfo += $g("分娩时间范围为0~23时,请填写正确数值!")+"<br>";
			}
			var DeathDate     = $('#dtMDeathDate').datebox('getValue'); 
			var NowDate = Common_GetDate(new Date());
			if ((LastMenDate!="")&&(Common_CompareDate(LastMenDate,NowDate)>0)) {
				errInfo += $g("末次月经不允许大于当前日期!")+"<br>";
			}
			if ((LastMenDate!="")&&(Common_CompareDate(LastMenDate,DeathDate)>0)) {
				errInfo += $g("末次月经不允许大于死亡日期!")+"<br>";
			}
			if ((DeliveryDate!="")&&(Common_CompareDate(DeliveryDate,NowDate)>0)) {
				errInfo += $g("分娩日期不允许大于当前日期!")+"<br>";
			}
			if ((DeliveryDate!="")&&(Common_CompareDate(DeliveryDate,DeathDate)>0)) {
				errInfo += $g("分娩日期不允许大于死亡日期!")+"<br>";
			}
			
			var DeathTime     = $.trim($('#txtMDeathTime').val());
			if((DeathTime>23)||(DeathTime<0)){
				errInfo += $g("死亡时间范围为0~23时,请填写正确数值!")+"<br>";
			}
		}
		
		if (Age.indexOf($g('岁'))>-1) {
			//var CurrAge = Age.replace("岁", ""); 
			var arrCurrAge = Age.split($g("岁")); 
			var CurrAge = arrCurrAge[0]; 
			if (CurrAge >= 5) {
				return errInfo;
			}
		}
	    var FatherName = $.trim($('#txtFatherName').val());
		if (FatherName =="") errInfo += $g("5岁以下儿童父亲姓名不允许为空")+"<br>";
		var MotherName = $.trim($('#txtMotherName').val());
		if (MotherName =="") errInfo += $g("5岁以下儿童母亲姓名不允许为空")+"<br>";
		var ChSex = $.trim($('#cboSex').combobox('getValue'));
		if (ChSex =="") errInfo += $g("5岁以下儿童性别不允许为空")+"<br>";
		var DeathAgeYear = $.trim($('#txtDeathAgeYear').val());
		var DeathAgeMonth = $.trim($('#txtDeathAgeMonth').val());
		var DeathAgeDay = $.trim($('#txtDeathAgeDay').val());
		var DeathAgeHour = $.trim($('#txtDeathAgeHour').val());
	    
		if(DeathAgeMonth > 12){
			errInfo += $g("死亡时年龄的月数不能大于'12'，请准确填写年数和月数！")+"<br>";
		}
		if(DeathAgeDay > 31){
			errInfo += $g("死亡时年龄的天数不能大于'31'，请准确填写月数和天数！")+"<br>";
		}
		if(DeathAgeHour > 24){
			errInfo += $g("死亡时年龄的小时数不能大于'23'，请准确填写天数数和小时数！")+"<br>";	
		}
		if (((DeathAgeYear == "") || (DeathAgeYear == 0)) &&
			((DeathAgeMonth == "") || (DeathAgeMonth == 0)) &&
			((DeathAgeDay == "") || (DeathAgeDay == 0)) &&
			((DeathAgeHour == "") || (DeathAgeHour == 0))){
			errInfo += $g("请填写患儿的死亡年龄，如果不足一周岁的，请填写具体年龄！")+"<br>";
		}
		
		var Weight = $.trim($('#txtWeight').val());
		if (Weight =="") errInfo += $g("5岁以下儿童出生体重不允许为空")+"<br>";
		var WeightType = $.trim($('#cboWeightType').combobox('getValue'));
		if (WeightType =="") errInfo += $g("5岁以下儿童体重类别不允许为空")+"<br>";
		var PregnancyWeek = $.trim($('#txtPregnancyWeek').val());
		if (PregnancyWeek =="") errInfo += $g("5岁以下儿童孕周不允许为空")+"<br>";
		var BirthdayPlace = $.trim($('#cboBirthdayPlace').combobox('getValue'));
		if (BirthdayPlace =="") errInfo += $g("5岁以下儿童出生地点不允许为空")+"<br>";
		var RegType = $.trim($('#cboRegType').combobox('getValue'));
		if (RegType =="") errInfo += $g("5岁以下儿童户籍类型不允许为空")+"<br>";
		var DeathPosition = $.trim($('#cboDeathPosition').combobox('getValue'));
		if (DeathPosition =="") errInfo += $g("5岁以下儿童死亡地点不允许为空")+"<br>";
		var DiagnoseLv = $.trim($('#cboDiagnoseLv').combobox('getValue'));
		if (DiagnoseLv =="") errInfo += $g("5岁以下儿童诊断级别不允许为空")+"<br>";
		var Category = $.trim($('#cboCategory').combobox('getValue'));
		if (Category =="") errInfo += $g("5岁以下儿童疾病分类编号不允许为空")+"<br>";
		var ChildDiagBasis = $.trim($('#cboChildDiagBasis').combobox('getValue'));
		if (ChildDiagBasis =="") errInfo += $g("5岁以下儿童最高诊断依据不允许为空")+"<br>";
		var CareBeforeDeath = $.trim($('#cboCareBeforeDeath').combobox('getValue'));
		if (CareBeforeDeath =="") errInfo += $g("5岁以下儿童死亡前治疗不允许为空")+"<br>";
		var CareDeath =  $.trim($('#cboCareBeforeDeath').combobox('getText'));
		var NotCareReason = $.trim($('#cboNotCareReason').combobox('getValue'));
		if (CareDeath.indexOf('未治疗')>-1) {
			if (NotCareReason =="") errInfo += $g("5岁以下儿童死亡前未治疗原因不允许为空")+"<br>";
		}
		var CareReason = $.trim($('#cboNotCareReason').combobox('getText'));
		var NotCareReasonTxt = $.trim($('#txtNotCareReasonTxt').val());
		if (CareReason.indexOf('其他')>-1) {
			if (NotCareReasonTxt =="") errInfo += $g("5岁以下儿童未治疗其他原因不允许为空")+"<br>";
		}
		return errInfo;
	}
	obj.CheckDeathDate = function(){
		var errInfo='';
		var thisNowDate = Common_GetDate(new Date());
		var thisNowTime = Common_GetTime(new Date());
		var DeathDate = $('#txtDeathDate').datebox('getValue');
		if (DeathDate=="") errInfo += $g("死亡日期不允许为空!")+"<br>";
		var DeathTime = $('#txtDeathTime').timespinner('getValue');
		if (DeathTime=="") errInfo += $g("死亡时间不允许为空!")+"<br>";
		/*var AdmDate ="";AdmTime=""
		//死亡日期不能早于就诊日期
		var strAdmInfo = $m({                  
			ClassName:"DHCMed.SSIO.FromAdmSrv",
			MethodName:"GetAdmDateTime",
			aEpisodeID:EpisodeID
		},false);
		if (strAdmInfo) {
			AdmDate = strAdmInfo.split("^")[0];
			AdmTime = strAdmInfo.split("^")[1];
		}
		if ((DeathDate!="")&&(Common_CompareDate(AdmDate,DeathDate)>0)) {
			errInfo += '死亡日期不允许早于就诊日期!<br>';
		}
		if ((DeathDate == AdmDate)&&(AdmTime >DeathTime)) {
			errInfo += '死亡日期不允许早于就诊日期!<br>';
		}*/
		var Birthday = $('#txtBirthday').datebox('getValue');
		if ((DeathDate!="")&&(Birthday!="")&&(Common_CompareDate(Birthday,DeathDate)>0)) {
			errInfo += $g("死亡日期不允许早于出生日期!")+"<br>";
		}
		//死亡日期不能大于当前日期
		if ((DeathDate!="")&&(Common_CompareDate(DeathDate,thisNowDate)>0)) {
			errInfo += $g("死亡日期不允许大于当前日期!")+"<br>";
		}
		if ((DeathDate == thisNowDate)&&(DeathTime >thisNowTime)) {
			errInfo += $g("死亡时间不允许大于当前时间!")+"<br>";
		}
		return errInfo;
	}
	
	// 获取上报的主卡字符串
	obj.SaveToString = function(RepStatus, separate) {
		if (!separate) separate="^";
		var MrNo = $.trim($('#txtMrNo').val());                                 //病案号
		var Name = $.trim($('#txtPatName').val());                              //患者姓名
		var Sex = $.trim($('#txtSex').val());                                   //性别
		var Birthday = $('#txtBirthday').datebox('getValue');           //出生日期
		var Age = $.trim($('#txtAge').val());                                   //年龄
		var CardType = $.trim($('#cboCardType').combobox('getValue'));          //证件类型ID
		var Identify = $.trim($('#txtIdentify').val());                         //证件号码
		var PapmiNo = $.trim($('#txtRegNo').val());                             //登记号
		var Occupation = $.trim($('#cboOccupation').combobox('getValue'));      //职业
		var Country = $.trim($('#txtCountry').val());                           //国家或地区
		var Nation = $.trim($('#txtNation').val());                             //民族
		var Marital = $.trim($('#cboMarital').combobox('getValue'));            //婚姻状况
		var Education = $.trim($('#cboEducation').combobox('getValue'));        //文化程度
		var Company = $.trim($('#txtCompany').val());                           //工作单位
		var FamName = $.trim($('#txtFamName').val());                           //家属姓名
		var FamRelation = $.trim($('#cboFamRelation').combobox('getValue'));    //与死者关系
		var FamTel = $.trim($('#txtFamTel').val());                             //家属联系电话
		var FamAddr = $.trim($('#txtFamAddress').val());                        //家属住址
		var FamCardTypeId = '';                                         //家属证件类型ID
		var Pregnancies = $.trim($('#cboPregnancies').combobox('getValue'));    //孕产情况
		var FamIdentify = '';                                           //家属证件号码
		
		//户籍地址(省市县乡)
		var RegProvince = $.trim($('#cboRegProvince').combobox('getValue'));
		var RegCity = $.trim($('#cboRegCity').combobox('getValue'));
		var RegCounty = $.trim($('#cboRegCounty').combobox('getValue'));
		var RegVillage = $.trim($('#cboRegVillage').combobox('getValue'));
		
		var RegProvinceDesc = $.trim($('#cboRegProvince').combobox('getText'));
		var RegCityDesc = $.trim($('#cboRegCity').combobox('getText'));
		var RegCountyDesc = $.trim($('#cboRegCounty').combobox('getText'));
		var RegVillageDesc = $.trim($('#cboRegVillage').combobox('getText'));
		var RegRoad = $.trim($('#txtRegRoad').val());
	
		var RegAddress = RegProvinceDesc + RegCityDesc + RegCountyDesc + RegVillageDesc + RegRoad;
		//生前住址(省市县乡)
		var CurrProvince = $.trim($('#cboCurrProvince').combobox('getValue'));
		var CurrCity = $.trim($('#cboCurrCity').combobox('getValue'));
		var CurrCounty = $.trim($('#cboCurrCounty').combobox('getValue'));
		var CurrVillage = $.trim($('#cboCurrVillage').combobox('getValue'));
		var CurrProvinceDesc = $.trim($('#cboCurrProvince').combobox('getText'));
		var CurrCityDesc = $.trim($('#cboCurrCity').combobox('getText'));
		var CurrCountyDesc = $.trim($('#cboCurrCounty').combobox('getText'));
		var CurrVillageDesc = $.trim($('#cboCurrVillage').combobox('getText'));
		var CurrRoad = $.trim($('#txtCurrRoad').val());
		var CurrAddress = CurrProvinceDesc + CurrCityDesc + CurrCountyDesc + CurrVillageDesc + CurrRoad;
	
		var RepNo = $.trim($('#txtDeathNo').val());                                     //报告编号
		var DeathNo = $.trim($('#txtDeathNo').val());                                   //死亡编号
		var DeathDate = $('#txtDeathDate').datebox('getValue');                 //死亡日期
		var DeathTime = $('#txtDeathTime').timespinner('getValue');             //死亡时间
		                                                                        
		var ExamMedical = $.trim($('#txtExamMedical').val());                           //死者生前病史及症状体征
		ExamMedical =ExamMedical.replace(/["^,\\]/g, " ");                      
		ExamMedical = ExamMedical.replace(/\n/g," ");		// 替换所有的\n为空格符，便于保存时去掉“\n”
		var ExamDeathReason = $.trim($('#txtExamDeathReason').val());                   //死亡推断
		var DeathPlace = $.trim($('#cboDeathPlace').combobox('getValue'));              //死亡地点
		var AReason = $.trim($('#cboAReason').lookup('getText'));                       //A诊断
		var AReasonICD = $.trim($('#txtAReasonICD').val());                             //A诊断ICD10
		var AInterval = $.trim($('#txtAInterval').val());                               //时间间隔
		var ATime = $.trim($('#cboATime').combobox('getValue'));                        //时间单位
		if (AReasonICD==""){    //输入非标准诊断不保存
			AReason="";
			AInterval="";
			ATime="";
		}
		var BReason = $.trim($('#cboBReason').lookup('getText'));                        //B诊断
		var BReasonICD = $.trim($('#txtBReasonICD').val());                              //B诊断ICD10
		var BInterval = $.trim($('#txtBInterval').val());                                //时间间隔
		var BTime = $.trim($('#cboBTime').combobox('getValue'));                         //时间单位
		if (BReasonICD==""){      //输入非标准诊断不保存                                                   
			BReason="";                                                       
			BInterval="";                                                        
			BTime="";                                                            
		}                                                                        
		var CReason = $.trim($('#cboCReason').lookup('getText'));                        //C诊断
		var CReasonICD = $.trim($('#txtCReasonICD').val());                              //C诊断ICD10
		var CInterval = $.trim($('#txtCInterval').val());                                //时间间隔
		var CTime = $.trim($('#cboCTime').combobox('getValue'));                         //时间单位
		if (CReasonICD==""){       //输入非标准诊断不保存                                                 
			CReason="";                                                       
			CInterval="";                                                        
			CTime="";                                                            
		}                                                                        
		var DReason = $.trim($('#cboDReason').lookup('getText'));                        //D诊断
		var DReasonICD = $.trim($('#txtDReasonICD').val());                              //D诊断ICD10
		var DInterval = $.trim($('#txtDInterval').val());                                //时间间隔
		var DTime = $.trim($('#cboDTime').combobox('getValue'));                         //时间单位
		if (DReasonICD==""){       //输入非标准诊断不保存                                             
			DReason="";
			DInterval="";
			DTime="";
		}
	
		var OtherDiagnose = $.trim($('#cboOtherDiagnose').lookup('getText'));             //其他诊断
		var OtherDiagnoseICD = $.trim($('#txtOtherDiagnoseICD').val());                   //其他诊断ICD
		if (OtherDiagnoseICD=="") OtherDiagnose='';    //输入非标准诊断不保存
		var OtherDiagnoseInterval = $.trim($('#txtOtherDiagnoseInterval').val());         //时间间隔
		var OtherDiagnoseTime = $.trim($('#cboOtherDiagnoseTime').combobox('getValue'));  //时间单位
		var DamageDiagnose = $.trim($('#cboDamageDiagnose').lookup('getText'));           //损伤中毒诊断
		var DamageDiagnoseICD = $.trim($('#txtDamageDiagnoseICD').val());                 //损伤中毒诊断ICD10
		if (DamageDiagnoseICD=="") DamageDiagnose=''; //输入非标准诊断不保存
		var DiagnoseUnit = $.trim($('#cboDiagnoseUnit').combobox('getValue'));            //诊断单位
		var DiagnoseBasis = $.trim($('#cboDiagnoseBasis').combobox('getValue'));          //诊断依据
		var ResumeText = $.trim($('#txtResume').val());                                   //备注
		                                                                          
		var BaseReason = $.trim($('#cboBaseReason').lookup('getText'));                   //根本死因
		var BaseReasonICD = $.trim($('#txtBaseReasonICD').val());                         //根本死因ICD10
		if (BaseReasonICD=="") BaseReason='';  //输入非标准诊断不保存
		var Damage = $.trim($('#cboDamage').lookup('getText'));                           //损伤中毒
		var DamageICD = $.trim($('#txtDamageICD').val());                                 //损伤中毒ICD10
		if (DamageICD=="") Damage='';           //输入非标准诊断不保存
		var ExamName = $.trim($('#txtExamName').val());                                   //被调查者
		var ExamRelation = $.trim($('#cboExamRelation').combobox('getValue'));            //被调查者与死者关系
		var ExamAddress = $.trim($('#txtExamAddress').val());                             //被调查者地址
		var ExamTel = $.trim($('#txtExamTel').val());                                     //被调查者电话
		
		//死因推断为空，调查日期置为空
		if (ExamDeathReason==""){
		   var ExamDate=""                                                         //调查日期
		} else {                                                                    
		   var ExamDate = $('#txtExamDate').datebox('getValue');                   //调查日期
		}                                                                         
		var ExamUserDR = $.trim($('#txtExamUser').val());                                  //调查人
		var RepUsrDR=ReportUser;                                                   //报告人
		var IsJohnDoe = $('#chkJohnDoe').checkbox('getValue')? 1:0;                //无名氏
		var IsNewBorn = $('#chkNewBorn').checkbox('getValue')? 1:0;                //新生儿
		var Household="";                                                         
		
		var inStr = ReportID;
		inStr = inStr + separate + PatientID;         //PatientID 2
		inStr = inStr + separate + Name;              //患者姓名 3
		inStr = inStr + separate + RepNo;             //报告编号 4
		inStr = inStr + separate + RepUsrDR;          //报告人 5
		inStr = inStr + separate + RepStatus;         //报告状态 6
		inStr = inStr + separate + PapmiNo;           //登记号 7
		inStr = inStr + separate + Age;               //年龄 8
		inStr = inStr + separate + Sex;               //性别 9
		inStr = inStr + separate + Identify;          //证件号码（身份证号）10
		inStr = inStr + separate + Birthday;          //出生日期 11
		inStr = inStr + separate + Country;           //国家或地区 12
		inStr = inStr + separate + Nation;            //民族 13
		inStr = inStr + separate + Marital;           //婚姻状况 14
		inStr = inStr + separate + Education;         //文化程度 15
		inStr = inStr + separate + Occupation;        //职业 16
		inStr = inStr + separate + '';                //工种 17
		inStr = inStr + separate + Company;           //工作单位 18
		inStr = inStr + separate + Pregnancies;       //孕产情况 19
		inStr = inStr + separate + RegAddress;        //户籍地址 20
		inStr = inStr + separate + CurrAddress;       //生前住址 21
		inStr = inStr + separate + FamName;           //家属姓名22
		inStr = inStr + separate + FamRelation;       //与死者关系 23
		inStr = inStr + separate + FamTel;            //家属电话 24
		inStr = inStr + separate + FamAddr;           //家属住址25
		inStr = inStr + separate + DeathNo;           //死亡编号 26
		inStr = inStr + separate + DeathDate;         //死亡日期 27
		inStr = inStr + separate + DeathTime;         //死亡时间 28
		inStr = inStr + separate + DeathPlace;        //死亡地点 29
		inStr = inStr + separate + BaseReason;        //根本死因 30 
		inStr = inStr + separate + BaseReasonICD;     //根本死因ICD 31
		inStr = inStr + separate + Damage;            //损失中毒 32
		inStr = inStr + separate + DamageICD;         //损失中毒ICD 33
		inStr = inStr + separate + AReason;           //A死因 34
		inStr = inStr + separate + AInterval;         //A时间间隔 35 
		inStr = inStr + separate + BReason;           //B死因 36
		inStr = inStr + separate + BInterval;         //B时间间隔 37
		inStr = inStr + separate + CReason;           //C死因 38
		inStr = inStr + separate + CInterval;         //C时间间隔 39
		inStr = inStr + separate + DReason;           //D死因 40
		inStr = inStr + separate + DInterval;         //D时间间隔 41
		inStr = inStr + separate + OtherDiagnose;     //其他诊断 42
		inStr = inStr + separate + DiagnoseUnit;      //诊断单位  43
		inStr = inStr + separate + DiagnoseBasis;     //诊断依据 44
		inStr = inStr + separate + ResumeText;        //备注 45
		inStr = inStr + separate + ExamMedical;       //死者生前病史及症状体征 46 
		inStr = inStr + separate + ExamName;          //被调查者 47
		inStr = inStr + separate + ExamRelation;      //被调查者与死者关系 48
		inStr = inStr + separate + ExamTel;           //被调查则联系电话 49
		inStr = inStr + separate + ExamDeathReason;   //调查死因推断 50
		inStr = inStr + separate + ExamAddress;       //被调查者住址 51
		inStr = inStr + separate + ExamUserDR;        //调查人 52
		inStr = inStr + separate + ExamDate;          //调查日期 53
		inStr = inStr + separate + ReportLoc;         //报告科室 54
		inStr = inStr + separate + Household;         //户籍性质 55
		inStr = inStr + separate + MrNo;              //病案号  56
		inStr = inStr + separate + DamageDiagnose;    //损伤中毒诊断 57
		inStr = inStr + separate + AReasonICD;        //A死因ICD10 58
		inStr = inStr + separate + BReasonICD;        //B死因ICD10 59
		inStr = inStr + separate + CReasonICD;        //C死因ICD10 60
		inStr = inStr + separate + DReasonICD;        //D死因ICD10 61
		inStr = inStr + separate + DamageDiagnoseICD; //损伤中毒诊断 62
		inStr = inStr + separate + ATime;             //A时间间隔单位ID 63
		inStr = inStr + separate + BTime;             //B时间间隔单位ID 64
		inStr = inStr + separate + CTime;             //C时间间隔单位ID 65
		inStr = inStr + separate + DTime;             //D时间间隔单位ID 66
		inStr = inStr + separate + CardType;          //证件类型 67
		inStr = inStr + separate + IsJohnDoe;         //是否无名氏 68
		inStr = inStr + separate + CurrProvince;      //生前住址省 69
		inStr = inStr + separate + CurrCity;          //生前住址市 70
		inStr = inStr + separate + CurrCounty;        //生前住址县 71
		inStr = inStr + separate + EpisodeID;         //就诊号 72
		inStr = inStr + separate + '';                //A死因编码 73
		inStr = inStr + separate + '';                //B死因编码 74
		inStr = inStr + separate + '';                //C死因编码 75
		inStr = inStr + separate + '';                //D死因编码 76
		inStr = inStr + separate + '';                //A死因编码ICD 77
		inStr = inStr + separate + '';                //B死因编码ICD 78
		inStr = inStr + separate + '';                //C死因编码ICD 79
		inStr = inStr + separate + '';                //D死因编码ICD 80
		inStr = inStr + separate + CurrVillage;       //生前住址乡 81
		inStr = inStr + separate + RegProvince;       //户籍地址省 82
		inStr = inStr + separate + RegCity;           //户籍地址市 83
		inStr = inStr + separate + RegCounty;         //户籍地址县 84
		inStr = inStr + separate + RegVillage;        //户籍地址乡 85
		inStr = inStr + separate + FamCardTypeId;     //家属证件类型 86
		inStr = inStr + separate + FamIdentify;       //家属证件号码 87
		inStr = inStr + separate + RegRoad;           //户籍地址村（小区） 88
		inStr = inStr + separate + CurrRoad;          //生前住址村（小区） 89
		inStr = inStr + separate + OtherDiagnoseICD;  //其他诊断ICD  90
		inStr = inStr + separate + '';                //其他诊断死因编码 91
		inStr = inStr + separate + '';                //其他诊断死因编码ICD 92
		inStr = inStr + separate + OtherDiagnoseInterval;      //其他诊断时间间隔 93
		inStr = inStr + separate + OtherDiagnoseTime;          //其他诊断时间单位 94
		inStr = inStr + separate + IsNewBorn;          //新生儿 95
		
		return inStr;
	}
	
	//保存死亡证方法
	obj.SaveData = function(RepStatus){
		var separate="^";
		var inStr = obj.SaveToString(RepStatus, separate);		// 主卡字符串
	
		var retValue = $m({                  
			ClassName:"DHCMed.DTH.Report",
			MethodName:"Update",
			instr:inStr, 
			separate:separate
		},false);
		if (retValue>0){
			ReportID=retValue;
			var Age = inStr.split(separate)[7];
			var RepUsrDR = inStr.split(separate)[4];
			var ReportLoc = inStr.split(separate)[53];
			
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:ReportID
		        });
		    	history.pushState("", "", Url);
			}
			if ($('#chkRepMaternal').checkbox('getValue')) {
				var MReportID = $m({                  
					ClassName:"DHCMed.DTH.MaternalReport",
					MethodName:"GetRepIDByDthID",
					DthRepID:ReportID
				},false);
				
				var strArg = MReportID + separate;
				strArg += PatientID +separate;
				strArg += EpisodeID +separate;
				strArg += ReportID +separate;
				// 死亡证明书编号
				strArg += '' +separate;  //5
				// 姓名
				strArg += $.trim($('#txtName').val()) + separate;
				// 常住址 省
				strArg +=$.trim($('#cboConProvince').combobox('getValue')) + separate;
				// 常住址 市
				strArg +=$.trim($('#cboConCity').combobox('getValue')) + separate;
				// 常住址 县
				strArg +=$.trim($('#cboConCounty').combobox('getValue')) + separate;
				strArg +=$.trim($('#cboConVillage').combobox('getValue'))+ separate;                                    //10
				strArg +=""+ separate;
				// 暂住址 省
				strArg +=$.trim($('#cboTempProvince').combobox('getValue')) + separate; 
				// 暂住址 市
				strArg +=$.trim($('#cboTempCity').combobox('getValue')) + separate;
				// 暂住址 县
				strArg +=$.trim($('#cboTempCounty').combobox('getValue')) + separate;
				strArg +=$.trim($('#cboTempVillage').combobox('getValue')) + separate;                                  //15
				strArg +=""+ separate;
	
				// 户口
				strArg +=$.trim($('#cboMRegType').combobox('getValue')) + separate;
				// 计划内外
				strArg +=$.trim($('#cboIsPlan').combobox('getValue')) + separate;
				// 年龄
				strArg += Age + separate;   
				//民族
				strArg +=$.trim($('#cboNation').combobox('getValue')) + separate;    //20
				//文化程度
				strArg +=$.trim($('#cboMEducation').combobox('getValue')) + separate;
				// 家庭年人均收入
				strArg +=$.trim($('#cboFamilIncome').combobox('getValue')) + separate;
				// 居住地区
				strArg +=$.trim($('#cboConType').combobox('getValue')) + separate;
				// 孕次
				strArg +=$.trim($('#txtPreTimes').val()) + separate; 
				// 产次
				strArg +=$.trim($('#txtProTimes').val()) + separate;  //25
				// 人工流产、引产次
				strArg +=$.trim($('#txtLaborTimes').val()) + separate;
				// 末次月经
				strArg +=$('#dtLastMenDate').datebox('getValue') + separate;
				// 分娩日期
				strArg +=$('#dtDeliveryDate').datebox('getValue') + separate;
				// 分娩时间
				strArg +=$.trim($('#txtDeliveryTime').val()) + separate;  
				// 死亡日期
				strArg +=$('#dtMDeathDate').datebox('getValue') + separate; //30
				// 死亡时间
				strArg +=$.trim($('#txtMDeathTime').val()) + separate;
				// 分娩地点
				strArg +=Common_RadioValue('radDeliveryPosList') + separate;
				// 死亡地点
				strArg +=Common_RadioValue('radDeathPosList') + separate;
				// 分娩方式
				strArg +=Common_RadioValue('radDeliveryWayList') + separate; 
				// 新法接生
				strArg +=$.trim($('#cboIsNewWay').combobox('getValue')) + separate; //35
				// 接生者
				strArg +=$.trim($('#cboDeliveryer').combobox('getValue')) + separate;
				// 产前检查
				strArg +=$.trim($('#cboIsPreCheck').combobox('getValue')) + separate;
				// 初检孕周
				strArg +=$.trim($('#txtPregWeek').val()) + separate;  
				// 产检次数
				strArg +=$.trim($('#txtPregCheckTime').val()) + separate; 
				// 死因诊断依据
				strArg +=$.trim($('#cboMDiagnoseBasis').combobox('getValue')) + separate; //40
				// 省级医疗保健机构评审结果
				strArg +=Common_RadioValue('radProResultList') + separate;
				// 省级 影响死亡的主要因素
				strArg +=Common_RadioValue('radProReasonList') + separate;	
				// 国家级评审结果
				strArg +=Common_RadioValue('radConResultList') + separate;
				// 国家 影响死亡的主要因素
				strArg +=Common_RadioValue('radConReasonList') + separate;
				
				strArg += RepUsrDR + separate;
				strArg += ReportLoc + separate;
				strArg += RepUsrDR + separate;
				strArg += '' + separate;
				strArg += '' + separate;
				strArg += RepStatus + separate;
				// 末次月经分类
				strArg +=Common_RadioValue('radLastMenList') + separate;
				// 分娩时间分类
				strArg +=Common_RadioValue('radDeliDateList') + separate; 
				// 死因分类
				strArg +=$.trim($('#cboMCategory').combobox('getValue')) + separate;
				
				var ret = $m({                  
					ClassName:"DHCMed.DTH.MaternalReport",
					MethodName:"Update",
					aInput:strArg, 
					aSeparate:separate
				},false);
				if (ret>0 ) {
					$.messager.alert("提示","报告"+(RepStatus==1?"上报":"保存")+"成功!", 'info');
					obj.InitRepPowerByStatus();
					obj.InitRepByReportID();
					obj.InitMRepByReportID();
					return ReportID;
				}else {
					$.messager.alert("提示", "孕产妇死亡副卡信息保存失败！", 'info');
					return ;
				}
			}
			
			if ((Age.indexOf($g('岁'))>-1)||(Age.indexOf($g('未知'))>-1)) {
				//var CurrAge = Age.replace("岁", "");
				var arrCurrAge = Age.split($g("岁")); 
				var CurrAge = arrCurrAge[0];
				debugger;  
				if ((CurrAge >= 5)||(Age.indexOf($g('未知'))>-1)) {
					$.messager.alert($g("提示"),$g("报告")+(RepStatus==1?"上报":"保存")+"成功!", 'info');
					obj.InitRepPowerByStatus();  //不可以使用obj.LoadEvent(); 否则界面上反复操作时，会多次插入数据和弹出提示 
					obj.InitRepByReportID();
					return ReportID;
				}
			}
			
			var chReportID = $m({                  
				ClassName:"DHCMed.DTH.ChildReport",
				MethodName:"GetRepIDByDthID",
				DthRepID:ReportID
			},false);
		 
			var strArg = chReportID + separate;
			strArg += PatientID +separate;
			strArg += EpisodeID +separate;
			strArg += ReportID +separate;
			// 姓名
			strArg += $.trim($('#txtName').val()) + separate;
			// 父亲姓名
			strArg += $.trim($('#txtFatherName').val()) + separate;
			// 母亲姓名
			strArg += $.trim($('#txtMotherName').val()) + separate;
			//  联系电话
			strArg += $.trim($('#txtFamTel').val()) + separate;
			// 性别 1--男 2--女 3--性别不明
			strArg += $.trim($('#cboSex').combobox('getValue')) + separate;
			// 出生日期
			strArg += $.trim($('#txtBirthday').datebox('getValue')) + separate;
			// 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
			strArg += $.trim($('#cboRegType').combobox('getValue')) + separate;
			// 出生体重
			strArg += $.trim($('#txtWeight').val()) + separate;
			// 出生体重类别：1--测量 2--估计
			strArg += $.trim($('#cboWeightType').combobox('getValue')) + separate;
			// 怀孕___周
			strArg += $.trim($('#txtPregnancyWeek').val()) + separate;
			// 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
			strArg += $.trim($('#cboBirthdayPlace').combobox('getValue')) + separate;
			// 死亡日期
			strArg += $('#txtDeathDate').datebox('getValue') + separate;
			// 死亡年龄 年
			strArg += $.trim($('#txtDeathAgeYear').val()) + separate;
			// 死亡年龄 月
			strArg += $.trim($('#txtDeathAgeMonth').val()) + separate;
			// 死亡年龄 日
			strArg += $.trim($('#txtDeathAgeDay').val()) + separate;
			// 死亡地点 1--医院 2--途中 3--家中
			strArg += $.trim($('#cboDeathPosition').combobox('getValue')) + separate;
			// 死亡前治疗 1--住院 2--门诊 3--未治疗
			strArg += $.trim($('#cboCareBeforeDeath').combobox('getValue')) + separate;
			// 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
			strArg += $.trim($('#cboDiagnoseLv').combobox('getValue')) + separate;
			// 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
			strArg += $.trim($('#cboNotCareReason').combobox('getValue')) + separate;
			// 未治疗或未就医主要原因（需要注明原因）
			strArg += $.trim($('#txtNotCareReasonTxt').val()) + separate;
			// 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
			strArg += $.trim($('#cboChildDiagBasis').combobox('getValue')) + separate;
			// 分类编号 01-痢疾 02--败血症 03-麻疹 ...
			strArg += $.trim($('#cboCategory').combobox('getValue'))+ separate;
			// ICD-10编码
			strArg += $.trim($('#txtICD10').val()) + separate;
			strArg += RepUsrDR + separate;
			strArg += ReportLoc + separate;
			strArg += RepUsrDR + separate;
			strArg += '' + separate;        //报告日期
			strArg += '' + separate;        //报告时间
			strArg += RepStatus + separate;
			// 死亡证编号
			strArg += $.trim($('#txtDeathNo').val()) + separate;
			// 是否补卡
			strArg += ($('#chkIsReplenish').checkbox('getValue')? 1:0 )+ separate;
			// 死亡年龄 时
			strArg += $.trim($('#txtDeathAgeHour').val()) + separate;
			
			var ret = $m({                  
				ClassName:"DHCMed.DTH.ChildReport",
				MethodName:"Update",
				aInput:strArg, 
				aSeparate:separate
			},false);
			
			if (ret>0 ) {
				$.messager.alert("提示","报告"+(RepStatus==1?"上报":"保存")+"成功!", 'info');
				obj.InitRepPowerByStatus();
				obj.InitRepByReportID();
				obj.InitChRepByReportID();
				return ReportID;
			}else {
				$.messager.alert("提示", "5岁以下儿童死亡信息保存失败！", 'info');
				return;
			}
			
		}else if(retValue==-200){
			$.messager.alert("错误提示","死亡证不允许重复填报!", 'info');
			return;
		}else {
			$.messager.alert("错误提示","数据中存在不规范字符!", 'info');
			return;	
		}
	}
	// 按钮触发事件
	obj.RelationToEvents = function() {
		$('#btnReport').on("click", function(){
			obj.btnReport_Click(); 
		});
		$('#btnPrintPatInfo').on("click", function(){
			obj.btnPrintPatInfo_Click();
		});
		$('#btnSaveTmp').on("click", function(){
			obj.btnSaveTmp_Click(); 
		});
		$('#btnCheckOne').on("click", function(){
			obj.btnCheckOne_Click(); 
		});
		$('#btnPrintOne').on("click", function(){
			//obj.btnPrintOne_Click();
			//CA签名验证
			CASignLogonModal('DTH','PrintDHTReport',{
				// 不保存签名数据
				signSave: false
			},obj.btnPrintOne_Click);
		});
		$('#btnPrintThree').on("click", function(){
			//obj.btnPrintThree_Click(); 
			//CA签名验证
			CASignLogonModal('DTH','PrintDHTReport',{
				// 不保存签名数据
				signSave: false
			},obj.btnPrintThree_Click);
		});
		$('#btnCancle').on("click", function(){
			obj.btnCancle_Click(); 
		});
		$('#btnGrantThree').on("click", function(){
			obj.btnGrantThree_Click(); 
		});
		$('#btnGrantOne').on("click", function(){
			obj.btnGrantOne_Click(); 
		});
		$('#btnCheckTwo').on("click", function(){
			obj.btnCheckTwo_Click(); 
		});
		$('#btnUnCheck').on("click", function(){
			obj.btnUnCheck_Click(); 
		});
		$('#btnDel').on("click", function(){
			obj.btnDel_Click(); 
		});
		$('#btnHelpWord').on("click", function(){
			obj.btnHelpWord_Click(); 
		});
		$('#btnReturn').on("click", function(){
			obj.btnReturn_Click(); 
		});
		$('#btnPrintChild').on("click", function(){ 
			obj.btnPrintChild_Click();
		});
		$('#btnPrintMaternal').on("click", function(){ 
			obj.btnPrintMaternal_Click();
		});
	}
	
	
	    // 获取病人年龄
	obj.GetPatAge = function (aDate,aTime) {  
		var Age = $m({       
			ClassName:"DHCMed.SSIO.FromHisSrv",
			MethodName:"GetPapmiAge",
			aPatientID:PatientID,
			aEpisodeID:EpisodeID,
			aDate:aDate,
			aTime:aTime
		},false);
		return Age;
	}
	
	//判断状态字典是否存在项目
	obj.DicManage = function (aType,aCode) {   //返回为对象的方法需重新写	
		var objDicManage = $cm({                  
			ClassName:"DHCMed.SSService.DictionarySrv",
			MethodName:"GetObjByCode",
			argType:aType,
			argCode:aCode,
			argIsActive:1
		},false);
		if ($.isEmptyObject(objDicManage)) return false;   //判断对象是否为空
		return objDicManage;
	}
	//根据字典描述获取字典对象
	obj.Dictionary = function (aType,aDesc) {   //返回为对象的方法需重新写	
		var Dictionary = $cm({                  
			ClassName:"DHCMed.SSService.DictionarySrv",
			MethodName:"GetObjByDesc",
			argType:aType, 
			argDesc:aDesc, 
			argIsActive:1 
		},false);
		if ($.isEmptyObject(Dictionary)) return false;   //判断对象是否为空
		
		return Dictionary;
	}
	
	$HUI.checkbox("#chkRepMaternal",{
        onUnchecked:function(event,value){
            $('#MaternalInfoDiv').css('display','none');
        }
    });
   
	$HUI.checkbox("#chkRepMaternal",{
		onChecked:function(event,value){
			$('#MaternalInfoDiv').removeAttr('style');
			$.parser.parse('#MaternalInfoDiv'); 
			obj.LoadMaternalInfo();
		    obj.LoadMaternalEvent();
		}
	});
	
	// 加载孕产妇副卡事件
	obj.LoadMaternalEvent = function () {
		$HUI.radio("[name='radLastMenList']",{  
			onCheckChange:function(e,value){
				var LastMenList = Common_RadioLabel("radLastMenList");   //当前选中的值
				if (LastMenList) {	
					$('#dtLastMenDate').datebox('clear');
					$('#dtLastMenDate').datebox('disable');
				}else{
					$('#dtLastMenDate').datebox('enable');	
				}
			}
		});
	   	$HUI.radio("[name='radDeliDateList']",{  
			onCheckChange:function(e,value){
				var DeliDateList = Common_RadioLabel("radDeliDateList");   //当前选中的值
				if (DeliDateList) {	
					$('#dtDeliveryDate').datebox('clear');
					$('#dtDeliveryDate').datebox('disable');
					$('#txtDeliveryTime').numberspinner('clear');
					$('#txtDeliveryTime').numberspinner('disable');
				}else{
					$('#dtDeliveryDate').datebox('enable');
					$('#txtDeliveryTime').numberspinner('enable');	
				}
			}
		});
		
		var Nation = $('#txtNation').val();
		obj.GetNation(Nation);
		$('#txtNation').bind('change', function (e) {
			Nation = $('#txtNation').val();
			obj.GetNation(Nation);
		});
		
		var DeathDate = $('#txtDeathDate').datebox('getValue');
		var DeathTime = $('#txtDeathTime').timespinner('getValue');
		if ((DeathDate!="")&&(DeathTime!="")) {
			obj.GetDeathDateTime(DeathDate,DeathTime);
		}
		$('#txtDeathDate').datebox({
			onChange: function(data) {
				DeathDate = $('#txtDeathDate').datebox('getValue');
				obj.GetDeathDateTime(DeathDate,DeathTime);
			}
		});
		$('#txtDeathDate').datebox('setValue',DeathDate);  //死亡日期被清空，需重新赋值
	
		$('#txtDeathTime').timespinner({
			onChange: function(time) {
				DeathTime = $('#txtDeathTime').timespinner('getValue');
				obj.GetDeathDateTime(DeathDate,DeathTime);
			}
		});
		
		var value = "";
	    $('#radProResultList label.radio').on('click', function(event){	   
		    var CheckValue = Common_CheckboxValue('radProResultList');
			if(value == CheckValue) {
				$HUI.radio('input[type=radio][name=radProResultList]').uncheck();
				value = "";
			}else {
				value = CheckValue;
			}
	    });
	   
	    var value = "";
	    $('#radConResultList label.radio').on('click', function(event){	   
		    var CheckValue = Common_CheckboxValue('radConResultList');
			if(value == CheckValue) {
				$HUI.radio('input[type=radio][name=radConResultList]').uncheck();
				value = "";
			}else {
				value = CheckValue;
			}
	    });
	    var value = "";
	    $('#radConReasonList label.radio').on('click', function(event){	   
		    var CheckValue = Common_CheckboxValue('radConReasonList');
			if(value == CheckValue) {
				$HUI.radio('input[type=radio][name=radConReasonList]').uncheck();
				value = "";
			}else {
				value = CheckValue;
			}
	    });
	    var value = "";
	    $('#radProReasonList label.radio').on('click', function(event){	   
		    var CheckValue = Common_CheckboxValue('radProReasonList');
			if(value == CheckValue) {
				$HUI.radio('input[type=radio][name=radProReasonList]').uncheck();
				value = "";
			}else {
				value = CheckValue;
			}
	    });   
	} 
   
	// 获取孕产妇副卡民族
	obj.GetNation = function(Nation) {
		if (($.trim(Nation)!='')&&($.trim(Nation) !='汉族')) {
			Nation = '少数民族';
		}
		objNation = obj.Dictionary('DTMNation',Nation);	
		if (objNation) {
			$('#cboNation').combobox('setValue',objNation.ID);
			$('#cboNation').combobox('setText',objNation.Description);
		} else {
			$('#cboNation').combobox('clear');
		}
	}
	
	// 孕产妇副卡死亡日期时间
	obj.GetDeathDateTime = function(aDate,aTime) {
		$('#dtMDeathDate').datebox('setValue',aDate);
		var Hour = aTime.split(':')[0];
		var Min = aTime.split(':')[1];
		if (Hour!="") {
			if (Min>=30) {
				Hour = parseInt(Hour)+1;
				Hour = (Hour<10?('0'+Hour):Hour);
			}
			$('#txtMDeathTime').val(Hour);
		}
	}

	// 获取5岁以下儿童的性别
	obj.GetChRepSex = function(Sex) {
		if (Sex=='') {
			Sex = '性别不明';
		}
		objSex = obj.Dictionary('DTCSex',Sex);
		if (objSex) {
			$('#cboSex').combobox('setValue',objSex.ID); 
			$('#cboSex').combobox('setText',objSex.Description);
		} else {
			$('#cboSex').combobox('enable');
		}
	}
	
	// 获取5岁以下儿童的年龄
	obj.GetChRepAge = function(Age) {
		if (Age.indexOf('岁')>-1) {
			var AgeYear = Age.split('岁')[0];
			var tmpAge = Age.split('岁')[1];
			$('#txtDeathAgeYear').val(AgeYear);
			if (tmpAge.indexOf('月')>-1) {
				var AgeMonth = tmpAge.split('月')[0];
				var tmpAge = tmpAge.split('月')[1];
				$('#txtDeathAgeMonth').val(AgeMonth); 
				if (tmpAge.indexOf('天')>-1) {
					var AgeDay = tmpAge.split('天')[0];
					var tmpAge = tmpAge.split('天')[1];
					$('#txtDeathAgeDay').val(AgeDay); 
					if (tmpAge.indexOf('小时')>-1) {
						var AgeHour = tmpAge.split('小时')[0];
						$('#txtDeathAgeHour').val(AgeHour); 
					}
				}
			}		
		}else if (Age.indexOf('月')>-1) {
			var AgeMonth = Age.split('月')[0];
			var tmpAge = Age.split('月')[1];
			$('#txtDeathAgeMonth').val(AgeMonth); 
			if (tmpAge.indexOf('天')>-1) {
				var AgeDay = tmpAge.split('天')[0];
				var tmpAge = tmpAge.split('天')[1];
				$('#txtDeathAgeDay').val(AgeDay); 
				if (tmpAge.indexOf('小时')>-1) {
					var AgeHour = tmpAge.split('小时')[0];
					$('#txtDeathAgeHour').val(AgeHour); 
				}
			}
		} else if (Age.indexOf('天')>-1) {
			var AgeDay = Age.split('天')[0];
			var tmpAge = Age.split('天')[1];
			$('#txtDeathAgeDay').val(AgeDay); 
			if (tmpAge.indexOf('小时')>-1) {
				var AgeHour = tmpAge.split('小时')[0];
				$('#txtDeathAgeHour').val(AgeHour); 
			}
		} else if (Age.indexOf('小时')>-1) {
			var AgeHour = Age.split('小时')[0];
			$('#txtDeathAgeHour').val(AgeHour); 
		}
	}

	
	
	//*******************************************按钮事件  ↓↓↓
	//暂存按钮触发事件
	obj.btnSaveTmp_Click = function(){
		if ((obj.RepStatusCode==2)||(obj.RepStatusCode==3)) {
			$.messager.alert("提示","已编码或已审核的报告,不允许再修改!", 'info');
			return;
		}
		obj.SaveData(6);
	}
	
	//打印核对信息按钮触发事件
	obj.btnPrintPatInfo_Click = function(){	
		if (ReportID==""){
			$.messager.alert("提示","打印失败！找不到这份报告" , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintDTHBaseInfo");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.dth.lodopbaseinfo.csp?ReportID="+ReportID);
		LODOP.PRINT();			//直接打印
	
		/*try {
			ExportBaseDataToExcel("","","",ReportID);
			window.location.reload();
		} catch(e) {
			$.messager.alert("错误提示","打印核对信息出错!Error：" + e.message, 'info');
		}*/
	}
	//5岁以下儿童死亡报告打印按钮触发事件
	obj.btnPrintChild_Click = function(){
		
		if (ReportID==""){
			$.messager.alert("提示","打印失败！找不到这份报告" , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintDTHChildInfo");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.dth.lodopchild.csp?ReportID="+ReportID);
		LODOP.PRINT();			//直接打印
		
	
		/*try {
			ExportChildDataToExcel(ReportID);
			window.location.reload();
		} catch(e) {
			$.messager.alert("错误提示","打印5岁以下儿童死亡报告信息出错!Error：" + e.message, 'info');
		}*/
	}
	
	//孕产妇死亡副卡打印打印按钮触发事件
	obj.btnPrintMaternal_Click = function(){
		if (ReportID==""){
			$.messager.alert("提示","打印失败！找不到这份报告" , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintDTHMomInfo");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.dth.lodopmother.csp?ReportID="+ReportID);
		LODOP.PRINT();			//直接打印
		/*	
		try {
			ExportMaDataToExcel(ReportID);
			window.location.reload();
		} catch(e) {
			$.messager.alert("错误提示","打印孕产妇死亡副卡信息出错!Error：" + e.message, 'info');
		}*/
	}
	
	//上报按钮单击事件
	obj.btnReport_Click = function(){
		//已审核的报告，不允许再修改
		if ((obj.RepStatusCode==2)||(obj.RepStatusCode==3)) {
			$.messager.alert("提示","已编码或已审核的报告,不允许再修改!", 'info');
			return;
		}
		//非无名氏或新生儿报告，数据完整性校验
		if (($('#chkJohnDoe').checkbox('getValue')=='')&&($('#chkNewBorn').checkbox('getValue')=='')) {
			var ret=obj.CheckRepData();
			if(ret!=""){
				$.messager.alert("提示",'<div style="min-height:20px;max-height:400px;overflow:auto">' + ret + '</div>', 'info');
				return;	
			}
		}else {
			var ret=obj.CheckDeathDate();
			if(ret!=""){
				$.messager.alert("提示",'<div style="min-height:20px;max-height:400px;overflow:auto">' + ret + '</div>', 'info');
				return;	
			}
		}
		//保存死亡证
		//obj.SaveData(1);
		//CA签名验证
		CASignLogonModal('DTH','SaveDHTReport',{
			// 签名数据
			signData: obj.SaveToString()
		},obj.SaveData,1);
	}
	//二审按钮触发事件
	obj.btnCheckTwo_Click = function(){
		var status = 3;
		var resumeText = '';
		var retValue = ChangeDMRepStatus(status,resumeText)
		if ((retValue>-1)){
			$.messager.popover({msg: '审核成功',type:'success',timeout: 2000});
			obj.InitRepPowerByStatus();
		}
	}
	//取消审核按钮触发事件
	obj.btnUnCheck_Click = function(){
		var status = 2;
		var resumeText = '';
		var retValue = ChangeDMRepStatus(status,resumeText)
		if ((retValue>-1)){
			$.messager.popover({msg: '取消审核成功',type:'success',timeout: 2000});
			obj.InitRepPowerByStatus();
		}
	}
	//作废按钮触发事件
	obj.btnDel_Click = function(){
		$.messager.confirm("提示", "请确认是否作废?", function (r) {
			if (r){
				var status = 5;
				var resumeText = '';
				var retValue = ChangeDMRepStatus(status,resumeText);
				if ((retValue>-1)){
					$.messager.popover({msg: '作废成功！',type:'success',timeout: 2000});
					var RecycleInfo = ""+"^"+ReportID+"^"+$("#txtDeathNo").val()+"^"+"";
					obj.CodeRecycle(RecycleInfo,"^");
					obj.InitRepPowerByStatus();
				}else {
					$.messager.alert("提示","作废失败!", 'info');
				}
			}
		});
	}
	//退回按钮触发事件
	obj.btnReturn_Click = function(){
		$.messager.prompt("退回", "请输入退回原因!", function (r) {
			if (r){
				var status = 9;
				var retValue = ChangeDMRepStatus(status,r);
			
				if ((retValue>-1)){
					$.messager.alert("提示","退回成功!", 'info');
					obj.InitRepPowerByStatus();
				} else {
					$.messager.alert("提示","退回失败!", 'info');
				}
			}else if(r==""){
				$.messager.alert("提示","请填写退回原因", 'info');
			}			
		});
	}
	//帮助文档按钮触发事件
	obj.btnHelpWord_Click=function(){
		var repTitile = $g('帮助文档-死亡证明书管理系统用户操作手册');
		websys_showModal({
			url:'../scripts/DHCMA/DTH/Document/死亡证明书管理系统用户操作手册.pdf',
			title:repTitile,
			iconCls:'icon-w-paper',     
			width:1200,
			height:window.screen.availHeight-80
		});
	}
	//编码按钮触发事件 2保健科审核
	obj.btnCheckOne_Click = function(){
		var ReportStatus = 2;
		var resumeText   = "";
		var inStr = "",separate = "^";
		
		var BaseReason    = $.trim($('#cboBaseReason').lookup('getText'));     //根本死因
		var BaseReasonICD = $.trim($('#txtBaseReasonICD').val());              //根本死因ICD
		if (BaseReasonICD.split("C02").length>1) {
			$.messager.alert("提示","根本死因诊断错误!", 'info');
			return;
		}
		var Damage = $.trim($('#cboDamage').lookup('getText'));                //损伤中毒
		var DamageICD = $.trim($('#txtDamageICD').val());                      //损伤中毒ICD
		var AReason = $.trim($('#cboAReason').lookup('getText'));              //A死因
		var AReasonICD = $.trim($('#txtAReasonICD').val());                    //A死因编码
		var BReason = $.trim($('#cboBReason').lookup('getText'));              //B死因
		var BReasonICD = $.trim($('#txtBReasonICD').val());                    //B死因编码
		var CReason = $.trim($('#cboCReason').lookup('getText'));              //C死因
		var CReasonICD = $.trim($('#txtCReasonICD').val());                    //C死因编码
		var DReason = $.trim($('#cboDReason').lookup('getText'));              //D死因
		var DReasonICD = $.trim($('#txtDReasonICD').val());                    //D死因编码
		var OtherDiagnose = $.trim($('#cboOtherDiagnose').lookup('getText'));  //其他死因
		var OtherDiagnoseICD = $.trim($('#txtOtherDiagnoseICD').val());        //其他死因编码
		var inStr = ReportID;                              //ReportID
		inStr = inStr + separate + BaseReason;             //根本死因
		inStr = inStr + separate + BaseReasonICD;          //根本死因ICD
		inStr = inStr + separate + Damage;                 //损伤中毒
		inStr = inStr + separate + DamageICD;              //损伤中毒ICD
		inStr = inStr + separate + AReason;                //A死因
		inStr = inStr + separate + BReason;                //A死因编码
		inStr = inStr + separate + CReason;                //B死因
		inStr = inStr + separate + DReason;                //B死因编码
		inStr = inStr + separate + AReasonICD;             //C死因  10
		inStr = inStr + separate + BReasonICD;             //C死因编码
		inStr = inStr + separate + CReasonICD;             //D死因
		inStr = inStr + separate + DReasonICD;             //D死因编码
		inStr = inStr + separate + OtherDiagnose;          //其他死因 14
		inStr = inStr + separate + OtherDiagnoseICD;       //其他死因编码 15
	    
		var retVal = $m({                  
			ClassName:"DHCMed.DTH.Report",
			MethodName:"UpdateDMRepDiagnose",
			instr:inStr, 
			separate:separate
		},false);
        
		if (parseInt(retVal)>0) {
			var retValue=ChangeDMRepStatus(ReportStatus,resumeText);
			if (parseInt(retValue)>0) {
				$.messager.alert("提示","编码保存成功!", 'info');
				if((!!AReason)&&(!!AReasonICD)){
					$('#txtAFPReason').val('[' + AReasonICD + ']' + AReason);
				}
				if((!!BReason)&&(!!BReasonICD)){
					$('#txtBFPReason').val('[' + BReasonICD + ']' + BReason);
				}
				if((!!CReason)&&(!!CReasonICD)){
					$('#txtCFPReason').val('[' + CReasonICD + ']' + CReason);
				}
				if((!!DReason)&&(!!DReasonICD)){
					$('#txtDFPReason').val('[' + DReasonICD + ']' + DReason);
				}
				if((!!OtherDiagnose)&&(!!OtherDiagnoseICD)){
					$('#txtOtherDiagnoseFP').val('[' + OtherDiagnoseICD + ']' + OtherDiagnose);
				}
				obj.InitRepPowerByStatus();
			} else {
				$.messager.alert("错误提示","保存审核状态错误!", 'info');
			}
		} else {
			$.messager.alert("错误提示","编码保存错误!", 'info');
		}
	}
	
	//加载纸单号弹出
	obj.LoadPaperNoWin = function(){
		var NewPaperNo = $m({      //获取未用纸单号              
			ClassName:"DHCMed.DTHService.PaperNoSrv",
			MethodName:"GetNewPaperNo"
		},false);
		
		var paperNo = $.trim($('#PaperNo').val());
		if ((SSHospCode=="11-DT")||(SSHospCode=="11-XH")){
			$('#PaperNo').val(NewPaperNo);
			$('#PaperNo').attr('disabled','disabled');
		}
		$('#PaperNoWin').window("open");
	}
	//保存纸单号
	obj.InitPaperNo = function() {
		var separate="^";
		var CtlocId=session['LOGON.CTLOCID'];
		var UserID=session['LOGON.USERID'];
		var StatusDR = 3;  //已用
		var retValue="";
		var paperNo = $.trim($('#PaperNo').val());
		
		if ((SSHospCode=="11-DT")||(SSHospCode=="11-XH")){
			if (!paperNo){
				$.messager.alert("提示","请联系统计室入库纸单号!", 'info');
				return;
			}
			var updateStr = paperNo+separate+StatusDR+separate+CtlocId+separate+CtlocId+separate+UserID+separate+ReportID;
			retValue = obj.ChangePaperNoStatus(updateStr);
		} else {
			var patrn=/^[0-9]{1,7}$/;
			if (!paperNo){
				$.messager.alert("提示","纸单号不能为空!", 'info');
				return;
			}
			if(!patrn.exec(paperNo)){
				$.messager.alert("提示","纸单号格式不正确，请输入1~7位数字!", 'info');
				return;
			}
			if (SSHospCode=="11-YY"){
				paperFlag = obj.CheckPaperNo(paperNo,CtlocId);
			} else {
				paperFlag = obj.CheckPaperNo(paperNo);
			}
			if (paperFlag=="0"){
				$.messager.alert("提示","纸单号不存在!", 'info');
				return;
			}else if(paperFlag=="1"){
				var updateStr = paperNo+separate+StatusDR+separate+CtlocId+separate+CtlocId+separate+UserID+separate+ReportID;
				retValue = obj.ChangePaperNoStatus(updateStr);
			} else {
				$.messager.alert("提示","纸单号已用!", 'info');
				return;
			}
		}
		
		if ((retValue>-1)){
			$.messager.alert("提示","保存成功!");
		    $('#PaperNoWin').window("close");
		} else {
			$.messager.alert("提示","保存失败!");
		}
		return retValue;
	}
	
	//首联打印按钮触发事件
	obj.btnPrintOne_Click=function(){
		RepStatus=1;  //首联打印状态1 三联打印状态2
		var returnFlagIdS="";
		
		var inputStr = ReportID + CHR_1 + RepStatus;
		//首联已打印次数
		var retPrintNumValue = obj.GetTPrintNum(inputStr,CHR_1);
		retPrintValue = parseInt(obj.PrintValue);  //允许打印次数
		retPrintNumValue = parseInt(retPrintNumValue);
		if (retPrintNumValue=="") retPrintNumValue=0;
		var IsPrintFlag = 0;
		if(SSHospCode=="22-CCZX"){
			var TimeOutFlag = $m({                  
				ClassName:"DHCMed.DTHService.ReportSrv",
				MethodName:"GetTimeOutFlag",
				ReportID:ReportID
			},false);
			if(TimeOutFlag ==0){
				IsPrintFlag = 1;
			} else {
				if (retPrintNumValue<retPrintValue){
					IsPrintFlag = 1;
				} else {
					//获取授权状态
					var PrintNum ="",TPrintNum = retPrintNumValue;
					var inputStr = ReportID + CHR_1 + RepStatus + CHR_1 + TPrintNum + CHR_1 + PrintNum;
					var retGrantFlagValue = obj.GetGrantStatus(inputStr,CHR_1);
					if ((retGrantFlagValue=="")||(retGrantFlagValue==0)){
						$.messager.confirm("提示", "死亡证不允许重复打印，需提交申请，确认提交?", function (r) {
							if (r) {
								obj.InitPrintReason();
							} 
						});
					} else {
						IsPrintFlag = 1;
					}
				}
			}
		} else {
			if (retPrintNumValue<retPrintValue){
				IsPrintFlag = 1;
			} else {
				//获取授权状态
				var PrintNum="",TPrintNum=retPrintNumValue;
				var inputStr = ReportID + CHR_1 + RepStatus + CHR_1 + TPrintNum + CHR_1 + PrintNum;
				var retGrantFlagValue = obj.GetGrantStatus(inputStr,CHR_1);
				if ((retGrantFlagValue=="")||(retGrantFlagValue==0)){
						$.messager.confirm("提示", "死亡证不允许重复打印，需提交申请，确认提交?", function (r) {
						if (r) {
							obj.InitPrintReason();
						} 
					});
				} else {
					IsPrintFlag = 1;
				}
			}
		}
		if (IsPrintFlag != 1) return;

		var SSHospCodeArray = SSHospCode.split("-");
		var waringmes = "提示";
		if (SSHospCodeArray[0] =="11"){           //11是北京的医院，北京的医院一般需要纸单号
			var pNo = obj.GetPaperNo(ReportID);
			if(pNo ==""){
				obj.LoadPaperNoWin();
				return ;
			} else {
				waringmes += ":【当前纸单号为"+pNo+"】";
			}
		}
		if (obj.SwitchPrint == 1){	
			if(SSHospCode=="------"){
				$.messager.confirm("是否补打", "确定显示补打?", function (r) {
					if (r) {
						var returnFlagIdS = 'Yes';
					} else {
						var returnFlagIdS = '';
					}
				});
			}
		}
     
		$.messager.confirm(waringmes,"（1）本次将是死亡证的正式打印，在打印前请再次核对所有信息。<br>（2）打印后的死亡证将被锁定并保存，之后不得更改。<br>（3）正式打印1次后，将不得再次打印。",function(r){
			if(r){
				if (SSHospCodeArray[0]=="11"){
					var retValue = obj.UpdatePaperNo(ReportID,"1","1");
					if ((retValue>-1)){
						$.messager.popover({msg: '更新纸单号成功',type:'success',timeout: 1000});
					} else {
						$.messager.alert("提示","更新纸单号失败!", 'info');
						return;
					}
				}
				
				var LogonLocID  = session['LOGON.CTLOCID'];
				var LogonUserID = session['LOGON.USERID'];
				var PrintNum ="",TPrintNum = retPrintNumValue;
				var retValue = ChangeDMRepPrint(LogonLocID,LogonUserID,RepStatus,PrintNum,TPrintNum);
				if (ReportID==""){
					$.messager.alert("提示","打印失败！找不到这份报告" , 'info');
					return
				}
				
				var backImgUrlBase64 = $m({                  
					ClassName:"DHCMA.Util.IO.CommonSrv",
					MethodName:"Img2Base64",
					Path: "/scripts/DHCMA/img/image-3.jpg", 
					IsWholePath: "0"
				},false);
				
				var LODOP=getLodop();
				LODOP.PRINT_INIT("PrintDTHFirstInfo");		//打印任务的名称
				LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
				LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
				LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
				LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
				LODOP. ADD_PRINT_SETUP_BKIMG("<img border='0' src='data:image/png;base64,"+ backImgUrlBase64 +"' style='z-index:-1;'/>");
				LODOP.SET_SHOW_MODE("BKIMG_IN_PREVIEW",1);
				LODOP.SET_SHOW_MODE("BKIMG_PRINT",1);
				LODOP.SET_SHOW_MODE("BKIMG_LEFT",150);
				LODOP.SET_SHOW_MODE("BKIMG_TOP",100);
				LodopPrintURL(LODOP,"dhcma.dth.lodopone.csp?ReportID="+ReportID);
				LODOP.PRINT();			//直接打印
				obj.InitRepPowerByStatus(); //首联打印后刷新
				window.location.reload();
				/*try {
					if (obj.TemplateVersion==1) {
						ExportTwoDataToExcelNew("","","",ReportID,returnFlagIdS);
						obj.InitRepPowerByStatus(); //首联打印后刷新
						window.location.reload();
					} else {
						ExportTwoDataToExcel("","","",ReportID);
						window.location.reload();
					}
				}catch(e){}*/
	  		}
		})
	}
	
	//首联重复打印原因
	obj.InitPrintReason = function(){
		$.messager.prompt("提示", "请输入重复打印原因：", function (r) {
			if (r) {
				var separate ="^";
				var CtlocId = session['LOGON.CTLOCID'];
				var UserID  = session['LOGON.USERID'];
				RepStatus = 1;
				var inStr = ReportID + separate + RepStatus;  
				var retPrintNumValue = obj.GetTPrintNum(inStr,separate);  //获取打印次数
				TPrintNum=retPrintNumValue;
				PrintNum="";
				var ret = ChargePrintReason(CtlocId,UserID,RepStatus,PrintNum,TPrintNum,r,r);
				if (ret<0){
					$.messager.alert("提示","重复打印申请提交失败!", 'info');
				}else {
					$.messager.alert("提示","死亡证再次打印申请已提交!", 'info');
				}
			}else if(r==""){
				$.messager.alert("提示","请输入重复打印的原因!", 'info');
			}
		});
	}
	
	//三联打印按钮触发事件
	obj.btnPrintThree_Click=function(){
		var returnIdS ="";
		var returnFlagIdS ="";
		RepStatus = 2;  //首联打印状态1 三联打印状态2		
		var inputStr = ReportID + CHR_1 + RepStatus;
		//已打印次数
		var retPrintNumValue = obj.GetPrintNum(inputStr,CHR_1);
		retPrintValue = parseInt(obj.PrintValue);//允许打印次数
		retPrintNumValue = parseInt(retPrintNumValue);
		var IsPrintFlag = 0;
		
		if(SSHospCode=="22-CCZX"){
			var TimeOutFlag = $m({                  
				ClassName:"DHCMed.DTHService.ReportSrv",
				MethodName:"GetTimeOutFlag",
				ReportID:ReportID
			},false);
			if(TimeOutFlag ==0){
				IsPrintFlag = 1;
			} else {
				if (retPrintNumValue<retPrintValue){
					IsPrintFlag = 1;
				} else {
					//获取授权状态
					TPrintNum="",PrintNum = retPrintNumValue;
					var inputStr = ReportID + CHR_1 + RepStatus + CHR_1 + TPrintNum + CHR_1 + PrintNum;
					var retGrantFlagValue = obj.GetGrantStatus(inputStr,CHR_1);
					if ((retGrantFlagValue=="")||(retGrantFlagValue==0)){
						$.messager.confirm("提示", "死亡证不允许重复打印，需提交申请，确认提交?", function (r) {
							if (r) {
								$('#PrintReason').window("open");
							} 
						});
					} else {
						IsPrintFlag = 1;
					}
				}
			}
		} else {
			if (retPrintNumValue<retPrintValue){
				IsPrintFlag = 1;
			} else {
				//获取授权状态
				TPrintNum ="",PrintNum = retPrintNumValue;
				var inputStr = ReportID + CHR_1 + RepStatus + CHR_1 + TPrintNum + CHR_1 + PrintNum;
				var retGrantFlagValue = obj.GetGrantStatus(inputStr,CHR_1);
				if ((retGrantFlagValue=="")||(retGrantFlagValue==0)){
					$.messager.confirm("提示", "死亡证不允许重复打印，需提交申请，确认提交?", function (r) {
						if (r) {
							$('#PrintReason').window("open");
						} 
					});
				} else {
					IsPrintFlag = 1;
				}
			}
		}
		if (IsPrintFlag != 1) return;
		
		var SSHospCodeArray=SSHospCode.split("-");
		var waringmes = "提示";
		if ((SSHospCodeArray[0]=="11")&&(SSHospCode != '11-AZ')){
			var OneFlag = 0;
			var ThreeFlag = 1;
			var havePaperNo = obj.GetPaperNo(ReportID);
			if(havePaperNo==""){
				var retValue = obj.LoadPaperNoWin();
				return;
			} 
			pNo = obj.GetPaperNo(ReportID);
			waringmes += ":【当前纸单号为"+pNo+"】";
		}
		if (obj.SwitchPrint==1){
			if(SSHospCode=="------"){  //选择报告是否显示补打字样
				$.messager.confirm("是否补打", "确定显示补打?", function (r) {
					if (r) {
						var returnFlagIdS = 'Yes';
					} else {
						var returnFlagIdS = '';
					}
				});
			}
		}
		
		$.messager.confirm(waringmes,"（1）本次将是死亡证的正式打印，在打印前请再次核对所有信息。<br>（2）打印后的死亡证将被锁定并保存，之后不得更改。<br>（3）正式打印1次后，将不得再次打印。",function(r){
			if(r){
				if (SSHospCodeArray[0]=="11") {
					if (SSHospCode != '11-AZ') {
						var retValue = obj.UpdatePaperNo(ReportID,"3","1");
						if ((retValue>-1)){
							$.messager.popover({msg: '更新纸单号成功',type:'success',timeout: 1000});
						} else {
							$.messager.alert("提示","更新纸单号失败!", 'info');
							return
						}
					}else {
						//安贞医院要求在打印的时候自动生成纸单号
						//取可用的最新的纸单号，并同时跟新纸单号的状态和纸单号的打印状态
						var CtlocId = session['LOGON.CTLOCID'];
						var UserID = session['LOGON.USERID'];
						var StatusDR = 3;  //已用
						var instr = StatusDR + "^" + CtlocId + "^" + CtlocId + "^" + UserID + "^" + ReportID;
						var retValue = $m({                  
							ClassName:"DHCMed.DTHService.PaperNoSrv",
							MethodName:"GetAndUpdateNewPaperNo",
							aReportID:ReportID, 
							aInStr:instr
						},false);
						
						if ((retValue>-1)){
							$.messager.popover({msg: '更新纸单号成功',type:'success',timeout: 1000});
						} else {
							$.messager.alert("提示","更新纸单号失败!", 'info');
							return
						}
					}
				}
				var LogonLocID = session['LOGON.CTLOCID'];
				var LogonUserID = session['LOGON.USERID'];
				TPrintNum="",PrintNum = retPrintNumValue;
				var retValue = ChangeDMRepPrint(LogonLocID,LogonUserID,RepStatus,PrintNum,TPrintNum);
				if (ReportID==""){
					$.messager.alert("提示","打印失败！找不到这份报告" , 'info');
					return
				}
				
				var backImgUrlBase64 = $m({                  
					ClassName:"DHCMA.Util.IO.CommonSrv",
					MethodName:"Img2Base64",
					Path: "/scripts/DHCMA/img/image-4.jpg", 
					IsWholePath: "0"
				},false);
				
				var LODOP=getLodop();
				LODOP.PRINT_INIT("PrintDTHThreeInfo");		//打印任务的名称
				LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
				LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
				LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
				LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
				LODOP. ADD_PRINT_SETUP_BKIMG("<img border='0' src='data:image/png;base64,"+ backImgUrlBase64 +"' style='z-index:-1;width:894px;height:1263px;'/>");
				LODOP.SET_SHOW_MODE("BKIMG_IN_PREVIEW",1);
				LODOP.SET_SHOW_MODE("BKIMG_PRINT",1);
				LODOP.SET_SHOW_MODE("BKIMG_LEFT",10);
				LODOP.SET_SHOW_MODE("BKIMG_TOP",10);
				LodopPrintURL(LODOP,"dhcma.dth.lodopthree.csp?ReportID="+ReportID);
				LODOP.PRINT();			//直接打印
				obj.InitRepPowerByStatus(); //三联打印后刷新
				window.location.reload();
				/*try {
					if(obj.TemplateVersion==1) {
						//ExportDataToExcelNew("","","",ReportID,returnIdS,returnFlagIdS);
						obj.InitRepPowerByStatus(); //三联打印后刷新
						window.location.reload();
					} else {
						ExportDataToExcel("","","",ReportID);
						window.location.reload();
					}
				}catch(e){}*/
			}
		});
	}
	
    //三联打印申请
	obj.InitPrintReasonThree = function(){ 
		var separate="^";
		var CtlocId = session['LOGON.CTLOCID'];
		var UserID = session['LOGON.USERID'];
		RepStatus = 2;
		var inStr = ReportID + separate + RepStatus   
		var retPrintNumValue = obj.GetPrintNum(inStr,separate);  //获取打印次数
		TPrintNum ="";
		PrintNum = retPrintNumValue;
		var ReasonTxt  = $.trim($('#ReasonTxt').val());
		var FamilyName = $.trim($('#FamilyName').val());
		var FamilyID   = $.trim($('#FamilyID').val());
		var PrintItem  = $.trim($('#PrintItem').val());
		var errInfo =""
		if (ReasonTxt=="") {
			errInfo += $g("补打原因不能为空!")+"<br>"	
		}
		if (FamilyName=="") {
			errInfo += $g("家属姓名不能为空!")+"<br>"
		}
		if (FamilyID=="") {
			errInfo += $g("家属身份证号不能为空!")+"<br>"
		}
		// 身份证格式验证	
		if ($.trim(FamilyID) != ""){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test(FamilyID))) {
				errInfo += "<P>"+$g("输入的家属身份证号格式不符合规定！请重新输入!")+"<br>";
			}
		}
		if (PrintItem=="") {
			errInfo += $g("补打项目不能为空!")+"<br>"
		}
		if (errInfo) {
			$.messager.alert("提示",errInfo, 'info');
			return;
		}
		var StrReason  = ReasonTxt+' '+FamilyName+' '+FamilyID+' '+PrintItem;
		var ret = ChargePrintReason(CtlocId,UserID,RepStatus,PrintNum,TPrintNum,StrReason,StrReason);
		
		if (ret<0){
			$.messager.alert("提示","重复打印申请提交失败!", 'info');
		}else {
			$.messager.alert("提示","死亡证再次打印申请已提交!", 'info');
			$('#PrintReason').window("close");
		}
	}
	
	//三联打印授权按钮触发事件 
	obj.btnGrantThree_Click = function(){
		$('#UserSignThree').window("open");
		var UserID = session['LOGON.USERCODE'];
		$('#UserNameThree').val(UserID);
	}
	
	//三联打印授权
	obj.InitPopStorageEvent = function(){	
		var UserID  = session['LOGON.USERCODE'];
		var CtlocId = session['LOGON.CTLOCID'];
		
		var PassWord = $.trim($('#PassWordThree').val());
		if (PassWord ==""){
			$.messager.alert("提示","请输入用户名密码!", 'info');		
			return;
		}
		
		var separate = "^"
		var inStr = UserID + separate + PassWord;
		var retVal = obj.VerifyUser(inStr,separate);
		if (retVal==-1){
			$.messager.alert("错误提示","用户名和密码不一致,请检查!", 'info');
			return;
		} else {	
			RepStatus = 2;
			var inStr = ReportID + separate + RepStatus   
			var retPrintNumValue = obj.GetPrintNum(inStr,separate);  //获取打印次数
			PrintNum  = retPrintNumValue;
			TPrintNum = "";
			GrantFlag = "Y";
			var inStr = ReportID + separate + CtlocId + separate + UserID + separate + RepStatus + separate + PrintNum + separate + TPrintNum + separate + GrantFlag;
			var retValue = obj.UpdateGrantFlag(inStr,separate);
			if (retValue>0){
				$.messager.alert("提示","授权成功!", 'info');
				$('#UserSignThree').window("close");
			}
		}
		return;
	}
	
	//首联联打印授权按钮触发事件 
	obj.btnGrantOne_Click = function(){
		$('#UserSignOne').window("open");
		var UserID = session['LOGON.USERCODE'];
		$('#UserNameOne').val(UserID);
	}
	//首联打印授权
	obj.InitPopStorageOneEvent = function(){	
		var UserID  = session['LOGON.USERCODE'];
		var CtlocId = session['LOGON.CTLOCID'];
		
		var PassWord = $.trim($('#PassWordOne').val());
		if (PassWord ==""){
			$.messager.alert("提示","请输入用户名密码!", 'info');		
			return;
		}
		var separate ="^"
		var inStr  = UserID + separate + PassWord;
		var retVal = obj.VerifyUser(inStr,separate);
		if (retVal==-1){
			$.messager.alert("错误提示","用户名和密码不一致,请检查!", 'info');
			return;
		} else {	
			RepStatus = 1;
			var inStr = ReportID + separate + RepStatus;   
			var retPrintNumValue = obj.GetTPrintNum(inStr,separate);  //获取打印次数
			PrintNum  = "";
			TPrintNum = retPrintNumValue;
			GrantFlag = "Y";
			var inStr = ReportID + separate + CtlocId + separate + UserID + separate + RepStatus + separate + PrintNum + separate + TPrintNum + separate + GrantFlag;
			var retValue = obj.UpdateGrantFlag(inStr,separate);
			if (retValue>0){
				$.messager.alert("提示","授权成功!", 'info');
				$('#UserSignOne').window("close");
			}
		}
		return;
	}
	
	//退出
	obj.btnCancle_Click = function(){	
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //关闭
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
	}
	//******************************************按钮事件 ↑↑↑ 
	
	//*******************************************鼠标事件  ↓↓↓
	//诊断7个   鼠标移动之后事件  
	$('#cboAReason').bind('change', function (e) {  //(a)直接导致死亡的疾病或情况
		if($('#cboAReason').lookup("getText")==""){
			$("#txtAReasonICD").val('');            //给相关的ICD10赋值
		}
	});
	$('#cboBReason').bind('change', function (e) {  //(b)引起(a)的疾病或情况 
		if($('#cboBReason').lookup("getText")==""){
			$("#txtBReasonICD").val('');            // 给相关的ICD10赋值
		}
	});
	$('#cboCReason').bind('change', function (e) {  //(c)引起(b)的疾病或情况
		if($('#cboCReason').lookup("getText")==""){
			$("#txtCReasonICD").val('');            //给相关的ICD10赋值
		}
	});
	$('#cboDReason').bind('change', function (e) {  //(d)引起(c)的疾病或情况 
		if($('#cboDReason').lookup("getText")==""){
			$("#txtDReasonICD").val('');            //给相关的ICD10赋值
		}
	});
	$('#cboDamageDiagnose').bind('change', function (e) {  //损伤中毒诊断
		if($('#cboDamageDiagnose').lookup("getText")==""){
			$("#txtDamageDiagnoseICD").val('');            // 给相关的ICD10赋值
		}
	});
	$('#cboOtherDiagnose').bind('change', function (e) {  //其他诊断
		if($('#cboOtherDiagnose').lookup("getText")==""){
			$("#txtOtherDiagnoseICD").val('');            //给相关的ICD10赋值 
		}
	});
	$('#cboBaseReason').bind('change', function (e) {  //根本死因
		if($('#cboBaseReason').lookup("getText")==""){
			$("#txtBaseReasonICD").val('');            //给相关的ICD10赋值
			if($("#chkNewBorn").val())$("#txtICD10").val('');
		}
	});  
	$('#txtRegRoad').keyup(function (e) {  //鼠标移动之后事件
		var RegRoad = $('#txtRegRoad').val();
		var RegAddress = $('#cboRegProvince').combobox('getText')+$('#cboRegCity').combobox('getText')+$('#cboRegCounty').combobox('getText')+$('#cboRegVillage').combobox('getText');
		$('#txtRegAddress').val(RegAddress+RegRoad);
	});
	$('#txtCurrRoad').keyup(function (e) {  //鼠标移动之后事件
		var CurrRoad = $('#txtCurrRoad').val();
		var CurrAddress = $('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText');
		$('#txtCurrAddress').val(CurrAddress+CurrRoad);
	});

	//*******************************************鼠标事件 ↑↑↑ 
	
	//*******************************************调用方法 ↓↓↓	
	//改变编码状态
	function ChangeDMRepStatus(status,resumeText,instr) {
		var separate="^";
		var LogonUserID=session['LOGON.USERID'];
		var inStr = ReportID + separate + status + separate + LogonUserID + separate + resumeText;
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"ChangeStatus",
			instr:inStr, 
			separate:separate
		},false);
		
		return retValue;
	}
	
	//改变首联三联打印状态
	function ChangeDMRepPrint(CtlocId,UserID,RepStatus,PrintNum,TPrintNum){
		var separate="^";
		var inStr=ReportID + separate + CtlocId + separate + UserID + separate + "Y" + separate + "" + separate + RepStatus + separate + PrintNum + separate + TPrintNum+separate;
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"UpdatePrintStatus",
			instr:inStr, 
			separate:separate
		},false);
		
		return retValue;
	}
	
	//改变首联三联打印原因
    function ChargePrintReason(CtlocId,UserID,RepStatus,PrintNum,TPrintNum,rejText){
		var separate="^";
		var inStr=ReportID + separate + CtlocId + separate + UserID + separate + "Y" + separate + "" + separate + RepStatus + separate + PrintNum + separate + TPrintNum + separate + rejText;
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"ChargePrintReason",
			instr:inStr, 
			separate:separate
		},false);
		
		return retValue;
	}
	
	// 获取授权状态
	obj.GetGrantStatus	= function(aInStr,aSeparate) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetGrantFlagStatus",
			instr:aInStr, 
			separate:aSeparate
		},false);
		
		return retValue;
	}
	
	// 获取报告对应的纸单号
	obj.GetPaperNo	= function(aReportID) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.PaperNoSrv",
			MethodName:"GetPaperNo",
			reportId:aReportID
		},false);
		
		return retValue;
	}
	
	// 更新纸单号的打印状态
	obj.UpdatePaperNo = function(aReportID,aTimes,aFlag) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.PaperNoSrv",
			MethodName:"UpdatePaperNo",
			reportId:aReportID,
			OneThree:aTimes,
			YesFlag:aFlag
		},false);
		
		return retValue;
	}
	
	// 检查纸单号是否存在及使用状态
	obj.CheckPaperNo = function(aPaperNo,aLocID) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.PaperNoSrv",
			MethodName:"CheckPaperNo",
			paperNo: aPaperNo,
			CtlocId: aLocID
		},false);
		
		return retValue;
	}
	
	// 修改纸单号的状态
	obj.ChangePaperNoStatus = function(aInstr) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.PaperNoSrv",
			MethodName:"ChangePaperNoStatus",
			instr: aInstr
		},false);
		
		return retValue;
	}
	
	// 获取时间
	obj.GetDataById = function(aDicID) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetDataById",
			DicId:aDicID
		},false);
		
		return retValue;
	}
	
	//获取首联已打印次数
	obj.GetTPrintNum = function(aInstr,aSeparate) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetTPrintNumStatus",
			instr:aInstr, 
			separate:aSeparate
		},false);
	
		return retValue;
	}
	
	//获取三联已打印次数
	obj.GetPrintNum = function(aInstr,aSeparate) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"GetPrintNumStatus",
			instr:aInstr, 
			separate:aSeparate
		},false);
		return retValue;
	}
	//更新打印状态
	obj.UpdateGrantFlag = function(aInstr,aSeparate) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.ReportSrv",
			MethodName:"UpdateGrantFlag",
			instr:aInstr, 
			separate:aSeparate
		},false);
		
		return retValue;
	}
	
	// 验证用户的用户名/密码
	obj.VerifyUser = function(aInstr,aSeparate) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTHService.CommonSrv",
			MethodName:"VerifyUser",
			instr:aInstr,
			separate:aSeparate
		},false);
		
		return retValue;
	}
	// 作废报告之后更新作废编码表
	obj.CodeRecycle = function(aInstr,aSeparate) {
		var retValue = $m({                  
			ClassName:"DHCMed.DTH.CodeRecycle",
			MethodName:"Update",
			aInputStr:aInstr,
			aSeparete:aSeparate
		},false);
		return retValue;
	}
	//*******************************************调用方法 ↑↑↑ 

}


