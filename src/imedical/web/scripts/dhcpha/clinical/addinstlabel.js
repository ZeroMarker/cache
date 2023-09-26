    
    $(function(){
              intinstlabel();

    });

	function intinstlabel()
    {
         var url="dhcpha.clinical.action.csp" ;
    
		 $('#labelgrid').datagrid({  
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  toolbar:"#tb",
			  url:url,
			  queryParams: {
					action:'QueryInstLabelDs'
			  },
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:true,//�???
			  pageSize:30,
			  pageList:[30,60],  
			  columns:[[  
			  {field:'code',title:'�???',width:60},   
			  {field:'desc',title:'??�?,width:200},
			  {field:'mode',title:'模�?',hidden:true},
			  {field:'modecode',title:'modecode',width:60,hidden:true},
			  {field:'rowid',title:'rowid',width:60,hidden:true}
			  ]],
			  onClickRow:function(rowIndex, rowData){ 
		      
			     $("#TxtCode").val(rowData.code);
		         $("#TxtDesc").val(rowData.desc);
				 $('#TxtMode').combobox('setValue', rowData.modecode);

 
			  }
		  });
        
      $("#btnInit").click(function (e) {   
                Init();
            })
 
      $("#btnAdd").click(function (e) {   
                Save();
            })

	   $("#btnUpd").click(function (e) {    
                Update();
            })


	  //??�???
	  var data = $('#TxtMode').combobox('getData');
	          
              if (data.length > 0) {
                  $('#TxtMode').combobox('select', data[0].value);
              } 

	  
	  
	  //??�???
      function Init()
	  {


			  	var _json = jQuery.param({ "action":"InitInstLabel"});
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




       //�?�?
      function Save()
	  {

				var code=$.trim($("#TxtCode").val());
				var desc=$.trim($("#TxtDesc").val());
				var mode=$('#TxtMode').combobox('getValue');

				if (checkdata(code,desc,mode)<0)
				{
					return;
				}
		  
			  	var _json = jQuery.param({ "action":"SaveInstLabel","code": code, "desc": desc,"mode":mode});
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					//contentType: "charset=utf-8",
					cache: false,
					success: function (r, textStatus) {
						//alert(r.retvalue + r.retinfo);
						if (r.retvalue=="-99")
						{
							$.messager.alert('??�???�?,'�???�??��??�?�???!',"error");
							return;

						}
						reload();
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});



		}
     //?��??rid
     function reload()
		{
	   		 $('#labelgrid').datagrid('load',  {  
				action: 'QueryInstLabelDs'
			 });
		}

	//�????��???��?
    function checkdata(code,desc,mode)
		{

				if (code=="")
				{
					$.messager.alert('??�???�?,'�???�??�为�?',"error");
					return -1;
				}
                if (desc=="")
				{
					$.messager.alert('??�???�?,'??述�??�为�?',"error");
					return -1;
				}
				if (mode=="")
				{
					$.messager.alert('??�???�?,'模�?�??�为�?',"error");
					return -1;
				}

				return 0 ;

		}

      //?��?����?
	  function Update()
	  {

				var code=$.trim($("#TxtCode").val());
				var desc=$.trim($("#TxtDesc").val());
				var mode=$('#TxtMode').combobox('getValue');

				var row = $("#labelgrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('??�???�?,'请�??????�??�N?��?!',"error");
					return;
				}

				var rowid=row.rowid;

				if (checkdata(code,desc,mode)<0)
				{
					return;
				}
			  	var _json = jQuery.param({ "action":"UpdateInstLabel","code": code, "desc": desc,"mode":mode,"rowid":rowid});
				var request = $.ajax({
					url: url,
					type: "POST",
					async: false,
					data: _json,
					dataType: "json",
					//contentType: "charset=utf-8",
					cache: false,
					success: function (r, textStatus) {
						//alert(r.retvalue + r.retinfo);
						if (r.retvalue!=0)
						{
							$.messager.alert('??�???�?,'?��?��?�?!',"error");
							return;

						}
						reload();
					},
					error: function (XMLHttpRequest, textStatus, errorThrown) { 
						  //alert(XMLHttpRequest.readyState); 
						}
				});



		}










}


