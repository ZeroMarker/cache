function InitDMPaperNoEvent(DMPaperNo){
    DMPaperNo.LoadEvent=function(){
		DMPaperNo.ClsDTHPaperNo = ExtTool.StaticServerObject("DHCMed.DTH.PaperNo");
		DMPaperNo.ClsDTHPaperNoSrv = ExtTool.StaticServerObject("DHCMed.DTHService.PaperNoSrv");
        DMPaperNo.gridPaperNoStore.load({});
		DMPaperNo.BtnQuery.on("click",DMPaperNo.BtnQuery_click,DMPaperNo);	
		DMPaperNo.BtnStorage.on("click",DMPaperNo.BtnStorage_click,DMPaperNo);
		DMPaperNo.BtnDistri.on("click",DMPaperNo.BtnDistri_click,DMPaperNo);
		DMPaperNo.BtnDistriRepeat.on("click",DMPaperNo.BtnDistriRepeat_click,DMPaperNo);
    }
	DMPaperNo.BtnDistriRepeat_click = function(){
		var aStatus="2";
		var CtlocId=session['LOGON.CTLOCID'];
		var UserID=session['LOGON.USERID'];
		var arrList = DMPaperNo.sm.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("提示", "没有选中记录，不能重新分配!");
			return;
		}
		var LocId = Common_GetValue('CobLocId');
		if (LocId=="") {
			ExtTool.alert("提示", "没有选择分配科室，不能重新分配!");
			return;
		}
		Ext.MessageBox.confirm('提示', '确定重新分配？', function(btn){
			var str = new Array()
			if (btn=="yes") {
				for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
					var r = arrList[rowIndex];
					var PaperNo=r.get("PaperNo");
					var Status=r.get("Status");
					if(Status!="待用"){
						str[rowIndex] = "选中数据第"+(rowIndex+1)+"条不能重新分配！<br/>"
					}else{
						var separate="^";
						var updateStr=PaperNo+separate+aStatus+separate+LocId+separate+CtlocId+separate+UserID;
						var retValue = DMPaperNo.ClsDTHPaperNoSrv.ChangePaperNoStatus(updateStr);
						if(retValue<0){
							str[rowIndex] = "选中数据第"+(rowIndex+1)+"条重新分配失败！<br/>"
						}else{
							str[rowIndex] = "选中数据第"+(rowIndex+1)+"条重新分配成功！<br/>"
						}
					}
				}
				if(str.length>0){
					ExtTool.alert("提示", str.join(""));
				}
				Common_SetValue('CobLocId',"");
				DMPaperNo.gridPaperNoStore.load({});
			}
		});
	}
	DMPaperNo.BtnDistri_click = function(){
		var aStatus="2";
		var CtlocId=session['LOGON.CTLOCID'];
		var UserID=session['LOGON.USERID'];
		var arrList = DMPaperNo.sm.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("提示", "没有选中记录，不能分配!");
			return;
		}
		var LocId = Common_GetValue('CobLocId');
		if (LocId=="") {
			ExtTool.alert("提示", "没有选择分配科室，不能分配!");
			return;
		}
		Ext.MessageBox.confirm('提示', '确定分配？', function(btn){
			var str = new Array()
			if (btn=="yes") {
				for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
					var r = arrList[rowIndex];
					var PaperNo=r.get("PaperNo");
					var Status=r.get("Status");
					if(Status!="待用"){  //未分配
						str[rowIndex] = "选中数据第"+(rowIndex+1)+"条已分配！<br/>"
					}else{
						var separate="^";
						var updateStr=PaperNo+separate+aStatus+separate+LocId+separate+CtlocId+separate+UserID;
						var retValue = DMPaperNo.ClsDTHPaperNoSrv.ChangePaperNoStatus(updateStr);
						if(retValue<0){
							str[rowIndex] = "选中数据第"+(rowIndex+1)+"条分配失败！<br/>"
						}else{
							str[rowIndex] = "选中数据第"+(rowIndex+1)+"条分配成功！<br/>"
						}
					}
				}
				if(str.length>0){
					ExtTool.alert("提示", str.join(""));
				}
				Common_SetValue('CobLocId',"");
				DMPaperNo.gridPaperNoStore.load({});
			}
		});
	}
    DMPaperNo.BtnStorage_click=function(){
		var InitPopStorageWindow=new InitPopStorage(DMPaperNo);
		InitPopStorageWindow.mainWindow.show();
    }
    DMPaperNo.BtnQuery_click=function(){
		DMPaperNo.gridPaperNoStore.load({});
    }
}
function InitPopStorageEvent(dmPaperNoStatusObj){
    var parentForm = dmPaperNoStatusObj.ParentForm;
    dmPaperNoStatusObj.LoadEvent=function(){
    	dmPaperNoStatusObj.BtnSure.on("click", dmPaperNoStatusObj.BtnSure_click, dmPaperNoStatusObj);
		dmPaperNoStatusObj.Btnexit.on("click", dmPaperNoStatusObj.Btnexit_click, dmPaperNoStatusObj);
    }
    dmPaperNoStatusObj.BtnSure_click=function(){
		var patrn=/^[0-9]{1,7}$/;  //  一到七位数字
        var startNo=dmPaperNoStatusObj.TxtStartNo.getValue();
        if (startNo==""){
            alert("请输入开始编号");
            dmPaperNoStatusObj.TxtStartNo.focus();
            return;
        }
		if(!patrn.exec(startNo)){
			ExtTool.alert("提示","开始编号格式不正确，请输入1~7位数字");
			return;
		}
        var endNo=dmPaperNoStatusObj.TxtEndNo.getValue();
        if (endNo==""){
            alert("请输入结束编号");
            dmPaperNoStatusObj.TxtEndNo.focus();
            return;
        }
		if(!patrn.exec(endNo)){
			ExtTool.alert("提示","结束编号格式不正确，请输入1~7位数字");
			return;
		}
        if (parseInt(startNo)>parseInt(endNo)){
            alert("结束编号必须大于等于开始编号");
            dmPaperNoStatusObj.TxtEndNo.focus();
            return;
        }
		var separate="^";
		var CtlocId=session['LOGON.CTLOCID'];
		var UserID=session['LOGON.USERID'];

		var updateStr=startNo+separate+endNo+separate+CtlocId+separate+UserID;
		var retValue = parentForm.ClsDTHPaperNoSrv.ImportPaperNo(updateStr);
        dmPaperNoStatusObj.mainWindow.close();
        var mainResultWindow=new InitPopStorage(parentForm);
        while(retValue.indexOf(separate)>0)
        {
           retValue=retValue.replace(separate,'\r');
        }
		Common_SetValue('CobStatusId',"");
		Common_SetValue('CobLocId',"");
		dmPaperNoStatusObj.ParentForm.gridPaperNoStore.load({});
        mainResultWindow.resumeText.setValue(retValue);
        mainResultWindow.mainReultWindow.show();
    }
    dmPaperNoStatusObj.Btnexit_click=function(){
        dmPaperNoStatusObj.mainWindow.close();
    }
}