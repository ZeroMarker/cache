/*
* ҩѧ�໤ά��
* pengzhikun
*/
var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
var ctlocArray = [{ "val": "1067", "text": "С�����" }, { "val": "970", "text": "�����" }, { "val": "971", "text": "����רҵ" },
	{ "val": "1209", "text": "�����" }, { "val": "999", "text": "�ڷ��ڿ�" }, { "val": "1081", "text": "���ڿ�" },
	{ "val": "1151", "text": "�������ƿ�" }];
$(document).ready(function(){
	//���ݵ����ϸ��ʾ����panel
	$('.easyui-accordion ul li a').click(function(){
		 var panelTitle = $(this).text();
		 //�����˵�����ʾ��Ӧ����
		 choseMenu(panelTitle);
	});
			
})

function choseMenu(item){
	switch(item){
		case "�໤����ά��":
			//��ֹ�ظ����������ʱFlag=1�����²�ִ�д�������
			if(Flag1==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��"����Ժ����"��panel
				createLevelPanel();
				//����mainPanel�ɼ�
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item
				});
			}
			
			break;
			
		case "�໤��Ŀά��":
			if(Flag2==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��"סԺ�ڼ仼��"��panel
				createMonItmPanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item
				});
				//��������
				//loadData();
			}
			break;
			
		case "�໤��Χά��":
			if(Flag3==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��"סԺ�ڼ仼��"��panel
				createRangePanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item
				});
				//��������
				//loadData();
			}
			break;
			
		default:
			break;	
	}
				 	
} 

//--����"�໤����"������--//
var Flag1=0;//��ֹ�ظ��������δ������
function createLevelPanel() {
	if(Flag1==0){
		//����ʾ��ѯ������
		$("#Level").css("display","block");
		Flag1=1;
		Flag2=0;
		Flag3=0;	
		initLevelData();
		
	}
} 


function initLevelData(){
	$("#levelDG").datagrid({
		idField:"rowid",
		url: url+"?actiontype=GetLevelList",  
		rownumbers:true,
		striped: true,
		pageList : [15, 30, 45],   // ��������ÿҳ��¼�������б�
		pageSize : 15 ,  // ÿҳ��ʾ�ļ�¼����
		fitColumns:true,
		//sortName: "rowid", //��ʼ�����ʱ���ݵ����� �ֶ� ��������ݿ��е��ֶ�������ͬ
		//sortOrder: "asc",
		singleSelect:true,
		fit: true,
		loadMsg: '���ڼ�����Ϣ...',
		columns: [[
		{	
			field:"rowid",
			title:"ID",
			width:50,
			align:"center"//,
			//hidden:true
		},{	
			field:"code",
			title:"����",
			width:200,
			align:"left",
			editor:'text'
		},
		{
			field:"desc",
			title:"����",
			width:200,
			align:"left",
			editor:'text'
		}]],
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#levelDG").datagrid('endEdit', editRow); 
            } 
            $("#levelDG").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})  
	
	//���÷�ҳ�ؼ�   
	$('#levelDG').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '��',//ҳ���ı���ǰ��ʾ�ĺ��� 
		afterPageText: 'ҳ    �� {pages} ҳ',   
		displayMsg: '��ǰ��ʾ {from} - {to} ����¼   �� {total} ����¼'
	});
}

// ��������
function insertLevelRow()
{
	if(editRow>="0"){
		$("#levelDG").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#levelDG").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {rowid: '',code:'',desc: ''}
	});
	$("#levelDG").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteLevelRow()
{
	var rows = $("#levelDG").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?actiontype=DeleteLevel',{"index":rows[0].rowid}, function(data){
					$('#levelDG').datagrid('reload'); //���¼���
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function saveLevelRow()
{
	if(editRow>="0"){
		$("#levelDG").datagrid('endEdit', editRow);
	}

	var rows = $("#levelDG").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		var tmp=rows[i].rowid+"^"+rows[i].code+"^"+rows[i].desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	//alert(rowstr)
	
	//��������
	$.post(url+'?actiontype=UpdateLevel',{"datelist":rowstr},function(data){
		$('#levelDG').datagrid('reload'); //���¼���
	});
}

// �޸�ѡ����
function modifyLevelRow()
{
	var rows = $("#levelDG").datagrid('getSelections'); //ѡ��һ�н��б༭
	//ѡ��һ�еĻ������¼�
	if (rows.length == 1)
	{
		if(editRow!=""){
			$("#levelDG").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
		}
		var index = $("#levelDG").datagrid('getRowIndex', rows[0]);//��ȡѡ���е�����
		$("#levelDG").datagrid('beginEdit',index);
		editRow=index;  //��¼��ǰ�༭��
	}else{
		$.messager.alert("��ʾ","��ѡ����༭��!");
	}
}




//--����"�໤��Ŀ"������--//
var Flag2=0;//��ֹ�ظ��������δ������
function createMonItmPanel() {
	if(Flag2==0){
		//����ʾ��ѯ������
		$("#MonItm").css("display","block");
		Flag2=1;
		Flag1=0;
		Flag3=0;
		
		$("#MILevel_comb").combobox({
			onShowPanel:function(){
				$('#MILevel_comb').combobox('reload',url+'?actiontype=GetLevelComb')
			}
		});
	
		$('#MICtloc_comb').combobox({
			panelHeight:"auto",  //���������߶��Զ�����
			data:ctlocArray 
		});
		
		var level=$("#MILevel_comb").combobox('getValue');
		var ctloc=$("#MICtloc_comb").combobox('getValue');
		initMonItmData(level,ctloc);
		
	}
} 

function initMonItmData(level,ctloc){	
		
	$("#MonItmDG").datagrid({
		idField:"rowid",
		url: url+"?actiontype=GetMonItmInfo&level="+level+"&ctloc="+ctloc,
		rownumbers:true,
		striped: true,
		pageList : [20, 30, 40],   // ��������ÿҳ��¼�������б�
		pageSize : 20 ,  // ÿҳ��ʾ�ļ�¼����
		fitColumns:true,
		//sortName: "rowid", //��ʼ�����ʱ���ݵ����� �ֶ� ��������ݿ��е��ֶ�������ͬ
		//sortOrder: "asc",
		singleSelect:true,
		fit: true,
		loadMsg: '���ڼ�����Ϣ...',
		columns: [[
		{	
			field:"rowid",
			title:"ID",
			width:50,
			align:"center",
			hidden:true
		},{	
			field:"code",
			title:"����",
			width:50,
			align:"left",
			hidden:true
			
		},
		{
			field:"desc",
			title:"����",
			width:100,
			align:"left",
			editor:'text'
		},
		{
			field:"level",
			title:"�໤����",
			width:100,
			align:"center",
			editor:{
				type:'combobox',
				options:{
					required:true,
					missingMessage: '��ѡ�񼶱�',
					url:url+'?actiontype=GetLevelComb',
					valueField:'rowid',
					textField:'desc'
					
				}
			}
		},
		{
			field:"ctloc",
			title:"�໤����",
			width:100,
			align:"center",
			editor:{
				type:'combobox',
				options:{
					required:true,
					missingMessage: '��ѡ�����',
					data:ctlocArray,
					valueField:'val',
					textField:'text'
					
				}
			}
		},
		{
			field:"levelDesc",
			title:"����",
			width:50,
			align:"center"
			
		},
		{
			field:"ctlocDesc",
			title:"����",
			width:200,
			align:"center"
			
		}
		
		]],
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#MonItmDG").datagrid('endEdit', editRow); 
            } 
            $("#MonItmDG").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})  
	
	//���÷�ҳ�ؼ�   
	$('#MonItmDG').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '��',//ҳ���ı���ǰ��ʾ�ĺ��� 
		afterPageText: 'ҳ    �� {pages} ҳ',   
		displayMsg: '��ǰ��ʾ {from} - {to} ����¼   �� {total} ����¼'
	});
}

// ��������
function insertMonItmRow()
{
	if(editRow>="0"){
		$("#MonItmDG").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#MonItmDG").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {rowid: '',code:'',desc: '',level:'',ctloc:''}
	});
	$("#MonItmDG").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

function saveMonItmRow()
{
	if(editRow>="0"){
		$("#MonItmDG").datagrid('endEdit', editRow);
	}

	var rows = $("#MonItmDG").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].level=="")||(rows[i].ctloc=="")||(rows[i].desc=="")){
			alert(rows[i].desc)
			alert("��"+(i+1)+"��,"+"������û��д������");
			return;
			
		}
		var tmp=rows[i].rowid+"^"+rows[i].code+"^"+rows[i].desc+"^"+rows[i].level+"^"+rows[i].ctloc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	//alert(rowstr)

	//��������
	
	$.post(url+'?actiontype=UpdateMonItm',{"datelist":rowstr},function(data){
		$('#MonItmDG').datagrid('reload'); //���¼���
	});
	
}

// ɾ��ѡ����
function deleteMonItmRow()
{
	var rows = $("#MonItmDG").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?actiontype=DeleteMonItm',{"index":rows[0].rowid}, function(data){
					$('#MonItmDG').datagrid('reload'); //���¼���
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}


function research(){
	var level=$("#level_comb").combobox('getValue');
	var ctloc=$("#ctloc_comb").combobox('getValue');
	/**
	* ������һ��ʼѡ�������ݣ�Ȼ�����ֶ�������ٻ�ȡֵ����undefined��������Ҫ������̨��������""
	*/
	if(ctloc==undefined){
		ctloc=""
	}
	if(level==undefined){
		level=""
	}
	if(level!="" && ctloc==""){
		alert("����ѡ�����,�ٽ��в�ѯ!");
		return ;
	}
	initRangeData(level,ctloc);
}


//--����"�໤��Χ"������--//
var Flag3=0; //��ֹ�ظ��������δ������
function createRangePanel() {
	if(Flag3==0){
		//����ʾ��ѯ������
		$("#Range").css("display","block");
		Flag3=1;
		Flag1=0;
		Flag2=0;
		
		$("#level_comb").combobox({
			onShowPanel:function(){
				$('#level_comb').combobox('reload',url+'?actiontype=GetLevelComb')
			}
		});
	
		$('#ctloc_comb').combobox({
			panelHeight:"auto",  //���������߶��Զ�����
			data:ctlocArray 
		});
		
		var level=$("#level_comb").combobox('getValue');
		var ctloc=$("#ctloc_comb").combobox('getValue');
		initRangeData(level,ctloc);
		
	}
} 

function initRangeData(level,ctloc){	
		
	$("#rangeDG").datagrid({
		idField:"rowid",
		url: url+"?actiontype=getRangeListInfo&level="+level+"&ctloc="+ctloc,
		rownumbers:true,
		striped: true,
		pageList : [20, 30, 40],   // ��������ÿҳ��¼�������б�
		pageSize : 20 ,  // ÿҳ��ʾ�ļ�¼����
		fitColumns:true,
		//sortName: "rowid", //��ʼ�����ʱ���ݵ����� �ֶ� ��������ݿ��е��ֶ�������ͬ
		//sortOrder: "asc",
		singleSelect:true,
		nowrap: false,   //�������Ӧ  2014-12-15 bianshuai
		fit: true,
		loadMsg: '���ڼ�����Ϣ...',
		columns: [[
		{	
			field:"rowid",
			title:"ID",
			width:50,
			align:"center",
			hidden:true
		},{	
			field:"code",
			title:"����",
			width:50,
			align:"left",
			hidden:true
			
		},
		{
			field:"desc",
			title:"����",
			width:400,
			align:"left",
			editor:'text'
		},
		{
			field:"level",
			title:"�໤����",
			width:100,
			align:"center",
			editor:{
				type:'combobox',
				options:{
					required:true,
					missingMessage: '��ѡ�񼶱�',
					url:url+'?actiontype=GetLevelComb',
					valueField:'rowid',
					textField:'desc'
					
				}
			}
		},
		{
			field:"ctloc",
			title:"�໤����",
			width:100,
			align:"center",
			editor:{
				type:'combobox',
				options:{
					required:true,
					missingMessage: '��ѡ�����',
					data:ctlocArray,
					valueField:'val',
					textField:'text'
					
				}
			}
		},
		{
			field:"levelDesc",
			title:"����",
			width:50,
			align:"center"
			
		},
		{
			field:"ctlocDesc",
			title:"����",
			width:200,
			align:"center"
			
		}
		
		]],
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#rangeDG").datagrid('endEdit', editRow); 
            } 
            $("#rangeDG").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})  
	
	//���÷�ҳ�ؼ�   
	$('#rangeDG').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '��',//ҳ���ı���ǰ��ʾ�ĺ��� 
		afterPageText: 'ҳ    �� {pages} ҳ',   
		displayMsg: '��ǰ��ʾ {from} - {to} ����¼   �� {total} ����¼'
	});
}

// ��������
function insertRangeRow()
{
	if(editRow>="0"){
		$("#rangeDG").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#rangeDG").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {rowid: '',code:'',desc: '',level:'',ctloc:''}
	});
	$("#rangeDG").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

function saveRangeRow()
{
	if(editRow>="0"){
		$("#rangeDG").datagrid('endEdit', editRow);
	}

	var rows = $("#rangeDG").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].level=="")||(rows[i].ctloc=="")||(rows[i].desc=="")){
			alert(rows[i].desc)
			alert("��"+(i+1)+"��,"+"������û��д������");
			return;
			
		}
		var tmp=rows[i].rowid+"^"+rows[i].code+"^"+rows[i].desc+"^"+rows[i].level+"^"+rows[i].ctloc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	//alert(rowstr)

	//��������
	
	$.post(url+'?actiontype=UpdateRange',{"datelist":rowstr},function(data){
		$('#rangeDG').datagrid('reload'); //���¼���
	});
	
}

// ɾ��ѡ����
function deleteRangeRow()
{
	var rows = $("#rangeDG").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?actiontype=DeleteRange',{"index":rows[0].rowid}, function(data){
					$('#rangeDG').datagrid('reload'); //���¼���
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

//�����ѯ��ť����ͳ��
function researchMonItm(){
	var level=$("#MILevel_comb").combobox('getValue');
	var ctloc=$("#MICtloc_comb").combobox('getValue');
	if(ctloc==undefined){
		ctloc=""
	}
	if(level==undefined){
		level=""
	}
	if(level!="" && ctloc==""){
		alert("����ѡ�����,�ٽ��в�ѯ!");
		return ;
	}
	initMonItmData(level,ctloc);
}