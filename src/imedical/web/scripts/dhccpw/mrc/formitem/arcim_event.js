function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.gridLnkArcimStore.load({});
		obj.gridLnkArcim.on("rowclick",obj.gridLnkArcim_rowclick,obj);
		obj.gridLnkArcim.on("cellclick",obj.gridLnkArcim_cellclick,obj);
		obj.btnAdd.on("click",obj.btnAdd_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnMoveUp.on("click",obj.btnMoveUp_click,obj);
		obj.btnMoveDown.on("click",obj.btnMoveDown_click,obj);
		obj.btnMerge.on("click",obj.btnMerge_click,obj);
		obj.cboArcim.on("select",obj.cboArcim_select,obj);
		obj.btnCopy.on("click",obj.btnCopy_click,obj);
		
		Common_SetDisabled('btnUpdate',true);
		Common_SetDisabled('btnDelete',true);
		Common_SetDisabled('btnMerge',true);
		Common_SetDisabled('btnMoveUp',true);
		Common_SetDisabled('btnMoveDown',true);
	}
	
	obj.gridLnkArcim_rowclick = function(){
		var rowIndex=arguments[1];
		obj.GridRowSelect(rowIndex);
	}
	
	obj.GridRowSelect = function(rowIndex){
		var rd = obj.gridLnkArcim.getStore().getAt(rowIndex);
		if (rd){
			obj.currRowIndex = rowIndex;
			Common_SetValue('cboOECPriority',rd.get('IGPriority'),rd.get('IGPriorityDesc'));
			Common_SetValue('txtLinkNo',rd.get('IGLinkNo'));
			Common_SetValue('cboArcim',rd.get('IGAArcimDR'),rd.get('IGAArcimDesc'));
			Common_SetValue('txtDoseQty',rd.get('IGADoseQty'));
			Common_SetValue('cboDoseUom',rd.get('IGADoseUomDR'),rd.get('IGADoseUomDesc'));
			Common_SetValue('cboPHCFreq',rd.get('IGAFreqDR'),rd.get('IGAFreqDesc'));
			Common_SetValue('cboPHCInstruc',rd.get('IGAInstrucDR'),rd.get('IGAInstrucDesc'));
			Common_SetValue('cboPHCDuration',rd.get('IGADuratDR'),rd.get('IGADuratDesc'));
			Common_SetValue('txtPackQty',rd.get('IGAPackQty'));
			Common_SetValue('txtItmResume',rd.get('IGAResume'));
			var ArcimID = rd.get('IGAArcimDR');
			obj.SetArcimLnkCmpDisabled(ArcimID);
			if (obj.IsReadOnly) {
				Common_SetDisabled('btnAdd',true);
				Common_SetDisabled('btnCopy',true);
				Common_SetDisabled('btnUpdate',true);
				Common_SetDisabled('btnDelete',true);
				Common_SetDisabled('btnMerge',true);
				Common_SetDisabled('btnMoveUp',true);
				Common_SetDisabled('btnMoveDown',true);
			}
			else {
				Common_SetDisabled('btnUpdate',false);
				Common_SetDisabled('btnDelete',false);
				Common_SetDisabled('btnMerge',false);
				Common_SetDisabled('btnMoveUp',false);
				Common_SetDisabled('btnMoveDown',false);
			}
		}
	}
	
	obj.ClearCmpListVal = function(){
		Common_SetValue('cboOECPriority','','');
		Common_SetValue('txtLinkNo','');
		Common_SetValue('cboArcim','','');
		Common_SetValue('txtDoseQty','');
		Common_SetValue('cboDoseUom','','');
		Common_SetValue('cboPHCFreq','','');
		Common_SetValue('cboPHCInstruc','','');
		Common_SetValue('cboPHCDuration','','');
		Common_SetValue('txtPackQty','');
		Common_SetValue('txtItmResume','');
		obj.SetArcimLnkCmpDisabled();
		Common_SetDisabled('btnUpdate',true);
		Common_SetDisabled('btnDelete',true);
		Common_SetDisabled('btnMerge',true);
		Common_SetDisabled('btnMoveUp',true);
		Common_SetDisabled('btnMoveDown',true);
	}
	
	obj.SaveLnkArcim = function(IGSub,IGASub){
		var PriorityID = Common_GetValue('cboOECPriority');
		var LinkNo = Common_GetValue('txtLinkNo');
		var ArcimID = Common_GetValue('cboArcim');
		var ArcimDesc = Common_GetText('cboArcim');
		var DoseQty = Common_GetValue('txtDoseQty');
		var DoseUomID = Common_GetValue('cboDoseUom');
		var FreqID = Common_GetValue('cboPHCFreq');
		var InstrucID = Common_GetValue('cboPHCInstruc');
		var DurationID = Common_GetValue('cboPHCDuration');
		var PackQty = Common_GetValue('txtPackQty');
		var ItmResume = Common_GetValue('txtItmResume');
		var Note = '';
		
		if (IGSub != ''){
			var rd = obj.gridLnkArcim.getStore().getAt(obj.currRowIndex);
			var IGNo = rd.get('IGNo');
			var IsDefault = rd.get('IGADefault');
			var IsActive = rd.get('IGAIsActive');
			var IsMain = rd.get('IGIsMain');
		} else {
			var IGNo = '';
			var IsDefault = 0;
			var IsActive = 1;
			var IsMain = 1;
		}
		
		if (PriorityID == ''){
			ExtTool.alert("提示","医嘱类型为必填项,请认真检查!");
	  		return false;
		}
		if ((ArcimID == '')||(ArcimDesc == '')){
			ExtTool.alert("提示","医嘱名称为必填项,请认真检查!");
	  		return false;
		}
		
		//关联号转换
		var tLinkNo = '';
		if (LinkNo != ''){
			var rowIndex = obj.gridLnkArcim.getStore().find('IGNo',LinkNo);
			if (rowIndex > -1){
				var rd = obj.gridLnkArcim.getStore().getAt(rowIndex);
				var ArcimDesc = rd.get('IGAArcimDesc');
				//if ((ArcimDesc.indexOf('葡萄糖注射液')>-1)||(ArcimDesc.indexOf('氯化钠注射液')>-1)) {
					var IGAIndex = rd.get('IGAIndex');
					tLinkNo = IGAIndex.split('-')[0];
				//}
			}
			if (tLinkNo == ''){
				ExtTool.alert("提示","关联号错误,请认真填写!");
				return false;
			}
		}
		
		var inputStr = FormItemID
			+ '^' + IGSub
			+ '^' + IGASub
			+ '^' + IGNo        //顺序号
			+ '^' + PriorityID  //医嘱类型
			+ '^' + tLinkNo     //关联号
			+ '^' + IsMain      //是否主医嘱
			+ '^' + ArcimID
			+ '^' + DoseQty
			+ '^' + DoseUomID
			+ '^' + FreqID
			+ '^' + InstrucID
			+ '^' + DurationID
			+ '^' + PackQty
			+ '^' + IsDefault  //首选医嘱
			+ '^' + IsActive   //是否有效
			+ '^' + ItmResume
			+ '^' + session['LOGON.USERID']
		
		var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","SaveLnkArcim",inputStr);
		if (parseInt(ret)<1){
			ExtTool.alert("提示","保存关联医嘱错误!");
	  		return false;
		}
		return true;
	}
	
	obj.btnAdd_click = function(){
		var ret = obj.SaveLnkArcim('','');
		if (ret == true){
			obj.currRowIndex = '';
			Common_LoadCurrPage('gridLnkArcim');
			obj.ClearCmpListVal();
		}
	}
	
	obj.btnCopy_click = function(){
		var arrID=FormItemID.split("||");
		if (arrID.length<4)
		{
			return;
		}
		var CPWID=arrID[0];
		var CPWItemID=obj.StepItemId;
		var obj2=obj;
	    CopyLinkArcimLookUpHeader(CPWID,CPWItemID,obj2,FormItemID);
	}
	
	obj.btnUpdate_click = function(){
		var IGSub = '',IGASub = '';
		var rd = obj.gridLnkArcim.getStore().getAt(obj.currRowIndex);
		if (rd){
			var IGAIndex = rd.get('IGAIndex');
			var GeneID = IGAIndex.split('-')[0];
			IGSub = GeneID.split('||')[4];
			IGASub = IGAIndex.split('-')[1];
		}
		var ret = obj.SaveLnkArcim(IGSub,IGASub);
		if (ret == true){
			Common_LoadCurrPage('gridLnkArcim');
			obj.ClearCmpListVal();
		}
	}
	
	obj.btnDelete_click = function(){
		Ext.MessageBox.confirm('提示', '确认是否删除当前选中关联医嘱?', function(btn,text){
			if(btn=="yes"){
				var GeneID = '',IGASub = '';
				var rd = obj.gridLnkArcim.getStore().getAt(obj.currRowIndex);
				if (rd){
					var IGAIndex = rd.get('IGAIndex');
					var GeneID = IGAIndex.split('-')[0];
					var IGASub = IGAIndex.split('-')[1];
				}
				var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","DeleteLnkArcim",GeneID,IGASub);
				if (parseInt(ret)<1){
					ExtTool.alert("提示","删除关联医嘱错误!");
					return false;
				} else {
					obj.currRowIndex = '';
					Common_LoadCurrPage('gridLnkArcim');
					obj.ClearCmpListVal();
				}
			}
		});
	}
	
	obj.cboArcim_select = function(combo,record,index){
		Common_SetValue('txtDoseQty','');
		Common_SetValue('txtPackQty','');
		Common_SetValue('txtItmResume','');
		Common_SetValue('cboDoseUom','','');
		Common_SetValue('cboPHCFreq','','');
		Common_SetValue('cboPHCInstruc','','');
		Common_SetValue('cboPHCDuration','','');
		obj.cboDoseUom.getStore().removeAll();
		obj.cboDoseUom.getStore().load({});
		obj.cboPHCFreq.getStore().removeAll();
		obj.cboPHCInstruc.getStore().removeAll();
		obj.cboPHCDuration.getStore().removeAll();
		var ArcimID = record.get(combo.valueField);
		obj.SetArcimLnkCmpDisabled(ArcimID,1);
	}
	
	obj.SetArcimLnkCmpDisabled = function(ArcimID,SetDefValue){
		Common_SetDisabled('txtDoseQty',true);
		Common_SetDisabled('txtPackQty',true);
		Common_SetDisabled('cboDoseUom',true);
		Common_SetDisabled('cboPHCFreq',true);
		Common_SetDisabled('cboPHCInstruc',true);
		Common_SetDisabled('cboPHCDuration',true);
		
		var tmpArcimID=ArcimID + '';
		if (tmpArcimID.indexOf('||')>-1){  //医嘱项
			var arcimStr = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","GetArcimInfoById",ArcimID);
			if (arcimStr == '') return;
			var arcim=arcimStr.split("^");
			if(arcim[1]=="R"){
				Common_SetDisabled('txtDoseQty',false);
				Common_SetDisabled('cboDoseUom',false);
				Common_SetDisabled('cboPHCFreq',false);
				Common_SetDisabled('cboPHCInstruc',false);
				Common_SetDisabled('cboPHCDuration',false);
			}else if(arcim[2]=="4"){
				Common_SetDisabled('txtPackQty',false);
				Common_SetDisabled('cboPHCFreq',false);
				Common_SetDisabled('cboPHCDuration',false);
			}else{
				Common_SetDisabled('txtPackQty',false);
			}
			
			if (SetDefValue){  //设置默认值
				if(arcim[1]=="R"){
					Common_SetValue('txtDoseQty',arcim[3]);
					Common_SetValue('cboDoseUom',arcim[4],arcim[5]);
					Common_SetValue('cboPHCFreq',arcim[8],arcim[9]);
					Common_SetValue('cboPHCInstruc',arcim[10],arcim[11]);
					Common_SetValue('cboPHCDuration',arcim[6],arcim[7]);
				}else if(arcim[2]=="4"){
					Common_SetValue('txtPackQty',1);
					Common_SetValue('cboPHCFreq',arcim[8],arcim[9]);
					Common_SetValue('cboPHCDuration',arcim[6],arcim[7]);
				}else{
					Common_SetValue('txtPackQty',1);
				}
			}
		}
	}
	
	obj.btnMoveUp_click = function(){
		var FromGeneID = '',FromIGAIndex = '';
		var rd = obj.gridLnkArcim.getStore().getAt(obj.currRowIndex);
		if (rd){
			FromIGAIndex = rd.get('IGAIndex');
			FromGeneID = FromIGAIndex.split('-')[0];
		}
		var ToGeneID = '';
		for (var rowIndex = obj.currRowIndex - 1; rowIndex > -1; rowIndex--) {
			var rd = obj.gridLnkArcim.getStore().getAt(rowIndex);
			if (rd){
				var ToIGAIndex = rd.get('IGAIndex');
				if (ToIGAIndex.split('-')[0] == FromGeneID) continue;
				ToGeneID = ToIGAIndex.split('-')[0];
				break;
			}
		}
		if (ToGeneID == ''){
			//ExtTool.alert("提示","不允许再向上移动!");
			return;
		}
		var ret = obj.ChangeArcimIGNo(FromGeneID,ToGeneID);
		if (ret == true){
			obj.gridLnkArcim.getStore().load({
				callback : function(o,response,success) {  
					if (success){
						var rowIndex = obj.gridLnkArcim.getStore().find('IGAIndex',FromIGAIndex);
						obj.gridLnkArcim.getSelectionModel().selectRow(rowIndex,true);
						obj.GridRowSelect(rowIndex);
					}  
				}
			});
		}
	}
	
	obj.btnMoveDown_click = function(){
		var FromGeneID = '',FromIGAIndex = '';
		var rd = obj.gridLnkArcim.getStore().getAt(obj.currRowIndex);
		if (rd){
			FromIGAIndex = rd.get('IGAIndex');
			FromGeneID = FromIGAIndex.split('-')[0];
		}
		var ToGeneID = '';
		for (var rowIndex = obj.currRowIndex + 1; rowIndex < obj.gridLnkArcim.getStore().getCount(); rowIndex++) {
			var rd = obj.gridLnkArcim.getStore().getAt(rowIndex);
			if (rd){
				var ToIGAIndex = rd.get('IGAIndex');
				if (ToIGAIndex.split('-')[0] == FromGeneID) continue;
				ToGeneID = ToIGAIndex.split('-')[0];
				break;
			}
		}
		if (ToGeneID == ''){
			//ExtTool.alert("提示","不允许再向下移动!");
			return;
		}
		var ret = obj.ChangeArcimIGNo(FromGeneID,ToGeneID);
		if (ret == true){
			obj.gridLnkArcim.getStore().load({
				callback : function(o,response,success) {  
					if (success){
						var rowIndex = obj.gridLnkArcim.getStore().find('IGAIndex',FromIGAIndex);
						obj.gridLnkArcim.getSelectionModel().selectRow(rowIndex,true);
						obj.GridRowSelect(rowIndex);
					}
				}
			});
		}
	}
	
	obj.ChangeArcimIGNo = function(FromGeneID,ToGeneID){
		if ((FromGeneID == '')||(ToGeneID == '')) return false;
		var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","ChangeIGNo",FromGeneID,ToGeneID);
		if (parseInt(ret)<1){
			ExtTool.alert("提示","向上、向下移动保存错误!");
			return false;
		} else {
			obj.currRowIndex = '';
		}
		return true;
	}
	
	obj.btnMerge_click = function(){
		var FromGeneID = '',FromGeneDesc = '';
		var rd = obj.gridLnkArcim.getStore().getAt(obj.currRowIndex);
		if (rd){
			var FromIGAIndex = rd.get('IGAIndex');
			FromGeneID = FromIGAIndex.split('-')[0];
			FromGeneDesc = rd.get('PHCGeneDesc');
		}
		var ToGeneID = '',ToGeneDesc = '';
		for (var rowIndex = obj.currRowIndex - 1; rowIndex > -1; rowIndex--) {
			var rd = obj.gridLnkArcim.getStore().getAt(rowIndex);
			if (rd){
				var ToIGAIndex = rd.get('IGAIndex');
				if (ToIGAIndex.split('-')[0] == FromGeneID) continue;
				ToGeneID =  ToIGAIndex.split('-')[0];
				ToGeneDesc = rd.get('PHCGeneDesc');
				break;
			}
		}
		if (ToGeneID == ''){
			//ExtTool.alert("提示","不允许合并医嘱!");
			return;
		}
		if (FromGeneDesc != ToGeneDesc){
			ExtTool.alert("提示","通用名不相同,不允许合并医嘱!");
			return;
		}
		
		var ret = obj.MergeArcimByGene(FromGeneID,ToGeneID);
		if (ret == true){
			obj.gridLnkArcim.getStore().load({
				callback : function(o,response,success) {
					if (success){
						var rowIndex = obj.gridLnkArcim.getStore().find('IGAIndex',FromIGAIndex);
						obj.gridLnkArcim.getSelectionModel().selectRow(rowIndex,true);
						obj.GridRowSelect(rowIndex);
					}
				}
			});
		}
	}
	
	obj.MergeArcimByGene = function(FromGeneID,ToGeneID){
		if ((FromGeneID == '')||(ToGeneID == '')) return false;
		var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","CheckMergeArcim",FromGeneID,ToGeneID);
		if (parseInt(ret)>0){
			ExtTool.alert("提示","存在重复的医嘱项,不允许合并医嘱!");
			return false;
		}
		
		var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","MergeArcim",FromGeneID,ToGeneID);
		if (parseInt(ret)<1){
			ExtTool.alert("提示","合并医嘱保存错误!");
			return false;
		} else {
			obj.currRowIndex = '';
		}
		return true;
	}
	
	obj.gridLnkArcim_cellclick = function(grid, rowIndex, columnIndex, e){
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		if ((fieldName != 'IGIsMain')
			&&(fieldName != 'IGADefault')
			&&(fieldName != 'IGAIsActive')){
			return;
		}
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		
		var IGAIndex = objRec.get('IGAIndex');
		var GeneID = IGAIndex.split('-')[0];
		var IGASub = IGAIndex.split('-')[1];
		if (fieldName == 'IGIsMain'){
			var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","UpdateIsMain",GeneID,newValue);
			if (parseInt(ret)<1){
				ExtTool.alert("提示","主医嘱设置错误!");
				return false;
			} else {
				//obj.currRowIndex = '';
				obj.gridLnkArcim.getStore().load({
					callback : function(o,response,success) {
						if (success){
							var rowIndex = obj.gridLnkArcim.getStore().find('IGAIndex',IGAIndex);
							obj.gridLnkArcim.getSelectionModel().selectRow(rowIndex,true);
							obj.GridRowSelect(rowIndex);
						}
					}
				});
			}
		} else if (fieldName == 'IGADefault'){
			var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","UpdateIsDefault",GeneID,IGASub,newValue);
			if (parseInt(ret)<1){
				ExtTool.alert("提示","首选医嘱设置错误!");
				return false;
			} else {
				//obj.currRowIndex = '';
			}
			objRec.set(fieldName, newValue);
			grid.getStore().commitChanges();
			grid.getView().refresh();
		} else if (fieldName == 'IGAIsActive'){
			var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","UpdateIsActive",GeneID,IGASub,newValue);
			if (parseInt(ret)<1){
				ExtTool.alert("提示","是否有效设置错误!");
				return false;
			} else {
				//obj.currRowIndex = '';
			}
			objRec.set(fieldName, newValue);
			grid.getStore().commitChanges();
			grid.getView().refresh();
		}
		return true;
	}
}
