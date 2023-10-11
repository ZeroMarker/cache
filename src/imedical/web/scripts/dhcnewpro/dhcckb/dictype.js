
/// date:      2021-09-01
/// descript:  ���״̬�ֵ�ά��

var editRow = ""; editDRow = ""; editPRow = "",hospData=[];
var hosp="";
/// ҳ���ʼ������
function initPageDefault(){
	
	// ��ʼ��ҽԺ
	init();
	
	///��ʼ�����������������б�
	InitCombobox()
	
	//��ʼ���ֵ������б�
	InitMainList();
	
	//��ʼ���ֵ���Ŀ�б�
	InitItemList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
	
	///��ʼ���ֵ������б�
	InitDetailList();
	
	///��ʼ����������
	InitTreeList();
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	$('#queryBTN').on("click",function(){
		$("#main").datagrid('reload',{params:hosp});
		$('#item').datagrid('reload',{mID:0});
		$("#detail").datagrid('reload',{mID:0});
	});
	$('#tab').tabs({ //hxy 2021-03-22 tab���ˢ������    
		 onSelect:function(title){    
		 		$('#item').datagrid('reload'); //���¼���
		 		$('#detail').datagrid('loadData', { total: 0, rows: [] }); //���¼���
				$("#tree").treegrid('reload'); //���¼���
		    }    
		}); 
	
}

function init(){
	runClassMethod("web.DHCEMConsultCom","JsonHosp",{},function(data){
		hospData=data;
		$("#_HospList").combobox({
			data:hospData,
			valueField:'value',
			textField:'text',
			onSelect:function(option){
				hosp = option.value
				$("#main").datagrid('reload',{params:hosp});
				$('#item').datagrid('reload',{mID:0});
				$("#detail").datagrid('reload',{mID:0});
			},
		})
		$("#_HospList").combobox("select",hospData[0].value);
		$("#HospArr").combobox({
			data: hospData, //HospArrN
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����	
		})
	});
}

///��ʼ�����������������б�
function InitCombobox(){
	var ActFlagArr = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
	
	$("#Active").combobox({
		data: ActFlagArr,
		valueField: "value",
		textField: "text",
		panelHeight:"auto",  //���������߶��Զ�����	
	})
	
	$("#ParList").combobox({
		//url:$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=QryEmConsItemArray",
		valueField: "value",
		textField: "text",
		panelHeight:200,  //���������߶��Զ�����	
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
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'����',width:300,editor:textEditor},
		{field:'Desc',title:'����',width:300,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'����',width:148,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'HospDesc',title:'ҽԺ',width:200,editor:HospEditor,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'�ֵ�����',
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
			/// �ֵ���Ŀ���б�
			$("#tree").treegrid('reload',{mID:rowData.ID});
			///�ֵ������б�
			$("#detail").datagrid('reload',{mID:0});
	    }
	};
	var uniturl = "dhcapp.broker.csp?ClassName=web.DHCPRESCDicType&MethodName=QryPrescDicType";
	new ListComponent('main', columns, uniturl, option).Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!",'info');
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!",'info'); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!",'info'); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCPRESCDicType","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
		$('#item').datagrid('reload'); //���¼���
		$("#tree").treegrid('reload');
		
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
	
	var HospDr=$("#_HospList").combobox("getValue")
	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:HospDr, HospDesc:''}
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
				runClassMethod("web.DHCPRESCDicType","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#main').datagrid('reload'); //���¼���
					$()
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
		{field:'Code',title:'����',width:300,editor:textEditor},
		{field:'Desc',title:'����',width:300,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'����',width:216,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'�ֵ���Ŀ',
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
	        console.log(rowData.ID);
	        var mID = rowData.ID;    
	        /// �ֵ���Ŀ�����б�
			$("#detail").datagrid('reload',{mID:mID});
	    }
	};
	
	var uniturl = "dhcapp.broker.csp?ClassName=web.DHCPrescDicItem&MethodName=QryPrescDicItem";
	new ListComponent('item', columns, uniturl, option).Init();

}

/// ����༭��
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}

	var rowsData = $("#item").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!",'info');
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!",'info'); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +"^"+ rowsData[i].mID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCPrescDicItem","save",{"mParam":mListData},function(jsonString){

		if (jsonString == "0"){
			$.messager.alert('��ʾ','����ɹ���','success');
				
		}else if ((jsonString == "-1")||((jsonString == "-3"))){
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
	var  titleStr="�ýڵ㲻�����ӽڵ㣬ȷ��ɾ����"
	var rowsData = $("#item").datagrid('getSelected'); //ѡ��Ҫɾ������
	var children=$("#tree").treegrid("getChildren",rowsData.ID);
	if(children.length>0){
		titleStr="�ýڵ㺬���ӽڵ㣬��һ��ɾ����ȷ��ɾ����"
		}
	IDStr=rowsData.ID;
	for(i=0;i<children.length;i++){
         IDStr=IDStr+"^"+children[i].ID
        }
	if (rowsData != null) {
		$.messager.confirm("��ʾ", titleStr, function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCPrescDicItem","treeDelete",{"IDStr":IDStr},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('��ʾ','������ʹ����Ŀ��������ɾ����','warning');
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

///��ʼ�������б�
function InitDetailList(){
	
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
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'ActCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'ActDesc'});
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
		{field:'Code',title:'����',width:300,editor:textEditor},
		{field:'Desc',title:'����',width:300,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'����',width:216,editor:activeEditor}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'�ֵ�����',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editPRow != "")||(editPRow == "0")) { 
                $("#detail").datagrid('endEdit', editPRow); 
            } 
            $("#detail").datagrid('beginEdit', rowIndex); 
            editPRow = rowIndex;
        }
	};
	
	var uniturl = "dhcapp.broker.csp?ClassName=web.DHCPrescDicItemProp&MethodName=QryPrescDicItemProp";
	new ListComponent('detail', columns, uniturl, option).Init();
}

/// ����༭��
function saveDetRow(){
	
	if(editPRow>="0"){
		$("#detail").datagrid('endEdit', editPRow);
	}

	var rowsData = $("#detail").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!",'info');
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!",'info'); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].mID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");
	console.log(mListData);
	//��������
	runClassMethod("web.DHCPrescDicItemProp","save",{"mParam":mListData},function(jsonString){

		if (jsonString == "0"){
			$.messager.alert('��ʾ','����ɹ���','success');
			
		}else if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#detail').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertDetRow(){
	
	var rowData = $("#item").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ֵ���Ŀ!",'info');
		return;
	}
	var ID = rowData.ID;           /// ����ĿID
	
	if(editPRow >= "0"){
		$("#detail").datagrid('endEdit', editPRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#detail").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#detail').datagrid('selectRow',0);
			$("#detail").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#detail").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {mID:ID, ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��'}
	});
	$("#detail").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editPRow=0;
}

/// ɾ��ѡ����
function deleteDetRow(){
	
	var rowsData = $("#detail").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCPrescDicItemProp","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#detail').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}



function InitTreeList(){
		/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:70,hidden:true},
		{field:'Code',title:'����',width:300},
		{field:'Desc',title:'����',width:300},
		{field:'ActDesc',title:'����',width:216}
	]];
	var uniturl = $URL+"?ClassName=web.DHCPrescDicItem&MethodName=QryPrescDicItem&mID=0&IsTreeGrid=1";
	//var uniturl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=QryEmConsItem&mID=0&IsTreeGrid=1";
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
//����
function treeItmSave(){
	
	var rowData = $("#main").treegrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ֵ�����!",'info');
		return;
	}
	var mID = rowData.ID;           /// ����ĿID
	var HospID = rowData.HospID;   /// ҽԺID
	var ID = $("#tID").val();
	var Code = $("#Code").val();
	var Desc = $("#Desc").val();
	var ParID = $("#ParList").combobox("getValue");
	var flag=$("#flag").val();
	if(ParID==0){
		ParID="";
	}
	var ActCode = $("#Active").combobox("getValue");
	if(ActCode==undefined){
		ActCode="";
	}
	if((Code=="")||(Desc=="")){
		$.messager.alert("��ʾ","�������������Ϊ��!",'info'); 
		return false;
	}
	if(flag==1){
		ID=""
		}
	
	var mListData=ID +"^"+ Code +"^"+ Desc +"^"+ ActCode +"^"+ HospID +"^"+ mID +"^"+ ParID;

	//��������
	runClassMethod("web.DHCPrescDicItem","treeItmSave",{"mParam":mListData},function(jsonString){

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
		$.messager.alert("��ʾ","����ѡ���ֵ�����!",'info');
		return;
	}
	
	var mID = rowData.ID;           /// �ֵ�����ID
	//var HospID = rowData.HospID;   /// ҽԺID
	var tID="";
	var treeRowData = $("#tree").treegrid("getSelected");
	if (treeRowData != null) {
		tID = treeRowData.ID;
	}
//	var ret=serverCall("web.DHCEMConsDicItem","isExOrEqual",{'tID':tID,'mID':mID}); //hxy 2020-08-13 st
//	if(ret=="-1"){
//		tID="";
//	}//ed
//	$("#tID").val("");
	loadTreePanelData(mID,tID,"","","",1);  ///��������������
	
	$("#treeOpPanel").window({
		title:"���ڵ�����",
	}).window('open');
	
	
}

/// ɾ��ѡ����
function deleteTreeRow(){
	var IDStr=""
	var titleStr="�ýڵ㲻�����ӽڵ㣬��ȷ��Ҫɾ���ýڵ���"
	var rowsData = $("#tree").treegrid('getSelected'); //ѡ��Ҫɾ������
	var children=$("#tree").treegrid("getChildren",rowsData.ID);
	if(children.length>0){
		titleStr="�ýڵ㺬���ӽڵ㣬��һ��ɾ����ȷ��ɾ����"
		}
	IDStr=rowsData.ID;
	for(i=0;i<children.length;i++){
         IDStr=IDStr+"^"+children[i].ID
        }
    
	if (rowsData != null) {
		$.messager.confirm("��ʾ", titleStr, function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCPrescDicItem","treeDelete",{"IDStr":IDStr},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('��ʾ','������ʹ����Ŀ��������ɾ����','warning');
					}else if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}else if (jsonString==0){ //hxy 2021-03-22
						$.messager.alert('��ʾ','ɾ���ɹ���','success');
					}
					$("#tree").treegrid('reload');
					$('#item').datagrid('reload'); //���¼��� hxy 2021-03-22 add st
					$('#detail').datagrid('reload'); //���¼��� ed
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
///�޸�ѡ�нڵ�
function updTreeRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ֵ�����!",'info');
		return;
	}
	var treeRowData = $("#tree").treegrid("getSelected");
	if (treeRowData == null) {
		$.messager.alert("��ʾ","����ѡ��һ������!",'info');
		return;
	}

	var mID = rowData.ID;           /// ����ĿID
	var tID = treeRowData.ID;
	var HospID = rowData.HospID;   /// ҽԺID
	var Code = treeRowData.Code;
	var Desc = treeRowData.Desc;
	var ParID = treeRowData._parentId;
	var ActCode=treeRowData.ActCode //hxy 2020-08-12
//	var ret=serverCall("web.DHCEMConsDicItem","isExCsID",{'tID':tID}); //hxy 2020-08-12 st
//	if(ret=="-1"){
//		$.messager.alert("��ʾ","����ѡ��һ������!");
//		return;
//	}//ed
	
	$("#tID").val(tID);
	
	loadTreePanelData(mID,ParID,Code,Desc,ActCode,"");  ///��������������� //hxy 2020-08-12 add ActCode   
	
	$("#treeOpPanel").window({
		title:"�޸�",
	}).window('open');
	
}
///��������������
function loadTreePanelData(mID,tID,code,desc,ActCode,flag){
	$("#Code").val(code);
	$("#Desc").val(desc);
	$("#flag").val(flag);  //���ӱ�־λ���ж����ӻ����޸�
	var url = $URL+"?ClassName=web.DHCPrescDicItem&MethodName=QryPrescDicItemArray&mID="+mID;
	$("#ParList").combobox("reload",url);
	$("#ParList").combobox("setValue",tID);
	$("#Active").combobox("setValue",ActCode); //"Y" //hxy 2020-08-12 change ActCode
	if(code==""){ //hxy 2020-08-13 ����Ĭ��Y
		$("#Active").combobox("setValue","Y")
	}
	
	$("#tree").treegrid('reload',{mID:mID});
}
/// ���� 2021-06-25
function copyRow(){
	var rowsData = $("#main").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���ֵ�����!",'info');
		return;	
	}
	$('#copyWin').dialog("open");
}

/// ���渴�� 2021-06-25
function saveCopy(){
	var rowsData = $("#main").datagrid('getSelected');
	var HospDr=$HUI.combobox("#HospArr").getValue();
	if((HospDr=="")||(HospDr==undefined)){
		$.messager.alert("��ʾ","��ѡ��ҽԺ!",'info');
		return;	
	}
	runClassMethod("web.DHCPrescDicItem","SaveCopy",{"ID":rowsData.ID,"Code":rowsData.Code,"Hosp":HospDr},function(jsonString){
		if (jsonString == -1){
			$.messager.alert('��ʾ','���ֵ��������У����踴�ƣ�','warning');
		}else if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}else if (jsonString==0){ 
			$.messager.alert('��ʾ','���Ƴɹ���','success');
			$('#copyWin').dialog("close");
		}
	})
	
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
