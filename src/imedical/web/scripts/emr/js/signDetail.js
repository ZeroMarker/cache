function initDetail(){
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.AnySignLog",
					"Method":"GetCASignDetailByID",			
					"p1":signID
				},
			success : function(d) {
	           		if(d!=""){
						d = JSON.parse(d);
		           		loadData(d[0]);
		           	}
			},
			error : function(d) { alert("GetSignDetailByID error");
			}
		});
}

function loadData(data){
	$('#signValue').text(data["SignValue"]);	
	$('#SignTimeStamp').text(data["SignTimeStamp"]);
}