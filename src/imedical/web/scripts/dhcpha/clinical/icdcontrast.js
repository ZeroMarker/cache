    function InitDiseaseList()
    {
		  var url="dhcpha.clinical.action.csp" ;

		  $('#diseasedata').datagrid({  
			  //title:'??????è¡?',
			  //bordr:false,
			  fit:true,
			  toolbar:"#diseasedatatbar",
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  //nowrap: false,
			  striped: true, 
			  pagination:true,
			  //rownumbers:true,//è¡???
			  pageSize:15,
			  pageList:[15,30],
			  //height:450,
			  rowStyler:function(index,row){
				  //return 'height:1.5em;';
			  },
			  columns:[[     
			  {field:'code',title:'ä»???',hidden:true},   
			  {field:'desc',title:'??è¿?,width:200},
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
			  title:'å¯¹ç????è¯???è¡?(??ç¤????»æ???å¯¹ç??)',
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
			  {field:'desc',title:'??è¿?,width:200},
			  {field:'icdflag',title:'ICD',width:60},
			  {field:'keyflag',title:'?³é??å­?',width:60},
			  {field:'actflag',title:'????',width:60},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]],
			  onDblClickRow:function(rowIndex, rowData){ 

                 var icdrowid=rowData.rowid;


				 $.messager.confirm('Confirm', '??ç¡?å®?è¦??´æ?¹æ???¡È?¹ç??????/ä¸????????', function(r){
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
			  title:'?³è??è¯?????ç»???è¡?',
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
			  {field:'desc',title:'??è¿?,width:200},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]],
			  onDblClickRow:function(rowIndex, rowData){ 

                 var rowid=rowData.rowid;


				 $.messager.confirm('Confirm', '??ç¡?å®?è¦????æ­??¡È?¹ç?????', function(r){
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

        //ä¸???å¯¹ç??
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
   
        //??è¯£×·²å¯¹ç??
		$("#btnFind").click(function (e) { 
			
             reload();


         })
         
		//å¢???????
		$("#btnAdd").click(function (e) { 
                
			    var desc=$.trim($("#TxtDesc").val());
				var keyflag="N";
				if ($('#chkkeyflag').attr('checked'))
				{
					var keyflag="Y" ;
				}
				if (desc=="")
	            {		
					    $.messager.alert('??è¯???ç¤?,'è¯·å??å½?????è¿?',"error");
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
							$.messager.alert('??è¯???ç¤?,'ä¸??½é??å¤?å¢???!',"error");
							return;

						}
						reload();
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});


         })

		 //å¢???å¯¹ç??

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
					$.messager.alert('??è¯???ç¤?,'è¯·å????å¯¹ç????è¡?ä¸???ä¸?è®°å?!',"error");
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
							$.messager.alert('??è¯???ç¤?,'ä¸??½é??å¤?å¢???!',"error");
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




     //?·æ??rid
     function reload()
	 {
		 	 var desc=$.trim($("#TxtDesc").val());
			 $('#seldisease').datagrid('load',  {  
					action: 'QueryContrastICDDs',
					input:desc
			    });

		}




	    //???å¯¹ç??

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




     //?·æ??rid
     function reloaditm(rowid)
	 {

			 $('#seldiseaseitm').datagrid('load',  {  
					action: 'QueryContrastItmDs',
					rowid:rowid
			    });

		}


        //???????ä¸?è¯?è¯??????³è??
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
							$.messager.alert('??è¯???ç¤?,'è¯?è®°å???ICD,ä¸??½æ???,è¯·å??å¯¹ç????è¡?ä¸????!',"error");
							return;

						}
						reloaditm(rowid);
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
					
						}
				});

				
		}








    }


