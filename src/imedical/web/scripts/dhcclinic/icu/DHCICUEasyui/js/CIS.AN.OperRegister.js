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
var PatAppDatas=dhccl.getDatas(ANCSP.DataQuery,{
    ClassName:ANCLS.BLL.OperScheduleList,
    QueryName:"FindOperScheduleList",
    Arg1:"",
    Arg2:"",
    Arg3:"",
    Arg4:session.OPSID,
    ArgCnt:4
},"json");
if(PatAppDatas && PatAppDatas.length>0){
    var PatAppData=PatAppDatas[0];
}

function initPage(){
    
    setDefaultValue();
    initAppForm(); 
}



/**
 * 初始化手术申请表单
 */
function initAppForm(){
    initDiagBox();
    initOperBox();
    initOperShiftBox();
    initAppFormOptions();
    initFinishOperation();
    loadAppFormData();
}

/**
 * 初始化术前诊断数据表格
 */
function initDiagBox(){
	var diagOptions=getDiagOptions();
	var columns=[[
	    {field:"DiagID",title:"<span class='required-color'>*</span>诊断描述",width:480,editor:{type:"combogrid",options:diagOptions},formatter:function(value,row,index){
            return row.DiagDesc;
		}},
		{field:"DiagNote",title:"备注",width:400,editor:{type:"validatebox"},hidden:true}
    ]];
    $("#postopDiagBox").datagrid({
        width: 1165,
        height: 180,
        singleSelect: true,
        rownumbers: true,
        columns:columns,
		toolbar:"<div style='padding:0px'><a href='#' id='btnAddDiag'>新增</a><a href='#' id='btnDelDiag'>删除</a></div>",
        headerCls:"panel-header-gray",
		bodyCls:"panel-header-gray",
        onLoadSuccess:function(data){
            initDiagButtons();
        },
		onBeforeEdit:function(rowIndex,rowData){
			operApplication.editIndex=rowIndex;
			operApplication.firstEdit=true;
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			operApplication.firstEdit=false;
		}
    });
	
    $("#postopDiagBox").datagrid("enableCellEditing");
	
    $("#Diagnosis").combogrid({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindMRCDiagnosis";
            param.Arg1 = param.q?param.q:"";
            param.ArgCnt = 1;
        },
        pagination:true,
        pageSize:10,
        panelWidth:300,
        panelHeight:400,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"Description",title:"名称",width:180},
            {field:"ICDCode",title:"ICD",width:100}
        ]],
        mode: "remote"
    });

    $("#btnAddDiag").linkbutton({
		iconCls:"icon-add",
		plain:true,
        onClick:function(){
            addDiagnosis();
        }
    });

    $("#btnDelDiag").linkbutton({
		iconCls:"icon-cancel",
		plain:true,
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
        {field:"OperNote",title:"名称备注",width:150},
        {field:"SurgeonDeptDesc",title:"术者科室",width:120},
        // {field:"SurgeonDeptDesc",title:"术者科室",width:120,editor:{type:"combobox",options:surgeonDeptOpts}},
        {field:"SurgeonDesc",title:"主刀",width:120},
        {field:"AssistantDesc",title:"助手",width:180},
        {field:"SurgeonExpert",title:"外院专家",width:120}
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
            param.Arg2 = $("#Surgeon").combobox("getValue");
            param.Arg3 = $("#SurgeonDeptID").combobox("getValue");
            param.ArgCnt = 3;
        },
        panelWidth:450,
        panelHeight:350,
        valueField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"名称",width:240},
            {field:"OperClassDesc",title:"分级",width:60},
            {field:"ICDCode",title:"ICD",width:120},
            {field:"ExternalID",title:"ExternalID",hidden:true}
        ]],
        pagination:true,
        pageSize:10,
        mode: "remote",
        onSelect:function(rowIndex,record){
            if(!operApplication.selectedPat) return;
            try{
                var EpisodeID=operApplication.selectedPat.EpisodeID;
                var operId=record.ExternalID?record.ExternalID:"";
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
                $("#OperClass").combobox("setValue",record.OperClass);
                $("#BladeType").combobox("setValue",record.BladeType);
                $("#BodySite").combobox("setValue",record.BodySite);
                $("#BodySite").combobox("reload");
            }catch(ex){

            }
        },
        onChange:function(newValue,oldValue){
            $("#Surgeon").combobox("clear");
            $("#Surgeon").combobox("reload");
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
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindSurgeonByOper";
            param.Arg1 = param.q?param.q:"";
            param.Arg2=$("#SurgeonDeptID").combobox("getValue");
            if(!param.Arg2){
				if(PatAppDatas && PatAppDatas.length>0){
					param.Arg2=PatAppDatas[0].AppDeptID   //session.DeptID;
				}
            }
            param.Arg3 = "Y";
            param.Arg4 = session.HospID;
            param.Arg5 = $("#Operation").combobox("getValue");
            param.ArgCnt = 5;
        },
        valueField: "Code",
        textField: "CareProvDesc",
        editable:false,
        mode: "remote",
		onChange:function(newValue,oldValue){
			var SurgeoGroupList=dhccl.getDatas(ANCSP.DataQuery,{
				ClassName:ANCLS.BLL.ConfigQueries,
				QueryName:"FindSurgeonGroup",
				Arg1:PatAppDatas[0].AppDeptID,
				Arg2:newValue,
				ArgCnt:2
			},"json");
			if(SurgeoGroupList && SurgeoGroupList.length>0){
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
	})

    $(".sur-careprov").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindResourceByHIS";
            param.Arg1=param.q?param.q:"";
            param.Arg2=$("#SurgeonDeptID").combobox("getValue");
            if(!param.Arg2){
				if(PatAppDatas && PatAppDatas.length>0){
					param.Arg2=PatAppDatas[0].AppDeptID   //session.DeptID;
				}
            }
            param.Arg3="Y";
            param.Arg4=session.HospID;
            param.ArgCnt=4;
        },
        //panelWidth:450,
        valueField: "CareProvider",
        textField: "CareProvDesc",
        editable:false,
        //columns:[[
        //    {field:"ResourceID",title:"ID",hidden:true},
        //    {field:"Description",title:"医护姓名",width:240},
        //    {field:"Location",title:"所在科室",width:200}
        //]],
        mode: "remote"
    });

    $("#operationBox").datagrid({
        width: 1165,
        height: 300,
        headerCls:"panel-header-gray",
		bodyCls:"panel-header-gray",
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
    
	$("#OperPosition").combobox("setValues","");
}

function initOperShiftBox(){
    dhccl.parseDateTimeFormat();
	var validParams = "YMD";
    if (session.DateFormat === "j/n/Y") {
      validParams = "DMY";
    }
	var careShiftprovOptions=getShiftcareprovOptions();
    var careReliefprovOptions=getReliefcareprovOptions();
    var columns=[[
        {field:"ShiftCareProv",title:"交班护士",width:120,editor:{type:"combogrid",options:careShiftprovOptions},formatter:function(value,row,index){
            return row.ShiftCareProvDesc;
		}},
        {field:"ShiftCareProvID",title:"交班护士",width:120,hidden:true,editor:{type:"combogrid",options:careShiftprovOptions},formatter:function(value,row,index){
            return row.ShiftCareProvID;
		}},
        {field:"ReliefCareProv",title:"接班护士",width:120,editor:{type:"combogrid",options:careReliefprovOptions},formatter:function(value,row,index){
            return row.ReliefCareProvDesc;
		}},
        {field:"ReliefCareProvID",title:"接班护士",width:120,hidden:true,editor:{type:"combogrid",options:careReliefprovOptions},formatter:function(value,row,index){
            return row.ReliefCareProvID;
		}},
        {field:"ShiftDT",title:"交接时间",width:200,editor:{type:"datetimebox",options:onSelect()},formatter:function (date) {
        if(date){
			var str = date.split(" ");
			var MyDateStr = str[0];
			if (MyDateStr.indexOf("/") >= 0) {
				var MyDate = MyDateStr.split("/");
				var y = parseInt(MyDate[2], 10);
				var m = parseInt(MyDate[1], 10);
				var d = parseInt(MyDate[0], 10);
			} else {
				var MyDate = MyDateStr.split("-");
				var y = parseInt(MyDate[0], 10);
				var m = parseInt(MyDate[1], 10);
				var d = parseInt(MyDate[2], 10);
			}
			var MyTimeStr = str[1];
			var MyTime = MyTimeStr.split(":");
			var h = parseInt(MyTime[0], 10);
			var min = parseInt(MyTime[1], 10);
			var sec = parseInt(MyTime[2], 10);
			m = m < 10 ? "0" + m : m;
			d = d < 10 ? "0" + d : d;
			h = h < 10 ? "0" + h : h;
			min = min < 10 ? "0" + min : min;
			sec = sec < 10 ? "0" + sec : sec;
			if (session.DateFormat == "j/n/Y") {
				return d + "/" + m + "/" + y + " " + h + ":" + min + ":" + sec;
			}else{
				return (y + "-" + m + "-" + d + " " + h + ":" + min + ":" + sec);
			}
		}
		},
      parser: function (s) {
        if (!s) return new Date();
        if (s.indexOf("/") >= 0) {
          var str = s.split(" ");
          var MyDateStr = str[0];
          var MyTimeStr = str[1];
          var MyDate = MyDateStr.split("/");
          var y = parseInt(MyDate[2], 10);
          var m = parseInt(MyDate[1], 10);
          var d = parseInt(MyDate[0], 10);
          var MyTime = MyTimeStr.split(":");
          var h = parseInt(MyTime[0], 10);
          var min = parseInt(MyTime[1], 10);
          var sec = parseInt(MyTime[2], 10);
        } else {
          var str = s.split(" ");
          var MyDateStr = str[0];
          var MyTimeStr = str[1];
          var MyDate = MyDateStr.split("-");
          var y = parseInt(MyDate[0], 10);
          var m = parseInt(MyDate[1], 10);
          var d = parseInt(MyDate[2], 10);
          var MyTime = MyTimeStr.split(":");
          var h = parseInt(MyTime[0], 10);
          var min = parseInt(MyTime[1], 10);
          var sec = parseInt(MyTime[2], 10);
        }
        if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
          return new Date(y, m - 1, d, h, min, sec);
        } else {
          return new Date();
        }
      },
      validParams: validParams
	  },
    ]];
    $("#operShiftBox").datagrid({
        width: 1165,
        height: 300,
        headerCls:"panel-header-gray",
        bodyCls: 'panel-body-gray',
        singleSelect: true,
        rownumbers: true,
        border:true,
        toolbar:"<div style='padding:0px'><a href='#' id='btnAddShift'>新增</a><a href='#' id='btnDelShift'>删除</a></div>",
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
	
	$("#operShiftBox").datagrid("enableCellEditing");
	
	$("#btnAddShift").linkbutton({
		iconCls:"icon-add",
		plain:true,
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
		iconCls:"icon-cancel",
		plain:true,
        onClick:function(){
            removeOperShift();
        }
    });
}


function initAppFormOptions(){
    $("#SurgeonDeptID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindLocationOld";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt=2;
        },
        onChange:function(newValue,oldValue){
            $("#Surgeon").combobox("clear");
            $("#Surgeon").combobox("reload");
            $(".sur-careprov").combobox("clear");
            $(".sur-careprov").combobox("reload");
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        editable:false
    });
	
    $("#AnaMethod").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.Arg1 = "";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description",
        editable:false,
        // multiple: true
    });

    // $("#OperDate").datebox({
    //     readonly:true
    // });

    $("#SourceType").combobox({
        valueField:"code",
        textField:"desc",
        // editable:false,
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


    $("#BodySite").combobox({
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindBodySiteByOper";
            param.Arg1=$("#Operation").combogrid("getValue");
            param.ArgCnt=1;
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
	//取手术室关联的麻醉科室Id
	var linklocIdArr=[];
	var linklocId="";
    var linklocIdStr=dhccl.runServerMethodNormal(CLCLS.BLL.Admission,"GetLinkLocId",session.DeptID);
	if(linklocIdStr!==""){
		linklocIdArr=linklocIdStr.split("^");
		linklocId=linklocIdArr[0];
	}
    $("#AnaExpert,#Anesthesiologist,#AnaAssistant").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindResourceByHIS";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = (linklocId!=="") ? linklocId:session.DeptID;
            param.Arg3 = "Y";
            param.Arg4=session.HospID;
            param.ArgCnt = 4;
        },
        valueField: "CareProvider",
        textField: "CareProvDesc",
        editable:false,
        mode: "remote",
        onSelect:function(record){
            var elementID=$(this).attr("id");
            //genArrangeElement(record,elementID,true);
            
        }
    });
	//交接班、巡回、器械 20191231 YuanLin
	$("#CircualNurse,#ScrubNurse,#ShiftCareProvID,#ReliefCareProvID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = session.DeptID;
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        editable:false,
        mode: "remote",
        onSelect:function(record){
            var elementID=$(this).attr("id");
            //genArrangeElement(record,elementID,true);
            
        }
    });
	//手术间 20191231 YuanLin
	$("#OperRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        editable:false,
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindOperRoom";
            param.Arg1 = "";
            param.Arg2="R";
            param.ArgCnt = 2;
        }
    });
	
    $("#btnSave").linkbutton({
        onClick:function(){
            saveOperRegister();
        }
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });
}

function initFinishOperation(){
    var canFinishOperation=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"CanFinishOperation",session.OPSID);
    if (canFinishOperation!=="Y"){
        $("#btnFinishOperation").remove();
    }else{
        $("#btnFinishOperation").linkbutton({
            onClick:function(){
                var ret=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"FinishOperation",session.OPSID,session.UserID);
                if(ret.indexOf("S^")===0){
                    $.messager.alert("提示","设置手术完成成功！","info");
                }else{
                    $.messager.alert("提示","设置手术完成失败！原因："+ret,"error");
                }
            }
        });
    }
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
        // $("body").layout("remove","west");
        // $(".btnList").css({"padding":"0","width":"auto"});
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
    ret=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"GetOperAppDeadLine");
    if(ret==="Y"){
        // 如果已截止，那么手术类型默认为“急诊”
        $("#SourceType").combobox("setValue","E");
        $("#SourceType").combobox("readonly");
    }else{
        $("#SourceType").combobox("setValue","B")
    }

    var sourceType=$("#SourceType").combobox("getValue");
    setOperDate(sourceType);

    // 默认手术申请科室为本科室
    $("#AppDeptID,#SurgeonDeptID").combobox("setValue",PatAppDatas[0].AppDeptID);

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
        $("#OperNote").val("");
        //术前诊断
        if(appData.PostDiagnosis=="")
        {
            if(appData.PrevDiagnosis){
                var diagListArr=appData.PrevDiagnosis.split("&&&");
                var diagObjects=[];
                for(var i=0;i<diagListArr.length;i++){
                    var diagArr=diagListArr[i].split("###");
                    diagObjects.push({
						DiagID:diagArr[0],
						DiagDesc:diagArr[1],
						DiagNote:diagArr[2]
                    });
                }
                $("#postopDiagBox").datagrid("loadData",diagObjects);
			}
        }
        else{
            if(appData.PostDiagnosis){
                var diagListArr=appData.PostDiagnosis.split("&&&");
                var diagObjects=[];
                for(var i=0;i<diagListArr.length;i++){
                    var diagArr=diagListArr[i].split("###");
                    diagObjects.push({
						DiagID:diagArr[0],
						DiagDesc:diagArr[1],
						DiagNote:diagArr[2]
                    });
                }
                $("#postopDiagBox").datagrid("loadData",diagObjects);
        }
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
		if(appData.FirstCirNurse){
            var CirNurseArr=appData.FirstCirNurse.split(",");
            $("#CircualNurse").combobox("setValues",CirNurseArr);
        }
		if(appData.FirstScrubNurse){
            var ScrubNurseArr=appData.FirstScrubNurse.split(",");
            $("#ScrubNurse").combobox("setValues",ScrubNurseArr);
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
    $("#OperNote").val("");
    $("#SurgeonExpert").val("");
    $("#Operation").combogrid("setValues","");
    $("#BodySite").combobox("setValues","");
}

function setPostDiagnosis(){
    if(!operApplication.selectedPat) return;
    $("#postopDiagBox").datagrid("loadData",[]);
    var admDiagnosisList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:CLCLS.BLL.Admission,
        QueryName:"FindAdmDiagnosis",
        Arg1:operApplication.selectedPat.EpisodeID,
        Arg2:"C008",
        ArgCnt:2
    },"json");
    if(admDiagnosisList && admDiagnosisList.length>0)
    {
        $("#postopDiagBox").datagrid("loadData",admDiagnosisList);
    }
}

function setOperDate(sourceType){
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetOperDate",sourceType);
    if(ret && ret.result){
        $("#OperDate").datebox("setValue",ret.result);
    }
}

function initDiagButtons(){
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
    endEdit("#postopDiagBox");
	$("#postopDiagBox").datagrid("appendRow",{
		DiagID:""
	});
	var rows=$("#postopDiagBox").datagrid("getRows");
}
function removeDiagnosis(index){
    var selectedDiag=$("#postopDiagBox").datagrid("getSelected");
    if(!selectedDiag){
        $.messager.alert("提示","请先选择一条术后诊断，再删除。","warning");
        return;
    }
    var selectedIndex=$("#postopDiagBox").datagrid("getRowIndex",selectedDiag);
    $.messager.confirm("提示","是否删除选择的术后诊断?",function(r){
        if(r){
			$("#postopDiagBox").datagrid("deleteRow",selectedIndex);
			$("#Diagnosis").combogrid("clear");
        }
    });
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
        assis3Desc=$("#Assistant3").combogrid("getText");
        //assis4Desc=$("#Assistant4").combogrid("getText"),
        //assis5Desc=$("#Assistant5").combogrid("getText");
    var surAssisDesc=assis1Desc;
    if(assis2Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis2Desc;
    }
    if(assis3Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis3Desc;
    }
    //if(assis4Desc){
        //if(surAssisDesc) surAssisDesc+=",";
        //surAssisDesc+=assis4Desc;
    //}
    //if(assis5Desc){
        //if(surAssisDesc) surAssisDesc+=",";
        //surAssisDesc+=assis5Desc;
    //}

    var surAssistant=formData.Assistant1;
    if (formData.Assistant2){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant2;
    }
    if (formData.Assistant3){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant3;
    }
    //if (formData.Assistant4){
        //if(surAssistant) surAssistant+=",";
        //surAssistant+=formData.Assistant4;
    //}
    //if (formData.Assistant5){
        //if(surAssistant) surAssistant+=",";
        //surAssistant+=formData.Assistant5;
    //}

    formData.Assistant=surAssistant;
    formData.AssistantDesc=surAssisDesc;
    formData.OperationDesc=$("#Operation").combogrid("getText");
    formData.OperClassDesc=$("#OperClass").combobox("getText");
    formData.SurgeonDesc=$("#Surgeon").combogrid("getText");
    formData.BodySiteDesc=$("#BodySite").combobox("getText");
    formData.BladeTypeDesc=$("#BladeType").combobox("getText");
    formData.SurgeonDeptDesc=$("#SurgeonDeptID").combobox("getText");
    return formData;
}

function addOperation(){
    if(!$("#operationForm").form("validate")) return;
	if (operApplication.newApp){
		var selectedApp=$("#patientsList").datagrid("getSelected");
        if (!selectedApp){
			$.messager.alert("提示","请先选择手术患者，再进行添加。","warning");
			return;
		}
    }
    var Operation = $("#Operation").combogrid("getValue");
    var reg = /^[0-9]+.?[0-9]*$/;
    if (!reg.test(Operation)){
        $.messager.alert("提示","请先选择手术名称，不允许手写填入。","warning");
        return;
	}
    var operList=$("#operationBox").datagrid("getRows");
    for(var i=0;i<operList.length;i++){
        var planOperation=operList[i];
        if(Operation==planOperation.Operation){
            $.messager.alert("提示","该手术已添加，请重新选择。","warning");
            return;
        }
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
}

function editOperation(index){
    var selectedOperation=$("#operationBox").datagrid("getSelected");
    var selectedIndex=$("#operationBox").datagrid("getRowIndex",selectedOperation);
    if(!selectedOperation){
        $.messager.alert("提示","请先选择一条手术，再修改。","warning");
        return;
    }
    var Operation = $("#Operation").combogrid("getValue");
    var reg = /^[0-9]+.?[0-9]*$/;
    if (!reg.test(Operation)){
        $.messager.alert("提示","请先选择手术名称，不允许手写填入。","warning");
        return;
	}
    var operList=$("#operationBox").datagrid("getRows");
    for(var i=0;i<operList.length;i++){
        var planOperation=operList[i];
        if((Operation==planOperation.Operation)&&(selectedIndex!=i)){
            $.messager.alert("提示","该手术已添加，请重新选择。","warning");
            return;
        }
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
    formData.RowId=selectOperation.RowId;
    $("#operationBox").datagrid("updateRow",{
        index:selectedIndex,
        row:formData
    });
    $("#operationForm").form("clear");
    $("#operationBox").datagrid("unselectRow", selectedIndex);
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
        }
    });
}

function selectOperation(index,row){
    if(row){
        $("#operationForm").form("load",row);
		$("#Operation").combogrid("setText",row.OperationDesc);
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

function selectPatient(pat){
    if(pat && pat.EpisodeID){
        var patDataList=dhccl.getDatas(ANCSP.DataQuery,{
            ClassName:CLCLS.BLL.Admission,
            QueryName:"FindPatient",
            Arg1:pat.EpisodeID,
            ArgCnt:1
        },"json");
        if(patDataList && patDataList.length>0){
            if(existsApplication()){
                $.messager.confirm("提示","该患者存在未完成的手术，是否继续申请手术？",function(r){
                    if(r){
                        var patData=patDataList[0];
                        $("#appForm").form("load",patData);
                        setPrevDiagnosis();
                        setDefaultValue();
                    }
                });
            }else{
                var patData=patDataList[0];
                $("#appForm").form("load",patData);
                setPrevDiagnosis();
                setDefaultValue();
            }
            
        }
    }
}

function existsApplication(){
    if(!operApplication.selectedPat) return;
    var ret=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"ExistsOperApplication",operApplication.selectedPat.EpisodeID);
    if(ret && ret.indexOf("Y")===0){
        return true;
    }

    return false;
}

function saveOperRegister(){
    if(!$("#appForm").form("validate")) return;
    var appData=$("#appForm").serializeJson();
	if(appData.AppUserID=="") appData.AppUserID=session.UserID;
    appData.StatusCode="Application";
    appData.ClassName=ANCLS.Model.OperSchedule;
    appData.RowId=session.OPSID?session.OPSID:"";
    appData.BodySite=$("#BodySite").combobox("getValues").join(",");
    appData.OperPosition=$("#OperPosition").combobox("getValues").join(",");

    // 术后诊断
    var diagList=$("#postopDiagBox").datagrid("getRows");
    if(!diagList || diagList.length<=0){
        $.messager.alert("提示","未添加术后诊断，请添加好术后诊断之后，再保存手术申请。","warning");
        return;
    }
    var diagInfo=getPostopDiag();
    //appData.PrevDiagnosis=diagInfo;
    appData.PostDiagnosis=diagInfo;
    var dataArr=[];
    dataArr.push(appData);

    var anaesthesia={
        RowId:PatAppDatas[0].MainAnaesthesia,
        AnaMethod:appData.AnaMethod,
        Anesthesiologist:appData.Anesthesiologist,
        TheatreInDT:appData.TheatreInDT,
        TheatreOutDT:appData.TheatreOutDT,
        AreaInDT:appData.AreaInDT,
        AreaOutDT:appData.AreaOutDT,
        ClassName:ANCLS.Model.Anaesthesia
    }
    dataArr.push(anaesthesia);

    // 实施手术
    var operList=$("#operationBox").datagrid("getRows");
    if(!operList || operList.length<=0){
        $.messager.alert("提示","未添加实施手术，请添加好实施手术之后，再保存手术申请。","warning");
        return;
    }
    for(var i=0;i<operList.length;i++){
        var planOperation=operList[i];
        var operation={};
        for(var property in planOperation){
            operation[property]=planOperation[property];
        }
        operation.OperSchedule=session.OPSID?session.OPSID:"";
        operation.ClassName=ANCLS.Model.OperList;
        dataArr.push(operation);
    }
    
    //交接班
    var operShiftList=$("#operShiftBox").datagrid("getRows");
    for(var i=0;i<operShiftList.length;i++){
        ShiftData=operShiftList[i];
		if((ShiftData.ReliefCareProvDesc==="")||(ShiftData.ShiftCareProvDesc==="")||(ShiftData.ShiftDT==="")){
			$.messager.alert("提示","交接班填写不完整，请填好后再保存。","warning");
			return;
		}
        ShiftData.OperSchedule=session.OPSID?session.OPSID:"";
        ShiftData.ShiftDate=ShiftData.ShiftDT;
        ShiftData.ShiftTime=ShiftData.ShiftDT;
		ShiftData.CareProvDept=session.DeptID;
        ShiftData.ClassName=ANCLS.Model.OperShift;
        dataArr.push(ShiftData);
    }

    var dataPara=dhccl.formatObjects(dataArr);
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"SaveRegister",dataPara,session.UserID);
    //var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"SaveOperApplication",dataPara);
    if(ret.success){
        if(operApplication.newApp){
            $.messager.alert("提示","保存术后登记成功。","info",function(){
                // $("#appForm").form("clear");
                // $("#patientsList").datagrid("clearSelections");
                window.location.reload();
            });
        }else{
            $.messager.confirm("提示","保存术后登记成功，是否关闭页面？",function(r){
                if(r){
                    //window.location.reload();
                    
                    if(window.parent.closeCurrentTab){
                        window.parent.closeCurrentTab();
                    }else{
                        loadAppFormData();
                    }
                }else{
                    loadAppFormData(); 
                }
            });
        }
    }else{
        $.messager.alert("提示","保存术后登记失败，原因："+ret.result,"error");
    }
}

function getPostopDiag(){
    /*
    var diagList=$("#postopDiagBox").datagrid("getRows");
    var ret="";
    if(diagList &&diagList.length>0){
        for(var i=0;i<diagList.length;i++){
            var diag=diagList[i];
            if(ret!==""){
                ret+=",";
            }
            ret+=diag.DiagID?diag.DiagID:diag.DiagDesc;
            //ret+=diag.DiagDesc;
        }
    }
    */
    var diagList=$("#postopDiagBox").datagrid("getRows");
    var ret="";
    if(diagList &&diagList.length>0){
        for(var i=0;i<diagList.length;i++){
            var diag=diagList[i];
            if(ret!=""){
                ret+="&&&";
            }
            ret+=diag.DiagID+"###"+diag.DiagDesc+"###"+'';
           // ret+=diag.DiagDesc;
        }
    }

    return ret;
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
function getDiagOptions(){
	return {
		url: ANCSP.DataQuery,
		onBeforeLoad: function(param) {
			param.Arg2="";
			var rows=$("#postopDiagBox").datagrid("getRows");
			var rowData=rows[operApplication.editIndex];
			if(operApplication.firstEdit && rowData.DiagDesc){
				param.q=rowData.DiagDesc;
				param.Arg2=rowData.DiagID;
				operApplication.firstEdit=false;
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
			var rows=$("#postopDiagBox").datagrid("getRows");
			var diagData=rows[operApplication.editIndex];
			if(diagData){
				for(var i=0;i<rows.length;i++){
					var diagrow=rows[i];
					if((diagrow.DiagDesc===rowData.Description)&&(i!==operApplication.editIndex)){
						$.messager.alert("提示","诊断重复,请重新选择!","warning");
						checkFlag=false;
						$("#postopDiagBox").datagrid("deleteRow",operApplication.editIndex);
						break;
					}
				}
				if(checkFlag)
                { 
                    diagData.DiagID=rowData.RowId;
                    diagData.DiagDesc=rowData.Description;
                }
			}
		}
	}
}
function getShiftcareprovOptions(){
	return {
		url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = session.DeptID;
            param.ArgCnt = 2;
        },
		pagination:true,
		pageSize:10,
		panelWidth:200,
		panelHeight:400,
        valueField: "RowId",
        textField: "Description",
		columns:[[
		    {field:"Description",title:"名称",width:200},
		    {field:"RowId",title:"ID",width:100,hidden:true}
		]],
		mode: "remote",
        onSelect:function(rowIndex,rowData){
			var checkFlag=true;
			var rows=$("#operShiftBox").datagrid("getRows");
			var CareData=rows[operApplication.editIndex];
			if(CareData){
				if(checkFlag) 
                {
                    CareData.ShiftCareProvDesc=rowData.Description;
                    CareData.ShiftCareProvID=rowData.RowId;
                }
			}
		}
	}
}
function getReliefcareprovOptions(){
	return {
		url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = session.DeptID;
            param.ArgCnt = 2;
        },
		pagination:true,
		pageSize:10,
		panelWidth:200,
		panelHeight:400,
        valueField: "RowId",
        textField: "Description",
		columns:[[
		    {field:"Description",title:"名称",width:200},
		    {field:"RowId",title:"ID",width:100,hidden:true}
		]],
		mode: "remote",
        onSelect:function(rowIndex,rowData){
			var checkFlag=true;
			var rows=$("#operShiftBox").datagrid("getRows");
			var CareData=rows[operApplication.editIndex];
			if(CareData){
				if(checkFlag) 
                {
                    CareData.ReliefCareProvDesc=rowData.Description;
                    CareData.ReliefCareProvID=rowData.RowId;
                }
			}
		}
	}
}
function endEdit(selector){
	var rows=$(selector).datagrid("getRows");
	for(var i=0;i<rows.length;i++){
		$(selector).datagrid("endEdit",i);
	}
}
function onSelect(date)
{
    return {
		mode: "remote",
        onChange:function(rowIndex,rowData){
            //alert(1212)
			var checkFlag=true;
			var rows=$("#operShiftBox").datagrid("getRows");
			var CareData=rows[operApplication.editIndex];
			if(CareData){
				if(checkFlag) 
                {
                    CareData.ShiftDT=rowIndex;
                }
			}
		}
	}
}
$(document).ready(initPage);

