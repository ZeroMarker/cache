var AddAttrCode="DrugLibaryData";
/// ҳ���ʼ������
function initPageDefault(){

	InitDataList();		//��� ҳ��DataGrid��ʼ������
	//InitDataListnew();			// �ұ�DataGrid��ʼ������
	InitButton();
}

function InitButton(){
$('#queryCode').searchbox({
		    searcher:function(value,name){
		   		QueryDicList();
		    }	   
		});
	
}
/// ҳ��DataGrid��ʼ����ͨ������ҩƷĿ¼�ֵ䣩
function InitDataList(){
						
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: false //���ñ༭��������
		}
	}
	
	/*// ְ��
	var Roleeditor={type:'combobox',
				  	 options:{
						valueField:'value',
						textField:'text',
						mode:'remote',
						enterNullValueClear:false,
						blurValidValue:true,
						onSelect:function(option) {
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'post'});
							$(ed.target).combobox('setValue', option.text);
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'postID'});
							$(ed.target).val(option.value);
						},
				  		onShowPanel:function(){
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'post'}) ;
							var unitUrl=$URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=QueryValue&AddAttrCode="+AddAttrCode;
							$(ed.target).combobox('reload',unitUrl) ;
				    	}	  
					}
	}*/
	
	// ����columns
	var columns=[[   
			{field:'ID',title:'ID',width:80,hidden:true},
			{field:'postID',title:'����ID',width:80,editor:texteditor,hidden:true},
			{field:'encoded',title:'����',width:80,hidden:false,editor:texteditor,hidden:true},
			{field:'post',title:'����',width:80,hidden:false,editor:texteditor},
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
 			getRuleIframe(rowData.ID);
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
        },
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=Queryposlifecycle&AddAttrCode="+AddAttrCode;
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}


function QueryDicList(){
	var params = $HUI.searchbox("#queryCode").getValue();
	var AddAttrCode="DrugLibaryData"
	$('#diclist').datagrid('load',{
		AddAttrCode:AddAttrCode,
		params:params
	})
	
	
	}
	
/// ʵ��datagrid����
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	

}

	
function getRuleIframe(catalogueid){
	$('#saveTreeDic').attr('src', "dhcckb.sourcepriority.csp?catalogueid="+catalogueid); 
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })