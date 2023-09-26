function InitEditViewportEvents(obj){
	obj.LoadEvents = function(){
		obj.btnBook.on('click',obj.btnBook_click,obj);
		obj.btnCancel.on('click',obj.btnCancel_click,obj);
		obj.btnCharge.on('click',obj.btnCharge_click,obj);
		obj.btnRetFee.on('click',obj.btnRetFee_click,obj);
		obj.InitBtn();
		obj.LoadData();
	}
	
	obj.InitBtn = function(){
		obj.btnBook.setVisible(false);
		obj.btnCancel.setVisible(false);
		obj.btnCharge.setVisible(false);
		obj.btnRetFee.setVisible(false);
		
		var Status = obj.VC_Input.StatusCode
		
		if ((Status=="RE")||(Status=="BO")) {
			obj.btnBook.setVisible(tDHCWMRMenuOper['BO']);
			obj.btnCancel.setVisible(tDHCWMRMenuOper['U']);
		}
		if ((Status=="BO")||(Status=="RF")){
			obj.btnCharge.setVisible(tDHCWMRMenuOper['CH']);
		}
		if (Status=="CH"){
			obj.btnRetFee.setVisible(tDHCWMRMenuOper['CH']);
		}
	}
	
	obj.LoadData = function (){
		var CopyRecordID = obj.VC_Input.RecordID;
		if (CopyRecordID=="") return "";
		Common_SetValue("ClientName",obj.VC_Input.ClientName);
		Common_SetValue("txtPersonalID",obj.VC_Input.PersonalID);
		Common_SetValue("cboClientRelation",obj.VC_Input.RelationID,obj.VC_Input.RelationDesc);
		Common_SetValue("txtTelephone",obj.VC_Input.Telephone);
		Common_SetValue("cboCardType",obj.VC_Input.CardTypeID,obj.VC_Input.CardTypeDesc);
		Common_SetValue("txtAddress",obj.VC_Input.Address);
		Common_SetValue('cbgPurpose',obj.VC_Input.PurposeIDs);
		Common_SetValue('cbgContent',obj.VC_Input.ContentIDs);
		Common_SetValue("txtNote",obj.VC_Input.Resume);
		Common_SetValue("txtPaperNumber",obj.VC_Input.PaperNumber);
		
		//ȡ�����շ���Ŀ����
		if (obj.VC_Input.CopyMoney != 0) {
			Common_SetValue('txtCopyPrice',"��ӡ���ã�" + obj.VC_Input.CopyMoney + 'Ԫ');
		} else {
			var MrTypeID = obj.VC_Input.MrTypeID;
			var unitPrice = ExtTool.RunServerMethod("DHCWMR.MF.FeeItem","GetTariPrice","FY",MrTypeID,CTHospID);
			var PaperNumber = obj.VC_Input.PaperNumber;
			if (PaperNumber != 0){
				var Price = Math.round(unitPrice*PaperNumber*100)/100;		//���ñ���С�������λ
				Common_SetValue('txtCopyPrice',"��ӡ���ã�" + Price + 'Ԫ');
			} else {
				Common_SetValue('txtCopyPrice','');
			}
		}
	}
	
	obj.btnBook_click = function(){
		var Error = '';
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID			= Common_GetValue('cboHospital');
		var CopyRecordID	= obj.VC_Input.RecordID;
		var PaperNumber		= Common_GetValue("txtPaperNumber");
		if (PaperNumber==''){
			Error = Error + '��ӡҳ��Ϊ�գ�';
		}
		if (Error)
		{
			ExtTool.alert("��ʾ",Error);
			return;
		}

		var FeeInfo ="";									//֧����ʽ
			FeeInfo += '^'+User;							//����Ա
			FeeInfo += '^'+Loc;								//��½����
			FeeInfo += '^'+GroupID;							//��½��ȫ��
			FeeInfo += '^'+HospID;							//��½ҽԺ	

		var CopyInfo = CopyRecordID;						//�Ǽ�ID
			CopyInfo += '^' + PaperNumber;					//��ӡ����

		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","BO",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("������ʾ","װ��ʧ��!");
			return;
		}else{
			obj.EditViewport.close();
			Common_LoadCurrPage('gridCopy',1);
		}
	}
	
	obj.btnCancel_click = function(){
	    var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = Common_GetValue('cboHospital');
		var CopyInfo = obj.VC_Input.RecordID;				//�Ǽ�ID
		
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//֧����ʽ
			FeeInfo += '^'+User;							//����Ա
			FeeInfo += '^'+Loc;								//��½����
			FeeInfo += '^'+GroupID;							//��½��ȫ��
			FeeInfo += '^'+HospID;							//��½ҽԺ
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","U",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("������ʾ","����ʧ��!");
			return;
		}else{
			obj.EditViewport.close();
			Common_LoadCurrPage('gridCopy',1);
		}
	}
	
	obj.btnCharge_click = function(){
		var CopyRecordID = obj.VC_Input.RecordID;
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = Common_GetValue('cboHospital');
		var CopyInfo = CopyRecordID;						//�Ǽ�ID
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//֧����ʽ
			FeeInfo += '^'+User;							//����Ա
			FeeInfo += '^'+Loc;								//��½����
			FeeInfo += '^'+GroupID;							//��½��ȫ��
			FeeInfo += '^'+HospID;							//��½ҽԺ
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","CH",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("������ʾ","�շ�ʧ��!"+ret);
			return;
		}else{
			obj.EditViewport.close();
			Common_LoadCurrPage('gridCopy',1);
			//TODO��ӡ��Ʊ
			if (IsCopyPrintBill==1){
				PrintBill(ret,User,PayModeID);
			}
		}
	}
	
	obj.btnRetFee_click = function(){
		var CopyRecordID = obj.VC_Input.RecordID;
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = Common_GetValue('cboHospital');
		
		var CopyInfo = CopyRecordID;						//�Ǽ�ID
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//֧����ʽ
			FeeInfo += '^'+User;							//����Ա
			FeeInfo += '^'+Loc;								//��½����
			FeeInfo += '^'+GroupID;							//��½��ȫ��
			FeeInfo += '^'+HospID;							//��½ҽԺ
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","RF",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("������ʾ","�˷�ʧ��!");
			return;
		}else{
			ExtTool.alert("��ʾ","�˷ѳɹ�!");
			obj.EditViewport.close();
			Common_LoadCurrPage('gridCopy',1);
		}
	}
}