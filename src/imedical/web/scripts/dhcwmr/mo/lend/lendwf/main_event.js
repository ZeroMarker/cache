function InitViewportEvents(obj){
	obj.InterValID = "";	//Grid自动刷新定时器ID
	obj.InterValActive = 0;
	document.body.onmousemove = document.body.onkeyup = function(){
		obj.InterValActive = 0;					//grid自动刷新计数器复位
	}	
	obj.LoadEvents = function(){
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboQryType.on("select",obj.cboQryType_select,obj);
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnLend.on("click",obj.btnLend_click,obj);
		obj.btnBack.on("click",obj.btnBack_click,obj);
		obj.btnPrint.on("click",obj.btnPrint_click,obj);
		obj.gridLendRecord.on("rowdblclick",obj.gridLendRecord_rowdblclick,obj);
		obj.gridLendRecord.on("rowclick",obj.gridLendRecord_rowclick,obj);
		obj.txtMrNo.on('specialkey',obj.btnMrNo_specialkey,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		obj.txtMrNo.focus(true);
		if (MrClass=="O")								//门诊病历 
		{
			obj.creatInterValGrid(10000);				//10秒刷新grid 自动打印
			obj.creatInterValLend(60000);				//挂号自动出库出条 60秒
		}else
		{
			var cm = obj.gridLendRecord.getColumnModel();
	    		var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if (cfg.id=="LendFlag") {
					cm.setHidden(i,true);
	   	 		}
			}
		}
	}
	
	obj.creatInterValLend = function(Sec){
		var InterValID = setInterval(function(){
			var MrTypeID = Common_GetValue('cboMrType');
			var UserID = session['LOGON.USERID'];
			var HospID = Common_GetValue('cboHospital');
			var DateFrom = obj.getNowFormatDate();
			var DateTo = obj.getNowFormatDate();
			var ret = ExtTool.RunServerMethod('DHCWMR.MOService.LendBarSrv','BatchLendByAdm',MrTypeID,UserID);
			if (ret>0)
			{
				var conn = Ext.lib.Ajax.getConnectionObject().conn;
				var url = ExtToolSetting.RunQueryPageURL + '?1=1'
				url += '&ClassName=' + 'DHCWMR.MOService.LendBarSrv'
				url += '&QueryName=' + 'QryLendBar'
				url += '&Arg1=' + HospID
				url += '&Arg2=' + MrTypeID
				url += '&Arg3=' + DateFrom
				url += '&Arg4=' + DateTo
				url += '&Arg5=' + 0
				url += '&ArgCnt=' + 5
				url += '&5=5'
				conn.open('post',url,false);
				conn.send(null);
				if (conn.status != '200') {
					ExtTool.alert('错误', '出库条查询错误!');
				}else{
					var jsonData = new Ext.decode(conn.responseText);
					if (jsonData.total > 0){
						for (var row = 0; row < jsonData.record.length; row++){
							var record = jsonData.record[row];
							var BarID = record.BarID;
							obj.PrintLendBar(BarID);
						}
					}
				}
			}
		},Sec);
	}
	
	//创建自动刷新页面计数器
	obj.creatInterValGrid = function(Sec){
		if (obj.InterValID) clearInterval(obj.InterValID);
		obj.InterValID = setInterval(function(){
			var OperType = Common_GetValue("cboOperType");
			if (OperType != 1) return;
			if (obj.InterValActive==1){
				Common_SetValue("cboQryType","L","出库");
				Common_SetValue('msgGridLendRecord','出库查询列表');
				obj.gridLendRecordStore.removeAll();
				obj.gridLendRecordStore.load({});
			}else{
				obj.InterValActive++;
			}
		},Sec);
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
						obj.cboQryType_select();
					}
				}
			}
		});
	}
	
	obj.cboQryType_select = function(combo,record,index){
		var MrTypeID = Common_GetValue("cboMrType");
		var QryType = Common_GetValue("cboQryType");
		var LendFlag = "";
		if (QryType=="L") {
			LendFlag="LL";
			Common_SetDisabled("btnLend",false);
			Common_SetDisabled("btnBack",true);
		}
		if (QryType=="B") {
			LendFlag="LB";
			Common_SetDisabled("btnLend",true);
			Common_SetDisabled("btnBack",false);
		}
		if (LendFlag!="") {
			var objWFItem = ExtTool.RunServerMethod('DHCWMR.SS.WorkFItem','GetWFItemBySysOpera',MrTypeID,LendFlag);
			if (objWFItem){
				obj.WFIBatchOper = objWFItem.WFIBatchOper;
				LendFlag="";
			}
		}
		obj.gridLendRecordStore.removeAll();
	}
	
	obj.btnMrNo_specialkey = function(field,e){
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_SetValue("cboOperType","2","手工执行");
		
		var HospID = Common_GetValue("cboHospital");
		var MrTypeID = Common_GetValue("cboMrType");
		var MrNo = Common_GetValue("txtMrNo");
		if (MrNo==''){
			ExtTool.alert("提示",'请输入病案号！');
			return;
		}
		
		var QryType = Common_GetValue("cboQryType");
		if (QryType == 'R') {  //申请
			
		} else if (QryType == 'L') {  //出库
			if (obj.WFIBatchOper=='1') {
				//批量出库 查询病案卷
				if (obj.btnLend.disabled) {
					Common_SetDisabled("btnLend",false);
					obj.gridLendRecordStore.removeAll();					
				}
				if (!obj.btnBack.disabled) {
					Common_SetDisabled("btnBack",true);
				}

				var win = new BL_InitVolumeLend();
				var flg = win.BL_VolumeQuery(MrTypeID,MrNo);
				if (flg){
					win.BL_WinVolumeLend.show();
					return;
				}
			}else{
				//单个出库 查询病案卷
				obj.gridLendRecordStore.removeAll();
				obj.gridLendRecordStore.load({
					callback : function(r,option,success){
						if (success) {
							var ReLength = r.length;
							obj.gridLendRecordStore.each(function(r){
								if (r.get('LendFlag')=="F") ReLength = ReLength-1;
							})
							if (ReLength > 0) {
								ExtTool.alert("提示",'病案已出库，不允许重复出库操作!');
								return;
							} else {
								var win = new VL_InitVolumeLend();
								var flg = win.VL_VolumeQuery(MrTypeID,MrNo);
								if (flg){
									win.VL_WinVolumeLend.show();
									return;
								}
							}
						}
					}
				});
			}
		} else if (QryType == 'B') {  //入库
			var win = new VB_InitVolumeBack();
			var flg = win.VB_VolumeQuery(MrTypeID,MrNo);
			if (flg){
				win.VB_WinVolumeBack.show();
				return;
			}
		}
		
		//Common_LoadCurrPage('gridLendRecord',1);
		Common_SetValue("txtMrNo","");
	}
	
	obj.btnQuery_click = function(){
		Common_SetValue("cboOperType","2","手工执行");
		Common_SetValue("txtMrNo","");
		
		var QryType=Common_GetValue("cboQryType");
		if (QryType=='R') {
			Common_SetValue('msgGridLendRecord','申请查询列表');
			Common_SetDisabled("btnLend",false);
			Common_SetDisabled("btnBack",true);
		} else if (QryType=='L') {
			Common_SetValue('msgGridLendRecord','出库查询列表');
			Common_SetDisabled("btnLend",true);
			Common_SetDisabled("btnBack",false);
		} else if (QryType=='B') {
			Common_SetValue('msgGridLendRecord','入库查询列表');
			Common_SetDisabled("btnLend",true);
			Common_SetDisabled("btnBack",true);
		} else {}
		
		obj.gridLendRecordStore.removeAll();
		obj.gridLendRecordStore.load({});
	}
	
	obj.btnLend_click = function(){
		var MrTypeID = Common_GetValue("cboMrType");
		if (!MrTypeID){
			ExtTool.alert("提示",'病案类型为空!');
			return;
		}
		var objWFItem = ExtTool.RunServerMethod('DHCWMR.SS.WorkFItem','GetWFItemBySysOpera',MrTypeID,"LL");
		if (!objWFItem){
			ExtTool.alert("提示",'无出库操作项目!');
			return;
		}
		//批量借出操作 
		var objStore = obj.gridLendRecord.getStore();
		var checkCount=0,MRecords='';
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') != '1') continue;
			var MainID=record.get('MainID');
			var VolumeIDs=record.get('VolumeIDs');
			if (MRecords=='')
			{
				MRecords = MainID+'^'+VolumeIDs;
			}else{
				MRecords = MRecords+'|'+MainID+'^'+VolumeIDs;
			}
			checkCount++;
		}
		if (!checkCount)
		{
			ExtTool.alert("提示",'无出库病案列表!');
			return;
		}
		var win = new LI_InitLendInfo(MRecords);
		win.LI_WinLendInfo.show();
		//单个借出操作
		/*var RecordIDS="";
		var objStore = obj.gridLendRecord.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') != '1') continue;
			var StatusCode = record.get('StatusCode');
			if (StatusCode!="R") continue;
			var RecordID = record.get('RecordID');
			var RecordIDS=RecordIDS+","+RecordID;
		}
		
		if (RecordIDS != '') RecordIDS = RecordIDS.substr(1,RecordIDS.length - 1);
		if (RecordIDS==''){
			ExtTool.alert("提示",'无出库病案列表!');
			return;
		}
		var objInput = new Object();
		objInput.OperType = 'L';
		objInput.ToUserID = '';
		objInput.MRecord = '';
		objInput.LRecord = RecordIDS;
		objInput.Detail = '';
		objInput.LendFlag = '';
		
		//是否用户校验
		if (objWFItem.WFICheckUser == 1){
			var win = new CU_InitCheckUser(objInput);
			win.WinCheckUser.show();
		} else {
			obj.SaveData(objInput);
		}*/
	}
	
	obj.btnBack_click = function(){
		var RecordIDS="";
		var objStore = obj.gridLendRecord.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
			if (record.get('IsChecked') != '1') continue;	
			var StatusCode = record.get('StatusCode');
			if (StatusCode != "L") continue;
			var RecordID = record.get('RecordID');
			RecordIDS = RecordIDS + "," + RecordID;
		}
		if (RecordIDS != '') RecordIDS = RecordIDS.substr(1,RecordIDS.length - 1);
		if (RecordIDS==''){
			ExtTool.alert("提示",'无入库病案列表!');
			return;
		}
		var MrTypeID = Common_GetValue("cboMrType");
		if (!MrTypeID){
			ExtTool.alert("提示",'病案类型为空!');
			return;
		}
		var objWFItem = ExtTool.RunServerMethod('DHCWMR.SS.WorkFItem','GetWFItemBySysOpera',MrTypeID,"LB");
		if (!objWFItem){
			ExtTool.alert("提示",'无入库操作项目!');
			return;
		}
		
		var objInput = new Object();
		objInput.OperType = 'B';
		objInput.ToUserID = '';
		objInput.MRecord = '';
		objInput.LRecord = RecordIDS;
		objInput.Detail = '';
		objInput.LendFlag = '';
		
		//是否用户校验
		if (objWFItem.WFICheckUser == 1){
			var win = new CU_InitCheckUser(objInput);
			win.WinCheckUser.show();
		} else {
			obj.SaveData(objInput);
		}
	}
	
	obj.btnPrint_click = function(){
		obj.gridLendRecordStore.each(function(r){
			var RecordID 	= r.get("RecordID");
			var IsChecked = r.get("IsChecked");
			if (IsChecked){
				obj.PrintLendBar(RecordID);
			}
		});
	}
	
	obj.gridLendRecord_rowclick = function(grid,rowIndex,e){
		var objStore = grid.getStore();
		var record = objStore.getAt(rowIndex);
		var StatusCode = record.get('StatusCode')
		if ((StatusCode!="U")||(StatusCode!="B")){
			if (record.get('IsChecked') != '1'){
				record.set('IsChecked', '1');
			} else {
				record.set('IsChecked', '0');
			}
		}
		//Common_SetDisabled("btnLend",true);				
		var QryType=Common_GetValue("cboQryType");
		if ((QryType=='L')&&(obj.WFIBatchOper!='1')) {
			Common_SetDisabled("btnLend",true);
		}
	}
	
	obj.gridLendRecord_rowdblclick = function(){
		var selectObj = obj.gridLendRecord.getSelectionModel().getSelected();
		var RecordID = selectObj.get("RecordID");
		var LendFlag = selectObj.get("LendFlag");
		var StatusCode = selectObj.get("StatusCode");
		Ext.MessageBox.confirm("系统提示", "是否取消当前操作？", function(but) {
			if (but=="yes"){
				var objInput = new Object();
				objInput.OperType = 'U';
				objInput.ToUserID = '';
				objInput.MRecord = '';
				objInput.LRecord = RecordID;
				objInput.Detail = '';
				objInput.LendFlag = LendFlag;
				obj.SaveData(objInput);
			}
		});
	}
	
	obj.SaveData = function(objInput){
		var FromUserID  = session['LOGON.USERID'];
		var OperType = objInput.OperType;
		var ToUserID = objInput.ToUserID;
		var MRecord = objInput.MRecord;
		var LRecord = objInput.LRecord;
		var Detail = objInput.Detail;
		var LendFlag = objInput.LendFlag;
				
		if ((Common_GetValue("cboQryType")=='L')&&(obj.WFIBatchOper=='1')) {
			//批量借出 保存
			var ret = ExtTool.RunServerMethod('DHCWMR.MOService.LendRecordSrv','BatchLendOper',OperType,FromUserID,ToUserID,MRecord,LRecord,Detail,LendFlag);
			if (ret== 1){
				ExtTool.alert("提示","保存成功!");
				obj.gridLendRecordStore.removeAll();
			} else{
				//批量借出失败 清除成功借出记录
				var retArray=ret.split("|");
				var objStore = obj.gridLendRecord.getStore();
				var removeArray=[];
				for (var i=0;i<retArray.length;i++){
					for (var row = 0; row < objStore.getCount(); row++){
						var record = objStore.getAt(row);
						var MainID =record.get('MainID');
						var VolumeID = record.get('VolumeIDs');
						
						if ((MainID==retArray[i].split('^')[0])&&(VolumeID==retArray[i].split('^')[1]))
						{
							objStore.removeAt(row);
						}
					}
				}		
			}
		}else{
			var ret = ExtTool.RunServerMethod('DHCWMR.MOService.LendRecordSrv','LendOperation',OperType,FromUserID,ToUserID,MRecord,LRecord,Detail,LendFlag);
			if (parseInt(ret) < 1){
				ExtTool.alert("错误","保存出入库记录失败!");
			} else {
				obj.btnQuery_click();
			}
		}
	}
	
	obj.BatchPrintLendBar = function(){
		obj.gridLendRecordStore.each(function(r){
			var PrintFlag = r.get("PrintFlag");
			var RecordID = r.get("RecordID");
			if (PrintFlag ==0) obj.PrintLendBar(RecordID);
		});
	}
		
	obj.PrintLendBar = function(BarID){
		var HospID = Common_GetValue('cboHospital');
		var LocIpAdr = obj.GetLocalIPAddr();
		var IpAdrList = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'PrintLendListIP');  //打印电脑IP配置
		if (IpAdrList=="") {
			ExtTool.alert("提示",'请配置需要打印出库条的IP地址！');
			return;
		}
		var IpAdrListArr = IpAdrList.split("/");
		var flg = 0
		for(var i =0;i<IpAdrListArr.length;i++)
		{
			if (IpAdrListArr[i]==LocIpAdr){
				flg = 1;
			}
		}
		if ( flg==0) return;
		try{
			var StrPrintInfo = ExtTool.RunServerMethod('DHCWMR.MOService.LendBarSrv','GetPrintInfo',BarID,HospID);
			if (StrPrintInfo=="") return;
			var strPrinterName = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'SerialNumberPrinterName');  //取热敏打印机名称
			if (strPrinterName=='') strPrinterName='Epson';
			var arrPrintInfo = StrPrintInfo.split("^");
			var Bar;
			Bar = new ActiveXObject("DHCMedBarCode.PrintBarMRLend");
			Bar.PrinterName = strPrinterName;  //打印机名称
			Bar.PrinterPort = "";              //打印机端口号
			//Bar.SetPrinter();                  //设置打印机    
			Bar.vLendFlag 		= arrPrintInfo[0];
			Bar.vTitie			= arrPrintInfo[1];
			Bar.vDocDesc		= arrPrintInfo[2];
			Bar.vNumber			= arrPrintInfo[3];
			Bar.vLocDesc		= arrPrintInfo[4];
			Bar.vMrNo			= arrPrintInfo[5];
			Bar.vPatName		= arrPrintInfo[6];
			Bar.vSex			= arrPrintInfo[7];
			Bar.vAdmDate		= arrPrintInfo[8];
			Bar.vAdmDateTime	= arrPrintInfo[9];
			Bar.vMrStatus		= arrPrintInfo[10];
			Bar.vLendLocDesc	= arrPrintInfo[11];
			Bar.vLendDocDesc	= arrPrintInfo[12];
			Bar.vLendDateTime	= arrPrintInfo[13];
			Bar.PrintLendBarCode();
		}catch(e){
			ExtTool.alert("提示",'打印错误：'+e.message);
		}
	}
	
	obj.GetLocalIPAddr = function(){
		var oSetting = null; 
		var ip = null; 
		try{ 
			oSetting = new ActiveXObject("rcbdyctl.Setting");
			ip = oSetting.GetIPAddress; 
			if (ip.length == 0){ 
				return "没有连接到网络"; 
			} 
			oSetting = null; 
		}catch(e){
			return ip; 
		} 
		return ip; 
	}

	obj.getNowFormatDate = function(){
		var date = new Date();
		var seperator1 = "-";
		var month = date.getMonth() + 1;
		var strDate = date.getDate();
		if (month >= 1 && month <= 9) {
			month = "0" + month;
		}
		if (strDate >= 0 && strDate <= 9) {
			strDate = "0" + strDate;
		}
		var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;
		return currentdate;
	} 
}