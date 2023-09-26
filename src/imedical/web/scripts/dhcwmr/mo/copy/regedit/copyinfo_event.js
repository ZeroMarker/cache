function BC_InitInfoEvent(obj){
	
	obj.BC_LoadEvents = function(){
		obj.BC_btnCancel.on("click",obj.BC_btnCancel_click,obj);
		obj.BC_btnSave.on("click",obj.BC_btnSave_click,obj);
	}
	obj.BC_btnCancel_click = function(){
		obj.BC_WinCopy.close();
	}

	obj.BC_btnSave_click = function(){
		var Error='';
		var MrTypeID = Common_GetValue("cboMrType");
		if (!MrTypeID){
			ExtTool.alert("��ʾ",'��������Ϊ��!');
			return;
		}
		var ClientName = Common_GetValue("BC_ClientName");
		var ClientRelation = Common_GetValue("BC_cboClientRelation");
		var CardType = Common_GetValue("BC_cboCardType");
		var PersonalID = Common_GetValue("BC_txtPersonalID");
		var Telephone = Common_GetValue("BC_txtTelephone");
		var Address = Common_GetValue("BC_txtAddress");
		var Purpose = Common_GetValue("BC_cbgPurpose");
		var Content = Common_GetValue("BC_cbgContent");
		var Resume = Common_GetValue("BC_txtResume");
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = session['LOGON.HOSPID'];
		
		if (Purpose != "") Purpose = Purpose.replace(/,/g,'#');
		if (Content != "") Content = Content.replace(/,/g,'#');
		//var OperaList = objScreen.GetOperaList();
		if (ClientName=="") Error=Error+"ί���ˡ�";
		if (ClientRelation=="") Error=Error+"�뻼�߹�ϵ��";
		if (CardType=="") Error=Error+"֤�����ϡ�";
		if (PersonalID=="") Error=Error+"֤�����롢";
		if (Telephone=="") Error=Error+"��ϵ�绰��";
		if (Purpose=="") Error=Error+"��ӡĿ�ġ�";
		if (Error!=""){
			ExtTool.alert("��ʾ",Error+"Ϊ�գ�");
			return;
		}
		
		var CopyInfo="";
			CopyInfo += '^' + ClientName;					//ί��������
			CopyInfo += '^' + ClientRelation;				//ί�����뻼�߹�ϵ
			CopyInfo += '^' + CardType;						//ί����֤������
			CopyInfo += '^' + PersonalID;					//ί�������֤��
			CopyInfo += '^' + Telephone;					//ί������ϵ�绰
			CopyInfo += '^' + Address;						//ί������ϵ��ַ
			CopyInfo += '^' + Content;						//��ӡ����
			CopyInfo += '^' + Purpose;						//��ӡĿ��
			CopyInfo += '^' + Resume;						//��ӡ��ע
		
		var FeeInfo ="";									//֧����ʽ
			FeeInfo += '^'+User;							//����Ա
			FeeInfo += '^'+Loc;								//��½����
			FeeInfo += '^'+GroupID;							//��½��ȫ��
			FeeInfo += '^'+HospID;							//��½ҽԺ		
			
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","BatchCopy","RE",obj.Records,CopyInfo,FeeInfo,"^");
		if (ret>0){
			ExtTool.alert("��ʾ","����ɹ�!",Ext.MessageBox.INFO,Ext.MessageBox.OK,function(button){
				if (button=='ok'){
					obj.BC_WinCopy.close();
					Common_LoadCurrPage('gridCopy',1);
					objScreen.btnQuery_click();
				}
			});
		}
		Common_SetValue("txtMrNo",'')	
	}
}