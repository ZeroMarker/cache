function InitReportWinEvent(obj) {
	
	obj.GetByPaCode = function(aReportID,aCode){
		var value = $m({                  
				ClassName:"DHCMed.CD.CRReportBZQT",
				MethodName:"GetByPaCode",
				ParRef:aReportID,
				Code:aCode
			},false);
		return value;
	} 
	
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
	//显示数据
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			$('#txtReportUser').val(DocName);   //填卡人
			//$('#txtReportOrgan').val(HospDesc);                   //填卡单位
			$('#txtReportDate').datebox('setValue',Common_GetDate(new Date()));  //填卡日期
			
			if(PatientID!=""){
				var objPat = $cm({                  
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				$('#txtPatName').val(objPat.PatientName);
				$('#txtPatSex').val(objPat.Sex);
				var PersonalIDType=objPat.PersonalIDType;				//证件类型
				if(PersonalIDType!=$g("居民身份证")){
					$('#txtPatCardNo').val("");     
				}
				else{
					$('#txtPatCardNo').val(objPat.PersonalID);                //身份证号
				}
				$('#txtLXDH').val(objPat.Telephone);     //联系电话
			
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
					if (session['LOGON.LANGCODE']=="EN"){
						$('#txtAdress1').val($('#cboProvince1').combobox('getText')+$('#cboCity1').combobox('getText')+$('#cboCounty1').combobox('getText')+$('#cboVillage1').combobox('getText'));
					}
				}
				if (ServerObj.DicInfo) {// 字典赋值
				    var OccupationInfo = ServerObj.DicInfo.split("^")[3];
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
	
		    var objSHK = $m({                  
				ClassName:"DHCMed.CD.CRReportSHK",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			
			var objPat = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			var arrSHK=objSHK.split("^");
			var arrPat=objPat.split("^");
			$('#txtCRKPBH').val(arrSHK[1]);  //卡片编号
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
			$('#txtLXDH').val(arrPat[20]);                                            //联系电话
			$('#cboCRZY').combobox('setValue',arrPat[16].split(CHR_1)[0]); 
			$('#cboCRZY').combobox('setText',arrPat[16].split(CHR_1)[1]);             //职业
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
			
			$('#txtCRYYBH').val(arrSHK[0]);
			$('#txtSHFSRQ').datebox('setValue',arrSHK[2]);
			$('#txtSHFSSJ').val(arrSHK[3]);
			$('#txtHZJZRQ').datebox('setValue',arrSHK[4]);
			$('#txtHZJZSJ').val(arrSHK[5]);
			$('#cboSHFSYY').combobox('setValue',arrSHK[6].split(CHR_1)[0]);
			$('#cboSHFSDD').combobox('setValue',arrSHK[7].split(CHR_1)[0]);
			$('#cboSHFSHD').combobox('setValue',arrSHK[8].split(CHR_1)[0]);
			$('#cboSHFSYY').combobox('setText',arrSHK[6].split(CHR_1)[1]);
			$('#cboSHFSDD').combobox('setText',arrSHK[7].split(CHR_1)[1]);
			$('#cboSHFSHD').combobox('setText',arrSHK[8].split(CHR_1)[1]);
			if (arrSHK[9].split(CHR_1)[0]) {
				$HUI.radio('#radSHSFGYList'+arrSHK[9].split(CHR_1)[0]).setValue(true);      //是否故意
			}
			$('#cboCRSHXZ').combobox('setValue',arrSHK[10].split(CHR_1)[0]);
			$('#cboCRSHBW').combobox('setValue',arrSHK[11].split(CHR_1)[0]);
			$('#cboCRSHXZ').combobox('setText',arrSHK[10].split(CHR_1)[1]);
			$('#cboCRSHBW').combobox('setText',arrSHK[11].split(CHR_1)[1]);
			if (arrSHK[12].split(CHR_1)[0]) {
				$HUI.radio('#radSHYZCDList'+arrSHK[12].split(CHR_1)[0]).setValue(true);      //伤害严重程度
			}
			obj.SHLCZD = arrSHK[13].split(CHR_1)[0];
			$('#cboSHLCZD').lookup('setText',arrSHK[13].split(CHR_1)[1]);
			$('#txtCRZDICD').val(arrSHK[13].split(CHR_1)[2]);
			if (arrSHK[14].split(CHR_1)[0]) {
				$HUI.radio('#radSHJJList'+arrSHK[14].split(CHR_1)[0]).setValue(true);      //伤害结局
			}
			$('#CPMC1').val(arrSHK[15]);
			$('#PPXH1').val(arrSHK[16]);
			$('#cboCRSHCPFL1').combobox('setValue',arrSHK[17].split(CHR_1)[0]);
			$('#cboCRSHCPFL1').combobox('setText',arrSHK[17].split(CHR_1)[1]);
			$('#CPMC2').val(arrSHK[18]);
			$('#PPXH2').val(arrSHK[19]);
			$('#cboCRSHCPFL2').combobox('setValue',arrSHK[20].split(CHR_1)[0]);
			$('#cboCRSHCPFL2').combobox('setText',arrSHK[20].split(CHR_1)[1]);
			for (var len=0; len < arrSHK[21].split(',').length;len++) {       
				var valueCode = arrSHK[21].split(',')[len];
				$('#chkSHDXALList'+valueCode).checkbox('setValue',(valueCode!="" ? true:false));             //典型案例
			}         
			
			$('#txtCRQTZY').val(ServerObj.CRQTZY);
			$('#txtCRQTYY').val(ServerObj.CRQTYY);
			$('#txtCRQTDD').val(ServerObj.CRQTDD);
			$('#txtCRQTHD').val(ServerObj.CRQTHD);
			$('#txtCRQTXZ').val(ServerObj.CRQTXZ);
			$('#txtCRQTBW').val(ServerObj.CRQTBW);
			
			$('#txtReportUser').val(arrRep[5]);
			$('#txtReportDate').datebox('setValue',arrRep[7]);
		}
	};
	//得到报告数据
	obj.GetRepData = function (step) {
		var RepLoc = "";
		if (obj.ReportID!="") {
			var objRep = $cm({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"GetObjById",
				id:obj.ReportID
			},false);
			RepLoc = objRep.CRReportLoc;		
		}
		else{
			RepLoc = session['LOGON.CTLOCID'];
		}
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"SHK";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3作废
		InputStr=InputStr+"^"+RepLoc; //session['LOGON.CTLOCID'];
		InputStr=InputStr+"^"+$.trim($('#txtReportUser').val());
		InputStr=InputStr+"^"+""  
		InputStr=InputStr+"^"+$('#txtReportDate').datebox('getValue');
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		
		return InputStr;
	}
	
	obj.GetSHKData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+$.trim($('#txtCRYYBH').val());  //医院编号
		InputStr=InputStr+"^"+$.trim($('#txtCRKPBH').val());  //卡片编号
		InputStr=InputStr+"^"+$('#txtSHFSRQ').datebox('getValue');      //伤害发生日期
		InputStr=InputStr+"^"+$('#txtSHFSSJ').timespinner('getValue'); 	//伤害发生时间
		InputStr=InputStr+"^"+$('#txtHZJZRQ').datebox('getValue');      //患者就诊日期
		InputStr=InputStr+"^"+$('#txtHZJZSJ').timespinner('getValue'); 	//患者就诊时间
		InputStr=InputStr+"^"+$.trim($('#cboSHFSYY').combobox('getValue'));     //伤害发生原因
		InputStr=InputStr+"^"+$.trim($('#cboSHFSDD').combobox('getValue'));     //伤害发生地点
		InputStr=InputStr+"^"+$.trim($('#cboSHFSHD').combobox('getValue'));     //伤害发生活动
		InputStr=InputStr+"^"+Common_RadioValue('radSHSFGYList');    	//是否故意
		InputStr=InputStr+"^"+$.trim($('#cboCRSHXZ').combobox('getValue'));     	//伤害性质
		InputStr=InputStr+"^"+$.trim($('#cboCRSHBW').combobox('getValue'));     	//伤害部位
		InputStr=InputStr+"^"+Common_RadioValue('radSHYZCDList');   	//伤害严重程度
		InputStr=InputStr+"^"+obj.SHLCZD;    	                        //伤害临床诊断
		InputStr=InputStr+"^"+Common_RadioValue('radSHJJList');    		//伤害结局
		InputStr=InputStr+"^"+$.trim($('#CPMC1').val());						//产品名称1
		InputStr=InputStr+"^"+$.trim($('#PPXH1').val());                        //品牌/型号1
		InputStr=InputStr+"^"+$.trim($('#cboCRSHCPFL1').combobox('getValue')); 		//产品分类1
		InputStr=InputStr+"^"+$.trim($('#CPMC2').val());						//产品名称2
		InputStr=InputStr+"^"+$.trim($('#PPXH2').val());                        //品牌/型号2
		InputStr=InputStr+"^"+$.trim($('#cboCRSHCPFL2').combobox('getValue')); 		//产品分类2
		InputStr=InputStr+"^"+Common_CheckboxValue('chkSHDXALList');    	//典型案例
		
		return InputStr;
	}
	
	obj.GetPatData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+$.trim($('#txtPatName').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatCardNo').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatSex').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatAge').val());
		InputStr=InputStr+"^"+$.trim($('#cboPatAgeDW').combobox('getValue'));  //7 
		InputStr=InputStr+"^"+$.trim($('#txtLXDH').val());
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+"";  //10
		InputStr=InputStr+"^"+$.trim($('#cboCRZY').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboProvince1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCity1').combobox('getValue')); //13
		InputStr=InputStr+"^"+$.trim($('#cboCounty1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboVillage1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCUN1').val());   //16
		InputStr=InputStr+"^"+$.trim($('#txtAdress1').val());
		return InputStr;
	}
	
	obj.GetExtraData = function () {
		var InputStr=obj.ReportID;
		ServerObj.CRQTZY = $.trim($('#txtCRQTZY').val());
		ServerObj.CRQTYY = $.trim($('#txtCRQTYY').val());
		ServerObj.CRQTDD = $.trim($('#txtCRQTDD').val());
		ServerObj.CRQTHD = $.trim($('#txtCRQTHD').val());
		ServerObj.CRQTXZ = $.trim($('#txtCRQTXZ').val());
		ServerObj.CRQTBW = $.trim($('#txtCRQTBW').val());	
		InputStr=InputStr+"^"+"CRQTZY"+CHR_1+"其他职业"+CHR_1+$.trim($('#txtCRQTZY').val());
		InputStr=InputStr+"^"+"CRQTYY"+CHR_1+"其他原因"+CHR_1+$.trim($('#txtCRQTYY').val());
		InputStr=InputStr+"^"+"CRQTDD"+CHR_1+"其他地点"+CHR_1+$.trim($('#txtCRQTDD').val());
		InputStr=InputStr+"^"+"CRQTHD"+CHR_1+"其他活动"+CHR_1+$.trim($('#txtCRQTHD').val());
		InputStr=InputStr+"^"+"CRQTXZ"+CHR_1+"其他性质"+CHR_1+$.trim($('#txtCRQTXZ').val());
		InputStr=InputStr+"^"+"CRQTBW"+CHR_1+"其他部位"+CHR_1+$.trim($('#txtCRQTBW').val());	
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
	//保存
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var SHKData=obj.GetSHKData();
		var PatData=obj.GetPatData();
		var ExtraData=obj.GetExtraData();
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:SHKData,
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
		var SHKData=obj.GetSHKData();
		var PatData=obj.GetPatData();
		var ExtraData=obj.GetExtraData();
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:SHKData,
			PatInfo:PatData,
			ExtraInfo:ExtraData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("草稿数据保存错误!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("草稿数据保存成功！<br>请及时完善伤害卡信息"), 'info');
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
			//var flg=ExportDataToExcel("","","意外伤害监测报告卡("+$.trim($('#txtPatName').val())+")",cArguments);
			var fileName="DHEMA_CD_PrintReportSHK.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
			DHCCPM_RQPrint(fileName);
		}
	};
	obj.btnPrint_click = function(){
		if (obj.ReportID==""){
			$.messager.alert($g("提示"),$g("打印失败！找不到这份报告") , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintCDSHKReport");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.cd.lodopshk.csp?ReportID="+obj.ReportID);
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
			errStr += $g("姓名不允许为空!<br>");		//病人姓名
		}
		if ($.trim($('#txtPatSex').val()) == "") {
			errStr += $g("性别不允许为空!<br>");		//性别
		}
		if ($.trim($('#txtPatAge').val()) == "") {
			errStr += $g("年龄不允许为空!<br>");		//年龄
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
		if (($.trim($('#cboCRZY').combobox('getValue')) == "")&&($.trim($('#txtCRQTZY').val()) == "")) {
			errStr += $g("职业不允许为空，请选择职业!<br>");		//职业	
		} 
		if ($.trim($('#txtLXDH').val()) == "") {
			errStr += $g("联系电话不允许为空!<br>");		//联系电话
		}  
		//电话号码格式验证 !(/^([0-9]{3,4}-)?[0-9]{7,8}$/.test(phone))
		if ($.trim($('#txtLXDH').val()) != ""){
			if (!(/^1[3456789]\d{9}$/.test($.trim($('#txtLXDH').val())))) {
				errStr += $g('输入的电话号码格式不符合规定！请重新输入!<br>');
			}
		}
		if ($.trim($('#cboProvince1').combobox('getValue')) == "") {
			errStr += $g("请选择联系地址省!<br>");		//省
		}
		if ($.trim($('#cboCity1').combobox('getValue')) == "") {
			errStr += $g("请选择联系地址市!<br>");		//市
		}
		if ($.trim($('#cboCounty1').combobox('getValue')) == "") {
			errStr += $g("请选择联系地址县!<br>");		//县
		}
		if ($.trim($('#cboVillage1').combobox('getValue')) == "") {
			errStr +=$g( "请选择联系地址乡/镇!<br>");		//乡/镇
		}
		if ($.trim($('#txtCUN1').val()) == "") {
			errStr += $g("村不允许为空!<br>");		//村
		}  
		if ($.trim($('#txtAdress1').val()) == "") {
			errStr += $g("详细地址不允许为空!<br>");		//详细地址		
		} 
		if ($('#txtSHFSRQ').datebox('getValue') == "") {
			errStr += $g("伤害发生日期不允许为空!<br>");		//伤害发生日期		
		}
		if ($.trim($('#txtSHFSSJ').val()) == "") {
			errStr += $g("伤害发生时间不允许为空!<br>");		//伤害发生时间	
		}
		if ($('#txtHZJZRQ').datebox('getValue') == "") {
			errStr += $g("患者就诊日期不允许为空!<br>");		//伤害就诊日期		
		}
		if ($.trim($('#txtHZJZSJ').val()) == "") {
			errStr += $g("患者就诊时间不允许为空!<br>");		//伤害就诊时间	
		}		
		if (($.trim($('#cboSHFSYY').combobox('getValue')) == "")&&($.trim($('#txtCRQTYY').val()) == "")) {
			errStr += $g("请选择伤害发生原因不允许为空!<br>");		//伤害发生原因	
		} 
		if (($.trim($('#cboSHFSDD').combobox('getValue')) == "")&&($.trim($('#txtCRQTDD').val()) == "")) {
			errStr += $g("请选择伤害发生地点!<br>");		//伤害发生地点	
		} 
		if (($.trim($('#cboSHFSHD').combobox('getValue')) == "")&&($.trim($('#txtCRQTHD').val()) == "")) {
			errStr += $g("请选择伤害发生活动!<br>");		//伤害发生活动	
		} 
		if (Common_RadioValue('radSHSFGYList') == "") {
			errStr += $g("是否故意不允许为空!<br>");		    //是否故意		
		}
		if (($.trim($('#cboCRSHXZ').combobox('getValue')) == "")&&($.trim($('#txtCRQTXZ').val()) == "")) {
			errStr += $g("伤害性质不允许为空!<br>");		//伤害性质
		} 
		if (($.trim($('#cboCRSHBW').combobox('getValue')) == "")&&($.trim($('#txtCRQTBW').val()) == "")) {
			errStr += $g("伤害部位!<br>");		//伤害部位	
		} 		
		if (Common_RadioValue('radSHYZCDList') == "") {
			errStr += $g("严重程度不允许为空!<br>");		    //严重程度		
		}  
		if (($.trim($('#cboSHLCZD').lookup('getText')) == "")||(obj.SHLCZD=="")) {
			errStr += $g("伤害诊断不允许为空，请选择诊断!<br>");		//临床诊断
		}  
		if (Common_RadioValue('radSHJJList') == "") {
			errStr += $g("伤害结局不允许为空!<br>");		         //伤害结局	
		}  
		if (Common_CheckboxValue('chkSHDXALList') == "") {
			errStr += $g("典型案例不允许为空!<br>");		         //典型案例
		} 
		var NowDate = Common_GetDate(new Date());
		var NowTime = Common_GetTime(new Date());
		
		var txtSHFSRQ = $('#txtSHFSRQ').datebox('getValue');
		var txtSHJZRQ = $('#txtHZJZRQ').datebox('getValue');
		var txtSHFSSJ = $('#txtSHFSSJ').val()
		var txtHZJZSJ = $('#txtHZJZSJ').val()
		
		
		if (Common_CompareDate(txtSHFSRQ,NowDate)>0) {
			errStr += $g('伤害发生日期不允许大于当前日期!<br>');			
		}
		if ((txtSHFSRQ==NowDate)&&(Common_CompareTime(txtSHFSSJ,NowTime)>0)){
			errStr += $g('伤害发生日期为今天，伤害时间不允许大于当前时间!<br>');			
		}
		
		if (Common_CompareDate(txtSHJZRQ,NowDate)>0) {
			errStr += $g('伤害就诊日期不允许大于当前日期!<br>');			
		}
		if ((txtSHJZRQ==NowDate)&&(Common_CompareTime(txtHZJZSJ,NowTime)>0)){
			errStr += $g('就诊日期为今天，就诊时间不允许大于当前时间!<br>');			
		}
		if (Common_CompareDate(txtSHFSRQ,txtSHJZRQ)>0) {
			errStr += $g('伤害发生日期不允许大于伤害就诊日期!<br>');			
		}
		if ((txtSHFSRQ==txtSHJZRQ)&&(Common_CompareTime(txtSHFSSJ,txtHZJZSJ)>0)){
			errStr += $g('发生与就诊为同一天,伤害发生时间不允许大于就诊时间!<br>');			
		}
		if(errStr != "")
		{
			$.messager.alert($g("提示"), errStr, 'info');
			return false;
		}
		return true;
	}

}


