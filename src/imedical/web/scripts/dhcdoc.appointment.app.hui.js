var PageLogicObj = {
	RBApptScheduleList:"",
	ASRowId:"", //选择的出诊记录
	OldID:"",
	OldColor:"",
	SelectSeqNum:"", //分时段选择就诊号
	SelectMethcode:"", //选择就诊号所在预约方式CODE
	SelectTimeRange:"", //分时段选择时段信息
	AppAddFlag:"",
	PatientNo:""
}
$(function(){
	//页面元素初始化
	PageHandle();
	//事件初始化
	InitEvent();
	$("#CardNo").focus();
});
function PageHandle(){
	//证件信息
	$("[name='CCreadNum'],[name='mesage']").hide()
	//根据配置设置是否可以无卡预约
	if (ServerObj.CanNoCardApp!="Y"){
		$("#CNoCardApp").hide()
	}
	//默认展示预约按钮
	$("#CAppoint").show();
	$("#CAdd").hide()
	;PageLogicObj.AppAddFlag="APP"
	//无卡预约展示证件信息填写位置
	$("#NoCardApp").checkbox({
		onChecked:function(){
			ClearPatInfo("N");
			if ((ServerObj.CommonCardNoStr.split("&").length)>1){
			   $('#CommonCardWin').window('open');	
			   InitCommonCardWin();
			}else{
				CommonCardclickRadio(ServerObj.CommonCardNoStr)
			}
			$("[name='CCreadNum'],[name='mesage']").show()
		},
		onUnchecked:function(){
			$("[name='CCreadNum'],[name='mesage']").hide();
			ClearPatInfo();
		}
	})
	//初始化患者信息
	if (ServerObj.PatNo!=""){
		$("#PatNo").val(ServerObj.PatNo)
		PatNoSearch()
	}
	//初始化出诊记录
	PageLogicObj.RBApptScheduleList=intAppTable()
	document.onkeydown = DocumentOnKeyDown;
	if (window.parent.PageLogicObj.LockPatientID==""){
		$("#BLockPatient").find(".l-btn-text").text($g("锁定患者"));
	}else{
		$("#BLockPatient").find(".l-btn-text").text($g("取消锁定"));
		ServerObj.PatientID=window.parent.PageLogicObj.LockPatientID
		if (ServerObj.PatientID!=""){
			var PatNo=$.cm({
				ClassName:"web.DHCDocAppointmentHui",
				MethodName:"GetPatientNo",
				dataType:"text",
				PatientID:ServerObj.PatientID
			},false);
			ServerObj.PatNo=PatNo
		}
		//初始化患者信息
		if (ServerObj.PatNo!=""){
			$("#PatNo").val(ServerObj.PatNo)
			PatNoSearch()
		}	
	}
}
function InitEvent()
{
	//预约
	$("#Appoint").click(function(){AppointClick("APP")});
	//预约
	$("#Add").click(function(){AddClick("DOCADD")});
	//回车事件
	$("#PatNo").keydown(function (e){
			var keycode = e.which;
			if(keycode==13){
				var patno=$("#PatNo").val()
				ClearPatInfo() 
				$("#PatNo").val(patno)	
				PatNoSearch()
			}
		}
	)
	$("#PatNo").keyup(function (e){
			if ($("#PatNo").val()==""){
				ClearPatInfo()
			}
		}
	)
	
	//回车事件
	$("#CardNo").keydown(function (e){
			var keycode = e.which;
			if(keycode==13){		
				CardNoKeyDownHandler()
			}
		}
	)
	$("#CardNo").keyup(function (e){
			if ($("#CardNo").val()==""){
				ClearPatInfo()
			}
		}
	)
	
	
	//读卡
	$("#BReadCard").click(ReadCardClickHandler);
	
	//锁定患者
	$("#BLockPatient").click(BLockPatientClickHandler);
	//患者查询
	$("#BFindPat").click(BFindPatClick);
	//加载资源
	LoadTableList()
}

//卡号回车
function CardNoKeyDownHandler()
{
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return;
	ClearPatInfo() 
	$("#CardNo").val(CardNo)	
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardTypeCallBack);
	return false;
}


//调用新读卡函数
function ReadCardClickHandler()
{
	//新版
	DHCACC_GetAccInfo7(CardTypeCallBack);
}

//读卡返回
function CardTypeCallBack(myrtn)
{
    var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").val(CardNo);
			$("#PatNo").val(PatientNo);
			PatNoSearch()		
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效!","info",function(){
				$("#CardNo").focus();
			});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").val(CardNo);
			$("#CardTypeRowID").val(myary[8])
			$("#PatNo").val(PatientNo);
			PatNoSearch()
			break;
		default:
	}
}


//预约
function AppointClick(RegType)
{
	var rtn=CheckBeforeAppoint("APP")
	if (!rtn){return}
	var PatientID=ServerObj.PatientID
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var ASRowId=PageLogicObj.ASRowId;
	var QueueNo=PageLogicObj.SelectSeqNum;
	var SelectTimeRange=PageLogicObj.SelectTimeRange;
	var MethCode=PageLogicObj.SelectMethcode;
	var Note=$("#Note").val().replace(/(^\s*)|(\s*$)/g,'');
	var index=$('#RBApptScheduleList').datagrid('getRowIndex',ASRowId);
	var AppDate=$('#RBApptScheduleList').datagrid('getRows')[index]['AppDate'];
	var htmlAppDate=$cm({
		ClassName:"websys.Conversions",
		MethodName:"DateHtmlToLogical",
		dataType:"text",
		d:AppDate
	},false);
	//组织无卡预约信息
	var AppPatInfo=""
	var NoCardApp=$("#NoCardApp").checkbox('getValue')
	if (NoCardApp){
		var Name=$("#Name").val().replace(/(^\s*)|(\s*$)/g,'');
		var Phone=$("#Phone").val().replace(/(^\s*)|(\s*$)/g,'');
		var CreadNum=$("#CreadNum").val().replace(/(^\s*)|(\s*$)/g,'');
		var Address=""
		var AppPatInfo=Name+"$"+CreadNum+"$"+Phone+"$"+Address+"$$"+ServerObj.IDCredTypeId;
		/*var CommonPatientID=$.cm({
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetCommonPatientID",
			dataType:"text"
		},false);
		if (CommonPatientID==""){
			$.messager.alert("提示","请联系信息科维护公共卡号!")
			return false
		}
		PatientID=CommonPatientID.split("^")[0];*/
	}
	
	//获取预约方式
	if (MethCode==""){
		var MethCode=$cm({
			ClassName:"web.DHCDocAppointmentHui",
			MethodName:"GetAppointMethCode",
			dataType:"text",
			ASRowId:ASRowId,
			AppMethCodeStr:ServerObj.AppMethCodeStr,
		},false);
	
	}
	if (MethCode==""){
		$.messager.alert("提示","预约方式无效!")
		return false
	}
	//判断跨科室预约限制数量
	if (MethCode=="DOC"){
		var CheckFlag=$cm({
			ClassName:"web.DHCDocRegDocAppiont",
			MethodName:"CheckForASNumber",
			dataType:"text",
			ASRowID:ASRowId,
			LoginLocID:session['LOGON.CTLOCID'],
		},false);
		if (CheckFlag=="1"){
			$.messager.alert("提示","超过跨科室预约限制数量。")
			return false	
		}
	}
	var ret=$cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"OPAppDocBroker",
		dataType:"text",
		PatientID:PatientID,
		ASRowId:ASRowId,
		QueueNo:QueueNo,
		UserRowId:UserID,
		MethCode:MethCode,
		RegType:RegType,
		AppPatInfo:AppPatInfo,
		ExpStr:SelectTimeRange,
		Note:Note,
	},false);
	var retArr=ret.split("^");
	if(retArr[0]==0){
		$.messager.popover({msg: '预约成功!',type:'success'});
		PageLogicObj.SelectSeqNum="",PageLogicObj.SelectTimeRange="";
		//加载资源
		LoadTableList();
		var AppID=retArr[1]; //预约ID
		//需要同步父刷新窗口的日历信息
		try{
			window.parent.IntCalender();
			window.parent.LoadtabAppList();
			window.parent.AddClass(htmlAppDate);
		}catch(e){}
		//打印预约条
		if (AppID!=""){
			PrintAPPMesag(AppID);
		}
		IntTimeRange("");
		if (window.parent.PageLogicObj.LockPatientID==""){
			ClearPatInfo();
		}
		/*if (r){
		    window.parent.destroyDialog("Appoint");
		}*/
	}else{
		var rettip=retArr[0];
  		if (retArr[0]==-203)rettip="停诊或替诊的班次则不能预约！";
  		if (retArr[0]==-301)rettip="超过每天预约限额！";
  		if (retArr[0]==-302)rettip="超过每天预约相同医生号限额！";
		if (retArr[0]==-304)rettip="超过每人每天同时段同科室同医生限额！";
  		if (retArr[0]==-201)rettip="没有预约资源！";
  		if (retArr[0]==-223)rettip="该预约患者已进黑名单,暂时无法预约！"
  		if (retArr[0]==-303)rettip="此病人超过每人每天挂相同科室限额！"
  		if (retArr[0]==-402)rettip="还未到预约时间!"	
		$.messager.alert("提示","预约失败！"+rettip)
		LoadTableList()
		return false
	}
}

//预约加号之前检测患者有效信息.
function CheckBeforeAppoint(Type)
{
	if (PageLogicObj.ASRowId==""){
		$.messager.alert("提示","请先选择需要【预约/加号】的排班信息!")
		return false
	}
	var CardNo=$("#CardNo").val();
	var CardTypeRowID=$("#CardTypeRowID").val();
	if ((CardNo=="")&&(CardTypeRowID =="")) {
		var CardNoStr=$.cm({
		    ClassName : "web.DHCOPAdmReg",
		    MethodName : "GetCardNoByPatientNo",
		    dataType:"text",
		    PatientNo:$("#PatNo").val()
	    },false);
	    var CardNo=CardNoStr.split("^")[0];
	    var CardTypeRowID=CardNoStr.split("^")[1];
	}
	if (CardNo!="") {
		var TemporaryCardFlag=CheckTemporaryCard(CardNo, CardTypeRowID);
		var IsTempCard=TemporaryCardFlag.split("^")[0];
		var DiscDate=TemporaryCardFlag.split("^")[1];
		if (IsTempCard=="Y"){
			if (Type =="APP") {
				$.messager.alert("提示","临时卡不能进行预约!");
			}else if (Type =="ADD"){
				$.messager.alert("提示","临时卡只能挂急诊号!");
			}
			return false;
		}
	}
	//检测预约必要患者信息
	var NoCardApp=$("#NoCardApp").checkbox('getValue')
	if (!NoCardApp){
		if (ServerObj.PatientID==""){
			$.messager.alert("提示","请通过读卡或者输入登记号确定有效的患者信息!")
			return false
		}
		//患者黑名单检测
		var BlackStr=$cm({
			ClassName:"web.DHCRBAppointment",
			MethodName:"GetLimitAppFlag",
			dataType:"text",
			PatientId:ServerObj.PatientID,
			IDCardNo:"",
		},false);
		var BlackFlag=BlackStr.split("^")[0];
		if (BlackFlag==1){
			$.messager.alert("提示","患者存在违约记录,已经记入黑名单。不允许预约!")
			return false
		}
		
	}else{
		if (ServerObj.PatientID==""){
			$.messager.alert("提示","请通过读卡或者输入登记号确定有效的患者信息!")
			return false
		}
		var Name=$("#Name").val().replace(/(^\s*)|(\s*$)/g,'');
		if (Name==""){$.messager.alert("提示","请输入有效的患者姓名!");return false;}
		var Phone=$("#Phone").val().replace(/(^\s*)|(\s*$)/g,'');
		if (Phone==""){$.messager.alert("提示","请输入患者联系电话!");return false;}
		var CreadNum=$("#CreadNum").val().replace(/(^\s*)|(\s*$)/g,'');
		if (CreadNum==""){$.messager.alert("提示","请输入患者有效证件信息");return false;}
		if(CreadNum!=""){
		    var myIsID=DHCWeb_IsIdCardNo(CreadNum);
			if (!myIsID){
				$("#CreadNum").focus();
				return false;
			}
	  	}
	  	if (!CheckTelOrMobile(Phone,"Phone","联系电话")) return false;
		//证件号的黑名单检测
		var BlackStr=$cm({
			ClassName:"web.DHCRBAppointment",
			MethodName:"GetLimitAppFlag",
			dataType:"text",
			PatientId:"",
			IDCardNo:CreadNum,
		},false);
		var BlackFlag=BlackStr.split("^")[0];
		if (BlackFlag==1){
			$.messager.alert("提示","该证件号码存在违约记录,已被记入黑名单中。不允许预约!")
			return false
		}
		
	}
	return true;
}

//加号
function AddClick(RegType)
{
	var rtn=CheckBeforeAppoint("ADD")
	if (!rtn){return}
	var PatientID=ServerObj.PatientID
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var ASRowId=PageLogicObj.ASRowId;
	var QueueNo=""
	var SelectTimeRange=""
	var MethCode="DOCADD"
	var Note=$("#Note").val().replace(/(^\s*)|(\s*$)/g,'');
	var index=$('#RBApptScheduleList').datagrid('getRowIndex',ASRowId);
	var AppDate=$('#RBApptScheduleList').datagrid('getRows')[index]['AppDate'];
	var htmlAppDate=$cm({
		ClassName:"websys.Conversions",
		MethodName:"DateHtmlToLogical",
		dataType:"text",
		d:AppDate
	},false);
	//组织无卡预约信息
	var AppPatInfo=""
	var NoCardApp=$("#NoCardApp").checkbox('getValue')
	if (NoCardApp){
		var Name=$("#Name").val().replace(/(^\s*)|(\s*$)/g,'');
		var Phone=$("#Phone").val().replace(/(^\s*)|(\s*$)/g,'');
		var CreadNum=$("#CreadNum").val().replace(/(^\s*)|(\s*$)/g,'');
		
		var Address=""
		var AppPatInfo=Name+"$"+CreadNum+"$"+Phone+"$"+Address;
	}
	
	if (MethCode==""){
		$.messager.alert("提示","预约方式无效!")
		return false
	}
	
	var ret=$cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"OPAppDocBroker",
		dataType:"text",
		PatientID:PatientID,
		ASRowId:ASRowId,
		QueueNo:QueueNo,
		UserRowId:UserID,
		MethCode:MethCode,
		RegType:RegType,
		AppPatInfo:AppPatInfo,
		ExpStr:"",
		Note:Note,
	},false);
	var retArr=ret.split("^");
	if(retArr[0]==0){
		$.messager.alert('提示', '加号成功')//, function(r){
			//加载资源
			LoadTableList();
			var AppID=retArr[1]; //预约ID
			//需要同步父刷新窗口的日历信息
			try{
				window.parent.IntCalender();
				window.parent.LoadtabAppList();
				window.parent.AddClass(htmlAppDate);
			}catch(e){}
			//打印预约条
			if (AppID!=""){
				PrintAPPMesag(AppID);
			}
			if (window.parent.PageLogicObj.LockPatientID==""){
				ClearPatInfo();
			}
			//if (r){
			//    window.parent.destroyDialog("Appoint");
			//} 
		//});
	}else{
		var rettip="";
  		if (retArr[0]==-203)rettip="：停诊或替诊的班次则不能预约。";
  		else if (retArr[0]==-301)rettip="：超过每天预约限额。";
  		else if (retArr[0]==-302)rettip="：超过每天预约相同医生号限额。";
  		else if (retArr[0]==-304)rettip="：超过每人每天同时段同科室同医生限额。";
  		else if (retArr[0]==-201)rettip="：没有预约资源。";
  		else if (retArr[0]==-223)rettip="：该预约患者已进黑名单,暂时无法预约."
  		else if (retArr[0]==-303)rettip="：此病人超过每人每天挂相同科室限额"	
  		else if (retArr[0]==-403)rettip="：还未到加号时间!"	
  		else if (retArr[0]==-404)rettip="：已经过了此排班记录出诊时间点!"	
  		else if (retArr[0]==-405)rettip="：非本人号别不能加号!"	
  		else if (retArr[0]==-213) rettip="：已经开启停止挂号,不予许加号！";
  		else rettip="："+retArr
  		if(RegType=="DOCADD"){rettip="加号失败"+rettip}
  		else{rettip="预约失败"+rettip}
		$.messager.alert("提示",rettip)
		LoadTableList()
		return false
	}
	
	
	
}
///判断卡是否是临时卡
function CheckTemporaryCard(CardNo, CardTypeDr) {
	var TemporaryCardFlag=$.cm({
		ClassName:"web.DHCBL.CARD.UCardRefInfo",
		MethodName:"GetTemporaryCardFlag",
		CardTypeId:CardTypeDr,
		CardNo:CardNo,
		dataType:"text"
	},false)
	return TemporaryCardFlag
}


//登记号回车
function PatNoSearch()
{
	var patno=$("#PatNo").val();
	if ((patno.length<ServerObj.PatNumLength)&&(ServerObj.PatNumLength!=0)) {
			for (var i=(ServerObj.PatNumLength-patno.length-1); i>=0; i--) {
				patno="0"+patno;
			}
	}
	$("#PatNo").val(patno)
	var rtn=$cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"getPatMesageByPatNo",
		dataType:"text",
		PatNo:patno,
		PatDr:"",
	},false);
	window.setTimeout("SetPatInfo('"+rtn+"')");
	
}

//设置患者信息
function SetPatInfo(rtn) {
	if (rtn==""){
		$.messager.alert("提示","患者信息无效！")
		return 
	}
	var CardNo=$("#CardNo").val()
	var CardTypeDr=$("#CardTypeRowID").val()
	var TempCardFlag=CheckTemporaryCard(CardNo, CardTypeDr)
	if(TempCardFlag=="Y") {
		$.messager.alert("提示","临时卡不能进行预约加号！")
		return 
	}
	var rtnarry=rtn.split("^")
	$("#Name").val(rtnarry[2])
	$("#Age").val(rtnarry[4])
	$("#Sex").val(rtnarry[3])
	$("#Phone").val(rtnarry[6])
	$("#AppBreakCount").val(rtnarry[15])
	var IsDeceased=rtnarry[16];
	if (IsDeceased =="Y") {
		$.messager.alert("提示","患者已死亡!","info",function(){
			ClearPatInfo();
			$("#CardNo").focus();
		})
		return false;
	} 
	//$("#CreadNum").val(rtnarry[14]); //默认不展示患者证件信息防止信息泄露
	ServerObj.PatientID=rtnarry[0]
	LoadTableList()
}
function LoadTableList()
{
	//需要加入患者信息 获取价格折扣
	IntTimeRange("")
	$cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"FindApptSchedule",
		ApptSchedule:ServerObj.RBASRowID,
		AppointMethCode:ServerObj.AppMethCodeStr,
		PAPMIID:ServerObj.PatientID,
	},function(GridData){
		PageLogicObj.RBApptScheduleList.datagrid('unselectAll').datagrid('loadData',GridData)
	});	
}
function intAppTable()
{
	var tabdatagrid=$('#RBApptScheduleList').datagrid({  
	fit : true,
	width : 'auto',
	border : false,
	striped : true,
	singleSelect : true,
	checkOnSelect:false,
	//fitColumns : true,
	autoRowHeight : false,
	nowrap: false,
	collapsible:false,
	url : '',
	loadMsg : '加载中..',  
	pagination : false,  //
	rownumbers : true,  //
	idField:"RBScheduleDr",
	pageNumber:0,
	pageSize : 30,
	toolbar:[],
	pageList : [30,50,100],
	columns :[[ 
				{field:'AppDate',title:"出诊日期",width:150,align:'left'},
				{field:'week',title:"星期",width:60,align:'left'},
				{field:'timerangedesc',title:"出诊时段",width:100,align:'left'}, 
				{field:'markdesc',title:"号别",width:150,align:'left'},
				{field:'sesstype',title:"出诊级别",width:150,align:'left'},
				{field:'AllNum',title:"总数",width:150,align:'left'},
				{field:'UserNum',title:"已用数",width:100,align:'left'},
				{field:'CanUseNum',title:"可用数",width:100,align:'left'},
				{field:'totalnum',title:"正号限额",width:100,align:'left'},
				{field:'addnum',title:"加号限额",width:100,align:'left'},
				{field:'booknum',title:"预约限额",width:100,align:'left'},
				{field:'roomdesc',title:"诊室",width:100,align:'left'},
				{field:'price',title:"金额",width:100,align:'left'},
				{field:'SessionClinicGroupDesc',title:"专业组",width:100,align:'left'},
				{field:'AddFlag',title:"AddFlag",width:35,align:'left',hidden:true},
				{field:'RBScheduleDr',title:"排班ID",width:35,align:'left',hidden:true},
				
			 ]] ,
			onSelect:function (rowIndex, rowData){
				//选中控制预约/加号
				var AddFlag=rowData.AddFlag
				if (AddFlag=="Y"){
					$("#CAppoint").hide();$("#CAdd").show();$('#timerangelist').html("");PageLogicObj.AppAddFlag="ADD";
					$("#CNoCardApp").hide()
				}
				else{
					$("#CAppoint").show();$("#CAdd").hide();IntTimeRange(rowData.RBScheduleDr);PageLogicObj.AppAddFlag="APP";
					$("#CNoCardApp").show();
				}
				
				//选中资源
				PageLogicObj.ASRowId=rowData.RBScheduleDr;
				
			},
			onLoadSuccess:function(rowData){
				$(this).datagrid('unselectAll');
				PageLogicObj.ASRowId="";
				for (var i=0;i<rowData.rows.length;i++){
					var SelectFlag=rowData.rows[i].SelectFlag
					if (SelectFlag==1){
						$(this).datagrid("selectRow",i)
						var AddFlag=rowData.rows[i].AddFlag
						if (AddFlag=="Y"){
							$("#CAppoint").hide();$("#CAdd").show();$('#timerangelist').html("");PageLogicObj.AppAddFlag="ADD";
							$("#CNoCardApp").hide()
						}
						else{
							$("#CAppoint").show();$("#CAdd").hide();IntTimeRange(rowData.rows[i].RBScheduleDr);PageLogicObj.AppAddFlag="APP";
							$("#CNoCardApp").show();
						}
						
						//选中资源
						PageLogicObj.ASRowId=rowData.rows[i].RBScheduleDr;
						}
					}
			},
			onUnselectAll:function(index, row){
				//IntTimeRange("");
			}
	
});
return tabdatagrid	
}

function IntTimeRange(ASRowId)
{
	PageLogicObj.OldID=""
	PageLogicObj.OldColor=""
	/*var datahtml = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"GetTimeRangeStrApp",
		dataType:"text",
		ASRowid:ASRowId,
		AppMedthod:ServerObj.AppMethCodeStr,
		MaxWeight:$("#timerangelist").width()
	},false);
	$('#timerangelist').html(datahtml)*/
	if (ASRowId=="") {
		$('#timerangelist').html("");
		return;
	}
	var innerHTML="<table border='1' class='diytable' cellspacing='1' cellpadding='0'>";
	var TimeRangeJson = $.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetTimeRangeStrApp",
	    ASRowid:ASRowId,
	    AppMedthod:ServerObj.AppMethCodeStr,
	    dataType:"text"
	},false);
	TimeRangeJson=eval('(' + TimeRangeJson + ')');
	var width=$("#timerangelist").width();
	var height=$("#timerangelist").height();
	var MaxLen=5;MaxCol=0;colNum=0;
	var Len=TimeRangeJson['row'].length;
	var col=TimeRangeJson['row'];
	for (var j=0;j<Len;j++){
		if (j%MaxLen==0) {
            innerHTML=innerHTML+"<tr>";
        }
		var SeqNo=col[j]['SeqNo'];
		var Time=col[j]['Time'];
		var Status=col[j]['Status'];
		if(Status==0){
			innerHTML=innerHTML+"<td class='td-seqno-invalid'>"+"<span class='td-seqno'>"+$g("可用:无")+"</span><br><span class='td-time'>"+Time+"</span></td>";
		}else{
			innerHTML=innerHTML+"<td onclick=dbtdclick(this) ondblclick=dbtdclick(this) id='"+ASRowId+"_table_"+Time+"'>"+"<span class='td-seqno'>"+$g("可用:有")+"</span><br><span class='td-time'>"+Time+"</span></td>";
		}
		innerHTML=innerHTML+"</td>";
		colNum=colNum+1;
		if (colNum==MaxLen) {
			innerHTML=innerHTML+"</tr>";
			colNum=0;
		}
		if (col.length>MaxCol) MaxCol=col.length;
	}
	if (colNum!=0)  innerHTML=innerHTML+"</tr>";
		innerHTML=innerHTML+"</table>";
	if (Len==0){
		innerHTML="";
	}
	$('#timerangelist').html(innerHTML);
}
function dbtdclick(obj){
	var id=obj.id;
	var Time=id.split("_table_")[1];
	PageLogicObj.SelectTimeRange=Time;
	$(".td-selecct").removeClass("td-selecct");
	$(obj).addClass("td-selecct");
}
//分时段选择回调
function selectseqnum(seqno,statu)
{
	if (statu!=0){return}
	if (PageLogicObj.OldID==seqno){
		$('#SEQ'+PageLogicObj.OldID).removeClass("timerangediv-select")
		$('#SEQ'+PageLogicObj.OldID).addClass("timerangediv"); 
	
		PageLogicObj.SelectSeqNum=""
		PageLogicObj.SelectMethcode=""
		PageLogicObj.SelectTimeRange=""
		PageLogicObj.OldID=""
		PageLogicObj.OldColor=""
	}else{
		if (PageLogicObj.OldID!=""){
			$('#SEQ'+PageLogicObj.OldID).removeClass("timerangediv-select");
			$('#SEQ'+PageLogicObj.OldID).addClass("timerangediv");
		}
		$('#SEQ'+seqno).addClass("timerangediv-select"); 
		
		//选择的信息
		PageLogicObj.OldID=seqno
		PageLogicObj.SelectSeqNum=seqno
		PageLogicObj.SelectTimeRange=($('#SEQ'+seqno).attr("timrange"))
		PageLogicObj.SelectMethcode=($('#SEQ'+seqno).attr("methcode"))
	}		
}

///清除患者信息
function ClearPatInfo(isReLoadRBASTable)
{
	if (!isReLoadRBASTable) isReLoadRBASTable="";
	$("#Name").val('')
	$("#Age").val('')
	$("#Sex").val('')
	$("#AppBreakCount").val('')
	$("#CreadNum").val('')
	$("#Note").val('')
	$("#PatNo").val('')
	$("#Phone").val('')
	$("#CardNo").val('')
	$("#CardTypeNew").val('');
	$("#CreadNum").val('');
	ServerObj.PatientID="";
	ServerObj.PatNo="";
	$("#CardTypeRowID").val('')
	$("#NoCardApp").checkbox('uncheck');
	if (isReLoadRBASTable!="N") {
		LoadTableList();
	}
}

//预约打印新加入方法 和日历预约的查询保持一致
function PrintAPPMesag(AppID)
{
	DHCP_GetXMLConfig("XMLObject","DHCOPAppointPrint");
	
	$.cm({
		ClassName:"DHCDoc.Common.pa",
		MethodName:"GetAppPrintData",
		AppARowid:AppID,
		dataType:"json"
	},function(data){
		var PDlime=String.fromCharCode(2);
		var PrtObj=data[0];
		var MyPara="CardNo"+PDlime+PrtObj['CardNo']+"^"+"PatNo"+PDlime+PrtObj['PatNo']+"^"+"PatName"+PDlime+PrtObj['PatName']+"^"+"RegDep"+PDlime+PrtObj['RegDep'];
		var MyPara=MyPara+"^"+"SessionType"+PDlime+PrtObj['SessionType']+"^"+"MarkDesc"+PDlime+PrtObj['MarkDesc']+"^"+"Total"+PDlime+PrtObj['Total'];
		var MyPara=MyPara+"^"+"AdmDate"+PDlime+PrtObj['AdmDate']+"^"+"APPDate"+PDlime+PrtObj['APPDate']+"^"+"SeqNo"+PDlime+PrtObj['SeqNo'];
		var MyPara=MyPara+"^"+"UserCode"+PDlime+PrtObj['UserCode'];
		var MyPara=MyPara+"^"+"MethType"+PDlime+"["+PrtObj['APPTMethod']+"]"
		var MyPara=MyPara+"^"+"AdmTimeRange"+PDlime+PrtObj['AdmTimeRange'] //建议就诊时间
		var myobj=document.getElementById("ClsBillPrint");
		//DHCP_PrintFun(myobj,MyPara,"");
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
	});
}

function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		/*
		if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			CardNoKeydownHandler(e);
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("PatNo")>=0){
			PatNoKeydownHandler(e);
			return false;
		}
		*/
		return false;
	}
	if (keyCode==115){
		//读卡快捷
		ReadCardClickHandler()
		return false;
	}
	if (keyCode==120){
		if (PageLogicObj.AppAddFlag=="APP"){return true;}
		//加号快捷
		AddClick("DOCADD")
		return true;
	}
	if (keyCode==121){
		if (PageLogicObj.AppAddFlag=="ADD"){return true;}
		//预约快捷
		AppointClick("APP")
		return true;
	}
	return true;
}

function LoadPage(RBASRowID,PatientID,AppMethCodeStr,CanNoCardApp){
	ServerObj.RBASRowID=RBASRowID;
	if (PatientID!=""){
		ClearPatInfo();
		ServerObj.PatientID=PatientID
	}
	PageLogicObj.SelectSeqNum="",PageLogicObj.SelectTimeRange="";
	ServerObj.AppMethCodeStr=AppMethCodeStr
	ServerObj.CanNoCardApp=CanNoCardApp
	//根据配置设置是否可以无卡预约
	if (ServerObj.CanNoCardApp!="Y"){
		$("#CNoCardApp").hide()
	}
	$("#NoCardApp").checkbox('uncheck');
	if (RBASRowID) {
		var ASDate=$(".selectCls" , parent.document)[0].id;
		if (ASDate == ServerObj.nowDate) {
			$("#CNoCardApp").hide();
		}else{
			$("#CNoCardApp").show();
		}
	}else{
		$("#CNoCardApp").hide();
	}
	if (ServerObj.PatientID!=""){
		var PatNo=$.cm({
			ClassName:"web.DHCDocAppointmentHui",
			MethodName:"GetPatientNo",
			dataType:"text",
			PatientID:ServerObj.PatientID
		},false);
		ServerObj.PatNo=PatNo
	}
	//初始化患者信息
	if (ServerObj.PatNo!=""){
		$("#PatNo").val(ServerObj.PatNo)
		PatNoSearch()
	}
	//加载资源
	if (ServerObj.RBASRowID!=""){
		LoadTableList()
	}else{
		PageLogicObj.RBApptScheduleList.datagrid('loadData',{"rows":[],"total":0,"curPage":1})
	}
	IntTimeRange("");
	if (window.parent.PageLogicObj.LockPatientID==""){
		$("#BLockPatient").find(".l-btn-text").text($g("锁定患者"));
	}else{
		$("#BLockPatient").find(".l-btn-text").text($g("取消锁定"));	
	}
}
function BLockPatientClickHandler(){
	if (ServerObj.PatientID!=""){
		var text=$("#BLockPatient").find(".l-btn-text").text()
		if (text==$g("锁定患者")){
			window.parent.PageLogicObj.LockPatientID=ServerObj.PatientID;
			$("#BLockPatient").find(".l-btn-text").text($g("取消锁定"));
		}else{
			window.parent.PageLogicObj.LockPatientID=""
			$("#BLockPatient").find(".l-btn-text").text($g("锁定患者"));
		}
	}else{
		$.messager.alert("提示","请读取患者后再进行锁定");
		return ;
	}
}
function CheckTelOrMobile(telephone,Name,Type){
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.indexOf('-')>=0){
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
				$("#"+Name).focus();
			})
			websys_setfocus(Name);
	        return false;
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+"联系电话电话长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}
function BFindPatClick() {
	var src="doc.patlistquery.hui.csp";
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	var $width=$(window.parent).width()-100
	var $height=$(window.parent).height()-80
	window.parent.createModalDialog("FindPatInfo","患者查询", $width, $height,"icon-w-find","",$code,"");
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content
    });
}
function InitCommonCardWin(){
	$("#CommonCardChoose").empty();
	retArry=ServerObj.CommonCardNoStr.split("&");
	htmlstr='<table class="search-table" style="margin:10px auto;">';
	for (var i=0; i<retArry.length; i++){
		htmlstr=htmlstr+'<tr><td colSpan=""><a class="hisui-linkbutton l-btn l-btn-small" id="Commoncard'+retArry[i]+'" onclick="CommonCardclickRadio('+"'"+retArry[i]+"'"+')" data-options="" group=""><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">'+retArry[i]+'</span><span class="l-btn-icon icon-w-plus">&nbsp;</span></span></a></td></tr>'
	}
	htmlstr=htmlstr+'</table>';
	$("#CommonCardChoose").append(htmlstr);
}
function CommonCardclickRadio(ChoseCommonCardNo){
	$('#CommonCardWin').window('close');	
	var PatientNomyrtn=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetCommonCardNoandPatientNo",
		dataType:"text",
		ChoseCommonCardNo:ChoseCommonCardNo
	},false);
	if (PatientNomyrtn==""){
		$.messager.alert("提示","请维护公共卡."); 
		$("#NoCardApp").checkbox('uncheck');      				
		return false;
	}else{
		var CardNo=PatientNomyrtn.split("^")[0]
		var PatientNo=PatientNomyrtn.split("^")[1];
		var CardTypeNew=PatientNomyrtn.split("^")[2];
		$("#CardNo").val(CardNo);
		$("#PatNo").val(PatientNo);
		$("#CardTypeNew").val(CardTypeNew);
		PatNoSearch()
	}
}
