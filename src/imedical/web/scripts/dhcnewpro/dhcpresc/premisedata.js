/// Creator:yuliping
/// CreateDate: 2022-06-09
//  Descript: ��ǰ������

var editRow=0;itmEditRow=0; itmAutEditRow=0,preEditRow=0, editDRow=-1; //��ǰ�༭�к�
var Active = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
var patTypeArray = [{"value":"O","text":'����'}, {"value":"E","text":'����'}, {"value":"I","text":'סԺ '}]; //  2021-01-21
var TypeLimit ="Constant"

//var tabsid="";
var valueEditor={}
$(function(){
	
	initDatagrid();
	
   	initMethod();
   	
})


function initDatagrid(){
	$("#HospList").combobox({
		url:$URL+"?ClassName=web.DHCPRESCPremiseName&MethodName=GetHospDs",
		})
	// �༭��
	var texteditor={
		type: 'text'//���ñ༭��ʽ
	}
	
	/// ҽԺ
	var hospEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			required: true,
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCPRESCPremiseName&MethodName=GetHospDs",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hosp'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospId'});
				$(ed.target).val(option.value); 
			},onChange:function(newValue,oldValue){
				if(newValue==""){
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospId'});
					$(ed.target).val(""); 	
				}
			}
	
		}
	}
		/// ҽԺ
	var moduleEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			required: true,
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCPRESCPremiseName&MethodName=ListCaseData",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'module'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'moduleId'});
				$(ed.target).val(option.value); 
			}
	
		}
	}
	var activeEditor = {
			type: 'combobox',//���ñ༭��ʽ
			options: {
			required: true,
			valueField: "value", 
			textField: "text",
			data:Active
			}
		}
	// ����columns
	var columns=[[
		{field:"code",title:'����',width:150,editor:{type:'validatebox',options:{required:true}}},
		{field:'hospId',title:'HospID',width:100,editor:texteditor,hidden:true,align:'center'},
		{field:'hosp',title:'ҽԺ',width:230,editor:hospEditor},
		{field:'module',title:'ģ��',width:100,editor:moduleEditor},
		{field:'moduleId',title:'ģ��',width:200,hidden:true,editor:texteditor},
		{field:'active',title:'�Ƿ����',width:100,editor:activeEditor,formatter:getActive},
		{field:"Id",title:'Id',width:70,align:'center',hidden:true},

	]];
	
	var HospID = $HUI.combogrid("#HospList").getValue();
	
	var params = "^"+HospID;
	function getActive(value)
	{
			if(value=="Y")
			{
				return "��"	
			}else if(value=="N")
			{
				return "��"		
			}
	}
	
	// ����datagrid
	$('#main').datagrid({
		title:'ǰ�����ƶ���',
		url:$URL+"?ClassName=web.DHCPRESCPremiseName&MethodName=ListData&Params="+params,
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
			$('#mainItm').datagrid("load",{"ID":rowData.Id});
			$('#mainItmAut').datagrid("load",{"ID":""});
        }
	});	
	/// �ֵ�
	var statusEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			required: true,
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCPRESCPremiseDic&MethodName=ListDataCombox",
			//required:true,
			panelHeight:350,  //���������߶��Զ����� //  2020-08-11 "auto"->350
			onSelect:function(option){
				///��������ֵ
				var ed=$("#mainItm").datagrid('getEditor',{index:editRow,field:'Dic'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#mainItm").datagrid('getEditor',{index:editRow,field:'DicDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	var OpEditor={
		type: 'combobox',//���ñ༭��ʽ
		options: {
			required: true,
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":'����'}, {"value":"N","text":'������'}]
		}
		}
	// ����columns  joe
	var columns=[[  
		{field:"NameDr",title:'����ָ��',width:30,editor:texteditor,hidden:true},
		{field:"Dic",title:'�ֵ�',width:260,editor:statusEditor},
		{field:"DicDr",title:'�ֵ�ID',width:100,editor:texteditor,hidden:true},
		{field:"PPNOp",title:'�����',width:260,editor:OpEditor,
				formatter:function(value,rec,index){
					if(value=="Y"){
						return "����";
					}else if(value=="N"){
						return "������";
					}else{
						return "";
						}
                    }  
		},
		{field:"type",title:'type',width:30,editor:texteditor,hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',editor:texteditor,hidden:true}
	]];
	
	// ����datagrid
	$('#mainItm').datagrid({
		title:'ǰ�ᶨ��',
		url:$URL+"?ClassName=web.DHCPRESCPremiseNode&MethodName=ListData",
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
 			$('#mainItmAut').datagrid("load",{"ID":rowData.ID});
 			runClassMethod("web.DHCPRESCPremiseDic","getUrl",{"Id":rowData.DicDr},function(ret){
	 			setEditor(ret)
	 			},"text")
 			
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
			mode:'remote',  
			url: '',
			onSelect:function(option){
				var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PointID'});
				$(ed.target).val(option.value);  //���ÿ���ID
				var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
			}
		}
	}
	
	// ����columns 
	var columnqx=[[
		{field:"PPDNodeDr",title:'PPDNodeDr',width:90,hidden:true},
		{field:"PPDValue",title:'����/ָ�루��ʼ���ڣ�',width:120,editor:valueEditor},
		{field:'PPDNameDr',title:'PPDNameDr',width:90,editor:'text',hidden:true},
		{field:"PPDName",title:'����',width:110,hidden:true},
		{field:'PPDLimit',title:'������Χ',width:120,editor:texteditor},
		{field:'PPDStTime',title:'��ʼʱ��',width:100,editor:texteditor},
		{field:'PPDEdTime',title:'����ʱ��',width:100,editor:texteditor},
		{field:'PPDType',title:'����',width:90,editor:'text'},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// ����datagrid
	$('#mainItmAut').datagrid({
		title:'Ȩ������',
		url:$URL+"?ClassName=web.DHCPRESCPremiseData&MethodName=ListData",
		fit:true,
		rownumbers:true,
		columns:columnqx,  //
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            $("#mainItmAut").datagrid('beginEdit', rowIndex); 
            itmAutEditRow = rowIndex; 
        }
	});

}


function initMethod(){
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
   
    $('#mainItmInsert').bind('click',itmInsertRow); 
    $('#mainItmDelet').bind('click',itmDeletRow);
    $('#mainItmSave').bind('click',itmSave);	
    
    $('#itmAutInsert').bind('click',itmAutInsertRow); 
    $('#itmAutDelet').bind('click',itmAutDeletRow);
    $('#itmAutSave').bind('click',itmAutSaveRow);
    
    $('#find').bind('click',queryMain);
    
    $('#mainCode').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            queryMain(); //���ò�ѯ
        }
    });
    
}

//ǰ���ֵ��ȡά������������
function setEditor(url){
	
	var mainData = $("#main").datagrid("getSelected");
	var hospId = mainData.hospId;
	// �༭��
	var texteditor={
		type: 'text'//���ñ༭��ʽ
	}
		
	var dateEditor={
		type: 'datebox'//���ñ༭��ʽ
		
	}
	var timeEditor={
		type: 'timespinner'//���ñ༭��ʽ
		}
	if(url=="Time"){
		TypeLimit="TimeInputLimit"
		var valueEditor=dateEditor;			//��ʼ����
		var endLimitEditor = dateEditor; //������Χ ��������
	}else{
		TypeLimit ="Constant"
		var endLimitEditor =texteditor;
		var valueEditor={
			type: 'combobox',     //���ñ༭��ʽ
			options: {
				valueField: "value",
				textField: "text",
				required:true,
				url:$URL+"?ClassName="+url+"&hospId="+hospId,
				mode:'remote',  
					onSelect:function(option){
					var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PPDValue'});
					$(ed.target).val(option.text);  //���ÿ���ID
					var ed=$("#mainItmAut").datagrid('getEditor',{index:itmAutEditRow,field:'PPDValueId'});
					$(ed.target).val(option.value);  //���ÿ���ID
				}

			}
		}
	}

		var columnqx=[[
		{field:"PPDNodeDr",title:'PPDNodeDr',width:90,hidden:true},
		{field:"PPDValueId",title:'PPDValueId',width:90,hidden:true,editor:texteditor},
		{field:"PPDValue",title:'����/ָ�루��ʼ���ڣ�',width:160,editor:valueEditor},
		{field:'PPDNameDr',title:'PPDNameDr',width:90,editor:'text',hidden:true},
		{field:"PPDName",title:'����',width:100,hidden:true},
		{field:'PPDLimit',title:'������Χ',width:120,editor:texteditor},
		{field:'PPDStTime',title:'��ʼʱ��',width:100,editor:timeEditor},
		{field:'PPDEdTime',title:'����ʱ��',width:100,editor:timeEditor},
		{field:'PPDType',title:'����',width:80,editor:'text'},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// ����datagrid
	$('#mainItmAut').datagrid({
		columns:columnqx,  
	})
}
// ��������
function insertRow()
{	
	if(editRow>=0){ //  2020-08-11 =
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#main").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")||(rows[i].EventType=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!",'info'); 
			return false;
		}		
	} 
	
	var HospID = $HUI.combogrid("#HospList").getValue();
	$("#main").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		
		index: 0, // ������0��ʼ����
		row: {Id: '',code:'',hospId:LgHospID,hosp:LgHospID,module:'',moduleId:''}
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
				runClassMethod("web.DHCPRESCPremiseName","delete",{"ID":rowsData.Id},function(jsonString){
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
///��ѯǰ����������
function queryMain()
{
	var mainCode = $('#mainCode').val();
	var hospId = $('#HospList').combobox('getValue');
	var params=mainCode+"^"+hospId;
	$('#main').datagrid('load',{Params:params});
	
}
// ����༭��
function saveRow()
{	
	if(editRow>=0){ 
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
		
	}
	var rows = $("#main").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!",'warning');
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].code=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!",'warning'); 
			return false;
		}		
		var tmp=rows[i].code+"^"+rows[i].hospId+"^"+rows[i].moduleId+"^"+rows[i].active+"^"+rows[i].Id;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//��������
	runClassMethod("web.DHCPRESCPremiseName","save",{"params":rowstr},function(jsonString){

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

// ��������
function itmInsertRow()
{
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���������¼��",'warning'); 
		return false;
	}
	if(itmEditRow>=0){ //  2020-08-11 =
		$("#mainItm").datagrid('endEdit', itmEditRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#mainItm").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Name=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!",'warning'); 
			return false;
		}
	} 
	$("#mainItm").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Dic:'',PPNOp:''}
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
				runClassMethod("web.DHCPRESCPremiseNode","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}else{
						$.messager.alert('��ʾ','ɾ���ɹ���','success');
					}

					$('#mainItm').datagrid('reload'); //���¼���
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
	var mID = rowsData.Id;
	if((itmEditRow!=="")&&(itmEditRow>=0)){
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
		
		if((rows[i].DicDr=="")||(rows[i].PPNOp=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!��",'warning'); 
			return false;
		}
		
		var tmp=mID+"^"+rows[i].DicDr+"^"+rows[i].PPNOp+"^"+rows[i].ID ; //  2020-08-05 rows[i].Status
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$")
	
	//��������
	runClassMethod("web.DHCPRESCPremiseNode","save",{"params":rowstr},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','��ǰ���ظ���������¼�룡','warning'); 
			return;	
		}else{
			$.messager.alert('��ʾ',"����ɹ�",'success')
			}/*else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}*/
		$('#mainItm').datagrid('load',{"ID":mID}); //���¼���
	})
	
}

// ��������
function itmAutInsertRow()
{
	var rowsData = $("#mainItm").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ","����ѡ��ǰ�ᣡ",'warning'); 
		return false;
	}
	
	if(itmAutEditRow>="0"){
		
		$("#mainItmAut").datagrid('endEdit', itmAutEditRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#mainItmAut").datagrid('getChanges');
	/*for(var i=0;i<rows.length;i++)
	{
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!",'warning'); 
			return false;
		}
	} */
	$("#mainItmAut").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',PPDValue:'',PPDType:TypeLimit}
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
				runClassMethod("web.DHCPRESCPremiseData","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#mainItmAut').datagrid('load',{ID:mItmID}); //���¼���
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
	var NameDr= rowsData.NameDr;
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
			$.messager.alert("��ʾ","��ѡ����Ҫ�༭��ǰ��!",'warning'); 
			return false;
		}
		if((rows[i].PPDType=="")||($.trim(rows[i].PPDValue)=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!",'warning'); 
			return false;
		}
		if(rows[i].PPDType=="Constant"){
			rows[i].PPDValue = rows[i].PPDValueId;
		}
		var tmp=mItmID+"^"+rows[i].PPDValue+"^"+NameDr+"^"+rows[i].PPDLimit+"^"+rows[i].PPDStTime+"^"+rows[i].PPDEdTime+"^"+rows[i].PPDType+"^"+rows[i].ID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//��������
	runClassMethod("web.DHCPRESCPremiseData","save",{"params":rowstr},function(jsonString){

		if (jsonString >= "0"){
			$.messager.alert('��ʾ','����ɹ���','success');
		}else if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#mainItmAut').datagrid('load',{ID:mItmID}); //���¼���
	})
	
}


//datagrid ʱ��ؼ��༭����չ
$.extend($.fn.datagrid.defaults.editors, {
    timespinner: {
        init: function (container, options) {
            var input = $('<input class = "easyui-timespinner" style="width:90px;"/>').appendTo(container);
            var options={
	            onChange:function(value){
		            $(this).timespinner('setValue', value);
		            }
	            }
            input.timespinner(options);
            return input
        },
        getValue: function (target) {
            var val = $(target).timespinner('getValue');
            return val;
        },
        setValue: function (target, value) {
	        
            $(target).timespinner('setValue', value);
        },
        resize: function (target, width) {
            var input = $(target);
            if ($.boxModel == true) {
                input.resize('resize', width - (input.outerWidth() - input.width()));
            } else {
                input.resize('resize', width);
            }
        }
    }
});
