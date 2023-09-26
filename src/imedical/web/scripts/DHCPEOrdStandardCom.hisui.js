//
//����	DHCPEOrdStandardCom.hisui.js
//����	ϸ��ѡ��ά��
//����	2019.05.31
//������  xy
$(function(){
  	InitCombobox();
			
	InitStationDataGrid();
	
	InitOrderDetailDataGrid();
	
	InitODStandardComDataGrid();

	//��ѯ
	$("#BFind").click(function(e){
    	BFind_click();
    });
    
    
	$("#ODDesc").keydown(function(e) {
			
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
	
	 //Ĭ���Ա�Ϊ"����"
	$("#Sex").combobox('setValue',"N"); 

})



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
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [],//������toolbarΪ��ʱ,���ڱ�������ͷ�������"
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
			  		
			$('#OrderDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadOrderDetailTablist(rowData);
					
		}
		
			
	})

}

/**********************ϸ�����************************************/
 function BFind_click()
{
	
	$("#OrderDetailTab").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"OrderDetailList",
			ParRef:$('#ParRef').val(),
			Desc:$("#ODDesc").val()
		
	});

}



function LoadOrderDetailTablist(rowData)
{
	
	$("#ParRef").val(rowData.ST_RowId);
	$("#ODRowID,#ODSRowID,#ChildSub,#ODType").val("");
	
	$("#OrderDetailTab").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"OrderDetailList",
			ParRef:$('#ParRef').val(),
		
	});
	
	
}
function InitOrderDetailDataGrid()
{
	
	$HUI.datagrid("#OrderDetailTab",{
		url:$URL,
		fit : true,
		border: false,
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
			ClassName:"web.DHCPE.OrderDetail",
			QueryName:"OrderDetailList",
			ParRef:$('#ParRef').val(),
		},
		columns:[[

		    {field:'OD_RowId',title:'ID',hidden: true},
		    {field:'OD_Type',title:'ODType',hidden: true},
		    {field:'OD_Desc',width:'200',title:'����'},
			{field:'OD_Code',width:'80',title:'����'},			
		]],
		
		onSelect: function (rowIndex, rowData) {
			  		
			$('#ODStandardComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadODStandardComDatalist(rowData);
					
		}
		
			
	})
}

/**********************ϸ��ѡ��ά������************************************/
function LoadODStandardComDatalist(rowData)
{
	
	$("#ODRowID").val(rowData.OD_RowId);
	$("#ODSDesc").val(rowData.OD_Desc);
	$("#ODType").val(rowData.OD_Type);
	BClear_click();
	$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.ODStandard",
			QueryName:"SearchODStandardNew",
			ParRef:$("#ODRowID").val(),
		
	});
	
	
}


function InitODStandardComDataGrid()
{
	$HUI.datagrid("#ODStandardComGrid",{
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
		//displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.ODStandard",
			QueryName:"SearchODStandardNew",
			ParRef:$("#ODRowID").val(),
		},
		frozenColumns:[[
			{field:'TTextVal',width:'120',title:'�ı�ֵ'},
		]],
		columns:[[
		    {field:'ODS_ParRef',title:'ParRef',hidden: true},
		    {field:'ODS_RowId',title:'RowId',hidden: true},
		    {field:'ODS_ChildSub',title:'ChildSub',hidden: true},
		    {field:'TSex',title:'Sex',hidden: true},
		    {field:'TSexDesc',width:'60',title:'�Ա�'},
		    {field:'TSort',width:'60',title:'���'},
			{field:'TNatureValue',width:'60',title:'����ֵ'},
			{field:'THDValue',width:'60',title:'�ĵ�ֵ'},
			{field:'TNoPrint',width:'60',title:'����ӡ'},
			{field:'TSummary',width:'60',title:'����С��'},
			{field:'TAgeMin',width:'80',title:'��������'},
			{field:'TAgeMax',width:'80',title:'��������'},
			{field:'TMin',width:'60',title:'����'},
			{field:'TMax',width:'60',title:'����'},
			{field:'TUnit',width:'60',title:'��λ'},
			{field:'TEyeSee',width:'100',title:'����'},	
						
		]],
		onSelect: function (rowIndex, rowData) {
			$("#ODSRowID").val(rowData.ODS_RowId);
			$("#ChildSub").val(rowData.ODS_ChildSub);
			$("#Sex").combobox('setValue',rowData.TSex);
			$("#Sort").val(rowData.TSort);
			if(rowData.TNatureValue=="��"){
					$("#NatureValue").checkbox('setValue',false);
				}if(rowData.TNatureValue=="��"){
					$("#NatureValue").checkbox('setValue',true);
				};
			if(rowData.TSummary=="��"){
					$("#Summary").checkbox('setValue',false);
				}if(rowData.TSummary=="��"){
					$("#Summary").checkbox('setValue',true);
				};
			if(rowData.THDValue=="��"){
					$("#HDValue").checkbox('setValue',false);
				}if(rowData.THDValue=="��"){
					$("#HDValue").checkbox('setValue',true);
				};	
			if(rowData.TNatureValue=="��"){
					$("#NatureValue").checkbox('setValue',false);
				}if(rowData.TNatureValue=="��"){
					$("#NatureValue").checkbox('setValue',true);
				};
			$("#EyeSee").val(rowData.TEyeSee);
			$("#Unit").val(rowData.TUnit);
			$("#ReferenceMin").val(rowData.TMin);
			$("#ReferenceMax").val(rowData.TMax);
			$("#AgeMin").val(rowData.TAgeMin);
			$("#AgeMax").val(rowData.TAgeMax); 
			$("#TextVal").val(rowData.TTextVal); 
			$("#CurNatureValue").val(rowData.TNatureValue); 
					
		
		}
		
			
	})
}


function InitCombobox()
{
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
}


 //����
function BAdd_click()
{
	BSave_click("0");
}

 //�޸�
function BUpdate_click()
{
	BSave_click("1");
}

function BSave_click(Type)
{
	if(Type=="1"){
		var ID=$("#ODSRowID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
		if($("#ODRowID").val()==""){
		    	$.messager.alert("��ʾ","����ѡ��ϸ��","info");
		    	return false;
		    }
	    if($("#ODSRowID").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
		var ID="";
	}
	var OrderDetailType=$("#ODType").val();
	var iParRef=$("#ODRowID").val();
	var iChildSub=$("#ChildSub").val();
	var iRowId="";
		
	//�Ա�
	var iSex=$("#Sex").combobox('getValue');
	if (($("#Sex").combobox('getValue')==undefined)||($("#Sex").combobox('getValue')=="")) {var iSex = "";}
	if(iSex==""){
		$.messager.alert("��ʾ","�Ա���Ϊ��","info"); 
			return false;
	}

	//��������
	var iAgeMin=$("#AgeMin").val();
	if (IsValidAge(iAgeMin)){}
		else { 
			$.messager.alert("��ʾ","�������޴���","info");		
			return false;
		}
			

	//��������
	var iAgeMax=$("#AgeMax").val();
	if (IsValidAge(iAgeMax)){}
		else {
			$.messager.alert("��ʾ","�������޴���","info");		
			return false;
		}
	
	if(iAgeMin>iAgeMax){
		$.messager.alert("��ʾ","�������޲��ܴ�����������","info");
		return false;
	}
	
	//�ı�ֵ
	var iTextVal=$.trim($("#TextVal").val());

	//��λ
	var iUnit=$("#Unit").val();
	
	//����
	var iMin=$("#ReferenceMin").val();
	if (!(IsFloat(iMin))) {
		$.messager.alert("��ʾ","�ο�ֵ���޴���","info");
		return false;
	}
	
	//����
	var iMax=$("#ReferenceMax").val();
	if (!(IsFloat(iMax))) {
		$.messager.alert("��ʾ","�ο�ֵ���޴���","info");
		return false;
	}
	
	//alert(OrderDetailType)
	if (("T"==OrderDetailType)||("S"==OrderDetailType)){
	    //����������֤
		if (""==iTextVal) {
			$.messager.alert("��ʾ","�ı�ֵ����Ϊ��","info");
			return false;
	 	}
	}
	else{
		
		if ((""==iMax)&&(""==iMin)&&(""==iUnit)) {
			$.messager.alert("��ʾ","�ο���Χһ������Ϊ��","info");
			return false;
		}	
	}


	//���
	var iSort=$("#Sort").val();
	
	//����
	var iEyeSee=$("#EyeSee").val();
	
	//�Ƿ�����ֵ 
	var iNatureValue="N";
	var NatureValue=$("#NatureValue").checkbox('getValue');
	if(NatureValue) iNatureValue="Y";
	
	
	//�Ƿ����С�� 
	var iSummary="N";
	var Summary=$("#Summary").checkbox('getValue');
	if(Summary) iSummary="Y";
	
	
	//�ĵ�ֵ
	var iHDValue="N";
	var HDValue=$("#HDValue").checkbox('getValue');
	if(HDValue) iHDValue="Y";
	
	
	//����ӡ
	var iNoPrint="N";
	var NoPrint=$("#NoPrint").checkbox('getValue');
	if(NoPrint) iNoPrint="Y";
	
	var iHighRiskFlag="N";
	
	
	var CurNatureValue=$("#CurNatureValue").val();
	var ret=tkMakeServerCall("web.DHCPE.ODStandard","GetODSNatureValue",iParRef,iRowId);
	if((CurNatureValue=="��")&&(iNatureValue=="Y")&&(ret=="1"))
	 {
	   $.messager.alert("��ʾ","����ֵ������,�����ظ�����","info");
	    return false;
    
	}
	
	var Instring = iParRef	
				+"^"+iRowId		
				+"^"+iChildSub
				+"^"+$.trim(iTextVal)		
				+"^"+$.trim(iUnit)		
				+"^"+$.trim(iSex)			
				+"^"+$.trim(iMin)		
				+"^"+$.trim(iMax)					
				+"^"+""					
				+"^"+iNatureValue
				+"^"+$.trim(iAgeMin)		
				+"^"+$.trim(iAgeMax)		
				+"^"+$.trim(iSort)	
	      		+"^"+iSummary
				+"^"+iNoPrint
	      		+"^"+""
	      		+"^"+iHighRiskFlag   
	      		+"^"+$.trim(iEyeSee)
	      		+"^"+iHDValue
		;
	//alert(Instring)
 	var flag=tkMakeServerCall("web.DHCPE.ODStandard","Save",'','',Instring);
	if (flag==0){
		
		BClear_click();
		
		if(Type=="1"){$.messager.alert("������ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("������ʾ","�����ɹ�","success");}
	}else{
		$.messager.alert("������ʾ","����ʧ��","error");	
	} 	
}

//ɾ��
function BDelete_click()
{
	var ID=$("#ODSRowID").val();
	if(ID==""){
		$.messager.alert('������ʾ',"��ѡ���ɾ���ļ�¼","info");
		return
	}
	var ParRef=$("#ODRowID").val();
	var ChildSub=$("#ChildSub").val();
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.ODStandard", MethodName:"Delete", itmjs:'',itmjsex:'',ParRef:ParRef,ChildSub:ChildSub },function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$("#ODSRowID").val(""); 
					$("#ODStandardComGrid").datagrid('load', {
						ClassName:"web.DHCPE.ODStandard",
						QueryName:"SearchODStandardNew",
						ParRef:$("#ODRowID").val(),
		
					});
					BClear_click();
			       // $('#myWin').dialog('close'); 
				}
			});	
		}
	});
}

//����
function BClear_click()
{
	
	$("#ODSRowID,#ChildSub,#TextVal,#EyeSee,#Sort,#Unit,#ReferenceMax,#ReferenceMin,#AgeMin,#AgeMax,#CurNatureValue").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
		//Ĭ���Ա�Ϊ"����"
	$("#Sex").combobox('setValue',"N");

	  
	$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.ODStandard",
			QueryName:"SearchODStandardNew",
			ParRef:$("#ODRowID").val(),
		
	});
}


//��֤�Ƿ�Ϊ��ȷ����
function IsValidAge(Value) {
	
	if(""==$.trim(Value) || "0"==Value) { 
		//����Ϊ��
		return true; 	
	}
	if (!(IsFloat(Value))) { return false; }
	
	if ((Value>0)&&(Value<120)) {
		return true; 
	}
}

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==$.trim(Value)) { 
		//����Ϊ��
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

