/** sufan 
  * 2018-04-09
  *
  * ���ͷ�����ά��
 */
var editRow = ""; 
var editsubRow="";
var dataArray = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
/// ҳ���ʼ������
function initPageDefault(){

	initSerGrolist();       	/// ��ʼҳ��DataGrid�Ű��
	initGroLinklist();			/// �������������
	initButton();           	/// ҳ��Button���¼�	
}
///�������б� 
function initSerGrolist(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var Hospeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#sergrolist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#sergrolist").datagrid('getEditor',{index:editRow,field:'SergHosp'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	var Flageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#sergrolist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
				$(ed.target).combobox('setValue', option.value);  //�����Ƿ����
			} 
		}

	}

	// ����columns
	var columns=[[
		{field:"SergCode",title:'����',width:150,align:'center',editor:textEditor},
		{field:"SergDesc",title:'����',width:150,align:'center',editor:textEditor},
		{field:"SergFlag",title:'�Ƿ����',width:150,align:'center',editor:Flageditor},
		{field:"FlagCode",title:'FlagCode',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"HospDesc",title:'���Ż�ҽԺ',width:180,align:'center',editor:Hospeditor},
		{field:"SergHosp",title:'SergHosp',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"SergId",title:'ID',width:20,hidden:true}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) { 
                $("#sergrolist").datagrid('endEdit', editRow); 
            } 
            $("#sergrolist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
           $('#groliklist').datagrid('reload',{SerGroId:rowData.SergId});
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDIDServiceGroupLink&MethodName=QuerySerGro";
	new ListComponent('sergrolist', columns, uniturl, option).Init(); 
}

///�����б� 
function initGroLinklist(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	var Loceditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo",
			//required:true,
			panelHeight:"400",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#groliklist").datagrid('getEditor',{index:editsubRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#groliklist").datagrid('getEditor',{index:editsubRow,field:'SgllLocId'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"SerGroId",title:'SerGroId',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"SerGroDesc",title:'����',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"SgllLocId",title:'SgllLocId',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"LocDesc",title:'��������',width:200,align:'center',editor:Loceditor},
		{field:"SgllId",title:'ID',width:20,hidden:true}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editsubRow != "")||(editsubRow == "0")) { 
                $("#groliklist").datagrid('endEdit', editsubRow); 
            } 
            $("#groliklist").datagrid('beginEdit', rowIndex); 
            
            editsubRow = rowIndex; 
        },
        onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
           //$('#shiftlist').datagrid('reload',{params:"",LastRowId:rowData.SchtId});
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDIDServiceGroupLink&MethodName=QuerySgllLoc";
	new ListComponent('groliklist', columns, uniturl, option).Init(); 
}


/// ҳ�� Button ���¼�
function initButton(){
	
	///  �����Ű�����
	$('#insert').bind("click",insertRow);
	
	///  �����Ű�����
	$('#save').bind("click",saveRow);
	
	///  ɾ���Ű�����
	$('#delete').bind("click",delRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findSchelist(); //���ò�ѯ
        }
    });
    
     // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findSerglist(); //���ò�ѯ
    });
    
    //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findSerglist(); //���ò�ѯ
    }); 
    
    ///  ���Ӱ��
	$('#subinsert').bind("click",insertsubRow);
	
	///  ������
	$('#subsave').bind("click",savesubRow);
	
	///  ɾ�����
	$('#subdelete').bind("click",delsubRow);
	
	
}

/// �������ͷ�����
function insertRow(){

	if(editRow>="0"){
		$("#sergrolist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#sergrolist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {SergId: '',SergCode:'',SergDesc: '',SergFlag:'Y',FlagCode:'Y',HospDesc:LgHospID,SergHosp:LgHospID}
	});
    
	$("#sergrolist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///�����Ű�����
function saveRow(){
	
	if(editRow>="0"){
		$("#sergrolist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#sergrolist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SergCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].SergDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].FlagCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�п��ñ�ʶΪ�գ�"); 
			return false;
		}
		if(rowsData[i].SergHosp==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"��ҽԺ��ϢΪ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].SergId +"^"+ rowsData[i].SergCode +"^"+ rowsData[i].SergDesc +"^"+ rowsData[i].FlagCode +"^"+ rowsData[i].SergHosp;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCDIDServiceGroupLink","SaveSerGro",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#sergrolist').datagrid('reload');  //���¼���
	});
}

/// ɾ��
function delRow(){
	
	var rowsData = $("#sergrolist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDIDServiceGroupLink","DelSerGro",{"SergRowId":rowsData.SergId},function(jsonString){
					
					$('#sergrolist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
///===================================================��������ά��========================================================
/// ������
function insertsubRow(){
	var rowData = $("#sergrolist").datagrid('getSelected');
	if(rowData==null){
		$.messager.alert("��ʾ","����ѡ�����飡");
		return;
	}
	var SergId=rowData.SergId;
	if(editsubRow>="0"){
		$("#groliklist").datagrid('endEdit', editsubRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#groliklist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {SgllId: '',SerGroId:SergId,SerGroDesc: '',SgllLocId:'',LocDesc:''}
	});
    
	$("#groliklist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editsubRow=0;
}
///�����Ű�����
function savesubRow(){
	
	
	if(editsubRow>="0"){
		$("#groliklist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#groliklist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SgllLocId==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�п���Ϊ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].SgllId +"^"+ rowsData[i].SerGroId +"^"+ rowsData[i].SgllLocId ;
		dataList.push(tmp);
	} 
	
	var params=dataList.join("&&");
	
	//��������
	runClassMethod("web.DHCDIDServiceGroupLink","SaveSerLoc",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#groliklist').datagrid('reload');  //���¼���
	});
}

/// ɾ��
function delsubRow(){
	
	var rowsData = $("#groliklist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDIDServiceGroupLink","DelSerLoc",{"SgllRowId":rowsData.SgllId},function(jsonString){
					
					$('#groliklist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ��ѯ
function findSerglist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#sergrolist').datagrid('load',{params:params}); 
}	 
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
