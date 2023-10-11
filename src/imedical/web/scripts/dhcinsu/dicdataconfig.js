/*
 * FileName:	dicdataconfig.js
 * User:		Hanzh 
 * Date:		2022-08-11
 * Description: 医保系统参数配置
 */

var GUser=session['LOGON.USERID'];
var HospDr=session['LOGON.HOSPID'];
var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],
	}
}
var INSUTYPE="";
var PassWardFlag="N";
var arr = new Array();
$(function(){
	//初始化医保类型
	init_INSUType();
	
	//页面元素初始化
	Initpage();
	
	//保存
	$HUI.linkbutton("#btn-save", {
		onClick: function() {
			save();
		}
	});
	$HUI.linkbutton("#btn-save2", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save3", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save4", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save5", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save6", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save7", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save8", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save9", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save10", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save11", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save12", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save13", {onClick: function() {save();}});
	$HUI.linkbutton("#btn-save14", {onClick: function() {save();}});
	//tab标签切换
	$HUI.tabs("#tab",{
		onload:function(title){
			arr=[];					
		},
		onSelect:function(title){
			arr=[];					
		}
	})
	
});

/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	}
	INSULoadDicData('InsuType','DLLType',Options); 	//scripts/dhcinsu/common/dhcinsu.common.js	
	$('#InsuType').combobox({
		onSelect:function(){
		    Init();
		}	
	})	
}
function Init()
{ 
	Clean();
	INSUTYPE="";
	var InsuType=$('#InsuType').combobox("getValue");
	$.cm({
		ClassName:"web.INSUDicDataConfig",
		MethodName:"GetINSUDicDataConfigInfo",
		HospId:PUBLIC_CONSTANT.SESSION.HOSPID,
		InsuType:InsuType,
		dataType:"text"
	},function(rtnStr){
		var rtnArr=rtnStr.split(",")
		//初始化字典数据
		//AdmDateCtl,DischDateCtl,AdmDateIsEdit,InsuDivRegFlag,PaadmConInadmType,OPRegBXFlag,OPRegUseZHFlag,,OPRegEffecDays,INSUMergesOP,
		//INSUMerges,UpDetailMode,UpFDetailMode,INSUBILLDATECTL,INSUDETDATACTL,NotConstracted,NotAudit,NoChecked,TariInsuFlag,TariSpecialFlag,
		//TarContrastAuditFlag,ChkInsuFlagMod,OPStrikeIsReadCard,ICDContrastFlag,IPRegDesIsReadCard,IPUseZHFlag,OPUseZHFlag,ZeroOrdIsUpFlag
		var DicCode="";
		var DicValue="";
		for(var i=1;i<rtnArr.length;i++){
			var DicData=rtnArr[i].split("^");
			DicType=DicData[0];
			DicCode=DicData[1];
			DicValue=DicData[2];

			if ((DicValue=="")&&((DicCode=="UpDetailMode")||(DicCode=="TarContrastAuditFlag")||(DicCode=="INSUBILLDATECTL")||(DicCode=="OPRegEffecDays")||(DicCode=="InsuDiscountCtl"))){
				DicValue="0";
			}
			if (DicType=="SYS"){
				if(DicCode=="DBEncrypt"){
					setValueById("Key",DicData[2]);
					setValueById("Username",DicData[3]);
					setValueById("Password",DicData[4]);
					setValueById("LinkType",DicData[5]);
				}else{
					setValueById(DicCode+"_SYS",DicValue);
				}
			}else{
				setValueById(DicCode,DicValue);
			}	
		}
	});
	setTimeout("INSUTYPE=$('#InsuType').combobox('getValue');arr=[]",1000);
	
}

function save(){
	InsuDicDataUp()
}

function InsuDicDataUp()
{
    var InsuType=$('#InsuType').combobox("getValue");
    if(InsuType==INSUTYPE){
        var oldOk = $.messager.defaults.ok;
		var oldCancel = $.messager.defaults.cancel;
		$.messager.defaults.ok = "确定";
		$.messager.defaults.cancel = "取消";
		$.messager.confirm("更新", "此配置更新会影响到业务流程，确定是否已在测试库更新测试", function (r) {
			if (r) {
				if(PassWardFlag == "N"){
	    			$.messager.prompt("提示", "请输入密码", function (r) {
						if (r) {
							PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
							if(PassWardFlag=='Y'){ 
								UptINSUDicData();
								Init();
							}
							else{
								$.messager.alert('错误','密码错误','error');	
							}
						} else {
							$.messager.popover({ msg: "点击了取消" });
						}
					})
				}else{
					UptINSUDicData(); 
					Init();
				} 
			} else {
				$.messager.popover({ msg: "点击了取消" });
				//INSUTYPE="";
			}
		});
		$.messager.defaults.ok = oldOk;
		$.messager.defaults.cancel = oldCancel;    
    } 
}
function UptINSUDicData()
{
	var InsuType=$('#InsuType').combobox("getValue");
	var UpdateStr=arr.toString();
	$.m({
		ClassName:"web.INSUDicDataConfig",
		MethodName:"UptConfigInfo",
		InsuType:InsuType,
		UpdateStr:UpdateStr,
		HospId:PUBLIC_CONSTANT.SESSION.HOSPID
	},function(rtnStr){
		var rtn=rtnStr.split("!")[0];
		if (rtn<"0")
		{
			$.messager.alert('更新字典数据失败',rtnStr,'info');
			INSUTYPE="";
			return;
		}
		var rtnList=rtnStr.split("!")[1];
		$.messager.alert('更新字典数据完成',"更新总条数:"+rtnList.split("^")[0]+",成功:"+rtnList.split("^")[1]+",失败:"+rtnList.split("^")[2],'info');

	});
	Init();	
}	

function Initpage(){
	//st 医保环境配置--NormalConfig
	//是否自动启动中间件（只有为1是自动启动）
	$('#AutoStartINSUService_SYS').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","UpDetailMode",newValue)
		}
	});
	//是否弹框提示
	$('#MsgBoxFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","MsgBoxFlag",newValue)
		}
	});
	//是否保存医保交互数据日志
	$('#InsuLogInsuFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","InsuLogInsuFlag",newValue)
		}
	});
	//是否保存医保接口函数流程日志
	$('#InsuLogHisFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","InsuLogHisFlag",newValue)
		}
	});
	//是否保存医保主业务日志
	$('#InsuLogBussFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","InsuLogBussFlag",newValue)
		}
	});
	//是否保存数据库日志
	$('#InsuMsgInfoFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","InsuMsgInfoFlag",newValue)
		}
	});
	//数据库连接用户名
	var Username=""
	$("#Username").on("click",function(){Username=$("#Username").val();}); 
    $("#Username").blur(function(){
	    if (Username!=$("#Username").val()){
			arr=ArrPush("SYS","DBEncrypt",$('#Username').val())  
		}
	});
	//数据库连接密码
	var Password=""
	$("#Password").on("click",function(){Password=$("#Password").val();}); 
    $("#Password").blur(function(){
	    if (Password!=$("#Password").val()){
			arr=ArrPush("SYS","DBEncrypt",$('#Password').val())
		}
	});
	//数据库连接密钥
	var Key=""
	$("#Key").on("click",function(){Key=$("#Key").val();}); 
    $("#Key").blur(function(){
	    if (Key!=$("#Key").val()){
			arr=ArrPush("SYS","DBEncrypt",$('#Key').val())
		}
	});
	//数据库连接方式
	$('#LinkType').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'DLL',text:'DLL'},
			{id:'WEB',text:'WEB'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("SYS","DBEncrypt",newValue)
		}
	});
	//ed
	
	//st 医保接口参数配置
	///医保接口公共参数
	//医保定点医药机构编号
	var InsuHospCode=""
	$("#InsuHospCode").on("click",function(){InsuHospCode=$("#InsuHospCode").val();}); 
    $("#InsuHospCode").blur(function(){
	    if (InsuHospCode!=$("#InsuHospCode").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuHospCode",$('#InsuHospCode').val())  
		}
	});
	//医保定点医药机构名称
	var InsuHospName=""
	$("#InsuHospName").on("click",function(){InsuHospName=$("#InsuHospName").val();}); 
    $("#InsuHospName").blur(function(){
	    if (InsuHospName!=$("#InsuHospName").val()){ 
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuHospName",$('#InsuHospName').val()) 
		}
	});
	//参保地医保区划代码缺省值(查询接口用的)
	var CenterNoDefault=""
	$("#CenterNoDefault").on("click",function(){CenterNoDefault=$("#CenterNoDefault").val();}); 
    $("#CenterNoDefault").blur(function(){
	    if (CenterNoDefault!=$("#CenterNoDefault").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"CenterNoDefault",$('#CenterNoDefault').val()) 
		}
	});
	//参保地医保区划名称缺省值(查询接口用的)
	var CenterNameDefault=""
	$("#CenterNameDefault").on("click",function(){CenterNameDefault=$("#CenterNameDefault").val();}); 
    $("#CenterNameDefault").blur(function(){
	    if (CenterNameDefault!=$("#CenterNameDefault").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"CenterNameDefault",$('#CenterNameDefault').val())
		}
	});//医保中心接口版本号
	$('#CenterVersion').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'2',text:'二版'},
			{id:'3',text:'三版'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"CenterVersion",newValue)
		}
	});
	
	//医保接口就医地区划
	var InsuCenterNo=""
	$("#InsuCenterNo").on("click",function(){InsuCenterNo=$("#InsuCenterNo").val();}); 
    $("#InsuCenterNo").blur(function(){
	    if (InsuCenterNo!=$("#InsuCenterNo").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuCenterNo",$('#InsuCenterNo').val())  
		}
	});
	//医保接口签名类型（交易入参，医保接口文档）
	var optertype=""
	$("#optertype").on("click",function(){optertype=$("#optertype").val();}); 
    $("#optertype").blur(function(){
	    if (optertype!=$("#optertype").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"optertype",$('#optertype').val())  
		}
	});
	
	//医保接口请求签名生成方式
	$('#SignMod').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'DHCC',text:'按照SHA1带秘钥生成签名，参考海南'},
			{id:'HN',text:'按照Sha256加密生成签名，参考云南'},
			{id:' ',text:'按照Sha256生成签名，参考：广东韶关'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"SignMod",newValue)
		}
	});
	//医保接口经办人类别
	$('#optertype').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'经办人'},
			{id:'2',text:'自助终端'},
			{id:'3',text:'移动终端'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"optertype",newValue)
		}
	});
	///医保接口header参数
	//医保接口应用服务地址
	var INSUIP=""
	$("#INSUIP").on("click",function(){INSUIP=$("#INSUIP").val();}); 
    $("#INSUIP").blur(function(){
	    if (INSUIP!=$("#INSUIP").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"INSUIP",$('#INSUIP').val())  
		}
	});
	//医保接口签名密钥（header参数，医保中心提供）
	var secretKey=""
	$("#secretKey").on("click",function(){secretKey=$("#secretKey").val();}); 
    $("#secretKey").blur(function(){
	    if (secretKey!=$("#secretKey").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"secretKey",$('#secretKey').val())  
		}
	});
	//医保接口版本（header参数，医保接口文档）
	var apiversion=""
	$("#apiversion").on("click",function(){apiversion=$("#apiversion").val();}); 
    $("#apiversion").blur(function(){
	    if (apiversion!=$("#apiversion").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"apiversion",$('#apiversion').val())  
		}
	});
	//医保接口版本号（交易入参，医保接口文档）
	var infver=""
	$("#infver").on("click",function(){infver=$("#infver").val();}); 
    $("#infver").blur(function(){
	    if (infver!=$("#infver").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"infver",$('#infver').val())  
		}
	});
	//应用账户编码
	var xRioPaasid=""
	$("#xRioPaasid").on("click",function(){xRioPaasid=$("#xRioPaasid").val();}); 
    $("#xRioPaasid").blur(function(){
	    if (xRioPaasid!=$("#xRioPaasid").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"xRioPaasid",$('#xRioPaasid').val())  
		}
	});
	//医保接口服务名（header参数，医保中心提供）
	var apiname=""
	$("#apiname").on("click",function(){apiname=$("#apiname").val();}); 
    $("#apiname").blur(function(){
	    if (apiname!=$("#apiname").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"apiname",$('#apiname').val())  
		}
	});
	//医保接口授权密钥(header参数，医保中心提供)
	var apiaccesskey=""
	$("#apiaccesskey").on("click",function(){apiaccesskey=$("#apiaccesskey").val();}); 
    $("#apiaccesskey").blur(function(){
	    if (apiaccesskey!=$("#apiaccesskey").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"apiaccesskey",$('#apiaccesskey').val())  
		}
	});
	//医保接口服务商 ID 码（header参数，医保中心提供
	var infosysign=""
	$("#infosysign").on("click",function(){infosysign=$("#infosysign").val();}); 
    $("#infosysign").blur(function(){
	    if (infosysign!=$("#infosysign").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"infosysign",$('#infosysign').val())  
		}
	});
	//接收方系统代码，用于多套系统接入，区分不同系统使用(DHCC:东华简拼)
	var HisSysCode=""
	$("#HisSysCode").on("click",function(){HisSysCode=$("#HisSysCode").val();}); 
    $("#HisSysCode").blur(function(){
	    if (HisSysCode!=$("#HisSysCode").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"HisSysCode",$('#HisSysCode').val())  
		}
	});
	//医保接口服务商统一社会信用代码（header参数，医保中心提供）
	var infosyscode=""
	$("#infosyscode").on("click",function(){infosyscode=$("#infosyscode").val();}); 
    $("#infosyscode").blur(function(){
	    if (infosyscode!=$("#infosyscode").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"infosyscode",$('#infosyscode').val())  
		}
	});
	//ed
	
	//st 医保目录对照
	//收费项是否与其他收费项关联的对照关系
	$('#TariInsuFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"TariInsuFlag",newValue) 
		}
	});
	//特殊收费项目对照是否启用
	$('#TariSpecialFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"TariSpecialFlag",newValue) 
		}
	});
	//[医保目录对照]是否按照收费项大类过滤
	$('#FilterByTarCate_SYS').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("SYS","FilterByTarCate",newValue)
		}
	});
	//默认对照时间设置
	var INSUCONACTDATE=""
	$("#INSUCONACTDATE_SYS").on("click",function(){INSUCONACTDATE=$("#INSUCONACTDATE_SYS").val();}); 
    $("#INSUCONACTDATE_SYS").blur(function(){
	    if (INSUCONACTDATE!=$("#INSUCONACTDATE_SYS").val()){
			arr=ArrPush("SYS","INSUCONACTDATE",$('#INSUCONACTDATE_SYS').val())  
		}
	});
	//ed
	
	//st 医保读卡
	//获取人员信息时是否弹窗显示
	$('#IsShowInsuCardInnfoDiagFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsShowInsuCardInnfoDiagFlag",newValue) 
		}
	});
	//是否强制动态库读卡
	$('#isCanReadCardByDLL').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"isCanReadCardByDLL",newValue) 
		}
	});
	//是否允许身份号获取人员信息
	$('#IsCanReadIDCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsCanReadIDCard",newValue) 
		}
	});
	//医保接口读卡服务（医保中心提供）
	var pUrl=""
	$("#pUrl").on("click",function(){pUrl=$("#pUrl").val();}); 
    $("#pUrl").blur(function(){
	    if (pUrl!=$("#pUrl").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"pUrl",$('#pUrl').val())  
		}
	});
	//医保接口读卡服务用户（医保中心提供）
	var pUser=""
	$("#pUser").on("click",function(){pUser=$("#pUser").val();}); 
    $("#pUser").blur(function(){
	    if (pUser!=$("#pUser").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"pUser",$('#pUser').val())  
		}
	});
	//ed
	
	//st 门诊医保挂号
	//门诊挂号是否弹读卡窗标志
	$('#IsOPRegShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsOPRegShowFlag",newValue) 
		}
	});
	//门诊挂号是否使用医保账户
	$('#OPRegUseZHFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegUseZHFlag",newValue) 
		}
	});
	//门诊挂号撤销是否需要读卡
	$('#OPRegDestroyIsReadCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegDestroyIsReadCard",newValue) 
		}
	});
	//门诊挂号有效天数(空或0:不验证，1(或2、3)：医保挂号天数有效1(或2、3))
	var OPRegEffecDays=""
	$("#OPRegEffecDays").on("click",function(){OPRegEffecDays=$("#OPRegEffecDays").val();}); 
    $("#OPRegEffecDays").blur(function(){
	    if (OPRegEffecDays!=$("#OPRegEffecDays").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegEffecDays",$('#OPRegEffecDays').val())  
		}
	});
	//慢病病种取值方式
	$('#QCChronicFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'医保控费'},
			{id:'2',text:'医保字典'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"QCChronicFlag",newValue) 
		}
	});
	//慢病信息是否同步保存医保控费系统
	$('#SaveLocalPsnInfo').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"SaveLocalPsnInfo",newValue) 
		}
	});
	//医保诊断是否取对照
	$('#ICDContrastFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'取对照'},
			{id:'N',text:'不取对照'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"ICDContrastFlag",newValue) 
		}
	});
	//ed
	
	//st 住院医保登记
	//住院登记是否弹读卡窗
	$('#IsIPRegShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsIPRegShowFlag",newValue)
		}
	});
	//住院登记取消是否需要读卡
	$('#IPRegDestroyIsReadCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPRegDestroyIsReadCard",newValue)
		}
	});
	//住院登记修改是否需要读卡
	$('#IPRegModIsReadCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'2',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPRegModIsReadCard",newValue)
		}
	});
	//医保登记成功后是否更新费别
	$('#UpdatePatAdmReason').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"UpdatePatAdmReason",newValue)
		}
	});
	//入院时间是否允许修改
	$('#AdmDateIsEdit').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'不允许'},
			{id:'1',text:'允许修改'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"AdmDateIsEdit",newValue)
		}
	});
	//住院结算是否调用出院登记
	$('#IPOutRegFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPOutRegFlag",newValue)
		}
	});
	
	//ed
	
	//st 医保结算
	//个人结算方式
	$('#Psnsetlway').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'01',text:'按项目结算'},
			{id:'02',text:'按定额结算'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"Psnsetlway",newValue)
		}
	});
	//医保返回总金额与HIS总金额误差允许最大值
	var Mistake=""
	$("#Mistake").on("click",function(){Mistake=$("#Mistake").val();}); 
    $("#Mistake").blur(function(){
	    if (Mistake!=$("#Mistake").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"Mistake",$('#Mistake').val())  
		}
	});
	//ed
	
	//st 门诊医保结算
	//门诊收费预结算弹框类型
	$('#OPDivFrmType').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'一张发票弹一个预结算框'},
			{id:'2',text:'多张发票数据汇总弹一个预结算框'},
			{id:'3',text:'一张发票一个预结算框，多张发票汇总一个预结算框'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPDivFrmType",newValue)
		}
	});
	//门诊结算是否使用医保账户
	$('#OPUseZHFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPUseZHFlag",newValue)
		}
	});
	//门诊结算是否自动补挂医保号
	$('#InsuDivRegFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuDivRegFlag",newValue)
		}
	});
	//门诊结算撤销是否需要读卡
	$('#OPStrikeIsReadCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'读卡'},
			{id:'0',text:'不读卡'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPStrikeIsReadCard",newValue)
		}
	});
	//门诊结算是否弹读卡窗
	$('#IsOPDivideShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsOPDivideShowFlag",newValue)
		}
	});
	//门诊退费是否弹读卡窗
	$('#IsOPDivideStrikeShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsOPDivideStrikeShowFlag",newValue)
		}
	});
	//门诊部分退费是否弹读卡窗
	$('#IsOPPartDivideStrikeShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsOPPartDivideStrikeShowFlag",newValue)
		}
	});
	//门诊预结算分解框弹窗标志
	$('#OPDivPreShw').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPDivPreShw",newValue)
		}
	});
	//HIS挂号与医保挂号对应关系
	$('#PaadmConInadmType').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'每一次HIS挂号只对应一个医保挂号'},
			{id:'2',text:'每个HIS挂号加医疗类别对应一个医保挂号'},
			{id:'3',text:'每次医保结算对应一个医保挂号'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"PaadmConInadmType",newValue)
		}
	});
	//医疗类别弹窗标志
	$('#AKA130MsgboxFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'弹窗'},
			{id:'N',text:'不弹窗'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"AKA130MsgboxFlag",newValue)
		}
	});
	//挂号调用医保结算标志
	$('#OPRegBXFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'只调用医保挂号交易，挂号与报销无关'},
			{id:'2',text:'调用医保挂号和医保结算交易，挂号报销'},
			{id:'3',text:'只调用医保挂号交易，但是返回报销金额，直接保存insu_divide表'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegBXFlag",newValue)
		}
	});
	//费别是否关联医疗类别
	$('#PacAdmreasonConAKA130Flag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'关联'},
			{id:'N',text:'不关联'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"PacAdmreasonConAKA130Flag",newValue)
		}
	});
	//ed
	
	//st 住院医保结算
	//允许中途结算的开始日期
	var MidStartDate=""
	$("#MidStartDate").on("click",function(){MidStartDate=$("#MidStartDate").val();}); 
    $("#MidStartDate").blur(function(){
	    if (MidStartDate!=$("#MidStartDate").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"MidStartDate",$('#MidStartDate').val())
		}
	});
	//允许中途结算的截止日期
	var MidEndDate=""
	$("#MidEndDate").on("click",function(){MidEndDate=$("#MidEndDate").val();}); 
    $("#MidEndDate").blur(function(){
	    if (MidEndDate!=$("#MidEndDate").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"MidEndDate",$('#MidEndDate').val())
		}
	});
	//医保结算是否需要读卡
	$('#InsuDivReadCardFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'读卡'},
			{id:'N',text:'不读卡'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuDivReadCardFlag",newValue)
		}
	});
	//医保结算撤销是否需要读卡
	$('#InsuDesDivReadCardFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'读卡'},
			{id:'N',text:'不读卡'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuDesDivReadCardFlag",newValue)
		}
	});
	//住院结算是否使用医保账户
	$('#IPUseZHFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPUseZHFlag",newValue)
		}
	});
	//住院是否打印医保结算单
	$('#IPIsPST').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPIsPST",newValue)
		}
	});
	//ed
	
	//st 医保明细上传
	//医保明细上传时是否校验未对照项目
	$('#NotConstracted').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'校验'},
			{id:'2',text:'不校验'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"NotConstracted",newValue)
		}
	});
	//医保明细上传时是否校验需未审核而未审核医嘱
	$('#NotAudit').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'校验'},
			{id:'2',text:'不校验'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"NotAudit",newValue)
		}
	});
	//医保明细上传时是否校验医保目录对照关系审批标志
	$('#NoChecked').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'校验'},
			{id:'2',text:'不校验'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"NoChecked",newValue)
		}
	});
	//医保明细上传时是否校验未对照项目
	$('#TarContrastAuditFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'目录对照完成未上传医保中心'},
			{id:'1',text:'对照关系上传医保中心'},
			{id:'2',text:'对照关系中心审核通过'},
		{id:'4',text:'对照关系院内审核通过'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"TarContrastAuditFlag",newValue)
		}
	});
	//费用明细合并方式
	$('#INSUMerges').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'不合并'},
			{id:'1',text:'按照收费项合并'},
			{id:'2',text:'按照医嘱项合并'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"INSUMerges",newValue)
		}
	});
	//费用发生日期取值方式
	$('#INSUBILLDATECTL').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'账单日期'},
			{id:'1',text:'执行日期'},
			{id:'2',text:'下医嘱日期'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"INSUBILLDATECTL",newValue)
		}
	});
	//明细上传分包模式
	$('#UpDetailMode').combobox({
		panelHeight:'auto',
		valueField:'id',
		textField:'text',
		required:true,
		editable:false,
		data:[
			{id:'0',text:'全部明细集合进行分包上传'},
			{id:'1',text:'正负明细集合分别分包上传'},
			{id:'2',text:'药品诊疗明细集合分别分包上传'},
			{id:'3',text:'正负明细集合再分药品诊疗集合分别分别上传'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"UpDetailMode",newValue)
		}
	}); 
	//负记录上传分包模式
	$('#UpFDetailMode').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'负记录分包上传(默认)'},
			{id:'1',text:'负记录退费时需要关联正记录，可以拆分正记录进行退费的方案'},
			{id:'2',text:'负记录退费时需要关联正记录，正记录全部撤销后重新上传正负记录合并后数量的方案'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"UpFDetailMode",newValue)
		}
	});
	//明细上传正记录单次上传最大条数
	var MaxRectNum=""
	$("#MaxRectNum").on("click",function(){MaxRectNum=$("#MaxRectNum").val();}); 
    $("#MaxRectNum").blur(function(){
	    if (MaxRectNum!=$("#MaxRectNum").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"MaxRectNum",$('#MaxRectNum').val())
		}
	});
	//明细上传负记录单次上传最大条数
	var MaxRectNumNeg=""
	$("#MaxRectNumNeg").on("click",function(){MaxRectNumNeg=$("#MaxRectNumNeg").val();}); 
    $("#MaxRectNumNeg").blur(function(){
	    if (MaxRectNumNeg!=$("#MaxRectNumNeg").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"MaxRectNumNeg",$('#MaxRectNumNeg').val())
		}
	});
	//零费用医嘱（单价或数量为零）上传标志
	$('#ZeroOrdIsUpFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'不上传'},
			{id:'1',text:'上传'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"ZeroOrdIsUpFlag",newValue)
		}
	});
	//费用明细院内审批标志取值位置配置
	$('#OEMainInsCfg').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'从执行记录表取值'},
			{id:'1',text:'从医嘱字段取值'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OEMainInsCfg",newValue)
		}
	});
	//明细核查接口院内审核标志取值位置
	$('#ChkInsuFlagMod').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'按医嘱'},
			{id:'1',text:'按医嘱的执行记录'},
			{id:'2',text:'按照医保医嘱审核'},
			{id:'3',text:'按照医保控费接口'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"ChkInsuFlagMod",newValue)
		}
	});
	//明细取折扣配置
	$('#InsuDiscountCtl_SYS').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'无折扣,取账单明细金额'},
			{id:'1',text:'有折扣,取账单明细自付金额'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("SYS","InsuDiscountCtl",newValue)
		}
	});
	//是否医保标识取值位置配置
	$('#OEMainInsCfg_SYS').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'从执行记录表取值'},
			{id:'1',text:'从医嘱字段取值'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("SYS","OEMainInsCfg",newValue)
		}
	});
	//ed
	
	//st 住院医保明细
	//住院明细全部撤销方式
	$('#IsCanDiretCancelMXFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'传0000撤销'},
			{id:'N',text:'循环本地明细撤销'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsCanDiretCancelMXFlag",newValue)
		}
	});
	//费用日期小于住院日期或大于出院日期处理方式
	$('#INSUDETDATACTL').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'处方的实际日期'},
			{id:'1',text:'分别取住院日期和出院日期'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"INSUDETDATACTL",newValue)
		}
	});
	//ed
	
	//st 签到
	//是否需要医保签到
	$('#IsNeedSignInFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsNeedSignInFlag",newValue)
		}
	});
	//是否需要医保签退
	$('#IsNeedSignOutFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsNeedSignOutFlag",newValue)
		}
	});
	//是否校验mac他址(签到mac地址和当前mac地址)
	$('#isCheckMACFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"isCheckMACFlag",newValue)
		}
	});
	//ed
	
	//st 医保报销返回支付方式
	//插入医保支付方式时，是否使用基金支付总额的支付方式
	$('#IsUseFundPaySumamtCTP').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsUseFundPaySumamtCTP",newValue)
		}
	});
	//插入医保支付方式时，门诊挂号报销支付方式是否全部返回(包括金额为零)
	$('#OPRegIsBackALLCTP').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegIsBackALLCTP",newValue)
		}
	});
	//插入医保支付方式时，门诊结算报销支付方式是否全部返回(包括金额为零)
	$('#OPDivIsBackALLCTP').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPDivIsBackALLCTP",newValue)
		}
	});
	//插入医保支付方式时，住院结算报销支付方式是否全部返回(包括金额为零)
	$('#IPDivIsBackALLCTP').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPDivIsBackALLCTP",newValue)
		}
	});
	//ed
	
	//st 医保数据上传
	//配置类型
	$('#CFTTYPE').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'线下'},
			{id:'1',text:'线上'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"CFTTYPE",newValue)
		}
	});
	//需要上传门诊基金结算清单的医疗类别(|14|1401|)
	var SpeDiseType=""
	$("#SpeDiseType").on("click",function(){SpeDiseType=$("#SpeDiseType").val();}); 
    $("#SpeDiseType").blur(function(){
	    if (SpeDiseType!=$("#SpeDiseType").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"SpeDiseType",$('#SpeDiseType').val())
		}
	});
	//ed
}

//数组增加
function ArrPush(type,code,desc){
	if(code=="DBEncrypt"){
		var Username=$('#Username').val();
		if(Username==""){
			$.messager.alert('错误','数据库连接用户名不能为空','error');
			return arr
		}
		var Password=$('#Password').val();
		if(Password==""){
			$.messager.alert('错误','数据库连接密码不能为空','error');
			return arr
		}
		var Key=$('#Key').val();
		if(Key==""){
			$.messager.alert('错误','数据库连接密钥不能为空','error');
			return arr
		}
		var LinkType=$('#LinkType').combobox("getValue");
		if(LinkType==""){
			$.messager.alert('错误','数据库连接方式不能为空','error');
			return arr
		}
		desc=Key+"^"+Username+"^"+Password+"^"+LinkType
	}
	var arrNew = new Array();
	for(var i=0;i<arr.length;i++){
		if(arr[i].indexOf(code)==-1){
			arrNew.push(arr[i]);
		}
    }
	arrNew.push(type+"^"+code+"^"+desc); 
	return arrNew
}	

//清屏
function Clean(){
	setValueById('UpDetailMode','');
	setValueById('UpFDetailMode','');
	setValueById('AKA130MsgboxFlag','');
	setValueById('InsuDivRegFlag','');
	setValueById('OPDivFrmType','');
	setValueById('optertype','');
	setValueById('IsCanDiretCancelMXFlag','');
	//setValueById('IPRegModIsReadCard','');
	setValueById('InsuDesDivReadCardFlag','');
	setValueById('InsuDivReadCardFlag','');
	setValueById('IsNeedSignOutFlag','');
	setValueById('IsNeedSignInFlag','');
	setValueById('IPRegDestroyIsReadCard','');
	setValueById('Psnsetlway','');
	setValueById('IsIPRegShowFlag','');
	setValueById('IsOPRegShowFlag','');
	setValueById('IsOPPartDivideStrikeShowFlag','');
	setValueById('IsOPDivideStrikeShowFlag','');
	setValueById('IsOPDivideShowFlag','');
	setValueById('IsShowInsuCardInnfoDiagFlag','');
	setValueById('IPUseZHFlag','');
	setValueById('OPRegUseZHFlag','');
	setValueById('OPUseZHFlag','');
	setValueById('OPDivPreShw','');
	setValueById('NotConstracted','');
	setValueById('NotAudit','');
	setValueById('NoChecked','');
	setValueById('UpdatePatAdmReason','');
	setValueById('PaadmConInadmType','');
	setValueById('OPStrikeIsReadCard','');
	setValueById('OPRegBXFlag','');
	setValueById('OPRegDestroyIsReadCard','');
	setValueById('isCanReadCardByDLL','');
	setValueById('IsCanReadIDCard','');
	setValueById('PacAdmreasonConAKA130Flag','');
	setValueById('TarContrastAuditFlag','');
	setValueById('InsuMsgInfoFlag','');
	setValueById('INSUMerges','');
	setValueById('INSUBILLDATECTL','');
	setValueById('INSUDETDATACTL','');
	setValueById('AdmDateCtl','');
	setValueById('DischDateCtl','');
	setValueById('AdmDateIsEdit','');
	setValueById('TariInsuFlag','');
	setValueById('OPRegEffecDays','');
	setValueById('ICDContrastFlag','');
	setValueById('CenterVersion','');
	setValueById('IPIsPST','');
	setValueById('TariSpecialFlag','');
	setValueById('ChkInsuFlagMod','');
	setValueById('ZeroOrdIsUpFlag','');
	setValueById('OEMainInsCfg','');
	setValueById('IsUseFundPaySumamtCTP','');
	setValueById('OPDivIsBackALLCTP','');
	setValueById('OPRegIsBackALLCTP','');
	setValueById('IPDivIsBackALLCTP','');
	setValueById('QCChronicFlag','');
	setValueById('IPOutRegFlag','');
	setValueById('SaveLocalPsnInfo','');
	setValueById('IPDivPreShw','');
	setValueById('CFTTYPE','');
	setValueById('isCheckMACFlag','');
	setValueById('InsuHospCode','');
	setValueById('InsuHospName','');
	setValueById('INSUIP','');
	setValueById('MaxRectNum','');
	setValueById('MaxRectNumNeg','');
	setValueById('MidStartDate','');
	setValueById('MidEndDate','');
	setValueById('Mistake','');
	setValueById('secretKey','');
	setValueById('optertype','');
	setValueById('InsuCenterNo','');
	setValueById('infver','');
	setValueById('signtype','');
	setValueById('xRioPaasid','');
	setValueById('pUrl','');
	setValueById('pUser','');
	setValueById('CenterNoDefault','');
	setValueById('CenterNameDefault','');
	setValueById('apiname','');
	setValueById('apiversion','');
	setValueById('apiaccesskey','');
	setValueById('HisSysCode','');
	setValueById('infosyscode','');
	setValueById('infosysign','');
	setValueById('SignMod','');
	setValueById('INSUCURRENT','');
	setValueById('SpeDiseType','');
	setValueById('OPMistake','');
	setValueById('IPMistake','');
	setValueById('AutoStartINSUService','');
	setValueById('FilterByTarCate','');
	setValueById('InsuDiscountCtl','');
	setValueById('OEMainInsCfg','');
	setValueById('NormalConfig','');
	setValueById('INSUCONACTDATE','');
	setValueById('MsgBoxFlag','');
	setValueById('InsuLogInsuFlag','');
	setValueById('InsuLogHisFlag','');
	setValueById('InsuLogBussFlag','');
	setValueById('InsuMsgInfoFlag','');
}
