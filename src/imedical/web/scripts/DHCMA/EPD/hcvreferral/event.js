function InitReportWinEvent(obj) {
	obj.LoadEvent = function(args)
    { 
		$("#btnSave").on("click",obj.btnSave_click);
		$("#btnDelete").on("click",obj.btnDelete_click);
		$("#btnCheck").on("click",obj.btnCheck_click);
		$("#btnExport").on("click",obj.btnExport_click);
		$("#btnPrint").on("click",obj.btnPrint_click);
		$("#btnCancle").on("click",obj.btnCancle_click);
		
		obj.InitRepPowerByStatus(obj.ReportID);  //��ť
		 //������ʾ
		obj.DisplayRepInfo();   //����
  	};
	
	//��ʾ��ť����Ȩ�� ���ݱ���״̬�����Ȩ�޿���
	obj.InitRepPowerByStatus = function(ReportID){	
		$('#btnSave').hide();		  
		$('#btnPrint').hide();	   
		$('#btnDelete').hide();      
		$('#btnCheck').hide();	      // ��˰�ť
		$('#btnCancle').hide();       // ɾ����ť
		
		obj.RepStatusCode=	$m({      //���ر���״̬����            
			ClassName:"DHCMed.EPD.HCVReferral",
			MethodName:"GetRepStatus",
			aRepID:ReportID
		},false);
     	switch (obj.RepStatusCode) {
			case "" : // �ޱ��� ֻ���ϱ�
				$('#btnSave').show();	
				$('#btnCancle').show();       // ɾ����ť
				break;
			case "�ϱ�" : // ����
				$('#btnSave').linkbutton({text:$g('�޸ı���')});
				$('#btnSave').show();
				if (LocFlag==1){
					$('#btnPrint').show();      
					$('#btnCheck').show(); // ��˰�ť 
					$('#btnDelete').show();  
				}		            
				$('#btnCancle').show(); 
				break;
			case "���" : // ���
				$('#btnPrint').show();	  
				$('#btnCancle').show();
				break;
			case "����" : // ɾ��
				$('#btnCancle').show();
				break;
		}
		$('#btnExport').hide();	    //���ص�����ť
	}
	//��ʾ����
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			var strInfo=$m({         
				ClassName:"DHCMed.EPD.HCVReferral",
				MethodName:"GetInfoByEPD",
				aEpisodeID:EpisodeID
			},false); 
			var arrInfo=strInfo.split("^");
			$("#txtPatName").val(arrInfo[0]);
			$("#txtPatSex").val(arrInfo[1]);
			$("#txtPersonalID").val(arrInfo[2]);
			$("#ReportDate").datebox("setValue",Common_GetDate(new Date()));
			$("#RefDoctor").val(DocName);
	 		$("#RefOrgName").val(HospDesc);
		}else{
			var strRep=$m({         
				ClassName:"DHCMed.EPD.HCVReferral",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false); 
			var arrRep=strRep.split("^");
			$("#RecHospName").val(arrRep[0]);
			$("#txtPatName").val(arrRep[1]);
			$("#txtPatSex").val(arrRep[2]);
			$("#txtPersonalID").val(arrRep[3]);
			Common_SetRadioValue("RadHCVDetection",arrRep[4].split(CHR_1)[0]);
			Common_SetRadioValue("RadExamPlan",arrRep[5].split(CHR_1)[0]);
			$("#OtherPlan").val(arrRep[6]);
			$("#RefTelPhone").val(arrRep[7]);
			$("#RefDoctor").val(arrRep[8]);
			$("#RefOrgName").val(arrRep[9]);
			$("#ReportDate").datebox("setValue",arrRep[10]);
			$("#Resume").val(arrRep[11]);
			$("#RepStatus").val(arrRep[12]);
		}
	};
	//��װ����
	obj.GetRepData = function (Status) {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+$("#RecHospName").val();
		InputStr=InputStr+"^"+$("#txtPatName").val();
		InputStr=InputStr+"^"+$("#txtPatSex").val();
		InputStr=InputStr+"^"+$("#txtPersonalID").val();
		InputStr=InputStr+"^"+Common_RadioValue("RadHCVDetection");
		InputStr=InputStr+"^"+Common_RadioValue("RadExamPlan");
		InputStr=InputStr+"^"+$("#OtherPlan").val();
		InputStr=InputStr+"^"+$("#RefTelPhone").val();
		InputStr=InputStr+"^"+$("#RefDoctor").val();
		InputStr=InputStr+"^"+$("#RefOrgName").val();
		InputStr=InputStr+"^"+$("#ReportDate").datebox("getValue");
		InputStr=InputStr+"^"+$("#Resume").val();
		InputStr=InputStr+"^"+Status;
		
		return InputStr;
	}
	obj.checkRepData=function(){
		var CheckStr=""
		if (!$("#RecHospName").val()){
			CheckStr=$g("����ҽ�ƻ������Ʋ���Ϊ��")+"!<br>";
		}
		if (!$("#RefTelPhone").val()){
			CheckStr=$g("ת�鵥λ��ϵ�绰����Ϊ��")+"!<br>";
		}
		if (!$("#RefDoctor").val()){
			CheckStr=$g("ת��ҽ������Ϊ��")+"!<br>";
		}
		if (!$("#RefOrgName").val()){
			CheckStr=$g("ת�鵥λ����Ϊ��")+"!<br>";
		}
		
		if(CheckStr != "")
		{
			$.messager.alert($g("��ʾ"), CheckStr, 'info');
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
		var RepData=obj.GetRepData(1);
		var ret=$m({                
			ClassName:"DHCMed.EPD.HCVReferral",
			MethodName:"Update",
			aInput:RepData,
			separete:"^"
		},false); 
		if(parseInt(ret)<=0){
			$.messager.alert($g("����"),$g("���ݱ������")+"!"+ret, 'info');
			return;
		}else{
			$.messager.alert($g("��ʾ"),$g("���ݱ���ɹ�")+"!", 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();   //����
			obj.InitRepPowerByStatus(obj.ReportID);  //��ť
		}
	};
	// ����
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("����"),$g("��δ�ϱ�")+"!");
			return;
		}
		$.messager.confirm($g("��ʾ"),$g("��ȷ���Ƿ�����")+"?",function(btn){
			if(btn){
				var Data=obj.GetRepData(3);
				var ret=$m({                
					ClassName:"DHCMed.EPD.HCVReferral",
					MethodName:"ChangeReport",
					aInput:Data,
					separete:"^"
				},false);
				if(parseInt(ret)<=0){
					$.messager.alert($g("����"),$g("����ʧ��")+"!"+ret, 'info');
					return;
				}else{
					$.messager.alert($g("��ʾ"),$g("�������ϳɹ�")+"!", 'info');
					obj.ReportID=ret;
					obj.DisplayRepInfo();   //����
					obj.InitRepPowerByStatus(obj.ReportID); 
				}
			}
		});
	};
	//���
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("����"),$g("���������ϱ�������"));
			return;
		}
		var Data=obj.GetRepData(2);
		var ret=$m({                
			ClassName:"DHCMed.EPD.HCVReferral",
			MethodName:"ChangeReport",
			aInput:Data,
			separete:"^"
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("����"),$g("�������ʧ��")+"!"+ret, 'info');
			return;
		}else{
			$.messager.alert($g("��ʾ"),$g("������˳ɹ�")+"!", 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();   //����
			obj.InitRepPowerByStatus(obj.ReportID);  //��ť
		}
	};
	
	//��ӡ
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("����"),$g("���������ϱ�������"));
			return;
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintDHCMAEPDHCVREFReport");		//��ӡ���������
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>��##ҳ</span>/<span tdata='pageCount'>��##ҳ</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//ÿҳ����ӡҳ��
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//�˹�˫���ӡ(��ӡ����֧��˫���ӡʱ��0Ϊ�����ӡ��1Ϊ��˫���ӡ��2Ϊ˫���ӡ)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//�Զ�˫���ӡ(��ӡ��֧��˫���ӡʱ��0Ϊ�����ӡ��1Ϊ��˫���ӡ��2Ϊ˫���ӡ)
		LodopPrintURL(LODOP,"dhcma.epd.lodophcvref.csp?ReportID="+obj.ReportID,"","20mm");
		LODOP.PRINT();			//ֱ�Ӵ�ӡ
	};
	//�˳�
	obj.btnCancle_click = function(){
		websys_showModal('close');
	};
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          