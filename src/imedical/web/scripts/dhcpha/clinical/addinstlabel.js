    
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
			  rownumbers:true,//è¡???
			  pageSize:30,
			  pageList:[30,60],  
			  columns:[[  
			  {field:'code',title:'ä»???',width:60},   
			  {field:'desc',title:'??è¿?,width:200},
			  {field:'mode',title:'æ¨¡È?',hidden:true},
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


	  //??å§???
	  var data = $('#TxtMode').combobox('getData');
	          
              if (data.length > 0) {
                  $('#TxtMode').combobox('select', data[0].value);
              } 

	  
	  
	  //??å§???
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




       //ä¿?å­?
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
							$.messager.alert('??è¯???ç¤?,'ä»???ä¸??½é??å¤?å¢???!',"error");
							return;

						}
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
	   		 $('#labelgrid').datagrid('load',  {  
				action: 'QueryInstLabelDs'
			 });
		}

	//æ£????°æ???¼å?
    function checkdata(code,desc,mode)
		{

				if (code=="")
				{
					$.messager.alert('??è¯???ç¤?,'ä»???ä¸??½ä¸ºç©?',"error");
					return -1;
				}
                if (desc=="")
				{
					$.messager.alert('??è¯???ç¤?,'??è¿°ä??½ä¸ºç©?',"error");
					return -1;
				}
				if (mode=="")
				{
					$.messager.alert('??è¯???ç¤?,'æ¨¡È?ä¸??½ä¸ºç©?',"error");
					return -1;
				}

				return 0 ;

		}

      //?´æ?°é¡÷ç­?
	  function Update()
	  {

				var code=$.trim($("#TxtCode").val());
				var desc=$.trim($("#TxtDesc").val());
				var mode=$('#TxtMode').combobox('getValue');

				var row = $("#labelgrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('??è¯???ç¤?,'è¯·å??????ä¸??¨N?°å?!',"error");
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
							$.messager.alert('??è¯???ç¤?,'?´æ?°å?è´?!',"error");
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


