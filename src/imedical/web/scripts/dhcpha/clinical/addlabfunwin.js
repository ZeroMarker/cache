    //¼��ҩƷ��������

	var url="dhcpha.clinical.action.csp";
	AddLabFunWindow= function(funitmdr,Fn)
    {
  

			$('#addLabFunWin').window({ 
			     title:' ',
			     minimizable:false,
			     maximizable:false,
			     collapsible:false,
			     width:860,   
			     height:500,   
			     modal:true
			});

		    $('#addLabFunWin').window({
                 onBeforeClose: function () { 
			
                      CloseWin();
                 }
 

            });  

            var mywin = document.getElementById("addLabFunWin");
			if (mywin)
			{
				mywin.style.display="block";
			}


            $('#tbllablist').datagrid({ 
				
	
				  bordr:false,
				  fit:true,
				  fitColumns:true,
				  singleSelect:true,
				  idField:'rowid', 
				  nowrap: false,
				  striped: true, 
				  pagination:true,
				  rownumbers:true,//�к� 
				  pageSize:150,
				  pageList:[150,300],
				  columns:[[  

				  {field:'tscode',title:'����',width:80},   
				  {field:'tsDesc',title:'����',width:160}
				  ]],
				  //url:url,
				  //queryParams: {
						//action:'QuerylabDs'
					
				  //},
				  onDblClickRow:function(rowIndex, rowData){ 
                     var desc=rowData.tsDesc;
					 var labid=rowData.tscode;
					 insrow(desc,labid);

				  }

		  });



		    $('#tblsellablist').datagrid({
				
				  title:'��ѡ�б�(˫�����)',
				  bordr:false,
				  fit:true,
				  fitColumns:true,
				  singleSelect:true,
				  idField:'drgid', 
				  nowrap: false,
				  striped: true, 
				  pagination:true,
				  rownumbers:true,//�к� 
				  pageSize:150,
				  pageList:[150,300],
				  columns:[[  

				  {field:'labid',title:'����'},   
				  {field:'desc',title:'����',width:200},  
				  {field:'min',title:'����',width:90,editor : {  
                       type : 'numberbox',  
                        options : {  
                            //required : true  
                        }  
                    }} ,  

				  {field:'max',title:'����',width:90,editor : {  
                       type : 'numberbox',  
                        options : {  
                            //required : true  
                        }  
                    }} 

			
				  ]],
				  url:url,
				  queryParams: {
						action:'QueryFunItmlabList',
						input:funitmdr
				  },
				  toolbar: [{
				    text:'ȷ��',
					iconCls: 'icon-save',
					handler: function(){

							returnData() ;
						}
				  }],
				  onDblClickRow:function(rowIndex, rowData){ 

					 del();

				  },  
				��onClickCell:function(rowIndex, field, value){ 
	
					$("#tblsellablist").datagrid('beginEdit',rowIndex); 
             
        ����������}


		  });

         //ҩƷ���ƻس��¼�
         $('#textlab').bind('keypress',function(event){
             if(event.keyCode == "13")    
             {
				 var input=$.trim($("#textlab").val());
				 if (input!="")
				 {
					 reload(input);
					
				 }	
             }
         });





	 function returnData()
	 {
			 $('#addLabFunWin').window('close');
	 }

	 function cleartbl()
	 {

		  $("#textlab").val('');
		  $('#tbllablist').datagrid('options').url=null;

		  var data = '{"total":0,"rows":[]}';  
          //data = JSON.parse(data); 

		  //$('#tbllablist').datagrid('loadData', data); 
          //$('#tblsellablist').datagrid('loadData', data);
		  
		   var item = $('#tbllablist').datagrid('getRows');  
            if (item) {  
                for (var i = item.length - 1; i >= 0; i--) {  
                    var index = $('#tbllablist').datagrid('getRowIndex', item[i]);  
                    $('#tbllablist').datagrid('deleteRow', index);  
                }  
            } 

		   var item = $('#tblsellablist').datagrid('getRows');  
            if (item) {  
                for (var i = item.length - 1; i >= 0; i--) {  
                    var index = $('#tblsellablist').datagrid('getRowIndex', item[i]);  
                    $('#tblsellablist').datagrid('deleteRow', index);  
                }  
            } 

		  

	 }


	//ˢ��grid
	 function reload(Input)
	 {
		      $('#tbllablist').datagrid('options').url=url;
			  
			  $('#tbllablist').datagrid('load',  {  
					action:'GetLabItemDs',
					input:Input
			  });

			  $('#tbllablist').datagrid({ onLoadSuccess:function() {
				  $('#tbllablist').datagrid('selectRow', 0);
				}
			  });


	 }

     //˫�����
	 function del(){     
		 var rows = $('#tblsellablist').datagrid("getSelections");  
		 var copyRows = [];      
		 for ( var j= 0; j < rows.length; j++) {  
			 copyRows.push(rows[j]);    
			 }     
		 for(var i =0;i<copyRows.length;i++){  
			 var index = $('#tblsellablist').datagrid('getRowIndex',copyRows[i]);    
			 $('#tblsellablist').datagrid('deleteRow',index);  
		 }
	 }

������//˫�����
     function insrow(desc,labid){ 

			 $('#tblsellablist').datagrid('insertRow',{
					index: 0,	// index start with 0
					row: {
						desc: desc,
						labid: labid
					}
         

	         });
	 }


	 function CloseWin()
	 {
		    
            var ret="" ;
		    var item = $('#tblsellablist').datagrid('getRows');  
            if (item) {  
                for (var i = item.length - 1; i >= 0; i--) {  
                    var row = $('#tblsellablist').datagrid('getRowIndex', item[i]); 
					$('#tblsellablist').datagrid('endEdit', row); 
                    var labid=item[i].labid;
					var min=item[i].min;
					if (typeof min=="undefined")
					{ 
						min=""
					}
					var max=item[i].max;
					if (typeof max=="undefined")
					{ 
						max=""
					}
					var str=labid+":"+min+":"+max ;
					if (ret=="")
					{
						ret=str
					}else{
						ret=ret+","+str;
					}
					
                }  
            } 
            
			Fn(ret);


		    cleartbl();
	 }  
	}

     

