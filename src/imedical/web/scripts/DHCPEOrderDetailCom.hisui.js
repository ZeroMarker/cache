
//����	DHCPEOrderDetailCom.hisui.js
//����	ϸ��ά��
//����	2019.05.22
//������  xy
$(function(){
	
	InitCombobox();
			
	InitStationDataGrid();
	
	InitOrderDetailDataGrid();
	
	//��ѯ
    $('#BFind').click(function(e){
    	BFind_click();
    });
	     
    //����
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //ɾ��
    $('#del_btn').click(function(e){
    	DelData();
    });
   
	//����
	$("#Type").combobox({
       onSelect:function(){
			Type_change();
	}
	});
    
})

function Type_change()
{
	
	var Type=$("#Type").combobox('getValue');
	if(Type=="C"){
		$("#EditExpression").attr('disabled',false);	
	}else{
		$("#EditExpression").attr('disabled',true);
	}
}

function IsValidExpression(aExpression) {
	
	var strExpression="";
	var strLine="";
	var iLoop=0;
	
	var iValue="",iOperator="",iCode="";	
	
	var ReadStatus=""; //��ȡ����   V ��ǰ��ȡ���� O ��ǰ��ȡ�������� P ��ǰ��ȡ������
	
	strExpression=aExpression+';';
  
	for (iLoop=0;iLoop<strExpression.length;iLoop++) {
		switch (strExpression.charAt(iLoop)){
			case "+":{
				Operator="+";
				ReadStatus="O";	
				break;				
			}
			case "-":{
				Operator="-";
				ReadStatus="O";	
				break;				
			}
			case "*":{
				
				Operator="*"
				ReadStatus="O";	
				break;			
			}
			case "/":{
				Operator="/";
				ReadStatus="O";			
				break;
			}
			case "(":{
				Operator="(";
				ReadStatus="PB";			
				break;
			}
			case ")":{
				Operator=")";
				ReadStatus="PE";			
				break;
			}
			
			case ";":{
				ReadStatus="F";
				break;
			}
			
			default: {
				ReadStatus="V";		 
				iValue=iValue+strExpression.charAt(iLoop);
				break;
			}

		}
		//��ǰ�ַ�Ϊ������
		if ("O"==ReadStatus) {
			iCode=tkMakeServerCall("web.DHCPE.OrderDetail","OMETypeDelete",$("#ParRef").val(),iValue);				
			//iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode+Operator;
			iValue="";	
			Operator="";	
		}
		
		//
		if ("PB"==ReadStatus) {
			strLine=strLine+Operator;
			iValue="";
			Operator="";
		}
		
		//
		if ("PE"==ReadStatus) {
			iCode=tkMakeServerCall("web.DHCPE.OrderDetail","OMETypeDelete",$("#ParRef").val(),iValue);	
			//iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode+Operator;
			iValue="";
			Operator="";
		}
		//������		
		if ("F"==ReadStatus) {
			iCode=tkMakeServerCall("web.DHCPE.OrderDetail","OMETypeDelete",$("#ParRef").val(),iValue);	
			//iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode;	
			if (""==strLine) { return ""; }			
		}
	}

   $("#EditExpression").val(strLine);
	
	return strLine;
}

function BFind_click()
{
	$("#OrderDetailComTab").datagrid('load',{
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"StationOrderDetailList",
			ParRef:$("#ParRef").val(),
			Desc:$("#ODDesc").val(),
			Code:"",
		});	
}

function AddData()
{
	
	$("#myWin").show();

		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'����',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'����',
				id:'save_btn',
				handler:function(){
					SaveForm("")
				}
			},{
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
			}]
		});
		
		$('#form-save').form("clear");
		var StaionDesc=$("#StaionDesc").val();
		$("#ODStaionDesc").val(StaionDesc);
		var valbox = $HUI.validatebox("#Code,#Desc", {
				required: false,
	   		});
	   	
		//Ĭ��ѡ��
		$HUI.checkbox("#Summary").setValue(true);
		$HUI.checkbox("#NoPrint").setValue(true);	
	    //$HUI.checkbox("#HistoryFlag").setValue(true);
		 //Ĭ���Ա�Ϊ"����"
	   $("#Sex").combobox('setValue',"N");

}

SaveForm=function(id)
{
	var iParRef="",iRowId="",iChildSub="",iAdvice="N",iSequence="";
	
	var iParRef=$.trim($("#ParRef").val());
	
	if(iParRef=="")
	{
		$.messager.alert('��ʾ','��ѡ��վ��',"info");
		return;
		
	}
	
	
	if(id!==""){$("#ChildSub").val(id.split("||")[1])}
	var iChildSub=$.trim($("#ChildSub").val());
	
	var iCode=$.trim($("#Code").val());
	if(iCode=="")
	{	
		var valbox = $HUI.validatebox("#Code", {
				required: true,
	   		});
		$.messager.alert('��ʾ','ϸ����벻��Ϊ��',"info");
		return;
		
	}
	
	var iDesc=$.trim($("#Desc").val());
	if(iDesc=="")
	{	
		var valbox = $HUI.validatebox("#Desc", {
				required: true,
	   		});
		$.messager.alert('��ʾ','ϸ�����Ʋ���Ϊ��',"info");
		return;
		
	}
	
	var iType=$('#Type').combobox('getValue');
	if (($('#Type').combobox('getValue')==undefined)||($('#Type').combobox('getValue')=="")){var iType="";}
	if(iType=="")
	{ 
		var valbox = $HUI.combobox("#Type", {
				required: true,
	   		});
		$.messager.alert('��ʾ','��Ŀ���Ͳ���Ϊ��',"info");
		return;
		
	}

	var iExpression=$.trim($("#EditExpression").val());
	if(iType=="C"){
		var ExpressionFlag=IsValidExpression(iExpression);
		if (""==ExpressionFlag) {
		
			$.messager.alert('��ʾ','���ʽ����',"error");
			return false;
		}
  
	}
	var iUnit=$.trim($("#Unit").val());
	
	var iExplain=$.trim($("#Explain").val());
	
	var iSummary="N";
	var Summary=$("#Summary").checkbox('getValue');
	if(Summary) {iSummary="Y";}
	
	var iNoPrint="N";
	var NoPrint=$("#NoPrint").checkbox('getValue');
	if(NoPrint) {iNoPrint="Y";}
	
	var iHistoryFlag="N";
	var HistoryFlag=$("#HistoryFlag").checkbox('getValue');
	if(HistoryFlag) {iHistoryFlag="Y";}
	
	var iSex=$('#Sex').combobox('getValue');
	if (($('#Sex').combobox('getValue')==undefined)||($('#Sex').combobox('getValue')=="")){var iSex="";}
	
	var iMarried=$('#Married_DR_Name').combobox('getValue');
	if (($('#Married_DR_Name').combobox('getValue')==undefined)||($('#Married_DR_Name').combobox('getValue')=="")){var iMarried="";}
	
	var iZhToEng=$.trim($("#ZhToEng").val());
	
	var iSpecialNature=$.trim($("#SpecialNature").val());
	
	var Instring = iParRef
				+"^"+iRowId
				+"^"+iChildSub
				+"^"+iCode
				+"^"+iDesc
				+"^"+iType
				+"^"+iExpression
				+"^"+iUnit
				+"^"+iSummary
				+"^"+iAdvice
				+"^"+iExplain
				+"^"+iSequence
				+"^"+iSex
				+"^"+iNoPrint  
				+"^"+iZhToEng
				+"^"+iSpecialNature
				+"^"+iMarried
				+"^"+iHistoryFlag
				;
	
	 
	var flag=tkMakeServerCall("web.DHCPE.OrderDetail","Save",'','',Instring);

	if(flag==0){
		    $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		    $("#OrderDetailComTab").datagrid('load',{
			    ClassName:"web.DHCPE.OrderDetail",
				QueryName:"StationOrderDetailList",
				ParRef:iParRef,
			   
			    }); 
			   
			$('#myWin').dialog('close'); 
	    }else{
		     if(flag=="Err 03"){
			    if(id==""){$.messager.alert('������ʾ',"����ʧ��:�ñ����ѱ�������Ŀʹ��","error");}
		     	if(id!=""){$.messager.alert('������ʾ',"�޸�ʧ��:�ñ����ѱ�������Ŀʹ��","error");}
		    }else{
		     if(id==""){$.messager.alert('������ʾ',"����ʧ��","error");}
		     if(id!=""){$.messager.alert('������ʾ',"�޸�ʧ��","error");}
		    }

		     
	    }
	
	
		
}
	
function UpdateData()
{

	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('������ʾ',"��ѡ����޸ĵļ�¼","info");
		return
	}
	
	var StaionDesc=$("#StaionDesc").val();
	$("#ODStaionDesc").val(StaionDesc);
	
	
	
	if(ID!="")
	{	
	      var OrdDetailStr=tkMakeServerCall("web.DHCPE.OrderDetail","GetOrdDetailByID",ID);
	      
		   var OrdDetail=OrdDetailStr.split("^");
		   $('#Desc').val(OrdDetail[0]);
		   $('#Type').combobox('setValue',OrdDetail[1]);
		   if($('#Type').combobox('getValue')=="C"){
				$("#EditExpression").attr('disabled',false);	
			}else{
				$("#EditExpression").attr('disabled',true);
			}
		   $('#EditExpression').val(OrdDetail[2]);
		   $('#Unit').val(OrdDetail[3]);
		   if(OrdDetail[4]=="Y"){
			    $("#Summary").checkbox('setValue',true);
		   }else{
			   $("#Summary").checkbox('setValue',false);
		   }
		   
		    $('#Explain').val(OrdDetail[6]);
		    $('#LabtrakCode').val(OrdDetail[9]);
		    $('#Code').val(OrdDetail[10]);
		    $('#Sex').combobox('setValue',OrdDetail[8]);
		    
		    $('#ZhToEng').val(OrdDetail[11]);
		    $('#SpecialNature').val(OrdDetail[13]);
		    $('#Married_DR_Name').combobox('setValue',OrdDetail[14]);
		    if(OrdDetail[12]=="Y"){
			    $("#NoPrint").checkbox('setValue',true);
		   }else{
			   $("#NoPrint").checkbox('setValue',false);
		   }
		    if(OrdDetail[15]=="Y"){
			    $("#HistoryFlag").checkbox('setValue',true);
		   }else{
			   $("#HistoryFlag").checkbox('setValue',false);
		   }
		    
		    
			$("#myWin").show();
			
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'�޸�',
				modal:true,
				buttons:[{
					text:'����',
					id:'save_btn',
					handler:function(){
						SaveForm(ID)
					}
				},{
					text:'�ر�',
					handler:function(){
						myWin.close();
					}
				}]
			});	
			var valbox = $HUI.validatebox("#Code,#Desc", {
				required: false,
	   		});						
	}	
}

function DelData()
{
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('������ʾ',"��ѡ���ɾ���ļ�¼","info");
		return
	}
	ParRef=ID.split("||")[0];
	ChildSub=ID.split("||")[1];
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.OrderDetail", MethodName:"Delete", itmjs:'',itmjsex:'',ParRef:ParRef,ChildSub:ChildSub },function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$("#ID").val(""); 
					
					$("#OrderDetailComTab").datagrid('load',{
			    		ClassName:"web.DHCPE.OrderDetail",
						QueryName:"StationOrderDetailList",
						ParRef:$("#ParRef").val(),
			   
			    	}); 
	
			        $('#myWin').dialog('close'); 
				}
			});	
		}
	});
	
}

function InitCombobox()
{
	//��Ŀ����
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'155',
		data:[
            {id:'T',text:'˵����'},
            {id:'N',text:'��ֵ��'},
            {id:'C',text:'������'},
            {id:'S',text:'ѡ����'},
            {id:'A',text:'�����ı�'},
        ]

	});
	//�Ա�
	var SexObj = $HUI.combobox("#Sex",{
		valueField:'id',
		textField:'text',
		panelHeight:'95',
		data:[
            {id:'M',text:'��'},
            {id:'F',text:'Ů'},
            {id:'N',text:'����'},
           
        ]

	});
	
	//����״�� 
	var MarriedObj = $HUI.combobox("#Married_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married',
		panelHeight:'95',
	});

}


	
function InitOrderDetailDataGrid()
{
	$HUI.datagrid("#OrderDetailComTab",{
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
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"StationOrderDetailList",
			ParRef:$("#ParRef").val(),
			Desc:"",
			Code:"",
		},
		frozenColumns:[[
			{field:'OD_Desc',width:'150',title:'ϸ������'},
			{field:'OD_Code',width:'100',title:'ϸ�����'},
		]],
		columns:[[
		    {field:'OD_ParRef',title:'ID',hidden: true},
		    {field:'OD_RowId',title:'ID',hidden: true},
		    {field:'OD_ChildSub',title:'ID',hidden: true},
			{field:'OD_Type',width:'80',title:'����'},
			{field:'OD_Sequence',width:'100',hidden: true},
			{field:'OD_Sex',width:'60',title:'�Ա�'},
			{field:'Married',title:'����',hidden: true},
			{field:'MarriedDesc',width:'60',title:'����'},
			{field:'OD_LabtrakCode',width:'100',title:'�������'},	
			{field:'OD_Summary',width:'80',title:'����С��'},
			{field:'OD_Advice',width:'100',hidden: true},
			{field:'NoPrint',width:'70',title:'����ӡ'},
			{field:'SpecialNature',width:'100',title:'���ⷶΧ'},
			{field:'ZhToEng',width:'90',title:'Ӣ�Ķ���'},
			{field:'OD_Explain',width:'100',title:'˵��'},
			{field:'OD_Expression',width:'250',title:'���ʽ'},
			{field:'OD_ParRef_Name',width:'100',title:'վ������'},
			{field:'HistoryFlag',width:'70',title:'�����жԱ�'}
		]],
		onSelect: function (rowIndex, rowData) {
			
			$("#ID").val(rowData.OD_RowId)
			  		
						
				
					
					
		}
		
			
	})
}

function LoadOrderDetailComlist(rowData)
{
	
	$('#ParRef').val(rowData.ST_RowId);
	$('#StaionDesc').val(rowData.ST_Desc);
	$('#OrderDetailComTab').datagrid('load', {
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"StationOrderDetailList",
			ParRef:$('#ParRef').val(),
			Desc:"",
			Code:"",
		
	});
	
	
}
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
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [],
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"StationList",
		},
		columns:[[

		    {field:'ST_RowId',title:'ID',hidden: true},
		    {field:'ST_Code',width:'50',title:'����'},
			{field:'ST_Desc',width:'200',title:'����'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#OrderDetailComTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadOrderDetailComlist(rowData);
			$("#ID").val("");		
		}
		
			
	})

}

