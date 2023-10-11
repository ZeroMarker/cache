/**
 * 
 * @authors liyi (124933390@qq.com)
 * @date    2017-09-13 16:25:35
 * @version v1.0
 */
function InitReportWinEvent(obj){
	// 初始化功能按钮
	CheckSpecificKey();
 	
 	if (obj.LabIsNeed=="1") {
		if (Common_RadioValue('radInfLab')!=1) {
			$('#divINFLab').attr("style","display:none");
		}else {
			$('#divINFLab').removeAttr("style");			
		}
	}
	
	if (obj.AntIsNeed=="1") {
		if (Common_RadioValue('radInfAnti')!=1) {
			$('#divINFAnti').attr("style","display:none");
		}else {
			$('#divINFAnti').removeAttr("style");
		}
	}
	if (obj.OprIsNeed=="1") {
		if (Common_RadioValue('radInfOpr')!=1) {
			$('#divINFOPS').attr("style","display:none");
		}else {
			$('#divINFOPS').removeAttr("style");
		}
	}
	if(obj.LabIsNeed!="1") {
		$('#TabLabMsg').attr("style","display:none");
		$('#TabLabLine').attr("style","display:none");			
	}
	if(obj.AntIsNeed!="1") {
		$('#TabAntiMsg').attr("style","display:none");
		$('#TabAntiLine').attr("style","display:none");
	}

	if (obj.OprIsNeed!="1") {
		$('#TabOprMsg').attr("style","display:none");
		$('#TabOprLine').attr("style","display:none");
	}
		
	obj.InitButtons = function(){
		$('#btnSubmit').hide();
		$('#btnCheck').hide();
		$('#btnDelete').hide();
		$('#btnReturn').hide();
		$('#btnExport').hide();
		$('#btnUnCheck').hide();
		
		//增加系统参数设置是否隐藏添加
		//btnINFOPSAdd btnINFLabAdd btnINFAntiAdd
		var configVal= $m({
			ClassName:"DHCHAI.BT.Config",
			MethodName:"GetValByCode",		
			aCode: "InfReportAddBtnHidden",
			aHospDr: $.LOGON.HOSPID
		},false);
		if (configVal!= ''){
			var arr = configVal.split("-");
			if(arr.length>=3)
			{
				if(arr[0]=="1")
				{
					$('#btnINFOPSAdd').hide();
				}
				if(arr[1]=="1")
				{
					$('#btnINFLabAdd').hide();
				}
				if(arr[2]=="1")
				{
					$('#btnINFAntiAdd').hide();
				}
			}
		}
		switch (obj.RepStatusCode) {
			case '2':       // 提交
				$('#btnDelete').show();
				$('#btnSubmit').show();
				$('#btnExport').show();
				if (obj.AdminPower==1) {	// 管理员
					$('#btnCheck').show();
					$('#btnReturn').show();
					$('#btnDelete').show();
				}
				ButtonStatus();
				break;
			case '3':       // 审核
				$('#btnExport').show();
				if (obj.AdminPower==1) {	// 管理员
					$('#btnUnCheck').show();
				}
				ButtonStatus();
				break;
			case '6':       // 取消审核
				$('#btnSubmit').show();
				$('#btnDelete').show();
				if (obj.AdminPower==1) {	// 管理员
					$('#btnCheck').show();
					$('#btnReturn').show();
				}
				ButtonStatus();
				break;
			case '4':       // 删除
				ButtonStatus();
				break;
			case '5':       // 退回
			    ButtonStatus();
				$('#btnSubmit').show();
				$('#btnDelete').show();
				break;
			default:
				$('#btnSubmit').show();
				break;
		}
		
		if ((obj.OpIsShow==1)&&(obj.RepStatusCode!="")) {   //管理员审核时填写
			if (obj.AdminPower==1) {
				$('#INFOpinion').removeAttr("style");
				$.parser.parse('#INFOpinion');         //需要再次解析			
			}else {
				if ($('#txtOpinion').val()) {   //内容不为空时显示，临床不可编辑
					$('#INFOpinion').removeAttr("style");
					$('#txtOpinion').attr('disabled','disabled');
					$.parser.parse('#INFOpinion');         //需要再次解析
				}
			}
		}
	}
	obj.InitButtons();
	
	
	
	// 提交
	$('#btnSubmit').click(function (e) {
		if (!obj.CheckInputData(2)){
			return;
		}
	
    	if (obj.Save()){
			$.messager.popover({msg: '提交成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("提示", '提交失败！', 'info');
    	};
	});

	// 审核
	$('#btnCheck').click(function (e) {
		if (!obj.CheckInputData(3)){
			return;
		}
    	if (obj.Save()){
			$.messager.popover({msg: '审核成功！',type:'success',timeout: 2000});	
    	}else{
			$.messager.alert("提示", '审核失败！', 'info');
    	};
	});

	// 删除
	$('#btnDelete').click(function (e) {
		$.messager.confirm("提示", "确认是否删除", function (r) {
			if (r){				
				if (obj.SaveStatus(4)){
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 2000});
				}else{
					$.messager.alert("提示", '删除失败！', 'info');
				};
			}
		});
	});

	// 退回
	$('#btnReturn').click(function (e) {
		$.messager.confirm("退回报告", "您确定要退回这份报告吗？", function(r){
			if (r){
				$.messager.prompt("退回报告", "请输入退回原因!", function(txt){
					if (txt){
						if(obj.SaveStatus(5,txt)){
							//添加给临床发送消息的功能  add by xwj 2020_3_5
							var retval = obj.LayerMsg_Save("退回原因：【"+txt+"】");
							if (retval>0){
								$.messager.popover({msg:  "退回成功！",type:'success',timeout: 2000});	
							}
						} else {
							$.messager.alert("提示", "退回失败！",'info');				
						}
					}else if (txt==='') {
						$.messager.alert("提示", "未输入退回原因,报告不能退回！",'info');
					}
				});
			}
			
		});
	});
	// msg 内容
	obj.LayerMsg_Save=function(msg){
		
		var CSEpisodeDr = EpisodeIDx.split("||")[1];
	
		var CSMessage = msg;		
		if (CSMessage == '') {
			layer.alert("消息内容不允许为空");
			return -1;
		}
		var RepUserID="";
		if (obj.RepInfo) {
			RepUserID = obj.RepInfo.rows[0].RepUserID;
		}
		var user = $.LOGON.USERID;
		var InputStr= CSMessage;
		var retval = $m({                  
			ClassName:"DHCHAI.IRS.INFReportSrv",
			MethodName:"SentMsg",
			Message:InputStr,
			FromUserDr:user,
			ToUserDr:RepUserID,
			HisPaadm:CSEpisodeDr,
			LnkJson:'{"linkParam":"MsgType=1&ReportID='+ReportID+'"}'
		},false);
		if (parseInt(retval)>0){
			//成功			
		} else {
			$.messager.alert("提示", '退回消息发送失败!', 'info');
		}
		return retval;
	};
	
	// 取消审核
	$('#btnUnCheck').click(function (e) {
    	if (obj.SaveStatus(6)){
	    	$('#txtOpinion').val(''); //取消审核不展示评价意见
			$.messager.popover({msg: '取消审核成功！',type:'success',timeout: 2000});	
    	}else{
    		$.messager.alert("提示", '取消审核失败！', 'info');
    	};
	});
	
	// 导出
	$('#btnExport').click(function(e){
		var fileName="DHCHAIReport.raq&aReportID="+ReportID+"&aEpisodeID="+EpisodeID;
		DHCCPM_RQPrint(fileName);
		
		//var fileName="{DHCHAIReport.raq(aReportID="+ReportID+";aEpisodeID="+EpisodeID+")}";
		//DHCCPM_RQDirectPrint(fileName);
	});
	
	//关闭
	$('#btnClose').click(function(e){
		if (PageType!= 'WinOpen') {
			websys_showModal('close');
			closeWin();	   //消息弹出报告后无法关闭问题	
		}else {
			window.close();
		}
	});
	
	function closeWin(){
		var modal=findThisModal();
		if (modal && modal.length>0){
			modal.window('close');
		}else{
			window.close()
			if (parent && parent.closeTransWin) {
				parent.closeTransWin();
			}else if(top && top.HideExecMsgWin) {
				top.HideExecMsgWin();
			}
		}
	}

	function findThisModal(id){
		var modal=null;
		var key=(new Date()).getTime()+'r'+parseInt(Math.random()*1000000);
		if (!window.parent || window.parent===window) return modal;
		try {
			var P$=window.parent.$;
		}catch(e){
			return modal;
		}
		if (typeof id=="string" && P$('#'+id).length>0) return P$('#'+id);
		window._findThisModalKey=key;
		
		P$('iframe').each(function(){
			try {
				if (this.contentWindow._findThisModalKey==key){
					modal=P$(this).closest('.window-body');
					return false;
				}
			}catch(e){}
			
		})
		return modal;
	}


	
	//评价意见
	obj.LayerOpinion = function() {
		$HUI.dialog('#LayerOpinion',{	
			title:'评价意见-选择',
			iconCls:'icon-w-paper',
			width: 700,    
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'确认',
				handler:function(){	
					var OpinionList="";
					var rows = obj.gridOpinion.getChecked();			
					var length = obj.gridOpinion.getChecked().length;  
					for (i=0;i<length;i++) {
						var DicDesc = rows[i].DicDesc;
						OpinionList += DicDesc+" ";
					}
					var Opinion = $("#txtOpinion").val(); 
					if (!Opinion) {
						$('#txtOpinion').val(OpinionList);
					}else {
						$('#txtOpinion').val(Opinion+OpinionList);
					}
					$HUI.dialog('#LayerOpinion').close();
				}
			},{
				text:'取消',
				handler:function(){$HUI.dialog('#LayerOpinion').close();}
			}]
		});
	}
	
	 obj.refreshgridOpinion = function(){
		obj.gridOpinion = $HUI.datagrid("#gridOpinion",{ 
			fit: true,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			pagination: false,
			rownumbers: true, //如果为true, 则显示一个行号列
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.BTS.DictionarySrv',
				QueryName:'QryDic',
				aTypeCode:'InfRepOpinion',
				aActive:1
			},
			columns:[[
				{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
				{field:'ID',title:'ID',width:50,hidden:true},
				{field:'DicDesc',title:'评价描述',width:600}
			]]
		});
    }
	
	$("#btnOpinion").click(function(e){
    	if ((obj.AdminPower==1)&&(obj.OpIsShow==1)&&((obj.RepStatusCode==2)||(obj.RepStatusCode==3)||(obj.RepStatusCode==6))) {   //管理员审核时填写
			obj.refreshgridOpinion();
			$('#LayerOpinion').show();
			obj.LayerOpinion();
  		}
  	});
	// 数据完整性验证
	obj.CheckInputData = function (statusCode){
		obj.InputRep 		= obj.Rep_Save(statusCode);		// 报告主表信息
		obj.InputRepLog 	= obj.RepLog_Save(statusCode);	// 日志
    	obj.InputPreFactors = obj.PreFactor_Save();			// 易感因素
    	obj.InputInvasOpers = obj.InvasOper_Save();			// 侵害性操作
    	obj.InputDiag 		= obj.DIAG_Save();				// 感染信息
    	obj.InputOPS 		= obj.OPR_Save();				// 手术信息
    	obj.InputLab 		= obj.LAB_Save();				// 病原学送检
    	obj.InputAnti 		= obj.ANT_Save();				// 抗菌药物
		if (!obj.InputDiag) {
			return false;
		}
		//检查手术部位感染是否关联手术
		var InfPosDesc = $('#cboInfPos').combobox('getText');
		if((InfPosDesc.indexOf("手术切口")>0||InfPosDesc.indexOf("和腔隙感染")>0)){
			if(obj.InputOPS==""){
				$.messager.alert("提示", '手术部位感染必须关联手术，请检查！', 'info');
				return false;
			}
		}
		//检查切口手术部位与感染诊断
		if ((obj.InputDiag) && (obj.InputOPS)) {
			var InfPosID = obj.InputDiag.split(CHR_2)[0].split(CHR_1)[2];
			var InputOPS = obj.InputOPS.split(CHR_2);
			var isAllAgree = 1;			//是否完全一致
			for (var i=0; i<InputOPS.length; i++) {
				var IsOperInf = InputOPS[i].split(CHR_1)[18];		//是否切口感染
				var InfTypeID = InputOPS[i].split(CHR_1)[19];		//手术部位
				if ((IsOperInf == 1)&&(InfPosID != InfTypeID)) {
					isAllAgree = 0;
					break;
				}
			}
			if (!isAllAgree) {
				$.messager.alert("提示", '切口感染的手术切口类型需与本次感染诊断保持一致，请检查！', 'info');
				return false;
			}
		}
		
		if ((!obj.InputLab)&&(obj.Bacterias)) {
			$.messager.alert("提示", '本次感染有病原学检验证据，请填写！', 'info');
			return false;
		}
		
		var IsInfLab = Common_RadioValue('radInfLab');
        var IsInfAnti = Common_RadioValue('radInfAnti');
        var IsInfOpr = Common_RadioValue('radInfOpr');
        if ((IsInfLab==1)&&(!obj.InputLab)){
	        $.messager.alert("提示", '存在与此次感染有关的病原学信息，请填写病原学检验信息内容！', 'info');
			return false;
        }
        if ((obj.LabIsNeed==1)&&(!IsInfLab)) {
	         $.messager.alert("提示", '是否存在与此次感染有关的病原学信息为必填内容，请选择！', 'info');
			return false;
        }
        if ((IsInfLab=="0")&&(obj.InputLab)){
	        $.messager.alert("提示", '不存在与此次感染有关的病原学信息时填写了病原学检验信息内容，请检查！', 'info');
			return false;
        }
        
        if ((obj.AntIsNeed==1)&&(!IsInfAnti)) {
	         $.messager.alert("提示", '是否存在与此次感染有关的抗菌用药信息为必填内容，请选择！', 'info');
			return false;
        }
        if ((IsInfAnti==1)&&(!obj.InputAnti)){
	        $.messager.alert("提示", '存在与此次感染有关的抗菌用药信息，请填写抗菌用药信息内容！', 'info');
			return false;
        }
        if ((IsInfAnti=="0")&&(obj.InputAnti)){
	        $.messager.alert("提示", '不存在与此次感染有关的抗菌用药信息时填写了抗菌用药信息内容，请检查！', 'info');
			return false;
        }
        
        if ((obj.OprIsNeed==1)&&(!IsInfOpr)) {
	         $.messager.alert("提示", '是否存在与此次感染有相关性的手术信息，请选择！', 'info');
			return false;
        }
        
        if ((IsInfOpr==1)&&(!obj.InputOPS)){
	        $.messager.alert("提示", '存在与此次感染有相关性的手术信息，请填写手术信息内容！', 'info');
			return false;
        }
         if ((IsInfOpr=="0")&&(obj.InputOPS)){
	        $.messager.alert("提示", '不存在与此次感染有相关性的手术信息时填写了手术信息内容，请检查！', 'info');
			return false;
        }

    	return true;
	}

	// 保存报告内容+状态
	obj.Save = function (){
		var ret = $cm({
			ClassName:"DHCHAI.IRS.INFReportSrv",
			MethodName:"SaveINFReport",
			aRepInfo:obj.InputRep, 
			aPreFactors :obj.InputPreFactors,
			aInvasOpers :obj.InputInvasOpers,
			aDiags :obj.InputDiag,
			aOPSs :obj.InputOPS,
			aLabs :obj.InputLab,
			aAntis :obj.InputAnti,
			aRepLog :obj.InputRepLog,
			aCSS :''			
		},false);
      
    	if (parseInt(ret)>0){
    		ReportID = parseInt(ret);
    		obj.refreshReportInfo();
    		obj.refreshgridINFOPS();
    		obj.refreshgridINFLab();
    		obj.refreshgridINFAnti();
    		obj.InitButtons();
    		
    		//删除医院感染,历史就诊 
    		var retd = $cm({
				ClassName:"DHCHAI.IRS.INFReportSrv",
				MethodName:"DelINFRepAdm",
				aReportID:ReportID,
				aEpisodeIDs:obj.DelEpisodeIDs.substring(1)
			},false);
    		//保存医院感染,历史就诊 
    		var rets = $cm({
				ClassName:"DHCHAI.IRS.INFReportSrv",
				MethodName:"SaveINFRepAdm",
				aReportID:ReportID,
				aEpisodeIDs:obj.EpisodeIDs.substring(1),
				aUser:$.LOGON.USERID
			},false);
			//保存患者代报标志
    	    if(ReplaceFlag!=""){
	    	 	var ret=$m({
					ClassName:"DHCHAI.IR.INFReport",
					MethodName:"UpdateReplaceFlag",
					aRepID:ReportID,
					aReplaceFlag:ReplaceFlag
				},false);
				if(ret<0){
					$.messager.alert("提示", '保存失败！', 'info');
					return false;
				}
	    	}
    	    if (PageType!= 'WinOpen') { //解决老版公共卫生事件打开报告无法执行的问题
				//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
				if (typeof(history.pushState) === 'function') {
				  	var Url=window.location.href;
			        Url=rewriteUrl(Url, {
				        ReportID:ReportID
			        });
			    	history.pushState("", "", Url);
			        return true;
				}
    	    }
    		return true;
    	}else{
    		return false;
    	}
	}

	// 保存报告状态
	obj.SaveStatus = function(statusCode){
		var Opinion = arguments[1];
		if (typeof(Opinion)=='undefined'){
			Opinion='';
		}
		var InputRepLog = obj.RepLog_Save(statusCode,Opinion);	// 日志
		var ret =  $m({
			ClassName:"DHCHAI.IRS.INFReportSrv",
			MethodName:"SaveINFReportStatus",
			aRepLog :InputRepLog, 
			separete:CHR_1
		},false);
    	if (parseInt(ret)>0){
    		obj.refreshReportInfo();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
        }
    }
    /// 若存在相同感染日期,感染类型,感染诊断,返回True
    obj.checkSameInf = function(){
        if (!obj.RepotInfo){
            return flag;
        }
        
        var InfDate = $('#txtInfDate').datebox('getValue')
        var InfType  = Common_RadioLabel('radInfType')
        var InfPos = $('#cboInfPos').combotree('getText');
        var flag= false
        var len = obj.RepotInfo.length
        for (var i=0;i<len;i++){
            var xInfPos=obj.RepotInfo[i].InfPosDescs
            var xInfType=obj.RepotInfo[i].InfType
            var xInfDate=obj.RepotInfo[i].InfDateDescs
            if ((xInfPos==InfPos)&&(InfDate==xInfDate)&&(InfType==xInfType)){
                flag=true;
                break;
            }
            
        }
        return flag;
   
    }
	function ButtonStatus() {
		if ((obj.RepStatusCode==3)||(obj.RepStatusCode==4)) {  //审核、删除状态报告
			$("#btnAddSen").linkbutton("disable");
			$("#btnDelSen").linkbutton("disable");
			$("#btnINFOPSSync").linkbutton("disable");
			$("#btnINFOPSAdd").linkbutton("disable");
			$("#btnINFLabSync").linkbutton("disable");
			$("#btnINFLabAdd").linkbutton("disable");
			$("#btnINFAntiSync").linkbutton("disable");
			$("#btnINFAntiAdd").linkbutton("disable");			
		}else {
			$("#btnAddSen").linkbutton("enable");
			$("#btnDelSen").linkbutton("enable");
			$("#btnINFOPSSync").linkbutton("enable");
			$("#btnINFOPSAdd").linkbutton("enable");
			$("#btnINFLabSync").linkbutton("enable");
			$("#btnINFLabAdd").linkbutton("enable");
			$("#btnINFAntiSync").linkbutton("enable");
			$("#btnINFAntiAdd").linkbutton("enable");			
		}
	}
}

