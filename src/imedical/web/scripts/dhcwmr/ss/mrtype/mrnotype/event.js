function InitMrNoTypeEvent(obj){
	obj.LoadEvents = function(){
		obj.btnSaveNoType.on('click',obj.btnSaveNoType_click,obj);
		obj.gridNoType.on('rowclick',obj.gridNoType_rowclick,obj);
	}
	
	obj.CheckNoHead = function(value)
	{
		var strExp=/^[A-Z]+$/;
        if(strExp.test(value)){
			return    true;
		}else{
			return   false;
		}
	}

	obj.btnSaveNoType_click = function(){
		var flag = 0;
		obj.gridNoTypeStore.each(function(r){
			if ((r.get('IsDefault')==1)&&(r.get('ID')!=obj.NoTypeID)) flag =1
		});
		
		var errinfo = ""
		var Separate = String.fromCharCode(1);
		var NoTypeID = obj.NoTypeID;
		if (NoTypeID == ""){
			var ChildSub = "";
		} else {
			var ChildSub = NoTypeID.split("||")[1];
		}
		var NTCode=obj.txtNTCode.getValue();
		if (!NTCode){
			errinfo = errinfo + "代码为空!<br>";
		}
		var NTDesc=obj.txtNTDesc.getValue();
		if (!NTDesc){
			errinfo = errinfo + "描述为空!<br>";
		}
		var NTNoLen=obj.txtNTNoLen.getValue();
		var NTNoHead=obj.txtNTNoHead.getValue();
		if (NTNoHead)
		{
			var Headflag = obj.CheckNoHead(NTNoHead);
			if (!Headflag)
			{
				errinfo = errinfo + "类型标记只能是大写字母!<br>";
			}
		}
		
		var NTCurrNo=obj.txtNTCurrNo.getValue();
		
		if (!NTCurrNo){
			if (NTCurrNo=='0'){
				errinfo = errinfo + "当前号为0!<br>";
			}else{
				errinfo = errinfo + "当前号为空!<br>";
			}
		}

		var NTMaxNo=obj.txtNTMaxNo.getValue();
		var NTMinNo=obj.txtNTMinNo.getValue();
		if ((NTMaxNo!="")&&(NTMinNo!="")){
			if (NTMaxNo<NTMinNo){
				errinfo = errinfo + "最大号小于最小号!<br>";
			}
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		var NTIsDefault=obj.chkNTIsDefault.getValue();
		var NTIsActive=obj.chkNTIsActive.getValue();
		if ((flag ==1)&&(NTIsDefault)){
			ExtTool.alert("提示","已设置默认类型，不允许再次设置！");
			return;
		}
		var NTResume=obj.txtNTResume.getValue();
		var tmp = obj.MrTypeID + Separate;
			tmp += ChildSub + Separate;
			tmp += NTCode + Separate;
			tmp += NTDesc + Separate;
			tmp += NTNoLen + Separate;
			tmp += NTNoHead + Separate;
			tmp += NTCurrNo + Separate;
			tmp += NTMaxNo + Separate;
			tmp += NTMinNo + Separate;
			tmp += (NTIsDefault==true?1:0) + Separate;
			tmp += (NTIsActive==true?1:0) + Separate;
			tmp += NTResume + Separate;
		
		var ret = ExtTool.RunServerMethod("DHCWMR.SS.NoType","Update",tmp,Separate);
		if (ret<0){
			ExtTool.alert("提示","保存失败！");
			return;
		} else {
			ExtTool.alert("提示","保存成功！");
			obj.gridNoTypeStore.load({});
		}
	}
	
	obj.gridNoType_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.gridNoTypeStore.getAt(rowIndex);
		if (obj.NoTypeID == objRec.get("ID")){
			obj.NoTypeID = '';
			obj.txtNTCode.setValue("");
			obj.txtNTMaxNo.setValue("");
			obj.txtNTDesc.setValue("");
			obj.txtNTMinNo.setValue("");
			obj.txtNTNoLen.setValue("");
			obj.chkNTIsDefault.setValue(false);
			obj.txtNTNoHead.setValue("");
			obj.chkNTIsActive.setValue(false);
			obj.txtNTCurrNo.setValue("");
			obj.txtNTResume.setValue("");
		} else {
			obj.NoTypeID = objRec.get("ID");
			obj.txtNTCode.setValue(objRec.get("Code"));
			obj.txtNTMaxNo.setValue(objRec.get("MaxNo"));
			obj.txtNTDesc.setValue(objRec.get("Desc"));
			obj.txtNTMinNo.setValue(objRec.get("MinNo"));
			obj.txtNTNoLen.setValue(objRec.get("NoLen"));
			obj.chkNTIsDefault.setValue(objRec.get("IsDefault")==1);
			obj.txtNTNoHead.setValue(objRec.get("NoHead"));
			obj.chkNTIsActive.setValue(objRec.get("IsActive")==1);
			obj.txtNTCurrNo.setValue(objRec.get("CurrNo"));
			obj.txtNTResume.setValue(objRec.get("Resume"));
		}
	}
}

function DisplayMrNoTypeLinkWindow(RowIndex,CTHospIDs){
	var objRec = Ext.getCmp("gridNoType").store.getAt(RowIndex);
	var NTLWindow= new InitMrNoTypeLinkViewPort(objRec,CTHospIDs);
	NTLWindow.MrNoTypeLinkWindow.show();
}