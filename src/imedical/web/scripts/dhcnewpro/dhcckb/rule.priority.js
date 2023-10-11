/**
	zhouxin
	2019-06-21
	Ŀ¼���ȼ�
*/
var editRow="";
$(function(){ 
	initTree();
	initDataGrid();
})

function initTree(){
	$('#catalogTree').tree({
    	url:$URL+'?ClassName=web.DHCCKBRulePriority&MethodName=GetDrugLibraryTree&model=tmpquit'+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""),
    	lines:true,
		animate:true,
		onClick:function(node, checked){
		    $('#datagrid').datagrid('load',{catId:node.id}); 
	    }
	});	
}
function initDataGrid(){
	
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	var levelEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id",  //w ##class(web.DHCCKBDiction).QueryDicComboboxByID("","102","0")
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+levelDataId+"&parrefFlag=0",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'RemindLevel'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'RemindLevelId'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	
	var priorityEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id",
			textField: "text",
			data:[{"id":"Y","text":"��"},{"id":"N","text":"��"}],
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'priority'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	var statusEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id",
			textField: "text",
			data:[{"id":"Y","text":"��"},{"id":"N","text":"��"}],
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'status'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	
	$('#datagrid').datagrid({
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCCKBRulePriority&MethodName=ListRuleDic",
		columns:[[ 
			{field:'dic',hidden:true},
			{field:'dicName',title:'��Ŀ',width:150,align:'left'},
			{field:'priority',title:'ǰ������',width:50,align:'left',editor:priorityEditor,formatter:FormatterCheck},
			{field:'status',title:'����',width:50,align:'left',editor:priorityEditor,formatter:FormatterCheck},		
			{field:'RemindMsg',title:'������Ϣ',width:50,align:'left',editor:{type:'text'}},
			{field:'RemindLevel',title:'��Ϣ����',width:50,align:'left',editor:levelEditor},
			{field:'RemindLevelId',title:'��Ϣ����id',width:50,align:'left',editor:texteditor,hidden:true}		

		 ]],
		title:'��ϸ',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper', 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
           CommonRowClick(rowIndex,rowData,"#datagrid");
           editRow = rowIndex; 
        }
	});
}

function Save(){
	
	var selectTree=$("#catalogTree").tree('getSelected')
	if(selectTree==null){
		$.messager.alert("��ʾ","��ѡ������б�!");
		return;
	}
	var catId=selectTree.id;
	
	if(!endEditing("#datagrid")){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	var del1=String.fromCharCode(1);
	var mindList = [];
	for(var i=0;i<rowsData.length;i++){
		
		var dic=rowsData[i].dic;
		var linkPriorityId=rowsData[i].linkPriorityId;
		var priorityDicId=rowsData[i].priorityDicId;
		//var priorityId=rowsData[i].priorityId;
		var priority=rowsData[i].priority;	// ǰ������
		if (priority == "��"){priority = "Y"}
		if (priority == "��"){priority = "N"}
		if (priority == undefined){priority = ""}
		if (priority != ""){
			var tmpPriorty=linkPriorityId+"^"+catId+"^"+dic+"^"+priorityDicId+"^"+priority;
			dataList.push(tmpPriorty)	
		}
		
		var linkStatusId=rowsData[i].linkStatusId;
		var statusDicId=rowsData[i].statusDicId;
		//var statusId=rowsData[i].statusId;		
		var status=rowsData[i].status;	
		var mindinfo=rowsData[i].RemindMsg;
		if (status == "��"){status = "Y"}
		if (status == "��"){status = "N"}
		if (status == undefined){status = ""}		
		if (status != ""){			
			var tmpstatus=linkStatusId+"^"+catId+"^"+dic+"^"+statusDicId+"^"+status;
			dataList.push(tmpstatus)
		}	
		
		var tmpPriorty=linkPriorityId+"^"+catId+"^"+dic+"^"+priorityDicId+"^"+priority;
		var tmpstatus=linkStatusId+"^"+catId+"^"+dic+"^"+statusDicId+"^"+status;
		
		var remindLevelId = (rowsData[i].RemindLevel=="")?"":rowsData[i].RemindLevelId;
		///��֯������Ϣ��
		var mindinfoList=catId +"^"+ dic +"^"+ mindinfo +"^"+ "RemindMsg" +"^"+ remindLevelId; // 2022-03-27 ������Ϣ���� qnp	
		mindList.push(mindinfoList)	
		
	}

	runClassMethod("web.DHCCKBRulePriority","SaveConfigPriority",{"str":dataList.join("$$"),"MindInfoList":mindList.join("$$")},function(data){
		if(data==0){
			$.messager.alert("��ʾ","����ɹ�!","success");
			$('#datagrid').datagrid('reload'); 
		}else{
			$.messager.alert("��ʾ","����ʧ��!"+data,"error");	
		}	
	},"text")
	/*
	runClassMethod("web.DHCADVModel","Save",{entity:"User.DHCCKBDicLinkAttr",'params':dataList.join("$$")},function(data){
		if(data==0){
			$.messager.alert("��ʾ","����ɹ�!");
			$('#datagrid').datagrid('reload'); 
		}else{
			$.messager.alert("��ʾ","����ʧ��!"+data);	
		}	
	},"text")
	*/
}
///��Ȩ  sufan 2020-03-27 ����
function GrantAuth()
{
	var selItem=$("#datagrid").datagrid("getSelected");
	if( selItem == null ){
		$.messager.alert('��ʾ',"��ѡ��Ҫ��Ȩ����Ŀ��")
		return;
	}
	var hideFlag=1;								//��ť���ر�ʶ
	var setFlag = "grantAuth";					//��Ȩ��ʶ
	var tableName = "DHC_CKBDicLinkAttr";		//��Ȩ��
	var dataId = selItem.link;					//����Id
	
	if($('#win').is(":visible")){return;}  			//���崦�ڴ�״̬,�˳�
	
	var linkurl = "dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&CloseFlag=1"+"&Operator="+LgUserID;
	if ("undefined"!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken();
	}	
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-write-order',
        title:'���',
        modal:true,
        width:700,
        height:500,
        content:"<iframe id='diclog' scrolling='auto' frameborder='0' src='"+linkurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                GrantAuthItem();                    
            }
        },{
            text:'�ر�',
            handler:function(){                              
                myWin.close(); 
            }
        }]
    });
	$('#win').dialog('center');
}
///��Ŀ��Ȩ
function GrantAuthItem(){
	
	$("#diclog")[0].contentWindow.SaveManyDatas();	// ��ҳ����־
	$HUI.dialog('#win').close();
}

function FormatterCheck(value){
	
  if(value=="Y"){
	return "<font color='#21ba45'>��</font>"
  }else if(value=="N"){
	return "<font color='#f16e57'>��</font>"
  }else{
    return "";
  }
}
function reloadDatagrid(){}
