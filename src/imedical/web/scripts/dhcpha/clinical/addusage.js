    
	//??�???�?
	function addusagelist()
    {
		  
          var url='dhcpha.clinical.action.csp' ;
		  

		  var Request = new Object();
		  Request = GetRequest();
          var drugid = Request['drugid'];
		  var druginstdr = Request['druginstdr'];

		  $('#usagedata').datagrid({  
			  title:'??�???�?',
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'code', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:true,//�???
			  pageSize:15,
			  pageList:[15,30],
			  columns:[[     
			  {field:'code',title:'�???',width:60},   
			  {field:'desc',title:'??�?,width:200},
			  {field:'rowid',title:'rowid',width:200}
			  ]],
			  url:url,
			  queryParams: {
					action:'QueryInstrucDS'
			  },
			  onDblClickRow:function(rowIndex, rowData){ 

                 var usagerowid=rowData.rowid;
				 
			     AddUsageData(drugid,usagerowid);

 
			  }

		  });
        

		 $('#selusage').datagrid({  
			  title:'已�????�?',
			  bordr:false,
			  toolbar:"#usagedatatbar",
			  fit:true,
			  fitColumns:true,			 
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  pageSize:15,
			  pageList:[15,30],
			  columns:[[     
			  {field:'desc',title:'??�?,width:200},
			  {field:'rowid',title:'rowid',width:200}
			  ]],
			  url:url,
			  queryParams: {
				  	drugid:drugid,
					action:'QuerySelUsageDS'
			  }	,
			  onDblClickRow:function(rowIndex, rowData){ 

                 var rowid=rowData.rowid;

 				 $.messager.confirm('Confirm', '??�?�?�????�??��?��?????', function(r){
					if (r){
						 DelUsageData(rowid);
					}
				 });

			  }



		  });


        GetDrugInstMode();

		$("#btnUpdMode").click(function (e) { 
			
			    var mode=$('#ComboMode').combobox('getValue');
				if (mode=="")
				{
							$.messager.alert('??�???�?,'�???�??�为�?',"error");
							return;
				}
				var rows = $('#selusage').datagrid('getRows');
			    var rowcount=rows.length ;			   
			    if (rowcount==0) {
							$.messager.alert('??�???�?,'已�????�???记�?�??��?��??',"error");
							return;
				}
                
			    var input=mode ;
			    var _json = jQuery.param({ "action":"UpdateGolbalDrgData","drugid": drugid,"type":"usage","input":input });
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					//contentType: "charset=utf-8",
					cache: false,
					success: function (r, textStatus) {
							$.messager.alert('??�???�?,'?��?��????!',"info");
							return;
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});



         })

	    //�?????�?

		function AddUsageData(drugid,usagerowid)
		{

				var mode=$('#ComboMode').combobox('getValue');
				if (mode=="")
				{
							$.messager.alert('??�???�?,'�???�??�为�?',"error");
							return;
				}
			    var input=mode ;
			    var _json = jQuery.param({ "action":"AddGolbalDrgData","drugid": drugid,"optype":"usage","oprowid":usagerowid,"input":input });
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					//contentType: "charset=utf-8",
					cache: false,
					success: function (r, textStatus) {
						if (r.retvalue=="-99")
						{
							$.messager.alert('??�???�?,'�??��??�?�???!',"error");
							return;

						}
						reload();
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});

				//alert(request.responseText);
		}


	     //??????�?

		function DelUsageData(rowid)
		{
			    
			    var _json = jQuery.param({ "action":"DelUsageData","rowid":rowid });
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					cache: false,
					success: function (r, textStatus) {
						reload();
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});

				//alert(request.responseText);
		}

     //?��??rid
     function reload()
		{
	   		 $('#selusage').datagrid('load',  {  
					drugid:drugid,
					action:'QuerySelUsageDS'
			 });
		}


        //?��??�???
		function GetDrugInstMode()
		{
			    
			    var _json = jQuery.param({ "action":"GetDrugInstMode","drugid":drugid,"type":"usage" });
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					cache: false,
					success: function (r, textStatus) {
						
						$('#ComboMode').combobox('select', r.data)
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});

				//alert(request.responseText);
		}



    }


