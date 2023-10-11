/**
  *sufan 
  *2019-06-18
  *ֵ�����ά��
  *
 **/
var editRow = ""; 
var CatId = getParam("parref");    //ʵ��ID
var RangeId=CatId;
/// ҳ���ʼ������
function initPageDefault(){

	initRangeTree();     /// ��ʼֵ�������
	initDataGrid();      /// ҳ��DataGrid��ʼ����
	initBlButton();      /// ҳ�� Button ���¼�
}

/// ֵ�������
function initRangeTree(){
	
	var params = "^"+CatId
	var uniturl = LINK_CSP+'?ClassName=web.DHCCKBRangeCat&MethodName=QueryRangeCatTree&params='+params;
	var option = {
		multiple:true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	        var RangeCatID = node.id; 	
	        CatId=RangeCatID;
			$("#Rangelist").datagrid("load",{"CatId":RangeCatID});
	    }, 
		onLoadSuccess: function(node, data){
			
		}
	};
	new CusTreeUX("RangeCat", uniturl, option).Init();
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
	
	///  ����columns
	var columns=[[
		{field:'ID',title:'ID',width:100,editor:textEditor},
		{field:'CDCode',title:'�������',width:200,editor:textEditor},
		{field:'CDDesc',title:'��������',width:200,editor:textEditor},
		{field:'CDType',title:'CDType',width:100,editor:textEditor},
		{field:'oper',title:'����',width:150,formatter:SetCellOperation},
	]];
	
	///  ����datagrid
	var option = {
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
           CommonRowClick(rowIndex,rowData,"#Rangelist");
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryRangeCat&CatId"+CatId;
	new ListComponent('Rangelist', columns, uniturl, option).Init();
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	///  ����
	$('#insert').bind("click",insertRow);
	
	///  ����
	$('#save').bind("click",saveRow);
	
	///  ɾ��
	$('#delete').bind("click",deleteRow);
	
	///  ƴ����
	$('#RangeCatCode').searchbox({
		searcher : function (value, name) {
			var PyCode=$.trim(value);
			findRangeTree(PyCode);
		}
	});	
	
}

/// ���Ҽ����Ŀ��
function findRangeTree(PyCode){
	
	var params = PyCode +"^"+ CatId;
	var url = LINK_CSP+'?ClassName=web.DHCCKBRangeCat&MethodName=QueryRangeCatTree&params='+params;
	$("#RangeCat").tree('options').url =encodeURI(url);
	$("#RangeCat").tree('reload');
}

/// ����
function insertRow(){
	
	/*var node = $("#itemCat").tree('getSelected');
	if (!node){
		$.messager.alert("��ʾ","��ѡ��������Ŀ��������Ӳ���!"); 
        return;
    }
	var isLeaf = $("#itemCat").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
    if (!isLeaf){
		$.messager.alert("��ʾ","��ѡ��������Ŀ��������Ӳ���!"); 
        return;
    }
    if (node.id.indexOf("^") != "-1"){
    	var TraID = node.id.split("^")[0];
    	var PartID = node.id.split("^")[1];
    }else{
		var TraID = node.id;
		var PartID = "";
	}*/
	commonAddRow({'datagrid':'#Rangelist',value:{ID:'', CDCode:'', CDDesc:'',CDType:CatId}});
	
}

///����
function saveRow()
{
	// ʹ�ô˷�������ʱ����Ҫdatagrid�������ͱ��ֶ�������ͬ���޸�ʱIDĬ�Ϲ̶�
	comSaveByDataGrid("User.DHCCKBCommonDiction","#Rangelist",function(ret){
			if(ret=="0")
			{
				$("#Rangelist").datagrid('reload');
				var params="^"+CatId
				//var url = LINK_CSP+'?ClassName=web.DHCCKBDiction&MethodName=QueryAttrTreeList&params='+params;
				//$("#RangeCat").tree('options').url =encodeURI(url);
				$("#RangeCat").tree('reload');
			}
					
		}
	)
	
}

/// ɾ�������Ŀ,��λѡ����
function deleteRow(){

	removeCom("User.DHCCKBCommonDiction","#Rangelist")
}
///���ò�����ϸ����
function SetCellOperation(value, rowData, rowIndex){

	var btnGroup = "<a style='margin-right:10px;' href='#' onclick=\"OpenWin('"+rowData.ID+"','prop')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>����</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"OpenWin('"+rowData.ID+"','linkprop')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>��������</a>";
	
	return btnGroup;
}
function OpenWin(ID,model){

	var url="",titleName=""
	
	if (model =="prop"){
		
		url = "dhcckb.addattr.csp";
		titleName = "����ά��";
		
	}else if (model == "linkprop"){
		
		url = "dhcckb.addlinkattr.csp";
		titleName ="��������ά��";
		
	}

	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:titleName,
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:500
	});
	
	var cot = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+url+"?type="+ID+'"></iframe>';

	$('#winmodel').html(cot);
	$('#winmodel').window('open');

}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })