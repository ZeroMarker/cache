//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-04
// ����:	   ��Ժ�������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var editSelRow = -1;    /// ��ǰ�༭��
var PisID = "";         /// ��������ID
var TakOrdMsg = "";
var rowNo = 4; 			/// �걾���
var pid = "";  			/// Ψһ��ʶ
var mListDataDoc = "";  /// ҽ��վ�����������
var DocMainFlag = "";   /// ҽ��վ���浯����ʾ
var LgUserID = session['LOGON.USERID'];   /// �û�ID
var LgCtLocID = session['LOGON.CTLOCID']; /// ����ID
var LgGroupID = session['LOGON.GROUPID']; /// ��ȫ��ID
var LgHospID=session['LOGON.HOSPID'];
var isPageEditFlag = 1; /// ҳ���Ƿ�����༭
/// ҳ���ʼ������
function initPageDefault(){

	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	//LoadCheckItemList();      /// ���ز�������Ŀ
	GetIsWritePisFlag();      /// �Ƿ����д�ж�
	GetPatBaseInfo();         /// ���ز�����Ϣ qunianpeng 2018/2/5
	InitPageCheckBox();       /// ҳ��CheckBox����
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
		/// ��塾��鼰������Ϣ����С����
		$('#cPanel').panel('resize',{width: PanelWidth ,height: 420});
		/// ��塾�걾��Ϣ����С����
		$('#sPanel').panel('resize',{width: PanelWidth ,height: 210});
		
	}else{
		LoadCheckItemList();         /// ���ز�������Ŀ
	}
}

/// ��������datagrid��С
function resize(){

	$('#PisSpecList').datagrid('resize',{width: 800,height: 200 });
	//$('#PisSpecList').datagrid('resize',{ });
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
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+itmmastid;
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

/// ѡ�м����Ŀ
function TesItm_onClick(){
	
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
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmastid},function(jsonString){
			
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				LocID = jsonObjArr[0].value;
				LocDesc = jsonObjArr[0].text;
			}
		},'json',false)

		$("#recLoc").combobox("setValue",LocID);
		$("#recLoc").combobox("setText",LocDesc);
	}
}

/// ���ؼ�鷽���б�
function LoadCheckItemList(){
	
	/// ��ʼ����鷽������
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCode",{"Code":"CON"},function(jsonString){

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

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPageDataGrid(){
	
	/// �༭��
	var texteditor = {
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// ���ֱ༭��
	var numberboxeditor = {
		type: 'numberbox',//���ñ༭��ʽ
		options: {
			//required: true //���ñ༭��������
		}
	}
		
	// �걾�༭��
	var SpliTypeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=JsonGetSpecType&HospID="+LgHospID,
			valueField: "value", 
			textField: "text",
			editable:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#PisSpecList").datagrid('getEditor',{index:editSelRow,field:'SliType'});
				$(ed.target).combobox('setValue', option.text);
			}
		}

	}
	
	var TitLnk = '<a href="#" onclick="insRow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';
	///  ����columns
	var columns=[[
		{field:'No',title:'�걾���',width:80,align:'center'},
		//{field:'ID',title:'�걾��ʶ',width:80,editor:texteditor},
		{field:'Name',title:'�걾����',width:300,editor:texteditor},
		{field:'Part',title:'�걾��λ',width:120,editor:texteditor,hidden:true},
		{field:'Qty',title:'�걾����',width:80,editor:numberboxeditor},
		{field:'SliType',title:'��Ƭ/����',width:140,editor:SpliTypeEditor},
		{field:'PisNo',title:'ԭ�����',width:140,editor:texteditor},
		//{field:'operation',title:TitLnk,width:40,align:'center',formatter:SetCellUrl}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumn:false,
		headerCls:'panel-header-gray',
		rownumbers : false,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (isPageEditFlag == 0) return;
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#PisSpecList").datagrid('endEdit', editSelRow); 
            } 
            $("#PisSpecList").datagrid('beginEdit', rowIndex); 

            editSelRow = rowIndex; 
        }
	};
	/// ��������
	var uniturl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=JsonQryPisSpecByOut&PisID="+PisID;
	new ListComponent('PisSpecList', columns, uniturl, option).Init();
}

/// ����
function SetCellUrl(value, rowData, rowIndex){	
	return "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

/// ɾ����
function delRow(rowIndex){
	
	if (isPageEditFlag == 0) return;
	var rows = $('#PisSpecList').datagrid('getRows');
	//ɾ��ǰ�������еı༭��
	$.each(rows,function(index,data){
		 if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#PisSpecList").datagrid('endEdit', editSelRow); 
            }
	});
	/// �ж���
    var rowObj={ID:'', Name:'', Part:'', Qty:'', SliType:'', PisNo:''};
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	
	if(rows.length>4){
		 $('#PisSpecList').datagrid('deleteRow',rowIndex);
		 rowNo -= 1;
	}else{
		//$('#PisSpecList').datagrid('updateRow',{index:rowIndex, row:rowObj});
		$('#PisSpecList').datagrid('deleteRow',rowIndex);  //С��4ʱ,ɾ�����к�,������һ������ qunianepng 2018/1/29
		 rowNo -= 1;
		 var rowObj = {"No":rowNo+1,"Name":"","Explain":"","Part":"","Qty":"","Remark":"","SliType":"","PisNo":""};
		$("#PisSpecList").datagrid('appendRow',rowObj);
	}
	
	// ɾ����,��������
	//$('#PisSpecList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
	//ɾ����,���ݱ걾�����������,�����±��
	sortTable();
}

/// �������
function insRow(){	

	if (isPageEditFlag == 0) return;
	rowNo += 1;
	var rowObj={"No":rowNo, "ID":"", "Name":"", "Part":"", "Qty":"", "SliType":"", "PisNo":""};
	$("#PisSpecList").datagrid('appendRow',rowObj);
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

/// ���没������
function SavePisNo(){
	
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#PisSpecList").datagrid('endEdit', editSelRow); 
    }
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
	//var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ session['LOGON.USERID'] +"^"+ session['LOGON.CTLOCID'] +"^"+ EmgFlag +"^"+ FrostFlag +"^^^^^^CON";
	var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^^^^^^CON";
	
	/// �ͼ�ҽ��
	var InsDoc = $("#InsDoc").val();
	/// �ͼ�ҽԺ
	var InsHosp = $("#InsHosp").val();
	/// ����걾�������
	var SpecExaRes = $("#SpecExaRes").val();
	/// ����Ҫ�� 
	var ConsNote = $("#ConsNote").val();
	/// ����ר�� 
	var ConsStaff = $("#ConsStaff").val();
	
	var mPatConsult = InsDoc +"^"+ InsHosp +"^"+ SpecExaRes +"^"+ ConsNote +"^"+ ConsStaff;
	
	/// ����걾
	var PisSpecArr=[];
	var rowDatas = $('#PisSpecList').datagrid('getRows');
	$.each(rowDatas, function(index, item){
		if((trim(item.Name) != "")&&(item.Qty>0)){
		    var TmpData = item.No +"^"+ item.ID +"^"+ item.Name +"^"+ item.Part +"^"+ item.Qty +"^"+ item.SliType +"^"+ item.PisNo;
		    PisSpecArr.push(TmpData);
		}
	})
	var PisSpecList = PisSpecArr.join("@");
	if (PisSpecList == ""){
		$.messager.alert("��ʾ:","�걾���ݲ���Ϊ�գ�");
		return;	
	}
	
	///             ����Ϣ  +"&"+  ������Ϣ  +"&"+  ����걾
	var mListData = mListData +"&"+ mPatConsult +"&"+ PisSpecList;

	/// ����
	runClassMethod("web.DHCAppPisMaster","Insert",{"PisType":"CON", "PisID":PisID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뵥����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			PisID = jsonString;
			GetPisNoObj(PisID)
			$.messager.alert("��ʾ:","����ɹ���");
			/// ���ø���ܺ���
		    window.parent.frames.reLoadEmPatList();
		}
	},'',false)
}

/// ���Ͳ�������
function SendPisNo(){

	/// סԺ��������Ѻ�����
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$.messager.alert("��ʾ:",PatArrManMsg);
		return;	
	}
	
	/// ����
	runClassMethod("web.DHCAppPisMaster","InsSendFlag",{"PisID":PisID},function(jsonString){
		
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
	},'',false)
}

/// ��ʱ�洢����
function InsertDoc(){
	
	if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#PisSpecList").datagrid('endEdit', editSelRow); 
    }
    
	/// ҽ���
	var mItemParam = mListDataDoc.split("!")[1];
	if (mItemParam == "") return false;

	var ApplyDocUser = session['LOGON.USERID'];    /// ����ҽ��
	var ApplyLoc = session['LOGON.CTLOCID']; 	   /// �������
	var EmgFlag = ""; 
	var FrostFlag = "";
	var mListData = "^^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^^^^^^CON" +"^";
	
	/// �ͼ�ҽ��
	var InsDoc = $("#InsDoc").val();
	/// �ͼ�ҽԺ
	var InsHosp = $("#InsHosp").val();
	/// ����걾�������
	var SpecExaRes = $("#SpecExaRes").val();
	/// ����Ҫ�� 
	var ConsNote = $("#ConsNote").val();
	/// ����ר�� 
	var ConsStaff = $("#ConsStaff").val();
	
	var mPatConsult = InsDoc +"^"+ InsHosp +"^"+ SpecExaRes +"^"+ ConsNote +"^"+ ConsStaff;
	
	/// ����걾
	var PisSpecArr=[];
	var rowDatas = $('#PisSpecList').datagrid('getRows');
	$.each(rowDatas, function(index, item){
		if(trim(item.Name) != ""){
		    var TmpData = item.No +"^"+ item.ID +"^"+ item.Name +"^"+ item.Part +"^"+ item.Qty +"^"+ item.SliType +"^"+ item.PisNo;
		    PisSpecArr.push(TmpData);
		}
	})
	var PisSpecList = PisSpecArr.join("@");
	if (PisSpecList == ""){
		window.parent.frames.InvErrMsg("����Ժ����걾���ݲ���Ϊ�գ�");
		return false;	
	}
	
	///             ����Ϣ  +"&"+  ������Ϣ  +"&"+  ����걾
	var mListData = mListData +"&"+ mPatConsult +"&"+ PisSpecList;
	/// ����
	runClassMethod("web.DHCAppPisMaster","InsertTempDoc",{"Pid":pid, "mListData":mListData, "mItemParam":mItemParam},function(jsonString){
		if (jsonString < 0){
			window.parent.frames.InvErrMsg("����Ժ�������롿����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
			return false;
		}
	},'',false)
	
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

/// ���ò������뵥����
function InsPisNoObj(itemobj){
	
	$("#TesItemID").val(itemobj.arcimid);
	$("#TesItemDesc").val(itemobj.ItemDesc);          /// ҽ������
	$("#recLoc").combobox("setValue",itemobj.LocID);  /// ���տ���
	$("#recLoc").combobox("setText",itemobj.LocDesc); /// ���տ���
	//$HUI.checkbox("#EmgFlag").setValue(itemobj.EmgFlag == "Y"? true:false);      /// �Ӽ�
	//$HUI.checkbox("#FrostFlag").setValue(itemobj.FrostFlag == "Y"? true:false);  /// ����
	$HUI.datebox("#FoundDate").setValue(itemobj.FoundDate); /// �״η�������ͷ������ʱ��
	
	$HUI.combobox("#ApplyDocUser").setValue(itemobj.ApplyDocId);  /// ������Һ�����ҽ�� qunianpeng 2018/2/5
	$HUI.combobox("#ApplyDocUser").setText(itemobj.ApplyDocDesc);	
	$HUI.combobox("#ApplyLoc").setValue(itemobj.ApplyLocId);	
	$HUI.combobox("#ApplyLoc").setText(itemobj.ApplyLocDesc);
	/// �ͼ�ҽ��
	$("#InsDoc").val(itemobj.InsDoc);
	/// �ͼ�ҽԺ
	$("#InsHosp").val(itemobj.InsHosp);
	/// ����걾�������
	$("#SpecExaRes").val(itemobj.SpecExaRes);
	/// ����Ҫ��
	$("#ConsNote").val(itemobj.ConsNote);
	/// ����ר��
	$("#ConsStaff").val(itemobj.ConsStaff);
	
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
	$HUI.datebox("#LastMensDate").disable(); /// �ϴ��¾�
	$HUI.datebox("#MensDate").disable();     /// ĩ���¾�
	$HUI.datetimebox("#SepDate").disable(); /// �걾����ʱ��
	$HUI.datetimebox("#FixDate").disable(); /// �걾�̶�ʱ��
	$HUI.combobox("#LocID").disable();  /// ȡ�Ŀ��Ҳ�����
	$HUI.combobox("#DocDr").disable();  /// ȡ��ҽ��������
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
	},'',false)
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

/// ��Ժ���뵥��ӡ
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
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);   /// �ٴ�����
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag); /// �ٴ����

	MyPara = MyPara+"^OperRes"+String.fromCharCode(2)+txtUtil(jsonObj.OperRes);        /// ��������
	MyPara = MyPara+"^FoundDate"+String.fromCharCode(2)+txtUtil(jsonObj.FoundDate);    /// �״η�������ͷ������ʱ��
	MyPara = MyPara+"^InsDoc"+String.fromCharCode(2)+txtUtil(jsonObj.InsDoc);          /// �ͼ�ҽ��
	MyPara = MyPara+"^InsHosp"+String.fromCharCode(2)+txtUtil(jsonObj.InsHosp);        /// �ͼ�ҽԺ
	MyPara = MyPara+"^SpecExaRes"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.SpecExaRes,60));  /// ����걾�������
	MyPara = MyPara+"^ConsNote"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.ConsNote,60));      /// ����Ҫ��
	MyPara = MyPara+"^ConsStaff"+String.fromCharCode(2)+txtUtil(jsonObj.ConsStaff);    /// ����ר��
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22

	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisOutCou");
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
	},'',false)
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

/// ���뵥�Ƿ�����༭
function InitReqEditFlag(ID){

	var LgParams = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","JsGetReqEditFlag",{"ID":ID, "Type":"P", "LgParams":LgParams},function(jsonString){
		if (jsonString != ""){
			isPageEditFlag = jsonString;
			PageBtEditFlag(jsonString);
		}
	},'',false)
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

	GetPisNoObj(PisID);        /// ���ز�������
	InitReqEditFlag(PisID);    /// ���뵥�Ƿ�����༭
	//$("#PisSpecList").datagrid("load",{"PisID":PisID});  /// �걾�б�
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

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	if (PisID != ""){
		LoadReqFrame(PisID, "");    /// ���ز�������
	}
}

// ���ɾ���к��������� qunianpeng  2018/1/29 
function sortTable(){
	var tmpNum = 1;
	var arr = [];
	var selItems = $('#PisSpecList').datagrid('getRows');
	$.each(selItems, function(index, item){
		var tepObj = {"No":tmpNum ,"Name": item.Name,"Explain":item.Explain,"Part":item.Part,"Qty":item.Qty,"Remark":item.Remark,"SliType":item.SliType,"PisNo":item.PisNo};
		tmpNum += 1;
		arr.push(tepObj);
	});
	for (var i=0; i<arr.length; i++){	
		$('#PisSpecList').datagrid('updateRow',{index:i, row:arr[i]});		
	}
	rowNo = tmpNum-1; 	//��¼�����к�
  
}

window.onload = onload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
