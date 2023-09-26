    
	//??å±?????
	function InitUseqty()
    {

		  var typedr="";
		  var url='dhcpha.clinical.action.csp' ;

		  var Request = new Object();
		  Request = GetRequest();
          var drugid = Request['drugid'];
		  var druginstdr = Request['druginstdr'];
  
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
							 // $('#OnceQtyUom').combobox('select', data[0].rowid);
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
							  //$('#DurationQtyUom').combobox('select', data[0].rowid);
						  } 
			  }

		  }); 
		  
         
		  $('#agecombogrid').combogrid({ 
			  url:url+"?action=QueryContrastAgeDs&page=1&rows=100", 
			  valueField:'rowid',
			  idField:'rowid',
			  textField:'desc',
			  fitColumns: true,  
			  multiple:true, 
			  columns:[[    
				  {field:'desc',title:'å¹´é?',width:100}, 
				  {field:'agemin',title:'??å°?',width:80},   
				  {field:'agemax',title:'??å¤?',width:80}, 
				  {field:'rowid',title:'rowid',width:80} 
			  ]],
			 onLoadSuccess:function(){

				  LoadAagData();

			  }

		  }); 

     LoadData();

     $("#btnAdd").click(function (e) {   
                Save();
            })

 
    
    //?°å?
    function Save()
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
	

		//var ss = [];
		var AgeStr="";  //å¹´é?
		var agegrid=$("#agecombogrid").combogrid("grid");//?·å??è¡??¼å?¹è±¡
		var rows  = agegrid.datagrid('getSelections');//
		for(var i=0; i<rows.length; i++){
                var row = rows[i];
				var ageid=row.rowid ;
				if (AgeStr=="")
				{
					AgeStr=ageid;
				}else{
					AgeStr=AgeStr+","+ageid ; 
				}
                //ss.push('<span>'+row.itemid+":"+row.productid+":"+row.attr1+'</span>');
				

        }

         //$.messager.alert('Info', ss.join('<br/>'));

         //????
		 var Sex=$("input[name='sex']:checked").val(); 
		 //èº?é«?
         var WeightMin=$.trim($("#WeightMin").val());
         var WeightMax=$.trim($("#WeightMax").val());



         var input=OneDayTimeMin+"^"+OneDayTimeMax+"^"+OnceQtyMin+"^"+OnceQtyMax+"^"+OnceQtyUom;
		 var input=input+"^"+OneDayQtyMin+"^"+OneDayQtyMax+"^"+OneDayQtyUom+"^"+OnceMaxQty+"^"+OnceMaxQtyUom;
		 var input=input+"^"+OneDayMaxQty+"^"+OneDayMaxQtyUom+"^"+FristTimeQtyMin+"^"+FristTimeQtyMax+"^"+FristTimeQtyUom;
		 var input=input+"^"+DurationQtyMin+"^"+DurationQtyMax+"^"+DurationQtyUom+"^"+SpaceQtyMin+"^"+SpaceQtyMax+"^"+SpaceQtyUom ;
		 var input=input+"^"+Sex+"^"+AgeStr+"^"+WeightMin+"^"+WeightMax;

		 

         var optype="UseQty"
		 var _json = jQuery.param({ "action":"SaveUseQty","input":input,"drugid":drugid,"typedr":typedr,"optype":optype});
			var request = $.ajax({
				url: url,
				type: "POST",
				async: false,
				data: _json,
				dataType: "json",
				//contentType: "charset=utf-8",
				cache: false,
				success: function (r, textStatus) {
					if (r.retvalue!=0)
					{
						$.messager.alert('??è¯???ç¤?,'ä¿?å­?å¤±è´¥!',"error");
						return;

					}

					$.messager.alert('??ä½???ç¤?,'ä¿?å­?????!',"info");
		
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


	function LoadAagData()
	{

	  		var _json = jQuery.param({ "action":"GetDrugInstAgeData","drginstdr":druginstdr});
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
					if (data!="")
					{    
						var tmp=data.split(",")
						for(var i=0; i<tmp.length; i++){
							var desc=tmp[i];							
							$('#agecombogrid').combogrid('grid').datagrid('selectRecord',tmp[i])

						}

						
					}
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					
					}
			});




	}










}


