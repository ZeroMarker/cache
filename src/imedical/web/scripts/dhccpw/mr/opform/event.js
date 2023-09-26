var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_ER = String.fromCharCode(13)+String.fromCharCode(10);
var separete = "&nbsp;";

// dhccpw.mr.opclinpathway.csp
function InitMainViewportEvent(obj) {
	
	obj.LoadEvent = function(args) {
		
		obj.HelpDocumentPanel.setHeight(Ext.getCmp('InPathWayPanel').getSize().height-45);
		obj.PathWaySelectPanel.setHeight(Ext.getCmp('InPathWayPanel').getSize().height-45);
		
		var HelpDocumentHTML = ''
		 +	'<table border="0" width="100%" height="100%" class="diytable" cellspacing="1" cellpadding="0">'
		 +		'<tr><td class="diytd3">请选择路径</td></tr>'
		 +	'</table>'
		 +	'';
		Ext.getCmp("HelpDocumentPanel").body.update(HelpDocumentHTML);
		
		obj.PathWayGridPanelStore.load({});
		obj.LocPathWayGrid.on("rowclick", obj.LocPathWayGrid_OnRowClick, obj);
		obj.PathWayGridPanel.on("rowdblclick", obj.PathWayGridPanel_OnRowClick, obj);
		obj.btnInPathWay.on("click", obj.btnInPathWay_OnClick, obj);
		
		var TipInfo = "";
		if (obj.CurrPaPerson.PatDeceased=="Y") { TipInfo = TipInfo + "死亡患者不允许入径！"; }
		if (obj.CurrPAADM.AdmType!="O") { TipInfo = TipInfo + "非门诊患者不允许入径！"; }
		if (obj.CurrPAADM.AdmStatus!="在院") { TipInfo = TipInfo + "非在院患者不允许入径！"; }
		if (obj.CurrStep[1]!="") { TipInfo = TipInfo + "病人此次就诊已经入径，不允许入径！"; }
		if (TipInfo!="") {
			ExtTool.alert("提示", TipInfo);
			obj.btnInPathWay.setDisabled(true);
		}
	}
	
	var HelpStepItemXTemplate = new Ext.XTemplate(
		'<tpl for="OrderData"><table border="0" cellspacing="1" cellpadding="0">',
			'<tr><td class="diytit">{SubCatDesc}</td></tr>',
			'</table><tpl for="CateItems"><table border="0" cellspacing="1" cellpadding="0">',
				'<tr><td class="<tpl if="this.isOptional(ItemOptional)">diyfont1</tpl>">{ItemDesc}</td></tr>',
			'</table></tpl>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,isOptional : function(ItemOptional) { return ItemOptional == "1"; }
		}
	);
	
	obj.RenderStepItem = function(TargetElement) {
		var objTargetElement = document.getElementById(TargetElement);
		if (!objTargetElement) { return; }
		var tmpArg = TargetElement.split("-");
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL
			,method : 'POST'
			,params : {
				ClassName : 'web.DHCCPW.OPCPW.FormShowOP',
				QueryName : 'QryStepItem',
				Arg1 : tmpArg[0],
				Arg2 : tmpArg[1],
				ArgCnt : 2
			}
			,success : function(response, opts) {
				Data = buildStepItemObj(response.responseText);
				HelpStepItemXTemplate.overwrite(TargetElement, Data);
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	function buildStepItemObj(Str) {
		var objData = Ext.decode(Str);
		var arrayData = new Array();
		var objItm = null;
		var groupCateg = new Array(), ind = 0, tmpCateg = "";
		for (var i=0; i<objData.total; i++) {
			objItm = objData.record[i];
			arrayData[arrayData.length] = objItm;
			if (tmpCateg.indexOf(objData.record[i].SubCatDesc)<0) {
				tmpCateg = tmpCateg + objData.record[i].SubCatDesc + ",";
				groupCateg[ind] = objData.record[i].SubCatDesc;
				ind = ind + 1;
			}
		}
		var OrderStr = "";
		for (var j=0; j<groupCateg.length; j++) {
			OrderStr = OrderStr + "{'SubCatDesc':'" + groupCateg[j] + "','CateItems':[";
			var itmStr = "";
			for (var k=0; k<objData.total; k++) {
				if (groupCateg[j]==objData.record[k].SubCatDesc) {
					itmStr = itmStr + "{'ItemDesc':'" + objData.record[k].ItemDesc;
					itmStr = itmStr + "','ItemOptional':'" + objData.record[k].ItemOptional + "'},";
				}
			}
			itmStr = itmStr.substring(0, itmStr.length-1);
			OrderStr = OrderStr + itmStr + "]},";
		}
		OrderStr = OrderStr.substring(0, OrderStr.length-1);
		OrderStr = "{OrderData:[" + OrderStr + "]}";
		var OrderData = Ext.decode(OrderStr);
		return OrderData;
	}
	
	obj.ShowHelpDocument = function(CPWID) {
		if (CPWID=="") { return; }
		var CPWEpStr = obj.FormShowOP.GetCPWEpStr(CPWID);
		var CPWEpStr = CPWEpStr.split(",");
		var RowHeight = 150, RowWidth = 300, TitHeight = 30, TitWidth = 30;
		var tmpStr = "", DivStr0 = "", DivStr1 = "", DivStr2 = "", DivStr = "";
		for (var i=0; i<CPWEpStr.length; i++) {
			tmpStr = CPWEpStr[i];
			tmpStr = tmpStr.split(":");
			DivStr0 = DivStr0 + '<td class="diytd3"><div style="width:'+RowWidth+'px;height:'+TitHeight+'px">'+tmpStr[1]+'</div></td>';
			DivStr1 = DivStr1 + '<td class="diytd1"><div id="'+tmpStr[0]+'-01" style="width:'+RowWidth+'px;height:'+RowHeight+'px"></div></td>';
			DivStr2 = DivStr2 + '<td class="diytd1"><div id="'+tmpStr[0]+'-02" style="width:'+RowWidth+'px;height:'+RowHeight+'px"></div></td>';
		}
		DivStr = DivStr+'<tr><td class="diytd3"><div style="width:'+TitWidth+'px;height:'+TitHeight+'px"></div></td>'+DivStr0+'</tr>';
		DivStr = DivStr+'<tr><td class="diytd3"><div style="width:'+TitWidth+'px;height:'+RowHeight+'px">主要诊疗工作</div></td>'+DivStr1+'</tr>';
		DivStr = DivStr+'<tr><td class="diytd3"><div style="width:'+TitWidth+'px;height:'+RowHeight+'px">重点医嘱</div></td>'+DivStr2+'</tr>';
		var HelpDocumentHTML = '<table border="0" height="'+RowHeight+'px" class="diytable" cellspacing="1" cellpadding="0">'+DivStr+'</table>';
		Ext.getCmp("HelpDocumentPanel").body.update(HelpDocumentHTML);
		for (var i=0; i<CPWEpStr.length; i++) {
			var EpStep = CPWEpStr[i].split(":")[0];
			for (var j=1; j<3; j++) { obj.RenderStepItem(EpStep+"-0"+j); }
		}
	}
	
	obj.LocPathWayGrid_OnRowClick = function() {
		var rowIndex = arguments[1];
		var objRec = obj.LocPathWayGridStore.getAt(rowIndex);
		obj.SelectCPWID = objRec.get("CPWID");
		obj.SelectCPWDesc = objRec.get("CPWDesc");
		obj.PathWayStep.reset();
		obj.PathWayStepStore.load({
			params : { Arg1 : obj.SelectCPWID, ArgCnt : 1 }
		});
		obj.ShowHelpDocument(obj.SelectCPWID);
	}
	
	obj.PathWayGridPanel_OnRowClick = function() {
		var rowIndex = arguments[1];
		var objRec = obj.PathWayGridPanelStore.getAt(rowIndex);
		var ImplNewID = objRec.get("ImplNewID");
		LinkFormWindow(ImplNewID);
	}
	
	obj.btnInPathWay_OnClick = function() {
		var SelectStepID = obj.PathWayStep.getValue();
		var SelectStepDesc = obj.PathWayStep.getRawValue();
		var SelectCPWID = obj.SelectCPWID;
		var SelectCPWDesc = obj.SelectCPWDesc;
		if (!SelectCPWID || !SelectStepID) {
			ExtTool.alert("提示", "请选择路径及步骤！");
			return;
		}
		var CurrPathWayID = "", CurrPathWayDesc = "";
		if (obj.CurrClinPathWay) {
			var CurrPathWayID = obj.CurrClinPathWay.Rowid;
			var CurrPathWayDR = obj.CurrClinPathWay.CPWDR;
			var CurrPathWayDesc = obj.CurrClinPathWay.CPWDesc;
			if (CurrPathWayDR!="" && CurrPathWayDR!=SelectCPWID) {
				ExtTool.alert("提示", "病人已入 <b>"+CurrPathWayDesc+"</b> 路径，不允许入其它路径！");
				return;
			}
		}
		var flgStep = obj.InterfaceOP.IfStepInOPCPW(PatientID, SelectCPWID, SelectStepID);
		if (flgStep==1) {
			ExtTool.alert("提示", "不允许进入以前的步骤!");
			return;
		}
		var InDoctor = "", InDate = "", InTime = "";
		var ctpcpService = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		var docString = ctpcpService.GetCareProvByUserID(obj.CurrLogon.USERID, "^");
		InDoctor = docString.split("^")[0];
		// 01:Rowid      02:MRADMDR     03:PathwayDR   04:PathwayEpStepDR 05:Status  06:InDoctorDR
		// 07:InDate     08:InTime      09:OutDoctorDR 10:OutDate         11:OutTime 12:UpdateDate
		// 13:UpdateTime 14:OutReasonDR 15:Comments    16:UpdateUserDR
		var InputStr = "";
		if (CurrPathWayID=="") {
			// 第一次入径，出入境记录表
			InputStr = InputStr + "^" + obj.CurrPAADM.MRAdm;
			InputStr = InputStr + "^" + SelectCPWID;
			InputStr = InputStr + "^";	// + SelectStepID;
			InputStr = InputStr + "^" + "I";
			InputStr = InputStr + "^" + InDoctor;
			InputStr = InputStr + "^";	// + InDate;
			InputStr = InputStr + "^";	// + InTime;
			InputStr = InputStr + "^";
			InputStr = InputStr + "^";
			InputStr = InputStr + "^";
			InputStr = InputStr + "^";
			InputStr = InputStr + "^";
			InputStr = InputStr + "^";
			InputStr = InputStr + "^";	// + obj.txtaResume.getValue();
			InputStr = InputStr + "^" + obj.CurrLogon.USERID;
			// 第一次入径，新实施记录表
			var InputSub = SelectStepID;	// StepDR
			InputSub = InputSub + "^" + InDoctor;	// Doctor
			InputSub = InputSub + "^" + obj.CurrPAADM.EpisodeID;
			InputSub = InputSub + "^";	// + Date
			InputSub = InputSub + "^";	// + Time
		} else {
			// 非第一次入径，新实施记录表
			// 1:RowID 2:StepDR 3:Doctor 4:Paadm 5:StrDate 6:StrTime
			var InputSub = CurrPathWayID + "||";	// rowid	"1||"
			InputSub = InputSub + "^" + SelectStepID;	// StepDR
			InputSub = InputSub + "^" + InDoctor;	// Docor
			InputSub = InputSub + "^" + obj.CurrPAADM.EpisodeID;
			InputSub = InputSub + "^";	// + Date
			InputSub = InputSub + "^";	// + Time
		}
		var TipInfo = "是否确定进入 <b>" + SelectCPWDesc + "</b> 路径 <b>" + SelectStepDesc + "</b> 步骤？";
		Ext.MessageBox.confirm('提示', TipInfo, function(btn, text) {
			if (btn=="yes") {
				var ret = obj.InterfaceOP.InPathWayOP(CurrPathWayID, InputStr, InputSub);
				if (ret<0) {
					ExtTool.alert("提示", "入径操作失败！", Ext.MessageBox.ERROR);
				} else {
					var logID = ExtTool.GetParam(window, "LogID");
					var objInPathLogSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWayInPathLogSrv");
					objInPathLogSrv.UpdateLogResult(logID, ret.split("||")[0]);
					LinkFormWindow(ret);
				}
			}
		});
	}
	
}
