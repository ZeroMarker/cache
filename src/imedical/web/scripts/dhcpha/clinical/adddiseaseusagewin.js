   
    //�???????�?�?
	AddDiseaseUsageWindow= function(druginstdr,drugid,Fn)
    {
          
		  var url='dhcpha.clinical.action.csp' ;
		  

		  var RetUsageRowidStr="";
	      $('#diseaseusagewin').window({ 
			   title:'�???????',
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




		  //??�?
	      $('#OnceQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??�???
					  var data = $('#OnceQtyUom').combobox('getData');
					  if (data.length > 0) {
							  //$('#OnceQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  });
		  

          //�?????
		  $('#OneDayQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??�???
					  var data = $('#OneDayQtyUom').combobox('getData');
					  if (data.length > 0) {
							  //$('#OneDayQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  });

          //�?次�??�???
		  $('#OnceMaxQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??�???
					  var data = $('#OnceMaxQtyUom').combobox('getData');
					  if (data.length > 0) {
							  //$('#OnceMaxQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  });

          //�?????�???
		  $('#OneDayMaxQtyUom').combobox({ 
			  panelHeight: "auto",
			  url:url+"?action=QueryDrgUomDs"+"&drugid="+drugid, 
			  valueField:'rowid', 
			  textField:'desc',
			  onSelect: function (record) {
                 //$("#hide_quale").val(record.ID);
              },
			  onLoadSuccess:function(){
				  	  //??�???
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
				  	  //??�???
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
				  	  //??�???
					  var data = $('#DurationQtyUom').combobox('getData');
					  if (data.length > 0) {
							 // $('#DurationQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  }); 


	      LoadData();
          //??�???�?
	      function SaveUsage()
		  {
			  
				
				var OneDayTimeMin=$.trim($("#OneDayTimeMin").val());  //�???????次�?��???�??��?
				var OneDayTimeMax=$.trim($("#OneDayTimeMax").val());  //�???????次�?��???�??��?

				var OnceQtyMin=$.trim($("#OnceQtyMin").val());   //??次�??????(??�??? 
				var OnceQtyMax=$.trim($("#OnceQtyMax").val());   //??次�??????(??�???
				var OnceQtyUom=$('#OnceQtyUom').combobox('getValue');

				var OneDayQtyMin=$.trim($("#OneDayQtyMin").val());   //�????????��??(??�???
				var OneDayQtyMax=$.trim($("#OneDayQtyMax").val());   //�????????��??(??�???
				var OneDayQtyUom=$('#OneDayQtyUom').combobox('getValue'); 

				var OnceMaxQty=$.trim($("#OnceMaxQty").val()); 
				var OnceMaxQtyUom=$('#OnceMaxQtyUom').combobox('getValue');  //�?次�??�???
				
				var OneDayMaxQty=$.trim($("#OneDayMaxQty").val()); 
				var OneDayMaxQtyUom=$('#OneDayMaxQtyUom').combobox('getValue');  //�?????�???
		 
				var FristTimeQtyMin=$.trim($("#FristTimeQtyMin").val());       //�?次�??????(??�???
				var FristTimeQtyMax=$.trim($("#FristTimeQtyMax").val());       //�?次�??????(??�???
				var FristTimeQtyUom=$('#FristTimeQtyUom').combobox('getValue');  //�?欨S??

				var DurationQtyMin=$.trim($("#DurationQtyMin").val());   //�???(??�???
				var DurationQtyMax=$.trim($("#DurationQtyMax").val());   //�???(??�???
				var DurationQtyUom=$('#DurationQtyUom').combobox('getValue'); 

				var SpaceQtyMin=$.trim($("#SpaceQtyMin").val());  //?��??
				var SpaceQtyMax=$.trim($("#SpaceQtyMax").val()); 
				var SpaceQtyUom=$('#SpaceQtyUom').combobox('getValue');


				var UsageStr=OneDayTimeMin+","+OneDayTimeMax+","+OnceQtyMin+","+OnceQtyMax+","+OnceQtyUom;
				var UsageStr=UsageStr+","+OneDayQtyMin+","+OneDayQtyMax+","+OneDayQtyUom+","+OnceMaxQty+","+OnceMaxQtyUom;
				var UsageStr=UsageStr+","+OneDayMaxQty+","+OneDayMaxQtyUom+","+FristTimeQtyMin+","+FristTimeQtyMax+","+FristTimeQtyUom;
				var UsageStr=UsageStr+","+DurationQtyMin+","+DurationQtyMax+","+DurationQtyUom+","+SpaceQtyMin+","+SpaceQtyMax+","+SpaceQtyUom ;
	
                RetUsageRowidStr=UsageStr ;
				
			    returnData() ;


		  }

		  
          //??�?
		  $("#btnSaveUsage").click(function (e) {  
                SaveUsage();
			})



		  //�????��?? 
		  function returnData()
		  {
			  $('#diseaseusagewin').window('close');
		  }

		  	  
		  //?��??�?�?
          $('#diseaseusagewin').window({
                 onBeforeClose: function () { 
					 Fn(RetUsageRowidStr);

                 }
 

            });



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


