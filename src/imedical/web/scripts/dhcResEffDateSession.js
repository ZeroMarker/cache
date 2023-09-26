var	userid = session['LOGON.USERID'];
var groupid = session['LOGON.GROUPID'];
var TalStartDate='';
var ASRoomData = ""
var TimeRange = eval('(' + tkMakeServerCall("web.DhcResEffDateSessionClass","GetTimeRange") + ')');
var ASSessionType =eval('(' + tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessionTypeStr") + ')');
var OldExaRowid = ""
var ExaRowid = ""
var LocRowid = ""
var DocRowid = ""
var AddFlag = 1
var DefaultCsp = "dhcResEffDateSession.Action.csp"
var FirstOpenAddWin = false;
var DateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
var CurrDate=tkMakeServerCall("web.DHCBatchStopNew","GetCurrDate");
$(function(){
	Init()
 });
 function Init(){
	InitLocDocTree()
	InitScheduleTab("")
	InitButton();
	InitWinCombo(); 
	InittabRBASApptNum("","","");
 }
  function InitButton(){
	$("#SerchLoc").bind("keyup",findLocData);
	$("#SerchDoc").bind("keyup",findLocData);
	$("#FindAll").bind("click",function(){
		//取消tree结点的选中
		$('#LocDocTree').find('.tree-node-selected').removeClass('tree-node-selected');
		FindScheduleByLoc("","","")
	});
	
	var GroupDesc= session['LOGON.GROUPDESC'];
	var CTLOCID= session['LOGON.CTLOCID'];
	
	$("#ApptMax").bind("keyup",LimitApptMax);
	
	$("#save").on("click", save);
	$("#cancel").on("click", cancel);
    $("#CreateSchedule").on("click", CreateDateSchedule);
 }
 
 function LimitApptMax()
 {
	 	var EPositiveMax = $("#PositiveMax").val() ; 			//正号限额
		var EApptMax = $("#ApptMax").val() ; 				//预约限额
		var EStartPrefix = $("#EStartPrefix").val() ;		//预约起始号			
		if (parseInt(EPositiveMax)!=0){
			if ((parseInt(EPositiveMax))<(parseInt(EApptMax))){
				$.messager.alert('错误', "正号限额不能小于预约限额！");
				return false;
			}
			if (parseInt(EApptMax)!=0){
				if ((parseInt(EPositiveMax)-parseInt(EStartPrefix)+1)<(parseInt(EApptMax))){
					$.messager.alert('错误', "正号限额减去预约起始号要大于等于预约限额！");
					return false;
				}
			}
		}
		
		//$("#TRRegNum").attr('value',EApptMax);
 }
 
 function LimitECombo(flag,type)
 {
	$('#EAdmDoc').combobox(flag);
	$('#EDocSession').combobox(flag);
	$('#EReason').combobox(flag);
	$('#ELeader').combobox(flag);
	if (type=='Stop'){
		$('#EAdmDoc').combobox('disable');
		$('#EDocSession').combobox('disable');
	}
 }
 
 function save()
 {
	
	if (!ValidateInput()) return ;
	var ASRowID=$("#ASRowID").val();
	if (ASRowID!=""){
		var ret=UpdateAS(ASRowID);
	}else{
		var ret=SaveNewAS();
	}
	if (ret) {
				
		// var LocID=$("#AdmLoc").combogrid("getValue");	  // 按科室,方便同时看替/被替诊医生
		// FindScheduleByLoc(LocID,"","");
		cancel();
	}
	var tab=$('#ScheduleTab').tabs("getSelected");
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId = "ScheduleGrid"+index
	$("#"+GridId).datagrid('reload'); 
	var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpClinicGroupAll";;
		queryParams.ArgCnt =0;
		InitComboData('#ClinicGroup',queryParams)
 }
function Delete(RBDSRowid,DelScheduleFlag){
	retcode = tkMakeServerCall("web.DHCRBResSession","Delete",RBDSRowid,DelScheduleFlag);
	if(retcode!=0){
		$.messager.alert('提示',"删除过程出现错误:" + retcode)

	}
}
 
function UpdateAS(ASRowID) 
{
	var tab=$('#ScheduleTab').tabs("getSelected");
	var opts=tab.panel("options")
	var tabDOW=opts.title
	var tabIndex = $('#ScheduleTab').tabs('getTabIndex',tab);
	tabIndex = parseInt(tabIndex) + 1
	
	var dow = tabIndex + String.fromCharCode(1) + tabDOW
	
 	var total = $("#PositiveMax").val() ; 			//正号限额
	var book = $("#ApptMax").val() ; 				//预约限额
	if(book==""){
		book = 0
	}		
	var AppClientNum = tkMakeServerCall("web.DhcResEffDateSessionClass","GetAppClientNum",ASRowID,"Template");
	if(+AppClientNum>+book)	{
		$.messager.alert('错误', "预约限额不能小于各个预约机构限额!");
		return false;
	}							
	var over = $("#AddtionMax").val() ;				//加号限额
	var startNum = $("#EStartPrefix").val() ;		//预约起始号			

	var TRStartTime = $("#TRStartTime").val() ;		
	var TREndTime = $("#TREndTime").val() ;	
	
	//预约限额为空验证预约起始号
	if (book==0){startNum=0}
	if (((startNum=="")||(startNum<=0))&(book>0)){
		$.messager.alert('错误', "预约起始号数量格式不正确")
		return false;
	}
		
	
	//分时段就诊
	var TRFlag="Y",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="";	
	if(!$("#TRFlag").is(':checked')){
		TRFlag = "N"
	}
	if (TRFlag=="Y"){
		var TRLength=$("#TRLength").val();		
		var TRRegNum=$("#TRRegNum").val() ;
		if(TRRegNum==""){
			TRRegNum = total
		}	
		if(+TRRegNum>+(total)){
			$.messager.alert('错误', "分时段时段号数不能大于正号限额! ");
			return false;
		}
		if (!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,startNum)) return false;
	
		TRRegNumStr=$("#TRRegNumStr").val();
		TRRegInfoStr=$("#TRRegInfoStr").val();
	}


	var AdmLoc = $("#AdmLoc").combogrid("getValue");	
	var AdmDoc = $("#AdmDoc").combogrid("getValue");	
	var TimeRange = $("#TimeRange").combogrid("getValue");
	
	
	var SessScheduleGenerFlag = 'Y'
	if(!$("#ScheduleGenerFlag").is(':checked')){
		SessScheduleGenerFlag = 'N'
	}
	
	//判断同一科室同一医生同一星期同一时段是否已经有排班
	
	var IsSameResEffDateSessByREDSRowid = tkMakeServerCall("web.DhcResEffDateSessionClass","IsSameResEffDateSessByREDSRowid",ASRowID,AdmLoc,AdmDoc,tabIndex,TimeRange,SessScheduleGenerFlag)
	if(IsSameResEffDateSessByREDSRowid==1){
		$.messager.alert('错误',"该医生同一时间已有排班模板，不能添加")
		return
	}
	
	
	var TimeRangeText = $("#TimeRange").combogrid("getText");
	TimeRange = TimeRange + String.fromCharCode(1) + TimeRangeText
	
	var LocArea = $("#LocArea").combogrid("getValue");	
	var LocAreaText = $("#LocArea").combogrid("getText");
	LocArea = 	LocArea + String.fromCharCode(1) + LocAreaText
	
	var DocSession = $("#DocSession").combogrid("getValue");
	if (DocSession==""){
		$.messager.alert('错误',"挂号职称不能为空,请选择!")
		return
	}
	var DocSessText = $("#DocSession").combogrid("getText");
	DocSession = 	DocSession + String.fromCharCode(1) + DocSessText
	
	
	var ClinicGroup	= $("#ClinicGroup").combogrid("getValue");
	var ClinicGroupText = $("#ClinicGroup").combogrid("getText");
	ClinicGroup = ClinicGroup + String.fromCharCode(1) + ClinicGroupText
	
	var TimeRangeStr=TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr;
	var SessSlotLength = ""
	var SessNoSlots = parseInt(total) - parseInt(book)
	var SessPatientType="O";
	
	
	
	var AutoLoad = "" //$("#AutoLoad").val() ;		
	var ExtLoad = "" //$("#ExtLoad").val() ;	
	
	//先设定AutoLoad 和 ExtLoad 为空
	AutoLoad = "" //$("#AutoLoad").val();
	ExtLoad = "" //$("#ExtLoad").val();
	
	var UpdateData=ASRowID+"^"+dow+"^"+TRStartTime+"^"+TREndTime+"^"+SessSlotLength+"^"+total+"^"+SessNoSlots+"^"+book;
		UpdateData=UpdateData+"^"+startNum+"^"+over+"^"+LocArea+"^"+DocSession+"^"+ClinicGroup+"^"+SessPatientType+"^"+TimeRange+"^"+SessScheduleGenerFlag;
		UpdateData=UpdateData+"^"+TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr+"^"+AutoLoad+"^"+ExtLoad

	//var ResDateRowid = tkMakeServerCall("web.DhcResEffDateSessionClass","GetResEffDateByLocIdAndDocId",AdmLoc,AdmDoc)
	
	var ret1 = tkMakeServerCall("web.DHCRBResSession","Update",UpdateData);
	var temparr=ret1.split("^");
	var retcode=temparr[0];
	if (retcode==0){
		if(temparr[1]!=""){
			$.messager.alert('提示',"同时间同诊室已有排班模板"+":"+temparr[1]);
			$.messager.alert('提示',"更新成功");
			cancel();	
		}else{
			$.messager.alert('提示',"更新成功");
			cancel();
		}
	}else{
		if (retcode=="-201"){
			$.messager.alert('提示',"同时间同诊室已有排班模板"+":"+temparr[1]);
		}else{
			$.messager.alert('提示',"更新排班模板失败");
		}
	}
} 
 
function SaveNewAS()
{	
	var tab=$('#ScheduleTab').tabs("getSelected");
	var opts=tab.panel("options")
	var tabDOW=opts.title
	var tabIndex = $('#ScheduleTab').tabs('getTabIndex',tab);
	tabIndex = parseInt(tabIndex) + 1
	
	var dow = tabIndex + String.fromCharCode(1) + tabDOW
	
 	var total = $("#PositiveMax").val() ; 			//正号限额
	var book = $("#ApptMax").val() ; 				//预约限额
	if(book==""){
		book = 0
	}
	var over = $("#AddtionMax").val() ;				//加号限额
	var startNum = $("#EStartPrefix").val() ;		//预约起始号			

	var TRStartTime = $("#TRStartTime").val() ;		
	var TREndTime = $("#TREndTime").val() ;	
	
	//预约限额为空验证预约起始号
	if (book==0){startNum=0}
	if (((startNum=="")||(startNum<=0))&(book>0)){
		$.messager.alert('错误', "预约起始号数量格式不正确")
		return false;
	}	
	
	//分时段就诊
	var TRFlag="Y",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="";	
	var TRFlag = "Y"
	if(!$("#TRFlag").is(':checked')){
		TRFlag = "N"
	}
	if (TRFlag=="Y"){
		var TRLength=$("#TRLength").val();		
		var TRRegNum=$("#TRRegNum").val() ;
		if(TRRegNum==""){
			TRRegNum = total
		}	
		if(+TRRegNum>+(total)){
			$.messager.alert('错误', "分时段时段号数不能大于正号限额! ");
			return false;
		}
		if (!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,startNum)) return false;
		
		TRRegNumStr=$("#TRRegNumStr").val();
		TRRegInfoStr=$("#TRRegInfoStr").val();
	}

	var AdmLoc = $("#AdmLoc").combogrid("getValue");	
	var AdmDoc = $("#AdmDoc").combogrid("getValue");	
	var TimeRange = $("#TimeRange").combogrid("getValue");
	
	
	
	var SessScheduleGenerFlag = 'Y'
	if(!$("#ScheduleGenerFlag").is(':checked')){
		SessScheduleGenerFlag = 'N'
	}
	
	//判断同一科室同一医生同一星期同一时段是否已经有排班
	
	var IsSameResEffDateSess = tkMakeServerCall("web.DhcResEffDateSessionClass","IsSameResEffDateSess",AdmLoc,AdmDoc,tabIndex,TimeRange,SessScheduleGenerFlag);
	if(IsSameResEffDateSess==1){
		$.messager.alert('错误',"该医生同一时间已有排班模板，不能添加")
		return
	}
	
	var TimeRangeText = $("#TimeRange").combogrid("getText");
	TimeRange = TimeRange + String.fromCharCode(1) + TimeRangeText
	
	var LocArea = $("#LocArea").combogrid("getValue");	
	var LocAreaText = $("#LocArea").combogrid("getText");
	LocArea = 	LocArea + String.fromCharCode(1) + LocAreaText
	
	var DocSession = $("#DocSession").combogrid("getValue");
	if (DocSession==""){
		$.messager.alert('错误',"挂号职称不能为空,请选择!")
		return
	}
	var DocSessText = $("#DocSession").combogrid("getText");
	DocSession = 	DocSession + String.fromCharCode(1) + DocSessText
	
	
	var ClinicGroup	= $("#ClinicGroup").combogrid("getValue");
	var ClinicGroupText = $("#ClinicGroup").combogrid("getText");
	ClinicGroup = ClinicGroup + String.fromCharCode(1) + ClinicGroupText
	
	var TimeRangeStr=TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr;
	var SessSlotLength = ""
	var SessNoSlots = parseInt(total) - parseInt(book)
	var SessPatientType="O";
	
	
	
	var AutoLoad = "" //$("#AutoLoad").val() ;		
	var ExtLoad = "" //$("#ExtLoad").val() ;	
	
	//先设定AutoLoad 和 ExtLoad 为空
	AutoLoad = "" //$("#AutoLoad").val();
	ExtLoad = "" //$("#ExtLoad").val();
	
	var InsertData = ""+"^"+dow+"^"+TRStartTime+"^"+TREndTime+"^"+SessSlotLength+"^"+total+"^"+SessNoSlots+"^"+book;
	InsertData=InsertData+"^"+startNum+"^"+over+"^"+LocArea+"^"+DocSession+"^"+ClinicGroup+"^"+SessPatientType+"^"+TimeRange+"^"+SessScheduleGenerFlag;
	InsertData=InsertData+"^"+TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr+"^"+AutoLoad+"^"+ExtLoad
	
	var ResDateRowid = tkMakeServerCall("web.DhcResEffDateSessionClass","GetResEffDateByLocIdAndDocId",AdmLoc,AdmDoc)

	//alert(ResDateRowid)
	var ret1 = tkMakeServerCall("web.DHCRBResSession","Insert",ResDateRowid,InsertData);
	var temparr=ret1.split("^");
	var retCode=temparr[0];
	if (retCode == 0){
		var SessRowId = temparr[1];
		if(temparr[2]!=""){
			$.messager.alert('错误','同时间同诊室已有排班模板'+":"+temparr[2]);
			$.messager.alert('提示',"新增排班模板成功")
			cancel();
		}else{
			$.messager.alert('提示',"新增排班模板成功")
			cancel();
		}
		$("#EditApptNumWin").panel({title:"<img src='/dthealth/web/images/uiimages/createschedulelist.png' style='vertical-align:middle;'>&nbsp;&nbsp;非现场预约限额维护"+"&nbsp;&nbsp;预约限额:"+"<font color='red'>"+book+"</font>"+"&nbsp;&nbsp;预约起始号:"+"<font color='red'>"+startNum+"</font>"});
		InittabRBASApptNum(SessRowId,book,startNum);
		$("#EditApptNumWin").window("open")
					 
		/*var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBRes.Session.AppQty&ResSessRowId="+SessRowId;
		websys_lu(url,false,"status=1,scrollbars=1,top=50,left=100,width=400,height=400");*/
	}else{
		if (retcode=="-201"){
			$.messager.alert('错误','同时间同诊室已有排班模板'+":"+temparr[1]);

		}else{
			$.messager.alert('错误','新增排班模板失败');
		}
	}
}

function TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,TRStartNum){
	if (TRStartTime==""){
		$.messager.alert('错误', "分时段开始时间格式不正确")
		return false;
	}
	if (TREndTime==""){
		$.messager.alert('错误', "分时段结束时间格式不正确")
		return false;
	}
	
	if ((TRLength=="")||(TRLength<0)){
		$.messager.alert('错误', "分时段时间间隔格式不正确")
		return false;
	}
	
	if ((TRRegNum=="")||(TRRegNum<0)){
		$.messager.alert('错误', "分时段号源数量格式不正确")
		return false;
	}
	
	
	//var ret=tkMakeServerCall("web.DHCRBResSession","TRInfoCalculateNew",TRStartTime,TREndTime,TRRegNum,TRStartNum)
	var ret=tkMakeServerCall("web.DHCRBResSession","TRInfoCalculate",TRStartTime,TREndTime,TRLength,TRRegNum)
	var arr=ret.split("^");
	if (arr[0]!="0"){
		$.messager.alert('错误', arr[1]);
		return false;
	}else{
		/*
		RegNumStr=$("#TRRegNumStr").val();
		RegInfoStr=$("#TRRegInfoStr").val();		
		if ((RegNumStr!=""&&RegNumStr!=arr[1])||(RegInfoStr!=""&&RegInfoStr!=arr[2]))
		{
			if (!(confirm("旧号段信息"+RegNumStr+"\n新号段信息"+arr[1]+"\n旧时段信息"+RegInfoStr+"\n新时段信息"+arr[2]+"\n是否替换?"))) return true;
		}
		*/
		$("#TRRegNumStr").attr('value',arr[1]);
		$("#TRRegInfoStr").attr('value',arr[2]);
		return true;
	}
	
}
 
function ValidateInput()
{
	var AdmLoc = $("#AdmLoc").combogrid("getValue");	
	if (AdmLoc==''){
		$.messager.alert('错误', "出诊科室不能为空！");
		return false;
	}
	var AdmDoc = $("#AdmDoc").combogrid("getValue");	
	if (AdmDoc==''){
		$.messager.alert('错误', "出诊医生不能为空！");
		return false;
	}
	var TimeRange = $("#TimeRange").combogrid("getValue");	
	if (TimeRange==''){
		$.messager.alert('错误', "出诊时段不能为空！");
		return false;
	}
	var EPositiveMax = $("#PositiveMax").val() ; 		//正号限额
	var EApptMax = $("#ApptMax").val() ; 				//预约限额
	var EAddtionMax = $("#AddtionMax").val() ;			//加号限额
	var EStartPrefix = $("#EStartPrefix").val() ;		//预约起始号
    var ESessionType = $("#DocSession").combogrid("getValue");
	if (ESessionType==''){
		$.messager.alert('错误', "挂号职称不能为空！ ");
		return false;
		}	
	if (EPositiveMax==''){
		$.messager.alert('错误', "正号限额不能为空！ ");
		return false;
	}

	if ((parseInt(EPositiveMax))<(parseInt(EApptMax))){
		$.messager.alert('错误', "正号限额不能小于预约限额！ ");
		return false;
	}
	if (parseInt(EApptMax)!=0){
		if ((parseInt(EPositiveMax)-parseInt(EStartPrefix)+1)<(parseInt(EApptMax))){
			$.messager.alert('错误', "正号限额减去预约起始号要大于等于预约限额！  ");
			return false;
		}
	}
	
	if (parseInt(EPositiveMax)>999){
		$.messager.alert('错误', "正号限额不能超过999!");
		return false;
	}
	
	if (parseInt(EApptMax)>99){
		//$.messager.alert('错误', "预约限额不能超过99!");
		//return false;
	}	

	return true;	
}

 
function cancel()
{
	$('#EditWin').window('close', true); 
}

function findLocData(event)
{
	var PyCode=$.trim($("#SerchLoc").val());
	var DocCode=$.trim($("#SerchDoc").val());
	var url = $("#LocDocTree").tree('options').url = "dhcrbapptschedulequeryrequest.csp?pid=0"+"&desc="+PyCode+"&userid="+userid+"&groupid="+groupid+"&docdesc="+DocCode ;
	$('#LocDocTree').tree('options').url =encodeURI(url);
	$(LocDocTree).tree('reload');
}

 function InitScheduleTab(StartDate)
 {
	//var AdmDateStr=tkMakeServerCall("web.DHCApptScheduleNew","GetAdmDateStr",StartDate)
	// AdmDateStr = "2016-01-01(周三)"
	var AdmDateStr = "星期一^星期二^星期三^星期四^星期五^星期六^星期日^假日模板一^假日模板二^假日模板三^假日模板四^假日模板五^假日模板六^假日模板七"
	var AdmDateStrArr=AdmDateStr.split("^")
	for(var i=0;i<AdmDateStrArr.length;i++){
		var admDate=AdmDateStrArr[i]
		$("#ScheduleTab").tabs("add",{
			title:admDate,
			content:'Tab Body'
		})
	}
	$('#ScheduleTab').tabs({
		heigth:'auto',
		onSelect: function(title,index){
			var CurrentTabPanel=$('#ScheduleTab').tabs("getSelected");
			LocRowid=""
			ExaRowid=""
			DocRowid=""
			var selObj=$("#LocDocTree").tree("getSelected")
			if(selObj){
				var id=selObj.id
				var idArr=id.split("^")
				if(idArr[0]=="Loc"){
					LocRowid=idArr[1]
					var parentNode=$("#LocDocTree").tree("getParent",selObj.target) ;
					if (parentNode){
						var parentNodeid=parentNode.id ;
						var parentNodeidArr=parentNodeid.split("^")
						ExaRowid=parentNodeidArr[1];
					}else{
						ExaRowid=idArr[2];
					}
					
				}else if (idArr[0]=="Doc"){
					DocRowid=idArr[1];
					var parentNode=$("#LocDocTree").tree("getParent",selObj.target) ;
					var parentNodeid=parentNode.id ;
					var parentNodeidArr=parentNodeid.split("^");
					LocRowid=parentNodeidArr[1];
					var grandPaNode = $("#LocDocTree").tree("getParent",parentNode.target);
					if (grandPaNode){
						var grandPaNodeid=grandPaNode.id ;
						var grandPaNodeidArr=grandPaNodeid.split("^");
						ExaRowid=grandPaNodeidArr[1];
					}else{
						ExaRowid=parentNodeidArr[2];
					}
					
				}else{
					ExaRowid=idArr[1] ;
				}
			}

			var TemplateTable=$('<div><table id="ScheduleGrid'+index+'"></table></div>');
			CurrentTabPanel.html(TemplateTable);

			var StartDate = title;
			TalStartDate=StartDate ;
			InitScheduleGrid("ScheduleGrid"+index,CurrentTabPanel.height());
			if((LocRowid!="")&&(DocRowid!="")){
				setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+LocRowid+"','"+DocRowid+"','')",500)
				return
			}
			else if(ExaRowid!=""&&(DocRowid=="")&&(LocRowid=="")){
				setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+''+"','','"+ExaRowid+"')",500)
				return
			}else if(ExaRowid!=""&&(DocRowid=="")&&(LocRowid!=""))
			setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+LocRowid+"','"+''+"','')",500)	
		}
	})
	$("#ScheduleTab").tabs("select",0)
 }
function TimeRangeFormatter(value){
	for(var i=0; i<TimeRange.length; i++){
		if (TimeRange[i].id == value) return TimeRange[i].name;
	}
	return value;
}
function ASSessionTypeFormatter(value){
	for(var i=0; i<ASSessionType.length; i++){
		if (ASSessionType[i].id == value) return ASSessionType[i].name;
	}
	return value;
}
function ASRoomDataFormatter(value){
	for(var i=0; i<ASRoomData.length; i++){
		if (ASRoomData[i].id == value) return ASRoomData[i].name;
	}
	return value;
}
 
function GetAsSessTypeByDoc(id){
	//alert(id)	 
}
 
function InitScheduleGrid(GridId,height){
	 //idField:'LocRowId',
	var lastIndex;
	$("#"+GridId).datagrid({
		title:'排班记录',
		remoteSort:false,
		width:'auto',
		border:true,
		striped:true,
		autoRowHeight:true,
		singleSelect : true, 
		fitColumns : true,
		url:'',
		singleSelect:false,
		height:height,
		loadMsg:'正在加载',
		rownumbers:true,
		columns:[[
			{field:"ck",checkbox:true},
			{field:'RBDSROWID',title:'RBDSROWID',width:10,hidden:true},
			{field:'LocDesc',title:'出诊科室',width:120,align:'left',sortable:true},
			{field:'DocDesc',title:'出诊医生',width:40,align:'left',sortable:true},
			{field:'ASSessionType',title:'职称',width:80,align:'left',sortable:true/*,
				formatter:ASSessionTypeFormatter,
				editor:{
				type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:ASSessionType,
							required:true
						}
			}*/},
			{field:'TimeRange',title:'午别',width:40,align:'left',sortable:true/*,
				formatter:TimeRangeFormatter,
				editor:{
				type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:TimeRange,
							required:true
						}
			}*/},
			{field:'ASLoad',title:'挂号限额',width:40,align:'left'/*,editor:'numberbox'*/},
			{field:'ASAppLoad',title:'预约限额',width:40,align:'left'/*,editor:'numberbox'*/},
			{field:'ASAppStart',title:'预约起始号',width:40,align:'left'/*,editor:'numberbox'*/},
			{field:'AddLoad',title:'加号限额',width:40,align:'left'/*,editor:'numberbox'*/},
			//{field:'AutoLoad',title:'自助限额',width:40,align:'left'/*,editor:'numberbox'*/},
			//{field:'ExtLoad',title:'外部限额',width:40,align:'left'/*,editor:'numberbox'*/},
			{field:'ASRoom',title:'诊室名称',width:120,align:'left',sortable:true/*,AutoLoad
				formatter:ASRoomDataFormatter,
				editor:{
				type:'combobox',
					options:{
						valueField:'id',
						textField:'name',
						data:ASRoomData,
						required:true
					}
			}*/},
			{field:'ASQueueNoCount',title:'合计限额',width:40,align:'left'},
			{field:'ScheduleGenerFlag',title:'状态',width:40,align:'left',
				formatter:function(value,data,index){
					if(value=="1"){
						return "激活"
					}else{
						return "未激活"
					}
				}/*,
				editor:{
					type:'checkbox',
					options:{on:"1",off:"0"}
			}*/}
		]],
		toolbar :[
			{	
			
				text:'新增排班模板',
				iconCls:'icon-add',
				handler:function(){
					AddFlag = 1;
					FirstOpenAddWin = true;
					ClearWinData();
					//LimitText("readonly");
					AddResEffDateSession("");
					//(ExaRowid+"__"+LocRowid+"__"+DocRowid)
					InitWinComboGrid();
				}
			},'-'/*,{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					$("#"+GridId).datagrid('acceptChanges');
				}
			},'-'*/,{
				text:'批量删除',
				iconCls:'icon-remove',
				handler:function(){
					var selections = $("#"+GridId).datagrid('getSelections')
					if(selections.length<1){
						$.messager.alert('错误',"请选择要删除的信息");

					}else{
						if(confirm("确认删除选中的排班模板？")){
							var DelScheduleFlag="";
							if(confirm("是否一并删除相应的未有挂号及预约记录排班？")){
								DelScheduleFlag="Y";
							}
							var len = selections.length
							var ASStr = ""
							for(var i =0;i<selections.length;i++){
								if(i==0){
									ASStr = selections[i].RBDSROWID
									Delete(selections[i].RBDSROWID,DelScheduleFlag)
								}else{
									ASStr += "^" + selections[i].RBDSROWID
									Delete(selections[i].RBDSROWID,DelScheduleFlag)
								}
							}
							$.messager.alert('提示',"删除完成");

							$("#"+GridId).datagrid('reload'); 
						}
					}
				}
			},'-',{
				text:'生成排班',
				iconCls:'icon-createschedule-custom',
				handler:function(){
					//AddResEffDateSession("");
					ShowCreateScheduleWin();
				}
			},'-',{
				text:'排班模板修改',
				iconCls:'icon-edit',
				handler:function(){
					//AddResEffDateSession("");
					AddFlag = 0
					var selections = $("#"+GridId).datagrid('getSelections')
					if(selections.length!=1){
						$.messager.alert("错误","只能选择一条信息进行修改");
					}else{
						selection = selections[0]
						DblClickFun(0,selection)
					}
				}
			},'-',{
				text:'非现场预约限额维护',
				iconCls:'icon-edit',
				handler:function(){
					var rows=$("#"+GridId).datagrid("getSelections");
					var idStr="",ASAppLoad="",AppStartSeqNo="";
					for(var i=0;i<rows.length;i++){
						if(idStr==""){
							idStr=rows[i].RBDSROWID
						}else{
							idStr=idStr+"^"+rows[i].RBDSROWID
						}
						var ASAppLoad=rows[i].ASAppLoad
					    var AppStartSeqNo=rows[i].ASAppStart
					}
					if(idStr==""){
						alert("请选择要修改的排班模板")
						return false;
					 }
					 if(idStr.split("^").length>1){
						 alert("请选择单个排班模板进行维护!")
						 return false;
					 }
					 $("#EditApptNumWin").panel({title:"<img src='/dthealth/web/images/uiimages/createschedulelist.png' style='vertical-align:middle;'>&nbsp;&nbsp;非现场预约限额维护"+"&nbsp;&nbsp;预约限额:"+"<font color='red'>"+ASAppLoad+"</font>"+"&nbsp;&nbsp;预约起始号:"+"<font color='red'>"+AppStartSeqNo+"</font>"});
					 InittabRBASApptNum(idStr,ASAppLoad,AppStartSeqNo);
					 $("#EditApptNumWin").window("open");
					 
					/*var selections = $("#"+GridId).datagrid('getSelections')
					if(selections.length!=1){
						$.messager.alert("提示","只能选择一条信息进行修改");
					}else{
						selection = selections[0];
						var SessRowid=selection.RBDSROWID;
						var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBRes.Session.AppQty&ResSessRowId="+SessRowid;
		                websys_lu(url,false,"status=1,scrollbars=1,top=50,left=100,width=400,height=400");
					}*/
				}
			}
		],
		onSelect:function(rowid,RowData){
			
		},
		/*
		onClickRow:function(rowIndex){
			if (lastIndex != rowIndex){
				$("#"+GridId).datagrid('endEdit', lastIndex);
				$("#"+GridId).datagrid('beginEdit', rowIndex);
				lastIndex = rowIndex;
			}else{
				$("#"+GridId).datagrid('beginEdit', rowIndex);
			}
			

			var ed = $("#"+GridId).datagrid("getEditor",{index:rowIndex,field:"ASRoom"});
			$(ed.target).combobox('loadData',ASRoomData);
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			if((changes.ASRoom==undefined)&&(changes.ASSessionType==undefined)&&(changes.TimeRange==undefined)&&(changes.ASLoad==undefined)&&(changes.ASAppLoad==undefined)&&((changes.ASAddLoad==rowData.ASAddLoad)||(changes.ASAddLoad==undefined))&&(changes.ScheduleGenerFlag==undefined)){
				return
			}else{
				alert("开始更新")
				var tab=$('#ScheduleTab').tabs("getSelected");
				var opts=tab.panel("options")
				var dow=opts.title
				//var ret=tkMakeServerCall("web.DHCRBResSession","TRInfoCalculateNew",TRStartTime,TREndTime,TRRegNum,TRStartNum)
				var NewSessionTpye = toBeSaved(changes.ASSessionType)
				var NewTimeRange = toBeSaved(changes.TimeRange)
				var NewASRoom = toBeSaved(changes.ASRoom)
				var NewASLoad = changeToInt(changes.ASLoad,rowData.ASLoad)
				var NewASAppLoad = changeToInt(changes.ASAppLoad,rowData.ASAppLoad)
				var NewASAddLoad = changeToInt(changes.ASAddLoad,rowData.ASAddLoad)
				var NewScheduleGenerFlag = changeToInt(changes.ScheduleGenerFlag,rowData.ScheduleGenerFlag)
				if(!validateUpdate(rowData.RBDSROWID,dow,NewSessionTpye,NewTimeRange,NewASRoom,NewASLoad,NewASAppLoad,NewASAddLoad,NewScheduleGenerFlag)){
					$("#"+GridId).datagrid('rejectChanges'); return false
				}
				UpdateStr = NewSessionTpye + "^" + NewTimeRange + "^" + NewASRoom + "^" + NewASLoad + "^" + NewASAppLoad + "^" + NewASAddLoad + "^" + NewScheduleGenerFlag
				$("#"+GridId).datagrid("updateRow",{
					index:rowIndex,
					row:{
						ASQueueNoCount:changeToInt(changes.ASLoad,rowData.ASLoad) + changeToInt(changes.ASAppLoad,rowData.ASAppLoad) + changeToInt(changes.ASAddLoad,rowData.ASAddLoad)
					}
				})
				var ret = tkMakeServerCall("web.DhcResEffDateSessionClass","Update",rowData.RBDSROWID + "^" + dow + "^" + UpdateStr)
				alert(ret)
				$("#"+GridId).datagrid("refreshRow",rowIndex)
			}
		},
		*/
		onBeforeEdit:function(rowIndex, rowData){
			
		},
		onDblClickRow:function(rowIndex,rowData){
			AddFlag = 0
			DblClickFun(rowIndex,rowData)
		}
	});
 }
 
function DblClickFun(rowIndex,rowData){
	ClearWinData();
	//LimitText("readonly");
	$("#ASRowID").attr("value",rowData.RBDSROWID);
	var ret = tkMakeServerCall("web.DhcResEffDateSessionClass","GetDataStrByASRowid",rowData.RBDSROWID)
	var retArray = ret.split("^");
	var LocDr = retArray[0]
	var Docdr = retArray[1]
	var ASSessionTypeDR = retArray[2]
	var ASTimeRangeDR = retArray[3]
	var ASRoomDr = retArray[4]
	var ASLoad = retArray[5]
	var ASAppLoad = retArray[6]
	var AddLoad = retArray[7]
	var ScheduleGenerFlag = retArray[8]
	var EStartPrefix = retArray[9]
	var TRRegNum = retArray[10]
	var TRRegNumStr = retArray[11]
	var TRRegInfoStr = retArray[12]
	var AutoLoad = "" //retArray[13]
	var ExtLoad = "" //retArray[14]
	var ClinicGroupDR = retArray[15]
	var TRLenghth=retArray[16]
	var TRflag=retArray[17] //分时段就诊标志
	var TRSttime=retArray[18] //分时段就诊开始时间
	var TREnTime=retArray[19] //分时段就诊结束时间
	//alert(AutoLoad+","+ExtLoad)
	InitLocCombo(ExaRowid,LocDr);
	if ($("#AdmLoc").combogrid("getText")==""){
		$("#AdmLoc").combogrid("setText",$("#AdmLoc").combogrid("grid").datagrid('getSelected').name);
	}
	LoadLocArea("");
	//$("#LocArea").combogrid("grid").datagrid("loadData", ASRoomData);
	var DocID = tkMakeServerCall("web.DhcResEffDateSessionClass","GetDocIDByRBRowid",rowData.RBDSROWID.split("||")[0])
	$("#AdmDoc").combogrid('grid').datagrid("selectRecord",DocID.toString());
	if (($("#AdmDoc").combogrid("getText")=="")&&($("#AdmDoc").combogrid("grid").datagrid('getSelected'))){
		$("#AdmDoc").combogrid("setText",$("#AdmDoc").combogrid("grid").datagrid('getSelected').name);
	}
	
	AddResEffDateSession(rowData);
	
	
	$("#TimeRange").combogrid('grid').datagrid("selectRecord",ASTimeRangeDR.toString());
	if ($("#TimeRange").combogrid("getText")==""){
		$("#TimeRange").combogrid("setText",$("#TimeRange").combogrid("grid").datagrid('getSelected').Desc);
	}
	
	$("#DocSession").combogrid('grid').datagrid("selectRecord",ASSessionTypeDR.toString());
	if ($("#DocSession").combogrid("getText")==""){
		$("#DocSession").combogrid("setText",$("#DocSession").combogrid("grid").datagrid('getSelected').Desc);
	}
	$("#LocArea").combogrid('grid').datagrid("selectRecord",ASRoomDr.toString());
	
	$("#PositiveMax").attr('value',ASLoad);
	$("#ApptMax").attr('value',ASAppLoad);
	$("#AddtionMax").attr('value',AddLoad);
	$("#EStartPrefix").attr('value',EStartPrefix);
	//$("#AutoLoad").attr('value',AutoLoad);
	//$("#ExtLoad").attr('value',ExtLoad);
	$("#TRLength").attr('value',TRLenghth);
	$("#TRRegNum").attr('value',TRRegNum);
	$("#TRRegNumStr").attr('value',TRRegNumStr);
	$("#TRRegInfoStr").attr('value',TRRegInfoStr);
	if(ScheduleGenerFlag=="1"){
		$("#ScheduleGenerFlag").attr('checked',true);
	}else{
		$("#ScheduleGenerFlag").attr('checked',false);
	}
	if (TRflag=="Y"){
		$("#TRFlag").attr('checked',true);
	}else{
		$("#TRFlag").attr('checked',false);
	}
	
	if(ClinicGroupDR!=""){
		$("#ClinicGroup").combogrid("setValue",ClinicGroupDR);
		//$("#ClinicGroup").combogrid("setText",'');
		//setTimeout($("#ClinicGroup").combogrid('grid').datagrid("selectRecord",ClinicGroupDR.toString()),5000)	
	}
}
 
function validateUpdate(Rowid,DOW,SessionTpye,TimeRange,ASRoom,ASLoad,ASAppLoad,ASAddLoad,ScheduleGenerFlag){
	if (SessionTpye==''){
		$.messager.alert('错误', "职称不能为空！");
		return false;
	}
	if (TimeRange==''){
		$.messager.alert('错误', "时段不能为空！");
		return false;
	}
	if (TimeRange==''){
		$.messager.alert('错误', "出诊时段不能为空！");
		return false;
	}
	if (ASRoom==''){
		$.messager.alert('错误', "诊室不能为空！");
		return false;
		}
	if (ASLoad==''){
		$.messager.alert('错误', "正号限额不能为空！ ");
		return false;
	}

	if ((parseInt(ASLoad))<(parseInt(ASAppLoad))){
		$.messager.alert('错误', "正号限额不能小于预约限额！ ");
		return false;
	}
	/*
	if (parseInt(EApptMax)!=0){
		if ((parseInt(EPositiveMax)-parseInt(EStartPrefix)+1)<(parseInt(EApptMax))){
			$.messager.alert('错误', "正号限额减去预约起始号要大于等于预约限额！  ");
			return false;
		}
	}
	*/
	
	if (parseInt(ASLoad)>999){
		$.messager.alert('错误', "正号限额不能超过999!");
		return false;
	}
	
	if (parseInt(ASAppLoad)>99){
		$.messager.alert('错误', "预约限额不能超过99!");
		return false;
	}	

	return true;
}
function toBeSaved(s){
	if(s){
		return s
	}else{
		return "NoChange"
	}
}
function changeToInt(a,b){
	if(a){
		return parseInt(a)
	}else if(!a&&b){
		return parseInt(b)
	}else{
		return 0
	}
}
function InitWinComboGrid(){
		InitLocCombo(ExaRowid,LocRowid)
		LoadLocArea("") 
		//$("#LocArea").combogrid("grid").datagrid("loadData", ASRoomData);
}
function InitLocCombo(ERowid,LRowid){
	var LocData = eval('(' + tkMakeServerCall("web.DhcResEffDateSessionClass","GetLocByBoruID",ERowid) + ')');
	$("#AdmLoc").combogrid("grid").datagrid("loadData",LocData);
	if(LRowid!=""){
		LoadClinicGroup(LRowid);
		$("#AdmLoc").combogrid('grid').datagrid("selectRecord",LRowid.toString());
		
	}
}
function InitDocCombo(DRowid){
	var LocID = $('#AdmLoc').combogrid("getValue");
	var DocDataStr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetRSDocByLocID",LocID,session['LOGON.USERID'])
	var DocData = eval('(' + DocDataStr + ')'); 
	$("#AdmDoc").combogrid("grid").datagrid("loadData",DocData);
	if(DRowid!=""){
		$("#AdmDoc").combogrid('grid').datagrid("selectRecord",DRowid.toString());
	}
}
 
function GetDateStr(AddDayCount) { 
	var dd = new Date(); 
	dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期 
	var y = dd.getFullYear();
	var m = dd.getMonth()+1;//获取当前月份的日期 
	if (Number(m)<10) m="0"+m
	var d = dd.getDate(); 
	if (Number(d)<10) d="0"+d
	return y+"-"+m+"-"+d; 
} 
function ScheduleGridLoad(GridId,StartDate,LocRowid,DocRowid,ExaRowid)
 {
	 $("#"+GridId).datagrid('uncheckAll');
	// alert(LocRowid+","+DocRowid)
	var tab=$('#ScheduleTab').tabs("getSelected");
	var weekindex = $('#ScheduleTab').tabs('getTabIndex',tab);
	weekindex=weekindex+1;
	var queryParams = new Object();
	queryParams.ClassName ='web.DhcResEffDateSessionClass';
	queryParams.QueryName ='GetApptSchedule';
	queryParams.Arg1 =LocRowid;
	queryParams.Arg2 =DocRowid;
	queryParams.Arg3 =StartDate;
	//queryParams.Arg4 =StartDate;
	queryParams.Arg4 =weekindex;
	queryParams.Arg5 =userid;
	queryParams.Arg6 =groupid;
	queryParams.Arg7 ="";	// 资源ID
	queryParams.Arg8 =ExaRowid;
	queryParams.ArgCnt = 8;
	var opts = $("#"+GridId).datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	$("#"+GridId).datagrid('load', queryParams); 
 }
 
 function InitLocDocTree(){
	var url = "dhcrbapptschedulequeryrequest.csp?pid=0&userid="+userid+"&groupid="+groupid ;
	$("#LocDocTree").tree({
		url:url,
		multiple:true,
		lines:true,
		onCheck:function(node,checked){
			//AddDataToSelLocDoc(node,checked)
		},
		onBeforeExpand:function(node,param){
             $("#LocDocTree").tree('options').url = "dhcrbapptschedulequeryrequest.csp?pid="+node.id+"&action=appt"+"&userid="+userid+"&groupid="+groupid+"&docdesc="+escape($.trim($("#SerchDoc").val()));
		}, 
		onLoadSuccess:function(node,data){
		},
		onSelect:function(node){
			ExaRowid="";
			LocRowid="";
			DocRowid="";
			var id=node.id
			var idArr=id.split("^")
			if(idArr[0]=="Loc"){
				LocRowid=idArr[1]
				var parentNode=$("#LocDocTree").tree("getParent",node.target) ;
				if (parentNode){
					var parentNodeid=parentNode.id ;
					var parentNodeidArr=parentNodeid.split("^")
					ExaRowid=parentNodeidArr[1];
				}else{
					ExaRowid=idArr[2];
				}
				FindScheduleByLoc(LocRowid,"",ExaRowid)
				if(OldExaRowid!=ExaRowid){
					GetASRoomData(ExaRowid);
					OldExaRowid = ExaRowid;
				}
			}else if (idArr[0]=="Doc"){
				DocRowid=idArr[1];
				var parentNode=$("#LocDocTree").tree("getParent",node.target) ;
				var parentNodeid=parentNode.id ;
				var parentNodeidArr=parentNodeid.split("^");
				LocRowid=parentNodeidArr[1];
				var grandPaNode = $("#LocDocTree").tree("getParent",parentNode.target);
				if (grandPaNode){
					var grandPaNodeid=grandPaNode.id ;
					var grandPaNodeidArr=grandPaNodeid.split("^");
					ExaRowid=grandPaNodeidArr[1];
				}else{
					ExaRowid=parentNodeidArr[2];
				}
				FindScheduleByLoc(LocRowid,DocRowid,"")
				if(OldExaRowid!=ExaRowid){
					GetASRoomData(ExaRowid);
					OldExaRowid = ExaRowid;
				}
			}else{
				ExaRowid=idArr[1] ;
				FindScheduleByLoc("","",ExaRowid)
				if(OldExaRowid!=ExaRowid){
					GetASRoomData(ExaRowid);
					OldExaRowid = ExaRowid;
				}
			}	
		}
		
	}); 
 }
function GetASRoomData(ERowid){
	ASRoomData =eval('(' + tkMakeServerCall("web.DhcResEffDateSessionClass","GetConsultingRoomByBoruID",ERowid) + ')'); 
}
 
 function FindScheduleByLoc(LocRowId,DocrowId,ExaRowId)
 {
	var tab=$('#ScheduleTab').tabs("getSelected");
	
	var opts=tab.panel("options")
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	//if (document.getElementById("ScheduleGrid"+index)) return
	var title=opts.title
	var StartDate=title.split("(")[0]
	ScheduleGridLoad("ScheduleGrid"+index,StartDate,LocRowId,DocrowId,ExaRowId)
	 
 }
 
 function ClearWinData()
 {
	$("#ASRowID").attr('value','');
	$("#AdmLoc").combogrid("setValue", '');
	$("#LocArea").combogrid("setValue", '');
	$("#TimeRange").combogrid("setValue", '');
	$("#ClinicGroup").combogrid("setValue", '');
	$("#ClinicGroup").combogrid("setText", '');
	$("#AdmDoc").combogrid("setValue", '');
	$("#DocSession").combogrid("setValue", '');
	$("#ClinicGroup").combogrid("setValue", '');
	$("#ClinicGroup").combogrid("setText", '');
	$("#PositiveMax").attr('value','');
	$("#ApptMax").attr('value','');
	$("#AddtionMax").attr('value','');	
	$("#EStartPrefix").attr('value','');
	
	//$("#AutoLoad").attr('value','');
	//$("#ExtLoad").attr('value','');
	$("#TRStartTime").attr('value','');
	$("#TREndTime").attr('value','');
	$("#TRLength").attr('value','');
	$("#TRRegNum").attr('value','');
	$("#TRRegNumStr").attr('value','');
	$("#TRRegInfoStr").attr('value','');
	
	$("#ScheduleGenerFlag").attr('checked',true);
	$("#TRFlag").attr('checked',false);
	//$("#TRFlag").attr('checked',true);
	//$("#TRFlag").attr('disabled',true);
	

 }
 function ShowCreateScheduleWin(){
	 var tab=$('#ScheduleTab').tabs("getSelected");
     var index = $('#ScheduleTab').tabs('getTabIndex',tab);
     if (index>=5){
	     $("#tr-EndDate").attr("style","display:none;");
	     $("#CreateDateScheduleWin").panel("setTitle","请选择需要生成排班的日期");
	 }else{
		 $("#tr-EndDate").removeAttr("style");
		 $("#CreateDateScheduleWin").panel("setTitle","请选择需要生成排班的日期段");
	 }
	 $("#CreateScheduleSttDate").datebox("setValue","");  
     $("#CreateScheduleEndDate").datebox("setValue",""); 
	 $("#CreateDateScheduleWin").window("open")
 }
 function CheckLocIsEmergency(){
    var selObj=$("#LocDocTree").tree("getSelected")
	if(selObj){
		if(selObj.text.indexOf("急诊")>=0){
				return true
	    }
	}
	return false;
 }
 function CreateDateSchedule(){
	 var SttDate=$("#CreateScheduleSttDate").datebox("getValue");  
	 var EndDate=$("#CreateScheduleEndDate").datebox("getValue"); 
	 var tab=$('#ScheduleTab').tabs("getSelected");
     var index = $('#ScheduleTab').tabs('getTabIndex',tab);
     var GridId = "ScheduleGrid"+index;
     var EmergencyFlag=CheckLocIsEmergency();
     var ASStr = ""
     if(!EmergencyFlag){
	     var rows = $("#"+GridId).datagrid('getRows');
	 }else{
		 var rows=$("#"+GridId).datagrid('getSelections');
	 }
     for(var i =0;i<rows.length;i++){
		     if (ASStr=="") ASStr=rows[i].RBDSROWID;
	         else ASStr=ASStr+"^"+rows[i].RBDSROWID;
	 }
	 if ((EmergencyFlag)&&(ASStr=="")){
		 $.messager.alert('提示','请选择需要生成排班的急诊模板!');
		 return false;
	 }else{
		if(ASStr==""){
			$.messager.alert('提示',"排班模板为空,不能生成排班!")
			return false
		}	 
	 }
	 
     if (index>=5){
	     if (SttDate==""){
		  $.messager.alert('提示','请输入日期!');
		  return false;
	    }
	    $.messager.confirm('确认对话框', '是否要生成日期 '+SttDate+' 的排班记录?', function(r){
			if (r){
			    CreateSchedule(SttDate,'',index+1,ASStr);
			}else{
				return false;
			}
		});
	 }else{
		if((SttDate=="")||(EndDate=="")){
		  $.messager.alert('提示','请输入开始日期和结束日期!');
		  return false;
	    }
	    var title=tab.panel("options").title;
        var DateFiffDays=DateDiff(SttDate, EndDate);
	    $.messager.confirm('确认对话框', '是否要生成 '+SttDate+' 至 '+EndDate+'时间段内 '+title+' 的排班记录?', function(r){
			if (r){
				if (parseInt(DateFiffDays)>180){
					$.messager.confirm('确认对话框', "生成的排班记录超过180天,是否继续?", function(r){
						if (r){
							CreateSchedule(SttDate,EndDate,index+1,ASStr);
						}
					})
				}else{
					CreateSchedule(SttDate,EndDate,index+1,ASStr);
				}
			}else{
				return false;
			}
		});
	 }
	 $('#CreateDateScheduleWin').window('close', true); 
 }
 
//计算两个日期天数差的函数，通用
function DateDiff(sDate1, sDate2) {  //sDate1和sDate2是yyyy-MM-dd格式
    var aDate, oDate1, oDate2, iDays;
    if (DateFormat==3){
	    aDate = sDate1.split("-");
    	oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);  //转换为yyyy-MM-dd格式
    	aDate = sDate2.split("-");
    	oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);
	}else if(DateFormat==4){
		aDate = sDate1.split("/"); // 12/02/2018
    	oDate1 = new Date(aDate[2] + '-' + aDate[1] + '-' + aDate[0]);  //转换为yyyy-MM-dd格式
    	aDate = sDate2.split("/");
    	oDate2 = new Date(aDate[2] + '-' + aDate[1] + '-' + aDate[0]);
	}
    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24); //把相差的毫秒数转换为天数
    return iDays;  //返回相差天数
}
 function CreateSchedule(SttDate,EndDate,week,ASSESSRowIdStr){
	// alert(SttDate+","+EndDate+","+week)
	 if(EndDate=="") EndDate=SttDate
	 var DocStr=tkMakeServerCall('web.DHCCPSchedBatch','GeneSched',SttDate,EndDate,0,"",week,ASSESSRowIdStr);
	 if(DocStr!=""){
		 $.messager.alert("提示","排班生成成功!");
	 }else{
		 $.messager.alert("提示","没有需要生成的排班记录.(没有维护排班记录或该医生已生成排班)");
		 return false;
	 }
 } 
 function AddResEffDateSession(rowData)
 {
	//var tab = $('#ScheduleTab').tabs('getSelected');
	//var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	//var GridId="ScheduleGrid"+index
	//var rows=$("#ScheduleGrid0").datagrid("getSelections")
	//$("#EditWin").window({onBeforeClose}
	
	//$("#AdmDate").combogrid("setValue", '');
	
	//alert(ExaRowid+"__"+LocRowid+"__"+DocRowid)
	
	var tab=$('#ScheduleTab').tabs("getSelected");
	var opts=tab.panel("options")
	var dow=opts.title
	var tabIndex = $('#ScheduleTab').tabs('getTabIndex',tab);
	if(rowData!=""){
		$("#EditWin").panel({title:"修改排班模板"+"<font color='red'>("+dow+")</font>"});
		$("#EditWin").window("open")
		InitUpdateCombo();
		
	}else{
		/*if(ExaRowid == ""){
			$.messager.alert('提示',"请选择分诊台")
			return
		}*/
		InitAddCombo()
		//$('#ClinicGroup').combobox('disable');
		$("#EditWin").panel({title:"新增排班模板"+"<font color='red'>("+dow+")</font>"});
	
		$('#EChkRep').attr("disabled",true);
		$('#EChkStop').attr("disabled",true);
	
		$("#EditWin").window("open")
	}
	
	
 }
 
function InitUpdateCombo(){
	LimitCombo('disable')
}

function InitAddCombo(){
	LimitCombo('enable')
}
 
 function LimitCombo(flag)
 {
	$('#AdmLoc').combobox(flag);
	$('#AdmDoc').combobox(flag);
	//$('#ClinicGroup').combobox(flag);
 }
 function LimitText(flag)
 {
	$("#PositiveMax").attr("readonly",flag);
	$("#TRStartTime").attr("readonly",flag);
	$("#TREndTime").attr("readonly",flag);
	$("#TRRegNum").attr("readonly",flag);
	$("#TRRegNumStr").attr("readonly",flag);
	$("#TRLength").attr("readonly",flag);
	$("#TRRegInfoStr").attr("readonly",flag);
	$("#EStartPrefix").attr("readonly",flag);
 }
 
function DocSelectFun(){
	if ((!$('#AdmLoc').combogrid('grid').datagrid('getSelected'))||(!$('#AdmDoc').combogrid('grid').datagrid('getSelected'))) return false;
	var LocSelectedId = $('#AdmLoc').combogrid('grid').datagrid('getSelected').id;
	var DocSelectedId = $('#AdmDoc').combogrid('grid').datagrid('getSelected').id; 
	var TimeRange=$("#TimeRange").combogrid("getValue");
	if(AddFlag == 1){
		var ret = tkMakeServerCall("web.DhcResEffDateSessionClass","GetDataStrByDocIdAndLocId",DocSelectedId,LocSelectedId,TimeRange)
		var retArray = ret.split("^")
		var SessTypeDR = retArray[0]
		var RESLoad = retArray[1]
		var RESAppLoad = retArray[2]
		var RESAppStartNum = retArray[3]
		var RESAddLoad = retArray[4]
		var RESTRLength = retArray[5]
		var RESTRRegNum = retArray[6]
		var ClinicGroupDR = retArray[7]
		if(TimeRange!=""){
			//var RESTAutoLoad=retArray[7]
			//var RESTExtLoad=retArray[8]
			var ClinicGroupDR = retArray[9]
			//$("#AutoLoad").val(RESTAutoLoad);
			//$("#ExtLoad").val(RESTExtLoad)
		}
		//$("#DocSession").combogrid('grid').datagrid("selectRecord",SessTypeDR.toString());
		$("#PositiveMax").attr('value',RESLoad);
		$("#ApptMax").attr('value',RESAppLoad);
		$("#EStartPrefix").attr('value',RESAppStartNum);  
		$("#AddtionMax").attr('value',RESAddLoad);
		/*if(RESLoad-3>0){
			$("#TRRegNum").attr('value',RESLoad-3);
		}else{
			$("#TRRegNum").attr('value',"");
		}*/
		$("#ClinicGroup").combogrid('grid').datagrid("selectRecord",ClinicGroupDR.toString());
	}
}
 
 ///排班修改窗口初始化
 ///初始化科室
function InitWinCombo()
{	
	$('#AdmLoc').combogrid({
		panelWidth:250,
		panelHeight:380,
		delay: 0,
		//mode: 'remote',
		//url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,
		striped: true,
		editable:true,
		//pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		//method:'post',
		idField: 'id',
		textField: 'name', 
		columns: [[
			{field:'name',title:'科室名称',width:400,sortable:true},
			{field:'id',title:'id',width:120,sortable:true,hidden:true},
			{field:'code',title:'code',width:120,sortable:true,hidden:true}
			
		]],
		onSelect:function(rowIndex,rowData){
			$("#ClinicGroup").combogrid("setValue",'');
			$("#ClinicGroup").combogrid("setText",'');
			LoadClinicGroup(rowData.id);
			setTimeout(function(){
				InitDocCombo(DocRowid);
				if(!FirstOpenAddWin){
					$("#AdmDoc").combogrid("setValue",'');
				}
				LoadLocArea("");
				FirstOpenAddWin = false
			},500)	
		},
		filter: function(q, row){
			var opts = $(this).combogrid('options');
		    return ((row["code"].indexOf(q.toUpperCase())>=0)||(row[opts.textField].indexOf(q.toUpperCase()) >= 0));

		}

	});
	
/*$('#LocArea').combogrid({
		panelWidth:200,
		panelHeight:380,
		delay: 0,
		//mode: 'remote',   
		//url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,
		editable:true,
		//pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		//method:'post', 
		idField: 'RowId',    
		textField: 'name', 
		columns: [[    
			{field:'Desc',title:'诊室名称',width:400,sortable:true},
			{field:'RowId',title:'id',width:20,sortable:true,hidden:true}
		]],
		onSelect:function(rowIndex,rowData){
		},
		keyHandler:{
		}
	});*/
	$('#LocArea').combogrid({
		panelWidth:400,
		panelHeight:380,
		delay: 0,    
		mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'诊室名称',width:400,sortable:true},
			{field:'RowId',title:'RowId',width:20,sortable:true,hidden:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#LocArea').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#LocArea').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#LocArea').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#LocArea').combogrid('grid').datagrid('getRows');
                    $('#LocArea').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#LocArea').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#LocArea').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#LocArea').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#LocArea').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#LocArea').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#LocArea').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      $('#LocArea').combogrid("options").value=selected.RowId;
			    }
                //选中后让下拉表格消失
                $('#LocArea').combogrid('hidePanel');
				//$("#LocArea").focus();
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadLocArea('"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadLocArea('"+q+"')",400)
				}

				$('#LocArea').combogrid("setValue",q);
				//LoadDiagnosData(q);
				
            }
		},onShowPanel:function(){
			LoadLocArea("");
		}
	});
	
	$("#AdmDoc").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,
		//mode: 'remote',
		//url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		//method:'post', 
		idField: 'id',    
		textField: 'name', 
		columns: [[    
			{field:'name',title:'医生',width:150,sortable:true},
			{field:'id',title:'id',width:20,hidden:true},
			{field:'code',title:'code',width:120,sortable:true,hidden:true}
		]],
		onSelect: function (rowIndex, rowData){
			var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeByDocId",rowData.id,$("#AdmLoc").combogrid("getValue"));
			if(sessTypeDr != ""){
				$("#DocSession").combogrid('grid').datagrid("selectRecord",sessTypeDr.toString());
			}
			DocSelectFun()
		},
		onChange:function(newValue, oldValue){
			if (newValue==""){
				$("#AdmDoc").combogrid("setValue", '');
				$("#AdmDoc").combogrid('grid').datagrid("unselectAll");
			}
		} ,
		filter: function(q, row){
			var opts = $(this).combogrid('options');
		    return ((row["code"].indexOf(q.toUpperCase())>=0)||(row[opts.textField].indexOf(q.toUpperCase()) >= 0));
		}
	});
	
	/// 选项不多, 不做检索了
	$("#TimeRange").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,
		//mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'时段',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]],
		onSelect: function (){
			var selected = $('#TimeRange').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
				var encmeth=GetTRTimeStrMethod.value;
				if (encmeth!=''){
					var ret=cspRunServerMethod(encmeth,selected.RowId);
					var Arr=ret.split("^");
					var SessTimeStart=Arr[0];
					var SessTimeEnd=Arr[1];
					$('#TRStartTime').attr('value',SessTimeStart);
					$('#TREndTime').attr('value',SessTimeEnd);
					//var RegNumAndStr=tkMakeServerCall("web.DHCRBResSession","TRInfoCalculateNew",SessTimeStart,SessTimeEnd,30,1)
				}
				$('#TimeRange').combogrid('hidePanel');
				DocSelectFun();
			}
		},
		onChange:function(newValue, oldValue){
			if (newValue==""){
				$("#TimeRange").combogrid("setValue", '');
				$("#TimeRange").combogrid('grid').datagrid("unselectAll");
			}
		},onShowPanel:function(){
			var queryParams = new Object();
			queryParams.ClassName = "web.DHCApptScheduleNew";
			queryParams.QueryName = "LookUpTimeRange";
			queryParams.Arg1 = CurrDate.split("^")[0];
			queryParams.ArgCnt = 1;
			InitComboData('#TimeRange',queryParams)
		}
		
	});
			
	$("#DocSession").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		//mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'职称',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]],
		onChange:function(newValue, oldValue){
			if (newValue==""){
				$("#DocSession").combogrid("setValue", '');
				$("#DocSession").combogrid('grid').datagrid("unselectAll");
			}
		}	   
	});
	
	
	$("#ClinicGroup").combogrid({
		panelWidth:150,
		panelHeight:200,
		delay: 0,    
		//mode: 'remote',    
		url: PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		method:'post', 
		idField: 'RowId',    
		textField: 'Desc', 
		columns: [[    
			{field:'Desc',title:'亚专业',width:150,sortable:true},
			{field:'RowId',title:'RowId',width:20,hidden:true}
		]]	   
	});

	LoadOtherCombo() ;

} 

function InitComboData(ComboGridID,queryParams)
{
	var jQueryComboGridObj = $(ComboGridID);
	var opts = jQueryComboGridObj.combogrid("grid").datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	opts.queryParams = queryParams;
	jQueryComboGridObj.combogrid("grid").datagrid("reload");
}


function LoadAdmLoc(q)
{
	var desc=q;
	//if (desc=="") return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FindLoc'; 
	queryParams.Arg1 =desc;
	queryParams.Arg2 =userid;
	queryParams.Arg3 =groupid;
	queryParams.ArgCnt =3;
	InitComboData('#AdmLoc',queryParams)
}

function LoadAdmDoc(AdmLocID)
{
	//$("#AdmDoc").combogrid('loadData', { total: 0, rows: [] }); 
	$("#AdmDoc").combogrid("grid").datagrid("reload");
	if (AdmLocID=="") return;
	var TimeRange=$("#TimeRange").combogrid("getValue");
	var AdmDate=$("#AdmDate").datebox("getValue");
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FinNoRegDoc';
	queryParams.Arg1 =AdmDate;
	queryParams.Arg2 =AdmLocID;
	queryParams.Arg3 =TimeRange;
	queryParams.ArgCnt =3;
	InitComboData('#AdmDoc',queryParams)
	InitComboData('#EAdmDoc',queryParams)
}

///初始化诊室
function LoadLocArea(q) 
{
	var LocID = $('#AdmLoc').combogrid("getValue");
	var desc=q;
	var queryParams = new Object();
	var ClassName = "web.DHCApptScheduleNew";
	//var QueryName = "LookUpRoomByUser";
	var QueryName = "LookUpRoomByUserNew";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = desc;
	queryParams.Arg2 = userid;
	queryParams.Arg3 = LocID;
	queryParams.ArgCnt = 3;
	InitComboData('#LocArea',queryParams)
} 

function LoadOtherCombo() 
{
	//var CurrDate=tkMakeServerCall("web.DHCBatchStopNew","GetCurrDate");
	var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpTimeRange";
		queryParams.Arg1 = CurrDate.split("^")[0];
		queryParams.ArgCnt = 1;
		InitComboData('#TimeRange',queryParams)
	
	var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpSessionType";
		queryParams.Arg1 = CurrDate.split("^")[0];
		queryParams.ArgCnt = 1;
		InitComboData('#DocSession',queryParams)
	LoadClinicGroup("");	
}
function LoadClinicGroup(LocRowid){
	//if (LocRowid=="") return ;
	var queryParams = new Object();
		queryParams.ClassName = "web.DHCApptScheduleNew";
		queryParams.QueryName = "LookUpClinicGroupAll";
		queryParams.Arg1=LocRowid
		queryParams.ArgCnt =1;
		InitComboData('#ClinicGroup',queryParams)
}
 
 function formatdate(Date)
 {
	return tkMakeServerCall("web.DHCBatchStopNew","FormatStringToDate",Date)	  ;
 }
 
 function formattime(Time)
 {
	return tkMakeServerCall("web.DHCBatchStopNew","FormatStringToTime",Time)	  ;
 }
 function InittabRBASApptNum(RBASRowId,ASAppLoad,AppStartSeqNo)
 {
	 var RBASApptToolBar = [{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
			  var rows = RBASApptDataGrid.datagrid("getRows"); 
			  var AppQtySum=0,paraString="";
			  for(var i=0;i<rows.length;i++){
				  var ASQRowId=rows[i].ASQRowId;
				  var ApptMethodDr=rows[i].ApptMethodDr;
				  var editors = RBASApptDataGrid.datagrid('getEditors', i); 
				  var AppQty =  editors[0].target.val();
				  AppQtySum=AppQtySum+(+AppQty);
				  var AppStartNum =  editors[1].target.val();
				  var r = /^\+?[0-9][0-9]*$/;　　//正整数
				  if (!r.test(+AppStartNum)){
					  $.messager.alert('错误', AppStartNum+",不是有效的数字!");
				      return false;
				  }
				  if (!r.test(+AppQty)){
					  $.messager.alert('错误', AppQty+",不是有效的数字!");
				      return false;
				  }
				  if ((+AppStartNum<0)||(+AppQty<0)){
					   $.messager.alert('错误', "各个预约机的预约起始号和预约限额不能小于0!");
				      return false;
				  }
				  if(((+AppStartNum)<(+AppStartSeqNo))&&(+AppStartNum!=0)){
					  $.messager.alert('错误', "各个预约机构预约的预约起始号不能小于预约排班的预约起始号:"+AppStartSeqNo);
				      return false;
				  }
				  if(paraString=="") paraString=ASQRowId+"^"+ApptMethodDr+"^"+AppQty+"^"+AppStartNum;
				  else paraString=paraString+","+ASQRowId+"^"+ApptMethodDr+"^"+AppQty+"^"+AppStartNum;
			  }
			  if(AppQtySum>(+ASAppLoad)){
				  $.messager.alert('错误', "各个预约机构预约限额总和不能大于预约限额:"+ASAppLoad);
				  return false;
			  }
			  var retcode = tkMakeServerCall("web.DHCRBResEffDateSessAppQty","SaveScheduleAppQty",paraString);
			  if(retcode!=0){
				  $.messager.alert('错误', "保存失败"+retcode);
				  return false;
			  }
			  $('#EditApptNumWin').window('close', true); 
            }
        }];
        //ASQRowId:%String,ApptMethodDr:%String,AppMethodName:%String,AppQty:%String,AppStartNum:%String
	RBASApptColumns=[[    
                    { field: 'ASQRowId', title: 'ASQRowId', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'ApptMethodDr', title: 'ApptMethodDr', width: 1, align: 'center', sortable: true,hidden:true
					},
        			{ field: 'AppMethodName', title: '预约方式', width: 150, align: 'center', sortable: true
					},
					{ field: 'AppQty', title: '预约限额',  align: 'center', sortable: true,
					   editor : {
                                type : 'text'
                       }
					},
					{ field: 'AppStartNum', title: '预约起始号',  align: 'center', sortable: true,
					   editor : {
                                type : 'text'
                       }
					}
    			 ]];
	RBASApptDataGrid=$('#tabRBASApptNum').datagrid({  
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ApptMethodDr",
		pageList : [15,50,100,200],
		columns :RBASApptColumns,
		toolbar :RBASApptToolBar,
		onBeforeLoad:function(param){
			if(RBASRowId=="") return false;
	        param.ClassName ='web.DHCRBResEffDateSessAppQty';
	        param.QueryName ='FindAppQty';
	        param.Arg1 =RBASRowId;
	        param.ArgCnt =1;
	    },
	    onLoadSuccess:function(data){
		    for(var index=0;index<data.total;index++){
			    RBASApptDataGrid.datagrid('beginEdit',index);
			}
		}
	});
 }
 function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (DateFormat==3){
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if(DateFormat==4){
		return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
		//return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}
			
}
function myparser(s){
	if (!s) return new Date();
	if (DateFormat==3){
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}else if(DateFormat==4){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}
	
}

 
 