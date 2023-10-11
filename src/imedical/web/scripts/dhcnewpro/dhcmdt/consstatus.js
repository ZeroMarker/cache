/// author:    bianshuai
/// date:      2016-04-11
/// descript:  ��������״̬�ֵ�ά��
var LgHospID = session['LOGON.HOSPID'];    /// ҽԺID
var LgHospDesc = session['LOGON.HOSPDESC'];  /// ҽԺ
var editRow = ""; editDRow = "";
$(function(){
    
    //��ʼ��ҽԺ ��Ժ������ ylp 2023-02-23
    InitHosp(); 

	//��ʼ������Ĭ����Ϣ
	InitDefault();
	
	//��ʼ����ѯ��Ϣ�б�
	InitDetList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
})
   
 //��ʼ��ҽԺ ��Ժ������ ylp 2023-02-23
function InitHosp(){
	hospComp = GenHospComp("DHC_MDTConsStatus"); 
	HospDr=hospComp.getValue(); //cy 2021-04-09
	hospComp.options().onSelect = function(){///ѡ���¼�
		HospDr=hospComp.getValue(); //cy 2021-04-09
		
		$("#dgMainList").datagrid('reload',{params:HospDr});
		
	}
	$('#queryBTN').on('click',function(){
		$("#dgMainList").datagrid('reload',{params:hospComp.getValue()});
	 })
	$("#_HospBtn").bind('click',function(){
		var rowData = $("#dgMainList").datagrid('getSelected');
		if (!rowData){
			$.messager.alert("��ʾ","��ѡ��һ�У�");
			return false;
		}
		GenHospWin("DHC_MDTConsStatus",rowData.ID);
	})
	

}

///��ʼ������Ĭ����Ϣ
function InitDefault(){

}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$("div#tb a:contains('����')").bind("click",insertRow);
	$("div#tb a:contains('ɾ��')").bind("click",deleteRow);
	$("div#tb a:contains('����')").bind("click",saveRow);
	
}

///��ʼ�������б�
function InitDetList(){
	
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
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActDesc'});
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
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	// ��һ״̬�༭��
	var SupStateEditor={
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			multiple:true,
			enterNullValueClear:false,
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=GetListMdtStatus&HospID="+LgHospID+"&MWToken="+websys_getMWToken(),
			blurValidValue:true,
			onChange:function() {
				///��������ֵ
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'SupState'});
				var SupStateArr=$(ed.target).combobox('getValues');
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'SupStateID'});
				$(ed.target).val(SupStateArr.join(","));	
			},
			onShowPanel:function(){
				
			}		   
		}
	}
	
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'����',width:100,editor:textEditor},
		{field:'Desc',title:'����',width:200,editor:textEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'�Ƿ����',width:100,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'HospDesc',title:'ҽԺ',width:300,editor:HospEditor,hidden:true},
		{field:'SupState',title:'��һ״̬',width:300,editor:SupStateEditor},
		{field:'SupStateID',title:'��һ״̬ID',width:100,editor:textEditor,hidden:true},
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		//title:'��������״̬�ֵ�',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            editRow = rowIndex;
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'SupStateID'});
            var SupStateArr=$(ed.target).val().split(",");
            var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'SupState'});
			$(ed.target).combobox('setValues',SupStateArr);
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsStatus&MethodName=QryEmConsStatus"+"&params="+hospComp.getValue()+"&MWToken="+websys_getMWToken();
	var dgMainListComponent = new ListComponent('dgMainList', columns, uniturl, option);
	dgMainListComponent.Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgMainList").datagrid('getChanges');
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
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +
				"^"+rowsData[i].SupStateID;
		
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTConsStatus","save",{"mParam":params},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#dgMainList').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#dgMainList").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:hospComp.getValue(), HospDesc:""}
	});
	$("#dgMainList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#dgMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTConsStatus","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('��ʾ','�����Ѻ�ҽ�����,����ɾ����','warning');
					}
					$('#dgMainList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}