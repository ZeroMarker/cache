function OE_InitOEOrderEvent(obj){
	obj.OE_LoadEvent = function(){
		obj.OE_btnCancel.on("click",obj.OE_btnCancel_click,obj);
		obj.OE_btnSave.on("click",obj.OE_btnSave_click,obj);
		obj.OE_gridOEOrder.on("rowclick",obj.OE_gridOEOrder_rowclick,obj);
		obj.OE_gridOEOrder.on("cellclick",obj.OE_gridOEOrder_cellclick,obj);
		obj.OE_gridArcimSelect.on("rowdblclick",obj.OE_gridArcimSelect_rowdblclick,obj);
		obj.OE_gridOEOrderStore.load({});
	};
	
	obj.OE_gridOEOrder_rowclick = function(){
		obj.OE_gridArcimSelectStore.removeAll();
		var rowIndex=arguments[1];
		var rd = obj.OE_gridOEOrder.getStore().getAt(rowIndex);
		if (rd){
			obj.currRowIndex = rowIndex;
			obj.currArcimID = rd.get('IGAArcimDR');
			obj.OE_gridArcimSelectStore.load({});
		}
	}
	
	obj.OE_gridArcimSelect_rowdblclick = function(){
		var rowIndex=arguments[1];
		var rd = obj.OE_gridArcimSelect.getStore().getAt(rowIndex);
		if (rd){
			var ArcimID = rd.get('ArcimID');
			var arcimStr = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.LnkArcimSrv","GetArcimInfoById",ArcimID);
			if (arcimStr == '') return;
			var arcim=arcimStr.split("^");
			
			var objRec = obj.OE_gridOEOrder.getStore().getAt(obj.currRowIndex);
			if (arcim[1] == 'R'){
				objRec.set('IGAArcimDR', rd.get('ArcimID'));
				objRec.set('IGAArcimDesc', rd.get('ArcimDesc'));
				objRec.set('IGAPackQty', '');
				objRec.set('IGAFreqDR', rd.get('FreqDR'));
				objRec.set('IGAFreqDesc', rd.get('FreqDesc'));
				objRec.set('IGADuratDR', rd.get('DuratDR'));
				objRec.set('IGADuratDesc', rd.get('DuratDesc'));
				objRec.set('IGAInstrucDR', rd.get('InstrucDR'));
				objRec.set('IGAInstrucDesc', rd.get('InstrucDesc'));
				objRec.set('IsArcInci', '1');
				if ((objRec.get('PHCGeneDesc')!=rd.get('PHCGeneDesc'))
				||(objRec.get('PHCSpecDesc')!=rd.get('PHCSpecDesc'))
				||(objRec.get('PHCFormDesc')!=rd.get('PHCFormDesc'))
				||(objRec.get('IGADoseUomDesc')!=rd.get('DoseUomDesc'))){
					objRec.set('IGADoseQty', '');
					objRec.set('IGADoseUomDR', '');
					objRec.set('IGADoseUomDesc', '');
				}
			} else if (arcim[2] == '4'){
				objRec.set('IGAArcimDR', rd.get('ArcimID'));
				objRec.set('IGAArcimDesc', rd.get('ArcimDesc'));
				objRec.set('IGAPackQty', '');
				objRec.set('IGAFreqDR', rd.get('FreqDR'));
				objRec.set('IGAFreqDesc', rd.get('FreqDesc'));
				objRec.set('IGADuratDR', '');
				objRec.set('IGADuratDesc', '');
				objRec.set('IGAInstrucDR', rd.get('InstrucDR'));
				objRec.set('IGAInstrucDesc', rd.get('InstrucDesc'));
				objRec.set('IGADoseQty', '');
				objRec.set('IGADoseUomDR', '');
				objRec.set('IGADoseUomDesc', '');
				objRec.set('IsArcInci', '1');
			} else {
				objRec.set('IGAArcimDR', rd.get('ArcimID'));
				objRec.set('IGAArcimDesc', rd.get('ArcimDesc'));
				objRec.set('IGAPackQty', '');
				objRec.set('IGAFreqDR', '');
				objRec.set('IGAFreqDesc', '');
				objRec.set('IGADuratDR', '');
				objRec.set('IGADuratDesc', '');
				objRec.set('IGAInstrucDR', '');
				objRec.set('IGAInstrucDesc', '');
				objRec.set('IGADoseQty', '');
				objRec.set('IGADoseUomDR', '');
				objRec.set('IGADoseUomDesc', '');
				objRec.set('IsArcInci', '1');
			}
			obj.OE_gridOEOrder.getStore().commitChanges();
			obj.OE_gridOEOrder.getView().refresh();
		}
	}
	
	obj.OE_gridOEOrder_cellclick = function(grid, rowIndex, columnIndex, e){
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		if (fieldName != 'IsChecked') return;
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		if (objRec.get('IsArcInci')!='1'){
			var newValue = '0';
		}
		
		if (fieldName == 'IsChecked'){
			objRec.set(fieldName, newValue);
			grid.getStore().commitChanges();
			//同一通用名记录下只允许选择一条医嘱
			if (newValue == '1'){
				var currIGAIndex = objRec.get('IGAIndex');
				for (var indArc = 0; indArc < grid.getStore().getCount(); indArc++){
					var rd = grid.getStore().getAt(indArc);
					var tmpIGAIndex = rd.get('IGAIndex');
					if (currIGAIndex == tmpIGAIndex) continue;
					if (currIGAIndex.split('-')[0]!=tmpIGAIndex.split('-')[0]) continue;
					rd.set(fieldName, '0');
					grid.getStore().commitChanges();
				}
			}
			grid.getView().refresh();
		}
		return true;
	}
	
	obj.OE_btnSave_click = function(){
		var strOrderList = '';
		var objStore = obj.OE_gridOEOrder.getStore();
		for (var rowIndex = 0; rowIndex < objStore.getCount(); rowIndex++){
			var rd = objStore.getAt(rowIndex);
			if (rd.get('IsChecked') != '1') continue;
			
			var IGAIndex = rd.get('IGAIndex');
			var GeneID = IGAIndex.split('-')[0];
			
			var strOrder = GeneID;
			strOrder += '^' + rd.get('IGAArcimDR');
			strOrder += '^' + rd.get('IGPriority');
			strOrder += '^' + rd.get('IGAPackQty');
			strOrder += '^' + rd.get('IGADoseQty');
			strOrder += '^' + rd.get('IGADoseUomDR');
			strOrder += '^' + rd.get('IGAFreqDR');
			strOrder += '^' + rd.get('IGADuratDR');
			strOrder += '^' + rd.get('IGAInstrucDR');
			strOrder += '^' + rd.get('IGAResume');
			strOrder += '^' + rd.get('OrderSeqNo');
			
			strOrderList +=  CHR_1 + strOrder;
		}
		if (strOrderList == ''){
			ExtTool.alert("提示","未选中医嘱!");
	  		return false;
		}
		
		//关闭当前窗口
		obj.OE_WinOEOrder.close();
		
		var ifrmDocOrderEntry = document.getElementById("docOrderEntry");
		if (typeof ifrmDocOrderEntry.contentWindow.addOEORIByCPW =="function"){
			ifrmDocOrderEntry.contentWindow.addOEORIByCPW(strOrderList);
		}else{
			var frameOrderEntry = ifrmDocOrderEntry.contentWindow.frames["oeorder_entry"];
			if (frameOrderEntry){
				//update by zf 医嘱录入页面增加了frame层级 20180726
				var ifrmOrdEntryFrame = frameOrderEntry.frames["OrdEntryFrame"];
				if (ifrmOrdEntryFrame){
					if (typeof ifrmOrdEntryFrame.window.addOEORIByCPW =="function") {
						ifrmOrdEntryFrame.addOEORIByCPW(strOrderList);
					}
				} else {
					if (typeof frameOrderEntry.window.addOEORIByCPW =="function") {
						frameOrderEntry.addOEORIByCPW(strOrderList);
					}
				}
			} else {
				var ifrmOrderEntrySub = ifrmDocOrderEntry.contentWindow.document.getElementById("OrderEdit");
				if (typeof ifrmOrderEntrySub.contentWindow.addOEORIByCPW =="function"){
					ifrmOrderEntrySub.contentWindow.addOEORIByCPW(strOrderList);
				} else {
					alert("医嘱录入模块升级导致结构变化,请调整!");
				}
			}
		}
	}
	
	obj.OE_btnCancel_click = function(){
		obj.OE_WinOEOrder.close();
	}
}