function InitViewPortEvent(obj) {
	objRepManage = ExtTool.StaticServerObject("DHCMed.EPD.ReferralRep");
	obj.LoadEvent = function(args)
    {
		obj.btnSave.on("click",obj.btnSave_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnCheck.on("click",obj.btnCheck_click,obj);
		obj.btnExport.on("click",obj.btnExport_click,obj);
		obj.btnPrint.on("click",obj.btnPrint_click,obj);
		obj.btnCancle.on("click",obj.btnCancle_click,obj);
		
		obj.DisplayRepInfo();
		obj.InitRepPowerByStatus(obj.ReportID);
  	};
	
	//��ʾ��ť����Ȩ�� ���ݱ���״̬�����Ȩ�޿���
	obj.InitRepPowerByStatus = function(ReportID){	
		Common_SetVisible("btnSave",false);
		Common_SetVisible("btnPrint",false);
		Common_SetVisible("btnExport",false);
		Common_SetVisible("btnDelete",false);
		Common_SetVisible("btnCheck",false);
		Common_SetVisible("btnCancle",false);
		obj.RepStatusCode=objRepManage.GetRepStatus(ReportID);
     	switch (obj.RepStatusCode) {
			case "" : // �ޱ��� ֻ���ϱ�
				Common_SetVisible("btnSave",true);
				Common_SetVisible("btnCancle",true);
				break;
			case "1" : // ����
				obj.btnSave.setText("�޸�");
				Common_SetVisible("btnSave",true);
				Common_SetVisible("btnDelete",true);
				Common_SetVisible("btnCheck",true);
				Common_SetVisible("btnExport",true);
				Common_SetVisible("btnPrint",true);
				Common_SetVisible("btnCancle",true);
				break;
			case "2" : // ���
				Common_SetVisible("btnPrint",true);
				Common_SetVisible("btnExport",true);
				Common_SetVisible("btnCancle",true);
				break;
			case "3" : // ɾ��
				Common_SetVisible("btnCancle",true);
				break;
		}
		
		if (tDHCMedMenuOper['Check']!=1) {
			Common_SetVisible("btnCheck",false);
		}
	}
	
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			var strInfo=objRepManage.GetInfoByEPD(EpisodeID);
			var arrInfo=strInfo.split("^");
			Common_SetValue("txtPatName",arrInfo[0]);
			Common_SetValue("txtPatSex",arrInfo[1]);
			Common_SetValue("txtPatAge",arrInfo[2]);
			Common_SetValue("txtPatMrNo",arrInfo[3]);
			Common_SetValue("txtPatAddress",arrInfo[4]);
			Common_SetValue("txtPatPhoneNo",arrInfo[5]);
			Common_SetValue("txtFamilyName",arrInfo[6]);
			Common_SetValue("txtWorkAddress",arrInfo[7]);
		}else{
			var strRep=objRepManage.GetStringById(obj.ReportID);
			var arrRep=strRep.split("^");
			Common_SetValue("txtPatName",arrRep[0]);
			Common_SetValue("txtPatSex",arrRep[1]);
			Common_SetValue("txtPatAge",arrRep[2]);
			Common_SetValue("txtPatMrNo",arrRep[3]);
			Common_SetValue("txtPatAddress",arrRep[4]);
			Common_SetValue("txtPatPhoneNo",arrRep[5]);
			Common_SetValue("txtFamilyName",arrRep[6]);
			Common_SetValue("txtWorkAddress",arrRep[7]);
			Common_SetValue("cboReferralReason","",arrRep[8]);
			Common_SetValue("txtReferralHosp",arrRep[9]);
			Common_SetValue("txtReferralDoc",arrRep[10]);
			Common_SetValue("txtReferralDate",arrRep[11]);
			Common_SetValue("txtReferralAdd",arrRep[12]);
			Common_SetValue("txtReferralPhone",arrRep[13]);
		}
	};
	
	obj.GetRepData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+Common_GetValue("txtPatName");
		InputStr=InputStr+"^"+Common_GetValue("txtPatSex");
		InputStr=InputStr+"^"+Common_GetValue("txtPatAge");
		InputStr=InputStr+"^"+Common_GetValue("txtPatMrNo");
		InputStr=InputStr+"^"+Common_GetValue("txtPatAddress");
		InputStr=InputStr+"^"+Common_GetValue("txtPatPhoneNo");
		InputStr=InputStr+"^"+Common_GetValue("txtFamilyName");
		InputStr=InputStr+"^"+Common_GetValue("txtWorkAddress");
		InputStr=InputStr+"^"+Common_GetText("cboReferralReason");
		InputStr=InputStr+"^"+Common_GetValue("txtReferralHosp");
		InputStr=InputStr+"^"+Common_GetValue("txtReferralDoc");
		InputStr=InputStr+"^"+Common_GetText("txtReferralDate");
		InputStr=InputStr+"^"+Common_GetValue("txtReferralAdd");
		InputStr=InputStr+"^"+Common_GetText("txtReferralPhone");
		InputStr=InputStr+"^"+EpisodeID;
		return InputStr;
	}
	
	
	obj.btnSave_click = function(){
		var RepData=obj.GetRepData();
		RepData=RepData+"^"+1+"^"+session['LOGON.USERID'];
		
		var ret=objRepManage.Update(RepData,"^");
		if(parseInt(ret)<=0){
			ExtTool.alert("����","���ݱ������!"+ret);
			return;
		}else{
			ExtTool.alert("��ʾ","���ݱ���ɹ�!");
			obj.ReportID=ret;
		}
	};
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("����","��δ�ϱ�!");
			return;
		}
		Ext.MessageBox.confirm("��ʾ","��ȷ���Ƿ�ɾ��?",function(btn){
			if(btn=="yes"){
				var DeleteStr=obj.ReportID;
				DeleteStr=DeleteStr+"^"+3
				var ret=objRepManage.ChangeReport(DeleteStr,"^");
				if(parseInt(ret)<=0){
					ExtTool.alert("����","ɾ��ʧ��!"+ret);
					return;
				}else{
					ExtTool.alert("��ʾ","����ɾ���ɹ�!");
				}
			}
		});
	};
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("����","���������ϱ�������");
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+2
		var ret=objRepManage.ChangeReport(CheckStr,"^");
		if(parseInt(ret)<=0){
			ExtTool.alert("����","�������ʧ��!"+ret);
			return;
		}else{
			ExtTool.alert("��ʾ","������˳ɹ�!");
		}
	};
	obj.btnExport_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("����","���������ϱ�������");
			return;
		}
		
		var cArguments=obj.ReportID;
		var flg=ExportDataToExcel("","","�ν�˲���ת�ﵥ("+Common_GetValue("txtPatName")+")",cArguments);
		
	};
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("����","���������ϱ�������");
			return;
		}
		
		var cArguments=obj.ReportID;
		debugger;
		var flg=PrintDataToExcel("","","�ν�˲���ת�ﵥ("+Common_GetValue("txtPatName")+")",cArguments);
		
	};
	obj.btnCancle_click = function(){
		window.close();
	};
}	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             