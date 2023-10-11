/// author:    bianshuai
/// date:      2019-04-16
/// descript:  MDT��������ֵ�ά��

var editRow = ""; editDRow = ""; editPRow = "";
/// ҳ���ʼ������
function initPageDefault(){
	
	init(); //ylp ��ʼ��ҽԺ //20230222
	InitCombobox();
	
	//��ʼ���ֵ������б�
	InitMainList();
	
	//��ʼ���ֵ���Ŀ�б�
	InitItemList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
	
	///��ʼ�����Դ洢�б�
	InitTreeList();
}
function init(){
	
	hospComp = GenHospComp("DHC_EmConsDicType");  //hxy 2020-05-27 st //2020-05-31 add
	hospComp.options().onSelect = function(){///ѡ���¼�
		$("#main").datagrid('reload',{params:hospComp.getValue()});
	}

	$('#queryBTN').on('click',function(){
		$("#main").datagrid('reload',{params:hospComp.getValue()});
	 })
		
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	
}

function InitCombobox(){
	var ActFlagArr = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
	
	$("#Active").combobox({
		data: ActFlagArr,
		valueField: "value",
		textField: "text",
		panelHeight:"auto",  //���������߶��Զ�����	
	})
	
	$("#ParList").combobox({
		url:$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=QryEmConsItemArray"+"&MWToken="+websys_getMWToken(),
		valueField: "value",
		textField: "text",
		panelHeight:"auto",  //���������߶��Զ�����	
	})
}

///��ʼ���ֵ������б�
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
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetHospDs"+"&MWToken="+websys_getMWToken(),
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
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'����',width:200,editor:textEditor},
		{field:'Desc',title:'����',width:200,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'����',width:140,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'HospDesc',title:'ҽԺ',width:200,editor:HospEditor,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'MDT�����ֵ�ά��-�ֵ�����',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        	        
	        /// �ֵ���Ŀ�б�
			$("#item").datagrid('reload',{mID:rowData.ID});
			
			/// ���б�
			$("#tree").treegrid('reload',{mID:rowData.ID});
			
			if(isTreeData()){
				$HUI.tabs("#tabs").select("��������");
			}else{
				$HUI.tabs("#tabs").select("��Ŀ����");
			}
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTDicType&MethodName=QryDicType"+"&params="+hospComp.getValue()+"&MWToken="+websys_getMWToken();
	new ListComponent('main', columns, uniturl, option).Init();

}

function isTreeData(){
	var rowsData = $("#main").treegrid('getSelected');
	var desc = rowsData.Desc;
	var ret=false;
	desc.indexOf("(��)")!=-1?ret=true:"";
	return ret;
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
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTDicType","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
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
	
	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:hospComp.getValue(), HospDesc:''}
	});
	$("#main").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTDicType","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#main').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

///��ʼ���ֵ���Ŀ�б�
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
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'ActCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'ActDesc'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'mID',title:'mID',width:100,hidden:true},
		{field:'Code',title:'����',width:100,editor:textEditor},
		{field:'Desc',title:'����',width:500,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'����',width:80,editor:activeEditor,align:'center'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		//title:'�ֵ���Ŀ',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editDRow != "")||(editDRow == "0")) { 
                $("#item").datagrid('endEdit', editDRow); 
            } 
            $("#item").datagrid('beginEdit', rowIndex); 
            editDRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        	        
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTDicItem&MethodName=QryDicItem&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('item', columns, uniturl, option).Init();

}

/// ����༭��
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}

	var rowsData = $("#item").datagrid('getChanges');
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
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +"^"+ rowsData[i].mID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTDicItem","save",{"mParam":mListData},function(jsonString){

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
		$.messager.alert("��ʾ","����ѡ���ֵ�����!");
		return;
	}
	var ID = rowData.ID;           /// ����ĿID
	var HospID = rowData.HospID;   /// ҽԺID
	
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
		row: {mID:ID, ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:HospID}
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
				runClassMethod("web.DHCMDTDicItem","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('��ʾ','����Ŀ��ʹ�ã�������ɾ����','warning');
					}else if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
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

///��ʼ�����Դ洢�б�
function InitTreeList(){
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:70,hidden:tree,align:'center'},
		{field:'Code',title:'����',width:140},
		{field:'Desc',title:'����',width:200},
		{field:'Url',title:'����',width:200},
		{field:'ActDesc',title:'����',width:100}
	]];
	
	/**
	 * ����dtreegrid
	 */
	 
	var uniturl = $URL+"?ClassName=web.DHCMDTDicItem&MethodName=QryDicItem&mID=0&IsTreeGrid=1"+"&MWToken="+websys_getMWToken();
	$('#tree').treegrid({
		url:uniturl,
		idField:'ID',
		treeField:'Code',
		fit:true,
		border:false,
		columns:columns,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            
        },
        onClickRow:function(rowIndex, rowData){       
	       
	    }
	});
}

function treeItmSave(){
	
	var rowData = $("#main").treegrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ֵ�����!");
		return;
	}
	var mID = rowData.ID;           /// ����ĿID
	var HospID = rowData.HospID;   /// ҽԺID
	var ID = $("#tID").val();
	var Code = $("#Code").val();
	var Desc = $("#Desc").val();
	var Url = $("#Url").val();
	var ParID = $("#ParList").combobox("getValue");
	if(ParID==undefined){
		ParID="";
	}
	var ActCode = $("#Active").combobox("getValue");
	if(ActCode==undefined){
		ActCode="";
	}
	if((Code=="")||(Desc=="")){
		$.messager.alert("��ʾ","�������������Ϊ��!"); 
		return false;
	}
	
	
	var mListData=ID +"^"+ Code +"^"+ Desc +"^"+ ActCode +"^"+ HospID +"^"+ mID +"^"+ ParID +"^"+ Url;

	//��������
	runClassMethod("web.DHCMDTDicItem","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		
		
		$("#treeOpPanel").window('close');
		$("#tree").treegrid('reload',{mID:mID});
	})
}

/// ��������
function insertTreeRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ֵ�����!");
		return;
	}
	
	var mID = rowData.ID;           /// ����ĿID
	var HospID = rowData.HospID;   /// ҽԺID
	var tID="";
	var treeRowData = $("#tree").treegrid("getSelected");
	if (treeRowData != null) {
		tID = treeRowData.ID;
	}
	$("#tID").val("");
	loadTreePanelData(mID,tID,"","");  ///���������������
	
	$("#treeOpPanel").window({
		title:"����",
	}).window('open');
	
}

/// �޸�
function updTreeRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ֵ�����!");
		return;
	}
	var treeRowData = $("#tree").treegrid("getSelected");
	if (treeRowData == null) {
		$.messager.alert("��ʾ","����ѡ��һ������!");
		return;
	}

	var mID = rowData.ID;           /// ����ĿID
	var tID = treeRowData.ID;
	var HospID = rowData.HospID;   /// ҽԺID
	var Code = treeRowData.Code;
	var Desc = treeRowData.Desc;
	var Url = treeRowData.Url;
	var ParID = treeRowData._parentId;
	
	if (ParID == "") {
		$.messager.alert("��ʾ","��ǰ�ڵ�Ϊ���ڵ㣬�����޸�!");
		return;
	}
	
	$("#tID").val(tID);
	
	loadTreePanelData(mID,ParID,Code,Desc,Url);  ///���������������
	
	$("#treeOpPanel").window({
		title:"�޸�",
	}).window('open');
	
}

function loadTreePanelData(mID,tID,code,desc,url){
	$("#Code").val(code);
	$("#Desc").val(desc);
	$("#Url").val(url);
	var url = $URL+"?ClassName=web.DHCMDTDicItem&MethodName=QryEmConsItemArray&mID="+mID+"&tID=";
	$("#ParList").combobox("reload",url);
	$("#ParList").combobox("setValue",tID);
	$("#Active").combobox("setValue","Y");
	
	$("#tree").treegrid('reload',{mID:mID});
}

/// ɾ��ѡ����
function deleteTreeRow(){
	
	var rowsData = $("#tree").treegrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTDicItem","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('��ʾ','����Ŀ��ʹ�ã�������ɾ����','warning');
					}else if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$("#tree").treegrid('reload');
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

function getTreeGridId(){
	addLine++;
	return "nodeId"+addLine;
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })