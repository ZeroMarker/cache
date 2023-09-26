
/// 新版用药差错报告表JS  bianshuai 2016-04-25
var LINK_CSP="dhcapp.broker.csp";
var url="dhcpha.clinical.action.csp";
var RowDelim=String.fromCharCode(1);  //行数据间的分隔符
var PatientID="",EpisodeID="",mrRepID="",editRow="",mrstatus="";

/// 页面初始化函数
function initPageDefault(){
	
	mrRepID=getParam("mrRepID");
	EpisodeID=getParam("EpisodeID");
	mrstatus=getParam("mrstatus");    //liyarong 2016-0923
	initCombobox();  ///  页面Combobox初始定义
	initDataGrid();  ///  页面DataGrid初始定义
	initBlButton();  ///  页面Button 绑定事件
	initCheckBoxEvent();     /// 初始化页面CheckBox事件
	
		
	if (mrRepID != ""){
		LoadDrugMisRep(mrRepID); /// 加载报告信息
		if(mrstatus=="提交"){           //liyarong 2016-0923
		 $("a:contains('提交')").linkbutton('disable');
	     $("a:contains('保存')").linkbutton('disable');
		 	}
	}else{
		initPatInfo();           /// 加载病人基本信息
	}
        $("#mrRepDept").combobox('setValue',LgCtLocDesc);   //hzg 2018-7-2
}

/// 页面Combobox初始定义
function initCombobox(){
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCSTPHCMCOMMON&MethodName=";

	///  性别
	var url = uniturl+"jsonCTSex";
	new ListCombobox("mrPatSex",url,'',{panelHeight:"auto"}).init();
	
	///  职称
	var url = uniturl+"jsonCarPrvTp";
	new ListCombobox("mrProTit",url,'').init();
	
	///  科室
	var url = uniturl+"jsonGetEmPatLoc";
	new ListCombobox("mrRepDept",url,'').init();
	$('#mrRepDept').combobox({
		mode:'remote',
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#mrRepDept').combobox('reload','dhcpha.clinical.action.csp'+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
		//onLoadSuccess:function(){
			//$("#mrRepDept").combobox('setValue',LgCtLocID); 
		//}
	}); 
	//$("#mrRepDept").combobox('setValue',LgCtLocID); 
	//$("#mrRepDept").combobox('setText',LgCtLocDesc);
	
	///  报告人
	var url = uniturl+"jsonGetSSUser";
	new ListCombobox("mrRepUser",url,'').init();
	$("#mrRepUser").combobox('setValue',LgUserID);
	
	/// 发生日期
	$('#mrErrOccDate').datebox("setValue",formatDate(-2));
	
	/// 发现日期
	$('#mrDisErrDate').datebox("setValue",formatDate(-2));
	
	/// 报告日期
	$('#mrRepDate').datebox("setValue",formatDate(0));
}

/// 页面DataGrid初始定义
function initDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:"orditm",title:'医嘱ID',width:90,hidden:true},
		{field:"phcdf",title:'药学项ID',width:90,hidden:true},
	    {field:'incidesc',title:'商品名称',width:200,editor:texteditor},
	    {field:'genenic',title:'通用名',width:200,editor:texteditor},
	    {field:'genenicdr',title:'genenicdr',width:80,hidden:true},
	    {field:'manf',title:'厂家',width:100,editor:texteditor},
	    {field:'manfdr',title:'manfdr',width:80,hidden:true},
	    {field:'form',title:'剂型',width:100,align:'left',editor:texteditor},
	    {field:'formdr',title:'formdr',width:80,hidden:true},
	    {field:'instru',title:'用法',width:100,editor:texteditor},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'dosage',title:'剂量',width:100,editor:texteditor},
		{field:'dosuomdr',title:'单位ID',width:60,hidden:true},
		{field:'freq',title:'频次',width:100,hidden:true},
		{field:'freqdr',title:'频次ID',width:60,hidden:true},
		{field:'operation',title:'<a href="#" onclick="createPatOrdWin()"><img style="margin-left:3px;margin-top:6px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
			formatter:SetCellUrl}
	]];
	
	///  定义datagrid
	var option = {
		title:"药品列表",
		fit:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,
	    remoteSort:false,
		pagination: false
	};

	var uniturl = "";
	new ListComponent('mrPatOrdItmList', columns, uniturl, option).Init();
	
	///  初始化Datagrid行数
	InitListComponentRow();
}

//初始化列表使用
function InitListComponentRow(){
	
	for(var k=0;k<4;k++){
		$("#mrPatOrdItmList").datagrid('insertRow',{index: 0, row: {orditm:''}});
	}
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	return "<a href='#' onclick='deleteRow("+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

/// 删除行
function deleteRow(rowIndex){
	
	//行对象
    var rowobj={
		orditm:'', incidesc:'', genenic:'', manf:'', form:'', instru:'', dosage:''
	};

	//当前行数大于4,则删除，否则清空
	var rows = $("#mrPatOrdItmList").datagrid('getRows');

	if(rows.length > 4){
		 $("#mrPatOrdItmList").datagrid('deleteRow',rowIndex);
	}else{
		$("#mrPatOrdItmList").datagrid('updateRow',{
			index: rowIndex, // 行索引
			row: rowobj
		});
	}
	
	// 删除后,重新排序
	$("#mrPatOrdItmList").datagrid('sort', {	        
		sortName: 'incidesc',
		sortOrder: 'desc'
	});
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	
	///  添加
	$('a:contains("添加")').bind("click",addMisRepDrug);
	
	///  取消
	$('a:contains("取消")').bind("click",cancelPatOrdWin);
}

/// 初始化页面CheckBox事件
function initCheckBoxEvent(){

	$("input[type=checkbox]").live('click',function(){
		///  差错内容
		if (this.name == "mrErrContent") {
			return;
		}
		///  引发差错的因素
		if (this.name == "ErrTriFac") {
			return;
		}
		///  症状
		if (this.name == "EmSymFeild") {
			$(this).parent().remove();
			return;
		}
		$("input[name="+this.name+"]:not([value="+this.value+"])").each(function(){
			$(this).removeAttr("checked");
			setCheckBoxRelation(this.id);    //wangxuejian 2016-08-29
		})
		setCheckBoxRelation(this.id);         //wangxuejian 2016-08-29
	});
}

/// 加载病人信息
function initPatInfo(){

	runClassMethod("web.DHCSTPHCMDrugMisUseQuery","GetPatInfo",{"EpisodeID":EpisodeID,"PatientID":PatientID},function(jsonString){

		if (jsonString != null){
			var rowData = jsonString;
			setRegPanelInfo(rowData);
		}
	},'json',false)
}

/// 设置登记面板数据
function setRegPanelInfo(rowData){
	
	PatientID = rowData.PatientID;
	$("#PatientID").val(rowData.PatientID);    /// 病人ID
	$("#mrPatName").val(rowData.PatName);      /// 姓名
	$("#mrPatDOB").datebox("setValue",rowData.birthday);     /// 出生日期
	$("#mrPatAge").val(rowData.PatAge);        /// 年龄
	$("#mrPatSex").combobox("setValue",rowData.sexId);       /// 性别
	$("#mrPatWeight").val(rowData.PatWeight);  /// 体重
	$("#mrPatContact").val(rowData.PatTelH);   /// 联系方式
	$("#mrPatNo").val(rowData.PatNo);          /// 登记号
	$("#mrPatDiag").val(rowData.PatDiag);      /// 诊断
}

/// 病人用药医嘱窗口
function createPatOrdWin(){

	$('#mrPatWin').window({
		title:'用药医嘱列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:400,
		minimizable:false,					/// 隐藏最小化按钮
		maximized:true						/// 最大化(qunianpeng 2018/5/2)
	}); 

	$('#mrPatWin').window('open');
	initPatOrdList(); /// 用药医嘱列表
}

/// 用药医嘱列表
function initPatOrdList(){
	
	//定义columns
	var columns=[[
		{field:"select",checkbox:true,width:20},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:'优先级',width:40},
		{field:'StartDate',title:'开始日期',width:80}, //日期错误 duwensheng 2016-09-13
		{field:'EndDate',title:'结束日期',width:80},
		{field:'incidesc',title:'名称',width:200},
		{field:'genenic',title:'通用名',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'剂量',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'用法',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'manf',title:'厂家',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'剂型',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'freq',title:'频次',width:80},
		{field:'freqdr',title:'freqdr',width:80,hidden:true}
		
	]];

	//定义datagrid  //2016-09-05 qunianpeng
	$('#medInfo').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
	    pageNumber:1,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
   $('#medInfo').datagrid('loadData', {total:0,rows:[]});
}

///  添加药品到报告类别
function addMisRepDrug(){
	
	/// 用药医嘱列表
	var rows = $('#mrPatOrdItmList').datagrid('getRows');
	for(var i=0;i<rows.length;i++){
		if(rows[i].orditm == ""){
			break;
		}
	}

	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems==""){
		 $.messager.alert("提示:","请先选择药品！");
		 return;
		}
	var ItemFlag="";
    $.each(checkedItems, function(index, item){
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic, genenicdr:item.genenicdr, manf:item.manf,
			manfdr:item.manfdr, formdr:item.formdr, form:item.form, dosage:item.dosage, instru:item.instru, instrudr:item.instrudr, 
			dosuomdr:item.dosuomID, freq:item.freq, freqdr:item.freqdr
		}

		//列表项中数据若已存在，则先提示，再关闭窗口
		for(var j=0;j<rows.length;j++){
			if(item.incidesc==rows[j].incidesc){
				ItemFlag=1;
				alert("药品列表已存在'"+rows[j].genenic+"',请重新选择!");
				return;
			}
		}
		if(ItemFlag!=1){
	    if((i>3)||(rows.length<=i)){
			$("#mrPatOrdItmList").datagrid('appendRow',rowobj);
		}else{
			$("#mrPatOrdItmList").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
				index: i, // 行数从0开始计算
				row: rowobj
			});
		}}
		i=i+1;		
    })
	 if(ItemFlag!=1){
    $.messager.alert("提示:","添加成功！");
    cancelPatOrdWin();
     }
}

///  关闭病人列表窗口
function cancelPatOrdWin(){

	$('#mrPatWin').window('close');
	
}
function saveBeforeCheck(){  //2016-09-29
	var mrDspToPat = "";
	if ($("input[name='mrDspToPat']:checked").length){
		mrDspToPat = $("input[name='mrDspToPat']:checked").val();     /// 是否发给患者
	}
	if(mrDspToPat==""){
		$.messager.alert("提示:","【错误药品是否发给患者】不能为空！");
		return false;
	}
	
	var mrErrorLevel = "";  
	if ($("input[name='mrErrorLevel']:checked").length){
		mrErrorLevel = $("input[name='mrErrorLevel']:checked").val(); /// 错误分级
	}
	if(mrErrorLevel==""){
		$.messager.alert("提示:","【错误分级】不能为空！");
		return false;
	}
	
	/// 伤害结果(死亡/伤害)
	var HarmRet = "";HarmRetDesc = "";
	if ($('input[name="HarmRet"]:checked').length){
		HarmRet = $('input[name="HarmRet"]:checked').val();
	}
	if(HarmRet==""){
	   $.messager.alert("提示:","【患者伤害情况】不能为空！");
		return false;
	}
	
	/// 发生场所
	var ErrHappSite = "";ErrHappSiteDesc = "";
	if ($('input[name="ErrHappSite"]:checked').length){
		ErrHappSite = $('input[name="ErrHappSite"]:checked').val();
	}
	if(ErrHappSite==""){
		$.messager.alert("提示:","【发生错误的场所】不能为空！");
		return false;
	}
	
	/// 引起错误人员
	var TriErrUser = "";TriErrUserDesc = "";
	if ($('input[name="TriErrUser"]:checked').length){
		TriErrUser = $('input[name="TriErrUser"]:checked').val();
	}
	 if(TriErrUser==""){
		$.messager.alert("提示:","【引起错误的人员】不能为空！");
		return false;
	}
	
	/// 差错内容
	var ErrContent = [];
	$('input[name="mrErrContent"]:checked').each(function(){
		ErrContent.push(this.value);
	})
	ErrContent = ErrContent.join("||");
	if(ErrContent==""){
		$.messager.alert("提示:","【差错内容】不能为空！");
		return false;
	}
	
	/// 引发错误的因素
	var ErrTriFac = [];
	$('input[name="ErrTriFac"]:checked').each(function(){
		ErrTriFac.push(this.value);
	})
	ErrTriFac = ErrTriFac.join("||");
	if(ErrTriFac==""){
		$.messager.alert("提示:","【引发错误的因素】不能为空！");
		return false;
	}
	
	/// 药品列表
	var mrItemList = [];
	var mrPatOrdItems = $("#mrPatOrdItmList").datagrid('getRows');
	$.each(mrPatOrdItems, function(index, item){
		if(item.orditm!=""){
		 	var ItemList = item.orditm +"^"+ item.phcdf +"^"+ item.incidesc +"^"+ item.genenicdr +"^"+ item.formdr +"^"+ item.dosage +"^"+ item.dosuomdr +"^"+ item.instrudr
		 	    +"^"+ item.freqdr +"^"+ item.manfdr;
		  	mrItemList.push(ItemList);
		 }
	})
	mrItemList = mrItemList.join("!!");
	if(mrItemList==""){
		$.messager.alert("提示:","【药品列表】不能为空！");
		return false;
	}
	return true ;
	}
/// 保存报告内容
function saveMisRep(flag){
		if((flag)&&(!saveBeforeCheck())){   //liyarong 2016-09-29
		return;
	}
	
	var mrRepDate = $("#mrRepDate").datebox("getValue");        /// 报告日期
	var mrErrOccDate = $("#mrErrOccDate").datebox("getValue");  /// 发生日期
	var mrDisErrDate = $("#mrDisErrDate").datebox("getValue");  /// 发现日期
	var mrDspToPat = "";
	if ($("input[name='mrDspToPat']:checked").length){
		mrDspToPat = $("input[name='mrDspToPat']:checked").val();     /// 是否发给患者
	}
	
	var mrPatTaked = "";
	if ($("input[name='mrPatTaked']:checked").length){
		mrPatTaked = $("input[name='mrPatTaked']:checked").val();     /// 患者是否使用
	}
	
	var mrErrorLevel = "";  
	if ($("input[name='mrErrorLevel']:checked").length){
		mrErrorLevel = $("input[name='mrErrorLevel']:checked").val(); /// 错误分级
	}

	var mrPatName = $("#mrPatName").val();				 /// 患者姓名
	var mrPatSex = $("#mrPatSex").combobox("getValue");  /// 性别
	var mrPatAge = $("#mrPatAge").val();   				 /// 年龄
	var mrPatDOB = $("#mrPatDOB").datebox("getValue");   /// 出生日期
	var mrPatWeight = $("#mrPatWeight").val();           /// 体重
	var mrPatContact = $("#mrPatContact").val();         /// 联系方式
	var mrPatNo = $("#mrPatNo").val();  				 /// 住院号/门诊就诊号
	
	var mrPatDiag = $("#mrPatDiag").val();			     /// 诊断描述
	
	/// 伤害结果(死亡/伤害)
	var HarmRet = "";HarmRetDesc = "";
	if ($('input[name="HarmRet"]:checked').length){
		HarmRet = $('input[name="HarmRet"]:checked').val();
	}
	if (HarmRet>10){
		HarmRetDesc=$('#HarmRetDesc'+HarmRet).val();
	}
	
	var mrDeathDate="";mrDeathTime="";
	var DeathTime = $("#DeathTime").datetimebox('getValue');
	if (DeathTime != ""){ 
		mrDeathDate = DeathTime.split(" ")[0];  /// 死亡日期
		mrDeathTime = DeathTime.split(" ")[1];  /// 死亡时间
	}
	
	/// 抢救措施描述
	var mrRescue = "N";
	if ($("#CriticallyIll:checked").length){
		mrRescue = "Y";
	}
	var mrResMeasDesc = $("#mrResMeasDesc").val();
	
	/// 恢复过程
	var mrRecProc = "";
	if ($('input[name="mrRecProc"]:checked').length){
		mrRecProc = $('input[name="mrRecProc"]:checked').val();
	}
	
	var mrRepUser = $("#mrRepUser").combobox("getValue");     /// 报告人
	var mrRepDept = $("#mrRepDept").combobox("getValue");     /// 报告人科室
	var mrProTit = $("#mrProTit").combobox("getValue");       /// 职称
	var mrRepTel = $("#mrRepTel").val();       /// 电话
	var mrEmail = $("#mrEmail").val();         /// E-mail
	var mrPostCode = $("#mrPostCode").val();   /// 邮编
	
	/// 发生场所
	var ErrHappSite = "";ErrHappSiteDesc = "";
	if ($('input[name="ErrHappSite"]:checked').length){
		ErrHappSite = $('input[name="ErrHappSite"]:checked').val();
	}
	if (ErrHappSite == "99"){
		ErrHappSiteDesc = $("#ErrHappSiteDesc").val();
	}
	
	
	/// 引起错误人员
	var TriErrUser = "";TriErrUserDesc = "";
	if ($('input[name="TriErrUser"]:checked').length){
		TriErrUser = $('input[name="TriErrUser"]:checked').val();
	}
	if (TriErrUser == "99"){
		TriErrUserDesc = $("#TriErrUserDesc").val();
	}
	/// 发现错误人员
	var DisErrUser = "";DisErrUserDesc = "";
	if ($('input[name="DisErrUser"]:checked').length){
		DisErrUser = $('input[name="DisErrUser"]:checked').val();
	}
	if (DisErrUser == "99"){
		DisErrUserDesc = $("#DisErrUserDesc").val();
	}
	
	/// 错误相关人员
	var ErrRelUser = "";ErrRelUserDesc = "";
	if ($('input[name="ErrRelUser"]:checked').length){
		ErrRelUser = $('input[name="ErrRelUser"]:checked').val();
	}
	if (ErrRelUser == "99"){
		ErrRelUserDesc = $("#ErrRelUserDesc").val();
	}
	
	/// 错误的发现和避免措施
	var mrDisAndHandMea = $("#mrDisAndHandMea").val();
	if (mrDisAndHandMea == "请简述事件发生、发现、后果及防范措施！"){
		mrDisAndHandMea = "";
	}
	
	/// 是否提供药品相关资料
	var mrProDrgRelInfo = "";mrDrgRelInfoDesc = "";
	if ($('input[name="mrProDrgRelInfo"]:checked').length){
		mrProDrgRelInfo = $('input[name="mrProDrgRelInfo"]:checked').val();
	}
	if (mrProDrgRelInfo == "99"){
		mrDrgRelInfoDesc = $("#mrDrgRelInfoDesc").val();
		//$('#mrDrgRelInfoDesc').attr("disabled",false);
	}
	
	/// 差错内容
	var ErrContent = [];
	$('input[name="mrErrContent"]:checked').each(function(){
		ErrContent.push(this.value);
	})
	var ErrContentDesc = $("#mrErrContentDesc").val();
	if (ErrContentDesc != ""){
		ErrContent.push("99"+"#"+ErrContentDesc);
	}
	ErrContent = ErrContent.join("||");
	
	
	/// 引发错误的因素
	var ErrTriFac = [];
	$('input[name="ErrTriFac"]:checked').each(function(){
		ErrTriFac.push(this.value);
	})
	var ErrTriFacDesc = $("#ErrTriFacDesc").val();
	if (ErrTriFacDesc != ""){
		ErrTriFac.push("99"+"#"+ErrTriFacDesc);
	}
	ErrTriFac = ErrTriFac.join("||");
	

	/// 报告日期^发生日期^发现日期^是否发给患者^患者是否使用^错误分级^姓名^性别^年龄^出生日期^体重^联系方式^登记号^诊断^伤害结果
	/// 伤害结果描述^死亡日期^死亡时间^抢救^抢救(措施)^恢复过程^报告人^报告科室^职称^电话^E-mail^邮编^发生错误的场所^发生错误的场所描述
	/// 引起差错的人员^引起差错的人员描述^发现错误人员^发现错误人员描述^错误相关人员^错误相关人员描述^后果及防范措施^是否提供药品相关资料^是否提供药品相关资料描述^错误内容^引发错误的因素
	var mrListData = mrRepDate +"^"+ mrErrOccDate +"^"+ mrDisErrDate +"^"+ mrDspToPat +"^"+ mrPatTaked +"^"+ mrErrorLevel +"^"+ PatientID +"^"+ mrPatName +"^"+ mrPatSex +"^"+ mrPatAge;
	    mrListData = mrListData +"^"+ mrPatDOB +"^"+ mrPatWeight +"^"+ mrPatContact +"^"+ mrPatNo +"^"+ mrPatDiag +"^"+ HarmRet +"^"+ HarmRetDesc +"^"+ mrDeathDate +"^"+ mrDeathTime;
	    mrListData = mrListData +"^"+ mrRescue +"^"+ mrResMeasDesc +"^"+ mrRecProc +"^"+ mrRepUser +"^"+ mrRepDept +"^"+ mrProTit +"^"+ mrRepTel +"^"+ mrEmail +"^"+ mrPostCode +"^"+ ErrHappSite +"^"+ ErrHappSiteDesc;
	    mrListData = mrListData +"^"+ TriErrUser +"^"+ TriErrUserDesc +"^"+ DisErrUser +"^"+ DisErrUserDesc +"^"+ ErrRelUser +"^"+ ErrRelUserDesc +"^"+ mrDisAndHandMea +"^"+ mrProDrgRelInfo +"^"+ mrDrgRelInfoDesc;
	    mrListData = mrListData +"^"+ ErrContent +"^"+ ErrTriFac;

	/// 药品列表
	var mrItemList = [];
	var mrPatOrdItems = $("#mrPatOrdItmList").datagrid('getRows');
	$.each(mrPatOrdItems, function(index, item){
		if(item.orditm!=""){
		 	var ItemList = item.orditm +"^"+ item.phcdf +"^"+ item.incidesc +"^"+ item.genenicdr +"^"+ item.formdr +"^"+ item.dosage +"^"+ item.dosuomdr +"^"+ item.instrudr
		 	    +"^"+ item.freqdr +"^"+ item.manfdr;
		  	mrItemList.push(ItemList);
		 }
	})
	mrItemList = mrItemList.join("!!");
	
		if(flag==1){		
		var curStatus="Y";
		var mrListData=mrListData+"^"+curStatus;
		}else if(flag==0){	
	    var curStatus="N";
	    var mrListData=mrListData+"^"+curStatus;    
		}
	
	/// 保存数据
	runClassMethod("web.DHCSTPHCMDrugMisUseReport","save",{"mrRepID":mrRepID,"mrListData":mrListData,"mrItemList":mrItemList},function(jsonString){
		var mrret = jsonString;
		if (mrret > 0){
			mrRepID = mrret;
			LoadDrugMisRep(mrRepID);   ///  加载报告数据
			if(flag==1){
				  $.messager.alert("提示:","提交成功！");	                 //liyarong 2016-10-09
				  $("a:contains('提交')").linkbutton('disable');
				  $("a:contains('保存')").linkbutton('disable');
			}else if(flag==0){
				  $.messager.alert("提示:","保存成功！");
			  }
		    parent.Query(); 
		}else{
		    if(flag==1){
				  $.messager.alert("提示:","提交失败！"); 
			}else if(flag==0){
				  $.messager.alert("提示:","保存失败！");  
			 }
		}
	})
}

///  加载报告数据
function LoadDrugMisRep(mrRepID){

	runClassMethod("web.DHCSTPHCMDrugMisUseQuery","GetMisRep",{"mrRepID":mrRepID},function(jsonString){

		if (jsonString != null){
			var mrRepObj = jsonString;
			
			$("#mrRepCode").val(mrRepObj.mrRepNo);        			       /// 编码
			$("#mrRepDate").datebox("setValue",mrRepObj.mrRepDate);        /// 报告日期
			$("#mrErrOccDate").datebox("setValue",mrRepObj.mrRepOccDate);  /// 发生日期
			$("#mrDisErrDate").datebox("setValue",mrRepObj.mrRepDisDate);  /// 发现日期
			PatientID=mrRepObj.mrRepPatID;                                 ///病人id  liyarong2016-10-8                      
			EpisodeID=mrRepObj.mrRepPatAdm;                                ///就诊id  liyarong2016-10-8
			$("#mrPatName").val(mrRepObj.mrRepPatName);				       /// 患者姓名
			$("#mrPatSex").combobox("setValue",mrRepObj.mrRepPatSex);      /// 性别
			$("#mrPatAge").val(mrRepObj.mrRepPatAge);   				   /// 年龄
			$("#mrPatDOB").datebox("setValue",mrRepObj.mrRepPatDOB);       /// 出生日期
			$("#mrPatWeight").val(mrRepObj.mrRepPatWeight);                /// 体重
			$("#mrPatContact").val(mrRepObj.mrRepPatContact);              /// 联系方式
			$("#mrPatNo").val(mrRepObj.mrRepPatMedNo);  				   /// 住院号/门诊就诊号
			$("#mrPatDiag").val(mrRepObj.mrRepPatICDDesc);			       /// 诊断描述
	
		    $("#mrRepUser").combobox("setValue",mrRepObj.mrRepUser);     /// 报告人
			$("#mrRepDept").combobox("setValue",mrRepObj.mrRepDept);     /// 报告人科室
			$("#mrProTit").combobox("setValue",mrRepObj.mrRepProTitle);  /// 职称
			$("#mrRepTel").val(mrRepObj.mrRepTel);           /// 电话
			$("#mrEmail").val(mrRepObj.mrRepEmail);          /// E-mail
			$("#mrPostCode").val(mrRepObj.mrRepPostCode);    /// 邮编

			$("#mrDisAndHandMea").val(mrRepObj.mrDisAndHandMea);  /// 错误的发现和避免措施
			
			/// 发现错误人员
			$('input[name="DisErrUser"][value="'+ mrRepObj.mrRepDisErrUser +'"]').attr("checked",'checked');
			$("#DisErrUserDesc").val(mrRepObj.mrRepDisErrUserDesc);
	
			/// 错误相关人员
			$('input[name="ErrRelUser"][value="'+ mrRepObj.mrRepErrRelUser +'"]').attr("checked",'checked');
			$("#ErrRelUserDesc").val(mrRepObj.mrRepErrRelUserDesc);
		
			/// 发生场所
			$('input[name="ErrHappSite"][value="'+ mrRepObj.mrRepHappSite +'"]').attr("checked",'checked');
			$("#ErrHappSiteDesc").val(mrRepObj.mrRepHappSiteDesc);

			/// 引起错误人员
			$('input[name="TriErrUser"][value="'+ mrRepObj.mrRepTriErrUser +'"]').attr("checked",'checked');
			$("#TriErrUserDesc").val(mrRepObj.mrRepTriErrUserDesc);
			
			/// 是否发给患者
			$('input[name="mrDspToPat"][value="'+ mrRepObj.mrRepDspToPat +'"]').attr("checked",'checked');
	
			/// 患者是否使用
			$('input[name="mrPatTaked"][value="'+ mrRepObj.mrRepPatTaked +'"]').attr("checked",'checked');
	
			/// 错误分级
			$('input[name="mrErrorLevel"][value="'+ mrRepObj.mrRepLevel +'"]').attr("checked",'checked');
	
			/// 伤害结果(死亡/伤害)
			$('input[name="HarmRet"][value="'+ mrRepObj.mrRepHarmRet +'"]').attr("checked",'checked');
			$('#HarmRetDesc'+mrRepObj.mrRepHarmRet).val(mrRepObj.mrRepHarmRetDesc);
			
			/// 死亡日期
			if((mrRepObj.mrRepDeathDate=="")&&(mrRepObj.mrRepDeathTime=="")){
				     $("#DeathTime").datetimebox('setValue',"");
			}else{
				     $("#DeathTime").datetimebox('setValue',mrRepObj.mrRepDeathDate+" "+mrRepObj.mrRepDeathTime);	
		     	 }
	
			/// 抢救措施描述
			$('input[name="HarmRet"][value="'+ mrRepObj.mrRepRescue +'"]').attr("checked",'checked');
			$("#mrResMeasDesc").val(mrRepObj.mrRepResMeasDesc);
	
			/// 恢复过程
			$('input[name="mrRecProc"][value="'+ mrRepObj.mrRepRecProc +'"]').attr("checked",'checked');
			
			/// 是否提供药品相关资料
			$('input[name="mrProDrgRelInfo"][value="'+ mrRepObj.mrProDrgRelInfo +'"]').attr("checked",'checked');
			$("#mrDrgRelInfoDesc").val(mrRepObj.mrDrgRelInfoDesc);
			
			/// 引发错误的因素
			var ErrTriFacArr = mrRepObj.mrRepTriErrFac.split("||");
			for (var i=0;i<ErrTriFacArr.length;i++){
				if (ErrTriFacArr[i].indexOf("#") == "-1"){
					$('input[name="ErrTriFac"][value="'+ ErrTriFacArr[i] +'"]').attr("checked",'checked');
				}else{
					 $("#ErrTriFacDesc").val(ErrTriFacArr[i].split("#")[1]);
				}
			}
			
			/// 差错内容
			var mrRepErrConArr = mrRepObj.mrRepErrContent.split("||");
			for (var i=0;i<mrRepErrConArr.length;i++){
				if (mrRepErrConArr[i].indexOf("#") == "-1"){
					$('input[name="mrErrContent"][value="'+ mrRepErrConArr[i] +'"]').attr("checked",'checked');
				}else{
					 $("#mrErrContentDesc").val(mrRepErrConArr[i].split("#")[1]);
				}
			}
		}
	})
	
	/// 加载药品列表
	var uniturl = LINK_CSP+"?ClassName=web.DHCSTPHCMDrugMisUseQuery&MethodName=QueryMRDrugMisList";
	$("#mrPatOrdItmList").datagrid({ url:uniturl, queryParams:{ mrRepID:mrRepID}});
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })

function setCheckBoxRelation(id){   //wangxuejian 2016-08-29
//	if($('#'+id).hasClass('cb_active')){
	if($('#'+id).is(':checked')){  
		///患者及家属
		if(id=="TriErrUser"){
			$('#TriErrUserDesc').attr("disabled",false);
		}		
		///残疾(部位、程度)
		if(id=="HL12"){
			$('#HarmRetDesc12').attr("disabled",false);
		}
		///暂时伤害(部位、程度)
		if(id=="HL11"){
			$('#HarmRetDesc11').attr("disabled",false);
			//$('#adrrEventRDRDate').datebox({disabled:false});
		}
	    ///抢救(措施)
		if(id=="CriticallyIll"){
			$('#mrResMeasDesc').attr("disabled",false);
		}    
		///死亡(直接死因)
		if(id=="death"){
			$('#HarmRetDesc13').attr("disabled",false);
			$("#DeathTime").datetimebox({disabled:false});  //zhaowuqiang 2016-09-14
		}
		///是否能够提供药品标签、</br>处方复印件等资料
		if(id=="ER99"){
		   	$('#mrDrgRelInfoDesc').attr("disabled",false);
		}
		///其他与错误相关的人员
		if(id=="ErrRelUser"){
			$('#ErrRelUserDesc').attr("disabled",false);
		}
		///发现错误的人员
		if(id=="DisErrUser"){
			$('#DisErrUserDesc').attr("disabled",false);
		}
		///发生错误的场所
		if(id=="ErrHappSite"){
			$('#ErrHappSiteDesc').attr("disabled",false);
		}
	}else{
		///患者及家属
		if(id=="TriErrUser"){
			$('#TriErrUserDesc').val("");
			$('#TriErrUserDesc').attr("disabled","true");
		}
		///残疾(部位、程度)
		if(id=="HL12"){
			$('#HarmRetDesc12').val("");
			$('#HarmRetDesc12').attr("disabled","true");
		}	
		///暂时伤害(部位、程度)
		if(id=="HL11"){
			$('#HarmRetDesc11').val("");
			$('#HarmRetDesc11').attr("disabled","true");
		}    
	    ///抢救(措施)
		if(id=="CriticallyIll"){
			$('#mrResMeasDesc').val("");
			$('#mrResMeasDesc').attr("disabled","true");
		}
		///死亡(直接死因)
		if(id=="death"){
			$('#HarmRetDesc13').val("");
			$('#HarmRetDesc13').attr("disabled","true");
			$("#DeathTime").datetimebox({disabled:true});  //zhaowuqiang 2016-09-14
		}
		///是否能够提供药品标签、</br>处方复印件等资料
		if(id=="ER99"){
			$('#mrDrgRelInfoDesc').val("");
			$('#mrDrgRelInfoDesc').attr("disabled","true");
		}
		///其他与错误相关的人员
		if(id=="ErrRelUser"){
			$('#ErrRelUserDesc').val("");
			$('#ErrRelUserDesc').attr("disabled","true");
		}
		///发现错误的人员
		if(id=="DisErrUser"){
			$('#DisErrUserDesc').val("");
			$('#DisErrUserDesc').attr("disabled","true");
		}
		///发生错误的场所
		if(id=="ErrHappSite"){
			$('#ErrHappSiteDesc').val("");
			$('#ErrHappSiteDesc').attr("disabled","true");
		}
	}
}