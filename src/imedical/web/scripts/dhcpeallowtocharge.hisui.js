
/*
 * FileName:    dhcpeallowtocharge.hisui.js
 * Author:      xy
 * Date:        20221205
 * Description: ����ɷѹ���
 */
 
 $(function(){
	 
	 //�����б��
	 InitCombobox();
	
	//��ʼ���б�
	InitAllowToChargeGrid();
	
	$("#RegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			BFind_click();
		}
	});
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
    
	 //����
	 $("#BClear").click(function() {	
		BClear_click();		
     });
     
    //����ɷ�/��������ɷ�
	$("#BSave").click(function() {	
		BSave_click();		
     });
     
})

 //����ɷ�/��������ɷ�
function BSave_click()
{ 
    var UserId=session['LOGON.USERID'];
	var selected = $('#AllowToChargeGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('��ʾ', "��ѡ�������ɷѵļ�¼", 'info');
		return;
	}
	var GADMID=selected.PEIAdmId;
	var AllowFlag=selected.TSelect;
	if(AllowFlag=="0"){
		var AllowFlag=1;
	}else{
		 AllowFlag=0;
	}
	var Type="Group";
	if(AllowFlag=="0"){
		$.messager.confirm("ȷ��", "ȷ��Ҫ��������ɷ���", function(r){
		if (r){
			var ret=tkMakeServerCall("web.DHCPE.AllowToCharge","AllowToCharge",GADMID+"^"+AllowFlag,Type,"ADM",UserId);
 			if(ret=="0"){	
   				$.messager.popover({msg: "��������ɷѳɹ���", type: "success",timeout: 1000});
   				BFind_click();
 			}
			
		}else{
			return;
		}
	});	
	}else{
		
 		var ret=tkMakeServerCall("web.DHCPE.AllowToCharge","AllowToCharge",GADMID+"^"+AllowFlag,Type,"ADM",UserId);
 		if(ret=="0"){	
   			$.messager.popover({msg: "����ɷѳɹ���", type: "success",timeout: 1000});
   			BFind_click();
 		}
	}
	
}


//��ѯ
function BFind_click() {

	var CTLocID=session['LOGON.CTLOCID'];
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
			$("#RegNo").val(iRegNo);
	}
	
	var iGroupID=$("#GroupName").combogrid('getValue');
	if (($("#GroupName").combogrid('getValue')==undefined)||($("#GroupName").combogrid('getValue')=="")){var iGroupID="";} 
	
	var iHadAllowed="0";
	var HadAllowed=$("#HadAllowed").checkbox('getValue');
	if(HadAllowed){iHadAllowed="1";}  
	//alert($("#AdmDate").datebox('getValue')+"^"+$("#EndDate").datebox('getValue')+"^"+iGroupID+"^"+iRegNo+"^"+iHadAllowed+"^"+1)
	 //s ^dhcpe("AllowToCharge")=$lb(txtPatName,txtGroupId,txtAdmDate,txtAdmNo,txtItemId,EndDate,HadAllowed,ShowGroup)
	$("#AllowToChargeGrid").datagrid('load',{
		ClassName:"web.DHCPE.AllowToCharge",
		QueryName:"AllowToCharge",
		txtAdmDate:$("#AdmDate").datebox('getValue'),
		EndDate:$("#EndDate").datebox('getValue'),
		txtGroupId:iGroupID,
		txtAdmNo:iRegNo,
		HadAllowed:iHadAllowed,
		ShowGroup:1,
	

	});
}

//����
function BClear_click()
{
	$("#RegNo").val("");
	$("#AdmDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#GroupName").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#BSave").linkbutton({text:'����ɷ�'})
	BFind_click();
}


function InitAllowToChargeGrid(){

	$HUI.datagrid("#AllowToChargeGrid",{
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
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.AllowToCharge",
			QueryName:"AllowToCharge",
			txtAdmDate:$("#AdmDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
						
		},

		columns:[[ 
			
		    {field:'PEIAdmId',title:'PEIAdmId',hidden: true},
			{field:'AdmNo',width:140,title:'�ǼǺ�'},
			{field:'PatName',width:400,title:'��������'},
			{field:'TSelect',title:'����ɷ�',width:90,align:'center',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
					if(value!=""){
	   					if (value=="1") {checked="checked=checked"}
						else{checked=""}
						var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
						return rvalue;
					}
				
			}},     	
			{field:'TGDesc',title:'�Ƿ�����',hidden: true},
			{field:'AdmDate',width:120,title:'�Ǽ�����'},
			{field:'AdmStatus',width:120,title:'״̬'},
			{field:'AdmAccountAmount',width:260,title:'Ӧ�ս��',align:'right'},
			{field:'AdmFactAmount',width:260,title:'�Ѹ����',align:'right'}
	
		]],
		onSelect: function (rowIndex, rowData) {
			if(rowData.TSelect=="1"){
				$("#BSave").linkbutton({text:'��������ɷ�'})
			}else{
				$("#BSave").linkbutton({text:'����ɷ�'})
			}
		
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
	
}


function InitCombobox()
{
	//����
	var GroupNameObj = $HUI.combogrid("#GroupName", {
		panelWidth: 450,
		url: $URL + "?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode: 'remote',
		delay: 200,
		idField: 'TRowId',
		textField: 'TGDesc',
		onBeforeLoad: function (param) {
			param.GBIDesc = param.q;
		},
		onChange: function () {	
		},
		columns: [[
			{ field: 'TRowId', title: '����ID', width: 80 },
			{ field: 'TGDesc', title: '��������', width: 140 },
			{ field: 'TGStatus', title: '״̬', width: 100 },
			{ field: 'TAdmDate', title: '����', width: 100 }

		]]
	})

	
}
