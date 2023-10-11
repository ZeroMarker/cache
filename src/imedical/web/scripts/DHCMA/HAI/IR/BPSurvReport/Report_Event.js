﻿function InitBPRepWinEvent(obj) {
	obj.LoadEvent = function () {
		//搜索框[字典类别]事件
		$('#searchboxT').searchbox({
			searcher: function (value, name) {
				InitPatWin(value);
			}
		});
		// 按钮点击事件
		$('#btnSubmit').click(function (e) {
			if (!obj.CheckInputData(2)) {
				return;
			}
			if (obj.Save()) {
				InitPatWin(2);
				$.messager.popover({ msg: '提交成功！', type: 'success', timeout: 2000 });
				$('#searchboxT').searchbox('setValue', '');
			} else {
				$.messager.alert("提示", '提交失败！', 'info');
			};
		});
		$('#btnCheck').click(function (e) {
			if (!obj.CheckInputData(3)) {
				return;
			}
			if (obj.Save()) {
				InitPatWin(2);
				$.messager.popover({ msg: '审核成功！', type: 'success', timeout: 2000 });
			} else {
				$.messager.alert("提示", '审核失败！', 'info');
			};
		});
		$('#btnDelete').click(function (e) {
			if (obj.SaveStatus(4)) {
				$.messager.popover({ msg: '删除成功！', type: 'success', timeout: 2000 });
			} else {
				$.messager.alert("提示", '删除失败！', 'info');
			};
		});
		$('#btnReturn').click(function (e) {
			if (obj.SaveStatus(5)) {
				$.messager.popover({ msg: '退回成功！', type: 'success', timeout: 2000 });
			} else {
				$.messager.alert("提示", '退回失败！', 'info');
			};
		});
		$('#btnUnCheck').click(function (e) {
			if (obj.SaveStatus(6)) {
				$.messager.popover({ msg: '取消审核成功！', type: 'success', timeout: 2000 });
			} else {
				$.messager.alert("提示", '取消审核失败！', 'info');
			};
		});
		$('#btnClose').click(function (e) {
			websys_showModal('close');
		});
	}
	obj.InitButtons = function () {
		if (obj.AdminPower == 1) {
			obj.InitButtons = function () {
				$('.CSSButton').hide();
				//管理员
				switch (obj.RepStatusCode) {
					case '2':       // 提交
						$('#btnDelete').show();
						$('#btnSubmit').show();
						$('#btnExport').show();
						$('#btnCheck').show();
						//$('#btnReturn').show();
						$('#btnDelete').show();
						break;
					case '3':       // 审核
						$('#btnExport').show();
						$('#btnUnCheck').show();
						break;
					case '6':       // 取消审核
						$('#btnSubmit').show();
						$('#btnDelete').show();
						$('#btnCheck').show();
						$('#btnReturn').show();
						break;
					case '4':       // 删除
						$('#btnSubmit').show();
						break;
					case '5':       // 退回
						$('#btnSubmit').show();
						$('#btnDelete').show();
						break;
					default:
						$('#btnSubmit').show();
						break;
				}
			}
		} else {
			obj.InitButtons = function () {
				//临床
				$('.CSSButton').hide();
				switch (obj.RepStatusCode) {
					case '2':       // 提交
						$('#btnDelete').show();
						$('#btnSubmit').show();
						$('#btnExport').show();
						break;
					case '3':       // 审核
						$('#btnExport').show();
						break;
					case '6':       // 取消审核
						$('#btnSubmit').show();
						$('#btnDelete').show();
						break;
					case '4':       // 删除
						$('#btnSubmit').show();
						break;
					case '5':       // 退回
						$('#btnSubmit').show();
						$('#btnDelete').show();
						break;
					default:
						$('#btnSubmit').show();
						break;
				}
			}
		}
		//首次加载
		obj.InitButtons();
	}
	obj.refreshReportInfo = function(){
		// 初始化报告主表信息
		obj.RepInfo = $cm({
			ClassName:"DHCHAI.IRS.BPSurverySrv",
			QueryName:"QryAdmInfo",		
			aBPRegID: ReportID,
			aSurvNumber:SurvNumber
		},false);
		if (obj.RepInfo.total>0) {
			var RepInfo = obj.RepInfo.rows[0];
			$('#txtBPRegDate').val(RepInfo.BPRegDate);
			$('#txtBPRegLocDesc').val(RepInfo.BPRegLocDesc);
			$('#txtBPRegUserDesc').val(RepInfo.BPRegUserDesc);
			$('#txtRepStatus').val(RepInfo.RepStatus);
			
			obj.RepStatusCode = RepInfo.RepStatusCode;
		}else{
			$('#txtBPRegDate').val("");
			$('#txtBPRegLocDesc').val("");
			$('#txtBPRegUserDesc').val("");
			$('#txtRepStatus').val("");
		}
	}
	// 数据完整性验证
	obj.CheckInputData = function (statusCode) {
		obj.RepInfo   = obj.Rep_Save(statusCode);	   // 报告主表信息
		obj.RegComRep = obj.RegExt_Save();             // 获取模板报告信息
		obj.RepLog    = obj.RepLog_Save(statusCode);   // 日志
		if (obj.RepInfo == '') {
			return false;
		}
		if (obj.RegComRep == '') {
			return false;
		}
		return true;
	}
	
	// 保存报告内容+状态
	obj.Save = function () {
        var ret = $m({
			ClassName: 'DHCHAI.IRS.BPSurverySrv',
			MethodName: 'SaveBPReport',
			aRepInfo: obj.RepInfo,
			aRegComRep: obj.RegComRep,
			aRepLog: obj.RepLog
		}, false);
		if (parseInt(ret) > 0) {
			ReportID = parseInt(ret);
			InitBase();
			obj.refreshReportInfo();
			obj.InitButtons();
			return true;
		} else {
			return false;
		}
	}
	
	// 保存报告状态
	obj.SaveStatus = function (statusCode) {
		var InputRepLog = obj.RepLog_Save(statusCode);	// 日志
		var ret = $m({
			ClassName: "DHCHAI.IRS.BPSurverySrv",
			MethodName: "SaveReportStatus",
			aRepLog: InputRepLog,
			separete: CHR_1
		}, false)
		if (parseInt(ret) > 0) {
			obj.refreshReportInfo();
			obj.InitButtons();
			InitPatWin(2);
			return true;
		} else {
			return false;
		}
	}
	obj.Rep_Save = function (statusCode){
		var RepDate = '';
		var RepTime = '';
		var RepLoc  = $.LOGON.LOCID;
		var RepUser = $.LOGON.USERID;
		var BPPatNo = $('#txtBPRegID').val();
		if (obj.AdminPower==1){  //管理员 不修改 报告科室、报告人、报告日期、报告时间 采用报告数据
			if ((obj.RepInfo)&&(obj.RepInfo.total>0)) { 
				RepDate = obj.RepInfo.rows[0].BPRegDate;
				RepTime = obj.RepInfo.rows[0].BPRegTime;
				RepLoc  = obj.RepInfo.rows[0].BPRegLocDr;
				RepUser = obj.RepInfo.rows[0].BPRegUserDr;
			}
		}

		var InputRep = ReportID;
		InputRep = InputRep + CHR_1 + RegTypeID;
		InputRep = InputRep + CHR_1 + BPRegID;
		InputRep = InputRep + CHR_1 + obj.PAEpisodeID;
		InputRep = InputRep + CHR_1 + SurvNumber;
		InputRep = InputRep + CHR_1 + RepDate;
		InputRep = InputRep + CHR_1 + RepTime;
		InputRep = InputRep + CHR_1 + RepLoc;
		InputRep = InputRep + CHR_1 + RepUser;
		InputRep = InputRep + CHR_1 + statusCode;	  // 状态
		InputRep = InputRep + CHR_1 + BPPatNo;        // 病人编号
    	return InputRep;
	}
	
	obj.RepLog_Save = function(statusCode){
		var Opinion = arguments[1];
		if (typeof(Opinion)=='undefined'){
			Opinion='';
		}
		var InputRepLog = ReportID;
		InputRepLog = InputRepLog + CHR_1 + "";
		InputRepLog = InputRepLog + CHR_1 + statusCode;		//状态
		InputRepLog = InputRepLog + CHR_1 + Opinion;
		InputRepLog = InputRepLog + CHR_1 + $.LOGON.USERID;      //session['LOGON.USERID'];
    	return InputRepLog;
	}
}

