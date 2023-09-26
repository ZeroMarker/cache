//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-08
// ����:	   �°�������
//===========================================================================================

var EpisodeID = "";      /// ���˾���ID
var itemCatID = "";      /// ������ID
var itemReqID = "";      /// ���뵥ID
var repEmgFlag = "";     /// ���뵥�Ӽ���־
var itemSelFlag = "";    /// ��ѡ�б�ǰ״ֵ̬
var arExaReqIdList = "";
var LgUserID = session['LOGON.USERID'];   /// �û�ID
var LgUserName=session['LOGON.USERNAME']; /// �û�����
var LgCtLocID = session['LOGON.CTLOCID']; /// ����ID
var LgGroupID = session['LOGON.GROUPID']; /// ��ȫ��ID
var LgHospID = session['LOGON.HOSPID'];   /// ҽԺID
var editRow = -1; var editSelRow = -1;
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
var mDel = String.fromCharCode(2);  /// �ָ���
var OrderLimit=tkMakeServerCall("web.DHCDocConfig", "GetConfigNode1", "OrderLimit",session['LOGON.GROUPID']);
var PatAdmType=tkMakeServerCall("web.DHCDocOrderEntry", "GetPAAdmType", getParam("EpisodeID"));
if (PatAdmType=="H") OrderLimit=1;
var pid = "";
/// ҳ���ʼ������
function initPageDefault(){
		
	InitPatEpisodeID();   /// ��ʼ�����ز��˾���ID
	
	initVersionMain();    ///  ҳ���������
	initItemSelList();    ///  ҳ��DataGrid��ʼ����
	initCombobox();       ///  ҳ��Combobox��ʼ����
	initBlButton();       ///  ҳ��Button���¼�
	initCheckBoxEvent();  ///  ҳ��CheckBox�¼�

	LoadExaReqHisSign();  ///  ���ز����ֲ�ʷ������
	LoadPageBaseInfo();   ///  ��ʼ�����ػ�������
	LoadPatBaseDiags();   ///  ���ز����������
	
	initPatNotTakOrdMsg(); /// ��֤�����Ƿ�����ҽ��
	initItemInstrDiv();    /// �����Ŀ˵����
}

/// ҳ���������
function initVersionMain(){

	/// ��������Ϊ�ɰ�ʱ,�����������°�¼�����
	if (DocMainFlag == 1){
		version = 1;
	}
	
    <!-- �¾ɰ汾�������� -->
    if (version != 1){
		initItemListOLD();       ///  ҳ��DataGrid�������б�
	}
	
	/// ҽ���������ʱ,��ʼ������
	if (DocMainFlag == 1){
		/// ���ý��水ť����
		$('#bt_sendreq').hide();   /// ���Ͱ�ť����
		$('#bt_printreq').hide();  /// ��ӡ��ť����
		$('#arPatSym').focus();    /// ���ý���
		//$('#arEmgFlag').hide();    /// �Ӽ���־����
		$('label:contains("�Ӽ�")').hide();    /// �Ӽ���־����
		
		//$('#bt_suredoc').hide();   /// ȷ�ϰ�ť���� �벡������
		//$('#bt_clsdoc').hide();    /// �رհ�ť���� �벡������
		$('#MainPanel').layout('hidden','south');  /// ��ť��
	}else{
		$('#bt_suredoc').hide();   /// ȷ�ϰ�ť����
		$('#bt_clsdoc').hide();    /// �رհ�ť����
	}
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	CloseFlag = getParam("CloseFlag");
	itemCatID = getParam("itemCatID");
	itemReqID = getParam("itemReqID");  /// ���뵥ID
	repEmgFlag = getParam("repEmgFlag");
	pid = getParam("pid");              /// Ψһ��ʶ �벡������ ���ÿ�ɾ��
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
	/// �������б�
	if (version != 1){
		var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckItemList";
		$('#itemList').datagrid({url:uniturl});
	}
	
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
		{field:'ItemRemark',title:'��ע',width:100,editor:texteditor},
		{field:'ItemStat',title:'��ǰ״̬',width:100,align:'center'},
		{field:'ItemBilled',title:'�Ʒ�״̬',width:100,hidden:true},
		{field:'ItemReqDate',title:'ҽ������',width:100,hidden:true},
		{field:'ItemUniqueID',title:'Ψһ��ʾ',width:100,hidden:true},
		//{field:'ItemEmgFlag',title:'�Ӽ���־',width:100,hidden:true},
		{field:'ItemEmgFlag',title:'�Ӽ�',width:40,hidden:false,align:'center',formatter:emgFlagControl}, // �Ӽ���־ qunianpneg 2018/3/20
		{field:'ItemPrice',title:'�۸�',width:100},
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

			/// ���Ŀ��
	        //LoadArcItemPurp(rowData.ItemExaPurp);  //sufan 2019-01-12
	        
	        /// ����ע������
	        LoadItemTemp(rowData.ItemExaID);
	    },
		onLoadSuccess:function(data){
			CheckForHidePrintClick();
			//itemSelFlag = 1;    /// ��ѡ�б�ǰ״ֵ̬
			GetExaReqItmCost();   /// �����������ܽ��
			var selItems=$("#ItemSelList").datagrid('getRows');
			if (selItems != ""){
				//LoadArcItemPurp(selItems[0].ItemExaPurp);  //sufan 2019-01-12
			}

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

	    	if ((rowData.ItemID != "")&&(rowData.ItemStat!="�����")) return;
            if (editSelRow != -1||editSelRow == 0) { 
                $("#ItemSelList").datagrid('endEdit', editSelRow); 
            } 
            $("#ItemSelList").datagrid('beginEdit', rowIndex); 
            
            editSelRow = rowIndex; 
            
			///���ü���ָ��
			var ed=$("#ItemSelList").datagrid('getEditor',{index:rowIndex,field:'ItemLoc'});
			
			var OpenForAllHosp=0,LogLoc="";
			var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
			var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
			if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
			if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
			var unitUrl=$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+rowData.ItemExaID+"&OrderDepRowId="+LogLoc+"&OpenForAllHosp="+OpenForAllHosp;
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
	if ((value == "1")&(DocMainFlag == 1)){
		 return "";
	}
	if ((rowData.ItemStat == "ֹͣ")||(rowData.ItemStat == "ִ��")){
		 return "";
	}
	if (rowData.ItemID == ""){
		var html = "<a href='#' onclick='delItmSelRow("+rowIndex+")'>ɾ��</a>";
	}else{
		if (rowData.oeori == ""){
		var html = "<a href='#' onclick='revItmSelRow("+rowIndex+")'>ɾ��</a>";
		}else{
		var html = "<a href='#' onclick='revItmSelRow("+rowIndex+")'>����</a>";	
			}
	}
    return html;
}

/// ɾ����
function delItmSelRow(rowIndex){
	
	$.messager.confirm('ȷ�϶Ի���','ȷ��Ҫɾ��������', function(r){
		if (r){
			/// ɾ�������Ŀ
			var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
			delExaReqItm(rowData.ItemArcID,rowData.ItemExaID,rowData.ItemExaPartID);
			/// ɾ����
			$("#ItemSelList").datagrid('deleteRow',rowIndex);
			var arExaItmID = rowData.ItemExaID.replace("||","_"); /// �����Ŀ
			/// ȡ�������Ŀ��ѡ��
			if ($("#"+arExaItmID).is(":checked")){
				$("#"+arExaItmID).attr("checked",false);
			}
			//CalExaReqCost();    ///  �����������ܽ��
			GetExaReqItmCost();   ///  �����������ܽ��
			setReqEmgFlag();      ///  �������뵥�Ӽ���־
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
			delExaReqOthOpt(itmmastid);
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

/// ҳ��DataGrid��ʼ����������б�
function initItemListOLD(){
	
	///  ����columns
	var columns=[[
		{field:'Select',title:'ѡ��',width:40,formatter:SetCellCheckBox},
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'ItemCode',title:'ItemCode',width:100,hidden:true},
		{field:'ItemDesc',title:'��Ŀ����',width:450},
		{field:'ItemPartID',title:'��λID',width:100,hidden:true},
		{field:'ItemPart',title:'��λ',width:100,hidden:true},
		{field:'ItemPrice',title:'����λ�۸�',width:100,hidden:true}
	]];

	///  ����datagrid
	var option = {
		rownumbers : false,
		singleSelect : false,
		onClickRow:function(rowIndex, rowData){
			
			/// ��ǰ��ѡ��/ȡ��״̬
			var selectflag=$("#itemList").datagrid('getPanel').find('[datagrid-row-index='+rowIndex+']').hasClass("datagrid-row-selected");
			if (selectflag){
				addItmToItmSelList(rowIndex);
				$("[name='ItmCheckBox'][value='"+ rowIndex+"']").attr("checked",true);
			}else{
				delItmFromItmSelList(rowIndex);
				$("[name='ItmCheckBox'][value='"+ rowIndex+"']").attr("checked",false);
			}
	    },
		onLoadSuccess:function(data){
			/// ������ɺ��������һ��,ֱ��ѡ��
			var rows = $("#itemList").datagrid('getRows');
			if (rows.length > 0){
				//$('#ItemList').datagrid('selectRow',0);
				//LoadArcItemRecLoc(rows[0].ItemID);
			}
			/// ����ӵ���ѡ�б����Ŀ����̬����ѡ��״̬
			$.each(rows, function(index, selItem){
				if (GetCurItmIsSelect(selItem.ItemID, selItem.ItemPartID)){
					$('#itemList').datagrid('selectRow',index);
					$("[name='ItmCheckBox'][value='"+ index+"']").attr("checked",true);
				}
			})
		}
	};

	var params = "";
	var uniturl = ""; //$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckItemList&params"+ params;
	new ListComponent('itemList', columns, uniturl, option).Init(); 

}

/// ��ѡ��
function SetCellCheckBox(value, rowData, rowIndex){

	var html = '<input name="ItmCheckBox" type="checkbox" value='+rowIndex+'></input>';
    return html;
}

/// ���ؼ�鷽���б�
function LoadItemList(item){
	
	/// ��ʼ����鷽������
	$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonItemList",{"item":item},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// ���ؼ�鷽���б�
function LoadCheckItemList(itemCatID){
	
	/// ��ʼ����鷽������
	$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
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
		//itemhtmlArr.push('<td style="width:30px"><input id="'+ itemArr[j-1].value +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itemobj.id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		itemhtmlArr.push('<td style="width:30px"><input id="'+ itemArr[j-1].value +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itemobj.id +'"  data-emtype="'+ itemArr[j-1].title +'"  data-defsensitive="'+ itemArr[j-1].defSensitive +'"></input></td><td><label id="'+ itemArr[j-1].value +'" value="'+ itemobj.id +'"  data-emtype="'+ itemArr[j-1].title +'"  data-defsensitive="'+ itemArr[j-1].defSensitive +'" >'+ itemArr[j-1].text +'</label></td>'); // qunianpeng 2018/3/20 ����title
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
		/// ҽ���������ʱ,��ʼ������
		if (DocMainFlag == 1){
			/// ���ڷ���ʱ���жϷ�����Ŀ�Ƿ��뿪����Ŀһֱ
			mItmMastDocArr.push(itemArr[j-1].value +"*"+ itemArr[j-1].text);
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(htmlstr+itemhtmlstr);
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

	///  ����
	//$('button:contains("����")').bind("click",sendExaReq);
	
	///  ��ӡ
	//$('button:contains("��ӡ")').bind("click",printExaReq);
	
	///  ƴ����
	$("#ExaItmCode").bind("keypress",findExaItemList);
	
	///  ƴ����
	$("#ExaCatCode").bind("keyup",findExaItmTree);
	
	///  �����Ŀ
	$("#item").bind("keyup",searchItem);
	
	///  ������Ŀ checkbox
	//$("#TmpOtherOpt input[type='checkbox']").live("click",setOtherOpt);
	$("#TmpOtherOpt").on("click","input[type='checkbox']",setOtherOpt);
	
	///  ������Ŀ text
	//$("#TmpOtherOpt input[name='Input']").live('change',setOtherOpt);
	$("#TmpOtherOpt").on("change","input[name='Input']",setOtherOpt);
	
	//$("#itemList .checkbox").live("click",selectExaItem);
	$("#itemList").on("click",".checkbox",selectExaItem);
	$("#itemList").on("click","label",selectExaItemlable);
	///  ȷ��
	$('#surPartWin').bind("click",addItmToItmSelListNew);
	
	///  ȡ��
	$('#clsPartWin').bind("click",closeWin);
	
	///  ȷ��
	//$('button:contains("ȷ��")').bind("click",sureExaReq);
	
	///  �ر�
	//$('button:contains("�ر�")').bind("click",closePopWin);
	
	/// ��λѡ��
	$("#ItmExaPart").on("click","[id^=Part]",selectItem);
}

/// ��ʼ��ҳ��CheckBox�¼�
function initCheckBoxEvent(){

	//$("input[type=checkbox]").live('click',function(){
	$("body").on('click',"input[type=checkbox]",function(){
		
		///  ����������λ�������
		if ((this.name == "ExaDisp")||(this.name == "ExaPart")||(this.name == "Diags")) {
			return;
		}
		
		$("input[name="+this.name+"]:not([value="+this.value+"])").each(function(){
			$(this).removeAttr("checked");
		})
	});
}

/// ��λ
function LoadItmPosition(itmmastid){
	
	$("#ItmPosi").html("");
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaPosition",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				//if ($('input[name="ExaPosi"][value="'+jsonObjArr[i].value+'"]').length == 0){
					var html = '<span><input class="checkbox" type="checkbox" name="ExaPosi" value="'+ jsonObjArr[i].value +'">'+ jsonObjArr[i].text +'</input>&nbsp;&nbsp;</span>';
					$("#ItmPosi").append(html);
				//}
			}
		}
	},'json',false)
}

/// ������
function LoadItmDispMethod(itmmastid){
	
	$("#ItmDisp").html("");
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaDisp",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				//if ($('input[name="ExaDisp"][value="'+jsonObjArr[i].value+'"]').length == 0){
					var html = '<span><input class="checkbox" type="checkbox" name="ExaDisp" value="'+ jsonObjArr[i].value +'">'+ jsonObjArr[i].text +'</input>&nbsp;&nbsp;</span>';
					$("#ItmDisp").append(html);
				//}
			}
		}
	},'json',false)
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

/// ��ʾ������Ŀ
function showItemOtherOpt(){

	/// ��ʼ��Ϊ����
	$("#TmpOtherOpt").html('');
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaReqTmpOtherOpt",{"pid":pid},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			//$(".form-table").html("");
			for (var i=1; i<=jsonObjArr.length; i++){
				insHtmlTable(jsonObjArr[i-1]);
			}
			/// ����Ϊ����ʱ���������У�
			if ((i-1) % 2 != 0){
				$("#TmpOtherOpt tr:last").append('<td align="right"></td><td style="width:120px"></td>');
			}
		}
	},'json',false)
}
/// ������Ŀ�б�
function addItemSelList(){
	
	/// ��ѡ�б�ǰ״ֵ̬
	if (itemSelFlag == "1"){
		itemSelFlag = "";
		$("#ItemSelList").datagrid('loadData',{total:0,rows:[]});
	}
	/// ��λ
	var arExaPosiID = "",arExaPosiDesc = "";
	if ($('input[name="ExaPosi"]:checked').length){
		arExaPosiID = $('input[name="ExaPosi"]:checked').val();
		arExaPosiDesc = $('input[name="ExaPosi"]:checked').parent().text();
	}
	
	/// ������
	var arExaDispID = [],arExaDispDesc = [];
	$('input[name="ExaDisp"]:checked').each(function(){
		arExaDispID.push(this.value);
		arExaDispDesc.push($.trim($(this).parent().text()));
	})
	arExaDispID = arExaDispID.join("@");
	arExaDispDesc = arExaDispDesc.join("��");
	
	/// ���տ���
	var ExaReclocID = $("#ExaRecloc").combobox("getValue");    	 /// ���տ���ID
	var ExaRecloc = $("#ExaRecloc").combobox("getText");    	 /// ���տ���
	if (ExaRecloc == ""){
		$.messager.alert("��ʾ:","���տ��Ҳ���Ϊ�գ�");
		return;
	}

	/// ��鷽��
	var selItems=$("#ItemList").datagrid('getSelections');
	$.each(selItems, function(index, selItem){
		
		var itmmmastid = selItem.ItemID;         /// ID
		var itmmmastdesc = selItem.ItemDesc;     /// ����
		var itmmmastprice = selItem.ItemPrice;   /// �۸�
		var arExaPartID = selItem.ItemPartID;    /// ��λID
		var arExaPartDesc = selItem.ItemPart;    /// ��λ����

		var ItemLabel = itmmmastdesc; // +" + "+ arExaPosiDesc +"["+ arExaPartDesc +"��"+ arExaDispDesc +"]";
		if (arExaPosiDesc !="" ){
			ItemLabel = ItemLabel +" + "+ $.trim(arExaPosiDesc);
		}
		
		var ItemLabelArr = [];
		if (arExaPartDesc !="" ){
			ItemLabelArr.push(arExaPartDesc);
		}
		if (arExaDispDesc !="" ){
			ItemLabelArr.push(arExaDispDesc);
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
		ItemExaPartID:arExaPartID, ItemExaDispID:arExaDispID, ItemExaPosiID:arExaPosiID,ItemExaPurp:ItemLabel, ItemOpt:'', ItemStat:"��ʵ", ItemRemark:''}
		$("#ItemSelList").datagrid('appendRow',rowobj);
		CheckForHidePrintClick();
		
		/// ������Ŀ
        LoadItmOtherOpt(itmmmastid);
        
        /// ��λ
        $('input[name="ExaPosi"]:checked').attr("checked",false);
        /// ����
        $('input[name="ExaDisp"]:checked').attr("checked",false);
	})
	
	showItemOtherOpt();  /// ȷ�ϼ����һ���Լ���������Ŀ bianshuai 2016-08-09 
	
	//CalExaReqCost();  ///  �����������ܽ��
	GetExaReqItmCost();   ///  �����������ܽ��
}

/// ���ͼ������
function sendExaReq(){

	/// ����ǩ������
	if (!window.parent.frames.isTakeDigSign()) return;
		
	/// ����ǰ����֪ʶ��
	if (InvokItmLib() != true) return;
	var selItems=$("#ItemSelList").datagrid('getRows');
	var ItemID = selItems[0].ItemID;
	if (ItemID==""){
		/// סԺ��������Ѻ�����
		var PatArrManMsg = GetPatArrManage();
		if (PatArrManMsg != ""){
			$.messager.alert("��ʾ:",PatArrManMsg);
			return;	
		}
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
    
	var itemExaDisHis = $("#arDisHis").val().replace(/\s/g,'');  /// �ֲ�ʷ
	if (itemExaDisHis == "�������ֲ�ʷ������"){
		itemExaDisHis = "";
	}
	
	var itemExaPhySig = $("#arPhySig").val().replace(/\s/g,'');  /// ����
	if (itemExaPhySig == "������������"){
		itemExaPhySig = "";
	}
		
	var itemExaSym = $("#arPatSym").val().replace(/\s/g,'');     /// ����
	if (itemExaSym == "���������ߣ�"){
		itemExaSym = "";
	}
	if (itemExaSym == ""){
		$.messager.alert("��ʾ:","�������߲���Ϊ�գ�","info",function(){
			$('#arPatSym').focus();    /// ���ý���
		});
		return;
	}
	var ExaPurp=$("#ExaPurp").val().replace(/\s/g,'');     /// ���Ŀ��
	if (ExaPurp == "��������Ŀ�ģ�"){
		ExaPurp = "";
	}
	if (ExaPurp == ""){
		var ExaPurpflag=dhcsys_confirm(('���Ŀ��Ϊ�ղ��ܱ���,�Ƿ��Զ�Ĭ��Ϊ��Ŀ���ƣ�'),true);
		if (ExaPurpflag==false){
			return;
		}else{
			var ExaPurp=""
			var selItems=$("#ItemSelList").datagrid('getRows');
			$.each(selItems, function(index, selItem){
				var ItemLabel = selItem.ItemLabel;               /// ��ĿID
				if (ExaPurp=""){ExaPurp=ItemLabel}else{ExaPurp=ExaPurp+","+ItemLabel}
			})
			$("#ExaPurp").val(ExaPurp);	
		}
	}
	/// ���
	var PatDiagsArr = [];
	$('input[name="Diags"]:checked').each(function(){
		PatDiagsArr.push(this.value +String.fromCharCode(4)+ $(this).parent().next().text()); //mDel
	})
	
	if ((PatDiagsArr.length == 0)&&(OrderLimit==0)){
		$.messager.alert("��ʾ:","��ϲ���Ϊ�գ�");
		return;
	}
	var PatDiags = PatDiagsArr.join("@");
	/// ���Ŀ��
	var ItemExaPurpA=$("#ExaPurp").val();
	/// ��������������Ϣ
	var mPatSymData = EpisodeID + String.fromCharCode(4) + itemExaDisHis + String.fromCharCode(4) + itemExaPhySig + String.fromCharCode(4) + itemExaSym+String.fromCharCode(4)+ItemExaPurpA;
	
	var tips = itmIsRequired();   /// ������Ŀ�Ƿ�Ϊ����
	if (tips != ""){
		$.messager.alert("��ʾ:","������Ŀ:" + tips +"����Ϊ�գ�");
		return;
	}

	var itemLocFlag = 0;

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
		//var itemExaPurp=$("#ExaPurp").val();	   /// ȡ�ֶ�¼��ļ��Ŀ��  sufan 2018-01-12
		if($.trim(ItemExaPurpA)=="")
		{
			var itemExaPurp = selItem.ItemLabel;	   /// ���Ŀ��
		}
		
		var itemRemark = selItem.ItemRemark;	   /// ��ע
		var itemBillTypeID = selItem.ItemBillTypeID; /// �ѱ�
		var itemEmgFlag=$("#CK_EmFlag"+index).is(":checked")? "Y":"N";     /// �Ӽ�
		if (selItems.length>1) {
			var arEmgFlag = "N";
		}else{
			var arEmgFlag = itemEmgFlag;
		}
		var CoverMainIns=0
		var InsurFlag=parent.$HUI.checkbox("#InsurFlag").getValue();
		if (InsurFlag==true){CoverMainIns=1}
		var ListData = ItemID +String.fromCharCode(2)+ EpisodeID +"^"+ itemLocID +"^"+ arEmgFlag +"^"+ itemExaPurp +"^"+ LgUserID +"^^^"+ LgCtLocID +"^^"+ "Y" +"^"+ PatDiags;
			ListData = ListData +String.fromCharCode(2)+ itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID +"^"+ itemRemark +"^^^"+itemBillTypeID+"^"+itemEmgFlag+"^"+CoverMainIns;
		mItmListData.push(ListData);
	})
	
	if (itemLocFlag == 1){
		$.messager.alert("��ʾ:","���տ��Ҳ���Ϊ�գ�");
		return;
	}
	
	mItmListData = mItmListData.join(String.fromCharCode(1));

	if (mItmListData == ""){
		$.messager.alert("��ʾ:","û�д�������Ŀ,��ѡ������Ŀ�����ԣ�");
		return;
	}
	/// ����ģ������
	runClassMethod("web.DHCAPPExaReport","save",{"pid":pid, "ListData":mItmListData, "mPatSymData":mPatSymData,"LgParams":LgUserID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			if (CloseFlag != ""){
				window.parent.frames.InvMainFrame(); /// ���ø���ܺ���
			}else{
				arExaReqIdList = jsonString;
				printCom(arExaReqIdList);
				$.messager.alert("��ʾ:","���ͳɹ�");
				$("#ItemSelList").datagrid("load",{"params":arExaReqIdList});
				/// ���ø���ܺ���
				window.parent.frames.reLoadEmPatList();
				/// �жϼ�������Ƿ��п�ԤԼ��Ŀ bianshuai 2016-08-09
				isNeedAppExaReqNo(arExaReqIdList);
				/// �Ӽ���ֹѡ��  sufan 2018-02-27
				//$('#arEmgFlag').attr("disabled",true);
				/// ����ǩ������
				window.parent.frames.TakeDigSign(arExaReqIdList, "E");
				/// ���Ӳ�����ܺ���
				window.parent.frames.InvEmrFrameFun();
			}
		}
	},'',false)
}

/// ������Ŀ����
function LoadItmOtherOpot(arReqID, itmmastid){

	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqOthOpt",{"pid":pid, "arReqID":arReqID, "itmmastid":itmmastid},function(jsonString){

		if (jsonString != ""){
			pid = jsonString;
			showItemOtherOpt();
		}
	},'',false)
	
}

/// ɾ��������Ŀ
function delExaReqItm(arReqItmID,itmmastid,PartID){

	if (arReqItmID != ""){
		/*
		runClassMethod("web.DHCAPPExaReport","delExaReqItm",{"arReqItmID":arReqItmID, "inPartID":PartID},function(jsonString){
			
			if (jsonString == 1){
				$.messager.alert("��ʾ:","������ִ�в��ܽ��д˲�����");
				return;
			}
		    if (jsonString < 0){
				$.messager.alert("��ʾ:","ɾ������,������Ϣ:"+jsonString);
				return;
			}
		    if (jsonString == 0){
				delExaReqOthOpt(itmmastid);
				$("#dgEmPatList").datagrid("reload");   /// ˢ��ҳ������
			}
		
		},'',false)
		*/
	}else{
		delExaReqOthOpt(itmmastid);
	}

}

/// ɾ��������Ŀ
function delExaReqOthOpt(itmmastid){

	runClassMethod("web.DHCAPPExaReportQuery","DelExaReqOthOpt",{"pid":pid, "itmmastid":itmmastid},function(jsonString){

		if (jsonString != ""){
			showItemOtherOpt();
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
	setOtherOptByItem(itemobj);
}
function setOtherOptByItem(itemobj){
	/// ������ʱ����
	runClassMethod("web.DHCAPPExaReportQuery","setExaOtherOpt",{"pid":pid, "id":itemobj.itemid, "type":itemobj.itemtype, "val":itemobj.itemval},function(jsonString){})
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

/// ���Ҽ����Ŀ��
function findExaItmTree(event){
	
	var PyCode=$.trim($("#ExaCatCode").val());
	if (PyCode == ""){
		<!-- �¾ɰ汾�������� -->
	    if (version != 1){
			/// �ɰ�
			var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+LgHospID;
		}else{
			/// �°�
			var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+LgHospID;
		}
	}else{
		<!-- �¾ɰ汾�������� -->
	    if (version != 1){
		    /// �ɰ�
			var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCode&PyCode='+PyCode+'&HospID='+LgHospID;
		}else{
			/// �°�
			var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCodeNew&PyCode='+PyCode+'&HospID='+LgHospID;
		}
	}
	
	$('#CheckPart').tree('options').url =encodeURI(url);
	$('#CheckPart').tree('reload');
}

/// ���Ҽ�鷽��
function searchItem(event){
	
	var item=$.trim($("#item").val());
	if (item != ""){
		LoadItemList(item);
	}
}

/// ���ü��Ŀ��
function LoadArcItemPurp(ExaReqItmPurp){
	
	if (ExaReqItmPurp != ""){
		$("#ExaPurp").css({"color":""});
		$("#ExaPurp").val(ExaReqItmPurp);
	}
}

/// �����������ֲ�ʷ
function LoadExaReqHisSign(){

	runClassMethod("web.DHCAPPExaReportQuery","jsonExaReqHisSign",{"arReqID":itemReqID, "EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			$("#arDisHis").css({"color":""});
			$("#arDisHis").val(jsonObjArr.arExaReqHis);  /// �ֲ�ʷ
			$("#arPhySig").css({"color":""});
			$("#arPhySig").val(jsonObjArr.arExaReqSig);  /// ����
			$("#arPatSym").css({"color":""});
			$("#arPatSym").val(jsonObjArr.arExaReqSym);  /// ����
		}
	},'json',false)
}

/// ���ؼ�����벡���������
function LoadExaReqDiags(arRepID){

	LoadPatBaseDiags();         /// ���ز����������
	LoadExaReqPatDiags(arRepID) /// ���ؼ����������������
}

/// ���ؼ����������������
function LoadExaReqPatDiags(mReqID){
	
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetExaRepDiags",{"mReqID":mReqID},function(jsonObject){
		if (jsonObject != ""){
			InsMarIndTable(jsonObject);
			var itmArr = jsonObject;
			for (var i=1; i<=itmArr.length; i++){
				if($('input[name="Diags"][value="'+ itmArr[i-1].value +'"]').length != 0){
					$('input[name="Diags"][value="'+ itmArr[i-1].value +'"]').attr("checked",true);
				}
			}
		}
	},'json',false)
}

/// ���ز����������
function LoadPatBaseDiags(){

	$("#TmpDiags").html("");
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetMRDiagnos",{"EpisodeID":EpisodeID, "Type":""},function(jsonObject){
		if (jsonObject != ""){
			InsMarIndTable(jsonObject);
		}
	},'json',false)
}

/// ���벡��������ݵ���������
function InsMarIndTable(itmArr){
	
	var itemhtmlArr = [];
	for (var j=1; j<=itmArr.length; j++){
		if($('input[name="Diags"][value="'+ itmArr[j-1].value +'"]').length == 0){
			itemhtmlArr.push('<tr><td style="width:20px;"><input onclick=\"DiagCheckClickHandler(this)\" linkvalue="'+ itmArr[j-1].linkvalue +'" value="'+ itmArr[j-1].value +'" name="Diags" type="checkbox"></input></td><td>'+ itmArr[j-1].text +'</td></tr>');
		}
	}
    $("#TmpDiags").append(itemhtmlArr.join(""));
}
function DiagCheckClickHandler(e){
	var linkvalue=$(e).attr("linkvalue");
	var value=$(e).attr("value");
	var checked=$(e).is(':checked')
	if (linkvalue!="") {
		$('input[name="Diags"]').each(function(){
			if (($(this).attr("value")==linkvalue)||($(this).attr("linkvalue")==linkvalue)) {
				$(this).prop("checked",checked);
			}
		})
	}else{
		$('input[name="Diags"]').each(function(){
			if ($(this).attr("linkvalue")==value) {
				$(this).prop("checked",checked);
			}
		})
	}
	
}
/// ��������ܽ��
function CalExaReqCost(){
	
	var arExaReqCost = 0;
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#ItemSelList').datagrid('refreshRow', index); /// ˢ�µ���
		var ItemPrice = selItem.ItemPrice;   /// ����
		arExaReqCost = parseFloat(arExaReqCost) + parseFloat(ItemPrice);
	})
	$("#arExaReqCost").text(arExaReqCost +"Ԫ");
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
function printExaReq(){
	
	printReq(arExaReqIdList);   /// ���ô�ӡ����
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

///  ������뵥�Ƿ���ҪԤԼ
function isNeedAppExaReqNo(arExaReqID){

	var arExaReqIDArr = arExaReqID.split("^");
	for (var m=0;m<arExaReqIDArr.length; m++){
		arReqID = arExaReqIDArr[m];
		if (isExistNeedAppItm(arReqID)){     /// ����ԤԼ��Ŀʱ,����ԤԼ����
			window.parent.frames.showItmAppDetWin(arReqID);  	 /// ԤԼ���鴰��
			break;
		}
	}
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
	var OpenForAllHosp=0,LogLoc="";
	var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
	var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
	if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
	if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmmastid,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
		
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
	CheckForHidePrintClick();

	/// ������Ŀ
    LoadItmOtherOpt(itmmmastid);

	showItemOtherOpt();   ///  ȷ�ϼ����һ���Լ���������Ŀ bianshuai 2016-08-09
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
/* ------�����Ŀ����ѡ�б�,֧��chrome start-------*/
function selectExaItem(e){
	if ($(this).is(':checked')){
		ChkBeforeSelectExaItem(e,selectExaItemData,"checkbox")
	}else{
		delSelectExaItem(e);
	}
}
function selectExaItemlable(e){
	var Labelclick=""
	if ($("#"+e.target.id).is(':checked')==false){
		ChkBeforeSelectExaItem(e,selectExaItemDatalab,"label")
		 $("#"+e.target.id).attr("checked",true); 
	}else{
		delSelectExaItem(e);
		$("#"+e.target.id).attr("checked",false); 
		}
	//}else{
		//delSelectExaItem(e);
	//}
}
function ChkBeforeSelectExaItem(e,ExcFunc,type){
	var CallBackFuncList=new Array();
	var CallBackRet=true;
	/// ҽ�ƽ����ж�
	if (GetIsMidDischarged() == 1){
		$.messager.alert("��ʾ:","�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����","",function(){
			if (type=="label"){
				$("#ItemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
				}else{
			$(e.target).attr("checked",false);}
		});
		return;	
	}
	/// ��֤�����Ƿ�����ҽ��
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg,"warning",function(){
			if (type=="label"){
				$("#ItemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
				}else{
			$(e.target).attr("checked",false);}
		});
		return;	
	}
	/// ��鷽����ҽ����ID��ҽ�������ơ�
	var arExaItmID = e.target.id;    /// ��鷽��ID
	if (DocMainFlag == 1){
		arExaItmID = arExaItmID.split("*")[3]; /// ҽ����ID
	}
	/// ��ȡҽ��¼ҽ��Ȩ��
	if (GetDocPermission(arExaItmID) == 1){
		$.messager.alert("��ʾ:","��û��Ȩ��¼���ҽ����","warning",function(){
			if (type=="label"){
				$("#ItemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
				}else{
			$(e.target).attr("checked",false);}
		});
		return;	
	}
	/// ��֤�����Ƿ�����ҽ��
	var ErrObject = GetPatNotTakOrdMsgArc(arExaItmID.replace("_","||"));
	if (ErrObject.ErrMsg != ""){
		$.messager.alert("��ʾ:",ErrObject.ErrMsg,"warning");
		if (ErrObject.ErrCode != 0){
			if (type=="label"){
				$("#ItemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
				}else{
			$(e.target).attr("checked",false);}
		}
		return;
	}
	/// ҽ�����Ա�/��������
	var LimitMsg = GetItmLimitMsg(arExaItmID)
	if (LimitMsg != ""){
		$.messager.alert("��ʾ:","��Ŀ��" +arExaItmDesc+ "��������ʹ�ã�" + LimitMsg,"warning");
		if (type=="label"){
				$("#ItemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
				}else{
			$(e.target).attr("checked",false);}
		return;	
	}
	/// ����ж�
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("��ʾ:","����û�����,����¼�룡","",function(){
			CallBackFuncList.push(
				DiagPopWinNew(function(){
					if (GetMRDiagnoseCount()>0) {
						ExecCallBackFuncList();
					}else{
						if (type=="label"){
						$("#ItemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
						}else{
					$(e.target).attr("checked",false);}
						return;
					}
				})
			);
			ExecCallBackFuncList();
		});
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
function selectExaItemData(e){
	/// ��鷽����ҽ����ID��ҽ�������ơ�
	var arExaItmID = e.target.id;    /// ��鷽��ID
	var arExaItmDesc = $(e.target).parent().next().text(); /// ��鷽��
	var arExaCatID = e.target.value; /// ������ID
	var arEmgFlag = $(e.target).attr("data-emtype");	 /// ���ӼӼ���־  qunianpeng 2018/3/20	
	var arDefEmg= $(e.target).attr("data-defsensitive");	 /// �Ƿ�Ĭ�ϼӼ�
	if (arDefEmg=="Y") arEmgFlag="C"; 
	if (arExaReqIdList != ""){
		$.messager.confirm('��ʾ','���뵥�ѷ��Ͳ���������Ŀ���Ƿ��������뵥��', function(b){
			if (b){
				PageEditFlag(1);    /// �������ý���༭״̬
				LoadPatBaseDiags(); ///  ���ز����������
				/// ׼����Ӽ����Ŀ
				attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag);
			}else{
				/// ȡ����Ŀѡ��״̬
				$("#"+arExaItmID).attr("checked",false);
			}
		})
	}else{
		/// ׼����Ӽ����Ŀ
		attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag);
	}
	///�Ӽ���ѡ��  sufan 2018-02-27
	$('#arEmgFlag').attr("disabled",false);
	DHCDocUseCount(arExaItmID.replace(/_/g,"||"), "User.ARCItmMast");
}
function selectExaItemDatalab(e){
	/// ��鷽����ҽ����ID��ҽ�������ơ�
	var arExaItmID = e.target.id;    /// ��鷽��ID
	var arExaItmDesc = e.target.textContent; /// ��鷽��
	var arExaCatID = e.target.value; /// ������ID
	var arEmgFlag = $(e.target).attr("data-emtype");	 /// ���ӼӼ���־  qunianpeng 2018/3/20	
	var arDefEmg= $(e.target).attr("data-defsensitive");	 /// �Ƿ�Ĭ�ϼӼ�
	if (arDefEmg=="Y") arEmgFlag="C"; 
	if (arExaReqIdList != ""){
		$.messager.confirm('��ʾ','���뵥�ѷ��Ͳ���������Ŀ���Ƿ��������뵥��', function(b){
			if (b){
				PageEditFlag(1);    /// �������ý���༭״̬
				LoadPatBaseDiags(); ///  ���ز����������
				/// ׼����Ӽ����Ŀ
				attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag);
			}else{
				/// ȡ����Ŀѡ��״̬
				$("#"+arExaItmID).attr("checked",false);
			}
		})
	}else{
		/// ׼����Ӽ����Ŀ
		attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag);
	}
	///�Ӽ���ѡ��  sufan 2018-02-27
	$('#arEmgFlag').attr("disabled",false);
	DHCDocUseCount(arExaItmID.replace(/_/g,"||"), "User.ARCItmMast");
}
function delSelectExaItem(e){
	var arExaItmID = $(e.target)[0].id;    /// ��鷽��ID
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
	setReqEmgFlag();      ///  �������뵥�Ӽ���־
	delExaReqOthOpt(arExaItmID); /// ɾ��������Ŀ
	///�Ӽ���ѡ��  sufan 2018-02-27
	$('#arEmgFlag').attr("disabled",false);
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
			LoadPatBaseDiags();
			if (callback) callback();
		}
	})
}
/* ------�����Ŀ����ѡ�б�,֧��chrome end-------*/
/// ѡ�м����Ŀ
/*function selectExaItem(){
	
	if ($(this).is(':checked')){
		
		/// ����ж�
		if (GetMRDiagnoseCount() == 0){
			$.messager.alert("��ʾ:","����û�����,����¼�룡","",function(){DiagPopWin()});
			$(this).attr("checked",false);
			return;	
		}
		
		/// ҽ�ƽ����ж�
		if (GetIsMidDischarged() == 1){
			$.messager.alert("��ʾ:","�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����","warning");
			$(this).attr("checked",false);
			return;	
		}
		
		/// ��֤�����Ƿ�����ҽ��
		TakOrdMsg = GetPatNotTakOrdMsg();
		if (TakOrdMsg != ""){
			$.messager.alert("��ʾ:",TakOrdMsg,"warning");
			$(this).attr("checked",false);
			return;	
		}
		
		/// ��鷽����ҽ����ID��ҽ�������ơ�
		var arExaItmID = this.id;    /// ��鷽��ID
		var arExaItmDesc = $(this).parent().next().text(); /// ��鷽��
		var arExaCatID = this.value; /// ������ID
		var arEmgFlag = $(this).attr("data-emtype");	 /// ���ӼӼ���־  qunianpeng 2018/3/20	
		var arDefEmg= $(this).attr("data-defsensitive");	 /// �Ƿ�Ĭ�ϼӼ�
		if (arDefEmg=="Y") arEmgFlag="C"; //
		/// ��ȡҽ��¼ҽ��Ȩ��
		if (GetDocPermission(arExaItmID) == 1){
			$.messager.alert("��ʾ:","��û��Ȩ��¼���ҽ����","warning");
			$(this).attr("checked",false);
			return;	
		}
						
		/// ��֤�����Ƿ�����ҽ��
		var ErrObject = GetPatNotTakOrdMsgArc(arExaItmID);
		if (ErrObject.ErrMsg != ""){
			$.messager.alert("��ʾ:",ErrObject.ErrMsg,"warning");
			if (ErrObject.ErrCode != 0){
				$(this).attr("checked",false);
			}
			return;
		}
		
		/// ҽ�����Ա�/��������
		var LimitMsg = GetItmLimitMsg(arExaItmID)
		if (LimitMsg != ""){
			$.messager.alert("��ʾ:","��Ŀ��" +arExaItmDesc+ "��������ʹ�ã�" + LimitMsg,"warning");
			$(this).attr("checked",false);
			return;	
		}
		
		if (arExaReqIdList != ""){
			$.messager.confirm('��ʾ','���뵥�ѷ��Ͳ���������Ŀ���Ƿ��������뵥��', function(b){
				if (b){
					PageEditFlag(1);    /// �������ý���༭״̬
					LoadPatBaseDiags(); ///  ���ز����������
					/// ׼����Ӽ����Ŀ
					attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag);
				}else{
					/// ȡ����Ŀѡ��״̬
					$("#"+arExaItmID).attr("checked",false);
				}
			})
		}else{
			/// ׼����Ӽ����Ŀ
			attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag);
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
		setReqEmgFlag();      ///  �������뵥�Ӽ���־
		delExaReqOthOpt(arExaItmID); /// ɾ��������Ŀ
	}
	///�Ӽ���ѡ��  sufan 2018-02-27
	$('#arEmgFlag').attr("disabled",false);
}*/

/// ׼����Ӽ����Ŀ
function attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag){
	
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
					if (DocMainFlag == 1){
						createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc);  /// ��Ŀ��ѡ��λ��������λ����
					}else{
						$("#arExaItmID").text(arExaItmID);     /// ��ʱ�洢��鷽��ID
						$("#arExaItmDesc").text(arExaItmDesc); /// ��ʱ�洢��鷽��
						window.parent.OpenPartWin(arExaCatID,arExaItmID.replace("_","||"));  /// ��λѡ���Ϊ�ⲿ����
					}
				}else{
					if (IsRepeatOneday(arExaItmID,"") == 1){
						$.messager.confirm('ȷ�϶Ի���','����������ͬҽ���Ƿ������ӣ�', function(r){
							if (r){
								addExaItem(arExaItmID,arExaItmDesc,arEmgFlag);          /// ��Ӽ����Ŀ
							}else{
								/// ȡ�������Ŀ��ѡ��
								if ($("#"+arExaItmID).is(":checked")){
									$("#"+arExaItmID).attr("checked",false);
								}
							}
						});
					}else{
						addExaItem(arExaItmID,arExaItmDesc,arEmgFlag);          /// ��Ӽ����Ŀ
					}
				}
			}
		},'',false)
}

/// ��Ӽ����Ŀ
function addExaItem(arExaItmID,arExaItmDesc,arEmgFlag){
	
//	/// ��鷽����ҽ����ID��ҽ�������ơ�
//	var arExaItmID = "",arExaItmDesc = "";
//	if ($('input[name="ExaItem"]:checked').length){
//		arExaItmID = $('input[name="ExaItem"]:checked').val();                     /// ��鷽��ID
//		arExaItmDesc = $('input[name="ExaItem"]:checked').parent().next().text();  /// ��鷽��
//	}
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
		var OpenForAllHosp=0,LogLoc="";
		var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
		var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
		if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
		if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}
	var itemprice=""
	runClassMethod("web.DHCEMInterface","GetExaReqCost",{"itmmastid":arExaItmID, "mPartList":"","EpisodeID":EpisodeID,"mDispID":"",IPid:""},function(jsonString){
		
			if (jsonString != ""){
				itemprice=jsonString
			}
		},'json',false)
	if (isExistItem(arExaItmDesc)){
		$.messager.alert("��ʾ:","�Ѵ�����ͬ��Ŀ,���ʵ�����ԣ�");
		return false;
	}

	var arReqDate  = "", uniqueID = ""; //,arEmgFlag = "";
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
	ItemEmgFlag:arEmgFlag, ItemRemark:'', ItemBillTypeID:BillTypeID, ItemBillType:BillType,ItemPrice:itemprice}
	$("#ItemSelList").datagrid('appendRow',rowobj);
	CheckForHidePrintClick();
	
	/// ������Ŀ
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  ȷ�ϼ����һ���Լ���������Ŀ bianshuai 2016-08-09
	GetExaReqItmCost();   ///  �����������ܽ��
	setReqEmgFlag();      ///  �������뵥�Ӽ���־
}

/// ������λ��������
function createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc){
	
	/// ����ҽ�����б���
	//new PopUpWin($(this), "760", "360" , "", "").init();
	$('#PopUpWin').window({
		title:'������Ϣ',   
	    width:900,    
	    height:500,    
	    modal:true,
	    collapsible:false,
	    minimizable:false,
	    maximizable:false,
	    onBeforeClose:function(){
			$("#dmPartList").datagrid('loadData',{total:0,rows:[]}); /// ���datagrid
			clrItmChkFlag();   	  ///  ȡ�������Ŀѡ��״̬
		}
	}); 
	
	$("#arExaItmID").text(arExaItmID);     /// ��ʱ�洢��鷽��ID
	$("#arExaItmDesc").text(arExaItmDesc); /// ��ʱ�洢��鷽��
	//initPartTree(arExaCatID,arExaItmID); /// ��鲿λ��
	initItemList(arExaItmID); /// ҳ��DataGrid��ʼ����������б�
	initItemDisp(arExaItmID); /// ������
	isShowPosi(arExaItmID);   /// �Ƿ���ʾ��λ��
	initExaPart(arExaCatID,arExaItmID);    /// ��鲿λ�б�CheckBox
}

/// ��鲿λ�б�
function initExaPart(arExaCatID,arExaItmID){
	
	var arExaItmID = arExaItmID.replace("_","||");
	/// ��ʼ����鷽������
	$("#ItmExaPart").html('<tr style="height:0px;" ><td style="width:80px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonGetPartTreeByArc",{"itmmastid": arExaItmID, "PyCode":"", "TraID":arExaCatID, "HospID": LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsPartRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// ��鲿λ����
function InsPartRegion(itemobj){	
	/// ������
	var htmlstr = '';
		// htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

	/// ��Ŀ
	var column = 5;  /// ����
	var itemArr = itemobj.children;
	var itemhtmlArr = []; itemhtmlstr = "";
	var merRow = Math.ceil(itemArr.length / column);  /// ����
	for (var j=1; j<=itemArr.length; j++){
		
		if (j == 1){
			itemhtmlArr.push('<td rowspan="'+ merRow +'" align="center">'+ itemobj.text +'</td>');
		}
		itemhtmlArr.push('<td><input id="Part_'+ itemArr[j-1].id +'" name="ExaPart" type="checkbox" value="'+ itemArr[j-1].id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		
		if (j % column == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % column != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + GetEmptyLabel(column - (itemArr.length % column)) +'</tr>';
		itemhtmlArr = [];
	}

	$("#ItmExaPart").append(htmlstr+itemhtmlstr)
}

/// ��ȡ��tb����
function GetEmptyLabel(number){
	
	var tempHtmlArr = [];
	for (var m=0; m < number; m++){
		tempHtmlArr.push('<td></td><td></td>');
	}
	return tempHtmlArr.join("");
}

/// ��ʼ����鲿λ��
function initPartTree(arExaCatID,arExaItmID){

	var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+arExaItmID+'&PyCode=&TraID='+arExaCatID+'&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
		checkbox:true,
        onCheck:function(node, checked){
	        var isLeaf = $("#EnPart").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        if (checked){
			        /// �����Ŀʱ,�жϵ����Ƿ�������ͬ��Ŀ
			        if (IsRepeatOneday(arExaItmID,node.id) == 1){
				        var nodeid = node.id;
				        var nodetext = node.text;
						$.messager.confirm('ȷ�϶Ի���','����������ͬ��λҽ���Ƿ������ӣ�', function(r){
							if (r){
								addItmSelList(nodeid, nodetext);
							}else{
								/// ȡ��ѡ�нڵ�
								var node = $("#EnPart").tree('find',nodeid);
								$("#EnPart").tree('uncheck',node.target);
							}
						});
					}else{
						addItmSelList(node.id, node.text);
					}
		        	//addItmSelList(node.id, node.text);
		        }else{
			    	delItmSelList(node.id);
			    }
	        }   
	    },
	    onLoadSuccess:function(node, data){
	    	//initPageBaseInfo(); /// ��ʼ������ҳ���������
	    	//$("span:contains('��ѡ��λ')").parent().find("span.tree-checkbox").remove();
			$("ul#EnPart>li>div").find("span.tree-checkbox").remove();
	    },
	    onClick:function(node){
			if (node.checked){
				$("#EnPart").tree('uncheck',node.target);
			}else{
				$("#EnPart").tree('check',node.target);
			}
		}
	};
	new CusTreeUX("EnPart", url, option).Init();
}

/// ҳ��DataGrid��ʼ����������б�
function initItemList(arExaItmID){
	
	var arExaItmID = arExaItmID.replace("_","||");
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}

	// ��λ�༭��
	var PosiEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaPosition&itmmastid="+arExaItmID+"&HospID="+LgHospID,
			valueField: "value", 
			textField: "text",
			multiple:true,
			editable:false,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var PosiED=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiDesc'});
				var tempPosiID = $(PosiED.target).combobox('getValues');
				var tempPosi = $(PosiED.target).combobox('getText');
				/// �ݴ���λID
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiID'});
				$(ed.target).val(tempPosiID);
				/// �ݴ���λ
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosi'});
				$(ed.target).val(tempPosi);
				/// ��ѡ��ĿΪ1��ʱ,ѡ�к�ֱ�ӹر�
				var rowData = $(PosiED.target).combobox('getData');
				if (rowData.length == 1){
					$(PosiED.target).combobox('hidePanel');
				}
			},
			onUnselect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiDesc'});
				var tempPosiID = $(ed.target).combobox('getValues');
				var tempPosi = $(ed.target).combobox('getText');
				/// �ݴ���λID
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiID'});
				$(ed.target).val(tempPosiID);
				/// �ݴ���λ
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosi'});
				$(ed.target).val(tempPosi);
			}
		}

	}
	
	///  ����columns
	var columns=[[
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'ItemPart',title:'��λ',width:200,align:'center'},
		{field:'ItemPosiID',title:'ItemPosiID',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosi',title:'ItemPosi',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosiDesc',title:'��λ',width:140,editor:PosiEditor},
		{field:'ItemRemark',title:'��ע',width:200,editor:texteditor},
		{field:'ItemOpt',title:'����',width:100,align:'center',formatter:SetCellDelUrl}
	]];
	
	///  ����datagrid
	var option = {
		border : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != -1||editRow == 0) { 
                //$("#dmPartList").datagrid('endEdit', editRow); 
            }
            //$("#dmPartList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	
	var params = "";
	var uniturl = "";
	new ListComponent('dmPartList', columns, uniturl, option).Init(); 
}

/// ����
function SetCellDelUrl(value, rowData, rowIndex){
	var html = "<a href='#' onclick='delItmRow("+rowData.ItemID+")'>ɾ��</a>";
    return html;
}

/// ɾ����
function delItmRow(PartID){
	
	/// ȡ��ѡ�нڵ�
	//var node = $("#EnPart").tree('find',PartID);
	//$("#EnPart").tree('uncheck',node.target);
	
	/// ȡ�������Ŀ��ѡ��
	if ($("#Part_"+PartID).is(":checked")){
		$("#Part_"+PartID).attr("checked",false);
	}
	
	/// ɾ��ѡ����
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(rowIndex, selItem){
		if (selItem.ItemID == PartID){
			/// ɾ����
			$("#dmPartList").datagrid('deleteRow',rowIndex);			
		}
	})
	
	/*
	/// ɾ����
	$("#dmPartList").datagrid('deleteRow',rowIndex);
	
	/// ˢ���б�����
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#dmPartList').datagrid('refreshRow', index);
	})
	*/
}

/// ѡ���¼�
function selectItem(){
	
	if ($(this).is(':checked')){
		
		/// ��λ
		var PartID = this.value;    /// ��λID
		var PartDesc = $(this).parent().next().text(); /// ��λ����
		addItmSelList(PartID, PartDesc);
	}else{
		
		var PartID = this.value;    /// ��λID
		delItmSelList(PartID);
	}
}

/// ������Ŀ�б�
function addItmSelList(id, text){

	var rowobj={ItemID:id, ItemPart:text, ItemPosiID:'', ItemPosi:'', ItemOpt:''}
	$("#dmPartList").datagrid('appendRow',rowobj);
	CheckForHidePrintClick();
	
	/// �����б༭     /// 2016-12-14 bianshuai �������б༭
	var rowsData=$("#dmPartList").datagrid('getRows');
	$("#dmPartList").datagrid('beginEdit', rowsData.length - 1);
}

/// ɾ���б�����
function delItmSelList(PartID){
	
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(rowIndex, selItem){
		if (selItem.ItemID == PartID){
			/// ɾ����
			$("#dmPartList").datagrid('deleteRow',rowIndex);			
		}
	})
	/*
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if (selItem.ItemID == id){
			delItmRow(index);  /// ɾ����Ӧ��
			return false;
		}
	})
	*/
}

/// ������
function initItemDisp(arExaItmID){
	
	var arExaItmID = arExaItmID.replace("_","||");
	$("#ItmExaDisp").html("");
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaDisp",{"itmmastid":arExaItmID, "HospID":LgHospID},function(jsonString){
		
		if (jsonString.length != 0){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				var html = '';
					html = html + '<tr style="height:30px">';
					html = html + '<td style="width:20px"><input name="ExaDisp" type="checkbox" value="'+ jsonObjArr[i].value +'"></input></td>';
					html = html + '<td>'+ jsonObjArr[i].text +'</td>';
					html = html + '</tr>';
				$("#ItmExaDisp").append(html);
			}
			/// ��������Ϊ�գ�չ�����
			//$('#PopPanel').layout('expand','east');
			$('#PopPanel').layout('show','east'); 
		}else{
			/// ��������Ϊ�գ��۵����
			//$('#PopPanel').layout('collapse','east');
			$('#PopPanel').layout('hidden','east'); 
		}
	},'json',false)
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
		var OpenForAllHosp=0,LogLoc="";
		var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
		var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
		if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
		if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
		
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
		
		/// �ѱ�
		var BillTypeID = "", BillType = "";
		if (typeof window.parent.frames.BillTypeID != "undefined"){
			BillTypeID = window.parent.frames.BillTypeID;  ///�ѱ�ID
			BillType = window.parent.frames.BillType;      ///�ѱ�
		}
	
		/// ������ѡ�б�
		var rowobj={ItemID:"", ItemArcID:"", ItemLabel:ItemLabel, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:arExaPartID, ItemExaDispID:arExaDispID, 
		ItemExaPosiID:arExaPosiID,ItemExaPurp:ItemLabel, ItemOpt:'', ItemStat:"��ʵ", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, ItemEmgFlag:arEmgFlag, ItemRemark:arExaRemark,
		ItemBillTypeID:BillTypeID, ItemBillType:BillType}
		$("#ItemSelList").datagrid('appendRow',rowobj);
		CheckForHidePrintClick();
		
	})
	
	clrItmChkFlag();   	  ///  ȡ�������Ŀѡ��״̬
	
	$("#dmPartList").datagrid('loadData',{total:0,rows:[]}); /// ���datagrid
	$('#PopUpWin').window("close");
	
	/// ������Ŀ
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  ȷ�ϼ����һ���Լ���������Ŀ bianshuai 2016-08-09
	GetExaReqItmCost();   ///  �����������ܽ��
	/// ȷ�����֮��,����Ĭ�ϵ����߿�
	$('#arPatSym').focus();    /// ���ý���
	
	///�Ӽ���ѡ��  sufan 2018-02-27
	//$('#arEmgFlag').attr("disabled",false);
}

///  �����Ŀ����ѡ�б�
function InsItemSelList(rows, arExaDispID, arExaDispDesc){

	var arExaItmID = $("#arExaItmID").text();     /// ��ʱ�洢��鷽��ID
	var id=arExaItmID;
	var arExaItmDesc = $("#arExaItmDesc").text(); /// ��ʱ�洢��鷽��
	var arExaItmID = arExaItmID.replace("_","||");
	var arEmgFlag = $("#"+id).attr("data-emtype");	 /// �Ƿ�����ѡ�Ӽ���ʶ	
	var arDefEmg= $("#"+id).attr("data-defsensitive");	 /// �Ƿ�Ĭ�ϼӼ�
	if (arDefEmg=="Y") arEmgFlag="C"; //
	/// ���տ���
	var ItemLocID = ""; var ItemLoc = "";
	var OpenForAllHosp=0,LogLoc="";
	var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
	var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
	if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
	if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
	
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			ItemLocID = jsonObjArr[0].value;
			ItemLoc = jsonObjArr[0].text;
		}
	},'json',false)
	
	/// ��鸽����Ϣ
	$.each(rows, function(index, rowData){
				
		var arExaPartID = rowData.ItemID;         /// ��λID
		var arExaPartDesc = rowData.ItemPart;     /// ��λ
		var arExaPosiID = rowData.ItemPosiID;     /// ��λID
		var arExaPosiDesc = rowData.ItemPosi;     /// ��λ
		var arExaRemark = rowData.ItemRemark;     /// ��ע
		var ItemLabel = arExaItmDesc;  /// �����Ŀ����
		
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
		
		var arReqDate  = "", uniqueID = "" //, arEmgFlag = "";
		
		/// �ѱ�
		var BillTypeID = "", BillType = "";
		if (typeof window.parent.frames.BillTypeID != "undefined"){
			BillTypeID = window.parent.frames.BillTypeID;  ///�ѱ�ID
			BillType = window.parent.frames.BillType;      ///�ѱ�
		}
		var mItmListData=[];
		mItmListData.push(arExaItmID +"^"+ arExaPosiID +"^"+ arExaPartID +"^"+ arExaDispID);
		mItmListData = mItmListData.join("&&");
		var ListData = "" +"^"+ EpisodeID +"^"+ pid +"#"+ mItmListData;
		var itemprice=""
		runClassMethod("web.DHCAPPExaReportQuery","GetExaReqItmCost",{"ListData":ListData},function(jsonString){
			if (jsonString > 0){
				itemprice = jsonString;
			}
		},'',false)
		/// ������ѡ�б�
		var rowobj={ItemID:"", ItemArcID:"", ItemLabel:ItemLabel, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:arExaPartID, ItemExaDispID:arExaDispID, 
		ItemExaPosiID:arExaPosiID,ItemExaPurp:ItemLabel, ItemOpt:'', ItemStat:"��ʵ", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, ItemEmgFlag:arEmgFlag, ItemRemark:arExaRemark,
		ItemBillTypeID:BillTypeID, ItemBillType:BillType, ItemPrice:itemprice}
		$("#ItemSelList").datagrid('appendRow',rowobj);
		CheckForHidePrintClick();
		
	})
	
	clrItmChkFlag();   	  ///  ȡ�������Ŀѡ��״̬
	
	//$("#dmPartList").datagrid('loadData',{total:0,rows:[]}); /// ���datagrid
	//$('#PopUpWin').window("close");
	
	/// ������Ŀ
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  ȷ�ϼ����һ���Լ���������Ŀ bianshuai 2016-08-09
	GetExaReqItmCost();   ///  �����������ܽ��
	/// ȷ�����֮��,����Ĭ�ϵ����߿�
	$('#arPatSym').focus();    /// ���ý���
	
	///�Ӽ���ѡ��  sufan 2018-02-27
	$('#arEmgFlag').attr("disabled",false);
}

/// �رյ�������
function closeWin(){
	
	var arExaItmID = $("#arExaItmID").text();
	/// ȡ�������Ŀѡ��Ч�� 
	$('#'+ arExaItmID).attr("checked",false);
	
	$("#arExaItmID").text("");     /// ��ʱ�洢��鷽��ID
	$("#arExaItmDesc").text("");   /// ��ʱ�洢��鷽��
	
	if (DocMainFlag == 1){
	   $('#PopUpWin').window("close");
	}
}

/// �����Ŀ�Ƿ���ʾ��λ��
function isShowPosi(arExaItmID){
	
	var arExaItmID = arExaItmID.replace("_","||");
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaPosition",{"itmmastid":arExaItmID, "HospID":LgHospID},function(jsonPosi){
		if (jsonPosi == ""){
			/// �����Ŀ�޶�Ӧ��λʱ��������λ��
			$("#dmPartList").datagrid('hideColumn','ItemPosiDesc');
		}
	},'json',false)
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

/// ������Ŀ�Ƿ�Ϊ����
function itmIsRequired(){
	
	var resval = "";
	runClassMethod("web.DHCAPPExaReport","ItmIsRequired",{"pid":pid},function(jsonString){

		if (jsonString != ""){
			resval = jsonString;
		}
	},'',false)

	return resval;
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
				InitInsSelItem(itemArr[i]);  /// ������ѡ��Ŀ�б�
			}
		}
	},'json',false)
	
}

/// �������ȷ��
function sureExaReq(){
	
	if (editSelRow != -1||editSelRow == 0) { 
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	} 
    
	var itemExaDisHis = $("#arDisHis").val().replace(/\s/g,'');  /// �ֲ�ʷ
	if (itemExaDisHis == "�������ֲ�ʷ������"){
		itemExaDisHis = "";
	}
	
	var itemExaPhySig = $("#arPhySig").val().replace(/\s/g,'');  /// ����
	if (itemExaPhySig == "������������"){
		itemExaPhySig = "";
	}
		
	var itemExaSym = $("#arPatSym").val().replace(/\s/g,'');     /// ����
	if (itemExaSym == "���������ߣ�"){
		itemExaSym = "";
	}
	if (itemExaSym == ""){
		$.messager.alert("��ʾ:","�������߲���Ϊ�գ�","info",function(){
			$('#arPatSym').focus();    /// ���ý���
		});
		return;
	}
	var ExaPurp=$("#ExaPurp").val().replace(/\s/g,'');     /// ���Ŀ��
	if (ExaPurp == "��������Ŀ�ģ�"){
		ExaPurp = "";
	}
	if (ExaPurp == ""){
		var ExaPurpflag=dhcsys_confirm(('���Ŀ��Ϊ�ղ��ܱ���,�Ƿ��Զ�Ĭ��Ϊ��Ŀ���ƣ�'),true);
		if (ExaPurpflag==false){
		return;
		}else{
			var ExaPurp=""
			var selItems=$("#ItemSelList").datagrid('getRows');
			$.each(selItems, function(index, selItem){
				var ItemLabel = selItem.ItemLabel;               /// ��ĿID
				if (ExaPurp=""){ExaPurp=ItemLabel}else{ExaPurp=ExaPurp+","+ItemLabel}
			})
			$("#ExaPurp").val(ExaPurp);	
		}
	}
	
	/// ���
	var PatDiagsArr = [];
	$('input[name="Diags"]:checked').each(function(){
		PatDiagsArr.push(this.value +String.fromCharCode(4)+ $(this).parent().next().text()); //mDel
	})
	if ((PatDiagsArr.length == 0)&&(OrderLimit==0)){
		$.messager.alert("��ʾ:","��ϲ���Ϊ�գ�","info",function(){
		});
		return;
	}
	var PatDiags = PatDiagsArr.join("@");
	var AitemExaPurp=$("#ExaPurp").val();
	/// ��������������Ϣ
	var mPatSymData = EpisodeID + String.fromCharCode(4) + itemExaDisHis + String.fromCharCode(4) + itemExaPhySig + String.fromCharCode(4) + itemExaSym+String.fromCharCode(4) + AitemExaPurp;
	
	var tips = itmIsRequired();   /// ������Ŀ�Ƿ�Ϊ����
	if (tips != ""){
		$.messager.alert("��ʾ:","������Ŀ:" + tips +"����Ϊ�գ�");
		return;
	}

	var itemLocFlag = 0; var mItmMastArr = [];
	//var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// �Ӽ�
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
		if (typeof itemExaDispID == "undefined"){
			itemExaDispID = "";
		}

		///var itemExaPurp = selItem.ItemExaPurp;  /// ���Ŀ��
		///var itemExaPurp = selItem.ItemLabel;	   /// ���Ŀ��
		var itemExaPurp="" //$("#ExaPurp").val();	   /// ȡ�ֶ�¼��ļ��Ŀ��  sufan 2018-01-12
		var arReqDate = selItem.ItemReqDate;	   /// ҽ������
		var uniqueID = selItem.ItemUniqueID;	   /// Ψһ��ʾ
		var arEmgFlag = selItem.ItemEmgFlag;	   /// �Ӽ���־
		
		var itemRemark = selItem.ItemRemark;	   /// ��ע
		var arEmgFlag = $("#CK_EmFlag"+index).is(":checked")? "Y":"N";     /// �Ӽ�
		if ($.inArray(itmmmastid+"^"+uniqueID,mItmMastArr) == "-1"){
			mItmMastArr.push(itmmmastid+"^"+uniqueID);
		}
		var ListData = EpisodeID +"^"+ itemLocID +"^"+ arEmgFlag +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ "" +"^"+ "" +"^"+ LgCtLocID +"^"+ "" +"^"+ "N" +"^"+ PatDiags;
			ListData = ListData +String.fromCharCode(2)+ itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID +"^"+ arReqDate +"^"+ uniqueID +"^"+ arEmgFlag +"^"+ itemRemark;

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
	
	mItmListData = mItmListData.join(String.fromCharCode(1));

	if (mItmListData == ""){
		$.messager.alert("��ʾ:","û�д�������Ŀ,��ѡ������Ŀ�����ԣ�");
		return;
	}
	/// ����ģ������
	runClassMethod("web.DHCAPPExaReport","saveDoc",{"pid":pid, "ListData":mItmListData, "mPatSymData":mPatSymData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			window.returnValue = jsonString;
			window.close();
		}
	},'',false)
	
}

/// �벡���ɵ��ú���
function InsertDoc(){
	
	if (editSelRow != -1||editSelRow == 0) { 
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	} 
    
	var itemExaDisHis = $("#arDisHis").val().replace(/\s/g,'');  /// �ֲ�ʷ
	if (itemExaDisHis == "�������ֲ�ʷ������"){
		itemExaDisHis = "";
	}
	
	var itemExaPhySig = $("#arPhySig").val().replace(/\s/g,'');  /// ����
	if (itemExaPhySig == "������������"){
		itemExaPhySig = "";
	}
		
	var itemExaSym = $("#arPatSym").val().replace(/\s/g,'');     /// ����
	if (itemExaSym == "���������ߣ�"){
		itemExaSym = "";
	}
	if (itemExaSym == ""){
		window.parent.frames.InvErrMsg("��������롿�������߲���Ϊ�գ�");
		$('#arPatSym').focus();    /// ���ý���
		return false;
	}
	var ExaPurp=$("#ExaPurp").val().replace(/\s/g,'');     /// ���Ŀ��
	if (ExaPurp == "��������Ŀ�ģ�"){
		ExaPurp = "";
	}
	if (ExaPurp == ""){
		var ExaPurpflag=dhcsys_confirm(('���Ŀ��Ϊ�ղ��ܱ���,�Ƿ��Զ�Ĭ��Ϊ��Ŀ���ƣ�'),true);
		if (ExaPurpflag==false){
		return;
		}else{
			var ExaPurp=""
			var selItems=$("#ItemSelList").datagrid('getRows');
			$.each(selItems, function(index, selItem){
				var ItemLabel = selItem.ItemLabel;               /// ��ĿID
				if (ExaPurp=""){ExaPurp=ItemLabel}else{ExaPurp=ExaPurp+","+ItemLabel}
			})
			$("#ExaPurp").val(ExaPurp);	
		}
	}
	/// ���
	var PatDiagsArr = [];
	$('input[name="Diags"]:checked').each(function(){
		PatDiagsArr.push(this.value +String.fromCharCode(4)+ $(this).parent().next().text()); //mDel
	})
	if ((PatDiagsArr.length == 0)&&(OrderLimit==0)){
		$.messager.alert("��ʾ:","��ϲ���Ϊ�գ�");
		return;
	}
	var PatDiags = PatDiagsArr.join("@");

	/// ��������������Ϣ
	var mPatSymData = EpisodeID + String.fromCharCode(4) + itemExaDisHis + String.fromCharCode(4) + itemExaPhySig + String.fromCharCode(4) + itemExaSym;

	var tips = itmIsRequired();   /// ������Ŀ�Ƿ�Ϊ����
	if (tips != ""){
		window.parent.frames.InvErrMsg("��������롿������Ŀ:" + tips +"����Ϊ�գ�");
		return false;
	}

	var itemLocFlag = 0; var mItmMastArr = [];
	//var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// �Ӽ�
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
		if (typeof itemExaDispID == "undefined"){
			itemExaDispID = "";
		}
		///var itemExaPurp = selItem.ItemExaPurp;  /// ���Ŀ��
		//var itemExaPurp = selItem.ItemLabel;	   /// ���Ŀ��
		var itemExaPurp=$("#ExaPurp").val();	   /// ȡ�ֶ�¼��ļ��Ŀ��  sufan 2018-01-12
		var arReqDate = selItem.ItemReqDate;	   /// ҽ������
		var uniqueID = selItem.ItemUniqueID;	   /// Ψһ��ʾ
		var arEmgFlag = selItem.ItemEmgFlag;	   /// �Ӽ���־
		var itemRemark = selItem.ItemRemark;	   /// ��ע
		var arEmgFlag = $("#CK_EmFlag"+index).is(":checked")? "Y":"N";     /// �Ӽ�
		if ($.inArray(itmmmastid+"^"+uniqueID,mItmMastArr) == "-1"){
			mItmMastArr.push(itmmmastid+"^"+uniqueID);
		}
		
		var ListData = EpisodeID +"^"+ itemLocID +"^"+ arEmgFlag +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ "" +"^"+ "" +"^"+ LgCtLocID +"^"+ "" +"^"+ "N" +"^"+ PatDiags;
			ListData = ListData +String.fromCharCode(2)+ itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID +"^"+ arReqDate +"^"+ uniqueID +"^"+ arEmgFlag +"^"+ itemRemark;
        //"#"
		mItmListData.push(ListData);
	})
	if (itemLocFlag == 1){
		window.parent.frames.InvErrMsg("��������롿���տ��Ҳ���Ϊ�գ�");
		return false;
	}
	/// ��Ŀ��һ��ʱ��������ʾ
	if (mItmMastArr.length != mItmMastLen){
		GetTmpItmMastTip(mItmMastArr);
		return false;
	}	
	
	//mItmListData = mItmListData.join("!!");
    mItmListData = mItmListData.join(String.fromCharCode(1));
	if (mItmListData == ""){
		window.parent.frames.InvErrMsg("��������롿û�д�������Ŀ,��ѡ������Ŀ�����ԣ�");
		return false;
	}
	/// ����ģ������
	runClassMethod("web.DHCAppPisMaster","InsExaTempDoc",{"Pid":pid, "mListData":mItmListData, "mPatSymData":mPatSymData},function(jsonString){
		if (jsonString < 0){
			window.parent.frames.InvErrMsg("��������롿������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
			return false;
		}
	},'',false)
	return true;
}

/// �رյ�������
function closePopWin(){
	
	window.close();        /// �رյ�������
}

/// ȡ�������Ŀѡ��״̬
function clrItmChkFlag(){
	
	var arExaItmID = $("#arExaItmID").text();
	/// ȡ�������Ŀѡ��Ч�� 
	$('#'+ arExaItmID).attr("checked",false);
	
	$("#arExaItmID").text("");     /// ��ʱ�洢��鷽��ID
	$("#arExaItmDesc").text("");   /// ��ʱ�洢��鷽��
}

/// ������ѡ��Ŀ�б�
function InitInsSelItem(itemobj){
	
	var mItmMastStr = itemobj.value;  /// ҽ����Ŀ��
	var arExaItmDesc = itemobj.text;  /// ҽ��������
	var arExaItmID = mItmMastStr.split("*")[3]; /// ҽ����ID
	var arExaItmID = arExaItmID.replace("_","||");
	/// ���տ���
	var ItemLocID = ""; var ItemLoc = "";
	/// ҽ���������ʱ,ȡֵ��ʽ
	var LocID = mItmMastStr.split("*")[1];
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmRecLoc",{"LocID":LocID},function(jsonString){
	
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			ItemLocID = jsonObjArr[0].value;
			ItemLoc = jsonObjArr[0].text;
		}
	},'json',false)

	var arReqDate  = "", uniqueID = "", arEmgFlag = "";
	var ItemPartID = ""; var ItemDispID = ""; var ItemPosiID = "";
	/// ҽ���������ʱ,ȡֵ��ʽ
	arEmgFlag = mItmMastStr.split("*")[0];  /// �Ӽ���־
	arReqDate = mItmMastStr.split("*")[2];  /// ҽ������
	uniqueID = mItmMastStr.split("*")[4];   /// Ψһ��ʾ
	ItemPartID = mItmMastStr.split("*")[5]; /// ��λID
	ItemDispID = mItmMastStr.split("*")[6]; /// ����ID

	/// ���ڷ���ʱ���жϷ�����Ŀ�Ƿ��뿪����Ŀһֱ
	mItmMastDocArr.push(mItmMastStr +"*"+ arExaItmDesc);
	
	/// ������ѡ�б�
	var rowobj={ItemID:"", ItemArcID:"", ItemLabel:arExaItmDesc, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:ItemPartID, 
	ItemExaDispID:ItemDispID, ItemExaPosiID:ItemPosiID,ItemExaPurp:arExaItmDesc, ItemOpt:'1', ItemStat:"��ʵ", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, ItemEmgFlag:arEmgFlag, ItemRemark:''}
	$("#ItemSelList").datagrid('appendRow',rowobj);
	CheckForHidePrintClick();
	/// ������Ŀ
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  ȷ�ϼ����һ���Լ���������Ŀ bianshuai 2016-08-09
	GetExaReqItmCost();   ///  �����������ܽ��
	setTimeout(function(){ 
		var GridData=$("#ItemSelList").datagrid('getData'); 
		var LastIndex=GridData.total-1;
		$('#CK_EmFlag'+LastIndex).prop("checked",arEmgFlag=="Y"?true:false);
		if (DocMainFlag == 1){
			$('#CK_EmFlag'+LastIndex).attr("disabled",true);
		}
	 }); 
}

/// ��֤�����Ƿ�����ҽ��
function initPatNotTakOrdMsg(){
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		//$.messager.alert("��ʾ:",TakOrdMsg);
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

///����ʱ������ʾ����  sufan  2016/12/20
function savesymmodel()
{
	var patsymtom=$("#arPatSym").val();
	if ((patsymtom=="�������ߣ�")||patsymtom=="")
	{
		$.messager.alert("��ʾ:","û�д��������ݣ�");
		return;
		}
	createsymPointWin();    ///����ʾ����
}

/// �������߿���ģ��
function saveSymLoc()
{
	var patsymtom=$("#arPatSym").val();  // ������Ϣ
	var amSaveas="";					 // �������
	var params=EpisodeID+"^"+patsymtom+"^"+amSaveas+"^"+LgCtLocID+"^"+LgUserID;
	SaveSym(params);   // ���ñ��溯��
}

/// �������߸���ģ��
function saveSymUser()
{
	var patsymtom=$("#arPatSym").val();	// ������Ϣ
	var amSaveas=LgUserName;			// �������
	var params=EpisodeID+"^"+patsymtom+"^"+amSaveas+"^"+LgUserID+"^"+LgUserID;
	SaveSym(params);	// ���ñ��溯��
}

/// ���溯��
function SaveSym(params)
{
	runClassMethod("web.DHCAPPExaReport","SavePatSymModel",{"params":params},function(jsonString){
		if (jsonString==0)
		{
			$('#symwin').window('close');
			$.messager.alert("��ʾ:","����ɹ���");
			}
		if (jsonString=="-1")
		{	$('#symwin').window('close');
			$.messager.alert("��ʾ:","�����Ѵ��ڣ�");
			}
	},'',false)
}
///����ʱ������ʾ����  sufan  2016/12/20
function saveprehismodel()
{	
	var patprehis=$("#arDisHis").val();
	if ((patprehis=="�������ߣ�")||patprehis=="")
	{
		$.messager.alert("��ʾ:","û�д��������ݣ�");
		return;
		}
	createPrehisPointWin();		 ///����ʾ����
}

/// �����ֲ�ʷ����ģ��
function savePrehisLoc()
{
	var patprehis=$("#arDisHis").val();		// �ֲ�ʷ��Ϣ
	var apSaveas=""							// �������
	var params=EpisodeID+"^"+patprehis+"^"+apSaveas+"^"+LgCtLocID+"^"+LgUserID;
	SavePrehis(params);		// ���ñ��溯��
}

/// �����ֲ�ʷ����ģ��
function savePrehisUser()
{
	var patprehis=$("#arDisHis").val();		// �ֲ�ʷ��Ϣ
	var apSaveas=LgUserName;				// �������
	var params=EpisodeID+"^"+patprehis+"^"+apSaveas+"^"+LgUserID+"^"+LgUserID;
	SavePrehis(params);		// ���ñ��溯��
}
/// ���溯��
function SavePrehis(params)
{
	runClassMethod("web.DHCAPPExaReport","SavePreHis",{"params":params},function(jsonString){
		if (jsonString==0)
		{
			$('#prehis').window('close');
			$.messager.alert("��ʾ:","����ɹ���");
			}
		if (jsonString=="-1")
		{
			$('#prehis').window('close');
			$.messager.alert("��ʾ:","�����Ѵ��ڣ�");
			}
	},'',false)
}

///����ʱ������ʾ����  sufan  2016/12/20
function savesignmodel()
{
	var patsign=$("#arPhySig").val();
	if ((patsign=="�������ֲ�ʷ������")||patsign=="")
	{
		$.messager.alert("��ʾ:","û�д��������ݣ�");
		return;
		}
	createPatsignPointWin();		///����ʾ����
}

/// ������������ģ��
function savePatsignLoc()
{
	var patsign=$("#arPhySig").val();
	var aptSaveas=""
	var params=EpisodeID+"^"+patsign+"^"+aptSaveas+"^"+LgCtLocID+"^"+LgUserID;
	SavePatsign(params);		// ���ñ��溯��
}
/// ������������ģ��
function savePatsignUser()
{
	var patsign=$("#arPhySig").val();
	var aptSaveas=LgUserName
	var params=EpisodeID+"^"+patsign+"^"+aptSaveas+"^"+LgUserID+"^"+LgUserID;
	SavePatsign(params);		// ���ñ��溯��
}
/// ���溯��
function SavePatsign(params)
{
	runClassMethod("web.DHCAPPExaReport","SaveSignModel",{"params":params},function(jsonString){
		if (jsonString==0)
		{
			$('#patsign').window('close');
			$.messager.alert("��ʾ:","����ɹ���");
			}
		if (jsonString=="-1")
		{
			$('#patsign').window('close');
			$.messager.alert("��ʾ:","�����Ѵ��ڣ�");
			}
	},'',false)
}
///������Ŀ��ʱ������ʾ����  sufan  2018-10-17
function savePurmodel()
{
	var ExaPurp=$("#ExaPurp").val();
	if ((patsign=="��������Ŀ�ģ�")||ExaPurp=="")
	{
		$.messager.alert("��ʾ:","û�д��������ݣ�");
		return;
		}
	createPurPointWin();		///����ʾ����
}

/// ���������ģ��
function savePatpurLoc()
{
	var ExaPurp=$("#ExaPurp").val();
	var aptSaveas=""
	var params=EpisodeID+"^"+ExaPurp+"^"+aptSaveas+"^"+LgCtLocID+"^"+LgUserID;
	SavePatPur(params);		// ���ñ��溯��
}
/// ������Ŀ�ĸ���ģ��
function savePatpurUser()
{
	var ExaPurp=$("#ExaPurp").val();
	var aptSaveas=LgUserName
	var params=EpisodeID+"^"+ExaPurp+"^"+aptSaveas+"^"+LgUserID+"^"+LgUserID;
	SavePatPur(params);		// ���ñ��溯��
}
/// ���溯��
function SavePatPur(params)
{
	runClassMethod("web.DHCAPPExaReport","SavePurModel",{"params":params},function(jsonString){
		if (jsonString==0)
		{
			$('#patpur').window('close');
			$.messager.alert("��ʾ:","����ɹ���");
			}
		if (jsonString=="-1")
		{
			$('#patpur').window('close');
			$.messager.alert("��ʾ:","�����Ѵ��ڣ�");
			}
	},'',false)
}
///������Ŀ��ģ��  sufan  2016/12/20
function showmodel(flag)
{	
	if($('#winonline').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:'ģ���б�',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:550,
		height:450
	});
	var iframepatsym = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.patsymtemp.csp"></iframe>';
	var iframeprehis = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.prehistmp.csp"></iframe>';
	var iframesign = '<iframe   scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.resultwindow.csp"></iframe>';
	var iframepur = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.exeapurmodel.csp"></iframe>';
	if (flag==1)
	{
		$('#winonline').html(iframepatsym);
	 }
	if (flag==2)
	{
		$('#winonline').html(iframeprehis);
	 }
	if (flag==3)
	{
		$('#winonline').html(iframesign);
	 }
	if (flag==4)
	{
		$('#winonline').html(iframepur);
	}
		$('#winonline').window('open');
}
/// ��ʾ����
function createsymPointWin(){	
	if($('symwin').is(":hidden")){
	   $('symwin').window('open');
		return;
		}           ///���崦�ڴ�״̬,�˳�	
	/// ��ѯ����
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('ѡ��', 'symwin', '260', '130', option).Init();
}
/// ��ʾ����
function createPrehisPointWin(){	
	if($('prehis').is(":hidden")){
	   $('prehis').window('open');
		return;
		}           ///���崦�ڴ�״̬,�˳�	
	/// ��ѯ����
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('ѡ��', 'prehis', '260', '130', option).Init();
}
/// ��ʾ����
function createPatsignPointWin(){	
	if($('patsign').is(":hidden")){
	   $('patsign').window('open');
		return;
		}           ///���崦�ڴ�״̬,�˳�	
	/// ��ѯ����
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('ѡ��', 'patsign', '260', '130', option).Init();
}
/// ���Ŀ����ʾ����
function createPurPointWin(){	
	if($('#patpur').is(":hidden")){
	   $('#patpur').window('open');
		return;
	}           ///���崦�ڴ�״̬,�˳�	
	/// ��ѯ����
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('ѡ��', 'patpur', '260', '130', option).Init();
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
	window.parent.frames.GetPatBaseInfo();  ///  ���ز�����Ϣ
}

/// �жϷ�����Ŀ�Ƿ��뿪����Ŀһ��ʱ����ʾ����
function GetTmpItmMastTip(mItmMastArr){
	var TmpItmMastTipArr = [];
	for(var x=0;x<mItmMastLen;x++){
		var itmmmastid = mItmMastDocArr[x].split("*")[3]; /// ҽ����ID
		var itmmmastid = itmmmastid.replace("_","||");
		var uniqueID = mItmMastDocArr[x].split("*")[4];	  /// Ψһ��ʾ
		var itmmmast = mItmMastDocArr[x].split("*")[6];   /// ��Ŀ����
		if ($.inArray(itmmmastid+"^"+uniqueID,mItmMastArr) == "-1"){
			TmpItmMastTipArr.push(itmmmast);
		}
	}
	//$.messager.alert("��ʾ:","��Ŀ��"+TmpItmMastTipArr.join("��")+"δѡ��λ������ѡ��λ��");
	window.parent.frames.InvErrMsg("��Ŀ��"+TmpItmMastTipArr.join("��")+"δѡ��λ������ѡ��λ��");
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
	
	$("#ItemSelList").datagrid("load",{"params":arRepID});
	//$('#arEmgFlag').prop("checked",repEmgFlag=="��"?true:false);
	arExaReqIdList = arRepID;
	///�Ӽ���ֹѡ��  sufan 2018-02-27
	//$('#arEmgFlag').attr("disabled",true); 
	itemReqID = arRepID;
	/// ����������Ŀ
	LoadItmOtherOpot(arRepID, arRepID);
	LoadExaReqHisSign();          /// ���ز����ֲ�ʷ������
	LoadExaReqDiags(arRepID);     /// ���ز����������
	InitGetReqEditFlag(arRepID);  /// ���뵥�Ƿ�����༭
	LoadExaPurpose(arRepID);
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
		$("#arPatSym").attr("disabled", true);    /// ����
		$("#arDisHis").attr("disabled", true);    /// �ֲ�ʷ
		$("#arPhySig").attr("disabled", true);    /// ����
		$("#ExaPurp").attr("disabled", true);     /// ���Ŀ��
		$('input[name="Diags"]').attr("disabled",true); /// ���
		$('#bt_sendreq').linkbutton('disable');   /// ���Ͱ�ť����
		$('#bt_sendreq').removeClass('btn-lightgreen');
	}else{
		$("#arPatSym").attr("disabled", false);     /// ����
		$("#arDisHis").attr("disabled", false);     /// �ֲ�ʷ
		$("#arPhySig").attr("disabled", false);     /// ����
		$("#ExaPurp").attr("disabled", false);      /// ���Ŀ��
		$('input[name="Diags"]').attr("disabled",false); /// ���
		$('#bt_sendreq').linkbutton('enable');      /// ���Ͱ�ť����
		$('#bt_sendreq').addClass('btn-lightgreen');
	}
}

/// �����Ŀ�Ӽ�
function setReqEmgFlag(){

	var selItems=$("#ItemSelList").datagrid('getRows');
	var Flag = false;
	$.each(selItems, function(index, selItem){
		var itmmmastid = selItem.ItemExaID;           /// ҽ����ID
		if ((!Flag)&(GetEmgFlag(itmmmastid) == "Y")){
			//$("#arEmgFlag").prop("checked", true);    /// �Ӽ�
			//$("#arEmgFlag").parent().show();
			Flag = true;
		}
	})

	if (!Flag){
		//$("#arEmgFlag").prop("checked", false);       /// �Ӽ�
		//$("#arEmgFlag").parent().hide();
	}
}

/// ȡҽ���ļӼ���־
function GetEmgFlag(arcimid){
	
	var EmgFlag = false;
	runClassMethod("web.DHCAPPExaReportQuery","GetItmEmFlag",{"arcimid":arcimid},function(jsonString){
		
		EmgFlag = jsonString;
	},'text',false)
	return EmgFlag
}
///ȡ���Ŀ��
function LoadExaPurpose(arRepID)
{
	runClassMethod("web.DHCAPPExaReportQuery","GetExaPurpose",{"arRepID":arRepID},function(data){
		$("#ExaPurp").val(data);
	},'',false)
	
}
/// ɾ����ʱglobal
function killTmpGlobal(){

	runClassMethod("web.DHCAPPExaReportQuery","killTmpGlobal",{"pid":pid},function(jsonString){
	},'',false)
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    var RtnFlag=""
    var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		
		var ItemID = selItem.ItemID;               /// ��ĿID
		var itmmmastid = selItem.ItemExaID;        /// ҽ����ID
		if ((itmmmastid!="")){
			RtnFlag=1
			}
	})
	if (itemReqID ==""){
		if (RtnFlag == "1"){
					return "��δ�����ҽ�����Ƿ��뿪�˽���"
				}else{
					killTmpGlobal();  /// �����ʱglobal
					return;	
			}
	}else{ 
		killTmpGlobal();  /// �����ʱglobal
		return ;}
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
///�жϴ�ӡ�Ƿ�Ӧ������
function CheckForHidePrintClick(){
	var PrintFlag=0
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		var itmmmastid = selItem.ItemExaID;           /// ҽ����ID
		var ItemArcID = selItem.ItemArcID; 
		var PrintFlagRtn=$.cm({
			ClassName:"web.DHCAPPPrintCom",
			MethodName:"GetAllPrinttemp",
			dataType:"text",
			itmArcCatID:ItemArcID,
			ItemExaID:itmmmastid,
		},false);
		if (PrintFlagRtn!=""){PrintFlag=1}
	
	})
	if (PrintFlag==0){
		$("#bt_printreq").hide();//linkbutton("disable");
	}else{$('#bt_printreq').show();  }
}
//��¼������������ʹ�ô���
function DHCDocUseCount(ValueId, TableName) {
    var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
}
window.onload = onload_handler;
window.onbeforeunload = onbeforeunload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
