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
        loadMsg: "���ڼ�����...",
        width: 120,
        height:20,
        rownumbers: true,
        idField: "ARCICRowId",
        textField: "ARCICDesc",
        method:"post",	
        columns: [[
            { field: "ARCICDesc", title: "����",width:130},
            { field: "ARCICRowId", title: "ID",width:40,hidden:true}
        ]]
    });	
    
    $("#failcont").dialog({
		title:"�༭",
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
            {field:'ARCIMCode',title:'����',width:120},          
            {field:'ARCIMDesc',title:'����',width:120},            
            {field:'ARCIMGenericDesc',title:'ͨ����',width:120},
            {field:'itemCat',title:'ҽ���ӷ���',width:120},
            {field:'billUnit',title:'��λ',width:120},
            {field:'ARCIMUpdateDate',title:'��������',width:120},
            {field:'ARCIMUpdateTime',title:'����ʱ��',width:120}        
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
	 //alert(oSheet.UsedRange.Rows.Count); //��Ч�и���
     //alert(oSheet.UsedRange.Columns.Count);//��Ч�и���
     if(rows<2)
     {
	     alert("���������!");
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
	            failStr=failStr+"��"+i+"�д���Ϊ"+oSheet.Cells(i,2).value+",����Ϊ"+oSheet.Cells(i,3).value+"��ҽ��ҩƷ���ݲ���ʧ�ܣ�ԭ��"+data+'\n';
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
	 $("#arcimdatagrid").datagrid('reload');
	 oXL.Quit();
	 CollectGarbage();
	 
	 
}

