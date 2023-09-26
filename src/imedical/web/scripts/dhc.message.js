if (typeof $g=='undefined') var $g=function(a){return a;}
// underscore ����
function debounce(func, wait, immediate) {
    var timeout, result;
    var debounced = function () {
        var context = this;
        var args = arguments;

        if (timeout) clearTimeout(timeout);
        if (immediate) {
            // ����Ѿ�ִ�й�������ִ��
            var callNow = !timeout;
            timeout = setTimeout(function(){
                timeout = null;
            }, wait)
            if (callNow) result = func.apply(context, args)
        }
        else {
            timeout = setTimeout(function(){
                func.apply(context, args)
            }, wait);
        }
        return result;
    };
    debounced.cancel = function() {
        clearTimeout(timeout);
        timeout = null;
    };
    return debounced;
}
var ActionTypeArgOnChange=function(){
	debounce_findMessageList();
}
var MsgStatusOnChange=function(){
	debounce_findMessageList();
}
//����Json�����Ĵ���
var OtherJsonHandler = function(detailsId,OtherJson){
	if(OtherJson["link"] && Object.prototype.toString.call(OtherJson["link"]) === "[object String]"){
		if (opener && opener.ShowExecMsgWin){
			opener.ShowExecMsgWin(detailsId,OtherJson);
		}else if (parent && parent.ShowExecMsgWin){
			parent.ShowExecMsgWin(detailsId,OtherJson);
		}
	}else{
		alert("û����Ӧ�Ĵ�������");
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
		// δ���ظ��������
		$.extend(rowData,{NewReplyCount:0});
		$('#messagelist').datagrid("updateRow",{index:rindex, row:rowData}) ;
	});
}
// �Ѹ�����Ϣ�ó��Ѷ�,
var SetReadedFlag = function(detailsId,rindex,rowData){
	$.ajaxRunServerMethod({ClassName:"websys.DHCMessageDetailsMgr",MethodName:"SaveReadInfo",Id:detailsId},function(){
		refreshMessageCount();
		// ��ʾ��Ϣ�ұ�ɷǼӴ�����
		$.extend(rowData,{TExecFlag:rowData["TExecFlag"].replace("unread","read")});
		$('#messagelist').datagrid("updateRow",{ index:rindex, row:rowData}) ;
	});
}
var SetExecFlag = function (ContentId){
	$.ajaxRunServerMethod({ClassName:"websys.DHCMessageInterface",MethodName:"ExecAllByContentIds",ContentIds:ContentId},function(){
		refreshMessageCount();
		//$("#ToolsExecBtn").html("�Ѵ���").removeClass("i-btn").addClass("i-btn-execedMsg");
		$('<a class="msg-btn" href="javascript:void(0);" id="ToolsExecBtn">'+$g('�Ѵ���')+'</a>').insertAfter('#ToolsExecBtn').linkbutton({});
		$("#ToolsExecBtn").remove();
		
		//����ϸ�Ĵ������봦��ʱ��Ҳ��ʾ����
		$('.msg-collapse-c').find('span').each(function(){
			if ($.trim( $(this).text() )==$g('������')+'��'){
				$(this).text($g('������')+'��'+sessionUserName);
			}
			if ($.trim( $(this).text() )==$g('����ʱ��')+'��'){
				$(this).text($g('����ʱ��')+'��'+getNowDateStr($g('����ʱ��')=='����ʱ��')+' '+zt(new Date()));
			}
		})
		
		
	});
}
//CKEDITOR_BASEPATH = '../scripts_lib/ckeditor/';
var zd = function(date,type){
	if (arguments.length==1){
		return date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
	}
	if (type==5){
		return date.getFullYear()+"��"+(date.getMonth()+1)+"��"+date.getDate()+"��";
	}
}
var zt = function(date){
	return date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
}
///��ȡ��ǰ�����ַ���
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
var getExecUrl = function(rowData){
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
				width = tmpobj["dialogWidth"] || dialogStyle['dialogWidth']||1000;  //Ĭ��Ϊ1000  
				height =  tmpobj["dialogHeight"] || dialogStyle["dialogHeight"] || 500;  ////Ĭ��Ϊ500  
				target =tmpobj["target"] || dialogStyle["target"] || ''; 
			}
			if (dialogStyle['level']=='H'){
				width = dialogStyle['dialogWidth']||width;
				height = dialogStyle["dialogHeight"]||height;
				target = dialogStyle["target"] || '';  //target�Ƚ�����
			}
			if (Object.prototype.toString.call(tmpobj["link"]) === "[object String]" && tmpobj["link"]!=""){
				if (tmpobj["link"].indexOf("?")>-1) url = tmpobj["link"]+"&MsgDetailsId="+rowData["DetailsId"];
				else url = tmpobj["link"]+"?MsgDetailsId="+rowData["DetailsId"];
			}else{
				if (Object.prototype.toString.call(rowData["TExecLink"]) === "[object String]" && rowData["TExecLink"]!=""){
					url = rowData["TExecLink"]+ (rowData["TExecLink"].indexOf('?')>-1?'&':'?')
						+(tmpobj["linkParam"]?(tmpobj["linkParam"]+'&'):'')
						+"MsgDetailsId="+rowData["DetailsId"];
				}
			}
			
			if(!!url){
				tmp = '{"link":"'+url+'","dialogWidth":"'+width+'","dialogHeight":"'+height+'","target":"'+target+'"}';
				op = "javascript:OtherJsonHandler("+rowData["DetailsId"]+","+tmp+");";
			}
		}catch(e){
		}
	}
	return op;
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
	if ($(ele).hasClass('expanded')){  //�Ѿ�չ�� ����
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
	pageCount=50; //pageCount һ������ظ��б����� ��Ҫ�ͺ�̨��һ�λ�ȡʱ������һ��
//�鿴����
var viewMsgItemInfo = function(detailsId,rindex,rowData){
	if (detailsId>0){
		currSelectedMsgJson.replyLoading = true;
		$.ajaxRunServerMethod({ClassName:"websys.DHCMessageDetailsMgr",MethodName:"GetDetailsInfo",DetailsId:detailsId},function(rtn){
			var tmprtn = $.parseJSON(rtn);
			if (!tmprtn.ReadDate || tmprtn.ReadDate==""|| (tmprtn.TExecFlag=="read" && (!tmprtn.ExecDate || tmprtn.ExecDate==""))){ //read״̬ ����û�д������� ˵����Ϣ��������Ϊ�账�� ���ڸĳ��˶������� ��ʱҲҪ�ٴε��÷��� 2020-05-28
				SetReadedFlag(detailsId,rindex,rowData); 		// û�ж�ʱ�� 2017-08-28
				tmprtn.ReadDate = getNowDateStr(tmprtn.SendDate.indexOf('��')>-1); //zd(new Date(),5);
				tmprtn.ReadTime = zt(new Date());
				tmprtn.ReadUser = sessionUserName;
				/*����������Ϣ �����ϴ����� 2018-12-29*/
				if((tmprtn.TExecFlag=="unread"|| tmprtn.TExecFlag=="read") && (!tmprtn.ExecDate || tmprtn.ExecDate=="")){
					tmprtn.ExecDate = getNowDateStr(tmprtn.SendDate.indexOf('��')>-1); //zd(new Date(),5);
					tmprtn.ExecTime = zt(new Date());
					tmprtn.ExecUser = sessionUserName;
				}
			}
			currSelectedMsgJson = tmprtn;
			// �ж��Ƿ��лظ�
			if (tmprtn && tmprtn.ReplyList && tmprtn.ReplyList.length>0){
				var replyLength = tmprtn.ReplyList.length;
				var hasNewReplyFlag = false;
				for(var i=0;i<replyLength;i++){
					if (tmprtn.ReplyList[i].newReplyFlag==1){ hasNewReplyFlag=true; }
				}
				if (hasNewReplyFlag) SetReplyFlag(detailsId,rindex,rowData);  // �лظ����µ�
				if (replyLength==pageCount){
					currSelectedMsgJson.hasRemainReply = true;
				}
				
				currSelectedMsgJson.PageNo++;  //2019-6-5 ���������󷵻ص�ҳ����Ϊ0�������´ι�������Ӧ+1
				pageCount=currSelectedMsgJson.PageCount||pageCount;  //2019-6-5 ���������󷵻���һҳ���� �Դ�Ϊ׼
				
			}
			var btnHtml="";
			var op = getExecUrl(rowData);
			if ((op!="#")&&(op!="")){
				if(tmprtn["TExecFlag"]=="unread" || tmprtn["TExecFlag"]=="read" ){
					 btnHtml = "<a class='msg-btn' href='javascript:void(0);' onclick='"+op+";return false;' >�鿴</a>";
				}else if(tmprtn["TExecFlag"]=="unread-unexec" || tmprtn["TExecFlag"]=="read-unexec" ){
					btnHtml = "<a class='msg-btn unexec' href='javascript:void(0);' onclick='"+op+";return false;' >�봦��</a>";
				}else if(tmprtn["TExecFlag"]=="read-exec"){
					btnHtml = "<a class='msg-btn exec' href='javascript:void(0);' onclick='"+op+";return false;' >�Ѵ���</a>";
				}
			}
			tmprtn.ExecMsgBtn = ""
			var tools = "";
			if (tmprtn.ToolbarItems.indexOf("E")>-1 ){
				if (tmprtn["TExecFlag"].indexOf("unexec")>-1){ 	// Ĭ�ϴ���ť
					tools = "<a class='msg-btn' href='javascript:void(0);' onclick='javascript:SetExecFlag("+tmprtn.ContentId+");return false;' id='ToolsExecBtn'>�봦��</a>"
				}else {
					tools = "<a class='msg-btn' href='javascript:void(0);' id='ToolsExecBtn'>�Ѵ���</a>"
				}
			}else if (btnHtml!=""){
				tmprtn.ExecMsgBtn = btnHtml;   //otherjson�еĴ���·��
			}
			
			tmprtn.ToolbarItems = tools;
			tmprtn.attachmentA = "";    //�Ƚ����óɿգ��������û���� ����ʾundefined
			tmprtn.attachmentLabel = "";
			//��������������
			var attLinks = getAttachmentLink(rowData);
			var attachmentAArr =[];
			if (typeof attLinks!="undefined" && attLinks!="undefined" && attLinks!=""){
				tmprtn.attachmentA="";
				var webapp="";
				var attLinksArr = attLinks.split(",");
				//�฽��
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
						attachmentAArr.push("<a href='websys.file.utf8.csp?act=download&dirname="+dirName+"&filename="+encodeURIComponent(fileName)+"' target='TRAK_hidden'>"+fileName+"</a>&nbsp;");
					}
				}
				tmprtn.attachmentA = attachmentAArr.join(",");
				tmprtn.attachmentLabel = $g("����:");
			}
			//�Ա�ͷ��
			if (tmprtn.Sex=="��" || tmprtn.SexZH=="��" ) {
				tmprtn.admHeadClass="sex-male"
			}else if(tmprtn.Sex=="Ů"|| tmprtn.SexZH=="Ů" ){
				tmprtn.admHeadClass="sex-female"
			}else{
				tmprtn.admHeadClass="sex-unknown"
			}
			//��ϴ���  //ԭ��Ϊʵ��ÿ��������ӵ� ���������Ĵ��� 
			if (tmprtn.Diagnosis!=""){
				var DiagArr=tmprtn.Diagnosis.split(",");
				for (var i=0;i<DiagArr.length;i++){
					DiagArr[i]="<span class='msg-adm-diag typo-em' >"+DiagArr[i]+"</span>";
				}
				tmprtn.Diagnosis=DiagArr.join(" , ");
			}
			tmprtn.Context=removeXSS(tmprtn.Context);
			$('#right-box').html($('#AdmTpl').tmpl(tmprtn));
			$('.msg-btn').linkbutton({});
			gotoBottomReply();
			$(".msg-reply-c").scroll(function(){
				var _t = $(this);
				var scrollTop = _t.scrollTop();
				if (scrollTop===0 && currSelectedMsgJson.hasRemainReply && !currSelectedMsgJson.replyLoading){
					var oldHeight = $(".msg-reply-c")[0].scrollHeight;//offsetHeight; 
					currSelectedMsgJson.replyLoading = true;
					// console.log("��ȡ �� "+currSelectedMsgJson.PageNo+" ҳ����");
					$.ajaxRunServerMethod({
						ClassName:"websys.DHCMessageReplyContentMgr",MethodName:"GetReplyInfo",
						AdmDao:"",DetailsId:currSelectedMsgJson.DetailsId,PageNo:currSelectedMsgJson.PageNo,PageCount:pageCount
					},function(rtn){
						currSelectedMsgJson.hasRemainReply=false; // ��Ϊû�и���ظ�
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
			//fitMsgTextHeight();   /////������Ϣ���ݵĸ߶� ��ע��
		})		
	} 
}

var MsgMsgLevelOnChange=function(e,val){
	//ѡ��һ�λᴥ������  ��ԭ��ѡ�б�Ϊδѡ�� ���µ�ѡ�� ����ֻ�ڽ��µ�ѡ�еĲ�ѯ
	if (val){
		debounce_findMessageList();
	}
}
var replaceHtml=function(str){
	 return str.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
}
//���ڸ�ʽУ��
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
	//����Ƚϴֲڣ�����Ϣ��Ӧ�ÿ�������
	str=str.replace(/<\s*script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script\s*>/gi," ");
	str=str.replace(/javascript/ig,"[javascript]");
	str=str.replace(/<(\s+)on([a-zA-Z0-9]+)>/ig,"$1[on]$2"); 
	return str;
}
var findMessageList = function (pageNumber){
	//console.count("��ѯ����");
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
	if (ReadFlag=="Y"){ //�ڲ��Ѵ���ʱ 
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
	
	$('#messagelist').datagrid("load",{ 
		ClassName:"websys.DHCMessageDetailsMgr",
		QueryName:"FindInfo",
		UserId:sessionUserId,
		ReadFlag:ReadFlag,
		SendDateStart:sdate,
		SendDateEnd:edate,
		ActionTypeArg:ActionTypeArg,
		LevelType:LevelType
		,MarqueeShow:request.OnlyMarquee=='1'?'Y':''  //�������������ʾ
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
	if (request.OnlyMarquee!='1' && top.LevelTypeFlag) LevelTypeFlag=top.LevelTypeFlag

		var t=$("input[name='MsgLevel'][value='"+LevelTypeFlag+"']");
		if (t.length>0) t.radio('check');
		else  $("input[name='MsgLevel'][value='D,V,I,G']").radio('check');
	
	$('#sdate').datebox("setValue","");
	$('#edate').datebox("setValue","");
	$("#ActionTypeArg").combobox("setValue","");
	$('#MsgStatus').combobox('setValue','N');
	debounce_findMessageList(pageNumber);
}
var reply = function (typeFlag){
	var replyContentJObj = $("#replyContent");
	var replyContent = replyContentJObj.val();
	if (!replyContent){return false;}
	if (!currSelectedMsgJson){$.messager.alert("��ʾ","��ѡ����Ϣ�ֻظ�!"); return false;}
	if (!currSelectedMsgJson.ContentId){$.messager.alert("��ʾ","��ѡ����Ϣ�ֻظ�!"); return false;}
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
			//���֮ǰû�лظ���Ҫ��û�лظ���ʾȥ��
			$('.msg-no-reply').hide();
		}else{
			// reply fail
		}
	});
	return false;
}

var init=function(){
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
			ActionTypeArg:"",
			LevelType:"",
			MarqueeShow:request.OnlyMarquee=='1'?'Y':'' //���������ʾ
		},
		onClickRow:function(rindex,rowData){
			viewMsgItemInfo(rowData.DetailsId,rindex,rowData);
		},
		onLoadSuccess:function(data){
			$('#right-box').html('<div class="no-data"></div>');
			
			if (!request.DetailsIdSelected) { //���سɹ� ѡ��request��������DetailsId
				$.each(data.rows,function(ind,row){
					if(row.DetailsId==request.DetailsId && !request.DetailsIdSelected){
						$('#messagelist').datagrid('selectRow',ind);
						viewMsgItemInfo(row.DetailsId,ind,row);
						request.DetailsIdSelected=true;
					}
				})
			}

		},
		columns:[[
			{field:'TStatus',title:'״̬',width:45,resizable:false,align:'center',formatter: function(value,row,index){
					var style="",title="";
					switch (row["TExecFlag"]){
						case "unread":
							title= $g("δ��");
							break;
						case "unread-unexec":
							title= $g("δ��δ����");
							break;
						case "read":
							title= $g("�Ѷ�");
							break;
						case "read-exec":
							title= $g("�Ѷ��Ѵ���");
							break;
						case "read-unexec":
							title= $g("�Ѷ�δ����");
							break;
					}
					var style="display:block;width:100%;"
					if (row["TExecFlag"]!=""){
						style += "background:url(../skin/default/images/"+row["TExecFlag"]+".png) center center no-repeat;"
					}
					return '<span title="'+title+'" style="'+style+'">&nbsp;&nbsp;</span>';
				},styler:function(value,row,index){
					return "cursor:pointer ;";
					/*   //���ּӱ���ɫ��ɫģʽ
					var deflaultcss = "cursor:pointer ;color:#fff; ";
					var bgcolor="transparent";
					switch (row["TExecFlag"]){
						case "unread":
							bgcolor="#EF5420"; //"δ��"
							break;
						case "unread-unexec":
							bgcolor="#FB7A12"; //"δ��δ����";
							break;
						case "read":
							bgcolor="#0295D3"; //"�Ѷ�";
							break;
						case "read-exec":
							bgcolor="#0295D3"; //"�Ѷ��Ѵ���";
							break;
						case "read-unexec":
							bgcolor="#02C7D3"; //"�Ѷ�δ����";
							break;
					}
					
					deflaultcss += 'background-color:'+ bgcolor;
					return deflaultcss;*/
					
				}
			},
			{field:'ActionDesc',title:'��Ϣ����',width:77,
				styler:function(value,row,index){
					var deflaultcss = "cursor:pointer ;";
					if (row["TExecFlag"].indexOf("unread")>-1){
						deflaultcss += ';font-weight: bold;';
					}
					return deflaultcss;
				}
			},
			{field:'Content',title:'����',width:110,
				styler:function(value,row,index){
					var deflaultcss = "cursor:pointer ;";
					if (row["TExecFlag"].indexOf("unread")>-1){
						deflaultcss += ';font-weight: bold;';
					}
			
					if ((row["ActionLevelType"]=="V")||(row["ActionLevelType"]=="D")){return deflaultcss+'color:red;'}
					return deflaultcss;
				},
				formatter:function(value,row,index){
					return replaceHtml(value);
				}
			},
			{field:'SendDate',title:'��������',width:95,align:'left',
				styler:function(value,row,index){
					var deflaultcss = "cursor:pointer ;";
					if (row["TExecFlag"].indexOf("unread")>-1){
						deflaultcss += ';font-weight: bold;';
					}
					return deflaultcss;
				}
			},
			{field:'SendTime',title:'����ʱ��',width:71,align:'left',
				formatter:function(value,row,index){
					if (parseInt(row["NewReplyCount"])>0){
						return value+'<span class="badge" style="background-color:red;position:absolute;" title="δ���ظ�����">'+row["NewReplyCount"]+'</span>';
					}else{
						return value;
					}
				},
				styler:function(value,row,index){
					var deflaultcss = "cursor:pointer ;";
					if (row["TExecFlag"].indexOf("unread")>-1){
						deflaultcss += ';font-weight: bold;';
					}
					return deflaultcss;
				}
			}
		]],onOpen : function(){
			openWinHandler(pageNumber); //messagewinֻ���ڵ�һ�δ�ʱ����
		},lazy:true
	});
	if (request.OnlyMarquee!='1'){
		top.$("#MessageWin").window("options").onOpen=function(){
			openWinHandler();
		};
	}

	
	$('#right-box').on('click','.font-btn',function(){
		if ($(this).hasClass('bold')){  //�Ӵֵ��
			if($(this).hasClass('active')){  //�Ѽ���
				$(this).removeClass('active');
				$('#replyContent').removeClass('bold');
			}else{
				$(this).addClass('active');
				$('#replyContent').addClass('bold');
			}
		}else if($(this).hasClass('italic')){  //б����
			if($(this).hasClass('active')){  //�Ѽ���
				$(this).removeClass('active');
				$('#replyContent').removeClass('italic');
			}else{
				$(this).addClass('active');
				$('#replyContent').addClass('italic');
			}
		}	
	})
}
$(init)