function InitSpeMarkWinEvent(obj) {
	obj.LoadEvent = function(){
		
		$('#btnMark').on("click", function(){
			obj.SPM_btnMark_click();
		});
		$('#btnUpdoMark').on("click", function(){
			obj.SPM_btnUpdoMark_click();
		});
		$('#btnCheck').on("click", function(){
			obj.SPM_btnCheck_click();
		});
		$('#btnUpdoCheck').on("click", function(){
			obj.SPM_btnUpdoCheck_click();
		});
		$('#btnClose').on("click", function(){
			obj.SPM_btnClose_click();
		});
		$('#btnUpdoClose').on("click", function(){
			obj.SPM_btnUpdoClose_click();
		});
	  	$('#btnCancel').on("click", function(){
		  	obj.SPM_btnCancel_click();	  	
	  	});
		
		obj.SPM_InitSpeData();
		obj.SPM_DisplaySpeInfo();
		obj.SPM_DisplayButtons();
	}
	//按钮展示
	obj.SPM_DisplayButtons = function(){
		//隐藏按钮
		$("#btnMark").hide();
		$("#btnUpdoMark").hide();
		$("#btnCheck").hide();    
		$("#btnUpdoCheck").hide();
		$("#btnClose").hide();   
		$("#btnUpdoClose").hide();

		if (obj.SPM_Input.OperTpCode == '1'){  //标记操作
			if (obj.SPM_Input.SpeID == ''){
				$("#btnMark").show();
			} else {
				if (obj.SPM_SpeObj.StatusCode == '1'){
					$("#btnUpdoMark").show();
					if (obj.SPM_SpeObj.IsFinal == '0') {
						$("#btnClose").show();   
					}	
				} else if (obj.SPM_SpeObj.StatusCode == '2'){
					if (obj.SPM_SpeObj.IsFinal == '0') {
						$("#btnClose").show();   
					}	
				} else if (obj.SPM_SpeObj.StatusCode == '3'){
					if (obj.SPM_SpeObj.IsFinal == '2') {
						$("#btnUpdoClose").show();   
					}	
				}
			}
		} else if (obj.SPM_Input.OperTpCode == '2'){  //审核操作
			if (obj.SPM_Input.SpeID == ''){ //特殊患者筛查界面 标记操作
				$("#btnMark").show();
			} else {
				if (obj.SPM_SpeObj.StatusCode == '1'){
					$("#btnUpdoMark").show();
					$("#btnCheck").show();
					if (obj.SPM_SpeObj.IsFinal == '0') {
						$("#btnClose").show();   
					}
				} else if (obj.SPM_SpeObj.StatusCode == '2'){
					$("#btnUpdoCheck").show();
					if (obj.SPM_SpeObj.IsFinal == '0') {
						$("#btnClose").show();   
					}					
				} else if (obj.SPM_SpeObj.StatusCode == '3'){
					if (obj.SPM_SpeObj.IsFinal == '2') {
						$("#btnUpdoClose").show();   
					}		
				}
			}
		}
	}
	
	//初始信息
	obj.SPM_InitSpeData = function(){
		if (obj.SPM_Input.SpeID != ''){
			
			obj.strSpeInfo = $m({
				ClassName:"DHCMed.SPEService.PatientsSrv",
				MethodName:"GetSepInfoByID",
				aSepID:obj.SPM_Input.SpeID
			},false);
			
			if (obj.strSpeInfo=='') return;
			var arrSepInfo = obj.strSpeInfo.split('^');
						
			obj.SPM_Input.EpisodeID = arrSepInfo[1];
			obj.SPM_SpeObj = new Object();
			var tmp = arrSepInfo[2];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.PatTypeID    = arr[0];
			obj.SPM_SpeObj.PatTypeDesc  = arr[1];
			var tmp = arrSepInfo[3];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.PatTypeSubID    = arr[0];
			obj.SPM_SpeObj.PatTypeSubDesc  = arr[1];
			var tmp = arrSepInfo[4];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.StatusID   = arr[0];
			obj.SPM_SpeObj.StatusCode = arr[1];
			obj.SPM_SpeObj.StatusDesc = arr[2];
			var tmp = arrSepInfo[5];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.DutyDeptID   = arr[0];
			obj.SPM_SpeObj.DutyDeptDesc = arr[1];
			var tmp = arrSepInfo[6];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.DutyUserID   = arr[0];
			obj.SPM_SpeObj.DutyUserDesc = arr[1];
			var tmp = arrSepInfo[7];
			var arr = tmp.split(' ');
			obj.SPM_SpeObj.MarkDate     = arr[0];
			obj.SPM_SpeObj.MarkTime     = arr[1];
			obj.SPM_SpeObj.Note         = arrSepInfo[8];
			obj.SPM_SpeObj.Opinion      = arrSepInfo[9];
			var tmp = arrSepInfo[10];
			var arr = tmp.split(' ');
			obj.SPM_SpeObj.CheckDate    = arr[0];
			obj.SPM_SpeObj.CheckTime    = arr[1];
			obj.SPM_SpeObj.CheckOpinion = arrSepInfo[11];
			var tmp = arrSepInfo[12];
			var arr = tmp.split(' ');
			obj.SPM_SpeObj.FinalDate    = arr[0];
			obj.SPM_SpeObj.FinalTime    = arr[1];
			var tmp = arrSepInfo[13];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.PrognosisID   = arr[0];
			obj.SPM_SpeObj.PrognosisDesc = arr[1];
			obj.SPM_SpeObj.IsCheck = arrSepInfo[14];
			obj.SPM_SpeObj.IsFinal = arrSepInfo[15];
		}
	
		obj.strAdmInfo = $m({
			ClassName:"DHCMed.SPEService.PatientsSrv",
			MethodName:"GetPatInfoByAdm",
			aEpisodeID:obj.SPM_Input.EpisodeID
		},false);
		
		if (obj.strAdmInfo == '') return;
		var arrAdmInfo = obj.strAdmInfo.split('^');
		obj.SPM_PatObj = new Object();
		obj.SPM_PatObj.RegNo     = arrAdmInfo[4];
		obj.SPM_PatObj.PatName   = arrAdmInfo[5];
		obj.SPM_PatObj.Sex       = arrAdmInfo[6];
		obj.SPM_PatObj.Age       = arrAdmInfo[7];
		var tmp = arrAdmInfo[2];
		var arr = tmp.split(CHR_1);
		obj.SPM_PatObj.LocID     = arr[0];
		obj.SPM_PatObj.LocDesc   = arr[1];
		var tmp = arrAdmInfo[2];
		var arr = tmp.split(CHR_1);
		obj.SPM_PatObj.DocID     = arr[0];
		obj.SPM_PatObj.DocDesc   = arr[1];
	
	}
	
	obj.SPM_DisplaySpeInfo = function(){
		//显示基本信息
		var strInfo = "登记号：" + obj.SPM_PatObj.RegNo + "\n";
		strInfo += "患者姓名：" + obj.SPM_PatObj.PatName + "\n";
		strInfo += "性别：" + obj.SPM_PatObj.Sex;
		strInfo += "  年龄：" + obj.SPM_PatObj.Age;
	
		$('#txtPatBaseInfo').val(strInfo);

		//显示特殊患者信息
		if (obj.SPM_Input.SpeID != ''){
			$('#cboPatTypeSub').combobox('setValue',obj.SPM_SpeObj.PatTypeSubDesc);  //患者的类型应该显示为描述
			$('#txtNote').val(obj.SPM_SpeObj.Note);
			$('#txtMarkDate').val(obj.SPM_SpeObj.MarkDate + ' ' + obj.SPM_SpeObj.MarkTime);
			$('#txtCurrStatus').val(obj.SPM_SpeObj.StatusDesc);
			$('#txtCheckOpinion').val(obj.SPM_SpeObj.CheckOpinion);
			$('#txtCheckDate').val(obj.SPM_SpeObj.CheckDate + ' ' + obj.SPM_SpeObj.CheckTime);
			$('#cboPrognosis').combobox('setValue',obj.SPM_SpeObj.PrognosisDesc);  //转归应该显示为描述
			$('#txtFinalDate').val(obj.SPM_SpeObj.FinalDate + ' ' + obj.SPM_SpeObj.FinalTime);
	        
			if (obj.SPM_Input.OperTpCode == '1'){  //标记操作
				if (obj.SPM_SpeObj.StatusCode == '1'){
					$('#cboPatTypeSub').combobox('disable');  
					$('#txtNote').attr('disabled','disabled');
					$('#txtMarkDate').attr('disabled','disabled');
					$('#txtCurrStatus').attr('disabled','disabled');
					$('#txtCheckOpinion').attr('disabled','disabled');
					$('#txtCheckDate').attr('disabled','disabled');
					if (obj.SPM_SpeObj.IsFinal != '0') {
						$('#cboPrognosis').combobox('disable'); 
					}
					$('#txtFinalDate').attr('disabled','disabled');
				} else if(obj.SPM_SpeObj.StatusCode == '2'){
					$('#cboPatTypeSub').combobox('disable');  
					$('#txtNote').attr('disabled','disabled');
					$('#txtMarkDate').attr('disabled','disabled');
					$('#txtCurrStatus').attr('disabled','disabled');
					$('#txtCheckOpinion').attr('disabled','disabled');
					$('#txtCheckDate').attr('disabled','disabled');
					if (obj.SPM_SpeObj.IsFinal != '0') {
						$('#cboPrognosis').combobox('disable'); 
					}
					$('#txtFinalDate').attr('disabled','disabled');
				} else if(obj.SPM_SpeObj.StatusCode == '3'){
					$('#cboPatTypeSub').combobox('disable');  
					$('#txtNote').attr('disabled','disabled');
					$('#txtMarkDate').attr('disabled','disabled');
					$('#txtCurrStatus').attr('disabled','disabled');
					$('#txtCheckOpinion').attr('disabled','disabled');
					$('#txtCheckDate').attr('disabled','disabled');
					$('#cboPrognosis').combobox('disable');  
					$('#txtFinalDate').attr('disabled','disabled');
				} else {
					$('#cboPatTypeSub').combobox('disable');  
					$('#txtNote').attr('disabled','disabled');
					$('#txtMarkDate').attr('disabled','disabled');
					$('#txtCurrStatus').attr('disabled','disabled');
					$('#txtCheckOpinion').attr('disabled','disabled');
					$('#txtCheckDate').attr('disabled','disabled');
					$('#cboPrognosis').combobox('disable');  
					$('#txtFinalDate').attr('disabled','disabled');
				}
			} else if (obj.SPM_Input.OperTpCode == '2'){  //审核操作
				if (obj.SPM_SpeObj.StatusCode == '1'){
					$('#cboPatTypeSub').combobox('disable');  
					$('#txtNote').attr('disabled','disabled');
					$('#txtMarkDate').attr('disabled','disabled');
					$('#txtCurrStatus').attr('disabled','disabled');
					//$('#txtCheckOpinion').attr('disabled','disabled');   //特殊患者审核界面的审核可以加备注
					$('#txtCheckDate').attr('disabled','disabled');
					if (obj.SPM_SpeObj.IsFinal != '0') {
						$('#cboPrognosis').combobox('disable'); 
					}
					$('#txtFinalDate').attr('disabled','disabled');
				} else if(obj.SPM_SpeObj.StatusCode == '2'){
					$('#cboPatTypeSub').combobox('disable');  
					$('#txtNote').attr('disabled','disabled');
					$('#txtMarkDate').attr('disabled','disabled');
					$('#txtCurrStatus').attr('disabled','disabled');
					$('#txtCheckOpinion').attr('disabled','disabled');
					$('#txtCheckDate').attr('disabled','disabled');
					if (obj.SPM_SpeObj.IsFinal != '0') {
						$('#cboPrognosis').combobox('disable'); 
					}
					$('#txtFinalDate').attr('disabled','disabled');
				} else if(obj.SPM_SpeObj.StatusCode == '3'){
					$('#cboPatTypeSub').combobox('disable');  
					$('#txtNote').attr('disabled','disabled');
					$('#txtMarkDate').attr('disabled','disabled');
					$('#txtCurrStatus').attr('disabled','disabled');
					$('#txtCheckOpinion').attr('disabled','disabled');
					$('#txtCheckDate').attr('disabled','disabled');
					$('#cboPrognosis').combobox('disable');  
					$('#txtFinalDate').attr('disabled','disabled');
				} else {
					$('#cboPatTypeSub').combobox('disable');  
					$('#txtNote').attr('disabled','disabled');
					$('#txtMarkDate').attr('disabled','disabled');
					$('#txtCurrStatus').attr('disabled','disabled');
					$('#txtCheckOpinion').attr('disabled','disabled');
					$('#txtCheckDate').attr('disabled','disabled');
					$('#cboPrognosis').combobox('disable');  
					$('#txtFinalDate').attr('disabled','disabled');
				}
			}
		} else {
			$('#txtMarkDate').attr('disabled','disabled');    //设置输入框为禁用
			$('#txtCurrStatus').attr('disabled','disabled');  
			$('#txtCheckOpinion').attr('disabled','disabled');  
			$('#txtCheckDate').attr('disabled','disabled');   
			$('#cboPrognosis').combobox('disable');     //设置下拉款为禁用
			$('#txtFinalDate').attr('disabled','disabled');  
		}
		
	}
	
	obj.SPM_SaveSpeInfo = function(StatusCode){
		var PatTypeSubID = $.trim($('#cboPatTypeSub').combobox('getValue'));
		var Note = $.trim($('#txtNote').val());
		var CheckOpinion = $.trim($('#txtCheckOpinion').val());
		var PrognosisID = $.trim($('#cboPrognosis').combobox('getValue'));

		if (StatusCode == '1'){
			if (PatTypeSubID == ''){
				$.messager.alert("错误","请选择特殊患者类型!", 'info');
				return;
			}
		}	
		if (obj.SPM_Input.SpeID != ''){
			var InputStr = obj.SPM_Input.SpeID;
			InputStr += '^' + obj.SPM_Input.EpisodeID;
			InputStr += '^' + obj.SPM_SpeObj.PatTypeSubID;
			InputStr += '^' + obj.SPM_SpeObj.DutyDeptID;
			InputStr += '^' + obj.SPM_SpeObj.DutyUserID;
			InputStr += '^' + obj.SPM_SpeObj.Note;
			InputStr += '^' + obj.SPM_SpeObj.Opinion;
			InputStr += '^' + obj.SPM_SpeObj.MarkDate;
			InputStr += '^' + obj.SPM_SpeObj.MarkTime;
			InputStr += '^' + StatusCode;
			InputStr += '^' + CheckOpinion;
			InputStr += '^' + obj.SPM_SpeObj.CheckDate;
			InputStr += '^' + obj.SPM_SpeObj.CheckTime;
			InputStr += '^' + PrognosisID;
			InputStr += '^' + obj.SPM_SpeObj.FinalDate;
			InputStr += '^' + obj.SPM_SpeObj.FinalTime;
			InputStr += '^' + session['LOGON.USERID'];
		} else {
			var InputStr = '';
			InputStr += '^' + obj.SPM_Input.EpisodeID;
			InputStr += '^' + PatTypeSubID;
			InputStr += '^' + session['LOGON.CTLOCID'];
			InputStr += '^' + session['LOGON.USERID'];
			InputStr += '^' + Note;
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '1';  //标记状态
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + session['LOGON.USERID'];
		}
		InputStr += '^' + obj.SPM_Input.OperTpCode; 
		
		var ret = $m({
			ClassName:"DHCMed.SPEService.PatientsSrv",
			MethodName:"SaveSpeOper",
			aInputStr:InputStr
		},false);
	
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			if(arr[0]=='-3'){
				$.messager.alert("错误","已存在相同特殊患者标记，不允许重复标记!", 'info');
			}
			else{
				$.messager.alert("错误","保存特殊患者标记失败!", 'info');
			}
		} else {
			obj.SPM_WinSpeMark_close();    //关闭窗口
			obj.SPM_Input.SpeID = ret;
		}
	}
	
	
	obj.SPM_UpdoSpeInfo = function(UpdoStatusCode,Opinion){
		var InputStr = obj.SPM_Input.SpeID;
		InputStr += '^' + UpdoStatusCode;
		InputStr += '^' + Opinion;
		InputStr += '^' + session['LOGON.USERID'];
		
		var ret = $m({
			ClassName:"DHCMed.SPEService.PatientsSrv",
			MethodName:"UpdoSpeOper",
			aInputStr:InputStr
		},false);
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			$.messager.alert("错误","撤销特殊患者操作失败!", 'info');
		} else {
			$.messager.popover({msg: '操作成功！',type:'success',timeout: 1000});
			obj.SPM_WinSpeMark_close();   //关闭窗口
		}
	}
	
	obj.SPM_btnMark_click = function(){
		obj.SPM_SaveSpeInfo('1');
	}
	
	obj.SPM_btnUpdoMark_click = function(){
		$.messager.confirm("系统提示", "是否作废特殊患者标记？", function (r) {
			if (r){
				obj.SPM_UpdoSpeInfo('1','作废特殊患者标记');
			}
        });
	}
	
	obj.SPM_btnCheck_click = function(){
		obj.SPM_SaveSpeInfo('2');
	}
	
	obj.SPM_btnUpdoCheck_click = function(){
		$.messager.confirm("系统提示", "是否取消审核特殊患者标记？", function (r) {
			if (r){
				obj.SPM_UpdoSpeInfo('2','取消审核特殊患者标记');
			}
        });
	}
	
	obj.SPM_btnClose_click = function(){
		obj.SPM_SaveSpeInfo('3');
	}
	
	obj.SPM_btnUpdoClose_click = function(){
		$.messager.confirm("系统提示", "是否撤销关闭特殊患者标记？", function (r) {
			if (r){
				obj.SPM_UpdoSpeInfo('3','撤销关闭特殊患者标记');
			}
        });
	}
	
	obj.SPM_btnCancel_click = function(){
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
		
	};
	
	obj.SPM_WinSpeMark_close = function(){
		//刷新审核列表行
		var opt = websys_showModal("options");
		opt.originWindow.$('#SpeCheckList').datagrid('reload');
	    //关闭
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
	}
}
