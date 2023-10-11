var arcimObj=new Object();
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
	loadTable()
	$("#otherConfigureTd").css("display","none");
	$("#activeFlag").attr("checked","true");
	$('input:file').change(function(){ 
		$("#showFile").val($("#fileOpen").val()) 
    	
	});  
	$("#KPICode").change(function(){getKPIInfo();});
	loadDicHtml();


})

function loadDicHtml()
{
	runClassMethod("DtPortal.Configure.DataRuleDictionaries","getDataRuleByCode",{'code':'HISEDITION'},function(data){ 
		var DicData = JSON.parse(data);
		var html="";
		arcimObj.DicData=DicData;
		for (var i=0;i<DicData.length;i++)
		{
			html+=DicData[i].desc+'<input name="IsIMPSub" type="radio" value="'+DicData[i].value+'" />&nbsp;&nbsp';
		}
		html+=' 否<input name="IsIMPSub" type="radio" value="N" checked="true"/>';
		$("#dicHtml").html(html);
		 
	},"text",false);
}

function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
	if (!s) return new Date();
	var ss = (s.split('-'));
	var y = parseInt(ss[0],10);
	var m = parseInt(ss[1],10);
	var d = parseInt(ss[2],10);
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function loadTable()
{
	var bodyHeight=document.body.clientHeight;
	var tabTopHeight1=parseInt($("#arcimTable").position().top);
	var tabHeight1=bodyHeight-tabTopHeight1-1;
	var tabFuWisth1=$("#arcimTable").parent().width();

	$('#arcimTable').datagrid({  
		height:tabHeight1,
		pagination:true,  
		singleSelect:true, 
	    url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.arcim&MethodName=qureyArcimConfigure',    
	    columns:[[    
	        {field:'rowID',hidden:true}, 
	        {field:'ArcimCode',title:'项目CODE',width:parseInt(0.15*tabFuWisth1)-1},    
	        {field:'ArcimDesc',title:'项目描述',width:parseInt(0.13*tabFuWisth1)-1},
	        {field:'ArcimGro',title:'医嘱组',width:parseInt(0.1*tabFuWisth1)-1},
	        {field:'ArcimIsActive',title:'是否有效',width:parseInt(0.1*tabFuWisth1)-1},
	        {field:'ArcimIsToItmMast',title:'是否关联医嘱',width:parseInt(0.16*tabFuWisth1)-1},
	         {field:'ArcimIsShowWard',title:'【当日医嘱】显示',width:parseInt(0.18*tabFuWisth1)-1},
	        {field:'ArcimIsLoadZB',title:'生成指标数据',width:parseInt(0.18*tabFuWisth1)-1}      
	    ]],
	   	onClickRow:function(rowIndex, rowData){
			arcimRowClick(rowIndex, rowData);
		}, 
		onDblClickRow:function(rowIndex, rowData)
		{
			arcimRowDblClick(rowIndex, rowData);
		},
		onLoadSuccess:function(data){
			arcimObj.hisEdition=data.hisEdition;
		}, 
	}); 
	
	var tabTopHeight2=parseInt($("#arcimSubTable").position().top);
	var tabHeight2=bodyHeight-tabTopHeight2-1;
	var tabFuWisth2=$("#arcimSubTable").parent().width()-2;
	
	$('#arcimSubTable').datagrid({  
		height:tabHeight2,
		pagination:true,
		singleSelect:true,  
	    url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.arcimItem&MethodName=qureyArcimItem&arcimID=',    
	    columns:[[    
	        {field:'arcimSubID',hidden:true},    
	        {field:'ItmMastID',title:'医嘱ID',width:(parseInt(0.2*tabFuWisth2)-1)},    
	        {field:'ItmMastCode',title:'医嘱CODE',width:(parseInt(0.2*tabFuWisth2)-1)},	        
	        {field:'ItmMastDesc',title:'医嘱描述',width:(parseInt(0.6*tabFuWisth2)-1)}
	    ]],
	   	onClickRow:function(rowIndex, rowData){
			arcimSubRowClick(rowIndex, rowData);
		} 	
	}); 
	$('#arcimSubTable').datagrid('loadData', { total: 0, rows: [] });

	
}
//保存医嘱维护
function saveArcim(){
	
	if($("#arcimCode").val()==""){
		$.messager.alert('提示','请填写CODE');
		return;
	}else if($("#arcimDesc").val()==""){
		$.messager.alert('提示','请填写描述');
		return;
	}
	var ID=arcimObj.arcimID;
	if (ID==undefined) ID="";
	
	var activeflag="N";
	$("#activeFlag:checkbox:checked").each(function(){ 
		activeflag="Y"
	}) 
	
	var toItmMastFlag="N"
	$("#toItmMastFlag:checkbox:checked").each(function(){ 
		toItmMastFlag="Y"
	}) 
	
	var isShowflag="N";
	$("#isShowNH02:checkbox:checked").each(function(){ 
		isShowflag="Y"
	}) 
	
	var isLoadflag="N";
	$("#isLoadZB:checkbox:checked").each(function(){ 
		isLoadflag="Y"
	}) 
	if((toItmMastFlag=="N")&&(isLoadflag=="Y")){
		$.messager.alert('提示','不关联医嘱无法生成指标数据！');
		return;
	}
	
	var arcimCodeSS= htmlEncode($("#arcimCode").val());
	var arcimDescSS= htmlEncode($("#arcimDesc").val());
	var arcimGroSS= htmlEncode($("#arcimGro").val());
	var str="";
	str=str+ID+"^";
	str=str+arcimCodeSS+"^";
	str=str+arcimDescSS+"^";
	str=str+arcimGroSS+"^";
	str=str+activeflag+"^";
	str=str+toItmMastFlag+"^";
	str=str+isShowflag+"^";
	str=str+isLoadflag+"^";
	
	runClassMethod("DtPortal.Configure.arcim","Update",
					{'aInput':str,'aSeparate':'^'},
					function(data){										
						if(data>0){
		       				formClearArcim();
						}else if(data==0){
							$.messager.alert("提示","项目配置已存在,不能重复保存!"); 
						}else{	
							$.messager.alert('提示','保存失败:'+data)
				
						} 
					 });

	
}

//保存项目维护
function saveArcimSub(){
	if (($("#arcimSelect").combobox('getText')=="")&&(arcimObj.ArcimIsToItmMast=="Y")) $("#arcimSelect").combobox('setValue',"")
	if(arcimObj.arcimID==undefined)
	{
		$.messager.alert('提示','请选择左边项目');
		return;
	}
	var arcimConfigure=$('#arcimSelect').combogrid('getValue');
	var otherfigure=$('#otherConfigure').val();
	if((arcimConfigure=="")&&(arcimObj.ArcimIsToItmMast=="Y")){
		$.messager.alert('提示','请选择医嘱');
		return;
	}
	if((otherfigure=="")&&(arcimObj.ArcimIsToItmMast=="N")){
		$.messager.alert('提示','请填写配置');
		return;
	}
	
	if (arcimObj.ArcimIsToItmMast=="N")
	{
		arcimConfigure="";
	}else
	{
		otherfigure="";
	}
	var rowID=arcimObj.arcimID;;
	var rowSubID=arcimObj.arcimSubID;
	if (rowSubID==undefined) rowSubID="";
	var str="";
	str=str+rowID+"^";
	str=str+rowSubID+"^";
	str=str+arcimConfigure+"^";
	str=str+otherfigure+"^";
	runClassMethod("DtPortal.Configure.arcimItem","Update",
					{'aInput':str,'aSeparate':'^'},
					function(data){ 			
						if(data>0){		       				
	       				 $("#arcimSubTable").datagrid('load');
	       				 $("#arcimSelect").combogrid('setText','').combogrid('setValue','');
						}else if(data==0){
							$.messager.alert("提示","医嘱项已存在,不能重复保存!"); 
						}else{	
							$.messager.alert('提示','保存失败:'+data)
				
						} 
	});
	
}


//删除项目维护
function deleteArcim()
{
	if ($("#arcimTable").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#arcimTable").datagrid('getSelected');     
		 runClassMethod("DtPortal.Configure.arcim","DeleteById",{'ID':row.ID},function(data){ 
		    	formClearArcim();
		      })
         	 
    }    
    }); 
}

//删除医嘱维护
function deleteArcimSub()
{
	if(arcimObj.arcimID==undefined)
	{
		$.messager.alert('提示','请选择左边项目');
		return;
	}else if($("#arcimSubTable").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#arcimSubTable").datagrid('getSelected'); 
		runClassMethod("DtPortal.Configure.arcimItem","DeleteById",{'ID':row.ID},function(data){ 
		    	formClearArcimSub();
		      })
         	 
    }    
    }); 
}
//清空项目维护
function formClearArcim()
{
	arcimObj.arcimID=""
	$('#arcimForm').form('clear');	
	$("#arcimTable").datagrid('load');
	$('#arcimSubTable').datagrid('loadData', { total: 0, rows: [] });
	$("#activeFlag").attr("checked","true");
	$("#toItmMastFlag").attr("checked","true");
}

//清空医嘱维护
function formClearArcimSub()
{	
	arcimObj.arcimSubID=""
	$('#arcimSubForm').form('clear');
	$("#arcimSubTable").datagrid('load');
}


//维护项目表格单击事件,给form赋值
function arcimRowClick(rowIndex,rowData)
{

	$("#arcimCode").val(rowData.ArcimCode);
	$("#arcimDesc").val(rowData.ArcimDesc);
	$("#arcimGro").val(rowData.ArcimGro);
	
	if (rowData.ArcimIsActive=="Y")
	{
		arcimObj.ArcimIsActive="Y";
		$("#activeFlag").attr("checked","true"); 
	}else
	{
		arcimObj.ArcimIsActive="N";
		$("#activeFlag").removeAttr("checked"); 
	}
	
	if (rowData.ArcimIsShowWard=="Y")
	{
		arcimObj.ArcimIsShowWard="Y";
		$("#isShowNH02").attr("checked","true"); 
	}else
	{
		arcimObj.ArcimIsShowWard="N";
		$("#isShowNH02").removeAttr("checked"); 
	}
	
	if (rowData.ArcimIsLoadZB=="Y")
	{
		arcimObj.ArcimIsLoadZB="Y";
		$("#isLoadZB").attr("checked","true"); 
	}else
	{
		arcimObj.ArcimIsLoadZB="N";
		$("#isLoadZB").removeAttr("checked"); 
	}
	
	
	if (rowData.ArcimIsToItmMast=="Y")
	{
		arcimObj.ArcimIsToItmMast="Y";
		$("#toItmMastFlag").attr("checked","true"); 
	}else
	{
		arcimObj.ArcimIsToItmMast="N";
		$("#toItmMastFlag").removeAttr("checked"); 
	}
	arcimRowDblClick(rowIndex,rowData);
	
}

//医嘱维护表格单击事件,给form赋值
function arcimSubRowClick(rowIndex, rowData)
{
	arcimObj.arcimSubID=rowData.arcimSubID;
	$("#arcimSelect").combogrid('setText',rowData.ItmMastDesc).combogrid('setValue',rowData.ItmMastID);
}

//医嘱维护表格双击事件,加载项目维护模块
function arcimRowDblClick(rowIndex,rowData)
{	
	$("#itmMastConfigure").css("display","none");
	$("#otherConfigureTd").css("display","none");
	arcimObj.arcimID=rowData.ID;
	arcimObj.ArcimIsToItmMast=rowData.ArcimIsToItmMast;
	if(rowData.ArcimIsToItmMast=="N")
	{
		$("#otherConfigureTd").css("display","");
	}else
	{
		$("#itmMastConfigure").css("display","");
	}
	//formClearArcimSub();
	var bodyHeight=document.body.clientHeight;
	var tabTopHeight2=parseInt($("#arcimSubTable").position().top);
	var tabHeight2=bodyHeight-tabTopHeight2-1;
	var tabFuWisth2=$("#arcimSubTable").parent().width()-2;
	if (arcimObj.ArcimIsToItmMast=="N")
	{
		$('#arcimSubTable').datagrid({  
			height:tabHeight2,
			pagination:true,
			singleSelect:true,  
		    url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.arcimItem&MethodName=qureyArcimItem&arcimID='+rowData.ID,    
		    columns:[[    
		        {field:'arcimSubID',hidden:true},    	             
		        {field:'ItmOtherText',title:'其他配置',width:(parseInt(0.6*tabFuWisth2)-1)},	    
		    ]],
		   	onClickRow:function(rowIndex, rowData){
				arcimSubRowClick(rowIndex, rowData);
			} 	
		}); 
	}else
	{
		$('#arcimSubTable').datagrid({  
			height:tabHeight2,
			pagination:true,
			singleSelect:true,  
		    url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.arcimItem&MethodName=qureyArcimItem&arcimID='+rowData.ID,    
		    columns:[[    
		        {field:'arcimSubID',hidden:true},    
		        {field:'ItmMastID',title:'医嘱ID',width:(parseInt(0.2*tabFuWisth2)-1)},    
		        {field:'ItmMastCode',title:'医嘱CODE',width:(parseInt(0.2*tabFuWisth2)-1)},	        
		        {field:'ItmMastDesc',title:'医嘱描述描述',width:(parseInt(0.6*tabFuWisth2)-1)}	    
		    ]],
		   	onClickRow:function(rowIndex, rowData){
				arcimSubRowClick(rowIndex, rowData);
			} 	
		}); 
	}	

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

function findArcim()
{  
	var code=$("#arcimCode").val();
	var desc=$("#arcimDesc").val();
	var Grop=$("#arcimGro").val();
    $('#arcimTable').datagrid('load', {    
   		code: code,
   		desc: desc,
   		Grop: Grop  	 
	});   
}


function buidZbData()
{
	$('#buidKPIdata').dialog('open');
	$('#buidKPIdata').dialog('move',{
				left:240,
				top:80
	});
	
}
function getKPIInfo()
{
	var code=$("#KPICode").val();
	runClassMethod("DtPortal.Configure.arcim","getKPIInfo",{'KPICode':code},function(data){ 
		var kplArray=data.split(",")
		arcimObj.KPIID=kplArray[0];
		arcimObj.KPIDesc=kplArray[1];
		$("#KPIDesc").val(arcimObj.KPIDesc);
	})
}
function buildDataStart()
{
	if ((arcimObj.KPIID=="")||(arcimObj.KPIID==undefined))
	{
		$.messager.alert('提示','请填写指标编码，多个以","分隔！');
		return;
	}
	var starDate=$("#starDate").datebox('getValue');
	var endDate=$("#endDate").datebox('getValue');
	if ((starDate=="")||(starDate==undefined))
	{
		$.messager.alert('提示','请选择开始日期！');
		return;
	}
	if ((endDate=="")||(endDate==undefined))
	{
		$.messager.alert('提示','请选择结束日期！');
		return;
	}
	
	runClassMethod("DtPortal.Configure.arcim","buidZbData",{'starDate':starDate,'endDate':endDate,'KPIID':arcimObj.KPIID},function(data){ 
		$.messager.alert('数据生成结果',data);
		 
	},"text",false);

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
		xlApp.SheetsInNewWorkbook = 5; //'设置创建几个工作表
		
		
		var xlBook=xlApp.Workbooks.Add();
		var xlSheet=xlBook.Worksheets(1);	
		xlSheet.Name="医嘱项";	
		var xlSheet1=xlBook.Worksheets(2);	
		xlSheet1.Name="iMedical 8.0.0";	
		var xlSheet2=xlBook.Worksheets(3);	
		xlSheet2.Name="iMedical 8.2.0";	
		var xlSheet3=xlBook.Worksheets(4);	
		xlSheet3.Name="iMedical 8.3.0";	
		var xlSheet4=xlBook.Worksheets(5);	
		xlSheet4.Name="iMedical 8.4.0";	;
		var title1="医嘱配置code^医嘱配置描述^医嘱组配置^是否有效^是否关联医嘱^当日医嘱是否显示^是否生成指标数据";
		var titleArr1=title1.split("^");
		
		var titleHis="医嘱配置code^医嘱配置描述^医嘱项ID^医嘱项描述^非关联医嘱配置";
		var title2="医嘱配置code^医嘱配置描述^医嘱项ID^医嘱项描述^非关联医嘱配置";
		var titleArr2=title2.split("^");
		
		for (i=0;i<titleArr1.length;i++)
		{
			xlSheet.Cells(1,i+1).Value=titleArr1[i];
		}
		for (i=0;i<titleArr2.length;i++)
		{
			xlSheet1.Cells(1,i+1).Value=titleArr2[i];
			xlSheet2.Cells(1,i+1).Value=titleArr2[i];
			xlSheet3.Cells(1,i+1).Value=titleArr2[i];
			xlSheet4.Cells(1,i+1).Value=titleArr2[i];
		}
		
		var ret=""
		ret=serverCall("DtPortal.Configure.arcim","locIndexExp",{})
	
		var jsonStr=JSON.parse(ret);
		
		var subNum=0
		for (i=0;i<jsonStr.length;i++)
		{
			
			xlSheet.Cells(i+2,1).Value=jsonStr[i].ArcimCode;
			xlSheet.Cells(i+2,2).Value=jsonStr[i].ArcimDesc;
			xlSheet.Cells(i+2,3).Value=jsonStr[i].ArcimGro;
			xlSheet.Cells(i+2,4).Value=jsonStr[i].ArcimIsActive;
			xlSheet.Cells(i+2,5).Value=jsonStr[i].ArcimIsToItmMast;
			xlSheet.Cells(i+2,6).Value=jsonStr[i].ArcimIsShowWard;
			xlSheet.Cells(i+2,7).Value=jsonStr[i].ArcimIsLoadZB;
			
			if (arcimObj.hisEdition=="1")
			{
				for (j=0;j<jsonStr[i].subData.length;j++)
				{
					xlSheet1.Cells(subNum+2,1).Value=jsonStr[i].subData[j].ArcimCode;
					xlSheet1.Cells(subNum+2,2).Value=jsonStr[i].subData[j].ArcimDesc;
					xlSheet1.Cells(subNum+2,3).Value=jsonStr[i].subData[j].ItmMastID;
					xlSheet1.Cells(subNum+2,4).Value=jsonStr[i].subData[j].ItmMastDesc;
					xlSheet1.Cells(subNum+2,5).Value=jsonStr[i].subData[j].ItmOtherText;
					subNum=subNum+1
					
				}
			}
			if (arcimObj.hisEdition=="2")
			{
				for (j=0;j<jsonStr[i].subData.length;j++)
				{
					xlSheet2.Cells(subNum+2,1).Value=jsonStr[i].subData[j].ArcimCode;
					xlSheet2.Cells(subNum+2,2).Value=jsonStr[i].subData[j].ArcimDesc;
					xlSheet2.Cells(subNum+2,3).Value=jsonStr[i].subData[j].ItmMastID;
					xlSheet2.Cells(subNum+2,4).Value=jsonStr[i].subData[j].ItmMastDesc;
					xlSheet2.Cells(subNum+2,5).Value=jsonStr[i].subData[j].ItmOtherText;
					subNum=subNum+1
					
				}
			}
			if (arcimObj.hisEdition=="3")
			{
				for (j=0;j<jsonStr[i].subData.length;j++)
				{
					xlSheet3.Cells(subNum+2,1).Value=jsonStr[i].subData[j].ArcimCode;
					xlSheet3.Cells(subNum+2,2).Value=jsonStr[i].subData[j].ArcimDesc;
					xlSheet3.Cells(subNum+2,3).Value=jsonStr[i].subData[j].ItmMastID;
					xlSheet3.Cells(subNum+2,4).Value=jsonStr[i].subData[j].ItmMastDesc;
					xlSheet3.Cells(subNum+2,5).Value=jsonStr[i].subData[j].ItmOtherText;
					subNum=subNum+1
					
				}
			}
			if (arcimObj.hisEdition=="4")
			{
				for (j=0;j<jsonStr[i].subData.length;j++)
				{
					xlSheet4.Cells(subNum+2,1).Value=jsonStr[i].subData[j].ArcimCode;
					xlSheet4.Cells(subNum+2,2).Value=jsonStr[i].subData[j].ArcimDesc;
					xlSheet4.Cells(subNum+2,3).Value=jsonStr[i].subData[j].ItmMastID;
					xlSheet4.Cells(subNum+2,4).Value=jsonStr[i].subData[j].ItmMastDesc;
					xlSheet4.Cells(subNum+2,5).Value=jsonStr[i].subData[j].ItmOtherText;
					subNum=subNum+1
					
				}
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
        var rowsXML = "";
        var rowsXML1 = "";
        var rowsXML2 = "";
        var rowsXML3 = "";
        var rowsXML4 = "";
        
        var HisName="医嘱项配置"
		
		
		var title1="医嘱配置code^医嘱配置描述^医嘱组配置^是否有效^是否关联医嘱^当日医嘱是否显示^是否生成指标数据";
		var titleArr1=title1.split("^");
		
		var titleHis="医嘱配置code^医嘱配置描述^医嘱项ID^医嘱项描述^非关联医嘱配置";
		var title2="医嘱配置code^医嘱配置描述^医嘱项ID^医嘱项描述^非关联医嘱配置";
		var titleArr2=title2.split("^");
		
		rowsXML += '<Row>';
		for (i=0;i<titleArr1.length;i++)
		{
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:titleArr1[i]
                    , attributeFormula: ''
                  };
            rowsXML += format(tmplCellXML, ctx);
		}
		rowsXML += '</Row>'
		
		rowsXML1 += '<Row>';
		for (i=0;i<titleArr2.length;i++)
		{
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:titleArr2[i]
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
		
		rowsXML3 += '<Row>';
		for (i=0;i<titleArr2.length;i++)
		{
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:titleArr2[i]
                    , attributeFormula: ''
                  };
            rowsXML3 += format(tmplCellXML, ctx);
		}
		rowsXML3 += '</Row>'
		
		rowsXML4 += '<Row>';
		for (i=0;i<titleArr2.length;i++)
		{
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:titleArr2[i]
                    , attributeFormula: ''
                  };
            rowsXML4 += format(tmplCellXML, ctx);
		}
		rowsXML4 += '</Row>'
		
		var ret=""
		ret=serverCall("DtPortal.Configure.arcim","locIndexExp",{})
		var jsonStr=JSON.parse(ret);
		
		var subNum=0
		for (i=0;i<jsonStr.length;i++)
		{
			rowsXML += '<Row>';
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimCode
                    , attributeFormula: ''
                  };
            rowsXML += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimDesc
                    , attributeFormula: ''
                  };
            rowsXML += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimGro
                    , attributeFormula: ''
                  };
            rowsXML += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimIsActive
                    , attributeFormula: ''
                  };
            rowsXML += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimIsToItmMast
                    , attributeFormula: ''
                  };
            rowsXML += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimIsShowWard
                    , attributeFormula: ''
                  };
            rowsXML += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimIsLoadZB
                    , attributeFormula: ''
                  };
            rowsXML += format(tmplCellXML, ctx);
            rowsXML += '</Row>'
			
			var rowsXMLX="";
			for (j=0;j<jsonStr[i].subData.length;j++)
			{
				rowsXMLX += '<Row>';
				 ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].subData[j].ArcimCode
                    , attributeFormula: ''
                  };
            	rowsXMLX += format(tmplCellXML, ctx);
            	ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].subData[j].ArcimDesc
                    , attributeFormula: ''
                  };
            	rowsXMLX += format(tmplCellXML, ctx);
            	ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].subData[j].ItmMastID
                    , attributeFormula: ''
                  };
            	rowsXMLX += format(tmplCellXML, ctx);
            	ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].subData[j].ItmMastDesc
                    , attributeFormula: ''
                  };
            	rowsXMLX += format(tmplCellXML, ctx);
            	ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].subData[j].ItmOtherText
                    , attributeFormula: ''
                  };
            	rowsXMLX += format(tmplCellXML, ctx);
            	rowsXMLX += '</Row>'
			}
			if (arcimObj.hisEdition==1)
			{
				rowsXML1+=rowsXMLX;
			}
			if (arcimObj.hisEdition==2)
			{
				rowsXML2+=rowsXMLX;
			}
			if (arcimObj.hisEdition==3)
			{
				rowsXML3+=rowsXMLX;
			}
			if (arcimObj.hisEdition==4)
			{
				rowsXML4+=rowsXMLX;
			}
		}
	
		 ctx = {rows: rowsXML, nameWS:  '医嘱配置'|| 'Sheet' + 1};
         worksheetsXML += format(tmplWorksheetXML, ctx);
         ctx = {rows: rowsXML1, nameWS: 'iMedical 8.0.0' || 'Sheet' + 2};
         worksheetsXML += format(tmplWorksheetXML, ctx);
          ctx = {rows: rowsXML2, nameWS: 'iMedical 8.2.0' || 'Sheet' + 2};
         worksheetsXML += format(tmplWorksheetXML, ctx);
          ctx = {rows: rowsXML3, nameWS: 'iMedical 8.3.0' || 'Sheet' + 2};
         worksheetsXML += format(tmplWorksheetXML, ctx);
         ctx = {rows: rowsXML4, nameWS: 'iMedical 8.4.0' || 'Sheet' + 3};
         worksheetsXML += format(tmplWorksheetXML, ctx);
            
        ctx = {created: (new Date()).getTime(), worksheets: worksheetsXML};
        workbookXML = format(tmplWorkbookXML, ctx);
 
		//查看后台的打印输出
        //console.log(workbookXML);
 
		var link = document.createElement("A");
        link.href = uri + base64(workbookXML);
        link.download = HisName || 'Workbook.xls';
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
  var IsIMPSub=$("input[name='IsIMPSub']:checked").val();	//是否导入右侧医嘱
  if(!$("#filepath").get(0).files[0]) {
	  $.messager.alert("操作提示", "请选择要导入的文件！"); 
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
	   if (IsIMPSub=="1")
	  {
		   tempArr2 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[1]]);
	  }
	   if (IsIMPSub=="2")
	  {
		   tempArr2 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[2]]);
	  }
	   if (IsIMPSub=="3")
	  {
		   tempArr2 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[3]]);
	  }
	   if (IsIMPSub=="4")
	  {
		   tempArr2 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[4]]);
	  }
	 

	  console.log(tempArr1);
		var title1="医嘱配置code^医嘱配置描述^医嘱组配置^是否有效^是否关联医嘱^当日医嘱是否显示^是否生成指标数据";
		var titleArr1=title1.split("^");
			
		var title2="医嘱配置code^医嘱配置描述^医嘱项ID^医嘱项描述^非关联医嘱配置";
		var titleArr2=title2.split("^");

	    for (var i = 0; i < tempArr1.length; i++) {
		    var objJson=tempArr1[i];
			var ArcimCode="",ArcimDesc="",ArcimGro="",ArcimIsActive="",ArcimIsToItmMast="",ArcimIsShowWard="",ArcimIsLoadZB=""
	    
	        if (objJson[titleArr1[0]] != undefined) {
	            ArcimCode = objJson[titleArr1[0]]
	        }
	        if (objJson[titleArr1[1]] != undefined) {
	            ArcimDesc = objJson[titleArr1[1]]
	        }
	        if (objJson[titleArr1[2]] != undefined) {
	            ArcimGro = objJson[titleArr1[2]]
	        } 
	        if (objJson[titleArr1[3]] != undefined) {
	            ArcimIsActive = objJson[titleArr1[3]]
	        }
	        if (objJson[titleArr1[4]] != undefined) {
	            ArcimIsToItmMast = objJson[titleArr1[4]]
	        }
	        if (objJson[titleArr1[5]] != undefined) {
	            ArcimIsShowWard = objJson[titleArr1[5]]
	        }
	        if (objJson[titleArr1[6]] != undefined) {
	            ArcimIsLoadZB = objJson[titleArr1[6]]
	        }
	         
	        
			var str="^";
			str=str+ArcimCode+"^";
			str=str+ArcimDesc+"^";
			str=str+ArcimGro+"^";
			str=str+ArcimIsActive+"^";
			str=str+ArcimIsToItmMast+"^";
			str=str+ArcimIsShowWard+"^";
			str=str+ArcimIsLoadZB;
		
			if (inpotData=="")
			{
				inpotData=str;
			}else
			{
				inpotData=inpotData+"*"+str;
			}
	    }
	    if (IsIMPSub!="N")
	    {
		    var subData=""
		    for (var i = 0; i < tempArr2.length; i++) {
			   
			    var objJson=tempArr2[i];
		        var ArcimCode="",ArcimDesc="",ItmMastID="",ItmMastDesc="",ItmOtherText=""
		    
		        if (objJson[titleArr2[0]] != undefined) {
		            ArcimCode = objJson[titleArr2[0]]
		        }
		        if (objJson[titleArr2[1]] != undefined) {
		            ArcimDesc = objJson[titleArr2[1]]
		        }
		        if (objJson[titleArr2[2]] != undefined) {
		            ItmMastID = objJson[titleArr2[2]]
		        }
		        if (objJson[titleArr2[3]] != undefined) {
		            ItmMastDesc = objJson[titleArr2[3]]
		        }
		        if (objJson[titleArr2[4]] != undefined) {
		            ItmOtherText = objJson[titleArr2[4]]
		        }
		         
		        
				var str="";
				str=str+ArcimCode+"^";
				str=str+ArcimDesc+"^";
				str=str+ItmMastID+"^";
				str=str+ItmMastDesc+"^";
				str=str+ItmOtherText;
				
				if (subData=="")
				{
					subData=str;
				}else
				{
					subData=subData+"*"+str;
				}
		    }
		    inpotData=inpotData+"(%)"+subData
	    }
		
	    var errMsg="",ChongMsg="",isOk=0;
	    runClassMethod("DtPortal.Configure.arcim","locIndexInport",
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
				     showMsg=showMsg+"||"+"医嘱项导入成功"+subIsOK+"条数据!!!"
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


/**
 *  把html转义成HTML实体字符
 * @param str
 * @returns {string}
 * @constructor
 */
function htmlEncode(str) {
  var s = "";
  if (str.length === 0) {
    return "";
  }
  s = str.replace(/&/g, "&amp;");
  s = s.replace(/</g, "&lt;");
  s = s.replace(/>/g, "&gt;");
  s = s.replace(/ /g, "&nbsp;");
  s = s.replace(/\'/g, "&#39;");//IE下不支持实体名称
  s = s.replace(/\"/g, "&quot;");
  return s;
}