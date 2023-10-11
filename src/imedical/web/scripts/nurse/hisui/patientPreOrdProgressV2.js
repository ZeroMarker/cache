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
            $.messager.popover({ msg: 'δ�ܲ�ѯ����Ч��סԺ֤��Ϣ', type: 'success', timeout: 1000 });
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
		{title:'״̬',field:'Title',width:150},
		{title:'ҽ������',field:'ARCIMDesc',width:300},
		{title:'ҽ������',field:'TestSetName',width:250,hidden:true},
		{title:'״̬',field:'Status',hidden:true},
		{title:'ҽ��id',field:'OrderId',width:90,hidden:true},
		{title:'����id',field:'ReportId',width:90,hidden:true},
		{title:'�����',field:'VisitNumber',width:110,hidden:true},
		{title:'��Ѫʱ��',field:'SpecCollDate',width:90},
		{title:'����ʱ��',field:'RequestTime',width:90,hidden:true},
		{title:'����ʱ��',field:'ReceiveTime',width:90},
		{title:'����ʱ��',field:'ReportTime',width:90},
		{title:'��������',field:'labReportLink',width:70,
			formatter:function(value,rec){
 				var BtnHTML="";
 				 ///������ 1 ���ѽ��� 2 ���ѱ��� 3
 				if (rec.Status!="3"){
	 				return BtnHTML;
	 			}else{
		 			var BtnHTML = '<a class="editcls" onclick="OpenLabReport(\'' + rec.OrderId + '\')">'+$g("����")+'</a>';
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
///���ҽ��������״�б�
function LoadExamOrdGrid(){
	var ExamOrdColumns=[[    
		{field:'Index', hidden:true},
		{title:'״̬',field:'Title',width:90},
        {field:'OEORowid',hidden:true},
        {title:'ҽ��������',field:'ItemDesc',width:300},
        {title:'��λ/�걾',field:'BodyPart',width:150},
        {title:'����',field:'StudyNo',width:60,hidden:true},
        {title:'ִ�п���',field:'ExecuteLoc',width:80},
        {title:'״̬',field:'ReportStatus',hidden:true},
        {title:'ʱ��',field:'DateTime',width:150},
        {title:'ҽʦ',field:'AppDoc',width:80,hidden:true},
        {title:'��������',field:'ExamReportLink',width:70,
			formatter:function(value,rec){
 				var BtnHTML="";
 				 ///������ A ����"�Ǽ�"��"ԤԼ"�� ���ѱ��� C
 				if (rec.ReportStatus!="C"){
	 				return BtnHTML;
	 			}else{
		 			var BtnHTML = '<a class="editcls" onclick="OpenExamReport(\'' + rec.OEORowid + '\')">'+$g("����")+'</a>';
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
	    if (status ==$g("����")){
		    var cls="out";
		}else{
			var cls="notout";
		}
	    SummaryInfoArr.push("<span class='"+cls+"'>"+status+"</span><span class='"+cls+" num'>"+statusNum+"</span><span class='"+cls+"' style='margin-right:10px;'>"+$g("��")+"</span>");
	}
	SummaryInfoArr.splice(0, 0, "<span class='total'>"+$g("��")+"</span><span class='total num'>"+Sum+"</span><span class='total' style='margin-right:10px;'>"+$g("��")+"</span>");
	$("#SummaryInfo").html(SummaryInfoArr.join(""));
}
//�򿪼��鱨��
function OpenLabReport(OrderId){
	websys_showModal({
		iconCls:'icon-w-find',
		url:"dhcapp.seepatlis.csp?OEORIID="+OrderId+"&EpisodeID="+EpisodeIDTo,
		title:'������',
		width:'95%',height:'90%'
	})
}
//�򿪼�鱨��
function OpenExamReport(OrderId){
	websys_showModal({
		iconCls:'icon-w-find',
		url:"dhcapp.inspectrs.csp?OEORIID="+OrderId+"&EpisodeID="+EpisodeIDTo,
		title:'��鱨��',
		width:'95%',height:'90%'
	})
}