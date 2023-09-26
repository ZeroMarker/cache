   
	
	//??å±?é¢?æ¬?
	function addfreqlist()
    {
		  
          var url='dhcpha.clinical.action.csp' ;
	
		  var Request = new Object();
		  Request = GetRequest();
          var drugid = Request['drugid'];
		  var druginstdr = Request['druginstdr'];

		  $('#freqdata').datagrid({  
			  title:'é¢?????è¡?',
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'code', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:true,//è¡???
			  pageSize:15,
			  pageList:[15,30],
			  columns:[[     
			  {field:'code',title:'ä»???',width:60},   
			  {field:'desc',title:'??è¿?,width:200},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]],
			  url:url,
			  queryParams: {
					action:'QueryFreqDS'
			  },
			  onDblClickRow:function(rowIndex, rowData){ 

                 var freqdr=rowData.rowid;
				 
				 
			     AddFreqData(drugid,freqdr);

 
			  }

		  });
        

		 $('#selfreq').datagrid({  
			  title:'å·²é????è¡?',
			  bordr:false,
			  toolbar:"#freqdatatbar",
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
			  {field:'desc',title:'??è¿?,width:200},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]],
			  url:url,
			  queryParams: {
				  	drugid:drugid,
					action:'QuerySelFreqDS'
			  },
			  onDblClickRow:function(rowIndex, rowData){ 

                 var rowid=rowData.rowid;

 				 $.messager.confirm('Confirm', '??ç¡?å®?è¦????æ­??¡È?¹ç?????', function(r){
					if (r){
						 DelFreqData(rowid);
					}
				 });

			  }

		  });

        GetDrugInstMode();

		$("#btnUpdMode").click(function (e) { 
			
			    var mode=$('#ComboMode').combobox('getValue');
				if (mode=="")
				{
							$.messager.alert('??è¯???ç¤?,'çº???ä¸??½ä¸ºç©?',"error");
							return;
				}
				var rows = $('#selfreq').datagrid('getRows');
			    var rowcount=rows.length ;			   
			    if (rowcount==0) {
							$.messager.alert('??è¯???ç¤?,'å·²é????è¡???è®°å?ä¸??½æ?´æ??',"error");
							return;
				}
                
			    var input=mode ;
			    var _json = jQuery.param({ "action":"UpdateGolbalDrgData","drugid": drugid,"type":"freq","input":input });
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					//contentType: "charset=utf-8",
					cache: false,
					success: function (r, textStatus) {
							$.messager.alert('??ä½???ç¤?,'?´æ?°æ????!',"info");
							return;
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});



         })
		 //å¢???é¢?æ¬?

		function AddFreqData(drugid,freqdr)
		{
			    var mode=$('#ComboMode').combobox('getValue');
				if (mode=="")
				{
							$.messager.alert('??è¯???ç¤?,'çº???ä¸??½ä¸ºç©?',"error");
							return;
				}
			    var input=mode ;
			    var _json = jQuery.param({ "action":"AddGolbalDrgData","drugid": drugid,"optype":"freq","oprowid":freqdr,"input":input });
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
						reload();
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});

				//alert(request.responseText);
		}


	     //?????æ¬?

		function DelFreqData(rowid)
		{
			    
			    var _json = jQuery.param({ "action":"DelFreqData","rowid":rowid });
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


     //?·æ??rid
     function reload()
		{
	   		 $('#selfreq').datagrid('load',  {  
					drugid:drugid,
					action:'QuerySelFreqDS'
			 });
		}
	  
	  

        //?·å??çº???
		function GetDrugInstMode()
		{
			    
			    var _json = jQuery.param({ "action":"GetDrugInstMode","drugid":drugid,"type":"freq" });
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


