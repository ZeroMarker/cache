function InitViewport1Event(obj){
	obj.LoadEvent = function(){
		obj.btnAloneSave.on("click",obj.btnAloneSave_click,obj);
		obj.btnBatchSave.on("click",obj.btnBatchSave_click,obj);
		obj.btnBatchPrintBar.on("click",obj.btnBatchPrintBar_click,obj);
		obj.btnUpdoOpera.on("click",obj.btnUpdoOpera_click,obj);
		obj.btnClean.on("click",obj.btnClean_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnUpdoQuery.on("click",obj.btnUpdoQuery_click,obj);
		obj.txtMrNo.on("specialKey",obj.txtMrNo_specialKey,obj);
		obj.txtUpdoMrNo.on("specialKey",obj.txtUpdoMrNo_specialKey,obj);
		obj.GridWorkList.on('rowclick',obj.GridWorkList_rowclick,obj);
		obj.chkUpdoFlag.on('check',obj.chkUpdoFlag_check,obj);
		
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboMrType.on("select",obj.cboMrType_select,obj);
		obj.cboWFItem.on("select",obj.cboWFItem_select,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		obj.chkUpdoFlag_check();
		
		//页面加载时,输入框获取焦点
		Ext.getCmp("txtMrNo").focus(false, 100);
		
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.GridWorkList.getColumnModel();
			var cfg = null;
			for(var i=0;i<cm.config.length;++i)
			{
				cfg = cm.config[i];
				if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
				}
			}
		}
	}
	
	//通过权限获取工作项目
	obj.GetOperaList = function(){
		var OperaList = "";
		if (tDHCWMRMenuOper){
			for(var code in tDHCWMRMenuOper) {
				var hasPower = tDHCWMRMenuOper[code];
				if(hasPower == 0)
					continue;
				if(OperaList != "")
					OperaList += "#";
				OperaList += code;
			}
		}
		return OperaList;
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
		//加载操作项目列表
		obj.cboWFItem.getStore().removeAll();
		obj.cboWFItem.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboWFItem.setValue(r[0].get("WFItemID"));
						obj.cboWFItem.setRawValue(r[0].get("WFItemDesc"));
						obj.cboWFItem_select();
					}
				}
			}
		});
	}
	
	obj.cboWFItem_select = function(){
		var WFItemID = obj.cboWFItem.getValue();
		var objStore = obj.cboWFItem.getStore();
		var row = objStore.find('WFItemID',WFItemID);
		if (row > -1){
			var record = objStore.getAt(row);
			obj.GetWFIConfig(record);
		} else {
			obj.GetWFIConfig('');
		}
		if (!obj.chkUpdoFlag.getValue())
		{
			if (obj.WFIConfig.BatchOper == '1'){
				Common_SetDisabled('btnBatchSave',false);
			} else {
				Common_SetDisabled('btnBatchSave',true);
			}
			
			if (obj.WFIConfig.SubFlow == 'O'){
				if (obj.WFIConfig.SysOpera == 'RC'){
					Common_SetValue('chkMBarCode',(obj.DefaultPrintMrBarcode == '1'));
					Common_SetValue('chkVBarCode',(obj.DefaultPrintVolBarcode == '1'));
				} else {
					Common_SetValue('chkMBarCode',false);
					Common_SetValue('chkVBarCode',false);
				}
			} else {
				Common_SetValue('chkMBarCode',false);
				Common_SetValue('chkVBarCode',false);
			}
		}

		Common_LoadCurrPage("GridWorkList",1);
	}
	
	obj.GetWFIConfig = function(record){
		if (record){
			obj.WFIConfig.WFItemID = record.get('WFItemID');
			obj.WFIConfig.WFItemDesc = record.get('WFItemDesc');
			obj.WFIConfig.ItemID = record.get('ItemID');
			obj.WFIConfig.ItemType = record.get('ItemType');
			obj.WFIConfig.SubFlow = record.get('SubFlow');
			obj.WFIConfig.PostStep = record.get('PostStep');
			obj.WFIConfig.SysOpera = record.get('SysOpera');
			obj.WFIConfig.CheckUser = record.get('CheckUser');
			obj.WFIConfig.BeRequest = record.get('BeRequest');
			obj.WFIConfig.BatchOper = record.get('BatchOper');
		} else {
			obj.WFIConfig.WFItemID = '';
			obj.WFIConfig.WFItemDesc = '';
			obj.WFIConfig.ItemID = '';
			obj.WFIConfig.ItemType = '';
			obj.WFIConfig.SubFlow = '';
			obj.WFIConfig.PostStep = '';
			obj.WFIConfig.SysOpera = '';
			obj.WFIConfig.CheckUser = '';
			obj.WFIConfig.BeRequest = '';
			obj.WFIConfig.BatchOper = '';
		}
	}
	
	obj.chkUpdoFlag_check = function(){
		Common_SetValue("txtMrNo",'');  //清空病案号
		Common_SetValue("txtUpdoMrNo",'');  //清空病案号
		
		var updoFlag = obj.chkUpdoFlag.getValue();
		if (updoFlag){
			Common_SetDisabled('btnAloneSave',true);
			Common_SetDisabled('btnBatchSave',true);
			Common_SetDisabled('btnDelete',true);
			Common_SetDisabled('btnClean',true);
			Common_SetDisabled('chkMBarCode',true);
			Common_SetDisabled('chkVBarCode',true);
			Common_SetDisabled('txtMrNo',true);
			
			Common_SetDisabled('btnUpdoQuery',false);
			Common_SetDisabled('btnUpdoOpera',false);
			Common_SetDisabled('txtUpdoMrNo',false);
			Ext.getCmp("txtUpdoMrNo").focus(false, 100);
		} else {
			Common_SetDisabled('btnAloneSave',false);
			if (obj.WFIConfig.BatchOper == '1'){
				Common_SetDisabled('btnBatchSave',false);
			} else {
				Common_SetDisabled('btnBatchSave',true);
			}
			Common_SetDisabled('btnDelete',false);
			Common_SetDisabled('btnClean',false);
			Common_SetDisabled('chkMBarCode',false);
			Common_SetDisabled('chkVBarCode',false);
			Common_SetDisabled('txtMrNo',false);
			Ext.getCmp("txtMrNo").focus(false, 100);
			
			Common_SetDisabled('btnUpdoQuery',true);
			Common_SetDisabled('btnUpdoOpera',true);
			Common_SetDisabled('txtUpdoMrNo',true);
		}
		Common_LoadCurrPage("GridWorkList",1);
	}
	
	obj.GridWorkList_rowclick = function(grid,rowIndex,e){
		grid.getView().getRow(rowIndex).className = "x-grid3-row    x-grid3-row-first ";
		var objStore = grid.getStore();
		var updoFlag = obj.chkUpdoFlag.getValue();
		if (updoFlag){
			var record = objStore.getAt(rowIndex);
			if (record.get('IsChecked') != '1'){
				record.set('IsChecked', '1');
			} else {
				record.set('IsChecked', '0');
			}
		} else {
			if (obj.WFIConfig.ItemType == 'O'){  //顺序操作,按卷操作（单卷）
				for (var row = 0; row < objStore.getCount(); row++){
					var record = objStore.getAt(row);
					if ((row == rowIndex)&&(record.get('ProblemCode') == 1)){
						record.set('IsChecked', '1');
					} else {
						record.set('IsChecked', '0');
					}
				}
			} else {  //突发操作,按病案操作（整本）
				var MainID = objStore.getAt(rowIndex).get('MainID');
				for (var row = 0; row < objStore.getCount(); row++){
					var record = objStore.getAt(row);
					if ((record.get('MainID') == MainID)&&(record.get('ProblemCode') == 1)){
						record.set('IsChecked', '1');
					} else {
						record.set('IsChecked', '0');
					}
				}
			}
		}
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
	
	obj.btnUpdoQuery_click = function(){
		var MrTypeID = Common_GetValue("cboMrType");
		var WFItemID = obj.WFIConfig.WFItemID;
		if (!MrTypeID) {
			ExtTool.alert("提示", "请选择病案类型!");
			return;
		}
		if (!WFItemID) {
			ExtTool.alert("提示", "请选择操作项目!");
			return;
		}
		Common_SetValue("txtUpdoMrNo",'');  //清空病案号
		Common_LoadCurrPage("GridWorkList",1);
	}
	
	obj.txtUpdoMrNo_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var updoFlag = obj.chkUpdoFlag.getValue();
		if (!updoFlag) return;
		
		var errinfo = '';
		var MrTypeID = Common_GetValue('cboMrType');
		if (!MrTypeID) {
			errinfo = errinfo + "请选择病案类型!<br>";
		}
		if (!obj.WFIConfig.ItemID) {
			errinfo = errinfo + "请选择操作项目!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		Common_LoadCurrPage("GridWorkList",1);
	}
	
	obj.txtMrNo_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var updoFlag = obj.chkUpdoFlag.getValue();
		if (updoFlag) return;
		
		var errinfo = '';
		var MrTypeID = Common_GetValue('cboMrType');
		var MrNo = Common_GetValue('txtMrNo');
		
		if (!MrTypeID) {
			errinfo = errinfo + "请选择病案类型!<br>";
		}
		if (!obj.WFIConfig.ItemID) {
			errinfo = errinfo + "请选择操作项目!<br>";
		}
		if (!MrNo){
			errinfo = errinfo + "请输入病案号!<br>";
		}
		
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		//病案卷查询
		var win = new VS_InitVolumeSelect();
		var flg = win.VS_VolumeQuery(MrTypeID,obj.WFIConfig,MrNo);
		if (flg){
			win.VS_WinVolumeSelect.show();
			return;
		}
		
		Common_SetValue("txtMrNo",'');  //清空病案号
		Ext.getCmp("txtMrNo").focus(false, 100);
	}
	
	//点击确认按钮要做的操作
	obj.btnSaveOperaType = 0;
	obj.btnAloneSave_click = function(){
		var MrTypeID = Common_GetValue("cboMrType");
		var WFItemID = obj.WFIConfig.WFItemID;
		if (!MrTypeID) {
			ExtTool.alert("提示", "请选择病案类型!");
			return;
		}
		if (!WFItemID) {
			ExtTool.alert("提示", "请选择操作项目!");
			return;
		}
		
		var RecordIDs = '';
		var objStore = obj.GridWorkList.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				RecordIDs += ',' + record.get('RecordID');
			}
		}
		if (RecordIDs != '') RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
		
		if (RecordIDs == ''){
			ExtTool.alert('提示', '请选择当前操作病案卷!');
			return false;
		}
		
		obj.btnSaveOperaType = 0;
		obj.WorkFlowOperaByStep(1);
	}
	
	obj.btnBatchSave_click = function(){
		var MrTypeID = Common_GetValue("cboMrType");
		var WFItemID = obj.WFIConfig.WFItemID;
		if (!MrTypeID) {
			ExtTool.alert("提示", "请选择病案类型!");
			return;
		}
		if (!WFItemID) {
			ExtTool.alert("提示", "请选择操作项目!");
			return;
		}
		
		obj.btnSaveOperaType = 1;
		obj.WorkFlowOperaByStep(1);
	}
	
	obj.WorkFlowOperaByStep = function(step){
		if (step < 2){
			//值存入obj.ExtraItemInput中
			if ((obj.WFIConfig.SubFlow == 'Q')&&((obj.WFIConfig.SysOpera == '')||(obj.WFIConfig.SysOpera == 'H'))){
				var win = new EI_InitExtraItem('Q','H');  //质控发生登记/申请
				win.EI_WinExtraItem.show();
				return;
			}
			if (obj.WFIConfig.SubFlow == 'L'){
				if ((obj.WFIConfig.SysOpera == '')||(obj.WFIConfig.SysOpera == 'H')){
					var win = new EI_InitExtraItem('L','H');  //借阅发生登记/申请
					win.EI_WinExtraItem.show();
					return;
				} else {
					//诊室确认
				}
			}
			if ((obj.WFIConfig.SubFlow == 'C')&&((obj.WFIConfig.SysOpera == '')||(obj.WFIConfig.SysOpera == 'H'))){
				var win = new EI_InitExtraItem('C','H');  //复印发生登记/申请
				win.EI_WinExtraItem.show();
				return;
			}
			if ((obj.WFIConfig.SubFlow == 'S')&&((obj.WFIConfig.SysOpera == '')||(obj.WFIConfig.SysOpera == 'H'))){
				var win = new EI_InitExtraItem('S','H');  //封存发生登记/申请
				win.EI_WinExtraItem.show();
				return;
			}
		}
		
		if (step < 3){
			//值存入obj.CheckUserInput中
			if (obj.WFIConfig.CheckUser == '1'){
				var win = new CU_InitCheckUser();
				win.CU_WinCheckUser.show();
				return;
			}
		}
		
		var MrTypeID = Common_GetValue("cboMrType");
		if (MrTypeID == '') return;
		var WFItemID = obj.WFIConfig.WFItemID;
		if (WFItemID == '') return;
		var ExtraItemInput = obj.ExtraItemInput;
		var CheckUserInput = obj.CheckUserInput;
		if (step == 1){
			ExtraItemInput=""; //add by jiangpengpeng 2015-08-19
		}
		if (obj.btnSaveOperaType == 1){
			var ret = ExtTool.RunServerMethod("DHCWMR.SSService.OperationWL","WorkFlowOpera",MrTypeID,WFItemID,ExtraItemInput,session['LOGON.USERID'],CheckUserInput,'');
			if (parseInt(ret) < 0){
				ExtTool.alert("错误", "批量保存病案操作失败，返回值："+ret);
				return;
			}
		} else {
			var RecordIDs = '';
			var objStore = obj.GridWorkList.getStore();
			for (var row = 0; row < objStore.getCount(); row++){
				var record = objStore.getAt(row);
				if (record.get('IsChecked') == '1'){
					RecordIDs += ',' + record.get('RecordID');
				}
			}
			if (RecordIDs == '') return;
			RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
			var ret = ExtTool.RunServerMethod("DHCWMR.SSService.OperationWL","WorkFlowOpera",MrTypeID,WFItemID,ExtraItemInput,session['LOGON.USERID'],CheckUserInput,RecordIDs);
			if (parseInt(ret) < 0){
				ExtTool.alert("错误", "保存病案操作失败，返回值："+ret);
				return;
			}
		}
		obj.GridWorkList.getStore().removeAll();
		obj.GridWorkList.getStore().load({});
	}
	
	obj.btnDelete_click = function(){
		var MrTypeID = Common_GetValue("cboMrType");
		var WFItemID = obj.WFIConfig.WFItemID;
		if (!MrTypeID) {
			ExtTool.alert("提示", "请选择病案类型!");
			return;
		}
		if (!WFItemID) {
			ExtTool.alert("提示", "请选择操作项目!");
			return;
		}
		
		var objGrid = Ext.getCmp("GridWorkList");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中病案卷记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var RecordID = objRec.get("RecordID");
							var flg = ExtTool.RunServerMethod("DHCWMR.SSService.OperationWL","DelVolume",MrTypeID,WFItemID,RecordID,session['LOGON.USERID']);
							if (parseInt(flg) < 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除行 " + row + " 数据错误!Error=" + flg);
							} else {
								objGrid.getStore().remove(objRec);
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.btnClean_click = function(){
		var MrTypeID = Common_GetValue("cboMrType");
		var WFItemID = obj.WFIConfig.WFItemID;
		if (!MrTypeID) {
			ExtTool.alert("提示", "请选择病案类型!");
			return;
		}
		if (!WFItemID) {
			ExtTool.alert("提示", "请选择操作项目!");
			return;
		}
		
		var objGrid = Ext.getCmp("GridWorkList");
		if (objGrid){
			if (objGrid.getStore().getCount()>0){
				Ext.MessageBox.confirm('删除', '是否清空病案卷列表?', function(btn,text){
					if(btn=="yes"){
						var flg = ExtTool.RunServerMethod("DHCWMR.SSService.OperationWL","ClearVolume",MrTypeID,WFItemID,session['LOGON.USERID']);
						Common_LoadCurrPage("GridWorkList",1);
					}
				});
			}
		}
	}
	
	obj.btnUpdoOpera_click = function(){
		var RecordIDs = '';
		var objStore = obj.GridWorkList.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') == '1'){
				RecordIDs += ',' + record.get('RecordID');
			}
		}
		if (RecordIDs == '') return;
		RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
		
		if (RecordIDs == ''){
			ExtTool.alert('提示', '请选择需撤销的操作记录!');
			return false;
		}
		
		Ext.MessageBox.prompt('提示', '请输入撤销原因?', function(btn,text){
			if(btn=="ok"){
				if (text == ''){
					ExtTool.alert('提示', '撤销原因为空!');
					return;
				}
				var flg = ExtTool.RunServerMethod("DHCWMR.SSService.OperationWL","UpdoWorkFlowOpera",RecordIDs,session['LOGON.USERID'],text);
				if (parseInt(flg) < 0) {
					ExtTool.alert('提示', '撤销操作记录失败!');
					return;
				} else {
					ExtTool.alert('提示', '撤销操作记录成功!');
					Common_LoadCurrPage("GridWorkList",1);
				}
			}
		});
	}
	
	//打印病案条码或卷
	obj.PrintMrBarcode = function(VolumeIDs){
		var isPrintMBarcode = Common_GetValue("chkMBarCode");
		var isPrintVBarcode = Common_GetValue("chkVBarCode");
		if ((!isPrintMBarcode)&&(!isPrintVBarcode)) return;
		
		try{
			var strBarInfo = ExtTool.RunServerMethod("DHCWMR.SSService.VolumeSrv","GetBarInfo",VolumeIDs);
			if (strBarInfo == '') return;
			var arrBarInfo = strBarInfo.split(CHR_1);
			if (arrBarInfo.length<1) return;
			
			for (var indMR = 0; indMR < arrBarInfo.length; indMR++) {
				var strPatBarInfo = arrBarInfo[indMR];
				if (strPatBarInfo == '') return;
				var arrPatBarInfo = strPatBarInfo.split(CHR_2);
				var strMBarInfo = arrPatBarInfo[0];
				if (strMBarInfo == '') return;
				var arrMBarInfo = strMBarInfo.split("^");
				
				if (isPrintMBarcode) {
					var MBarCode	= arrMBarInfo[0];
					var MrType      = arrMBarInfo[1];
					var MrNo        = arrMBarInfo[2];
					var PatientName = arrMBarInfo[3];
					var Sex         = arrMBarInfo[4];
					var Birthday    = arrMBarInfo[5];
					var Age         = arrMBarInfo[6];
					for (indVol = 1; indVol < arrPatBarInfo.length; indVol++){
						var strVBarInfo = arrPatBarInfo[indVol];
						if (strVBarInfo == '') continue;
						var arrVBarInfo = strVBarInfo.split("^");
						if (arrVBarInfo.length>3) {
							var VBarCode     = arrVBarInfo[0];
							var DischLoc    = arrVBarInfo[1];
							var DischWard   = arrVBarInfo[2];
							var DischDate   = arrVBarInfo[3];
							var AdmDate     = arrVBarInfo[4];
							var printParam="";
							var printList="";
							// 打印参数
							printParam=printParam+"^MrNo1"+String.fromCharCode(2)+MrNo;
							printParam=printParam+"^DiscDate"+String.fromCharCode(2)+AdmDate;
							printParam=printParam+"^PatName"+String.fromCharCode(2)+PatientName;
							printParam=printParam+"^DiscLoc"+String.fromCharCode(2)+DischLoc;
							printParam=printParam+"^MrNo2"+String.fromCharCode(2)+MrNo;
							// 获取XML模板配置
							DHCP_GetXMLConfig("InvPrintEncrypt","WMRPrintMBar");
							var printObj = document.getElementById("ClsBillPrint");
							var c2 = String.fromCharCode(2);
							DHC_PrintByLodop(getLodop(),printParam,'',{},"");
						}
					}
				}
			}
		}catch(e) {
			alert('打印病案条码错误，' + e.message);
		}
	}
	
	obj.PrintMrBarcode_Bak = function(VolumeIDs){
		var isPrintMBarcode = Common_GetValue("chkMBarCode");
		var isPrintVBarcode = Common_GetValue("chkVBarCode");
		if ((!isPrintMBarcode)&&(!isPrintVBarcode)) return;
		
		try {
			var strBarInfo = ExtTool.RunServerMethod("DHCWMR.SSService.VolumeSrv","GetBarInfo",VolumeIDs);
			if (strBarInfo == '') return;
			var arrBarInfo = strBarInfo.split(CHR_1);
			if (arrBarInfo.length<1) return;
			
			var strPrinterName = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodePrinterName');  //取条码打印机名称
			if (strPrinterName=='') strPrinterName='Zebra';
			var strBarFormat = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodeType');  //取条码打印格式（条码样式）
			
			var Bar;
			Bar = new ActiveXObject("DHCMedBarCode.PrintBarMR");
			Bar.PrinterName = strPrinterName;  //打印机名称
			Bar.PrinterPort = "";              //打印机端口号
			Bar.BarFormat   = strBarFormat;    //设置条码样式编号
			//Bar.SetPrinter();                //设置打印机
			
			for (var indMR = 0; indMR < arrBarInfo.length; indMR++) {
				var strPatBarInfo = arrBarInfo[indMR];
				if (strPatBarInfo == '') return;
				var arrPatBarInfo = strPatBarInfo.split(CHR_2);
				var strMBarInfo = arrPatBarInfo[0];
				if (strMBarInfo == '') return;
				var arrMBarInfo = strMBarInfo.split("^");
				
				if ((isPrintMBarcode)&&(arrMBarInfo.length>=6)) {
					Bar.vMrType      = arrMBarInfo[1];
					Bar.vMrNo        = arrMBarInfo[2];
					Bar.vPatientName = arrMBarInfo[3];
					Bar.vSex         = arrMBarInfo[4];
					Bar.vBirthday    = arrMBarInfo[5];
					Bar.vAge         = arrMBarInfo[6];
					Bar.vBarCode     = arrMBarInfo[0];
					Bar.PrintOut();
				}
				
				if ((isPrintVBarcode)&&(arrMBarInfo.length>6)&&(arrPatBarInfo.length>1)) {
					Bar.vMrType      = arrMBarInfo[1] + " 卷";
					Bar.vMrNo        = arrMBarInfo[2];
					Bar.vPatientName = arrMBarInfo[3];
					Bar.vSex         = arrMBarInfo[4];
					Bar.vBirthday    = arrMBarInfo[5];
					Bar.vAge         = arrMBarInfo[6];
					
					for (indVol = 1; indVol < arrPatBarInfo.length; indVol++){
						var strVBarInfo = arrPatBarInfo[indVol];
						if (strVBarInfo == '') continue;
						var arrVBarInfo = strVBarInfo.split("^");
						if (arrVBarInfo.length>3) {
							Bar.vLocDesc     = arrVBarInfo[1];
							Bar.vAdmDate     = arrVBarInfo[4];
							Bar.vDischDate   = arrVBarInfo[3];
							Bar.vBarCode     = arrVBarInfo[0];
							Bar.PrintOut();
						}
					}
				}
			}
		} catch(e) {
			alert('打印病案条码错误，' + e.message);
		}
	}
	
	obj.btnBatchPrintBar_click = function(){
		var isPrintMBarcode = Common_GetValue("chkMBarCode");
		var isPrintVBarcode = Common_GetValue("chkVBarCode");
		if ((!isPrintMBarcode)&&(!isPrintVBarcode)) return;
		
		var VolumeIDs = '';
		var objStore = obj.GridWorkList.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			//if (record.get('IsChecked') == '1'){
				VolumeIDs += ',' + record.get('VolID');
			//}
		}
		if (VolumeIDs != '') VolumeIDs = VolumeIDs.substr(1,VolumeIDs.length-1);
		
		objScreen.PrintMrBarcode(VolumeIDs);  //打印条码 add by zf 20150318
	}
}