var app={
    opts:{
    },

    /**
     * 页面初始化入口
     */
    initPage:function(){
        var _this=app;
        _this.changeCSS();
        _this.loadAppConfig();
        _this.loadCommonDatas();
        _this.initFormOptions();
        _this.initOperAction();

        if(_this.opts.newApp==="Y"){
            // 新申请手术，加载患者列表
			if(!_this.VerifyConditions(true)) return;
            _this.initPatList();
            _this.loadPatInfo();
            _this.setNewAppDefValue();
            var showDialog=dhccl.getQueryString("showDialog");
            if(showDialog==="Y"){
                $("#btnPatList").remove();
            }
        }else { 
            // 如果是暂存手术，那么要加载患者列表
            if (_this.opts.tempApp==="Y"){
                _this.initPatList();
            }else{
                $("#btnSaveTemp").remove();
                $("#btnPatList").remove();
            }
            _this.loadAppData();
            
        }

        _this.loadAppFormData();
    },

    /**
     * 需要在JS修改的CSS
     */
    changeCSS:function(){
        // 根据UI规范，修改微调框
        $(".spinner-text").each(function(index,item){
            var spinnerWidth=$(item).width();
            $(item).css("width",(spinnerWidth-5)+"px");
        });
    },

	/**
     * 验证手术申请前的必要条件是否满足
     */
    VerifyConditions:function(showMessage){
		var ret=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"VerifyConditions",session.EpisodeID);
		if(ret!=="Y"){
			$.messager.alert("提示",ret,"warning");
			return false;
        }
		else{
			return true;
        }
    },

    /**
     * 初始化患者列表
     */
    initPatList:function(){
        var _this=app;
        $("#btnPatList").linkbutton({
            onClick:function(){
                $("#patListDialog").dialog("open");
            }
        });

        var columns =[[
            { field: 'PatientID', title: 'PatientID', width: 55, hidden: true },
            { field: 'PAPMIName', title: '姓名', width: 100 },
            { field: 'PAPMISex', title: '性别', width: 40 },
            { field: 'Age', title: '年龄', width: 60 },
            { field: 'PAAdmDepCodeDR', title: '科室', width: 140 },
            { field: 'PAAdmWard', title: '病区', width: 140 },
            { field: 'PAAdmBed', title: '床位', width: 60 },
            { field: 'EpisodeID', title: 'EpisodeID', width: 80 }]];
        
        $("#patientsList").datagrid({
            fit: true,
            singleSelect: true,
            pagination: false,
            iconCls:'icon-paper',
            headerCls:'panel-header-gray',
            url: ANCSP.DataQuery,
            toolbar: "#patListTool",
            rownumbers:true,
            border:true,
            bodyCls: 'panel-body-gray',
            queryParams: {
                ClassName: CLCLS.BLL.Admission,
                QueryName: "FindLocDocCurrentAdm",
                ArgCnt: 13
            },
            onBeforeLoad: function(param) {
                var locId=$("#patLoc").combobox("getValue");
                param.Arg1 = locId;
                param.Arg2 = session.ExtUserID;
                param.Arg3 = "";
                param.Arg4 = "";
                param.Arg5 = "";
                param.Arg6 = $("#patientNo").val();
                param.Arg7 = "";
                param.Arg8 = "";
                (locId == "") ? param.Arg9 = "": param.Arg9 = "on";
                param.Arg10 = "";
                param.Arg11 = "on";
                param.Arg12 = "";  //$("#patWard").combobox("getValue");
                param.Arg13 = "";
            },
            columns:columns,
            onDblClickRow:function(rowIndex,rowData){
                var patLocId=$("#patLoc").combobox("getValue");
                var patWardId=""  //$("#patWard").combobox("getValue");
                var showDialog=dhccl.getQueryString("showDialog") || '';
                window.location.href="cis.an.operapplication.csp?EpisodeID="+rowData.EpisodeID+"&PatientID="+rowData.PatientID+"&mradm="+rowData.mradm+"&patLocId="+patLocId+"&patWardId="+patWardId+"&showDialog="+showDialog;
            }
        });

        $("#btnSearch").linkbutton({
            onClick:function(){
                $("#patientsList").datagrid("reload");
            }
        });

        $("#patLoc").combobox("setValue",session.DeptID);

        var showDialog=dhccl.getQueryString("showDialog");
        var EpisodeID=dhccl.getQueryString("EpisodeID");
        if(_this.opts.newApp==="Y" && showDialog==="Y" && !EpisodeID){
            $("#patListDialog").dialog("open");
        }
    },

    /**
     * 初始化手术申请表单
     */
    initFormOptions:function(){
        var _this=app;
        _this.diagnosis.initDiagBox();
        _this.operation.initOperBox();

        var appDeptOptions=_this.operation.getSurgeonDeptOptions();
        $("#patLoc").combobox(appDeptOptions);
        appDeptOptions.readonly=true;
        appDeptOptions.hasDownArrow=false;
        $("#AppDeptID").combobox(appDeptOptions);

        $("#patWard").combobox({
            valueField:"RowId",
            textField:"Description",
            panelWidth:200,
            data:_this.opts.patWards
        });

        var appCareProvOptions=_this.operation.getAppCareProvOptions();
        appCareProvOptions.readonly=true;
        appCareProvOptions.hasDownArrow=false;
        $("#AppCareProvID").combobox(appCareProvOptions);

        var anaDeptOptions=_this.operation.getAnaDeptOptions();
        anaDeptOptions.data=_this.opts.anaDepts;
        $("#AnaDept").combobox(anaDeptOptions);

        var operDeptOptions=_this.operation.getOperDeptOptions();
        operDeptOptions.data=_this.opts.operDepts;
        $("#OperDeptID").combobox(operDeptOptions);

        var operPosOptions=_this.operation.getOperPosOptions();
        $("#OperPosition").combobox(operPosOptions);

        

        $("#IsoOperation,#ECC,#TransAutoblood,#PrepareBlood,#InfectionOper,#MIS,#Antibiosis,#ReentryOperation").combobox({
            valueField:"value",
            textField:"text",
            data:CommonArray.WhetherOrNot,
            editable:false
        });

        $("#HbsAg,#HcvAb,#HivAb,#Syphilis,#MDROS").combobox({
            valueField:"value",
            textField:"text",
            data:CommonArray.InfectionTypes,
            editable:false
        });

        $("#BloodType").combobox({
            valueField:"value",
            textField:"text",
            data:CommonArray.BloodTypes,
            editable:false
        });

        $("#RHBloodType").combobox({
            valueField:"value",
            textField:"text",
            data:CommonArray.RHDTypes,
            editable:false
        });

        $("#SeqType").combobox({
            valueField:"value",
            textField:"text",
            data:CommonArray.SeqTypes,
            editable:false
        });

        $("#SourceType").combobox({
            valueField:"value",
            textField:"text",
            data:CommonArray.SourceTypes,
            editable:false,
            onSelect:function(record){
                var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetOperDate",record.value);
                if(ret && ret.result){
					if(record.value==="E"){
						$('#OperDate').datebox({disabled:true});
						$("#OperDate").datebox("setValue",ret.result);
					}
					else{
						$('#OperDate').datebox({disabled:false});
						$("#OperDate").datebox("setValue",ret.result);
					}
                }
            }
        });

        $('#OperDate').datebox({
            onSelect:function(date){
                var SelectedDate = $("#OperDate").datebox('getValue');
                var dateFormat = session.DateFormat;
                if (dateFormat.indexOf("/") >= 0){
                    var tomorrow=new Date().addDays(1);
                    var tomorrow= tomorrow.format("dd/MM/yyyy");
                }else{
                    var tomorrow=new Date().addDays(1);
                    var tomorrow= tomorrow.format("yyyy-MM-dd");
                }
                if(app.opts.sourceType=="E"){
                    if(SelectedDate>tomorrow){
                        $("#SourceType").combobox("setValue","B");
                    }else{
                        $("#SourceType").combobox("setValue","E");
                    }
                }
            }
        })

        $("#PrevAnaMethod").combobox({
            valueField:"RowId",
            textField:"Description",
            data:_this.opts.anaMethodList,
            filter:function(q,row){
                return row.Description.indexOf(q)>=0
            }
        });

        $("#OperRequirement").combobox({
            valueField:"value",
            textField:"text",
            rowStyle:"checkbox",
            multiple:true,
            data:[{
                value:"隔离手术",
                text:"隔离手术"
            },{
                value:"体外循环",
                text:"体外循环"
            },{
                value:"自体血回输",
                text:"自体血回输"
            },{
                value:"备血",
                text:"备血"
            },{
                value:"感染手术",
                text:"感染手术"
            },{
                value:"微创手术",
                text:"微创手术"
            },{
                value:"使用抗菌药物",
                text:"使用抗菌药物"
            }]
        });
    },

    /**
     * 初始化功能操作按钮
     */
    initOperAction:function(){
        $("#btnSave").linkbutton({
            onClick:app.save
        });

        $("#btnSaveTemp").linkbutton({
            onClick:app.tempSave
        });

        $("#btnRefresh").linkbutton({
            onClick:function () {
                $.messager.confirm("提示","是否刷新页面，刷新后清除当前表单输入的数据？",function(r){
                    if(r){
                        window.location.reload();
                    }
                });
            }
        })
		var EnableAppTempSave=dhccl.runServerMethodNormal(ANCLS.BLL.DataConfiguration,"GetValueByKey","EnableAppTempSave");
        if(EnableAppTempSave!="Y"){
			$("#btnSaveTemp").remove();
		}
    },

    /**
     * 新增申请时，设置表单部分元素的默认值。
     */
    setNewAppDefValue:function(){
        var _this=app;
        var _opts=app.opts;
        // 获取默认手术室
        $("#OperDeptID").combobox("setValue",_opts.defOperDept);
        $("#AnaDept").combobox("setValue",_opts.defANDept);
        $("#SourceType").combobox("setValue",_opts.sourceType);
        if(_opts.sourceType=="E"){
            $("#SourceType").combobox("readonly");
        }
		dhccl.parseDateFormat();
        $("#OperDate").datebox("setValue",_opts.operDate)

        // 默认手术申请科室为本科室
        $("#AppDeptID").combobox("setValue",session.DeptID);

        // 默认手术申请医生为当前登录的医护人员
        $("#AppCareProvID").combobox("setValue",session.CareProvID);

        // 默认手术时间为早上8:00
        $("#OperTime").timespinner("setValue","08:00")

        // 默认手术时长为2小时
        $("#OperDuration").numberspinner("setValue",2)

        // 台次类型默认正常台
        $("#SeqType").combobox("setValue","N");

        // 检验项目结果取自检验组
        _this.setNewAppTestResult()

        $("#AppUserID").val(session.UserID);

        $("#PlanSeq").numberspinner("setValue",1);

        $("#ReentryOperation").combobox("setValue","N");

        $("#OperPosition").combobox("setValues","");
        if(_opts.admDiagnosis && _opts.admDiagnosis.length>0){
            $("#preopDiagBox").datagrid("loadData",_opts.admDiagnosis);
        }
        
    },

    /**
     * 新增申请时，设置表单检验数据元素的默认值
     */
    setNewAppTestResult:function(){
        var testResult=app.opts.testResult;
        if (testResult){
            for(var key in testResult){
                $("#"+key).combobox("setValue",testResult[key]);
            }
        }
    },

    /**
     * 加载手术申请配置
     */
    loadAppConfig:function(){
        var _this=app;
        var appOptsDatas=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetAppConfig",session.DeptID,session.EpisodeID,session.OPSID,session.HospID);
        if(appOptsDatas && appOptsDatas.length>0){
            _this.opts=$.extend(appOptsDatas[0],app.opts);
        }
    },

    /**
     * 加载手术申请数据
     */
    loadAppData:function(){
        if(session.OPSID){
            var _this=app;
            var queryPara = [{
                ListName: "appDatas",
                ClassName: ANCLS.BLL.OperScheduleList,
                QueryName:"FindOperScheduleList",
                Arg1:"",
                Arg2:"",
                Arg3:"",
                Arg4:session.OPSID,
                ArgCnt:4
            },
            {
                ListName: "operList",
                ClassName:ANCLS.BLL.OperationList,
                QueryName:"FindPlanOperationList",
                Arg1:session.OPSID,
                ArgCnt:1
            }];

            var queryData = dhccl.getDatas(ANCSP.DataQueries, {
                jsonData: dhccl.formatObjects(queryPara)
            }, "json");
            if (queryData) {
                for (var key in queryData) {
                    _this.opts[key] = queryData[key];
                }
                if(_this.opts.appDatas && _this.opts.appDatas.length>0){
                    _this.opts.appData=_this.opts.appDatas[0]; 
                    
                    var prevDiagnosisDesc=_this.opts.appData.PrevDiagnosis;  //诊断目前有两种格式，不对 YuanLin  20200827
                    if(prevDiagnosisDesc){
                        var diagListArr=prevDiagnosisDesc.split("&&&"),diagList=[];
                        for(var i=0;i<diagListArr.length;i++){
                            var diagArr=diagListArr[i].split("###");
                            diagList.push({
                                DiagID:"",
                                DiagDesc:diagArr[1],
                                DiagNote:diagArr[2]
                            });
                        }
                        _this.opts.diagList=diagList;
                    }
                }
            }
        }
    },

    /**
     * 选择患者时，加载患者信息
     */
    loadPatInfo:function(){
        if(session.EpisodeID){
            var patDataList=dhccl.getDatas(ANCSP.DataQuery,{
                ClassName:CLCLS.BLL.Admission,
                QueryName:"FindPatient",
                Arg1:session.EpisodeID,
                ArgCnt:1
            },"json");
            if(patDataList && patDataList.length>0){
                app.opts.patData=patDataList[0];
            };
            var diagDataList=dhccl.getDatas(ANCSP.DataQuery,{
                ClassName:CLCLS.BLL.Admission,
                QueryName:"FindAdmDiagnosis",
                Arg1:session.EpisodeID,
                Arg2:"C008",
				ArgCnt:2
            },"json");
			var diagList=[];
            if(diagDataList && diagDataList.length>0){
				for(var i=0;i<diagDataList.length;i++){
					diagList.push({
						DiagID:diagDataList[i].DiagID,
						DiagDesc:diagDataList[i].DiagDesc.split("(")[0],
						DiagNote:diagDataList[i].DiagnosNote,
					});
					app.opts.diagList=diagList;
				}
            }
        }
    },

    /**
     * 填充手术申请表单
     * @param {object} data 表单数据
     */
    loadAppFormData:function(){
        if(app.opts.newApp==="Y"){
            $("#appForm").form("load",app.opts.patData);
        }else{
			dhccl.parseDateFormat();
            $("#appForm").form("load",app.opts.appData);
            var operPosition=app.opts.appData.OperPosition;
            if(operPosition){
                var operPosArr=operPosition.split(",");
                $("#OperPosition").combobox("setValues",operPosArr);
            }

            var operRequirement=app.opts.appData.OperRequirement;
            if(operRequirement){
                var reqArr=operRequirement.split(",");
                $("#OperRequirement").combobox("setValues",reqArr);
            }
			$("#AppCareProvID").combobox("setValue",app.opts.appData.AppCareProvID);
        }
        
        if(app.opts.operList && app.opts.operList.length>0){
            $("#operationBox").datagrid("loadData",app.opts.operList);
        }
        
        if(app.opts.diagList && app.opts.diagList.length>0){
            $("#preopDiagBox").datagrid("loadData",app.opts.diagList);
        }
    },

    /**
     * 加载公共数据(新增申请和修改申请都需要用到的基础数据和配置数据)
     */
    loadCommonDatas:function(){
        var _this=app;
        var queryPara = [{
            ListName: "appDepts",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindLocationOld",
            Arg1:"",
            Arg2:"INOPDEPT",
			Arg3:session.HospID,
            ArgCnt: 3
        },
        {
            ListName: "operDepts",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindLocationOld",
            Arg1:"",
            Arg2:"OP^EMOP^OUTOP",
            ArgCnt: 2
        },
        {
            ListName: "appCareProvs",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindCareProvByLoc",
            Arg1:"",
            Arg2:session.DeptID,
            ArgCnt: 2
        },
        {
            ListName: "patWards",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindWard",
            ArgCnt: 0
        },
        {
            ListName: "operClassList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperClass",
            ArgCnt: 0
        },
        {
            ListName: "bladeTypeList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindBladeType",
            ArgCnt: 0
        },
        {
            ListName: "bodySiteList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindBodySite",
            ArgCnt: 0
        },
        {
            ListName: "operPosList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperPosition",
            ArgCnt: 0
        },
        {
            ListName: "anaMethodList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindAnaestMethod",
            Arg1:"",
            ArgCnt: 1
        }];

        var queryData = dhccl.getDatas(ANCSP.DataQueries, {
            jsonData: dhccl.formatObjects(queryPara)
        }, "json");
        if (queryData) {
            for (var key in queryData) {
                _this.opts[key] = queryData[key];
            }
            _this.opts.surgeons=_this.opts.appCareProvs;
        }
    },

    /**
     * 加载手术医生
     */
    loadSurgeons:function(operId,deptId){
        var _this=app;
        _this.opts.surgeons = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindSurgeonByOper",
            Arg1:"",
            Arg2:deptId,
            Arg3:"Y",
            Arg4:session.HospID,
            Arg5:operId,
            ArgCnt: 4
        }, "json");
    },

     /**
     * 加载手术助手
     */
    loadAssistants:function(deptId){
        var _this=app;
        _this.opts.assistants = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindCareProvByLoc",
            Arg1:"",
            Arg2:deptId,
            ArgCnt: 2
        }, "json");
    },

    /**
     * 选择新的手术名称后，重新加载手术关联的部位选择项
     * @param {String} operId 手术名称ID
     */
    loadBodySites:function(operId){
        var _this=app;
        _this.opts.bodySiteList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindBodySiteByOper",
            Arg1:operId,
            ArgCnt: 1
        }, "json");
    },

    save:function(){
        var _this=app;
        _this.endEdit("#operationBox");
        _this.endEdit("#preopDiagBox");
        if (!$("#appForm").form("validate")) return;            // 手术申请表单必填项验证
        if(!_this.diagnosis.validateDiagnosis(true)) return;    // 术前诊断数据完整性验证
        if(!_this.operation.validateOperList(true)) return;     // 拟施手术数据完整性验证
        if(_this.opts.saveFlag==="N"){
            $.messager.alert("提示","所选手术受临床知识库管制不可申请！","warning");
            return;
        }

        var prevAnaMethodId=$("#PrevAnaMethod").combobox("getValue");
        var operClassDesc=_this.operation.getOperClassDesc();
        var sourceType=$("#SourceType").combobox("getValue");
        // 关联电子病历文书
        if(_this.opts.linkEMR==="Y"){
            var view=new EMRLinkView({
                title:"关联病历",
                prevAnaMethodId:prevAnaMethodId,
                OperClass:operClassDesc,
                EpisodeID:session.EpisodeID,
                OPSID:session.OPSID,
                OPAID:session.OPAID,
				SourceType:sourceType,
                app:true,
                closeCallBack:_this.saveApp
           });
		   if(needLinkEMR){
			   view.open();
		   }else{
			   _this.saveApp(null);
		   }
        }else{
            _this.saveApp(null);
        }
    },
    /**
     * 保存手术申请
     */
    saveApp:function(saveOpts){
        var _this=app;
		if(_this.opts.linkEMR==="Y"){
			var controlFillInFlag=false;
			var controlDatas=app.getEMRControl();
			var reg = /^[0-9]+.?[0-9]*$/;
			$(".EMRControl").each(function(index,item){
				var id=$(item).attr("id");
				var Desc=$(item).attr("Desc");
				if(controlFillIn[id]){
					var value=$(this).combogrid("getText");
					if(value===""){
						$.messager.alert("提示",Desc+"为必填项！","warning");
						controlFillInFlag=true;
					}
				}
			});
		}
		if (controlFillInFlag) return;                          // 关联病历完整性验证
        var appArr=[];
        var appData=$("#appForm").serializeJson();
        appData.ClassName="CIS.AN.OperCatalogue";
        appData.PrevDiagnosis=_this.diagnosis.formatDiagnosis();
        appData.StatusCode="Application";
        appData.RowId=session.OPSID?session.OPSID:"";
        appData.GroupID=session.GroupID?session.GroupID:"";
        var operPosValues=$("#OperPosition").combobox("getValues");
        appData.OperPosition=operPosValues.join(",");
        appData.OperRequirement=$("#OperRequirement").combobox("getText");
        if(saveOpts && saveOpts.linkRecords && saveOpts.linkRecords.length>0){
            appData.LinkEMRecords=saveOpts.linkRecords.join(",");
        }
        appArr.push(appData);
        var planOperList=$("#operationBox").datagrid("getRows");
        var operList=[];
        var operIdArr=[];
        for(var i=0;i<planOperList.length;i++){
            var planOperation=planOperList[i];
            operList.push(JSON.parse(JSON.stringify(planOperation)));
            planOperation.ClassName="CIS.AN.PlanOperationList";
            appArr.push(planOperation);
            operIdArr.push(planOperation.Operation);
        }

        for(var i=0;i<operList.length;i++){
            var operation=operList[i];
            operation.ClassName="CIS.AN.OperationList"
            appArr.push(operation);
        }
		
		//不允许同一个病人同一天内重复申请同一择期手术 YuanLin 2020-12-11
        var operIdStr=operIdArr.join(",");
        var sourceType=$("#SourceType").combobox("getValue");
        var VerifyRet=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"VerifyOperRepeated",appData.EpisodeID,appData.OperDate,operIdStr,session.OPSID);
        if((VerifyRet==="Y")&&(sourceType==="B")){
            $.messager.alert("提示","当天已有该手术申请记录，不可重复申请","info");
            return;
        }
        var arrPara=dhccl.formatObjects(appArr);
        var ret=dhccl.runServerMethodNormal("CIS.AN.BL.OperSubscription","SaveOperCatalogue",arrPara);
        if(ret.success){
            var showDialog=dhccl.getQueryString("showDialog");
            if(showDialog==="Y"){
                $.messager.alert("提示","保存手术申请成功。","info",function(){
                    window.parent.closeDialog();
					ShowIPCPW(appData.EpisodeID);//临床入径管理
                    //_this.setReturnValue();
                });
            }else{
                $.messager.alert("提示","保存手术申请成功。","info",function(){
                    _this.clearAppForm();
					ShowIPCPW(appData.EpisodeID);//临床入径管理
                    $("#patListDialog").dialog("open");
                });
            }            
        }else{
            $.messager.alert("提示","保存手术申请失败，原因："+ret.result,"error");
        }

    },

    setReturnValue:function(){
        var rlt = "我想返回的数值";
        window.returnValue = rlt;//ie之类浏览器
        if(opener != null && opener != 'undefined')
        {
            window.opener.returnValue = rlt; //chrome有些版本有问题, 所以在子窗口同时修改了父窗口的ReturnValue(能执行showModalDialog的chrome)
            if(window.opener.showModalDialogCallback)
                window.opener.showModalDialogCallback(rlt);
        }
        window.close();
    },

    /**
     * 暂存手术申请
     */
    tempSave:function(){
        var _this=app;
        _this.endEdit("#operationBox");
        _this.endEdit("#preopDiagBox");

        var appArr=[];
        var appData=$("#appForm").serializeJson();
        appData.ClassName=ANCLS.Model.OperSchedule;
        appData.PrevDiagnosis=_this.diagnosis.formatDiagnosis();
        appData.StatusCode="Application";
        appData.RowId=session.OPSID?session.OPSID:"";
        var operPosValues=$("#OperPosition").combobox("getValues");
        appData.OperPosition=operPosValues.join(",");
        appArr.push(appData);

        var planOperList=$("#operationBox").datagrid("getRows");
        var operList=[];
        for(var i=0;i<planOperList.length;i++){
            var planOperation=planOperList[i];
            operList.push(JSON.parse(JSON.stringify(planOperation)));
            planOperation.ClassName=ANCLS.Model.PlanOperList;
            appArr.push(planOperation);
        }

        for(var i=0;i<operList.length;i++){
            var operation=operList[i];
            operation.ClassName=ANCLS.Model.OperList
            appArr.push(operation);
        }

        var arrPara=dhccl.formatObjects(appArr);
        var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"SaveOperAppTemp",arrPara);
        if(ret.success){
            $.messager.alert("提示","手术申请暂存成功。","info",function(){
                _this.clearAppForm();
                $("#patListDialog").dialog("open");
            });          
        }else{
            $.messager.alert("提示","手术申请暂存失败，原因："+ret.result,"error");
        }
    },

    /**
     * 清空手术申请表单
     */
    clearAppForm:function(){
        $("#appForm").form("clear");
        $("#preopDiagBox").datagrid("loadData",[]);
        $("#operationBox").datagrid("loadData",[]);
    },


    /**
     * 诊断信息处理对象
     */
    diagnosis:{
        editIndex:-1,
        firstEdit:false,
        initDiagBox:function(){
            var _this=app.diagnosis;
            var diagOptions=_this.getDiagOptions();
            var columns=[[
                {field:"DiagID",title:"<span class='required-color'>*</span>诊断描述",width:480,editor:{type:"combogrid",options:diagOptions},formatter:function(value,row,index){
                    return row.DiagDesc;
                }},
                {field:"DiagNote",title:"备注",width:400,editor:{type:"validatebox"}}
            ]];
        
            $("#preopDiagBox").datagrid({
                width: 1010,
                height: 150,
                singleSelect: true,
                rownumbers: true,
                columns:columns,
                toolbar:"<div style='padding:3px 0'><a href='#' id='btnAddDiag'>新增</a><a href='#' id='btnDelDiag'>删除</a></div>",
                headerCls:"panel-header-gray",
                bodyCls:"panel-header-gray",
                onBeforeEdit:function(rowIndex,rowData){
                    _this.editIndex=rowIndex;
                    _this.firstEdit=true;
                },
                onAfterEdit:function(rowIndex,rowData,changes){
                    _this.firstEdit=false;
                },
                onClickRow:function(rowIndex,rowData){
                    // app.endEdit("#preopDiagBox");
                    // $(this).datagrid("beginEdit",rowIndex);
                    
                },
            });

            $("#preopDiagBox").datagrid("enableCellEditing");

            $("#btnAddDiag").linkbutton({
                iconCls:"icon-add",
                plain:true,
                onClick:function(){
                    app.endEdit("#preopDiagBox"); 
                    $("#preopDiagBox").datagrid("appendRow",{
                        DiagID:"",
                        DiagDesc:""
                    });
                    var rows=$("#preopDiagBox").datagrid("getRows");
                }
            });

            $("#btnDelDiag").linkbutton({
                iconCls:"icon-remove",
                plain:true,
                onClick:function(){
                    var selectedRow=$("#preopDiagBox").datagrid("getSelected");
                    if(!selectedRow){
                        $.messager.alert("提示","请先选择需要删除的诊断，再操作。","warning");
                    }else{
                        $.messager.confirm("提示","是否删除选择的诊断？",function(r){
                            if(r){
                                var rowIndex=$("#preopDiagBox").datagrid("getRowIndex",selectedRow);
                                $("#preopDiagBox").datagrid("deleteRow",rowIndex);
                            }
                        })
                        
                    }
                }
            });
        },

        /**
         * 获取诊断编辑控件的选项
         */
        getDiagOptions:function(){
            return {
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    param.Arg2="";
                    var rows=$("#preopDiagBox").datagrid("getRows");
                    var rowData=rows[app.diagnosis.editIndex];
                    if(app.diagnosis.firstEdit && rowData.DiagDesc){
                        param.q=rowData.DiagDesc;
                        param.Arg2=rowData.DiagID;
                        app.diagnosis.firstEdit=false;
                    }
                    if(!param.q) return false;
                    param.ClassName = CLCLS.BLL.Admission;
                    param.QueryName = "FindMRCDiagnosis";
                    param.Arg1 = param.q?param.q:"";
                    param.ArgCnt = 2;
                },
                pagination:true,
                pageSize:10,
                panelWidth:500,
                panelHeight:400,
                idField: "RowId",
                textField: "Description",
                columns:[[
                    {field:"Description",title:"名称",width:380},
                    {field:"ICDCode",title:"ICD",width:100}
                ]],
                mode: "remote",
                onSelect:function(rowIndex,rowData){
                    var checkFlag=true;
                    var rows=$("#preopDiagBox").datagrid("getRows");
                    var diagData=rows[app.diagnosis.editIndex];
                    if(diagData){
						for(var i=0;i<rows.length;i++){
							var diagrow=rows[i];
							if((diagrow.DiagDesc===rowData.Description)&&(i!==app.diagnosis.editIndex)){
								$.messager.alert("提示","诊断重复,请重新选择!","warning");
								checkFlag=false;
                                $("#preopDiagBox").datagrid("deleteRow",app.diagnosis.editIndex);
								break;
							}
						}
                        if(checkFlag) diagData.DiagDesc=rowData.Description;
                    }
                }
            }
        },

        /**
         * 验证术前诊断列表的完整性
         */
        validateDiagnosis:function (showMessage) {
            var diagRows=$("#preopDiagBox").datagrid("getRows");
            var alertMsgs=[];
            if(diagRows && diagRows.length>0){
                for(var i=0;i<diagRows.length;i++){
                    var diagRow=diagRows[i];
                    var operMsgs=[];
                    if(!diagRow.DiagID && !diagRow.DiagDesc){
                        operMsgs.push("诊断描述不能为空");
                    }
                    
                    if(operMsgs.length>0){
                        alertMsgs.push("第"+(i+1)+"条术前诊断不完整："+operMsgs.join(",")+"。");
                    }
                }
                if(alertMsgs.length>0){
                    var alertMsgStr="术前诊断列表数据不完整\n"+alertMsgs.join("\n");
                    if(showMessage) $.messager.alert("提示",alertMsgStr,"warning");
                    return false;
                }
            }else{
                $.messager.alert("提示","未添加术前诊断，请添加好术前诊断之后，再保存手术申请。","warning");
                return false;
            }

            return true;
        },

        /**
         * 将术前诊断数据格式化为字符串
         * @returns {String} 存储字符串
         */
        formatDiagnosis:function(){
            var ret="",propSplitChar="###",dataSplitChar="&&&";
            var diagRows=$("#preopDiagBox").datagrid("getRows");
            if(diagRows && diagRows.length>0){
                var formatArr=[];
                for(var i=0;i<diagRows.length;i++){
                    var diagRow=diagRows[i];
                    formatArr.push(diagRow.DiagID+propSplitChar+diagRow.DiagDesc+propSplitChar+(diagRow.DiagNote || ''));
                }
                ret=formatArr.join(dataSplitChar);
            }
            return ret;
        },

        /**
         * 将诊断字符串转化为诊断对象
         * @param {String} diagStr 诊断字符串
         * @returns {Array} 诊断对象数组
         */
        parseDiagnosis:function(diagStr){
            var retArr=[];
            if(diagStr){
                var diagStrArr=diagStr.split("&&&");
                for(var i=0;i<diagStrArr.length;i++){
                    var diagArr=diagStrArr[i].split("###");
                    retArr.push({
                        DiagID:diagArr[0],
                        DiagDesc:diagArr[1],
                        DiagNote:diagArr[2]
                    });
                }
            }
            return retArr;
        }
    },

    operation:{
        editIndex:-1,
        editData:null,
        firstEdit:false,
        initOperBox:function(){
            var _this=app.operation;
            var operationOptions=_this.getOperationOptions();
            var operClassOptions=_this.getOperClassOptions();
            var bladeTypeOptions=_this.getBladeTypeOptions();
            var bodySiteOptions=_this.getBodySiteOptions();
            var surgeonDeptOptions=_this.getSurgeonDeptOptions();
            var assistantOptions=_this.getAssistantOptions();
            var surgeonOptions=_this.getSurgeonOptions();
            var EmergencyOperationOptions=_this.getEmergencyOperationOptions();
            var columns=[[
                {field:"RowId",title:"ID",hidden:true},
                {field:"Operation",title:"<span class='required-color'>*</span>手术名称",width:260,editor:{type:"combogrid",options:operationOptions},formatter:function(value,row,index){
                    if(row.Operation===""){
						row.OperationDesc="";
					}
                    return row.OperationDesc;
                }},
                {field:"OperNote",title:"名称备注",width:110,editor:{type:"validatebox"}},
                {field:"OperClass",title:"<span class='required-color'>*</span>分级",width:66,editor:{type:"combobox",options:operClassOptions},formatter:function(value,row,index){
                    return row.OperClassDesc;
                }},
                {field:"BodySite",title:"<span class='required-color'>*</span>部位",width:76,editor:{type:"combobox",options:bodySiteOptions},formatter:function(value,row,index){
                    return row.BodySiteDesc;
                }},
                {field:"BladeType",title:"<span class='required-color'>*</span>切口类型",width:76,editor:{type:"combobox",options:bladeTypeOptions},formatter:function(value,row,index){
                    return row.BladeTypeDesc;
                }},
                {field:"SurgeonDeptID",title:"<span class='required-color'>*</span>术者科室",width:80,editor:{type:"combobox",options:surgeonDeptOptions},formatter:function(value,row,index){
                    return row.SurgeonDeptDesc;
                }},
                {field:"Surgeon",title:"<span class='required-color'>*</span>主刀",width:76,editor:{type:"combobox",options:surgeonOptions},formatter:function(value,row,index){
                    return row.SurgeonDesc;
                }},
                {field:"Assistant",title:"助手",width:150,editor:{type:"combobox",options:assistantOptions},formatter:function(value,row,index){
                    return row.AssistantDesc;
                }},
                {field:"SurgeonExpert",title:"外院专家",width:76,editor:{type:"validatebox"}},
                {field:"EmergencyOperation",title:"紧急手术",width:76,editor:{type:"combobox",options:EmergencyOperationOptions},formatter:function(value,row,index){
                    return row.EmergencyOperationDesc;
                }},
				{field:"SKDOperID",title:"SKDOperID",hidden:true}
            ]];

            $("#operationBox").datagrid({
                width: 1010,
                height: 200,
                headerCls:"panel-header-gray",
                bodyCls:"panel-header-gray",
                sytle:{"border-radius":"2px"},
                method:"local",
                singleSelect: true,
                rownumbers: true,
                toolbar: "<div style='padding:3px 0'><a href='#' id='btnAddOperation'>新增</a><a href='#' id='btnDelOperation'>删除</a></div>",
                columns:columns,
                onClickRow:function(rowIndex,rowData){
                    // app.endEdit("#operationBox");
                    // $(this).datagrid("beginEdit",rowIndex);
                },
                onBeforeEdit:function(rowIndex,rowData){
                    _this.editIndex=rowIndex;
                    _this.editData=rowData;
                    _this.firstEdit=true;
                },
                onAfterEdit:function(rowIndex,rowData,changes){
                    _this.firstEdit=false;
                }
            });

            $("#operationBox").datagrid("enableCellEditing");

            $("#btnAddOperation").linkbutton({
                iconCls:"icon-add",
                plain:true,
                onClick:function(){
                    app.endEdit("#operationBox");
                    $("#operationBox").datagrid("appendRow",{
                        RowId:"",
                        Operation:"",
                        OperationDesc:"",
                        OperNote:"",
                        OperClass:"",
                        OperClassDesc:"",
                        BladeType:"",
                        BladeTypeDesc:"",
                        BodySite:"",
                        BodySiteDesc:"",
                        SurgeonDeptID:session.DeptID,
                        SurgeonDeptDesc:session.DeptDesc,
                        Surgeon:"",
                        SurgeonDesc:"",
                        Assistant:"",
                        AssistantDesc:"",
                        SurgeonExpert:"",
						EmergencyOperation:"",
						EmergencyOperationDesc:"",
                        SKDOperID:""
                    });
                    var rows=$("#operationBox").datagrid("getRows");
                    //$("#operationBox").datagrid("beginEdit",rows.length-1);
                }
            });

            $("#btnDelOperation").linkbutton({
                iconCls:"icon-remove",
                plain:true,
                onClick:function(){
                    var selectedRow=$("#operationBox").datagrid("getSelected");
                    if(!selectedRow){
                        $.messager.alert("提示","请先选择需要删除的手术，再操作。","warning");
                    }else{
                        $.messager.confirm("提示","是否删除选择的手术？",function(r){
                            if(r){
                                var rowIndex=$("#operationBox").datagrid("getRowIndex",selectedRow);
                                $("#operationBox").datagrid("deleteRow",rowIndex);
                            }
                        })
                        
                    }
                }
            });
        },

        /**
         * 下拉框选择后，对表格的相应描述字段进行赋值。
         * 这样表格相应行结束编辑状态后，相应字段就不会显示成ID。
         * 相应字段显示方式参考列选项的formatter函数。
         * @param {object} record 下拉框选择项
         * @param {String} descField 表格描述字段
         * @param {String} textField 下拉框文本字段
         */
        setComboboxFieldDesc:function(record,descField,textField){
            var rows=$("#operationBox").datagrid("getRows");
            var rowData=rows[app.operation.editIndex];
            if(rowData){
                rowData[descField]=record[textField];
            }
        },

        /**
         * 获取术者科室编辑控件的选项
         */
        getSurgeonDeptOptions:function(){
            return {
                valueField: "RowId",
                textField: "Description",
                data:app.opts.appDepts,
                panelWidth:120,
                filter:function(q,row){
                    var filterDesc=q.toUpperCase();
                    var desc=row.Description.toUpperCase();
                    var alias=row.Alias.toUpperCase();
                    return (desc.indexOf(filterDesc)>=0 || alias.indexOf(filterDesc)>=0)
                },
                onSelect:function(record){
                    app.operation.setComboboxFieldDesc(record,"SurgeonDeptDesc","Description");
                    //app.loadAssistants(record.RowId);
                    //var surgeonID=app.operation.getComboboxEditorValue("Surgeon",false);
                    var operId=app.operation.editData.Operation;
                    app.loadSurgeons(operId,record.RowId);
                    app.loadAssistants(record.RowId);
                    app.operation.reloadSurgeonAssistant();
                }
            }
        },

        /**
         * 获取术者科室编辑控件的选项
         */
        getOperDeptOptions:function(){
            return {
                valueField: "RowId",
                textField: "Description",
                data:app.opts.operDepts,
                editable:false,
                filter:function(q,row){
                    var filterDesc=q.toUpperCase();
                    var desc=row.Description.toUpperCase();
                    var alias=row.Alias.toUpperCase();
                    return (desc.indexOf(filterDesc)>=0 || alias.indexOf(filterDesc)>=0)
                }
            }
        },

        /**
         * 获取术者科室编辑控件的选项
         */
        getAnaDeptOptions:function(){
            return {
                valueField: "RowId",
                textField: "Description",
                data:app.opts.anaDepts,
                editable:false,
                filter:function(q,row){
                    var filterDesc=q.toUpperCase();
                    var desc=row.Description.toUpperCase();
                    var alias=row.Alias.toUpperCase();
                    return (desc.indexOf(filterDesc)>=0 || alias.indexOf(filterDesc)>=0)
                }
            }
        },

        /**
         * 获取手术医生编辑控件的选项
         */
        getSurgeonOptions:function(){
            return {
                //data:app.opts.appCareProvs,
                valueField: "Code",
                textField: "CareProvDesc",
                panelWidth:120,
                // filter:function(q,row){
                //     var filterDesc=q.toUpperCase();
                //     var desc=row.Description.toUpperCase();
                //     var alias=row.Alias.toUpperCase();
                //     return (desc.indexOf(filterDesc)>=0 || alias.indexOf(filterDesc)>=0)
                // },
                url:ANCSP.DataQuery,
                onBeforeLoad:function(param){
                    var operId=app.operation.editData.Operation;
                    var deptId=app.operation.editData.SurgeonDeptID;
                    param.ClassName=ANCLS.BLL.ConfigQueries;
                    param.QueryName="FindSurgeonByOper";
                    param.Arg1=param.q?param.q:"";
                    param.Arg2=deptId;
                    param.Arg3="Y";
                    param.Arg4=session.HospID;
                    param.Arg5=operId;
                    param.ArgCnt=5;
                },
                onSelect:function(record){
                    app.operation.setComboboxFieldDesc(record,"SurgeonDesc","Description");
                    app.operation.setComboboxFieldDesc(record,"Surgeon","Code");
					var SurgeoGroupList=dhccl.getDatas(ANCSP.DataQuery,{
						ClassName:ANCLS.BLL.ConfigQueries,
						QueryName:"FindSurgeonGroup",
						Arg1:session.DeptID,
						Arg2:record.Code,
						Arg3:"Y",
						ArgCnt:3
					},"json");
					if(SurgeoGroupList && SurgeoGroupList.length>0){
						var Assistant=SurgeoGroupList[0].Assist1Desc+","+SurgeoGroupList[0].Assist2Desc+","+SurgeoGroupList[0].Assist3Desc
						var AssistantId=SurgeoGroupList[0].Assist1+","+SurgeoGroupList[0].Assist2+","+SurgeoGroupList[0].Assist3
						var rows=$("#operationBox").datagrid("getRows");
						var rowData=rows[app.operation.editIndex];
						if(rowData){
							rowData["Assistant"]=AssistantId;
							rowData["AssistantDesc"]=Assistant;
						}
						app.endEdit("#operationBox");
					}
					else{
						var rows=$("#operationBox").datagrid("getRows");
						var rowData=rows[app.operation.editIndex];
						if(rowData){
							rowData["Assistant"]="";
							rowData["AssistantDesc"]="";
						}
						app.endEdit("#operationBox");
					}
                },
                mode:"remote"
            }
        },


        /**
         * 获取手术助手编辑控件的选项
         */
        getAssistantOptions:function(){
            return {
                // data:app.opts.appCareProvs,
                valueField: "RowId",
                textField: "Description",
                multiple:true,
                rowStyle:"checkbox",
                url:ANCSP.DataQuery,
                onBeforeLoad:function(param){
                    var deptId=app.operation.editData.SurgeonDeptID;
                    param.ClassName=CLCLS.BLL.Admission;
                    param.QueryName="FindCareProvByLoc";
                    param.Arg1="";
                    param.Arg2=deptId;
                    param.ArgCnt=2;
                },
                onSelect:function(record){
                    var text=$(this).combobox("getText");
                    app.operation.setComboboxFieldDesc({Description:text},"AssistantDesc","Description");
                }
            }
        },

        getAppCareProvOptions:function(){
            return {
                // data:app.opts.appCareProvs,
                valueField: "RowId",
                textField: "Description",
                multiple:true,
                rowStyle:"checkbox",
                url:ANCSP.DataQuery,
                onBeforeLoad:function(param){
                    var deptId=session.DeptID;
                    param.ClassName=CLCLS.BLL.Admission;
                    param.QueryName="FindCareProvByLoc";
                    param.Arg1="";
                    param.Arg2=deptId;
                    param.ArgCnt=2;
                },
                onSelect:function(record){
                    var text=$(this).combobox("getText");
                    app.operation.setComboboxFieldDesc({Description:text},"AssistantDesc","Description");
                }
            }
        },

        /**
         * 获取手术分级编辑控件的选项
         */
        getOperClassOptions:function(){
            return {
                valueField: "RowId",
                textField: "Description",
                data:app.opts.operClassList,
                editable:false,
                onSelect:function(record){
                    app.operation.setComboboxFieldDesc(record,"OperClassDesc","Description");
                }
            }
        },

        /**
         * 获取切口类型编辑控件的选项
         */
        getBladeTypeOptions:function(){
            return {
                valueField: "RowId",
                textField: "Description",
                data:app.opts.bladeTypeList,
                editable:false,
                onSelect:function(record){
                    app.operation.setComboboxFieldDesc(record,"BladeTypeDesc","Description");
                }
            }
        },

        /**
         * 获取手术部位编辑控件的选项
         */
        getBodySiteOptions:function(){
            return {
                valueField: "RowId",
                textField: "Description",
                // data:app.opts.bodySiteList,
                panelWidth:120,
                // filter:function(q,row){
                //     var filterDesc=q.toUpperCase();
                //     var desc=row.Description.toUpperCase();
                //     return (desc.indexOf(filterDesc)>=0)
                // },
                url:ANCSP.DataQuery,
                onBeforeLoad:function(param){
                    var operId=app.operation.editData.Operation;
                    param.ClassName=ANCLS.BLL.CodeQueries;
                    param.QueryName="FindBodySiteByOper";
                    param.Arg1=operId;
                    param.Arg2=param.q?param.q:"";
                    param.ArgCnt=2;
                },
                onSelect:function(record){
                    app.operation.setComboboxFieldDesc(record,"BodySiteDesc","Description");
                }
            }
        },

        /**
         * 获取手术体位编辑控件的选项
         */
        getOperPosOptions:function(){
            return {
                valueField: "RowId",
                textField: "Description",
                data:app.opts.operPosList,
                editable:false,
                multiple:true,
                rowStyle:"checkbox",
                onSelect:function(record){
                    var text=$(this).combobox("getText");
                    app.operation.setComboboxFieldDesc({Description:text},"OperPosDesc","Description");
                }
            }
        },

        /**
         * 获取紧急手术编辑控件的选项
         */
        getEmergencyOperationOptions:function(){
            return {
                valueField:"value",
				textField:"text",
				data:CommonArray.WhetherOrNot,
				editable:false,
                onSelect:function(record){
                    app.operation.setComboboxFieldDesc(record,"EmergencyOperationDesc","text");
                }
            }
        },
        /**
         * 获取手术名称编辑控件的选项
         */
        getOperationOptions:function(){
            return {
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    param.Arg4="";
                    var rows=$("#operationBox").datagrid("getRows");
                    var rowData=rows[app.operation.editIndex];
                    if(rows && rows.length>0 && app.operation.firstEdit && rowData.OperationDesc){
                        param.q=rowData.OperationDesc;
                        param.Arg4=rowData.Operation;
                        app.operation.firstEdit=false;
                    }
                    param.ClassName = ANCLS.BLL.Operation;
                    param.QueryName = "FindOperation";
                    param.Arg1 = param.q?param.q:"";
                    param.Arg2 = rowData.Surgeon;
                    param.Arg3 = rowData.SurgeonDeptID;
                    param.ArgCnt = 4;
                },
                panelWidth:600,
                panelHeight:400,
                idField: "RowId",
                textField: "Description",
                columns:[[
                    {field:"RowId",title:"ID",hidden:true},
                    {field:"Description",title:"名称",width:390},
                    {field:"OperClassDesc",title:"分级",width:60},
                    {field:"ICDCode",title:"ICD码",width:130},
                    {field:"ExternalID",title:"ExternalID",hidden:true}
                ]],
                pagination:true,
                pageSize:10,
                mode: "remote",
                onSelect:function(rowIndex,rowData){
					var checkFlag=true;
                    var rows=$("#operationBox").datagrid("getRows");
					for(var i=0;i<rows.length;i++){
						var operrow=rows[i];
						if((operrow.OperationDesc===rowData.Description)&&(i!==app.operation.editIndex)){
							$.messager.alert("提示","手术重复,请重新选择!","warning");
							checkFlag=false;
							$("#operationBox").datagrid("deleteRow",app.operation.editIndex);
							break;
						}
                    }
					if(checkFlag){
						app.operation.setComboboxFieldDesc(rowData,"OperationDesc","Description");
					    app.operation.setComboboxFieldDesc(rowData,"Operation","RowId");
						app.operation.setComboboxFieldDesc(rowData,"OperClass","OperClass");
						app.operation.setComboboxFieldDesc(rowData,"OperClassDesc","OperClassDesc");
						app.operation.setComboboxFieldDesc(rowData,"BladeType","BladeType");
						app.operation.setComboboxFieldDesc(rowData,"BladeTypeDesc","BladeTypeDesc");
						app.operation.setComboboxFieldDesc(rowData,"BodySite","BodySite");
						app.operation.setComboboxFieldDesc(rowData,"BodySiteDesc","BodySiteDesc");
						$("#OperPosition").combobox("setValues",rowData.OperPos);
						app.endEdit("#operationBox");
					}
                    // 判断临床知识库
                    if (app.opts.validOperation==="Y"){
                        var validResult=app.operation.getOperValidData(rowData.RowId);
                        if (validResult.validData && validResult.validData.passFlag!=="1"){
                            $.messager.alert(validResult.alertLevel.desc,validResult.alertLevel.msg,validResult.alertLevel.code);
                            if (validResult.validData.manLevel==="C"){
                                app.opts.saveFlag="N";
                                $(this).combogrid("clear");
                                return;
                            }
                        }
                    }
                }
            }
        },

        /**
         * 重新加载手术医生和手术助手下拉框选择项
         */
        reloadSurgeonAssistant:function(){
            // var editor=$("#operationBox").datagrid("getEditor",{index:app.operation.editIndex,field:"Surgeon"});
            // if(editor && editor.target){
            //     $(editor.target).combobox("loadData",app.opts.surgeons);
            // }
            // editor=$("#operationBox").datagrid("getEditor",{index:app.operation.editIndex,field:"Assistant"});
            // if(editor && editor.target){
            //     $(editor.target).combobox("loadData",app.opts.assistants);
            // }
        },

        /**
         * 重新加载手术部位下拉框选择项
         */
        reloadBodySite:function(){
            var editor=$("#operationBox").datagrid("getEditor",{index:app.operation.editIndex,field:"BodySite"});
            if(editor && editor.target){
                $(editor.target).combobox("loadData",app.opts.bodySiteList);
            }
        },

        /**
         * 获取表格Combobox编辑控件的值
         * @param {String} field 字段
         * @param {String} values 是否多选值
         * @returns {String} 控件值
         */
        getComboboxEditorValue:function(field,values){
            var ret="";
            try {
                var editor=$("#operationBox").datagrid("getEditor",{index:app.operation.editIndex,field:field});
                if(editor && editor.target){
                    if(values){
                        ret=$(editor.target).combobox("getValues");
                    }else{
                        ret=$(editor.target).combobox("getValue");
                    }
                }
            } catch (error) {
                
            }
            
            return ret;
        },

        /**
         * 获取手术名称验证结果数据
         * @param {String} operId 手术名称ID
         * @returns {object} 手术名称验证结果对象，其格式为
         * @example
         * [{
         *      "manLevel": "W",
         *      "passFlag": 0,
         *      "retMsg": [{
         *          "PhMRId": 393,
         *          "arci": "76",
         *          "chlidren": [{
         *              "alertMsg": "1、血压偏高不能做该手术",
         *              "labelDesc": "高危提醒",
         *              "labelLevel": "W",
         *              "linkArci": "",
         *              "linkOeSeqNo": "",
         *              "linkOeori": ""
         *          }, {
         *              "alertMsg": "1、术前没有做胸部增强CT ",
         *              "labelDesc": "术前检查",
         *              "labelLevel": "W",
         *              "linkArci": "",
         *              "linkOeSeqNo": "",
         *              "linkOeori": ""
         *          }],
         *          "geneDesc": "双心室起搏器置入术",
         *          "level": "W",
         *          "oeori": "",
         *          "passFlag": 0,
         *          "pointer": "",
         *          "seqNo": ""
         *      }]
         *  }]
         */
        getOperValidData:function(operId){
            var EpisodeID=session.EpisodeID;
            var userInfo=session.UserID+"^"+session.DeptID+"^"+session.GroupID;
            var validDatas=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"CheckOperValid",EpisodeID,operId,userInfo);
            var ret={validData:null,alertMsg:"",alertLevel:null}
            if(validDatas && validDatas.length>0){
                ret.validData=validDatas[0];
                if(ret.validData.passFlag!==1){
                    var alertMsgs=[];
                    for (var i = 0; i < ret.validData.retMsg.length; i++) {
                        var msg = ret.validData.retMsg[i];
                        if(!msg.chlidren || msg.chlidren.length===0) continue;
                        for (var j = 0; j < msg.chlidren.length; j++) {
                            var msgChild = msg.chlidren[j];
                            if(msgChild.alertMsg) alertMsgs.push(msgChild.labelDesc+":"+msgChild.alertMsg);
                        }
                    }
                    if(alertMsgs.length>0) ret.alertMsg=alertMsgs.join("<br>");
                    var levelCode="",levelDesc="";
                    switch(ret.validData.manLevel){
                        case "C":
                            levelCode="error";
                            levelDesc="管制";
                            break;
                        case "W":
                            levelCode="warning";
                            levelDesc="警示";
                            break;
                        case "S":
                            levelCode="info";
                            levelDesc="提示";
                            break;
                    }
                    ret.alertLevel={
                        code:levelCode,
                        desc:levelDesc,
                        msg:ret.alertMsg
                    };
                }
            }
            return ret;
        },

        /**
         * 获取手术分级名称
         */
        getOperClassDesc:function(){
            var operClassDesc="",operClassArr=[],OperClassDescStr=[];
            var operRows=$("#operationBox").datagrid("getRows");
            if(operRows && operRows.length>0){
                for(var i=0;i<operRows.length;i++){
                    var operRow=operRows[i];
                    operClassArr.push(operRow);
                    OperClassDescStr.push(operRow.OperClassDesc)
                }
                operClassDesc=OperClassDescStr.join(",");
            }

            return operClassDesc;
        },

        /**
         * 验证手术列表数据完整性
         * @param {Boolean} showMessage 是否提示验证失败消息
         * @returns {Boolean} 验证成功返回true，验证失败返回false。
         */
        validateOperList:function(showMessage){
            var operRows=$("#operationBox").datagrid("getRows");
            var alertMsgs=[];
            if(operRows && operRows.length>0){
                for(var i=0;i<operRows.length;i++){
                    var operRow=operRows[i];
                    var operMsgs=[];
                    if(!operRow.Operation || !operRow.OperationDesc){
                        operMsgs.push("手术名称不能为空");
                    }
                    if(!operRow.OperClass || !operRow.OperClassDesc){
                        operMsgs.push("手术分级不能为空");
                    }
                    if(!operRow.BodySite || !operRow.BodySiteDesc){
                        operMsgs.push("手术部位不能为空");
                    }
                    if(!operRow.BladeType || !operRow.BladeTypeDesc){
                        operMsgs.push("切口类型不能为空");
                    }
                    if(!operRow.SurgeonDeptID || !operRow.SurgeonDeptDesc){
                        operMsgs.push("术者科室不能为空");
                    }
                    if(!operRow.Surgeon || !operRow.SurgeonDesc){
                        operMsgs.push("手术医生不能为空");
                    }
                    if(operMsgs.length>0){
                        alertMsgs.push("第"+(i+1)+"条手术不完整："+operMsgs.join(",")+"。");
                    }
                }
                if(alertMsgs.length>0){
                    var alertMsgStr="手术列表数据不完整\n"+alertMsgs.join("\n");
                    if(showMessage) $.messager.alert("提示",alertMsgStr,"warning");
                    return false;
                }
            }else{
                $.messager.alert("提示","未添加拟施手术，请添加好拟施手术之后，再保存手术申请。","warning");
                return false;
            }

            return true;
        }
    },

    /**
     * 结束编辑状态
     * @param {String} selector Datagrid选择器
     */
    endEdit:function(selector){
        var rows=$(selector).datagrid("getRows");
        for(var i=0;i<rows.length;i++){
            $(selector).datagrid("endEdit",i);
        }
    },

    linkEMRecord:function(linked,linkDatas){
        var _this=app;
        _this.EMRecord={linked:linked,linkDatas:linkDatas};
    },
	
	getEMRControl:function(){
		var controlDatas=dhccl.getDatas(ANCSP.DataQuery,{
			ClassName:ANCLS.BLL.CodeQueries,
			QueryName:"FindOperRiskControl",
			Arg1:"",
			Arg2:"5",
			ArgCnt:2
		},"json");
		return controlDatas;
	}
}

$(document).ready(app.initPage);