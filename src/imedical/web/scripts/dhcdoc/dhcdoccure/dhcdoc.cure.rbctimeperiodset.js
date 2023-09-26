var cureRBCTimePeriodSetDataGrid;
$(function(){ 
  InitCureRBCTimePeriodSet();
  $('#btnSave').bind('click', function(){
	  	if(!SaveFormData())return false;
   });
   LoadCureRBCTimePeriodSetDataGrid();
});	
function CheckData(){
	var DDCTSCode=$("#DDCTSCode").val();
	if(DDCTSCode=="")
	{
		 $.messager.alert("����", "���벻��Ϊ��", 'error')
        return false;
	}
	var DDCTSDesc=$("#DDCTSDesc").val();
	if(DDCTSDesc=="")
	{
		$.messager.alert('Warning','ʱ�����������Ϊ��');   
        return false;
	}
	var DDCTSStartTime=$("#DDCTSStartTime").val();
	if(DDCTSStartTime=="")
	{
		$.messager.alert('Warning','��ʼʱ�䲻��Ϊ��');   
        return false;
	}
	var DDCTSEndTime=$("#DDCTSEndTime").val();
	if(DDCTSEndTime=="")
	{
		$.messager.alert('Warning','����ʱ�䲻��Ϊ��');   
        return false;
	}
	return true;
}
///�޸ı����
function SaveFormData(){
   		if(!CheckData()) return false;    
	    var DDCTSROWID=$("#DDCTSROWID").val();
	    var DDCTSCode=$("#DDCTSCode").val();
	    var DDCTSDesc=$("#DDCTSDesc").val();
	    var DDCTSStartTime=$("#DDCTSStartTime").val();
	    var DDCTSEndTime=$("#DDCTSEndTime").val();
	    var DDCTSEndChargeTime=$("#DDCTSEndChargeTime").val();
	    var DDCTSNotAvailFlag="";
	    if ($("#DDCTSNotAvailFlag").is(":checked")) {
		         DDCTSNotAvailFlag="Y";
	           }
	    var InputPara=DDCTSROWID+"^"+DDCTSCode+"^"+DDCTSDesc+"^"+DDCTSStartTime+"^"+DDCTSEndTime+"^"+DDCTSEndChargeTime+"^"+DDCTSNotAvailFlag;
		 //alert(InputPara)
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCTimePeriodSet","SaveCureRBCTimePeriodSet","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			$("#add-dialog").dialog( "close" );
			LoadCureRBCTimePeriodSetDataGrid()
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
   var rows = cureRBCTimePeriodSetDataGrid.datagrid('getSelections');
    if (rows.length ==1) {
       //$("#add-dialog").dialog("open");
        $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
        //��ձ�����
	 	$('#add-form').form("clear")
	 	if(rows[0].NotAvailFlag=="Y")
	 	{
	 	    var NotAvailFlag=true
	 	}else{
			var NotAvailFlag=false
		}
		$("#DDCTSNotAvailFlag").attr('checked',NotAvailFlag);
		 $('#add-form').form("load",{
		 DDCTSROWID:rows[0].Rowid,
		 DDCTSCode:rows[0].Code,
		 DDCTSDesc:rows[0].Desc,
		 DDCTSStartTime:rows[0].StartTime,
		 DDCTSEndTime:rows[0].EndTime,
		 DDCTSEndChargeTime:rows[0].EndChargeTime	 
	 })
	 
      $('#updateym').val("�޸�")    
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'err')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'err')
     }

}
function InitCureRBCTimePeriodSet()
{
	var cureRBCTimePeriodSetToolBar = [{
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
                var rows = cureRBCTimePeriodSetDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCTimePeriodSet","DeleteCureRBCTimePeriodSet","false",function testget(value){
						        if(value=="0"){
							       cureRBCTimePeriodSetDataGrid.datagrid('load');
           					       cureRBCTimePeriodSetDataGrid.datagrid('unselectAll');
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
	cureRBCTimePeriodSetColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Code', title:'����', width: 10, align: 'center', sortable: true  
					},
        			{ field: 'Desc', title: 'ʱ�������', width: 20, align: 'center', sortable: true
					},
					{ field: 'StartTime', title: '��ʼʱ��', width: 20, align: 'center', sortable: true, resizable: true
					},
					{ field: 'EndTime', title: '����ʱ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'EndChargeTime', title: '��ֹ�շ�����', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'NotAvailFlag', title: '�����ñ��', width: 20, align: 'center', sortable: true,resizable: true
					}
					
    			 ]];
	cureRBCTimePeriodSetDataGrid=$('#tabCureRBCTimePeriodSet').datagrid({  
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
		columns :cureRBCTimePeriodSetColumns,
		toolbar:cureRBCTimePeriodSetToolBar,
		onClickRow:function(rowIndex, rowData){
			PTRowid=rowData.PTRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
		 UpdateGridData();
			
       }
	});
}
function LoadCureRBCTimePeriodSetDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCTimePeriodSet';
	queryParams.QueryName ='QueryBookTime';
	queryParams.ArgCnt =0;
	var opts = cureRBCTimePeriodSetDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCTimePeriodSetDataGrid.datagrid('load', queryParams);
	cureRBCTimePeriodSetDataGrid.datagrid("unselectAll")
};
