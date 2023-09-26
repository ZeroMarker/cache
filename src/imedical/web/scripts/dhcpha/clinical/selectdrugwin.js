
SelectDrugWindow= function(Input,Fn)
{
	      
          var url='dhcpha.clinical.action.csp' ;
		  var RetDescStr="";
          var RetRowidStr="";
		  

       
		  $('#selectdrugwin').window({ 
		   title:'??????�?',
		   minimizable:false,
		   maximizable:false,
		   collapsible:false,
		   width:550,   
		   height:400,   
		   modal:true,
		   close:true
		 });
			

         $('#seldruglist').datagrid({  
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:true,//�???
			  pageSize:10,
			  pageList:[10,20],
			  columns:[[ 
			  {field:'code',title:'�???',width:80}, 
			  {field:'desc',title:'??�?,width:180},   
			  {field:'rowid',title:'rowid',width:20}
			  ]],
			  url:url,
			  queryParams: {
					action:'QueryDrugDs',
					input:Input
			  },
			  onDblClickRow:function(rowIndex, rowData){ 

                 returnData();

 
			  },
			  toolbar: [{
				    text:'�?�?',
					iconCls: 'icon-save',
					handler: function(){

						   returnData() ;
						}
				}],
			  onLoadSuccess:function() {
					 
					  //$("#seldruglist").focus();
					  $('#seldruglist').datagrid('clearSelections');
					  $('#seldruglist').datagrid('unselectAll');
					  $('#seldruglist').datagrid('selectRow', 0);
                    }


		  });




         
		  var mywin = document.getElementById("selectdrugwin");
			if (mywin)
			{
				mywin.style.display="block";
				 //$('#selectdrugwin').window('open');
			}

	
          //????
          //reload();

          //????记�?
		  function Save()
		  {
			   
			   var rows = $('#seldruglist').datagrid('getRows');
			   var rowcount=rows.length ;			   
			   if (rowcount==0)
			   {
				   		//$.messager.alert('??�???�?,'??记�?!',"error");
						//return;
			   }else{
				   		var row = $("#seldruglist").datagrid("getSelected"); 
						if (!(row))
						{	//$.messager.alert('??�???�?,'请�??????�??�N?��?!',"error");
							//return;
						}else{
							RetRowidStr=row.rowid;
							RetDescStr=row.desc;
						}



			   }

			  


		  }


          //�????��?? 
		  function returnData()
		  {
			  $('#selectdrugwin').window('close');
		  }

		  	  
		  //?��??�?�?
          $('#selectdrugwin').window({
                 onBeforeClose: function () { 
					 Save();
					 $('#seldruglist').datagrid('clearSelections');
					 $('#seldruglist').datagrid('unselectAll');
					 Fn(RetDescStr,RetRowidStr);

                 }
 

            });


         $('#seldruglist').focus(function()
		{
			 //alert(1)
		});
			 //?��??rid
		 function reload()
		 {
			      $('#seldruglist').datagrid('loadData', { total: 0, rows: [] }); 
				  $('#seldruglist').datagrid('load',  {  
				 		action:'QueryDrugDs',
				 		input:Input
				  });

				  $('#seldruglist').datagrid({ onLoadSuccess:function() {
					  $('#seldruglist').datagrid('selectRow', 0);
                    }
				  });


		 }

         //$("#selectdrugwin").attr("tabindex",0);
		 //$("#selectdrugwin").focus();

         $("#seldruglist").datagrid({}).datagrid("keyCtr");

}


