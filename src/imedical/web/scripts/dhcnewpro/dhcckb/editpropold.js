//===========================================================================================
// Author��      qunianpeng
// Date:		 2019-06-28
// Description:	 �°��ٴ�֪ʶ��-ʵ��ά������
//===========================================================================================

var editRow = 0;
var subEditRow = 0; 
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
var parref = "";					// ����ҩƷid
var dicParref = ""					// ҩƷʵ��id
/// ҳ���ʼ������
function initPageDefault(){
	
	InitDataList();		// ҳ��DataGrid��ʼ������
	InitButton();		// ��ť��Ӧ�¼���ʼ��
	InitCombobox();		// ��ʼ��combobox
	InitSubDataList();  // ҳ��DataGrid��ʼ������
	InitAttrValueList(); // 
}


/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#insert").bind("click",InsertRow);	// ��������
	
	$("#save").bind("click",SaveRow);		// ����
	
	$("#delete").bind("click",DeleteRow);	// ɾ��
	
	$("#find").bind("click",QueryDicList);	// ��ѯ
	
	$("#reset").bind("click",InitPageInfo);	// ����
	
	/// ����.������ѯ
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});
	
	$("#subinsert").bind("click",SubInsertRow);	// ��������
	
	$("#subsave").bind("click",SubSaveRow);		// ����
	
	$("#subdel").bind("click",SubDelRow);	// ɾ��
	
	$("#subfind").bind("click",SubQueryDicList);	// ��ѯ
	
	$("#test").bind("click",AddAttrValue);	// ��ѯ
	//$("#subreset").bind("click",InitPageInfo);	// ����
	
}

/// ��ʼ��combobox
function InitCombobox(){
		
	/// ��ʼ�����������
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        dicParref = option.value;
	       	QueryDicList();
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("dicType",url,'',option).init(); 	
}


/// ҳ��DataGrid��ʼ����ͨ����
function InitDataList(){
						
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns
	var columns=[[   	 
			{field:'dicID',title:'rowid',hidden:true},
			{field:'dicCode',title:'����',width:200,align:'left',editor:texteditor},
			{field:'dicDesc',title:'����',width:300,align:'left',editor:texteditor},
			{field:'parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'parrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true}
			/* {field:'Operating',title:'����',width:380,align:'left',formatter:SetCellOperation} */
			
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
 			parref=rowData.dicID;  
		   	SubQueryDicList(rowData.dicID);		 
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
           /*  if (editRow != ""||editRow == 0) { 
                $("#diclist").datagrid('endEdit', editRow); 
            } 
            $("#diclist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex;  */
        }
		  
	}
	var params = ""
	var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params;
	
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

// ��������
function InsertRow(){
	
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

// ɾ��ѡ����
function DeleteRow(){
	
	var rowsData = $("#diclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"typeID":rowsData.ID},function(jsonString){
					$('#diclist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ����༭��
function SaveRow(){
	
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
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			InitPageInfo();
			return;	
		}else{
			$.messager.alert('��ʾ','����ɹ���','info');
			InitPageInfo();
			return;
		}
		
		//$('#diclist').datagrid('reload'); //���¼���
	});
}

/// ɾ������
function DeleteRow(){
	 
	var rowsData = $("#diclist").datagrid('getSelected'); 						// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						$('#diclist').datagrid('reload'); //���¼���
					}else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
					}					
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}

}

// ��ѯ
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();

	$('#diclist').datagrid('load',{
		extraAttr:"DataSource",
		parref:dicParref,
		params:params
	}); 
}


/// ҳ��DataGrid��ʼ����ͨ����
function InitSubDataList(){
						
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var attreditor={  
		type: 'combobox',	//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#linkattrlist").datagrid('getEditor',{index:subEditRow,field:'attrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#linkattrlist").datagrid('getEditor',{index:subEditRow,field:'attrID'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){				
				var ed=$("#linkattrlist").datagrid('getEditor',{index:subEditRow,field:'attrDesc'});
				///���ü���ָ��
				var params=parref+"^"+"LinkProp"+ "^"+ dicParref;
				var unitUrl=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicAttrList&params="+ params;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}
	
	// ����columns	 // linkRowID^attrID^dataType^linkAttrDr^linkAttrValue
	var columns=[[   // ������id ,����id,�������������Ե���������, ����ֵid������ֵ����(��Ҫ�������ʱ��)	 
			{field:'linkRowID',title:'rowid',hidden:true},
			{field:'attrID',title:'����id',width:60,align:'left',editor:texteditor,hidden:true},
			{field:'attrDesc',title:'����',width:300,align:'left',editor:attreditor},
			{field:'dataType',title:'��������',width:300,align:'left',hidden:false},
			{field:'linkAttrDr',title:'����ֵID',width:300,align:'left',editor:texteditor,hidden:false},
			{field:'linkAttrValue',title:'����ֵ',width:300,align:'left',editor:texteditor,hidden:false}
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
		   
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (subEditRow != ""||subEditRow == 0) { 
                $("#linkattrlist").datagrid('endEdit', subEditRow); 
            } 
            $("#linkattrlist").datagrid('beginEdit', rowIndex); 
            
            subEditRow = rowIndex; 
            dataGridBindEnterEvent(rowIndex);
        }
		  
	}
	var params = "" +"^"+ "LinkProp";
	var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetLinkAttrListData&params="+params;

	new ListComponent('linkattrlist', columns, uniturl, option).Init();
	
}

/// sub��������
function SubInsertRow(){
	
	if(subEditRow>="0"){
		$("#linkattrlist").datagrid('endEdit', subEditRow);		//�����༭������֮ǰ�༭����
	}
	$("#linkattrlist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#linkattrlist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	subEditRow=0;
	dataGridBindEnterEvent(subEditRow);
}

/// sub����
function SubSaveRow(){
	
	var parrefObj = $("#diclist").datagrid('getSelected');
	var tmpparref = $g(parrefObj.dicID)
	
	if(subEditRow>="0"){
		$("#linkattrlist").datagrid('endEdit', subEditRow);
	}

	var rowsData = $("#linkattrlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
	
		if((rowsData[i].linkAttrValue=="")){
			$.messager.alert("��ʾ","����ֵ����Ϊ��!"); 
			return false;
		}
		var linkAttrValue = $g(rowsData[i].linkAttrDr) =="" ? $g(rowsData[i].linkAttrValue) :"" ;	// ����ֵid��Ϊ�գ��������ֶ�Ϊ��
		var tmp=$g(rowsData[i].linkRowID) +"^"+ tmpparref +"^"+ $g(rowsData[i].attrID) +"^"+ linkAttrValue +"^"+ $g(rowsData[i].linkAttrDr);
		
		dataList.push(tmp);
	} 
	var ListData=dataList.join("&&");

	//��������
	runClassMethod("web.DHCCKBDicLinkAttr","SaveDicAttr",{"ListData":ListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			SubQueryDicList(parref);
			return;	
		}else{
			$.messager.alert('��ʾ','����ɹ���','info');
			SubQueryDicList(parref);
			return;
		}
		
		//$('#diclist').datagrid('reload'); //���¼���
	});
}

/// subɾ��
function SubDelRow(){

	var rowsData = $("#linkattrlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDicLinkAttr","DelDicAttr",{"linkRowID":rowsData.linkRowID},function(jsonString){
					$('#linkattrlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

function SubQueryDicList(id){

	//var params = $HUI.searchbox("#subQueryCode").getValue();
	$('#linkattrlist').datagrid('load',{
		params:id +"^"+"LinkProp"
	}); 
}

/// 
function dataGridBindEnterEvent(index){
	
	subEditRow=index;
		
	var rows = $("#linkattrlist").datagrid("getRows");
	var row = rows[index];
	var htmlType=$g(row.dataType);
	if (htmlType == ""){htmlType="textarea"}
	
	var editors = $('#linkattrlist').datagrid('getEditors', index);
	for(var i=0;i<editors.length;i++){
		var workRateEditor = editors[i];
		
		//����ֵ  linkAttrValue
		if(workRateEditor.field=="linkAttrValue"){
			workRateEditor.target.mousedown(function(e){
				var ed=$("#linkattrlist").datagrid('getEditor',{index:index, field:'linkAttrValue'});		
				var input = $(ed.target).val();
				divComponent({tarobj:$(ed.target),htmlType:htmlType,width: 400,height: 260},function(obj){
					//var ed=$("#linkattrlist").datagrid('getEditor',{index:index, field:'linkAttrDr'});						
					//$(ed.target).val(obj);				
				})				
			});
		}
		else{
			workRateEditor.target.mousedown(function(e){
					$("#win").remove();;
			});
			workRateEditor.target.focus(function(e){
					$("#win").remove();;
			});
		}
	}
}

// ����
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	//$("#div-img").show();

}

/// ҳ������ֵtreeGrid��ʼ����
function InitAttrValueList(){
						
	// ����columns
	var columns=[[     
			{field:'id',title:'id',width:80,sortable:true,hidden:true},
			{field:'code',title:'����',width:80,sortable:true,hidden:true},
			{field:'desc',title:'����',width:360,sortable:true,hidden:false},
			{field:'_parentId',title:'parentId',width:80,sortable:true,hidden:true}				
		 ]]

	var option={	
		height:$(window).height()-105,
		idField: 'id',
		treeField:'desc',
		checkbox:true,
		fitColumns:true,	//����Ϊ true������Զ��������С�еĳߴ�����Ӧ����Ŀ�Ȳ��ҷ�ֹˮƽ����
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		lines:true,		
		showHeader:false,
		pagination:false,
		rownumbers:false,
		//pageSize:30,
		//pageList:[30,60,90],				
		onDblClickRow: function (rowIndex, rowData) {	//˫��ѡ���б༭
        }		  
	}
	
	var params = ""
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonNew&attrID=99&input=" //$URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibItemDs";
	new ListTreeGrid('mygrid', columns, uniturl, option).Init();
	
}

///	�༭����ֵ 
function AddAttrValue(){
	//var htmlType="textarea" //attrId
	var htmlType="treegrid";
	$("#myWin").show();
	
	if (htmlType == "textarea"){
	
	}else if (htmlType == "treegrid"){
		
	}else if(htmlType == "input"){
		
	}else if(htmlType == "checkbox"){
	
	}else{
	
	}
	var options={}
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonNew&attrID=99&input=" 
	$('#mygrid').treegrid(options);
	$('#mygrid').treegrid('reload');
	/*$('#mygrid').datagrid('reload',  { 
	    ClassName:"web.DHCCKBQueryDic",
	    QueryName:"GetTreeJsonNew",
	    attrID:"99",
        input:""
	});
	*/
	
	$("#my"+htmlType).show();	
	
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-addlittle',
		resizable:true,
		title:'���',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'����',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				console.log($('#mygrid').treegrid('getCheckedNodes','checked'));
				SaveDicTree()
			}
		},{
			text:'�ر�',
			handler:function(){
				myWin.close();
			}
		}]
	});	
}

/// ��������ֵ
function SaveAttrValue(){



}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
