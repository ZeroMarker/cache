var url='dhcpha.clinical.action.csp';
var tempParam="";
var length="";
var FavEpisodeID=episodeID; //收藏时的就诊号
var flag="";flagRightLeft="";tabSelectName="";tabUrl="";

$(function(){
	getPatinentInfo(); //患者信息
	setViewForm(); //加载tabs头菜单
	getListRecord(episodeID);//初始化药历目录
	CollectTalk(); //收藏、评价
	tabSelect(); //切换tabs菜单效果
	patientList(); //病人就诊记录列表
	buttonRightOrLeft(); //窗口宽度变化
});

//病人就诊记录列表
function patientList(){
	//就诊类型
	$('#episodeType').combobox({  
		valueField:'id',  
		textField:'text',
		panelHeight:100,
		width:60,
		data:[
				{"id":"","text":$g("全部"),"selected":true},
				{"id":"O","text":$g("门诊")},
				{"id":"E","text":$g("急诊")},
				{"id":"I","text":$g("住院")}
			 ]
	}); 	
	//就诊列表
	$("#episodeList").datagrid({ 
	    width:'100%',
	    height:'100%', 
	    loadMsg:$g('数据装载中......'),
	    url:'../EMRservice.Ajax.hisData.cls?Action=GetEpisodeList&PatientID='+patientID,
	    //url:url+'?action=GetAllEpisode',
	    singleSelect:false,
	    rownumbers:true,
	    pagination:true,
	    pageSize:20,	    
	    idField:'EpisodeID',
	    fit:true,
	    columns:[[  
	    	{field:'ck',checkbox:true},
	        {field:'EpisodeDate',title:$g('就诊日期'),width:80},
	        {field:'Diagnosis',title:$g('诊断'),width:100}, 
	        {field:'EpisodeType',title:$g('类型'),width:60,formatter:formatColor}, 
	        {field:'EpisodeDeptDesc',title:$g('科室'),width:100},     
	        {field:'MainDocName',title:$g('主治医生'),width:80}, 
	        {field:'DischargeDate',title:$g('出院日期'),width:60},
	        {field:'EpisodeID',title:$g('就诊号'),width:40},
	        {field:'EpisodeDeptID',title:$g('科室ID'),width:40}
	    ]],
	    onClickRow:function(rowIndex,rowData){
		   $("#episodeList").datagrid('unselectAll');
		   $("#episodeList").datagrid('selectRow',rowIndex);
		   $("#BrowseCategory").html("");
		   tempParam="";
		   if(flag==0){
		   	   getListRecord(rowData.EpisodeID); //点击切换就诊
		   	   episodeID=rowData.EpisodeID;
		   	   mradm=rowData.EpisodeID;
		   }
		   else if(flag==1){
		       getListRecords(rowData.EpisodeID);
		       episodeID=rowData.EpisodeID;
		       mradm=rowData.EpisodeID;
		   }
		   else{
			   episodeID=rowData.EpisodeID;
			   mradm=rowData.EpisodeID;
			   selectTabsUrlTo();//点击tabs链接页面变化情况
		   }
		   FavEpisodeID=rowData.EpisodeID; //收藏时的就诊号
	    }
	    //queryParams:{
		    //PatientID:patientID
	    //}
 	});	
 	//查询
	$("#episodeSeek").click(function(){
		queryData();
	});
	
	var pager = $('#episodeList').datagrid('getPager'); 
	pager.pagination({
		showPageList:false
	});
	//申请权限
	$("#authorizesrequest").click(function(){
		var SelectedRow = $("#episodeList").datagrid('getSelected');
		if (SelectedRow == null)
		{
			alert("请选择一条就诊记录，再申请权限！")
			return;
		}
		else
		{
			var returnValues = window.open("emr.authorizes.request.csp?EpisodeID="+SelectedRow.EpisodeID+"&PatientID="+patientID,"requestWin","resizable:no;status:no,width=600,height=470");
		}
		
	});
	
	function formatColor(val,row)
	{
		if (row.EpisodeType == $g("住院"))
		{
			return '<span style="color:green;">'+val+'</span>';
		}
		else if (row.EpisodeType == $g("门诊"))
		{
			return '<span style="color:red;">'+val+'</span>';
		}
		else if (row.EpisodeType == $g("急诊"))
		{
			return '<span style="color:blue;">'+val+'</span>';
		}	
	}

	//查询就诊列表
	function queryData()
	{
		var queryItem = document.getElementById("diagnosDesc").value
		$("#episodeList").datagrid('load', {
			Action: "GetEpisodeList",
			PatientID: patientID,
			QueryItem: (queryItem == $g("诊断内容"))? "":queryItem,
			EpisodeType: $('#episodeType').combobox('getValue')
		});	
	}
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
			obj.style.color='#999'
		}
	}
}

//患者信息
function getPatinentInfo()
{
	$.ajax({ 
        type: "POST", 
       	url: "../web.DHCCM.EMRservice.Ajax.PatientInfo.cls", 
        data: "action=GetPatientInfo"+ "&patientID=" +patientID+ "&EpisodeID=" +episodeID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            setPatientInfo(eval(data));
        } 
    });
}

//加载患者信息
function setPatientInfo(patientInfo) {
	var splitor = '&nbsp&nbsp|&nbsp&nbsp';
	var htmlStr = '&nbsp<span class="spancolorleft">'+$g("登记号")+':</span> <span class="spancolor">'
			+ patientInfo[0].papmiNo + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">'+$g("病案号")+':</span><span class="spancolor">'
			+ patientInfo[0].ipRecordNo + '</span>';
	
	/*if (HasPatEncryptLevel == "Y")
	{
		htmlStr += splitor
			+ '<span class="spancolorleft">病人密级:</span><span class="spancolor">'
			+ patientInfo[0].SecAlias + '</span>';

		htmlStr += splitor
			+ '<span class="spancolorleft">病人级别:</span><span class="spancolor">'
			+ patientInfo[0].EmployeeFunction + '</span>';
	}*/

	htmlStr += splitor
			+ '<span class="spancolorleft">'+$g("床号")+':</span><span class="spancolor">'
			+ patientInfo[0].disBed + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">'+$g("姓名")+':</span> <span class="spancolor">'
			+ patientInfo[0].name + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">'+$g("性别")+':</span> <span class="spancolor">'
			+ patientInfo[0].gender + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">'+$g("年龄")+':</span> <span class="spancolor">'
			+ patientInfo[0].age + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">'+$g("付费方式")+':</span><span class="spancolor">'
			+ patientInfo[0].payType + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">'+$g("入院日期")+':</span> <span class="spancolor">'
			+ patientInfo[0].admDate + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">'+$g("诊断")+':</span> <span class="spancolor">'
			+ patientInfo[0].mainDiagnos + '</span>';
	$('#patientInfo').append(htmlStr);
	jQuery(".patientInfo").css("display", "inline-block");
}


//浏览界面头菜单tabs
function setViewForm()
{
	/*
	var content1="<div id='frameBrowseEPRorEMR'>"+
					"<div data-options='iconCls:'list-category',selected:true,tools:'#instance-tools'' style='overflow-y:auto;height:700px;width:30%;vertical-align:text-top;padding:0px;background-color:#F6F6F6;margin:0px;float:right'>"+
						"<ul id='grugTree'></ul>"+
					"</div>"+
					"<div id='BrowseCategory'  style='width:70%; height:700px;scrolling:no;background-color:lightblue'></div>"+
				"</div>"
	addTab("tabBrowse","BrowseInEpisode","药历浏览",content1,false,true);
	
	var content2="<div id='frameBrowseEPRorEMRs'>"+
					"<div data-options='iconCls:'list-category',selected:true,tools:'#instance-tools'' style='overflow-y:auto;height:700px;width:30%;vertical-align:text-top;padding:0px;background-color:#F6F6F6;margin:0px;float:right'>"+
						"<ul id='grugTrees'></ul>"+
					"</div>"+
					"<div id='BrowseCategorys'  style='width:70%; height:700px;scrolling:no;background-color:lightblue'></div>"+
				"</div>"
	//var contents ="<iframe id='frameBrowseInEpisode' src='dhcpha.record.browse.episode.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeLocID="+episodeLocID+"&AdmType="+admType+"' style='width:1320px;height:700px;scrolling:no;frameborder:0'></iframe>"
	addTab("tabBrowse","BrowseInEpisodes","病历浏览",content2,false,false);
	
	loadHisDoc();	
	*/
	
	var content1="<div id='frameBrowseEPRorEMR'>"+
					"<div data-options='iconCls:'list-category',selected:true,tools:'#instance-tools'' style='overflow-y:auto;height:700px;width:30%;vertical-align:text-top;padding:0px;background-color:#F6F6F6;margin:0px;float:right'>"+
						"<ul id='grugTree'></ul>"+
					"</div>"+
					"<div id='BrowseCategory'  style='width:70%; scrolling:no;background-color:lightblue'></div>"+
				"</div>"
	addTab("tabBrowse","BrowseInEpisode",$g("药历浏览"),content1,false,true);
	$(".tabs-inner").hide(); //隐藏药历浏览tab头
}

//加载His数据,生成窗口头菜单，点击跳转到对应链接
function loadHisDoc()
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../web.DHCCM.EMRservice.Ajax.browse.cls",
		async: true,
		data: {"Action":"GetHisData"},
		success: function(d){
			if (d != "")
			{
				var data = eval(d);
				for (var i=0;i<data.length;i++){
					var url = formatUrl(data[i].url);
					var countent = '<iframe id="iframeTabs" frameborder="0" src="'+url+'&MWToken='+websys_getMWToken()+'" style=" width:1320px; height:500px;scrolling:no;"></iframe>';
					addTab("tabBrowse","his"+i,data[i].title,countent,false,false);
				}
			}
		},
		error: function(d){alert("error");}
	});
}
//格式化his url
function formatUrl(url)
{
	url = url.replace(/\[patientID\]/g, patientID);
	url = url.replace(/\[episodeID\]/g, episodeID);
	url = url.replace(/\[mradm\]/g, mradm);
	url = url.replace(/\[regNo\]/g, regNo);
	url = url.replace(/\[medicare\]/g, medicare);
	url = url.replace(/\[userID\]/g, userID);
	url = url.replace(/\[userCode\]/g, userCode);
	url = url.replace(/\[ctLocID\]/g, userLocID);
	url = url.replace(/\[ctLocCode\]/g, userLocCode);
	url = url.replace(/\[ssGroupID\]/g, ssgroupID);
	return url	
}
//增加tab标签
function addTab(ctrlId,tabId,tabTitle,content,closable,selected)
{

	$('#'+ctrlId).tabs('add',{
	    id:       tabId ,
		title:    tabTitle,
		content:  content,
		closable: closable,
		selected: selected	
   });	
}

//获取药历目录
function getListRecord(EpisodeId)
{
	var data = {
			"OutputType":"Stream",
			"Class":"web.DHCCM.EMRservice.BL.BLClientCategory",
			"Method":"GetRecordCatalogByHappenDate",
			"p1":EpisodeId,
			"p2":"save",
			"p3":"List"
		};
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: data,
		success: function(d) {
			setRecordList( eval("["+d+"]"));
		}
	});		
}

//加载药历浏览目录
function setRecordList(data)
{
	length=data.length;
	if(length==0){
		$("#grugTree").html("");
		$("#BrowseCategory").html("");
		var content = "<iframe style='width:99%;height:700px'></iframe>";
		$('#BrowseCategory').append(content);
		$.messager.show({
				title:$g('提示信息'),
				msg:$g('此次就诊没有药历!!')
			});
		return;
	}
	$('#grugTree').html("");
	$("#BrowseCategory").html("");
	$('#grugTree').attr("class","instance-item");
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li class="green" onclick="selectListRecord(this);"></li>');
		$(li).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(li).attr({"chartItemType":data[i].chartItemType,"pluginType":data[i].documentType});           
		$(li).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});			       
		$(li).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic,"emrNum":data[i].emrNum});
		var datetime = '<h3>'+data[i].happendate+'<span>'+data[i].happentime+'</span></h3>';
		var content = '<a href="#">'
							+'<DIV><H3>'+data[i].text+'</H3>'+" "
						   	+'<P class=con><span>'+data[i].creator+'</span>&nbsp&nbsp<span id="status">'+data[i].status+'</span></P></DIV>';
					 +'</a>';
		//判断当前是否被打印过，若printstatus为空，未被打印过
		if (data[i].printstatus == "")
		{
			var Logflag = $('<input type="button" class=flag id="Logflag"></input>');
			$(Logflag).attr({"emrDocId":data[i].emrDocId,"emrNum":data[i].emrNum});
		}
		else
		{
			var Logflag = $('<input type="button" class=flag id="Logflag" style="border:#49A026;background-color:#49A026;color:#49A026"></input>');
			$(Logflag).attr({"emrDocId":data[i].emrDocId,"emrNum":data[i].emrNum});
		}
		$(li).append(datetime+" ");
		$(li).append(content);	
		$(li).append(Logflag);
		$('#grugTree').append(li);  
		$('#grugTree').children().first().css("background-color","#DAEBFC")
		if (i == 0)
		{
			initRecord(li); 	
		} 	
	}
}

//药历浏览目录点击事件
$("#grugTree.instance-item li").live('click',function(){
	loadRecords(this);
});

///药历浏览目录选中效果
function selectListRecord(obj)
{
	for(var j=0;j<length;j++){
		$(obj).parent().children().eq(j).css("background-color","white")
	}
	$(obj).css("background-color","lightgreen")
}

//取药历相关详细数据
function setTempParam(obj)
{
	var id = $(obj).attr("id");
	var text = $(obj).text();
	var arraytext=text.split(" ");
	var text=arraytext[1] //药历名
    var chartItemType = $(obj).attr("chartItemType");
    var pluginType = $(obj).attr("pluginType");
    var emrDocId = $(obj).attr("emrDocId");
    var categoryId=$(obj).attr("categoryId");
    var templateId=$(obj).attr("templateId");
	tempParam = {"id":id,"text":text,"chartItemType":chartItemType,"pluginType":pluginType,"emrDocId":emrDocId,"status":"BROWSE","categoryId":categoryId,"templateId":templateId};
	return tempParam;
}

//初始化药历
function initRecord(obj)
{
	tempParam = setTempParam(obj);
	var src = "dhcpha.record.browse.browsform.editor.csp?id="+tempParam.id+"&text="+tempParam.text+"&chartItemType="+tempParam.chartItemType
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId
        + "&characteristic=1" + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID + "&MWToken="+websys_getMWToken();	
	var content = "<iframe id='frameBrowseCategory' src='" + src + "' style='width:99%;height:700px;frameborder='0';scrolling='no''></iframe>";
	$('#BrowseCategory').append(content);
}

//切换加载药历
function loadRecords(obj)
{
	if (window.frames["frameBrowseCategory"])
	{
		$("#BrowseCategory").html("");
		tempParam = setTempParam(obj);
		var src = "dhcpha.record.browse.browsform.editor.csp?id="+tempParam.id+"&text="+tempParam.text+"&chartItemType="+tempParam.chartItemType
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId
        + "&characteristic=1" + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID + "&MWToken="+websys_getMWToken();
        
		var contents="<iframe id='frameBrowseCategory' src='" + src + "' style='width:99%;height:700px;scrolling:no;frameborder:0'></iframe>";
		$('#BrowseCategory').append(contents);
	 	window.frames["frameBrowseCategory"].loadDocument(setTempParam(obj));
	}
}
///--------------------------------------------------------------------
//获取病历目录
function getListRecords(EpisodeId)
{
	var data = {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetRecordCatalogByHappenDate",
			"p1":EpisodeId,
			"p2":"save",
			"p3":"List"
		};
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: data,
		success: function(d) {
			setRecordLists( eval("["+d+"]"));
		}
	});		
}

//加载病历浏览目录
function setRecordLists(data)
{
	length=data.length;
	if(length==0){
		$("#grugTrees").html("");
		$("#BrowseCategorys").html("");
		var content = "<iframe style='width:99%;height:700px'></iframe>";
		$('#BrowseCategorys').append(content);
		$.messager.show({
				title:$g('提示信息'),
				msg:$g('此次就诊没有病历!!')
			});
		return;
	}
	$('#grugTrees').html("");
	$("#BrowseCategorys").html("");
	$('#grugTrees').attr("class","instance-item");
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li class="green" onclick="selectListRecord(this);"></li>');
		$(li).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(li).attr({"chartItemType":data[i].chartItemType,"pluginType":data[i].documentType});           
		$(li).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});			       
		$(li).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic,"emrNum":data[i].emrNum});
		var datetime = '<h3>'+data[i].happendate+'<span>'+data[i].happentime+'</span></h3>';
		var content = '<a href="#">'
							+'<DIV><H3>'+data[i].text+'</H3>'+" "
						   	+'<P class=con><span>'+data[i].creator+'</span>&nbsp&nbsp<span id="status">'+data[i].status+'</span></P></DIV>';
					 +'</a>';
		//判断当前是否被打印过，若printstatus为空，未被打印过
		if (data[i].printstatus == "")
		{
			var Logflag = $('<input type="button" class=flag id="Logflag"></input>');
			$(Logflag).attr({"emrDocId":data[i].emrDocId,"emrNum":data[i].emrNum});
		}
		else
		{
			var Logflag = $('<input type="button" class=flag id="Logflag" style="border:#49A026;background-color:#49A026;color:#49A026"></input>');
			$(Logflag).attr({"emrDocId":data[i].emrDocId,"emrNum":data[i].emrNum});
		}
		$(li).append(datetime+" ");
		$(li).append(content);	
		$(li).append(Logflag);
		$('#grugTrees').append(li);  
		
		if (i == 0)
		{
			initRecords(li); 	
		} 	
	}
}

//病历浏览目录点击事件
$("#grugTrees.instance-item li").live('click',function(){
	loadRecordss(this);
});

//初始化病历
function initRecords(obj)
{
	tempParam = setTempParam(obj);
	var src = "emr.record.browse.browsform.editor.csp?id="+tempParam.id+"&text="+tempParam.text+"&chartItemType="+tempParam.chartItemType
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId
        + "&characteristic=1" + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID + "&MWToken="+websys_getMWToken();	
	var content = "<iframe id='frameBrowseCategorys' src='" + src + "' style='width:99%;height:700px;frameborder='0';scrolling='no''></iframe>";
	$('#BrowseCategorys').append(content);
}

//切换加载病历
function loadRecordss(obj)
{
	if (window.frames["frameBrowseCategorys"])
	{
		$("#BrowseCategorys").html("");
		tempParam = setTempParam(obj);
		var src = "emr.record.browse.browsform.editor.csp?id="+tempParam.id+"&text="+tempParam.text+"&chartItemType="+tempParam.chartItemType
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId
        + "&characteristic=1" + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID + "&MWToken="+websys_getMWToken();
        
		var contents="<iframe id='frameBrowseCategorys' src='" + src + "' style='width:99%;height:700px;scrolling:no;frameborder:0'></iframe>";
		$('#BrowseCategorys').append(contents);
	 	window.frames["frameBrowseCategorys"].loadDocument(setTempParam(obj));
	}
}
//收藏,评价
function CollectTalk(){
	//添加收藏
	$("#btnCollect").on("click",function(){
		//药历操作记录需要数据 start
		var categoryId = "";
		var templateId = "";
		var recordParam=tempParam;
		
		if (recordParam != "")
		{
			categoryId = recordParam.categoryId;
			templateId = recordParam.templateId;
		}
		else{
			alert("请选择要收藏的药历!");
			return;
		}
		//药历操作记录需要数据 end
		//记录用户(收藏药历)行为
    	AddActionLog(userID,userLocID,"FavoritesAdd",""); 
		var arr = {"userId":userID,"userLocId":userLocID};
	    var tempFrame = "<iframe id='iframeFavAdd' scrolling='auto' frameborder='0' src='dhcpha.clinical.favorite.add.csp?EpisodeID="+episodeID+"&categoryId="+categoryId+"&templateId="+templateId+ "&MWToken="+websys_getMWToken()+"' style='width:450px; height:450px; display:block;'></iframe>";
	    document.getElementById("browsepage").style.visibility="hidden";
	    createDialog("dialogFavAdd",$g("添加收藏"),"454","490","iframeFavAdd",tempFrame,favAddCallback,arr);
	});
	
		//添加收藏回调记录日志
function favAddCallback(returnValue,arr)
{
	var UserID = arr.userId;
	var UserLocID = arr.userLocId;
    //记录用户(收藏病历.取消)行为
    if (returnValue == "FavoritesAdd.Cancel")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Cancel",""); 
    else if (returnValue == "FavoritesAdd.Commit")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Commit","");
}
	
	//药历评价
	$("#btnTalk").on("click",function(){
		if(tempParam==""){
			alert("请选择要评价的药历!");
			return;
		} 
		else{ 
		window.location="dhcpha.clinical.remarking.csp?InstanceID="+tempParam.id+"&UserID="+userID+"&UserLocID="+userLocID+"&EpisodeID="+episodeID+"&pluginType="+tempParam.pluginType+"&chartItemType="+tempParam.chartItemType+"&emrDocId="+tempParam.emrDocId;
		}
	});
}
function createDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback,arr){
    if ($("#modalIframe").length<1)
	{
        $("body").append('<iframe id="modalIframe" style="position: absolute; z-index: 1999; width: 100%; height: 100%; top: 0;left:0;scrolling:no;" frameborder="0"></iframe>');
    }
	else
	{
        $("#modalIframe").css("display","block");
    }
    $("body").append("<div id='"+dialogId+"'</div>");
	if (isNaN(width)) width = 800;
	if (isNaN(height)) height = 500; 
    
    var returnValue = "";
	$('#'+dialogId).dialog({ 
        title: dialogTitle,
        width: width,
        height: height,
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content: iframeContent,
        onBeforeClose:function(){
            var tempFrame = $('#'+iframeId)[0].contentWindow;
			if (tempFrame.dialogBeforeClose)
			{
				tempFrame.dialogBeforeClose();
			}
            if (tempFrame && tempFrame.returnValue)
			{
				returnValue = tempFrame.returnValue;
			    if ((returnValue !== "") &&(typeof(callback) === "function"))
				{
                    callback(returnValue,arr);
                }
			}
        },
        onClose:function(){
            $("#modalIframe").hide();
            document.getElementById("browsepage").style.visibility="visible";
			$("#"+dialogId).dialog('destroy');
        }
    });
}
//切换tab菜单效果
function tabSelect(){
	$('#tabBrowse').tabs({
    onSelect:function(title,index){
        if(index==0){
	        $("#tab-tools").css("display","block");
	        getListRecord(episodeID);//初始化药历目录
	        flag=0;
	        tabSelectName=title;
        }
        else if(index==1){
	        $("#tab-tools").css("display","none");
	        getListRecords(episodeID);//初始化病历目录
	        flag=1;
	        tabSelectName=title;
        }
        else{
	        $("#tab-tools").css("display","none");
	        flag=2;
	        tabSelectName=title;
	        selectTabsUrlTo();//点击tabs链接页面变化情况
        }
    }
 });
}

//窗口宽度变化
function buttonRightOrLeft()
{
	$(".layout-button-right").on("click",function(){
		$("#frameBrowseEPRorEMR").css("width","1090px");
		//$("#frameBrowseEPRorEMRs").css("width","967px");
		//$("#iframeTabs").css("width","967px");
		flagRightLeft=1;
	});
	$(".layout-button-left").on("click",function(){
		$("#frameBrowseEPRorEMR").css("width","1430px");
		//$("#frameBrowseEPRorEMRs").css("width","1320px");
		//$("#iframeTabs").css("width","1320px");
		flagRightLeft=2;
		
	});
}

//点击tabs链接页面变化情况
function selectTabsUrlTo(){
	if(tabSelectName==$g("过敏史")){
		 tabUrl="epr.chart.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeIDs=&mradm="+episodeID+"&ChartID=19&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=&ConsultID=&ConsultEpisodeID=981&copyOeoris=&copyTo="
	}
	if(tabSelectName==$g("检查报告")){
		tabUrl="epr.chart.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeIDs=&mradm="+episodeID+"&ChartID=23&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=&ConsultID=&ConsultEpisodeID=981&copyOeoris=&copyTo="
	}
	if(tabSelectName==$g("检验报告")){
		tabUrl="websys.csp?TDIRECTPAGE=jquery.easyui.dhclaborder.csp&PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeIDs=&mradm="+episodeID+"&ChartID=98&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=&ConsultID=&ConsultEpisodeID=161&copyOeoris=&copyTo="
	}
	if(tabSelectName==$g("病理")){
		tabUrl="epr.chart.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeIDs=&mradm="+episodeID+"&ChartID=140&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=&ConsultID=&ConsultEpisodeID=613&copyOeoris=&copyTo="
	}
	if(tabSelectName==$g("医嘱")){
		tabUrl="websys.csp?TDIRECTPAGE=websys.default.csp&WEBSYS.TCOMPONENT=DHCFAdmOrder&PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeIDs=&mradm="+episodeID+"&ChartID=22&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=&ConsultID=&ConsultEpisodeID=161&copyOeoris=&copyTo="
	}
	var countents = '<iframe id="iframeTabs" frameborder="0" src="'+tabUrl+'&MWToken='+websys_getMWToken()+'" style=" width:1320px; height:500px;scrolling:no;"></iframe>';
	var tab = $('#tabBrowse').tabs('getSelected');
		$('#tabBrowse').tabs('update', {
			tab: tab,
			options: {
				content: countents
			}
		});
}



