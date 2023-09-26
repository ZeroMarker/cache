//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2016-07-05
// ����:	   �°�������
//===========================================================================================

var EpisodeID = "";      /// ���˾���ID
var arItemCatID = "";    /// ������ID
var itemSelFlag = "";    /// ��ѡ�б���ǰ״ֵ̬
var arExaReqIdList = "";
var editRow = ""; var editSelRow="";
var repStatusArr = [{"value":"V","text":'��ʵ'}, {"value":"D","text":'ֹͣ'}];

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
/// ҳ���ʼ������
function initPageDefault(){
		
	InitPatEpisodeID();   /// ��ʼ�����ز��˾���ID
	
	initVersionMain();    ///  ҳ���������
	
	initDataGrid();  	  ///  ҳ��DataGrid��ʼ����
	initItemSelList();    ///  ҳ��DataGrid��ʼ����
	//initCheckPartTree();  ///  ��ʼ����鲿λ��
	initCombobox();       ///  ҳ��Combobox��ʼ����
	initBlButton();       ///  ҳ��Button���¼�
	initCheckBoxEvent();  ///  ҳ��CheckBox�¼�
	initCombogrid();      ///  ҳ��Combogrid�¼�
	
	GetPatBaseInfo();     ///  ���ز�����Ϣ
	LoadExaReqHisSign();  ///  ���ز����ֲ�ʷ������
		
	LoadPageBaseInfo();   ///  ��ʼ�����ػ�������
	
	initPatNotTakOrdMsg(); /// ��֤�����Ƿ�������ҽ��
	initItemInstrDiv();    /// �����Ŀ˵����
}

/// ҳ���������
function initVersionMain(){

	/// ��������Ϊ�ɰ�ʱ,�����������°�¼�����
	if (DocMainFlag == 1){
		version = 1;
	}
	
    <!-- �¾ɰ汾�������� -->
    if (version == 1){
	    
	    /// �°�ʱ,���ؼ�������
		//$("#ItemPanel").layout('remove','north');
		initCheckPartTreeNew();  ///  ��ʼ����鲿λ��
	}else{
		initItemListOLD();       ///  ҳ��DataGrid�������б�
		initCheckPartTree();     ///  ��ʼ����鲿λ��
	}
	
	/// ҽ���������ʱ,��ʼ������
	if (DocMainFlag == 1){
		/// ���ý��水ť����
		//$('button:contains("����")').text("ȷ��");
		$('button:contains("��ӡ")').text("�ر�");
		/// ���ء����ξ������뵥�б������������Ŀ��
		$('#MainPanel').layout('hidden','west');  /// �����ξ������뵥�б���
		$('#CenPanel').layout('hidden','west');   /// �������Ŀ��
		$('#arPatSym').focus();    /// ���ý���
		$('#arEmgFlag').parent().parent().hide(); /// �Ӽ���־����
	}else{
		$('#ExaCatCode').focus();  /// ���ý���
	}
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
	CloseFlag = getParam("CloseFlag");
	
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
}

///  ��ʼ�����ػ�������
function LoadPageBaseInfo(){
	
	/// ��ʼ��������
	<!-- �¾ɰ汾�������� -->
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+LgHospID;
	if (version == 1){
		uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+LgHospID;
	}
	if ((version == 1)&(expFlag == 1)){
		uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID;
	}

	$('#CheckPart').tree('options').url = uniturl;
	$('#CheckPart').tree('reload');
	
	/// ��ʷ���뵥����
	//var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqHisList&params="+EpisodeID;
	//$('#dgEmPatList').datagrid({url:uniturl});
	
	/// �������б�
	if (version != 1){
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckItemList";
		$('#itemList').datagrid({url:uniturl});
	}
	
	/// ��ѡ��Ŀ�б�
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqDetList";
	$('#ItemSelList').datagrid({url:uniturl});
	
	/// ҽ���������ʱ,��ʼ������
	if (DocMainFlag == 1){
		LoadCheckItemByDoc();   /// ��ʼ����鷽������
	}
	
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	runClassMethod("web.DHCAPPExaReportQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
		})
	},'json',false)
}

/// ҳ��DataGrid��ʼ����
function initDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'PatLabel',title:'���뵥',width:180,formatter:setCellLabel,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	        itemSelFlag = 1;  /// ��ѡ�б���ǰ״ֵ̬
	        /// ���뵥��ѡ�б�
	        var params = rowData.arRepID;
			$("#ItemSelList").datagrid("load",{"params":params});
			
			$('#arEmgFlag').attr("checked",rowData.repEmgFlag=="��"? true:false);
			
			/// ����������Ŀ
			LoadItmOtherOpot(rowData.arRepID,rowData.arRepID);
			
			arExaReqIdList = rowData.arRepID;
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
	    }
	};

	var params = EpisodeID +"^^^"+ LgHospID;
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqHisList&params="+params;
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
	
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.arExaReqCode +'</h3><h4 style="float:left;padding-left:10px;background-color:transparent;">'+ rowData.arReqData+'</h4><h3 style="float:right;color:red;background-color:transparent;"><span>'+ rowData.repStatCode +'</span></h3><br>';
		/*
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
			if (TempCArr[1].length > 7){
				TempCText = TempCArr[1];					   /// �����Ŀȫ�� ������ʾ
				TempCArr[1]=TempCArr[1].substring(0,6)+"...";  /// �����Ŀ����ʾ7���ַ�
			}
			var FontColor = "";
			if (TempCArr[2] == "IM"){ 
				FontColor="#FF69B4";    /// �����Ŀ�б��淵��,��ʾ��ɫ����
			}

			htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px;color:'+FontColor+'" name="'+TempCText+'">'+ TempCArr[1] +'</span></h4>';
			htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px">';
			/// �Ƿ���ҪԤԼ
			if (TempCArr[3] == "Y"){
				htmlstr = htmlstr + '<a href="#" onclick="showItmDetWin('+rowData.arRepID+')">ԤԼ</a>';
			}
			htmlstr = htmlstr + '&nbsp;&nbsp;&nbsp;<a href="#" onclick="showItmRetWin(\''+TempCArr[0]+'\')">���</a></span></h4><br>';
		}
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// �����Ŀ����ʾ��
function BindTips(){
	var html='<div id="tip" style="border-radius:3px; display:none; border:1px solid #000; padding:10px;position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	/// ����뿪
	$('h4 span').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('h4 span').on({
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
			url: '', //LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID=11207||1",
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
		{field:'ItemEmgFlag',title:'�Ӽ���־',width:100,hidden:true},
		{field:'ItemTarItm',title:'�շ���Ŀ',width:100,align:'center',formatter:SetCellTarUrl},
		{field:'ItemXUser',title:'������',width:100,align:'center'},
		{field:'ItemXDate',title:'��������',width:100,align:'center'},
		{field:'ItemXTime',title:'����ʱ��',width:100,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
		onClickRow:function(rowIndex, rowData){

			/// ���Ŀ��
	        LoadArcItemPurp(rowData.ItemExaPurp);
	        
	        /// ����ע������
	        LoadItemTemp(rowData.ItemExaID);
	    },
		onLoadSuccess:function(data){

			//itemSelFlag = 1;    /// ��ѡ�б���ǰ״ֵ̬
			GetExaReqItmCost();   /// �����������ܽ��
			var selItems=$("#ItemSelList").datagrid('getRows');
			if (selItems != ""){
				LoadArcItemPurp(selItems[0].ItemExaPurp);
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

	    	if (rowData.ItemID != "") return;
            if (editSelRow != ""||editSelRow == 0) { 
                $("#ItemSelList").datagrid('endEdit', editSelRow); 
            } 
            $("#ItemSelList").datagrid('beginEdit', rowIndex); 
            
            editSelRow = rowIndex; 
            
			///���ü���ָ��
			var ed=$("#ItemSelList").datagrid('getEditor',{index:rowIndex,field:'ItemLoc'});
			var unitUrl=LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+rowData.ItemExaID;
			$(ed.target).combobox('reload',unitUrl);
        }
	};

	var uniturl = ""; //LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqDetList";
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
				$.messager.alert("��ʾ:","��Ŀ���շѣ�������������");
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
			$("#dgEmPatList").datagrid("reload");   /// ˢ��ҳ������
		}
	});
}

/// ����ִ��ѡ����Ŀ
function revExaReqItm(arReqItmID,itmmastid,PartID){
	
	if (arReqItmID == "") return;
	runClassMethod("web.DHCAPPExaReport","revExaReqItm",{"arRepItmID":arReqItmID, "PartID":PartID, "LgParam":LgUserID+"^"+LgCtLocID+"^"+LgGroupID},function(jsonString){
		
		if (jsonString == 1){
			$.messager.alert("��ʾ:","��Ŀ��ִ�У�������������");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","��Ŀ���շѣ�������������");
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
			$.messager.alert("��ʾ:","����Ȩִ�иò�����");
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
			/// �����ӵ���ѡ�б�����Ŀ����̬����ѡ��״̬
			$.each(rows, function(index, selItem){
				if (GetCurItmIsSelect(selItem.ItemID, selItem.ItemPartID)){
					$('#itemList').datagrid('selectRow',index);
					$("[name='ItmCheckBox'][value='"+ index+"']").attr("checked",true);
				}
			})
		}
	};

	var params = "";
	var uniturl = ""; //LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckItemList&params"+ params;
	new ListComponent('itemList', columns, uniturl, option).Init(); 

}

/// ��ѡ��
function SetCellCheckBox(value, rowData, rowIndex){

	var html = '<input name="ItmCheckBox" type="checkbox" value='+rowIndex+'></input>';
    return html;
}

/// ��ʼ����鲿λ��
function initCheckPartTree(){

	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	        var isLeaf = $("#CheckPart").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        var itemCatID = node.id; 		/// ������ID
				var params = itemCatID;
				$("#itemList").datagrid("load",{"params":params});
	        }else{
		    	$("#CheckPart").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    }
	    }
	};
	new CusTreeUX("CheckPart", '', option).Init();
}

/// ��ʼ����鲿λ��
function initCheckPartTreeNew(){

	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	       
	        var isLeaf = $("#CheckPart").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        var itemCatID = node.id;       /// ������ID
				LoadCheckItemList(itemCatID);  /// ���ؼ�鷽���б�
	        }else{
		    	$("#CheckPart").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    }
	    },
	    onExpand:function(node, checked){
			var childNode = $("#CheckPart").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
	        var isLeaf = $("#CheckPart").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        var itemCatID = node.id;       /// ������ID
				LoadCheckItemList(itemCatID);  /// ���ؼ�鷽���б�
	        }
		}
	};
	new CusTreeUX("CheckPart", '', option).Init();
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
		htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// ��Ŀ
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px"><input id="'+ itemArr[j-1].value +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itemobj.id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
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
	$("#itemList").append(htmlstr+itemhtmlstr)
}

/// ҳ��Combobox��ʼ����
function initCombobox(){

	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";

	/// ������
	var option = {
        onSelect:function(option){

	        var arItemCatID = option.value; /// ������ID
			
	        var repStatusID = $("#repStatus").combobox('getValue'); /// ����״̬
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var tmpEpisodeID = $('#AdmHis').combogrid('getValue');  /// ����ID
	        if (tmpEpisodeID == ""){
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
	        if (tmpEpisodeID == ""){
		    	tmpEpisodeID = EpisodeID;   
		    }
			var params = tmpEpisodeID +"^"+ "" +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    }
	};
	var url = uniturl+"jsonExaCat&HospID="+LgHospID;
	new ListCombobox("itemCatID",url,'',option).init();

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
			if (tmpEpisodeID == ""){
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
			if (tmpEpisodeID == ""){
		    	tmpEpisodeID = EpisodeID;
		    }
	        /// ��鷽��
			var params = tmpEpisodeID +"^"+ itemCatID +"^"+ "" +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    }
	};
	new ListCombobox("repStatus",'',repStatusArr,option).init();
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	///  ����
	//$('button:contains("ȷ��")').bind("click",addItemSelList);
	//$('a:contains("ȷ��")').bind("click",addItemSelList);
	
	///  ����
	$('button:contains("����")').bind("click",sendExaReq);
	
	///  ��ӡ
	$('button:contains("��ӡ")').bind("click",printExaReq);
	
	///  ƴ����
	$("#ExaItmCode").bind("keypress",findExaItemList);
	
	///  ƴ����
	$("#ExaCatCode").bind("keyup",findExaItmTree);
	
	///  ������Ŀ checkbox
	//$("#TmpOtherOpt input[type='checkbox']").live("click",setOtherOpt);
	$("#TmpOtherOpt").on("click","input[type='checkbox']",setOtherOpt); /// JQuery 2.2.4
	
	///  ������Ŀ text
	//$("#TmpOtherOpt input[name='Input']").live('change',setOtherOpt);
	$("#TmpOtherOpt").on("change","input[name='Input']",setOtherOpt); /// JQuery 2.2.4
	
	//$("#itemList .checkbox").live("click",selectExaItem);
	$("#itemList").on("click",".checkbox",selectExaItem); /// JQuery 2.2.4
	
	///  ȷ��
	$('a:contains("ȷ��")').bind("click",addItmToItmSelListNew);
	
	///  ȡ��
	$('a:contains("ȡ��")').bind("click",closeWin);
	
	///  ȷ��
	$('button:contains("ȷ��")').bind("click",sureExaReq);
	
	///  �ر�
	$('button:contains("�ر�")').bind("click",closePopWin);
}

/// ��ʼ��ҳ��CheckBox�¼�
function initCheckBoxEvent(){

	//$("input[type=checkbox]").live('click',function(){
	$("body").on('click',"input[type=checkbox]",function(){
		
		///  ��������
		if (this.name == "ExaDisp") {
			return;
		}
		
		$("input[name="+this.name+"]:not([value="+this.value+"])").each(function(){
			$(this).removeAttr("checked");
		})
	});
}

/// ��ʼ��������ʷ�����¼
function initCombogrid(){
	
	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPatAdmHisList&EpisodeID='+EpisodeID;
	
	///  ����columns
	var columns=[[
		{field:'EpisodeID',title:'EpisodeID',width:100},
		{field:'itmLabel',title:'��������',width:100,hidden:true},
		{field:'AdmDate',title:'��������',width:100},
		{field:'AdmLoc',title:'���տ���',width:100},
		{field:'AdmDoc',title:'ҽ��',width:100},
		{field:'PatDiag',title:'���',width:100}
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
        }
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

/// ��������
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
	
	/// ��ѡ�б���ǰ״ֵ̬
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
	
	/// ��������
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
	
	/// ����ǰ����֪ʶ��
	if (InvokItmLib() != true) return;
	
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

	if (editSelRow != ""||editSelRow == 0) { 
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	} 
    
	var itemExaDisHis = $("#arDisHis").val();  /// �ֲ�ʷ
	if (itemExaDisHis == "�������ֲ�ʷ������"){
		itemExaDisHis = "";
	}
	
	var itemExaPhySig = $("#arPhySig").val();  /// ����
	if (itemExaPhySig == "������������"){
		itemExaPhySig = "";
	}
		
	var itemExaSym = $("#arPatSym").val();     /// ����
	if (itemExaSym == "���������ߣ�"){
		itemExaSym = "";
	}
	if (itemExaSym == ""){
		$.messager.alert("��ʾ:","�������߲���Ϊ�գ�","info",function(){
			$('#arPatSym').focus();    /// ���ý���
		});
		return;
	}

	var tips = itmIsRequired();   /// ������Ŀ�Ƿ�Ϊ����
	if (tips != ""){
		$.messager.alert("��ʾ:","������Ŀ:" + tips +"����Ϊ�գ�");
		return;
	}

	var itemLocFlag = 0;
	var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// �Ӽ�
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
		var itemRemark = selItem.ItemRemark;	   /// ��ע
		
		
		var ListData = ItemID +"#"+ EpisodeID +"^"+ itemLocID +"^"+ arEmgFlag +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ itemExaDisHis +"^"+ itemExaPhySig +"^"+ LgCtLocID +"^"+ itemExaSym +"^"+ "Y" ;
			ListData = ListData +"#"+ itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID +"^"+ itemRemark;

		mItmListData.push(ListData);
	})
	
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
	runClassMethod("web.DHCAPPExaReport","save",{"pid":pid, "ListData":mItmListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			/*
			var PatType = $('#PatType').text();   /// ��������
			if (PatType == "I"){
				print(jsonString);                /// ���ô�ӡ����
				return;
			}
			*/
			if (CloseFlag == 1){
				window.opener.ReloadGrid("ExaReport");  /// ˢ��ҽ������ 
				window.parent.close();        /// �رյ�������
			}
			else if (CloseFlag == 2){
				window.parent.close();        /// �رյ�������
			}else{
				arExaReqIdList = jsonString;
				print(arExaReqIdList);
				//$("#ItemSelList").datagrid("reload"); /// ˢ��ҳ������
				$("#ItemSelList").datagrid("load",{"params":arExaReqIdList});
				$("#dgEmPatList").datagrid("reload");   /// ˢ��ҳ������
			
				isNeedAppExaReqNo(arExaReqIdList);      /// �жϼ�������Ƿ��п�ԤԼ��Ŀ bianshuai 2016-08-09
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
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonOtherOptSubItm&itemid="+ itemobj.itemid;
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

/// ��Ŀ��ϸ
function showItmDetWin(arRepID){
	
	showItmAppDetWin(arRepID);  /// ԤԼ���鴰��
}

/// �����
function showItmRetWin(Oeori){

	showItmAppRetWin(Oeori);        /// �����
}

/// ���ؽ��տ���
function LoadArcItemRecLoc(arItemID){

	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";
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
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+LgHospID;
		}else{
			/// �°�
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+LgHospID;
		}
	}else{
		<!-- �¾ɰ汾�������� -->
	    if (version != 1){
		    /// �ɰ�
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCode&PyCode='+PyCode+'&HospID='+LgHospID;
		}else{
			/// �°�
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCodeNew&PyCode='+PyCode+'&HospID='+LgHospID;
		}
	}
	
	$('#CheckPart').tree('options').url =encodeURI(url);
	$('#CheckPart').tree('reload');
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
	
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaReqHisSign",{"EpisodeID":EpisodeID},function(jsonString){

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

/// ����Ƿ���������ͬ��Ŀ
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
		$("#arExaReqCost").text("�ܷ���:"+0 +"Ԫ");
		return;
	}

	var ListData = arRepID +"^"+ EpisodeID +"^"+ pid +"#"+ mItmListData;

	/// ����ģ������
	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqItmCost",{"ListData":ListData},function(jsonString){
		if (jsonString > 0){
			var arExaReqCost = jsonString;
			$("#arExaReqCost").text("�ܷ���:"+arExaReqCost +"Ԫ");
		}
	},'',false)
}

/// ������뵥�Ƿ��п�ԤԼ��Ŀ
function isExistNeedAppItm(arReqID){
	
	var AppFlag = false;
	runClassMethod("web.DHCAPPInterface","GetExaReqAppFlag",{"arReqID":arReqID},function(jsonString){
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
			showItmAppDetWin(arReqID);  	 /// ԤԼ���鴰��
			break;
		}
	}
}

///  ������Ŀ����ѡ�б�
function addItmToItmSelList(rowIndex){
	
	/// ��ѡ�б���ǰ״ֵ̬
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

	/// ��֤�����Ƿ�������ҽ��
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

/// ��ǰ��Ŀ�Ƿ��Ѿ����ӵ���Ŀ�б�
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
		
		/// ��֤�����Ƿ�������ҽ��
		if (TakOrdMsg != ""){
			$.messager.alert("��ʾ:",TakOrdMsg);
			$(this).attr("checked",false);
			return;	
		}
		
		/// ��鷽����ҽ����ID��ҽ�������ơ�
		var arExaItmID = this.id;    /// ��鷽��ID
		var arExaItmDesc = $(this).parent().next().text(); /// ��鷽��
		var arExaCatID = this.value; /// ������ID
		
		/// ��ȡҽ��¼ҽ��Ȩ��
		if (GetDocPermission(arExaItmID) == 1){
			$.messager.alert("��ʾ:","��û��Ȩ��¼���ҽ����");
			$(this).attr("checked",false);
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
					/// ׼�����Ӽ����Ŀ
					attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID);
				}else{
					/// ȡ����Ŀѡ��״̬
					$("#"+arExaItmID).attr("checked",false);
				}
			})
		}else{
			/// ׼�����Ӽ����Ŀ
			attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID);
		}

	//	if ($('input[name="ExaItem"]:checked').length){
	//		arExaItmID = $('input[name="ExaItem"]:checked').attr("id"); /// ��鷽��ID
	//		arExaCatID = $('input[name="ExaItem"]:checked').val();      /// ������ID
	//	}
		/*
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
		
		runClassMethod("web.DHCAPPExaReportQuery","isExistLinkPart",{"itmmastid":arExaItmID,"TraID":arExaCatID},function(isLinkPart){
		
			if (isLinkPart != ""){
				if (isLinkPart == 1){
					createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc);  /// ��Ŀ��ѡ��λ��������λ����
				}else{
					addExaItem(arExaItmID,arExaItmDesc);          /// ���Ӽ����Ŀ
				}
			}
		},'',false)*/
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
	}
	
}

/// ׼�����Ӽ����Ŀ
function attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID){
	
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
					createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc);  /// ��Ŀ��ѡ��λ��������λ����
				}else{
					if (IsRepeatOneday(arExaItmID,"") == 1){
						$.messager.confirm('ȷ�϶Ի���','�����Ѿ�������ͬҽ���Ƿ�������ӣ�', function(r){
							if (r){
								addExaItem(arExaItmID,arExaItmDesc);          /// ���Ӽ����Ŀ
							}else{
								/// ȡ�������Ŀ��ѡ��
								if ($("#"+arExaItmID).is(":checked")){
									$("#"+arExaItmID).attr("checked",false);
								}
							}
						});
					}else{
						addExaItem(arExaItmID,arExaItmDesc);          /// ���Ӽ����Ŀ
					}
				}
			}
		},'',false)
}

/// ���Ӽ����Ŀ
function addExaItem(arExaItmID,arExaItmDesc){
	
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
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}
	
	if (isExistItem(arExaItmDesc)){
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
	var rowobj={ItemID:"", ItemArcID:"", ItemLabel:arExaItmDesc, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:'', 
	ItemExaDispID:'', ItemExaPosiID:'',ItemExaPurp:arExaItmDesc, ItemOpt:'', ItemStat:"��ʵ", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, ItemEmgFlag:arEmgFlag, ItemRemark:''}
	$("#ItemSelList").datagrid('appendRow',rowobj);
	
	/// ������Ŀ
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  ȷ�ϼ����һ���Լ���������Ŀ bianshuai 2016-08-09
	GetExaReqItmCost();   ///  �����������ܽ��
	
}

/// ������λ��������
function createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc){
	
	/// ����ҽ�����б�����
	//new PopUpWin($(this), "760", "360" , "", "").init();
	$('#PopUpWin').window({
		title:'������Ϣ',   
	    width:950,    
	    height:450,    
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
	initPartTree(arExaCatID,arExaItmID);
	initItemList(arExaItmID); /// ҳ��DataGrid��ʼ����������б�
	initItemDisp(arExaItmID); /// ��������
	isShowPosi(arExaItmID);   /// �Ƿ���ʾ��λ��
}

/// ��ʼ����鲿λ��
function initPartTree(arExaCatID,arExaItmID){

	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+arExaItmID+'&PyCode=&TraID='+arExaCatID+'&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
		checkbox:true,
        onCheck:function(node, checked){
	        var isLeaf = $("#EnPart").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        if (checked){
			        /// ������Ŀʱ,�жϵ����Ƿ�������ͬ��Ŀ
			        if (IsRepeatOneday(arExaItmID,node.id) == 1){
				        var nodeid = node.id;
				        var nodetext = node.text;
						$.messager.confirm('ȷ�϶Ի���','�����Ѿ�������ͬ��λҽ���Ƿ�������ӣ�', function(r){
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
	    	$("span:contains('��ѡ��λ')").parent().find("span.tree-checkbox").remove();
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
			url: LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaPosition&itmmastid="+arExaItmID+"&HospID="+LgHospID,
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
		{field:'ItemPart',title:'��λ',width:140},
		{field:'ItemPosiID',title:'ItemPosiID',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosi',title:'ItemPosi',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosiDesc',title:'��λ',width:140,editor:PosiEditor},
		{field:'ItemRemark',title:'��ע',width:100,editor:texteditor},
		{field:'ItemOpt',title:'����',width:100,align:'center',formatter:SetCellDelUrl}
	]];
	
	///  ����datagrid
	var option = {
		border : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
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
	var node = $("#EnPart").tree('find',PartID);
	$("#EnPart").tree('uncheck',node.target);
	
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

/// ������Ŀ�б�
function addItmSelList(id, text){

	var rowobj={ItemID:id, ItemPart:text, ItemPosiID:'', ItemPosi:'', ItemOpt:''}
	$("#dmPartList").datagrid('appendRow',rowobj);
	
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

/// ��������
function initItemDisp(arExaItmID){
	
	var arExaItmID = arExaItmID.replace("_","||");
	$("#ItmExaDisp").html("");
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaDisp",{"itmmastid":arExaItmID, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
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

///  ������Ŀ����ѡ�б�
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
		
		/// ��������
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
	
	/// ������Ŀ
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  ȷ�ϼ����һ���Լ���������Ŀ bianshuai 2016-08-09
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

/// ��֤�����Ƿ�������ҽ��
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// ��֤�����Ƿ�������ҽ��
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
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
	
	if (editSelRow != ""||editSelRow == 0) { 
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	} 
    
	var itemExaDisHis = $("#arDisHis").val();  /// �ֲ�ʷ
	if (itemExaDisHis == "�������ֲ�ʷ������"){
		itemExaDisHis = "";
	}
	
	var itemExaPhySig = $("#arPhySig").val();  /// ����
	if (itemExaPhySig == "������������"){
		itemExaPhySig = "";
	}
		
	var itemExaSym = $("#arPatSym").val();     /// ����
	if (itemExaSym == "���������ߣ�"){
		itemExaSym = "";
	}
	if (itemExaSym == ""){
		$.messager.alert("��ʾ:","�������߲���Ϊ�գ�","info",function(){
			$('#arPatSym').focus();    /// ���ý���
		});
		return;
	}

	var tips = itmIsRequired();   /// ������Ŀ�Ƿ�Ϊ����
	if (tips != ""){
		$.messager.alert("��ʾ:","������Ŀ:" + tips +"����Ϊ�գ�");
		return;
	}

	var itemLocFlag = 0; var mItmMastArr = [];
	var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// �Ӽ�
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
		
		var ListData = EpisodeID +"^"+ itemLocID +"^"+ arEmgFlag +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ itemExaDisHis +"^"+ itemExaPhySig +"^"+ LgCtLocID +"^"+ itemExaSym +"^"+ "N" ;
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
			$.messager.alert("��ʾ:","������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			window.returnValue = jsonString;
			window.close();
		}
	},'',false)
	

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
	/// ҽ���������ʱ,ȡֵ��ʽ
	arEmgFlag = mItmMastStr.split("*")[0];  /// �Ӽ���־
	arReqDate = mItmMastStr.split("*")[2];  /// ҽ������
	uniqueID = mItmMastStr.split("*")[4];   /// Ψһ��ʾ
	
	/// ���ڷ���ʱ���жϷ�����Ŀ�Ƿ��뿪����Ŀһֱ
	mItmMastDocArr.push(mItmMastStr +"*"+ arExaItmDesc);
	
	/// ������ѡ�б�
	var rowobj={ItemID:"", ItemArcID:"", ItemLabel:arExaItmDesc, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:'', 
	ItemExaDispID:'', ItemExaPosiID:'',ItemExaPurp:arExaItmDesc, ItemOpt:'', ItemStat:"��ʵ", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, ItemEmgFlag:arEmgFlag, ItemRemark:''}
	$("#ItemSelList").datagrid('appendRow',rowobj);
	
	/// ������Ŀ
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  ȷ�ϼ����һ���Լ���������Ŀ bianshuai 2016-08-09
	GetExaReqItmCost();   ///  �����������ܽ��
	
}

/// ��֤�����Ƿ�������ҽ��
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

///������Ŀ��ģ��  sufan  2016/12/20
function showmodel(flag)
{	
	if($('#winonline').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:'ģ���б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:550,
		height:450
	});
	var iframepatsym = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.patsymtemp.csp"></iframe>';
	var iframeprehis = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.prehistmp.csp"></iframe>';
	var iframesign = '<iframe   scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.resultwindow.csp"></iframe>';
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
		collapsible:true,
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
		collapsible:true,
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
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('ѡ��', 'patsign', '260', '130', option).Init();
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

	/// ����ҽ�����б�����
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
						$.messager.alert("��ʾ:","��������ܿ���Ŀ�����������ͣ�");
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

	$("#TmpFunLib").html(htmlstr);
	//$('#FunUpWin').html(htmlstr);
}

/// ������ϴ���
function DiagPopWin(){
	
	var PatientID = $("#PatientID").text();  /// ����ID
	var mradm = $("#mradm").text();			 /// �������ID

	var lnk = "diagnosentry.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
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

/// ��ʼ������ div��ʽ
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
	initDivHtml();   					   /// ��ʼ������ div��ʽ
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
	
	/// div ������ʽ����
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

/// ɾ����ʱglobal
function killTmpGlobal(){

	runClassMethod("web.DHCAPPExaReportQuery","killTmpGlobal",{"pid":pid},function(jsonString){
	},'',false)
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    killTmpGlobal();  /// �����ʱglobal
}

window.onbeforeunload = onbeforeunload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })