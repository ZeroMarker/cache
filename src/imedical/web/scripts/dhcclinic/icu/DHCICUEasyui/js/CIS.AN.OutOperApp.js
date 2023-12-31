var operApplication = {
    newApp: true,
    editableStatus: "Application",
    yesNoOptions: [{
        value: "Y",
        text: "是"
    }, {
        value: "N",
        text: "否"
    }],
    testOptions: [{
        value: "N",
        text: "未知",
    }, {
        value: "-",
        text: "阴性"
    }, {
        value: "+",
        text: "阳性"
    }],
    relatedEMRecords: null,
    controlDatas: null
};

var outOper = {
    schedule: null,
    contextMenu: null,
    contextMenuD: null,
    clickColumn: null
};

var outApp = {
    editIndex:-1,
	editData:null,
	firstEdit:false,
};

function initPage() {
    $(".spinner-text").each(function(index, item) {
        var spinnerWidth = $(item).width();
        $(item).css("width", (spinnerWidth - 5) + "px");
    });
    //设置默认值
    dhccl.parseDateFormat();
    loadCommonDatas();
    loadAppConfig();
    initAppForm();
    setDefaultValue();
}
/**
 * 加载公共数据(新增申请和修改申请都需要用到的基础数据和配置数据)
 */
var app = {
    opts: {}
}

function loadCommonDatas() {
    var _this = app;
    var queryPara = [{
            ListName: "appDepts",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindLocationOld",
            Arg1: "",
            Arg2: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
            Arg3: session.HospID,
            ArgCnt: 3
        },
        {
            ListName: "operDepts",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindLocationOld",
            Arg1: "",
            Arg2: "OP^EMOP^OUTOP",
            ArgCnt: 2
        },
        {
            ListName: "appCareProvs",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindCareProvByLoc",
            Arg1: "",
            Arg2: session.DeptID,
            Arg3: "",
            ArgCnt: 3
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
            Arg1: "",
            ArgCnt: 1
        }
    ];
    var queryData = dhccl.getDatas(ANCSP.DataQueries, {
        jsonData: dhccl.formatObjects(queryPara)
    }, "json");
    if (queryData) {
        for (var key in queryData) {
            _this.opts[key] = queryData[key];
        }
        _this.opts.surgeons = _this.opts.appCareProvs;
    }
}
/**
 * 加载手术申请配置
 */
function loadAppConfig() {
    var _this = app;
    var appOptsDatas = dhccl.runServerMethod(ANCLS.BLL.OperApplication, "GetAppConfig", session.DeptID, session.EpisodeID, session.OPSID, session.HospID);
    if (appOptsDatas && appOptsDatas.length > 0) {
        _this.opts = $.extend(appOptsDatas[0], app.opts);
    }
}
/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    outOper.schedule = operApplication;
}
/**
 * 初始化手术申请表单
 */
function initAppForm() {
    initOperBox();
    initAppFormOptions();
    loadAppFormData();
}


function initOperBox() {
    var Columns = [
		[
			{ field: "RowId", title: "ID", hidden: true },
			{ field: "Description", title: "名称", width: 240 },
			{ field: "OperClassDesc", title: "分级", width: 60 },
			{ field: "ICDCode", title: "ICD", width: 120 }
		]
	];
	
    $("#Operation").combogrid({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.Operation;
            param.QueryName = "FindOperation";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = $("#Surgeon").combobox("getValue");
            param.Arg3 = $("#SurgeonDeptID").combobox("getValue");
            param.Arg4 = "";
			param.Arg5 = session.EpisodeID;
            param.ArgCnt = 5;
        },
        panelWidth: 450,
        idField: "RowId",
        textField: "Description",
        columns: Columns,
        pagination: true,
        pageSize: 10,
        mode: "remote",
        onSelect: function(rowIndex, record) {

            try {

                var judgeClinicKnowledge = dhccl.runServerMethodNormal(ANCLS.BLL.DataConfiguration, "GetValueByKey", "JudgeClinicKnowledge");
                if (judgeClinicKnowledge === "Y") {

                    var operId = record.ExternalID ? record.ExternalID : "";
                    var userInfo = session.UserID + "^" + session.DeptID + "^" + session.GroupID;

                    var checkValidStr = dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication, "CheckOperValid", session.EpisodeID, operId, userInfo);
                    var checkValidDatas = JSON.parse(checkValidStr);
                    var checkValidData = checkValidDatas[0];
                    if (checkValidData.passFlag !== "1") {
                        var alertMsgs = [];
                        for (var i = 0; i < checkValidData.retMsg.length; i++) {
                            const msg = checkValidData.retMsg[i];
                            if (!msg.chlidren || msg.chlidren.length === 0) continue;
                            for (var j = 0; j < msg.chlidren.length; j++) {
                                const msgChild = msg.chlidren[j];
                                if (msgChild.alertMsg) alertMsgs.push(msgChild.alertMsg);
                            }
                        }
                        var alertMsgStr = "";
                        if (alertMsgs.length > 0) alertMsgStr = alertMsgs.join("\n");
                        if (checkValidData.manLevel === "C") {
                            $.messager.alert("管制提示", alertMsgStr, "error");
                            var grid = $(this).combogrid("grid");
                            grid.datagrid("unselectRow", rowIndex);
                            $(this).combogrid("setValue", "");
                            $(this).combogrid("setText", "");
                            $(this).combogrid("clear");
                        } else if (checkValidData.manLevel === "W") {
                            $.messager.alert("警示", alertMsgStr, "warning");
                        } else if (checkValidData.manLevel === "S") {
                            $.messager.alert("提示", alertMsgStr, "info");
                        }
                    }
                }
                $("#OperClass").combobox("setValue", record.OperClass);
                $("#BladeType").combobox("setValue", record.BladeType);
                $("#BodySite").combobox("setValue", record.BodySite);
                $("#BodySite").combobox("reload");
            } catch (ex) {

            }
        },
        onChange: function(newValue, oldValue) {
            $("#Surgeon").combobox("reload");
        }
    });

    $("#OperClass").combobox({
        valueField: "RowId",
        textField: "Description",
        editable: false,
        data: app.opts.operClassList
    });
    $("#BodySite").combobox({
        valueField: "RowId",
        textField: "Description",
        data: app.opts.bodySiteList
    });
    $("#BladeType").combobox({
        valueField: "RowId",
        textField: "Description",
        editable: false,
        data: app.opts.bladeTypeList
    });
    $("#Surgeon").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindSurgeonByOper";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = $("#SurgeonDeptID").combobox("getValue");
            if (!param.Arg2) {
                param.Arg2 = session.DeptID;
            }
            param.Arg3 = "Y";
            param.Arg4 = session.HospID;
            param.Arg5 = $("#Operation").combobox("getValue");
            param.ArgCnt = 5;
        },
        valueField: "Code",
        textField: "Description",
        mode: "remote",
        onChange: function(newValue, oldValue) {
            var grid = $("#Operation").combogrid("grid");
            grid.datagrid("reload");
        }
    })
    $(".sur-careprov").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = $("#SurgeonDeptID").combobox("getValue");
            if (!param.Arg2) {
                param.Arg2 = session.DeptID;
            }
            param.ArgCnt = 2;
        },
        // panelWidth:450,
        valueField: "RowId",
        textField: "Description",

        mode: "remote"
    });
	var operationOptions=getOperationOptions();
	var operClassOptions=getOperClassOptions();
	var bladeTypeOptions=getBladeTypeOptions();
	var bodySiteOptions=getBodySiteOptions();
	var surgeonDeptOptions=getSurgeonDeptOptions();
	var assistantOptions=getAssistantOptions();
	var surgeonOptions=getSurgeonOptions();
	var columns=[[
		{field:"RowId",title:"ID",hidden:true},
		{field:"Operation",title:"<span class='required-color'>*</span>"+$g('手术名称'),width:260,editor:{type:"combogrid",options:operationOptions},formatter:function(value,row,index){
			if(row.Operation===""){
				row.OperationDesc="";
			}
			return row.OperationDesc;
		}},
		{field:"OperNote",title:$g("名称备注"),width:100,editor:{type:"validatebox"}},
		{field:"OperClass",title:"<span class='required-color'>*</span>"+$g('分级'),width:65,editor:{type:"combobox",options:operClassOptions},formatter:function(value,row,index){
			return row.OperClassDesc;
		}},
		{field:"BodySite",title:"<span class='required-color'>*</span>"+$g('部位'),width:75,editor:{type:"combobox",options:bodySiteOptions},formatter:function(value,row,index){
			return row.BodySiteDesc;
		}},
		{field:"BladeType",title:"<span class='required-color'>*</span>"+$g('切口类型'),width:75,editor:{type:"combobox",options:bladeTypeOptions},formatter:function(value,row,index){
			return row.BladeTypeDesc;
		}},
		{field:"SurgeonDeptID",title:"<span class='required-color'>*</span>"+$g('术者科室'),width:80,editor:{type:"combobox",options:surgeonDeptOptions},formatter:function(value,row,index){
			return row.SurgeonDeptDesc;
		}},
		{field:"Surgeon",title:"<span class='required-color'>*</span>"+$g('主刀'),width:75,editor:{type:"combobox",options:surgeonOptions},formatter:function(value,row,index){
			if(value==="") return "";
			else return row.SurgeonDesc;
		}},
		{field:"Assistant",title:$g("助手"),width:150,editor:{type:"combobox",options:assistantOptions},formatter:function(value,row,index){
			if(value==="") return "";
			else return row.AssistantDesc;
		}},
		{field:"SKDOperID",title:"SKDOperID",hidden:true}
	]];

    $("#operationBox").datagrid({
        width: 1020,
        height: 220,
        headerCls: "panel-header-gray",
        bodyCls: "panel-header-gray",
        sytle: { "border-radius": "2px" },
        singleSelect: true,
        rownumbers: true,
        toolbar: "<div style='padding:0px'><a href='#' id='btnAddOperation'>新增</a><a href='#' id='btnDelOperation'>删除</a></div>",
        url: ANCSP.DataQuery,
        columns: columns,
		onBeforeEdit:function(rowIndex,rowData){
			outApp.editIndex=rowIndex;
			outApp.editData=rowData;
			outApp.firstEdit=true;
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			outApp.firstEdit=false;
		}
    });

	$("#operationBox").datagrid("enableCellEditing");

	$("#btnAddOperation").linkbutton({
		iconCls:"icon-add",
		plain:true,
		onClick:function(){
			endEdit("#operationBox");
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
				SKDOperID:""
			});
			var rows=$("#operationBox").datagrid("getRows");
		}
	});

	$("#btnDelOperation").linkbutton({
		iconCls:"icon-cancel",
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
}

function initAppFormOptions() {

    $("#AppDeptID").combobox({
        valueField: "RowId",
        textField: "Description",
        readonly: true,
        hasDownArrow: false,
        data: app.opts.appDepts
    });

    $("#AppCareProvID").combobox({
        valueField: "RowId",
        textField: "Description",
        readonly: true,
        hasDownArrow: false,
        data: app.opts.appCareProvs
    });

    $("#OperDeptID").combobox({
        valueField: "RowId",
        textField: "Description",
        data: app.opts.operDepts
    });

    $("#SurgeonDeptID").combobox({
        valueField: "RowId",
        textField: "Description",
        data: app.opts.appDepts,
        onChange: function(newValue, oldValue) {
            var grid = $("#Operation").combogrid("grid");
            grid.datagrid("reload");
            $("#Surgeon").combobox("clear");
            $("#Surgeon").combobox("reload");
            $(".sur-careprov").combobox("clear");
            $(".sur-careprov").combobox("reload");
			$("#Operation").combogrid("setValue","");
        }
    });

    $("#PrevAnaMethod").combobox({
        valueField: "RowId",
        textField: "Description",
        data: app.opts.anaMethodList,
        filter: function(q, row) {
            return row.Description.indexOf(q) >= 0
        }
    });

    $("#SourceType").combobox({
        valueField: "code",
        textField: "desc",
        //disabled:true,
        // editable:false,
        data: [{
            code: "B",
            desc: "择期"
        }, {
            code: "E",
            desc: "急诊"
        }],
        onSelect: function(record) {
            var ret = dhccl.runServerMethod(ANCLS.BLL.DaySurgery, "GetOperDate", record.code);
            if (ret && ret.result) {
                $("#OperDate").datebox("setValue", ret.result);
            }
        }
    });

    $("#ReentryOperation").combobox({
        valueField: "code",
        textField: "desc",
        editable: false,
        data: [{
            code: "Y",
            desc: "是"
        }, {
            code: "N",
            desc: "否"
        }]
    });
    $("#IsoOperation,#ECC,#TransAutoblood,#PrepareBlood,#InfectionOper,#MIS,#Antibiosis").combobox({
        valueField: "code",
        textField: "desc",
        editable: false,
        data: [{
            code: "Y",
            desc: "是"
        }, {
            code: "N",
            desc: "否"
        }]

    });

    $("#AnaDept").combobox({
        valueField: "RowId",
        textField: "Description",
        editable: false,
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.OperApplication;
            param.MethodName = "GetAnaDepts";
            var appDeptId = $("#AppDeptID").combobox("getValue");
            if (!appDeptId) {
                appDeptId = session.DeptID;
            }
            param.Arg1 = appDeptId;
            param.Arg2 = session.HospID;
            param.ArgCnt = 2;
        },
        mode: "remote"
    });
    $("#SeqType").combobox({
        valueField: "code",
        textField: "desc",
        editable: false,
        data: [{
            code: "N",
            desc: "正常台"
        }, {
            code: "C",
            desc: "接台"
        }]
    });


    $("#OperPosition").combobox({
        multiple: true,
        valueField: "RowId",
        textField: "Description",
        editable: false,
        data: app.opts.operPosList
    });

    $(".oper-require").combobox({
        valueField: "value",
        textField: "text",
        data: operApplication.yesNoOptions
    });

    $(".test-item").combobox({
        valueField: "value",
        textField: "text",

        data: operApplication.testOptions
    });

    $("#BloodType").combobox({
        valueField: "value",
        textField: "text",
        data: [{
            text: "未知",
            value: "N"
        }, {
            text: "A型",
            value: "A"
        }, {
            text: "B型",
            value: "B"
        }, {
            text: "AB型",
            value: "AB"
        }, {
            text: "O型",
            value: "O"
        }]
    });

    $("#btnSavePersonInfo").linkbutton({
        onClick: function() {
            SavePersonalInfo();
        }
    });
    $("#btnSave").linkbutton({
        onClick: function() {
            saveOperApplication();
        }
    });
	$("#btnRefresh").linkbutton({
		onClick:function () {
			$.messager.confirm("提示","刷新后将清除当前已输入的数据，是否继续刷新界面？",function(r){
				if(r){
					window.location.reload();
				}
			});
		}
	})
}

function loadAppFormData() {
    $("#appForm").form("clear");
    setOperAppData();
    setOperList();

}

function setDefaultValue() {
    // 获取新增手术申请还是修改手术申请
    setDefaultPatInfo();
    if (session.OPSID) {
        operApplication.newApp = false;
        setNewAppTestResult();
        $("body").layout("remove", "west");
        $(".btnList").css({ "padding": "0", "width": "auto" });
    } else {
        operApplication.newApp = true;
        setNewAppDefValue();
    }
}
//
function setDefaultPatInfo() {
    var banner = operScheduleBanner.init('#patinfo_banner', {});
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindPatient",
        Arg1: session.EpisodeID,
        ArgCnt: 1
    }, "json", true, function(appDatas) {
        if (appDatas && appDatas.length > 0) {

            banner.loadData(appDatas[0]);
            $("#btnOperList").hide();
        }
    });

}

function setNewAppDefValue() {
    // 获取默认手术室
    //var ret=dhccl.runServerMethod(ANCLS.BLL.DaySurgery,"GetDefOperDept",session.ExtDeptID);
    var ret = dhccl.runServerMethod(ANCLS.BLL.DaySurgery, "GetOutOperDeptID", "");
    $("#OperDeptID").combobox("setValue", ret);
    var retPerson = dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery, "GetPersonalInfo", session.UserID, session.DeptID);
    $("#PatNeedNotice").val(retPerson);
    // 获取择期手术是否已截止
    ret = dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication, "GetOperAppDeadLine");
    if (ret === "Y") {
        // 如果已截止，那么手术类型默认为“急诊”
        $("#SourceType").combobox("setValue", "E");
        $("#SourceType").combobox("readonly");
    } else {
        $("#SourceType").combobox("setValue", "B")
    }

    var sourceType = $("#SourceType").combobox("getValue");
    setOperDate(sourceType);

    // 默认手术申请科室为本科室
    $("#SurgeonDeptID").combobox("setValue", session.ExtDeptID);
    // 默认手术申请科室为本科室
    $("#AppDeptID").combobox("setValue", session.ExtDeptID);

    $("#AppCareProvID").combobox("reload");
    // 默认手术申请医生为当前登录的医护人员
    $("#AppCareProvID").combobox("setValue", session.CareProvID);

    // 默认手术时间为早上8:00
    $("#OperTime").timespinner("setValue", "08:00")

    // 默认手术时长为2小时
    $("#OperDuration").numberspinner("setValue", 1)

    // 台次类型默认正常台
    $("#SeqType").combobox("setValue", "N");

    // 检验项目默认值为未知
    // $(".test-item").combobox("setValue","");
    // $("#BloodType").combobox("setValue","");
    setNewAppTestResult();
    $("#AppUserID").val(session.UserID);

    $("#PlanSeq").numberspinner("setValue", 1);

    $("#ReentryOperation").combobox("setValue", "N");

    $("#Anaesthesia").combobox("setValue", "Y");
    var retPersonInfo = dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery, "GetAdmInfoFromOld", session.EpisodeID);
    var deathFlag = retPersonInfo.split("^")[3];
    $("#PatPhoneNumber").val(retPersonInfo.split("^")[0]);
    if (deathFlag == "Y") {
        $.messager.alert("提示", "患者已故不允许再申请手术", "error");
        $("#btnSave").linkbutton("disable");
        $("#btnSave").css('background-color', '#555555');
        return;
    }
    //判断是否超过挂号日期7天
    var checkValidflag = dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery, "CheckAdmValid", session.EpisodeID, session.GroupID, session.HospID);

    if (checkValidflag != "") {

        //var alertInfoStr="此就诊记录的挂号日期在"+checkValidflag.split("^")[1]+checkValidflag.split("^")[2]+"前，不允许再开手术申请";
        $.messager.alert("提示", checkValidflag, "error");
        $("#btnSave").css('background-color', '#555555');
        $("#btnSave").linkbutton('disable');
    }
}

function setNewAppTestResult() {
    var testResult = app.opts.testResult;
    if (testResult) {
        for (var key in testResult) {
            $("#" + key).combobox("setValue", testResult[key]);
        }
    }
}

function setOperAppData() {
    var appDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperScheduleList,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: session.OPSID,
        ArgCnt: 4
    }, "json");
    if (appDatas && appDatas.length > 0) {
        var appData = appDatas[0];
        $("#appForm").form("load", appData);
        $("#AppCareProvID").combobox("reload"); //加载数字问题
        // 手术部位
        /*
        if(appData.BodySite){
            var bodySiteArr=appData.BodySite.split(",");
            $("#BodySite").combobox("setValues",bodySiteArr);
        }
        */
        $("#BodySite").combobox("setValue", "");
        // 手术体位
        if (appData.OperPosition) {
            var operPosArr = appData.OperPosition.split(",");
            $("#OperPosition").combobox("setValues", operPosArr);
        }
    }
}

function setOperList() {
    var operList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperationList,
        QueryName: "FindOperationList",
        Arg1: session.OPSID,
        ArgCnt: 1
    }, "json");
    if (operList && operList.length > 0) {
        $("#operationBox").datagrid("loadData", operList);
    }
    $("#OperNote").val(""); //YuanLin 20200212 需单独处理一次
    $("#Operation").combogrid("setValues", "");
    $("#BodySite").combobox("setValues", "");
}

function setOperDate(sourceType) {
    var ret = dhccl.runServerMethod(ANCLS.BLL.DaySurgery, "GetOperDate", sourceType);
    if (ret && ret.result) {
        $("#OperDate").datebox("setValue", ret.result);
    }
}

function initOperButtons() {
    $(".operEditBtns .edit-btns").linkbutton({
        onClick: function() {
            var index = $(this).attr("data-rowindex");
            editOperation(index);
        }
    });

    $(".operSaveBtns .save-btns").linkbutton({
        onClick: function() {
            var index = $(this).attr("data-rowindex");
            saveOperation(index);
        },
        disabled: true
    });

    $(".operRemoveBtns .remove-btns").linkbutton({
        onClick: function() {
            var index = $(this).attr("data-rowindex");
            removeOperation(index);
        }
    });
}

function genOperation() {
    var formData = $("#operationForm").serializeJson();
    //var surAssistant=formData.Assistant1+","+formData.Assistant2+","+formData.Assistant3+","+formData.Assistant4+","+formData.Assistant5;
    var assis1Desc = $("#Assistant1").combobox("getText"),
        assis2Desc = "",
        assis3Desc = "";
    //$("#Assistant2").combobox("getText")
    //$("#Assistant3").combobox("getText")
    var surAssisDesc = assis1Desc;
    if (assis2Desc) {
        if (surAssisDesc) surAssisDesc += ",";
        surAssisDesc += assis2Desc;
    }
    if (assis3Desc) {
        if (surAssisDesc) surAssisDesc += ",";
        surAssisDesc += assis3Desc;
    }
    var surAssistant = formData.Assistant1;
    if (formData.Assistant2) {
        if (surAssistant) surAssistant += ",";
        surAssistant += formData.Assistant2;
    }
    if (formData.Assistant3) {
        if (surAssistant) surAssistant += ",";
        surAssistant += formData.Assistant3;
    }

    formData.Assistant = surAssistant;
    formData.AssistantDesc = surAssisDesc;
    formData.OperationDesc = $("#Operation").combogrid("getText");
    formData.OperClassDesc = $("#OperClass").combobox("getText");
    formData.SurgeonDesc = $("#Surgeon").combobox("getText");
    formData.BodySiteDesc = $("#BodySite").combobox("getText");
    formData.BladeTypeDesc = $("#BladeType").combobox("getText");
    formData.SurgeonDeptDesc = $("#SurgeonDeptID").combobox("getText");

    return formData;
}

function addOperation() {
    if (!$("#operationForm").form("validate")) return;

    var Operation = $("#Operation").combogrid("grid").datagrid("getSelected");
    if (Operation == null || Operation == undefined) {
        $.messager.alert("提示", "请选择手术名称，不允许手写填入。", "warning");
        return;
    }
    var lastSurgeonLocId = $("#SurgeonDeptID").combobox("getValue");
    var lastSurgeonLoc = $("#SurgeonDeptID").combobox("getText");
    var operList = $("#operationBox").datagrid("getRows");
    for (var i = 0; i < operList.length; i++) {
        var planOperation = operList[i];
        if (Operation == planOperation.Operation) {
            $.messager.alert("提示", "该手术已添加，请重新选择。", "warning");
            return;
        }
    }
    if ($("#Operation").combogrid("getValue") == "") {
        $.messager.alert("提示", "请先选择手术名称，再进行添加。", "warning");
        return;
    }
    if ($("#OperClass").combobox("getValue") == "") {
        $.messager.alert("提示", "请先选择手术分级，再进行添加。", "warning");
        return;
    }
    if ($("#BladeType").combobox("getValue") == "") {
        $.messager.alert("提示", "请先选择切口类型，再进行添加。", "warning");
        return;
    }
    if ($("#BodySite").combobox("getValue") == "") {
        $.messager.alert("提示", "请先选择手术部位，再进行添加。", "warning");
        return;
    }
    if ($("#Surgeon").combobox("getValue") == "") {
        $.messager.alert("提示", "请先选择主刀医生，再进行添加。", "warning");
        return;
    }
    $("#OpSubDr").val("");
    var formData = genOperation();
    formData.RowId = "";
    formData.ExternalID = "";
    $("#operationBox").datagrid("appendRow", formData);
    $("#operationForm").form("clear");
    $("#SurgeonDeptID").combobox("setValue", lastSurgeonLocId);
    $("#SurgeonDeptID").combobox("setText", lastSurgeonLoc);
}

function editOperation(index) {
    var selectedOperation = $("#operationBox").datagrid("getSelected");
    if (!selectedOperation) {
        $.messager.alert("提示", "请先选择一条手术，再修改。", "warning");
        return;
    }
    var selectedIndex = $("#operationBox").datagrid("getRowIndex", selectedOperation);
    var formData = genOperation();
    var lastSurgeonLocId = $("#SurgeonDeptID").combobox("getValue");
    var lastSurgeonLoc = $("#SurgeonDeptID").combobox("getText");
    formData.RowId = selectOperation.RowId;
    formData.ExternalID = $("#OpSubDr").val();
    $("#operationBox").datagrid("updateRow", {
        index: selectedIndex,
        row: formData
    });
    $("#operationForm").form("clear");
    $("#SurgeonDeptID").combobox("setValue", lastSurgeonLocId);
    $("#SurgeonDeptID").combobox("setText", lastSurgeonLoc);
}

function removeOperation(index) {
    var selectedOperation = $("#operationBox").datagrid("getSelected");
    if (!selectedOperation) {
        $.messager.alert("提示", "请先选择一条手术，再修改。", "warning");
        return;
    }
    var selectedIndex = $("#operationBox").datagrid("getRowIndex", selectedOperation);
    $.messager.confirm("提示", "是否删除选择的手术?", function(r) {
        if (r) {
            if (selectedOperation.RowId) {
                $("#operationBox").datagrid("deleteRow", selectedIndex);
                $("#operationForm").form("clear");
            } else {
                $("#operationBox").datagrid("deleteRow", selectedIndex);
                $("#operationForm").form("clear");
            }
        }
    });
}

function selectOperation(index, row) {
    if (row) {
        $("#operationForm").form("load", row);
        $("#Operation").combogrid("setText", row.OperationDesc);
        $("#Surgeon").combobox("setText", row.SurgeonDesc);
        $("#OpSubDr").val(row.ExternalID);

        if (row.Assistant) {
            var assisArr = row.Assistant.split(",");
            var assisDescArr = row.AssistantDesc.split(",");
            for (var i = 0; i < assisArr.length; i++) {
                var assisIndex = i + 1;
                $("#Assistant" + assisIndex).combobox("setValue", assisArr[i]);
                $("#Assistant" + assisIndex).combobox("setText", assisDescArr[i]);
            }
        } else {
            $("#Assistant1").combobox("setValue", "");
            $("#Assistant1").combobox("setText", "");
        }
    }
}


function existsApplication() {

    var ret = dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery, "ExistsOperApplication", session.EpisodeID);
    if (ret && ret.indexOf("Y") === 0) {
        return true;
    }

    return false;
}

function saveOperApplication() {
    endEdit("#operationBox");
    var PrevAnaMethod = $("#PrevAnaMethod").combobox("getValues");
    if (PrevAnaMethod.length == 0) {
        $.messager.alert("提示", "请选择拟施麻醉，不允许手写填入。", "warning");
        return;
    }
    if (!$("#appForm").form("validate")) return;
    var appData = $("#appForm").serializeJson();

    appData.ClassName = ANCLS.Model.OperSchedule;
    appData.RowId = session.OPSID ? session.OPSID : "";
    //appData.BodySite=$("#BodySite").combobox("getValues").join(",");
    appData.OperPosition = $("#OperPosition").combobox("getValues").join(",");
    if (!appData.PatPhoneNumber) {
        $.messager.alert("提示", "患者电话不能为空，请填写后再保存手术申请。", "warning");
        return;
    }
    appData.EpisodeID = session.EpisodeID;
    appData.AppUserID = session.UserID; //???
    appData.OPAdmType = "OOP";
    // 拟施手术
	if(!validateOperList(true)) return;     // 拟施手术数据完整性验证
    var operList = $("#operationBox").datagrid("getRows");
    var checkSurStr = "";
    appData.StatusCode = "Application";
    for (var ic = 0; ic < operList.length; ic++) {
        var planOperation = operList[ic];
        planOperation.ClassName = ANCLS.Model.PlanOperList;
        if (checkSurStr != "") checkSurStr = checkSurStr + "^" + planOperation.SurgeonDesc;
        else {
            checkSurStr = planOperation.SurgeonDesc;
        }
    }
    if (checkSurStr == "") {
        //$.messager.alert("提示","日间手术确认需选择主刀医师，请修改拟施手术信息","error");  
        //return;
    }

    // 拟施手术
    var dataArr = [];
    dataArr.push(appData);
    for (var i1 = 0; i1 < operList.length; i1++) {
        var planOperation = operList[i1];
        planOperation.ClassName = ANCLS.Model.PlanOperList;
        dataArr.push(planOperation);
    }

    // 实施手术
    for (var i2 = 0; i2 < operList.length; i2++) {
        var actOperation = operList[i2];
        var operation = {};
        for (var property in actOperation) {
            operation[property] = actOperation[property];
        }
        operation.ClassName = ANCLS.Model.OperList;
        dataArr.push(operation);
    }

    var dataPara = dhccl.formatObjects(dataArr);

	//CA签名
	var OrdItms=""
	var originalData = JSON.stringify(dataArr);
	var ret=CheckCAIfInUsage();
	if(ret=="1"){
		dhcsys_getcacert({
			modelCode:"ANOPSign",
			callback:function(cartn){
				// 签名窗口关闭后,会进入这里
				if (cartn.IsSucc){
					if (cartn.ContainerName) {
						if ("object"== typeof cartn && cartn.IsCAReLogon){
							var userCertCode = cartn.CAUserCertCode;
							var certNo = cartn.CACertNo;
							var toSignData=originalData;
							var hashData = cartn.ca_key.HashData(encodeURI($.parseJSON(toSignData)));
							var signedData = cartn.ca_key.SignedData(hashData, cartn.ContainerName);
							var opsId = SaveOutOperApp(dataPara, appData);
							if(opsId){
								var RecordSheetID=dhccl.runServerMethodNormal(ANCLS.BLL.RecordSheet,"GetRecordSheetIdByModCode",opsId,session.ModuleCode,session.ExtUserID)
								var saveRet=dhccl.runServerMethodNormal(ANCLS.CA.SignatureService,"Sign", RecordSheetID, userCertCode,"btnSave", hashData, signedData, "", certNo);
								OrdItms=dhccl.runServerMethodNormal("CIS.AN.SRV.OperAppService","GetOrdItms",opsId);
								if(saveRet.indexOf("S^")===0){
									$.messager.popover({
										msg: "签名成功!",
										type: "success"
									});
								}else{
									$.messager.alert("提示","签名失败，原因："+saveRet,"error");
								}
								if(OrdItms!=""){
									InsDigitalSign(OrdItms,session.ExtUserID,"A","ANOPSign","",cartn,certNo,userCertCode)
								}
							}
						}
					}else{
						alert("未开启CA,使用HIS系统签名!");
						return false;
					}
				}else {
					alert("签名失败！");
					return false;
				}
			}
		}, "",0,1);
	}
	else{
		SaveOutOperApp(dataPara, appData);
	}
}

function SaveOutOperApp(dataPara, appData){
	var ret = dhccl.runServerMethod(ANCLS.BLL.DaySurgery, "SaveOperApplication", dataPara, "", appData.RowId);
    if (ret.success) {
        if (operApplication.newApp) {

            var warninginfo2 = "保存手术申请成功，是否打印门诊预约单？";
            session.OPSID = ret.result;

            $.messager.confirm("提示", warninginfo2, function(data) {
                if (data) {
                    PrintMZSSYYD();

                } else {
                    loadAppFormData();
                }
            });
            // window.location.reload();
        } else {
            var warninginfo = "";

            warninginfo = "手术修改成功，是否打印门诊预约单？";
            $.messager.confirm("提示", warninginfo, function(r) {
                if (r) {
                    PrintMZSSYYD();
                    if (window.parent.closeOutOperDialog) {
                        window.parent.closeOutOperDialog();
                    } else {
                        loadAppFormData();
                    }

                } else {

                    loadAppFormData();
                }
            });

        }
		return ret.result

    } else {
        $.messager.alert("提示", "保存门诊手术申请失败，原因：" + ret.result, "error");
		return "";
    }
}


function validateOperList(showMessage){
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

function ClearAppData() {
    var rows = $("#operationBox").datagrid('getRows');
    for (var i = 0; i < rows.length; i++) {
        $("#operationBox").datagrid('deleteRow', i);
    }
    $("#operationForm").form("clear");

    //手术部位
    //$("#BodySite").combobox("setValues","");

    //手术体位
    $("#OperPosition").combobox("setValues", "");

    //实习进修
    //$("#SurIntership").val("");

    //参观人员
    //$("#SurVisitors").val("");

    //仪器要求
    $("#SurgicalMaterials").val("");

    //特殊情况
    $("#SpecialConditions").val("");

    //高值耗材
    $("#HighConsume").val("");

    //隔离手术
    $("#IsoOperation").combobox("setValues", "");

    //体外循环
    $("#ECC").combobox("setValues", "");

    //自体血回输
    $("#TransAutoblood").combobox("setValues", "");

    //备血
    $("#PrepareBlood").combobox("setValues", "");

    //感染手术
    $("#InfectionOper").combobox("setValues", "");

    //微创手术
    $("#MIS").combobox("setValues", "");

    //使用抗生素
    $("#Antibiosis").combobox("setValues", "");
}

function SavePersonalInfo() {
    var userId = session.UserID;
    var userLocId = session.DeptID;
    var personalInfo = $("#PatNeedNotice").val();
    var ret = dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery, "SavePersonalInfo", userId, userLocId, personalInfo);
    //if(ret)
}

function PrintMZSSYYD() {

    operDataManager.printCount(session.RecordSheetID, session.ModuleCode, true);
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OutOper" + session.OPSID); //初始化表单
    lodop.SET_PRINT_MODE("PRINT_DUPLEX", 2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printCount;

    createOutPrintOnePage(lodop, outOper.schedule);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
    lodop.PREVIEW();
}

function createOutPrintOnePage(LODOP, operSchedule) {
    var prtConfig = sheetPrintConfig,
        logoMargin = prtConfig.logo.margin,
        logoSize = prtConfig.logo.size,
        titleFont = prtConfig.title.font,
        titleSize = prtConfig.title.size,
        titleMargin = prtConfig.title.margin,
        contentSize = prtConfig.content.size,
        contentFont = prtConfig.content.font;
    LODOP.SET_PRINT_PAGESIZE(prtConfig.paper.direction, 0, 0, prtConfig.paper.name);
    //lodop.SET_PRINT_STYLE("FontSize", contentFont.size);
    //lodop.SET_PRINT_STYLE("FontName", contentFont.name);
    //lodop.ADD_PRINT_IMAGE(logoMargin.top,logoMargin.left,logoSize.width,logoSize.height,"<img src='"+prtConfig.logo.imgSrc+"'>");
    // lodop.SET_PRINT_STYLEA(0, "Stretch", 2);

    var startPos = {
        x: prtConfig.paper.margin.left,
        y: logoMargin.top + logoSize.height + logoMargin.bottom + 20
    };
    var tmpwidth = 5;
    LODOP.ADD_PRINT_RECT(10, 10, 740 + tmpwidth, 45, 0, 1); //第1行

    LODOP.ADD_PRINT_TEXT(20, startPos.x, "100%", 30, session.ExtHospDesc);
    LODOP.SET_PRINT_STYLEA(0, "FontName", titleFont.name);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", titleFont.size);

    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);

    LODOP.ADD_PRINT_RECT(55, 10, 740 + tmpwidth, 40, 0, 1); //第2行

    LODOP.ADD_PRINT_TEXT(65, startPos.x, "100%", 30, "门诊手术预约单");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    //----
    //lodop.ADD_PRINT_RECT(90,10,775,40,0,1);    //第3行
    //lodop.SET_PRINT_STYLE("FontSize",18);

    LODOP.SET_PRINT_STYLE("FontSize", 16);
    LODOP.SET_PRINT_STYLE("FontName", "宋体");
    LODOP.ADD_PRINT_RECT(95, 10, 100, 45, 0, 1); //第3行 1
    LODOP.ADD_PRINT_TEXT(107, 15, 100, 30, "患者姓名");
    LODOP.ADD_PRINT_RECT(95, 110, 160, 45, 0, 1); //第3行 2
    LODOP.ADD_PRINT_TEXT(107, 120, 160, 30, (operSchedule ? operSchedule.PatName : ""));

    //lodop.ADD_PRINT_RECT(90,270,60,40,0,1);    //第3行 3
    LODOP.ADD_PRINT_TEXT(107, 280, 60, 30, "性别");
    LODOP.ADD_PRINT_RECT(95,350,40,45,0,1);    //第3行 4
    LODOP.ADD_PRINT_TEXT(107, 360, 45, 30, (operSchedule?operSchedule.PatGender:""));


    LODOP.ADD_PRINT_RECT(95,390,60,45,0,1);    //第3行
    LODOP.ADD_PRINT_TEXT(107, 400, 60, 30, "年龄");
    LODOP.ADD_PRINT_RECT(95,450,70,45,0,1);    //第3行
    LODOP.ADD_PRINT_TEXT(107, 460, 70, 30, (operSchedule?operSchedule.PatAge:""));


    LODOP.ADD_PRINT_RECT(95,520,100,45,0,1);    //第3行
    LODOP.ADD_PRINT_TEXT(107, 540, 100, 30, "住院号");
    LODOP.ADD_PRINT_RECT(95,620,130+tmpwidth,45,0,1);    //第3行
    LODOP.ADD_PRINT_TEXT(107, 630, 140, 30, (operSchedule?operSchedule.MedcareNo:""));
    //----
    //ADD_PRINT_RECT(Top, Left, Width, Height,intLineStyle, intLineWidth)增加矩形线
    //ADD_PRINT_TEXT(Top,Left,Width,Height,strContent)增加纯文本打印项
    LODOP.ADD_PRINT_RECT(140,10,100,45,0,1);    //第4行
    LODOP.ADD_PRINT_TEXT(152, 15, 100, 30, "身份证号");

    LODOP.ADD_PRINT_RECT(140,110,240,45,0,1);    //第4行
    LODOP.ADD_PRINT_TEXT(152, 120, 220, 30, replacePos((operSchedule?operSchedule.PatCardID:""),7,"********"));
    //LODOP.ADD_PRINT_TEXT(152, 115, 225, 30, replacePos("15040319890304351x",7,"********"));
    var retPersonInfo=dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery,"GetAdmInfoFromOld",operSchedule.EpisodeID);
   
    //ADD_PRINT_RECT(Top, Left, Width, Height,intLineStyle, intLineWidth)
    LODOP.ADD_PRINT_RECT(140,350,100,45,0,1);    //第4行
    LODOP.ADD_PRINT_TEXT(152, 360, 100, 30, "工作单位");

    LODOP.ADD_PRINT_RECT(140,450,300+tmpwidth,45,0,1);    //第4行
    LODOP.ADD_PRINT_TEXT(152, 460, 295, 30, retPersonInfo.split("^")[1]);

     //----
     LODOP.ADD_PRINT_RECT(185,10,740+tmpwidth,45,0,1);    //第5行
     LODOP.ADD_PRINT_TEXT(197, 15, 110, 30, "联系电话");

     LODOP.ADD_PRINT_RECT(185,110,240,45,0,1);    //第5行
     LODOP.ADD_PRINT_TEXT(197, 115, 220, 30, (operSchedule?operSchedule.PatPhoneNumber:""));

     LODOP.ADD_PRINT_RECT(185,350,100,45,0,1);    //第4行
     LODOP.ADD_PRINT_TEXT(197, 360, 100, 30, "家庭地址");

     LODOP.ADD_PRINT_RECT(185,450,300+tmpwidth,45,0,1);    //第4行
     LODOP.ADD_PRINT_TEXT(197, 455, 295, 30, retPersonInfo.split("^")[2]);
     //----
     LODOP.ADD_PRINT_RECT(230,10,100,45,0,1);    //第6行
     LODOP.ADD_PRINT_TEXT(242, 15, 110, 30, "手术要求");
     LODOP.ADD_PRINT_RECT(230,110,640+tmpwidth,45,0,0);    //第6行
     LODOP.ADD_PRINT_TEXT(242, 120, 640, 30, (operSchedule?operSchedule.SurgicalMaterials:""));
     //----
    var admDiagnosisList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindAdmDiagnosis",
        Arg1: operSchedule.EpisodeID,
        Arg2: "OP",
        ArgCnt: 2
    }, "json");
    var singlediag = "";
    if (admDiagnosisList && admDiagnosisList.length > 0) {
        for (var intdiag = 0; intdiag < admDiagnosisList.length; intdiag++) {
            var diagstr = admDiagnosisList[intdiag];
            if (singlediag != "") singlediag = singlediag + "," + diagstr.ICDCodeDesc;
            else singlediag = diagstr.ICDCodeDesc;
        }
    }

    LODOP.ADD_PRINT_RECT(275, 10, 100, 45, 0, 1); //第7行
    LODOP.ADD_PRINT_TEXT(287, 15, 110, 30, "诊    断");
    LODOP.ADD_PRINT_RECT(275, 110, 640 + tmpwidth, 45, 0, 1); //第6行
    LODOP.ADD_PRINT_TEXT(287, 120, 640, 30, singlediag);
    //----
    LODOP.ADD_PRINT_RECT(320, 10, 100, 45, 0, 1); //第8行
    LODOP.ADD_PRINT_TEXT(332, 15, 110, 30, "手术名称");
    LODOP.ADD_PRINT_RECT(320, 110, 640 + tmpwidth, 45, 0, 1); //第6行
    LODOP.ADD_PRINT_TEXT(332, 120, 640, 30, (operSchedule ? operSchedule.OperDesc : ""));
    //----
    LODOP.ADD_PRINT_RECT(365, 10, 100, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(377, 15, 100, 30, "手术医师");
    LODOP.ADD_PRINT_RECT(365, 110, 100, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(377, 115, 100, 30, (operSchedule ? operSchedule.SurgeonDesc : ""));

    LODOP.ADD_PRINT_RECT(365, 210, 100, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(377, 215, 100, 30, "手术科室");
    LODOP.ADD_PRINT_RECT(365, 310, 190, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(377, 315, 185, 30, (operSchedule ? operSchedule.OperDeptDesc : ""));

    LODOP.ADD_PRINT_RECT(365, 500, 250 + tmpwidth, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(377, 515, 270, 30, "预约时间");

    LODOP.ADD_PRINT_RECT(410, 500, 250 + tmpwidth, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(422, 535, 220, 30, (operSchedule ? operSchedule.OperDate : "") + " " + (operSchedule ? operSchedule.OperTime : "").substring(0, 5));
    //----
    LODOP.ADD_PRINT_RECT(410, 10, 100, 45, 0, 1); //第10行
    LODOP.ADD_PRINT_TEXT(422, 15, 100, 30, "申请医师");
    LODOP.ADD_PRINT_RECT(410, 110, 100, 45, 0, 1); //第10行
    LODOP.ADD_PRINT_TEXT(422, 115, 100, 30, (operSchedule ? operSchedule.AppCareProvDesc : ""));
    LODOP.ADD_PRINT_RECT(410, 210, 100, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(422, 215, 100, 30, "申请科室");
    LODOP.ADD_PRINT_RECT(410, 310, 190, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(422, 315, 190, 30, (operSchedule ? operSchedule.AppDeptDesc : ""));

    LODOP.ADD_PRINT_RECT(455, 500, 250 + tmpwidth, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(467, 515, 250, 30, "申请时间");

    LODOP.ADD_PRINT_RECT(500, 500, 250 + tmpwidth, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(512, 535, 220, 30, (operSchedule ? operSchedule.AppDateTime : "").substring(0, 16));

    //----
    LODOP.SET_PRINT_STYLE("FontName", "黑体");
    LODOP.ADD_PRINT_RECT(455, 10, 100, 250, 0, 1); //第11行
    LODOP.ADD_PRINT_TEXT(467, 15, 100, 200, "患者须知");
    LODOP.SET_PRINT_STYLE("FontName", "宋体");
    LODOP.ADD_PRINT_RECT(455, 110, 390, 250, 0, 1); //第11行
    LODOP.ADD_PRINT_TEXT(467, 120, 370, 250, (operSchedule ? operSchedule.PatNeedNotice : ""));

    LODOP.SET_PRINT_STYLE("FontName", "黑体");
    LODOP.ADD_PRINT_RECT(545, 500, 250 + tmpwidth, 45, 0, 1); //第9行
    LODOP.ADD_PRINT_TEXT(557, 515, 250, 30, "来院时间");
    //lodop.SET_PRINT_STYLE( "FontName", "宋体");
    //
    LODOP.ADD_PRINT_RECT(590, 500, 250 + tmpwidth, 115, 0, 1); //第9行
    var comDateStr = (operSchedule ? operSchedule.OperDate : "") + " " + (operSchedule ? operSchedule.ComeHosTime : "");

    LODOP.ADD_PRINT_TEXT(612, 535, 300, 30, comDateStr);
    //SET_PRINT_STYLE(strStyleName,varStyleValue)
    //ADD_PRINT_TEXT(Top,Left,Width,Height,strContent)增加纯文本打印项
    startPos.y += titleSize.height + titleMargin.bottom;
    var lineHeight = 20;

    LODOP.SET_PRINT_STYLE("FontSize", 12);

    var anaestMethodInfo = operSchedule ? operSchedule.AnaestMethodInfo : ""
    if (!anaestMethodInfo || anaestMethodInfo === "") {
        anaestMethodInfo = operSchedule ? operSchedule.PrevAnaMethodDesc : "";
    }
    startPos.y += lineHeight;
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "手术日期:"+(operSchedule?operSchedule.OperDate:""));
    //var operInfo="这里取手术名称";
    LODOP.SET_PRINT_STYLE("FontSize", 12);
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "手术方式：");
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+70, 470, 30, operSchedule?operSchedule.OperDesc:"");

    //startPos.y+=lineHeight+(operInfo.length>40?25:0);

}

function replacePos(strObj, pos, replacetext) {
    var str = strObj.substr(0, pos - 1) + replacetext + strObj.substring(pos + 6, strObj.length);
    return str;
}

function dateAddDays(dateStr, dayCount) {
    var tempDate = new Date(dateStr.replace(/-/g, "/"));
    var resultDate = new Date((tempDate / 1000 + (86400 * dayCount)) * 1000);
    var resultDateStr = resultDate.getFullYear() + "-" + (resultDate.getMonth() + 1) + "-" + (resultDate.getDate());
    return resultDateStr;
}


/**
 * 获取手术名称编辑控件的选项
 */
function getOperationOptions(){
	return {
		url: ANCSP.DataQuery,
		onBeforeLoad: function(param) {
			param.Arg4="";
			param.Arg5=session.EpisodeID;
			param.Arg6=session.HospID;
			var rows=$("#operationBox").datagrid("getRows");
			var rowData=rows[outApp.editIndex];
			if(rows && rows.length>0 && outApp.firstEdit && rowData.OperationDesc){
				param.q=rowData.OperationDesc;
				param.Arg4=rowData.Operation;
				outApp.firstEdit=false;
			}
			param.ClassName = ANCLS.BLL.Operation;
			param.QueryName = "FindOperation";
			param.Arg1 = param.q?param.q:"";
			param.Arg2 = rowData.Surgeon;
			param.Arg3 = rowData.SurgeonDeptID;
			param.ArgCnt = 6;
		},
		panelWidth:600,
		panelHeight:400,
		idField: "RowId",
		textField: "Description",
		className: ANCLS.BLL.Operation,
		queryName:"FindOperationColumns",
		onColumnsLoad:function(cm){
			for (var i=0;i<cm.length;i++){
				if(cm[i]['field']=="RowId"){
					cm[i]['title']="ID"
					cm[i].formatter = function(value,rec){
						var btn=""
						if (value!=""){
							var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.RowId + '\')">'+value+'</a>';
						}
						return btn;
					}
				}
				else if(cm[i]['field']=="Description"){
					cm[i]['title']="名称"
					cm[i].formatter = function(value,rec){
						var btn=""
						if (value!=""){
							var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.RowId + '\')">'+value+'</a>';
						}
						return btn;
					}
				}
				else if(cm[i]['field']=="StandardDesc"){
					cm[i]['title']="医保名称"
					cm[i].formatter = function(value,rec){
						var btn=""
						if (value!=""){
							var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.RowId + '\')">'+value+'</a>';
						}
						return btn;
					}
				}
				else if(cm[i]['field']=="StandardCode"){
					cm[i]['title']="医保编码"
					cm[i].formatter = function(value,rec){
						var btn=""
						if (value!=""){
							var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.RowId + '\')">'+value+'</a>';
						}
						return btn;
					}
				}
				else if(cm[i]['field']=="OperClassDesc"){
					cm[i]['title']="分级"
					cm[i].formatter = function(value,rec){
						var btn=""
						if (value!=""){
							var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.RowId + '\')">'+value+'</a>';
						}
						return btn;
					}
				}
				else if(cm[i]['field']=="ICDCode"){
					cm[i]['title']="ICD码"
					cm[i].formatter = function(value,rec){
						var btn=""
						if (value!=""){
							var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.RowId + '\')">'+value+'</a>';
						}
						return btn;
					}
				}
				else {
					cm[i].hidden=true;
				}
			}
		},
		pagination:true,
		pageSize:10,
		mode: "remote",
		onSelect:function(rowIndex,rowData){
			var checkFlag=true;
			var rows=$("#operationBox").datagrid("getRows");
			for(var i=0;i<rows.length;i++){
				var operrow=rows[i];
				if((operrow.OperationDesc===rowData.Description)&&(i!==outApp.editIndex)){
					$.messager.alert("提示","手术重复,请重新选择!","warning");
					checkFlag=false;
					$("#operationBox").datagrid("deleteRow",outApp.editIndex);
					break;
				}
			}
			if(checkFlag){
				setComboboxFieldDesc(rowData,"OperationDesc","Description");
				setComboboxFieldDesc(rowData,"Operation","RowId");
				setComboboxFieldDesc(rowData,"OperClass","OperClass");
				setComboboxFieldDesc(rowData,"OperClassDesc","OperClassDesc");
				setComboboxFieldDesc(rowData,"BladeType","BladeType");
				setComboboxFieldDesc(rowData,"BladeTypeDesc","BladeTypeDesc");
				setComboboxFieldDesc(rowData,"BodySite","BodySite");
				setComboboxFieldDesc(rowData,"BodySiteDesc","BodySiteDesc");
				$("#OperPosition").combobox("setValues",rowData.OperPos);
				endEdit("#operationBox");
			}
		}
	}
}

/**
 * 获取手术分级编辑控件的选项
 */
function getOperClassOptions(){
	return {
		valueField: "RowId",
		textField: "Description",
		data:app.opts.operClassList,
		editable:false,
		onSelect:function(record){
			setComboboxFieldDesc(record,"OperClassDesc","Description");
		}
	}
}

/**
 * 获取切口类型编辑控件的选项
 */
function getBladeTypeOptions(){
	return {
		valueField: "RowId",
		textField: "Description",
		data:app.opts.bladeTypeList,
		editable:false,
		onSelect:function(record){
			setComboboxFieldDesc(record,"BladeTypeDesc","Description");
		}
	}
}

/**
 * 获取手术部位编辑控件的选项
 */
function getBodySiteOptions(){
	return {
		valueField: "RowId",
		textField: "Description",
		mode: "remote",
		data:app.opts.bodySiteList,
		panelWidth:120,
		onSelect:function(record){
			setComboboxFieldDesc(record,"BodySiteDesc","Description");
		}
	}
}

/**
 * 获取术者科室编辑控件的选项
 */
function getSurgeonDeptOptions(){
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
			setComboboxFieldDesc(record,"SurgeonDeptDesc","Description");
			var operId="";
			if (outApp.editData) operId=outApp.editData.Operation;
			loadSurgeons(operId,record.RowId);
			loadAssistants(record.RowId);
			$("#patChiefDoc").combobox("loadData",app.opts.surgeons);
		}
	}
}
		
/**
 * 获取手术助手编辑控件的选项
 */
function getAssistantOptions(){
	return {
		//data:app.opts.appCareProvs,
		valueField: "RowId",
		textField: "Description",
		multiple:true,
		rowStyle:"checkbox",
		url:ANCSP.DataQuery,
		onBeforeLoad:function(param){
			var deptId=outApp.editData.SurgeonDeptID;
			param.ClassName=CLCLS.BLL.Admission;
			param.QueryName="FindCareProvByLoc";
			param.Arg1="";
			param.Arg2=deptId;
			param.ArgCnt=2;
		},
		onSelect:function(record){
			var text=$(this).combobox("getText");
			setComboboxFieldDesc({Description:text},"AssistantDesc","Description");
		}
	}
}

/**
 * 获取手术医生编辑控件的选项
 */
function getSurgeonOptions(){
	return {
		//data:app.opts.appCareProvs,
		valueField: "RowId",
		textField: "CareProvDesc",
		panelWidth:120,
		url:ANCSP.DataQuery,
		onBeforeLoad:function(param){
			var operId=outApp.editData.Operation;
			var deptId=outApp.editData.SurgeonDeptID;
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
			setComboboxFieldDesc(record,"SurgeonDesc","Description");
			setComboboxFieldDesc(record,"Surgeon","Code");
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
				var rowData=rows[outApp.editIndex];
				if(rowData){
					rowData["Assistant"]=AssistantId;
					rowData["AssistantDesc"]=Assistant;
				}
				endEdit("#operationBox");
			}
			else{
				var rows=$("#operationBox").datagrid("getRows");
				var rowData=rows[outApp.editIndex];
				if(rowData){
					rowData["Assistant"]="";
					rowData["AssistantDesc"]="";
				}
				endEdit("#operationBox");
			}
		},
		mode:"remote"
	}
}

/**
 * 结束编辑状态
 * @param {String} selector Datagrid选择器
 */
function endEdit(selector){
	var rows=$(selector).datagrid("getRows");
	for(var i=0;i<rows.length;i++){
		$(selector).datagrid("endEdit",i);
	}
}

/**
 * 下拉框选择后，对表格的相应描述字段进行赋值。
 * 这样表格相应行结束编辑状态后，相应字段就不会显示成ID。
 * 相应字段显示方式参考列选项的formatter函数。
 * @param {object} record 下拉框选择项
 * @param {String} descField 表格描述字段
 * @param {String} textField 下拉框文本字段
 */
function setComboboxFieldDesc(record,descField,textField){
	var rows=$("#operationBox").datagrid("getRows");
	var rowData=rows[outApp.editIndex];
	if(rowData){
		rowData[descField]=record[textField];
	}
}

/**
 * 加载手术医生
 */
function loadSurgeons(operId,deptId){
	var _this=app;
	_this.opts.surgeons = dhccl.getDatas(ANCSP.DataQuery, {
		ClassName: ANCLS.BLL.ConfigQueries,
		QueryName: "FindSurgeonByOper",
		Arg1:"",
		Arg2:deptId,
		Arg3:"Y",
		Arg4:session.HospID,
		Arg5:operId,
		ArgCnt: 5
	}, "json");
}

 /**
 * 加载手术助手
 */
function loadAssistants(deptId){
	var _this=app;
	_this.opts.assistants = dhccl.getDatas(ANCSP.DataQuery, {
		ClassName: CLCLS.BLL.Admission,
		QueryName: "FindCareProvByLoc",
		Arg1:"",
		Arg2:deptId,
		ArgCnt: 2
	}, "json");
}

function dhcsys_getcacert(options, logonType, singleLogon, forceOpen) {
		var isHeaderMenuOpen = false;
		var notLoadCAJs = 0,
		caInSelfWindow = 0,
        loc = "",
        groupDesc = "",
        forceOpenSure = 0,
        forceOpenUkeySure = 0;
		var modelCfgJson = "",
        modelCfgJsonObj = {};
		var callback = undefined;
		if ("object" == typeof options && options !== null) {
			if ("undefined" !== typeof options.callback) callback = options.callback;
			if ("undefined" !== typeof options.modelCode) {
				modelCfgJson = tkMakeServerCall("CF.BSP.CA.DTO.SignModel", "GetCfgJson", options.modelCode);
				if (modelCfgJson != "") {
					eval("modelCfgJsonObj=" + modelCfgJson);
					if (modelCfgJsonObj) {
						if ("undefined" !== typeof modelCfgJsonObj.active) {
							if (modelCfgJsonObj.active == 0) {
								callback({
									IsSucc: true,
									varCert: "",
									ContainerName: "",
									"IsCA": false
								});
								return {
									IsSucc: true,
									varCert: "",
									ContainerName: "",
									"IsCA": false
								};
							}
						}
						if ("undefined" === typeof options.isHeaderMenuOpen && "undefined" !== typeof modelCfgJsonObj.isHeaderMenuOpen) {
							//options.isHeaderMenuOpen = modelCfgJsonObj.isHeaderMenuOpen;
							options.isHeaderMenuOpen = 0;
						}
						if ("undefined" === typeof options.notLoadCAJs && "undefined" !== typeof modelCfgJsonObj.notLoadCAJs) {
							options.notLoadCAJs = modelCfgJsonObj.notLoadCAJs;
						}
						if ("undefined" === typeof options.signUserType && "undefined" !== typeof modelCfgJsonObj.signUserType) {
							options.signUserType = modelCfgJsonObj.signUserType;
						}
						if ("undefined" === typeof options.forceOpenSure && "undefined" !== typeof modelCfgJsonObj.forceOpenSure) {
							options.forceOpenSure = modelCfgJsonObj.forceOpenSure;
						}
						if ("undefined" === typeof forceOpen && "undefined" !== typeof modelCfgJsonObj.forceOpen) {
							options.forceOpen = modelCfgJsonObj.forceOpen;
							forceOpen = modelCfgJsonObj.forceOpen;
						}
						if ("undefined" === typeof singleLogon && "undefined" !== typeof modelCfgJsonObj.singleLogon) {
							options.singleLogon = modelCfgJsonObj.singleLogon;
							singleLogon = modelCfgJsonObj.singleLogon;
						}
					}
				}
			}
			if ("undefined" !== typeof options.isHeaderMenuOpen) isHeaderMenuOpen = options.isHeaderMenuOpen;
			if ("undefined" !== typeof options.SignUserCode) SignUserCode = options.SignUserCode;
			if ("undefined" !== typeof options.notLoadCAJs) notLoadCAJs = options.notLoadCAJs
			if ("undefined" !== typeof options.loc) loc = options.loc
			if ("undefined" !== typeof options.groupDesc) groupDesc = options.groupDesc;
			if ("undefined" !== typeof options.caInSelfWindow) caInSelfWindow = options.caInSelfWindow;
			if ("undefined" !== typeof options.forceOpenSure) forceOpenSure = options.forceOpenSure;
		}
		if ("function" == typeof options) {
			callback = options;
		}
		var win = websys_getMenuWin() || window;
		if (caInSelfWindow == 1) {
			win = window;
		}
		if (isHeaderMenuOpen) {
			if (win != self && win.dhcsys_getcacert) {
				return win.dhcsys_getcacert(options, logonType, singleLogon, forceOpen);
			}
		}
		if ("undefined" === typeof singleLogon) singleLogon = 1;
		if ("undefined" === typeof logonType || "" == logonType) {
			logonType = "UKEY";
			if (win.LastCALogonType) {
				logonType = win.LastCALogonType;
				if (logonType == "UKEY" && forceOpenSure == 1) forceOpenUkeySure = 1;
			}
		}
		if ("undefined" === typeof forceOpen) forceOpen = 0;
		var obj = {},
		varCert = "",
        ContainerName = "",
        CTLoc = "",
        arr = [],
        rtn = {};
		var failRtn = {
			IsSucc: false,
			varCert: "",
			ContainerName: "",
			"IsCA": false
		};
		if (loc != "") {
			CTLoc = loc
		} else {
			if (session.ExtDeptID) {
				CTLoc = session.ExtDeptID;
			}
		}
		if (CTLoc == "") {
			rtn = {
				IsSucc: true,
				varCert: "",
				ContainerName: "",
				"IsCA": false
			};
			if (callback) callback(rtn);
			return rtn;
		}
		var userName = session.ExtUserCode;
		if ("0" == forceOpen) {
			var flag = IsCaLogon(CTLoc, userName, groupDesc);
			if (flag == 0) {
				rtn = {
					IsSucc: true,
					varCert: "",
					ContainerName: "",
					"IsCA": false
				};
				if (callback) callback(rtn);
				return rtn;
			}
			ContainerName = dhcsys_getContainerNameAndPin();
			if (ContainerName.indexOf("^") > -1) {
				arr = ContainerName.split("^");
				ContainerName = arr[0];
				logonType = arr[2] || "UKEY";
			}
		}
        if (ContainerName) {
        var rtn = {
            "IsCA": true,
            IsSucc: true,
            ContainerName: ContainerName,
            UserName: arr[7] || "",
            UserID: arr[6] || "",
            CALogonType: arr[2] || "",
            CAUserCertCode: arr[3] || "",
            CACertNo: arr[4] || "",
            CAToken: arr[5] || "",
            ca_key: win.ca_key || ""
        };
        var validJsonStr = tkMakeServerCall("websys.CAInterface", "GetCACertIsValidInfo", logonType, CTLoc);
        if (validJsonStr != "") {
            var jsonObj = {};
            eval("jsonObj=" + validJsonStr + "");
            if (jsonObj.VenderCode != "") {
                if (notLoadCAJs == 1) {
                    jsonObj.retCode = 0;
                } else {
                    if (logonType == "UKEY") {
                        if (jsonObj.VenderCode.indexOf("BJCA") > -1) {
                            if (isValidBJCA(win, ContainerName)) {
                                jsonObj.retCode = 0;
                            } else {
                                jsonObj.retCode = -1;
                            }
                        } else {
                            if (isValidCA(win, ContainerName)) {
                                jsonObj.retCode = 0;
                            } else {
                                jsonObj.retCode = -1;
                            }
                        }
                    }
                }
            }
            if (jsonObj.retCode == 0) {
                try {
                    rtn.varCert = win.GetSignCert(ContainerName);
                } catch (ex) {};
                if (forceOpenUkeySure == 0 && callback) callback(rtn);
                if (forceOpenUkeySure == 0) return rtn;
            } else {}
        }
    }
    if (forceOpenUkeySure == 1) {
        logonType = "UKEYSURELIST";
        singleLogon = 1;
    }
    obj = dhcsys_calogonshow(CTLoc, userName, logonType, singleLogon, callback, options);
    if (obj.IsSucc && obj.ContainerName) {
        try {
            obj.varCert = win.GetSignCert(obj.ContainerName);
        } catch (ex) {};
        obj.ca_key = win.ca_key || "";
    }
    return obj;
}
	function tkMakeServerCall(){
		var result = null;
		if (arguments.length < 2) return result;
		var className = arguments[0];
		var methodName = arguments[1];
		var params = [];
		for (var i = 2; i < arguments.length; i++) {
			if (params.length > 0) params.push(splitchar.comma);
			params.push("\"" + arguments[i] + "\"");
		}
		$.ajax({
			url: ANCSP.MethodService,
			async: false,
			data: {
				ClassName: className,
				MethodName: methodName,
				Params: params.join("")
			},
			type: "post",
			success: function (data) {
				result = $.trim(data);
			}
		});
		return result;
	}
	/*检查CA是否使用*/
	function CheckCAIfInUsage(){
		var userId = session.ExtUserID;
		var locId = session.ExtDeptID;
		var groupId = session.ExtGroupID;
		var ret = dhccl.runServerMethodNormal("CA.DigitalSignatureService","GetCAServiceStatus",locId,userId,groupId,"ANOPSign");
		return ret;
	}
	function InsDigitalSign(Datas,LgUserID,XmlType,ModuleMark,OtherParams,cartn,CACertNo,userCertCode){
		try {
			//1.批量签名认证
			var itmValData = ""; var itmHashData = ""; var itmSignData = "";
			var DatasArr = Datas.split("^");
			for (var i=0; i < DatasArr.length; i++){
				/// 医嘱信息串:
				var itmsXml = GetOrdItemXml(DatasArr[i], XmlType);
				var itmXmlArr = itmsXml.split(String.fromCharCode(2));
				for (var j = 0; j < itmXmlArr.length; j++) {
					if (itmXmlArr[j] == "") continue;
					var itmXml = itmXmlArr[j].split(String.fromCharCode(1))[1];
					var itmOpType = itmXmlArr[j].split(String.fromCharCode(1))[0];
					var itmXmlHash = cartn.ca_key.HashData(itmXml);
					/// 签名串Hash值
					if (itmHashData == "") itmHashData = itmXmlHash;
					else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
					/// 签名串
					var SignedData = cartn.ca_key.SignedOrdData(itmXmlHash, cartn.ContainerName);
					if (itmSignData == "") itmSignData = SignedData;
					else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
					
					if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + DatasArr[i];
					else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + DatasArr[i];
				}
			}
			
			if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
			if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

			//获取客户端证书
			var varCert = cartn.ca_key.GetSignCert(cartn.ContainerName);   ///这两个函数电子病历提供
			var varCertCode = userCertCode; //cartn.ca_key.GetUniqueID(varCert);
			if((CACertNo||"")!=""){varCert=CACertNo};
			
			//3.保存签名信息记录
			if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
				var ret = InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData, varCert, ModuleMark);
				if (ret != "0") $.messager.alert("警告", "数字签名没成功");
			} else {
				$.messager.alert("警告", "数字签名错误");
			}
		}catch(e){
			$.messager.alert("警告", e.message);
		}
	}
	/// 保存签名
	function InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData, varCert, ModuleMark){ //ExpStr能否传模块名？DHCEM
		var retFlag = dhccl.runServerMethodNormal("web.DHCDocSignVerify","InsertSignBatchSignRecord",itmValData,LgUserID,XmlType, itmHashData,varCertCode,itmSignData,"",varCert)
		return retFlag;
	}
	/// 取医嘱信息串
	function GetOrdItemXml(Oeori, XmlType){
		var OrdItemXml=dhccl.runServerMethodNormal("web.DHCDocSignVerify","GetOEORIItemXML",Oeori,XmlType)
		return OrdItemXml;
	}

$(document).ready(initPage);