function InitReceiptPageEvent(obj){
	obj.LoadEvents = function(){
		obj.btnReceipt.on('click',obj.btnReceipt_click,obj);
		obj.btnCancel.on('click',obj.btnCancel_click,obj);
		obj.cboMrType.on('select',obj.cboMrType_select,obj);
		obj.cboNoType.on('select',obj.cboNoType_select,obj);
		obj.txtMrNo.on('specialkey',obj.txtMrNo_specialkey,obj);
		
		obj.cboMrTypeStore.load({
			callback : function(r){
				for (var row = 0; row < r.length; row++){
					var objRec = r[row];
					if (objRec.get("IsDefault") == '1'){
						Common_SetValue('cboMrType',objRec.get('MrTypeID'),objRec.get('MrTypeDesc'));
						Common_SetValue('cboNoType',objRec.get('NoTypeID'),objRec.get('NoTypeDesc'));
					}
				}
			}
		});
		
		if (typeof(window.opener) == 'undefined') window.opener = window.dialogArguments;
	}
	
	obj.cboMrType_select = function(cb,r,num){
		Common_SetValue('cboMrType',r.get('MrTypeID'),r.get('MrTypeDesc'));
		Common_SetValue('cboNoType',r.get('NoTypeID'),r.get('NoTypeDesc'));
	}
	
	obj.cboNoType_select = function(cb,r,num){
		Common_SetValue('cboMrType',r.get('MrTypeID'),r.get('MrTypeDesc'));
		Common_SetValue('cboNoType',r.get('NoTypeID'),r.get('NoTypeDesc'));
	}
	
	obj.txtMrNo_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) {
			return;
		}
		var MrNo = Common_GetValue("txtMrNo");
		if (MrNo != '')	obj.btnReceipt.focus();
	}
	
	obj.btnReceipt_click = function(){
		var NoTypeID = Common_GetValue("cboNoType");
		if (NoTypeID == ''){
			alert('请选择病案类型!');
			return;
		}
		var MrTypeID = NoTypeID.split('||')[0];
		var MrNo = Common_GetValue("txtMrNo");
		var LogonLocID=session['LOGON.CTLOCID'];
		var LogonUserID=session['LOGON.USERID'];
		
		//HN 手工输入病案号方式接诊,HT 手工选择号码类型方式接诊
		if ((ReceiptType == 'HN')&&(MrNo == '')){
			alert('请输入病案号!');
			obj.txtMrNo.focus();
			return;
		}
		
		//检查病案号格式
		if (MrNo != ''){
			var result = tkMakeServerCall("DHCWMR.SSService.ReceiptSrv","CheckMrNoInput",NoTypeID,MrNo);
			var err = result.split('^')[0];
			if ((err*1)<1){
				alert('病案号格式错误！错误代码：' + err);
				return;
			}
			MrNo = result.split('^')[1];
		}
		
		//病案接诊
		var result = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GroupReceipt',EpisodeID,MrNo,LogonLocID,LogonUserID,NoTypeID);
		var err = result.split('^')[0];
		if ((err*1)<1){
			alert(result.split('^')[1]+'！错误代码：' + err);
			return;
		} else {
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^接诊成功^' + VolumeID + '^' + MrNo;
		}
		
		//窗口返回值
		window.returnValue = result;
		if (window.opener && window.opener != null){
			window.opener.ReturnValue = result;
		}
		window.close();
	}
	
	obj.btnCancel_click = function(){
		//窗口返回值
		window.returnValue = '';
		if (window.opener && window.opener != null){
			window.opener.ReturnValue = '';
		}
		window.close();
	}
}