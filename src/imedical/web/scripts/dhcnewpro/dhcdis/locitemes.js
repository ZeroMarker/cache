///CreatDate:  2017-01-07
///Author:    yuliping
var ItmID="";
$(function(){ 
	//ͬʱ������������󶨻س��¼�
     $('#LICode,#LIDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
        }
    });
    $('#Code,#Desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagridsub','formid':'#queryFormsub'}); //���ò�ѯ
        }
    });
});
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LIType':'1','LIActiveFlag':'Y',LIHospDrID:'2','LIHospDr':'2','LITypeAddDr':'1'}})
}
function onClickRow(index,row){
	
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	
	saveByDataGrid("web.DHCDISLocItemEs","SaveUpdLevReson","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
			
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}



function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCDISLocItemEs","RemoveUpdLevReson",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}
function fillvalue(obj)
{
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'LITypeAddDesc'});			//��ĿID��ֵ
	$(ed.target).val(obj.text);
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'LITypeAddDr'});				//��Ŀ������ֵ
	$(ed.target).val(obj.value);
	
}
function fillHospvalue(obj)
{
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'LIHospDr'});			//��ĿID��ֵ
	$(ed.target).val(obj.text);
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'LIHospDrID'});				//��Ŀ������ֵ
	$(ed.target).val(obj.value);
}

function onClickLocRow(index,row)
{
	ItmID=row.ID;
	$('#datagridsub').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISLocItemLinkRec&MethodName=ListLocItemLinkRec',	
		queryParams:{
			Item:ItmID}
	});
	
	
}
///�������տ�������
function SubaddRow(){
	commonAddRow({'datagrid':'#datagridsub',value:{'LREItemDr':ItmID,'LRELocDr':''}})
}
function onClickRowsub(index,row){

	CommonRowClick(index,row,"#datagridsub");
}
function Subsave(){
	
	saveByDataGrid("web.DHCDISLocItemLinkRec","SaveUpdLevReson","#datagridsub",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagridsub").datagrid('reload')
			}else if(data==1){
			
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagridsub").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
	/*if(editIndex>="0"){
		$("#datagridsub").datagrid('endEdit', editIndex);
	}

	var rowsData = $("#datagridsub").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var tmp=ItmID +"^"+ rowsData[i].LRELocDr ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCDISLocItemLinkRec","SaveUpdLevReson",{"params":params},function(data){
		
		if (data==0){
			$('#datagridsub').datagrid('reload'); //���¼���
		}else if (data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagridsub").datagrid('reload')
		}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		//$('#arccatlist').datagrid('reload'); //���¼���
	});	*/
		
}



function Subcancel(){
	
	if ($("#datagridsub").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagridsub").datagrid('getSelected');     
		 runClassMethod("web.DHCDISLocItemLinkRec","RemoveUpdLevReson",{'Id':row.ID},function(data){ $('#datagridsub').datagrid('load'); })
    }    
}); 
}