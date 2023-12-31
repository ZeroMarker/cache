var operApplication={
    newApp:true,
    editableStatus:"Application",
    selectedPat:null,
    yesNoOptions:[{
        value:"Y",
        text:"是"
    },{
        value:"N",
        text:"否"
    }],
    testOptions:[{
        value:"N",
        text:"未知",
    },{
        value:"-",
        text:"阴性"
    },{
        value:"+",
        text:"阳性"
    }]
};

function initPage(){
    
    initPatListForm();
    setDefaultValue();
    initAppForm(); 
}

/**
 * 初始化患者列表表单
 */
function initPatListForm(){
    if(operApplication.newApp===false) return;
    //科室
    $("#patLoc").combobox({
        valueField: 'RowId',
        textField: 'Description',
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt = 2;
        },
        onLoadSuccess:function(data){
            if(data && data.length>0){
                $("#patLoc").combobox('setValue', session.DeptID);
            }
        }
    });
    
    //病区
    $("#patWard").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindWard";
            param.ArgCnt = 0;
        }
    });

    var columns =[[
        {
            field: 'PAPMINO',
            title: '患者信息',
            width: 250,
            formatter: function(value, row, index) {
                var retArray = [];
                retArray.push("<div class='patlist-item' style='padding-top:10px;'><span>" + row.PAPMIName + "</span>");
                retArray.push("<span>" + value + "</span></div>");
                retArray.push("<div class='patlist-item' style='padding-bottom:10px;'><span>" + row.PAPMISex + "/" + row.Age + "</span>");
                retArray.push("<span>" + row.PAAdmWard + "</span></div>");
                return retArray.join("");
            }
        },
        { field: 'PatientID', title: 'PatientID', width: 55, hidden: true },
        { field: 'EpisodeID', title: 'EpisodeID', width: 80, hidden: true },
        { field: 'PAAdmBed', title: '床位', width: 60, hidden: true },
        { field: 'PAPMIName', title: '姓名', width: 80, hidden: true },
        { field: 'PAPMISex', title: '性别', width: 40, hidden: true },
        { field: 'Age', title: '年龄', width: 60, hidden: true },
        { field: 'PAAdmDepCodeDR', title: '科室', width: 110, hidden: true },
        { field: 'PAAdmWard', title: '病区', width: 130, hidden: true }]];
    
    $("#patientsList").datagrid({
        fit: true,
        title: "患者列表 (<span id='patCount'>共0人</span>)",
        singleSelect: true,
        nowrap: false,
        pagination: true,
        iconCls:'icon-paper',
        pageSize:10,
        headerCls:'panel-header-gray',
        url: ANCSP.DataQuery,
        toolbar: "#searchList",
        fitColumns:true,
        showHeader: false,
        showPageList:false,
        displayMsg:'',
        scrollbarSize:0,
        // rowStyler:function(index,row){
        //     if(index%2===1)
        //     {  
        //         return "background-color:#FFFFCC";
        //     }
        // },
        queryParams: {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindLocDocCurrentAdm",
            ArgCnt: 13
        },
        onBeforeLoad: function(param) {
            var patientNo = $('#patientNo').val();
            var isNum = true;
            var reg = /^[0-9]+.?[0-9]*$/;
            if (!reg.test(patientNo)) { isNum = false; }
            var locId=$("#patLoc").combobox("getValue");
            if(locId===""){
                locId=session.DeptID;
            }
            param.Arg1 = locId;
            param.Arg2 = session.UserID;
            param.Arg3 = "";
            param.Arg4 = "";
            (isNum == false) ? param.Arg5 = "": param.Arg5 = patientNo;
            (!isNum && (patientNo.length > 10)) ? param.Arg6 = "": param.Arg6 = patientNo; //$("#patName").val();
            param.Arg7 = "";
            param.Arg8 = "";
            (locId == "") ? param.Arg9 = "": param.Arg9 = "on";
            param.Arg10 = "";
            param.Arg11 = "on";
            param.Arg12 = $("#patWard").combobox("getValue");
            param.Arg13 = "";
        },
        columns:columns,
        onSelect: function(rowIndex, rowData) {
            EpisodeID = rowData.EpisodeID;
            if (EpisodeID && (EpisodeID != "")) {
                operApplication.selectedPat=rowData;
                selectPatient(rowData);
            }
            $("#patientsList").parent(".datagrid-view").find("tr .patlist-item:last-child").css("color","#6f6f6f");
            $("#patientsList").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] .patlist-item:last-child").css("color","#FFF");
        },
        onUnselect:function(rowIndex,rowData){
            
        },
        onLoadSuccess: function(data) {
            // $("#searchList").find(".searchListTitle").find("span").html(data.total);
            var panel=$(this).datagrid("getPanel");
            $(panel).panel("setTitle","患者列表 (<span id='patCount'>共"+data.total+"人</span>)")
        }
    });
    $("#patientsList").parent(".datagrid-view").find("td").css("border-right","none");
    $("#btnSearch").linkbutton({
        onClick:function(){
            $("#patientsList").datagrid("reload");
        }
    })
    // $("#patientNo").next("span").find(".searchbox-button").click(function(){
    //     $("#patientsList").datagrid("reload");
    // });
}

/**
 * 初始化手术申请表单
 */
function initAppForm(){
    initDiagBox();
    initOperBox();
    initAppFormOptions();
    loadAppFormData();
}

/**
 * 初始化术前诊断数据表格
 */
function initDiagBox(){
    // var diagDescOptions=getDiagnosisOptions();
    var columns=[[
        {field:"DiagID",title:"诊断ID",hidden:true},
        {field:"DiagDesc",title:"诊断描述",width:875}
        // {field:"Operator",title:"<a href='#' id='btnAddDiag' class='hisui-linkbutton' data-options='iconCls:\"icon-add\",plain:true'></a>",
        //  formatter:function(value,row,index){
        //     // if(row.StatusCode!==operApplication.editableStatus) return "";
        //     var htmlArr=[
        //     "<span class='diagEditBtns' id='diagEditBtns"+index+"'><a href='#' class='hisui-linkbutton edit-btns' data-options='iconCls:\"icon-edit\",plain:true' data-rowindex='"+index+"' data-rowid='"+(row.RowId?row.RowId:"")+"'></a></span>",
        //     "<span class='diagSaveBtns' id='diagSaveBtns"+index+"'><a href='#' class='hisui-linkbutton save-btns' data-options='iconCls:\"icon-ok\",plain:true' data-rowindex='"+index+"' data-rowid='"+(row.RowId?row.RowId:"")+"'></a></span>",
        //     "<span class='diagRemoveBtns' id='diagRemoveBtns"+index+"'><a href='#' class='hisui-linkbutton remove-btns' data-options='iconCls:\"icon-remove\",plain:true' data-rowindex='"+index+"' data-rowid='"+(row.RowId?row.RowId:"")+"'></a></span>"
        //     ];
        //     return htmlArr.join("");
        //  }}
    ]];

    $("#preopDiagBox").datagrid({
        width: 912,
        height: 180,
        singleSelect: true,
        rownumbers: false,
        columns:columns,
        toolbar:"#preopDiagTool",
        headerCls:"panel-header-gray",
        onLoadSuccess:function(data){
            initDiagButtons();
        },
        onSelect:function(index,row){
            if(row && row.DiagDesc){
                $("#Diagnosis").combogrid("setValue",row.DiagID);
                $("#Diagnosis").combogrid("setText",row.DiagDesc);
            }
        }
    });

    $("#Diagnosis").combogrid({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindMRCDiagnosis";
            param.Arg1 = param.q?param.q:"";
            param.ArgCnt = 1;
        },
        panelWidth:300,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"Description",title:"名称",width:180},
            {field:"ICDCode",title:"ICD",width:100}
        ]],
        mode: "remote"
    });

    $("#btnAddDiag").linkbutton({
        onClick:function(){
            addDiagnosis();
        }
    });

    $("#btnEditDiag").linkbutton({
        onClick:function(){
            editDiagnosis();
        }
    });

    $("#btnDelDiag").linkbutton({
        onClick:function(){
            removeDiagnosis();
        }
    });
}

function initOperBox(){
    // var operationOpts=getOperationOptions();
    // var operClassOpts=getOperClassOptions();
    // var surgeonDeptOpts=getSurgeonDeptOptions();
    // var surgeonOpts=getSurgeonOptions();
    var columns=[[
        {field:"RowId",title:"ID",hidden:true},
        {field:"Operation",title:"Operation",hidden:true},
        {field:"OperClass",title:"OperClass",hidden:true},
        {field:"Surgeon",title:"Surgeon",hidden:true},
        {field:"Assistant",title:"Assistant",hidden:true},
        {field:"OperationDesc",title:"手术名称",width:240},
        {field:"OperNote",title:"名称备注",width:240},
        {field:"OperClassDesc",title:"分级",width:80},
        // {field:"SurgeonDeptDesc",title:"术者科室",width:120,editor:{type:"combobox",options:surgeonDeptOpts}},
        {field:"SurgeonDesc",title:"主刀",width:100},
        {field:"AssistantDesc",title:"助手",width:160}
        // {field:"Operator",title:"<a href='#' id='btnAddOper' class='hisui-linkbutton' data-options='iconCls:\"icon-add\",plain:true'></a>",
        //  formatter:function(value,row,index){
        //     if(row.StatusCode!==operApplication.editableStatus) return "";
        //     var htmlArr=[
        //     "<span class='operEditBtns' id='operEditBtns"+index+"'><a href='#' class='hisui-linkbutton edit-btns' data-options='iconCls:\"icon-edit\",plain:true' data-rowindex='"+index+"' data-rowid='"+(row.RowId?row.RowId:"")+"'></a></span>",
        //     "<span class='operSaveBtns' id='operSaveBtns"+index+"'><a href='#' class='hisui-linkbutton save-btns' data-options='iconCls:\"icon-save\",plain:true' data-rowindex='"+index+"' data-rowid='"+(row.RowId?row.RowId:"")+"'></a></span>",
        //     "<span class='operRemoveBtns' id='operRemoveBtns"+index+"'><a href='#' class='hisui-linkbutton remove-btns' data-options='iconCls:\"icon-remove\",plain:true' data-rowindex='"+index+"' data-rowid='"+(row.RowId?row.RowId:"")+"'></a></span>"
        //     ];
        //     return htmlArr.join("");
        //  }}
    ]];

    $("#Operation").combogrid({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.Operation;
            param.QueryName = "FindOperation";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = "";
            param.Arg3 = "";
            param.ArgCnt = 3;
        },
        panelWidth:450,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"名称",width:240},
            {field:"OperClassDesc",title:"分级",width:60},
            {field:"ICDCode",title:"ICD",width:120}
        ]],
        mode: "remote",
        onSelect:function(rowIndex,record){
            
        }
    });

    $("#OperClass").combobox({
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindOperClass";
            param.ArgCnt=0;
        }
    });

    $(".sur-careprov").combogrid({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindCareProv";
            param.Arg1=param.q?param.q:"";
            param.Arg2="";
            if(!param.Arg1){
                param.Arg2=session.DeptID;
            }
            param.ArgCnt=2;
        },
        panelWidth:450,
        idField: "ResourceID",
        textField: "Description",
        columns:[[
            {field:"ResourceID",title:"ID",hidden:true},
            {field:"Description",title:"医护姓名",width:240},
            {field:"Location",title:"所在科室",width:200}
        ]],
        mode: "remote",
        onSelect:function(rowIndex,record){

        }   
    });

    $("#operationBox").datagrid({
        width: 912,
        height: 300,
        headerCls:"panel-header-gray",
        singleSelect: true,
        rownumbers: true,
        toolbar: "#operationTool",
        url: ANCSP.DataQuery,
        columns:columns,
        onLoadSuccess:function(data){
            initOperButtons();
        },
        onSelect:function(index,row){
            selectOperation(index,row);
        }
    });

    $("#btnAddOperation").linkbutton({
        onClick:function(){
            addOperation();
        }
    });

    $("#btnEditOperation").linkbutton({
        onClick:function(){
            editOperation();
        }
    });

    $("#btnDelOperation").linkbutton({
        onClick:function(){
            removeOperation();
        }
    });
}

function initAppFormOptions(){
    $("#AppDeptID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindLocationOld";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        editable:false
    });

    $("#AppCareProvID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindCareProvByLoc";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.DeptID;
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        readonly:true
    });

    $("#OperDeptID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindLocationOld";
            param.Arg1=param.q?param.q:"";
            param.Arg2="OP^OUTOP^EMOP";
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        editable:false
    });

    $("#PrevAnaMethod").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.Arg1 = "";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description",
        required: $("#Anaesthesia").combobox("getValue") === "Y" ? true : false
        // multiple: true
    });

    $("#OperDate").datebox({
        readonly:true
    });

    $("#SourceType").combobox({
        valueField:"code",
        textField:"desc",
        editable:false,
        data:[{
            code:"B",
            desc:"择期"
        },{
            code:"E",
            desc:"急诊"
        }],
        onSelect:function(record){
            var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetOperDate",record.code);
            if(ret && ret.result){
                $("#OperDate").datebox("setValue",ret.result);
            }
        }
    });

    $("#ReentryOperation").combobox({
        valueField:"code",
        textField:"desc",
        editable:false,
        data:[{
            code:"Y",
            desc:"是"
        },{
            code:"N",
            desc:"否"
        }]
    });

    $("#Anaesthesia").combobox({
        valueField:"code",
        textField:"desc",
        editable:false,
        data:[{
            code:"Y",
            desc:"是"
        },{
            code:"N",
            desc:"否"
        }]
    });

    $("#SeqType").combobox({
        valueField:"code",
        textField:"desc",
        editable:false,
        data:[{
            code:"N",
            desc:"正常台"
        },{
            code:"C",
            desc:"接台"
        }]
    });

    $("#BodySite").combobox({
        multiple:true,
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindBodySite";
            param.ArgCnt=0;
        }
    });

    $("#OperPosition").combobox({
        multiple:true,
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindOperPosition";
            param.ArgCnt=0;
        }
    });

    $(".oper-require").combobox({
        valueField:"value",
        textField:"text",
        data:operApplication.yesNoOptions
    });

    $(".test-item").combobox({
        valueField:"value",
        textField:"text",
        data:operApplication.testOptions
    });

    $("#BloodType").combobox({
        valueField:"value",
        textField:"text",
        data:[{
            text:"未知",
            value:"N"
        },{
            text:"A型",
            value:"A"
        },{
            text:"B型",
            value:"B"
        },{
            text:"AB型",
            value:"AB"
        },{
            text:"O型",
            value:"O"
        }]
    });

    $("#btnSave").linkbutton({
        onClick:function(){
            saveOperApplication();
        }
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });
}

function loadAppFormData(){
    $("#appForm").form("clear");
    setOperAppData();
    setOperList();
}

function setDefaultValue(){
    // 获取新增手术申请还是修改手术申请
    if (session.OPSID){
        operApplication.newApp=false;
        $("body").layout("remove","west");
        $(".btnList").css({"padding":"0","width":"auto"});
    }else{
        operApplication.newApp=true;
        var selectedPat=$("#patientsList").datagrid("getSelected");
        if(selectedPat){
            setNewAppDefValue();
        }
    }
}

function setNewAppDefValue(){
    // 获取默认手术室
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetDefOperDept",session.DeptID);
    $("#OperDeptID").combobox("setValue",ret);

    // 获取择期手术是否已截止
    ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetOperAppDeadLine");
    if(ret.result==="Y"){
        // 如果已截止，那么手术类型默认为“急诊”
        $("#SourceType").combobox("setValue","E");
    }else{
        $("#SourceType").combobox("setValue","B")
    }

    var sourceType=$("#SourceType").combobox("getValue");
    setOperDate(sourceType);

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

    // 检验项目默认值为未知
    $(".test-item").combobox("setValue","N");
    $("#BloodType").combobox("setValue","N");

    $("#AppUserID").val(session.UserID);

    $("#PlanSeq").numberspinner("setValue",1);

    $("#ReentryOperation").combobox("setValue","N");

    $("#Anaesthesia").combobox("setValue","Y");
}

function setOperAppData(){
    var appDatas=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.OperScheduleList,
        QueryName:"FindOperScheduleList",
        Arg1:"",
        Arg2:"",
        Arg3:"",
        Arg4:session.OPSID,
        ArgCnt:4
    },"json");
    if(appDatas && appDatas.length>0){
        var appData=appDatas[0];
        $("#appForm").form("load",appData);

        //术前诊断
        if(appData.PrevDiagnosis){
            var diagArr=appData.PrevDiagnosis.split(",");
            var diagObjects=[];
            for(var i=0;i<diagArr.length;i++){
                diagObjects.push({
                    DiagID:"",
                    DiagDesc:diagArr[i]
                });
            }
            $("#preopDiagBox").datagrid("loadData",diagObjects);
        }

        // 手术部位
        if(appData.BodySite){
            var bodySiteArr=appData.BodySite.split(",");
            $("#BodySite").combobox("setValues",bodySiteArr);
        }
        // 手术体位
        if(appData.OperPosition){
            var operPosArr=appData.OperPosition.split(",");
            $("#OperPosition").combobox("setValues",operPosArr);
        }
    }
}

function setOperList(){
    var operList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.OperationList,
        QueryName:"FindOperationList",
        Arg1:session.OPSID,
        ArgCnt:1
    },"json");
    if(operList && operList.length>0)
    {
        $("#operationBox").datagrid("loadData",operList);
    }
}

function setOperDate(sourceType){
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetOperDate",sourceType);
    if(ret && ret.result){
        $("#OperDate").datebox("setValue",ret.result);
    }
}

function initDiagButtons(){
    $("span.diagEditBtns .edit-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            editDiagnosis(index);
        }
    });

    $(".diagSaveBtns .save-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            saveDiagnosis(index);
        },
        disabled:true
    });

    $(".diagRemoveBtns .remove-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            removeDiagnosis(index);
        }
    });
}

function addDiagnosis(){
    
    if (operApplication.newApp){
        
        var selectedApp=$("#patientsList").datagrid("getSelected");
        if(!selectedApp){
            $.messager.alert("提示","请先选择手术患者，再进行添加。","warning");
            return;
        }
        
    }
    var diagnosis={
        DiagID:$("#Diagnosis").combogrid("getValue"),
        DiagDesc:$("#Diagnosis").combogrid("getText")
    };
    if(!diagnosis.DiagID && !diagnosis.DiagDesc){
        $.messager.alert("提示","请先选择诊断字典，再添加。","warning");
        return;
    }
    $("#preopDiagBox").datagrid("appendRow",diagnosis);
    $("#Diagnosis").combogrid("clear");
}

function editDiagnosis(index){
    var selectedDiag=$("#preopDiagBox").datagrid("getSelected");
    if(!selectedDiag){
        $.messager.alert("提示","请先选择一条术前诊断记录，再修改。","warning");
        return;
    }
    var selectedIndex=$("#preopDiagBox").datagrid("getRowIndex",selectedDiag);
    var diagnosis={
        DiagID:$("#Diagnosis").combogrid("getValue"),
        DiagDesc:$("#Diagnosis").combogrid("getText")
    };
    if(!diagnosis.DiagID && !diagnosis.DiagDesc){
        $.messager.alert("提示","请先选择诊断字典，再修改。","warning");
        return;
    }
    $("#preopDiagBox").datagrid("updateRow",{
        index:selectedIndex,
        row:diagnosis
    });
}

function removeDiagnosis(index){
    var selectedDiag=$("#preopDiagBox").datagrid("getSelected");
    if(!selectedDiag){
        $.messager.alert("提示","请先选择一条术前诊断，再删除。","warning");
        return;
    }
    var selectedIndex=$("#preopDiagBox").datagrid("getRowIndex",selectedDiag);
    $.messager.confirm("提示","是否删除选择的术前诊断?",function(r){
        if(r){
            if(selectedDiag.RowId){

            }else{
                $("#preopDiagBox").datagrid("deleteRow",selectedIndex);
                $("#Diagnosis").combogrid("clear");
            }
        }
    });
}

function getDiagnosisOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindMRCDiagnosis";
            param.Arg1=param.q?param.q:"";
            param.ArgCnt = 1;
        },
        panelWidth:450,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"诊断描述",width:400}
        ]],
        mode: "remote",
        onSelect:function(rowIndex,record){
            
        }
    }
}

function getOperationOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.Operation;
            param.QueryName = "FindOperation";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = "";
            param.Arg3 = "";
            param.ArgCnt = 3;
        },
        panelWidth:450,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"名称",width:240},
            {field:"OperClassDesc",title:"分级",width:60},
            {field:"ICDCode",title:"ICD",width:120}
        ]],
        mode: "remote",
        onSelect:function(rowIndex,record){
            
        }
    }
}

function getOperClassOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperClass";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    }
}

function getSurgeonDeptOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindLocationOld";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    }
}

function getSurgeonOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindCareProvByLoc";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.DeptID;
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    }
}

function getAssistantOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindCareProvByLoc";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.DeptID;
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    }
}

function initOperButtons(){
    $(".operEditBtns .edit-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            editOperation(index);
        }
    });

    $(".operSaveBtns .save-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            saveOperation(index);
        },
        disabled:true
    });

    $(".operRemoveBtns .remove-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            removeOperation(index);
        }
    });
}

function genOperation(){
    var formData=$("#operationForm").serializeJson();
    //var surAssistant=formData.Assistant1+","+formData.Assistant2+","+formData.Assistant3+","+formData.Assistant4+","+formData.Assistant5;
    var assis1Desc=$("#Assistant1").combogrid("getText"),
        assis2Desc=$("#Assistant2").combogrid("getText"),
        assis3Desc=$("#Assistant3").combogrid("getText"),
        assis4Desc=$("#Assistant4").combogrid("getText"),
        assis5Desc=$("#Assistant5").combogrid("getText");
    var surAssisDesc=assis1Desc;
    if(assis2Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis2Desc;
    }
    if(assis3Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis3Desc;
    }
    if(assis4Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis4Desc;
    }
    if(assis5Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis5Desc;
    }

    var surAssistant=formData.Assistant1;
    if (formData.Assistant2){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant2;
    }
    if (formData.Assistant3){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant3;
    }
    if (formData.Assistant4){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant4;
    }
    if (formData.Assistant5){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant5;
    }

    formData.Assistant=surAssistant;
    formData.AssistantDesc=surAssisDesc;
    formData.OperationDesc=$("#Operation").combogrid("getText");
    formData.OperClassDesc=$("#OperClass").combobox("getText");
    formData.SurgeonDesc=$("#Surgeon").combogrid("getText");

    return formData;
}

function addOperation(){
    if(!$("#operationForm").form("validate")) return;
    var selectedApp=$("#patientsList").datagrid("getSelected");
    if (!selectedApp && operApplication.newApp){
        $.messager.alert("提示","请先选择手术患者，再进行添加。","warning");
        return;
    }
    
    var formData=genOperation();
    formData.RowId="";
    $("#operationBox").datagrid("appendRow",formData); 
    $("#operationForm").form("clear");
}

function editOperation(index){
    var selectedOperation=$("#operationBox").datagrid("getSelected");
    if(!selectedOperation){
        $.messager.alert("提示","请先选择一条手术，再修改。","warning");
        return;
    }
    var selectedIndex=$("#operationBox").datagrid("getRowIndex",selectedOperation);
    var formData=genOperation();
    formData.RowId=selectOperation.RowId;
    $("#operationBox").datagrid("updateRow",{
        index:selectedIndex,
        row:formData
    });
}

function removeOperation(index){
    
    var selectedOperation=$("#operationBox").datagrid("getSelected");
    if(!selectedOperation){
        $.messager.alert("提示","请先选择一条手术，再删除。","warning");
        return;
    }
    var selectedIndex=$("#operationBox").datagrid("getRowIndex",selectedOperation);
    $.messager.confirm("提示","是否删除选择的手术?",function(r){
        if(r){
            if(selectedOperation.RowId){

            }else{
                $("#operationBox").datagrid("deleteRow",selectedIndex);
                $("#operationForm").form("clear");
            }
        }
    });
}

function selectOperation(index,row){
    if(row){
        $("#operationForm").form("load",row);
        $("#Operation").combogrid("setText",row.OperationDesc);
        $("#Surgeon").combogrid("setText",row.SurgeonDesc);
        if(row.Assistant){
            var assisArr=row.Assistant.split(",");
            var assisDescArr=row.AssistantDesc.split(",");
            for(var i=0;i<assisArr.length;i++){
                var assisIndex=i+1;
                $("#Assistant"+assisIndex).combogrid("setValue",assisArr[i]);
                $("#Assistant"+assisIndex).combogrid("setText",assisDescArr[i]);
            }
        }
    }
}

function selectPatient(pat){
    if(pat && pat.EpisodeID){
        var patDataList=dhccl.getDatas(ANCSP.DataQuery,{
            ClassName:CLCLS.BLL.Admission,
            QueryName:"FindPatient",
            Arg1:pat.EpisodeID,
            ArgCnt:1
        },"json");
        if(patDataList && patDataList.length>0){
            var patData=patDataList[0];
            $("#appForm").form("load",patData);
            setDefaultValue();
        }
    }
}

function saveOperApplication(){
    if(!$("#appForm").form("validate")) return;
    var appData=$("#appForm").serializeJson();
    appData.StatusCode="Application";
    appData.ClassName=ANCLS.Model.OperSchedule;
    appData.RowId=session.OPSID?session.OPSID:"";
    appData.BodySite=$("#BodySite").combobox("getValues").join(",");
    appData.OperPosition=$("#OperPosition").combobox("getValues").join(",");

    // 拟施手术
    var operList=$("#operationBox").datagrid("getRows");
    if(!operList || operList.length<=0){
        $.messager.alert("提示","未添加拟施手术，请添加好拟施手术之后，再保存手术申请。","warning");
        return;
    }

    // 术前诊断
    var diagList=$("#preopDiagBox").datagrid("getRows");
    if(!diagList || diagList.length<=0){
        $.messager.alert("提示","未添加术前诊断，请添加好术前诊断之后，再保存手术申请。","warning");
        return;
    }
    var diagInfo=getPreopDiag();
    appData.PrevDiagnosis=diagInfo;

    // 拟施手术
    var dataArr=[];
    dataArr.push(appData);
    for(var i=0;i<operList.length;i++){
        var planOperation=operList[i];
        planOperation.ClassName=ANCLS.Model.PlanOperList;
        dataArr.push(planOperation);
    }

    // 实施手术
    for(var i=0;i<operList.length;i++){
        var planOperation=operList[i];
        var operation={};
        for(var property in planOperation){
            operation[property]=planOperation[property];
        }
        operation.ClassName=ANCLS.Model.OperList;
        dataArr.push(operation);
    }

    var dataPara=dhccl.formatObjects(dataArr);
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"SaveOperApplication",dataPara);
    if(ret.success){
        if(operApplication.newApp){
            $.messager.alert("提示","保存手术申请成功。","info",function(){
                // $("#appForm").form("clear");
                // $("#patientsList").datagrid("clearSelections");
                window.location.reload();
            });
        }else{
            $.messager.confirm("提示","保存手术申请成功，是否关闭页面？。",function(r){
                if(r){
                    //window.location.reload();
                    
                    if(window.parent.closeOperEditDialog){
                        window.parent.closeOperEditDialog();
                    }else{
                        loadAppFormData();
                    }
                }else{
                    loadAppFormData(); 
                }
            });
        }
        
        
    }else{
        $.messager.alert("提示","保存手术申请失败，原因："+ret.result,"error");
    }
}

function getPreopDiag(){
    var diagList=$("#preopDiagBox").datagrid("getRows");
    var ret="";
    if(diagList &&diagList.length>0){
        for(var i=0;i<diagList.length;i++){
            var diag=diagList[i];
            if(ret!==""){
                ret+=",";
            }
            //ret+=diag.DiagID?diag.DiagID:diag.DiagDesc;
            ret+=diag.DiagDesc;
        }
    }

    return ret;
}

$(document).ready(initPage);

