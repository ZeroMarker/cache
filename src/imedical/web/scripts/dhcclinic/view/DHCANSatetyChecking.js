var patientInfo="",
	operationInfo="",
	anaestInfo="",
	filePath="",
	hospitalDesc="",
	currentStatus="";
$(document).ready(function(){
	var opaId=getQueryString("opaId"),
		userId=getQueryString("userId");
	
	$("input:checkbox").click(function(){
		var YES="_yes",NO="_no";
		if($(this).is(":checked")){
			$(this).attr("class","label_on");
			
			//ѡ��򻥳�����
			var thisItemId=$(this).attr("id"),
				mainItemId="",
				thatItemId="";
			if(thisItemId.indexOf(YES)>0){
				mainItemId=thisItemId.replace(YES,"");
				thatItemId=mainItemId+NO;
			}
			else if(thisItemId.indexOf(NO)>0){
				mainItemId=thisItemId.replace(NO,"");
				thatItemId=mainItemId+YES;
			}

			$("#"+thatItemId).attr("checked",false);
			$("#"+thatItemId).attr("class","label_off");
		}
		else{
			$(this).attr("class","label_off");
		}
	});
	
	
	$("#preAN").panel({
		title:"1������ʵʩǰ",
		width:380,
		height:625,
		style:{"float":"left","padding":"5px 0 0 0"}
	});

	$("#preOP").panel({
		title:"2��Ƥ���п�ǰ",
		width:380,
		height:625,
		style:{"float":"left","padding":"5px 5px 0 5px"}
	});

	$("#preTheatreOut").panel({
		title:"3����������ǰ",
		width:370,
		height:625,
		style:{"float":"left","padding":"5px 0 0 0"}
	});
	
	
	setElementDisabled("preFirstSave");
	setButtonStyle("preFirstSave");
	
	$("#OPS_SurgeonSign").keypress(function(e){
		if(e.which==13){
			$.post("dhcclinic.jquery.method.csp",{
				ClassName:"web.DHCClinicCom",
				MethodName:"GetUserInfoByInitials",
				Arg1:$(this).val(),
				ArgCnt:"1"
			},function(data){
				var dataArr=data.split("^");
				if(dataArr[0].Trim()!="DOCTOR"){
					$.messager.alert("����","���û����Ͳ���ҽ����������ҽ���û����˺ţ�","error",function(){
						$("#OPS_SurgeonSign").focus();
					});
					
					return;
				}
				//document.getElementById("OPS.SurgeonSign").value=dataArr[4];
				$("#OPS_SurgeonSign").val(dataArr[4]);
				$("#OPS_SurgeonSignId").val(dataArr[3]);
				$("#OPS_AnesthetistSign").focus();
			});
		}
	});
	
	$("#OPS_AnesthetistSign").keypress(function(e){
		if(e.which==13){
			$.post("dhcclinic.jquery.method.csp",{
				ClassName:"web.DHCClinicCom",
				MethodName:"GetUserInfoByInitials",
				Arg1:$(this).val(),
				ArgCnt:"1"
			},function(data){
				var dataArr=data.split("^");
				if(dataArr[0].Trim()!="DOCTOR"){
					$.messager.alert("����","���û����Ͳ���ҽ����������ҽ���û����˺ţ�","error",function(){
						$("#OPS_AnesthetistSign").focus();
					});
					
					return;
				}
				//document.getElementById("OPS.SurgeonSign").value=dataArr[4];
				$("#OPS_AnesthetistSign").val(dataArr[4]);
				$("#OPS_AnesthetistSignId").val(dataArr[3]);
				$("#OPS_OperNurseSign").focus();
			});
		}
	});
	
	$("#OPS_OperNurseSign").keypress(function(e){
		if(e.which==13){
			$.post("dhcclinic.jquery.method.csp",{
				ClassName:"web.DHCClinicCom",
				MethodName:"GetUserInfoByInitials",
				Arg1:$(this).val(),
				ArgCnt:"1"
			},function(data){
				var dataArr=data.split("^");
				if(dataArr[0].Trim()!="NURSE"){
					$.messager.alert("����","���û����Ͳ��ǻ�ʿ�������뻤ʿ�û����˺ţ�","error",function(){
						$("#OPS_OperNurseSign").focus();
					});
					
					return;
				}
				//document.getElementById("OPS.SurgeonSign").value=dataArr[4];
				$("#OPS_OperNurseSign").val(dataArr[4]);
				$("#OPS_OperNurseSignId").val(dataArr[3]);
				//$("#OPS_AnesthetistSign").focus();
			});
		}
	});
	
	var statusArr=null;
	
	//��������
	$("#btnPreANChecking").click(function(){
		statusArr=["preAN","preOP","preTheatreOut"];
		if(statusArr.Contains(currentStatus)){
			return;
		}
		if($("#OPS_PatInfoChecking_yes").is(":checked") || $("#OPS_PatInfoChecking_no").is(":checked")){
			saveElementValue(opaId,"preAN",userId,true);
		}else{
			$.messager.alert("����","�����������Ա�����δȷ��!","error");
		}
		
	});
	
	
	$("#btnPreOPChecking").click(function(){
		statusArr=["","preOP","preTheatreOut"];
		if(statusArr.Contains(currentStatus)){
			return;
		}
		if($("#OPS_SurgeonSignId").val()==""){
			
			$.messager.alert("����","����ҽ��δǩ�������ܱ��棡","error");
			return;
		}
		if($("#OPS_AnesthetistSignId").val()==""){
			$.messager.alert("����","����ҽ��δǩ�������ܱ��棡","error");
			return;
		}
		if($("#OPS_PreOPPatInfoChecking_yes").is(":checked") || $("#OPS_PreOPPatInfoChecking_no").is(":checked")){
			saveElementValue(opaId,"preOP",userId,true);
			//saveElementValue(opaId,"sign",userId,false);
		}
		else{
			$.messager.alert("����","�����������Ա�����δȷ��!","error");
		}
	});
	
	$("#btnPreTheatreOutChecking").click(function(){
		statusArr=["","preAN","preTheatreOut"];
		if(statusArr.Contains(currentStatus)){
			return;
		}
		if($("#OPS_OperNurseSign").val()==""){
			$.messager.alert("����","������ʿδǩ�������ܱ��棡","error");
			return;
		}
		if($("#OPS_PreTOPatInfoChecking_yes").is(":checked") || $("#OPS_PreTOPatInfoChecking_no").is(":checked")){
			saveElementValue(opaId,"preTheatreOut",userId,true);
			//saveElementValue(opaId,"sign",userId,false);
		}else{
			$.messager.alert("����","�����������Ա�����δȷ��!","error");
		}
		
	});
	
	$("#CancelOperation").click(function(){
		$.post("dhcclinic.jquery.method.csp?time="+(new Date()).getTime(),{ClassName:"web.UDHCANOPArrange",MethodName:"ChangeAnopStat",Arg1:"D",Arg2:opaId,ArgCnt:"2"},
		function(data){
		//����ֵ�лس�����ȥ��	+20161024+dyl
		data=data.replace(/[\r\n ]/g, '');
		//data=data.replace(/[ ]/g,"")
		//alert("^"+data+"^")
			if(data==""){
				$.messager.alert("��ʾ","�ɹ�ȡ��������","info");
				window.returnValue=1;
			}
			else{
				$.messager.alert("����","ȡ������ʧ��!"+data,"error");
			}
		});
	});
	
	$("#Print").click(function(){
		statusArr=["","preAN","preOP"];
		if(statusArr.Contains(currentStatus)){
			return;
		}
		printCheckingRecord();
	});
	
	//ȡ������Ϣ
	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindPatientInfo",Arg1:opaId,ArgCnt:"1"},
	    function(data){
	    	patientInfo=data.rows[0];
	    	$("#patName").text("����������"+patientInfo.Name);
	    	$("#gender").text("�Ա�"+patientInfo.Gender);
	    	$("#age").text("���䣺"+patientInfo.Age);
	    	$("#dept").text("�Ʊ�"+patientInfo.Location);
	    	$("#medicareNo").text("�����ţ�"+patientInfo.MedicareNo);
	},"json");
	
	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindOperationInfo",Arg1:opaId,ArgCnt:"1"},
		function(data){
			operationInfo=data.rows[0];
			$("#operation").text("�������ƣ�"+operationInfo.Operation);
	},"json");

	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindAnaestInfo",Arg1:opaId,ArgCnt:"1"},
		function(data){
			anaestInfo=data.rows[0];
	},"json");
	
	//��ȡ�Ѿ������ֵ
	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCANOPArrangeExtend",QueryName:"FindArrangeExtendValue",Arg1:opaId,Arg2:"OPS",ArgCnt:"2"},
	function(data){
		if(data && data.rows && data.rows.length>0){
			var OPSStatus="";
			$.each(data.rows,function(index,dataItem){
				if(dataItem.ExtendItemCode && dataItem.Value){
					var extendItem=document.getElementById(dataItem.ExtendItemCode);
					if(extendItem){
						if(dataItem.Value=="true"){
							extendItem.checked=true;
							$("#"+dataItem.ExtendItemCode).attr("class","label_on");
						}
						else if(dataItem.Value=="false")
						{
							extendItem.checked=false;
							$("#"+dataItem.ExtendItemCode).attr("class","label_off");
						}
						else
						{
							extendItem.value=dataItem.Value;
						}
					}
					
					if(dataItem.ExtendItemCode=="OPS_Status"){
						currentStatus=dataItem.Value;
						setElementDisabled(dataItem.Value);
						setButtonStyle(dataItem.Value);
						
					}
				}
			});
			
			
		}
	},"json");
	
	// ��ӡģ��·��
	$.post("dhcclinic.jquery.method.csp",{ClassName:"web.DHCClinicCom",MethodName:"GetPath",ArgCnt:"0"},
	function(data){
		filePath=data;
	});
	$.post("dhcclinic.jquery.method.csp",{ClassName:"web.DHCClinicCom",MethodName:"GetHospital",ArgCnt:"0"},
	function(data){
		hospitalDesc=data;
	});
});

function printCheckingRecord(){
		
	//����excel
	var excel=null,
		workBook=null,
		sheet=null;
	try{
		excel=new ActiveXObject("Excel.Application");
	}
	catch(e){
		$.messager.alert("����","�����δ��װExcel���ӱ��������Ȱ�װ��","error");
	}
	
	var fileName=filePath.replace(/[\r\n]/g,"").replace(/\ +/g,"")+"OperSafetyChecking.xls";
	try{
		workBook=excel.Workbooks.open(fileName);
		sheet=workBook.ActiveSheet;
		

		excel.Range("D1").Value= hospitalDesc+"������ȫ�˲��";
		//������Ϣ	
	    excel.Range("N2").Value= patientInfo.Name;
	    excel.Range("V2").Value= patientInfo.Gender;
	    excel.Range("Y2").Value= patientInfo.Age;
	    excel.Range("D2").Value= patientInfo.Location;
	    excel.Range("D5").Value= operationInfo.Operation;
	    excel.Range("U3").Value= operationInfo.OperationDate;
	    excel.Range("D3").Value= patientInfo.MedicareNo;
		excel.Range("M3").Value= operationInfo.Surgeon;
		excel.Range("D4").Value= anaestInfo.AnaMethod;
	    
	    //�˶���Ϣ(����ǰ)
	    excel.Range("H10").Value=$("#OPS_PatInfoChecking_yes").is(":checked")?"��":"";
		excel.Range("J10").Value=$("#OPS_PatInfoChecking_no").is(":checked")?"��":"";
		excel.Range("H14").Value=$("#OPS_SurgicalProceduresChecking_yes").is(":checked")?"��":"";
		excel.Range("J14").Value=$("#OPS_SurgicalProceduresChecking_no").is(":checked")?"��":"";
		excel.Range("H18").Value=$("#OPS_SurgicalSiteChecking_yes").is(":checked")?"��":"";
		excel.Range("J18").Value=$("#OPS_SurgicalSiteChecking_no").is(":checked")?"��":"";
		excel.Range("H22").Value=$("#OPS_SurgicalSiteMarkChecking_yes").is(":checked")?"��":"";
		excel.Range("J22").Value=$("#OPS_SurgicalSiteMarkChecking_no").is(":checked")?"��":"";
		excel.Range("A27").Value=$("#OPS_SurgicalSiteMarkReason").val();
		excel.Range("H34").Value=$("#OPS_SurgicalConsentChecking_yes").is(":checked")?"��":"";
		excel.Range("J34").Value=$("#OPS_SurgicalConsentChecking_no").is(":checked")?"��":"";
		excel.Range("H38").Value=$("#OPS_ANConsentChecking_yes").is(":checked")?"��":"";
		excel.Range("J38").Value=$("#OPS_ANConsentChecking_no").is(":checked")?"��":"";
		excel.Range("H44").Value=$("#OPS_ANMethodChecking_yes").is(":checked")?"��":"";
		excel.Range("J44").Value=$("#OPS_ANMethodChecking_no").is(":checked")?"��":"";
		excel.Range("H50").Value=$("#OPS_ANEquipChecking_yes").is(":checked")?"��":"";
		excel.Range("J50").Value=$("#OPS_ANEquipChecking_no").is(":checked")?"��":"";
		excel.Range("H56").Value=$("#OPS_SkinIntegralityChecking_yes").is(":checked")?"��":"";
		excel.Range("J56").Value=$("#OPS_SkinIntegralityChecking_no").is(":checked")?"��":"";
		excel.Range("H61").Value=$("#OPS_SkinPreparationChecking_yes").is(":checked")?"��":"";
		excel.Range("J61").Value=$("#OPS_SkinPreparationChecking_no").is(":checked")?"��":"";
		excel.Range("H65").Value=$("#OPS_VeinPassageEstablishesChecking_yes").is(":checked")?"��":"";
		excel.Range("J65").Value=$("#OPS_VeinPassageEstablishesChecking_no").is(":checked")?"��":"";
		excel.Range("H71").Value=$("#OPS_AllergicHistory_yes").is(":checked")?"��":"";
		excel.Range("J71").Value=$("#OPS_AllergicHistory_no").is(":checked")?"��":"";
		excel.Range("H77").Value=$("#OPS_SkinTestResultChecking_yes").is(":checked")?"��":"";
		excel.Range("J77").Value=$("#OPS_SkinTestResultChecking_no").is(":checked")?"��":"";
		excel.Range("H81").Value=$("#OPS_BloodPreparationChecking_yes").is(":checked")?"��":"";
		excel.Range("J81").Value=$("#OPS_BloodPreparationChecking_no").is(":checked")?"��":"";
	    excel.Range("B84").Value=$("#OPS_ProsthesisChecking").is(":checked")?"��":"";
	    excel.Range("E84").Value=$("#OPS_BodyImplantChecking").is(":checked")?"��":"";
	    excel.Range("J84").Value=$("#OPS_MedicalPictureChecking").is(":checked")?"��":"";
	    excel.Range("B87").Value=$("#OPS_PreANOtherChecking").val();
		excel.Range("D89").Value=$("#OPS_SurgeonSign").val();	
	    
	    
	    //�˶���Ϣ������ǰ��
		excel.Range("P10").Value=$("#OPS_PreOPPatInfoChecking_yes").is(":checked")?"��":"";
		excel.Range("R10").Value=$("#OPS_PreOPPatInfoChecking_no").is(":checked")?"��":"";
		excel.Range("P14").Value=$("#OPS_PreOPSurgicalProceduresChecking_yes").is(":checked")?"��":"";
		excel.Range("R14").Value=$("#OPS_PreOPSurgicalProceduresChecking_no").is(":checked")?"��":"";
		excel.Range("P18").Value=$("#OPS_SurgicalSiteAndMarkChecking_yes").is(":checked")?"��":"";
		excel.Range("R18").Value=$("#OPS_SurgicalSiteAndMarkChecking_no").is(":checked")?"��":"";
		
	    excel.Range("R25").Value=$("#OPS_OperEstimatedDurationChecking").is(":checked")?"��":"";
	    excel.Range("R28").Value=$("#OPS_OperEstimatedBleedingVolumeChecking").is(":checked")?"��":"";
	    excel.Range("R31").Value=$("#OPS_OperKeyStepsChecking").is(":checked")?"��":"";
	    excel.Range("R34").Value=$("#OPS_SurgeonOtherStatementChecking").is(":checked")?"��":"";
		
	    excel.Range("R38").Value=$("#OPS_SpecialAttentionChecking").is(":checked")?"��":"";
	    excel.Range("R41").Value=$("#OPS_AnesthetistOtherStatementChecking").is(":checked")?"��":"";
		
	    excel.Range("R47").Value=$("#OPS_DisinfectionChecking").is(":checked")?"��":"";
	    excel.Range("R50").Value=$("#OPS_MachineStateChecking").is(":checked")?"��":"";
	    excel.Range("R53").Value=$("#OPS_SpecialDrugChecking").is(":checked")?"��":"";
	    excel.Range("R56").Value=$("#OPS_SurgeryNurseOtherStatementChecking").is(":checked")?"��":"";
		
	    excel.Range("P61").Value=$("#OPS_PreOPMedicalPictureChecking_yes").is(":checked")?"��":"";
	    excel.Range("R61").Value=$("#OPS_PreOPMedicalPictureChecking_no").is(":checked")?"��":"";
		
	    excel.Range("M87").Value=$("#OPS_PreOPOtherChecking").val();
	    excel.Range("N89").Value=$("#OPS_AnesthetistSign").val();

	    
	    //�˶���Ϣ������ǰ��
	    //��������+20160922+dyl+û����?
		excel.Range("X10").Value=$("#OPS_PreTOPatInfoChecking_yes").is(":checked")?"��":"";
		excel.Range("Z10").Value=$("#OPS_PreTOPatInfoChecking_no").is(":checked")?"��":"";
		//ʵ������
		excel.Range("X14").Value=$("#OPS_PreTOSurgicalProceduresChecking_yes").is(":checked")?"��":"";
		excel.Range("Z14").Value=$("#OPS_PreToSurgicalProceduresChecking_no").is(":checked")?"��":"";
		//������ҩ
		excel.Range("X18").Value=$("#OPS_DrugAndBloodChecking_yes").is(":checked")?"��":"";
		excel.Range("Z18").Value=$("#OPS_DrugAndBloodChecking_no").is(":checked")?"��":"";
		//�����������
		excel.Range("X22").Value=$("#OPS_SurgicalInstrumentChecking_yes").is(":checked")?"��":"";
		excel.Range("Z22").Value=$("#OPS_SurgicalInstrumentChecking_no").is(":checked")?"��":"";
		//�����걾
		excel.Range("X28").Value=$("#OPS_SurgicalSpecimensChecking_yes").is(":checked")?"��":"";
		excel.Range("Z28").Value=$("#OPS_SurgicalSpecimensChecking_no").is(":checked")?"��":"";
		//Ƥ��
		excel.Range("X34").Value=$("#OPS_PreTOSkinIntegralityChecking_yes").is(":checked")?"��":"";
		excel.Range("Z34").Value=$("#OPS_PreTOSkinIntegralityChecking_no").is(":checked")?"��":"";
		
	    excel.Range("Z38").Value=$("#OPS_CatheterChecking_CVC").is(":checked")?"��":"";
	    excel.Range("Z41").Value=$("#OPS_CatheterChecking_Artery").is(":checked")?"��":"";
	    excel.Range("Z44").Value=$("#OPS_CatheterChecking_TrachealIntubation").is(":checked")?"��":"";
	    excel.Range("Z47").Value=$("#OPS_CatheterChecking_WoundDrainage").is(":checked")?"��":"";
	    excel.Range("Z50").Value=$("#OPS_CatheterChecking_StomachTube").is(":checked")?"��":"";
	    excel.Range("Z53").Value=$("#OPS_CatheterChecking_Urine").is(":checked")?"��":"";
		excel.Range("Z56").Value=$("#OPS_CatheterChecking_PeripheralVein").is(":checked")?"��":"";
		excel.Range("Z59").Value=$("#OPS_CatheterChecking_Other").is(":checked")?"��":"";
		excel.Range("V58").Value=$("#OPS_CatheterChecking_Othertext").val();
		
		excel.Range("Z65").Value=$("#OPS_TransChecking_PACU").is(":checked")?"��":"";
		excel.Range("Z68").Value=$("#OPS_TransChecking_Ward").is(":checked")?"��":"";
		excel.Range("Z71").Value=$("#OPS_TransChecking_ICU").is(":checked")?"��":"";
		excel.Range("Z74").Value=$("#OPS_TransChecking_Emergency").is(":checked")?"��":"";
		excel.Range("Z77").Value=$("#OPS_TransChecking_Discharge").is(":checked")?"��":"";
		
		excel.Range("U87").Value=$("#OPS_PreTOOtherChecking").val();
		excel.Range("V89").Value=$("#OPS_OperNurseSign").val();

	    
	    sheet.PrintOut();
	    sheet=null;
	    workBook.Close(savechanges=false);
	    workBook=null;
	}
	catch(e){
		$.messager.alert("����","δ�ҵ���ӡģ�壬��ȷ�ϴ�ӡģ���·���Ƿ���ȷ��","error");
	}
	
	
	excel.Quit();
	excel=null;
}

function setButtonStyle(OPSStatus){
	
	switch(OPSStatus){
		case "preAN":
			//$("#btnPreANChecking").removeClass("c5");
			//$("#btnPreANChecking").addClass("c1");
			$("#btnPreANChecking").linkbutton({
				text:"�ѱ���"
			});
			$('#btnPreANChecking').linkbutton('disable');


			//$("#btnPreOPChecking").removeClass("c2");
			//$("#btnPreOPChecking").addClass("c5");
			$("#btnPreOPChecking").linkbutton('enable');
			break;
		case "preOP":
			//$("#btnPreANChecking").removeClass("c5");
			//$("#btnPreANChecking").addClass("c1");
			$("#btnPreANChecking").linkbutton({
				text:"�ѱ���"
			});
			$('#btnPreANChecking').linkbutton('disable');
			
			//$("#btnPreOPChecking").removeClass("c5");
			//$("#btnPreOPChecking").removeClass("c2");
			//$("#btnPreOPChecking").addClass("c1");
			$("#btnPreOPChecking").linkbutton({
				text:"�ѱ���"
			});
			$("#btnPreOPChecking").linkbutton('disable');
			//$("#btnPreTheatreOutChecking").removeClass("c2");
			//$("#btnPreTheatreOutChecking").addClass("c5");
			$("#btnPreTheatreOutChecking").linkbutton('enable');
			break;
		case "preTheatreOut":
			//$("#btnPreANChecking").removeClass("c5");
			//$("#btnPreANChecking").addClass("c1");
			$("#btnPreANChecking").linkbutton({
				text:"�ѱ���"
			});
			$('#btnPreANChecking').linkbutton('disable');
			
			//$("#btnPreOPChecking").removeClass("c5");
			//$("#btnPreOPChecking").removeClass("c2");
			//$("#btnPreOPChecking").addClass("c1");
			$("#btnPreOPChecking").linkbutton('disable');
			$("#btnPreOPChecking").linkbutton({
				text:"�ѱ���"
			});
			//$("#btnPreTheatreOutChecking").removeClass("c5");
			//$("#btnPreTheatreOutChecking").removeClass("c2");
			//$("#btnPreTheatreOutChecking").addClass("c1");
			$("#btnPreTheatreOutChecking").linkbutton('disable');
			$("#btnPreTheatreOutChecking").linkbutton({
				text:"�ѱ���"
			});
			
			//$("#Print").removeClass("c2");
			//$("#Print").addClass("c5");
			$("#Print").linkbutton('enable');
			break;
		default:
			//$("#btnPreANChecking").addClass("c5");
			//��׼��Ҫ��ͳһ����Ĭ����ʽ+dyl+20161007
			$("#btnPreANChecking").linkbutton('enable');
			
			//$("#btnPreOPChecking").addClass("c2");
			$("#btnPreOPChecking").linkbutton('disable');
			//$("#btnPreTheatreOutChecking").addClass("c2");
			$("#btnPreTheatreOutChecking").linkbutton('disable');
			//$("#Print").addClass("c2");
			$("#Print").linkbutton('disable');
			break;
	}
}

function saveElementValue(opaId,OPSStatus,userId,editStatus){
	var subSplitChar=String.fromCharCode(3),mainSplitChar="^",singleValue="",value="";
	var checkingTimeCode="OPS."+OPSStatus+"CheckingTime";
	
	$("#"+OPSStatus).find("input").each(function(index,element){
		switch($(this).attr("type")){
			case "checkbox":
				singleValue=$(this).attr("id")+subSplitChar+$(this).is(":checked")+subSplitChar;
				break;
			case "textbox":
			case "text":
				if($(this).attr("id").toUpperCase()==checkingTimeCode.toUpperCase())
				{
					if($(this).val()==""){
						var serverDate= new Date($.ajax({async:false}).getResponseHeader("Date"));	//��ȡ�������ĵ�ǰʱ��
						$(this).val(serverDate.Format("yyyy-MM-dd hh:mm"));
					}
					
					
				}
				singleValue=$(this).attr("id")+subSplitChar+$(this).val()+subSplitChar;
				break;
		}
		
		if(value!=""){
			value=value+mainSplitChar;
		}
		value=value+singleValue;
		
	});
	
	if(value && value!=""){
		if(OPSStatus=="preOP"){
			value=value+"^"+"OPS_SurgeonSign"+subSplitChar+$("#OPS_SurgeonSign").val()+subSplitChar;
			value=value+"^"+"OPS_SurgeonSignId"+subSplitChar+$("#OPS_SurgeonSignId").val()+subSplitChar;
			value=value+"^"+"OPS_AnesthetistSign"+subSplitChar+$("#OPS_AnesthetistSign").val()+subSplitChar;
			value=value+"^"+"OPS_AnesthetistSignId"+subSplitChar+$("#OPS_AnesthetistSignId").val()+subSplitChar;
		}
		if(OPSStatus=="preTheatreOut"){
			value=value+"^"+"OPS_OperNurseSign"+subSplitChar+$("#OPS_OperNurseSign").val()+subSplitChar;
			value=value+"^"+"OPS_OperNurseSignId"+subSplitChar+$("#OPS_OperNurseSignId").val()+subSplitChar;
		}
		if(editStatus){
			value=value+"^"+"OPS_Status"+subSplitChar+OPSStatus+subSplitChar;
		}
		
		$.post("dhcclinic.jquery.method.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCANOPArrangeExtend",MethodName:"SaveArrangeExtend",Arg1:opaId,Arg2:value,Arg3:userId,ArgCnt:"3"},
		function(data){
			if(data.Trim()==""){
				$.messager.alert("��ʾ","�ɹ�����������ȫ�˲����ݣ�","info",function(){
					currentStatus=OPSStatus;
					setElementDisabled(OPSStatus);
					if(editStatus){
						setButtonStyle(OPSStatus);
					}
				});
				
			}
			else
			{
				$.messager.alert("����","����ʧ�ܣ����������޶�����"+data,"error");
			}
			
		});
	}
	
}


function setElementDisabled(OPSStatus){
	switch(OPSStatus){
		case "preAN":
			//$("#btnPreANChecking").attr("disabled",true);
			//$("#btnPreOPChecking").attr("disabled",false);
			//$("#btnPreTheatreOutChecking").attr("disabled",true);
			$("#preAN").find("input").attr("disabled",true);
			$("#preOP").find("input").attr("disabled",false);
			$("#preTheatreOut").find("input").attr("disabled",true);
			$("#OPS_SurgeonSign").attr("disabled",false)
			$("#OPS_AnesthetistSign").attr("disabled",false)
			$("#OPS_OperNurseSign").attr("disabled",true)
			break;
		case "preOP":
			//$("#btnPreANChecking").attr("disabled",true);
			//$("#btnPreOPChecking").attr("disabled",true);
			//$("#btnPreTheatreOutChecking").attr("disabled",false);
			$("#preAN").find("input").attr("disabled",true);
			$("#preOP").find("input").attr("disabled",true);
			$("#preTheatreOut").find("input").attr("disabled",false);
			$("#OPS_SurgeonSign").attr("disabled",true)
			$("#OPS_AnesthetistSign").attr("disabled",true)
			$("#OPS_OperNurseSign").attr("disabled",false)
			break;
		case "preTheatreOut":
			//$("#btnPreANChecking").attr("disabled",true);
			//$("#btnPreOPChecking").attr("disabled",true);
			//$("#btnPreTheatreOutChecking").attr("disabled",true);
			$("#preAN").find("input").attr("disabled",true);
			$("#preOP").find("input").attr("disabled",true);
			$("#preTheatreOut").find("input").attr("disabled",true);
			$("#OPS_SurgeonSign").attr("disabled",true)
			$("#OPS_AnesthetistSign").attr("disabled",true)
			$("#OPS_OperNurseSign").attr("disabled",true)
			break;
		case "preFirstSave":
			//$("#btnPreANChecking").attr("disabled",false);
			//$("#btnPreOPChecking").attr("disabled",true);
			//$("#btnPreTheatreOutChecking").attr("disabled",true);
			$("#preAN").find("input").attr("disabled",false);
			$("#preOP").find("input").attr("disabled",true);
			$("#preTheatreOut").find("input").attr("disabled",true);
			$("#OPS_SurgeonSign").attr("disabled",false)
			$("#OPS_AnesthetistSign").attr("disabled",false)
			$("#OPS_OperNurseSign").attr("disabled",true)
			break;
		default:
			break;
		}
}