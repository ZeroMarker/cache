$(function(){
	loadEnsWebServiceClient();
    // 查询按钮
    $("#methodDataSelectBtn").click(function () {    
    	reLoadEnsInterfaceMethod();
    });  	
    
})

function reLoadEnsInterfaceMethod(){
	var methodCode=$('#methodCode').combobox('getText');
	var methodType=$('#type').combobox('getValue');	
	var inputContent=$("#inputContent").val().replace(/\ /g,"");
	var starttime=$("#starttime").combobox('getValue');
	var endtime=$("#endtime").combobox('getValue');
	var methodstatus=$('#status').combobox('getValue');	
	var selectInfo=methodCode+"^"+methodType+"^"+inputContent+"^"+starttime+"^"+endtime+"^"+methodstatus;
	$('#ensInterfaceListDg').datagrid({ url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ensInterfacelist&input="+selectInfo,method:"get"});
	$('#ensInterfaceListDg').datagrid('load');
}

function loadEnsWebServiceClient() {
    $('#ensInterfaceListDg').datagrid({
        title:'日志列表',
        pagination:true,
        fit:true,
        nowrap: false,        
        fitCloumns: true,
        minimized:false,
        striped:true,
        cache:false, 
        method:'get',
        url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ensInterfacelist&input=^^^^^N',
        singleSelect:true,
		columns:[[   
		    {field:'id',title:'序号',sortable:true,width:60},   
		    {field:'code',title:'方法代码',width:180},
		    /* 
		    {field:'desc',title:'方法描述',width:250},  
		    */
		    {field:'transferInClass',title:'方法使用类',width:170},  
		    {field:'transferInMethod',title:'方法使用名',width:100},  
		    {field:'input',title:'入参',width:300},
		    {field:'inputDesc',title:'入参描述',width:150},    
		    {field:'transferOuput',title:'返回值',width:300}, 
		    {field:'transferInsDate',title:'日期',sortable:true,width:80}, 
		    {field:'transferInsTime',title:'时间',sortable:true,width:80},
		    {field:'transferStatus',title:'状态',sortable:true,width:40,
		    	formatter:function(v,rec){
			    	var status="";
		    		if (rec.transferStatus=="Y") {
			    		status="成功";
		    		}
		    		else {
			    		status="失败";
		    		}
		    		return status;
		    	}		    
		    }
		]],
		rowStyler: function(index,row){
			if (row.transferStatus == 'N'){
				return 'background-color:#E93C20;color:#fff;';
			}
		}
    })
}
