//===========================================================================================
// Author��      lidong
// Date:		 2022-9-7
// Description:	 ������򵯳�ҳ��
//===========================================================================================
var editRow = 0;
var subEditRow = 0; 
var valeditRow = 0;
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
var parref = "";					// ����ҩƷid
var dicParref = "";					// ҩƷʵ��id
var EntLinkId="";					// ����Id
var DataType=""
var Parref=""
var NodeId=""
/// ҳ���ʼ������
function initPageDefault(){
	
	InitButton();			// ��ť��Ӧ�¼���ʼ��
	InitCombobox();			// ��ʼ��combobox
	InitDataList();			// ʵ��DataGrid��ʼ������
	InitTree();
	
	InitGetData()
	
	$('#showlist').panel('resize', {
        height:$(window).height()-105
    }); 
     if (DataType=="tree"){
		$("#dictree").resizable({
	   		maxHeight : $(window).height()-105
		});
    }else{
		$("#DicList").datagrid('resize', { 
            height : $(window).height()-105
   		});
	}	

}
/// ��ʼ�����������Ϣ /�ֵ�����/��¼��/������
function InitGetData(){
	Parref = getParam("Parref");				//��������ֵ�ID
	NodeId = getParam("NodeId");				//������Ⱥ����ID
	          
}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#reset").bind("click",InitPageInfo);	// ����	
	
	$("#treereset").bind("click",InitTreeData);	// ����		
	
	$('#queryCode').searchbox({
		
	    searcher:function(value,name){
		    if (DataType == "tree"){
				$("#dictree").tree("search", value)
			}else{
				QueryDicList();
			}
	    }	   
	});		
	
	$('#treequery').searchbox({
		
	    searcher:function(value,name){
		    if (DataType == "tree"){
				$("#dictree").tree("search", value)
			}
	    }	   
	});	
		
}
/// ��ʼ��combobox
function InitCombobox(){
	
	/// ��ʼ�����������
	var option = {
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       dicParref = option.value;
	       runClassMethod("web.DHCCKBEditDiction","GetDicDataType",{'dicID':dicParref},function(ret){
				DataType=ret;
				},'text',false);
		   if(DataType=="tree")
		   	   {
			   $("#treediv").show();
			   $("#griddiv").hide();
			   $("#toolbartree").show();
			   var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+dicParref+"&hospID="+LgHospID+"&groupID="+LgGroupID+"&locID="+LgCtLocID+"&userID="+LgUserID
			   $('#dictree').tree({url:uniturl}); 
			   $("#DicList").datagrid("reload")
			   }
			   else
			   {
			   $("#treediv").hide();
			   $("#toolbartree").hide();	
			   $("#griddiv").show();
	       	   $("#DicList").datagrid("load",{"id":dicParref});
	       	   $("#dictree").tree("reload")
			   }

	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	new ListCombobox("dicType",url,'',option).init(); 
	new ListCombobox("treeType",url,'',option).init();
	
	$('#dicDesc').combobox({
		url:url,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		editable:false
	})
	
	
}

function InitComboboxAll(){
		$("#dictree").tree("search", "")
		$('#linkattrlist').datagrid('loadData',[]);	    
	}
/// ʵ��datagrid����
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	SubQueryDicList();
}
function InitTreeData()
{
	$HUI.searchbox('#treequery').setValue("");
	$("#dictree").tree("search", "")
}
/// ʵ��DataGrid��ʼ����ͨ����
function InitDataList(){
	
	// ����columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'����',width:300,align:'left',editor:texteditor},
			{field:'CDParref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDParrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"��������",width:200,align:'left',hidden:true},
			{field:'CDLinkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true}
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
 			parref=rowData.ID;  
		}, 
		onDblClickRow: function (rowIndex, rowData) { }
		  
	}
	var params = ""
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+parref+"&parrefFlag=0&parDesc="+params;
	
	new ListComponent('DicList', columns, uniturl, option).Init();
	
}

/// �ֵ������
function InitTree(){
	var url = "" 
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,  
		multiple: true,
		lines:true,
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	        parref=node.id;          
		   	SubQueryDicList();	
	       
	    },
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
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
	    onExpand:function(node, checked){
			var childNode = $("#dictree").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
	        var isLeaf = $("#dictree").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("dictree", url, option).Init(); 	
}

/// ʵ��datagrid��ѯ
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();

	$('#DicList').datagrid('load',{
		extraAttr:"DataSource",
		id:dicParref,
		parDesc:params
	}); 
}
//�������Ľڵ�
function QueryTreeList()
{
	var desc=$HUI.searchbox("#myChecktreeDesc").getValue();
	$("#dictree").tree("search", desc)
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //ȡ�����Ľڵ�ѡ��
}
function InitTreeData()
{
	$HUI.searchbox('#treequery').setValue("");
	$("#dictree").tree("search", "")
}
// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}
/// ҩƷ����
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}
function SaveTermRule(){
	var Parref = getParam("Parref");
	var NodeId = getParam("NodeId");
	var LoginInfo = getParam("LoginInfo");
	var ClientIPAdd = getParam("ClientIPAdd");
	
	var selecItm=$("#DicList").datagrid('getSelected');
	var dicId=selecItm.ID
	var dicCode=selecItm.CDCode
	var dicDesc=selecItm.CDDesc
	var node=$("#dictree").tree('getSelected');
	
	/* var params=""+"^"+NodeId+"^"+dicParref+"^"+dicId+"^"+"" */
	
	var params=NodeId+"^"+dicId
	
	//ListData, Type, LoginInfo, ClientIPAddress
	runClassMethod("web.DHCCKBDefinitionRule","SaveTermRule",{"ListData":params,"Type":"tree","LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
	
		if (jsonString >= 0){
			$.messager.popover({msg: '����ɹ�����',type:'success',timeout: 1000});		
			return;	
		}else if(jsonString == -100){
			$.messager.alert('��ʾ','�Ѵ��ڶ������ݣ������ظ�����','warning');
			
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			
		}		
	});
	
	
	
}

/// ��ȡ����
function getParam(paramName){
	
    var paramValue = "";
    var isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1){
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        var i = 0;
        while (i < arrSource.length && !isFound){
            if (arrSource[i].indexOf("=") > 0){
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase()){
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        } 
    }
   return paramValue;
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })