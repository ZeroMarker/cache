/** Descript  : �����Ŀ�ײͼ���ϸά��
 *  Creator   : sufan
 *  CreatDate : 2017-07-06
 */
var editRow = ""; 
var ActiveArray = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var TestPackID="" ;  ///�����Ŀ�ײ�ID
var ArcUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail';
/// ҳ���ʼ������
function initPageDefault(){
	
	initPacklist();       	/// ��ʼҳ��DataGrid�����Ŀ�ײͱ�
	initPackItmlist();	 	///	��ʼҳ��DataGrid�����Ŀ�ײͱ�
	initButton();           /// ҳ��Button���¼�
	initColumns();	
}

/// ��ʼ��datagrid��
function initColumns(){
		
	ArcColumns = [[
	    {field:'itmDesc',title:'ҽ��������',width:300},
	    {field:'itmCode',title:'ҽ�������',width:100},
	    {field:'itmPrice',title:'����',width:100},
		{field:'itmID',title:'itmID',width:80,hidden:true}
	]];
}

///�����Ŀ�ײ��б� 
function initPacklist(){
	
	// ҽԺ
	var Hospeditor={		//������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'HospDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// �Ƿ����
	var Flageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:ActiveArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'ATPFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	// ������
	var ItmCateditor={	
		type: 'combobox',	//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+'?ClassName=web.DHCAPPTestPack&MethodName=GetArcCat&HospID='+LgHospID,
			panelHeight:180,  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'CatDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#Packlist").datagrid('getEditor',{index:editRow,field:'CatID'});
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
	// ����columns
	var columns=[[
		{field:"ATPCode",title:'�ײʹ���',width:120,align:'center',editor:textEditor},
		{field:"ATPDesc",title:'�ײ�����',width:120,align:'center',editor:textEditor},
		{field:"FlagCode",title:'FlagCode',width:80,hidden:'true',align:'center',editor:textEditor},
		{field:"ATPFlag",title:'�Ƿ����',width:80,align:'center',editor:Flageditor},
		{field:"CatID",title:'����ID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"CatDesc",title:'������',width:140,align:'center',editor:ItmCateditor},
		{field:"HospDesc",title:'ҽԺ',width:180,align:'center',editor:Hospeditor},
		{field:"HospDr",title:'ҽԺID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"ATPRowID",title:'ID',width:20,hidden:'true',align:'center'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#Packlist").datagrid('endEdit', editRow); 
            } 
            $("#Packlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
       onClickRow:function(rowIndex, rowData){
	    	TestPackID = rowData.ATPRowID ;
			$('#PackItmlist').datagrid('reload',{TestPackID: TestPackID});
	   }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTestPack&MethodName=QueryTestPack&HospID='+LgHospID;
	new ListComponent('Packlist', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	///  ���Ӽ����Ŀ
	$('#insert').bind("click",insertPackRow);
	
	///  ��������Ŀ
	$('#save').bind("click",savePackRow);
	
	///  ɾ�������Ŀ
	$('#delete').bind("click",deletePackRow);
	
	///  �����ײ���ϸ
	$('#insertItm').bind("click",insertItmRow);
	
	///  �����ײ���ϸ
	$('#saveItm').bind("click",saveItmRow);
	
	///  ɾ���ײ���ϸ
	$('#deleteItm').bind("click",deleteItmRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findPacklist(); //���ò�ѯ
        }
    });
    
    // �����ײ���Ŀ��ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findPacklist(); //���ò�ѯ
    });
    
   	// �����Ŀ�󶨻س��¼�
    $('#Itemdesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findPackItemlist(); //���ò�ѯ
        }
    });
    // �����ײ���Ŀ��ϸ��ť�󶨵����¼�
    $('#Itemfind').bind('click',function(event){
         findPackItemlist(); //���ò�ѯ
    });
    
    //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findPacklist(); //���ò�ѯ
    }); 
    
    //���ð�ť�󶨵����¼�
    $('#resetitm').bind('click',function(event){
	    $('#Itemdesc').val("");
        findPackItemlist(); //���ò�ѯ
    }); 
}

/// ��������Ŀ��
function insertPackRow(){

	if(editRow>="0"){
		$("#Packlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#Packlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ATPRowID:'',ATPCode:'',ATPDesc:'',FlagCode:'Y',ATPFlag:'Y',HospDr:LgHospID,HospDesc:LgHospID}
	});
    
	$("#Packlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///��������Ŀ
function savePackRow(){
	
	if(editRow>="0"){
		$("#Packlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#Packlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].ATPCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].ATPDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].CatDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�м�����Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].HospDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"ҽԺΪΪ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].ATPRowID +"^"+ rowsData[i].ATPCode +"^"+ rowsData[i].ATPDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].ATPFlag +"^"+ rowsData[i].CatID;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCAPPTestPack","SaveTestPack",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#Packlist').datagrid('reload'); //���¼���
	});
}

/// ɾ��
function deletePackRow(){
	
	var rowsData = $("#Packlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPTestPack","DeleteTestPack",{"ATPRowID":rowsData.ATPRowID},function(jsonString){
					$('#Packlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ�ײ���Ŀ
function findPacklist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#Packlist').datagrid('load',{params:params}); 
}	 
////==========================================�ײ���ϸά��=======================================================================
/// ��ʼ����Ŀ��ϸ�б�
function initPackItmlist()
{
	var Itemeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+'?ClassName=web.DHCAPPTestPack&MethodName=GetTestItem&HospID='+LgHospID,
			//required:true,
			panelHeight:"260",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#PackItmlist").datagrid('getEditor',{index:editRow,field:'TestItemDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#PackItmlist").datagrid('getEditor',{index:editRow,field:'TestItemID'});
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
	// ����columns
	var columns=[[
		{field:"TestDesc",title:'ҽ����Ŀ',width:300,align:'center',editor:textEditor},
		{field:"TestQty",title:'����',width:120,align:'center',editor:textEditor},
		{field:"TestID",title:'TestID',width:80,align:'center',editor:textEditor},
		{field:"TestPackItmID",title:'TestPackItmID',width:80,align:'center'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    	var e = $("#PackItmlist").datagrid('getColumnOption', 'TestDesc');
			e.editor = {};
            if (editRow != ""||editRow == 0) { 
                $("#PackItmlist").datagrid('endEdit', editRow); 
            } 
            $("#PackItmlist").datagrid('beginEdit', rowIndex); 
            dataArcGridBindEnterEvent(rowIndex);  //���ûس��¼�
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTestPack&MethodName=QueryTestPackItm";
	new ListComponent('PackItmlist', columns, uniturl, option).Init();
}
/// �����ײ���ϸ
function insertItmRow()
{
	var rowsData = $("#Packlist").datagrid('getSelected');
	if (rowsData==null)
	{
		$.messager.alert("��ʾ","����ѡ������Ŀ�ײͣ�"); 
		return false;
	}
	var e = $("#PackItmlist").datagrid('getColumnOption', 'TestDesc');
	e.editor = {type:'text'};
	
	if(editRow>="0"){
		$("#PackItmlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#PackItmlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {TestDesc:'',TestID:'',TestPackItmID:'',TestQty:'1'}
	});
    
	$("#PackItmlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
	
	dataArcGridBindEnterEvent(0);  //���ûس��¼�
}

///��������Ŀ�ײ���ϸ
function saveItmRow(){
	
	var rowsData = $("#Packlist").datagrid('getSelected');
	var PackID=rowsData.ATPRowID;
	if(editRow>="0"){
		$("#PackItmlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#PackItmlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}

	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].TestItemDesc==""){
			$.messager.alert("��ʾ","�����Ŀ����Ϊ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].TestPackItmID +"^"+ PackID +"^"+ rowsData[i].TestDesc +"^"+ rowsData[i].TestID +"^"+ rowsData[i].TestQty;
		dataList.push(tmp);
		
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCAPPTestPack","InsTesItm",{"params":params},function(jsonString){
		
		if (jsonString == "0"){
			$.messager.alert('��ʾ','����ɹ���');
		}
		if (jsonString == "-11"){
			$.messager.alert('��ʾ','�����Ŀ�����ظ���');
		}
		$('#PackItmlist').datagrid('reload'); //���¼���
	});
}
/// ɾ��
function deleteItmRow(){
	
	var rowsData = $("#PackItmlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPTestPack","DeleteTestPackItm",{"PackItmRowID":rowsData.TestPackItmID},function(jsonString){
					$('#PackItmlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ�ײ���ϸ
function findPackItemlist()
{
	var desc=$('#Itemdesc').val();
	$('#PackItmlist').datagrid('load',{ItemDesc:desc,TestPackID:TestPackID}); 
}

/// �������Ŀ,��λdatagrid�󶨻س��¼�
function dataArcGridBindEnterEvent(index){
	
	var editors = $('#PackItmlist').datagrid('getEditors', index);
	/// �����Ŀ����
	var workRateEditor = editors[0];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#PackItmlist").datagrid('getEditor',{index:index, field:'TestDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = ArcUrl + "&Input="+$(ed.target).val();
			/// ����ҽ�����б���
			new ListComponentWin($(ed.target), input, "550px", "" , unitUrl, ArcColumns, setCurrArcEditRowCellVal).init();
		}
	});
}

/// ����ǰ�༭�и�ֵ(�����Ŀ)
function setCurrArcEditRowCellVal(rowObj){
	
	if (rowObj == null){
		var editors = $('#PackItmlist').datagrid('getEditors', editRow);
		///�����Ŀ
		var workRateEditor = editors[0];
		workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
		return;
	}
	
	/// ��Ŀ����
	var ed=$("#PackItmlist").datagrid('getEditor',{index:editRow, field:'TestDesc'});
	$(ed.target).val(rowObj.itmDesc);
	/// ��Ŀ����ID
	var ed=$("#PackItmlist").datagrid('getEditor',{index:editRow, field:'TestID'});		
	$(ed.target).val(rowObj.itmID);
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
