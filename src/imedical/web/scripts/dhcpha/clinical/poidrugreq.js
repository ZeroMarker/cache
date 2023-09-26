
/// bianshuai
/// 2016-04-02
/// �龫ҩƷ���ٵǼ�

var editRow = "";
var url="dhcpha.clinical.action.csp";
$(function(){
	
	//��ʼ������Ĭ����Ϣ
	InitDefault();
	
	//��ʼ����ѯ��Ϣ�б�
	InitDetList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
})

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	
	/**
	 * ��������
	 */
	$("#ddrDate").datebox("setValue", formatDate(0));
	//$("#ddrTime").val(""); //����ʱ��
	
	/**
	 * ����Ʊ�
	 */
	var ddrDeptCombobox = new ListCombobox("ddrDept",url+'?action=QueryConDept','');
	ddrDeptCombobox.init();
	
	$("#ddrDept").combobox("setValue",LgCtLocID);
	
	/**
	 * ������Ա
	 */
	var ddrUserCombobox = new ListCombobox("ddrUser",url+'?action=GetDeptUser&LgLocID='+LgCtLocID,'',{panelHeight:"auto"});
	ddrUserCombobox.init();
	
	$("#ddrUser").combobox("setValue",LgUserID);
	
		
	/**
	 * ���տƱ�
	 */
	var ddrToLocCombobox = new ListCombobox("ddrToLoc",url+'?action=QueryConDept','');
	ddrToLocCombobox.init();

}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$("a:contains('���ӿ���')").bind("click",insertRow);
	$("a:contains('��ѯ����')").bind("click",findTindy);
	$("a:contains('ȡ�����')").bind("click",cancelComFlag);
	$("a:contains('ɾ��')").bind("click",DelddrNo);
	$("a:contains('����')").bind("click",saveRow);
	$("a:contains('�������')").bind("click",setComFlag);
	$("a:contains('���')").bind("click",clrCurrUI);
	
	$('#menu').menu({    
	    onClick:function(item){    
	       if (item.name == "delDet"){
		       delddrItm();
		   }
	    }    
	});
}

///��ʼ�������б�
function InitDetList(){

	//������Ϊ�ɱ༭
	var manfEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			valueField: "value",
			textField: "text",
			url: url+"?action=QueryManf",
			onSelect:function(option){
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrManfID'});
				$(ed.target).val(option.value);  //���ò���ID
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrManf'});
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
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrUomID'});
				$(ed.target).val(option.value);  //���õ�λID
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrUom'});
				$(ed.target).combobox('setValue', option.text);  //���õ�λDesc
			},
			onShowPanel:function(option){
				LoadUomComboboxData();
			}
		}
	}
	
	//������Ϊ�ɱ༭
	var ddrBatExpEditor={
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value",
			textField: "text",
			width:"200px",
			url: "",
			onSelect:function(option){
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrBatID'});
				$(ed.target).val(option.value);  //��������ID
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrBatNo'});
				$(ed.target).combobox('setValue', option.text.split("~")[0]);  //��������
				var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow,field:'ddrExpDate'});
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
		{field:'ddrInciCode',title:'����',width:100,editor:textEditor},
		{field:'ddrInciDesc',title:'ҩƷ����',width:260,editor:textEditor},
		{field:'ddrInci',title:'ddrInci',width:100,editor:textEditor,hidden:true},
		{field:'ddrManfID',title:'ddrManfID',width:100,editor:textEditor,hidden:true},
		{field:'ddrManf',title:'����',width:200,editor:manfEditor},
		{field:'ddrBatNo',title:'����',width:140,editor:ddrBatExpEditor},
		{field:'ddrExpDate',title:'Ч��',width:145,editor:textEditor},
		{field:'ddrQty',title:'�˻�����',width:120,editor:NumberEditor},
		{field:'ddrBatID',title:'ddrBatID',width:120,editor:textEditor,hidden:true},
		{field:'ddrUomID',title:'ddrUomID',width:120,editor:textEditor,hidden:true},
		{field:'ddrUom',title:'��λ',width:120,editor:uomEditor},
		{field:'ddrSpec',title:'���',width:120,editor:textEditor},
		{field:'ddrRemark',title:'��ע',width:200,editor:textEditor},
		{field:'ddrItmID',title:'ddrItmID',width:100,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'�˻�������ϸ',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
	    	if ($('#ddrChkFlag').is(':checked')){
				 $.messager.alert('��ʾ','���뵥���Ѻ˶����,���ܽ��б༭��','warning');
				 return;
			}
	
			if ($('#ddrComFlag').is(':checked')){
				 $.messager.alert('��ʾ','���뵥�������,���ܽ��б༭��','warning');
				 return;
			}
            if ((editRow != "")||(editRow == "0")) { 
                $("#ddrDetList").datagrid('endEdit', editRow); 
            } 
            $("#ddrDetList").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  //���ûس��¼�
            editRow = rowIndex;
        },
		onRowContextMenu: function (e, rowIndex, rowData){
			e.preventDefault();
			$("#ddrDetList").datagrid("selectRow",rowIndex);
			$('#menu').menu('show', {    
			    left: e.pageX,
			    top: e.pageY
			}); 
		}
	};
		
	var ddrDetListComponent = new ListComponent('ddrDetList', columns, '', option);
	ddrDetListComponent.Init();

	/**
	 * ��ʼ����ʾ���������
	 */
	//initScroll("#ddrDetList");
}

/// ��datagrid�󶨻س��¼�
function dataGridBindEnterEvent(index){
	
	var editors = $('#ddrDetList').datagrid('getEditors', index);
	///ҩƷ����
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrInciDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var mydiv = new UIDivWindow($(ed.target), input, setCurrEditRowCellVal);
		    //var mydiv = new UIDivWindow($("#consPatMedNo"));
            mydiv.init();
		}
	});
	
	///����
	/*
	var workRateEditor = editors[5];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrBatNo'});
			if ($(ed.target).val() == ""){
				return;
			}
			var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrExpDate'});
			//$(ed.target).datebox().next('span').find('input').focus()
			$(ed.target).focus();
		}
	});
	*/
	///Ч��
	/*
	var workRateEditor = editors[6];
	$(workRateEditor.target).datebox().next('span').find('input').bind('keydown', function(e){
		if (e.keyCode == 13) {
			setTinyUIFocus("ddrExpDate");
		}
	});
	*/
	/*
	var workRateEditor = editors[6];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			setTinyUIFocus("ddrExpDate");
		}
	});
	*/
	///��������
	var workRateEditor = editors[7];
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrQty'});
			if ($(ed.target).val() == ""){
				return;
			}
			insertRow();
		}
	});
	/*
	var editors = $('#ddrDetList').datagrid('getEditors', index);
	for (var i=0; i<editors.length; i++){
		var workRateEditor = editors[i];
		if (i == 0){
			workRateEditor.target.focus();  ///���ý���
		}
		workRateEditor.target.bind('keydown', function(e){
			if (e.keyCode == 13) {
					var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrInciDesc'});		
				
					var input = $(ed.target).val();
					alert(input)
				//var ed=$("#ddrDetList").datagrid('getEditor',{index:index, field:'ddrInciDesc'});		
				
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
		var editors = $('#ddrDetList').datagrid('getEditors', editRow);
		///ҩƷ����
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
		return;
	}
	///ҩƷ����
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInciCode'});
	$(ed.target).val(rowObj.InciCode);
	///ҩƷ����
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInciDesc'});		
	$(ed.target).val(rowObj.InciDesc);
	///ҩƷ����ID
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInci'});		
	$(ed.target).val(rowObj.InciDr);
	///���
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrSpec'});		
	$(ed.target).val(rowObj.Spec);
	///����ID
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrManfID'});		
	$(ed.target).val(rowObj.Manfdr);
	///����
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrManf'});		
	$(ed.target).combobox("setValue",rowObj.Manf);
	///��λID
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrUomID'});		
	$(ed.target).val(rowObj.PuomDr);
	///��λ
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrUom'});
	$(ed.target).combobox("setValue",rowObj.PuomDesc);
						
	///���ü���ָ��
	LoadUomComboboxData();
	
	///���ü���ָ��
	LoadBatExpComboboxData();

	setTinyUIFocus("ddrInciDesc","");
}

/// ���ص�λ�б�
function LoadUomComboboxData(){
	
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInci'});
	if ($(ed.target).val() == ""){ return;}
	var unitUrl=url + '?action=QueryUom&inci=' + $(ed.target).val();
	
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrUom'});
	$(ed.target).combobox('reload',unitUrl);
}

/// ��������Ч���б�
function LoadBatExpComboboxData(){
	
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrInci'});
	if ($(ed.target).val() == ""){ return;}
	var unitUrl=url + '?action=QueryBatExp&LocID=' +  LgCtLocID +'&Inci=' + $(ed.target).val();

	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:'ddrBatNo'});
	$(ed.target).combobox('reload',unitUrl);
}

/// ���ý���Ԫ�ؽ���
function setTinyUIFocus(lastEl, nextEl){
	var nextField = "";
	switch(lastEl){
	    case "ddrInciDesc":
			nextField="ddrBatNo";
			break;
	    case "ddrManf":
			nextField="ddrBatNo";
			break;
		case "ddrBatNo":
			nextField="ddrExpDate";
			break;
		case "ddrExpDate":
			nextField="ddrQty";
			break;
		default:
			nextField="";
	}
	if (nextField == ""){return;}
	var ed=$("#ddrDetList").datagrid('getEditor',{index:editRow, field:nextField});
	if (nextField == "ddrManf"){
		//$(ed.target).combobox().next('span').find('input').focus()
	}else{
		$(ed.target).focus().select();
	}
}
/// ��������
function insertRow(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���뵥���Ѻ˶����,�������޸ģ�','warning');
		 return;
	}
	
	if ($('#ddrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���뵥�������,����"ȡ��"��,�ٲ�����','warning');
		 return;
	}
	
	if(editRow >= "0"){
		$("#ddrDetList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	var rows = $("#ddrDetList").datagrid('getRows');
	if (rows.length != "0"){
		if (rows[rows.length - 1].ddrInci == ""){
			 $("#ddrDetList").datagrid('beginEdit', rows.length - 1);
			 dataGridBindEnterEvent(rows.length - 1);  //���ûس��¼�
             editRow = rows.length - 1;
			 return;
		}
	}
	/*
	$("#ddrDetList").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ddrInciDesc: '',ddrSpec:'',ddrManf: '',ddrBatNo: '',ddrExpDate: ''}
	});
	
	$("#ddrDetList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	dataGridBindEnterEvent(0);  //���ûس��¼�
	editRow=0;
	
	*/
	///׷��
	$("#ddrDetList").datagrid('appendRow',{
		ddrInciDesc: '',ddrSpec:'',ddrManf: '',ddrBatNo: '',ddrExpDate: ''});

	var currRowIndex = $("#ddrDetList").datagrid("getRows").length - 1;
	$("#ddrDetList").datagrid('beginEdit', currRowIndex);//�����༭������Ҫ�༭����
	dataGridBindEnterEvent(currRowIndex);  //���ûس��¼�
	editRow = currRowIndex;

}

// ɾ��ѡ����
function deleteRow(){
	
	var rows = $("#ddrDetList").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdrPatImpoInfo',{"params":rows[0].ID}, function(data){
					$('#ddrDetList').datagrid('reload'); //���¼���
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
		$("#ddrDetList").datagrid('endEdit', editRow);
	}

	var rows = $("#ddrDetList").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	/**
	 *���뵥������Ϣ
	 */

	///����Ʊ�
	var ddrDeptID = $("#ddrDept").combobox("getValue");
	///������Ա
	var ddrUser = $("#ddrUser").combobox("getValue");
	
	///���տ���
	var ddrToLoc = $("#ddrToLoc").combobox("getValue");
	
	if (ddrToLoc == ""){
		$.messager.alert("��ʾ:","<font style='font-size:20px;color:red;'>���տ��Ҳ���Ϊ�գ�</font>");
		return;
	}
	var ddrMListData = ddrDeptID +"^"+ ddrUser +"^"+ ddrToLoc ;

	///���뵥����ϸ��Ϣ
	var ListData = [];
	for(var i=0;i<rows.length;i++){
		
		if (rows[i].ddrInci != ""){
			var tmp = trsUndefinedToEmpty(rows[i].ddrItmID) +"^"+ rows[i].ddrInci +"^"+ rows[i].ddrManfID +"^"+ rows[i].ddrBatID;
			tmp = tmp +"^"+ rows[i].ddrQty  +"^"+ rows[i].ddrUomID +"^"+ rows[i].ddrBatNo +"^"+ rows[i].ddrExpDate+"^"+ rows[i].ddrRemark;
			ListData.push(tmp);
		}
	}
	var ddrDListData = ListData.join(RowDelim);

	var ddrID = $('#ddrID').val(); ///����ID

	//��������
	$.post(url+'?action=saveDrgReq',{"ddrID":ddrID, "ddrMListData":ddrMListData, "ddrDListData":ddrDListData},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode > 0){
			$.messager.alert("��ʾ:","����ɹ���");
			setCurrddrNoUI(jsonddrObj.ErrorCode);
		}else{
			$.messager.alert("��ʾ:","�ύʧ��,����ԭ��"+jsonddrObj.ErrorMessage);
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

/// �������ٵ���
function findTindy(){
	createDesDrugReqWin(setCurrddrNoUI);
}

/// ��ѯ�ص�����
function setCurrddrNoUI(ddrID){
	
	/// ��ѯ����
	$.post(url+'?action=GetReqMainInfo',{"ddrID":ddrID},function(jsonString){

		var jsonddrObj = jQuery.parseJSON(jsonString);

		$('#ddrID').val(jsonddrObj.ddrID);  ///����ID
		$('#ddrNo').val(jsonddrObj.ddrNo);  ///����
		$('#ddrComFlag').attr("checked",(jsonddrObj.ddrComFlag == "��"? true:false)); ///���
		$('#ddrChkFlag').attr("checked",(jsonddrObj.ddrChkFlag == "��"? true:false));  ///�˶�
		$('#ddrDate').datebox("setValue",jsonddrObj.ddrCDate); ///����
		$('#ddrTime').val(jsonddrObj.ddrCTime);  ///ʱ��
		$('#ddrDept').combobox("setValue",jsonddrObj.ddrDeptID); ///����
		$('#ddrUser').combobox("setValue",jsonddrObj.ddrUserID); ///��Ա
		$('#ddrToLoc').combobox("setValue",jsonddrObj.ddrToLocDesc); ///���տ���
		$('#ddrRemark').combobox("setValue",jsonddrObj.ddrRemarkCode); ///��ע
	});
	
	/// ����ҩƷ��ϸ
	$('#ddrDetList').datagrid({
		url:url+'?action=QueryReqNoDetList',
		queryParams:{
			ddrID : ddrID}
	});
}

/// ���õ�ǰ�ؼ��༭״̬
function setCurrCompEditable(){
	
	$('#ddrNo').attr("disabled",true);
	$('#ddrDate').datebox({"disabled":true});
	$('#ddrTime').attr("disabled",true);
	$('#ddrDept').combobox({"disabled":true});
	$('#ddrUser').combobox({"disabled":true});
	$('#ddrToLoc').combobox({"disabled":true});
}

/// ���
function clrCurrUI(){
	
	///ˢ�½���
	///location.reload();
	$('#ddrNo').attr("disabled",false);
	$('#ddrDate').datebox({"disabled":false});
	$('#ddrTime').attr("disabled",false);
	$('#ddrDept').combobox({"disabled":false});
	$('#ddrUser').combobox({"disabled":false});
	$('#ddrToLoc').combobox({"disabled":false});
	
	///��ʼ��ֵ
	$('#ddrID').val("");  ///����ID
	$('#ddrNo').val("");  ///����
	$('#ddrComFlag').attr("checked",false); ///���
	$('#ddrChkFlag').attr("checked",false);  ///�˶�
	$("#ddrDate").datebox("setValue", formatDate(0));
	$('#ddrTime').val("");  ///ʱ��
	$("#ddrDept").combobox("setValue",LgCtLocID);
	$("#ddrUser").combobox("setValue",LgUserID);
	$('#ddrToLoc').combobox("setValue",""); ///���տ���

	///���datagrid 
	$('#ddrDetList').datagrid('loadData', {total:0,rows:[]}); 
}

/// ȷ�����
function setComFlag(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���ٵ����Ѻ˶���ɣ�','warning');
		 return;
	}
	
	if ($('#ddrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���ٵ�������ɣ�','warning');
		 return;
	}
	var ddrID = $('#ddrID').val(); ///����ID

	//��������
	$.post(url+'?action=SetReqComFlag',{"ddrID":ddrID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$('#ddrComFlag').attr("checked",true);
			$.messager.alert("��ʾ:","���óɹ���");
		}else{
			$.messager.alert("��ʾ:","����ʧ��,����ԭ��"+jsonddrObj.ErrorMessage);
		}
	});
}

/// ȡ�����
function cancelComFlag(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���ٵ����Ѻ˶����,��������д˲�����','warning');
		 return;
	}
	
	if (!$('#ddrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���ٵ���δ���,����Ҫ"ȡ��"��','warning');
		 return;
	}
	var ddrID = $('#ddrID').val(); ///����ID

	//��������
	$.post(url+'?action=CancelReqComFlag',{"ddrID":ddrID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$('#ddrComFlag').attr("checked",false);
			$.messager.alert("��ʾ:","ȡ���ɹ���");
		}else{
			$.messager.alert("��ʾ:","ȡ��ʧ��,����ԭ��"+jsonddrObj.ErrorMessage);
		}
	});
}

/// ɾ������
function DelddrNo(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���ٵ����Ѻ˶����,������"ɾ��"��','warning');
		 return;
	}
	
	if ($('#ddrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���ٵ���δ���,������"ɾ��"��','warning');
		 return;
	}
	var ddrID = $('#ddrID').val(); ///����ID

	//��������
	$.post(url+'?action=DelReq',{"ddrID":ddrID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$.messager.alert("��ʾ:","ɾ���ɹ���");
			clrCurrUI();
		}else{
			$.messager.alert("��ʾ:","ɾ��ʧ��,����ԭ��"+jsonddrObj.ErrorMessage);
		}
	});
}


/// ɾ����ϸ��Ŀ
function delddrItm(){
	
	if ($('#ddrChkFlag').is(':checked')){
		 $.messager.alert('��ʾ','���ٵ����Ѻ˶����,������"ɾ��"��','warning');
		 return;
	}
	
	if ($('#ddrComFlag').is(':checked')){
		 $.messager.alert('��ʾ','���ٵ��������,������"ɾ��"��','warning');
		 return;
	}
	
	var rowData = $("#ddrDetList").datagrid('getSelected'); //ѡ����
	if (trsUndefinedToEmpty(rowData.ddrItmID) == ""){
		var selectedRowIndex = $("#ddrDetList").datagrid('getRowIndex',rowData);
		$("#ddrDetList").datagrid('deleteRow',selectedRowIndex);
		return;
	}

	//��������
	$.post(url+'?action=delReqItm',{"ddrItmID":rowData.ddrItmID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$.messager.alert("��ʾ:","ɾ���ɹ���");
			$("#ddrDetList").datagrid("reload");
		}else{
			$.messager.alert("��ʾ:","ɾ��ʧ��,����ԭ��"+jsonddrObj.ErrorMessage);
		}
	});
}