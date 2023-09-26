/// Creator: zhaowuqiang
/// CreateDate: 2017-03-23
//  Descript:��תվά��

var editRow="";parentID="";  //��ǰ�༭�к�
var dataArray=[{"value":"Y","text":"Y"},{"value":"N","text":"N"}];
$(function(){
	
	//ͬʱ������������󶨻س��¼�
     $('#NLcode,#NLDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        findNodeLoc();  //���ò�ѯ
            //commonQuery({'datagrid':'#nodeloclist','formid':'#queryForm'}); //���ò�ѯ
        }
    });
	
	var Flageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			editable:false, 
			onSelect:function(option){
				///��������ֵ
				var ed=$("#nodeloclist").datagrid('getEditor',{index:editRow,field:'nlenabled'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
			} 
		}

	}
	var Loceditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISNodeLoc&MethodName=SelLoc", 
			required:true,
			panelHeight:"200",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#nodeloclist").datagrid('getEditor',{index:editRow,field:'nlloc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#nodeloclist").datagrid('getEditor',{index:editRow,field:'nllocid'});
				$(ed.target).val(option.value);
			} 
		}
	}
	var NLLLoceditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISNodeLoc&MethodName=SelLoc", 
			required:true,
			panelHeight:"200",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#nodeloclinklist").datagrid('getEditor',{index:editRow,field:'nllloc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#nodeloclinklist").datagrid('getEditor',{index:editRow,field:'nlllocid'});
				$(ed.target).val(option.value);    
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"nlcode",title:'����',width:100,align:'center',editor:{type:'validatebox',options:{required:true}}}, 
		{field:"nldesc",title:'����',width:130,align:'center',editor:{type:'validatebox',options:{required:true}}},
		{field:'nlenabled',title:'�Ƿ����',width:130,align:'center',editor:Flageditor},
		//{field:'nlloc',title:'��������',width:200,align:'center',editor:Loceditor},
		//{field:'nllocid',title:'����ID',width:130,align:'center',editor:{type:'text'},hidden:true},
		{field:"nlid",title:'ID',width:70,align:'center',editor:{type:'validatebox'},hidden:true}
	]];
	var option = {
		title:'������תվ�ֵ�ά��',
		singleSelect : true,
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#nodeloclist").datagrid('endEdit', editRow); 
            } 
            $("#nodeloclist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
			$('#nodeloclinklist').datagrid('reload',{params: rowData.nlid});
			parentID=rowData.nlid
	    }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISNodeLoc&MethodName=QueryNodeLoc";
	new ListComponent('nodeloclist', columns, uniturl, option).Init();
	// ����columns
	var columns=[[
		{field:'nllloc',title:'����ҵ�����',width:300,align:'center',editor:NLLLoceditor},   
		{field:"nlllocid",title:'��������ID',width:70,align:'center',editor:{type:'validatebox'},hidden:true},
		{field:"nllid",title:'ID',width:70,align:'center',editor:{type:'validatebox'},hidden:true},
		{field:"parentid",title:'parentID',width:70,align:'center',editor:{type:'validatebox'},hidden:true}
	]];
	///  ����datagrid  
	var option = {
		title:'������תվ����ҵ�����',
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#nodeloclinklist").datagrid('endEdit', editRow); 
            } 
            $("#nodeloclinklist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISNodeLoc&MethodName=QueryNodeLocLink";
	new ListComponent('nodeloclinklist', columns, uniturl, option).Init();
	
	//��ť���¼�
    $('#NLinsert').bind('click',NLinsertRow);
    $('#NLsave').bind('click',NLsaveRow);
    $('#NLdelete').bind('click',NLdeleteRow);
    $('#NLLinsert').bind('click',NLLinsertRow); 
    $('#NLLsave').bind('click',NLLsaveRow);
    $('#NLLdelete').bind('click',NLLdeleteRow);
    
    $('#NLfind').bind('click',function(event){
         findNodeLoc(); //���ò�ѯ
    });
  
		
})

function NLinsertRow(){
	if(editRow>="0"){
		$("#nodeloclist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#nodeloclist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {nlid: '',nlcode:'',nldesc: '',nlloc:'',nlenabled:'Y',nllocid:''} 
	});
            
	$("#nodeloclist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
function NLLinsertRow(){
	if(parentID==""){
	$.messager.alert("��ʾ","��ѡ����תվ!");
		return;
	}
	if(editRow>="0"){
		$("#nodeloclinklist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#nodeloclinklist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {nllid: '',nllloc:'2',nlllocid:'2',parentid:parentID} 
	});
            
	$("#nodeloclinklist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
function NLsaveRow(){
	if(editRow>="0"){
		$("#nodeloclist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#nodeloclist").datagrid('getChanges');
	//console.log(rowsData);
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].nllloc=="")||(rowsData[i].nldesc=="")||(rowsData[i].nlenabled=="")){ //huaxiaoying 2017-01-06
			$.messager.alert("��ʾ","��༭��������!"); 
			return false;
		}
		var tmp=rowsData[i].nlid +"^"+ rowsData[i].nlcode +"^"+ rowsData[i].nldesc +"^"+ rowsData[i].nlenabled +"^"+ "";
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCDISNodeLoc","SaveNodeLoc",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ","����ɹ�!"); 
			$('#nodeloclist').datagrid('reload'); //���¼���
		}else if(jsonString==-96){
			$.messager.alert("��ʾ","�����ظ�!"); 
			$('#nodeloclist').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ","����ʧ��!"); 
			$('#nodeloclist').datagrid('reload'); //���¼���
		}
	});
}
function NLLsaveRow(){
	if(editRow>="0"){
		$("#nodeloclinklist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#nodeloclinklist").datagrid('getChanges');
	console.log(rowsData);
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].nlcode==""){ 
			$.messager.alert("��ʾ","��༭��������!"); 
			return false;
		}
		var tmp=rowsData[i].nllid +"^"+ rowsData[i].nlllocid +"^"+ rowsData[i].parentid;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCDISNodeLoc","SaveNodeLocLink",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ","����ɹ�!"); 
			$('#nodeloclinklist').datagrid('reload'); //���¼���
		}else if(jsonString==-96){
			$.messager.alert("��ʾ","�����ظ�!"); 
			$('#nodeloclinklist').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ","����ʧ��!"); 
			$('#nodeloclinklist').datagrid('reload'); //���¼���
		}
	});
}
function NLdeleteRow(){
	var rowsData = $("#nodeloclist").datagrid('getSelected');
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��������Ҳ��ɾ��.��ȷ��Ҫɾ����", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISNodeLoc","DelNodeLoc",{"params":rowsData.nlid},function(jsonString){
					if(jsonString==0){
						$.messager.alert('��ʾ','ɾ���ɹ���','warning');
					}
					else{
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#nodeloclist').datagrid('reload'); //���¼���
					$('#nodeloclinklist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}

}
function NLLdeleteRow(){
	var rowsData = $("#nodeloclinklist").datagrid('getSelected');
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISNodeLoc","DelLocLink",{"params":rowsData.nllid},function(jsonString){
					if(jsonString==0){
						$.messager.alert('��ʾ','ɾ���ɹ���','warning');
					}
					else{
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#nodeloclinklist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

function findNodeLoc()
{
	var code=$('#NLcode').val();
	var desc=$('#NLdesc').val();
	var params=code+"^"+desc;
	$('#nodeloclist').datagrid('load',{params:params}); 
}
