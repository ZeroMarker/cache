var locGroupObj=new Object();
$(function(){ 
	loadTable()
	$('#locTypeSelect').combobox({
		onSelect: function(record){
			if (record.value=="I")
			{
				$("#relationLocTd").css("visibility","hidden");
				$("#DocHeadHiddenTr").css("visibility","visible");
				$("#DocHeadHiddenDIV").css("visibility","visible");
				$("#linkLocShowDiv").css("display","none");
			}else
			{
				$("#relationLocTd").css("visibility","visible");
				$("#DocHeadHiddenTr").css("visibility","hidden");
				$("#DocHeadHiddenDIV").css("visibility","hidden");
				$("#linkLocShowDiv").css("display","");
			}
		}
	});
	$('input:file').change(function(){ 
		$("#showFile").val($("#fileOpen").val()) 
    	
	});  
	$("#DocHeadFlagY").attr("checked","checked");
	formClearLocGroupSub();
})
function loadTable()
{
	var bodyHeight=document.body.clientHeight;
	var tabTopHeight1=parseInt($("#locGroupTable").position().top);
	var tabHeight1=bodyHeight-tabTopHeight1-1;
	var tabFuWisth1=$("#locGroupTable").parent().width();

	$('#locGroupTable').datagrid({  
		height:tabHeight1,
		pagination:true,  
		singleSelect:true, 
	    url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.LocGroup&MethodName=qureyLocGroup',    
	    columns:[[    
	        {field:'LocGroupID',hidden:true},    
	        {field:'LocGroupCode',title:'���������',width:parseInt(0.3*tabFuWisth1)-1},    
	        {field:'LocGroupDesc',title:'����������',width:parseInt(0.3*tabFuWisth1)-1},
	        {field:'DocHeadDesc',title:'�������',width:parseInt(0.4*tabFuWisth1)-1}    
	    ]],
	   	onClickRow:function(rowIndex, rowData){
			locGroupRowClick(rowIndex, rowData);
		}, 
		onDblClickRow:function(rowIndex, rowData)
		{
			locGroupRowDblClick(rowIndex, rowData);
		}
	}); 
	
	var tabTopHeight2=parseInt($("#locGroupSubTable").position().top);
	var tabHeight2=bodyHeight-tabTopHeight2-1;
	var tabFuWisth2=$("#locGroupSubTable").parent().width();
	$('#locGroupSubTable').datagrid({  
		height:tabHeight2,
		pagination:true,
		singleSelect:true,  
	    url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.LocGroupSub&MethodName=qureyLocGroupSub',    
	    columns:[[    
	        {field:'LocGroupLocID',hidden:true},   
	        {field:'rowID',title:'������ID',width:parseInt(0.1*tabFuWisth2)-1},  
	        {field:'LocGroupLocDesc',title:'��������',width:parseInt(0.3*tabFuWisth2)-1},           
	        {field:'LocGroupTypeDesc',title:'������������',width:parseInt(0.2*tabFuWisth2)-1}, 
	        {field:'DocHeadDesc',title:'��������',width:parseInt(0.2*tabFuWisth2)-1},
	        {field:'LocGroupRelationLocDesc',title:'��������',width:parseInt(0.2*tabFuWisth2)-1}    
	    ]],
	   	onClickRow:function(rowIndex, rowData){
			locGroupRowSubClick(rowIndex, rowData);
		}	
	}); 
}
//���������
function saveLocGroup(){
	if($("#locGroupCode").val()==""){
		$.messager.alert('��ʾ','����дCODE');
		return;
	}else if($("#locGroupDesc").val()==""){
		$.messager.alert('��ʾ','����д����');
		return;
	}
	var ID=$("#locGroupID").val();
	if (ID==0) ID="";
	var str="";
	str=str+ID+"^";
	str=str+$("#locGroupCode").val()+"^";
	str=str+$("#locGroupDesc").val()+"^";
	str=str+locGroupObj.DocHeadStr+"^";

	runClassMethod("DtPortal.Configure.LocGroup","updateLocDoc",
					{'aInput':str,'aSeparate':'^'},
					function(data){										
						if(data>0){
		       				formClearLocGroup();
						}else if(data==0){
							$.messager.alert("��ʾ","�������Ѵ���,�����ظ�����!"); 
						}else{	
							$.messager.alert('��ʾ','����ʧ��:'+data)
				
						} 
					 });

	
}

//�����������Ŀ
function saveLocGroupSub(){
	if ($("#locSelect").combobox('getText')=="") $("#locSelect").combobox('setValue',"")
	if ($("#locTypeSelect").combobox('getText')=="") $("#locTypeSelect").combobox('setValue',"")
	if ($("#relationLoc").combobox('getText')=="") $("#relationLoc").combobox('setValue',"")
	if(locGroupObj.locGroupID==undefined)
	{
		$.messager.alert('��ʾ','��ѡ����߿�����');
		return;
	}
	else if($('#locSelect').combobox('getValue')==""){
		$.messager.alert('��ʾ','��ѡ�����');
		return;
	}else if($("#locTypeSelect").val()==""){
		$.messager.alert('��ʾ','��ѡ���������');
		return;
	}
	var rowID=locGroupObj.locGroupID;;
	var rowSubID=$("#locGroupSubID").val();
	var docHeadID=$("#docHeadSelect").combobox('getValue');
	if (($("#docHeadSelect").combobox('getText')=="")||($("#locTypeSelect").combobox('getValue')!="I")) docHeadID=""
	var str="";
	str=str+rowID+"^";
	str=str+rowSubID+"^";
	str=str+$('#locSelect').combobox('getValue')+"^";
	str=str+$("#locTypeSelect").combobox('getValue')+"^";
	str=str+locGroupObj.linkLocStr+"^";
	str=str+locGroupObj.subDocHeadStr+"^";
	runClassMethod("DtPortal.Configure.LocGroupSub","updateLocDoc",
					{'aInput':str,'aSeparate':'^'},
					function(data){ 
											
						if(data>0){		       				
	       				 $("#locGroupSubTable").datagrid('load');
	       				 formClearLocGroupSub();
						}else if(arrry[0]==0){
							$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
						}else{	
							$.messager.alert('��ʾ','����ʧ��:'+data)
				
						} 
	});
	
}

//ѡ������������
function addDocHead(){
	if ($("#bigDocHeadSelect").combobox('getText')=="") $("#bigDocHeadSelect").combobox('setValue',"")
	if($('#bigDocHeadSelect').combobox('getValue')==""){
		$.messager.alert('��ʾ','ѡ��������');
		return;
	}
	if($('#bigDocHeadSelect').combobox('getValue')==$("#bigDocHeadSelect").combobox('getText')){
		$.messager.alert('��ʾ','ѡ��������');
		return;
	}
	var str=$('#bigDocHeadSelect').combobox('getText');
	var docID=$('#bigDocHeadSelect').combobox('getValue');
	if (docID=="")
	{
		$.messager.alert('��ʾ','ѡ��������');
		return;
	} 
	var docFalg=$("input[name='DocFlag']:checked").val();
	var docStr=docID+"*"+docFalg
	if ((locGroupObj.DocIDStr!="")&&(locGroupObj.DocIDStr!=undefined))
	{
		
		if(locGroupObj.DocIDStr.indexOf("|")>0)
		{
			var docIDArry=locGroupObj.DocIDStr.split("|");
			if(docIDArry.indexOf(docID)>=0)
			{
				$.messager.alert('��ʾ','���û��Ѵ���');
				return;
			}
		}else
		{			
			if(locGroupObj.DocIDStr==docID)
			{
				$.messager.alert('��ʾ','���û��Ѵ���');
				return;
			}
		}
		
	}
	var StrAarry=str.split("(");
	$("#DocHeadHtml").append("<div id='DocID"+docID+"' class='con'><a onclick='deleteDocHead("+docID+")'><div class='addHongcha'></div><div class='name'>"+StrAarry[0]+"</div></a><div>");	
	if ((locGroupObj.DocHeadStr=="")||(locGroupObj.DocHeadStr==undefined))
	{
		locGroupObj.DocIDStr=docID;
		locGroupObj.DocHeadStr=docStr;
	}else
	{
		locGroupObj.DocIDStr=locGroupObj.DocIDStr+"|"+docID;
		locGroupObj.DocHeadStr=locGroupObj.DocHeadStr+"|"+docStr;
	}
	$("#bigDocHeadSelect").combogrid('setText',"").combogrid('setValue',"");
}

//ѡ��������ɾ��
function deleteDocHead(docID){
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ�����û���',function(r){    
	    if (r){
		   $("#DocID"+docID).remove();
		   var DocStr="";
		   var DocHeadStr=""
		   if(locGroupObj.DocIDStr.indexOf("|")>0)
			{
			   var DocIDStrArry=locGroupObj.DocIDStr.split("|");
			   var DocHeadStrArry=locGroupObj.DocHeadStr.split("|");
			   var index = getIndexOfAaary(DocIDStrArry,docID);
			   if (index == -1) {  
				 return;
			   }			   
			   for (var i=0;i<DocHeadStrArry.length;i++)
			   {
				   if (i==index) continue
				   if (DocHeadStrArry[i]!="")
				   {
					   if (DocHeadStr=="")
					   {
							DocHeadStr=DocHeadStrArry[i];
					   }else
					   {
						   DocHeadStr=DocHeadStr+"|"+DocHeadStrArry[i];
					   }
					   
					   if (DocStr=="")
					   {
							DocStr=DocIDStrArry[i];
					   }else
					   {
						   DocStr=DocStr+"|"+DocIDStrArry[i];
					   }
					}
			   }
			}else
			{			
				if(locGroupObj.DocIDStr==docID)
				{
					DocStr="";
					DocHeadStr="";
				}
			}

		   locGroupObj.DocIDStr=DocStr;
		   locGroupObj.DocHeadStr=DocHeadStr;
			
		}
		
	})
}

//ѡ������������
function addSubDocHead(){
	if ($("#docHeadSelect").combobox('getText')=="") $("#docHeadSelect").combobox('setValue',"")
	if($('#docHeadSelect').combobox('getValue')==""){
		$.messager.alert('��ʾ','ѡ��������');
		return;
	}
	if($('#docHeadSelect').combobox('getValue')==$("#docHeadSelect").combobox('getText')){
		$.messager.alert('��ʾ','ѡ��������');
		return;
	}
	var str=$('#docHeadSelect').combobox('getText');
	var docID=$('#docHeadSelect').combobox('getValue');
	if (docID=="")
	{
		$.messager.alert('��ʾ','ѡ��������');
		return;
	} 

	var docFalg=$("input[name='subDocFlag']:checked").val();
	var docStr=docID+"*"+docFalg
	if ((locGroupObj.subDocIDStr!="")&&(locGroupObj.subDocIDStr!=undefined))
	{
		
		if(locGroupObj.subDocIDStr.indexOf("|")>0)
		{
			var docIDArry=locGroupObj.subDocIDStr.split("|");
			if(docIDArry.indexOf(docID)>=0)
			{
				$.messager.alert('��ʾ','���û��Ѵ���');
				return;
			}
		}else
		{			
			if(locGroupObj.subDocIDStr==docID)
			{
				$.messager.alert('��ʾ','���û��Ѵ���');
				return;
			}
		}
		
	}
	var StrAarry=str.split("(");
	$("#subDocHeadHtml").append("<div id='subDocID"+docID+"' class='con'><a onclick='deleteSubDocHead("+docID+")'><div class='addHongcha'></div><div class='name'>"+StrAarry[0]+"</div></a><div>");	
	if ((locGroupObj.subDocHeadStr=="")||(locGroupObj.subDocHeadStr==undefined))
	{
		locGroupObj.subDocIDStr=docID;
		locGroupObj.subDocHeadStr=docStr;
	}else
	{
		locGroupObj.subDocIDStr=locGroupObj.subDocIDStr+"|"+docID;
		locGroupObj.subDocHeadStr=locGroupObj.subDocHeadStr+"|"+docStr;
	}
	$("#docHeadSelect").combogrid('setText',"").combogrid('setValue',"");
}

//ѡ��������ɾ��
function deleteSubDocHead(docID){
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ�����û���',function(r){    
	    if (r){
		   $("#subDocID"+docID).remove();
		   
		   var DocStr="";
		   var DocHeadStr=""
		   if(locGroupObj.subDocIDStr.indexOf("|")>0)
			{
			   var subDocIDStrArry=locGroupObj.subDocIDStr.split("|");
			   var subDocHeadStrArry=locGroupObj.subDocHeadStr.split("|");
			   var index = getIndexOfAaary(subDocIDStrArry,docID);
			   if (index == -1) {  
				 return;
			   }			   
			   for (var i=0;i<subDocHeadStrArry.length;i++)
			   {
				   if (i==index) continue
				   if (subDocHeadStrArry[i]!="")
				   {
					   if (DocHeadStr=="")
					   {
							DocHeadStr=subDocHeadStrArry[i];
					   }else
					   {
						   DocHeadStr=DocHeadStr+"|"+subDocHeadStrArry[i];
					   }
					   
					   if (DocStr=="")
					   {
							DocStr=subDocIDStrArry[i];
					   }else
					   {
						   DocStr=DocStr+"|"+subDocIDStrArry[i];
					   }
					}
			   }
			}else
			{			
				if(locGroupObj.subDocIDStr==docID)
				{
					DocStr="";
					DocHeadStr="";
				}
			}

		   locGroupObj.subDocIDStr=DocStr;
		   locGroupObj.subDocHeadStr=DocHeadStr;
		   
			
		}
		
	})
}


//ѡ�������������
function addLinLoc(){
	if ($("#relationLoc").combobox('getText')=="") $("#relationLoc").combobox('setValue',"")
	if($('#relationLoc').combobox('getValue')==""){
		$.messager.alert('��ʾ','ѡ���������');
		return;
	}
	if($('#relationLoc').combobox('getValue')==$("#relationLoc").combobox('getText')){
		$.messager.alert('��ʾ','ѡ���������');
		return;
	}
	var locDesc=$('#relationLoc').combobox('getText');
	var LocID=$('#relationLoc').combobox('getValue');


	if ((locGroupObj.linkLocStr!="")&&(locGroupObj.linkLocStr!=undefined))
	{
		if(locGroupObj.linkLocStr.indexOf("*")>0)
		{
			var LocIDArry=locGroupObj.linkLocDescStr.split("*");
			if(LocIDArry.indexOf(locDesc)>=0)
			{
				$.messager.alert('��ʾ','�ù��������Ѵ���');
				return;
			}
		}else
		{			
			if(locGroupObj.linkLocDescStr==locDesc)
			{
				$.messager.alert('��ʾ','�ù��������Ѵ���');
				return;
			}
		}
		
	}
	if ((locGroupObj.linkLocStr=="")||(locGroupObj.linkLocStr==undefined))
	{
		locGroupObj.linkLocStr=LocID;
		locGroupObj.linkLocDescStr=locDesc;
	}else
	{
		locGroupObj.linkLocStr=locGroupObj.linkLocStr+"*"+LocID;
		locGroupObj.linkLocDescStr=locGroupObj.linkLocDescStr+"*"+locDesc;
	}
	var locID2=LocID.replace("||", "_");
	$("#linkLocHtml").append("<div id='linkLocID"+locID2+"' class='con'><a onclick='deleteLinLoc(\""+LocID+"\")'><div class='addHongcha'></div><div class='name'>"+locDesc+"</div></a><div>");	
	//$("#relationLoc").combogrid('setText',"").combogrid('setValue',"");
}

//ѡ���������ɾ��
function deleteLinLoc(LocID){
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ���ù���������',function(r){    
	    if (r){
		   var locID2=LocID.replace("||", "_");
		   $("#linkLocID"+locID2).remove();
		   var LocIDStr="";
		   var LocDescStr=""
		   if(locGroupObj.linkLocStr.indexOf("*")>0)
			{
			   var LocIdArry=locGroupObj.linkLocStr.split("*");
			   var LocDescArry=locGroupObj.linkLocStr.split("*");
			   var index = getIndexOfAaary(LocIdArry,LocID);
			   if (index == -1) {  
				 return;
			   }			   
			   for (var i=0;i<LocIdArry.length;i++)
			   {
				   if (i==index) continue
				   if (LocIdArry[i]!="")
				   {
					   if (LocIDStr=="")
					   {
							LocIDStr=LocIdArry[i];
					   }else
					   {
						   LocIDStr=LocIDStr+"*"+LocIdArry[i];
					   }
					   
					   if (LocDescStr=="")
					   {
							LocDescStr=LocDescArry[i];
					   }else
					   {
						   LocDescStr=LocDescStr+"*"+LocDescArry[i];
					   }
					 				
					}
			   }
			}else
			{			
				if(locGroupObj.linkLocStr==LocID)
				{
					LocIDStr="";
					LocDescStr="";
				}
			}
		   locGroupObj.linkLocStr=LocIDStr;
		   locGroupObj.linkLocStr=LocDescStr;
		}
		
	})
}
//ɾ��������ά��
function deleteLocGroup()
{
	if ($("#locGroupTable").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#locGroupTable").datagrid('getSelected');     
		 runClassMethod("DtPortal.Configure.LocGroup","DeleteById",{'ID':row.LocGroupID},function(data){ 
		    	formClearLocGroup();
		      })
         	 
    }    
    }); 
}

//ɾ����������Ŀ
function deleteLocGroupSub()
{
	if(locGroupObj.locGroupID==undefined)
	{
		$.messager.alert('��ʾ','��ѡ����߿�����');
		return;
	}else if($("#locGroupSubTable").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#locGroupSubTable").datagrid('getSelected'); 
	    var ID=locGroupObj.locGroupID+"||"+row.rowSubID;
		runClassMethod("DtPortal.Configure.LocGroupSub","DeleteById",{'ID':ID},function(data){ 
		    	formClearLocGroupSub();
		      })
         	 
    }    
    }); 
}
//��տ�����ά��
function formClearLocGroup()
{
	$('#locGroupForm').form('clear');
	locGroupObj.DocHeadStr="";
	locGroupObj.DocIDStr=""
	$("#DocHeadHtml").html("");
	$("input[name='DocFlag'][value=Y]").attr("checked",true); 
	$("#locGroupTable").datagrid('load');
	$("#linkLocShowDiv").css("display","none");
}

//��տ�������Ŀά��
function formClearLocGroupSub()
{	
	$('#locGroupSubForm').form('clear');
	locGroupObj.subDocHeadStr="";
	locGroupObj.subDocIDStr=""
	$("#subDocHeadHtml").html("");
	$("input[name='subDocFlag'][value=Y]").attr("checked",true); 
	$("#DocHeadHiddenTr").css("visibility","visible");
	$("#DocHeadHiddenDIV").css("visibility","visible");
	$("#linkLocShowDiv").css("display","none");
	$("#locGroupSubTable").datagrid('load');
}


//�������񵥻��¼�,��form��ֵ
function locGroupRowClick(rowIndex,rowData)
{
	locGroupObj.DocHeadStr="";
	locGroupObj.DocIDStr=""
	$("#DocHeadHtml").html("");
	$("#linkLocShowDiv").css("display","none");
	$("#locGroupID").val(rowData.LocGroupID);
	$("#locGroupCode").val(rowData.LocGroupCode);
	$("#locGroupDesc").val(rowData.LocGroupDesc);
	
	var DocHeadIDStr=rowData.DocHeadIDStr;
	var DocNameStr=rowData.DocNameStr;
	var DocFlagStr=rowData.DocFlagStr;
	
	var DocHeadIDArray=DocHeadIDStr.split("^");
	var DocHeadNameArray=DocNameStr.split("^");
	var DocHeadFlagArray=DocFlagStr.split("^");

	for (i=0;i<DocHeadIDArray.length;i++)
	{
		if (DocHeadIDArray[i]=="") continue
		var docStr=DocHeadIDArray[i]+"*"+DocHeadFlagArray[i]
		if ((locGroupObj.DocHeadStr=="")||(locGroupObj.DocHeadStr==undefined))
		{
			locGroupObj.DocIDStr=DocHeadIDArray[i];
			locGroupObj.DocHeadStr=docStr;
		}else
		{
			locGroupObj.DocIDStr=locGroupObj.DocIDStr+"|"+DocHeadIDArray[i];
			locGroupObj.DocHeadStr=locGroupObj.DocHeadStr+"|"+docStr;
		}

		$("#DocHeadHtml").append("<div id='DocID"+DocHeadIDArray[i]+"' class='con'><a onclick='deleteDocHead("+DocHeadIDArray[i]+")'><div class='addHongcha'></div><div class='name'>"+DocHeadNameArray[i]+"</div></a><div>");	
	}

	
}

//��������Ŀ��񵥻��¼�,��form��ֵ
function locGroupRowSubClick(rowIndex, rowData)
{
	locGroupObj.subDocHeadStr="";
	locGroupObj.subDocIDStr="";
	locGroupObj.linkLocDescStr="";
	locGroupObj.linkLocStr="";
	$("#subDocHeadHtml").html("");
	$("#linkLocHtml").html("");
	
	if (rowData.LocGroupType=="I")
	{
		
		$("#relationLocTd").css("visibility","hidden");	
		$("#DocHeadHiddenTr").css("display","");
		$("#linkLocShowDiv").css("display","none");
		$("#DocHeadHiddenDIV").css("visibility","visible");
		var DocHeadIDStr=rowData.DocHeadIDStr;
		var DocNameStr=rowData.DocNameStr;
		var DocFlagStr=rowData.DocFlagStr;
		
		var DocHeadIDArray=DocHeadIDStr.split("^");
		var DocHeadNameArray=DocNameStr.split("^");
		var DocHeadFlagArray=DocFlagStr.split("^");
		
		
		for (i=0;i<DocHeadIDArray.length;i++)
		{
			if (DocHeadIDArray[i]=="") continue
			var docStr=DocHeadIDArray[i]+"*"+DocHeadFlagArray[i]
			if ((locGroupObj.subDocHeadStr=="")||(locGroupObj.subDocHeadStr==undefined))
			{
				locGroupObj.subDocIDStr=DocHeadIDArray[i];
				locGroupObj.subDocHeadStr=docStr;
			}else
			{
				locGroupObj.subDocIDStr=locGroupObj.subDocIDStr+"|"+DocHeadIDArray[i];
				locGroupObj.subDocHeadStr=locGroupObj.subDocHeadStr+"|"+docStr;
			}

			$("#subDocHeadHtml").append("<div id='linkLocID"+DocHeadIDArray[i]+"' class='con'><a onclick='deleteSubDocHead("+DocHeadIDArray[i]+")'><div class='addHongcha'></div><div class='name'>"+DocHeadNameArray[i]+"</div></a><div>");	
		}
	}else
	{
		var LocGroupRelationLocID=rowData.LocGroupRelationLocID;
		var LocGroupRelationLocDesc=rowData.linLocDesc;
		var linkLocStr=LocGroupRelationLocID.split("^");
		var linkLocStrStr=LocGroupRelationLocDesc.split("^");
		for (i=0;i<linkLocStr.length;i++)
		{
			if (linkLocStr[i]=="") continue
			var locID=linkLocStr[i];
			var locDesc=linkLocStrStr[i];
			if ((locGroupObj.linkLocStr=="")||(locGroupObj.linkLocStr==undefined))
			{
				locGroupObj.linkLocStr=locID;
				locGroupObj.linkLocDescStr=locDesc;
			}else
			{
				locGroupObj.linkLocStr=locGroupObj.linkLocStr+"*"+locID;
				locGroupObj.linkLocDescStr=locGroupObj.linkLocDescStr+"*"+locDesc;
			}
			var locID2=locID.replace("||", "_");
			$("#linkLocHtml").append("<div id='linkLocID"+locID2+"' class='con'><a onclick='deleteLinLoc(\""+locID+"\")'><div class='addHongcha'></div><div class='name'>"+locDesc+"</div></a><div>");	
		}
		$("#relationLocTd").css("visibility","visible");
		$("#linkLocShowDiv").css("display","");
		$("#DocHeadHiddenTr").css("display","none");
		$("#DocHeadHiddenDIV").css("visibility","hidden");
		
	}

	$("#locSelect").combobox('setValue',rowData.LocGroupLocID).combobox('setText', rowData.LocGroupLocDesc);
	//$("#locSelect").combobox('setValue', rowData.LocGroupLocID).combobox('setText', rowData.LocGroupLocDesc);
	$("#locTypeSelect").combobox('setValue',rowData.LocGroupType).combobox('setText', rowData.LocGroupTypeDesc);
	$("#locGroupSubID").val(rowData.rowSubID);
	$("#docHeadSelect").combobox('setValue', rowData.DcoHeadUserID).combobox('setText', rowData.DcoHeadName);


}

//��������˫���¼�,������ɫ���ô���
function locGroupRowDblClick(rowIndex,rowData)
{
	
	$("#DocHeadHiddenTd").css("visibility","visible");
	locGroupObj.locGroupID=rowData.LocGroupID;
	locGroupObj.locGroupCode=rowData.LocGroupCode;
	locGroupObj.locGroupDesc=rowData.LocGroupDesc;
	$("#locGroupSpan").html(rowData.LocGroupDesc);
	runClassMethod("DtPortal.Configure.DocHead","GetNameByLocGroupID",
					{'LocGroupID':rowData.LocGroupID},
					function(data){ 
						if(data==0){		       				
	       					 $("#bigDocHeadSpan").html("__ __");
						}else
						{
							$("#bigDocHeadSpan").html(data);
						}
	});
	formClearLocGroupSub();
	$('#locGroupSubTable').datagrid({  
		url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.LocGroupSub&MethodName=qureyLocGroupSub&locGroupID='+rowData.LocGroupID
	});
	$('#relationLoc').combobox('reload','dhcapp.broker.csp?ClassName=DtPortal.Configure.LocGroupSub&MethodName=qureyLocGroupSubI&locGroupID='+rowData.LocGroupID);
}

//��ȡ������Ԫ�ص��±�(indexof��������)
function getIndexOfAaary(arry,str)
{
	var ret=-1
	for (var i=0;i<arry.length;i++)
	{
		if (arry[i]==str) ret=i;
	}
	return ret
}

function findLocGroup()
{  
	var code=$("#locGroupCode").val();
	var desc=$("#locGroupDesc").val();
	var docHead=$('#bigDocHeadSelect').combobox('getValue')
    $('#locGroupTable').datagrid('load', {    
   		code: code,
   		desc: desc,
   		docHead: docHead    	 
	});   
}
function openInDataView()
{
	$('#detail').dialog('open');
	$('#detail').dialog('move',{
				left:280,
				top:180
	});
}
function inLocGroupData(){          
          var ie = !-[1,];   
        if(ie){  
            $('input:file').trigger('click').trigger('change');  
        }else{  
            $('input:file').trigger('click');  
        }  
        
          
} 
