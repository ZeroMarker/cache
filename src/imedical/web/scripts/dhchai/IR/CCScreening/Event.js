//页面Event
function InitCCScreeningWinEvent(obj){
	// 启用科室分组标志
	obj.LocGroupFlg = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","IRScreenIsGroup",$.LOGON.HOSPID);
	// 初始化权限
	obj.AdminPower = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	$.form.CheckBoxRender("#divpInfEffect");
	
	CheckSpecificKey();
	$.form.iCheckRender();  //渲染复选框|单选钮
	$.form.SetValue('chkIsFinish',true); //初始化
	$.form.SetValue('chkIsDelete',true);
	$.form.SetValue('chkIsMessage',true);
	$.form.SetValue('chkIsFollow',true);
	$.form.SetValue('chkIsScreenAtt',true);
	$.form.SetValue('chkIsScreenNoAtt',true);
	var htmlStr="";
	// 初始化快捷消息信息
	var DataQuery = $.Tool.RunQuery('DHCHAI.BTS.DictionarySrv','QryDic',"CCScreenMessage","");
	if(DataQuery){
		var arrDT = DataQuery.record;
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
	//初始化字典数据
	$("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框
	$.form.SelectRender("#cboFollowReason");  //渲染下拉框
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		refreshLocList();
	});
	$.form.SelectRender("#cboInfSubPos");  //渲染下拉框
	//给select2赋值change事件
	$("#cboInfSubPos").on("select2:select", function (e) { 
		//获得选中的诊断
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		layer.close(obj.idxLayerInfPos);
		
		//更新表格里的诊断
		var table = $("#gridPaAdm"+obj.selIdx);
		$('tr',table).each( function (){
			$('td',$(this)).eq(0).html(text);
		});
	});
	obj.StartDt = $.form.DateTimeRender("startDT",$.form.GetCurrDate('-'));  //默认当天
	obj.StartDt.on('change',function(ev){
		var  sDt=$("#startDT").val();
		var  eDt=$("#endDT").val();		
		if(sDt==""||eDt=="")
		{
			return;
		}
		var d1 = new Date(sDt.replace(/\-/g, "\/"));  
		var d2 = new Date(eDt.replace(/\-/g, "\/"));
		if(sDt!=""&&eDt!=""&&d1>d2)  
		{  
			//layer.alert('开始日期不能大于结束日期！');
			layer.tips('开始日期不能大于结束日期！', '#startDT', {tips: [1,'#3595CC'],time: 3000});
			$("#startDT").val("");
			return;
		}
		refreshLocList();
	});
	$('#IsMessage,#IsFollow').on('ifChanged', function(event){
		refreshLocList();
	});
	$('#IsFinish,#IsDelete').on('ifChanged', function(event){
		refreshLocList();
	});
	$('#IsScreenAtt,#IsScreenNoAtt').on('ifChanged', function(event){
		refreshLocList();
	});
	
	
	obj.EndDt = $.form.DateTimeRender("endDT",$.form.GetCurrDate('-'));
	obj.EndDt.on('change',function(ev){
		var  sDt=$("#startDT").val();
		var  eDt=$("#endDT").val();		
		if(sDt==""||eDt=="")
		{
			return;
		}
		var d1 = new Date(sDt.replace(/\-/g, "\/"));  
		var d2 = new Date(eDt.replace(/\-/g, "\/"));
		if(sDt!=""&&eDt!=""&&d1>d2)  
		{  
			//layer.alert('开始日期不能大于结束日期！');
			layer.tips('开始日期不能大于结束日期！', '#endDT', {tips: [1,'#3595CC'],time: 3000});
			$("#endDT").val("");
			return;
		}
		refreshLocList();
	});
	
	//在院状态事件
	$('#ulPaadmStatus > li').click(function (e) {
		e.preventDefault();
		$('#ulPaadmStatus > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).val();
		$('#ulPaadmStatus').val(val);
		if(val=="1")
		{
			//在院
			$('#selectDT').hide();
			$('#IsFinish').hide();
			$('#IsDelete').hide();
			$('#IsMessage').hide();
			$('#IsFollow').hide();
			$('#IsScreenAtt').show();
			$('#IsScreenNoAtt').show();
			var wh = $(window).height();
			$("#divPanel").height(wh-173);	
		}else if (val=="2")
		{
			//已出院
			$('#selectDT').show();
			$('#IsFinish').hide();
			$('#IsDelete').hide();
			$('#IsMessage').hide();
			$('#IsFollow').hide();
			$('#IsScreenAtt').show();
			$('#IsScreenNoAtt').show();
			var wh = $(window).height();
			$("#divPanel").height(wh-208);
		}else if (val=="3")
		{
			//已处理
			$('#selectDT').show();
			$('#IsFinish').show();
			$('#IsDelete').show();
			$('#IsMessage').hide();
			$('#IsFollow').hide();
			$('#IsScreenAtt').hide();
			$('#IsScreenNoAtt').hide();
			var wh = $(window).height();
			$("#divPanel").height(wh-208);	
		}else{
			//需关注
			$('#selectDT').show();
			$('#IsFinish').hide();
			$('#IsDelete').hide();
			$('#IsMessage').show();
			$('#IsFollow').show();
			$('#IsScreenAtt').hide();
			$('#IsScreenNoAtt').hide();
			var wh = $(window).height();
			$("#divPanel").height(wh-208);
		}
		refreshLocList();
	});
	
	//快捷发送消息逻辑 
	/* $('#ulqMsg li').click(function (e) {
		e.preventDefault();
		var txt = $(this).attr("text");		
		var retval = obj.LayerMsg_Save("","1",txt,"0");   
		if (parseInt(retval)>0){
			layer.msg('消息发送成功!',{time: 2000,icon: 1});
			//layer.close(obj.idxLayerMsg);
			obj.ccMsgLoad("");
		} else {
			
		}
		
	}); */
	//默认选择在院
	$('#ulPaadmStatus li:first-child').click();
	
	/* $("#btnSaveMsg").click(function(e){
		//按钮发送消息
		var txt = $("#areaTxtMdg").val();
		var retval = obj.LayerMsg_Save("","1",txt,"0"); 
		if (parseInt(retval)>0){
			layer.msg('消息发送成功!',{time: 2000,icon: 1});
			$("#areaTxtMdg").val("");
			obj.ccMsgLoad("");
			//layer.close(obj.idxLayerMsg);
		} else {
			
		}
	});
	$("#btnCloseMsg").click(function(e){
		layer.close(obj.idxLayerMsg);
	}); */
	/*
	btnPatAtt_Click = function(el,EpisodeID)
	{
		//切换样式
		var $this = $(el);
		var write = $this.hasClass("text-write");
		$.form.SetValue('cboIsNeedAtt',""); //初始化原因输入框
		if (write) {
			//需关注
			layer.open({
				type: 1,
				zIndex: 100,
				area: ['400px','200px'],
				title: '需关注原因', 
				content: $('#LayerIsNeedAtt'),
				btn: ['保存','关闭'],
				btnAlign: 'c',
				yes: function(index, layero){
					var retval = obj.LayerAtt_Save(EpisodeID,1);
					if (parseInt(retval)>0){
						$this.toggleClass("text-write");
						$this.toggleClass("text-yellow");
						layer.msg('关注成功!',{time: 2000,icon: 1});
					}
				}
			});
		} else {
			//取消关注
			var retval=obj.LayerAtt_Save(EpisodeID,0);
			if (parseInt(retval)>0){
				$this.toggleClass("text-yellow");
				$this.toggleClass("text-write");
				layer.msg('取消关注成功!',{time: 2000,icon: 1});
			}
		}
	};
	
	//编辑诊断
	btnEditAll_Click = function(el,aEpisodeDr,aInHospDate,aOutHospDate)
	{
		obj.selIdx = aEpisodeDr;  //主表下标
		obj.InfDiagnosDr = ''; //感染诊断记录指针
		obj.winOpenInfReport(aEpisodeDr);
		//obj.LayerInfRep(aInHospDate,aOutHospDate);	//弹出窗
	};
	*/
	//导出
	btnExport_click = function(e,aEpisodeDr)
	{		
		var table = $('#gridPaAdm' + aEpisodeDr).DataTable();
		if(table)
		{
			//导出
			table.buttons(0,null)[0].node.click();
		}
	}
	/*
	//全部确诊
	btnOkAll_Click = function(el,aEpisodeDr,aInHospDate,aOutHospDate)
	{
		var Count=0;
		var arrResult = obj.EpisScrRstList.CCSList[aEpisodeDr];
		for (var indRst = 0; indRst < arrResult.length; indRst++){
			var row = arrResult[indRst];
			if (!row) return;
			//if (row.RstStatus !== '0') continue;  //0未处理、1已处理
			//if ((row.OprStatus !== '0')&&(row.OprStatus !== '1')) continue;  //0未操作、1确诊、2排除
			if (row.OprStatus == '1') continue;
			
			var ScreenInfo = row.ItmScreenID;      //疑似筛查项目
			ScreenInfo += '^' + row.ItmScreenTxt;  //疑似筛查文本
			ScreenInfo += '^' + row.RstFromDate;   //疑似开始日期
			ScreenInfo += '^' + row.RstToDate;     //疑似结束日期
			ScreenInfo += '^' + '';                //疑似诊断
			ScreenInfo += '^' + "";                //疑似处置意见
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreeningSrv","SaveScreenOpera",aEpisodeDr,ScreenInfo,1,$.LOGON.USERID);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				Count++;
			}			
		}
		if (parseInt(Count)>0){
			layer.msg('确诊失败!',{icon: 2});
			return;
		} else {
			layer.msg('确诊成功!',{icon: 1});
			
			//处理疑似状态及处置状态（待处理、已确诊、已排除、已上报）
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreenAttSrv","UpdateSusInfFlag",aEpisodeDr);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				layer.msg('处置状态更新失败!',{icon: 2});
			} else {
				var txtSuspendCode2=$("#txtSuspendCode" + aEpisodeDr).html();
				$("#txtSuspendCode2" + aEpisodeDr).html(txtSuspendCode2);
				$("#txtSuspendCode" + aEpisodeDr).html(rstArr[2]);
				$("#txtSuspendDesc" + aEpisodeDr).html(rstArr[3]);
			}
			
			//刷新疑似筛查结果列表
			refreshRstList(aEpisodeDr,aInHospDate,aOutHospDate);
		}
		
		var $this = $(el);
		refreshCnt(aEpisodeDr);  //计数更新
	};
	
	//全部排除
	btnDetAll_Click = function(el,aEpisodeDr,aInHospDate,aOutHospDate)
	{
		var Count=0;
		var arrResult = obj.EpisScrRstList.CCSList[aEpisodeDr];
		for (var indRst = 0; indRst < arrResult.length; indRst++){
			var row = arrResult[indRst];
			if (!row) return;
			//if (row.RstStatus !== '0') continue;  //0未处理、1已处理
			//if ((row.OprStatus !== '0')&&(row.OprStatus !== '2')) continue;  //0未操作、1确诊、2排除
			if (row.OprStatus == '2') continue;
			
			var ScreenInfo = row.ItmScreenID;      //疑似筛查项目
			ScreenInfo += '^' + row.ItmScreenTxt;  //疑似筛查文本
			ScreenInfo += '^' + row.RstFromDate;   //疑似开始日期
			ScreenInfo += '^' + row.RstToDate;     //疑似结束日期
			ScreenInfo += '^' + '';                //疑似诊断
			ScreenInfo += '^' + "";                //疑似处置意见
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreeningSrv","SaveScreenOpera",aEpisodeDr,ScreenInfo,2,$.LOGON.USERID);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				Count++;
			}
		}
		if (parseInt(Count)>0){
			layer.msg('排除失败!',{icon: 2});
			return;
		} else {
			layer.msg('排除成功!',{icon: 1});
			
			//处理疑似状态及处置状态（待处理、已确诊、已排除、已上报）
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreenAttSrv","UpdateSusInfFlag",aEpisodeDr);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				layer.msg('处置状态更新失败!',{icon: 2});
			} else {
				var txtSuspendCode2=$("#txtSuspendCode" + aEpisodeDr).html();
				$("#txtSuspendCode2" + aEpisodeDr).html(txtSuspendCode2);
				$("#txtSuspendCode" + aEpisodeDr).html(rstArr[2]);
				$("#txtSuspendDesc" + aEpisodeDr).html(rstArr[3]);
			}
			
			//刷新疑似筛查结果列表
			refreshRstList(aEpisodeDr,aInHospDate,aOutHospDate);
		}
		
		var $this = $(el);
		refreshCnt(aEpisodeDr);  //计数更新
	};
	*/
	btnCCItemEditDiag_Click = function(e,aEpisodeDr,aArgStr)
	{
		obj.selIdx = aEpisodeDr;  //主表下标
		obj.InfDiagnosDr = aArgStr; //感染诊断记录指针
		obj.LayerInfRep("","");
	}
	
	btnCCItemDelDiag_Click = function(e,aEpisodeDr,aArgStr)
	{
		var InfDiagnosDr = aArgStr; //感染诊断记录指针
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.INFDiagnos","DeleteById",InfDiagnosDr);
		if (parseInt(retval)<0){
			if (parseInt(retval)==-2){
				layer.msg('存在关联院感报告不允许删除!',{icon: 2});
				return;
			}
			layer.msg('删除失败!',{icon: 2});
			return;
		} else {
			layer.msg('删除成功!',{icon: 1});
			refreshRstList(aEpisodeDr,"","");
		}
	}
	
	//确诊按钮
	btnCCItemOk_Click= function(e,aEpisodeDr,aArgStr,aInHospDate,aOutHospDate)
	{		
		var arrArg = aArgStr.split('^');
		if (arrArg.length < 4) return;
		var ItmScreenID = arrArg[0];
		var ItmScreenTxt = arrArg[1];
		var RstFromDate = arrArg[2];
		var RstToDate = arrArg[3];
		
		var ScreenInfo = ItmScreenID;      //疑似筛查项目
		ScreenInfo += '^' + ItmScreenTxt;  //疑似筛查文本
		ScreenInfo += '^' + RstFromDate;   //疑似开始日期
		ScreenInfo += '^' + RstToDate;     //疑似结束日期
		ScreenInfo += '^' + '';            //疑似诊断
		ScreenInfo += '^' + "";            //疑似处置意见
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreeningSrv","SaveScreenOpera",aEpisodeDr,ScreenInfo,1,$.LOGON.USERID);
		var rstArr = retval.split("^");
		if (parseInt(rstArr[0])<1){
			layer.msg('确认失败!',{icon: 2});
			return;
		} else {
			layer.msg('确认成功!',{icon: 1});
			
			//处理疑似状态及处置状态（待处理、已确诊、已排除、已上报）
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreenAttSrv","UpdateSusInfFlag",aEpisodeDr);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				layer.msg('处置状态更新失败!',{icon: 2});
			} else {
				var txtSuspendCode2=$("#txtSuspendCode" + aEpisodeDr).html();
				$("#txtSuspendCode2" + aEpisodeDr).html(txtSuspendCode2);
				$("#txtSuspendCode" + aEpisodeDr).html(rstArr[2]);
				$("#txtSuspendDesc" + aEpisodeDr).html(rstArr[3]);
			}
			
			//刷新疑似筛查结果列表
			refreshRstList(aEpisodeDr,aInHospDate,aOutHospDate);
			if (parseInt(rstArr[2])>0){
				refreshCnt(aEpisodeDr);  //计数更新
			}
		}
	}
	
	//排除按钮
	btnCCItemDel_Click =function(e,aEpisodeDr,aArgStr,aInHospDate,aOutHospDate)
	{
		
		var arrArg = aArgStr.split('^');
		if (arrArg.length < 4) return;
		var ItmScreenID = arrArg[0];
		var ItmScreenTxt = arrArg[1];
		var RstFromDate = arrArg[2];
		var RstToDate = arrArg[3];
		
		var ScreenInfo = ItmScreenID;      //疑似筛查项目
		ScreenInfo += '^' + ItmScreenTxt;  //疑似筛查文本
		ScreenInfo += '^' + RstFromDate;   //疑似开始日期
		ScreenInfo += '^' + RstToDate;     //疑似结束日期
		ScreenInfo += '^' + '';            //疑似诊断
		ScreenInfo += '^' + "";            //疑似处置意见
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreeningSrv","SaveScreenOpera",aEpisodeDr,ScreenInfo,2,$.LOGON.USERID);
		var rstArr = retval.split("^");
		if (parseInt(rstArr[0])<1){
			layer.msg('排除失败!',{icon: 2});
			return;
		} else {
			layer.msg('排除成功!',{icon: 1});
			
			//处理疑似状态及处置状态（待处理、已确诊、已排除、已上报）
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreenAttSrv","UpdateSusInfFlag",aEpisodeDr);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				layer.msg('处置状态更新失败!',{icon: 2});
			} else {
				var txtSuspendCode2=$("#txtSuspendCode" + aEpisodeDr).html();
				$("#txtSuspendCode2" + aEpisodeDr).html(txtSuspendCode2);
				$("#txtSuspendCode" + aEpisodeDr).html(rstArr[2]);
				$("#txtSuspendDesc" + aEpisodeDr).html(rstArr[3]);
			}
			
			//刷新疑似筛查结果列表
			refreshRstList(aEpisodeDr,aInHospDate,aOutHospDate);
			if (parseInt(rstArr[2])>0){
				refreshCnt(aEpisodeDr);  //计数更新
			}
		}
	}
	/*
	//集成视图
	openViewPat_click=function(EpisodeID)
	{
		//obj.selIdx = idx;
		//var objAdm = obj.PatArrData[obj.selIdx];
		var paadm = EpisodeID;
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+paadm+'&1=1';
		parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
	};
	//疑似病例筛查 发送消息 页面方式打开
	HAICasesMsgOper = function(aHAIEpisodeDr)
	{
		var t=new Date();
		t=t.getTime();
		var winWidth = 800;
		var winHeight = 500;
		var lnk = "../csp/dhchai.ir.ccmessage.csp?EpisodeDr=" + aHAIEpisodeDr + "&PageType=WinOpen&MsgType=1&t=" + t;
		try {
			var sFeatures = "dialogWidth=" + winWidth + "px;dialogHeight=" + winHeight + "px;resizable=no;"
			window.showModalDialog(lnk,"",sFeatures);
		} catch (error) {
			var sFeatures = "width=" + winWidth + "px,height=" + winHeight + "px,top=" + (($(window).height()-winHeight+200)/2) + "px,left=" + (($(window).width()-winWidth)/2) + "px,resizable=no;"
			var oWin = window.open(lnk,"",sFeatures);
		}
	}
	//发送提醒消息
	/* btnMsgSend_Click = function(el,admIdx)
	{
		obj.selIdx = admIdx;
		var objAdm = obj.PatArrData[obj.selIdx];
		obj.idxLayerMsg = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 100,
				maxmin: false,
				title: [objAdm.CurrLoc+"-"+objAdm.PatName,"text-align:center;background-color: #4C9CE4;color:#fff"], 
				area: ['600px','500px'],
				content: $('#LayerMsg'),
				success: function(layero,index){
					//展示回调
					//layer.full(index);					
					obj.ccMsgLoad("");		
					
				}
		});
	}; */
	
	//弹出
	obj.LayerICURep = function()
	{
		var rd = obj.layerRep_rd;
		//obj.layerIdxICURep = 
		
	};
	//数据保存
	//id 主键 type 消息类型 msg 内容 isRead 是否阅读
	/* obj.LayerMsg_Save=function(id,type,msg,isRead){
		var ID = id;
		var objAdm = obj.PatArrData[obj.selIdx];
		var CSEpisodeDr = objAdm.EpisodeID;
		var CSMsgType = type;  // 1院感、2临床
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
	}; */
	
	//更新需关注标志
	obj.LayerAtt_Save = function(EpisodeID,needAtt){
		if (EpisodeID == '') {
			layer.alert("关注患者不允许为空");
			return -1;
		}
		if ($.form.GetValue("cboIsNeedAtt") == "") {
			var IsNeedMsg = $.form.GetText("cboFollowReason");
		} else if ($.form.GetValue("cboFollowReason") == "") {
			var IsNeedMsg = $.form.GetValue("cboIsNeedAtt");
		} else {
			var IsNeedMsg = $.form.GetText("cboFollowReason") + ',' + $.form.GetValue("cboIsNeedAtt");
		}
		if (needAtt==0) IsNeedMsg='';
		
		//通过就诊号唯一判断
		var InputStr = EpisodeID;
		InputStr += "^" + needAtt;
		InputStr += "^" + IsNeedMsg;
		InputStr += "^" + $.LOGON.USERID;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCScreenAtt","UpdateNeedAttflag",InputStr);
		return retval;
	};
	
	//链接选中方式
    $('#gridLogs').on('click', 'a.editor_edit', function (e) {
        e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridLogs.row(tr);
		var rowData = row.data();
		obj.layerRep_rd = rowData;
		//alert(rowData.LocID+"---"+rowData.SurveryDate);
		//初始化数据
		//弹出界面
		obj.LayerICURep();
		
    });
	$("#btnPiccDel").on('click', function(){
		var selectedRows = obj.gridPICC.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridPICC.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFICUPICC","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!');
				} else {
					obj.gridPICC.rows({selected:true}).remove().draw(false);
					obj.layerPICC_rd = "";
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	$("#btnVapAdd").on('click', function(){
		//带管日志明细
		//$('td', row).eq(7)
		var rst = "";
		obj.layerVAP_rd = "";
		obj.LayerVAP();
	});
	$("#btnVapDel").on('click', function(){
		var selectedRows = obj.gridVAP.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridVAP.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFICUVAP","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!');
				} else {
					obj.gridVAP.rows({selected:true}).remove().draw(false);
					obj.layerVAP_rd = "";
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	$("#btnUcAdd").on('click', function(){
		//带管日志明细
		//$('td', row).eq(7)
		var rst = "";
		obj.layerUC_rd = "";
		obj.LayerUC();
	});
	$("#btnUcDel").on('click', function(){
		var selectedRows = obj.gridUC.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridUC.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFICUUC","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!');
				} else {
					obj.gridUC.rows({selected:true}).remove().draw(false);
					obj.layerUC_rd="";
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
		
	$("#btnExport").on('click', function(){
		//导出
		obj.gridLogs.buttons(0,null)[1].node.click();
		
	});
	
	//历史消息显示
	/* obj.ccMsgLoad = function(isRead)
	{
		var objAdm = obj.PatArrData[obj.selIdx];
		var paadm =objAdm.EpisodeID;
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
	}; */
	
	function refreshLocList()
	{
		//科室列表
		if (IsFinflag=='1'){
		   $("#ulPaadmStatus").hide();
		   $("#IsScreenAtt").hide();
		   $("#IsScreenNoAtt").hide();
	    }
		if (aTypeFlag!='') {$("#ulPaadmStatus").val(aTypeFlag);}
		if (aDateFrom!='') {$("#startDT").val(aDateFrom);}
		if (aIsFinDel!='') {$("#chkIsFinish").prop("checked",true);$("#chkIsDelete").prop("checked",false);}
		var status = $("#ulPaadmStatus").val();
		var start =$.form.GetValue("startDT");    //$.form.GetValue("startDT")==""?$.form.GetCurrDate('-'):
		var end =$.form.GetValue("endDT");     //$.form.GetValue("endDT")==""?$.form.GetCurrDate('-'):
		var hospIDs = $.form.GetValue("cboHospital");
		var IsMessage = $.form.GetValue("chkIsMessage");
		var IsFollow = $.form.GetValue("chkIsFollow");
		var IsFinDel = "";
		var IsFinish = $.form.GetValue("chkIsFinish");
		var IsDelete = $.form.GetValue("chkIsDelete");
		if ((IsFinish==1)&&(IsDelete==0)) {IsFinDel = "1";} //确诊
		if ((IsFinish==0)&&(IsDelete==1)) {IsFinDel = "2";} //排除
		if ((IsFinish==1)&&(IsDelete==1)) {IsFinDel = "3";} //确诊+排除
		
		var IsAttFlg = "";
		var IsScreenAtt = $.form.GetValue("chkIsScreenAtt");
		var IsScreenNoAtt = $.form.GetValue("chkIsScreenNoAtt");
		if ((IsScreenAtt==1)&&(IsScreenNoAtt==0)) {IsAttFlg = "1";} //已关注
		if ((IsScreenAtt==0)&&(IsScreenNoAtt==1)) {IsAttFlg = "2";} //未关注
		if ((IsScreenAtt==1)&&(IsScreenNoAtt==1)) {IsAttFlg = "3";} //已关注+未关注
		
		//条件有效性验证
		if(status=="2")
		{
			//出院 31天
			var iDay = $.form.DateDiff(start,end);
			if(iDay>31)
			{
				//$.form.DateTimeRender("startDT",$.form.GetCurrDate('-'));
				//$.form.DateTimeRender("endDT",$.form.GetCurrDate('-'));
				//layer.msg('开始结束日期间隔超出范围 31天！');
				//小tips
				layer.tips('开始结束日期间隔超出范围 31天！', '#endDT', {tips: [1,'#3595CC'],time: 3000});
				//return;
			}
		}
		else if(status=="3")
		{
			//已处理15天 31
			var iDay = $.form.DateDiff(start,end);
			if(iDay>31)
			{
				//$.form.DateTimeRender("startDT",$.form.GetCurrDate('-'));
				//$.form.DateTimeRender("endDT",$.form.GetCurrDate('-'));
				layer.tips('开始结束日期间隔超出范围 31天！', '#endDT', {tips: [1,'#3595CC'],time: 3000});
				//return;
			}
		}
		else if(status=="4")
		{
			//已处理15天 31
			var iDay = $.form.DateDiff(start,end);
			if(iDay>31)
			{	
				//$.form.DateTimeRender("startDT",$.form.GetCurrDate('-'));
				//$.form.DateTimeRender("endDT",$.form.GetCurrDate('-'));
				layer.tips('开始结束日期间隔超出范围 31天！', '#endDT', {tips: [1,'#3595CC'],time: 3000});
				//return;
			}
		}
		
		//1科室、2病区
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CCScreeningSrv','QryScreenLocList',status,start,end,hospIDs,"2",IsMessage,IsFollow,IsFinDel,IsAttFlg,IsFinflag);
		if(obj.LocGroupFlg=="1"){
			//处理科室组数据(obj.LocGrpData)
			if(runQuery){
				$("#ulLoc").empty();
				var arrDT = runQuery.record;
				ProcLocGrpData(arrDT);
				
				//一级
				var str="";
				str += "<li>";
				str +="<a id='LocQY' href='#'>";
				str +="<span>{0}</span><span class='pull-right-container'><small class='label pull-right bg-yellow' title='住院病人'>{1}</small>  <small class='label pull-right bg-green' title='已确诊/已处理'>{4}/{2}</small>  <small class='label pull-right bg-red' title='待处理'>{3}</small></span>";
				str +="</a></li>";
				str = str.format("全  院", obj.LocGrpData.HospInPatientCnt,obj.LocGrpData.HospScreenLogCnt,obj.LocGrpData.HospScreeningCnt,obj.LocGrpData.HospConfirmCnt);
				var tmpStr ="";
				GroupArrData=obj.LocGrpData.LocGrpList;
				
				for(i=0;i<GroupArrData.length;i++){
					var LocGrpUser   = GroupArrData[i].LocGrpUser;
					var ScreeningCnt = GroupArrData[i].ScreeningCnt;
					var	ScreenLogCnt = GroupArrData[i].ScreenLogCnt;
					var	InPatientCnt = GroupArrData[i].InPatientCnt;
					var	ConfirmCnt   = GroupArrData[i].ConfirmCnt;
					tmpStr += ("<li class='loc-group'><a id='LocGroup"+i+"' href='#'><span>{0}</span><span class='pull-right-container'><small class='label pull-right bg-yellow' title='住院病人'>{1}</small>  <small class='label pull-right bg-green' title='已处理'>{4}/{2}</small>  <small class='label pull-right bg-red' title='待处理'>{3}</small></span></a>");
					tmpStr = tmpStr.format(LocGrpUser,InPatientCnt,ScreenLogCnt,ScreeningCnt,ConfirmCnt);
					tmpStr+="</li>";
					// 二级
					tmpStr += "<li class='loc-sub'>";
					tmpStr +="<ul id='ulLocMX"+i+"' class='treeview-menu'>";
					var tmp2Str="";
					for(j=0;j<GroupArrData[i].LocList.length;j++){
						var pID = GroupArrData[i].LocList[j].LocID;
						//二级
						if (status=="1") {   // 只是在院才显示床位图标
							tmp2Str += ("<li text='"+pID+"'><a style='margin-left:-10px;' href='#'><img src='../scripts/dhchai/img/床位图.png'></a><a id='Loc"+pID+"' href='#'>{0}<span class='pull-right-container'><small class='label pull-right bg-yellow' title='住院病人'>{1}</small>  <small class='label pull-right bg-green' title='已确诊/已处理'>{4}/{2}</small>  <small class='label pull-right bg-red' title='待处理'>{3}</small></span></a>");
						}else{
							tmp2Str += ("<li text='"+pID+"'><a id='Loc"+pID+"' href='#'>{0}<span class='pull-right-container'><small class='label pull-right bg-yellow' title='住院病人'>{1}</small>  <small class='label pull-right bg-green' title='已确诊/已处理'>{4}/{2}</small>  <small class='label pull-right bg-red' title='待处理'>{3}</small></span></a>");
						}
						tmp2Str = tmp2Str.format(GroupArrData[i].LocList[j].LocDesc,GroupArrData[i].LocList[j].InPatientCnt,GroupArrData[i].LocList[j].ScreenLogCnt,GroupArrData[i].LocList[j].ScreeningCnt,GroupArrData[i].LocList[j].ConfirmCnt);
						tmp2Str+="</li>";
					}
					tmpStr += tmp2Str;
					tmpStr += "</ul></li>";
				}
				str += tmpStr;
				$("#ulLoc").append(str);
				if(status == "2"){   //修改不同页签的title提示
					$("#LocQY .pull-right-container small:first-child").attr("title","出院病人");  //一级标题
					$("li.loc-group a .pull-right-container small:first-child").attr("title","出院病人");
					$("li.loc-sub a .pull-right-container small:first-child").attr("title","出院病人");
				}
				else if(status == "3"){
					$("#LocQY .pull-right-container small:first-child").attr("title","已处理病人");
					$("li.loc-group a .pull-right-container small:first-child").attr("title","已处理病人");
					$("li.loc-sub a .pull-right-container small:first-child").attr("title","已处理病人");
				}
				else if(status == "4"){
					$("#LocQY .pull-right-container small:first-child").attr("title","需关注病人");
					$("li.loc-group a .pull-right-container small:first-child").attr("title","需关注病人");
					$("li.loc-sub a .pull-right-container small:first-child").attr("title","需关注病人");
				}
			}
			// 点击展开床位图
			$('.loc-sub img').click(function(e){
				e.preventDefault();
				if (e.stopPropagation) {
		            e.stopPropagation();      //阻止事件
		        } else {
		            e.cancelBubble = true;    //IE兼容
		        }
				var LocID = $(this).parent().parent().attr("text");
				$('#ulLoc').val(LocID);
				InitBedChart(obj,LocID,"","","","2");
				return;
			});
			//科室选中逻辑 
			$('.loc-sub li').click(function (e) {
				e.preventDefault();
				$('.loc-sub li').removeClass('active');
				$(this).addClass("active");
				myLoading();			
				if ($(".Loading_animate_content").length != 0) {
					myLoadingBug();
					$(".Loading_animate_content").css("display","block");
				}
				var txt = $(this,"a").attr("text");
				$('#ulLoc').val(txt);
				setTimeout(refreshPatList,0.2*1000);  //错开达到异步
			});
			//默认选择第一条科室
			//$('#ulLocMX0 li:first-child').click();
			$(".loc-sub ul").hide();
			// 科室分组点击展现
			$(".loc-group").click(function(){
				var GroupID = $(this).children("a").attr("id").substring(8);
				if ($("#ulLocMX"+GroupID).css("display")=="block"){
					$(".loc-sub ul").hide();
				}else {
					$(".loc-sub ul").hide();
					$("#ulLocMX"+GroupID).show();
				}
				//默认选择该分组下第一条科室
				$('#ulLocMX'+GroupID+' li:first-child').click();
			});  
		} else {
			if(runQuery){
		
				$("#ulLoc").empty();
				var arrDT = runQuery.record;
				
				//一级
				var str="";
				str += "<li class='active treeview'>";
				str +="<a id='LocQY' href='#'>";
				str +="<span>{0}</span><span class='pull-right-container'><small class='label pull-right bg-yellow' title='住院病人'>{1}</small>  <small class='label pull-right bg-green' title='已确诊/已处理'>{4}/{2}</small>  <small class='label pull-right bg-red' title='待处理'>{3}</small></span>";
				str +="</a>";
				var cntIn =0,cntLog=0,cntIng=0,cntCfm=0;
				
				str +="<ul id='ulLocMX' class='treeview-menu'>"
				var tmpStr ="";
				for(i=0;i<arrDT.length;i++){
					var pID = arrDT[i].LocID;
					
					//二级
					if (status=="1") {   // 只是在院才显示床位图标
						tmpStr += ("<li text='"+pID+"'><a style='margin-left:-10px;' href='#'><img src='../scripts/dhchai/img/床位图.png'></a><a id='Loc"+pID+"' href='#'>{0}<span class='pull-right-container'><small class='label pull-right bg-yellow'>{1}</small>  <small class='label pull-right bg-green'>{4}/{2}</small>  <small class='label pull-right bg-red'>{3}</small></span></a>");
					}else{
						tmpStr += ("<li text='"+pID+"'><a id='Loc"+pID+"' href='#'>{0}<span class='pull-right-container'><small class='label pull-right bg-yellow'>{1}</small>  <small class='label pull-right bg-green'>{4}/{2}</small>  <small class='label pull-right bg-red'>{3}</small></span></a>");
					}
					cntIn  = cntIn  + parseInt(arrDT[i].InPatientCnt);
					cntLog = cntLog + parseInt(arrDT[i].ScreenLogCnt);
					cntIng = cntIng + parseInt(arrDT[i].ScreeningCnt);
					cntCfm = cntCfm + parseInt(arrDT[i].ConfirmCnt);
					tmpStr = tmpStr.format(arrDT[i].LocDesc,arrDT[i].InPatientCnt,arrDT[i].ScreenLogCnt,arrDT[i].ScreeningCnt,arrDT[i].ConfirmCnt);
					
					//三级暂不考虑
					
					tmpStr+="</li>";
				}
				str = str.format("全  院", cntIn,cntLog,cntIng,cntCfm);
				str += tmpStr;
				str += "</ul></li>";
				$("#ulLoc").append(str);
				if(status == "2"){   //修改不同页签的title提示
					$("#LocQY .pull-right-container small:first-child").attr("title","出院病人");  //一级标题
					$("li.loc-group a .pull-right-container small:first-child").attr("title","出院病人");
					$("li.loc-sub a .pull-right-container small:first-child").attr("title","出院病人");
				}
				else if(status == "3"){
					$("#LocQY .pull-right-container small:first-child").attr("title","已处理病人");
					$("li.loc-group a .pull-right-container small:first-child").attr("title","已处理病人");
					$("li.loc-sub a .pull-right-container small:first-child").attr("title","已处理病人");
				}
				else if(status == "4"){
					$("#LocQY .pull-right-container small:first-child").attr("title","需关注病人");
					$("li.loc-group a .pull-right-container small:first-child").attr("title","需关注病人");
					$("li.loc-sub a .pull-right-container small:first-child").attr("title","需关注病人");
				}
			}
			// 点击展开床位图
			$('#ulLocMX img').click(function(e){
				e.preventDefault();
				if (e.stopPropagation) {
		            e.stopPropagation();      //阻止事件
		        } else {
		            e.cancelBubble = true;    //IE兼容
		        }
				var LocID = $(this).parent().parent().attr("text");
				$('#ulLoc').val(LocID);
				InitBedChart(obj,LocID,"","","","2");
				return;
			});
			//科室选中逻辑 
			$('#ulLocMX > li').click(function (e) {
				e.preventDefault();
				$('#ulLocMX > li').removeClass('active');
				$(this).addClass("active");
				myLoading();			
				if ($(".Loading_animate_content").length != 0) {
					myLoadingBug();
					$(".Loading_animate_content").css("display","block");
				}
				var txt = $(this,"a").attr("text");  //text
				$('#ulLoc').val(txt);
				//refreshPatList();
				setTimeout(refreshPatList,0.2*1000);  //错开达到异步
				//setTimeout(myLoadHiden,0.3*1000);
				//$("a#2 .bg-red:first").html(val);
			});
			
			//默认选择第一条科室
			$('#ulLocMX li:first-child').click();
		}
		setTimeout(refreshPatList,0.2*1000);  //错开达到异步	
	}
	// 处理科室分组
	function ProcLocGrpData(ArrData){
		//初始化科室组数据(obj.LocGrpData)
		obj.LocGrpData = new Object();
		obj.LocGrpData.LocGrpList = new Array();
		obj.LocGrpData.LocGrpListI = new Array();   // 计数
		// 全院的三个数
		obj.LocGrpData.HospScreeningCnt = 0;
		obj.LocGrpData.HospScreenLogCnt = 0;
		obj.LocGrpData.HospInPatientCnt = 0;
		obj.LocGrpData.HospConfirmCnt   = 0;
		
		for(i=0;i<ArrData.length;i++){
			var LocID        = ArrData[i].LocID;
			var LocDesc      = ArrData[i].LocDesc;        // 科室 
			var ScreeningCnt = ArrData[i].ScreeningCnt;   // 疑似病例
			var ScreenLogCnt = ArrData[i].ScreenLogCnt;   // 处置病例
			var InPatientCnt = ArrData[i].InPatientCnt;   // 住院病人
			var ConfirmCnt   = ArrData[i].ConfirmCnt;   // 住院病人
			var LocGrpUser   = ArrData[i].LocGrpUser;     // 分组负责人
			if (typeof(obj.LocGrpData.LocGrpListI[LocGrpUser]) != 'undefined') {
				var ind = obj.LocGrpData.LocGrpListI[LocGrpUser];
				var objLocGroup = obj.LocGrpData.LocGrpList[ind];
			} else {
				var objLocGroup = {
					LocGrpUser : LocGrpUser,
					ScreeningCnt : 0,
					ScreenLogCnt : 0,
					InPatientCnt : 0,
					ConfirmCnt   : 0,
					LocList : new Array(),
					LocListI : new Array()
				};
				var ind = obj.LocGrpData.LocGrpList.length;
				obj.LocGrpData.LocGrpList[ind] = objLocGroup;
				obj.LocGrpData.LocGrpListI[LocGrpUser] = ind;
			}
			// 科室分组下面的科室
			var objLoc = {
				LocID : LocID,
				LocDesc : LocDesc,
				LocGrpUser : LocGrpUser,
				ScreeningCnt : ScreeningCnt,
				ScreenLogCnt : ScreenLogCnt,
				InPatientCnt : InPatientCnt,
				ConfirmCnt   : ConfirmCnt,
				PatList : new Array()
			};
			var ind = objLocGroup.LocList.length;
			objLocGroup.LocList[ind] = objLoc;
			objLocGroup.LocListI[LocDesc] = ind;
			// 分组累加
			objLocGroup.ScreeningCnt = parseInt(objLocGroup.ScreeningCnt) + parseInt(ScreeningCnt);
			objLocGroup.ScreenLogCnt = parseInt(objLocGroup.ScreenLogCnt) + parseInt(ScreenLogCnt);
			objLocGroup.InPatientCnt = parseInt(objLocGroup.InPatientCnt) + parseInt(InPatientCnt);
			objLocGroup.ConfirmCnt   = parseInt(objLocGroup.ConfirmCnt) + parseInt(ConfirmCnt);
			var ind = obj.LocGrpData.LocGrpListI[LocGrpUser];
			obj.LocGrpData.LocGrpList[ind] = objLocGroup;
			// 全院累加
			obj.LocGrpData.HospScreeningCnt = parseInt(obj.LocGrpData.HospScreeningCnt) + parseInt(ScreeningCnt);
			obj.LocGrpData.HospScreenLogCnt = parseInt(obj.LocGrpData.HospScreenLogCnt) + parseInt(ScreenLogCnt);
			obj.LocGrpData.HospInPatientCnt = parseInt(obj.LocGrpData.HospInPatientCnt) + parseInt(InPatientCnt);
			obj.LocGrpData.HospConfirmCnt   = parseInt(obj.LocGrpData.HospConfirmCnt) + parseInt(ConfirmCnt);
		}
		
		//科室排序
		for(var indLocGroup = 0; indLocGroup < obj.LocGrpData.LocGrpList.length; indLocGroup++)
		{
			var objLocGroup = obj.LocGrpData.LocGrpList[indLocGroup];
			SortLoc(objLocGroup.LocList);
		}
		//分组排序
		SortLocGrp(obj.LocGrpData.LocGrpList);
	}
	
	function SortLoc(array)
	{
		var i = 0, len = array.length,j,d;
		for(; i<len; i++){ 
			for(j=0; j<len; j++){
				if(array[i].LocID > array[j].LocID){  
					d = array[j];  
					array[j] = array[i];  
					array[i] = d;  
				}
			}
		}
		return array;
	}
	
	function SortLocGrp(array)
	{
		var i = 0, len = array.length,j,d;
		for(; i<len; i++){ 
			for(j=0; j<len; j++){
				if(array[i].LocGrpUser > array[j].LocGrpUser){
					d = array[j];
					array[j] = array[i];
					array[i] = d;  
				}
			}
		}
		return array;
	}
	
	//刷新病人列表
	function refreshPatList()
	{
		var status = $("#ulPaadmStatus").val();
		var start =$.form.GetValue("startDT")==""?$.form.GetCurrDate('-'):$.form.GetValue("startDT");    //$.form.GetCurrDate('-')
		var end =$.form.GetValue("endDT")==""?$.form.GetCurrDate('-'):$.form.GetValue("endDT");
		var locID = $("#ulLoc").val();  //科室ID
		$("#MainTable").mCustomScrollbar("destroy");  //滚动条重置
		var IsMessage = $.form.GetValue("chkIsMessage");
		var IsFollow = $.form.GetValue("chkIsFollow");
		var IsFinDel = "";
		var IsFinish = $.form.GetValue("chkIsFinish");
		var IsDelete = $.form.GetValue("chkIsDelete");
		if ((IsFinish==1)&&(IsDelete==0)) {IsFinDel = "1";} //确诊
		if ((IsFinish==0)&&(IsDelete==1)) {IsFinDel = "2";} //排除
		if ((IsFinish==1)&&(IsDelete==1)) {IsFinDel = "3";} //确诊+排除
		
		var IsAttFlg = "";
		var IsScreenAtt = $.form.GetValue("chkIsScreenAtt");
		var IsScreenNoAtt = $.form.GetValue("chkIsScreenNoAtt");
		if ((IsScreenAtt==1)&&(IsScreenNoAtt==0)) {IsAttFlg = "1";} //已关注
		if ((IsScreenAtt==0)&&(IsScreenNoAtt==1)) {IsAttFlg = "2";} //未关注
		if ((IsScreenAtt==1)&&(IsScreenNoAtt==1)) {IsAttFlg = "3";} //已关注+未关注
		
		//清空主区域内容
		$("#divMain").empty();
		
		//1科室、2病区
		var htmlStr = "";
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CCScreeningSrv','QryScreenPatList',status,start,end,locID,IsMessage,IsFollow,IsFinDel,IsAttFlg);
		if (!runQuery) {
			//病人列表查询失败
			htmlStr='<div id ="PaAdm1" class="noresult">'
					+	'<img src="../scripts/dhchai/img/noresult.png"/>'
				    + 	'<p>病人列表查询失败</p>'
				    +'</div>';
			$("#divMain").append(htmlStr);
		} else {
			obj.PatArrData = runQuery.record;
			if (obj.PatArrData.length<1) {
				//无符合条件的记录
				htmlStr='<div id ="PaAdm1" class="noresult">'
						+	'<img src="../scripts/dhchai/img/noresult.png"/>'
				        + 	'<p>无符合条件的记录!<br>选择其他条件试试!</p>'
				        +'</div>';
				$("#divMain").append(htmlStr);
			} else {
				
				//显示疑似病人列表
				for(var indPat = 0; indPat < obj.PatArrData.length; indPat++){
					var objAdm = obj.PatArrData[indPat];
					if (!objAdm) continue;
					
					htmlStr='<div id ="PaAdm' + objAdm.EpisodeID + '" class="panel panel-primary">'
						// 1.病人基本信息
						+ '	<div class="panel-heading">'
						+ '		<div class = "row">'
						+ '			<div class="col-md-12 col-xs-12">'
						+ '			<ul class="list-inline">'
						+ '				<li>'
						+ '		  		<a href="#"  class="tabbtn" style="margin-right:10px;">'
						//+ '			   		<i class="fa fa-star fa-lg ' + (("1"==objAdm.IsNeedAtt) ? "text-yellow" : "text-write") + '" onclick="btnPatAtt_Click(this,' + objAdm.EpisodeID + ')"></i>'
						+ '			   		<i class="fa fa-star fa-lg ' + (("1"==objAdm.IsNeedAtt) ? "text-yellow" : "text-write") + '" name="PatAtt" value="'+ objAdm.EpisodeID +'" ></i>'
						+ '		  		</a>'
						+ '		  		<a  name="MsgSend" value="'+ indPat +'" href="#" class="tabbtn">'
						+ '			   		<i class="fa fa-commenting fa-lg '+ (("1"==objAdm.IsMessage) ? "text-yellow" : "text-write") +'""></i>'
						+ '		  		</a>'
						+ '				</li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>'
						+ '					<span id="txtSuspendDesc' + objAdm.EpisodeID + '" style="font-weight:bold;font-size:120%;">'+objAdm.SuspendDesc+'</span>'
						+ '					<span id="txtSuspendCode' + objAdm.EpisodeID + '" style="display:none;">'+objAdm.SuspendCode+'</span></li>'
						+ '					<span id="txtSuspendCode2' + objAdm.EpisodeID + '" style="display:none;"></span></li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>'+objAdm.PatName+' '+objAdm.RegNo+'</li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>' + ((objAdm.CurrBed != '') ? objAdm.CurrBed : '空床') + '</li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>' + objAdm.Sex + '</li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>' + objAdm.Age + '</li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>' + ((objAdm.OutHospDate != '') ? objAdm.OutHospDate : '') + objAdm.VisitStatus + '</li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>' + objAdm.CurrLocDesc + '</li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>' + objAdm.InHospDate + '入院'+ ((objAdm.InHospLocDesc != objAdm.CurrLocDesc) ? ('('+objAdm.FromLocDesc+')') : '') + '</li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>' + objAdm.InLocDate + '入科' + ((objAdm.FromLocDesc != '') ? ('('+objAdm.FromLocDesc+')') : '') + '</li>'
						+ '				<li class="color-gray-light">|</li>'
						+ '				<li>' + '医生(' + ((objAdm.AdmDocDesc != '') ? objAdm.AdmDocDesc : '') + ')</li>'
						+ '				<li class="color-gray-light"></li>'
						+ '			</ul>'
						+ '			</div>'
						+ '		</div>'
						+ '	</div>'
						
						// 2.疑似病例筛查明细信息
						+ '	<div class="panel-body" style = "padding: 0px;">'
						
						// 2.1疑似筛查确诊排除摘要
						+ '		<div class="tab-button">'
						//+ '		  	<a href="#" onclick="openViewPat_click(\'' + objAdm.EpisodeID + '\')"class="tabbtn btn-me">'
						+ '		  	<a class="tabbtn btn-me" name="openViewPat" value="'+objAdm.EpisodeID+'" href="#"  >'
						+ '				<img src="../scripts/dhchai/img/summary-inf.png"/><span>摘要</span>'
						+ '		  	</a>'
						//+ '			<a class="tabbtn" href="#" onclick="btnOkAll_Click (this,\'' + objAdm.EpisodeID + '\',\'' + objAdm.InHospDate + '\',\'' + objAdm.OutHospDate +  '\')">'
						+ '			<a class="tabbtn" name="btnOkAll" value="'+ objAdm.EpisodeID + ',' + objAdm.InHospDate + ',' + objAdm.OutHospDate +'" href="#" >'
						+ '				<img src="../scripts/dhchai/img/finish.png" /><span>确诊</span>'
						+ '			</a>'
						//+ '			<a class="tabbtn" href="#" onclick="btnDetAll_Click (this,\'' + objAdm.EpisodeID + '\',\'' + objAdm.InHospDate + '\',\'' + objAdm.OutHospDate + '\')">'
						+ '			<a class="tabbtn" name="btnDetAll" value="'+ objAdm.EpisodeID + ',' + objAdm.InHospDate + ',' + objAdm.OutHospDate +'" href="#">'
						+ '				<img src="../scripts/dhchai/img/delete.png"/><span>排除</span>'
						+ '			</a>'
						//+ '			<a class="tabbtn" href="#" onclick="btnEditAll_Click(this,\'' + objAdm.EpisodeID + '\',\'' + objAdm.InHospDate + '\',\'' + objAdm.OutHospDate + '\')">'
						+ '			<a class="tabbtn" name="btnEditAll" value="'+ objAdm.EpisodeID + ',' + objAdm.InHospDate + ',' + objAdm.OutHospDate +'" href="#" >'
						+ '				<img src="../scripts/dhchai/img/edit.png"/><span>感染报告</span>'
						+ '			</a>'
						//+ '			<a class="tabbtn" href="#" onclick="addQuest(\'' + objAdm.EpisodeID + '\',\'1\')">'
						+ '			<a  class="tabbtn" name="addQuest" value="'+objAdm.EpisodeID + ',' +'1'+'" href="#" >'
						+ '				<img src="../scripts/dhchai/img/院感报告.png" /><span>反馈问题</span>'
						+ '			</a>'
						+ '			<a  class="tabbtn" name="addEMR" value="'+objAdm.EpisodeID + '" href="#" >'
						+ '				<img src="../scripts/dhchai/img/院感报告.png" /><span>电子病历</span>'
						+ '			</a>'
						+ '		</div>'
						+ '		<div class = "row">'
						+ '			<div class="col-md-8 col-xs-8">'
						+ '				<div class="panel-heading">'
						+ '					<font color=royalblue>'
						+ '						<span style="font-weight:bold;font-size:100%;"><img src="../scripts/dhchai/img/疑似感染.png"/>&nbsp;疑似诊断：</span>'
						+ '						<span id="txtSusInfDiagnos' + objAdm.EpisodeID + '"></span>'
						+ '					</font>'
						+ '				</div>'
						+ '			</div>'
						+ '			<div class="col-md-4 col-xs-4">'
						+ '				<div class="panel-heading text-right">'
						+ 				'<span style="font-size:100%;">关注原因：</span><span id="txtNeedMsg' + objAdm.EpisodeID + '">' + objAdm.IsNeedMsg + '</span>'
						+ '				</div>'
						+ '			</div>'
						+ '		</div>'
						
						// 2.2疑似筛查指标列表
						+ '		<table id="gridPaAdm' + objAdm.EpisodeID + '" class="table table-bordered" cellspacing="0" width="100%">'
						+ '			<thead>'
						+ '				<tr>'
						+ '					<th style="text-align:center;">序号</th>'
						+ '					<th style="text-align:center;">感染相关指标</th>'
						+ '					<th style="text-align:center;">次数</th>'
						+ '					<th style="text-align:center;">时间</th>'
						+ '					<th style="text-align:center;">天数</th>'
						+ '					<th style="text-align:center;">发热</th>'
						+ '					<th style="text-align:center;">血常规</th>'
						+ '					<th style="text-align:center;"><span class="icontip_span">'
						+ '						<a class="icontip" href="#" data-toggle="tooltip" data-placement="top" title="导尿管"><img src="../scripts/dhchai/img/导尿管.png"/></a>'
						+ '						<a class="icontip" href="#" data-toggle="tooltip" data-placement="top" title="呼吸机"><img src="../scripts/dhchai/img/呼吸机.png"/></a>'
						+ '						<a class="icontip" href="#" data-toggle="tooltip" data-placement="top" title="静脉插管"><img src="../scripts/dhchai/img/静脉插管.png"/></a>'
						+ '					</span></th>'
						+ '					<th style="text-align:center;">隐藏</th>'
						+ '				</tr>'
						+ '				<colgroup>'
						+ '					<col width="4%"></col>'
						+ '					<col width="40%"></col>'
						+ '					<col width="4%"></col>'
						+ '					<col width="25%"></col>'
						+ '					<col width="4%"></col>'
						+ '					<col width="6%"></col>'
						+ '					<col width="8%"></col>'
						+ '					<col width="8%"></col>'
						+ '					<col width="1%"></col>'
				 		+ '				</colgroup>'
						+ '			</thead>'
						+ '			<tbody>'
						+ '			</tbody>'
						+ '		</table>'
						
						// 2.3阳性症状或体征列表
						+ '		<table id="gridInfSymptom' + objAdm.EpisodeID + '" class="table table-bordered" cellspacing="0" width="100%">'
						+ '			<thead>'
						+ '				<tr>'
						+ '					<th style="text-align:center;">序号</th>'
						+ '					<th style="text-align:center;">日期</th>'
						+ '					<th style="text-align:center;">发热记录</th>'
						+ '					<th style="text-align:center;">阳性症状或体征</th>'
						+ '					<th style="text-align:center;">手术/操作</th>'
						+ '					<th style="text-align:center;">隐藏</th>'
						+ '				</tr>'
						+ '				<colgroup>'
						+ '					<col width="4%"></col>'
						+ '					<col width="14%"></col>'
						+ '					<col width="27%"></col>'
						+ '					<col width="27%"></col>'
						+ '					<col width="27%"></col>'
						+ '					<col width="1%"></col>'
				 		+ '				</colgroup>'
						+ '			</thead>'
						+ '			<tbody>'
						+ '			</tbody>'
						+ '		</table>'
						
						// 2.4医院感染报告列表
						+ '		<table id="gridInfDiagnos' + objAdm.EpisodeID + '" class="table table-bordered" cellspacing="0" width="100%">'
						+ '			<thead>'
						+ '				<tr>'
						+ '					<th style="text-align:center;">序号</th>'
						+ '					<th style="text-align:center;">感染诊断</th>'
						+ '					<th style="text-align:center;">类型</th>'
						+ '					<th style="text-align:center;">感染日期</th>'
						+ '					<th style="text-align:center;">转归</th>'
						+ '					<th style="text-align:center;">转归日期</th>'
						+ '					<th style="text-align:center;">操作</th>'
						+ '					<th style="text-align:center;">隐藏</th>'
						+ '				</tr>'
						+ '				<colgroup>'
						+ '					<col width="4%"></col>'
						+ '					<col width="34%"></col>'
						+ '					<col width="10%"></col>'
						+ '					<col width="15%"></col>'
						+ '					<col width="6%"></col>'
						+ '					<col width="15%"></col>'
						+ '					<col width="15%"></col>'
						+ '					<col width="1%"></col>'
				 		+ '				</colgroup>'
						+ '			</thead>'
						+ '			<tbody>'
						+ '			</tbody>'
						+ '		</table>'
						
						+ '	</div>'
						+ '</div>';
					
					$("#divMain").append(htmlStr);
					$(".icontip").tooltip();
				}
				
				obj.EpisScrRstList.CCSList.length = 0;  //清空数组
				for(var indPat = 0; indPat < obj.PatArrData.length; indPat++){
					var objAdm = obj.PatArrData[indPat];
					if (!objAdm) continue;
					refreshRstList(objAdm.EpisodeID,objAdm.InHospDate,objAdm.OutHospDate);
				}
			}
		}	
		
		//移动滚动条
		//$("#MainTable").mCustomScrollbar("scrollTo",[0,0]);
		//$("#MainTable").mCustomScrollbar("scrollTo","top");
		$("#MainTable").mCustomScrollbar({
			theme: "dark-thick",
			axis: "y",
			scrollInertia: 100,
			mouseWheelPixels: 80
		});
		myLoadHiden();
		//setTimeout('$("#MainTable").mCustomScrollbar("scrollTo","top");',2*1000)		
		
		/*****************************IE8下写法***************************/
		$("[name='openViewPat']").on('click', function(e){
			obj.openViewPat_click($(this).attr("value"));
		});
 		$("[name='MsgSend']").on('click', function(e){
			obj.btnMsgSend_Click(this,$(this).attr("value"));
		});
		$("[name='PatAtt']").on('click', function(e){
			obj.btnPatAtt_Click(this,$(this).attr("value"));
		});
		$("[name='btnOkAll']").on('click', function(e){
			var ArgString =$(this).attr("value");
			var EpisodeID=ArgString.split(",")[0];
			var InHospDate=ArgString.split(",")[1];
			var OutHospDate=ArgString.split(",")[2];
			obj.btnOkAll_Click(this,EpisodeID,InHospDate,OutHospDate);
		});
		$("[name='btnDetAll']").on('click', function(e){
			var ArgString =$(this).attr("value");
			var EpisodeID=ArgString.split(",")[0];
			var InHospDate=ArgString.split(",")[1];
			var OutHospDate=ArgString.split(",")[2];
			obj.btnDetAll_Click(this,EpisodeID,InHospDate,OutHospDate);
		});
		$("[name='btnEditAll']").on('click', function(e){
			var ArgString =$(this).attr("value");
			var EpisodeID=ArgString.split(",")[0];
			var InHospDate=ArgString.split(",")[1];
			var OutHospDate=ArgString.split(",")[2];
			obj.btnEditAll_Click(this,EpisodeID,InHospDate,OutHospDate);
		});
		$("[name='addQuest']").on('click', function(e){
			var ArgString =$(this).attr("value");
			var EpisodeID=ArgString.split(",")[0];
			var TypeCode=ArgString.split(",")[1];
			addQuest(EpisodeID,TypeCode);
		});
		$("[name='addEMR']").on('click', function(e){
			var ArgString =$(this).attr("value");
			var EpisodeID=ArgString.split(",")[0];			
			QryEMR(EpisodeID);
		});
	    /*****************************************************************/
	}
	//查看电子病历
	function QryEMR(EpisodeID)
	{
		//根据数据中心ID取His值
		var rst = $.Tool.RunServerMethod("DHCHAI.DPS.PAAdmSrv","GetPaAdmHISx",EpisodeID);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var url = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&2=2';
		//var url = '../csp/emr.record.browse.csp?PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&2=2';
		parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:1,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
	}
	/*****************IE8下写法***************************/
	obj.openViewPat_click = function(aEpisodeID)
	{
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+aEpisodeID+'&1=1';
		parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
	};
	obj.btnMsgSend_Click = function(el,admIdx)
	{
		obj.selIdx = admIdx;
		var objAdm = obj.PatArrData[obj.selIdx];
		var url = "../csp/dhchai.ir.ccmessage.csp?EpisodeDr=" + objAdm.EpisodeID + "&PageType=layerOpen&MsgType=1";
		obj.idxLayerMsg = layer.open({
			type: 2,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
			maxmin: false,
			title: [objAdm.CurrLoc+"-"+objAdm.PatName,"text-align:center;background-color: #4C9CE4;color:#fff"], 
			area: ['800px','500px'],
			content: [url,'no']
		});
	};
	
	obj.btnPatAtt_Click = function(el,aEpisodeID)
	{
		//切换样式
		var $this = $(el);
		var write = $this.hasClass("text-write");
		$.form.SetValue('cboIsNeedAtt',""); //初始化原因输入框
		$.form.SelectRender("#cboFollowReason");  //渲染下拉框
		//  默认选中其他
		$.form.SetValue("cboFollowReason",$("#cboFollowReason>option:nth-child(2)").val(),$("#cboFollowReason>option:nth-child(2)").text());
		if (write) {
			//需关注
			layer.open({
				type: 1,
				zIndex: 100,
				area: ['400px','220px'],
				title: '需关注原因', 
				content: $('#LayerIsNeedAtt'),
				btn: ['保存','关闭'],
				btnAlign: 'c',
				yes: function(index, layero){
					var retval = obj.LayerAtt_Save(aEpisodeID,1);
					if (parseInt(retval)>0){
						if ($.form.GetValue("cboIsNeedAtt") == "") {
							var input = $.form.GetText("cboFollowReason");
						} else if ($.form.GetValue("cboFollowReason") == "") {
							var input = $.form.GetValue("cboIsNeedAtt");
						} else {
							var input = $.form.GetText("cboFollowReason") + ',' + $.form.GetValue("cboIsNeedAtt");
						}
						$("#txtNeedMsg"+aEpisodeID).html(input);
						$this.toggleClass("text-write");
						$this.toggleClass("text-yellow");
						layer.msg('关注成功!',{time: 2000,icon: 1});
						layer.close(index);
					}
				}
			});
		} else {
			//取消关注
			var retval=obj.LayerAtt_Save(aEpisodeID,0);
			if (parseInt(retval)>0){
				$this.toggleClass("text-yellow");
				$this.toggleClass("text-write");
				$("#txtNeedMsg"+aEpisodeID).html("");
				layer.msg('取消关注成功!',{time: 2000,icon: 1});
			}
		}
	};
	
	//全部确诊
	obj.btnOkAll_Click = function(el,aEpisodeDr,aInHospDate,aOutHospDate)
	{
	
		var Count=0;
		var arrResult = obj.EpisScrRstList.CCSList[aEpisodeDr];
		for (var indRst = 0; indRst < arrResult.length; indRst++){
			var row = arrResult[indRst];
			if (!row) return;
			//if (row.RstStatus !== '0') continue;  //0未处理、1已处理
			//if ((row.OprStatus !== '0')&&(row.OprStatus !== '1')) continue;  //0未操作、1确诊、2排除
			if (row.OprStatus == '1') continue;
			
			var ScreenInfo = row.ItmScreenID;      //疑似筛查项目
			ScreenInfo += '^' + row.ItmScreenTxt;  //疑似筛查文本
			ScreenInfo += '^' + row.RstFromDate;   //疑似开始日期
			ScreenInfo += '^' + row.RstToDate;     //疑似结束日期
			ScreenInfo += '^' + '';                //疑似诊断
			ScreenInfo += '^' + "";                //疑似处置意见
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreeningSrv","SaveScreenOpera",aEpisodeDr,ScreenInfo,1,$.LOGON.USERID);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				Count++;
			}			
		}
		if (parseInt(Count)>0){
			layer.msg('确诊失败!',{icon: 2});
			return;
		} else {
			layer.msg('确诊成功!',{icon: 1,time:5000});
			$(".tab-button .tabbtn").mouseleave(function(){
				$(".tab-button .tabbtn").css("background-color","#FFFFFF");
			});
			$(".tab-button .tabbtn").focus(function(){
				$(".tab-button .tabbtn:focus").css("background-color","#B0E0E6");
			});
			$(".tab-button .tabbtn").click(function(){
				$(".tab-button .tabbtn:focus").css("background-color","#B0E0E6");
			}); 
			//处理疑似状态及处置状态（待处理、已确诊、已排除、已上报）
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreenAttSrv","UpdateSusInfFlag",aEpisodeDr);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				layer.msg('处置状态更新失败!',{icon: 2});
			} else {
				var txtSuspendCode2=$("#txtSuspendCode" + aEpisodeDr).html();
				$("#txtSuspendCode2" + aEpisodeDr).html(txtSuspendCode2);
				$("#txtSuspendCode" + aEpisodeDr).html(rstArr[2]);
				$("#txtSuspendDesc" + aEpisodeDr).html(rstArr[3]);
			}
			
			//刷新疑似筛查结果列表
			refreshRstList(aEpisodeDr,aInHospDate,aOutHospDate);
		}
		
		var $this = $(el);
		refreshCnt(aEpisodeDr);  //计数更新
	};
	
	//排除
	obj.btnDetAll_Click = function(el,aEpisodeDr,aInHospDate,aOutHospDate)
	{
		var Count=0;
		var arrResult = obj.EpisScrRstList.CCSList[aEpisodeDr];
		for (var indRst = 0; indRst < arrResult.length; indRst++){
			var row = arrResult[indRst];
			if (!row) return;
			//if (row.RstStatus !== '0') continue;  //0未处理、1已处理
			//if ((row.OprStatus !== '0')&&(row.OprStatus !== '2')) continue;  //0未操作、1确诊、2排除
			if (row.OprStatus == '2') continue;
			
			var ScreenInfo = row.ItmScreenID;      //疑似筛查项目
			ScreenInfo += '^' + row.ItmScreenTxt;  //疑似筛查文本
			ScreenInfo += '^' + row.RstFromDate;   //疑似开始日期
			ScreenInfo += '^' + row.RstToDate;     //疑似结束日期
			ScreenInfo += '^' + '';                //疑似诊断
			ScreenInfo += '^' + "";                //疑似处置意见
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreeningSrv","SaveScreenOpera",aEpisodeDr,ScreenInfo,2,$.LOGON.USERID);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				Count++;
			}
		}
		if (parseInt(Count)>0){
			layer.msg('排除失败!',{icon: 2});
			return;
		} else {
			layer.msg('排除成功!',{icon: 1});
			
			//处理疑似状态及处置状态（待处理、已确诊、已排除、已上报）
			var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreenAttSrv","UpdateSusInfFlag",aEpisodeDr);
			var rstArr = retval.split("^");
			if (parseInt(rstArr[0])<1){
				layer.msg('处置状态更新失败!',{icon: 2});
			} else {
				var txtSuspendCode2=$("#txtSuspendCode" + aEpisodeDr).html();
				$("#txtSuspendCode2" + aEpisodeDr).html(txtSuspendCode2);
				$("#txtSuspendCode" + aEpisodeDr).html(rstArr[2]);
				$("#txtSuspendDesc" + aEpisodeDr).html(rstArr[3]);
			}
			
			//刷新疑似筛查结果列表
			refreshRstList(aEpisodeDr,aInHospDate,aOutHospDate);
		}
		
		var $this = $(el);
		refreshCnt(aEpisodeDr);  //计数更新
	};
	obj.btnEditAll_Click = function(el,aEpisodeDr,aInHospDate,aOutHospDate)
	{
		
		obj.selIdx = aEpisodeDr;  //主表下标
		obj.InfDiagnosDr = ''; //感染诊断记录指针
		var NewBabyFlg = $.Tool.RunServerMethod("DHCHAI.DP.PAAdm","GetNewBabyById",aEpisodeDr);
		if (NewBabyFlg=="1"){
			obj.winOpenNewInfReport(aEpisodeDr);
		}else{
			obj.winOpenInfReport(aEpisodeDr);
		}
		//obj.LayerInfRep(aInHospDate,aOutHospDate);	//弹出窗
	};
	/**************************************************************/
	//刷新疑似筛查记录
	function refreshRstList(aEpisodeDr,aInHospDate,aOutHospDate)
	{
		//加载疑似筛查项目明细
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CCScreeningSrv','QryScreenResult',aEpisodeDr);
		if (runQuery) {
			var arrResult = runQuery.record;
			
			var arrSusInfDiagnos = {};
			for (var indRst=0; indRst<arrResult.length; indRst++){
				var rd = arrResult[indRst];
				if (!rd["InfPosDesc"]) continue;
				var txtSusInfDiagnos = rd["InfPosDesc"] ;
				
				var arrSI = txtSusInfDiagnos.split(';');
				for (var indSI = 0;  indSI < arrSI.length; indSI++){
					var tSusInfDiagnos = arrSI[indSI];
					if (!tSusInfDiagnos) continue;
					if (typeof(arrSusInfDiagnos[tSusInfDiagnos]) == 'undefined'){
						arrSusInfDiagnos[tSusInfDiagnos] = 1;
					}
				}
			}
			var txtSusInfDiagnos = '';
			for (var indV in arrSusInfDiagnos){
				txtSusInfDiagnos += indV + '；'
			}
			$("#txtSusInfDiagnos" + aEpisodeDr).html(txtSusInfDiagnos);
			
			//obj.EpisScrRstList.CCSList 全局变量数组
			obj.EpisScrRstList.CCSList[aEpisodeDr] = new Array();
			obj.EpisScrRstList.CCSList[aEpisodeDr] = arrResult;
			$('#gridPaAdm' + aEpisodeDr).DataTable().destroy();
			var table = $('#gridPaAdm' + aEpisodeDr).DataTable({
				dom: 'rt'
				,paging: false
				,ordering: true
				,info: true
				,data:arrResult
				,order: [[3, 'desc']]  //按日期排序
				,columns: [
					{"data": null,"targets": 0,orderable: false, width: "4%"},
					// update by zf 20180104 去掉每一条的疑似诊断
					//{ "data": "InfPosDesc",orderable: false },
					{ "data": "ResultNote" ,orderable: false},
					{ "data": "ResultCnt",orderable: false },
					{ "data": "ResultDate" ,orderable: false},
					{ "data": "ResultDays" ,orderable: false},
					{ "data": "FeverDays" ,orderable: false},
					{ "data": "TestAbTimes" ,orderable: false},
					{ "data": null,orderable: false,
						render: function(data,type,row)
						{
							return data.OEUCIntuDays + "/" + data.OEVAPIntuDays + "/" + data.OEPICCIntuDays
						}
					},
					/* update by zf 20180104 去掉每一条的确诊和排除
					{
						"data": "OprStatus",orderable: false,
						 render: function ( data, type, row ) {
							var editHtml="";
							if (row.RstStatus=='1'){
								//疑似筛查指标（敏感性+特异性）
								var ArgStr = row.ItmScreenID + "^" + row.ItmScreenTxt + "^" + row.RstFromDate + "^" + row.RstToDate;
								if(data=="0") {  // 未操作，可确认可排除
									editHtml += '<a href="#" class="editor_edit" onclick="btnCCItemOk_Click(this,\''+aEpisodeDr+'\',\''+ ArgStr+'\',\''+ aInHospDate+'\',\''+ aOutHospDate+'\');return false;">确诊</a>'
									editHtml += '&nbsp;&nbsp;'
									editHtml += '<a href="#" class="editor_del" onclick="btnCCItemDel_Click(this,\''+aEpisodeDr+'\',\''+ ArgStr+'\',\''+ aInHospDate+'\',\''+ aOutHospDate+'\');return false;">排除</a>';
								} else if ((data=="1")||(data=="-1")) {  // 已确认，可排除
									editHtml += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
									editHtml += '<a href="#" class="editor_del" onclick="btnCCItemDel_Click(this,\''+aEpisodeDr+'\',\''+ ArgStr+'\',\''+ aInHospDate+'\',\''+ aOutHospDate+'\');return false;">排除</a>';
								} else if ((data=="2")||(data=="-2")) {  // 已排除，可确认
									editHtml += '<a href="#" class="editor_edit" onclick="btnCCItemOk_Click(this,\''+aEpisodeDr+'\',\''+ ArgStr+'\',\''+ aInHospDate+'\',\''+ aOutHospDate+'\');return false;">确诊</a>';
									editHtml += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
								} else {
									var ArgStr = row.ItmScreenID + "^" + row.ItmScreenTxt + "^" + row.RstFromDate + "^" + row.RstToDate;
									alert(ArgStr+"///"+data+"///"+row.RstStatus);
								}
							} else {
								var ArgStr = row.ItmScreenID + "^" + row.ItmScreenTxt + "^" + row.RstFromDate + "^" + row.RstToDate;
								alert(ArgStr+"///"+data+"///"+row.RstStatus);
								//非疑似筛查指标（组合条件不满足）
							}
							return editHtml;
						}
					},
					*/
					{data:null, visible: false}
				]
				,"createdRow": function ( row, data, index ) {
					
					if(data.OprStatus=="0")
					{
						
						$('td',row).eq(1).removeClass("text-black");
						$('td',row).eq(1).removeClass("text-gray");
						$('td',row).eq(1).addClass("text-red");
						$('td',row).eq(2).removeClass("text-black");
						$('td',row).eq(2).removeClass("text-gray");
						$('td',row).eq(2).addClass("text-red");
					}
					else if(data.OprStatus=="1"){
						$('td',row).eq(1).removeClass("text-gray");
						$('td',row).eq(1).removeClass("text-red");
						$('td',row).eq(1).addClass("text-black");
						$('td',row).eq(2).removeClass("text-gray");
						$('td',row).eq(2).removeClass("text-red");
						$('td',row).eq(2).addClass("text-black");
					}
					else if(data.OprStatus=="2"){
						$('td',row).eq(1).removeClass("text-black");
						$('td',row).eq(1).removeClass("text-red");
						$('td',row).eq(1).addClass("text-gray");
						$('td',row).eq(2).removeClass("text-black");
						$('td',row).eq(2).removeClass("text-red");
						$('td',row).eq(2).addClass("text-gray");
					}
				}
				,"fnDrawCallback": function(){
				　　var api = this.api();
				　　var startIndex= api.context[0]._iDisplayStart;//获取到本页开始的条数
				　　api.column(0).nodes().each(function(cell, i) {
				　　　　cell.innerHTML = startIndex + i + 1;
				　　});
				}
			});
		}
		
		//加载阳性症状或体征信息
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CCScreeningSrv','QryINFSymptom',aEpisodeDr);
		if (runQuery) {
			var arrResult = runQuery.record;
			
			$('#gridInfSymptom' + aEpisodeDr).DataTable().destroy();
			var table = $('#gridInfSymptom' + aEpisodeDr).DataTable({
				dom: 'rt',
				paging: false,
				ordering: true,
				info: true,
				data:arrResult
				,order: [[1, 'desc']]
				,columns: [
					{"data": null,"targets": 0,orderable: false},
					{ "data": "ActDate" ,orderable: false},
					{ "data": "FeResult" ,orderable: false},
					{ "data": "SxResult" ,orderable: false},
					{ "data": "OpResult" ,orderable: false},
					{data:null, visible: false}
				]
				,"createdRow": function ( row, data, index ) {
					//颜色处理
				}
				,"fnDrawCallback": function(){
				　　var api = this.api();
				　　var startIndex= api.context[0]._iDisplayStart;//获取到本页开始的条数
				　　api.column(0).nodes().each(function(cell, i) {
				　　　　cell.innerHTML = startIndex + i + 1;
				　　});
				}
			});
		}
		
		//加载感染诊断信息
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CCScreeningSrv','QryINFDiagnos',aEpisodeDr);
		if (runQuery) {
			var arrResult = runQuery.record;
			
			//obj.EpisScrRstList.INFList 全局变量数组
			obj.EpisScrRstList.INFList[aEpisodeDr] = new Array();
			obj.EpisScrRstList.INFList[aEpisodeDr] = arrResult;
			$('#gridInfDiagnos' + aEpisodeDr).DataTable().destroy();
			var table = $('#gridInfDiagnos' + aEpisodeDr).DataTable({
				dom: 'rt',
				paging: false,
				ordering: true,
				info: true,
				data:arrResult
				,order: [[7, 'desc']]
				,columns: [
					{"data": null,"targets": 0,orderable: false},
					{ "data": "InfDiagnos" ,orderable: false},
					{ "data": "DiagnosType" ,orderable: false},
					{ "data": "InfDate" ,orderable: false},
					{ "data": "InfEffect" ,orderable: false},
					{ "data": "InfXDate",orderable: false },
					{
						"data": null,orderable: false,
						 render: function ( data, type, row ) {
							var editHtml="";
							var ArgStr = row.ID;
							if (row.DiagnosType=='报告诊断'){  // 已报告，可编辑、不可删除
								editHtml += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
								//editHtml += '<a href="#" class="editor_del" onclick="btnCCItemEditDiag_Click(this,\''+aEpisodeDr+'\',\''+ ArgStr+'\');return false;">编辑</a>';
								editHtml += '<a href="#" class="editor_edit" value="'+aEpisodeDr+','+ ArgStr+'">编辑</a>';
							} else if (row.DiagnosType=='确诊诊断') {  // 未报告，可编辑，可删除
								//editHtml += '<a href="#" class="editor_edit" onclick="btnCCItemEditDiag_Click(this,\''+aEpisodeDr+'\',\''+ ArgStr+'\',\''+ aInHospDate+'\',\''+ aOutHospDate+'\');return false;">编辑</a>'
								editHtml += '<a href="#" class="editor_edit" value="'+aEpisodeDr+','+ ArgStr+','+ aInHospDate+','+ aOutHospDate+'">编辑</a>'
								editHtml += '&nbsp;&nbsp;'
								//editHtml += '<a href="#" class="editor_del" onclick="btnCCItemDelDiag_Click(this,\''+aEpisodeDr+'\',\''+ ArgStr+'\');return false;">删除</a>';
								editHtml += '<a href="#" class="editor_del" value="'+aEpisodeDr+','+ ArgStr+'">删除</a>';
							}
							return editHtml;
						}
					},
					{data:null, visible: false}
				]
				,"createdRow": function ( row, data, index ) {
					//颜色处理
				}
				,"fnDrawCallback": function(){
				　　var api = this.api();
				　　var startIndex= api.context[0]._iDisplayStart;//获取到本页开始的条数
				　　api.column(0).nodes().each(function(cell, i) {
				　　　　cell.innerHTML = startIndex + i + 1;
				　　});
				}
			});
		}
		/*****************************IE8下写法********************************/
		$('#gridInfDiagnos' + aEpisodeDr).off("click");
		$('#gridInfDiagnos' + aEpisodeDr).on('click','a.editor_edit', function (e) {		
			e.preventDefault();
			var ArgString =$(this).attr("value");
			var ArgStr=ArgString.split(",")[1];
			obj.selIdx = aEpisodeDr;  //主表下标
			obj.InfDiagnosDr = ArgStr; //感染诊断记录指针
			//obj.LayerInfRep();
			obj.LayerInfRep(aInHospDate,aOutHospDate);
			
		});
        $('#gridInfDiagnos' + aEpisodeDr).on('click','a.editor_del', function (e) {
			e.preventDefault();
			var ArgString =$(this).attr("value");
			var ArgStr=ArgString.split(",")[1];
			var InfDiagnosDr = ArgStr; //感染诊断记录指针
			var retval = $.Tool.RunServerMethod("DHCHAI.IR.INFDiagnos","DeleteById",InfDiagnosDr);
			if (parseInt(retval)<0){
				if (parseInt(retval)==-2){
					layer.msg('存在关联院感报告不允许删除!',{icon: 2});
					return;
				}
				layer.msg('删除失败!',{icon: 2});
				return;
			} else {
				layer.msg('删除成功!',{icon: 1});
				refreshRstList(aEpisodeDr,"","");
			}
		});	
        /**********************************************************************************/
		
	}
	
	function refreshCnt(aEpisodeDr)
	{
		//科室ID
		var pID = $('#ulLoc').val();
		
		//当前患者处置状态
		var txtSuspendCode = $("#txtSuspendCode" + aEpisodeDr).html();
		var txtSuspendCode2 = $("#txtSuspendCode2" + aEpisodeDr).html();
		//debugger
		if (obj.LocGroupFlg=="1"){
			//待处理-->确诊
			if (parseInt(txtSuspendCode2)==0) {
				//待处理-1
				var cnt = $("a#Loc"+pID+" .bg-red:first").html();
				var cntQY = $("a#LocQY .bg-red:first").html();
				var cntLocSubGrp = $("a#Loc"+pID).parents('.loc-sub').prev().find(".bg-red").html();
				cnt = parseInt(cnt)-1;
				cntQY = parseInt(cntQY)-1;
				cntLocSubGrp = parseInt(cntLocSubGrp)-1;
				$("a#Loc"+pID+" .bg-red:first").html(cnt);
				$("a#LocQY .bg-red:first").html(cntQY);
				$("a#Loc"+pID).parents('.loc-sub').prev().find(".bg-red").html(cntLocSubGrp);
				//已处理+1,已确诊+1
				var cntQR = $("a#Loc"+pID+" .bg-green:first").html();
				var cntQR0 = cntQR.split('/')[0];
				var cntQR1 = cntQR.split('/')[1];
				var cntQYQR = $("a#LocQY .bg-green:first").html();
				var cntQYQR0 = cntQYQR.split('/')[0];
				var cntQYQR1 = cntQYQR.split('/')[1];
				var cntLocSubGrpQR = $("a#Loc"+pID).parents('.loc-sub').prev().find(".bg-green").html();
				var cntLocSubGrpQR0 = cntLocSubGrpQR.split('/')[0];
				var cntLocSubGrpQR1 = cntLocSubGrpQR.split('/')[1];
				
				if (parseInt(txtSuspendCode)==1) {  //已确诊病例
					cntQR0 = parseInt(cntQR0) + 1;
					cntQYQR0 = parseInt(cntQYQR0) + 1;
					cntLocSubGrpQR0 = parseInt(cntLocSubGrpQR0) + 1;
				}
				cntQR1 = parseInt(cntQR1) + 1;
				cntQYQR1 = parseInt(cntQYQR1) + 1;
				cntLocSubGrpQR1 = parseInt(cntLocSubGrpQR1) + 1;
				$("a#Loc"+pID+" .bg-green:first").html(cntQR0 + '/' + cntQR1);
				$("a#LocQY .bg-green:first").html(cntQYQR0 + '/' + cntQYQR1);
				$("a#Loc"+pID).parents('.loc-sub').prev().find(".bg-green").html(cntLocSubGrpQR0 + '/' + cntLocSubGrpQR1);
			} else {
				//已确诊-->排除
				if ((parseInt(txtSuspendCode2)==1)&&(parseInt(txtSuspendCode)!=1)){
					//已确诊-1
					var cntQR = $("a#Loc"+pID+" .bg-green:first").html();
					var cntQR0 = cntQR.split('/')[0];
					var cntQR1 = cntQR.split('/')[1];
					var cntQYQR = $("a#LocQY .bg-green:first").html();
					var cntQYQR0 = cntQYQR.split('/')[0];
					var cntQYQR1 = cntQYQR.split('/')[1];
					cntQR0 = parseInt(cntQR0) - 1;
					cntQYQR0 = parseInt(cntQYQR0) - 1;
					cntQR1 = parseInt(cntQR1);
					cntQYQR1 = parseInt(cntQYQR1);
					$("a#Loc"+pID+" .bg-green:first").html(cntQR0 + '/' + cntQR1);
					$("a#LocQY .bg-green:first").html(cntQYQR0 + '/' + cntQYQR1);
				}
				//已排除-确诊
				if ((parseInt(txtSuspendCode2)==2)&&(parseInt(txtSuspendCode)!=2)){
					//已确诊+1
					var cntQR = $("a#Loc"+pID+" .bg-green:first").html();
					var cntQR0 = cntQR.split('/')[0];
					var cntQR1 = cntQR.split('/')[1];
					var cntQYQR = $("a#LocQY .bg-green:first").html();
					var cntQYQR0 = cntQYQR.split('/')[0];
					var cntQYQR1 = cntQYQR.split('/')[1];
					cntQR0 = parseInt(cntQR0) + 1;
					cntQYQR0 = parseInt(cntQYQR0) + 1;
					cntQR1 = parseInt(cntQR1);
					cntQYQR1 = parseInt(cntQYQR1);
					$("a#Loc"+pID+" .bg-green:first").html(cntQR0 + '/' + cntQR1);
					$("a#LocQY .bg-green:first").html(cntQYQR0 + '/' + cntQYQR1);
				}
			}
		} else {
			//待处理-->确诊
			if (parseInt(txtSuspendCode2)==0) {
				//待处理-1
				var cnt = $("a#Loc"+pID+" .bg-red:first").html();
				var cntQY = $("a#LocQY .bg-red:first").html();
				cnt = parseInt(cnt)-1;
				cntQY = parseInt(cntQY)-1;
				$("a#Loc"+pID+" .bg-red:first").html(cnt);
				$("a#LocQY .bg-red:first").html(cntQY);
				//已处理+1,已确诊+1
				var cntQR = $("a#Loc"+pID+" .bg-green:first").html();
				var cntQR0 = cntQR.split('/')[0];
				var cntQR1 = cntQR.split('/')[1];
				var cntQYQR = $("a#LocQY .bg-green:first").html();
				var cntQYQR0 = cntQYQR.split('/')[0];
				var cntQYQR1 = cntQYQR.split('/')[1];
				if (parseInt(txtSuspendCode)==1) {  //已确诊病例
					cntQR0 = parseInt(cntQR0) + 1;
					cntQYQR0 = parseInt(cntQYQR0) + 1;
				}
				cntQR1 = parseInt(cntQR1) + 1;
				cntQYQR1 = parseInt(cntQYQR1) + 1;
				$("a#Loc"+pID+" .bg-green:first").html(cntQR0 + '/' + cntQR1);
				$("a#LocQY .bg-green:first").html(cntQYQR0 + '/' + cntQYQR1);
			} else {
				//已确诊-->排除
				if ((parseInt(txtSuspendCode2)==1)&&(parseInt(txtSuspendCode)!=1)){
					//已确诊-1
					var cntQR = $("a#Loc"+pID+" .bg-green:first").html();
					var cntQR0 = cntQR.split('/')[0];
					var cntQR1 = cntQR.split('/')[1];
					var cntQYQR = $("a#LocQY .bg-green:first").html();
					var cntQYQR0 = cntQYQR.split('/')[0];
					var cntQYQR1 = cntQYQR.split('/')[1];
					cntQR0 = parseInt(cntQR0) - 1;
					cntQYQR0 = parseInt(cntQYQR0) - 1;
					cntQR1 = parseInt(cntQR1);
					cntQYQR1 = parseInt(cntQYQR1);
					$("a#Loc"+pID+" .bg-green:first").html(cntQR0 + '/' + cntQR1);
					$("a#LocQY .bg-green:first").html(cntQYQR0 + '/' + cntQYQR1);
				}
				//已排除-->确诊
				if ((parseInt(txtSuspendCode2)==2)&&(parseInt(txtSuspendCode)!=2)){
					//已确诊+1
					var cntQR = $("a#Loc"+pID+" .bg-green:first").html();
					var cntQR0 = cntQR.split('/')[0];
					var cntQR1 = cntQR.split('/')[1];
					var cntQYQR = $("a#LocQY .bg-green:first").html();
					var cntQYQR0 = cntQYQR.split('/')[0];
					var cntQYQR1 = cntQYQR.split('/')[1];
					cntQR0 = parseInt(cntQR0) + 1;
					cntQYQR0 = parseInt(cntQYQR0) + 1;
					cntQR1 = parseInt(cntQR1);
					cntQYQR1 = parseInt(cntQYQR1);
					$("a#Loc"+pID+" .bg-green:first").html(cntQR0 + '/' + cntQR1);
					$("a#LocQY .bg-green:first").html(cntQYQR0 + '/' + cntQYQR1);
				}
			}
		}
		
		var status = $("#ulPaadmStatus").val();
		if (status !='3') { //已处理页签下的病人列表不需要移除
			if ((parseInt(cnt)<1)&&(parseInt(cntQR0)<1)){
				//清空主区域内容
				$("#divMain").empty();
				//无符合条件的记录
				htmlStr='<div id ="PaAdm1" class="noresult">'
						+	'<img src="../scripts/dhchai/img/noresult.png"/>'
						+ 	'<p>已处理完本科室数据!<br>选择其他科室继续吧!</p>'
						+'</div>';		
				$("#divMain").append(htmlStr);
			} else {
				//清空处理完患者
				if (parseInt(txtSuspendCode)!=1) {  //非确诊病例
					$("#PaAdm"+aEpisodeDr).remove();
				}
			}
		}
	}
	function myLoading() {
		if ($(".Loading_animate_content").length != 0) {
			if ($(".Loading_animate_bg").length == 0) {
				var html = '<div class="Loading_animate_bg">'
				    +'<div class="loading">'
					+	'<img src="../scripts/dhchai/img/loading.gif"/>'
				    +'</div>'
				    +'</div>'
					+ '<div class="Loading_animate_font">加载中...</div>';
					$(".Loading_animate_content").append(html);
			}
		}
	}
	function myLoadingBug() {		
		$('.Loading_animate_bg').css({ height: $(document).height() });
		$('.Loading_animate_font').css({ left: ($(document).width() - 36) / 2 });
	}
	function myLoadHiden()
	{
		if ($(".Loading_animate_content").length != 0) {
			$(".Loading_animate_content").css("display", "none");
			$(".Loading_animate_font").text("加载中...");
		}
	}
	
	obj.winOpenInfReport = function(aEpisodeID)
	{
		if (!aEpisodeID) return;
		var url="dhcma.hai.ir.inf.report.csp?1=1&EpisodeID="+aEpisodeID+'&AdminPower='+ obj.AdminPower+"&2=2";
		websys_showModal({
			url:url,
			title:'医院感染报告',
			iconCls:'icon-w-epr',  
			originWindow:window,
			//closable:false,
			width:1320,
			height:'95%',
			onBeforeClose:function(){} 
		});
	}
	obj.winOpenNewInfReport = function(aEpisodeID)
	{
		if (!aEpisodeID) return;
		var url="dhcma.hai.ir.inf.nreport.csp?1=1&EpisodeID="+aEpisodeID+'&AdminPower='+ obj.AdminPower+"&2=2";
		websys_showModal({
			url:url,
			title:'新生儿医院感染报告',
			iconCls:'icon-w-epr',  
			originWindow:window,
			//closable:false,
			width:1320,
			height:'95%',
			onBeforeClose:function(){} 
		});
	}
	obj.LayerInfRep = function(aInHospDate,aOutHospDate)
	{
		obj.layerIdxInfRep = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 100,
				maxmin: false,
				title: "院感信息填写", 
				area: ['620px'],
				content: $('#LayerInfRep'),
				btn: ['保存'],
				btnAlign: 'c',
				yes: function(index, layero){
				  	//保存	
					var text = $.form.GetText("cbopInfPos");
					if (!verifyReport(aInHospDate,aOutHospDate)){
						return;
					};
					var ret = obj.InfRepSave("1","1");
					if (parseInt(ret)>0) {
						//更新表格里的诊断
						/*
						var table = $("#gridPaAdm"+obj.selIdx);
						$('tr',table).each( function (){
							$('td',$(this)).eq(0).html(text);
						});
						*/						
						//setTimeout(refreshRstList(obj.selIdx,aInHospDate,aOutHospDate),1000);
						refreshRstList(obj.selIdx,aInHospDate,aOutHospDate);
						layer.close(index);
					} else {
						layer.msg('保存失败!',{icon: 2});
					}
				},
				success: function(layero,index){
					//展示回调 绑定事件	互斥事件						
					$.form.DateRender("FormVopInfDate","");	
					$.form.DateRender("FormVopIRInfXDate","","top-right");					
					//下拉框动态赋值
					//alert(rd["LocID"]); 列表是病区ID
					$("#cbopInfLoc").data("param",obj.selIdx+"^E");					
					$.form.SelectRender("#cbopInfLoc");
					$.form.SelectRender("#cbopInfPos");
					$("#cbopInfPosSub").data("param","^");	
					$.form.SelectRender("#cbopInfPosSub");
					//$("#cbopInfLoc").val("9").trigger("change"); 
					$("input[name='divpInfEffect']").iCheck('uncheck');   // bug:500370,再次打开该页面，“疾病转归”没有清空
					obj.IRIsReportDiag = 0; // 是否临床上报诊断
					if (obj.InfDiagnosDr !=""){
						//赋值数据
						//retval[0]=obj.IREpisodeDr            // 就诊记录
						//retval[1]=obj.IRInfPosDr             // 感染部位/感染诊断
						//retval[2]=obj.IRInfSubDr             // 感染分类
						//retval[3]=obj.IRInfDate              // 感染日期
						//retval[4]=obj.IRInfLocDr             // 感染科室
						//retval[5]=obj.IRInfDiagnosisBasis    // 诊断依据
						//retval[6]=obj.IRInfDiseaseCourse     // 感染性疾病病程
						//retval[7]=obj.IRInfXDate             // 感染结束日期
						//retval[8]=obj.IRInfEffectDr          // 感染转归/疗效
						//retval[9]=obj.IRDeathRelationDr      // 与死亡关系
						var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.INFDiagnosSrv","GetStrByRowID",obj.InfDiagnosDr);
						
						if (retStr != ''){
							var retval = retStr.split('^');
							if(retval[4])
							{
								$("#cbopInfLoc").val(retval[6]).trigger("change");
							}
							if(retval[5])
							{
								$.form.DateRender("FormVopInfDate",retval[5]);	//可能“,” 分割需要处理
							}
							if(retval[10])
							{
								$.form.DateRender("FormVopIRInfXDate",retval[10],"top-right");
							}
							if(retval[1])
							{
								$("#cbopInfPos").val(retval[1]).trigger("change");
							}
							if(retval[3])
							{
								$("#cbopInfPosSub").val(retval[3]).trigger("change");
							}
							if(retval[11])
							{
								$("#"+retval[11]).iCheck("check");
							}
							obj.IRIsReportDiag = retval[15]		// 是否临床上报诊断
						}
					}
				}
		});		
	};
	// 感染诊断和分类进行关联
	$("#cbopInfPos").change(function(){
		var InfPosID = $.form.GetValue("cbopInfPos");
		$("#cbopInfPosSub").data("param",InfPosID+"^");	
		$.form.SelectRender("#cbopInfPosSub");
	});

	// 报告填写内容控制
	function verifyReport(aInHospDate,aOutHospDate){
		// 感染科室
		if ($.form.GetValue("cbopInfLoc")==''){
    		layer.msg('感染科室不能为空!',{icon: 2});
			return false;
    	}
    	// 感染日期
    	var InfDate = $.form.GetValue("FormVopInfDate");
		if (InfDate==''){
    		layer.msg('感染日期不能为空!',{icon: 2});
			return false;
    	}
		// 感染日期控制在住院期间
		aInHospDate = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",aInHospDate);
		if (aOutHospDate==''){
			aOutHospDate = $.form.GetCurrDate('-');
		}
		aOutHospDate= $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",aOutHospDate);
		var flg1 = $.form.CompareDate(InfDate,aInHospDate);
		var flg2 = $.form.CompareDate(aOutHospDate,InfDate);
		if (flg1&&flg2){
		}else{
			layer.msg('感染日期需要在住院期间!',{icon: 2});
			return false;
		}
		// 感染诊断
		if ($.form.GetValue("cbopInfPos")==''){
    		layer.msg('感染诊断不能为空!',{icon: 2});
			return false;
    	}
    	// 诊断分类
    	if (($("#cbopInfPosSub option").length>1)&&($.form.GetValue("cbopInfPosSub")=='')){
    		layer.msg('诊断分类不能为空!',{icon: 2});
			return false;
    	}
    	// 治愈、死亡、好转都填感染结束日期
    	var InfXDate = $.form.GetValue("FormVopIRInfXDate");
    	var InfEffectDesc ='';
		$("#divpInfEffect input").each( function (){
			if($(this).is(":checked"))
			{
				InfEffectDesc = $(this).parent().parent().text();
			}
		});
		if ((InfEffectDesc.indexOf('治愈')>-1)||(InfEffectDesc.indexOf('死亡')>-1)||(InfEffectDesc.indexOf('好转')>-1)){
			if (InfXDate==''){
				layer.msg('疾病转归为治愈、死亡、好转感染结束日期不能为空!',{icon: 2});
				return false;
			}
		}
    	// 感染结束日期需在住院期间
    	if (InfXDate!=''){
	    	var flg1 = $.form.CompareDate(InfXDate,aInHospDate);
			var flg2 = $.form.CompareDate(aOutHospDate,InfXDate);
			if (flg1&&flg2){
			}else{
				layer.msg('感染结束日期需要在住院期间或超出当前日期!',{icon: 2});
				return false;
			}
	    	// 感染结束日期需要感染日期之后
	    	var flg = $.form.CompareDate(InfXDate,InfDate);
	    	if (!flg){
				layer.msg('感染结束日期需要感染日期之后!',{icon: 2});
				return false;
			}
		}
		return true;
	}
	//感染报告 保存失败返回 小于等于 0
	obj.InfRepSave = function (repType,repStatus)
	{
		var DiasID    = (obj.InfDiagnosDr ? obj.InfDiagnosDr : '');          //感染诊断ID（rd.RepID）
		var Paadm = obj.selIdx;  //就诊号
		
		//保存感染部位信息
		var IRInfPosDr    = $.form.GetValue("cbopInfPos");         //感染（部位）诊断
		var IRInfSubDr    = $.form.GetValue("cbopInfPosSub");      //感染子分类
		var IRInfDate     = $.form.GetValue("FormVopInfDate");     //感染日期
		var IRInfLocDr    = $.form.GetValue("cbopInfLoc");         //感染科室
		var IRInfXDate    = $.form.GetValue("FormVopIRInfXDate");  //感染结束日期
		var IRInfEffectDr = "";                                    //转归情况
		$("#divpInfEffect input").each( function (){
			if($(this).is(":checked")){
				IRInfEffectDr = $(this).attr("id");
			}
		});
		
		var InputInfDiag = DiasID;
		InputInfDiag += "^" + Paadm;
		InputInfDiag += "^" + IRInfPosDr; 
		InputInfDiag += "^" + IRInfSubDr;
		InputInfDiag += "^" + IRInfDate;
		InputInfDiag += "^" + IRInfLocDr;
		InputInfDiag += "^" + "";    //IRInfDiagnosisBasis
		InputInfDiag += "^" + "";    //IRInfDiseaseCourse		
		InputInfDiag += "^" + IRInfXDate;
		InputInfDiag += "^" + IRInfEffectDr
		InputInfDiag += "^" + "";   //与死亡关系
		InputInfDiag += "^" + "";
		InputInfDiag += "^" + "";
		InputInfDiag += "^" + $.LOGON.USERID;
		InputInfDiag += "^" + obj.IRIsReportDiag;	// 是否临床上报诊断
		var retinfID = $.Tool.RunServerMethod("DHCHAI.IR.INFDiagnos","Update",InputInfDiag);
		return retinfID;
		
		/* 编辑诊断不保存报告信息
		//感染信息和报告关联
		IRLinkDiags = retinfID;
		
		var IRRepType = "1";   //调查表类型
		var IRRepDate = "";
		var IRRepTime = "";  //报告时间
		var IRRepLocDr = $.LOGON.LOCID;  //调查科室 ？= 当前科室 rd.LocID
		var IRRepUser = $.LOGON.USERID;   //$.LOGON.USERID
		var IRStatusDr = repStatus;
		var IRLinkDiags = "";   // 感染诊断
		var IRLinkICDs = "";    //疾病诊断
		var IRLinkLabs = "";    //IRLinkAntis
		var IRLinkAntis = "";
		var IRLinkOPSs = "";  //
		var IRLinkMRBs = "";
		var IRLinkInvOpers = "";  //
		var IRLinkICUUCs = "";  //
		var IRLinkICUVAPs ="";  //呼吸机
		var IRLinkICUPICCs = "";
		
		var IRDiagnosisBasis =""; //诊断依据
		var IRDiseaseCourse = ""; //
		var IRInLocDr = "";  //入科来源
		var IROutLocDr ="";    //出科方向
		var IRInDate =""; //入科时间
		var IROutDate=""; //出科时间 
		var IRAPACHEScore="";   //APACHEⅡ评分
		var IROutIntubats=""; //出ICU带管情况 List # 分割多个值
		var IROut48Intubats=""; //出ICU48带管情况 list  # 分割多个值
		
		var InputStr = ID;
		InputStr += "^" + Paadm;
		InputStr += "^" + IRRepType;
		InputStr += "^" + IRRepDate;
		InputStr += "^" + IRRepTime;
		InputStr += "^" + IRRepLocDr;
		InputStr += "^" + IRRepUser;  //
		InputStr += "^" + IRStatusDr;
		InputStr += "^" + IRLinkDiags;
		InputStr += "^" + IRLinkICDs;
		InputStr += "^" + IRLinkLabs;
		InputStr += "^" + IRLinkAntis;
		InputStr += "^" + IRLinkOPSs;
		InputStr += "^" + IRLinkMRBs;
		InputStr += "^" + IRLinkInvOpers;
		InputStr += "^" + IRLinkICUUCs;
		InputStr += "^" + IRLinkICUVAPs;
		InputStr += "^" + IRLinkICUPICCs;
		InputStr += "^" + IRDiagnosisBasis;
		InputStr += "^" + IRDiseaseCourse;
		InputStr += "^" + IRInLocDr;
		InputStr += "^" + IRInDate;
		InputStr += "^" + IROutDate;
		InputStr += "^" + IRAPACHEScore;  
		InputStr += "^" + IROutIntubats; 
		InputStr += "^" + IROut48Intubats; 
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.INFReport","Update",InputStr);
		return retval;
		*/
	};
}
