    
	///??????�?????
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

               //�?????�?
			  $('#route').combogrid({ 
				  url:url+"?action=QueryDrgUsageCombo&page=1&rows=100"+"&drugid="+drugid, 
				  valueField:'rowid',
				  idField:'rowid',
				  textField:'desc',
				  fitColumns: true,  
				  multiple:true, 
				  columns:[[    
					  {field:'desc',title:'??�?',width:100}, 
					  {field:'rowid',title:'rowid',width:80} 
				  ]],
				 onLoadSuccess:function(){

					  LoadRouteData();

				  }

			  }); 

			  //�?????�?
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
						  //??�???
						  var data = $('#route').combobox('getData');
						  if (data.length > 0) {
								  //$('#route').combobox('select', data[0].rowid);
							  } 
				  }

			  });
             */


			  LoadData();

		     //????年�?
			 $("#btnaddage").click(function (e) { 
				      
						AddAgeWindow(druginstdr,SetAgeVal);
			 })
			 //????????
			 $("#btndisease").click(function (e) {  

						AddDiseaseWindow(druginstdr,SetDiseaseVal);
					})

			 //�?????�?????
			 function SetDiseaseVal(str,idstr)
			 {

					 $("#disease").val(str);
					 $("#diseaseid").val(idstr);
				
				 
			 }

			 //�?年�?�?????
			 function SetAgeVal(str,idstr)
			 {
					 $("#age").val(str);
					 $("#ageid").val(idstr);
 		 
			 }

			 //�?????�?????
			 $("#btnaddusage").click(function (e) {  
                        
						AddDiseaseUsageWindow(druginstdr,drugid,SetUsageVal);
			 })
			 

			 //�?年�??�?????
			 function SetUsageVal(idstr)
			 {

				 if (idstr!="")
				 {
					 $("#usageid").val(idstr);
				 }
				 
			 }

             //�?�?

			 $("#btnReload").click(function (e) { 
				 druginstdr="";
				 refresh();
			 })

			 //�?�?
			 $("#btnSave").click(function (e) {  
                        

						 //????
						 var DrugDisease=$.trim($("#diseaseid").val());
						 if (DrugDisease=="")
						 {
								$.messager.alert('??�???�?,'????�??�为�?',"error");
								return;
						 }
						 //??�?
						 var UsageStr=$.trim($("#usageid").val());
						 if (UsageStr=="")
                         {
							  //$.messager.alert('??�???�?,'??�?�??�为�?',"error");
							  //return;

                         }

	
						 var Route="";  //年�?
						 var Routegrid=$("#route").combogrid("grid");//?��??�??��?�象
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

                         //年�?
						 var AgeStr=$.trim($("#ageid").val());
						 //????
						 var Sex=$("input[name='sex']:checked").val();
						 //�???
						 var WeightMin=$.trim($("#WeightMin").val());
						 var WeightMax=$.trim($("#WeightMax").val());
						 //�?�??��??
						 var BodyAreaMin=$.trim($("#BodyAreaMin").val());
						 var BodyAreaMax=$.trim($("#BodyAreaMax").val());  
						 //?��??人群
						 var PlanPregnancy="N";
						 if ($('#PlanPregnancy').attr('checked')) //计�??�?�?
						 {
							var PlanPregnancy="Y" ;
						 }
						 var Climacteric="N";
						 if ($('#Climacteric').attr('checked')) //?�年??�?�?
						 {
							var Climacteric="Y" ;
						 }
						 var Menstrual="N";
						 if ($('#Menstrual').attr('checked')) //�???
						 { 
							var Menstrual="Y" ;
						 }
						 var Lactation="N";
						 if ($('#Lactation').attr('checked')) //?�乳??
						 {  
							var Lactation="Y" ;
						 }
                         var Pregnant="N";
						 if ($('#Pregnant').attr('checked')) //�?�?
						 {
							var Pregnant="Y" ;
						 }
                         var RenalFunction="N";
						 if ($('#RenalFunction').attr('checked')) //???��???��???
						 {
							var RenalFunction="Y" ;
						 }
						 //??????�??��????)
						 var DocUseTips=$.trim($("#AreaDocUseTips").val());  
                         //??�???��)
                         var NurseUseTips=$.trim($("#AreaEatTips").val());
                         //�?�?
						 var Note=$.trim($("#AreaNote").val());
         
						 var ManageMode=$('#ComboMode').combobox('getValue');
						 if (ManageMode=="")
							{
										$.messager.alert('??�???�?,'�???�??�为�?',"error");
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
										$.messager.alert('??�???�?,'�?�?????!',"info");
										

									}else{
										$.messager.alert('??�???�?,'�?�?失败!',"error");
										return;
									}
						
								},
								error: function (XMLHttpRequest, textStatus, errorThrown) { 
									  //alert(XMLHttpRequest.readyState); 
									}
							});


			 })




//?��??
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
	                    SetUsageVal(UsageStr); //??�?�???�?????

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



    //??载年�?
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


	//??载�????
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


    //??载�??�?

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

    //?��??
	function refresh()
	{
		//window.location.reload();
		var lnk="dhcpha.clinical.adddisdosage.csp?drugid="+drugid+"&druginstdr=" ;
	    location.href=lnk;
	}

							



}


