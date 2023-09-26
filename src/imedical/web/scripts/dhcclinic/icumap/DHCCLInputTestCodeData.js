$(document).ready(function () {	
    $('#Code').textbox({
	    width:120
    })
    $('#Desc').textbox({
	    width:120
    })
    $("#failcont").dialog({
		title:"编辑",
		width:500,
		height:250,
		closed:true
	})
	$("#testcodedatagrid").datagrid({
		height:480,
		url:'dhcclinic.jquery.csp', 
        queryParams:{
            ClassName:"web.DHCCLDataCom",
            QueryName:"FindLabTestCodeData",
            Arg1:"",
            Arg2:"",
            ArgCnt:2
        },
        border:'true',
        singleSelect:true,
        columns:[[
            {field:'CLCLTCRowId',title:'RowId',width:60}, 
            {field:'CLCLTCCode',title:'代码',width:150},    
            {field:'CLCLTCDesc',title:'描述',width:150},
            {field:'CLCLTCAbbrev',title:'英文缩写',width:150},
            {field:'CLCLTCStandardCode',title:'标准代码',width:150}
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
    	var queryParams = $("#testcodedatagrid").datagrid('options').queryParams;
        queryParams.Arg1 = $("#Code").textbox('getValue');
        queryParams.Arg2 = $("#Desc").textbox('getValue');
        $("#testcodedatagrid").datagrid('reload');
     })
     $("#BtnClear").click(function(){
	     $.messager.confirm('请确认', '您确定要清空检验项目表相关数据？', function (b) { 
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
                     MethodName:"ImportLabTestCode",
                     Arg1:"Clear",
                     Arg2:"",
                     ArgCnt:2
                 },
                 success:function (data, response, status) {
                     alert(data);
                     $("#testcodedatagrid").datagrid('reload');
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
                ClassName:"web.DHCCLDataCom",
                MethodName:"ImportLabTestCode",
                Arg1:"",
                Arg2:tempStr,
                ArgCnt:2
            },
            success:function (data, response, status) {
            if (data==0) {
                successnum=successnum+1;
            }   
            else {
	            failStr=failStr+"第"+i+"行代码为"+oSheet.Cells(i,1).value+",描述为"+oSheet.Cells(i,2).value+"的检验项目数据插入失败，原因："+data+'\n';
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
	 $("#testcodedatagrid").datagrid('reload');
	 oXL.Quit();
	 CollectGarbage();
	 
	 
}

