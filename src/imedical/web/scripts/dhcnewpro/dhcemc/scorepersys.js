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
	GetPatBaseInfo();  /// ���ز�����Ϣ
}

/// ��ʼ��ҳ�����
function InitParams(){
	
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
		$("#FormMain").attr("src", LinkUrl);
	});
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "Ů"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/unman.png");
			}
		})
	},'json',false)
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitDetList(){
	
	///  ����columns
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'ScoreLabel',title:'���ֱ�',width:215,formatter:setCellLabel,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
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
			$("#FormMain").attr("src", LinkUrl);
        }
	};
	/// ��������
	var param = "^^^"+ EpisodeID+"^"+LgHospID; //hxy 2020-06-09 +"^"+LgHospID
	var uniturl = $URL+"?ClassName=web.DHCEMCScoreQuery&MethodName=JsGetScore&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// �����б� ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){

	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.ScoreDesc +'</h3>';
	htmlstr = htmlstr +'<h3 style="position:absolute;right:0;color:red;background-color:transparent;"><span style="font-size:17px;">'+ rowData.ScoreVal +'��</span></h3><br>';
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

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
	onresize_handler();
	
	var thisobj = $(".pf-nav-item-li")[0];
	var LinkUrl = "dhcemc.scoretabreview.csp?ScoreID=&ScoreCode="+ $(thisobj).attr("data-name") +"&EditFlag=2&EpisodeID="+ EpisodeID;
	$("#FormMain").attr("src", LinkUrl);
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })