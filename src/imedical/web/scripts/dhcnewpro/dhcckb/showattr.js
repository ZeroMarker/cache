/**
  *qunianpeng 
  *2019-06-18
  *�����б�
  *
 **/
var editRow = ""; 
var dicID = getParam("parref");    //ʵ��ID

/// ҳ���ʼ������
function initPageDefault(){

	initDataGrid();      /// ҳ��DataGrid��ʼ����
	//initBlButton();      /// ҳ�� Button ���¼�
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
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'code',title:'����',width:50,hidden:true},
		{field:'desc',title:'����',width:650}
	]];
	
	///  ����datagrid
	var option = {
		fitColumns:true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {}	//˫��ѡ���б༭
	};
	
	var params=dicID +"^"+ "LinkProp"

	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryDicAttr&params="+params;
	new ListComponent('attrlist', columns, uniturl, option).Init();
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
	
	var linkUrl = "dhcckb.property.csp"
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