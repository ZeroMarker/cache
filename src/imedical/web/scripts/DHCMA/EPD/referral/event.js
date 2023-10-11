function InitReportWinEvent(obj) {
	obj.LoadEvent = function(args)
    { 
		$("#btnSave").on("click",obj.btnSave_click);
		$("#btnDelete").on("click",obj.btnDelete_click);
		$("#btnCheck").on("click",obj.btnCheck_click);
		$("#btnExport").on("click",obj.btnExport_click);
		$("#btnPrint").on("click",obj.btnPrint_click);
		$("#btnCancle").on("click",obj.btnCancle_click);
		 //������ʾ
		obj.DisplayRepInfo();   //����
		obj.InitRepPowerByStatus(obj.ReportID);  //��ť
  	};
	
	//��ʾ��ť����Ȩ�� ���ݱ���״̬�����Ȩ�޿���
	obj.InitRepPowerByStatus = function(ReportID){	
		$('#btnSave').hide();		  
		$('#btnPrint').hide();	      
		$('#btnExport').hide();	  
		$('#btnDelete').hide();      
		$('#btnCheck').hide();	      // ��˰�ť
		$('#btnCancle').hide();       // ɾ����ť
		
		obj.RepStatusCode=	$m({      //���ر���״̬����            
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"GetRepStatus",
			aRepID:ReportID
		},false);
     	switch (obj.RepStatusCode) {
			case "" : // �ޱ��� ֻ���ϱ�
				$('#btnSave').show();	
				$('#btnCancle').show();       // ɾ����ť
				break;
			case "1" : // ����
				$('#btnSave').linkbutton({text:'�޸ı���'});
				$('#btnSave').show();		  
				$('#btnPrint').show();	      
				$('#btnExport').show();	      
				$('#btnCheck').show();  
				$('#btnDelete').show();            // ��˰�ť
				$('#btnCancle').show(); 
				break;
			case "2" : // ���
				$('#btnPrint').show();	      
				$('#btnExport').show();	 
				$('#btnCancle').show();
				break;
			case "3" : // ɾ��
				$('#btnCancle').show();
				break;
		}
		$('#btnExport').hide();	    //���ص�����ť
	}
	//��ʾ����
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			var strInfo=$m({         
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"GetInfoByEPD",
			aEpisodeID:EpisodeID
		},false); 
			var arrInfo=strInfo.split("^");
			$("#txtPatName").val(arrInfo[0]);
			$("#txtPatSex").val(arrInfo[1]);
			$("#txtPatAge").val(arrInfo[2]);
			$("#txtPatMrNo").val(arrInfo[3]);
			$("#txtPatAddress").val(arrInfo[4]);
			$("#txtPatPhoneNo").val(arrInfo[5]);
			$("#txtFamilyName").val(arrInfo[6]);
			$("#txtWorkAddress").val(arrInfo[7]);
		}else{
			var strRep=$m({         
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"GetStringById",
			id:obj.ReportID,
			lagCode:session['LOGON.LANGCODE']
		},false); 
			var arrRep=strRep.split("^");
			$("#txtPatName").val(arrRep[0]);
			$("#txtPatSex").val(arrRep[1]);
			$("#txtPatAge").val(arrRep[2]);
			$("#txtPatMrNo").val(arrRep[3]);
			$("#txtPatAddress").val(arrRep[4]);
			$("#txtPatPhoneNo").val(arrRep[5]);
			$("#txtFamilyName").val(arrRep[6]);
			$("#txtWorkAddress").val(arrRep[7]);
			$("#cboReferralReason").combobox("setValue",arrRep[8]);
			$("#txtReferralHosp").val(arrRep[9]);
			$("#txtReferralDoc").val(arrRep[10]);
			$("#txtReferralDate").datebox("setValue",arrRep[11]);
			$("#txtReferralAdd").val(arrRep[12]);
			$("#txtReferralPhone").val(arrRep[13]);
			$("#cboPatReferralHosp").combobox("setValue",arrRep[14]);
		}
	};
	//��װ����
	obj.GetRepData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+$("#txtPatName").val();
		InputStr=InputStr+"^"+$("#txtPatSex").val();
		InputStr=InputStr+"^"+$("#txtPatAge").val();
		InputStr=InputStr+"^"+$("#txtPatMrNo").val();
		InputStr=InputStr+"^"+$("#txtPatAddress").val();
		InputStr=InputStr+"^"+$("#txtPatPhoneNo").val();
		InputStr=InputStr+"^"+$("#txtFamilyName").val();
		InputStr=InputStr+"^"+$("#txtWorkAddress").val();
		InputStr=InputStr+"^"+$("#cboReferralReason").combobox("getValue");
		InputStr=InputStr+"^"+$("#txtReferralHosp").val();
		InputStr=InputStr+"^"+$("#txtReferralDoc").val();
		InputStr=InputStr+"^"+$("#txtReferralDate").datebox("getValue");
		InputStr=InputStr+"^"+$("#txtReferralAdd").val();
		InputStr=InputStr+"^"+$("#txtReferralPhone").val();
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+$("#cboPatReferralHosp").combobox("getValue");
		
		return InputStr;
	}
	obj.checkRepData=function(){
		var CheckStr=""
		
		if (!$("#txtPatAddress").val()){
			CheckStr="��ס��ϸ��ַ����Ϊ��!<br>";
		}
		if (!$("#txtPatPhoneNo").val()){
			CheckStr="������ϵ�绰����Ϊ��!<br>"
		}
		if ($("#txtPatPhoneNo").val() != ""){
			if (!(/^1[3456789]\d{9}$/.test($("#txtPatPhoneNo").val()))) {
				CheckStr += '����Ļ��ߵ绰�����ʽ�����Ϲ涨������������!<br>';
			}
		}
		if (!$("#txtFamilyName").val()){
			CheckStr="������������Ϊ��!<br>"
		}
		if (!$("#txtWorkAddress").val()){
			CheckStr="������λ����Ϊ��!<br>"
		}
	
		if (!$("#cboReferralReason").combobox("getValue")){
			CheckStr="ת��ԭ����Ϊ��!<br>"
		}
		if (!$("#txtReferralAdd").val()){
			CheckStr="��ַ����Ϊ��!"
		}
		if (!$("#txtReferralPhone").val()){
			CheckStr="ת�ﵥλ�绰����Ϊ��!"
		}
		if ($("#txtReferralPhone").val() != ""){
			if (!(/^1[3456789]\d{9}$/.test($("#txtReferralPhone").val()))) {
				CheckStr += '�����ת�ﵥλ�绰��ʽ�����Ϲ涨������������!<br>';
			}
		}
		if (!$("#cboPatReferralHosp").combobox("getValue")){
			CheckStr="�벡�˵�ĳ��ҽԺ����Ϊ��!"
		}
		if(CheckStr != "")
		{
			$.messager.alert("��ʾ", CheckStr, 'info');
			return false;
		}
		return true;
	}
	//�ϱ�(����)
	obj.btnSave_click = function(){
		var flag=obj.checkRepData();
		if (flag !=true){
			return;
		}
		var RepData=obj.GetRepData();
		RepData=RepData+"^"+1+"^"+session['LOGON.USERID'];
		
		var ret=$m({                
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"Update",
			aInput:RepData,
			separete:"^"
		},false); 
		
		if(parseInt(ret)<=0){
			$.messager.alert("����","���ݱ������!"+ret);
			return;
		}else{
			$.messager.alert("��ʾ","���ݱ���ɹ�!");
			obj.ReportID=ret;
			obj.InitRepPowerByStatus(obj.ReportID);  //��ť
		}
	};
	//ɾ��
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("����","��δ�ϱ�!");
			return;
		}
		$.messager.confirm("��ʾ","��ȷ���Ƿ�ɾ��?",function(btn){
			if(btn){
				var DeleteStr=obj.ReportID;
				DeleteStr=DeleteStr+"^"+3
				var ret=$m({                
					ClassName:"DHCMed.EPD.ReferralRep",
					MethodName:"ChangeReport",
					aInput:DeleteStr,
					separete:"^"
				},false);
				if(parseInt(ret)<=0){
					$.messager.alert("����","ɾ��ʧ��!"+ret);
					return;
				}else{
					$.messager.alert("��ʾ","����ɾ���ɹ�!");
					obj.InitRepPowerByStatus(obj.ReportID); 
					obj.btnCancle_click();
				}
			}
		});
	};
	//���
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("����","���������ϱ�������");
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+2
		var ret=$m({                
			ClassName:"DHCMed.EPD.ReferralRep",
			MethodName:"ChangeReport",
			aInput:CheckStr,
			separete:"^"
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert("����","�������ʧ��!"+ret);
			return;
		}else{
			$.messager.alert("��ʾ","������˳ɹ�!");
			obj.InitRepPowerByStatus(obj.ReportID);  //��ť
		}
	};
	//����
	obj.btnExport_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("����","���������ϱ�������");
			return;
		}
		var cArguments=obj.ReportID;
		//var flg=ExportDataToExcel("","","�ν�˲���ת�ﵥ("+$("#txtPatName").val()+")",cArguments);
		var fileName="DHCMA_EPD_PrintReportReferral.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
		DHCCPM_RQPrint(fileName);
		
	};
	//��ӡ
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			$.messager.alert("����","���������ϱ�������");
			return;
		}
		var cArguments=obj.ReportID;
		//var flg=PrintDataToExcel("","","�ν�˲���ת�ﵥ("+$("#txtPatName").val()+")",cArguments);
		/*var fileName="{DHCMA_EPD_PrintReportReferral.raq(aReportID="+obj.ReportID+")}";
		DHCCPM_RQDirectPrint(fileName);*/
		var fileName="DHCMA_EPD_PrintReportReferral.raq&aReportID="+obj.ReportID;
		DHCCPM_RQPrint(fileName);
	};
	//�˳�
	obj.btnCancle_click = function(){
		websys_showModal('close');
	};
}