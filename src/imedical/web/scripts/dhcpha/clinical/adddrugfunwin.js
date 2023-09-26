    //录入药品函数窗体

	var url="dhcpha.clinical.action.csp";
	AddDrugFunWindow= function(funitmdr,Fn)
    {
  

			$('#addDurgFunWin').window({ 
			     title:' ',
			     minimizable:false,
			     maximizable:false,
			     collapsible:false,
			     width:560,   
			     height:500,   
			     modal:true
			});

		    $('#addDurgFunWin').window({
                 onBeforeClose: function () { 
			
                      CloseWin();
                 }
 

            });  

            var mywin = document.getElementById("addDurgFunWin");
			if (mywin)
			{
				mywin.style.display="block";
			}


            $('#tbldruglist').datagrid({ 
				
	
				  bordr:false,
				  fit:true,
				  fitColumns:true,
				  singleSelect:true,
				  idField:'rowid', 
				  nowrap: false,
				  striped: true, 
				  pagination:true,
				  rownumbers:true,//行号 
				  pageSize:150,
				  pageList:[150,300],
				  columns:[[  

				  {field:'rowid',title:'rowid',hidden:true},   
				  {field:'desc',title:'描述',width:100}
				  ]],
				  //url:url,
				  //queryParams: {
						//action:'QueryDrugDs'
					
				  //},
				  onDblClickRow:function(rowIndex, rowData){ 
                     var desc=rowData.desc;
					 var drugid=rowData.rowid;
					 insrow(desc,drugid);

				  }

		  });



		    $('#tblseldruglist').datagrid({
				
				  title:'已选列表(双击清除)',
				  bordr:false,
				  fit:true,
				  fitColumns:true,
				  singleSelect:true,
				  idField:'drgid', 
				  nowrap: false,
				  striped: true, 
				  pagination:true,
				  rownumbers:true,//行号 
				  pageSize:150,
				  pageList:[150,300],
				  columns:[[  

				  {field:'drgid',title:'drgid',hidden:true},   
				  {field:'desc',title:'描述',width:100}
			
				  ]],
				  url:url,
				  queryParams: {
						action:'QueryFunItmDrugList',
						input:funitmdr
				  },
				  toolbar: [{
				    text:'确定',
					iconCls: 'icon-save',
					handler: function(){

							returnData() ;
						}
				  }],
				  onDblClickRow:function(rowIndex, rowData){ 

					 del();

				  }

		  });

         //药品名称回车事件
         $('#textDrug').bind('keypress',function(event){
             if(event.keyCode == "13")    
             {
				 var input=$.trim($("#textDrug").val());
				 if (input!="")
				 {
					 reload(input);
					
				 }	
             }
         });





	 function returnData()
	 {
			 $('#addDurgFunWin').window('close');
	 }

	 function cleartbl()
	 {

		  $("#textDrug").val('');
		  $('#tbldruglist').datagrid('options').url=null;

		  var data = '{"total":0,"rows":[]}';  
          //data = JSON.parse(data); 

		  //$('#tbldruglist').datagrid('loadData', data); 
          //$('#tblseldruglist').datagrid('loadData', data);
		  
		   var item = $('#tbldruglist').datagrid('getRows');  
            if (item) {  
                for (var i = item.length - 1; i >= 0; i--) {  
                    var index = $('#tbldruglist').datagrid('getRowIndex', item[i]);  
                    $('#tbldruglist').datagrid('deleteRow', index);  
                }  
            } 

		   var item = $('#tblseldruglist').datagrid('getRows');  
            if (item) {  
                for (var i = item.length - 1; i >= 0; i--) {  
                    var index = $('#tblseldruglist').datagrid('getRowIndex', item[i]);  
                    $('#tblseldruglist').datagrid('deleteRow', index);  
                }  
            } 

		  

	 }


	//刷新grid
	 function reload(Input)
	 {
		      $('#tbldruglist').datagrid('options').url=url;
			  
			  $('#tbldruglist').datagrid('load',  {  
					action:'QueryDrugDs',
					input:Input
			  });

			  $('#tbldruglist').datagrid({ onLoadSuccess:function() {
				  $('#tbldruglist').datagrid('selectRow', 0);
				}
			  });


	 }

     //双击清除
	 function del(){     
		 var rows = $('#tblseldruglist').datagrid("getSelections");  
		 var copyRows = [];      
		 for ( var j= 0; j < rows.length; j++) {  
			 copyRows.push(rows[j]);    
			 }     
		 for(var i =0;i<copyRows.length;i++){  
			 var index = $('#tblseldruglist').datagrid('getRowIndex',copyRows[i]);    
			 $('#tblseldruglist').datagrid('deleteRow',index);  
		 }
	 }

　　　//双击添加
     function insrow(desc,drugid){ 

			 $('#tblseldruglist').datagrid('insertRow',{
					index: 0,	// index start with 0
					row: {
						desc: desc,
						drgid: drugid
					}
         

	         });
	 }


	 function CloseWin()
	 {
		    
            var ret="" ;
		    var item = $('#tblseldruglist').datagrid('getRows');  
            if (item) {  
                for (var i = item.length - 1; i >= 0; i--) {  
                    var row = $('#tblseldruglist').datagrid('getRowIndex', item[i]);  
                    var drgid=item[i].drgid;
					if (ret=="")
					{
						ret=drgid;
					}else{
						ret=ret+","+drgid;
					}
					
                }  
            } 
            
			Fn(ret);


		    cleartbl();
	 }














 
  
       
	}

     

