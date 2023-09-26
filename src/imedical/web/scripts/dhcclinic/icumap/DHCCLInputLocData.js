$(document).ready(function () {	
    $('#Code').textbox({
	    width:120
    })
    $('#Desc').textbox({
	    width:120
    })
    $("#Type").combogrid({
	    url:null,
        panelWidth: 120,
        loadMsg: "正在加载中...",
        width: 120,
        height:20,
        rownumbers: true,
        idField: "code",
        textField: "desc",	
        columns: [[
            { field: "desc", title: "服务类型",width:100}
        ]]
    });		
	var type=[
        {code:'W',desc:'Ward'},
        {code:'E',desc:'Execute'},
        {code:'DI',desc:'DrugInjection'},
        {code:'D',desc:'Dispensing'},
        {code:'C',desc:'Cashier'},
        {code:'O',desc:'Other'},
        {code:'OP',desc:'OperatingTheatre'},
        {code:'EM',desc:'Emergency'},
        {code:'DS',desc:'DaySurgery'},
        {code:'MR',desc:'MedicalRecords'},
        {code:'OR',desc:'OutPatientConsultingRoom'},
        {code:'CL',desc:'Clinic'},
        {code:'ADM',desc:'AdmissionPoint'}
		];
	$("#Type").combogrid("grid").datagrid("loadData",type);

    $("#failcont").dialog({
		title:"编辑",
		width:500,
		height:250,
		closed:true
	})
	$("#locdatagrid").datagrid({
		height:480,
		url:'dhcclinic.jquery.csp', 
        queryParams:{
            ClassName:"web.DHCCLDataCom",
            QueryName:"FindImportLocData",
            Arg1:"",
            Arg2:"",
            Arg3:"",
            ArgCnt:3
        },
        border:'true',
        singleSelect:true,
        columns:[[                
            {field:'RowId',title:'RowId',width:120}, 
            {field:'LocCode',title:'代码',width:120},    
            {field:'LocDesc',title:'描述',width:120},    
            {field:'LocType',title:'科室类型',width:120},
            {field:'HospitalCode',title:'医院代码',width:120},
            {field:'LocTel',title:'电话',width:120,hidden:true},
            {field:'LocContactName',title:'科室检索码',width:120},
            {field:'ActiveDate',title:'生效日期',width:120},
            {field:'ActiveDateTo',title:'截止日期',width:120}     
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
    	var queryParams = $("#locdatagrid").datagrid('options').queryParams;
        queryParams.Arg1 = $("#Code").textbox('getValue');
        queryParams.Arg2 = $("#Desc").textbox('getValue');
        queryParams.Arg3 = $("#Type").combogrid('getValue');
        $("#locdatagrid").datagrid('reload');
     })
     $("#BtnClear").click(function(){
	     $.messager.confirm('请确认', '您确定要清空科室相关数据？', function (b) { 
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
                     MethodName:"ImportCtloc",
                     Arg1:"Clear",
                     Arg2:"",
                     ArgCnt:2
                 },
                 success:function (data, response, status) {
                     alert(data);
                     $("#locdatagrid").datagrid('reload');
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
	     return;
	 }
     for(var i=2;i<(rows+1);i++)
     {
	     /*if(oSheet.Cells(i,2).value =="null")
	     {
		     alert("第"+i+"行的"+oSheet.Cells(1,1).value+"对应单元格不能为空!");
		     return;
		 }
		 if(oSheet.Cells(i,3).value =="null")
	     {
		     alert("第"+i+"行的"+oSheet.Cells(1,2).value+"对应单元格不能为空!");
		     return;
		 }
		 if(oSheet.Cells(i,4).value =="null")
	     {
		     alert("第"+i+"行的"+oSheet.Cells(1,3).value+"对应单元格不能为空!");
		     return;
		 }
		 if(oSheet.Cells(i,8).value =="null")
	     {
		     alert("第"+i+"行的"+oSheet.Cells(1,7).value+"对应单元格不能为空!");
		     return;
		 }*/
		 
		 var tempStr="";
		 for(var j=1;j<(cols+1);j++)
		 {
			 var transtr = typeof(oSheet.Cells(i,j).value)=="undefined"?"":oSheet.Cells(i,j).value;
			 if (tempStr=="") tempStr=transtr;
			 else tempStr=tempStr+"^"+transtr;
		 }	 
		 $.ajax({
            url :"dhcclinic.jquery.method.csp",
            async:false,
            type:"POST",
            data:{
                ClassName:"web.DHCCLImportData",
                MethodName:"ImportCtloc",
                Arg1:"",
                Arg2:tempStr,
                ArgCnt:2
            },
            success:function (data, response, status) {
            if (data==0) {
                successnum=successnum+1;
            }   
            else {
	            failStr=failStr+"第"+i+"行代码为"+oSheet.Cells(i,2).value+",描述为"+oSheet.Cells(i,3).value+"的科室数据插入失败，原因："+data+'\n';
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
	 $("#locdatagrid").datagrid('reload');
	 oXL.Quit();
	 CollectGarbage();
	 
	 
}

