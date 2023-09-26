
/// bianshuai
/// 2016-03-22
/// ҩƷ����

var editRow = "";
var url="dhcpha.clinical.action.csp";
var tdrPurArray = [{"value":"10","text":'�Զ��ְ���'}, {"value":"20","text":'��ת��'}, {"value":"30","text":'���ڷְ�������'}, {"value":"40","text":'DTA'}];
$(function(){
	
	//��ʼ������Ĭ����Ϣ
	InitTinyDrugRegDefault();
	
	//��ʼ����ѯ��Ϣ�б�
	InitTinyDrugRegDetList();
	
	//��ʼ�����水ť�¼�
	InitTinyWidgetListener();
})

///��ʼ������Ĭ����Ϣ
function InitTinyDrugRegDefault(){
	
	/**
	 * ��������
	 */
	$("#tdrDate").datebox("setValue", formatDate(0));
	//$("#tdrTime").val(""); //����ʱ��
	
	/**
	 * ����Ʊ�
	 */
	var tdrDeptCombobox = new ListCombobox("tdrDept",url+'?action=QueryConDept','');
	tdrDeptCombobox.init();
	
	$("#tdrDept").combobox("setValue",LgCtLocID);
	
	/**
	 * ������Ա
	 */
	var tdrUserCombobox = new ListCombobox("tdrUser",url+'?action=GetDeptUser&LgLocID='+LgCtLocID,'',{});
	tdrUserCombobox.init();
	
	$("#tdrUser").combobox("setValue",LgUserID);
	
		
	/**
	 * ���������
	 */
	var tdrPurDescCombobox = new ListCombobox("tdrPurDesc",'',tdrPurArray,{panelHeight:"auto"});
	tdrPurDescCombobox.init();
}

/// ����Ԫ�ؼ����¼�
function InitTinyWidgetListener(){

	$("a:contains('���ӿ���')").bind("click",insertRow);
	$("a:contains('��ѯ����')").bind("click",findTindy);
	$("a:contains('ȡ�����')").bind("click",cancelTdrComFlag);
	$("a:contains('ɾ��')").bind("click",DelTdrNo);
	$("a:contains('����')").bind("click",saveRow);
	$("a:contains('�������')").bind("click",setTdrComFlag);
	$("a:contains('���')").bind("click",clrCurrUI);
	
	$('#menu').menu({    
	    onClick:function(item){    
	       if (item.name == "delDet"){
		       delTdrItm();
		   }
	    }    
	});
}

///��ʼ�������б�
function InitTinyDrugRegDetList(){

	//������Ϊ�ɱ༭
	var manfEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			valueField: "value",
			textField: "text",
			url: url+"?action=QueryManf",
			onSelect:function(option){
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrManfID'});
				$(ed.target).val(option.value);  //���ò���ID
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrManf'});
				$(ed.target).combobox('setValue', option.text);  //���ò���Desc
			}
		}
	}
	
	//������Ϊ�ɱ༭
	var uomEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			valueField: "value",
			textField: "text",
			url: "",
			onSelect:function(option){
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrUomID'});
				$(ed.target).val(option.value);  //���õ�λID
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrUom'});
				$(ed.target).combobox('setValue', option.text);  //���õ�λDesc
			},
			onShowPanel:function(option){
				LoadUomComboboxData();
			}
		}
	}
	
	//������Ϊ�ɱ༭
	var tdrPurEditor={
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:tdrPurArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrPurCode'});
				$(ed.target).val(option.value);  //���ò��������ID
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrPurDesc'});
				$(ed.target).combobox('setValue', option.text);  //���ò��������Desc
			}
		}
	}
	
	//������Ϊ�ɱ༭
	var tdrBatExpEditor={
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value",
			textField: "text",
			url: "",
			onSelect:function(option){
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrBatID'});
				$(ed.target).val(option.value);  //��������ID
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrBatNo'});
				$(ed.target).combobox('setValue', option.text.split("~")[0]);  //��������
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrBatNoH'});
				$(ed.target).val(option.text.split("~")[0]);  //��������
				var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow,field:'tdrExpDate'});
				//$(ed.target).datebox("setValue", option.text.split("~")[1]);  //����Ч��
				$(ed.target).val(option.text.split("~")[1]);  //����Ч��
			},
			onShowPanel:function(option){
				LoadBatExpComboboxData();
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'tdrInciCode',title:'����',width:100,editor:textEditor},
		{field:'tdrInciDesc',title:'ҩƷ����',width:260,editor:textEditor},
		{field:'tdrInci',title:'tdrInci',width:100,editor:textEditor,hidden:true},
		{field:'tdrManfID',title:'tdrManfID',width:100,editor:textEditor,hidden:true},
		{field:'tdrManf',title:'����',width:190,editor:manfEditor},
		{field:'tdrPurCode',title:'tdrPurCode',width:120,editor:textEditor,hidden:true},
		{field:'tdrPurDesc',title:'���������',width:120,editor:tdrPurEditor,hidden:true},
		{field:'tdrBatNo',title:'����',width:140,editor:tdrBatExpEditor},
		{field:'tdrBatNoH',title:'����(����)',width:120,editor:textEditor},
		{field:'tdrExpDate',title:'Ч��',width:100,editor:textEditor},
		{field:'tdrQty',title:'��������',width:100,editor:NumberEditor},
		{field:'tdrBatID',title:'tdrBatID',width:120,editor:textEditor,hidden:true},
		{field:'tdrUomID',title:'tdrUomID',width:120,editor:textEditor,hidden:true},
		{field:'tdrUom',title:'��λ',width:100,editor:uomEditor},
		{field:'tdrMacSitNum',title:'ҩλ��',width:100,editor:textEditor},
		{field:'tdrSpec',title:'���',width:100,editor:textEditor},
		{field:'tdrItmID',title:'tdrItmID',width:100,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'������ϸ',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
	    	if ($('#tdrChkFlag').is(':checked')){
				 $.messager.alert('��ʾ','���㵥���Ѻ˶����,���ܽ��б༭��','warning');
				 return;
			}
	
			if ($('#tdrComFlag').is(':checked')){
				 $.messager.alert('��ʾ','���㵥�������,���ܽ��б༭��','warning');
				 return;
			}
            if ((editRow != "")||(editRow == "0")) { 
                $("#tdrDetList").datagrid('endEdit', editRow); 
            } 
            $("#tdrDetList").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  //���ûس��¼�
            editRow = rowIndex;
        },
		onRowContextMenu: function (e, rowIndex, rowData){
			e.preventDefault();
			$("#tdrDetList").datagrid("selectRow",rowIndex);
			$('#menu').menu('show', {    
			    left: e.pageX,
			    top: e.pageY
			}); 
		}
	};
		
	var tdrDetListComponent = new ListComponent('tdrDetList', columns, '', option);
	tdrDetListComponent.Init();

	/**
	 * ��ʼ����ʾ���������
	 */
	//initScroll("#tdrDetList");
}

/// ��datagrid�󶨻س��¼�
function dataGridBindEnterEvent(index){
	
	var editors = $('#tdrDetList').datagrid('getEditors', index);
	///ҩƷ����
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrInciDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var mydiv = new UIDivWindow($(ed.target), input, setCurrEditRowCellVal);
		    //var mydiv = new UIDivWindow($("#consPatMedNo"));
            mydiv.init();
		}
	});
	
	///����
	var workRateEditor = editors[7];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrBatNo'});
			if ($(ed.target).val() == ""){
				return;
			}
			var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrExpDate'});
			//$(ed.target).datebox().next('span').find('input').focus()
			$(ed.target).focus();
		}
	});
	
	///Ч��
	/*
	var workRateEditor = editors[8];
	$(workRateEditor.target).datebox().next('span').find('input').bind('keydown', function(e){
		if (e.keyCode == 13) {
			setTinyUIFocus("tdrExpDate");
		}
	});
	*/
	var workRateEditor = editors[9];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			setTinyUIFocus("tdrExpDate");
		}
	});
	
	///��������
	var workRateEditor = editors[10];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrQty'});
			if ($(ed.target).val() == ""){
				return;
			}
			setTinyUIFocus("tdrQty");   //insertRow();
		}
	});
	
	///ҩλ��
	var workRateEditor = editors[14];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			insertRow();
		}
	});
	/*
	var editors = $('#tdrDetList').datagrid('getEditors', index);
	for (var i=0; i<editors.length; i++){
		var workRateEditor = editors[i];
		if (i == 0){
			workRateEditor.target.focus();  ///���ý���
		}
		workRateEditor.target.bind('keydown', function(e){
			if (e.keyCode == 13) {
					var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrInciDesc'});		
				
					var input = $(ed.target).val();
					alert(input)
				//var ed=$("#tdrDetList").datagrid('getEditor',{index:index, field:'tdrInciDesc'});		
				
				//var input = $(ed.target).val();
				//setTinyUIFocus();
			}
		});
	}
	*/
}

/// ����ǰ�༭�и�ֵ
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#tdrDetList').datagrid('getEditors', editRow);
		///ҩƷ����
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
		return;
	}
	///ҩƷ����
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInciCode'});
	$(ed.target).val(rowObj.InciCode);
	///ҩƷ����
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInciDesc'});		
	$(ed.target).val(rowObj.InciDesc);
	///ҩƷ����ID
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInci'});		
	$(ed.target).val(rowObj.InciDr);
	///���
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrSpec'});		
	$(ed.target).val(rowObj.Spec);
	///����ID
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrManfID'});		
	$(ed.target).val(rowObj.Manfdr);
	///����
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrManf'});		
	$(ed.target).combobox("setValue",rowObj.Manf);
	/*
	///��λID
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUomID'});		
	$(ed.target).val(rowObj.PuomDr);
	///��λ
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUom'});
	$(ed.target).combobox("setValue",rowObj.PuomDesc);
	*/
	///��λID
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUomID'});		
	$(ed.target).val(rowObj.BuomDr);
	///��λ
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUom'});
	$(ed.target).combobox("setValue",rowObj.BuomDesc);
						
	///���ü���ָ��
	LoadUomComboboxData();
	
	///���ü���ָ��
	LoadBatExpComboboxData();

	setTinyUIFocus("tdrInciDesc","");
}

/// ���ص�λ�б�
function LoadUomComboboxData(){
	
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInci'});
	if ($(ed.target).val() == ""){ return;}
	var unitUrl=url + '?action=QueryUom&inci=' + $(ed.target).val();
	
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrUom'});
	$(ed.target).combobox('reload',unitUrl);
}

/// ��������Ч���б�
function LoadBatExpComboboxData(){
	
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrInci'});
	if ($(ed.target).val() == ""){ return;}
	var unitUrl=url + '?action=QueryBatExp&LocID=' +  LgCtLocID +'&Inci=' + $(ed.target).val();

	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:'tdrBatNo'});
	$(ed.target).combobox('reload',unitUrl);
}

/// ���ý���Ԫ�ؽ���
function setTinyUIFocus(lastEl, nextEl){
	var nextField = "";
	switch(lastEl){
	    case "tdrInciDesc":
			nextField="tdrBatNo";
			break;
	    case "tdrManf":
			nextField="tdrBatNo";
			break;
		case "tdrBatNo":
			nextField="tdrExpDate";
			break;
		case "tdrExpDate":
			nextField="tdrQty";
			break;
		case "tdrQty":
			nextField="tdrMacSitNum";
			break;
		default:
			nextField="";
	}
	if (nextField == ""){return;}
	var ed=$("#tdrDetList").datagrid('getEditor',{index:editRow, field:nextField});
	if (nextField == "tdrManf"){
		//$(ed.target).combobox().next('span').find('input').focus()
	}else{
		$(ed.target).focus().select();
	}
}
/// ��������
function insertRow(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥���Ѻ˶����,�������޸ģ�','warning');
		 return;
	}
	
	if ($('#tdrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥�������,����"ȡ��"��,�ٲ�����','warning');
		 return;
	}
	
	if(editRow >= "0"){
		$("#tdrDetList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	var rows = $("#tdrDetList").datagrid('getRows');
	if (rows.length != "0"){
		if (rows[rows.length - 1].tdrInci == ""){
			 $("#tdrDetList").datagrid('beginEdit', rows.length - 1);
			 dataGridBindEnterEvent(rows.length - 1);  //���ûس��¼�
             editRow = rows.length - 1;
			 return;
		}
	}
	/*
	$("#tdrDetList").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {tdrInciDesc: '',tdrSpec:'',tdrManf: '',tdrBatNo: '',tdrExpDate: ''}
	});
	
	$("#tdrDetList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	dataGridBindEnterEvent(0);  //���ûس��¼�
	editRow=0;
	
	*/
	///׷��
	$("#tdrDetList").datagrid('appendRow',{
		tdrInciDesc: '',tdrSpec:'',tdrManf: '',tdrBatNo: '',tdrExpDate: ''});

	var currRowIndex = $("#tdrDetList").datagrid("getRows").length - 1;
	$("#tdrDetList").datagrid('beginEdit', currRowIndex);//�����༭������Ҫ�༭����
	dataGridBindEnterEvent(currRowIndex);  //���ûس��¼�
	editRow = currRowIndex;

}

// ɾ��ѡ����
function deleteRow(){
	
	var rows = $("#tdrDetList").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdrPatImpoInfo',{"params":rows[0].ID}, function(data){
					$('#tdrDetList').datagrid('reload'); //���¼���
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#tdrDetList").datagrid('endEdit', editRow);
	}

	var rows = $("#tdrDetList").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	/**
	 *���㵥������Ϣ
	 */
	
	///����Ʊ�
	var tdrDeptID = $("#tdrDept").combobox("getValue");
	///������Ա
	var tdrUser = $("#tdrUser").combobox("getValue");
	///���������
	var tdrPurCode = $("#tdrPurDesc").combobox("getValue");
	if (tdrPurCode == ""){
		$.messager.alert("��ʾ:","<font style='font-size:20px;color:red;'>����Ŀ�Ĳ���Ϊ�գ�</font>");
		return;
	}
	var tdrMListData = tdrDeptID +"^"+ tdrUser +"^"+ tdrPurCode;
	
	///���㵥����ϸ��Ϣ
	var ListData = [];
	for(var i=0;i<rows.length;i++){
		
		if (rows[i].tdrInci != ""){
			var tmp = trsUndefinedToEmpty(rows[i].tdrItmID) +"^"+ rows[i].tdrInci +"^"+ rows[i].tdrManfID +"^"+ rows[i].tdrBatID;
			tmp = tmp +"^"+ rows[i].tdrQty  +"^"+ rows[i].tdrUomID +"^"+ rows[i].tdrBatNoH +"^"+ rows[i].tdrExpDate +"^"+ rows[i].tdrMacSitNum;
			ListData.push(tmp);
		}
	}
	var tdrDListData = ListData.join(RowDelim);
	
	var tdrID = $('#tdrID').val(); ///����ID

	//��������
	$.post(url+'?action=saveTindy',{"tdrID":tdrID, "tdrMListData":tdrMListData, "tdrDListData":tdrDListData},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode > 0){
			$.messager.alert("��ʾ:","����ɹ���");
			setCurrTdrNoUI(jsonTdrObj.ErrorCode);
		}else{
			$.messager.alert("��ʾ:","�ύʧ��,����ԭ��"+jsonTdrObj.ErrorMessage);
		}
	});
}

// �ı��༭��
var textEditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

// ���ֱ༭��
var NumberEditor={
	type: 'numberbox',//���ñ༭��ʽ
	options: {
		//required: true //���ñ༭��������
	}
}

// ���ڱ༭��
var dateEditor={
	type: 'datebox',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

/// ���Ҳ��㵥��
function findTindy(){
	createFindTindyDrugRegWin(setCurrTdrNoUI);
}

/// ��ѯ�ص�����
function setCurrTdrNoUI(tdrID){
	
	/*
	setCurrCompEditable();  /// ���õ�ǰ�ؼ��༭״̬
	
	$('#tdrID').val(rowData.tdrID);  ///����ID
	$('#tdrNo').val(rowData.tdrNo);  ///����

	$('#tdrComFlag').attr("checked",(rowData.tdrComFlag == "��"? true:false)); ///���
	$('#tdrChkFlag').attr("checked",(rowData.tdrChkFlag == "��"? true:false));  ///�˶�
	$('#tdrDate').datebox("setValue",rowData.tdrCDate); ///����
	$('#tdrTime').val(rowData.tdrCTime);  ///ʱ��
	$('#tdrDept').combobox("setValue",rowData.tdrDeptID); ///����
	$('#tdrUser').combobox("setValue",rowData.tdrUserID); ///��Ա
	$('#tdrPurDesc').combobox("setValue",rowData.tdrPurCode); ///����Ŀ��
	*/

	/// ��ѯ����
	$.post(url+'?action=GetTdrInfo',{"tdrID":tdrID},function(jsonString){

		var jsonTdrObj = jQuery.parseJSON(jsonString);

		$('#tdrID').val(jsonTdrObj.tdrID);  ///����ID
		$('#tdrNo').val(jsonTdrObj.tdrNo);  ///����

		$('#tdrComFlag').attr("checked",(jsonTdrObj.tdrComFlag == "��"? true:false)); ///���
		$('#tdrChkFlag').attr("checked",(jsonTdrObj.tdrChkFlag == "��"? true:false));  ///�˶�
		$('#tdrDate').datebox("setValue",jsonTdrObj.tdrCDate); ///����
		$('#tdrTime').val(jsonTdrObj.tdrCTime);  ///ʱ��
		$('#tdrDept').combobox("setValue",jsonTdrObj.tdrDeptID); ///����
		$('#tdrUser').combobox("setValue",jsonTdrObj.tdrUserID); ///��Ա
		$('#tdrPurDesc').combobox("setValue",jsonTdrObj.tdrPurCode); ///����Ŀ��
	});
	
	/// ����ҩƷ��ϸ
	$('#tdrDetList').datagrid({
		url:url+'?action=QueryTdrNoDetList',
		queryParams:{
			tdrID : tdrID}
	});
}

/// ���õ�ǰ�ؼ��༭״̬
function setCurrCompEditable(){
	
	$('#tdrNo').attr("disabled",true);
	$('#tdrDate').datebox({"disabled":true});
	$('#tdrTime').attr("disabled",true);
	$('#tdrDept').combobox({"disabled":true});
	$('#tdrUser').combobox({"disabled":true});
	$('#tdrPurDesc').combobox({"disabled":true});
}

/// ���
function clrCurrUI(){
	
	///ˢ�½���
	///location.reload();
	$('#tdrNo').attr("disabled",false);
	$('#tdrDate').datebox({"disabled":false});
	$('#tdrTime').attr("disabled",false);
	$('#tdrDept').combobox({"disabled":false});
	$('#tdrUser').combobox({"disabled":false});
	$('#tdrPurDesc').combobox({"disabled":false});
	
	///��ʼ��ֵ
	$('#tdrID').val("");  ///����ID
	$('#tdrNo').val("");  ///����
	$('#tdrComFlag').attr("checked",false); ///���
	$('#tdrChkFlag').attr("checked",false);  ///�˶�
	$("#tdrDate").datebox("setValue", formatDate(0));
	$('#tdrTime').val("");  ///ʱ��
	$("#tdrDept").combobox("setValue",LgCtLocID);
	$("#tdrUser").combobox("setValue",LgUserID);
	$('#tdrPurDesc').combobox("setValue",""); ///����Ŀ��

	///���datagrid 
	$('#tdrDetList').datagrid('loadData', {total:0,rows:[]}); 
}

/// ȷ�����
function setTdrComFlag(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥���Ѻ˶���ɣ�','warning');
		 return;
	}
	
	if ($('#tdrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥������ɣ�','warning');
		 return;
	}
	var tdrID = $('#tdrID').val(); ///����ID

	//��������
	$.post(url+'?action=SetTindyComFlag',{"tdrID":tdrID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$('#tdrComFlag').attr("checked",true);
			$.messager.alert("��ʾ:","���óɹ���");
		}else{
			$.messager.alert("��ʾ:","����ʧ��,����ԭ��"+jsonTdrObj.ErrorMessage);
		}
	});
}

/// ȡ�����
function cancelTdrComFlag(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥���Ѻ˶����,��������д˲�����','warning');
		 return;
	}
	
	if (!$('#tdrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥��δ���,����Ҫ"ȡ��"��','warning');
		 return;
	}
	var tdrID = $('#tdrID').val(); ///����ID

	//��������
	$.post(url+'?action=CancelTindyComFlag',{"tdrID":tdrID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$('#tdrComFlag').attr("checked",false);
			$.messager.alert("��ʾ:","ȡ���ɹ���");
		}else{
			$.messager.alert("��ʾ:","ȡ��ʧ��,����ԭ��"+jsonTdrObj.ErrorMessage);
		}
	});
}

/// ɾ������
function DelTdrNo(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥���Ѻ˶����,������"ɾ��"��','warning');
		 return;
	}
	
	if ($('#tdrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥��δ���,������"ɾ��"��','warning');
		 return;
	}
	var tdrID = $('#tdrID').val(); ///����ID

	//��������
	$.post(url+'?action=DelTindy',{"tdrID":tdrID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$.messager.alert("��ʾ:","ɾ���ɹ���");
			clrCurrUI();
		}else{
			$.messager.alert("��ʾ:","ɾ��ʧ��,����ԭ��"+jsonTdrObj.ErrorMessage);
		}
	});
}


/// ɾ����ϸ��Ŀ
function delTdrItm(){
	
	if ($('#tdrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥���Ѻ˶����,������"ɾ��"��','warning');
		 return;
	}
	
	if ($('#tdrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���㵥�������,������"ɾ��"��','warning');
		 return;
	}
	
	var rowData = $("#tdrDetList").datagrid('getSelected'); //ѡ����
	if (trsUndefinedToEmpty(rowData.tdrItmID) == ""){
		var selectedRowIndex = $("#tdrDetList").datagrid('getRowIndex',rowData);
		$("#tdrDetList").datagrid('deleteRow',selectedRowIndex);
		return;
	}

	//��������
	$.post(url+'?action=delTdrItm',{"tdrItmID":rowData.tdrItmID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$.messager.alert("��ʾ:","ɾ���ɹ���");
			$("#tdrDetList").datagrid("reload");
		}else{
			$.messager.alert("��ʾ:","ɾ��ʧ��,����ԭ��"+jsonTdrObj.ErrorMessage);
		}
	});
}