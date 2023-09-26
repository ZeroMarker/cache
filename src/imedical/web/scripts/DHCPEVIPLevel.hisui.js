
//����	DHCPEVIPLevel.hisui.js
//����	�ͻ�VIP�ȼ�ά��
//����	2019.05.07
//������  xy

$(function(){
		
	InitCombobox();
	
	InitVIPLevelDataGrid();
        
    //�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
    
    
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
   
})


//�޸�
function BUpdate_click()
{
	BSave_click("1");
}

 //����
function BAdd_click()
{
	BSave_click("0");
}

function BSave_click(Type)
{
	
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
		if($("#ID").val()!=""){
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
			return false;
		}
		var ID="";
	}
	
	var Desc=$("#Desc").val();
	if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("��ʾ","VIP�ȼ�����Ϊ��","info");
		return false;
	}
	var SetCode=""
	/*
	var SetCode=$("#SetCode").val();
	if (""==SetCode) {
		$("#SetCode").focus();
		var valbox = $HUI.validatebox("#SetCode", {
			required: true,
	    });
		$.messager.alert("��ʾ","�ײͱ��벻��Ϊ��","info");
		return false;
	}
	*/
	var HPCode=$("#HPCode").val();
	if (""==HPCode) {
		$("#HPCode").focus();
		var valbox = $HUI.validatebox("#HPCode", {
			required: true,
	    });
		$.messager.alert("��ʾ","���ű��벻��Ϊ��","info");
		return false;
	}
	

    var HMService=$("#HMService").combobox('getValue');
    if (($("#HMService").combobox('getValue')==undefined)||($("#HMService").combobox('getValue')=="")){var HMService="";}
   
   	
    var OrdSetsDR=$("#OrdSetsDesc").combogrid('getValue');
    if (($("#OrdSetsDesc").combogrid('getValue')==undefined)||($("#OrdSetsDesc").combogrid('getValue')=="")){var OrdSetsDR="";}
    var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(OrdSetsDR)))&&(OrdSetsDR!="")){var OrdSetsDR=$("#OrdSetsDR").val();}
	
    var FeeType=$("#PatFeeType").combogrid('getValue');
    if (($("#PatFeeType").combogrid('getValue')==undefined)||($("#PatFeeType").combogrid('getValue')=="")){var FeeType="";}
	
	var Level=$("#Level").val();
	var ZYDInfo=$("#ZYDInfo").val();
	var ZYDTemplate=$("#ZYDTemplate").val();
	var Template=$("#Template").val();
	
	var iIsSecret="N";
	var IsSecret=$("#IsSecret").checkbox('getValue');
	if(IsSecret) iIsSecret="Y";
	
	var iIsUse="N";
	var IsUse=$("#IsUse").checkbox('getValue');
	if(IsUse) iIsUse="Y"
	
	var iIsApprove="N";
	var IsApprove=$("#IsApprove").checkbox('getValue');
	if(IsApprove) iIsApprove="Y"
	
    var GeneralType=$("#GeneralType").combogrid('getValue');
	
	var IfInsert=$("#IfInsert").combobox('getValue');
    if (($("#IfInsert").combobox('getValue')==undefined)||($("#IfInsert").combobox('getValue')=="")){var IfInsert="";}
   
	
	var Instring=trim(Level)		
		    +"^"+trim(Desc)
		    +"^"+iIsSecret
		    +"^"+iIsUse 		
            +"^"+iIsApprove				
            +"^"+ID
            +"^"+trim(Template)
			+"^"+trim(FeeType)
			+"^"+trim(SetCode)
			+"^"+trim(HPCode)
			+"^"+""
			+"^"+OrdSetsDR
			+"^"+trim(ZYDInfo)
			+"^"+trim(ZYDTemplate)
			+"^"+HMService
			+"^"+GeneralType
			+"^"+IfInsert
			;
		
	
	var CurIsApprove=$("#CurIsApprove").val();
	var ret=tkMakeServerCall("web.DHCPE.VIPLevel","GetVipApprove");
	//alert(CurIsApprove+"^"+iIsApprove+"^"+ret) 
	if((CurIsApprove=="��")&&(iIsApprove=="Y")&&(ret=="1"))
	{
	    $.messager.alert("��ʾ","Ĭ��ֵ������,�����ظ�����","info");
	    return false;
	}
	
	var flag=tkMakeServerCall("web.DHCPE.VIPLevel","Insert",'','',Instring);
	if (flag==0){
		
		BClear_click();
		
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
	}else{
		$.messager.alert("��ʾ","����ʧ��","error");	
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//����
function BClear_click()
{
	$("#ID,#Desc,#HPCode,#Level,#ZYDInfo,#ZYDTemplate,#Template").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#OrdSetsDesc").combogrid('setValue',"");
	$("#PatFeeType").combobox('setValue',"");
	$("#HMService").combobox('setValue',"");
	var valbox = $HUI.validatebox("#HPCode,#HPCode", {
			required: false,
	});
	$("#VIPLevelQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.VIPLevel",
			QueryName:"FindVIPLevel",
	});	
	
	$("#GeneralType").combobox('setValue',"JKTJ");
} 



function InitCombobox()
{
	  //������
	  var VIPObj = $HUI.combobox("#PatFeeType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'70',
		});
	//������
	  var VIPObj = $HUI.combobox("#IfInsert",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindIfInsert&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'90',
		});
		
	 //�ʾ�ȼ�
	  var HMSObj = $HUI.combobox("#HMService",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindHMService&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'105',
		});
		
	//Ĭ���ײ�
	var OrdSeObj = $HUI.combogrid("#OrdSetsDesc",{
		panelWidth:500,
		url:$URL+"?ClassName=web.DHCPE.HandlerOrdSetsEx&QueryName=queryOrdSet",
		mode:'remote',
		delay:200,
		idField:'OrderSetId',
		textField:'OrderSetDesc',
		onBeforeLoad:function(param){
			param.Set = param.q;
			param.Type = "ItemSet";
		},
		columns:[[
		    {field:'OrderSetId',title:'ID',width:80},
		    {field:'OrderSetDesc',title:'����',width:200},
			{field:'IsBreakable',title:'�Ƿ���',width:80},
			{field:'OrderSetPrice',title:'�۸�',width:100},	
					
		]]
		});
		
	// �ܼ�����
	$HUI.combobox("#GeneralType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'JKTJ', text:'�������', selected:'true'},
			{id:'RZTJ', text:'��ְ���'},
			{id:'GWY', text:'����Ա'},
			{id:'ZYJK', text:'ְҵ����'},
			{id:'JKZ', text:'����֤'},
			{id:'OTHER', text:'����'}
		]
	});
}

function InitVIPLevelDataGrid()
{
	$HUI.datagrid("#VIPLevelQueryTab",{
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
			ClassName:"web.DHCPE.VIPLevel",
			QueryName:"FindVIPLevel",
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TDesc',title:'VIP�ȼ�'},
			{field:'TSetCode',title:'�ײͱ���',hidden: true},
			{field:'THPCode',title:'���ű���'},
			{field:'TLevel',title:'����',align:'center'},
			{field:'TFeeTypeName',title:'������'},
			{field:'TFeeTypeDR',title:'TFeeTypeDR',hidden: true},
			{field:'THMService',title:'�ʾ���'},
			{field:'THMServiceDR',title:'THMServiceDR',hidden: true},
			{field:'TIsSecret',width:'40',title:'����',align:'center'},
			{field:'TIsUse',width:'40',title:'ʹ��',align:'center'},
			{field:'TIsApprove',width:'40',title:'Ĭ��',align:'center'},
			{field:'TOrdSetsDR',title:'TOrdSetsDR',hidden: true},
			{field:'TOrdSetsDesc',title:'Ĭ���ײ�'},
			{field:'TZYDInfo',title:'ָ������ʾ'},
			{field:'TZYDTemplate',title:'ָ����ģ��'},
			{field:'TGeneralType',title:'�ܼ�����',
				formatter: function(value,rowData,rowIndex) {
					if (value == "JKTJ") return "�������";
					else if (value == "RZTJ") return "��ְ���";
					else if (value == "GWY") return "����Ա";
					else if (value == "ZYJK") return "ְҵ����";
					else if (value == "JKZ") return "����֤";
					else if (value == "OTHER") return "����";
					else return "�������";
				}
			},
			{field:'TTemplate',title:'ģ������'}
			,
			{field:'TIfInsert',title:'�Ƿ���',
			formatter: function(value,rowData,rowIndex) {
					if (value == "1") return "��";
					else return "��";
				}
				}
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.TID);
				$("#Desc").val(rowData.TDesc);
				$("#SetCode").val(rowData.TSetCode);
				$("#HPCode").val(rowData.THPCode);
				$("#Level").val(rowData.TLevel);
				$("#ZYDInfo").val(rowData.TZYDInfo);
				$("#ZYDTemplate").val(rowData.TZYDTemplate);
				$("#Template").val(rowData.TTemplate);
				$("#OrdSetsDesc").combogrid('setValue',rowData.TOrdSetsDesc);
				$("#OrdSetsDR").val(rowData.TOrdSetsDR);
				$("#HMService").combobox('setValue',rowData.THMServiceDR);
				$("#PatFeeType").combobox('setValue',rowData.TFeeTypeDR);
				
				if(rowData.TIsSecret=="��"){
					$("#IsSecret").checkbox('setValue',false);
				}if(rowData.TIsSecret=="��"){
					$("#IsSecret").checkbox('setValue',true);
				};
				if(rowData.TIsUse=="��"){
					$("#IsUse").checkbox('setValue',false);
				}if(rowData.TIsUse=="��"){
					$("#IsUse").checkbox('setValue',true);
				};
				if(rowData.TIsApprove=="��"){
					$("#IsApprove").checkbox('setValue',false);
				}if(rowData.TIsApprove=="��"){
					$("#IsApprove").checkbox('setValue',true);
				};	
						
				$("#CurIsApprove").val(rowData.TIsApprove);
				//$("#IfInsert").combobox('setValue',rowData.TIfInsert);
				
				if (rowData.TGeneralType == "") $("#GeneralType").combobox('setValue','JKTJ');
				else $("#GeneralType").combobox('setValue',rowData.TGeneralType);
				
				if (rowData.TIfInsert == "1") $("#IfInsert").combobox('setValue',rowData.TIfInsert);
				else $("#IfInsert").combobox('setValue',0);
		}
	});
}