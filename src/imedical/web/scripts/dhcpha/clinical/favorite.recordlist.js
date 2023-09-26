??$(function(){
	
	if (isShare.toUpperCase() == "TRUE")
	{
		$('.easyui-layout').layout('remove','south');
	}
	else
	{
		$('#all').attr("checked",true);
		//就诊列表
		$("#episodeList").datagrid({ 
			    width:'100%',
			    height:'100px', 
			    loadMsg:'数据装载中......',
			    url:'../EMRservice.Ajax.hisData.cls?Action=GetEpisodeList&PatientID='+patientId,
			    singleSelect:false,
			    rownumbers:true,
			    pagination:true,
			    pageSize:20,	    
			    idField:'EpisodeID',
			    fit:true,
			    fitColumns:false,
			    columns:[[  
			        {field:'EpisodeDate',title:'就诊日期',width:150,align:'center'},
			        {field:'EpisodeTime',title:'就诊时间',width:150,align:'center'},
			        {field:'Diagnosis',title:'诊断',width:400,align:'center'}, 
			        {field:'EpisodeType',title:'类型',width:103,formatter:formatColor,align:'center'}, 
			        {field:'EpisodeDeptDesc',title:'科室',width:200,align:'center'},    
			        {field:'MainDocName',title:'主治医生',width:143,align:'center'}, 
			        {field:'DischargeDate',title:'出院日期',width:150,align:'center'},
			        {field:'EpisodeID',title:'就诊号',hidden:true}
			    ]],
			    onSelect:function(rowIndex,rowData){
				    getNoFavRecords(rowData);
			    }
		  });
	}
	//已经收藏的病历
	getRecords();
	$('input').find(':radio').change(function () {
		
		var queryItem = document.getElementById("diagnosDesc").value
		queryItem = (queryItem == "请输入诊断内容...")? "":queryItem;
		if (this.id == "all")
		{
			queryData(queryItem,"");
		}
		else
		{
			queryData(queryItem,this.id);
		}
	});	
	///按就诊内容查找
	$("#episodeSeek").click(function(){
		var queryItem = document.getElementById("diagnosDesc").value
		queryItem = (queryItem == "请输入诊断内容...")? "":queryItem;
		var episodeType = $("input[name='episode']:checked").attr("id");
		episodeType = (episodeType == "all")?"":episodeType;
		queryData(queryItem,episodeType);
		
	});	
});

//查询
function queryData(queryItem,episodeType)
{
	//记录用户(整理收藏.查看病历.全部就诊病历.类型)行为
	AddActionLog(userId,userLocId,"FavoritesView.RecordView.AllRecord."+episodeType,""); 				
	
	$("#episodeList").datagrid('load', {
		Action: "GetEpisodeList",
		PatientID: patientId,
		QueryItem: queryItem,
		EpisodeType: episodeType
	});		
}
// 取消收藏病历
function cancelFavRecrod(instanceId,episodeId,favInfoId)
{
	//记录用户(整理收藏.查看病历.取消病历收藏)行为
	AddActionLog(userId,userLocId,"FavoritesView.RecordView.Record.UnFavorite",""); 				

	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=CancelFavRecrod&FavInfoID="+favInfoId+"&EpisodeID="+episodeId+"&InstanceID="+instanceId, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data == "1") 
        	{
	        	var param = "#editEpisode #"+episodeId;
	        	var tmpArray = removeRecord("favoriteRecordList #"+episodeId,instanceId); 
	        	$(tmpArray).find(".tooldiv").remove();
	        	var tool = "<div class='tooldiv'><a href='javascript:void(0);' style='color:blue;' onclick='doFavorite("+'"'+ instanceId +'","'+episodeId+'","'+favInfoId +'"'+")'>添加收藏</a></div>";
	        	$(tmpArray).append(tool);
	        	if ($("#editEpisode #"+episodeId+" .box .apply_nav .apply_w").length>0)
	        	{
		        	$("#editEpisode #"+episodeId+" .box .apply_nav .apply_w").append(tmpArray);
		        }else
		        {
			        var apply = $('<div id="'+episodeId+'" class="apply"></div>');
			        $(apply).append($("#editEpisode .apply .titlelist"));
			        var box = $('<div class="box"></div>');
			        $(box).append('<div class="img_l" style="background:url(../scripts/dhcpha/emr/image/icon/arrowscq.png) 0px 0px no-repeat;" onclick="imgleft('+"'"+param+"'"+')"></div>');
			        $(box).append($('<div class="apply_nav"></div>').append($('<div class="apply_w"></div>').append(tmpArray)));
			        $(box).append('<div class="img_r" style="background:url(../scripts/dhcpha/emr/image/icon/arrowscq.png) -36px 0px no-repeat;" onclick="imgright('+"'"+param+"'"+')"></div>');
			        $(apply).append(box);
			        $("#editEpisode").append(apply);
			}
			bindClick("#editEpisode #"+episodeId);
	        }
	        else
	        {
		        alert("取消失败");
		    }
        } 
    });	  	 	
}

//对病历进行评论
function remarkingFav(instanceId,favInfoId,instanceName,episodeId,pluginType,chartItemType,emrDocId)
{
	//记录用户(整理收藏.查看病历.点评病历)行为
	AddActionLog(userId,userLocId,"FavoritesView.RecordView.Record.Comment",""); 				
	
	var content = '<iframe id="framremark'+instanceId+'" frameborder="0" src="dhcpha.clinical.favorite.remarking.csp?FavInfoID='+favInfoId+'&InstanceID='+instanceId+'&InstanceName='+instanceName+'&EpisodeID='+episodeId+'&UserID='+userId+'&UserLocID='+userLocId+'&pluginType='+pluginType+'&chartItemType='+chartItemType+'&emrDocId='+emrDocId+'" style="width:100%;height:100%;scrolling:no;"></iframe>'
	parent.addTab("tabFavorite","remark"+instanceId,"对 "+instanceName+" 评价",content,true);
	
}

//添加收藏
function doFavorite(instanceId,episodeId,favInfoId)
{
	//记录用户(整理收藏.查看病历.全部就诊病历.添加病历)行为
	AddActionLog(userId,userLocId,"FavoritesView.RecordView.AllRecord.AddRecord",""); 				
	
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=AddFavRecord&FavInfoID="+favInfoId+"&EpisodeID="+episodeId+"&InstanceID="+instanceId, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data == "1") 
        	{
	        	var param = "#favoriteRecordList #"+episodeId;
	        	var tmpArray = removeRecord("editEpisode",instanceId); 
	        	$(tmpArray).find(".tooldiv").remove();
	        	var title = $(tmpArray).find(".titlediv").text();
	        	var tool = "<div class='tooldiv'><a href='javascript:void(0);' style='color:blue;' onclick='cancelFavRecrod("+'"'+ instanceId +'","'+episodeId+'","'+favInfoId +'"'+")'>取消收藏</a>&nbsp;|&nbsp;";
				tool = tool + "<a href='javascript:void(0);' style='color:blue;' onclick='remarkingFav("+'"'+ instanceId +'","'+ favInfoId +'","'+title+'","'+episodeId+'"'+")'>病历评价</a></div>";
	        	$(tmpArray).append(tool);
	        	if ($("#favoriteRecordList #"+episodeId+" .box .apply_nav .apply_w").length>0)
	        	{
		        	$("#favoriteRecordList #"+episodeId+" .box .apply_nav .apply_w").append(tmpArray);
		        }
		        else
		        {
			        $("#favoriteRecordList").empty();
			        var apply = $('<div id="'+episodeId+'" class="apply"></div>');
			        $(apply).append($("#editEpisode .apply .titlelist"));
			        var box = $('<div class="box"></div>');
			        $(box).append('<div class="img_l" style="background:url(../scripts/dhcpha/emr/image/icon/arrowscq.png) 0px 0px no-repeat;" onclick="imgleft('+"'"+param+"'"+')"></div>');
			        var empty = $('<div class="empty"><div class="p"></div>没有？快点击列表<br />添加收藏</div>');
			        $(box).append($('<div class="apply_nav"></div>').append($('<div class="apply_w"></div>').append(empty).append(tmpArray)));
			        $(box).append('<div class="img_r" style="background:url(../scripts/dhcpha/emr/image/icon/arrowscq.png) -36px 0px no-repeat;" onclick="imgright('+"'"+param+"'"+')"></div>');
			        $(apply).append(box);
			        $("#favoriteRecordList").append(apply);
			}
			bindClick("#favoriteRecordList #"+episodeId);
	        }
	        else
	        {
		        alert("添加失败");
		    }

        } 
    });		
}

//从界面移除病历
function removeRecord(pageId,instanceId)
{
	var data = "";

	$("#"+pageId).find(".apply_array").each(function(){
		if($(this).find(".content").attr("id")==instanceId)
		{
			if ((pageId == "editEpisode")||(pageId.indexOf("favoriteRecordList")>=0))
			{
				data = $(this);
			}
			$(this).remove();
			return false; 
		}
	});

	return data;
}

//添加病历
function setRecord(episodeId,data)
{
	$("#favoriteRecordList #"+episodeId+" .apply_w").append(data);
}

//未收藏病历
function getNoFavRecords(admData)
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=GetNoFavRecords&FavInfoID="+favInfoId+"&EpisodeID="+admData.EpisodeID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	$("#editEpisode").empty();
        	var result = setRecords(eval(data),"NoFavoriteRecord",favInfoId,admData.EpisodeID,admData.EpisodeDate,admData.EpisodeType,admData.EpisodeDeptDesc);
        	$("#editEpisode").append(result);
        	bindClick("#editEpisode #"+admData.EpisodeID);
        } 
    });		
}

///我的收藏
function getRecords()
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=GetFavRecords&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	$("#favoriteRecordList").empty();
            var array = eval(data);
            for (var i=0;i<array.length;i++)
            {
	        	var result = setRecords(array[i].Records,"FavoriteRecord",favInfoId,array[i].EpioseID,array[i].EpisodeDateTime,array[i].EpisodeType,array[i].EpisodeLoc); 
	        	$("#favoriteRecordList").append(result);
	        	bindClick("#favoriteRecordList #"+array[i].EpioseID);
	        }
	        if(array.length == "")
	        {
		        var apply = $('<div class="apply"></div>');
		        $(apply).append('<div class="titlelist"><span></span><span></span><span></span></div>');
				var box = $('<div class="box"></div>');
				$(box).append('<div class="img_l" style="background:url(../scripts/dhcpha/emr/image/icon/arrowscq.png) 0px 0px no-repeat;"></div>');
				var applyw = $('<div class="apply_w"></div>');
				var empty = $('<div class="empty"><div class="p"></div>没有？快点击列表<br />添加收藏</div>');
	    		$(applyw).append(empty);
				var applynav = $('<div class="apply_nav"></div>').append(applyw);
				$(box).append(applynav);
				$(box).append('<div class="img_r" style="background:url(../scripts/dhcpha/emr/image/icon/arrowscq.png) -36px 0px no-repeat;"></div>');
				$(apply).append(box);
		        $("#favoriteRecordList").append(apply);    
		    }
        } 
    });	
}

///加载病例列表
function setRecords(data,type,favInfoId,episodeId,episodeDate,episodeType,episodeLoc)
{
	var apply = $('<div id="'+episodeId+'" class="apply"></div>');
	$(apply).append('<div class="titlelist"><span>'+episodeDate+'</span><span>'+episodeType+'</span><span>'+episodeLoc+'</span></div>');
	var box = $('<div class="box"></div>');
	var param = "";
	if(type =="NoFavoriteRecord")
	{
		param = "#editEpisode #"+episodeId;
	}else
	{
		param = "#favoriteRecordList #"+episodeId;
	}
	$(box).append('<div class="img_l" style="background:url(../scripts/dhcpha/emr/image/icon/arrowscq.png) 0px 0px no-repeat;" onclick="imgleft('+"'"+param+"'"+')"></div>');
	var applyw = $('<div class="apply_w"></div>');
	if (type == "FavoriteRecord")
    {
	    var empty = $('<div class="empty"><div class="p"></div>没有？快点击列表<br />添加收藏</div>');
	    $(applyw).append(empty);
	}
	for (var i=0;i<data.length;i++)
	{
		var array = $('<div class="apply_array"></div>');
		var link = $('<a class="content" href="javascript:void(0);"></a>');
		$(link).attr({"id":data[i].id,"isLeadframe":data[i].isLeadframe,"text":data[i].text});
		$(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});		
		$(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});
		$(link).attr({"templateId":data[i].templateId});
		var summary = data[i].summary;
		var status = "", content = "";
		if(data[i].status=="完成")
		{
			status = "待签";
		}
		if(status != "") content = "<div class='pic'>"+status+"</div>";
        content+= "<div class='info' style='overflow:hidden;height:140px;'>"+summary+"</div><div class='titlediv'>"+data[i].text+"</div><div class='datediv'>"+data[i].happendate+" "+data[i].happentime+"</div>";
        $(link).append(content);
        $(array).append(link);
        var tool = "<div class='tooldiv'>" ;
        if (type == "FavoriteRecord")
        {
	        if (isShare.toUpperCase() != "TRUE")
	        {
	        	tool = tool + "<a href='javascript:void(0);' onclick='cancelFavRecrod("+'"'+ data[i].id +'","'+episodeId+'","'+favInfoId +'"'+")'>取消收藏</a>&nbsp;|&nbsp;";
	        }
	        tool = tool + "<a href='javascript:void(0);' onclick='remarkingFav("+'"'+ data[i].id +'","'+ favInfoId +'","'+data[i].text+'","'+episodeId+'","'+data[i].documentType+'","'+data[i].chartItemType+'","'+data[i].emrDocId+'"'+")'>病历评价</a>";   
	    } 
	    else
	    {
		    tool = tool + "<a href='javascript:void(0);' onclick='doFavorite("+'"'+ data[i].id +'","'+episodeId+'","'+favInfoId+'"'+")'>添加收藏</a>"
		}
		tool = tool + "</div>"
		$(array).append(tool);
		$(applyw).append(array);
	}
	var applynav = $('<div class="apply_nav"></div>').append(applyw);
	$(box).append(applynav);
	$(box).append('<div class="img_r" style="background:url(../scripts/dhcpha/emr/image/icon/arrowscq.png) -36px 0px no-repeat;" onclick="imgright('+"'"+param+"'"+')"></div>');
	$(apply).append(box);
	return apply;  	
}	

//打开病历	

$(".apply .content").live('click',function(){

	var id=$(this).attr("id"); 
	var text=$(this).attr("text");
	var pluginType=$(this).attr("documentType");
	var chartItemType=$(this).attr("chartItemType");
	var emrDocId=$(this).attr("emrDocId");
	var templateId=$(this).attr("templateId");
	var isLeadframe=$(this).attr("isLeadframe");
	var isMutex=$(this).attr("isMutex");
	var categoryId=$(this).attr("categoryId");
	var actionType="LOAD";
	var status ="NORMAL";
	//var content = '<iframe id="framInstance'+id+'" frameborder="0" src="emr.record.browse.browsform.editor.csp?id='+id+'&pluginType='+pluginType+'&chartItemType='+chartItemType+'&emrDocId='+emrDocId+'" style="width:100%;height:100%;scrolling:no;"></iframe>'
	//parent.addTab("tabFavorite","Instance"+id,text,content,true);
	window.open("dhcpha.clinical.browse.editor.csp?id="+id+"&pluginType="+pluginType+"&chartItemType="+chartItemType+"&emrDocId="+emrDocId,"");

	//记录用户(整理收藏.查看病历.打开病历)行为
	AddActionLog(userId,userLocId,"FavoritesView.RecordView.Record.Open",text); 				

});

//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999';
	}
}
//设置颜色
function formatColor(val,row)
{
	if (row.EpisodeType == "住院")
	{
		return '<span style="color:green;">'+val+'</span>';
	}
	else if (row.EpisodeType == "门诊")
	{
		return '<span style="color:red;">'+val+'</span>';
	}
	else if (row.EpisodeType == "急诊")
	{
		return '<span style="color:blue;">'+val+'</span>';
	}	
}

//注册单击事件
function bindClick(navid)
{
	$li1 = $(navid+" .box .apply_nav .apply_w .apply_array");
	$window1 = $(navid+" .box .apply_nav .apply_w");

	$(navid+" .box .apply_nav .apply_w").css("width", ($(navid+" .apply_nav .apply_w .apply_array").length+3)*166);
}
//单击左移动画效果
function imgleft(navid)
{
	$(navid+" .box .apply_nav .apply_w").animate({left:'+=166px'}, 1000);
}
//单击右移动画效果
function imgright(navid)
{
	$(navid+" .box .apply_nav .apply_w").animate({left:'-=166px'}, 1000);
}

//页面关闭
window.onunload=function()
{
	//记录用户(整理收藏.查看病历.页面关闭)行为
    AddActionLog(userId,userLocId,"FavoritesView.RecordView.Page.Close",""); 			
}
