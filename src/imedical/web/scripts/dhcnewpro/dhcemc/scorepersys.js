//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-10-21
// 描述:	   评分查询JS
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID

/// 页面初始化函数
function initPageDefault(){

	InitParams();      /// 初始化参数
	InitDetList();     /// 初始化列表
	InitComponent();   /// 初始化组件
	InitPatInfoBanner(EpisodeID);
	//initPatInfoBar();	/// 加载病人信息
}

/// 初始化页面参数
function InitParams(){
	// 2023-03-09 HOS 患者列表弹出 st
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl");
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):'';
	// 2023-03-09 HOS 患者列表弹出 ed
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
}

/// 初始化组件
function InitComponent(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	
	/// 表单类型
	$(".pf-nav-item-li").bind("click",function(){
		$("#"+this.id).addClass("item-li-select").siblings().removeClass("item-li-select");
		var LinkUrl = "dhcemc.scoretabreview.csp?ScoreID=&ScoreCode="+ $(this).attr("data-name") +"&EditFlag=2&EpisodeID="+ EpisodeID;
		if ('undefined'!==typeof websys_getMWToken){
			LinkUrl += "&MWToken="+websys_getMWToken();
		}
		$("#FormMain").attr("src", LinkUrl);
	});
}

/// 页面DataGrid初始定义已选列表
function InitDetList(){
	
	///  定义columns
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'ScoreLabel',title:'评分表',width:215,formatter:setCellLabel,align:''}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		toolbar:"#tbtoolbar",
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
		    ///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();	
		},
		onClickRow: function (rowIndex, rowData) {
			/// 表单类型
			$(".pf-nav-item-li").removeClass("item-li-select");
			var LinkUrl = "dhcemc.scoretabreview.csp?ScoreID="+ rowData.ScoreID +"&ID=" + rowData.ID +"&EditFlag=0";
			if ('undefined'!==typeof websys_getMWToken){
				LinkUrl += "&MWToken="+websys_getMWToken();
			}
			$("#FormMain").attr("src", LinkUrl);
        }
	};
	/// 就诊类型
	var param = "^^^"+ EpisodeID+"^"+LgHospID; //hxy 2020-06-09 +"^"+LgHospID
	var uniturl = $URL+"?ClassName=web.DHCEMCScoreQuery&MethodName=JsGetScore&Params="+param;
	if ('undefined'!==typeof websys_getMWToken){
		uniturl += "&MWToken="+websys_getMWToken();
	}
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 申请列表 卡片样式
function setCellLabel(value, rowData, rowIndex){

	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.ScoreDesc +'</h3>';
	htmlstr = htmlstr +'<h3 style="position:absolute;right:0;color:red;background-color:transparent;"><span style="font-size:17px;">'+ rowData.ScoreVal +$g('分')+'</span></h3><br>';
	htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.Date +" "+ rowData.Time +'</h4>';
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ rowData.User +'</h4><br>';
	htmlstr = htmlstr + '<br>';
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// 评分表预览
function review(ID, ScoreID){
	
	if (ScoreID == ""){
		$.messager.alert("提示:","表单为空！","warning");
		return;
	}
	var link = "dhcemc.scoretabreview.csp?ScoreID="+ ScoreID +"&ID=" + ID +"&EditFlag=2";
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	window.open(link, '_blank', 'height='+ (window.screen.availHeight - 180) +', width=1200, top=50, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 查询
function find_click(){

	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var params = StartDate +"^"+ EndDate +"^"+ "" +"^"+ EpisodeID+"^"+LgHospID; //hxy 2020-06-09 +"^"+LgHospID
	$("#bmDetList").datagrid("load",{"Params":params});
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

/// 评分回调函数
function InvScoreCallBack(ScoreCode, scoreVal){
	
	$("#bmDetList").datagrid("reload");
}

/// 自动设置页面布局
function onresize_handler(){
	
}
function initPatInfoBar(){
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:EpisodeID,PatientID:PatientID},function(html){
		if (html!=""){
			var TopBtnWid=30; //hxy 2023-01-09
			var patInfoWi=$("#patInfo").width();
			var whiteBaWi=$(".item-label").width()-30;
			if(patInfoWi>whiteBaWi){
				var Ellipsis='<div class="Ellipsis" style="width:'+TopBtnWid+'px;">...</div>';
				$("#patInfo").html(reservedToHtml(html)+Ellipsis);
			}else{
				$("#patInfo").html(reservedToHtml(html));
			}
			$("#patInfo").mouseover(function(){
				html=reservedToHtml(html).replace(/color:#589DDA/g, "");
				layer.tips(html, '#patInfo', {
    				tips: [1, '#3595CC'],
    				area: ['800px', 'auto'],
    				time: 0
				});
			});
			$("#patInfo").mouseout(function(){
				layer.closeAll()
			});
		}else{
			$("#patInfo").html("获取病人信息失败。请检查【患者信息展示】配置。");
		}
	});		
}
function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}
/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
	
	var thisobj = $(".pf-nav-item-li")[0];
	var LinkUrl = "dhcemc.scoretabreview.csp?ScoreID=&ScoreCode="+ $(thisobj).attr("data-name") +"&EditFlag=2&EpisodeID="+ EpisodeID;
	if ('undefined'!==typeof websys_getMWToken){
		LinkUrl += "&MWToken="+websys_getMWToken();
	}
	$("#FormMain").attr("src", LinkUrl);
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
