/**
  *sufan 
  *2019-06-18
  *��������ά��
  *
 **/
 
var editRow = 0; editsubRow=0;
var CatId = getParam("parref");    //ʵ��ID
var RangeId=CatId;
var extraAttr = "KnowType";			// ��������-֪ʶ����
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
/// ҳ���ʼ������
function initPageDefault(){

	initDataGrid();      /// ҳ��DataGrid��ʼ����
	initBlButton();      /// ҳ�� Button ���¼�
	initCombobox();		 /// ��ʼ��combobx
}

/// ҳ��DataGrid��ʼ����
function initDataGrid(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var Attreditor={  
		type: 'combobox',	//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'AttrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDr'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrCode'});
				var AddAttrID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'AttrDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAttrValue&AddAttrID="+ AddAttrID;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}

	///  ����columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult"
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'ʵ��ID',width:100,hidden:true},
		{field:'DLAAttrCode',title:'����id',width:150,hidden:true},
		{field:'DLAAttrCodeDesc',title:'��������',width:200},	
		{field:'DLAAttrDr',title:'����ֵid',width:80,editor:textEditor,hidden:true},	
		/* {field:'DLAAttrDesc',title:'����ֵ����',width:200,editor:Attreditor},	 */	
		{field:'DLAAttrDesc',title:'����ֵ����',width:300,editor:textEditor,showTip:true},
		{field:'DLAResult',title:'��ע',width:200,editor:textEditor,hidden:true},
		{field:'DLAAttr',title:'DLAAttr',width:200,hidden:true}
		
	]];
	
	///  ����datagrid
	var option = {
		singleSelect : true,
	    onClickRow: function (rowIndex, rowData) {		//������ѡ���б༭
           if (rowIndex != ""||rowIndex == 0) {    //wangxuejian 2021-05-21  �رձ༭�� 
                $("#addattrlist").datagrid('endEdit', editsubRow); 
            } 
        },
        onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
        
           //����Դ
           var DataSource = serverCall("web.DHCCKBRangeCat","GetAddAttrSource",{"queryDicID":rowData.DLAAttrCode,"AttrLinkCode":"DataSource","AttrId":CatId});		//����Դ
          
           //��������
           var DataType = serverCall("web.DHCCKBRangeCat","GetAddAttrCode",{"queryDicID":rowData.DLAAttrCode,"AttrLinkCode":rowData.DLAAttr,"AttrId":CatId});		//ȡ��������
           var e = $("#addattrlist").datagrid('getColumnOption', 'DLAAttrDesc');
           var multiplevalue=false;
          
           if(rowData.DLAAttr =="DataSource"){multiplevalue=true;}
           if((DataType == "combobox")){
	            e.editor = {type:'combobox',
						  options:{
							valueField:'value',
							textField:'text',
							multiple:multiplevalue,
							onSelect:function(option) {
								// �����������Ѿ��Ӻ�̨������ֵ,ѡ��ʱ�ᱻ�ظ�ѡ��							
								var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
								var selVal = $(ed.target).combobox('getValues');
								var setValArr = [];									
								if (selVal.indexOf(option.text) != -1){ //����
									for (i=0;i<selVal.length-1;i++){
										if (selVal[i] != option.value){
											setValArr.push(selVal[i] );
										}										
									}							
									$(ed.target).combobox('setValues', setValArr); 
								}
								/* var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
								$(ed.target).combobox('setValue', option.text); 
								
								var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDr'});
								$(ed.target).val(option.value);  */	
							}, 
						  	onShowPanel:function(){
								var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
								
								var unitUrl = $URL+'?ClassName=web.DHCCKBRangeCat&MethodName=GetDataCombo&DataSource='+DataSource+'&dicCode='+rowData.DLAAttr
							
								$(ed.target).combobox('reload',unitUrl);
						    }	  
						}
				 }
				if (editRow != ""||editRow === 0) { 
            		$("#addattrlist").datagrid('endEdit', editRow); 
        		} 
           		$("#addattrlist").datagrid('beginEdit', rowIndex); 
	       }else if(rowData.DLAAttr=="OrderNum"){ 
	       		 e.editor = {type:'text'}
		         if (editRow != ""||editRow === 0) { 
                	 $("#addattrlist").datagrid('endEdit', editRow); 
            	 } 
            	 $("#addattrlist").datagrid('beginEdit', rowIndex); 
		        
		   }else if(DataType=="textarea"){ 
	       		 e.editor = {type:'text'}
		         if (editRow != ""||editRow === 0) { 
                	 $("#addattrlist").datagrid('endEdit', editRow); 
            	 } 
            	 $("#addattrlist").datagrid('beginEdit', rowIndex); 
		        
		   }else
		   {
			    ShowAllData();
		   }
		        var editors = $('#addattrlist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 ʧȥ����رձ༭��                
                for (var i = 0; i < editors.length; i++)   
                  {  
                    var e = editors[i]; 
                    $(e.target).bind("blur",function()
              	    { 
              	     $("#addattrlist").datagrid('endEdit', rowIndex); 
              	    })
                 }
             editsubRow = rowIndex 
             editRow=rowIndex;  
           }
            
	    };
	      
	var params=CatId +"^"+ extraAttr +"^"+"ExtraProp"+"^"+"";  //ƴ�� codeΪ��
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAddLinkAttr&params="+params;
	new ListComponent('addattrlist', columns, uniturl, option).Init();
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	
	///  ����
	//$('#save').bind("click",saveRow);
	
	//$('#link').bind("click",LinkPropWin);
	
	$("#reset").bind("click",InitPageInfo);	// ����
	
	///���Լ���
	$('#attrtreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			findattrTree(searcode);
		}
	});

	///�ֵ����
	$('#dictreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			finddicTree(searcode);
		}
	});
	
	///ʵ��
	$('#entityCode').searchbox({
	    searcher:function(value,name){
	   		QueryWinDicList();
	    }	   
	});
	
	///��������  
	$('#addattrcode').searchbox({
	    searcher:function(value,name){
	   		serchAddattr()
	    }	   
	});
}

/// ����diag�����ã�
function dataGridBindEnterEvent(index){
	editRow=index;
	var editors = $('#addattrlist').datagrid('getEditors', index);

	for(var i=0;i<editors.length;i++){
		var workRateEditor = editors[i];
		
		//����ֵ DLAAttrDesc
		if(workRateEditor.field=="DLAAttrDesc"){
			workRateEditor.target.mousedown(function(e){
				var ed=$("#addattrlist").datagrid('getEditor',{index:index, field:'DLAAttrDesc'});		
				var input = $(ed.target).val();
				divComponent({tarobj:$(ed.target),htmlType:"tree",width: 400,height: 260},function(obj){
					var ed=$("#addattrlist").datagrid('getEditor',{index:index, field:'DLAAttrDr'});		
					$(ed.target).val(obj.id);				
				})				
			});
		}else{
			workRateEditor.target.mousedown(function(e){
					$("#win").remove();;
			});
			workRateEditor.target.focus(function(e){
					$("#win").remove();;
			});
		}
	}
}

/// 
function LinkPropWin(){
	var linkUrl = "dhcckb.property.csp"
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += '?MWToken='+websys_getMWToken(); 
	}
	///window.location.href="dhcckb.property.csp";
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';

	if($('#editProp').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="editProp"></div>');
	$('#editProp').window({
		title:"����ά��",
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		//maximizable:true,
		width:800,
		height:500
	});	

	$('#editProp').html(openUrl);
	$('#editProp').window('open');
}



//����,��ѡ����
function treeSingleCheckCtrl(node, checked) {
    var elementId = 'attrtree';		//Ԫ��ID
    if (checked) {
        var allCheckedNodes = $('#' + elementId).tree("getChecked");
        for (var i = 0; i < allCheckedNodes.length; i++) {
            var tempNode = allCheckedNodes[i];
            if (tempNode.id != node.id) {
                $('#' + elementId).tree('uncheck', tempNode.target);
            }
        }
        $('#attrtree').tree('select', node.target);
    }

}

//����,ѡ��ͬʱ��ѡ
function treeSelectCheckCtrl(node) {
    var elementId = 'attrtree';		//Ԫ��ID 
   	$('#' + elementId).tree('check', node.target);

}

/// ���ݼ��ϣ�ȫ����
function ShowAllData(){

	var attrrow = $('#addattrlist').datagrid('getSelected');	// ��ȡѡ�е���  
	if ($g(attrrow) == ""){
		$.messager.alert('��ʾ','��ѡ��һ���������Խ���ά����','info');
		return;
	}
	$("#myWin").show();
	
	SetTabsInit();
      
    var myWin = $HUI.dialog("#myWin",{
        iconCls:'icon-w-save',
        resizable:true,
        title:'�������ֵ',
        modal:true,
        //left:400,
        //top:150,
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                SaveFunLib();                    
            }
        },{
            text:'�ر�',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        }
    });
	$('#myWin').dialog('center');
	$('#tabOther').tabs('select',0);  
	
	var extraAttrValue = "AttrFlag" 	// �ֵ���(��������ֵ)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	
	$("#attrtree").tree('options').url =(uniturl);
	$("#attrtree").tree('reload');
	
	
	$('#tabOther').tabs({
		onSelect:function(title){
			if (title == "����"){
				var extraAttrValue = "AttrFlag" 	// �ֵ���(��������ֵ)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
				
				$("#attrtree").tree('options').url =(uniturl);
				$("#attrtree").tree('reload');
				
			}else if(title == "�ֵ�"){
				var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;

				$("#dictree").tree('options').url =(uniturl);
				$("#dictree").tree('reload');
				$("#entitygrid").datagrid("unselectAll");
				
			}else if (title == "ʵ��"){			  	
				var extraAttrValue = "ModelFlag" 	// �ֵ���(��������ֵ)
				var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";

				$("#entitygrid").datagrid('options').url =(uniturl);
				$("#entitygrid").datagrid('reload');	
			}
		}
	});
}


/// ��ʼ��tabs�е����ݱ��
function SetTabsInit(){

	var extraAttrValue = "AttrFlag" 	// knowledge-����
	// ����
	var myAttrTree = $HUI.tree("#attrtree",{
		url:"", //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue,
   		lines:true,  //���ڵ�֮����ʾ����
		autoSizeColumn:false,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  //�Ƿ�����顣Ĭ��true  �˵����⣬����������
		animate:false     	//�Ƿ���չ���۵��Ķ���Ч��
		//onCheck: treeSingleCheckCtrl,//����,��ѡ����
		//onSelect:treeSelectCheckCtrl	//����,��ѡ����		
	});
	//$("#attrtree").tree('options').url =(url);
	//$("#attrtree").tree('reload');
		
	// �ֵ�
	var extraAttrValue = "DictionFlag" 	// knowledge-����
	// ����
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	var DicTree = $HUI.tree("#dictree",{
		url:uniturl, 
   		lines:true,  //���ڵ�֮����ʾ����
		autoSizeColumn:false,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//�Ƿ�����顣Ĭ��true  �˵����⣬����������
		animate:false,    			//�Ƿ���չ���۵��Ķ���Ч��
		onClick:function(node, checked){
	    	
	    },
	    onLoadSuccess: function(node, data){
			if (node != null){
				$('#dictree').tree('expand', node.target);
			}
		}
			
	}); 
  
    // ʵ��
	var entitycolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left'},
			{field:'CDDesc',title:'����',width:300,align:'left'}			
		 ]]		 
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90]	
		  
	}
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('entitygrid', entitycolumns, uniturl, option).Init();

}

/// ����
function SaveFunLib(){

	var currTab = $('#tabOther').tabs('getSelected');
	var currTabTitle = currTab.panel('options').title;
	var selectID=""
	var selectDesc=""
	var dataList=[];
	var Param="";
	if (currTabTitle.indexOf("����")!=-1){					// ѡ������
		var attrrow = $('#attrtree').tree('getChecked');	// ��ȡѡ�е���  
		for (var i=0;i<attrrow.length;i++){
			selectID = $g(attrrow)==""?"":attrrow[i].id;
			selectDesc =  $g(attrrow)==""?"":attrrow[i].code;
			dataList.push(selectID);
		}
		Param=dataList.join("$");
	}else if(currTabTitle.indexOf("�ֵ�") != -1){				// ѡ���ֵ�
	
		var dicrow =$('#dictree').tree('getChecked');	// ��ȡѡ�е���
		for (var i=0;i<dicrow.length;i++){
			selectID = $g(dicrow)==""?"":dicrow[i].id;
			selectDesc =  $g(dicrow)==""?"":dicrow[i].code;
			dataList.push(selectID);
		}
		Param=dataList.join("$");
	}else if(currTabTitle.indexOf("ʵ��") != -1){				// ѡ��ʵ��
	
		var entityrow =$('#entitygrid').datagrid('getSelected'); // ��ȡѡ�е���  
		selectID = $g(entityrow)==""?"":entityrow.ID;
		selectDesc =  $g(entityrow)==""?"":entityrow.CDDesc;
		dataList.push(selectID);
		Param=dataList.join("$");
	}

	if ($g(selectID) == ""){	
		 $.messager.alert('��ʾ','��ѡ��һ�����Ի��ֵ��ʵ�壡','info');
		 return;	
	} 
	
	/// �������Խ��渳ֵ
	$('#addattrlist').datagrid('beginEdit', editRow);	
	//var attrDescObj=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
	//$(attrDescObj.target).val(selectDesc);
	//var attrDrObj=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDr'});
	//$(attrDrObj.target).val(selectID);
	//$('#addattrlist').datagrid('endEdit', editRow);
	SaveLinkAttr(Param,2)
	//saveRow();

	//$HUI.dialog("#myWin").close();
}


///����
function saveRow()
{
	// ʹ�ô˷�������ʱ����Ҫdatagrid�������ͱ��ֶ�������ͬ���޸�ʱIDĬ�Ϲ̶�
	comSaveByDataGrid("User.DHCCKBDicLinkAttr","#addattrlist",function(ret){
			if(ret=="0")
			{
				$('#myWin').dialog('close');
				$("#addattrlist").datagrid('reload');
			}
					
		}
	)	
}

/// ɾ��
function DelLinkAttr(){

	//removeCom("User.DHCCKBDicLinkAttr","#addattrlist")
	var rowsData = $("#addattrlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		if((rowsData.DLAAttrDr=="")||(rowsData.DLAAttrDr === undefined)){
			//$.messager.alert('��ʾ','û�����ݣ�����Ҫɾ��','warning');
			return;
		}
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBRangeCat","CancelAddAttr",{"EntyId":CatId,"AddAttrList":rowsData.DLAAttrCode},function(jsonString){
					if(jsonString!=0){
						$.messager.alert('��ʾ',"ErrMsg:"+jsonString,"warning")
					}else{
						window.parent.reloadPagedg();
					}
					$('#addattrlist').datagrid('reload'); 
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
///����������
function findattrTree(searcode)
{
	var extraAttrValue = "AttrFlag" 	// �ֵ���(��������ֵ)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///��������
function RefreshData()
{
	$HUI.searchbox("#attrtreecode").setValue("");
	var searcode=$HUI.searchbox("#attrtreecode").getValue();
	var extraAttrValue = "AttrFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///�����ֵ���
function finddicTree(searcode)
{
	var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
	var dictype = $("#dictype").combobox("getValue");
	/* if(searcode==""){
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	}else{
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	} */
	dictype = dictype==""?0:dictype;
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id='+dictype+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue+"&queryCode="+searcode;
	$("#dictree").tree('options').url =encodeURI(uniturl);
	$("#dictree").tree('reload');
}
///��������
function Refreshdic()
{
	$HUI.searchbox("#dictreecode").setValue("");
	$HUI.combobox("#dictype").setValue("");
	
	var extraAttrValue = "DictionFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	$("#dictree").tree('options').url =encodeURI(uniturl);
	$("#dictree").tree('reload');
}
// ʵ���ѯ
function QueryWinDicList()
{
	var params = $HUI.searchbox("#entityCode").getValue();
	
	$('#entitygrid').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:extraAttrValue,
		params:params
	}); 
}
// ����
function InitPageInfo(){
	$HUI.searchbox('#entityCode').setValue("");
	QueryWinDicList();	
	$("#div-img").show();

}
///���渽�����Կɱ༭���� 2019-11-27
function SaveLinkAttr(Param,flag)
{
	if(editRow>="0"){
		$("#addattrlist").datagrid('endEdit', editRow);
	}
	var dataList = [];
	if(Param=="0"){
		
		var rowsData = $("#addattrlist").datagrid('getChanges');
		if(rowsData.length<=0){
			$.messager.alert("��ʾ","û�д���������!",'info');
			return;
		}
		if (rowsData.length == 1){
			if(rowsData[0].DLAAttrDesc==""){
				$.messager.alert("��ʾ","�������ݲ���Ϊ�գ�����ɾ��������ɾ����ť",'info',function(){
					$('#addattrlist').datagrid('reload'); 
				}); 				
				return;
			}
		}		
		for(var i=0;i<rowsData.length;i++){
		
			/*if(rowsData[i].DLAAttrDesc==""){
				$.messager.alert("��ʾ","�ɱ༭���ݲ���Ϊ�գ�"); 
				return false;
			}*/
			var IdList=serverCall("web.DHCCKBRangeCat","GetAttrIdList",{"ItmList":rowsData[i].DLAAttrDesc,'AddAttr':$g(rowsData[i].DLAAttrCode)});
			var dataId=IdList.split("^")[0];
			var datatext=IdList.split("^")[1];
			var IdArray=dataId.split(",")
			
			if(dataId==""){
				var tmp=RangeId +"^"+ $g(rowsData[i].DLAAttrCode) +"^"+ dataId +"^"+ datatext+"^"+ $g(rowsData[i].DLAAttr);
				dataList.push(tmp);
			}else{
				if(IdArray.length>1){
					for(var j=0;j<IdArray.length;j++){
						var tmp=RangeId +"^"+ $g(rowsData[i].DLAAttrCode) +"^"+ $g(IdArray[j]) +"^"+ $g(IdArray[j]) +"^"+ $g(rowsData[i].DLAAttr);
						dataList.push(tmp);
					}
				}else{
					var tmp=RangeId +"^"+ $g(rowsData[i].DLAAttrCode) +"^"+ $g(dataId) +"^"+ $g(rowsData[i].DLAAttrDesc) +"^"+ $g(rowsData[i].DLAAttr);
					dataList.push(tmp);
				}
			}	
		} 
	}else{
		var rowsData=$("#addattrlist").datagrid('getRows')[editRow];
		var ParamArray = Param.split("$");
		for(var i=0;i<ParamArray.length;i++)
		{
			var tmp=RangeId +"^"+ $g(rowsData.DLAAttrCode) +"^"+ $g(ParamArray[i]) +"^"+ "" +"^"+ $g(rowsData.DLAAttr);
			dataList.push(tmp);
		}
	}
	
	var params=dataList.join("&&");
	
	//��������
	runClassMethod("web.DHCCKBRangeCat","SaveUpdate",{"params":params,"flag":flag},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�ErrCode:'+jsonString,'warning');
			$('#addattrlist').datagrid('reload'); 
			return;	
		}else{
			$.messager.alert('��ʾ','����ɹ���','info');
			if(flag==2){
				$HUI.dialog("#myWin").close();
				
				
			}
			$('#addattrlist').datagrid('reload'); 
			//window.parent.reloadPagedg();
			return;
		}
	});
}
function DownData()
{

	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"ҩѧ����", //Ĭ��DHCCExcel
		ClassName:"web.DHCCKBPrescTest",
		QueryName:"ExportDrugCat"
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;

}
function saveCommon()
{
	
}
//��ѯ����  wxj 2021-05-20
function serchData(){
   	var searcode = $HUI.searchbox("#attrtreecode").getValue();
	findattrTree(searcode);
	}
	
function serchdic(){
   	var searcode = $HUI.searchbox("#dictreecode").getValue();
	finddicTree(searcode);
	}
	
// ��ѯ��������
function serchAddattr()
{
	var addattrcode = $HUI.searchbox("#addattrcode").getValue();
	var params=CatId +"^"+ extraAttr +"^"+"ExtraProp"+"^"+addattrcode; 
	//alert(params)
	$('#addattrlist').datagrid('load',{
		params:params
	}); 
}
///������������
function RefreshAddattr()
{
    $HUI.searchbox("#addattrcode").setValue("");
	serchAddattr()
}

/// ��ʼ��ҳ��combobx 
function initCombobox(){
	
	    /// ��ʼ�����������
    var option = {
        //panelHeight:"auto",
        mode: "remote",
        valueField: 'value',
        textField: 'text',
        onSelect: function (option) {
            serchdic();
      
        },
        onLoadSuccess:function(data){
	        console.log(data)
	        newdata = [
	        {value: '20', text: '���������ֵ�'}
	        ]
	        return newdata;
	    }
    };
    var url = LINK_CSP + "?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr=" + extraAttr +
        "&extraAttrValue=" + "DictionFlag";
    new ListCombobox("dictype", url, '', option).init();
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
