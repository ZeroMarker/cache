/// author:    bianshuai
/// date:      2018-06-20
/// descript:  ���������ֵ�ά��

var editRow = ""; editDRow = ""; editPRow = "",editRowT="";
var addLine=0;
/// ҳ���ʼ������
function initPageDefault(){
	
	init(); //hxy 2020-05-27 ��ʼ��ҽԺ //2020-05-31 add
	
	InitCombobox();
	
	//��ʼ���ֵ������б�
	InitMainList();
	
	//��ʼ���ֵ���Ŀ�б�
	InitItemList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
	
	///��ʼ���ֵ������б�
	InitDetailList();
	
	///��ʼ�����Դ洢�б�
	InitTreeList();
}

function init(){
	hospComp = GenHospComp("DHC_EmConsDicType");  //hxy 2020-05-27 st //2020-05-31 add
	hospComp.options().onSelect = function(){///ѡ���¼�
		$("#main").datagrid('reload',{params:hospComp.getValue()});
	}//ed
		
	hospComp.options().onLoadSuccess=function(data){ //hxy 2021-06-25
		var HospArr=data.rows;
		/*HospArrN=[];
		var j=0;
		//var HospArr=[{HOSPRowId: "2", HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"}, {HOSPRowId: "3", HOSPDesc: "������׼�����ֻ���ǻҽԺ"}];
		for (var i = 0; i < HospArr.length; i++) {
            if (HospArr[i].HOSPRowId!=LgHospID) {
				HospArrN[j]=HospArr[i];
				j++;
            }
        }*/
		$("#HospArr").combobox({
			data: HospArr, //HospArrN
			valueField: "HOSPRowId",
			textField: "HOSPDesc",
			panelHeight:"auto",  //���������߶��Զ�����	
		})
	}
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
		url:$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=QryEmConsItemArray",
		valueField: "value",
		textField: "text",
		panelHeight:"260",  //���������߶��Զ�����	
	})

}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	/*$('#hospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto',
		onSelect:function(option){ //hxy 2021-05-06 st
			query();
	    },
	    onLoadSuccess:function(data){
		    $HUI.combobox("#hospDrID").setValue(LgHospID);
		    $("#main").datagrid('reload',{params:LgHospID});
	    } //ed
	 }) */ //hxy 2020-05-27 ע�� //2020-05-31 add
	 $('#queryBTN').on('click',function(){
		 query();
		 /*$("#main").datagrid('reload',{params:$('#hospDrID').combobox('getValue')});
		 $('#detail').datagrid('loadData', { total: 0, rows: [] }); //hxy 2021-03-22 st
		 $('#item').datagrid('loadData', { total: 0, rows: [] });
		 $('#tree').treegrid('loadData', { total: 0, rows: [] }); //ed*/
	 }) //hxy ed
	 
	 $('#tab').tabs({ //hxy 2021-03-22 tab���ˢ������    
		    onSelect:function(title){    
		 		$('#item').datagrid('reload'); //���¼���
		 		$('#detail').datagrid('loadData', { total: 0, rows: [] }); //���¼���
				$("#tree").treegrid('reload'); //���¼���
		    }    
		});  
	
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
			url:$URL+"?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs",
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
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'Code',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'Desc',title:'����',width:290,editor:textEditor,align:'center'},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActDesc',title:'����',width:80,editor:activeEditor,align:'center'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'HospDesc',title:'ҽԺ',width:200,editor:HospEditor,align:'center',hidden:true} //hxy 2020-05-27 hidden //2020-05-31 add
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
			/// �ֵ������б�
			$('#detail').datagrid('loadData', { total: 0, rows: [] });
	    }
	};
	
	//var uniturl = $URL+"?ClassName=web.DHCEMConsDicType&MethodName=QryEmConsType";
	var uniturl = $URL+"?ClassName=web.DHCEMConsDicType&MethodName=QryEmConsType&params="+hospComp.getValue(); //hxy 2020-05-27 &params="+hospComp.getValue(); //2020-05-31 add
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
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code.trim() +"^"+ rowsData[i].Desc.trim() +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID; //hxy 2021-03-29 Add .trim()
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsDicType","save",{"mParam":mListData},function(jsonString){

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
	
	var HospDr=hospComp.getValue(); //hxy 2020-05-27 //2020-05-31 add
	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:HospDr, HospDesc:''} //hxy 2020-05-27 ԭ��HospID:'' //2020-05-31 add
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
				runClassMethod("web.DHCEMConsDicType","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){ //hxy 2021-04-13
						$.messager.alert('��ʾ','������ʹ����Ŀ��������ɾ����','warning');
					}else if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					if (jsonString==0){ //hxy 2021-03-22
						$.messager.alert('��ʾ','ɾ���ɹ���','success');
						$('#detail').datagrid('loadData', { total: 0, rows: [] }); //hxy 2021-04-13 st
						$('#item').datagrid('loadData', { total: 0, rows: [] });
						$('#tree').treegrid('loadData', { total: 0, rows: [] }); //ed
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
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'mID',title:'mID',width:100,hidden:true,align:'center'},
		{field:'Code',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'Desc',title:'����',width:400,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActDesc',title:'����',width:80,editor:activeEditor,align:'center'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'center'}
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
	        	        
	        /// �ֵ���Ŀ�����б�
			$("#detail").datagrid('reload',{mID:rowData.ID});
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=QryEmConsItem&mID=0";
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
		var _parentId = rowsData[i]._parentId==undefined?"":rowsData[i]._parentId;
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +"^"+ rowsData[i].mID+"^"+_parentId; //hxy 2021-04-14 ��Ŀ��������-�ֵ���Ŀ-�޸����ݽ�par�ÿ����޸� add _parentId
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsDicItem","save",{"mParam":mListData},function(jsonString){

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
	
	if(ID==""){ //hxy 2022-09-27
		$.messager.alert("��ʾ","��ѡ����Ч���ֵ�����!");
		return;
	}
	
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
	var IfHaveProp=serverCall("web.DHCEMConsDicItem", "IfHaveProp", {mID:rowsData.ID}); //hxy 2021-04-03
	var Tip="";
	if(IfHaveProp==1){Tip="�����ֵ�����";}
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ�����ֵ���Ŀ"+Tip+"��", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsDicItem","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('��ʾ','����Ŀ��ʹ�ã�������ɾ����','warning');
					}else if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}else if (jsonString==0){ //hxy 2021-03-22
						$.messager.alert('��ʾ','ɾ���ɹ���','success');
					}
					$('#item').datagrid('reload'); //���¼���
					$('#detail').datagrid('reload'); //���¼��� hxy 2021-03-22 add st
					$("#tree").treegrid('reload'); //���¼��� ed
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
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'mID',title:'mID',width:100,hidden:true,align:'center'},
		{field:'Code',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'Desc',title:'����',width:400,editor:textEditor},
		{field:'Value',title:'����',width:100,editor:textEditor}, //hxy 2021-05-08
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActDesc',title:'����',width:80,editor:activeEditor,align:'center'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'center'}
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
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsItemProp&MethodName=QryEmConsItem&mID=0";
	new ListComponent('detail', columns, uniturl, option).Init();
}

/// ����༭��
function saveDetRow(){
	
	if(editPRow>="0"){
		$("#detail").datagrid('endEdit', editPRow);
	}

	var rowsData = $("#detail").datagrid('getChanges');
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
		if((rowsData[i].Code=="DEFOPENACCHOUR")&&(!(/(^[1-9]\d*$)/.test(rowsData[i].Value)))){ //hxy 2021-03-15 ����������ά��Ĭ�Ͽ���������ȨСʱ��ά�����������뿪����Ȩ����һ��//2021-05-08 Desc->Value
			$.messager.alert("��ʾ","���� DEFOPENACCHOUR ��������ά����������"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +"^"+ rowsData[i].mID +"^"+rowsData[i].Value;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsItemProp","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
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
		$.messager.alert("��ʾ","����ѡ���ֵ���Ŀ!");
		return;
	}
	var ID = rowData.ID;           /// ����ĿID
	var HospID = rowData.HospID;   /// ҽԺID
	
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
		row: {mID:ID, ID:'', Code:'', Desc:'', Value:'',ActCode:'Y', ActDesc:'��', HospID:HospID}
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
				runClassMethod("web.DHCEMConsItemProp","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					if (jsonString==0){ //hxy 2021-03-22
						$.messager.alert('��ʾ','ɾ���ɹ���','success');
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

///��ʼ�����Դ洢�б�
function InitTreeList(){
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:70,hidden:tree,align:'center'},
		{field:'Code',title:'����',width:200,align:'center'},
		{field:'Desc',title:'����',width:300,align:'center'},
		{field:'ActDesc',title:'����',width:80,align:'center'}
	]];
	
	/**
	 * ����dtreegrid
	 */
	 
	var uniturl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=QryEmConsItem&mID=0&IsTreeGrid=1";
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
	var mListData=ID +"^"+ Code +"^"+ Desc +"^"+ ActCode +"^"+ HospID +"^"+ mID +"^"+ ParID;

	//��������
	runClassMethod("web.DHCEMConsDicItem","save",{"mParam":mListData},function(jsonString){

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
	var ret=serverCall("web.DHCEMConsDicItem","isExOrEqual",{'tID':tID,'mID':mID}); //hxy 2020-08-13 st
	if(ret=="-1"){
		tID="";
	}//ed
	$("#tID").val("");
	loadTreePanelData(mID,tID,"","");  ///���������������
	
	$("#treeOpPanel").window({
		title:"���ڵ�����",
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
	var ParID = treeRowData._parentId;
	var ActCode=treeRowData.ActCode //hxy 2020-08-12
	var ret=serverCall("web.DHCEMConsDicItem","isExCsID",{'tID':tID}); //hxy 2020-08-12 st
	if(ret=="-1"){
		$.messager.alert("��ʾ","����ѡ��һ������!");
		return;
	}//ed
	
	$("#tID").val(tID);
	
	loadTreePanelData(mID,ParID,Code,Desc,ActCode);  ///��������������� //hxy 2020-08-12 add ActCode
	
	$("#treeOpPanel").window({
		title:"�޸�",
	}).window('open');
	
}

function loadTreePanelData(mID,tID,code,desc,ActCode){
	$("#Code").val(code);
	$("#Desc").val(desc);
	var url = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=QryEmConsItemArray&mID="+mID+"&tID=";
	$("#ParList").combobox("reload",url);
	$("#ParList").combobox("setValue",tID);
	$("#Active").combobox("setValue",ActCode); //"Y" //hxy 2020-08-12 change ActCode
	if(code==""){ //hxy 2020-08-13 ����Ĭ��Y
		$("#Active").combobox("setValue","Y")
	}
	
	$("#tree").treegrid('reload',{mID:mID});
}

/// ɾ��ѡ����
function deleteTreeRow(){
	
	var rowsData = $("#tree").treegrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsDicItem","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString == -1){
						$.messager.alert('��ʾ','����Ŀ��ʹ�ã�������ɾ����','warning');
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

function getTreeGridId(){
	addLine++;
	return "nodeId"+addLine;
}

/// ��ѯ��� 2021-05-06
function query(){
	$("#main").datagrid('reload',{params:hospComp.getValue()}); //hxy 2020-05-27 //2020-05-31 add
	//$("#main").datagrid('reload',{params:$('#hospDrID').combobox('getValue')});
 	$('#detail').datagrid('loadData', { total: 0, rows: [] });
 	$('#item').datagrid('loadData', { total: 0, rows: [] });
 	$('#tree').treegrid('loadData', { total: 0, rows: [] });
}

/// ���� 2021-06-25
function copyRow(){
	var rowsData = $("#main").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���ֵ�����!");
		return;	
	}	
	if(rowsData.ID==""){ //hxy 2022-09-27
		$.messager.alert("��ʾ","��ѡ����Ч���ֵ�����!");
		return;
	}
	$('#copyWin').dialog("open");
}

/// ���渴�� 2021-06-25
function saveCopy(){
	var rowsData = $("#main").datagrid('getSelected');
	var HospDr=$HUI.combobox("#HospArr").getValue();
	if((HospDr=="")||(HospDr==undefined)){
		$.messager.alert("��ʾ","��ѡ��ҽԺ!");
		return;	
	}
	runClassMethod("web.DHCEMConsDicItem","SaveCopy",{"ID":rowsData.ID,"Code":rowsData.Code,"Hosp":HospDr},function(jsonString){
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