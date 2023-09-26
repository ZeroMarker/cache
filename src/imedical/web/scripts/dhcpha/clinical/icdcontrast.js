    function InitDiseaseList()
    {
		  var url="dhcpha.clinical.action.csp" ;

		  $('#diseasedata').datagrid({  
			  //title:'??????�?',
			  //bordr:false,
			  fit:true,
			  toolbar:"#diseasedatatbar",
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  //nowrap: false,
			  striped: true, 
			  pagination:true,
			  //rownumbers:true,//�???
			  pageSize:15,
			  pageList:[15,30],
			  //height:450,
			  rowStyler:function(index,row){
				  //return 'height:1.5em;';
			  },
			  columns:[[     
			  {field:'code',title:'�???',hidden:true},   
			  {field:'desc',title:'??�?,width:200},
              {field:'rowid',title:'rowid',hidden:true}
			  ]],
			  url:url,
			  queryParams: {
					action: 'QueryICD'
			  },
			  onDblClickRow:function(rowIndex, rowData){ 

                 var icdrowid=rowData.rowid;

			     AddICDData(icdrowid);

 
			  }

		  });
        

		 $('#seldisease').datagrid({  
			  title:'对�????�???�?(??�????��???对�??)',
			  bordr:false,
			  fit:true,
			  toolbar:"#seldiseasetbar",
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  pageSize:15,
			  pageList:[15,30],
			  url:url,
			  queryParams: {
					action: 'QueryContrastICDDs'
			  },
			  columns:[[       
			  {field:'desc',title:'??�?,width:200},
			  {field:'icdflag',title:'ICD',width:60},
			  {field:'keyflag',title:'?��??�?',width:60},
			  {field:'actflag',title:'????',width:60},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]],
			  onDblClickRow:function(rowIndex, rowData){ 

                 var icdrowid=rowData.rowid;


				 $.messager.confirm('Confirm', '??�?�?�??��?��???��?��??????/�????????', function(r){
					if (r){
						DelICDData(icdrowid);
					}
				 });
			     

 
			  },
			  onClickRow:function(rowIndex, rowData){ 

                 var rowid=rowData.rowid;

                 reloaditm(rowid) ;
			     

 
			  },
          	  onLoadSuccess:function() {
				  	   var rows = $('#seldisease').datagrid('getRows');
			           var rowcount=rows.length ;			   
			           if (rowcount==0) return;
					   $('#seldisease').datagrid('selectRow', 0);
              }

		  });


	     $('#seldiseaseitm').datagrid({  
			  title:'?��??�?????�???�?',
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  pageSize:15,
			  pageList:[15,30],
			  url:url,
			  queryParams: {
					action: 'QueryContrastItmDs'
			  },
			  columns:[[       
			  {field:'desc',title:'??�?,width:200},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]],
			  onDblClickRow:function(rowIndex, rowData){ 

                 var rowid=rowData.rowid;


				 $.messager.confirm('Confirm', '??�?�?�????�??��?��?????', function(r){
					if (r){
						DelItmData(rowid);
					}
				 });
			     

 
			  }


		  });

        
		 
		$("#btnFindIcd").click(function (e) { 
			
				var desc=$.trim($("#TxtICDDesc").val());
				$('#diseasedata').datagrid('load',  {  
					action: 'QueryICD',
					input:desc
			    });


         })

        //�???对�??
		$("#btnAddIcd").click(function (e) { 
			
				var _json = jQuery.param({ "action":"ContrastAllICD"});
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


         })
   
        //??诣׷�对�??
		$("#btnFind").click(function (e) { 
			
             reload();


         })
         
		//�???????
		$("#btnAdd").click(function (e) { 
                
			    var desc=$.trim($("#TxtDesc").val());
				var keyflag="N";
				if ($('#chkkeyflag').attr('checked'))
				{
					var keyflag="Y" ;
				}
				if (desc=="")
	            {		
					    $.messager.alert('??�???�?,'请�??�?????�?',"error");
						return;
	            }
				var input=desc+"^"+keyflag ;
				
				var _json = jQuery.param({ "action":"AddContrastDesc","input":input});
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
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


         })

		 //�???对�??

		function AddICDData(icdrowid)
		{
			    var main="";
			    var selectedrow = $("#seldisease").datagrid("getSelected"); 
				if (selectedrow)
				{
					var main=selectedrow.rowid ;
				}
                if (main=="")
                {
					$.messager.alert('??�???�?,'请�????对�????�?�???�?记�?!',"error");
					return;
                }


			    var _json = jQuery.param({ "action":"AddICD","icdrowid": icdrowid ,"main":main});
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
						reloaditm(main);
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
		 	 var desc=$.trim($("#TxtDesc").val());
			 $('#seldisease').datagrid('load',  {  
					action: 'QueryContrastICDDs',
					input:desc
			    });

		}




	    //???对�??

		function DelICDData(rowid)
		{
			    
			    var _json = jQuery.param({ "action":"DelICDData", "rowid": rowid });
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					//contentType: "charset=utf-8",
					cache: false,
					success: function (r, textStatus) {

						reload();
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
					
						}
				});

				
		}




     //?��??rid
     function reloaditm(rowid)
	 {

			 $('#seldiseaseitm').datagrid('load',  {  
					action: 'QueryContrastItmDs',
					rowid:rowid
			    });

		}


        //???????�?�?�??????��??
		function DelItmData(rowid)
		{
			    
			    var _json = jQuery.param({ "action":"DelContrastItm", "rowid": rowid });
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
							$.messager.alert('??�???�?,'�?记�???ICD,�??��???,请�??对�????�?�????!',"error");
							return;

						}
						reloaditm(rowid);
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
					
						}
				});

				
		}








    }


