$(document).ready(function() {	
	$("#checkboxItem4").checkbox({
		onChecked: function()
		{
			$("#checkboxItem5").checkbox('enable');
			$("#checkboxItem6").checkbox('enable');
			$("#checkboxItem7").checkbox('enable');
			$("#checkboxItem8").checkbox('enable');
			$("#checkboxItem9").checkbox('enable');
			$("#checkboxItem10").checkbox('enable');
			$("#checkboxItem11").checkbox('enable');
			
		},
		onUnchecked: function()
		{
			$("#checkboxItem5").checkbox('uncheck');
			$("#checkboxItem6").checkbox('uncheck');
			$("#checkboxItem7").checkbox('uncheck');
			$("#checkboxItem8").checkbox('uncheck');
			$("#checkboxItem9").checkbox('uncheck');
			$("#checkboxItem10").checkbox('uncheck');
			$("#checkboxItem11").checkbox('uncheck');
			///
			$("#checkboxItem5").checkbox('disable');
			$("#checkboxItem6").checkbox('disable');
			$("#checkboxItem7").checkbox('disable');
			$("#checkboxItem8").checkbox('disable');
			$("#checkboxItem9").checkbox('disable');
			$("#checkboxItem10").checkbox('disable');
			$("#checkboxItem11").checkbox('disable');
		}

    });
    $("#checkboxItem24").checkbox({
	    onChecked: function()
	    {
		    $("#checkboxItem25").checkbox('enable');
			$("#checkboxItem26").checkbox('enable');
			$("#checkboxItem27").checkbox('enable');
			$("#checkboxItem28").checkbox('enable');
			$("#checkboxItem29").checkbox('enable');
			$("#checkboxItem30").checkbox('enable');
			$("#checkboxItem31").checkbox('enable');
			$("#checkboxItem32").checkbox('enable');
			$("#checkboxItem33").checkbox('enable');
			$("#checkboxItem34").checkbox('enable');
			$("#checkboxItem35").checkbox('enable');
			$("#checkboxItem36").checkbox('enable');
	    },
	    onUnchecked: function()
	    {
		    $("#checkboxItem25").checkbox('uncheck');
			$("#checkboxItem26").checkbox('uncheck');
			$("#checkboxItem27").checkbox('uncheck');
			$("#checkboxItem28").checkbox('uncheck');
			$("#checkboxItem29").checkbox('uncheck');
			$("#checkboxItem30").checkbox('uncheck');
			$("#checkboxItem31").checkbox('uncheck');
			$("#checkboxItem32").checkbox('uncheck');
			$("#checkboxItem33").checkbox('uncheck');
			$("#checkboxItem34").checkbox('uncheck');
			$("#checkboxItem35").checkbox('uncheck');
			$("#checkboxItem36").checkbox('uncheck');
		    ///
		    $("#checkboxItem25").checkbox('disable');
			$("#checkboxItem26").checkbox('disable');
			$("#checkboxItem27").checkbox('disable');
			$("#checkboxItem28").checkbox('disable');
			$("#checkboxItem29").checkbox('disable');
			$("#checkboxItem30").checkbox('disable');
			$("#checkboxItem31").checkbox('disable');
			$("#checkboxItem32").checkbox('disable');
			$("#checkboxItem33").checkbox('disable');
			$("#checkboxItem34").checkbox('disable');
			$("#checkboxItem35").checkbox('disable');
			$("#checkboxItem36").checkbox('disable');
		    
	    }
	    
	    
	    
	    
	    
	    })
	    $("#checkboxItem38").checkbox({
		    onChecked: function()
		    {
			   $("#checkboxItem39").checkbox('enable');
			   $("#checkboxItem40").checkbox('enable'); 
		    } ,
		    onUnchecked: function()
		    {
			   $("#checkboxItem39").checkbox('uncheck');
			   $("#checkboxItem40").checkbox('uncheck');
			   $("#checkboxItem39").checkbox('disable');
			   $("#checkboxItem40").checkbox('disable');
		    
			    
		    }
		    
		    
		    
		    
		    
		    })
		    $("#numberspinnerItem").on({
			    keyup: function()
			    {
				    var n1 = $("#numberspinnerItem1").numberbox('getValue')/1;
				    var n2 = $("#numberspinnerItem2").numberbox('getValue')/1;
				    var n3 = $("#numberspinnerItem3").numberbox('getValue')/1;
				    var n4 = $("#numberspinnerItem4").numberbox('getValue')/1;
				    var n5 = $("#numberspinnerItem5").numberbox('getValue')/1;
				    var n6 = $("#numberspinnerItem6").numberbox('getValue')/1;
				    var n7 = $("#numberspinnerItem7").numberbox('getValue')/1;
				    var n8 = $("#numberspinnerItem8").numberbox('getValue')/1;
				    var n9 = $("#numberspinnerItem9").numberbox('getValue')/1;
				    var n = n1+n2+n3+n4+n5+n6+n7+n8+n9
				    
				    $("#numberspinnerItem").numberbox('setValue',n)
			    }
			     });
			     $("#numberspinnerItem16").on({
			    keyup: function()
			    {   
			        var n6 = $("#numberspinnerItem10").numberbox('getValue')/1;
				    var n1 = $("#numberspinnerItem11").numberbox('getValue')/1;
				    var n2 = $("#numberspinnerItem12").numberbox('getValue')/1;
				    var n3 = $("#numberspinnerItem13").numberbox('getValue')/1;
				    var n4 = $("#numberspinnerItem14").numberbox('getValue')/1;
				    var n5 = $("#numberspinnerItem15").numberbox('getValue')/1;
				    var n = n1+n2+n3+n4+n5+n6
				    
				    $("#numberspinnerItem16").numberbox('setValue',n)
			    }
			     });
			     
		    
});
