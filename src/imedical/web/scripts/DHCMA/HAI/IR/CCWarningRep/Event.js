function InitWinEvent(obj) {
	obj.LoadEvent = function(){
		$('#btnSave').on("click", function(){
			obj.btnSave_click(1); 
		});
		$('#btnSave2').on("click", function(){
			obj.btnSave_click(2); 
		});
		$('#btnCancle').on("click", function(){
			obj.btnCancle_click(); 
		});
		obj.DisplayRepInfo(); 
		obj.InitRepPowerByStatus()
	}
	
	//显示按钮权限
	obj.InitRepPowerByStatus = function(ReportID){		
		var RepStatusCode = $m({                  
			ClassName:"DHCHAI.IR.CCWarningRep",
			MethodName:"GetStringById",
			aId:obj.ReportID
		},false);
		var arrRep=RepStatusCode.split("^");
		obj.RepStatus=arrRep[1];
     	switch (obj.RepStatus) {
			case "1" : 
				$('#btnSave').linkbutton({text:'修改'});
				$('#btnSave2').show();
				break;
			case "2" : 
				$('#btnSave').hide();
				$('#btnSave2').show();
				break;
			default: 
				$('#btnSave').show();
				$('#btnSave2').hide();
				break;
		}
	}	
	obj.DisplayRepInfo = function(){
		if(obj.ReportID!="") {
			var objRep = $m({                  
				ClassName:"DHCHAI.IR.CCWarningRep",
				MethodName:"GetStringById",
				aId:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			obj.RepStatus=arrRep[1];
			$('#DateFrom').datebox('setValue',arrRep[4]);
			$('#DateTo').datebox('setValue',arrRep[5]);
			$('#cboHospital').combobox('setValue',arrRep[6]);
			$('#cboHospital').combobox('setText',arrRep[7]);
			$('#cboLocation').combobox('setValue',arrRep[8]);
			$('#cboLocation').combobox('setText',arrRep[9]);
			$('#PreInfDiag').val(arrRep[10]);
			$('#cboInfDiag').combobox('setValue',arrRep[11]);
			$('#cboInfDiag').combobox('setText',arrRep[12]);
			$('#cboMayPathogen').combobox('setValue',arrRep[13]);
			$('#cboMayPathogen').combobox('setText',arrRep[14]);
			$('#cboPathogen').combobox('setValue',arrRep[15]);
			$('#cboPathogen').combobox('setText',arrRep[16]);
			
			$('#txtCumPat').val(arrRep[17]);
			$('#txtInfPat').val(arrRep[18]);
			$('#txtCure').val(arrRep[19]);
			$('#txtUnderTreat').val(arrRep[20]);
			$('#txtCritically').val(arrRep[21]);
			$('#txtDeath').val(arrRep[22]);
			
			var MayTransList =arrRep[23].split(","); 
			for (var len=0; len < MayTransList.length;len++) {        
				var value = MayTransList[len];
				$('#MayTrans'+value).checkbox('setValue', (value!="" ? true:false));                
			}
			var MaySourceList =arrRep[25].split(","); 
			for (var len=0; len < MaySourceList.length;len++) {        
				var value = MaySourceList[len];
				$('#MaySource'+value).checkbox('setValue', (value!="" ? true:false));                
			}
			
			$('#txtTrans').val(arrRep[24]);
			$('#txtSource').val(arrRep[26]);
			$('#txtSameSymptom').val(arrRep[27]);
			$('#txtHygiene').val(arrRep[28]);
			$('#txtImaging').val(arrRep[29]);
			$('#txtEtiology').val(arrRep[30]);
			$('#txtDetaiDesc').val(arrRep[31]);
			$('#UpdateLoc').val(arrRep[32]);
			$('#UpdateDate').datebox('setValue',arrRep[33]);
			$('#UpdateUser').val(arrRep[35]);
		}
	};
		
	
	obj.btnSave_click = function(aCode){
		if (obj.CheckReport(aCode) != true) return; //数据校验
		obj.qryDate=$("#UpdateDate").datebox('getValue');
		if(obj.LocID=="") {obj.LocID=$("#cboLocation").combobox('getValue')}
		var judgeret = $m({
			ClassName:"DHCHAI.IRS.CCWarningRepSrv",
			MethodName:"JudgeRep",
			aLocID:obj.LocID,
			aDate:obj.qryDate,
			aselItems:obj.selItems
		},false);

		if((!obj.RepStatus)&&(parseInt(judgeret)==1)){
			$.messager.alert("提示","本科室已存在【预警项目："+obj.selItems+"，预警日期："+obj.qryDate+"】的报告，如需修改请在原报告中进行，无需重新填报!", 'info');
			return
		}
		var DateFrom	=	$("#DateFrom").datebox('getValue');
		var DateTo		=	$("#DateTo").datebox('getValue');
		var Hospital	=	$("#cboHospital").combobox('getValue');
		var Location	=	$("#cboLocation").combobox('getValue');
		var PreInfDiag  = 	$('#PreInfDiag').val();
		var InfDiag		=	$("#cboInfDiag").combobox('getValue');
		var MayPathogen = 	$("#cboMayPathogen").combobox('getValue');
		var Pathogen    = 	$("#cboPathogen").combobox('getValue');
		var CumPat      = 	$('#txtCumPat').val();
		var InfPat      = 	$('#txtInfPat').val();
		var Cure       	= 	$('#txtCure').val();
		var UnderTreat  = 	$('#txtUnderTreat').val();
		var Critically  = 	$('#txtCritically').val();
		var Death       = 	$('#txtDeath').val();
		var MayTrans	=	Common_CheckboxValue('MayTrans');
		var MaySource	=	Common_CheckboxValue('MaySource');
		var Trans    	= 	$('#txtTrans').val();
		var Source   	= 	$('#txtSource').val();
		var SameSymptom = 	$('#txtSameSymptom').val();
		var Hygiene 	= 	$('#txtHygiene').val();
		var Imaging 	= 	$('#txtImaging').val();
		var Etiology 	= 	$('#txtEtiology').val();
		var DetaiDesc	= 	$('#txtDetaiDesc').val();
		var UpdateLoc 	= 	$('#UpdateLoc').val();
		var UpdateUser 	= 	$('#UpdateUser').val();
		var UpdateDate	=	$("#UpdateDate").datebox('getValue');
	
		var inputStr = obj.ReportID;
		inputStr = inputStr + "^"  + aCode;
		inputStr = inputStr + "^"  + DateFrom;
		inputStr = inputStr + "^"  + DateTo;
		inputStr = inputStr + "^"  + Hospital;
		inputStr = inputStr + "^"  + Location;
		inputStr = inputStr + "^"  + PreInfDiag;
		inputStr = inputStr + "^"  + InfDiag;
		inputStr = inputStr + "^"  + MayPathogen;
		inputStr = inputStr + "^"  + Pathogen;
		inputStr = inputStr + "^"  + CumPat;
		inputStr = inputStr + "^"  + InfPat;
		inputStr = inputStr + "^"  + Cure;
		inputStr = inputStr + "^"  + UnderTreat;
		inputStr = inputStr + "^"  + Critically;
		inputStr = inputStr + "^"  + Death;
		inputStr = inputStr + "^"  + MayTrans;
		inputStr = inputStr + "^"  + MaySource;
		inputStr = inputStr + "^"  + Trans;
		inputStr = inputStr + "^"  + Source;
		inputStr = inputStr + "^"  + SameSymptom;
		inputStr = inputStr + "^"  + Hygiene;
		inputStr = inputStr + "^"  + Imaging;
		inputStr = inputStr + "^"  + Etiology;
		inputStr = inputStr + "^"  + DetaiDesc;
		inputStr = inputStr + "^"  + UpdateLoc;
		inputStr = inputStr + "^"  + UpdateUser;
		inputStr = inputStr + "^"  + UpdateDate;
		inputStr = inputStr + "^"  + obj.LocID;		//科室ID
		inputStr = inputStr + "^"  + obj.selItems;		//项目
		var ret = $m({                  
			ClassName:"DHCHAI.IR.CCWarningRep",
			MethodName:"Update",
			aInputStr:inputStr
		},false);
		if((parseInt(ret)>0)){
			obj.ReportID=ret;
			var InputStrAct = "";
			InputStrAct += "^" + obj.LocID;
			InputStrAct += "^" + obj.selItems;
			InputStrAct += "^" + obj.qryDate;
			InputStrAct += "^" + "1"; 
			InputStrAct += "^" + "";      // 处置日期
			InputStrAct += "^" + "";      // 处置时间
			InputStrAct += "^" + $.LOGON.USERID; // 处置人
			InputStrAct += "^" + "";     // 处置意见
			InputStrAct += "^" + obj.ReportID;     // 报告ID
			InputStrAct += "^#" + obj.WarnItems;	//查询条件
			if(obj.RepStatus!=1){
				var retval = $m({
					ClassName:"DHCHAI.IR.CCWarningAct",
					MethodName:"Update",
					aInput:InputStrAct,
					aSeparate:"^"
				},false);
	
				if((parseInt(retval)<=0)){
					$.messager.alert("错误","处置失败!"+ret, 'error');
					return;
				}
			}

			$.messager.alert("提示","保存成功!", 'info');
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
				var Url=window.location.href;
				Url=rewriteUrl(Url, {
					ReportID:obj.ReportID
				});
				history.pushState("", "", Url);
			}
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus(obj.ReportID);
			return;	
		}else{
			$.messager.alert("错误","保存失败!"+retval, 'error');
			return;
		}
	}
	obj.btnCancle_click = function(){
		websys_showModal('close');
	};
	//检查规范
	obj.CheckReport = function(aCode){
		var errStr = "";
		if ($("#UpdateDate").datebox('getValue')=="") {
			errStr += "请填写报告日期!<br>";		
		}
		if ($("#DateFrom").datebox('getValue')=="") {
			errStr += "请填写开始日期!<br>";		
		}
		if ($("#cboHospital").combobox('getValue')=="") {
			errStr += "请填写医院!<br>";		
		}
		if ($("#cboLocation").combobox('getValue')=="") {
			errStr += "请填写病区!<br>";		
		}
		if ($("#PreInfDiag").val()=="") {
			errStr += "请填写初步感染诊断!<br>";		
		}
		if ($("#cboMayPathogen").combobox('getValue')=="") {
			errStr += "请填写可能病原体!<br>";		
		}
		if (Common_CheckboxValue('MayTrans')=="") {
			errStr += "请填写可能传播途径!<br>";		
		}
		if (Common_CheckboxValue('MaySource')=="") {
			errStr += "请填写可能感染源!<br>";		
		}	
							
		if (aCode == 2) {
			if ($("#DateTo").datebox('getValue')=="") {
				errStr += "订正必填结束时间!<br>";		
			}
			if ($("#cboInfDiag").combobox('getValue')=="") {
				errStr += "订正必填医院感染诊断!<br>	";	
			}
			if ($("#cboPathogen").combobox('getValue')=="") {
				errStr += "订正必填医院感染病原体!<br>";	
			}
			if ($("#txtInfPat").val()=="") {
				errStr += "订正必填感染患者数!<br>";	
			}
			if ($("#txtTrans").val()=="") {
				errStr += "订正必填传播途径!<br>";		
			}
			if ($("#txtSource").val()=="") {
				errStr += "订正必填感染源!<br>";	
			}
		}
		if(errStr != "") {
			$.messager.alert("提示", errStr, 'error');
			return false;
		}
		return true;
	}
}

