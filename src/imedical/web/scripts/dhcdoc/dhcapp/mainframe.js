//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-08
// ����:	   �°���һ�廯
//===========================================================================================

var PatientID = "";      /// ����ID
var mradm = "";			 /// �������ID
var EpisodeID = "";      /// ���˾���ID
var arItemCatID = "";    /// ������ID
var itemSelFlag = "";    /// ��ѡ�б�ǰ״ֵ̬
var mMainSrc = "E";
var arExaReqIdList = "";
var LgUserID = session['LOGON.USERID'];   /// �û�ID
var LgCtLocID = session['LOGON.CTLOCID']; /// ����ID
var LgGroupID = session['LOGON.GROUPID']; /// ��ȫ��ID
var LgHospID = session['LOGON.HOSPID'];   /// ҽԺID
var repStatusArr = [{"value":"V","text":$g('��ʵ')}, {"value":"D","text":$g('ֹͣ')}, {"value":"I","text":$g('�����')}];
var PyType="";
var PatType="";   /// ��������
var PracticeFlag=""
var NotBindLabFee="";	//���鲻�󶨷��ñ�־,Y����

/// 1���رյ�ǰ������ˢ��ҽ��ҳ��(ҽ��վ)
/// 2���رյ�ǰ����(���Ӳ���)
var CloseFlag = "";      /// �رձ�־

/// ����ǩ�����
var IsCAWin = "";	  
var caIsPass = 0;
var ContainerName = "";
var BillTypeID = "";     /// ���˷ѱ�
var BillType = "";       /// ���˷ѱ�
var SendFlag = "";       /// �Ƿ���
var PPRowId = "";        /// �ٴ�����ID
var PPFlag = "";         /// �ٴ����б�ʶ
var IsPatDead="";
var EmConsultItm="";     /// �����ӱ�ID
var LeaveSelect="";		/// �뿪�����¼�ѡ���ʶ

/// ҳ���ʼ������
function initPageDefault(){
		
	InitPatEpisodeID();   ///  ��ʼ�����ز��˾���ID
	initShowBillType();   ///  ��ʼ�����˷ѱ�
	initVersionMain();    ///  ҳ���������
	initDataGrid();  	  ///  ҳ��DataGrid��ʼ����

	initCombobox();       ///  ҳ��Combobox��ʼ����
	initBlButton();       ///  ҳ��Button���¼�
	initCombogrid();      ///  ҳ��Combogrid�¼�
	GetPatBaseInfo();     ///  ���ز�����ϢBillType
		
	LoadPageBaseInfo();   ///  ��ʼ�����ػ�������
	initPatNotTakOrdMsg(); /// ��֤�����Ƿ�����ҽ��
	
	switchMainSrc("L","","","","");
	//��ʼ����������LookUp
    InitChronicDiagLookUp();
	treeTypeClick();	  ///  ��ݰ�ť����¼���Ӧ
	if (RecLocByLogonLocFlag==1) {
		$("#FindByLogDep").checkbox("setValue",true);
	}
	GetIsPatDeadFlag();
}

function initShowBillType(){

	var billBtnHtml="";
	if (EpisodeID!="") {
		var billInfo = $.m({ClassName:"web.DHCAPPExaReportQuery",MethodName:"GetBillInfo",EpisodeID:EpisodeID,PPFlag:PPFlag,InHosp:session['LOGON.HOSPID']},false);
		BillTypeID=billInfo.split("^")[0];   /// �ѱ�ָ��
		BillType=billInfo.split("^")[1];
		PatType=billInfo.split("^")[2];      /// ��������
	}
	if((PPFlag=="Y")&&(BillTypeID=="")){
		$.messager.alert("��ʾ","���в��˷ѱ�δ����,���ܷ������뵥��");
		return;
	}
	
	if(PPFlag=="Y"){
		 //billBtnHtml = billBtnHtml+"<li class='pf-nav-item-li item-li item-li-select' id='"+BillTypeID+"'><span>"+BillType+"</span></li>"
		billBtnHtml = billBtnHtml+" <li data-type='' id='"+BillTypeID+"' ><a href='#' >"+BillType+"</a></li>"
	}else{
		var PrescriptTypeStr = $.m({ClassName:"web.DHCDocOrderCommon",MethodName:"GetPrescriptTypeInfo",BillTypeID:BillTypeID,PAAdmType:PatType},false);
		var PrescriptTypeArr = PrescriptTypeStr.split("^");
		var PresTypes=PrescriptTypeArr[0]  /// �ѱ��б�
		var DefTypes=PrescriptTypeArr[1]   /// Ĭ�Ϸѱ�
		if (DefTypes!="") {
			BillTypeID=DefTypes.split(":")[0];
			BillType=DefTypes.split(":")[1];
		}
		InitInsurFlag(BillTypeID)
		
		var PresTypesArr = PresTypes.split(";");
		for(i in PresTypesArr){
		   var BillTypeList=PresTypesArr[i];
		   var TypeID=BillTypeList.split(":")[0];
		   var BillTypeDesc=BillTypeList.split(":")[1];
		   if(BillTypeList!=DefTypes){
			   //billBtnHtml = billBtnHtml+"<li class='pf-nav-item-li item-li' id='"+TypeID+"'><span>"+BillTypeDesc+"</span></li>";
			   billBtnHtml = billBtnHtml+" <li class='' id='"+TypeID+"'><a href='#' >"+BillTypeDesc+"</a></li>"
		   }else{
			  //billBtnHtml = billBtnHtml+"<li class='pf-nav-item-li item-li item-li-select' id='"+TypeID+"'><span>"+BillTypeDesc+"</span></li>"
			  billBtnHtml = billBtnHtml+" <li class='selected' id='"+TypeID+"' ><a href='#' >"+BillTypeDesc+"</a></li>"
		   }
		}
	}
	$("#billTyp").append(billBtnHtml);
	return;
}

function initShowPatInfo(){
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:EpisodeID,PatientID:""},function(html){
		if (html!=""){
			$("#patInfo").html(reservedToHtml(html));
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

/**
* @author wanghc
* @date 2012/5/18
* @param {String} str
* @return {HTMLString} html htmlƬ��
*/
function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

/// ҳ���������
function initVersionMain(){

    initCheckPartTree();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	PatientID = getParam("PatientID");
	mradm = getParam("mradm");
	CloseFlag = getParam("CloseFlag");
	PPRowId = getParam("PPRowId");    /// �ٴ�����ID
	PPFlag = PPRowId==""?"N":"Y";
	PracticeFlag=getParam("PracticeFlag");  
	EmConsultItm=getParam("EmConsultItm");
	NotBindLabFee=getParam("NotBindLabFee");
	if (ParaType!="SideMenu"){
		if(typeof InitPatInfoBanner){
			InitPatInfoBanner(EpisodeID,PatientID);
		}
	}
	ShowSecondeWin("onOpenDHCEMRbrowse");
}

///  ��ʼ�����ػ�������
function LoadPageBaseInfo(){
	
	/// ��ʼ����
	findExaItmTree();
	
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	runClassMethod("web.DHCAPPExaReportQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "PPFlag":PPFlag},function(jsonString){
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
		if (BillType == ""){
			BillTypeID = jsonObject.BillTypeID;  /// �ѱ�ID
			BillType = jsonObject.BillType;  /// �ѱ�
			InitInsurFlag(BillTypeID)
			
			
		}
		PatType = jsonObject.PatType;  		/// ��������
	},'json',false)
}

/// ҳ��DataGrid��ʼ����
function initDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'PatLabel',title:'���뵥',width:217,formatter:setCellLabel,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	        itemSelFlag = 1;  /// ��ѡ�б�ǰ״ֵ̬
			/// ���뵥��ѡ�б�
	        var arRepID = rowData.arRepID;
	        var nodeType = rowData.TraType;
	        var repEmgFlag = rowData.repEmgFlag;
	       
		    if(nodeType != mMainSrc){
				switchMainSrc(nodeType, "", arRepID, repEmgFlag, rowData.ReqType);   ///��ӼӼ���־  sufan
			}else{
				frames[0].LoadReqFrame(arRepID, repEmgFlag);
			}
			//mMainSrc = nodeType; /// ��ǰ��Դ����
	    },
		onLoadSuccess:function(data){
			///  ���ط�ҳͼ��
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            BindTips(); /// ����ʾ��Ϣ
		},
		rowStyler:function(index,rowData){   
	        if (rowData.repStatCode == "ֹͣ"){
	            return 'background-color:Pink;'; 
	        }
	    },
	    onRowContextMenu: function (e, rowIndex, rowData) { //�Ҽ�ʱ�����¼�

           e.preventDefault(); //��ֹ����������Ҽ��¼�  
           $(this).datagrid("clearSelections"); //ȡ������ѡ����  
           $(this).datagrid("selectRow", rowIndex); //��������ѡ�и���  
           $('#menu').menu('show', {  
               //��ʾ�Ҽ��˵�  
               left: e.pageX,//�����������ʾ�˵�  
               top: e.pageY  
           });  
           e.preventDefault();  //��ֹ������Դ����Ҽ��˵����� 
        }
	};

	var params = EpisodeID +"^^^"+ LgHospID;
	if (PracticeFlag==1){
		var params = EpisodeID +"^^I^"+ LgHospID;
		}
	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqHisList&params="+params;
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
	if (rowData.repStatCode == "ֹͣ"){
		FontColor = "red";
	}
	if (rowData.repStatCode=="�����"){
		var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.arExaReqCode +'</h3><h4 style="float:left;padding-left:10px;background-color:transparent;">'+ rowData.arReqData+'</h4><h3 style="float:right;color:'+ FontColor +';background-color:transparent;"><span>'+ rowData.CreateDocDesc +'</span></h3><br>';	
	}else{
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.arExaReqCode +'</h3><h4 style="float:left;padding-left:10px;background-color:transparent;">'+ rowData.arReqData+'</h4><h3 style="float:right;color:'+ FontColor +';background-color:transparent;"><span>'+ rowData.repStatCode +'</span></h3><br>';
	
	}	/*
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.arReqData +'</h4>';
		
		if (rowData.repStatCode != "ֹͣ"){
		    htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px"><a href="#" onclick="showItmDetWin('+rowData.arRepID+')">ԤԼ</a>&nbsp;&nbsp;&nbsp;<a href="#" onclick="showItmRetWin('+rowData.Oeori+')">���</a></span></h4>';
		}
		*/
		/// ѭ����ּ����Ŀ
		var TempList = rowData.arcListData;
		var TempArr = TempList.split("#");
		for (var k=0; k < TempArr.length; k++){
			var TempCArr = TempArr[k].split("&&");
			var TempCText=""; /// ��Ŀȫ��
			if (!TempCArr[1]) continue
			if (TempCArr[1].length > 7){
				TempCText = TempCArr[1];					   /// �����Ŀȫ�� ������ʾ
				TempCArr[1]=TempCArr[1].substring(0,6)+"...";  /// �����Ŀ����ʾ7���ַ�
			}
			var FontColor = "";
/* 			if (TempCArr[2] == "IM"){ 
				FontColor="#FF69B4";    /// �����Ŀ�б��淵��,��ʾ��ɫ����
			} */

			htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px;color:'+FontColor+'" name="'+TempCText+'">'+ TempCArr[1] +'</span></h4>';
			htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;padding-right: 10px;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px" name="1">';
			/// �Ƿ���ҪԤԼ
			if (TempCArr[3] == "Y"){
				htmlstr = htmlstr + '<a href="#" onclick="showItmDetWin('+rowData.arRepID+')"><img src="../scripts/dhcnewpro/images/app.png"></a>';
			}
			if (TempCArr[2] == "IM"){ 
				htmlstr = htmlstr + '&nbsp;&nbsp;&nbsp;<a href="#" onclick="showItmRetWin(\''+TempCArr[0]+'\',\''+rowData.TraType+'\')"><img src="../scripts/dhcnewpro/images/result.png"></a>';
				
			}
			htmlstr = htmlstr + '</span></h4><br>';
		}
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// �����Ŀ����ʾ��
function BindTips(){
	
	var html='<div id="tip" style="border-radius:3px; display:none; border:1px solid #000; padding:10px;position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	/// ����뿪
	$('.celllabel h4 span').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('.celllabel h4 span').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			if ($(this).attr("name").length <= 7){  //.text()
				return;
			}
			/// tip ��ʾ��λ�ú������趨
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.7
			}).text($(this).attr("name"));    // .text()
		}
	})
}

/// ��ѡ��
function SetCellCheckBox(value, rowData, rowIndex){

	var html = '<input name="ItmCheckBox" type="checkbox" value='+rowIndex+'></input>';
    return html;
}

/// ��ʼ����鲿λ��
function initCheckPartTree(){

	var url = ""; //$URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	       
	        var isLeaf = $("#CheckPart").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        var itemCatID = node.id;         /// ������ID
		        var itemCatCode = node.code;     /// ���������
				//LoadCheckItemList(itemCatID);  /// ���ؼ�鷽���б�
			    var nodeType = GetNodeType(itemCatID);
		        if (nodeType != mMainSrc){
			    	switchMainSrc(nodeType, itemCatID, "", "", itemCatCode);
			    }else{
					frames[0].LoadCheckItemList(itemCatID);
				}
	        }else{
		       	var itemCatID = node.id;         /// ������ID
		        var itemCatCode = node.code;     /// ���������
		        var nodeType = GetNodeType(itemCatID);
		        if ((nodeType != mMainSrc)&(nodeType != "P")){
		        	switchMainSrc(nodeType, itemCatID, "", "", itemCatCode);
		        }
		    	$("#CheckPart").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    }
	    },
	    onExpand:function(node, checked){
		 
			var childNode = $("#CheckPart").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
	        var isLeaf = $("#CheckPart").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        var itemCatID = node.id;         /// ������ID
		        var itemCatCode = node.code;     /// ���������
		        var nodeType = GetNodeType(itemCatID);
		        if (nodeType == "P") return;
		        if (nodeType != mMainSrc){
		        	switchMainSrc(nodeType, itemCatID, "", "", itemCatCode);
		        }else{
					frames[0].LoadCheckItemList(itemCatID);  /// ���ؼ�鷽���б�
		        }
	        }
		}
	};
	new CusTreeUX("CheckPart", '', option).Init();
}

/// ҳ��Combobox��ʼ����
function initCombobox(){

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";

	/// ������
	var option = {
        onSelect:function(option){

	        var arItemCatID = option.value; /// ������ID
			
	        var repStatusID = $("#repStatus").combobox('getValue'); /// ����״̬
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var tmpEpisodeID = $('#AdmHis').combogrid('getValue');  /// ����ID
	        if ((typeof tmpEpisodeID == "undefined")||(tmpEpisodeID=="")){
		    	tmpEpisodeID = EpisodeID;   
		    }
			var params = tmpEpisodeID +"^"+ arItemCatID +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue != ""){
		    	return;
		    }
		    var repStatusID = $("#repStatus").combobox('getValue'); /// ����״̬
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var tmpEpisodeID = $('#AdmHis').combogrid('getValue');  /// ����ID
	        if ((typeof tmpEpisodeID == "undefined")||(tmpEpisodeID=="")){
		    	tmpEpisodeID = EpisodeID;   
		    }
			var params = tmpEpisodeID +"^"+ "" +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    }
	};
	var url = uniturl+"jsonExaCat&HospID="+LgHospID;
	new ListCombobox("itemCatID",url,'',option).init();
	
	/// ����״̬
	var option = {
		panelHeight:"auto",
        onSelect:function(option){

	        var repStatusID = option.value; /// ����״̬Code
			var itemCatID = $("#itemCatID").combobox('getValue'); /// ������ID
			if (typeof itemCatID == "undefined"){
		    	itemCatID = "";
		    }
			var tmpEpisodeID = $('#AdmHis').combogrid('getValue');
			if ((typeof tmpEpisodeID == "undefined")||(tmpEpisodeID=="")){
		    	tmpEpisodeID = EpisodeID;
		    }
	        /// ��鷽��
			var params = tmpEpisodeID +"^"+ itemCatID +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue != ""){
		    	return;
		    }
			var itemCatID = $("#itemCatID").combobox('getValue'); /// ������ID
			if (typeof itemCatID == "undefined"){
		    	itemCatID = "";
		    }
			var tmpEpisodeID = $('#AdmHis').combogrid('getValue');
			if ((typeof  tmpEpisodeID == "undefined")||(tmpEpisodeID=="")){
		    	tmpEpisodeID = EpisodeID;
		    }
	        /// ��鷽��
			var params = tmpEpisodeID +"^"+ itemCatID +"^"+ "" +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    }
	};
	new ListCombobox("repStatus",'',repStatusArr,option).init();
	if (PracticeFlag==1){
		 $HUI.combobox("#repStatus").setValue("I"); 
		}
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	///  ƴ����
	$("#ExaItmCode").bind("keypress",findExaItemList);
	
	///  ƴ����
	$("#ExaCatCode").bind("keyup",findExaItmTree);

	/// �ѱ������¼�
	//$("#billTyp").bind("click",BillTypeEvt);
	$("#billTyp.kw-section-list>li").click(function(){
		var LeaveFlag=true;
		if (LeaveFlag){	
			var btnObj = $(this);
			$("#billTyp.kw-section-list>li").removeClass('selected');
			btnObj.addClass('selected');
			BillTypeID =  this.id;       /// �ѱ�ID 
			BillType = $(this).text();   /// �ѱ�
			InitInsurFlag(BillTypeID)
			
		}else{
		}				
	});	
}

/// �ѱ������¼�
function BillTypeEvt(){
	
	$("#"+this.id).addClass("item-li-select").siblings().removeClass("item-li-select");
	BillTypeID =  this.id;       /// �ѱ�ID 
	BillType = $(this).text();   /// �ѱ�
	InitInsurFlag(BillTypeID)
	
}

/// ��ʼ��������ʷ�����¼
function initCombogrid(){
	
	var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPatAdmHisList&EpisodeID='+EpisodeID+"&HospId="+LgHospID;
	
	///  ����columns
	var columns=[[
		{field:'EpisodeID',title:'EpisodeID',width:100},
		{field:'itmLabel',title:'��������',width:100,hidden:true},
		{field:'AdmDate',title:'��������',width:100},
		{field:'AdmLoc',title:'���տ���',width:100},
		{field:'AdmDoc',title:'ҽ��',width:100},
		{field:'PatDiag',title:'���',width:300}
	]];
	
	$('#AdmHis').combogrid({
		url:url,
		editable:false,    
	    panelWidth:550,
	    idField:'EpisodeID',
	    textField:'itmLabel',
	    columns:columns,
	    pagination:true,
        onSelect: function (rowIndex, rowData) {
	        
	        var repStatusID = $("#repStatus").combobox('getValue'); /// ����״̬
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var itemCatID = $("#itemCatID").combobox('getValue');   /// ������ID
	        if (typeof itemCatID == "undefined"){
		    	itemCatID = "";
		    }
	        /// ��鷽��
			var params = rowData.EpisodeID +"^"+ itemCatID +"^"+ repStatusID +"^"+ LgHospID;
            $("#dgEmPatList").datagrid("reload",{"params":params});   /// ˢ��ҳ������
            
            /// �л������¼ʱ,ͬʱˢ�����뵥������
            switchMainSrc("E","","","","");
            ShowSecondeWin("onOpenDHCEMRbrowse");
        }
	});
}

/// ��ѯ�����Ŀ
function findExaItemList(event){
	
	if(event.keyCode == "13"){
		var ExaItmCode=$.trim($("#ExaItmCode").val());
		var PyCode=$.trim($("#ExaCatCode").val());	
		var node = $("#CheckPart").tree('getSelected');	
		var isLeaf = $("CheckPart").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�		
	    if (isLeaf){
	        var params = node.id +"^"+ "" +"^"+ ExaItmCode;
			$("#ItemList").datagrid("load",{"params":params});
        }
	}
}

/// ���Ҽ����Ŀ��
function findExaItmTree(event){
	
	var PyCode=$.trim($("#ExaCatCode").val());	
	if ((PyCode=="")&&(event)) {PyCode=event}
	if ((PyCode == "")&&(PyType == "")){
		<!-- �¾ɰ汾�������� -->
	    if (version != 1){
			/// �ɰ�
			if (expFlag==1) {
				//TODO
				var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatOld&HospID='+LgHospID;
			}else{
				var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+LgHospID+'&PyType='+PyType;
			}
		}else{
			/// �°�
			if (expFlag==1) {
				var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID+"&LocID="+LgCtLocID;
			}else{
				var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+LgHospID+'&PyType='+PyType+"&LocID="+LgCtLocID;;
			}
		}
	}else{			
		//$(".treetype li").removeClass('active');					//��������ʱ����ݰ�ťʧЧ qunianpeng 2018/2/1
		//PyType = ""; 				
		<!-- �¾ɰ汾�������� -->
	    if (version != 1){
		    /// �ɰ�
			var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCode&PyCode='+PyCode+'&HospID='+LgHospID+'&PyType='+PyType+"&LocID="+LgCtLocID;;
		}else{
			/// �°�
			var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCodeNew&PyCode='+PyCode+'&HospID='+LgHospID+'&PyType='+PyType+"&LocID="+LgCtLocID;;
		}
	}
	
	$('#CheckPart').tree('options').url =encodeURI(url);
	$('#CheckPart').tree('reload');
}

/// ��֤�����Ƿ�����ҽ��
function initPatNotTakOrdMsg(){
	
	var TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg,"warning");
		return;	
	}
}

/// ��֤�����Ƿ�����ҽ��
function GetPatNotTakOrdMsg(){
	var NotTakOrdMsg = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID,"EmConsultItm":EmConsultItm},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

/// �л�����
function switchMainSrc(TypeFlag, itemCatID, arRepID, repEmgFlag, itemCatCode){
	
	var LinkUrl = "";
	if (TypeFlag == "E"){
		LinkUrl = "dhcapp.reportreq.csp?EpisodeID="+ EpisodeID +"&itemCatID="+itemCatID +"&repEmgFlag="+repEmgFlag+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;
		//����ҳ���window.onload ��mMainSrc ���и�ֵ����ֹ�������ε����������ڶ��ε��ҳ����ش���
		//mMainSrc = TypeFlag; /// ��ǰ��Դ����
	}else if (TypeFlag == "L"){
		LinkUrl = "dhcapp.labreportreq.csp?EpisodeID="+ EpisodeID +"&itemCatID="+itemCatID +"&repEmgFlag="+repEmgFlag+"&itemReqID="+arRepID+"&PatType="+PatType+"&EmConsultItm="+EmConsultItm;
		//mMainSrc = TypeFlag; /// ��ǰ��Դ����
		LinkUrl+='&NotBindLabFee='+NotBindLabFee;
	}else if (TypeFlag == "P"){
		/// ȡ�������ʹ���
		if (arRepID == ""){
			itemCatCode = GetPisTypeCode(itemCatID);
			if (itemCatCode == ""){
				$.messager.alert("��ʾ","ȡ�������ʹ������,����ԭ�򣺼������ҽ��δ���й�����");
				return;
			}
		}
		
		if (itemCatCode == "HPV"){
			LinkUrl = "dhcapp.pismaster.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "CYT"){
			LinkUrl = "dhcapp.piscytexn.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "MOL"){
			LinkUrl = "dhcapp.pismolecular.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "CON"){
			LinkUrl = "dhcapp.pisoutcourt.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "TCT"){
			LinkUrl = "dhcapp.piswontct.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "APY"){
			LinkUrl = "dhcapp.pisautopsy.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "LIV"){
			LinkUrl = "dhcapp.pislivcells.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}else{
			LinkUrl = "docapp.blmapshow.hui.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&MapCode="+itemCatCode+"&EmConsultItm="+EmConsultItm;	
		}
		mMainSrc = itemCatCode; /// ��ǰ��Դ����
	}
	if (LinkUrl != ""){
		if(typeof websys_writeMWToken=='function') LinkUrl=websys_writeMWToken(LinkUrl);
		$("#TabMain").attr("src", LinkUrl);
	}
}

/// ��ȡ�ڵ�����
function GetNodeType(ID){
	
	var nodeType = "";
	runClassMethod("web.DHCAPPExaReportQuery","GetNodeType",{"ID":ID},function(jsonString){
		nodeType = jsonString;
	},'',false)
	return nodeType;
}

/// ȡ����������ʹ���
function GetPisTypeCode(itemCatID){
	
	var PisTypeCode = "";
	runClassMethod("web.DHCAPPExaReportQuery","GetPisTypeCode",{"itemCatID":itemCatID},function(jsonString){
		PisTypeCode = jsonString;
	},'',false)
	return PisTypeCode;
}

/// ���¼��ز����б�
function reLoadEmPatList(){
	SendFlag = 1;   /// �Ƿ���
	$("#dgEmPatList").datagrid("reload");   /// ˢ��ҳ������
	if (CloseFlag == 1){
		websys_showModal('options').CallBackFunc(SendFlag);
	}
	if (parent.UpdateTabsTilte) {
		parent.UpdateTabsTilte();
	}
}

/// ���ú�����ˢ����������ݺͲ���
function InvMainFrame(){
	SendFlag = 1;   /// �Ƿ���
	$("#dgEmPatList").datagrid("reload");   /// ˢ��ҳ������
	if (CloseFlag == 1){
		websys_showModal('options').CallBackFunc(SendFlag);
	}
}

/// ��Ŀ��ϸ
function showItmDetWin(arRepID){
	
	showItmAppDetWin(arRepID);  /// ԤԼ���鴰��
}

/// �����
function showItmRetWin(Oeori, TraType){

	showItmAppRetWin(Oeori, TraType);        /// �����
}

/// ������־
function MoreInfo(){

	LogPopUpWin();
}

/// ������־����
function LogPopUpWin(){
	
	var option = {
		modal:true,
	    collapsible:false,
	    minimizable:false,
	    maximizable:false,
	    onBeforeClose:function(){
			$("#dmLogList").datagrid('loadData',{total:0,rows:[]}); /// ���datagrid
		}
	}
	/// ����ҽ�����б���
	new WindowUX("������־","PopUpWin", "900", "300" , option).Init();
	InitLogList();
}

/// ��ʼ��������־�б�
function InitLogList(){
	
	///  ����columns
	var columns=[[
		{field:'ItmID',title:'ItemID',width:80,hidden:true},
		{field:'ItmStatus',title:'״̬',width:100,align:"center"},
		{field:'ItmDate',title:'����',width:100,align:"center"},
		{field:'ItmTime',title:'ʱ��',width:100,align:"center"},
		{field:'ItmUser',title:'����Ա',width:100,align:"center"},
		{field:'ItmReason',title:'����/���벿λ��Ϣ',width:200}, //��ע
		{field:'ItemDesc',title:'ҽ������',width:200} 
	]];
	
	///  ����datagrid
	var option = {
		border : false,
		rownumbers : true,
		singleSelect : true,
		pagination: false
	};
	
	var ID = ""; var TraType = "";
	var rowData = $('#dgEmPatList').datagrid('getSelected');
	if (rowData){
		ID = rowData.arRepID;
		TraType = rowData.TraType;
	}

	var uniturl = $URL+"?ClassName=web.DHCAppPisMasterQuery&MethodName=GetAppLogList&AppID="+ID+"&TraType="+TraType;
	new ListComponent('dmLogList', columns, uniturl, option).Init();
}

/// ��ݰ�ťͨ�����ͼ�����  qunianpeng 2018/2/1
function treeTypeClick(){
	
	$("#Typelist.kw-section-list>li").removeClass("selected").filter("[data-type='E,L,P']").addClass("selected");
	$("#Typelist.kw-section-list>li").click(function(){
		var LeaveFlag=true;
		if (typeof(window.frames['TabMain'].onbeforeunload_handler) === 'function') {
			var UnSaveData=window.frames['TabMain'].onbeforeunload_handler();
			if (UnSaveData){
				LeaveFlag=dhcsys_confirm('��δ��������ݣ��Ƿ�ȷ���л���');
				LeaveSelect="Y";
			}
		}
		if (LeaveFlag){	
			var btnObj = $(this);
			$("#Typelist.kw-section-list>li").removeClass('selected');
			btnObj.addClass('selected');
			PyType = btnObj.data("type");		
			findExaItmTree(); 
			if (PyType=="E"){
				switchMainSrc("E","","","","");
			}else if (PyType=="L"){
				switchMainSrc("L","","","","");	
			}	
		}else{
			LeaveSelect="";
		}				
	});	
}

/// ������뵯����λ����
function OpenPartWin(arExaCatID,arExaItmID,GlobaPartID,EpisodeID){
	
	if($('#nPartWin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="nPartWin"></div>');

	/// ԤԼ���鴰��
	var option = {
		collapsible:true,
		border:true,
		closed:true,
		modal:true,
	    collapsible:false,
	    minimizable:false,
	    maximizable:false,
	    onBeforeClose:function(){
			frames[0].clrItmChkFlag();   	  ///  ȡ�������Ŀѡ��״̬
		}
	};
	if(!EpisodeID) EpisodeID="";
	var linkUrl = "dhcapp.appreppartwin.csp?itmmastid="+arExaItmID +"&arExaCatID="+ arExaCatID +"&InvFlag=1"+"&GlobaPartID="+GlobaPartID+"&EpisodeID="+EpisodeID;
	var iframe='<iframe scrolling="no" width=100% height=558px  frameborder="0" src="'+linkUrl+'"></iframe>';
	new WindowUX('������Ϣ', 'nPartWin', '1200', '600', option).Init();
	
	$("#nPartWin").html(iframe);
}

/// ������벿λ����ȷ���ص�����
function closeWin(){
	
	frames[0].closeWin();
	$("#nPartWin").window("close");
}

/// �����Ŀ����ѡ�б�
function InsItemSelList(rows, arExaDispID, arExaDispDesc){
	
	frames[0].InsItemSelList(rows, arExaDispID, arExaDispDesc);
	$("#nPartWin").window("close");
}

/// ���ÿ�ܽӿں�����������Ҫ���ýӿڣ���ҽ�����뵽�����С�
function InvEmrFrameFun(){

	if (PatType != "I"){
		runClassMethod("web.DHCOEOrdItem","GetOrderDataToEMR",{"EpisodeID":EpisodeID},function(string){
			if (string != ""){
				InvokeChartFun(string);
			}
		},'',false)
	}
}

/// ���ÿ�ܽӿں���
function InvokeChartFun(string){
	
	var TabName = "���ﲡ��";
	if (PatType == "E"){ TabName = "�ż��ﲡ����¼"; }
	var win1 = null;
	try{
		win1 = window.top.opener.frames['TRAK_main'];
	}catch(ex){
		win1 = window.top.opener.frames('TRAK_main');
	}
	if (!win1){
		//˫��¼��
		try{
			win1 = window.top.opener.top.frames["TRAK_main"];
		}catch(ex){
			win1 = window.top.opener.top.frames('TRAK_main');
		}
	}
	if(win1){
		win1.invokeChartFun(TabName,"updateEMRInstanceData","oeord",string);
	}
}

/// ������ϴ���
function DiagPopWin(){
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

/// ��ȡ���˵���ϼ�¼��
function GetMRDiagnoseCount(){

	var Count = 0;
	/// ����ҽ��վ���ж�
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}

/// ҽ�����Ա�/��������
function GetItmLimitMsg(arExaItmID){
	
	var LimitMsg = 0;
	var itmmastid = arExaItmID.replace("_","||");
	/// ҽ�����Ա�/��������
	runClassMethod("web.DHCAPPExaReport","GetItmLimitMsg",{"EpisodeID":EpisodeID, "itmmastid":itmmastid},function(jsonString){

		LimitMsg = jsonString;
	},'',false)
	
	return LimitMsg;
}
function InitChronicDiagLookUp(){
	if (PatType =="I") {
		$("#ChronicDiag").hide();
		return;
	}
	if ($("#ChronicDiag").length==0){return}
	$("#ChronicDiag").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
       		{field:'Desc',title:'����',width:130,sortable:true}
        	,{field:'Code',title:'����',hidden:true}
        	,{field:'Type',title:'����',width:80,sortable:true}
        ]],
        width:95,
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocQryOEOrder',QueryName: 'LookUpChronicDiag'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc,EpisodeID:EpisodeID});
	    }
	});
	$("#ChronicDiag").keyup(function(){
		if ($(this).val()==""){
			$(this).lookup("setValue","").lookup("setText","");
		}
	});
}
function GetChronicDiagCode(){
	if (PatType =="I") return "";
	var ChronicDiagCode="";
	if ($("#ChronicDiag").length>0){
		if ($("#ChronicDiag").lookup("getText")!=""){
			ChronicDiagCode=$("#ChronicDiag").lookup("getValue")
		}
	}
	if (typeof ChronicDiagCode=="undefined"){
		ChronicDiagCode="";
	}
	return ChronicDiagCode;
}
/// ==============================================����CA����ǩ��=============================================

/// CA����ǩ�� ��ȡ�û�list  bianshuai 2018-03-17 ������豸�����ֳ����в���
function GetList_pnp(){
	
	if (CAInit == 1){
		var strTemp =GetUserList();
		if (strTemp!="") IsCAWin=strTemp;
		else IsCAWin="";
	}
}

/// ����ǩ�� ���������
function TakeDigSign(mReqID, Type, UpdateObj){
	if (UpdateObj.caIsPass==1){
	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqOeori",{"mReqID":mReqID, "Type":Type},function(jsonString){

		if (jsonString != ""){
			//InsDigitalSign(jsonString, "A");  /// ��������ǩ��
			if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, jsonString, "A");
		}
	},'',false)
	}
}


/// ����ǩ�� ��������
function TakeDigSignRev(mReqID, Type,UpdateObj){
	if (UpdateObj.caIsPass==1){
	runClassMethod("web.DHCAPPExaReportQuery","GetRevOeori",{"mReqID":mReqID, "Type":Type},function(jsonString){

		if (jsonString != ""){
			if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, jsonString, "S");
		}
	},'',false)
	}
}


/// CA����ǩ����֤����
function InsDigitalSign(mOrditmData, XmlType){
	
    try {
        //1.����ǩ����֤
		var itmValData = ""; var itmHashData = ""; var itmSignData = "";
		var mOrditmArr = mOrditmData.split("^");
		for (var i=0; i < mOrditmArr.length; i++){
			/// ҽ����Ϣ��
			var itmsXml = GetOrdItemXml(mOrditmArr[i], XmlType);
			var itmXmlArr = itmsXml.split(String.fromCharCode(2));
			for (var j = 0; j < itmXmlArr.length; j++) {
				if (itmXmlArr[j] == "") continue;
				var itmXml = itmXmlArr[j].split(String.fromCharCode(1))[1];
                var itmOpType = itmXmlArr[j].split(String.fromCharCode(1))[0];
                var itmXmlHash = HashData(itmXml);
                /// ǩ����Hashֵ
                if (itmHashData == "") itmHashData = itmXmlHash;
                else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
                /// ǩ����
                var SignedData = SignedOrdData(itmXmlHash, ContainerName);
                if (itmSignData == "") itmSignData = SignedData;
                else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
                
                if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + mOrditmArr[i];
                else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + mOrditmArr[i];
			}
		}
		
        if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
        if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

        //��ȡ�ͻ���֤��
        var varCert = GetSignCert(ContainerName);
        var varCertCode = GetUniqueID(varCert);
        
        //3.����ǩ����Ϣ��¼
        if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
            var ret = InsBatchSign(itmValData, session['LOGON.USERID'], XmlType, itmHashData, varCertCode, itmSignData);
            if (ret != "0") $.messager.alert("����", "����ǩ��û�ɹ�");
        } else {
            $.messager.alert("����", "����ǩ������");
        }
    }catch(e){
	    $.messager.alert("����", e.message);
    }
}

/// ȡҽ����Ϣ��
function GetOrdItemXml(Oeori, XmlType){
	
	var OrdItemXml = "";
	runClassMethod("web.DHCDocSignVerify","GetOEORIItemXML",{"newOrdIdDR":Oeori, "OperationType":XmlType},function(jsonString){
		OrdItemXml = jsonString;
	},'',false)
	return OrdItemXml;
}

/// ����ǩ��
function InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData){
	
	var retFlag = "";
	runClassMethod("web.DHCDocSignVerify","InsertBatchSignRecord",{"CurrOrderItemStr":itmValData, "UserID":LgUserID, "OperationType":XmlType, "OrdItemsHashVal":itmHashData,
	    "MainSignCertCode":varCertCode, "MainSignValue":itmSignData, "ExpStr":""},function(jsonString){
		
		retFlag = jsonString;
	},'',false)
	return retFlag;
}

/// ����ǩ�����
function isTakeDigSign(){
	
    var caIsPass = 0;
    //var ContainerName = "";
    if (CAInit == 1){
        if (IsCAWin == "") {
            $.messager.alert("����", "���Ȳ���KEY");
            return false;
        }
        //�жϵ�ǰkey�Ƿ��ǵ�½ʱ���key
        var resultObj = dhcsys_getcacert();
        var result = resultObj.ContainerName;
        if ((result == "") || (result == "undefined") || (result == null)) {
            return false;
        }
        ContainerName = result;
        caIsPass = 1;
    }
    return true;
}
function GetIsPatDeadFlag(){
	IsPatDead=$.cm({
		ClassName:"web.DHCAppPisMasterQuery",
		MethodName:"isPatDeadFlag",
		dataType:"text",
		EpisodeID:EpisodeID
	},false);
	return;
}
/// ==============================================����CA����ǩ��=============================================

///�޸�ҽ����ʶĬ��ֵ ͳһ��һ����������
function InitInsurFlag(BillTypeID){
	runClassMethod("web.DHCDocOrderCommon","GetDefInsurFlag",{"BillType":BillTypeID, "PAAdmType":""},function(jsonString){
			if (jsonString=="1"){
				$HUI.checkbox("#InsurFlag").setValue(true)
			}else{
				$HUI.checkbox("#InsurFlag").setValue(false)
				}
		},'',false)	
	
}

/// չʾ�ڶ�����
function ShowSecondeWin(Flag){
    if (websys_getAppScreenIndex()==0){
	    var Obj={PatientID:PatientID,EpisodeID:EpisodeID,mradm:mradm};
	    if (Flag=="onOpenIPTab"){
		    //��Ϣ����
		}
		if (Flag=="onOpenDHCEMRbrowse"){
			var JsonStr=$.m({
				ClassName:"DHCDoc.Util.Base",
				MethodName:"GetMenuInfoByName",
				MenuCode:"DHC.Seconde.DHCEMRbrowse"
			},false)
			if (JsonStr=="{}") return false;
			var JsonObj=JSON.parse(JsonStr);
			$.extend(Obj,JsonObj);
		}
		websys_emit(Flag,Obj);
	}
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {

    if (CloseFlag == 1){
		window.returnValue = SendFlag;
	}
	//���������
    tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
}
window.onbeforeunload = onbeforeunload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })