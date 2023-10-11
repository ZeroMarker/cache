/*
 * FileName:	dicdataconfig.js
 * User:		Hanzh 
 * Date:		2022-08-11
 * Description: ҽ��ϵͳ��������
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
	//��ʼ��ҽ������
	init_INSUType();
	
	//ҳ��Ԫ�س�ʼ��
	Initpage();
	
	//����
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
	//tab��ǩ�л�
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
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
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
		//��ʼ���ֵ�����
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
		$.messager.defaults.ok = "ȷ��";
		$.messager.defaults.cancel = "ȡ��";
		$.messager.confirm("����", "�����ø��»�Ӱ�쵽ҵ�����̣�ȷ���Ƿ����ڲ��Կ���²���", function (r) {
			if (r) {
				if(PassWardFlag == "N"){
	    			$.messager.prompt("��ʾ", "����������", function (r) {
						if (r) {
							PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
							if(PassWardFlag=='Y'){ 
								UptINSUDicData();
								Init();
							}
							else{
								$.messager.alert('����','�������','error');	
							}
						} else {
							$.messager.popover({ msg: "�����ȡ��" });
						}
					})
				}else{
					UptINSUDicData(); 
					Init();
				} 
			} else {
				$.messager.popover({ msg: "�����ȡ��" });
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
			$.messager.alert('�����ֵ�����ʧ��',rtnStr,'info');
			INSUTYPE="";
			return;
		}
		var rtnList=rtnStr.split("!")[1];
		$.messager.alert('�����ֵ��������',"����������:"+rtnList.split("^")[0]+",�ɹ�:"+rtnList.split("^")[1]+",ʧ��:"+rtnList.split("^")[2],'info');

	});
	Init();	
}	

function Initpage(){
	//st ҽ����������--NormalConfig
	//�Ƿ��Զ������м����ֻ��Ϊ1���Զ�������
	$('#AutoStartINSUService_SYS').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","UpDetailMode",newValue)
		}
	});
	//�Ƿ񵯿���ʾ
	$('#MsgBoxFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","MsgBoxFlag",newValue)
		}
	});
	//�Ƿ񱣴�ҽ������������־
	$('#InsuLogInsuFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","InsuLogInsuFlag",newValue)
		}
	});
	//�Ƿ񱣴�ҽ���ӿں���������־
	$('#InsuLogHisFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","InsuLogHisFlag",newValue)
		}
	});
	//�Ƿ񱣴�ҽ����ҵ����־
	$('#InsuLogBussFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","InsuLogBussFlag",newValue)
		}
	});
	//�Ƿ񱣴����ݿ���־
	$('#InsuMsgInfoFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("NormalConfig","InsuMsgInfoFlag",newValue)
		}
	});
	//���ݿ������û���
	var Username=""
	$("#Username").on("click",function(){Username=$("#Username").val();}); 
    $("#Username").blur(function(){
	    if (Username!=$("#Username").val()){
			arr=ArrPush("SYS","DBEncrypt",$('#Username').val())  
		}
	});
	//���ݿ���������
	var Password=""
	$("#Password").on("click",function(){Password=$("#Password").val();}); 
    $("#Password").blur(function(){
	    if (Password!=$("#Password").val()){
			arr=ArrPush("SYS","DBEncrypt",$('#Password').val())
		}
	});
	//���ݿ�������Կ
	var Key=""
	$("#Key").on("click",function(){Key=$("#Key").val();}); 
    $("#Key").blur(function(){
	    if (Key!=$("#Key").val()){
			arr=ArrPush("SYS","DBEncrypt",$('#Key').val())
		}
	});
	//���ݿ����ӷ�ʽ
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
	
	//st ҽ���ӿڲ�������
	///ҽ���ӿڹ�������
	//ҽ������ҽҩ�������
	var InsuHospCode=""
	$("#InsuHospCode").on("click",function(){InsuHospCode=$("#InsuHospCode").val();}); 
    $("#InsuHospCode").blur(function(){
	    if (InsuHospCode!=$("#InsuHospCode").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuHospCode",$('#InsuHospCode').val())  
		}
	});
	//ҽ������ҽҩ��������
	var InsuHospName=""
	$("#InsuHospName").on("click",function(){InsuHospName=$("#InsuHospName").val();}); 
    $("#InsuHospName").blur(function(){
	    if (InsuHospName!=$("#InsuHospName").val()){ 
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuHospName",$('#InsuHospName').val()) 
		}
	});
	//�α���ҽ����������ȱʡֵ(��ѯ�ӿ��õ�)
	var CenterNoDefault=""
	$("#CenterNoDefault").on("click",function(){CenterNoDefault=$("#CenterNoDefault").val();}); 
    $("#CenterNoDefault").blur(function(){
	    if (CenterNoDefault!=$("#CenterNoDefault").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"CenterNoDefault",$('#CenterNoDefault').val()) 
		}
	});
	//�α���ҽ����������ȱʡֵ(��ѯ�ӿ��õ�)
	var CenterNameDefault=""
	$("#CenterNameDefault").on("click",function(){CenterNameDefault=$("#CenterNameDefault").val();}); 
    $("#CenterNameDefault").blur(function(){
	    if (CenterNameDefault!=$("#CenterNameDefault").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"CenterNameDefault",$('#CenterNameDefault').val())
		}
	});//ҽ�����Ľӿڰ汾��
	$('#CenterVersion').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'2',text:'����'},
			{id:'3',text:'����'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"CenterVersion",newValue)
		}
	});
	
	//ҽ���ӿھ�ҽ������
	var InsuCenterNo=""
	$("#InsuCenterNo").on("click",function(){InsuCenterNo=$("#InsuCenterNo").val();}); 
    $("#InsuCenterNo").blur(function(){
	    if (InsuCenterNo!=$("#InsuCenterNo").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuCenterNo",$('#InsuCenterNo').val())  
		}
	});
	//ҽ���ӿ�ǩ�����ͣ�������Σ�ҽ���ӿ��ĵ���
	var optertype=""
	$("#optertype").on("click",function(){optertype=$("#optertype").val();}); 
    $("#optertype").blur(function(){
	    if (optertype!=$("#optertype").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"optertype",$('#optertype').val())  
		}
	});
	
	//ҽ���ӿ�����ǩ�����ɷ�ʽ
	$('#SignMod').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'DHCC',text:'����SHA1����Կ����ǩ�����ο�����'},
			{id:'HN',text:'����Sha256��������ǩ�����ο�����'},
			{id:' ',text:'����Sha256����ǩ�����ο����㶫�ع�'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"SignMod",newValue)
		}
	});
	//ҽ���ӿھ��������
	$('#optertype').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'������'},
			{id:'2',text:'�����ն�'},
			{id:'3',text:'�ƶ��ն�'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"optertype",newValue)
		}
	});
	///ҽ���ӿ�header����
	//ҽ���ӿ�Ӧ�÷����ַ
	var INSUIP=""
	$("#INSUIP").on("click",function(){INSUIP=$("#INSUIP").val();}); 
    $("#INSUIP").blur(function(){
	    if (INSUIP!=$("#INSUIP").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"INSUIP",$('#INSUIP').val())  
		}
	});
	//ҽ���ӿ�ǩ����Կ��header������ҽ�������ṩ��
	var secretKey=""
	$("#secretKey").on("click",function(){secretKey=$("#secretKey").val();}); 
    $("#secretKey").blur(function(){
	    if (secretKey!=$("#secretKey").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"secretKey",$('#secretKey').val())  
		}
	});
	//ҽ���ӿڰ汾��header������ҽ���ӿ��ĵ���
	var apiversion=""
	$("#apiversion").on("click",function(){apiversion=$("#apiversion").val();}); 
    $("#apiversion").blur(function(){
	    if (apiversion!=$("#apiversion").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"apiversion",$('#apiversion').val())  
		}
	});
	//ҽ���ӿڰ汾�ţ�������Σ�ҽ���ӿ��ĵ���
	var infver=""
	$("#infver").on("click",function(){infver=$("#infver").val();}); 
    $("#infver").blur(function(){
	    if (infver!=$("#infver").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"infver",$('#infver').val())  
		}
	});
	//Ӧ���˻�����
	var xRioPaasid=""
	$("#xRioPaasid").on("click",function(){xRioPaasid=$("#xRioPaasid").val();}); 
    $("#xRioPaasid").blur(function(){
	    if (xRioPaasid!=$("#xRioPaasid").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"xRioPaasid",$('#xRioPaasid').val())  
		}
	});
	//ҽ���ӿڷ�������header������ҽ�������ṩ��
	var apiname=""
	$("#apiname").on("click",function(){apiname=$("#apiname").val();}); 
    $("#apiname").blur(function(){
	    if (apiname!=$("#apiname").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"apiname",$('#apiname').val())  
		}
	});
	//ҽ���ӿ���Ȩ��Կ(header������ҽ�������ṩ)
	var apiaccesskey=""
	$("#apiaccesskey").on("click",function(){apiaccesskey=$("#apiaccesskey").val();}); 
    $("#apiaccesskey").blur(function(){
	    if (apiaccesskey!=$("#apiaccesskey").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"apiaccesskey",$('#apiaccesskey').val())  
		}
	});
	//ҽ���ӿڷ����� ID �루header������ҽ�������ṩ
	var infosysign=""
	$("#infosysign").on("click",function(){infosysign=$("#infosysign").val();}); 
    $("#infosysign").blur(function(){
	    if (infosysign!=$("#infosysign").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"infosysign",$('#infosysign').val())  
		}
	});
	//���շ�ϵͳ���룬���ڶ���ϵͳ���룬���ֲ�ͬϵͳʹ��(DHCC:������ƴ)
	var HisSysCode=""
	$("#HisSysCode").on("click",function(){HisSysCode=$("#HisSysCode").val();}); 
    $("#HisSysCode").blur(function(){
	    if (HisSysCode!=$("#HisSysCode").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"HisSysCode",$('#HisSysCode').val())  
		}
	});
	//ҽ���ӿڷ�����ͳһ������ô��루header������ҽ�������ṩ��
	var infosyscode=""
	$("#infosyscode").on("click",function(){infosyscode=$("#infosyscode").val();}); 
    $("#infosyscode").blur(function(){
	    if (infosyscode!=$("#infosyscode").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"infosyscode",$('#infosyscode').val())  
		}
	});
	//ed
	
	//st ҽ��Ŀ¼����
	//�շ����Ƿ��������շ�������Ķ��չ�ϵ
	$('#TariInsuFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"TariInsuFlag",newValue) 
		}
	});
	//�����շ���Ŀ�����Ƿ�����
	$('#TariSpecialFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"TariSpecialFlag",newValue) 
		}
	});
	//[ҽ��Ŀ¼����]�Ƿ����շ���������
	$('#FilterByTarCate_SYS').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("SYS","FilterByTarCate",newValue)
		}
	});
	//Ĭ�϶���ʱ������
	var INSUCONACTDATE=""
	$("#INSUCONACTDATE_SYS").on("click",function(){INSUCONACTDATE=$("#INSUCONACTDATE_SYS").val();}); 
    $("#INSUCONACTDATE_SYS").blur(function(){
	    if (INSUCONACTDATE!=$("#INSUCONACTDATE_SYS").val()){
			arr=ArrPush("SYS","INSUCONACTDATE",$('#INSUCONACTDATE_SYS').val())  
		}
	});
	//ed
	
	//st ҽ������
	//��ȡ��Ա��Ϣʱ�Ƿ񵯴���ʾ
	$('#IsShowInsuCardInnfoDiagFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsShowInsuCardInnfoDiagFlag",newValue) 
		}
	});
	//�Ƿ�ǿ�ƶ�̬�����
	$('#isCanReadCardByDLL').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"isCanReadCardByDLL",newValue) 
		}
	});
	//�Ƿ�������ݺŻ�ȡ��Ա��Ϣ
	$('#IsCanReadIDCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsCanReadIDCard",newValue) 
		}
	});
	//ҽ���ӿڶ�������ҽ�������ṩ��
	var pUrl=""
	$("#pUrl").on("click",function(){pUrl=$("#pUrl").val();}); 
    $("#pUrl").blur(function(){
	    if (pUrl!=$("#pUrl").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"pUrl",$('#pUrl').val())  
		}
	});
	//ҽ���ӿڶ��������û���ҽ�������ṩ��
	var pUser=""
	$("#pUser").on("click",function(){pUser=$("#pUser").val();}); 
    $("#pUser").blur(function(){
	    if (pUser!=$("#pUser").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"pUser",$('#pUser').val())  
		}
	});
	//ed
	
	//st ����ҽ���Һ�
	//����Һ��Ƿ񵯶�������־
	$('#IsOPRegShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsOPRegShowFlag",newValue) 
		}
	});
	//����Һ��Ƿ�ʹ��ҽ���˻�
	$('#OPRegUseZHFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegUseZHFlag",newValue) 
		}
	});
	//����Һų����Ƿ���Ҫ����
	$('#OPRegDestroyIsReadCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegDestroyIsReadCard",newValue) 
		}
	});
	//����Һ���Ч����(�ջ�0:����֤��1(��2��3)��ҽ���Һ�������Ч1(��2��3))
	var OPRegEffecDays=""
	$("#OPRegEffecDays").on("click",function(){OPRegEffecDays=$("#OPRegEffecDays").val();}); 
    $("#OPRegEffecDays").blur(function(){
	    if (OPRegEffecDays!=$("#OPRegEffecDays").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegEffecDays",$('#OPRegEffecDays').val())  
		}
	});
	//��������ȡֵ��ʽ
	$('#QCChronicFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'ҽ���ط�'},
			{id:'2',text:'ҽ���ֵ�'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"QCChronicFlag",newValue) 
		}
	});
	//������Ϣ�Ƿ�ͬ������ҽ���ط�ϵͳ
	$('#SaveLocalPsnInfo').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"SaveLocalPsnInfo",newValue) 
		}
	});
	//ҽ������Ƿ�ȡ����
	$('#ICDContrastFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'ȡ����'},
			{id:'N',text:'��ȡ����'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"ICDContrastFlag",newValue) 
		}
	});
	//ed
	
	//st סԺҽ���Ǽ�
	//סԺ�Ǽ��Ƿ񵯶�����
	$('#IsIPRegShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsIPRegShowFlag",newValue)
		}
	});
	//סԺ�Ǽ�ȡ���Ƿ���Ҫ����
	$('#IPRegDestroyIsReadCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPRegDestroyIsReadCard",newValue)
		}
	});
	//סԺ�Ǽ��޸��Ƿ���Ҫ����
	$('#IPRegModIsReadCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'2',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPRegModIsReadCard",newValue)
		}
	});
	//ҽ���Ǽǳɹ����Ƿ���·ѱ�
	$('#UpdatePatAdmReason').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"UpdatePatAdmReason",newValue)
		}
	});
	//��Ժʱ���Ƿ������޸�
	$('#AdmDateIsEdit').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'������'},
			{id:'1',text:'�����޸�'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"AdmDateIsEdit",newValue)
		}
	});
	//סԺ�����Ƿ���ó�Ժ�Ǽ�
	$('#IPOutRegFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPOutRegFlag",newValue)
		}
	});
	
	//ed
	
	//st ҽ������
	//���˽��㷽ʽ
	$('#Psnsetlway').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'01',text:'����Ŀ����'},
			{id:'02',text:'���������'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"Psnsetlway",newValue)
		}
	});
	//ҽ�������ܽ����HIS�ܽ������������ֵ
	var Mistake=""
	$("#Mistake").on("click",function(){Mistake=$("#Mistake").val();}); 
    $("#Mistake").blur(function(){
	    if (Mistake!=$("#Mistake").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"Mistake",$('#Mistake').val())  
		}
	});
	//ed
	
	//st ����ҽ������
	//�����շ�Ԥ���㵯������
	$('#OPDivFrmType').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'һ�ŷ�Ʊ��һ��Ԥ�����'},
			{id:'2',text:'���ŷ�Ʊ���ݻ��ܵ�һ��Ԥ�����'},
			{id:'3',text:'һ�ŷ�Ʊһ��Ԥ����򣬶��ŷ�Ʊ����һ��Ԥ�����'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPDivFrmType",newValue)
		}
	});
	//��������Ƿ�ʹ��ҽ���˻�
	$('#OPUseZHFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPUseZHFlag",newValue)
		}
	});
	//��������Ƿ��Զ�����ҽ����
	$('#InsuDivRegFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuDivRegFlag",newValue)
		}
	});
	//������㳷���Ƿ���Ҫ����
	$('#OPStrikeIsReadCard').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'����'},
			{id:'0',text:'������'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPStrikeIsReadCard",newValue)
		}
	});
	//��������Ƿ񵯶�����
	$('#IsOPDivideShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsOPDivideShowFlag",newValue)
		}
	});
	//�����˷��Ƿ񵯶�����
	$('#IsOPDivideStrikeShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsOPDivideStrikeShowFlag",newValue)
		}
	});
	//���ﲿ���˷��Ƿ񵯶�����
	$('#IsOPPartDivideStrikeShowFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsOPPartDivideStrikeShowFlag",newValue)
		}
	});
	//����Ԥ����ֽ�򵯴���־
	$('#OPDivPreShw').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPDivPreShw",newValue)
		}
	});
	//HIS�Һ���ҽ���ҺŶ�Ӧ��ϵ
	$('#PaadmConInadmType').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'ÿһ��HIS�Һ�ֻ��Ӧһ��ҽ���Һ�'},
			{id:'2',text:'ÿ��HIS�Һż�ҽ������Ӧһ��ҽ���Һ�'},
			{id:'3',text:'ÿ��ҽ�������Ӧһ��ҽ���Һ�'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"PaadmConInadmType",newValue)
		}
	});
	//ҽ����𵯴���־
	$('#AKA130MsgboxFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'����'},
			{id:'N',text:'������'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"AKA130MsgboxFlag",newValue)
		}
	});
	//�Һŵ���ҽ�������־
	$('#OPRegBXFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'ֻ����ҽ���ҺŽ��ף��Һ��뱨���޹�'},
			{id:'2',text:'����ҽ���Һź�ҽ�����㽻�ף��Һű���'},
			{id:'3',text:'ֻ����ҽ���ҺŽ��ף����Ƿ��ر�����ֱ�ӱ���insu_divide��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegBXFlag",newValue)
		}
	});
	//�ѱ��Ƿ����ҽ�����
	$('#PacAdmreasonConAKA130Flag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'����'},
			{id:'N',text:'������'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"PacAdmreasonConAKA130Flag",newValue)
		}
	});
	//ed
	
	//st סԺҽ������
	//������;����Ŀ�ʼ����
	var MidStartDate=""
	$("#MidStartDate").on("click",function(){MidStartDate=$("#MidStartDate").val();}); 
    $("#MidStartDate").blur(function(){
	    if (MidStartDate!=$("#MidStartDate").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"MidStartDate",$('#MidStartDate').val())
		}
	});
	//������;����Ľ�ֹ����
	var MidEndDate=""
	$("#MidEndDate").on("click",function(){MidEndDate=$("#MidEndDate").val();}); 
    $("#MidEndDate").blur(function(){
	    if (MidEndDate!=$("#MidEndDate").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"MidEndDate",$('#MidEndDate').val())
		}
	});
	//ҽ�������Ƿ���Ҫ����
	$('#InsuDivReadCardFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'����'},
			{id:'N',text:'������'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuDivReadCardFlag",newValue)
		}
	});
	//ҽ�����㳷���Ƿ���Ҫ����
	$('#InsuDesDivReadCardFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'����'},
			{id:'N',text:'������'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"InsuDesDivReadCardFlag",newValue)
		}
	});
	//סԺ�����Ƿ�ʹ��ҽ���˻�
	$('#IPUseZHFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPUseZHFlag",newValue)
		}
	});
	//סԺ�Ƿ��ӡҽ�����㵥
	$('#IPIsPST').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPIsPST",newValue)
		}
	});
	//ed
	
	//st ҽ����ϸ�ϴ�
	//ҽ����ϸ�ϴ�ʱ�Ƿ�У��δ������Ŀ
	$('#NotConstracted').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'У��'},
			{id:'2',text:'��У��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"NotConstracted",newValue)
		}
	});
	//ҽ����ϸ�ϴ�ʱ�Ƿ�У����δ��˶�δ���ҽ��
	$('#NotAudit').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'У��'},
			{id:'2',text:'��У��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"NotAudit",newValue)
		}
	});
	//ҽ����ϸ�ϴ�ʱ�Ƿ�У��ҽ��Ŀ¼���չ�ϵ������־
	$('#NoChecked').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'У��'},
			{id:'2',text:'��У��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"NoChecked",newValue)
		}
	});
	//ҽ����ϸ�ϴ�ʱ�Ƿ�У��δ������Ŀ
	$('#TarContrastAuditFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'Ŀ¼�������δ�ϴ�ҽ������'},
			{id:'1',text:'���չ�ϵ�ϴ�ҽ������'},
			{id:'2',text:'���չ�ϵ�������ͨ��'},
		{id:'4',text:'���չ�ϵԺ�����ͨ��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"TarContrastAuditFlag",newValue)
		}
	});
	//������ϸ�ϲ���ʽ
	$('#INSUMerges').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'���ϲ�'},
			{id:'1',text:'�����շ���ϲ�'},
			{id:'2',text:'����ҽ����ϲ�'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"INSUMerges",newValue)
		}
	});
	//���÷�������ȡֵ��ʽ
	$('#INSUBILLDATECTL').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'�˵�����'},
			{id:'1',text:'ִ������'},
			{id:'2',text:'��ҽ������'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"INSUBILLDATECTL",newValue)
		}
	});
	//��ϸ�ϴ��ְ�ģʽ
	$('#UpDetailMode').combobox({
		panelHeight:'auto',
		valueField:'id',
		textField:'text',
		required:true,
		editable:false,
		data:[
			{id:'0',text:'ȫ����ϸ���Ͻ��зְ��ϴ�'},
			{id:'1',text:'������ϸ���Ϸֱ�ְ��ϴ�'},
			{id:'2',text:'ҩƷ������ϸ���Ϸֱ�ְ��ϴ�'},
			{id:'3',text:'������ϸ�����ٷ�ҩƷ���Ƽ��Ϸֱ�ֱ��ϴ�'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"UpDetailMode",newValue)
		}
	}); 
	//����¼�ϴ��ְ�ģʽ
	$('#UpFDetailMode').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'����¼�ְ��ϴ�(Ĭ��)'},
			{id:'1',text:'����¼�˷�ʱ��Ҫ��������¼�����Բ������¼�����˷ѵķ���'},
			{id:'2',text:'����¼�˷�ʱ��Ҫ��������¼������¼ȫ�������������ϴ�������¼�ϲ��������ķ���'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"UpFDetailMode",newValue)
		}
	});
	//��ϸ�ϴ�����¼�����ϴ��������
	var MaxRectNum=""
	$("#MaxRectNum").on("click",function(){MaxRectNum=$("#MaxRectNum").val();}); 
    $("#MaxRectNum").blur(function(){
	    if (MaxRectNum!=$("#MaxRectNum").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"MaxRectNum",$('#MaxRectNum').val())
		}
	});
	//��ϸ�ϴ�����¼�����ϴ��������
	var MaxRectNumNeg=""
	$("#MaxRectNumNeg").on("click",function(){MaxRectNumNeg=$("#MaxRectNumNeg").val();}); 
    $("#MaxRectNumNeg").blur(function(){
	    if (MaxRectNumNeg!=$("#MaxRectNumNeg").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"MaxRectNumNeg",$('#MaxRectNumNeg').val())
		}
	});
	//�����ҽ�������ۻ�����Ϊ�㣩�ϴ���־
	$('#ZeroOrdIsUpFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'���ϴ�'},
			{id:'1',text:'�ϴ�'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"ZeroOrdIsUpFlag",newValue)
		}
	});
	//������ϸԺ��������־ȡֵλ������
	$('#OEMainInsCfg').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'��ִ�м�¼��ȡֵ'},
			{id:'1',text:'��ҽ���ֶ�ȡֵ'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OEMainInsCfg",newValue)
		}
	});
	//��ϸ�˲�ӿ�Ժ����˱�־ȡֵλ��
	$('#ChkInsuFlagMod').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'��ҽ��'},
			{id:'1',text:'��ҽ����ִ�м�¼'},
			{id:'2',text:'����ҽ��ҽ�����'},
			{id:'3',text:'����ҽ���طѽӿ�'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"ChkInsuFlagMod",newValue)
		}
	});
	//��ϸȡ�ۿ�����
	$('#InsuDiscountCtl_SYS').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'���ۿ�,ȡ�˵���ϸ���'},
			{id:'1',text:'���ۿ�,ȡ�˵���ϸ�Ը����'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("SYS","InsuDiscountCtl",newValue)
		}
	});
	//�Ƿ�ҽ����ʶȡֵλ������
	$('#OEMainInsCfg_SYS').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'��ִ�м�¼��ȡֵ'},
			{id:'1',text:'��ҽ���ֶ�ȡֵ'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("SYS","OEMainInsCfg",newValue)
		}
	});
	//ed
	
	//st סԺҽ����ϸ
	//סԺ��ϸȫ��������ʽ
	$('#IsCanDiretCancelMXFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��0000����'},
			{id:'N',text:'ѭ��������ϸ����'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsCanDiretCancelMXFlag",newValue)
		}
	});
	//��������С��סԺ���ڻ���ڳ�Ժ���ڴ���ʽ
	$('#INSUDETDATACTL').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'������ʵ������'},
			{id:'1',text:'�ֱ�ȡסԺ���ںͳ�Ժ����'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"INSUDETDATACTL",newValue)
		}
	});
	//ed
	
	//st ǩ��
	//�Ƿ���Ҫҽ��ǩ��
	$('#IsNeedSignInFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsNeedSignInFlag",newValue)
		}
	});
	//�Ƿ���Ҫҽ��ǩ��
	$('#IsNeedSignOutFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsNeedSignOutFlag",newValue)
		}
	});
	//�Ƿ�У��mac��ַ(ǩ��mac��ַ�͵�ǰmac��ַ)
	$('#isCheckMACFlag').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"isCheckMACFlag",newValue)
		}
	});
	//ed
	
	//st ҽ����������֧����ʽ
	//����ҽ��֧����ʽʱ���Ƿ�ʹ�û���֧���ܶ��֧����ʽ
	$('#IsUseFundPaySumamtCTP').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IsUseFundPaySumamtCTP",newValue)
		}
	});
	//����ҽ��֧����ʽʱ������Һű���֧����ʽ�Ƿ�ȫ������(�������Ϊ��)
	$('#OPRegIsBackALLCTP').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPRegIsBackALLCTP",newValue)
		}
	});
	//����ҽ��֧����ʽʱ��������㱨��֧����ʽ�Ƿ�ȫ������(�������Ϊ��)
	$('#OPDivIsBackALLCTP').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"OPDivIsBackALLCTP",newValue)
		}
	});
	//����ҽ��֧����ʽʱ��סԺ���㱨��֧����ʽ�Ƿ�ȫ������(�������Ϊ��)
	$('#IPDivIsBackALLCTP').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"IPDivIsBackALLCTP",newValue)
		}
	});
	//ed
	
	//st ҽ�������ϴ�
	//��������
	$('#CFTTYPE').combobox({
		 panelHeight:'auto',
		 valueField:'id',
		 textField:'text',
		 required:true,
		 editable:false,
		data:[
			{id:'0',text:'����'},
			{id:'1',text:'����'}
		],
		onChange: function (newValue, oldValue) {
			arr=ArrPush("HISPROPerty"+INSUTYPE,"CFTTYPE",newValue)
		}
	});
	//��Ҫ�ϴ������������嵥��ҽ�����(|14|1401|)
	var SpeDiseType=""
	$("#SpeDiseType").on("click",function(){SpeDiseType=$("#SpeDiseType").val();}); 
    $("#SpeDiseType").blur(function(){
	    if (SpeDiseType!=$("#SpeDiseType").val()){
			arr=ArrPush("HISPROPerty"+INSUTYPE,"SpeDiseType",$('#SpeDiseType').val())
		}
	});
	//ed
}

//��������
function ArrPush(type,code,desc){
	if(code=="DBEncrypt"){
		var Username=$('#Username').val();
		if(Username==""){
			$.messager.alert('����','���ݿ������û�������Ϊ��','error');
			return arr
		}
		var Password=$('#Password').val();
		if(Password==""){
			$.messager.alert('����','���ݿ��������벻��Ϊ��','error');
			return arr
		}
		var Key=$('#Key').val();
		if(Key==""){
			$.messager.alert('����','���ݿ�������Կ����Ϊ��','error');
			return arr
		}
		var LinkType=$('#LinkType').combobox("getValue");
		if(LinkType==""){
			$.messager.alert('����','���ݿ����ӷ�ʽ����Ϊ��','error');
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

//����
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
