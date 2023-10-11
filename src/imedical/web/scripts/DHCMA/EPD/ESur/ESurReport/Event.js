// 流调报告
function InitReportWinEvent(obj){
    
    //获取当前日期
    var currDate = Common_GetDate(new Date());     //当前日期
	
	// 初始化职业暴露主表信息
    obj.refreshRegInfo = function () {
	    if(ReportID!=""){
		    obj.RegInfo =$cm({
	            ClassName: "DHCMed.EPDService.ESurRepSrv",
	            QueryName: "QryRepInfo",
	            aRepID: ReportID
	        },false);
            if (obj.RegInfo.total != 0) {
                var RegInfo = obj.RegInfo.rows[0];
                $("#txtName").val(RegInfo.SEName);
				$("#txtSex").val(RegInfo.SESex);
				$("#txtRegNo").val(RegInfo.SERegNo);
				$("#txtIDNumber").val(RegInfo.SEIDNumber);
				$("#txtTelPhone").val(RegInfo.SETelPhone); 
				$("#txtDiagDateTime").datetimebox("setValue",RegInfo.SEDiagDateTime);
				$("#txtDiagLoc").val(RegInfo.SEDiagLoc);  
				$("#txtDiagDoc").val(RegInfo.SEDiagDoc); 
				$("#txtRepStatus").val(RegInfo.SERepStutas); 
                obj.RepStatusCode = RegInfo.SERepStutas;				
            }
		}else{
			if ((PatientID!="")&&(EpisodeID!="")){
		    	var objPaadm = $cm({                   
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				$("#txtName").val(objPaadm.PatientName);
				if((objPaadm.Sex!="男")&&(objPaadm.Sex!="女")){
					var Sex = "其他";
				}else{
					var Sex = objPaadm.Sex;
				}
				$("#txtSex").val(Sex);
				$("#txtRegNo").val(objPaadm.PapmiNo);
				$("#txtIDNumber").val(objPaadm.PersonalID);
				$("#txtTelPhone").val(objPaadm.Telephone);  
				
		    	var objPatient = $cm({                   
					ClassName:"DHCMed.Base.PatientAdm",
					MethodName:"GetObjById",
					paadm:EpisodeID
				},false);
				var AdmitDate = objPatient.AdmitDate;
				var AdmitTime = objPatient.AdmitTime;
				var AdminDay  = AdmitDate+" "+ AdmitTime
				$("#txtDiagDateTime").datetimebox("setValue",AdminDay);
				$("#txtDiagLoc").val(objPatient.Department);  
				$("#txtDiagDoc").val(objPatient.DoctorName); 
			}
	    }
    }
	obj.refreshRegInfo();
    // 初始化职业暴露扩展信息
    obj.refreshExtInfo = function () {
        //初始化所有日期、下拉列表(置空)
        var ExtDataQuery = $cm({
            ClassName: "DHCMed.EPDService.ESurRepSrv",
            QueryName: "QryESurTypeExt",
            aTypeID: RegTypeID
        }, false);
        if (ExtDataQuery) {
            var arrDT = ExtDataQuery.rows;
            for (var ind = 0; ind < arrDT.length; ind++) {
                var rd = arrDT[ind];
                if (!rd) continue;
                var ItemDr = rd.ID;
                var DataType = rd.DatCode;
                var ItemCode = rd.Code;
                if (DataType == "DD") {
                    $("#txt" + ItemCode).val();
                }
                if (DataType == "S") {
                    $("#cbo" + ItemCode).combobox('clear');
                }

            }
        }
        //加载报告填写内容
        obj.RegExt = $cm({
            ClassName: "DHCMed.EPDService.ESurRepSrv",
            QueryName: "QryExpExtInfo",
            aRepID: ReportID
        }, false);
        if (obj.RegExt != '') {
            if (obj.RegExt.total != 0) {
                var arrDT = obj.RegExt.rows;
                for (var ind = 0; ind < arrDT.length; ind++) {
                    var rd = arrDT[ind];
                    if (!rd) continue;
                    var DataType = rd.DataType;
                    var ItemCode = rd.Code;
                    var ResultID = rd.ResultID;
                    var ResultCode = rd.ResultCode;
                    var ResultDesc = rd.ResultDesc;
                    var ResultTxt = rd.ResultTxt;
                    var ResultList = rd.ResultList;
                    var Line = parseInt(ItemCode);

                    if ((DataType == "DS") || (DataType == "DSL")) {
                        var selector = '#Line' + Line + ResultID;
                        $HUI.radio(selector).setValue(true);
                    }
                    if ((DataType == "B1") || (DataType == "B2")) {  //界面中有多个是否、有无时 赋值方式
                        var selector = '#Line' + Line + ResultID;

                        $HUI.radio(selector).setValue(true);
                    }
                    if ((DataType == "DB") || (DataType == "DBL")) {
                        var Len = ResultList.split(",").length;
                        if(ResultList=="") continue;
                        for (var indx = 0; indx < Len; indx++) {
                            var Result = ResultList.split(",")[indx];
                            $("#Line" + Line + Result).checkbox('setValue', true)
                        }
                    }
                    if ((DataType == "T") || (DataType == "TL") || (DataType == "N0") || (DataType == "N1") || (DataType == "TB")) {
                        $("#Line" + Line).val(rd.ResultTxt);
                    }
                    if (DataType == "DD") {
                        $("#Line" + Line ).val(rd.ResultTxt);
                    }
                    if (DataType == "S") {
                        $("#Line" + Line).combobox('setValue', rd.ResultID);
                        $("#Line" + Line).combobox('setText', rd.ResultDesc);
                    }

                }
            }
        }
    }
    obj.refreshExtInfo();
    //保存基本信息
    obj.Reg_Save = function (StatusCode) {
		var Name 		= $("#txtName").val(); 		// 姓名
		var RegNo 		= $("#txtRegNo").val(); 	// 登记号
		var IDNumber 	= $("#txtIDNumber").val(); 	// 身份证号
		var Sex 		= $("#txtSex").val(); 		// 性别
		var TelPhone 	= $("#txtTelPhone").val(); 	// 电话
		var DiagDateTime= $("#txtDiagDateTime").datetimebox('getValue'); 	// 接诊时间
		var DiagLoc 	= $("#txtDiagLoc").val(); 	// 诊断科室
		var DiagDoc 	= $("#txtDiagDoc").val(); 	// 诊断医生

        var InputReg = ReportID;
        InputReg = InputReg + "^" + RegTypeID;
        InputReg = InputReg + "^" + Name;
        InputReg = InputReg + "^" + RegNo;
        InputReg = InputReg + "^" + IDNumber;
        InputReg = InputReg + "^" + Sex;
        InputReg = InputReg + "^" + TelPhone; //状态	
        InputReg = InputReg + "^" + DiagDateTime;
        InputReg = InputReg + "^" + DiagLoc;
        InputReg = InputReg + "^" + DiagDoc;
        InputReg = InputReg + "^" + StatusCode;
        InputReg = InputReg + "^" + EpisodeID;
        InputReg = InputReg + "^" + PatientID;
        

        return InputReg;
    }
    //保存项目定义
    obj.RegExt_Save = function (aExtType) {

        var Parref = ReportID;
        var InputRegExts = "";
        var ExtDataQuery = $cm({
        	ClassName: "DHCMed.EPDService.ESurRepSrv",
            QueryName: "QryESurTypeExt",
            aTypeID: RegTypeID
        }, false);
        
        if (ExtDataQuery) {
            var arrDT = ExtDataQuery.rows;
            for (var ind = 0; ind < arrDT.length; ind++) {
                var rd = arrDT[ind];
                if (!rd) continue;
                var ItemDr = rd.ID;
                var ItemCode = parseInt(rd.Code);
                var ItemDesc = rd.Desc;
                var DataType = rd.DatCode;
                var Required = rd.IsRequired;
                var ResultDr = '';
                var ResultList = '';
                var ResultTxt = '';
                var TypeDesc = rd.TypeDesc;
                var TypeCode = rd.TypeCode;

                var display = $("#" + TypeCode).css('display');
                if (display == 'none') continue; //隐藏的项目不检查是否必填

                if ((DataType == "DS") || (DataType == "DSL") || (DataType == "B1") || (DataType == "B2")) {
                    ResultDr = Common_RadioValue("Line"+ItemCode);
                }
                if ((DataType == "DB") || (DataType == "DBL")) {
	                ResultList = Common_CheckboxValue("Line"+ItemCode);
                }
                if ((DataType == "T") || (DataType == "TL") || (DataType == "TB") || (DataType == "N0") || (DataType == "N1") ) {
                    var ResultTxt = $("#Line" + ItemCode).val();
					var ResultTxt = ResultTxt.replace(/\s+/g,"");

                    var type = /(^[0-9]\d*$)/;　　//正整数+0
                    var regu = /^[0-9]+\.?[0-9]*$/; //小数
                    if ((ResultTxt != "") && (DataType == "N0")) {    //整数类型   
                        if (!type.test(ResultTxt)) {
                            $.messager.alert("提示", ItemDesc + "只允许输入0-9的数字!", 'info');
                            return false;
                        }
                    }
                    if ((ResultTxt != "") && (DataType == "N1")) {    //小数类型
                        if (!regu.test(ResultTxt)) {
                            $.messager.alert("提示", ItemDesc + "只允许输入小数的数字!", 'info');
                            return false;
                        }
                    }
                    
                }
                if (DataType == "DD") {
                     var ResultTxt = $("#Line" + ItemCode).datebox('getValue');
                     if ((ResultTxt != "") && (DataType == "DD")) {  //日期类型
                        if (currDate<ResultTxt) {
                            $.messager.alert("提示", ItemDesc + "不能在当前日期之后!", 'info');
                            return false;
                        }
                    }
                }

                if (DataType == "S") {
                    var ResultDr = $("#Line" + ItemCode).combobox('getValue');
                }

                if ((Required == '1') && ((ResultDr == "") && (ResultList == "") && (ResultTxt == ""))) {
                    $.messager.alert("提示", TypeDesc + '中的' + ItemDesc + '不允许为空!', 'info');
                    return false;
                }

                if ((ResultDr == "") && (ResultList == "") && (ResultTxt == "")) {  //值为空不保存
                    continue;
                }

                var ChildSub = $m({
                    ClassName: "DHCMed.EPD.ESurRegExt",
                    MethodName: "GetIDByItemDr",
                    aReportID: Parref,
                    aItemDr: ItemDr
                }, false);
                var InputRegExt = Parref;
                InputRegExt = InputRegExt + "^" + ChildSub;
                InputRegExt = InputRegExt + "^" + ItemDr;		//关联项目
                InputRegExt = InputRegExt + "^" + ItemDesc;
                InputRegExt = InputRegExt + "^" + DataType;   //5
                InputRegExt = InputRegExt + "^" + ResultDr;
                InputRegExt = InputRegExt + "^" + ResultList;
                InputRegExt = InputRegExt + "^" + ResultTxt;
                InputRegExt = InputRegExt + "^" + '';
                InputRegExt = InputRegExt + "^" + '';         //10
                InputRegExts = InputRegExts + "#" + InputRegExt;	 //保存多条
            }
            if (InputRegExts == "") {
                $.messager.alert("提示", '流调信息不能为空!', 'info');
                return false;
            }
            console.log(InputRegExts);
            return InputRegExts;
        }
    }
   
    //封装按钮相关
    obj.InitButtons = function () {
        $('#btnSave').hide();
        $('#btnCheck').hide();
        $('#btnUnCheck').hide();
        $('#btnDelete').hide();
        $('#btnClose').hide();
        
		RepStatusCode=obj.RepStatusCode;
        switch (RepStatusCode) {
            case '保存':       // 保存
                $('#btnSave').show();
       		 	$('#btnCheck').show();
        		$('#btnDelete').show();
       			 $('#btnClose').show();
                break;
            case '审核':       // 审核
        		$('#btnUnCheck').show();
       			 $('#btnClose').show();
                break;
            case '取消审核':       // 取消审核
                $('#btnSave').show();
       		 	$('#btnCheck').show();
        		$('#btnDelete').show();
       			 $('#btnClose').show();
                break;
            default:
                $('#btnSave').show();
       			 $('#btnClose').show();
                break;
        }
    }
    obj.InitButtons();
    // 提交
    $('#btnSave').click(function (e) {
        if (!obj.CheckInputData(1)) {
            return false;
        }
        if (obj.Save()) {
            $.messager.alert("提示", "提交成功!", 'info');
        } else {
            $.messager.alert("提示", "提交失败!", 'info');
        };

    });

    // 审核
    $('#btnCheck').click(function (e) {
	    
	    var ret = $m({
            ClassName: "DHCMed.EPD.ESurRepReg",
            MethodName: "CheckReport",
            aId: ReportID
        }, false);
	    
        if (ret>0) {
            $.messager.alert("提示", "审核成功!", 'info');
            
            obj.refreshRegInfo();
            obj.refreshExtInfo();
            obj.InitButtons();
        } else {
            $.messager.alert("提示", "审核失败!", 'info');
        };
    });

    // 删除
    $('#btnDelete').click(function (e) {
	     $.messager.confirm("提示", '是否删除?', function (r) {
            if (r) {
			    var ret = $m({
		            ClassName: "DHCMed.EPD.ESurRepReg",
		            MethodName: "DeleteById",
		            aId: ReportID
		        }, false);
               if (ret==0) {
            		$.messager.alert("提示", "删除成功!", 'info');
            		websys_showModal('close');
        		} else {
            		$.messager.alert("提示", "删除失败!", 'info');
        		};
            }
            else {
                return;
            }
        });
    });

    // 取消审核
    $('#btnUnCheck').click(function (e) {
	    var ret = $m({
            ClassName: "DHCMed.EPD.ESurRepReg",
            MethodName: "UnCheckReport",
            aId: ReportID
        }, false);
        if (ret>0) {
            $.messager.alert("提示", "取消审核成功!", 'info');
            
            obj.refreshRegInfo();
            obj.refreshExtInfo();
            obj.InitButtons();
        } else {
            $.messager.alert("提示", "取消审核失败!", 'info');
        };
    });
	$('#btnClose').on("click", function(){
		//关闭
		websys_showModal('close');
	});

    // 数据完整性验证
    obj.CheckInputData = function (StatusCode) {

        obj.ExpReg = obj.Reg_Save(StatusCode);		// 报告主表信息
        obj.ExpRegExt = obj.RegExt_Save("");	            // 扩展表

        if (!obj.ExpReg) {
            return false;
        }
        if (!obj.ExpRegExt) {
            return false;
        }
        return true;
    }
    // 保存报告内容+状态
    obj.Save = function () {
        var ret = $m({
            ClassName: "DHCMed.EPDService.ESurRepSrv",
            MethodName: "SaveExpReport",
            aExpReg: obj.ExpReg,
            aExpRegExts: obj.ExpRegExt
        }, false);
        
        if (parseInt(ret) > 0) {
            ReportID = parseInt(ret);
            obj.refreshRegInfo();
            obj.refreshExtInfo();
            obj.InitButtons();
            return true;
        } else {
            return false;
        }
    }
    
}

