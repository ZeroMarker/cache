//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-04
// ����:	   ���Ӳ������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var editSelRow = -1;    /// ��ǰ�༭��
var PisID = "";         /// ��������ID
var TakOrdMsg = "";
var pid = "";  			 /// Ψһ��ʶ
var mListDataDoc = "";   /// ҽ��վ�����������
var DocMainFlag = "";    /// ҽ��վ���浯����ʾ
var LgUserID = session['LOGON.USERID'];   /// �û�ID
var LgCtLocID = session['LOGON.CTLOCID']; /// ����ID
var LgGroupID = session['LOGON.GROUPID']; /// ��ȫ��ID
var LgHospID=session['LOGON.HOSPID'];
var asStaus="";

/// ҳ���ʼ������
function initPageDefault(){

	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	LoadTestItemList();       /// ����HPV���˲�������
	//LoadCheckItemList();      /// ���ز�������Ŀ
	LoadCutBaseList();        /// ����ȡ�ķ�������
	InitPageCheckBox();       /// ҳ��CheckBox����
	GetPatBaseInfo();         /// ���ز�����Ϣ
	LoadPatClinicalRec();	  /// �����ٴ�����
	GetIsWritePisFlag();      /// �Ƿ����д�ж�
	InitVersionMain();        /// ҳ���������
}

/// ҳ���������
function InitVersionMain(){
	
	/// ��������ʱ,�����������°�¼�����
	if (DocMainFlag == 1){
		$('#tPanel').panel({closed:true});        /// ���ء�������Ϣ��
		$('#mainPanel').layout("remove","south"); /// ���ء���ť����
		$('a:contains("ȡ������")').hide();
		$('a:contains("����")').hide();
		$('a:contains("��ӡ")').hide();
		LoadCheckItemListDoc();      /// ���ز�������Ŀ
		var PanelWidth = window.parent.frames.GetPanelWidth();
		/// ��塾������Ϣ����С���� 
		$('#mPanel').panel('resize',{width: PanelWidth ,height: 100});
		/// ��塾�ۺ���Ϣ����С����
		$('#cPanel').panel('resize',{width: PanelWidth ,height: 540});
	}else{
		LoadCheckItemList();         /// ���ز�������Ŀ
	}
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	PisID = getParam("itemReqID");  /// ���뵥ID
			
	/// ����Ϊҽ��վ�������� ����
	pid = getParam("pid");          /// Ψһ��ʶ
	mListDataDoc = getParam("ARCIMStr");
	if (mListDataDoc != ""){
		DocMainFlag = 1;
		var mParam = mListDataDoc.split("!")[0];
		if (mParam != ""){
			EpisodeID = mParam.split("^")[0];
		}
	}
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	/// ���տ���
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
		},
		onShowPanel:function(){
			var itmmastid = $("#TesItemID").val();
			if (itmmastid != ""){
				var OpenForAllHosp=0,LogLoc="";
				var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
				var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
				if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
				if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+itmmastid+"&OrderDepRowId="+LogLoc+"&OpenForAllHosp="+OpenForAllHosp;
				$("#recLoc").combobox('reload',unitUrl);
			}
		}
	}
	new ListCombobox("recLoc",'','',option).init();
	
	/// ��������Ŀѡ���¼�
	$("#itemList").on("click","[name='item']",TesItm_onClick);
	
	/// ������� 
	$('#ApplyLoc').combobox({	//������Һ�����ҽ������ѡ��(Ĭ�Ͼ���ҽ���Ϳ���) 2018/2/5 qunianpeng 
		mode:'remote',  
		onShowPanel:function(){
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&hospId="+LgHospID;
			$("#ApplyLoc").combobox('reload',unitUrl);
		},
		onSelect:function(){	//���ü��� ѡ����Һ󣬼��ؿ��Ե�¼�ÿ��ҵ�ҽ�� qunianpeng 2018/2/7
			$("#ApplyDocUser").combobox("setValue","");
			$("#ApplyDocUser").combobox('reload');
		}
	});
	
	/// ����ҽ��  
	$('#ApplyDocUser').combobox({
		//mode:'remote',  
		onShowPanel:function(){
			var appLocID=$('#ApplyLoc').combobox('getValue');
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+appLocID;
			$("#ApplyDocUser").combobox('reload',unitUrl);
		}
	});	
	
	/// ���水ť״̬
	$('a:contains("ȡ������")').linkbutton('disable');
	$('a:contains("ȡ������")').removeClass('btn-lightred');
	$('a:contains("����")').linkbutton('disable');
	$('a:contains("����")').removeClass('btn-lightgreen');
	$('a:contains("��ӡ")').linkbutton('disable');
}
/* ------ѡ�в�����Ŀ����ѡ�б�,֧��chrome start-------*/
function TesItm_onClick(e){
	if ($(this).is(':checked')){
		ChkBeforeSelectTesItm(e,selectTesItmData)
	}
}
function ChkBeforeSelectTesItm(e,ExcFunc){
	var CallBackFuncList=new Array();
	var CallBackRet=true;
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg);
		return;	
	}
	/// ��鷽����ҽ����ID��ҽ�������ơ�
	var TesItemID = e.target.id;    /// ��鷽��ID
	var TesItemDesc = $(e.target).parent().next().text(); /// ��鷽��
	var itmmastid = TesItemID.replace("_","||");
	/// ҽ�����Ա�/��������
	var LimitMsg = window.parent.frames.GetItmLimitMsg(itmmastid)
	if (LimitMsg != ""){
		$.messager.alert("��ʾ:","��Ŀ��" +TesItemDesc+ "��������ʹ�ã�" + LimitMsg);
		return;	
	}
	/// ����ж�
	if (window.parent.frames.GetMRDiagnoseCount() == 0){
		$.messager.alert("��ʾ:","����û�����,����¼�룡","",function(){
			CallBackFuncList.push(
				DiagPopWinNew(function(){
					if (window.parent.frames.GetMRDiagnoseCount()>0) {
						ExecCallBackFuncList();
					}else{
						$(e.target).attr("checked",false);
						return;
					}
				})
			);
			ExecCallBackFuncList();
		})
	}else{
		ExecCallBackFuncList();
	}
	function ExecCallBackFuncList(){
		if (CallBackFuncList.length==0) {
			if (CallBackRet==true) {
				ExcFunc(e);
			}
			return;
		}
		CallBackFuncList[0];
		CallBackFuncList.splice(0,1);
	}
}
function selectTesItmData(e){	
	/// ��鷽����ҽ����ID��ҽ�������ơ�
	var TesItemID = e.target.id;    /// ��鷽��ID
	var TesItemDesc = $(e.target).parent().next().text(); /// ��鷽��
	var itmmastid = TesItemID.replace("_","||");
	$("#TesItemID").val(itmmastid);
	$("#TesItemDesc").val(TesItemDesc);
	/// ���տ���
	var LocID = ""; var LocDesc = "";
	var OpenForAllHosp=0,LogLoc="";
	var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
	var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
	if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
	if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmastid,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			LocID = jsonObjArr[0].value;
			LocDesc = jsonObjArr[0].text;
		}
	},'json',false)

	$("#recLoc").combobox("setValue",LocID);
	$("#recLoc").combobox("setText",LocDesc);
}
function DiagPopWinNew(callback){
	var PatientID = $("#PatientID").text();  /// ����ID
	var mradm = $("#mradm").text();			 /// �������ID
	websys_showModal({
		url:"diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm,
		title:'���¼��',
		width:screen.availWidth-100,height:screen.availHeight-200,
		onClose:function(){
			window.parent.frames.GetPatBaseInfo();  ///  ���ز�����Ϣ
			if (callback) callback();
		}
	})
}
/* ------ѡ�в�����Ŀ����ѡ�б�,֧��chrome start-------*/
/// ѡ�м����Ŀ
/*function TesItm_onClick(){
	
	if ($(this).is(':checked')){
		
		if (TakOrdMsg != ""){
			$.messager.alert("��ʾ:",TakOrdMsg);
			return;	
		}
		
		/// ����ж�
		if (window.parent.frames.GetMRDiagnoseCount() == 0){
			$.messager.alert("��ʾ:","����û�����,����¼�룡","",function(){window.parent.frames.DiagPopWin()});
			$(this).attr("checked",false);
			return;	
		}
		
		/// ��鷽����ҽ����ID��ҽ�������ơ�
		var TesItemID = this.id;    /// ��鷽��ID
		var TesItemDesc = $(this).parent().next().text(); /// ��鷽��
		var itmmastid = TesItemID.replace("_","||");
		$("#TesItemID").val(itmmastid);
		$("#TesItemDesc").val(TesItemDesc);

		/// ҽ�����Ա�/��������
		var LimitMsg = window.parent.frames.GetItmLimitMsg(itmmastid)
		if (LimitMsg != ""){
			$.messager.alert("��ʾ:","��Ŀ��" +TesItemDesc+ "��������ʹ�ã�" + LimitMsg);
			return;	
		}
		
		/// ���տ���
		var LocID = ""; var LocDesc = "";
		var OpenForAllHosp=0,LogLoc="";
		var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
		var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
		if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
		if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmastid,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
			
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				LocID = jsonObjArr[0].value;
				LocDesc = jsonObjArr[0].text;
			}
		},'json',false)

		$("#recLoc").combobox("setValue",LocID);
		$("#recLoc").combobox("setText",LocDesc);
	}
}*/

/// ҳ��CheckBox����
function InitPageCheckBox(){
	
	$("input[name=CutBas]").click(function(){
		
		if($("[value='"+this.id+"'][name=CutBas]").is(':checked')){
			$("input[name=CutBas]:not([value='"+this.id+"'])").removeAttr("checked");
		}
	});
	
	/// �����Ŀ
	$("input[name=TestItem]").click(function(){
		
		if($("[value='"+this.id+"'][name=TestItem]").is(':checked')){
			$("input[name=TestItem]:not([value='"+this.id+"'])").removeAttr("checked");
		}
	});	
	
	///����ҽ���ѡ  sufan 2018-01-30
	var tempckid="";
	//$("#itemList input[type='checkbox'][name='item']").click(function(){
	$("#itemList").on("click","[name='item']",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("#itemList input[type='checkbox'][name="+this.name+"]").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					}
				})
			
			}else{
					$("#TesItemID").val("");
					$("#TesItemDesc").val("");
					$("#recLoc").combobox("setValue","");
					$("#recLoc").combobox("setText","");
				}
		})
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	runClassMethod("web.DHCAppPisMasterQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "LocID":session['LOGON.CTLOCID'], "UserID":session['LOGON.USERID'] },function(jsonString){
		var jsonObject = jsonString;		
		if (PisID == ""){
		
			/// ����ҽ��	
			$('#ApplyDocUser').combobox("setValue",session['LOGON.USERID']);
			$('#ApplyDocUser').combobox("setText",session['LOGON.USERNAME']);	
			
			/// �������
			$('#ApplyLoc').combobox("setValue",session['LOGON.CTLOCID']); 
			$('#ApplyLoc').combobox("setText",jsonObject.LgLocDesc);		
		}		
	},'json',false)
}

/// ���ؼ�鷽���б�
function LoadCheckItemList(){
	
	/// ��ʼ����鷽������
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCode",{"Code":"MOL"},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// ��鷽���б�
function InitCheckItemRegion(itemobj){	
	/// ������
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// ��Ŀ
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="item" type="checkbox"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(htmlstr+itemhtmlstr)
}

/// ����ȡ�ķ�������
function LoadCutBaseList(){
	
	/// ��ʼ��ȡ�ķ�������
	$("#CutBas").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","JsonGetPisCutBasList",{"HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsCutBaseRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// ���ȡ�ķ�������
function InsCutBaseRegion(itemobj){	
	/// ������
	var htmlstr = '';
		htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// ��Ŀ
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 4 == 0){
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 4 != 0){
		itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#CutBas").append(htmlstr+itemhtmlstr)
}

/// ���ؼ����Ŀ����
function LoadTestItemList(){
	
	/// ��ʼ����鷽������
	$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","JsonTestItemList",{"HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsTesItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// �����Ŀ����
function InsTesItemRegion(itemobj){	
	/// ������
	var htmlstr = '';
		htmlstr = '<tr style="height:30px"><td colspan="7" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

	/// ��Ŀ
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 3 == 0){
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 3 != 0){
		itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#TesItem").append(htmlstr+itemhtmlstr)
}

/// ���没������
function SavePisNo(){
	
	/*
	/// ҽ��վ��������ʱ����
	if (DocMainFlag == 1){
		InsertDoc();
		return;
	}
	*/
	
	var itmmastid = $("#TesItemID").val();  			   /// ҽ����ID
	if (itmmastid == ""){
		$.messager.alert("��ʾ:","����ѡ��������Ŀ��");
		return;
	}
	var recLocID = $HUI.combobox("#recLoc").getValue();    /// ���տ���ID
	var ApplyDocUser = $HUI.combobox("#ApplyDocUser").getValue();    /// ����ҽ��  qunianpeng 2018/2/5
	if ((asStaus=="I")&&(ApplyDocUser!=LgUserID)){ApplyDocUser=LgUserID}
	var ApplyLoc = $HUI.combobox("#ApplyLoc").getValue(); 			 /// �������
	if(ApplyLoc==""){
		$.messager.alert("��ʾ:","����ѡ��������ң�");
		return;
	}
	if(ApplyDocUser==""){
		$.messager.alert("��ʾ:","����ѡ������ҽ����");
		return;
	}
	var EmgFlag = ""; //$HUI.checkbox("#EmgFlag").getValue() ? "Y":"N";     /// �Ӽ�
	var FrostFlag = ""; //$HUI.checkbox("#FrostFlag").getValue() ? "Y":"N"; /// ����
	var MedRecord =  $("#MedRecord").val(); 			   /// ���˲���
	var MedDiag =  $("#MedDiag").val(); 			       /// �ٴ����
	var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ "" +"^"+ MedRecord +"^"+ MedDiag +"^^^MOL" +"^";

	/// ȡ����Ϣ 
	var Position =  $("#Position").val(); 		     	   /// ȡ�Ĳ�λ
	if (Position == ""){
		$.messager.alert("��ʾ:","ȡ�Ĳ�λ����Ϊ�գ�");
		return;
	}
	var mType="";										   /// ȡ������
    var mTypeArr = $("input[name=CutBas]");
    for (var j=0; j < mTypeArr.length; j++){
	    if($("[value='"+mTypeArr[j].value+"'][name=CutBas]").is(':checked')){
			mType = mTypeArr[j].value;
	    }
	}
	if (mType == ""){
		$.messager.alert("��ʾ:","ȡ�����Ͳ���Ϊ�գ�");
		return;
	}
	var mPisPatSpec = "1^^"+ Position +"^^^^^^"+ mType;

	/// �����Ŀ
	var mPisTestItem=""; mPisTestItemArr = [];
    var TestItemArr = $("input[name=TestItem]");
    for (var j=0; j < TestItemArr.length; j++){
	    if($("[value='"+TestItemArr[j].value+"'][name=TestItem]").is(':checked')){
			mPisTestItemArr.push(TestItemArr[j].value);
	    }
	}
	var mPisTestItem = mPisTestItemArr.join("@");
	
	///             ����Ϣ  +"&"+  ����걾  +"&"+   �����Ŀ
	var mListData = mListData +"&"+ mPisPatSpec +"&"+ mPisTestItem;

	/// ����
	runClassMethod("web.DHCAppPisMaster","Insert",{"PisType":"MOL", "PisID":PisID, "mListData":mListData},function(jsonString){

		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			PisID = jsonString;
			GetPisNoObj(PisID);
			$.messager.alert("��ʾ:","����ɹ���");
		    /// ���ø���ܺ���
		    window.parent.frames.reLoadEmPatList();
		}
	},'json',false)
}

/// ���Ͳ�������
function SendPisNo(){

	/// סԺ��������Ѻ�����
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$.messager.alert("��ʾ:",PatArrManMsg);
		return;	
	}
	var BillTypeID = "";
	if (typeof window.parent.frames.BillTypeID != "undefined"){
		BillTypeID = window.parent.frames.BillTypeID;  ///�ѱ�ID
	}
	var InsurFlag=parent.$HUI.checkbox("#InsurFlag").getValue()?"Y":"N";
	/// ����
	runClassMethod("web.DHCAppPisMaster","InsSendFlag",{"PisID":PisID,"UserID":session['LOGON.USERID'],"BillTypeID":BillTypeID,"InsurFlag":InsurFlag},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","�������뵥�ѷ��������ٴη���!");
		}else if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			GetPisNoObj(PisID);
			$.messager.alert("��ʾ:","���ͳɹ���");
			/// ���ø���ܺ���
		    window.parent.frames.reLoadEmPatList();
			/// ���Ӳ�����ܺ���
			window.parent.frames.InvEmrFrameFun();
		}
	},'json',false)
}

/// ��ʱ�洢����
function InsertDoc(){
	
	/// ҽ���
	var mItemParam = mListDataDoc.split("!")[1];
	if (mItemParam == "") return false;

	var ApplyDocUser = session['LOGON.USERID'];    /// ����ҽ��
	var ApplyLoc = session['LOGON.CTLOCID']; 	   /// �������
	var EmgFlag = ""; 
	var FrostFlag = "";
	var MedRecord =  $("#MedRecord").val(); 			   /// ���˲���
	var MedDiag =  $("#MedDiag").val(); 			       /// �ٴ����
	var mListData = "^^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ "" +"^"+ MedRecord +"^"+ MedDiag +"^^^MOL" +"^";

	/// ȡ����Ϣ 
	var Position =  $("#Position").val(); 		     	   /// ȡ�Ĳ�λ
	if (Position == ""){
		window.parent.frames.InvErrMsg("�����Ӳ������롿ȡ�Ĳ�λ����Ϊ�գ�");
		return false;
	}
	var mType="";										   /// ȡ������
    var mTypeArr = $("input[name=CutBas]");
    for (var j=0; j < mTypeArr.length; j++){
	    if($("[value='"+mTypeArr[j].value+"'][name=CutBas]").is(':checked')){
			mType = mTypeArr[j].value;
	    }
	}
	if (mType == ""){
		window.parent.frames.InvErrMsg("�����Ӳ������롿ȡ�����Ͳ���Ϊ�գ�");
		return false;
	}
	var mPisPatSpec = "1^^"+ Position +"^^^^^^"+ mType;

	/// �����Ŀ
	var mPisTestItem=""; mPisTestItemArr = [];
    var TestItemArr = $("input[name=TestItem]");
    for (var j=0; j < TestItemArr.length; j++){
	    if($("[value='"+TestItemArr[j].value+"'][name=TestItem]").is(':checked')){
			mPisTestItemArr.push(TestItemArr[j].value);
	    }
	}
	var mPisTestItem = mPisTestItemArr.join("@");
	
	///             ����Ϣ  +"&"+  ����걾  +"&"+   �����Ŀ
	var mListData = mListData +"&"+ mPisPatSpec +"&"+ mPisTestItem;

	/// ����
	runClassMethod("web.DHCAppPisMaster","InsertTempDoc",{"Pid":pid, "mListData":mListData, "mItemParam":mItemParam},function(jsonString){
		if (jsonString < 0){
			window.parent.frames.InvErrMsg("�����Ӳ������롿����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
			return false;
		}
	},'json',false)
	
	return true;
}

/// ���ز�����������Ϣ����
function GetPisNoObj(PisID){
	
	runClassMethod("web.DHCAppPisMaster","JsGetPisNoObj",{"PisID":PisID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsPisNoObj(jsonObjArr);
		}
	},'json',false)
}

/// ���ز������벡�˲�������
function GetPisItemList(){

	runClassMethod("web.DHCAppPisMasterQuery","JsonPisItemList",{"PisID":PisID, "Type":"MOL"},function(jsonString){

		if (jsonString != ""){
			var itemArr = jsonString;
			for (var j=0; j<itemArr.length; j++){
				$("[name="+ itemArr[j].name +"][value="+ itemArr[j].value +"]").attr("checked",'true'); 
			}
			$("input[name='TestItem']").each(function(){
				if(!$(this).attr("checked")){
					$(this).parent().hide();
					$(this).parent().next().hide();
				}
			})
		}

	},'json',false)
}

/// ���ò������뵥����
function InsPisNoObj(itemobj){
	
	$("#TesItemID").val(itemobj.arcimid);
	$("#TesItemDesc").val(itemobj.ItemDesc);          /// ҽ������
	$("#recLoc").combobox("setValue",itemobj.LocID);  /// ���տ���
	$("#recLoc").combobox("setText",itemobj.LocDesc); /// ���տ���
	$HUI.combobox("#ApplyDocUser").setValue(itemobj.ApplyDocId);  /// ������Һ�����ҽ�� qunianpeng 2018/2/5
	$HUI.combobox("#ApplyDocUser").setText(itemobj.ApplyDocDesc);	
	$HUI.combobox("#ApplyLoc").setValue(itemobj.ApplyLocId);	
	$HUI.combobox("#ApplyLoc").setText(itemobj.ApplyLocDesc);

	$HUI.checkbox("#EmgFlag").setValue(itemobj.EmgFlag == "Y"? true:false);      /// �Ӽ�
	$HUI.checkbox("#FrostFlag").setValue(itemobj.FrostFlag == "Y"? true:false);  /// ����
	$("#MedRecord").val(itemobj.MedRecord); 	   		       /// ���˲���
	$("#MedDiag").val(itemobj.MedDiag); 	   	     	       /// �ٴ����
	$("#Position").val(itemobj.Position); 	   		           /// ȡ�Ĳ�λ
	$("[name=CutBas][value="+ itemobj.Type +"]").attr("checked",'true');
	asStaus="";
	var SendPisFlag = itemobj.SendPisFlag;  /// �Ƿ������ٴη���
	if (SendPisFlag == 1){
		$('a:contains("ȡ������")').linkbutton('disable');
		$('a:contains("ȡ������")').removeClass('btn-lightred');
		$('a:contains("����")').linkbutton('disable');
		$('a:contains("����")').removeClass('btn-lightgreen');
		$('a:contains("����")').linkbutton('disable');
		$('a:contains("����")').removeClass('btn-lightgreen');
		$('a:contains("��ӡ")').linkbutton('disable');
		PageEditFlag(1);  /// ���ý���༭״̬
	}else if (SendPisFlag == 2){
		$('a:contains("����")').linkbutton('disable');
		$('a:contains("����")').removeClass('btn-lightgreen');
		$('a:contains("ȡ������")').linkbutton('enable');
		$('a:contains("ȡ������")').addClass('btn-lightred');
		$('a:contains("��ӡ")').linkbutton('enable');
		PageEditFlag(2);  /// ���ý���༭״̬
	}else if (SendPisFlag == 3){
		$('a:contains("����")').linkbutton('disable');
		$('a:contains("����")').removeClass('btn-lightgreen');
		$('a:contains("ȡ������")').linkbutton('enable');
		$('a:contains("ȡ������")').addClass('btn-lightred');
		$('a:contains("����")').linkbutton('enable');
		$('a:contains("��ӡ")').linkbutton('disable');
		asStaus="I";
	}else{
		$('a:contains("ȡ������")').linkbutton('enable');
		$('a:contains("ȡ������")').addClass('btn-lightred');
		$('a:contains("����")').linkbutton('enable');
		$('a:contains("����")').addClass('btn-lightgreen');
		$('a:contains("����")').linkbutton('enable');
		$('a:contains("��ӡ")').linkbutton('disable');
	}
	$("#Oeori").text(itemobj.Oeori);  /// ҽ����
	$("#PisNo").text(itemobj.No);     /// ���뵥��
}

/// ���ý���༭״̬
function PageEditFlag(Flag){
	
	$("#TesItemDesc").attr("disabled",true);   /// ҽ������
	$HUI.combobox("#recLoc").disable();        /// ���տ��Ҳ�����
	$HUI.combobox("#ApplyLoc").disable();      /// ������Ҳ�����
	$HUI.combobox("#ApplyDocUser").disable();  /// ����ҽ��������
	$('input[type="checkbox"]').attr("disabled",true);
	$('textarea').attr("disabled", true);  /// �ı���
	$('.validatebox-text').attr("disabled", true); /// hisui �ı�
	$('input[type="text"]').attr("disabled", true);
}

/// �Ƿ�������д���뵥
function GetIsWritePisFlag(){
	
	runClassMethod("web.DHCAppPisMasterQuery","GetIsWritePisFlag",{"LgGroupID":session['LOGON.GROUPID'],"LgUserID":session['LOGON.USERID'],"LgLocID":session['LOGON.CTLOCID'],"EpisodeID":EpisodeID},function(jsonString){
		TakOrdMsg = jsonString;
		if(TakOrdMsg != ""){
			$.messager.alert("��ʾ:",TakOrdMsg);
		}
	},'text',false)
}

/// �Ӽ�
function EmgFlag_onClick(event, value){
	
	if (value == true){
		$HUI.checkbox("#FrostFlag").setValue(false);  /// ����
	}
}

/// ����
function FrostFlag_onClick(event, value){
	
	if (value == true){
		$HUI.checkbox("#EmgFlag").setValue(false);   /// �Ӽ�
	}
}

/// ���ؼ�鷽���б�
function LoadCheckItemListDoc(){
	
	var arcItemList=mListDataDoc.split("!")[1];

	/// ��ʼ����鷽������
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td></td><td style="width:20px;"></td><td></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","jsonExaItemListDoc",{"arcItemList":arcItemList},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString
			InitCheckItemRegionDoc(jsonObjArr);
		}
	},'json',false)
}

/// ��鷽���б�
function InitCheckItemRegionDoc(itemArr){

	var itemhtmlArr = []; itemhtmlstr = "";
	for (var i=1; i<=itemArr.length; i++){
		itemhtmlArr.push('<td style="width:30px;">'+ i +'</td><td>'+ itemArr[i-1].text +'</td><td>'+ itemArr[i-1].desc +'</td>');
		if (i % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
 	if ((i-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(itemhtmlstr);

}

/// ��ӡ�������뵥
function PrintPisNo(){

	PrintPis_REQ(PisID);
	return;
		
//	if (PisID == ""){
//		$.messager.alert("��ʾ:","��ǰ�޿ɴ�ӡ�Ĳ������뵥��");
//		return;
//	}
//	
//	runClassMethod("web.DHCAPPPrintCom","GetPisPrintCon",{"PisID":PisID},function(jsonString){
//		
//		if (jsonString == null){
//			$.messager.alert("��ʾ:","��ӡ�쳣��");
//		}else{
//			var jsonObj = jsonString;
//			Print_Xml(jsonObj);
//		}
//	},'json',false)	
}

/// �������뵥��ӡ
function Print_Xml(jsonObj){
	var MyPara = "";
	/// ���뵥��������
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// �ǼǺ�
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// �ǼǺ�-����
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// �ǼǺ�-����
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// ������
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// �������
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// ��������
	
	/// ���뵥��ϸ����
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       /// �Ӽ�
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);   /// ����
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// �����
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// ���뵥��
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// �����Ŀ
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisReqSpec,60)); /// ����걾
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.MedRecord,60));   /// �ٴ�����
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisTesDiag,60)); /// �ٴ����
	MyPara = MyPara+"^Position"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec);   /// ȡ�Ĳ�λ
	MyPara = MyPara+"^PisCutBasType"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisCutBasType,60)); ///���Ӳ���ȡ������ qunianpeng 2018/2/7
	MyPara = MyPara+"^PisTesItmMol"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisTesItmMol,60));  ///���Ӳ�������Ŀ qunianpeng 2018/2/7
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisMol");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
	
}

/// �����������뵥
function RevPisNo(){
	
	runClassMethod("web.DHCAppPisMaster","revPisMain",{"PisID":PisID, "UserID":session['LOGON.USERID']},function(jsonString){

		if (jsonString == 0){
			GetPisNoObj(PisID);
			$.messager.alert("��ʾ:","ȡ���ɹ���");
			/// ���ø���ܺ���
		    window.parent.frames.reLoadEmPatList();
		}else if(jsonString == "-12"){   //sufan 2018-03-12
			$.messager.alert("��ʾ:","��ִ�У�����ȡ�����룡");
			}else{
			$.messager.alert("��ʾ:","ȡ���쳣��");
		}
	},'json',false)
}

/// ��ӡ����
function PrintPisBar(flag){
	
	window.parent.frames.PrintBar(PisID,flag)
	/*runClassMethod("web.DHCAPPPrintCom","GetPisPrintCon",{"PisID":PisID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}else{
			var jsonObj = jsonString;
			Print_BarCode(jsonObj);
		}
	},'json',false)*/
}

/// �����ӡ
function Print_BarCode(jsonObj){

	var MyPara = "";
	/// ���뵥��������
	MyPara = "RegNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// �ǼǺ�
	MyPara = MyPara+"^lbbarcode"+String.fromCharCode(2)+"*"+jsonObj.PatNo+"*";  /// �ǼǺ�-����
	MyPara = MyPara+"^lbpatname"+String.fromCharCode(2)+jsonObj.PatName;		/// ����
	MyPara = MyPara+"^lbpatsex"+String.fromCharCode(2)+jsonObj.PatSex;		    /// �Ա�
	MyPara = MyPara+"^lbpatage"+String.fromCharCode(2)+jsonObj.PatAge;          /// ����
	MyPara = MyPara+"^lblesion"+String.fromCharCode(2)+jsonObj.PatWard;       	/// ����
	MyPara = MyPara+"^lbapplydoc"+String.fromCharCode(2)+jsonObj.UserName;    	/// ������
	MyPara = MyPara+"^lbapllyloc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	/// �������
	MyPara = MyPara+"^lbrecloc"+String.fromCharCode(2)+txtUtil(jsonObj.RecLoc); /// ���տ���
	MyPara = MyPara+"^lbapplydate"+String.fromCharCode(2)+jsonObj.CreatDate;  	/// ��������
	MyPara = MyPara+"^CreatTime"+String.fromCharCode(2)+jsonObj.CreatTime;    	/// ����ʱ��
	MyPara = MyPara+"^lbspecinfo"+String.fromCharCode(2)+txtUtil(jsonObj.SpecName);     	/// �걾
	MyPara = MyPara+"^lbapplycheckpro"+String.fromCharCode(2)+txtUtil(jsonObj.PisItem);     /// �����Ŀ

	//DHCP_GetXMLConfig("DHCAPP_PisBarCode");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisBarCode");
	//���þ����ӡ����
	//DHCP_PrintFun(MyPara, "");
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"");
}

/// ����Ϊ undefined ��ʾ��
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}
/// �����ٴ�����  sufan 2018-02-01
function LoadPatClinicalRec(){
	runClassMethod("web.DHCAppPisMasterQuery","GetPatClinicalRec",{"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
		
			$("#MedRecord").val( jsonObjArr.arExaReqSym +""+ jsonObjArr.arExaReqHis +""+ jsonObjArr.arExaReqSig);  /// ����+�ֲ�ʷ+����
			
		}
	},'json',false)
}

/// ���뵥�Ƿ�����༭
function InitReqEditFlag(ID){

	var LgParams = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","JsGetReqEditFlag",{"ID":ID, "Type":"P", "LgParams":LgParams},function(jsonString){
		if (jsonString != ""){
			PageBtEditFlag(jsonString);
		}
	},'json',false)
}

/// ���ý���༭״̬
function PageBtEditFlag(Flag){
	
	if (Flag == 0){
		$('a:contains("ȡ������")').linkbutton('disable');
		$('a:contains("ȡ������")').removeClass('btn-lightred');
		$('a:contains("����")').linkbutton('disable');
		$('a:contains("����")').removeClass('btn-lightgreen');
	}
}

/// �������뵥����
function LoadReqFrame(PisID, repEmgFlag){

	GetPisNoObj(PisID);   /// ���ز�������
	GetPisItemList();     /// ���ز������벡�˲�������
	InitReqEditFlag(PisID);  /// ���뵥�Ƿ�����༭
}

/// ��֤�����Ƿ�����ҽ�� סԺ��������Ѻ�����
function GetPatArrManage(){

	var PatArrManMsg = "";
	var amount = $("#arExaReqCost").text(); /// ���
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCAPPExaReport","GetArrearsManage",{"EpisodeID":EpisodeID,"LgGroupID":LgGroupID,"LgLocID":LgCtLocID,"amount":amount},function(jsonString){

		if (jsonString != ""){
			PatArrManMsg = jsonString;
		}
	},'text',false)

	return PatArrManMsg;
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	if (PisID != ""){
		LoadReqFrame(PisID, "");    /// ���ز�������
		$("#itemList").hide();
	}
}

window.onload = onload_handler;
window.onbeforeunload = function(event) { 
	if (PisID != ""){
		var RtnFlag="1"
		runClassMethod("web.DHCAppPisMaster","InsCheckSend",{"Pid":PisID},function(jsonString){
			RtnFlag=jsonString;
		},'text',false)
		if (RtnFlag == "0"){
				return "��δ�������뵥���Ƿ��뿪�˽���"
			}else{
				return;	
		}
	}else{ return;}
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
