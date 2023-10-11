/// author:    bianshuai
/// date:      2019-04-16
/// descript:  MDT���Ѳ��ַ���ά��
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var editRow = ""; editDRow = ""; editPRow = "",editCRow=0,editURow =0,editARow=0;
/// ҳ���ʼ������
function initPageDefault(){
	
	init(); //ylp ��ʼ��ҽԺ //20230222
	//��ʼ���ֵ������б�
	InitMainList();
	
	//��ʼ���ֵ���Ŀ�б�
	InitItemList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
	
	///��ʼ���ֵ������б�
	InitDetailList();
	
	///��ʼ��ҽ���ֵ��
	InitConsOrdList();
	
	InitConsPurList();
	
	InitAppUserList();
	
	InitAppUserAutList();
	
	///��ʼ��MDT��������ά���б� xiaowenwu 2020-03-05
	InitFeedbackNumList();
	
	/// ҳ�� tabs
	InitPageTabs();
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

/// ҳ�� tabs
function InitPageTabs(){
	
	$('#tag_id').tabs({ 
		onSelect:function(title){
			switch (title){
				case "��Ժר��":
					if ($("#tab_req").attr("src") == "") $("#tab_req").attr('src',$("#tab_req").attr("data-src"));
					break;
				default:
					return;
			}
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
			editable:false,
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
		{field:'Code',title:'����',width:100,editor:textEditor},
		{field:'Desc',title:'����',width:150,editor:textEditor},
		{field:'Addr',title:'����ص�',width:150,editor:textEditor},
		{field:'Notes',title:'��ע',width:150,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'����',width:80,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'HospDesc',title:'ҽԺ',width:200,editor:HospEditor,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
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
	        	        
	        /// ��Ա�����б�
			$("#item").datagrid('reload',{ID:rowData.ID});
			
			/// ���Һű��б�
			$("#detail").datagrid('reload',{mID:rowData.ID});
			
			/// ҽ������
			$("#consOrd").datagrid('reload',{mID:rowData.ID});
			
			/// ģ������
			$("#consPur").datagrid('reload',{mID:rowData.ID});
			
			/// ����Ȩ������
			$("#consAppUser").datagrid('reload',{GropID:rowData.ID});
			
			$("#consAppUserAut").datagrid('reload',{DARowID:0});
			
			$("#feedbackNum").datagrid('reload',{mID:rowData.ID});
			
			/// ��Ժר��
			frames[0].window.location.reload()
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=QryGroup"+"&params="+hospComp.getValue()+"&MWToken="+websys_getMWToken();
	new ListComponent('main', columns, uniturl, option).Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!","warning"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!","warning"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID+"^"+rowsData[i].Addr+"^"+rowsData[i].Notes;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTGroup","save",{"mParam":mListData},function(jsonString){

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
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:hospComp.getValue(), HospDesc:'',Notes:''}
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
				runClassMethod("web.DHCMDTGroup","delete",{"ID":rowsData.ID},function(jsonString){
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

	// ���ұ༭��
	var LocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID']+"&MWToken="+websys_getMWToken(),
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
				
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
			}
		}
	}
	
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///���ü���ָ��
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	
	// ���ҳ�Ա
	var UserEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			//url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonUser",
			url: "",
			valueField: "value", 
			textField: "text",
			//editable:false,
			mode:'remote',
			onSelect:function(option){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				$(ed.target).combobox('setValue', option.text);
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTp",
					UserID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
					var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocID'});
				    var LocID = $(ed.target).val();
				});
				
			},
			onShowPanel:function(){
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#item").datagrid('getEditor',{index:editDRow,field:'User'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocUser&LocID="+ LocID+"&PrvTpID="+PrvTpID+"&MWToken="+websys_getMWToken();
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
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'mID',title:'mID',width:100,hidden:true},
		{field:'LocID',title:'LocID',width:100,editor:textEditor,hidden:true},
		{field:'LocDesc',title:'����',width:220,editor:LocEditor},
		{field:'UserID',title:'UserID',width:100,editor:textEditor,hidden:true},
		{field:'User',title:'���ҳ�Ա',width:140,editor:UserEditor},
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:textEditor,hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,editor:PrvTpEditor,hidden:false},
		{field:'ContactsID',title:'ContactsID',width:100,editor:textEditor,hidden:true},
		{field:'ContactsFlag',title:'�����˱�ʶ',width:100,editor:ContractEditor}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
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
	
	var uniturl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=QryGroupItm&ID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('item', columns, uniturl, option).Init();

}

/// ����༭��
function saveItemRow(){
	
	if(editDRow>="0"){
		$("#item").datagrid('endEdit', editDRow);
	}

	var rowsData = $("#item").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].LocID=="")||(rowsData[i].PrvTpID=="")){
			$.messager.alert("��ʾ","���һ�ְ�Ʋ���Ϊ��!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].mID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].PrvTpID +"^"+ rowsData[i].UserID +"^"+ rowsData[i].ContactsID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTGroup","saveItm",{"mParam":mListData},function(jsonString){

		if (jsonString == "-1"){
			$.messager.alert('��ʾ','������Ա�ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if (jsonString == "-2"){
			$.messager.alert('��ʾ','�������ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#item').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertItmRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ��MDTС��!");
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
		row: {mID:ID, ID:'', LocID:'', LocDesc:'', UserID:'', User:'', ContactsID:'', ContactsFlag:'N'}
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
				runClassMethod("web.DHCMDTGroup","deleteItem",{"ID":rowsData.ID},function(jsonString){

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
	
	// ���ұ༭��
	var LocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: '',
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocID'});
				$(ed.target).val(option.value);
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvID'});
				$(ed.target).val("");
			},
			onShowPanel:function(){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'HospID'});
				var HospID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocDesc'});
				var unitUrl=$URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+HospID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	// ��Դ�ű�
	var PrvEditor = {  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			//editable:false,
			onSelect:function(option){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvID'});
				$(ed.target).val(option.value);
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#detail").datagrid('getEditor',{index:editPRow,field:'PrvDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=jsonLocCare&LocID="+ LocID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'mID',title:'mID',width:100,hidden:true},
		{field:'LocID',title:'LocID',width:100,editor:textEditor,hidden:true},
		{field:'LocDesc',title:'����',width:220,editor:LocEditor},
		{field:'PrvID',title:'PrvID',width:100,editor:textEditor,hidden:true},
		{field:'PrvDesc',title:'�ű�',width:220,editor:PrvEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
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
	
	var uniturl = $URL+"?ClassName=web.DHCMDTCareProv&MethodName=QryCareProv&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('detail', columns, uniturl, option).Init();
}


///��ʼ�������б�
function InitConsOrdList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ��Դ�ű�
	var ArciEditor = {  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#consOrd").datagrid('getEditor',{index:editCRow,field:'ArciID'});
				$(ed.target).val(option.value);
				var ed=$("#consOrd").datagrid('getEditor',{index:editCRow,field:'Arci'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#consOrd").datagrid('getEditor',{index:editCRow,field:'Arci'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTOrdConfig&MethodName=ListArci"+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'mID',title:'mID',width:100,hidden:false},
		{field:'ArciID',title:'ArciID',width:100,editor:textEditor,hidden:true},
		{field:'Arci',title:'����ҽ��',width:220,editor:ArciEditor},
		{field:'ArciNum',title:'����',width:100,editor:textEditor}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editCRow != "")||(editCRow == "0")) { 
                $("#consOrd").datagrid('endEdit', editCRow); 
            } 
            $("#consOrd").datagrid('beginEdit', rowIndex); 
            editCRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTOrdConfig&MethodName=QryList&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('consOrd', columns, uniturl, option).Init();
}

///��ʼ�������б�
function InitAppUserList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ��Ա����
	var TypeEditor = {  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'PointerID'});
				$(ed.target).val("");
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Pointer'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'TypeID'});
				$(ed.target).val(option.value);
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Type'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Type'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTDocAppAut&MethodName=JsonListAutType"+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	
	// �����б�
	var PointerEditor = {  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'PointerID'});
				$(ed.target).val(option.value);
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'TypeID'});
				var TypeID=$(ed.target).val();
				var ed=$("#consAppUser").datagrid('getEditor',{index:editURow,field:'Pointer'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTDocAppAut&MethodName=JsonListAutPointer&TypeID="+TypeID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Type',title:'����',width:150,hidden:false,editor:TypeEditor},
		{field:'TypeID',title:'����ID',width:100,editor:textEditor,hidden:true},
		{field:'Pointer',title:'ָ��',width:250,editor:PointerEditor},
		{field:'PointerID',title:'ָ��ID',width:100,editor:textEditor,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		onClickRow:function(rowIndex, rowData){
			$("#consAppUserAut").datagrid("load",{DARowID:rowData.ID});
		},
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editURow != "")||(editURow == "0")) { 
                $("#consAppUser").datagrid('endEdit', editURow); 
            } 
            $("#consAppUser").datagrid('beginEdit', rowIndex); 
            editURow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTDocAppAut&MethodName=QryDocAutItm&GropID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('consAppUser', columns, uniturl, option).Init();
}


///��ʼ�������б�
function InitAppUserAutList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ��Ȩ����
	var DicItmEditor = {  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#consAppUserAut").datagrid('getEditor',{index:editARow,field:'DicItmID'});
				$(ed.target).val(option.value);
				var ed=$("#consAppUserAut").datagrid('getEditor',{index:editARow,field:'DicItm'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var ed=$("#consAppUserAut").datagrid('getEditor',{index:editARow,field:'DicItm'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonListDitItm&DicCode=AppAut&LgParams="+LgParams+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'DicItm',title:'��Ȩ����',width:450,hidden:false,editor:DicItmEditor},
		{field:'DicItmID',title:'��Ȩ����ID',width:100,editor:textEditor,hidden:true},
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		pagination:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		onClickRow:function(rowIndex, rowData){
			
		},
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editARow != "")||(editARow == "0")) { 
                $("#consAppUserAut").datagrid('endEdit', editARow); 
            } 
            $("#consAppUserAut").datagrid('beginEdit', rowIndex); 
            editARow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTDocAppAut&MethodName=QryDocAutDicItm&DARowID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('consAppUserAut', columns, uniturl, option).Init();
}
/// ����༭��
function saveDetRow(){
	
	if(editPRow>="0"){
		$("#detail").datagrid('endEdit', editPRow);
	}

	var rowsData = $("#detail").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].LocID=="")||(rowsData[i].UserID=="")){
			$.messager.alert("��ʾ","���һ�ű���Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].mID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].PrvID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTCareProv","save",{"mParam":mListData},function(jsonString){

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
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ַ���!","warning");
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
	if (rowsData.length >= 1) {
		$.messager.alert("��ʾ","��ά���ű���ɾ��������","warning");
		return;
	}
	
	$("#detail").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {mID:ID, ID:'', LocID:'', LocDesc:'', PrvID:'', PrvDesc:'', HospID:HospID}
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
				runClassMethod("web.DHCMDTCareProv","delete",{"ID":rowsData.ID},function(jsonString){

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


/// ��������
function insertOrdRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ַ���!","warning");
		return;
	}
	var ID = rowData.ID;           /// ����ĿID
	var HospID = rowData.HospID;   /// ҽԺID
	
	if(editCRow >= "0"){
		$("#consOrd").datagrid('endEdit', editCRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#consOrd").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#consOrd').datagrid('selectRow',0);
			$("#consOrd").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#consOrd").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {mID:ID, ID:'', ArciID:'', Arci:''}
	});
	$("#consOrd").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editCRow=0;
}

/// ɾ��ѡ����
function deleteOrdRow(){
	
	var rowsData = $("#consOrd").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTOrdConfig","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#consOrd').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}


/// ����༭��
function saveOrdRow(){
	
	if(editCRow>="0"){
		$("#consOrd").datagrid('endEdit', editCRow);
	}

	var rowsData = $("#consOrd").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].LocID=="")||(rowsData[i].UserID=="")){
			$.messager.alert("��ʾ","���һ�ű���Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].mID +"^"+ rowsData[i].ArciID+"^"+rowsData[i].ArciNum ;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTOrdConfig","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
	
		$("#consOrd").datagrid('reload');
	})
}


///yzy
///��ʼ�������б�
function InitConsPurList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}

	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Pointer',title:'mID',width:100,hidden:true},
		{field:'Title',title:'����',width:100,editor:textEditor},
		{field:'Text',title:'��������',width:220,editor:textEditor},
		
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editPRow != "")||(editPRow == "0")) { 
                $("#consPur").datagrid('endEdit', editPRow); 
            } 
            $("#consPur").datagrid('beginEdit', rowIndex); 
            editPRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTemp&MethodName=QryOpiTemp&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('consPur', columns, uniturl, option).Init();
}

/// ����༭��
function saveconsPurRow(){
	
	if(editPRow>="0"){
		$("#consPur").datagrid('endEdit', editPRow);
	}

	var rowsData = $("#consPur").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((trim(rowsData[i].Title) == "")||(trim(rowsData[i].Text) == "")){
			$.messager.alert("��ʾ","��������ݲ���Ϊ��!",'warning'); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Pointer +"^"+ rowsData[i].Title +"^"+ rowsData[i].Text;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTemp","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#consPur').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertconsPurRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ַ���!","warning");
		return;
	}
	var ID = rowData.ID;           /// ����ĿID
	
	
	if(editPRow >= "0"){
		$("#consPur").datagrid('endEdit', editPRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#consPur").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].MTTitles == ""){
			$('#consPur').datagrid('selectRow',0);
			$("#consPur").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#consPur").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {Pointer:ID, ID:'', Title:'', Text:'',}
	});
	$("#consPur").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editPRow=0;
}

/// ɾ��ѡ����
function deleteconsPurRow(){
	
	var rowsData = $("#consPur").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTemp","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#consPur').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ��������
function insertAppUserRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ַ���!","warning");
		return;
	}
	var ID = rowData.ID;           /// ����ĿID
	var HospID = rowData.HospID;   /// ҽԺID
	
	if(editURow >= "0"){
		$("#consAppUser").datagrid('endEdit', editURow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#consAppUser").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].TypeID == ""){
			$('#consAppUser').datagrid('selectRow',0);
			$("#consAppUser").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#consAppUser").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'',Pointer:'', PointerID:'', Type:'', TypeID:''}
	});
	$("#consAppUser").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editURow=0;
}


/// ɾ��ѡ����
function deleteAppUserRow(){
	
	var rowsData = $("#consAppUser").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTDocAppAut","delete",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#consAppUser').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ����༭��
function saveAppUserRow(){
	
	if(editURow>="0"){
		$("#consAppUser").datagrid('endEdit', editURow);
	}
	
	var rowData = $("#main").datagrid("getSelected");
	var GropID = rowData.ID;           /// ����ĿID

	var rowsData = $("#consAppUser").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}

	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].TypeID=="")||(rowsData[i].PointerID=="")){
			$.messager.alert("��ʾ","���ͻ�ָ��ֵ����Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ GropID +"^"+ rowsData[i].TypeID +"^"+ rowsData[i].PointerID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTDocAppAut","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-2"))){
			$.messager.alert('��ʾ','��¼�ظ�,���ʵ�����ԣ�','warning');
			return;	
		}
	
		$("#consAppUser").datagrid('reload');
	})
}


/// ��������
function insertAppAutRow(){
	
	var rowData = $("#consAppUser").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ����Ȩ��Ա!","warning");
		return;
	}
	var ID = rowData.ID;           /// ����ĿID
	
	if(editARow >= "0"){
		$("#consAppUserAut").datagrid('endEdit', editARow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#consAppUserAut").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].TypeID == ""){
			$('#consAppUserAut').datagrid('selectRow',0);
			$("#consAppUserAut").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#consAppUserAut").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'',DicItm:'', DicItmID:''}
	});
	$("#consAppUserAut").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editARow=0;
}


/// ɾ��ѡ����
function deleteAppAutRow(){
	
	var rowsData = $("#consAppUserAut").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTDocAppAut","deleteAut",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#consAppUserAut').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ����༭��
function saveAppAutRow(){
	
	if(editARow>="0"){
		$("#consAppUserAut").datagrid('endEdit', editARow);
	}
	
	var rowData = $("#consAppUser").datagrid("getSelected");
	var AppUserID = rowData.ID;           /// ����ĿID

	var rowsData = $("#consAppUserAut").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}

	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].DicItmID==""){
			$.messager.alert("��ʾ","��Ȩ���Ͳ���Ϊ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ AppUserID +"^"+ rowsData[i].DicItmID ;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTDocAppAut","saveAut",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
	
		$("#consAppUserAut").datagrid('reload');
	})
}

///��ʼ��MDT��������ά���б� xiaowenwu 2020-03-05
function InitFeedbackNumList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'mID',title:'mID',width:100,hidden:true,align:'center'},
		{field:'MDTimes',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'MDInterval',title:'���ʱ��(��)',width:100,editor:textEditor,align:'center'},
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editPRow != "")||(editPRow == "0")) { 
                $("#feedbackNum").datagrid('endEdit', editPRow); 
            } 
            $("#feedbackNum").datagrid('beginEdit', rowIndex); 
            editPRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTFolUpTimes&MethodName=QryFolUpTimes&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('feedbackNum', columns, uniturl, option).Init();
}

/// �������� xiaowenwu 2020-03-05
function insertFeeRow(){
	
	var rowData = $("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ���ַ���!","warning");
		return;
	}
	var ID = rowData.ID;           /// ����ĿID
	var HospID = rowData.HospID;   /// ҽԺID
	
	if(editCRow >= "0"){
		$("#feedbackNum").datagrid('endEdit', editCRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#feedbackNum").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].LocID == ""){
			$('#feedbackNum').datagrid('selectRow',0);
			$("#feedbackNum").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#feedbackNum").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {mID:ID, ID:'', MDTimes:'', MDInterval:''}
	});
	$("#feedbackNum").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editCRow=0;
}

/// ɾ��ѡ���� xiaowenwu 2020-03-05
function deleteFeeRow(){
	
	var rowsData = $("#feedbackNum").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTFolUpTimes","remove",{"ID":rowsData.ID},function(jsonString){

					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#feedbackNum').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}


/// ����༭�� xiaowenwu 2020-03-05
function saveFeeRow(){
	
	if(editCRow>="0"){
		$("#feedbackNum").datagrid('endEdit', editCRow);
	}

	var rowsData = $("#feedbackNum").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].MDTimes=="")||(rowsData[i].MDInterval=="")){
			$.messager.alert("��ʾ","��ô�����ʱ��������Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].mID +"^"+ rowsData[i].MDTimes+"^"+ rowsData[i].MDInterval;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTFolUpTimes","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
	
		$("#feedbackNum").datagrid('reload');
	})
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
