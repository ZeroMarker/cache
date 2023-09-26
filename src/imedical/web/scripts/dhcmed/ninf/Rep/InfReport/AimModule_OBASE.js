
function InitOBASE(obj)
{
	//显示基本信息
	obj.OBASE_txtRegNo = Common_TextField("OBASE_txtRegNo","登记号");
	obj.OBASE_txtPatName = Common_TextField("OBASE_txtPatName","姓名");
	obj.OBASE_txtPatSex = Common_TextField("OBASE_txtPatSex","性别");
	obj.OBASE_txtPatAge = Common_TextField("OBASE_txtPatAge","年龄");
	obj.OBASE_txtMrNo = Common_TextField("OBASE_txtMrNo","病历号");
	obj.OBASE_txtAdmLoc = Common_TextField("OBASE_txtAdmLoc","当前科室");
	obj.OBASE_txtAdmDate = Common_TextField("OBASE_txtAdmDate","入院日期");
	obj.OBASE_txtDisDate = Common_TextField("OBASE_txtDisDate","出院日期");
	obj.OBASE_txtAdmDays = Common_TextField("OBASE_txtAdmDays","住院天数");
	obj.OBASE_txtAdmBed = Common_TextField("OBASE_txtAdmBed","床号");
	obj.OBASE_txtRepDate = Common_TextField("OBASE_txtRepDate","填报日期");
	obj.OBASE_txtRepUser = Common_TextField("OBASE_txtRepUser","填报人");
	obj.OBASE_txtRepStatus = Common_TextField("OBASE_txtRepStatus","报告状态");
	obj.OBASE_txtRepLoc = Common_TextField("OBASE_txtRepLoc","填报科室");
	obj.OBASE_cboTransLoc = Common_ComboToTransLoc("OBASE_cboTransLoc","<font color='red';>*</font>调查科室",obj.CurrReport.EpisodeID,"E");
	obj.OBASE_txtEncryptLevel = Common_TextField("OBASE_txtEncryptLevel","病人密级");
	obj.OBASE_txtPatLevel = Common_TextField("OBASE_txtPatLevel","病人级别");
	
	Common_SetDisabled("OBASE_txtRegNo",true);
	Common_SetDisabled("OBASE_txtPatName",true);
	Common_SetDisabled("OBASE_txtPatSex",true);
	Common_SetDisabled("OBASE_txtPatAge",true);
	Common_SetDisabled("OBASE_txtMrNo",true);
	Common_SetDisabled("OBASE_txtAdmLoc",true);
	Common_SetDisabled("OBASE_txtAdmDate",true);
	Common_SetDisabled("OBASE_txtDisDate",true);
	Common_SetDisabled("OBASE_txtAdmDays",true);
	Common_SetDisabled("OBASE_txtAdmBed",true);
	Common_SetDisabled("OBASE_txtRepLoc",true);
	Common_SetDisabled("OBASE_txtRepDate",true);
	Common_SetDisabled("OBASE_txtRepUser",true);
	Common_SetDisabled("OBASE_txtRepStatus",true);
	Common_SetDisabled("OBASE_txtEncryptLevel",true);
	Common_SetDisabled("OBASE_txtPatLevel",true);
	
	//疾病转归
	obj.OBASE_cbgDiseasePrognosis = Common_RadioGroupToDic("OBASE_cbgDiseasePrognosis","疾病转归","NINFInfDiseasePrognosis",5);
	//与死亡关系
	obj.OBASE_cbgDeathRelation = Common_RadioGroupToDic("OBASE_cbgDeathRelation","与死亡关系","NINFInfDeathRelation",3);
	
	//界面布局
	obj.OBASE_ViewPort = {
		id : 'OBASEViewPort',
		//title : '基本信息',
		layout : 'border',
		//frame : true,
		height : 180,
		anchor : '-20',
		tbar : ['<img SRC="../scripts/dhcmed/img/PatInfo.png"><b style="font-size:16px;">病人基本信息</b>'],
		items : [
			{
				region: 'center',
				layout : 'form',
				frame : true,
				items : [
					{
						layout : 'column',
						items : [
							{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.OBASE_txtRegNo,obj.OBASE_txtAdmLoc,obj.OBASE_cboTransLoc]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.OBASE_txtPatName,obj.OBASE_txtAdmDate,obj.OBASE_txtRepLoc]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.OBASE_txtMrNo,obj.OBASE_txtDisDate,obj.OBASE_txtRepDate]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.OBASE_txtPatSex,obj.OBASE_txtAdmDays,obj.OBASE_txtRepUser]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.OBASE_txtPatAge,obj.OBASE_txtAdmBed,obj.OBASE_txtRepStatus]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.OBASE_txtEncryptLevel]
							},{
								columnWidth:.23,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.OBASE_txtPatLevel]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.60,
								boxMinWidth : 100,
								boxMaxWidth : 400,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.OBASE_cbgDiseasePrognosis]
							},{
								columnWidth:.40,
								boxMinWidth : 100,
								boxMaxWidth : 260,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [obj.OBASE_cbgDeathRelation]
							}
						]
					}
				]
			}
		]
	}
	
	//初始化界面
	obj.OBASE_InitView = function(){
		var objPaadm = obj.CurrPaadm;
		if (objPaadm) {
			var PatientID = objPaadm.PatientID;
			var objPatient = obj.CurrPatient;
			if (objPatient) {
				Common_SetValue('OBASE_txtRegNo',objPatient.PapmiNo);
				Common_SetValue('OBASE_txtPatName',objPatient.PatientName);
				Common_SetValue('OBASE_txtPatSex',objPatient.Sex);
				/*
				var Age = objPatient.Age;
				var Month = objPatient.AgeMonth;
				var Day = objPatient.AgeDay;
				if (!Age) Age=0;
				if (!Month) Month=0;
				if (!Day) Day=0;
				if (parseInt(Age) > 0) {
					Common_SetValue('OBASE_txtPatAge',parseInt(Age) + '岁');
				}else if(parseInt(Month) > 0){
					Common_SetValue('OBASE_txtPatAge',parseInt(Month) + '月'); //fix bug 8000 by pylian 2015-03-24 患者年龄显示为如0月45天
				}else{
					Common_SetValue('OBASE_txtPatAge', parseInt(Day) + '天');
				}*/
				//update by pylian 2015-07-17 年龄由接口来获取,解决已上报的报告打开时年龄变化的问题
				var Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",PatientID,"", obj.CurrPaadm.AdmitDate,obj.CurrPaadm.AdmitTime);
	            Common_SetValue('OBASE_txtPatAge',Age)
				//update by zf 2013-05-14
				var MrNo=obj.ClsCommonClsSrv.GetMrNoByAdm(obj.CurrReport.EpisodeID);
				if (MrNo){
					objPaadm.MrNo = MrNo;
					Common_SetValue('OBASE_txtMrNo',MrNo);
				} else {
					Common_SetValue('OBASE_txtMrNo',objPatient.InPatientMrNo);
				}
			}
			var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetPatEncryptLevel",PatientID,"");
			Common_SetValue('OBASE_txtEncryptLevel',SecretStr.split('^')[0]);
			Common_SetValue('OBASE_txtPatLevel',SecretStr.split('^')[1]);
			Common_SetValue('OBASE_txtAdmLoc',objPaadm.Department);
			Common_SetValue('OBASE_txtAdmDate',objPaadm.AdmitDate + ' ' + objPaadm.AdmitTime);
			Common_SetValue('OBASE_txtDisDate',objPaadm.DisDate + ' ' + objPaadm.DisTime);
			Common_SetValue('OBASE_txtAdmBed',objPaadm.Bed);
			Common_SetValue('OBASE_txtAdmDays',objPaadm.Days);
		}
		
		Common_SetValue('OBASE_txtRepLoc',(obj.CurrReport.ReportLoc !='' ? obj.CurrReport.ReportLoc.Descs : ''));
		Common_SetValue('OBASE_txtRepDate',obj.CurrReport.ReportDate);
		Common_SetValue('OBASE_txtRepUser',(obj.CurrReport.ReportUser !='' ? obj.CurrReport.ReportUser.Name : ''));
		Common_SetValue('OBASE_txtRepStatus',(obj.CurrReport.ReportStatus !='' ? obj.CurrReport.ReportStatus.Description : ''));
		
		Common_SetValue('OBASE_cbgDiseasePrognosis',(obj.CurrReport.ChildSumm.DiseasePrognosis !='' ? obj.CurrReport.ChildSumm.DiseasePrognosis.RowID : ''));
		Common_SetValue('OBASE_cbgDeathRelation',(obj.CurrReport.ChildSumm.DeathRelation !='' ? obj.CurrReport.ChildSumm.DeathRelation.RowID : ''));
		
		var isActive = false;
		var objSumm = obj.CurrReport.ChildSumm;
		if (objSumm) {
			if (objSumm.DiseasePrognosis) {
				isActive = (objSumm.DiseasePrognosis.Description.indexOf('死亡') > -1);
			}
		}
		Common_SetDisabled('OBASE_cbgDeathRelation',(!isActive));
		
		var objCmp = Ext.getCmp("OBASE_cbgDiseasePrognosis");
		if (objCmp) {
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					var cb = val[0];
					var objDic = obj.ClsSSDictionary.GetObjById(cb.inputValue);
					if (objDic) {
						isActive = (objDic.Description.indexOf('死亡') > -1);
					}
				}
				Common_SetDisabled('OBASE_cbgDeathRelation',(!isActive));
				Common_SetValue('OBASE_cbgDeathRelation','');
			});
		}
		
		//初始化调查科室
		obj.OBASE_cboTransLoc_Init();
	}
	
	//调查科室初始化
	obj.OBASE_cboTransLoc_Init = function(){
		var xTransID = '';
		var xTransLocDesc = '';
		
		var objTransLocStore = obj.OBASE_cboTransLoc.getStore();
		if (obj.CurrReport.ChildSumm.TransID != '') {
			for (var indRec = 0; indRec < objTransLocStore.getCount(); indRec++) {
				var objRec = objTransLocStore.getAt(indRec);
				if (objRec.get('TransID') == obj.CurrReport.ChildSumm.TransID) {
					var xTransID = objRec.get('TransID');
					var xTransLocDesc = objRec.get('TransLocDesc');
				}
			}
		} else {
			if (TransLoc !='') {
				for (var indRec = 0; indRec < objTransLocStore.getCount(); indRec++) {
					var objRec = objTransLocStore.getAt(indRec);
					if (objRec.get('TransLocID') == TransLoc) {
						var xTransID = objRec.get('TransID');
						var xTransLocDesc = objRec.get('TransLocDesc');
					}
				}
			}
		}
		
		obj.OBASE_cboTransLoc.setValue(xTransID);
		obj.OBASE_cboTransLoc.setRawValue(xTransLocDesc);
	}
	
	//数据存储
	obj.OBASE_SaveData = function(){
		var errinfo = '';
		
		//转科记录、调查科室
		var xTransID = '';
		var xTransLocID = '';
		var objTransLoc = Ext.getCmp('OBASE_cboTransLoc');
		if (objTransLoc) {
			xTransID = objTransLoc.getValue();
			var objTransLocStore = objTransLoc.getStore();
			var ind = objTransLocStore.find("TransID",xTransID);
			if (ind > -1) {
				var objRec = objTransLocStore.getAt(ind);
				xTransLocID = objRec.get('TransLocID');
			}
		}
		obj.CurrReport.ChildSumm.TransID = xTransID;
		obj.CurrReport.ChildSumm.TransLoc = obj.ClsBaseCtloc.GetObjById(xTransLocID);
		
		//获取ObjectID
		if (obj.CurrReport.ObjectID == '') {
			obj.CurrReport.ObjectID = obj.ClsInfReportSrv.GetObjectID(obj.CurrReport.EpisodeID,obj.CurrReport.ReportType.RowID,'');
		}
		
		//疾病转归
		var itmValue = Common_GetValue('OBASE_cbgDiseasePrognosis');
		obj.CurrReport.ChildSumm.DiseasePrognosis = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//与死亡关系
		var itmValue = Common_GetValue('OBASE_cbgDeathRelation');
		obj.CurrReport.ChildSumm.DeathRelation = obj.ClsSSDictionary.GetObjById(itmValue);
		
		//数据完整性校验
		if (obj.CurrReport.ObjectID == '') {
			//errinfo = errinfo + 'ObjectID 为空!<br>'
		}
		var objSumm = obj.CurrReport.ChildSumm;
		if (!objSumm.TransLoc) {
			errinfo = errinfo + '调查科室未填!<br>'
		}
		if (objSumm.DiseasePrognosis) {
			if ((objSumm.DiseasePrognosis.Description.indexOf('死亡') > -1)&&(!objSumm.DeathRelation)) {
				errinfo = errinfo + '与死亡关系未填!<br>'
			}
		}
		
		return errinfo;
	}
	
	return obj;
}