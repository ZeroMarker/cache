
function InitICUStrAdmSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.ICUStrAdmSubGridPanelStore.load({});
		obj.ICUStrAdmSubGridPanel.on("rowdblclick", obj.ICUStrAdmSubGridPanel_rowdblclick, obj);
	};
	
	obj.ICUStrAdmSubGridPanel_rowdblclick = function(objGrid, rowIndex)
	{
		var record = objGrid.getStore().getAt(rowIndex);
		var Paadm = record.get("Paadm");
		var SubjectCode='INTCCS';
		var objDisplayWin = new InitPatientDtl(Paadm, SubjectCode);
		objDisplayWin.WinPatientDtl.show();
	}
}

function StrAdmLookUpHeader(SurveryDate,LocID)
{
	//alert(SurveryDate);
	//alert(LocID);
	var objInitICUStrAdmSubWindow = new InitICUStrAdmSubWindow(SurveryDate,LocID);
	objInitICUStrAdmSubWindow.ICUStrAdmSubWindow.show();
	var numTop=(document.body.clientHeight-objInitICUStrAdmSubWindow.ICUStrAdmSubWindow.height)/2;
	var numLeft=(document.body.clientWidth-objInitICUStrAdmSubWindow.ICUStrAdmSubWindow.width)/2;
	objInitICUStrAdmSubWindow.ICUStrAdmSubWindow.setPosition(numLeft,numTop);
	ExtDeignerHelper.HandleResize(objInitICUStrAdmSubWindow);
	
}