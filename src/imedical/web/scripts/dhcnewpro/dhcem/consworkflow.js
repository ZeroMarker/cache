/// Creator: qqa
/// CreateDate: 2019-12-09
//  Descript: ���﹤��������

var editRow=0;itmEditRow=0; itmAutEditRow=0,preEditRow=0, editDRow=-1; //��ǰ�༭�к�
var dataArrayNew = [{"value":"G","text":'��ȫ��'}, {"value":"L","text":'����'}, {"value":"U","text":'��Ա'}]; //hxy 2017-12-14
var dataArray = [{"value":"1","text":'��ȫ��'}, {"value":"2","text":'����'}, {"value":"3","text":'��Ա'}]; //, {"value":"4","text":'ȫԺ'}
var Active = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
var patTypeArray = [{"value":"O","text":'����'}, {"value":"E","text":'����'}, {"value":"I","text":'סԺ '}]; //hxy 2021-01-21
//var tabsid="";
$(function(){
	///��Ժ������
	MoreHospSetting("DHC_EmConsWorkFlow");
	
	initDatagrid();
	
   	initMethod();
   	
   	/// ���ʽ�����б�
   	initFnParamDG();
})

///��Ժ������
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = findMainTable;
}

function initDatagrid(){
	
	// �༭��
	var texteditor={
		type: 'validatebox',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// ҽԺ
	var hospEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCEMNurExecFormSet&MethodName=GetHospDs",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			},onChange:function(newValue,oldValue){
				if(newValue==""){
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'HospID'});
					$(ed.target).val(""); 	
				}
			}
	
		}
	}
	
	// ����columns
	var columns=[[
		{field:"Code",title:'����',width:150,editor:texteditor},
		{field:'Desc',title:'����',width:250,editor:texteditor},
		{field:"ID",title:'ID',width:70,align:'center',hidden:true},
		{field:'HospID',title:'HospID',width:100,editor:texteditor,hidden:true,align:'center'},
		{field:'HospDesc',title:'ҽԺ',width:200,editor:hospEditor,hidden:true,align:'center'}
	]];
	
	var HospID = $HUI.combogrid("#_HospList").getValue();
	
	var params = "^^"+HospID;
	
	// ����datagrid
	$('#main').datagrid({
		title:'���﹤��������-����������',
		url:$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListMain&Params="+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) {
            	$("#main").datagrid('endEdit', editRow); 
			}
            $("#main").datagrid('beginEdit', rowIndex);
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
			
			$('#mainItm').datagrid("load",{"Params":rowData.ID});
			$('#consPre').datagrid("load",{"Params":rowData.ID});
			$('#mainItmAut').datagrid("load",{"Params":""});
			$("#btParamsList").datagrid('load',{"ID":""}); //hxy 2021-12-22
        }
	});	
	
	/// ҽԺ
	var statusEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=GetStatusList&HospID="+LgHospID,
			//required:true,
			panelHeight:350,  //���������߶��Զ����� //hxy 2020-08-11 "auto"->350
			onSelect:function(option){
				///��������ֵ
				var ed=$("#mainItm").datagrid('getEditor',{index:editRow,field:'Status'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#mainItm").datagrid('getEditor',{index:editRow,field:'StatusDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	// ����columns  joe
	var columns=[[  
		{field:"Status",title:'״̬',width:310,editor:statusEditor},
		{field:"StatusDr",title:'״̬',width:110,editor:texteditor,hidden:true},
		{field:'pri',title:'���ȼ�',width:300,hidden:true,
				formatter:function(value,rec,index){
					var a = '<a href="#" mce_href="#" class="img icon-up" onclick="upclick(\''+ index + '\')"></a> ';
					var b = '<a href="#" mce_href="#" class="img icon-down" onclick="downclick(\''+ index + '\')"></a> ';
					return a+b;  
                    }  
		},
		{field:'OrderNo',title:'˳���',width:130,hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// ����datagrid
	$('#mainItm').datagrid({
		title:'��������Ŀ',
		url:$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListMainItm",
		fit:true,
		rownumbers:true,
		columns:columns,
		order:'asc',
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            $("#mainItm").datagrid('beginEdit', rowIndex); 
            itmEditRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
 			$('#mainItmAut').datagrid("load",{"Params":rowData.ID});
	    },
	  onLoadSuccess: function (data) {
	        
        }
	});
	

	//������Ϊ�ɱ༭
	var editPoint={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			valueField: "value",
			textField: "text",
			required:true,
			mode:'remote',  //��������������� 2017-08-01 cy �޸�������ģ������
			url: '',
			onSelect:function(option){
				var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PointID'});
				$(ed.target).val(option.value);  //���ÿ���ID
				var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
			}
		}
	}
	
	// ����columns joe
	var columnqx=[[
		{field:"ItmDr",title:'ItmDr',width:90,align:'center',hidden:true},
		{field:"ParRefDr",title:'ParRefDr',width:90,align:'center',hidden:true},
		{field:'TypeID',title:'TypeID',width:90,editor:'text',hidden:true},
		{field:"Type",title:'����',width:110,editor:texteditor,
			editor: {  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
				options: {
					data:dataArrayNew,  //dataArray hxy 2017-12-14
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //���������߶��Զ�����
					required:true,
					onSelect:function(option){
						///��������ֵ
						var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'TypeID'});
						$(ed.target).val(option.value);  //���ÿ���ID
					
						var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Type'});
						$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
						
						///����PointID 
						var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PointID'});
						$(ed.target).val("");
						var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Pointer'});
						var HospID = $HUI.combogrid("#_HospList").getValue();
						var url=$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListPointer&Type="+option.value+"&InHospID="+HospID;
						$(ed.target).combobox('setValue',"");  
						$(ed.target).combobox('reload',url);
					}  
				}
			}
		},
		{field:'Pointer',title:'ָ��',width:300,editor:editPoint},
		{field:'PointID',title:'PointID',width:130,editor:'text',hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// ����datagrid
	$('#mainItmAut').datagrid({
		title:'Ȩ������',
		url:$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListMainItmAut",
		fit:true,
		rownumbers:true,
		columns:columnqx,  //�����
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((itmAutEditRow != "")||(itmAutEditRow == "0")) {
	            
            	$("#mainItmAut").datagrid('endEdit', itmAutEditRow);
			}
            $("#mainItmAut").datagrid('beginEdit', rowIndex); 
            itmAutEditRow = rowIndex; 
            
            ///����PointID 
			var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'TypeID'});
			var TypeID = $(ed.target).val();
			var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Pointer'});
			
			var HospID = $HUI.combogrid("#_HospList").getValue();
			var url=$URL+"?ClassName=web.DHCEMConsWorkFlow&MethodName=QryListPointer&Type="+TypeID+"&InHospID="+HospID;  
			$(ed.target).combobox('reload',url);
        }
	});
	
	
	var funEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCEMConsPreCon&MethodName=GetPreList&HospID="+LgHospID,
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#consPre").datagrid('getEditor',{index:preEditRow,field:'Fun'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#consPre").datagrid('getEditor',{index:preEditRow,field:'FunDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	
	// ����columns  joe
	var columns=[[  
		{field:"Fun",title:'���ʽ',width:310,editor:funEditor},
		{field:"FunDr",title:'���ʽID',width:110,editor:texteditor,hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// ����datagrid
	$('#consPre').datagrid({
		title:'ǰ���������ʽ',
		url:$URL+"?ClassName=web.DHCEMConsPreCon&MethodName=QryListPreCon",
		fit:true,
		rownumbers:true,
		columns:columns,
		order:'asc',
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	   		if ((preEditRow != "")||(preEditRow == "0")) {
            	$("#consPre").datagrid('endEdit', preEditRow); 
			}
            $("#consPre").datagrid('beginEdit', rowIndex);
           preEditRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	        /// �����б�
			$("#btParamsList").datagrid('reload',{ID:rowData.ID});
	    },
	  onLoadSuccess: function (data) {
	        
        }
	});
	
}

/// ��ʼ�����ʽ�����б� bianshuai 2021-01-11
function initFnParamDG(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ������༭
	var DGEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp&Type=DOC^PHA",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onShowPanel: function(){
				var rowData = $("#consPre").datagrid("getSelected");
				if(rowData.Fun=="��������"){
					var ed=$("#btParamsList").datagrid('getEditor',{index:editDRow,field:'Desc'});
					$(ed.target).combobox('clear');//�������ֵ
					$(ed.target).combobox('loadData',patTypeArray);
				}else if(rowData.Fun!="ҽ������"){
					var ed=$("#btParamsList").datagrid('getEditor',{index:editDRow,field:'Desc'});
					$(ed.target).combobox('clear');//�������ֵ
					$(ed.target).combobox('loadData',"[]");
					$.messager.alert("��ʾ","�ñ��ʽ����ά������!"); 
				}
			},
			onSelect:function(option){
				var ed=$("#btParamsList").datagrid('getEditor',{index:editDRow,field:'Desc'});
				$(ed.target).combobox('setValue', option.text);
			} 
		}
	}

		
	///  ����columns
	var columns=[[
		//{field:'Desc',title:'����',width:300,editor:textEditor},
		{field:'Desc',title:'����',width:300,editor:DGEditor},
		{field:'ID',title:'id',width:80,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		title:'����',
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		pageSize : [100],
		pageList : [100,200],
		border : true,
		onDblClickRow: function (rowIndex, rowData) {
			if ((editDRow != "")||(editDRow == "0")) { 
                $("#btParamsList").datagrid('endEdit', editDRow); 
            } 
            $("#btParamsList").datagrid('beginEdit', rowIndex); 
            editDRow = rowIndex;
        }
	};
	/// ��������
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCEMConsPreCon&MethodName=ListExpParams";
	new ListComponent('btParamsList', columns, uniturl, option).Init(); 
}

function initMethod(){
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
   
    $('#mainItmInsert').bind('click',itmInsertRow); 
    $('#mainItmDelet').bind('click',itmDeletRow);
    $('#mainItmSave').bind('click',itmSave);	
    
    //��ť���¼�
    $('#itmAutInsert').bind('click',itmAutInsertRow); 
    $('#itmAutDelet').bind('click',itmAutDeletRow);
    $('#itmAutSave').bind('click',itmAutSaveRow);
    
    $('#preInsert').bind('click',insertPreRow); 
    $('#preDelet').bind('click',deletePreRow);
    $('#preSave').bind('click',savePreRow);
    
    $("#find").bind('click',findMainTable);
}

// ��������
function insertRow()
{	
	if(editRow>=0){ //hxy 2020-08-11 =
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#main").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")||(rows[i].EventType=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}		
	} 
	
	var HospID = $HUI.combogrid("#_HospList").getValue();
	$("#main").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: '',HospID:HospID,HospDesc:HospID}
	});
	
	$("#main").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsWorkFlow","delete",{"ID":rowsData.ID},function(jsonString){
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

// ����༭��
function saveRow()
{
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rows = $("#main").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}		
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].HospID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//��������
	runClassMethod("web.DHCEMConsWorkFlow","save",{"mParam":rowstr},function(jsonString){

		if ((jsonString == "1")||(jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
	})
}


// ��ѯ
function findEventtype()
{
	//var adrEventType=$('#eventtype').val();
	//lvpeng(��)  2017-12-05 
	var adrEventType=$('#eventtype').combobox('getText')=="ȫ��"?"":$('#eventtype').combobox('getText');  //������  2016-07-14
	var params=adrEventType;
	$('#main').datagrid('load',{params:params}); 
}

// ��������
function itmInsertRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���������¼��",'warning'); 
		return false;
	}
	
	if(itmEditRow>=0){ //hxy 2020-08-11 =
		
		$("#mainItm").datagrid('endEdit', itmEditRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#mainItm").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].StatusDr==""){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!",'warning'); 
			return false;
		}
	} 
	$("#mainItm").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',StatusDr:'',Status: ''}
	});
	
	$("#mainItm").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	itmEditRow=0;
}

// ɾ��ѡ����
function itmDeletRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	var mID = rowsData.ID;
	var rowsData = $("#mainItm").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsWorkFlow","deleteItm",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#mainItm').datagrid('load',{Params:mID}); //���¼���
					$('#mainItmAut').datagrid("load",{"Params":""}); //���¼��� hxy 2021-07-13
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function itmSave()
{
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���������¼��",'warning'); 
		return false;
	}
	var mID = rowsData.ID;
	
	if(itmEditRow>=0){
		$("#mainItm").datagrid('endEdit', itmEditRow);
	}
	var rows = $("#mainItm").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!",'warning');
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(mID==""){
			$.messager.alert("��ʾ","��ѡ��һ��������!",'warning'); 
			return false;
		}
		
		if(rows[i].StatusDr==""){
			$.messager.alert("��ʾ","״̬����Ϊ�գ�",'warning'); 
			return false;
		}
		
		var tmp=rows[i].ID+"^"+mID+"^"+rows[i].StatusDr+"^"+rows[i].Status; //hxy 2020-08-05 rows[i].Status
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$")
	
	//��������
	runClassMethod("web.DHCEMConsWorkFlow","saveItm",{"mParam":rowstr},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','״̬�ظ�,���ʵ�����ԣ�','warning'); //hxy 2020-03-12 ԭ:����
			return;	
		}/*else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}*/
		$('#mainItm').datagrid('load',{Params:mID}); //���¼���
	})
	
}

// ��������
function itmAutInsertRow()
{
	var rowsData = $("#mainItm").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","����ѡ��������Ŀ��",'warning'); 
		return false;
	}
	
	if(itmAutEditRow>="0"){
		
		$("#mainItmAut").datagrid('endEdit', itmAutEditRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#mainItmAut").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!",'warning'); 
			return false;
		}
	} 
	$("#mainItmAut").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',TypeID:'',PointID: ''}
	});
	$("#mainItmAut").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	itmAutEditRow=0;
}


// ɾ��ѡ����
function itmAutDeletRow()
{
	
	var rowsData = $("#mainItm").datagrid('getSelected'); //ѡ��Ҫɾ������
	var mItmID = rowsData.ID;
	var rowsData = $("#mainItmAut").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsWorkFlow","deleteItmAut",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#mainItmAut').datagrid('load',{Params:mItmID}); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
	
}

// ����༭��
function itmAutSaveRow()
{
	
	var rowsData = $("#mainItm").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ����Ȩ��Ŀ��",'warning'); 
		return false;
	}
	var mItmID = rowsData.ID;
	
	if(itmAutEditRow>="0"){
		$("#mainItmAut").datagrid('endEdit', itmAutEditRow);
	}

	var rows = $("#mainItmAut").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!",'warning');
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		if(mItmID==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ����Ŀ!",'warning'); 
			return false;
		}
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!",'warning'); 
			return false;
		}
		
		var tmp=rows[i].ID+"^"+mItmID+"^"+rows[i].TypeID+"^"+rows[i].PointID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	
	//��������
	runClassMethod("web.DHCEMConsWorkFlow","saveAutItm",{"mParam":rowstr},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#mainItmAut').datagrid('load',{Params:mItmID}); //���¼���
	})
	
}

function findMainTable(){
	var mainCode=$("#mainCode").val();
	var mainDesc = $("#mainDesc").val();
	var HospID = $HUI.combogrid("#_HospList").getValue();
	
	var params = mainCode+"^"+mainDesc+"^"+HospID;
	$('#main').datagrid("load",{"Params":params});
	$('#mainItm').datagrid("load",{"Params":""});
	$('#mainItmAut').datagrid("load",{"Params":""});
	$('#consPre').datagrid("load",{"Params":""});
	return;
}




// ��������
function insertPreRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���������¼��",'warning'); 
		return false;
	}
		
	if(preEditRow>=0){ //hxy 2020-08-11 add 0
		$("#consPre").datagrid('endEdit', preEditRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#consPre").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Fun=="")||(rows[i].FunDr=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!",'warning'); 
			return false;
		}		
	} 
	$("#consPre").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		
		index: 0, // ������0��ʼ����
		row: {ID: '',Fun:'',FunDr: ''}
	});
	
	$("#consPre").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	preEditRow=0;
}

// ɾ��ѡ����
function deletePreRow()
{
	var rowsData = $("#consPre").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsPreCon","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#consPre').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function savePreRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���������¼��"); 
		return false;
	}
	var mID = rowsData.ID;
	
	if(preEditRow>="0"){
		$("#consPre").datagrid('endEdit', preEditRow);
	}
	
	var rows = $("#consPre").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Fun=="")||(rows[i].FunDr=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}		
		var tmp=rows[i].ID+"^"+mID+"^"+rows[i].FunDr;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//��������
	runClassMethod("web.DHCEMConsPreCon","save",{"mParam":rowstr},function(jsonString){
		
		if(jsonString=="-1"){ //hxy 2020-08-10
			$.messager.alert('��ʾ','�ñ��ʽ�Ѵ���','warning');
			return;	
		}
		
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#consPre').datagrid('reload'); //���¼���
	})
}

var eventwfitmdg;
//����
function upclick(index)
{
     var newrow=parseInt(index)-1 
	 var curr=$("#mainItm").datagrid('getData').rows[index];
	 var currowid=curr.ID;
	 var currordnum=curr.OrderNo;
	 var up =$("#mainItm").datagrid('getData').rows[newrow];
	 var uprowid=up.ID;
     var upordnum=up.OrderNo;

	 var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
     SaveUp(input);
	 mysort(index, 'up', 'eventwfitmdg');
	
}
//����
function downclick(index)
{

	 var newrow=parseInt(index)+1 ;
	 var curr=$("#mainItm").datagrid('getData').rows[index];
	 var currowid=curr.ID;
	 var currordnum=curr.OrderNo;
	 var down =$("#mainItm").datagrid('getData').rows[newrow];
	 var downrowid=down.ID;
     var downordnum=down.OrderNo;

	 var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
     SaveUp(input);
	 mysort(index, 'down', 'eventwfitmdg');
}
function SaveUp(input)
{
	 $.post(url+'?action=UpdEventWorkFlowItmNum',{"input":input},function(data){
	});
	 
}
function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}
//���༭���Ƿ�༭��ȫ 2018-07-18 cy
function CheckEdit(id,index){
	var flag=0;
	var editors = $('#'+id).datagrid('getEditors', index); 
	for (i=0;i<editors.length;i++){
		if(((editors[i].type=="validatebox")&&(editors[i].target.val()==""))|| ((editors[i].type=="text")&&(editors[i].target.val()==""))||((editors[i].type=="combobox")&&(editors[i].target.combobox('getText')==""))){
			flag=-1;
			return flag;	
		}
	}
	return flag; 
} 
//YNת���Ƿ�
function formatLink(value,row,index){
	if (value=='Y'){
		return '��';
	} else {
		return '��';
	}
}

/// ���� bianshuai 2020-12-30
function savePar(){
	
	if(editDRow >= 0){
		$("#btParamsList").datagrid('endEdit', editDRow);
	}

	var rowData = $("#consPre").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ����ʽ!");
		return;
	}
	var ID = rowData.ID;
	
	var rowsData = $("#btParamsList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	/// ��ȡ��
	var rowsData = $("#btParamsList").datagrid('getChanges'); //var rowsData = $("#btParamsList").datagrid('getRows');
	var itemArr = []; 
	var delArr = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].Desc==""){
			$.messager.alert("��ʾ","��������Ϊ��!"); 
			return false;
		}
		itemArr.push(rowsData[i].Desc);
		if((rowsData[i].Desc!="")&&(rowsData[i].Desc!=rowsData[i].OldDesc)){
			delArr.push(rowsData[i].OldDesc);
		}
	}
	
	var Params=itemArr.join(",");
	var DelParams=delArr.join(",");

	//��������
	runClassMethod("web.DHCEMConsPreCon","InsExpParam",{"ID":ID, "Params":Params,"DelParams":DelParams},function(jsonString){

		$('#btParamsList').datagrid('reload'); //���¼���
	})
}

/// ɾ�� bianshuai 2020-12-30
function cancelPar(){
	
	var rowsData = $("#btParamsList").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	
	$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//hxy 2022-10-11 ��ʾ�Ƿ�ɾ��
		if (res) {
			var row =$("#btParamsList").datagrid('getSelected');     
		 	runClassMethod("web.DHCEMConsPreCon","DelExpParam",{'ID':row.ID,"Desc":row.Desc},function(data){ $('#btParamsList').datagrid('load'); })
		 	return;
			// ��ȡ��ѡ���е����� index
			var rowIndex = $("#btParamsList").datagrid('getRowIndex',rowsData);
			
			$('#btParamsList').datagrid('deleteRow',rowIndex);
			
			savePar(); /// ����
		}
	})
}

/// ������ bianshuai 2020-12-30
function addParRow(){
	
	if(editDRow >= "0"){
		$("#btParamsList").datagrid('endEdit', editDRow);//�����༭������֮ǰ�༭����
	}
	
	var rowData = $("#consPre").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ����ʽ!");
		return;
	}
	if (rowData.FunExp.indexOf("get") == "-1") {
		$.messager.alert("��ʾ","��ǰ�����������������Ӳ���!","warning");
		return;
	}
	
	var ID = rowData.ID;           /// ����ĿID
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#btParamsList").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Desc == ""){
			$('#btParamsList').datagrid('selectRow',0);
			$("#btParamsList").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#btParamsList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:ID, Desc:''}
	});
	$("#btParamsList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editDRow=0;

}

