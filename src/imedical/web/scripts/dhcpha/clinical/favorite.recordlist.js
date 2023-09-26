??$(function(){
	
	if (isShare.toUpperCase() == "TRUE")
	{
		$('.easyui-layout').layout('remove','south');
	}
	else
	{
		$('#all').attr("checked",true);
		//�����б�
		$("#episodeList").datagrid({ 
			    width:'100%',
			    height:'100px', 
			    loadMsg:'����װ����......',
			    url:'../EMRservice.Ajax.hisData.cls?Action=GetEpisodeList&PatientID='+patientId,
			    singleSelect:false,
			    rownumbers:true,
			    pagination:true,
			    pageSize:20,	    
			    idField:'EpisodeID',
			    fit:true,
			    fitColumns:false,
			    columns:[[  
			        {field:'EpisodeDate',title:'��������',width:150,align:'center'},
			        {field:'EpisodeTime',title:'����ʱ��',width:150,align:'center'},
			        {field:'Diagnosis',title:'���',width:400,align:'center'}, 
			        {field:'EpisodeType',title:'����',width:103,formatter:formatColor,align:'center'}, 
			        {field:'EpisodeDeptDesc',title:'����',width:200,align:'center'},    
			        {field:'MainDocName',title:'����ҽ��',width:143,align:'center'}, 
			        {field:'DischargeDate',title:'��Ժ����',width:150,align:'center'},
			        {field:'EpisodeID',title:'�����',hidden:true}
			    ]],
			    onSelect:function(rowIndex,rowData){
				    getNoFavRecords(rowData);
			    }
		  });
	}
	//�Ѿ��ղصĲ���
	getRecords();
	$('input').find(':radio').change(function () {
		
		var queryItem = document.getElementById("diagnosDesc").value
		queryItem = (queryItem == "�������������...")? "":queryItem;
		if (this.id == "all")
		{
			queryData(queryItem,"");
		}
		else
		{
			queryData(queryItem,this.id);
		}
	});	
	///���������ݲ���
	$("#episodeSeek").click(function(){
		var queryItem = document.getElementById("diagnosDesc").value
		queryItem = (queryItem == "�������������...")? "":queryItem;
		var episodeType = $("input[name='episode']:checked").attr("id");
		episodeType = (episodeType == "all")?"":episodeType;
		queryData(queryItem,episodeType);
		
	});	
});

//��ѯ
function queryData(queryItem,episodeType)
{
	//��¼�û�(�����ղ�.�鿴����.ȫ�����ﲡ��.����)��Ϊ
	AddActionLog(userId,userLocId,"FavoritesView.RecordView.AllRecord."+episodeType,""); 				
	
	$("#episodeList").datagrid('load', {
		Action: "GetEpisodeList",
		PatientID: patientId,
		QueryItem: queryItem,
		EpisodeType: episodeType
	});		
}
// ȡ���ղز���
function cancelFavRecrod(instanceId,episodeId,favInfoId)
{
	//��¼�û�(�����ղ�.�鿴����.ȡ�������ղ�)��Ϊ
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
	        	var tool = "<div class='tooldiv'><a href='javascript:void(0);' style='color:blue;' onclick='doFavorite("+'"'+ instanceId +'","'+episodeId+'","'+favInfoId +'"'+")'>����ղ�</a></div>";
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
		        alert("ȡ��ʧ��");
		    }
        } 
    });	  	 	
}

//�Բ�����������
function remarkingFav(instanceId,favInfoId,instanceName,episodeId,pluginType,chartItemType,emrDocId)
{
	//��¼�û�(�����ղ�.�鿴����.��������)��Ϊ
	AddActionLog(userId,userLocId,"FavoritesView.RecordView.Record.Comment",""); 				
	
	var content = '<iframe id="framremark'+instanceId+'" frameborder="0" src="dhcpha.clinical.favorite.remarking.csp?FavInfoID='+favInfoId+'&InstanceID='+instanceId+'&InstanceName='+instanceName+'&EpisodeID='+episodeId+'&UserID='+userId+'&UserLocID='+userLocId+'&pluginType='+pluginType+'&chartItemType='+chartItemType+'&emrDocId='+emrDocId+'" style="width:100%;height:100%;scrolling:no;"></iframe>'
	parent.addTab("tabFavorite","remark"+instanceId,"�� "+instanceName+" ����",content,true);
	
}

//����ղ�
function doFavorite(instanceId,episodeId,favInfoId)
{
	//��¼�û�(�����ղ�.�鿴����.ȫ�����ﲡ��.��Ӳ���)��Ϊ
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
	        	var tool = "<div class='tooldiv'><a href='javascript:void(0);' style='color:blue;' onclick='cancelFavRecrod("+'"'+ instanceId +'","'+episodeId+'","'+favInfoId +'"'+")'>ȡ���ղ�</a>&nbsp;|&nbsp;";
				tool = tool + "<a href='javascript:void(0);' style='color:blue;' onclick='remarkingFav("+'"'+ instanceId +'","'+ favInfoId +'","'+title+'","'+episodeId+'"'+")'>��������</a></div>";
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
			        var empty = $('<div class="empty"><div class="p"></div>û�У������б�<br />����ղ�</div>');
			        $(box).append($('<div class="apply_nav"></div>').append($('<div class="apply_w"></div>').append(empty).append(tmpArray)));
			        $(box).append('<div class="img_r" style="background:url(../scripts/dhcpha/emr/image/icon/arrowscq.png) -36px 0px no-repeat;" onclick="imgright('+"'"+param+"'"+')"></div>');
			        $(apply).append(box);
			        $("#favoriteRecordList").append(apply);
			}
			bindClick("#favoriteRecordList #"+episodeId);
	        }
	        else
	        {
		        alert("���ʧ��");
		    }

        } 
    });		
}

//�ӽ����Ƴ�����
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

//��Ӳ���
function setRecord(episodeId,data)
{
	$("#favoriteRecordList #"+episodeId+" .apply_w").append(data);
}

//δ�ղز���
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

///�ҵ��ղ�
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
				var empty = $('<div class="empty"><div class="p"></div>û�У������б�<br />����ղ�</div>');
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

///���ز����б�
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
	    var empty = $('<div class="empty"><div class="p"></div>û�У������б�<br />����ղ�</div>');
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
		if(data[i].status=="���")
		{
			status = "��ǩ";
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
	        	tool = tool + "<a href='javascript:void(0);' onclick='cancelFavRecrod("+'"'+ data[i].id +'","'+episodeId+'","'+favInfoId +'"'+")'>ȡ���ղ�</a>&nbsp;|&nbsp;";
	        }
	        tool = tool + "<a href='javascript:void(0);' onclick='remarkingFav("+'"'+ data[i].id +'","'+ favInfoId +'","'+data[i].text+'","'+episodeId+'","'+data[i].documentType+'","'+data[i].chartItemType+'","'+data[i].emrDocId+'"'+")'>��������</a>";   
	    } 
	    else
	    {
		    tool = tool + "<a href='javascript:void(0);' onclick='doFavorite("+'"'+ data[i].id +'","'+episodeId+'","'+favInfoId+'"'+")'>����ղ�</a>"
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

//�򿪲���	

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

	//��¼�û�(�����ղ�.�鿴����.�򿪲���)��Ϊ
	AddActionLog(userId,userLocId,"FavoritesView.RecordView.Record.Open",text); 				

});

//����ؼ��¼�
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//�뿪�ؼ��¼�
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999';
	}
}
//������ɫ
function formatColor(val,row)
{
	if (row.EpisodeType == "סԺ")
	{
		return '<span style="color:green;">'+val+'</span>';
	}
	else if (row.EpisodeType == "����")
	{
		return '<span style="color:red;">'+val+'</span>';
	}
	else if (row.EpisodeType == "����")
	{
		return '<span style="color:blue;">'+val+'</span>';
	}	
}

//ע�ᵥ���¼�
function bindClick(navid)
{
	$li1 = $(navid+" .box .apply_nav .apply_w .apply_array");
	$window1 = $(navid+" .box .apply_nav .apply_w");

	$(navid+" .box .apply_nav .apply_w").css("width", ($(navid+" .apply_nav .apply_w .apply_array").length+3)*166);
}
//�������ƶ���Ч��
function imgleft(navid)
{
	$(navid+" .box .apply_nav .apply_w").animate({left:'+=166px'}, 1000);
}
//�������ƶ���Ч��
function imgright(navid)
{
	$(navid+" .box .apply_nav .apply_w").animate({left:'-=166px'}, 1000);
}

//ҳ��ر�
window.onunload=function()
{
	//��¼�û�(�����ղ�.�鿴����.ҳ��ر�)��Ϊ
    AddActionLog(userId,userLocId,"FavoritesView.RecordView.Page.Close",""); 			
}
