/// Descript: ���ҽ��ά��
/// Creator : sufan
/// Date    : 2017-02-07
var editRow = ""; editTRow = ""; var ArcColumns="";
var ArcUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail';
var ExecArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
var TarArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
var ReqArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
/// ҳ���ʼ������
function initPageDefault(){
	var hospComp = GenHospComp("DHC_AppArcAdd"); //Doc_APP_Arcmastrelmain
	hospComp.jdata.options.onSelect  = function(){
		$("#code,#desc").val("");
		commonQuery();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		initArcItemList();       ///  ��ʼҳ��DataGrid���ҽ���б�
		initButton();          ///  ҳ��Button���¼�
		initColumns();
	}
}
/// ��ʼ��datagrid��
function initColumns(){
	ArcColumns = [[
	    {field:'itmDesc',title:'ҽ��������',width:220},
	    {field:'itmCode',title:'ҽ�������',width:100},
	    {field:'itmPrice',title:'����',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];
}
///�����Ŀ,��λ�б� 
function initArcItemList(){
	
	/// ִ�б�־
	var ExecFlageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:ExecArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ExecFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ExecCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	
	/// �Ʒѱ�־
	var TarFlageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:TarArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'TarFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'TarCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	
	
	/// �����־
	var ReqFlageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:ReqArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ReqFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ReqCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'ArcDr',title:'ҽ����ID',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'AraArcCode',title:'ҽ�������',width:180,editor:textEditor},
		{field:'AraArcDesc',title:'ҽ����',width:240,editor:textEditor},
		{field:'ExecCode',title:'ExecCode',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'ExecFlag',title:'����λ����ִ�м�¼',width:180,align:'center',hidden:true,editor:ExecFlageditor},
		{field:'TarCode',title:'TarCode',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'TarFlag',title:'����λ�ۼ��շ�',width:160,align:'center',editor:TarFlageditor},
		{field:'ReqCode',title:'ReqCode',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'ReqFlag',title:'�Զ���������(�����/��������)',width:200,align:'center',editor:ReqFlageditor},
		{field:"AraRowId",title:'ID',hidden:true,editor:textEditor}
	]];
	
	///  ����datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#arcItemList").datagrid('endEdit', editRow); 
            } 
            $("#arcItemList").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  //���ûس��¼�
            editRow = rowIndex;
        }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue()
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcAdd&MethodName=QueryExaArc&HospID="+HospID;
	new ListComponent('arcItemList', columns, uniturl, option).Init(); 
}


/// ҳ�� Button ���¼�
function initButton(){
	
	///  ���Ӽ����Ŀ,��λ
	$('#arctb a:contains("����")').bind("click",insertArcRow);
	
	///  ��������Ŀ,��λ
	$('#arctb a:contains("����")').bind("click",saveExecArc);
	
	///  ɾ�������Ŀ,��λ
	$('#arctb a:contains("ɾ��")').bind("click",deleteArcRow);
	
	///�س��¼� sufan   2016/08/03
	$('#desc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var HospID=$HUI.combogrid('#_HospList').getValue()
			var unitUrl = ArcUrl + "&Input="+$('#desc').val()+"&HospID="+HospID;
			/// ����ҽ�����б���
			//new ListComponentWin($('#desc'), "", "600px", "" , unitUrl, ArcColumns, setArcCurrEditRowCellVal).init();
		}
	});
	
	 // ���Ұ�ť�󶨵����¼�
	$('#find').bind('click',function(event){
         commonQuery(); //���ò�ѯ
    })
    
	//���ð�ť�󶨵����¼�
	$('#reset').bind('click',function(event){
		$('#code').val("");
		$('#desc').val("");
		commonQuery(); //���ò�ѯ
	})		
}

///��ѯ��ťҽ������Ӧ����
function setArcCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#desc').focus().select();  ///���ý��� ��ѡ������
		return;
	}
	$('#desc').val(rowObj.itmDesc);  /// ҽ����
}

/// ��������Ŀ��λ��
function insertArcRow(){
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#arcItemList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {AraRowId:'', ArcDr:'', AraArcDesc:'', TarCode:'N',TarFlag:'N',ReqCode:'Y',ReqFlag:'Y'}
	});
	$("#arcItemList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
	
	var rows = $("#arcItemList").datagrid('getRows');
	if (rows.length != "0"){
		dataGridBindEnterEvent(0);  //���ûس��¼�
	}
}
///��������Ŀ��λ
function saveExecArc(){
	
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);
	}
	var rowsData = $("#arcItemList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var HospID=$HUI.combogrid('#_HospList').getValue()
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].ArcDr=="")||(rowsData[i].AraArcDesc=="")){
			$.messager.alert("��ʾ","ҽ�����Ϊ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].AraRowId+"^"+rowsData[i].ArcDr+"^"+rowsData[i].AraArcDesc+"^"+rowsData[i].ExecCode+"^"+ rowsData[i].TarCode +"^"+ rowsData[i].ReqCode+"^"+HospID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPArcAdd","SaveExaArc",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ","����ɹ�!"); 
			$('#arcItemList').datagrid('reload'); //���¼���
		}
		if(jsonString=="-1"){
			$.messager.alert("��ʾ","�����ظ�!"); 
			$('#arcItemList').datagrid('reload'); //���¼���
		}
	});
}

/// ɾ��
function deleteArcRow(){
	
	var rowsData = $("#arcItemList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPArcAdd","DeleteArcAdd",{"AraRowId":rowsData.AraRowId},function(jsonString){
					$('#arcItemList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}	 
/// ��ҽ����󶨻س��¼�
function dataGridBindEnterEvent(index){
	
	var editors = $('#arcItemList').datagrid('getEditors', index);
	/// �����Ŀ����
	var workRateEditor = editors[2];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#arcItemList").datagrid('getEditor',{index:index, field:'AraArcDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var HospID=$HUI.combogrid('#_HospList').getValue()
			var unitUrl = ArcUrl + "&Input="+$(ed.target).val()+"&HospID="+HospID;
			/// ����ҽ�����б���
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	});
}

/// ����ǰ�༭�и�ֵ(�����Ŀ)
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#arcItemList').datagrid('getEditors', editRow);
		///�����Ŀ
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
		return;
	}
	/// ��Ŀ����
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'AraArcDesc'});
	$(ed.target).val(rowObj.itmDesc);
	/// ��Ŀ����ID
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ArcDr'});		
	$(ed.target).val(rowObj.itmID);
	/// ��Ŀ����
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'AraArcCode'});		
	$(ed.target).val(rowObj.itmCode);
}
/// ��ҽ���������ѯ����
function commonQuery() 
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var param=code+"^"+desc;
	var HospID=$HUI.combogrid('#_HospList').getValue()
	$('#arcItemList').datagrid('load',{params:param,HospID:HospID}); 
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
