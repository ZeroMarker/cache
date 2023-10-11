if (typeof $g=='undefined') var $g=function(a){return a;}

var ActionTypeArgOnChange=function(){
	debounce_findMessageList();
}
var MsgStatusOnChange=function(){
	debounce_findMessageList();
}

//附加Json参数的处理
var OtherJsonHandler = function(detailsId,OtherJson,target){
	
	if (OtherJson && OtherJson["link"] && OtherJson["link"].indexOf('dhc.message.commexec.csp')>-1) {
		
		easyModal('须处理',OtherJson["link"],450,240,function(){
			onExecWindowClose();
		});
		return true;
	}
	
	
	var dialogTitle=$(target).data('from')=='view'?'查看':'须处理';
	if (OtherJson && !OtherJson.dialogTitle) OtherJson.dialogTitle=dialogTitle; //dialogTitle 窗口标题
	if(OtherJson["link"] && Object.prototype.toString.call(OtherJson["link"]) === "[object String]"){
		if (opener && opener.ShowExecMsgWin){
			opener.ShowExecMsgWin(detailsId,OtherJson);
		}else if (parent && parent.ShowExecMsgWin){
			parent.ShowExecMsgWin(detailsId,OtherJson);
		}
		
		OnOpenExecLink(detailsId);
		
	}else{
		alert("没有相应的处理链接");
	}
}

/// 当消息处理链接或查看链接打开时做某事  1.某些未处理消息在此时置为已处理
var OnOpenExecLink=function(detailsId){
	
	var rowData=$('#messagelist').datagrid('getSelected');
	if (rowData && rowData.DetailsId==detailsId ) {
		var rindex=$('#messagelist').datagrid('getRowIndex',rowData);
		if (typeof rowData["TExecFlag"]=='string' && rowData["TExecFlag"].indexOf('unexec')>-1 ){
			var dialogStyle=parseKeyValue(rowData['TDialogStyle']||'',',','=');
			if (dialogStyle['execMsgOnOpen']=='One' || dialogStyle['execMsgOnOpen']=='All'){  //当界面打开时处理消息
				var methodName="Exec"+dialogStyle['execMsgOnOpen'];
				$.ajaxRunServerMethod({ClassName:"websys.DHCMessageInterface",MethodName:methodName,MsgDetailsId:detailsId},function(rtn){
					if (rtn>0) {  //重新加载一遍新的消息数据
						viewMsgItemInfo(detailsId,rindex,rowData);
					}
				});
			}
		}
		
	}
}


var refreshMessageCount = function(){
	if (opener && opener.ForceShowDHCMessageCount){
			opener.ForceShowDHCMessageCount(false);
		}else if (parent && parent.ForceShowDHCMessageCount){
			parent.ForceShowDHCMessageCount(false);
		}
}
var SetReplyFlag = function(detailsId,rindex,rowData){
	$.ajaxRunServerMethod({ClassName:"websys.DHCMessageDetailsMgr",MethodName:"SaveReplyInfo",Id:detailsId},function(){
		refreshMessageCount();
		// 未读回复数量清空
		$.extend(rowData,{NewReplyCount:0});
		$('#messagelist').datagrid("updateRow",{index:rindex, row:rowData}) ;
	});
}
// 把该条消息置成已读,
var SetReadedFlag = function(detailsId,rindex,rowData){
	$.ajaxRunServerMethod({ClassName:"websys.DHCMessageDetailsMgr",MethodName:"SaveReadInfo",Id:detailsId},function(){
		refreshMessageCount();
		// 显示消息且变成非加粗字体
		$.extend(rowData,{TExecFlag:rowData["TExecFlag"].replace("unread","read")});
		$('#messagelist').datagrid("updateRow",{ index:rindex, row:rowData}) ;
	});
}
var SetExecFlag = function (ContentId){
	$.ajaxRunServerMethod({ClassName:"websys.DHCMessageInterface",MethodName:"ExecAllByContentIds",ContentIds:ContentId},function(){
		refreshMessageCount();
		//$("#ToolsExecBtn").html("已处理").removeClass("i-btn").addClass("i-btn-execedMsg");
		$('<a class="msg-btn" href="javascript:void(0);" id="ToolsExecBtn">'+$g('已处理')+'</a>').insertAfter('#ToolsExecBtn').linkbutton({});
		$("#ToolsExecBtn").remove();
		
		//把明细的处理人与处理时间也显示出来
		$('.msg-collapse-c').find('span').each(function(){
			if ($.trim( $(this).text() )==$g('处理人')+'：'){
				$(this).text($g('处理人')+'：'+sessionUserName);
			}
			if ($.trim( $(this).text() )==$g('处理时间')+'：'){
				$(this).text($g('处理时间')+'：'+getNowDateStr($g('处理时间')=='处理时间')+' '+zt(new Date()));
			}
		})
		
		
	});
}
///病历浏览按钮
var OpenEMRView=function(adm){
	var url='websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N'
	url=url+'&EpisodeID='+adm;
	easyOriginWin('EMRViewWin',url,'96%','88%')
}

//CKEDITOR_BASEPATH = '../scripts_lib/ckeditor/';
var zd = function(date,type){
	if (arguments.length==1){
		return date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
	}
	if (type==5){
		return date.getFullYear()+"年"+(date.getMonth()+1)+"月"+date.getDate()+"日";
	}
}
var zt = function(date){
	return date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
}
///获取当前日期字符串
function getNowDateStr(isCN){
	var date=new Date();
	if(isCN){
		return zd(date,5);
	}else{
		return $.fn.datebox.defaults.formatter(date);
	}
}
function parseKeyValue(str,sep1,sep2){
	var t={};
	for (var i=0,arr=str.split(sep1),len=arr.length;i<len;i++){
		var key=arr[i].split(sep2)[0]||'';
		var value=arr[i].split(sep2)[1]||'';
		if (key!='') t[key]=value;
	}
	return t;
}
var getExecUrl = function(rowData,detailData){
	var op="#", url = "", tmpobj = {};
	if ((rowData["OtherJson"] && rowData["OtherJson"]!="") || (rowData["TExecLink"]!="")){
		try{
			eval("var tmp = \""+rowData.OtherJson+"\"")
		}catch(e){
			var tmp=""
		}
		var width = 1000,height = 500,target="";
		var dialogStyle=parseKeyValue(rowData['TDialogStyle']||'',',','=');
		try{
			if (!!tmp ){
				tmpobj = $.parseJSON(tmp);
				width = tmpobj["dialogWidth"] || dialogStyle['dialogWidth']||1000;  //默认为1000  
				height =  tmpobj["dialogHeight"] || dialogStyle["dialogHeight"] || 500;  ////默认为500  
				target =tmpobj["target"] || dialogStyle["target"] || ''; 
			}
			if (dialogStyle['level']=='H'){
				width = dialogStyle['dialogWidth']||width;
				height = dialogStyle["dialogHeight"]||height;
				target = dialogStyle["target"] || '';  //target比较特殊
			}
			if (Object.prototype.toString.call(tmpobj["link"]) === "[object String]" && tmpobj["link"]!=""){
				//if (tmpobj["link"].indexOf("?")>-1) url = tmpobj["link"]+"&MsgDetailsId="+rowData["DetailsId"];
				//else url = tmpobj["link"]+"?MsgDetailsId="+rowData["DetailsId"];
				url = tmpobj["link"];
			}else{
				if (Object.prototype.toString.call(rowData["TExecLink"]) === "[object String]" && rowData["TExecLink"]!=""){
//					url = rowData["TExecLink"]+ (rowData["TExecLink"].indexOf('?')>-1?'&':'?')
//						+(tmpobj["linkParam"]?(tmpobj["linkParam"]+'&'):'')
//						+"MsgDetailsId="+rowData["DetailsId"];
					if (tmpobj["linkParam"]) {
						url = rowData["TExecLink"]+ (rowData["TExecLink"].indexOf('?')>-1?'&':'?')+tmpobj["linkParam"];
					}else{
						url = rowData["TExecLink"];
					}
				}
			}
			
			
			
			
			if(!!url){
				//统一拼接MsgDetailsId参数
				var noDetailsId=(dialogStyle['noDetailsId']=='1');
				if (!noDetailsId) url=url+(url.indexOf('?')>-1?'&':'?')+'MsgDetailsId='+rowData["DetailsId"];
				//url 支持模板语法
				var tmpData=$.extend({},rowData,detailData,window.session||{});
				url=parseTmpl(url,tmpData);
				
				var clientPath=dialogStyle['clientPath']||'';
				clientPath=clientPath.replace(/\\/ig,'\\\\'); //把单斜杠替换成双斜杠
				tmp = '{"link":"'+url+'","dialogWidth":"'+width+'","dialogHeight":"'+height+'","target":"'+target+'","clientPath":"'+clientPath+'"}';
				op = "javascript:OtherJsonHandler("+rowData["DetailsId"]+","+tmp+",this);";
			}
		}catch(e){
		}
	}
	return op;
}
var parseTmpl=function(template,data){
	if (typeof data=='object') {
		data=data||{};
	}else{
		data={};	
	}
	return template.replace(/\$\{(.+?)\}/ig,function(m,i,d){
		return data[i]||'';
	}) ;

}
var getAttachmentLink  = function(rowData){
	var url = "", tmpobj = {};
	if ((rowData["OtherJson"] && rowData["OtherJson"]!="")){
		try{
			eval("var tmp = \""+rowData.OtherJson+"\"")
		}catch(e){
			var tmp=""
		}
		try{
			if (!!tmp ){
				tmpobj = $.parseJSON(tmp);
			}
			if (Object.prototype.toString.call(tmpobj["attachmentUrl"]) === "[object String]"){
				url = tmpobj["attachmentUrl"];
			}
			if(!!url){
				return url
				
			}
		}catch(e){
			return "";
		}
	}
	return url;
} 
var gotoBottomReply = function(){
	var msgJObj = $(".msg-reply-c");
	if(msgJObj.length>0) msgJObj[0].scrollTop = msgJObj[0].scrollHeight; 
}
var showReadExecInfo=function(){
	var top=$('.msg-title a').offset().top-$('.adminfo').offset().top;
	var left=$('.msg-title a').offset().left-$('.adminfo').offset().left;
	var hiddenW=$('.msg-hidden').width();
	//console.log(left);console.log(top);
	$('.msg-hidden').css({left:left-hiddenW+7,top:top+24}).show();
}
var hideReadExecInfo=function(){
	$('.msg-hidden').hide();
}
var toggleExecInfo=function(ele){
	if($(".msg-title").is(":animated") || $(".msg-content").is(":animated")) return;
	if ($(ele).hasClass('expanded')){  //已经展开 隐藏
		$(ele).removeClass('expanded');
		//$('.msg-collapse-c').hide();
		$('.msg-content').animate({height:'+=24px'},600,'swing');
		$('.msg-title').animate({height:'-=24px'},600,'swing',function(){
			$('.msg-collapse-c').hide();
		});
	}else{
		$(ele).addClass('expanded');
		$('.msg-collapse-c').show();
		$('.msg-content').animate({height:'-=24px'},600,'swing');
		$('.msg-title').animate({height:'+=24px'},600,'swing');
		
	}
}
var currSelectedMsgJson={},
	pageCount=50; //pageCount 一次请求回复列表数量 需要和后台第一次获取时的数量一致
//查看详情
// caller调用方 ExecWinClose消息处理/查看窗口关闭时 ReqSelect请求选中（如跑马灯点击） TableClick消息列表表格点击 
// 2022-06-13增加了查看详情时自动打开业务处理、详情查看界面，避免死循环，增加caller参数区分是用户点击消息列表触发的还是处理窗口关闭时触发的
var viewMsgItemInfo = function(detailsId,rindex,rowData,caller){
	caller=caller||'';
	
	if (detailsId>0){
		currSelectedMsgJson.replyLoading = true;
		$.ajaxRunServerMethod({ClassName:"websys.DHCMessageDetailsMgr",MethodName:"GetDetailsInfo",DetailsId:detailsId},function(rtn){
			var tmprtn = $.parseJSON(rtn);
			if (!tmprtn.ReadDate || tmprtn.ReadDate==""|| (tmprtn.TExecFlag=="read" && (!tmprtn.ExecDate || tmprtn.ExecDate==""))){ //read状态 但是没有处理日期 说明消息曾经配置为需处理 现在改成了读即处理 这时也要再次调用方法 2020-05-28
				SetReadedFlag(detailsId,rindex,rowData); 		// 没有读时间 2017-08-28
				tmprtn.ReadDate = getNowDateStr(tmprtn.SendDate.indexOf('年')>-1); //zd(new Date(),5);
				tmprtn.ReadTime = zt(new Date());
				tmprtn.ReadUser = sessionUserName;
				/*读即处理消息 设置上处理人 2018-12-29*/
				if((tmprtn.TExecFlag=="unread"|| tmprtn.TExecFlag=="read") && (!tmprtn.ExecDate || tmprtn.ExecDate=="")){
					tmprtn.ExecDate = getNowDateStr(tmprtn.SendDate.indexOf('年')>-1); //zd(new Date(),5);
					tmprtn.ExecTime = zt(new Date());
					tmprtn.ExecUser = sessionUserName;
				}
			}
			currSelectedMsgJson = tmprtn;
			// 判断是否还有回复
			if (tmprtn && tmprtn.ReplyList && tmprtn.ReplyList.length>0){
				var replyLength = tmprtn.ReplyList.length;
				var hasNewReplyFlag = false;
				for(var i=0;i<replyLength;i++){
					if (tmprtn.ReplyList[i].newReplyFlag==1){ hasNewReplyFlag=true; }
				}
				if (hasNewReplyFlag) SetReplyFlag(detailsId,rindex,rowData);  // 有回复是新的
				if (replyLength==pageCount){
					currSelectedMsgJson.hasRemainReply = true;
				}
				
				currSelectedMsgJson.PageNo++;  //2019-6-5 随内容请求返回的页数改为0，所以下次滚动请求应+1
				pageCount=currSelectedMsgJson.PageCount||pageCount;  //2019-6-5 随内容请求返回了一页数量 以此为准
				
			}
			var btnHtml="";
			var op = getExecUrl(rowData,tmprtn);
			if ((op!="#")&&(op!="")){
				if(tmprtn["TExecFlag"]=="unread" || tmprtn["TExecFlag"]=="read" ){
					 btnHtml = "<a class='msg-btn msg-btn-link' href='javascript:void(0);' onclick='"+op+";return false;' data-from='view'>查看</a>";
				}else if(tmprtn["TExecFlag"]=="unread-unexec" || tmprtn["TExecFlag"]=="read-unexec" ){
					btnHtml = "<a class='msg-btn unexec msg-btn-link' href='javascript:void(0);' onclick='"+op+";return false;' >须处理</a>";
				}else if(tmprtn["TExecFlag"]=="read-exec"){
					btnHtml = "<a class='msg-btn exec msg-btn-link' href='javascript:void(0);' onclick='"+op+";return false;' >已处理</a>";
				}
			}
			tmprtn.ExecMsgBtn = ""
			var tools = "";
			var ToolbarItems=','+(tmprtn.ToolbarItems||'')+',';
			if (ToolbarItems.indexOf(",E,")>-1 ){
				if (tmprtn["TExecFlag"].indexOf("unexec")>-1){ 	// 默认处理按钮
					tools = "<a class='msg-btn' href='javascript:void(0);' onclick='javascript:SetExecFlag("+tmprtn.ContentId+");return false;' id='ToolsExecBtn'>须处理</a>"
				}else {
					tools = "<a class='msg-btn' href='javascript:void(0);' id='ToolsExecBtn'>已处理</a>"
				}
				if ((op!="#")&&(op!="")){ //如果配置了执行按钮  那么原来的配置的处理链接或者调用接口时传的链接 都当作查看链接 生成一个查看按钮 2020-12-24
					btnHtml = "<a class='msg-btn msg-btn-link' href='javascript:void(0);' onclick='"+op+";return false;' style='margin-left:10px;' data-from='view' >查看</a>";
				}
				tmprtn.ExecMsgBtn = btnHtml;
			}else if (btnHtml!=""){
				tmprtn.ExecMsgBtn = btnHtml;   //otherjson中的处理路径
			}
			
			if (ToolbarItems.indexOf(",EMRView,")>-1 && rowData.EpisodeId>0 ) { //病历浏览功能按钮
				tools="<a class='msg-btn' href='javascript:void(0);' onclick='javascript:OpenEMRView("+rowData.EpisodeId+");return false;' id='ToolsEMRViewBtn'>病历浏览</a>"+tools
				
			}
			
			
			tmprtn.ToolbarItems = tools;
			tmprtn.attachmentA = "";    //先将其置成空，否则如果没附件 会显示undefined
			tmprtn.attachmentLabel = "";
			//解析附件成链接
			var attLinks = getAttachmentLink(rowData);
			var attachmentAArr =[];
			if (typeof attLinks!="undefined" && attLinks!="undefined" && attLinks!=""){
				tmprtn.attachmentA="";
				var webapp="";
				var attLinksArr = attLinks.split(",");
				//多附件
				for (var i=0; i<attLinksArr.length; i++){
					var attLink = attLinksArr[i];
					var attLinkArr = attLink.split("/");
					var fileName = attLinkArr.splice(-1,1)[0];
					var dirName = attLinkArr.join("/");
					webapp = dirName.slice(0,dirName.indexOf("/web/"))
					var ext=fileName.split(".").splice(-1,1)[0].toUpperCase();
					if(ext=="BMP" || ext=="PNG" || ext=="GIF" || ext=="JPG" || ext=="JPEG"){
						//attachmentAArr.push("<a href='#' onclick='websys_lu(\""+attLink+"\",false,\"top=50,left=50,width=600,height=600\");return false;' target='_blank'>"+fileName+"</a>&nbsp;");
						var viewLink='dhc.message.imageview.csp?dirname='+dirName+'&filename='+encodeURIComponent(fileName);
						attachmentAArr.push("<a href='#' onclick='websys_lu(\""+viewLink+"\",false,\"top=50,left=50,width=600,height=600\");return false;' target='_blank'>"+fileName+"</a>&nbsp;");
					}else{
						//encodeURI --> encodeURIComponent
						var downloadUrl="websys.file.utf8.csp?act=download&dirname="+dirName+"&filename="+encodeURIComponent(fileName)
						downloadUrl=getTokenUrl(downloadUrl);
						attachmentAArr.push("<a href='"+downloadUrl+"' target='TRAK_hidden'>"+fileName+"</a>&nbsp;");
					}
				}
				tmprtn.attachmentA = attachmentAArr.join(",");
				tmprtn.attachmentLabel = $g("附件:");
			}
			//性别头像
			var patSex=''+tmprtn.SexZH+tmprtn.Sex;
			if (patSex.indexOf('男')>-1 ) {
				tmprtn.admHeadClass="sex-male"
			}else if(patSex.indexOf('女')>-1){
				tmprtn.admHeadClass="sex-female"
			}else{
				tmprtn.admHeadClass="sex-unknown"
			}
			//诊断处理  //原本为实现每个字下面加点 而在这做的处理 
			if (tmprtn.Diagnosis!=""){
				var DiagArr=tmprtn.Diagnosis.split(",");
				for (var i=0;i<DiagArr.length;i++){
					DiagArr[i]="<span class='msg-adm-diag typo-em' >"+DiagArr[i]+"</span>";
				}
				tmprtn.Diagnosis=DiagArr.join(" , ");
			}
			tmprtn.Context=removeXSS(tmprtn.Context);
			$('#right-box').html($('#AdmTpl').tmpl(tmprtn));
			$('#right-box').find('.msg-adm-content-diag').popover({
				content:'<div style="line-height:25px;width:'+($('#right-box').find('.msg-adm-content-diag').width())+'px;">'+tmprtn.Diagnosis+'</div>',
				placement:'bottom',
				trigger:'hover'
			})
			$('.msg-btn').linkbutton({});
			
			if(rowData['TDialogStyle'] && rowData['TDialogStyle'].indexOf('autoOpen')>-1 && caller=='TableClick') {  //autoOpen=1 并且是点击消息列表时触发的 自动打开业务处理链接或查看链接
				$('.msg-btn.msg-btn-link').click();
				
			}
			
			///当当前消息界面宽度较高时
			var hh=$('#right-box').height()-$('#right-box .adminfo').height();
			if (Math.abs(hh)>10) $('#right-box .msg-content').height( $('#right-box .msg-content').height()+hh );
			
			gotoBottomReply();
			$(".msg-reply-c").scroll(function(){
				var _t = $(this);
				var scrollTop = _t.scrollTop();
				if (scrollTop===0 && currSelectedMsgJson.hasRemainReply && !currSelectedMsgJson.replyLoading){
					var oldHeight = $(".msg-reply-c")[0].scrollHeight;//offsetHeight; 
					currSelectedMsgJson.replyLoading = true;
					// console.log("获取 第 "+currSelectedMsgJson.PageNo+" 页数据");
					$.ajaxRunServerMethod({
						ClassName:"websys.DHCMessageReplyContentMgr",MethodName:"GetReplyInfo",
						AdmDao:"",DetailsId:currSelectedMsgJson.DetailsId,PageNo:currSelectedMsgJson.PageNo,PageCount:pageCount
					},function(rtn){
						currSelectedMsgJson.hasRemainReply=false; // 认为没有更多回复
						currSelectedMsgJson.PageNo++;
						currSelectedMsgJson.replyLoading = false;
						var json = $.parseJSON(rtn);
						if (json && json.ReplyList){
							if (json.ReplyList.length==pageCount){
								currSelectedMsgJson.hasRemainReply=true;
							}else{
								//$(".msg-reply-c").off("scroll");
							}
							// var html = 
							$('#replyTpl').tmpl(json).prependTo(".msg-reply-c");
							//$(".msg-reply-c").append(html);
							//$(".msg-reply-c").prepend(html); // add before reply
							$(".msg-reply-c").get(0).scrollTop = $(".msg-reply-c").get(0).scrollHeight - oldHeight ;
						}
					});
				}
			});
			currSelectedMsgJson.replyLoading = false;
			//fitMsgTextHeight();   /////调整消息内容的高度 先注了
		})		
	} 
}

var MsgMsgLevelOnChange=function(e,val){
	//选择一次会触发两次  将原本选中变为未选中 将新的选中 所以只在将新的选中的查询
	if (val){
		debounce_findMessageList();
	}
}
/// 仅本身收到 状态且胡
var OnlySelfReceiveOnChange=function(e,val){
	debounce_findMessageList();
	
}
var replaceHtml=function(str){
	 return str.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
}
//日期格式校验
var checkDate=function (str){
	if(str==""){return true;}
	if(!dateformat) dateformat=3;
	if(dateformat==4){
		var RegStr=/^((((0[1-9]|[12][0-9]|3[01])\/(0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|((0[1-9]|[1][0-9]|2[0-8])\/02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
	}else if(dateformat==1){
		var RegStr=/^((((0[13578]|1[02])\/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)\/(0[1-9]|[12][0-9]|30))|(02\/(0[1-9]|[1][0-9]|2[0-8])))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
	}else{
		var RegStr=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
	}
	if (str.match(RegStr)==null){
		return false;
	}else{
		return true;
	}
}
function removeXSS(str){
	//str=str.replace(/(javascript)|(&nbsp;)|(script)/ig,""); 
	//处理比较粗糙，在消息这应该可以满足
	str=str.replace(/<\s*script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script\s*>/gi," ");
	str=str.replace(/javascript/ig,"[javascript]");
	str=str.replace(/<(\s+)on([a-zA-Z0-9]+)>/ig,"$1[on]$2"); 
	return str;
}
var findMessageList = function (pageNumber){
	//console.count("查询次数");
	var ReadFlag = $('#MsgStatus').combobox('getValue');
	ReadFlag!="Y"?ReadFlag="N":'';
	
	var LevelType = $("input[name='MsgLevel']:checked").length>0?$("input[name='MsgLevel']:checked").val():"D,V,I,G"

	var ActionTypeArg = $("#ActionTypeArg").combobox("getValue");
	
	var sdate=$('#sdate').datebox("getValue");
	if(!checkDate(sdate)){
		sdate="";
		$('#sdate').datebox("setValue",sdate);
	}
	var edate=$('#edate').datebox("getValue");
	if(!checkDate(edate)){
		edate="";
		$('#edate').datebox("setValue",edate);
	}
	if (ReadFlag=="Y"){ //在查已处理时 
		if (sdate==""){
			if (edate=="") {
				var EDate=new Date();
				sdate=$.fn.datebox.defaults.formatter( new Date(EDate-30*24*60*60*1000) );
			}else{
				var EDate=$.fn.datebox.defaults.parser(edate);
				sdate=$.fn.datebox.defaults.formatter( new Date( EDate-30*24*60*60*1000) );
			}
			$('#sdate').datebox("setValue",sdate);
		}
	}
	var OnlySelfReceive=''
	if($('#OnlySelfReceive').length>0){
		OnlySelfReceive=$('#OnlySelfReceive').checkbox('getValue')?'Y':'N';
	}
	var Catgory=STATIC_ARG.Catgory;

	var OtherParams='^^'+OnlySelfReceive+'^'+Catgory;
	
	
	$('#messagelist').datagrid("load",{ 
		ClassName:"websys.DHCMessageDetailsMgr",
		QueryName:"FindInfo",
		UserId:sessionUserId,
		ReadFlag:ReadFlag,
		SendDateStart:sdate,
		SendDateEnd:edate,
		ActionTypeArg:ActionTypeArg,
		LevelType:LevelType
		,MarqueeShow:request.OnlyMarquee=='1'?'Y':''  //仅跑马灯数据显示
		,OneDetailsId:request.MsgDetailsId>0?request.MsgDetailsId:''
		,OtherParams:OtherParams
	});
	if (pageNumber && pageNumber>1) {
		var opts=$('#messagelist').datagrid('options');
		var temp=opts.onLoadSuccess;
		opts.onLoadSuccess=function(){
			$('#messagelist').datagrid('getPager').pagination('select',pageNumber);
			opts.onLoadSuccess=temp;
		}
	}

}
var debounce_findMessageList=debounce(findMessageList,300);  
var openWinHandler = function(pageNumber){
	var LevelTypeFlag='D,V,I,G'
	if (IsNormalOpen && websys_getTop().LevelTypeFlag) LevelTypeFlag=websys_getTop().LevelTypeFlag

		var t=$("input[name='MsgLevel'][value='"+LevelTypeFlag+"']");
		if (t.length>0) t.radio('check');
		else  $("input[name='MsgLevel'][value='D,V,I,G']").radio('check');
		
	if (IsNormalOpen){
		var Catgory=websys_getTop().MsgListCatgory||'';
		STATIC_ARG.Catgory=Catgory;
		$("#ActionTypeArg").combobox('loadData',ActionTypeJson[Catgory]);
	}	
	
	
	$('#sdate').datebox("setValue","");
	$('#edate').datebox("setValue","");
	$("#ActionTypeArg").combobox("setValue","");
	$('#MsgStatus').combobox('setValue','N');
	
	if($('#OnlySelfReceiveOnChange').length>0){
		$('#OnlySelfReceiveOnChange').checkbox('setValue',false);
	}
	debounce_findMessageList(pageNumber);

}

///第三方打开 需要设置下初始值
var initTpsOpenDefArg=function(){
	
	setSearchFormData({
		LevelType:request.LevelType,
		ActionCode:request.ActionCode
	})
	
	return;
	
	var LevelTypeFlag='D,V,I,G';
	if (request.LevelType) LevelTypeFlag=request.LevelType;
		
		var t=$("input[name='MsgLevel'][value='"+LevelTypeFlag+"']");
		if (t.length>0) t.radio('check');
		else  $("input[name='MsgLevel'][value='D,V,I,G']").radio('check');
	
	$('#sdate').datebox("setValue","");
	$('#edate').datebox("setValue","");
	$("#ActionTypeArg").combobox("setValue",request.ActionCode||'');
	$('#MsgStatus').combobox('setValue','N');
	if($('#OnlySelfReceive').length>0){
		$('#OnlySelfReceive').checkbox('setValue',false);
	}
	
}

function setSearchFormData(obj){
	var LevelTypeFlag=obj.LevelType||'D,V,I,G';
	var t=$("input[name='MsgLevel'][value='"+LevelTypeFlag+"']");
	if (t.length>0) t.radio('check');
	else  $("input[name='MsgLevel'][value='D,V,I,G']").radio('check');
	
	$('#sdate').datebox("setValue",obj.StartDate||'');
	$('#edate').datebox("setValue",obj.EndDate||'');
	$("#ActionTypeArg").combobox("setValue",obj.ActionCode||'');
	$('#MsgStatus').combobox('setValue',obj.Status||'');
	if($('#OnlySelfReceive').length>0){
		$('#OnlySelfReceive').checkbox('setValue',!!obj.OnlySelfReceive);
	}
}

var fitSmallSize=function(){
	


	
	
	if(request.MsgDetailsId>0) {  //上 左 面板宽度为0
		$('body').layout('panel','north').panel('resize',{height:0});
		$('body>.layout-panel-north').hide();
		$('body').layout('panel','west').panel('resize',{width:0});
		$('#layout-center').css({paddingTop:'10px'});
		$('body').layout('resize');
		
		if($('#right-box').find('.msg-content').length>0) {
			var hh=$('#right-box').height()-$('#right-box .adminfo').height();
			if (Math.abs(hh)>10) $('#right-box .msg-content').height( $('#right-box .msg-content').height()+hh );
		}
		
		return;
	}
	
	
	
	//最佳为1230
	var leftBest=425;
	var winWidth=$(window).width();
	if (winWidth<1200) {
		var leftWidth=leftBest-(1200-winWidth);
		$('body').layout('panel','west').panel('resize',{width:leftWidth});
		$('body').layout('resize');
	}
	if (winWidth<1130) {
		$('#edate').next('.combo').hide()
		$('#edate').prev('span').hide()
	}
}
var debounce_fitSmallSize=debounce(fitSmallSize,200);  


var reply = function (typeFlag){
	var replyContentJObj = $("#replyContent");
	var replyContent = replyContentJObj.val();
	if (!replyContent){return false;}
	if (!currSelectedMsgJson){$.messager.alert("提示","请选中消息现回复!"); return false;}
	if (!currSelectedMsgJson.ContentId){$.messager.alert("提示","请选中消息现回复!"); return false;}
	var curUserName = sessionUserName;
	if (curUserName.length>=4){
		curUserName = curUserName.slice(0,4);
	}
	var style="";
	if (replyContentJObj.hasClass("italic")){
		style += "font-style:italic;";
	}
	if (replyContentJObj.hasClass("bold")){
		style += "font-weight:bold;";
	}
	$.ajaxRunServerMethod({ClassName:"websys.DHCMessageReplyContentMgr",MethodName:"Reply",
		Content:replyContent,ContentDr:currSelectedMsgJson.ContentId,ReplyUserDr:sessionUserId,ReplyType:typeFlag,IsAttachment:0,FStyle:style
	},function(replyRowId){
		if (parseInt(replyRowId)>0){
			$("#myselfReplyTpl").tmpl({
				userName:curUserName,
				replyContent:replyContent,
				sendDate:zd(new Date())+" "+zt(new Date()),
				newReplyFlag:0,
				fStyle:style
			}).appendTo(".msg-reply-c");
			$("#replyContent").val("");
			gotoBottomReply();
			//如果之前没有回复，要把没有回复提示去掉
			$('.msg-no-reply').hide();
		}else{
			// reply fail
		}
	});
	return false;
}

var init=function(){
	
	var DefLevelType='';
	var DefCatgory='';
	var DefOtherParams='';
	if (IsNormalOpen) {
		DefLevelType=websys_getTop().LevelType||'';
		DefCatgory=websys_getTop().MsgListCatgory||'';
		STATIC_ARG.Catgory=DefCatgory;
		
		DefOtherParams='^^^'+DefCatgory;
		
	}else if(request.IsTpsOpen=='1'){
		DefLevelType=request.LevelType||'';
		
		///tps也支持catgory 
		DefCatgory=request.Catgory||'';
		STATIC_ARG.Catgory=DefCatgory;
		DefOtherParams='^^^'+DefCatgory;
		
		
	}
	$('#ActionTypeArg').combobox({
		data:ActionTypeJson[DefCatgory]||[]
		,defaultFilter:4
	})
	
	var toolbar=undefined;
	if(typeof ShowOneKeyRead=='string' && ShowOneKeyRead=='Y') {
		toolbar=[{
			text:'一键阅读',
			iconCls:'icon-eye',
			id:'tb-one-key-read',
			handler:function(){
				$.messager.confirm('确定','确定要将所有消息标记为已读吗？',function(r){
					if(r){
						$.messager.progress({  
							title:'正在保存'
							,msg:'正在保存信息,请稍后...'	
						});
						
						var queryParams=$('#messagelist').datagrid('options').queryParams;
						var data=$.extend({},queryParams,{ClassName:'websys.DHCMessageDetailsMgr',MethodName:'ReadAllUnexec',UserId:sessionUserId})
						
						$.m(data,function(ret){
							$.messager.progress('close');
							if(ret>0) {
								$.messager.popover({type:'success',msg:'成功将'+ret+'条消息标为已读'})
								$('#messagelist').datagrid('reload');
							}else if(ret=='0'){
								$.messager.popover({type:'alert',msg:'没有消息需要标为已读'})
							}else{
								$.messager.popover({type:'error',msg:'失败：'+(ret.split('^')[1]||ret)})
							}
						})
						
						
					}	
					
				})	
				
			}	
		}]
		
	}



	var pageNumber=1,pageSize=12;
	if (request.DataInd>0) pageNumber=Math.floor((parseInt(request.DataInd)+1)/pageSize)+1;
	$('#messagelist').datagrid({
		fit:true,
		pagination: true,
	    pageSize:pageSize,
	    pageList:[pageSize],
	    pageNumber:pageNumber,
	    showPageList:false,
		striped:true,
		singleSelect:true,
		fit:true,
		url:$URL,
		queryParams: { 
			ClassName:"websys.DHCMessageDetailsMgr",
			QueryName:"FindInfo",
			UserId:sessionUserId,
			ReadFlag:"N",
			SendDateStart:"",
			SendDateEnd:"",
			ActionTypeArg:request.IsTpsOpen=='1'?request.ActionCode:'',
			LevelType:request.IsTpsOpen=='1'?request.LevelType:DefLevelType,
			MarqueeShow:request.OnlyMarquee=='1'?'Y':'' //仅跑马灯显示
			,OneDetailsId:request.MsgDetailsId>0?request.MsgDetailsId:''
			,OtherParams:DefOtherParams
		},
		onClickRow:function(rindex,rowData){
			viewMsgItemInfo(rowData.DetailsId,rindex,rowData,'TableClick');  //选择消息列表记录 查看详情
		},
		toolbar:toolbar,
		onLoadSuccess:function(data){
			
			if($('#messagelist').datagrid('options').queryParams.ReadFlag!='Y' && data.total>0) {
				$('#tb-one-key-read').linkbutton('enable')
			}else{
				$('#tb-one-key-read').linkbutton('disable')
			}
			
			$('#right-box').html('<div class="no-data"></div>');
			
			if (!request.DetailsIdSelected) { //加载成功 选择request传过来的DetailsId
				$.each(data.rows,function(ind,row){
					if(row.DetailsId==request.DetailsId && !request.DetailsIdSelected){
						$('#messagelist').datagrid('selectRow',ind);
						viewMsgItemInfo(row.DetailsId,ind,row,'ReqSelect');   //请求参数直接选择消息列表记录（如华西二的跑马灯点击） 查看详情
						request.DetailsIdSelected=true;
					}
				})
			}
			///直接只查一条消息 并且只打开一条消息
			if (request.MsgDetailsId>0) {
				$.each(data.rows,function(ind,row){
					if(row.DetailsId==request.MsgDetailsId){
						$('#messagelist').datagrid('selectRow',ind);
						viewMsgItemInfo(row.DetailsId,ind,row,'ReqSelect');   //请求参数直接选择消息列表记录（如华西二的跑马灯点击） 查看详情
					}
				})
			}

		},
		columns:[[
			{field:'TStatus',title:'状态',width:45,resizable:false,align:'center',formatter: function(value,row,index){
					var style="",title="";
					switch (row["TExecFlag"]){
						case "unread":
							title= $g("未读");
							break;
						case "unread-unexec":
							title= $g("未读未处理");
							break;
						case "read":
							title= $g("已读");
							break;
						case "read-exec":
							title= $g("已读已处理");
							break;
						case "read-unexec":
							title= $g("已读未处理");
							break;
					}
					var style="display:block;width:100%;"
					if (row["TExecFlag"]!=""){
						style += "background:url(../skin/default/images/"+row["TExecFlag"]+".png) center center no-repeat;"
					}
					return '<span title="'+title+'" style="'+style+'">&nbsp;&nbsp;</span>';
					
					// 2023-03-28 再次改为使用图片 炫彩极简 消息都使用彩图
					
					//var iconCls='icon-msg-'+(row["TExecFlag"].replace('exec','processed'));
					//return '<span title="'+title+'" class="icon block-icon '+iconCls+'"></span>';
					
				},styler:function(value,row,index){
					return "cursor:pointer ;";
					/*   //文字加背景色颜色模式
					var deflaultcss = "cursor:pointer ;color:#fff; ";
					var bgcolor="transparent";
					switch (row["TExecFlag"]){
						case "unread":
							bgcolor="#EF5420"; //"未读"
							break;
						case "unread-unexec":
							bgcolor="#FB7A12"; //"未读未处理";
							break;
						case "read":
							bgcolor="#0295D3"; //"已读";
							break;
						case "read-exec":
							bgcolor="#0295D3"; //"已读已处理";
							break;
						case "read-unexec":
							bgcolor="#02C7D3"; //"已读未处理";
							break;
					}
					
					deflaultcss += 'background-color:'+ bgcolor;
					return deflaultcss;*/
					
				}
			},
			{field:'ActionDesc',title:'消息类型',width:77,
				styler:function(value,row,index){
					var deflaultcss = "cursor:pointer ;";
					if (row["TExecFlag"].indexOf("unread")>-1){
						deflaultcss += ';font-weight: bold;';
					}
					return deflaultcss;
				}
			},
			{field:'Content',title:'内容',width:110,
				styler:function(value,row,index){
					var deflaultcss = "cursor:pointer ;";
					if (row["TExecFlag"].indexOf("unread")>-1){
						//deflaultcss += 'font-weight: bold;';
					}
					if ((row["ActionLevelType"]=="V")||(row["ActionLevelType"]=="D")){ deflaultcss+='color:red;';}
					if(row.TCellContentStyle) deflaultcss+=row.TCellContentStyle;
					return deflaultcss;
				},
				formatter:function(value,row,index){
					return replaceHtml(value);
				}
			},
			{field:'SendDate',title:'发送日期',width:95,align:'left',
				styler:function(value,row,index){
					var deflaultcss = "cursor:pointer ;";
					if (row["TExecFlag"].indexOf("unread")>-1){
						//deflaultcss += ';font-weight: bold;';
					}
					return deflaultcss;
				}
			},
			{field:'SendTime',title:'发送时间',width:71,align:'left',
				formatter:function(value,row,index){
					if (parseInt(row["NewReplyCount"])>0){
						return value+'<span class="badge" style="background-color:red;position:absolute;" title="未读回复数量">'+row["NewReplyCount"]+'</span>';
					}else{
						return value;
					}
				},
				styler:function(value,row,index){
					var deflaultcss = "cursor:pointer ;";
					if (row["TExecFlag"].indexOf("unread")>-1){
						//deflaultcss += ';font-weight: bold;';
					}
					return deflaultcss;
				}
			}
		]],onOpen : function(){
			openWinHandler(pageNumber); //messagewin只会在第一次打开时进入
		},lazy:true
	});
	if (IsNormalOpen){
		websys_getTop().$("#MessageWin").window("options").onOpen=function(){
			openWinHandler();
		};
	}
	if (request.IsTpsOpen=='1') {
		initTpsOpenDefArg();	
	}

	
	$('#right-box').on('click','.font-btn',function(){
		if ($(this).hasClass('bold')){  //加粗点击
			if($(this).hasClass('active')){  //已激活
				$(this).removeClass('active');
				$('#replyContent').removeClass('bold');
			}else{
				$(this).addClass('active');
				$('#replyContent').addClass('bold');
			}
		}else if($(this).hasClass('italic')){  //斜体点击
			if($(this).hasClass('active')){  //已激活
				$(this).removeClass('active');
				$('#replyContent').removeClass('italic');
			}else{
				$(this).addClass('active');
				$('#replyContent').addClass('italic');
			}
		}	
	})
	


	debounce_fitSmallSize();
}
$(init)

/// 提供给顶层消息处理界面弹框的onClose事件调用
function onExecWindowClose(){
	var rowData=$('#messagelist').datagrid('getSelected');
	if (rowData) {
		var rindex=$('#messagelist').datagrid('getRowIndex',rowData);
		viewMsgItemInfo(rowData.DetailsId,rindex,rowData,'ExecWinClose');  //消息处理/查看窗口关闭时 再次触发查看详情
	}
}