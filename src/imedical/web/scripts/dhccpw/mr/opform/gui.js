// dhccpw.mr.opclinpathway.csp
function InitMainViewport() {
	var obj = new Object();
	obj.CurrLogon = null;
	obj.CurrPaPerson = null;
	obj.CurrPAADM = null;
	obj.CurrClinPathWay = null;
	obj.LocPathWayQryArg1 = "";
	
	obj.CurrLogon = LoadDHCLogon();
	obj.CurrPaPerson = LoadDHCPaPerson(PatientID);
	obj.CurrPAADM = LoadDHCPAADM(EpisodeID);
	
	obj.InterfaceOP = ExtTool.StaticServerObject("web.DHCCPW.OPCPW.InterfaceOP");
	obj.FormShowOP = ExtTool.StaticServerObject("web.DHCCPW.OPCPW.FormShowOP");
	obj.CurrStep = obj.InterfaceOP.IsCurrStepOP(EpisodeID, obj.CurrLogon.CTLOCID);
	obj.CurrStep = obj.CurrStep.split("^");
	obj.CurrClinPathWay = GetClinPathWay(obj.CurrStep[0]);
	if (!BackPage && obj.CurrClinPathWay && obj.CurrStep[1].indexOf("||")>0) {
		LinkFormWindow(obj.CurrStep[1]);
		return;
	}
	var AdmTypeDesc = "";
	if (obj.CurrPAADM) {
		if (obj.CurrPAADM.AdmType == "O") {
			AdmTypeDesc = "门诊";
		} else if (obj.CurrPAADM.AdmType == "E") {
			AdmTypeDesc = "急诊";
		} else if (obj.CurrPAADM.AdmType == "I") {
			AdmTypeDesc = "住院";
		} else {
			AdmTypeDesc = "其它";
		}
	}
	var Title = "<b>" + AdmTypeDesc + "</b>";
	Title = Title + separete + separete + "登记号:" + obj.CurrPaPerson.PapmiNo;
	Title = Title + separete + separete + "<b>姓名:</b>" + obj.CurrPaPerson.PatName;
	Title = Title + separete + separete + "性别:" + obj.CurrPaPerson.PatSex;
	Title = Title + separete + separete + "出生日期:" + obj.CurrPaPerson.BirthDay;
	Title = Title + separete + separete + "就诊日期:" + obj.CurrPAADM.AdmDate;
	Title = Title + separete + separete + "就诊时间:" + obj.CurrPAADM.AdmTime;
	Title = Title + separete + separete + "主管医生:" + obj.CurrPAADM.AdmDoc;
	if (obj.CurrClinPathWay) {
		Title = Title + separete + separete + "<b>当前路径:</b>" + obj.CurrClinPathWay.CPWDesc;
	}
	
	obj.LocPathWayGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.LocPathWayGridStore = new Ext.data.GroupingStore({
		proxy : obj.LocPathWayGridStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'CPWID'
		},
		[
			 { name : 'CPWID', mapping : 'CPWID' }
			,{ name : 'CPWDesc', mapping : 'CPWDesc' }
			,{ name : 'CPWType', mapping : 'CPWType' }
			//,{ name : 'CPWOffShoot', mapping : 'CPWOffShoot' }
		])
		,sortInfo : { field : 'CPWID', direction : 'ASC' }
		,groupField : 'CPWType'
	});
	obj.LocPathWayGrid = new Ext.grid.GridPanel({
		id : 'LocPathWayGrid'
		,store : obj.LocPathWayGridStore
		,region : 'south'
		,frame : true
		,buttonAlign : 'center'
		,columns : [
			 { header : '路径名称', width : 200, dataIndex : 'CPWDesc', sortable : false }
			//,{ header : '是否分支型路径', width : 80, dataIndex : 'CPWOffShoot', sortable : false }
			,{ header : '路径类型', width : 1, dataIndex : 'CPWType', sortable : false, hidden : true }
		]
		,view : new Ext.grid.GroupingView({
			forceFit : true
			,groupTextTpl : '{[values.rs[0].get("CPWType")]}(共{[values.rs.length]}条路径)'
			,groupByText : '路径类型'
		})
	});
	obj.LocPathWayGridStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysSrv';
		param.QueryName = 'QryCPWToInPathWay';
		param.Arg1 = obj.CurrLogon.CTLOCID;
		param.ArgCnt = 1;
	});
	obj.LocPathWayGridStore.load({});
	
	obj.PathWayStepStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.PathWayStepStore = new Ext.data.Store({
		proxy : obj.PathWayStepStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'StepRowID'
		},
		[
			 { name : 'checked', mapping : 'checked' }
			,{ name : 'StepRowID', mapping : 'StepRowID' }
			,{ name : 'StepDesc', mapping : 'StepDesc' }
		])
		,listeners : {	// 步骤combobox默认取第一条记录
			'load' : function() {
				var record = obj.PathWayStepStore.getAt(0).get("StepRowID");
				obj.PathWayStep.setValue(record);
			}
		}
	});
	obj.PathWayStep = new Ext.form.ComboBox({
		id : 'PathWayStep'
		,width : 300
		,store : obj.PathWayStepStore
		,minChars : 1
		,mode : 'local'
		,displayField : 'StepDesc'
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'StepRowID'
	});
	obj.PathWayStepStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCCPW.OPCPW.FormShowOP';
		param.QueryName = 'GetEpStepByCPWID';
		param.Arg1 = param.Arg1;
		param.ArgCnt = 1;
	});
	
	obj.btnInPathWay = new Ext.Toolbar.Button({
		tooltip : '入径',
		iconCls : 'icon-new',
		text : '入径',
		id : 'btnInPathWay'
	});
	
	obj.PathWaySelectPanel = new Ext.Panel({
		id : 'PathWaySelectPanel'
		,columnWidth : .30
		,frame : false
		,buttonAlign : 'center'
		,layout : 'fit'
		,items : [ obj.LocPathWayGrid ]
		,bbar : [ obj.PathWayStep, '->', obj.btnInPathWay ]
	});
	
	obj.HelpDocumentPanel = new Ext.Panel({
		id : 'HelpDocumentPanel'
		,layout : 'fit'
		,columnWidth : .70
		,frame : true
		,autoScroll : true
	});
	
	obj.PathWayGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.PathWayGridPanelStore = new Ext.data.Store({
		proxy : obj.PathWayGridPanelStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'ImplNewID'
		},
		[
			 { name : 'checked', mapping : 'checked' }
			,{ name : 'ImplNewID', mapping : 'ImplNewID' }
			,{ name : 'AdmitDate', mapping : 'AdmitDate' }
			,{ name : 'AdmitTime', mapping : 'AdmitTime' }
			,{ name : 'Loc', mapping : 'Loc' }
			,{ name : 'PathWayDesc', mapping : 'PathWayDesc' }
			,{ name : 'StatusDesc', mapping : 'StatusDesc' }
			,{ name : 'StepDesc', mapping : 'StepDesc' }
			,{ name : 'StepDate', mapping : 'StepDate' }
			,{ name : 'StepTime', mapping : 'StepTime' }
			,{ name : 'StepDoctor', mapping : 'StepDoctor' }
			,{ name : 'Note', mapping : 'Note' }
		]
	)});
	obj.PathWayGridPanelCheckCol = new Ext.grid.CheckColumn({ header : '', dataIndex : 'checked', width : 50 });
	obj.PathWayGridPanel = new Ext.grid.GridPanel({
		id : 'PathWayGridPanel'
		,store : obj.PathWayGridPanelStore
		,region : 'south'
		,frame : true
		,height : 150
		,buttonAlign : 'center'
		,viewConfig : { forceFit : true }
		,columns : [
			 { header : 'ID', width : 80, dataIndex : 'ImplNewID', sortable : false }
			,{ header : '路径名称', width : 160, dataIndex : 'PathWayDesc', sortable : false }
			,{ header : '状态', width : 80, dataIndex : 'StatusDesc', sortable : false }
			,{ header : '步骤', width : 160, dataIndex : 'StepDesc', sortable : false }
			,{ header : '步骤日期', width : 100, dataIndex : 'StepDate', sortable : false }
			,{ header : '步骤时间', width : 100, dataIndex : 'StepTime', sortable : false }
			,{ header : '医生', width : 100, dataIndex : 'StepDoctor', sortable : false }
			,{ header : '科室', width : 100, dataIndex : 'Loc', sortable : false }
			,{ header : '就诊日期', width : 100, dataIndex : 'AdmitDate', sortable : false }
			,{ header : '就诊时间', width : 100, dataIndex : 'AdmitTime', sortable : false }
			,{ header : '备注', width : 100, dataIndex : 'Note', sortable : false }
		]
	});
	obj.PathWayGridPanelStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCCPW.OPCPW.FormShowOP';
		param.QueryName = 'QryOPCPWByPaadm';
		param.Arg1 = obj.CurrPAADM.EpisodeID;
		param.Arg2 = "O";
		param.ArgCnt = 2;
	});
	
	obj.InPathWayPanel = new Ext.Panel({
		id : 'InPathWayPanel'
		,layout : 'column'
		,region : 'center'
		,frame : true
		,items : [ obj.PathWaySelectPanel, obj.HelpDocumentPanel ]
		,tbar : [ Title ]
	});
	obj.MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'border'
		,items : [ obj.InPathWayPanel, obj.PathWayGridPanel ]
	});
	
	InitMainViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function LinkFormWindow(ImplNewID) {
	var lnk = "dhccpw.mr.opformshow.csp?ImplNewID="+ImplNewID+"&FormMode="+0+"&NewPage="+0+"&PortalFlg="+0;
	document.location.href = lnk;
}

function LoadDHCLogon() {
	var objLogon = new DHCLogon();
	objLogon.SITECODE = session['LOGON.SITECODE'];
	objLogon.USERID = session['LOGON.USERID'];
	objLogon.USERCODE = session['LOGON.USERCODE'];
	objLogon.USERNAME = session['LOGON.USERNAME'];
	objLogon.GROUPID = session['LOGON.GROUPID'];
	objLogon.GROUPDESC = session['LOGON.GROUPDESC'];
	objLogon.CTLOCID = session['LOGON.CTLOCID'];
	var objBaseCTCareProvSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
	if (objLogon.USERID) {
		var ret = objBaseCTCareProvSrv.GetCareProvByUserID(objLogon.USERID, CHR_1);
		if (ret!="") {
			var arrItems = ret.split(CHR_1);
			objLogon.CAREPROVID = arrItems[0];
			objLogon.CAREPROVDesc = arrItems[1];
		}
	}
	return objLogon;
}

function LoadDHCPaPerson(PatientID) {
	var objBasePaPatmasSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PaPatmasSrv");
	if (PatientID) {
		var ret = objBasePaPatmasSrv.GetPatInfoByID(PatientID, "", CHR_1);
		if (ret!="") {
			var arrItems = ret.split(CHR_1);
			var objPaPerson = new DHCPaPerson();
			objPaPerson.PatientID = arrItems[0];
			objPaPerson.PapmiNo = arrItems[1];
			objPaPerson.PatName = arrItems[2];
			objPaPerson.PatSex = arrItems[3];
			objPaPerson.BirthDay = arrItems[4];
			objPaPerson.Age = arrItems[5];
			if (arrItems.length>6) {
				objPaPerson.PatDeceased = arrItems[6];
			}
			if (arrItems.length>7) {
				objPaPerson.Medicare = arrItems[7];
			}
			return objPaPerson;
		}
	}
	return null;
}

function LoadDHCPAADM(EpisodeID) {
	var objBasePAADMSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PAADMSrv");
	if (EpisodeID) {
		var ret = objBasePAADMSrv.GetAdmInfoByID(EpisodeID, CHR_1);
		if (ret!="") {
			var arrItems = ret.split(CHR_1);
			var objPaadm = new DHCPAADM();
			objPaadm.EpisodeID = arrItems[0];
			objPaadm.AdmType = arrItems[1];
			objPaadm.AdmDate = arrItems[2];
			objPaadm.AdmTime = arrItems[3];
			objPaadm.AdmDoc = arrItems[4];
			objPaadm.AdmLoc = arrItems[5];
			objPaadm.AdmWard = arrItems[6];
			objPaadm.AdmRoom = arrItems[7];
			objPaadm.AdmBed = arrItems[8];
			objPaadm.AdmStatus = arrItems[9];
			objPaadm.DischDate = arrItems[10];
			objPaadm.DischTime = arrItems[11];
			objPaadm.MRAdm = arrItems[12];
			return objPaadm;
		}
	}
	return null;
}

function GetClinPathWay(PathWayID) {
	var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
	var ret = objMRClinicalPathWays.GetStringById(PathWayID, CHR_1);
	if (ret!="") {
		var arrItems = ret.split(CHR_1);
		var objCPW = new ClinicalPathWay();
		objCPW.Rowid = arrItems[0];
		objCPW.MRADMDR = arrItems[1];
		objCPW.CPWDR = arrItems[2];
		objCPW.CPWDesc = arrItems[3];
		objCPW.CPWEpDR = arrItems[4];
		objCPW.CPWEpDesc = arrItems[5];
		objCPW.CPWEpStepDR = arrItems[6];
		objCPW.CPWEPStepDesc = arrItems[7];
		objCPW.Status = arrItems[8];
		objCPW.StatusDesc = arrItems[9];
		objCPW.InDoctorDR = arrItems[10];
		objCPW.InDoctorDesc = arrItems[11];
		objCPW.InDate = arrItems[12];
		objCPW.InTime = arrItems[13];
		objCPW.OutDoctorDR = arrItems[14];
		objCPW.OutDoctorDesc = arrItems[15];
		objCPW.OutDate = arrItems[16];
		objCPW.OutTime = arrItems[17];
		objCPW.OutReasonDR = arrItems[18];
		objCPW.OutReasonDesc = arrItems[19];
		objCPW.UpdateUserDR = arrItems[20];
		objCPW.UpdateUserDesc = arrItems[21];
		objCPW.UpdateDate = arrItems[22];
		objCPW.UpdateTime = arrItems[23];
		objCPW.Comments = arrItems[24];
		return objCPW;
	}
	return null;
}

function DHCLogon() {
	var objTMP = new Object();
	objTMP.SITECODE = "";
	objTMP.USERID = "";
	objTMP.USERCODE = "";
	objTMP.USERNAME = "";
	objTMP.GROUPID = "";
	objTMP.GROUPDESC = "";
	objTMP.CTLOCID = "";
	objTMP.CAREPROVID = "";
	objTMP.CAREPROVDesc = "";
	return objTMP;
}

function DHCPaPerson() {
	var objTMP = new Object();
	objTMP.PatientID = "";
	objTMP.PapmiNo = "";
	objTMP.PatName = "";
	objTMP.PatSex = "";
	objTMP.BirthDay = "";
	objTMP.Age = "";
	objTMP.Medicare = "";
	return objTMP;
}

function DHCPAADM() {
	var objTMP = new Object();
	objTMP.EpisodeID = "";
	objTMP.AdmType = "";
	objTMP.AdmDate = "";
	objTMP.AdmDoc = "";
	objTMP.AdmTime = "";
	objTMP.AdmLoc = "";
	objTMP.AdmWard = "";
	objTMP.AdmRoom = "";
	objTMP.AdmBed = "";
	objTMP.AdmStatus = "";
	objTMP.DischDate = "";
	objTMP.DischTime = "";
	objTMP.MRAdm = "";
	return objTMP;
}

function ClinicalPathWay() {
	var objTMP = new Object();
	objTMP.Rowid = "";
	objTMP.MRADMDR = "";
	objTMP.CPWDR = "";
	objTMP.CPWDesc = "";
	objTMP.CPWEpDR = "";
	objTMP.CPWEpDesc = "";
	objTMP.CPWEpStepDR = "";
	objTMP.CPWEPStepDesc = "";
	objTMP.Status = "";
	objTMP.StatusDesc = "";
	objTMP.InDoctorDR = "";
	objTMP.InDoctorDesc = "";
	objTMP.InDate = "";
	objTMP.InTime = "";
	objTMP.OutDoctorDR = "";
	objTMP.OutDoctorDesc = "";
	objTMP.OutDate = "";
	objTMP.OutTime = "";
	objTMP.OutReasonDR = "";
	objTMP.OutReasonDesc = "";
	objTMP.UpdateUserDR = "";
	objTMP.UpdateUserDesc = "";
	objTMP.UpdateDate = "";
	objTMP.UpdateTime = "";
	objTMP.Comments = "";
	return objTMP;
}
