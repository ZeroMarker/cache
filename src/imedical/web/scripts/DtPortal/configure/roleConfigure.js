var RoleObj=new Object();
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
	//$("#SyncOneLocDiv").hide();
	$("#MoreDataTishi").hide();
	$("#SyncRoleUserDiv").hide();
	$("#SyncOneUserDiv").hide();
	$("#Synclongding").hide();
	
	 $(":radio").click(function(){
    	var syncType=$("input[name='syncType']:checked").val();
    	var syncNum=$("input[name='syncNum']:checked").val();
    	$("#MoreDataTishi").hide();
    	$("#SyncOneLocDiv").hide();
		$("#SyncRoleUserDiv").hide();
		$("#SyncOneUserDiv").hide();
    	if(syncType=="D")
    	{
	    	if (syncNum=="2")
	    	{
				$("#MoreDataTishi").show();
		    }else
		    {
			    $("#SyncOneLocDiv").show();
			}
	    }else
	    {
		    if (syncNum=="2")
	    	{
				$("#SyncRoleUserDiv").show();
				$("#MoreDataTishi").show();
		    }else
		    {
				$("#SyncOneUserDiv").show();
			}
		}
    	
   	});
	$("#activeFlag").attr("checked","true");
})
function loadTable()
{
	var bodyHeight=document.body.clientHeight;
	var tabTopHeight1=parseInt($("#RoleTable").position().top);
	var tabHeight1=bodyHeight-tabTopHeight1-1;
	var tabFuWisth1=$("#RoleTable").parent().width();

	$('#RoleTable').datagrid({  
		height:tabHeight1,
		pagination:true,  
		singleSelect:true, 
	    url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.RoleGroup&MethodName=qureyGroupConfigure',    
	    columns:[[    
	        {field:'ID',hidden:true},    
	        {field:'PortalID',title:'��ɫID',width:parseInt(0.2*tabFuWisth1)-1},    
	        {field:'RoleCode',title:'��ɫCODE',width:parseInt(0.2*tabFuWisth1)-1},
	        {field:'RoleDesc',title:'��ɫ����',width:parseInt(0.4*tabFuWisth1)-1},
	        {field:'RoleIsActive',title:'�Ƿ���Ч',width:parseInt(0.2*tabFuWisth1)-1}     
	    ]],
	   	onClickRow:function(rowIndex, rowData){
			RoleRowClick(rowIndex, rowData);
		}, 
		onDblClickRow:function(rowIndex, rowData)
		{
			RoleRowDblClick(rowIndex, rowData);
		}
	}); 
	
	var tabTopHeight2=parseInt($("#RoleSubTable").position().top);
	var tabHeight2=bodyHeight-tabTopHeight2-1;
	var tabFuWisth2=$("#RoleSubTable").parent().width()-2;
	$('#RoleSubTable').datagrid({  
		height:tabHeight2,
		pagination:true,
		singleSelect:true,  
	    url:'dhcapp.broker.csp?ClassName=DtPortal.Configure.RoleGroupItem&MethodName=qureyRoleGroup',    
	    columns:[[    
	        {field:'RoleSubID',hidden:true},    
	        {field:'groupID',title:'��ȫ��ID',width:(parseInt(0.2*tabFuWisth2)-1)},           
	        {field:'groupDesc',title:'��ȫ������',width:(parseInt(0.6*tabFuWisth2)-1)},	    
	    ]],
	   	onClickRow:function(rowIndex, rowData){
			RoleSubRowClick(rowIndex, rowData);
		}	
	}); 
}
//�����ɫά��
function saveRole(){
	
	if($("#RoleID").val()==""){
		$.messager.alert('��ʾ','����дPortalID');
		return;
	}
	if($("#RoleCode").val()==""){
		$.messager.alert('��ʾ','����дCODE');
		return;
	}
	 if($("#RoleDesc").val()==""){
		$.messager.alert('��ʾ','����д����');
		return;
	}
	var ID=RoleObj.RoleID;
	if (ID==undefined) ID="";
	var flag="N"
	$("#activeFlag:checkbox:checked").each(function(){ 
		flag="Y"
	}) 

	var str="";
	str=str+ID+"^";
	str=str+$("#RoleID").val()+"^";
	str=str+$("#RoleCode").val()+"^";
	str=str+$("#RoleDesc").val()+"^";
	str=str+flag+"^";
	runClassMethod("DtPortal.Configure.RoleGroup","Update",
					{'aInput':str,'aSeparate':'^'},
					function(data){										
						if(data>0){
		       				formClearRole();
						}else if(data==0){
							$.messager.alert("��ʾ","��ɫ�����Ѵ���,�����ظ�����!"); 
						}else{	
							$.messager.alert('��ʾ','����ʧ��:'+data)
				
						} 
					 });

	
}

//���氲ȫ��ά��
function saveRoleSub(){
	if ($("#RoleSelect").combobox('getText')=="") $("#RoleSelect").combobox('setValue',"")
	if(RoleObj.RoleID==undefined)
	{
		$.messager.alert('��ʾ','��ѡ����߽�ɫ');
		return;
	}
	else if($('#RoleSelect').combogrid('getValue')==""){
		$.messager.alert('��ʾ','��ѡ��ȫ��');
		return;
	}
	var rowID=RoleObj.RoleID;;
	var rowSubID=RoleObj.RoleSubID;

	var str="";
	str=str+rowID+"^";
	str=str+rowSubID+"^";
	str=str+$('#RoleSelect').combogrid('getValue')+"^";
	runClassMethod("DtPortal.Configure.RoleGroupItem","Update",
					{'aInput':str,'aSeparate':'^'},
					function(data){ 			
						if(data>0){		       				
	       				 $("#RoleSubTable").datagrid('load');
	       				 $("#RoleSelect").combogrid('setText','').combogrid('setValue','');
						}else if(data==0){
							$.messager.alert("��ʾ","��ȫ���Ѵ���,�����ظ�����!"); 
						}else{	
							$.messager.alert('��ʾ','����ʧ��:'+data)
				
						} 
	});
	
}


//ɾ����ɫά��
function deleteRole()
{
	if ($("#RoleTable").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#RoleTable").datagrid('getSelected');     
		 runClassMethod("DtPortal.Configure.RoleGroup","DeleteById",{'ID':row.ID},function(data){ 
		    	formClearRole();
		      })
         	 
    }    
    }); 
}

//ɾ����ȫ��ά��
function deleteRoleSub()
{
	if(RoleObj.RoleID==undefined)
	{
		$.messager.alert('��ʾ','��ѡ����߽�ɫ');
		return;
	}else if($("#RoleSubTable").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#RoleSubTable").datagrid('getSelected'); 
		runClassMethod("DtPortal.Configure.RoleGroupItem","DeleteById",{'ID':row.roleGroupID},function(data){ 
		    	formClearRoleSub();
		      })
         	 
    }    
    }); 
}
//��ս�ɫά��
function formClearRole()
{
	RoleObj.RoleID=""
	$('#RoleForm').form('clear');	
	$("#RoleTable").datagrid('load');
	$("#activeFlag").attr("checked","true");
}

//��հ�ȫ��ά��
function formClearRoleSub()
{	
	RoleObj.RoleSubID=""
	$('#RoleSubForm').form('clear');
	$("#RoleSubTable").datagrid('load');
}
//����ͬ����
function openDataSync()
{
	$('#dataSyncDiv').dialog('open');
	$('#dataSyncDiv').dialog('move',{
				left:280,
				top:180
	});
}

//����ͬ��
function saveDataSync()
{
	
	var syncType=$("input[name='syncType']:checked").val();
	var syncNum=$("input[name='syncNum']:checked").val();
	var SyncOneLocVale=$('#SyncOneLocSelect').combobox('getValue')
	var SyncRoleUserVale=$('#SyncRoleUserSelect').combobox('getValue')
	var SyncOneUserVale=$('#SyncOneUserSelect').combobox('getValue')
	var selectValue="";
	if(syncType=="D")
	{
    	if (syncNum=="1")
    	{
	    	if (SyncOneLocVale=="")
	    	{
		    	$.messager.alert('��ʾ','��ѡ��Ҫ����Ŀ���');
				return;
		    }else
		    {
			    selectValue=SyncOneLocVale;
			}	    		
	    }
    }else
    {
	    if (syncNum=="2")
    	{
	    	if (SyncRoleUserVale=="")
	    	{
		    	$.messager.alert('��ʾ','��Ҫѡ����Ľ�ɫ');
				return;
		    }else
		    {
			    selectValue=SyncRoleUserVale;
			}
	    }else
	    {
		   if (SyncOneUserVale=="")
	    	{
		    	$.messager.alert('��ʾ','��ѡ��Ҫ������û�');
				return;
		    }else
		    {
			    selectValue=SyncOneUserVale;
			}
		}
	}
	var str="";
	str=str+syncType+"^";
	str=str+syncNum+"^";
	str=str+selectValue+"^";
	$("#Synclongding").show();
	runClassMethod("DtPortal.Configure.DataSync","saveDataSync",
					{'aInput':str,'aSeparate':'1'},
					function(data){ 
					$("#Synclongding").hide();								
					$.messager.alert('��ʾ',data);
				
						
	});
}
//ά����ɫ��񵥻��¼�,��form��ֵ
function RoleRowClick(rowIndex,rowData)
{
	$("#RoleID").val(rowData.PortalID);
	$("#RoleCode").val(rowData.RoleCode);
	$("#RoleDesc").val(rowData.RoleDesc);
	$("#locGroupDesc").val(rowData.LocGroupDesc);
	
	if (rowData.RoleIsActive=="Y")
	{
		$("#activeFlag").attr("checked","true"); 
	}else
	{
		$("#activeFlag").removeAttr("checked"); 
	}

	RoleRowDblClick(rowIndex,rowData);
}

//��ȫ��ά����񵥻��¼�,��form��ֵ
function RoleSubRowClick(rowIndex, rowData)
{
	RoleObj.RoleSubID=rowData.RoleSubID;
	$("#RoleSelect").combogrid('setText',rowData.ItmMastDesc).combogrid('setValue',rowData.ItmMastID);
}

//��ɫά�����˫���¼�,������ɫ���ô���
function RoleRowDblClick(rowIndex,rowData)
{
	
	RoleObj.RoleID=rowData.ID;
	formClearRoleSub();	
	$('#RoleSubTable').datagrid('load', {    
   		roleID: rowData.ID   		    	 
	});
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

function findRole()
{  
	var code=$("#RoleCode").val();
	var desc=$("#RoleDesc").val();
    $('#RoleTable').datagrid('load', {    
   		code: code,
   		desc: desc   	 
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
		var title1="��ɫcode^��ɫ����^Portal��ɫID^�Ƿ���Ч";
		var titleArr1=title1.split("^");
		
		var title2="��ɫcode^��ɫ����^��ȫ��ID^��ȫ������";
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
		ret=serverCall("DtPortal.Configure.RoleGroup","locIndexExp",{})
		var jsonStr=JSON.parse(ret);
		
		var subNum=0
		for (i=0;i<jsonStr.length;i++)
		{
			
			xlSheet.Cells(i+2,1).Value=jsonStr[i].RoleCode;
			xlSheet.Cells(i+2,2).Value=jsonStr[i].RoleDesc;
			xlSheet.Cells(i+2,3).Value=jsonStr[i].PortalID;
			xlSheet.Cells(i+2,4).Value=jsonStr[i].RoleIsActive;
			
			for (j=0;j<jsonStr[i].subData.length;j++)
			{
				
				xlSheet2.Cells(subNum+2,1).Value=jsonStr[i].subData[j].RoleCode;
				xlSheet2.Cells(subNum+2,2).Value=jsonStr[i].subData[j].RoleDesc;
				xlSheet2.Cells(subNum+2,3).Value=jsonStr[i].subData[j].groupID;
				xlSheet2.Cells(subNum+2,4).Value=jsonStr[i].subData[j].groupDesc;
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
        
		var title1="��ɫcode^��ɫ����^Portal��ɫID^�Ƿ���Ч";
		var titleArr1=title1.split("^");
		
		var title2="��ɫcode^��ɫ����^��ȫ��ID^��ȫ������";
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
		ret=serverCall("DtPortal.Configure.RoleGroup","locIndexExp",{})
		var jsonStr=JSON.parse(ret);
		
		var subNum=0
		for (i=0;i<jsonStr.length;i++)
		{
			rowsXML1 += '<Row>';
			ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].RoleCode
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].RoleDesc
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].PortalID
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            ctx = {  attributeStyleID: ''
                    , nameType: 'String'
                    , data:jsonStr[i].RoleIsActive
                    , attributeFormula: ''
                  };
            rowsXML1 += format(tmplCellXML, ctx);
            rowsXML1 += '</Row>'
            
			for (j=0;j<jsonStr[i].subData.length;j++)
			{
				rowsXML2 += '<Row>';
				ctx = {  attributeStyleID: ''
	                    , nameType: 'String'
	                    , data:jsonStr[i].subData[j].RoleCode
	                    , attributeFormula: ''
	                  };
	            rowsXML2 += format(tmplCellXML, ctx);
	            ctx = {  attributeStyleID: ''
	                    , nameType: 'String'
	                    , data:jsonStr[i].subData[j].RoleDesc
	                    , attributeFormula: ''
	                  };
	            rowsXML2 += format(tmplCellXML, ctx);
	            ctx = {  attributeStyleID: ''
	                    , nameType: 'String'
	                    , data:jsonStr[i].subData[j].groupID
	                    , attributeFormula: ''
	                  };
	            rowsXML2 += format(tmplCellXML, ctx);
	            ctx = {  attributeStyleID: ''
	                    , nameType: 'String'
	                    , data:jsonStr[i].subData[j].groupDesc
	                    , attributeFormula: ''
	                  };
	            rowsXML2 += format(tmplCellXML, ctx);
	            rowsXML2 += '</Row>'
			}
		}
		
		 ctx = {rows: rowsXML1, nameWS:  '��ɫ����'|| 'Sheet' + i};
         worksheetsXML += format(tmplWorksheetXML, ctx);
         ctx = {rows: rowsXML2, nameWS: '��ȫ������' || 'Sheet' + i};
         worksheetsXML += format(tmplWorksheetXML, ctx);
            
        ctx = {created: (new Date()).getTime(), worksheets: worksheetsXML};
        workbookXML = format(tmplWorkbookXML, ctx);
 
		//�鿴��̨�Ĵ�ӡ���
        //console.log(workbookXML);
 
		var link = document.createElement("A");
        link.href = uri + base64(workbookXML);
        link.download = '��ɫ����' || 'Workbook.xls';
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
  var IsIMPSub=$("input[name='IsIMPSub']:checked").val();	//�Ƿ����Ҳలȫ��
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
	var title1="��ɫcode^��ɫ����^Portal��ɫID^�Ƿ���Ч";
	var titleArr1=title1.split("^");
	
	var title2="��ɫcode^��ɫ����^��ȫ��ID^��ȫ������";
	var titleArr2=title2.split("^");

    for (var i = 0; i < tempArr1.length; i++) {
	    var objJson=tempArr1[i];
	    var RoleCode="",RoleDesc="",PortalID="",RoleIsActive=""
	    
        if (objJson[titleArr1[0]] != undefined) {
            RoleCode = objJson[titleArr1[0]]
        }
        if (objJson[titleArr1[1]] != undefined) {
            RoleDesc = objJson[titleArr1[1]]
        }
        if (objJson[titleArr1[2]] != undefined) {
            PortalID = objJson[titleArr1[2]]
        }
        if (objJson[titleArr1[3]] != undefined) {
            RoleIsActive = objJson[titleArr1[3]]
        }
         
        
		var str="^";
		str=str+PortalID+"^";
		str=str+RoleCode+"^";
		str=str+RoleDesc+"^";
		str=str+RoleIsActive;
		
		if (inpotData=="")
		{
			inpotData=str;
		}else
		{
			inpotData=inpotData+"*"+str;
		}
		
    }
    if (IsIMPSub=="Y")
    {
	    var subData=""
	    for (var i = 0; i < tempArr2.length; i++) {
		   
		    var objJson=tempArr2[i];
		     var RoleCode="",RoleDesc="",groupID="",groupDesc=""
		    
	        if (objJson[titleArr2[0]] != undefined) {
	            RoleCode =objJson[titleArr2[0]]
	        }
	        if (objJson[titleArr2[1]] != undefined) {
	            RoleDesc = objJson[titleArr2[1]]
	        }
	        if (objJson[titleArr2[2]] != undefined) {
	            groupID = objJson[titleArr2[2]]
	        }
	        if (objJson[titleArr2[3]] != undefined) {
	            groupDesc = objJson[titleArr2[3]]
	        }
	         
	        
			var str="";
			str=str+RoleCode+"^";
			str=str+RoleDesc+"^";
			str=str+groupID+"^";
			str=str+groupDesc;
			
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
    runClassMethod("DtPortal.Configure.RoleGroup","locIndexInport",
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

