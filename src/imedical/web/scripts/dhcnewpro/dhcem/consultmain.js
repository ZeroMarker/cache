//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-22
// 描述:	   会诊申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var CsType = "";        /// 会诊类型
var Risk = "";          /// 危急值
var LgGroup = session['LOGON.GROUPDESC'];
/// 页面初始化函数
function initPageDefault(){

	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	GetPatBaseInfo();         /// 病人就诊信息
	LoadPatientRecord();
	
	InitPageComponent(); 	  /// 初始化界面控件内容 hxy 2021-06-15
	InitPageDataGrid();       /// 初始化申请历史列表 hxy 2021-06-11 
}
function switchPatientEm(patid,admid,mradm)
{
	PatientID=patid;
	EpisodeID=admid;
	GetPatBaseInfo();         /// 病人就诊信息
	LoadPatientRecord();
	InitPageComponent(); 	  /// 初始化界面控件内容 hxy 2021-06-15
	InitPageDataGrid();       /// 初始化申请历史列表 hxy 2021-06-11 
}
/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2023-03-17 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed
	
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	mradm = getParam("mradm");          /// 就诊诊断ID
	CsType = getParam("CsType");         /// 会诊类型
	Risk = getParam("Risk");             /// 危急值
	ObsId=getParam("obsId");			 /// 血糖
	ObsDate=getParam("obsDate");		 /// 血糖时间
	//HOS医生站配置MenuCode DHC.Consult.Manager.IPDoc 取不到就诊 st
	if(EpisodeID==""){ 
		var frm = dhcsys_getmenuform();
		if (frm) {
			PatientID = frm.PatientID.value;
			EpisodeID = frm.EpisodeID.value;
			mradm = frm.mradm.value;
		}
	}//ed
//	if(EpisodeID==""){
//		$.messager.alert("提示","请先选择患者的就诊记录！","warning");
//	}
	/// 患者列表（护士会诊不弹出患者列表）
	if((CsType!="Nur")&&(!PatientID&&!EpisodeID)&&(LocAdmType!="I")){
		openPatListWin();
	}
}
function openPatListWin(){
	if($('#winpatlist').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winpatlist" style="overflow:hidden"></div>');
	$('#winpatlist').window({
		iconCls:'icon-w-paper', //hxy 2023-02-24
		title:$g('患者列表'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal: true,
		width:1300,
		height:600
	});
	
	var link="dhcem.patlist.csp?";
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token改造
		link += "&MWToken="+websys_getMWToken();
	}
	var cot = '<iframe scrolling="yes" width=100% height=99%  frameborder="0" src='+link+'></iframe>';
	$('#winpatlist').html(cot);
	$('#winpatlist').window('open');
}
function hidePatListWin(){
	$('#winpatlist').window('close');
}

/// 病人就诊信息
function GetPatBaseInfo(){
	if(LocAdmType=="I"){
		$('#myLayout').layout('panel', 'north').panel('resize',{height:10});
		$('#myLayout').layout('resize');
		$("#PatPhoto").css("display","none");
	}else{
		$("#PatPhoto").css("display","inline");
	
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if ((jsonObject.PatSexCh == "男")||(jsonObject.PatSex == "Male")){
				$("#PatPhoto").attr("src","../images/man_lite.png"); //../scripts/dhcnewpro/images/boy.png //hxy 2023-01-04
			}else if ((jsonObject.PatSexCh == "女")||(jsonObject.PatSex == "Female")){
				$("#PatPhoto").attr("src","../images/woman_lite.png "); //../scripts/dhcnewpro/images/girl.png //hxy 2023-01-04
			}else{
				$("#PatPhoto").attr("src","../images/unman.png");
			}
		})
	},'json',false)

	}
}

/// 病历查看
function LoadPatientRecord(){
	
	/// 危急值和血糖带入界面会带参数过来，不要取框架中的值
	if((Risk=="")&&(ObsId=="")){
		var frm = dhcsys_getmenuform();
		if (frm) {
			PatientID = frm.PatientID.value==""?PatientID:frm.PatientID.value;
			EpisodeID = frm.EpisodeID.value==""?EpisodeID:frm.EpisodeID.value;
			mradm = frm.mradm.value==""?mradm:frm.mradm.value;
		}
	}
	
	
	var EMRCSP="emr.bs.browse.csp"; //hxy 2021-05-10 st //emr.interface.browse.category.csp
	if((CsType=="Nur")&&(NurUseNurRec==1)){
		EMRCSP="nur.hisui.recordsBrowser.csp";
		$('#myLayout').layout('panel','center').panel('setTitle',$g('护理病历'));
	} //ed
	var link =EMRCSP+"?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp&SinglePatient=1'+'&CsType='+CsType+'&categorydir=south'; //hxy 2021-02-09 原：emr.interface.browse.category.csp //2021-03-19 改回去：左右布局字体太小，仍使用原上下布局 emr.browse.manage.csp
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	$("#newWinFrame").attr("src",link);//2023-02-06 add CsType:为了给护理病历一个标识，以屏蔽患者信息
	
	var url = "dhcem.consultwrite.csp";
	if (CsType == "Nur"){
		url = "dhcem.consultnur.csp";
	}
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&seeCstType=2&Risk="+Risk+"&ObsId="+ObsId+"&ObsDate="+ObsDate;
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	$("#ConsultFrame").attr("src",link);
}

/// 引用内容
function InsQuote(resQuote, flag){

	frames[0].InsQuote(resQuote, flag); /// 插入引用内容
}

/// 初始化界面控件内容
function InitPageComponent(){
		
	/// 开始日期
	$HUI.datebox("#CstStartDate").setValue(GetCurSystemDate(-1));
	
	/// 结束日期
	$HUI.datebox("#CstEndDate").setValue(GetCurSystemDate(0));
	
	/// 护士会诊不需要
	if(CsType=="Nur"){
		$("#myLayout").layout('remove','west');
	}
}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// 页面DataGrid初始定义
function InitPageDataGrid(){
	///  定义columns
	var columns=[[
		{field:'PatLabel',width:218,formatter:setCellLabel,align:'center'} //hxy 2023-02-08 205->218
	]];
	
	///  定义datagrid
	var option = {
		fit:true,
		striped:false, //hxy 2023-02-08
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
		toolbar:"#btn-toolbar",
        onClickRow:function(rowIndex, rowData){
	        CstID = rowData.CstID;           /// 会诊ID
	        CstItmID = rowData.CstItmID;     /// 会诊子表ID
			var link = "dhcem.consultwrite.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&seeCstType=2"+"&CstID="+CstID+"&CstItmID="+CstItmID+"&IsMain=1";
			if ('undefined'!==typeof websys_getMWToken){
				link += "&MWToken="+websys_getMWToken();
			}
			$("#ConsultFrame").attr("src",link);
	    },
		onLoadSuccess:function(data){
			///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
		},
		rowStyler:function(index,rowData){   	       
	    }
	};
	
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// 开始日期
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// 结束日期
	var params = CstStartDate +"^"+ CstEndDate+"^^^" + session['LOGON.USERID'] +"^"+ session['LOGON.CTLOCID'] +"^"+"R"+"^^^^"+EpisodeID; //11:就诊号
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonGetConList&Params="+params;
	new ListComponent('PatList', columns, uniturl, option).Init();
	
	//  隐藏刷新按钮
	$('#PatList').datagrid('getPager').pagination({ showRefresh: false}); 
	
	///  隐藏分页图标
    var panel = $("#PatList").datagrid('getPanel').panel('panel');  
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide()
}

/// 申请列表 卡片样式
function setCellLabel(value, rowData, rowIndex){

	
	var FontColor = "green";
	var EmHtml="";    ///加急显示在病人名字后   
	if ((rowData.CsStatCode == $g("取消"))||(rowData.CsStatCode == $g("拒绝"))){
		FontColor = "red";
	}
	if (rowData.CsEmFlag == $g("加急")){
       EmHtml="<span style='color:red'>("+$g("急")+")</span>";
    }
	var ConsultType = rowData.CstTypeDesc.split("")[0];
	var CsCategory = rowData.CsCategory;
	var TypeColor="";
	if(CsCategory=="DOCA") ConsultType=$g("抗");
	if(ConsultType==$g("单")){
		TypeColor="#ABD";	
	}else if(ConsultType==$g("多")) {
		TypeColor="#fbfb79";
	}else{
		TypeColor="#9de09d";
	}
	
	if (rowData.CsSurTime == "超时"){
		rowData.CsSurTime = $g("超时");
	}
	
	/// 会诊科室
	var CsLocDesc = rowData.CsCLoc;
	if (CsLocDesc != ""){
		CsLocDesc = CsLocDesc.length > 8?CsLocDesc.substr(0,8)+"...":CsLocDesc;
	}
	
	var htmlstr =  '<div class="celllabel" style="padding-right:8px"><h3 style="position:absolute;left:0;background-color:transparent;">'+ rowData.PatName;
	htmlstr = htmlstr +EmHtml+'</h3>'
	if(rowData.MulStr!=""){ //hxy 2021-01-25
		htmlstr = htmlstr +'<br>';
	}else{
	htmlstr = htmlstr +'<h3 style="position:relative;float:right;color:'+ FontColor +';background-color:transparent;"><span>'+ $g(rowData.CsStatCode) +'</span></h3><br>';
	}
	if($("button:contains('"+$g("会诊列表")+"')").hasClass("btn-blue-select")){
		htmlstr = htmlstr +'<h4 style="position:absolute;left:0;background-color:transparent;color:green;">'+ rowData.CsRLoc +'</h4>';
		htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;color:green;">'+ rowData.CsRUser +'</h4><br>';
	}
	if(rowData.MulStr!=""){ //hxy 2021-01-25
		var MulStrArr=rowData.MulStr.split("##");
		for(var i=0; i<MulStrArr.length; i++){
			var MulStat=MulStrArr[i].split(",")[2];
			var MulColor = "green";
			if ((MulColor == $g("取消"))||(MulColor == $g("拒绝"))){
				MulColor = "red";
			}
			if(MulStrArr[i].length<15){ //hxy 2021-03-15
			var MulHtml='<h3 style="float:right;position:relative;left:4px;color:'+ MulColor +';background-color:transparent;"><span>'+ MulStat +'&nbsp;</span></h3>';
			htmlstr = htmlstr + '<h4 style="position:absolute;left:0;background-color:transparent;">'+ MulStrArr[i].split(",")[0] +'</h4>'+MulHtml;
			htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ MulStrArr[i].split(",")[1] +'</h4><br>';
			}else if(MulStrArr[i].length>20){
				var MulHtml='<h3 style="float:right;position:relative;left:4px;color:'+ MulColor +';background-color:transparent;"><span>'+ MulStat +'&nbsp;</span></h3>';
				htmlstr = htmlstr + '<h4 style="position:absolute;left:0;background-color:transparent;">'+ MulStrArr[i].split(",")[0] +'</h4><br>';
				if(MulStat!="")htmlstr = htmlstr +MulHtml;
				htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ MulStrArr[i].split(",")[1] +'</h4><br>';
			}else{
				var MulHtml='<h3 style="float:right;position:relative;left:4px;color:'+ MulColor +';background-color:transparent;"><span>'+ MulStat +'&nbsp;</span></h3>';
				htmlstr = htmlstr + '<h4 style="position:absolute;left:0;background-color:transparent;">'+ MulStrArr[i].split(",")[0] +'</h4>';
				htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ MulStrArr[i].split(",")[1] +'</h4><br>';
				if(MulStat!="")htmlstr = htmlstr +MulHtml+'<br>';
			}
			
		}
	}else{
	htmlstr = htmlstr +'<h4 style="position:absolute;left:0;background-color:transparent;">'+ CsLocDesc +'</h4>';
	if((CsLocDesc.length+rowData.CsCUser.length)>16){
		htmlstr = htmlstr +'<br>'
	}
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ rowData.CsCUser +'</h4><br>';
	}
	htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.CsRDate +" "+ rowData.CsRTime +'</h4>';
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;color:red;">'+ rowData.CsSurTime +'</h4><br>';
	htmlstr = htmlstr + '<span style=\"position: relative;top: -25px;left: 45px;border-radius: 3px; display: inline-block;width: 20px;height: 18px;line-height: 18px;background-color:'+TypeColor+'\" class="consult_type">'+$g(ConsultType)+'</span>';
	htmlstr = htmlstr + '<br>';
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// 查询申请单列表
function QryCons(Load){
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// 开始日期
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// 结束日期
    /// 重新加载会诊列表
	var params = CstStartDate +"^"+ CstEndDate +"^^"+ session['LOGON.HOSPID'] +"^"+ session['LOGON.USERID'] +"^"+session['LOGON.CTLOCID']+"^"+ "R" +"^^^^"+EpisodeID;
	$("#PatList").datagrid("load",{"Params":params});
	if(Load=="1"){
		LoadConFrame(); //2021-07-05
	}
}

/// 重新加载
function LoadConFrame(){
	var link = "dhcem.consultwrite.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&seeCstType=2"; //+"&CstID="+CstID+"&CstItmID="+CstItmID+"&IsMain=1";
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	$("#ConsultFrame").attr("src",link);
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })
