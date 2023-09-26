function InitViewPortEvents(obj){
	obj.LoadEvents = function(){
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.btnQry.on('click',obj.btnQry_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.RowExpander.on("expand",obj.RowExpander_expand,obj);
		obj.txtRegNo.on('specialkey',obj.txtRegNo_specialkey,obj);
		obj.txtRegNo.setWidth(150);
		
		Common_SetValue('txtAdmType',obj.AdmTypeDesc);
		Common_SetDisabled('txtAdmType',true);

		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.ReceiptGrid.getColumnModel();
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
	
	obj.RowExpander_expand = function(){	
		var objRec = arguments[1];
		var EpisodeID = objRec.get("EpisodeID");
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCWMR.SSService.ReceiptLogSrv',
				QueryName : 'QryReceiptLog',
				Arg1 : EpisodeID,
				ArgCnt : 1
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var arryData = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					arryData[arryData.length] = objItem;
				}
				var objRowExpander = new Object();
				objRowExpander.EpisodeID = EpisodeID;
				objRowExpander.Record = new Array();
				objRowExpander.Record = arryData;
				obj.RowTemplate.overwrite("divCtrlDtl-" + EpisodeID, objRowExpander);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divCtrlDtl-" + EpisodeID);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	obj.btnQry_click = function (){
		Common_LoadCurrPage('ReceiptGrid',1);
	}
	
	obj.btnExport_click = function (){
		if (obj.ReceiptGridStore.getCount()<1) {
			window.alert("请先查询再导出Excel！");
			return;
		}
		ExportGridByCls(obj.ReceiptGrid,'接诊日志查询');
	}
	
	obj.txtRegNo_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_LoadCurrPage('ReceiptGrid',1);
	}
	
	obj.GroupReceipt = function(aEpisodeID,aMrNo){
		if (!aEpisodeID) return;
		var result = IGroupReceipt(aEpisodeID,aMrNo,session['LOGON.CTLOCID'],session['LOGON.USERID']);
		var err = result.split('^')[0];
		if ((err*1)<0){
			ExtTool.alert('提示',result.split('^')[1]);
			return;
		}else{
			/* update by zf 2015-01-19
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			var objStore = obj.ReceiptGrid.getStore();
			if (objStore){
				var row = objStore.find('EpisodeID',aEpisodeID);
				if (row > -1){
					var rd = objStore.getAt(row);
					if (!rd) return;
					rd.set('VolumeID',VolumeID);
					rd.set('MrNo',MrNo);
					//rd.commitChange();
				}
			}
			*/
			Common_LoadCurrPage('ReceiptGrid');
		}
	}
	
	obj.GroupUnReceipt = function(aEpisodeID){
		if (!aEpisodeID) return;
		var result = IGroupUnReceipt(aEpisodeID,session['LOGON.CTLOCID'],session['LOGON.USERID']);
		var err = result.split('^')[0];
		if ((err*1)<0){
			ExtTool.alert('提示',err);
			return;
		}else{
			/* update by zf 2015-01-19
			var MrNo = IGetMrNoByEpisodeID(aEpisodeID);
			var objStore = obj.ReceiptGrid.getStore();
			if (objStore){
				var row = objStore.find('EpisodeID',aEpisodeID);
				if (row > -1){
					var rd = objStore.getAt(row);
					if (!rd) return;
					rd.set('VolumeID','');
					rd.set('MrNo',MrNo);
					//rd.commitChange();
				}
			}
			*/
			Common_LoadCurrPage('ReceiptGrid');
		}
	}
}
