    function InitDrugList()
    {
		 
		  var url="dhcpha.clinical.action.csp" ;
		  var mode="D";

		  var Request = new Object();
		  Request = GetRequest();
		  var drugid = Request['drugid'];

		  $('#druggrid').datagrid({ 
			  bordr:false,
			  toolbar:"#druggridtb",
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  //rownumbers:true,//è¡???
			  pageSize:50,
			  pageList:[50,100],
			  //height:450,
			  columns:[[     
			  {field:'desc',title:'??????ç§?,width:100},
			  {field:'mode',title:'çº???',width:40},
              {field:'rowid',title:'rowid',hidden:true}
			  ]],
			  url:url,
			  queryParams: {
					action: 'QueryDrugInteractDS',
				    drugid: drugid
			  },
			  onDblClickRow:function(rowIndex, rowData){ 

                 var rowid=rowData.rowid;

				 $.messager.confirm('Confirm', '??ç¡?å®?è¦????æ­??¨N?°å????', function(r){
					if (r){
						 Delete(rowid);
					}
				 });
				

 
			  }


		  });

		  //reload();

         //??????ç§?
         $('#TxtDrugDesc').bind('keypress',function(event){
             if(event.keyCode == "13")    
             {
				 var input=$.trim($("#TxtDrugDesc").val());

				 if (input=="")
				 {
					 return;
				 }
                 SelectDrugWindow(input,SetDrugTxtVal);
             }
         });
 

		//??????ç§?
		function SetDrugTxtVal(str,id)
			 {

				 if (str!="")
				 {
					 $("#TxtDrugDesc").val(str);
					 $("#TxtDrugRowId").val(id);
					 
				 }
				 
		 }
             


		 $("#btnAdd").click(function (e) { 
			
				var desc=$.trim($("#TxtDrugDesc").val());
				var rowid=$.trim($("#TxtDrugRowId").val());
	            if (rowid=="")
	            {		
					    $.messager.alert('??è¯???ç¤?,'è¯·å????????????ç§?',"error");
						return;
	            }
				var ManageMode=$('#ComboMode').combobox('getValue');
				if (ManageMode=="")
				{
						$.messager.alert('??è¯???ç¤?,'çº???ä¸??½ä¸ºç©?',"error");
						return;
				}

                //var mode="N";
				//if ($('#ifmanage').attr('checked'))
				//{
				//	var mode="Y" ;
				//} 
                var input=ManageMode;
				Save(rowid,input)

         })

		 //å¢???

		function Save(rowid,input)
		{    
			    
			    var _json = jQuery.param({ "action":"SaveInteract","drugid": drugid,"optype":"Interact","oprowid":rowid,"input":input });
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


		}

		//????

		function Delete(rowid)
		{    

			    
			    var _json = jQuery.param({ "action":"DelDrugInteract","rowid":rowid});
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


		}




     //?·æ??rid
     function reload()
	 {
	   		 $('#druggrid').datagrid('load',  {  
				action: 'QueryDrugInteractDS',
				drugid: drugid
			 });
		}







}


