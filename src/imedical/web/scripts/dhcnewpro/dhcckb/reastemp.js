var editMRow="",UserList=[],LocList=[]
$(function(){
	$('#searchRT').click(searchRT);
	$('#resetRT').click(resetRT);
	initCombobox();
	
});

// ��ʼ������������
function initCombobox(){
	runClassMethod("web.DHCCKBReasTemp","JsonUser",{},function(userData){
		UserList=userData;
		$("#userSearch").combobox("loadData",userData);
	})
	runClassMethod("web.DHCCKBReasTemp","JsonLoc",{},function(locData){
			LocList=locData;
			$("#locSearch").combobox("loadData",locData);
		})
}


// ��������ʾ����
function ActiveFormat(value){
	if(value=="Y"){
		return "��";
	}else{
		return "��";
	}
};

// ��������̬���ؿ���������
function choosePoint(){
	var ed=$("#RTTable").datagrid('getEditor',{index:editMRow,field:'RTType'});
	var value = $(ed.target).combobox('getValue');
	var ed=$("#RTTable").datagrid('getEditor',{index:editMRow,field:'RTPointDesc'});
	if(value=="User"){
		$(ed.target).combobox("loadData",UserList);
	}else if(value=="Loc"){
		$(ed.target).combobox("loadData",LocList);
	}else{
		$(ed.target).combobox("loadData",'');
	}	
}

// ָ������������ݹ淶��
function pointFormat(){
	var ed=$("#RTTable").datagrid('getEditor',{index:editMRow,field:'RTPointDesc'});
	var showText = $(ed.target).combobox('getText');
	var showId = $(ed.target).combobox('getValue');
	console.log(showId)
	$(ed.target).combobox('setValue', showText);
	var ed=$("#RTTable").datagrid('getEditor',{index:editMRow,field:'RTPoint'});
	$(ed.target).val(showId); 	
}

	

// ���ԭ�����������
function searchRT(){
		var userPoint = $("#userSearch").combobox("getValue");
		var locPoint = $("#locSearch").combobox("getValue");
		var text = $("#textSearch").val();
		var params = userPoint+"^"+locPoint+"^"+text;
		console.log(params);
		$("#RTTable").datagrid({
			url:'dhcapp.broker.csp?ClassName=web.DHCCKBReasTemp&MethodName=GetListByCondition',
			queryParams:{params:params},	
		})
	}
	
// ���ԭ��������������÷���
function resetRT(){
		$("#userSearch").combobox("setValue","");
		$("#locSearch").combobox("setValue","");
		$("#textSearch").val("");
		$("#RTTable").datagrid({url:'dhcapp.broker.csp?ClassName=web.DHCCKBReasTemp&MethodName=GetList'})
	}

//���ԭ��������һ��
function addRow(){
	if(editMRow>="0"){
		$("#RTTable").datagrid('endEdit', editMRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#RTTable").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].RTText == ""){
			$('#RTTable').datagrid('selectRow',0);
			$("#RTTable").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			editMRow=0;
			return;
		}
	}
	
	$("#RTTable").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {RowID:'', RTText:'',RTType:"User", RTPoint:'',RTPointDesc:'', RTActiveFlag:'Y'}
	});
	$("#RTTable").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editMRow=0;
	choosePoint();
}


//˫��ѡ���б༭
function onDblClickRow(index,row){
	if ((editMRow != "")||(editMRow == "0")) { 
		$("#RTTable").datagrid('endEdit', editMRow); 
    } 
    $("#RTTable").datagrid('beginEdit', index); 
    editMRow = index;
    choosePoint();
}

//�б�����Ϣ
function saveRow(){
	
	if(editMRow>="0"){
		$("#RTTable").datagrid('endEdit', editMRow);
	}

	var rowsData = $("#RTTable").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].RTText==""){
			$.messager.alert("��ʾ","��������Ϊ��!"); 
			return false;
		}
		if(rowsData[i].RTType==""){
			$.messager.alert("��ʾ","���Ͳ���Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].RowID +"^"+ rowsData[i].RTText +"^"+ rowsData[i].RTType +"^"+ rowsData[i].RTPoint +"^"+ rowsData[i].RTActiveFlag;
		dataList.push(tmp);
	}
	var mListData=dataList.join("$$");
	console.log(mListData)
	//��������
	runClassMethod("web.DHCCKBReasTemp","Save",{"params":mListData},function(jsonString){
		if (jsonString == "-1"){
			$.messager.alert('��ʾ','����ʧ��,���ʵ���ݺ����ԣ�','warning');
			return;	
		}else{
			$.messager.alert('��ʾ','����ɹ���');
			editMRow=""
		}
		$('#RTTable').datagrid('reload'); //���¼���
	})
}

// ɾ���б�����
function deleteRow(){
	var rowsData = $("#RTTable").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBReasTemp","Remove",{"RowID":rowsData.RowID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#RTTable').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}



