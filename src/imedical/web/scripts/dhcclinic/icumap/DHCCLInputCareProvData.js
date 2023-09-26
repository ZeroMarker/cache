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
        loadMsg: "���ڼ�����...",
        width: 120,
        height:20,
        rownumbers: true,
        idField: "CTCPTRowId",
        textField: "CTCPTDesc",
        method:"post",	
        columns: [[
            { field: "CTCPTDesc", title: "����",width:130},
            { field: "CTCPTRowId", title: "ID",width:40,hidden:true}
        ]]
    });	
    $("#Status").combogrid({
	    url:null,
        panelWidth: 120,
        loadMsg: "���ڼ�����...",
        width: 120,
        height:20,
        rownumbers: true,
        idField: "code",
        textField: "desc",	
        columns: [[
            { field: "desc", title: "״̬",width:100}
        ]]
    });		
	var type=[
        {code:'Y',desc:'�Ѽ���'},
        {code:'N',desc:'δ����'}
		];
	$("#Status").combogrid("grid").datagrid("loadData",type);

    $("#failcont").dialog({
		title:"�༭",
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
            {field:'CtcpCode',title:'����',width:120},    
            {field:'CtcpDesc',title:'����',width:120},
            {field:'CtcpType',title:'��Ա����',width:120},    
            {field:'CtcpOtherName',title:'ƴ��������',width:120},            
            {field:'CtcpActiveFlag',title:'�Ƿ񼤻�',width:120},
            {field:'CtcpDateActiveFrom',title:'��Ч����',width:120},
            {field:'CtcpDateActiveTo',title:'��ֹ����',width:120}          
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
	     $.messager.confirm('��ȷ��', '��ȷ��Ҫ���ҽ����Ա������ݣ�', function (b) { 
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
	 //alert(oSheet.UsedRange.Rows.Count); //��Ч�и���
     //alert(oSheet.UsedRange.Columns.Count);//��Ч�и���
     if(rows<2)
     {
	     alert("���������!");
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
	            failStr=failStr+"��"+i+"�й���Ϊ"+oSheet.Cells(i,4).value+",����Ϊ"+oSheet.Cells(i,5).value+"�Ŀ������ݲ���ʧ�ܣ�ԭ��"+data+'\n';
                failnum=failnum+1;
            }
           }
            
        })
	 }
     if(failStr.length>0)
     {
	      $("#failcont").dialog("open");
	      document.getElementById("cont").value="����ɹ�"+successnum+"��,ʧ��"+failnum+"��\n"+failStr;
     }
     else{
	     alert("ȫ�����ݳɹ�����!");	     	     
	 }
	 $("#ctcpdatagrid").datagrid('reload');
	 oXL.Quit();
	 CollectGarbage();
	 
	 
}

