
function CopyLinkArcimEvent(obj){
	obj.LoadEvent = function(args)
	{
		obj.btnAdd.on('click',obj.btnAdd_OnClick,obj);
		obj.chkSelectAll.on("check", obj.chkSelectAll_check, obj);
	}
	obj.btnAdd_OnClick = function(){
		var stepItemServer = ExtTool.StaticServerObject("DHCCPW.MRC.FORM.LnkArcimSrv");
		var objStore=obj.PathWaysARCIMGrid.getStore();
		
		var myArray=new Array()
		for (var rowIndex=0; rowIndex<objStore.getCount();rowIndex++ )
		{
			var rd=objStore.getAt(rowIndex);
			var IsChecked=rd.get("checked");
			if (IsChecked)
			{
				var IGSub=""
				var IGASub=""
				var IGNo = "";
				var tIGNo = rd.get('IGNo');
				var IsDefault = rd.get('IGADefault');
				var IsActive = rd.get('IGAIsActive');
				var IsMain = rd.get('IGIsMain');
				
				var PriorityID = rd.get('IGPriority');
				var tLinkNo = rd.get('IGLinkNo');
				var ArcimID = rd.get('IGAArcimDR');
				var DoseQty = rd.get('IGADoseQty');
				var DoseUomID = rd.get('IGADoseUomDR');
				var FreqID = rd.get('IGAFreqDR');
				var InstrucID = rd.get('IGAInstrucDR');
				var DurationID = rd.get('IGADuratDR');
				var PackQty = rd.get('IGAPackQty');
				var IsMain = rd.get('IGIsMain');
				var ItmResume = rd.get('IGAResume');
				
				if (myArray[tLinkNo]!=undefined) tLinkNo=myArray[tLinkNo];
				
				var inputStr = obj.FormItemID
					+ '^' + IGSub
					+ '^' + IGASub
					+ '^' + IGNo 
					+ '^' + PriorityID  
					+ '^' + tLinkNo
					+ '^' + IsMain
					+ '^' + ArcimID
					+ '^' + DoseQty
					+ '^' + DoseUomID
					+ '^' + FreqID
					+ '^' + InstrucID
					+ '^' + DurationID
					+ '^' + PackQty
					+ '^' + IsDefault
					+ '^' + IsActive
					+ '^' + ItmResume
					+ '^' + session['LOGON.USERID']
				
				try{
					var ret = stepItemServer.SaveLnkArcim(inputStr);
					if(ret<0) {
						//ExtTool.alert("提示","可选医嘱项添加失败!");
						continue;
					}else{
						myArray[tIGNo]=ret
						
					}
				}catch(err){
					ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
					return;
				}
			}
		}
		obj.CopyLinkArcimWindow.close();
		obj.obj2.gridLnkArcimStore.load();
	}
	
	obj.chkSelectAll_check = function()
	{
		var objStore = obj.PathWaysARCIMGrid.getStore();
		if (objStore.getCount() < 1){
			return;
		}
		
		var isCheck = obj.chkSelectAll.getValue();
		for (var row = 0; row < objStore.getCount(); row++){
			objStore.getAt(row).set('checked', isCheck);
		}
		obj.PathWaysARCIMGrid.getStore().commitChanges();
		obj.PathWaysARCIMGrid.getView().refresh();
	}
}

function CopyLinkArcimLookUpHeader(CPWID,CPWItemID,obj2,FormItemID)
{
	var objWin = new CopyLinkArcim(CPWID,CPWItemID,obj2,FormItemID);
	objWin.CopyLinkArcimWindow.show();
	//var numTop=(screen.availHeight-objWin.CopyLinkArcimWindow.height)/2;
	//var numLeft=(screen.availWidth-objWin.CopyLinkArcimWindow.width)/2;
	//objWin.CopyLinkArcimWindow.setPosition(numLeft,numTop);
	//ExtDeignerHelper.HandleResize(objWin);
}