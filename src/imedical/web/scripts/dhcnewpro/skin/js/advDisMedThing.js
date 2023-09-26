/// Description: 一次性医疗用品不良事件报告单
/// Creator: congyue
/// CreateDate: 2017-12-18
var eventtype=""
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	if ((recordId=="")){
		var frm = dhcadvdhcsys_getmenuform();
		if (frm) {
	        var adm = frm.EpisodeID.value;
		    EpisodeID=adm;
	        InitPatInfo(adm);//获取病人信息
		}
	}
	$('#OccuLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //必须设置这个属性
		onShowPanel:function(){ 
			$('#OccuLoc').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+'')
		}
	});
	$('#DisMedThingDept').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //必须设置这个属性
		onShowPanel:function(){ 
			$('#dept').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+'')
		}
	});
	
	$("#SaveBut").on("click",function(){
		SaveDisMedReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveDisMedReport(1);
	})
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	//报告日期控制
	$('#ReportDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//发生日期控制
	$('#DisMedThingHappenDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});

	CheckTimeornum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	PatMedNoEnter();//病案号回车事件
	PatIDEnter();//登记号回车事件
	InitDisMedReport(recordId);//加载页面信息
	
});
//加载报表信息
function InitDisMedReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		
		$('#OccuLoc').combobox('setValue',LgCtLocDesc);  //发生科室
		$('#DisMedThingDept').combobox('setValue',LgCtLocDesc);  //报告科室
		
		$('#DisMedThingEventUserOfReport').val(LgUserName); //填报人姓名为登录人
		$('#DisMedThingEventUserOfReport').attr("readonly","readonly");//填报人姓名为登录人
		if(LgGroupDesc=="护理部"){
			$('#ReportDate').datebox({disabled:false});//报告日期
		}else{
			$('#ReportDate').datebox({disabled:'true'});//报告日期
		}
		$('#ReportDate').datebox("setValue",RepDate);   //报告日期
		//病人信息	 
		$('#DisMedThingPatName').attr("readonly","readonly");//病人姓名	
	}else{
		//病人信息	 
		$('#DisMedThingPatName').attr("readonly","readonly");//病人姓名
		$('#PatSexinput').attr("readonly","readonly"); //性别
		$('#PatAge').attr("readonly","readonly"); //年龄
		//$('#PatMedicalNo').attr("readonly","readonly"); //病案号
		var date=$('#ReportDate').datebox("getValue");//报告日期
		if(LgGroupDesc=="护理部"){
			$('#ReportDate').datebox({disabled:false});//报告日期
			$('#ReportDate').datebox("setValue",date);   //报告日期
		}else{
			$('#ReportDate').datebox({disabled:'true'});//报告日期
			$('#ReportDate').datebox("setValue",date);   //报告日期
		}
		$('#DisMedThingEventUserOfReport').attr("readonly","readonly");//填报人姓名为登录人
    	$("#from").form('validate');			
	} 
}
//报告保存
function SaveDisMedReport(flag)
{
	if($('#DisMedThingPatName').val()==""){
		$.messager.alert("提示:","患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！");	
		return false;
	}
	///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReport(flag);
}
//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getRepPatInfo&PatNo="+""+"&EpisodeID="+EpisodeID,
		success: function(val){
			var tmp=val.split("^");
	    	//病人信息
	    	$('#PatID').val(tmp[0]); //登记号
			$('#DisMedThingPatName').val(tmp[1]); //病人姓名
			$('#DisMedThingPatName').attr("readonly","readonly");
			$('#PatSexinput').val(tmp[3]);  //性别
			$('#PatSexinput').attr("readonly","readonly");
			$('#PatAge').val(tmp[4]);  //年龄
			$('#PatAge').attr("readonly","readonly");
			$('#PatMedicalNo').val(tmp[5]); //病案号
			$('#PatMedicalNo').attr("readonly","readonly");
      		$("#from").form('validate');
		}
	})
}
//检查界面勾选其他，是否填写输入框
function checkother(){
	//患者来源
	var PatOriginoth=0;
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94109']").val()=="")){
				PatOriginoth=-1;
			}
		}
	})
	if(PatOriginoth==-1){
		$.messager.alert("提示:","【患者来源】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//发生地点
	var HappenPlaceoth=0;
	$("input[type=radio][id^='HappenPlace-label']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94076']").val()=="")){
				HappenPlaceoth=-1;
			}
		}
	})
	if(HappenPlaceoth==-1){
		$.messager.alert("提示:","【发生地点】勾选'其它'，请填写内容！");	
		return false;
	}
	
	//跌倒/坠床（指患者身体的任何部位（不包括双脚）意外触及地面）时患者的状态
	var Rankoth=0;
	$("input[type=radio][id^='FDPatState']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93720']").val()=="")){
				Rankoth=-1;
			}
		}
	})
	if(Rankoth==-1){
		$.messager.alert("提示:","【跌倒/坠床（指患者身体的任何部位（不包括双脚）意外触及地面）时患者的状态】勾选'其他'，请填写内容！");	
		return false;
	}

	//发生原因(可多选)  患者因素 
	var PatReasonoth=0,PatReason="",PatReasonList="";
	$("input[type=checkbox][id='OccurReason-95068']").each(function(){
		if ($(this).is(':checked')){
			PatReason=this.value;
		}
	})
	if(PatReason=="患者因素"){
		$("input[type=checkbox][id^='OccurReason-95068-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PatReasonList=this.value
			}
		})
		if (PatReasonList==""){
			$.messager.alert("提示:","【发生原因(可多选)】勾选'患者因素'，请勾选相应内容！");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='OccurReason-95068-']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93730'][class='lable-input']").val()=="")){
				PatReasonoth=-1; 
			}
		}
	})
	if(PatReasonoth==-1){
		$.messager.alert("提示:","【发生原因(可多选)】勾选'患者因素  其他'，请填写内容！");	
		return false;
	}

	//发生原因(可多选)  药物因素  
	var DrugReasonoth=0,DrugReason="",DrugReasonList="";
	$("input[type=checkbox][id='OccurReason-95069']").each(function(){
		if ($(this).is(':checked')){
			DrugReason=this.value;
		}
	})
	if(DrugReason=="药物因素"){
		$("input[type=checkbox][id^='OccurReason-95069-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugReasonList=this.value
			}
		})
		if (DrugReasonList==""){
			$.messager.alert("提示:","【发生原因(可多选)】勾选'药物因素'，请勾选相应内容！");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='OccurReason-95069-']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93739'][class='lable-input']").val()=="")){
				DrugReasonoth=-1; 
			}
		}
	})
	if(DrugReasonoth==-1){
		$.messager.alert("提示:","【发生原因(可多选)】勾选'药物因素  其他'，请填写内容！");	
		return false;
	}

	//发生原因(可多选)  管理因素  
	var ManageReasonoth=0,ManageReason="",ManageReasonList="";
	$("input[type=checkbox][id='OccurReason-95070']").each(function(){
		if ($(this).is(':checked')){
			ManageReason=this.value;
		}
	})
	if(ManageReason=="管理因素"){
		$("input[type=checkbox][id^='OccurReason-95070-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				ManageReasonList=this.value
			}
		})
		if (ManageReasonList==""){
			$.messager.alert("提示:","【发生原因(可多选)】勾选'管理因素'，请勾选相应内容！");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='OccurReason-95070-']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93746'][class='lable-input']").val()=="")){
				ManageReasonoth=-1; 
			}
		}
	})
	if(ManageReasonoth==-1){
		$.messager.alert("提示:","【发生原因(可多选)】勾选'管理因素  其他'，请填写内容！");	
		return false;
	}
	//发生原因(可多选)  其他因素  
	var OccurReasonoth=0;
	$("input[type=checkbox][id^='OccurReason']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93746'][class='lable-input']").val()=="")){
				OccurReasonoth=-1; 
			}
		}
	})
	if(OccurReasonoth==-1){
		$.messager.alert("提示:","【发生原因(可多选)】勾选'其它因素'，请填写内容！");	
		return false;
	}
	
	//发现人
	var DiscoverManoth=0;
	$("input[type=radio][id^='DiscoverMan']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94080']").val()=="")){
				DiscoverManoth=-1;
			}
		}
	})
	if(DiscoverManoth==-1){
		$.messager.alert("提示:","【发现人】勾选'其他人员'，请填写内容！");	
		return false;
	}
	
	//跌倒/坠床事件造成的结果   患者住院天数
	var FDResult="",FDResultList="";
	$("input[type=checkbox][id='FDResult-95132']").each(function(){
		if ($(this).is(':checked')){
			FDResult=this.value;
		}
	})
	if(FDResult=="患者住院天数"){
		$("input[type=radio][id^='FDResult-95132-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				FDResultList=this.value
			}
		})
		if (FDResultList==""){
			$.messager.alert("提示:","【跌倒/坠床事件造成的结果】勾选'患者住院天数'，请勾选相应内容！");	
			return false;
		}
	}
	//跌倒/坠床事件造 其他因素  
	var FDResultoth=0;
	$("input[type=checkbox][id^='FDResult']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94245'][class='lable-input']").val()=="")){
				FDResultoth=-1; 
			}
		}
	})
	if(FDResultoth==-1){
		$.messager.alert("提示:","【跌倒/坠床事件造成的结果】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//患者意外事件处理经过
	var PatEventProoth=0,PatEventPro="",PatEventProList="";
	$("input[type=checkbox][id='PatEventProcess-95021']").each(function(){
		if ($(this).is(':checked')){
			PatEventPro=this.value;
		}
	})
	if(PatEventPro=="立即通知"){
		$("input[type=radio][id^='PatEventProcess-95021']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PatEventProList=this.value
			}
		})
		if (PatEventProList==""){
			$.messager.alert("提示:","【患者意外事件处理经过】勾选'立即通知'，请勾选相应内容！");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='PatEventProcess']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94101'][class='lable-input']").val()=="")){
				PatEventProoth=-1; 
			}
		}
	})
	if(PatEventProoth==-1){
		$.messager.alert("提示:","【患者意外事件处理经过】勾选'其他'，请填写内容！");	
		return false;
	}
	
	return true;
}


//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//发生原因(可多选)  患者因素
	if($('#OccurReason-95068').is(':checked')){
		$("input[type=checkbox][id^='OccurReason-95068-']").attr("disabled",false);
		$("input[name$='.93730'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[type=checkbox][id^='OccurReason-95068-']").removeAttr("checked");
		$("input[type=checkbox][id^='OccurReason-95068-']").attr("disabled",true);
		$("input[name$='.93730'][class='lable-input']").val("");  //清空其他内容
		$("input[name$='.93730'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93730'][class='lable-input']").hide();  
	}
	
	//发生原因(可多选)  药物因素
	if($('#OccurReason-95069').is(':checked')){
		$("input[type=checkbox][id^='OccurReason-95069-']").attr("disabled",false);
		$("input[name$='.93739'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[type=checkbox][id^='OccurReason-95069-']").removeAttr("checked");
		$("input[type=checkbox][id^='OccurReason-95069-']").attr("disabled",true);
		$("input[name$='.93739'][class='lable-input']").val("");  //清空其他内容
		$("input[name$='.93739'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93739'][class='lable-input']").hide();  
	}
	
	//发生原因(可多选)  管理因素
	if($('#OccurReason-95070').is(':checked')){
		$("input[type=checkbox][id^='OccurReason-95070-']").attr("disabled",false);
		$("input[name$='.93746'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[type=checkbox][id^='OccurReason-95070-']").removeAttr("checked");
		$("input[type=checkbox][id^='OccurReason-95070-']").attr("disabled",true);
		$("input[name$='.93746'][class='lable-input']").val("");  //清空其他内容
		$("input[name$='.93746'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93746'][class='lable-input']").hide();  
	}
	
	//跌倒/坠床事件造成的结果   患者住院天数
	if($('#FDResult-95132').is(':checked')){
		$("input[type=radio][id^='FDResult-95132-']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='FDResult-95132-']").removeAttr("checked");
		$("input[type=radio][id^='FDResult-95132-']").attr("disabled",true);
	}
	
	//患者意外事件处理经过   立即通知
	if($('#PatEventProcess-95021').is(':checked')){
		$("input[type=radio][id^='PatEventProcess-95021-']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='PatEventProcess-95021-']").removeAttr("checked");
		$("input[type=radio][id^='PatEventProcess-95021-']").attr("disabled",true);
	}
}
//时间 数字校验
function CheckTimeornum(){
	//时间输入校验
	//发生时间
	$('#OccurTime').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#OccurTime').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#OccurTime').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	//给药时间错误 医嘱给药时间
	$('#DrugUseErrType-94617-94204').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#DrugUseErrType-94617-94204').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#DrugUseErrType-94617-94204').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	//给药时间错误 错误给药时间
	$('#DrugUseErrType-94617-94205').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#DrugUseErrType-94617-94205').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#DrugUseErrType-94617-94205').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	//遗漏给药 医嘱给药时间
	$('#DrugUseErrType-94619-94213').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#DrugUseErrType-94619-94213').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#DrugUseErrType-94619-94213').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	
	//数字输入校验
	//遗漏给药 遗漏次数
	$('#DrugUseErrType-94619-94212').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//当事人工作年限(年)
	$('#DrugUsePartyWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//工作年限(年)
	$('#WLManWorkLife').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//填报人工作年限
	$('#RepUserWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
}
//登记号自动补0
function getRePatNo(regno)
{
	//return regno;
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	return zero+regno ;
}
//通过住院号（病案号）获取病人基本信息
function PatMedNoEnter(){
	$('#PatMedicalNo').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			var patientNO=$('#PatMedicalNo').val();
			if (patientNO=="")
			{
				$.messager.alert("提示:","病人病案号不能为空！");
				return;
			}
			//var  patientNO=getRePatNo(patientNO);
			var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			var mycols = [[
				{field:'RegNo',title:'病人id',width:80},
				{field:'AdmTypeDesc',title:'就诊类型',width:60}, 
				{field:'AdmLoc',title:'就诊科室',width:120}, 
				{field:'AdmDate',title:'就诊日期',width:80},
				{field:'AdmTime',title:'就诊时间',width:70},
				{field:'Adm',title:'Adm',width:60,hidden:true} 
			]];
			var mydgs = {
				url:'dhcadv.repaction.csp'+'?action=GetAdmList&Input='+patientNO ,
				columns: mycols,  //列信息
				nowrap:false,
				pagesize:10,  //一页显示记录数
				table: '#admdsgrid', //grid ID
				field:'Adm', //记录唯一标识
				params:null,  // 请求字段,空为null
				tbar:null //上工具栏,空为null
			}
			var win=new CreatMyDiv(input,$("#PatMedicalNo"),"drugsfollower","460px","335px","admdsgrid",mycols,mydgs,"","",SetAdmIdTxtVal);	
			win.init();
		}
	});
}
//获取病案号选择记录数据
function SetAdmIdTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID="";
	}
	InitPatInfo(EpisodeID);
}
//登记号回车事件
function PatIDEnter(){
	$('#PatID').bind('keydown',function(event){

		 if(event.keyCode == "13")    
		 {
			 var PatID=$('#PatID').val();
			 if (PatID=="")
			 {
				 	$.messager.alert("提示:","病人登记号不能为空！");
					return;
			 }
			 var PatID=getRegNo(PatID);
			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'就诊科室',width:220}, 
			 	{field:'AdmDate',title:'就诊日期',width:80},
			 	{field:'AdmTime',title:'就诊时间',width:80},
			 	{field:'RegNo',title:'病人id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+PatID ,
				 columns: mycols,  //列信息
				 pagesize:10,  //一页显示记录数
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //记录唯一标识
				 params:null,  // 请求字段,空为null
				 tbar:null //上工具栏,空为null
				}
			 var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});	
}
//获取登记号选择记录数据
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	InitPatInfo(EpisodeID);
	
}
