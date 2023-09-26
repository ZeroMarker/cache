//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-22
// ����:	   �������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var CstID = "";         /// ��������ID
var CsType = "";        /// ��������
var isWriteFlag = "-1";
var listStautsHtml=""
var CstTypeArr = [{"value":"A","text":$g('ȫ��')}, {"value":"V","text":$g('��ʵ')}, {"value":"D","text":$g('ֹͣ')}];
/// ҳ���ʼ������
function initPageDefault(){
	
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	//GetPatBaseInfo();       /// ���˾�����Ϣ
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitPageStyle();          /// ��ʼ��ҳ����ʽ
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	CsType = getParam("CsType");  /// ��������
	listStautsHtml=$("#statusUl").html();
}

/// ��ʼ��ҳ����ʽ
function InitPageStyle(){
	
	//$("#LisPanel").css({"height":$(document).height() - 215});
	$("#dgEmPatList").datagrid("resize");
	$(".item-label").hide();	 /// ���ز�����Ϣ��
	$(".item-tip").show();	     /// ��ʾ��ʾ��
	if (CsType == "Nur"){
       $("#TabMain1").hide();
	   $("#TabMain2").hide();
	   $("#TabMain3").show();
	}
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=";
	/// ״̬����
	var option = {
		onSelect:function(option){
		}
	}
	var url = uniturl+"jsonConsStat&HospID="+session['LOGON.HOSPID'];
	new ListCombobox("CstType",url,'',option).init();
	//$HUI.combobox("#CstType").setValue("A");
	
	/// ��ʼ����
	$("#CstStartDate").next().find(".validatebox-text").attr("placeholder",$g("��ʼ����")).css("color","#A9A9A9");
	$HUI.datebox("#CstStartDate").setValue(GetCurSystemDate(-1));
	
	/// ��������
	$("#CstEndDate").next().find(".validatebox-text").attr("placeholder",$g("��������")).css("color","#A9A9A9");
	$HUI.datebox("#CstEndDate").setValue(GetCurSystemDate(0));
	
	/// �ǼǺ�
	$("#EmPatNo").bind('keypress',PatNo_KeyPress);
}

/// �ǼǺ�
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#EmPatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  �ǼǺŲ�0
			$("#EmPatNo").val(GetWholePatNo(PatNo));
		}
		
		TypeFlag = "R";   /// �����б�����
		if ($("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select")){
			TypeFlag = "C"
		}

		QryConsList(TypeFlag);  /// ��ѯ
	}
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == $g("��")){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == $g("Ů")){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../images/unman.png");
			}
		})
	},'json',false)
}

/// ҳ��DataGrid��ʼ����
function InitPageDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'PatLabel',title:$g('�������뵥'),width:205,formatter:setCellLabel,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		fit:true,
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
		toolbar:"#btn-toolbar",
        onClickRow:function(rowIndex, rowData){
	        
	        $(".item-label").show(); /// ��ʾ������Ϣ��
	        $(".item-tip").hide();	 /// ������ʾ��

			/// ���뵥��ѡ�б�
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
			///  ���ط�ҳͼ��
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            if (typeof data.CsHanNum != "undefined"){
            	$("button:contains('"+$g("�����б�")+"')").text($g("�����б�")+"["+data.CsHanNum+"]");
            }
		},
		rowStyler:function(index,rowData){   
	        if (rowData.CsStatCode == $g("ȡ��")){
	            return 'background-color:Pink;'; 
	        }
	       
	    }
	};

	var params = "^^^^" + session['LOGON.USERID'] +"^"+ session['LOGON.CTLOCID'] +"^R^^" + IsFiltPrvTpFlag;
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonGetConList&Params="+params;
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
	
	var FontColor = "green";
	var EmHtml="";    ///�Ӽ���ʾ�ڲ������ֺ�   
	if ((rowData.CsStatCode == $g("ȡ��"))||(rowData.CsStatCode == $g("�ܾ�"))){
		FontColor = "red";
	}
	if (rowData.CsEmFlag == $g("�Ӽ�")){
       EmHtml="<span style='color:red'>("+$g("��")+")</span>";
    }
	var ConsultType = rowData.CstTypeDesc.split("")[0];
	var CsCategory = rowData.CsCategory;
	var TypeColor="";
	if(CsCategory=="DOCA") ConsultType=$g("��");
	if(ConsultType==$g("��")){
		TypeColor="#ABD";	
	}else if(ConsultType==$g("��")) {
		TypeColor="#fbfb79";
	}else{
		TypeColor="#9de09d";
	}
	
	/// �������
	var CsLocDesc = rowData.CsCLoc;
	if (CsLocDesc != ""){
		CsLocDesc = CsLocDesc.length > 8?CsLocDesc.substr(0,8)+"...":CsLocDesc;
	}
	
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.PatName;
	htmlstr = htmlstr +EmHtml+'</h3>'
	htmlstr = htmlstr +'<h3 style="position:absolute;right:0;color:'+ FontColor +';background-color:transparent;"><span>'+ $g(rowData.CsStatCode) +'</span></h3><br>';
	if($("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select")){
		htmlstr = htmlstr +'<h4 style="position:absolute;left:0;background-color:transparent;color:green;">'+ rowData.CsRLoc +'</h4>';
		htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;color:green;">'+ rowData.CsRUser +'</h4><br>';
	}
	htmlstr = htmlstr +'<h4 style="position:absolute;left:0;background-color:transparent;">'+ CsLocDesc +'</h4>';
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ rowData.CsCUser +'</h4><br>';
	htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.CsRDate +" "+ rowData.CsRTime +'</h4>';
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;color:red;">'+ rowData.CsSurTime +'</h4><br>';
	htmlstr = htmlstr + '<span style=\"position: relative;top: -25px;left: 45px;border-radius: 3px; display: inline-block;width: 20px;height: 18px;line-height: 18px;background-color:'+TypeColor+'\" class="consult_type">'+$g(ConsultType)+'</span>';
	htmlstr = htmlstr + '<br>';
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// ��ѯ���뵥�б�
function QryCons(){
	
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// ��ʼ����
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// ��������
	var CstTypeID = $HUI.combobox("#CstType").getValue();    /// ״̬
	TypeFlag = "R";   /// �����б�����
	if ($("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select")){
		TypeFlag = "C"
	}
	var PatNo = $("#EmPatNo").val();    /// �ǼǺ�
    /// ���¼��ػ����б�
	var params = CstStartDate +"^"+ CstEndDate +"^"+ CstTypeID +"^"+ session['LOGON.HOSPID'] +"^"+ + session['LOGON.USERID'] +"^"+session['LOGON.CTLOCID']+"^"+ TypeFlag +"^"+ PatNo +"^"+ IsFiltPrvTpFlag;

	$("#dgEmPatList").datagrid("load",{"Params":params});
}


/// ��ѯ���뵥�б�
function QryConsList(TypeFlag){
	
	if (TypeFlag == "C"){
		$("button:contains('"+$g("�����б�")+"')").addClass("btn-blue-select");
		$("button:contains('"+$g("�����б�")+"')").removeClass("btn-blue-select")
	}else{
		$("button:contains('"+$g("�����б�")+"')").addClass("btn-blue-select");
		$("button:contains('"+$g("�����б�")+"')").removeClass("btn-blue-select")
	}
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// ��ʼ����
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// ��������
	var CstTypeID = $HUI.combobox("#CstType").getValue();    /// ״̬
	var PatNo = $("#EmPatNo").val();    /// �ǼǺ�

    /// ���¼��ػ����б�
	var params = CstStartDate +"^"+ CstEndDate +"^"+ CstTypeID +"^"+ session['LOGON.HOSPID'] +"^"+ + session['LOGON.USERID'] +"^"+session['LOGON.CTLOCID'] +"^"+ TypeFlag +"^"+ PatNo +"^"+ IsFiltPrvTpFlag;

	$("#dgEmPatList").datagrid("load",{"Params":params});
}

/// ��ʼ�������б�״̬
function LoadConsStatus(CstItmID){
	$("#statusUl").html(listStautsHtml);
	$(".status-list li").removeClass("li_comp").removeClass("li_active");
	$(".status-list li").find("span").text("");
	$(".status-list li").find(".time").text("");
	$("#21").hide();  					/// �������״̬
	$("#5").hide();  					/// ����ȡ��״̬
	$("#25").hide();  					/// ���ؾܾ�״̬
	$("#22").hide();  					/// ���ز���״̬
	
	if(CstItmID==""){return;} //hxy 2020-03-02
	
	runClassMethod("web.DHCEMConsultQuery","JsonGetEmConsLog",{"CstID":CstItmID},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			var statusCode=jsonObjArr[jsonObjArr.length-1].Status;
			var showLogFlag=false;
			if((statusCode==25)||(statusCode==5)) showLogFlag=true;
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

/// ��鷽���б�
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
	/// ����
	if (itemobj.Status == 70){
		$("#"+ itemobj.Status).css({"border-left":"0"});
	}
	/// ȡ������
	if (itemobj.Status == 35){
		$("#30").find(".txt span").html("");
		$("#30").find(".time").text("");
		$("#30").removeClass("li_comp").removeClass("li_active");
		return;
	}
	/// ȡ�����
	if (itemobj.Status == 51){
		$("#50").find(".txt span").html("");
		$("#50").find(".time").text("");
		$("#50").removeClass("li_comp").removeClass("li_active");
		return;
	}
	
	///���ͣ�ȡ����˲����״̬Ҳ�Ƿ��ͣ�����ֻȡ��һ�η���״̬����Ϣ
	if(itemobj.Status==20){
		var hasUserDesc = $("#"+ itemobj.Status).find(".txt span").html();
		if(hasUserDesc!="") return;
	}
	
	
	var txt = $("#"+ itemobj.Status).find(".txt").text();
	$("#"+ itemobj.Status).find(".txt span").html(itemobj.User);
	$("#"+ itemobj.Status).find(".time").text(itemobj.Time);
}

/// ���¼��ػ����б�
function reLoadEmPatList(){
	$("#dgEmPatList").datagrid("reload");   /// ˢ��ҳ������
}

/// ˢ����ҳ������
function reLoadMainPanel(CstID){
	LoadConsStatus(CstID)
	reLoadEmPatList(); /// ���¼��ػ����б�
}


/// ˢ����ҳ������
function UpdMainPanel(CstID,statCode){
	LoadConsStatus(CstID)
	UpdEmPatList(statCode); /// �޸�ѡ���б�ֵ
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

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert($g('������ʾ'),$g("�ǼǺ��������"));
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

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

/// ��������
function InsQuote(resQuote, flag){
	frames[0].InsQuote(resQuote, flag); /// ������������
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })