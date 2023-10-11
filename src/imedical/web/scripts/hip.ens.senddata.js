var eventStatus="";
$(function(){
    $("#dataAddBtn").click(function () { 
    	eventStatus="add";
    	clearDetailContent();
		$('#methodCode').attr("readOnly",false);
		$('#sendDataDetail').window('open'); 
    })
    $("#sendDataCancleBtn").click(function () { 
    	clearDetailContent();
    })
    $("#methodCode").combobox({
		onChange: function (n,o) {
			var methodId=$('#methodCode').combobox('getValue');
			$.ajax({ 
				type: "POST",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodDetail&input="+methodId,
				dateType: "json",
				success: function(data){
					var obj=eval('('+data+')');
					$('#methodDesc').val(obj.methodDesc);
					$('#methodClassName').val(obj.methodClassName);
					$('#methodName').val(obj.methodName)
				}
			})
		}
	});  
    $("#sendDataSaveBtn").click(function () { 
		var methodId=$('#methodCode').combobox('getValue');
		if (methodId=="") {
			$.messager.alert('提示',"请选择方法代码");
			return;
		}	
		var methodStatus=$('#methodStatus').combobox('getValue');
		if (methodStatus=="") {
			$.messager.alert('提示',"请选择当前状态");
			return;
		}		
		var methodFreq=$('#methodFreq').combobox('getValue');
		if (methodFreq=="") {
			$.messager.alert('提示',"请选择频率");
			return;
		}	
		var methodWeeks=$('#methodWeeks').combobox('getValue');
		var methodDays=$('#methodDays').combobox('getValue');
		var methodTimes=$("#methodTimes").val().replace(/\ /g,"");
		if (methodTimes=="") {
			$.messager.alert('提示',"请输入同步时间");
			return;
		} 
		var methodNotes=$("#methodNotes").val().replace(/\ /g,"");
		var ensDataFormat=$("#ensDataFormat").val().replace(/\ /g,"");		
		var sendDataInfo=eventStatus+"^"+methodId+"^"+methodStatus+"^"+methodFreq+"^"+methodWeeks;
		sendDataInfo=sendDataInfo+"^"+methodDays+"^"+methodTimes+"^"+methodNotes+"^"+ensDataFormat;
		sendDataInfo=encodeURI(sendDataInfo);
		$.ajax({ 
			type: "POST",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveEnsSendDataInfo&input="+sendDataInfo,
			dateType: "json",
			success: function(data){
				var obj=eval('('+data+')');
				if (obj.retvalue=="1") {  
					$.messager.alert('提示','保存成功',"",function(){
						$('#sendDataDetail').window('close');
						reLoadEnsSendData();
				    });
				}
				else{  
					$.messager.alert('提示',obj.retinfo);
				}				
			}
		}) 
    })
	loadEnsSendData();
    // 查询按钮
    $("#dataSelectBtn").click(function () {    
    	reLoadEnsSendData();
    });    
})

function reLoadEnsSendData(){
	var methodId=$('#code').combobox('getValue');
	var methodStatus=$('#status').combobox('getValue');	
	var methodFreqs=$("#freq").combobox('getValue');
	var selectInfo=methodId+"^"+methodStatus+"^"+methodFreqs;
	$('#ensSenDataListDg').datagrid({ url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ensSendDatalist&input="+selectInfo,method:"get"});
	$('#ensSenDataListDg').datagrid('load');
}

function loadEnsSendData() {
    $('#ensSenDataListDg').datagrid({
        title:'数据列表',
        pagination:true,
        fit:true,
        nowrap: false,        
        fitCloumns: true,
        minimized:false,
        striped:true,
        cache:false, 
        method:'get',
        url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ensSendDatalist',
        singleSelect:true,
		columns:[[   
		    {field:'id',title:'序号',sortable:true,width:60},   
		    {field:'code',title:'方法代码',width:180},
		    {field:'desc',title:'方法描述',width:250},   
		    {field:'freq',title:'频率',width:60,
		    	formatter:function(v,rec){
			    	var freq="";
		    		if (rec.freq=="Day") {
			    		freq="每天";
		    		}
		    		if (rec.freq=="Week") {
			    		freq="每周";
		    		}
		    		if (rec.freq=="Month") {
			    		freq="每月";
		    		}
		    		if (rec.freq=="Year") {
			    		freq="每年";
		    		}
		    		return freq;
		    	}},
		    {field:'status',title:'状态',sortable:true,width:40,
		    	formatter:function(v,rec){
			    	var status="";
		    		if (rec.status=="Y") {
			    		status="运行";
		    		}
		    		else {
			    		status="停止";
		    		}
		    		return status;
		    	}		    
		    }, 
		    {field:'event',title:' ',float:'left',width:200,
		    	formatter:function(v,rec){ 
	                var editBtn = '<a href="#this" class="editcls" onclick="editRow('+(rec.id)+')">修改</a>';
	                var deleteBtn = '<a href="#this" class="deletecls" onclick="deleteRow('+(rec.id)+')">删除</a>';
	                if (rec.status=="Y") {
	                	var statusBtn = '<a href="#this" class="stopcls" onclick="updateStatus('+(rec.id)+')">停用</a>';
	                }
	                else {
	                	var statusBtn = '<a href="#this" class="startcls" onclick="updateStatus('+(rec.id)+')">运行</a>';
	                }

                	var sendBtn = '<a href="#this" class="startcls" onclick="ensSendData('+(rec.methodId)+')">同步数据</a>';
	                return editBtn+" "+deleteBtn+" "+statusBtn+" "+sendBtn;
				}
		    }
		]],
		rowStyler: function(index,row){
			if (row.status == 'N'){
				return 'background-color:#6293BB;color:#fff;';
			}
		}
    })
}

function editRow(id) {
    eventStatus="update";
	$('#methodDataCancleBtn').linkbutton('disable'); 
	$('#methodDataCancleBtn').attr("disabled",true);
	$('#methodInputAddBtn').attr("disabled",false);
	arrayObj=[];
	outputNote="";
	$.ajax({ 
		type: "get",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ensSendDataDetail&input="+id,
		dateType: "json",
		success: function(data){
			var obj=eval('('+data+')');
			$('#methodCode').attr("readOnly",true);
			$('#methodCode').combobox('setValue',obj.methodId);
			$('#methodDesc').val(obj.methodDesc);
			$('#methodClassName').val(obj.methodClassName);
			$('#methodName').val(obj.methodName);
			$('#ensDataFormat').val(obj.ensDataFormat);
		    $('#methodNotes').val(obj.methodNotes);
		    $('#methodStatus').combobox('setValue',obj.methodStatus);
			$("#methodFreq").combobox('setValue',obj.methodFreq);
			$("#methodWeeks").combobox('setValue',obj.methodWeeks);
			$('#sendDataDetail').window('open');
		}
	});
}

function clearDetailContent() {
    $('#methodCode').combobox('setValue',''); 
    $('#methodDesc').val("");
    $('#methodClassName').val("");
	$('#methodName').val("");  
	$('#ensDataFormat').val("");
    $('#methodNotes').val("");
    $('#methodStatus').combobox('setValue','Y');
	$("#methodFreq").combobox('setValue',"Day");
	$("#methodWeeks").combobox('setValue',"1");
	$('#methodTimes').val("00:00");	
}

function updateStatus(id) {
	$.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm("操作提示", "您确定要执行修改操作吗？", function (data) {
	    if (data) {
		   $.ajax({ 
				type: "get",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=updateSendDataStatus&input="+id,
				dateType: "json",
				success: function(data){
					var dataInfo=data.replace(/[\r\n]/g,"^")
					var arr = new Array();
					arr = dataInfo.split("^^");
					var length=arr.length
					var obj=eval('('+arr[length-1]+')');
					if (obj.retvalue=="1") {  
						$.messager.alert('提示','修改成功',"",function(){
							reLoadEnsSendData(); 
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

function deleteRow(id) {
	$.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
        if (data) {
	        $.ajax({ 
				type: "get",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=delSendData&input="+id,
				dateType: "json",
				success: function(data){
					var dataInfo=data.replace(/[\r\n]/g,"^")
					var arr = new Array();
					arr = dataInfo.split("^^");
					var length=arr.length
					var obj=eval('('+arr[length-1]+')');
					if (obj.retvalue=="1") {
						$.messager.alert('提示','删除成功',"",function(){
							reLoadEnsSendData(); 
				    	});
					}
					else{  
						$.messager.alert('提示',obj.retinfo);
					}
				}
			});
        }
    });
}

function ensSendData(id) {
	$.ajax({
		type : "get",   
		url : "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=expandMethodDetail&input="+id,   
		dataType: "json",   
		success : function(data) {
			var detailHtml="<table style='width:600px;color:blue;font-size:12px;font-weight:bold;margin:15 auto;'>"; 
			$.each(data,function(i,list){
				detailHtml+="<tr><td>调用方法：</td><td>"+list.methodPublishClassName+"</td></tr>";	
				var arr = new Array();
				var inputInfo=list.methodInputDesc
				arr = inputInfo.split(",");
				var length=arr.length
				for (i=0;i<length;i++) {
					var inputdesc=arr[i];
					var ar= inputdesc.split(":");
					if (ar[0]=="KeyName(固定值)") {
						detailHtml+="<tr><td style='width:80px'>"+ar[0]+"：</td><td><input class='textbox' type='text' id='"+ar[0]+"' style='width:520px' value='"+ar[1]+"'></input></td></tr>";
					}
					else {
						detailHtml+="<tr><td style='width:80px'>"+ar[0]+"：</td><td><input class='textbox' type='text' id='"+ar[0]+"' style='width:520px'></input></td></tr>";
					}
				}
				detailHtml+="<tr><td></td><td style='text-align:right;'><a id='testBtn' href='#' class='easyui-linkbutton'>同步</a></td></tr>"
				
				detailHtml+="<tr><td>结果：</td><td><label id='ttile'></label></td></tr>";
			}); 
			detailHtml+="</table>"; 
			$('#testMethod').html(detailHtml);
		    $('#testBtn').linkbutton({   
			    iconCls: 'icon-ok'  
			}); 
		    $('#testBtn').bind('click', function(){
				var inputInfo="";
				var inputs = document.getElementById("testMethod").getElementsByTagName("input");  
				for(var i=0;i<inputs.length;i++){
					if(inputs[i].type=="text"){
						inputInfo=inputInfo+"&input="+inputs[i].value;
					}
				} 	
				inputInfo="input="+id+inputInfo	
				$.ajax({
					type: "get",
					url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=testMethodResult&"+inputInfo,
					dateType: "json",
					async: false,
					success: function(data){
						var dataInfo=data.replace(/[\r\n]/g,"^")
						var arr = new Array();
						arr = dataInfo.split("^^");
						var length=arr.length
						var obj=eval('('+arr[length-1]+')');
						var detailHtml="<table style='width:500px;color:blue;font-size:12px;font-weight:bold;margin:15 auto;'>"; 
						detailHtml+="<tr><td>"+obj.retinfo+"</td></tr>";
						//detailHtml+="<tr><td>"+inputInfo+"</td></tr>";
						detailHtml+="</table>"; 
						document.getElementById("ttile").innerHTML=detailHtml  
					}
				})
		    }); 
		}
	})  
	$('#testMethod').window('open');
}

	
