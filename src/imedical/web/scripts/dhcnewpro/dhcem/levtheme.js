/// huaxiaoying
/// 2016-05-31
/// �ּ�ָ�������
var themeID=""
var pos="";
$(function(){
    //��������ʼ��ʾ
	$('#ThemeTree').tree({
		url: LINK_CSP+'?ClassName=web.DHCEMLevExpress&MethodName=ListLevTree', 
		//checkbox:true,
		multiple: true,
		lines:true,
		animate:true,   
		required: true,
		onClick:function(node, checked){
			if (node.attributes=="1")
			{
				themeID=node.id;
				//������Ӧ������ʾ
				$('#CatLib').tree({
						url: LINK_CSP+'?ClassName=web.DHCEMLevExpress&MethodName=ListCatLibTree&themeID='+themeID, 
						//checkbox:true,
						multiple: true,
						lines:true,
						animate:true,   
						required: true,
						onClick:function(node, checked){
							var str=""
							var LEXText=$("#LEXText").val();
							if(node.id==1)
							{
								str="";
							}else
							{
				
								if(LEXText.charAt(LEXText.length - 1) == ".")
								{
					
									str="(#"+node.attributes+"())";
								}
								if (LEXText=="")
								{
									str="(#"+node.attributes+"())";
								}
				
							}	
							big(str);
		
						}
					});
				$('#queryForm').form('clear');
				var box = document.getElementsByName("LEXActiveFlag");
	            box[0].checked = true;
	            $("#themeHidden").val(themeID);//��������id��ֵ
	            var SelectLTILev= $("#SelectLTILev").combobox("getValue");//get optionֵ
	            if(SelectLTILev=="0"){SelectLTILev=""} 
				$("#LTILev").val(SelectLTILev);//���ּ���ֵ
				commonQuery({'datagrid':'#datagrid1','formid':'#queryForm'})
				$("#LTILev").val("");//���ּ�����
			}else{
				$('#tabs').tabs('select', 1);
				$('#queryForm').form('clear');
				var box = document.getElementsByName("LEXActiveFlag");
	            box[0].checked = true;
				$("#LEXDesc").val(node.text);
				commonQuery({'datagrid':'#datagrid1','formid':'#queryForm'})
				$("#LEXDesc").val("");
			}
			
		}
	});
	//������ʼ��ʾ
	$('#CatLib').tree({
		url: LINK_CSP+'?ClassName=web.DHCEMLevExpress&MethodName=ListCatLibTreeFirst', 
		//checkbox:true,
		multiple: true,
		lines:true,
		animate:true,   
		required: true,
		onClick:function(node, checked){
			var str=""
			var LEXText=$("#LEXText").val();
			if(node.id==1)
			{
				str="";
			}else
			{
				
				if(LEXText.charAt(LEXText.length - 1) == ".")
				{
					
					str="(#"+node.attributes+"())";
				}
				if (LEXText=="")
				{
					str="(#"+node.attributes+"())";
				}
				
			}	
			big(str);
		
		}
	});
	///����ؼ���
    $("#SelectT").on('click', function() {
	    if (themeID==""){
		    $.messager.alert("��ʾ","��ѡ������"); 
		}else{             //2016-10-28 add else
		    pos=$("#LEXText").getFieldPos();   
			$('#detail').dialog('open');
			$('#detail').dialog('move',{
					left:280,
					top:180
				});
		    $('#detailgrid').datagrid({  
		    	    url:LINK_CSP+'?ClassName=web.DHCEMLevKey&MethodName=ListLevKeyY&themeID='+themeID,
		    	    method:'get',
		    	    fit:true,
		    	    loadMsg:'����������.....',
		    	    pagination:true,
		    	    fitColumns:true,
		    	    rownumbers:true,
		    	    //onClickRow:detailonClickRow,
		    	    onDblClickRow:onDblClickRow,
		    	    columns:[[ 
				            {field:'LKCode',title:'����',width:100},
				            {field:'LKDesc',title:'����',width:120},
				            {field:'ID',title:'id',hidden:true,width:50}
		    	  	        ]]
	    	  	
			    });   
		} //2016-10-28 add else
 	}); //����ؼ���END
 	
	$('#hospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryBTN').on('click',function(){
		 $("#datagrid").datagrid('reload',{hospDrID:$('#hospDrID').combobox('getValue')});
	 }) //hxy ed
  
})

///����ؼ��ֵ���
function onDblClickRow(rowIndex, rowData){
	var currRow =$('#detailgrid').datagrid('getSelected');
	$("#LEXText").insertPos(pos,"["+rowData.LKDesc+"]")
	$('#detail').window('close');
	}
	
///��ť�¼�
function big(type){
	var str=$("#LEXText").val();
	$("#LEXText").val(str+type);
	}
///���
function Clear(){
	$("#LEXText").val("");
	}
///��������
function newT(){
	$('#tabs').tabs('select', 0);
	}

///����������Ŀ(���ʽ)
function newP(){
	$('#tabs').tabs('select', 1);
	}
	
///��������_Tab
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LTHActiveFlag':'Y','LTHHospDr':LgHospID,'LTHRemark':''}})
}
//˫���༭
function onClickRow(index,row){
	
	CommonRowClick(index,row,"#datagrid");
	$("#a").attr("formatter",row.LTHHospDr.HOSPDesc);
	
}

function save(){
	saveByDataGrid("web.DHCEMLevTheme","SaveLevTheme","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
				$('#ThemeTree').tree('reload')   
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
		 runClassMethod("web.DHCEMLevTheme","RemoveLevTheme",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
		 $('#ThemeTree').tree('reload')  
    }    
    }); 
}

///����������Ŀ_Tab
function addRowLib(){
	$('#queryForm').form('clear');
	var box = document.getElementsByName("LEXActiveFlag");
	box[0].checked = true;
	//$('#datagrid1').datagrid('selectRow', '');
	//$("#datagrid1").datagrid('reload')
}

function onClickRowE()
{
	var row =$("#datagrid1").datagrid('getSelected');
	$("#LEXCode").val(row.LEXCode);
	$("#LEXDesc").val(row.LEXDesc);
	$("#LEXRemark").val(row.LEXRemark);
	$("#LEXText").val(row.LEXText);
	$("#LTILev").val(row.LTILev);
	if(row.LEXActiveFlag=="Y"){
		var box = document.getElementsByName("LEXActiveFlag");
	    box[0].checked = true;	
	}else{
		var box = document.getElementsByName("LEXActiveFlag");
	    box[0].checked = false;
		}
	
	
}
function saveExpress(){
	if((themeID=="")&&($("#datagrid1").datagrid('getSelections').length != 1)){
		$.messager.alert('��ʾ','��ѡ���������');
		return;
	}else if($("#LEXCode").val()==""){
		$.messager.alert('��ʾ','����д ����');
		return;
	}else if($("#LEXDesc").val()==""){
		$.messager.alert('��ʾ','����д ����');
		return;
	//}else if($("#LEXRemark").val()==""){
	//	$.messager.alert('��ʾ','����д ��ע');
	//	return;
	}else if($("#LEXText").val()==""){
		$.messager.alert('��ʾ','����д ���ʽ');
		return;
	}else if($("#LTILev").val()==""){
		$.messager.alert('��ʾ','����д �ּ�');
		return;
	}//else if(($("#LTILev").val()!=1)&&($("#LTILev").val()!=2)&&($("#LTILev").val()!=3)&&($("#LTILev").val()!=4)){
	 //	$.messager.alert('��ʾ','����д���֣�1/2/3/4 (�ּ����ҽ���1 2 3 4)');
	 //	return;
	 //	} //2017-1-5
	
    var text=$("#LEXText").val()
    if(text.length>500){
	    $.messager.alert("��ʾ","�ַ�������!"); 
	    return;
	    }
    
	var str=""
	str=str+themeID+"^";
    str=str+$("#LEXCode").val()+"^";
	str=str+$("#LEXDesc").val()+"^";
	str=str+$("#LEXRemark").val()+"^";
	str=str+$("#LEXText").val()+"^";
	str=str+$("#LTILev").val()+"^";
	if($('#LEXActiveFlag').is(':checked')){
		str=str+encodeURI("Y");
    }else{
	     str=str+encodeURI("N");
	}
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		var ID=0
	}else{
		var row =$("#datagrid1").datagrid('getSelected');
		var ID=row.ID;
	}
	str=str+"^"+ID;	
	//var str=str.replace("#","!"); 
	str=str.replace(/#/g,"!");

	runClassMethod("web.DHCEMLevExpress","SaveLevExpress",
					{'str':str},
					function(data){ 
						if(data==0){
		       				$('#queryForm').form('clear');
		       				//$('#LEXActiveFlag').checked = true;
		       				var box = document.getElementsByName("LEXActiveFlag");
		       				box[0].checked = true;
							$("#datagrid1").datagrid('reload')
							$('#ThemeTree').tree('reload')  
						}else if(data==1){
							$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
						}else{	
							$.messager.alert('��ʾ','����ʧ��:'+data)
				
						} 
					 });

	
}

function cancelExpress(){
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEMLevExpress","RemoveLevExpress",{'Id':row.ID},function(data){ 
		    $('#queryForm').form('clear');
		    var box = document.getElementsByName("LEXActiveFlag");
	       	box[0].checked = true;
            $("#datagrid1").datagrid('load');
		    $('#ThemeTree').tree('reload')    })
         	 
    }    
    }); 
    
}