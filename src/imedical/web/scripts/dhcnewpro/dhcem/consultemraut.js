/// �������벡����Ȩ
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var TakType=1;     //��Ȩ����
/// ҳ���ʼ������
function initPageDefault(){

	initPageMainGrid();		  /// ��Ȩ�б�datagrid
    initPageItemGrid();		  /// ��Ȩ��ʷdatagrid
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function initPageMainGrid(){
	
	/// �༭��
	var numbereditor={
		type: 'numberbox',//���ñ༭��ʽ
		options: {
			required: true, //���ñ༭��������
			validType:'number'
		}
	}
	
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var TakOrdArr = [{"value":"1","text":$g('����')}, {"value":"2","text":$g('ҽ��')}];
	//������Ϊ�ɱ༭
	var TakOrdEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: TakOrdArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				TakType =option.value;
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#main").datagrid('getEditor',{index:modRowIndex,field:'TakOrdFlag'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#main").datagrid('getEditor',{index:modRowIndex,field:'TakOrd'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
				$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			}
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'chk',checkbox:true,width:260,align:'center',hidden:true},
		{field:'itmID',title:'itmID',width:100,hidden:true},
		{field:'LocID',title:'����ID',width:100,hidden:true},
		{field:'LocDesc',title:'����',width:260},
		{field:'UserID',title:'ҽ��ID',width:100,hidden:true},
		{field:'UserName',title:'ҽ��',width:100},
		{field:'TakFlag',title:'TakFlag',width:100,hidden:true},
		{field:'TakTime',title:'��Ȩʱ��(Сʱ)',width:120,editor:numbereditor,align:'center'},
		{field:'TakOrdFlag',title:'TakOrdFlag',editor:texteditor,width:100,hidden:true},
		{field:'TakOrd',title:'Ȩ������',editor:TakOrdEditor,width:100,formatter:SetCellTakOrd},
		{field:'OperButton',title:'����',width:140,align:'center',formatter:SetCellOperLink}
	]];
	
	///  ����datagrid
	var option = {
		toolbar:[],//hxy 2023-02-08 st
		title:$g("��Ȩ�б�"),
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',//ed
		fitColumn:true,
		rownumbers:false,
		singleSelect:false,
		pagination:false,
		fit:false,
	    onLoadSuccess: function (data) { //���ݼ�������¼�
			/// �����б༭     /// 2016-12-14 bianshuai �������б༭
			var rowsData=$("#main").datagrid('getRows');
			$.each(rowsData, function(rowIndex, selItem){
				$("#main").datagrid('beginEdit', rowIndex);
				var ed=$("#main").datagrid('getEditor',{index:rowIndex,field:'TakOrd'});
				$(ed.target).combobox('setValue', $g($(ed.target).combobox('getValue')));  //����Desc
				return;
				//$("#main").datagrid("selectRow", rowIndex); //��������ѡ�и���		
			})
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsCstEmrAutItem&CstID="+CstID+"&TakType="+TakType;
	new ListComponent('main', columns, uniturl, option).Init();
}

/// �в�����ť
function SetCellOperLink(value, rowData, rowIndex){
	
	var html = "";
	if (rowData.TakFlag == "N"){
		html = "<a href='#' class='icon-accept a-icon' onclick='OpenAuthorize("+rowIndex+")'>"+"</a>"; //$g('����')+ hxy 2023-02-08 ui����ͼ��
	}else{
		html = "<a href='#' class='icon-no a-icon' onclick='CloseAuthorize("+rowIndex+")'>"+"</a>"; //$g('�ر�')+ hxy 2023-02-08 ui����ͼ��
	}
    return html;
}

/// �в�����ť
function SetCellTakOrd(value, rowData, rowIndex){
	
	var res = "";
	if (rowData.TakOrd == "ҽ��"){
		res = $g('ҽ��');
	}else{
		res = $g('����');
	}
    return res;
}

/// ������Ȩ
function OpenAuthorize(rowIndex){
	
	$("#main").datagrid('endEdit', rowIndex);
	var rowData=$("#main").datagrid('getData').rows[rowIndex];
	if((rowData.LocID=="")||(rowData.LocID==undefined)){
		$.messager.alert("��ʾ:","��Ȩ���Ҳ���Ϊ�գ�","warning");
		$("#main").datagrid('beginEdit', rowIndex);
		return;
	}

	if(rowData.TakTime==0){
		$.messager.alert("��ʾ:","ʱ�����Ϊ����0������","warning");
		$("#main").datagrid('beginEdit', rowIndex);
		return;
	}
		
	if(rowData.TakTime>720){ //hxy 2021-05-17 200000000ʱ����$zd����
		$.messager.alert("��ʾ:","������Ȩʱ��(Сʱ)�����ԣ��ѳ�30��","warning");
		$("#main").datagrid('beginEdit', rowIndex);
		return;
	}
	
	if(rowData.TakOrdFlag==1){
		var TakEmrAutMsg = isPopEmrAut();
		/// ��֤�����Ƿ����������Ȩ
		if (TakEmrAutMsg != ""){
			$.messager.alert("��ʾ:",TakEmrAutMsg,"warning");
			$("#main").datagrid('beginEdit', rowIndex);
			return;	
		}
	}
	
	var mListData = EpisodeID +"^"+ rowData.itmID +"^"+ LgUserID +"^"+ rowData.LocID +"^"+ rowData.UserID +"^"+ rowData.TakTime +"^"+ rowData.TakOrdFlag;
	
	runClassMethod("web.DHCEMConsult","InsEmrAutMas",{"mListData":mListData},function(jsonString){

		if (jsonString == -2){
			$.messager.alert("��ʾ:","������Ȩʧ�ܣ�ʧ��ԭ��:��ǰ���˴˴ξ���û�в��������ʵ��","warning");
			$("#main").datagrid('beginEdit', rowIndex);
			return;
		}
		
		if (jsonString < 0){
			$.messager.alert("��ʾ:","������Ȩʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
			$("#main").datagrid('beginEdit', rowIndex);
			return;
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","������Ȩ�ɹ�","warning");
			$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			$("#item").datagrid("reload");
		}
	},'',false)
}

/// �ر���Ȩ
function CloseAuthorize(rowIndex){
	$("#main").datagrid('endEdit', rowIndex);
	var rowData=$("#main").datagrid('getData').rows[rowIndex];
	runClassMethod("web.DHCEMConsult","ClsCstEmrAut",{"EpisodeID":EpisodeID, "itmID":rowData.itmID,"TakType":rowData.TakOrdFlag},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","������Ȩ��ʧ��ԭ��:"+jsonString,"warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","�ر���Ȩ�ɹ�","warning");
			$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			$("#item").datagrid("reload");
		}
	},'',false)
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function initPageItemGrid(){
	
	///  ����columns
	var columns=[[
		{field:'TakFlag',title:'״̬',width:100,align:'center',formatter:SetCellColor},
		{field:'LocDesc',title:'����',width:260},
		{field:'mUser',title:'ҽ��',width:100},
		{field:'TakOrd',title:'Ȩ������',width:100,align:'center',formatter:SetCellTakOrd},
		{field:'StartDate',title:'��Ȩ��ʼ����',width:120,align:'center'},
		{field:'StartTime',title:'��Ȩ��ʼʱ��',width:120,align:'center'},
		{field:'EndDate',title:'��Ȩ��������',width:120,align:'center'},
		{field:'EndTime',title:'��Ȩ����ʱ��',width:120,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		toolbar:[],//hxy 2023-02-08 st
		border:true,
		title:$g("��Ȩ��ʷ"),
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',//ed
		fitColumn:false,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		fit:true
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsEmrAutDet&CstID="+CstID;
	new ListComponent('item', columns, uniturl, option).Init();
}

/// ����ɫ����
function SetCellColor(value, rowData, rowIndex){
	
	var fontColor = (value == "Y"?"green":"red");
	var html = "<span style='color:"+ fontColor +";font-weight:bold;'>"+ (value == "Y"?$g("��Ч��"):$g("��Ȩ����")) +"</span>";
    return html;
}


/// ������Ȩ
function OpenEmrAut(){
	
	/// �����༭
	var rows=$("#main").datagrid('getRows');
	$.each(rows, function(index, rowData){
		$("#main").datagrid('endEdit', index); 
	})
	var mListArr = [];
	var rows = $("#main").datagrid('getSelections');
	
	if((rows[0].LocID=="")||(rows[i].LocID==undefined)){
		$.messager.alert("��ʾ:","��Ȩ���Ҳ���Ϊ�գ�","warning");
		return;
	}
	
	if(rows[0].TakTime==0){
		$.messager.alert("��ʾ:","ʱ�����Ϊ����0������","warning");
		return;
	}
	
	if(rows[0].TakOrdFlag==1){
		var TakEmrAutMsg = isPopEmrAut();
		/// ��֤�����Ƿ����������Ȩ
		if (TakEmrAutMsg != ""){
			$.messager.alert("��ʾ:",TakEmrAutMsg,"warning");
			return;	
		}
	}
	
	for(var i=0; i<rows.length; i++){
		if (rows[i].TakFlag == "N"){
			mListArr.push(EpisodeID +"^"+ rows[i].itmID +"^"+ LgUserID +"^"+ rows[i].LocID +"^"+ rows[i].UserID +"^"+ rows[i].TakTime +"^"+ rows[i].TakOrdFlag);
		}
	}
	var mListData = mListArr.join("#");
	if (mListData == ""){
		$.messager.alert("��ʾ:","��ѡ���������¼�����ԣ�","warning");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","InvEmrAutMas",{"mListData":mListData},function(jsonString){
		
		if (jsonString < 0){
			$.messager.alert("��ʾ:","������Ȩ��ʧ��ԭ��:"+jsonString,"warning");
			return;
		}
		
		if (jsonString == 0){
			$.messager.alert("��ʾ:","������Ȩ�ɹ�","warning");
			$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			$("#item").datagrid("reload");
		}
	},'',false)
}

/// �ر���Ȩ
function CloseEmrAut(){
	
	var mListArr = [];
	
	var rows=$("#main").datagrid('getRows');
	$.each(rows, function(index, rowData){
		$("#main").datagrid('endEdit', index); 
	})
	
	var rows = $("#main").datagrid('getSelections');
	
	for(var i=0; i<rows.length; i++){
		if (rows[i].TakFlag == "Y"){
			mListArr.push(EpisodeID +"^"+ rows[i].itmID+"^"+rows[i].TakOrdFlag);
		}
	}
	var mListData = mListArr.join("#");
	if (mListData == ""){
		$.messager.alert("��ʾ:","��ѡ����رռ�¼�����ԣ�","warning");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","ClsCstEmrAutMas",{"mListData":mListData},function(jsonString){

		if (jsonString < 0){
			$.messager.alert("��ʾ:","�ر���Ȩ��ʧ��ԭ��:"+jsonString,"warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","�ر���Ȩ�ɹ�","warning");
			$("#main").datagrid("load",{"CstID":CstID,"TakType":TakType});
			$("#item").datagrid("reload");
		}
	},'',false)
}

/// ��֤�����Ƿ����������Ȩ
function isPopEmrAut(){
	
	var TakMsg = "";
	runClassMethod("web.DHCEMConsInterface","isPopEmrAut",{"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			TakMsg = jsonString;
		}
	},'',false)
	return TakMsg
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })