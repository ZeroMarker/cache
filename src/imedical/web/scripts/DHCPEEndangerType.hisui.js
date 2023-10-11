//
//����	DHCPEEndangerType.hisui.js
//����	Σ������ά��
//����	2019.06.13
//������  xy

var WIDTH = $(document).width();
$("#Endanger").css("width", WIDTH*0.5);

$(function(){

	InitCombobox();
	
	InitEndangerTypeGrid();
	
	InitEndangerGrid();
     
    // �޸�(Σ�����ط���ά��)
	$("#update_btn").click(function() {	
		BUpdate_click();		
    });
        
    // ����(Σ�����ط���ά��)
	$("#add_btn").click(function() {	
		BAdd_click();		
    });  
    
    
    // ����(Σ�����ط���ά��)
	$("#BClear").click(function() {	
		BClear_click();		
    });
    
    // �޸�(Σ������ά��)
	$("#ENupdate_btn").click(function() {	
		BENUpdate_click();		
    });
        
    // ����(Σ������ά��)
	$("#ENadd_btn").click(function() {	
		BENAdd_click();		
    });  
    
    
    // ����(Σ������ά��)
	$("#BENClear").click(function() {	
		BENClear_click();		
    });
   
    // Ŀ�꼲��(Σ������ά��)
	$("#ENIllness_btn").click(function() {	
		ENIllness_click();		
    });
    
    // �������(Σ������ά��)
	$("#ENCheckCycle_btn").click(function() {	
		ENCheckCycle_click();		
    });
    
    // ��ϱ�׼(Σ������ά��)
    $("#ENCriteria_btn").click(function() {	
		ENCriteria_click();
    });
        
    // �����Ŀ(Σ������ά��)
	$("#ENItem_btn").click(function() {	
		ENItem_click();		
    });
});

/*******************************************Σ�����ط���ά������***************************/
//����
function BAdd_click() {
	BSave_click("0");
}

//�޸�
function BUpdate_click() {
	BSave_click("1");
}

function BSave_click(Type) {
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
	}
	
	var Code=$("#Code").val();
	if (""==Code) {
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	var Desc=$("#Desc").val();
	if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var VIPLevel="";}
	if (""==VIPLevel) {
		var valbox = $HUI.combobox("#VIPLevel", {
			required: true,
	    });
		$.messager.alert("��ʾ","VIP�ȼ�����Ϊ��","info");
		return false;
	}
	
	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	var ID=$("#ID").val();
	
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	var Str=Code+"^"+Desc+"^"+iActive+"^"+VIPLevel+"^"+ExpInfo+"^"+Remark;
	//alert(Str)
	var rtn=tkMakeServerCall("web.DHCPE.Endanger","UpdateEndangerType",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		if(rtn.split("^")[1].indexOf("Code")>0){
			$.messager.alert("��ʾ","���벻Ψһ","error");
		}
		if(rtn.split("^")[1].indexOf("Desc")>0){
			$.messager.alert("��ʾ","������Ψһ","error");
		}	
		
	}else{
		BClear_click();
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		
	}
}

//����
function BClear_click() {
	$("#ID,#Code,#Desc,#ExpInfo,#Remark").val("");
	$("#Active").checkbox('setValue',true);
	$(".hisui-combobox").combobox('setValue',"");
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	var valbox = $HUI.combobox("#VIPLevel", {
			required: false,
	    });
	$("#EndangerTypeGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEndangerType",
	});
	LoadEndangerList("");
}

function InitCombobox() {	

	   var LocID=session['LOGON.CTLOCID']
	
	// VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+LocID+"&Desc="+escape("ְҵ��"),
		valueField:'id',
		textField:'desc',
		editable:false,
		onLoadSuccess:function(){
			
			//����Ĭ��ֵ
			var Data=$('#VIPLevel').combobox('getData');
			if(Data){
				$('#VIPLevel').combobox('setValue',Data[0].id)
			}
			
		}

	});

}

function InitEndangerTypeGrid() {
	$HUI.datagrid("#EndangerTypeGrid",{
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
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEndangerType",
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:100,title:'����'},
			{field:'TDesc',width:150,title:'����'},
			{field:'TActive',width:40,title:'����'},
			{field:'TVIPLevel',width:100,title:'VIP�ȼ�'},
			{field:'TExpInfo',width:100,title:'��չ��Ϣ'},
			{field:'TRemark',width:100,title:'��ע'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.TID);
				$("#Desc").val(rowData.TDesc);
				$("#Code").val(rowData.TCode);
				$("#VIPLevel").combobox('setValue',rowData.TVIPLevelDR);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',true);
				};
				$('#EndangerGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadEndangerList(rowData);		
												
		}
	})
}

/**************************************Σ������ά��*******************************************************/
//Ŀ�꼲��
function ENIllness_click() {
	var record = $("#EndangerGrid").datagrid("getSelected"); 

	if (!(record)) {
		$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
		return;
	} else {  
		var RowId=record.TID
		var Desc=record.TDesc
		/*
		$("#myWinIllness").show();  
		var myWinGuideImage = $HUI.window("#myWinIllness",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			iconCls:'icon-w-paper',
			title:"Ŀ�꼲��ά��-"+Desc,
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="dhcpeedillness.hisui.csp?selectrow='+RowId+'+" width="100%" height="99%" ></iframe>'
		});	
		*/
		lnk="dhcpeedillness.hisui.csp"+"?selectrow="+RowId;	
		websys_lu(lnk,false,'width=870,height=600,hisui=true,title=Ŀ�꼲��ά��-'+Desc);
	}
}

//�������
function ENCheckCycle_click() {
	
	var record = $("#EndangerGrid").datagrid("getSelected"); 
	
	if (!(record)) {
		$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
		return;
	} else {  
		var RowId=record.TID
		var Desc=record.TDesc
		/*
		$("#myWinIllness").show();  
		var myWinGuideImage = $HUI.window("#myWinIllness",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			iconCls:'icon-w-paper',
			title:"�������ά��-"+Desc,
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="dhcpeedcheckcycle.hisui.csp?selectrow='+RowId+'+" width="100%" height="99%" ></iframe>'
		
		});	
		*/
		lnk="dhcpeedcheckcycle.hisui.csp"+"?selectrow="+RowId;	
		websys_lu(lnk,false,'width=927,height=600,hisui=true,title=�������ά��-'+Desc);
	}
}

// ��ϱ�׼
function ENCriteria_click() {
	var record = $("#EndangerGrid").datagrid("getSelected"); 
	
	if (!(record)) {
		$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
		return;
	} else {  
		var RowId=record.TID
		var Desc=record.TDesc
		/*
		$("#myWinIllness").show();  
		var myWinGuideImage = $HUI.window("#myWinIllness",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			iconCls:'icon-w-paper',
			title:"�������ά��-"+Desc,
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="dhcpeedcheckcycle.hisui.csp?selectrow='+RowId+'+" width="100%" height="99%" ></iframe>'
		
		});	
		*/
		lnk="dhcpeedcheckcriteria.hisui.csp"+"?selectrow="+RowId;	
		websys_lu(lnk,false,'width=927,height=600,hisui=true,title=��ϱ�׼ά��-'+Desc);
	}
}

// �����Ŀ
function ENItem_click(){
	var record = $("#EndangerGrid").datagrid("getSelected"); 
	
	if (!(record)) {
		$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
		return;
	} else {  
		var RowId=record.TID
		var Desc=record.TDesc
		/*
		$("#myWinEDItem").show();  
		var myWinGuideImage = $HUI.window("#myWinEDItem",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			iconCls:'icon-w-paper',
			title:"�����Ŀά��-"+Desc,
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="dhcpeeditem.hisui.csp?selectrow='+RowId+'+" width="100%" height="99%" ></iframe>'
		});	
		*/
		lnk="dhcpe.ct.endangeritem.csp"+"?selectrow="+RowId;
		websys_lu(lnk,false,'width=1355,height=600,hisui=true,title=�����Ŀά��-'+Desc);
	}
}

//����
function BENAdd_click(){
	BENSave_click("0");
}

//�޸�
function BENUpdate_click(){
	BENSave_click("1");
}

function BENSave_click(Type) {
	if(Type=="1"){
		var ID=$("#ENID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if($("#ENID").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
	}
	
	var ENCode=$("#ENCode").val();
	if (""==ENCode) {
		$("#ENCode").focus();
		var valbox = $HUI.validatebox("#ENCode", {
			required: true,
	    });
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	var ENDesc=$("#ENDesc").val();
	if (""==ENDesc) {
		$("#ENDesc").focus();
		var valbox = $HUI.validatebox("#ENDesc", {
			required: true,
	    });
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	
	var ENExpInfo=$("#ENExpInfo").val();
	var ENRemark=$("#ENRemark").val();
	var ID=$("#ENID").val();
	
	var iENActive="N";
	var ENActive=$("#ENActive").checkbox('getValue');
	if(ENActive) iENActive="Y";
	
	var EDTypeDR=$("#ID").val();
	var Str=ENCode+"^"+ENDesc+"^"+iENActive+"^"+EDTypeDR+"^"+ENExpInfo+"^"+ENRemark;

	var rtn=tkMakeServerCall("web.DHCPE.Endanger","UpdateEndanger",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		if(rtn.split("^")[1].indexOf("Code")>0){
			$.messager.alert("��ʾ","���벻Ψһ","error");
		}
		if(rtn.split("^")[1].indexOf("Desc")>0){
			$.messager.alert("��ʾ","������Ψһ","error");
		}	
		
	}else{
		BENClear_click();
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		
	}
}

//����
function BENClear_click(){
	$("#ENID,#ENCode,#ENDesc,#ENExpInfo,#ENRemark").val("");
	$("#ENActive").checkbox('setValue',true);
	var valbox = $HUI.validatebox("#ENCode,#ENDesc", {
			required: false,
	});
	
	$("#EndangerGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEndanger",
			EDEDTypeDR:$('#ID').val(),
	});
}

function LoadEndangerList(rowData) {
	if(rowData!="") $('#ID').val(rowData.TID);
	$("#ENID,#ENCode,#ENDesc,#ENExpInfo,#ENRemark").val("");
	$('#EndangerGrid').datagrid('load', {
		ClassName:"web.DHCPE.Endanger",
		QueryName:"SearchEndanger",
		EDEDTypeDR:$('#ID').val(),
	});
}

function InitEndangerGrid(){
	$HUI.datagrid("#EndangerGrid",{
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
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEndanger",
			
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:100,title:'����'},
			{field:'TDesc',width:200,title:'����'},
			{field:'TActive',width:40,title:'����'},
			{field:'TExpInfo',width:150,title:'��չ��Ϣ'},
			{field:'TRemark',width:150,title:'��ע'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
			$("#ENID").val(rowData.TID);
			$("#ENDesc").val(rowData.TDesc);
			$("#ENCode").val(rowData.TCode);
			$("#ENExpInfo").val(rowData.TExpInfo);
			$("#ENRemark").val(rowData.TRemark);
			if(rowData.TActive=="��"){
				$("#ENActive").checkbox('setValue',false);
			}if(rowData.TActive=="��"){
				$("#ENActive").checkbox('setValue',true);
			};
		}
	})
}