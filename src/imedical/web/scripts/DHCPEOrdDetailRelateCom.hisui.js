//����	DHCPEOrdDetailRelateCom.hisui.js
//����	�����ϸ����Ϲ�ϵ����
//����	2019.06.03
//������  xy
$(function(){
  	InitCombobox();
			
	InitStationDataGrid();
	
	InitOrderTabDataGrid();
	
	InitODRelateComDataGrid();

	//��ѯ
	$("#BFind").click(function(e){
    	BFind_click();
    });
	
	$("#ARCIMDesc").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
				}
		});

	
	//����
    $("#BClear").click(function(e){
    	BClear_click();
    });
	     
    //����
    $("#BAdd").click(function(e){
    	BAdd_click();
    });
    
    //�޸�
    $("#BUpdate").click(function(){
    	BUpdate_click();
    });
    
    //ɾ��
    $("#BDelete").click(function(e){
    	BDelete_click();
    }); 
    
    //����LIS��Ŀ
     $("#BImport").click(function(e){
    	BImport_click();
    }); 
    
     $("#Cascade").change(function(){
  			Cascade_change();
		});
		
    iniForm();
   
})

 function BFind_click()
{
	
	$("#OrderTab").datagrid('load',{
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			Desc:$("#ARCIMDesc").val(),
			hospId:session['LOGON.HOSPID']
		}); 

}  

function iniForm(){
	$("#BImport").css('display','none');
	 // ���밴ť��ʾ
	var STType=tkMakeServerCall("web.DHCPE.Public.Setting","GetStationType",$("#ParRef").val());
	var flag=tkMakeServerCall("web.DHCPE.TransOrderDetail","GetLisInterface");
	if ("Lab"==STType&&"N"==flag) { $("#BImport").css('display','block');}
}

function InitCombobox()
{
	//ϸ������
	var ODObj = $HUI.combogrid("#ODDRName",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.OrderDetail&QueryName=FromDescOrderDetail",
		mode:'remote',
		delay:200,
		idField:'OD_RowId',
		textField:'OD_Desc',
		onBeforeLoad:function(param){
			param.ParRef = "";
			param.Desc = param.q;
		},
		onShowPanel:function()
		{
			$('#ODDRName').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'OD_RowId',title:'ID',hidden: true},
		    {field:'OD_Desc',title:'����',width:150},
		    {field:'OD_Code',title:'����',width:100},	    	
					
		]],
		onLoadSuccess:function(){
			//$("#ODDRName").combogrid('setValue',"")
			
		},

		});
		
	//����
	var OrdObj = $HUI.combogrid("#Parent_DR_Name",{
		panelWidth:249,
		url:$URL+"?ClassName=web.DHCPE.OrderDetailRelate&QueryName=SearchParentOrderDetailRelate",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ARCIMDR = $("#ARCIMDR").val();
			param.Desc = param.q;
		},
		onShowPanel:function()
		{
			$('#Parent_DR_Name').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'ID',title:'ID',width:80},
		    {field:'Desc',title:'����',width:140}, 
		
					
		]]
		});
	
}

/**********************վ�����************************************/
function InitStationDataGrid()
{
	
	$HUI.datagrid("#StationTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
		toolbar: [],//������toolbarΪ��ʱ,���ڱ�������ͷ�������"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"StationList",
		},
		columns:[[

		    {field:'ST_RowId',title:'ID',hidden: true},
		    {field:'ST_Code',width:'60',title:'վ�����'},
			{field:'ST_Desc',width:'170',title:'վ������'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#OrderTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadOrderTabTablist(rowData);
			$("#ARCIMDR,#ARCIMDesc").val("");
			BClear_click();
			iniForm();
					
		}
		
			
	})

}


/**********************��Ŀ����************************************/
function LoadOrderTabTablist(rowData)
{
	
	$("#ParRef").val(rowData.ST_RowId);
	
	$("#OrderTab").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			hospId:session['LOGON.HOSPID']
		
	});
	
	
}
function InitOrderTabDataGrid()
{
	
	$HUI.datagrid("#OrderTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
		toolbar: [],//������toolbarΪ��ʱ,���ڱ�������ͷ�������"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			hospId:session['LOGON.HOSPID']
		},
		columns:[[

		    {field:'ODR_ARCIM_DR:',title:'ID',hidden: true},
		    {field:'ODR_ARCIM_DR_Name',width:'200',title:'��Ŀ����'},
			{field:'ODR_ARCIM_Code',width:'70',title:'��Ŀ����'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#ODRelateComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadODRelateComDatalist(rowData);
					
		}
		
			
	})
}

/**********************��Ŀ���ά������************************************/
function LoadODRelateComDatalist(rowData)
{
	
	$("#ARCIMDR").val(rowData.ODR_ARCIM_DR);
	$("#ARCIMDesc").val(rowData.ODR_ARCIM_DR_Name);
	
	//BClear_click();
	$("#ODRelateComGrid").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"SreachOrderDetailRelate",
			ParARCIMDR:$("#ARCIMDR").val(),
		
	});
	
	
}


function InitODRelateComDataGrid()
{
	$HUI.datagrid("#ODRelateComGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"SreachOrderDetailRelate",
			ParRef:"",
			ParARCIMDR:"",
		},
		frozenColumns:[[
			{field:'ODR_OD_DR_Name',width:'150',title:'ϸ������'},
		    {field:'ODR_OD_DR_Code',width:'100',title:'ϸ�����'},
			 
		]],
		columns:[[
		    {field:'ODR_RowId',title:'ODRRowId',hidden: true},
		    {field:'ODR_ARCIM_DR',title:'ARCIMDR',hidden: true},
		    {field:'ODR_OD_DR',title:'ODRowId',hidden: true},
		    {field:'ODR_ARCIM_DR_Name',title:'ARCIMDesc',hidden: true},
			{field:'ODR_Sequence',width:'80',title:'˳���'},
			{field:'ODR_Required',width:'120',title:'�Ƿ������'},
			{field:'THistoryFlag',width:'120',title:'�����бȶ�'},
			{field:'ODR_Cascade',width:'80',title:'���'},
			{field:'ODR_Parent_DR_Name',width:'100',title:'����'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			
			$("#ODRRowId").val(rowData.ODR_RowId);
			$("#ARCIMDR").val(rowData.ODR_ARCIM_DR);
			$("#ODRowId").val(rowData.ODR_OD_DR);
			$("#ODDRName").combogrid('setValue',rowData.ODR_OD_DR_Name);
			$("#Sequence").val(rowData.ODR_Sequence);
			$("#Cascade").val(rowData.ODR_Cascade);
			$("#Parent_DR_Name").combogrid('setValue',rowData.ODR_Parent_DR_Name);
			
			if(rowData.THistoryFlag=="��"){
					$("#HistoryFlag").checkbox('setValue',false);
				}if(rowData.THistoryFlag=="��"){
					$("#HistoryFlag").checkbox('setValue',true);
				};
			if(rowData.ODR_Required=="��"){
					$("#Required").checkbox('setValue',false);
				}if(rowData.ODR_Required=="��"){
					$("#Required").checkbox('setValue',true);
				};

			if(rowData.ODR_Cascade=="1"){
			$("#Parent_DR_Name").combogrid("disable");
			}else{
			$("#Parent_DR_Name").combogrid("enable");
			}
		
		}
		
			
	})
}

// ������ʱ?�ж��Ƿ��Ƕ���,���򽫸����Ϊ������
function Cascade_change () {
	var Src=window.event.srcElement;
	
	var iCascade=$("#Cascade").val();
	if(iCascade=="1"){
		$("#Parent_DR_Name").combogrid("disable");
	}else{
		$("#Parent_DR_Name").combogrid("enable");
	}
	
}


//����
function BClear_click(){
	$("#ODRRowId,#ODRowId,#Sequence,#Cascade").val("");
	$("#ODDRName").combogrid('setValue',"");
	$("#Parent_DR_Name").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	
	var valbox = $HUI.combogrid("#ODDRName", {
			required: false,
	    });
	var valbox = $HUI.validatebox("#Sequence", {
			required: false,
	    });

	$("#ODRelateComGrid").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"SreachOrderDetailRelate",
			ParARCIMDR:$("#ARCIMDR").val(),
		
	});
}

//����
function BAdd_click(){
	BSave_click("0");
} 

//�޸�
function BUpdate_click(){
	BSave_click("1");
}

function BSave_click(Type){
	
	if(Type=="1"){
		var ID=$("#ODRRowId").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
		if($("#ARCIMDR").val()==""){
		    	$.messager.alert("��ʾ","����ѡ����Ŀ","info");
		    	return false;
		    }
	    if($("#ODRRowId").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
		var ID="";
	}
	
	 var iRowId=$("#ODRRowId").val(); 
	 
	var iARCIMDR=$("#ARCIMDR").val();  

   //ϸ������
	var iODDR=$("#ODDRName").combogrid('getValue');
	if (($("#ODDRName").combogrid('getValue')==undefined)||($("#ODDRName").combogrid('getValue')=="")){var iODDR="";}
	if (""==iODDR) {
		$("#ODDRName").focus();
		var valbox = $HUI.combogrid("#ODDRName", {
			required: true,
	    });
		$.messager.alert("��ʾ","��ѡ��ϸ������,ϸ�����Ʋ���Ϊ��","info");
		return false;
	}
	
	 if(iRowId!=""){var iODDR=$("#ODRowId").val();}
	 if(iODDR!="")
	 {
		 var flag=tkMakeServerCall("web.DHCPE.OrderDetailRelate","IsOrderDetailFlag",iODDR);
		 if(flag=="0"){
			 $.messager.alert("��ʾ","������ѡ��ϸ��","info");
			return false;
		 }
	 }

	
	
	//˳���
	var iSequence=$("#Sequence").val(); 
	if (""==iSequence) {
		$("#Sequence").focus();
		var valbox = $HUI.validatebox("#Sequence", {
			required: true,
	    });
		$.messager.alert("��ʾ","˳��Ų���Ϊ��","info");
		return false;
	}
	if((!(isInteger(iSequence)))||(iSequence<=0)) 
		   {
			   $.messager.alert("��ʾ","˳���ֻ����������","info");
			    return false; 
		   }


	//�Ƿ������
	var iRequired="N";
	var Required=$("#Required").checkbox('getValue');
	if(Required) iRequired="Y";
		
	// ����
	var iParentDR=$("#Parent_DR_Name").combogrid('getValue');
	if (($("#Parent_DR_Name").combogrid('getValue')==undefined)||($("#Parent_DR_Name").combogrid('getValue')=="")){var iParentDR="";}
	 
	// ���
	var iCascade=$("#Cascade").val();
	if ("1"==iCascade) { iParentDR=""; }

	if((iCascade!="1")&&(iCascade!="")&&(iParentDR=="")){
		$.messager.alert("��ʾ","��ѡ����","info");
		return false;
		
	}
	// �����бȶ�
	var iHistory="N";
	var HistoryFlag=$("#HistoryFlag").checkbox('getValue');
	if(HistoryFlag) iHistory="Y";
	
	var Instring=$.trim(iRowId)			
				+"^"+$.trim(iARCIMDR)		
				+"^"+$.trim(iODDR)		
				+"^"+$.trim(iSequence)	
				+"^"+$.trim(iRequired)	
				+"^"+$.trim(iParentDR)	
				+"^"+$.trim(iCascade)		
				+"^"+$.trim(iHistory)		
				;
	
	var flag=tkMakeServerCall("web.DHCPE.OrderDetailRelate","Save",'','',Instring);
	//alert(flag)
	if (flag=='-104') {
		$.messager.alert("������ʾ","�����õĸ����¼������","info");
	}else{
		if (flag=='0') {
			
			if(Type=="1"){$.messager.alert("������ʾ","�޸ĳɹ�","success");}
			if(Type=="0"){$.messager.alert("������ʾ","�����ɹ�","success");}
			BClear_click();	
				
		}else if (flag=='Err 01') {
			$.messager.alert("������ʾ","����Ŀ������","info");
			
		}else{
			if(Type=="1"){$.messager.alert("������ʾ","�޸�ʧ��","error");}
			if(Type=="0"){$.messager.alert("������ʾ","����ʧ��","error");}	
		
		}
	} 
}
//ɾ��
function BDelete_click(){
	var ID=$("#ODRRowId").val();
	if(ID==""){
			$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
			return false;
		}
			
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.OrderDetailRelate", MethodName:"Delete", itmjs:'',itmjsex:'',Rowid:ID },function(ReturnValue){
				if (ReturnValue!='0') {
					if(ReturnValue=="Err 07"){$.messager.alert("��ʾ","ɾ��ʧ��:��ϸ���Ѻʹ������","error")}
					else{$.messager.alert("��ʾ","ɾ��ʧ��","error"); } 
  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					BClear_click();
					
	
			        $('#myWin').dialog('close'); 
				}
			});	
		}
	});
}


//����
function BImport_click()
{

	var ARCIMDr=$("#ARCIMDR").val(); 
	var flag=tkMakeServerCall("web.DHCPE.TransOrderDetail","Main",ARCIMDr);
	BClear_click();
	
}

 function isInteger(num) {
      if (!isNaN(num) && num % 1 === 0) {
        return true;
      } else {
        return false;
      }
}

