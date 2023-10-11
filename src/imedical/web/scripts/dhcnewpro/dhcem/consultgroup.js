/// author:    bianshuai
/// date:      2018-06-20
/// descript:  ��������MDTС���ֵ�ά��

var editRow = ""; editDRow = "";
TypeCode="";
var TypeFlagArr = [{"value":"NUR","text":'��ʿר����'}, {"value":"DOC","text":'ҽʦ���'}]; //hxy 2021-06-18
/// ҳ���ʼ������
function initPageDefault(){
	//��ʼ��ҽԺ hxy 2020-05-28
	InitHosp();
	
	//��ʼ����ѯ��Ϣ�б�
	InitMainList();
	
	//��ʼ����ѯ��Ϣ�б�
	InitItemList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
}

function InitHosp(){
	hospComp = GenHospComp("DHC_EmConsultGroup");  //hxy 2020-05-12 st
	hospComp.options().onSelect = function(){///ѡ���¼�
		query();
	}//ed
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	
}

///��ʼ�������б�
function InitMainList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var ActFlagArr = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
	//������Ϊ�ɱ༭
	var activeEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActDesc'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
			}
		}
	}
	
	/// ҽԺ
	var HospEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
		
	// ���ҳ�Ա
	var TLeaderEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonUser",
			url: "",
			valueField: "value", 
			textField: "text",
			//editable:false,
			mode:'remote',
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeaderID'});
				$(ed.target).val(option.value);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeader'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'Type'}); //hxy 2021-06-28 st
				var Type=$(ed.target).val();
				if(Type==""){
					$.messager.alert("��ʾ","��ѡ������!");
					return;
				} //ed

				///���ü���ָ��
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeader'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonUser&HospID="+hospComp.getValue()+"&Type="+Type; //hxy 2020-05-28 &HospID="+hospComp.getValue()
				$(ed.target).combobox('reload',unitUrl);
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeaderID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	//����������Ϊ�ɱ༭ //hxy 2021-06-18
	var typeEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			required: true,
			data: TypeFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			editable:false,
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TypeDesc'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
				
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeaderID'});
				$(ed.target).val("");
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeader'});
				$(ed.target).combobox('setValue', "");
			}
		}
	}

	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'left'}, //hxy 2020-04-30 �����
		{field:'Code',title:'����',width:100,editor:textEditor,align:'left'},
		{field:'Desc',title:'����',width:140,editor:textEditor,align:'left'},
		{field:'Type',title:'����',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'TypeDesc',title:'����',width:110,editor:typeEditor,align:'left'},
		{field:'TLeaderID',title:'TLeaderID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'TLeader',title:'�鳤',width:100,editor:TLeaderEditor,align:'left'},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'ActDesc',title:'�Ƿ����',width:80,editor:activeEditor,align:'left'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'HospDesc',title:'ҽԺ',width:200,editor:HospEditor,align:'left',hidden:true} //hxy 2020-05-28 hidden
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'���������ά��-ר����/���', //hxy 2020-04-30 st
		headerCls:'panel-header-gray', 
		border:true,
		iconCls:'icon-paper',//ed
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
	    	//ע��Ҫ�ڿ����б༭֮**ǰ**�������editorΪ�յĲ��� 2021-06-21
	    	var ee = $('#main').datagrid('getColumnOption', 'TypeDesc');
	    	if(rowData.ID!=""){			
				ee.editor={};    
	        }else{
				ee.editor=typeEditor;
		    }
	    	
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        TypeCode=rowData.Type;
	        /// MDTС���Ա�б�
			var uniturl = $URL+"?ClassName=web.DHCEMConsultGroup&MethodName=QryConsultGroupItm&ID="+rowData.ID;
			$("#item").datagrid({url:uniturl});
			if(rowData.Type=="DOC"){ //hxy 2021-06-18
				$('#item').datagrid('hideColumn', 'User');
				$('#item').datagrid('hideColumn', 'ContactsFlag');
				$('#item').datagrid('hideColumn', 'DefFlag');
			}else{
				$('#item').datagrid('showColumn', 'User');
				$('#item').datagrid('showColumn', 'ContactsFlag');
				$('#item').datagrid('showColumn', 'DefFlag');
				
			}
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsultGroup&MethodName=QryConsultGroup&params="+hospComp.getValue();
	new ListComponent('main', columns, uniturl, option).Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}
		if((rowsData[i].Type=="DOC")&&(rowsData[i].TLeaderID=="")){ //hxy 2021-06-18
			$.messager.alert("��ʾ","ҽʦ�����ѡ���鳤!"); 
			return false;
		}
		
		var TLeaderID=rowsData[i].TLeaderID; //hxy 2020-09-22 st
		if(rowsData[i].TLeader==""){
			TLeaderID="";
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +"^"+ TLeaderID +"^"+ rowsData[i].Type; //hxy 2020-09-22 rowsData[i]. //ed
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsultGroup","Save",{"mListData":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
		$('#item').datagrid('loadData',{total:0,rows:[]}); //hxy 2021-06-21
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	var HospDr=hospComp.getValue(); //hxy 2020-05-28
	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:HospDr, HospDesc:'',TypeDesc:''} //hxy 2020-05-28 HospID:''
	});
	
	//ע��Ҫ�ڿ����б༭֮**ǰ**�������editorΪ�յĲ��� 2021-06-21
	var ee = $('#main').datagrid('getColumnOption', 'TypeDesc');
	ee.editor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			required: true,
			data: TypeFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			editable:false,
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TypeDesc'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
				
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeaderID'});
				$(ed.target).val("");
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'TLeader'});
				$(ed.target).combobox('setValue', "");
			}
		}
	};
	
	$("#main").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsultGroup","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('��ʾ','�����Ѻ�ҽ�����,����ɾ����','warning');
					}
					$('#main').datagrid('reload'); //���¼���
					$('#item').datagrid('loadData',{total:0,rows:[]}); //hxy 2021-06-21
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

///��ʼ�������б�
function InitItemList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}

	// ���ұ༭��
	var LocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			//url: $URL +"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+session['LOGON.HOSPID'], //hxy 2020-05-28 ע��
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocID'});
				$(ed.target).val(option.value);
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'UserID'});
				$(ed.target).val("");
				/*
				///���ü���ָ��
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocUser&LocID="+ option.value;
				$(ed.target).combobox('reload',unitUrl);
				*/
			},
			onShowPanel:function(){ //hxy 2020-06-04
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocDesc'});
				//var unitUrl=$URL +"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+hospComp.getValue();
				var LType="CONSULTWARD"; //hxy 2021-06-10 st
				var rowData = $("#main").datagrid("getSelected");
				if(rowData.Type=="DOC"){
					LType="CONSULT";
				}
				var unitUrl=$URL +"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&HospID="+hospComp.getValue()+"&LType="+LType; //hxy 2020-09-21 //ed
				//var unitUrl=$URL +"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&HospID="+hospComp.getValue()+"&LType=CONSULTWARD"; //hxy 2020-09-21 //ed
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	// ���ҳ�Ա
	var UserEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonUser",
			url: "",
			valueField: "value", 
			textField: "text",
			//required: true, //hxy 2020-09-23
			//editable:false,
			mode:'remote',
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocUser&LocID="+ LocID +"&Type=NURSE"+"&HospID="+hospComp.getValue();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	var TempArr = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
	//������Ϊ�ɱ༭
	var ContractEditor ={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: TempArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'ContactsID'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'ContactsFlag'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
			}
		}
	}
	
	//������Ϊ�ɱ༭
	var DefEditor ={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: TempArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'DefFlagID'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'DefFlag'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'left'}, //hxy 2020-04-30 �����
		{field:'MasID',title:'MasID',width:100,hidden:true,align:'left'},
		{field:'LocID',title:'LocID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'LocDesc',title:'����',width:220,editor:LocEditor,align:'left'},
		{field:'UserID',title:'UserID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'User',title:'��Ա',width:140,editor:UserEditor,align:'left'},
		{field:'ContactsID',title:'ContactsID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'ContactsFlag',title:'�����˱�־',width:100,editor:ContractEditor,align:'left'},
		{field:'DefFlagID',title:'DefFlagID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'DefFlag',title:'Ĭ�ϱ�־',width:100,editor:DefEditor,align:'left'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'ר�����Ա����/��ƿ���', //hxy 2020-04-30 st
		headerCls:'panel-header-gray', 
		border:true,
		iconCls:'icon-paper',//ed
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editDRow != "")||(editDRow == "0")) { 
                $("#item").datagrid('endEdit', editDRow); 
            } 
            $("#item").datagrid('beginEdit', rowIndex); 
            editDRow = rowIndex;
        }
	};
	
	var uniturl = ""; //$URL+"?ClassName=web.DHCEMConsultGroup&MethodName=QryConsultGroupItm";
	new ListComponent('item', columns, uniturl, option).Init();

}

/// ����༭��
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}

	var rowsData = $("#item").datagrid('getChanges');
	var allRowData = $("#item").datagrid('getData').rows;
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	/*var allHasUserID="";
	for(var i=0;i<allRowData.length;i++){		///�ж��ظ���Ա
		if((allRowData[i].UserID!="")&&(allHasUserID.indexOf("^"+allRowData[i].UserID+"^")!=-1)){
			$.messager.alert("��ʾ","�����ظ�����Ա��Ϣ���ظ���Ա��"+allRowData[i].User); 
			return false;	
		}
		allHasUserID==""?allHasUserID="^"+allRowData[i].UserID+"^":allHasUserID=allRowData[i].UserID+"^";
	}*/
	
	var  dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].LocID==""){
			$.messager.alert("��ʾ","���Ҳ���Ϊ��!"); 
			return false;
		}
		if((rowsData[i].UserID=="")&&(TypeCode=="NUR")){
			$.messager.alert("��ʾ","��Ա����Ϊ��!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].MasID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].UserID +"^"+ rowsData[i].ContactsID +"^"+ rowsData[i].DefFlagID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsultGroup","SaveItem",{"mListData":mListData},function(jsonString){
		
		if (jsonString == "-1"){ //hxy 2020-08-11
			$.messager.alert('��ʾ','��Ա�ظ�,���ʵ�����ԣ�','warning');
			return;	
		}
		if (jsonString == "-2"){ //hxy 2021-06-18
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#item').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertItmRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ��ר��С��!");
		return;
	}
	var ID = rowData.ID;   /// MDTС��ID
	
	if(editDRow >= "0"){
		$("#item").datagrid('endEdit', editDRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#item").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#item').datagrid('selectRow',0);
			$("#item").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#item").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {MasID:ID, ID:'', LocID:'', LocDesc:'', UserID:'', User:'', ContactsID:'', ContactsFlag:''}
	});
	$("#item").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editDRow=0;
}

/// ɾ��ѡ����
function deleteItmRow(){
	
	var rowsData = $("#item").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsultGroup","deleteItem",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('��ʾ','�����Ѻ�ҽ�����,����ɾ����','warning');
					}
					$('#item').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

function query(){
	var HospDr=hospComp.getValue();
	var Type = $HUI.combobox("#typeBox").getValue(); //hxy 2021-06-18
	$("#main").datagrid( { 
		url:$URL+"?ClassName=web.DHCEMConsultGroup&MethodName=QryConsultGroup&params="+HospDr+"^"+Type
	})
	$('#item').datagrid('loadData',{total:0,rows:[]});
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })