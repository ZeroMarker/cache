
function InitMRBReportEvent(obj) {
	obj.LoadEvent = function(args){
		obj.btnClose.on("click", obj.btnClose_click, obj);
		obj.btnUpdate.on("click", obj.btnUpdate_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
		obj.cboTransLoc_Init();
		obj.txtPathDate.setValue(obj.MRBPathDate);
		obj.SetComboInitVal('cboSampleType','',obj.MRBSampleType);
		obj.SetComboInitVal('cboMRBPy','',obj.MRBMRBPy);
		obj.gridMDRListStore.load({});
	}
	
	obj.btnUpdate_click = function(){
		var xTransID = '';
		var xTransLocID = '';
		var objTransLoc = Ext.getCmp('cboTransLoc');
		if (objTransLoc) {
			xTransID = objTransLoc.getValue();
			var objTransLocStore = objTransLoc.getStore();
			var ind = objTransLocStore.find("TransID",xTransID);
			if (ind > -1) {
				var objRec = objTransLocStore.getAt(ind);
				xTransLocID = objRec.get('TransLocID');
			}
		}
		var PathDate = Common_GetValue('txtPathDate');
		var SampleType = Common_GetValue('cboSampleType');
		var Pathogeny = Common_GetValue('cboMRBPy');
		var inputErr = '';
		if (xTransID == ''){
			inputErr = inputErr + '目标科室不允许为空!<br>';
		}
		if (PathDate == ''){
			inputErr = inputErr + '送检日期不允许为空!<br>';
		}
		if (SampleType == ''){
			inputErr = inputErr + '标本类型不允许为空!<br>';
		}
		if (Pathogeny == ''){
			inputErr = inputErr + '细菌名称不允许为空!<br>';
		}
		if (inputErr) {
			inputErr = inputErr + '请认真填写!<br>';
			ExtTool.alert("确认", inputErr);
			return;
		}
		
		var inputStr = obj.MDRRepID;
		inputStr = inputStr + CHR_1 + obj.EpisodeID;
		inputStr = inputStr + CHR_1 + xTransID;
		inputStr = inputStr + CHR_1 + xTransLocID;
		inputStr = inputStr + CHR_1 + PathDate;
		inputStr = inputStr + CHR_1 + SampleType;
		inputStr = inputStr + CHR_1 + Pathogeny;
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + obj.DataSource;
		var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CtlMRBSrv","SaveMDRRep",inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","保存失败!Error=" + flg);
			return;
		} else {
			obj.gridMDRListStore.load({});
			obj.MDRRepID = flg;
			objScreen.WindowRefresh_Handler();
		}
	}
	
	obj.btnDelete_click = function(){
		var objGrid = Ext.getCmp("gridMDRList");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除多重耐药菌记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							if (objRec.get("ReportID") != obj.MDRRepID) continue;
							
							var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CtlMRBSrv","DelMDRRep",objRec.get("ReportID"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								if (objRec.get("ReportID") == obj.MDRRepID){
									obj.MDRRepID = '';
									objScreen.WindowRefresh_Handler();
								}
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
	
	obj.btnClose_click = function(){
		obj.WinMRBReport.close();
	}
	
	obj.cboTransLoc_Init = function(){
		var xTransID = '';
		var xTransLocDesc = '';
		
		var strJson = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.CommonSrv","GetTransLocList",obj.EpisodeID,"W");
		var jsonData = Ext.util.JSON.decode(strJson);
		var tmpStore = new Ext.data.Store({
			data : jsonData,
			reader: new Ext.data.ArrayReader({
				idIndex: 0
			},Ext.data.Record.create([
				{name: 'TransID', mapping: 0}
				,{name: 'TransLocID', mapping: 1}
				,{name: 'TransLocDesc', mapping: 2}
				,{name: 'TransInTime', mapping: 3}
				,{name: 'TransOutTime', mapping: 4}
				,{name: 'PrevLocID', mapping: 5}
				,{name: 'PrevLocDesc', mapping: 6}
				,{name: 'NextLocID', mapping: 7}
				,{name: 'NextLocDesc', mapping: 8}
			]))
		})
		
		if (tmpStore.getCount() > 0){
			var tmpCount = tmpStore.getCount();
			var objRec = tmpStore.getAt(tmpCount-1);
			if (objRec){
				xTransID = objRec.get('TransID');
				xTransLocDesc = objRec.get('TransLocDesc');
				Common_SetValue('cboTransLoc',xTransID,xTransLocDesc);
			}
		}
	}
	
	obj.SetComboInitVal = function(cmp,code,desc){
		var objCmp = Ext.getCmp(cmp);
		if (objCmp){
			var valueField = objCmp.valueField;
			var displayField = objCmp.displayField;
			objCmp.getStore().load({
				callback : function(r){
					var flg = 0;
					for (var indRec = 0; indRec < r.length; indRec++){
						var objRec = r[indRec];
						if ((code != '')&&(code == objRec.get(valueField))) {
							flg = 1;
							Common_SetValue(cmp,objRec.get(valueField),objRec.get(displayField));
						}
						if ((desc != '')&&(desc == objRec.get(displayField))) {
							flg = 1;
							Common_SetValue(cmp,objRec.get(valueField),objRec.get(displayField));
						}
					}
					if (flg == 0){
						Common_SetValue(cmp,code,desc);
					}
				}
			});
		}
	}
}

