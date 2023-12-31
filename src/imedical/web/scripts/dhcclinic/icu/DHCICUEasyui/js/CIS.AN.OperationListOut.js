var operList={
    controlDatas:null
}

/**
 * 初始化页面
 */
var selectOPSID="";
function initPage()
{
    initConditionForm();
    initOperListGrid();
    initCancelReasonDialog();
    initActionPermission();
}

/**
 * 初始化查询条件表单
 */
function initConditionForm(){
    dhccl.parseDateFormat();
    /*
    $("#AppDept").combobox({
        valueField:"RowId",
        textField:"Description",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindDeptListDept";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.Arg3=session.HospID;
            param.ArgCnt=3;
        },
        mode:"remote"
    });
	*/
	
	$("#AppDept").combobox({
		valueField:"RowId",
		textField:"Description",
		url:ANCSP.DataQuery,
		onBeforeLoad:function(param){
			param.ClassName=CLCLS.BLL.Admission;
			param.QueryName="FindLocationOld";
			param.Arg1=param.q?param.q:"";
			param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
			param.ArgCnt=2;
		},
		mode:"remote"
	});
	
    $("#PatWard").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindWards";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.HospID;
            param.Arg3="";
            param.Arg4="Y";
            param.ArgCnt = 4;
        }
    });

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

    $("#OperStatus").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperStatus";
            param.ArgCnt = 0;
        }
    });

    $("#RegNo").keyup(function(e){
        if(e.keyCode===13){
            var text=$(this).val();
            if(text && text.length<10){
                var zeroArr=[];
                for(var i=0;i<10-text.length;i++){
                    zeroArr.push(0);
                }
                $(this).val(zeroArr.join("")+text);
            }
            queryOperList();
        }
    });

    $("#btnQuery").linkbutton({
        onClick:queryOperList
    });

    $("#btnExport").linkbutton({
        onClick:exportOperList
    });

    $("#btnPrint").linkbutton({
        onClick:printOperations
    });
	
    $("#IsOutOper").checkbox('setValue',true)
	
    //202003+dyl
    $("#btnPrintOutOper").linkbutton({
        onClick:printOutOper
    });
	
    $("#btnClean").linkbutton({
        onClick:function(){
            $("#conditionForm").form("clear");
			$("#IsOutOper").checkbox('setValue',true)
            setQueryConditions();
        }
    });
    setQueryConditions();
}

/**
 * 根据配置信息设置默认查询条件
 */
function setQueryConditions(){
    var permission=operationListConfig.getPermission(session.GroupID);
    if(permission && permission.qryConditions){
        var conditions=permission.qryConditions;
        if(!conditions.startDate) conditions.startDate=0;
        if(!conditions.endDate) conditions.endDate=0;
        var today=new Date();
        var startDate=today.addDays(conditions.startDate);
        var endDate=today.addDays(conditions.endDate);
        var startDateStr=startDate.format("yyyy-MM-dd");
        var endDateStr=endDate.format("yyyy-MM-dd");
        $("#OperStartDate").datebox("setValue",startDateStr);
        $("#OperEndDate").datebox("setValue",endDateStr);
        if(conditions.appDeptEnable===0){
            $("#AppDept").combobox("disable");
        }
        if(conditions.appDeptDefValue===1){
            $("#AppDept").combobox("setValue",session.DeptID);
        }
        
    }else{
        var today=(new Date()).format("yyyy-MM-dd");
        $("#OperStartDate,#OperEndDate").datebox("setValue",today);
    }
}

/**
 * 初始化手术列表表格
 */
var lastselctrowindex="";
function initOperListGrid(){
    var roomEditorOptions=getOperRoomEditorOptions();
    //var columnsConfig=dhccl.runServerMethod("CIS.AN.BL.DataGrid","GetDataColumns",session.ModuleID,"operlistBox",session.GroupID,session.UserID);
    var columns=[[
        {field:"CheckStatus",title:"勾选",checkbox:true},
        {field:"StatusDesc",title:"状态",width:50,styler:function(value,row,index){
            return "background-color:" + row.StatusColor + ";color:white;text-align:center";
        }}, 
        {field:"SourceTypeDesc",title:"类型",width:50,styler: function (value, row, index) {
            switch (row.SourceType) {
                case "B":
                    return "background-color:"+SourceTypeColors.Book + ";color:white;text-align:center";
                    return "background-color:"+SourceTypeColors.Emergency + ";color:white;text-align:center";
                default:
					return "background-color:white;color:white;text-align:center";
            }
        }},
        {field:"OperDate",title:"手术日期",width:100},
        {field:"RoomDesc",title:"手术间",width:70,
		editor:{
            type:'combobox',
            options: roomEditorOptions
        },
        formatter:function(value,row){
            if((/^(\+|-)?\d+$/.test( value )))
            {
            var oproomList=getOpRoomList();
           
            for(var i=0;i<oproomList.length;i++)
            {
                if(oproomList[i].RowId==value)
                {
                    return oproomList[i].Description;
                }
            }
            }else{
                return value;
            }
        }},
        {field:"OperSeq",title:"台次",width:45,
        editor:{
            type:'combobox',
            options:{
                panelWidth:80,
                valueField:'code',
                textField:'desc',
                data:getOrdNo()	
            }
        }},
        {field:"PlanSurgeonDesc",title:"主刀",width:62
        /*
        ,editor:{
            type:'combobox',
            options: getSurgeonOptions()	
        } ,
        formatter:function(value,row){
            if((/^(\+|-)?\d+$/.test( value )))
            {
            var surgeonList=getSurgeonList();
            for(var is=0;is<surgeonList.length;is++)
            {
                if(surgeonList[is].CareProvider==value)
                {
                    return surgeonList[is].CareProvDesc;
                }
            }
            }else{
                return value;
            }
        }
        */
		},
        {field:"CircualNurseDesc",title:"巡回护士",width:112
        ,editor:{
            type:'combobox',
            options: getNurseOptions()	
        } ,
        formatter:function(value,row){
            if((/^(\+|-)?\d+$/.test( value )))
            {
            var snurseList=getNurseList();
            for(var inum=0;inum<snurseList.length;inum++)
            {
                if(snurseList[inum].RowId==value)
                {
                    return snurseList[inum].Description;
                }
            }
            }else{
                return value;
            }
        }},
        {field:"AnaMethodDesc",title:"麻醉方法",width:100},
        {field:"PlanSeq",title:"拟台",width:45},
        {field:"PatName",title:"患者姓名",width:76},
        {field:"PatGender",title:"性别",width:45},
        {field:"PatAge",title:"年龄",width:50},
        {field:"OperDesc",title:"手术名称",width:200},
        {field:"PlanAsstDesc",title:"助手",width:80},
        {field:"AnesthesiologistDesc",title:"麻醉医生",width:80},
        {field:"InfectionOperDesc",title:"感染",width:48},
        {field:"OperPositionDesc",title:"体位",width:62},
        {field:"AntibiosisDesc",title:"抗生素",width:52},
        {field:"SurgicalMaterials",title:"特殊器械",width:80},
        {field:"HighConsume",title:"高值耗材",width:80},
        {field:"PatDeptDesc",title:"科室",width:120},
        {field:"PrevDiagnosisDesc",title:"术前诊断",width:160},
        //{field:"OperRequirementDesc",title:"备注",width:120},
        {field:"DaySurgery",title:"日间",width:45}, //202002+dyl
        {field:"IsCanDayOper",title:"日间准入",width:80},   //20210617+dyl
        {field:"OPAdmType",title:"门诊手术",width:1,hidden:true}, //202003+dyl
        {field:"OperRoom",title:"OperRoomId",width:1,hidden:true},
        {field:"CircualNurse",title:"CircualNurseId",width:1,hidden:true},
        {field:"OPSID",title:"OPSID",width:100},
        {field:"OperNote",title:"备注",width:120}
    ]];
    //initColumns(columns[0],columnsConfig);
   
    $("#operlistBox").datagrid({
        fit:true,
        title:"手术列表",
        headerCls:"panel-header-gray",
        border: false,
        iconCls:"icon-paper",
        rownumbers: true,
        pagination: true,
        pageSize: 300,
        pageList: [50, 100, 200,300,400,500],
        remoteSort: false,
        checkbox: true,
        checkOnSelect:false,
        selectOnCheck:false,
        singleSelect:true,  //选择行时只能单选，多选要选择勾选框，涉及患者信息写入头菜单的问题。 YL 20220120
        toolbar:"#operlistTool",
        columns:columns,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperScheduleList;
            param.QueryName="FindOperScheduleList";
            param.Arg1=$("#OperStartDate").datebox("getValue");
            param.Arg2=$("#OperEndDate").datebox("getValue");
            param.Arg3=session.DeptID;
            param.Arg4="";
            param.Arg5=$("#AppDept").combobox("getValue");
            param.Arg6=$("#PatWard").combobox("getValue");
            param.Arg7=$("#OperStatus").combobox("getValue");
            param.Arg8=$("#OperRoom").combobox("getValue");
            param.Arg9=$("#RegNo").val();
            param.Arg10=$("#MedcareNo").val();
           	param.Arg11="";
            param.Arg12=$("#chkIsDayOper").checkbox('getValue')?"Y":"N";
            param.Arg13=$("#IsOutOper").checkbox('getValue')?"Y":"N";
            param.ArgCnt=13;
        },
       
        onCheck:function(rowIndex, rowData) {
            //$('#operlistBox').datagrid('selectRow',rowIndex);
            //curSelOpsId=rowData.opsId;
            //selectPatient(rowData);
        },
        onSelect: function (rowIndex, rowData) {
          dhccl.setHeaderParam(rowData);     //选择勾选框时不允许将患者信息写入头菜单，选择行时才允许将患者信息写入头菜单。 YL 20220120
        },
        onUncheck:function(rowIndex, rowData) {
            $('#operlistBox').datagrid('unselectRow',rowIndex);

        },
        onClickRow: function(rowIndex, rowData) {
            //if(lastselctrowindex!=="")
	        //{
		        //$('#operlistBox').datagrid('uncheckRow',lastselctrowindex);
            //}
         
            //selectPatient(rowData);
            //$('#operlistBox').datagrid('clearSelections');
			//$('#operlistBox').datagrid('selectRow',rowIndex);
            //$('#operlistBox').datagrid('checkRow',rowIndex);
            //lastselctrowindex=rowIndex;
        },
        handler:function(){ //接受改变的值
            $("#operlistBox").datagrid('acceptChanges');
        },
        onBeforeEdit:function(rowIndex,rowData){
            var logLocType=getLogLocType();
            if((logLocType!="OUT"))
            {
                return false;
            }
			if (rowData.VisitStatus==="D") {
				$.messager.alert("提示","该患者已出院不能安排手术间","info");
				return false;
			}
			if (rowData.VisitStatus==="C") {
				$.messager.alert("提示","该患者已退号不能安排手术间","info");
				return false;
			}
        },
		onAfterEdit:function(rowIndex,rowData,changes){
			var opaId=rowData.OPSID;
			//
			if(changes.RoomDesc&&changes.RoomDesc!=undefined)
			{
				var result=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","UpdateOpRoomAndOrdNo",opaId,changes.RoomDesc,session.UserID);
				if((/^(\+|-)?\d+$/.test( result ))&&result>0) 
				{	
					var noproomList=getOpRoomList();
					var showroomdr=changes.RoomDesc;
					var newroom=changes.RoomDesc;
					var newoproomdr="";
						for(var ri=0;ri<noproomList.length;ri++)
						{
							newoproomdr=noproomList[ri].RowId;
							if(newoproomdr==showroomdr)
							{
								newroom=noproomList[ri].Description;
							}
						}

					$("#operlistBox").datagrid('updateRow',{
						index:rowIndex,
						row:{OperSeq:result,StatusDesc:'安排', OperRoom:newoproomdr, RoomDesc:newroom }
						});
				}
				else
				{
					$("#operlistBox").datagrid('reload');	
				}
			}
			//ChangeOperSeq
			if(changes.OperSeq&&changes.OperSeq!=undefined){
				var showroomdr=changes.RoomDesc;
				
				var result=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","ChangeOperSeq",opaId,changes.OperSeq);
				if((/^(\+|-)?\d+$/.test( result ))&&result>0) 
				{	   
					$("#operlistBox").datagrid('updateRow',{
						index:rowIndex,
						row:{OperSeq:changes.OperSeq}
					});
				}
				else
				{
					$("#operlistBox").datagrid('reload');	
				}
			}
			//
			if(changes.PlanSurgeonDesc&&changes.PlanSurgeonDesc!=undefined){
				/*
				var res=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","SaveOutArrInfo",opaId,"PlanSurgeonDesc^"+changes.PlanSurgeonDesc);
				if((/^(\+|-)?\d+$/.test( res ))) 
				{	
					var surgeonList=getSurgeonList();
					var showsurdr=changes.PlanSurgeonDesc;
					var newsur=changes.PlanSurgeonDesc;
					var newsurdr="";
						for(var ri=0;ri<surgeonList.length;ri++)
						{
							newsurdr=surgeonList[ri].CareProvider
							if(newsurdr==showsurdr)
							{
								newsur=surgeonList[ri].CareProvDesc;
							}
						}

					$("#operlistBox").datagrid('updateRow',{
						index:rowIndex,
						row:{PlanSurgeonDesc:newsur }
						});
				}
				else
				{
					$("#operlistBox").datagrid('reload');	
				}
				*/
			}
			//
			if(changes.CircualNurseDesc&&changes.CircualNurseDesc!=undefined){
				var res=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","SaveOutArrInfo",opaId,"CircleNurse^"+changes.CircualNurseDesc);
				if((/^(\+|-)?\d+$/.test( res ))) 
				{	
					var nurseList=getNurseList();
					var showNurdr=changes.CircualNurseDesc;
					var newnur=changes.CircualNurseDesc;
					var newnurdr="";
						for(var rin=0;rin<nurseList.length;rin++)
						{
							newnurdr=nurseList[rin].RowId;
							if(newnurdr==showNurdr)
							{
								newnur=nurseList[rin].Description;
							}
						}

					$("#operlistBox").datagrid('updateRow',{
						index:rowIndex,
						row:{CircualNurseDesc:newnur,CircualNurse:newnurdr }
						});
                }
                else
                {
                    $("#operlistBox").datagrid('reload');	
                }
            }
            //
            $('#operlistBox').datagrid('uncheckAll'); 
        },
        onClickCell:onClickCell,
        onLoadSuccess:function(data){
		}
    });

    //setOperlistBoxColumnDisplay();

    $("#btnCancelOperation").linkbutton({
        onClick:cancelOperation
    });
	
	$("#btnEditOperation").linkbutton({
    	onClick:editOperation
	});

	//202002+dyl
	$("#btnEditDaySurgery").linkbutton({
		onClick:editDaySurgery
	});
	
	$("#btnConfirmDaySurgery").linkbutton({
		onClick:confirmDaySurgery
	});
	
	$("#btnPreDaySurgery").linkbutton({
		onClick:preDaySurgery
	});
	
	$("#btnPostDaySurgery").linkbutton({
		onClick:postDaySurgery
	});
	
	$("#btnMaterialStastics").linkbutton({
		onClick:materialStastics
	});
	
	//202003+dyl
	$("#btnOutDaySurgery").linkbutton({
		onClick:outDaySurgery
	});
	
	$("#btnClearOpArrange").linkbutton({
		onClick:btnClearOpArrange
	});
	
	$("#btnRegOutOper").linkbutton({
		onClick:btnRegOutOper
	});

    $("#btnAuditOperation").linkbutton({
        onClick:function(){
            $.messager.confirm("提示","是否审核所有勾选的手术？",function(r){
                if(r){
                    auditOperation();
                }
            });
        }
    });
}
function getSeqEditorOptions(){
    return {
        min:1,
        max:100
    }
}
function getOperRoomEditorOptions(){
    //var operDeptId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetOutOperDeptID",session.DeptID);
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            var operDeptId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetOutOperDeptID",selectOPSID);
            param.ClassName = ANCLS.BLL.ConfigQueries,
            param.QueryName = "FindOperRoom",
            param.Arg1 = operDeptId,
            param.Arg2 = "",
            param.ArgCnt = 2
        },
        valueField: "RowId",
        textField: "Description",
        panelWidth:100
    }
}
function getSurgeonOptions(){
    return{
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindSurgeonByOper";
            param.Arg1=param.q?param.q:"";
            var surLocId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetPlanSurLocId",selectOPSID);
            param.Arg2=surLocId;
            param.Arg3="Y";
            param.Arg4='';
            param.Arg5="";
            param.ArgCnt=5;
        },
        panelWidth:120,
        valueField: "CareProvider",
        textField: "CareProvDesc",
        mode: "remote"
    }
}
function getNurseOptions(){
    return{
        /*
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindResource";
            param.Arg1=param.q?param.q:"";
            param.Arg2=operDeptId;
            param.Arg3="Y";
            param.Arg4=session.HospID;
            param.Arg5="NURSE";
            param.ArgCnt=5;
        },
        panelWidth:120,
        valueField: "CareProvider",
        textField: "CareProvDesc",
        mode: "remote"*/
        url: ANCSP.DataQuery,
    onBeforeLoad:function(param){
        var operDeptId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetOutOperDeptID",selectOPSID);
        param.ClassName=CLCLS.BLL.Admission;
        param.QueryName="FindCareProvByLoc";
        param.Arg1=param.q?param.q:"";
        param.Arg2=operDeptId;
        param.ArgCnt=2;
    },
    valueField: "RowId",
    textField: "Description",
    panelWidth:120,
    mode: "remote"
    }
}
//获取手术间数据
function getOpRoomList(){
    var operDeptId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetOutOperDeptID",selectOPSID);
    var admDiagnosisList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindOperRoom",
        Arg1:operDeptId,
        Arg2:"",
        ArgCnt:2
    },"json");
    return admDiagnosisList;
}
function getSurgeonList()
{var surLocId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetPlanSurLocId",selectOPSID);
    var admDiagnosisList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindSurgeonByOper",
        Arg1:'',
        Arg2:surLocId,
        Arg3:"Y",
        Arg4:'',
        Arg5:'',
        ArgCnt:5
    },"json");
    return admDiagnosisList;
}
function getNurseList()
{
    var operDeptId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetOutOperDeptID",selectOPSID);
    /*
    var admDiagnosisList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindResource",
        Arg1:'',
        Arg2:operDeptId,
        Arg3:"Y",
        Arg4:'',
        Arg5:'NURSE',
        ArgCnt:5
    },"json");
    return admDiagnosisList;
    */
   var curtmpnurList=dhccl.getDatas(ANCSP.DataQuery,{
    ClassName:CLCLS.BLL.Admission,
    QueryName:"FindCareProvByLoc",
    Arg1:'',
    Arg2:operDeptId,
    ArgCnt:2
   },"json");
   return curtmpnurList;
  
}
var editIndex = undefined;
function endEditing(){
	if (editIndex == undefined){return true}
	var logLocType=getLogLocType();
	if((logLocType!="OUT"))
	{
		return false;
	}
	if ($("#operlistBox").datagrid('validateRow', editIndex)){
		$("#operlistBox").datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function onClickCell(index, field){
	$("#operlistBox").datagrid('selectRow',index);
    var selectRowObj=$("#operlistBox").datagrid('getSelected');
    
	var seldylindex=$("#operlistBox").datagrid('getRowIndex',selectRowObj);
	if(index!=seldylindex)
	{
		$("#operlistBox").datagrid("unselectRow",seldylindex);
		$("#operlistBox").datagrid("selectRow",index);
		selectRowObj=$("#operlistBox").datagrid('getSelected');
    }
    selectOPSID=selectRowObj.OPSID;
    var statusn=selectRowObj.StatusDesc;
    
    var logLocType=getLogLocType();
	var logUserType=getLogUserType();
	
	if (endEditing()&&(logUserType=="OPNURSE")){
		if((field != 'RoomDesc')&(field != 'OperSeq')&&(field!='PlanSurgeonDesc')&&(field!='CircualNurseDesc'))
        {
            return false;
        }
       
        if((field == 'OperSeq') && (statusn != '安排'))
		{
			//$.messager.alert("提示","只能操作状态为安排或申请的手术!","error");
			return false;
        }
        if((field == 'CircualNurseDesc')&& (statusn != '安排'))
		{
			//$.messager.alert("提示","只能操作状态为安排的手术!","error");
			return false;
        }
        else{}
        if((field == 'PlanSurgeonDesc')&& (statusn != '安排'))
		{
			//$.messager.alert("提示","只能操作状态为安排的手术!","error");
			return false;
		}
		if (field == 'RoomDesc') {
			var value = selectRowObj.RoomDesc;
			if (value == '无') {
				$.messager.alert("提示","请首先安排手术间!","error");
				return false;
			}
			if((statusn != '申请') && (statusn != '安排') && (statusn != '审核')) 
			{ 
				$.messager.alert("提示","只能操作安排或申请状态的手术!","error");
				return false;
			}
        }
       $("#operlistBox").datagrid('selectRow', index).datagrid('editCell', {index:index,field:field});
			editIndex = index;
    }
}

//获取科室类型
function getLogLocType(){
    var logLocType="App";
    var logLocType=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetIfOutOperLoc",session.ExtDeptID);
    return logLocType;
}
//获取登录用户类型
function getLogUserType(){
    var logUserType="";
    var userType=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetUserType",session.UserID);
    var locFlag=getLogLocType();
    if(locFlag=="OUT")
    {
        if (userType=="NURSE")  logUserType="OPNURSE";
    }
    return logUserType;
}
//获取台次数据
function getOrdNo(){
	var maxOrdNo=30
	var data=new Array();
	for(var i=0;i<maxOrdNo;i++)
	{
		var no=i+1;
		var obj=new Object();
		obj={
			code:no,
			desc:no
			}
		data[i]=obj;
	}
	return data;	
}

function setOperlistBoxColumnDisplay(){
    
    var testIcon=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetIfOutOperLoc",session.DeptID);
    if(testIcon=="OUT")
    {
        $("#operlistBox").datagrid("enableGridSetting",{clickHandler:function(columnOptList){
        var columnEditor=new DataGridEditor({
            title:"手术列表",
            data:columnOptList,
            moduleId:session.ModuleID,
            elementId:"operlistBox",
            closeCallBack:function(){
                window.location.reload();
            }
        });
        columnEditor.open();
        }});
    }   
}

function initCancelReasonDialog(){
    $("#ReasonOptions").combobox({
        textField:"text",
        valueField:"value",
        editable:false,
        data:[{
            text:"患者要求",
            value:"患者要求"
        },{
            text:"手术条件不具备",
            value:"手术条件不具备"
        }],
        onSelect:function(record){
            var reason=$("#CancelReason").val();
            if(reason){
				if(reason.indexOf(record.text) === -1){
					reason+=",";
					reason+=record.text;
					$("#CancelReason").val(reason);
					$(this).combobox("clear");
				}
				else{
					$.messager.alert("提示",record.text+"已选择","info")
					$(this).combobox("clear");
				}
            }
			else{
				reason+=record.text;
				$("#CancelReason").val(reason);
				$(this).combobox("clear");
			}
        }
    });

    $("#btnExitReason").linkbutton({
        onClick:function(){
            $("#CancelReason").val("");
            $("#ReasonOptions").combobox("clear");
            $("#operCancelReason").dialog("close");
        }
    });

    $("#operCancelReason").dialog({
        buttons:[{
            id:"btnSaveReason",
            text:"保存",
            handler:function(){

            },
            iconCls:'icon-w-save'
        }]
    });

    $("#btnSaveReason").linkbutton({
        onClick:function(){
            var selectedData=$("#operlistBox").datagrid("getSelected");
            var opsId=selectedData.OPSID;
            var cancelUserId=session.ExtUserID;
            var reason=$("#CancelReason").val();
            var ret=dhccl.runServerMethod(ANCLS.BLL.DaySurgery,"CancelOutOperation",opsId,reason,cancelUserId);
            if(ret.success){
                $.messager.alert("提示","取消手术成功","info",function(){
                    $("#CancelReason").val("");
                    $("#ReasonOptions").combobox("clear");
                    $("#operCancelReason").dialog("close");
                    $("#operlistBox").datagrid("reload");
                });
            }else{
                $.messager.alert("提示","取消手术失败，原因："+ret.result,"error");
            }
        }
    });
}

function initActionPermission(){
    //$(".hisui-linkbutton").linkbutton("disable");
    var actionPermissions=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindActionPermission",
        Arg1:session.GroupID,
        Arg2:session.ModuleID,
        Arg3:"Y",
        ArgCnt:3
    },"json");
    var AuditOperations=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindDataConfigurations",
        Arg1:"",
        ArgCnt:1
    },"json");
    if(actionPermissions && actionPermissions.length>0){
        for(var i=0;i<actionPermissions.length;i++){
            var actionPermission=actionPermissions[i];
            //审核手术按钮受手术申请配置控制 YuanLin 20200212
            //if((actionPermission.ElementID=="btnAuditOperation")&(AuditOperations[8].DataKey=="NeedAuditOperation")&(AuditOperations[8].DataValue=="N")) continue;
            // 不需要审核按钮，只要把按钮移除 CCQ 20200220
            if((actionPermission.ElementID=="btnAuditOperation")&(AuditOperations[8].DataKey=="NeedAuditOperation")&(AuditOperations[8].DataValue=="N")){
                $("#"+actionPermission.ElementID).remove();
            }
            //$("#"+actionPermission.ElementID).linkbutton("enable");
        }

        $(".hisui-linkbutton").each(function(index,item){
            var id=$(item).attr("id");
            var permission=getActionPermssion(id);
            if(!permission){
                $(item).remove();
            }
        });
    }else{
        $(".hisui-linkbutton").each(function(index,item){
            $(item).remove();
        });
    }

    function getActionPermssion(elID){
        var result=null;
        if(actionPermissions && actionPermissions.length>0){
            for(var actionIndex=0;actionIndex<actionPermissions.length;actionIndex++){
                permission=actionPermissions[actionIndex];
                if(permission.ElementID===elID){
                    result=permission;
                }
            }
        }
        return result;
    }
}

/**
 * 查询手术列表
 */
function queryOperList(){
    $("#operlistBox").datagrid("reload");
}

/**
 * 导出手术列表
 */
function exportOperList(){
    var rows=$("#operlistBox").datagrid("getChecked");
    if (!rows || rows.length<1){
        $.messager.alert("提示","请先选勾选需要导出的手术，再进行操作。","warning");
        return;
    }
    var columnFields=$("#operlistBox").datagrid("getColumnFields");
    if(!columnFields || columnFields.length<1) return;
    var aoa=[],     // array of array
        fieldArray=[];
    for(var fieldInd=0;fieldInd<columnFields.length;fieldInd++){
        var columnField=columnFields[fieldInd];
        var columnOpts=$("#operlistBox").datagrid("getColumnOption",columnField);
        fieldArray.push(columnOpts.title);
    }
    aoa.push(fieldArray);
    for(var i=0;i<rows.length;i++){
        var row=rows[i],
            valueArray=[];
        for(var j=0;j<columnFields.length;j++){
            var columnField=columnFields[j];
            var columnOpts=$("#operlistBox").datagrid("getColumnOption",columnField);
            valueArray.push(row[columnOpts.field] || '');
        }
        aoa.push(valueArray);
    }
    if (aoa.length>0 && window.excelmgr){
        window.excelmgr.aoa2excel(aoa,"手术列表.xlsx");
    }
}

/**
 * 作废手术申请
 */
function cancelOperation(){
	var selectedData = $("#operlistBox").datagrid("getSelections");
    if(selectedData.length ===0){
        $.messager.alert("提示","请先选择手术记录，再取消手术。","warning");
        return;
    }
	if (selectedData.length > 1) {
		$.messager.alert(
          "提示",
          "请选择单条手术进行操作，不能取消多条。",
          "warning"
        );
        return;
    }
    var canCancelOperation=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"CanCancelOperation",selectedData[0].OPSID,session.UserID,session.GroupID,"btnCancelOperation");
    if(canCancelOperation.indexOf("E^")===0){
        $.messager.alert("提示",canCancelOperation,"warning");
        return;
    }
 
    $("#operCancelReason").dialog("open");
}

//202002+dyl
function editDaySurgery()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var actionPermission=operationListConfig.getActionPermission(session.GroupID,session.ModuleID,"btnEditDaySurgery");
    if(actionPermission.OperStatusCode.indexOf(selectedData.StatusCode)<0){
        $.messager.alert("提示","当前安全组或当前状态无修改手术的权限。","warning");
        return;
    }

    var url="CIS.AN.DaySurgeryApp.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID+"&IsConfirm="+"N";
    //var url="CIS.AN.DaySurgeryApp.csp?opsId="+''+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID+"&IsConfirm="+"";
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#editDaySurgeryApp").dialog({
        content:href,
        title:selectedData.PatName+"的日间手术修改",
        iconCls:"icon-w-edit",
	    resizable:true,
		height:600,
		width:1200
    });
    
    $("#editDaySurgeryApp").dialog("open");
}
//202003+dyl+门诊手术修改
function editOperation()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var actionPermission=operationListConfig.getActionPermission(session.GroupID,session.ModuleID,"btnEditOperation");
    if(actionPermission.OperStatusCode.indexOf(selectedData.StatusCode)<0){
        $.messager.alert("提示","当前安全组或当前状态无修改手术的权限。","warning");
        return;
    }
    var url="CIS.AN.OutOperApp.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#OutOperShow").dialog({
        content:href,
        title:selectedData.PatName+"的门诊手术修改",
        iconCls:"icon-w-edit",
	    resizable:true,
		height:650,
		width:1200
    });
    
    $("#OutOperShow").dialog("open");
}
//
function confirmDaySurgery()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var actionPermission=operationListConfig.getActionPermission(session.GroupID,session.ModuleID,"btnConfirmDaySurgery");
    if(actionPermission.OperStatusCode.indexOf(selectedData.StatusCode)<0){
        $.messager.alert("提示","当前安全组或当前状态无修改手术的权限。","warning");
        return;
    }

    var url="CIS.AN.DaySurgeryApp.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID+"&IsConfirm="+"Y";
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#editDaySurgeryApp").dialog({
        content:href,
        title:selectedData.PatName+"的日间手术确认",
        iconCls:"icon-w-edit",
	    resizable:true,
		height:700
    });
    
    $("#editDaySurgeryApp").dialog("open");
}
function closeDaySurgeryDialog()
{
    $("#editDaySurgeryApp").dialog("close");
    $("#operlistBox").datagrid("clearSelections");
    $("#operlistBox").datagrid("reload");
}
function closePreDaySurgery()
{
    $("#PreDaySurgery").dialog("close");
    $("#operlistBox").datagrid("clearSelections");
    $("#operlistBox").datagrid("reload");
}

function closeOutOperDialog()
{
    $("#OutOperShow").dialog("close");
    $("#operlistBox").datagrid("clearSelections");
    $("#operlistBox").datagrid("reload");
}
function preDaySurgery()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var curStatus=selectedData.DaySurgery;
    if(curStatus!="Y"){
        $.messager.alert("提示","请先选择日间手术，再进行修改。","warning");
        return;
    }
    var actionPermission=operationListConfig.getActionPermission(session.GroupID,session.ModuleID,"btnPreDaySurgery");
    if(actionPermission.OperStatusCode.indexOf(selectedData.StatusCode)<0){
        $.messager.alert("提示","当前安全组或当前状态无修改手术的权限。","warning");
        return;
    }

    var url="CIS.AN.DaySurgeryPreAccess.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#PreDaySurgery").dialog({
        content:href,
        title:selectedData.PatName+"的日间麻醉术前评估",
        iconCls:"icon-w-edit",
	    resizable:true,
		height:640
    });
    
    $("#PreDaySurgery").dialog("open");
}
function postDaySurgery()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var curStatus=selectedData.DaySurgery;
    if(curStatus!="Y"){
        $.messager.alert("提示","请先选择日间手术，再进行修改。","warning");
        return;
    }
    var actionPermission=operationListConfig.getActionPermission(session.GroupID,session.ModuleID,"btnPostDaySurgery");
    if(actionPermission.OperStatusCode.indexOf(selectedData.StatusCode)<0){
        $.messager.alert("提示","当前安全组或当前状态无修改手术的权限。","warning");
        return;
    }

    var url="CIS.AN.DaySurgeryPost.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#PreDaySurgery").dialog({
        content:href,
        title:selectedData.PatName+"的日间恢复评估",
        iconCls:"icon-w-edit",
	    resizable:true,
		height:700
    });
    
    $("#PreDaySurgery").dialog("open");
}
function outDaySurgery()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var curStatus=selectedData.DaySurgery;
    if(curStatus!="Y"){
        $.messager.alert("提示","请先选择日间手术，再进行修改。","warning");
        return;
    }
    var actionPermission=operationListConfig.getActionPermission(session.GroupID,session.ModuleID,"btnOutDaySurgery");
    if(actionPermission.OperStatusCode.indexOf(selectedData.StatusCode)<0){
        $.messager.alert("提示","当前安全组或当前状态无修改手术的权限。","warning");
        return;
    }

    var url="CIS.AN.DaySurgeryOut.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#PreDaySurgery").dialog({
        content:href,
        title:selectedData.PatName+"的日间出院评估",
        iconCls:"icon-w-edit",
	    resizable:true,
		height:700
    });
    
    $("#PreDaySurgery").dialog("open");
}
function materialStastics()
{
    var url="CIS.AN.MaterialStastics.csp?";
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#MaterialStastics").dialog({
        content:href,
        title:"器械材料统计",
        iconCls:"icon-result",
	    resizable:true,
		height:700
    });
    
    $("#MaterialStastics").dialog("open");
}
function btnClearOpArrange()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var curStatus=selectedData.StatusDesc;
    if(curStatus!="安排")
    {
        $.messager.alert("提示","不可对此状态修改。","warning");
        return;
    }
    var ret=dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery,"RevokeArrange",selectedData.OPSID,session.UserID);
    $("#operlistBox").datagrid("reload");
}
function btnRegOutOper()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var actionPermission=operationListConfig.getActionPermission(session.GroupID,session.ModuleID,"btnRegOutOper");
    if(actionPermission.OperStatusCode.indexOf(selectedData.StatusCode)<0){
        $.messager.alert("提示","当前安全组或当前状态无权限,请重新选择。","warning");
        return;
    }
    var url="CIS.AN.OutOperReg.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#OutOperShow").dialog({
        content:href,
        title:selectedData.PatName+"的门诊手术登记",
        iconCls:"icon-w-edit",
	    resizable:true,
		height:650,
        width: 1200
    });
    
    $("#OutOperShow").dialog("open");
}

//-------------------
function auditOperation(){
    var selectedRows=$("#operlistBox").datagrid("getSelections");
    if(!selectedRows || selectedRows.length<1){
        $.messager.alert("提示","请先选择手术记录，再审核手术。","warning");
        return;
    }
    var opsIdArr=[];
	var operRows="" //20191211 YuanLin 只有申请状态的手术允许审核
    for(var i=0;i<selectedRows.length;i++){
		if(selectedRows[i].StatusDesc!="申请"){
			if(operRows=="") operRows=i+1;
			else operRows=operRows+","+(i+1);
			continue;
		}
        opsIdArr.push(selectedRows[i].OPSID);
    }
    var opsIdStr=opsIdArr.join(";");
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"AuditOperation",opsIdStr,session.UserID);
    if(ret.success){
        if(operRows=="")$.messager.alert("提示","审核手术成功","info");
		if(operRows!=""){
			$.messager.alert("提示","其余手术审核成功","info");
			$.messager.alert("提示","其中所勾选手术中第"+operRows+"条手术非申请状态不予审核!","warning");
		}
        $("#operlistBox").datagrid("reload");
    }else{
        $.messager.alert("提示","审核手术失败，原因："+ret.result,"error");
		if(operRows!="") $.messager.alert("提示","所勾选手术中第"+operRows+"条手术非申请状态不予审核!","warning");
    }
}
//202003+dyl
function printOutOper()
{
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择一条手术记录，再进行打印。","warning");
        return;
    }
    var actionPermission=operationListConfig.getActionPermission(session.GroupID,session.ModuleID,"btnPrintOutOper");
    if(actionPermission.OperStatusCode.indexOf(selectedData.StatusCode)<0){
        $.messager.alert("提示","当前安全组或当前状态无打印权限。","warning");
        return;
    }
    var outOperscheduleTmp=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.OperScheduleList,
            QueryName:"FindOperScheduleList",
            Arg1:"",
            Arg2:"",
            Arg3:"",
            Arg4:selectedData.OPSID,
            Arg5:"",
            Arg6:"",
            Arg7:"",
            Arg8:"",
            Arg9:"",
            Arg10:"",
           	Arg11:"",
            Arg12:"",
            Arg13:"",
            ArgCnt:13
    },"json");
    var intoutoper="";
    if(outOperscheduleTmp && outOperscheduleTmp.length>0)
    {
        for(var intout=0;intout<outOperscheduleTmp.length;intout++)
        {
            intoutoper=outOperscheduleTmp[intout];
         
        }
    }
    var LODOP = getLodop();
    LODOP.PRINT_INIT("OutOper"+selectedData.OPSID);    //初始化表单
    LODOP.PRINT_INITA(0,0,750,"100%","OutOper"+selectedData.OPSID);
	LODOP.SET_PRINT_MODE("PRINT_DUPLEX",2);
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printCount;
    
    createOutPrintOnePage(LODOP,intoutoper);
    LODOP.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
    LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
    LODOP.PREVIEW();
}
function createOutPrintOnePage(LODOP,operSchedule) {  
    var prtConfig=sheetPrintConfig,
        logoMargin=prtConfig.logo.margin,
        logoSize=prtConfig.logo.size,
        titleFont=prtConfig.title.font,
        titleSize=prtConfig.title.size,
        titleMargin=prtConfig.title.margin,
        contentSize=prtConfig.content.size,
        contentFont=prtConfig.content.font;
        LODOP.SET_PRINT_PAGESIZE(prtConfig.paper.direction, 0, 0, prtConfig.paper.name);
    //lodop.SET_PRINT_STYLE("FontSize", contentFont.size);
    //lodop.SET_PRINT_STYLE("FontName", contentFont.name);
    //lodop.ADD_PRINT_IMAGE(logoMargin.top,logoMargin.left,logoSize.width,logoSize.height,"<img src='"+prtConfig.logo.imgSrc+"'>");
   // lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
   
    var startPos={
        x:prtConfig.paper.margin.left,
        y:logoMargin.top+logoSize.height+logoMargin.bottom+20
    };
    var tmpwidth=5;
    LODOP.ADD_PRINT_RECT(10,10,740+tmpwidth,45,0,1);     //第1行
    
    LODOP.ADD_PRINT_TEXT(20, startPos.x, "100%", 30, session.ExtHospDesc);
    LODOP.SET_PRINT_STYLEA(0, "FontName", titleFont.name);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", titleFont.size);
    
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);

    LODOP.ADD_PRINT_RECT(55,10,740+tmpwidth,40,0,1);     //第2行
    
    LODOP.ADD_PRINT_TEXT(65, startPos.x, "100%", 30, "门诊手术预约单");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    //----
    //lodop.ADD_PRINT_RECT(90,10,775,40,0,1);    //第3行
    //lodop.SET_PRINT_STYLE("FontSize",18);
    
    LODOP.SET_PRINT_STYLE("FontSize",16);
    LODOP.SET_PRINT_STYLE( "FontName", "宋体");
    LODOP.ADD_PRINT_RECT(95,10,100,45,0,1);    //第3行 1
    LODOP.ADD_PRINT_TEXT(107, 15, 100, 30, "患者姓名");
    LODOP.ADD_PRINT_RECT(95,110,160,45,0,1);    //第3行 2
    LODOP.ADD_PRINT_TEXT(107, 120, 180, 30, (operSchedule?operSchedule.PatName:""));
    
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
     var admDiagnosisList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:CLCLS.BLL.Admission,
        QueryName:"FindAdmDiagnosis",
        Arg1:operSchedule.EpisodeID,
        Arg2:"OP",
        ArgCnt:2
    },"json");
    var singlediag="";
    if(admDiagnosisList && admDiagnosisList.length>0)
    {
        for(var intdiag=0;intdiag<admDiagnosisList.length;intdiag++)
        {
            var diagstr=admDiagnosisList[intdiag];
           if(singlediag!="") singlediag=singlediag+","+diagstr.ICDCodeDesc;
           else singlediag=diagstr.ICDCodeDesc;
        }
    }
   
    LODOP.ADD_PRINT_RECT(275,10,100,45,0,1);    //第7行
    LODOP.ADD_PRINT_TEXT(287, 15, 110, 30, "诊    断");
    LODOP.ADD_PRINT_RECT(275,110,640+tmpwidth,45,0,1);    //第6行
    LODOP.ADD_PRINT_TEXT(287, 120, 640, 30, singlediag);
     //----
     LODOP.ADD_PRINT_RECT(320,10,100,45,0,1);    //第8行
     LODOP.ADD_PRINT_TEXT(332, 15, 110, 30, "手术名称");
     LODOP.ADD_PRINT_RECT(320,110,640+tmpwidth,45,0,1);    //第6行
    LODOP.ADD_PRINT_TEXT(332, 120, 640, 30, (operSchedule?operSchedule.OperDesc:""));
     //----
     LODOP.ADD_PRINT_RECT(365,10,100,45,0,1);    //第9行
     LODOP.ADD_PRINT_TEXT(377, 15, 100, 30, "手术医师");
     LODOP.ADD_PRINT_RECT(365,110,100,45,0,1);    //第9行
     LODOP.ADD_PRINT_TEXT(377, 115, 100, 30, (operSchedule?operSchedule.SurgeonDesc:""));
    
     LODOP.ADD_PRINT_RECT(365,210,100,45,0,1);    //第9行
     LODOP.ADD_PRINT_TEXT(377, 215, 100, 30, "手术科室");
     LODOP.ADD_PRINT_RECT(365,310,190,45,0,1);    //第9行
     LODOP.ADD_PRINT_TEXT(377, 315, 185, 30, (operSchedule?operSchedule.OperDeptDesc:""));

     LODOP.ADD_PRINT_RECT(365,500,250+tmpwidth,45,0,1);    //第9行
     LODOP.ADD_PRINT_TEXT(377, 515, 270, 30, "预约时间");

     LODOP.ADD_PRINT_RECT(410,500,250+tmpwidth,45,0,1);    //第9行
     LODOP.ADD_PRINT_TEXT(422, 535, 220, 30, (operSchedule?operSchedule.OperDate:"")+" "+(operSchedule?operSchedule.OperTime:"").substring(0,5));
     //----
     LODOP.ADD_PRINT_RECT(410,10,100,45,0,1);    //第10行
     LODOP.ADD_PRINT_TEXT(422, 15, 100, 30, "申请医师");
     LODOP.ADD_PRINT_RECT(410,110,100,45,0,1);    //第10行
     LODOP.ADD_PRINT_TEXT(422, 115, 100, 30, (operSchedule?operSchedule.AppCareProvDesc:""));
     LODOP.ADD_PRINT_RECT(410,210,100,45,0,1);    //第9行
     LODOP.ADD_PRINT_TEXT(422, 215, 100, 30, "申请科室");
     LODOP.ADD_PRINT_RECT(410,310,190,45,0,1);    //第9行
     LODOP.ADD_PRINT_TEXT(422, 315, 190, 30, (operSchedule?operSchedule.AppDeptDesc:""));
    
     LODOP.ADD_PRINT_RECT(455,500,250+tmpwidth,45,0,1);    //第9行
     LODOP.ADD_PRINT_TEXT(467, 515, 250, 30, "申请时间");

    LODOP.ADD_PRINT_RECT(500,500,250+tmpwidth,45,0,1);    //第9行
    LODOP.ADD_PRINT_TEXT(512, 535, 220, 30, (operSchedule?operSchedule.AppDateTime:"").substring(0,16));

    //----
    LODOP.SET_PRINT_STYLE( "FontName", "黑体");
    LODOP.ADD_PRINT_RECT(455,10,100,250,0,1);    //第11行
    LODOP.ADD_PRINT_TEXT(467, 15, 100, 200, "患者须知");
    LODOP.SET_PRINT_STYLE( "FontName", "宋体");
    LODOP.ADD_PRINT_RECT(455,110,390,250,0,1);    //第11行
    LODOP.ADD_PRINT_TEXT(467, 120, 370, 250, (operSchedule?operSchedule.PatNeedNotice:""));

    LODOP.SET_PRINT_STYLE( "FontName", "黑体");
    LODOP.ADD_PRINT_RECT(545,500,250+tmpwidth,45,0,1);    //第9行
    LODOP.ADD_PRINT_TEXT(557, 515, 250, 30, "来院时间");
    //lodop.SET_PRINT_STYLE( "FontName", "宋体");
    //
    LODOP.ADD_PRINT_RECT(590,500,250+tmpwidth,115,0,1);    //第9行
    var comDateStr=(operSchedule?operSchedule.OperDate:"")+" "+(operSchedule?operSchedule.ComeHosTime:"");
   
    LODOP.ADD_PRINT_TEXT(612, 535, 300, 30, comDateStr);
    //SET_PRINT_STYLE(strStyleName,varStyleValue)
    //ADD_PRINT_TEXT(Top,Left,Width,Height,strContent)增加纯文本打印项
    startPos.y+=titleSize.height+titleMargin.bottom;
    var lineHeight=20;
    
    LODOP.SET_PRINT_STYLE("FontSize",12);
   
    var anaestMethodInfo=operSchedule?operSchedule.AnaestMethodInfo:""
    if (!anaestMethodInfo || anaestMethodInfo===""){
        anaestMethodInfo=operSchedule?operSchedule.PrevAnaMethodDesc:"";
    }
    startPos.y+=lineHeight;
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "手术日期:"+(operSchedule?operSchedule.OperDate:""));
    //var operInfo="这里取手术名称";
    LODOP.SET_PRINT_STYLE("FontSize",12);
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "手术方式：");
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+70, 470, 30, operSchedule?operSchedule.OperDesc:"");

    //startPos.y+=lineHeight+(operInfo.length>40?25:0);
  
}
function replacePos(strObj, pos, replacetext)
{
var str = strObj.substr(0, pos-1) + replacetext + strObj.substring(pos+6, strObj.length);
return str;
}
//---------------
function printOperations(){
    var rows=$("#operlistBox").datagrid("getChecked");
    if (!rows || rows.length<1){
        $.messager.alert("提示","请先选勾选需要打印的手术，再进行操作。","warning");
        return;
    }
    var Auditret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"CheckIsNeedAuditAudit");
    //alert(Auditret.result)
    var canPrintRows=[];
    for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
        const row = rows[rowIndex];
        if(row.StatusCode!=="Application" && row.StatusCode!=="Audit") continue;
        if(Auditret.result=="Y" && row.StatusCode!=="Audit") continue;
       // alert(row.StatusCode)
        canPrintRows.push(row);
    }

    

    if ((!canPrintRows || canPrintRows.length<1)&&Auditret.result!=="Y"){
        $.messager.alert("提示","只能打印申请或审核状态的手术。","warning");
        return;
    }
    if ((!canPrintRows || canPrintRows.length<1)&&Auditret.result=="Y"){
        $.messager.alert("提示","只能打印审核状态的手术。","warning");
        return;
    }
    var firstRow=canPrintRows[0];

    var LODOP=getLodop();
    LODOP.PRINT_INIT("手术通知单");
    // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "SSS");
    LODOP.SET_PRINT_PAGESIZE("2", "", "", "A4");
    LODOP.ADD_PRINT_TEXT(25, 250, 500, 40, session.DeptDesc+"手术通知单");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
    LODOP.ADD_PRINT_TEXT(65, 20, "100%", 28, "科室：" + session.DeptDesc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(65, 400, "100%", 28, "日期：" + firstRow.OperDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(65, 700, "100%", 28, "总计：" + canPrintRows.length+"台手术");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(65, 900, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);

    var columns=[{
        title:"姓名",
        field:"PatName",
        width:30,
        uom:"pt"
    },{
        title:"性别",
        field:"PatGender",
        width:30,
        uom:"pt"
    },{
        title:"年龄",
        field:"PatAge",
        width:30,
        uom:"pt"
    },{
        title:"病区",
        field:"PatWardDesc",
        width:84,
        uom:"pt"
    },{
        title:"床位",
        field:"PatBedCode",
        width:30,
        uom:"pt"
    },{
        title:"台次",
        field:"PlanOperSeq",
        width:30,
        uom:"pt"
    },{
        title:"术前诊断",
        field:"PrevDiagnosis",
        width:126,
        uom:"pt"
    },{
        title:"手术名称",
        field:"OperDesc",
        width:126,
        uom:"pt"
    },{
        title:"主刀",
        field:"SurgeonDesc",
        width:45,
        uom:"pt"
    },{
        title:"助手",
        field:"PlanAsstDesc",
        width:84,
        uom:"pt"
    },{
        title:"感染",
        field:"InfectionOper",
        width:30,
        uom:"pt"
    },{
        title:"抗生素",
        field:"Antibiosis",
        width:45,
        uom:"pt"
    },{
        title:"器械",
        field:"SurgicalMaterials",
        width:84,
        uom:"pt"
    },{
        title:"耗材",
        field:"HighConsume",
        width:84,
        uom:"pt"
    },{
        title:"备注",
        field:"OperNote",
        width:84,
        uom:"pt"
    }];

    var totalWidth=0;
    for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
        const element = columns[columnIndex];
        totalWidth+=element.width;
    }
    var htmlArr=[
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;} table{table-layout:fixed;}</style>",
        "<table style='"+totalWidth+"pt'><thead><tr>"
    ];

    for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
        const column = columns[columnIndex];
        htmlArr.push("<th width='"+column.width+column.uom+"'>"+column.title+"</th>");
    }

    htmlArr.push("</tr></thead><tbody>");

    for (var rowIndex = 0; rowIndex < canPrintRows.length; rowIndex++) {
        const row = canPrintRows[rowIndex];
        htmlArr.push("<tr>");
        for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
            const column = columns[columnIndex];
            htmlArr.push("<td>"+(row[column.field] || '')+"</td>");
        }
        htmlArr.push("</tr>");
    }
    htmlArr.push("</tbody></table>");
    LODOP.ADD_PRINT_TABLE(90, 10, totalWidth+"pt", "100%", htmlArr.join(""));
    LODOP.PREVIEW();
}

function closeOperEditDialog(){
    $("#OutOperShow").dialog("close");
    $("#operlistBox").datagrid("clearSelections");
    $("#operlistBox").datagrid("reload");
}

function selectPatient(patOperData){
    if (patOperData) {
        //var eprmenu = window.parent.top.frames["eprmenu"];
        var isSet = false;
        // if (eprmenu) {
        var frm = window.parent.parent.document.forms['fEPRMENU'];
        if (frm) {
            frm.PatientID.value = patOperData.PatientID;
            frm.EpisodeID.value = patOperData.EpisodeID;
            frm.mradm.value = patOperData.MRAdmID;
            if (frm.AnaesthesiaID)
                frm.AnaesthesiaID.value = patOperData.ExtAnaestID;
            isSet = true;
        }
        if (isSet == false) {
            var frm = dhcsys_getmenuform();
            if (frm) {
                frm.PatientID.value = patOperData.PatientID;
                frm.EpisodeID.value = patOperData.EpisodeID;
                frm.mradm.value = patOperData.MRAdmID;
                if (frm.AnaesthesiaID)
                    frm.AnaesthesiaID.value = patOperData.ExtAnaestID;
            }
        }
        //}
    }
}

function getOperClass(operClassStr){
    var operClassArr=operClassStr.split(",")
    var classDescs=["I级","II级","III级","IV级"];
    var classes=[1,2,3,4];
    var retClass=0;
    if(operClassArr && operClassArr.length>0){
        for (var i = 0; i < operClassArr.length; i++) {
            const operClassDesc = operClassArr[i];
            if(classDescs.indexOf(operClassDesc)>=0){
                var operClass=classes[classDescs.indexOf(operClassDesc)];
                if(operClass>retClass){
                    retClass=operClass;
                }
            }
        }
    }

    return retClass;
}
//点日间手术
function DayOrOut(event,value)
{
	
	if(value=true)
	{
		$("#IsOutOper").checkbox('setValue',false);
	}
}
//点击门诊手术
function OutOrDay(event,value)
{
	if(value=true)
	{
		$("#chkIsDayOper").checkbox('setValue',false);
	}
}

/*
function initColumns(columns,columnsConfig)
{
    for(var i=0;i<columns.length;i++)
    {
        for(var j=0;j<columnsConfig.length;j++)
        {
            var test=columns[i].field;
            var test1=columnsConfig[j].field;
            if(columns[i].field==columnsConfig[j].field)
            {
                if(columnsConfig[j].hidden=="true") columns[i].hidden=true;
                if(columnsConfig[j].sortable=="true") columns[i].sortable=true;
                columns[i].width=columnsConfig[j].width;
                columns[i].SeqNo=columnsConfig[j].SeqNo;
            }
        
        }
    }
    columns.sort(function(a,b){
        return a.SeqNo - b.SeqNo;
    });
}
*/
$(document).ready(initPage);