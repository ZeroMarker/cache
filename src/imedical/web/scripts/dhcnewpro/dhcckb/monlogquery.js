/**
  *sufan
  *2020-12-29
  *�����ͳ����־����
  *
 **/
var hospArr = [{"value":"������׼�����ֻ�ҽԺ��Ժ","text":'������׼�����ֻ�ҽԺ[��Ժ]'},{"value":"������׼�����ֻ�ҽԺ��Ժ","text":'������׼�����ֻ�ҽԺ[��Ժ]'},{"value":"������ҽ�ƴ�ѧ��һ����ҽԺ","text":'������ҽ�ƴ�ѧ��һ����ҽԺ'},{"value":"������ҽ�ƴ�ѧ��һ����ҽԺ20201203","text":'������ҽ�ƴ�ѧ��һ����ҽԺ(20201203)'},{"value":"�人�е�һҽԺ","text":'�人�е�һҽԺ'},{"value":"�����γ���ҽ","text":'�����γ���ҽ'},{"value":"������ҽ�ƴ�ѧ��һ����ҽԺ20201215","text":'������ҽ�ƴ�ѧ��һ����ҽԺ(20201215)'},{"value":"������ҽ�ƴ�ѧ��һ����ҽԺ20201221","text":'������ҽ�ƴ�ѧ��һ����ҽԺ(20201221)'}];
hospArr.push({"value":"������ҽ�ƴ�ѧ��һ����ҽԺ20201224","text":'������ҽ�ƴ�ѧ��һ����ҽԺ(20201224)'});

var signArr = [{"value":"complet","text":'������������'},{"value":"uwcomplet","text":'�������δ���'},{"value":"partcomp","text":'������󣬲������'},{"value":"partcompcon","text":'������󣬲�����ɣ����û�ȷ��'},{"value":"partcompproame","text":'������󣬲�����ɣ�����������'}, {"value":"partcompruleimp","text":'������󣬲�����ɣ������ƹ���'},{"value":"partcompdicimp","text":'������󣬲�����ɣ��������ֵ�'},{"value":"verifycorrect","text":'������ȷ������֤'},{"value":"affirmcorrect","text":'������ȷ�����û�ȷ��'},{"value":"achievecorrect","text":'������ȷ�������'}];

/// ҳ���ʼ������
function initPageDefault(){

	initDataGrid();      /// ҳ��DataGrid��ʼ����
	initBlButton();      /// ҳ��Button ���¼�
	initCombobox();		 /// ҳ��Combobox��ʼ����
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
		{field:'monId',title:'monId',width:50,editor:textEditor,hidden:true},
		{field:'monItmId',title:'monItmId',width:100,editor:textEditor,hidden:true},
		{field:'drug',title:'ҩƷ����',width:400,editor:textEditor},
		{field:'remarks',title:'��˱�ע',width:150,editor:textEditor},
		{field:'exasignval',title:'��˱��',width:200,editor:textEditor},
		{field:'drugOutParam',title:'��˽��',width:200,editor:textEditor}
	]];
	
	///  ����datagrid
	var option = {
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
           
        }
	};
	
	var fromdate = $("#fromdate").datebox('getValue');
	var todate = $("#todate").datebox('getValue');
	var sign = $HUI.combobox('#sign').getValue();
	var hosp = $HUI.combobox('#hosp').getText();
	var params = fromdate +"^"+ todate +"^"+ sign +"^"+ hosp;
	var uniturl = $URL+"?ClassName=web.DHCCKBMonLogQuery&MethodName=QueryMonData&params="+params;
	new ListComponent('monloglist', columns, uniturl, option).Init();
}

/// ҳ�� Button ���¼�
function initBlButton()
{	
	///  ��ѯ
	$('#find').bind("click",query);

}

/// ҳ�� initCombobox ���¼�
function initCombobox()
{
	// Ժ��
	$HUI.combobox("#hosp",{
		data:hospArr,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			query();
		}
	})
	
	// ��˱��
	$HUI.combobox("#sign",{
		data:signArr,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			query();
		}
	})
}

///��ѯ
function query()
{
	var fromdate = $("#fromdate").datebox('getValue');
	var todate = $("#todate").datebox('getValue');
	var sign = $HUI.combobox('#sign').getValue();
	var hosp = $HUI.combobox('#hosp').getText();
	var params = fromdate +"^"+ todate +"^"+ sign +"^"+ hosp;
	$("#monloglist").datagrid('load',{'params':params});
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })