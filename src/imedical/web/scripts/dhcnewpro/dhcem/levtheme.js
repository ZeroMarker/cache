/// huaxiaoying
/// 2016-05-31
/// �ּ�ָ�������
var themeID=""
var pos="";
var hospComp;
$(function(){
    //��������ʼ��ʾ
	$('#ThemeTree').tree({
		url: LINK_CSP+'?ClassName=web.DHCEMLevExpress&MethodName=ListLevTree',
		multiple: true,
		lines:true,
		animate:true,   
		required: true,
		onClick:function(node, checked){
			if (node.attributes=="1")
			{
				themeID=node.id;
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
			
		},
		onLoadSuccess:function(){
			$('#ThemeTree').tree("collapseAll");
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
	    /*if (themeID==""){
		    $.messager.alert("��ʾ","��ѡ������"); 
		}else{             //2016-10-28 add else */
		    pos=$("#LEXText").getFieldPos();   
			$('#detail').dialog('open');
			$('#detail').dialog('move',{
					left:280,
					top:180
				});
		    $('#detailgrid').datagrid({  
		    	    url:LINK_CSP+'?ClassName=web.DHCEMLevKey&MethodName=ListLevKeyY&themeID=', //+themeID, //2020-12-28 �ؼ��ָĹ��У�����id���գ�ȥ���ж�
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
		//} //2016-10-28 add else
 	}); //����ؼ���END
 	
	/*$('#hospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryBTN').on('click',function(){
		 $("#datagrid").datagrid('reload',{hospDrID:$('#hospDrID').combobox('getValue')});
	 }) //hxy ed *///hxy 2020-12-25 ע��
	 
	hospComp = GenHospComp("DHC_EmLevTheme");  //hxy 2020-12-25 add st
    query(); //��ʼ��Ĭ�ϲ�ѯ
	hospComp.options().onSelect = function(){///ѡ���¼�
		query();
	}
	$('#queryBTN').on('click',function(){
		query();
	}) //ed
  
})

function query(){
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMLevTheme&MethodName=ListLevTheme&hospDrID='+hospComp.getValue()
	})
}

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
	var HospDr=hospComp.getValue(); //
	commonAddRow({'datagrid':'#datagrid',value:{'LTHActiveFlag':'Y','LTHHospDr':HospDr,'LTHRemark':'','HospDr':HospDr}}) //hxy 2020-12-25 add HospDr
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
			}else if(data==-11){ //hxy 2020-12-25 st
				$.messager.alert("��ʾ","û�п���ҽԺ����Ȩ!"); 
				$("#datagrid").datagrid('reload') //ed
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
function saveExpress(type){
	if((themeID=="")&&($("#datagrid1").datagrid('getSelections').length != 1)){
		$.messager.alert('��ʾ','��ѡ���������');
		return;
	}else if($("#LEXCode").val()==""){
		$.messager.alert('��ʾ','����д����');
		return;
	}else if($("#LEXDesc").val()==""){
		$.messager.alert('��ʾ','����д����');
		return;
	}else if($("#LEXText").val()==""){
		$.messager.alert('��ʾ','����д���ʽ');
		return;
	}else if($("#LTILev").val()==""){
		$.messager.alert('��ʾ','����д�ּ�');
		return;
	}
	
    var text=$("#LEXText").val()
    if(text.length>500){
	    $.messager.alert("��ʾ","�ַ�������!"); 
	    return;
	}
    
	var str=""
	var ID=""
	var row =$("#datagrid1").datagrid('getSelected');
	var ID=row?row.ID:"";
	type=="add"?ID="":"";	///��Ӱ�ť����ֱ�Ӹ���
	
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
	str=str+"^"+ID;	
	
	if(!ID){
		if(type!="add"){
			$.messager.alert("��ʾ","��ѡ��һ�����ʽ"); 
	    	return;	
		}
	}
	
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

function queryExpress(){
	$('#datagrid1').datagrid('load',{
		LEXCode: $('#LEXCode').val(),
		LEXDesc: $('#LEXDesc').val(),
		LEXRemark: $('#LEXRemark').val(),
		LTILev: $('#LTILev').val(),
		LEXText: $('#LEXText').val()
	})
}

function clearAndQueryExpress(){
	addRowLib();
	queryExpress();	
}