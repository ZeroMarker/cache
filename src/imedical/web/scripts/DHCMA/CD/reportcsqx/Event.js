function InitReportWinEvent(obj) {
	var Twins = $g("双胎");
	var Multiple = $g("多胎");
	var DefectEesc1 = $g("先天性心脏病");
	var DefectEesc2 = $g("尿道下裂");
	var DefectEesc3 = $g("胎儿水肿综合征");
	var Others = $g("其他");
	var Antenatal = $g("产前");
	
	
	
	
	
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
	$('#txtCurrRoad').bind('change', function (e) {  //鼠标移动之后事件
		var cboProvince = $('#cboCurrProvince').combobox('getText');
		var cboCity = $('#cboCurrCity').combobox('getText');
		var cboCounty = $('#cboCurrCounty').combobox('getText');
		var cboVillage = $('#cboCurrVillage').combobox('getText');
		var txtRoad = $('#txtCurrRoad').val();
		$('#txtCurrAddress').val(cboProvince+cboCity+cboCounty+cboVillage+txtRoad);
	});
	
	$HUI.radio("[name='IsRelaMarry']",{  //是否近亲婚配
		onChecked:function(e,value){
			var IsRelaMarry = $(e.target).val();   //当前选中的值
			if (IsRelaMarry==1) {	
				$('#txtRelaMarry').removeAttr("disabled");
			}else{
				$('#txtRelaMarry').attr('disabled','disabled');
				$('#txtRelaMarry').val("");
			}
		}
	});
	obj.cboDefect = $HUI.combobox('#cboDefect', {    //当选中下拉框的值为  先天性心脏病时，可选择先心病的类型
		onChange:function(newValue,oldValue){
			setTimeout(function(){
				var cboDefectEesc = $.trim($('#cboDefect').combobox('getText')); 
				if (cboDefectEesc==DefectEesc1) {	
					$('#cboChdType').combobox('enable');
					$('#txtFeDSyndrome').attr('disabled','disabled');
					$('#txtBelowUre').attr('disabled','disabled');
					$('#txtOtherDef').attr('disabled','disabled');
					$('#txtBelowUre').val("");
					$('#txtFeDSyndrome').val("");
					$('#txtOtherDef').val("");
				}else if (cboDefectEesc==DefectEesc2) {	
					$('#txtBelowUre').removeAttr('disabled');
					$('#cboChdType').combobox('disable');
					$('#cboChdType').combobox('clear');
					$('#txtFeDSyndrome').attr('disabled','disabled');
					$('#txtOtherDef').attr('disabled','disabled');
					$('#txtFeDSyndrome').val("");
					$('#txtOtherDef').val("");
				}else if (cboDefectEesc==DefectEesc3) {	
					$('#txtFeDSyndrome').removeAttr('disabled');
					$('#cboChdType').combobox('disable');
					$('#cboChdType').combobox('clear');
					$('#txtBelowUre').attr('disabled','disabled');
					$('#txtOtherDef').attr('disabled','disabled');
					$('#txtBelowUre').val("");
					$('#txtOtherDef').val("");
				}else if (cboDefectEesc==Others) {	
					$('#txtOtherDef').removeAttr('disabled');
					$('#cboChdType').combobox('disable');
					$('#cboChdType').combobox('clear');
					$('#txtFeDSyndrome').attr('disabled','disabled');
					$('#txtBelowUre').attr('disabled','disabled');
					$('#txtBelowUre').val("");
					$('#txtFeDSyndrome').val("");
				}else{
					$('#cboChdType').combobox('disable');
					$('#cboChdType').combobox('clear');
					$('#txtFeDSyndrome').attr('disabled','disabled');
					$('#txtBelowUre').attr('disabled','disabled');
					$('#txtOtherDef').attr('disabled','disabled');
					$('#txtBelowUre').val("");
					$('#txtFeDSyndrome').val("");
					$('#txtOtherDef').val("");
				}
			},100);
		}
	});
	
	obj.cboMalfTime = $HUI.combobox('#cboMalfTime', {    //当选中下拉框中为产前时，则需要填写填写产前诊断孕周和产前诊断医院  
		onChange:function(newValue,oldValue){
			setTimeout(function(){
				var cboMalfTimeEesc = $.trim($('#cboMalfTime').combobox('getText')); 
				if (cboMalfTimeEesc==Antenatal) {	
					$('#txtPreWeek').removeAttr('disabled');
					$('#txtDiagHos').removeAttr('disabled');
				}
				else{
					$('#txtPreWeek').attr('disabled','disabled');
					$('#txtDiagHos').attr('disabled','disabled');
					$('#txtPreWeek').val("");
					$('#txtDiagHos').val("");	
				}
			},100);
		}
	});
	
	obj.cboFoetNum = $HUI.combobox('#cboFoetNum', {    //当选中下拉框中为双胎或多胎时，则需要填写是同卵还是异卵
		onChange:function(newValue,oldValue){
			setTimeout(function(){
				var FoetNumEesc = $.trim($('#cboFoetNum').combobox('getText')); 
				debugger;
				if (FoetNumEesc==Twins || FoetNumEesc==Multiple) {	
					$('#cboMultiple').combobox('enable');
				}
				else{
					$('#cboMultiple').combobox('disable');
					$('#cboMultiple').combobox('clear');
				}
			},100);
		}
	});

	obj.cboDiagBasis = $HUI.combobox('#cboDiagBasis', {    //当选中下拉框中为其他诊断依据时，则需要填写诊断备注  
		onChange:function(newValue,oldValue){
			setTimeout(function(){
				var cboDiagBasisEesc = $.trim($('#cboDiagBasis').combobox('getText')); 
				if (cboDiagBasisEesc==Others) {	
					$('#txtDiagBasis').removeAttr('disabled');
				}
				else{
					$('#txtDiagBasis').attr('disabled','disabled');
					$('#txtDiagBasis').val("");
				}
			},100);
		}
	});
	obj.DisplayRepInfo = function(){
	
		if(obj.ReportID==""){
			$('#txtDoctor').val(DocName);
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
				}else if(AgeD>0){
					$('#txtAge').val(objPat.AgeDay);
					$('#cboPatAgeDW').combobox('setValue',$g('天'));
				}else {
					$('#txtAge').val($g("未知"));
					$('#cboPatAgeDW').combobox('setValue','');
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
			}
		}else{
			var objRep = $m({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false);
		    var objCSQX = $m({                  
				ClassName:"DHCMed.CD.CRReportCSQX",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var objPat = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			var arrCSQX=objCSQX.split("^");
			var arrPat=objPat.split("^");
	
			
			//孕母信息
			$('#txtRegNo').val(arrPat[3]);
			$('#txtPatName').val(arrPat[4]);
			$('#txtSex').val(arrPat[6]);
			$('#txtBirthDay').datebox('setValue',arrPat[7]);
					
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
			$('#txtAge').val(patAge);
			$('#cboPatAgeDW').combobox('setValue',patAgeDW);
		
			$('#cboNation').combobox('setValue',arrPat[13].split(CHR_1)[0]);
			$('#cboNation').combobox('setText',arrPat[13].split(CHR_1)[1]);
			
			$('#cboEducation').combobox('setValue',arrPat[15].split(CHR_1)[0]);
			$('#cboEducation').combobox('setText',arrPat[15].split(CHR_1)[1]);

			$('#cboOccupation').combobox('setValue',arrPat[16].split(CHR_1)[0]);
		  $('#cboOccupation').combobox('setText',arrPat[16].split(CHR_1)[1]);
		    
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
			
			$('#dtRepDate').datebox('setValue',arrRep[7]);
			
			
			//缺陷儿信息，孕早期，家族史
			
			$('#txtKPBH').val(arrCSQX[0]);
			$('#cboRegType').combobox('setValue',arrCSQX[1].split(CHR_1)[0]);
			$('#cboRegType').combobox('setText',arrCSQX[1].split(CHR_1)[1]);
			$('#txtGestational').numberbox('setValue',arrCSQX[2]);
			$('#txtParity').numberbox('setValue',arrCSQX[3]);
			$('#IsPreExam').checkbox('setValue',(arrCSQX[4]==1 ? true:false)); 
			
			$('#txtArea').val(arrCSQX[5]);
			$('#txtAreaTime').numberbox('setValue',arrCSQX[6]);
			$('#IsReproduc').checkbox('setValue',(arrCSQX[7]==1 ? true:false)); 
			$('#cboPreIncome').combobox('setValue',arrCSQX[8].split(CHR_1)[0]);
			$('#cboPreIncome').combobox('setText',arrCSQX[8].split(CHR_1)[1]);
			$('#dtBirthday').datebox('setValue',arrCSQX[9]);
			
			$('#txtBirHospital').val(arrCSQX[10]);
			$('#txtGestAge').numberbox('setValue',arrCSQX[11]);
			$('#txtWeight').numberbox('setValue',arrCSQX[12]);
			$('#txtLength').numberbox('setValue',arrCSQX[13]);
			$('#txtAbnormal').numberbox('setValue',arrCSQX[14]);

			$('#cboFoetNum').combobox('setValue',arrCSQX[15].split(CHR_1)[0]);
			$('#cboFoetNum').combobox('setText',arrCSQX[15].split(CHR_1)[1]);
			$('#cboMultiple').combobox('setValue',arrCSQX[16].split(CHR_1)[0]);
			$('#cboMultiple').combobox('setText',arrCSQX[16].split(CHR_1)[1]);
			$('#cboChildSex').combobox('setValue',arrCSQX[17].split(CHR_1)[0]);
			$('#cboChildSex').combobox('setText',arrCSQX[17].split(CHR_1)[1]);
			$('#cboOutCome').combobox('setValue',arrCSQX[18].split(CHR_1)[0]);
			$('#cboOutCome').combobox('setText',arrCSQX[18].split(CHR_1)[1]);
			$('#chkIsInduced').checkbox('setValue',(arrCSQX[19]==1 ? true:false)); 
			
			$('#cboDiagBasis').combobox('setValue',arrCSQX[20].split(CHR_1)[0]);
			$('#cboDiagBasis').combobox('setText',arrCSQX[20].split(CHR_1)[1]);
			$('#txtDiagBasis').val(arrCSQX[21]);
			$('#cboMalfTime').combobox('setValue',arrCSQX[22].split(CHR_1)[0]);
			$('#cboMalfTime').combobox('setText',arrCSQX[22].split(CHR_1)[1]);
			$('#txtPreWeek').val(arrCSQX[23]);
			$('#txtDiagHos').val(arrCSQX[24]);
			
			$('#cboDefect').combobox('setValue',arrCSQX[25].split(CHR_1)[0]);
			$('#cboDefect').combobox('setText',arrCSQX[25].split(CHR_1)[1]);
			$('#cboPosition').combobox('setValue',arrCSQX[26].split(CHR_1)[0]);
			$('#cboPosition').combobox('setText',arrCSQX[26].split(CHR_1)[1]);
			$('#txtBelowUre').val(arrCSQX[27]);
			$('#cboChdType').combobox('setValue',arrCSQX[28].split(CHR_1)[0]);
			$('#cboChdType').combobox('setText',arrCSQX[28].split(CHR_1)[1]);
			$('#txtFeDSyndrome').val(arrCSQX[29]);
			
			$('#txtOtherDef').val(arrCSQX[30]);
			$('#txtYZQHBFR').val(arrCSQX[31]);
			$('#txtYZQHBBDGR').val(arrCSQX[32]);
			$('#txtYZQHBTNB').val(arrCSQX[33]);
			$('#txtYZQHB').val(arrCSQX[34]);
			
			$('#txtYZQFYHAL').val(arrCSQX[35]);
			$('#txtYZQFYKSS').val(arrCSQX[36]);
			$('#txtYZQFYBYY').val(arrCSQX[37]);
			$('#txtYZQFYZJY').val(arrCSQX[38]);
			$('#txtYZQFY').val(arrCSQX[39]);
			
			$('#txtYZQQTYJ').val(arrCSQX[40]);
			$('#txtYZQQTNY').val(arrCSQX[41]);
			$('#txtYZQQTSX').val(arrCSQX[42]);
			$('#txtYZQQTHXZJ').val(arrCSQX[43]);
			$('#txtYZQQT').val(arrCSQX[44]);
			
			var AbnoBirth = arrCSQX[45];
			var AbnoBirthDescs = arrCSQX[46];
			if (AbnoBirth){
			var arr = AbnoBirth.split(',');
			var valueArr = new Array();
            for (var i = 0; i < arr.length; i++) {
                valueArr.push(arr[i]);
            }
			$('#cboAbnoBirth').combobox('setValues',valueArr);
			$('#cboAbnoBirth').combobox('setText',AbnoBirthDescs);
			}
			$('#txtStillbirth').numberbox('setValue',arrCSQX[47]);
			$('#txtAbortion').numberbox('setValue',arrCSQX[48]);
			$('#txtDefeChild').numberbox('setValue',arrCSQX[49]);
			$('#txtDefecName').val(arrCSQX[50]);
			
			
			$('#txtFamGen1').val(arrCSQX[51]);
			$('#txtRelation1').val(arrCSQX[52]);
			$('#txtFamGen2').val(arrCSQX[53]);
			$('#txtRelation2').val(arrCSQX[54]);
			$('#txtFamGen3').val(arrCSQX[55]);
			$('#txtRelation3').val(arrCSQX[56]);
			
			var IsRelaMarry = arrCSQX[57];		
			
			if (IsRelaMarry) {
				$HUI.radio("#IsRelaMarry-"+IsRelaMarry).setValue(true);    
			}
			$('#txtRelaMarry').val(arrCSQX[58]);	 
			$('#cboCRReportLoc').combobox('setValue',arrRep[3]);
			$('#cboCRReportLoc').combobox('setText',arrRep[4]);
			$('#txtDoctor').val(arrRep[5]);
			
		}
	};
	
   obj.GetRepData = function (step) {
		
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"CSQX";
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
	
	obj.GetCSQXData = function () {
		
		
		var IsRelaMarry = $("input[name=IsRelaMarry]:checked").val();				//是否是近亲结婚
		if (!IsRelaMarry){
			IsRelaMarry="";
		}
		var RelaMarry = $.trim($('#txtRelaMarry').val());					
		
		var DiagInfo=obj.ReportID;
		
		DiagInfo=DiagInfo+"^"+$.trim($('#txtKPBH').val());  				//1.卡片编号
		DiagInfo=DiagInfo+"^"+$.trim($('#cboRegType').combobox('getValue'));	    //2.户籍类型
		DiagInfo=DiagInfo+"^"+$.trim($('#txtGestational').val());					//3.孕次
		DiagInfo=DiagInfo+"^"+$.trim($('#txtParity').val());						//4.产次
		DiagInfo=DiagInfo+"^"+($('#IsPreExam').checkbox('getValue') ? 1 : 0);  //5.是否婚检
		
		DiagInfo=DiagInfo+"^"+$.trim($('#txtArea').val());						//6.居住所属地区
		DiagInfo=DiagInfo+"^"+$.trim($('#txtAreaTime').val());					//7.居住时间		
		DiagInfo=DiagInfo+"^"+($('#IsReproduc').checkbox('getValue') ? 1 : 0);  //8.是否辅助生殖				
		DiagInfo=DiagInfo+"^"+$.trim($('#cboPreIncome').combobox('getValue'));	//9.家庭年人均收入
		DiagInfo=DiagInfo+"^"+$('#dtBirthday').datebox('getValue');  			//10.出生日期
		
		DiagInfo=DiagInfo+"^"+$.trim($('#txtBirHospital').val());  //11.出生医院
		DiagInfo=DiagInfo+"^"+$.trim($('#txtGestAge').val());  		//12.胎龄
		DiagInfo=DiagInfo+"^"+$.trim($('#txtWeight').val());  //13.体重
		DiagInfo=DiagInfo+"^"+$.trim($('#txtLength').val());  //14.身长
		DiagInfo=DiagInfo+"^"+$.trim($('#txtAbnormal').val());  //15.畸形数
		
		DiagInfo=DiagInfo+"^"+$.trim($('#cboFoetNum').combobox('getValue'));	//16.胎数
		DiagInfo=DiagInfo+"^"+$.trim($('#cboMultiple').combobox('getValue'));  //17.同卵异卵		
		DiagInfo=DiagInfo+"^"+$.trim($('#cboChildSex').combobox('getValue'));  //18.缺陷儿性别
		DiagInfo=DiagInfo+"^"+$.trim($('#cboOutCome').combobox('getValue'));	//19.转归
		DiagInfo=DiagInfo+"^"+($('#chkIsInduced').checkbox('getValue') ? 1 : 0);  //20.诊断为出生缺陷后治疗性引产


		DiagInfo=DiagInfo+"^"+$.trim($('#cboDiagBasis').combobox('getValue'));	//21.诊断依据
		DiagInfo=DiagInfo+"^"+$.trim($('#txtDiagBasis').val()); 				//22.诊断备注
	  	DiagInfo=DiagInfo+"^"+$.trim($('#cboMalfTime').combobox('getValue'));	//23.畸形确诊时间
		DiagInfo=DiagInfo+"^"+$.trim($('#txtPreWeek').val());  					//24.产前诊断孕周
		DiagInfo=DiagInfo+"^"+$.trim($('#txtDiagHos').val());  					//25.产前诊断医院
		
		DiagInfo=DiagInfo+"^"+$.trim($('#cboDefect').combobox('getValue'));		//26.缺陷诊断
		DiagInfo=DiagInfo+"^"+$.trim($('#cboPosition').combobox('getValue'));	//27.位置
		DiagInfo=DiagInfo+"^"+$.trim($('#txtBelowUre').val()); 					//28.尿道下裂
		DiagInfo=DiagInfo+"^"+$.trim($('#cboChdType').combobox('getValue'));	//29.先心病类型
		DiagInfo=DiagInfo+"^"+$.trim($('#txtFeDSyndrome').val()); 				//30.胎儿水肿综合征
		
		
		DiagInfo=DiagInfo+"^"+$.trim($('#txtOtherDef').val()); 					//31.其他缺陷名
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQHBFR').val()); 					//32.发热
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQHBBDGR').val()); 				//33.病毒感染类型
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQHBTNB').val()); 					//34.糖尿病
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQHB').val()); 					//35.其他
		
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQFYHAL').val()); 					//36.磺胺类药物名称
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQFYKSS').val()); 					//37.抗生素药物名称
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQFYBYY').val()); 				//38.避孕药药物名称
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQFYZJY').val()); 					//39.镇静药药物名称
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQFY').val()); 					//40.其他药物名称
		
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQQTYJ').val()); 					//41.有害因素饮酒剂量
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQQTNY').val()); 					//42.有害因素农药名称
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQQTSX').val()); 					//43.有害因素射线种类
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQQTHXZJ').val()); 				//44.有害因素化学制剂名称
		DiagInfo=DiagInfo+"^"+$.trim($('#txtYZQQT').val()); 					//45.其他有害因素
		
		DiagInfo=DiagInfo+"^"+$.trim($('#cboAbnoBirth').combobox('getValues'));	//46.异常生育史
		DiagInfo=DiagInfo+"^"+$.trim($('#txtStillbirth').val()); 				//47.死胎
		DiagInfo=DiagInfo+"^"+$.trim($('#txtAbortion').val()); 					//48.自然流产
		DiagInfo=DiagInfo+"^"+$.trim($('#txtDefeChild').val()); 				//49.缺陷儿
		DiagInfo=DiagInfo+"^"+$.trim($('#txtDefecName').val()); 				//50.缺陷名称
		
		
		DiagInfo=DiagInfo+"^"+$.trim($('#txtFamGen1').val()); 					//51.家族遗传史1
		DiagInfo=DiagInfo+"^"+$.trim($('#txtRelation1').val()); 				//52.与缺陷儿亲属关系1
		DiagInfo=DiagInfo+"^"+$.trim($('#txtFamGen2').val()); 					//53.家族遗传史2
		DiagInfo=DiagInfo+"^"+$.trim($('#txtRelation2').val()); 				//54.与缺陷儿亲属关系2
		DiagInfo=DiagInfo+"^"+$.trim($('#txtFamGen3').val()); 					//55.家族遗传史3
		DiagInfo=DiagInfo+"^"+$.trim($('#txtRelation3').val()); 				//56.与缺陷儿亲属关系3
		DiagInfo=DiagInfo+"^"+IsRelaMarry; 										//57.是否是近亲结婚
		DiagInfo=DiagInfo+"^"+RelaMarry; 										//59.近亲的关系
		

		return DiagInfo;
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
		InputStr = InputStr+"^"+"";	                //CRSFZH
		InputStr = InputStr+"^"+"";	                                        //CRJTDH
		InputStr = InputStr+"^"+$.trim($('#cboNation').combobox('getValue'));	    //CRMZ
		InputStr = InputStr+"^"+"";    			//CRHYZK
		InputStr = InputStr+"^"+$.trim($('#cboEducation').combobox('getValue'));	//CRWHCD
		InputStr = InputStr+"^"+$.trim($('#cboOccupation').combobox('getValue'));	//CRZY
		InputStr = InputStr+"^"+"";	    //CRGZ
		InputStr = InputStr+"^"+"";	                                        //CRLXR
		InputStr = InputStr+"^"+"";	                                        //CRYBRGX
		InputStr = InputStr+"^"+"";	                    //CRLXDH
		InputStr = InputStr+"^"+"";	                    //CRGZDW
		InputStr = InputStr+"^"+"";	                                        //CRHJ
		InputStr = InputStr+"^"+"";					//CRHJDZS
		InputStr = InputStr+"^"+"";    				 //CRHJDZS2
		InputStr = InputStr+"^"+"";  				//CRHJDZX
		InputStr = InputStr+"^"+"";					//CRHJDZX2
		InputStr = InputStr+"^"+"";                     								//CRHJDZC
		InputStr = InputStr+"^"+"";	                //CRHJDZXX
		InputStr = InputStr+"^"+$.trim($('#cboCurrProvince').combobox('getValue'));	//居住省
		InputStr = InputStr+"^"+$.trim($('#cboCurrCity').combobox('getValue'));     //居住市
		InputStr = InputStr+"^"+$.trim($('#cboCurrCounty').combobox('getValue'));   //居住县
		InputStr = InputStr+"^"+$.trim($('#cboCurrVillage').combobox('getValue'));	//居住村
		InputStr = InputStr+"^"+$.trim($('#txtCurrRoad').val());                    //居住街道
		InputStr = InputStr+"^"+$.trim($('#txtCurrAddress').val());	                //居住地址
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
		var CSQXData=obj.GetCSQXData();
		var PatData=obj.GetPatData();
		var ExtraData="";
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:CSQXData,
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
		var CSQXData=obj.GetCSQXData();
		var PatData=obj.GetPatData();
		var ExtraData="";
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:CSQXData,
			PatInfo:PatData,
			ExtraInfo:ExtraData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("草稿数据保存错误!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("草稿数据保存成功！<br>请及时完善出生缺陷儿卡信息"), 'info');
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
			
			var fileName="DHCMA_CD_PrintReportCSQX.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
			DHCCPM_RQPrint(fileName);
		}
	};
	obj.btnPrint_click = function(){
		if (obj.ReportID==""){
			$.messager.alert($g("提示"),$g("打印失败！找不到这份报告") , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintCDCSQXReport");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.cd.lodopcsqx.csp?ReportID="+obj.ReportID);
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
		var IsRelaMarry = $("input[name=IsRelaMarry]:checked").val();				// 是否近亲结婚
		if (!IsRelaMarry){
			IsRelaMarry="";
		}
		var RelaMarry = $.trim($('#txtRelaMarry').val());					//近亲双方的亲属关系
		
		if ($.trim($('#txtPatName').val()) == "") {
			errStr += $g("病人姓名不允许为空!<br>");		//病人姓名
		}
		if ($.trim($('#txtSex').val()) == "") {
			errStr += $g("性别不允许为空!<br>");		//性别
		}
		if ($.trim($('#txtAge').val()) == "") {
			errStr += $g("年龄不允许为空!<br>");		//年龄
		}
		if ($.trim($('#cboNation').combobox('getValue')) == "") {
			errStr += $g("请选择民族!<br>");		//民族
		}
		if ($.trim($('#cboEducation').combobox('getValue')) == "") {
			errStr += $g("请选择文化!<br>");		//文化
		}
		
		if ($.trim($('#cboOccupation').combobox('getValue')) == "") {
			errStr += $g("请选择职业!<br>");		//职业
		}
		
		if ($.trim($('#txtGestational').val()) == "") {
			errStr += $g("孕次不允许为空!<br>");		//孕次
		}
		if ($.trim($('#txtParity').val()) == "") {
			errStr += $g("产次不允许为空!<br>");		//产次
		}
		if ($.trim($('#cboPreIncome').combobox('getValue')) == "") {
			errStr += $g("请选择家庭年人均收入!<br>");		//家庭年人均收入
		}
		if ($.trim($('#cboRegType').combobox('getValue')) == "") {
			errStr += $g("请选择户籍类型!<br>");	//户籍类型
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
		if ($.trim($('#txtAreaTime').val())=="") {
			errStr += $g("居住时间不允许为空!<br>");		//居住时间
		}
		if (($('#dtBirthday').datebox('getValue')) == "") {
			errStr += $g("请选择出生日期!<br>");		//出生日期
		}
		if ($.trim($('#txtBirHospital').val()) == "") {
			errStr += $g("出生医院不能为空!<br>");		//出生医院		
		} 
		if ($.trim($('#cboChildSex').combobox('getValue')) == "") {
			errStr += $g("请选择缺陷儿性别!<br>");		//缺陷儿性别
		}
		if ($.trim($('#txtGestAge').val()) == "") {
			errStr += $g("出生缺陷儿胎龄不能为空!<br>");//出生缺陷儿年龄		
		} 
		if ($.trim($('#txtWeight').val()) == "") {
			errStr += $g("出生缺陷儿体重不能为空!<br>");//出生缺陷儿体重		
		} 
		if ($.trim($('#txtLength').val()) == "") {
			errStr += $g("出生缺陷儿身长不能为空!<br>");//出生缺陷儿身长		
		} 
		if ($.trim($('#txtAbnormal').val()) == "") {
			errStr += $g("出生缺陷儿畸形数不能为空!<br>");	//出生缺陷儿畸形数	
		} 
		if ($.trim($('#cboMalfTime').combobox('getValue')) == "") {
			errStr += $g("畸形确诊时间不允许为空!<br>");		//畸形确诊时间
		} 
		if ($.trim($('#cboDiagBasis').combobox('getValue')) == "") {
			errStr += $g("诊断依据不允许为空!<br>");		//诊断依据
		}
		if (($.trim($('#cboDiagBasis').combobox('getText')) == $g("其他"))&&($.trim($('#txtDiagBasis').val()) == "")) {
			errStr += $g("诊断依据为其他，请填写诊断备注!<br>");//诊断备注		
		} 
		if ($.trim($('#cboFoetNum').combobox('getValue')) == "") {
			errStr += $g("胎数不允许为空!<br>");		//胎数
		} 
		if (($.trim($('#cboFoetNum').combobox('getText')) == $g("双胎")) && ($.trim($('#cboMultiple').combobox('getValue')) == "")) {
			errStr += $g("请选择双胎或多胎是同卵还是异卵!<br>");		//同卵异卵
		} if (($.trim($('#cboFoetNum').combobox('getText')) == $g("多胎"))  && ($.trim($('#cboMultiple').combobox('getValue')) == "")) {
			errStr += $g("请选择双胎或多胎是同卵还是异卵!<br>");		//同卵异卵
		} 
		
		if ($.trim($('#cboOutCome').combobox('getValue')) == "") {
			errStr += $g("请选择转归!<br>");		//转归
		}
		
		
		if ($.trim($('#cboDefect').combobox('getValue')) == "") {
			errStr += $g("请选择缺陷诊断!<br>");		//缺陷诊断
		}
		if (($.trim($('#cboDefect').combobox('getText')) == $g("先天性心脏病")) && ($.trim($('#cboChdType').combobox('getValue')) == "")) {
			errStr += $g("请选择先心病类型!<br>");		//先心病类型
		}
		if (($.trim($('#cboDefect').combobox('getText')) == $g("尿道下裂")) && ($.trim($('#txtBelowUre').val()) == "")) {
			errStr += $g("请填写尿道下裂的类型!<br>");		//	尿道下裂
		}
		if (($.trim($('#cboDefect').combobox('getText')) == $g("胎儿水肿综合征")) && ($.trim($('#txtFeDSyndrome').val()) == "")) {
			errStr += $g("请胎儿水肿综合征是否确诊为*型（中或重）度地中海贫血!<br>");		//	胎儿水肿综合征
		}
		if (($.trim($('#cboDefect').combobox('getText')) == $g("其他")) && ($.trim($('#txtOtherDef').val()) == "")) {
			errStr += $g("请写明其他缺陷诊断病名或详细描述!<br>");		//	其他
		}
		
		

		if (IsRelaMarry=="") { errStr += $g("请选择是否是近亲婚配!<br>"); }
		if ((IsRelaMarry=='1')&&(RelaMarry=="")) { errStr += $g("请填写近亲亲属关系!<br>");	 }
		
		var dtBirthday = $('#dtBirthday').datebox('getValue');
		var dtRepDate = $('#dtRepDate').datebox('getValue');
		if (Common_CompareDate(dtBirthday,dtRepDate)>0) {
			$.messager.alert($g("提示"),$g("出生日期不能大于报卡日期!"), 'info');
			return false;
		}
		
		if(errStr != "") {
			$.messager.alert($g("提示"), errStr, 'info');
			return false;
		}
		return true;
	}

}


