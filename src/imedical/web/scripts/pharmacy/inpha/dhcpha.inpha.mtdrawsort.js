/*
ģ��:		�ƶ�ҩ��
��ģ��:		�ƶ�ҩ��-��ҩ����ά��
Creator:	hulihua
CreateDate:	2016-10-07
*/
var currEditRow=undefined; //�����б༭
$(function(){
    InitDrawSortDetail();
	commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
	//��λ�������ûس��¼�
     $('#sbdesctext').keyup(function(e){
        if(e.which == "13")    
        {
			find();
		}
    }); 
    $('#drawsortdetail').datagrid('loadData',{total:0,rows:[]});
	$('#drawsortdetail').datagrid('options').queryParams.params = "";     
});

///������ʾ��ҩ������ϸ
function onClickRow(index,row){
	var phlocdr=row["PhLocId"];
	var dsid=row["ID"];
	var params=phlocdr+"^"+dsid;
	$('#drawsortdetail').datagrid('load',{params:params});
}

///˫���༭��ҩ����
function onDblClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

///Ĭ��ѡ�е�һ��
function LoadSuccessRow(){
	if ($('#datagrid').datagrid("getRows").length>0){
		$('#datagrid').datagrid("selectRow", 0)
	}else{
	    $('#drawsortdetail').datagrid('loadData',{total:0,rows:[]});
		$('#drawsortdetail').datagrid('options').queryParams.params = "";     	
	}
	find();
}

/// �������
function ChkCondition(){
	var phlocdr=$('#CombPhaloc').combobox('getValue');
	if (phlocdr==""||phlocdr==null){
		$.messager.alert('��ʾ',"ҩ������Ϊ��!","info");
		return false;
	}
	return true ;
} 

///�����ұ���ϸ
function find(){
	if (ChkCondition()==false) return;
	var phlocdr=$('#CombPhaloc').combobox('getValue');
	var sbdesc=$.trim($("#sbdesctext").val());
	var row =$("#datagrid").datagrid('getSelected');
	if (row==null){
		return;
	}
	var dsid=row.ID;
	var params=phlocdr+"^"+dsid+"^"+sbdesc;
	$('#drawsortdetail').datagrid('load',{params:params});
}

///������ҩ����
function addRow(){
	if (ChkCondition()==false) return;
	var phlocdr=$('#CombPhaloc').combobox('getValue');
	commonAddRow({'datagrid':'#datagrid',value:{'PhLocId':phlocdr}});
}

///���汸ҩ����
function save(){
	saveByDataGrid("web.DHCINPHA.MTDrawSort.DrawSortQuery","Save","#datagrid",function(data){
			if(data==0){
				$("#datagrid").datagrid('reload');
				commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
			}else if(data==-1){
				$.messager.alert("��ʾ","�����������Ϊ��,���ܱ���!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-11){
				$.messager.alert("��ʾ","�����ظ�,���ܱ���!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-12){
				$.messager.alert("��ʾ","�����ظ�,���ܱ���!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}

///ɾ����ҩ����
function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ����ҩ�������ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����ѡ�ı�ҩ��������¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		runClassMethod("web.DHCINPHA.MTDrawSort.SqlDbDrawSort","Delete",{'Id':row.ID},function(data){
			if(data==0){
				$("#datagrid").datagrid('reload')
			}else if(data==-1){
				$.messager.alert("��ʾ","δѡ����Ҫɾ���ļ�¼!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-2){
				$.messager.alert("��ʾ","��ѡ�м�¼��ɾ��!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','ɾ��ʧ��:'+data)
			}  
		});
    }    
});

}
///��ʼ����ҩ������ϸ�б�
function InitDrawSortDetail(){
	//����columns
	var columns=[[  
	    {field:'TSBID',title:'��λID',width:100,hidden:true},     
        {field:'TSBCode',title:'��λ����',width:200,align:'center'},
        {field:'TSBDesc',title:'��λ����',width:200,align:'center'},
        {field:'TDSId',title:'����ID',width:200,hidden:true},
        {field:'TDSiId',title:'ID',width:100,hidden:true},
        {field:'TDSiSN',title:'SN˳��',width:100,align:'right',
        	editor:{
				type:'numberbox',
				options:{
					precision:0
				}
			},
			formatter: function(value,row,index){
				return  '<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
        }     
   ]];  
	
   //����datagrid	
   $('#drawsortdetail').datagrid({    
      url:LINK_CSP+'?ClassName=web.DHCINPHA.MTDrawSort.DrawSortQuery&MethodName=GetDrawSortDetailList',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columns,
      pageSize:50,  // ÿҳ��ʾ�ļ�¼����
	  pageList:[20,50,100,300],   // ��������ÿҳ��¼�������б�
	  loadMsg: '���ڼ�����Ϣ...',
	  pagination:true,    
	  onLoadSuccess: function(){
		if (currEditRow!=undefined){
			$('#drawsortdetail').datagrid('endEdit', currEditRow);
			currEditRow = undefined
		}
	  },
  	  onClickCell: function (rowIndex, field, value) {
		if (field!="TDSiSN"){return;}
	  	if (rowIndex != currEditRow) {
        	if (endEditing(field)) {
				$("#drawsortdetail").datagrid('beginEdit', rowIndex);
				var editor = $('#drawsortdetail').datagrid('getEditor', {index:rowIndex,field:field});
	     	    editor.target.focus();
	     	    editor.target.select();
				$(editor.target).bind("blur",function(){
                	endEditingdt(field);      
            	});
				currEditRow=rowIndex;  
        	}
		}		
			  	  
  	  }  
   });
 }

///��֤�����SN�ĺϷ���
var endEditingdt = function (field) {
    if (currEditRow == undefined) { return true }
    if ($('#drawsortdetail').datagrid('validateRow', currEditRow)) {
        var ed = $('#drawsortdetail').datagrid('getEditor', { index: currEditRow, field: field });
		var selecteddata = $('#drawsortdetail').datagrid('getRows')[currEditRow]; 
		var dsid=selecteddata["TDSId"];
		var dsiid=selecteddata["TDSiId"];
		var dsisbid=selecteddata["TSBID"];
		var dsisn=selecteddata["TDSiSN"];
        var inputtxt=$(ed.target).numberbox('getValue');
        $('#drawsortdetail').filter(":contains('2')").addClass("promoted")
	    if (inputtxt<0){ t
	    	$.messager.alert('������ʾ',"�� "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (currEditRow+1)+'</span>'+" ��SN˳����С��0!","info");
	    	return false;
	    }
		$('#drawsortdetail').datagrid('updateRow',{
			index: currEditRow,
			row: {TDSiSN:inputtxt}
		});
		var detaildata=dsid+"^"+dsiid+"^"+inputtxt+"^"+dsisbid;
		savedata(detaildata);
        $('#drawsortdetail').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        return true;
    } else {
        return false;
    }
}

///���汸ҩ������ϸ��SN
function savedata(detaildata){
	var data=tkMakeServerCall("web.DHCINPHA.MTDrawSort.DrawSortQuery","SaveDeatil",detaildata)
	if(data!=""){
		if(data==-1){
			$.messager.alert("��ʾ","û��ѡ�������߻�λ��Ϊ��,���ܱ���!"); 
		}else if(data==-2){	
			$.messager.alert('��ʾ','����ʧ��!');		
		}else if(data==-3){	
			$.messager.alert('��ʾ','SN�ظ�,����������!');		
		}
		$("#drawsortdetail").datagrid('reload');
	}	
}
