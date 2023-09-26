$(document).ready(function () {	
    $('#WorkNo').textbox({
	    width:120
    })
    $('#Name').textbox({
	    width:120
    })
    $("#CtCpType").combogrid({
	    url:'dhcclinic.jquery.csp',
	    queryParams:{
           ClassName:"web.DHCCLDataCom",
           QueryName:"FindPrvTpData",
           ArgCnt:0
        },
        panelWidth: 160,
        loadMsg: "正在加载中...",
        width: 120,
        height:20,
        rownumbers: true,
        idField: "CTCPTRowId",
        textField: "CTCPTDesc",
        method:"post",	
        columns: [[
            { field: "CTCPTDesc", title: "描述",width:130},
            { field: "CTCPTRowId", title: "ID",width:40,hidden:true}
        ]]
    });	
    $("#Status").combogrid({
	    url:null,
        panelWidth: 120,
        loadMsg: "正在加载中...",
        width: 120,
        height:20,
        rownumbers: true,
        idField: "code",
        textField: "desc",	
        columns: [[
            { field: "desc", title: "状态",width:100}
        ]]
    });		
	var type=[
        {code:'Y',desc:'已激活'},
        {code:'N',desc:'未激活'}
		];
	$("#Status").combogrid("grid").datagrid("loadData",type);

    $("#failcont").dialog({
		title:"编辑",
		width:500,
		height:250,
		closed:true
	})
	$("#ctcpdatagrid").datagrid({
		height:480,
		url:'dhcclinic.jquery.csp', 
        queryParams:{
            ClassName:"web.DHCCLDataCom",
            QueryName:"FindImportCareProvData",
            Arg1:"",
            Arg2:"",
            Arg3:"",
            Arg4:"",
            ArgCnt:4
        },
        border:'true',
        singleSelect:true,
        columns:[[                
            {field:'RowId',title:'RowId',width:60}, 
            {field:'CtcpCode',title:'工号',width:120},    
            {field:'CtcpDesc',title:'姓名',width:120},
            {field:'CtcpType',title:'人员类型',width:120},    
            {field:'CtcpOtherName',title:'拼音检索码',width:120},            
            {field:'CtcpActiveFlag',title:'是否激活',width:120},
            {field:'CtcpDateActiveFrom',title:'生效日期',width:120},
            {field:'CtcpDateActiveTo',title:'截止日期',width:120}          
        ]],
        pagination:true,
        pageSize:15,
        pageNumber:1,
        pageList:[15,30,45,60]   
    });
    $("#import").click(function(){
	     var filePath=document.getElementById("textfield").value
	     ReadExcel(filePath);
	})
	$("#BtnFind").click(function(){
    	var queryParams = $("#ctcpdatagrid").datagrid('options').queryParams;
        queryParams.Arg1 = $("#WorkNo").textbox('getValue');
        queryParams.Arg2 = $("#Name").textbox('getValue');
        queryParams.Arg3 = $("#CtCpType").combogrid('getValue');
        queryParams.Arg4 = $("#Status").combogrid('getValue');
        $("#ctcpdatagrid").datagrid('reload');
     })
     $("#BtnClear").click(function(){
	     $.messager.confirm('请确认', '您确定要清空医护人员相关数据？', function (b) { 
         if (b==false)
         {
             return;
         }
         else
         {
             $.ajax({
                 url :"dhcclinic.jquery.method.csp",
                 type:"POST",
                 data:{
                     ClassName:"web.DHCCLImportData",
                     MethodName:"ImportCtcp",
                     Arg1:"Clear",
                     Arg2:"",
                     ArgCnt:2
                 },
                 success:function (data, response, status) {
                     alert(data);
                     $("#ctcpdatagrid").datagrid('reload');
                }
            
            })
        }       
        })
     })
})

function ReadExcel(filePath)
{
	 var successnum=0,failnum=0;
	 var failStr="";
	 var oXL=new ActiveXObject("Excel.Application"); 
	 var oWB=oXL.Workbooks.open(filePath);
	 oWB.worksheets(1).select(); 
	 var oSheet = oWB.ActiveSheet;
	 var rows=oSheet.UsedRange.Rows.Count;
	 var cols=oSheet.UsedRange.Columns.Count;
	 //alert(oSheet.UsedRange.Rows.Count); //有效行个数
     //alert(oSheet.UsedRange.Columns.Count);//有效列个数
     if(rows<2)
     {
	     alert("表格无数据!");
	     oXL.Quit();
	     CollectGarbage();
	     return;
	 }
     for(var i=2;i<(rows+1);i++)
     {
		 
		 var tempStr="";
		 for(var j=1;j<(cols+1);j++)
		 {
			 var transtr = typeof(oSheet.Cells(i,j).value)=="undefined"?"":oSheet.Cells(i,j).value;
			 if (tempStr=="") tempStr=transtr;
			 else tempStr=tempStr+"^"+transtr;
		 }	 
		 //alert(tempStr)
		 $.ajax({
            url :"dhcclinic.jquery.method.csp",
            async:false,
            type:"POST",
            data:{
                ClassName:"web.DHCCLImportData",
                MethodName:"ImportCtcp",
                Arg1:"",
                Arg2:tempStr,
                ArgCnt:2
            },
            success:function (data, response, status) {
            if (data==0) {
                successnum=successnum+1;
            }   
            else {
	            failStr=failStr+"第"+i+"行工号为"+oSheet.Cells(i,4).value+",姓名为"+oSheet.Cells(i,5).value+"的科室数据插入失败，原因："+data+'\n';
                failnum=failnum+1;
            }
           }
            
        })
	 }
     if(failStr.length>0)
     {
	      $("#failcont").dialog("open");
	      document.getElementById("cont").value="插入成功"+successnum+"条,失败"+failnum+"条\n"+failStr;
     }
     else{
	     alert("全部数据成功插入!");	     	     
	 }
	 $("#ctcpdatagrid").datagrid('reload');
	 oXL.Quit();
	 CollectGarbage();
	 
	 
}

