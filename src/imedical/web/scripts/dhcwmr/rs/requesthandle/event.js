function InitviewScreenEvents(obj){
	var ClsRsRquest = ExtTool.StaticServerObject("DHCWMR.SS.RsRquest");
	var ClsSsVolume = ExtTool.StaticServerObject("DHCWMR.SS.Volume");
	var ClsSsWorkItem = ExtTool.StaticServerObject("DHCWMR.SS.WorkItem");
	var ClsSsWorkFItem = ExtTool.StaticServerObject("DHCWMR.SS.WorkFItem");
	obj.InterValID = "";
	obj.InterValActive = 0;
	obj.LoadEvents = function(){
		obj.cboLocGroup.on("select",obj.cboLocGroup_select,obj);
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.cboWFItem.on("select",obj.cboWFItem_select,obj);
		obj.cboMrType.on("select",obj.cboMrType_select,obj);
		obj.txtMrNo.on('specialKey',obj.txtMrNo_specialKey,obj);
		obj.btnQuery.on('click',obj.btnQuery_click,obj);
		obj.btnPrinf.on('click',obj.btnPrinf_click,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		document.body.onmousemove = document.body.onkeyup = function(){
		  obj.InterValActive = 1;  //计数器复位
		}
		obj.creatInterValGrid(30000); //默认五分钟刷新grid 
		obj.txtMrNo.focus();
		Common_LoadCurrPage('ConsultList');
	}

	///创建自动刷新页面计数器
	obj.creatInterValGrid = function(Sec)
	{
		if (obj.InterValID) clearInterval(obj.InterValID);
		obj.InterValID = setInterval(function(){
				if (obj.InterValActive==10)
				{
					obj.InterValActive = 1;
					Common_LoadCurrPage('ConsultList');//obj.ConsultListStore.load({});
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
						obj.cboMrType_select();
					}
				}
			}
		});
		//加载科室组
		obj.cboLocGroup.getStore().removeAll();
		obj.cboLocGroup.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0){
						obj.cboLocGroup.setValue(r[0].get("GroupID"));
						obj.cboLocGroup.setRawValue(r[0].get("GroupDesc"));
					}
				}
			}
		});
	}
	
	obj.cboLocGroup_select = function(combo,record,index){
		obj.cboLoc.setValue();
		obj.cboLoc.setRawValue();
		obj.cboLoc.getStore().removeAll();
		obj.cboLoc.getStore().load({});
	}

	//通过权限获取工作项目
	obj.GetOperaList = function(){
		var OperaList = "";
		if (tDHCMedMenuOper){
			for(var code in tDHCMedMenuOper) {
				var hasPower = tDHCMedMenuOper[code];
				if(hasPower == 0)
					continue;
				if(OperaList != "")
					OperaList += "#";
				OperaList += code;
			}
		}
		return OperaList;
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
			obj.WFIConfig.MRCategory = record.get('MRCategory');
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
			obj.WFIConfig.MRCategory = '';
		}
	}
	
	obj.txtMrNo_specialKey = function(field, e)
	{
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_LoadCurrPage('ConsultList');
		Common_SetValue("txtMrNo","");
		obj.txtMrNo.focus();
	}

	obj.btnQuery_click = function()
	{
		Common_LoadCurrPage('ConsultList');
	}

	obj.btnPrinf_click = function()
	{
		if (obj.ConsultListStore.getCount()<1) {
			window.alert("请先查询再打印！");
			return;
		}
		var fields = 'PatName'
			+ CHR_1 + 'PapmiNo'
			+ CHR_1 + 'MrNo'
			+ CHR_1 + 'Sex'
			+ CHR_1 + 'Age'
			+ CHR_1 + 'ReqUserDesc'
			+ CHR_1 + 'ReqLocDesc'
			+ CHR_1 + 'ReqTime';
		var xlsName = 'DHCWMR_OMR_RequestList.xlt';
		var recTitle = Common_GetValue('门诊病历调阅申请单');
		PrintGridByCls(obj.ConsultList,fields,xlsName,recTitle);
	}

	obj.marking = function(rowIndex)
	{
		var objRec = obj.ConsultListStore.getAt(rowIndex);
		var ret = ClsRsRquest.UpdateMarker(objRec.get("RquestID"),"A");
		if (parseInt(ret)<0) {
			Ext.MessageBox.alert("错误提示","标记失败！");
		}else{
			Common_LoadCurrPage('ConsultList');
		}
	}
	obj.operation = function(rowIndex)
	{
		var objRec = obj.ConsultListStore.getAt(rowIndex);
		var VolumeID = objRec.get("VolumeID");
		var RquestID = objRec.get("RquestID");
		var Marker = objRec.get("Marker");
		if (!Marker)
		{
			Ext.MessageBox.alert("提示","请先标记！");
			return;
		}
		obj.btnSaveOperaType = 0;
		obj.WorkFlowOperaByStep(VolumeID,RquestID);
	}

	obj.WorkFlowOperaByStep = function(VolumeID,RquestID){
		var MrTypeID = Common_GetValue("cboMrType");
		if (MrTypeID == '') return;
		var WFItemID = obj.WFIConfig.WFItemID;
		if (WFItemID == '') return;
		if (!WFItemID){
			ExtTool.alert("错误", "菜单权限配置错误！");
			return;
		}
		var CurrentWorkItem = ClsSsVolume.GetObjById(VolumeID).SVStatus;
		var WorkItemTo  = ClsSsWorkFItem.GetObjById(WFItemID).WFIItem;
		if (WorkItemTo==CurrentWorkItem)
		{
			ExtTool.alert("提示", "该病历已经处理！");
			return;
		}

	    var flg = ExtTool.RunServerMethod("DHCWMR.SSService.OperationSrv","CheckOperation",VolumeID,WFItemID,"")
		var ProblemCode=flg.split("^")[0];
		var ProblemDesc=flg.split("^")[1];
		if (ProblemCode<0){
			ExtTool.alert("提示", ProblemDesc);
			return;
		}
		var ExtraItemInput = '';
		var CheckUserInput = '';
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.OperationSrv","Operation",VolumeID,WFItemID,"",session['LOGON.USERID'],"","","");
		if (parseInt(ret) < 0){
			ExtTool.alert("错误", "出库失败，返回值："+ret);
			return;
		}else{
			//改变申请状态
			var CHR_1=String.fromCharCode(1);
			var inputStr = "A";
			inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
			var ret = ClsRsRquest.UpdateReqStatus(RquestID,inputStr,CHR_1)
			if (parseInt(ret)<0) {
				Ext.MessageBox.alert("错误提示","标记失败！");
			}else{
				Common_LoadCurrPage('ConsultList');
			}
		}
	}
}