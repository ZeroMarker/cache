/**
 * combined.js 抗菌药物联合用药
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-05-04
 * 
 */
$(function () {
	//提示信息
    var Chrflag = false;
    var Curflag = false;
	//var MaxNum = $.InvokeMethod("DHCAnt.KSS.Combined","GetCombinedNumFormDAUP",PARAOBJ.EpisodeId, PARAOBJ.ParrAllInfo,session['LOGON.HOSPID']);
	var CurRearet = $.InvokeMethod("DHCAnt.KSS.Combined","GetCombinedNumFormDAUP",PARAOBJ.EpisodeId,PARAOBJ.ParrAllInfo,session['LOGON.HOSPID']);
    if (CurRearet.split("|")[0] > 1) {	//QP 20170622
        Curflag = true;
    };
	var Chrret = $.InvokeMethod("DHCAnt.KSS.Combined","IfChangeFormDAUP",PARAOBJ.EpisodeId, PARAOBJ.ParrAllInfo,session['LOGON.HOSPID']);
    if (Chrret == 1){
        Chrflag = true;
    };
    if (Curflag) {
		var tipInfo = "<span style='font-size:12px;'>需要填写联用原因</span><span style='margin-left:30px;color:#000;font-size:12px;'>不需要填写变更原因</span>";
		$("#i-fill-content").html(tipInfo);
	};
    if (Chrflag) {
		var tipInfo = "<span style='color:#000;font-size:12px;'>不需要填写联用原因</span><span style='margin-left:30px;font-size:12px;'>需要填写变更原因</span>";
		$("#i-fill-content").html(tipInfo);
	};
    if ( Curflag && Chrflag) {
		var tipInfo = "<span style='font-size:12px;'>需要填写联用原因</span><span style='margin-left:30px;font-size:12px;'>需要填写变更原因</span>";
		$("#i-fill-content").html(tipInfo);
	};
	
	//联用原因
	$('#i-caim-reason').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Combined";
			param.QueryName="QryCombinedUseReason";
			param.ModuleName="combobox";
			param.ArgCnt=0;
		}
	});
	
	//变更原因
	$('#i-caim-changereason').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Combined";
			param.QueryName="QryChangeReason";
			param.ModuleName="combobox";
			param.ArgCnt=0;
		}
	});
	
	if (CurRearet.split("|")[0] <= 1){	//QP 20170622
		$("#i-caim-reason").simplecombobox('disable');
		$("#i-caim-reason").simplecombobox('setValue',"");
	} else {
		$("#i-caim-reason").simplecombobox('enable');                                 
	};
	
	if (Chrflag==0){
		$('#i-caim-changereason').simplecombobox('disable');
		$('#i-caim-changereason').simplecombobox('setValue',"");
	} else {
		$('#i-caim-changereason').simplecombobox('enable');
	}
		
	//当前联用抗菌药物
	$('#i-combined-grid').simpledatagrid({
		pagination:false,
		//title:"当前联用抗菌药物",
		iconCls:'icon-cdrug',
		collapsible:false,
		border:false,
		frozenColumns:[
			{field:'ck',checkbox:false}
		],
		headerCls:'panel-header-gray',
		queryParams: {
			ClassName:"DHCAnt.KSS.Combined",
			QueryName:"CombinedInfo",
			ModuleName:"datagrid",
			Arg1:PARAOBJ.EpisodeId,
			Arg2:PARAOBJ.ParrAllInfo,
			ArgCnt:2
		},
		columns:[[
			{field:'ArcItm',title:'医嘱名称',width:100},
			{field:'Priority',title:'医嘱分类',width:100},
			{field:'Status',title:'医嘱状态',width:100},
		]]
	});
	
	//抗菌药物更改原由
	$('#i-change-grid').simpledatagrid({
		pagination:false,
		//title:"抗菌药物更改原由",
		headerCls:'panel-header-gray',
		border:false,
		frozenColumns:[
			{field:'ck',checkbox:false}
		],
		iconCls:'icon-creason',
		queryParams: {
			ClassName:"DHCAnt.KSS.Combined",
			QueryName:"AntChange",
			ModuleName:"datagrid",
			Arg1:PARAOBJ.EpisodeId,
			Arg2:PARAOBJ.ParrAllInfo,
			ArgCnt:2
		},
		columns:[[
			{field:'Status',title:'医嘱状态',width:100},
			{field:'ArcItm',title:'药品名称',width:100},
			{field:'StopDate',title:'停医嘱时间',width:100},
		]]
	});
	
	//保存
	$("#i-btn-save").on("click", function() {
		var tmpFlag = checkData(CurRearet, Chrret);
		if (!tmpFlag) {
			return false;
		}
		var savePara = getData(CurRearet,Chrret);
		var saveArr = savePara.split("^");
		var CurInfo = saveArr[0];	//联用原因
		var ChrInfo = saveArr[1];	//变更原因	
		var ret = $.InvokeMethod("DHCAnt.KSS.Combined","SaveCombinedInfo",PARAOBJ.EpisodeId, PARAOBJ.ParrAllInfo, CurInfo, ChrInfo,session['LOGON.HOSPID']);
        if (ret!=0) {
			//$.messager.alert('提示','保存成功!','info');
			$.messager.alert('提示','保存成功!','info', function () {
				closeWin(true);
			});
		} else {
			$.messager.alert('提示','保存失败!','info');
			return;
		};
				
	});
	//取消
	$("#i-btn-cancel").on("click", function() {
		$.messager.confirm('提示', '登记表未保存,是否继续退出?', function(r){
			if (r){
				closeWin("");
			}
		});
	});
	
	function closeWin (saveFlag) {
		if ((websys_showModal('options'))&&(websys_showModal('options').CallBackFunc)) {
			websys_showModal('options').CallBackFunc(saveFlag);
		}else{
			if (window.opener) {
				window.opener.returnValue = saveFlag;
			} else {
				window.returnValue = saveFlag;
			}
			window.close();
			return;
		}
	}
	function checkData (CurRearet, Chrret) {
		if(CurRearet.split("|")[0] > 1){	//QP 20170622
			var CombinedReasonValue = $("#i-caim-reason").simplecombobox('getValue');
			if (CombinedReasonValue == "") {
				$.messager.alert('提示','联用原因不能为空!','info');
				return false;
			}
		}
		if(Chrret!=0){
			var ChangeKssReasonValue = $('#i-caim-changereason').simplecombobox('getValue');
			if (ChangeKssReasonValue == "") {
				$.messager.alert('提示','变更原因不能为空!','info');
				return false;  
			}
		}
		return true;    
	}
	function getData (CurRearet, Chrret) {
		var CombinedReasonValue=""
		if(CurRearet.split("|")[0]!=0){
			var CombinedReasonValue = $("#i-caim-reason").simplecombobox('getValue');
		}
		var ChangeKssReasonValue=""
		if( Chrret != 0 ){
			ChangeKssReasonValue = $('#i-caim-changereason').simplecombobox('getValue');
		}
		var Para=CombinedReasonValue+"^"+ChangeKssReasonValue
		return Para;
	}
})