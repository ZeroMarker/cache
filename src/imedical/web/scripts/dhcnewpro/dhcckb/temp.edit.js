//===========================================================================================
// Author��      kemaolin
// Date:		 2020-01-20
// Description:	 �°��ٴ�֪ʶ��-ģ��ά������
//===========================================================================================

var tempDataId=serverCall("web.DHCCKBCommon","GetDicIdByCode",{'code':'TempData'}); //ģ���ֵ�Id
var tempElemCode="TempElement"  //ģ��Ԫ��Code
var tempElemId=serverCall("web.DHCCKBCommon","GetDicIdByCode",{'code':'TempElement'}); //ģ��Ԫ��Id
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
var extraAttrDic = "DictionFlag"	//�ֵ���
//var propId="" //ʵ������Id
var propList=[];
var delPropList=[];
var tempId="" //ģ��Id
var dicID=""; //ʵ��Id	
var editRow=0 //,editsubRow = 0;	
var queryDicID="";
var queryParams="";
var TempWinFlag="";   //sufan  ��¼��������
/// JQuery ��ʼ��ҳ��
$(function(){ 
	
	initPageDefault(); 
})

/// ҳ���ʼ������
function initPageDefault(){
	
	InitButton();			// ��ť��Ӧ�¼���ʼ��
	//InitCombobox();			// ��ʼ��combobox
	InitEntityCombobox();
	InitDicCombobox();
	initTempElemGrid();
	initAttrGrid();
	initTempTree();				//sufan 2020-03-27 �������ط���
	//InitSubDataList();		//sufan 2020-03-27 ģ�������μ���ά������ע��
	
}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#insert").bind("click",SubInsertRow); //ģ��������
	$("#save").bind("click",SubSaveRow); //ģ�屣��
	$("#delete").bind("click",SubDelRow); //ģ��ɾ��
	$("#addTempElem").bind("click",addTempElem); //���ģ��Ԫ�� 
	$("#removeTempElem").bind("click",removeTempElem); //�Ƴ�ģ��Ԫ�� 	
	//������
	$('#queryEnt').searchbox({
	    searcher:function(value,name){
	   		queryEnt();
	    }	   
	});	
	
	$('#queryDic').searchbox({
	    searcher:function(value,name){
	   		queryDic();
	    }	   
	});
	$("#canwin").bind("click",canWin); 		//�رմ���
	
	$("#saveTree").bind("click",saveTree);
	
	$('#tempsearch').searchbox({
	    searcher:function(value,name){
	   		QueryTemp();
	    }	   
	});	
	
}

// ��ѯ
function queryEnt()
{
	var query = $HUI.searchbox("#queryEnt").getValue();
	
	$('#attrlist').datagrid('load',{
		query:query,
		listType:1,
		params:queryParams
	}); 
}
function queryDic()
{
	var query = $HUI.searchbox("#queryDic").getValue();
	
	$('#attrlist').datagrid('load',{
		query:query,
		listType:0,
		id:queryDicID
	}); 
}
/// ��ʼ��combobox
//=================================ʵ��������=================================================
function InitEntityCombobox(){
		
	/// ��ʼ�����������
	var option = {
		panelHeight:"250", //auto
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       dicID = option.value;
 		   var params=dicID +"^"+ "LinkProp";
 		   queryParams=params;
		   $("#attrlist").datagrid("load",{"params":params,'listType':1});
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("entityType",url,'',option).init(); 	
}

//=================================�ֵ�������=================================================
function InitDicCombobox(){
		
	/// ��ʼ�����������
	var option = {
		panelHeight:"250", //auto
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       dicID = option.value;
	       queryDicID=dicID;
	       //$("#attrlist").datagrid('options').url=$URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID";
 		   //var params=dicID +"^"+ "LinkProp"
		   $("#attrlist").datagrid("load",{'id':dicID,'listType':0});
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrDic;
	new ListCombobox("dicType",url,'',option).init(); 	
}

//=================================ģ�����Թ����б�=================================================
///ģ�����Թ����б�
function initTempElemGrid()
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
		{field:'linkRowId',title:'linkRowId',width:50,editor:textEditor,hidden:false},
		{field:'attrCodeDr',title:'attrCodeDr',width:50,hidden:true},
		{field:'attrCodeDesc',title:'attrCodeDesc',width:450,hidden:true},
		{field:'attrValueDr',title:'Ԫ��id',width:100},
		{field:'attrValue',title:'����',width:450},
		{field:'attrResult',title:'attrResult',width:450,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		fitColumns:true,
		//singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//˫��ѡ���б༭
	    //onClickRow: function(rowIndex,rowData){
	 	//}, 
	};
	 //w ##class(web.DHCCKBDicLinkAttr).QueryDicLinkAttr("10","1","4072^2860^5282")
	var params=tempId +"^"+ tempElemId;
	var uniturl = $URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryDatagridDicLinkAttr&params="+params;
	new ListComponent('tempElement', columns, uniturl, option).Init();
}

/// �����Ƴ�
function removeTempElem(){

	//var rowsData = $("#tempElement").datagrid('getSelected'); //ѡ��Ҫɾ������
	//if (rowsData != null) {
	delPropList=$("#tempElement").datagrid('getSelections');
	var RowIDList=""
	$.each(delPropList,function(index,item){
		if(RowIDList==""){
			RowIDList=item.linkRowId
		}else{
			RowIDList=RowIDList+"&"+item.linkRowId
		}
	})
	if(RowIDList!=""){
		//$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
		//	if (res) {
				runClassMethod("web.DHCCKBDicLinkAttr","DelData",{"params":RowIDList},function(jsonString){					
					if (jsonString==0){
						var params=tempId +"^"+ tempElemId;
						$('#tempElement').datagrid('load',{'params':params}); //���¼���
					}
					else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
					}
					
				})
		//	}
		//});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

//����ģ��Ԫ��
function addTempElem(){
	
	var node = $("#tempTree").tree('getSelected');
	var isLeaf = $("#tempTree").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
    if (!isLeaf){
        $.messager.alert("��ʾ","��ѡ��ĩ���ڵ���ӣ�")
        return;
    }
    tempId=node.id;
	propList=$("#attrlist").datagrid('getSelections');
	if(propList.length==0){
		$.messager.alert("��ʾ","��ѡ��ʵ������")
		return;	
	}
	var listData=""
	
	$.each(propList,function(index,item){
		if(listData==""){
			listData="^"+tempId+"^"+tempElemId+"^"+item.ID+"^"+tempElemCode;
		}else{
			listData=listData+"&&"+"^"+tempId+"^"+tempElemId+"^"+item.ID+"^"+tempElemCode;
		}
	})
	//var ListStr="0" +"^"+ tempId +"^"+ tempElemId +"^"+ "" +"^"+ ""
	//var ListData ="^"+tempId+"^"+tempElemId+"^"+propId+"^"+tempElemCode;
	//var Type="datagrid" ;
	//��������
	runClassMethod("web.DHCCKBDicLinkAttr","saveGridData",{"ListData":listData,"repeatFlag":1},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			var params=tempId +"^"+ tempElemId;
			$('#tempElement').datagrid('load',{'params':params}); //���¼���
			return;	
		}else{
			//$.messager.alert('��ʾ','����ɹ���','info');
	 		var params=tempId +"^"+ tempElemId;
			$('#tempElement').datagrid('load',{'params':params}); //���¼���
			return;
		}
	});
}
//======================================ʵ�������б�===========================================================

///ʵ�������б�
function initAttrGrid()
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
		//singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//˫��ѡ���б༭
	    //onClickRow: function(rowIndex,rowData){
	 	//	propId=rowData.ID;
	 	//}, 
	};
	
	var params=dicID +"^"+ "LinkProp"
	//var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryDicAttr&params="+params;
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicAndAttrList&params="+params+"&listType=1";
	new ListComponent('attrlist', columns, uniturl, option).Init();
}

//==================================================ģ��ά������============================================================//
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
		//bordr:false,
		//fit:true,
		fitColumns:true,
		singleSelect:true,	
		//nowrap: false,
		//striped: true, 
		//pagination:true,
		//rownumbers:true,
		//pageSize:30,
		//pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){
	 		tempId=rowData.ID;
	 		//var params=tempId +"^"+ tempElemCode
	 		var params=tempId +"^"+ tempElemId
	 		$("#tempElement").datagrid("load",{"params":params});

	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#templist").datagrid('endEdit', editRow); 
            } 
            $("#templist").datagrid('beginEdit', rowIndex); 
            
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
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+tempDataId+"&parrefFlag=0&parDesc=";
	new ListComponent('templist', columns, uniturl, option).Init();
	
}

/// sub��������
function SubInsertRow(){
	
	if(editRow>="0"){
		$("#templist").datagrid('endEdit', editRow);		//�����༭������֮ǰ�༭����
	}
	$("#templist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#templist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editRow=0;
}

/// sub����
function SubSaveRow(){
	
	if(editRow>="0"){
		$("#templist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#templist").datagrid('getChanges');
	
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

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc) +"^"+ tempDataId;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			return;	
		}else{
			$.messager.alert('��ʾ','����ɹ���','info');
			var params=tempId +"^"+ tempElemId
	 		$("#templist").datagrid("load",{"params":params});
			return;
		}	
	});
}

/// subɾ��
function SubDelRow(){

	var rowsData = $("#templist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){					
					if (jsonString==0){
						var params=tempId +"^"+ tempElemId
	 					$("#templist").datagrid("load",{"params":params});
					}else if (jsonString == "-1"){
						 $.messager.alert('��ʾ','�������ѱ�����,����ֱ��ɾ����','warning');
					}
					else{
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
/*
/// sub ��ѯ
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	
	$('#templist').datagrid('load',{
		id:tempDataId,
		parrefFlag:0,
		parDesc:params
	}); 
}

// ����
function InitSubPageInfo(){

	$HUI.searchbox('#subQueryCode').setValue("");
	SubQueryDicList();	

}
*/

//===========================================�������Ե���========================================================

///���ò�����ϸ����
function SetCellOperation(value, rowData, rowIndex){
	var btn = "<img class='mytooltip' title='��������' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  
	
}

/// ����ֵ�༭��
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

	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?parref='+ID+'"></iframe>';

	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		maximizable:true,
		minimizable:false,		
		width:$(window).width()-50, //800,
		height:$(window).height()-50,//500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}
/*========================sufan 2020-03-27start===========================================================================*/
function initTempTree()
{
	
	uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryTempTree&ParentId='+tempDataId+"&Input=";
	var option = {
		multiple:true,
		lines:true,
		animate:true,
		dnd:true,
        onClick:function(node, checked){
	        var isLeaf = $("#tempTree").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        var params=node.id +"^"+ tempElemId;
				$('#tempElement').datagrid('load',{'params':params}); //���¼���
	        }else{
		    	
		    }
	    }, 
		onContextMenu: function(e, node){
			
			e.preventDefault();
			var node = $("#tempTree").tree('getSelected');
			if (node == null){
				$.messager.alert("��ʾ","��ѡ�нڵ������!"); 
				return;
			}
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onLoadSuccess: function(node, data){
			
		}
	};
	new CusTreeUX("tempTree", uniturl, option).Init();
}
///����ģ��
function newCreateItmCat(type)
{
	TempWinFlag = type;
	var node = $("#tempTree").tree('getSelected');
	newCreateItmCatWin(type);      
	InitItmCatDefault(type);   		
}

/// Window ����
function newCreateItmCatWin(type){
	
	/// ���ര��
	var option = {
		modal:false,
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	var title = "�����¼�";
	if (type == "S"){
		title = "����ͬ��";
	}
	if(type == "U"){
		title = "���� ";
	}
	
	new WindowUX(title, 'samewin', '400', '200', option).Init();
}
/// ��ʼ������Ĭ����Ϣ
function InitItmCatDefault(type){
	
	$("#sametpdesc").val("");    	/// ����
	$("#sametpcode").val("");   	/// ����
	var node = $("#tempTree").tree('getSelected');
	if(type=="N"){
		$("#lastsameId").val(node.id);
		$("#lastsamedesc").val(node.text);
	}else if(type=="U"){
		var List = serverCall("web.DHCCKBDiction","GetLastList",{"Id":node.id});
		var Array = List.split("^"); 
		$("#sametpcode").val(node.code);
		$("#sametpdesc").val(node.text);
		$("#lastsameId").val(Array[0]);
		$("#lastsamedesc").val(Array[1]);
		
	}else{
		var List = serverCall("web.DHCCKBDiction","GetLastList",{"Id":node.id});
		var Array = List.split("^"); 
		$("#lastsameId").val(Array[0]);
		$("#lastsamedesc").val(Array[1]);
	}
}
/// �رմ���
function canWin()
{
	$("#samewin").window('close');
}
///����
function saveTree()
{
	var node = $("#tempTree").tree('getSelected');
	var Code = $("#sametpcode").val();
	var Desc = $("#sametpdesc").val();
	if((Code=="")||(Desc=="")){
		$.messager.alert("��ʾ","�������������Ϊ�գ�");
		return;
	}
	var LastId = $("#lastsameId").val();
	if(TempWinFlag == "U"){
		var ListData = node.id +"^"+ Code +"^"+ Desc +"^"+ LastId;
		
	}else{
		var ListData = "" +"^"+ Code +"^"+ Desc +"^"+ LastId;
	}
	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":ListData,"attrData":""},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			return;	
		}else{
			$.messager.alert('��ʾ','����ɹ���','info');
			canWin();
			$("#tempTree").tree('reload');
			return;
		}	
	});
}
///ɾ��
function DeleTree()
{
	
	var node = $("#tempTree").tree('getSelected');
	if (node != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleTree",{"dicID":node.id},function(jsonString){
					if(jsonString==-1){
						$.messager.alert("��ʾ","��ģ����ڹ������ݣ�");
						return;
					}
					$("#tempTree").tree('reload');
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
///��ѯ
function QueryTemp()
{
	var Input = $.trim($HUI.searchbox("#tempsearch").getValue());
	uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryTempTree&ParentId='+tempDataId+"&Input="+Input;
	$("#tempTree").tree('options').url =encodeURI(uniturl);
	$("#tempTree").tree('reload');
}
