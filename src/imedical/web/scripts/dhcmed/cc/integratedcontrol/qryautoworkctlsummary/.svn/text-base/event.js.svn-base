

function InitviewScreenEvent(obj) {
	
	obj.LoadEvent = function(args)
	{
		obj.CurrentSubjectID = SubjectID;
		obj.Adm48HourFlag = 1;
		obj.btnQuery_onClick();
	}
	
	obj.GetSelectSummaryStatus = function()
	{
		var ret = "0";
		if (Ext.getCmp("rdoStatus1").getValue()) ret = 0;
		if (Ext.getCmp("rdoStatus2").getValue()) ret = 1;
		if (Ext.getCmp("rdoStatus3").getValue()) ret = 9;
		return ret;
	}
	
	obj.GetArg = function()
	{
		var strArg = ""
		strArg += "DepTemp^OutOfTemperature^" + obj.txtTemp.getValue() + String.fromCharCode(1);
		strArg += "DepGermCnt^Bacteria^" + obj.txtDepGerm.getValue() + String.fromCharCode(1);
		strArg += "PersonalGermKind^Bacteria^" + obj.txtPeronalGerm.getValue() + String.fromCharCode(1);
		strArg += "DepGermKind^Bacteria^" + obj.txtDepGermKind.getValue() + String.fromCharCode(1);
		return strArg;
	}
	
	obj.btnQuery_onClick = function(objButton, objEvent, WardID, SubCatID, PanelTitle, aEpisodeID)
	{
		if((WardID == null) || (WardID == 0)) WardID="";
		if(SubCatID == null) SubCatID = "";
		if(PanelTitle == null) PanelTitle = "";
		if(!aEpisodeID) aEpisodeID = "";
		obj.SelWardID = WardID;
		obj.SelSubCatID = SubCatID;
		obj.PanelTitle = PanelTitle;
		
		var dtFromDate = Ext.getCmp('dtFromDate').getRawValue();
		var dtToDate = Ext.getCmp('dtToDate').getRawValue();
		var today = new Date();
		var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (dtFromDate == '') {
			Ext.getCmp('dtFromDate').setValue(CurrDate);
			dtFromDate = Ext.getCmp('dtFromDate').getRawValue();
		}
		if (dtToDate == '') {
			Ext.getCmp('dtToDate').setValue(CurrDate);
			dtToDate = Ext.getCmp('dtToDate').getRawValue();
		}
		var flg = objINTCCommon.CompareDate(dtFromDate,CurrDate);
		if (!flg) {
			Ext.getCmp('dtFromDate').setValue(CurrDate);
			dtFromDate = Ext.getCmp('dtFromDate').getRawValue();
			ExtTool.alert("提示", '开始日期大于当前日期,开始日期设为当前日期!');
		}
		var flg = objINTCCommon.CompareDate(dtToDate,CurrDate);
		if (!flg) {
			Ext.getCmp('dtToDate').setValue(CurrDate);
			dtToDate = Ext.getCmp('dtToDate').getRawValue();
			ExtTool.alert("提示", '结束日期大于当前日期,结束日期设为当前日期!');
		}
		var flg = objINTCCommon.CompareDate(dtFromDate,dtToDate);
		if (!flg) {
			Ext.getCmp('dtToDate').setValue(dtFromDate);
			dtToDate = Ext.getCmp('dtToDate').getRawValue();
			ExtTool.alert("提示", '结束日期大于开始日期,结束日期设为开始日期!');
		}
		
		var dtMaxDate = dtFromDate;
		var dtMaxMonth = dtMaxDate.substring(5,dtMaxDate.lastIndexOf ("-"));
		var dtMaxDay = dtMaxDate.substring(dtMaxDate.length,dtMaxDate.lastIndexOf ("-")+1);
		var dtMaxYear = dtMaxDate.substring(0,dtMaxDate.indexOf ("-"));
		var dtMaxDate = new Date(dtMaxMonth+"/"+dtMaxDay+"/"+dtMaxYear);
		dtMaxDate = dtMaxDate.add(Date.DAY, 7);
		dtMaxDate = dtMaxDate.format('Y-m-d');
		if (dtToDate > dtMaxDate)
		{
			Ext.getCmp('dtToDate').setValue(dtMaxDate);
			dtToDate = Ext.getCmp('dtToDate').getRawValue();
			ExtTool.alert("提示", '最大时间跨度为7天,结束日期设为"' + dtMaxDate + '".');
		}
		obj.dtFromDate = dtFromDate;
		obj.dtToDate = dtToDate;
		
		//显示监控结果
		obj.DisplayCtrlResult(aEpisodeID);
	}
	
	obj.DisplayCtrlResult = function(aEpisodeID)
	{
		if (!aEpisodeID) aEpisodeID = '';
		
		if (aEpisodeID == '') {
			if ((obj.SelWardID == '') && (obj.SelSubCatID == ''))
			{
				objScreen.pnLocBed.setTitle('床位图（全院）');
				objScreen.pnFloorplan.setTitle('病区床位图（全院）');
				objScreen.pnDetail.setTitle('明细（全院）');
				objScreen.pnSummary.setTitle('摘要（全院）');
			}
			
			if((obj.PanelTitle != null) && (obj.PanelTitle != ''))
			{
				objScreen.pnLocBed.setTitle('床位图（' + obj.PanelTitle + '）');
				objScreen.pnFloorplan.setTitle('病区床位图（' + obj.PanelTitle + '）');
				objScreen.pnDetail.setTitle('明细（' + obj.PanelTitle + '）');
				objScreen.pnSummary.setTitle('摘要（' + obj.PanelTitle + '）');
			}
			
			//摘要...
			if(obj.SelWardID == '') {
				var strHTML = '<iframe height="100%" width="100%" src="./dhccpmrunqianreport.csp?reportName=DHCMed.NINF.Srv.SuspectPatSummaryAllDep.raq' 
				+ '&FromDate=' + obj.dtFromDate
				+ '&ToDate=' + obj.dtToDate
				+ '&SubjectID=' + SubjectID 
				+ '&WardID=' + obj.SelWardID 
				+ '&ViewConfigCode=' + ViewConfigCode
				+ '&Status=' + obj.GetSelectSummaryStatus()
				+ '&Adm48HourFlag=' + obj.Adm48HourFlag
				+ '&rnd=Math.random()" />';
				objScreen.pnSummary.update(strHTML);
			} else {
				var strHTML = '<iframe height="100%" width="100%" src="./dhccpmrunqianreport.csp?reportName=DHCMed.NINF.Srv.SuspectPatSummary.raq' 
				+ '&FromDate=' + obj.dtFromDate
				+ '&ToDate=' + obj.dtToDate
				+ '&SubjectID=' + SubjectID 
				+ '&WardID=' + obj.SelWardID
				+ '&ViewConfigCode=' + ViewConfigCode
				+ '&Status=' + obj.GetSelectSummaryStatus()
				+ '&Adm48HourFlag=' + obj.Adm48HourFlag
				+ '&rnd=Math.random()" />';
				objScreen.pnSummary.update(strHTML);
			}
			
			//指标汇总（按病区汇总）
			Ext.Ajax.request({
				url : ExtToolSetting.RunQueryPageURL,
				method : "POST",
				params  : {
					ClassName : 'DHCMed.CCService.Feedback.SummaryService',
					QueryName : 'QrySummarySubtotal',
					Arg1 : obj.dtFromDate,
					Arg2 : obj.dtToDate,
					Arg3 : SubjectID,
					Arg4 : (DepType==1? 2:1), //按病区分组统计
					Arg5 : objScreen.GetSelectSummaryStatus(),
					Arg6 : '',
					Arg7 : '',
					Arg8 : '',
					Arg9 : ViewConfigCode,
					Arg10 : obj.GetArg(),
					Arg11 : obj.Adm48HourFlag,
					ArgCnt : 11
				},
				success: function(response, opts) {
					var objData = Ext.decode(response.responseText);
					for(var i = 0; i < objData.total; i ++)
					{
						objRec = objData.record[i];
						objRec.WarnCtrl = new Array();
						var arryRows = objRec.WarnInfo.split(String.fromCharCode(1));
						for(var j = 0; j < arryRows.length; j ++)
						{
							if(arryRows[j] == '')
								continue;
							var arryFields = arryRows[j].split("^");
							objRec.WarnCtrl[objRec.WarnCtrl.length] = 
								{
									WardID : arryFields[0],
									TypeCode : arryFields[1],
									TypeDesc : arryFields[2],
									MinNum : arryFields[3],
									Keyword : arryFields[4],
									ItemName : objRec.ItemName
								};
						}
					}
					obj.tplWardSta.overwrite(obj.gridDep.body, objData);
				},
				failure: function(response, opts) {
					obj.pnDepSta.body.dom.innerHTML = response.responseText;
				}
			});
			
			//指标汇总（按类别汇总）
			Ext.Ajax.request({
				url : ExtToolSetting.RunQueryPageURL,
				method : "POST",
				params  : {
					ClassName : 'DHCMed.CCService.Feedback.SummaryService',
					QueryName : 'QrySummarySubtotal',
					Arg1 : obj.dtFromDate,
					Arg2 : obj.dtToDate,
					Arg3 : SubjectID,
					Arg4 : 3, //按类别（关键字）分组统计
					Arg5 : objScreen.GetSelectSummaryStatus(),
					Arg6 : (DepType==1? "":obj.SelWardID),
					Arg7 : (DepType==1? obj.SelWardID:""),
					Arg8 : obj.SelSubCatID,
					Arg9 : ViewConfigCode,
					Arg10 : obj.GetArg(),
					Arg11 : obj.Adm48HourFlag,
					ArgCnt : 11
				},
				success: function(response, opts) {
					var objData = Ext.decode(response.responseText);
					for(var i = 0; i < objData.total; i ++)
					{
						objData.record[i].WardID = (obj.SelWardID == '' ? 0 : obj.SelWardID);
					}				
					obj.tplItemSta.overwrite(obj.gridKeyword.body, objData);
					//window.alert(obj.gridKeyword.body.dom.innerHTML);
				},
				failure: function(response, opts) {
					obj.gridKeyword.body.dom.innerHTML = response.responseText;
				}
			});
		}
		
		//明细...
		if ((obj.SelWardID != '')||(obj.SelSubCatID != '')) {
			//update by zf 20130514 给床位图增加链接
			if (aEpisodeID) {
				obj.tabResult.setActiveTab(3);
				obj.tabResult.setActiveTab(1);
				obj.tabResult.setActiveTab(2);
			} else {
				objScreen.tabResult.add(objScreen.pnLocBed);
				objScreen.tabResult.add(objScreen.pnDetail);
				objScreen.tabResult.add(objScreen.pnFloorplan);
				objScreen.tabResult.setActiveTab(3);
				objScreen.tabResult.setActiveTab(2);
				objScreen.tabResult.setActiveTab(1);
				var strHTML = '<iframe height="100%" width="100%" src="./dhcmed.cc.floorplan.view.csp?1=1&WardID=' + obj.SelWardID + '&ProfileID=' + '&rnd=Math.random()" />';
				objScreen.pnFloorplan.update(strHTML);
			}
			
			Ext.Ajax.request({
				url : ExtToolSetting.RunQueryPageURL,
				method : "POST",
				params  : {
					ClassName : 'DHCMed.CCService.Feedback.SummaryService',
					QueryName : 'QrySummary',
					Arg1 : obj.dtFromDate,
					Arg2 : obj.dtToDate,
					Arg3 : SubjectID,
					Arg4 : objScreen.GetSelectSummaryStatus(),
					Arg5 : (DepType==1? "":obj.SelWardID),
					Arg6 : (DepType==1? obj.SelWardID:""),
					Arg7 : obj.SelSubCatID,
					Arg8 : ViewConfigCode,
					Arg9 : obj.Adm48HourFlag,
					Arg10 : aEpisodeID,
					ArgCnt : 10
				},
				success: function(response, opts) {
					var objData = Ext.decode(response.responseText);
					//*************************************************
					//update by zf 20130329
					//此处修改，影响疑似病例筛查明细页面患者数量
					//如果病人明细超过100，只显示100个人
					if (objData.record.length>100) {
						objData.record.length = 100;
					}
					//*************************************************
					
					//update by zf 20130514 给床位图增加链接
					if (aEpisodeID) {
						objScreen.objTplDetail.overwrite(obj.pnDetail.body, objData);
					} else {
						objScreen.objTplLocBed.overwrite(obj.pnLocBed.body, objData);
						objScreen.objTplDetail.overwrite(obj.pnDetail.body, objData);
					}
				},
				failure: function(response, opts) {
					objScreen.pnLocBed.body.dom.innerHTML = response.responseText;
					objScreen.pnDetail.body.dom.innerHTML = response.responseText;
				}
			});
		} else {
			objScreen.tabResult.remove(objScreen.pnLocBed);
			objScreen.tabResult.remove(objScreen.pnFloorplan);
			objScreen.tabResult.remove(objScreen.pnDetail);
			objScreen.tabResult.setActiveTab(0);
		}
	}
	
	obj.DisplayWarnCtrlPatient = function(WardID, TypeCode, Keyword, MinNum, WardDesc) 
	{
		objScreen.tabResult.add(objScreen.pnLocBed);
		objScreen.tabResult.add(objScreen.pnDetail);
		objScreen.tabResult.add(objScreen.pnFloorplan);
		objScreen.tabResult.setActiveTab(3);
		objScreen.tabResult.setActiveTab(2);
		objScreen.tabResult.setActiveTab(1);
		
		var strHTML = '<iframe height="100%" width="100%" src="./dhcmed.cc.floorplan.view.csp?1=1&WardID=' + WardID + '&ProfileID=' + '&rnd=Math.random()" />';
		objScreen.pnFloorplan.update(strHTML);
		
		var strWarnStr = "";
		var arryTypeCode = TypeCode.split("$");
		var arryKeyword = Keyword.split("$");
		var arryMinNum = MinNum.split("$");
		for(var i = 0; i < arryTypeCode.length; i ++)
		{
			if(arryTypeCode[i] == "")
				continue;
			if(strWarnStr != "")
				strWarnStr += String.fromCharCode(1);
			strWarnStr += arryTypeCode[i] + "^" + arryKeyword[i] + "^" + arryMinNum[i];
		}
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.CCService.Feedback.WarnService',
				QueryName : 'QryWarnPatient',
				Arg1 : Ext.getCmp('dtFromDate').getRawValue(),
				Arg2 : Ext.getCmp('dtToDate').getRawValue(),
  				Arg3 : SubjectID,
  				Arg4 : strWarnStr,
				Arg5 : (DepType==1? "":WardID),
  				Arg6 : (DepType==1? WardID:""),
  				ArgCnt : 6
			},
			success: function(response, opts) {
				if((WardDesc != null) && (WardDesc != ''))
				{
					objScreen.pnLocBed.setTitle('床位图（' + WardDesc + '）');
					objScreen.pnFloorplan.setTitle('病区床位图（' + WardDesc + '）');
					objScreen.pnDetail.setTitle('明细（' + WardDesc + '）');
					objScreen.pnSummary.setTitle('摘要（' + WardDesc + '）');
				}
				var objData = Ext.decode(response.responseText);
				//*************************************************
				//update by zf 20130329
				//此处修改，影响疑似病例筛查明细页面患者数量
				//如果病人明细超过100，只显示100个人
				if (objData.record.length>100) {
					objData.record.length = 100;
				}
				//*************************************************
				objScreen.objTplLocBed.overwrite(obj.pnLocBed.body, objData);
				objScreen.objTplDetail.overwrite(obj.pnDetail.body, objData);
			},
			failure: function(response, opts) {
				objScreen.pnLocBed.body.dom.innerHTML = response.responseText;
				objScreen.pnDetail.body.dom.innerHTML = response.responseText;
			}
		});
	}
	
	obj.iconDep_onDoubleClick = function(WardID)
	{
		var objFrm = new PatientList("", WardID, objScreen.SelKeywordID);
		objFrm.winPatientList.show();
		objFrm.dataViewStore.load({});
	}
	
	window.viewPatientInfo = function(EpisodeID, SummaryID)
	{
		var objViewBaseInfo = new InitViewBaseInfo();
		objViewBaseInfo.DisplayDetailInfo(EpisodeID,SubjectID,SummaryID);
		objViewBaseInfo.viewPatientWin.show();
	}
	
	//发送医师反馈
	obj.btnNoticeDoctor_onclick = function(SummaryID,LnkSummaryIDs)
	{
		var objSendFeedBackWin = new InitwinSendFeedback(SummaryID, LnkSummaryIDs, obj.DisplayCtrlResult, obj);
		objSendFeedBackWin.winSendFeedback.show({});
	}
	
	//排除此次结果
	obj.btnReject_onclick = function(SummaryID,LnkSummaryIDs)
	{
		var ret=ExtTool.RunServerMethod("DHCMed.CC.CtlSummary", "RejectSummary", SummaryID, session['LOGON.USERID']);
		//处理关联Summary状态
		var flg = ExtTool.RunServerMethod("DHCMed.CC.CtlSummary", "ProcessLnkSummary", SummaryID, LnkSummaryIDs);
		obj.DisplayCtrlResult();
	}
}

