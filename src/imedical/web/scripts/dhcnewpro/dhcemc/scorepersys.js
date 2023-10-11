//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-10-21
// ����:	   ���ֲ�ѯJS
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID

/// ҳ���ʼ������
function initPageDefault(){

	InitParams();      /// ��ʼ������
	InitDetList();     /// ��ʼ���б�
	InitComponent();   /// ��ʼ�����
	InitPatInfoBanner(EpisodeID);
	//initPatInfoBar();	/// ���ز�����Ϣ
}

/// ��ʼ��ҳ�����
function InitParams(){
	// 2023-03-09 HOS �����б��� st
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl");
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):'';
	// 2023-03-09 HOS �����б��� ed
	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
}

/// ��ʼ�����
function InitComponent(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	
	/// ������
	$(".pf-nav-item-li").bind("click",function(){
		$("#"+this.id).addClass("item-li-select").siblings().removeClass("item-li-select");
		var LinkUrl = "dhcemc.scoretabreview.csp?ScoreID=&ScoreCode="+ $(this).attr("data-name") +"&EditFlag=2&EpisodeID="+ EpisodeID;
		if ('undefined'!==typeof websys_getMWToken){
			LinkUrl += "&MWToken="+websys_getMWToken();
		}
		$("#FormMain").attr("src", LinkUrl);
	});
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitDetList(){
	
	///  ����columns
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'ScoreLabel',title:'���ֱ�',width:215,formatter:setCellLabel,align:''}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		toolbar:"#tbtoolbar",
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
		    ///  ���ط�ҳͼ��
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();	
		},
		onClickRow: function (rowIndex, rowData) {
			/// ������
			$(".pf-nav-item-li").removeClass("item-li-select");
			var LinkUrl = "dhcemc.scoretabreview.csp?ScoreID="+ rowData.ScoreID +"&ID=" + rowData.ID +"&EditFlag=0";
			if ('undefined'!==typeof websys_getMWToken){
				LinkUrl += "&MWToken="+websys_getMWToken();
			}
			$("#FormMain").attr("src", LinkUrl);
        }
	};
	/// ��������
	var param = "^^^"+ EpisodeID+"^"+LgHospID; //hxy 2020-06-09 +"^"+LgHospID
	var uniturl = $URL+"?ClassName=web.DHCEMCScoreQuery&MethodName=JsGetScore&Params="+param;
	if ('undefined'!==typeof websys_getMWToken){
		uniturl += "&MWToken="+websys_getMWToken();
	}
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// �����б� ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){

	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.ScoreDesc +'</h3>';
	htmlstr = htmlstr +'<h3 style="position:absolute;right:0;color:red;background-color:transparent;"><span style="font-size:17px;">'+ rowData.ScoreVal +$g('��')+'</span></h3><br>';
	htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.Date +" "+ rowData.Time +'</h4>';
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ rowData.User +'</h4><br>';
	htmlstr = htmlstr + '<br>';
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// ���ֱ�Ԥ��
function review(ID, ScoreID){
	
	if (ScoreID == ""){
		$.messager.alert("��ʾ:","��Ϊ�գ�","warning");
		return;
	}
	var link = "dhcemc.scoretabreview.csp?ScoreID="+ ScoreID +"&ID=" + ID +"&EditFlag=2";
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	window.open(link, '_blank', 'height='+ (window.screen.availHeight - 180) +', width=1200, top=50, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ��ѯ
function find_click(){

	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var params = StartDate +"^"+ EndDate +"^"+ "" +"^"+ EpisodeID+"^"+LgHospID; //hxy 2020-06-09 +"^"+LgHospID
	$("#bmDetList").datagrid("load",{"Params":params});
}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// ���ֻص�����
function InvScoreCallBack(ScoreCode, scoreVal){
	
	$("#bmDetList").datagrid("reload");
}

/// �Զ�����ҳ�沼��
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
			$("#patInfo").html("��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�");
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
/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
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

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
