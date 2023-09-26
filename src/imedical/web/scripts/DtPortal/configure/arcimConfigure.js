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
	    pt.onload(pt); //ҳ����dataȡpt.content�ļ�����
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



})
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
	        {field:'ArcimCode',title:'��ĿCODE',width:parseInt(0.15*tabFuWisth1)-1},    
	        {field:'ArcimDesc',title:'��Ŀ����',width:parseInt(0.13*tabFuWisth1)-1},
	        {field:'ArcimGro',title:'ҽ����',width:parseInt(0.1*tabFuWisth1)-1},
	        {field:'ArcimIsActive',title:'�Ƿ���Ч',width:parseInt(0.1*tabFuWisth1)-1},
	        {field:'ArcimIsToItmMast',title:'�Ƿ����ҽ��',width:parseInt(0.16*tabFuWisth1)-1},
	         {field:'ArcimIsShowWard',title:'������ҽ������ʾ',width:parseInt(0.18*tabFuWisth1)-1},
	        {field:'ArcimIsLoadZB',title:'����ָ������',width:parseInt(0.18*tabFuWisth1)-1}      
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
	        {field:'ItmMastID',title:'ҽ��ID',width:(parseInt(0.2*tabFuWisth2)-1)},    
	        {field:'ItmMastCode',title:'ҽ��CODE',width:(parseInt(0.2*tabFuWisth2)-1)},	        
	        {field:'ItmMastDesc',title:'ҽ������',width:(parseInt(0.6*tabFuWisth2)-1)}
	    ]],
	   	onClickRow:function(rowIndex, rowData){
			arcimSubRowClick(rowIndex, rowData);
		} 	
	}); 
	$('#arcimSubTable').datagrid('loadData', { total: 0, rows: [] });

	
}
//����ҽ��ά��
function saveArcim(){
	
	if($("#arcimCode").val()==""){
		$.messager.alert('��ʾ','����дCODE');
		return;
	}else if($("#arcimDesc").val()==""){
		$.messager.alert('��ʾ','����д����');
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
		$.messager.alert('��ʾ','������ҽ���޷�����ָ�����ݣ�');
		return;
	}
	
	var str="";
	str=str+ID+"^";
	str=str+$("#arcimCode").val()+"^";
	str=str+$("#arcimDesc").val()+"^";
	str=str+$("#arcimGro").val()+"^";
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
							$.messager.alert("��ʾ","��Ŀ�����Ѵ���,�����ظ�����!"); 
						}else{	
							$.messager.alert('��ʾ','����ʧ��:'+data)
				
						} 
					 });

	
}

//������Ŀά��
function saveArcimSub(){
	if (($("#arcimSelect").combobox('getText')=="")&&(arcimObj.ArcimIsToItmMast=="Y")) $("#arcimSelect").combobox('setValue',"")
	if(arcimObj.arcimID==undefined)
	{
		$.messager.alert('��ʾ','��ѡ�������Ŀ');
		return;
	}
	var arcimConfigure=$('#arcimSelect').combogrid('getValue');
	var otherfigure=$('#otherConfigure').val();
	if((arcimConfigure=="")&&(arcimObj.ArcimIsToItmMast=="Y")){
		$.messager.alert('��ʾ','��ѡ��ҽ��');
		return;
	}
	if((otherfigure=="")&&(arcimObj.ArcimIsToItmMast=="N")){
		$.messager.alert('��ʾ','����д����');
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
							$.messager.alert("��ʾ","ҽ�����Ѵ���,�����ظ�����!"); 
						}else{	
							$.messager.alert('��ʾ','����ʧ��:'+data)
				
						} 
	});
	
}


//ɾ����Ŀά��
function deleteArcim()
{
	if ($("#arcimTable").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#arcimTable").datagrid('getSelected');     
		 runClassMethod("DtPortal.Configure.arcim","DeleteById",{'ID':row.ID},function(data){ 
		    	formClearArcim();
		      })
         	 
    }    
    }); 
}

//ɾ��ҽ��ά��
function deleteArcimSub()
{
	if(arcimObj.arcimID==undefined)
	{
		$.messager.alert('��ʾ','��ѡ�������Ŀ');
		return;
	}else if($("#arcimSubTable").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#arcimSubTable").datagrid('getSelected'); 
		runClassMethod("DtPortal.Configure.arcimItem","DeleteById",{'ID':row.ID},function(data){ 
		    	formClearArcimSub();
		      })
         	 
    }    
    }); 
}
//�����Ŀά��
function formClearArcim()
{
	arcimObj.arcimID=""
	$('#arcimForm').form('clear');	
	$("#arcimTable").datagrid('load');
	$("#activeFlag").attr("checked","true");
	$("#toItmMastFlag").attr("checked","true");
}

//���ҽ��ά��
function formClearArcimSub()
{	
	arcimObj.arcimSubID=""
	$('#arcimSubForm').form('clear');
	$("#arcimSubTable").datagrid('load');
}


//ά����Ŀ��񵥻��¼�,��form��ֵ
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

//ҽ��ά����񵥻��¼�,��form��ֵ
function arcimSubRowClick(rowIndex, rowData)
{
	arcimObj.arcimSubID=rowData.arcimSubID;
	$("#arcimSelect").combogrid('setText',rowData.ItmMastDesc).combogrid('setValue',rowData.ItmMastID);
}

//ҽ��ά�����˫���¼�,������Ŀά��ģ��
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
		        {field:'ItmOtherText',title:'��������',width:(parseInt(0.6*tabFuWisth2)-1)},	    
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
		        {field:'ItmMastID',title:'ҽ��ID',width:(parseInt(0.2*tabFuWisth2)-1)},    
		        {field:'ItmMastCode',title:'ҽ��CODE',width:(parseInt(0.2*tabFuWisth2)-1)},	        
		        {field:'ItmMastDesc',title:'ҽ����������',width:(parseInt(0.6*tabFuWisth2)-1)}	    
		    ]],
		   	onClickRow:function(rowIndex, rowData){
				arcimSubRowClick(rowIndex, rowData);
			} 	
		}); 
	}	

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
		$.messager.alert('��ʾ','����дָ����룬�����","�ָ���');
		return;
	}
	var starDate=$("#starDate").datebox('getValue');
	var endDate=$("#endDate").datebox('getValue');
	if ((starDate=="")||(starDate==undefined))
	{
		$.messager.alert('��ʾ','��ѡ��ʼ���ڣ�');
		return;
	}
	if ((endDate=="")||(endDate==undefined))
	{
		$.messager.alert('��ʾ','��ѡ��������ڣ�');
		return;
	}
	
	runClassMethod("DtPortal.Configure.arcim","buidZbData",{'starDate':starDate,'endDate':endDate,'KPIID':arcimObj.KPIID},function(data){ 
		$.messager.alert('�������ɽ��',data);
		 
	},"text",false);

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
		xlApp.SheetsInNewWorkbook = 3 //'���ô�������������
		
		var hisNum=2,HisName="�ϰ�ҽ��������"
		if (arcimObj.hisEdition==3){hisNum=3;HisName="iMedical8.3ҽ��������"}
		
		var xlBook=xlApp.Workbooks.Add();
		var xlSheet=xlBook.Worksheets(1);	
		var xlSheet2=xlBook.Worksheets(hisNum);	
		xlSheet2.Name=HisName;
		var title1="ҽ������code^ҽ����������^ҽ��������^�Ƿ���Ч^�Ƿ����ҽ��^����ҽ���Ƿ���ʾ^�Ƿ�����ָ������";
		var titleArr1=title1.split("^");
		
		var titleHis="ҽ������code^ҽ����������^ҽ����ID^ҽ��������^�ǹ���ҽ������";
		var title2="ҽ������code^ҽ����������^ҽ����ID^ҽ��������^�ǹ���ҽ������";
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
        var rowsXML3 = "";
        
        var hisNum=2,HisName="�ϰ�ҽ��������"
		if (arcimObj.hisEdition==3){hisNum=3;HisName="iMedical8_3ҽ��������"}
		
		var title1="ҽ������code^ҽ����������^ҽ��������^�Ƿ���Ч^�Ƿ����ҽ��^����ҽ���Ƿ���ʾ^�Ƿ�����ָ������";
		var titleArr1=title1.split("^");
		
		var titleHis="ҽ������code^ҽ����������^ҽ����ID^ҽ��������^�ǹ���ҽ������";
		var title2="ҽ������code^ҽ����������^ҽ����ID^ҽ��������^�ǹ���ҽ������";
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
		
		var ret=""
		ret=serverCall("DtPortal.Configure.arcim","locIndexExp",{})
		var jsonStr=JSON.parse(ret);
		
		var subNum=0
		for (i=0;i<jsonStr.length;i++)
		{
			rowsXML1 += '<Row>';
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimCode
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimDesc
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimGro
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimIsActive
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimIsToItmMast
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimIsShowWard
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].ArcimIsLoadZB
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            rowsXML1 += '</Row>'
			
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
			if (arcimObj.hisEdition==3)
			{
				rowsXML3+=rowsXMLX;
			}else
			{
				rowsXML2+=rowsXMLX;
			}
		}
	
		 ctx = {rows: rowsXML1, nameWS:  'ҽ������'|| 'Sheet' + 1};
         worksheetsXML += format(tmplWorksheetXML, ctx);
         ctx = {rows: rowsXML2, nameWS: '�ϰ�ҽ��������' || 'Sheet' + 2};
         worksheetsXML += format(tmplWorksheetXML, ctx);
         ctx = {rows: rowsXML3, nameWS: 'iMedical8_3ҽ��������' || 'Sheet' + 3};
         worksheetsXML += format(tmplWorksheetXML, ctx);
            
        ctx = {created: (new Date()).getTime(), worksheets: worksheetsXML};
        workbookXML = format(tmplWorkbookXML, ctx);
 
		//�鿴��̨�Ĵ�ӡ���
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
  var IsIMPSub=$("input[name='IsIMPSub']:checked").val();	//�Ƿ����Ҳ�ҽ��
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
	  if (IsIMPSub=="8.3")
	  {
		  tempArr2 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[2]]);
	  }else
	  {
		  tempArr2 = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[1]]);
	  }
	 

	  console.log(tempArr1);
		var title1="ҽ������code^ҽ����������^ҽ��������^�Ƿ���Ч^�Ƿ����ҽ��^����ҽ���Ƿ���ʾ^�Ƿ�����ָ������";
		var titleArr1=title1.split("^");
			
		var title2="ҽ������code^ҽ����������^ҽ����ID^ҽ��������^�ǹ���ҽ������";
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
				     showMsg=showMsg+"||"+"ҽ�����ɹ�"+subIsOK+"������!!!"
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