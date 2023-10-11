
/*
 * FileName: dhcpe/ct/odstandardcom.js
 * Author: xy
 * Date: 2021-08-14
 * Description: ϸ��ѡ��ά��
 */
 
var odstableName = "DHC_PE_ODStandard"; //վ��ϸ��ѡ���

var tableName ="DHC_PE_OrderDetail";  //ϸ���

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	
$(function(){
	
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	 //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
	       BFind_click();
	       BODFind_click();
	       $("#StationID,#ODRowID,#ODSDesc,#ODType").val('');
	       BClear_click();
		   $('#ODStandardComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
	    		 
       }
		
	});
	
	
  	InitCombobox();
			
	//��ʼ�� վ��Grid 
	InitStationGrid();
	 
	//��ѯ��վ�㣩
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
	$("#Desc").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});
	
	//��ʼ�� ϸ��Grid 
	InitOrderDetailDataGrid();
	
	//��ѯ(ϸ��)
	$("#BODFind").click(function(e){
    	BODFind_click();
    });
    
    
	$("#ODDesc").keydown(function(e) {	
		if(e.keyCode==13){
			BODFind_click();
		}
	});

	
	//��ʼ�� ϸ��ѡ��Grid 
	InitODStandardComDataGrid();
	
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
    
    //��ѯ
    $("#BODSFind").click(function(){
    	BODSFind_click();
    });
    
	 //Ĭ���Ա�Ϊ"����"
	$("#Sex").combobox('setValue',"N"); 
   /*
	$('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			LocID:session['LOGON.CTLOCID']
		});		
	   }			
    }); 
    */
	/*
    //������Ȩ
     $("#BPower").click(function(){
    	BPower_click();
    });
    */
    
    //��Ȩ����
     $("#BRelateLoc").click(function(){
    	BRelateLoc_click();
    });
    
})



//��ѯ��ϸ�
 function BODFind_click()
{
	$("#OrderDetailTab").datagrid('load', {
		ClassName:"web.DHCPE.CT.StatOrderDetail",
		QueryName:"FindOrderDetail",
		StationID:$("#StationID").val(),
		Desc:$("#ODDesc").val(),
		LocID:$("#LocList").combobox('getValue'),
		tableName:tableName
		
	});	

}

//��ʼ�� ϸ��Grid 
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
			ClassName:"web.DHCPE.CT.StatOrderDetail",
			QueryName:"FindOrderDetail",
			StationID:$("#StationID").val(),
			Desc:"",
			LocID:session['LOGON.CTLOCID'],
			tableName:tableName
		},
		columns:[[

		    {field:'TODID',title:'ODID',hidden: true},
		    {field:'TODType',title:'ODType',hidden: true},
		    {field:'TStationName',width:150,title:'վ��'},
		    {field:'TODDesc',width:150,title:'����'},
					
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


/**********************ϸ�� end************************************/

/**********************ϸ��ѡ�� start************************************/

//��ѯ��ϸ��ѡ��
function BODSFind_click(){
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

	$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			LocID:locId
	});	
}

//������Ȩ/ȡ����Ȩ
function BPower_click(){
	var DateID=$("#ODSRowID").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ������Ȩ�ļ�¼","info"); 
		return false;
	}
	var selected = $('#ODStandardComGrid').datagrid('getSelected');
	if(selected){
	
		//������Ȩ 
		var iEmpower="N";
		var Empower=$("#Empower").checkbox('getValue');
		if(Empower) iEmpower="Y";
		var LocID=$("#LocList").combobox('getValue');
		var UserID=session['LOGON.USERID'];
	    var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",odstableName,DateID,LocID,UserID,iEmpower)
		var rtnArr=rtn.split("^");
		if(rtnArr[0]=="-1"){
			$.messager.alert("��ʾ","��Ȩʧ��","error");
		}else{
			$.messager.alert("��ʾ","��Ȩ�ɹ�","success");
			 $("#ODStandardComGrid").datagrid('reload');
		}		
	}	
}
    

//��Ȩ����
function BRelateLoc_click()
{
	var DateID=$("#ODSRowID").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}
   var LocID=$("#LocList").combobox('getValue');
   //alert("LocID:"+LocID)
    OpenLocWin(odstableName,DateID,SessionStr,LocID,InitODStandardComDataGrid);
}

function LoadODStandardComDatalist(rowData)
{
	$("#ODRowID").val(rowData.TODID);
	$("#ODSDesc").val(rowData.TODDesc);
	$("#ODType").val(rowData.TODTypeDR);
	BClear_click();

	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

	$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			LocID:locId		
		
	});
		
}




//��ʼ�� ϸ��ѡ��Grid 
function InitODStandardComDataGrid()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

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
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			LocID:locId,	
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N"
		},
		frozenColumns:[[
			{field:'TSort',width:60,title:'˳���',sortable:true},
			{field:'TTextVal',width:120,title:'�ı�ֵ'},
			{field:'TNatureValue',width:60,title:'����ֵ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TNoActive',width:80,title:'����',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			}
					
		]],
		columns:[[
		    {field:'ODS_ParRef',title:'ParRef',hidden: true},
		    {field:'ODS_RowId',title:'RowId',hidden: true},
		    {field:'ODS_ChildSub',title:'ChildSub',hidden: true},
		    {field:'TSex',title:'Sex',hidden: true},
		    {field:'TSexDesc',width:60,title:'�Ա�'},
		
			{field:'THDValue',width:60,title:'�ĵ�ֵ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TNoPrint',width:60,title:'����ӡ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TSummary',width:80,title:'����С��',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TAgeMin',width:80,title:'��������'},
			{field:'TAgeMax',width:80,title:'��������'},
			{field:'TMin',width:60,title:'����'},
			{field:'TMax',width:60,title:'����'},
			{field:'TUnit',width:60,title:'��λ'},
			{field:'TEyeSee',width:100,title:'����'},
			{field:'TDefault',width:80,title:'Ĭ��',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			
			
			{field:'TUpdateDate',width:120,title:'��������'},	
			{field:'TUpdateTime',width:120,title:'����ʱ��'},	
			{field:'TUserName',width:120,title:'������'}
            /*
			{field:'TEmpower',width:80,title:'�Ƿ񵥶���Ȩ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       				}
			},{ field:'TEffPowerFlag',width:100,align:'center',title:'��ǰ������Ȩ',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}
			*/
						
		]],
		onSelect: function (rowIndex, rowData) {
		
			if((rowData.TEmpower=="Y")){		
				$("#BRelateLoc").linkbutton('enable');
				$("#Empower").checkbox('setValue',true);
				//$("#BPower").linkbutton({text:'ȡ����Ȩ'});
			}else{
				if(rowData.TNoActive=="Y")	{
					$("#BRelateLoc").linkbutton('disable');
					//$("#BPower").linkbutton('enable');
					$("#Empower").checkbox('setValue',false);
					//$("#BPower").linkbutton({text:'������Ȩ'})
					
				}else{
					$("#BRelateLoc").linkbutton('disable');
					//$("#BPower").linkbutton('disable');			
				}
			}
			$("#ODSRowID").val(rowData.ODS_RowId);
			$("#ChildSub").val(rowData.ODS_ChildSub);
			$("#Sex").combobox('setValue',rowData.TSex);
			$("#Sort").val(rowData.TSort);
			if(rowData.TNatureValue=="Y"){
				$("#NatureValue").checkbox('setValue',true);
			}else{
				$("#NatureValue").checkbox('setValue',false);
			}
			if(rowData.TSummary=="Y"){
				$("#Summary").checkbox('setValue',true);
			}else{
				$("#Summary").checkbox('setValue',false);
			}
			if(rowData.THDValue=="Y"){
				$("#HDValue").checkbox('setValue',true);
			}else{
				$("#HDValue").checkbox('setValue',false);
			}
			if(rowData.TNatureValue=="Y"){
				$("#NatureValue").checkbox('setValue',true);
			}else{
				$("#NatureValue").checkbox('setValue',false);
			}
			$("#EyeSee").val(rowData.TEyeSee);
			$("#Unit").val(rowData.TUnit);
			$("#ReferenceMin").val(rowData.TMin);
			$("#ReferenceMax").val(rowData.TMax);
			$("#AgeMin").val(rowData.TAgeMin);
			$("#AgeMax").val(rowData.TAgeMax); 
			$("#TextVal").val(rowData.TTextVal); 
			$("#CurNatureValue").val(rowData.TNatureValue); 
			
			if(rowData.TDefault=="Y"){
				$("#Default").checkbox('setValue',true);
			}else{
				$("#Default").checkbox('setValue',false);
			}
					
			if(rowData.TNoPrint=="Y"){
				$("#NoPrint").checkbox('setValue',true);
			}else{
				$("#NoPrint").checkbox('setValue',false);
			}
			if(rowData.TNoActive=="Y"){
				$("#NoActive").checkbox('setValue',true);
			}else{
				$("#NoActive").checkbox('setValue',false);
			}
				
				
				
				
					
		
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
            {id:'M',text:$g('��')},
            {id:'F',text:$g('Ů')},
            {id:'N',text:$g('����')},
           
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
	
	
	//Ĭ��
	var iDefault="N";
	var Default=$("#Default").checkbox('getValue');
	if(Default) iDefault="Y";
    

	//�Ƿ����С�� 
	var iSummary="N";
	var Summary=$("#Summary").checkbox('getValue');
	if(Summary) iSummary="Y";
	
	
	//�ĵ�ֵ
	var iHDValue="N";
	var HDValue=$("#HDValue").checkbox('getValue');
	if(HDValue) iHDValue="Y";
	
	if((iHDValue=="Y")&&(iNatureValue=="Y")){
		$.messager.alert("��ʾ","����ֵ�ͻĵ�ֵ����ͬʱ����","info");
	    return false;
	}

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
	
	//����
	var iNoActive="N";
	var NoActive=$("#NoActive").checkbox('getValue');
	if(NoActive) iNoActive="Y";

	var iEmpower="N";
	var Empower=$("#Empower").checkbox('getValue');
	if(Empower) iEmpower="Y";
	
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
	      		+"^"+iDefault
	      		+"^"+iNoActive
				+"^"+iEmpower
		;
	//alert(Instring)
 	var rtn=tkMakeServerCall("web.DHCPE.CT.ODStandard","SaveODStandard",Instring,odstableName,session['LOGON.USERID'],session['LOGON.CTLOCID']);
	var rtnArr=rtn.split("^");
	if(rtnArr[0]=="-1"){
		$.messager.alert('��ʾ', '����ʧ��:'+ rtnArr[1], 'error');				
	}else{
		BClear_click();
		if(Type=="1"){$.messager.popover({msg: '�޸ĳɹ�',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '�����ɹ�',type:'success',timeout: 1000});}		
	} 	
}

//����
function BClear_click()
{
	$("#ODSRowID,#ChildSub,#TextVal,#EyeSee,#Sort,#Unit,#ReferenceMax,#ReferenceMin,#AgeMin,#AgeMax,#CurNatureValue,#Default").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#NoActive").checkbox('setValue',true);
	//Ĭ�Ͻ���С�� 
	$("#Summary").checkbox('setValue',true);	
	//Ĭ���Ա�Ϊ"����"
	$("#Sex").combobox('setValue',"N");
    //$("#BPower").linkbutton({text:'������Ȩ'});
    $("#BRelateLoc").linkbutton('enable');
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

	 $("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			LocID:locId
			
		
	});
	
}

/**********************ϸ��ѡ�� end************************************/

/**********************վ�� start************************************/
// ��ʼ��վ��ά��DataGrid
function InitStationGrid()
{
	$('#StaionGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
		
		    {field:'TStationID',title:'ID',hidden: true},
			{field:'TStationCode',title:'����',width: 70},
			{field:'TStationDesc',title:'����',width: 180},
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationSet",
			LocID:session['LOGON.CTLOCID'],
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			$("#ODDesc").val('');
		
			$('#OrderDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			
			BODFind_click();
			$("#ODRowID,#ODSDesc,#ODType").val('');
			BClear_click();
			$('#ODStandardComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
		
		},
		onLoadSuccess: function (data) {		 
			
		}
	});
	
}

	

//��ѯ��վ�㣩
function BFind_click(){
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		LocID:$("#LocList").combobox('getValue'),
		Desc:$("#Desc").val(),
		STActive:"Y"
	});	
	
}

/**********************վ�� end************************************/


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

