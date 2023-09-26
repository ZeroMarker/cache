$(document).ready(function () {	
    $('#ArcimCode').textbox({
	    width:120
    })
    $('#ArcimDesc').textbox({
	    width:120
    })
    $("#ArcimCat").combogrid({
	    url:'dhcclinic.jquery.csp',
	    queryParams:{
           ClassName:"web.DHCCLDataCom",
           QueryName:"FindARCItemCatData",
           Arg1:"",
           Arg2:"",
           ArgCnt:2
        },
        panelWidth: 160,
        loadMsg: "正在加载中...",
        width: 120,
        height:20,
        rownumbers: true,
        idField: "ARCICRowId",
        textField: "ARCICDesc",
        method:"post",	
        columns: [[
            { field: "ARCICDesc", title: "描述",width:130},
            { field: "ARCICRowId", title: "ID",width:40,hidden:true}
        ]]
    });	
    
    $("#failcont").dialog({
		title:"编辑",
		width:500,
		height:250,
		closed:true
	})
	$("#arcimdatagrid").datagrid({
		height:480,
		url:'dhcclinic.jquery.csp', 
        queryParams:{
            ClassName:"web.DHCCLDataCom",
            QueryName:"FindImportArcimData",
            Arg1:"",
            Arg2:"",
            Arg3:"",
            ArgCnt:3
        },
        border:'true',
        singleSelect:true,
        columns:[[                
            {field:'rowid',title:'rowid',width:120}, 
            {field:'ARCIMCode',title:'代码',width:120},          
            {field:'ARCIMDesc',title:'描述',width:120},            
            {field:'ARCIMGenericDesc',title:'通用名',width:120},
            {field:'itemCat',title:'医嘱子分类',width:120},
            {field:'billUnit',title:'单位',width:120},
            {field:'ARCIMUpdateDate',title:'更新日期',width:120},
            {field:'ARCIMUpdateTime',title:'更新时间',width:120}        
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
    	var queryParams = $("#arcimdatagrid").datagrid('options').queryParams;
        queryParams.Arg1 = $("#ArcimCode").textbox('getValue');
        queryParams.Arg2 = $("#ArcimDesc").textbox('getValue');
        queryParams.Arg3 = $("#ArcimCat").combogrid('getValue');
        $("#arcimdatagrid").datagrid('reload');
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
                     MethodName:"ImportArcim",
                     Arg1:"Clear",
                     Arg2:"",
                     ArgCnt:2
                 },
                 success:function (data, response, status) {
                     alert(data);
                     $("#arcimdatagrid").datagrid('reload');
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
	 var rowact=0;
	 for(var k=2;k<(rows+1);k++)
	 {
		 if(typeof(oSheet.Cells(k,1).value)!="undefined") rowact=rowact+1;
	 }
     for(var i=1;i<(rowact+1);i++)
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
                MethodName:"ImportArcim",
                Arg1:"",
                Arg2:tempStr,
                ArgCnt:2
            },
            success:function (data, response, status) {
            if (data==0) {
                successnum=successnum+1;
            }   
            else {
	            failStr=failStr+"第"+i+"行代码为"+oSheet.Cells(i,2).value+",描述为"+oSheet.Cells(i,3).value+"的医嘱药品数据插入失败，原因："+data+'\n';
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
	 $("#arcimdatagrid").datagrid('reload');
	 oXL.Quit();
	 CollectGarbage();
	 
	 
}

