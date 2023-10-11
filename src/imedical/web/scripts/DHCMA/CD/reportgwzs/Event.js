function InitReportWinEvent(obj) {
	
	obj.LoadEvent = function(){
		obj.LoadListInfo();
		obj.DisplayRepInfo();
		obj.InitRepPowerByStatus(ReportID);
		obj.RelationToEvents(); // 按钮监听事件 
		top.$("#WinModalEasyUI").empty();
		
	}	
	//显示按钮操作权限 根据报告状态与操作权限控制
		obj.InitRepPowerByStatus = function(ReportID){		
		$('#btnSave').hide();
		$('#btnPrint').hide();
		$('#btnCanCheck').hide();
		$('#btnExport').hide();
		$('#btnDelete').hide();
		$('#btnCheck').hide();
		$('#btnCancle').hide();
		$('#btnReturn').hide();
		$('#btnSaveTemp').hide();
		
		obj.RepStatusCode = $m({                  
			ClassName:"DHCMed.CDService.Service",
			MethodName:"GetReportStatus",
			aReportID:ReportID
		},false);
		
     	switch (obj.RepStatusCode) {
			case "" : // 无报告 只能上报
				$('#btnSaveTemp').show();
				$('#btnSave').show();
				$('#btnCancle').show();
				break;
			case "1" : // 待审
				$('#btnSave').linkbutton({text:$g('修改报卡')});
				$('#btnSave').show();
				$('#btnDelete').show();
				$('#btnCheck').show();
				$('#btnExport').show();
				$('#btnPrint').show();
				$('#btnCancle').show();
				if(LocFlag==1){$('#btnReturn').show();}
				break;
			case "2" : // 审核
				$('#btnCanCheck').show();
				$('#btnPrint').show();
				$('#btnExport').show();
				$('#btnCancle').show();
				break;
			case "3" : // 作废
				$('#btnCancle').show();
				break;
			case "4" : // 草稿
				$('#btnSaveTemp').show();
				$('#btnSave').show();
				$('#btnCancle').show();
				break;
			case "5" : // 退回
				$('#btnSave').linkbutton({text:$g('修改报卡')});
				$('#btnSaveTemp').show();
				$('#btnDelete').show();
				$('#btnSave').show();
				$('#btnCancle').show();
				break;
		}
		
		if (tDHCMedMenuOper['Submit']!=1) {//没有提交权限，隐藏保存按钮
			$('#btnSave').hide();
		}
		if (tDHCMedMenuOper['Check']!=1) {//没有审核权限，隐藏审核按钮
			$('#btnCheck').hide();
			$('#btnCanCheck').hide();
		}
		if (tDHCMedMenuOper['Check']) {
			$('#btnDelete').hide();
		}
		$('#btnExport').hide();
	}
	
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			$('#txtReportUser').val(DocName);
			$('#txtReportOrgan').val(HospDesc);
			$('#txtReportDate').datebox('setValue',Common_GetDate(new Date()));
			
			if(PatientID!=""){
				var objPat = $cm({                  
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				
				$('#txtPatName').val(objPat.PatientName);
				$('#txtPatSex').val(objPat.Sex);
				var PersonalIDType=objPat.PersonalIDType;				//证件类型
				if(PersonalIDType!=$g("居民身份证")){
					$('#txtPatCardNo').val("");     
				}
				else{
					$('#txtPatCardNo').val(objPat.PersonalID);                //身份证号
				}
				$('#txtLXDH').val(objPat.Telephone);
			
				var AgeY=objPat.Age;
				var AgeM=objPat.AgeMonth;
				var AgeD=objPat.AgeDay;
				if (AgeY>0){
					$('#txtPatAge').val(objPat.Age);
					$('#cboPatAgeDW').combobox('setValue',$g('岁'));
				}else if(AgeM>0){
					$('#txtPatAge').val(objPat.AgeMonth);
					$('#cboPatAgeDW').combobox('setValue',$g('月'));
				}else if(AgeD>0){
					$('#txtPatAge').val(objPat.AgeDay);
					$('#cboPatAgeDW').combobox('setValue',$g('天'));
				}else{
					$('#txtPatAge').val($g("未知"));
					$('#cboPatAgeDW').combobox('setValue','');
				}
				if (ServerObj.CurrAddress) {// 现地址
					$('#cboProvince1').combobox('setValue',ServerObj.CurrAddress.split("^")[0]);                    
					$('#cboProvince1').combobox('setText',ServerObj.CurrAddress.split("^")[1]);                  
					$('#cboCity1').combobox('setValue',ServerObj.CurrAddress.split("^")[2]);                    
					$('#cboCity1').combobox('setText',ServerObj.CurrAddress.split("^")[3]);                  
					$('#cboCounty1').combobox('setValue',ServerObj.CurrAddress.split("^")[4]);                    
					$('#cboCounty1').combobox('setText',ServerObj.CurrAddress.split("^")[5]);                  
					$('#cboVillage1').combobox('setValue',ServerObj.CurrAddress.split("^")[6]);                    
					$('#cboVillage1').combobox('setText',ServerObj.CurrAddress.split("^")[7]);                  
					$('#txtCUN1').val(ServerObj.CurrAddress.split("^")[8]);    
					$('#txtAdress1').val(ServerObj.PatCurrAddress);
					if (session['LOGON.LANGCODE']=="EN"){
						$('#txtAdress1').val($('#cboProvince1').combobox('getText')+$('#cboCity1').combobox('getText')+$('#cboCounty1').combobox('getText')+$('#cboVillage1').combobox('getText'));
					}
				}	
			}
		}else{
			var objRep = $m({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false);
	
		    var objGWZS = $m({                  
				ClassName:"DHCMed.CD.CRReportGWZS",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			
			var objPat = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			var arrGWZS=objGWZS.split("^");
			var arrPat=objPat.split("^");
			
			$('#txtCRKPBH').val(arrGWZS[0]);
			$('#txtPatName').val(arrPat[4]);
			$('#txtPatCardNo').val(arrPat[11]);
			$('#txtPatSex').val(arrPat[6]);
			var patAge="";
			var patAgeDW="";
			if(arrPat[8]!=""){
				patAge=arrPat[8];
				patAgeDW=$g("岁");
			}else if(arrPat[9]!=""){
				patAge=arrPat[9];
				patAgeDW=$g("月");
			}else if(arrPat[10]!=""){
				 if(arrPat[10]!=$g("未知")){
					patAge=arrPat[10];
					patAgeDW=$g("天");
				 }else{
					 patAge=arrPat[10];
					 patAgeDW="";
				 }
			}
			$('#txtPatAge').val(patAge);
			$('#cboPatAgeDW').combobox('setValue',patAgeDW);
			$('#txtLXDH').val(arrPat[20]);
			
			$('#cboProvince1').combobox('setValue',arrPat[29].split(CHR_1)[0]);
			$('#cboProvince1').combobox('setText',((arrPat[29].indexOf(CHR_1)>-1) ? arrPat[29].split(CHR_1)[1] : ''));
			$('#cboCity1').combobox('setValue',arrPat[30].split(CHR_1)[0]);
		    $('#cboCity1').combobox('setText',((arrPat[30].indexOf(CHR_1)>-1) ? arrPat[30].split(CHR_1)[1] : ''));
			$('#cboCounty1').combobox('setValue',arrPat[31].split(CHR_1)[0]);
			$('#cboCounty1').combobox('setText',((arrPat[31].indexOf(CHR_1)>-1) ? arrPat[31].split(CHR_1)[1] : ''));
			$('#cboVillage1').combobox('setValue',arrPat[32].split(CHR_1)[0]);
			$('#cboVillage1').combobox('setText',((arrPat[32].indexOf(CHR_1)>-1) ? arrPat[32].split(CHR_1)[1] : ''));
	
			$('#txtCUN1').val(arrPat[33]);
			$('#txtAdress1').val(arrPat[34]);
            if (arrGWZS[1].split(CHR_1)[0]) {
				$HUI.radio('#radZSXZList'+arrGWZS[1].split(CHR_1)[0]).setValue(true); //中暑性质
            }
			$('#txtZSDD').val(arrGWZS[2]);  //中暑地点
			$('#txtLCBX').val(arrGWZS[3]);  //临床表现
			if (arrGWZS[4].split(CHR_1)[0]) {
				$HUI.radio('#radZSZDList'+arrGWZS[4].split(CHR_1)[0]).setValue(true);   //中暑诊断
			}
			$('#txtZLGY').val(arrGWZS[5]);  //治疗概要
			if (arrGWZS[6].split(CHR_1)[0]) {
				$HUI.radio('#radZSZGList'+arrGWZS[6].split(CHR_1)[0]).setValue(true);   //中暑转归
			}
			$('#txtZDRQ').datebox('setValue',arrGWZS[7]);
			$('#txtSWRQ').datebox('setValue',arrGWZS[8]);

			$('#txtReportUser').val(arrRep[5]);
			$('#txtReportOrgan').val(arrRep[6]);
			$('#txtReportDate').datebox('setValue',arrRep[7]);
		}
	};
	
	obj.GetRepData = function (step) {
		var RepLoc = "";
		if (obj.ReportID!="") {
			var objRep = $cm({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"GetObjById",
				id:obj.ReportID
			},false);
			RepLoc = objRep.CRReportLoc;
		}
		else{
			RepLoc = session['LOGON.CTLOCID'];
		}
	
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"GWZS";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3作废
		InputStr=InputStr+"^"+RepLoc; //session['LOGON.CTLOCID'];
		InputStr=InputStr+"^"+$.trim($('#txtReportUser').val());
		InputStr=InputStr+"^"+$.trim($('#txtReportOrgan').val());
		InputStr=InputStr+"^"+$('#txtReportDate').datebox('getValue');
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		
		return InputStr;
	}
	
	obj.GetGWZSData = function () {
		var InputStr=obj.ReportID;	
		InputStr=InputStr+"^"+$.trim($('#txtCRKPBH').val());  //0
		InputStr=InputStr+"^"+Common_RadioValue('radZSXZList'); //1
		InputStr=InputStr+"^"+$.trim($('#txtZSDD').val());  //2
		InputStr=InputStr+"^"+$.trim($('#txtLCBX').val());  //3
		InputStr=InputStr+"^"+Common_RadioValue('radZSZDList');  //4
		InputStr=InputStr+"^"+$.trim($('#txtZLGY').val());  //5
		InputStr=InputStr+"^"+Common_RadioValue('radZSZGList');  //6
		InputStr=InputStr+"^"+$('#txtZDRQ').datebox('getValue');  //7
		InputStr=InputStr+"^"+$('#txtSWRQ').datebox('getValue');  //8
		
		return InputStr;
	}
	
	obj.GetPatData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+$.trim($('#txtPatName').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatCardNo').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatSex').val());
		InputStr=InputStr+"^"+$.trim($('#txtPatAge').val());
		InputStr=InputStr+"^"+$.trim($('#cboPatAgeDW').combobox('getValue'));  //7 
		InputStr=InputStr+"^"+$.trim($('#txtLXDH').val());	
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+"";  //10
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+$.trim($('#cboProvince1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboCity1').combobox('getValue')); //13
		InputStr=InputStr+"^"+$.trim($('#cboCounty1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#cboVillage1').combobox('getValue'));
		InputStr=InputStr+"^"+$.trim($('#txtCUN1').val());   //16
		InputStr=InputStr+"^"+$.trim($('#txtAdress1').val());
		
		return InputStr;
	}
	
	// 按钮触发事件
	obj.RelationToEvents = function() {
		$('#btnSave').on("click", function(){
			obj.btnSave_click(); 
		});
		$('#btnSaveTemp').on("click", function(){
			obj.btnSaveTemp_click();
		});
		$('#btnCanCheck').on("click", function(){	//取消审核
			obj.btnCanCheck_click(); 		
		});
		$('#btnDelete').on("click", function(){
			obj.btnDelete_click(); 
		});
		$('#btnCheck').on("click", function(){
			obj.btnCheck_click(); 
		});
		$('#btnExport').on("click", function(){
			obj.btnExport_click(); 
		});
		$('#btnPrint').on("click", function(){
			obj.btnPrint_click(); 
		});
		$('#btnCancle').on("click", function(){
			obj.btnCancle_click(); 
		});
		$('#btnReturn').on("click", function(){
			$.messager.prompt($g("退回"), $g("请输入退回原因")+"!", function (r) {
				if (r){
					obj.btnReturn_click(r); 
				}else if(r==""){
					$.messager.alert($g("提示"),$g("退回原因不能为空")+"!", 'info');
				}			
			});
		});
	}	
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var SHKData=obj.GetGWZSData();
		var PatData=obj.GetPatData();
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:SHKData,
			PatInfo:PatData,
			ExtraInfo:""
		},false);
		
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("数据保存错误")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("数据保存成功")+"!", 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus(obj.ReportID);
			//追加隐藏元素，用于强制报告保存失败时作废诊断
			top.$("#WinModalEasyUI").append("<input type='hidden' id='flag' value='1'>");
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:obj.ReportID
		        });
		    	history.pushState("", "", Url);
		        return;
			}
		}
	};
		// 草稿
	obj.btnSaveTemp_click = function(){
		var RepData=obj.GetRepData(4);
		var SHKData=obj.GetGWZSData();
		var PatData=obj.GetPatData();
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:SHKData,
			PatInfo:PatData,
			ExtraInfo:""
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("草稿数据保存错误")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("草稿数据保存成功")+"！<br>"+$g("请及时完善高温中暑卡信息"), 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus(obj.ReportID);
			//追加隐藏元素，用于强制报告保存失败时作废诊断
			top.$("#WinModalEasyUI").append("<input type='hidden' id='flag' value='1'>");
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:obj.ReportID
		        });
		    	history.pushState("", "", Url);
		        return;
			}
		}
	};
	// 退回
	obj.btnReturn_click = function(r){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'info');
			return;
		}
		var ReturnStr=obj.ReportID;
		ReturnStr=ReturnStr+"^"+5
		ReturnStr=ReturnStr+"^"+session['LOGON.USERID'];
		ReturnStr=ReturnStr+"^"+session['LOGON.CTLOCID'];
		ReturnStr=ReturnStr+"^"+"RETURN";
		console.log(ReturnStr);
		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"ReturnReport",
			aInput:ReturnStr,
			separete:"^",
			aReason:r
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("退回失败")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("退回成功")+"!", 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	}
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("还未上报")+"!", 'error');
			return;
		}
		$.messager.confirm($g("提示"),$g("请确认是否作废")+"?",function(r){
			if(r){
				var DeleteStr=obj.ReportID;
				DeleteStr=DeleteStr+"^"+3
				DeleteStr=DeleteStr+"^"+session['LOGON.USERID'];
				DeleteStr=DeleteStr+"^"+session['LOGON.CTLOCID'];
				DeleteStr=DeleteStr+"^"+"DELETE";
				var ret = $m({                  
					ClassName:"DHCMed.CD.CRReport",
					MethodName:"DeleteReport",
					aInput:DeleteStr,
					separete:"^"
				},false);
			
				if(parseInt(ret)<=0){
					$.messager.alert($g("错误"),$g("作废失败")+"!"+ret, 'error');
					return;
				}else{
					$.messager.alert($g("提示"),$g("报告作废成功")+"!", 'info');
					obj.InitRepPowerByStatus(obj.ReportID);
				}
			}
		});
	};
	
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'info');
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+2
		CheckStr=CheckStr+"^"+session['LOGON.USERID'];
		CheckStr=CheckStr+"^"+session['LOGON.CTLOCID'];

		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"CheckReport",
			aInput:CheckStr,
			separete:"^"
		},false);
				
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("报告审核失败")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("报告审核成功")+"!", 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	};
	//取消审核
	obj.btnCanCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'info');
			return;
		}
		var CanCheckStr=obj.ReportID;
		CanCheckStr=CanCheckStr+"^"+1
		CanCheckStr=CanCheckStr+"^"+session['LOGON.USERID'];
		CanCheckStr=CanCheckStr+"^"+session['LOGON.CTLOCID'];
		CanCheckStr=CanCheckStr+"^"+"CANCHECK";

		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"CanCheckReport",
			aInput:CanCheckStr,
			separete:"^"
		},false);
				
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("取消审核失败")+"!"+ret, 'error');
			return;
		}else{
			$.messager.alert($g("提示"),$g("取消审核成功")+"!", 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	}
	
	obj.btnExport_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("错误"),$g("请先做【上报】操作"), 'error');
			return;
		}
		var ExportStr=obj.ReportID;
		ExportStr=ExportStr+"^"+session['LOGON.USERID'];
		ExportStr=ExportStr+"^"+session['LOGON.CTLOCID'];
		ExportStr=ExportStr+"^"+"EXPORT";
		
		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"ExportReport",
			aInput:ExportStr,
			separete:"^"
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("错误"),$g("报告导出失败")+"!"+ret, 'error');
			return;
		}else{
			//var cArguments=obj.ReportID;
			//var flg=ExportDataToExcel("","","高温中暑报告卡("+$.trim($('#txtPatName').val())+")",cArguments);
			var fileName="DHCMA_CD_PrintReportGWZS.raq&aReportID="+obj.ReportID+"&aUserID="+session['LOGON.USERID']+"&aLocID="+session['LOGON.CTLOCID'];
			DHCCPM_RQPrint(fileName);
		}
	};
	obj.btnPrint_click = function(){
		if (obj.ReportID==""){
			$.messager.alert($g("提示"),$g("打印失败！找不到这份报告") , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintCDGWZSReport");		//打印任务的名称
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
		LodopPrintURL(LODOP,"dhcma.cd.lodopgwzs.csp?ReportID="+obj.ReportID);
		LODOP.PRINT();			//直接打印
	};
	obj.btnCancle_click = function(){
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //关闭
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
	};
	
	//检查规范
	obj.CheckReport = function(){
		var errStr = "";
		
		if ($.trim($('#txtPatName').val()) == "") {
			errStr += $g("姓名不允许为空")+"!<br>"		//姓名
		}
		if ($.trim($('#txtPatSex').val()) == "") {
			errStr += $g("性别不允许为空")+"!<br>"		    //性别
		}
		if ($.trim($('#txtPatAge').val()) == "") {
			errStr += $g("年龄不允许为空")+"!<br>"		    //年龄
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			errStr += $g("身份证号不允许为空")+"!<br>"		//身份证号
		}
		// 身份证格式验证	
		if ($.trim($('#txtPatCardNo').val()) != ""){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test($.trim($('#txtPatCardNo').val())))) {
				errStr += $g('输入的身份证号格式不符合规定！请重新输入')+'!<br>'
			}
		}
		if ($.trim($('#txtLXDH').val()) == "") {
			errStr += $g("联系电话不允许为空")+"!<br>"		//联系电话
		}  
		
		//电话号码格式验证 !(/^([0-9]{3,4}-)?[0-9]{7,8}$/.test(phone))
		if ($.trim($('#txtLXDH').val()) != ""){
			if (!(/^1[3456789]\d{9}$/.test($.trim($('#txtLXDH').val())))) {
				errStr += $g('输入的电话号码格式不符合规定！请重新输入')+'!<br>'
			}
		}
		if ($.trim($('#cboProvince1').combobox('getValue')) == "") {
			errStr += $g("请选择联系地址省")+"!<br>"		//省
		}
		if ($.trim($('#cboCity1').combobox('getValue')) == "") {
			errStr += $g("请选择联系地址市")+"!<br>"		//市
		}
		if ($.trim($('#cboCounty1').combobox('getValue')) == "") {
			errStr += $g("请选择联系地址县")+"!<br>"		//县
		}
		if ($.trim($('#cboVillage1').combobox('getValue')) == "") {
			errStr += $g("请选择联系地址乡/镇")+"!<br>"      //乡
		}
		if ($.trim($('#txtCUN1').val()) == "") {
			errStr += $g("村不允许为空")+"!<br>"		        //村
		}  
		if ($.trim($('#txtAdress1').val()) == "") {
			errStr += $g("详细地址不允许为空")+"!<br>"		//详细地址		
		}  
		if ($.trim($('#txtZSDD').val()) == "") {
			errStr += $g("中暑地点不允许为空")+"!<br>"	//中暑地点		
		}
		if ($.trim($('#txtLCBX').val()) == "") {
			errStr += $g("临床表现不允许为空")+"!<br>"	//临床表现		
		}		  
		if (Common_RadioValue('radZSXZList') == "") {
			errStr += $g("中暑性质不允许为空")+"!<br>"		//中暑性质		
		}  
		if (Common_RadioValue('radZSZDList') == "") {
			errStr += $g("中暑诊断不允许为空")+"!<br>"		//中暑诊断	
		}
		if ($.trim($('#txtZLGY').val()) == "") {
			errStr += $g("治疗概要不允许为空")+"!<br>"	//治疗概要		
		}		 
		if (Common_RadioValue('radZSZGList') == "") {
			errStr += $g("转归不允许为空")+"!<br>"		    //转归		
		}  
		if ($('#txtZDRQ').datebox('getValue') == "") {
			errStr += $g("诊断日期不允许为空")+"!<br>"		//诊断日期		
		}
		var NowDate = Common_GetDate(new Date());
		var txtZDRQ = $('#txtZDRQ').datebox('getValue');
		var txtSWRQ = $('#txtSWRQ').datebox('getValue');
		if (Common_CompareDate(txtZDRQ,NowDate)>0) {
			errStr += $g('诊断日期不允许大于当前日期')+'!<br>'			
		}
		if ((Common_RadioLabel('radZSZGList')!='死亡')&&(txtSWRQ !="")){
			errStr += $g('填写了死亡日期，请确认转归')+'!<br>'
		}
		if (Common_RadioLabel('radZSZGList')=='死亡') {
			if (txtSWRQ=="") {
				errStr += $g('填写转归为死亡，请填写死亡日期')+'!<br>'
			}
			else {
				if (Common_CompareDate(txtSWRQ,NowDate)>0) { 
					errStr += $g('死亡日期不允许大于当前日期')+'!<br>'
				}
				if (Common_CompareDate(txtZDRQ,txtSWRQ)>0) { 
					errStr += $g('死亡日期不能小于诊断日期')+'!<br>'
				}
			}
		}
		
		if(errStr != "") {
			$.messager.alert($g("提示"), errStr, 'info');
			return false;
		}
		return true;
	}

}


