//===========================================================================================
// Author��      qunianpeng
// Date:		 2019-01-04
// Description:	 �°��ٴ�֪ʶ��-�ֵ�����
//===========================================================================================

var editRow = 0;
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
var parref = getParam("parref");

/// ҳ���ʼ������
function initPageDefault(){
	
	InitButton();		// ��ť��Ӧ�¼���ʼ��
	InitCombobox();		// ��ʼ��combobox
	InitSubDataList();  // ҳ��DataGrid��ʼ������
}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	/// ����.������ѯ
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#subQueryCode').searchbox({
	    searcher:function(value,name){
	   		SubQueryDicList();
	    }	   
	});
	
	$("#subinsert").bind("click",SubInsertRow);	// ��������
	
	$("#subsave").bind("click",SubSaveRow);		// ����
	
	$("#subdel").bind("click",SubDelRow);	// ɾ��
	
	//$("#subfind").bind("click",SubQueryDicList);	// ��ѯ
	
	$("#reset").bind("click",InitPageInfo);	// ����
	
}

/// ��ʼ��combobox
function InitCombobox(){}


/// ҳ��DataGrid��ʼ����ͨ����
function InitSubDataList(){
						
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
			{field:'CDDesc',title:'����',width:400,align:'left',editor:texteditor},
			{field:'Parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"��������",width:200,align:'left',hidden:true},
			{field:'Operating',title:'����',width:200,align:'center',formatter:SetCellOperation} 
			
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
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#subdiclist").datagrid('endEdit', editRow); 
            } 
            $("#subdiclist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onLoadSuccess:function(data){
            $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({});
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+parref+"&parrefFlag=0&parDesc=";
	new ListComponent('subdiclist', columns, uniturl, option).Init();
	
}

/// sub��������
function SubInsertRow(){
	
	if(editRow>="0"){
		$("#subdiclist").datagrid('endEdit', editRow);		//�����༭������֮ǰ�༭����
	}
	$("#subdiclist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#subdiclist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editRow=0;
}

/// sub����
function SubSaveRow(){
	
	if(editRow>="0"){
		$("#subdiclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#subdiclist").datagrid('getChanges');
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

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
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

	var rowsData = $("#subdiclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					$('#subdiclist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// sub ��ѯ
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	
	$('#subdiclist').datagrid('load',{
		id:id,
		parrefFlag:0,
		parDesc:params
	}); 
}

// ����
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#subQueryCode').setValue("");
	SubQueryDicList();	
	//$("#div-img").show();

}

///���ò�����ϸ����
function SetCellOperation(value, rowData, rowIndex){

	///<a href='#' onclick=\"showAuditListWin('"+a+"','"+a+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>����</a>";
	/* var btnGroup="<a style='margin-right:10px;' href='#' onclick=\"switchMainSrc('"+rowData.ID+"','list','"+rowData.DataType+"')\">����</a>"; */
	/*var btnGroup="";
	btnGroup = btnGroup + "<a style='margin-right:10px;display:none' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','prop','"+rowData.DataType+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>����</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>��������</a>";
	
	return btnGroup;
	*/
	var btn = "<img class='mytooltip' title='��������' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  
}

/// ���Ա༭��
function OpenEditWin(ID,model,dataType){

	var linkUrl="",title=""
	if (model == "list"){
		
		linkUrl = "dhcckb.addlist.csp"
		title = "�ֵ�ά��"
		
	}else if (model =="prop"){
		
		linkUrl = "dhcckb.addattr.csp";
		title = "�����б�";
		
	}else if (model == "linkprop"){
		
		linkUrl = "dhcckb.addlinkattr.csp";
		title ="��������ά��";
		
	}else {
		linkUrl = "dhcckb.addlist.csp"
		title = "�ֵ�ά��"
	}	

	linkUrl += '?parref='+ID;
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += "&MWToken="+websys_getMWToken(); 
	}
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';

	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		minimizable:false,
		//maximized:true,
		maximizable:true,
		width:900,
		height:550
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
