///CreatDate:  2017-01-09
///Author:    yuliping
var editRow="";
$(function(){ 
	
	//���������б�ѡ��󴥷���ѯ
    $("#LULocDr").combobox({    
   			valueField: "id", 
			textField: "text",
			editable:true,
			url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,
			//url:'dhcapp.broker.csp?ClassName=web.DHCDISLocUser&MethodName=GetLoc&HospID='+hosp,
			mode:'remote',
			onSelect:function(){
				findItmlist();
					/*setTimeout(function(){
	 	  				commonQuery({'datagrid':'#datagrid','formid':'#queryForm'});
  					},100)*/
			}
	});
	//��Ա�����б�ѡ��󴥷���ѯ
    $("#LUUserDr").combobox({    
   			valueField: "id", 
			textField: "text",
			mode:'remote',
			url:'dhcapp.broker.csp?ClassName=web.DHCDISLocUser&MethodName=GetSSUser&HospID='+hosp,
			onSelect:function(){
				findItmlist();
					/*setTimeout(function(){
	 	  				commonQuery({'datagrid':'#datagrid','formid':'#queryForm'});
  					},100)*/
			}
	});
	//��Ŀ���������б�ѡ��󴥷���ѯ
    $("#itemName").combobox({    
   			valueField: "id", 
			textField: "text",
			url:'dhcapp.broker.csp?ClassName=web.DHCDISLocUser&MethodName=ListItemCode',
			onSelect:function(){
					setTimeout(function(){
	 	  				commonQuery({'datagrid':'#locdatagrid','formid':'#queryLocForm'});
	 	  		
  					},100)
			}
	});

	$('#find').bind('click',function(event){
         findItmlist(); //���ò�ѯ
    });
    
    $('#reset').bind('click',function(event){
	     $HUI.combobox('#LULocDr').setValue("");
		 $HUI.combobox('#LUUserDr').setValue("");
         findItmlist(); //���ò�ѯ
    });
	
});
function onDbClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
	
}
function onDbClickRows(index,row){
	CommonRowClick(index,row,"#locdatagrid");
	editRow = index;
	var rows = $("#locdatagrid").datagrid('getChanges'); 
	if(rows.length==1){
		$.messager.alert("��ʾ","��δ��ɱ༭������!"); 
		$("#locdatagrid").datagrid('endEdit', index)
		return;
	}
}
function onClickRow(index,row){

	$("#getLuId").val(row.ID)
	$("#LocUser").val(row.ID)
	
	$("#locdatagrid").datagrid({
		queryParams: {
		LocUser:row.ID,
		itemName:''
		}
});
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LUActiveFlag':'Y','LUStatus':'0'}})
}
function save(){
	saveByDataGrid("web.DHCDISLocUser","SaveUpdLevReson","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","������Ա�Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-3){
				$.messager.alert("��ʾ","��༭��������!"); 
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
		 runClassMethod("web.DHCDISLocUser","RemoveUpdLevReson",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function addItemRow(){
	var liid=$("#getLuId").val();
	if(liid==""){
		$.messager.alert('��ʾ','��ѡһ����Ա');
		return;
		}
	if(editRow>="0"){
		//$("#locdatagrid").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
		$.messager.alert("��ʾ","��δ��ɱ༭������!"); 
		return;
	}
	
	var rows = $("#locdatagrid").datagrid('getChanges');    
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Type=="")||(rows[i].Pointer=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return;
		}		
	} 
	$("#locdatagrid").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ItemDesc: '',ItemLoc:''}
	});
	$("#locdatagrid").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
	
}
function Itemsave(){
	if(editRow>="0"){
		$("#locdatagrid").datagrid('endEdit', editRow);
	
	}
	var LocUserID=$("#getLuId").val();
	var rows = $("#locdatagrid").datagrid('getChanges');
	
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		if((rows[i].ItemDesc=="")){ 
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}
		var ID=rows[i].linkitem
		if(typeof(ID)=="undefined"){ 

			ID =0

		} 
		var tmp=LocUserID+"^"+ID+"^"+rows[i].ItemDesc
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//��������
	var data=serverCall("web.DHCDISLocLinkItem","SaveUpdUserLinkItem",
				{
					'params': rowstr
				})
	
	
		if(data==0){
			$.messager.alert("��ʾ","����ɹ�!");		
		}else if(data==10){
			$.messager.alert("��ʾ","��¼�ظ�������ʧ��!");	
			$('#locdatagrid').datagrid('reload');
			return;		
		}else{
			$.messager.alert("��ʾ","����ʧ��!");
			
			return;	
			
		}
		
		$('#locdatagrid').datagrid('reload'); //���¼���

}



function Itemcancel(){
	var LocUserID=$("#getLuId").val();
	
	if ($("#locdatagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}

	
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#locdatagrid").datagrid('getSelected');  
	    var tmp=LocUserID+"^"+row.linkitem+"^"+row.IDd
	   
		 runClassMethod("web.DHCDISLocLinkItem","RemoveUserLinkItem",{'str':tmp},function(data){ $('#locdatagrid').datagrid('load'); })
    }    
}); 
}
//���ã�ԭ���Ĳ��ܴ�DHC_DisLocUser��ID
function reloadData(){
	//$("#itemName ").find('input').val('');
	var td=$("#itemName ").parents("td");
	var span=td.find("span")
	span.find("input").val('');
	$("#locdatagrid").datagrid({
		queryParams: {
		LocUser:$("#getLuId").val(),
		itemName:''
		}
});
	}
function ma(index,row){
	//alert(row.linkitem)
	
	}
	
///��ѯ
function findItmlist()
{
	var loc=$HUI.combobox('#LULocDr').getValue();
	var user=$HUI.combobox('#LUUserDr').getValue();
	$('#datagrid').datagrid('load',{"LULocDr":loc,"LUUserDr":user}); 
}