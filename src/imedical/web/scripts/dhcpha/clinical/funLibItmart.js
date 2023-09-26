
var editRow = "";     /// ��ǰ�༭�к�
var funLibItmID = ""; /// ���⺯������ĿID
var funLibItmType=""; /// ���⺯������Ŀtype   wangxuejian 2016-09-21
var arcColumns="";  //gai
var url = "dhcpha.clinical.action.csp"; 

/// ҳ���ʼ������
function initPageDefault(){
	
	funLibItmID=getParam("funLibItmID");
	funLibItmType=getParam("funLibItmType")
	initDataGrid();  ///  ҳ��DataGrid��ʼ����
	initBlButton();  ///  ҳ��Button ���¼�
	initColumns();   ///  ��ʼ��datagrid�б� 
}
/// ��ʼ��datagrid�б�  
function initColumns(){
	
	arcColumns = [[
	    {field:'itmDesc',title:'ҽ��������',width:220},
	    {field:'itmCode',title:'ҽ�������',width:100},
	    //{field:'itmPrice',title:'����',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];
}

/// ҳ��DataGrid��ʼ����
function initDataGrid(){
	
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'itmID',title:'ItmID',width:100,hidden:true},
		{field:'itmCode',title:'��Ŀ����',width:100,editor:textEditor}, 
		{field:'itmDesc',title:'��Ŀ����',width:200,editor:textEditor},
		{field:'itmmastid',title:'itmmastid',width:100,editor:textEditor}
	]];
	
	///  ����datagrid
	var option = {
		title:'ҽ����Ŀ�б�',
		singleSelect : true,
		showPageList : false,
        onClickRow:function(rowIndex, rowData){
	    },	
	onLoadSuccess:function(data){
		},
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭     //**���ӿɱ༭�д���
            if (editRow != "") { 
                $("#dgItmList").datagrid('endEdit', editRow); 
            } 
            $("#dgItmList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
            itmUpdate(editRow)        //wangxuejian 2016-10-12
        }

	};

	var uniturl = url + "?action=QueryFunLibArt&params="+funLibItmID;
	new ListComponent('dgItmList', columns, uniturl, option).Init();
	 
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	///  ��ѯ
	$('a:contains("��ѯ")').bind("click",itmFind);
	
	///  ����
	$('a:contains("����")').bind("click",itmAdd);
	
	///  ɾ��
	$('a:contains("ɾ��")').bind("click",itmDel);
		
	///  ����
	$('a:contains("����")').bind("click",itmSave);

      //ͬʱ������������󶨻س��¼�        wangxuejian 2016-10-12
       $('#itmcode,#itmdesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            itmFind(); //���ò�ѯ
        }
    });
}

/// ��ѯ
function itmFind(){
	
	var itmCode = $("#itmcode").val();  /// ����
	var itmDesc = $("#itmdesc").val();  /// ����
	var params = funLibItmID +"^"+ itmCode +"^"+ itmDesc;
	$("#dgItmList").datagrid("reload",{"params":params});
}

/// ����
function itmAdd(){
	
	if(editRow>="0"){
		$("#dgItmList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#dgItmList").datagrid('insertRow', {//��ָ�����������ݣ�appendRow�������һ����������
		index: 0, // ������0��ʼ����
		row: {itmID: '',ItmCode:'',ItmDesc: ''}   //wangxuejian 2016-10-12
	});
	$("#dgItmList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	dataGridBindEnterEvent(0);  			 //���ûس��¼�
	editRow=0;
}

/// ����
function itmUpdate(index){               //wangxuejian 2016-10-12   
	$("#dgItmList").datagrid('beginEdit', index);//�����༭������Ҫ�༭����
	dataGridBindEnterEvent(index);  			 //���ûس��¼�
}

/// ��datagrid�󶨻س��¼�
function dataGridBindEnterEvent(index){
	
	var editors = $('#dgItmList').datagrid('getEditors', index);
	/// ����
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#dgItmList").datagrid('getEditor',{index:index, field:'itmDesc'});		
			if ($(ed.target).val() == ""){return;}
			var unitUrl = url+'?action=QueryArcItmDetail&hospId='+LgHospID+'&Input='+$(ed.target).val();   
			/// ����ҽ�����б�����
			new ListComponentWin($(ed.target), "", "600px", "" , unitUrl, arcColumns, setCurrEditRowCellVal).init();
		}
	});
}

/// ����ǰ�༭�и�ֵ
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#dgItmList').datagrid('getEditors', editRow);
		///ҩƷ����
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
		return;
	}
	///����
	var ed=$("#dgItmList").datagrid('getEditor',{index:editRow, field:'itmCode'});
	$(ed.target).val(rowObj.itmCode);
	///����
	var ed=$("#dgItmList").datagrid('getEditor',{index:editRow, field:'itmDesc'});		
	$(ed.target).val(rowObj.itmDesc);
	///ID
	var ed=$("#dgItmList").datagrid('getEditor',{index:editRow, field:'itmmastid'});		
	$(ed.target).val(rowObj.itmID);
	var rows = $('#dgItmList').datagrid('getRows');  //hezg ����ҩƷ����һ����
	for(var j=0;j<rows.length;j++){
		if(rowObj.itmID==rows[j].itmmastid){
			alert("ҩƷ�Ѵ���'"+rows[j].itmDesc+"',����������!")
			$.post(url+'?action=delFunLibArt',{"itmID":rowObj.itmID}, function(data){
					$('#dgItmList').datagrid('reload'); //���¼���
					$("#dgItmList").datagrid('loadData',{total:0,rows:[]}); 
				});
			
			}
		}
	
}

/// ɾ��
function itmDel(){
	
	var rows = $("#dgItmList").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=delFunLibArt',{"itmID":rows[0].itmID}, function(data){
					$('#dgItmList').datagrid('reload'); //���¼���
					$("#dgItmList").datagrid('loadData',{total:0,rows:[]});  //nisijia 2016-10-08 	
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ����
function itmSave(){
	
	if(editRow>="0"){
		$("#dgItmList").datagrid('endEdit', editRow);
	}

	var rows = $("#dgItmList").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++){
		if((rows[i].itmCode=="")||(rows[i].itmDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].itmID +"^"+ funLibItmID +"^"+ rows[i].itmmastid;   //wangxuejian 2016-10-12
		dataList.push(tmp);
	} 
	var ListData=dataList.join("&");

	//��������
	$.post(url+'?action=saveFunLibArt',{"ListData":ListData},function(data){
		$('#dgItmList').datagrid('reload'); //���¼���
	});
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })