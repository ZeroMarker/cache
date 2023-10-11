$(function(){
	init();
	$("ul").on("click", ".addCollectImg", addCollect);
  	$("ul").on("click", ".removeCollectImg", removeConfirm);
});

//模板跨科检索
var searchAcrossDepartDocID = getSearchAcrossDepartDocID();
//显示全部还是常用模板的标识
var showType = "all";

//加载
function init()
{
	if(parent.setDisplay){
		parent.setDisplay("allBtn","oftenBtn");
	}
	showType = "all";
	$('.display').empty();
   	var flag = checkCategoryIdInLocId(gl.episodeId,gl.userLocId,gl.categoryId,gl.groupId);
	if (flag == 1) getTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",false);
    getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",false,"List",gl.sequence);
}
function filterOften() {
  showType = "part";
  if ($.inArray(gl.categoryId, searchAcrossDepartDocID) > -1) {
    //知情同意书
    $('.display').empty();
    getTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",false,"collect");
  } else {
    var $li = $(".display li").filter(function (index) {
      var isCollect = $($(".display li")[index]).attr("isCollect");
      return isCollect !== "1" || isCollect === undefined ? true : false;
    });
    $li.hide();
  }
}
//获取当前用户在全院搜索下的收藏的知情同意书
function getAllCollectTemplate(className, methodName, async) {
  jQuery.ajax({
    type: "get",
    dataType: "text",
    url: "../EMRservice.Ajax.common.cls",
    async: async,
    data: {
      OutputType: "Stream",
      Class: className,
      Method: methodName,
      p1: gl.categoryId,
      p2: gl.episodeId,
      p3: gl.userId,
      p4: "",
      p5: "",
      p6: "",
      p7: ""
    },
    success: function (d) {
      //隐藏所有当前所有的li
      $(".display li").hide();
      setTemplate(eval("[" + d + "]"));
    },
    error: function (d) {
      alert("getAllCollectTemplate error");
    }
  });
}
//获得模板
function getTemplate(className,methodName,async,collect)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":gl.categoryId,
			"p2":gl.episodeId,
			"p3":gl.userId,
			"p4":"",
			"p5":"",
			"p6":"",
			"p7":"",
			"p8":gl.docID,
			"p9":collect||""
		},
		success: function(d) {
			setTemplate(eval("["+d+"]"));
		},
		error : function(d) { 
			alert("getTemplate error");
		}
	});
}
//加载模板
function setTemplate(data)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onmouseover="temp.show(this)" onmouseout="temp.hide(this)" style="background:url(../scripts/emr/image/record-card-png/png/5.png);background-size:100%"></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].attributes.isLeadframe});
		$(link).attr({"chartItemType":data[i].attributes.chartItemType,"documentType":data[i].attributes.documentType});
		$(link).attr({"isMutex":data[i].attributes.isMutex,"categoryId":gl.categoryId});
		$(link).attr({"templateId":data[i].attributes.templateId});
		$(link).attr({"isCollect":data[i].isCollect});
		
		var div = $('<div class="template" style="position:relative;padding:14px 3px 0px 3.5px"></div>');
		var hasTemplate = GetHasUserTemplate(data[i].id);
		var cardTitleText = "通用模板";
		var cardTitle = "使用通用模板创建病历";
		if(hasTemplate)
		{
			cardTitleText = "科室模板";
			cardTitle = "选择模板创建";	
		}
		
 		if (data[i].attributes.quotation == "1")
		{
			$(div).append('<div class="cardImage" style="width:128;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"><div class="new" ><div class="title"><div class="doctitle" title=' +data[i].attributes.DocIDText+ '>' +data[i].attributes.DocIDTitle+ '</div><div class="creatediv" style="margin-top:10px"><a href="#" title=' +emrTrans(cardTitle) +'>'+emrTrans(cardTitleText) +'</a></div><a href="#" title=' +emrTrans("使用通用模板创建病历") +'><div class="addimage" style="width:16px;height:16px;right:18px; bottom:23px; position: absolute;background:url(../scripts/emr/image/record-card-png/png/add.png) no-repeat;"></div></a></div></div></div>');
			$(div).append('<a href="#" title=' +emrTrans("引用") +'><div class="quote" style="background:url(../scripts/emr/image/record-card-png/png/12.png) no-repeat;"></div></a>');
		}
		else
		{
			$(div).append('<div class="cardImage" style="width:128;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"><div class="title"><div class="doctitle" title=' +data[i].attributes.DocIDText+ '>' +data[i].attributes.DocIDTitle+ '</div><div class="creatediv" style="margin-top:10px"><a href="#" title=' +emrTrans(cardTitle) +'>'+emrTrans(cardTitleText) +'</a></div><a href="#" title=' +emrTrans("使用通用模板创建病历") +'><div class="addimage" style="width:16px;height:16px;right:18px; bottom:23px; position: absolute;background:url(../scripts/emr/image/record-card-png/png/add.png) no-repeat;"></div></a></div></div>');
		} 
		var collect="none",removeCollect="none";
		if(data[i].isCollect==="1"){
			collect = "none";
			removeCollect="block";
			}else{
			collect = "block";
			removeCollect="none";
				}
		$(div).append('<img class="removeCollectImg" alt="移除常用模板"  title="'+emrTrans("移除常用模板")+'" style="cursor:pointer; width: 16px; left: 10px; bottom: 23px; position: absolute;display:'+removeCollect+';" src="../scripts/emr/image/record-card-png/png/18.png">');
		$(div).append('<img class="addCollectImg" alt="添加常用模板"  title="'+emrTrans("添加常用模板")+'" style="cursor:pointer; width: 16px; left: 10px; bottom: 23px; position: absolute;display:'+collect+';" src="../scripts/emr/image/record-card-png/png/11.png">');
		$(div).append('<div class="janespell" style="display:none;">' +data[i].attributes.JaneSpell+ '</div>');
		$(div).append('<div class="fullfight" style="display:none;">' +data[i].attributes.FullFight+ '</div>');
		$(link).append(div);
		var imagediv = $('<div align="center" src="../scripts/emr/image/record-card-png/png/5.png" style="float:right;"></div>');
		$('.display').append(link);
	}
}
function addCollect(){
	var collectImg = $(this);
	var removeImg = collectImg.prev(".removeCollectImg"); 
	var liDom = collectImg.closest("li");
	var docID = liDom.attr("id"); 
	$.ajax({
		url:"../EMRservice.Ajax.CollectTemplate.cls?Action=AddCollect",
		type:"POST",
		data:{
			userID:gl.userId,
	  		Id: docID
		},
		success:function(result){
			if(+result===-1){
				$.messager.alert("提示","添加失败","info");
			}else{
				//设置已经收藏属性
				liDom.attr("isCollect","1");
				collectImg.css("display","none");
				//显示移除收藏图标
				removeImg.css("display","block");
				}
			},
		error:function(error){
			$.messager.alert("错误","添加失败","error");
			}
		});
}
function removeConfirm(){
	var removeImg = $(this);
	var collectImg = removeImg.next(".addCollectImg"); 
	var liDom = removeImg.closest("li");
	var docID = liDom.attr("id"); 
	var userID = gl.userId;
	var templateTitle = liDom.find("div .title").first().text();
	var text = "确定移除常用模板【"+templateTitle+"】?";
	$.messager.confirm("删除",text, function (r) {
		if (r) {
			removeCollect({removeImg:removeImg,collectImg:collectImg,docID:docID,showType:showType,userID:userID,liDom:liDom});
		} 
	});
}
function removeCollect(obj){
	var removeImg = obj.removeImg;
	var collectImg = obj.collectImg; 
	var docID = obj.docID; 
	var userID = obj.userID;
	var showType = obj.showType;
	var liDom = obj.liDom;
	$.ajax({
		url:"../EMRservice.Ajax.CollectTemplate.cls?Action=removeCollect",
		type:"POST",
		data:{
			userID:userID,
	  		Id: docID
		},
		success:function(result){
			if(+result===-1||result===""){
				$.messager.alert("提示","移除失败","info");
			}else{
				liDom.attr("isCollect","0");
				//显示收藏图标
				collectImg.css("display","block");
				removeImg.css("display","none");
				if(showType==="part"){ 
					liDom.css("display","none");
					}
				}
			},
		error:function(error){
			$.messager.alert("错误","移除失败","error");
			}
		});
}
//加载实例
function getRecord(className,methodName,async,resultType,sequence)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":gl.categoryId,
			"p2":gl.episodeId,
			"p3":resultType,
			"p4":sequence,
			"p5":gl.docID
		},
		success: function(d) {
			setRecord(eval("["+d+"]"),gl.categoryId);
		},
		error : function(d) { 
			alert("getRecord error");
		}
	});	
}
//加载文档
function setRecord(data,categoryId)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onmouseover="record.show(this)" onmouseout="record.hide(this)" style="background:url(../scripts/emr/image/record-card-png/png/34.png);background-size:100%"></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});		
		$(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":categoryId});
		$(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic});
		$(link).attr({"pdfDocType":data[i].pdfDocType});
		
		var div = $('<div class="instance" style="padding:14px 3px 0px 3.5px"></div>');
		var contentclass = "class = 'content'";
		var imagecontentclass = "class='recordimage' style='width:128px;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat'"
		if ((data[i].doctorwait != "")&&(data[i].patientwait != ""))
		{
			var ret = getContentClass(data[i].doctorwait,data[i].doctorIsSignCA,data[i].patSignStatus);
			contentclass = ret.contentclass;
			if ((ret.doctorStyle!="")&&(ret.patStyle!=""))
			{
				$(div).append('<div '+ imagecontentclass +'><a href="#"><div ' +contentclass+ '><div ' +ret.patStyle+ '></div><div ' +ret.doctorStyle+ '></div><div class="memoConcent">' +data[i].summary+ '</div></div></a></div>');
			}
			else if((ret.doctorStyle!="")&&(ret.patStyle==""))
			{
				$(div).append('<div '+ imagecontentclass +'><a href="#"><div ' +contentclass+ '><div ' +ret.doctorStyle+ '></div><div class="memoConcent">' +data[i].summary+ '</div></div></a></div>');
			}
			else if((ret.doctorStyle=="")&&(ret.patStyle!=""))
			{
				$(div).append('<div '+ imagecontentclass +'><a href="#"><div ' +contentclass+ '><div ' +ret.patStyle+ '></div><div class="memoConcent">' +data[i].summary+ '</div></div></a></div>');
			}
			else if((ret.doctorStyle=="")&&(ret.patStyle==""))
			{
				$(div).append('<div '+ imagecontentclass +'><a href="#"><div ' +contentclass+ '><div class="memoConcent">' +data[i].summary+ '</div></div></a></div>');
			}
		}
		else
		{
			$(div).append('<div '+ imagecontentclass +'><a href="#"><div ' +contentclass+ '><div class="memoConcent">' +data[i].summary+ '</div></div></a></div>');
		}
		//$(div).append('<a class="addMemo" title="单击修改备注" style="width:16px;height:16px;"><div style="float:right;margin:-51px 13px 0px 0px;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/gray_edit.png) no-repeat"></div></a>');
		var tag = $('<div class="tag" onmouseover="tip.show(this)" onmouseout="tip.hide()"></div>');
		$(tag).append('<div title="'+data[i].text+ '" class="title">' +data[i].text+ '</div>');
		$(tag).append('<a class="addMemo" title="'+emrTrans("单击修改备注")+'">'+emrTrans("注")+'</a>')
		$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+'</div>');
		$(tag).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(tag).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		$('.display').append($(link).append($(div).append(tag)));
	}
}
///编辑备注///////////////////////////////////////////////////////////////////////////////////////////////////////////
var instanceId = "";
$(function(){
	//编辑备注
	$('#memo').css("display","block");
	$('#memo').window('close');
	//保存备注信息
	$('#memoSure').click(function(){
		var memoText = $('#memoText').val();
		if (memoText.length > 1000)
		{
			alert("备注内容超出1000字数限制");
		}else{
			save(instanceId,memoText);
		}
	});

	//取消或关闭编辑备注
	$("#memoCancel").click(function(){
		$('#memo').window('close');
	});
});

//保存备注信息
function save(id,memoText){
	$.ajax({
		type: "post",
		url: "../EMRservice.Ajax.common.cls",
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLInstanceData",
			"Method":"SetDocumentMemo",
			"p1":id,
			"p2":stringTJson(memoText)
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			alert(textStatus);
		},
		success: function (data) {
			if (data == "1")
			{
				$('#memo').window('close');
				$('li[id="'+instanceId+'"] div.memoConcent').html(memoText);
				$('li[id="'+instanceId+'"] span.description').html(memoText);
			}
			else
			{
				alert("备注修改失败!");
			}
		}
	});
}

 $(document).on("click",".instance .addMemo",function(){
	var obj = $(this).closest("li");
	instanceId = obj.attr("id");
	var memo = $(this).parent().prev().children().children().children().next().html();
	$('#memo').window('open');
	//$('#memoText').html(memo);
	$('#memoText').val("");
    $('#memoText').val(memo);
}); 

///新建病历/////////////////////////////////////////////////////////////////////////////////////////////////////////
//用基础模板新建
$(document).on("click",".template .title .addimage",function(){
    var obj = $(this).closest("li");
    var tabParam ={
		"id":"",
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("id"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"actionType":"CREATE",
		"status":"NORMAL",
		"closable":true
	 };
	 
	operateRecord(tabParam);
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");

});

//选择模板新建
$(document).on("click",".template .title .creatediv",function(){
    var obj = $(this).closest("li");
    var tabParam ={
		"id":"",
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("id"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"actionType":"CREATE",
		"status":"NORMAL",
		"closable":true
	 };
	 
	tabParam = getParamByUserTemplate(tabParam);

});

//从既往病历新建
$(document).on("click",".template .quote",function(){
	var obj = $(this).closest("li");
	var docId = obj.attr("id")
	//showQuotationDialog("病历引用","<iframe id='iframeQuotation' scrolling='auto' frameborder='0' src='emr.ip.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+docId+"' style='width:100%; height:100%; display:block;overflow:hidden'></iframe>","quotationCardCallBack()");
	var iframeContent = "<iframe id='iframeQuotation' scrolling='auto' frameborder='0' src='emr.ip.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+docId+"' style='width:100%; height:100%; display:block;overflow:hidden'></iframe>"
	parent.createModalDialog("quotationDialog","病历引用",window.screen.width-300,window.screen.height-300,"iframeQuotation",iframeContent,quotationCardCallBack,obj,true,false)
});



function quotationCardCallBack(returnValue,obj)
{
    if ((!returnValue)||(returnValue == "")) return;
    var tabParam ={
		"id":"",
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("id"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"actionType":"QUOTATION",
		"status":"NORMAL",
		"closable":true,
		"pInstanceId":returnValue
	 };
	 operateRecord(tabParam);
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.CreateInOld");
}



///打开病历///////////////////////////////////////////////////////////////////////////////////////////////////////////
//点击病历打开
$(document).on("click",".instance .content",function(){
	var obj = $(this).closest("li");
    var tabParam ={
		"id":obj.attr("id"),
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("emrDocId"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"characteristic":obj.attr("characteristic"),
		"pdfDocType":obj.attr("pdfDocType"),
		"actionType":"LOAD",
		"status":"NORMAL",
		"closable":true
	};
	parent.parent.changeCurrentTitle(tabParam.text,tabParam.categoryId);
	operateRecord(tabParam)
	//自动记录病例操作日志
	openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
});


///查询卡片///////////////////////////////////////////////////////////////
function searchSelect(value)
{
	var categoryId = gl.categoryId;
	if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
		value = value.toUpperCase();
	}
	//是否支持跨科检索模板
	if ($.inArray(categoryId,searchAcrossDepartDocID)>-1)
	{
		if (value != "")
		{
			$('.display').empty();
			searchTemplate("EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,categoryId,episodeID,false);
			getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",false,"List",gl.sequence);
			$(".display li .instance").parent().hide();
			var $instance = $(".display li .instance .tag").filter(":contains('"+$.trim(value)+"')");
			$instance.parent().parent().show();
		}
		else
		{
			init();
		}
	}
	else
	{
		$(".display li").hide();
		var $instance = $(".display li .instance .tag").filter(":contains('"+$.trim(value)+"')");
		$instance.parent().parent().show();
		var $template = $(".display li .template").filter(":contains('"+$.trim(value)+"')");
		$template.parent().show();
	}	
}

//搜索知情同意书模板
function searchTemplate(className,methodName,searchValue,parentID,episodeID,async)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":searchValue,
			"p2":parentID,
			"p3":episodeID,
			"p4":userID
		},
		success: function(d) {
			setSearchTemplate(eval("["+d+"]"),parentID);
		},
		error : function(d) { 
			alert("searchTemplate error");
		}
	});
}

//加载知情同意书搜索后模板
function setSearchTemplate(data,categoryId)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onmouseover="temp.show(this)" onmouseout="temp.hide(this)" style="background:url(../scripts/emr/image/record-card-png/png/5.png);background-size:100%"></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].attributes.isLeadframe});
		$(link).attr({"chartItemType":data[i].attributes.chartItemType,"documentType":data[i].attributes.documentType});
		$(link).attr({"isMutex":data[i].attributes.isMutex,"categoryId":categoryId});
		$(link).attr({"templateId":data[i].attributes.templateId});
		$(link).attr({"isCollect":data[i].attributes.isCollect});
		
		var div = $('<div class="template" style="position:relative;padding:14px 3px 0px 3.5px"></div>');
		var hasTemplate = GetHasUserTemplate(data[i].id);
		var cardTitleText = "通用模板";
		var cardTitle = "使用通用模板创建病历";
		if(hasTemplate)
		{
			cardTitleText = "科室模板";
			cardTitle = "选择模板创建";	
		}
		if(data[i].attributes.disCurDocGropName != "")
		{
			if (data[i].attributes.quotation == "1")
			{
				$(div).append('<div class="cardImage" style="width:128;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"><div class="new" ><div class="title">' +data[i].attributes.DocIDText+ '<div class="creatediv" style="margin-top:10px"><a href="#" title=' +emrTrans(cardTitle) +'>'+emrTrans(cardTitleText) +'</a></div><a href="#" title=' +emrTrans("使用通用模板创建病历") +'><div class="addimage" style="width:16px;height:16px;right:18px; bottom:23px; position: absolute;background:url(../scripts/emr/image/record-card-png/png/add.png) no-repeat;"></div></a></div></div></div>');
				$(div).append('<a href="#" title=' +emrTrans("引用") +'><div class="quote" style="background:url(../scripts/emr/image/record-card-png/png/12.png) no-repeat;"></div></a>');
				
			}
			else
			{
				$(div).append('<div class="cardImage" style="width:128;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"><div class="title">' +data[i].attributes.DocIDText+ '<div class="creatediv" style="margin-top:10px"><a href="#" title=' +emrTrans(cardTitle) +'>'+emrTrans(cardTitleText) +'</a></div><a href="#" title=' +emrTrans("使用通用模板创建病历") +'><div class="addimage" style="width:16px;height:16px;right:18px; bottom:23px; position: absolute;background:url(../scripts/emr/image/record-card-png/png/add.png) no-repeat;"></div></a></div></div>');

			}
			$(div).append('<a id="search" class="groupName" href="#" class="easyui-tooltip" title='+data[i].attributes.disCurDocGropName+ '>' +data[i].attributes.disCurDocGropName+ '</a>');
		}
		else
		{
			if (data[i].attributes.quotation == "1")
			{
				$(div).append('<div class="cardImage" style="width:128;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"><div class="new" ><div class="title">' +data[i].attributes.DocIDText+ '<div class="creatediv" style="margin-top:10px"><a href="#" title=' +emrTrans(cardTitle) +'>'+emrTrans(cardTitleText) +'</a></div><a href="#" title=' +emrTrans("使用通用模板创建病历") +'><div class="addimage" style="width:16px;height:16px;right:18px; bottom:23px; position: absolute;background:url(../scripts/emr/image/record-card-png/png/add.png) no-repeat;"></div></a></div></div></div>');
				$(div).append('<a href="#" title=' +emrTrans("引用") +'><div class="quote" style="background:url(../scripts/emr/image/record-card-png/png/12.png) no-repeat;"></div></a>');				
			}
			else
			{
				$(div).append('<div class="cardImage" style="width:128;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"><div class="title">' +data[i].attributes.DocIDText+ '<div class="creatediv" style="margin-top:10px"><a href="#" title=' +emrTrans(cardTitle) +'>'+emrTrans(cardTitleText) +'</a></div><a href="#" title=' +emrTrans("使用通用模板创建病历") +'><div class="addimage" style="width:16px;height:16px;right:18px; bottom:23px; position: absolute;background:url(../scripts/emr/image/record-card-png/png/add.png) no-repeat;"></div></a></div></div>');			
			}
		}
		var collect="none",removeCollect="none";
		if(data[i].attributes.isCollect==="1"){
			collect = "none";
			removeCollect="block";
			}else{
			collect = "block";
			removeCollect="none";
				}
				
		$(div).append('<img class="removeCollectImg" alt="移除收藏"  title="'+emrTrans("移除收藏")+'" style="cursor:pointer; width: 16px; left: 10px; bottom: 23px; position: absolute;display:'+removeCollect+';" src="../scripts/emr/image/record-card-png/png/18.png">');
		$(div).append('<img class="addCollectImg" alt="添加收藏"  title="'+emrTrans("添加收藏")+'" style="cursor:pointer; width: 16px; left: 10px; bottom: 23px; position: absolute;display:'+collect+';" src="../scripts/emr/image/record-card-png/png/11.png">');
		$(div).append('<div class="janespell" style="display:none;">' +data[i].attributes.JaneSpell+ '</div>');
		$(div).append('<div class="fullfight" style="display:none;">' +data[i].attributes.FullFight+ '</div>');
		$(link).append(div);
		$('.display').append(link);	
	}
}

function getContentClass(doctorwait,doctorIsSignCA,patSignStatus)
{
	var ret = {};
	ret.contentclass = "class = 'content'";
	ret.doctorStyle = "";
	ret.patStyle = "";
	if (doctorwait == "1")
	{
		var tmpClass = "";
		var tmpTitle = "需要医生签名";
		ret.doctorStyle = "style='margin:8px 7px 0px 0px;float:right;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/30.png) no-repeat'";
		ret.patStyle = "";
		if ((patSignStatus.indexOf("待签") != -1)&&(isPatCAOn == "1"))
		{
			tmpClass = " patientwait";
			tmpTitle = "需要医生和患者签名";
			ret.doctorStyle = "style='margin:8px 7px 0px 0px;float:right;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/30.png) no-repeat'";
			ret.patStyle = "style='margin:8px 0px 0px 7px;float:left;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/33.png) no-repeat'"
		}
		else if((patSignStatus.indexOf("已签") != -1)&&(isPatCAOn == "1"))
		{
			tmpClass = " patCA";
			tmpTitle = "需要医生签名，患者已签名";
			ret.doctorStyle = "style='margin:8px 7px 0px 0px;float:right;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/38.png) no-repeat'";
		}
		ret.contentclass = "class = 'content doctorwait"+ tmpClass +"' title="+emrTrans(tmpTitle);
	}
	else if(doctorIsSignCA == "1")
	{
		var tmpClass = "";
		var tmpTitle = "医生已CA签名";
		if ((patSignStatus.indexOf("待签") != -1)&&(isPatCAOn == "1"))
		{
			tmpClass = " patientwait";
			tmpTitle = "需要患者签名，医生已CA签名";
			ret.patStyle = "style='margin:8px 0px 0px 7px;float:left;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/33.png) no-repeat'"			
		}
		else if((patSignStatus.indexOf("已签") != -1)&&(isPatCAOn == "1"))
		{
			tmpClass = " patCA";
			tmpTitle = "医生和患者均已CA签名";
		}
		ret.contentclass = "class = 'content docCA"+ tmpClass +"' title="+emrTrans(tmpTitle);
	}
	else if((patSignStatus.indexOf("待签") != -1)&&(isPatCAOn == "1"))
	{
		ret.contentclass = "class = 'content patientwait' title="+emrTrans("需要患者签名");
		ret.patStyle = "style='margin:8px 0px 0px 7px;float:left;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/33.png) no-repeat'";
	}
	else if((patSignStatus.indexOf("已签") != -1)&&(isPatCAOn == "1"))
	{
		ret.contentclass = "class = 'content patCA' title="+emrTrans("患者已CA签名");
	}
	
	return ret;
}


