var patientInfo="",
	operationInfo="",
	anaestInfo="",
	filePath="",
	hospitalDesc="",
	currentStatus="",
	operName="";
$(document).ready(function(){
	var opaId=dhccl.getUrlParam("opaId"),
		userId=dhccl.getUrlParam("userId");
	
	$(".hisui-checkbox").checkbox({
        onChecked:function(){
            var YES="_yes",NO="_no";
            //console.log($(this).checkbox('getValue'));
            if(!$(this).checkbox('getValue')){
                //选择框互斥的情况
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
                $("#"+thatItemId).checkbox('setValue',false);
            }
        }
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
				if($.trim(dataArr[0])!="DOCTOR"){
					$.messager.alert("错误","该用户类型并非医生，请输入医生用户的账号！","error",function(){
						$("#OPS_SurgeonSign").focus();
					});
					
					return;
				}
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
				if($.trim(dataArr[0])!="DOCTOR"){
					$.messager.alert("错误","该用户类型并非医生，请输入医生用户的账号！","error",function(){
						$("#OPS_AnesthetistSign").focus();
					});
					
					return;
				}
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
				if($.trim(dataArr[0])!="NURSE"){
					$.messager.alert("错误","该用户类型并非护士，请输入护士用户的账号！","error",function(){
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
	
	//保存数据
	$("#btnPreANChecking").click(function(){
		statusArr=["preAN","preOP","preTheatreOut"];
		if($.inArray(currentStatus,statusArr)!=-1){
			return;
		}
		if($("#OPS_PatInfoChecking_yes").checkbox('getValue') || $("#OPS_PatInfoChecking_no").checkbox('getValue')){
			saveElementValue(opaId,"preAN",userId,true);
		}else{
			$.messager.alert("错误","患者姓名、性别、年龄未确认!","error");
		}
		
	});
	
	
	$("#btnPreOPChecking").click(function(){
		statusArr=["","preOP","preTheatreOut"];
		if($.inArray(currentStatus,statusArr)!=-1){
			return;
		}
		if($("#OPS_SurgeonSignId").val()==""){
			
			$.messager.alert("错误","手术医生未签名，不能保存！","error");
			return;
		}
		if($("#OPS_AnesthetistSignId").val()==""){
			$.messager.alert("错误","麻醉医生未签名，不能保存！","error");
			return;
		}
		if($("#OPS_PreOPPatInfoChecking_yes").checkbox('getValue') || $("#OPS_PreOPPatInfoChecking_no").checkbox('getValue')){
			saveElementValue(opaId,"preOP",userId,true);
			//saveElementValue(opaId,"sign",userId,false);
		}
		else{
			$.messager.alert("错误","患者姓名、性别、年龄未确认!","error");
		}
	});
	
	$("#btnPreTheatreOutChecking").click(function(){
		statusArr=["","preAN","preTheatreOut"];
		if($.inArray(currentStatus,statusArr)!=-1){
			return;
		}
		if($("#OPS_OperNurseSign").val()==""){
			$.messager.alert("错误","手术护士未签名，不能保存！","error");
			return;
		}
		if($("#OPS_PreTOPatInfoChecking_yes").checkbox('getValue') || $("#OPS_PreTOPatInfoChecking_no").checkbox('getValue')){
			saveElementValue(opaId,"preTheatreOut",userId,true);
			//saveElementValue(opaId,"sign",userId,false);
		}else{
			$.messager.alert("错误","患者姓名、性别、年龄未确认!","error");
		}
		
	});
	
	$("#CancelOperation").click(function(){
		var status=$.m({
				ClassName:"web.DHCANOPArrange",
				MethodName:"GetStatus",
				opaId:opaId
				},false);
		if(status!="A")
		{
			$.messager.alert("提示","能操作的手术状态为：申请","warning");
			return;
		}

		$.post("dhcclinic.jquery.method.csp?time="+(new Date()).getTime(),{ClassName:"web.UDHCANOPArrange",MethodName:"ChangeAnopStat",Arg1:"D",Arg2:opaId,ArgCnt:"2"},
		function(data){
		//返回值有回车，得去掉	+20161024+dyl
		data=data.replace(/[\r\n ]/g, '');
		//data=data.replace(/[ ]/g,"")
		if(data==""){
				var userId=session['LOGON.USERID'];
				var IfInsertLog=$.m({
        			ClassName:"web.DHCANOPCancelOper",
        			MethodName:"IfInsertLog"
        		},false);
    			if(IfInsertLog=="Y")
    			{
					var clclogId="RefuseOper",
					    preValue=status,
					    preAddNote="Pre手术状态",
					    postValue="D",
					    postAddNote="停止手术成功";
	    			var ret=$.m({
       					ClassName:"web.DHCANOPCancelOper",
        				MethodName:"InsertCLLog",
        				clclogcode:clclogId,
        				logRecordId:opaId,
        				preValue:preValue,
       	 				preAddNote:preAddNote,
        				postValue:postValue,
        				postAddNote:postAddNote,
        				userId:userId,
        				ipAdress:ClientIPAddress
    				},false);
    				
					if(ret>0){
						$.messager.alert("提示","成功停止手术！","info");
						window.returnValue=1;
						
					}else{
						$.messager.alert("提示","停止手术插入日志错误："+ret,"info");
						return
					}
					
    			}
			}
			else{
				$.messager.alert("错误","停止手术失败!"+data,"error");
			}
		});
	});
	
	$("#Print").click(function(){
		statusArr=["","preAN","preOP"];
		if($.inArray(currentStatus,statusArr)>=0){
			return;
		}
		printCheckingRecord();
	});
	
	//取病人信息
	/*$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindPatientInfo",Arg1:opaId,ArgCnt:"1"},
	    function(data){
	    	patientInfo=data.rows[0];
	    	$("#patName").text("患者姓名："+patientInfo.Name);
	    	$("#gender").text("性别："+patientInfo.Gender);
	    	$("#age").text("年龄："+patientInfo.Age);
	    	$("#dept").text("科别："+patientInfo.Location);
	    	$("#medicareNo").text("病案号："+patientInfo.MedicareNo);
	},"json");*/
    var jsonData=$.cm({
        ClassName:"web.DHCClinicAdmission",
        QueryName:"FindPatientInfo",
        opaId:opaId
    },false);
    if(jsonData&&jsonData.rows.length>0)
    {
        patientInfo=jsonData.rows[0];
        /*$("#patName").text("患者姓名："+patientInfo.Name);
        $("#gender").text("性别："+patientInfo.Gender);
        $("#age").text("年龄："+patientInfo.Age);
        $("#dept").text("科别："+patientInfo.Location);
        $("#medicareNo").text("病案号："+patientInfo.MedicareNo);*/
        $("#patName").prop("innerText",patientInfo.Name);
        $("#gender").prop("innerText",patientInfo.Gender);
        $("#age").prop("innerText",patientInfo.Age);
        $("#dept").prop("innerText",patientInfo.Location);
        $("#medicareNo").prop("innerText",patientInfo.MedicareNo);
        $("#patSeximg").prop("innerText","");
    	if(patientInfo.Gender=="男"){
			var imghtml="<img src='../images/man.png' alt='' style='margin-top:0px;'/>"
			$("#patSeximg").append(imghtml)
		}else if(patientInfo.Gender=="女"){
			var imghtml="<img src='../images/woman.png' alt='' style='margin-top:0px;'/>";
			$("#patSeximg").append(imghtml)
		}
    }
	
    var operData=$.cm({
        ClassName:"web.DHCClinicAdmission",
        QueryName:"FindOperationInfo",
        opaId:opaId
    },false);
    if(operData&&operData.rows.length>0)
    {
        operationInfo=operData.rows[0];
		//$("#operation").text("手术名称：",operationInfo.Operation);
		$.each(operData.rows,function(i,data){
			if(operName=="") 
			{
				operName=data.Operation;
			}
			else 
			{
				operName=operName+"+"+data.Operation;
			}
		})
		$("#operation").prop("innerText",operName);
    }
    //20181029+dyl
	var anaData=$.cm({
        ClassName:"web.DHCClinicAdmission",
        QueryName:"FindAnaestInfo",
        opaId:opaId
    },false);
    if(anaData&&anaData.rows.length>0)
    {
        anaestInfo=anaData.rows[0];
    }
	//获取已经保存的值
    var data=$.cm({
        ClassName:"web.DHCANOPArrangeExtend",
        QueryName:"FindArrangeExtendValue",
        opaId:opaId,
        extendItemType:"OPS",
        rows:100
    },false);
    if(data && data.rows && data.rows.length>0){
        var OPSStatus="";
        $.each(data.rows,function(index,dataItem){
            if(dataItem.ExtendItemCode && dataItem.Value){
				var selector="#"+dataItem.ExtendItemCode;
                if($(selector).hasClass('hisui-checkbox')){
                    $(selector).checkbox('setValue',dataItem.Value=="true"?true:false);
                }else{
					$(selector).val(dataItem.Value);
				}
                
                if(dataItem.ExtendItemCode=="OPS_Status"){
                    currentStatus=dataItem.Value;
                    setElementDisabled(dataItem.Value);
                    setButtonStyle(dataItem.Value);
                    
                }
            }
        });
			
			
		}
	
	// 打印模板路径
	filePath=$.m({
		ClassName:"web.DHCClinicCom",
		MethodName:"GetPath"
	},false);
	hospitalDesc=$.m({
		ClassName:"web.DHCClinicCom",
		MethodName:"GetHospital"
	},false);
});

function printCheckingRecord(){
		
	//操作excel
	var excel=null,
		workBook=null,
		sheet=null;
	try{
		excel=new ActiveXObject("Excel.Application");
	}
	catch(e){
		$.messager.alert("错误","计算机未安装Excel电子表格程序，请先安装！","error");
	}
	
	var fileName=filePath.replace(/[\r\n]/g,"").replace(/\ +/g,"")+"OperSafetyChecking.xls";
	//var fileName="http://114.251.235.112/dthealth/med/Results/Template/OperSafetyChecking.xls"
	try{
		console.log(fileName);
		workBook=excel.Workbooks.open(fileName);
		sheet=workBook.ActiveSheet;
		
		console.log("hospitalDesc="+hospitalDesc);
		console.log(patientInfo);
		excel.Range("D1").Value= hospitalDesc+"手术安全核查表";
		//病人信息	
	    excel.Range("N2").Value= patientInfo.Name;
	    excel.Range("V2").Value= patientInfo.Gender;
	    excel.Range("Y2").Value= patientInfo.Age;
	    excel.Range("D2").Value= patientInfo.Location;
	    excel.Range("D5").Value= operName;
	    excel.Range("U3").Value= operationInfo.OperationDate;
	    excel.Range("D3").Value= patientInfo.MedicareNo;
		excel.Range("M3").Value= operationInfo.Surgeon;
		excel.Range("D4").Value= anaestInfo.AnaMethod;
	    
	    //核对信息(麻醉前)
	    excel.Range("H10").Value=$("#OPS_PatInfoChecking_yes").is(":checked")?"√":"";
		excel.Range("J10").Value=$("#OPS_PatInfoChecking_no").is(":checked")?"√":"";
		excel.Range("H14").Value=$("#OPS_SurgicalProceduresChecking_yes").is(":checked")?"√":"";
		excel.Range("J14").Value=$("#OPS_SurgicalProceduresChecking_no").is(":checked")?"√":"";
		excel.Range("H18").Value=$("#OPS_SurgicalSiteChecking_yes").is(":checked")?"√":"";
		excel.Range("J18").Value=$("#OPS_SurgicalSiteChecking_no").is(":checked")?"√":"";
		excel.Range("H22").Value=$("#OPS_SurgicalSiteMarkChecking_yes").is(":checked")?"√":"";
		excel.Range("J22").Value=$("#OPS_SurgicalSiteMarkChecking_no").is(":checked")?"√":"";
		excel.Range("A27").Value=$("#OPS_SurgicalSiteMarkReason").val();
		excel.Range("H34").Value=$("#OPS_SurgicalConsentChecking_yes").is(":checked")?"√":"";
		excel.Range("J34").Value=$("#OPS_SurgicalConsentChecking_no").is(":checked")?"√":"";
		excel.Range("H38").Value=$("#OPS_ANConsentChecking_yes").is(":checked")?"√":"";
		excel.Range("J38").Value=$("#OPS_ANConsentChecking_no").is(":checked")?"√":"";
		excel.Range("H44").Value=$("#OPS_ANMethodChecking_yes").is(":checked")?"√":"";
		excel.Range("J44").Value=$("#OPS_ANMethodChecking_no").is(":checked")?"√":"";
		excel.Range("H50").Value=$("#OPS_ANEquipChecking_yes").is(":checked")?"√":"";
		excel.Range("J50").Value=$("#OPS_ANEquipChecking_no").is(":checked")?"√":"";
		excel.Range("H56").Value=$("#OPS_SkinIntegralityChecking_yes").is(":checked")?"√":"";
		excel.Range("J56").Value=$("#OPS_SkinIntegralityChecking_no").is(":checked")?"√":"";
		excel.Range("H61").Value=$("#OPS_SkinPreparationChecking_yes").is(":checked")?"√":"";
		excel.Range("J61").Value=$("#OPS_SkinPreparationChecking_no").is(":checked")?"√":"";
		excel.Range("H65").Value=$("#OPS_VeinPassageEstablishesChecking_yes").is(":checked")?"√":"";
		excel.Range("J65").Value=$("#OPS_VeinPassageEstablishesChecking_no").is(":checked")?"√":"";
		excel.Range("H71").Value=$("#OPS_AllergicHistory_yes").is(":checked")?"√":"";
		excel.Range("J71").Value=$("#OPS_AllergicHistory_no").is(":checked")?"√":"";
		excel.Range("H77").Value=$("#OPS_SkinTestResultChecking_yes").is(":checked")?"√":"";
		excel.Range("J77").Value=$("#OPS_SkinTestResultChecking_no").is(":checked")?"√":"";
		excel.Range("H81").Value=$("#OPS_BloodPreparationChecking_yes").is(":checked")?"√":"";
		excel.Range("J81").Value=$("#OPS_BloodPreparationChecking_no").is(":checked")?"√":"";
	    excel.Range("B84").Value=$("#OPS_ProsthesisChecking").is(":checked")?"√":"";
	    excel.Range("E84").Value=$("#OPS_BodyImplantChecking").is(":checked")?"√":"";
	    excel.Range("J84").Value=$("#OPS_MedicalPictureChecking").is(":checked")?"√":"";
	    excel.Range("B87").Value=$("#OPS_PreANOtherChecking").val();
		excel.Range("D89").Value=$("#OPS_SurgeonSign").val();	
	    
	    
	    //核对信息（手术前）
		excel.Range("P10").Value=$("#OPS_PreOPPatInfoChecking_yes").is(":checked")?"√":"";
		excel.Range("R10").Value=$("#OPS_PreOPPatInfoChecking_no").is(":checked")?"√":"";
		excel.Range("P14").Value=$("#OPS_PreOPSurgicalProceduresChecking_yes").is(":checked")?"√":"";
		excel.Range("R14").Value=$("#OPS_PreOPSurgicalProceduresChecking_no").is(":checked")?"√":"";
		excel.Range("P18").Value=$("#OPS_SurgicalSiteAndMarkChecking_yes").is(":checked")?"√":"";
		excel.Range("R18").Value=$("#OPS_SurgicalSiteAndMarkChecking_no").is(":checked")?"√":"";
		
	    excel.Range("R25").Value=$("#OPS_OperEstimatedDurationChecking").is(":checked")?"√":"";
	    excel.Range("R28").Value=$("#OPS_OperEstimatedBleedingVolumeChecking").is(":checked")?"√":"";
	    excel.Range("R31").Value=$("#OPS_OperKeyStepsChecking").is(":checked")?"√":"";
	    excel.Range("R34").Value=$("#OPS_SurgeonOtherStatementChecking").is(":checked")?"√":"";
		
	    excel.Range("R38").Value=$("#OPS_SpecialAttentionChecking").is(":checked")?"√":"";
	    excel.Range("R41").Value=$("#OPS_AnesthetistOtherStatementChecking").is(":checked")?"√":"";
		
	    excel.Range("R47").Value=$("#OPS_DisinfectionChecking").is(":checked")?"√":"";
	    excel.Range("R50").Value=$("#OPS_MachineStateChecking").is(":checked")?"√":"";
	    excel.Range("R53").Value=$("#OPS_SpecialDrugChecking").is(":checked")?"√":"";
	    excel.Range("R56").Value=$("#OPS_SurgeryNurseOtherStatementChecking").is(":checked")?"√":"";
		
	    excel.Range("P61").Value=$("#OPS_PreOPMedicalPictureChecking_yes").is(":checked")?"√":"";
	    excel.Range("R61").Value=$("#OPS_PreOPMedicalPictureChecking_no").is(":checked")?"√":"";
		
	    excel.Range("M87").Value=$("#OPS_PreOPOtherChecking").val();
	    excel.Range("N89").Value=$("#OPS_AnesthetistSign").val();

	    
	    //核对信息（离室前）
	    //患者姓名+20160922+dyl+没对上?
		excel.Range("X10").Value=$("#OPS_PreTOPatInfoChecking_yes").is(":checked")?"√":"";
		excel.Range("Z10").Value=$("#OPS_PreTOPatInfoChecking_no").is(":checked")?"√":"";
		//实际手术
		excel.Range("X14").Value=$("#OPS_PreTOSurgicalProceduresChecking_yes").is(":checked")?"√":"";
		excel.Range("Z14").Value=$("#OPS_PreToSurgicalProceduresChecking_no").is(":checked")?"√":"";
		//手术用药
		excel.Range("X18").Value=$("#OPS_DrugAndBloodChecking_yes").is(":checked")?"√":"";
		excel.Range("Z18").Value=$("#OPS_DrugAndBloodChecking_no").is(":checked")?"√":"";
		//手术用无清点
		excel.Range("X22").Value=$("#OPS_SurgicalInstrumentChecking_yes").is(":checked")?"√":"";
		excel.Range("Z22").Value=$("#OPS_SurgicalInstrumentChecking_no").is(":checked")?"√":"";
		//手术标本
		excel.Range("X28").Value=$("#OPS_SurgicalSpecimensChecking_yes").is(":checked")?"√":"";
		excel.Range("Z28").Value=$("#OPS_SurgicalSpecimensChecking_no").is(":checked")?"√":"";
		//皮肤
		excel.Range("X34").Value=$("#OPS_PreTOSkinIntegralityChecking_yes").is(":checked")?"√":"";
		excel.Range("Z34").Value=$("#OPS_PreTOSkinIntegralityChecking_no").is(":checked")?"√":"";
		
	    excel.Range("Z38").Value=$("#OPS_CatheterChecking_CVC").is(":checked")?"√":"";
	    excel.Range("Z41").Value=$("#OPS_CatheterChecking_Artery").is(":checked")?"√":"";
	    excel.Range("Z44").Value=$("#OPS_CatheterChecking_TrachealIntubation").is(":checked")?"√":"";
	    excel.Range("Z47").Value=$("#OPS_CatheterChecking_WoundDrainage").is(":checked")?"√":"";
	    excel.Range("Z50").Value=$("#OPS_CatheterChecking_StomachTube").is(":checked")?"√":"";
	    excel.Range("Z53").Value=$("#OPS_CatheterChecking_Urine").is(":checked")?"√":"";
		excel.Range("Z56").Value=$("#OPS_CatheterChecking_PeripheralVein").is(":checked")?"√":"";
		excel.Range("Z59").Value=$("#OPS_CatheterChecking_Other").is(":checked")?"√":"";
		excel.Range("V58").Value=$("#OPS_CatheterChecking_Othertext").val();
		
		excel.Range("Z65").Value=$("#OPS_TransChecking_PACU").is(":checked")?"√":"";
		excel.Range("Z68").Value=$("#OPS_TransChecking_Ward").is(":checked")?"√":"";
		excel.Range("Z71").Value=$("#OPS_TransChecking_ICU").is(":checked")?"√":"";
		excel.Range("Z74").Value=$("#OPS_TransChecking_Emergency").is(":checked")?"√":"";
		excel.Range("Z77").Value=$("#OPS_TransChecking_Discharge").is(":checked")?"√":"";
		
		excel.Range("U87").Value=$("#OPS_PreTOOtherChecking").val();
		excel.Range("V89").Value=$("#OPS_OperNurseSign").val();

	    
	    sheet.PrintOut();
	    sheet=null;
	    workBook.Close(savechanges=false);
	    workBook=null;
	}
	catch(e){
		$.messager.alert("错误","未找到打印模板，请确认打印模板的路径是否正确！","error");
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
				text:"已保存"
			});
			$('#btnPreANChecking').linkbutton('disable');


			//$("#btnPreOPChecking").removeClass("c2");
			//$("#btnPreOPChecking").addClass("c5");
			$("#btnPreOPChecking").linkbutton('enable');
			break;
		case "preOP":
			$("#btnPreANChecking").linkbutton({
				text:"已保存"
			});
			$('#btnPreANChecking').linkbutton('disable');
			$("#btnPreOPChecking").linkbutton({
				text:"已保存"
			});
			$("#btnPreOPChecking").linkbutton('disable');
			$("#btnPreTheatreOutChecking").linkbutton('enable');
			break;
		case "preTheatreOut":
			$("#btnPreANChecking").linkbutton({
				text:"已保存"
			});
			$('#btnPreANChecking').linkbutton('disable');
			
			$("#btnPreOPChecking").linkbutton('disable');
			$("#btnPreOPChecking").linkbutton({
				text:"已保存"
			});
		
			$("#btnPreTheatreOutChecking").linkbutton('disable');
			$("#btnPreTheatreOutChecking").linkbutton({
				text:"已保存"
			});
			
			$("#Print").linkbutton('enable');
			break;
		default:
			//标准版要求统一调用默认样式+dyl+20161007
			$("#btnPreANChecking").linkbutton('enable');
			
			$("#btnPreOPChecking").linkbutton('disable');
			
			$("#btnPreTheatreOutChecking").linkbutton('disable');
			
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
				singleValue=$(this).attr("id")+subSplitChar+$(this).checkbox("getValue")+subSplitChar;
				break;
			case "textbox":
			case "text":
				if($(this).attr("id").toUpperCase()==checkingTimeCode.toUpperCase())
				{
					if($(this).val()==""){
						var serverDate= new Date($.ajax({async:false}).getResponseHeader("Date"));	//获取服务器的当前时间
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
		
		//$.post("dhcclinic.jquery.method.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCANOPArrangeExtend",MethodName:"SaveArrangeExtend",Arg1:opaId,Arg2:value,Arg3:userId,ArgCnt:"3"},
		var data=$.m({
            ClassName:"web.DHCANOPArrangeExtend",
            MethodName:"SaveArrangeExtend",
            opaId:opaId,
            paraStr:value,
            userId:userId
        },false)
        if($.trim(data)==""){
            $.messager.alert("提示","成功保存手术安全核查数据！","info",function(){
                currentStatus=OPSStatus;
                setElementDisabled(OPSStatus);
                if(editStatus){
                    setButtonStyle(OPSStatus);
                }
            });
            
        }
        else
        {
            $.messager.alert("错误","保存失败！描述超过限定字数"+data,"error");
        }
	}
	
}


function setElementDisabled(OPSStatus){
	switch(OPSStatus){
		case "preAN":
			$("#preAN").find("input").attr("disabled",true);
			$("#preOP").find("input").attr("disabled",false);
			$("#preTheatreOut").find("input").attr("disabled",true);
			$("#OPS_SurgeonSign").attr("disabled",false)
			$("#OPS_AnesthetistSign").attr("disabled",false)
			$("#OPS_OperNurseSign").attr("disabled",true)
			break;
		case "preOP":
			$("#preAN").find("input").attr("disabled",true);
			$("#preOP").find("input").attr("disabled",true);
			$("#preTheatreOut").find("input").attr("disabled",false);
			$("#OPS_SurgeonSign").attr("disabled",true)
			$("#OPS_AnesthetistSign").attr("disabled",true)
			$("#OPS_OperNurseSign").attr("disabled",false)
			break;
		case "preTheatreOut":
			$("#preAN").find("input").attr("disabled",true);
			$("#preOP").find("input").attr("disabled",true);
			$("#preTheatreOut").find("input").attr("disabled",true);
			$("#OPS_SurgeonSign").attr("disabled",true)
			$("#OPS_AnesthetistSign").attr("disabled",true)
			$("#OPS_OperNurseSign").attr("disabled",true)
			break;
		case "preFirstSave":
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