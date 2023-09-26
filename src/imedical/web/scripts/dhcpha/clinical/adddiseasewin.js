

//????????æ¡?

var url='dhcpha.clinical.action.csp' ;

AddDiseaseWindow = function(druginstdr,Fn) {

		  var RetDiseaseStr="";
		  var RetDiseaseRowidStr="";
	      $('#win').window({ 
			   title:'????',
			   minimizable:false,
			   maximizable:false,
			   collapsible:false,
			   width:550,   
			   height:500,   
			   modal:true
			 });


		  $('#diseasedata').datagrid({  
			  title:'?°æ????è¡?',
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
			  toolbar: [{
					text: '????<input type="text" id="inputicdalias"/>'
				},'-',{
					iconCls: 'icon-search',
					handler: function(){

							var input=$.trim($("#inputicdalias").val()); 
							
							$('#diseasedata').datagrid('load',  {  
								action: 'QueryContrastICDDs',
								input:input

						   });
							
						}
				}],
			  columns:[[        
			  {field:'desc',title:'??è¿?,width:200},
			  {field:'rowid',title:'rowid',width:20}
			  ]],
			  url:url,
			  queryParams: {
					action:'QueryContrastICDDs'
			  },
			  onDblClickRow:function(rowIndex, rowData){ 
		      
		         addRow(rowData.code,rowData.desc,rowData.rowid)   
 
			  },
			  onLoadSuccess:function() {
					  $('#diseasedata').datagrid('unselectAll');
              }  



		  });


		 $('#seldisease').datagrid({  
			  title:'å·²é??',
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  columns:[[     
			  {field:'code',title:'ä»???',width:60,hidden:true},   
			  {field:'desc',title:'??è¿?,width:200},
			  {field:'rowid',title:'rowid',width:20}
			  ]],
			  striped: true, 
			  pagination:true,
			  pageSize:15,
			  pageList:[15,30],
              url:url,
			  queryParams: {
					action:'JsQueryDrgDisICD',
					drginstdr:druginstdr
			  },
			  toolbar: [{
				    text:'ç¡?å®?',
					iconCls: 'icon-save',
					handler: function(){

							returnData() ;
						}
				}],
			  onDblClickRow:function(rowIndex, rowData){ 
 
				 $.messager.confirm('Confirm', '??ç¡?å®?è¦????æ­??¨N?°å????', function(r){
					if (r){
						  delRow(druginstdr,rowData.rowid,rowIndex) 
					}
				 }); 
 
			  }
              

			
		  });

		//??è½?äº?ä»?

        $('#inputicdalias').bind('keypress',function(event){

				var input=$.trim($("#inputicdalias").val()); 
				
				$('#diseasedata').datagrid('load',  {  
					action: 'QueryContrastICDDs',
					input:input

			   });

         });
          
           //????è®°å?
		  function Save()
		  {
			   
			   var rows = $('#seldisease').datagrid('getRows');
			   var rowcount=rows.length ;			   
			   if (rowcount==0)
			   {
				   		//$.messager.alert('??è¯???ç¤?,'??è®°å?!',"error");
						//return;
			   }else{
				   		for (var i = 0; i < rowcount; i++) {
							selrowid = rows[i]['rowid'];
		                    if (RetDiseaseRowidStr=="")
		                    {
								RetDiseaseRowidStr=selrowid;
		                    }else{
								RetDiseaseRowidStr=RetDiseaseRowidStr+","+selrowid ;
							}
                            //
							seldesc = rows[i]['desc'];
                            if (RetDiseaseStr=="")
		                    {
								RetDiseaseStr=seldesc;
		                    }else{
								RetDiseaseStr=RetDiseaseStr+","+seldesc ;
							}

						}

			   }
  
			   


		  }


          //å¢???å·²é??è®°å?
          function addRow(code,desc,rowid)
		  {

			   var rows = $('#seldisease').datagrid('getRows');
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

           
            
              // var data=$('#seldisease').datagrid('getData') ;
			  // var rowcount=data.rows.length ;
			   $('#seldisease').datagrid('insertRow',{
					index: rowcount,	
					row: {
						code: code,
						desc: desc,
						rowid: rowid
					}
				});
				

		  }

          //????????
		  function delRow(drginstdr,rowid,rowindex)
		  {

			    var _json = jQuery.param({ "action":"DelDrgDis","drginstdr":drginstdr,"rowid":rowid });
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					cache: false,
					success: function (r, textStatus) {
						$('#seldisease').datagrid('deleteRow', rowindex);
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});
				

		  }
            

          


          //?¾ç?div
          var mywin = document.getElementById("win");
		  if (mywin)
			{
				mywin.style.display="block";
				
			}


          //è¿????°æ?? 
		  function returnData()
		  {
			  $('#win').window('close');
		  }

		  	  
		  //?³é??äº?ä»?
          $('#win').window({
                 onBeforeClose: function () { 
					 Save() ;
					 Fn(RetDiseaseStr,RetDiseaseRowidStr);

                 }
 

            });


		   //?·æ??rid
     function reload()
		{
	   		 $('#seldisease').datagrid('load',  {  
	
					action:'JsQueryDrgDisICD',
					drginstdr:druginstdr
	
			 });

  
		}








 }