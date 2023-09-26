    
	//ç¦?å¿???
	function InitIndication()
    {

		  var typedr="Contraindication";
		  var mode="C";
		  var optype="DrugDis"
		  var url='dhcpha.clinical.action.csp' ;

		  var Request = new Object();
		  Request = GetRequest();
          var drugid = Request['drugid'];
		  var druginstdr = Request['druginstdr'];


		  $('#agecombogrid').combogrid({ 
			  url:url+"?action=QueryContrastAgeDs&page=1&rows=100", 
			  valueField:'rowid', 
			  textField:'desc',
			  fitColumns: true,  
			  multiple:true, 
			  columns:[[    
				  {field:'desc',title:'å¹´é?',width:100}, 
				  {field:'agemin',title:'??å°?',width:80},   
				  {field:'agemax',title:'??å¤?',width:80}, 
				  {field:'rowid',title:'rowid',width:80} 
			  ]]

		  }); 

     LoadData() ;

     //????å¹´é?
	 $("#btnaddage").click(function (e) {  
                AddAgeWindow(druginstdr,SetAgeVal);
     })
     //????????
	 $("#btndisease").click(function (e) {  
                AddDiseaseWindow(druginstdr,SetDiseaseVal);
            })

     //ç½?????è¿?????
     function SetDiseaseVal(str,idstr)
	 {

		 $("#disease").val(str);
		 $("#diseaseid").val(idstr);
         
	 }

	 //ç½?å¹´é?è¿?????
     function SetAgeVal(str,idstr)
	 {
		 $("#age").val(str);
		 $("#ageid").val(idstr);
         
	 }

	 //æ¸?ç©?

	 $("#btnReload").click(function (e) { 
		 druginstdr="";
		 refresh();
	 })

    //ä¿?å­?
	$("#btnAdd").click(function (e) { 
		 
                Save();
            })
    
    //?°å?
    function Save()
	{ 
		var DocUseTips=$.trim($("#AreaDocUseTips").val());  //??????ç¤??»ç????)

		var AgeStr=$.trim($("#ageid").val());

         //????
		 var Sex=$("input[name='sex']:checked").val(); 
         //????
         var DrugDisease=$.trim($("#diseaseid").val());
		 if (DrugDisease=="")
		 {
			 	$.messager.alert('??è¯???ç¤?,'????ä¸??½ä¸ºç©?',"error");
				return;
		 }

		 var Note=$.trim($("#AreaNote").val());

		 var ManageMode=$('#ComboMode').combobox('getValue');
		 if (ManageMode=="")
			{
						$.messager.alert('??è¯???ç¤?,'çº???ä¸??½ä¸ºç©?',"error");
						return;
			}

         var input=DocUseTips+"^"+AgeStr+"^"+Sex+"^"+DrugDisease+"^"+Note+"^"+ManageMode;
	
		 var _json = jQuery.param({ "action":"SaveIndication","input":input,"drugid":drugid,"typedr":typedr,"optype":optype,"druginstdr":druginstdr,"mode":mode});
			var request = $.ajax({
				url: url,
				type: "POST",
				async: false,
				data: _json,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
					if (r.retvalue>0)
					{
						druginstdr=r.retvalue ;
						$.messager.alert('??ä½???ç¤?,'ä¿?å­?????!',"info");

					}else{
						$.messager.alert('??è¯???ç¤?,'ä¿?å­?å¤±è´¥!',"error");
						return;
					}
		
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					}
			});




	}





//?·æ??
  function LoadData()
	{ 
	      
	  		var _json = jQuery.param({ "action":"GetDrugInstData","drginstdr":druginstdr});
			var request = $.ajax({
				url: url,
				type: "POST",
				async: false,
				data: _json,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
		            var data=r.data ;
					if (data!="")
					{
						var tmp=data.split("^")
					    var SexDr=tmp[2];
			
                        if (SexDr=="M")
                        {
							$('#man').attr("checked",'true')
                        }
						if (SexDr=="F")
                        {
							$('#woman').attr("checked",'true')
                        }
                         
						if (SexDr=="A")
                        {
							$('#sexall').attr("checked",'true')
                        }
                        var DocUseTips=tmp[35];
                        var Note=tmp[36];

                        $("#AreaDocUseTips").val(DocUseTips);
						$("#AreaNote").val(Note);
						
						$('#ComboMode').combobox('select', tmp[39]);
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					}
			});


                               
            LoadAagData();
			LoadDiseaseData();


	}



    //??è½½å¹´é¾?
    function LoadAagData()
	{

	  		var _json = jQuery.param({ "action":"GetDrugInstAgeDesc","drginstdr":druginstdr});
			var request = $.ajax({
				url: url,
				type: "POST",
				async: false,
				data: _json,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
					var str="";
		            var data=r.data ;
			        $("#age").val(data);
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					
					}
			});




	}


	//??è½½ç????
    function LoadDiseaseData()
	{

	  		var _json = jQuery.param({ "action":"GetDrgOneDisInstStr","drginstdr":druginstdr});
			var request = $.ajax({
				url: url,
				type: "POST",
				async: false,
				data: _json,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
					var str="";
		           	var data=r.desc ;
					var dataid=r.rowid ;
			        $("#disease").val(data);
					$("#diseaseid").val(dataid);
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					
					}
			});




	}




    //?·æ??
	function refresh()
	{
		var lnk="dhcpha.clinical.addlimitdisease.csp?drugid="+drugid+"&druginstdr=" ;
	    location.href=lnk;
	}








}


