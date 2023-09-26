$(document).ready(function () {	
    $('#FromUom').textbox({
	    width:120
    })
    $('#ToUom').textbox({
	    width:120
    })
    $("#failcont").dialog({
		title:"�༭",
		width:500,
		height:250,
		closed:true
	})
	$("#confacdatagrid").datagrid({
		height:480,
		url:'dhcclinic.jquery.csp', 
        queryParams:{
            ClassName:"web.DHCCLDataCom",
            QueryName:"FindConFacData",
            Arg1:"",
            Arg2:"",
            ArgCnt:2
        },
        border:'true',
        singleSelect:true,
        columns:[[       
            {field:'CTCFRowId',title:'RowId',width:60},
            {field:'CTCFFrUOMDR',title:'CTCFFrUOMDR',width:150},    
            {field:'CTCFFrUOM',title:'�ӵ�λ',width:150},
            {field:'CTCFFactor',title:'ת��ϵ��',width:150},
            {field:'CTCFToUOM',title:'����λ',width:150},
            {field:'CTCFToUOMDR',title:'CTCFToUOMDR',width:150},            
            {field:'CTCFActiveFlag',title:'�����ʶ',width:150}
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
    	var queryParams = $("#confacdatagrid").datagrid('options').queryParams;
        queryParams.Arg1 = $("#FromUom").textbox('getValue');
        queryParams.Arg2 = $("#ToUom").textbox('getValue');
        $("#confacdatagrid").datagrid('reload');
     })
     $("#BtnClear").click(function(){
	     $.messager.confirm('��ȷ��', '��ȷ��Ҫ��յ�λת����������ݣ�', function (b) { 
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
                     ClassName:"web.DHCCLDataCom",
                     MethodName:"ImportUomConFac",
                     Arg1:"Clear",
                     Arg2:"",
                     ArgCnt:2
                 },
                 success:function (data, response, status) {
                     alert(data);
                     $("#confacdatagrid").datagrid('reload');
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
                ClassName:"web.DHCCLDataCom",
                MethodName:"ImportUomConFac",
                Arg1:"",
                Arg2:tempStr,
                ArgCnt:2
            },
            success:function (data, response, status) {
            if (data==0) {
                successnum=successnum+1;
            }   
            else {
	            failStr=failStr+"��"+i+"�д���Ϊ"+oSheet.Cells(i,1).value+",����Ϊ"+oSheet.Cells(i,2).value+"�ĵ�λת�������ݲ���ʧ�ܣ�ԭ��"+data+'\n';
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
	 $("#confacdatagrid").datagrid('reload');
	 oXL.Quit();
	 CollectGarbage();
	 
	 
}

