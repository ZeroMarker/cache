    function InitAgeList()
    {
		  var url="dhcpha.clinical.action.csp" ;

		  $('#agegrid').datagrid({ 
			  bordr:false,
			  toolbar:"#agegridtb",
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  //rownumbers:true,//è¡???
			  pageSize:15,
			  pageList:[15,30],
			  //height:450,
			  columns:[[     
			  {field:'desc',title:'å¹´é?',width:100},
			  {field:'agemin',title:'??ä½?',width:100},
			  {field:'agemax',title:'??é«?',width:100},
              {field:'rowid',title:'rowid',hidden:true}
			  ]],
			  url:url,
			  queryParams: {
					action: 'QueryContrastAgeDs'
			  },
			  onClickRow:function(rowIndex, rowData){ 
		      
			     $("#TxtAgeDesc").val(rowData.desc);
		         $("#TxtAgeMin").val(rowData.agemin);
				 $('#TxtAgeMax').val(rowData.agemax);

 
			  }


		  });
        
		$("#btnAdd").click(function (e) { 
			
				var agedesc=$.trim($("#TxtAgeDesc").val());
				var agemin=$.trim($("#TxtAgeMin").val());
				var agemax=$.trim($("#TxtAgeMax").val());

				if (checkdata(agedesc,agemin,agemax)<0)
				{
					return;
				}
				
                AddAge(agedesc,agemin,agemax);
         })


		$("#btnUpd").click(function (e) { 
			
				var agedesc=$.trim($("#TxtAgeDesc").val());
				var agemin=$.trim($("#TxtAgeMin").val());
				var agemax=$.trim($("#TxtAgeMax").val());
				var agerowid=$.trim($("#TxtAgeMax").val());

				if (checkdata(agedesc,agemin,agemax)<0)
				{
					return;
				}


				var row = $("#agegrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('??è¯???ç¤?,'è¯·å??????ä¸??¨N?°å?!',"error");
					return;
				}

				var rowid=row.rowid;
				
                UpdAge(agedesc,agemin,agemax,rowid);
         })

		 //å¢???å¯¹ç??

		function AddAge(agedesc,agemin,agemax)
		{
			    
			    var _json = jQuery.param({ "action":"AddAge","agedesc": agedesc, "agemax": agemax ,"agemin":agemin});
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
						  //alert(XMLHttpRequest.readyState); 
						}
				});


		}




     //?·æ??rid
     function reload()
	 {
	   		 $('#agegrid').datagrid('load',  {  
				action: 'QueryContrastAgeDs'
			 });
		}


		 //?´æ?°å?¹ç??

		function UpdAge(agedesc,agemin,agemax,rowid)
		{
			    
			    var _json = jQuery.param({ "action":"UpdAge","agedesc": agedesc, "agemax": agemax ,"agemin":agemin,"rowid":rowid});
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
						  //alert(XMLHttpRequest.readyState); 
						}
				});


		}

	



	//æ£????°æ???¼å?
    function checkdata(agedesc,agemin,agemax)
		{


				if (agedesc=="")
				{
					$.messager.alert('??è¯???ç¤?,'å¹´é?ä¸??½ä¸ºç©?',"error");
					return -1;
				}else{

					if ((agemin=="")&&(agemax==""))
					{
						$.messager.alert('??è¯???ç¤?,'???´ä??½ä¸ºç©?',"error");
						return -1;
					}
				}

				return 0 ;

		}






    }


