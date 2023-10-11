//===========================================================================================
// Author��      qunianpeng
// Date:		 2019-01-04
// Description:	 �°��ٴ�֪ʶ��-ʵ���ֵ��
//===========================================================================================

var editRow = 0,editaddRow=0;
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
var dicID="";						// ʵ��ID
var nodeArr=[];					
/// ҳ���ʼ������
function initPageDefault(){
	
	initDataList();		// ҳ��DataGrid��ʼ������
	initattrGrid(); 	// �����б�
	//initaddattrGrid();	// ��������
	initButton();		// ��ť��Ӧ�¼���ʼ��
	initCombobox();		// ��ʼ��combobox
}

/// ҳ��DataGrid��ʼ����ͨ����
function initDataList(){
						
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'����',width:300,align:'left',editor:texteditor},
			{field:'Parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"֪ʶ����",width:200,align:'left',hidden:true},
			{field:'DataType',title:"��������",width:200,align:'left',hidden:true},			
			{field:'Operating',title:'����',width:380,align:'left',formatter:SetCellOperation,hidden:true}
			
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
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 	
 		   dicID=rowData.ID;
 		   var attr=dicID +"^"+ "LinkProp"
		   $("#attrlist").datagrid("load",{"params":attr});
		   switchMainSrc(dicID)
		   //var addattr=dicID +"^"+ extraAttr+"^"+"ExtraProp";
		   //$("#addattrlist").datagrid("load",{"params":addattr}); 
		   
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#diclist").datagrid('endEdit', editRow); 
            } 
            $("#diclist").datagrid('beginEdit', rowIndex); 
            var editors = $('#diclist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 ʧȥ����رձ༭��                
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i]; 
              	$(e.target).bind("blur",function()
              	  {  
                    $("#diclist").datagrid('endEdit', rowIndex);
                  });   
                  
            } 
            editRow = rowIndex; 
        }
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params="+"&drugType="+InitDrugType();
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

///���ò�����ϸ����
function SetCellOperation(value, rowData, rowIndex){

	///<a href='#' onclick=\"showAuditListWin('"+a+"','"+a+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>����</a>";
	/* var btnGroup="<a style='margin-right:10px;' href='#' onclick=\"switchMainSrc('"+rowData.ID+"','list','"+rowData.DataType+"')\">����</a>"; */
	var btnGroup="";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"switchMainSrc('"+rowData.ID+"','prop','"+rowData.DataType+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>����</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"switchMainSrc('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>��������</a>";
	
	return btnGroup;
}

/// ���Ժ͸��������л�
function switchMainSrc(dicID){
	var linkUrl=""
	linkUrl = "dhcckb.addlinkattr.csp?parref="+dicID;	// ��������
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += '&MWToken='+websys_getMWToken(); 
	}
	$("#tabscont").attr("src", linkUrl);	

}

/// ��ť��Ӧ�¼���ʼ��
function initButton(){

	$("#insert").bind("click",insertRow);	// ��������
	
	$("#save").bind("click",saveEntyRow);		// ����
	
	$("#delete").bind("click",deleteRow);	// ɾ��
	
	$("#find").bind("click",QueryDicList);	// ��ѯ
	
	$("#reset").bind("click",InitPageInfo);	// ����
	
	/// ����.������ѯ
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});
	
	/// tabs ѡ�
	$("#tabs").tabs({
		onSelect:function(title){
		   	LoadattrList(title);
		}
	});
	
	///���Լ���
	$('#attrtreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			findattrTree(searcode);
		}
	});
	
	///���Լ���
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
}

/// ��ʼ��combobox
function initCombobox(){}

// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);		//�����༭������֮ǰ�༭����
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editRow=0;
}


/// ����༭��
function saveEntyRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = extraAttr +"^"+ extraAttrValue;

	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else if(jsonString == -98){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
		}else if(jsonString == -99){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		InitPageInfo();		
		//$('#diclist').datagrid('reload'); //���¼���
	});
}

/// ɾ������
function deleteRow(){
	 
	var rowsData = $("#diclist").datagrid('getSelected'); 						// ѡ��Ҫɾ������
	
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫͣ����Щ������", function (res) {	 // ��ʾ�Ƿ�ɾ��
			if (res) {
				var StopDate=SetDateTime("date");
				var StopTime=SetDateTime("time");
				SetFlag="stop"        //ͣ�����ݱ��
				DicName="DHC_CKBCommonDiction"
				dataid=rowsData.ID
				Operator=LgUserID
	  			runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":ClientIPAddress,"Type":'log'},function(getString){
					if (getString == 0){
						Result = "�����ɹ���";
					}else if(getString == -1){
						Result = "��ǰ���ݴ�������ֵ,������ͣ��";
					}else{
						Result = "����ʧ�ܣ�";	
					}
				},'text',false);
				$.messager.popover({msg: Result,type:'success',timeout: 1000});
				$('#diclist').datagrid('reload'); //���¼���
			}
		}); 
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫͣ�õ���','warning');
		 return;
	}
	
	/*
	var delFlag=CheckDicLink(rowsData.ID)

	if (!delFlag){
		$.messager.alert('��ʾ','�����ӽڵ���߹������ԣ�����ɾ���ӽڵ���������','warning');
		return;
	}
	
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {				
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						
						$('#diclist').datagrid('reload'); //���¼���
					}else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
						 return;
					}					
				},"",false)
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
	*/
}

/// �ж��Ƿ����ӽڵ���߹�������
function CheckDicLink(dicID){
	
	var ret=true;
	runClassMethod("web.DHCCKBDiction","CheckDicLink",{"dicID":dicID},function(jsonString){
		if (jsonString == 0){						
				ret=false;
			}else{
				ret=true;
			}					
		},"",false);

	return ret;	
	
}
// ��ѯ
function QueryDicList(){
	var params = $HUI.searchbox("#queryCode").getValue();
	
	$('#diclist').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:extraAttrValue,
		params:params,
		drugType:InitDrugType()
	}); 
	
	dicID = ""; //����ѡ����Ŀ
	$("#attrlist").datagrid("load",{});
	if ($("#tabscont")[0].contentWindow){
		$("#tabscont")[0].contentWindow.CatId = "";
		$("#tabscont")[0].contentWindow.serchAddattr();
	}

}

// ����
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	$("#div-img").show();

}

/// �򿪴����л����ṩ����ҳ����ã�
function OpenEditWin(linkUrl,title){

	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		maximized:true,
		maximizable:true,
		width:800,
		height:500
	});	

	$('#winmodel').html(linkUrl);
	$('#winmodel').window('open');

}
///�����б�
function initattrGrid()
{
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'code',title:'����',width:50,hidden:true},
		{field:'desc',title:'����',width:650}
	]];
	
	///  ����datagrid
	var option = {
		fitColumns:true,
		toolbar:[],
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {}	//˫��ѡ���б༭
	};
	
	var params=dicID +"^"+ "LinkProp"

	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryDicAttr&params="+params;
	new ListComponent('attrlist', columns, uniturl, option).Init();
}
///��������
function initaddattrGrid()
{
	
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
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'AttrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrDr'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrCode'});
				var AddAttrID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'AttrDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAttrValue&AddAttrID="+ AddAttrID;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}
	///  ����columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult"
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'ʵ��ID',width:100,editor:textEditor,hidden:true},
		{field:'DLAAttrCode',title:'����id',width:150,editor:textEditor,hidden:true},
		{field:'DLAAttrCodeDesc',title:'��������',width:200,editor:textEditor},	
		{field:'DLAAttrDr',title:'����ֵid',width:80,editor:textEditor,hidden:true},	
		/* {field:'DLAAttrDesc',title:'����ֵ����',width:200,editor:Attreditor},	 */	
		{field:'DLAAttrDesc',title:'����ֵ����',width:300,editor:textEditor},
		{field:'DLAResult',title:'��ע',width:200,editor:textEditor,hidden:true}
	]];
	///  ����datagrid
	var option = {
		singleSelect : true,
	    onClickRow: function (rowIndex, rowData) {		//������ѡ���б༭
           editaddRow=rowIndex;
        },
        onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
           editaddRow=rowIndex;
           ShowAllData();
        }
	};
	
	var params=dicID +"^"+ extraAttr +"^"+"ExtraProp";
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAddLinkAttr&params="+params;
	new ListComponent('addattrlist', columns, uniturl, option).Init();
}
function LoadattrList(title)
{  
	if (title == "����"){ //hxy 2018-09-17 ����
		 var attr=dicID +"^"+ "LinkProp"
		 $("#attrlist").datagrid("load",{"params":attr});
	}else{
		 switchMainSrc(dicID)
	}
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
        iconCls:'icon-write-order',
        resizable:true,
        title:'���',
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
				$("#dicgrid").datagrid("unselectAll");	
				$("#attrtree").tree("unselectAll");	     
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
		//checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  //�Ƿ�����顣Ĭ��true  �˵����⣬����������
		animate:false     	//�Ƿ���չ���۵��Ķ���Ч��		
	});
	
	var extraAttrValue = "DictionFlag" 	// knowledge-����
	// ����
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	var DicTree = $HUI.tree("#dictree",{
		url:uniturl, 
   		lines:true,  //���ڵ�֮����ʾ����
		autoSizeColumn:false,
		//checkbox:true,
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
	
	// �ֵ�
	var diccolumns=[[   	 
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
	new ListComponent('dicgrid', diccolumns, uniturl, option).Init();
  
    // ʵ��
	var entitycolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left'},
			{field:'CDDesc',title:'����',width:300,align:'left'}			
		 ]]
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('entitygrid', entitycolumns, uniturl, option).Init();

}
/// ����
function SaveFunLib(){

	var currTab = $('#tabOther').tabs('getSelected');
	var currTabTitle = currTab.panel('options').title;
	var selectID=""
	var selectDesc=""
	
	
	if (currTabTitle.indexOf("����")!=-1){					// ѡ������
		var attrrow = $('#attrtree').tree('getSelected');	// ��ȡѡ�е���  
		selectID = $g(attrrow)==""?"":attrrow.id;
		selectDesc =  $g(attrrow)==""?"":attrrow.code;
		
	}else if(currTabTitle.indexOf("�ֵ�") != -1){				// ѡ���ֵ�
	
		var dicrow =$('#dictree').tree('getSelected');	// ��ȡѡ�е���
		selectID = $g(dicrow)==""?"":dicrow.id;
		selectDesc =  $g(dicrow)==""?"":dicrow.code;
		
	}else if(currTabTitle.indexOf("ʵ��") != -1){				// ѡ��ʵ��
	
		var entityrow =$('#entitygrid').datagrid('getSelected'); // ��ȡѡ�е���  
		selectID = $g(entityrow)==""?"":entityrow.ID;
		selectDesc =  $g(entityrow)==""?"":entityrow.CDDesc;
	}

	if ($g(selectID) == ""){	
		 $.messager.alert('��ʾ','��ѡ��һ�����Ի��ֵ��ʵ�壡','info');
		 return;	
	} 
	
	/// �������Խ��渳ֵ
	$('#addattrlist').datagrid('beginEdit', editaddRow);	
	//var attrDescObj=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
	//$(attrDescObj.target).val(selectDesc);
	var attrDrObj=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrDr'});
	$(attrDrObj.target).val(selectID);
	$('#addattrlist').datagrid('endEdit', editaddRow);
	saveRow();

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
	var rowData = $('#addattrlist').datagrid('getSelected');	// ��ȡѡ�е���  
	if(rowData==null){
		$.messager.alert("��ʾ","��ѡ�񸽼����ԣ�")
		return false;
	}
	removeCom("User.DHCCKBDicLinkAttr","#addattrlist")
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
	if(searcode==""){
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	}else{
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	}
	$("#dictree").tree('options').url =encodeURI(uniturl);
	$("#dictree").tree('reload');
}
///��������
function Refreshdic()
{
	$HUI.searchbox("#dictreecode").setValue("");
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
///����datagrid
function reloadPagedg()
{
	QueryDicList();
}

/// ҩƷ����
function InitDrugType(){
	
	var drugType = getParam("DrugType");	
	return drugType;

}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
