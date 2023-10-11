//
//����	DHCPEGroupDiagnosisPercent.hisui.js
//����	�������꼲��������ά������
//����	2022.12.06
//������  sunxintao
var editIndex=undefined;
var GroupID="";
var GType="";
$(function(){
  	InitCombobox();
			
	InitStationDataGrid();
	
	InitDetailDataGrid();
	
	InitPercentGrid();

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
	$HUI.datagrid("#YearTab",{
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
			ClassName:"web.DHCPE.GroupDiagnosisPercent",
			QueryName:"QueryYear",
		},
		columns:[[

		    
		    {field:'Year',width:'300',title:'���'}
					
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
	GroupID="";
	GType="";
	var Type=""
	var CID=$("#Contract").combogrid('getText');
	var CID=$("#Contract").combogrid('getValue');
	var GID=$("#GADM").combogrid('getValue');
	var DID=$("#Depart").combogrid('getText');
	var ID="";
	//alert(CID)
	if (CID!=""){
		Type="C";
		ID=CID
	}else if(GID!=""){
		Type="G"
		ID=GID
	}else{
		Type="D"
		ID=DID
	}
	$("#GInfoTab").datagrid('load', {
			ClassName:"web.DHCPE.GroupDiagnosisPercent",
			QueryName:"QueryGInfo",
			GType:Type,
			ID:ID
		
	});
	
	$('#PercentGrid').datagrid('loadData', {
				total: 0,
				rows: []
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
function InitDetailDataGrid()
{
	
	$HUI.datagrid("#GInfoTab",{
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
			GType:"",
			ID:"",
		},
		columns:[[

		    {field:'ID',title:'ID',hidden: true},
		    {field:'TypeDesc',width:'50',title:'����'},
		    {field:'Name',width:'200',title:'����'},
		    {field:'GType',hidden: true,title:'��������'}			
		]],
		
		onSelect: function (rowIndex, rowData) {
			  		
			  		GroupID=rowData.ID;
			  		GType=rowData.GType
			$('#PercentGrid').datagrid('loadData', {
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
	debugger; //
	
	var Year=$("#YearTab").datagrid("getSelected").Year;
	
	// Type// GID
	//BClear_click();
	$("#PercentGrid").datagrid('load', {
			ClassName:"web.DHCPE.GroupDiagnosisPercent",
			QueryName:"QueryDiagnosis",
			Year:Year,
			Type:rowData.GType,
			GID:rowData.ID
		
	});
	
	
}


function InitPercentGrid()
{
	// DiagnosisDesc,DiagnosisType,Percent
	$HUI.datagrid("#PercentGrid",{
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
		toolbar: [],//������toolbarΪ��ʱ,���ڱ�������ͷ�������"
		//displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.GroupDiagnosisPercent",
			QueryName:"QueryDiagnosis",
			Year:'',
			Type:''
		},
		columns:[[
		    {field:'Year',title:'Year',hidden: true},
		    {field:'Type',title:'Type',hidden: true},
		    {field:'EDID',title:'EDID',hidden: true},
		    {field:'DiagnosisDesc',width:'160',title:'����'},
		    {field:'DiagnosisType',width:'60',title:'����'},
			{field:'Percent',width:'120',title:'�ٷֱ�',editor:{type:'numberbox'}}
						
		]],
		onSelect: function (rowIndex, rowData) {
			
					
		
		},onAfterEdit:function(rowIndex,rowData,changes){
			
			//alert(rowIndex);
			//alert(rowData);
			//alert(changes);
			debugger; //
			SavePercent(rowData.EDID,rowData.Year,rowData.Percent)
			
		},onDblClickRow: onDblClickRow
		
			
	})
}
function onDblClickRow(index,value){
     
        NowRow=index;
        debugger; //
        if (editIndex!=index) {
            if (endEditing()){
                $('#PercentGrid').datagrid('selectRow',index).datagrid('beginEdit',index);
                
                var tt = $('#PercentGrid').datagrid('getEditor', { index: index, field: 'Percent' });
                //var IsMedical = $('#PreItemList').datagrid('getRows')[index]['TIsMedical'] 
                
                editIndex = index;
                
            } else {
                $('#PercentGrid').datagrid('selectRow',editIndex);
            }
        }
     
    }
function endEditing(){
            
            if (editIndex == undefined){return true}
            debugger; //  222
            if ($('#PercentGrid').datagrid('validateRow', editIndex)){
	            
               $('#PercentGrid').datagrid('endEdit',editIndex);
               
                //SavePercent(EDID,Year,Percent)
                editIndex = undefined;
                return true;
            } else {
                return false;
            }
    }
function SavePercent(EDID,Year,Percent)
{
	//var GroupID=$("#GInfoTab").datagrid('')
	// GType  GroupID
	/// d ##Class(web.DHCPE.GroupDiagnosisPercent).SavePercent(GType, GID, Year, EDID, Percent)
	if((GroupID=="")||(GType=="")){
		alert("û��ѡ��������Ϣ")
	}
	// d ##Class(web.DHCPE.GroupDiagnosisPercent).SavePercent(GType, GID, Year, EDID, Percent)
	var ret=tkMakeServerCall("web.DHCPE.GroupDiagnosisPercent","SavePercent",GType, GroupID, Year, EDID, Percent);
	debugger; // ret
	
	
	
	}
function InitCombobox()
{
	// ��ͬ
	   var OPNameObj = $HUI.combogrid("#Contract",{
		panelWidth:270,
		url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract",
		mode:'remote',
		delay:200,
		idField:'TID',
		textField:'TName',
		onBeforeLoad:function(param){
			param.Contract = param.q;
		},
		columns:[[
		    {field:'TNo',title:'���',width:60},
			{field:'TName',title:'����',width:100},
			{field:'TSignDate',title:'ǩ������',width:110}
				
		]],
		onLoadSuccess:function(){
			//$("#OPName").combogrid('setValue',""); 
		},

		});
		
		// ����
	   var OPNameObj = $HUI.combogrid("#GADM",{
		panelWidth:270,
		url:$URL+"?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
		mode:'remote',
		delay:200,
		idField:'Hidden',
		textField:'Name',
		onBeforeLoad:function(param){
			param.Code = param.q;
		},
		columns:[[
		    {field:'Name',title:'����',width:100},
			{field:'Hidden',title:'ID',width:100},
			{field:'Begin',title:'��ʼ����',width:110},
			{field:'End',title:'��ֹ����',width:110}
				
		]],
		onLoadSuccess:function(){
			//$("#OPName").combogrid('setValue',""); 
		},

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

