//===========================================================================================
// ���ߣ�      sunhe
// ��д����:   2022-08-15
// ����:	   ԺǰԺ���ν�ƽ̨
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgParams=LgUserID+"^"+LgLocID+"^"+LgHospID;
var EpisodeID="";
function initPageDefault(){
	
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitPageStyle();          /// ��ʼ��ҳ����ʽ
	initMap("")   //��ʼ����ͼ
}

/// ��ʼ��ҳ����ʽ
function InitPageStyle(){
	
	$("#LisPanel").css({"height":$(document).height()-50});
	$("#dgEmPatList").datagrid("resize");

}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	/// ��ʼ����
	$HUI.datebox("#CstStartDate").setValue(GetCurSystemDate(-1));
	
	/// ��������
	$HUI.datebox("#CstEndDate").setValue(GetCurSystemDate(0));
	
	///tabs 
	$HUI.tabs("#tabs",{
		onSelect:function(tabTitle){
			var rowData = $("#dgEmPatList").datagrid('getSelected'); //ѡ��Ҫɾ������
			if (rowData != null) {
				EpisodeID = rowData.EpisodeID;
			}
 			selectTab(tabTitle, EpisodeID);
		}
	});
}

function selectTab(tabTitle, EpisodeID){
	if(tabTitle=="������Ϣ"){
		initPatInf(EpisodeID)
	}
	else if(tabTitle=="�ĵ�ͼ"){
		initXd(EpisodeID)
	}
	else if(tabTitle=="�ĵ���Ƭ"){
		initXdPhoto(EpisodeID)
	}else if(tabTitle=="����"){
    	initCs(EpisodeID)
    }else if(tabTitle=="��ͼ"){
		initMap()
	}else if(tabTitle=="Զ�̻���"){
		initYchz(EpisodeID, "");
	}
}

/// ҳ��DataGrid��ʼ����11
function InitPageDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'PatLabel',title:'�����б�',width:205,formatter:setCellLabel,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
			var tab = $("#tabs").tabs("getSelected");    //��ȡѡ�еı�ǩҳ���
    		var tabObj = tab.panel('options').tab;          //��Ӧ�ı�ǩҳ����
    		var tabTitle = tabObj[0].innerText;             //��Ӧ�ı�ǩҳ����
    		selectTab(tabTitle, rowData.EpisodeID);
	    },
		onLoadSuccess:function(data){
			///  ���ط�ҳͼ��
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            if (data.rows.length != 0) {
		       $('#dgEmPatList').datagrid("selectRow", 0); 
		       
		       var tab = $("#tabs").tabs("getSelected");    //��ȡѡ�еı�ǩҳ���
    		   var tabObj = tab.panel('options').tab;          //��Ӧ�ı�ǩҳ����
    		   var tabTitle = tabObj[0].innerText;             //��Ӧ�ı�ǩҳ����
		       selectTab(tabTitle, data.rows[0].EpisodeID);
		    } 
   
		},
		rowStyler:function(index,rowData){   
	
	    }
	};

	var params = LgParams+"^^^^"
	var uniturl = LINK_CSP+"?ClassName=web.DHCERPreinJoin&MethodName=GetErPatList&Params="+params;
	new ListComponent('dgEmPatList', columns, uniturl, option).Init();
	
	///  ����ˢ�°�ť
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false}); 
	
	///  ���ط�ҳͼ��
    var panel = $("#dgEmPatList").datagrid('getPanel').panel('panel');  
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide()
}

/// �����б� ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){	
	
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.PatName +'</h3>';
	htmlstr = htmlstr +'<h3 style="position:absolute;right:0;background-color:transparent;"><span>'+ rowData.PatNo +'</span></h3><br>';
	htmlstr = htmlstr +'<h4 style="position:absolute;left:0;background-color:transparent;">'+ rowData.PatAge +'</h4>';
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ rowData.EMDispJud +'</h4><br>';
	htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.PAAdmDate+" "+rowData.PAAdmTime+'</h4>';
	htmlstr = htmlstr + '<br>';
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// ��ѯ���뵥�б�
function QryCons(){
	
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// ��ʼ����
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// ��������
	var PatNo = $("#PatNo").val();    /// �ǼǺ�
	var PatName = $("#PatName").val();    /// ��������
   /// ���¼��ػ����б�
	var params = LgParams+"^"+CstStartDate+"^"+CstEndDate+"^"+PatNo+"^"+PatName;
	$("#dgEmPatList").datagrid("load",{"Params":params});
}

/// ���¼��ػ����б�
function reLoadEmPatList(){
	$("#dgEmPatList").datagrid("reload");   /// ˢ��ҳ������
}

/// ˢ����ҳ������
function reLoadMainPanel(){
	reLoadEmPatList(); /// ���¼��ػ����б�
}

function btn_More_Click(){
	
	if ($(".more-panel").is(":hidden")){
		$(".more-panel").css("display","block");
		$("#LisPanel").height($("#LisPanel").height()-180);
		$("#dgEmPatList").datagrid("resize");
	}else{
		$(".more-panel").css("display","none");
		$("#LisPanel").height($("#LisPanel").height()+180);
		$("#dgEmPatList").datagrid("resize");
	}
}
/// ������Ϣ
function initPatInf(EpisodeID){	
	var url="dhcer.patprehosinf.csp?EpisodeID="+EpisodeID
	$("#patInf").attr("src",url)
}
/// ��ʼ����ͼ
function initMap(method, params){
	
//	var Link = "dhcer.defaulthome.csp?message=δ��⵽��ͼ���ӣ������������ã�";
//	$('#map').html('<iframe id="mapframe" src="'+ Link +'" width="100%" height="100%" style="border:0"/>');
	var Link = "dhcer.larscrmap.csp";
	$('#map').html('<iframe id="mapframe" src="'+ Link +'" width="100%" height="100%" style="border:0"/>');
}

//�ĵ�
function initXd(patno){
	
	//var Link = "dhcer.defaulthome.csp?message=δ��⵽�豸���ӣ������������ã�";
	var Link="../scripts/dhcnewpro/dhcer/pdf/xd.pdf";  
	$("#xd").attr("src",Link)
}

//�ĵ���Ƭ
function initXdPhoto(EpisodeID){	

	var url = "dhcer.ecgshow.csp";
	$("#xdPhoto").attr("src",url)
}
//����
function initCs(EpisodeID){	
	var url="dhcer.ultimgview.csp?EpisodeID="+EpisodeID 
	$("#cs").attr("src",url)
}
//Զ�̻���
function initYchz(admDr,SN){
		
	var url="dhcer.remoteconsultations.csp?admDr="+admDr+"&SN="+SN+"&flag=1";
	$("#consult").attr("src",url)
//	var url="dhcer.remoteconsultations.csp?admDr="+admDr+"&SN="+SN+"&flag=1"
//	window.open(url); 
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

/// �Զ�����ҳ�沼��
function onresize_handler(){
	$.parser.parse($('#tabmain'));  /// ���½���	
}

window.onresize = onresize_handler;
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })