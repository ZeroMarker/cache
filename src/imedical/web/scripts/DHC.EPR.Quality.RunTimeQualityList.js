var i = 1;
var x = 0;
var msg = "";

var qualityData = qualityCheck(key)	
//alert(qualityData);
var m = qualityData.split(";");
while(i<m.length) {
	if(m[x][1]!= "^"){
		msg += '<div id="test">'+m[x]+'</div>';
		i++;
		x++;
	}else{
		msg += '<div id="test">'+m[x].slice(2,m[x].length)+'</div>';
		i++;
		x++;
	}
}
//alert(msg);
var el = document.getElementById('messages');
el.innerHTML = msg;

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
