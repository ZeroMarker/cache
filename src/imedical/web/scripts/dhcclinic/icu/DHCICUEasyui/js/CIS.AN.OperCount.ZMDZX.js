function initPage(){
    dhccl.parseDateTimeFormat();
    initOperNurForm();

    operDataManager.initFormData(loadApplicationData);

    initInstrumentsBox();
    initOperBox();
    initOperShiftBox();
    
    initSurgicalKitOptions();
    initOperActions();

    operDataManager.setCheckChange();
    SignTool.loadSignature();

    setOperList();
    
    //initOperRegForm();

    initOperEditPermission();
	
	loadPatTestResult();
}

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

var operCount={
    schedule:null,
    contextMenu:null,
    contextMenuD:null,
    clickColumn:null
};

function initOperRegForm(){
    $("#operRegForm").form("load",operCount.schedule);
    $("#operationForm").form("clear");
}
/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    operCount.schedule=operApplication;
    
}

function initOperNurForm(){
    $("#VPSite,#HemostaticSite,#AdverseReactionsDesc").combobox({
        rowStyle:"checkbox",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            var optsType=$(this).attr("data-optstype");
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindDataOptions";
            param.Arg1=optsType;
            param.ArgCnt=1;
        },
        mode:"remote",
        valueField:"Description",
        textField:"Description",
        multiple:true
    });

    $("#OperPosPrecaution2").checkbox({
        onChecked:function(e,value){
            $("#OperPosPrecautionDesc").val("体位垫");
        },
        onUnchecked:function(e,value){
            $("#OperPosPrecautionDesc").val("");
        }
    });

    $("#PreTransDrugDesc").combobox({
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindDataOptions";
            param.Arg1="PreTransDrug";
            param.ArgCnt=1;
        },
        mode:"remote",
        valueField:"Description",
        textField:"Description"
    });

    $("#ABO").combobox({
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindDataOptions";
            param.Arg1="ABO";
            param.ArgCnt=1;
        },
        mode:"remote",
        valueField:"Description",
        textField:"Description"
    });

    $("#TreatMeasureOpts").combobox({
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindDataOptions";
            param.Arg1="TransBloodTreatMeasure";
            param.ArgCnt=1;
        },
        mode:"remote",
        valueField:"Description",
        textField:"Description",
        onSelect:function(record){
            var treatMeasure=$("#TreatMeasure").val();
            if(treatMeasure){
                var newMeasure=treatMeasure+""+record.Description
                $("#TreatMeasure").val(newMeasure);
            }else{
                $("#TreatMeasure").val(record.Description);
            }
            $("#TreatMeasureOpts").combobox("clear");
        }
    });

    

    $(".NegativePlateDirection").combobox({
        valueField:"value",
        textField:"text",
        data:[{
            value:"左侧",
            text:"左侧"
        },{
            value:"右侧",
            text:"右侧"
        }]
    });
}

function initInstrumentsBox(){
    var columns=[[
        {field:"CheckStatus",title:"选择",checkbox:true},
        {field:"SurgicalMaterial",title:"手术物品ID",hidden:true},
        {field:"MaterialNote",title:"手术物品",width:200},
        {field:"PreopCount",title:"术前清点",width:76,editor:{type:"numberbox"}},
        {field:"OperAddCount",title:"术中加数(数值)",hidden:true},
        {field:"AddCountDesc",title:"术中加数",width:160,editor:{type:"validatebox"}},
        {field:"PreCloseCount",title:"关前清点",width:76,editor:{type:"numberbox"},styler: function (value, row, index) {
            if(!operCountBalance(row,"PreCloseCount")){
                return "background-color:#FFFFCC;";
            }
        }},
        {field:"PostCloseCount",title:"关后清点",width:76,editor:{type:"numberbox"},styler: function (value, row, index) {
            if(!operCountBalance(row,"PostCloseCount")){
                return "background-color:#FFFFCC;";
            }
        }},
        {field:"PostSewCount",title:"缝皮后清点",width:90,editor:{type:"numberbox"},styler: function (value, row, index) {
            if(!operCountBalance(row,"PostSewCount")){
                return "background-color:#FFFFCC;";
            }
        }}
    ]];

    $("#instrumentsBox").datagrid({
        fit: true,
        title:"手术清点记录",
        // border:false,
        headerCls:"panel-header-gray",
        checkOnSelect:false,
        selectOnCheck:false,
        singleSelect: false,
        pagination: true,
        iconCls:"icon-paper",
        url: ANCSP.DataQuery,
        toolbar: "#instrumentsTool",
        columns: columns,
        // rowStyler: function(index, row) {
        //     if(!operCountBalance(row)){
        //         return "background-color:yellow;";
        //     }
        // },
        queryParams: {
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindSurInventory",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        onClickCell: function(index, field, value) {
            var countDatas=$(this).datagrid("getRows");
            if(countDatas && countDatas.length>0){
                var id=$(this).attr("id");
                genCountData(id,field,countDatas);
            }
        },
        onBeginEdit: function(rowIndex, rowData) {
            var editor = $(this).datagrid("getEditor", {
                index: rowIndex,
                field: "AddCountDesc"
            });
            calcAddCount(editor,rowData);
        },
        onLoadSuccess: function(data) {
            $(this).datagrid("clearChecked");
        }
    });

    $("#instrumentsBox").datagrid("enableCellEditing");
	
	$("#ISterilityPackBarCode").keypress(function(e) {
        if (e.keyCode == 13) {
			var ISterilityPackBarCode = $("#ISterilityPackBarCode").val();
            var countBoxId="instrumentsBox";
            var ivType="I";

            var packNo=ISterilityPackBarCode;
            var ifValid = dhccl.runServerMethodNormal(ANCLS.BLL.SterilityPack, "JudgeCSSDValid",packNo, ivType);
            if(ifValid==0)
            {
                $("#CSSPackDialog").dialog("open");
                $("#CSSPackBox").datagrid("reload");  
                var opts=$("#CSSPackDialog").dialog("options"); 
                opts.countBoxId="instrumentsBox";
                opts.comboBoxId=this.id;; 
            }
            else{
                $.messager.alert("提示","扫码失败，原因："+ifValid,"warning");
            }
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
        {field:"OperInfo",title:"手术名称",width:300,formatter:function(value,row,index){
            var retArr=[row.OperationDesc];
            if(row.OperClassDesc){
                retArr.push("("+row.OperClassDesc);
            }
            if(row.BodySiteDesc){
                if (row.OperClassDesc) retArr.push(",")
                retArr.push(row.BodySiteDesc);
            }
            if(row.BladeTypeDesc){
                if(row.OperClassDesc || row.BodySiteDesc) retArr.push(",")
                retArr.push(row.BladeTypeDesc);
            }
            if(row.OperClassDesc || row.BodySiteDesc || row.BladeTypeDesc){
                retArr.push(")");
            }

            return retArr.join("");
        }},
        {field:"OperNote",title:"名称备注",width:180},
        {field:"SurgeonDeptDesc",title:"术者科室",width:100},
        {field:"SurgeonDesc",title:"主刀",width:80},
        {field:"AssistantDesc",title:"助手",width:140},
        {field:"SurgeonExpert",title:"外院专家",width:80}
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
        onSelect:function(rowIndex,record){
            if(!operCount.schedule) return;
            try{
                var EpisodeID=operCount.schedule.EpisodeID;
                var operId=operCount.schedule.ExternalID;
                var userInfo=session.UserID+"^"+session.DeptID+"^"+session.GroupID;
                var checkValidStr=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"CheckOperValid",EpisodeID,operId,userInfo);
                var checkValidDatas=JSON.parse(checkValidStr);
                var checkValidData=checkValidDatas[0];
                if(checkValidData.passFlag!==1){
                    if(checkValidData.manLevel==="C"){
                        $.messager.alert("管制提示","该手术不符合临床知识库管控要求，不能申请！","error");
                        var grid=$(this).combogrid("grid");
                        grid.datagrid("unselectRow",rowIndex);
                        $(this).combogrid("clear");
                    }else if(checkValidData.manLevel==="W"){
                        $.messager.alert("警示","该手术不符合临床知识库管控要求！","warning");
                    }else if(checkValidData.manLevel==="W"){
                        $.messager.alert("提示","该手术不符合临床知识库管控要求！","info");
                    }
                }
                if(!$("#OperClass").combobox("getValue"))
                    $("#OperClass").combobox("setValue",record.OperClass);
                if(!$("#BladeType").combobox("getValue"))
                    $("#BladeType").combobox("setValue",record.BladeType);
                if(!$("#BodySite").combobox("getValue"))
                    $("#BodySite").combobox("setValue",record.BodySite);
                $("#BodySite").combobox("reload");
            }catch(ex){

            }
            
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

    $("#BodySite").combobox({
        valueField:"RowId",
        textField:"Description",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindBodySiteByOper";
            param.Arg1=$("#Operation").combogrid("getValue");
            param.ArgCnt=1;
        }
    });

    $("#BladeType").combobox({
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindBladeType";
            param.ArgCnt=0;
        }
    });

	//手术医师组
	$("#Surgeon").combobox({
		onChange:function(newValue,oldValue){
			var SurgeoGroupList=dhccl.getDatas(ANCSP.DataQuery,{
				ClassName:ANCLS.BLL.ConfigQueries,
				QueryName:"FindSurgeonGroup",
				Arg1:session.DeptID,
				Arg2:newValue,
				ArgCnt:2
			},"json");
			if(SurgeoGroupList.length>0){
				$("#Assistant1").combobox("setValue",SurgeoGroupList[0].Assist1)
				$("#Assistant2").combobox("setValue",SurgeoGroupList[0].Assist2)
				$("#Assistant3").combobox("setValue",SurgeoGroupList[0].Assist3)
			}
			else{
				$("#Assistant1").combobox("setValue","")
				$("#Assistant2").combobox("setValue","")
				$("#Assistant3").combobox("setValue","")
			}
            var grid=$("#Operation").combogrid("grid");
            grid.datagrid("reload");
        }
	});
	
    $(".sur-careprov").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindResourceByHIS";
            param.Arg1=param.q?param.q:"";
            param.Arg2=$("#SurgeonDeptID").combobox("getValue");
            if(!param.Arg2 && operCount && operCount.schedule){
                param.Arg2=operCount.schedule.PatDeptID;
            }
            param.Arg3="Y";
            param.Arg4=session.HospID;
            param.ArgCnt=4;
        },
        // panelWidth:450,
        valueField: "CareProvider",
        textField: "CareProvDesc",
        // columns:[[
        //     {field:"RowId",title:"ID",hidden:true},
        //     {field:"CareProvDesc",title:"医护姓名",width:240},
        //     {field:"DeptDesc",title:"所在科室",width:200}
        // ]],
        mode: "remote"
    });

    $("#SurgeonDeptID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindLocationOld";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT";
            param.Arg3=session.HospID;
            param.ArgCnt=3;
        },
        onChange:function(newValue,oldValue){
            $(".sur-careprov").combobox("reload");
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        editable:false
    });

    $("#operationBox").datagrid({
        title:"实施手术",
        height: 400,
        iconCls:"icon-paper",
        headerCls:"panel-header-gray",
        sytle:{"border-radius":"2px"},
        singleSelect: true,
        rownumbers: true,
        toolbar: "#operationTool",
        url: ANCSP.DataQuery,
        columns:columns,
        onLoadSuccess:function(data){
            //initOperButtons();
        },
        onSelect:function(index,row){
            selectOperation(index,row);
        }
    });

    $("#AnaMethod").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.Arg1 = "";
            param.Arg2="Y";
            param.Arg3="局";
            param.ArgCnt = 3;
        },
        valueField: "RowId",
        textField: "Description",
        mode:"remote"
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

function addOperation(){
    if(!$("#operationForm").form("validate")) return;
    //var selectedApp=$("#patientsList").datagrid("getSelected");
    //if (!selectedApp && operApplication.newApp){
        //$.messager.alert("提示","请先选择手术患者，再进行添加。","warning");
        //return;
    //}
	var Operation = $("#Operation").combogrid("grid").datagrid("getSelected");
	if (Operation == null || Operation == undefined){
        $.messager.alert("提示","请选择手术名称，不允许手写填入。","warning");
        return;
    }
	if($("#Operation").combogrid("getValue")==""){
        $.messager.alert("提示","请先选择手术名称，再进行添加。","warning");
        return;
	}
    if($("#OperClass").combobox("getValue")==""){
        $.messager.alert("提示","请先选择手术分级，再进行添加。","warning");
        return;
    }
    if($("#BodySite").combobox("getValue")==""){
        $.messager.alert("提示","请先选择手术部位，再进行添加。","warning");
        return;
    }
    if($("#BladeType").combobox("getValue")==""){
        $.messager.alert("提示","请先选择切口类型，再进行添加。","warning");
        return;
	}
	if($("#Surgeon").combogrid("getValue")==""){
        $.messager.alert("提示","请先选择主刀医生，再进行添加。","warning");
        return;
	}
    var formData=genOperation();
    formData.RowId="";
    $("#operationBox").datagrid("appendRow",formData); 
    $("#operationForm").form("clear");
    setOperFormDefaultVal();
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
    $("#operationForm").form("clear");
    setOperFormDefaultVal();
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
			$("#operationBox").datagrid("deleteRow",selectedIndex);
            $("#operationForm").form("clear");
            setOperFormDefaultVal();
        }
    });
}

function genOperation(){
    var formData=$("#operationForm").serializeJson();
    //var surAssistant=formData.Assistant1+","+formData.Assistant2+","+formData.Assistant3+","+formData.Assistant4+","+formData.Assistant5;
    var assis1Desc=$("#Assistant1").combobox("getText"),
        assis2Desc=$("#Assistant2").combobox("getText"),
        assis3Desc=$("#Assistant3").combobox("getText");
        // assis4Desc=$("#Assistant4").combogrid("getText"),
        // assis5Desc=$("#Assistant5").combogrid("getText");
    var surAssisDesc=assis1Desc;
    if(assis2Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis2Desc;
    }
    if(assis3Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis3Desc;
    }
    // if(assis4Desc){
    //     if(surAssisDesc) surAssisDesc+=",";
    //     surAssisDesc+=assis4Desc;
    // }
    // if(assis5Desc){
    //     if(surAssisDesc) surAssisDesc+=",";
    //     surAssisDesc+=assis5Desc;
    // }

    var surAssistant=formData.Assistant1;
    if (formData.Assistant2){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant2;
    }
    if (formData.Assistant3){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant3;
    }
    // if (formData.Assistant4){
    //     if(surAssistant) surAssistant+=",";
    //     surAssistant+=formData.Assistant4;
    // }
    // if (formData.Assistant5){
    //     if(surAssistant) surAssistant+=",";
    //     surAssistant+=formData.Assistant5;
    // }

    formData.Assistant=surAssistant;
    formData.AssistantDesc=surAssisDesc;
    formData.OperationDesc=$("#Operation").combogrid("getText");
    formData.OperClassDesc=$("#OperClass").combobox("getText");
    formData.SurgeonDesc=$("#Surgeon").combobox("getText");
    formData.BodySiteDesc=$("#BodySite").combobox("getText");
    formData.BladeTypeDesc=$("#BladeType").combobox("getText");
    formData.SurgeonDeptDesc=$("#SurgeonDeptID").combobox("getText");
    return formData;
}

function setOperFormDefaultVal(){
    if(operCount && operCount.schedule){
        $("#SurgeonDeptID").combobox("setValue",operCount.schedule.PatDeptID);
    }
}

function initOperShiftBox(){
	var careprovOptions=getcareprovOptions();
    var columns=[[
        {field:"ShiftCareProvID",title:"交班护士",width:120,editor:{type:"combobox",options:careprovOptions},formatter:function(value,row,index){
            return row.ShiftCareProvDesc;
		}},
        {field:"ReliefCareProvID",title:"接班护士",width:120,editor:{type:"combobox",options:careprovOptions},formatter:function(value,row,index){
            return row.ReliefCareProvDesc;
		}},
        {field:"ShiftDT",title:"交接时间",width:200,editor:{type:"datetimebox"},formatter:function(value,row,index){
            return row.ShiftDT;
		}},
    ]];
    $("#operShiftBox").datagrid({
        title:"护士交接班",
        height: 300,
        iconCls:"icon-paper",
        headerCls:"panel-header-gray",
        singleSelect: true,
        rownumbers: true,
        toolbar: "#operShiftTool",
        url: ANCSP.DataQuery,
        columns:columns,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.DataQueries;
            param.QueryName="FindOperShift";
            param.Arg1=session.OPSID;
            param.Arg2=session.DeptID;
            param.Arg3="";
            param.ArgCnt=3;
        },
		onBeforeEdit:function(rowIndex,rowData){
			operApplication.editIndex=rowIndex;
			operApplication.firstEdit=true;
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			operApplication.firstEdit=false;
		}
    });

	//手术间 20191231 YuanLin
	$("#OperRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindOperRoom";
            param.Arg1 = "";
            param.Arg2="R";
            param.ArgCnt = 2;
        }
    });

    $("#Anesthesiologist").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.MethodService,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.OperApplication;
            param.MethodName = "GetAnaDoctors";
            param.Arg1 = session.OPSID;
            param.ArgCnt = 1;
        }
    });

    $("#TheatreOutTransLoc").combobox({
        valueField: "Code",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataOptions";
            param.Arg1 = "TheatreOutTransLoc";
            param.ArgCnt = 1;
        },
        mode:"remote"
    });
	
	$("#operShiftBox").datagrid("enableCellEditing");
	
	$("#btnAddShift").linkbutton({
        onClick:function(){
            addOperShift();
        }
    });

    $("#btnEditShift").linkbutton({
        onClick:function(){
            editOperShift();
        }
    });

    $("#btnDelShift").linkbutton({
        onClick:function(){
            removeOperShift();
        }
    });
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
                $("#Assistant"+assisIndex).combobox("setValue",assisArr[i]);
            }
        }
    }
}

/**
 * 初始化手术包和手术物品可选项。
 */
function initSurgicalKitOptions(){
    $("#ISurgicalKit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalKits";
            param.Arg1 = "N";
            param.Arg2 = "Y";
            param.Arg3=param.q?param.q:"";
            param.ArgCnt = 3;
        },
        mode: "remote",
        onSelect:function(record){
            var id=$(this).attr("id");
            selectedSurgicalKit(id,"手术包",record,"instrumentsBox");
        }
    });

    $("#SurgicalKitBox").datagrid({
        fit: true,
        singleSelect: false,
        checkOnSelect:false,
        selectOnCheck:false,
        rownumbers: true,
        headerCls:"panel-header-gray",
        bodyCls:"panel-header-gray",
        // style:{"border-color":"#333"},
        url: ANCSP.DataQuery,
        toolbar: "",
        columns: [[{
                    field: "CheckStatus",
                    title: "选择",
                    width: 60,
                    checkbox: true
                },{
                    field: "SurgicalMaterial",
                    title: "SurgicalMaterial",
                    width: 100,
                    hidden: true
                },{
                    field: "SurgicalMaterialDesc",
                    title: "项目名称",
                    width: 120
                },{
                    field: "DefaultQty",
                    title: "数量",
                    width: 80
                }]],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurKitMaterial";
            var surKitId = $("#ISurgicalKit").combobox("getValue");
            param.Arg1 = surKitId;
            param.ArgCnt = 1;
        },
        onLoadSuccess:function(data){
            $(this).datagrid("checkAll");
        }
    });
	
	$("#CSSPackBox").datagrid({
        fit: true,
        singleSelect: false,
        checkOnSelect:false,
        selectOnCheck:false,
        rownumbers: true,
        headerCls:"panel-header-gray",
        bodyCls:"panel-header-gray",
        // style:{"border-color":"#333"},
        url: ANCSP.DataQuery,
        toolbar: "",
        columns: [[{
                    field: "CheckStatus",
                    title: "选择",
                    width: 60,
                    checkbox: true
                },{
                    field: "SurgicalMaterial",
                    title: "SurgicalMaterial",
                    width: 100,
                    hidden: true
                },{
                    field: "SurgicalMaterialDesc",
                    title: "项目名称",
                    width: 120
                },{
                    field: "DefaultQty",
                    title: "数量",
                    width: 80
                },{
                    field: "packNo",
                    title: "包号",
                    width: 80,
					hidden: true
                },{
                    field: "packName",
                    title: "包名",
                    width: 200
                },{
                    field: "ItemId",
                    title: "项目Id",
                    width: 200,
					hidden: true
                }]],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.SterilityPack;
            param.QueryName = "FindCSSDItemByPackNo";
            var ISterilityPackBarCode = $("#ISterilityPackBarCode").val();
            var DSterilityPackBarCode = $("#DSterilityPackBarCode").val();
            param.Arg1 = (ISterilityPackBarCode=="")?DSterilityPackBarCode:ISterilityPackBarCode;
            param.ArgCnt = 1;
        },
        onLoadSuccess:function(data){
            $(this).datagrid("checkAll");
        }
    });

    $("#ISurgicalItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalMaterials";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        mode: "remote",
        onSelect: function(record) {
            var id=$(this).attr("id");
            addSurgicalItem("instrumentsBox",id,record,"I");
        }
    });

    $("#btnAddISurgicalItem").linkbutton({
        onClick:function(){
            var id=$(this).attr("id");
            var itemDesc=$("#ISurgicalItem").combobox("getText");
            if(!itemDesc) return;
            var record={
                RowId:"",
                Description:itemDesc,
                AddCountDesc:"",
                PreopCount:1,
                PreCloseCount:"",
                PostCloseCount:"",
                PostSewCount:""
            }
            addSurgicalItem("instrumentsBox","ISurgicalItem",record,"I");
        }
    });

    $("#btnDelISurgicalItem").linkbutton({
        onClick:function(){
            var buttonId=$(this).attr("id");
            var boxId="instrumentsBox";
            var boxSelector="#"+boxId;
            var checkedRows=$(boxSelector).datagrid("getChecked");
            if(checkedRows && checkedRows.length>0){
                $.messager.confirm("确认", "是否删除勾选清点记录？", function(result) {
                    if (result) {
                        delCountRecord(boxId,checkedRows);
                    }
                });
            }else{
                $.messager.alert("提示","请先勾选需要删除的清点记录，再进行操作。","warning");
            }
        }
    });

    $("#btnConfirmKit").linkbutton({
        onClick:function(){
            var opts=$("#surKitDialog").dialog("options");
            var countBoxId=opts.countBoxId;
            var comboBoxId=opts.comboBoxId;
            var kitItems=$("#SurgicalKitBox").datagrid("getChecked");
            if (kitItems && kitItems.length>0 && countBoxId){
                for (var i = 0; i < kitItems.length; i++) {
                    const kitItem = kitItems[i];
                    var countItem=existsSurgicalItem(countBoxId,kitItem.SurgicalMaterial);
                    if(countItem.existence){
                        var addCountDesc=countItem.rowData.AddCountDesc?countItem.rowData.AddCountDesc:"";
                        countItem.rowData.AddCountDesc=addCountDesc+(addCountDesc?"+":"")+kitItem.DefaultQty;
                        countItem.rowData.OperAddCount=calExp(countItem.rowData.AddCountDesc);
                        $("#"+countBoxId).datagrid("refreshRow",countItem.rowIndex);
                    }else{
                        var ivType="I";
                        if(countBoxId==="dressingsBox"){
                            ivType="D";
                        }
                        $("#"+countBoxId).datagrid("appendRow", {
                            SurgicalMaterial: kitItem.SurgicalMaterial,
                            SurgicalMaterialDesc: kitItem.SurgicalMaterialDesc,
                            MaterialNote: kitItem.SurgicalMaterialDesc,
                            PreopCount: (kitItem.DefaultQty) ? kitItem.DefaultQty : 1,
                            AddCountDesc:"",
                            PreCloseCount:"",
                            PostCloseCount:"",
                            PostSewCount:"",
                            InventoryType:ivType
                        });
                    }

                }
                $("#surKitDialog").dialog("close");
                $("#"+comboBoxId).combobox("clear");
            }
        }
    });
	
	$("#btnConfirmCSSPack").linkbutton({
        onClick:function(){
            var opts=$("#CSSPackDialog").dialog("options");
            var countBoxId=opts.countBoxId;
            var comboBoxId=opts.comboBoxId;
			var savePackNo=[];
			var saveSterilityPack=[];
            var kitItems=$("#CSSPackBox").datagrid("getChecked");
            if (kitItems && kitItems.length>0 && countBoxId){
                for (var i = 0; i < kitItems.length; i++) {
                    const kitItem = kitItems[i];
                    var countItem=existsSurgicalItem(countBoxId,kitItem.SurgicalMaterial,kitItem.SurgicalMaterialDesc);
                    
					if(i==1)
					{
						var packInfo={
							RecordSheet:session.RecordSheetID,
							Description:kitItem.packName,
							BarCode:kitItem.packNo,
							ClassName:ANCLS.Model.SterilityPack
						}
						savePackNo.push(packInfo);
					}
					
					var SterilityPackInfo={
							ItemCode:kitItem.ItemId,
							ItemDesc:kitItem.SurgicalMaterialDesc,
							Qty:kitItem.DefaultQty,
							ClassName:ANCLS.Model.SterilityItem
						}
					saveSterilityPack.push(SterilityPackInfo);
                }
                $("#CSSPackDialog").dialog("close");
                $("#"+comboBoxId).val("");
				
            }
            var saveCSSDRet=saveCSSDPackDatas(savePackNo,saveSterilityPack);
            if(saveCSSDRet.success){
                if (kitItems && kitItems.length>0 && countBoxId){
                    for (var i = 0; i < kitItems.length; i++) {
                        const kitItem = kitItems[i];
                        var countItem=existsSurgicalItem(countBoxId,kitItem.SurgicalMaterial,kitItem.SurgicalMaterialDesc);
                        if(countItem.exists){
                            var addCountDesc=countItem.rowData.AddCountDesc?countItem.rowData.AddCountDesc:"";
                            countItem.rowData.AddCountDesc=addCountDesc+(addCountDesc?"+":"")+kitItem.DefaultQty;
                            countItem.rowData.OperAddCount=calExp(countItem.rowData.AddCountDesc);
                            $("#"+countBoxId).datagrid("refreshRow",countItem.rowIndex);
                        }else{
                            var ivType="I";
                            if(countBoxId==="dressingsBox"){
                                ivType="D";
                            }
                            $("#"+countBoxId).datagrid("appendRow", {
                                SurgicalMaterial: kitItem.SurgicalMaterial,
                                SurgicalMaterialDesc: kitItem.SurgicalMaterialDesc,
                                MaterialNote: kitItem.SurgicalMaterialDesc,
                                PreopCount: (kitItem.DefaultQty) ? kitItem.DefaultQty : 1,
                                AddCountDesc:"",
                                PreCloseCount:"",
                                PostCloseCount:"",
                                PostSewCount:"",
                                InventoryType:ivType
                            });
                        }
                    }
                }
                saveCountDatas();
                $.messager.alert("提示","扫码成功","success");
                }
            else{
                $.messager.alert("提示","数据回传失败。"+saveCSSDRet.result,"warning");
            }
			
        }
    });

    $("#btnExitKit").linkbutton({
        onClick:function(){
            $("#surKitDialog").dialog("close");
            var opts=$("#surKitDialog").dialog("options");
            // var countBoxId=opts.countBoxId;
            var comboBoxId=opts.comboBoxId;
            $("#"+comboBoxId).combobox("clear");
        }
    });
	
	$("#btnExitKit1").linkbutton({
        onClick:function(){
            $("#CSSPackDialog").dialog("close");
            var opts=$("#CSSPackDialog").dialog("options");
            // var countBoxId=opts.countBoxId;
            var comboBoxId=opts.comboBoxId;
            $("#"+comboBoxId).combobox("clear");
        }
    });
}

/**
 * 初始化操作功能按钮
 */
function initOperActions(){
    $('#btnSave').linkbutton({
        onClick:function(){
            saveCountDatas();
            operDataManager.saveOperDatas();
            //saveOperRegister();
        }
    });

    $('#btnRefresh').linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });

    $('#btnPrint').linkbutton({
        onClick:function(){
            $.get("CIS.AN.OperCountPrint.ZMDZX.csp?opsId="+session.OPSID,function(ret){
                var jqueryObj=$("<div></div>").append(ret);
                var operDatas = operDataManager.getOperDatas();
                var signList=SignTool.loadSignature();
                var signCodeArr=["CircualNurseSign","PreopScrubNurseSign","PreCloseScrubNurseSign","PostCloseScrubNurseSign","PostSewScrubNurseSign","PreopCirNurseSign","PreCloseCirNurseSign","PostCloseCirNurseSign","PostSewCirNurseSign"];
                var relatedData=SignTool.getSignature(signList,signCodeArr);
                jqueryObj.find("#CircualNurseSign").attr("value",relatedData.CircualNurseSign?relatedData.CircualNurseSign.FullName:"/");

                var operDate=new Date(operCount.schedule.OperDate);
                operCount.schedule.OperDateYear=operDate.getFullYear();
                operCount.schedule.OperDateMonth=operDate.getMonth()+1;
                operCount.schedule.OperDateDay=operDate.getDate();
                for (var key in operCount.schedule) {
                    if (operCount.schedule.hasOwnProperty(key)) {
                        const value = operCount.schedule[key];
                        //jqueryObj.find("#"+key).text(value);
                        jqueryObj.find("#"+key).attr("value",value);
                    }
                }

                for (var i = 0; i < operDatas.length; i++) {
                    const operData = operDatas[i];
                    var dataValue=operData.DataValue;
                    if(!dataValue) dataValue="/";
                    jqueryObj.find("#"+operData.DataItem).text(dataValue);
                    jqueryObj.find("#"+operData.DataItem).attr("value",dataValue);
                    jqueryObj.find("[data-formitem='"+operData.DataItem+"']").each(function(index,item){
                        var label=$(item).attr("label");
                        if((","+operData.DataValue+",").indexOf(label)>=0){
                            $(item).attr("checked","checked");
                        }
                    });
                }

                var countDatas=$("#instrumentsBox").datagrid("getRows");
                var rowCount=19;
                var htmlArr=[];
                for (var i = 0; i < rowCount; i++) {
                    var firstData=null,secondData=null;
                    if(countDatas.length>i){
                        firstData=countDatas[i];
                    }
                    if(countDatas.length>(rowCount+i)){
                        secondData=countDatas[rowCount+i];
                    }
                    htmlArr.push(
                        "<tr style='height:18pt'>",
                        "<td style='text-align:center'>"+(firstData?(firstData.MaterialNote || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(firstData?(firstData.PreopCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(firstData?(firstData.OperAddCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(firstData?(firstData.PreCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(firstData?(firstData.PostCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(firstData?(firstData.PostSewCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(secondData?(secondData.MaterialNote || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(secondData?(secondData.PreopCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(secondData?(secondData.OperAddCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(secondData?(secondData.PreCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(secondData?(secondData.PostCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(secondData?(secondData.PostSewCount || "/"):"/")+"</td>",
                        "</tr>");
                }
                var countData=null,displayCount=2*rowCount;
                if(countDatas.length>displayCount){
                    countData=countDatas[displayCount];
                    displayCount+=1;
                }
                htmlArr.push(
                    "<tr style='height:18pt'>",
                    "<td style='text-align:center'></td>",
                    "<td style='text-align:center' colspan='2'>手术开始前</td>",
                    "<td style='text-align:center'>关前<br>清点</td>",
                    "<td style='text-align:center'>关后<br>清点</td>",
                    "<td style='text-align:center'>缝皮后<br>清点</td>",
                    "<td style='text-align:center'>"+(countData?(countData.MaterialNote || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PreopCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.OperAddCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PreCloseCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PostCloseCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PostSewCount || "/"):"/")+"</td>",
                    "</tr>");
                if(countDatas.length>displayCount){
                    countData=countDatas[displayCount];
                    displayCount+=1;
                }

                
                htmlArr.push(
                    "<tr style='height:18pt'>",
                    "<td style='text-align:center'>器械护士</td>",
                    "<td style='text-align:center' colspan='2'>"+(relatedData.PreopScrubNurseSign?relatedData.PreopScrubNurseSign.SignUserName:"/")+"</td>",
                    "<td style='text-align:center'>"+(relatedData.PreCloseScrubNurseSign?relatedData.PreCloseScrubNurseSign.SignUserName:"/")+"</td>",
                    "<td style='text-align:center'>"+(relatedData.PostCloseScrubNurseSign?relatedData.PostCloseScrubNurseSign.SignUserName:"/")+"</td>",
                    "<td style='text-align:center'>"+(relatedData.PostSewScrubNurseSign?relatedData.PostSewScrubNurseSign.SignUserName:"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.MaterialNote || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PreopCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.OperAddCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PreCloseCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PostCloseCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PostSewCount || "/"):"/")+"</td>",
                    "</tr>");
                if(countDatas.length>displayCount){
                    countData=countDatas[displayCount];
                    displayCount+=1;
                }
                htmlArr.push(
                    "<tr style='height:18pt'>",
                    "<td style='text-align:center'>巡回护士</td>",
                    "<td style='text-align:center' colspan='2'>"+(relatedData.PreopCirNurseSign?relatedData.PreopCirNurseSign.SignUserName:"/")+"</td>",
                    "<td style='text-align:center'>"+(relatedData.PreCloseCirNurseSign?relatedData.PreCloseCirNurseSign.SignUserName:"/")+"</td>",
                    "<td style='text-align:center'>"+(relatedData.PostCloseCirNurseSign?relatedData.PostCloseCirNurseSign.SignUserName:"/")+"</td>",
                    "<td style='text-align:center'>"+(relatedData.PostSewCirNurseSign?relatedData.PostSewCirNurseSign.SignUserName:"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.MaterialNote || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PreopCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.OperAddCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PreCloseCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PostCloseCount || "/"):"/")+"</td>",
                    "<td style='text-align:center'>"+(countData?(countData.PostSewCount || "/"):"/")+"</td>",
                    "</tr>");
                var noteData=getOperDataByCode("OperCountNote");
                htmlArr.push("<tr style='height:30pt;text-align:center'><td>备注</td><td colspan='11' style='text-align:left'>"+(noteData?noteData.DataValue:"")+"</td>");
                jqueryObj.find("#countTable").append(htmlArr.join(""));
                var firstPage="<head>"+jqueryObj.find("#head").html()+"</head><body>"+jqueryObj.find("#OperCountRecord").html()+"</body>";
                var secondPage="<head>"+jqueryObj.find("#head").html()+"</head><body>"+jqueryObj.find("#OperNurRecord").html()+"</body>";
                printMessage(firstPage,secondPage);

                function getOperDataByCode(itemCode){
                    var retData=null;

                    if(operDatas && operDatas.length>0){
                        for (var i = 0; i < operDatas.length; i++) {
                            const operData = operDatas[i];
                            if(operData.DataItem===itemCode){
                                retData=operData;
                            }
                        }
                    }
                    return retData;
                }
            });
            //printDocument();
        }
    });
}

/**
 * 术中加数编辑框文本变化，重新计算术中加数。
 */
function calcAddCount(editor,rowData){
    if (editor && editor.target) {
        $(editor.target).change(function(e) {
            var addCountStr = $(this).val();
            var operAddCount = 0;
            if (addCountStr) {
                var addCountArr = addCountStr.split("+");       // 用户在术中加数编辑框中输入的文本必须是以+拼接数字字符串，如：1+1+2+4 表示术中加了4次器械，第1次加了1把，第2次加了1把，第3次加了2把，第4次加了4把。
                for (var index = 0; index < addCountArr.length; index++) {
                    var element = Number(addCountArr[index]);
                    if (!isNaN(element)) {
                        operAddCount += element;
                    }
                }
                rowData.OperAddCount = operAddCount;
            }
        });
    }
}

/**
 * 判断某一器械各阶段的数量是否一致，即：(术前清点数+术中加数)=关前清点数/关后清点数/缝皮后清点数
 * @param {object} row 器械清点记录行数据对象
 */
function operCountBalance(row,field){
    var preopCount=isNaN(row.PreopCount)?0:Number(row.PreopCount),      // 术前清点数存在用户未填写数值的情况，需要判断值是否为数字。
        operAddCount=isNaN(row.OperAddCount)?0:Number(row.OperAddCount),
        fieldCount=isNaN(row[field])?0:Number(row[field]),
        preopTotalCount=preopCount+operAddCount;
    // 如果(术前清点数+术中加数)≠关前清点数或关后清点数或缝皮后清点数
    if (preopTotalCount!==fieldCount){
        return false;
    }
    return true;
}

function selectedSurgicalKit(id,title,surgicalKit,countBoxId){
    $("#surKitDialog").dialog("open");
    var opts=$("#surKitDialog").dialog("options");
    opts.countBoxId=countBoxId;
    opts.comboBoxId=id;
    // $("#surKitDialog").dialog({
    //     countBoxId:countBoxId,
    //     comboBoxId:id
    // });
    $("#SurgicalKitBox").datagrid("reload");
    var surKitDesc = $("#"+id).combobox("getText");
    $("#surKitDialog").dialog("setTitle", title+"-" + surKitDesc);
    var comboBoxId=opts.comboBoxId;
    $("#"+comboBoxId).combobox("clear");
}

/**
 * 添加手术物品
 * @param {String} boxId 清点记录表格ID
 * @param {object} surgicalItem 手术物品json对象
 */
function addSurgicalItem(boxId,comboId,surgicalItem,ivType){
    var itemDesc=surgicalItem.RowId;
    if(!itemDesc){
        itemDesc=surgicalItem.Description;
    }
    var result=existsSurgicalItem(boxId,itemDesc);
    if(result.existence){
        $.messager.confirm("提示","手术清点列表已存在"+result.rowData.MaterialNote+"，确认之后将术中加数加1？",function(r){
			if(r)
			{
				var addCountDesc=result.rowData.AddCountDesc?result.rowData.AddCountDesc:"";
				result.rowData.AddCountDesc=addCountDesc+(addCountDesc?"+":"")+"1";
				result.rowData.OperAddCount=calExp(result.rowData.AddCountDesc);
				$("#"+boxId).datagrid("refreshRow",result.rowIndex);
				//$("#"+boxId).datagrid("selectRow",result.rowIndex);
			}
        });
    }else{
        $.messager.confirm("提示", "是否添加“" + surgicalItem.Description + "”到清点列表？", function(r) {
            if (r) {
                $("#"+boxId).datagrid("appendRow", {
                    SurgicalMaterial: surgicalItem.RowId,
                    SurgicalMaterialDesc: surgicalItem.Description,
                    MaterialNote: surgicalItem.Description,
                    PreopCount: (surgicalItem.PreopCount ? surgicalItem.PreopCount : 1),
                    AddCountDesc: (surgicalItem.AddCountDesc ? surgicalItem.AddCountDesc : ""),
                    PreCloseCount: (surgicalItem.PreCloseCount ? surgicalItem.PreCloseCount : ""),
                    PostCloseCount: (surgicalItem.PostCloseCount ? surgicalItem.PostCloseCount : ""),
                    PostSewCount: (surgicalItem.PostSewCount ? surgicalItem.PostSewCount : ""),
                    BarCode: "",
                    InventoryType:ivType
                });
                $("#"+comboId).combobox("clear");
            }
        });
    }
}

/**
 * 判断清点记录表格存在手术物品的清点记录。
 * @param {string} boxId 清点记录表格ID
 * @param {string} surgicalItem 手术物品RowId或名称
 */
function existsSurgicalItem(boxId,surgicalItem){
    var result={
        existence:false,
        rowIndex:-1,
        rowData:null
    };
    var countRows=$("#"+boxId).datagrid("getRows");
    if(countRows && countRows.length>0){
        for(var countIndex=0;countIndex<countRows.length;countIndex++){
            var countRow=countRows[countIndex];
            if(countRow.SurgicalMaterial===surgicalItem || countRow.MaterialNote===surgicalItem){
                result.existence=true;
                result.rowIndex=countIndex;
                result.rowData=countRow;
                break;
            }
        }
    }
    return result;
}

/**
 * 保存无菌包信息
 */
function saveCSSDPackDatas(savePackNo,saveSterilityPack){
    
    if(savePackNo.length==0)
    {
        return "数据为空，不能回传";
    }
    var savePackNojsonData = dhccl.formatObjects(savePackNo);
	var saveSterilityPackjsonData = dhccl.formatObjects(saveSterilityPack);

	operDataManager.reloadPatInfo(loadApplicationData);
	var operInfo = [];
	var PatInfo={
				OPAID:operCount.schedule.OPAID,
				PatName:operCount.schedule.PatName,
				PatientID:operCount.schedule.EpisodeID,
				AppCareProvID:operCount.schedule.AppCareProvID,
				ArrOperRoom:operCount.schedule.ArrOperRoom,
				ScrubNurse:operCount.schedule.ScrubNurse,
				CircualNurse:operCount.schedule.CircualNurse,
				OperDesc:operCount.schedule.OperDesc
				}
	operInfo.push(PatInfo);
	var operInfoData = dhccl.formatObjects(operInfo);
	var saveSign = dhccl.runServerMethod(ANCLS.BLL.SterilityPack, "SaveSterilityPack",savePackNojsonData, saveSterilityPackjsonData,operInfoData);
    return saveSign;
}

/**
 * 批量删除清点记录
 * @param {String} boxId 表格ID
 * @param {Array} countDatas 需要删除清点记录数组
 */
function delCountRecord(boxId,countDatas){
    var saveDatas=[],delDatas=[];
    for (var i = 0; i < countDatas.length; i++) {
        const element = countDatas[i];
        var rowIndex=$("#"+boxId).datagrid("getRowIndex",element);
        var dto={
            ClassName:ANCLS.Model.SurInventory,
            RowId:element.RowId
        };
        var delObj={
            RowIndex:rowIndex,
            RowData:element
        }
        if(dto.RowId){
            saveDatas.push(dto);
        }
        delDatas.push(delObj);
    }
    if(saveDatas.length>0){
        var jsonStr=dhccl.formatObjects(saveDatas);
        var delResult=dhccl.removeDatas(jsonStr);
        if(delResult.indexOf("S^")===0){
            for (var i = 0; i < delDatas.length; i++) {
                const element = delDatas[i];
                var rowIndex=$("#"+boxId).datagrid("getRowIndex",element.RowData);
                $("#"+boxId).datagrid("deleteRow",rowIndex);
            }
            $("#"+boxId).datagrid("clearChecked");
        }else{
            $.messager.alert("提示","删除失败，原因："+delResult,"error");
        }
    }else{
        for (var i = 0; i < delDatas.length; i++) {
            const element = delDatas[i];
            var rowIndex=$("#"+boxId).datagrid("getRowIndex",element.RowData);
            $("#"+boxId).datagrid("deleteRow",rowIndex);
        }
        $("#"+boxId).datagrid("clearChecked");
    }
    
}

/**
 * 用户点击单元格时，自动计算并生成清点记录数据。
 * @param {String} boxId 表格ID
 * @param {Array} countDatas 清点记录数组
 */
function genCountData(boxId,clickField,countDatas){
    var genFields=['PreCloseCount','PostCloseCount','PostSewCount'];
    if (genFields.indexOf(clickField)<0) return;    // 只有关前清点、关后清点和缝皮后清点数据自动生成
    for (var i = 0; i < countDatas.length; i++) {
        const element = countDatas[i];
        var curCount= parseFloat(element[clickField]);
        var preopCount=parseFloat(element['PreopCount']);
        preopCount=!isNaN(preopCount)?preopCount:0;
        var operAddCount=parseFloat(element['OperAddCount']);
        operAddCount=!isNaN(operAddCount)?operAddCount:0;
        if (curCount===(preopCount+operAddCount)) continue;
        element[clickField]=preopCount+operAddCount;
        $('#'+boxId).datagrid('updateRow',{
            index:i,
            data:element
        });
    }
}

/**
 * 结束表格中所有单元格的编辑状态
 * @param {String} boxId 表格ID
 */
function endEditDataGrid(boxId){
    var rows=$('#'+boxId).datagrid('getRows');
    if(rows && rows.length>0){
        for (var i = 0; i < rows.length; i++) {
            const element = rows[i];
            $('#'+boxId).datagrid('endEdit',i);
        }
    }
}

/**
 * 保存清点记录数据
 * @param {String} boxId 表格ID
 */
function saveCountDatas(){
    var boxIdList=['instrumentsBox'];
    var saveDatas=[];
    for (var i = 0; i < boxIdList.length; i++) {
        const boxId = boxIdList[i];
        var countDatas=getCountDatas(boxId);
        for (var j = 0; j < countDatas.length; j++) {
            const countData = countDatas[j];
            saveDatas.push(countData);
        }
    }
    if(saveDatas.length===0) return;
    var jsonData = dhccl.formatObjects(saveDatas);
    var data = dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonData
    }, function(result) {
        if(result.indexOf("S^")===0){
            $('#instrumentsBox').datagrid("reload");
        }else{
            $.messager.alert("保存清点数据失败，原因："+result);
        }
        
    });
}

function saveOperRegister(){
    var regFormData=$("#operRegForm").serializeJson();
    
    var operSchedule={
        RowId:operCount.schedule.RowId,
        OperRoom:regFormData.OperRoom,
        OperSeq:regFormData.OperSeq,
        ClassName:ANCLS.Model.OperSchedule
    };
    var saveDatas=[operSchedule];
    var permission=getOperEditPermission();
    if(permission==="Y"){
        var patWeight=$("#PatWeight").numberbox("getValue");
        var patWeightDesc=$("#PatWeightDesc").checkbox("getValue");
        operSchedule.PatWeight=patWeight;
        if(patWeightDesc===true){
            operSchedule.PatWeight=patWeightDesc;
        }
        var anaesthesia={
            RowId:operCount.schedule.MainAnaesthesia,
            OperStartDT:regFormData.OperStartDT,
            OperFinishDT:regFormData.OperFinishDT,
            TheatreInDT:regFormData.TheatreInDT,
            TheatreOutDT:regFormData.TheatreOutDT,
            AnaMethod:regFormData.AnaMethod,
            TheatreOutTransLoc:regFormData.TheatreOutTransLoc,
            Anesthesiologist:regFormData.Anesthesiologist,
            ClassName:ANCLS.Model.Anaesthesia
        }
        saveDatas.push(anaesthesia);

        var operList=$("#operationBox").datagrid("getRows");
        for (var i = 0; i < operList.length; i++) {
            const operation = operList[i];
            operation.ClassName=ANCLS.Model.OperList;
            operation.OperSchedule=operSchedule.RowId;
            operation.RowId="";
            saveDatas.push(operation);
        }
    }
    
    var shiftList=$("#operShiftBox").datagrid("getRows");
    for (var i = 0; i < shiftList.length; i++) {
        const shift = shiftList[i];
        shift.ClassName=ANCLS.Model.OperShift;
        shift.OperSchedule=operSchedule.RowId;
        shift.CareProvDept=session.DeptID;
        var shiftDT=shift.ShiftDT.split(" ");
        shift.ShiftDate=shiftDT[0];
        shift.ShiftTime=shiftDT[1];
        saveDatas.push(shift);
    }

    var operDatas = operDataManager.getFormOperDatas(".operdata");
    for (var i = 0; i < operDatas.length; i++) {
        const operData = operDatas[i];
        operData.ClassName=ANCLS.Model.OperData;
        operData.RecordSheet=session.RecordSheetID;
        saveDatas.push(operData);
    }

    var boxIdList=['instrumentsBox'];
    for (var i = 0; i < boxIdList.length; i++) {
        const boxId = boxIdList[i];
        var countDatas=getCountDatas(boxId);
        for (var j = 0; j < countDatas.length; j++) {
            const countData = countDatas[j];
            saveDatas.push(countData);
        }
    }

    var dataPara=dhccl.formatObjects(saveDatas);
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"SaveRegister",dataPara);
    if(ret.success){
        $.messager.popover({msg: '数据保存成功！',type:'success',timeout: 1000});
        operDatas = operDataManager.getOperDatas();
        operDataManager.setFormOperDatas(operDatas);
        $("#operationBox").datagrid("reload");
        $("#operShiftBox").datagrid("reload");
        $("#instrumentsBox").datagrid("reload");
    }else{
        $.messager.alert("提示","保存手术登记失败，原因："+ret.result,"error");
    }
}

function getCountDatas(boxId){
    var countDatas=$('#'+boxId).datagrid('getRows');
    var saveDatas=[];
    if (countDatas && countDatas.length>0 && session.RecordSheetID){
        for (var i = 0; i < countDatas.length; i++) {
            const element = countDatas[i];
            var surgicalCount={
                RowId:element.RowId,
                RecordSheet:session.RecordSheetID,
                SurgicalMaterial:element.SurgicalMaterial,
                MaterialNote:element.MaterialNote,
                AddCountDesc:element.AddCountDesc,
                InventoryType:element.InventoryType,
                ClassName:ANCLS.Model.SurInventory
            }
            var preopCount=parseFloat(element.PreopCount);
            surgicalCount.PreopCount=!isNaN(preopCount)?preopCount:"";
            var operAddCount=parseFloat(element.OperAddCount);
            surgicalCount.OperAddCount=!isNaN(operAddCount)?operAddCount:"";
            var preCloseCount=parseFloat(element.PreCloseCount);
            surgicalCount.PreCloseCount=!isNaN(preCloseCount)?preCloseCount:"";
            var postCloseCount=parseFloat(element.PostCloseCount);
            surgicalCount.PostCloseCount=!isNaN(postCloseCount)?postCloseCount:"";
            var postSewCount=parseFloat(element.PostSewCount);
            surgicalCount.PostSewCount=!isNaN(postSewCount)?postSewCount:"";
            saveDatas.push(surgicalCount);
        }
    }
    return saveDatas;
}

function calExp(exp){
    var expArr=exp.split("+");
    var result=0;
    for(var i=0;i<expArr.length;i++){
        result+=Number(expArr[i]);
    }
    return result;
}

function addOperShift(){
    endEdit("#operShiftBox");
	$("#operShiftBox").datagrid("appendRow",{
		ShiftCareProvDesc:"",
		ReliefCareProvDesc:"",
		ShiftDT:""
    });
	var rows=$("#operShiftBox").datagrid("getRows");
}

function removeOperShift(){
    var selectedoperShift=$("#operShiftBox").datagrid("getSelected");
    if(!selectedoperShift){
        $.messager.alert("提示","请先选择一条交接记录，再删除。","warning");
        return;
    }
    var selectedIndex=$("#operShiftBox").datagrid("getRowIndex",selectedoperShift);
    $.messager.confirm("提示","是否删除选择的交接记录?",function(r){
        if(r){
            if(selectedoperShift.RowId){
                $("#operShiftBox").datagrid("deleteRow",selectedIndex);
				$("#ShiftCareProvID").combobox("clear");
				$("#ReliefCareProvID").combobox("clear");
				$("#ShiftDT").combobox("clear");
            }else{
                $("#operShiftBox").datagrid("deleteRow",selectedIndex);
				$("#ShiftCareProvID").combobox("clear");
				$("#ReliefCareProvID").combobox("clear");
				$("#ShiftDT").combobox("clear");
            }
        }
    });
}

var patInfo;
var operSchedule;

function printMessage(firstPage,secondPage) {
    var count=operDataManager.printCount(session.RecordSheetID,session.ModuleCode)
    var ifMessage=operDataManager.ifPrintMessage()
    if(ifMessage!="Y"||Number(count)==0) printNew(firstPage,secondPage)
    else if(Number(count)>0){
        $.messager.confirm("提示","表单已打印"+count+"次,是否继续打印",function (r)
        {
            if(r)
            {
                printNew(firstPage,secondPage)
            } 
        } );
    }
}

function printNew(firstPage,secondPage){
    var lodop = getLodop();
    lodop.PRINT_INIT("OperCount" + session.OPSID);
    // lodop.SET_PRINT_MODE("POS_BASEON_PAPER",true);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    //lodop.ADD_PRINT_IMAGE(0,0,"17cm","4.2cm","<img src='../service/dhcanop/img/logo.zmdzx.png'>");
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    
    lodop.ADD_PRINT_HTM("1.05cm","0.5cm","492pt","100%","<html>"+firstPage+"</html>");
    lodop.NEWPAGE();
    //lodop.ADD_PRINT_IMAGE(0,0,"17cm","4.2cm","<img src='../service/dhcanop/img/logo.zmdzx.png'>");
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    lodop.ADD_PRINT_HTM("1.05cm","0.5cm","540pt","100%","<html>"+secondPage+"</html>");
    lodop.PREVIEW();
    operDataManager.savePrintLog(session.RecordSheetID,session.ModuleCode,session.UserID)
}

function getOperEditPermission(){
    var permission=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"GetOperEditPermission",session.OPSID);
    return permission;
}
function initOperEditPermission(){
    var permission=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"GetOperEditPermission",session.OPSID);
    if(permission==="Y"){

    }else{
        $("#OperStartDT,#OperFinishDT,#TheatreInDT,#TheatreOutDT").datetimebox("disable");
        $("#Anesthesiologist,#TheatreOutTransLoc,#AnaMethod").combobox("disable");
        //$("#btnAddOperation,#btnEditOperation,#btnDelOperation").linkbutton("disable");
        $("#PatWeight").numberbox("disable");
        $("#PatWeightDesc").checkbox("disable");
    }
    if(operCount.schedule.PatWeight==="平车"){
        $("#PatWeightDesc").checkbox("setValue",true);
    }
}

function printDocument(){
    var dataIntegrity=operDataManager.isDataIntegrity(".operdata");
    if(dataIntegrity===false){
        $.messager.alert("提示","手术清点数据不完整！","warning");
        //return;
    }
    operDataManager.printCount(session.RecordSheetID,session.ModuleCode,true);
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OperCount" + session.OPSID);
	lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printCount;
    /*if(lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer))
    {
        createPrintOnePage(lodop,operCount.schedule);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        printCount=lodop.PREVIEW();

    }else{*/
        createPrintOnePage(lodop,operCount.schedule);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        printCount=lodop.PREVIEW();
    //}
    if(printCount>0){
        operDataManager.savePrintLog(session.RecordSheetID,session.ModuleCode,session.UserID);
    }
}
function createPrintOnePage(lodop,operSchedule) {  
    var prtConfig=sheetPrintConfig,
        logoMargin=prtConfig.logo.margin,
        logoSize=prtConfig.logo.size,
        titleFont=prtConfig.title.font,
        titleSize=prtConfig.title.size,
        titleMargin=prtConfig.title.margin,
        contentSize=prtConfig.content.size,
        contentFont=prtConfig.content.font;
    lodop.SET_PRINT_PAGESIZE(prtConfig.paper.direction, 0, 0, prtConfig.paper.name);
    //lodop.SET_PRINT_STYLE("FontSize", contentFont.size);
    //lodop.SET_PRINT_STYLE("FontName", contentFont.name);
    //lodop.ADD_PRINT_IMAGE(logoMargin.top,logoMargin.left,logoSize.width,logoSize.height,"<img src='"+prtConfig.logo.imgSrc+"'>");
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
   
    var startPos={
        x:prtConfig.paper.margin.left,
        y:logoMargin.top+logoSize.height+logoMargin.bottom
    };
    lodop.ADD_PRINT_TEXT(70, 300, "100%", 60, session.ExtHospDesc);
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "手术护理记录单(器械清点记录单)");
    lodop.SET_PRINT_STYLEA(0, "FontName", titleFont.name);
    lodop.SET_PRINT_STYLEA(0, "FontSize", titleFont.size);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);

    startPos.y+=titleSize.height+titleMargin.bottom;
    var tableHtmlArr=[];
    tableHtmlArr.push("<table><tbody>");
    tableHtmlArr.push("<tr>")
    var lineHeight=20;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 200, 15, "姓名："+(operSchedule?operSchedule.PatName:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+120, 200, 15, "性别："+(operSchedule?operSchedule.PatGender:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+200, 200, 15, "年龄："+(operSchedule?operSchedule.PatAge:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+300, 200, 15, "科室："+(operSchedule?operSchedule.PatDeptDesc:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+460, 200, 15, "床号："+(operSchedule?operSchedule.PatBedCode:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "住院号："+(operSchedule?operSchedule.MedcareNo:""));
    var anaestMethodInfo=operSchedule?operSchedule.AnaestMethodInfo:""
    if (!anaestMethodInfo || anaestMethodInfo===""){
        anaestMethodInfo=operSchedule?operSchedule.PrevAnaMethodDesc:"";
    }
    startPos.y+=lineHeight;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "手术日期:"+(operSchedule?operSchedule.OperDate:""));
    var operInfo=$("#OperationDesc").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "手术方式：");
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+70, 470, 30, operSchedule?operSchedule.OperDesc:"");

    startPos.y+=lineHeight+(operInfo.length>40?25:0);
    //var bloodTransInfo=getBloodTransInfo();
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+400, 120, 15, "输血 血型："+(operSchedule.ABO));
   // var bloodTransInfo=getBloodTransInfo();
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+120+400, "100%", 15, "成分：");
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+160+400, 520, 30, bloodTransInfo);
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+200, 540, 30, "输血成分："+$("#BloodComponent").combobox("getText"));
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "输血量："+$("#BloodTransVol").val());
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+640, 200, 15, "ml");
    
    //startPos.y+=lineHeight+(bloodTransInfo.length>35?20:0);
    var htmlArr=[
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size: 14px;}",
        "table {table-layout:fixed;} td {text-align:center}",
        "tr {height:22px;} .textline {display:inline-block;width:100px;height:18px;border:none;border-bottom:1px solid #000;}</style>",
        "<table><thead><tr><th width='140'>器械名称</th><th width='40'>术前清点</th><th width='40'>术中加数</th><th width='40'>关体腔前</th><th width='40'>关体腔后</th><th width='40'>缝皮肤后</th>",
        "<th width='140'>器械名称</th><th width='40'>术前清点</th><th width='40'>术中加数</th><th width='40'>关体腔前</th><th width='40'>关体腔后</th><th width='40'>缝皮肤后</th></tr></thead><tbody>"
    ];

    var operCountRows = $("#instrumentsBox").datagrid("getRows");
	var inventoryRows=operCountRows;
    var maxCount = 20;
    var operCountRow;
    var secCountRow;
    var operCount = {
        MaterialNote: "",
        PreopCount: "",
        OperAddCount: "",
        PreCloseCount: "",
        PostCloseCount: "",
        PostSewCount: ""
    }
    //alert(operCountRows.length)
    for (var i = 0; i < maxCount; i++) {
        if (i >= operCountRows.length) {
            operCountRow = operCount;
            secCountRow = operCount;
        } else {
            operCountRow = operCountRows[i];
            secCountRow = operCountRows.length > (i + maxCount) ? operCountRows[i + maxCount] : operCount;
        }

        htmlArr.push("<tr><td>" + (operCountRow.MaterialNote ? operCountRow.MaterialNote : "") + "</td>");
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (operCountRow.PreopCount?operCountRow.PreopCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (Number(operCountRow.OperAddCount)>0?operCountRow.OperAddCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (operCountRow.PreCloseCount?operCountRow.PreCloseCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (operCountRow.PostCloseCount?operCountRow.PostCloseCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (operCountRow.PostSewCount?operCountRow.PostSewCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        
        htmlArr.push("<td>" + (secCountRow.MaterialNote ? secCountRow.MaterialNote : "") + "</td>");
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (secCountRow.PreopCount?secCountRow.PreopCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (Number(secCountRow.OperAddCount)>0?secCountRow.OperAddCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (secCountRow.PreCloseCount?secCountRow.PreCloseCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (secCountRow.PostCloseCount?secCountRow.PostCloseCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (secCountRow.PostSewCount?secCountRow.PostSewCount:0) + "</td></tr>");
        }else{
            htmlArr.push("<td></td>");
        }
        
    }

    // var rowCount=20;
    // var countRows=$("#dataBox").datagrid("getRows");
    // for(var i=0;i<rowCount;i++){
    //     htmlArr.push("<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
    // }
    htmlArr.push("<tr><td colspan='12'></td></tr>");
    htmlArr.push("<tr><th>敷料名称</th><th>术前清点</th><th>术中加数</th><th>关体腔前</th><th>关体腔后</th><th>缝皮肤后</th>");
    htmlArr.push("<th>敷料名称</th><th>术前清点</th><th>术中加数</th><th>关体腔前</th><th>关体腔后</th><th>缝皮肤后</th></tr>");
    
    operCountRows = $("#dressingsBox").datagrid("getRows");
    maxCount = 7;
    operCount = {
        MaterialNote: "",
        PreopCount: "",
        OperAddCount: "",
        PreCloseCount: "",
        PostCloseCount: "",
        PostSewCount: ""
    }
    for (var i = 0; i < maxCount; i++) {
        if (i >= operCountRows.length) {
            operCountRow = operCount;
            secCountRow = operCount;
        } else {
            operCountRow = operCountRows[i];
            secCountRow = operCountRows.length > (i + maxCount) ? operCountRows[i + maxCount] : operCount;
        }

        htmlArr.push("<tr><td>" + (operCountRow.MaterialNote ? operCountRow.MaterialNote : "") + "</td>");
        
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (operCountRow.PreopCount?operCountRow.PreopCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (Number(operCountRow.OperAddCount)>0?operCountRow.OperAddCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (operCountRow.PreCloseCount?operCountRow.PreCloseCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (operCountRow.PostCloseCount?operCountRow.PostCloseCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(operCountRow.MaterialNote){
            htmlArr.push("<td>" + (operCountRow.PostSewCount?operCountRow.PostSewCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        
        htmlArr.push("<td>" + (secCountRow.MaterialNote ? secCountRow.MaterialNote : "") + "</td>");
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (secCountRow.PreopCount?secCountRow.PreopCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (Number(secCountRow.OperAddCount)>0?secCountRow.OperAddCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (secCountRow.PreCloseCount?secCountRow.PreCloseCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (secCountRow.PostCloseCount?secCountRow.PostCloseCount:0) + "</td>");
        }else{
            htmlArr.push("<td></td>");
        }
        if(secCountRow.MaterialNote){
            htmlArr.push("<td>" + (secCountRow.PostSewCount?secCountRow.PostSewCount:0) + "</td></tr>");
        }else{
            htmlArr.push("<td></td>");
        }
        
    }
    // rowCount=7;
    // for(var i=0;i<rowCount;i++){
    //     htmlArr.push("<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
    // }
    /*
    htmlArr.push("<tr><td colspan='12'></td></tr>");
    htmlArr.push("<tr style='height:60px;'><td colspan='12' valign='top' style='padding:5px;text-align:left'>特殊情况记录："+$("#SpecialCondition").val()+"</td></tr>");
    htmlArr.push("<tr style='height:30px;'><td colspan='6' style='padding:5px;'>器械护士签名：<span class='textline'></span>/<span class='textline'></span></td>");
    htmlArr.push("<td colspan='6' style='padding:5px;'>巡回护士签名：<span class='textline'></span>/<span class='textline'></span></td></tr>")
    htmlArr.push("</tbody></table>");
    */
    lodop.ADD_PRINT_HTM(startPos.y,startPos.x,"RightMargin:1.5cm","BottomMargin:1cm",htmlArr.join(""));
	
	// 打印背面
	lodop.NEWPAGE();
	startPos.x=prtConfig.paper.margin.left;
	startPos.y=prtConfig.paper.margin.top;
	lodop.ADD_PRINT_RECT(startPos.y,startPos.x,"RightMargin:1.5cm",880,0,1);
	lodop.ADD_PRINT_TEXT(startPos.y+10,startPos.x+10,"100%",lineHeight,"体内植入物条形码粘贴处：");
	startPos.y+=900;
	lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",lineHeight,"填表说明：");
	startPos.y+=lineHeight;
	lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",lineHeight,"1.表格内的清点数必须用数字说明，不得用\"√\"表示。");
	startPos.y+=lineHeight;
	lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",lineHeight,"2.空格处可以填写其他手术物品。");
	startPos.y+=lineHeight;
	lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",lineHeight,"3.表格内的清点数目必须清晰，不得采用刮、粘、涂等方法涂改。");
}
function loadPatInfo(result) {
    if (result) {
        operSchedule = result;
        $("#PatName").text(result.PatName);
        $("#PatGender").text(result.PatGender);
        $("#PatAge").text(result.PatAge);
        $("#PatDept").text(result.PatDeptDesc);
        $("#PatWardBed").text(result.PatBedCode);
        $("#PatMedCareNo").text(result.MedcareNo);
        $("#OperDate").text(result.OperDate);
        $("#AreaInTime").text(result.AreaInDT);
        $("#OperRoom").text(result.RoomDesc);
        $("#OperationDesc").text(result.OperDesc);
        var surgenDesc = result.SurgeonDesc;
        if (result.AssistantDesc && result.AssistantDesc != "") {
            surgenDesc += "," + result.AssistantDesc;
        }
        $("#SurgeonDesc").text(surgenDesc);
        $("#SurgeonInfo").val(surgenDesc);
        var anaDoctor = result.AnesthesiologistDesc;
        if (!anaDoctor || anaDoctor === "") {
            anaDoctor = $("#AnaestDoctor").val();
        }
        $("#AnesthetistDesc").text(anaDoctor);
        $("#ABO").text(result.ABO);
        $("#RH").text(result.RH);
        $("#RealOperationDesc").val(result.OperationDesc);
        patInfo = result;

        //if(result.AreaInDT && $("#TheatreInTime").val()==='') $("#TheatreInTime").val(result.AreaInDT);
        //if(result.AreaInDT && $("#TheatreOutTime").val()==='') $("#TheatreOutTime").val(result.TheatreOutDT);

        var anaMethod=result.AnaestMethodInfo || result.PrevAnaMethodDesc;
        $("#AnaestMethod").combobox('setText', anaMethod);
        if(anaMethod=="局部麻醉"||anaMethod=="局部麻醉/全麻醉") $('.opertime-setting').show();
        else $('.opertime-setting').hide();

        $('#oper_start_time').text(result.OperStartDT);
        $('#oper_finish_time').text(result.OperFinishDT);

        if (patInfo.TheatreInDT != "") {
            $("#AnaestMethod").combobox('disable');
            $("#AnaestDoctor").attr('disabled',true);
            $("#AnaestDoctor").attr('title','已填写麻醉单，以麻醉单上为准');
            $("#AnaestDoctor").val(patInfo.AnesthesiologistDesc);
        }
    }
}

function msg(value, name) {
	var signCode = $(this).attr("id");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode
            });
            signView.initView();
            signView.open();
            signCommon.loadSignatureCommon();
}

function loadPatTestResult() {
	var appData = operDataManager.getOperAppData();
	var appOptsDatas=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetTestDataJSON",session.EpisodeID,appData.OperDate);
	if((appOptsDatas.BloodType!="")&&(appOptsDatas.BloodType!="N")){
		$("#ABO").combobox("setValue",appOptsDatas.BloodType);
	}
	if(appOptsDatas.RHBloodType==="+"){
		$("#RHDType1").checkbox("setValue",true);
	}else if(appOptsDatas.RHBloodType==="-"){
		$("#RHDType2").checkbox("setValue",true);
	}
}

$(document).ready(initPage);

