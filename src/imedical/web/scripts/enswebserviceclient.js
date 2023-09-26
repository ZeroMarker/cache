var eventStatus="";
$(function(){
	loadEnsWebServiceClient();
	// 查询按钮
	$("#webServiceClientDataSelectBtn").click(function () {
		reLoadEnsWebServiceClient();
    });
    // 新增按钮
    $("#webServiceClientDataAddBtn").click(function () {    
	    eventStatus="add";
		$('#webServiceDataCancleBtn').linkbutton('enable');     // 启用此 button 
		$('#webServiceDataCancleBtn').attr("disabled",false);
		$('#webServiceCode').attr("readOnly",false);
		clearDetailContent();
		$('#configDetail').window('open');
    });
    $('#webServiceUrl').blur(function() {
		var soapUrl = $(this).val();
		soapUrl = $.trim(soapUrl);
		var arr = new Array();
		arr = soapUrl.split("/");
		var index=arr[2].indexOf(":");
		if (index=="-1") {
			var soapIpAddr= arr[2];
			var soapPort= "";
		}
		else {
			var soapIpAddr= arr[2].substring(0,index);
			var soapPort= arr[2].substring(index+1,arr[2].length);
		}
		$('#webServiceAddress').val(soapIpAddr);
		$('#webServiceport').val(soapPort);
	}); 
    // 保存按钮
	$("#webServiceDataSaveBtn").click(function () {
		var webServiceCode=$("#webServiceCode").val().replace(/\ /g,"");
		if (webServiceCode=="") {
			$.messager.alert('提示',"请输入服务代码");
			return;
		}
		var webServiceName=$("#webServiceName").val().replace(/\ /g,"");
		if (webServiceName=="") {
			$.messager.alert('提示',"请输入服务名称");
			return;
		}
		var procuctionname=$("#webServiceProcuctionTerm").combobox('getText').replace(/\ /g,"");
		if (procuctionname=="") {
			$.messager.alert('提示',"请输入厂商名称");
			return;
		}
		var webServiceUrl=$("#webServiceUrl").val().replace(/\ /g,"");
		if (webServiceUrl=="") {
			$.messager.alert('提示',"请输入URL地址");
			return;
		}
		var webServiceClassName=$("#webServiceClassName").val().replace(/\ /g,"");
		if (webServiceClassName=="") {
			$.messager.alert('提示',"请输入保存路径");
			return;
		}
		var webServiceUseFlag=$('#webServiceUseFlag').combobox('getValue');
		if (webServiceUseFlag=="") {
			$.messager.alert('提示',"请选择使用标记");
			return;
		}
		var webServiceLangues=$("#webServiceLangues").combobox('getText').replace(/\ /g,"");
		if (webServiceLangues=="") {
			$.messager.alert('提示',"请选择开发语言");
			return;
		}
		var webServiceDesc=$("#webServiceDesc").val().replace(/\ /g,"");
		var serviceRemarks=$("#webServiceRemarks").val().replace(/\ /g,"");
		var ipAddress=$("#webServiceAddress").val().replace(/\ /g,"");
		var port=$("#webServiceport").val().replace(/\ /g,"")
		var webServiceUserName=$("#webServiceUserName").val().replace(/\ /g,"");
		var webServicePassWord=$("#webServicePassWord").val().replace(/\ /g,"");
		var webServiceInfo="input="+eventStatus+"&input="+webServiceCode+"&input="+webServiceDesc+"&input="+serviceRemarks+"&input="+ipAddress+"&input="+port;
		var webServiceInfo=webServiceInfo+"&input="+webServiceUrl+"&input="+webServiceName+"&input="+webServiceClassName+"&input="+webServiceUserName+"&input="+webServicePassWord;
		var webServiceInfo=webServiceInfo+"&input="+procuctionname+"&input="+webServiceUseFlag+"&input="+webServiceLangues;
		webServiceInfo=encodeURI(webServiceInfo);
		$.ajax({ 
			type: "POST",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveWebServiceData&"+webServiceInfo,
			dateType: "json",
			success: function(data){
				var dataInfo=data.replace(/[\r\n]/g,"^")
				var arr = new Array();
				arr = dataInfo.split("^^");
				var length=arr.length;
				var obj=eval('('+arr[length-1]+')');				
				if (obj.retvalue=="1") {  
					$.messager.alert('提示','保存成功',"",function(){
						reLoadEnsWebServiceClient(); 
						$('#configDetail').window('close');
				    });
				}
				else{  
					$.messager.alert('提示',obj.retinfo);
				}
			}
		}) 
	})  
    // 取消按钮
	$("#webServiceDataCancleBtn").click(function () {		
		if ($(this).linkbutton('options').disabled == true) {
			return;
		}
	    clearDetailContent();
    });	
})

function loadEnsWebServiceClient() {
    $('#webServiceClientListDg').datagrid({
        title:'WSDL地址列表',
        pagination:true,
        fit:true,
        nowrap: false,        
        fitCloumns: true,
        minimized:false,
        striped:true,
        cache:false, 
        method:'get',
        url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=webserviceclientlist',
        singleSelect:true,
		columns:[[   
		    {field:'id',title:'序号',sortable:true,width:40},   
		    {field:'code',title:'服务代码',sortable:true,width:120}, 
		    {field:'desc',title:'服务描述',width:300},  
		    {field:'pPackage',title:'存储路径',width:230},
		    {field:'serviceName',title:'代理类名称',width:120},
		    {field:'ipAddress',title:'IP地址',width:80},    
		    {field:'productionName',title:'厂商',sortable:true,width:200}, 
		    {field:'status',title:'状态',sortable:true,width:40,
		    	formatter:function(v,rec){
			    	var status="";
		    		if (rec.status=="Y") {
			    		status="运行";
		    		}
		    		else {
			    		status="停用";
		    		}
		    		return status;
		    	}		    
		    }, 
		    {field:'event',title:' ',float:'left',width:190,
		    	formatter:function(v,rec){ 
	                var editBtn = '<a href="#this" class="editcls" onclick="editRow('+(rec.id)+')">修改</a>';
	                var deleteBtn = '<a href="#this" class="deletecls" onclick="deleteRow('+(rec.id)+')">删除</a>';
	                if (rec.status=="Y") {
	                	var statusBtn = '<a href="#this" class="stopcls" onclick="updateStatus('+(rec.id)+')">停用</a>';
	                }
	                else {
	                	var statusBtn = '<a href="#this" class="startcls" onclick="updateStatus('+(rec.id)+')">运行</a>';
	                };
	                return editBtn+" "+deleteBtn+" "+statusBtn;
				}
		    }
		]],
		rowStyler: function(index,row){
			if (row.status == 'N'){
				return 'background-color:#6293BB;color:#fff;';
			}
		} ,
	    onLoadSuccess:function(data){  
	        $('.editcls').linkbutton({text:'编辑',plain:true,iconCls:'icon-edit'});
	        $('.deletecls').linkbutton({text:'删除',plain:true,iconCls:'icon-cancel'});
	        $('.stopcls').linkbutton({text:'停用',plain:true,iconCls:'icon-lock'});
	        $('.startcls').linkbutton({text:'运行',plain:true,iconCls:'icon-lock'});
	    }
    })
}

function editRow(id) {
    eventStatus="update";
	$('#webServiceDataCancleBtn').linkbutton('disable'); 
	$('#webServiceDataCancleBtn').attr("disabled",true);
	$.ajax({ 
		type: "get",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=webServiceClientDetail&input="+id,
		dateType: "json",
		success: function(data){
			var obj=eval('('+data+')');
			$('#webServiceCode').attr("readOnly",true);
			$('#webServiceCode').val(obj.serviceCode);
			$('#webServiceName').val(obj.serviceName);
			$('#webServiceDesc').val(obj.serviceDesc);
			$('#webServiceProcuctionTerm').combobox('select',obj.serviceProcuctionTerm);
			$('#webServiceUrl').val(obj.soapUrl);
			$('#webServiceAddress').val(obj.ipAddress);	
			$('#webServiceport').val(obj.port);	
			$('#webServiceUserName').val(obj.userName);	
			$('#webServicePassWord').val(obj.passWord);	
			$('#webServiceClassName').val(obj.className);			
			$('#webServiceLangues').combobox('select',obj.langues);
			$('#webServiceUseFlag').combobox('select',obj.useFlag);
			$('#webServiceRemarks').val(obj.serviceRemarks);	
			$('#methodDetail').window('open');
		}
	});	
	$('#configDetail').window('open');
}

function deleteRow(id) {
	$.ajax({ 
		type: "get",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=delEnsWebServiceClient&input="+id,
		dateType: "json",
		success: function(data){
			var dataInfo=data.replace(/[\r\n]/g,"^")
			var arr = new Array();
			arr = dataInfo.split("^^");
			var length=arr.length;
			var obj=eval('('+arr[length-1]+')');				
			if (obj.retvalue=="0") {  
				$.messager.alert('提示','删除成功',"",function(){
					reLoadEnsWebServiceClient(); 
			    });
			}
			else{  
				$.messager.alert('提示',obj.retinfo);
			}
		}
	});	

}

function updateStatus(id) {
	$.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm("操作提示", "您确定要执行修改操作吗？", function (data) {
	    if (data) {
		   $.ajax({ 
				type: "get",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=updateWebServiceClientStatus&input="+id,
				dateType: "json",
				success: function(data){
					var dataInfo=data.replace(/[\r\n]/g,"^")
					var arr = new Array();
					arr = dataInfo.split("^^");
					var length=arr.length
					var obj=eval('('+arr[length-1]+')');
					if (obj.retvalue=="1") {  
						$.messager.alert('提示','修改成功',"",function(){
							reLoadEnsWebServiceClient(); 
			    		});
					}
					else{  
						$.messager.alert('提示',obj.retinfo);
					}
				}
			}); 
		}else{
			
		}
	});
}

function clearDetailContent() {	
	var inputs = document.getElementById("configDetail").getElementsByTagName("input");  
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].type=="text"){
			if (inputs[i].id=="webServiceProcuctionTerm"){
			    $('#webServiceProcuctionTerm').combobox('clear');
			}
			else if (inputs[i].id=="webServiceLangues"){
				$('#webServiceLangues').combobox('clear');
			}
			else {
				inputs[i].value ="";
			}
		}
    }
    $('#webServiceUseFlag').combobox('setValue','Y');
	$('#webServiceRemarks').val("");    
}

function reLoadEnsWebServiceClient() {
	var code=$("#code").val().replace(/\ /g,"");
	var desc=$("#desc").val().replace(/\ /g,"");
	var ip=$("#ip").val().replace(/\ /g,"");
	var procuctionname=$('#procuctionname').combobox('getText').replace(/\ /g,"");
	var status=$('#status').combobox('getValue');
	var selectInfo=code+"^"+desc+"^"+ip+"^"+procuctionname+"^"+status;
	selectInfo=escape(selectInfo);
	$('#webServiceClientListDg').datagrid({ url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=webserviceclientlist&input="+selectInfo,method:"get"});
	$('#webServiceClientListDg').datagrid('load');
}