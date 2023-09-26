var CHR_1=String.fromCharCode(1);
var separete="&nbsp;";

function InitPageErrorWin(){
	
	function GetObj_PAADM(argEpisodeID){
		var objBasePAADMSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PAADMSrv");
		if (argEpisodeID){
			var ret = objBasePAADMSrv.GetAdmInfoByID(argEpisodeID,CHR_1);
			if (ret!=""){
				var arrItems=ret.split(CHR_1);
				var objPaadm=new Obj_PAADM();
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
				objPaadm.PatientID = arrItems[13];
				return objPaadm;
			}
		}
		return null;
	}
	
	function GetObj_PaPerson(argPatientID){
		var objBasePaPatmasSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PaPatmasSrv");
		if (argPatientID){
			var ret = objBasePaPatmasSrv.GetPatInfoByID(argPatientID,"",CHR_1);
			if (ret!=""){
				var arrItems=ret.split(CHR_1);
				var objPaPerson=new Obj_PaPerson();
				objPaPerson.PatientID = arrItems[0];
				objPaPerson.PapmiNo = arrItems[1];
				objPaPerson.PatName = arrItems[2];
				objPaPerson.PatSex = arrItems[3];
				objPaPerson.BirthDay = arrItems[4];
				objPaPerson.Age = arrItems[5];
				return objPaPerson;
			}
		}
		return null
	}
	
	function GetObj_ClinPathWay(argPathWayID){
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var ret = objMRClinicalPathWays.GetStringById(argPathWayID,CHR_1);
		if (ret!=""){
			var arrItems=ret.split(CHR_1);
			var objCPW=new Obj_ClinPathWay();
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
	
	function Obj_PaPerson(){
		var objTMP = new Object();
		objTMP.PatientID = "";
		objTMP.PapmiNo = "";
		objTMP.PatName = "";
		objTMP.PatSex = "";
		objTMP.BirthDay = "";
		objTMP.Age = "";
		return objTMP;
	}
	
	function Obj_PAADM(){
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
		objTMP.PatientID = "";
		return objTMP;
	}
	
	function Obj_ClinPathWay(){
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
	
	var obj = new Object();
	
	obj.Paadm=GetObj_PAADM(EpisodeID);
	obj.PaPerson=GetObj_PaPerson(PatientID);
	obj.ClinPathWay=GetObj_ClinPathWay(PathWayID);
	
	var ErrorHtml=""
	ErrorHtml = ErrorHtml + '               <h1>友情提示:</h1>'
	ErrorHtml = ErrorHtml + '               <ul id="ErrorUl1" style="list-style:none;margin-left:0;">'
	ErrorHtml = ErrorHtml + '                 <li>此患者不是临床路径患者,不能进行当前操作!</li>'
	ErrorHtml = ErrorHtml + '                 <li></li>'
	ErrorHtml = ErrorHtml + '               </ul>'
	ErrorHtml = ErrorHtml + '               <h1>患者信息:</h1>'
	ErrorHtml = ErrorHtml + '               <ul id="ErrorUl2" style="list-style:none;margin-left:0;">'
	ErrorHtml = ErrorHtml + '                 <li>登记号 :'+obj.PaPerson.PapmiNo+'</li>'
	ErrorHtml = ErrorHtml + '                 <li>姓名 :'+obj.PaPerson.PatName+'</li>'
	ErrorHtml = ErrorHtml + '                 <li>性别 :'+obj.PaPerson.PatSex+'</li>'
	ErrorHtml = ErrorHtml + '                 <li>出生日期 :'+obj.PaPerson.BirthDay+'</li>'
	ErrorHtml = ErrorHtml + '                 <li>入院日期 :'+obj.Paadm.AdmDate+'</li>'
	ErrorHtml = ErrorHtml + '                 <li>科室 :'+obj.Paadm.AdmLoc+'</li>'
	ErrorHtml = ErrorHtml + '                 <li>病区 :'+obj.Paadm.AdmWard+'</li>'
	ErrorHtml = ErrorHtml + '                 <li>主管医生 :'+obj.Paadm.AdmDoc+'</li>'
	ErrorHtml = ErrorHtml + '               </ul>'
	
	obj.ErrorInfoPanel = new Ext.Panel({
		id : 'ErrorInfoPanel'
		,width : 250
		,html:'<div id="win">'+ErrorHtml+'</div>'
		,frame : true
	});
	
	obj.PageErrorWin = new Ext.Viewport({
		id : 'PageErrorWin'
		,region : document.body
		,frame : true
		//,layout : 'fit'
		,items:[
			obj.ErrorInfoPanel
		]
	});
	
	return obj;
}