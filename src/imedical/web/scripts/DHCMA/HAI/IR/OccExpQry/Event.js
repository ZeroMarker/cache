//页面Event
function InitOccExpQryWinEvent(obj) {
    //点击头链接
    $('#custtb > a').click(function (e) {
        var RepID = $(this).attr('text');
        if (RepID=="") {
            $.messager.alert("提示", "暴露项目为空!", 'info');
        }
        else if (RepID == "btnExport") { //导出
        	var rows 			= obj.gridExpReg.getRows();  //返回当前页的所有行
        	
        	if(rows.length==0){
	        	$.messager.alert("错误","当前界面没有数据，无法导出!", 'info');
				return;
	        }
        	
            $('#gridExpReg').datagrid('toExcel', '职业暴露登记表.xls');   //导出
        }
        else {
            //获取职业暴露长度
            var flag = $cm({
                ClassName: "DHCHAI.IRS.OccExpTypeSrv",
                QueryName: "QryOccExpTypeExt",
                aTypeID: RepID
            }, false);
            var Length = flag.total;
            if (Length != 0) {
                var aRegTypeID = $(this).attr("text");
                var aReportID = "";

                obj.OpenOccView(aRegTypeID, aReportID, obj.AdminPower);   //打开职业暴露报告
            }
        }
    });
    obj.LoadEvent=function(){
		 obj.refreshgridExpReg();
	}
    //查询
    $("#btnQuery").on('click', function () {
        obj.refreshgridExpReg();
    });
    //刷新职业暴露表
    obj.refreshgridExpReg = function () {
        var aHospID = $('#cboHospital').combobox('getValue');   //院区
        var aRepType = $('#cboRepType').combobox('getValue');   //报告类型
        var aDateType = $('#cboDateType').combobox('getValue');   //日期类型
        var aDateFrom = $('#DateFrom').datebox('getValue');      //开始日期
        var aDateTo = $('#DateTo').datebox('getValue');     //结束日期

        var aRegLoc = $('#cboLocation').combobox('getValue');   //登记科室
        var aStatus = $('#cboStatus').combobox('getValue');   //报告状态
        var aLabStatus = $('#cboLabStatus').combobox('getValue');   //追踪检测
        if (aDateFrom > aDateTo) {
            $.messager.alert("提示", "开始日期应小于或等于结束日期!", 'info'); 
            return;
        }
        var curreDate = Common_GetDate(new Date());
		if (Common_CompareDate(aDateFrom,curreDate)) {
			$.messager.alert("提示", "开始日期大于当前日期!", 'info');
            return;
		}
        //后台加载刷新
        obj.gridExpReg.load({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryOccExpReg",
            aHospIDs: aHospID,
            aRepType: aRepType,
            aDateType: aDateType,
            aDateFrom: aDateFrom,
            aDateTo: aDateTo,
            aRegLoc: aRegLoc,
            aStatus: aStatus,
            aLabStatus:aLabStatus
        })
    }
    obj.refreshgridExpReg();
    //打开职业暴露报告
    obj.OpenOccView = function (aRegTypeID, aReportID, aAdminPower) {
        var url = '../csp/dhcma.hai.ir.occexpreport.csp?&RegTypeID=' + aRegTypeID + '&ReportID=' + aReportID + "&AdminPower=" + obj.AdminPower;
        websys_showModal({
            url: url,
            title: '职业暴露报告',
            iconCls: 'icon-w-paper',
            width: '1320',
            height: '95%',
            onBeforeClose: function () {
                obj.refreshgridExpReg();
            }
        });
    }
    //打开操作明细
    obj.OpenOccRepLog = function (aRepID) {
        $('#LayerOccRepLog').show();
        $HUI.dialog('#LayerOccRepLog', {
            title: "操作明细",
            iconCls: 'icon-w-paper',
            width: 800,
            height: 500,
            modal: true,
            isTopZindex: true
        });
        obj.refreshgridExpRepLog(aRepID);
    }
    //打印条码
    obj.OpenOccRepBarCode = function (aRepID) {
        $('#LayerOccBarCode').show();
        $HUI.dialog('#LayerOccBarCode', {
            title: "打印条码",
            iconCls: 'icon-w-paper',
            width: 670,
            height: 500,
            modal: true,
            isTopZindex: true
        });
        obj.refreshgridExpBarCode(aRepID);
    }
    //刷新操作明细
    obj.refreshgridExpRepLog = function (aRepID) {
        //后台加载刷新
        obj.gridExpRepLog.load({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryExpRepLog",
            aRepID: aRepID
        })
    }
    //刷新检查项目
    obj.refreshgridExpBarCode = function (aRepID) {
	    var LabList = $m({
        	ClassName: "DHCHAI.IR.OccExpReg",
            MethodName: "GetOELabList",
          	aRepID: aRepID
       	}, false);
       	
        //后台加载刷新
        obj.gridExpBarCode.load({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryExpLabSubByType",
            aRepID: aRepID,
            aLabList: LabList
        })
    }
    //打印条码
    obj.PrintBarCode = function (aRepID,aRegTypeDesc,aSpenBarCode,aDesc,aBTResume) {
	    vBarCode = "*O"+aSpenBarCode+"*";
		PrintXMLBar(aRepID,aRegTypeDesc,vBarCode,aDesc,aBTResume);
    }
    function  PrintXMLBar(aRepID,aRegTypeDesc,aSpenBarCode,aDesc,aBTResume) {
		 var printParam="";
	     var printList="";
	     // 获取XML模板配置
	 	 DHCP_GetXMLConfig("InvPrintEncrypt","DHCHAIEnviHyBar");
	 	 // 打印参数
	     printParam=printParam+"ItemDesc"+String.fromCharCode(2)+aRegTypeDesc;
	     printParam=printParam+"^NormObject"+String.fromCharCode(2)+aDesc;
	     printParam=printParam+"^ItemDate"+String.fromCharCode(2)+aBTResume;
	     printParam=printParam+"^LocDesc"+String.fromCharCode(2)+"";
	     printParam=printParam+"^BarCode"+String.fromCharCode(2)+aSpenBarCode;	
	     printParam=printParam+"^BarCodeNo"+String.fromCharCode(2)+aSpenBarCode; 
	     // 打印控件
	      if (xmlPrintFlag==2){
             // lodop打印
            DHC_PrintByLodop(getLodop(),printParam,"","","");   
         } else{
              // 控件打印
         	var printControlObj=document.getElementById("barPrintControl");
		 	DHCP_XMLPrint(printControlObj,printParam,printList);		
		}
    }
	//追踪检测相关
    //1.初始化追踪检测
    obj.InitOccLab=function(aRegTypeID,aRepID){
	    //加载职业暴露检验类别[HBV,HCV,HIV,梅毒]
	    var LabTypeList = $m({
        	ClassName: "DHCHAI.IR.OccExpReg",
            MethodName: "GetOELabList",
            aRepID: aRepID
        }, false);
        if(LabTypeList=="")return -1;
	    
		//加载检验列表
	    var LabList = $cm({
        	ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        	QueryName: "QryOccExpTypeLab",
        	aTypeID: aRegTypeID,
			aIsActive:1,
			rows:999
    	}, false);
    	var Html="<div id='LabData' style='padding-battom:10px;'><table class='report-tab'>";
    	for (var i = 0; i < LabList.total; i++) {
       	 	var LabData = LabList.rows[i];
        	var ID = LabData.ID;
        	var BTDesc = LabData.BTDesc;
        	var BTDays = LabData.BTDays;
        	var Resume = LabData.Resume;
        	var SubID = ID.split("||")[1];
			var LabType=LabData.LabType;
			//过滤检验类别
			if(LabTypeList.indexOf(LabType)<0)continue;
		
        	var Html = Html + '	<tr id="'+LabType+"_"+SubID+'" class="report-tr">'
                        + '		<td style="padding-left:50px;">' + BTDesc + '</td>'
                        + '		<td class="report-td">' + Resume + '</td>'
                        + '		<td class="report-td">检验日期</td>'
                        + '		<td><input class="hisui-datebox textbox" id="dtLabDate' + SubID + '" style="width: 150px; " /></td>'
                        + '		<td class="report-td">检验项目</td>'
                        + '		<td><input class="textbox" id="txtLabItem' + SubID + '" style="width: 150px; " /></td>'
                        + '		<td class="report-td">检验结果</td>'
                        //下拉框
                        + '		<td><input class="textbox" id="cboLabResult' + SubID + '" style="width: 150px; " /></td>'
                       	+ '	</tr>';
   		}
    	var Html = Html +'<tr><td colspan="8" class="search-btnlist">'
    			+ '<a id="btnSave" class="hisui-linkbutton">保存</a>'
    			+' <a id="btnClose" class="hisui-linkbutton">关闭</a>'
    			+'</td></tr>'
    			+'</table></div>';
    	$('#LayerLab').html(Html);
    	$.parser.parse('#LayerLab');
    	//初始化下拉框
    	for (var i = 0; i < LabList.total; i++) {
       	 	var LabData = LabList.rows[i];
        	var ID = LabData.ID;
        	var SubID = ID.split("||")[1];
        
        	$HUI.combobox("#cboLabResult"+SubID, {
				editable: true,
				allowNull: true, 
				valueField: 'value',
				textField: 'text',
				data: [
					{ value: '1', text: '阴性' },
					{ value: '2', text: '阳性' },
					{ value: '3', text: '不详' }
        		]
			});
    	}
    	//初始化具体检验项目文本+日期+下拉菜单
        var RegLabDataList = $cm({
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryOccExpTypeLab",
            aTypeID: aRegTypeID,
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
            aRepID: aRepID
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
        //保存事件
        $('#btnSave').click(function (e) {	
        	//获取日志信息
        	obj.ExpRegLog = obj.RegLog_Save(2, "");
        	//获取检验信息
        	obj.ExpRegLab = obj.SaveOccLab();
        	
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
                	 $.messager.alert("提示", '保存成功!', 'info');
                	 return true;
            	} else {
                	 $.messager.alert("提示", '保存失败!', 'info');
                	 return false;
            	}
        	}
    	})
        //关闭事件
        $('#btnClose').on('click', function () {
            $HUI.dialog('#LayerLab').close();
        });
	}
    //2.加载追踪检测
    obj.LoadOccLab=function(aRepID){
		//加载具体检验信息
        var RegLabDataList = $cm({
            ClassName: "DHCHAI.IRS.OccExpRegSrv",
            QueryName: "QryExpLabInfo",
            aRepID: aRepID,
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
                //管理员权限
        		if(obj.AdminPower==1){
	    			$('#dtLabDate' + SubID).datebox('enable');
	    			$("#txtLabItem" + SubID).removeAttr("disabled");
	    			$("#cboLabResult" + SubID).combobox('enable');
	    		}
	    		else{
		    		$('#dtLabDate' + SubID).datebox('disable');
		    		$("#txtLabItem" + SubID).attr("disabled","disabled");
		    		$("#cboLabResult" + SubID).combobox('disable');
		    	}
            }
        }
	}
    //3.打开追踪检测
    obj.OpenOccLab = function (aRegTypeID,aRepID) {
	    //赋值
	    obj.RegTypeID=aRegTypeID;
	    obj.RepID=aRepID;
	    
	    var Ret=obj.InitOccLab(aRegTypeID,aRepID);
	    if(Ret<0){
			$.messager.alert("提示", "追踪检测项目为空!", 'info');
			return false;
		}
	    obj.LoadOccLab(aRepID);
	    //打开弹出框
    	$('#LayerLab').show();
        $HUI.dialog('#LayerLab', {
            title: "追踪检测",
            iconCls: 'icon-w-paper',
            width: 1000,
            modal: true,
            isTopZindex: true
        })
	}
    //4.保存追踪检测
    obj.SaveOccLab = function () {
	     //加载职业暴露检验类别[HBV,HCV,HIV,梅毒]
	    var LabTypeList = $m({
        	ClassName: "DHCHAI.IR.OccExpReg",
            MethodName: "GetOELabList",
            aRepID: obj.RepID
        }, false);
        
        var InputRegLabs = "";
        var RegLabDataList = $cm({
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryOccExpTypeLab",
            aTypeID: obj.RegTypeID,
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
                
                //过滤检验类别
                var LabType=rd.LabType;
				if(LabTypeList.indexOf(LabType)<0)continue;
				
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
                    aReportID: obj.RepID,
                    aLabTimDr: LabTimDr
                }, false);
                var InputRegLab = obj.RepID;
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
        var InputRegLog = obj.RepID;
        InputRegLog = InputRegLog + CHR_1 + '';
        InputRegLog = InputRegLog + CHR_1 + StatusCode;		//状态
        InputRegLog = InputRegLog + CHR_1 + Opinion;
        InputRegLog = InputRegLog + CHR_1 + '';
        InputRegLog = InputRegLog + CHR_1 + '';
        InputRegLog = InputRegLog + CHR_1 + $.LOGON.USERID;

        return InputRegLog;
    }
}