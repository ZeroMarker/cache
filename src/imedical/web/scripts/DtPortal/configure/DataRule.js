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
	    pt.onload(pt); //页面内data取pt.content文件内容
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
				$("#optionValue").html("配置值:");
				$("#optionValueDesc").html("值描述:");
				
			}else
			{
				$("#optionAdd").show();
				$("#optionDelete").show();
				$("#optionValue").html("选项值:");
				$("#optionValueDesc").html("选项描述:");
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
	        {field:'desc',title:'描述',width:parseInt(0.15*tabFuWisth1)-1},    
	        {field:'typeDesc',title:'分类',width:parseInt(0.06*tabFuWisth1)-1},    
	        {field:'roleDesc',title:'角色',width:parseInt(0.06*tabFuWisth1)-1},    
	        {field:'valueTypeDesc',title:'值类型',width:parseInt(0.05*tabFuWisth1)-1},    
	        {field:'value',title:'值',width:parseInt(0.1*tabFuWisth1)-1},    
	        {field:'valueDesc',title:'值描述',width:parseInt(0.14*tabFuWisth1)-1},    
	        {field:'Remarks',title:'备注',width:parseInt(0.35*tabFuWisth1)-1}
	         
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

//查询按钮点击事件
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

//增加配置
function add()
{
	DataRuleObj.ID=""; 
	openDataAdd();
}

//修改配置
function update()
{
	if (DataRuleObj.ID=="") 
	{
		$.messager.alert('提示','请选择要修改的配置!');
		return;
	}
	openDataAdd();
	
}

//项目增加打开
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

//增加选项值
function addOption()
{
	var value=$("#value").val();
	var valueDesc=$("#valueDesc").val();
	
	if ((valueDesc=="")||(valueDesc==undefined)) 
	{
		$.messager.alert('提示','请填写选项值描述!');
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
			errDesc="该选项值已存在";
		}
		if (vD==valueDesc)
		{
			errDesc="该选项描述已存在";
		}	
	})
	if (errDesc!="") 
	{
		$.messager.alert('提示',errDesc);
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

//保存选项值
function saveOption()
{
	var value=$("#value").val();
	var valueDesc=$("#valueDesc").val();
	
	if ((valueDesc=="")||(valueDesc==undefined)) 
	{
		$.messager.alert('提示','请填写选项值描述!');
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
				errDesc="该选项值已存在";
			}
			if (vD==valueDesc)
			{
				errDesc="该选项描述已存在";
			}
		}
		
	})
	if (errDesc!="") 
	{
		$.messager.alert('提示',errDesc);
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
//保存点击事件
function save(){
	var code=$("#AddCode").val();
	var desc=$("#AddDesc").val();
	var type=$('#type2').combobox('getValue');
	var valueType=$('#valueType').combobox('getValue');
	if(code==""){
		$.messager.alert('提示','请填写数据规则code');
		return;
	}
	if(desc==""){
		$.messager.alert('提示','请填写数据规则描述');
		return;
	}
	if(valueType==""){
		$.messager.alert('提示','请选择值类型');
		return;
	}
	var value=""
	if (DataRuleObj.valueType==1)
	{
		value=$("#value").val();
		if(value==""){
			$.messager.alert('提示','请填写配置值!');
			return;
		}
		DataRuleObj.optionValueStr=value;
		DataRuleObj.optionValueDescStr=$("#valueDesc").val();
	}else if(DataRuleObj.valueType==2)
	{
		value=$("input[name='value2']:checked").val();
		if((value=="")||(value==undefined)){
			$.messager.alert('提示','请选择配置值!');
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
			$.messager.alert('提示','请选择配置值!');
			return;
		}
	}
	
	//规则使用角色
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
				$.messager.confirm('提示','已保存成功,关闭页面?',function(r){    
	    			if (r){$('#dataAddDiv').dialog('close');}
				})
   				
			}else if(data==0){
				$.messager.alert("提示","不能重复!"); 
			}else{	
				$.messager.alert('提示','保存失败:'+data)
	
			} 
		 });

	
}

//选项点击事件
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
		$.messager.alert('提示','请选择要删除的选项!');
		return;
	}
	
	$.messager.confirm('确认','您确认想删除该选项吗？',function(r){    
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

//清空
function formClear()
{
	$('#FormAdd').form('clear');
	DataRuleObj.ID="";
	$("#optionShow").html("");
}

//获取数组中元素的下标(indexof不起作用)
function getIndexOfAaary(arry,str)
{
	var ret=-1
	for (var i=0;i<arry.length;i++)
	{
		if (arry[i]==str) ret=i;
	}
	return ret
}


//删除
function deleteData()
{
	if ($("#DataRuleTable").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#DataRuleTable").datagrid('getSelected');     
		 runClassMethod("DtPortal.Configure.DataRule","DeleteById",{'ID':row.ID},function(data){ 
		    	$('#DataRuleTable').datagrid('load')
		      })
         	 
    }    
    }); 
}


//数据导出
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
	        $.messager.alert('提示','请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
	        return;
		}
		$.messager.progress({   //数据导入提示
			title:'请稍后', 
			msg:'数据正在导出中...' 
		}); 
		xlApp.Visible=false;
		xlApp.DisplayAlerts = false;
		xlApp.SheetsInNewWorkbook = 2 //'设置创建几个工作表
		var xlBook=xlApp.Workbooks.Add();
		var xlSheet=xlBook.Worksheets(1);	
		var xlSheet2=xlBook.Worksheets(2);	
		var title1="数据规则配置code^数据规则配置desc^配置分类^分类描述^使用角色^值类型^值类型描述^配置值^配置值描述^备注";
		var titleArr1=title1.split("^");
		
		var title2="数据规则配置code^数据规则配置desc^字典值^字典描述";
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

	 	 $.messager.progress('close')//数据导入完成关闭加载框
	 	
	 	  
		try
		{
			var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
			if(fileName){
				 var ss = xlBook.SaveAs(fileName);   
			 	if (ss==false)
				{
					 $.messager.alert('提示','导出失败！') ;
				}else{
					 $.messager.alert('提示','导出成功！') ;
				}
			}else{
				$.messager.alert('提示','导出取消！') ;
			}
			
		}
		catch(e){
			  $.messager.alert('提示','导出失败！') ;
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
        
		var title1="数据规则配置code^数据规则配置desc^配置分类^分类描述^使用角色^值类型^值类型描述^配置值^配置值描述^备注";
		var titleArr1=title1.split("^");
		
		var title2="数据规则配置code^数据规则配置desc^字典值^字典描述";
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
		 ctx = {rows: rowsXML1, nameWS:  '数据规则配置'|| 'Sheet' + i};
         worksheetsXML += format(tmplWorksheetXML, ctx);
         ctx = {rows: rowsXML2, nameWS: '配置值' || 'Sheet' + i};
         worksheetsXML += format(tmplWorksheetXML, ctx);
            
        ctx = {created: (new Date()).getTime(), worksheets: worksheetsXML};
        workbookXML = format(tmplWorkbookXML, ctx);
 
		//查看后台的打印输出
        //console.log(workbookXML);
 
		var link = document.createElement("A");
        link.href = uri + base64(workbookXML);
        link.download = '数据规则配置' || 'Workbook.xls';
        link.target = '_blank';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
	}
	
}
//数据入打开
function openFormImp()
{
	$('#formImpDiv').dialog('open');
	$('#formImpDiv').dialog('move',{
				left:280,
				top:10
	});
}
//数据导入
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
	    wb = XLSX.read(btoa(this.fixdata(data)), { //手动转化
	        type: 'base64'
	    });
	  } else {
	    wb = XLSX.read(data, {
	    type: 'binary'
	    });
	  }
  } catch (e) {
        console.log('文件类型不正确');
        return;
  }
  
  //wb.SheetNames[0]是获取Sheets中第一个Sheet的名字
  //wb.Sheets[Sheet名]获取第一个Sheet的数据
  tempArr1 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
  tempArr2 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[1]]);
  //console.log(tempArr1);
	var title1="数据规则配置code^数据规则配置desc^配置分类^分类描述^使用角色^值类型^值类型描述^配置值^配置值描述^备注";
	var titleArr1=title1.split("^");
			
	var title2="数据规则配置code^数据规则配置desc^字典值^字典描述";
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
			$.messager.progress('close')//数据导入完成关闭加载框
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
					 showMsg=showMsg+"||"+"导入成功"+isOk+"条数据!!!"
				 }else
				 {
					 showMsg="导入成功"+isOk+"条数据!!!"
				 }
			     
			}
			
			if(subIsOK>0){
			     showMsg=showMsg+"||"+"配置子表导入成功"+subIsOK+"条数据!!!"
			}
			$.messager.confirm("操作提示", showMsg, function (data) {  
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
//清空文件上传的路径 
function clearFiles (){
     var file = $("#filepath");
      file.after(file.clone().val(""));      
      file.remove();   
	
}

//判断浏览器
function myBrowser(){
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var isOpera = userAgent.indexOf("Opera") > -1;
    if (isOpera) {
        return "Opera"
    }; //判断是否Opera浏览器
    if (userAgent.indexOf("Firefox") > -1) {
        return "FF";
    } //判断是否Firefox浏览器
    if (userAgent.indexOf("Chrome") > -1){
 		 return "Chrome";
 	}
    if (userAgent.indexOf("Safari") > -1) {
        return "Safari";
    } //判断是否Safari浏览器
   	//判断是否IE浏览器
	if (!!window.ActiveXObject || "ActiveXObject" in window) {
   		return "IE";
	}; 
}



   