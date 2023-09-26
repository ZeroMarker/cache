var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.CurrRepData = new Object();
	obj.cbgSymptoms = new Array();
	obj.ReportID 	= ReportID;
	obj.DiseaseID 	= DiseaseID;
	obj.RepTypeID 	= RepTypeID;
	obj.RepTypeCode = RepTypeCode;
	obj.RepTypeDesc = RepTypeDesc;
	obj.RepStatus 	= RepStatus;
	obj.EpisodeID 	= EpisodeID;
	obj.PatientID 	= PatientID;
	
	if (obj.RepTypeCode == '1') {  //重性精神疾病发病报告卡
		if (typeof InitSmdReport == 'function') obj = InitSmiReport(obj);
	} else if (obj.RepTypeCode == '2') {  //重性精神疾病出院信息单
		if (typeof InitSmdDischage == 'function') obj = InitSmiDischage(obj);
	} else if (obj.RepTypeCode == '3') {  //严重精神障碍患者发病报告卡
		if (typeof InitSmdReport == 'function') obj = InitSmdReport(obj);
	} else if (obj.RepTypeCode == '4') {  //严重精神障碍患者出院信息单
		if (typeof InitSmdDischage == 'function') obj = InitSmdDischage(obj);
	} else {
		ExtTool.alert("提示","报告类型错误,请检查程序配置!");
		return;
	}
	
	var clientHeight = document.body.clientHeight;
	var clientWidth = document.body.clientWidth;
	var htmlMainPanel = ''
		//+ '<div style="overflow-y:auto;width:' + clientWidth + 'px;height:' + clientHeight + 'px">'
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0 style="border:1px solid #84C1FF;border-collapse:collapse;">'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>' + obj.RepTypeDesc + '</span>'
		+ '		</div></td></tr>'
		
		+ obj.HtmlSubPanel  //加载不同类型报告页面布局
		
		/* + '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '             <td width="50%"> </td>'
		+ '				<td><div id="td_btnRepTmp" style="width:80px;height:30px;overflow:hidden;"></div></td>'
		+ '				<td><div id="td_btnSubmit" style="width:80px;height:30px;overflow:hidden;"></div></td>'
		+ '				<td><div id="td_btnDelete" style="width:80px;height:30px;overflow:hidden;"></div></td>'
		+ '				<td><div id="td_btnCheck" style="width:80px;height:30px;overflow:hidden;"></div></td>'
		+ '				<td><div id="td_btnCancelCheck" style="width:80px;height:30px;overflow:hidden;"></div></td>'
		+ '				<td><div id="td_btnReturn" style="width:80px;height:30px;overflow:hidden;"></div></td>'
		+ '				<td><div id="td_btnPrint" style="width:80px;height:30px;overflow:hidden;"></div></td>'
		+ '				<td><div id="td_btnClose" style="width:80px;height:30px;overflow:hidden;"></div></td>'
		+ '             <td width="50%"> </td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>' */
		
		//+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		+ '</tr></table>'
		//+ '</div>'
		
	//页面元素
	obj.txtCardNo 	    = Common_TextField("txtCardNo","卡片编号");
	obj.cbgPatType 	    = Common_ComboToDic("cbgPatType","患者类型","SMDPatType");
	obj.cbgAdmitReason  = Common_ComboToDic("cbgAdmitReason","本次入院原因","SMDAdmitReason");
	obj.txtAdmitDate 	= Common_DateFieldToDate("txtAdmitDate","入院日期");
	obj.txtDischDate 	= Common_DateFieldToDate("txtDischDate","出院日期");
	obj.cbgIsComplete 	= Common_ComboToDic("cbgIsComplete","完整性","SMDIsComplete");
	obj.cbgAdmType 	    = Common_ComboToDic("cbgAdmType","报卡类型","SMDAdmType");
	
	obj.txtPatName 	    = Common_TextField("txtPatName","患者姓名");
	obj.txtOPMrNo		= Common_TextField("txtOPMrNo","门诊病案号");
	obj.txtIPMrNo		= Common_TextField("txtIPMrNo","住院病案号");
	obj.txtSex 		    = Common_TextField("txtSex","性别");
	obj.txtPersonalID   = Common_TextField("txtPersonalID","身份证号");
	obj.txtBirthday 	= Common_DateFieldToDate("txtBirthday","出生日期");
	//obj.txtNation		= Common_TextField("txtNation","民族");
	obj.txtNation		= Common_ComboToDic("txtNation","民族","Nation");	////修改“民族”为下拉选择框
	obj.txtContactor 	= Common_TextField("txtContactor","联系人姓名");
	obj.txtContactorTel	= Common_TextField("txtContactorTel","联系人电话");
	obj.txtHomeTel    	= Common_TextField("txtHomeTel","家庭电话");
	obj.txtCompany      = Common_TextField("txtCompany","工作单位");
	obj.txtCompanyTel	= Common_TextField("txtCompanyTel","工作单位联系电话");
	
	obj.cbgLocal 	    = Common_ComboToDic("cbgLocal","人员属地","SMDLocal");
	obj.cboRegProvince 	= Common_ComboToArea("cboRegProvince","户籍地省","1");
	obj.cboRegCity 		= Common_ComboToArea("cboRegCity","市","cboRegProvince","N");
	obj.cboRegCounty 	= Common_ComboToArea("cboRegCounty","区","cboRegCity","N");
	obj.cboRegVillage 	= Common_ComboToArea("cboRegVillage","乡镇(街道)","cboRegCounty","N");
	obj.txtRegRoad 		= Common_TextField("txtRegRoad","村(居委会)");
	obj.cboRegAddType   = Common_ComboToDic("cboRegAddType","户籍地址类型","SMDAddrType");
	obj.cboCurrProvince = Common_ComboToArea("cboCurrProvince","现住址省","1");
	obj.cboCurrCity 	= Common_ComboToArea("cboCurrCity","市","cboCurrProvince","N");
	obj.cboCurrCounty 	= Common_ComboToArea("cboCurrCounty","区","cboCurrCity","N");
	obj.cboCurrVillage 	= Common_ComboToArea("cboCurrVillage","乡镇(街道)","cboCurrCounty","N");
	obj.txtCurrRoad 	= Common_TextField("txtCurrRoad","村(居委会)");
	obj.cboCurrAddType  = Common_ComboToDic("cboCurrAddType","现住址地址类型","SMDAddrType");
	
	obj.cboOccupation   = Common_ComboToDic("cboOccupation","职业类别","SMDOccupation");
	obj.txtSickDate     = Common_DateFieldToDate("txtSickDate","初次发病日期");
	obj.cbgReferral     = Common_CheckboxGroupToDic("cbgReferral","送诊主体","SMDReferral",5)
	obj.txtReferralTxt  = Common_TextField("txtReferralTxt","送诊主体备注");
	obj.txtDiagHospital = Common_TextField("txtDiagHospital","确诊医院");
	obj.txtDiagDate     = Common_DateFieldToDate("txtDiagDate","确诊日期");
	obj.txtDiseaseICD   = Common_TextField("txtDiseaseICD","ICD10编码");
	obj.txtResume 	    = Common_TextArea("txtResume","备注",50);
	
	obj.txtRepLoc       = Common_TextField("txtRepLoc","报告科室");
	obj.txtRepLocTel    = Common_TextField("txtRepLocTel","科室联系电话");
	obj.txtRepUser      = Common_TextField("txtRepUser","填卡医师");
	obj.txtRepDate 	    = Common_DateFieldToDate("txtRepDate","填卡日期");
	obj.txtCheckUser    = Common_TextField("txtCheckUser","录入人");
	obj.txtCheckDate    = Common_DateFieldToDate("txtCheckDate","录入日期");
	obj.cboPayment	    = Common_ComboToDic("cboPayment","医疗付费方式","SMDPaidType");
	obj.txtInsurNo		= Common_TextField("txtInsurNo","医保号");
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboDiseaseStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboDiseaseStore = new Ext.data.Store({
		proxy: obj.cboDiseaseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'IDCode', mapping: 'IDCode'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
			,{name: 'ICD10', mapping: 'ICD10'}
			,{name: 'CateID', mapping: 'CateID'}
			,{name: 'CateDesc', mapping: 'CateDesc'}
			,{name: 'ProID', mapping: 'ProID'}
			,{name: 'ProName', mapping: 'ProName'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.cboDisease = new Ext.form.ComboBox({
		id : 'cboDisease'
		,minChars : 1
		,store : obj.cboDiseaseStore
		,valueField : 'ID'
		,fieldLabel : '疾病名称'
		,displayField : 'IDDesc'
		,triggerAction : 'all'
		,width : 120
		,listWidth : 300
	});
	obj.cboDisease.on("select",function(){
		var objCmp = Ext.getCmp("txtDiseaseICD");
		if(objCmp){
			var DiseaseID = Common_GetValue("cboDisease");
			var objDisease = ExtTool.RunServerMethod("DHCMed.SS.Disease","GetObjById",DiseaseID);
			objCmp.setValue(objDisease.IDICD10);
		}
	});
	obj.cboDiseaseStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SSService.DiseaseSrv';
		param.QueryName = 'QryDisease';
		param.Arg1 = 'SMD';
		param.Arg2 = 1;
		param.Arg3 = "";
		param.Arg4 = obj.cboDisease.getRawValue();
		param.ArgCnt = 4;
	});
	
    obj.btnRepTmp=new Ext.Button({
        id:'btnRepTmp'
        ,text:'草稿'
        ,iconCls:'icon-temp'
    });
	
    obj.btnSubmit=new Ext.Button({
        id:'btnSubmit'
        ,text:'提交'
        ,iconCls:'icon-save'
    });
	
    obj.btnDelete=new Ext.Button({
        id:'btnDelete'
        ,text:'删除'
        ,iconCls:'icon-delete'
    });
    
    obj.btnCheck=new Ext.Button({
        id:'btnCheck'
        ,text:'审核'
        ,iconCls:'icon-check'
    });
	
	obj.btnCancelCheck=new Ext.Button({
        id:'btnCancelCheck'
        ,text:'取消审核'
        ,iconCls:'icon-undo'
    });
	
    obj.btnReturn=new Ext.Button({
        id:'btnReturn'
        ,text:'退回'
        ,iconCls:'icon-cancel'
    });
    
    obj.btnPrint=new Ext.Button({
        id:'btnPrint'
        ,text:'打印'
        ,iconCls:'icon-print'
    });
    
    obj.btnClose=new Ext.Button({
        id:'btnClose'
        ,text:'关闭'
        ,iconCls:'icon-close'
    });
    
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,autoScroll : true
		,renderTo : Ext.getBody()
		,frame : true
		//,layout : 'form'
		,html : htmlMainPanel
		,buttonAlign:'center'
		,buttons : [
			obj.btnRepTmp,
			obj.btnSubmit,
			obj.btnDelete,
			obj.btnCheck,
			obj.btnCancelCheck,
			obj.btnReturn,
			obj.btnPrint,
			obj.btnClose
		]
	});
	
    obj.MainViewPort=new Ext.Viewport({
        id:'MainViewPortId'
		,layout : 'fit'
		,items : [
			obj.MainPanel
		]
    });
	
	Ext.ComponentMgr.all.each(function(cmp){
		var objTD = document.getElementById('td_' + cmp.id);
		if (objTD) {
			cmp.setWidth(objTD.offsetWidth);
			cmp.render('td_' + cmp.id);
		}
	});
	
    InitviewScreenEvent(obj);
    obj.LoadEvent();
}