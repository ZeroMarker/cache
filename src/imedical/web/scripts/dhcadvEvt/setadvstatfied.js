//qqa
//2017-12-14
;$(function(){

	initParams();
	
	initCombobx();
	
	initDatagrid();
	
	initBindMethod();
})

function initParams(){
	
	formNameID = "";
	
	editRow="";	
	
	///ȫ�ֱ�������̬���ı༭��
	formDicIDEditor={  
		type: 'combobox',
		options: {
			data:[],       //## ���λ�û�ȡ�ؼ�����Ϊʱ��Ŀؼ�
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			required:true,
			editable:false, //huaxiaoying 2017-01-06
			onSelect:function(rowData){
				
			}
			
		}
	}
	
	
	formUomEditor={  
		type: 'combobox',
		options: {
			data:[
				{"value":"1","text":"��"},
				{"value":"2","text":"��"},
				{"value":"3","text":"��"}
			],       //## ���λ�û�ȡ�ؼ�����Ϊʱ��Ŀؼ�
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			required:true,
			editable:false, //huaxiaoying 2017-01-06
			onSelect:function(rowData){
				///���ü���
				var ed=$("#setFielValTable").datagrid('getEditor',{index:editRow,field:'FieldUomID'});   //##   enabledδ�ֶ�����
				$(ed.target).val(rowData.value);
			}
			
		}
	}
	
	inputEditor={type:'validatebox',options:{required:true}};
}

function initBindMethod(){
 	$('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);	
    $("a:contains('���Ԫ��')").bind('click',addItm);
    $("a:contains('ɾ��Ԫ��')").bind('click',delItm);
    $("a:contains('ȫ��ѡ��')").bind('click',selAllItm);
    $("a:contains('ȡ��ѡ��')").bind('click',unSelAllItm);
    $("a:contains('ȫ��ɾ��')").bind('click',delAllItm);
}

///���Ԫ��
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(!datas.length){
		$.messager.alert("��ʾ","δѡ��������ݣ�");
		return;	    
	}
	
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].FormDicID+"^"+ datas[x].ValDr;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVSetAdvStatFied","InsStatField",{"FormNameID":formNameID,"Params":params},
	function(ret){
		if(ret=="0"){
			$.messager.alert("��ʾ","ү,�����ɹ���");
			reloadTopTable();
		}
	},'text');
}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(!datas.length){
		$.messager.alert("��ʾ","δѡ���Ҳ����ݣ�");
		return;	    
	}
	
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].STFId;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVSetAdvStatFied","DelStatField",{"Params":params},
	function(ret){
		if(ret=="0"){
			$.messager.alert("��ʾ","ү,ɾ���ɹ���");
			reloadTopTable();
		}
	},'text');
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}

function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}

function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
		
}
// ��������
function insertRow()
{

	if(!formNameID){
		$.messager.alert("��ʾ","��ѡ�񱨸����ͣ�");
		return ;	
	}
	
	if(editRow>="0"){
		$("#setFielValTable").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#setFielValTable").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {STFVId:'',FormNameDr:formNameID,FormDicDr:'',FeildDesc: '',FieldVal:'',FieldUom:1,FieldUomID:1} //huaxiaoying 2017-01-06
	});         
            
	$("#setFielValTable").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rowsData = $("#setFielValTable").datagrid('getSelected'); //ѡ��Ҫɾ������
	
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ������������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCADVSetAdvStatFied","Delete",{"STFVId":rowsData.STFVId},function(ret){
					if(ret==0){
						$.messager.alert("��ʾ","ɾ���ɹ���");
						$('#setFielValTable').datagrid('reload'); //���¼���
					}
				},'text')
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
		$("#setFielValTable").datagrid('endEdit', editRow);
	}

	var rowsData = $("#setFielValTable").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].FormNameDr=="")||(rowsData[i].FormDicDr=="")||(rowsData[i].FeildDesc=="")||(rowsData[i].FieldVal=="")||(rowsData[i].FieldUomID=="")){ //huaxiaoying 2017-01-06
			$.messager.alert("��ʾ","��༭��������!"); 
			return false;
		}
		var tmp=rowsData[i].STFVId+"^"+rowsData[i].FormNameDr +"^"+ rowsData[i].FormDicDr +"^"+ rowsData[i].FeildDesc +"^"+ rowsData[i].FieldVal+"^"+rowsData[i].FieldUomID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//��������  ##
	runClassMethod("web.DHCADVSetAdvStatFied","Save",{"Params":params},
	function(ret){
		if(ret==0){
			$.messager.alert("��ʾ","�޸ĳɹ���");
			reloadSetFielValTable(formNameID);	
		}
	},'text');
}

function initCombobx(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			formNameID = option.value;
			reloadAllItmTable(option.value);
			reloadSetFielValTable(option.value);
			reloadSetFielTable(option.value);
			updateFormDicIDEditor();
	    }
	};
	
	var url = uniturl+"JsonGetRepotType";
	new ListCombobox("reportType",url,'',option).init();	
}


function initDatagrid(){
	
	var columns=[[
		{field:'PatLabel',title:'',width:210,formatter:setCellLabel}
	]];
	

	$("#allItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVSetAdvStatFied&MethodName=JsonListGetAllItmByFormID",
		queryParams:{
			ForNameID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '���ڼ�����Ϣ...',
		showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	
	var columns=[[
		{field:'PatLabel',title:'',width:210,formatter:setCellLabel}
	]];
	

	$("#setItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVSetAdvStatFied&MethodName=JsonListGetSetFiel",
		queryParams:{
			ForNameID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '���ڼ�����Ϣ...',
		showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	//��ʼ�����·����
	initFieldValTable();
	
	
	
}

//Ϊ�˶�̬
function initFieldValTable(){
	// ����columns
	var columns=[[
		{field:"STFVId",title:'�Զ���Ԫ��ID',width:100,hidden:true,align:'center'}, 
		{field:"FormNameDr",title:'ͳ�Ʊ�',width:100,hidden:true,align:'center',editor:inputEditor}, 
		{field:"FormDicDesc",title:'Ԫ������',width:130,align:'center',editor:inputEditor,editor:formDicIDEditor},
		{field:"FormDicDr",title:'Ԫ��ID',width:130,hidden:true,align:'center',editor:inputEditor},
		{field:"FeildDesc",title:'����',width:150,align:'center',editor:inputEditor},
		{field:'FieldVal',title:'ͳ��ʱ��',width:130,align:'center',editor:inputEditor},
		{field:'FieldUom',title:'ͳ�Ƶ�λ',width:130,align:'center',editor:formUomEditor},
		{field:'FieldUomID',title:'ͳ�Ƶ�λID',width:130,align:'center',hidden:true,editor:inputEditor},
	]];
	
	
	// ����datagrid
	$('#setFielValTable').datagrid({
		title:'',
		url:LINK_CSP+"?ClassName=web.DHCADVSetAdvStatFied&MethodName=JsonListGetSetFielVal", //huaxiaoying 2017-1-4 �淶����
		queryParams:{
			ForNameID:formNameID
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,60],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#setFielValTable").datagrid('endEdit', editRow); 
            } 
            $("#setFielValTable").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
}

//reload ���ϱ�
function reloadAllItmTable(value){
	
	$("#allItmTable").datagrid('load',{
		ForNameID:value
	})
}

function reloadSetFielValTable(value){
	$("#setFielValTable").datagrid('load',{
		ForNameID:value
	})
}

function reloadSetFielTable(value){
	$("#setItmTable").datagrid('load',{
		ForNameID:value
	})
}

///���˼���ҽ������
function setCellLabel(value, rowData, rowIndex){
	var retHtml=rowData.DicDesc;
	return retHtml;
}

///ˢ�� field��fieldVal
function reloadTopTable(){
	reloadSetFielTable(formNameID);
	reloadAllItmTable(formNameID);
}

function updateFormDicIDEditor(){
	
	runClassMethod("web.DHCADVSetAdvStatFied","GetStatFiedValComboBox",{"FormNameID":formNameID},
	function(jsonData){
		console.log(jsonData);
		formDicIDEditor={  
			type: 'combobox',
			options: {
				//url:LINK_CSP+"?ClassName=web.DHCADVSetAdvStatFied&MethodName=GetStatFiedValComboBox&FormNameID="+FormNameID,       //## ���λ�û�ȡ�ؼ�����Ϊʱ��Ŀؼ�
				data:jsonData,
				valueField: "value", 
				textField: "text",
				editable:false, //huaxiaoying 2017-01-06
				onSelect:function(rowData){
					///���ü���
					var ed=$("#setFielValTable").datagrid('getEditor',{index:editRow,field:'FormDicDr'});   //##   enabledδ�ֶ�����
					//$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
					$(ed.target).val(rowData.value);
				} 
			}
		}
		
	},'json',false);
	
	
	initFieldValTable();	
}