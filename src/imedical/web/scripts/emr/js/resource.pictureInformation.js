$(function(){
	$HUI.radio("#currentEpisode").setValue(true);
	$HUI.radio("#sortDefault").setValue(true);
});
$HUI.radio("[name='episode']",{
	onChecked:function(el){
		if(el.target.value==="allEpisode"){
			initEpisodeList("#EpisodeList");
		}else{
			return;
		}
	}	
})
$HUI.radio("[name='sort']",{
	onChecked:function(el){
		queryData();
		}
	})
//打开院外资料
$("#output").click(function(){
	var win = window.open("emr.picturemanage.csp?EpisodeID="+episodeID+"&PatientID="+patientID,"pictureManage","resizable=yes,height=850,width=1250,left=100;");
})
//放大
function enlarge(){
	imgToSize(100);
}
//缩小
function reduce(){
	imgToSize(-100);	
}
//上一张
function prev(){
	len = $("#picList img").length
	if(count<=0){
		count = len-1;
	}else{
		count--;
	}
	$("#picList .picItem")[count].click();
	move(count);	
}
//下一张
function next(){
	len = $("#picList img").length
	if(count >= len-1){
		count=0;	
	}else{
		count++;
	}
	$("#picList .picItem")[count].click();
	move(count);	
}
//移动图片
function move(arg){
	var img = $("#picList img")[0];
	var imgWidth =parseInt(getStyle(img).width);
	if(arg>4){
		$("#picList").scrollLeft((arg-4)*imgWidth);
	}else{
		$("#picList").scrollLeft(0);
	}
}
//向左旋转
function left(){
	deg -= 90;
	$("#pic img").css("transform","rotate("+deg+"deg)");
}
//向右旋转
function right(){
	deg += 90;
	$("#pic img").css("transform","rotate("+deg+"deg)");
}
//删除图片
function del(){
	var RowId=$($("#picList .picItem")[count]).val();
	$($("#picList li")[count]).remove();
	
	if(count>0){
		count--;	
	}else if(count=0){
		return;
	}
	var len = $("#picList img").index();
	if(len=0){
		return;
	}else{
		$("#picList .picItem")[count].click();
	}
	jQuery.ajax({
        type: "Get",
        dataType: "text",
        url: "../EMRservice.Ajax.pictureManage.cls",
        data: {
            "RowId":RowId,
            "Action":"delPic"
        },
        async: false,
        success: function(data) {
	         alert(data); 
        },
        error : function(d) { 
            alert("GetViewDisplayData error");
        }
    });
}
function getStyle(ele){
	return window.getComputedStyle ? window.getComputedStyle(ele) : ele.currentStyle;	
}
function imgToSize(size){
	var img = $("#pic img")[0];
	var imgWidth =parseInt(getStyle(img).width);
	var imgHeight = parseInt(getStyle(img).height);
	$(img).css("width",imgWidth+size+"px");
	$(img).css("height",imgHeight+size+"px");	
} 
function getData(episodes,sort){
	jQuery.ajax({
        type: "Get",
        dataType: "text",
        url: "../EMRservice.Ajax.pictureManage.cls",
        data: {
            "episodes":episodes,
            "sort":sort,
            "Action":"getPicList"
        },
        async: false,
        success: function(data) {
             var list = eval(data)
             init(list);
        },
        error : function(d) { 
            alert("GetViewDisplayData error");
        }
    });	
}
//查询
function queryData(){
	$("#pic img").remove();
	var episodeValues = $("input[name='episode']:checked").val();
	if(episodeValues ==="currentEpisode" ){
		episodeValues = episodeID;
	}else{
		episodeValues = $('#EpisodeList').combogrid('getValues');
		episodeValues = episodeValues.join(',');
	}
	var picSort = $("input[name='sort']:checked").val();
	if(picSort == undefined) return
	picSort=picSort.toUpperCase();
	getData(episodeValues,picSort);
	if ($("#picList .picItem")[0] == undefined) return
	$("#picList .picItem")[0].click();
}
function init(picArr){
	var len = picArr.length;
	var content = "<ul class='clearFix' style='display:block;width:"+(len*90)+";'>";
	for(var i=0;i<len;i++){
		content += "<li class='picItem' value="+picArr[i]['RowId']+" style='width:80px;height:80px;'><img src="+picArr[i]["pic"]+" width='100%' height='100%' style='transform:rotate(-90deg);'></li>";	
	}
	content += "</ul>" 
	document.getElementById("picList").innerHTML = content;
	/*
	$("#pic .picItem")[j].onclick=function(){
		$(this).addClass("on");
		$($("#pic .picItem")[index]).removeClass("on");
		index = j;
	}*/
	$("#picList .picItem").click(function(e)
	{
	   $(this).addClass("on").siblings(".picItem").removeClass("on");
	   count=$(this).index();
	   move(count);
	   document.getElementById("pic").innerHTML = "<img class='picType' src="+$(this).find('img').attr('src')+" width='550px'>"; 
	   deg = -90;
	   $("#pic img").css("transform","rotate("+deg+"deg)");
	});	
}
