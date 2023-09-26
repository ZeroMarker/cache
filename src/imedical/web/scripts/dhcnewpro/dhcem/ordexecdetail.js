$(function (){	
	initPage();
})

function initPage(){
	runClassMethod("web.DHCEMOrdExecDetail","GetExecDetailByOEORIDr",
		{"OEORIDr":OEORIId},
		function(data){
			showPatInfo(data.patInfo);
			showOrdInfo(data.OEOREInfo);
		},"json",false
	)
}

function showPatInfo(data){
	var dataArr = data.patInfo.split("^");
	$("#patName").html(dataArr[1]);
	$("#patSex").html(dataArr[2]);
	$("#regNo").html(dataArr[0]);

	if(dataArr[2]=="男"){
		$("#patSexImg").attr("src","../scripts/dhcnewpro/images/dhcMan.png")
	}else if(dataArr[2]=="女"){
		$("#patSexImg").attr("src","../scripts/dhcnewpro/images/dhcWoman.png")
	}
}

function showOrdInfo(data){
	$("#arciName").val(data[0].ArciName)
	for(var i=0;i<data.length;i++){
		addExecItm(data[i]);
	}	
}

function addExecItm(data){
	$("#arciName").html(data.ArciName);
	var imgUrl=""
	var retHtml="";
	if(data.ExecFlag){
		imgUrl = "../scripts/dhcnewpro/images/yzx32.png"
	}else{
		imgUrl="../scripts/dhcnewpro/images/wzx32.png";
	}

	retHtml=	'<td class="detail-td" >';
 	retHtml=retHtml+'<div style="height:100%;width:100%">';
 	retHtml=retHtml+	'<div class="execDate" style="">';
 	retHtml=retHtml+		data.ExecDate+" "+data.ExecTime;
 	retHtml=retHtml+	'</div>';
 	retHtml=retHtml+	'<div class="execImg">';
 	retHtml=retHtml+		'<img src="'+imgUrl+'"/>';
 	retHtml=retHtml+	'</div>';
 	retHtml=retHtml+	'<div class="needExecDate">';
 	retHtml=retHtml+		data.NeedExecDate+" "+data.NeedExecTime;
 	retHtml=retHtml+	'</div>';
 	retHtml=retHtml+'</div>';
 	retHtml=retHtml+'</td>';
 	$("#detail-tr").append(retHtml);
}