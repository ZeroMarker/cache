$(function(){
	var i = 1;
	var x = 0;
	var msg = "";

	var qualityData = qualityCheck(key)	
	//alert(qualityData);
	var m = qualityData.split(";");	
	while(i<m.length) {
		var setredcode = m[x].split("#");
		var codes=""
		for (var j=1;j<setredcode.length;j++)
		{
			//msg += '<div id='+setredcode[j]+' onclick="javascript:setred(this)" class="textmessage">'+setredcode[0]+'</div>';
			if(codes!="")
			{
				codes=codes+"^"+setredcode[j]
			}
			else
			{
				codes=setredcode[j]
			}
		}
		msg += '<div id='+codes+' onclick="javascript:setred(this)" class="textmessage">'+setredcode[0]+'</div>';
		i++;
		x++;
	}
	//alert(msg);
	var el = document.getElementById('messages');
	el.innerHTML = msg;
	
	
	
});

function setred(obj)
{
	if (typeof parent.qualityMarkRequiredObjects  == "function")
  {
    parent.qualityMarkRequiredObjects(obj.id)
  }else if (typeof parent.parent.qualityMarkRequiredObjects  == "function")
  {
    parent.parent.qualityMarkRequiredObjects(obj.id)
  };
}


//ÖÊ¿Ø
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
