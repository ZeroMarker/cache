//职业暴露报告--Event
var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
function InitReportWinEvent(obj) {
    //初始化信息
    obj.LoadEvent = function () {
        obj.AdminPower = AdminPower;			//管理员权限
        //obj.AdminPower = "1";			//管理员权限
        obj.GroupDesc = session['LOGON.GROUPDESC'];
        obj.SupNurFlg = 0;
        obj.SupDocFlg = 0;
        if (obj.GroupDesc.indexOf('护士长') > -1) {
            obj.SupNurFlg = 1;					//护士长权限
        }
        if (obj.GroupDesc.indexOf('主任') > -1) {
            obj.SupDocFlg = 1					//科主任权限
        }

        //刷新基本信息
        obj.Reg_Refresh();
        //刷新按钮
        obj.InitButtons();
        //刷新报告信息
        obj.RegExt_Refresh();
        //刷新检验信息
        obj.RegLab_Refresh();
        
    }
	 // 提交[暴露信息+暴露源情况]
    $('#btnTmpSubmit').click(function (e) {
        if (!obj.CheckInputData(8, 1)) {
            return false;
        }
		
        if (obj.Save()) {
            $.messager.alert("提示", "暂存成功!", 'info');
        } else {
			debugger
            $.messager.alert("提示", "暂存失败!", 'info');
        };
        //按钮事件
        obj.RepStatusCode = "8";
        obj.InitButtons();
    });
    // 提交[暴露信息+暴露源情况]
    $('#btnSubmit').click(function (e) {
        if (!obj.CheckInputData(1, 1)) {
            return false;
        }
        if (obj.Save()) {
            $.messager.alert("提示", "提交成功!", 'info');
        } else {
            $.messager.alert("提示", "提交失败!", 'info');
        };
        //按钮事件
        obj.RepStatusCode = "1";
        obj.InitButtons();
    });
    $('#btnCheck').click(function (e) {
        if (!obj.CheckInputData(2, 1)) {
            return false;
        }
        if (obj.Save()) {
            $.messager.alert("提示", "审核成功!", 'info');
        } else {
            $.messager.alert("提示", "审核失败!", 'info');
        };
        //按钮事件
        obj.RepStatusCode = "2";
        obj.InitButtons();
    });
    $('#btnUnCheck').click(function (e) {
        if (obj.SaveStatus(5, "")) {
            $.messager.alert("提示", "取消审核成功!", 'info');
        } else {
            $.messager.alert("提示", "取消审核失败!", 'info');
        };
        //按钮事件
        obj.RepStatusCode = "1";
        obj.InitButtons();
    });
    $('#btnDelete').click(function (e) {
        $.messager.confirm("提示", '是否删除?', function (r) {
            if (r) {
                if (obj.SaveStatus(3, "")) {
                    $.messager.alert("提示", "删除成功!", 'info');
                    //按钮事件
                    obj.RepStatusCode = "3";
                    obj.InitButtons();
                } else {
                    $.messager.alert("提示", "删除失败!", 'info');
                };
            }
            else {
                return;
            }
        });
    });
    //护士长签名
    $('#btnSuperNur').click(function (e) {
        if (!obj.CheckInputData(6, 1)) {
            return false;
        }
        if (obj.Save()) {
            $.messager.prompt("提示", "护士长签名意见(必填)", function (value) {
                if (value) {
                    if (obj.SaveLog(6, value)) {
                        $.messager.alert("提示", "护士长签名成功!", 'info');
                    } else {
                        $.messager.alert("提示", "护士长签名失败!", 'info');
                    };
                }
            });
        } else {
            $.messager.alert("提示", "提交失败!", 'info');
        };
        //按钮事件
        obj.RepStatusCode = "6";
        obj.InitButtons();
    });
    //科主任签名
    $('#btnSuperDor').click(function (e) {
        if (!obj.CheckInputData(7, 1)) {
            return false;
        }
        if (obj.Save()) {
            $.messager.prompt("提示", "科主任签名意见(必填)", function (value) {
                if (value) {
                    if (obj.SaveLog(7, value)) {
                        $.messager.alert("提示", "科主任签名成功!", 'info');
                    } else {
                        $.messager.alert("提示", "科主任签名失败!", 'info');
                    };
                }
            });
        } else {
            $.messager.alert("提示", "提交失败!", 'info');
        };
        //按钮事件
        obj.RepStatusCode = "7";
        obj.InitButtons();
    });
    $('#btnExport_1').click(function (e) {
        var RegTypeData = $cm({				//暴露人[obj]
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryOccExpType",
            aActive: "1",
            aRegTypeID: RegTypeID
        }, false);
        var RegTypeDesc = RegTypeData.rows[0].BTDesc;
        if (RegTypeDesc.indexOf("利器伤") >= 0) {
            var url = "OccExpReg_1.raq&aRepID=" + ReportID;
        }
        else if (RegTypeDesc.indexOf("血液体液污染") >= 0) {
            var url = "OccExpReg_2.raq&aRepID=" + ReportID;
        }
        else if(RegTypeDesc.indexOf("血源性")>=0){
            var url = "OccExpReg_4.raq&aRepID=" + ReportID;
        }
        else {
            $.messager.alert("提示", "导出失败!", 'info');
        }

        DHCCPM_RQPrint(url);
    });
    //保存'审核观察'
    $('#btnSave').click(function (e) {
        //1.保存送检
        obj.ExpRegLog = obj.RegLog_Save(2, "");
        obj.ExpRegLab = obj.RegLab_Save();
        if (obj.ExpRegLab == -1) return false;
        var LabFlag = 1;
        if (obj.ExpRegLab != "") {
            var ret = $m({
                ClassName: "DHCHAI.IRS.OccExpRegSrv",
                MethodName: "SaveExpLab",
                aExpRegLabs: obj.ExpRegLab,
                aExpRegLog: obj.ExpRegLog
            }, false);
            if (parseInt(ret) > 0) {
                ReportID = parseInt(ret);
                LabFlag = 1;
            } else {
                LabFlag = 0;
            }
        }
        //2.保存报告(配置信息)
        var Flag = 1;
        if (!obj.CheckInputData(2, 2)) {
            Flag = 0;
        }
        if ((LabFlag != 1) && (Flag != 1)) {
            $.messager.alert("提示", "保存失败!", 'info');
            return false;
        }

        if ((LabFlag == 1) && (obj.Save())) {
            $.messager.alert("提示", "保存成功!", 'info');
            return true;
        } else {
            $.messager.alert("提示", "保存失败!", 'info');
            return false;
        };
    });
    $('#btnExport_2').click(function (e) {
        var url = "OccExpReg_3.raq&aRepID=" + ReportID + '&aTypeID=2';
        DHCCPM_RQPrint(url);
    });
    //封装按钮相关操作事件
    obj.InitButtons = function () {
		$('#btnTmpSubmit').hide();		//暂存
        $('#btnSubmit').hide();		//提交
        $('#btnCheck').hide();		//审核
        $('#btnUnCheck').hide();	//取消审核
        $('#btnDelete').hide();		//删除
        $('#btnExport_1').hide();	//导出-登记报告

        $('#btnSuperNur').hide();	//护士长签名
        $('#btnSuperDor').hide();	//科主任签名

        $('#btnSave').hide();		//保存
        $('#btnExport_2').hide();	//导出-审核观察
        //是否启用护士长-科主任签字
        var IsOccRepSign = $m({
            ClassName: "DHCHAI.BT.Config",
            MethodName: "GetValByCode",
            aCode: "IsOccRepSign"
        }, false);

        //隐藏页签
        tab_option = $('#Maintabs').tabs('getTab', "登记报告").panel('options').tab;
        tab_option.hide();
        tab_option = $('#Maintabs').tabs('getTab', "审核观察").panel('options').tab;
        tab_option.hide();
        $('.tabs-wrap').height(0);
        $('.tabs').height(0);

        //0.未提交,1.提交,2.审核,3.删除,4.取消审核,5.护士长签名,6.科主任签名
        if (obj.RepStatusCode == "1") $('#txtRepStatus').val("提交");
        if (obj.RepStatusCode == "2") $('#txtRepStatus').val("审核");
        if (obj.RepStatusCode == "3") $('#txtRepStatus').val("删除");
        if (obj.RepStatusCode == "5") $('#txtRepStatus').val("取消审核");
        if (obj.RepStatusCode == "6") $('#txtRepStatus').val("护士长签名");
        if (obj.RepStatusCode == "7") $('#txtRepStatus').val("科主任签名");
        switch (obj.RepStatusCode) {
            case "0":
				$('#btnTmpSubmit').show();
                $('#btnSubmit').show();
                break;
            case "1":
                $('#btnSubmit').show();
                if (IsOccRepSign == "1") {
                    if (obj.SupNurFlg == 1) {
                        $('#btnSuperNur').show();
                    }
                    if (obj.SupDocFlg == 1) {
                        $('#btnSuperDor').show();
                    }
                }
                $('#btnDelete').show();
                $('#btnExport_1').show();
                if ((obj.AdminPower == 1) && (IsOccRepSign != "1")) {		// 管理员
                    $('#btnCheck').show();
                }
                break;
            case "2":
                $('#btnExport_1').show();
                if (obj.AdminPower == 1) {		// 管理员
                    //加载页签
                    tab_option = $('#Maintabs').tabs('getTab', "登记报告").panel('options').tab;
                    tab_option.show();
                    tab_option = $('#Maintabs').tabs('getTab', "审核观察").panel('options').tab;
                    tab_option.show();
                    $('.tabs').height(35);
                    $('.tabs-wrap').height(35);
                    //默认加载'审核观察'页签
                    $("#Maintabs").tabs('select', 1);
					$.parser.parse('#OccInfo_2'); 		// 解析页签2
                    $('#btnUnCheck').show();
                    $('#btnSave').show();
                    $('#btnExport_2').show();
                }
                break;
            case "5":
                $('#btnSubmit').show();
                if (obj.SupNurFlg == 1) {
                    $('#btnSuperNur').show();
                }
                if (obj.SupDocFlg == 1) {
                    $('#btnSuperDor').show();
                }
                $('#btnDelete').show();
                $('#btnExport_1').show();
                if ((obj.AdminPower == 1) && (IsOccRepSign != "1")) {		// 管理员
                    $('#btnCheck').show();
                }
                break;
            case "6":
                if (obj.SupNurFlg == 1) {
                    $('#btnSuperNur').show();
                }
                if (obj.SupDocFlg == 1) {
                    $('#btnSuperDor').show();
                }
                $('#btnDelete').show();
                $('#btnExport_1').show();
                if ((obj.AdminPower == 1) && (IsOccRepSign == "1")) {		// 管理员
                    $('#btnCheck').show();
                }
                break;
            case "7":
                if (obj.SupNurFlg == 1) {
                    $('#btnSuperNur').show();
                }
                if (obj.SupDocFlg == 1) {
                    $('#btnSuperDor').show();
                }
                $('#btnDelete').show();
                $('#btnExport_1').show();
                if ((obj.AdminPower == 1) && (IsOccRepSign == "1")) {		// 管理员
                    $('#btnCheck').show();
                }
                break;
			case "8":
				$('#btnTmpSubmit').show();
				$('#btnSubmit').show();
				break
            default:
				$('#btnTmpSubmit').hide();
                $('#btnSubmit').hide();
                $('#btnSuperNur').hide();
                $('#btnSuperDor').hide();
                $('#btnCheck').hide();
                $('#btnUnCheck').hide();
                $('#btnDelete').hide();
                $('#btnExport_1').hide();
                $('#btnSave').hide();
                $('#btnExport_2').hide();
                break;
        }
    }
        	//显示+隐藏
   obj.hideOrShow=function(parId,chidId,desc,type,ids){
    var  parName=""
    if(parId.indexOf("div_")>-1){
        parName=parId.split('_')[1]
    }
    else{
        parName=parId
    }  
    if(type=="1"){
        $('#'+chidId).hide();     
        $HUI.radio("[name="+parName+"]", {
            onCheckChange: function () {
               var Label=Common_RadioLabel(parName);
               if(Label=="皮肤"&&parName=="20200"){
                $("#div_20210").show(); 
                $("#div_20220").hide();
                $('[name="20220"]').checkbox('setValue', false);
            }
               else if(Label=="粘膜"&&parName=="20200"){
                $("#div_20220").show(); 
                $("#div_20210").hide();
                $('[name="20210"]').checkbox('setValue', false);
             }
             //  else{$("#div_20220").hide(); $("#div_20210").hide()}
               if(Label=="何种体液"&&parName=="20600"){$("#20601").show();$("#20602").hide(); }
               else if(Label=="其他"&&parName=="20600"){$("#20602").show() ; $("#20601").hide()}
               else if(parName=="20600"){$("#20602").hide(); $("#20601").hide()}
               if(Label=="其他器械"&&parName=="20800"){$("#20801").show(); }
               else if(parName=="20800"){ $("#20801").hide()}
               if(Label=="含血体液"&&parName=="21100"){$("#21101").show();$("#21102").hide() }
               else if(Label=="其他"&&parName=="21100"){$("#21102").show();  $("#21101").hide() }
               else if(parName=="21100"){$("#21102").hide(); $("#21101").hide()}
               if(Label=="其他"&&parName=="21300"){$("#21301").show(); }
               else if(parName=="21300"){ $("#21301").hide()}
               if(Label=="有反应"&&parName=="71200"){
                $("#div_71201").show(); 
                $("#div_71202").hide(); 
                $("#div_71203").hide();
                $('[name="71202"]').checkbox('setValue', false);
                $('[name="71203"]').checkbox('setValue', false);
            }
               else if(Label=="无反应"&&parName=="71200"){
                $("#div_71202").show(); 
                $("#div_71201").hide(); 
                $("#div_71203").hide();
                $('[name="71201"]').checkbox('setValue', false);
                $('[name="71203"]').checkbox('setValue', false);
            }
                
               else if(Label=="未知"&&parName=="71200"){
                 $("#div_71203").show();
                 $("#div_71201").hide(); 
                 $("#div_71202").hide();
                 $('[name="71201"]').checkbox('setValue', false);
                 $('[name="71202"]').checkbox('setValue', false);
                }
              // else{$("#div_71203").hide(); $("#div_71201").hide(); $("#div_71202").hide()}
            }
        });
    }
    else if(type=="2"){
        var idsArry=ids.split(',')
        idsArry.forEach(element => {
            $( "[id^='"+element+"']" ).hide();
        });
        $HUI.radio("[name="+parName+"]", {
            onCheckChange: function () {
               var Label=Common_RadioLabel(parName);
               if(Label=="皮肤"&&parName=="40000"){
                $("[id^='div_402']" ).show();
                $("[id^='div_403']" ).hide();
                $("[name^='403']").checkbox('setValue', false);
            }
               else if(Label=="粘膜"&&parName=="40000"){
                $("[id^='div_403']").show();
                $("[id^='div_402']" ).hide();
                $("[name^='402']").checkbox('setValue', false);
            }
             //  else{$("[id^='div_403']").hide();$("[id^='div_402']" ).hide();}
               if(Label=="未接种"&&parName=="70900"){
                $("#71000").show();
                $("[id^='div_711']" ).show();
                $("[id^='div_712']" ).hide();
                $('[name="71200"]').checkbox('setValue', false);
                $('[name="71201"]').checkbox('setValue', false);
                $('[name="71202"]').checkbox('setValue', false);
                $('[name="71203"]').checkbox('setValue', false);
            }
               else if(Label=="已接种"&&parName=="70900"){
                $("#71000").show();
                $("#div_71200").show();
                $("#div_71100").hide();
                $('[name="71100"]').checkbox('setValue', false);
                var Label=Common_RadioLabel("71200");
                if(Label=="有反应"){
                 $('#div_71201').show();
                 $('#div_71202').hide();
                 $('#div_71203').hide();
                 $('[name="71202"]').checkbox('setValue', false);
                 $('[name="71203"]').checkbox('setValue', false);
                }
                else if(Label=="无反应"){
                 $('#div_71201').hide();
                 $('#div_71202').show();
                 $('#div_71203').hide();
                 $('[name="71201"]').checkbox('setValue', false);
                 $('[name="71203"]').checkbox('setValue', false);
                }
                else if(Label=="未知"){
                 $('#div_71201').hide();
                 $('#div_71202').hide();
                 $('#div_71203').show();
                 $('[name="71201"]').checkbox('setValue', false);
                 $('[name="71202"]').checkbox('setValue', false);
         }
                //$("[id^='div_711']" ).hide();
            }
              //else{$("#71000").hide();$("#div_71200").hide();$("[id^='div_711']" ).hide();}
            }
        });

    }

   }
      //
      //if(obj.RegTypeDesc.indexOf("血源性")>-1){
      obj.hideOrShow("div_20200","div_20210","皮肤","1")//接触方式
      obj.hideOrShow("div_20200","div_20220","粘膜","1")
      obj.hideOrShow("20600","20601","何种体液","1")
      obj.hideOrShow("20600","20602","其他","1")//危险物来源
      obj.hideOrShow("20800","20801","其他器械","1")//何种器械
      obj.hideOrShow("21100","21101","含血体液","1")
      obj.hideOrShow("21100","21102","其他","1")//污染物来源
      obj.hideOrShow("21300","21301","其他","1")//致伤方式
      obj.hideOrShow("div_40000","div_402","皮肤","2","div_402,div_403")//接触方式，皮肤
      //obj.hideOrShow("div_40000","div_403","粘膜","2","div_402,div_403")//接触方式，粘膜
      obj.hideOrShow("div_70900","div_711","未接种","2","710,div_711,div_712")//疫苗接种情况 未接种
      //obj.hideOrShow("div_70900","div_712","已接种","2","div_711,div_712")//疫苗接种情况 已接种
      obj.hideOrShow("div_71200","div_71201","有反应","1")//疫苗接种情况 已接种 有反应
      obj.hideOrShow("div_71200","div_71202","无反应","1")//疫苗接种情况 已接种 无反应
      obj.hideOrShow("div_71200","div_71203","未知","1")//疫苗接种情况 已接种 未知 
      //}
    //其他显示+隐藏
    $('#10201').hide();		//本次职业暴露
    $HUI.radio("[name='10200']", {
        onCheckChange: function () {
            var Label = Common_RadioLabel("10200");
            if (Label == "第二次") {
                $('#10201').show();
            }
            else {
                $('#10201').hide();
            }
        }
    });
    $('#10301').hide();		//工作类别
    $HUI.radio("[name='10300']", {
        onCheckChange: function () {
            var Label = Common_RadioLabel("10300");
            if (Label == "其他（需注明）") {
                $('#10301').show();
            }
            else {
                $('#10301').hide();
            }
        }
    });
    $('#10401').hide();		//暴露地点
    $HUI.radio("[name='10400']", {
        onCheckChange: function () {
            var Label = Common_RadioLabel("10400");
            if (Label == "其他（需注明）") {
                $('#10401').show();
            }
            else {
                $('#10401').hide();
            }
        }
    });
    $('#10601').hide();		//发生原因
    $HUI.checkbox("[name='10600']", {
        onCheckChange: function () {
            var Label = Common_CheckboxLabel("10600");
            if (Label.indexOf("其他（需注明）") >= 0) {
                $('#10601').show();
            }
            else {
                $('#10601').hide();
            }
        }
    });
    $('#10901').hide();		//暴露部位
    $HUI.radio("[name='10900']", {
        onCheckChange: function () {
            var Label = Common_RadioLabel("10900");
            if (Label == "其他（需注明）") {
                $('#10901').show();
            }
            else {
                $('#10901').hide();
            }
        }
    });
    $('#30201').hide();		//干预用药
    $HUI.radio("[name='30200']", {
        onCheckChange: function () {
            var Label = Common_RadioLabel("30200");
            if (Label == "是") {
                $('#30201').show();
            }
            else {
                $('#30201').hide();
            }
        }
    });
    $('#40101').hide();		//干预用药
    $HUI.checkbox("[name='40100']", {
        onCheckChange: function () {
            var Label = Common_RadioLabel("40100");
            if (Label != "") {
                $('#40101').show();
                $('#40101').attr("placeholder",Label+"请详述")
            }
            else {
                $('#40101').hide();
            }
        }
    });
    //复选框改变时间[追踪检测]
    $HUI.checkbox("[name='chkLab']", {
        onCheckChange: function () {
            var LabList = Common_CheckboxValue('chkLab');
            if (LabList == "") {
                $('#LabData').hide();
                $('#LineLab').hide();
            }
            else {
                $('#LabData').show();
                $('#LineLab').show()
            }
            if (LabList.indexOf("HBV") >= 0) {
                $("[id^='HBV']").show();
            }
            else {
                $("[id^='HBV']").hide();
            }
            if (LabList.indexOf("HCV") >= 0) {
                $("[id^='HCV']").show();
            }
            else {
                $("[id^='HCV']").hide();
            }
            if (LabList.indexOf("HIV") >= 0) {
                $("[id^='HIV']").show();
            }
            else {
                $("[id^='HIV']").hide();
            }
            if (LabList.indexOf("MD") >= 0) {
                $("[id^='MD']").show();
            }
            else {
                $("[id^='MD']").hide();
            }
        }
    });
    // 数据完整性验证
    obj.CheckInputData = function (StatusCode, TypeID) {
        //1.基本信息
        obj.ExpReg = obj.Reg_Save(StatusCode);
        if (!obj.ExpReg) {
            return false;
        }
        //2.暴露信息[1.登记报告,2.审核观察]
        obj.ExpRegExt = obj.RegExt_Save(TypeID);
        if ((!obj.ExpRegExt)&&(StatusCode!=8)) {
            return false;
        }
        //3.日志
        obj.ExpRegLog = obj.RegLog_Save(StatusCode, "");

        return true;
    }
    //初始化基本信息
    obj.Reg_Refresh = function () {
        obj.RepStatusCode = "0";	//默认为0
        var RegDataList = $cm({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryRepInfo",
            aRepID: ReportID,
            rows: 999
        }, false);
        if (RegDataList.total != 0) {
            var RegData = RegDataList.rows[0];

            $("#txtName").val(RegData.Name);		//姓名
            $("#txtRegNo").val(RegData.RegNo);		//工号
            if (RegData.Sex == obj.SexNLng) {				//性别
                $('#cboSex').combobox('setValue', 'M');
                $('#cboSex').combobox('setText', obj.SexNLng);
            }
            if (RegData.Sex == obj.SexVLng) {
                $('#cboSex').combobox('setValue', 'F');
                $('#cboSex').combobox('setText', obj.SexVLng);
            }
            $("#txtAge").val(RegData.Age);			//年龄
            $("#txtTelPhone").val(RegData.TelPhone);//电话
            $('#txtExpDateTime').datetimebox('setValue', RegData.ExpDate + ' ' + RegData.ExpTime);	//暴露时间
            $('#cboExpLoc').combobox('setValue', RegData.ExpLocID);			//所在科室
            $('#cboExpLoc').combobox('setText', RegData.ExpLocDesc);
            $("#txtRepStatus").val(RegData.StatusDesc);			//报告状态		
            $("#txtRegLoc").val(RegData.RegLocDesc);			//登记科室
            $("#txtRegUser").val(RegData.RegUserDesc);			//登记人
            //保存登记人/科室/日期/时间
            obj.RegLocID = RegData.RegLocID
            obj.RegUserID = RegData.RegUserID
            obj.RegDate = RegData.RegDate
            obj.RegTime = RegData.RegTime
            //保存状态(1.提交,2.审核)
            obj.RepStatusCode = RegData.StatusCode;
        }
    }
    //保存基本信息
    obj.Reg_Save = function (StatusCode) {
        var Name = $("#txtName").val(); 	//姓名
        var RegNo = $("#txtRegNo").val(); 	//工号
        var ExposerDr = $m({				//暴露人[obj]
            ClassName: "DHCHAI.BT.SysUser",
            MethodName: "GetIDByCode",
            aUserCode: RegNo
        }, false);
        var Sex = $('#cboSex').combobox('getValue'); 	//性别
        var Age = $("#txtAge").val(); 		//年龄
        var TelPhone = $("#txtTelPhone").val();			//电话
        var ExpDateTime = $('#txtExpDateTime').datetimebox('getValue');
        ExpDateTime = ExpDateTime.replace(" ", "")
        var ExpDate = ExpDateTime.substring(0, 10);        // 暴露日期
        var ExpTime = ExpDateTime.substring(10, 15);       // 暴露时间
        var ExpLoc = $('#cboExpLoc').combobox('getValue'); // 所在科室
        //院感科修正报告不更改登记人
        if ((ReportID != "") && (obj.AdminPower == 1)) {
            var RegLoc = obj.RegLocID;			//登记科室
            var RegUser = obj.RegUserID;		//登记人
            var RegDate = obj.RegDate;					//登记日期
            var RegTime = obj.RegTime;					//登记时间
        }
        else {
            var RegLoc = $.LOGON.LOCID;			//登记科室
            var RegUser = $.LOGON.USERID;		//登记人
            var RegDate = '';					//登记日期
            var RegTime = '';					//登记时间
        }
        //暂时并未使用	
        var Birthday = '';
        var WorkAge = '';
        var Duty = '';
        var ExpAddr = '';
        //数据完整性判断
        if (Name == '') {
            $.messager.alert("提示", "暴露者姓名不能为空!", 'info');
            return false;
        }
        if (RegNo == '') {
            $.messager.alert("提示", "工号不能为空!", 'info');
            return false;
        }
		if (ExpDateTime == '') {
            $.messager.alert("提示", "暴露时间不能为空!", 'info');
            return false;
        }
		
        if (Sex == '') {
            $.messager.alert("提示", "暴露者性别不能为空!", 'info');
            return false;
        }
		if (StatusCode!= 8) {
        if (Age == '') {
            $.messager.alert("提示", "暴露者年龄不能为空!", 'info');
            return false;
        }
        if (TelPhone == '') {
            $.messager.alert("提示", "暴露者联系电话不能为空!", 'info');
            return false;
        } else {
            var isMblNum = /^[1][3,4,5,7,8,9][0-9]{9}$/;
            var isPhNum = /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
            if (!isMblNum.test(TelPhone) && !isPhNum.test(TelPhone)) {
                $.messager.alert("提示", "暴露者联系电话格式有误!", 'info');
                return false;
            }
        }
        
        if (Common_CompareDate(ExpDate, Common_GetDate(new Date())) == 1) {
            $.messager.alert("提示", "暴露日期不能在当前日期之后!", 'info');
            return false;
        }
        if (ExpLoc == '') {
            $.messager.alert("提示", "员工工作科室为空!", 'info');
            return false;
        }
		}
		if (ExpDateTime == '') {
            $.messager.alert("提示", "暴露时间不能为空!", 'info');
            return false;
        }
        var InputReg = ReportID;
        InputReg = InputReg + CHR_1 + RegTypeID;
        InputReg = InputReg + CHR_1 + RegDate;
        InputReg = InputReg + CHR_1 + RegTime;
        InputReg = InputReg + CHR_1 + RegLoc;
        InputReg = InputReg + CHR_1 + RegUser;
        InputReg = InputReg + CHR_1 + StatusCode; 		//状态	
        InputReg = InputReg + CHR_1 + ExposerDr;
        InputReg = InputReg + CHR_1 + Name;
        InputReg = InputReg + CHR_1 + RegNo;
        InputReg = InputReg + CHR_1 + Sex;
        InputReg = InputReg + CHR_1 + Birthday;
        InputReg = InputReg + CHR_1 + Age;
        InputReg = InputReg + CHR_1 + WorkAge;
        InputReg = InputReg + CHR_1 + Duty;
        InputReg = InputReg + CHR_1 + ExpLoc;
        InputReg = InputReg + CHR_1 + ExpDate;
        InputReg = InputReg + CHR_1 + ExpTime;
        InputReg = InputReg + CHR_1 + ExpAddr;
        InputReg = InputReg + CHR_1 + TelPhone;

        return InputReg;
    }
    //初始化报告信息[1.登记报告,2.审核观察]
    obj.RegExt_Refresh = function () {
        //下拉菜单+日期置空
        var RegExtDataList = $cm({		//工龄,工作类别,暴露地点......
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryOccExpTypeExt",
            aTypeID: RegTypeID,
            rows: 999
        }, false);
        if (RegExtDataList) {
            var arrDT = RegExtDataList.rows;
            for (var ind = 0; ind < arrDT.length; ind++) {
                var rd = arrDT[ind];
                if (!rd) continue;
                var ItemDr = rd.ID;
                var DataType = rd.DatCode;
                var ItemCode = rd.Code;

                var ItemID = parseInt(ItemCode);
                if (DataType == "DD") {
                    $("#" + ItemID).datebox('setValue', "");
                }
                if (DataType == "S") {
                    $("#" + ItemID).combobox('clear');
                }
            }
        }
        //加载报告填写内容
        var RegExtDataList = $cm({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryExpExtInfo",
            aRepID: ReportID,
            rows: 999
        }, false);

        if (RegExtDataList != '') {
            if (RegExtDataList.total != 0) {
                var arrDT = RegExtDataList.rows;
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

                    var ItemID = parseInt(ItemCode);
                    //单选字典+单选长字典+是否+有无
                    if ((DataType == "DS") || (DataType == "DSL") || (DataType == "B1") || (DataType == "B2")) {
                        if (!ResultID) continue;
                        $HUI.radio('#' + ItemID + ResultID).setValue(true);

                    }
                    //多选字典+多选长字典
                    if ((DataType == "DB") || (DataType == "DBL")) {
                        if (ResultList == "") continue;
                        var Len = ResultList.split(",").length;
                        for (var jnd = 0; jnd < Len; jnd++) {
                            var Result = ResultList.split(",")[jnd];

                            $('#' + ItemID + Result).checkbox('setValue', true)
                        }
                    }
                    //文本类型
                    if ((DataType == "T") || (DataType == "TL") || (DataType == "N0") || (DataType == "N1") || (DataType == "TB")) {
                        $('#' + ItemID).val(ResultTxt);
                    }
                    //日期类型
                    if (DataType == "DD") {
                        $('#' + ItemID).datebox('setValue', ResultTxt);
                    }
                    if (DataType == "S") {
                        if (!ResultID) continue;
                        $("#" + ItemID).combobox('setValue', ResultID);
                        $("#" + ItemID).combobox('setText', ResultDesc);
                    }
                        //单选字典
                    if (DataType == "DST") {
                        if (!ResultID) continue;
                         $HUI.radio('#' + ItemID + ResultID).setValue(true);
                         $('#' + ItemID + ResultID).next().next().val(ResultTxt);
                        

                    }
                }
            }
        }
    }
    //保存报告信息[1.登记报告,2.审核观察]
    obj.RegExt_Save = function (aType) {
        //特殊判断(乙肝疫苗为'是',注射时间必填)
        var Hepatitis = Common_RadioLabel('10700');
        var Time = Common_RadioValue('10701');
        if ((Hepatitis == "是") && (Time == "")) {
            $.messager.alert("提示", "接种过乙肝疫苗,请填写注射时间!", 'info');
            return false;
        }
        
        var Parref = ReportID;		//父表ID[ReportID]
        //模块[1.暴露信息+暴露源信息,2.随访+用药]
        var RegExtDataList = $cm({
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryExpRegType",
            aRegTypeID: RegTypeID,
            aExtTypeID: aType,
            rows: 999
        }, false);
        for (var ind = 0; ind < RegExtDataList.total; ind++) {
            var RegExtData = RegExtDataList.rows[ind];
            var RegExtCode = RegExtData.TypeCode;	//blxx-1[暴露信息]

            var DicID = $m({
                ClassName: "DHCHAI.BT.Dictionary",
                MethodName: "GetIDByCode",
                aTypeCode: "OEExtType",
                aCode: RegExtCode,
                rows: 999
            }, false);
            if (DicID) {
                //职业暴露扩展项目[1.工龄,2.暴露地点,3.暴露部位......]
                var RegExtDicDataList = $cm({
                    ClassName: "DHCHAI.IRS.OccExpTypeSrv",
                    QueryName: "QryOccExpTypeExt",
                    aTypeID: RegTypeID,
                    aExtTypeID: DicID,
                    rows: 999
                }, false);
            } else {
                return false;
            }
            //加载具体信息
            var InputRegExts = "";
            if (RegExtDicDataList) {
                var arrDT = RegExtDicDataList.rows;

                for (var jnd = 0; jnd < arrDT.length; jnd++) {
                    var rd = arrDT[jnd];
                    if (!rd) continue;

                    var ItemDr = rd.ID;
                    var ItemCode = parseInt(rd.Code);
                    var ItemDesc = rd.Desc;
                    var DataType = rd.DatCode;
                    var Required = rd.IsRequired;
                    var ResultDr = '';
                    var ResultList = '';
                    var ResultTxt = '';
                    var ActUserDr = $.LOGON.USERID;
                    var TypeDesc = rd.TypeDesc;
                    var TypeCode = rd.TypeCode;

                    var ItemName = parseInt(ItemCode);
                    var ItemID = parseInt(ItemCode);
                    //单选+单选长字典+有无+是否
                    if ((DataType == "DS") || (DataType == "DSL") || (DataType == "B1") || (DataType == "B2")) {
                        ResultDr = Common_RadioValue(ItemName);
                    }
                    //多选+多选长字典
                    if ((DataType == "DB") || (DataType == "DBL")) {
                        $("input[name='" + ItemCode + "']:checked").each(function () {
                            ResultList = ResultList + $(this).val() + "#";
                        });
                        if (ResultList != "") { ResultList = ResultList.substring(0, ResultList.length - 1); }
                    }
                    //文本+长文本+大文本+数值+日期
                    if ((DataType == "T") || (DataType == "TL") || (DataType == "TB") || (DataType == "N0") || (DataType == "N1") || (DataType == "DD")) {
                        if (DataType == "DD") {								//日期
                            var ResultTxt = $("#" + ItemID).datebox('getValue');
                        }
                        else {
                            var ResultTxt = $("#" + ItemID).val();
                        }
                        //完整性判断
                        if ((ResultTxt != "") && (DataType == "N0")) {    	//整数类型   
                            var type = /(^[0-9]\d*$)/;
                            if (!type.test(ResultTxt)) {
                                $.messager.alert("提示", ItemDesc + "只允许输入0-9的数字!", 'info');
                                return false;
                            }
                        }
                        if ((ResultTxt != "") && (DataType == "N1")) {    	//小数类型
                            var regu = /^[0-9]+\.?[0-9]*$/; //小数
                            if (!regu.test(ResultTxt)) {
                                $.messager.alert("提示", ItemDesc + "只允许输入小数的数字!", 'info');
                                return false;
                            }
                        }
                        if ((ResultTxt != "") && (DataType == "DD")) {  	//日期类型
                            if (Common_GetDate(new Date()) < ResultTxt) {
                                $.messager.alert("提示", ItemDesc + "不能在当前日期之后!", 'info');
                                return false;
                            }
                        }
                    }
                    //下拉框
                    if (DataType == "S") {
                        var ResultDr = $("#" + ItemID).combobox('getValue');
                    }
                    if (DataType=="DST"){
                         $("input[name='"+ItemName+"']:checked").each(function(){
                              ResultDr = $(this).val(); 
                              
                              ResultTxt= $(this).next().next().val();
                        });
                        if ((Required == '1') && (ResultDr == "")&& (ResultTxt == "")){
                             $.messager.alert("提示", TypeDesc + '选项必填!', 'info');
                             return false;
                        }
                    }
                    //必选
                    if ((Required == '1') && ((ResultDr == "") && (ResultList == "") && (ResultTxt == ""))) {
                        $.messager.alert("提示", TypeDesc + '中的' + ItemDesc + '不允许为空!', 'info');
                        return false;
                    }

                    var ChildSub = $m({
                        ClassName: "DHCHAI.IR.OccExpRegExt",
                        MethodName: "GetIDByItemDr",
                        aReportID: Parref,
                        aItemDr: ItemDr
                    }, false);
                    var InputRegExt = Parref;
                    InputRegExt = InputRegExt + CHR_1 + ChildSub;
                    InputRegExt = InputRegExt + CHR_1 + ItemDr;		//关联项目
                    InputRegExt = InputRegExt + CHR_1 + ItemDesc;
                    InputRegExt = InputRegExt + CHR_1 + DataType;   //5
                    InputRegExt = InputRegExt + CHR_1 + ResultDr;
                    InputRegExt = InputRegExt + CHR_1 + ResultList;
                    InputRegExt = InputRegExt + CHR_1 + ResultTxt;
                    InputRegExt = InputRegExt + CHR_1 + '';
                    InputRegExt = InputRegExt + CHR_1 + '';         //10
                    InputRegExt = InputRegExt + CHR_1 + ActUserDr;
                    InputRegExts = InputRegExts + CHR_2 + InputRegExt;	 //保存多条
                }
                if (InputRegExts == "") {
                    $.messager.alert("提示", '暴露信息不能为空!', 'info');
                    return false;
                }
                return InputRegExts;
            }
        }
    }
    //刷新检验信息
    obj.RegLab_Refresh = function () {
        //加载送检列表[多选框]
        var LabList = $m({
            ClassName: "DHCHAI.IR.OccExpReg",
            MethodName: "GetOELabList",
            aRepID: ReportID
        }, false);
        for (var ind = 0; ind < LabList.split(",").length; ind++) {
            var Result = LabList.split(",")[ind];

            $('#chk' + Result).checkbox('setValue', true)
        }
        //初始化具体检验项目文本+日期+下拉菜单
        var RegLabDataList = $cm({
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryOccExpTypeLab",
            aTypeID: RegTypeID,
            aIsActive: 1,
            rows: 999
        }, false);
        if (RegLabDataList) {
            var arrDT = RegLabDataList.rows;
            for (var ind = 0; ind < arrDT.length; ind++) {
                var rd = arrDT[ind];
                if (!rd) continue;
                var LabTimDr = rd.ID;
                var SubID = LabTimDr.split("||")[1];

                $('#dtLabDate' + SubID).datebox('setValue', "");
                $("#txtLabItem" + SubID).val('');
                $("#cboLabResult" + SubID).combobox('clear');
            }
        }
        //加载检验项目填写信息 add by zhoubo 2021-10-08
        obj.RegLab = $cm({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryExpLabSubID",
            rows: 999,
            aRepID: ReportID
        }, false);
        if (obj.RegLab != '') {
            if (obj.RegLab.total != 0) {
                var arrDT = obj.RegLab.rows;
                for (var ind = 0; ind < arrDT.length; ind++) {
                    var rd = arrDT[ind];
                    if (!rd) continue;
                    var SubID = rd.SubID;

                    $("#txtLabItem" + SubID).val(rd.LabTestDesc);
                    $('#dtLabDate' + SubID).datebox('setValue', rd.LabRegDate);
                    $("#cboLabResult" + SubID).combobox('setText', rd.LabResult);
                }
            }
        }

        //加载具体检验信息
        var RegLabDataList = $cm({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryExpLabInfo",
            aRepID: ReportID,
            rows: 999
        }, false);
        if (RegLabDataList.total != 0) {
            var arrDT = RegLabDataList.rows;
            for (var ind = 0; ind < arrDT.length; ind++) {
                var rd = arrDT[ind];
                if (!rd) continue;
                var SubID = rd.LabTimID.split("||")[1];

                $('#dtLabDate' + SubID).datebox('setValue', rd.LabDate);
                $("#txtLabItem" + SubID).val(rd.LabItem);
                $("#cboLabResult" + SubID).combobox('setValue', rd.Result.split("|")[0]);
                $("#cboLabResult" + SubID).combobox('setText', rd.Result.split("|")[1]);
            }
        }
    }
    //保存检验信息
    obj.RegLab_Save = function () {
        //保存送检列表[多选框]
        var LabList = Common_CheckboxValue('chkLab');
        var ret_1 = $m({
            ClassName: "DHCHAI.IR.OccExpReg",
            MethodName: "SaveOELabList",
            aRepID: ReportID,
            aLabList: LabList
        }, false);

        var Parref = ReportID;
        if (!Parref) {
            $.messager.alert("提示", '先填写职业暴露相关信息!', 'info');
            return -1;
        }
        var InputRegLabs = "";
        var RegLabDataList = $cm({
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryOccExpTypeLab",
            aTypeID: RegTypeID,
            aIsActive: 1,
            rows: 999
        }, false);
        if (RegLabDataList) {
            var arrDT = RegLabDataList.rows;
            for (var ind = 0; ind < arrDT.length; ind++) {
                var rd = arrDT[ind];
                if (!rd) continue;
                var LabTimDr = rd.ID;
                var SubID = LabTimDr.split("||")[1];
                //检验日期
                var LabDate = $("#dtLabDate" + SubID).datebox('getValue');
                if (LabDate == "") continue;
                if (Common_CompareDate(LabDate, Common_GetDate(new Date())) == 1) {
                    $.messager.alert("提示", rd.BTDesc + ' ' + rd.Resume + ' ' + '检验日期不能在当前日期之后!', 'info');
                    return -1;
                }
                //检验项目
                var LabItem = $("#txtLabItem" + SubID).val();
                if (LabItem == '') {
                    $.messager.alert("提示", rd.BTDesc + ' ' + rd.Resume + ' ' + '检验项目不能为空!', 'info');
                    return -1;
                }
                //检验结果
                var Result = $("#cboLabResult" + SubID).combobox('getValue') + "|" + $("#cboLabResult" + SubID).combobox('getText');
                if (Result == '') {
                    $.messager.alert("提示", rd.BTDesc + ' ' + rd.Resume + ' ' + '检验结果不能为空!', 'info');
                    return -1;
                }

                var DeptDesc = '';
                var Collector = '';
                var Reterence = '';
                var Examiner = '';
                var ChildSub = $m({
                    ClassName: "DHCHAI.IR.OccExpRegLab",
                    MethodName: "GetIDByTimDr",
                    aReportID: Parref,
                    aLabTimDr: LabTimDr
                }, false);
                var InputRegLab = Parref;
                InputRegLab = InputRegLab + CHR_1 + ChildSub;
                InputRegLab = InputRegLab + CHR_1 + LabTimDr;
                InputRegLab = InputRegLab + CHR_1 + LabDate;
                InputRegLab = InputRegLab + CHR_1 + LabItem;
                InputRegLab = InputRegLab + CHR_1 + Result;
                InputRegLab = InputRegLab + CHR_1 + DeptDesc;
                InputRegLab = InputRegLab + CHR_1 + Collector;
                InputRegLab = InputRegLab + CHR_1 + Reterence;
                InputRegLab = InputRegLab + CHR_1 + Examiner;
                InputRegLabs = InputRegLabs + CHR_2 + InputRegLab;
            }
            return InputRegLabs;
        }
    }

    //保存日志
    obj.RegLog_Save = function (StatusCode, Opinion) {
        var InputRegLog = ReportID;
        InputRegLog = InputRegLog + CHR_1 + '';
        InputRegLog = InputRegLog + CHR_1 + StatusCode;		//状态
        InputRegLog = InputRegLog + CHR_1 + Opinion;
        InputRegLog = InputRegLog + CHR_1 + '';
        InputRegLog = InputRegLog + CHR_1 + '';
        InputRegLog = InputRegLog + CHR_1 + $.LOGON.USERID;

        return InputRegLog;
    }
    // 保存报告内容+状态
    obj.Save = function () {
        var ret = $m({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            MethodName: "SaveExpReport",
            aExpReg: obj.ExpReg,
            aExpRegExts: obj.ExpRegExt,
            aExpRegLog: obj.ExpRegLog
        }, false);
        if (parseInt(ret) > 0) {
            ReportID = parseInt(ret);
            // 环境卫生学监测检验标本 add by zhoubo 2021-10-08
            var retval = $m({
                ClassName: "DHCHAI.DP.LabInfVisitNumber",
                MethodName: "SaveOCCLabBarcode",
                aReportID: ReportID
            });
            obj.LoadEvent()		//刷新
            return true;
        } else {
            return false;
        }
    }
    // 保存日志
    obj.SaveLog = function (StatusCode, Opinion) {
        obj.ExpRegLog = obj.RegLog_Save(StatusCode, Opinion);

        var ret = $m({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            MethodName: "SaveRepLog",
            aReportID: ReportID,
            aExpRegLog: obj.ExpRegLog
        }, false);
        if (parseInt(ret) > 0) {
            ReportID = parseInt(ret);
            return true;
        } else {
            return false;
        }
    }
    // 保存报告状态
    obj.SaveStatus = function (StatusCode, Opinion) {
        obj.ExpRegLog = obj.RegLog_Save(StatusCode, Opinion);

        var ret = $m({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            MethodName: "SaveRepStatus",
            aReportID: ReportID,
            aStatus: StatusCode,
            aExpRegLog: obj.ExpRegLog
        }, false);
        if (parseInt(ret) > 0) {
            ReportID = parseInt(ret);
            return true;
        } else {
            return false;
        }
    }
}

