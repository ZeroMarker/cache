function InitReportWinEvent(obj){

	//obj.PatRegNum="DHCMed.Base.Patient".GetObjById(PatientID).PapmiNo;         //获取病人登记号14-1
	var curAddress="";
	obj.LoadEvent = function(args)
	{
		
		//村失去焦点事件
		$("#txtERCurrVillage").bind('input propertychange',function(){
			$('#txtERCurrAddress').val($('#cboERCurrProvince').combobox('getText')+$('#cboERCurrCity').combobox('getText')+$('#cboERCurrCounty').combobox('getText')+$('#cboERCurrTown').combobox('getText')+$('#txtERCurrVillage').val());
		})
		$("#btnSave").on("click",obj.btnSave_click);
		$("#btnDelete").on("click",obj.btnDelete_click);
		$("#btnCheck").on("click",obj.btnCheck_click);
		$("#btnUnCheck").on("click",obj.btnUnCheck_click);
		$("#btnExport").on("click",obj.btnExport_click);
		$("#btnPrint").on("click",obj.btnPrint_click);
		$("#btnCancle").on("click",obj.btnCancle_click);
		
		obj.DisplayRepInfo();
		obj.InitRepPowerByStatus();
		
		
	}
	obj.DisplayRepInfo = function() {
		if(obj.ReportID==""){
			var LogLocID = session['LOGON.CTLOCID'];
			var objLoc = $cm({                 
			ClassName:"DHCMed.Base.Ctloc",
			MethodName:"GetObjById",
			ctloc:LogLocID
			},false);
			
			if(objLoc.Rowid){
				$("#cboERAdmLoc").combobox("setValue",objLoc.Rowid)
			}else{
				$("#cboERAdmLoc").combobox("setValue",objLoc.Descs);
			}
			$("#txtERDoctorName").val(DocName);
			$("#txtERHospitalName").val(HospDesc);
			if(PatientID!=""){
				var objPat = $cm({                 
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				$("#txtERRegNo").val(objPat.PapmiNo);
				$("#txtERPatName").val(objPat.PatientName);
				$("#txtERPatSex").val(objPat.Sex);
				if(objPat.Age!="0"){					
					$("#txtPatAge").val(objPat.Age);
					$("#cboPatAgeDW").combobox("setValue",$g("岁"));
				}else if(objPat.AgeMonth!="0"){
					$("#txtPatAge").val(objPat.AgeMonth);
					$("#cboPatAgeDW").combobox("setValue",$g("月"));
				}else{
					$("#txtPatAge").val(objPat.AgeDay);
					$("#cboPatAgeDW").combobox("setValue",$g("天"));
				}
				$("#txtERTelephone").val(objPat.Telephone);
				$("#txtERCurrAddress").val(objPat.Address);	
				var Address=obj.EpdInitAddressByLocalHospital.split("`")
				$("#cboERCurrProvince").combobox("setValue",Address[0].split("^")[0]);
				$("#cboERCurrProvince").combobox("setText",Address[0].split("^")[1]);
				$("#cboERCurrCity").combobox("setValue",Address[1].split("^")[0]);
				$("#cboERCurrCity").combobox("setText",Address[1].split("^")[1]);
				$("#cboERCurrCounty").combobox("setValue",Address[2].split("^")[0]);
				$("#cboERCurrCounty").combobox("setText",Address[2].split("^")[1]);
			}
		}else{
			var objRep=$m({                 
				ClassName:"DHCMed.EPD.ERReportILI",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false);
			
			var arrRep=objRep.split("^");
			
			$("#txtERReportNum").val(arrRep[0]);
			$("#txtERRegNo").val(arrRep[3]);
			$("#txtERPatName").val(arrRep[4]);
			$("#txtERPatSex").val(arrRep[5]);
			if(arrRep[7]!=""){
				$("#txtPatAge").val(arrRep[7])
				$("#cboPatAgeDW").combobox("setValue","岁")
			}else if(arrRep[8]!=""){
				$("#txtPatAge").val(arrRep[8])
				$("#cboPatAgeDW").combobox("setValue","月")
			}else if(arrRep[9]!=""){
				$("#txtPatAge").val(arrRep[9])
				$("#cboPatAgeDW").combobox("setValue","天")
			}
			
			$("#txtERTelephone").val(arrRep[16]);
			$("#txtERParent").val(arrRep[17]);
			
			
			$("#cboERCurrProvince").combobox("setValue",arrRep[11].split(CHR_1)[0]);
			$("#cboERCurrProvince").combobox("setText",arrRep[11].split(CHR_1)[1]);
			$("#cboERCurrCity").combobox("setValue",arrRep[12].split(CHR_1)[0]);
			$("#cboERCurrCity").combobox("setText",arrRep[12].split(CHR_1)[1]);
			$("#cboERCurrCounty").combobox("setValue",arrRep[13].split(CHR_1)[0]);
			$("#cboERCurrCounty").combobox("setText",arrRep[13].split(CHR_1)[1]);
			$("#cboERCurrTown").combobox("setValue",arrRep[14].split(CHR_1)[0]);
			$("#cboERCurrTown").combobox("setText",arrRep[14].split(CHR_1)[1]);
			$("#txtERCurrVillage").val(arrRep[15]);
			$("#txtERCurrAddress").val(arrRep[10]);
			$("#cboERSpecimenType").combobox("setValue",arrRep[24].split(CHR_1)[0])//,arrRep[24].split(CHR_1)[1]);
			$("#cboERSpecimenType").combobox("setText",arrRep[24].split(CHR_1)[1])
			$("#txtERSpecimenClnArea").val(arrRep[26]);
			$("#cboERSpecimenSource").combobox("setValue",arrRep[25].split(CHR_1)[0])//,arrRep[25].split(CHR_1)[1]);
			$("#cboERSpecimenSource").combobox("setText",arrRep[25].split(CHR_1)[1])
			$("#txtERIncident").val(arrRep[34]);
			
			$("#txtERSickDate").datebox("setValue",arrRep[20]);
			$("#txtERAdmDate").datebox("setValue",arrRep[21]);
			$("#txtERRepDate").datebox("setValue",arrRep[22]);
			$("#cboERAdmLoc").combobox("setValue",arrRep[27])//,arrRep[28]);
			$("#txtERDoctorName").val(arrRep[18]);
			$("#txtERHospitalName").val(arrRep[29]);
			
		}	
	};
	//显示按钮操作权限 根据报告状态与操作权限控制
	obj.InitRepPowerByStatus = function(){
		$('#btnSave').hide();		  
		$('#btnPrint').hide();	      
		$('#btnExport').hide();	  
		$('#btnDelete').hide();      
		$('#btnCheck').hide();
		$('#btnUnCheck').hide();			
		$('#btnCancle').hide();      
		obj.RepStatusCode=$m({      //返回报告状态代码            
			ClassName:"DHCMed.EPD.ERReportILI",
			MethodName:"GetReportStatus",
			aReportID:obj.ReportID
		},false);
		
     	switch (obj.RepStatusCode) {
			case "" : // 无报告 只能上报
				$('#btnSave').show();	
				$('#btnCancle').show(); 
				break;
			case "1" : // 待审
				$('#btnSave').linkbutton({text:'修改报卡'});
				$('#btnSave').show();		  
				$('#btnPrint').show();	      
				$('#btnExport').show();	  
				$('#btnDelete').show();      
				$('#btnCheck').show();	     
				$('#btnCancle').show(); 
				break;
			case "2" : // 审核
				$('#btnPrint').show();	      
				$('#btnExport').show();	
				$('#btnUnCheck').show();
				$('#btnCancle').show(); 
				break;
			case "3" : // 删除
				$('#btnCancle').show(); 
				break;
		}
		
		if (tDHCMedMenuOper['Submit']!=1) {
			$('#btnSave').show();
		}
		if (tDHCMedMenuOper['Check']!=1) {
			$('#btnCheck').hide();
			$('#btnUnCheck').hide();
		}
		if (tDHCMedMenuOper['Print']!=1) {
			$('#btnPrint').hide();   
			$('#btnExport').hide();
		}
		$('#btnExport').hide();         //隐藏导出按钮
	}
	
	
	obj.GetRepData = function (step) {
		var InputStr = obj.ReportID;                          //报告ID,非编号
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+"ILI";   
		InputStr=InputStr+"^"+step;
		InputStr=InputStr+"^"+$("#txtERRegNo").val() //添加登记号		
		InputStr=InputStr+"^"+$("#txtERPatName").val();
		InputStr=InputStr+"^"+$("#txtERPatSex").val();
		InputStr=InputStr+"^"+$("#txtPatAge").val();
		InputStr=InputStr+"^"+$("#cboPatAgeDW").combobox("getValue");             //10
		InputStr=InputStr+"^"+$("#txtERTelephone").val();
		InputStr=InputStr+"^"+$("#txtERParent").val();
		InputStr=InputStr+"^"+$("#cboERCurrProvince").combobox("getValue");
		InputStr=InputStr+"^"+$("#cboERCurrCity").combobox("getValue");
		InputStr=InputStr+"^"+$("#cboERCurrCounty").combobox("getValue");
		InputStr=InputStr+"^"+$("#cboERCurrTown").combobox("getValue");
		InputStr=InputStr+"^"+$("#txtERCurrVillage").val();
		InputStr=InputStr+"^"+$("#txtERCurrAddress").val();         //18
		
		InputStr=InputStr+"^"+$("#cboERSpecimenType").combobox("getValue");
		InputStr=InputStr+"^"+$("#txtERSpecimenClnArea").val();
		InputStr=InputStr+"^"+$("#cboERSpecimenSource").combobox("getValue");
		InputStr=InputStr+"^"+$("#txtERIncident").val();
		InputStr=InputStr+"^"+$("#txtERSickDate").datebox("getValue");           //23
		InputStr=InputStr+"^"+$("#txtERAdmDate").datebox("getValue");
		InputStr=InputStr+"^"+$("#cboERAdmLoc").combobox("getValue");
		InputStr=InputStr+"^"+$("#txtERDoctorName").val();
		InputStr=InputStr+"^"+$("#txtERHospitalName").val();
		InputStr=InputStr+"^"+$("#txtERReportNum").val();     //28
		
		return InputStr;		
	}
	obj.btnSave_click = function(){
		if(obj.CheckReport() !=true) return;
		var RepData=obj.GetRepData(1);      //参数为“1”，表示上报
		var ret=$m({                 
			ClassName:"DHCMed.EPDService.ILIUpadateService",
			MethodName:"SaveRepData",
			RepInfo:RepData
		},false);
	
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("数据保存错误!")+ret,"info");
			return;
		}else{
			$.messager.alert($g("提示"),$g("数据保存成功!"),"info");
			obj.ReportID=ret;
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus();			
		}
	}
	obj.btnDelete_click = function(){
		
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("还未上报!"));
			return;
		}
		$.messager.confirm($g("提示"),$g("请确认是否删除?"),function(btn){
			if(btn){
				var DeleteStr=obj.ReportID;
				DeleteStr=DeleteStr+"^"+3;    //为"3",删除状态
				DeleteStr=DeleteStr+"^"+session['LOGON.USERID'];
				DeleteStr=DeleteStr+"^"+session['LOGON.CTLOCID'];
				DeleteStr=DeleteStr+"^"+"DELETE";
				var ret=$m({                 
					ClassName:"DHCMed.EPD.ERReportILI",
					MethodName:"DeleteReport",
					aInput:DeleteStr,
					separete:"^"
				},false);
				
				if(parseInt(ret)<=0){
					$.messager.alert($g("错误"),$g("删除失败!")+ret,"info");
					return;
				}else{
					$.messager.alert($g("提示"),$g("报告删除成功!"),"info");
					obj.InitRepPowerByStatus();			
				}
			}

		});
	};
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"));
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+2
		CheckStr=CheckStr+"^"+session['LOGON.USERID'];
		CheckStr=CheckStr+"^"+session['LOGON.CTLOCID'];
		var ret=$m({                 
			ClassName:"DHCMed.EPD.ERReportILI",
			MethodName:"CheckReport",
			aInput:CheckStr,
			separete:"^"
		},false);
		
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("报告审核失败!")+ret,"info");
			//return;
		}else{
			
			$.messager.alert($g("提示"),$g("报告审核成功!"),"info");
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus();	
		}
	}
	obj.btnUnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"),"info");
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+1
		CheckStr=CheckStr+"^"+session['LOGON.USERID'];
		CheckStr=CheckStr+"^"+session['LOGON.CTLOCID'];
		var ret=$m({                 
			ClassName:"DHCMed.EPD.ERReportILI",
			MethodName:"CheckReport",
			aInput:CheckStr,
			separete:"^"
		},false);
		
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("报告取消审核失败!")+ret,"info");
			//return;
		}else{
			
			$.messager.alert($g("提示"),$g("报告取消审核成功!"),"info");
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus();	
		}
	}
	obj.btnExport_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"),"info");
			return;
		}
		var ExportStr=obj.ReportID;
		ExportStr=ExportStr+"^"+session['LOGON.USERID'];
		ExportStr=ExportStr+"^"+session['LOGON.CTLOCID'];
		ExportStr=ExportStr+"^"+"EXPORT";
		var ret=$m({                 
			ClassName:"DHCMed.EPD.ERReportILI",
			MethodName:"ExportReport",
			aInput:ExportStr,
			separete:"^"
		},false);
		
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("报告导出失败!")+ret,"info");
			return;
		}else{
			var cArguments=obj.ReportID;
			//var flg=ExportDataToExcel("","","流感样病例标本登记表("+$("#txtERPatName").val()+")",cArguments);
			var fileName="DHCMA_EPD_PrintRepILI.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
			DHCCPM_RQPrint(fileName);
		}
	}	
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"));
			return;
		}
		var PrintStr=obj.ReportID;
		PrintStr=PrintStr+"^"+session['LOGON.USERID'];
		PrintStr=PrintStr+"^"+session['LOGON.CTLOCID'];
		PrintStr=PrintStr+"^"+"PRINT";
		var ret=$m({                 
			ClassName:"DHCMed.EPD.ERReportILI",
			MethodName:"ExportReport",
			aInput:PrintStr,
			separete:"^"
		},false);
		
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("报告打印失败!")+ret,"info");
			return;
		}else{
			var cArguments=obj.ReportID;
			//var flg=PrintDataToExcel("","","流感样病例标本登记表("+$("#txtERPatName").val()+")",cArguments);
			//var fileName="{DHCMA_EPD_PrintRepILI.raq(aReportID="+obj.ReportID+")}";
			var fileName="DHCMA_EPD_PrintRepILI.raq&aReportID="+obj.ReportID;
			DHCCPM_RQPrint(fileName);
		}
	}
	obj.btnCancle_click =function(){
		websys_showModal('close');
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //关闭
	};
	//检查数据有效性
	obj.CheckReport = function(){
		var errStr = "";
		if(!$('#txtERRegNo').val())errStr +=   $g("登记号不能为空!")+"<br>";
		if(!$('#txtERPatName').val())errStr +=   $g("姓名不能为空!")+"<br>";
		if(!$('#txtERPatSex').val())errStr +=   $g("性别不能为空!")+"<br>";
		if(!$('#cboERCurrProvince').combobox("getValue"))errStr +=   $g("省地址不能为空!")+"<br>";
		if(!$('#cboERCurrCity').combobox("getValue"))errStr +=   $g("市地址不能为空!")+"<br>";
		if(!$('#cboERCurrCounty').combobox("getValue"))errStr +=   $g("县地址不能为空!")+"<br>";
		if(!$('#cboERCurrTown').combobox("getValue"))errStr +=   $g("乡地址不能为空!")+"<br>";
		if(!$('#txtERCurrVillage').val())errStr +=   $g("村地址不能为空!")+"<br>";
		//errStr +=obj.ValidateControl(obj.txtERCurrVillage));    //村
		if(!$('#txtERCurrAddress').val())errStr +=   $g("居住详细地址不能为空!")+"<br>";
		if(!$('#cboERSpecimenType').combobox("getValue"))errStr +=   $g("标本类型不能为空!")+"<br>";
		if(!$('#txtERSpecimenClnArea').val())errStr +=   $g("标本采集地不能为空!")+"<br>";
		if(!$('#cboERSpecimenSource').combobox("getValue"))errStr +=   $g("标本来源不能为空!")+"<br>";
		if(!$('#txtERSickDate').datebox("getValue"))errStr +=   $g("发病日期不能为空!")+"<br>";
		if(!$('#txtERAdmDate').datebox("getValue"))errStr +=   $g("就诊日期不能为空!")+"<br>";
		if(!$('#cboERAdmLoc').combobox("getValue"))errStr +=   $g("就诊科室不能为空!")+"<br>";
		if(!$('#txtERDoctorName').val())errStr +=   $g("就诊医生不能为空!")+"<br>";
		if((($("#cboPatAgeDW").combobox("getValue")!=$g("岁"))||($("#txtPatAge").val()<=14))&&($("#txtERParent").val()==""))errStr +=   $g("儿童患者家长姓名不能为空!")+"<br>";
		

		var startDate =$('#txtERSickDate').datebox("getValue")
		var endDate =$('#txtERAdmDate').datebox("getValue");
		if(Common_CompareDate(startDate,endDate)>0){
			errStr += $g("发病日期不能大于就诊日期!")+"<br>";
		}
		var endSickDate=$('#txtERRepDate').datebox("getValue");
		if (Common_CompareDate(startDate,endSickDate)>0){
			errStr += $g("发病日期不能大于上报日期!")+"<br>";
		}
		if(Common_CompareDateToNum(startDate,endSickDate)<0){
			errStr += $g("发病日期应在上报日期三天内!")+"<br>";
			}
		if(($('#cboERSpecimenSource').combobox("getText")==$g("流感样病例暴发监测"))&&($('#txtERIncident').val() == "")){
			errStr += $g("需填写暴发事件名称!")
		}	
		if(errStr != "")
		{
			$.messager.alert($g("提示"), errStr, 'info');
			return false;
		}
		return true;
	}
	
}