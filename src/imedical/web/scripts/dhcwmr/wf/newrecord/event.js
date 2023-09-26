function InitEvent(obj){
	obj.LoadEvents = function(){
		obj.gridAdmListByPat.on('rowclick',obj.gridAdmListByPat_rowclick,obj);
		obj.txtRegNo.on('specialkey',obj.txtRegNo_specialkey,obj);
		obj.btnReset.on('click',obj.btnReset_click,obj);
		obj.btnSave.on('click',obj.btnSave_click,obj);
		obj.btnCancel.on('click',obj.btnCancel_click,obj);
		obj.cboFirstLoc.on('select',obj.cboFirstLoc_select,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboMrType.on("select",obj.cboMrType_select,obj);
		obj.RadioGroupPatFrom.on('change',obj.RadioGroupPatFrom_change,obj);
		
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		Common_SetValue('txtFirstDate','');
		obj.RadioGroupEPPatFrom.setDisabled(true);
		//创建必填项回车到下一个必填项事件
		obj.CreatFieldEnterDownEvent("txtName","cboSex","txtBirthday","txtAge","txtPersonalID","cboNation","cboCountry","cboBirthProvince","cboBirthCity","txtRegAddr","txtForeignTel","cboFirstLoc","cboFirstDoc","txtFirstDate");
		
	}
	
	obj.CreatFieldEnterDownEvent = function()
	{
		AutoArray = arguments;
		for (var i =0;i<AutoArray.length-1;i++)
		{
			Ext.getCmp(AutoArray[i]).on('specialkey',function(field,e){
					if (e.getKey() != e.ENTER) return;
					for (var j =0 ;j <AutoArray.length;j++){
						if (AutoArray[j]==this.id){
							if (Common_GetText(AutoArray[j])!=='')
							{
								Ext.getCmp(AutoArray[j+1]).focus(true);
							}
						}
					}
			});
		}
	}

	obj.cboFirstLoc_select = function()
	{
		obj.cboFirstDoc.reset();
		obj.cboFirstDoc.getStore().load({});
	}
	
	obj.RadioGroupPatFrom_change = function()
	{
		var itemValue = Common_GetValue("RadioGroupPatFrom");
		var objPatFrom = ExtTool.RunServerMethod("DHCWMR.SS.Dictionary","GetObjById",itemValue);
			var PatFromDesc = objPatFrom.SDDesc;
			if (PatFromDesc=="急诊")
			{
				obj.RadioGroupEPPatFrom.setDisabled(false);	
			}else{
				obj.RadioGroupEPPatFrom.reset();
				obj.RadioGroupEPPatFrom.setDisabled(true);
			}
	}

	obj.cboHospital_select = function(combo,record,index){
		//加载病案类型
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
						obj.cboMrType_select();
					}
				}
			}
		});
	}
	
	obj.cboMrType_select = function(combo,record,index){
		obj.ResetCurrPage();
	}
	
	obj.ResetCurrPage = function(){
		obj.SetUpdateFlag(-1);
		obj.PatientID = '';
		obj.MrNo = '';
		obj.FirstAdm = '';
		
		Common_SetValue('txtRegNo','');
		Common_SetValue('txtMrNo','');
		Common_SetValue('txtSocialNo','');
		Common_SetValue('txtMedicalNo','');
		Common_SetValue('cboSocSat','','');
		Common_SetValue('txtName','');
		Common_SetValue('txtNameSpell','');
		Common_SetValue('cboCardType','','');
		Common_SetValue('txtPersonalID','');
		Common_SetValue('cboSex','','');
		Common_SetValue('cboMarital','','');
		Common_SetValue('txtBirthday','');
		Common_SetValue('txtAge','');
		Common_SetValue('cboOccupation','','');
		Common_SetValue('cboNation','','');
		Common_SetValue('cboCountry','','');
		Common_SetValue('cboBirthProvince','','');
		Common_SetValue('cboBirthCity','','');
		Common_SetValue('txtRegAddr','');
		Common_SetValue('txtRegZIP','');
		Common_SetValue('txtCompany','');
		Common_SetValue('txtCompanyZIP','');
		Common_SetValue('txtCompanyTel','');
		Common_SetValue('txtForeignId','');
		Common_SetValue('cboRelation','','');
		Common_SetValue('txtForeignAddr','');
		Common_SetValue('txtForeignTel','');
		Common_SetValue('txtMrStatus','');
		Common_SetValue('txtBuildFees','');
		Common_SetValue('txtBuildDate','');
		Common_SetValue('txtBuildUser','');
		Common_SetValue('cboFirstLoc','','');
		Common_SetValue('cboFirstDoc','','');
		Common_SetValue('txtFirstDate','');
		obj.RadioGroupPatFrom.reset();
		obj.RadioGroupEPPatFrom.reset();
		obj.RadioGroupPatAdmStatus.reset();
		Common_SetDisabled('txtMrStatus',true);
		Common_SetDisabled('txtBuildFees',true);
		Common_SetDisabled('txtBuildDate',true);
		Common_SetDisabled('txtBuildUser',true);
		Common_SetDisabled('txtMrNo',false);
		obj.gridAdmListByPat.getStore().removeAll();
	}
	
	obj.txtRegNo_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		
		var MrTypeID = Common_GetValue('cboMrType');
		if (!MrTypeID) {
			ExtTool.alert("错误提示",'病案类型为空!');
			return;
		}
		var RegNo = Common_GetValue('txtRegNo');
		if (!RegNo) {
			ExtTool.alert("错误提示",'登记号为空!');
			return;
		}
		obj.ResetCurrPage();
		obj.GetPatInfo(MrTypeID,RegNo,"");
		Ext.getCmp("txtName").focus(true);
	}
	
	obj.SetUpdateFlag = function(num){
		obj.UpdateFlag = num;
		if (obj.UpdateFlag < 0){
			Common_SetDisabled('btnSave',true);
			Common_SetDisabled('btnPrint',true);
		} else if (obj.UpdateFlag == 0){
			Common_SetDisabled('btnSave',false);
			Common_SetDisabled('btnPrint',true);
		} else if (obj.UpdateFlag > 0){
			Common_SetDisabled('btnSave',false);
			Common_SetDisabled('btnPrint',false);
		}
	}
	
	obj.SetMrNoVal = function(MrTypeID,MrNo){
		obj.MrNo = MrNo;
		Common_SetValue('txtMrNo',MrNo);
		var MRInfo = ExtTool.RunServerMethod("DHCWMR.SSService.NewRecordSrv","GetMRInfoByMrNo",MrTypeID,MrNo);
		if (MRInfo != ''){
			var arrMRInfo = MRInfo.split('^');
			if (arrMRInfo.length >= 9){
				Common_SetValue('txtMrStatus',arrMRInfo[4]);
				Common_SetValue('txtBuildFees',arrMRInfo[3]);
				Common_SetValue('txtBuildDate',arrMRInfo[1]);
				Common_SetValue('txtBuildUser',arrMRInfo[2]);
				if (arrMRInfo[6] != ''){
					var arr = arrMRInfo[6].split('&');
					if (arr.length>=2){
						obj.cboFirstLoc.setValue(arr[0]);
						obj.cboFirstLoc.setRawValue(arr[1]);
					}
				} else {
					Common_SetValue('cboFirstLoc','','');
				}
				if (arrMRInfo[7] != ''){
					var arr = arrMRInfo[7].split('&');
					if (arr.length>=2){
						obj.cboFirstDoc.setValue(arr[0]);
						obj.cboFirstDoc.setRawValue(arr[1]);
					}
				} else {
					Common_SetValue('cboFirstDoc','','');
				}
				Common_SetValue('txtFirstDate',arrMRInfo[8]);
				Common_SetValue('RadioGroupPatFrom',arrMRInfo[10]);
				Common_SetValue('RadioGroupEPPatFrom',arrMRInfo[11]);
				Common_SetValue('RadioGroupPatAdmStatus',arrMRInfo[12]);
				obj.FirstAdm = arrMRInfo[9];
				Common_SetDisabled('cboFirstLoc',true);
				Common_SetDisabled('cboFirstDoc',true);
				Common_SetDisabled('txtFirstDate',true);
				Common_SetDisabled('txtMrNo',true);
				obj.SetUpdateFlag(1);
			}
		} else {
			var NewRecordFee = ExtTool.RunServerMethod("DHCWMR.SSService.NewRecordSrv","GetNewRecordFee",MrTypeID,CTHospID);
			Common_SetValue('txtMrStatus','未建档');
			Common_SetValue('txtBuildFees',NewRecordFee);
			Common_SetValue('txtBuildDate','');
			Common_SetValue('txtBuildUser','');
			Common_SetValue('cboFirstLoc','','');
			Common_SetValue('cboFirstDoc','','');
			Common_SetValue('txtFirstDate','');
			obj.FirstAdm = '';
			Common_SetDisabled('cboFirstLoc',false);
			Common_SetDisabled('cboFirstDoc',false);
			Common_SetDisabled('txtFirstDate',false);
			Common_SetDisabled('txtMrNo',false);
			obj.SetUpdateFlag(0);
		}
	}
	
	obj.GetPatInfo = function(MrTypeID,RegNo,CardNo){
		var strPatInfo = ExtTool.RunServerMethod("DHCWMR.SSService.NewRecordSrv","GetPatInfo",RegNo,CardNo,MrTypeID);
		if (strPatInfo == '') {
			ExtTool.alert("错误", "无当前患者!");
			return;
		}
		
		//初始化病人信息
		var arrPatInfo = strPatInfo.split('^');
		var MrNo= arrPatInfo[27];
		if (arrPatInfo.length>=27){
			obj.PatientID = arrPatInfo[0];
			Common_SetValue('txtRegNo',arrPatInfo[1]);
			if (arrPatInfo[2] != ''){
				var arr = arrPatInfo[2].split('&');
				if (arr.length>=2){
					Common_SetValue('cboSocSat',arr[0],arr[1]);
				}
			}
			Common_SetValue('txtSocialNo',arrPatInfo[3]);
			Common_SetValue('txtMedicalNo',arrPatInfo[4]);
			Common_SetValue('txtName',arrPatInfo[5]);
			Common_SetValue('txtNameSpell',arrPatInfo[6]);
			if (arrPatInfo[7] != ''){
				var arr = arrPatInfo[7].split('&');
				if (arr.length>=2){
					Common_SetValue('cboCardType',arr[0],arr[1]);
				}
			}
			Common_SetValue('txtPersonalID',arrPatInfo[8]);
			if (arrPatInfo[9] != ''){
				var arr = arrPatInfo[9].split('&');
				if (arr.length>=2){
					Common_SetValue('cboSex',arr[0],arr[1]);
				}
			}
			if (arrPatInfo[10] != ''){
				var arr = arrPatInfo[10].split('&');
				if (arr.length>=2){
					Common_SetValue('cboMarital',arr[0],arr[1]);
				}
			}
			Common_SetValue('txtBirthday',arrPatInfo[11]);
			Common_SetValue('txtAge',arrPatInfo[12]);
			if (arrPatInfo[13] != ''){
				var arr = arrPatInfo[13].split('&');
				if (arr.length>=2){
					Common_SetValue('cboOccupation',arr[0],arr[1]);
				}
			}
			if (arrPatInfo[14] != ''){
				var arr = arrPatInfo[14].split('&');
				if (arr.length>=2){
					Common_SetValue('cboNation',arr[0],arr[1]);
				}
			}
			if (arrPatInfo[15] != ''){
				var arr = arrPatInfo[15].split('&');
				if (arr.length>=2){
					Common_SetValue('cboCountry',arr[0],arr[1]);
				}
			}
			if (arrPatInfo[16] != ''){
				var arr = arrPatInfo[16].split('&');
				if (arr.length>=2){
					obj.cboBirthProvince.setValue(arr[0]);
					obj.cboBirthProvince.setRawValue(arr[1]);
				}
			}
			if (arrPatInfo[17] != ''){
				var arr = arrPatInfo[17].split('&');
				if (arr.length>=2){
					obj.cboBirthCity.setValue(arr[0]);
					obj.cboBirthCity.setRawValue(arr[1]);
				}
			}

			Common_SetValue('txtRegAddr',arrPatInfo[18]);
			Common_SetValue('txtRegZIP',arrPatInfo[19]);
			Common_SetValue('txtCompany',arrPatInfo[20]);
			Common_SetValue('txtCompanyZIP',arrPatInfo[21]);
			Common_SetValue('txtCompanyTel',arrPatInfo[22]);
			Common_SetValue('txtForeignId',arrPatInfo[23]);
			if (arrPatInfo[24] != ''){
				var arr = arrPatInfo[24].split('&');
				if (arr.length>=2){
					Common_SetValue('cboRelation',arr[0],arr[1]);
				}
			}
			Common_SetValue('txtForeignAddr',arrPatInfo[25]);
			Common_SetValue('txtForeignTel',arrPatInfo[26]);
		}
		
		//初始化病案信息
		obj.SetMrNoVal(MrTypeID,MrNo);
		//初始化就诊列表
		obj.gridAdmListByPat.getStore().removeAll();
		obj.gridAdmListByPat.getStore().load({});
	}
	
	obj.gridAdmListByPat_rowclick = function() {
		var rd = obj.gridAdmListByPat.getSelectionModel().getSelected();
		if (rd){
			if (obj.FirstAdm == rd.get('EpisodeID')){
				obj.FirstAdm = '';
				Common_SetValue('cboFirstLoc','','');
				Common_SetValue('cboFirstDoc','','');
				Common_SetValue('txtFirstDate','');
				Common_SetDisabled('cboFirstLoc',false);
				Common_SetDisabled('cboFirstDoc',false);
				Common_SetDisabled('txtFirstDate',false);
			} else {
				obj.FirstAdm = rd.get('EpisodeID');
				Common_SetValue('cboFirstLoc','','');
				Common_SetValue('cboFirstDoc','','');
				obj.cboFirstLoc.setValue(rd.get('AdmLocID'));
				obj.cboFirstLoc.setRawValue(rd.get('AdmLocDesc'));
				obj.cboFirstDoc.setValue(rd.get('AdmDocID'));
				obj.cboFirstDoc.setRawValue(rd.get('AdmDocDesc'));
				Common_SetValue('txtFirstDate',rd.get('AdmDate'));
				Common_SetDisabled('cboFirstLoc',true);
				Common_SetDisabled('cboFirstDoc',true);
				Common_SetDisabled('txtFirstDate',true);
			}
		}
	}
	
	obj.btnReset_click = function() {
		obj.ResetCurrPage();
	}
	
	obj.btnSave_click = function() {
		if (obj.UpdateFlag < 0) return;
		if (obj.PatientID == '') return;
		var Error = "";
		var MrTypeID 		= Common_GetValue('cboMrType');
		var MrNo            = Common_GetValue('txtMrNo');  //修复bug167114,建档时报错
		var PatName 		= Common_GetValue('txtName');
		var NameSpell		= Common_GetValue('txtNameSpell');
		var Sex 			= Common_GetValue('cboSex');
		var SexDesc 		= Common_GetText('cboSex');
		var Birthday 		= Common_GetValue('txtBirthday');
		var Age 			= Common_GetValue('txtAge');
		var CardType		= Common_GetValue('cboCardType');
		var CardTypeDesc	= Common_GetText('cboCardType');
		var PersonalID 		= Common_GetValue('txtPersonalID');
		var Marital 		= Common_GetValue('cboMarital');
		var MaritalDesc		= Common_GetText('cboMarital');
		var Occupation		= Common_GetValue('cboOccupation');
		var OccupatioDesc	= Common_GetText('cboOccupation');
		var Nation 			= Common_GetValue('cboNation');
		var NationDesc 		= Common_GetText('cboNation');
		var Country			= Common_GetValue('cboCountry');
		var CountryDesc 	= Common_GetText('cboCountry');
		var BirthProvince 	= Common_GetText('cboBirthProvince');
		var BirthCity 		= Common_GetText('cboBirthCity');
		var RegAddr 		= Common_GetValue('txtRegAddr');	
		var RegZIP	 		= Common_GetValue('txtRegZIP');	
		var Company	 		= Common_GetValue('txtCompany');	
		var CompanyZIP	 	= Common_GetValue('txtCompanyZIP');	
		var CompanyTel	 	= Common_GetValue('txtCompanyTel');	
		var ForeignId	 	= Common_GetValue('txtForeignId');	
		var Relation	 	= Common_GetValue('cboRelation');
		var RelationDesc	= Common_GetText('cboRelation');	
		var ForeignAddr	 	= Common_GetValue('txtForeignAddr');	
		var ForeignTel	 	= Common_GetValue('txtForeignTel');
		var PatFrom 		= Common_GetValue('RadioGroupPatFrom');
		var EpPatFrom 		= Common_GetValue('RadioGroupEPPatFrom');
		var AdmStatus 		= Common_GetValue('RadioGroupPatAdmStatus');
		var FirstLocID 		= Common_GetValue('cboFirstLoc');
		var FirstLocDesc 	= Common_GetText('cboFirstLoc');
		var FirstDocID 		= Common_GetValue('cboFirstDoc');
		var FirstDocDesc 	= Common_GetText('cboFirstDoc');
		var FirstDate 		= Common_GetValue('txtFirstDate');
		
		if (!MrTypeID) Error = Error+'病案类型、';
		//if (!MrNo) Error = Error+'病案号、';
		if (!PatName) Error = Error+'姓名、';
		if (!Sex) Error = Error+'性别、';
		if (!Birthday) Error = Error+'出生日期、';
		if (!Age) Error = Error+'年龄、';
		if (!PersonalID) Error = Error+'证件号码、';
		if (!NationDesc) Error = Error+'民族、';  //修复更改信息时提示民族国籍不存在问题
		if (!CountryDesc) Error = Error+'国籍、';
		if (!BirthProvince) Error = Error+'出生省市、';
		if (!BirthCity) Error = Error+'出生县、';
		if (!RegAddr) Error = Error+'户口地址、';
		if (!AdmStatus) Error = Error+'就诊状态、';
		if (!FirstLocID) Error = Error+'初诊科室、';
		if (!FirstDocID) Error = Error+'初诊医师、';
		if (!FirstDate) Error = Error+'初诊日期、';
		if (!ForeignTel) Error = Error+'联系人电话、';
		if (!PatFrom){
			Error = Error+'门急诊类型、';
		}else{
			var objPatFrom = ExtTool.RunServerMethod("DHCWMR.SS.Dictionary","GetObjById",PatFrom);
			var PatFromDesc = objPatFrom.SDDesc;
			if ((!EpPatFrom)&&(PatFromDesc=="急诊"))
			{
				Error = Error+'急诊类型、';
			}
		}
		if (Error)
		{
			ExtTool.alert("提示",Error+'为空！');
			return;
		}
		var FirstHospID = '';    				  //暂时、院区根据初诊科室处理
		var FirstAdm = obj.FirstAdm;
		
		var FirstInfo = FirstHospID;              //初诊院区
		FirstInfo += '^' + FirstLocID;            //初诊科室
		FirstInfo += '^' + FirstDocID;            //初诊医师
		FirstInfo += '^' + FirstDate;             //初诊日期
		FirstInfo += '^' + FirstAdm;              //初诊就诊
		FirstInfo += '^' + PatFrom;               //病人来源
		FirstInfo += '^' + EpPatFrom;             //急诊来源
		FirstInfo += '^' + AdmStatus;             //就诊状态

		var PayModeID=1;
		var FeeInfo = PayModeID;                  //支付方式，默认现金
		FeeInfo += '^' + session['LOGON.USERID']; //用户
		FeeInfo += '^' + session['LOGON.CTLOCID'];//科室
		FeeInfo += '^' + session['LOGON.GROUPID'];//安全组
		
		var PatInfo=PatName	
			PatInfo += '^' + NameSpell		
			PatInfo += '^' + SexDesc 		
			PatInfo += '^' + Birthday 		
			PatInfo += '^' + Age 		
			PatInfo += '^' + CardTypeDesc	
			PatInfo += '^' + PersonalID 		
			PatInfo += '^' + MaritalDesc		
			PatInfo += '^' + OccupatioDesc	
			PatInfo += '^' + NationDesc 		
			PatInfo += '^' + CountryDesc 	
			PatInfo += '^' + BirthProvince
			PatInfo += '^' + BirthCity		
			PatInfo += '^' + RegAddr 		
			PatInfo += '^' + RegZIP	 	
			PatInfo += '^' + Company	 	
			PatInfo += '^' + CompanyZIP	 	
			PatInfo += '^' + CompanyTel	 	
			PatInfo += '^' + ForeignId	 	
			PatInfo += '^' + RelationDesc	
			PatInfo += '^' + ForeignAddr	 	
			PatInfo += '^' + ForeignTel	 	
		//新建病历
		if (obj.UpdateFlag == 0) {
			//add by mxp 2016-05-04 收费前检查用户是否有可用发票
			var flg = ExtTool.RunServerMethod("DHCWMR.MFService.FeeRecordSrv","CheckInsertMedical","JD",FeeInfo);
			if (parseInt(flg)<=0) {
				ExtTool.alert("提示",flg.split('^')[1]);
				return;
			}
			var PatientID = obj.PatientID;
			var ret = IGroupReceiptByPat(PatientID,MrClass,MrNo,session['LOGON.CTLOCID'],session['LOGON.USERID'],FirstInfo,FeeInfo,PatInfo);
			var err = ret.split('^')[0];
			if ((err*1)<=0){
				if ((err*1)<0)
				{
					ExtTool.alert("错误提示",ret);
					return;
				}else{
					return;
				}
			}else{
				var VolID = ret.split('^')[2];
				var MrNo = ret.split('^')[3];
				//建档后出库信息
				var MRecord = '' + '^' + VolID;
				var Detail = FirstLocID;               //借阅科室
				Detail += '^' + FirstLocDesc;          //借阅科室名称
				Detail += '^' + '';                    //借阅科室电话
				Detail += '^' + FirstDocID;            //借阅人
				Detail += '^' + FirstDocDesc;          //借阅人姓名
				Detail += '^' + '';                    //借阅人电话
				Detail += '^' + '';                    //借阅目的
				Detail += '^' + '';                    //预计归还日期
				Detail += '^' + '';                    //备注
				Detail += '^' + obj.FirstAdm;          //就诊号
				var ret = ExtTool.RunServerMethod("DHCWMR.MOService.LendRecordSrv","LendOperation",'L',session['LOGON.USERID'],'',MRecord,'',Detail,'N');		//建档出库
				var err = ret.split('^')[0];
				
				if ((err*1)<0){
					ExtTool.alert("错误提示",ret);
					return;
				} else {
					obj.SetMrNoVal(MrTypeID,MrNo);
					ExtTool.alert("提示",'建档成功');
					//obj.PrintOPFrontPage(MrTypeID,MrNo,1,"");
				}
			}
		} else {
			//更新病案建档信息、病人信息
			var MrNo = obj.MrNo;
			var ret = ExtTool.RunServerMethod("DHCWMR.SSService.NewRecordSrv","UpdateFirstInfo",MrTypeID,MrNo,FirstInfo,PatInfo);
			var err = ret.split('^')[0];
			if ((err*1)<0){
				ExtTool.alert("错误提示",ret);
				return;
			} else {
				obj.SetMrNoVal(MrTypeID,MrNo);
				ExtTool.alert("提示",'保存成功');
			}
		}
		Common_SetDisabled('txtMrNo',true);
	}
	
	obj.btnCancel_click = function(){
		var FirstLocID = Common_GetValue('cboFirstLoc');
		var LogonUserID = session['LOGON.USERID'];
		if (obj.PatientID=="") return
		var ret = IGroupUnReceiptByPat(obj.PatientID,"O",FirstLocID,LogonUserID)
		var err = ret.split('^')[0];
		if ((err*1)<0){
			ExtTool.alert("错误提示",ret);
			return;
		}else{
			obj.ResetCurrPage();
			ExtTool.alert("提示",'取消成功！');
			Common_SetDisabled('txtMrNo',false);
		}
	}
	
	
	obj.PrintOPFrontPage= function(MrTypeID,MrNo,Type,VPVoulmeID){
		var objPrint = ExtTool.StaticServerObject("DHCWMR.SSService.NewRecordSrv");
		var objTmp = ExtTool.StaticServerObject("DHCMed.Service");
		var TemplatePath = objTmp.GetTemplatePath();
		var FileName=TemplatePath+"\\\\"+"DHCWMR_OMR_FrontPage.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			alert("创建Excel应用对象失败!");
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);	
		var flg=objPrint.PrintOPFrontPage("fillxlSheet",MrTypeID,MrNo,Type,VPVoulmeID);
		if (flg==1)
		{
			xlSheet.printout();
			xlSheet=null;
			xlBook.Close (savechanges=false);
			xls.Quit();
			xlSheet=null;
			xlBook=null;
			xls=null;
			idTmr=window.setInterval("Cleanup();",1);
			return true;
		}else{
			alert("打印信息错误!");
			return false;
		}
	}
}
