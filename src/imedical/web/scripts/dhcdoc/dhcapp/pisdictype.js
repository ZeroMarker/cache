/// author:    bianshuai
/// date:      2019-02-28
/// descript:  ������벡������ֵ�ά��

var editRow = ""; editDRow = ""; editPRow = "";
/// ҳ���ʼ������
function initPageDefault(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Pisdictype",hospStr);
	hospComp.jdata.options.onSelect  = function(){
		InitMainList();
		InitItemList();
		InitWidListener();
		} 
	//��ʼ���ֵ������б�
	InitMainList();
	
	//��ʼ���ֵ���Ŀ�б�
	InitItemList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
	
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	
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
	var activeActMapEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActMapCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ActMapDesc'});
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
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'Code',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'Desc',title:'����',width:150,editor:textEditor,align:'center'},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActDesc',title:'����',width:80,editor:activeEditor,align:'center'},
		{field:'ActMapCode',title:'ActMapCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActMapDesc',title:'�������뵥��Ȩ',width:80,editor:activeActMapEditor,align:'center'},
		/*{field:'HospID',title:'HospID',width:100,hidden:true,align:'center'}, //editor:textEditor,
		{field:'HospDesc',title:'ҽԺ',width:200,align:'center'} //editor:HospEditor,*/
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
	        var HospID=$HUI.combogrid('#_HospList').getValue();	        
	        /// �ֵ���Ŀ�б�
			$("#item").datagrid('reload',{mID:rowData.ID,HospID:HospID});
	    }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = $URL+"?ClassName=web.DHCAPPPisDicType&MethodName=QryPisDicType&HospID="+HospID;
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
	var HospID=2 ///�ֵ�����Ϊ�������ݣ��ֵ���ĿΪ˽��
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		/*if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}*/
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ HospID+"^"+ rowsData[i].ActMapCode;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCAPPPisDicType","save",{"mParam":mListData},function(jsonString){

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
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:'', HospDesc:''}
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
				runClassMethod("web.DHCAPPPisDicType","delete",{"ID":rowsData.ID},function(jsonString){
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
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'mID',title:'mID',width:100,hidden:true,align:'center'},
		{field:'Code',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'Desc',title:'����',width:500,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActDesc',title:'����',width:80,editor:activeEditor,align:'center'},
		{field:'HospID',title:'HospID',width:100,hidden:true,align:'center'}, //editor:textEditor,
		{field:'HospDesc',title:'ҽԺ',width:200,align:'center'} //editor:HospEditor,
		//{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'center'}
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
	        	        
	    }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = $URL+"?ClassName=web.DHCAPPPisDicItem&MethodName=QryPisDicItem&mID=0&HospID="+HospID;
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
		var HospID=$HUI.combogrid('#_HospList').getValue();
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ HospID +"^"+ rowsData[i].mID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCAPPPisDicItem","save",{"mParam":mListData},function(jsonString){

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
				runClassMethod("web.DHCAPPPisDicItem","delete",{"ID":rowsData.ID},function(jsonString){

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
var m_ReBLMapDataGrid
function ConItemRow(){
	var rowsData = $("#item").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ", "��ѡ��һ����Ŀ!", 'info');
		return 
	}
	$("#ReBLMap-dialog").dialog("open");
	$.cm({
			ClassName:"web.DHCDocAPPBL",
			QueryName:"FindBLType",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#BLMap", {
				editable:false,
				valueField: 'RowID',
				textField: 'BLTypeDesc', 
				data: GridData["rows"],
				onLoadSuccess:function(){
					$("#BLMap").combobox('select','');
				}
			 });
	});
	m_ReBLMapDataGrid=InitReBLMapDataGrid();
	LoadReBLMapDataGrid();
	}
function InitReBLMapDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {ConItemaddClickHandle();}
    }, {
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: function() {ConItemdelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'RowID',hidden:true,title:'RowID'},
		{field:'BLMapID',hidden:true,title:'BLMapID'},
		{field:'BLMapDesc',title:'���뵥',width:100},
		{field:'Defalute',title:'�Ƿ�Ĭ��',width:100}
    ]]
	var ReHospitalDataGrid=$("#ReBLMapTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'RowID',
		columns :Columns,
		toolbar:toobar
	}); 
	return ReHospitalDataGrid;
}
function LoadReBLMapDataGrid(){
	var rowsData = $("#item").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ", "��ѡ��һ����Ŀ!", 'info');
		return 
	}
	var PisDicItem=rowsData.ID
	$.q({
	    ClassName : "web.DHCAppPisDicRelationBLMap",
	    QueryName : "FindRelationBLMap",
	    PisDicItem:PisDicItem,
	    Pagerows:m_ReBLMapDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		m_ReBLMapDataGrid.datagrid("unselectAll");
		m_ReBLMapDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function ConItemaddClickHandle(){
	var rowsData = $("#item").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ", "��ѡ��һ����Ŀ!", 'info');
		return 
	}
	var PisDicItem=rowsData.ID
	var rowsData = $("#main").datagrid('getSelected');
	var PisDicType=rowsData.ID
	var PisBLmap=$("#BLMap").combobox("getValue")
	var PisDefulat="N";
	var ForRequest=$("#BLMapDef").prop("checked");
	if(ForRequest) PisDefulat="Y"
	$.cm({
		ClassName:"web.DHCAppPisDicRelationBLMap",
		MethodName:"InsertRelationBLMap",
		PisDicItem:PisDicItem,
		PisDicType:PisDicType,
		PisBLmap:PisBLmap,
		PisDefulat:PisDefulat,
		dataType:"text",
	},function(data){
		if (data==0) {
			$.messager.popover({msg: '���ӳɹ�!',type:'success',timeout: 1000});
			LoadReBLMapDataGrid();
		}else if(data>0) {
			$.messager.alert("��ʾ","����ʧ�ܣ���¼�ظ�!","info");
		}else{
			$.messager.alert("��ʾ","����ʧ�ܣ�"+data,"info");
		}
	})
}
function ConItemdelectClickHandle(){
	var rowsData = m_ReBLMapDataGrid.datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ", "��ѡ��һ����Ŀ!", 'info');
		return 
	}
	var RowID=rowsData.RowID
	$.cm({
		ClassName:"web.DHCAppPisDicRelationBLMap",
		MethodName:"DelectRelationBLMap",
		RowID:RowID,
		dataType:"text",
	},function(data){
		$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
		LoadReBLMapDataGrid();
	})
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
