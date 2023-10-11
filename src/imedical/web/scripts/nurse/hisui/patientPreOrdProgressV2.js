var GV = {
    PfBarInfo: "",
}
$(function(){
	initOrdListGrid();
	$cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "GetPatBookingList",
        RegNo: "",
        BookNo: BookNo,
        AppState:5
    }, function(data) {
        if (data.total == 0) {
            $.messager.popover({ msg: '未能查询到有效的住院证信息', type: 'success', timeout: 1000 });
        } else {
            GV.PfBarInfo = data.bookList[0];
            setPfBar();
            setBookInfo();
        }
    });
})
function initOrdListGrid(){
	if (SearchOrdType =="L"){
		LoadLabOrdGrid();
	}else if(SearchOrdType =="Exam"){
		LoadExamOrdGrid();
	}else{
		LoadFlowChart();	
	}
}
function LoadFlowChart(){
	var JsonFlowChart=tkMakeServerCall("Nur.InService.AppointManageV2","getPatFlowChartInfo",BookNo);	
	if(JsonFlowChart!=""){	
		var DataArray=JsonFlowChart.split("^");
		var NodeNum=DataArray[1];
		var JsonFlowChart=DataArray[0];
		var FlowChartOBJECT=($.parseJSON(JsonFlowChart))
		$("#FlowChartShow").hstep({
        	showNumber:false,
        	stepWidth:200,
        	currentInd:parseInt(NodeNum),
        	onSelect:function(ind,item){console.log(item);},
        	//titlePostion:'top',
        	items:FlowChartOBJECT
    	});
	}
}
function LoadLabOrdGrid(){
	var LabOrdColumns=[[    
		{field:'Index', hidden:true},
		{title:'状态',field:'Title',width:150},
		{title:'医嘱名称',field:'ARCIMDesc',width:300},
		{title:'医嘱名称',field:'TestSetName',width:250,hidden:true},
		{title:'状态',field:'Status',hidden:true},
		{title:'医嘱id',field:'OrderId',width:90,hidden:true},
		{title:'报告id',field:'ReportId',width:90,hidden:true},
		{title:'检验号',field:'VisitNumber',width:110,hidden:true},
		{title:'采血时间',field:'SpecCollDate',width:90},
		{title:'申请时间',field:'RequestTime',width:90,hidden:true},
		{title:'接收时间',field:'ReceiveTime',width:90},
		{title:'报告时间',field:'ReportTime',width:90},
		{title:'报告链接',field:'labReportLink',width:70,
			formatter:function(value,rec){
 				var BtnHTML="";
 				 ///已申请 1 ，已接收 2 ，已报告 3
 				if (rec.Status!="3"){
	 				return BtnHTML;
	 			}else{
		 			var BtnHTML = '<a class="editcls" onclick="OpenLabReport(\'' + rec.OrderId + '\')">'+$g("操作")+'</a>';
		 		}
		       return BtnHTML;
            }
		}
    ]];
   
	$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"GetLabGridData",
	    EpisodeID:EpisodeIDTo,
		UserId:session['LOGON.USERID']
	},function(val){
		var GridData=eval('(' + val + ')'); 
		$('#LabOrdGrid').treegrid({
			height:347,
		    data:GridData,
		    idField:'Index',
		    treeField:'Title',
		    fit : false,
		    border: false,
		    columns:LabOrdColumns,
		    onLoadSuccess:function(row, data){
			    SetSummaryInfo(data);
			}
		});
	});
}
///检查医嘱分类树状列表
function LoadExamOrdGrid(){
	var ExamOrdColumns=[[    
		{field:'Index', hidden:true},
		{title:'状态',field:'Title',width:90},
        {field:'OEORowid',hidden:true},
        {title:'医嘱项名称',field:'ItemDesc',width:300},
        {title:'部位/标本',field:'BodyPart',width:150},
        {title:'检查号',field:'StudyNo',width:60,hidden:true},
        {title:'执行科室',field:'ExecuteLoc',width:80},
        {title:'状态',field:'ReportStatus',hidden:true},
        {title:'时间',field:'DateTime',width:150},
        {title:'医师',field:'AppDoc',width:80,hidden:true},
        {title:'报告链接',field:'ExamReportLink',width:70,
			formatter:function(value,rec){
 				var BtnHTML="";
 				 ///已申请 A ，（"登记"、"预约"） ，已报告 C
 				if (rec.ReportStatus!="C"){
	 				return BtnHTML;
	 			}else{
		 			var BtnHTML = '<a class="editcls" onclick="OpenExamReport(\'' + rec.OEORowid + '\')">'+$g("操作")+'</a>';
		 		}
				return BtnHTML;
            }
		}
    ]];
	$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"GetExamGridData",
	    EpisodeID:EpisodeIDTo,
	    UserCode:session['LOGON.USERCODE']
	},function(val){
		var GridData=eval('(' + val + ')'); 
		$HUI.treegrid('#ExamOrdGrid',{
		    data:GridData,
		    idField:'Index',    
		    treeField:'Title',
		    fit : false,
		    border: false,   
		    columns:ExamOrdColumns,
		    onLoadSuccess:function(row, data){
			    SetSummaryInfo(data);
			}
		});
	});
	
}
function SetSummaryInfo(data){
    var SummaryInfoArr=[];
    var Sum=0;
    for (var i=0;i<data.length;i++){
	    var status=data[i].Title;
	    var statusNum=data[i].children.length;
	    Sum += statusNum;
	    if (status ==$g("报告")){
		    var cls="out";
		}else{
			var cls="notout";
		}
	    SummaryInfoArr.push("<span class='"+cls+"'>"+status+"</span><span class='"+cls+" num'>"+statusNum+"</span><span class='"+cls+"' style='margin-right:10px;'>"+$g("项")+"</span>");
	}
	SummaryInfoArr.splice(0, 0, "<span class='total'>"+$g("共")+"</span><span class='total num'>"+Sum+"</span><span class='total' style='margin-right:10px;'>"+$g("项")+"</span>");
	$("#SummaryInfo").html(SummaryInfoArr.join(""));
}
//打开检验报告
function OpenLabReport(OrderId){
	websys_showModal({
		iconCls:'icon-w-find',
		url:"dhcapp.seepatlis.csp?OEORIID="+OrderId+"&EpisodeID="+EpisodeIDTo,
		title:'检验结果',
		width:'95%',height:'90%'
	})
}
//打开检查报告
function OpenExamReport(OrderId){
	websys_showModal({
		iconCls:'icon-w-find',
		url:"dhcapp.inspectrs.csp?OEORIID="+OrderId+"&EpisodeID="+EpisodeIDTo,
		title:'检查报告',
		width:'95%',height:'90%'
	})
}