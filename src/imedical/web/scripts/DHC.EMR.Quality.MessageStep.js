$(function(){
    jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EPRservice.Quality.DataAccess.BOQualityMessage",
			"Method":"GetMessageStepByMesId",
			"p1":MessageID,	
		},
		success: function(d) {
			var data=eval(d)
			var empetyInd=data.length
			console.log(eval(d))
			for (var i=0;i<data.length;i++)
			{
				console.log(data[i].context)
				if (data[i].context=="") 
				{ 
					empetyInd=i 
					break
				}
			}
			$("#vstp").vstep({
		        stepHeight:50,
		        currentInd:empetyInd,
		        items:data
		    });
		},
		error : function(d) { alert(action+"GetSummary error");}
	});	
    
});

