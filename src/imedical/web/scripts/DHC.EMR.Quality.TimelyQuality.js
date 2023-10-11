/*
	*zyp  20221220
*/

$(function(){
	//根据TipType判断走那个接口  若是SERVICE则走新接口,空值则走老接口
	var msg='';
	if(TipType=='SERVICE'){
		var msgCode=getZKRst()

		if(msgCode.result_code==-1){
			alert(msgCode. result_message)	
			return
		}	
		
		var arr=msgCode.result_data;
		for(var i=0;i<arr.length;i++){
			msg+='<div class="msg-div textmessage" style="border:none">'
			msg+=arr[i].MRQ_Desc
			msg+='&nbsp;&nbsp;&nbsp;&nbsp;';
			msg+='<div class="icon-location" style="display:inline-block;width:16px;" title="定位" onClick="iconClick('+'\''+setredcode[1]+'\''+')">&nbsp;</div>'
			msg+='</div>'	
		}
	}else{
		var qualityData = qualityCheck(key)
		var i = 1;
		var x = 0;
		var m = qualityData.split(";");	
		while(i<m.length) {
			var setredcode = m[x].split("#");

			msg+='<div class="msg-div textmessage" style="border:none">'
			msg+=setredcode[0]
			msg+='&nbsp;&nbsp;&nbsp;&nbsp;';
			msg+='<div class="icon-location" style="display:inline-block;width:16px;" title="定位" onClick="iconClick('+'\''+setredcode[1]+'\''+')">&nbsp;</div>'
			msg+='</div>'
			
			i++;
			x++;
		}
	}
	
	var zkMsgTip=document.getElementById('zkMsgTip');
	zkMsgTip.innerHTML=msg;
	
	var msgDiv = $('.msg-div');
	for (var i = 0; i < msgDiv.length; i++) {
	    $(msgDiv[i]).bind("click", { index: i }, msgClick);
	}
	
	
	//整个页面重新编译
	$.parser.parse();
	
	
})

//点击每一条消息事件  添加背景色
function msgClick(event){
	var i = event.data.index;
    $('.msg-div').eq(i).addClass('active');
    $('.msg-div').eq(i).siblings().removeClass('active');	
}

//点击图标事件
function iconClick(code){
	
	var codeList = code.split("^");	
	if ((codeList[1]=="")&&(codeList[2]=="")) return
	parent.parent.qualityTextFindNext(code)
}

//获取质控消息结果接口
function getZKRst(){
	var result = "0"
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"MA.QC.SRV.QCServiveTest",
					"Method":"QualityCheckTest",			
					"p1":EpisodeID,
					"p2":InstanceID
				},
			success: function(d) {
					result = d;
			},
			error : function(d) { alert("GetSummery error");}
		});
			
	return result;
}


//获取质控消息结果接口  老接口
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
