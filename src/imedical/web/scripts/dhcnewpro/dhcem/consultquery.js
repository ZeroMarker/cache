//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-22
// 描述:	   会诊申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var CstID = "";         /// 会诊申请ID
var CsType = "";        /// 会诊类型
var isWriteFlag = "-1";
var listStautsHtml=""
var CstTypeArr = [{"value":"A","text":$g('全部')}, {"value":"V","text":$g('核实')}, {"value":"D","text":$g('停止')}];
var WinName="" //侧菜单时为'idhcem_consultquery'
/// 页面初始化函数
function initPageDefault(){
	InitNorth();
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	//GetPatBaseInfo();       /// 病人就诊信息
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitPageStyle();          /// 初始化页面样式
}

function InitNorth(){
	
	if(window.name){ //侧菜单标识
		if(window.name=="idhcem_consultquery"){
			WinName=1;
			$('#myLayout').layout('remove','north');
		}
	}
	
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	CsType = getParam("CsType");  /// 会诊类型
	listStautsHtml=$("#statusUl").html();
}

/// 初始化页面样式
function InitPageStyle(){
	
	//$("#LisPanel").css({"height":$(document).height() - 215});
	$("#dgEmPatList").datagrid("resize");
	$(".item-label").hide();	 /// 隐藏病人信息栏
	$(".item-tip").show();	     /// 显示提示栏
	if (CsType == "Nur"){
       $("#TabMain1").hide();
	   $("#TabMain2").hide();
	   $("#TabMain3").show();
	}
	if(QueryShow==1){ //hxy 2021-01-14
		$(".more-panel").css("display","block");
	}
}

/// 初始化界面控件内容
function InitPageComponent(){
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=";
	/// 状态类型
	var option = {
		onSelect:function(option){
		}
	}
	var url = uniturl+"jsonConsStat&HospID="+session['LOGON.HOSPID']+"&RidNotProSta=1"; //RidNotProSta移除非流程控制的状态标志（到达）
	new ListCombobox("CstType",url,'',option).init();
	//$HUI.combobox("#CstType").setValue("A");
	
	/// 开始日期
	$("#CstStartDate").next().find(".validatebox-text").attr("placeholder",$g("开始日期")).css("color","#A9A9A9");
	var Days=Number(DefStDay) //hxy 2021-02-24 st
	if((trim(DefStDay)=="")||(isNaN(DefStDay))){
		Days=-1;
	}else{
		Days=0-Days;
	}
	$HUI.datebox("#CstStartDate").setValue(GetCurSystemDate(Days)); //ed 原：-1
	
	/// 结束日期
	$("#CstEndDate").next().find(".validatebox-text").attr("placeholder",$g("结束日期")).css("color","#A9A9A9");
	$HUI.datebox("#CstEndDate").setValue(GetCurSystemDate(0));
	
	/// 登记号
	$("#EmPatNo").bind('keypress',PatNo_KeyPress);
	
	/*// 本科复选框 hxy 2021-03-09
	if((DefRListByLoc==1)&(DefCList!=1)){ //hxy 2021-03-12 &(DefCList!=1)
		$("#ByLocSpan").css("display","inline");
		$("#QryCons").css("margin-left","10px");
		$HUI.checkbox("#ByLoc").setValue(true);
	}*/
	/// 本科复选框 hxy 2021-03-09
	if(DefRListByLoc==1){
		$HUI.checkbox("#ByLoc").setValue(true);
		if(DefCList!=1){
			$("#ByLocSpan").css("display","inline");
			$("#QryCons").css("margin-left","10px");
		}else{
			$HUI.checkbox("#ByLoc").setValue(false);
		}
	}
	
	/// 本科复选框 hxy 2022-05-26 会诊列表
	if(CListByLoc==1){
		if(DefCList==1){
			$("#ByLocSpan").css("display","inline");
			$("#QryCons").css("margin-left","10px");
		}	
	}
	
	//会诊性质 hxy 2022-06-23
	$HUI.combobox("#consNature",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstProp&LgHospID="+session['LOGON.HOSPID'],
		valueField: "itmID", 
		textField: "itmDesc",
		panelHeight:"auto",
		editable:true
	})
}

/// 登记号
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#EmPatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			$("#EmPatNo").val(GetWholePatNo(PatNo));
		}
		
		TypeFlag = "R";   /// 会诊列表类型
		if ($("button:contains('"+$g("会诊列表")+"')").hasClass("btn-blue-select")){
			TypeFlag = "C"
		}

		QryConsList(TypeFlag);  /// 查询
	}
}

/// 病人就诊信息
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			//if ((jsonObject.PatSex == $g("男"))||(jsonObject.PatSex == "male")){
			if ((jsonObject.PatSexCh == "男")||(jsonObject.PatSex == "Male")){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if ((jsonObject.PatSexCh == "女")||(jsonObject.PatSex == "Female")){
			//}else if ((jsonObject.PatSex == $g("女"))||(jsonObject.PatSex == "female")){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../images/unman.png");
			}
		})
	},'json',false)
}

/// 页面DataGrid初始定义
function InitPageDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'PatLabel',title:$g('会诊申请单'),width:228,formatter:setCellLabel,align:'center'} //hxy 2023-02-08 205->228
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
	        
	        $(".item-label").show(); /// 显示病人信息栏
	        $(".item-tip").hide();	 /// 隐藏提示栏

			/// 申请单已选列表
	        var CstID = rowData.CstID;
	        var CstItmID = rowData.CstItmID;
	        if (rowData.CsCategory == "MDT"){
		       $("#TabMain1").hide();
		       $("#TabMain2").show();
		       $("#TabMain3").hide();
			   frames[1].LoadReqFrame(CstID, CstItmID);
	        }else if (rowData.CsCategory == "NUR"){
		       $("#TabMain1").hide();
			   $("#TabMain2").hide();
			   $("#TabMain3").show();
		       frames[2].LoadReqFrame(CstID, CstItmID);
		    }else{
		       $("#TabMain1").show();
			   $("#TabMain2").hide();
			   $("#TabMain3").hide();
		       frames[0].LoadReqFrame(CstID, CstItmID);
		    }
			EpisodeID = rowData.EpisodeID;
			GetPatBaseInfo();
			LoadConsStatus(CstItmID);
	    },
		onLoadSuccess:function(data){
			///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            if (typeof data.CsHanNum != "undefined"){
            	$("button:contains('"+$g("会诊列表")+"')").text($g("会诊列表")+"["+data.CsHanNum+"]");
            }
            if(WinName==1){
	            if(data.rows.length){
		            $("#TabMain1").show();
			   		$("#TabMain2").hide();
			   		$("#TabMain3").hide();
		            $("#dgEmPatList").datagrid('selectRow','0');
		            var CstID = data.rows[0].CstID;
	        		var CstItmID = data.rows[0].CstItmID;
	        		EpisodeID = data.rows[0].EpisodeID;
	        		LoadConsStatus(CstItmID);
	        		setTimeout(function(){ 
						frames[0].LoadReqFrame(CstID, CstItmID);
					}, 100);
		        }
	            
	        }
		},
		rowStyler:function(index,rowData){   
	        if (rowData.CsStatCode == $g("取消")){
	            return 'background-color:Pink;'; 
	        }
	       
	    }
	};
	
	TypeFlag="R"; //hxy 2021-02-20 st
	if(DefCList==1){
		TypeFlag="C";
		$("button:contains('"+$g("会诊列表")+"')").addClass("btn-blue-select");
		$("button:contains('"+$g("申请列表")+"')").removeClass("btn-blue-select")
	}
	
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// 开始日期
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// 结束日期
	var ByLoc = $HUI.checkbox("#ByLoc").getValue()?"1":"0"; //hxy 2021-03-09
	var params = CstStartDate +"^"+ CstEndDate+"^^^" + session['LOGON.USERID'] +"^"+ session['LOGON.CTLOCID'] +"^"+TypeFlag+"^^" + IsFiltPrvTpFlag+"^"+ByLoc+"^"+"^^";
	if(WinName==1){
		params=params+EpisodeID;
	}
	//var params = "^^^^" + session['LOGON.USERID'] +"^"+ session['LOGON.CTLOCID'] +"^R^^" + IsFiltPrvTpFlag; //ed
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonGetConList&Params="+params;
	new ListComponent('dgEmPatList', columns, uniturl, option).Init();
	
	///  隐藏刷新按钮
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false}); 
	
	///  隐藏分页图标
    var panel = $("#dgEmPatList").datagrid('getPanel').panel('panel');  
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
	
	var htmlstr =  '<div class="celllabel" style="padding-right:8px"><h3 style="float:left;background-color:transparent;">'+ rowData.PatName;
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
			if ((MulStat == $g("取消"))||(MulStat == $g("拒绝"))){
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
function QryCons(){
	
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// 开始日期
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// 结束日期
	var CstTypeID = $HUI.combobox("#CstType").getValue();    /// 状态
	TypeFlag = "R";   /// 会诊列表类型
	if ($("button:contains('"+$g("会诊列表")+"')").hasClass("btn-blue-select")){
		TypeFlag = "C"
	}
	var PatNo = $("#EmPatNo").val();    /// 登记号
	var ByLoc = $HUI.checkbox("#ByLoc").getValue()?"1":"0"; //hxy 2021-03-09
	var consNature = $HUI.combobox("#consNature").getValue()==undefined?"":$HUI.combobox("#consNature").getValue(); //会诊性质 hxy 2022-06-23

    /// 重新加载会诊列表
	var params = CstStartDate +"^"+ CstEndDate +"^"+ CstTypeID +"^"+ session['LOGON.HOSPID'] +"^"+ session['LOGON.USERID'] +"^"+session['LOGON.CTLOCID']+"^"+ TypeFlag +"^"+ PatNo +"^"+ IsFiltPrvTpFlag+"^"+ByLoc+"^"+"^"+consNature+"^";
	if(WinName==1){
		params = params+EpisodeID;
	}

	$("#dgEmPatList").datagrid("load",{"Params":params});
}


/// 查询申请单列表
function QryConsList(TypeFlag){
	
	if (TypeFlag == "C"){
		$("button:contains('"+$g("会诊列表")+"')").addClass("btn-blue-select");
		$("button:contains('"+$g("申请列表")+"')").removeClass("btn-blue-select");
		$("#ByLocSpan").css("display","none"); //hxy 2021-03-10 st
		$("#QryCons").css("margin-left","60px"); //ed
		if(CListByLoc==1){ //hxy 2021-05-26 st
			$("#ByLocSpan").css("display","inline"); 
			$("#QryCons").css("margin-left","10px");
		}else{
			$("#ByLocSpan").css("display","none");
			$("#QryCons").css("margin-left","60px");
		}
		$HUI.checkbox("#ByLoc").setValue(false);//ed
	}else{
		$("button:contains('"+$g("申请列表")+"')").addClass("btn-blue-select");
		$("button:contains('"+$g("会诊列表")+"')").removeClass("btn-blue-select");
		if(DefRListByLoc==1){ //hxy 2021-03-10 st
			$("#ByLocSpan").css("display","inline"); 
			$("#QryCons").css("margin-left","10px");
			$HUI.checkbox("#ByLoc").setValue(true); //hxy 2022-05-26 st
		}else{
			$HUI.checkbox("#ByLoc").setValue(false);
			$("#ByLocSpan").css("display","none");
			$("#QryCons").css("margin-left","60px");
		}//ed
	}
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// 开始日期
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// 结束日期
	var CstTypeID = $HUI.combobox("#CstType").getValue();    /// 状态
	var PatNo = $("#EmPatNo").val();    /// 登记号
	var ByLoc = $HUI.checkbox("#ByLoc").getValue()?"1":"0"; //hxy 2021-03-09

    /// 重新加载会诊列表
	var params = CstStartDate +"^"+ CstEndDate +"^"+ CstTypeID +"^"+ session['LOGON.HOSPID'] +"^"+ + session['LOGON.USERID'] +"^"+session['LOGON.CTLOCID'] +"^"+ TypeFlag +"^"+ PatNo +"^"+ IsFiltPrvTpFlag+"^"+ByLoc+"^"+"^^";
	if(WinName==1){
		params = params+EpisodeID;
	}

	$("#dgEmPatList").datagrid("load",{"Params":params});
}

/// 初始化会诊列表状态
function LoadConsStatus(CstItmID){
	$("#statusUl").html(listStautsHtml);
	$(".status-list li").removeClass("li_comp").removeClass("li_active");
	$(".status-list li").find("span").text("");
	$(".status-list li").find(".time").text("");
	$(".dymStatusLi").remove();
	//$("#21").hide();  					/// 隐藏审核状态
	//$("#5").hide();  						/// 隐藏取消状态
	//$("#25").hide();  					/// 隐藏拒绝状态
	//$("#22").hide();  					/// 隐藏驳回状态
	
	if(CstItmID==""){return;} //hxy 2020-03-02
	
	runClassMethod("web.DHCEMConsultQuery","JsonGetEmConsLogAndWorkFlowStauts",{"CstID":CstItmID},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString.ConsLog;
			var stringStatus = jsonString.WorkFlowStauts;
			if(stringStatus!=""){
				var statusArr=stringStatus.split("#");
				for(var i=statusArr.length; i>0; i--){
					InitConsWorkFlowStatus(statusArr[i-1]);
				}
			}
			
			if(jsonObjArr.length==0)return; //hxy 2021-01-13 否则报错导致列表不能刷新
			var statusCode=jsonObjArr[jsonObjArr.length-1].Status;
			var showLogFlag=false;
			if((statusCode==25)||(statusCode==5)||(statusCode==22)) showLogFlag=true; //hxy 2021-01-28 add ||(statusCode==22)
			if(showLogFlag){
				$("#statusUl").html("");
				for (var i=0; i<jsonObjArr.length; i++){
					InitConsStatusList(jsonObjArr[i]);	
				}
			}else{
				for (var i=0; i<jsonObjArr.length; i++){
					InitConsStatus(jsonObjArr[i],(i==jsonObjArr.length - 1));
				}
			}
		}
	},'json',false)
}

function InitConsWorkFlowStatus(itemString){
	var itm="";
	itm = itm+"<li id='"+itemString.split("^")[0]+"' class='dymStatusLi workFlowStItm'>"
	itm = itm+"<div class='circle'></div>";
	itm = itm+"<div class='txt'>"+itemString.split("^")[1]+"<span style='margin-left:10px;'></span></div>";
	itm = itm+"<div class='time'></div>";
	itm = itm+"</li>"
							
	$("#statusUl").find("#20").after(itm);		
	
	return;	
}

function InitConsStatusList(itemobj){
	var itm="";
	itm = itm+"<li id='' class='li_active'>"
	itm = itm+"<div class='circle'></div>";
	itm = itm+"<div class='txt'>"+itemobj.StatusDesc+"<span style='margin-left:10px;'>"+itemobj.User+"</span></div>";
	itm = itm+"<div class='time'>"+itemobj.Time+"</div>";
	itm = itm+"</li>"
							
	$("#statusUl").append(itm);		
	
	return;	
}

/// 检查方法列表
function InitConsStatus(itemobj, Flag){	

	if (Flag){
		$("#"+ itemobj.Status).addClass("li_active");
	}else{
		$("#"+ itemobj.Status).addClass("li_comp");
	}
	
	if (itemobj.Status == 5){
		$("#"+ itemobj.Status).show();
	}
	if (itemobj.Status == 21){
		$("#"+ itemobj.Status).show();
	}else if(itemobj.Status < 21){
		$("#21").removeClass("li_comp").removeClass("li_active");
	}
	
	if (itemobj.Status == 22){
		$("#"+ itemobj.Status).show();
	}
	if (itemobj.Status == 25){
		$("#"+ itemobj.Status).show();
	}
	/// 评价
	if (itemobj.Status == 70){
		$("#"+ itemobj.Status).css({"border-left":"0"});
	}
	/// 取消接收
	if (itemobj.Status == 35){
		$("#30").find(".txt span").html("");
		$("#30").find(".time").text("");
		$("#30").removeClass("li_comp").removeClass("li_active");
		return;
	}
	/// 取消完成
	if (itemobj.Status == 51){
		$("#50").find(".txt span").html("");
		$("#50").find(".time").text("");
		$("#50").removeClass("li_comp").removeClass("li_active");
		return;
	}
	
	///发送：取消审核插入的状态也是发送，这里只取第一次发送状态的信息
	if(itemobj.Status==20){
		var hasUserDesc = $("#"+ itemobj.Status).find(".txt span").html();
		if(hasUserDesc!="") return;
	}
	
	///取消审核
	if (itemobj.Status == 80){
		var wFlStItmLen=$(".workFlowStItm").length;
		if(wFlStItmLen>0){
			for (i=wFlStItmLen;i--;i>0){
				var $thisItm=$(".workFlowStItm").eq(i);
				if(!$thisItm.hasClass("li_comp")) continue;
				$thisItm.find(".txt span").html("");
				$thisItm.find(".time").text("");
				$thisItm.removeClass("li_comp").removeClass("li_active");
				break;
			}
		}
		return;
	}
	
	/// 取消会诊评价
	if (itemobj.Status == 56){
		$("#55").find(".txt span").html("");
		$("#55").find(".time").text("");
		$("#55").removeClass("li_comp").removeClass("li_active");
		return;
	}
	
	/// 取消确认 hxy 2021-01-07
	if (itemobj.Status == 61){
		$("#60").find(".txt span").html("");
		$("#60").find(".time").text("");
		$("#60").removeClass("li_comp").removeClass("li_active");
		return;
	}
	/// 取消评价 hxy 2021-01-08
	if (itemobj.Status == 79){
		$("#70").find(".txt span").html("");
		$("#70").find(".time").text("");
		$("#70").removeClass("li_comp").removeClass("li_active");
		return;
	}
	
	var txt = $("#"+ itemobj.Status).find(".txt").text();
	$("#"+ itemobj.Status).find(".txt span").html(itemobj.User);
	$("#"+ itemobj.Status).find(".time").text(itemobj.Time);
}

/// 重新加载会诊列表
function reLoadEmPatList(){
	$("#dgEmPatList").datagrid("reload");   /// 刷新页面数据
}

/// 刷新主页面数据
function reLoadMainPanel(CstID){
	LoadConsStatus(CstID)
	reLoadEmPatList(); /// 重新加载会诊列表
}


/// 刷新主页面数据
function UpdMainPanel(CstID,statCode){
	LoadConsStatus(CstID)
	UpdEmPatList(statCode); /// 修改选中列表值
}


function UpdEmPatList(statCode){
	
	var rowData=$HUI.datagrid("#dgEmPatList").getSelected();
	if(rowData!=null){
		var rowIndex=$HUI.datagrid("#dgEmPatList").getRowIndex(rowData)
		$HUI.datagrid("#dgEmPatList").updateRow({
			index:rowIndex,
			row:{
				CsStatCode:statCode	
			}
		})
	}
}


function btn_More_Click(){
	
	if ($(".more-panel").is(":hidden")){
		$(".more-panel").css("display","block");
		//$("#LisPanel").height($("#LisPanel").height()-180);
		$("#dgEmPatList").datagrid("resize");
	}else{
		$(".more-panel").css("display","none");
		//$("#LisPanel").height($("#LisPanel").height()+180);
		$("#dgEmPatList").datagrid("resize");
	}
}

var resetEprMenuForm = function(){
	setEprMenuForm("","","","");
}

var setEprMenuForm = function(adm,papmi,mradm,canGiveBirth){
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		frm.mradm.value = mradm; 				//DHCDocMainView.EpisodeID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if (frm.canGiveBirth) frm.canGiveBirth.value = canGiveBirth;
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
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
			$.messager.alert($g('错误提示'),$g("登记号输入错误！"));
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

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

/// 引用内容
function InsQuote(resQuote, flag){
	if(flag>20){ //hxy 2021-01-14
		frames[2].InsQuote(resQuote, flag); /// 插入引用内容
	}else{
	frames[0].InsQuote(resQuote, flag); /// 插入引用内容
	} //ed
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })