//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2017-11-24
// 描述:	   急诊病人列表
//===========================================================================================

var PatientID = "";  /// 病人ID
var EpisodeID = "";  /// 病人就诊ID
var defaultCardTypeDr;  /// 默认卡类型
var m_CardNoLength = 0;
var m_CCMRowID = "" ;
var tabSelectFlag = 0;
var PatListType = "Per"; /// 病人列表
var EmWardID = "";	     /// 抢救病区ID
var PatArrFlag = "N";
var PatType = "E"; var LgCtLocID=session['LOGON.CTLOCID']; var LgUserID=session['LOGON.USERID']; var LgHospID=session['LOGON.HOSPID'];//hxy 2018-06-22

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
	/// 初始化日期
	InitDateBox();
	
	/// 初始化加载病人列表
	InitPatList();
	
	InitPatInfoPanel()
	 
	/// 初始化页面卡类型定义
	InitCardTypeDefine();
	
	InitDomAndVal();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	DateFormat = "";
	runClassMethod("web.DHCEMInComUseMethod","GetParams",{Params:""},
		function (rtn){
			DateFormat = rtn;
		},"text",false
	)	
	
	//EpisodeID = getParam("EpisodeID");
}

function InitDateBox(){

	if(LISTDEFDATE != 0){
		$HUI.datebox("#StartDate").setValue(formatDate(0-LISTDEFDATE));
		$HUI.datebox("#EndDate").setValue(formatDate(0));		
	}else{
		$HUI.datebox("#StartDate").setValue("");
		$HUI.datebox("#EndDate").setValue("");		
	}
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=";
	/// 卡类型  卡类型的combobox的onSelect事件。
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
	        var CardTypeDefArr = option.value.split("^");
	        m_CardNoLength = CardTypeDefArr[17];
	        m_CCMRowID = CardTypeDefArr[14];
	        
	        if (CardTypeDefArr[16] == "Handle"){
		    	$('#EmCardNo').attr("readOnly",false);
		    }else{
				$('#EmCardNo').attr("readOnly",true);
			}
			$('#EmCardNo').val("");  /// 清空内容
	    }
	};
	var url = uniturl+"CardTypeDefineListBroker";
	new ListCombobox("EmCardType",url,'',option).init();
	
	//主管医生
	$HUI.combobox("#concDoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+LgCtLocID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
			
	    }	
	})
	
	
	/// 登记号/床号/姓名 回车事件
	$("#TmpCondition").bind('keypress',TmpCon_KeyPress);
	
	/// 卡号 回车事件
	$("#EmCardNo").bind('keypress',EmCardNo_KeyPress);
	 
	$("#roomSeatCode").bind('keypress',SeatNo_KeyPress);
	
	/// tabs 选项卡
	$("#tabs").tabs({
		onSelect:function(title){
		   if (tabSelectFlag == 1){
		   	  LoadEmPatByLoc(title);
		   }
		}
	});
	
	/// 点击变色
	$(".pf-sider ul li").bind('click',SetLabelColor);
	
	/// 默认给待诊病人增加选中效果
	$("li:contains('待诊患者')").addClass("btn-gray"); //hxy 2018-09-17 病人 2018-10-18 btn-success
	
	//号别  hxy 2018-06-22
	$HUI.combobox("#Care",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=getEmeNumInfo&hosp="+LgHospID,
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	/// 获取当前科室号别并初始化赋值 hxy 2018-06-22
	///runClassMethod("web.DHCEMPatCheckLevQuery","jsonGetEmPatChkCare",{"LocID":LgCtLocID,"HospID":LgHospID},function(jsonString){
	///	var Arr = jsonString.split('"');
	///	
	///},'',false)
	
	/// 更多
	$("#more").bind('click',MoreCondition);
	
}

/// 初始化页面卡类型定义
function InitCardTypeDefine(){
	
	/// 获取默认卡类型
	runClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{},function(jsonString){
		
		defaultCardTypeDr = jsonString;
		var CardTypeDefArr = defaultCardTypeDr.split("^");
        m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
        m_CCMRowID = CardTypeDefArr[14];
        if (CardTypeDefArr[16] == "Handle"){
	    	$('#EmCardNo').attr("readOnly",false);
	    }else{
			$('#EmCardNo').attr("readOnly",true);
		}
		$("#EmCardType").combobox("setValue",defaultCardTypeDr);
	},'',false)
}

function InitDomAndVal(){
	$('#PatList').datagrid('hideColumn','PAAdmBed');	///待诊列表床号不需显示
	$("#roomSeatCode").attr("disabled", true);
	$HUI.combobox("#concDoc").disable();
	return;
}
/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	///  定义columns
	var columns=[[
		{field:'ItmXH',title:'序号',width:40,align:'center'},
		{field:'PAAdmBed',title:'床号',width:80,align:'center'},
		{field:'PCLvArea',title:'区域',width:60,align:'center',styler:setCellAreaLabel},
		//{field:'CareLevel',title:'护理级别',width:70,align:'center',styler:setCellCareLevelLabel},
		//{field:'CareLevelUpOrDown',title:'趋势',width:45,align:'center',formatter:setCellCareLevelUpOrDown},
		{field:'PAAdmPriority',title:'当前分级',width:70,align:'center',formatter:setCellPAAdmPriority},
		{field:'PatLevel',title:'预检分级',width:70,align:'center',formatter:setCellLevLabel},
		{field:'LocSeqNo',title:'顺序号',width:60,align:'center'},
		{field:'CalledDesc',title:'呼叫状态',width:70,align:'center'},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatAge',title:'年龄',width:80,align:'center'},
		{field:'Arrived',title:'到达',width:60,align:'center',formatter:setCellSymbol},
		{field:'PatNo',title:'登记号',width:120},
		{field:'RegDoctor',title:'号别',width:120},
		{field:'PatSex',title:'性别',width:80,align:'center'},
		//{field:'ItmUnObr',title:'留观',width:100},
		//{field:'StrTime',title:'滞留时间',width:120,align:'center'},
		{field:'PAAdmDate',title:'入科时间',width:150,align:'center',formatter:function(value, rowData, rowIndex){
			return rowData.PAAdmDate+"  "+rowData.PAAdmTime;
			}},
		{field:'PAAdmDepCodeDR',title:'就诊科室',width:120},
		{field:'PAAdmDocCodeDR',title:'医生',width:100},
		{field:'PCLvNurse',title:'分诊护士',width:80},
		{field:'BillType',title:'病人类型',width:80,align:'center'},
		{field:'PatEmrUrl',title:'电子病历',width:70,align:'center',formatter:setCellEmrUrl},
		//{field:'Called',title:'叫号',width:40,align:'center'},
		{field:'PatGreFlag',title:'绿色通道',width:70,align:'center',formatter:setCellGreenLabel},
		{field:'ItmUnObr',title:'图标菜单',width:80,
			formatter: function(value,row,index){
				return reservedToHtml(value);
			}},
		
		{field:'Diagnosis',title:'诊断',width:100,align:'center'},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
		//{field:'WalkStatus',title:'状态',width:60,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		headerCls:'panel-header-gray',
		rownumbers : false,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
	    },
		onLoadSuccess:function(data){
			///  设置分诊区域
            if (typeof data.EmPatLevWait == "undefined"){return;}
        	$("#EmPatLevWait").text(data.EmPatLevWait);
			$("#EmPatLevUnWait").text(data.EmPatLevUnWait);
			$("a:contains('红区')").html("红区(" + data.EmPatLevCnt1 +")");
			$("a:contains('橙区')").html("橙区(" + data.EmPatLevCnt2 +")"); //hxy 2020-02-21 st
			$("a:contains('黄区')").html("黄区(" + data.EmPatLevCnt3 +")"); //原：EmPatLevCnt2
			$("a:contains('绿区')").html("绿区(" + data.EmPatLevCnt4 +")"); //原：EmPatLevCnt3 ed 
			setObsPatNumInfo(data.ObsPatInfo);   /// 设置留观室人数信息
			tabSelectFlag = 1;
		},
		rowStyler:function(index,rowData){   
			if(rowData.Called==1){
				//return "background-color:#53868B";  //暂时不用颜色
			}
	    },
	    rowStyler:function(index,rowData){  
			if ((rowData.CalledDesc.indexOf("正在叫号")>-1)){   //hxy 2020-03-09 st
	            return 'background-color:#4b991b;';  //029c87 //018674
	        }//ed 	 
	    },
	    onDblClickRow: function (rowIndex, rowData) {
			if(window.parent.frames && window.parent.frames.switchPatient){
				//双击选择行编辑
				window.parent.frames.switchPatient(rowData.PatientID,rowData.EpisodeID,rowData.mradm);
				window.parent.frames.hidePatListWin();
		    }
        },
        onSelect:function(index,rowData){
	        return;
			var frm = dhcsys_getmenuform();
			if((frm) &&(frm.EpisodeID.value != rowData.EpisodeID)){
				frm.EpisodeID.value = rowData.EpisodeID; 			
				frm.PatientID.value = rowData.PatientID; 	
				if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
				if(frm.PPRowId) frm.PPRowId.value = "";
			}
	    }
	};
	
	/// 开始日期
	var StartDate = $HUI.datebox("#StartDate").getValue();
	/// 结束日期
	var EndDate = $HUI.datebox("#EndDate").getValue();

	var param = "^^^"+ PatType +"^^"+StartDate+"^"+EndDate+"^"+ PatArrFlag +"^^^^^"+LgCtLocID +"^"+ LgUserID +"^^^^^"+ PatListType;
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=JSonQryEmDocMainPatList&params="+param;
	new ListComponent('PatList', columns, uniturl, option).Init();
	$('#PatList').datagrid('hideColumn','PAAdmBed');	///待诊列表床号不需显示
}

function setObsPatNumInfo(data){
	var infoArr = data.split("^");
	for(var i=0;i<infoArr.length;i++){
		var itmInfo = infoArr[i];
		$(".pf-sider li[name='"+itmInfo.split(":")[0]+"']").find("span").text(itmInfo.split(":")[1]);
	}
	return ;
}

/// 设置图标菜单
function reservedToHtml(str){
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

/// 分级
function setCellLevLabel(value, rowData, rowIndex){
	var fontColor = "";
	/*if ((value == "1级")||(value == "2级")){ fontColor = "#F16E57";} //hxy 2020-02-21 st
	if (value == "3级"){ fontColor = "#FFB746";}
	if (value == "4级"){ fontColor = "#2AB66A";}*/
	if (value == "1级"){ fontColor = "#F16E57";}
	if (value == "2级"){ fontColor = "orange";}
	if (value == "3级"){ fontColor = "#FFB746";}
	if ((value == "4级")||(value == "5级")){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>"; //hxy 2020-02-21
}

function setCellPAAdmPriority(value, rowData, rowIndex){
	var fontColor = "";
	if (value == "1级"){ fontColor = "#F16E57";}
	if (value == "2级"){ fontColor = "orange";}
	if (value == "3级"){ fontColor = "#FFB746";}
	if ((value == "4级")||(value == "5级")){ fontColor = "#2AB66A";}
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>";	//hxy 2020-02-21
}

/// 电子病历
function setCellEmrUrl(value, rowData, rowIndex){

	return "<a href='#' onclick='OpenPatEmr("+rowData.PatientID +","+rowData.EpisodeID +","+rowData.mradm +")'>查看</a>";
}

/// 病历查看
function OpenPatEmr(PatientID, EpisodeID, mradm){
	
	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择会诊记录后重试！","warning");
		return;
	}
	/// 旧版病历
	/// window.open("emr.record.browse.patient.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	
	/// 新版病历
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 绿色通道
/// zhouxin 2018-07-18
function setCellGreenLabel(value, rowData, rowIndex){
	//var fontColor = "";
	//if (value == "是"){ fontColor = "#2AB66A"; }
	//return "<font color='" + fontColor + "'>"+value+"</font>";
	var html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.EpisodeID+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
	if (value == "是"){ html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.EpisodeID+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"/></a>'; }
	return html;
}
function showGreenRec(adm){
	var option = {
		minimizable:false,
		iconCls:'icon-save',
		onClose:function(){QryEmPatList()}
	}
	new WindowUX("绿色通道","PatLabWin", 700, 420 , option).Init();
	
	var LinkUrl ='dhcem.green.rec.csp?EpisodeID='+adm
	var content = '<iframe class="page-iframe" src="'+ LinkUrl +'" frameborder="no" border="no" height="98%" width="100%" scrolling="no"></iframe>';
	$("#PatLabWin").html(content);
	return;		
}
/// 去向
function setCellAreaLabel(value, row, index){
	if (value == "红区"){
		return 'background-color:#F16E57;color:white';
	}else if (value == "橙区"){ //hxy 2020-02-21 st
		return 'background-color:orange;color:white'; //ed
	}else if (value == "黄区"){
		return 'background-color:#FFB746;color:white';
	}else if (value == "绿区"){
		return 'background-color:#2AB66A;color:white';
	}else{
		return '';
	}
}

/// 护理级别
function setCellCareLevelLabel(value, row, index){
	if (value == "特级"){
		return 'background-color:red;color:black';
	}else if (value == "一级"){
		return 'background-color:#FD99CB;color:black';
	}else if (value == "二级"){
		return 'background-color:#02B0EF;color:black';
	}else if (value == "三级"){
		return 'color:black';
	}else{
		return '';
	}
}

/// 护理级别
function setCellCareLevelUpOrDown(value, row, index){
	if (value == "1"){
		return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/up.png'/>";
	}else if (value == "-1"){
		return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/down.png'/>";
	}else{
		return '';
	}
}

/// 获取病人信息
function GetEmRegPatInfo(){
	
	runClassMethod("web.DHCEMDocMainOutPat","GetEmRegPatInfo",{"EpisodeID": EpisodeID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			InitPatInfoPanel(rowData);
		}
	},'json',false)
}

/// 呼叫
function CallPatientOLD(){
	
	///调用叫号公司的webervice进行呼叫
	runClassMethod("web.DHCDocOutPatientList","SendCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
			if(retArr[0]=="0"){
				search("");  /// 查询病人列表
				return;
			}
		}
	},'',false)
}

/// 重复呼叫
function reCallPatientOLD(){

	///调用叫号公司的webervice进行重复呼叫
	runClassMethod("web.DHCDocOutPatientList","SendReCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
		}
	},'',false)
}



/// 登记号/床号/姓名 回车事件
function TmpCon_KeyPress(e){

	if(e.keyCode == 13){
		var TmpCondition = $("#TmpCondition").val();
		if (!TmpCondition.replace(/[\d]/gi,"")&(TmpCondition != "")){
			///  登记号补0
			TmpCondition = GetWholePatNo(TmpCondition);
			$("#TmpCondition").val(TmpCondition);
		}
		QryEmPatList();  /// 查询
	}
}

/// 查询
function QryEmPatList(){
	
	/// 开始日期
	var StartDate = $HUI.datebox("#StartDate").getValue();
	/// 结束日期
	var EndDate = $HUI.datebox("#EndDate").getValue();
	
	/// 红黄绿区
	var TypeCode="";
	if(arguments.length!=0){
		TypeCode=arguments[0];
	}
	
	/// 卡号
	var CardNo = $("#EmCardNo").val();
	var TmpCondition = $("#TmpCondition").val();
    var CareDesc=$("#Care").combobox("getText");
    var ConcDoc= $("#concDoc").combobox("getValue");
    var SeatNo = $("#roomSeatCode").val();
	var params = "^^^"+ PatType +"^"+ CardNo +"^"+ StartDate +"^"+ EndDate ;
	params=params+"^"+ PatArrFlag +"^^^^^"+LgCtLocID +"^"+ LgUserID +"^^"+ TmpCondition ;
	params=params+"^"+ "" +"^"+TypeCode+"^"+ PatListType +"^"+ EmWardID+"^^"+ CareDesc;
	params=params+"^"+ ConcDoc + "^" +SeatNo;
	$("#PatList").datagrid("load",{"params":params}); 
}

/// 读卡
function ReadCard(){

	runClassMethod("web.DHCOPConfig","GetVersion",{},function(myVersion){
		
		var CardTypeRowId = "";
		var CardTypeValue = $("#EmCardType").combobox("getValue");
		var m_CCMRowID=""
		if (CardTypeValue != "") {
			var CardTypeArr = CardTypeValue.split("^");
			m_CCMRowID = CardTypeArr[14];
			CardTypeRowId=CardTypeArr[0];
		}
		//var rtn=DHCACC_ReadMagCard(m_CCMRowID,"R", "2");  //QQA
		var rtn=DHCACC_GetAccInfo(CardTypeRowId,CardTypeValue);
		var myary=rtn.split("^");
		if (myary[0]!="0"){
   			$.messager.alert("提示","卡无效!");
   		}
		
		if ((myary[0]=="0")&&(myary[1]!="undefined")){
			//$("#EmPatNo").val(myDataArr[2]);      /// 登记号;
			//$("#PatientID").val(myDataArr[3]);  /// 病人ID
			$('#EmCardNo').val(myary[1]);
			QryEmPatList();   /// 查询
		}			
	},"text",false)
}

function M1Card_InitPassWord(){
	
	try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
    }catch(e){}
}

/// 加载病人列表
function LoadEmPatByCurType(TypeCode){
	
	PatArrFlag = "N";
	/// 卡号
	var CardNo = $("#EmCardNo").val();
	var TmpCondition = $("#TmpCondition").val();
	var StayInWard = "";
	if (TypeCode == "D"){ PatArrFlag = "N"; }  /// 待诊病人
	if (TypeCode == "H"){ PatArrFlag = "Y"; } 
	/*
	if (TypeCode == "E"){ StayInWard = "E"; }  /// 急诊留观
	if (TypeCode == "R"){ StayInWard = "R"; }  /// 抢救留观
	*/
	EmWardID = (TypeCode == (TypeCode == "D"?"D":"H")?"":TypeCode);

	
	if ((TypeCode != "D")&(TypeCode != "H")){
		$('#PatPanel').layout('hidden','north');
		$('#bt_call').hide();    /// 叫号
		$('#bt_recall').hide();  /// 重复叫号
		$('#bt_cross').hide();   /// 过号
		$('#bt_endadm').hide();   /// 完成就诊
		$('#bt_calsel').hide();   /// 选择呼叫
		$('#bt_outcall').hide();  /// 过号重排
		$HUI.datebox("#StartDate").disable();
		$HUI.datebox("#EndDate").disable();
		$("#TmpCondition").attr("disabled", true);
		$("#EmCardNo").attr("disabled", true);
		$HUI.combobox("#EmCardType").disable();
		$HUI.linkbutton("#ReadCard").disable();
		$("#roomSeatCode").attr("disabled", false);
		$HUI.combobox("#concDoc").enable();
		$HUI.datebox("#StartDate").setValue("");
		$HUI.datebox("#EndDate").setValue("");
		$("#TmpCondition").val("");
		$("#EmCardNo").val("");
		$(".more-obs").show();
		$('#PatList').datagrid('showColumn','PAAdmBed');
		$('#PatList').datagrid('hideColumn','CalledDesc');
		
	}else{
		$('#PatPanel').layout('show','north');
		$('#bt_call').show();    /// 叫号
		$('#bt_recall').show();  /// 重复叫号
		$('#bt_cross').show();   /// 过号
		$('#bt_calsel').show();   /// 选择呼叫
		$('#bt_outcall').show();  /// 过号重排
		$HUI.datebox("#StartDate").enable();
		$HUI.datebox("#EndDate").enable();
		InitDateBox();      ///初始化默认时间
		$("#TmpCondition").attr("disabled", false);
		$("#EmCardNo").attr("disabled", false);
		$HUI.combobox("#EmCardType").enable();
		$HUI.linkbutton("#ReadCard").enable();
		$("#roomSeatCode").attr("disabled", true);
		$HUI.combobox("#concDoc").disable();
		$HUI.combobox("#concDoc").setValue("");
		$("#roomSeatCode").val("");
		$(".more-obs").show();
		if (TypeCode == "H"){
			$('#bt_call').hide();    /// 叫号
			$('#bt_recall').hide();  /// 重复叫号
			$('#bt_cross').hide();   /// 过号
			$('#bt_calsel').hide();   /// 选择呼叫
			$('#bt_outcall').hide();  /// 过号重排
			$('#bt_endadm').hide();   /// 完成就诊
		}else{
			$('#bt_endadm').show();   /// 完成就诊
		}
		$('#PatList').datagrid('hideColumn','PAAdmBed');
		$('#PatList').datagrid('showColumn','CalledDesc');
	}
	var CareDesc=$("#Care").combobox("getText");
		
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var params = "^^^"+ PatType +"^"+ CardNo +"^"+ StartDate +"^"+ EndDate +"^"+ PatArrFlag +"^^^^^"+LgCtLocID +"^"+ LgUserID +"^^"+ TmpCondition +"^"+ StayInWard +"^^"+ PatListType +"^"+ EmWardID+"^^"+CareDesc;
	$("#PatList").datagrid("load",{"params":params}); 
}

/// 加载病人列表
function LoadEmPatByLoc(title){
	
	if (title == "本人患者"){ //hxy 2018-09-17 病人
		PatListType = "Per";
	}else if (title == "本科室患者"){
		PatListType = "Loc";
	}else{
		PatListType = "Grp";
	}
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var params = "^^^"+ PatType +"^^"+ StartDate +"^"+ EndDate +"^"+ PatArrFlag +"^^^^^"+LgCtLocID +"^"+ LgUserID +"^^^^^"+ PatListType;
	$("#PatList").datagrid("load",{"params":params});
}

/// 床位号回车
function SeatNo_KeyPress(e){
	if(e.keyCode == 13){
		QryEmPatList();	
	}
}

///  卡号回车
function EmCardNo_KeyPress(e){

	if(e.keyCode == 13){
		var CardNo = $("#EmCardNo").val();
		if (CardNo == "") return;
		var CardTypeID = GetPatCardType(CardNo); /// 根据卡号取病人的卡类型定义
		if (CardTypeID == ""){
			var CardNoLen = CardNo.length;
			if (m_CardNoLength < CardNoLen){
				$.messager.alert("提示:","卡号输入错误,请重新录入！");
				return;
			}

			/// 卡号不足位数时补0
			for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
				CardNo="0"+CardNo;  
			}
		}else{
			GetEmPatCardTypeDefine(CardTypeID);  ///  设置卡类型
		}
		$("#EmCardNo").val(CardNo);
		QryEmPatList();
	}
}

//Desc:切换患者
function doSwitch(PatientID,EpisodeID,mradm) {
	if(top.frames[0] && top.frames[0].switchPatient){
		top.frames[0].switchPatient(PatientID,EpisodeID,mradm);
		top.frames[0].hidePatListWin();
	}else{
		parent.parent.switchPatient(PatientID,EpisodeID,mradm);
		parent.parent.hidePatListWin();
	}
	return ;
	/*window.parent.parent.opener.switchPatient(PatientID,EpisodeID,mradm);
	window.parent.parent.close(); 
	return false;*/
	
	/*var frm = getMenuForm();
	if (frm){
		
		var frmEpisodeID = frm.EpisodeID;
		var frmPatientID = frm.PatientID;
		var frmmradm = frm.mradm;
		frmPatientID.value = PatientID;
		frmEpisodeID.value = EpisodeID;
		frmmradm.value = mradm;
		
		frm.EpisodeID=EpisodeID;
		frm.PatientID=PatientID;
		frm.mradm=mradm;
	}
	window.parent.parent.location.reload();*/
}

///设置编辑连接
function setCellSymbol(value, rowData, rowIndex){
	
	return "<a href='#' onclick='PatArrived("+rowData.PatientID+","+rowData.EpisodeID+","+rowData.mradm+")'><img src='../scripts/dhcnewpro/images/update.gif' border=0/></a>";
}

/// 到达
function PatArrived(PatientID,EpisodeID,mradm){

	///设置病人状态
	runClassMethod("web.DHCEMDocMainOutPat","SetArrivedStatus",{"EpisodeID":EpisodeID, "LocID":LgCtLocID,"UserID":LgUserID},function(jsonString){
		
		if (jsonString != "1"){
			$.messager.alert("提示","病人状态更新失败！");
		}else{
			$("#PatList").datagrid("reload");  /// 刷新病人列表
			if(window.parent.frames && window.parent.frames.switchPatient){
				//双击选择行编辑
				window.parent.frames.switchPatient(PatientID,EpisodeID,mradm);
				window.parent.frames.hidePatListWin();
		    }
		}
	},'',false)
}

/// 设置标签颜色
function SetLabelColor(){
	
	$(this).addClass("btn-gray").siblings().removeClass("btn-gray"); //hxy 2018-10-18 原：btn-success
}

/// 病人去向
function TransPatToArea(TypeCode){
	QryEmPatList(TypeCode);
}

///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;
}

/// 更多查询条件
function MoreCondition(){

	if ($(".more-panel").is(":hidden")){
		$(".more-panel").css("display","block");
		$("#mainpanel").layout('panel','north').panel('resize',{height: 100});
		$("#mainpanel").layout('resize');
		$(".more i").removeClass("more-bk-down").addClass("more-bk-up");
	}else{
		$(".more-panel").css("display","");
		$("#mainpanel").layout('panel','north').panel('resize',{height: 50});
		$("#mainpanel").layout('resize');
		$(".more i").removeClass("more-bk-up").addClass("more-bk-down");
		$HUI.datebox("#StartDate").setValue("");
		$HUI.datebox("#EndDate").setValue("");
	}
}

/// =================================== 以下内容为安贞门诊叫号程序 ===========================================

///呼叫
function CallPatient(){
	var IPAddress=GetComputerIp()
	var ret = tkMakeServerCall("web.DHCVISQueueManage","RunNextButtonNewProEm","","",IPAddress);
	$.messager.alert("提示",ret.split("^")[1]);
	$("#PatList").datagrid("reload");  /// 刷新病人列表	
	return;
}

/// 重复叫号
function ReCallPatient(){
	var IPAddress=GetComputerIp();
	var ret=tkMakeServerCall("web.DHCVISQueueManage","RecallButtonNewProEm","","",IPAddress);
	$.messager.alert("提示",ret.split("^")[1]);
	$("#PatList").datagrid("reload");  /// 刷新病人列表	
	return;
}

/// 选择呼叫
function CallSelPatient(){
	var CallNum=1;    ///允许当前呼叫的人数
	var IPAddress=GetComputerIp();
	var NowCallNum=0;     /// 当前叫号个数
	var rowData=$("#PatList").datagrid('getRows');
	var rowData = $("#PatList").datagrid('getSelected'); /// 存在选中行
	var allRowData = $("#PatList").datagrid('getData').rows;
	if(!rowData){
		$.messager.alert("提示","请选中病人后，再进行叫号操作！");
		return;
	}
	
	var TmpEpisodeID = rowData.EpisodeID; /// 就诊ID
	for (var m=0; m<allRowData.length; m++){
		var EpisodeID = allRowData[m].EpisodeID;     /// 就诊ID
		var PAAdmDate = allRowData[m].PAAdmDate;     /// 就诊日期
		if(TmpEpisodeID==EpisodeID) continue;
		if(allRowData[m].Called == "1"){
			NowCallNum = NowCallNum + 1;
		}
	}
	if(NowCallNum >= CallNum){
		$.messager.alert("提示","请先处理已经呼叫患者!");
		return;
	}
	
	var PatName = rowData.PatName;    /// 姓名
	var LocSeqNo = rowData.LocSeqNo;  /// 顺序号
	var ret = tkMakeServerCall("web.DHCVISQueueManage","FrontQueueInsertNewProEm",TmpEpisodeID,"","",IPAddress);
	$.messager.alert("提示",ret.split("^")[1]);
	$("#PatList").datagrid("reload");  /// 刷新病人列表
	return;	

	if (TmpEpisodeID != ""){  /// 设置呼叫状态
		var ret=tkMakeServerCall("web.DHCEMDocMainOutPat","SetPatCallStatu",TmpEpisodeID,session["LOGON.USERID"]);
		if (ret==0){
			
		}
	}
}

/// 过号
function OutCallQueue(){
	var rowData = $("#PatList").datagrid('getSelected');
	if (rowData){
		var PatName = rowData.PatName;    /// 姓名
		var LocSeqNo = rowData.LocSeqNo;  /// 顺序号	
		if(rowData.Called == ""){
			$.messager.alert("提示","没有呼叫的病人不能过号！");
			return;
		}
		$.messager.confirm("对话框","登记号: "+rowData.PatNo+" 姓名: "+PatName + "是否需要过号?",function(res){
			if (res){
				var EpisodeID = rowData.EpisodeID; /// 就诊ID
				
				runClassMethod("web.DHCEMDocMainOutPat","SetSkipStatus",{"Adm":EpisodeID,"LgUserID":LgUserID},function(jsonString){
					if (jsonString != 1){
						$.messager.alert("提示","操作失败！失败原因:" + jsonString);
					}
					$("#PatList").datagrid("reload");  /// 刷新病人列表	
				},'',false)
			}
		})
		
	}else{
		$.messager.alert("提示","请选中病人后，再进行过号操作！");
		return;
	}
}

/// 过号重排
function OutCallQueueCP(){
	var rowData = $("#PatList").datagrid('getSelected');
	if(rowData==null){
		$.messager.alert("提示","请选中病人后，再进行过号重排操作！");
		return;
	}
	if(rowData.CalledDesc.indexOf("过号")==-1){
		$.messager.alert("提示","非过号病人不能使用过号重排功能！");
		return;
	}
	
	
	var EpisodeID = rowData.EpisodeID; 
	runClassMethod("web.DHCEMDocMainOutPat","PatPrior",{"EpisodeID":EpisodeID,"UserID":LgUserID},function(ret){
		if(ret==0){
			$.messager.alert("提示","过号重排成功！");
			$("#PatList").datagrid("reload");  /// 刷新病人列表	
		}else{
			$.messager.alert("提示","失败!Code"+ret);
		}
	},'',false)
	return;
}

///叫号结束调用的方法
function findPatientTree(){
	
}

function Find_click(){
	
}

function SetFillToCall(EpisodeID){
	
	return;    /// 领导说上线不用，没有指定IP保存文件时会卡住，所以暂时注释；
	try{
		var fs = new ActiveXObject("Scripting.FileSystemObject");
		var ret=tkMakeServerCall("web.DHCDocMainOut","GetCallMesage",EpisodeID,session["LOGON.USERID"])
		if (ret!=""){
			var RetArry=ret.split("^");
			if (RetArry[0] == "")return;
			var Address=RetArry[0]+"\\"+RetArry[1]+".TXT"
			Address=Address.toString()
			fw=fs.CreateTextFile(Address,true);
		  	fw.WriteLine(RetArry[2]);
		  	fw.Close();
		}
	}catch(e){}
}


function GetComputerIp() 
{
	if(window.ActiveXObject){
		var ipAddr="";
		var locator = new ActiveXObject("WbemScripting.SWbemLocator");
		var service = locator.ConnectServer(".");
		var properties = service.ExecQuery("Select * FROM Win32_NetworkAdapterconfiguration");
		var e = new Enumerator(properties);
		var p=e.item();
		for(;!e.atEnd();e.moveNext())
		{
			var p=e.item();
			ipAddr=p.IPAddress(0);
			if(ipAddr) break;
		}
		return ipAddr;
	}else{
		return ClientIPAddress;
	}
}

/// 根据卡号取病人的卡类型定义
function GetPatCardType(CardNo){
	var CardTypeID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatCardType",{"CardNo":CardNo},function(jsonString){
		if (jsonString != null){
			CardTypeID = jsonString;
		}
	},'',false)
	return CardTypeID;
}

/// 获取病人对应卡类型数据
function GetEmPatCardTypeDefine(CardTypeID){

	runClassMethod("web.DHCEMPatCheckLevCom","GetEmPatCardTypeDefine",{"CardTypeID":CardTypeID},function(jsonString){
		
		if (jsonString != null){
			var CardTypeDefine = jsonString;
			var CardTypeDefArr = CardTypeDefine.split("^");
			if (CardTypeDefArr[16] == "Handle"){
				$('#EmCardNo').attr("readOnly",false);
			}else{
				$('#EmCardNo').attr("readOnly",true);
			}
			m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
			m_CCMRowID = CardTypeDefArr[14];
			$("#EmCardType").combobox("setValue",CardTypeDefine);
		}
	},'',false)
}

function ComplateAdm(){
	var rowData = $("#PatList").datagrid('getSelected');
	debugger;
	var Adm="";
	if (rowData){
		Adm = rowData.EpisodeID; /// 就诊ID
	}
	if(Adm==""){
		$.messager.alert("提示","选择患者就诊记录！");
		return;
	}
	$.m({
		ClassName:"web.DHCDocOutPatientList",
		MethodName:"SetComplate",
		Adm:Adm,
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID']
	},function(rtn){
		if (rtn!="0"){
			$.messager.alert("提示",rtn.split("^")[1]);
			return false;
		}else{
			$.messager.alert("提示","已完成就诊!","info",function(){
				$("#PatList").datagrid("reload");  /// 刷新病人列表		
			});
		}
	});	
}

//hxy 2020-02-21
function setCell(value){
	if(value=="1级"){value="Ⅰ级";}
	if(value=="2级"){value="Ⅱ级";}
	if(value=="3级"){value="Ⅲ级";}
	if(value=="4级"){value="Ⅳa级";}
	if(value=="5级"){value="Ⅳb级";}
	return value;
}


/// =================================== 以上内容为安贞门诊叫号程序 ===========================================
/// JQuery 初始化页面
$(function(){ initPageDefault(); })



