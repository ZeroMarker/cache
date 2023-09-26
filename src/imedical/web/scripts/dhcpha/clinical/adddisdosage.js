    
	///??????æ³?????
	function InitDiseaseDosage()
    {
			  var typedr="Disease";
		      var mode="D";
		      var optype="DisUsage"
		      var url='dhcpha.clinical.action.csp' ;

			  var Request = new Object();
			  Request = GetRequest();
			  var drugid = Request['drugid'];
			  var druginstdr = Request['druginstdr'];

               //ç»?????å¾?
			  $('#route').combogrid({ 
				  url:url+"?action=QueryDrgUsageCombo&page=1&rows=100"+"&drugid="+drugid, 
				  valueField:'rowid',
				  idField:'rowid',
				  textField:'desc',
				  fitColumns: true,  
				  multiple:true, 
				  columns:[[    
					  {field:'desc',title:'??æ³?',width:100}, 
					  {field:'rowid',title:'rowid',width:80} 
				  ]],
				 onLoadSuccess:function(){

					  LoadRouteData();

				  }

			  }); 

			  //ç»?????å¾?
			  /*
			  $('#route').combobox({ 
				  panelHeight: "auto",
				  url:url+"?action=QueryDrgUsageCombo"+"&drugid="+drugid , 
				  valueField:'rowid', 
				  textField:'desc',
				  onSelect: function (record) {
					 //$("#hide_quale").val(record.ID);
				  },
				  onLoadSuccess:function(){
						  //??å§???
						  var data = $('#route').combobox('getData');
						  if (data.length > 0) {
								  //$('#route').combobox('select', data[0].rowid);
							  } 
				  }

			  });
             */


			  LoadData();

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

			 //å½?????æ³?????
			 $("#btnaddusage").click(function (e) {  
                        
						AddDiseaseUsageWindow(druginstdr,drugid,SetUsageVal);
			 })
			 

			 //ç½?å¹´ç??æ³?????
			 function SetUsageVal(idstr)
			 {

				 if (idstr!="")
				 {
					 $("#usageid").val(idstr);
				 }
				 
			 }

             //æ¸?ç©?

			 $("#btnReload").click(function (e) { 
				 druginstdr="";
				 refresh();
			 })

			 //ä¿?å­?
			 $("#btnSave").click(function (e) {  
                        

						 //????
						 var DrugDisease=$.trim($("#diseaseid").val());
						 if (DrugDisease=="")
						 {
								$.messager.alert('??è¯???ç¤?,'????ä¸??½ä¸ºç©?',"error");
								return;
						 }
						 //??æ³?
						 var UsageStr=$.trim($("#usageid").val());
						 if (UsageStr=="")
                         {
							  //$.messager.alert('??è¯???ç¤?,'??æ³?ä¸??½ä¸ºç©?',"error");
							  //return;

                         }

	
						 var Route="";  //å¹´é?
						 var Routegrid=$("#route").combogrid("grid");//?·å??è¡??¼å?¹è±¡
						 var rows  = Routegrid.datagrid('getSelections');//
						 for(var i=0; i<rows.length; i++){
								var row = rows[i];
								var useid=row.rowid ;
								if (Route=="")
								{
									Route=useid;
								}else{
									Route=Route+","+useid ; 
								}

						 }

                         //å¹´é?
						 var AgeStr=$.trim($("#ageid").val());
						 //????
						 var Sex=$("input[name='sex']:checked").val();
						 //ä½???
						 var WeightMin=$.trim($("#WeightMin").val());
						 var WeightMax=$.trim($("#WeightMax").val());
						 //ä½?è¡??£Ù??
						 var BodyAreaMin=$.trim($("#BodyAreaMin").val());
						 var BodyAreaMax=$.trim($("#BodyAreaMax").val());  
						 //?¹æ??äººç¾¤
						 var PlanPregnancy="N";
						 if ($('#PlanPregnancy').attr('checked')) //è®¡È??å¦?å¨?
						 {
							var PlanPregnancy="Y" ;
						 }
						 var Climacteric="N";
						 if ($('#Climacteric').attr('checked')) //?´å¹´??å¦?å¥?
						 {
							var Climacteric="Y" ;
						 }
						 var Menstrual="N";
						 if ($('#Menstrual').attr('checked')) //ç»???
						 { 
							var Menstrual="Y" ;
						 }
						 var Lactation="N";
						 if ($('#Lactation').attr('checked')) //?ºä¹³??
						 {  
							var Lactation="Y" ;
						 }
                         var Pregnant="N";
						 if ($('#Pregnant').attr('checked')) //å­?å¦?
						 {
							var Pregnant="Y" ;
						 }
                         var RenalFunction="N";
						 if ($('#RenalFunction').attr('checked')) //???¾å???½ä???
						 {
							var RenalFunction="Y" ;
						 }
						 //??????ç¤??»ç????)
						 var DocUseTips=$.trim($("#AreaDocUseTips").val());  
                         //??ç¤???¨Ú)
                         var NurseUseTips=$.trim($("#AreaEatTips").val());
                         //å¤?æ³?
						 var Note=$.trim($("#AreaNote").val());
         
						 var ManageMode=$('#ComboMode').combobox('getValue');
						 if (ManageMode=="")
							{
										$.messager.alert('??è¯???ç¤?,'çº???ä¸??½ä¸ºç©?',"error");
										return;
							}
						 

						 var input=DrugDisease+"^"+Route+"^"+UsageStr+"^"+AgeStr+"^"+Sex+"^"+WeightMin+"^"+WeightMax;
						 var input=input+"^"+BodyAreaMin+"^"+BodyAreaMax+"^"+PlanPregnancy+"^"+Climacteric+"^"+Menstrual;
						 var input=input+"^"+Lactation+"^"+Pregnant+"^"+RenalFunction+"^"+DocUseTips+"^"+NurseUseTips+"^"+Note ;
						 var input=input+"^"+ManageMode ;


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


			 })




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
					    
						var OneDayTimeMin=tmp[3];
						var OneDayTimeMax=tmp[4];
						var OnceQtyMin=tmp[5];
						var OnceQtyMax=tmp[6];
						var OnceQtyUom=tmp[7];
						var OneDayQtyMin=tmp[8];
						var OneDayQtyMax=tmp[9];
						var OneDayQtyUom=tmp[10];
						var OnceMaxQty=tmp[11];
						var OnceMaxQtyUom=tmp[12];
						var OneDayMaxQty=tmp[13];
						var OneDayMaxQtyUom=tmp[14];
						var FristTimeQtyMin=tmp[15];
						var FristTimeQtyMax=tmp[16];
						var FristTimeQtyUom=tmp[17];
						var DurationQtyMin=tmp[18];
						var DurationQtyMax=tmp[19];
						var DurationQtyUom=tmp[20];
						var SpaceQtyMin=tmp[21];
						var SpaceQtyMax=tmp[22];
						var SpaceQtyUom=tmp[23];
						var WeightMin=tmp[24];
						var WeightMax=tmp[25];
						var BodyAreaMin=tmp[26];
						var BodyAreaMax=tmp[27];
						var PlanPregnancy=tmp[28];
						var Climacteric=tmp[29];
						var Menstrual=tmp[30];
						var Lactation=tmp[31];
						var Pregnant=tmp[32];
						var RenalFunction=tmp[33];
					    var NurseUseTips=tmp[34];
                        var DocUseTips=tmp[35];
                        var Note=tmp[36];

						var UsageStr=OneDayTimeMin+","+OneDayTimeMax+","+OnceQtyMin+","+OnceQtyMax+","+OnceQtyUom;
						var UsageStr=UsageStr+","+OneDayQtyMin+","+OneDayQtyMax+","+OneDayQtyUom+","+OnceMaxQty+","+OnceMaxQtyUom;
						var UsageStr=UsageStr+","+OneDayMaxQty+","+OneDayMaxQtyUom+","+FristTimeQtyMin+","+FristTimeQtyMax+","+FristTimeQtyUom;
						var UsageStr=UsageStr+","+DurationQtyMin+","+DurationQtyMax+","+DurationQtyUom+","+SpaceQtyMin+","+SpaceQtyMax+","+SpaceQtyUom ;
	                    SetUsageVal(UsageStr); //??å§?ç½???æ³?????

			            $("#WeightMin").val(WeightMin);
						$("#WeightMax").val(WeightMax);
						$("#BodyAreaMin").val(BodyAreaMin);
						$("#BodyAreaMax").val(BodyAreaMax);
						if (PlanPregnancy=="Y")
						{
							$('#PlanPregnancy').attr("checked",'true')
						}
						if (Climacteric=="Y")
						{
							$('#Climacteric').attr("checked",'true')
						}
						if (Menstrual=="Y")
						{
							$('#Menstrual').attr("checked",'true')
						}
						if (Lactation=="Y")
						{
							$('#Lactation').attr("checked",'true')
						}
						if (Pregnant=="Y")
						{
							$('#Pregnant').attr("checked",'true')
						}
                        if (RenalFunction=="Y")
						{
							$('#RenalFunction').attr("checked",'true')
						}

						$("#AreaEatTips").val(NurseUseTips);
                        $("#AreaDocUseTips").val(DocUseTips);
						$("#AreaNote").val(Note);
                        var managemode=tmp[39] ;
						$('#ComboMode').combobox('select', managemode);
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


    //??è½½ç??æ³?

	function LoadRouteData()
	{

	  		var _json = jQuery.param({ "action":"GetDrugInstRouteData","drginstdr":druginstdr});
			var request = $.ajax({
				url: url,
				type: "POST",
				async: false,
				data: _json,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
					var str="";
		            var data=r.rowid ;
					if (data!="")
					{    
						var tmp=data.split(",")
						for(var i=0; i<tmp.length; i++){
							var desc=tmp[i];							
							$('#route').combogrid('grid').datagrid('selectRecord',tmp[i])

						}

						
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					
					}
			});




	}

    //?·æ??
	function refresh()
	{
		//window.location.reload();
		var lnk="dhcpha.clinical.adddisdosage.csp?drugid="+drugid+"&druginstdr=" ;
	    location.href=lnk;
	}

							



}


