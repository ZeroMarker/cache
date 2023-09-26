var objScreen = new Object();
function InitMainViewport(){
	var obj = new Object();
	objScreen = obj;
	
	obj.CurrLogon = null;
	obj.CurrPaPerson = null;
	obj.CurrPAADM = null;
	obj.CurrClinPathWay = null;
	obj.LocPathWayQryArg1="";
	obj.InitCPWID=ExtTool.GetParam(window,"CpwVerID");   //update by zf 2012-04-21  准入提示路径ID
	obj.InitCPWDesc=ExtTool.GetParam(window,"CpwDesc");   //update by zf 2012-04-21  准入提示路径
	
	//update by zf 2012-10-10
	//处理准入提示符合多条路径问题
	var strCPWID = obj.InitCPWID;
	var arrCPWID = strCPWID.split(String.fromCharCode(2));
	obj.SelectCPWID=arrCPWID[0];
	
	//**************************Start******************************
	//初始化数据
	obj.CurrLogon = LoadDHCLogon();
	obj.CurrPaPerson = LoadDHCPaPerson(PatientID);
	obj.CurrPAADM = LoadDHCPAADM(EpisodeID);
	obj.CurrClinPathWay = LoadClinPathWay(obj.CurrPAADM.MRAdm);
	obj.CurrentStep = LoadCurrentStep(obj.CurrPAADM.EpisodeID)
	
	var AdmTypeDesc="";
	if (obj.CurrPAADM){
		if (obj.CurrPAADM.AdmType=="O"){
			AdmTypeDesc="门诊";
		}else if (obj.CurrPAADM.AdmType=="E"){
			AdmTypeDesc="急诊";
		}else if (obj.CurrPAADM.AdmType=="I"){
			AdmTypeDesc="住院";
		}else{
			AdmTypeDesc="其他";
		}
	}
	var Title = "<b>"+AdmTypeDesc+"</b>";
	Title = Title + separete + separete + "登记号:"+obj.CurrPaPerson.PapmiNo;
	Title = Title + separete + separete + "<b>姓名:</b>"+obj.CurrPaPerson.PatName;
	Title = Title + separete + separete + "性别:"+obj.CurrPaPerson.PatSex;
	Title = Title + separete + separete + "出生日期:"+obj.CurrPaPerson.BirthDay;
	Title = Title + separete + separete + "就诊日期:"+obj.CurrPAADM.AdmDate;
	Title = Title + separete + separete + "就诊时间:"+obj.CurrPAADM.AdmTime;
	Title = Title + separete + separete + "主管医生:"+obj.CurrPAADM.AdmDoc;
	if (obj.CurrClinPathWay){
		Title = Title + separete + separete + "<b>当前路径:</b>"+obj.CurrClinPathWay.CPWDesc;
	}
	if (obj.CurrentStep){
		Title = Title + separete + separete + "入院第"+obj.CurrentStep.admDateNo+"日";		
		Title = Title + separete + separete + "入径第"+obj.CurrentStep.cpwDateNo+"日";
	}
	var winTitle=Title;
	//***************************End*******************************
	
	obj.LocPathWayGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.LocPathWayGridStore = new Ext.data.GroupingStore({
		proxy: obj.LocPathWayGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CPWID'
		}, 
		[
			{name: 'CPWID', mapping: 'CPWID'}
			,{name: 'CPWDesc', mapping: 'CPWDesc'}
			,{name: 'CPWType', mapping: 'CPWType'}
			,{name: 'CPWOffShoot', mapping: 'CPWOffShoot'}
		])
		,sortInfo:{field:'CPWID',direction:'ASC'}
		,groupField:'CPWType'
	});
	obj.LocPathWayGrid = new Ext.grid.GridPanel({
		id : 'LocPathWayGrid'
		,store : obj.LocPathWayGridStore
		,region : 'south'
		,frame : true
		,buttonAlign : 'center'
		,columns: [
			{header: '路径名称', width: 200, dataIndex: 'CPWDesc', sortable: false}
			,{header: '是否分支型路径', width: 80, dataIndex: 'CPWOffShoot', sortable: false}
			,{header: '路径类型', width: 1, dataIndex: 'CPWType', sortable: false,hidden:true}
		]
		,view : new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl:'{[values.rs[0].get("CPWType")]}(共{[values.rs.length]}条路径)',
			groupByText:'路径类型'
		})
	});
	obj.LocPathWayGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysSrv';
			param.QueryName = 'QryCPWToInPathWay';
			param.Arg1 = obj.LocPathWayQryArg1;
			param.ArgCnt = 1;
	});
	
	var locPathWay = new Ext.Toolbar.Button({
		tooltip: '科室常用路径',
		//iconCls: 'icon-new',
		text:'科室常用路径',
		id: 'btnLocPathWay',
		handler: function (){
			obj.LocPathWayQryArg1=obj.CurrLogon.CTLOCID;
			obj.LocPathWayGridStore.load({
    			//params: {start:0,limit:20},
				callback: function(records, options, success){
					obj.LocPathWayGrid.getView().expandAllGroups();
				},
				scope: obj.LocPathWayGridStore,
				add: false
			});
		}
	});
	var allPathWay = new Ext.Toolbar.Button({
		tooltip: '其它路径',
		//iconCls: 'icon-new',
		text:'其它路径',
		id: 'btnAllPathWay',
		handler: function (){
			obj.LocPathWayQryArg1="";
			obj.LocPathWayGridStore.load({
				//params: {start:0,limit:20},
				callback: function(records, options, success){
					obj.LocPathWayGrid.getView().collapseAllGroups();
				},
				scope: obj.LocPathWayGridStore,
				add: false
			});
		}
	});
	obj.PathWaySelectPanel = new Ext.Panel({
		id : 'PathWaySelectPanel'
		,columnWidth : .30
		,layout : 'fit'
		,items:[
			obj.LocPathWayGrid
		]
		,bbar : [
			'-'
			,locPathWay
			,'-'
			,allPathWay
			,'-'
		]
	});
	
	var inPathWay = new Ext.Toolbar.Button({
		tooltip: '入径',
		iconCls: 'icon-new',
		text:'入径',
		id: 'btnInPathWay'
	});
	var formDisplay = new Ext.Toolbar.Button({
		tooltip: '查看表单',
		iconCls: 'icon-export',
		text:'查看表单',
		id: 'btFormDisplay'
	});
	var btnSatisfactionSurvey = new Ext.Toolbar.Button({
		tooltip: '打印满意度调查表',
		iconCls: 'icon-print',
		text:'打印满意度调查表',
		id: 'btnSatisfactionSurvey',
		handler: function (){
			PrintSatisfactionSurvey(obj.CurrClinPathWay,obj.CurrPaPerson,obj.CurrPAADM)
		}
	});
	var btnInformedConsert = new Ext.Toolbar.Button({
		tooltip: '打印知情同意书',
		iconCls: 'icon-print',
		text:'打印知情同意书',
		id: 'btnInformedConsert',
		handler: function (){
			PrintInformedConsert(obj.CurrClinPathWay,obj.CurrPaPerson,obj.CurrPAADM)
		}
	});
	
	obj.HelpDocumentPanel = new Ext.Panel({
		id : 'HelpDocumentPanel'
		,layout : 'fit'
		,modal : true
		,columnWidth : .70
		,renderTo : Ext.getBody()
		,autoScroll:true
		,bbar : [
			"<i>相关操作:</i>"
			,'-'
			,inPathWay
			,formDisplay
			,btnInformedConsert
			,btnSatisfactionSurvey
			,"-"
		]
	});
	obj.tplHelpDoc=new Ext.XTemplate(
		'<table border=.1 width=100% height=100%>',
			'<tr>',
				'<td bgcolor="#FFFFFF" valign="top" >{helpDocument}</td>',
			'</tr>',
		'</table>'
	);
	
	obj.PathWayGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.PathWayGridPanelStore = new Ext.data.Store({
		proxy: obj.PathWayGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'CPWMRAdm', mapping: 'CPWMRAdm'}
			,{name: 'CPWDR', mapping: 'CPWDR'}
			,{name: 'CPWDesc', mapping: 'CPWDesc'}
			,{name: 'CPWEpDR', mapping: 'CPWEpDR'}
			,{name: 'CPWEpDesc', mapping: 'CPWEpDesc'}
			,{name: 'CPWEpStepDR', mapping: 'CPWEpStepDR'}
			,{name: 'CPWEPStepDesc', mapping: 'CPWEPStepDesc'}
			,{name: 'Status', mapping: 'Status'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'InDoctorDR', mapping: 'InDoctorDR'}
			,{name: 'InDoctorDesc', mapping: 'InDoctorDesc'}
			,{name: 'InDate', mapping: 'InDate'}
			,{name: 'InTime', mapping: 'InTime'}
			,{name: 'OutDoctorDR', mapping: 'OutDoctorDR'}
			,{name: 'OutDoctorDesc', mapping: 'OutDoctorDesc'}
			,{name: 'OutDate', mapping: 'OutDate'}
			,{name: 'OutTime', mapping: 'OutTime'}
			,{name: 'OutReasonDR', mapping: 'OutReasonDR'}
			,{name: 'OutReasonDesc', mapping: 'OutReasonDesc'}
			,{name: 'UpdateUserDR', mapping: 'UpdateUserDR'}
			,{name: 'UpdateUserDesc', mapping: 'UpdateUserDesc'}
			,{name: 'UpdateDate', mapping: 'UpdateDate'}
			,{name: 'UpdateTime', mapping: 'UpdateTime'}
			,{name: 'Comments', mapping: 'Comments'}
		])
	});
	obj.PathWayGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.PathWayGridPanel = new Ext.grid.GridPanel({
		id : 'PathWayGridPanel'
		,store : obj.PathWayGridPanelStore
		,region : 'south'
		,frame : true
		,height : 150
		//,title : '出入径记录'
		,buttonAlign : 'center'
		,viewConfig : {forceFit:true}
		,columns: [
			{header: '临床路径', width: 200, dataIndex: 'CPWDesc', sortable: false}
			,{header: '状态', width: 60, dataIndex: 'StatusDesc', sortable: false}
			//,{header: '入径阶段', width: 180, dataIndex: 'CPWEpDesc', sortable: false}
			,{header: '入径步骤', width: 100, dataIndex: 'CPWEPStepDesc', sortable: false}
			,{header: '入径人', width: 60, dataIndex: 'InDoctorDesc', sortable: false}
			,{header: '入径日期', width: 80, dataIndex: 'InDate', sortable: false}
			,{header: '入径时间', width: 60, dataIndex: 'InTime', sortable: false}
			,{header: '出径人', width: 60, dataIndex: 'OutDoctorDesc', sortable: false}
			,{header: '出径日期', width: 80, dataIndex: 'OutDate', sortable: false}
			,{header: '出径时间', width: 60, dataIndex: 'OutTime', sortable: false}
			,{header: '出径原因', width: 100, dataIndex: 'OutReasonDesc', sortable: false}
			,{header: '更新人', width: 60, dataIndex: 'UpdateUserDesc', sortable: false}
			,{header: '更新日期', width: 80, dataIndex: 'UpdateDate', sortable: true}
			,{header: '更新时间', width: 60, dataIndex: 'UpdateTime', sortable: false}
			,{header: '备注', width: 300, dataIndex: 'Comments', sortable: false}
		]
	});
	obj.PathWayGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.ClinicalPathWays';
		param.QueryName = 'QryPathWayByAdm';
		if (obj.CurrPAADM){
			param.Arg1 = obj.CurrPAADM.MRAdm ;
		}else{
			param.Arg1 = "";
		}
		param.ArgCnt = 1;
	});
	
	obj.InPathWayPanel = new Ext.Panel({
		id : 'InPathWayPanel'
		,layout : 'column'
		,region : 'center'
		,frame : true
		,items:[
			obj.PathWaySelectPanel
			,obj.HelpDocumentPanel
		]
		,tbar:[winTitle]
	});
	obj.MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'border'
		,items:[
			obj.InPathWayPanel
			,obj.PathWayGridPanel
		]
	});
	
	InitMainViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}


//**************************************************************************************

function LoadDHCPaPerson(argPatientID){
	var objBasePaPatmasSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PaPatmasSrv");
	if (argPatientID){
		var ret = objBasePaPatmasSrv.GetPatInfoByID(argPatientID,"",CHR_1);
		if (ret!=""){
			var arrItems=ret.split(CHR_1);
			var objPaPerson=new DHCPaPerson();
			objPaPerson.PatientID = arrItems[0];
			objPaPerson.PapmiNo = arrItems[1];
			objPaPerson.PatName = arrItems[2];
			objPaPerson.PatSex = arrItems[3];
			objPaPerson.BirthDay = arrItems[4];
			objPaPerson.Age = arrItems[5];
			if (arrItems.length > 6)
			{
				objPaPerson.PatDeceased = arrItems[6];  //Add By NiuCaicai 2011-07-27 FixBug:105  临床应用--出入径管理-已死亡病人仍可进行出入径操作
			}
			if (arrItems.length >7 )
			{
				objPaPerson.Medicare = arrItems[7];
			}
			return objPaPerson;
		}
	}
	return null
}
	
function LoadDHCLogon(){
	var objLogon=new DHCLogon();
	objLogon.SITECODE = session['LOGON.SITECODE'];
	objLogon.USERID = session['LOGON.USERID'];
	objLogon.USERCODE = session['LOGON.USERCODE'];
	objLogon.USERNAME = session['LOGON.USERNAME'];
	objLogon.GROUPID = session['LOGON.GROUPID'];
	objLogon.GROUPDESC = session['LOGON.GROUPDESC'];
	objLogon.CTLOCID = session['LOGON.CTLOCID'];
	var objBaseCTCareProvSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
	if (objLogon.USERID){
		var ret = objBaseCTCareProvSrv.GetCareProvByUserID(objLogon.USERID,CHR_1);
		if (ret!=""){
			var arrItems=ret.split(CHR_1)
			objLogon.CAREPROVID = arrItems[0];
			objLogon.CAREPROVDesc = arrItems[1];
		}
	}
	return objLogon;
}
	
function LoadDHCPAADM(argEpisodeID){
	var objBasePAADMSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PAADMSrv");
	if (argEpisodeID){
		var ret = objBasePAADMSrv.GetAdmInfoByID(argEpisodeID,CHR_1);
		if (ret!=""){
			var arrItems=ret.split(CHR_1);
			var objPaadm=new DHCPAADM();
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

function LoadClinPathWay(argMRAdm){
	var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
	if (argMRAdm){
		var ret = objMRClinicalPathWays.GetActiveCPWByadm(argMRAdm,CHR_1);
	}
	if (ret!=""){
		var arrItems=ret.split(CHR_1);
		var objCPW=new ClinicalPathWay();
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
	
function LoadCurrentStep(EpisodeID){
	var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
	var ret = objMRClinicalPathWays.GetCurrentStepInfo(EpisodeID,CHR_1)
	if (ret!=""){
		var arrItems=ret.split(CHR_1);
		var objCPW=new CPWStep();
		objCPW.admDateNo = arrItems[0];
		objCPW.cpwDateNo = arrItems[1];
		objCPW.currentStepId = arrItems[2];
		objCPW.currentStepDesc = arrItems[3];
		objCPW.currentStepDayNo = arrItems[4];
		return objCPW;
	}
}

function DHCLogon(){
	var objTMP = new Object();
	objTMP.SITECODE = "";
	objTMP.USERID = "";
	objTMP.USERCODE = "";
	objTMP.USERNAME = "";
	objTMP.GROUPID = "";
	objTMP.GROUPDESC = "";
	objTMP.CTLOCID ="";
	objTMP.CAREPROVID ="";
	objTMP.CAREPROVDesc ="";
	return objTMP;
}

function DHCPaPerson(){
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

function DHCPAADM(){
	var objTMP = new Object();
	objTMP.EpisodeID = "";
	objTMP.AdmType = "";
	objTMP.AdmDate = "";
	objTMP.AdmTime = "";
	objTMP.AdmDoc = "";
	objTMP.AdmLoc = "";
	objTMP.AdmWard ="";
	objTMP.AdmRoom ="";
	objTMP.AdmBed ="";
	objTMP.AdmStatus = "";
	objTMP.DischDate = "";
	objTMP.DischTime = "";
	objTMP.MRAdm = "";
	return objTMP;
}

function ClinicalPathWay(){
	var objTMP = new Object();
	objTMP.Rowid = "";
	objTMP.MRADMDR = "";
	objTMP.CPWDR = "";
	objTMP.CPWDesc = "";
	objTMP.CPWEpDR = "";
	objTMP.CPWEpDesc = "";
	objTMP.CPWEpStepDR ="";
	objTMP.CPWEPStepDesc ="";
	objTMP.Status ="";
	objTMP.StatusDesc ="";
	objTMP.InDoctorDR ="";
	objTMP.InDoctorDesc ="";
	objTMP.InDate ="";
	objTMP.InTime ="";
	objTMP.OutDoctorDR ="";
	objTMP.OutDoctorDesc ="";
	objTMP.OutDate ="";
	objTMP.OutTime ="";
	objTMP.OutReasonDR ="";
	objTMP.OutReasonDesc ="";
	objTMP.UpdateUserDR ="";
	objTMP.UpdateUserDesc ="";
	objTMP.UpdateDate ="";
	objTMP.UpdateTime ="";
	objTMP.Comments ="";
	return objTMP;
}

function CPWStep(){
	var objTMP = new Object();
	objTMP.admDateNo = "";
	objTMP.cpwDateNo = "";
	objTMP.currentStepId = "";
	objTMP.currentStepDesc = "";
	objTMP.currentStepDayNo = "";
	return objTMP;
}

//连接表单界面
function LinkFormWindow(PathWayID){
	var lnk="dhccpw.mr.formshow.csp?a=a&ConsultFlag=1&NurseFlag=1&OEOutOrderFlag=1&NEOutOrderFlag=1&VarianceFlag=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+MRAdm+"&PathWayID="+PathWayID+"&b=b";
	document.location.href=lnk;
}