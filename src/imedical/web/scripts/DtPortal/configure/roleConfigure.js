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
	    pt.onload(pt); //页面内data取pt.content文件内容
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
	        {field:'PortalID',title:'角色ID',width:parseInt(0.2*tabFuWisth1)-1},    
	        {field:'RoleCode',title:'角色CODE',width:parseInt(0.2*tabFuWisth1)-1},
	        {field:'RoleDesc',title:'角色描述',width:parseInt(0.4*tabFuWisth1)-1},
	        {field:'RoleIsActive',title:'是否有效',width:parseInt(0.2*tabFuWisth1)-1}     
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
	        {field:'groupID',title:'安全组ID',width:(parseInt(0.2*tabFuWisth2)-1)},           
	        {field:'groupDesc',title:'安全组描述',width:(parseInt(0.6*tabFuWisth2)-1)},	    
	    ]],
	   	onClickRow:function(rowIndex, rowData){
			RoleSubRowClick(rowIndex, rowData);
		}	
	}); 
}
//保存角色维护
function saveRole(){
	
	if($("#RoleID").val()==""){
		$.messager.alert('提示','请填写PortalID');
		return;
	}
	if($("#RoleCode").val()==""){
		$.messager.alert('提示','请填写CODE');
		return;
	}
	 if($("#RoleDesc").val()==""){
		$.messager.alert('提示','请填写描述');
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
							$.messager.alert("提示","角色配置已存在,不能重复保存!"); 
						}else{	
							$.messager.alert('提示','保存失败:'+data)
				
						} 
					 });

	
}

//保存安全组维护
function saveRoleSub(){
	if ($("#RoleSelect").combobox('getText')=="") $("#RoleSelect").combobox('setValue',"")
	if(RoleObj.RoleID==undefined)
	{
		$.messager.alert('提示','请选择左边角色');
		return;
	}
	else if($('#RoleSelect').combogrid('getValue')==""){
		$.messager.alert('提示','请选择安全组');
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
							$.messager.alert("提示","安全组已存在,不能重复保存!"); 
						}else{	
							$.messager.alert('提示','保存失败:'+data)
				
						} 
	});
	
}


//删除角色维护
function deleteRole()
{
	if ($("#RoleTable").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#RoleTable").datagrid('getSelected');     
		 runClassMethod("DtPortal.Configure.RoleGroup","DeleteById",{'ID':row.ID},function(data){ 
		    	formClearRole();
		      })
         	 
    }    
    }); 
}

//删除安全组维护
function deleteRoleSub()
{
	if(RoleObj.RoleID==undefined)
	{
		$.messager.alert('提示','请选择左边角色');
		return;
	}else if($("#RoleSubTable").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#RoleSubTable").datagrid('getSelected'); 
		runClassMethod("DtPortal.Configure.RoleGroupItem","DeleteById",{'ID':row.roleGroupID},function(data){ 
		    	formClearRoleSub();
		      })
         	 
    }    
    }); 
}
//清空角色维护
function formClearRole()
{
	RoleObj.RoleID=""
	$('#RoleForm').form('clear');	
	$("#RoleTable").datagrid('load');
	$("#activeFlag").attr("checked","true");
}

//清空安全组维护
function formClearRoleSub()
{	
	RoleObj.RoleSubID=""
	$('#RoleSubForm').form('clear');
	$("#RoleSubTable").datagrid('load');
}
//数据同步打开
function openDataSync()
{
	$('#dataSyncDiv').dialog('open');
	$('#dataSyncDiv').dialog('move',{
				left:280,
				top:180
	});
}

//数据同步
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
		    	$.messager.alert('提示','请选择要导入的科室');
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
		    	$.messager.alert('提示','请要选择导入的角色');
				return;
		    }else
		    {
			    selectValue=SyncRoleUserVale;
			}
	    }else
	    {
		   if (SyncOneUserVale=="")
	    	{
		    	$.messager.alert('提示','请选择要导入的用户');
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
					$.messager.alert('提示',data);
				
						
	});
}
//维护角色表格单击事件,给form赋值
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

//安全组维护表格单击事件,给form赋值
function RoleSubRowClick(rowIndex, rowData)
{
	RoleObj.RoleSubID=rowData.RoleSubID;
	$("#RoleSelect").combogrid('setText',rowData.ItmMastDesc).combogrid('setValue',rowData.ItmMastID);
}

//角色维护表格双击事件,弹出角色配置窗口
function RoleRowDblClick(rowIndex,rowData)
{
	
	RoleObj.RoleID=rowData.ID;
	formClearRoleSub();	
	$('#RoleSubTable').datagrid('load', {    
   		roleID: rowData.ID   		    	 
	});
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

function findRole()
{  
	var code=$("#RoleCode").val();
	var desc=$("#RoleDesc").val();
    $('#RoleTable').datagrid('load', {    
   		code: code,
   		desc: desc   	 
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
		var title1="角色code^角色描述^Portal角色ID^是否有效";
		var titleArr1=title1.split("^");
		
		var title2="角色code^角色描述^安全组ID^安全组描述";
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
        var rowsXML1 = "";
        var rowsXML2 = "";
        
		var title1="角色code^角色描述^Portal角色ID^是否有效";
		var titleArr1=title1.split("^");
		
		var title2="角色code^角色描述^安全组ID^安全组描述";
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
		
		 ctx = {rows: rowsXML1, nameWS:  '角色配置'|| 'Sheet' + i};
         worksheetsXML += format(tmplWorksheetXML, ctx);
         ctx = {rows: rowsXML2, nameWS: '安全组配置' || 'Sheet' + i};
         worksheetsXML += format(tmplWorksheetXML, ctx);
            
        ctx = {created: (new Date()).getTime(), worksheets: worksheetsXML};
        workbookXML = format(tmplWorkbookXML, ctx);
 
		//查看后台的打印输出
        //console.log(workbookXML);
 
		var link = document.createElement("A");
        link.href = uri + base64(workbookXML);
        link.download = '角色配置' || 'Workbook.xls';
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
  var IsIMPSub=$("input[name='IsIMPSub']:checked").val();	//是否导入右侧安全组
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
	var title1="角色code^角色描述^Portal角色ID^是否有效";
	var titleArr1=title1.split("^");
	
	var title2="角色code^角色描述^安全组ID^安全组描述";
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

