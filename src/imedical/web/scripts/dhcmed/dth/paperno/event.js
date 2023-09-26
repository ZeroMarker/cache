function InitPaperNoEvent(objPaperNo){
	var separate="^";
	var CtlocId=session['LOGON.CTLOCID'];
	var UserID=session['LOGON.USERID'];
	var StatusDR = 3;  //已用
	var IsActive=1;
	var Resume="";
	objPaperNo.LoadEvent = function(){
		objPaperNo.ClsDTHPaperNo = ExtTool.StaticServerObject("DHCMed.DTH.PaperNo");
		objPaperNo.ClsDTHPaperNoSrv = ExtTool.StaticServerObject("DHCMed.DTHService.PaperNoSrv");
		if ((SSHospCode=="11-DT")||(SSHospCode=="11-XH")){
			Common_SetValue('PaperNo',objPaperNo.ClsDTHPaperNoSrv.GetNewPaperNo());
			objPaperNo.PaperNo.setDisabled(true);
		}
		objPaperNo.saveBtn.on("click", objPaperNo.saveBtn_click, objPaperNo);
		objPaperNo.exitBtn.on("click", objPaperNo.exitBtn_click, objPaperNo);
	};
	objPaperNo.saveBtn_click = function(){
		var paperNo = objPaperNo.PaperNo.getValue();
		var retValue="";
		if ((SSHospCode=="11-DT")||(SSHospCode=="11-XH")){
			if (!paperNo){
				ExtTool.alert("提示","请联系统计室入库纸单号");
				return;
			}
			var updateStr=paperNo+separate+StatusDR+separate+CtlocId+separate+CtlocId+separate+UserID+separate+ReportID;
			retValue = objPaperNo.ClsDTHPaperNoSrv.ChangePaperNoStatus(updateStr);
		}else{
			var patrn=/^[0-9]{1,7}$/;
			if (!paperNo){
				ExtTool.alert("提示","纸单号不能为空");
				return;
			}
			if(!patrn.exec(paperNo)){
				ExtTool.alert("提示","纸单号格式不正确，请输入1~7位数字");
				return;
			}
			if (SSHospCode=="11-YY"){
				paperFlag = objPaperNo.ClsDTHPaperNoSrv.CheckPaperNo(paperNo,CtlocId);
			} else {
				paperFlag = objPaperNo.ClsDTHPaperNoSrv.CheckPaperNo(paperNo);
			}
			if (paperFlag=="0"){
				ExtTool.alert("提示","纸单号不存在");
				return;
			}else if(paperFlag=="1"){
				var updateStr=paperNo+separate+StatusDR+separate+CtlocId+separate+CtlocId+separate+UserID+separate+ReportID;
				retValue = objPaperNo.ClsDTHPaperNoSrv.ChangePaperNoStatus(updateStr);
			}else{
				ExtTool.alert("提示","纸单号已用");
				return;
			}
		}
		if ((retValue>-1)){
			Ext.Msg.alert("提示","保存成功!");
			window.close();
		}else{
			Ext.Msg.alert("提示","保存失败!");
		}
		parent.window.returnValue=retValue;
		
	};
	objPaperNo.exitBtn_click = function(){
		window.close();
	};
}
