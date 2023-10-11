var HospDr="";
$(function(){
    //InitHosp(); 	//��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
	//��ʼ������Ĭ����Ϣ
	InitDefault();
});
// ��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvFormName"); 
	HospDr=hospComp.getValue(); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///ѡ���¼�
		HospDr=hospComp.getValue();
		$("#queryForm").combobox('setValue',""); 
		QueryDataGrid(); 
		var url='dhcapp.broker.csp?ClassName=web.DHCADVFormName&MethodName=listCombo&HospDr='+HospDr;
		$("#queryForm").combobox('reload',url);  
	}
}
function InitDefault(){
	if($("#userEdit").val()==1){
	    $("#goFormName").hide();
	    $("#subHidden").parent().parent().hide();
	    $("#addRow").hide(); //hxy 2018-06-12 st
	    $("#addSub").hide();
	    $("#save").hide();
	    $("#delete").hide();
	    $('#subStyle').combobox({disabled:true});//hxy 2018-06-12
		$("#subUrl").attr("disabled",true);//hxy 2018-06-12
		$("#bindRow").hide(); //cy 2018-11-08
		$(".tool-bar-line").hide();//cy 2018-08-28
		var tempPanel = $("#mainPanel").layout('panel','east');
		tempPanel.panel('setTitle','���ݼ�ά��(�Ҽ��༭)');
		$("#quetype").css('display','none');
		$("#dicele").css('display','none');
		$("#allele").css('display','none');
	    //hxy ed
	    // cy �û�Ԫ�ؽ���������
	    $('#datagrid').datagrid('hideColumn','field');
	    $('#datagrid').datagrid('hideColumn','style');
	    $('#datagrid').datagrid('hideColumn','url');
	    $('#datagrid').datagrid('hideColumn','value');
	    $('#datagrid').datagrid('hideColumn','newLine');
	    $('#datagrid').datagrid('hideColumn','width');
	    $('#datagrid').datagrid('hideColumn','height');
	    $('#datagrid').datagrid('hideColumn','cols');
	    $('#datagrid').datagrid('hideColumn','rows');

	    $('#datagrid').datagrid('hideColumn','sameLevel');
	    $('#datagrid').datagrid('hideColumn','hiddenSub');
	    $('#datagrid').datagrid('hideColumn','subDicSameLine');
	    $('#datagrid').datagrid('hideColumn','canCopy');
	    $('#datagrid').datagrid('hideColumn','displayTitle');
	    $('#datagrid').datagrid('hideColumn','userEdit');
	    $('#datagrid').datagrid('hideColumn','subDicTile');
	}
	$HUI.radio("#queryTypen").setValue(true);
	var IEVersion =serverCall("ext.util.String","GetIEVersion"); //hxy 2017-12-14 st
    $('#datagrid').datagrid({   
		url:'dhcapp.broker.csp?ClassName=web.DHCADVFormDic&MethodName=listGrid&IEVersion='+IEVersion
	});//ed
	$("#queryStyle").next().find(".combo-text").on("input propertychange",function(){  
     	$('#queryStyle').combobox('clear');
   		QueryDataGrid();
	})
	//������
	$('#queryForm').combobox({
		valueField:'value',
		textField:'text',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVFormName&MethodName=listCombo&HospDr='+HospDr,
		onSelect: function(rec){  
			QueryDataGrid();
		} 	  
	}); 
	$("#queryForm").next().find(".combo-text").on("input propertychange",function(){  
   		QueryDataGrid();
	}) 	
	$("#queryFormBtn").hide(); 
	$("#queryField").keydown(
		function(e){
			if(e.keyCode==13) {
				QueryDataGrid();
     		}	
		}
	
	) 
	$('#queryTreeField').searchbox({
		searcher : function (value, name) {
			var rowsData = $("#datagrid").datagrid('getSelected')
				var url = LINK_CSP+'?ClassName=web.DHCADVFormDic&MethodName=listTree&id='+rowsData.ID+'&text='+value;
				$('#formTree').tree('options').url=encodeURI(url);
				$('#formTree').tree('reload');
		}
	});
	$("#subValue").keydown(
		function(e){
			if(e.keyCode==13) {
				if($("#subStyle").combobox('getValue')=='form'){
					queryFormDataGrid(); 	
				}
     		}	
		}
	
	) 
	$("#queryFormBtn").on('click',function(){
		queryFormDataGrid(); 
	})
	
	$HUI.radio("[name='queryType']",{
		onChecked:function(){   		
			QueryDataGrid();
		}
  	}); 
  	
	QueryDataGrid();
}
function QueryDataGrid(){
	commonQuery({'datagrid':'#datagrid','formid':'#toolbar'});
}

function queryFormDataGrid(){
	$('#formDatagrid').datagrid('load', {    
    	queryStr: $("#subValue").val()  
	});
	$('#queryFormDialog').dialog("open");
}

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
	// ��Ժ������ cy 2021-04-13 ����ҽԺ���¼��ع�����ά����������������
	var catDesced=$("#datagrid").datagrid('getEditor',{index:index,field:'catDesc'});
	var url="dhcapp.broker.csp?ClassName=web.DHCADVFormDic&MethodName=listFormCat&HospDr="+HospDr;
	$(catDesced.target).combobox('reload',url);  
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'style':'input','newLine':'N'}})
	// ��Ժ������ cy 2021-04-13 ����ҽԺ���¼��ع�����ά����������������
	var catDesced=$("#datagrid").datagrid('getEditor',{index:0,field:'catDesc'});
	var url="dhcapp.broker.csp?ClassName=web.DHCADVFormDic&MethodName=listFormCat&HospDr="+HospDr;
	$(catDesced.target).combobox('reload',url);  

}
///������   
function binding(){                      
	//commonAddRow({'datagrid':'#datagrid',value:{'style':'input','newLine':'N'}})
	var rowsData = $("#datagrid").datagrid('getSelected')
	$("#subParref").val(rowsData.ID)
    $("#subField").val(rowsData.field)
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���Ԫ��!");
		return;	
	}
	$('#binding').dialog("open");
}

function save(){
	saveByDataGrid("web.DHCADVFormDic","save","#datagrid",function(data){
		//�޸�
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�')
			$("#datagrid").datagrid('reload'); 
		}else{
			if((data=-11)||(data=-12)){
				$.messager.alert('��ʾ','����ʧ��:Ψһ��ʾ�Ѵ���!')
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
			
		}
		
	});	
}

function selectRow(index,row){
	$('#formTree').tree({    
    	url: LINK_CSP+"?ClassName=web.DHCADVFormDic&MethodName=listTree&id="+row.ID, 
    	lines:true,
    	onContextMenu: function(e, node){
			e.preventDefault();
			// ���ҽڵ�
			$('#formTree').tree('select', node.target);
			// ��ʾ��ݲ˵�
			$('#mm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}


	});
}

function addSub(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���Ԫ��!");
		return;	
	}
	clearForm();
    $("#subParref").val(rowsData.ID)
    //$("#subField").val(rowsData.field)
    $("#subStyle").combobox('setValue',rowsData.style);
    if(rowsData.style=="form"){
	    $("#queryFormBtn").show(); 
	}else{
		$("#queryFormBtn").hide(); 
	}
	$("#seq").val(0)
	$('#sub').dialog("open");   
}

function appendSub(){
	clearForm();
    select=$('#formTree').tree('getSelected')
    $("#subParref").val(select.id)
    //$("#subField").val(select.field)
    $("#subStyle").combobox('setValue',select.style);
    if(select.style=="form"){
	    $("#queryFormBtn").show(); 
	}else{
		$("#queryFormBtn").hide(); 
	}
	$('#sub').dialog("open");  
}

function append(){
	clearForm();
    select=$('#formTree').tree('getSelected')
    $("#subParref").val(select.parRef)
    //$("#subField").val(select.field)
    $("#subStyle").combobox('setValue',select.style);
    if(select.style=="form"){
	    $("#queryFormBtn").show(); 
	}else{
		$("#queryFormBtn").hide(); 
	}
	$('#sub').dialog("open");
}

function edit(){
	clearForm();
	select=$('#formTree').tree('getSelected')
	ret=serverCall("web.DHCADVFormDic","findById",{'id':select.id})
	arr=ret.split("^");
	$("#subId").val(select.id);
	$("#subParref").val(arr[4]);
	$("#subField").val(arr[0]);
	$("#subStyle").combobox('setValue',arr[1]);
	$("#subValue").val(arr[5]);
	$("#subTitle").val(arr[2]);
	$("#subUrl").val(arr[3]);
	$("#subNewLine").combobox('setValue',arr[6]);
	
	$("#subWidth").val(arr[8]);
	$("#subHeight").val(arr[9]);
	$("#subCols").val(arr[10]);
	$("#subRows").val(arr[11]);
	
	$("#subSameLevel").combobox('setValue',arr[13]);
	$("#subHiddenValue").val(arr[14]);
	$("#subHiddenSub").combobox('setValue',arr[15]);
	if(arr[1]=='form'){
		$('#queryFormBtn').show()
	}else{
    	$('#queryFormBtn').hide()
    }
    
    $("#subDicSameLine").combobox('setValue',arr[16]);
	//��Ԫ�غ͸�Ԫ��ͬ��
	$("#canCopy").combobox('setValue',arr[17]); 
	
	$("#seq").val(arr[19]);
	$("#subHidden").combobox('setValue',arr[21]);   //hxy 2018-04-26 
	$('#sub').dialog("open");
}

function deleteSub(){
	$.messager.confirm('ȷ�϶Ի���', 'ȷ��Ҫɾ����', function(r){
		if (r){
				select=$('#formTree').tree('getSelected')
	    		runClassMethod(
	 				"web.DHCADVFormDic",
	 				"remove",
	 				{'id':select.id},
	 				function(data){
	 					if(data==0){
		 					$.messager.alert("��ʾ","ɾ���ɹ�!");
		 					$('#formTree').tree('reload');
		 				}else{
			 				$.messager.alert("����","ɾ��ʧ��!"+data);
			 			} 
	 				})
		}
	});
}

function saveSub(){
	 
	 if($("#form").form('validate')){;
		 subId=$("#subId").val();
		 subParref=$("#subParref").val();
		 subField=$("#subField").val();
		 subStyle=$("#subStyle").combobox('getValue');
		 subValue=$("#subValue").val();
		 subTitle=$("#subTitle").val();
		 subUrl=$("#subUrl").val();
		 subWidth=$("#subWidth").val();
		 subHeight=$("#subHeight").val();
		 subCols=$("#subCols").val();
		 subRows=$("#subRows").val();
		 subNewLine=$("#subNewLine").combobox('getValue');
		 sameLevel=$("#subSameLevel").combobox('getValue');
		 subHiddenValue=$("#subHiddenValue").val();
		 subHiddenSub=$("#subHiddenSub").combobox('getValue');
		 subHidden=$("#subHidden").combobox('getValue'); //hxy 2018-04-26
		 //��Ԫ�غ͸�Ԫ��ͬ��
		 subDicSameLine=$("#subDicSameLine").combobox('getValue');
		 //���Ը���
		 canCopy=$("#canCopy").combobox('getValue');
		 //��Ԫ����ʾ˳��
		 seq=$("#seq").val();
		 par=subField+"^"+subTitle+"^"+subStyle+"^"+subId+"^"+subParref+"^"+subUrl+"^"+subValue+"^"+subNewLine 
		 par=par+"^"+subWidth+"^"+subHeight+"^"+subCols+"^"+subRows+"^^"+sameLevel+"^"+subHiddenValue+"^"+subHiddenSub+"^^"+subDicSameLine+"^"+canCopy+"^^"+seq
		 par=par+"^^^"+subHidden;//hxy 2018-04-26 //hxy 2020-10-09 add ^ //24

		 runClassMethod(
	 				"web.DHCADVFormDic",
	 				"save",
	 				{'params':par},
	 				function(data){
	 					if(data==0){
		 					$.messager.alert("��ʾ","����ɹ�!");
		 					$('#formTree').tree('reload');
		 					clearForm();
		 					$('#sub').dialog("close");
		 				}else{
			 				if((data=-11)||(data=-12)){
								$.messager.alert('��ʾ','����ʧ��:Ψһ��ʾ�Ѵ���!')
							}else{
								$.messager.alert('��ʾ','����ʧ��:'+data)
							}
			 			} 
	 				})
 				
	 }	
}

function clearForm(){
	$(':input','#form')    
    .not(':button, :submit, :reset')    
    .val('')
}

function goFormName(){
	window.location.href="dhcadv.formname.csp"	
}

function onSelectForm(index,row){
	$('#queryFormDialog').dialog("close");
	$("#subValue").val(row.code)
}
///wangxuejian  2018-08-21 ����ά���õ����
function Query()
{ 
   var Levelrowid="",ParrefID=""
	 $('#TypeTree').tree           
		 ({
	 	   type: 'get',
	 	   url: "dhcadv.repaction.csp?action=QueryTypeTree",
		    loadFilter: function(TypeTree)
		    {
			var data=eval(TypeTree);
			var json=GetJson(data,Levelrowid,ParrefID);
			//ParrefID=""
			return json;
		    }
		 })
}                      
function GetJson(data,Levelrowid,ParrefID){
    var result = [] , temp;//����temp�м����
    for(var i in data){                          
        if((data[i].Levelrowid==Levelrowid&&ParrefID==data[i].PID)||(Levelrowid==""&&data[i].Levelrowid=="")){
	        //if(data[i].Levelrowid==Levelrowid){
            result.push(data[i]);              
            temp = GetJson(data,data[i].ID, data[i].PID); // ����temp        
            if(temp.length>0){
                data[i].children=temp; //��data[i]���children���Բ���ֵ
            }           
        }       
    }  
    return result;
}

//������
function Sure()
{
   var nodes = $('#TypeTree').tree('getChecked',['checked','indeterminate']);
   var desc = ''; code=""; str="";typeTreestrs=""; typeTreestr="" //��ȡ����ѡ��ֵ
   var subParref=$("#subParref").val();                           //ѡ�����ݵ�id
   var subField=$("#subField").val();                             //��ȡΨһ��ʶ
   for(var i=0; i<nodes.length; i++)
   {
   desc = nodes[i].text
   code = nodes[i].Code
   Pcode=nodes[i].PCode
   str=code+"^"+desc+"^"+"checkbox"+"^"+Pcode 
   if (typeTreestrs== '') 
    typeTreestrs=str
   else
    typeTreestrs=typeTreestrs+"$$"+str    
  }
  if(str=="")
  {
	   $.messager.alert("��ʾ","�빴ѡҪ�󶨵�����!");
	  return ;
  } 
 typeTreestrs=typeTreestrs+"||"+subParref+"||"+subField
  runClassMethod(
          "web.DHCADVFormDic",
	      "saveTypeTree",
	      {'params':typeTreestrs},
	 function(data){
	  if(data==0)
	   {
	   $.messager.alert("��ʾ","����ɹ�!");
       $('#formTree').tree('reload');
	   clearForm();
	   $('#binding').dialog("close");
	   }else
	   {
	    if((data=-11)||(data=-12)){
		$.messager.alert('��ʾ','����ʧ��:Ψһ��ʾ�Ѵ���!')
		}else{
		$.messager.alert('��ʾ','����ʧ��:'+data)}
	   } 
	})
 
}
window.onload = function(){ 
	if($("#userEdit").val()==1){
	����$HUI.radio("input[name='queryType'][value='Y']").setValue(true);
		QueryDataGrid();
	}
} 
