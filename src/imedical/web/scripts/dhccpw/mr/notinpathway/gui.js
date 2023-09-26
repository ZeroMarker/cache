var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_ER=String.fromCharCode(13)+String.fromCharCode(10);
var separete="&nbsp;";

function InitMainViewport(){
	var obj = new Object();
	obj.CurrLogon = null;
	obj.CurrPaPerson = null;
	obj.CurrPAADM = null;
	
	//初始化数据
	obj.CurrLogon = LoadDHCLogon();
	obj.CurrPaPerson = LoadDHCPaPerson(PatientID);
	obj.CurrPAADM = LoadDHCPAADM(EpisodeID);
	obj.InPathLog = LoadInPathLog(EpisodeID);
	
	var Title = "姓名:"+obj.CurrPaPerson.PatName;
	Title = Title + separete + separete + "性别:"+obj.CurrPaPerson.PatSex;
	Title = Title + separete + separete + "路径:"+VersionDesc;
	var winTitle=Title;
	
	obj.txtResume = new Ext.form.TextArea({
		id : 'txtResume'
		,height : 50
		,width : 60
		,fieldLabel : '备注'
		,blankText:"请填写备注信息!"
		,emptyText:"请填写备注信息!"
	});
	
	obj.ReasonGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ReasonGridStore = new Ext.data.GroupingStore({
		proxy: obj.ReasonGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping: 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'CategDesc', mapping: 'CategDesc'}
		])
		,sortInfo:{field:'Rowid',direction:'ASC'}
		,groupField:'CategDesc'
	});
	obj.ReasonGridCheckCol = new Ext.grid.CheckColumn({header:'选择', dataIndex: 'checked', width: 50 });
	obj.ReasonGrid = new Ext.grid.GridPanel({
		id : 'ReasonGrid'
		,store : obj.ReasonGridStore
		,region : 'center'
		,frame : true
		,buttonAlign : 'center'
		,columns: [
			obj.ReasonGridCheckCol
			,{header: '原因', width: 200, dataIndex: 'Desc', sortable: false}
			,{header: '原因分类', width: 1, dataIndex: 'CategDesc', sortable: false,hidden:true}
		]
		,plugins : obj.ReasonGridCheckCol
		,tbar:[winTitle]
		,view : new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl:'{[values.rs[0].get("CategDesc")]}(共{[values.rs.length]}条原因)',
			groupByText:'原因分类'
		})
	});
	obj.ReasonGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
			param.QueryName = 'QryReasonByType';
			param.Arg1 = "N";
			param.ArgCnt = 1;
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '确定'
	});
	
	obj.ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 50
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'fit'
		,frame : true
		,region : 'south'
		,height : 100
		,items:[
			obj.txtResume
		]
		,buttons:[
			obj.btnSave
		]
	});
	
	obj.MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'border'
		,items:[
			obj.ReasonGrid
			,obj.ConditionPanel
		]
	});
	
	InitMainViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

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
			objPaPerson.PatDeceased = arrItems[6];
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

function LoadInPathLog(argEpisodeID){
	var objInPathLogSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWayInPathLogSrv");
	if (argEpisodeID){
		var ret = objInPathLogSrv.GetLogByPaadm(argEpisodeID,CHR_1);
		if (ret!=""){
			var arrItems=ret.split(CHR_1);
			var objInPathLog=new Object();
			objInPathLog.RowID = arrItems[0];
			objInPathLog.Paadm = arrItems[1];
			objInPathLog.PathWayID = arrItems[2];
			objInPathLog.NoticeDate = arrItems[3];
			objInPathLog.NoticeTime = arrItems[4];
			objInPathLog.DoctorID = arrItems[5];
			objInPathLog.MRCICDRowid = arrItems[6];
			objInPathLog.NoticePathWayVerID = arrItems[7];
			objInPathLog.NotInCPWReason = arrItems[8];
			objInPathLog.NotInCPWResume = arrItems[9];
			return objInPathLog;
		}
	}
	return null;
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