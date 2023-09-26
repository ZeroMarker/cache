/// 2016-11-28 bianshuai 医生病人列表界面 
var SelectedRowData = "";
/// 页面初始化函数
function initPageDefault(){

	initCombobox();  /// 初始化页面选择列表
	initBlButton();  /// 初始化页面按钮事件
	initPatListTable(); /// 初始化病人列表控件
    //initLgUserPriConfig(); /// 初始化用户权限
}

/// 初始化病人列表控件
function initPatListTable(){
	$('#patTable').dhccTable({
	    height:$(window).height()-142,
	    showHeader:false,
		pageSize:10,
		pagination: true,     //是否显示分页（*）
		clickToSelect: true,    //是否启用点击选中行
		formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocMainOutPat&MethodName=JSonQryEmDocMainPatList',
	    queryParam: {
            params: "^^^E^^^^^^^^^"+LgCtLocID+"^"+LgUserID+"^^"+EpisodeID                 //QQA 2017-02-21
        },
        columns: [
        {
            field: 'ff',
            formatter:'patFormatter'
        }],
        onLoadSuccess:function(data){

	        ///  设置分诊区域	        
            if (typeof data.EmPatLevTotal == "undefined"){return;}
        	$(".btn-toolbar .btn-success").text(data.EmPatLevCnt3+"/"+data.EmPatLevTotal);
			$(".btn-toolbar .btn-warning").text(data.EmPatLevCnt2+"/"+data.EmPatLevTotal);
			$(".btn-toolbar .btn-danger").text(data.EmPatLevCnt1+"/"+data.EmPatLevTotal);
			$('strong:contains("未就诊")').html("未就诊："+data.EmPatLevNotCnt+"人");

			if ($('#unfold').hasClass("fa-chevron-up")){
	         	 $('.fixed-table-container').attr("style","height:"+($(window).height()-174)+"px");
			}else{
	            $('.fixed-table-container').attr("style","height:"+($(window).height()-292)+"px");
			}

			if(data.rows.length != 0){
				setPatInfoPanel(data.rows[0]);
		   		/// 加载框架
				LoadPatInfoFrame(data.rows[0]);
				SelectedRowData = data.rows[0];
		
				}
		
	    },
	    onClickRow:function(rowData, $element, field){
		    
		    /// 行颜色设置
		    $($element).addClass("row-background");
		    $($element).siblings().removeClass("row-background");
		    /// 病人信息
		    setPatInfoPanel(rowData);
		    /// 加载框架
			LoadPatInfoFrame(rowData);
			SelectedRowData = rowData;
		}
    });
}

/// table td 格式 病人信息卡片
function patFormatter(value, rowData) {

    	var htmlstr =  '<div class="celllabel"><h3 style="float:left"><span style="color:#f22613;margin-right:10px;">'+ rowData.LocSeqNo +'</span>'+ rowData.PatName +'</h3><h3 style="float:right"><span>'+ rowData.PatSex +'/'+ rowData.PatAge +'</span></h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left">ID:'+ rowData.PatNo +'</h4>';
		var classstyle="color: #18bc9c";
		if(rowData.PatLevel==3) {classstyle="color: #f9bf3b"};
		if(rowData.PatLevel==1) {classstyle="color: #f22613"};
		if(rowData.PatLevel==2) {classstyle="color: #f22613"};
		var level=""
		if(rowData.PatLevel>0){
			level=rowData.PatLevel+"级";
		}
		htmlstr = htmlstr +'<h4 style="float:right"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></h4></div>';

		return htmlstr;
}

/// 页面Combobox初始定义
function initCombobox(){
	
	runClassMethod("web.DHCEMPatCheckLevCom","CardTypeDefineListBroker",{},function (data){
		
		var CardTypeArr=[]; //可以找到
		var objDefult  = new Object();
		for (var i=0;i<data.length;i++){
			var obj = new Object();
			if(data[i].value.split("^")[8]=="N"){
				obj.id=data[i].value;
				obj.text=data[i].text;
				CardTypeArr.push(obj);
			}else if(data[i].value.split("^")[8]=="Y"){
				objDefult.id=data[i].value;
				objDefult.text=data[i].text;
				CarTypeSetting(objDefult.id);
			}
		}
		CardTypeArr.unshift(objDefult);

		$("#CardType").dhccSelect({
   			data:CardTypeArr,
   			minimumResultsForSearch:-1
		});
		$('#CardType').on('select2:select', function (evt) {
  			CarTypeSetting(this.value);
		}); 
	});
}


function CarTypeSetting(value){

	m_SelectCardTypeDR = value.split("^")[0];
	var CardTypeDefArr = value.split("^");
    m_CardNoLength = CardTypeDefArr[17];

    if (CardTypeDefArr[16] == "Handle"){
    	$('#CardNo').attr("readOnly",false);
    }else{
		$('#CardNo').attr("readOnly",true);
	}
	$('#CardNo').val("");  /// 清空内容
	$('#PatNo').val("");   /// 清空内容
}

/// 页面 Button 绑定事件
function initBlButton(){

	///  读卡
	//$('a:contains("读卡")').bind("click",readCard);
		
	///	 登记号
	$('#PatNo').bind('keypress',GetEmPatInfo);
	
	///  卡号
	$('#CardNo').bind('keypress',GetEmPatInfoByCardNo);	
	
	///	 号数
	$('#AdmReqNo').bind('keypress',GetEmPatList);
	
	/// 开始日期
	$('#startdate').dhccDate();
	$("#startdate").setDate(new Date().Format("yyyy-MM-dd"));
	
	/// 结束日期
	$('#enddate').dhccDate();
	$("#enddate").setDate(new Date().Format("yyyy-MM-dd"));
	
	/// 查询按钮
	$("#queryBtn").bind('click',function(){
		search("");
	});
	
	/// 分级级别按钮点击事件
	$(".btn-toolbar button").bind('click',function(){
		search(this.id);
	});
	
	/// 展开/收缩按钮
	$('#unfold').bind('click',function(){
		if ($(this).hasClass("fa-chevron-up")){
			$(this).removeClass("fa-chevron-up");
            $(this).addClass("fa-chevron-down");
            $('.fixed-table-container').attr("style","height:"+($(window).height()-292)+"px");
		}else{
			$(this).removeClass("fa-chevron-down");
            $(this).addClass("fa-chevron-up");
            $('.fixed-table-container').attr("style","height:"+($(window).height()-174)+"px");
		}
	})
	
	/// 展开/收缩按钮
	$('#fold').bind('click',function(){
		if ($(this).hasClass("fa-angle-left")){
			$(this).removeClass("fa-angle-left");
            $(this).addClass("fa-angle-right");
            $(".sidebar-menu").hide();
		}else{
			$(this).removeClass("fa-angle-right");
            $(this).addClass("fa-angle-left");
            $(".sidebar-menu").show();
		}
	})
	
	/// 病人状态按钮事件
	$("#PriCon a").bind('click',showModPanel)
	
	/// 更新病人状态
	$("#update").bind('click',function(){
		modPatStatus();
	});
	
	/// 床号
	$('#EmBed').bind('click',BedPopUpWin);	
	
	/// 急诊病区
	$("#EmWard").change(function(){
		$("#EmBed").val("");   /// 床位描述
		$("#EmBedID").val("");   /// 床位ID
	})
	
	/// Tabs 点击事件
	$(".J_menuTabs").on("click", ".J_menuTab", TabsEvent);
}

///  登记号回车
function GetEmPatInfo(e){
			
	 if(e.keyCode == 13){
		var EmPatNo = $("#PatNo").val();
		///  登记号补0
		var EmPatNo = GetWholePatNo(EmPatNo);
		//clearEmPanel();				///  清空
		$("#PatNo").val(EmPatNo);
		
		runClassMethod("web.DHCEMPatCheckLevCom","CheckPatNo",{"EmPatNo":EmPatNo},function(jsonString){
			
			if (jsonString ==-1){
				dhccBox.alert("当前卡无效,请重试！","register-one");
				return;

			}else{
				$("#PatAdmInfoOne").css("display","none")
				GetEmRegPatInfo();
			}
			
		},'text',false)
		
	}
}

///  卡号回车
function GetEmPatInfoByCardNo(e){
	if(e.keyCode == 13){
		var CardNo = $("#CardNo").val();
		var CardNoLen = CardNo.length;
		if (m_CardNoLength < CardNoLen){
			//$("#emcardno").focus().select();
			dhccBox.alert("卡号输入错误,请重新录入！","register-one");
			return;
		}

		/// 卡号不足位数时补0
		for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
			CardNo="0"+CardNo;  
		}
		
		clearEmPanel();				///  清空
		
		$("#CardNo").val(CardNo);

		///  根据卡号取登记号
		var EmPatNo = "";
		runClassMethod("web.DHCEMPatCheckLevCom","GetPmiNoFrCardNo",{"cardno":CardNo},function(jsonString){

			if (jsonString ==-1){
				dhccBox.alert("当前卡无效,请重试！","register-one");
				return;

			}else{
				EmPatNo = jsonString;
				$("#PatNo").val(EmPatNo);
			}
			
		},'text',false)

		GetEmRegPatInfo();
	}
}

/// 获取病人信息
function GetEmRegPatInfo(){
	
	var EmPatNo = $("#PatNo").val();        /// 登记号;
	var PatientID = $("#PatientID").val();  /// 病人ID
	runClassMethod("web.DHCEMDocMainOutPat","GetEmRegPatInfo",{"EmPatNo":EmPatNo,"PatientID":PatientID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			setPatInfoPanel(rowData);
			search("");
		}
	},'json',false)
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
			dhccBox.alert("登记号输入错误！","register-one");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// 设置登记面板数据
function setPatInfoPanel(rowData){
	if(rowData.PatSex=="男")
	{
		htmlstr='<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;" src="../scripts/dhcnewpro/images/nursemano.png" />'
	}else
	{
		htmlstr='<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;border:0;" src="../scripts/dhcnewpro/images/nursewomano.png" />'
	}
	classstyle="color: #18bc9c";
	classtext="绿区"
	if(rowData.EmPatLev==3) {classstyle="color: #f9bf3b";classtext="黄区"};
	if(rowData.EmPatLev==1) {classstyle="color: #f22613";classtext="红区"};
	if(rowData.EmPatLev==2) {classstyle="color: #f22613";classtext="红区"};
	var htmlstr = htmlstr +'<span style="font-size:16px;color:#000;">'+ rowData.PatName +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
		htmlstr = htmlstr + '<div class="badge " style="background-'+classstyle+';margin: 3px 5px 3px 0px; border-radius: 5px;height:20px;width:28px;"><span style="font-size: 11px; margin-left: -5px;">'+classtext+'</span></div>';
	    htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PatLevel +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
	    /*htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PAAdmBed +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';*/
	    htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PAAdmReason +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
		htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PatSex +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
		htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PatBDay +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
		/* htmlstr = htmlstr + '<ul id="PriCon" class="nav navbar-top-links pull-right" style="margin-right:5px;">';
		htmlstr = htmlstr +	'<li><a href="#" class="btn-primary" style="color:#fff;width:80px;height:28px;text-align:center;" data-id="Salvage">抢救</a></li>';
		htmlstr = htmlstr +	'<li><a href="#" class="btn-primary" style="color:#fff;width:80px;height:28px;text-align:center;" data-id="Stay">留观</a></li></ul>'; */
	/* 	htmlstr = htmlstr + '<span style="color:red;font-weight:bold;color:##758697;display:none">'+ rowData.BillType +'</span>';
		htmlstr = htmlstr + '<span id="EpisodeID" style="display:none;">'+ rowData.EpisodeID +'</span>';
		htmlstr = htmlstr + '<span id="PAAdmType" style="display:none;">'+ rowData.PAAdmType +'</span>'; */
	$("#PatAdmInfo").html(htmlstr);
	
	
	/*if (rowData.PatSex == "女"){
		$("#seximg").attr("src","../scripts/dhcnewpro/images/nursewomano.png");
	}else{
		$("#seximg").attr("src","../scripts/dhcnewpro/images/nursemano.png");
	}*/
	
	var htmlstr = "";
	htmlstr = htmlstr + '<span id="EpisodeID" style="display:none;">'+ rowData.EpisodeID +'</span>';
	htmlstr = htmlstr + '<span id="PAAdmType" style="display:none;">'+ rowData.PAAdmType +'</span>';
	$(".page-title form").append(htmlstr);

	$("#CardNo").val(rowData.PatCardNo);   		    /// 卡号
	$("#PatNo").val(rowData.PatNo);   		        /// 登记号
	
	/*$("#PatName").val(rowData.PatName);   		    /// 姓名
	$("#PatSex").val(rowData.PatSex);   		    /// 性别
	$("#PatCardBal").val(rowData.PatCardBal);   		    /// 余额
	$("#PatLevel").val(rowData.PatLevel);   		    /// 级别
	$("#BillType").val(rowData.BillType);   		    /// 费别 */
	//$("#PatientID").val(rowData.PatientID);   		/// PatientID
	//$("#PatientID").val(rowData.PatientID);   		/// PatientID
	
	//GetEmPatCardTypeDefine(rowData.CardTypeID);  ///  设置卡类型
}

/// 获取病人对应卡类型数据
function GetEmPatCardTypeDefine(CardTypeID){

	runClassMethod("web.DHCEMPatCheckLevCom","GetEmPatCardTypeDefine",{"CardTypeID":CardTypeID},function(jsonString){
		
		if (jsonString != null){
			var CardTypeDefine = jsonString;
			var CardTypeDefArr = CardTypeDefine.split("^");
			if (CardTypeDefArr[16] == "Handle"){
				$('#CardNo').attr("readOnly",false);
			}else{
				$('#CardNo').attr("readOnly",true);
			}
			$("#CardType").combobox("setValue",CardTypeDefine);
		}
	},'',false)
}

///	 清空
function clearEmPanel(){

	$("#CardNo").val(""); /// 卡号
	$("#PatNo").val("");  /// 登记号
}	

/// 天数回车事件调用
function GetEmPatList(e){
	
	if(e.keyCode == 13){
			
		$("#CardNo").val(""); /// 卡号
		$("#PatNo").val("");  /// 登记号
		search("");
	}
}

/// 查找
function search(btn_id){
	
	$("#PatAdmInfoOne").css("display","none");
	/// 卡号
	var CardNo = $("#CardNo").val();
	
	/// 登记号
	var PatNo = "" //$("#PatNo").val();
	/// 开始日期
	var startdate = $('#startdate input').val();
	/// 结束日期
	var enddate = $('#enddate input').val();
	/// 就诊类型
	var PatType = "E";
	/// 已就诊
	var OutArrivedQue=$("#admstatues").is(':checked')?"on":"";
	/// 号数
	var AdmReqNo = $("#AdmReqNo").val();;

	/// 分级
	var EmPatLev = "";
	if (btn_id == "btn_danger"){EmPatLev = "1"; }
	if (btn_id == "btn_warning"){EmPatLev = "2"; }
	if (btn_id == "btn_success"){EmPatLev = "3"; }

	var param = PatNo +"^^^"+ PatType +"^"+ CardNo +"^"+ startdate +"^"+ enddate+"^"+ OutArrivedQue +"^^^^"+ AdmReqNo +"^"+LgCtLocID +"^"+ LgUserID +"^"+ EmPatLev+"^"+EpisodeID;
	$('#patTable').bootstrapTable('refresh',{
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocMainOutPat&MethodName=JSonQryEmDocMainPatList&params='+param
	});
}

/// 呼叫
function callPatient(){

	///调用叫号公司的webervice进行呼叫
	runClassMethod("web.DHCDocOutPatientList","SendCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
			if(retArr[0]=="0"){
				search("");  /// 查询病人列表
				return;
			}else{
				return;
			}
		}
	},'',false)
}

/// 重复呼叫
function reCallPatient(){

	///调用叫号公司的webervice进行重复呼叫
	runClassMethod("web.DHCDocOutPatientList","SendReCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
		}
	},'',false)
}

/// 过号
function outCallQueue(){
	
	//var rowData = $('#patTable').bootstrapTable('getAllSelections');
	if (SelectedRowData == ""){
		dhccBox.alert("请先选择要过号的病人后，重试！","register-one");
		return;
	}
	var AdmDate=SelectedRowData.PAAdmDate;
	if (CheckAdmDate(AdmDate)==false) {
		dhccBox.alert("请选择当日就诊病人！","register-one");
		return;
	}
	if(SelectedRowData.Called == ""){
		dhccBox.alert("没有呼叫的病人不能过号！","register-one");
		return;
	}

	var PatName=SelectedRowData.PatName;
	var Patient="登记号: "+SelectedRowData.PatNo+" 姓名: "+PatName;
	dhccBox.confirm("对话框",Patient + "是否需要过号?","my-modalone",function(res){
		if (res){
			var EpisodeID = SelectedRowData.EpisodeID; /// 就诊ID
			var DoctorId = SelectedRowData.RegDocDr;   /// 医生ID
			runClassMethod("web.DHCDocOutPatientList","SetSkipStatus",{"Adm":CardTypeID,"DocDr":DocDr},function(jsonString){
	
				if (jsonString != ""){
					dhccBox.alert("操作失败！失败原因:" + jsonString,"register-one");
				}
			},'',false)

			search(""); /// 重新查询病人列表	
		}
	})
}

/// 检查是否是当天就诊
function CheckAdmDate(AdmDate)	{

	var ToDay= new Date();
	var Year=ToDay.getFullYear();
	var Month=ToDay.getMonth();
	Month=Month+1;
	if (Month<10) {Month='0'+Month;}
	var Day=ToDay.getDate();
	if (Day<10) Day='0'+Day;
	var StrDate=Year+'-'+Month+'-'+Day
	if (StrDate==AdmDate) {return true}
	else  {return false;}	
}

/// 刷新框架内容
function LoadPatInfoFrame(rowData){

	$(".J_menuTab").each(function(){
		$(this).attr("data-regno",rowData.CardNo);
		$(this).attr("data-episodeid",rowData.EpisodeID);
		$(this).attr("data-patientid",rowData.PatientID);
	})
	var csp = $("iframe:visible").data("id")+"?RegNo="+rowData.CardNo+"&EpisodeID="+rowData.EpisodeID //+"&Allgryflag="+rowData.Allgryflag;
	$("iframe:visible").attr("src",csp)	
	
}

/// 初始化用户权限
function initLgUserPriConfig(){

	/// 留观
	runClassMethod("web.DHCEMDocMainOutPat","GetEmPatStatusAcc",{"userid":LgUserID,"GroupID":LgGroupID,"AuthCode":"Stay"},function(res){
		if (res == 1){
			$("#PriCon").append('<li><a href="#" class="btn-success" style="color:#fff;width:70px;height:35px;text-align:center;border-radius:5px;" data-id="Inhospital">留观</a></li>');
		}
	},'',false)
	
	/// 抢救
	runClassMethod("web.DHCEMDocMainOutPat","GetEmPatStatusAcc",{"userid":LgUserID,"GroupID":LgGroupID,"AuthCode":"Salvage"},function(res){
		if (res == 1){
			$("#PriCon").append('<li><a href="#" class="btn-danger" style="color:#fff;width:70px;height:35px;text-align:center;border-radius:5px;" data-id="Displace">抢救</a></li>');
		}
	},'',false)
}

/// 病人状态按钮事件
function showModPanel(){
	
	var EpisodeID = $("#EpisodeID").text();
	if (EpisodeID == ""){
		//dhccBox.alert("请先选择需要修改状态的病人！","report-timeone");	
		//return ;
	}
	var type=$(this).attr("data-id");
	$("#CommonModel .modal-title").html($(this).html()+"( 变更急诊病人状态 )");
	//留观
	if(type == "Stay"){
		runClassMethod("web.DHCEMPatChange","GetAbnormalConsultAlert",{"EpisodeID":EpisodeID},function(res){
			res = 0
			if (res != '0') {
				dhccBox.alert(res,"report-two");
				return;
			}else{
				conceal();
				$('#changedate').css("display","");
				$('#changetime').css("display","");	
				$('#patarea').css("display","");
				$('#emarea').css("display","");
				$('#embed').css("display","");
				$('#update').attr("data-type","Stay")
				$("#CommonModel .modal-header").addClass("bg-success")
				$('#CommonModel').modal()
			}
		},'',false)
		
		/// 入院病区
		$('#InHosWard').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatChange&MethodName=LookUpWardTojson"
		})
		
		/// 急诊病区
		$('#EmWard').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatChange&MethodName=LookUpWardTojson&locType=EM"
		})
	
		/// 急诊床位
		$('#EmBed').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatChange&MethodName=LookUpCtlocTojson"
		})
	}
	
	/// 抢救
	if(type == "Salvage"){
		runClassMethod("web.DHCEMPatChange","GetAbnormalConsultAlert",{"EpisodeID":EpisodeID},function(res){
			res = 0
			if (res != '0') {
				dhccBox.alert(res,"report-two");
				return;
			}else{
				conceal();
				$('#changedate').css("display","");
				$('#changetime').css("display","");	
				$('#patarea').css("display","");
				$('#update').attr("data-type","Salvage")
				$("#CommonModel .modal-header").addClass("bg-danger")
				$('#CommonModel').modal()
			}
		},'',false)
		
		/// 入院科室下拉框
		$('#InHosWard').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatChange&MethodName=LookUpCtlocTojson"
		})
	}
}

/// 修改病人状态
function modPatStatus(){
	
	var PAAdmType = $("#PAAdmType").text();
	if (PAAdmType != "E"){
		var PAAdmType = (PAAdmType == "E"?"急诊":"门诊")
		//dhccBox.alert("此操作只能针对急诊病人进行,请核实病人状态！当前病人状态为：" + PAAdmType,"register-one");
		//return;
	}
	var type = $(this).attr("data-type");
	if(type == "Stay"){
		SetPatSatyStatus();    /// 更新病人留观状态
	}else{
		SetPatSalvageStatus(); /// 更新病人急救状态
	}
}

/// 更新病人留观状态
function SetPatSatyStatus(){
	
	var EpisodeID = $("#EpisodeID").text();
	var StatusDate=$('#StatusDate input').val();  /// 变更日期
	var StatusTime=$('#StatusTime input').val();  /// 变更时间
	if ((StatusDate=="" )||(StatusTime=="")){
		dhccBox.alert("日期或时间不能为空！","report-timeone");	
		return ;
	}
	/// 入院病区
	var InHosWard=$('#InHosWard option:selected').text();

	/// 留观病区
	var EmWardID=$('#EmWard option:selected').attr("value");
	
	/// 床位
	var EmBedID=$('#EmBedID').val();
	
	/// 更新状态
	runClassMethod("web.DHCEMPatChange","setPatSatyStatus",{"EpisodeID":EpisodeID,"StatusDate":StatusDate,'StatusTime':StatusTime,'userID':LgUserID,'WardDesc':InHosWard,'LocID':LgCtLocID,'EmWardID':EmWardID,'EmBedID':EmBedID},function(res){
		if (res != 0){
			dhccBox.alert("插入状态错误!","report-inserttwo");
			return;
		}
	},'',false);
}

/// 更新病人急救状态
function SetPatSalvageStatus(){
	
	var EpisodeID = $("#EpisodeID").text();
	var StatusDate=$('#StatusDate input').val();  /// 变更日期
	var StatusTime=$('#StatusTime input').val();  /// 变更时间
	if ((StatusDate=="" )||(StatusTime=="")){
		dhccBox.alert("日期或时间不能为空！","report-timeone");	
		return ;
	}

	/// 入院病区
	var InHosWard=$('#InHosWard option:selected').text();
	/// 更新状态
	runClassMethod("web.DHCEMPatChange","InsertVis",{"EpisodeID":EpisodeID,"visStatCode":"Salvage","avsDateStr":StatusDate,'avsTimeStr':StatusTime,'userId':LgUserID,'wardDesc':InHosWard},function(res){
		if (res != 0){
			dhccBox.alert("插入状态错误!","report-inserttwo");
		}else{
			dhccBox.alert("修改成功!","report-inserttwo");
		}
	},'',false)	
}

//隐藏modal所有元素
function conceal(){
	
	$("#CommonModel .modal-header").removeClass("bg-success");
	$("#CommonModel .modal-header").removeClass("bg-danger");
	$('#changedate').css("display","none");
	$('#changetime').css("display","none");
	$('#patarea').css("display","none");
	$('#emarea').css("display","none");
	$('#embed').css("display","none");
	
	$('#StatusDate').dhccDate();
	$("#StatusDate").setDate(new Date().Format("yyyy-MM-dd"))
	
	$('#tp-time').timepicker({minuteStep:1,showMeridian:false});	
}

/// 床位点击事件
function BedPopUpWin(e){
	
	var BedUrl = 'dhcapp.broker.csp?ClassName=web.DHCEMPatChange&MethodName=JSonQryEmWardBed';

	var BedColumns = [
		{checkbox: true,title:'选择'},
		{field:'BedID',title:'床位ID',visible:false},
	    {field:'BedDesc',title:'床位'},
	    {field:'WardDesc',title:'病区'},
	    {field:'RoomDesc',title:'病房'},
		{field:'BedType',title:'床位类型'},
		{field:'RoomType',title:'病房类型'}
	];
	
	var EmWardID = $('#EmWard option:selected').attr("value");
	if (typeof EmWardID == "undefined"){EmWardID="";}
	var unitUrl = BedUrl+"&WardID="+EmWardID+"&EpisodeID=11";
	/// 调用医嘱项列表窗口
	new PopUpWin($("#EmBed"), "760", "260" , unitUrl, BedColumns, setCurrArcEditRowCellVal).init();

}

/// 给当前编辑栏赋值
function setCurrArcEditRowCellVal(rowObj){
	if (rowObj == null){
		$("#EmBed").focus().select();  ///设置焦点 并选中内容
		return;
	}

	$("#EmBed").val(rowObj.BedDesc);   /// 床位描述
	$("#EmBedID").val(rowObj.BedID);   /// 床位ID
}

/// tab点击事件处理
function TabsEvent() {
    
    if (!$(this).hasClass("active")) {
        var k = $(this).data("id");
        regno=$(this).attr("data-regno");
        episodeid=$(this).attr("data-episodeid");
        patientid=$(this).attr("data-patientid");
        if (patientid == ""){
			dhccBox.alert("请先选择病人！","report-timeone");	
			return ;
        }
        $(".J_mainContent .J_iframe").each(function() {
            if ($(this).data("id") == k) {
                
                if($(this).attr("src").indexOf("?")==-1){
	               $(this).attr("src",k+"?RegNo="+regno+"&EpisodeID="+episodeid+"&PatientID="+patientid) 
	            }else{
		            if(checkUrlParam($(this).attr("src"),regno)==0){
			             $(this).attr("src",k+"?RegNo="+regno+"&EpisodeID="+episodeid+"&PatientID="+patientid)
			         }   
		        }
                
                $(this).show().siblings(".J_iframe").hide();
                return false
            }
        });
        $(this).addClass("active").siblings(".J_menuTab").removeClass("active");
        g(this)
    }
}
    
/// JQuery 初始化页面
$(function(){ initPageDefault(); })