//页面Gui
function InitPatDtl(obj){
	InitFloatWin(obj);
	obj.IsReportDiag = '';
	obj.pindex ='';
	obj.rindex = '';
	obj.EpisodeID = '';
	obj.AdmDate = '';
	obj.DischDate = '';
	obj.DiagData = '';
	obj.ScreenData = '';
	obj.Bacterias ='';
	obj.DiagID = '';
	obj.ReportID = '';
	objConfig = ServerObj.IsCheckReport;
	
	//加载病人信息
	obj.BuildPatIfo = function(pindex,rindex,objAdm,flg) {   //flg=1，科室汇总
		var htmlStr='';
		var htmlMsg='';
		var EpisodeID = objAdm.EpisodeID;
		obj.pindex = pindex;
		obj.rindex = rindex;
		
		if (!EpisodeID) return;
		// 1.病人基本信息
		htmlStr ='<div id=divPatInfo'+EpisodeID+' class="panel-heading">'
				+ '	<ul class="list-inline">'
				+ '		<li>'		
				+ '			<a href="#" id=btnIsNeed'+EpisodeID+' style="margin-right:5px;">'
				+ ' 	    	 <img id=Star'+EpisodeID+' onclick="btnIsNeed_click(this,\'' + EpisodeID  + '\',\'' +  pindex+ '\',\'' +  rindex + '\')" style="vertical-align: middle;"' +((objAdm.IsNeedAtt==1) ? 'class="yellow-star" src="../scripts/DHCMA/HAI/img/关注-选中.png" ' :   'class="write-star" src="../scripts/DHCMA/HAI/img/收藏-未选中.png" ' ) +'/>'
				+ ' 	    </a>'
				+ '			<a href="#" id=btnMessage'+EpisodeID+' >'
				+ '				<img id=Message'+EpisodeID+'  onclick="btnMessage_click(this,\'' + EpisodeID  + '\',\'' +  pindex+ '\',\'' +  rindex + '\')" style="vertical-align: middle;"'+((objAdm.IsMessage==1) ? 'class="green-message" src="../scripts/DHCMA/HAI/img/消息-选中.png" '  : 'class="write-message" src="../scripts/DHCMA/HAI/img/消息-未选中.png" ') +'/>'
				+ '			</a>'
				+ '		</li>'	
				+ '		<li class="middle-line" >|</li>'
				+ '		<li>'
				+ '			<span id="txtSuspendDesc' + EpisodeID + '" style="font-weight:bold;font-size:120%;">'+objAdm.SuspendDesc+'</span>'
				+ '			<span id="txtSuspendCode' + EpisodeID + '" style="display:none;">'+objAdm.SuspendCode+'</span></li>'
				+ '		</li>'
				+ '		<li class="middle-line">|</li>'
				+ '		<li>'+objAdm.PatName+' '+objAdm.RegNo+'</li>'
				+ '		<li class="middle-line">|</li>'
				+ '		<li>' + ((objAdm.CurrBed != '') ? objAdm.CurrBed : '空床') + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.Sex + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.Age + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + ((objAdm.OutHospDate != '') ? objAdm.OutHospDate : '') + objAdm.VisitStatus +'</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.CurrLocDesc + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.InHospDate + '入院'+ ((objAdm.InHospLocDesc != objAdm.CurrLocDesc) ? ('('+objAdm.FromLocDesc+')') : '') + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.InLocDate + '入科' + ((objAdm.FromLocDesc != '') ? ('('+objAdm.FromLocDesc+')') : '')  + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + ((objAdm.AdmDocDesc != '') ? objAdm.AdmDocDesc : '') + '(医)'+'</li>'
				+ '	</ul>'
				+ '</div>'
				
				//2. 感染诊断/疑似筛查信息
				+ '	<div class="table-nobottom" style="border-left:1px solid #ccc;border-right:1px solid #ccc;border-bottom:1px solid #ccc;">'
				+ '	<div style="padding:5px;border-bottom:1px solid #ccc;">'
				+ ' 	<a id=btnOkAll'+EpisodeID+' onclick="btnOkAll_click(this,\'' + EpisodeID + '\',\'' + objAdm.InHospDate + '\',\'' + objAdm.OutHospDate + '\',\'' +  pindex+ '\',\'' +  rindex + '\')" > 全部确诊 </a>'		
				+ '		<a id=btnDelAll'+EpisodeID+' onclick="btnDelAll_click(this,\'' + EpisodeID + '\',\'' +  pindex+ '\',\'' +  rindex + '\')"> 全部排除 </a>'	
				+ ' 	<a id=btnReport'+EpisodeID+' onclick="btnReport_click(this,\'' + EpisodeID  + '\',\'' +  pindex+ '\',\'' +  rindex + '\')" > 上报 </a>'
				+ ' 	<a id=btnCheck'+EpisodeID+' onclick="btnCheck_click(this,\'' + EpisodeID + '\')" > 审核 </a>'	 //院感科审核报告			
				+ '		<a id=btnSummer'+EpisodeID+' onclick="btnSummer_click(this,\'' + EpisodeID + '\')"> 摘要 </a>'
				+ '		<a id=btnAddQuest'+EpisodeID+' onclick="btnAddQuest_click(this,\'' + EpisodeID + '\')"> 反馈问题 </a>'
				+ '	</div>'
				+ ' <table id=gridScreenInfo'+EpisodeID+' data-options="border:false," ></table>'
				+ '	</div>'
				+ ' <div style="padding-bottom:10px;">'	
				
		if (flg<1) {    //科室汇总不显示消息
				
			htmlMsg= ' <div	style="margin-top:10px;border:1px solid #ccc;">'
				//3.消息记录
			    + ' <div id=divMessage'+EpisodeID+' style="padding:10px;">'	
				+ ' </div>'
				
				//4.发消息
				+ ' <div id=divSendMess'+EpisodeID+' style="display: block; border-top: 1px solid #ccc;padding:10px;">'		
				+ '		<textarea class="textbox"  id=txtMessage'+EpisodeID+' style="width:99%;height:80px;border:none;outline: none;background-color:#fff;" placeholder="请输入..."></textarea> '
				+ ' 	<div style="padding-top:10px;text-align:right">'
				+ '			<a id=btnRead'+EpisodeID+' onclick="btnRead_click(\'' + EpisodeID  + '\',\'' +  pindex+ '\',\'' +  rindex + '\')"  style="margin-right:10px;">阅读</a>'
				+ '			<a id=btnSend'+EpisodeID+' onclick="btnSend_click(\'' + EpisodeID  + '\',\'' +  pindex+ '\',\'' +  rindex + '\')" >发送</a>'
				+ '			<span style="margin-left:-7px;font-size:12px;color: #fff;">|</span>'
				+ '			<a id=btnMSend'+EpisodeID+' onclick="btnMSend_click(\'' + EpisodeID  + '\',\'' +  pindex+ '\',\'' +  rindex + '\')" style="margin-left:-5px;background-color:#40A2DE"></a>'	
				+ ' 	</div>'
				+ ' </div>'	
				+ ' </div>'	
			htmlStr += htmlMsg;
		}
		$('#divMain').append(htmlStr);
		
		if (flg<1) {
			obj.MsgLoad(EpisodeID);
		}
		
		$('#btnReport'+EpisodeID).linkbutton({
			iconCls: 'icon-add',
			plain: true
		});
		if (LocFlag==1) {
			$('#btnCheck'+EpisodeID).hide();
		}else {
			$('#btnCheck'+EpisodeID).linkbutton({
				iconCls: 'icon-stamp',
				plain: true
			});
		}
		$('#btnSummer'+EpisodeID).linkbutton({
			iconCls: 'icon-tip',
			plain: true
		});
		$('#btnOkAll'+EpisodeID).linkbutton({
			iconCls: 'icon-ok',
			plain: true
		});
		$('#btnDelAll'+EpisodeID).linkbutton({
			iconCls: 'icon-cancel',
			plain: true
		});
		
		$('#btnAddQuest'+EpisodeID).linkbutton({
			iconCls: 'icon-paper-table',
			plain: true
		});
		
		obj.gridScreenInfo(EpisodeID,pindex,rindex);
		obj.gridScreenInfoLoad(EpisodeID);
	}
	
	//加载患者消息
	obj.MsgLoad = function(EpisodeID){
		$('#btnRead'+EpisodeID).linkbutton();
		$('#btnSend'+EpisodeID).linkbutton();	
		$('#btnMSend'+EpisodeID).linkbutton({
			iconCls:'icon-w-arrow-down',
			plain: true
		});	
		var Msghtml="";
		obj.Msg = $cm({
			ClassName:'DHCHAI.IRS.CCMessageSrv',
			QueryName:'QryMsgByPaadm',
			aPaadm:EpisodeID
		},false);
		if (obj.Msg.total>0) {
			$('#divMessage'+EpisodeID).empty();
		
			for (var i=0;i<obj.Msg.total;i++){
				var rd = obj.Msg.rows[i];	
				if ((rd.CSMsgType==1)||(rd.CSMsgType==3)) {
					Msghtml += ' <div id="patMsgType1" class="right_message">'
							+ ' 	<div class="MessTitle">'
							+ '     	<span>'+rd.MTitle+'</span>'
							+ '     </div>'
							+ '     <div class="MessDtl">'	
							+ '			<div>'+ ((rd.CSIsRead==0) ? '<div style="background-color:red;color:#fff;border-radius:10px;font-size:10px;padding:3px;width:25px;font-weight: 600;">未读</div>' :'')+'</div>'
							+ ' 		<div class="message">'
							+ '     	    <div class="left message-green">'
							+ '					<div class="message-arrow"></div>'				
							+ '     			<div class="message-inner">'+rd.CSMessage+'</div>'
							+ '     		</div>'
							+ '     	</div>'	
							+ ' 		<div style="display: inline-block;">'
							+ ' 		     <div class="icon-doctor-green-pen" style="margin-top: 3px;width:25px;height:25px;border: 3px solid #16BBA2;border-radius: 15px;"></div>'
							+ '         </div>'
							+ '     </div>'
							+ ' </div>'				
				}else {
					Msghtml += ' <div id="patMsgType2" class="left_message">'
							+ ' 	<div class="MessTitle">'
							+ '     	<span>'+rd.MTitle+'</span>'
							+ '     </div>'
							+ '     <div class="MessDtl">'
							+ ' 		<div style="display: inline-block;">'
							+ ' 			<div class="icon-person" style="margin-top: 3px;width:25px;height:25px;border: 3px solid #509DE1;border-radius: 15px;"></div>'									
							+ '         </div>'
							+ ' 		<div class="message">'
							+ '     	    <div class="right message-blue">'
							+ '					<div class="message-arrow"></div>'				
							+ '     			<div class="message-inner">'+rd.CSMessage+'</div>'
							+ '     		</div>'
							+ '     	</div>'	
							+ ' 		<div>'+ ((rd.CSIsRead==0) ? '<div style="background-color:red;color:#fff;border-radius:10px;font-size:10px;padding:3px;width:25px;font-weight: 600;">未读</div>' :'')+'</div>'
							+ '     </div>'
							+ ' </div>'
				}
			}
		
			$('#divMessage'+EpisodeID).append(Msghtml);	
			return true;
		}			
	}
	
	//疑似筛查明细
	obj.gridScreenInfo = function(EpisodeID,pindex,rindex) {
		$HUI.datagrid("#gridScreenInfo"+EpisodeID,{
			singleSelect: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			fitColumns: true,   //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
			//nowrap: false,      //设置为 true，则把数据显示在一行里。false 超长折行显示。
			columns:[[
				{field:'ItmScreenID',title:'操作',width:110,align:'center',
					formatter: function(value,row,index){
						if (row.ItmScreenID) {
							if (row.OprStatus=='1') {    //已确诊项目
								return "<a href='#' onclick='btnDel_click(this,\"" + EpisodeID + "\",\"" + index + "\",\"" +  pindex+ "\",\"" +  rindex + "\")' >排除</a>";						   
							}else if (row.OprStatus=='2') {    //已排除项目
								return "<a href='#' onclick='btnOk_click(this,\"" + EpisodeID + "\",\"" + index +"\",\"" +  pindex+ "\",\"" +  rindex + "\",\"" + row.AdmDate + "\",\"" + row.DischDate + "\")' >确诊</a>";		
							}else {
								return "<a href='#' onclick='btnOk_click(this,\"" + EpisodeID + "\",\"" + index + "\",\"" +  pindex+ "\",\"" +  rindex + "\",\"" + row.AdmDate + "\",\"" + row.DischDate + "\")' >确诊</a>" 
								+"&nbsp;&nbsp;<a href='#' onclick='btnDel_click(this,\"" + EpisodeID + "\",\"" + index +"\",\"" +  pindex+ "\",\"" +  rindex + "\")' >排除</a>";
							}
						}else {
							if ((row.RepStatusCode!='3')&&(row.RepStatusCode!='4')) {
								return "<a href='#' onclick='btnDeleteRep_click(this,\"" + EpisodeID + "\",\"" +  row.InfReportID+ "\",\"" +  row.RepStatusCode + "\")' >删除</a>";    //删除感染报告
						    }else {
								return "";
							}
						}
					}	
				},	
				{field:'InfPosList',title:'诊断',width:355,
					formatter: function(value,row,index){	
						if (row.InfRepPos) {
							var strList = row.InfRepInfo.split(",");
							var len = strList.length;   				
							var strRet ="";
							for (var i=0;i<len;i++){
								var InfRepInfo =strList[i].split(" ")[0];
								var InfRepDiagID =strList[i].split(" ")[1];
								var InfReportID =strList[i].split(" ")[2];
								strRet +=((row.ScreenID!='')&&((row.OprStatus=='1')||(row.OprStatus=='-1')) ? "<a href='#' class='icon-ok' style='padding-right: 3px;' onclick='btnConfDtl_click(this,\"" + row.ScreenID + "\");'>&nbsp;&nbsp;&nbsp;&nbsp;</a>":'');
								strRet +=InfRepInfo+' '+"<a href='#' class='icon-edit' style='padding-left: 3px;line-height:30px;' onclick='btnEdit_click(this,\"" + EpisodeID + "\" ,\"" + InfRepDiagID + "\" ,\"" + InfReportID + "\",\"" + row.AdmDate + "\" ,\"" + row.DischDate + "\" ,\"" + index +"\",\"" +  pindex+ "\",\"" +  rindex + "\");'>&nbsp;&nbsp;&nbsp;&nbsp;</a></br>";
							}
							return strRet;
						} else {
							return  value;
						}
					}						
				},	 				
				{field:'ResultNote',title:'感染相关指标',width:280,showTip:true,
					formatter: function(value,row,index){					
						return  value + "<a style='color:#00BFFF'>"+((row.InfType=='0') ? ' (院外)':'')+"</a>";
					}	
				},	
				{field:'ResultDates',title:'异常指标时间',width:260,showTip:true,tipWidth:400,
					formatter: function(value,row,index){
						return  value;
						/* 2020-03-25 xwj bug:1239431
						if (row.ResultCnt) {
							debugger;
							return  value + "(" +row.ResultCnt+ "次)";
						}else {
							return  value;
						}*/
					}	
				},	 				
				{field:'IsFever|IsTSAb',title:'感染因素',width:130,
					formatter: function(value,row,index){
						return  ((row.IsFever<1) ? '':'<a class="hisui-tooltip" title="体温异常"><img style="width:16px;height:16px;" src="../scripts/DHCMA/HAI/img/体温.png"/></a>')
								+ ((row.IsTSAb<1) ? '':'<a class="hisui-tooltip" style="padding-left:5px;" title="血常规异常"><img style="width:16px;height:16px;" src="../scripts/DHCMA/HAI/img/血常规.png"/></a>')
								+ ((row.IsOEUC<1) ? '':'<a class="hisui-tooltip" style="padding-left:5px;" title="导尿管"><img style="width:16px;height:16px;"src="../scripts/DHCMA/HAI/img/导尿管.png"/></a>')
								+ ((row.IsOEVAP<1) ? '':'<a class="hisui-tooltip" style="padding-left:5px;" title="呼吸机"><img style="width:16px;height:16px;"src="../scripts/DHCMA/HAI/img/呼吸机.png"/></a>')
								+ ((row.IsOEPICC<1) ? '':'<a class="hisui-tooltip" style="padding-left:5px;" title="静脉插管"><img style="width:16px;height:16px;"src="../scripts/DHCMA/HAI/img/静脉插管.png"/></a>');	 
					}
				}
			]],
			rowStyler: function(index,row){
				if (row.OprStatus=='0') {     //疑似、确诊后n之后有新疑似、排除后n之后有新疑似
					return 'color:red;'; // return inline style
				}			
				if ((row.ItmScreenID=='')&&(row.OprStatus=='2')){    //删除的感染报告
					return 'color:gray;'; // return inline style
				}			
				if (row.Status=='2') {   //排除后无新疑似
					return 'color:gray;'; // return inline style
				}
			},
			onLoadSuccess:function(data){ 
				if (data.total<1){
					$('#btnOkAll'+EpisodeID).linkbutton("disable");
					$('#btnDelAll'+EpisodeID).linkbutton("disable");										
				}
			}
			
		});
	}
	
	//加载疑似筛查明细
    obj.gridScreenInfoLoad = function(EpisodeID){	
		$cm ({
			ClassName:'DHCHAI.IRS.CCScreeningSrv',
			QueryName:'QrySuRuleResult',
			aEpisodeID:EpisodeID
		},function(rs){
			$('#gridScreenInfo'+EpisodeID).datagrid('loadData', rs);				
		});
    }
	
	// ****************************** ↓↓↓按钮事件
	//需关注
	btnIsNeed_click = function (el,EpisodeID,pindex,rindex ) {	
	    var $this = $(el);
		var write = $this.hasClass("write-star");
		
		if (write) {
			//需关注类型
			obj.cboFollowReason = Common_ComboDicID("cboFollowReason","FollowReason");
            $('#txtIsNeedAtt').val('');
			$('#IsNeedDialog').show();
			obj.IsNeedDialog = $HUI.dialog('#IsNeedDialog',{
				title:'需关注原因',
				iconCls:'icon-w-star',  
				resizable:true,
				modal: true,
				isTopZindex:true,
				buttons:[{
					text:'保存',
					handler:function(){
						//关注
						var retval = obj.IsNeed_Save(EpisodeID,1);
						if(parseInt(retval)<0){
							$.messager.alert("提示","关注失败！","info");
						}else{			
							//切换图片
							$this.toggleClass("write-star");
							$this.toggleClass("yellow-star");
							$('.yellow-star').attr("src",'../scripts/DHCMA/HAI/img/关注-选中.png');
							$.messager.popover({msg: '关注成功！',type:'success',timeout: 1000});
							$HUI.dialog('#IsNeedDialog').close();
							if (pindex) { //存在左侧列表
								if (LocFlag==1) { //刷新科室明细列表
									$('#gridAdmInfo').datagrid('updateRow', {
										index: pindex,
										row: {'IsNeedAtt':1}
									});
								}else{ //刷新科室汇总列表
									if ( $('#gridLocInf').length <= 0 ){   //确诊未报等界面没有左侧科室列表不刷新
								        if ($('#gridPatList').length>0) {
									        gridPatListLoad();
								        }
								   	 	return;
								    }
									var rows = $('#gridLocInf').datagrid('getSelected');
									var Count = parseInt(rows.ScreenAttCnt) + 1;
									var currPage=1;
									var expander = $('#gridLocInf').datagrid('getExpander',pindex);  //获取展开行
									if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
										if (rindex>=0) {
											var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
											currPage = options.pageNumber; 
										}
									}
														
									$('#gridLocInf').datagrid('updateRow', {  //更新一行
										index: pindex,
										row: {'ScreenAttCnt':Count}
									});							    
							
									if(expander.length && expander.hasClass('datagrid-row-collapse')){
										$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
										$('#gridLocInf').datagrid('expandRow',pindex);   //展开
										obj.SelectAdmRow(EpisodeID,pindex,currPage);  //刷新明细表格
									}									
								}
							}								
						}
					}
				},{
					text:'关闭',
					handler:function(){
						$HUI.dialog('#IsNeedDialog').close();
					}
				}]
			});
		}else {
			//取消关注
			var retval = obj.IsNeed_Save(EpisodeID,0);
			if(parseInt(retval)<0){
				$.messager.alert("提示","关注失败！",'info');
			}else{	
				//切换图片
				$this.toggleClass("yellow-star");
				$this.toggleClass("write-star");
				$('.write-star').attr("src",'../scripts/DHCMA/HAI/img/收藏-未选中.png');	
				$.messager.popover({msg: '取消关注成功！',type:'success',timeout: 1000});
				if (pindex) { //存在左侧列表 
					if (LocFlag==1) { //刷新科室明细列表
						$('#gridAdmInfo').datagrid('updateRow', {
							index: pindex,
							row: {'IsNeedAtt':0}
						});
					} else{  //刷新科室汇总列表
						if ( $('#gridLocInf').length <= 0 ){   //确诊未报等界面没有左侧科室列表不刷新
					        if ($('#gridPatList').length>0) {
						        len = $('#gridPatList').datagrid('getRows').length;
						        gridPatListLoad();	
						        $('#gridPatList').datagrid({   //需关注病例列表取消关注后刷新右侧
									onLoadSuccess:function(data) {
										if (len>data.total) {
											$('#divMain').empty();
											$('#divNoResult').attr("style","display:block");
										}
										dispalyEasyUILoad(); //隐藏效果
									}
						        });			      
					        }
					   	 	return;
					    }
						var rows = $('#gridLocInf').datagrid('getSelected');
						var Count = parseInt(rows.ScreenAttCnt) -1;
						var currPage=1;
						var expander = $('#gridLocInf').datagrid('getExpander',pindex);  //获取展开行
						if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
							if (rindex>=0) {
								var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
								currPage = options.pageNumber; 
							}
						}
									
						$('#gridLocInf').datagrid('updateRow', {  //更新一行
							index: pindex,
							row: {'ScreenAttCnt':Count}
						});
						
						if(expander.length && expander.hasClass('datagrid-row-collapse')){
							$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
							$('#gridLocInf').datagrid('expandRow',pindex);   //展开						
							obj.SelectAdmRow(EpisodeID,pindex,currPage);  //刷新明细表格						
						}
					}
				}					
			}
		}
	}
	
	//需关注保存
	obj.IsNeed_Save = function(EpisodeID,needAtt){
		if (EpisodeID == '') {
			$.messager.alert("提示", "关注患者不允许为空！", "info");
			return -1;
		}	
		var FollowReason = $('#cboFollowReason').combobox('getValue');
		var IsNeedAtt = $('#txtIsNeedAtt').val();
		if ((needAtt==1)&&(!FollowReason)&&(!IsNeedAtt)) {
			$.messager.alert("提示", "需关注类型、需关注原因不能同时为空！", "info");
			return -1;
		}
		if (!FollowReason) {
			var IsNeedMsg = IsNeedAtt;
		}
		if (!IsNeedAtt) {
			var IsNeedMsg = FollowReason;
		}
		if ((FollowReason)&&(IsNeedAtt)) {
			var IsNeedMsg = FollowReason + ',' + IsNeedAtt;
		}
		if (needAtt==0) IsNeedMsg='';
		
		//通过就诊号唯一判断
		var InputStr = EpisodeID;
		InputStr += "^" + needAtt;
		InputStr += "^" + IsNeedMsg;
		InputStr += "^" + $.LOGON.USERID;
		var retval  = $m({
			ClassName:"DHCHAI.IR.CCScreenAtt",
			MethodName:"UpdateNeedAttflag",
			aInputStr:InputStr,
			aSeparete:'^'
		},false);
		return retval;
	};
	
	//消息
	btnMessage_click = function (el,EpisodeID,pindex,rindex) {
		// 1院感、2临床
		var MsgType=1;
		if (LocFlag==1) MsgType=2;
		
		var t=new Date();
		t=t.getTime();
		var $this = $(el);
		var strUrl = "./dhcma.hai.ir.ccmessage.csp?EpisodeDr=" + EpisodeID + "&MsgType="+MsgType+"&PageType=WinOpen&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'消息列表',
			iconCls:'icon-w-msg',  
			width:800,
			height:500,
			onBeforeClose:function(){	
				var ret = obj.MsgLoad(EpisodeID); //刷新单个患者消息
				if (ret) {
					//消息发送成功应该显示绿色图标
					$('#Message'+EpisodeID).toggleClass("write-message",false);  
					$('#Message'+EpisodeID).toggleClass("yellow-message",true);
					$('.yellow-message').attr("src",'../scripts/DHCMA/HAI/img/消息-选中.png');
					
					if (pindex) { //存在左侧列表
						if (LocFlag==1) { //刷新科室明细列表	
							$('#gridAdmInfo').datagrid('updateRow', {
								index: pindex,
								row: {'IsMessage':1}
							});
						}else {  //刷新科室汇总列表
						    if ( $('#gridLocInf').length <= 0 ){   //确诊未报等界面没有左侧科室列表不刷新
						        if ($('#gridPatList').length>0) {
							        gridPatListLoad();
						        }
						   	 	return;
						    }
							var currPage=1;
							var expander = $('#gridLocInf').datagrid('getExpander',pindex);  //获取展开行
							if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
								if (rindex>=0) {
									var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
									currPage = options.pageNumber; 
								}
							}
						
							$('#gridLocInf').datagrid('updateRow', {  //更新一行
								index: pindex
							});

							if(expander.length && expander.hasClass('datagrid-row-collapse')){
								$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
								$('#gridLocInf').datagrid('expandRow',pindex);   //展开
								obj.SelectAdmRow(EpisodeID,pindex,currPage);  //刷新明细表格							
							}
							
						}
					}					
				}					
			}  
		});
	}
	
	//确诊 (单行确诊)
	btnOk_click = function (el,EpisodeID,rowIndex,pindex,rindex,AdmDate,DischDate) {
		var arrData = new Array();
		$('#gridScreenInfo'+EpisodeID).datagrid('selectRow',rowIndex);// 获取点击当前行的索引
        var rData=$('#gridScreenInfo'+EpisodeID).datagrid("getSelected");//获取当前行数据
		arrData[arrData.length] =rData;
		var OprStatus = rData.OprStatus;
		if (OprStatus=='1') return;	
		var InfRepDiagID="",DiagID="";
		var InfPosIDList = rData.InfPosIDList.replace("，",",");
		var InfPosList = rData.InfPosList.replace("，",",");
		var InfPosID = InfPosIDList.split(",")[0];
		var InfPos = InfPosList.split(",")[0];
		var InfSuDate=rData.InfSuDate;
		var Bacterias = rData.ItmScreenTxt;
		
		obj.AdmDate = AdmDate;
		obj.DischDate = DischDate;
		obj.ScreenData = arrData;
		obj.Bacterias = Bacterias;

		//只判断是否有确诊、报告记录，推荐感染诊断与确诊、报告的感染诊断一致时，可能因多条记录先后顺序关系，默认诊断与推荐诊断不一致		
		if (objConfig==1) { //配置自动关联上次报告，直接确诊 
			var objReportInfo = $cm({     
				ClassName:'DHCHAI.IRS.CCScreeningSrv',
				QueryName:"QryRepInfo",
				aEpisodeID:EpisodeID, 
				aIsReport:1
			},false);
			if (objReportInfo.total>0) {  //有报告记录
				var InfDiagID =  objReportInfo.rows[0].DiagID;  
		    	var ReportID =  objReportInfo.rows[0].ReportID; 								
				obj.OperConfirm(EpisodeID,InfDiagID,ReportID,obj.Bacterias);	   //操作确诊					
			}else {   //无报告
				var objDiagInfo = $cm({     
					ClassName:'DHCHAI.IRS.CCScreeningSrv',
					QueryName:"QryRepInfo",
					aEpisodeID:EpisodeID 
				},false);
				if (objDiagInfo.total>0) {   //有有效的确诊信息
	        		obj.RepInfoDialog(EpisodeID,objDiagInfo);        	
	       		}else { //无报告且无确诊信息            
					var InfData=EpisodeID+"^"+InfPosID+"^"+InfPos+"^^^"+InfSuDate+"^^^^^^^^^^^^1^1";					
					obj.InfDiagnos(EpisodeID,InfData); //感染诊断信息窗口
	        	}	
			}
		}else {
			var objDiagInfo = $cm({     
				ClassName:'DHCHAI.IRS.CCScreeningSrv',
				QueryName:"QryRepInfo",
				aEpisodeID:EpisodeID 
			},false);
		
	        if (objDiagInfo.total>0) {   //有有效的报告或确诊信息
	        	obj.RepInfoDialog(EpisodeID,objDiagInfo);        	
	        }else { //无报告且无确诊信息            
				var InfData=EpisodeID+"^"+InfPosID+"^"+InfPos+"^^^"+InfSuDate+"^^^^^^^^^^^^1^1";					
				obj.InfDiagnos(EpisodeID,InfData); //感染诊断信息窗口
	        }			
        }
	}
	
	//全部确诊
	btnOkAll_click = function (el,EpisodeID,AdmDate,DischDate,pindex,rindex) {   //只确诊疑似状态
        var arrData = new Array();
		var InfPosIDList ="",InfPosList="",InfSuDateList ="";
		var InfRepDiagID="",BacteriaList="",DiagID="";
		var rows = $('#gridScreenInfo'+EpisodeID).datagrid("getRows"); //获取当前页所有行
		for (var i=0;i<rows.length;i++) {
			if (rows[i].OprStatus !='0') continue;
			arrData[arrData.length] =rows[i];
			if (rows[i].ItmScreenTxt) {
				BacteriaList=BacteriaList+","+rows[i].ItmScreenTxt;
			}
		}
		
	    var arrLen = arrData.length; 
	    if (arrLen<1) {   //无疑似条目
	    	$.messager.alert("提示", "无疑似项目需确诊!", 'info');
			return;
	    } else if (arrLen==1) { //一条疑似记录
	    	 var InfPosID = arrData[0].InfPosIDList;
			 var InfPos = arrData[0].InfPosList;
			 var InfSuDate =arrData[0].InfSuDate;
	    } else {  //多条疑似记录
		     for (var j=0;j<arrLen;j++) {    //取第一条推荐诊断不为空项目
			   if (!arrData[j].InfPosIDList) continue; 
			   InfPosIDList = arrData[j].InfPosIDList;
			   InfPosList = arrData[j].InfPosList;
			   InfSuDateList =arrData[j].InfSuDate;
			   if (InfPosIDList) continue;   
		    }
		    if (!InfPosIDList) {  //没有推荐诊断
		    	var InfPosID = arrData[0].InfPosIDList;
			 	var InfPos = arrData[0].InfPosList;
			 	var InfSuDate =arrData[0].InfSuDate;
		    } else{
			    var InfPosID = InfPosIDList;
			 	var InfPos = InfPosList;
			 	var InfSuDate =InfPosList;
		    }   
	    }
	   
		obj.AdmDate = AdmDate;
		obj.DischDate = DischDate;
		obj.ScreenData = arrData;
		obj.Bacterias = BacteriaList;
		if (!InfPosID)  InfPosID="";
		if ((!InfPosID)||(!InfPos))  InfPos="";		  
	
		//只判断是否有确诊、报告记录，推荐感染诊断与确诊、报告的感染诊断一致时，可能因多条记录先后顺序关系，默认诊断与推荐诊断不一致 	
		if (objConfig==1) { //配置自动关联上次报告，直接确诊 
			var objReportInfo = $cm({     
				ClassName:'DHCHAI.IRS.CCScreeningSrv',
				QueryName:"QryRepInfo",
				aEpisodeID:EpisodeID, 
				aIsReport:1
			},false);
			if (objReportInfo.total>0) {  //有报告记录
				var InfDiagID =  objReportInfo.rows[0].DiagID;  
		    	var ReportID =  objReportInfo.rows[0].ReportID; 								
				obj.OperConfirm(EpisodeID,InfDiagID,ReportID,obj.Bacterias);	   //操作确诊					
			}else {    //无报告
				var objDiagInfo = $cm({     
					ClassName:'DHCHAI.IRS.CCScreeningSrv',
					QueryName:"QryRepInfo",
					aEpisodeID:EpisodeID 
				},false);
				if (objDiagInfo.total>0) {   //有有效的确诊信息
	        		obj.RepInfoDialog(EpisodeID,objDiagInfo);        	
	       		}else { //无报告且无确诊信息            
					var InfData=EpisodeID+"^"+InfPosID+"^"+InfPos+"^^^"+InfSuDate+"^^^^^^^^^^^^1^1";					
					obj.InfDiagnos(EpisodeID,InfData); //感染诊断信息窗口
	        	}	
			}
		}else {
			var objDiagInfo = $cm({     
				ClassName:'DHCHAI.IRS.CCScreeningSrv',
				QueryName:"QryRepInfo",
				aEpisodeID:EpisodeID 
			},false);
		
	        if (objDiagInfo.total>0) {   //有有效的报告或确诊信息
	        	obj.RepInfoDialog(EpisodeID,objDiagInfo);        	
	        }else { //无报告且无确诊信息            
				var InfData=EpisodeID+"^"+InfPosID+"^"+InfPos+"^^^"+InfSuDate+"^^^^^^^^^^^^1^1";					
				obj.InfDiagnos(EpisodeID,InfData); //感染诊断信息窗口
	        }			
        }
	}
	
	//感染诊断信息窗口
	obj.InfDiagnos = function(EpisodeID,InfData) {	
		obj.InitInfDialog(EpisodeID,InfData);		
		$HUI.dialog('#InfDiagnos',{
			title:'感染信息',
			iconCls:'icon-w-paper', 
			width:360,
			height:360,  
			resizable:true,
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){
					var DiagID = obj.InfDiagnos_Save(obj.EpisodeID,'',obj.AdmDate,obj.DischDate);
					if (!DiagID) return;
					if(parseInt(DiagID)>0){
						obj.OperConfirm(EpisodeID,DiagID,obj.ReportID,obj.Bacterias);	   //操作确诊
						$HUI.dialog('#InfDiagnos').close();
						obj.gridScreenInfoLoad(EpisodeID);
					}else{	
						$.messager.alert("提示","感染信息保存失败！",'info');
					}				
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#InfDiagnos').close();
				}
			}]
		});      
	}
	
	//排除字典操作
	$HUI.combobox('#cboOpinion',{
		onSelect:function(data){
			var OpinionDesc = $('#cboOpinion').combobox('getText');
			if (OpinionDesc=="其他") {
				$('#DivOpinion').removeAttr('style');
			}else {
				$('#DivOpinion').css('display','none');
				$('#txtOpinion').val('');
			}
		}
	});
			
	//排除(单行排除)
	btnDel_click = function (el,EpisodeID,rowIndex,pindex,rindex) {
		$('#gridScreenInfo'+EpisodeID).datagrid('selectRow',rowIndex);// 获取点击当前行的索引
        var rData=$('#gridScreenInfo'+EpisodeID).datagrid("getSelected");//获取当前行数据
		var OprStatus = rData.OprStatus;
		if (OprStatus=='2') return;	
		var ScreenIDs=obj.getScreenIDs(EpisodeID);
		var retval  = $m({
			ClassName:"DHCHAI.IRS.CCScreeningSrv",
			MethodName:"CheckDiagRep",
			aScreenID:rData.ScreenID
		},false);
		if (parseInt(retval)==1){
			$.messager.alert("提示", "确诊诊断已上报院感报卡，需先作废报告才可排除!", 'info');
			return;
		}
		//排除原因
		obj.cboOpinion = Common_ComboDicID("cboOpinion","InfDelOpinion");	
		$('#DivOpinion').css('display','none');
		
		$('#DelOpnDialog').show();
		obj.DelOpnDialog = $HUI.dialog('#DelOpnDialog',{
			title:'请输入排除原因',
			iconCls:'icon-w-cancel',  
			resizable:true,
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'确定',
				handler:function(){
					var OpinionID = $('#cboOpinion').combobox('getValue');			
					var Opinion =  $.trim($('#txtOpinion').val());
					var OpinionDesc = $('#cboOpinion').combobox('getText');
					if (!OpinionDesc) {
						$.messager.alert("提示", "请输入排除原因!", 'info');
						return;
					}
					
					if ((OpinionDesc=="其他")&&(!Opinion)) {
						$.messager.alert("提示", "请输入具体排除原因!", 'info');
						return;
					}
					
					if (OprStatus=='1')   {   //确诊无新项目产生，修改当前最后一条确诊记录
						var retval  = $m({
							ClassName:"DHCHAI.IRS.CCScreeningSrv",
							MethodName:"UpdateFinalOper",
							aScreenID:rData.ScreenID, 
							aOperCode:2, 
							aOperUser:$.LOGON.USERID,
							aOpinionDr:OpinionID,
							aOpinion:Opinion,
							aScreenIDs:ScreenIDs
						},false);
			
						if (parseInt(retval)<0){
							$.messager.alert("提示", "排除失败!", 'info');
							return;
						} else {
							obj.gridScreenInfoLoad(EpisodeID);
							$HUI.dialog('#DelOpnDialog').close();
							$.messager.popover({msg: '排除成功！',type:'success',timeout: 2000});
							var SuspendCode = document.getElementById("txtSuspendCode" + EpisodeID).innerText;
						
							//排除、确诊操作刷新界面
							if (pindex) { //存在左侧列表
								obj.RefreshTable(EpisodeID,pindex,rindex,SuspendCode);
							}							
						}
					} else {

						var ScreenInfo = rData.ItmScreenID;      //疑似筛查项目
						ScreenInfo += '^' + rData.ItmScreenTxt;  //疑似筛查文本
						ScreenInfo += '^' + rData.RstFromDate;   //疑似开始日期
						ScreenInfo += '^' + rData.RstToDate;     //疑似结束日期
						ScreenInfo += '^' + rData.InfSuPosID;    //疑似诊断
						ScreenInfo += '^' + Opinion;             //疑似处置意见
						ScreenInfo += '^' + OpinionID;           //疑似处置意见字典
						ScreenInfo += '^' + '';                  //感染部位  
						
						var retval  = $m({
							ClassName:"DHCHAI.IRS.CCScreeningSrv",
							MethodName:"SaveSuRuleOper",
							aEpisodeDr:EpisodeID, 
							aScreenInfos:ScreenInfo, 
							aOperCode:2, 
							aOperUser:$.LOGON.USERID,
							aOpinionDr:OpinionID,
							aOpinion:Opinion
						},false);
						
						var rstArr = retval.split("^");
						if (parseInt(rstArr[0])<0){
							$.messager.alert("提示", "排除失败!", 'info');
							return;
						} else {
							obj.gridScreenInfoLoad(EpisodeID);
							$HUI.dialog('#DelOpnDialog').close();
							$.messager.popover({msg: '排除成功！',type:'success',timeout: 2000});
							$("#txtSuspendCode" + EpisodeID).html(rstArr[2]);
							$("#txtSuspendDesc" + EpisodeID).html(rstArr[3]);
							
							//排除、确诊操作刷新界面
							if (pindex) { //存在左侧列表
								obj.RefreshTable(EpisodeID,pindex,rindex,rstArr[2]);
							}							
						}						
					}
				}					
			},{
				text:'取消',
				handler:function(){
					$HUI.dialog('#DelOpnDialog').close();
				}
			}]
		});	
	}
	
	//全部排除
	btnDelAll_click = function (el,EpisodeID,pindex,rindex) { //只排除疑似状态
        var arrData = new Array();
		var rows = $('#gridScreenInfo'+EpisodeID).datagrid("getRows"); //获取当前页所有行
		for (var i=0;i<rows.length;i++) {
			if (rows[i].OprStatus !='0') continue;
			arrData[arrData.length] =rows[i];
		}
		
		if (arrData.length>0) {
			//排除原因
			obj.cboOpinion = Common_ComboDicID("cboOpinion","InfDelOpinion");	
			$('#DivOpinion').css('display','none');
			
			$('#DelOpnDialog').show();
			obj.DelOpnDialog = $HUI.dialog('#DelOpnDialog',{
				title:'请输入排除原因',
				iconCls:'icon-w-cancel',  
				resizable:true,
				modal: true,
				isTopZindex:true,
				buttons:[{
					text:'确定',
					handler:function(){
						var OpinionID = $('#cboOpinion').combobox('getValue');			
						var Opinion =  $.trim($('#txtOpinion').val());
						var OpinionDesc = $('#cboOpinion').combobox('getText');
						if (!OpinionDesc) {
							$.messager.alert("提示", "请输入排除原因!", 'info');
							return;
						}
						
						if ((OpinionDesc=="其他")&&(!Opinion)) {
							$.messager.alert("提示", "请输入具体排除原因!", 'info');
							return;
						}
						
						var ScreenInfos = ""				
						for (var j=0;j<arrData.length;j++) {				
							var ScreenInfo = arrData[j].ItmScreenID;      //疑似筛查项目
							ScreenInfo += '^' + arrData[j].ItmScreenTxt;  //疑似筛查文本
							ScreenInfo += '^' + arrData[j].RstFromDate;   //疑似开始日期
							ScreenInfo += '^' + arrData[j].RstToDate;     //疑似结束日期
							ScreenInfo += '^' + arrData[j].InfSuPosID;    //疑似诊断
							ScreenInfo += '^' + Opinion;                  //疑似处置意见
							ScreenInfo += '^' + OpinionID;                //疑似处置意见字典
							ScreenInfo += '^' + '';                       //感染部位  
							ScreenInfos = ScreenInfos+","+ScreenInfo;
						}
						var retval  = $m({
							ClassName:"DHCHAI.IRS.CCScreeningSrv",
							MethodName:"SaveSuRuleOper",
							aEpisodeDr:EpisodeID, 
							aScreenInfos:ScreenInfos, 
							aOperCode:2, 
							aOperUser:$.LOGON.USERID,
							aOpinionDr:OpinionID,
							aOpinion:Opinion
						},false);
					
						var rstArr = retval.split("^");
						if (parseInt(rstArr[0])<0){
							$.messager.alert("提示", "排除失败!", 'info');
							return;
						} else {
							obj.gridScreenInfoLoad(EpisodeID);
							$HUI.dialog('#DelOpnDialog').close();
							
							$.messager.popover({msg: '排除成功！',type:'success',timeout: 2000});
							$("#txtSuspendCode" + EpisodeID).html(rstArr[2]);
							$("#txtSuspendDesc" + EpisodeID).html(rstArr[3]);
							
							//排除、确诊操作刷新界面
							if (pindex) { //存在左侧列表
								obj.RefreshTable(EpisodeID,pindex,rindex,rstArr[2]);
							}							
						}													
					}				
					
				},{
					text:'取消',
					handler:function(){
						$HUI.dialog('#DelOpnDialog').close();
					}
				}]
			});
		}else {
			$.messager.alert("提示", "无疑似项目需排除!", 'info');
			return;
		}			
	}
	
    //打开确诊明细
	btnConfDtl_click = function(el,aScreenID) {
		var objCofDtl = $cm({   //查找已确诊记录
			ClassName:'DHCHAI.IRS.CCScreeningSrv',
			QueryName:"QryScreenDtl",
			aScreenIDs:aScreenID, 
			aStatus:1 
		},false);
		if (objCofDtl.total>0) {								
			$('#CofDtlDialog').show();
			obj.ConfirmDtl(objCofDtl.rows);
			obj.CofDtlDialog = $HUI.dialog('#CofDtlDialog',{
				title:'是否取消已确诊记录',
				width:1100,
				iconCls:'icon-w-paper',  
				resizable:true,
				modal: true,
				isTopZindex:true
			});			
		} 
	}
						
	//确诊明细
	obj.ConfirmDtl = function(rs) {
		$HUI.datagrid("#ConfirmDtl",{
			fit:true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏	
			autoRowHeight: true,
			rownumbers: true,
			//title:'已确诊的项目如需修改，点击取消确诊按钮执行取消，无需修改，请关闭',
			loadMsg:'数据加载中...',
			columns:[[
				{field:'ScrDtlID',title:'取消确诊',width:80,align:'center',
					formatter: function(value,row,index){
						return "<a href='#' class='icon-no' onclick='btnExclude_click(this,\"" + row.EpisodeID + "\",\"" + value + "\")' >&nbsp;&nbsp;&nbsp;&nbsp;</a>";		
					}
				},
				{field:'ItmScreenDesc',title:'感染相关指标',width:210},
				{field:'RstDate',title:'结果日期',width:100},
				{field:'InfTypeDesc',title:'感染类型',width:80},				
				{field:'InfRepPos',title:'感染诊断',width:200},
				{field:'InfDate',title:'感染日期',width:100},
				{field:'ActDate',title:'操作日期',width:100},
				{field:'ActTime',title:'操作时间',width:80},
				{field:'ActUserDesc',title:'操作人',width:80}			
			]]
		});	
		$('#ConfirmDtl').datagrid('loadData', rs);
	}
	
	//获取疑似筛查项目指标ID
    obj.getScreenIDs = function(aEpisodeID){	
		var rows = $('#gridScreenInfo'+aEpisodeID).datagrid("getRows"); //获取当前页所有行
		var ScreenIDs="";
		for (var i=0;i<rows.length;i++) {
			if (rows[i].ScreenID !=""){
				ScreenIDs=ScreenIDs+","+ rows[i].ScreenID;
			}
		}
		return ScreenIDs;
    }
    
	//取消确诊
	btnExclude_click = function (el,aEpisodeID,aScrDtlID) {		
		var ScreenIDs=obj.getScreenIDs(aEpisodeID);
		var retval  = $m({
			ClassName:"DHCHAI.IRS.CCScreeningSrv",
			MethodName:"UpdateDiagStatus",
			aScrDtlID:aScrDtlID, 
			aScreenIDs:ScreenIDs
		},false);
		if (parseInt(retval)==1){
			$.messager.alert("提示", "确诊诊断已上报院感报卡，需先作废报告才可取消确诊!", 'info');
			return;
		}
		$.messager.prompt("取消确诊", "请输入取消原因!", function (r) {
			if (r){	
				var retval  = $m({
					ClassName:"DHCHAI.IRS.CCScreeningSrv",
					MethodName:"UpdateOper",
					aScrDtlInfos:aScrDtlID, 
					aOperCode:2, 
					aOperUser:$.LOGON.USERID,
					aOpinion:r,
					aScreenIDs:ScreenIDs
				},false);
				if (parseInt(retval)<0){
					$.messager.alert("提示", "取消失败!", 'info');
					return;
				} else {
					$HUI.dialog('#CofDtlDialog').close();
					obj.gridScreenInfoLoad(aEpisodeID);
					$.messager.popover({msg: '取消成功！',type:'success',timeout: 2000});
				}				
			}				
			else if(r === '') {
				$.messager.alert("提示", "先输入取消原因!", 'info');
				return;
			}
		});			
	}
	
	//上报
	btnReport_click = function (el,EpisodeID,pindex,rindex) {
		var DiagID = "";
		var Bacterias ="";
		var DiagInfo  = $cm({
			ClassName:"DHCHAI.IRS.CCScreeningSrv",
			QueryName:"QryUnRepScreen",
			aEpisodeID:EpisodeID
		},false);
	    
		if (DiagInfo.total>0) {
			DiagID = DiagInfo.rows[0].DiagID;
			Bacterias = DiagInfo.rows[0].Bacterias;
		}   
		var strUrl="dhcma.hai.ir.inf.report.csp?1=1&EpisodeID=" +EpisodeID +"&DiagnosID=" +DiagID +"&Bacterias=" +Bacterias +"&ReportID="+"&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'感染报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        //closable:false,
			width:1320,
			height:window.screen.availHeight-80,
			onBeforeClose:function(){
				var retval  = $m({
					ClassName:"DHCHAI.IRS.CCScreenAttSrv",
					MethodName:"UpdateSusInfFlagNew",
					aEpisodeDr:EpisodeID
				},false);
				var rstArr = retval.split("^");
				obj.gridScreenInfoLoad(EpisodeID);
				//排除、确诊操作刷新界面
				if (pindex) { //存在左侧列表
					obj.RefreshTable(EpisodeID,pindex,rindex,rstArr[2]);
				}					
			} 
		});    
	}
	
	//编辑感染信息
	btnEdit_click = function (el,EpisodeID,InfDiagID,ReportID,AdmDate,DischDate) {	
	    if (ReportID) {
			var strUrl="dhcma.hai.ir.inf.report.csp?1=1&EpisodeID="+EpisodeID+"&ReportID="+ReportID+"&t=" + t;
			websys_showModal({
				url:strUrl,
				title:'感染报告',
				iconCls:'icon-w-epr',  
				originWindow:window,
				//closable:false,
				width:1320,
				height:window.screen.availHeight-80,
				onBeforeClose:function(){
					obj.gridScreenInfoLoad(EpisodeID);
				} 
			});	
		}else {		
			var rdata = $m({
				ClassName:"DHCHAI.IRS.INFDiagnosSrv",
				MethodName:"GetStrByRowID",
				aID:InfDiagID
			},false);			 
			obj.InitInfDialog(EpisodeID,rdata);
			obj.InfDiagnosDialog(EpisodeID,InfDiagID,AdmDate,DischDate);
		}			
	}
	
	// 删除报告
	btnDeleteRep_click = function (el,aEpisodeID,aReportID,aStatusCode) {
		if (aStatusCode==3){ //已审核的报告不允许删除
    		$.messager.popover({msg: '已审核的报告不允许删除！',type:'info',timeout: 2000});
			return;
		}else {
			obj.SaveStatus(aReportID,4,aEpisodeID);
			obj.gridScreenInfoLoad(aEpisodeID);
		}
	}
	
	//审核
	btnCheck_click = function (el,EpisodeID) {
		$('#InfRepDialog').show();
		obj.gridRepList(EpisodeID);
		obj.gridRepDetail();
		obj.InfRepDialog = $HUI.dialog('#InfRepDialog',{
			title:'感染报告审核',
			width:1300,
			iconCls:'icon-w-paper',  
			resizable:true,
			modal: true,
			isTopZindex:true
		});	
	}
	
	//摘要
	btnSummer_click = function (el,EpisodeID) {
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + EpisodeID + "&PageType=WinOpen&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'医院感染集成视图',
			iconCls:'icon-w-paper',  
	        originWindow:window,
			width:window.screen.availWidth-40,
			height:window.screen.availHeight-80,
			onBeforeClose:function(){}  //若无词句,IE下打开一份报告关闭后，摘要无法关闭
		});
	}
	
	//反馈问题
	btnAddQuest_click = function (el,EpisodeID) {
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhcma.hai.ir.feedback.csp?EpisodeID=" + EpisodeID+"&TypeCode=1";
		websys_showModal({
			url:strUrl,
			title:'问题反馈',
			iconCls:'icon-w-paper',  
			width:800,
			height:600,
			onBeforeClose:function(){}  //若无词句,IE下打开一份报告关闭后，摘要无法关闭
		});
	}
	
	//阅读消息
	btnRead_click = function (EpisodeID,pindex,rindex) {
		// 1院感、2临床
		var MsgType=1;
		if (LocFlag==1) MsgType=2;
		
		var retval  = $m({
			ClassName:"DHCHAI.IRS.CCMessageSrv",
			MethodName:"ReadMessage",
			aEpisodeID:EpisodeID, 
			aUserID:$.LOGON.USERID, 
			aTypeCode:MsgType
		},false);
	
		if (parseInt(retval)>0){
			obj.MsgLoad(EpisodeID); //刷新单个患者消息
			if (pindex) { //存在左侧列表
				if (LocFlag==1) { //刷新科室明细列表	
					$('#gridAdmInfo').datagrid('updateRow', {
						index: pindex,
						row: {'LocUnRead':0}
					});
				}else {  //刷新明细表格
					var currPage=1;
					if (rindex>=0) {
						var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
						currPage = options.pageNumber; 
					}
					obj.SelectAdmRow(EpisodeID,pindex,currPage);  //刷新明细表格								
				}	
			}
			$.messager.popover({msg: '消息阅读成功！',type:'success',timeout: 2000});
		}else if(parseInt(retval)==0) {
			$.messager.popover({msg: '无未读消息需阅读！',type:'info',timeout: 2000});
		}else  {
			$.messager.popover({msg: '消息失败！',type:'error',timeout: 2000});
		}	
	}
	
	//发送消息
	btnSend_click = function (EpisodeID,pindex,rindex) {
		// 1院感、2临床
		var MsgType=1;
		if (LocFlag==1) MsgType=2;
		
		var MsgTxt= $('#txtMessage'+EpisodeID).val().replace(/\^/g,"").replace(/\r?\n/g,"<br />");
		if (MsgTxt == '') {
			$.messager.alert("提示", "消息内容不允许为空！", "info");
			return;
		}
		var retval = obj.Msg_Save("",EpisodeID,MsgType,MsgTxt,"0");
		if (parseInt(retval)>0){
			//切换图片
			$('#Message'+EpisodeID).toggleClass("write-message",false);
			$('#Message'+EpisodeID).toggleClass("yellow-message",true);
			$('.yellow-message').attr("src",'../scripts/DHCMA/HAI/img/消息-选中.png');
			if (pindex) { //存在左侧列表
				if (LocFlag==1) { //刷新科室明细列表	
					$('#gridAdmInfo').datagrid('updateRow', {
						index: pindex,
						row: {'IsMessage':1}
					});
				}else {  //刷新科室汇总列表
					if ( $('#gridLocInf').length <= 0 ){   //确诊未报等界面没有左侧科室列表不刷新
				        if ($('#gridPatList').length>0) {
					        gridPatListLoad();
				        }
				   	 	return;
				    }
					var currPage=1;
					var expander = $('#gridLocInf').datagrid('getExpander',pindex);  //获取展开行
					if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
						if (rindex>=0) {
							var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
							currPage = options.pageNumber; 
						}
					}	
					$('#gridLocInf').datagrid('updateRow', {  //更新一行
						index: pindex
					});				
					
					if(expander.length && expander.hasClass('datagrid-row-collapse')){
						$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
						$('#gridLocInf').datagrid('expandRow',pindex);   //展开			
						
						obj.SelectAdmRow(EpisodeID,pindex,currPage);  //刷新明细表格			
					}
				}	
			}
			obj.MsgLoad(EpisodeID); //刷新单个患者消息
			$('#txtMessage'+EpisodeID).val('');
			$.messager.popover({msg: '消息发送成功！',type:'success',timeout: 2000});
		} else {
			$.messager.alert("提示", "消息发送失败！", "info");
			return;
		}
	}
	
	//发送消息更多
	btnMSend_click = function (EpisodeID,pindex,rindex) {
		// 1院感、2临床
		var MsgType=1;
		if (LocFlag==1) MsgType=2;
		
		obj.MMsg = $cm({
			ClassName:'DHCHAI.BTS.DictionarySrv',
			QueryName:'QryDic',
			aTypeCode:"CCScreenMessage",
			aActive:1
		},false);
		
		var htmlMMsg='<div id=ulqMsg'+EpisodeID+' style="text-align:right;">';
		for (var j=0;j<obj.MMsg.total;j++){
			var rd = obj.MMsg.rows[j];	
			var message=rd["DicDesc"];
			htmlMMsg += '<li style="list-style:none;" text="'+message+'"><a href="#" style="color:blue">'+message+'</a></li>';
		}
		htmlMMsg +='</div>';
		$('#btnMSend'+EpisodeID).popover({
			width:'300px',
			height:'200px',
			content:htmlMMsg,
			trigger:'hover',
			placement:'left',
			type:'html'
		});
		$('#btnMSend'+EpisodeID).popover('show');  
		
		$('#ulqMsg'+EpisodeID).delegate("li","click",function(e) {
			e.preventDefault();
			var MsgTxt = $(this).attr("text");
			if (MsgTxt == '') {
				$.messager.alert("提示", "消息内容不允许为空！", "info");
				return;
			}
			var retval = obj.Msg_Save("",EpisodeID,MsgType,MsgTxt,"0");
			if (parseInt(retval)>0){
				//切换图片
				$('#Message'+EpisodeID).toggleClass("write-message",false);
				$('#Message'+EpisodeID).toggleClass("yellow-message",true);
				$('.yellow-message').attr("src",'../scripts/DHCMA/HAI/img/消息-选中.png');
				
				if (pindex) { //存在左侧列表
					
					if (LocFlag==1) { //刷新科室明细列表	
						$('#gridAdmInfo').datagrid('updateRow', {
							index: pindex,
							row: {'IsMessage':1}
						});
					}else {  //刷新科室汇总列表
						if ( $('#gridLocInf').length <= 0 ){   //确诊未报等界面没有左侧科室列表不刷新
					        if ($('#gridPatList').length>0) {
						        gridPatListLoad();
					        }
					   	 	return;
					    }
						var currPage=1;
						var expander = $('#gridLocInf').datagrid('getExpander',pindex);  //获取展开行
						if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
							if (rindex>=0) {
								var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
								currPage = options.pageNumber; 
							}
						}
						$('#gridLocInf').datagrid('updateRow', {  //更新一行
							index: pindex
						});
						
						if(expander.length && expander.hasClass('datagrid-row-collapse')){
							$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
							$('#gridLocInf').datagrid('expandRow',pindex);   //展开
							
							obj.SelectAdmRow(EpisodeID,pindex,currPage);  //刷新明细表格
						}
					}
				}					
				obj.MsgLoad(EpisodeID); //刷新单个患者消息
				$('#txtMessage'+EpisodeID).val('');
				$.messager.popover({msg: '消息发送成功！',type:'success',timeout: 2000});
			} else {
				$.messager.alert("提示", "消息发送失败！", "info");
				return;
			}
		});
	}	
	
	//保存消息
	obj.Msg_Save=function(ID,EpisodeID,MsgType,MsgTxt,IsRead){	
		var CSEpisodeDr = EpisodeID;
		var CSMsgType   = MsgType;  // 1院感、2临床
		var CSMsgDate   = "";
		var CSMsgTime   = "";  //时间
		var CSMsgUserDr = $.LOGON.USERID;
		var CSMsgLocDr  = $.LOGON.LOCID;  
		var CSMessage   = MsgTxt;
		var CSIsRead    = IsRead;
		var CSReadDate  = "";
		var CSReadTime  = "";
		var CSReadUserDr = $.LOGON.USERID;		
		
		if (CSMessage == '') {
			$.messager.alert("提示", "消息内容不允许为空！", "info");
			return -1;
		}
		
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
	
		var retval  = $m({
			ClassName:"DHCHAI.IR.CCMessage",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:'^'
		},false);
		return retval;
	};
	// ****************************** ↑↑↑ 按钮事件
	
	// ****************************** ↓↓↓ 感染信息编辑
	
	//确诊操作
	obj.OperConfirm = function (EpisodeID,DiagID,ReportID,Bacterias) {
		var ScreenInfos = "";	
		for (var m=0;m<obj.ScreenData.length;m++) {						
			if (obj.ScreenData[m].OprStatus=='2') {   //单行确诊，排除无新项目产生，修改当前最后一条排除记录
				var retval  = $m({
					ClassName:"DHCHAI.IRS.CCScreeningSrv",
					MethodName:"UpdateFinalOper",
					aScreenID:obj.ScreenData[m].ScreenID, 
					aInfSuPosID:DiagID,
					aOperCode:1, 
					aOperUser:$.LOGON.USERID
				},false);
				
				if (parseInt(retval)>0){
					obj.gridScreenInfoLoad(EpisodeID);
					$.messager.popover({msg: '确诊成功！',type:'success',timeout: 2000});
					var SuspendCode = document.getElementById("txtSuspendCode" + EpisodeID).innerText;  //操作历史记录不修改当前状态	
					//排除、确诊操作刷新界面
					if (obj.pindex) { //存在左侧列表
						obj.RefreshTable(EpisodeID,obj.pindex,obj.rindex,SuspendCode);
					}	
					if ((LocFlag==1)&&(!ReportID)){
						$.messager.confirm("提示", "是否上报感染报告？", function(r){
							if (r){
								var strUrl="dhcma.hai.ir.inf.report.csp?1=1&EpisodeID=" +EpisodeID +"&DiagnosID=" +DiagID +"&Bacterias=" +Bacterias +"&ReportID="+ReportID+"&t=" + t;
								websys_showModal({
									url:strUrl,
									title:'感染报告',
									iconCls:'icon-w-epr',  
									originWindow:window,
									//closable:false,
									width:1320,
									height:window.screen.availHeight-80,
									onBeforeClose:function(){
										obj.gridScreenInfoLoad(EpisodeID);   //关闭报告后刷新编辑按钮才可正常显示	
										//排除、确诊操作刷新界面
										if (obj.pindex) { //存在左侧列表
											obj.RefreshTable(EpisodeID,obj.pindex,obj.rindex,SuspendCode);  //提交错误修改
										}	
									} 
								})
							} 
						});				
					}				
					return;										
				} else {
					$.messager.alert("提示", "确诊失败!", 'info');
					return;														
				}
			} else {
				var ScreenInfo = obj.ScreenData[m].ItmScreenID;      //疑似筛查项目
				ScreenInfo += '^' + obj.ScreenData[m].ItmScreenTxt;  //疑似筛查文本
				ScreenInfo += '^' + obj.ScreenData[m].RstFromDate;   //疑似开始日期
				ScreenInfo += '^' + obj.ScreenData[m].RstToDate;     //疑似结束日期
				ScreenInfo += '^' + obj.ScreenData[m].InfSuPosID;    //疑似诊断
				ScreenInfo += '^' + '';                              //疑似处置意见
				ScreenInfo += '^' + '';                              //疑似处置意见字典
				ScreenInfo += '^' + DiagID;                 //感染部位  
				ScreenInfos = ScreenInfos+","+ScreenInfo;			
			}
		}
		var retval  = $m({
			ClassName:"DHCHAI.IRS.CCScreeningSrv",
			MethodName:"SaveSuRuleOper",
			aEpisodeDr:EpisodeID, 
			aScreenInfos:ScreenInfos, 
			aOperCode:1, 
			aOperUser:$.LOGON.USERID,
			aOpinionDr:'',
			aOpinion:''
		},false);

		var rstArr = retval.split("^");
		
		if (parseInt(rstArr[0])>0){
			obj.gridScreenInfoLoad(EpisodeID);
			$.messager.popover({msg: '确诊成功！',type:'success',timeout: 2000});			
			$("#txtSuspendCode" + EpisodeID).html(rstArr[2]);
			$("#txtSuspendDesc" + EpisodeID).html(rstArr[3]);
			//排除、确诊操作刷新界面
			if (obj.pindex) { //存在左侧列表
				obj.RefreshTable(EpisodeID,obj.pindex,obj.rindex,rstArr[2]);
			}				
			if ((LocFlag==1)&&(!ReportID)) {
				$.messager.confirm("提示", "是否上报感染报告？", function(r){
					if (r){
						var strUrl="dhcma.hai.ir.inf.report.csp?1=1&EpisodeID=" +EpisodeID +"&DiagnosID=" +DiagID +"&Bacterias=" +Bacterias +"&ReportID="+ReportID+"&t=" + t;
						websys_showModal({
							url:strUrl,
							title:'感染报告',
							iconCls:'icon-w-epr',  
							originWindow:window,
							//closable:false,
							width:1320,
							height:window.screen.availHeight-80,
							onBeforeClose:function(){
								obj.gridScreenInfoLoad(EpisodeID);   //关闭报告后刷新编辑按钮才可正常显示
								//排除、确诊操作刷新界面
								if (obj.pindex) { //存在左侧列表
									obj.RefreshTable(EpisodeID,obj.pindex,obj.rindex,rstArr[2]);
								}	
							} 
						})
					}
				});
			}
			return;			
		} else {
			$.messager.alert("提示", "确诊失败!", 'info');
			return;				
		}					
	}
	
	//打开合并感染诊断
	obj.RepInfoDialog = function (EpisodeID,rows) {	
		$('#InfDiagnos').show();
		obj.RepInfoList(EpisodeID,rows);
		$HUI.dialog('#InfDiagnos',{
			title:'感染诊断信息',
			iconCls:'icon-w-paper', 
			width:580,
			height:392,  
			resizable:true,
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){
					var DiagID = obj.InfDiagnos_Save(EpisodeID,obj.DiagID,obj.AdmDate,obj.DischDate);
					if (!DiagID) return;
					if(parseInt(DiagID)>0){
						obj.OperConfirm(EpisodeID,DiagID,obj.ReportID,obj.Bacterias);	   //操作确诊
						$HUI.dialog('#InfDiagnos').close();
						obj.gridScreenInfoLoad(EpisodeID);	
					}else{	
						$.messager.alert("提示","感染信息保存失败！",info);
					}				
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#InfDiagnos').close();
				}
			}]
		});
	}
	
	//合并感染诊断
	obj.RepInfoList = function(aEpisodeID,rs) {	
	    $('#IsNewInfRow').removeAttr('style');
		$('#chkIsNewInf').checkbox('setValue',false);    //是否新发感染  否		
        $('#cboInfPos').combobox('disable');
		$('#dtInfDate').datebox('disable');	
	
		$HUI.datagrid("#RepInfoList",{
			showHeader:false, 
			headerCls:'panel-header-gray',
			iconCls:'icon-resort',
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏	
			autoRowHeight: true,
			singleSelect: true,
			nowrap: true,
			title:'历史感染信息',
			loadMsg:'数据加载中...',
			columns:[[						
				{field:'InfPos',title:'感染信息',width:208,
					formatter: function(value,row,index){					
						return "<div style='line-height:25px;'>"+value+ "<a style='font-size:12px;color:#00BFFF'>"+((row.InfType=='0') ? ' (院外)':'')+"</a><br>"+row.InfDate+" "+"<a style='font-size:12px;color:red'>"+((row.ReportID) ? '('+row.RepDate+')':'(未报)')+"</a></div>";
					}
				}
			]],
			onSelect:function(rowIndex, rowData){
				obj.SetDialogValue(aEpisodeID);
			}
			
		});	
		$('#RepInfoList').datagrid('loadData', rs);
		$('#RepInfoList').datagrid('selectRow', 0);   //默认选中第一条记录
	}

	//感染诊断窗口初始化
	obj.InitDialog = function(){
	    $('#chkIsNewInf').checkbox('setValue',false);	
		obj.cboInfPos = $HUI.combobox("#cboInfPos", {
			editable: true,       
			defaultFilter:4,     
			valueField: 'ID',
			textField: 'Desc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=array&aPosFlg=2";
			   	$("#cboInfPos").combobox('reload',url);
			},
			onChange:function(newValue,oldValue){	
				$('#cboInfSub').combobox('clear');
			}
		});
		
		obj.cboInfSub = $HUI.combobox("#cboInfSub", {
			editable: false,       
			defaultFilter:4,     
			valueField: 'ID',
			textField: 'Desc',			
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCHAI.BTS.InfSubSrv&QueryName=QryInfSubByPosID&ResultSetType=array&aPosID="+$('#cboInfPos').combobox('getValue');
				$("#cboInfSub").combobox('reload',url);
			}
		});
		//感染转归字典
		obj.cboInfEffect = Common_ComboDicID("cboInfEffect","InfDiseasePrognosis");
		//与死亡关系字典
		obj.cboDeathRelation = Common_ComboDicID("cboDeathRelation","RepDeathRelative");

	} 
	
	// 感染信息赋值 
	obj.SetDialogValue = function(aEpisodeID){
		obj.InitDialog(); 	
		obj.EpisodeID =  aEpisodeID;
		var IsNewInf = $('#chkIsNewInf').checkbox('getValue');
		if (IsNewInf) {
			$('#cboInfPos').combobox('enable');
			$('#dtInfDate').datebox('enable');
		}else {
			$('#cboInfPos').combobox('disable');
			$('#dtInfDate').datebox('disable');	 
		}
		 
		var rd = $('#RepInfoList').datagrid('getSelected');	
		if (rd)  {
			obj.DiagID = rd.DiagID;
			obj.ReportID = rd.ReportID;
			
			var InfPosID  = rd.InfPosID;
			var InfPos    = rd.InfPos;
			var InfSubID  = rd.InfSubID;
			var InfSub    = rd.InfSub;
			var InfDate   = rd.InfDate;
			var InfXDate  = rd.InfXDate;
			var InfEffectID  = rd.InfEffectID;
			var InfEffect    = rd.InfEffect;
			var DeathRelationID  = rd.DeathRelationID;
			var DeathRelation    = rd.DeathRelation;
			var IsReportDiag     = rd.IsReportDiag;
			var InfType          = rd.InfType;
		  
			if (InfType==0) {
				$HUI.radio('#radInfType-0').setValue(true);
			}else {
				$HUI.radio('#radInfType-1').setValue(true);
			}
			
			$('#cboInfPos').combobox('setValue',InfPosID);
			$('#cboInfPos').combobox('setText',InfPos);
			$('#cboInfSub').combobox('setValue',InfSubID);
			$('#cboInfSub').combobox('setText',InfSub);
			$('#dtInfDate').datebox('setValue',InfDate);
			$('#dtInfXDate').datebox('setValue',InfXDate);
			$('#cboInfEffect').combobox('setValue',InfEffectID);
			$('#cboInfEffect').combobox('setText',InfEffect);
			$('#cboDeathRelation').combobox('setValue',DeathRelationID);
			$('#cboDeathRelation').combobox('setText',DeathRelation);
			
			if (!IsReportDiag) {  // 是否临床上报诊断
				if (LocFlag==1) {
					obj.IsReportDiag = 1;
				}else {
					obj.IsReportDiag = 0;
				}
			}else{
				obj.IsReportDiag =IsReportDiag;
			}	
		}else {
			$('#cboInfPos').combobox('clear');
			$('#cboInfSub').combobox('clear');		
			$('#dtInfDate').datebox('clear');
			$('#dtInfXDate').datebox('clear');	
			$('#cboInfEffect').combobox('clear');
			$('#cboDeathRelation').combobox('clear');
		}
	}
	//是否新发感染选择事件
	$HUI.checkbox("[name='chkIsNewInf']",{  
		onCheckChange:function(event,value){		
			if (value) {     //当前选中的值 是				
				$HUI.radio('input[type=radio][name=radInfType]').uncheck();	
				$("#RepInfoList").datagrid('clearSelections');  //取消历史选中	
				obj.SetDialogValue(obj.EpisodeID);
				obj.DiagID = '';
				obj.ReportID = '';	
			}else {
				$('#chkIsNewInf').checkbox('setValue',false);
				var rd = $('#RepInfoList').datagrid('getSelected');
				if (!rd) {   //先判断选中，无选中行默认第一条记录
					 $('#RepInfoList').datagrid('selectRow', 0);   //默认选中第一条记录
				}   
		 		obj.SetDialogValue(obj.EpisodeID);			
			}
		}
	});
	
	
	//感染诊断窗口初始化
	obj.InitInfDialog = function(EpisodeID,rowData){ 
	    $('#InfDiagnos').show(); 		
		obj.InitDialog();
		$('#IsNewInfRow').css('display','none');
		$('#cboInfPos').combobox('enable');
		$('#dtInfDate').datebox('enable');
        obj.EpisodeID = EpisodeID;	
		if (rowData) {
			var arrData   = rowData.split("^");
			var InfPosID  = arrData[1];
			var InfPos    = arrData[2];
			var InfSubID  = arrData[3];
			var InfSub    = arrData[4];
			var InfDate   = arrData[5];
			var InfXDate  = arrData[10];
			var InfEffectID  = arrData[11];
			var InfEffect    = arrData[12];
			var DeathRelationID  = arrData[13];
			var DeathRelation    = arrData[14];
			var IsReportDiag     = arrData[15];
			var InfType          = arrData[18];
		    
			if (InfType==0) {
				$HUI.radio('#radInfType-0').setValue(true);
			}else {
				$HUI.radio('#radInfType-1').setValue(true);
			}
			$('#cboInfPos').combobox('setValue',InfPosID);
			$('#cboInfPos').combobox('setText',InfPos);
			$('#cboInfSub').combobox('setValue',InfSubID);
			$('#cboInfSub').combobox('setText',InfSub);
			$('#dtInfDate').datebox('setValue',InfDate);
			$('#dtInfXDate').datebox('setValue',InfXDate);
			$('#cboInfEffect').combobox('setValue',InfEffectID);
			$('#cboInfEffect').combobox('setText',InfEffect);
			$('#cboDeathRelation').combobox('setValue',DeathRelationID);
			$('#cboDeathRelation').combobox('setText',DeathRelation);
			if (!IsReportDiag) {  // 是否临床上报诊断
				if (LocFlag==1) {
					obj.IsReportDiag = 1;
				}else {
					obj.IsReportDiag = 0;
				}
			}else{
				obj.IsReportDiag =IsReportDiag;
			}	
		}else {
			$('#cboInfPos').combobox('clear');
			$('#cboInfSub').combobox('clear');		
			$('#dtInfDate').datebox('clear');
			$('#dtInfXDate').datebox('clear');	
			$('#cboInfEffect').combobox('clear');
			$('#cboDeathRelation').combobox('clear');
		}	
	} 
		
	//确诊保存感染信息
	obj.InfDiagnos_Save = function(EpisodeID,InfDiagID,AdmDate,DischDate) {
		obj.InputDiag 	= obj.Diag_Save(EpisodeID,InfDiagID,AdmDate,DischDate);	// 感染信息	
        if (!obj.InputDiag) {
			return ;
		}	
		var retval  = $m({
			ClassName:"DHCHAI.IR.INFDiagnos",
			MethodName:"Update",
			aInputStr:obj.InputDiag,
			aSeparete:CHR_1
		},false);
	
		return retval;
	}
	
	//感染信息
	obj.Diag_Save = function (EpisodeID,InfDiagID,AdmDate,DischDate) {
		var errorStr = '';
		
		var InfType = Common_RadioValue("radInfType");
		var InfPosID = $('#cboInfPos').combobox('getValue');
		var InfSubID = $('#cboInfSub').combobox('getValue');
		var InfDate = $('#dtInfDate').datebox('getValue');
		var InfXDate = $('#dtInfXDate').datebox('getValue');
		var InfEffectID = $('#cboInfEffect').combobox('getValue');
		var InfEffect = $('#cboInfEffect').combobox('getText');
		var DeathRelationID = $('#cboDeathRelation').combobox('getValue');
	   
		var NowDate = Common_GetDate(new Date()); 
		if (!InfPosID) {
			errorStr = errorStr + "请填写感染诊断!<br>"; 
		}
		if (!InfType) {
			errorStr = errorStr + "请填写诊断类型!<br>"; 
		}
		if (!InfDate) {
			errorStr = errorStr + "请填写感染日期!<br>"; 
		}else {	
			if (InfType==1){  //医院感染
				if ((Common_CompareDate(AdmDate,InfDate)>0)||(Common_CompareDate(InfDate,DischDate)>0)||(Common_CompareDate(InfDate,NowDate)>0)) {
					errorStr = errorStr + "感染时间需要在住院期间且不应超出当前日期!<br>"; 
				}
			}else {
				if ((Common_CompareDate(InfDate,DischDate)>0)||(Common_CompareDate(InfDate,NowDate)>0)) {
					errorStr = errorStr + "社区感染时间需要在出院之前且不应超出当前日期!<br>"; 
				}
			}
		}
		if (InfXDate) {
			if (Common_CompareDate(InfDate,InfXDate)>0){
    			errorStr = errorStr + "感染结束日期不能在感染日期之前!<br>"; 
    		}
			if ((Common_CompareDate(InfXDate,DischDate)>0)||(Common_CompareDate(InfXDate,NowDate)>0)) {
				errorStr = errorStr + "感染结束日期需在住院期间且不应超出当前日期!<br>"; 
			}
    		if (!InfEffectID){
				errorStr = errorStr + "感染结束后感染转归不能为空!<br>"; 
		    }
		} else {
			if ((InfEffect=='治愈')||(InfEffect=='死亡')||(InfEffect=='好转')){
				errorStr = errorStr + "感染转归为治愈、死亡、好转感染结束日期不能为空!<br>"; 
			}
		}
		
		if ((InfEffect=='死亡')&&(!DeathRelationID)) {
			errorStr = errorStr + "感染转归为死亡、死亡病例，请填写感染与死亡关系!<br>"; 
		}
		if (errorStr!="") { 
			$.messager.alert("提示", errorStr, 'info');
			return ; 
		}
		// 感染信息
		var Input = InfDiagID;
		Input = Input + CHR_1 + EpisodeID;
		Input = Input + CHR_1 + InfPosID;
		Input = Input + CHR_1 + InfSubID;
		Input = Input + CHR_1 + InfDate;
		Input = Input + CHR_1 + '';
		Input = Input + CHR_1 + '';
		Input = Input + CHR_1 + '';
		Input = Input + CHR_1 + InfXDate;
		Input = Input + CHR_1 + InfEffectID;
		Input = Input + CHR_1 + DeathRelationID;
		Input = Input + CHR_1 + '';
		Input = Input + CHR_1 + '';
		Input = Input + CHR_1 + $.LOGON.USERID;
		Input = Input + CHR_1 + obj.IsReportDiag;	// 是否临床上报诊断
		Input = Input + CHR_1 + '';                 // 病原体
		Input = Input + CHR_1 + 1;                  // 是否有效
		Input = Input + CHR_1 + InfType;            // 社区感染0、医院感染1
		return Input;
	}
	
	//编辑感染诊断窗口弹出
	obj.InfDiagnosDialog = function(EpisodeID,InfDiagID,AdmDate,DischDate) {
		//$('#IsNewInfRow').css('display','none');
		$HUI.dialog('#InfDiagnos',{
			title:'感染信息',
			iconCls:'icon-w-paper', 
			width:360,
			height:360, 
			resizable:true,
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){
					var DiagID = obj.InfDiagnos_Save(EpisodeID,InfDiagID,AdmDate,DischDate);
					if (!DiagID) return;
					if(parseInt(DiagID)>0){
						$.messager.popover({msg: '感染信息保存成功！',type:'success',timeout: 2000});
						$HUI.dialog('#InfDiagnos').close();
						obj.gridScreenInfoLoad(EpisodeID);
					}else{	
						$.messager.alert("提示","感染信息保存失败！",info);
					}				
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#InfDiagnos').close();
				}
			}]
		});
	}
	
	// ****************************** ↑↑↑ 感染信息编辑
	

	// ****************************** ↓↓↓ 审核感染报告
	//患者感染报告列表
	obj.gridRepList = function(EpisodeID) {	
		$HUI.datagrid("#gridRepList",{
			fit:true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏	
			fitColumns: true,
			autoRowHeight: true,
			singleSelect: true,
			rownumbers: true,
			loadMsg:'数据加载中...',
			columns:[[
				{field:'ReportID',title:'报告编号',width:80},	 				
				{field:'RepStatus',title:'状态',width:100},
				{field:'InfTypeDesc',title:'感染类型',width:100},				
				{field:'InfPos',title:'感染诊断',width:200},	 				
				{field:'InfDate',title:'感染日期',width:100},	
				{field:'ReportDate',title:'报告日期',width:100},	 				
				{field:'ReportLocDesc',title:'报告科室',width:120},	
				{field:'ReportUserDesc',title:'报告人',width:100}							
			]],
			onSelect:function(rindex,rowData){
				var RepStatus = rowData.RepStatus;
				if ((RepStatus=="保存")||(RepStatus=="提交")) {    
					$("#btnCheckRep").linkbutton("enable");	
				}else {
					$("#btnCheckRep").linkbutton("disable");
				}
				if (rindex>-1) {
					obj.gridRepDetailLoad(rowData.ReportID);
				}
			},
			rowStyler: function(index,row){
				if (row.RepStatus=="提交"){
					return 'color:red;'; // return inline style
				}
				if (row.RepStatus=="审核"){
					return 'color:green;'; // return inline style
				}
			}
		});	
		obj.gridRepListLoad(EpisodeID);
		//审核按钮
		$('#btnCheckRep').on('click', function(){
			obj.btnCheckRep_click(EpisodeID);
		});
		
	}
	//加载患者感染报告列表
	obj.gridRepListLoad= function(EpisodeID) {
		$cm ({
			ClassName:'DHCHAI.IRS.INFDiagnosSrv',
			QueryName:'QryInfRepList',
			aEpisodeID:EpisodeID
		},function(rs){
			$('#gridRepList').datagrid('loadData', rs);				
		});	
	}
	//患者感染报告明细
    obj.gridRepDetail = function() {
		$HUI.datagrid("#gridINFOPS",{ 
			fitColumns: true,
			autoRowHeight: true,
			rownumbers: true, //如果为true, 则显示一个行号列
			loadMsg:'数据加载中...',
			columns:[[
				{field:'OperName',title:'手术名称',width:200},
				{field:'OperType',title:'手术类型',width:90},
				{field:'OperLoc',title:'手术科室',width:130},
				{field:'OperDate',title:'手术开始时间',width:100,
					formatter: function(value,row,index){
						return row.OperDate+" "+row.SttTime;	
					}
				},
				{field:'EndDate',title:'手术结束时间',width:100,
					formatter: function(value,row,index){
						return row.EndDate+" "+row.EndTime;	
					}
				},
				{field:'OperDocTxt',title:'手术医生',width:90},
				{field:'Anesthesia',title:'麻醉方式',width:80},
				{field:'CuteType',title:'切口类型',width:70},
				{field:'NNISLevel',title:'NNIS分级',width:75},
				{field:'CuteHealing',title:'愈合情况',width:70,align:'center'},
				{field:'IsOperInf',title:'切口感染',width:70,align:'center',
					formatter: function(value,row,index){
						if (value==1){
							return "是";
						}else {
							return "否";
						}
					}
				},
				{field:'InfType',title:'感染类型',width:80},
				{field:'IsInHospInf',title:'引起院感',width:70,align:'center',
					formatter: function(value,row,index){
						if (value==1){
							return "是";
						}else {
							return "否";
						}
					}
				}
			]]
		});
			
		$HUI.datagrid("#gridINFLab",{ 
			fitColumns: true,
			autoRowHeight: true,
			rownumbers: true, //如果为true, 则显示一个行号列
			loadMsg:'数据加载中...',
			columns:[[
				{field:'TSDesc',title:'检验医嘱',width:300},
				{field:'SubmissLoc',title:'送检科室',width:160},
				{field:'Specimen',title:'标本',width:120},
				{field:'SubmissDate',title:'送检日期',width:100},
				{field:'AssayMethod',title:'检验方法',width:120},
				{field:'RuleMRBs',title:'病原体',width:300},
				{field:'PathogenTest',title:'病原学检验结果',width:120}
			]]
		});
		
		$HUI.datagrid("#gridINFAnti",{ 
			fitColumns: true,
			autoRowHeight: true,
			rownumbers: true, //如果为true, 则显示一个行号列
			loadMsg:'数据加载中...',
			columns:[[
				{field:'AntiDesc',title:'抗生素',width:140},
				{field:'SttDate',title:'开始日期',width:90},
				{field:'EndDate',title:'结束日期',width:90},
				{field:'DoseQty',title:'剂量',width:45},
				{field:'DoseUnit',title:'剂量<br>单位',width:45},
				{field:'PhcFreq',title:'频次',width:100},
				{field:'MedUsePurpose',title:'用途',width:80},
				{field:'AdminRoute',title:'给药途径',width:80},
				{field:'MedPurpose',title:'目的',width:60},
				{field:'TreatmentMode',title:'治疗用药<br>方式',width:75},
				{field:'PreMedEffect',title:'预防用药<br>效果',width:75},
				{field:'PreMedIndicat',title:'预防用药<br>指征',width:70},
				{field:'CombinedMed',title:'联合用药',width:75},
				{field:'PreMedTime',title:'术前用药<br>时间(分钟)',width:75},
				{field:'PostMedDays',title:'术后用药<br>天数',width:65},
				{field:'SenAna',title:'敏感度',width:55}
			]]
		});
	}
	
	//加载感染信息明细
    obj.gridRepDetailLoad = function(ReportID){	
		$cm ({
			ClassName:"DHCHAI.IRS.INFOPSSrv",
			QueryName:"QryINFOPSByRep",		
			aReportID: ReportID
		},function(rs){
			$('#gridINFOPS').datagrid('loadData', rs);				
		});
			
		$cm ({
			ClassName:"DHCHAI.IRS.INFLabSrv",
			QueryName:"QryINFLabByRep",		
			aReportID: ReportID
		},function(rs){
			$('#gridINFLab').datagrid('loadData', rs);				
		});	
		
		$cm ({
			ClassName:"DHCHAI.IRS.INFAntiSrv",
			QueryName:"QryINFAntiByRep",		
			aReportID: ReportID
		},function(rs){
			$('#gridINFAnti').datagrid('loadData', rs);				
		});	
    }
	//审核报告
	obj.btnCheckRep_click = function (EpisodeID) {
		var rd = $('#gridRepList').datagrid('getSelected');
		var ReportID = rd.ReportID;
	
		obj.SaveStatus(ReportID,3,EpisodeID);
	}
	
	// 保存报告状态
	obj.SaveStatus = function(ReportID,StatusCode,EpisodeID){
		var Opinion ='';
		var InputRepLog = ReportID;
		InputRepLog = InputRepLog + CHR_1 + StatusCode;		//状态
		InputRepLog = InputRepLog + CHR_1 + Opinion;
		InputRepLog = InputRepLog + CHR_1 + $.LOGON.USERID;
		
		var ret =  $m({
			ClassName:"DHCHAI.IRS.INFReportSrv",
			MethodName:"SaveINFReportStatus",
			aRepLog :InputRepLog, 
			separete:CHR_1
		},false);
		
    	if (parseInt(ret)>0){
    		$.messager.popover({msg: '操作成功！',type:'success',timeout: 2000});
			obj.gridRepListLoad(EpisodeID);
			return true;
		} else {
			$.messager.alert("提示", "操作失败！", "info");
    		return false;
    	}
	}
	// ****************************** ↑↑↑ 审核感染报告

    // ****************************** ↓↓↓ 刷新数据
   	//刷新左侧数据
    obj.RefreshTable = function(EpisodeID,pindex,rindex,aSuspendCode) {	
		if (LocFlag==1) {    //刷新科室明细列表	
			var ConfRepCnt  = $m({
				ClassName:"DHCHAI.IRS.CCScreeningSrv",
				MethodName:"GetConfRepCnt",
				aEpisodeID:EpisodeID
			},false);
			var CntArr = ConfRepCnt.split("^");
			var NeedRepCnt = CntArr[0]-CntArr[1];
			if (NeedRepCnt<0) NeedRepCnt=0;
			var Accordion = $('#divAccordion').accordion('getSelected');
			if (Accordion){
				var index = $('#divAccordion').accordion('getPanelIndex', Accordion);
				if (index==1) {
					$('#gridDutyList').datagrid('updateRow', {
						index: pindex,
						row: {
							'SuspendCode':aSuspendCode,
							'NeedRepCnt':NeedRepCnt
						}
					});
				}else {
					$('#gridAdmInfo').datagrid('updateRow', {
						index: pindex,
						row: {
							'SuspendCode':aSuspendCode,
							'NeedRepCnt':NeedRepCnt
						}
					});
				}
			}
		}else {   //刷新科室汇总、科室明细列表	
		    if ( $('#gridLocInf').length <= 0 ){   //确诊未报等界面没有左侧科室列表不刷新
		        if ($('#gridPatList').length>0) {
			        gridPatListLoad();
		        }
		   	 	return;
		    }		    
			var currPage=1;
			var expander = $('#gridLocInf').datagrid('getExpander',pindex);  //获取展开行
			if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
				if (rindex>=0) {
					var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
					currPage = options.pageNumber; 
				}
			}
			
			var rows = $('#gridLocInf').datagrid('getSelected',pindex);
			var LocID = rows.LocID;		
			var PatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
			var LocInfo = $cm({
				ClassName:"DHCHAI.IRS.CCScreeningSrv",
				QueryName:"QrySuRuleLocList",
				aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
				aDateFrom:$('#aDateFrom').datebox('getValue'), 
				aDateTo:$('#aDateTo').datebox('getValue'), 
				aHospIDs:$('#cboHospital').combobox('getValue'), 
				aViewFlag:2,	
				aGroupUser:$('#cboGroup').combobox('getText'),
				aPatInfo:PatInfo,
				aLocID:LocID
			},false);
			
			var ScreenProCnt = LocInfo.rows[0].ScreenProCnt;
			var ConfirmCnt = LocInfo.rows[0].ConfirmCnt;
			var DiagNoRepCnt = LocInfo.rows[0].DiagNoRepCnt;		
		   
			$('#gridLocInf').datagrid('updateRow', {
				index: pindex,
				row: {
					'ScreenProCnt':ScreenProCnt,
					'ScreenLogCnt':DiagNoRepCnt+" / "+ConfirmCnt
				}
			});
			
			if(expander.length && expander.hasClass('datagrid-row-collapse')){
				$('#gridLocInf').datagrid('collapseRow',pindex); //折叠
				$('#gridLocInf').datagrid('expandRow',pindex);   //展开						
				obj.SelectAdmRow(EpisodeID,pindex,currPage);  //刷新明细表格						
			}
					
		}	
	}	
   
   //刷新并选中明细表格数据
   obj.SelectAdmRow = function(EpisodeID,pindex,currPage){
		$('#gridAdmInfo'+pindex).datagrid({
			pageNumber:currPage,
			/*			
			onBeforeLoad: function (param) {  //加载两遍才能正确定位翻页
	            var firstLoad = $(this).attr("firstLoad");
	            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
	            {
	                $(this).attr("firstLoad","true");
	                return false;
	            }
	            return true;
			},
			*/
			onLoadSuccess:function(data) {
				//获取数据列表中的所有数据
				var rows = data.rows;
				var length = rows.length;
				
				//循环数据找出列表中ID和需要选中数据的ID相等的数据并选中
				for(var i=0;i<length;i++){
					var rowIdID = rows[i].EpisodeID;  
					if(rowIdID==EpisodeID){
						var index = $('#gridAdmInfo'+pindex).datagrid("getRowIndex",rows[i]);
						$('#gridAdmInfo'+pindex).datagrid('scrollTo', index); //滚动到指定行
						$('#gridAdmInfo'+pindex).datagrid('selectRow', index); //选中指定行
					}
				}
		        
				setTimeout(function () {
					$('#gridLocInf').datagrid('fixDetailRowHeight', pindex);
				}, 0);
			}
		});	
   }
	// ****************************** ↑↑↑ 刷新数据
}


