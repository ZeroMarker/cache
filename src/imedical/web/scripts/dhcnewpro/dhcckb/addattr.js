/**
  *qunianpeng 
  *2019-06-18
  *����ά��
  *
 **/
var editRow = ""; 
var CatId = getParam("type");    //ʵ��ID
var RangeId=CatId;
/// ҳ���ʼ������
function initPageDefault(){

	initDataGrid();      /// ҳ��DataGrid��ʼ����
	initBlButton();      /// ҳ�� Button ���¼�
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
	var columns=[[
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'ʵ��ID',width:100,editor:textEditor,hidden:true},
		{field:'CDDesc',title:'��������',width:200,editor:textEditor},
		{field:'DLAAttrCode',title:'���Դ���',width:150,editor:textEditor,hidden:true},
		{field:'AttrDesc',title:'����ֵ����',width:200,editor:textEditor},
		{field:'DLAAttrDr',title:'����ֵ',width:80,editor:textEditor,hidden:true},
		{field:'DLAResult',title:'��ע',width:200,editor:textEditor}
	]];
	
	///  ����datagrid
	var option = {
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
           CommonRowClick(rowIndex,rowData,"#addattrlist");
            dataGridBindEnterEvent(rowIndex);
           editRow=rowIndex
        }
	};
	
	var params="LinkTemp^"+CatId;
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAddAttr&params="+params;
	new ListComponent('addattrlist', columns, uniturl, option).Init();
}

/// ҳ�� Button ���¼�
function initBlButton(){	
	
	///  ����
	$('#save').bind("click",saveRow);
	
	/// 
	$('#link').bind("click",AddAttr);
}

///����
function saveRow()
{
	// ʹ�ô˷�������ʱ����Ҫdatagrid�������ͱ��ֶ�������ͬ���޸�ʱIDĬ�Ϲ̶�
	comSaveByDataGrid("User.DHCCKBDicLinkAttr","#addattrlist",function(ret){
			if(ret=="0")
			{
				$("#addattrlist").datagrid('reload');
			}
					
		}
	)	
}

function AddAttr(){
	
	var linkUrl = "dhcckb.property.csp";
	linkUrl += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
	///window.location.href="dhcckb.property.csp";
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';

	if($('#editProp').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="editProp"></div>');
	$('#editProp').window({
		title:"�������",
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

/// 
function dataGridBindEnterEvent(index){
	
	editRow=index;
	var editors = $('#addattrlist').datagrid('getEditors', index);

	for(var i=0;i<editors.length;i++){
		var workRateEditor = editors[i];
		
		//����ֵ����  AttrDesc
		if(workRateEditor.field=="AttrDesc"){
			workRateEditor.target.mousedown(function(e){
				var ed=$("#addattrlist").datagrid('getEditor',{index:index, field:'AttrDesc'});		
				var input = $(ed.target).val();
				divComponent({tarobj:$(ed.target),htmlType:"tree",width: 400,height: 260},function(obj){
					var ed=$("#addattrlist").datagrid('getEditor',{index:index, field:'DLAAttrDr'});		
					$(ed.target).val(obj.id);				
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

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })