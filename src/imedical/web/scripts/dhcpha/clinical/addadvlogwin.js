    //�???????建�??�?�?

	var url="dhcpha.clinical.action.csp";
	var adm="";
	OpenAdvlogWin= function(data,Fn)
    {

		    var arr=data.split("^");
			var patward=arr[0];
			var patbed=arr[1];
			var patname=arr[2];
			adm=arr[3];

			$("#txtrward").text(patward);
			$("#txtrbed").text(patbed);
			$("#txtrname").text(patname);

			$("#txtroomlog").val('');

			$('#addadvlogWin').window({ 
			     title:' ',
			     minimizable:false,
			     maximizable:false,
			     collapsible:false,
			     width:960,   
			     height:500,   
			     modal:true
			});

		    $('#addadvlogWin').window({
                 onBeforeClose: function () { 
			
                     // CloseWin();
                 }
 

            });  

            var mywin = document.getElementById("addadvlogWin");
			if (mywin)
			{
				mywin.style.display="block";
			}


            $('#tblroomlist').datagrid({ 
				
	
				  bordr:false,
				  fit:true,
				  fitColumns:true,
				  singleSelect:true,
				  idField:'rowid', 
				  nowrap: false,
				  striped: true, 
				  pagination:true,
				  rownumbers:true,//�???
				  pageSize:150,
				  pageList:[150,300],
				  columns:[[  

				  {field:'rowid',title:'rowid',hidden:true},
				  {field:'date',title:'记�?????',width:100},
				  {field:'user',title:'记�?�?,width:100}
				  ]],
				  url:url,
				  queryParams: {
						action:'QueryAdmRoomLogList',
						input:adm
					
				  },
				  onClickRow:function(rowIndex, rowData){ 
					 var rowid=rowData.rowid;
					 showLog(rowid);

				  }

		  });





	 function returnData()
	 {
			 $('#addDurgFunWin').window('close');
	 }

	 function cleartbl()
	 {

		  $("#txtroomlog").val('');
		  $('#tblroomlist').datagrid('options').url=null;

	 }


	//?��??rid
	 function reload()
	 {
		      $('#tblroomlist').datagrid('options').url=url;
			  $("#txtroomlog").val('');
			  
			  $('#tblroomlist').datagrid('load',  {  
					action:'QueryAdmRoomLogList',
					input:adm
			  });

			  $('#tblroomlist').datagrid({ onLoadSuccess:function() {
				  $('#tblroomlist').datagrid('selectRow', 0);
				}
			  });


	 }

    $("#btnAddRlog").click(function (e) { 

       Save(0);
    })

    $("#btnUpdRlog").click(function (e) { 

       Save(1);
    })
		


	    //0?��? 1,?��??
    function Save(flag)
	{ 
		var roomlog=$.trim($("#txtroomlog").val());  
        var user=session['LOGON.USERID'] ;

		if (roomlog=="")
		{
			$.messager.alert('??�???�?,'???��???��??�为�?',"error");
			return;
		}

        var rowid="";
		var row=$('#tblroomlist').datagrid('getSelected');
		if (row)
		{
					var rowid=row.rowid ;
	
		}
		if (flag=="0")
		{
			var rowid="" ;
		}

        var type="Room";
        var input=roomlog+"^"+user+"^"+adm+"^"+type+"^"+rowid;

		var _json = jQuery.param({ "action":"SaveAdmRoomLog","input":input});
			var request = $.ajax({
				url: url,
				type: "POST",
				async: false,
				data: _json,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
					if (r.retvalue==0)
					{
						$.messager.alert('??�???�?,'�?�?????!',"info");
						reload();

					}else{
						$.messager.alert('??�???�?,'�?�?失败!',"error");
						return;
					}

					
		
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					}
			});



     }


   //?��????��????
   function showLog(rowid)
	{

        var input=rowid;

		var _json = jQuery.param({ "action":"GetAdmRoomLog","input":input});
			var request = $.ajax({
				url: url,
				type: "POST",
				async: false,
				data: _json,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {

					$("#txtroomlog").val(r.retvalue);
		
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					}
			});



	}
  
       
}

     

