/** sufan 
  * 2018-04-09
  *
  * �����Ű���ϸά��
 */
var editRow = ""; 
/// ҳ���ʼ������
function initPageDefault(){

	iniSchItmlist();	 	///	��ʼҳ��DataGrid�Ű���ϸ��
	initButton();           /// ҳ��Button���¼�	
}
/// ��ʼ���Ű���ϸ�б�
function iniSchItmlist()
{
	var Scheditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=GetSchedule",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'SchDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'SchDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	var Typeeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisTypeCombobox",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'TypeDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'TypeDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	var Nodeeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=QueryNode",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'NodeDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'NodeDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	var Usereditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=GetDisUser",
			//required:true,
			panelHeight:200,  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'UserDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'UserDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}

	// ����columns
	var columns=[[
		{field:"SchDr",title:'SchDr',width:50,hidden:true,editor:textEditor},
		{field:"SchDesc",title:'���',width:160,align:'center',editor:Scheditor},
		{field:"TypeDr",title:'TypeDr',width:50,hidden:true,editor:textEditor},
		{field:"TypeDesc",title:'��������',width:180,align:'center',editor:Typeeditor},
		{field:"NodeDr",title:'NodeDr',width:50,hidden:true,editor:textEditor},
		{field:"NodeDesc",title:'������λ',width:180,align:'center',editor:Nodeeditor},
		{field:"UserDr",title:'UserDr',width:50,hidden:true,editor:textEditor},
		{field:"UserDesc",title:'������Ա',width:180,hidden:true,align:'center',editor:Usereditor},
		{field:"SchtItmId",title:'SchtItmId',width:50,hidden:true,editor:textEditor}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) { 
                $("#scheitmlist").datagrid('endEdit', editRow); 
            } 
            $("#scheitmlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl =LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=QuerySchItm";
	new ListComponent('scheitmlist', columns, uniturl, option).Init();
}
/// ҳ�� Button ���¼�
function initButton(){
	
	///  �����Ű���ϸ
	$('#subinsert').bind("click",insItmRow);
	
	///  �����Ű���ϸ
	$('#subsave').bind("click",saveItmRow);
	
	///  ɾ���Ű���ϸ
	$('#subdelete').bind("click",delItmRow);

}

/// �����Ű���ϸ
function insItmRow()
{

	if(editRow>="0"){
		$("#scheitmlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#scheitmlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {SchDr:'',SchDesc:'',TypeDr: '',TypeDesc:'',NodeDr: '',NodeDesc:'',UserDr:'',UserDesc:'',SchtItmId:''}
	});
    
	$("#scheitmlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

///�����Ű���ϸ
function saveItmRow()
{
	if(editRow>="0"){
		$("#scheitmlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#scheitmlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].SchDesc=="")||(rowsData[i].SchDr=="")){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"���Ű�����Ϊ�գ�"); 
			return false;
		}
		if((rowsData[i].TypeDesc=="")||(rowsData[i].TypeDr=="")){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"��������Ϊ�գ�"); 
			return false;
		}
		if((rowsData[i].NodeDesc=="")||(rowsData[i].NodeDr=="")){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�й�����λΪ�գ�"); 
			return false;
		}
		/*if((rowsData[i].UserDesc=="")||(rowsData[i].UserDr=="")){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�й�����ԱΪ�գ�"); 
			return false;
		}*/
		var tmp=rowsData[i].SchtItmId +"^"+ rowsData[i].SchDr +"^"+ rowsData[i].TypeDr +"^"+ rowsData[i].NodeDr +"^"+ rowsData[i].UserDr;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//alert(params)
	//��������
	runClassMethod("web.DHCDISScheduleType","SaveSchItm",{"params":params},function(jsonString){
		
		if (jsonString == "0"){
			$('#scheitmlist').datagrid('reload'); //���¼���
		}
		
	});
}
/// ɾ��
function delItmRow(){
	
	var rowsData = $("#scheitmlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISScheduleType","DelSchItm",{"SchtItmId":rowsData.SchtItmId},function(jsonString){
					$('#scheitmlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
