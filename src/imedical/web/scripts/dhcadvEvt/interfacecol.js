/// author:     sufan
/// date:       2020-02-20
/// descript:   �����¼���Ԫ�ض��ս���JS

var editRow = "",HospDr="";
$(function(){
    InitHosp(); 	//��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
	InitdgMainList();		//��ʼ�����չ�ϵ�б�
	
	initBlButton();			//��ʼ�����水ť�¼�
})
// ��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvInterfaceCol"); 
	HospDr=hospComp.getValue(); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///ѡ���¼�
		HospDr=hospComp.getValue();
		search(); 
	}
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
	
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:"HospDr",title:'ҽԺid',width:90,align:'center',hidden:true},
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'����',width:180,editor:textEditor},
		{field:'Desc',title:'����',width:200,editor:textEditor},
		
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
	var uniturl = $URL+"?ClassName=web.DHCADVInterfaceCol&MethodName=QueryIntCol&param="+"&HospDr="+HospDr;
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
		
		if(rowsData[i].Code==""){
			$.messager.alert("��ʾ","���벻��Ϊ��!"); 
			return false;
		}
		if(rowsData[i].Desc==""){
			$.messager.alert("��ʾ","��������Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc+"^"+rowsData[i].HospDr;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");
	
	//��������
	runClassMethod("web.DHCADVInterfaceCol","SaveIntCol",{"params":params},function(jsonString){

		if ((jsonString == -1)||(jsonString == -3)){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
		}
		if ((jsonString == -2)||(jsonString == -4)){
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
		row: {ID:'', Code:'', Desc:'',HospDr:HospDr}
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
				runClassMethod("web.DHCADVInterfaceCol","DelIntCol",{"AFCRowID":rowsData.ID},function(jsonString){
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
	var param=code+"^"+desc;
	$('#dgMainList').datagrid('load',{params:param,HospDr:HospDr}); 
}

///����
function reset()
{
	$('#code').val("");
	$('#desc').val("");
	$('#dgMainList').datagrid('load',{param:"",HospDr:HospDr});
}
