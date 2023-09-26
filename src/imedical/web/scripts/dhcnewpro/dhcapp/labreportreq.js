//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-09
// ����:	   �°����
//===========================================================================================

var EpisodeID = "";      /// ���˾���ID
var itemCatID = "";      /// ������ID
var itemReqID = "";      /// ���뵥ID
var itemSelFlag = "";    /// ��ѡ�б�ǰ״ֵ̬
var arExaReqIdList = "";
var editRow = ""; var editSelRow = -1;
var LgUserID = session['LOGON.USERID'];   /// �û�ID
var LgCtLocID = session['LOGON.CTLOCID']; /// ����ID
var LgGroupID = session['LOGON.GROUPID']; /// ��ȫ��ID
var LgHospID = session['LOGON.HOSPID'];   /// ҽԺID
var isPageEditFlag = 1;  /// ҳ���Ƿ�����༭

/// 1���رյ�ǰ������ˢ��ҽ��ҳ��(ҽ��վ)
/// 2���رյ�ǰ����(���Ӳ���)
var CloseFlag = "";      /// �رձ�־
var DocMainFlag = "";    /// ҽ��վ���浯����ʾ
var mListDataDoc = "";
var mItmMastStr = "";    /// ��ʱ�洢��Ŀ��
var TakOrdMsg = "";
var mItmMastLen = "";    /// �����Ŀ�ܸ���
var mItmMastDocArr = []; /// �����Ŀ
var pid = "";
var repEmgFlag = "";     /// ���뵥�Ӽ���־  sfuan 2018-02-01
var PatType="";          /// ��������
/// ҳ���ʼ������
function initPageDefault(){
		
	InitPatEpisodeID();   /// ��ʼ�����ز��˾���ID
	
	initVersionMain();    ///  ҳ���������
	initItemSelList();    ///  ҳ��DataGrid��ʼ����
	initCombobox();       ///  ҳ��Combobox��ʼ����
	initBlButton();       ///  ҳ��Button���¼�

	LoadPageBaseInfo();   ///  ��ʼ�����ػ�������
	
	initPatNotTakOrdMsg(); /// ��֤�����Ƿ�����ҽ��
	//initItemInstrDiv();    /// �����Ŀ˵����
}

/// ҳ���������
function initVersionMain(){

	/// ҽ���������ʱ,��ʼ������
	if (DocMainFlag == 1){
		/// ���ý��水ť����
		//$('button:contains("����")').text("ȷ��");
		$('button:contains("��ӡ")').text("�ر�");
		//$('#arEmgFlag').parent().parent().hide(); /// �Ӽ���־���� qunianpeng 2018/3/20
	}
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
	CloseFlag = getParam("CloseFlag");
	itemCatID = getParam("itemCatID");
	itemReqID = getParam("itemReqID");  /// ���뵥ID
	repEmgFlag = getParam("repEmgFlag");
	PatType = getParam("PatType");       /// ��������
	
	/// ����Ϊҽ��վ�������� ����
	mListDataDoc = getParam("ARCIMStr");
	//DocMainFlag = getParam("DocMainFlag");  /// ҽ�������ж�
	if (mListDataDoc != ""){
		DocMainFlag = 1;
		var mParam = mListDataDoc.split("!")[0];
		if (mParam != ""){
			EpisodeID = mParam.split("^")[0];
		}
	}
	
	if (itemCatID != ""){
		LoadCheckItemList(itemCatID);
	}
}

///  ��ʼ�����ػ�������
function LoadPageBaseInfo(){
	
	/// ��ѡ��Ŀ�б�
	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqDetList";
	$('#ItemSelList').datagrid({url:uniturl});
	
	/// ҽ���������ʱ,��ʼ������
	if (DocMainFlag == 1){
		LoadCheckItemByDoc();   /// ��ʼ����鷽������
	}
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function initItemSelList(){
	
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}

	// ���տ��ұ༭��
	var rLocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: '', //$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID=11207||1",
			valueField: "value", 
			textField: "text",
			onSelect:function(option){
				///��������ֵ
				var ed=$("#ItemSelList").datagrid('getEditor',{index:editSelRow,field:'ItemLocID'});
				$(ed.target).val(option.value);
				var ed=$("#ItemSelList").datagrid('getEditor',{index:editSelRow,field:'ItemLoc'});
				$(ed.target).combobox('setValue', option.text);
			} 
		}

	}
	
	// �걾�༭��
	var SpeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url:'',//$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=GetSpeJsonData&HospID="+ LgHospID,
			valueField: "value", 
			textField: "text",
			onSelect:function(option){
				///��������ֵ
				var ed=$("#ItemSelList").datagrid('getEditor',{index:editSelRow,field:'ItemSpecCode'});
				$(ed.target).val(option.value);
				var ed=$("#ItemSelList").datagrid('getEditor',{index:editSelRow,field:'ItemSpec'});
				$(ed.target).combobox('setValue', option.text);
			} 
		}

	}
	
	///  ����columns
	var columns=[[
		{field:'ItemOpt',title:'����',width:60,align:'center',formatter:SetCellOpUrl},
		
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'ItemArcID',title:'ItemArcID',width:100,hidden:true},
		{field:'ItemLabel',title:'��Ŀ����',width:280,align:'center'},
		{field:'ItemLoc',title:'���տ���',width:150,align:'center',editor:rLocEditor},
		{field:'ItemLocID',title:'���տ���ID',width:100,hidden:true,editor:texteditor},
		{field:'ItemExaID',title:'��ĿID',width:100,hidden:true},
		{field:'ItemExaPosiID',title:'��λID',width:100,hidden:true},
		{field:'ItemExaPartID',title:'��λID',width:100,hidden:true},
		{field:'ItemExaDispID',title:'����ID',width:100,hidden:true},
		{field:'ItemExaPurp',title:'���Ŀ��',width:100,hidden:true},		
		{field:'ItemSpecCode',title:'�걾Code',width:100,hidden:true,editor:texteditor},
		{field:'ItemSpec',title:'�걾',width:100,editor:SpeEditor},
		{field:'ItemRemark',title:'��ע',width:100,editor:texteditor},
		{field:'ItemStat',title:'��ǰ״̬',width:100,align:'center'},
		{field:'ItemBilled',title:'�Ʒ�״̬',width:100,hidden:true},
		{field:'ItemReqDate',title:'ҽ������',width:100,hidden:true},
		{field:'ItemUniqueID',title:'Ψһ��ʾ',width:100,hidden:true},
		{field:'ItemEmgFlag',title:'�Ӽ�',width:40,hidden:false,align:'center',formatter:emgFlagControl}, // �Ӽ���־ qunianpneg 2018/3/20
		{field:'ItemTarItm',title:'�շ���Ŀ',width:100,align:'center',formatter:SetCellTarUrl},
		{field:'ItemXUser',title:'������',width:100,align:'center'},
		{field:'ItemXDate',title:'��������',width:100,align:'center'},
		{field:'ItemXTime',title:'����ʱ��',width:100,align:'center'},
		{field:'ItemBillTypeID',title:'�ѱ�ID',width:100,align:'center',hidden:true},
		{field:'ItemBillType',title:'�ѱ�',width:100,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
		onClickRow:function(rowIndex, rowData){
	        
	        /// ����ע������
	        LoadItemTemp(rowData.ItemExaID);
	    },
		onLoadSuccess:function(data){

			//itemSelFlag = 1;    /// ��ѡ�б�ǰ״ֵ̬
			GetExaReqItmCost();   /// �����������ܽ��

		},
		rowStyler:function(index,rowData){   
	        if (rowData.ItemStat == "ֹͣ"){
	            return 'background-color:Pink;'; 
	        }
	        if (rowData.ItemStat == "ִ��"){
	            return 'background-color:#99FFFF;'; 
	        } 
	    },
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭

	    	if (rowData.ItemID != "") return;
            if (editSelRow != ""||editSelRow == 0) { 
                $("#ItemSelList").datagrid('endEdit', editSelRow); 
            } 
            $("#ItemSelList").datagrid('beginEdit', rowIndex); 
            
            editSelRow = rowIndex; 
            
			///���ü���ָ��
			var ed=$("#ItemSelList").datagrid('getEditor',{index:rowIndex,field:'ItemLoc'});
			var unitUrl=$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+rowData.ItemExaID;
			$(ed.target).combobox('reload',unitUrl);
			
			///���ü���ָ�� �걾  sufan 2018-02-02
			///���ñ걾
			var ed=$("#ItemSelList").datagrid('getEditor',{index:rowIndex,field:'ItemSpec'});
			var unitUrl=$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonArcItemSpec&itmmastid="+rowData.ItemExaID;
			$(ed.target).combobox('reload',unitUrl);
        }
	};

	var uniturl = ""; //$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqDetList";
	new ListComponent('ItemSelList', columns, '', option).Init(); 
}

/// ����
function SetCellOpUrl(value, rowData, rowIndex){
	
	/*
	if ((rowData.ItemStat == "ֹͣ")||(rowData.ItemStat == "ִ��")||(rowData.OpCellFlag == "1")){
		 return "";
	}*/
	/// ҽ��վ�������棬�޲�λʱ����ʾ��������
	if ((rowData.ItemExaPartID == "")&(DocMainFlag == 1)){
		 return "";
	}
	if ((rowData.ItemStat == "ֹͣ")||(rowData.ItemStat == "ִ��")){
		 return "";
	}
	if (rowData.ItemID == ""){
		var html = "<a href='#' onclick='delItmSelRow("+rowIndex+")'>ɾ��</a>";
	}else{
		var html = "<a href='#' onclick='revItmSelRow("+rowIndex+")'>����</a>";
	}
    return html;
}

/// ɾ����
function delItmSelRow(rowIndex){
	
	$.messager.confirm('ȷ�϶Ի���','ȷ��Ҫɾ��������', function(r){
		if (r){
			/// �����༭��
			if (editSelRow != -1||editSelRow == 0) {
				$("#ItemSelList").datagrid('endEdit', editSelRow); 
			}
			/// ɾ�������Ŀ
			var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
			/// ɾ����
			$("#ItemSelList").datagrid('deleteRow',rowIndex);
			var arExaItmID = rowData.ItemExaID.replace("||","_"); /// �����Ŀ
			/// ȡ�������Ŀ��ѡ��
			if ($("#"+arExaItmID).is(":checked")){
				$("#"+arExaItmID).attr("checked",false);
			}
			GetExaReqItmCost();   ///  �����������ܽ��
			$("#noteContent").html(""); /// ��Ŀɾ��ʱ��ͬʱ���ע��������
		}
	});
}

/// ����
function revItmSelRow(rowIndex){
	
	var revTipMessage = "ȷ��Ҫ����������";
	if (GetPartTarFlag(rowIndex) == "Y"){
		revTipMessage = "��ҽ��������λ�ۼ��շ����ѼƷѣ�����ֻ�ܳ������в�λ���Ƿ������";
	}
	$.messager.confirm('ȷ�϶Ի���',revTipMessage, function(r){
		if (r){
			/// ɾ�������Ŀ
			var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
			if (rowData.ItemBilled == "P"){
				$.messager.alert("��ʾ:","��Ŀ���շѣ�����������");
				return;
			}
			if (rowData.ItemStat == "ֹͣ"){
				$.messager.alert("��ʾ:","��ǰ��¼��ֹͣ�������ٴγ�����");
				return;
			}
			if (rowData.ItemStat == "ִ��"){
				$.messager.alert("��ʾ:","��ǰ��¼��ִ�У����ܳ�����");
				return;
			}
			revExaReqItm(rowData.ItemArcID,rowData.ItemExaID,rowData.ItemExaPartID);
			GetExaReqItmCost();   ///  �����������ܽ��
			//$("#dgEmPatList").datagrid("reload");   /// ˢ��ҳ������
			/// ���ø���ܺ���
			window.parent.frames.reLoadEmPatList();
			/// ����ǩ������
			window.parent.frames.TakeDigSignRev(rowData.ItemExaID, "E");
		}
	});
}

/// ����ִ��ѡ����Ŀ
function revExaReqItm(arReqItmID,itmmastid,PartID){
	
	if (arReqItmID == "") return;
	runClassMethod("web.DHCAPPExaReport","revExaReqItm",{"arRepItmID":arReqItmID, "PartID":PartID, "LgParam":LgUserID+"^"+LgCtLocID+"^"+LgGroupID},function(jsonString){
		
		if (jsonString == 1){
			$.messager.alert("��ʾ:","��Ŀ��ִ�У�����������");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","��Ŀ���շѣ�����������");
			return;
		}
		if (jsonString == -3){
			$.messager.alert("��ʾ:","ִ�м�¼�ѽ������ɣ�����ִ�иò�����");
			return;
		}
		if ((jsonString == -4)||(jsonString == -302)){
			$.messager.alert("��ʾ:","��ʿ��ִ�У����ܳ�����");
			return;
		}
		if (jsonString == -5){
			$.messager.alert("��ʾ:","�û���Ȩ�޳���ҽ����");
			return;
		}
	    if (jsonString < 0){
			$.messager.alert("��ʾ:","ɾ������,������Ϣ:"+jsonString);
			return;
		}
		if (jsonString == 0){
			$("#ItemSelList").datagrid("reload");   /// ˢ��ҳ������
		}
	
	},'',false)
}

/// �շ���Ŀ��ϸ
function SetCellTarUrl(value, rowData, rowIndex){
	
	if (rowData.ItemStat == "ֹͣ") return "";
	var params = rowData.ItemExaID +"^"+ rowData.ItemExaPartID +"^"+ pid;
	var html = "<a href='#' onclick='showTarItmWin(\""+ params +"\")'>��ϸ</a>";
    return html;
}

/// ���ؼ�鷽���б�
function LoadCheckItemList(itemCatID){
	
	/// ��ʼ����鷽������
	$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaItemList",{"TraID":itemCatID},function(jsonString){

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
		htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:0px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// ��Ŀ
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px"><input id="'+ itemArr[j-1].value +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itemobj.id +'"  data-emtype="'+ itemArr[j-1].title +'"></input></td><td>'+ itemArr[j-1].text +'</td>'); // qunianpeng 2018/3/20 ����title
		if (j % 3 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
		/// ҽ���������ʱ,��ʼ������
		if (DocMainFlag == 1){
			/// ���ڷ���ʱ���жϷ�����Ŀ�Ƿ��뿪����Ŀһֱ
			mItmMastDocArr.push(itemArr[j-1].value +"*"+ itemArr[j-1].text);
		}
	}
	if ((j-1) % 3 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(htmlstr+itemhtmlstr)
}

/// ҳ��Combobox��ʼ����
function initCombobox(){

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";

	/// ���տ���
	var option = {
	    onLoadSuccess: function () {
		    //���ݼ�������¼�
	        var data = $("#ExaRecloc").combobox('getData');
	        if (data.length > 0) {
	            //$("#ExaRecloc").combobox('select', data[0].value);
	        }
	    }
	}
	new ListCombobox("ExaRecloc",'','',option).init();
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	$("#itemList").on("click",".checkbox",selectExaItem);
	
	///  ȷ��
	$('a:contains("ȷ��")').bind("click",addItmToItmSelListNew);
	
	///  ȡ��
	$('a:contains("ȡ��")').bind("click",closeWin);
	
}

/// ������Ŀ
function LoadItmOtherOpt(itmmastid){

	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqOtherOpt",{"pid":pid, "itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			pid = jsonString;
			//showItemOtherOpt();  /// ע�� bianshuai 2016-08-09 
		}
	},'',false)
}

/// ���ͼ������
function sendExaReq(){
	
	/// ����ǩ������
	if (!window.parent.frames.isTakeDigSign()) return;
	
	/// ����ǰ����֪ʶ��
	//if (InvokItmLib() != true) return;
	
	/// סԺ��������Ѻ�����
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$.messager.alert("��ʾ:",PatArrManMsg);
		return;	
	}
	
	/// ���ͼ������
	sendExaReqDetail(); 
}

/// ���ͼ������
function sendExaReqDetail(){
	
	/// ҽ���������ʱ��ִ�����滹��
	if (DocMainFlag == 1){
		sureExaReq();
		return;
	}

	if (editSelRow != -1||editSelRow == 0) {
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	}

	var itemLocFlag = 0; itemSpecFlag = 0;
	//var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// �Ӽ� qunianpeng 2018/3/20 �Ƶ���Ŀ�б�
	var mItmListData = [];
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		
		var ItemID = selItem.ItemID;               /// ��ĿID
		var itmmmastid = selItem.ItemExaID;        /// ҽ����ID
		var itemLocID = selItem.ItemLocID;         /// ���տ���ID
		var itemLoc = selItem.ItemLoc;             /// ���տ���
		if ((itemLocID == "")||((itemLoc == "")||(typeof itemLoc == "undefined"))){
			itemLocFlag = 1;
			return false;
		}

		var itemExaPurp = selItem.ItemLabel;	   /// ���Ŀ��
		var itemRemark = selItem.ItemRemark;	   /// ��ע
		var itemSpecCode = selItem.ItemSpecCode;   /// �걾
		if (itemSpecCode == ""){
			itemSpecFlag = 1;
			return false;
		}
		var arEmgFlag = $("#CK_EmFlag"+index).is(":checked")? "Y":"N";   /// �Ӽ� ƴ��ҽ������Ϣ���� qunianpeng 2018/3/20
		var itemBillTypeID = selItem.ItemBillTypeID; /// �ѱ�
		
		var ListData = ItemID +"#"+ EpisodeID +"^"+ itemLocID +"^"+ "" +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ "" +"^"+ "" +"^"+ LgCtLocID +"^"+ "" +"^"+ "Y";
			ListData = ListData +"#"+ itmmmastid +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ itemRemark +"^"+ itemSpecCode +"^"+ arEmgFlag +"^"+ itemBillTypeID;

		mItmListData.push(ListData);
	})
	if (itemLocFlag == 1){
		$.messager.alert("��ʾ:","���տ��Ҳ���Ϊ�գ�");
		return;
	}
	if (itemSpecFlag == 1){
		$.messager.alert("��ʾ:","������Ŀ�걾����Ϊ�գ�");
		return;
	}
	
	mItmListData = mItmListData.join("!!");
	if (mItmListData == ""){
		$.messager.alert("��ʾ:","û�д�������Ŀ,��ѡ������Ŀ�����ԣ�");
		return;
	}

	/// ����ģ������
	runClassMethod("web.DHCAPPExaReport","save",{"pid":pid, "ListData":mItmListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			if (CloseFlag != ""){
				window.parent.frames.InvMainFrame(); /// ���ø���ܺ���
			}else{
				arExaReqIdList = jsonString;
				//printCom(arExaReqIdList);
				$.messager.alert("��ʾ:","���ͳɹ�");
				$("#ItemSelList").datagrid("load",{"params":arExaReqIdList});
				/// ���ø���ܺ���
				window.parent.frames.reLoadEmPatList();
				/// ����ǩ������
				window.parent.frames.TakeDigSign(arExaReqIdList, "E");
				/// ���Ӳ�����ܺ���
				window.parent.frames.InvEmrFrameFun();
			}
		}
	},'',false)
}

/// ������Ŀ
function insHtmlTable(itemobj){

	/// ��ȡ���table���һ��td����
	var tdnum = $("#TmpOtherOpt tr:last td").length;
	
	var htmlstr = '<td align="right">'+ itemobj.itemdesc +'</td>';
	if (itemobj.itemtype == "Check"){
		htmlstr = htmlstr + '<td style="width:120px"><input id="'+ itemobj.itemid +'" name="'+ itemobj.itemtype +'" type="checkbox" value="Y"/></td>';
	}else{
		htmlstr = htmlstr + '<td style="width:120px"><input id="'+ itemobj.itemid +'" name="'+ itemobj.itemtype +'" style="width:120px;"/></td>';
	}

	/// ����λ��
	if ((tdnum == 0)||(tdnum == 4)){
		htmlstr = '<tr>' + htmlstr + '</tr>';
		$("#TmpOtherOpt").append(htmlstr);
	}else{
		$("#TmpOtherOpt tr:last").append(htmlstr);
	}
	
	/// ���� Combox
	if (itemobj.itemtype == "Combox"){
		var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonOtherOptSubItm&itemid="+ itemobj.itemid;
		var option = {
			panelHeight:"auto",
	        onSelect:function(option){

	        	/// ������ʱ����
				runClassMethod("web.DHCAPPExaReportQuery","setExaOtherOpt",{"pid":pid, "id":this.id, "type":"Combox", "val":option.value},function(jsonString){})
		    }
		};
		new ListCombobox(itemobj.itemid,uniturl,'',option).init();
	}
	
	/// ���سɹ���,������ʱ����
	if (itemobj.itemtype == "Check"){
		$("#"+ itemobj.itemid).attr("checked",itemobj.itemval=="Y"?true:false);
	}
	if (itemobj.itemtype == "Combox"){
		$("#"+ itemobj.itemid).combobox("setValue",itemobj.itemval);;
	}
	if (itemobj.itemtype == "Input"){
		$("#"+ itemobj.itemid).val(itemobj.itemval);
	}
}

///  ������Ŀ��ֵ
function setOtherOpt(){
	
	var val = "";
	if (this.name == "Check"){
		val = $(this).is(':checked')?"Y":"N";
	}

	if (this.name == "Input"){
		val = $(this).val();
	}

	/// ������ʱ����
	runClassMethod("web.DHCAPPExaReportQuery","setExaOtherOpt",{"pid":pid, "id":this.id, "type":this.name, "val":val},function(jsonString){})
}

/// ���ؽ��տ���
function LoadArcItemRecLoc(arItemID){

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";
    /// ���ؽ��տ���
    var url = uniturl+"jsonExaCatRecLoc&EpisodeID="+ EpisodeID +"&arItmmastID="+ arItemID;
    $("#ExaRecloc").combobox('reload', url);
}

/// ���ؽ��տ���
function LoadArcItemRecLocNew(arItemID){

	runClassMethod("web.DHCAPPExaReportQuery","jsonExaCatRecLoc",{"EpisodeID":EpisodeID,"arItmmastID":arItemID},function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			$("#ExaRecloc").combobox('loadData',jsonString); 
			for(var i=0;i<jsonObjArr.length;i++){
				if (jsonObjArr[i].deftyle == "Y"){
					$("#ExaRecloc").combobox('select', jsonObjArr[i].value);
				}
			}     
		}
	},'json',false)
}

/// ��ѯ�����Ŀ
function findExaItemList(event){
	
	if(event.keyCode == "13"){
		var ExaItmCode=$.trim($("#ExaItmCode").val());
		var node = $("#CheckPart").tree('getSelected');
		var isLeaf = $("CheckPart").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
        if (isLeaf){
	        var params = node.id +"^"+ "" +"^"+ ExaItmCode;
			$("#ItemList").datagrid("load",{"params":params});
        }
        /*
		var node = $("#CheckPart").tree('getSelected');
        if (node.id.indexOf("^") != "-1"){
			var params = node.id +"^"+ ExaItmCode;
			$("#ItemList").datagrid("load",{"params":params});
        }
        */
	}
}

/// ����Ƿ��������ͬ��Ŀ
function isExistItem(ItemLabel){
	
	var isExistItem = false;
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if (selItem.ItemLabel == ItemLabel){
			isExistItem = true;
			return false;
		}
	})
	return isExistItem;
}

/// ��ӡ���뵥
function printExaReq(flag){
	
	var arReqArr=arExaReqIdList.split("^");
	for (var i=0;i<arReqArr.length;i++){
		window.parent.frames.PrintBar(arReqArr[i],flag)
	}
	
	//window.parent.frames.PrintBar(arExaReqIdList,flag);
	//printReq(arExaReqIdList);   /// ���ô�ӡ����
}

/// ��ȡ���뵥�ܷ���
function GetExaReqItmCost(){

	var mItmListData=[];
	var arRepID = "";
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#ItemSelList').datagrid('refreshRow', index); /// ˢ�µ���
		
		arRepID = selItem.ItemID;                  /// ��ĿID
		var itmmmastid = selItem.ItemExaID;        /// ҽ����ID
		var itemExaPosiID = selItem.ItemExaPosiID; /// ��λID
		var itemExaPartID = selItem.ItemExaPartID; /// ��λID
		var itemExaDispID = selItem.ItemExaDispID; /// ����ID
		
		if (selItem.ItemStat == "ֹͣ") return;
		
		mItmListData.push(itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID);
	})

	mItmListData = mItmListData.join("&&");

	if (mItmListData == ""){
		$("#arExaReqCost").text(0 +"Ԫ");
		return;
	}

	var ListData = arRepID +"^"+ EpisodeID +"^"+ pid +"#"+ mItmListData;

	/// ����ģ������
	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqItmCost",{"ListData":ListData},function(jsonString){
		if (jsonString > 0){
			var arExaReqCost = jsonString;
			$("#arExaReqCost").text(arExaReqCost +"Ԫ");
		}
	},'',false)
}

/// ������뵥�Ƿ��п�ԤԼ��Ŀ
function isExistNeedAppItm(arReqID){
	
	var AppFlag = false;
	runClassMethod("web.DHCEMInterface","GetExaReqAppFlag",{"arReqID":arReqID},function(jsonString){
		if (jsonString == "Y"){
			AppFlag = true;
		}
	},'',false)
	
	return AppFlag;
}

///  �����Ŀ����ѡ�б�
function addItmToItmSelList(rowIndex){
	
	/// ��ѡ�б�ǰ״ֵ̬
	if (itemSelFlag == "1"){
		itemSelFlag = "";
		$("#ItemSelList").datagrid('loadData',{total:0,rows:[]});
	}
	
	/// ����ж�
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("��ʾ:","����û�����,����¼�룡","",function(){DiagPopWin()});
		return;	
	}

	/// ҽ�ƽ����ж�
	if (GetIsMidDischarged() == 1){
		$.messager.alert("��ʾ:","�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����");
		return;	
	}

	/// ��֤�����Ƿ�����ҽ��
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg);
		return;	
	}
		
	/// ��鷽��
	var rowData=$("#itemList").datagrid('getData').rows[rowIndex];
		
	var itmmmastid = rowData.ItemID;         /// ID
	var itmmmastdesc = rowData.ItemDesc;     /// ����
	var itmmmastprice = rowData.ItemPrice;   /// �۸�
	var arExaPartID = rowData.ItemPartID;    /// ��λID
	var arExaPartDesc = rowData.ItemPart;    /// ��λ����

	/// ҽ�����Ա�/��������
	var LimitMsg = GetItmLimitMsg(itmmmastid)
	if (LimitMsg != ""){
		$.messager.alert("��ʾ:","��Ŀ��" +itmmmastdesc+ "��������ʹ�ã�" + LimitMsg);
		return;	
	}
		
	/// ���տ���
	var ExaReclocID = ""; var ExaRecloc = "";
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmmastid},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			ExaReclocID = jsonObjArr[0].value;
			ExaRecloc = jsonObjArr[0].text;
		}
	},'json',false)
	
	var ItemLabel = itmmmastdesc;

	var ItemLabelArr = [];
	if (arExaPartDesc !="" ){
		ItemLabelArr.push(arExaPartDesc);
	}
	if (ItemLabelArr.join("��") != ""){
		ItemLabel = ItemLabel + "[" + ItemLabelArr.join("��") + "]";
	}

	if (isExistItem(ItemLabel)){
		$.messager.alert("��ʾ:","�Ѵ�����ͬ��Ŀ,���ʵ�����ԣ�");
		return false;
	}

	/// ������ѡ�б�
	var rowobj={ItemID:"", ItemArcID:"", ItemLabel:ItemLabel, ItemExaID:itmmmastid, ItemPrice:itmmmastprice, ItemLocID:ExaReclocID, ItemLoc:ExaRecloc,
	ItemExaPartID:arExaPartID, ItemExaDispID:'', ItemExaPosiID:'',ItemExaPurp:ItemLabel, ItemOpt:'', ItemRemark:'', ItemStat:"��ʵ"}
	$("#ItemSelList").datagrid('appendRow',rowobj);

	/// ������Ŀ
    LoadItmOtherOpt(itmmmastid);
    
	GetExaReqItmCost();   ///  �����������ܽ��
}

/// ɾ����Ŀ
function delItmFromItmSelList(rowIndex){
	
	var rowData=$("#itemList").datagrid('getData').rows[rowIndex];
		
	var itmmmastid = rowData.ItemID;         /// ID
	var arExaPartID = rowData.ItemPartID;    /// ��λID
	
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if ((selItem.ItemExaID == itmmmastid)&(selItem.ItemExaPartID == arExaPartID)){
			/// ɾ����
			$("#ItemSelList").datagrid('deleteRow',index);
			GetExaReqItmCost();   ///  �����������ܽ��
			return false;
		}
	})
}

/// ��ǰ��Ŀ�Ƿ��Ѿ���ӵ���Ŀ�б�
function GetCurItmIsSelect(itmmmastid, arExaPartID){
	
	var IsSelect = false;
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if ((selItem.ItemExaID == itmmmastid)&(selItem.ItemExaPartID == arExaPartID)){
			IsSelect = true;
			return false;
		}
	})
	return IsSelect;
}

/// ѡ�м����Ŀ
function selectExaItem(){
	
	if ($(this).is(':checked')){
		
		/// ����ж�
		if (GetMRDiagnoseCount() == 0){
			$.messager.alert("��ʾ:","����û�����,����¼�룡","",function(){DiagPopWin()});
			$(this).attr("checked",false);
			return;	
		}
		
		/// ҽ�ƽ����ж�
		if (GetIsMidDischarged() == 1){
			$.messager.alert("��ʾ:","�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����");
			$(this).attr("checked",false);
			return;	
		}
		
		/// ��֤�����Ƿ�����ҽ��
		if (TakOrdMsg != ""){
			$.messager.alert("��ʾ:",TakOrdMsg);
			$(this).attr("checked",false);
			return;	
		}
		
		/// ��鷽����ҽ����ID��ҽ�������ơ�
		var arExaItmID = this.id;    /// ��鷽��ID
		var arExaItmDesc = $(this).parent().next().text(); /// ��鷽��
		var arExaCatID = this.value; /// ������ID
		var arEmgFlag = $(this).attr("data-emtype");	 /// ���ӼӼ���־  qunianpeng 2018/3/20		

		/// ��ȡҽ��¼ҽ��Ȩ��
		if (GetDocPermission(arExaItmID) == 1){
			$.messager.alert("��ʾ:","��û��Ȩ��¼���ҽ����");
			$(this).attr("checked",false);
			return;	
		}
				
		/// ��֤�����Ƿ�����ҽ��
		var ErrObject = GetPatNotTakOrdMsgArc(arExaItmID);
		if (ErrObject.ErrMsg != ""){
			$.messager.alert("��ʾ:",ErrObject.ErrMsg,"info");
			if (ErrObject.ErrCode != 0){
				$(this).attr("checked",false);
			}
			return;
		}
		
		/// ҽ�����Ա�/��������
		var LimitMsg = GetItmLimitMsg(arExaItmID)
		if (LimitMsg != ""){
			$.messager.alert("��ʾ:","��Ŀ��" +arExaItmDesc+ "��������ʹ�ã�" + LimitMsg);
			$(this).attr("checked",false);
			return;	
		}
		
		if (arExaReqIdList != ""){
			$.messager.confirm('��ʾ','���뵥�ѷ��Ͳ���������Ŀ���Ƿ��������뵥��', function(b){
				if (b){
					PageEditFlag(1);  /// �������ý���༭״̬
					/// ׼����Ӽ����Ŀ
					attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag); ///���ӼӼ���־  qunianpeng 2018/3/20
				}else{
					/// ȡ����Ŀѡ��״̬
					$("#"+arExaItmID).attr("checked",false);
				}
			})
		}else{
			/// ׼����Ӽ����Ŀ
			attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag);  ///���ӼӼ���־  qunianpeng 2018/3/20
		}
	}else{
		
		var arExaItmID = this.id;    /// ��鷽��ID
		var arExaItmID = arExaItmID.replace("_","||");
	
		/// ɾ����
		var selItems=$("#ItemSelList").datagrid('getRows');
		$.each(selItems, function(rowIndex, selItem){
			if ((selItem.ItemExaID == arExaItmID)&(selItem.ItemExaPartID == "")){
				/// ɾ����
				$("#ItemSelList").datagrid('deleteRow',rowIndex);			
				$("#noteContent").html(""); /// ��Ŀɾ��ʱ��ͬʱ���ע��������			
			}
		})
		GetExaReqItmCost();   ///  �����������ܽ��
	}
	
}

/// ׼����Ӽ����Ŀ
function attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag){ /// ���ӼӼ���־  qunianpeng 2018/3/20
	
		/// �����ѡ��Ŀ�б�
		if (arExaReqIdList != ""){
			$("#ItemSelList").datagrid('loadData',{total:0,rows:[]});
			arExaReqIdList = "";
		}
		
		/// ҽ���������ʱ,ȡֵ��ʽ
		if (DocMainFlag == 1){
			mItmMastStr = arExaItmID;      /// ��ʱ�洢��鷽��
			arExaItmID = arExaItmID.split("*")[3];
		}
		
		runClassMethod("web.DHCAPPExaReportQuery","isExistLinkPart",{"itmmastid":arExaItmID,"TraID":arExaCatID,"HospID":LgHospID},function(isLinkPart){
		
			if (isLinkPart != ""){
				if (isLinkPart == 1){
					//createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc);  /// ��Ŀ��ѡ��λ��������λ����
				}else{
					if (IsRepeatOneday(arExaItmID,"") == 1){
						if (PatType != "I"){
							$.messager.alert("��ʾ:", "�����Ѿ�������ͬҽ��,������������!","warning");
							return;
						}
						$.messager.confirm('ȷ�϶Ի���','�����Ѿ�������ͬҽ���Ƿ������ӣ�', function(r){
							if (r){
								addExaItem(arExaItmID,arExaItmDesc,arEmgFlag);          /// ��Ӽ����Ŀ  ���ӼӼ���־  qunianpeng 2018/3/20
							}else{
								/// ȡ�������Ŀ��ѡ��
								if ($("#"+arExaItmID).is(":checked")){
									$("#"+arExaItmID).attr("checked",false);
								}
							}
						});
					}else{
						addExaItem(arExaItmID,arExaItmDesc,arEmgFlag);          /// ��Ӽ����Ŀ    ���ӼӼ���־  qunianpeng 2018/3/20
					}
				}
			}
		},'',false)
}

/// ��Ӽ����Ŀ
function addExaItem(arExaItmID,arExaItmDesc,arEmgFlag){ /// ���ӼӼ���־  qunianpeng 2018/3/20
    var arExaItmID = arExaItmID.replace("_","||");
	/// ���տ���
	var ItemLocID = ""; var ItemLoc = "";
	/// ҽ���������ʱ,ȡֵ��ʽ
	if (DocMainFlag == 1){
		var LocID = mItmMastStr.split("*")[1];
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmRecLoc",{"LocID":LocID},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}else{
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}
	
	/// �걾
	var ItemSpecCode = ""; var ItemSpec = ""; var HavFlag = "";
	runClassMethod("web.DHCAPPExaReportQuery","jsonGetArcItmSpec",{"itmmastid":arExaItmID, "isDefFlag":"Y"},function(jsonString){
	
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			ItemSpecCode = jsonObjArr[0].value;
			ItemSpec = jsonObjArr[0].text;
		}
	},'json',false)
	if (ItemSpecCode == "-1"){
		$.messager.alert("��ʾ:", "����걾û��ά����ȷ��");
		return false;	
	}
	
	if (isExistItem(arExaItmDesc)){
		$.messager.alert("��ʾ:","�Ѵ�����ͬ��Ŀ,���ʵ�����ԣ�");
		return false;
	}

	var arReqDate  = "", uniqueID = ""; //arEmgFlag = ""; ע��arEmgFlag qunianpeng 2018/3/20
	/// ҽ���������ʱ,ȡֵ��ʽ
	if (DocMainFlag == 1){
		arEmgFlag = mItmMastStr.split("*")[0];  /// �Ӽ���־
		arReqDate = mItmMastStr.split("*")[2];  /// ҽ������
		uniqueID = mItmMastStr.split("*")[4];   /// Ψһ��ʾ
	}
	
	/// �ѱ�
	var BillTypeID = "", BillType = "";
	if (typeof window.parent.frames.BillTypeID != "undefined"){
		BillTypeID = window.parent.frames.BillTypeID;  ///�ѱ�ID
		BillType = window.parent.frames.BillType;      ///�ѱ�
	}
	
	/// ������ѡ�б�
	var rowobj={ItemID:"", ItemArcID:"", ItemLabel:arExaItmDesc, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:'', 
	ItemExaDispID:'', ItemExaPosiID:'',ItemExaPurp:arExaItmDesc, ItemOpt:'', ItemStat:"��ʵ", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, 
	ItemEmgFlag:arEmgFlag, ItemRemark:'', ItemSpecCode:ItemSpecCode, ItemSpec:ItemSpec, ItemBillTypeID:BillTypeID,ItemBillType:BillType}
	$("#ItemSelList").datagrid('appendRow',rowobj);
    
    /// ������Ŀ
    LoadItmOtherOpt(arExaItmID);
    
	GetExaReqItmCost();   ///  �����������ܽ��
}

/// ������Ŀ�б�
function addItmSelList(id, text){

	var rowobj={ItemID:id, ItemPart:text, ItemPosiID:'', ItemPosi:'', ItemOpt:''}
	$("#dmPartList").datagrid('appendRow',rowobj);
	
	/// �����б༭     /// 2016-12-14 bianshuai �������б༭
	var rowsData=$("#dmPartList").datagrid('getRows');
	$("#dmPartList").datagrid('beginEdit', rowsData.length - 1);
}

///  �����Ŀ����ѡ�б�
function addItmToItmSelListNew(){

//	/// �����༭
//    if (editRow != ""||editRow == 0) { 
//        $("#dmPartList").datagrid('endEdit', editRow); 
//    }

//	/// ��鷽����ҽ����ID��ҽ�������ơ�
//	var arExaItmID = "",arExaItmDesc = "";
//	if ($('input[name="ExaItem"]:checked').length){
//		arExaItmID = $('input[name="ExaItem"]:checked').val();                     /// ��鷽��ID
//		arExaItmDesc = $('input[name="ExaItem"]:checked').parent().next().text();  /// ��鷽��
//	}
	var arExaItmID = $("#arExaItmID").text();     /// ��ʱ�洢��鷽��ID
	var arExaItmDesc = $("#arExaItmDesc").text(); /// ��ʱ�洢��鷽��
	var arExaItmID = arExaItmID.replace("_","||");
	
	/// ���տ���
	var ItemLocID = ""; var ItemLoc = "";
	/// ҽ���������ʱ,ȡֵ��ʽ
	if (DocMainFlag == 1){
		var LocID = mItmMastStr.split("*")[1];
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmRecLoc",{"LocID":LocID},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}else{
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}
	
	/// ��鸽����Ϣ
	var rows=$("#dmPartList").datagrid('getRows');
	if (rows.length == 0){
		$.messager.alert("��ʾ:","����ѡ��λ��");
		return;
	}
	
	$.each(rows, function(index, rowData){
		
		/// �����༭
		$("#dmPartList").datagrid('endEdit', index); 
		
		var arExaPartID = rowData.ItemID;         /// ��λID
		var arExaPartDesc = rowData.ItemPart;     /// ��λ
		var arExaPosiID = rowData.ItemPosiID;     /// ��λID
		var arExaPosiDesc = rowData.ItemPosi;     /// ��λ
		var arExaRemark = rowData.ItemRemark;     /// ��ע

		var ItemLabel = arExaItmDesc;  /// �����Ŀ����
		
		/// ������
		var arExaDispID = [],arExaDispDesc = [];
		$('input[name="ExaDisp"]:checked').each(function(){
			arExaDispID.push(this.value);
			arExaDispDesc.push($.trim($(this).parent().next().text()));
		})
		arExaDispID = arExaDispID.join("@");
		arExaDispDesc = arExaDispDesc.join("��");
	
		var ItemLabelArr = [];
		
		if (arExaDispDesc != "" ){
			ItemLabel = ItemLabel +" + "+ $.trim(arExaDispDesc);
		}
		if (arExaPartDesc !="" ){
			if (arExaPosiDesc != ""){
				arExaPartDesc = arExaPartDesc +"("+ arExaPosiDesc +")";
			}
			ItemLabelArr.push(arExaPartDesc);
		}
		if (ItemLabelArr.join("��") != ""){
			ItemLabel = ItemLabel + "[" + ItemLabelArr.join("��") + "]";
		}

		if (isExistItem(ItemLabel)){
			$.messager.alert("��ʾ:","�Ѵ�����ͬ��Ŀ,���ʵ�����ԣ�");
			return false;
		}
		
		var arReqDate  = "", uniqueID = "", arEmgFlag = "";
		/// ҽ���������ʱ,ȡֵ��ʽ
		if (DocMainFlag == 1){
			arEmgFlag = mItmMastStr.split("*")[0];  /// �Ӽ���־
			arReqDate = mItmMastStr.split("*")[2];  /// ҽ������
			uniqueID = mItmMastStr.split("*")[4];   /// Ψһ��ʾ
		}
		
		/// ������ѡ�б�
		var rowobj={ItemID:"", ItemArcID:"", ItemLabel:ItemLabel, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:arExaPartID, ItemExaDispID:arExaDispID, 
		ItemExaPosiID:arExaPosiID,ItemExaPurp:ItemLabel, ItemOpt:'', ItemStat:"��ʵ", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, ItemEmgFlag:arEmgFlag, ItemRemark:arExaRemark}
		$("#ItemSelList").datagrid('appendRow',rowobj);
		
	})
	
	clrItmChkFlag();   	  ///  ȡ�������Ŀѡ��״̬
	
	$("#dmPartList").datagrid('loadData',{total:0,rows:[]}); /// ���datagrid
	$('#PopUpWin').window("close");
    
	GetExaReqItmCost();   ///  �����������ܽ��
	
	/// ȷ�����֮��,����Ĭ�ϵ����߿�
	$('#arPatSym').focus();    /// ���ý���
}

/// �رյ�������
function closeWin(){
	
	var arExaItmID = $("#arExaItmID").text();
	/// ȡ�������Ŀѡ��Ч�� 
	$('#'+ arExaItmID).attr("checked",false);
	
	$("#arExaItmID").text("");     /// ��ʱ�洢��鷽��ID
	$("#arExaItmDesc").text("");   /// ��ʱ�洢��鷽��
	
	$('#PopUpWin').window("close");
}

/// ������Ŀ����
function LoadItmOtherOpot(arReqID, itmmastid){

	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqOthOpt",{"pid":pid, "arReqID":arReqID, "itmmastid":itmmastid},function(jsonString){

		if (jsonString != ""){
			pid = jsonString;
			//showItemOtherOpt();
		}
	},'',false)
	
}

/// ����ע������
function LoadItemTemp(itmmastid){

	$("#noteContent").html("");
	runClassMethod("web.DHCAPPExaReportQuery","jsonItemTemp",{"itmmastid" : itmmastid, "HospID" : LgHospID},function(jsonString){
		var jsonObjArr = jsonString;
		for (var i=0; i<jsonObjArr.length; i++){
			showItemTemp(jsonObjArr[i]);
		}
	},'json',false)
}

/// ����ע��������ʾ��ʽ
function showItemTemp(itemobj){
	
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="table_title">'+ itemobj.ItemTemp +'</div>';
		htmlstr = htmlstr + '<div style="border-bottom: 1px solid #40a2de;"></div>';
		htmlstr = htmlstr + '<table border="1" cellspacing="0" cellpadding="1" class="report_table">';
		htmlstr = htmlstr + '	<tr>';
		htmlstr = htmlstr + '		<td>';
		htmlstr = htmlstr + '			<div style="margin:10px 5px;font-size:15px;line-height:150%;">';
		htmlstr = htmlstr + '				<p>'+ itemobj.TempText.replace(/<br>/g,'</p><p>') +'</p>';
		htmlstr = htmlstr + '			</div>';
		htmlstr = htmlstr + '		</td>';
		htmlstr = htmlstr + '	</tr>';
		htmlstr = htmlstr + '</table>';
		
	$("#noteContent").append(htmlstr);
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

/// ��ȡҽ�ƽ����־
function GetIsMidDischarged(){

	var MidDischargedFlag = 0;
	/// ����ҽ��վ���ж�
	runClassMethod("web.DHCAPPExaReport","GetIsMidDischarged",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			MidDischargedFlag = jsonString;
		}
	},'',false)

	return MidDischargedFlag;
}

/// ��ȡҽ��¼ҽ��Ȩ��
function GetDocPermission(arExaItmID){

	var arcitemId = arExaItmID.replace("_","||");
	var DocPerFlag = 0;
	/// ����ҽ��¼ҽ��Ȩ��
	runClassMethod("web.DHCAPPExaReport","GetDocPermission",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID,"arcitemId":arcitemId},function(jsonString){

		if (jsonString == 1){
			DocPerFlag = jsonString;
		}
	},'',false)

	return DocPerFlag;
}

/// ��֤�����Ƿ�����ҽ��
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

/// ��֤�����Ƿ�����ҽ��
function GetPatNotTakOrdMsgArc(arExaItmID){

	var arcitemId = arExaItmID.replace("_","||");
	var ErrObject = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsgArc",{"EpisodeID":EpisodeID,"arcitemId":arcitemId},function(jsonString){

		if (jsonString != ""){
			ErrObject = jsonString;
		}
	},'json',false)

	return ErrObject;
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
	},'',false)

	return PatArrManMsg;
}

/// ��ʼ����鷽������
function LoadCheckItemByDoc(){

	var arcItemList=mListDataDoc.split("!")[1];
	mItmMastLen = arcItemList.split("@").length; /// ��Ŀ
	/// ��ʼ����鷽������ ������λ
	$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaItemListDoc",{"arcItemList":arcItemList,"LinkFlag":"1","HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
	
	/// ��ʼ����鷽������ ��������λ
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaItemListDoc",{"arcItemList":arcItemList,"LinkFlag":"0","HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			var itemArr = jsonObjArr[0].items;
			for (var i=0; i<itemArr.length; i++){
				//InitInsSelItem(itemArr[i]);  /// ������ѡ��Ŀ�б�
			}
		}
	},'json',false)
	
}

/// �������ȷ��
function sureExaReq(){
	
	if (editSelRow != -1||editSelRow == 0) { 
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	}

	var itemLocFlag = 0; var mItmMastArr = [];
	//var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// �Ӽ� qunianpeng 2018/3/20
	var mItmListData = [];
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		
		var ItemID = selItem.ItemID;               /// ��ĿID
		var itmmmastid = selItem.ItemExaID;        /// ҽ����ID
		var itemLocID = selItem.ItemLocID;         /// ���տ���ID
		var itemLoc = selItem.ItemLoc;             /// ���տ���
		if ((itemLocID == "")||((itemLoc == "")||(typeof itemLoc == "undefined"))){
			itemLocFlag = 1;
			return false;
		}
		var itemExaPosiID = selItem.ItemExaPosiID; /// ��λID
		var itemExaPartID = selItem.ItemExaPartID; /// ��λID
		var itemExaDispID = selItem.ItemExaDispID; /// ����ID

		///var itemExaPurp = selItem.ItemExaPurp;  /// ���Ŀ��
		var itemExaPurp = selItem.ItemLabel;	   /// ���Ŀ��
		var arReqDate = selItem.ItemReqDate;	   /// ҽ������
		var uniqueID = selItem.ItemUniqueID;	   /// Ψһ��ʾ
		var arEmgFlag = selItem.ItemEmgFlag;	   /// �Ӽ���־
		
		var itemRemark = selItem.ItemRemark;	   /// ��ע

		if ($.inArray(itmmmastid+"^"+uniqueID,mItmMastArr) == "-1"){
			mItmMastArr.push(itmmmastid+"^"+uniqueID);
		}
		
		var ListData = EpisodeID +"^"+ itemLocID +"^"+ arEmgFlag +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ "" +"^"+ "" +"^"+ LgCtLocID +"^"+ "" +"^"+ "N" ;
			ListData = ListData +"#"+ itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID +"^"+ arReqDate +"^"+ uniqueID +"^"+ arEmgFlag +"^"+ itemRemark;

		mItmListData.push(ListData);
	})
	
	/// ��Ŀ��һ��ʱ��������ʾ
	if (mItmMastArr.length != mItmMastLen){
		GetTmpItmMastTip(mItmMastArr);
		return;
	}
	
	if (itemLocFlag == 1){
		$.messager.alert("��ʾ:","���տ��Ҳ���Ϊ�գ�");
		return;
	}
	
	mItmListData = mItmListData.join("!!");

	if (mItmListData == ""){
		$.messager.alert("��ʾ:","û�д�������Ŀ,��ѡ������Ŀ�����ԣ�");
		return;
	}
	
	/// ����ģ������
	runClassMethod("web.DHCAPPExaReport","saveDoc",{"pid":pid, "ListData":mItmListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			window.returnValue = jsonString;
			window.close();
		}
	},'',false)
	

}

/// ȡ�������Ŀѡ��״̬
function clrItmChkFlag(){
	
	var arExaItmID = $("#arExaItmID").text();
	/// ȡ�������Ŀѡ��Ч�� 
	$('#'+ arExaItmID).attr("checked",false);
	
	$("#arExaItmID").text("");     /// ��ʱ�洢��鷽��ID
	$("#arExaItmDesc").text("");   /// ��ʱ�洢��鷽��
}

/// ��֤�����Ƿ�����ҽ��
function initPatNotTakOrdMsg(){
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg);
		return;	
	}
}

/// һ�����Ƿ��ظ����������Ŀ
function IsRepeatOneday(arExaItmID, PartID){

	var arcitemId = arExaItmID.replace("_","||");
	var isRepFlag = 0;
	/// ����ҽ��¼ҽ��Ȩ��
	runClassMethod("web.DHCAPPExaReport","IsRepeatOneday",{"EpisodeID":EpisodeID,"Inarcimid":arcitemId,"InPartID":PartID},function(jsonString){

		if (jsonString == 1){
			isRepFlag = jsonString;
		}
	},'',false)

	return isRepFlag;
}

/// ����֪ʶ������Ŀ
function InvokItmLib(){

	var del= String.fromCharCode(2);
	var mListData = [];
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		
		var itmmmastid = selItem.ItemExaID;        /// ҽ����ID
		var itemLocID = selItem.ItemLocID;         /// ���տ���ID
		var itemExaPosiID = selItem.ItemExaPosiID; /// ��λID
		var itemExaPartID = selItem.ItemExaPartID; /// ��λID
		var itemExaDispID = selItem.ItemExaDispID; /// ����ID

		var ListData =itmmmastid +"^"+ itemExaPartID;

		mListData.push(ListData);
	})
	mListData = mListData.join(del);

	if (mListData == ""){
		return;
	}

	var retFlag = false;
	/// �û���Ϣ
	var userInfo = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","InvokItemLibrary",{"EpisodeID":EpisodeID, "mListData":mListData, "userInfo":userInfo},function(jsonObj){
		if (jsonObj != null){
			if (jsonObj[0].passFlag == 1){
				retFlag = true;
			}else{
				retFlag = false;
				FunUpWin(jsonObj[0]);
			}
		}
	},'json',false)
	
	return retFlag;
}

/// ֪ʶ�����ݵ���
function FunUpWin(jsonObj){

	/// ����ҽ�����б���
	var option = {
		buttons:[{
				text:'ȷ��',
				iconCls:'icon-edit',
				handler:function(){
					if (jsonObj.manLevel == "W"){
						$('#FunUpWin').dialog('close');
						/// ���ͼ������
						sendExaReqDetail(); 
					}else{
						$.messager.alert("��ʾ:","��������ܿ���Ŀ���������ͣ�");
						return;
					}
				}
			},{
				text:'ȡ��',
				iconCls:'icon-cancel',
				handler:function(){
					$('#FunUpWin').dialog('close');
				}
			}]
	};
	//new WindowUX("֪ʶ������Ϣ", "FunUpWin", "760", "360" , option).Init();
	new DialogUX("֪ʶ������Ϣ", "FunUpWin", "760", "360" , option).Init();
	
	/// ��ʼ��֪ʶ����Ϣ����
	initMedLibTip(jsonObj); 
}

/// ��ʼ��֪ʶ����Ϣ����
function initMedLibTip(jsonObj){
	
	$("#TmpFunLib").html("");
	var htmlstr = '';
	var itmArr = jsonObj.retMsg;
	    htmlstr = "<div class='libtitle' style='border-bottom: 1px solid #ccc;padding-top: 3px;'>��["+itmArr.length+"]��</div>";
	for(var i=0; i<itmArr.length; i++){
		var bkcolor = "#DDDDDD";
		if (itmArr[i].level == "C"){
			bkcolor = "red";
		}
		htmlstr = htmlstr + "<div class='table_title' style='margin:5px 0 0 7px;border-bottom: 1px solid #ccc;	font-weight:bold;padding: 3px 0 0 5px;background-color:"+ bkcolor +"'>��"+(i+1)+"��</div>";
		htmlstr = htmlstr + "<table  cellpadding='0' cellspacing='0' class='medicontTb'><tr><td style='background-color:#F6F6F6;width:120px' >�������Ŀ��</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+itmArr[i].geneDesc+"["+itmArr[i].pointer+"]</td></tr>";
		var itmSubArr = itmArr[i].chlidren;
		for(var j=0; j<itmSubArr.length; j++){
			htmlstr = htmlstr + "<tr><td style='background-color:#F6F6F6;width:120px;' >��"+itmSubArr[j].labelDesc+"��</td><td style='border-right:solid #E3E3E3 1px' colspan='2' >"+itmSubArr[j].alertMsg+"</td></tr>";
		}
		htmlstr = htmlstr + "</table>";
	}
    $("#TmpFunLib").append(htmlstr);
}

/// ������ϴ���
function DiagPopWin(){
	
	var PatientID = $("#PatientID").text();  /// ����ID
	var mradm = $("#mradm").text();			 /// �������ID

	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	//window.open(lnk,"_blank","top=100,left=100,width=700,height=350,menubar=yes,scrollbars=no,toolbar=no,status=no");
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

/// �жϷ�����Ŀ�Ƿ��뿪����Ŀһ��ʱ����ʾ����
function GetTmpItmMastTip(mItmMastArr){
	
	var TmpItmMastTipArr = [];
	for(var x=0;x<mItmMastLen;x++){
		var itmmmastid = mItmMastDocArr[x].split("*")[3]; /// ҽ����ID
		var itmmmastid = itmmmastid.replace("_","||");
		var uniqueID = mItmMastDocArr[x].split("*")[4];	  /// Ψһ��ʾ
		var itmmmast = mItmMastDocArr[x].split("*")[5];   /// ��Ŀ����
		if ($.inArray(itmmmastid+"^"+uniqueID,mItmMastArr) == "-1"){
			TmpItmMastTipArr.push(itmmmast);
		}
	}
	$.messager.alert("��ʾ:","��Ŀ��"+TmpItmMastTipArr.join("��")+"δѡ��λ������ѡ��λ��");
	return;
}

/// ȡ��������Ƿ���Ե���λ������־
function GetPartTarFlag(rowIndex){
	
	var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
	rowData.ItemArcID
	var PartTarFlag = 0;
	/// ����ҽ��¼ҽ��Ȩ��
	runClassMethod("web.DHCAPPExaReport","GetPartTarFlag",{"arPartID":rowData.ItemArcID},function(jsonString){

		PartTarFlag = jsonString;
	},'',false)

	return PartTarFlag;
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

/// ��ʼ����� div��ʽ
function initDivHtml(){
	
	var html  = "<div id='itro_win'  class='div-notes' style='border-radius:3px; display:none; border:2px solid #20A0FF; background:#FFF; position:absolute; width:700px; height:300px;'>";
	    /// ������
		html += "	<div id='itro_title_bar' style='width:100%; height:35px; background:#20A0FF;color:#fff;font-weight:bold;'>";
		html += "		<div id='itro_title' style='padding:8px;text-align:center'></span></div>";
		html += "	</div>"
		/// ������
		html += "	<div id='itro_content' style='width:100%; height:260px; overflow:auto;'>";
		html += "	</div>"
		html += "</div>"
	$('body').append(html);
}

/// �����Ŀ˵����
/*
function initItemInstrDiv(){

	var TarEl = 'td[field="ItemLabel"]';   /// Ŀ��Ԫ��
	initDivHtml();   					   /// ��ʼ����� div��ʽ
	//$("#itro_title").text(itro_title);     /// div�� ����
	//$("#itro_content").text(itro_content); /// div�� ����
	
	/// ��껬���¼�
	//$(TarEl).on('mousemove',function(){//�԰�ť�Ĵ���
	$(".datagrid-body").on('mousemove','td[field="ItemLabel"]',function(){//�԰�ť�Ĵ��� 
		$(this).removeClass("hover1");
		
		/// ������
		var rowIndex = $(this).parent().attr("datagrid-row-index");
		var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
		$("#itro_title").text(rowData.ItemLabel +" - "+ "˵����");  /// div�� ����
		var itmmmastid = rowData.ItemExaID;        /// ҽ����ID
		var itemPartID = rowData.ItemExaPartID;    /// ��λID
		var itemHtml = GetItemInstr(itmmmastid, itemPartID);
		if (itemHtml == "") return;
		$("#itro_content").html(itemHtml); 		   /// div�� ����
		
		$(".div-notes").css({
			top : ($(this).parent().offset().top + $(this).outerHeight() - 10) + 'px',
			left : (event.clientX + 10) + 'px',
			'z-index' : 9999
		}).show();
	})
	
	/// ��껬���뿪�¼�
	//$(TarEl).on('mouseleave',function(){//�԰�ť�Ĵ���
	$(".datagrid-body").on('mouseleave','td[field="ItemLabel"]',function(){
		var divThis = $(".div-notes"); 
		setTimeout(function(){ 
			if (divThis.hasClass("hover0")) {//˵��û�дӰ�ť����div
				divThis.hide(); 
			}
	     }, 100); 
		$(this).addClass("hover1");	
	});
	
	/// div ������ʽ���
	$(".div-notes").hover(function(){//div
		$(this).removeClass("hover0");
	},function(){
		$(this).addClass("hover0"); 
		var anniu = $('td[field="ItemLabel"]'); 
		var tthis = $(this); 
		setTimeout(function(){ 
			if(anniu.hasClass("hover1")){//˵��û�д�div�ص���ť
				tthis.hide(); 
			}
		},100); 
	})
}
*/
/// ��ȡ�����Ŀ˵����
function GetItemInstr(itmmastid, itemPartID){
	var html = '';
	// ��ȡ��ʾ����
	runClassMethod("web.DHCAPPExaReportQuery","GetItemInstr",{"itmmastid":itmmastid, "itemPartID":itemPartID},function(jsonString){

		if (jsonString != ""){
			var jsonObject = jsonString;
			html = initMedIntrTip(jsonObject);
		}else{
			html = "";
		}
	},'json',false)
	return html;
}

/// ��ʼ��֪ʶ����Ϣ����
function initMedIntrTip(itmArr){
	
	var htmlstr = '';
	for(var i=0; i<itmArr.length; i++){
		
		htmlstr = htmlstr + "<table  cellpadding='0' cellspacing='0' class='itro_content'>" //<tr><td style='background-color:#F6F6F6;width:120px' >�������Ŀ��</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+itmArr[i].geneDesc+"["+itmArr[i].pointer+"]</td></tr>";
		htmlstr = htmlstr + "<tr><td style='background-color:#F6F6F6;font-weight:bold; font-size:14px;'>"+itmArr[i].itemTile+"</td></tr>";
		htmlstr = htmlstr + "<tr><td style='border-right:solid #E3E3E3 1px; font-size:14px; padding-left: 10px;'>"+itmArr[i].itemContent+"</td></tr>";
		htmlstr = htmlstr + "</table>";
	}

   return htmlstr;
}

/// �������뵥����
function LoadReqFrame(arRepID, repEmgFlag){
	
	$('#arEmgFlag').prop("checked",repEmgFlag=="��"?true:false);   ///sufan 2018-01-30
	$("#ItemSelList").datagrid("load",{"params":arRepID});
	LoadItmOtherOpot(arRepID, arRepID); /// ����������Ŀ
	arExaReqIdList = arRepID;
	InitGetReqEditFlag(arRepID);  /// ���뵥�Ƿ�����༭
}

/// ���뵥�Ƿ�����༭
function InitGetReqEditFlag(ID){

	var LgParams = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","JsGetReqEditFlag",{"ID":ID, "Type":"", "LgParams":LgParams},function(jsonString){
		if (jsonString != ""){
			isPageEditFlag = jsonString;
			PageEditFlag(jsonString);
		}
	},'',false)
}

/// ���ý���༭״̬
function PageEditFlag(Flag){
	
	if (Flag == 0){
		$('#bt_sendreq').linkbutton('disable');   /// ���Ͱ�ť����
		$('#bt_sendreq').removeClass('btn-lightgreen');
	}else{
		$('#bt_sendreq').linkbutton('enable');      /// ���Ͱ�ť����
		$('#bt_sendreq').addClass('btn-lightgreen');
	}
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	if (itemReqID != ""){
		LoadReqFrame(itemReqID, repEmgFlag);
	}
}

/// �Ӽ���־���� qunianpeng 2018/3/20 
function emgFlagControl(value,row,index){	
	switch(value){	// Y/N �����ܲ��ܹ�ѡ(ҽ�����ʶ)   1/0 �����Ƿ��Ѿ���ѡ��ҽ����Ӽ���־��
		case "Y":
			return '<input type=\'checkbox\' id=\'CK_EmFlag'+index+'\' onclick=\'setCheckFlag('+index+')\'/>';
		case "N":
			return '<input type=\'checkbox\' disabled  id=\'CK_EmFlag'+index+'\'/>';
		case "1":
			return '<input type=\'checkbox\' disabled  id=\'CK_EmFlag'+index+'\' checked=\'checked\' />';
		case "0":
			return '<input type=\'checkbox\' disabled  id=\'CK_EmFlag'+index+'\' />';
		case "C":
			return '<input type=\'checkbox\' id=\'CK_EmFlag'+index+'\' checked=\'checked\' onclick=\'setCheckFlag('+index+')\'/>';				
	}	
}				

/// ����rowsDataֵ
function setCheckFlag(index){
	
	var rowsData = $("#ItemSelList").datagrid('getRows');
	rowsData[index].ItemEmgFlag = ($("#CK_EmFlag"+index).is(":checked")?"C":"Y");
}

window.onload = onload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
