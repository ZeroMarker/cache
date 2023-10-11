/// author:    huanghongping
/// date:      2021-07-20
/// descript:  ��Ա��Ϣ�ֵ�ά��

var editRow = ""; editDRow = ""; editPRow = "";
/// ҳ���ʼ������
function initPageDefault(){
	
	//��ʼ����Ա��Ϣ����
	InitMainList();
	
	//��ʼ����Ա��Ϣ
	InitItemList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
	
	
	
}
//��ʼ�����水ť�¼�
function InitWidListener(){
	 $("#ManageSearch").on('click',ManageSearch);
	
	
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
	var hhpEditor={
		type: 'combobox',
		options: {
			//data: [{"value":"��","text":'��'}, {"value":"Ů","text":'Ů'}, {"value":"δ֪�Ա�","text":'����'}, {"value":"δ˵���Ա�","text":'�´�����'}],
			url:$URL+"?ClassName=web.DHCINTManageCrud&MethodName=GetSex" ,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",
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
			editable: false,
			panelHeight:"auto", //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'PLTFlagCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'PLTFlag'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'RowID',title:'ID',width:50,hidden:true,align:'left'},
		{field:'PLTCode',title:'ģ�����',width:130,editor:textEditor,align:'left'},
		{field:'PLTDesc',title:'ģ������',width:170,editor:textEditor,align:'left'},
//		{field:'PLTFlag',title:'�Ƿ����',width:150,editor:{type:'numberbox'},hidden:false,align:'center'},
//		{field:'Sex',title:'�Ա�',width:120,editor:hhpEditor,align:'center'},
//		{field:'Depart',title:'����',width:180,editor:textEditor,align:'center'},
//		{field:'Address',title:'��ַ',width:230,editor:textEditor,align:'center'},
//		{field:'DateTime',title:'����ʱ��',width:160,editor:{type:'datetimebox'},align:'center'},
		{field:'PLTFlagCode',title:'PLTFlagCode',width:80,editor:textEditor,align:'left',hidden:true},		
		{field:'PLTFlag',title:'�Ƿ����',width:80,editor:activeEditor,align:'left'},		
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		rownumbers:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
	        	        
	        /// �ֵ���Ŀ�б�
			$("#item").datagrid('reload',{mID:rowData.RowID});
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCLocTemp&QueryName=GetAllTemplate&SearchStr=";
	new ListComponent('main', columns, uniturl, option).Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!",'warning');
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PLTCode=="")||(rowsData[i].PLTDesc=="")||(rowsData[i].PLTFlag=="")){
			$.messager.alert("��ʾ","����δ��д��,����д����!",'warning'); 
			return false;
	    }
		if(rowsData[i].PLTFlag.trim()=="��"){
		    rowsData[i].PLTFlag="Y"	
		}
		if(rowsData[i].PLTFlag.trim()=="��"){
			rowsData[i].PLTFlag="N"		
		}
		var tmp=rowsData[i].RowID +"^"+ rowsData[i].PLTCode +"^"+ rowsData[i].PLTDesc +"^"+
		 rowsData[i].PLTFlag;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");
	

	//��������
	runClassMethod("web.DHCPRESCLocTemp","TemplateSave",{"mParam":mListData},function(jsonString){

		if (jsonString == "-1"){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}
		if (jsonString == "-2"){
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
		row: {RowID:'', PLTCode:'', PLTDesc:'', PLTFlagCode:'Y',PLTFlag:'��'}
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
				runClassMethod("web.DHCPRESCLocTemp","DeleteTemplate",{"ID":rowsData.RowID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#main').datagrid('reload'); //���¼���
					$('#item').datagrid('reload'); //���¼���
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
		var CtlocEditor={
		type: 'combobox',
		options: {
			url:$URL+"?ClassName=web.DHCPRESCDicScheme&MethodName=GetAllCTLoc&Hosp="+LgHospID  ,
			valueField: "ctloc",
			textField: "ctloc",
			mode:'remote',
			panelHeight:"300",
		}
		
		}
	
	var disableEditor={
          type:'textbox',
           options:{editable: false}
          
          }
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'mID',title:'ģ��id',width:100,hidden:true,align:'left'},
		{field:'LocCode',title:'���Ҵ���',width:150,hidden:false,align:'left'},
		{field:'LocName',title:'��������',width:220,hidden:false,align:'left',editor:CtlocEditor},
		{field:'ID',title:'id',width:200,hidden:true,align:'left'},
//		{field:'Grade',title:'����',width:150,editor:numberEditor},

		
		
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		rownumbers:false,
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
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCLocTemp&QueryName=GetAllPLCtLoc&mID=";
	new ListComponent('item', columns, uniturl, option).Init();

}

/// ����༭��
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}
	var rowData = $("#main").datagrid("getSelected");
	
	if(rowData ==null){
		$.messager.alert("��ʾ","��ѡ�����ģ��!",'warning');
		return;
	}
	var mID = rowData.RowID;           /// ����ĿID
	var rowsData = $("#item").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!",'warning');
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].LocName==""){
			$.messager.alert("��ʾ","���Ҳ���Ϊ��!","warning"); 
			return false;
		}
		var tmp=rowsData[i].LocName+"^"+rowsData[i].id;
		dataList.push(tmp);
	}
//	
	var mListData=dataList.join("$$");
//
//	//��������
	runClassMethod("web.DHCPRESCLocTemp","SaveTempCtloc",{mID:mID,mParam:mListData},function(jsonString){
		if (jsonString == "-3"){
			$.messager.alert('��ʾ','���Ҳ���Ϊ�գ�','warning');
			return;	
		}
		
		if (jsonString == "-1"){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}
		
		if (jsonString == "-2"){
			$.messager.alert('��ʾ','�ÿ��Ҳ�����,���ʵ�����ԣ�','warning');
			return;	
		}
		$('#item').datagrid('reload'); //���¼���
	})
	
}

/// ��������
function insertItmRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ��ģ��!","warning");
		return;
	}
	var ID = rowData.RowID;           /// ����ĿID
	
	
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
		row: {mID:ID, LocCode:'', LocName:'',id:''}
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
				runClassMethod("web.DHCPRESCLocTemp","DeleteTempCtloc",{"ID":rowsData.ID},function(jsonString){

					if (jsonString == -1){
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
function ManageSearch(){
	var SearchStr=$("#Code").val()
	$("#main").datagrid('load',{SearchStr:SearchStr}); 
	$("#item").datagrid('reload',{mID:""});
	
}

/// JQuery ��ʼ��ҳ��
$(function(){
  

 initPageDefault(); 

 })


	