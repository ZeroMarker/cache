var cureRBCServiceGroupSetDataGrid;
$(function(){ 
  InitCureRBCServiceGroupSet();
  $('#btnSave').bind('click', function(){
	  	if(!SaveFormData())return false;
   });
   LoadCureRBCServiceGroupSetDataGrid();
});	
function CheckData(){
	var DDCSGSCode=$("#DDCSGSCode").val();
	if(DDCSGSCode=="")
	{
		 $.messager.alert("����", "���벻��Ϊ��", 'error')
        return false;
	}
	var DDCSGSDesc=$("#DDCSGSDesc").val();
	if(DDCSGSDesc=="")
	{
		$.messager.alert('Warning','��������Ϊ��');   
        return false;
	}
	var DDCSGSDateFrom=$("#DDCSGSDateFrom").datebox("getValue");
	if(DDCSGSDateFrom=="")
	{
		$.messager.alert('Warning','��ʼ���ڲ���Ϊ��');   
        return false;
	}
	return true;
}
///�޸ı����
function SaveFormData(){
   		if(!CheckData()) return false;    
	    var DDCSGSROWID=$("#DDCSGSROWID").val();
	    var DDCSGSCode=$("#DDCSGSCode").val();
	    var DDCSGSDesc=$("#DDCSGSDesc").val();
	    var DDCSGSDateFrom=$("#DDCSGSDateFrom").datebox("getValue");
	    var DDCSGSDateTo=$("#DDCSGSDateTo").datebox("getValue");
	    var InputPara=DDCSGSROWID+"^"+DDCSGSCode+"^"+DDCSGSDesc+"^"+DDCSGSDateFrom+"^"+DDCSGSDateTo;
		 //alert(InputPara)
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCServiceGroupSet","SaveCureRBCServiceGroupSet","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			$("#add-dialog").dialog( "close" );
			LoadCureRBCServiceGroupSetDataGrid()
			return true;							
		}else{
			var err=""
			if (value=="100") err="�����ֶβ���Ϊ��";
			else if (value=="101") err="�����ظ�";
			else err=value;
			$.messager.alert('Warning',err);
			return false;
		}
	   },"","",InputPara);
}
///�޸ı����
function UpdateGridData(){
   var rows = cureRBCServiceGroupSetDataGrid.datagrid('getSelections');
    if (rows.length ==1) {
       //$("#add-dialog").dialog("open");
        $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
        //��ձ�����
	 	$('#add-form').form("clear")
	 	
		 $('#add-form').form("load",{
		 DDCSGSROWID:rows[0].Rowid,
		 DDCSGSCode:rows[0].Code,
		 DDCSGSDesc:rows[0].Desc,
		 DDCSGSDateFrom:rows[0].DateFrom,
		 DDCSGSDateTo:rows[0].DateTo	 
	 })
	 
      $('#updateym').val("�޸�")    
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'err')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'err')
     }

}
function InitCureRBCServiceGroupSet()
{
	var cureRBCServiceGroupSetToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
              $("#add-dialog").dialog("open");
	 			//��ձ�����
	 		  $('#add-form').form("clear")
	 		  $('#submitdata').val("���")  
            }
        },
        '-', {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = cureRBCServiceGroupSetDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCServiceGroupSet","DeleteCureRBCServiceGroupSet","false",function testget(value){
						        if(value=="0"){
							       cureRBCServiceGroupSetDataGrid.datagrid('load');
           					       cureRBCServiceGroupSetDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						        }else{
							       $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						        }
						  
						   },"","",ID);
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },'-',{
			text: '�޸�',
			iconCls: 'icon-edit',
			handler: function() {
			  UpdateGridData();
			}
		}];
	cureRBCServiceGroupSetColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Code', title:'����', width: 10, align: 'center', sortable: true  
					},
        			{ field: 'Desc', title: '����', width: 20, align: 'center', sortable: true
					},
					{ field: 'DateFrom', title: '��ʼ����', width: 20, align: 'center', sortable: true, resizable: true
					},
					{ field: 'DateTo', title: '��ֹ����', width: 20, align: 'center', sortable: true,resizable: true
					}
    			 ]];
	cureRBCServiceGroupSetDataGrid=$('#tabCureRBCServiceGroupSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"PTRowid",
		pageList : [15,50,100,200],
		columns :cureRBCServiceGroupSetColumns,
		toolbar:cureRBCServiceGroupSetToolBar,
		onClickRow:function(rowIndex, rowData){
			PTRowid=rowData.PTRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
		 UpdateGridData();
			
       }
	});
}
function LoadCureRBCServiceGroupSetDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCServiceGroupSet';
	queryParams.QueryName ='QueryServiceGroup';
	queryParams.ArgCnt =0;
	var opts = cureRBCServiceGroupSetDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCServiceGroupSetDataGrid.datagrid('load', queryParams);
	cureRBCServiceGroupSetDataGrid.datagrid("unselectAll")
};
