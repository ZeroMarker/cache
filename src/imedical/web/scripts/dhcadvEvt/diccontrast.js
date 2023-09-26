/// author:     sufan
/// date:       2020-02-20
/// descript:   �����¼���Ԫ�ض��ս���JS

var editRow = "";
var ConArray = [{"value":"0","text":'ͳ��'}, {"value":"1","text":'�ӿ�'}];

$(function(){
	
	InitCombobox()			//��ʼ��������
	
	InitdgMainList();		//��ʼ�����չ�ϵ�б�
	
	initBlButton();			//��ʼ�����水ť�¼�
})
///��ʼ������������
function InitCombobox()
{
	//���Ȳ���
	$('#formname').combobox({
		url:$URL+"?ClassName=web.DHCADVDicContrast&MethodName=jsonForm",
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
	})
	
}
/// ����Ԫ�ؼ����¼�
function initBlButton()
{

	///����
	$("#insert").bind("click",insertRow);
	
	///ɾ��
	$("#delete").bind("click",deleteRow);
	
	///����
	$("#save").bind("click",saveRow);
	
	///��ѯ
	$("#find").bind("click",search);
	
	///����
	$("#reset").bind("click",reset);
}

///��ʼ�������б�
function InitdgMainList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var dicclonms = [[
	    {field:'DicField',title:'Ԫ�ش���',width:120},
	    {field:'DicDesc',title:'Ԫ������',width:100}
	]];
	
	//����
	var ConEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:ConArray,
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				///��������ֵ
				/// Ԫ������
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ConFlag'});
				$(ed.target).combobox('setValue', option.text);
				/// Ԫ�ش���
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ConFlagCode'});
				$(ed.target).val(option.value);
				
				///һ�¼�������grid����
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FieldDesc'});
				$(ed.target).combogrid('grid').datagrid('load', {
                    type: option.value,
				});
			}
		}
	}
	
	/// ͳ��/�ӿ�Ԫ��
	var FieldEditor = {
		type:'combogrid',
		options:{
		    id:'DicField',
		    fitColumns:true,
		    fit: true,//�Զ���С  
			pagination : true,
			panelWidth:500,
			textField:'DicDesc',
			mode:'remote',
			url:$URL+'?ClassName=web.DHCADVDicContrast&MethodName=QueryAllFormItem',
			columns:dicclonms,
				onSelect:function(rowIndex, rowData) {
   					setAttrEditRowCellVal(rowData);
				}		   
			}
	}
	
	/// ��Combobox
	var FormEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVDicContrast&MethodName=jsonForm",
			mode:'remote',
			onSelect:function(option){
				///��������ֵ
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormNameDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormNameCode'});
				$(ed.target).val(option.code);
				///���ü���ָ��
				var FormID=option.value;  //Ԫ��
				var FormDicDesced=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormFieldDesc'});
				$(FormDicDesced.target).combobox('setValue', "");
				var unitUrl=LINK_CSP+"?ClassName=web.DHCADVDicContrast&MethodName=jsonFormDic&FormID="+FormID;
				$(FormDicDesced.target).combobox('reload',unitUrl);
				var FormDicCodeed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormFieldCode'});
				$(FormDicCodeed.target).val("");
			}
		}
	}
	
	/// �ֶ�Combobox
	var FormFieldEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonFormField",
			mode:'remote',
			onSelect:function(option){
				///��������ֵ
				/// Ԫ������
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormFieldDesc'});
				$(ed.target).combobox('setValue', option.text);
				/// Ԫ�ش���
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormFieldCode'});
				$(ed.target).val(option.code);
			}
		}
	}
	
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'ConFlagCode',title:'ConFlagCode',width:80,editor:textEditor,hidden:true},
		{field:'ConFlag',title:'ͳ��/�ӿ�',width:120,editor:ConEditor},
		{field:'FieldCode',title:'ͳ��/�ӿ�Ԫ�ش���',width:130,editor:textEditor},
		{field:'FieldDesc',title:'ͳ��/�ӿ�Ԫ��',width:180,editor:FieldEditor},
		{field:'FormNameCode',title:'������',width:100,editor:textEditor,hidden:true},
		{field:'FormNameDesc',title:'������',width:220,editor:FormEditor},
		{field:'FormFieldCode',title:'�¼�Ԫ�ش���',width:120,editor:textEditor},
		{field:'FormFieldDesc',title:'�¼�Ԫ��',width:180,editor:FormFieldEditor}
		
	]];
	/**
	 * ����datagrid
	 */
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	      
	    }
	};
	var uniturl = $URL+"?ClassName=web.DHCADVDicContrast&MethodName=QueryDicContrast&param=";
	new ListComponent('dgMainList', columns, uniturl, option).Init(); 
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
		
		if(rowsData[i].FieldCode==""){
			$.messager.alert("��ʾ","ͳ��/�ӿ�Ԫ�ش��벻��Ϊ��!"); 
			return false;
		}
		if(rowsData[i].FormNameCode==""){
			$.messager.alert("��ʾ","�����벻��Ϊ��!"); 
			return false;
		}
		if(rowsData[i].FormFieldCode==""){
			$.messager.alert("��ʾ","�¼�Ԫ�ش��벻��Ϊ��!"); 
			return false;
		}
		
		var tmp=rowsData[i].ID +"^"+ rowsData[i].FieldCode +"^"+ rowsData[i].FormNameCode +"^"+ rowsData[i].FormFieldCode +"^"+ rowsData[i].ConFlagCode;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCADVDicContrast","saveDicContrast",{"ListData":params},function(jsonString){

		if (jsonString == "-1"){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
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
		if (rowsData[0].aitCode == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', FieldCode:'', FieldDesc:'', FormNameCode:'', FormNameDesc:'',FormFieldCode:'', FormFieldDesc:'', FormDicCode:'', ConFlag:''}
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
				runClassMethod("web.DHCADVDicContrast","DelContrast",{"ConId":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
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

///dg�и�ֵ
function setAttrEditRowCellVal(rowObj)
{
	var ed=$("#dgMainList").datagrid('getEditor',{index:editRow, field:'FieldCode'});		
	$(ed.target).val(rowObj.DicField);
	var ed=$("#dgMainList").datagrid('getEditor',{index:editRow, field:'FieldDesc'});		
	$(ed.target).val(rowObj.DicDesc);
	
}

///��ѯ
function search()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var formname=$("#formname").combobox('getValue');
	var param=code+"^"+desc+"^"+formname;
	$('#dgMainList').datagrid('load',{param:param}); 
}

///����
function reset()
{
	$('#code').val("");
	$('#desc').val("");
	$("#formname").combobox('setValue',"");
	$('#dgMainList').datagrid('load',{param:""});
}