/// Creator: congyue
/// CreateDate: 2015-11-16
//  Descript: �����¼�����������

var editRow="",wfgrantRow="",wflevelRow="",nodeArr=[],count = 0;//��ǰ�༭�к�
var url="dhcadv.repaction.csp";
var dataArrayNew = [{"value":"4","text":'ȫԺ'},{"value":"1","text":'��ȫ��'}, {"value":"2","text":'����'}, {"value":"3","text":'��Ա'},{"value":"5","text":'���'}]; //hxy 2017-12-14
var dataArray = [{"value":"1","text":'��ȫ��'}, {"value":"2","text":'����'}, {"value":"3","text":'��Ա'}]; //
var Active = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
var Levelrowid="";
var level=0,parentid="",Eventeditor={type: 'text'};
var LevelArr=[{"value":"1","text":'һ��'}, {"value":"2","text":'����'}, {"value":"3","text":'����'}, {"value":"4","text":'�ļ�'}];
$(function(){
	//���� �¼��ȼ����� tabǩ
	//$('#tabs').tabs('getTab',"�¼��ȼ�").panel('options').tab.hide();//��ʾtab��ͷ    
	//$("#EWFL").hide();
	//�¼�����Ԫ�����ļ��� 
	$('#tree').tree({
		url: 'dhcapp.broker.csp'+"?ClassName=web.DHCADVEVTWORKFLOW&MethodName=jsonCheckWorkFlow&id="+"Root",  /// jsonCheckWorkFlow1  jsonCheckWorkFlowByType Ĭ�ϴ��� "Root"  ���ظ�Ŀ¼��һ���¼���������
    	lines:true,
    	onClick: function(node){
	    	level=node.level;
			level++;
			parentid=node.id;
			var tab = $('#tabs').tabs('getTab',0);
			if(parentid=="Root"){
				$('#tabs').tabs('update', {tab: tab,options: {title: '������'} });
			}else{
				$('#tabs').tabs('update', {tab: tab,options: {title: '��������Ŀ'} });
			}
			Query();
		},
		onLoadSuccess: function(node, data){
				for (var i=0;i<nodeArr.length;i++){
					var node = $('#tree').tree('find', nodeArr[i]);
					if (node != null){
						$('#tree').tree('expand', node.target);
						count = count + 1;
					}
				}
				if (count == nodeArr.length+1){
					nodeArr=[];
				}
				if(parentid!="")
				{
					var node = $('#tree').tree('find', parentid);	//�ҵ�idΪtree������Ľڵ�idΪparentid�Ķ���
					if(node!=null)
					{
						$('#tree').tree('select', node.target);			//����ѡ�иýڵ�

					}
				}				
		}

			
	});
	InitEvtWorkFlow();
	InitEvtWFGrant();
	InitEvtWFLevel();
	$('#tabs').tabs({    
	    onSelect:function(title){  
	    	Query();  
	    } 
	}); 
	
	$("#evtworkflowdg").datagrid('loadData',{total:0,rows:[]});
 
})
///���ݱ����ص���
function Query(){
	var dgurl="";
	if((parentid=="Root")||(parentid=="")){
		dgurl=url+"?action=QueryAdrEvtworkFlow";
		$('#insertwf').show();
		$('#insertwfi').hide();
		$('#evtworkflowdg').datagrid('hideColumn','pri');
		$('#evtworkflowdg').datagrid('showColumn','EventType');
		$('#evtworkflowdg').datagrid('showColumn','Active');
	}else{
		$('#insertwf').hide();
		$('#insertwfi').show();
		dgurl=url+"?action=QueryEventWorkFlowItm";
		$('#evtworkflowdg').datagrid('showColumn','pri');
		$('#evtworkflowdg').datagrid('hideColumn','EventType');
		$('#evtworkflowdg').datagrid('hideColumn','Active');
		
	}
	$('#evtworkflowdg').datagrid({   //����ļ���      wangxuejian 2018-08-21
		url:dgurl,	
		queryParams:{
			params:parentid
		}
	});	
	$('#evtwfgrantdg').datagrid({
		url:'dhcadv.repaction.csp?action=QueryEventWorkFlowGrant',	
		queryParams:{
			params:parentid
		}
	});
	$('#evtwfleveldg').datagrid({
		url:'dhcadv.repaction.csp?action=QueryEvtWorkFlowLink',	
		queryParams:{
			params:parentid
		}
	});
	if(parentid.indexOf("||")>=0){
		$HUI.linkbutton("#inseventwfl").enable();
		$HUI.linkbutton("#deleventwfl").enable();
		$HUI.linkbutton("#saveventwfl").enable();
	}else{
		$("#inseventwfl").linkbutton('disable');
		$("#deleventwfl").linkbutton('disable');
		$("#saveventwfl").linkbutton('disable');
	}
}
function InitEvtWorkFlow(){
	
	/* //��������  ������  2016-07-14
	$('#eventtype').combobox({    
		valueField: "val", 
		textField: "text",
		//url:url+'?action=selEvent',
		mode:'remote',
		url: 'dhcapp.broker.csp'+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryEventCommbox&params=1",  ///Ĭ�ϴ��� "Root"  ���ظ�Ŀ¼��һ���¼���������
		onLoadSuccess:function(){
			var temp=$('#eventtype').combobox('getData');
			for(var i=0;i<temp.length;i++){
				if(temp[i].text=="ȫ��"){
					return;	
				}	
			}
			temp=[{'val':"ȫ��",'text':"ȫ��"}].concat(temp);
			$('#eventtype').combobox('loadData',temp);
		}
	}); */
	//�Ƿ���ñ�־
	var activeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //���������߶��Զ�����
			
		}
	}
	//����
	Eventeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "val", 
			textField: "text",
			url: 'dhcapp.broker.csp'+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryEventCommbox",  ///Ĭ�ϴ��� "Root"  ���ظ�Ŀ¼��һ���¼���������
			required:true,
			mode:'remote',
			onSelect:function(option){
				///��������ֵ
				var ed=$("#evtworkflowdg").datagrid('getEditor',{index:editRow,field:'EventType'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#evtworkflowdg").datagrid('getEditor',{index:editRow,field:'EventTypeDr'});
				$(ed.target).val(option.val); 
			}
		}
	}
	// ����columns
	var columns=[[
		{field:"Code",title:'����',width:150,editor:texteditor},
		{field:'Desc',title:'����',width:150,editor:texteditor},
		{field:"EventTypeDr",title:'����ID',width:80,editor:'text',hidden:true},
		{field:"EventType",title:'����',width:300,editor:Eventeditor,hidden:false},
		{field:'Active',title:'�Ƿ����',width:80,formatter:formatLink,editor:activeEditor},
		{field:"Level",title:'�㼶',width:100,hidden:true},
		{field:'Levelrowid',title:'��һ�㼶ID',width:100,hidden:false},
		{field:'pri',title:'���ȼ�',width:100,
				formatter:function(value,rec,index){
					var a = '<a href="#" mce_href="#" class="img icon-up" onclick="upclick(\''+ index + '\')"></a> ';
					var b = '<a href="#" mce_href="#" class="img icon-down" onclick="downclick(\''+ index + '\')"></a> ';
					return a+b;  
                    }  
		,hidden:true},
		{field:'OrderNo',title:'˳���',width:130,hidden:false},
		{field:"ID",title:'ID',width:60,align:'center',hidden:false}

	]];
	// ����datagrid
	$('#evtworkflowdg').datagrid({
		title:'',/* �����¼����������� */
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		nowrap:false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) {
            	if(CheckEdit("evtworkflowdg",editRow)){
		        	$.messager.alert("��ʾ","����д��������Ϣ!"); 
					return false;	    
	            }
            	$("#evtworkflowdg").datagrid('endEdit', editRow); 
			}
			//��ӹ�����������Ԫ�أ�ʱ��EventType--�����¼���������Ҫ�����ӹ�������Ŀ���ӱ�Ԫ�أ�ʱ��EventType--�����¼����������÷Ǳ���
			var EventTypett=$('#evtworkflowdg').datagrid('getColumnOption','EventType'); //ͨ��������ô���
			if((parentid!="Root")){
				EventTypett.editor={type:'text'}; //���ô��еı༭����
			}else{
				EventTypett.editor=Eventeditor; //���ô��еı༭����
			}	
            $("#evtworkflowdg").datagrid('beginEdit', rowIndex);
            editRow = rowIndex; 
        }
	});
	
	initScroll("#evtworkflowdg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insertwf').bind('click',insertRow); 
    $('#insertwfi').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
}


// ��������
function insertRow()
{	
	if((parentid=="")){
		$.messager.alert("��ʾ","��ѡ���Ŀ¼���߾���Ĺ�����!"); 
		return false;
	}
	//��ӹ�����������Ԫ�أ�ʱ��EventType--�����¼���������Ҫ�����ӹ�������Ŀ���ӱ�Ԫ�أ�ʱ��EventType--�����¼����������÷Ǳ���
	var EventTypett=$('#evtworkflowdg').datagrid('getColumnOption','EventType'); //ͨ��������ô���
	if((parentid!="Root")){
		EventTypett.editor={type:'text'}; //���ô��еı༭����
	}else{
		EventTypett.editor=Eventeditor; //���ô��еı༭����
	}		
	
	if(editRow>="0"){
		if(CheckEdit("evtworkflowdg",editRow)){
        	$.messager.alert("��ʾ","����д��������Ϣ!"); 
			return false;	    
        }
		$("#evtworkflowdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#evtworkflowdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","����д��������Ϣ!"); 
			return false;
		}
	} 
	
	$("#evtworkflowdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		
		index: 0, // ������0��ʼ����
		
		row: {ID: '',Code:'',Desc: '',Level:level,Levelrowid: parentid,Active: 'Y'}
	});
	
	$("#evtworkflowdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#evtworkflowdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	var dgurl=""
	if(parentid=="Root"){
		dgurl=url+'?action=DelAdrEvtworkFlow';
	}else {
		dgurl=url+'?action=DelAdrEvtworkFlowItm';
	}
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(dgurl,{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('��ʾ','ɾ���ɹ�');	
					}else if(data==-1){
						$.messager.alert('��ʾ','�����ݴ���ʹ����Ϣ������ɾ��');	
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��');
					}
					$('#evtworkflowdg').datagrid('reload'); //���¼���
					RefreshTree(parentid);
				});
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
		$("#evtworkflowdg").datagrid('endEdit', editRow);
	}

	var rows = $("#evtworkflowdg").datagrid('getChanges');
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
		if(parentid=="Root"){
			var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].EventTypeDr+"^"+rows[i].Active;
		}else {
			var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Active+"^"+rows[i].Level+"^"+rows[i].Levelrowid;
		}
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	var dgurl=""
	if(parentid=="Root"){
		dgurl=url+'?action=SaveAdrEvtworkFlow';
	}else {
		dgurl=url+'?action=SaveAdrEvtworkFlowItm';
	}
	//��������
	$.post(dgurl,{"params":rowstr},function(data){
		
		if(data==0){
			$.messager.alert('��ʾ','�����ɹ�');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ������','warning');
		}else {
			$.messager.alert('��ʾ','����ʧ��','warning');
		}
		$('#evtworkflowdg').datagrid('reload'); //���¼���
		RefreshTree(parentid);
	});
}
/// ˢ���� ��ȡѡ�нڵ�����и��ڵ�ID
function RefreshTree(parentid){

	runClassMethod("web.DHCADVEVTWORKFLOW","GetItmLevCon",{"ItmID":parentid},function(jsonString){
		if(jsonString){
			nodeArr = jsonString.split("^");
			count = 0;
		}
	},'',false);
	$('#tree').tree('reload');
	return;
}

// �༭��
var texteditor={
	type: 'validatebox',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

/// ================================================================================
/// =====================================������Ȩ������=============================
function InitEvtWFGrant()
{
	//������Ϊ�ɱ༭
	var editPoint={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			valueField: "value",
			textField: "text",
			required:true,
			mode:'remote',  //��������������� 2017-08-01 cy �޸�������ģ������
			url:'dhcadv.repaction.csp?action=QueryEventWorkFlowGrant',	
			onSelect:function(option){
				var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'PointID'});
				$(ed.target).val(option.value);  //���ÿ���ID
				var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
			}
		}
	}

	// ����columns
	var columns=[[
		{field:"ItmDr",title:'ItmDr',width:90,align:'center',hidden:true},
		{field:"ParRefDr",title:'ParRefDr',width:90,align:'center',hidden:true},
		{field:'TypeID',title:'TypeID',width:90,editor:'text',hidden:true},
		{field:"Type",title:'����',width:110,editor:texteditor,
			editor: {  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
				options: {
					data:dataArrayNew,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //���������߶��Զ�����
					required:true,
					onSelect:function(option){
						///��������ֵ
						var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'TypeID'});
						$(ed.target).val(option.value);  //���ÿ���ID
						
						var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'PointID'});
						$(ed.target).val(" ");        //����� 2016/7/12
						
						var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'Type'});
						$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
						///���ü���ָ��
						var paramType=option.value+"^"+LgGroupID;  //����^��ȫ��
						var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'Pointer'});
						var url='dhcadv.repaction.csp?action=GetSSPPoint&params='+paramType;
						$(ed.target).combobox('setValue',"");
						$(ed.target).combobox('reload',url);  //����� 2016/7/12
						
					} 
				}
			}
		},
		{field:'Pointer',title:'ָ��',width:300,editor:editPoint},
		{field:'PointID',title:'PointID',width:130,editor:'text',hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	// ����datagrid
	$('#evtwfgrantdg').datagrid({
		title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		//pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		//pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((wfgrantRow != "")||(wfgrantRow == "0")) {
	            if(CheckEdit("evtwfgrantdg",wfgrantRow)){
		        	$.messager.alert("��ʾ","����д��������Ϣ!"); 
					return false;	    
	            }
            	$("#evtwfgrantdg").datagrid('endEdit', wfgrantRow);
			}
            $("#evtwfgrantdg").datagrid('beginEdit', rowIndex); 
            wfgrantRow = rowIndex; 
            
			///���ü���ָ�� huaxiaoying 2018-01-26 st
			var paramType=rowData.TypeID+"^"+LgGroupID;  //����^��ȫ��
			var ed=$("#evtwfgrantdg").datagrid('getEditor',{index:wfgrantRow,field:'Pointer'});
			var url='dhcadv.repaction.csp?action=GetSSPPoint&params='+paramType;
			$(ed.target).combobox('reload',url); //ed
        
        }
	});
	
	initScroll("#evtwfgrantdg");//��ʼ����ʾ���������
	
	//��ť���¼�
    $('#inseventwfg').bind('click',inseventwfgRow); 		//����� 2016/713
    $('#deleventwfg').bind('click',deleventwfgRow);
    $('#saveventwfg').bind('click',saveventwfgRow);
	
}

// ��������
function inseventwfgRow()
{
	if((parentid=="")||(parentid=="Root")){
		$.messager.alert("��ʾ","��ѡ��һ���¼��������ڵ�!"); 
		return false;
	}
	if(wfgrantRow>="0"){
		if(CheckEdit("evtwfgrantdg",wfgrantRow)){
        	$.messager.alert("��ʾ","����д��������Ϣ!"); 
			return false;	    
        }
		$("#evtwfgrantdg").datagrid('endEdit', wfgrantRow);//�����༭������֮ǰ�༭����
	}
	//////////////////////////////////////////////////////////////����� 2016/7/13
	var rows = $("#evtwfgrantdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}		
	} 
	////////////////////////////////////////////////////////////////
	
	$("#evtwfgrantdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',TypeID:'',PointID: ''}
	});
	$("#evtwfgrantdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	wfgrantRow=0;
}

// ɾ��ѡ����
function deleventwfgRow()
{
	var rows = $("#evtwfgrantdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdrWorkFlowGrant',{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('��ʾ','�����ɹ�');
					}else {
						$.messager.alert('��ʾ','����ʧ��','warning');
						//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
					}
					$('#evtwfgrantdg').datagrid('reload'); //���¼���
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function saveventwfgRow()
{
	if(wfgrantRow>="0"){
		$("#evtwfgrantdg").datagrid('endEdit', wfgrantRow);
	}

	var rows = $("#evtwfgrantdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((parentid=="")||(parentid=="Root")){
			$.messager.alert("��ʾ","��ѡ��һ���������������ڵ�!"); 
			return false;
		}
		if((rows[i].TypeID=="")||($.trim(rows[i].PointID)=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}
		if(parentid.indexOf("||")<0){
			var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].TypeID+"^"+rows[i].PointID+"^"+1;
		}else {
			var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].TypeID+"^"+rows[i].PointID+"^"+2;
		}
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//��������
	$.post('dhcadv.repaction.csp?action=SaveAdrWorkFlowGrant',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('��ʾ','�����ɹ�');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','ͬһ����ָ���ظ�,���ʵ������','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}else {
			$.messager.alert('��ʾ','����ʧ��','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}
		$('#evtwfgrantdg').datagrid('reload'); //���¼���
	});
}

var eventwfitmdg;
//����
function upclick(index)
{
     var newrow=parseInt(index)-1 
	 var curr=$("#eventwfitmdg").datagrid('getData').rows[index];
	 var currowid=curr.ID;
	 var currordnum=curr.OrderNo;
	 var up =$("#eventwfitmdg").datagrid('getData').rows[newrow];
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
	 var curr=$("#eventwfitmdg").datagrid('getData').rows[index];
	 var currowid=curr.ID;
	 var currordnum=curr.OrderNo;
	 var down =$("#eventwfitmdg").datagrid('getData').rows[newrow];
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
		if(((editors[i].type=="validatebox")&&(editors[i].target.val()==""))){  ///|| ((editors[i].type=="text")&&(editors[i].target.val()==""))||((editors[i].type=="combobox")&&(editors[i].target.combobox('getText')==""))
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


/// ================================================================================
/// =====================================�������¼��ּ�����=============================
function InitEvtWFLevel()
{
	//������Ϊ�ɱ༭
	var editLevel={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data:LevelArr,
			valueField: "value",
			textField: "text",
			required:true,
			onSelect:function(option){
				var ed=$("#evtwfleveldg").datagrid('getEditor',{index:wflevelRow,field:'LevelDr'});
				$(ed.target).val(option.value);  //���ÿ���ID
				var ed=$("#evtwfleveldg").datagrid('getEditor',{index:wflevelRow,field:'Level'});
				$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
			}
		}
	}
	
	// ����columns
	var columns=[[
		{field:"LinkDr",title:'LinkDr',width:100,align:'center',hidden:true},
		{field:'Level',title:'�ȼ�',width:100,editor:editLevel,hidden:false},
		{field:'LevelDr',title:'LevelDr',width:100,editor:'text',hidden:true},
		{field:"ID",title:'ID',width:100,align:'center',hidden:true}
	]];
	// ����datagrid
	$('#evtwfleveldg').datagrid({
		title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((wflevelRow != "")||(wflevelRow == "0")) {
	            if(CheckEdit("evtwfleveldg",wflevelRow)){
		        	$.messager.alert("��ʾ","����д��������Ϣ!"); 
					return false;	    
	            }
            	$("#evtwfleveldg").datagrid('endEdit', wflevelRow);
			}
            $("#evtwfleveldg").datagrid('beginEdit', rowIndex); 
            wflevelRow = rowIndex; 
        
        }
	});
	
	initScroll("#evtwfleveldg");//��ʼ����ʾ���������
	
	//��ť���¼�
    $('#inseventwfl').bind('click',inseventwflRow); 		//����� 2016/713
    $('#deleventwfl').bind('click',deleventwflRow);
    $('#saveventwfl').bind('click',saveventwflRow);
	
}

// ��������
function inseventwflRow()
{
	if((parentid=="")||(parentid=="Root")){
		$.messager.alert("��ʾ","��ѡ��һ���¼��������ڵ�!"); 
		return false;
	}
	if(wflevelRow>="0"){
		if(CheckEdit("evtwfleveldg",wflevelRow)){
        	$.messager.alert("��ʾ","����д��������Ϣ!"); 
			return false;	    
        }
		$("#evtwfleveldg").datagrid('endEdit', wflevelRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#evtwfleveldg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].LevelDr=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}		
	} 
	
	$("#evtwfleveldg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',LinkDr:parentid,Level: ''}
	});
	$("#evtwfleveldg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	wflevelRow=0;
}

// ɾ��ѡ����
function deleventwflRow()
{
	var rows = $("#evtwfleveldg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelEvtWorkFlowLink',{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('��ʾ','�����ɹ�');
					}else {
						$.messager.alert('��ʾ','����ʧ��','warning');
						//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
					}
					$('#evtwfleveldg').datagrid('reload'); //���¼���
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function saveventwflRow()
{
	if(wflevelRow>="0"){
		$("#evtwfleveldg").datagrid('endEdit', wflevelRow);
	}

	var rows = $("#evtwfleveldg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((parentid=="")||(parentid=="Root")){
			$.messager.alert("��ʾ","��ѡ��һ���������������ڵ�!"); 
			return false;
		}
		if((rows[i].LevelDr=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+parentid+"^"+rows[i].LevelDr;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//��������
	$.post('dhcadv.repaction.csp?action=SaveEvtWorkFlowLink',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('��ʾ','�����ɹ�');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','ͬһ����ָ��ȼ��ظ�,���ʵ������','warning');
		}else {
			$.messager.alert('��ʾ','����ʧ��','warning');
		}
		$('#evtwfleveldg').datagrid('reload'); //���¼���
	});
}
