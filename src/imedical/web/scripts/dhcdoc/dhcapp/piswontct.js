//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-04
// ����:	   ����TCT�������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var PisID = "";         /// ��������ID
var Oeori = "";         /// ҽ��ID
var isWriteFlagTCT = "-1";
var TakOrdMsg = "";
var pid = "";  			 /// Ψһ��ʶ
var mListDataDoc = "";   /// ҽ��վ�����������
var DocMainFlag = "";    /// ҽ��վ���浯����ʾ
var LgUserID = session['LOGON.USERID'];   /// �û�ID
var LgCtLocID = session['LOGON.CTLOCID']; /// ����ID
var LgGroupID = session['LOGON.GROUPID']; /// ��ȫ��ID
var LgHospID=session['LOGON.HOSPID'];
var asStaus=""
/// ҳ���ʼ������
function initPageDefault(){

	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	LoadTestItemList();       /// ����HPV���˲�������
	//LoadCheckItemList();      /// ���ز�������Ŀ
	GetIsWriteFlagTCT();      /// �Ƿ����д�ж�
	GetIsWritePisFlag();      /// �Ƿ����д�ж�
	GetPatBaseInfo();         /// ���ز�����Ϣ
	InitPageCheckBox();		  /// ҳ��CheckBox����
	LoadPisNoByOeori();       /// ���ز������뵥��Ϣ
	InitVersionMain();        /// ҳ���������
}

/// ҳ���������
function InitVersionMain(){
	
	/// ��������ʱ,�����������°�¼�����
	if (DocMainFlag == 1){
		$('#tPanel').panel({closed:true});  	  /// ���ء�������Ϣ��
		$('#mainPanel').layout("remove","south"); /// ���ء���ť����
		$('a:contains("ȡ������")').hide();
		$('a:contains("����")').hide();
		$('a:contains("��ӡ")').hide();
		LoadCheckItemListDoc();      /// ���ز�������Ŀ
		var PanelWidth = window.parent.frames.GetPanelWidth()-170;
		/// ��塾������Ϣ����С���� 
		$('#mPanel').panel('resize',{width: PanelWidth ,height: 100});
		/// ��塾�ۺ���Ϣ����С����
		$('#cPanel').panel('resize',{width: PanelWidth ,height: 160});
		/// ��塾���˲�������С����
		$('#pPanel').panel('resize',{width: PanelWidth ,height: 375});
	}else{
		LoadCheckItemList();         /// ���ز�������Ŀ
	}
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	PisID = getParam("itemReqID");     /// ���뵥ID
	Oeori = getParam("Oeori");         /// ҽ��ID
	if (Oeori != ""){
		$('#mPanel').panel({closed:true}); /// ���ء�����TCT������Ϣ��
		$('a:contains("����")').hide();
	}
	
	/// ����Ϊҽ��վ�������� ����
	pid = getParam("pid");         /// Ψһ��ʶ
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

	/// ȡ�����ڿ���
	$('#SepDate').datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// �ϴ��¾����ڿ���
	$('#LastMensDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// ĩ���¾����ڿ���
	$('#MensDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// �ϴ��¾����ڿ���
	$('#LastMensDate').datebox({
		onSelect: function(date){
			var MensDate = $HUI.datebox("#MensDate").getValue(); /// ĩ���¾�
			if (MensDate != ""){
				var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// �ϴ��¾�
				if (isCompare(LastMensDate, MensDate) == 1){
					$.messager.alert("��ʾ:","���ϴ��¾����ڡ����ܴ��ڵ��ڡ�ĩ���¾����ڡ���");
					$('#LastMensDate').datebox('setValue',"");
					return;
				}
			}else{
				$HUI.checkbox("#PauFlag").setValue(false);  /// ����
			}
			return true;
		}
	});
	
	/// ĩ���¾����ڿ���
	$('#MensDate').datebox({
		onSelect: function(date){
			var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// �ϴ��¾�
			if (LastMensDate != ""){
				//var LastMensDate = new Date(LastMensDate.replace(/\-/g, "\/"));
				var MensDate = $HUI.datebox("#MensDate").getValue(); /// ĩ���¾�
				if (isCompare(LastMensDate, MensDate) != 0){
					$.messager.alert("��ʾ:","��ĩ���¾����ڡ�����С�ڵ��ڡ��ϴ��¾����ڡ���");
					$('#MensDate').datebox('setValue',"");
					return;
				}
			}else{
				$HUI.checkbox("#PauFlag").setValue(false);  /// ����
			}
			return true;
		}
	});
	
	/// ̥��
	$("#PreTimes").keyup(function(){
	    var PreTimes = $("#PreTimes").val();  /// ̥��
	    var LyTimes = $("#LyTimes").val();    /// ����
	    if ((LyTimes != "")&(PreTimes < LyTimes)){
		    $.messager.alert("��ʾ:","̥��������ڵ��ڲ�����");
			$("#PreTimes").val("");
		}
	});
	
	/// ����
	$("#LyTimes").keyup(function(){
	    var PreTimes = $("#PreTimes").val();  /// ̥��
	    var LyTimes = $("#LyTimes").val();    /// ����
	    if ((LyTimes != "")&(PreTimes < LyTimes)){
		    $.messager.alert("��ʾ:","̥��������ڵ��ڲ�����");
			$("#LyTimes").val("");
		}
	});
	
	/// ȡ�Ŀ��� 
	$('#LocID').combobox({	//ȡ�Ŀ��Һ�ȡ��ҽ������ѡ�� 2018/2/2 qunianpeng 
		mode:'remote',  
		onShowPanel:function(){
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID;
			$("#LocID").combobox('reload',unitUrl);
		},
		onSelect:function(){	//���ü��� ѡ����Һ󣬼��ؿ��Ե�¼�ÿ��ҵ�ҽ�� qunianpeng 2018/2/7
			$("#DocDr").combobox("setValue","");
			$("#DocDr").combobox('reload');
		}
	});
	
	/// ȡ��ҽ�� 
	$('#DocDr').combobox({
		//mode:'remote',  
		onShowPanel:function(){
			var bLocID=$('#LocID').combobox('getValue');	
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+bLocID;
			$("#DocDr").combobox('reload',unitUrl);
		}
	});	
	
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
	if ((isWriteFlagTCT != 0)&&(DocMainFlag != 1)){
		$.messager.alert("��ʾ","ֻ�г���Ů�Բſ���д����TCT������룡");
		$(e.target).attr("checked",false);
		return;
	}
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ",TakOrdMsg);
		return;	
	}
	/// ��鷽����ҽ����ID��ҽ�������ơ�
	var TesItemID = e.target.id;    /// ��鷽��ID
	var TesItemDesc = $(e.target).parent().next().text(); /// ��鷽��
	var itmmastid = TesItemID.replace("_","||");
	/// ҽ�����Ա�/��������
	var LimitMsg = window.parent.frames.GetItmLimitMsg(itmmastid)
	if (LimitMsg != ""){
		$.messager.alert("��ʾ","��Ŀ��" +TesItemDesc+ "��������ʹ�ã�" + LimitMsg);
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
		
		if ((isWriteFlagTCT != 0)&&(DocMainFlag != 1)){
			$.messager.alert("��ʾ:","ֻ�г���Ů�Բſ���д����TCT������룡");
			$(this).attr("checked",false);
			return;
		}
		
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

/// ���ؼ�鷽���б�
function LoadCheckItemList(){
	
	/// ��ʼ����鷽������
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCode",{"Code":"TCT"},function(jsonString){

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

/// ����HPV���˲�������
function LoadTestItemList(){
	
	/// ��ʼ����鷽������
	$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","JsonPatRecList",{"HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsTesItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// HPV���˲�������
function InsTesItemRegion(itemobj){	
	/// ������
	var htmlstr = '';
	/// ע�ͱ����� qunianpeng 2018/1/30
	htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

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
	$("#TesItem").append(htmlstr+itemhtmlstr)
}

/// ���没������
function SavePisNo(){
	
	/// ҽ��վ��������ʱ����
	/*
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
	var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ "" +"^"+ MedRecord +"^^^^TCT" +"^"+ Oeori;

	/// ������Ϣ
	var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// �ϴ��¾�
	var MensDate = $HUI.datebox("#MensDate").getValue();   /// ĩ���¾�
	var PreTimes =  $("#PreTimes").val(); 			       /// ̥
	var LyTimes =  $("#LyTimes").val(); 			       /// ��
	var PauFlag= $HUI.checkbox("#PauFlag").getValue() ? "Y":"N"; /// ����
	var UnknownFlag= $HUI.checkbox("#UnknownFlag").getValue() ? "Y":"N"; /// ����
	var BloodFlag= $HUI.checkbox("#BloodFlag").getValue() ? "Y":"N"; /// �ӹ��쳣��Ѫ
	var mPisGynWon = LastMensDate +"^"+ MensDate +"^"+ PreTimes +"^"+ LyTimes +"^"+ PauFlag+"^"+UnknownFlag+"^"+BloodFlag;
	if ((LastMensDate == "")&(PauFlag == "N")){
		$.messager.alert("��ʾ:","����д�ϴ��¾����ڣ�");
		return;	
	}
	if ((MensDate == "")&(PauFlag == "N")){
		$.messager.alert("��ʾ:","����дĩ���¾����ڣ�");
		return;	
	}

	/// ȡ����Ϣ 
	//var CbSepDate = $HUI.datebox("#SepDate").getValue();   /// ȡ������
	var TmpSepDate=""; var TmpSepTime=""; 
	var TmpDateTime = $HUI.datetimebox("#SepDate").getValue();   /// �걾��������
	if (TmpDateTime == ""){
		$.messager.alert("��ʾ:","����дȡ�����ڣ�");
		return;
	}
	if (TmpDateTime != ""){
		TmpSepDate=TmpDateTime.split(" ")[0]; TmpSepTime=TmpDateTime.split(" ")[1];
	}
	
	//var CbLocDesc =  $("#LocID").val(); 			       /// ȡ�Ŀ���
	//var CbDocName =  $("#DocDr").val(); 		     	   /// ȡ��ҽ��
	var CbLocDesc = $HUI.combobox("#LocID").getValue();    /// ȡ�Ŀ���  qunianpeng 2018/2/2
	var CbDocName = $HUI.combobox("#DocDr").getValue();	   /// ȡ��ҽ��
	var mPisCutBas = TmpSepDate +"^"+ TmpSepTime + "^" + "" +"^"+ "" +"^"+ CbLocDesc +"^"+ CbDocName;

	/// ���˲���
	var mPisPatRec=""; mPisPatRecArr = [];
    var PatRecArr = $("input[name=PatRec]");
    for (var j=0; j < PatRecArr.length; j++){
	    if($('#'+PatRecArr[j].id).is(':checked')){
			mPisPatRecArr.push(PatRecArr[j].value);
	    }
	}

    mPisPatRec = mPisPatRecArr.join("@")
	if(mPisPatRec == ""){
		$.messager.alert("��ʾ:","����д���˲�����");
		return;	
	}
		
	/// �ٴ����
	var mPisTesDiagArr=[]; var mPisTesDiag="";
	var TesDiagArr = $("input[name=TesDiag]");
	for (var j=0; j < TesDiagArr.length; j++){
	    if($("[value='"+TesDiagArr[j].value+"'][name=TesDiag]").is(':checked')){
			mPisTesDiagArr.push(TesDiagArr[j].value);
	    }
	}
	var mPisTesDiag = mPisTesDiagArr.join("@");
	
	///             ����Ϣ  +"&"+  ������Ϣ  +"&"+   ȡ����Ϣ  +"&"+  ���˲���+"&"+  �ٴ����
	var mListData = mListData +"&"+ mPisGynWon +"&"+ mPisCutBas +"&"+ mPisPatRec+"&"+ mPisTesDiag;

	/// ����
	runClassMethod("web.DHCAppPisMaster","Insert",{"PisType":"TCT", "PisID":PisID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			PisID = jsonString;
			GetPisNoObj(PisID)
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
	var mListData =  "^^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ "" +"^"+ MedRecord +"^^^^TCT" +"^"+ Oeori;

	/// ������Ϣ
	var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// �ϴ��¾�
	var MensDate = $HUI.datebox("#MensDate").getValue();   /// ĩ���¾�
	var PreTimes =  $("#PreTimes").val(); 			       /// ̥
	var LyTimes =  $("#LyTimes").val(); 			       /// ��
	var PauFlag= $HUI.checkbox("#PauFlag").getValue() ? "Y":"N"; /// ����
	var UnknownFlag= $HUI.checkbox("#UnknownFlag").getValue() ? "Y":"N"; /// ����
	var BloodFlag= $HUI.checkbox("#BloodFlag").getValue() ? "Y":"N"; /// �ӹ��쳣��Ѫ
	var mPisGynWon = LastMensDate +"^"+ MensDate +"^"+ PreTimes +"^"+ LyTimes +"^"+ PauFlag+"^"+UnknownFlag+"^"+BloodFlag;
	if ((LastMensDate == "")&(PauFlag == "N")){
		window.parent.frames.InvErrMsg("����д������TCT���롿�ϴ��¾����ڣ�");
		return false;
	}
	if ((MensDate == "")&(PauFlag == "N")){
		window.parent.frames.InvErrMsg("����д������TCT���롿ĩ���¾����ڣ�");
		return false;
	}

	var TmpSepDate=""; var TmpSepTime=""; 
	var TmpDateTime = $HUI.datetimebox("#SepDate").getValue();   /// �걾��������
	if (TmpDateTime == ""){
		$.messager.alert("��ʾ:","����дȡ�����ڣ�");
		return;
	}
	if (TmpDateTime != ""){
		TmpSepDate=TmpDateTime.split(" ")[0]; TmpSepTime=TmpDateTime.split(" ")[1];
	}
	
	/// ȡ����Ϣ 
	//var CbSepDate = $HUI.datebox("#SepDate").getValue();   /// ȡ������
	var CbLocDesc = $HUI.combobox("#LocID").getValue();    /// ȡ�Ŀ���  qunianpeng 2018/2/2
	var CbDocName = $HUI.combobox("#DocDr").getValue();	   /// ȡ��ҽ��
	var mPisCutBas = TmpSepDate +"^"+ TmpSepTime + "^" + "" +"^"+ "" +"^"+ CbLocDesc +"^"+ CbDocName;

	/// ���˲���
	var mPisPatRec=""; mPisPatRecArr = [];
    var PatRecArr = $("input[name=PatRec]");
    for (var j=0; j < PatRecArr.length; j++){
	    if($('#'+PatRecArr[j].id).is(':checked')){
			mPisPatRecArr.push(PatRecArr[j].value);
	    }
	}

    mPisPatRec = mPisPatRecArr.join("@")
	if(mPisPatRec == ""){
		window.parent.frames.InvErrMsg("����д������TCT���롿���˲�����Ϣ��");
		return false;
	}
	///             ����Ϣ  +"&"+  ������Ϣ  +"&"+   ȡ����Ϣ  +"&"+  ���˲���
	var mListData = mListData +"&"+ mPisGynWon +"&"+ mPisCutBas +"&"+ mPisPatRec;
	/// ����
	runClassMethod("web.DHCAppPisMaster","InsertTempDoc",{"Pid":pid, "mListData":mListData, "mItemParam":mItemParam},function(jsonString){
		if (jsonString < 0){
			window.parent.frames.InvErrMsg("������TCT���롿����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
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

	runClassMethod("web.DHCAppPisMasterQuery","JsonPisItemList",{"PisID":PisID, "Type":"TCT"},function(jsonString){

		if (jsonString != ""){
			var itemArr = jsonString;
			for (var j=0; j<itemArr.length; j++){
				$("[name="+ itemArr[j].name +"][value="+ itemArr[j].value +"]").attr("checked",'true'); 
			}
		}
	},'json',false)
}

/// ���ò������뵥����
function InsPisNoObj(itemobj){
	
	$("#TesItemID").val(itemobj.arcimid);
	$("#TesItemDesc").val(itemobj.ItemDesc);          /// ҽ������
	$("#recLoc").combobox("setValue",itemobj.LocID);  /// ���տ���
	$("#recLoc").combobox("setText",itemobj.LocDesc); /// ���տ���
	$HUI.checkbox("#EmgFlag").setValue(itemobj.EmgFlag == "Y"? true:false);      /// �Ӽ�
	$HUI.checkbox("#FrostFlag").setValue(itemobj.FrostFlag == "Y"? true:false);  /// ����
	$("#MedRecord").val(itemobj.MedRecord); 	   		       /// ���˲���
	$HUI.datebox("#LastMensDate").setValue(itemobj.LastMensDate); /// �ϴ��¾�
	$HUI.datebox("#MensDate").setValue(itemobj.MensDate);      /// ĩ���¾�
	$("#PreTimes").val(itemobj.PreTimes); 	   		           /// ̥
	$("#LyTimes").val(itemobj.LyTimes); 	   		           /// ��
	$HUI.checkbox("#PauFlag").setValue(itemobj.PauFlag == "Y"? true:false);  /// ����
	$HUI.checkbox("#UnknownFlag").setValue(itemobj.UnknownFlag == "Y"? true:false);  /// ����
	$HUI.checkbox("#BloodFlag").setValue(itemobj.BloodFlag == "Y"? true:false);  /// �ӹ��쳣��Ѫ
	$HUI.datetimebox("#SepDate").setValue(itemobj.SepDate);        /// ȡ������
	//$("#LocID").val(itemobj.BLocDesc); 	   		               /// ȡ�Ŀ���
	//$("#DocDr").val(itemobj.DocName); 	   		               /// ȡ��ҽ��
	$HUI.combobox("#LocID").setValue(itemobj.BLocID);			   /// ȡ�Ŀ��Һ�ҽ����Ϊ������ qunianpeng 2018/2/2
	$HUI.combobox("#LocID").setText(itemobj.BLocDesc);	
	$HUI.combobox("#DocDr").setValue(itemobj.BDocID);	
	$HUI.combobox("#DocDr").setText(itemobj.DocName);
	
	$HUI.combobox("#ApplyDocUser").setValue(itemobj.ApplyDocId);  /// ������Һ�����ҽ�� qunianpeng 2018/2/5
	$HUI.combobox("#ApplyDocUser").setText(itemobj.ApplyDocDesc);	
	$HUI.combobox("#ApplyLoc").setValue(itemobj.ApplyLocId);	
	$HUI.combobox("#ApplyLoc").setText(itemobj.ApplyLocDesc);
	var SendPisFlag = itemobj.SendPisFlag;  /// �Ƿ������ٴη���
	asStaus="";
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
		asStaus="I"
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
	$(".hisui-checkbox").checkbox('disable');
	$HUI.datebox("#LastMensDate").disable(); /// �ϴ��¾�
	$HUI.datebox("#MensDate").disable();     /// ĩ���¾�
	$HUI.datebox("#SepDate").disable();      /// ȡ������
	$HUI.combobox("#LocID").disable();  /// ȡ�Ŀ��Ҳ�����
	$HUI.combobox("#DocDr").disable();  /// ȡ��ҽ��������
	$('.validatebox-text').attr("disabled", true); /// hisui �ı�
	$('textarea').attr("disabled", true);  /// �ı���
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

/// �Ƿ�������д����TCT
function GetIsWriteFlagTCT(){
	
	runClassMethod("web.DHCAppPisMasterQuery","GetIsWriteFlagTCT",{"EpisodeID":EpisodeID},function(jsonString){
		isWriteFlagTCT = jsonString;
		if((isWriteFlagTCT != 0)&&(DocMainFlag != 1)){
			$.messager.alert("��ʾ:","ֻ�г���Ů�Բſ���д����TCT������룡");
		}
	},'json',false)
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	runClassMethod("web.DHCAppPisMasterQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "LocID":session['LOGON.CTLOCID'], "UserID":session['LOGON.USERID']},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject.PatSex == "��"){
			$("label:contains('������Ϣ')").parent().hide();
		}
		
		if (PisID == ""){
			/// ȡ��ҽ��
			$('#DocDr').combobox("setValue",session['LOGON.USERID']);
			$('#DocDr').combobox("setText",session['LOGON.USERNAME']);
			/// ȡ�Ŀ���
			$('#LocID').combobox("setValue",session['LOGON.CTLOCID']);
			$('#LocID').combobox("setText",jsonObject.LgLocDesc);
			
			/// ����ҽ��	
			$('#ApplyDocUser').combobox("setValue",session['LOGON.USERID']);
			$('#ApplyDocUser').combobox("setText",session['LOGON.USERNAME']);	
			
			/// �������
			$('#ApplyLoc').combobox("setValue",session['LOGON.CTLOCID']); 
			$('#ApplyLoc').combobox("setText",jsonObject.LgLocDesc);	
			
		}

	},'json',false)
}

/// ����
function PauFlag_onClick(event, value){
	
	if (value == true){
		//$('#MensDate').datebox('setValue',"");
		//$('#LastMensDate').datebox('setValue',"");
	}
}

/// ҽ��ID��λ�գ�����ҽ��ID�������뵥����
function LoadPisNoByOeori(){
	
	if (Oeori == "") return;

	runClassMethod("web.DHCAPPPisInterface","GetPisNoByOeori",{"Oeori":Oeori},function(jsonObj){

		if (jsonObj != null){

			if (jsonObj.PisID != ""){
				PisID = jsonObj.PisID;  /// �������뵥����
			}else{
				$("#TesItemID").val(jsonObj.arcimid);            /// ��ĿID
				$("#TesItemDesc").val(jsonObj.arcimDesc);        /// ��Ŀ����
				$("#recLoc").combobox("setValue",jsonObj.rLocID);   /// ���տ���ID
				$("#recLoc").combobox("setText",jsonObj.rLocDesc);  /// ���տ���
			}
		}
	},'json',false)
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

/// ����TCT���뵥��ӡ
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
	/// ����ַ���
	var PatMedRecord = jsonObj.PisPatRec +","+ jsonObj.MedRecord;
	var TmpLabelArr = SplitString(PatMedRecord, 88);
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(TmpLabelArr[0]);      /// �ٴ�����
	MyPara = MyPara+"^MedRecord1"+String.fromCharCode(2)+txtUtil(TmpLabelArr[1]);     /// �ٴ�����
	MyPara = MyPara+"^MedRecord2"+String.fromCharCode(2)+txtUtil(TmpLabelArr[2]);     /// �ٴ�����
	
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisTesDiag,60)); /// �ٴ����
	MyPara = MyPara+"^SepDate"+String.fromCharCode(2)+txtUtil(jsonObj.SepDate);            /// ȡ����������
	MyPara = MyPara+"^FixDate"+String.fromCharCode(2)+txtUtil(jsonObj.FixDate);            /// ��ʼ�̶�����
	MyPara = MyPara+"^BLocDesc"+String.fromCharCode(2)+txtUtil(jsonObj.BLocDesc);          /// ȡ�Ŀ���
	MyPara = MyPara+"^DocName"+String.fromCharCode(2)+txtUtil(jsonObj.DocName);            /// ȡ��ҽ��
	MyPara = MyPara+"^LastMensDate"+String.fromCharCode(2)+txtUtil(jsonObj.LastMensDate);  /// �ϴ��¾�����
	MyPara = MyPara+"^MensDate"+String.fromCharCode(2)+txtUtil(jsonObj.MensDate);          /// ĩ���¾�����
	MyPara = MyPara+"^PauFlag"+String.fromCharCode(2)+txtUtil(jsonObj.PauFlag);            /// �Ƿ����
	MyPara = MyPara+"^PreTimes"+String.fromCharCode(2)+txtUtil(jsonObj.PreTimes);          /// ���д���
	MyPara = MyPara+"^LyTimes"+String.fromCharCode(2)+txtUtil(jsonObj.LyTimes);            /// ��������
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisTCT");
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
	
	//window.parent.frames.PrintBar(PisID,flag);
	PrintBar(PisID,flag);
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
function LoadReqFrame(arRepID, repEmgFlag){

	GetPisNoObj(PisID);   /// ���ز�������
	GetPisItemList();     /// ���ز������벡�˲�������
	InitReqEditFlag(PisID);  /// ���뵥�Ƿ�����༭
}

/// ���ڴ�С�ж�
function isCompare(FriDate, SecDate){
	
	var isCompareFlag = 0;
	runClassMethod("web.DHCAppPisMasterQuery","isCompare",{"FriDate":FriDate, "SecDate":SecDate},function(jsonString){

		if (jsonString != null){
			isCompareFlag = jsonString;			
		}
	},'json',false)
	return isCompareFlag;
}

/// ҳ��CheckBox���� sufan 2018-01-30
function InitPageCheckBox()
{
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
