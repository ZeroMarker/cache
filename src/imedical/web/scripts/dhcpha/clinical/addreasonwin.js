/*
Creator:LiangQiang
CreatDate:2014-07-20
Description:标记原因
*/
var url='dhcpha.clinical.action.csp' ;

AddReaWindow= function(adm,reason,Fn)
  {

	  
			$('#addreasonWin').window({ 
			     title:'　　　',
			     minimizable:false,
			     maximizable:false,
			     collapsible:false,
			     width:900,   
			     height:500,   
			     modal:true
			});

		    $('#addreasonWin').window({
                 onBeforeClose: function () { 
			
                      //CloseWin();
                 }
 

            }); 

			var mywin = document.getElementById("addreasonWin");
			if (mywin)
			{
				mywin.style.display="block";
			}


			$('#tblrea').treegrid({ 
				
	              title:'原因列表',
				  bordr:false,
				  fit:true,
				  fitColumns:true,
				  singleSelect:true, 
				  nowrap: true,
				  striped: true, 
				  pagination:false,
				  rownumbers:true,//行号 
				  idField:'rowid', 
			      treeField:'desc',
				  pageSize:1500,
				  pageList:[1500,3000],
				  columns:[[  

				  {field:'rowid',title:'rowid',hidden:true},   
				  {field:'desc',title:'描述',width:400},
				  {field:'_parentId',title:'parentId',hidden:true}
				  ]],
				  url:url,
				  queryParams: {
						action:'QueryReaDs'
					
				  },
				  onClickRow:function(rowData){ 

                     var desc=rowData.desc;
					 var rowid=rowData.rowid;
					 insrow(desc,rowid);

				  }

		  });




	$('#tblselrea').datagrid({ 
				
	              title:'已选原因',
				  bordr:false,
				  fit:true,
				  fitColumns:true,
				  singleSelect:true,
				  idField:'rowid', 
				  nowrap: false,
				  striped: true, 
				  pagination:false,
				  rownumbers:true,//行号 
				  pageSize:1500,
				  pageList:[1500,3000],
				  columns:[[  

				  {field:'rowid',title:'rowid',hidden:true},   
				  {field:'desc',title:'描述',width:100}
				  ]],
				  onClickRow:function(rowIndex, rowData){ 

					del();

				  },
				  toolbar: [{
				    text:'确定',
					iconCls: 'icon-save',
					handler: function(){

							returnData() ;
						}
				  }]

		  });

     
     $('#tblselrea').datagrid('loadData', reason); 

     function insrow(desc,rowid)
	 {
		    
		 	 $('#tblselrea').datagrid('insertRow',{
					index: 0,	// index start with 0
					row: {
						desc: desc,
						rowid: rowid
					}
         

	         });
	  }



     //双击清除
	 function del(){     
		 var rows = $('#tblselrea').datagrid("getSelections");  
		 var copyRows = [];      
		 for ( var j= 0; j < rows.length; j++) {  
			 copyRows.push(rows[j]);    
			 }     
		 for(var i =0;i<copyRows.length;i++){  
			 var index = $('#tblselrea').datagrid('getRowIndex',copyRows[i]);    
			 $('#tblselrea').datagrid('deleteRow',index);  
		 }
	 }



	 function returnData()
	 {
		     CloseWin();

			 $('#addreasonWin').window('close');
	 }





	 function CloseWin()
	 {
		    
            var ret="" ;
		    var item = $('#tblselrea').datagrid('getRows');  
            if (item) {  
                for (var i = item.length - 1; i >= 0; i--) {  
                    var row = $('#tblselrea').datagrid('getRowIndex', item[i]);  
                    var rowid=item[i].rowid;
					if (ret=="")
					{
						ret=rowid;
					}else{
						ret=ret+","+rowid;
					}
					
                }  
            } 
            
			Fn(ret);

			

	 }


	 function cleartbl()
	 {

			  $('#tblrea').datagrid('options').url=null;
			  $('#tblselrea').datagrid('options').url=null;

	 }








   }


