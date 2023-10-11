//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2017-11-24
// ����:	   ���ﲡ���б�
//===========================================================================================
var Flag=0;
var PatientID = "";  /// ����ID
var EpisodeID = "";  /// ���˾���ID
var defaultCardTypeDr;  /// Ĭ�Ͽ�����
var m_CardNoLength = 0;
var m_CCMRowID = "" ;
var tabSelectFlag = 0;
var PatListType = "Per"; /// �����б�
var EmWardID = "";	     /// ���Ȳ���ID
var PatArrFlag = "N";
var Compted = "" ;
var DisHospPat = "";
var PatType = "E"; 
var LgCtLocID=session['LOGON.CTLOCID']; 
var LgUserID=session['LOGON.USERID']; 
var LgHospID=session['LOGON.HOSPID'];
var LgGroupID=session['LOGON.GROUPID'];
var LgParams = LgHospID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgUserID
var HOSOPEN = ""; //2023-03-07 �û����
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();
	
	/// ��ʼ������
	InitDateBox();
	
	/// ��ʼ��������
	///InitCombobox();
	
	/// ��ʼ�����ز����б�
	InitPatList();
	
	InitPatInfoPanel()
	 
	
	InitDomAndVal();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	DateFormat = "";
	runClassMethod("web.DHCEMInComUseMethod","GetParams",{Params:""},
		function (rtn){
			DateFormat = rtn;
		},"text",false
	)	
	
	//EpisodeID = getParam("EpisodeID");
	
	///�Ƿ�HOSOPEN 2023-03-07 �û����
	HOSOPEN = getParam("hosOpen");
	HOSWINDOWID = getParam("windowId");
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

function InitCombobox(){
	$HUI.combobox("#preDiag",{
		valueField:'id',
		textField:'text',
		data:[    {'id':'CP','text':'��ʹ����'},
				  {'id':'SC','text':'��������'},
				  {'id':'TR','text':'��������'}
			  ],
		onSelect:function(option){
	    }	
	})	
	
	
}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	
	//����ҽ��
	$HUI.combobox("#concDoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+LgCtLocID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
			
	    }	
	})
	
	
	/// �ǼǺ�/����/���� �س��¼�
	$("#TmpCondition").bind('keypress',TmpCon_KeyPress);
	
	/// ���� �س��¼�
	$("#EmCardNo").bind('keypress',EmCardNo_KeyPress);
	 
	$("#roomSeatCode").bind('keypress',SeatNo_KeyPress);
	
	/// tabs ѡ�
	$("#tabs").tabs({
		onSelect:function(title){
		   if (tabSelectFlag == 1){
		   	  LoadEmPatByLoc(title);
		   }
		}
	});
	
	/// �����ɫ
	$(".pf-sider ul li").bind('click',SetLabelColor);
	
	/// Ĭ�ϸ����ﲡ������ѡ��Ч��
	$("li:contains('"+$g("���ﻼ��")+"')").addClass("btn-gray"); //hxy 2018-09-17 ���� 2018-10-18 btn-success
	
	//�ű�  hxy 2018-06-22
	$HUI.combobox("#Care",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=getEmeNumInfo&hosp="+LgHospID+"&LocID="+LgCtLocID,
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	/// ��ȡ��ǰ���Һű𲢳�ʼ����ֵ hxy 2018-06-22
	///runClassMethod("web.DHCEMPatCheckLevQuery","jsonGetEmPatChkCare",{"LocID":LgCtLocID,"HospID":LgHospID},function(jsonString){
	///	var Arr = jsonString.split('"');
	///	
	///},'',false)
	
	/// ����
	$("#more").bind('click',MoreCondition);
	
}

function InitDomAndVal(){
	$('#PatList').datagrid('hideColumn','PAAdmBed');	///�����б��Ų�����ʾ
	$("#roomSeatCode").attr("disabled", true);
	$HUI.combobox("#concDoc").disable();
	return;
}
/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	
	///  ����columns
	var columns=[[
		{field:'ItmXH',title:'���',width:40,align:'center'},
		{field:'PAAdmBed',title:'����',width:80,align:'center'},
		{field:'PCLvArea',title:'����',width:60,align:'center',styler:setCellAreaLabel},
		//{field:'CareLevel',title:'������',width:70,align:'center',styler:setCellCareLevelLabel},
		//{field:'CareLevelUpOrDown',title:'����',width:45,align:'center',formatter:setCellCareLevelUpOrDown},
		{field:'PAAdmPriority',title:'��ǰ�ּ�',width:70,align:'center',formatter:setCellPAAdmPriority},
		{field:'PatLevel',title:'Ԥ��ּ�',width:70,align:'center',formatter:setCellLevLabel},
		{field:'LocSeqNo',title:'˳���',width:60,align:'center'},
		{field:'CalledDesc',title:'����״̬',width:70,align:'center'},
		{field:'PatName',title:'����',width:100,styler:patNameStyler},
		///{field:'PatName',title:'����',width:100,styler:patNameStyler,formatter:function(value, rowData, rowIndex){return "*"+rowData.PatName.substring(1,9);}},
		{field:'PatAge',title:'����',width:80,align:'center'},
		{field:'Arrived',title:'����',width:60,align:'center',formatter:setCellSymbol},
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'RegDoctor',title:'�ű�',width:120},
		{field:'PatSex',title:'�Ա�',width:80,align:'center'},
		//{field:'ItmUnObr',title:'����',width:100},
		//{field:'StrTime',title:'����ʱ��',width:120,align:'center'},
		{field:'PAAdmDate',title:'���ʱ��',width:150,align:'center',formatter:function(value, rowData, rowIndex){
			return rowData.PAAdmDate+"  "+rowData.PAAdmTime;
			}},
		{field:'PAAdmDepCodeDR',title:'�������',width:120},
		{field:'PAAdmDocCodeDR',title:'ҽ��',width:100},
		{field:'PCLvNurse',title:'���ﻤʿ',width:80},
		{field:'BillType',title:'��������',width:80,align:'center'},
		{field:'PatEmrUrl',title:'���Ӳ���',width:70,align:'center',formatter:setCellEmrUrl},
		//{field:'Called',title:'�к�',width:40,align:'center'},
		{field:'PatGreFlag',title:'��ɫͨ��',width:70,align:'center',formatter:setCellGreenLabel},
		///{field:'DisType',title:'����ɫͨ��',width:90,align:'center',formatter:setCellDisType},
		{field:'EmChkWaitYx',title:'��������',width:70,align:'center'},
		{field:'ItmUnObr',title:'ͼ��˵�',width:80,
			formatter: function(value,row,index){
				return reservedToHtml(value);
			}},
		
		{field:'Diagnosis',title:'���',width:100,align:'center'},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
		//{field:'WalkStatus',title:'״̬',width:60,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		headerCls:'panel-header-gray',
		rownumbers : false,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
	    },
		onLoadSuccess:function(data){
			///  ���÷�������
            if (typeof data.EmPatLevWait == "undefined"){return;}
            if(EmWardID==""){
        		$("#EmPatLevWait").text(data.EmPatLevWait);
				$("#EmPatLevUnWait").text(data.EmPatLevUnWait);
				$("#EmPatLevComp").text(data.EmPatLevComp);
            }
            // �ǼǺ�/���� ��ѯʱ �Զ���ת����ѯ�����˵��б�ҳǩ��FlagΪ1ʱ ��ѯ��FlagΪ0ʱ����ѯ��
            // �ǼǺ�/������Ϊ�գ����лس��¼����ߵ����ѯ��ťʱ�Զ���ת�����ҳǩʱ��������ת
            if((CROSSLISTSEARCH==1)&&($("#TmpCondition").val()!="")){
				if(Flag==1){
		            if((data.EmPatLevWait>0)&&(PatArrFlag!="N")){
						/// Ĭ�ϸ����ﲡ������ѡ��Ч��
			            $(".pf-sider ul li")[0].firstChild.onclick();
			            $(".pf-sider").find("li:eq(0)").addClass("btn-gray").siblings().removeClass("btn-gray"); //hxy 2018-10-18 ԭ��btn-success
			        }
			        if((data.EmPatLevUnWait>0)&&(PatArrFlag!="Y")){
			            $(".pf-sider ul li")[1].firstChild.onclick();
			            $(".pf-sider").find("li:eq(1)").addClass("btn-gray").siblings().removeClass("btn-gray"); //hxy 2018-10-18 ԭ��btn-success
			        }
			        if((data.EmPatLevComp>0)&&(Compted!="Y")){
			            $(".pf-sider ul li")[2].firstChild.onclick();
			            $(".pf-sider").find("li:eq(2)").addClass("btn-gray").siblings().removeClass("btn-gray"); //hxy 2018-10-18 ԭ��btn-success
			        }
			        Flag=0;
			 	}
	        }
			$("a:contains('"+$g("����")+"')").html($g("����")+"(" + data.EmPatLevCnt1 +")");
			$("a:contains('"+$g("����")+"')").html($g("����")+"(" + data.EmPatLevCnt2 +")"); //hxy 2020-02-21 st
			$("a:contains('"+$g("����")+"')").html($g("����")+"(" + data.EmPatLevCnt3 +")"); //ԭ��EmPatLevCnt2
			$("a:contains('"+$g("����")+"')").html($g("����")+"(" + data.EmPatLevCnt4 +")"); //ԭ��EmPatLevCnt3 ed 
			setObsPatNumInfo(data.ObsPatInfo);   /// ����������������Ϣ
			$("#EmPatLevLeaveHosp").text(data.EmPatDisHosp);	///������Ժ����
			tabSelectFlag = 1;
		},
		rowStyler:function(index,rowData){   
			if(rowData.Called==1){
				//return "background-color:#53868B";  //��ʱ������ɫ
			}
	    },
	    rowStyler:function(index,rowData){  
			if ((rowData.CalledDesc.indexOf($g("���ڽк�"))>-1)){   //hxy 2020-03-09 st
	            return 'background-color:#B8E5AA;';  // #4b991b //029c87 //018674
	        }//ed 	  
	    },
	    onDblClickRow: function (rowIndex, rowData) {
		    sendMessage(rowData); //�û���� 2023-03-07 st
		    ///hos�����Ļ����б�,����ѡ���رմ���
		    ///HOSOPEN?hosCloseWindow(HOSWINDOWID):'';
		    
		    if(HOSOPEN){
			    if(window.opener){
				   var nowUrl = window.opener.location.href;
				   window.opener.location.href = changeURLArgs(nowUrl,{EpisodeID:rowData.EpisodeID,PatientID:rowData.PatientID});
				}
				window.close();
			} //ed
			
			if(window.parent.frames && window.parent.frames.switchPatient){
				//˫��ѡ���б༭
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
	
	/// ��ʼ����
	var StartDate = $HUI.datebox("#StartDate").getValue();
	/// ��������
	var EndDate = $HUI.datebox("#EndDate").getValue();

	var param = "^^^"+ PatType +"^^"+StartDate+"^"+EndDate+"^"+ PatArrFlag +"^^^^^"+LgCtLocID +"^"+ LgUserID +"^^^^^"+ 
		PatListType+"^^^^^^^^"+LgHospID;
		
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=JSonQryEmDocMainPatList&params="+param;
	new ListComponent('PatList', columns, uniturl, option).Init();
	$('#PatList').datagrid('hideColumn','PAAdmBed');	///�����б��Ų�����ʾ
}

/// ����·������ bianshuai 2018-07-18
function setCellDisType(value, rowData, rowIndex){
	var style=""; //hxy 2019-11-22 st
	if(rowData.EmCenterIfEnd=="1"){style="style='color:gray'"} //ed
	var htmlstr = "";
	if ((value == "CP")||(value == "SC")||(value == "TR")) {
		if (value == "CP") {
			value = "��ʹ";
		}
		if (value == "SC") {
			value = "����";
		}
		if (value == "TR") {
			value = "����";
		}
		htmlstr = '<a href="javascript:void(0);" '+style+' onclick="OpenDisTypeWin(\''+ rowData.EpisodeID +'\',\''+ rowData.DisType +'\')">'+ value +'</a>';
	}
	return htmlstr;
}
/// �򿪲���·��ҳ��
function OpenDisTypeWin(EpisodeID, DisType){
	
	var Link = "";
	if (DisType == "CP"){
		Link = "dhcemc.chestdiseasestation.csp?EpisodeID="+ EpisodeID +"&PosNode=ChestEmergency";
	}
	if (DisType == "SC"){
		Link = "dhcemc.strokecenter.csp?EpisodeID="+ EpisodeID +"&PosNode=StrokeEMWithinHosp";
	}
	if (DisType == "TR"){
		Link = "dhcemc.traumacenter.csp?EpisodeID="+ EpisodeID +"&PosNode=dhcemc.patchecklev.csp";
	}
	if ('undefined'!==typeof websys_getMWToken){
      Link += "&MWToken="+websys_getMWToken()
    }
	// window.parent.frames.window.location.href = Link ;
	window.open(Link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

function sendMessage(rowData) {
    //  ������Ҫ���͸��Ż������ݶ���
    //  type: 'postFromProd'    �̶�ֵ���ش���
    //  message���������Ҫ���ݵĻ�������
    var obj = {
        type: 'postFromProd',
        messageList: 
        [
            {
                key: 'EpisodeID',
                value: rowData.EpisodeID
            },{
                key: 'PatientID',
                value: rowData.PatientID
            }
        ]
    }
    
    var _w = HOSOPEN?window.opener.top:window.top;
    _w.postMessage(obj, "*")
  }

function setObsPatNumInfo(data){
	$(".wardclass").find("span").text("0");/// 2022-09-30 ��̬���ز������������� ��ֵǰ����0
	var infoArr = data.split("^");
	for(var i=0;i<infoArr.length;i++){
		var itmInfo = infoArr[i];
		$(".pf-sider li[name='"+itmInfo.split(":")[0]+"']").find("span").text(itmInfo.split(":")[1]);
	}
	return ;
}

/// ����ͼ��˵�
function reservedToHtml(str){
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

/// �ּ�
function setCellLevLabel(value, rowData, rowIndex){
	var fontColor = "";
	/*if ((value == "1��")||(value == "2��")){ fontColor = "#F16E57";} //hxy 2020-02-21 st
	if (value == "3��"){ fontColor = "#FFB746";}
	if (value == "4��"){ fontColor = "#2AB66A";}*/
	if (value == $g("1��")){ fontColor = "#F16E57";}
	if (value == $g("2��")){ fontColor = "orange";}
	if (value == $g("3��")){ fontColor = "#FFB746";}
	if ((value == $g("4��"))||(value == $g("5��"))){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>"; //hxy 2020-02-21
}

function patNameStyler(value, rowData, rowIndex){

	if(rowData.WalkStatus=="����"){
		return "color:blue";
	}
	return ""
}

function setCellPAAdmPriority(value, rowData, rowIndex){
	var fontColor = "";
	if (value == $g("1��")){ fontColor = "#F16E57";}
	if (value == $g("2��")){ fontColor = "orange";}
	if (value == $g("3��")){ fontColor = "#FFB746";}
	if ((value == $g("4��"))||(value == $g("5��"))){ fontColor = "#2AB66A";}
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>";	//hxy 2020-02-21
}

/// ���Ӳ���
function setCellEmrUrl(value, rowData, rowIndex){

	return "<a href='#' onclick='OpenPatEmr("+rowData.PatientID +","+rowData.EpisodeID +","+rowData.mradm +")'>"+$g("�鿴")+"</a>";
}

/// �����鿴
function OpenPatEmr(PatientID, EpisodeID, mradm){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼�����ԣ�","warning");
		return;
	}
	/// �ɰ没��
	/// window.open("emr.record.browse.patient.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	
	/// �°没��
	var link="websys.chartbook.hisui.csp?";
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken()
	}
	link += "&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ��ɫͨ��
/// zhouxin 2018-07-18
function setCellGreenLabel(value, rowData, rowIndex){
	//var fontColor = "";
	//if (value == "��"){ fontColor = "#2AB66A"; }
	//return "<font color='" + fontColor + "'>"+value+"</font>";
	var html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.EpisodeID+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
	if (value == "��"){ html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.EpisodeID+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"/></a>'; }
	return html;
}
function showGreenRec(adm){
	var option = {
		minimizable:false,
		iconCls:'icon-w-paper',
		onClose:function(){QryEmPatList()}
	}
	new WindowUX("��ɫͨ��","PatLabWin", 700, 420 , option).Init();
	
	var LinkUrl ='dhcem.green.rec.csp?EpisodeID='+adm;
	if ('undefined'!==typeof websys_getMWToken){
		LinkUrl += "&MWToken="+websys_getMWToken()
	}
	var content = '<iframe class="page-iframe" src="'+ LinkUrl +'" frameborder="no" border="no" height="98%" width="100%" scrolling="no"></iframe>';
	$("#PatLabWin").html(content);
	return;		
}
/// ȥ��
function setCellAreaLabel(value, row, index){
	if (value == $g("����")){
		return 'background-color:#F16E57;color:white';
	}else if (value == $g("����")){ //hxy 2020-02-21 st
		return 'background-color:orange;color:white'; //ed
	}else if (value == $g("����")){
		return 'background-color:#FFB746;color:white';
	}else if (value == $g("����")){
		return 'background-color:#2AB66A;color:white';
	}else{
		return '';
	}
}

/// ������
function setCellCareLevelLabel(value, row, index){
	if (value == $g("�ؼ�")){
		return 'background-color:red;color:black';
	}else if (value == $g("һ��")){
		return 'background-color:#FD99CB;color:black';
	}else if (value == $g("����")){
		return 'background-color:#02B0EF;color:black';
	}else if (value == $g("����")){
		return 'color:black';
	}else{
		return '';
	}
}

/// ������
function setCellCareLevelUpOrDown(value, row, index){
	if (value == "1"){
		return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/up.png'/>";
	}else if (value == "-1"){
		return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/down.png'/>";
	}else{
		return '';
	}
}

/// ��ȡ������Ϣ
function GetEmRegPatInfo(){
	
	runClassMethod("web.DHCEMDocMainOutPat","GetEmRegPatInfo",{"EpisodeID": EpisodeID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			InitPatInfoPanel(rowData);
		}
	},'json',false)
}

/// ����
function CallPatientOLD(){
	
	///���ýкŹ�˾��webervice���к���
	runClassMethod("web.DHCDocOutPatientList","SendCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
			if(retArr[0]=="0"){
				search("");  /// ��ѯ�����б�
				return;
			}
		}
	},'',false)
}

/// �ظ�����
function reCallPatientOLD(){

	///���ýкŹ�˾��webervice�����ظ�����
	runClassMethod("web.DHCDocOutPatientList","SendReCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
		}
	},'',false)
}



/// �ǼǺ�/����/���� �س��¼�
function TmpCon_KeyPress(e){

	if(e.keyCode == 13){
		var TmpCondition = $("#TmpCondition").val();
		if (!TmpCondition.replace(/[\d]/gi,"")&(TmpCondition != "")){
			///  �ǼǺŲ�0
			TmpCondition = GetWholePatNo(TmpCondition);
			$("#TmpCondition").val(TmpCondition);
			Flag=1;
		}
		QryEmPatList();  /// ��ѯ
	}
}

/// ��ѯ
function QryEmPatList(){
	
	/// ��ʼ����
	var StartDate = $HUI.datebox("#StartDate").getValue();
	/// ��������
	var EndDate = $HUI.datebox("#EndDate").getValue();
	
	/// �������
	var TypeCode="";
	if(arguments.length!=0){
		if(arguments[0]!=1){
			TypeCode=arguments[0];
		}
		// Ϊ�˿��� �ǼǺ�/������ѯʱ���Ƿ��Զ���ת���д˲��˵��б�ҳǩ
		if(arguments[0]==1){
			Flag=1;
		}
	}
	/// ȫ����
	var AllWard="";
	if(TypeCode=="ȫ����"){
		AllWard="Y";
		TypeCode="";
	}
	
	/// ����
	var CardNo = $("#EmCardNo").val();
	var TmpCondition = $("#TmpCondition").val();
    var CareDesc=$("#Care").combobox("getText");
    var ConcDoc= $("#concDoc").combobox("getValue");
    var SeatNo = $("#roomSeatCode").val();
    ///var preDiag=$("#preDiag").combobox("getValue");
    
	var params = "^^^"+ PatType +"^"+ CardNo +"^"+ StartDate +"^"+ EndDate ;
	params=params+"^"+ PatArrFlag +"^^^^^"+LgCtLocID +"^"+ LgUserID +"^^"+ TmpCondition ;
	params=params+"^"+ "" +"^"+TypeCode+"^"+ PatListType +"^"+ EmWardID+"^^"+ CareDesc;
	params=params+"^"+ ConcDoc + "^" + SeatNo +"^"+ Compted +"^"+ DisHospPat +"^"+ LgHospID+"^"+AllWard;
	///params=params+"^"+ ConcDoc + "^" + SeatNo +"^"+ Compted +"^"+ DisHospPat +"^"+ LgHospID+"^"+AllWard+"^"+preDiag;
	$("#PatList").datagrid("load",{"params":params}); 
}
/// ���� ��
function ReadCard() {
	DHCACC_GetAccInfo7(ReadCardCallback);
}
/// ����
function ReadCardCallback(rtnValue){
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case '0':
		$("#EmCardNo").val(myAry[1]);
		patientId = myAry[4];
		break;
	case '-200':
		$.messager.alert("��ʾ", "����Ч", "info", function() {
			$("#EmCardNo").focus();
		});
		break;
	case '-201':
		$("#EmCardNo").val(myAry[1]);
		patientId = myAry[4];
		break;
	default:
	}
	if (patientId != "") {
		QryEmPatList();
	}
}

function M1Card_InitPassWord(){
	
	try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
    }catch(e){}
}

/// ���ز����б�
function LoadEmPatByCurType(TypeCode){
	
	PatArrFlag = "N";
	Compted="N";
	if(TypeCode == "C"){		///��ɻ��ߵ�ͬ���ﻼ�ߴ���Compted����ʶ�Ƿ���ɾ���
		TypeCode = "H" ;
		Compted = "Y" ;	
	}
	if (TypeCode == "D"){ PatArrFlag = "N"; }  /// ���ﲡ��
	if (TypeCode == "H"){ PatArrFlag = "Y"; } 
	
	
	EmWardID = parseInt(TypeCode)==TypeCode?TypeCode:"";	///����ID
	DisHospPat = TypeCode=="B"?"Y":"";						///��Ժ����
	if(EmWardID){
		$("#AllWard").css("display","inline");
	}else{
		$("#AllWard").css("display","none");
	}
		
	if ((TypeCode != "D")&(TypeCode != "H")){
		$('#PatPanel').layout('hidden','north');
		$('#histb').css("margin-top","0px");
		$('#bt_call').hide();    /// �к�
		$('#bt_recall').hide();  /// �ظ��к�
		$('#bt_cross').hide();   /// ����
		$('#bt_endadm').hide();   /// ��ɾ���
		$('#bt_calsel').hide();   /// ѡ�����
		$('#bt_outcall').hide();  /// ��������
		$HUI.datebox("#StartDate").disable();
		$HUI.datebox("#EndDate").disable();
		$("#TmpCondition").attr("disabled", true);
		$("#EmCardNo").attr("disabled", true);
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
		$('#histb').css("margin-top","-4px");
		$('#bt_call').show();    /// �к�
		$('#bt_recall').show();  /// �ظ��к�
		$('#bt_cross').show();   /// ����
		$('#bt_calsel').show();   /// ѡ�����
		$('#bt_outcall').show();  /// ��������
		$HUI.datebox("#StartDate").enable();
		$HUI.datebox("#EndDate").enable();
		if($HUI.datebox("#StartDate").getValue()==""){
			InitDateBox();      ///��ʼ��Ĭ��ʱ��
		}
		$("#TmpCondition").attr("disabled", false);
		$("#EmCardNo").attr("disabled", false);
		$HUI.linkbutton("#ReadCard").enable();
		$("#roomSeatCode").attr("disabled", true);
		$HUI.combobox("#concDoc").disable();
		$HUI.combobox("#concDoc").setValue("");
		$("#roomSeatCode").val("");
		$(".more-obs").show();
		if (TypeCode == "H"){
			$('#bt_call').hide();    /// �к�
			$('#bt_recall').hide();  /// �ظ��к�
			$('#bt_cross').hide();   /// ����
			$('#bt_calsel').hide();   /// ѡ�����
			$('#bt_outcall').hide();  /// ��������
			Compted!="Y"?$('#bt_endadm').show():$('#bt_endadm').hide();   /// ��ɾ���
		}else{
			$('#bt_endadm').show();   /// ��ɾ���
		}
		$('#PatList').datagrid('hideColumn','PAAdmBed');
		$('#PatList').datagrid('showColumn','CalledDesc');
	}
	var CareDesc=$("#Care").combobox("getText");
		
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ��
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	//var params = "^^^"+ PatType +"^"+ CardNo +"^"+ StartDate +"^"+ EndDate +"^"+ PatArrFlag +"^^^^^"+LgCtLocID +"^"+
	//	LgUserID +"^^"+ TmpCondition +"^"+ StayInWard +"^^"+ PatListType +"^"+ EmWardID+"^^"+CareDesc+"^"+Compted;
	
	//$("#PatList").datagrid("load",{"params":params}); 
	
	QryEmPatList();
}

/// ���ز����б�
function LoadEmPatByLoc(title){
	
	if ($g(title) == $g("���˻���")){ //hxy 2018-09-17 ����
		PatListType = "Per";
	}else if ($g(title) == $g("�����һ���")){
		PatListType = "Loc";
	}else{
		PatListType = "Grp";
	}
	
	QryEmPatList();
	return;
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ��
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var params = "^^^"+ PatType +"^^"+ StartDate +"^"+ EndDate +"^"+ PatArrFlag +"^^^^^"+LgCtLocID +"^"+ LgUserID +"^^^^^"+ PatListType;
	$("#PatList").datagrid("load",{"params":params});
}

/// ��λ�Żس�
function SeatNo_KeyPress(e){
	if(e.keyCode == 13){
		QryEmPatList();	
	}
}

///  ���Żس�
function EmCardNo_KeyPress(e){
	if(e.keyCode == 13){
		var CardNo = $("#EmCardNo").val();
		if (CardNo == "") return;
		DHCACC_GetAccInfo("", CardNo, "", "", ReadCardCallback);
	}
}

//Desc:�л�����
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

///���ñ༭����
function setCellSymbol(value, rowData, rowIndex){
	
	return "<a href='#' onclick='PatArrived("+rowData.PatientID+","+rowData.EpisodeID+","+rowData.mradm+")'><img src='../scripts/dhcnewpro/images/update.gif' border=0/></a>";
}

/// ����
function PatArrived(PatientID,EpisodeID,mradm){

	///���ò���״̬
	runClassMethod("web.DHCEMDocMainOutPat","SetArrivedStatus",{"Adm":EpisodeID, "LocId":LgCtLocID,"UserId":LgUserID},function(jsonString){
		
		if (jsonString != "1"){
			$.messager.alert("��ʾ","����״̬����ʧ�ܣ�");
		}else{
			$("#PatList").datagrid("reload");  /// ˢ�²����б�
			if(window.parent.frames && window.parent.frames.switchPatient){
				//˫��ѡ���б༭
				window.parent.frames.switchPatient(PatientID,EpisodeID,mradm);
				window.parent.frames.hidePatListWin();
		    }
		}
	},'',false)
}

/// ���ñ�ǩ��ɫ
function SetLabelColor(){
	
	$(this).addClass("btn-gray").siblings().removeClass("btn-gray"); //hxy 2018-10-18 ԭ��btn-success
}

/// ����ȥ��
function TransPatToArea(TypeCode){
	QryEmPatList(TypeCode);
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
			$.messager.alert('������ʾ',"�ǼǺ��������");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;
}

/// �����ѯ����
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

/// =================================== ��������Ϊ��������кų��� ===========================================

///����
function CallPatient(){
	var IPAddress=GetComputerIp()
	var ret = tkMakeServerCall("web.DHCVISQueueManage","RunNextButtonNewProEm","","",IPAddress);
	$.messager.alert("��ʾ",ret.split("^")[1]);
	$("#PatList").datagrid("reload");  /// ˢ�²����б�	
	return;
}

/// �ظ��к�
function ReCallPatient(){
	var rowData=$("#PatList").datagrid('getRows');
	if(rowData.length == 0){
		$.messager.alert("��ʾ","�����б�Ϊ�գ��޷������ظ����У�");
		return;
	}
	var IPAddress=GetComputerIp();
	var ret=tkMakeServerCall("web.DHCVISQueueManage","RecallButtonNewProEm","","",IPAddress);
	$.messager.alert("��ʾ",ret.split("^")[1]);
	$("#PatList").datagrid("reload");  /// ˢ�²����б�	
	return;
}

/// ѡ�����
function CallSelPatient(){
	var CallNum=1;    ///����ǰ���е�����
	var IPAddress=GetComputerIp();
	var NowCallNum=0;     /// ��ǰ�кŸ���
	var rowData=$("#PatList").datagrid('getRows');
	var rowData = $("#PatList").datagrid('getSelected'); /// ����ѡ����
	var allRowData = $("#PatList").datagrid('getData').rows;
	if(!rowData){
		$.messager.alert("��ʾ","��ѡ�в��˺��ٽ��нкŲ�����");
		return;
	}
	
	var TmpEpisodeID = rowData.EpisodeID; /// ����ID
	for (var m=0; m<allRowData.length; m++){
		var EpisodeID = allRowData[m].EpisodeID;     /// ����ID
		var PAAdmDate = allRowData[m].PAAdmDate;     /// ��������
		if(TmpEpisodeID==EpisodeID) continue;
		if(allRowData[m].Called == "1"){
			NowCallNum = NowCallNum + 1;
		}
	}
	if(NowCallNum >= CallNum){
		$.messager.alert("��ʾ","���ȴ����Ѿ����л���!");
		return;
	}
	
	var PatName = rowData.PatName;    /// ����
	var LocSeqNo = rowData.LocSeqNo;  /// ˳���
	var ret = tkMakeServerCall("web.DHCVISQueueManage","FrontQueueInsertNewProEm",TmpEpisodeID,"","",IPAddress);
	$.messager.alert("��ʾ",ret.split("^")[1]);
	$("#PatList").datagrid("reload");  /// ˢ�²����б�
	return;	

	if (TmpEpisodeID != ""){  /// ���ú���״̬
		var ret=tkMakeServerCall("web.DHCEMDocMainOutPat","SetPatCallStatu",TmpEpisodeID,session["LOGON.USERID"]);
		if (ret==0){
			
		}
	}
}

/// ����
function OutCallQueue(){
	var rowData = $("#PatList").datagrid('getSelected');
	if (rowData){
		var PatName = rowData.PatName;    /// ����
		var LocSeqNo = rowData.LocSeqNo;  /// ˳���	
		if(rowData.Called == ""){
			$.messager.alert("��ʾ","û�к��еĲ��˲��ܹ��ţ�");
			return;
		}
		$.messager.confirm("�Ի���",$g("�ǼǺ�")+":"+rowData.PatNo+$g("����")+": "+PatName + $g("�Ƿ���Ҫ����")+"?",function(res){
			if (res){
				var EpisodeID = rowData.EpisodeID; /// ����ID
				
				runClassMethod("web.DHCEMDocMainOutPat","SetSkipStatus",{"Adm":EpisodeID,"LgUserID":LgUserID},function(jsonString){
					if (jsonString != 1){
						$.messager.alert("��ʾ","����ʧ�ܣ�ʧ��ԭ��:" + jsonString);
					}
					$("#PatList").datagrid("reload");  /// ˢ�²����б�	
				},'',false)
			}
		})
		
	}else{
		$.messager.alert("��ʾ","��ѡ�в��˺��ٽ��й��Ų�����");
		return;
	}
}

/// ��������
function OutCallQueueCP(){
	var rowData = $("#PatList").datagrid('getSelected');
	if(rowData==null){
		$.messager.alert("��ʾ","��ѡ�в��˺��ٽ��й������Ų�����");
		return;
	}
	if(rowData.CalledDesc.indexOf($g("����"))==-1){
		$.messager.alert("��ʾ","�ǹ��Ų��˲���ʹ�ù������Ź��ܣ�");
		return;
	}
	
	
	var EpisodeID = rowData.EpisodeID; 
	runClassMethod("web.DHCEMDocMainOutPat","PatPrior",{"EpisodeID":EpisodeID,"UserID":LgUserID},function(ret){
		if(ret==0){
			$.messager.alert("��ʾ","�������ųɹ���");
			$("#PatList").datagrid("reload");  /// ˢ�²����б�	
		}else{
			$.messager.alert("��ʾ","ʧ��!Code"+ret);
		}
	},'',false)
	return;
}

///�кŽ������õķ���
function findPatientTree(){
	
}

function Find_click(){
	
}

function SetFillToCall(EpisodeID){
	
	return;    /// �쵼˵���߲��ã�û��ָ��IP�����ļ�ʱ�Ῠס��������ʱע�ͣ�
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

/// ���ݿ���ȡ���˵Ŀ����Ͷ���
function GetPatCardType(CardNo){
	var CardTypeID = "";
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatCardType",{"CardNo":CardNo},function(jsonString){
		if (jsonString != null){
			CardTypeID = jsonString;
		}
	},'',false)
	return CardTypeID;
}

function ComplateAdm(){
	var rowData = $("#PatList").datagrid('getSelected');
	debugger;
	var Adm="";
	if (rowData){
		Adm = rowData.EpisodeID; /// ����ID
	}
	if(Adm==""){
		$.messager.alert("��ʾ","ѡ���߾����¼��");
		return;
	}
	$.m({
		ClassName:"web.DHCEMDocMainOutPat",
		MethodName:"SetComplate",
		Adm:Adm,
		LgParams:LgParams
	},function(rtn){
		var err = rtn.split("^")[0];
		if (err!="0"){
			$.messager.alert("��ʾ",rtn.split("^")[1]);
			return false;
		}else{
			$.messager.alert("��ʾ","����ɾ���!","info",function(){
				$("#PatList").datagrid("reload");  /// ˢ�²����б�		
			});
		}
	});	
}

//hxy 2020-02-21
function setCell(value){
	if(value==$g("1��")){value=$g("��");}
	if(value==$g("2��")){value=$g("��");}
	if(value==$g("3��")){value=$g("��");}
	if(value==$g("4��")){value=$g("��a��");}
	if(value==$g("5��")){value=$g("��b��");}
	return value;
}


/// =================================== ��������Ϊ��������кų��� ===========================================
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })



