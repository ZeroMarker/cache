 var tb;
	$(function(){
		//alert("regist")
		loadEnsWebServiceClient();
		
	})
	
	//显示新增模态框
	function showAddModal(){
		alert("show")
		$('#addServiceDialog').css('display','block');
		$('#addServiceDialog').window('open')
	}
	
	//保存新增服务信息
	function addService(){
		var serCode="";
		var sername=$('input[name="sername"]').val();//服务名称
		var serdesc=$('input[name="serdesc"]').val();//服务描述
		var serflag=$('#serflag').switchbox("getValue");//服务状态
		serflag = serflag==true?"Y":"N"
		var serhost=$('input[name="serhost"]').val();//服务IP
		var busCode=$('input[name="busCode"]').val();//总线代码
		var serport=$('input[name="serport"]').val();//服务端口
		var busCode=$('input[name="busCode"]').val();//总线代码
		var input=serCode+"^"+sername+"^"+serdesc+"^"+serhost+"^"+serflag+"^"+busCode+"^"+serport;
		input = encodeURI(input);
		
		//新增服务
		$.ajax({ 
			type: "POST",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=addService&input="+input,
			dateType: "json",
			success: function(data){
				var dataArr=data.split("^");		
				if (dataArr[0]=="1") {  
					$.messager.alert('提示','新增成功','info');
					//加载服务列表
					loadEnsWebServiceClient();
				}else{  
					$.messager.alert('提示','新增失败','error');
				}
			}
		}) 
	}
	
	
	function cancel(){
		$('#addServiceDialog').window('close');
	}


	/*初始化服务列表查询*/
	function initSearchbox(){
		$("#serviceBar").appendTo(".datagrid-toolbar table tbody tr");
		$("#serviceBar").css("display","inline-block");
	}
		
	//加载服务列表
	function loadEnsWebServiceClient() {
	    tb=$HUI.datagrid('#ServiceGrid', {
	        //title:'WSDL服务列表',
	        height:500,
	        pagination:true,
	        afterPageText:'页,共{pages}页', beforePageText:'第', displayMsg:'显示{from}到{to}条，共{total}条',
	        nowrap: false,        
	        fitCloumns: true,
	        minimized:false,
	        striped:true,
	        cache:false, 
	        method:'get',
	        url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ServiceList',
	        singleSelect:true,
			columns:[[ 
			    {field:'rowId',title:'序号',sortable:true,width:40},   
			    {field:'serCode',title:'服务代码',sortable:true,width:120}, 
			    {field:'serDesc',title:'服务名称',width:300},  
			    {field:'serNote',title:'服务描述',width:230},
			    {field:'serFlag',title:'服务状态',sortable:true,width:100,align:"center",
			    	formatter:function(v,rec){
				    	var status="";
			    		if (rec.serFlag=="Y") {
				    		status='<a href="#" name="run" class="status">运行</a>';
			    		}
			    	 	else {
				    		status='<a href="#" name="stop" class="status">停止</a>';
			    		} 
			    		return status;
				 	}   
			    },
			    {field:'serType',title:'服务类型',width:80},  
			    {field:'productionName',title:'更新',sortable:true,width:200,
			    	formatter:function(value,rowData,rowIndex){ 
			    		var editBtn = '<a href="#this" class="editSer" onclick="editRow('+rowIndex+')">编辑</a>';
		               	return editBtn
					}
			    }, 
			]],
		    onLoadSuccess:function(data){  
		        $('.editSer').linkbutton({text:'编辑',plain:true,iconCls:'icon-edit'});
		        $('a[name="run"]').addClass('run');
		        $('a[name="stop"]').addClass('stop');
		    }
	    })
	    $(initSearchbox());	
	}
	
	//查询
	function findService(){
		var busCode = "";
		var serCode = $("#serCode").val();    
		var serDesc = $("#serDesc").val();
		var serStatus = $("#serStatus").combobox("getValue");
		var serType = $("#serType").combobox("getValue");
		var seachPar = busCode+"^"+serCode+"^"+serDesc+"^"+serStatus+"^"+serType;
		$("#ServiceGrid").datagrid("load",{input:seachPar});
	   	$(initSearchbox());
	}

	
	//刷新
	function reloadService(){
		tb.reload();
	}
	
	
	//编辑
	function editRow(rowindex) {
		tb.selectRow(rowindex);
		var row = tb.getSelected();
		
		//显示编辑界面
		var ServObj={};
		ServObj.serCode=row['serCode'];//服务代码
		ServObj.serDesc=row['serDesc'];//服务名称
		ServObj.serNote=row['serNote'];//服务描述
		ServObj.serType = row['serType'];//服务类型
		ServObj.serFlag=row['serFlag'];//服务状态
		ServObj.serWsdl=row['serWsdl'];//服务地址
		ServObj.host=row['host'];//服务IP
		ServObj.port=row['port'];//服务端口
		ServObj.busCode=row['serBusCode'];//总线代码
		var url="enswebserviceedit.csp"
		$("body.service").empty();
		$("body.service").load(url,ServObj);
	} 
