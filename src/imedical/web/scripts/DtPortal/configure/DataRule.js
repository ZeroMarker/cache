var DataRuleObj=new Object();
FileReader.prototype.readAsBinaryString = function (fileData) {
	var binary = "";
	var pt = this;
	var reader = new FileReader();
	reader.onload = function (e) {
	    var bytes = new Uint8Array(reader.result);
	    var length = bytes.byteLength;
	    for (var i = 0; i < length; i++) {
	        binary += String.fromCharCode(bytes[i]);
	    }
	    pt.content = binary;
	    pt.onload(pt); //ҳ����dataȡpt.content�ļ�����
	  }
	  reader.readAsArrayBuffer(fileData);
}
$(function(){ 
	loadTable7()
	DataRuleObj.ID=""; 
	DataRuleObj.code=""; 
	DataRuleObj.desc=""; 
	DataRuleObj.type=""; 
	DataRuleObj.typeDesc=""; 
	DataRuleObj.valueType="1"; 
	DataRuleObj.valueTypeDesc=""; 
	DataRuleObj.value=""; 
	DataRuleObj.valueDesc="";
	DataRuleObj.Remarks="";
	DataRuleObj.optionValueStr="";
	DataRuleObj.optionValueDescStr="";
	$('#valueType').combobox({
		onSelect: function(record){
			$("#value").val("");
			$("#valueDesc").val("");
			DataRuleObj.valueType=record.value;
			if (record.value=="1")
			{
				$("#optionAdd").hide();
				$("#optionDelete").hide();
				$("#optionValue").html("����ֵ:");
				$("#optionValueDesc").html("ֵ����:");
				
			}else
			{
				$("#optionAdd").show();
				$("#optionDelete").show();
				$("#optionValue").html("ѡ��ֵ:");
				$("#optionValueDesc").html("ѡ������:");
				$("#optionShow").html("");
				DataRuleObj.optionValueStr="";
				DataRuleObj.optionValueDescStr="";
			}
		}
	});
	
	$('#type').combobox({
		onChange: function(record){
			find();
		}
		
	});
	$('#selectRole').combobox({
		onChange: function(record){
			find();
		}
		
	});
	
	runClassMethod("DtPortal.Configure.DataRule","qureyRole",
		{},
		function(data){	
			var html='';
			for (var i=0;i<data.length;i++)
			{
				html+='<div style="float:left;padding:0 5px 0 5px" id=\'Role'+data[i].RoleDesc+'\'><input type=\'checkbox\'  name=\'roleCheck\' value=\''+data[i].RoleDesc+'\' />'+data[i].RoleDesc+'</input></div>';
			}		
			$("#role").html(html)
		 });
	 
})
function loadTable7()
{
	var bodyHeight=document.body.clientHeight;
	var tabTopHeight1=parseInt($("#DataRuleTable").position().top);
	var tabHeight1=bodyHeight-tabTopHeight1-1;
	var tabFuWisth1=$("#DataRuleTable").parent().width();
	$('#DataRuleTable').datagrid({  
		height:tabHeight1,
		pagination:true,  
		singleSelect:true, 
		pageList:[10,15,20,30,40,50],
		pageSize:15,
	    url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.DataRule&MethodName=qureyData',    
	    columns:[[    
	        {field:'ID',hidden:true},
	        {field:'code',title:'CODE',width:parseInt(0.15*tabFuWisth1)-1},    
	        {field:'desc',title:'����',width:parseInt(0.15*tabFuWisth1)-1},    
	        {field:'typeDesc',title:'����',width:parseInt(0.06*tabFuWisth1)-1},    
	        {field:'roleDesc',title:'��ɫ',width:parseInt(0.06*tabFuWisth1)-1},    
	        {field:'valueTypeDesc',title:'ֵ����',width:parseInt(0.05*tabFuWisth1)-1},    
	        {field:'value',title:'ֵ',width:parseInt(0.1*tabFuWisth1)-1},    
	        {field:'valueDesc',title:'ֵ����',width:parseInt(0.14*tabFuWisth1)-1},    
	        {field:'Remarks',title:'��ע',width:parseInt(0.35*tabFuWisth1)-1}
	         
	    ]],
	   	onClickRow:function(rowIndex, rowData){
		   	DataRuleObj.ID=rowData.ID;
			DataRuleObj.code=rowData.code; 
			DataRuleObj.desc=rowData.desc; 
			DataRuleObj.type=rowData.type; 
			DataRuleObj.typeDesc=rowData.typeDesc; 
			DataRuleObj.valueType=rowData.valueType; 
			DataRuleObj.valueTypeDesc=rowData.valueTypeDesc; 
			DataRuleObj.value=rowData.value; 
			DataRuleObj.valueDesc=rowData.valueDesc;
			DataRuleObj.Remarks=rowData.Remarks;
			DataRuleObj.optionValueStr=rowData.optionValue;
			DataRuleObj.optionValueDescStr=rowData.optionDesc;
			DataRuleObj.roleDesc=rowData.roleDesc;
		},
		onDblClickRow:function(rowIndex, rowData)
		{
			update();
		}
		
	}); 
}

//��ѯ��ť����¼�
function find()
{  
	var code=$("#code").val();
	var desc=$("#desc").val();
	var type=$('#type').combobox('getValue');
	var role=$('#selectRole').combobox('getValue');
    $('#DataRuleTable').datagrid('load', {   
    	code: code, 
   		desc: desc,
   		type: type,
   		role: role
   	 
	});   
}

//��������
function add()
{
	DataRuleObj.ID=""; 
	openDataAdd();
}

//�޸�����
function update()
{
	if (DataRuleObj.ID=="") 
	{
		$.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵ�����!');
		return;
	}
	openDataAdd();
	
}

//��Ŀ���Ӵ�
function openDataAdd()
{
	$('#dataAddDiv').dialog('open');
	$('#dataAddDiv').dialog('move',{
				left:240,
				top:80
	});
	$("#optionSave").hide();
	if (DataRuleObj.ID=="") 
	{
		formClear();
	}else
	{
		$("#optionAdd").hide();
	    $("#optionDelete").hide();
		$("#AddCode").val(DataRuleObj.code);
		$("#AddDesc").val(DataRuleObj.desc);
		$("#type2").combobox('setValue',DataRuleObj.type).combobox('setText',DataRuleObj.typeDesc);
		$("#valueType").combobox('setValue',DataRuleObj.valueType).combobox('setText',DataRuleObj.valueTypeDesc);
		$("#Remarks").val(DataRuleObj.Remarks);
		
		var html=""
		if (DataRuleObj.valueType==1)
		{
			$("#value").val(DataRuleObj.value);
			$("#valueDesc").val(DataRuleObj.valueDesc);
		}else
		{
			 $("#optionAdd").show();
			 $("#optionDelete").show();
			 if(DataRuleObj.optionValueStr.indexOf("#*")>0)
			{
			   var valueStrArry=DataRuleObj.optionValueStr.split("#*");
			   var valueDescStrArry=DataRuleObj.optionValueDescStr.split("#*");		   
			   for (var i=0;i<valueDescStrArry.length;i++)
			   {
				   if (DataRuleObj.valueType==2)
				   {
					   html+='<div style="float:left;padding:0 5px 0 5px" id=\'optionValueDiv'+valueStrArry[i]+'\' onclick="optionClick(this,\''+valueStrArry[i]+'\',\''+valueDescStrArry[i]+'\')"><input data-options=\'required:true\' type=\'radio\'  name=\'value2\' valueDesc=\''+valueDescStrArry[i]+'\' value=\''+valueStrArry[i]+'\'  class=\'easyui-textbox\'><span type="desc">'+valueDescStrArry[i]+'</span>(<span type="id">'+valueStrArry[i]+'</span>)</input></div>';
				   }else
				   {
					   html+='<div style="float:left;padding:0 5px 0 5px" id=\'optionValueDiv'+valueStrArry[i]+'\' onclick="optionClick(this,\''+valueStrArry[i]+'\',\' '+valueDescStrArry[i]+' \')"><input type=\'checkbox\'  name=\'value3\' value=\''+valueStrArry[i]+'\' valueDesc=\''+valueDescStrArry[i]+'\' /><span type="desc">'+valueDescStrArry[i]+'</span>(<span type="id">'+valueStrArry[i]+'</span>)</input></div>';
				   }
			   }
			}else
			{
			   if (DataRuleObj.valueType==2)
			   {
				   html+='<div style="float:left;padding:0 5px 0 5px" id=\'optionValueDiv'+DataRuleObj.optionValueStr+'\' onclick="optionClick(this,\''+DataRuleObj.optionValueStr+'\',\''+DataRuleObj.optionValueDescStr+'\')"><input data-options=\'required:true\' type=\'radio\'  name=\'value2\' value=\''+DataRuleObj.optionValueStr+'\' valueDesc=\''+DataRuleObj.optionValueDescStr+'\'  class=\'easyui-textbox\'><span type="desc">'+DataRuleObj.optionValueDescStr+'</span>(<span type="id">'+DataRuleObj.optionValueStr+'</span>)</input></div>';
			   }else
			   {
				   html+='<div style="float:left;padding:0 5px 0 5px" id=\'optionValueDiv'+DataRuleObj.optionValueStr+'\' onclick="optionClick(this,\''+DataRuleObj.optionValueStr+'\',\''+DataRuleObj.optionValueDescStr+'\')"><input type=\'checkbox\'  name=\'value3\' value=\''+DataRuleObj.optionValueStr+'\' valueDesc=\''+DataRuleObj.optionValueDescStr+'\' /><span type="desc">'+DataRuleObj.optionValueDescStr+'</span>(<span type="id">'+DataRuleObj.optionValueStr+'</span>)</input></div>';
			   }
			}
			$("#optionShow").html(html);
			var valueArry=DataRuleObj.value.split("^");
			for (var i=0;i<valueArry.length;i++)
			{
				$("#optionValueDiv"+valueArry[i]+" :radio").attr("checked","true");
				$("#optionValueDiv"+valueArry[i]+" :checkbox").attr("checked","true"); 
			}
			
		}
		
		var roleCodeArry=DataRuleObj.roleDesc.split("|");
		for (var i=0;i<roleCodeArry.length;i++)
		{
			$("#Role"+roleCodeArry[i]+" :checkbox").attr("checked","true"); 
		}
	}
	
	
}

//����ѡ��ֵ
function addOption()
{
	var value=$("#value").val();
	var valueDesc=$("#valueDesc").val();
	
	if ((valueDesc=="")||(valueDesc==undefined)) 
	{
		$.messager.alert('��ʾ','����дѡ��ֵ����!');
		return;
	}

	var name="value2";
	if (DataRuleObj.valueType==3)
    {
	   name="value3";
    }
    var errDesc="";
	$("[name='"+name+"']").each(function(){
		var v=$(this).val();
		var vD=$(this).attr("valueDesc");
		
		if (value==v)
		{
			errDesc="��ѡ��ֵ�Ѵ���";
		}
		if (vD==valueDesc)
		{
			errDesc="��ѡ�������Ѵ���";
		}	
	})
	if (errDesc!="") 
	{
		$.messager.alert('��ʾ',errDesc);
		return;
	}
	var html="";
	if (DataRuleObj.valueType==2)
	{
		html='<div style="float:left;padding:0 5px 0 5px" id=\'optionValueDiv'+value+'\' onclick="optionClick(this,\''+value+'\',\''+valueDesc+'\')"><input data-options=\'required:true\' type=\'radio\' checked  name=\'value2\' value=\''+value+'\' valueDesc=\''+valueDesc+'\'  class=\'easyui-textbox\'><span type="desc">'+valueDesc+'</span>(<span type="id">'+value+'</span>)</input></div>';
	}
	if (DataRuleObj.valueType==3)
	{
		html='<div style="float:left;padding:0 5px 0 5px" id=\'optionValueDiv'+value+'\' onclick="optionClick(this,\''+value+'\',\''+valueDesc+'\')"><input type=\'checkbox\' checked=\'true\'  name=\'value3\' value=\''+value+'\' valueDesc=\''+valueDesc+'\' /><span type="desc">'+valueDesc+'</span>(<span type="id">'+value+'</span>)</input></div>';
	}
	$("#value").val("");
	$("#valueDesc").val("");
	$("#optionShow").append(html);
}

//����ѡ��ֵ
function saveOption()
{
	var value=$("#value").val();
	var valueDesc=$("#valueDesc").val();
	
	if ((valueDesc=="")||(valueDesc==undefined)) 
	{
		$.messager.alert('��ʾ','����дѡ��ֵ����!');
		return;
	}
	
	var name="value2";
	if (DataRuleObj.valueType==3)
    {
	   name="value3";
    }
    var errDesc="";
	$("[name='"+name+"']").each(function(){
		var v=$(this).val();
		var vD=$(this).attr("valueDesc");
		if (v!=DataRuleObj.editOptionValue)
		{
			if (value==v)
			{
				errDesc="��ѡ��ֵ�Ѵ���";
			}
			if (vD==valueDesc)
			{
				errDesc="��ѡ�������Ѵ���";
			}
		}
		
	})
	if (errDesc!="") 
	{
		$.messager.alert('��ʾ',errDesc);
		return;
	}
	$("#optionValueDiv"+value).remove();
	var html="";
	if (DataRuleObj.valueType==2)
	{
		html='<div style="float:left;padding:0 5px 0 5px" id=\'optionValueDiv'+value+'\' onclick="optionClick(this,\''+value+'\',\''+valueDesc+'\')"><input data-options=\'required:true\' type=\'radio\' checked  name=\'value2\' value=\''+value+'\' valueDesc=\''+valueDesc+'\'  class=\'easyui-textbox\'><span type="desc">'+valueDesc+'</span>(<span type="id">'+value+'</span>)</input></div>';
	}
	if (DataRuleObj.valueType==3)
	{
		html='<div style="float:left;padding:0 5px 0 5px" id=\'optionValueDiv'+value+'\' onclick="optionClick(this,\''+value+'\',\''+valueDesc+'\')"><input type=\'checkbox\' checked=\'true\'  name=\'value3\' value=\''+value+'\' valueDesc=\''+valueDesc+'\' /><span type="desc">'+valueDesc+'</span>(<span type="id">'+value+'</span>)</input></div>';
	}
	$("#value").val("");
	$("#valueDesc").val("");
	$("#optionShow").append(html);
	$("#optionAdd").show();
	$("#optionSave").hide();
}
//�������¼�
function save(){
	var code=$("#AddCode").val();
	var desc=$("#AddDesc").val();
	var type=$('#type2').combobox('getValue');
	var valueType=$('#valueType').combobox('getValue');
	if(code==""){
		$.messager.alert('��ʾ','����д���ݹ���code');
		return;
	}
	if(desc==""){
		$.messager.alert('��ʾ','����д���ݹ�������');
		return;
	}
	if(valueType==""){
		$.messager.alert('��ʾ','��ѡ��ֵ����');
		return;
	}
	var value=""
	if (DataRuleObj.valueType==1)
	{
		value=$("#value").val();
		if(value==""){
			$.messager.alert('��ʾ','����д����ֵ!');
			return;
		}
		DataRuleObj.optionValueStr=value;
		DataRuleObj.optionValueDescStr=$("#valueDesc").val();
	}else if(DataRuleObj.valueType==2)
	{
		value=$("input[name='value2']:checked").val();
		if((value=="")||(value==undefined)){
			$.messager.alert('��ʾ','��ѡ������ֵ!');
			return;
		}
	}else
	{
		var arr = new Array();
		$('input[name="value3"]:checked').each(function(i){
			arr[i] = $(this).val();
		});
		value = arr.join("^");
		if((value=="")||(value==undefined)){
			$.messager.alert('��ʾ','��ѡ������ֵ!');
			return;
		}
	}
	
	//����ʹ�ý�ɫ
	var arrRole = new Array();
	$('input[name="roleCheck"]:checked').each(function(i){
		arrRole[i] = $(this).val();
	});
	var roleStr = arrRole.join("|");
	
		var name="value2";
	if (DataRuleObj.valueType==3)
    {
	   name="value3";
    }
    
    var optionValue="",optionValueDesc="";
	$("[name='"+name+"']").each(function(){
		var v=$(this).val();
		var vD=$(this).attr("valueDesc");
		if (optionValue=="")
		{
			optionValue=v;
			optionValueDesc=vD;
		}else
		{
			optionValue=optionValue+"#*"+v;
			optionValueDesc=optionValueDesc+"#*"+vD;
		}
		
	})
	
	var ID=DataRuleObj.ID;
	
	var str="";
	str=str+ID+"@$";
	str=str+code+"@$";
	str=str+desc+"@$";
	str=str+type+"@$";
	str=str+roleStr+"@$";
	str=str+valueType+"@$";
	str=str+value+"@$";
	str=str+$("#Remarks").val()+"@$";
	str=str+optionValue+"@$";
	str=str+optionValueDesc;

	runClassMethod("DtPortal.Configure.DataRule","Update",
		{'aInput':str,'aSeparate':'@$'},
		function(data){			
			if(data>0){
				$.messager.confirm('��ʾ','�ѱ���ɹ�,�ر�ҳ��?',function(r){    
	    			if (r){$('#dataAddDiv').dialog('close');}
				})
   				
			}else if(data==0){
				$.messager.alert("��ʾ","�����ظ�!"); 
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
	
			} 
		 });

	
}

//ѡ�����¼�
function optionClick(obj,optionValue,optionValueDesc)
{
	DataRuleObj.editOptionValue=optionValue;
	DataRuleObj.editOptionValueDesc=optionValueDesc;
	//$("#optionSave").show();
	//$("#optionAdd").hide();
	$("#value").val(optionValue);
	$("#valueDesc").val(optionValueDesc);
	
	$("#value").keyup(function(){
	var value=$("#value").val();
	$(obj).find("input").val(value);
	$(obj).find("[type='id']").html(value);
	})
	$("#valueDesc").keyup(function(){
	var valueDesc=$("#valueDesc").val();
	$(obj).find("input").attr("valueDesc",valueDesc);
	$(obj).find("[type='desc']").html(valueDesc);
	
	})
}
function deleteOption()
{
	var value=$("#value").val();
	var DivID="optionValueDiv"+value;
	if ($("#"+DivID).length <= 0)
	{
		$.messager.alert('��ʾ','��ѡ��Ҫɾ����ѡ��!');
		return;
	}
	
	$.messager.confirm('ȷ��','��ȷ����ɾ����ѡ����',function(r){    
	    if (r){
		   $("#optionValueDiv"+value).remove();
		   $("#optionSave").hide();
			$("#optionAdd").show();
		   var valueStr="";
		   var valueDescStr=""
		   if(DataRuleObj.optionValueStr.indexOf("#*")>0)
			{
			   var valueStrArry=DataRuleObj.optionValueStr.split("#*");
			   var valueDescStrArry=DataRuleObj.optionValueDescStr.split("#*");
			   var index = getIndexOfAaary(valueStrArry,value);
			   if (index == -1) {  
				 return;
			   }			   
			   for (var i=0;i<valueDescStrArry.length;i++)
			   {
				   if (i==index) continue
				   if (valueDescStrArry[i]!="")
				   {
					   if (valueDescStr=="")
					   {
							valueDescStr=valueDescStrArry[i];
					   }else
					   {
						   valueDescStr=valueDescStr+"#*"+valueDescStrArry[i];
					   }
					   
					   if (valueStr=="")
					   {
							valueStr=valueStrArry[i];
					   }else
					   {
						   valueStr=valueStr+"#*"+valueStrArry[i];
					   }
					}
			   }
			}else
			{			
				if(DataRuleObj.optionValueStr==value)
				{
					valueStr="";
					valueDescStr="";
				}
			}

		   DataRuleObj.optionValueStr=valueStr;
		   DataRuleObj.optionValueDescStr=valueDescStr;
		   $("#value").val("");
		   $("#valueDesc").val("");
		}
		
	})
	
}

//���
function formClear()
{
	$('#FormAdd').form('clear');
	DataRuleObj.ID="";
	$("#optionShow").html("");
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


//ɾ��
function deleteData()
{
	if ($("#DataRuleTable").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#DataRuleTable").datagrid('getSelected');     
		 runClassMethod("DtPortal.Configure.DataRule","DeleteById",{'ID':row.ID},function(data){ 
		    	$('#DataRuleTable').datagrid('load')
		      })
         	 
    }    
    }); 
}


//���ݵ���
function formExp()
{
	var mb = myBrowser();
	if ("IE" == mb) {
    	try
		{
			var xlApp=new ActiveXObject("Excel.Application");
		}
		catch (e)
		{
	        $.messager.alert('��ʾ','����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
	        return;
		}
		$.messager.progress({   //���ݵ�����ʾ
			title:'���Ժ�', 
			msg:'�������ڵ�����...' 
		}); 
		xlApp.Visible=false;
		xlApp.DisplayAlerts = false;
		xlApp.SheetsInNewWorkbook = 2 //'���ô�������������
		var xlBook=xlApp.Workbooks.Add();
		var xlSheet=xlBook.Worksheets(1);	
		var xlSheet2=xlBook.Worksheets(2);	
		var title1="���ݹ�������code^���ݹ�������desc^���÷���^��������^ʹ�ý�ɫ^ֵ����^ֵ��������^����ֵ^����ֵ����^��ע";
		var titleArr1=title1.split("^");
		
		var title2="���ݹ�������code^���ݹ�������desc^�ֵ�ֵ^�ֵ�����";
		var titleArr2=title2.split("^");
		
		for (i=0;i<titleArr1.length;i++)
		{
			xlSheet.Cells(1,i+1).Value=titleArr1[i];
		}
		for (i=0;i<titleArr2.length;i++)
		{
			xlSheet2.Cells(1,i+1).Value=titleArr2[i];
		}
		
		var ret=""
		ret=serverCall("DtPortal.Configure.DataRule","locIndexExp",{})
		var jsonStr=JSON.parse(ret);
		
		var subNum=0
		for (i=0;i<jsonStr.length;i++)
		{
			
			xlSheet.Cells(i+2,1).Value=jsonStr[i].DataRuleCode;
			xlSheet.Cells(i+2,2).Value=jsonStr[i].DataRuleDesc;
			xlSheet.Cells(i+2,3).Value=jsonStr[i].DataRuleType;
			xlSheet.Cells(i+2,4).Value=jsonStr[i].DataRuleTypeDesc;
			xlSheet.Cells(i+2,5).Value=jsonStr[i].DataRuleRole;
			xlSheet.Cells(i+2,6).Value=jsonStr[i].DataRuleValeType;
			xlSheet.Cells(i+2,7).Value=jsonStr[i].DataRuleValeTypeDesc;
			xlSheet.Cells(i+2,8).Value=jsonStr[i].DataRuleValue;
			xlSheet.Cells(i+2,9).Value=jsonStr[i].DataRuleValueDesc;
			xlSheet.Cells(i+2,10).Value=jsonStr[i].DataRuleRemarks;
			
			for (j=0;j<jsonStr[i].subData.length;j++)
			{
				
				xlSheet2.Cells(subNum+2,1).Value=jsonStr[i].subData[j].DataRuleCode;
				xlSheet2.Cells(subNum+2,2).Value=jsonStr[i].subData[j].DataRuleDesc;
				xlSheet2.Cells(subNum+2,3).Value=jsonStr[i].subData[j].DataDictValue;
				xlSheet2.Cells(subNum+2,4).Value=jsonStr[i].subData[j].DataDictDesc;
				subNum=subNum+1
				
			}
		}

	 	 $.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
	 	
	 	  
		try
		{
			var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
			if(fileName){
				 var ss = xlBook.SaveAs(fileName);   
			 	if (ss==false)
				{
					 $.messager.alert('��ʾ','����ʧ�ܣ�') ;
				}else{
					 $.messager.alert('��ʾ','�����ɹ���') ;
				}
			}else{
				$.messager.alert('��ʾ','����ȡ����') ;
			}
			
		}
		catch(e){
			  $.messager.alert('��ʾ','����ʧ�ܣ�') ;
		}


		xlSheet=null;
		xlSheet2=null;
	    xlBook.Close (savechanges=false);
	    xlBook=null;
	    xlApp.Quit();
	    xlApp=null;
	}
	if (("FF"==mb)||("Chrome" == mb)) {
		var uri = 'data:application/vnd.ms-excel;base64,';
		var	tmplWorkbookXML = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">'
			+ '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Author>Axel Richter</Author><Created>{created}</Created></DocumentProperties>'
			+ '<Styles>'
			+ '<Style ss:ID="Currency"><NumberFormat ss:Format="Currency"></NumberFormat></Style>'
			+ '<Style ss:ID="Date"><NumberFormat ss:Format="Medium Date"></NumberFormat></Style>'
			+ '</Styles>'
			+ '{worksheets}</Workbook>'
		var tmplWorksheetXML = '<Worksheet ss:Name="{nameWS}"><Table>{rows}</Table></Worksheet>'
		var tmplCellXML = '<Cell{attributeStyleID}{attributeFormula}><Data ss:Type="{nameType}">{data}</Data></Cell>'
		var base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
        var format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
 
        var ctx = "";
        var workbookXML = "";
        var worksheetsXML = "";
        var rowsXML1 = "";
        var rowsXML2 = "";
        
		var title1="���ݹ�������code^���ݹ�������desc^���÷���^��������^ʹ�ý�ɫ^ֵ����^ֵ��������^����ֵ^����ֵ����^��ע";
		var titleArr1=title1.split("^");
		
		var title2="���ݹ�������code^���ݹ�������desc^�ֵ�ֵ^�ֵ�����";
		var titleArr2=title2.split("^");
		
		rowsXML1 += '<Row>';
		for (i=0;i<titleArr1.length;i++)
		{
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:titleArr1[i]
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
		}
		rowsXML1 += '</Row>'
		
		rowsXML2 += '<Row>';
		for (i=0;i<titleArr2.length;i++)
		{
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:titleArr2[i]
                    , attributeFormula: ''
                  };
            rowsXML2 += format(tmplCellXML, ctx);
		}
		rowsXML2 += '</Row>'
		
		var ret=""
		ret=serverCall("DtPortal.Configure.DataRule","locIndexExp",{})
		var jsonStr=JSON.parse(ret);
		
 		var subNum=0
		for (i=0;i<jsonStr.length;i++)
		{
			rowsXML1 += '<Row>';
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleCode
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleDesc
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleType
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleTypeDesc
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleRole
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleValeType
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleValeTypeDesc
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleValue
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleValueDesc
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].DataRuleRemarks
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
			rowsXML1 += '</Row>'
			for (j=0;j<jsonStr[i].subData.length;j++)
			{
				rowsXML2 += '<Row>';
				var ctx1 = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].subData[j].DataRuleCode
                    , attributeFormula: ''
                  };
           		rowsXML2 += format(tmplCellXML, ctx1);
				ctx1 = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].subData[j].DataRuleDesc
                    , attributeFormula: ''
                  };
           		rowsXML2 += format(tmplCellXML, ctx1);
				ctx1 = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].subData[j].DataDictValue
                    , attributeFormula: ''
                  };
           		rowsXML2 += format(tmplCellXML, ctx1);
				ctx1 = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].subData[j].DataDictDesc
                    , attributeFormula: ''
                  };
           		rowsXML2 += format(tmplCellXML, ctx1);
           		rowsXML2 += '</Row>'
			}
		}
		 ctx = {rows: rowsXML1, nameWS:  '���ݹ�������'|| 'Sheet' + i};
         worksheetsXML += format(tmplWorksheetXML, ctx);
         ctx = {rows: rowsXML2, nameWS: '����ֵ' || 'Sheet' + i};
         worksheetsXML += format(tmplWorksheetXML, ctx);
            
        ctx = {created: (new Date()).getTime(), worksheets: worksheetsXML};
        workbookXML = format(tmplWorkbookXML, ctx);
 
		//�鿴��̨�Ĵ�ӡ���
        //console.log(workbookXML);
 
		var link = document.createElement("A");
        link.href = uri + base64(workbookXML);
        link.download = '���ݹ�������' || 'Workbook.xls';
        link.target = '_blank';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
	}
	
}
//�������
function openFormImp()
{
	$('#formImpDiv').dialog('open');
	$('#formImpDiv').dialog('move',{
				left:280,
				top:10
	});
}
//���ݵ���
function formImp(){
	
  if(!$("#filepath").get(0).files[0]) {
      return;
  }
  var fileE=$("#filepath").val();
  var file = $("#filepath").get(0).files[0];
  var reader = new FileReader();
  var wb;
  var rABS = false;
  var inpotData="";
  reader.onload = function(data) {
  var data = data.content;
  try {
    if(rABS) {
	    wb = XLSX.read(btoa(this.fixdata(data)), { //�ֶ�ת��
	        type: 'base64'
	    });
	  } else {
	    wb = XLSX.read(data, {
	    type: 'binary'
	    });
	  }
  } catch (e) {
        console.log('�ļ����Ͳ���ȷ');
        return;
  }
  
  //wb.SheetNames[0]�ǻ�ȡSheets�е�һ��Sheet������
  //wb.Sheets[Sheet��]��ȡ��һ��Sheet������
  tempArr1 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
  tempArr2 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[1]]);
  //console.log(tempArr1);
	var title1="���ݹ�������code^���ݹ�������desc^���÷���^��������^ʹ�ý�ɫ^ֵ����^ֵ��������^����ֵ^����ֵ����^��ע";
	var titleArr1=title1.split("^");
			
	var title2="���ݹ�������code^���ݹ�������desc^�ֵ�ֵ^�ֵ�����";
	var titleArr2=title2.split("^");

    for (var i = 0; i < tempArr1.length; i++) {
	    var objJson=tempArr1[i];
		var DataRuleCode="",DataRuleDesc="",DataRuleType="",DataRuleRole="",DataRuleValeType="",DataRuleValue="",DataRuleRemarks=""
	    
        if (objJson[titleArr1[0]] != undefined) {
            DataRuleCode = objJson[titleArr1[0]];
        }
        if (objJson[titleArr1[1]] != undefined) {
            DataRuleDesc = objJson[titleArr1[1]];
        }
        if (objJson[titleArr1[2]] != undefined) {
            DataRuleType = objJson[titleArr1[2]];
        }
        if (objJson[titleArr1[4]] != undefined) {
            DataRuleRole = objJson[titleArr1[4]];
        }
        if (objJson[titleArr1[5]] != undefined) {
            DataRuleValeType = objJson[titleArr1[5]]
        }
        if (objJson[titleArr1[7]] != undefined) {
            DataRuleValue = objJson[titleArr1[7]]
        }
        if (objJson[titleArr1[9]] != undefined) {
            DataRuleRemarks = objJson[titleArr1[9]]
        }
		var str="(@)";
		str=str+DataRuleCode+"(@)";
		str=str+DataRuleDesc+"(@)";
		str=str+DataRuleType+"(@)";
		str=str+DataRuleRole+"(@)";
		str=str+DataRuleValeType+"(@)";
		str=str+DataRuleValue+"(@)";
		str=str+DataRuleRemarks;
		if (inpotData=="")
		{
			inpotData=str;
		}else
		{
			inpotData=inpotData+"(*)"+str;
		}
    }
	var subData=""
    for (var i = 0; i < tempArr2.length; i++) {
	   
	    var objJson=tempArr2[i];
	    var DataRuleCode="",DataRuleDesc="",DataDictValue="",DataDictDesc=""
	    
        if (objJson[titleArr2[0]] != undefined) {
            DataRuleCode = objJson[titleArr2[0]]
        }
        if (objJson[titleArr2[1]] != undefined) {
            DataRuleDesc = objJson[titleArr2[1]]
        }
        if (objJson[titleArr2[2]] != undefined) {
            DataDictValue = objJson[titleArr2[2]]
        }
        if (objJson[titleArr2[3]] != undefined) {
            DataDictDesc = objJson[titleArr2[3]]
        }
         
        
		var str="";
		str=str+DataRuleCode+"(@)";
		str=str+DataRuleDesc+"(@)";
		str=str+DataDictValue+"(@)";
		str=str+DataDictDesc;
		
        var str="";
		str=str+objJson[titleArr2[0]]+"(@)";
		str=str+objJson[titleArr2[1]]+"(@)";
		str=str+objJson[titleArr2[2]]+"(@)";
		str=str+objJson[titleArr2[3]];
		
		if (subData=="")
		{
			subData=str;
		}else
		{
			subData=subData+"(*)"+str;
		}
    }
    inpotData=inpotData+"(%)"+subData;
 	
    var errMsg="",ChongMsg="",isOk=0;
    runClassMethod("DtPortal.Configure.DataRule","locIndexInport",
						{'inpotData':inpotData},
		function(data){									
			$.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
			var retStr=data.split("^")
			var isOk=retStr[0];
			var errMsg=retStr[1];
			var subIsOK=retStr[2];
			var subErrStr=retStr[3];
			
			var showMsg=""
		    if(errMsg!=""){
			     showMsg=errMsg;
			}
			
		    if(subErrStr!=""){
			     showMsg=showMsg+"||"+subErrStr;
			}
			
			if(isOk>0){
				 if (showMsg!="")
				 {
					 showMsg=showMsg+"||"+"����ɹ�"+isOk+"������!!!"
				 }else
				 {
					 showMsg="����ɹ�"+isOk+"������!!!"
				 }
			     
			}
			
			if(subIsOK>0){
			     showMsg=showMsg+"||"+"�����ӱ���ɹ�"+subIsOK+"������!!!"
			}
			$.messager.confirm("������ʾ", showMsg, function (data) {  
		        }); 
		 }
	)
  };
  
   if(rABS) {
      reader.readAsArrayBuffer(file);
  } else {
      reader.readAsBinaryString(file);
  }

}
//����ļ��ϴ���·�� 
function clearFiles (){
     var file = $("#filepath");
      file.after(file.clone().val(""));      
      file.remove();   
	
}

//�ж������
function myBrowser(){
    var userAgent = navigator.userAgent; //ȡ���������userAgent�ַ���
    var isOpera = userAgent.indexOf("Opera") > -1;
    if (isOpera) {
        return "Opera"
    }; //�ж��Ƿ�Opera�����
    if (userAgent.indexOf("Firefox") > -1) {
        return "FF";
    } //�ж��Ƿ�Firefox�����
    if (userAgent.indexOf("Chrome") > -1){
 		 return "Chrome";
 	}
    if (userAgent.indexOf("Safari") > -1) {
        return "Safari";
    } //�ж��Ƿ�Safari�����
   	//�ж��Ƿ�IE�����
	if (!!window.ActiveXObject || "ActiveXObject" in window) {
   		return "IE";
	}; 
}



   