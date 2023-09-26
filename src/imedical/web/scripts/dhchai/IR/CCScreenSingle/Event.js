///页面Event
function InitSingleWinEvent(obj){
	CheckSpecificKey();
	$.form.iCheckRender();  //渲染复选框|单选钮
	
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
	$.form.CheckBoxRender("#divpInfEffect");
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
	
	obj.LoadEvent = function(arguments){
		objPatInfo = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreeningSrv","GetCCScreenByEpisodeID",EpisodeDr);
	    if (objPatInfo=="") {
			// 病人信息加载失败
			htmlStr='<div id ="PaAdm1" class="noresult">'
					+	'<img src="../scripts/dhchai/img/noresult.png"/>'
				    + 	'<p>病人信息加载失败</p>'
				    +'</div>';
			$("#divMain").append(htmlStr);
		} else {
			var indPat=1;
			var PatArray = objPatInfo.split("^");
		    //$.form.SetValue("txtOperDesc",objPatInfo.split("^")[3]);
			htmlStr='<div id ="PaAdm' + PatArray[0] + '" class="panel panel-primary">'
				// 1.病人基本信息
				+ '	<div class="panel-heading">'
				+ '		<div class = "row">'
				+ '			<div class="col-md-12 col-xs-12">'
				+ '			<ul class="list-inline">'
				+ '				<li>'
				+ '		  		<a href="#"  class="tabbtn" style="margin-right:10px;">'
				//+ '			   		<i class="fa fa-star fa-lg ' + (("1"==objAdm.IsNeedAtt) ? "text-yellow" : "text-write") + '" onclick="btnPatAtt_Click(this,' + PatArray[0] + ')"></i>'
				+ '			   		<i class="fa fa-star fa-lg ' + (("1"==PatArray[16]) ? "text-yellow" : "text-write") + '" name="PatAtt" value="'+ PatArray[0] +'" ></i>'
				+ '		  		</a>'
				+ '		  		<a  name="MsgSend" value="'+ PatArray[0]+"^"+ PatArray[2] +"^"+ PatArray[5] +'" href="#" class="tabbtn">'
				+ '			   		<i class="fa fa-commenting fa-lg '+ (("1"==PatArray[23]) ? "text-yellow" : "text-write") +'""></i>'
				+ '		  		</a>'
				+ '				</li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>'
				+ '					<span id="txtSuspendDesc' + PatArray[0] + '" style="font-weight:bold;font-size:120%;">'+PatArray[19]+'</span>'
				+ '					<span id="txtSuspendCode' + PatArray[0] + '" style="display:none;">'+PatArray[18]+'</span></li>'
				+ '					<span id="txtSuspendCode2' + PatArray[0] + '" style="display:none;"></span></li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>'+PatArray[2]+' '+PatArray[1]+'</li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>' + ((PatArray[6] != '') ? PatArray[6] : '空床') + '</li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>' + PatArray[3] + '</li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>' + PatArray[4] + '</li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>' + ((PatArray[17] != '') ? PatArray[17] : '') + PatArray[7] + '</li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>' + PatArray[13] + '</li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>' + PatArray[8] + '入院'+ ((PatArray[10] != PatArray[13]) ? ('('+PatArray[15]+')') : '') + '</li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>' + PatArray[11] + '入科' + ((PatArray[15] != '') ? ('('+PatArray[15]+')') : '') + '</li>'
				+ '				<li class="color-gray-light">|</li>'
				+ '				<li>' + '医生(' + ((PatArray[21] != '') ? PatArray[21] : '') + ')</li>'
				+ '				<li class="color-gray-light"></li>'
				+ '			</ul>'
				+ '			</div>'
				+ '		</div>'
				+ '	</div>'
				
				// 2.疑似病例筛查明细信息
				+ '	<div class="panel-body" style = "padding: 0px;">'
				
				// 2.1疑似筛查确诊排除摘要
				+ '		<div class="tab-button">'
				//+ '		  	<a href="#" onclick="openViewPat_click(\'' + PatArray[0] + '\')"class="tabbtn btn-me">'
				+ '		  	<a class="tabbtn btn-me" name="openViewPat" value="'+PatArray[0]+'" href="#"  >'
				+ '				<img src="../scripts/dhchai/img/summary-inf.png"/><span>摘要</span>'
				+ '		  	</a>'
				//+ '			<a class="tabbtn" href="#" onclick="btnOkAll_Click (this,\'' + PatArray[0] + '\',\'' + PatArray[8] + '\',\'' + PatArray[17] +  '\')">'
				+ '			<a class="tabbtn" name="btnOkAll" value="'+ PatArray[0] + ',' + PatArray[8] + ',' + PatArray[17] +'" href="#" >'
				+ '				<img src="../scripts/dhchai/img/finish.png" /><span>确诊</span>'
				+ '			</a>'
				//+ '			<a class="tabbtn" href="#" onclick="btnDetAll_Click (this,\'' + PatArray[0] + '\',\'' + PatArray[8] + '\',\'' + PatArray[17] + '\')">'
				+ '			<a class="tabbtn" name="btnDetAll" value="'+ PatArray[0] + ',' + PatArray[8] + ',' + PatArray[17] +'" href="#">'
				+ '				<img src="../scripts/dhchai/img/delete.png"/><span>排除</span>'
				+ '			</a>'
				//+ '			<a class="tabbtn" href="#" onclick="btnEditAll_Click(this,\'' + PatArray[0] + '\',\'' + PatArray[8] + '\',\'' + PatArray[17] + '\')">'
				+ '			<a class="tabbtn" name="btnEditAll" value="'+ PatArray[0] + ',' + PatArray[8] + ',' + PatArray[17] +'" href="#" >'
				+ '				<img src="../scripts/dhchai/img/edit.png"/><span>感染报告</span>'
				+ '			</a>'
				//+ '			<a class="tabbtn" href="#" onclick="addQuest(\'' + PatArray[0] + '\',\'1\')">'
				+ '			<a  class="tabbtn" name="addQuest" value="'+PatArray[0] + ',' +'1'+'" href="#" >'
				+ '				<img src="../scripts/dhchai/img/院感报告.png" /><span>反馈问题</span>'
				+ '			</a>'
				+ '			<a  class="tabbtn" name="addEMR" value="'+PatArray[0] + '" href="#" >'
				+ '				<img src="../scripts/dhchai/img/院感报告.png" /><span>电子病历</span>'
				+ '			</a>'
				+ '		</div>'
				+ '		<div class = "row">'
				+ '			<div class="col-md-8 col-xs-8">'
				+ '				<div class="panel-heading">'
				+ '					<font color=royalblue>'
				+ '						<span style="font-weight:bold;font-size:100%;"><img src="../scripts/dhchai/img/疑似感染.png"/>&nbsp;疑似诊断：</span>'
				+ '						<span id="txtSusInfDiagnos' + PatArray[0] + '"></span>'
				+ '					</font>'
				+ '				</div>'
				+ '			</div>'
				+ '			<div class="col-md-4 col-xs-4">'
				+ '				<div class="panel-heading text-right">'
				+ 				'<span style="font-size:100%;">关注原因：</span><span id="txtNeedMsg' + PatArray[0] + '">' + PatArray[22] + '</span>'
				+ '				</div>'
				+ '			</div>'
				+ '		</div>'
				
				// 2.2疑似筛查指标列表
				+ '		<table id="gridPaAdm' + PatArray[0] + '" class="table table-bordered" cellspacing="0" width="100%">'
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
				+ '		<table id="gridInfSymptom' + PatArray[0] + '" class="table table-bordered" cellspacing="0" width="100%">'
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
				+ '		<table id="gridInfDiagnos' + PatArray[0] + '" class="table table-bordered" cellspacing="0" width="100%">'
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
		//refreshRstList(objAdm.EpisodeID,objAdm.InHospDate,objAdm.OutHospDate);
		refreshRstList(PatArray[0],PatArray[8],PatArray[17]);
		
		$("#MainTable").mCustomScrollbar({
			theme: "dark-thick",
			axis: "y",
			scrollInertia: 100,
			mouseWheelPixels: 80
		});
		
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
	};
	
	//查看电子病历
	function QryEMR(EpisodeID)
	{
		//根据数据中心ID取His值
		var rst = $.Tool.RunServerMethod("DHCHAI.DPS.PAAdmSrv","GetPaAdmHISx",EpisodeID);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var url = '../csp/emr.record.browse.csp?PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&2=2';
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:1,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"病历浏览",1);
	}
	/*****************IE8下写法***************************/
	obj.openViewPat_click = function(aEpisodeID)
	{
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+aEpisodeID+'&1=1';
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"");
	};
	obj.btnMsgSend_Click = function(el,admIdx)
	{
		var url = "../csp/dhchai.ir.ccmessage.csp?EpisodeDr=" + admIdx.split("^")[0] + "&PageType=layerOpen&MsgType=1";
		obj.idxLayerMsg = layer.open({
			type: 2,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
			maxmin: false,
			title: [admIdx.split("^")[2]+"-"+admIdx.split("^")[1],"text-align:center;background-color: #4C9CE4;color:#fff"], 
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
		//refreshCnt(aEpisodeDr);  //计数更新
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
		//refreshCnt(aEpisodeDr);  //计数更新
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
			obj.LayerInfRep("","");
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
		var url="dhchai.ir.inf.report.csp?1=1&EpisodeID="+aEpisodeID+'&AdminPower='+ obj.AdminPower+"&2=2";
		if(parent.layer){
		parent.layer.open({
		      type: 2,
			  area: ['95%', '100%'],
			  title:'医院感染报告',
			  closeBtn:1,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no'],
			  success: function(layero, index){
				$("div.layui-layer-content").css("padding-right","2px");
			  },
			  end: function () {
              	refreshRstList(aEpisodeID,"","");
              }
		});
		}
		else
		{
			showFullScreenDiag(url,"医院感染报告");
		}
	}
	obj.winOpenNewInfReport = function(aEpisodeID)
	{
		if (!aEpisodeID) return;
		var url="dhchai.ir.inf.nreport.csp?1=1&EpisodeID="+aEpisodeID+'&AdminPower='+ obj.AdminPower+"&2=2";
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '100%'],
			  title:'医院感染报告',
			  closeBtn:1,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no'],
			 end: function () {
              	refreshRstList(aEpisodeID,"","");
              }
		});*/
		showFullScreenDiag(url,"医院感染报告",1);
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
		var DiasID = (obj.InfDiagnosDr ? obj.InfDiagnosDr : '');          //感染诊断ID（rd.RepID）
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
	};
}
