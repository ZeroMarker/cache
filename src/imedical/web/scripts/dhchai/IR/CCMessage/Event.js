///页面Event
function InitMessageWinEvent(obj){
	obj.LoadEvent = function(arguments){
		//加载消息列表
		obj.ccMsgLoad("");
		
		// 初始化快捷消息信息
		var DataQuery = $.Tool.RunQuery('DHCHAI.BTS.DictionarySrv','QryDic',"CCScreenMessage","1");
		if(DataQuery){
			var arrDT = DataQuery.record;
			var htmlStr = '';
			for (var ind = 0; ind < arrDT.length; ind++){
				var rd = arrDT[ind];
				var message=rd["DicDesc"];
				htmlStr += '<li text="'+message+'"><a href="#">'+message+'</a></li>';
			}
			$("#ulqMsg").html(htmlStr);
			$("#ulqMsg").mCustomScrollbar({
				theme: "dark-thick",
				axis: "y",
				scrollInertia: 100
			});
		}
	};
	
	$("#btnSaveMsg").click(function(e){
		//按钮发送消息
		var txt = $("#areaTxtMdg").val();
		var retval = obj.LayerMsg_Save("",MsgType,txt,"0");
		if (parseInt(retval)>0){
			layer.msg('消息发送成功!',{time: 2000,icon: 1});
			$("#areaTxtMdg").val("");
			obj.ccMsgLoad("");
			//layer.close(obj.idxLayerMsg);
		} else {
			
		}
	});
	
	$("#btnCloseMsg").click(function(e){
		if (PageType == 'WinOpen') { //js直接window.open
			window.close();
			 //关闭
			//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
			websys_showModal('close');

		} else {
			//layer.close(obj.idxLayerMsg);
			var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
			parent.layer.close(index);
		}
	});
	
	//数据保存
	//id 主键 type 消息类型 msg 内容 isRead 是否阅读
	obj.LayerMsg_Save=function(id,type,msg,isRead){
		var ID = id;
		var CSEpisodeDr = EpisodeDr;
		var CSMsgType = MsgType;  // 1院感、2临床
		var CSMsgDate = "";
		var CSMsgTime = "";  //时间
		var CSMsgUserDr = $.LOGON.USERID;
		var CSMsgLocDr =$.LOGON.LOCID;   //
		var CSMessage = msg;
		var CSIsRead = isRead;
		var CSReadDate = "";
		var CSReadTime = "";
		var CSReadUserDr = $.LOGON.USERID;		
		
		if (CSMessage == '') {
			layer.alert("消息内容不允许为空");
			return -1;
		}
		
		//处理换行特殊字符
		CSMessage= $.form.return2Br(CSMessage);
		
		var InputStr = ID;
		InputStr += "^" + CSEpisodeDr;
		InputStr += "^" + CSMsgType;
		InputStr += "^" + CSMsgDate;
		InputStr += "^" + CSMsgTime;
		InputStr += "^" + CSMsgUserDr;
		InputStr += "^" + CSMsgLocDr;
		InputStr += "^" + CSMessage;
		InputStr += "^" + CSIsRead;
		InputStr += "^" + CSReadDate;
		InputStr += "^" + CSReadTime;
		InputStr += "^" + CSReadUserDr;
		//debugger
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCMessage","Update",InputStr);
		if (parseInt(retval)>0){
			//成功			
		} else {
			layer.msg('保存消息发送失败!',{icon: 2});
		}
		return retval;
	};
		
	//快捷发送消息逻辑????
	$("#ulqMsg").delegate("li","click",function(e) {
		e.preventDefault();
		var txt = $(this).attr("text");
		var retval = obj.LayerMsg_Save("",MsgType,txt,"0");
		if (parseInt(retval)>0){
			layer.msg('消息发送成功!',{time: 2000,icon: 1});
			//layer.close(obj.idxLayerMsg);
			obj.ccMsgLoad("");
		}
	});
	
	//历史消息显示
	obj.ccMsgLoad = function(isRead)
	{
		var paadm = EpisodeDr;
		var runMsgQuery = $.Tool.RunQuery('DHCHAI.IRS.CCMessageSrv','QryMsgByPaadm',paadm,isRead);
		if(runMsgQuery){
			var arrDT = runMsgQuery.record;
			var str="";
			$("#lstMsg").empty();  //清楚历史数据
			for (var indDT = 0; indDT < arrDT.length; indDT++){
				var rd = arrDT[indDT];
				if(rd["CSMsgType"]=="1"){
					//院感科消息
					str += "<div id='patMsgType1'>";
		            str += "<div class='text-right'>{0}";
			        str +="<div class='row pd5'>";
			        str +="<div class='col-sm-11 col-md-11 pdr0 text-right'>";
					str +="<div class='tooltip left tooltip-danger' role='tooltip'>";
					str +="	<div class='tooltip-arrow'></div>";
					str +="	<div class='tooltip-inner'>{1}</div>";
					str +="</div>";
					str +="</div>";
					str +="<div class='col-sm-1 col-md-1 pdl0 text-left'>";
					str +="<span class='userphoto userphoto-danger'><i class='fa fa-user'></i></span>";
					str +="</div>";
					str +="</div>";
					str +="</div>";
					str = str.format(rd["MTitle"],rd["CSMessage"]);
				} else {
					//临床消息
					str +="<div id='patMsgType2'>";
					str += "	<div class='text-left'>{0}</div>";
					str += "	<div class='row pd5'>";
					str += "		<div class='col-sm-1 col-md-1 pdl0 pdr0 text-right'>";
					str += "			<span class='userphoto userphoto-primary'><i class='fa fa-user-md'></i></span>";
					str += "		</div>";
					str += "		<div class='col-sm-11 col-md-11 pdl0 text-left'>";
					str += "			<div class='tooltip right tooltip-info' role='tooltip'>";
					str += "				<div class='tooltip-arrow'></div>";
					str += "				<div class='tooltip-inner'>{1}</div>";
					str += "			</div>";
					str += "		</div>";
					str += "	</div>";
					str += "</div>";
					str = str.format(rd["MTitle"],rd["CSMessage"]);
				}
			}
			$("#lstMsg").append(str);
		}
		$("#bodyMsg").mCustomScrollbar({
			theme: "dark-thick",
			axis: "y",
			scrollInertia: 100
		});
		$("#bodyMsg").mCustomScrollbar("scrollTo","last");
	};
	
}
///iframe自适应屏幕高度
function iFrameHeight(id){
	var ifm = document.getElementById(id);
	if (ifm != null) {
		try {
			var bHeight = ifm.contentWindow.document.body.scrollHeight;
			var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
			var innerHeight = Math.min(bHeight, dHeight);
			var outerHeight = $(window).height()-70 ;
			ifm.height = outerHeight;
		} catch (e) {
			console.error(e);
			ifm.height = 560;
		}
	}
}