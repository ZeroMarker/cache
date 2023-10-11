$(function(){
	var i = 1;
	var x = 0;
	var msg = "";

	var qualityData = qualityCheck(key)	
	//alert(qualityData);
	var m = qualityData.split(";");	
	while(i<m.length) {
		var setredcode = m[x].split("#");
		msg += '<div id='+setredcode[1]+' onclick="javascript:setred(this)" class="textmessage">'+setredcode[0]+'</div>';
		i++;
		x++;
	}
	//alert(msg);
	var el = document.getElementById('messages');
	el.innerHTML = msg;
	
	
	
});

function setred(obj)
{
	//alert(obj.id);
	parent.qualityMarkRequiredObjects(obj.id);
}

//质控
function qualityCheck(key)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.HISInterface.QualityInterface",
					"Method":"GetCheckResultList",	
					"p1":EpisodeID,		
					"p2":key
				},
			success: function(d) {
					result = d;
			},
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}
