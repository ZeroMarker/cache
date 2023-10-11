/**
* @author songchunli
* HISUI 计划到期提醒主js
* NursePlanRecordAlert.js
*/
var PageLogicObj={
	episodeIDs:"", //已否选就诊串
	m_NurPlanRecordAlertTab:""
}
$(function(){
	Init();
	InitEvent();	
	if(ServerObj.versionNewFlag=="1"){
		$('#main').layout('panel', 'west').panel({
			onExpand: ResetDomSize,
		  	onCollapse: ResetDomSize
		});
	}
	if ((typeof(HISUIStyleCode)!='undefined')&&('lite'!=HISUIStyleCode)) {//炫彩
		 $("#main").layout('panel', 'center').attr("style","overflow:hidden;background-color:#FFFFFF");		
	}
	
});
$(window).load(function() {
	$("#loading").hide();
	ResetDomSize();
})
//窗口改变
window.addEventListener("resize",ResetDomSize);

function Init(){
	$("#SearchDateFrom,#SearchDateTo").datebox("setValue",ServerObj.CurrentDate);
	//Before_R8_5_3
	if(ServerObj.versionNewFlag!="1"){
		// 护理分组权限开启时，默认显示责组
		if(ServerObj.groupFlag=="Y"){
			$("#switchBtn").addClass("ant-switch-checked");
			$($(".switch label")[1]).addClass("current");
		}
		//InitPatientTree();
		InitPatientTreeOld();
		$('#wardPatientCondition').css("margin-top","5px");
		$('#wardPatientCondition').css("width","206px");
		$('#wardPatientCondition').css("padding","0 1px");
	}else{
		var innerHeight=window.innerHeight-8;
		$("#tab-div").panel('open');
		$("#tab-div").css("height",innerHeight-92);
		PageLogicObj.episodeIDs=_PatListGV.EpisodeID;
		InitNurPlanRecordAlertTab();
	}
}
function InitEvent(){
	$("#BFind").click(function(){
		$('#NurPlanRecordAlertTab').datagrid('load');
	});
	/*$('#wardPatientSearchBox').searchbox({
		searcher: function(value) {
			SetPatientTreeStatus();
		}
	});*/
	$("#wardPatientSearchBox").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			SetPatientTreeStatus();
		}
	});
	$("#wardPatientSearchBtn").click(function(){
		SetPatientTreeStatus();
	});
	$("#switchBtn").click(function(){
		$(".current").removeClass("current");
		if ($(".ant-switch-checked").length) {
			$("#switchBtn").removeClass("ant-switch-checked");
			$($(".switch label")[0]).addClass("current");
		}else{
			$("#switchBtn").addClass("ant-switch-checked");
			$($(".switch label")[1]).addClass("current");
		}
		$HUI.tree('#patientTree','reload');
	});
	$('#wardPatientCondition').switchbox('options').onSwitchChange = function(){
		PageLogicObj.episodeIDs="";
		$HUI.tree('#patientTree','reload');
	};
}
function InitPatientTreeOld(){
	var innerHeight=window.innerHeight;
	$("#patientList").panel('resize', {
	  	height:innerHeight-42
	});
	$("#patientListTree").panel('resize', {
	  	height:innerHeight-100
	});
	//重要，不然显示出来的table数据则会隐藏不可见,table的标题,工具栏,分页栏则会压缩在一起
	$("#tab-div").css("height",innerHeight-95); 
	$HUI.tree('#patientTree', {
		checkbox:true,
		loader: function(param, success, error) {
			// HIS 8.5 版本
			if (ServerObj.version85 == "1")
			{
				var parameter = { EpisodeID:ServerObj.EpisodeID, WardID:session['LOGON.WARDID'], LocID:session['LOGON.CTLOCID'], GroupFlag:$(".ant-switch-checked").length ? true : false, BabyFlag:'', SearchInfo:$("#wardPatientSearchBox").val(), LangID:session['LOGON.LANGID'], UserID:session['LOGON.USERID'] };
				$cm({
					ClassName: "Nur.NIS.Service.Base.Ward",
					MethodName: "GetWardPatientsNew",
					wardID:session['LOGON.WARDID'],
					adm:ServerObj.EpisodeID,
					groupSort:$(".ant-switch-checked").length?"true":"false",
					babyFlag:"",
					searchInfo:$("#wardPatientSearchBox").val(),
					locID:session['LOGON.CTLOCID']
					//MethodName: "getPatients",
					//Param: JSON.stringify(parameter)
				}, function(data) {
					var addIDAndText = function(node) {
						node.id = node.ID;
						node.text = node.label ;
						if (node.id === ServerObj.EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			}
			/*
			else
			{
				// 兼容低版本HIS -- 取护理病历病人列表接口
				$cm({
					ClassName: "NurMp.NursingRecords",
					MethodName: "getWardPatients",
					wardID: session['LOGON.WARDID'],
					adm: ServerObj.EpisodeID,
					groupSort: $(".ant-switch-checked").length?"true":"false", //!$('#wardPatientCondition').switchbox('getValue'),
					babyFlag: '',
					searchInfo:$("#wardPatientSearchBox").val(), //$HUI.searchbox('#wardPatientSearchBox').getValue(),
					locID: session['LOGON.CTLOCID']||'',
					todayOperFlag: $("#radioTodayOper").radio('getValue')
				}, function(data) {
					var addIDAndText = function(node) {
						node.id = node.ID;
						node.text = node.label ;
						if (node.id === ServerObj.EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			}
			*/			
            else {
                // 兼容低版本HIS -- 取护理病历病人列表接口
                var parameter = {					
					WardID: session['LOGON.WARDID'],
					EpisodeID: ServerObj.EpisodeID,
					LocID: session['LOGON.CTLOCID'],
					GroupFlag: $(".ant-switch-checked").length ? "true" : "false", //$('#wardPatientCondition').switchbox('getValue') == true ? 'N' : 'Y',
					BabyFlag: '',
					SearchInfo: $("#wardPatientSearchBox").val(),//$HUI.searchbox('#wardPatientSearchBox').getValue(),
					LangID: session['LOGON.LANGID'],
					UserID: session['LOGON.USERID'],
					StartDate: '', //ShowSearchDate == 1 ? $('#startDate').datebox('getValue') : '',
					EndDate: '', //ShowSearchDate == 1 ? $('#endDate').datebox('getValue') : ''
				};
                $cm({
					ClassName: 'NurMp.Service.Patient.List',
					MethodName: 'getPatients',
					Param: JSON.stringify(parameter)
				}, function (data) {
                    var addIDAndText = function (node) {
                        node.id = node.ID;
                        node.text = node.label;
                        if (node.id === ServerObj.EpisodeID) {
                            node.checked = true;
                        }
                        if (node.children) {
                            node.children.forEach(addIDAndText);
                        }
                    }         
                    data.WardPatients.forEach(addIDAndText);
                    success(data.WardPatients);
                });
            }
		},
		onLoadSuccess: function(node, data) {
			$(".tree-file,.tree-folder,.tree-folder-open").css("display","none")	
			if (!!ServerObj.EpisodeID) {
				var selNode = $('#patientTree').tree('find', ServerObj.EpisodeID);
				$('#patientTree').tree('check', selNode.target);
				$($(selNode.target).children()[4]).addClass("frmepisodepat")
			}
		},
		lines: true,
		onClick: function (node) {
			var nodes =$('#patientTree').tree('getChecked');
			if ($.hisui.indexOfArray(nodes,"ID",node.ID)>=0) {
				$('#patientTree').tree('uncheck', node.target);
			}else{
				$('#patientTree').tree('check', node.target);
			}
		},
		onCheck:function(node, checked){
			var selEpisodeIDsArr=new Array();
			var nodes =$('#patientTree').tree('getChecked');
			for (var i=0;i<nodes.length;i++){
				if (nodes[i].children) continue;
				selEpisodeIDsArr.push(nodes[i].episodeID);
			}
			PageLogicObj.episodeIDs=selEpisodeIDsArr.join("^");
			if (!PageLogicObj.m_NurPlanRecordAlertTab) {
				InitNurPlanRecordAlertTab();
			}else{
				$('#NurPlanRecordAlertTab').datagrid('load');
			}
		}
	});
}

//患者树勾选/取消勾选时调用
function patientTreeCheckChangeHandle()
{
	/*
	var selEpisodeIDsArr=new Array();	
	var nodes =$('#patientTree').tree('getChecked');
	for (var i=0;i<nodes.length;i++){
		if (nodes[i].children) continue;
		selEpisodeIDsArr.push(nodes[i].episodeID);
	}
	PageLogicObj.episodeIDs=selEpisodeIDsArr.join("^");
	*/
	$("#tab-div").panel('open');
	$("#tab-div").panel('open');
	PageLogicObj.episodeIDs=EpisodeIDStr;
	if (!PageLogicObj.m_NurPlanRecordAlertTab) {
		InitNurPlanRecordAlertTab();
	}else{
		$('#NurPlanRecordAlertTab').datagrid('load');
	}	
}
function InitNurPlanRecordAlertTab(){
	var Columns=[[ 
		{ field: 'bedCode', title: '床号',width:80},
		{ field: 'name', title: '姓名',width:100},
		{ field: 'queName', title: '护理问题',width:200},
		{ field: 'createDateTime', title: '创建时间',width:150},
		{ field: 'createUser', title: '创建人',width:100},
		{ field: 'playDays', title: '计划达成天数',width:95},
		{ field: 'playDate', title: '计划到期日',width:95,			
			styler: function(value,row,index){
 				if ((value!="")&&(value!=" ")){
	 				if (!CompareDate(value,ServerObj.CurrentDate)){
		 				return 'background-color:#FF3D3D;';
		 			}
	 			}
 			},
 			formatter: function(value,row,index){
 				if ((value!="")&&(value!=" ")){
	 				if (!CompareDate(value,ServerObj.CurrentDate)){
		 				return "<span style='color:#FFFFFF '>" + value + "</span>";
		 			}else{
			 			return "<span style='color:#000000 '>" + value + "</span>";
			 		}
	 			}
 			},
		}
    ]];
	PageLogicObj.m_NurPlanRecordAlertTab=$('#NurPlanRecordAlertTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,   //设置隔行变色
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, //分页
		rownumbers : true,
		idField:"recordId",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionRecord&QueryName=GetPlansAlertList",
		onBeforeLoad:function(param){
			$('#NurPlanRecordAlertTab').datagrid("unselectAll");
			param = $.extend(param,{
				episodeIDs:PageLogicObj.episodeIDs,
				dateFrom:$("#SearchDateFrom").datebox('getValue'), 
				dateTo:$("#SearchDateTo").datebox('getValue')
			});
		},
		onDblClickRow:function(rowIndex, rowData){
			websys_showModal({
				url:"nur.hisui.nurseplanmake.csp?IsShowPatList=N&IsShowPatInfoBannner=N&EpisodeID="+rowData.episodeID,
				title:rowData.name+' 护理计划制定',
				width:'98%',height:'95%'
			})
		}
	})
}
function SetPatientTreeStatus(){
	var SearchName=$.trim($('#wardPatientSearchBox').val());
	if (!SearchName) {
		$(".hidenode").removeClass("hidenode");
	}else{
		SearchName=SearchName.toUpperCase();
		var roots=$('#patientTree').tree('getRoots');
		for (var i=0;i<roots.length;i++){
			var children=roots[i].children;
			var childrenHideNum=0;
			for (var j=0;j<children.length;j++){
				var bedCode=children[j].bedCode;
				if (bedCode) {
					bedCode=bedCode.toUpperCase();
				}
				var name=children[j].name.toUpperCase();
				var Node = $('#patientTree').tree('find', children[j].episodeID);
				if (((bedCode)&&(bedCode.indexOf(SearchName) >=0))||(name.indexOf(SearchName) >=0)){
					$(Node.target).removeClass("hidenode");
				}else{
					$(Node.target).addClass("hidenode");
					childrenHideNum++;
				}
			}
			var ParentNode = $('#patientTree').tree('find', roots[i].ID);
			if (childrenHideNum == children.length) {
				$(ParentNode.target).addClass("hidenode");
			}else{
				$(ParentNode.target).removeClass("hidenode");
			}
		}
	}
}
function CompareDate(date1,date2){
	var date1 = myparser(date1);
	var date2 = myparser(date2); 
	if(date2<date1){  
		return true;  
	} 
	return false;
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
/*
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
*/
function myparser(dateStr){
	if (!dateStr) return new Date();
	var formats = [
		/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/,    //"dd/MM/yyyy"
		/^(\d{1,2})-(\d{1,2})-(\d{4})$/,	  //"dd-MM-yyyy"
		/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/,    //"MM/dd/yyyy"
		/^(\d{1,2})-(\d{1,2})-(\d{4})$/,      //"MM-dd-yyyy"
		/(\d{4})\/(\d{2})\/(\d{2})/,          //"yyyy/MM/dd"
		/(\d{4})-(\d{2})-(\d{2})/,            //"yyyy-MM-dd"
	];
	for (var i = 0; i < formats.length; i++) {
  		var format = formats[i];
		var match = dateStr.match(format);
		if (match) {
			//[,a,b,c] = match;
			//兼容IE
			a=match[1];
			b=match[2];
			c=match[3];
			if (format === formats[0] || format === formats[1]) {
				return new Date(c, b-1, a);
			}
			else if (format === formats[2] || format === formats[3]) {
				return new Date(c, a - 1, b);
			} else {
				return new Date(a, b - 1, c);
			}
		}
	}
}
function ResetDomSize(){
	var innerHeight= window.innerHeight-8;
	//$("#main").layout("resize").layout('panel', 'center').panel('resize',{height:innerHeight,width:'100%',left: '221px'});
	$("#main").layout('panel', 'center').panel('resize',{height:innerHeight,width:'100%',left: '221px'});
	$("#PlanRecordAlert-panel").parent().css({'width':$(window).width(), 'height':innerHeight});
	if(ServerObj.versionNewFlag!="1"){
		var patientListTreeWidth =$("#patientListTree").outerWidth();
		$("#main").layout('panel', 'center').panel('resize',{height:innerHeight,width:'100%',left: patientListTreeWidth+8});
		$("#PlanRecordAlert-panel").parent().css({'width':$(window).width(), 'height':innerHeight});
		$("#PlanRecordAlert-panel").panel("resize",{height:innerHeight,width:'100%'});
	}
	else{		
		setTimeout(function () {
	        ResetPatientSearch();
	    },10);
	}
}
function ResetPatientSearch(){
	var innerWidth= window.innerWidth-8;
	var innerHeight= window.innerHeight-8;
	//$("#patient_search").css("height",innerHeight-36);
	var panelheaderH = $(".panel-header").outerHeight();
	var ele = document.getElementById("patient_search");
	var style=window.getComputedStyle ? window.getComputedStyle(ele,null) : ele.currentStyle;
	var display=style["display"];
	if (display=="block"){
		$("#main").layout("resize").layout('panel', 'center').panel('resize', {
        	left: 224,
        	height:innerHeight,
        	width: innerWidth-224
    	});
    	$("#PlanRecordAlert-panel").panel("resize",{height:innerHeight ,width:innerWidth-225});
    	$("#PlanRecordAlert-panel").css("height",innerHeight-panelheaderH+1);
    	var searchtableH = $(".search-table").outerHeight();    	
		$("#tab-div").parent().css("height",innerHeight-panelheaderH-searchtableH);
		
		$("#tab-div").panel('open'); 
		$("#tab-div").css("height",innerHeight-panelheaderH-searchtableH); 
		$("#tab-div").css("width",innerWidth-225);	
		$("#tab-div").css({"border-left-width":0,"border-right-width":0});
		$('NurPlanRecordAlertTab').datagrid("resize",{
	    	height: innerHeight-panelheaderH-searchtableH
	    });	
	}
	else if (display=="none"){
		$("#main").layout("resize").layout('panel', 'center').panel('resize', {
        	left: 32,
        	height:innerHeight,
        	width: innerWidth-32    	
    	});
    	$("#PlanRecordAlert-panel").panel("resize",{height:innerHeight ,width:innerWidth-32});
		$("#PlanRecordAlert-panel").css("height",innerHeight-36+1);
		var searchtableH = $(".search-table").outerHeight();   
		$("#tab-div").parent().css("height",innerHeight-36-searchtableH);
		$("#tab-div").css("height",innerHeight-36-searchtableH); 
		$("#tab-div").css("width",innerWidth-32);
		$("#tab-div").css({"border-left-width":0,"border-right-width":0});
    			$('NurPlanRecordAlertTab').datagrid("resize",{
	    	height: innerHeight-panelheaderH-searchtableH
	    });	
	}

}

