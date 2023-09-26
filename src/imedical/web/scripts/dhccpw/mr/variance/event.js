var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_ER=String.fromCharCode(13)+String.fromCharCode(10);
var separete="&nbsp;";
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

function Load_DHCPAADM(argEpisodeID){
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

function Load_DHCPaPerson(argPatientID){
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
			return objPaPerson;
		}
	}
	return null
}

function Load_DHCLogon(){
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

function ClinPathWaysVariance(){
	var objTMP = new Object();
	objTMP.Rowid = "";
	objTMP.EpisodeDR = "";
	objTMP.EpisodeDesc = "";
	objTMP.CategoryDR = "";
	objTMP.CategoryDesc = "";
	objTMP.ReasonDR = "";
	objTMP.ReasonDesc = "";
	objTMP.UserDR = "";
	objTMP.UserName = "";
	objTMP.UpdateDate = "";
	objTMP.UpdateTime = "";
	objTMP.DoctorDR = "";
	objTMP.DoctorDesc = "";
	objTMP.Note = "";
	return objTMP;
}

function InitMainViewportEvent(obj) {
	//***************************************************************
	// 事件加载
	//***************************************************************
	obj.LoadEvent = function(args){
		obj.Load_Init();
		
		obj.SubPanel5.on("rowclick", obj.SubPanel5_OnRowClick, obj);
		obj.SubPanel5.on("rowdblclick", obj.SubPanel5_OnRowClick, obj);
		
		obj.cboVarCateg.on("select", obj.SubPanel6_cboVarCateg_select, obj);
		obj.btnUpdateCPWV.on("click", obj.SubPanel6_btnUpdateCPWV_click, obj);
		//obj.btnAuditCPWV.on("click", obj.SubPanel6_btnAuditCPWV_click, obj);
	};
	
	//***************************************************************
	// 初始化
	//***************************************************************
	obj.Load_Init = function(){
		obj.CurrClinPathWay = obj.Load_ClinPathWay(obj.CurrPAADM.MRAdm,"");
		obj.LoadClinPathWayTree();
		obj.LoadTitle();
		if (!obj.CurrClinPathWay) return;
		obj.SubPanel5_Init();
		if (!obj.CurrCPWVariance){
			obj.CurrCPWVariance = new ClinPathWaysVariance();
		}
		obj.CurrCPWVariance.EpisodeDR = obj.CurrentStep.currentStepId;
		obj.CurrCPWVariance.EpisodeDesc = obj.CurrentStep.currentStepDesc;
		obj.SubPanel6_Init();
	}
	
	obj.LoadTitle = function(){
		var Title = "登记号:" + obj.CurrPaPerson.PapmiNo;
		Title = Title + separete + "姓名:"+obj.CurrPaPerson.PatName;
		Title = Title + separete + "性别:"+obj.CurrPaPerson.PatSex;
		Title = Title + separete + "出生日期:"+obj.CurrPaPerson.BirthDay;
		Title = Title + separete + "就诊日期:"+obj.CurrPAADM.AdmDate;
		Title = Title + separete + "就诊时间:"+obj.CurrPAADM.AdmTime;
		Title = Title + separete + "主管医生:"+obj.CurrPAADM.AdmDoc;
		if (obj.CurrClinPathWay){
			Title = Title + separete + "入院第"+obj.CurrentStep.admDateNo+"日";
			Title = Title + separete + "当前路径:"+obj.CurrClinPathWay.CPWDesc;
			Title = Title + separete + "入径第"+obj.CurrentStep.cpwDateNo+"日";
			Title = Title + separete + "当前步骤:"+obj.CurrentStep.currentStepDesc;
			Title = Title + separete + "当前步骤第"+obj.CurrentStep.currentStepDayNo+"日";
		}
		//obj.TitleLabel.setText(Title);
		if(obj.TitlePanel.rendered){
		  obj.TitlePanel.body.update(Title);
		}else{
		  obj.TitlePanel.on("render" , function(){panel.body.update(Title)});
		}
	}
		
	obj.SubPanel5_Init = function(){
		obj.SubPanel5Store.load({});
	}
	
	obj.SubPanel6_Init = function(){
		obj.SubFormPanel6.getForm().reset();
		if (obj.CurrCPWVariance){
			obj.txtVarEp.setValue(obj.CurrCPWVariance.EpisodeDesc);
			obj.cboVarCateg.clearValue();
			obj.cboVarCateg.setValue(obj.CurrCPWVariance.CategoryDR);
			obj.cboVarCateg.setRawValue(obj.CurrCPWVariance.CategoryDesc);
			obj.cboVarReason.clearValue();
			obj.cboVarReason.setValue(obj.CurrCPWVariance.ReasonDR);
			obj.cboVarReason.setRawValue(obj.CurrCPWVariance.ReasonDesc);
			obj.cboAuditDoctor.clearValue();
			obj.txtaVarResume.setValue(obj.CurrCPWVariance.Note);
			/*obj.cboAuditDoctor.setValue(obj.CurrCPWVariance.DoctorDR);
			obj.cboAuditDoctor.setRawValue(obj.CurrCPWVariance.DoctorDesc);
			obj.txtaVarResume.setValue(obj.CurrCPWVariance.Note);
			obj.txtAuditPassword.setValue("");
			obj.cboVarCateg.enable();
			obj.cboVarReason.enable();
			if (obj.CurrCPWVariance.Rowid){
				if (obj.CurrLogon.CAREPROVID){
					obj.cboAuditDoctor.disable();
				}else{
					obj.cboAuditDoctor.enable();
				}
				obj.txtAuditPassword.enable();
			}else{
				obj.cboAuditDoctor.disable();
				obj.txtAuditPassword.disable();
			}
			obj.btnAuditCPWV.enable();
			obj.txtaVarResume.enable();*/
			obj.btnUpdateCPWV.enable();
		}else{
			/*
			obj.txtVarEp.setValue("");
			obj.cboVarCateg.clearValue();
			obj.cboVarReason.clearValue();
			obj.cboAuditDoctor.clearValue();
			obj.txtaVarResume.setValue("");
			obj.txtAuditPassword.setValue("");
			obj.cboVarCateg.disable();
			obj.cboVarReason.disable();
			obj.cboAuditDoctor.disable();
			obj.txtaVarResume.disable();
			obj.btnUpdateCPWV.disable();
			obj.btnAuditCPWV.disable();
			obj.txtAuditPassword.disable();
			*/
		}
	}
	
	
	obj.LoadClinPathWayTree = function(){
		if (!obj.CurrClinPathWay) return;
		var cpwRowid=obj.CurrClinPathWay.CPWDR;
		var cpwDesc=obj.CurrClinPathWay.CPWDesc;
	  	var objPathWayTree = new Ext.tree.TreePanel({
			autoScroll : true
			,root : new Ext.tree.AsyncTreeNode({text:cpwDesc,id:cpwRowid})
			//,width : 100
			,region : 'center'
			,rootVisible:(cpwDesc!="")
			,autoScroll:true
			,loader : new Ext.tree.TreeLoader({nodeParameter : "Arg1",	dataUrl:ExtToolSetting.TreeQueryPageURL, baseParams : {ClassName:"web.DHCCPW.MRC.ClinPathWaysSrv",	QueryName:"QueryCPWTree" ,ArgCnt:1}})
			,contextMenu:  new Ext.menu.Menu({
			        id :'rightClickCont',
			        items : [] ,
			        listeners: {
			            itemclick: function(item) {
	                        var node = objPathWayTree.getSelectionModel().getSelectedNode();
	                        //InPathWay(node.id);
	                        //alert(node.id);
	                        obj.menuRecordVariance(node);
			            }
			        }
		    })
			,listeners: {
				contextmenu: function(node, e) {
					node.select();
				    var nodeIds=node.attributes.id.split("||");
				    if (nodeIds.length==3){
						    var cm = node.getOwnerTree().contextMenu;
						    cm.contextNode = node;
						    cm.removeAll();
						    var menuSelectEpStep = new Ext.menu.Item({
						    	//id:'menuRecordVariance',    //removed by wuqk 2010-08-06
						    	text: '记录变异'
						    	,disabled : (!obj.CurrClinPathWay)
						    	,iconCls : 'icon-add'
						    	,tooltip: '记录变异'
						    });
							cm.add(menuSelectEpStep);
						    cm.showAt(e.getXY());
				    }
				}
			}
		});
		obj.SubPanel2.removeAll(true);
		obj.SubPanel2.add(objPathWayTree);
	  	obj.SubPanel2.doLayout();
	  	objPathWayTree.getRootNode().expand();
	}
	
	obj.Load_ClinPathWay = function(argMRAdm,argCPWID){
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		if (argMRAdm){
			var ret = objMRClinicalPathWays.GetActiveCPWByadm(argMRAdm,CHR_1);
			obj.CurrentStep = obj.LoadCurrentStep(objMRClinicalPathWays,obj.CurrPAADM.EpisodeID)
		}else if (argCPWID){
			//var ret = objMRClinicalPathWays.GetStringById(argCPWID,CHR_1);
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
	obj.LoadCurrentStep = function(service,EpisodeID){
		var ret = service.GetCurrentStepInfo(EpisodeID,CHR_1)
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
	obj.SubPanel5_OnRowClick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.SubPanel5Store.getAt(rowIndex);
		var objSelCPWVariance=obj.SubPanel5_GetDataByRow(objRec);
		if ((obj.objSelCPWVariance)&&(objSelCPWVariance.Rowid==obj.CurrCPWVariance.Rowid)){
			obj.CurrCPWVariance = null;
		}else{
			obj.CurrCPWVariance = objSelCPWVariance;
		}
		obj.SubPanel6_Init();
	}
	
	obj.SubPanel6_cboVarCateg_select = function(){
		obj.cboVarReason.clearValue();
	}
	
	obj.SubPanel5_GetDataByRow = function(objTableRow){
		if (objTableRow)
		{
			var objCPWV = new ClinPathWaysVariance();
			objCPWV.Rowid = objTableRow.get("VID");
			objCPWV.EpisodeDR = objTableRow.get("VEpisodeDR");
			objCPWV.EpisodeDesc = objTableRow.get("VEpisodeDesc");
			objCPWV.CategoryDR = objTableRow.get("VCategoryDR");
			objCPWV.CategoryDesc = objTableRow.get("VCategoryDesc");
			objCPWV.ReasonDR = objTableRow.get("VReasonDR");
			objCPWV.ReasonDesc = objTableRow.get("VReasonDesc");
			objCPWV.UserDR = objTableRow.get("VUserDR");
			objCPWV.UserName = objTableRow.get("VUserDesc");
			objCPWV.UpdateDate = objTableRow.get("VDate");
			objCPWV.UpdateTime = objTableRow.get("VTime");
			objCPWV.DoctorDR = objTableRow.get("VDoctorDR");
			objCPWV.DoctorDesc =  objTableRow.get("VDoctorDesc");
			objCPWV.Note = objTableRow.get("VNote");
			return objCPWV;
		}else{
			return null;
		}
	}
	
	obj.menuRecordVariance = function(node){
		if (obj.CurrClinPathWay){
			if (obj.CurrClinPathWay.Status!=="I")
			{
				ExtTool.alert("提示","无激活状态临床路径,无法记录变异记录!");
				return
			}
		}else{
			ExtTool.alert("提示","无激活状态临床路径,无法记录变异记录!");
			return
		}
		//if (!obj.CurrCPWVariance){
			obj.CurrCPWVariance = new ClinPathWaysVariance();
		//}
		obj.CurrCPWVariance.EpisodeDR = node.attributes.id;
		obj.CurrCPWVariance.EpisodeDesc = node.attributes.text;
		obj.SubPanel6_Init();
	}
	
	obj.SubPanel6_btnUpdateCPWV_click = function(){
		var InputErr="",InputSign="";
		var VarEp="",VarCateg="",VarReason="",AuditDoctor="",VarResume="";
		if (!obj.CurrCPWVariance) return;
		if (obj.CurrCPWVariance.EpisodeDR){
			VarEp=obj.CurrCPWVariance.EpisodeDR;
		}else{
			InputErr = InputErr + "临床路径阶段为空,请认真填写!" + CHR_ER;
		}
		if (obj.cboVarCateg.getValue()){
			VarCateg = obj.cboVarCateg.getValue();
		}else{
			InputErr = InputErr + "变异类型为空,请认真填写!" + CHR_ER;
		}
		if (obj.cboVarReason.getValue()){
			VarReason = obj.cboVarReason.getValue();
		}else{
			InputErr = InputErr + "变异原因为空,请认真填写!" + CHR_ER;
		}
		if (obj.txtaVarResume.getValue()){
			VarResume = obj.txtaVarResume.getValue();
		}else{
			InputErr = InputErr + "备注不允许为空,请认真填写!" + CHR_ER;
		}
		if (InputErr) {
			ExtTool.alert("提示",InputErr+InputSign);
			return;
		}else if (InputSign){
			ExtTool.alert("提示",InputSign);
		}
		if (!obj.CurrCPWVariance.Rowid){
			obj.CurrCPWVariance.Rowid = obj.CurrClinPathWay.Rowid;
		}
		var ctpcpService = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		var docString=ctpcpService.GetCareProvByUserID(obj.CurrLogon.USERID);
		var rcdDoctor=docString.split("^")[0];
		
		//1:Rowid 2:VEpisodeDR 3:VCategoryDR 4:VReasonDR 5:VUserDR 6:VDate 7:VTime 8:VDoctorDR 9:VNote
		var InputStr=obj.CurrCPWVariance.Rowid;
		InputStr=InputStr + "^" + VarEp;
		InputStr=InputStr + "^" + VarCateg;
		InputStr=InputStr + "^" + VarReason;
		InputStr=InputStr + "^" + obj.CurrLogon.USERID;
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^" + rcdDoctor; // + obj.CurrCPWVariance.DoctorDR;
		InputStr=InputStr + "^" + VarResume;
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysVariance");
		var ret = objMRClinicalPathWays.Update(InputStr);
		if (ret<0){
			ExtTool.alert("提示","更新失败!");
		}
		obj.CurrCPWVariance = null;
		obj.SubPanel5_Init();
		obj.SubPanel6_Init();
	}
	
}