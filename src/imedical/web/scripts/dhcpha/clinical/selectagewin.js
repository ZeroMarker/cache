    //å¹´é?????æ¡?
	
	var url='dhcpha.clinical.action.csp' ;
  
	AddAgeWindow= function(druginstdr,Fn)
    {
           
		  var RetAgeStr="";
          var RetAgeRowidStr="";

	      $('#selectagewin').window({ 
			   title:'å¹´é?',
			   minimizable:false,
			   maximizable:false,
			   collapsible:false,
			   width:550,   
			    height:500,   
			     modal:true
			 });


		  $('#agedata').datagrid({  
			  title:'?°æ????è¡?',
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'id', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:true,//è¡???
			  pageSize:15,
			  pageList:[15,30],
			  columns:[[     
			  {field:'desc',title:'å¹´é?',width:180},   
			  {field:'rowid',title:'id',width:20}
			  ]],
			  url:url,
			  queryParams: {
					action:'QueryContrastAgeDs'
			  },
			  onDblClickRow:function(rowIndex, rowData){ 
		      
		         addRow(rowData.desc,rowData.rowid)   
 
			  }	,
			  onLoadSuccess:function() {
					  $('#agedata').datagrid('unselectAll');
              }          
			 
		  });

         
		 $('#selage').datagrid({  
			  title:'å·²é??',
			  bordr:false,
			  fit:true,
			  fitColumns:true,			  
			  singleSelect:true,
			  idField:'id', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:true,//è¡???
			  columns:[[     
			  {field:'desc',title:'å¹´é?',width:80},   
			  {field:'rowid',title:'rowid',width:80}
			  ]],
			  url:url,
              queryParams: {
					action:'QueryAgeDs',
					druginstdr:druginstdr
			  },
			  toolbar: [{
				    text:'ç¡?å®?',
					iconCls: 'icon-save',
					handler: function(){

							returnData() ;
						}
				}],
			  onDblClickRow:function(rowIndex, rowData){ 
		      
		         var rowid=rowData.rowid;

 				 $.messager.confirm('Confirm', '??ç¡?å®?è¦????æ­??¨N?°å????', function(r){
					if (r){
						 
						 DelAgeData(rowIndex,rowid);
					}
				 });  
 
			  }	,
			  onLoadSuccess:function() {
					  $('#selage').datagrid('unselectAll');
              } 



		  });


		  var mywin = document.getElementById("selectagewin");
			if (mywin)
			{
				mywin.style.display="block";
			}


         //????è®°å?
		  function Save()
		  {
			   
			   var rows = $('#selage').datagrid('getRows');
			   var rowcount=rows.length ;			   
			   if (rowcount==0)
			   {
				   		//$.messager.alert('??è¯???ç¤?,'??è®°å?!',"error");
						//return;
			   }else{
				   		for (var i = 0; i < rowcount; i++) {
							selrowid = rows[i]['rowid'];
		                    if (RetAgeRowidStr=="")
		                    {
								RetAgeRowidStr=selrowid;
		                    }else{
								RetAgeRowidStr=RetAgeRowidStr+","+selrowid ;
							}
                            //
							seldesc = rows[i]['desc'];
                            if (RetAgeStr=="")
		                    {
								RetAgeStr=seldesc;
		                    }else{
								RetAgeStr=RetAgeStr+","+seldesc ;
							}

						}

			   }
  
			   


		  }


          //è¿????°æ?? 
		  function returnData()
		  {
			  $('#selectagewin').window('close');
		  }

		  	  
		  //?³é??äº?ä»?
          $('#selectagewin').window({
                 onBeforeClose: function () { 
					 Save() ;
					 Fn(RetAgeStr,RetAgeRowidStr);

                 }
 

            });


		//å¢???å·²é??è®°å?
		function addRow(desc,rowid)
		{

			   var rows = $('#selage').datagrid('getRows');
			   var rowcount=rows.length ;			   
			   if (rowcount==0)
			   {
			   }else{
				   		for (var i = 0; i < rowcount; i++) {
							selrowid = rows[i]['rowid'];
							if (rowid==selrowid)
							{
									$.messager.alert('??è¯???ç¤?,'ä¸??½é??å¤?????!',"error");
									return;
							}
						}
			   }
            
			   $('#selage').datagrid('insertRow',{
					index: rowcount,	
					row: {
						desc: desc,
						rowid: rowid
					}
				});
				

		  }



	     //????¹´é¾?

		function DelAgeData(rowindex,rowid)
		{
			    
			    var _json = jQuery.param({ "action":"DelAgeData","drginstdr":druginstdr,"rowid":rowid });
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					cache: false,
					success: function (r, textStatus) {
						$('#selage').datagrid('deleteRow', rowindex);
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
	   		 $('#selage').datagrid('load',  {  
	
					action:'QueryAgeDs',
					druginstdr:druginstdr
	
			 });

  
		}




}


