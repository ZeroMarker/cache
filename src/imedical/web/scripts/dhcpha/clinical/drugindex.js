/// Creator: dws
/// CreateDate: 2017-06-01
//  Descript: ҩƷ����ָ��ά��

var editRow=""; editmuliRow=""; //��ǰ�༭�к�
var hospID=session['LOGON.HOSPID']
//����ָ����
var PartColumns = [[
	    {field:'IndexCode',title:'����',width:100},
	    {field:'TestCodeName',title:'����',width:150},
	]];
$(function(){
	DrugInfo(); //ҩƷ��Ϣ
	IndexInfo("");
	//��ѯҩƷ
	$("#find").on('click',function(){
		DrugInfo();
		$('#meduselinkitmdg').datagrid('loadData',{total:0,rows:[]});
	});
	//��������
	$("#insmuli").on('click',function(){
		insmuliRow();
	});
	//ɾ������
	$("#delmuli").on('click',function(){
		deleteRow();
	});
	//��������
	$("#savmuli").on('click',function(){
		savmuliRow();
	});
	
});

//ҩƷ��Ϣ
function DrugInfo(){
	var code=$("#code").val(); //����
	var desc=$("#desc").val(); //����
	$('#meduselinkdg').datagrid({
			url:"dhcapp.broker.csp?ClassName=web.DHCSTPHCMedIndexMonitoringInquiry&MethodName=DrugInfo",
			pageNumber:1, //�ӵ�һҳ��ʾ
			fit:true,
			striped: true, //�Ƿ���ʾ������Ч��	
			frozenColumns:true,  //fitColumns�Զ���ʼ����ȣ���Ҫ��frozenColumns�������У�һ��ʹ��
			loadMsg:'�������ڼ��أ������ĵȴ�', 
			rownumbers:true, //��ʾ�к�
			pagination:true, //��ʾ��ҳ������
			singleSelect:true, //��ѡ
			checkOnSelect:true, //����оͱ�ѡ��
			pageList : [40,80], // ��������ÿҳ��¼�������б�
			pageSize : 40 , // ÿҳ��ʾ�ļ�¼����
			
			columns:[[		  //������յ����ݸ�ʽ�����е�fieldҪ�ͺ�̨���ݹ��������Ӧ
				{field:'Code',title:'����',width:104},
				{field:'Desc',title:'����',width:400},
				{field:'Id',title:'ID',width:15,hidden:'true'}								
			]],
			queryParams:{
				code:code,
				desc:desc,
				hospID:hospID
			},
			onClickRow:function(rowIndex, rowData){ //���ҩƷ��ʾ��ص�ָ��
				IndexInfo(rowData.Id)
			}			
	});	
	
}		

//ָ����Ϣ
function IndexInfo(phdcDr){
	var editorText={
			type:'text',    
			options:{     
				required:true 
			}
	} 
	$('#meduselinkitmdg').datagrid({
			url:"dhcapp.broker.csp?ClassName=web.DHCSTPHCMedIndexMonitoringInquiry&MethodName=IndexInfo",
			pageNumber:1, //�ӵ�һҳ��ʾ
			fit:true,
			striped: true, //�Ƿ���ʾ������Ч��	
			fitColumns:false,  //�Զ���ʼ����ȣ���Ҫ��frozenColumns�������У�һ��ʹ��
			loadMsg:'�������ڼ��أ������ĵȴ�', 
			rownumbers:true, //��ʾ�к�
			pagination:true, //��ʾ��ҳ������
			singleSelect:true, //��ѡ
			checkOnSelect:true, //����оͱ�ѡ��
			pageList : [20,40], // ��������ÿҳ��¼�������б�
			pageSize : 20 , // ÿҳ��ʾ�ļ�¼����
			
			columns:[[		  //������յ����ݸ�ʽ�����е�fieldҪ�ͺ�̨���ݹ��������Ӧ
				{field:'IndexCode',title:'����',width:120,editor:editorText},
				{field:'TestCodeName',title:'����',width:300,editor:editorText},
				{field:'Id',title:'ID',hidden:true}							
			]],
			queryParams:{
				phdcDr:phdcDr
			},
			onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			if ((editmuliRow != "")||(editmuliRow == "0")) {
            	 $("#meduselinkitmdg").datagrid('endEdit', editmuliRow); 
			}    
            $("#meduselinkitmdg").datagrid('beginEdit', rowIndex); 
            editmuliRow = rowIndex; 
            //���ûس��¼�
            dataIndexGridBindEnterEvent(editmuliRow);
        }			
	});
	$('#meduselinkitmdg').datagrid('loadData',{total:0,rows:[]});	
}		


// ��������
function insmuliRow()
{
	var rows=$('#meduselinkdg').datagrid('getSelections')
	if(rows.length<=0){
		$.messager.alert("��ʾ","��ѡ��ҩƷ!");
		return;
	}
	if( editmuliRow>="0"){
		$("#meduselinkitmdg").datagrid('endEdit',  editmuliRow);//�����༭������֮ǰ�༭����
	}
	$("#meduselinkitmdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {IndexCode: '',TestCodeName:''}
	});
	$("#meduselinkitmdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editmuliRow=0;
	//���ûس��¼�
	dataIndexGridBindEnterEvent(editmuliRow);
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#meduselinkitmdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				var dgDr=$('#meduselinkdg').datagrid('getSelected').Id; //ѡ��ҩƷid
				var mdgDr=$('#meduselinkitmdg').datagrid('getSelected').Id; //ѡ��ҩƷid
				//alert(dgDr+"*"+mdgDr)
				runClassMethod("web.DHCSTPHCMedIndexMonitoringInquiry","DelIndex",{"phdcDr":dgDr,"testCodeDr":mdgDr},function(data){
					if(data==0){
						//$.messager.alert('��ʾ','ɾ���ɹ�');	
						$('#meduselinkitmdg').datagrid('reload'); //���¼���
					}
					else{
						$.messager.alert('��ʾ','ɾ��ʧ��');
					}
				},'text');
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function savmuliRow()
{
	var dgDr=$('#meduselinkdg').datagrid('getSelected').Id; //ѡ��ҩƷid 
	if( editmuliRow>="0"){
		$("#meduselinkitmdg").datagrid('endEdit',  editmuliRow);
	}
	var rows = $("#meduselinkitmdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].IndexCode=="")||(rows[i].TestCodeName=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}
		var tabId=rows[i].Id; //ָ���б���ָ��id,���idΪ�����������ݣ���ֵ���������
		//ָ���Ӧ��id
		var id=tkMakeServerCall("web.DHCSTPHCMedIndexMonitoringInquiry","GetIndexId",rows[i].IndexCode,rows[i].TestCodeName)
			var tmp=dgDr+"^"+id+"^"+tabId;
			dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&")
	//��������
	runClassMethod("web.DHCSTPHCMedIndexMonitoringInquiry","SaveDrugIndex",{"rowstr":rowstr},function(data){
		switch(data){
			case 0:
				$.messager.alert('��ʾ','�����ɹ�');
				break;
			case 3:
				$.messager.alert('��ʾ','�����ظ�,���ʵ������','warning');
				break;
			default:
				$.messager.alert('��ʾ','����ʧ��','warning');
				break;
		}
	});
	$('#meduselinkitmdg').datagrid('reload'); //���¼���
}

//���ûس��¼�
function dataIndexGridBindEnterEvent(editmuliRow){
	var editors = $('#meduselinkitmdg').datagrid('getEditors', editmuliRow);
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
	if (e.keyCode == 13) {
		var ed=$("#meduselinkitmdg").datagrid('getEditor',{index:editmuliRow, field:'TestCodeName'});		
		var input = $(ed.target).val();
		//if (input == ""){return;}
		var unitUrl = LINK_CSP+'?ClassName=web.DHCSTPHCMedIndexMonitoringInquiry&MethodName=GetAllIndexInfo&input='+$(ed.target).val();
		/// ����ָ���б���
		new ListComponentWin($(ed.target), input, "400px", "" , unitUrl, PartColumns, setCurrIndexEditRowCellVal).init();
		}
	});
	
}

//ѡ��ָ����Ϣ����ָ���б�
function setCurrIndexEditRowCellVal(rowObj){
	var ed=$("#meduselinkitmdg").datagrid('getEditor',{index:editmuliRow, field:'IndexCode'});
	$(ed.target).val(rowObj.IndexCode);
	var ed=$("#meduselinkitmdg").datagrid('getEditor',{index:editmuliRow, field:'TestCodeName'});		
	$(ed.target).val(rowObj.TestCodeName);
}