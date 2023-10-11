//页面Event
function InitHandHyRegWinEvent(obj) {
    obj.HandRegID = "";
	
    obj.LoadEvent = function (args) {  
	    //默认医生护士等非管理员权限只能填写或修改当月数据 0为无限制 1为医生护士等非管理员权限只能填写或修改当月数据
		var IsHandHyRegUpdate = $m({
			ClassName: "DHCHAI.BT.Config",
			MethodName: "GetValByCode",
			aCode: "IsHandHyRegUpdate"
			}, false);
		if(IsHandHyRegUpdate=="1"){
			//默认医生护士等非管理员权限只能填写或修改当月数据
			//管理员权限
			var CheckFlg = 0;
			if (tDHCMedMenuOper['Admin'] == 1) {
				CheckFlg = 1; 
				}
			if(CheckFlg == 0){
				var my_date = new Date();
				var first_date = new Date(my_date.getFullYear(), my_date.getMonth(), 1);
				var last_date = new Date(my_date.getFullYear(), my_date.getMonth() + 1, 0);
				var opt = $("#ObsDate").datebox('options');
				opt.minDate = opt.formatter(first_date); 
				opt.maxDate = opt.formatter(last_date); 
			}	
		}	  
		if (!obj.RegID) {
			 /* 渲染下拉框 */
			obj.cboHospital = Common_ComboToSSHosp("cboHospital", $.LOGON.HOSPID);  //医院
			obj.cboObsType = obj.refreshDicID("cboObsType", "HandHyObsMethod");    //调查方式
			obj.cboObsPage = obj.refreshDicID("cboObsPage", "HandHyObsPage");  //调查页
			obj.ObsDate = $('#ObsDate').datebox('setValue', Common_GetDate(new Date()));  // 调查日期
			//取登录人的翻译
			obj.USERDESCLng = $m({          //当前页(默认最后一页)
		        ClassName: "DHCHAI.Abstract",
		        MethodName: "HAIGetTranByDesc",
		        aProp: "SSUSRName"
		        ,aDesc:$.LOGON.USERDESC
		        ,aClassName:"User.SSUser"
		    }, false);
			obj.txtObsUser = $('#txtObsUser').val(obj.USERDESCLng);    //调查人
			$("#btnDelete").hide();
			$("#btnPrint").hide();
		}else {
			obj.refreshgridHandHyReg();
		}
    }
    //院区点击事件
    $HUI.combobox('#cboHospital', {
        onSelect: function (data) {
           Common_ComboToLoc("cboObsLoc", data.ID, "", "", ""); //初始化病区
        }
    });
    //病区改变事件
    $HUI.combobox('#cboObsLoc', {
        onSelect: function () {
			if (($('#ObsDate').datebox('getValue'))&&($('#cboObsType').combobox('getValue'))&&($('#cboObsPage').combobox('getValue'))) {
				obj.refreshgridHandHyReg();  //刷新表格
			}
        }
    });
    //页码改变事件
    $HUI.combobox('#cboObsPage', {
        onSelect: function (row) {
			if (($('#cboObsLoc').combobox('getValue'))&&($('#cboObsType').combobox('getValue'))&&($('#ObsDate').datebox('getValue'))) {
				obj.refreshgridHandHyReg();  //刷新表格
			}
        }
    });
    //日期改变事件
    $HUI.datebox('#ObsDate', {
        onChange: function (newValue, oldValue) {
			if (($('#cboObsLoc').combobox('getValue'))&&($('#cboObsType').combobox('getValue'))&&($('#cboObsPage').combobox('getValue'))) {
				obj.refreshgridHandHyReg();  //刷新表格
			}
        }
    })
	//调查方式改变事件
    $HUI.combobox('#cboObsType', {
        onSelect: function (row) {
			var ObsPage = row.DicDesc;
			if ((!$('#cboObsLoc').combobox('getValue'))) {   //初始自查科室为登录科室
				$('#cboObsLoc').combobox('setValue',$.LOGON.LOCID);
			}
			if (($('#cboObsLoc').combobox('getValue'))&&($('#ObsDate').datebox('getValue'))&&($('#cboObsPage').datebox('getValue'))) {
				obj.refreshgridHandHyReg();  //刷新表格
			}
        }
    })
	
    //刷新表
    obj.refreshgridHandHyReg = function () {
		if (!obj.RegID) {
			var HospitalDr = $('#cboHospital').combobox('getValue'); 
			var ObsLocDr = $('#cboObsLoc').combobox('getValue'); 
			var ObsMethod = $('#cboObsType').combobox('getValue'); 
			var ObsPage = $('#cboObsPage').combobox('getValue'); 
			var ObsDate = $('#ObsDate').datebox('getValue');
			var ObsUser = $('#txtObsUser').val();
		} else{
			var ObsLocDr = obj.ObsLocID; 
			var ObsMethod = obj.ObsMethod; 
			var ObsPage = obj.ObsPage; 
			var ObsDate = obj.ObsDate;
			var ObsUser = obj.ObsUser;
		}
		if ((ObsLocDr=="")||(ObsMethod=="")||(ObsPage=="")||(ObsDate=="")) {
			return;
		}
		
        var flg = $m({
            ClassName: "DHCHAI.IR.HandHyReg",
            MethodName: "GetIDByLocDate",
            aLocDr: ObsLocDr,
            aObsDate: ObsDate,
            aObsPageDr: ObsPage,
			aObsMethodDr: ObsMethod
        }, false);
		
        if (parseInt(flg) > 0) {
            obj.HandRegID = parseInt(flg);
            $("#btnDelete").show();
			if (ServerObj.RegVer=='2') {
				$("#btnPrint").show();
			}else {
				$("#btnPrint").hide();
			}
        } else {
            obj.HandRegID = "";
            $("#btnDelete").hide();
			$("#btnPrint").hide();
        }
        obj.gridHandHyReg.load({
            ClassName: "DHCHAI.IRS.HandHyRegSrv",
            QueryName: "QryHandHyReg",
            aLocID: ObsLocDr,
            aCheckDate: ObsDate,
            aObsPageID: ObsPage,
			aObsMethodID: ObsMethod
        })
    }
    //保存
    $("#btnSave").on('click', function () {
		if (!obj.RegID) {
			var HospitalDr = $('#cboHospital').combobox('getValue'); 
			var ObsLocDr = $('#cboObsLoc').combobox('getValue'); 
			var ObsMethod = $('#cboObsType').combobox('getValue'); 
			var ObsPage = $('#cboObsPage').combobox('getValue'); 
			var ObsDate = $('#ObsDate').datebox('getValue');
			var ObsUser = $('#txtObsUser').val();
		}else {
			var ObsLocDr = obj.ObsLocID; 
			var ObsMethod = obj.ObsMethod; 
			var ObsPage = obj.ObsPage; 
			var ObsDate = obj.ObsDate;
			var ObsUser = obj.ObsUser;
		}
	 
        if (ObsLocDr == '') {
            $.messager.alert("提示", "调查病区不允许为空!", 'info');
            return;
        }
        if (ObsMethod == '') {
            $.messager.alert("提示", "调查方式不允许为空!", 'info');
            return;
        }
        if (ObsPage == '') {
            $.messager.alert("提示", "调查页不允许为空!", 'info');
            return;
        }
        if (ObsDate == '') {
            $.messager.alert("提示", "调查月份不允许为空!", 'info');
            return;
        }
        if (ObsUser == '') {
            $.messager.alert("提示", "调查人不允许为空!", 'info');
            return;
        }

		var HandHyRegTim = obj.CheckInputData();	
        if (!HandHyRegTim) {
            return;
        }
		if (HandHyRegTim=="") {
            $.messager.alert("提示", '手卫生调查信息为空!', 'info');
            return;
        }else {
			HandHyRegTim = HandHyRegTim.join("#");
		}
        var HandHyRegCnt = obj.CheckCntData();
		if (!HandHyRegCnt) {
            return;
        }	
	
	    var InputStr = obj.HandRegID;
        InputStr += "^" + ObsLocDr;        // 调查科室病区
        InputStr += "^" + ObsMethod;       // 调查类型（自查/督察）
        InputStr += "^" + ObsPage;         // 调查第几页
        InputStr += "^" + ObsDate;         // 调查月份
        InputStr += "^" + ObsUser;         // 调查人
        InputStr += "^" + "1";             // 是否有效
        InputStr += "^" + "";              // 登记日期
        InputStr += "^" + "";              // 登记时间
        InputStr += "^" + $.LOGON.USERID;  // 登记人
	  
        var flg = $m({
            ClassName: "DHCHAI.IRS.HandHyRegSrv",
            MethodName: "SaveHandHyReg",
            aInputStr: InputStr,
            aInputRegTim: HandHyRegTim,
            aInputRegCnt: HandHyRegCnt
        }, false);
     
        if (parseInt(flg) < 0) {
            if (parseInt(flg) == "-101") {
                $.messager.alert("提示", '手卫生报告信息保存失败!', 'info');
                return;
            } else if (parseInt(flg) == "-102") {
                $.messager.alert("提示", '手卫生调查时机信息保存失败!', 'info');
                return;
            } else if (parseInt(flg) == "-103") {
                $.messager.alert("提示", '手卫生调查人信息保存失败!', 'info');
                return;
            } else {
                $.messager.alert("提示", '保存失败!', 'info');
                return;
            }
        } else {
            obj.HandRegID = parseInt(flg);
			$("#btnDelete").show();
			if (ServerObj.RegVer=='2') {
				$("#btnPrint").show();
			}
            obj.refreshgridHandHyReg();
            $.messager.alert("提示", '保存成功!', 'info');
        }
    })
	
	// 手卫生调查时机
	obj.CheckInputData = function (){
		var arrResult = new Array();
        var rows = $('#gridHandHyReg').datagrid('getRows');
		if (ServerObj.RegVer!='2') {
			var ObsTypeID1 = $('#ObsTypeID1').val(); 
			var ObsTypeID2 = $('#ObsTypeID2').val(); 
			var ObsTypeID3 = $('#ObsTypeID3').val(); 
			var ObsTypeID4 = $('#ObsTypeID4').val();	
			
			for (var row = 0; row < rows.length; row++) {
				var rd = rows[row];
				var val = getItemValues(rd['Cmp1'])+",Type-"+ObsTypeID1+",Name-"+""+",Sign-A";
				var texts = getItemTexts(rd['Cmp1']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("提示", "第" + (row + 1) + "行第2、3列,请选择指征和手卫生行为,否则系统作为无效记录!", 'info');              
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",病人后,") >= 0) && (("," + texts + ",").indexOf(",环境后,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第2列,病人后、环境后不可同时选择!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",无,") >= 0) && (("," + texts + ",").indexOf(",正确,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第3列,无、正确不可同时选择!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp2'])+",Type-"+ObsTypeID1+",Name-"+""+",Sign-A";
				var texts = getItemTexts(rd['Cmp2']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("提示", "第" + (row + 1) + "行第5、6列,请选择指征和手卫生行为,否则系统作为无效记录!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",病人后,") >= 0) && (("," + texts + ",").indexOf(",环境后,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第5列,病人后、环境后不可同时选择!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",无,") >= 0) && (("," + texts + ",").indexOf(",正确,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第6列,无、正确不可同时选择!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp3'])+",Type-"+ObsTypeID2+",Name-"+""+",Sign-B";
				var texts = getItemTexts(rd['Cmp3']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("提示", "第" + (row + 1) + "行第8、9列,请选择指征和手卫生行为,否则系统作为无效记录!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",病人后,") >= 0) && (("," + texts + ",").indexOf(",环境后,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第8列,病人后、环境后不可同时选择!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",无,") >= 0) && (("," + texts + ",").indexOf(",正确,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第9列无、正确不可同时选择!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp4'])+",Type-"+ObsTypeID2+",Name-"+""+",Sign-B";
				var texts = getItemTexts(rd['Cmp4']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("提示", "第" + (row + 1) + "行第11、12列,请选择指征和手卫生行为,否则系统作为无效记录!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",病人后,") >= 0) && (("," + texts + ",").indexOf(",环境后,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第11列,病人后、环境后不可同时选择!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",无,") >= 0) && (("," + texts + ",").indexOf(",正确,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第12列,无、正确不可同时选择!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp5'])+",Type-"+ObsTypeID3+",Name-"+""+",Sign-C";
				var texts = getItemTexts(rd['Cmp5']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("提示", "第" + (row + 1) + "行第14、15列,请选择指征和手卫生行为,否则系统作为无效记录!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",病人后,") >= 0) && (("," + texts + ",").indexOf(",环境后,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第14列,病人后、环境后不可同时选择!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",无,") >= 0) && (("," + texts + ",").indexOf(",正确,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第15列,无、正确不可同时选择!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}

				var val = getItemValues(rd['Cmp6'])+",Type-"+ObsTypeID4+",Name-"+""+",Sign-D";
				var texts = getItemTexts(rd['Cmp6']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("提示", "第" + (row + 1) + "行第17、18列,请选择指征和手卫生行为,否则系统作为无效记录!", 'info');
						return false;
					}
				}
				if ((("," + texts + ",").indexOf(",病人后,") >= 0) && (("," + texts + ",").indexOf(",环境后,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第17列,病人后、环境后不可同时选择!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",无,") >= 0) && (("," + texts + ",").indexOf(",正确,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第18列,无、正确不可同时选择!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}
			}
		}else {	
			var ObsName1 = $('#ObsName1').lookup('getText'); 
			var ObsName2 = $('#ObsName2').lookup('getText'); 
			var ObsName3 = $('#ObsName3').lookup('getText'); 
			var ObsType1 = $('#ObsType1').combobox('getValue'); 
			var ObsType2 = $('#ObsType2').combobox('getValue');
			var ObsType3 = $('#ObsType3').combobox('getValue');
		
			for (var row = 0; row < rows.length; row++) {
				var rd = rows[row];
				if ((getItemValues(rd['Cmp1']))&&(!ObsType1)) {
					 $.messager.alert("提示", "第1单元,请选择被调查者职业!", 'info');              
					 return false;
				}
				var val = getItemValues(rd['Cmp1'])+",Type-"+ObsType1+",Name-"+ObsName1+",Sign-A";
				var texts = getItemTexts(rd['Cmp1']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("提示", "第" + (row + 1) + "行第2、3列,请选择指征和手卫生行为,否则系统作为无效记录!", 'info');              
						return false;
					}
				}
				//如果勾选了其他且没有填其他原因则拦截
				if(Common_CheckboxLabel(rd['Cmp1']+"-I5").indexOf($g("其他"))>-1&&(($('#'+rd['Cmp1']+'-Other').val()==undefined)||($('#'+rd['Cmp1']+'-Other').val()==""))){
					$.messager.alert("提示", "第" + (row + 1) + "行第3列,请填写正确其他原因!", 'info');
					return false;
				}

				if (((("," + texts + ",").indexOf(",病人后,") >= 0) && (("," + texts + ",").indexOf(",环境后,") >= 0))||((("," + texts + ",").indexOf(",接触病人后,") >= 0) && (("," + texts + ",").indexOf(",接触环境后,") >= 0))) {
					$.messager.alert("提示", "第" + (row + 1) + "行第2列,病人后、环境后不可同时选择!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",无,") >= 0) && (("," + texts + ",").indexOf(",正确,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第3列,无、正确不可同时选择!", 'info');
					return false;
				}
				var Err=getErrTexts(rd['Cmp1']);
				if (((("," + texts + ",").indexOf(",洗手,") >= 0) ||(("," + texts + ",").indexOf(",手消,") >= 0)||(("," + texts + ",").indexOf(",洗手+手消,") >= 0))&& (("," + texts + ",").indexOf(",正确,") <0)&&(!Err)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第3、4列,洗手、手消、洗手+手消不正确时需选择不正确原因!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",正确,")>=0)&&(Err)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第3、4列,洗手、手消正确与不正确原因不可同时选择!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}
				
				if ((getItemValues(rd['Cmp2']))&&(!ObsType2)) {
					 $.messager.alert("提示", "第2单元,请选择被调查者职业!", 'info');              
					 return false;
				}
				var val = getItemValues(rd['Cmp2'])+",Type-"+ObsType2+",Name-"+ObsName2+",Sign-B";
				var texts = getItemTexts(rd['Cmp2']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("提示", "第" + (row + 1) + "行第6、7列,请选择指征和手卫生行为,否则系统作为无效记录!", 'info');
						return false;
					}
				}
				//如果勾选了其他且没有填其他原因则拦截
				if(Common_CheckboxLabel(rd['Cmp2']+"-I5").indexOf($g("其他"))>-1&&(($('#'+rd['Cmp2']+'-Other').val()==undefined)||($('#'+rd['Cmp2']+'-Other').val()==""))){
					$.messager.alert("提示", "第" + (row + 1) + "行第3列,请填写正确其他原因!", 'info');
					return false;
				}				
				if (((("," + texts + ",").indexOf(",病人后,") >= 0) && (("," + texts + ",").indexOf(",环境后,") >= 0))||((("," + texts + ",").indexOf(",接触病人后,") >= 0) && (("," + texts + ",").indexOf(",接触环境后,") >= 0))) {
					return false;
				}
				if ((("," + texts + ",").indexOf(",无,") >= 0) && (("," + texts + ",").indexOf(",正确,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第7列,无、正确不可同时选择!", 'info');
					return false;
				}
				
				var Err=getErrTexts(rd['Cmp2']);
				if (((("," + texts + ",").indexOf(",洗手,") >= 0) ||(("," + texts + ",").indexOf(",手消,") >= 0)||(("," + texts + ",").indexOf(",洗手+手消,") >= 0))&& (("," + texts + ",").indexOf(",正确,") <0)&&(!Err)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第7、8列,洗手、手消、洗手+手消不正确时需选择不正确原因!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",正确,")>=0)&&(Err)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第7、8列,洗手、手消正确与不正确原因不可同时选择!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}
				
				if ((getItemValues(rd['Cmp3']))&&(!ObsType3)) {
					 $.messager.alert("提示", "第3单元,请选择被调查者职业!", 'info');              
					 return false;
				}
				var val = getItemValues(rd['Cmp3'])+",Type-"+ObsType3+",Name-"+ObsName3+",Sign-C";
				var texts = getItemTexts(rd['Cmp3']);
				if (!((val.indexOf("I1") < 0) && (val.indexOf("I2") < 0))) {
					if ((val.indexOf("I1") < 0) || (val.indexOf("I2") < 0)) {
						$.messager.alert("提示", "第" + (row + 1) + "行第10、11列,请选择指征和手卫生行为,否则系统作为无效记录!", 'info');
						return false;
					}
				}
				//如果勾选了其他且没有填其他原因则拦截
				if(Common_CheckboxLabel(rd['Cmp3']+"-I5").indexOf($g("其他"))>-1&&(($('#'+rd['Cmp3']+'-Other').val()==undefined)||($('#'+rd['Cmp3']+'-Other').val()==""))){
					$.messager.alert("提示", "第" + (row + 1) + "行第3列,请填写正确其他原因!", 'info');
					return false;
				}				
				if (((("," + texts + ",").indexOf(",病人后,") >= 0) && (("," + texts + ",").indexOf(",环境后,") >= 0))||((("," + texts + ",").indexOf(",接触病人后,") >= 0) && (("," + texts + ",").indexOf(",接触环境后,") >= 0))) {
					$.messager.alert("提示", "第" + (row + 1) + "行第10列,病人后、环境后不可同时选择!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",无,") >= 0) && (("," + texts + ",").indexOf(",正确,") >= 0)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第11列无、正确不可同时选择!", 'info');
					return false;
				}
				var Err=getErrTexts(rd['Cmp3']);
				if (((("," + texts + ",").indexOf(",洗手,") >= 0) ||(("," + texts + ",").indexOf(",手消,") >= 0)||(("," + texts + ",").indexOf(",洗手+手消,") >= 0))&& (("," + texts + ",").indexOf(",正确,") <0)&&(!Err)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第11、12列,洗手、手消、洗手+手消不正确时需选择不正确原因!", 'info');
					return false;
				}
				if ((("," + texts + ",").indexOf(",正确,")>=0)&&(Err)) {
					$.messager.alert("提示", "第" + (row + 1) + "行第11、12列,洗手、手消正确与不正确原因不可同时选择!", 'info');
					return false;
				}
				if ((val.indexOf("I1") >= 0) && (val.indexOf("I2") >= 0)) {
					arrResult.push(val);
				}
			}
		}
		return arrResult;
	}
	// 手卫生调查人数
	obj.CheckCntData = function (){
		var HandHyRegCnt ="";
		if (ServerObj.RegVer!='2') {
			var ObsNumber1 = $('#ObsNumber1').val(); 
			var ObsNumber2 = $('#ObsNumber2').val(); 
			var ObsNumber3 = $('#ObsNumber3').val(); 
			var ObsNumber4 = $('#ObsNumber4').val();
			var ObsType1 = $('#ObsType1').val(); 
			var ObsType2 = $('#ObsType2').val(); 
			var ObsType3 = $('#ObsType3').val(); 
			var ObsType4 = $('#ObsType4').val();	
			var ObsTypeID1 = $('#ObsTypeID1').val(); 
			var ObsTypeID2 = $('#ObsTypeID2').val(); 
			var ObsTypeID3 = $('#ObsTypeID3').val(); 
			var ObsTypeID4 = $('#ObsTypeID4').val();	

			if (ObsNumber1 == '') {
				$.messager.alert("提示", ObsType1+"调查人数不允许为空!", 'info');
				return false;
			}
			if (ObsNumber2 == '') {
				$.messager.alert("提示", ObsType2+"调查人数不允许为空!", 'info');
				return false;
			}
			if (ObsNumber3 == '') {
				$.messager.alert("提示", ObsType3+"调查人数不允许为空!", 'info');
				return false;
			}
			if (ObsNumber4 == '') {
				$.messager.alert("提示", ObsType4+"调查人数不允许为空!", 'info');
				return false;
			}
			HandHyRegCnt = ObsTypeID1+","+ObsNumber1 +",A"+ "#"+ObsTypeID2+","+ObsNumber2 +",B"+ "#"+ObsTypeID3+"," + ObsNumber3 +",C"+"#"+ObsTypeID4+","+ObsNumber4+",D";
		}else {	
			var ObsName1 = $('#ObsName1').lookup('getText'); 
			var ObsName2 = $('#ObsName2').lookup('getText'); 
			var ObsName3 = $('#ObsName3').lookup('getText'); 
			var ObsType1 = $('#ObsType1').combobox('getValue'); 
			var ObsType2 = $('#ObsType2').combobox('getValue');
			var ObsType3 = $('#ObsType3').combobox('getValue');
			HandHyRegCnt = ObsType1+"," + (ObsType1 ? 1:"") +"," +(ObsType1 ? "A":"")+ "#"+ObsType2+"," + (ObsType2 ? 1:"") +"," +(ObsType2 ? "B":"")+ "#"+ObsType3+","+(ObsType3 ? 1:"")+"," +(ObsType3 ? "C":"");
		}
		return HandHyRegCnt;
	}
	//打印
    $("#btnPrint").on('click', function () {
		var RegID=(obj.RegID) ? obj.RegID:obj.HandRegID;
       	var fileName="DHCHAIHandHyReport.raq&aRegID="+RegID;
		DHCCPM_RQPrint(fileName);
    })
    //打印空白
    $("#btnPrintNull").on('click', function () {
		var RegID="0";
       	var fileName="DHCHAIHandHyReport.raq&aRegID="+RegID;
		DHCCPM_RQPrint(fileName);
    })
    //删除
    $("#btnDelete").on('click', function () {
        if (obj.HandRegID == "") {
			$.messager.alert("提示", "无数据时无法删除!", 'info');
			return;
		}
        $.messager.confirm("提示", '确认是否删除?', function (r) {
            if (r) {
                var flg = $m({
                    ClassName: "DHCHAI.IR.HandHyReg",
                    MethodName: "DeleteById",
                    aId: obj.HandRegID
                }, false);
                if (parseInt(flg) < 0) {
                    $.messager.alert("提示", "删除失败!", 'info');
                } else {
                    $("#btnDelete").hide();
					$("#btnPrint").hide();
                    obj.HandRegID = "";
					if (!obj.RegID) {
						obj.refreshgridHandHyReg();
					}else {
						$("#btnSave").hide();
					}
                    $.messager.popover({msg: '删除成功！',type: 'success',timeout: 2000});
                }
            }
            else {
                return;
            }
        });
    })
    function getItemValues(cmp) {
        var str = "";
        if (cmp == "") {
            return str;
        }
        var cmpArr = $('ul#' + cmp + ' li :checkbox');
        for (var num = 0; num < cmpArr.length; num++) {
            if (cmpArr[num].checked) {
                str = str + ',' + cmpArr[num].id;
            }
        }
        var cmpArr = $('ul#' + cmp + ' li :radio');
        for (var num = 0; num < cmpArr.length; num++) {
            if (cmpArr[num].checked) {
                str = str + ',' + cmpArr[num].id;
            }
        }
		if(($('#'+cmp+'-Other').val())!=undefined&&($('#'+cmp+'-Other').val()!="")){
			str= str +',Other-'+ $('#'+cmp+'-Other').val()
		}
		
        if (str != "") {
            var str = str.substring(1);
        }
        return str;
    }

    function getItemTexts(cmp) {
        var str = "";
        if (cmp == "") {
            return str;
        }
        $('ul#' + cmp).find("li").each(function () {
            if ($(this).find("input")[0].checked) {
                str = str + ',' + $.trim($(this).text());
            }
        });

        if (str != "") {
            var str = str.substring(1);
        }
        return str;
    }
	
	
	function getErrTexts(cmp) {
        var str = "";
        if (cmp == "") {
            return str;
        }
		$("input[name='"+cmp + '-I5'+"']:checked").each(function(){
             str = str + ',' +$(this).attr("label");
        });
		if (str != "") {
            var str = str.substring(1);
        }
        return str;
    }
    //加载字典下拉框(默认选中第一行)
	obj.refreshDicID = function (ItemCode, DicType) {
	    $HUI.combobox("#" + ItemCode, {
	        url: $URL,
	        editable: true,
	        allowNull: true,
	        defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
	        valueField: 'ID',
	        textField: 'DicDesc',
			loadFilter : function(data) {
				if (obj.ParamAdmin=="Admin"){
					return data;
				}/*
				var len=data.length
				for (var indRd = 0; indRd < data.length; indRd++){
					var rd = data[indRd];
					if (rd["DicDesc"]==$g("督查")) {
						delete data[indRd];
						data.length=len-2;
						break;
					}
				}*/
				return data;
				
			},
	        onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
	            param.ClassName = 'DHCHAI.BTS.DictionarySrv';
	            param.QueryName = 'QryDic';
	            param.aTypeCode = DicType;
	            param.aActive = 1;
	            param.ResultSetType = 'array';
	        },
	        onLoadSuccess: function () {   //初始加载赋值
	            var data = $(this).combobox('getData');
	            if (data.length > 0) {
	                $(this).combobox('select', data[0]['ID']);
	            }
	        },
			
	    });
	}
}