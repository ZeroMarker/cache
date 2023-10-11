//页面Event
function InitCPImplWinEvent(obj) {
	obj.LoadEvent = function (args) {
		obj.InitCPWInfo();	//路径信息
		obj.tabType = "T";
		obj.tabVarType = "I";
		obj.FormID="";
		TreatRowID=""
		NurRowID=""
		$HUI.tabs("#CPW-main", {
			onSelect: function (title,index) {
				var tab = $('#CPW-main').tabs('getTab',index);
				var tabID=tab[0].id
				$.parser.parse("#"+tabID);
				switch (title) {
					case "主要诊疗工作":
						obj.tabType = "T";
						obj.TQueryLoad();
						break;
					case "主要护理工作":
						obj.tabType = "N";
						obj.NQueryLoad();
						break;
					case "重点医嘱":
						obj.tabType = "O";
						obj.OQueryLoad();
						break;
					case "变异原因":
						obj.tabType = "V";
						obj.tabVarType = "N";
						obj.VQueryLoad();
						break;
				}
			}
		});
		if (UserType == "N") {
			$('#CPW-main').tabs('select', $g("主要护理工作"));
		}
		if (UserType != "N") {
			$('#dd').layout('remove','west');
		}
		$HUI.tabs("#CPW-Var", {
			onSelect: function (title,index) {
				var tab = $('#CPW-Var').tabs('getTab',index);
				var tabID=tab[0].id
				$.parser.parse("#"+tabID);
				switch (title) {
					case "路径外医嘱":
						obj.tabVarType = "O";
						obj.VQueryLoad();
						break;
					case "表单项目":
						obj.tabVarType = "I";
						obj.VQueryLoad();
						break;
					case "未执行项目":
						obj.tabVarType = "N";
						obj.VQueryLoad();
						break;
				}
			}
		});
		//查看本科室路径(未入径页面)
		$('#LookCPWList').on('click', function () {
			obj.ShowCPWList(session['DHCMA.CTLOCID'],obj.searchValue);
		});
		if (UserType == "N") {
			$('#LookCPWList').linkbutton("disable");//路径列表按钮
		}
		//切换路径弹窗
		$('#btnChange').on('click', function () {
			//增加付费病种出组检查提醒
			if (parseInt(IsOpenPCSDMod)==1&&obj.PCSDStatus==$g("入组")){
				var chkSDRet = $m({
					ClassName: "DHCMA.CPW.SDS.PCIOToCPWSrv",
					MethodName: "IsMatchCEntity",
					aPathwayID: obj.PathwayID
				}, false)
				if (parseInt(chkSDRet)>0) {
					$.messager.confirm($g("提示"), $g("切换路径将退出当前付费病种入组并同时退出单病种付费，是否继续?"), function (r) {
						if (r) {
							obj.ShowChangeCPW();
						} else {
							return;
						}
					});
				}	
			}else{
				obj.ShowChangeCPW();	
			}
		})
		//切换
		$('#btn-CgCPWDialog').on('click', function () {
			if(obj.NewStepID){
				obj.BtnChangeCPW();
			}else{ 
        /*update by dengshaopeng 2019-08-15 切换路径不选择目标阶段提醒*/
				$.messager.popover({
							msg: $g('请选择目标阶段'),
							type: 'error',
							style: {
								top: 150,
								left: 450
							}
						});
			}
			
		})
		//医生签名
		$('#btnDoc').on('click', function () {
			obj.SignStep();
		})
		//护士签名
		$('#btnNur').on('click', function () {
			obj.SignStep();
		})
		//确定按钮
		$('#btnSave').on('click', function () {
			obj.ConfirmStep();
		})
    	//阶段退回操作
		$('#btnChangeEp').on('click',function(){
			obj.RevokeStep();
		})
		//出径弹窗
		$('#btnOut').on('click', function () {
			//增加付费病种出组检查提醒
			if (parseInt(IsOpenPCSDMod)==1&&obj.PCSDStatus==$g("入组")){
				var chkSDRet = $m({
					ClassName: "DHCMA.CPW.SDS.PCIOToCPWSrv",
					MethodName: "IsMatchCEntity",
					aPathwayID: obj.PathwayID
				}, false)
				if (parseInt(chkSDRet)>0) {
					$.messager.confirm($g("提示"), $g("出径将退出当前付费病种入组并同时退出单病种付费，是否继续?"), function (r) {
						if (r) {
							$HUI.dialog('#OutCPWDialog').open();
						} else {
							return;
						}
					});
				}	
			}else{
				$HUI.dialog('#OutCPWDialog').open();	
			}
		})
		//出径
		$('#btn-OutCPWDialog').on('click', function () {
			obj.OutCPW();
		})
		
		//作废弹窗
		$('#btnUCancel').on('click', function () {
			$HUI.dialog('#UCanCPWDialog').open();	
		})
		//作废
		$('#btn-UCanCPWDialog').on('click', function () {
			obj.UCanCPW();
		})
		//展现单病种表单
		$('#btnSD').on('click', function () {
			obj.ShowSD();
		})
		//完成
		$('#btnClose').on('click', function () {
			if (parseInt(IsOpenPCSDMod)==1&&obj.PCSDStatus=="入组"){
				//添加付费病种入组符合性校验
				var chkSDRet = $m({
					ClassName: "DHCMA.CPW.SDS.PCIOToCPWSrv",
					MethodName: "CheckPCSD",
					aEpisodeID: EpisodeID,
					aPathwayID: obj.PathwayID
				}, false)
				if (chkSDRet.split("^")[0]=="0") {
					$.messager.alert($g("提示"), $g("该患者")+chkSDRet.split("^")[1]+$g("，禁止完成路径，请先进行付费病种出组操作！"), "info")
					return;
				}	
			}
			obj.CloseCPW();
		})
		//未执行项目保存变异信息
		$('#Var-Item-Save').on('click', function () {
			obj.SaveItemVar();
		})
		//未执行项目撤销变异信息
		$('#Var-Item-Cancel').on('click', function () {
			obj.CancelItemVar();
		})
		//路径外医嘱保存变异信息
		$('#Var-Order-Save').on('click', function () {
			obj.SaveOrderVar();
		})
		//路径外医嘱撤销变异信息
		$('#Var-Order-Cancel').on('click', function () {
			obj.CancelOrderVar();
		})
		
		// 知情同意书打印
		$('#PrintCPWInformedConsert').on('click', function () {
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintCPWInformedConsert");  //打印任务的名称
			LODOP.ADD_PRINT_HTM("285mm", "90mm",300,100,"<span tdata='pageNO'>"+$g("第##页")+"</span>/<span tdata='pageCount'>"+$g("共##页")+"</span>");
			LODOP.SET_PRINT_STYLEA(0, "ItemType",1);//每页都输出
			//LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0); 	//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
			//LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);			//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
			LodopPrintURL(LODOP,"./dhcma.cpw.cp.consentprint.csp?EpisodeID="+EpisodeID+"&HospID="+session['DHCMA.HOSPID'],"10mm","12mm","6mm","20mm")
			LODOP.PRINT();
		});
		
		// 路径表单打印
		$('#PrintCPWInform').on('click', function () {
			// 打印前进行出院项目检查
			var retChk = $m({
				ClassName: "DHCMA.CPW.CPS.ImplementSrv",
				MethodName: "AutoExeDischItem",
				aPathwayID: obj.PathwayID,
				aEpisodeID: EpisodeID,
				aHospID:session['DHCMA.HOSPID']
			}, false)
			if (retChk == "1"){
				var LODOP=getLodop();
				LODOP.PRINT_INIT("PrintCPWInform");  //打印任务的名称
				LODOP.ADD_PRINT_HTM("285mm", "90mm",300,100,"<span tdata='pageNO'>"+$g("第##页")+"</span>/<span tdata='pageCount'>"+$g("共##页")+"</span>");
				LODOP.SET_PRINT_STYLEA(0, "ItemType",1);//每页都输出
				//LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0); 	//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
				//LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);			//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
				LodopPrintURL(LODOP,"./dhcma.cpw.cp.lodopprint.csp?EpisodeID="+EpisodeID+"&HospID="+session['DHCMA.HOSPID'],"10mm","12mm","6mm","20mm")
				LODOP.PRINT();
			}else{
				$.messager.popover({msg: $g('操作失败，请稍后重试！'),type: 'error'});	
			}
		});
		$('#CPWSur').on('click', function () {
			var strUrl= "./dhcma.cpw.cp.survey.csp?1=1&Code=" + Code + "&EpisodeID=" + EpisodeID ;
		    websys_showModal({
				url:strUrl,
				title:$g('满意度调查表'),
				iconCls:'icon-w-epr',  
		        originWindow:window,
		        closable:true,
				width:1150,
				height:'90%'  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			});
		});
		$('#btnShow').on('click', function () {
			var FormUrl="./dhcma.cpw.cp.form.csp?EpisodeID="+EpisodeID+"&UserType="+UserType;
			websys_showModal({
				url:FormUrl,
				title:$g('表单总览'),
				iconCls:'icon-w-import',  
				closable:true,
				originWindow:window,
				width:"95%", //screen.availWidth-100,
				height:"95%", //screen.availHeight-100,  
				onBeforeClose:function(){
					obj.InitCPWInfo();;  //刷新
				}
			});	
		});
		
		//付费病种出组
		$('#btnOutPCSD').on('click', function () {
			obj.GetOutPCSD();
		})
		
		//添加合并症
		$("#btnAddCompl").on('click', function(){
			//console.log("obj.PathwayID="+obj.PathwayID);
			var FormUrl="./dhcma.cpw.cp.pathcompl.csp?EpisodeID="+EpisodeID+"&PathwayID="+obj.PathwayID;
			websys_showModal({
				url:FormUrl,
				title:$g('关联合并症'),
				iconCls:'icon-w-import',  
				closable:true,
				originWindow:window,
				width:1100,
				height:600,
				onClose:function(){
					obj.InitCPWInfo();
				}
			});
		})
		
		//暂停执行自动阶段确认
		$("#btnPause").on('click', function(){
			obj.PauseAutoRunCPW();	
		})
		
		//继续执行自动阶段确认
		$("#btnAutoRun").on('click', function(){
			obj.CtnuAutoRunCPW();	
		})
		
		//备注记录
		//诊疗备注
		obj.gridTreatment_onSelect = function (){
			var rowData = obj.gridTreatment.getSelected();
			if (rowData["ID"] != TreatRowID) {
				$("#Treat"+TreatRowID).popover("destroy");
			}
		}
		obj.TreatNode=function(ID,idx,node){
			node = node.replace(/<br\/>/g, '\n'); //IE9、FF、chrome  
			$('#tb-Treatment').datagrid("selectRow", idx);
			var rowData = obj.gridTreatment.getSelected();
			TreatRowID=rowData["ID"]
			$("#Treat"+TreatRowID).popover("destroy");
			$("#Treat"+TreatRowID).popover({
					title:$g('备注信息'),
					closeable:true,
					content:'<textarea class="textbox" id=TNode'+TreatRowID+' style="width:407px;height:100px" placeholder='+$g("添加项目详细信息")+'></textarea><div style="text-align:center;padding-top:5px"><a style="margin-right:10px" class=\"hisui-linkbutton l-btn l-btn-small" onclick=\"obj.SaveNode(\'' + TreatRowID+ '\')\"><span class="l-btn-left"><span class="l-btn-text">'+$g("保存")+'</span></span></a><a class=\"hisui-linkbutton l-btn l-btn-small" onclick=\"obj.ClearNode(\'' + TreatRowID+ '\')\"><span class="l-btn-left"><span class="l-btn-text">'+$g("清屏")+'</span></span></a></div>',
					onHide: function(){
						$("#Treat"+TreatRowID).popover("destroy");
				    }
				});
			$("#Treat"+TreatRowID).popover("show");	
			document.getElementById("TNode"+TreatRowID).innerHTML=node;
		};
		//护理备注
		obj.gridNursing_onSelect = function (){
			var rowData = obj.gridNursing.getSelected();
			if (rowData["ID"] != NurRowID) {
				$("#Nur"+NurRowID).popover("destroy");
			}
		}
		obj.NurNode=function(ID,idx,node){
			node = node.replace(/<br\/>/g, '\n'); //IE9、FF、chrome  
			$('#tb-Nursing').datagrid("selectRow", idx);
			var rowData = obj.gridNursing.getSelected();
			NurRowID=rowData["ID"]
			$("#Nur"+NurRowID).popover("destroy");
			$("#Nur"+NurRowID).popover({
					title:$g('备注信息'),
					closeable:true,
					content:'<textarea class="textbox" id=NurNode'+NurRowID+' style="width:407px;height:100px" placeholder='+$g("添加项目详细信息")+'></textarea><div style="text-align:center;padding-top:5px;"><a style="margin-right:10px" class=\"hisui-linkbutton l-btn l-btn-small" onclick=\"obj.SaveNurNode(\'' + NurRowID+ '\')\"><span class="l-btn-left"><span class="l-btn-text">'+$g("保存")+'</span></span></a><a class=\"hisui-linkbutton l-btn l-btn-small" onclick=\"obj.ClearNurNode(\'' + NurRowID+ '\')\"><span class="l-btn-left"><span class="l-btn-text">'+$g("清屏")+'</span></span></a></div>',
					onHide: function(){
						$("#Nur"+NurRowID).popover("destroy");
				    }
				});
			$("#Nur"+NurRowID).popover("show");	
			document.getElementById("NurNode"+NurRowID).innerHTML=node;
		};
	}
	
	//诊疗备注实现
	obj.ClearNode= function (ID) {
		$.messager.confirm($g("提示"), $g("是否清除记录?"), function (r) {				
			if (r) {		
				$("#TNode"+ID).val("");
			} 
		});
	}
	obj.SaveNode= function (ID) {
		var node=$("#TNode"+ID).val()
		node = node.replace(/[\r\n]/g, '<br/>'); //IE9、FF、chrome  
        node = node.replace(/\n/g, '<br/>'); //IE7-8  
        node = node.replace(/\s/g, ' '); //空格处理  
		$m({
			ClassName: "DHCMA.CPW.CP.PathwayImpl",
			MethodName: "UpdateNode",
			aID: obj.PathwayID+"||"+ID,
			aText: node,
			aUserID: session['DHCMA.USERID']
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({
					msg: $g('保存备注成功'),
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: $g('保存备注失败'),
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
			}
			$("#Treat"+ID).popover("destroy");
			obj.ShowSelectedStepDetail();
			TreatRowID=""
		})
	}
	
	//护理备注实现
	obj.ClearNurNode= function (NID) {
		$.messager.confirm($g("提示"), $g("是否清除记录?"), function (r) {				
			if (r) {		
				$("#NurNode"+NID).val("");
			} 
		});
	}
	obj.SaveNurNode= function (NID) {
		var node=$("#NurNode"+NID).val()
		node = node.replace(/[\r\n]/g, '<br/>'); //IE9、FF、chrome  
        node = node.replace(/\n/g, '<br/>'); //IE7-8  
        node = node.replace(/\s/g, ' '); //空格处理 
		$m({
			ClassName: "DHCMA.CPW.CP.PathwayImpl",
			MethodName: "UpdateNode",
			aID: obj.PathwayID+"||"+NID,
			aText: node,
			aUserID: session['DHCMA.USERID']
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({
					msg: $g('保存备注成功'),
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: $g('保存备注失败'),
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
			}
			$("#Nur"+NID).popover("destroy");
			obj.ShowSelectedStepDetail();
			NurRowID=""
		})
	}
	
	/* 页面操作控制,控制顺序不可变
	 * 控制顺序：
	 *	1、角色控制
	 *	2、阶段状态控制
	 *	3、路径状态控制
	 */
	obj.OperationControl = function () {
		//角色控制
		obj.ShowByUserType();
		//阶段状态控制
		obj.ShowByStepStatus();
		//路径状态控制
		obj.ShowByCPWStatus();
	}

	/*	按用户类型控制页面及操作
	 *	UserType在CSP中定义
	 *	D医生，N护士，空管理员
	 */
	obj.ShowByUserType = function () {
		if (UserType == "D") {
			$("#btnSave").linkbutton("enable");
			$("#CPWPatList").lookup("disable");
			$("#btnDoc").linkbutton("enable");
			$("#btnNur").linkbutton("disable");
			
			$(".img-NOper").removeClass('icon-no');
			$(".img-NOper").removeClass('icon-add');
			$(".img-NOper").addClass('icon-forbid');
			//$(".img-NOper").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".img-NOper").attr("title", $g("禁止操作"));
			$(".img-NOper").attr("onclick", "");
		} else if (UserType == "N") {
			$("#btnNur").linkbutton("enable");
			$("#btnDoc").linkbutton("disable");
			$("#btnSave").linkbutton("disable");	//确定按钮
			$("#btnClose").linkbutton("disable");	//完成按钮
			$("#btnOut").linkbutton("disable");		//出径按钮
			$("#btnUCancel").linkbutton("disable");	//作废按钮
			$("#btnChange").linkbutton("disable");	//切换路径按钮
			$('#LookCPWList').linkbutton("disable");//路径列表按钮
			$("#btnAddCompl").linkbutton("disable");	//添加合并症
			$("#btnChangeEp").linkbutton("disable");	//退回上一阶段
			$("#btnChange").css("background-color", "#BBBBBB");
			
			$(".img-TOper").removeClass('icon-no');
			$(".img-TOper").removeClass('icon-add');
			$(".img-TOper").addClass('icon-forbid');
			//$(".img-TOper").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".img-TOper").attr("title", $g("禁止操作"));
			$(".img-TOper").attr("onclick", "");
		} else {
			$("#btnNur").linkbutton("disable");
			$("#btnDoc").linkbutton("disable");
		}

	}
	/*	按用阶段状态控制页面及操作
	 *	非当前状态控制
	 *	阶段确定控制
	 */
	obj.ShowByStepStatus = function () {
		//非当前阶段
		if (obj.CurrIndex != obj.SelectedIndex) {
			$("#btnSave").linkbutton("disable");	//确定按钮
			$("#btnNur").linkbutton("disable");
			$("#btnDoc").linkbutton("disable");
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			
			$(".Operimg").removeClass('icon-no');
			$(".Operimg").removeClass('icon-add');
			$(".Operimg").addClass('icon-forbid');
			//$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("禁止操作"));
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text($g("请选择【当前阶段】后，继续各项操作！"))
		} else {
			$('#Var-Item-Save').linkbutton("enable");
			$('#Var-Item-Cancel').linkbutton("enable");
			$('#Var-Order-Save').linkbutton("enable");
			$('#Var-Order-Cancel').linkbutton("enable");
			$("#foot-note").text($g("请按照本阶段内容执行！"))
		}
	}
	obj.ShowByCPWStatus = function () {
		if ((obj.CPWStatus == $g("出径"))||(obj.CPWStatus == $g("作废"))) {
			$("#btnDoc").linkbutton("disable");		//医生签名
			$("#btnNur").linkbutton("disable");		//护士签名
			$("#btnSave").linkbutton("disable");	//确定按钮
			$("#btnClose").linkbutton("disable");	//完成按钮
			$("#btnOut").linkbutton("disable");		//出径按钮
			$("#btnUCancel").linkbutton("disable");		//作废按钮
			$("#btnChange").linkbutton("disable");	//切换路径按钮
			$("#btnAddCompl").linkbutton("disable");	//关联合并症
			//$("#btnChangeEp").linkbutton("disable");	//退回上一阶段
			$('#btnChangeEp').css('display','none');
			$("#btnChange").css("background-color", "#BBBBBB");
			$('#btnPause').css('display','none');
			$('#btnAutoRun').css('display','none');
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("禁止操作"));
			$(".Operimg").attr("onclick", "");
			$("#foot-note").html($g("该临床路径已经【") + obj.CPWStatus + "】，"+$g("禁止做任何操作！")+"<a class='reEnterPath' href='javascript:void(0)' onclick=obj.reInPathFun()>"+$g("重新入径")+"</a>")
			
			if (DischInfo.split("^")[0]=="D"){
				$('.reEnterPath').removeAttr('href');
				$('.reEnterPath').removeAttr('onclick');	
			}
		} else if (obj.CPWStatus == $g("完成")) {
			$("#btnDoc").linkbutton("disable");		//医生签名
			$("#btnNur").linkbutton("disable");		//护士签名
			$("#btnSave").linkbutton("disable");	//确定按钮
			$("#btnClose").linkbutton("disable");	//完成按钮
			$("#btnOut").linkbutton("disable");		//出径按钮
			$("#btnUCancel").linkbutton("disable");		//作废按钮
			$("#btnChange").linkbutton("disable");	//切换路径按钮
			$("#btnAddCompl").linkbutton("disable");	//关联合并症
			$("#btnChangeEp").linkbutton("disable");	//退回上一阶段
			$("#btnChange").css("background-color", "#BBBBBB");
			$('#btnPause').css('display','none');
			$('#btnAutoRun').css('display','none');
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("禁止操作"));
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text($g("该临床路径已经【") + obj.CPWStatus + $g("】，禁止做任何操作！"))
		} else {	//入径
			var ret = $m({
				ClassName: "DHCMA.Util.BT.Config",
				MethodName: "GetValueByCode",
				aCode: "CPWIsAutoConfirmEpis",
				aHospID:session['DHCMA.HOSPID']
			}, false);
			
			if (ret=="Y") {
				if (obj.ARStatus=="1"){
					$('#btnPause').css('display','none');
					$('#btnAutoRun').css('display','inline-block');
				}else {
					$('#btnPause').css('display','inline-block');
					$('#btnAutoRun').css('display','none');	
				}
			}else{
				$('#btnPause').css('display','none');
				$('#btnAutoRun').css('display','none');	
			}
		}
	}
	
	// 通过配置参数检查未入径页面展示控制    add by yankai 20221212
	obj.ShowNotInPage = function(){
		var ret = $m({
			ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
			MethodName: "ChkAdmitDaysVal",
			aEpisodeID: EpisodeID,
			aHospID: session['DHCMA.HOSPID']
		}, false);
		if (parseInt(ret.split("^")[0]) != 1) {
			if (ret.split("^")[1] != ""){
				$("#initTipInfo").html("").html("<span style='color:red'>"+$g("该患者入院已超过") + ret.split("^")[1] +$g("天，禁止入径！")+"<span>")	
			}
			$("#btn-GetInCPW").linkbutton("disable");
		} 
	}
	
	// 重新入径方法
	obj.reInPathFun = function() {
		$.messager.confirm($g("提示"),$g("本操作将重新进入路径，进入成功后，将以新路径作为最终有效路径进行统计！"),function(r){
			if (r){
				var url = "../scripts/DHCMA/CPW/CP/CPImpl/Layout_NoCPW.html";
				$("body").load(url,null,function(responseTxt,statusTxt,xhr){
					if(statusTxt=="success") {
			   			InitCPImplWin();
					} else if (statusTxt=="error") {
			   			alert("Error: "+xhr.status+": "+xhr.statusText);
			   		}
			    });
			}else{
				return;	
			}	
		});	
	}
	
	obj.SaveItemVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-Item').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: $g('请选择项目'),
						type: 'error',
						style: {
							top: 150,
							left: 450
						}
					});
					return;
				}
				for (var ind = 0, len = rows.length; ind < len; ind++) {
					var RowIndex = $('#tb-Variation-Item').datagrid("getRowIndex", rows[ind]);
					var ed = $('#tb-Variation-Item').datagrid('getEditor', { index: RowIndex, field: 'VariatTxt' });
					var VariatTxt = ""
					if (ed) VariatTxt = $(ed.target).val();
					var rowData = rows[ind]
					var Node = $('#ItemTree').tree('getSelected');
					var EpisID = obj.PathwayID + "||" + obj.StepSelecedID;
					var ImplID = obj.PathwayID + "||" + rowData['ImplID'];
					var OrdDID = "";
					var InputStr = obj.PathwayID + "^" + rowData['VarID'] + "^" + Node.id.split("-")[1] + "^" + VariatTxt + "^" + EpisID + "^" + ImplID + "^" + OrdDID + "^" + session['DHCMA.USERID'];
					var ret = $m({
						ClassName: "DHCMA.CPW.CP.PathwayVar",
						MethodName: "Update",
						aInputStr: InputStr,
						aSeparete: "^"
					}, false)

					if (parseInt(ret) > 0) {
						$('#tb-Variation-Item').datagrid("uncheckRow", RowIndex);
					}
				}
				$('#tb-Variation-Item').datagrid('reload');
				$('#ItemTree').find('.tree-node-selected').removeClass('tree-node-selected');
			} else {
				$.messager.popover({
					msg: $g('不能选择原因分类'),
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
				return;
			}
		} else {
			$.messager.popover({
				msg: $g('请选择变异原因'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	obj.CancelItemVar = function () {
		var DocSignText=$('#SignDoc').val();
		var NurSignText=$('#SignNur').val();
		if(DocSignText!=""&&NurSignText!="") {
			$.messager.popover({msg:$g("医生和护士已经签名，不能撤销！"),type:'error'});
			return;
		}
		var rows = $('#tb-Variation-Item').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: $g('请选择项目'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
		for (var ind = 0, len = rows.length; ind < len; ind++) {
			var RowIndex = $('#tb-Variation-Item').datagrid("getRowIndex", rows[ind]);
			var VarID = rows[ind]['VarID'];
			if (VarID == "") continue;
			$m({
				ClassName: "DHCMA.CPW.CP.PathwayVar",
				MethodName: "Invalid",
				aID: obj.PathwayID + "||" + VarID,
				aUserID: session['DHCMA.USERID']
			}, false)
			$('#tb-Variation-Item').datagrid("uncheckRow", RowIndex);
		}
		$('#tb-Variation-Item').datagrid('reload');
	}
	obj.SaveOrderVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-Order').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: $g('请选择医嘱'),
						type: 'error',
						style: {
							top: 150,
							left: 450
						}
					});
					return;
				}
				for (var ind = 0, len = rows.length; ind < len; ind++) {
					var RowIndex = $('#tb-Variation-Order').datagrid("getRowIndex", rows[ind]);
					var Node = $('#ItemTree').tree('getSelected');
					var ed = $('#tb-Variation-Order').datagrid('getEditor', { index: RowIndex, field: 'VariatTxt' });
					var VariatTxt = ""
					if (ed) VariatTxt = $(ed.target).val();
					var EpisID = obj.PathwayID + "||" + obj.StepSelecedID;
					var ImplID = "";	//路径外医嘱没有关联项目
					var rowData = rows[ind]
					var OrdDID = rowData['OrdDID'];
					var InputStr = obj.PathwayID + "^" + rowData['VarID'] + "^" + Node.id.split("-")[1] + "^" + VariatTxt + "^" + EpisID + "^" + ImplID + "^" + OrdDID + "^" + session['DHCMA.USERID']+"^1";
					ret = $m({
						ClassName: "DHCMA.CPW.CP.PathwayVar",
						MethodName: "Update",
						aInputStr: InputStr,
						aSeparete: "^"
					}, false)
					if (parseInt(ret) > 0) {
						$('#tb-Variation-Order').datagrid("uncheckRow", RowIndex);
					}
				}
				$('#tb-Variation-Order').datagrid('reload');
				$('#ItemTree').find('.tree-node-selected').removeClass('tree-node-selected');
			} else {
				$.messager.popover({
					msg: $g('不能选择原因分类'),
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
				return;
			}
		} else {
			$.messager.popover({
				msg: $g('请选择变异原因'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	obj.CancelOrderVar = function () {
		var rows = $('#tb-Variation-Order').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: $g('请选择医嘱'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
		for (var ind = 0, len = rows.length; ind < len; ind++) {
			var RowIndex = $('#tb-Variation-Order').datagrid("getRowIndex", rows[ind]);
			var VarID = rows[ind]['VarID'];
			if (VarID == "") continue;
			$m({
				ClassName: "DHCMA.CPW.CP.PathwayVar",
				MethodName: "Invalid",
				aID: obj.PathwayID + "||" + VarID,
				aUserID: session['DHCMA.USERID']
			}, false)
			$('#tb-Variation-Order').datagrid("uncheckRow", RowIndex);
		}
		$('#tb-Variation-Order').datagrid('reload');
	}
	obj.OutCPW = function () {
		var verID = Common_GetValue('OutReason')
		var verTxt = Common_GetValue('OutText')
		var errorInfo = "";
		if (verID == "") {
			errorInfo = $g("请选择出径原因！<br />")
		}
		if (verTxt == "") {
			errorInfo = errorInfo + $g("请填写备注信息！")
		}
		if (errorInfo != "") {
			$.messager.alert($g("错误提示"), errorInfo, "error")
			return;
		}
		$m({
			ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
			MethodName: "GetOutCPW",
			aEpisodeID: EpisodeID,
			aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID'] + "^" + verID + "^" + verTxt
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({ msg: $g("操作成功"), type: 'success' });
				$HUI.dialog('#OutCPWDialog').close();
				obj.InitCPWInfo();
				obj.OperationControl();
			}
		})
	}
	obj.UCanCPW = function () {
		var verID = Common_GetValue('UCanReason')
		var verTxt = Common_GetValue('UCanText')
		var errorInfo = "";
		if (verID == "") {
			errorInfo = $g("请选择作废原因！<br />")
		}
		if (verTxt == "") {
			errorInfo = errorInfo + $g("请填写备注信息！")
		}
		if (errorInfo != "") {
			$.messager.alert($g("错误提示"), errorInfo, "error")
			return;
		}
		$m({
			ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
			MethodName: "GetUCanCPW",
			aEpisodeID: EpisodeID,
			aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID'] + "^" + verID + "^" + verTxt
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({ msg: $g("操作成功"), type: 'success' });
				$HUI.dialog('#UCanCPWDialog').close();
				obj.InitCPWInfo();
				obj.OperationControl();
			}
		})
	}
	obj.CloseCPW = function () {
		//最后一个阶段是否确定
		if (obj.ConfList.slice(-1) != 1) {
			$.messager.popover({ msg: $g("还有阶段未确定，禁止此操作"), type: 'error' });
			return;
		}
		
		//通过配置信息判断是否检查签名
		var strCheckSign = $m({
			ClassName: "DHCMA.Util.BT.Config",
			MethodName: "GetValueByCode",
			aCode: "CPWCheckSignBeforeClose",
			aHospID:session['DHCMA.HOSPID']
		}, false)
		
		var SignMsg = ""
		if (strCheckSign.split("||")[0] == "N"){		// "提醒"需检查，"强制"不需要检查
			var retChkSign = $m({
				ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
				MethodName: "CheckStepSignInfo",
				aEpisodeID: EpisodeID,
				aPathwayID:obj.PathwayID
			}, false)
			if (retChkSign != "0"){
				var DocSign = retChkSign.split("^")[1].split(":")[1]
				var NurSign = retChkSign.split("^")[2].split(":")[1]
				if (strCheckSign.split("||")[1] == "0") {				//提醒医生护士
					if (DocSign!="" && DocSign!=undefined) SignMsg = $g("存在医生未签名阶段：") + DocSign + "！"
					if (NurSign!="" && NurSign!=undefined) SignMsg = SignMsg + $g("存在护士未签名阶段：") + NurSign + "！"
				} else if (strCheckSign.split("||")[1] == "1") {		//提醒医生
					SignMsg = $g("存在医生未签名阶段：") + DocSign + "！"	
				} else if (strCheckSign.split("||")[1] == "2") {		//提醒护士
					SignMsg = $g("存在护士未签名阶段：") + NurSign + "！"	
				} else {} 	
			}
		}
		if (SignMsg != ""){
			$.messager.confirm($g("提示"), SignMsg + $g("<br />是否先补签签名？"), function (r) {
				if (r) return;
				else{
					$.messager.confirm($g("完成"), $g("确定完成?<br />完成后将不能再做任何修改！"), function (r) {
						if (r) {
							$m({
								ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
								MethodName: "CloseCPW",
								aEpisodeID: EpisodeID,
								aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID']
							}, function (ret) {
								if (parseInt(ret) > 0) {
									$.messager.popover({ msg: $g("操作成功"), type: 'success' });
									obj.InitCPWInfo();
									obj.OperationControl();
								}
							})
						} else {
							return;
						}
					});		
				}
			})	
		}else{
			$.messager.confirm($g("完成"), $g("确定完成?<br />完成后将不能再做任何修改！"), function (r) {
				if (r) {
					$m({
						ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
						MethodName: "CloseCPW",
						aEpisodeID: EpisodeID,
						aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID']
					}, function (ret) {
						if (parseInt(ret) > 0) {
							$.messager.popover({ msg: $g("操作成功"), type: 'success' });
							obj.InitCPWInfo();
							obj.OperationControl();
						}
					})
				} else {
					return;
				}
			});	
		}
	}
	
	// 暂停自动执行阶段确认
	obj.PauseAutoRunCPW = function(){
		$.messager.confirm($g("暂停"), $g("确定暂停本路径的自动阶段确认?"), function (r) {
			if (r) {
				$m({
					ClassName: "DHCMA.CPW.CP.Pathway",
					MethodName: "UpdateARStatus",
					aPathwayID: obj.PathwayID,
					aARStatus: "1"
				}, function (ret) {
					if (parseInt(ret) > 0) {
						$.messager.popover({ msg: $g("操作成功"), type: 'success' });
						obj.InitCPWInfo();
						obj.OperationControl();
					}
				})
			} else {
				return;
			}
		});		
	}
	
	// 继续自动执行阶段确认
	obj.CtnuAutoRunCPW = function(){
		$.messager.confirm($g("继续"), $g("取消本路径暂停，继续执行自动阶段确认?"), function (r) {
			if (r) {
				$m({
					ClassName: "DHCMA.CPW.CP.Pathway",
					MethodName: "UpdateARStatus",
					aPathwayID: obj.PathwayID,
					aARStatus: "0"
				}, function (ret) {
					if (parseInt(ret) > 0) {
						$.messager.popover({ msg: $g("操作成功"), type: 'success' });
						obj.InitCPWInfo();
						obj.OperationControl();
					}
				})
			} else {
				return;
			}
		});		
	}
	
	// 阶段确认事件
	obj.ConfirmStep = function () {
		var DateTimeFrom = $('#DateFrom').datetimebox('getValue');
		var DateTimeTo = $('#DateTo').datetimebox('getValue');
		var myDate=new Date();
		var Month=myDate.getMonth()+1
		var dateTime=myDate.getFullYear()+"-"+Month+"-"+myDate.getDate()+" "+myDate.getHours()+":"+myDate.getMinutes()+":"+myDate.getSeconds();
		if (DateTimeFrom == "") {
			$.messager.popover({ msg: $g("开始时间不能为空"), type: 'error' });
			return;
		} else {
			if (DateTimeTo == "") {
				$.messager.popover({ msg: $g("结束时间不能为空"), type: 'error' });
				return;
			} else {
				var flg = Common_CompareDate(DateTimeTo,DateTimeFrom);
				if (!flg) {
					$.messager.popover({ msg: $g("结束时间应大于开始时间"), type: 'error' });
					return;
				}
				var flg2 = Common_CompareDate(DateTimeTo,dateTime);
				if (flg2) {
					$.messager.popover({ msg: $g("结束时间不能大于当前时间"), type: 'error' });
					return;
				}
			}
		}
		
		// 自动签名检查配置
		var IsAtuoSignOnCfmEp = $m({ClassName: "DHCMA.Util.BT.Config",MethodName: "GetValueByCode",aCode: "CPWIsAutoSignOnCfmEp",aHospID:session['DHCMA.HOSPID']}, false)
	    var strCheckSign = $m({ClassName: "DHCMA.Util.BT.Config",MethodName: "GetValueByCode",aCode: "CPWCheckSignBeforeClose",aHospID:session['DHCMA.HOSPID']}, false)
	    
	    new Promise(function(resolve, reject) {
		    // 阶段确认前进行变异检查
			var VarCount = $cm({ ClassName: "DHCMA.CPW.CPS.ImplementSrv", MethodName: "CheckVarToSign", aPathwayID: obj.PathwayID, aEpisID: obj.PathwayID + "||" + obj.StepSelecedID, aSignType: UserType, aHospID:session['DHCMA.HOSPID'] }, false);
			if (parseInt(VarCount) > 0) {
				$.messager.popover({ msg: $g("有变异信息未处理，不允许确认阶段！"), type: 'error' });
				$('#CPW-main').tabs('select', $g("变异原因"));
				reject(false)
			}else{
				resolve(true);		//默认执行	
			}
	    })
	    .then(function(data) {
			return new Promise(function(resolve,reject){
				// 自动签名检查
				if(IsAtuoSignOnCfmEp=="Y") {
					if ((UserType=="D" && $('#SignDoc').val()=="") || (UserType=="N" && $('#SignNur').val()=="")){
						obj.SignStep(resolve)						
					}else resolve(true);
				}else resolve(true)
			})
		})
		.then(function(data){
			return new Promise(function(resolve,reject){
				if (data == false){
					reject(false)
					return;		
				}
				
				//通过配置信息判断是否检查签名
				var SignMsg = "",DocSignText = $('#SignDoc').val(),NurSignText = $('#SignNur').val()
				var arrCheckSign = strCheckSign.split("||");
				if (arrCheckSign[1] == "0") {
					if (IsAtuoSignOnCfmEp=="Y"){		// 自动签名模式下能进入当前一级then方法证明前一级then中自动签名已执行成功
						if (UserType=="D" && NurSignText==""){		
							SignMsg = $g("护士没有签名，");
						}else if (UserType=="N" && DocSignText==""){
							SignMsg = $g("医生没有签名，");	
						}
					}else{
						if ((DocSignText == "") || (NurSignText == "")) {
						 	SignMsg = $g("医生或护士没有签名，");
						}
					}
				} else if (arrCheckSign[1] == "1") {
					if (IsAtuoSignOnCfmEp=="Y"){
						if (UserType=="N" && DocSignText == "") {
							SignMsg = $g("医生没有签名，");
						}	
					}else{
						if (DocSignText == "") {
							SignMsg = $g("医生没有签名，");
						}	
					}
					
				} else if (arrCheckSign[1] == "2") {
					if (IsAtuoSignOnCfmEp=="Y"){
						if (UserType=="D" && NurSignText == "") {
							SignMsg = $g("护士没有签名，");
						}	
					}else{
						if (NurSignText == "") {
							SignMsg = "护士没有签名，";
						}	
					}
				} else {
				}
				if (SignMsg != ""){
					if (arrCheckSign[0] == "Y"){
						$.messager.popover({ msg: SignMsg + $g("禁止此操作"), type: 'error' });
						reject(false);
					}else {
						$.messager.confirm($g("提示"), SignMsg + $g("是否继续？"), function (r) {
							if (r) resolve(true)
							else reject(false)	
						})
					}	
				}else resolve(true)
			})
		})
		.then(function(data){
			return new Promise(function(resolve,reject){
				$.messager.confirm($g("确定"), $g("确定后将不能再做任何修改！"), function (r) {
					if (r) {
						//继续操作
						var NextEpisID = ""
						var NextIndex = parseInt(obj.CurrIndex) + 1;
						if (NextIndex < obj.StepList.length) {
							var NextStep = obj.StepList[NextIndex];
							var NextEpisID = NextStep.split(":")[0];	//下一个步骤的ID
							NextEpisID = obj.PathwayID + "||" + NextEpisID;
						}
						$m({
							ClassName: "DHCMA.CPW.CPS.ImplementSrv",
							MethodName: "ConfirmStep",
							aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
							aSttDate: DateTimeFrom,
							aEndDate: DateTimeTo,
							aUserID: session['DHCMA.USERID'],
							aNextEpisID: NextEpisID,
							aHospID:session['DHCMA.HOSPID']
						}, function (ret) {
							if (parseInt(ret) > 0) {
								var RevInputStr="^"+obj.PathwayID+"^"+NextEpisID+"^"+session['DHCMA.USERID']
								$m({
									ClassName: "DHCMA.CPW.CP.PathwayEpisRevoke",
									MethodName: "Update",
									aInputStr: RevInputStr,
									aSeparete: "^"
								}, function (RevokeRet) {
									$.messager.popover({ msg: $g("确定成功"), type: 'success' });
									obj.InitCPWSteps();	//步骤信息
								})
							}else{
								$.messager.popover({ msg: $g("操作失败，请稍后重试！"), type: 'error' });
								$('#DateTo').datetimebox('setValue',"");
								return;	
							}
						})
					} else {
						$('#DateTo').datetimebox('setValue',"");
						return;
					}
				})
			})
		},function(data){
			if (data==false){
				$('#DateTo').datetimebox('setValue',"");
			}	
		})
	}
	
	///阶段退回
	obj.RevokeStep = function () {
		$.messager.confirm($g("确定"), $g("确定退回上一阶段！"), function (r) {
			if (r) {		
				var BackEpisID = ""
				var BackIndex = parseInt(obj.CurrIndex) - 1;
				if(BackIndex<0){
					$.messager.popover({ msg: $g("已是最早阶段"), type: 'error' });
					return;
				}
				if (BackIndex < obj.StepList.length) {
					var BackStep = obj.StepList[BackIndex];
					var BackEpisID = BackStep.split(":")[0];	//上一个步骤的ID
					BackEpisID = obj.PathwayID + "||" + BackEpisID;
				}
				//return;
				$m({
					ClassName: "DHCMA.CPW.CPS.ImplementSrv",
					MethodName: "RevokeStep",
					aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
					aUserID: session['DHCMA.USERID'],
					aBackEpisID: BackEpisID
				}, function (ret) {
					if (parseInt(ret) > 0) {
						var RevInputStr="^"+obj.PathwayID+"^"+obj.PathwayID + "||" + obj.StepSelecedID+"^"+session['DHCMA.USERID']
						$m({
							ClassName: "DHCMA.CPW.CP.PathwayEpisRevoke",
							MethodName: "Update",
							aInputStr: RevInputStr,
							aSeparete: "^"
						}, function (RevokeRet) {
							if(RevokeRet>0){
								$.messager.popover({ msg: $g("退回阶段成功"), type: 'success' });
								obj.InitCPWSteps();	//步骤信息
								}								
						});
					}
				})
			}
		})

	}
	
	// 阶段签名
	obj.SignStep = function (callback) {
		var VarCount = $cm({ ClassName: "DHCMA.CPW.CPS.ImplementSrv", MethodName: "CheckVarToSign", aPathwayID: obj.PathwayID, aEpisID: obj.PathwayID + "||" + obj.StepSelecedID, aSignType: UserType, aHospID:session['DHCMA.HOSPID'] }, false);
		if (parseInt(VarCount) > 0) {
			$.messager.popover({ msg: $g("有变异信息未处理，不允许签名"), type: 'error' });
			$('#CPW-main').tabs('select', $g("变异原因"));
			if (typeof callback === 'function'){
				callback(false);
			}else { return false;}
		}
		var SignText = "";
		if (UserType == "D") SignText = $('#SignDoc').val();
		if (UserType == "N") SignText = $('#SignNur').val();
		
		if (SignText != "") {
			$.messager.popover({ msg: $g("不能重复签名"), type: 'error' });
			if (typeof callback === 'function'){
				callback(false);
			}else { return false;}
		}
		
		// 设置CA签名参数
		var retSign=""
		var CA_Code = UserType=="D"? "DocSignToCPW":"NurseSignToCPW";
		var CA_OperType = UserType=="D"?"DS":"NS";						//医生签名DS,护士签名NS
		var aInputStr=obj.PathwayID + "||" + obj.StepSelecedID + "^" + session['DHCMA.USERID'] + "^" + UserType;
		
		new Promise(function(resolve, reject) {
			var strCheckItm = $m({
				ClassName: "DHCMA.CPW.CPS.ImplementSrv",
				MethodName: "CheckHaveUnExItm",
				aPathwayID: obj.PathwayID,
				aEpisID: obj.PathwayID + "||" + obj.StepCurrID,
				aUserType: UserType
			}, false)
			if (strCheckItm == "1") {
				$.messager.confirm($g("提示"), $g("存在未执行的非必选项目，确定不执行？"), function (r) {
				 	if (r) resolve(true)
				 	else reject(false)
				})	
			}else{
				resolve(true);
			}
		}).then(function(data){
			return new Promise(function(resolve,reject){
				//CA签名验证
				CASignLogonModal('CPW',CA_Code,{
					signData: aInputStr,				// 签名数据
					dhcmaOperaType:CA_OperType,
					ModalOption:{
						isHeaderMenuOpen:false			//当前页面打开认证弹窗
					}
				},function() {
					var data = obj.SaveSignInfo();
					if (data!=false) {
						if (UserType == "N") $('#gridAdm').datagrid('reload');
						if (typeof callback === 'function'){
							callback(true);
							return data;
						}else { return data;}
					}
					else {
						if (typeof callback === 'function'){
							callback(false);
							return data;
						}else { return false;}	
					}
				});
			})
		},function(data){
			if (typeof callback === 'function'){
				callback(false);
			}else { return false;}	
		})
	}
	
	//保存签名信息
	obj.SaveSignInfo = function() {
		var ret=$m({
				ClassName: "DHCMA.CPW.CP.PathwayEpis",
				MethodName: "Sign",
				aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
				aUserID: session['DHCMA.USERID'],
				aUserType: UserType
		}, false)
		if (parseInt(ret) > 0) {
			$.messager.popover({ msg: $g("签名成功！"), type: 'success' });
			obj.InitCPWSteps();	//步骤信息
			return ret;
		}
	}
	
	//路径信息
	obj.InitCPWInfo = function () {
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetCPWInfo",
			aEpisodeID: EpisodeID,
			aHospID:session['DHCMA.HOSPID']
		}, function (JsonStr) {
			if (JsonStr == "") return;
			var JsonObj = $.parseJSON(JsonStr);
			obj.CPWCurrDesc = JsonObj.CPWDesc;		//当前步骤名称
			obj.CPWStatus = JsonObj.CPWStatus;		//当前路径状态
			obj.ARStatus = JsonObj.ARStatus;		//自动阶段确认状态
			obj.PathFormID = JsonObj.PathFormID		//当前路径的表单ID
			obj.PathwayID = JsonObj.PathwayID		//出入径记录ID
			obj.IsCostTip = JsonObj.IsCostTip

			$('#CPWDesc').text(JsonObj.CPWDesc)
			if(obj.ARStatus=="1"){
				$('#CPWStatus').html(JsonObj.CPWStatus+"<font color='red'>【"+$g("已暂停")+"】</font>")	
			}else{
				$('#CPWStatus').html(JsonObj.CPWStatus)
			}
			$('#CPWUser').text(JsonObj.CPWUser)
			$('#CPWTime').text(JsonObj.CPWTime)
			
			var isCAVerify = $m({
				ClassName: "DHCMed.CA.SignVerify",
				MethodName: "GetRepIsSign",
				aProCode: "CPW",
				aModType: "CPW",
				aReportID:obj.PathwayID,
				aOprType:"I"
			}, false);
			
			var htmlIcon = ""
			htmlIcon = htmlIcon + '<span class="Icon Icon-D">'+$g("单")+'</span>'
			htmlIcon = htmlIcon + '<span class="Icon Icon-B">'+$g("变")+'</span>'
			htmlIcon = htmlIcon + '<span class="Icon Icon-T">T</span>'
			htmlIcon = htmlIcon + '<span class="Icon Icon-Y">¥</span>'
			if (parseInt(isCAVerify)==1) htmlIcon = htmlIcon + '<span class="Icon-CA"><img src=\'../skin/default/images/ca_icon_green.png\'/></span>'
			
			$('#CPWIcon').html(htmlIcon)
			$(".Icon-D").popover({
				content: $g('单病种信息：') + JsonObj.SDDesc
			});
			$(".Icon-B").popover({
				content: JsonObj.VarDesc
			});
			$(".Icon-T").popover({
				content: $g('入径天数：') + JsonObj.CPWDays + $g('天<br />计划天数：') + JsonObj.FormDays + $g('天')
			});
			var showFeeColor = (obj.IsCostTip == "1") ? "#FF0000":"#40A2DE"
			$(".Icon-Y").popover({
				width:350,
				content:"<p style='line-height:25px;'>"+$g("住院总费用")+"：<font color='" + showFeeColor + "'>" + JsonObj.PatCost + "</font>"+$g("元，自付金额")+"：<font color='#40A2DE'>"+ JsonObj.PatCost + "</font>"+$g("元")+"</p>"+
						"<p style='line-height:25px;'>"+$g("参考费用")+"：<font color='#40A2DE'>" + JsonObj.FormCost + "</font>"+$g("元，预警费用")+"：<font color='#40A2DE'>"+ JsonObj.LimitCost + "</font>"+$g("元")+"</p>",
				onShow:function(e,v){
					obj.FlgPCIcon=-1;	
				}
			});
			if (UserType== "D" && obj.IsCostTip == "1"){						// 医生界面进行费用图标定时提醒
				obj.FeeTmpFlg = 1;
				setInterval("obj.myInterval()",300);							// 图标进行闪动	
			}
			
			$(".Icon-CA").popover({
				content: $g('入径已进行CA验证')
			});

			obj.InitCPWSteps();	//步骤信息
			
			//单病种入组->表单展现
			$m({
				ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
				MethodName: "GetMrListIDByCPID",
				CPID: obj.PathwayID
			}, function (MrListID) {
				if (MrListID>0) {
					obj.MrListID=MrListID
					$("#btnSD").show();
				}
			})
			
			//付费病种->病种出组
			if(parseInt(IsOpenPCSDMod)==1){
				$m({
					ClassName: "DHCMA.CPW.SDS.PCIOToCPWSrv",
					MethodName: "IsMatchCEntity",
					aPathwayID: obj.PathwayID
				}, function (ret) {
					if (parseInt(ret) > 0) {
						$("#btnOutPCSD").show();
					}
				})	
			}
		});
	}
	
	//费用预警患者设置动态改变图标背景色
	obj.myInterval=function(){   
     	if (obj.FeeTmpFlg==1){
     		$(".Icon-Y").css("background-color","#FF0000");	
     		obj.FeeTmpFlg=0;
    	 }else{
	     	$(".Icon-Y").css("background-color","#7DB561"); //#FFFF00
	     	obj.FeeTmpFlg=1;
	     }
     }

	//获取路径步骤列表
	obj.InitCPWSteps = function () {
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetCPWSteps",
			aPathwayID: obj.PathwayID
		}, function (StepsStr) {
			var StepsArr = StepsStr.split("#");
			var StepCurr = StepsArr[0];
			if (StepCurr == "") return;

			obj.StepCurrID = StepCurr.split(":")[0];		//已经执行到当前步骤的ID
			obj.StepCurrDesc = StepCurr.split(":")[1];		//已经执行到当前步骤的Desc
			obj.StepList = StepsArr[1].split("^");			//该路径所有步骤数组，ID:Desc
			obj.TimeList = StepsArr[2].split("^");			//该路径所有步骤起止时间数组，EpDays*SttDateTime*EndDateTime
			obj.ConfList = StepsArr[3].split("^");			//该路径所有步骤是否确定数组，1、0
			obj.SignList = StepsArr[4].split("^");			//该路径所有步骤签名信息数组，SignDoc:SignNur:SignDocDate:SignNurDate
			obj.NoteList = StepsArr[5].split("^");	
			obj.CurrIndex = obj.StepList.indexOf(StepCurr);	//已经执行到当前步骤的下标						
			
			//展现步骤
			obj.ShowCPWSteps();
			obj.StepSelecedID = obj.StepCurrID;				//点击选中的步骤ID
			$('#StepDesc ul').each(function(){ 
				$(this).find('li').eq(obj.CurrIndex).css({color:'#40A2DE'})
			})
			
			//展现步骤内容
			obj.SelectStep(obj.CurrIndex);
			obj.IsBackStep(obj.PathwayID,obj.StepSelecedID);
		});
	}

	// 展现阶段时间线步骤
	obj.ShowCPWSteps = function () {
		$("#StepDesc").empty()
		var ItemsData=[]	//水平步骤内容
		$.each(obj.StepList, function(ind, item){	// item=stepId:stepDesc
			var tmpItem = {}
			var stepID = item.split(":")[0];		// 阶段ID
			var stepDesc = item.split(":")[1];		// 阶段描述
			if (ind == obj.CurrIndex) stepDesc = stepDesc + $g('(当前阶段)')
			tmpItem.stepID = stepID
			tmpItem.stepIndex = ind 
			tmpItem.title = stepDesc
			ItemsData[ind] = tmpItem
		})	
		$("#StepDesc").hstep({
		    stepWidth:($('#ww').width()/obj.StepList.length),
		    currentInd:parseInt(obj.CurrIndex+1),
		    items:ItemsData,
		    onSelect:function(ind,item){
				obj.SelectStep(item.stepIndex);
			}
		});
	}
	
	// 阶段选中处理
	obj.SelectStep = function (SelectedIndex) {
		var SelectedStep = obj.StepList[SelectedIndex]
		obj.StepSelecedID = SelectedStep.split(":")[0]
		obj.SelectedIndex = SelectedIndex
		
		var StepSelect = obj.TimeList[SelectedIndex].split("*");
		$('#StepTime').text(StepSelect[0]);
		$('#DateFrom').datetimebox('setValue', StepSelect[1]);
		//$('#DateTo').datetimebox('setValue', StepSelect[2]);
		if (obj.CurrIndex==SelectedIndex) {
			$('#DateTo').datetimebox({disabled:false}).datetimebox('setValue', StepSelect[2])
		}else {
			$('#DateTo').datetimebox({disabled:true}).datetimebox('setValue', StepSelect[2])	
		}
		var StepSign = obj.SignList[SelectedIndex].split(":");
		$('#SignDoc').val(StepSign[0]);
		$('#SignNur').val(StepSign[1]);
		
		//调整并展现步骤
		$('#StepDesc').hstep('setStep',SelectedIndex+1);
		//展现步骤内容
		obj.ShowSelectedStepDetail();

		//已经确定的步骤不能再操作
		obj.OperationControl();
		obj.VQueryLoad(); 				//dsp 变异数据grid展示格式异常，未找到原因，故此处再次加载 Modified by yankai 20221230
	}
	obj.IsBackStep = function(aPathwayID,aStepSelecedID){
		$m({
			ClassName: "DHCMA.CPW.CP.PathwayEpisRevoke",
			MethodName: "CheckIsRevoke",
			aCPPathwayID: aPathwayID,
			aCPPathwayEpisID: aPathwayID+"||"+aStepSelecedID
			}, function (ret) {
				if(ret=="1"){
					$('#btnChangeEp').css('display','');
				}else{
					$('#btnChangeEp').css('display','none');
					}
		
		})
		
	}
	
	
	// 加载所选页签下所选阶段内容
	obj.ShowSelectedStepDetail = function () {
		switch (obj.tabType) {
			case "T":
				obj.TQueryLoad();
				break;
			case "N":
				obj.NQueryLoad();
				break;
			case "O":
				obj.OQueryLoad();
				break;
			case "V":
				obj.VQueryLoad();
				break;
		}
	}


	obj.TQueryLoad = function () {
		obj.gridTreatment.load({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			QueryName: "QryCPWStepInfo",
			aPathwayID: obj.PathwayID,
			aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
			aType: "T"
		});
	}
	obj.NQueryLoad = function () {
		obj.gridNursing.load({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			QueryName: "QryCPWStepInfo",
			aPathwayID: obj.PathwayID,
			aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
			aType: "N"
		});
	}
	obj.OQueryLoad = function () {
		obj.gridOrder.load({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			QueryName: "QryCPWStepInfo",
			aPathwayID: obj.PathwayID,
			aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
			aType: "O"
		});
	}
	obj.VQueryLoad = function () {
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetVariatTree",
			aTypeCode: "01",
			aCatCode: ""
		}, function (treeJson) {
			var dataArr = $.parseJSON(treeJson)
			$('#ItemTree').tree({
				data: dataArr,
				formatter: function (node) {
					//formatter  此时isLeaf方法还无法判断是不是叶子节点 可通过children
					if (node.children) {
						return node.text;
					} else {
						len = node.text.length;
						if (len < 15) {
							return node.text;
						} else {
							return node.text.substring(0, 15) + "<br />" + node.text.substring(15)
						}
						/* return "<div >"
							+"<span data-id='"+node.id+"' class='icon-write-order' style='display:block;width:16px;height:16px;position:absolute;right:5px;top:5px;'></span>"
							+"<div style='height:20px;line-height:20px;color:gray'>"+(new Date()).toLocaleString()+"</div>"
							+"<div style='height:20px;line-height:20px;'>"+node.text+"</div>"
							+"</div>";
						//同时给此树下的tree-node 加上position: relative;   以实现小图标靠右 */
					}

				},
				onClick: function (node) {

				},
				lines: true, autoNodeHeight: true
			})
		});
		
		if (obj.tabVarType == "O") {
			obj.gridVarOrder.load({
				ClassName: "DHCMA.CPW.CPS.ImplementSrv",
				QueryName: "QryCPWVarOrder",
				aPathwayID: obj.PathwayID,
				aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
				page:1,
				rows:9999
			});
		} else if(obj.tabVarType == "N") {
			obj.gridVarItem.load({
				ClassName: "DHCMA.CPW.CPS.ImplementSrv",
				QueryName: "QryCPWVarItem",
				aPathwayID: obj.PathwayID,
				aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
				aUserType: UserType,
				aHospID:session['DHCMA.HOSPID'],
				page:1,
				rows:9999
			});
		}
		
		var tab = $('#CPW-Var').tabs('getSelected');
		var tabID=tab[0].id
		$.parser.parse("#"+tabID);

	}
	obj.ExecuteItem = function (ItemID) {
		$m({
			ClassName: "DHCMA.CPW.CP.PathwayImpl",
			MethodName: "ExecuteItem",
			aPathwayID: obj.PathwayID,
			aItemID: ItemID,
			aOrdDID: "",
			aUserID: session['DHCMA.USERID'],
			aIsImpl: 1,
			aIsSystem: 0
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({
					msg: $g('执行成功'),
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: $g('执行失败')+',ret=' + ret,
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
			}
			$("#Treat"+TreatRowID).popover("destroy");
			$("#Nur"+NurRowID).popover("destroy");
			if (UserType == "N") {
				$('#gridAdm').datagrid('reload');
			}
			TreatRowID=""
			NurRowID=""
			obj.ShowSelectedStepDetail();
		});
	}
	obj.CancelItem = function (ItemID) {
		$m({
			ClassName: "DHCMA.CPW.CP.PathwayImpl",
			MethodName: "ExecuteItem",
			aPathwayID: obj.PathwayID,
			aItemID: ItemID,
			aOrdDID: "",
			aUserID: session['DHCMA.USERID'],
			aIsImpl: 0,
			aIsSystem: 0
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({
					msg: $g('撤销成功'),
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: $g('撤销失败'),
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
			}
			$("#Treat"+TreatRowID).popover("destroy");
			$("#Nur"+NurRowID).popover("destroy");
			if (UserType == "N") {
				$('#gridAdm').datagrid('reload');
			}
			TreatRowID=""
			NurRowID=""
			obj.ShowSelectedStepDetail();
		});
	}

	//切换路径
	obj.ShowChangeCPW = function () {
		$('#CgStepList').html("");
		$('#CgStepDetail').html("");
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetCPWList",
			aPathFormID: obj.PathFormID,
			//增加科室常用路径判断
			aAdmLocID: session['DHCMA.CTLOCID']
		}, function (CPWList) {
			if (CPWList == "") {
				$.messager.popover({
					msg: $g('没有可切换的路径'),
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
				return;
			}
			var CPWHtml = "";
			var CPWArr = CPWList.split("^");
			for (var ind = 0, len = CPWArr.length; ind < len; ind++) {
				var tmpCPW = CPWArr[ind].split(":");
				if (ind==0){
					CPWHtml = CPWHtml + "<span style='padding-right:10px'></span><input class='hisui-radio' type='radio' label='" + tmpCPW[1] + "' value='" + tmpCPW[0] + "' name='ipCPWList' id='CPW-" + tmpCPW[0] + "'>";
				}else{
					CPWHtml = CPWHtml + "<span style='padding-right:20px'></span><input class='hisui-radio' type='radio' label='" + tmpCPW[1] + "' value='" + tmpCPW[0] + "' name='ipCPWList' id='CPW-" + tmpCPW[0] + "'>";
				}
				if ((ind + 1) % 4 == 0) CPWHtml = CPWHtml + "<br />";
			}
			$('#CgCPWlist').html(CPWHtml)
			$HUI.radio("#CgCPWlist input.hisui-radio", {});
			//$HUI.radio("#CPW-"+CPWArr[0].split(":")[0]).setValue(true);	//默认选中第一个
			$('#CurrCPWDesc').text(obj.CPWCurrDesc);
			$('#CurrStepDesc').text(obj.StepCurrDesc);
			$HUI.radio("[name='ipCPWList']", {
				onChecked: function (e) {
					var CgCPWID = $(e.target).attr("value");
					obj.ShowCgSteps(CgCPWID);
					$('#CgStepDetail').html("<span style='margin-top:3px;color:#1474AF;'><span class='icon icon-tip'></span>"+$g("提示：灰色阶段不可用，请选择可用阶段进行切换！")+"</span>");
				}
			});
			$HUI.dialog('#ChangeCPWDialog').open();
		});

	}
	obj.BtnChangeCPW = function () {
		/*add by xwj 2019-07-31*/
		var StepList = document.getElementById("CgStepList");
		if (StepList.innerHTML== "") {
			$.messager.alert($g("提示"), $g("请选择切换的路径及阶段!"), 'info');
			return   		
		}
		//end
		$.messager.prompt($g("提示"), $g("切换原因"), function (note) {
			if (note) {
				$m({
					ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
					MethodName: "SwitchCPW",
					aEpisodeID: EpisodeID,
					aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + obj.NewFormID + "^" + obj.NewStepID + "^" + note
				}, function (ret) {
					if (parseInt(ret) > 0) {
						$HUI.dialog('#ChangeCPWDialog').close();
						$.messager.popover({
							msg: $g('切换成功'),
							type: 'success',
							style: {
								top: 150,
								left: 450
							}
						});
						window.location.reload();	//刷新页面
					} else {
						$.messager.popover({
							msg: $g('切换失败'),
							type: 'error',
							style: {
								top: 150,
								left: 450
							}
						});
					}
				});
			} else {
				$HUI.dialog('#ChangeCPWDialog').close();
				$.messager.popover({ msg: $g("原因为空或取消切换"), type: 'alert' });
			}
		});
	}
	obj.ShowCgSteps = function (CPWID) {
		obj.NewStepID="" //add by dengshaopeng 2019-08-15
		//$('.Cgstep').removeClass('CgstepActive');
		$('#CgStepDetail').html("");
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetStepList",
			aPathFormID: CPWID,
			aPathwayID: obj.PathwayID
		}, function (StepList) {
			if (StepList == "") {
				return;
			}
			var StepHtml = ""
			var StepArr = StepList.split("^");
			for (var ind = 0, len = StepArr.length; ind < len; ind++) {
				var tmpStep = StepArr[ind].split(":");
				//StepHtml = StepHtml + "<div id='CgStep-" + tmpStep[0] + "' class='selectStepMore Cgstep' style='margin-top:10px;'>" + tmpStep[1] + "</div>"
				if(tmpStep[2]==0){
					StepHtml = StepHtml + "<a href='#' id='CgStep-" + tmpStep[0] + "' class='hisui-linkbutton' disabled style='margin-top:10px;width:100%;'>" + tmpStep[1] + "</a>"
				}else{
					StepHtml = StepHtml + "<a href='#' id='CgStep-" + tmpStep[0] + "' class='hisui-linkbutton Cgstep' style='margin-top:10px;width:100%;'>" + tmpStep[1] + "</a>"	
				}
			}
			$('#CgStepList').html(StepHtml);
			$.parser.parse("#CgStepList");
			
			$('#CgStepList .Cgstep').on('click', function () {
				//$('.Cgstep').removeClass('CgstepActive');
				//$('#' + this.id).addClass('CgstepActive');
				obj.ShowCgStepDetail(CPWID + "||" + this.id.split("-")[1]);
			});
		});
	}
	obj.ShowCgStepDetail = function (StepID) {
		obj.NewFormID = StepID.split("||")[0];
		obj.NewStepID = StepID.split("||")[1];
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetStepDetail",
			aFormEpID: StepID
		}, function (StepDetail) {
			if (StepDetail == "") {
				return;
			}
			$('#CgStepDetail').html(StepDetail);
		});
	}
	obj.ShowCPWList = function (LocID,Desc) {
		$m({
			ClassName: "DHCMA.CPW.BTS.PathLocSrv",
			QueryName: "QryPathByLocDesc",
			ResultSetType: 'array',
			aLocID: LocID,
			aDesc: Desc,
			aEpisodeID: EpisodeID,
			aHospID:session['DHCMA.HOSPID']
		}, function (CPWList) {
			if (CPWList == "") {
				return;
			}
			var CPWHtml = ""
			var CPWArr = JSON.parse(CPWList);

			for (var ind = 0, len = CPWArr.length; ind < len; ind++) {
				
				var tmpDesc = CPWArr[ind].TmpDesc;
				var tmpItemID = CPWArr[ind].MastID;
				var tmpItemDesc = CPWArr[ind].MastDesc;
				CPWHtml = CPWHtml + "<div id='CPWItem-" + tmpItemID + "' class='selectStepMore CPWItem' style='margin-top:10px;'>"
				CPWHtml = CPWHtml + tmpItemDesc
				CPWHtml = CPWHtml + "<div style='text-align:right;font-size:0.8em;border-top:1px dashed;'>"+tmpDesc+"</div>"
				CPWHtml = CPWHtml + "</div>"
			}
			$('#CPWListItem').html(CPWHtml);
			$('#CPWListItem .CPWItem').on('click', function () {
				$('.CPWItem').removeClass('CgstepActive');
				$('#' + this.id).addClass('CgstepActive');
				obj.ShowCPWDetail(this.id.split("-")[1]);
				$("#initTipInfo").css('display','none');
				$("#CPWListDetail").css('display','block');
			});
		});
		obj.ShowNotInPage();
		$HUI.dialog('#LookCPWDialog').open();
		obj.FormID="";
	}
	//add by xwj 2019-08-09
	$('#btn-GetInCPW').on('click', function () {
		if(DischInfo.split("^")[0]=="D") return;				//按钮设为不可用后仍能点击，此处直接根据出院状态设置事件不可用
		var content = document.getElementById('CCPWDiag-right');
		if ((content.innerText != "")&&(obj.FormID == "")) {
			$.messager.popover({ msg: $g("路径未发布，请选择其他路径！"), type: 'error' });
			return;
		}
		if ((obj.FormID=="")&&(content.innerText == "")) {
			$.messager.popover({ msg: $g("未选择路径"), type: 'error' });
			return;
		}
		
		var aInputStr=parseInt(obj.FormID) + CHR_1 + session['DHCMA.USERID'] + CHR_1 + session['DHCMA.CTLOCID'] + CHR_1 + session['DHCMA.CTWARDID'];
		//CA签名验证
		CASignLogonModal('CPW','GetInCPW',{
			// 签名数据
			signData: aInputStr,
			dhcmaOperaType:'I'
		},obj.GetInCPWFun,EpisodeID,aInputStr);
	});
	
	// 关闭科室路径弹窗
	$('#btn-CloseWin_CPW').on('click',function(){
		$('#CPWListDetail').css('display','none');
		$('#CPWLocType').keywords('select','myloc');
		$('#CPWSearch').searchbox('setValue','');
		$('#PathName').html('');
		$('#ApplyDoc').html('');
		$('#HelpDoc').html('');
		obj.searchValue='';
		$HUI.dialog('#LookCPWDialog').close();	
	})
	
	//end
	obj.ShowCPWDetail = function (MastID) {
		var FormID = $m({
			ClassName: "DHCMA.CPW.BTS.PathFormSrv",
			MethodName: "GetFormByMast",
			aMastID: MastID,
			aIO: 1
		}, false);
		//FormID = parseInt(FormID); //会将空值转换为0
		obj.FormID=(FormID.split("^"))[0];
		var aFormID=(FormID.split("^"))[0];
		if (FormID == "") {
			$('#CPWDetail').css('display','none');
			$('#NoData').html($g("<p>没有可用的已发布版本！</p>"))
			$('#PathName').html('');
			$('#ApplyDoc').html('');
			$('#HelpDoc').html('');
		} else {
			$("#CPWDetail").css('display','block');
			$('#NoData').html('');
			$m({
				ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
				MethodName:"GetCPWSummary",
				aPathID:aFormID
			}, function (Summary) {
				$('#PathName').html(Summary.split("^")[0])
				$('#ApplyDoc').html(Summary.split("^")[1])
				$('#HelpDoc').html(Summary.split("^")[2]);
			});
		}
	}
	obj.SearchCPW = function(){
		$("#initTipInfo").css('display','block');
		$("#CPWListDetail").css('display','none');
		if(obj.serchType=="myloc"){
			obj.ShowCPWList(session['DHCMA.CTLOCID'],obj.searchValue)
		}else{
			obj.ShowCPWList("",obj.searchValue)
		}
	}
	obj.ShowSD=function(){
		title=$g("单病种表单填报") 
		url="./dhcma.cpw.sd.qcformshow.csp?MrListID=" + obj.MrListID + "&random="+Math.random();
		websys_showModal({
			url:url,
			title:title,
			iconCls:'icon-w-epr',
			originWindow:window,
			isTopZindex:true,
			onBeforeClose:function(){}
		});
	}
	
	// 付费病种出组
	obj.GetOutPCSD = function(){
		$.messager.confirm($g("提示"), $g("此操作将退出当前付费病种入组并修改付费方式为按项目付费，是否继续？"), function (r) {
			if (r) {
				var ret = $m({
					ClassName: "DHCMA.CPW.SDS.PCIOToCPWSrv",
					MethodName: "GetIOPCEntity",
					aEpisodeID: EpisodeID,
					aPathwayID: obj.PathwayID,
					aStatus: "O",
					aUserID: session['DHCMA.USERID']
				}, false);
				if (parseInt(ret) > 0) {
					$.messager.popover({ msg: $g("付费病种出组成功！"), type: 'success' });
					$("#btnOutPCSD").linkbutton('disable');
				} else {
					$.messager.popover({ msg: $g("付费病种出组失败！"), type: 'error' });
				}
			}
			else{
				return;
			}
		})
	}
	
	// 入径方法
	obj.GetInCPWFun = function(aEpisodeID,aInputStr){
		var ret = $m({
			ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
			MethodName: "GetInCPW",
			aEpisodeID: aEpisodeID,
			aInputs: aInputStr,
			aSeparete:CHR_1
		}, false);
		if (parseInt(ret) > 0) {
			$.messager.popover({ msg: $g("入径成功！"), type: 'info',timeout: 2000 });
		} else {
			$.messager.popover({ msg: $g("入径失败！"), type: 'info',timeout: 2000 });
		}
		$HUI.dialog('#LookCPWDialog').close();
		window.location.reload();
		if (parseInt(ret)>0) return parseInt(ret);	
	}
	
}
GetLength = function (str) {
	///获得字符串实际长度，中文2，英文1，符号1
	var realLength = 0, len = str.length, charCode = -1;
	for (var i = 0; i < len; i++) {
		charCode = str.charCodeAt(i);
		if (charCode >= 0 && charCode <= 128)
			realLength += 1;
		else
			realLength += 2;
	}
	return realLength;
}
	obj.gridAdm_onSelect = function (){
		var rowData = obj.gridAdm.getSelected();
		EpisodeID=rowData["EpisodeID"];
		obj.InitCPWInfo()
	}