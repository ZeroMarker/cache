var objScreen = null;
function InitviewScreenEvent(obj) {
	
	obj.objCurrSubject = ExtTool.RunServerMethod("DHCMed.CC.Subject", "GetObjById", document.getElementById("SubjectID").value);
	obj.SubjectCode = obj.objCurrSubject.Code;
	obj.strCurrArg = "";
	obj.LoadEvent = function(args)
  {
  	obj.btnQuery.on("click", obj.btnQuery_onClick, obj);
  	window.objScreen = obj;
  };
  
  obj.GetArg = function(){
  	var strArg = ""
  	if (obj.chkTemp.getValue())
  		strArg += "DepTemp^OutOfTemperature^" + obj.txtTemp.getValue() + String.fromCharCode(1);
  	if (obj.chkDepGerm.getValue())
  		strArg += "DepGermCnt^Bacteria^" + obj.txtDepGerm.getValue() + String.fromCharCode(1);
   	if (obj.chkPersonalGermKind.getValue())
  		strArg += "PersonalGermKind^Bacteria^" + obj.txtPeronalGerm.getValue() + String.fromCharCode(1); 		
   	if (obj.chkDepGermKind.getValue())
  		strArg += "DepGermKind^Bacteria^" + obj.txtDepGermKind.getValue() + String.fromCharCode(1); 		  		
  		
  	return strArg;  	
  }
  
  obj.btnQuery_onClick = function()
  {
  	Ext.MessageBox.progress("正在查询，请稍后...");
  	obj.btnQuery.disable();
  	var strArg = obj.GetArg();
  	obj.strCurrArg = strArg;
  	ExtTool.RunQuery(
  		{
  			ClassName : 'DHCMed.CCService.Warning.WarningControl',
  			QueryName : 'QueryDepWarning',
  			Arg1 : obj.dtFromDate.getRawValue(),
  			Arg2 : obj.dtToDate.getRawValue(),
  			Arg3 : obj.SubjectCode,
  			Arg4 : strArg,
  			ArgCnt : 4
  		},
  		obj.DisplayQueryResult,
  		obj
  	);
  }
  
  obj.DisplayQueryResult = function(arryResult)
  {
  	var tpl = new Ext.XTemplate(
	'<div class="all">',
		'<tpl for=".">',
			'<DIV id="frame-{Ctloc}" CLASS="Result_Main">',
		     '<div class="topm">',
			     '<div class="left">',
				      '<ul>',
								'<li>{Department}</li>',
								'<li><strong>{TypeDesc}</strong></li>',
					  		'</ul>',
					'</div>',
				 '</div>',
			'</div>',	 
			'</tpl>',
		'</div>'
		);
		//tpl.overwrite(obj.pnResult.body, arryResult); 
		obj.pnResult.removeAll(true);

		var objItm = null;
		for(var i = 0; i < arryResult.length; i ++)
		{
			objItm = arryResult[i];
			var objPn = new Ext.Panel({
				id : "pnResult-" + objItm.Ctloc + "-" + objItm.TypeCode,
				title : objItm.Department + "   " + objItm.TypeDesc,
				collapsed : true,
				collapsible : true,
				autoScroll : true,
				html : '<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px"><B>正在加载数据，请稍后...</B>'
			});
			objPn.on("expand", obj.pnResult_expand, obj);
			objPn.Keyword = objItm.Keyword;
			objPn.Ctloc = objItm.Ctloc;
			objPn.Arg = obj.strCurrArg;
			objPn.FromDate = obj.dtFromDate.getRawValue();
			objPn.ToDate = obj.dtToDate.getRawValue();
			objPn.TypeCode = objItm.TypeCode;
			objPn.MinNum = objItm.MinNum;
			obj.pnResult.add(objPn);
		}
		obj.pnResult.doLayout();
		
		Ext.MessageBox.hide();
		if(arryResult.length == 0)
		{
			ExtTool.alert("提示", "没有找到任何数据！", Ext.MessageBox.INFO);
		}		
		obj.btnQuery.enable();
  }
  
  obj.pnResult_expand = function(objPanel)
  {

			ExtTool.RunQuery(
				{
					ClassName : 'DHCMed.CCService.Warning.WarningControl',
					QueryName : 'QryWarnPatient',
	  			Arg1 : objPanel.FromDate,
  				Arg2 : objPanel.ToDate,
  				Arg3 : 'INTCC',
  				Arg4 : objPanel.TypeCode + "^" + objPanel.Keyword + "^" + objPanel.MinNum,
  				Arg5 : objPanel.Ctloc,
  				ArgCnt : 5				
				},
				obj.DisplayPatient,
				obj,
				objPanel
			
			);
		
  }

  obj.DisplayPatient = function(arryResult, objPanel)
  {
  	
  	var strSubjectCode = obj.SubjectCode;
  	var strKeywordCode = objPanel.Keyword;
  	var strFromDate = objPanel.FromDate;
  	var strToDate = objPanel.ToDate;
  	
  	var objTpl = new Ext.XTemplate(
			/*'<div class="all">',
		        '<div class="top">',
				    '<div class="mid" >',
						 '<ul class="num">',
							 '<li>查找到的病例数量</li>',
							 '<li class="num1">{totalCount}个</li>',
						 '</ul> ',
					'</div>',
				'</div>',
				*/
				//"查找到的病例数量：{length}<BR/>",
				'<tpl for=".">',
					'<DIV id="frame-{SummaryID}" CLASS="Result_Main">',
				     '<div class="topm">',
					     '<div class="left">',
						      '<ul>',
								'<li>{PatientName}</li>',
								'<li><strong>{PatNo}</strong></li>',
								'<li>{Sex}</li>',
								'<li><strong>{Age}岁</strong></li>',	
								'<li>{AdmitDate}</li>',
								'<li><strong>{Ward}</strong></li>',	
								
								'<li><strong>诊断：{Diagnose}</strong></li>',	
								'<li><strong>医师：{Doctor}</strong></li>',	
								
								'<li><a href="#" onclick="return objScreen.viewPatientInfo({EpisodeID},{SummaryID})"><img src="../scripts/dhcmed/img/summary.gif" width="66" height="32" alt="摘要" /></a> </li>',
								'<li><a href="#" onclick="return objScreen.btnNoticeDoctor_onclick({SummaryID},\'{LnkSummaryIDs}\')"><img src="../scripts/dhcmed/img/notice.gif" width="87" height="32" alt="提示医师" /></a> </li>',
								'<li><a href="#" onclick="return objScreen.btnReject_onclick({SummaryID},\'{LnkSummaryIDs}\')"><img src="../scripts/dhcmed/img/reject.gif" width="65" height="32" alt="排除" /></a> </li>',
							  '</ul>',
						 '</div>',
					 '</div>',
					 '<div class="mas">',
							'<div class="lim">',
								//'<div id="divFeedbackList-{SummaryID}">{[this.FormatHTML(values.EpisodeID,values.SummaryID,values.ActDate,values)]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
								'<div id="divCtlResult-{SummaryID}-' + objPanel.id + '">{[this.FormatHTML("' + strFromDate + '", "' + strToDate + '" ,values.EpisodeID,"'+ obj.objCurrSubject.RowID + '", "' + strKeywordCode + '", values.SummaryID, "' + objPanel.id + '" )]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
								//'<div id="divInf-{SummaryID}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',     
								'</div>',
							'</div>', 
						'</div>',	
					'</tpl>',
				'</div>',
				{
					FormatHTML : function(FromDate, ToDate, EpisodeID, SubjectCode, KeywordCode, SummaryID, PanelID){
						ExtTool.RunQuery(
							{
								ClassName : 'DHCMed.CCService.Warning.WarningControl',
								QueryName : 'QryCtlResultByEpisode',
								Arg1 : FromDate,
								Arg2 : ToDate,
								Arg3 : EpisodeID,
								Arg4 : SubjectCode,
								Arg5 : KeywordCode,
								ArgCnt : 5		
							},
							obj.DisplayCtlResult,
							obj,
							"divCtlResult-" + SummaryID + "-" + PanelID
						
						);						
					}
				}
			);  	
		
			objTpl.overwrite(objPanel.body, arryResult);
  }
  
 obj.DisplayCtlResult = function(arryResult, TargetElement)
	{
		var objTargetElement = document.getElementById(TargetElement);
		if(arryResult.length == 0)
		{
			//document.getElementById(TargetElement).innerHTML = "<B>无触发的特异性指标</B><BR/>";
			
			if (objTargetElement) {
				objTargetElement.innerHTML = "<B>无触发项目信息</B><BR/>";
			}
			return true;
		}		
		var objTemplate = new Ext.XTemplate(
			'<table width="100%" class="Result_Table_CtlResult">',
				'<thead>',
				'<tr><th class="Result_Table_CtlResult_th" colspan="5"><b>触发项目信息</b></th></tr>',
				'<tr>',
					'<th class="Result_Table_CtlResult_td" width="5%">序号</th>',
					'<th class="Result_Table_CtlResult_td" width="60%">项目</th>',
					'<th class="Result_Table_CtlResult_td" width="10%">用户</th>',
					'<th class="Result_Table_CtlResult_td" width="10%">日期</th>',
					'<th class="Result_Table_CtlResult_td" width="10%">时间</th>',
				'</tr>',
				'</thead>',
				'<tbody>',
				'<tpl for=".">',
					'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
						'<td class="Result_Table_CtlResult_td">{[xindex]}</td>',
						//'<td class="Result_Table_CtlResult_td">{[ this.GetActNote([xindex],values.ActFlag) ]}</td>',
						'<td class="Result_Table_CtlResult_td">{Summary}</td>',
						'<td class="Result_Table_CtlResult_td">{UserName}</td>',
						'<td class="Result_Table_CtlResult_td">{ActDate}</td>',
						'<td class="Result_Table_CtlResult_td">{ActTime}</td>',
					'</tr>',
				'</tpl>',
				'</tbody>',
			'</table>',
			'<br/>',
			{
				GetActNote : function(note,actfalg)
				{
					if (actfalg == 1) {
						return "<font style='color:red;'>" + note + "</font>";
					} else {
						return note;
					}
				}
			}
		);
		
		//try{
		//	var objPanel = Ext.getCmp(PanelID);
			objTemplate.overwrite(objTargetElement, arryResult);
		//}catch(err){
		//	window.alert(err.message);
		//}
	}
  
  
  
  
  
  obj.viewPatientInfo = function(EpisodeID, SummaryID)
	{
		obj.CurrentEpisodeID = EpisodeID;
		var objViewBaseInfo = new InitViewBaseInfo();
		objViewBaseInfo.DisplayDetailInfo(
			EpisodeID,
			document.getElementById("SubjectID").value,
			SummaryID
		);
		objViewBaseInfo.viewPatientWin.show();
	}
  
  	//发送医师反馈
	obj.btnNoticeDoctor_onclick = function(SummaryID,LnkSummaryIDs)
	{
		var objSendFeedBackWin = new InitwinSendFeedback(SummaryID, LnkSummaryIDs, obj.btnQrySummary_onclick, obj);
		objSendFeedBackWin.winSendFeedback.show({});
	}
	
	//排除此次结果
	obj.btnReject_onclick = function(SummaryID,LnkSummaryIDs)
	{
		var ret=ExtTool.RunServerMethod("DHCMed.CC.CtlSummary", "RejectSummary", SummaryID, session['LOGON.USERID']);
		
		//处理关联Summary状态
		var flg = ExtTool.RunServerMethod("DHCMed.CC.CtlSummary", "ProcessLnkSummary", SummaryID, LnkSummaryIDs);
		var objDomID = "frame-" + SummaryID;
		var objDom = document.getElementById(objDomID);
		var objParent = objDom.parentElement;
		objParent.removeChild(objDom);
	}	
/*viewScreen新增代码占位符*/}

