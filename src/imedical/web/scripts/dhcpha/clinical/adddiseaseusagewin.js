   
    //å½???????çª?ä½?
	AddDiseaseUsageWindow= function(druginstdr,drugid,Fn)
    {
          
		  var url='dhcpha.clinical.action.csp' ;
		  

		  var RetUsageRowidStr="";
	      $('#diseaseusagewin').window({ 
			   title:'å½???????',
			   minimizable:false,
			   maximizable:false,
			   collapsible:false,
			   width:550,   
			    height:500,   
			     modal:true
			 });

			   

            var mywin = document.getElementById("diseaseusagewin");
			if (mywin)
			{
				mywin.style.display="block";
			}




		  //??æ¬?
	      $('#OnceQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??å§???
					  var data = $('#OnceQtyUom').combobox('getData');
					  if (data.length > 0) {
							  //$('#OnceQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  });
		  

          //æ¯?????
		  $('#OneDayQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??å§???
					  var data = $('#OneDayQtyUom').combobox('getData');
					  if (data.length > 0) {
							  //$('#OneDayQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  });

          //æ¯?æ¬¡Í??å¤???
		  $('#OnceMaxQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??å§???
					  var data = $('#OnceMaxQtyUom').combobox('getData');
					  if (data.length > 0) {
							  //$('#OnceMaxQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  });

          //æ¯?????å¤???
		  $('#OneDayMaxQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??å§???
					  var data = $('#OneDayMaxQtyUom').combobox('getData');
					  if (data.length > 0) {
							  //$('#OneDayMaxQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  });
          
		  //
          $('#FristTimeQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??å§???
					  var data = $('#FristTimeQtyUom').combobox('getData');
					  if (data.length > 0) {
							  //$('#FristTimeQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  });
		  

		  $('#DurationQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??å§???
					  var data = $('#DurationQtyUom').combobox('getData');
					  if (data.length > 0) {
							 // $('#DurationQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  }); 


	      LoadData();
          //??äº???æ³?
	      function SaveUsage()
		  {
			  
				
				var OneDayTimeMin=$.trim($("#OneDayTimeMin").val());  //æ¯???????æ¬¡Í?°ï???å°??¼ï?
				var OneDayTimeMax=$.trim($("#OneDayTimeMax").val());  //æ¯???????æ¬¡Í?°ï???å¤??¼ï?

				var OnceQtyMin=$.trim($("#OnceQtyMin").val());   //??æ¬¡Í??????(??å°??? 
				var OnceQtyMax=$.trim($("#OnceQtyMax").val());   //??æ¬¡Í??????(??å¤???
				var OnceQtyUom=$('#OnceQtyUom').combobox('getValue');

				var OneDayQtyMin=$.trim($("#OneDayQtyMin").val());   //æ¯????????»é??(??å°???
				var OneDayQtyMax=$.trim($("#OneDayQtyMax").val());   //æ¯????????»é??(??å¤???
				var OneDayQtyUom=$('#OneDayQtyUom').combobox('getValue'); 

				var OnceMaxQty=$.trim($("#OnceMaxQty").val()); 
				var OnceMaxQtyUom=$('#OnceMaxQtyUom').combobox('getValue');  //æ¯?æ¬¡Í??å¤???
				
				var OneDayMaxQty=$.trim($("#OneDayMaxQty").val()); 
				var OneDayMaxQtyUom=$('#OneDayMaxQtyUom').combobox('getValue');  //æ¯?????å¤???
		 
				var FristTimeQtyMin=$.trim($("#FristTimeQtyMin").val());       //é¦?æ¬¡Í??????(??å°???
				var FristTimeQtyMax=$.trim($("#FristTimeQtyMax").val());       //é¦?æ¬¡Í??????(??å¤???
				var FristTimeQtyUom=$('#FristTimeQtyUom').combobox('getValue');  //é¦?æ¬¨S??

				var DurationQtyMin=$.trim($("#DurationQtyMin").val());   //è¿???(??å°???
				var DurationQtyMax=$.trim($("#DurationQtyMax").val());   //è¿???(??å¤???
				var DurationQtyUom=$('#DurationQtyUom').combobox('getValue'); 

				var SpaceQtyMin=$.trim($("#SpaceQtyMin").val());  //?´é??
				var SpaceQtyMax=$.trim($("#SpaceQtyMax").val()); 
				var SpaceQtyUom=$('#SpaceQtyUom').combobox('getValue');


				var UsageStr=OneDayTimeMin+","+OneDayTimeMax+","+OnceQtyMin+","+OnceQtyMax+","+OnceQtyUom;
				var UsageStr=UsageStr+","+OneDayQtyMin+","+OneDayQtyMax+","+OneDayQtyUom+","+OnceMaxQty+","+OnceMaxQtyUom;
				var UsageStr=UsageStr+","+OneDayMaxQty+","+OneDayMaxQtyUom+","+FristTimeQtyMin+","+FristTimeQtyMax+","+FristTimeQtyUom;
				var UsageStr=UsageStr+","+DurationQtyMin+","+DurationQtyMax+","+DurationQtyUom+","+SpaceQtyMin+","+SpaceQtyMax+","+SpaceQtyUom ;
	
                RetUsageRowidStr=UsageStr ;
				
			    returnData() ;


		  }

		  
          //??äº?
		  $("#btnSaveUsage").click(function (e) {  
                SaveUsage();
			})



		  //è¿????°æ?? 
		  function returnData()
		  {
			  $('#diseaseusagewin').window('close');
		  }

		  	  
		  //?³é??äº?ä»?
          $('#diseaseusagewin').window({
                 onBeforeClose: function () { 
					 Fn(RetUsageRowidStr);

                 }
 

            });



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
						$("#OneDayTimeMin").val(OneDayTimeMin);
                        $("#OneDayTimeMax").val(OneDayTimeMax);
						$("#OnceQtyMin").val(OnceQtyMin);
						$("#OnceQtyMax").val(OnceQtyMax);
						$('#OnceQtyUom').combobox('setValue',OnceQtyUom);
						$("#OneDayQtyMin").val(OneDayQtyMin);
						$("#OneDayQtyMax").val(OneDayQtyMax);
						$('#OneDayQtyUom').combobox('setValue',OneDayQtyUom);
						$("#OnceMaxQty").val(OnceMaxQty);
						$('#OnceMaxQtyUom').combobox('setValue',OnceMaxQtyUom);
						$("#OneDayMaxQty").val(OneDayMaxQty);
						$('#OneDayMaxQtyUom').combobox('setValue',OneDayMaxQtyUom);
						$("#FristTimeQtyMin").val(FristTimeQtyMin);
						$("#FristTimeQtyMax").val(FristTimeQtyMax);
						$('#FristTimeQtyUom').combobox('setValue',FristTimeQtyUom);
						$("#DurationQtyMin").val(DurationQtyMin);
						$("#DurationQtyMax").val(DurationQtyMax);
						$('#DurationQtyUom').combobox('setValue',DurationQtyUom);
                        $("#SpaceQtyMin").val(SpaceQtyMin);
						$("#SpaceQtyMax").val(SpaceQtyMax);
						//$('#SpaceQtyUom').combobox('setValue',SpaceQtyUom);
						
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

      
                        $("#WeightMin").val(WeightMin);
						$("#WeightMax").val(WeightMax);
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					}
			});


                              



	}





}


