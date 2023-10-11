$(function(){
	initDateList();
	$('#dateList').on('mouseenter', 'li', function() {
	    $(this).find('#dot').addClass("hoverdot");
	});
	$('#dateList').on('mouseleave', 'li', function() {
	   $(this).find('#dot').removeClass("hoverdot");
	});
});

function initDateList()
{
	if (tempdateObj !== "")
	{
		var date = tempdateObj;
		$('#dateList').empty();
		$('#dateList').addClass('date-item');
		$('#dateList').append('<div class="head"></div>');
		for (var i=0;i<date.length;i++)
		{
			var li = $('<li></li>');
			$(li).attr({"id":date[i].EpisodeID,"text":date[i].AdmDate});
			$(li).append('<div id="dot" class="left"></div>')
			
			var right = $('<a href="#" class="right"></a>');
			var first = $('<div class="first">' + date[i].AdmDate + '</div>');
			$(right).append(first);
			$(li).append(right);
			$('#dateList').append(li);
		}
		$('#dateList').append('<div class="foot"></div>');
		$('#'+date[0].EpisodeID).click();//时间轴倒叙排列，默认选中第一个，也就是最近一次就诊
	}
}

function reload(iframeid)
{
	var src = "emr.ip.pasthistorybydate.csp?tempdate=" + tempdateStr;
	parent.reloadIframe(iframeid,src);
}

//目录点击事件
$(document).on("click","#dateList.date-item li",function()
{
	//alert($(this).attr("id"));
	//alert(userLocID);
	//alert(userSSGroupID);
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLPastHistory",
			"Method":"getEMRpasthistory",
			"p1":$(this).attr("id")
		},
		success: function(d) {
			if (d !== "")
			{
				$('#EMRpasthistoryPanel').html(d);
			}
			else
			{
				$('#EMRpasthistoryPanel').html("暂无既往史内容！");
			}
		},
		error : function(d) {
			$.messager.alert("提示信息", "getEMRpasthistory ERROR！", 'info');
		}
	});

	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLPastHistory",
			"Method":"getHisDataByAdm",
			"p1":$(this).attr("id")
		},
		success: function(d) {
			setTreeData(eval("["+d+"]"),"");
		},
		error : function(d) {
			$.messager.alert("提示信息", "getHisDataByAdm ERROR！", 'info');
		}
	});	
	
});

function setTreeData(data,instanceId)
{
	$('#pastHisTree').tree({  
		lines:true,
	    data:data,
	    onSelect:function(node){
		   
		},
		formatter:function(node){
			var output = node.text;
			var input = node.text;
			if (input.indexOf("douhaodouhao")){
				output = input.replace('douhaodouhao','，');
			}
			return output;
		},
		autoNodeHeight:true	 
	});
}

//选中文档目录
function selectListRecord(id)
{
	$(".dateList .datepanel").each(function()
	{
		if ($(this).attr('id') == undefined) return;
		if($(this).attr('id')==id)
		{
			$(this).addClass("select");
			$(this).find(".title").addClass("whitefont");
		}
		else
		{
			$(this).removeClass("select");
			$(this).find(".title").removeClass("whitefont");
		}
	 });
}