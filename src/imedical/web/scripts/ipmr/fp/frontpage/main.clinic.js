/**
 * 编目主页面
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */
// 页面全局变量对象
var globalObj = {
	m_emrviewflg:0,			// 病历浏览页签被点击过标志
	m_qualityviewflg:0,		// 质控页签被点击过标志
	m_multiverflg:0    		// 多版本诊断编目页签被点击过标志
}
// 页面入口
$(function(){
	//初始化页面
	Init();
	//事件初始化
	InitEvent();
})
// 初始化页面
function Init(){
	if (ServerObj.IsCanCode==0){
		$.messager.alert("提示","此病历不可以编目,请确保此病历已回收！","info")
		$('#btnDraft').linkbutton('disable');
		$('#btnSave').linkbutton('disable');
	}else{
		InitBtnPower(ServerObj.MasterStatus)
	}
	if (ServerObj.IsCodePageShowEmrAlone==1){
		$('#edit_tabs').tabs('close','病历浏览');	//关闭病历浏览tab
		$('#EmrPanel').panel({
			onExpand:function(){
				loadEmrPage();
			},
			onCollapse:function(){
			}
		});
	}else{
		$('#adminfoPanel').layout('remove','east')	//不显示浏览面板
	}
	apendPatInfoItem();
}

// 初始化事件
function InitEvent(){
	// 同步首页数据按钮
	$('#btnSyncEmrData').click(function(){
		if (SyncEmrData())
		{
			getEmrChage();
		};
	});

	// 保存按钮
	$('#btnSave').click(function(){
		SaveResult("C");
	});

	// 草稿按钮
	$('#btnDraft').click(function(){
		SaveResult("R");
	});

	// tabs页签切换事件
	$('#edit_tabs').tabs({
		onSelect:function(title){
			if (title=='病历浏览'){
				loadEmrPage();
			}
			if (title=='病案首页质控') {
				loadQualityPage();
			}
			if (title=='多版本诊断编目') {
				if (globalObj.m_multiverflg==1) return;
				var url = 'ma.ipmr.fp.frontpage.multiver.csp?EpisodeID='+ServerObj.EpisodeID;
				if ('undefined'!== typeof websys_getMWToken) {
					url+='&MWToken='+websys_getMWToken();
				}
				document.getElementById('iframemultiver').src=url;
				globalObj.m_multiverflg=1;
			}
		}
	});
	
}

// tab选择
function selecttab(title){
	$('#edit_tabs').tabs('select',title);
}

// 加载浏览病历链接
function loadEmrPage() {
	if (globalObj.m_emrviewflg==1) return;
	if (ServerObj.IsCodePageShowEmrAlone==1)
	{
		var Element = 'iframeviewemreast';
	}else{
		var Element = 'iframeviewemr';
	}
	var PatientID = ServerObj.OutSysPatientID;
	var EpisodeID = ServerObj.OutSysEpisodeID;
	var AdmType   = 'I';
	var EpisodeLocID = ServerObj.OutSysAdmLocID;
	var url = ServerObj.EmrUrl;
	if (url==''){
		$.messager.alert("提示","请在参数配置页面维护病历浏览链接！","info")
	}
	
	var csp = url.split('?')[0];
	var requset = url.split('?')[1];
	var arrrequest = requset.split('&');
	var trequset='';
	for (var i = 0 ; i < arrrequest.length;i++){
		var req = arrrequest[i];
		var str = "str = '"+req+"'+"+req.split('=')[0];
		eval(str)
		if (trequset==''){
			trequset = str;
		}else{
			trequset = trequset+'&'+str;
		}
	}
	var url = csp+'?'+trequset
	if ('undefined'!== typeof websys_getMWToken) {
		url+='&MWToken='+websys_getMWToken();
	}
	document.getElementById(Element).src=url;
	globalObj.m_emrviewflg=1;
}

// 加载质控链接
function loadQualityPage() {
	if (globalObj.m_qualityviewflg==1) return;
	var url = ServerObj.QualityUrl;
	if (url==''){
		$.messager.alert("提示","请在参数配置页面维护质控链接！","info")
	}
	var PatientID = ServerObj.OutSysPatientID;
	var EpisodeID = ServerObj.OutSysEpisodeID;
	var csp = url.split('?')[0];
	var requset = url.split('?')[1];
	var arrrequest = requset.split('&');
	var trequset='';
	for (var i = 0 ; i < arrrequest.length;i++){
		var req = arrrequest[i];
		if ((req.split('=')[0]!='')&&(req.split('=')[1]!=''))
		{
			var str = req;
		}else{
			var str = "str = '"+req+"'+"+req.split('=')[0];
			eval(str)
		}
		if (trequset==''){
			trequset = str;
		}else{
			trequset = trequset+'&'+str;
		}
	}
	var url = csp+'?'+trequset
	if ('undefined'!== typeof websys_getMWToken) {
		url+='&MWToken='+websys_getMWToken();
	}
	document.getElementById('iframeviewQC').src=url;
	globalObj.m_qualityviewflg=1;
}

 /**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 编目功能按钮模块
 * DATE: 2019-11-28
 * NOTE: 编目功能按钮
 * TABLE: 
 */

// 同步首页数据
function SyncEmrData(){
    var ret = $m({
    	ClassName:"MA.IPMR.FPS.EmrRecordSrv",
    	MethodName:"getEmrDataByVol",
    	aVolumeID:ServerObj.VoumeID
    },false);
	if (ret==''){
		$.messager.alert("错误","同步医生首页数据失败...","error")
		return false;
	}else{
		return true;
	}
}

// 获取病历数据变化
function getEmrChage() {
	$cm({
    	ClassName:"MA.IPMR.FPS.EmrRecordSrv",
    	QueryName:"QryChange",
    	aVolumeID:ServerObj.VoumeID,
    	page:1,
    	rows:10000
    },function(rs){
    	var json = rs;
    	if (json.total==0) {
    		$.messager.popover({msg: '同步成功!病历首页没有数据变化！',type:'alert'});
    		return;
    	}
    	showEmrChangeDialog(json.rows);
    	
    });
}

// 显示病历同步弹框
function showEmrChangeDialog(array) {
	var Columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		{field: 'ItemDesc', title: '数据项', width: 160, align: 'left'},
		{field: 'IpmrShowValue', title: '病案编目', width: 100, align: 'left'},
		{field: 'EmrShowValue', title: '电子病历', width: 100, align: 'left'}
	]];
	var gridEmrChange= $HUI.datagrid("#gridEmrChange", {
		fit: true,
		iconCls : 'icon-write-order',
		rownumbers : true, 
		singleSelect : false,
		pagination : false, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10000,
		fitColumns : true,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    columns : Columns,
	    data: array
	});
	var title= '病历数据同步'+'<span style="color:red;">'+'&nbsp&nbsp&nbsp注意：诊断、手术同步会在现有编目数据基础上新增一行数据！注意修改保存！'+'</span>';
	var emrChangeDialog = $('#emrChangeDialog').dialog({
	    title: title,
		iconCls: 'icon-w-new',
	    width: 800,
        height: 500,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true,
		buttons:[{
			text:'同步',
				iconCls:'icon-w-synceprdata',
				handler:function(){
					var select= $('#gridEmrChange').datagrid('getSelections');
					if (select.length<1) {
						$.messager.popover({msg: '请至少勾选一条需要同步的数据项！',type: 'alert',timeout: 1000});
						return;
					}
					if (replaceData()) {
						$('#emrChangeDialog').dialog("close");
						$.messager.popover({msg: '同步成功！',type: 'success',timeout: 1000});
					}else{
						$.messager.alert("错误", "同步失败!", 'error');
					}
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#emrChangeDialog').dialog("close");
			}	
		}]
	});
}


/**
 * 替换编目数据
 * @param {} 
 * @return {Boolean} True 成功, false 失败
 */
function replaceData() {
	try {
		var select= $('#gridEmrChange').datagrid('getSelections');
		var dialogTypeArr = [];	// 诊断类型
		var operationTypeArr = [];	// 手术类型
		for (var i = 0; i < select.length; i++) {
			var row = select[i];
			var itemcat = row.ItemCat;
			var data = [itemcat,row.EmrId,row.EmrCode,row.EmrText]
			if (itemcat.charAt(0)=='D') {
				if (row.EmrText=='') continue;
				var info = itemcat+'^'+row.ItemRowNum;
				var flg=0;
				for (var j=0;j<dialogTypeArr.length;j++) {
					if (dialogTypeArr[j]==info) flg=1
					
				}
				if (flg==0){
					dialogTypeArr.push(info);
				}
			}else if (itemcat.charAt(0)=='O'){
				if (row.EmrText=='') continue;
				var info = itemcat+'^'+row.ItemRowNum;
				var flg=0;
				for (var j=0;j<operationTypeArr.length;j++) {
					if (operationTypeArr[j]==info) flg=1
					
				}
				if (flg==0){
					operationTypeArr.push(info);
				}
			}else if (itemcat.charAt(0)=='F'){
				if (document.getElementById('iframecost').src!='')	{
					document.getElementById('iframecost').contentWindow.replaceData(data);
				}
			}else{
				if (document.getElementById('iframebaseinfo').src!='')	{
					document.getElementById('iframebaseinfo').contentWindow.replaceData(data);
				}
			}
		}
		if (dialogTypeArr.length>0) {	// 诊断
			for (var i=0;i<dialogTypeArr.length;i++){
				selecttab('诊断信息');
				if (document.getElementById('iframediagnos').src!='') {
					document.getElementById('iframediagnos').contentWindow.addEmrData(dialogTypeArr[i]);
				}
			}
		}
		if (operationTypeArr.length>0) {	// 手术
			for (var i=0;i<operationTypeArr.length;i++){
				selecttab('手术信息');
				if (document.getElementById('iframeopration').src!='') {
					document.getElementById('iframeopration').contentWindow.addEmrData(operationTypeArr[i]);
				}
			}
		}
	}catch(e){
		return false;
	}
	return true;
}


// 数据保存方法
function SaveResult(status){
	openWinTip('编目数据保存中...');
	var MasterInfo = ServerObj.MasterID; 
	MasterInfo += CHR_1 + ServerObj.VoumeID; 
	MasterInfo += CHR_1 + ServerObj.MasterTypeID;  			//首页类型
	MasterInfo += CHR_1 + status;  						//状态
	MasterInfo += CHR_1 + Logon.UserID;   			//操作用户
	MasterInfo += CHR_1 + '';  							//备注
	MasterInfo += CHR_1 + ServerObj.WorkFItemID;  
	MasterInfo += CHR_1 + ServerObj.DefaultFPConfig;  // 默认编目配置ID

	var Patinfo ='';
	if (document.getElementById('iframebaseinfo').src!='')	{
		Patinfo= document.getElementById('iframebaseinfo').contentWindow.getPatinfo();
		if (Patinfo==false) {
			closeWinTip();
			return;
		}
	}
	var DiagInfo ='';
	var attDiagInfo = '';
	if (document.getElementById('iframediagnos').src!='')	{
		DiagInfo = document.getElementById('iframediagnos').contentWindow.getDiag(status);
		attDiagInfo = document.getElementById('iframediagnos').contentWindow.getAttDiag();
	}
	var OperInfo = '';
	if (document.getElementById('iframeopration').src!='')	{
		OperInfo= document.getElementById('iframeopration').contentWindow.getOper(status);
	}
	
	var CostInfo = '';
	if (document.getElementById('iframecost').src!='')	{
		CostInfo= document.getElementById('iframecost').contentWindow.getCostinfo();
	}

	if (CostInfo!='') Patinfo=Patinfo+CHR_2+CostInfo;
	if ((DiagInfo=='')&&(status=='C')){
		$.messager.popover({msg: '诊断信息为空！',type: 'alert',timeout: 1000});
		closeWinTip();
		return false;
	}
	$m({
		ClassName:"MA.IPMR.FPS.DataMasterSrv",
		MethodName:"SaveResult",
		aMasterInfo:MasterInfo,
		aDiagInfo:DiagInfo,
		aOperInfo:OperInfo,
		aPatInfo:Patinfo,
		aAttDiagInfo:attDiagInfo
	},function(txtData){
		closeWinTip();
		var arrtxtdata = txtData.split(CHR_1);
		if (arrtxtdata.length==1){		// 非质控失败
			$.messager.alert("错误","保存失败","error")
		}else if (arrtxtdata.length==3){
			var errcode = arrtxtdata[0];
			var ForceInfo = arrtxtdata[1];
			var TipInfo = arrtxtdata[2];
			if (parseInt(errcode) > 0){
				if (TipInfo!='')
				{
					var arrtip = TipInfo.split('^');
					var info='';
					for (i=0;i<arrtip.length ;i++ ){
						if (arrtip[i]=='') continue;
						for (j=0;j<arrtip[i].split('#').length ;j++ ){
							if (arrtip[i].split('#')[j]=='') continue;
							if (info==''){
								info=arrtip[i].split('#')[j];
							}else{
								info=info+'<br/>'+arrtip[i].split('#')[j];
							}
						}
					}
					$.messager.show({
						title:'提示性质控',
						width:500,
						height:400,
						msg:info,
						timeout:6000,
						showType:'slide'
					});
				}
				$.messager.popover({msg: '保存成功！',type: 'success',timeout: 1000});
				if (status=='C') OpenEmrWindow(ServerObj.EpisodeID);
				Common_Focus('txtMrNo');
				return true;
			}else{
				if (TipInfo!='')
				{
					var arrtip = TipInfo.split('^');
					var info='';
					for (i=0;i<arrtip.length ;i++ ){
						if (arrtip[i]=='') continue;
						for (j=0;j<arrtip[i].split('#').length ;j++ ){
							if (arrtip[i].split('#')[j]=='') continue;
							if (info==''){
								info=arrtip[i].split('#')[j];
							}else{
								info=info+'<br/>'+arrtip[i].split('#')[j];
							}
						}
					}
					$.messager.show({
						title:'提示性质控',
						width:500,
						height:400,
						msg:info,
						timeout:6000,
						showType:'slide'
					});
				}
				if (ForceInfo!=''){
					var arrforce = ForceInfo.split('^');
					var info='';
					for (i=0;i<arrforce.length ;i++ ){
						if (arrforce[i]=='') continue;
						for (j=0;j<arrforce[i].split('#').length ;j++ ){
							if (arrforce[i].split('#')[j]=='') continue;
							if (info==''){
								info=arrforce[i].split('#')[j];
							}else{
								info=info+'<br/>'+arrforce[i].split('#')[j];
							}
						}
					}
					$.messager.alert("强制性质控",info,"info")
				}
			}
		}
	});
}

// 初始化编目功能按钮
function InitBtnPower(status) {
	if (status=='C'){
		$('#btnDraft').linkbutton('disable');
	}else{
		$('#btnDraft').linkbutton('enable');
	}
}

// 弹出提示框
function openWinTip(aTitle){
	var _title=aTitle;
	$('#wintip').dialog({
	    title: _title,
	    width: 250,
	    height: 10,
	    closable:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
}
// 关闭提示框
function closeWinTip(){
	$('#wintip').window("close");
}

// 编目后病历浏览
function OpenEmrWindow(EpisodeID){
	// 是否启用编目后首页
	var CodingEMRStr  = ServerObj.IsEMRByCoding
	var IsCodingEMR = CodingEMRStr.split('|')[0];
	if (IsCodingEMR!='1') return false
	if (EpisodeID=='undefined') return false
	
	// 中医首页和西医首页模板不同
	if(globalObj.m_crrfptype == 0){
		var url =  CodingEMRStr.split('|')[1];
		var DocID 	= ServerObj.CodingDocID.split('|')[0];
	}else{
		var url =  CodingEMRStr.split('|')[2];
		var DocID 	= ServerObj.CodingDocID.split('|')[1];
	}
	if (DocID=='undefined') return false
  
  // 加入InstanceID创建新首页
	var InstanceID = $m({
  	ClassName:"EMRservice.HISInterface.PatientInfoAssist",
  	MethodName:"GetBMSYRecordID",
  	AEpisodeID:EpisodeID,
  	ADocIDs:DocID
  },false);
	var USERNAME= Logon.UserCode
	var htm		= url.split('?')[0];
	var requset = url.split('?')[1];
	var arrrequest = requset.split('&');
	var trequset='';
	for (var i = 0 ; i < arrrequest.length;i++){
		var req = arrrequest[i];
		// 模板ID是固定值
		if (req.split('=')[0]=='TPSID') {
			var str = req
		}else{
			var str = "str = '"+req+"'+"+req.split('=')[0];
		}
		eval(str)
		if (trequset==''){
			trequset = str;
		}else{
			trequset = trequset+'&'+str;
		}
	}
	var url = htm+'?'+trequset
	$('#windowEmr').window({    
		title:"病历浏览(编目)",   
	    resizable:true,
	    maximized:true,
	    onMinimize:function(){
		 //折叠  
		    $('#windowEmr').window('collapse').window('open');
	    },
	     onBeforeClose:function(){
		    $('#iframeFPWindow')[0].contentWindow.framRecord.savePrompt("")
		}
	});  
	document.getElementById('iframeFPWindow').src = url ;
	$('#windowEmr').window('open');
}

function apendPatInfoItem()
{
	$('#PatInfoItem').empty();
	var html = '<div class="'
	switch(ServerObj.Sex){
	   case $g('男'):
			html +='man"/>'
	       break;
	   case $g('女'):
			html +='woman"/>'
	       break;
	   default:
			html +='unman"/>'
	}
	html +='</div>'

	// 姓名
	html +='<div class="patname">'
	html +=ServerObj.PatName
    html +='</div>'
    html +='<div class="patinfo-slash">/</div>'
    // 性别
    html +='<div class="normal">'
	html +=ServerObj.Sex
    html +='</div>'
    html +='<div class="patinfo-slash">/</div>'
    // 年龄
    html +='<div class="normal">'
	html +=ServerObj.Age
    html +='</div>'
    html +='<div class="patinfo-slash">/</div>'
    // 是否死亡
    switch(ServerObj.IsDeath){
	   case '1':
       		 	html +='<div class="notice">'
				html +=$g('死亡')
    			html +='</div>'
    			html +='<div class="patinfo-slash">/</div>'
           break;
       default:
			break;
   	}
   	// 病案号
	html +='<div class="content"><lable>'
	html +=$g('病案号:')
	html +='</lable>'
	html +='<div class="content-notice"><lable>'
	html +=ServerObj.MrNo
	html +='</lable>'
	html +='</div>'
	html +='</div>'
	html +='<div class="patinfo-slash">/</div>'
	// 住院次数
	html +='<div class="content"><lable>'
	html +=$g('住院次数:')
	html +='</lable>'
	html +='<div class="content-normal"><lable>'
	html +=ServerObj.AdmTimes
	html +='</lable>'
	html +='</div>'
	html +='</div>'
	html +='<div class="patinfo-slash">/</div>'
	// 入院日期
	html +='<div class="content"><lable>'
	html +=$g('入院日期:')
	html +='</lable>'
	html +='<div class="content-normal"><lable>'
	html +=ServerObj.AdmDate
	html +='</lable>'
	html +='</div>'
	html +='</div>'
	html +='<div class="patinfo-slash">/</div>'
	// 出院日期
	html +='<div class="content"><lable>'
	html +=$g('出院日期:')
	html +='</lable>'
	html +='<div class="content-notice"><lable>'
	html +=ServerObj.DischDate
	html +='</lable>'
	html +='</div>'
	html +='</div>'
	html +='<div class="patinfo-slash">/</div>'
	// 出院科室
	html +='<div class="content"><lable>'
	html +=$g('出院科室:')
	html +='</lable>'
	html +='<div class="content-normal"><lable>'
	html +=ServerObj.DischLocDesc
	html +='</lable>'
	html +='</div>'
	html +='</div>'
	html +='<div class="patinfo-slash">/</div>'
	if (ServerObj.FillNoAct==1) {
		// 归档号
		html +='<div class="content"><lable>'
		html +=$g('归档号:')
		html +='</lable>'
		html +='<div class="content-normal"><lable>'
		html +=ServerObj.FillNo
		html +='</lable>'
		html +='</div>'
		html +='</div>'
		html +='<div class="patinfo-slash">/</div>'
   }
   $('#PatInfoItem').append(html)
}