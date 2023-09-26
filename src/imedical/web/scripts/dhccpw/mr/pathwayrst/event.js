function InitPathWayRstWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.LoadPathWayRstInfo();
		obj.btnUpdate.on("click", obj.btnUpdate_OnClick, obj);
	};
	obj.LoadPathWayRstInfo = function(){
		if (obj.PathWayID){
			var objPathWayRst = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysResult");
			var objBaseDic = ExtTool.StaticServerObject("web.DHCCPW.MRC.BaseDictionary");
			var ZZGSStr=objBaseDic.GetBySubCateg("XZZGS",obj.PathWayID);
			var TZGSStr=objBaseDic.GetBySubCateg("XTZGS",obj.PathWayID);
			var LHZBStr=objBaseDic.GetBySubCateg("XLHZB",obj.PathWayID);
			var ZGQKStr=objBaseDic.GetBySubCateg("YZGQK","");
			var strPathWayRst=objPathWayRst.GetStrByPathWayID(obj.PathWayID);
			if (strPathWayRst){
				var tmpList=strPathWayRst.split(String.fromCharCode(1));
				obj.CurrRstID=tmpList[0];
				var strList,strSubList,objRecord;
				if (ZZGSStr!=='') {
					strList=ZZGSStr.split(String.fromCharCode(1));
					for (var ind=0;ind<strList.length;ind++) {
						strSubList=strList[ind].split(String.fromCharCode(2));
						objRecord = new Ext.data.Record({
							DicID : strSubList[0]
							,DicCode : strSubList[1]
							,DicDesc : strSubList[2]
						});
						obj.cboZZGS.store.add(objRecord);
					}
				}
				var tmpSubList=tmpList[1].split(String.fromCharCode(2));
				obj.cboZZGS.setValue(tmpSubList[0]);
				obj.cboZZGS.setRawValue(tmpSubList[1]);
				
				if (TZGSStr!=='') {
					strList=TZGSStr.split(String.fromCharCode(1));
					for (var ind=0;ind<strList.length;ind++) {
						strSubList=strList[ind].split(String.fromCharCode(2));
						objRecord = new Ext.data.Record({
							DicID : strSubList[0]
							,DicCode : strSubList[1]
							,DicDesc : strSubList[2]
						});
						obj.cboTZGS.store.add(objRecord);
					}
					
				}
				var tmpSubList=tmpList[2].split(String.fromCharCode(2));
				obj.cboTZGS.setValue(tmpSubList[0]);
				obj.cboTZGS.setRawValue(tmpSubList[1]);
				
				if (LHZBStr!=='') {
					strList=LHZBStr.split(String.fromCharCode(1));
					for (var ind=0;ind<strList.length;ind++) {
						strSubList=strList[ind].split(String.fromCharCode(2));
						objRecord = new Ext.data.Record({
							DicID : strSubList[0]
							,DicCode : strSubList[1]
							,DicDesc : strSubList[2]
						});
						obj.cboLHZB.store.add(objRecord);
					}
				}
				var tmpSubList=tmpList[3].split(String.fromCharCode(2));
				obj.cboLHZB.setValue(tmpSubList[0]);
				obj.cboLHZB.setRawValue(tmpSubList[1]);
				
				if (ZGQKStr!=='') {
					strList=ZGQKStr.split(String.fromCharCode(1));
					for (var ind=0;ind<strList.length;ind++) {
						strSubList=strList[ind].split(String.fromCharCode(2));
						objRecord = new Ext.data.Record({
							DicID : strSubList[0]
							,DicCode : strSubList[1]
							,DicDesc : strSubList[2]
						});
						obj.cboZGQK.store.add(objRecord);
					}
				}
				var tmpSubList=tmpList[4].split(String.fromCharCode(2))
				obj.cboZGQK.setValue(tmpSubList[0]);
				obj.cboZGQK.setRawValue(tmpSubList[1]);
				
				obj.txtResume.setValue(tmpList[8]);
			}
		}
	}
	obj.btnUpdate_OnClick = function(){
		var ZZGSDR="",TZGSDR="",LHZBDR="",ZGQKDR="",ResumeText="",ErrInfo="";
		if ((obj.cboZZGS.getValue()!=='')&&(obj.cboZZGS.getRawValue()!=='')){
			ZZGSDR=obj.cboZZGS.getValue();
		}
		if ((obj.cboTZGS.getValue()!=='')&&(obj.cboTZGS.getRawValue()!=='')){
			TZGSDR=obj.cboTZGS.getValue();
		}
		if ((obj.cboLHZB.getValue()!=='')&&(obj.cboLHZB.getRawValue()!=='')){
			LHZBDR=obj.cboLHZB.getValue();
		}
		if ((obj.cboZGQK.getValue()!=='')&&(obj.cboZGQK.getRawValue()!=='')){
			ZGQKDR=obj.cboZGQK.getValue();
		}
		ResumeText=obj.txtResume.getValue();
		if (!ZZGSDR){
			ErrInfo = ErrInfo + "请选择症状改善,症状改善不允许为空!";
		}
		if (!TZGSDR){
			ErrInfo = ErrInfo + "请选择体征改善,体征改善不允许为空!";
		}
		if (!LHZBDR){
			ErrInfo = ErrInfo + "请选择理化指标,理化指标不允许为空!";
		}
		if (!ZGQKDR){
			ErrInfo = ErrInfo + "请选择转归情况,转归情况不允许为空!";
		}
		if (ErrInfo) {
			alert(ErrInfo);
			return;
		}
		if (obj.CurrRstID){
			var InputStr=obj.CurrRstID;
		}else{
			var InputStr=obj.PathWayID;
		}
		InputStr=InputStr + "^" + ZZGSDR;
		InputStr=InputStr + "^" + TZGSDR;
		InputStr=InputStr + "^" + LHZBDR;
		InputStr=InputStr + "^" + ZGQKDR;
		InputStr=InputStr + "^" + obj.UserID;
		InputStr=InputStr + "^" + ResumeText;
		var objPathWayRst = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysResult");
		var ret=objPathWayRst.Update(InputStr);
		if (ret<0){
			ExtTool.alert("提示","出径失败!",Ext.MessageBox.ERROR);
		}else{
			Ext.getCmp("PathWayRstWindow").close();
			if (obj.WinParent) {
				if (obj.WinParent.InitForm){
					obj.WinParent.InitForm();
				}
			}
		}
	}
}

function PathWayRstHeader(WinParent,PathWayID,UserID)
{
	var objPathWayRstWindow = new InitPathWayRstWindow(WinParent,PathWayID,UserID);
	objPathWayRstWindow.PathWayRstWindow.show();
	var numTop=(screen.availHeight-objPathWayRstWindow.PathWayRstWindow.height)/2;
	var numLeft=(screen.availWidth-objPathWayRstWindow.PathWayRstWindow.width)/2;
	objPathWayRstWindow.PathWayRstWindow.setPosition(numLeft,numTop);
	ExtDeignerHelper.HandleResize(objPathWayRstWindow);
}