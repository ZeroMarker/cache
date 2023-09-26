/// Description: 用药错误报告单
/// Creator: congyue
/// CreateDate: 2017-12-16
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
	
	/*//科室1
	$('#DeptLocOne').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocCombox',
		mode:'remote',  //必须设置这个属性
		onSelect: function(rec){  
           var LocOneDr=rec.value; 
			ComboboxLocTwo(LocOneDr);        
	  }
	});*/
	$("#SaveBut").on("click",function(){
		SaveDrugErrReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveDrugErrReport(1);
	})
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	//入院时间控制
	$('#PatAdmDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//报告日期控制
	$('#ReportDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//给药发生日期控制
	$('#GiveDrugHappenTime').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	CheckTimeornum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	PatMedNoEnter();//病案号回车事件
	PatIDEnter();//登记号回车事件
	InitDrugErrReport(recordId);//加载页面信息
	
});
//加载报表信息
function InitDrugErrReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		
		$('#OccuLoc').combobox('setValue',LgCtLocDesc);  //发生科室
		$('#RepHospType').val(LgHospDesc); //报告单位
		$('#RepHospType').attr("readonly","readonly"); //报告单位
		$('#RepUserName').val(LgUserName); //填报人姓名为登录人
		$('#RepUserName').attr("readonly","readonly");//填报人姓名为登录人
		if(LgGroupDesc=="护理部"){
			$('#ReportDate').datebox({disabled:false});//报告日期
		}else{
			$('#ReportDate').datebox({disabled:'true'});//报告日期
		}
		$('#ReportDate').datebox("setValue",RepDate);   //报告日期

		//$('#HospPhone').val("64456715");//联系电话
		//$('#HospPhone').attr("readonly","readonly"); //联系电话
		//病人信息	 
		$('#DisMedThingPatName').attr("readonly","readonly");//病人姓名	
	}else{
		//病人信息	 
		$('#DisMedThingPatName').attr("readonly","readonly");//病人姓名
		$('#PatSexinput').attr("readonly","readonly"); //性别
		$('#PatAge').attr("readonly","readonly"); //年龄
		//$('#PatMedicalNo').attr("readonly","readonly"); //病案号
		$('#PatAdmDate').datebox({disabled:'true'});//入院日期     
		$('#PatDiag').attr("readonly","readonly");//诊断
		var date=$('#ReportDate').datebox("getValue");//报告日期
		if(LgGroupDesc=="护理部"){
			$('#ReportDate').datebox({disabled:false});//报告日期
			$('#ReportDate').datebox("setValue",date);   //报告日期
		}else{
			$('#ReportDate').datebox({disabled:'true'});//报告日期
			$('#ReportDate').datebox("setValue",date);   //报告日期
		}
		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",true);  //自我照顾能力
    	$('#RepHospType').attr("readonly","readonly"); //报告单位
    	$('#RepUserName').attr("readonly","readonly");//填报人姓名为登录人
    	//$('#HospPhone').attr("readonly","readonly"); //联系电话
    	$("#from").form('validate');			
	} 
}
//报告保存
function SaveDrugErrReport(flag)
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
			if(tmp[24]!=""){
	      		$('#PatAdmDate').datebox({disabled:'true'});	
	      	}
			$('#PatAdmDate').datebox("setValue",tmp[24]);  //入院日期
      		$('#PatDiag').val(tmp[10]);  //诊断
      		if(tmp[10]!=""){
	      		$('#PatDiag').attr("readonly","readonly");	
	      	}
	      	$("input[type=radio][id^='PatOrigin-label']").attr("disabled",false);  //自我照顾能力
	      	if((tmp[22]=="住院")||(tmp[22]=="门诊")||(tmp[22]=="急诊")||(tmp[22]=="日间病房")||(tmp[22]=="其他")){
		      	$("input[type=radio][value='"+tmp[22]+"']").click(); //患者来源
	      		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",true);  //自我照顾能力
	      	}else{
	      		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",false);  //自我照顾能力
		    }
	      	$("input[type=radio][value='"+tmp[23]+"']").click(); //护理级别
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
	$("input[type=radio][id^='DrugUseHappenPlace-label']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94125']").val()=="")){
				HappenPlaceoth=-1;
			}
		}
	})
	if(HappenPlaceoth==-1){
		$.messager.alert("提示:","【发生地点】勾选'其它'，请填写内容！");	
		return false;
	}
	
	//身份
	var Rankoth=0;
	$("input[type=radio][id^='DrugUseErrRank']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94136']").val()=="")){
				Rankoth=-1;
			}
		}
	})
	if(Rankoth==-1){
		$.messager.alert("提示:","【身份】勾选'其它'，请填写内容！");	
		return false;
	}

	//错误类型 给药时间错误
	var dosetimeerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94617']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94617-94204").val()=="")||($("#DrugUseErrType-94617-94205").val()=="")){
				dosetimeerr=-1;
			}
		}
	})
	if(dosetimeerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'给药时间错误'，请填写内容！");	
		return false;
	}
	//错误类型 给药途径错误
	var dosewayerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94618']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94618-94208").val()=="")||($("#DrugUseErrType-94618-94209").val()=="")){
				dosewayerr=-1;
			}
		}
	})
	if(dosewayerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'给药途径错误'，请填写内容！");	
		return false;
	}
	//错误类型 遗漏给药
	var missdose=0;
	$("input[type=checkbox][id^='DrugUseErrType-94619']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94619-94212").val()=="")||($("#DrugUseErrType-94619-94213").val()=="")){
				missdose=-1;
			}
		}
	})
	if(missdose==-1){
		$.messager.alert("提示:","【错误类型】勾选'遗漏给药'，请填写内容！");	
		return false;
	}
	//错误类型 输液速度错误
	var infusionspeed=0;
	$("input[type=checkbox][id^='DrugUseErrType-94620']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94620-94215").val()=="")||($("#DrugUseErrType-94620-94216").val()=="")){
				infusionspeed=-1;
			}
		}
	})
	if(infusionspeed==-1){
		$.messager.alert("提示:","【错误类型】勾选'输液速度错误'，请填写内容！");	
		return false;
	}
	//错误类型 剂量错误
	var dosageerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94621']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94621-94219").val()=="")||($("#DrugUseErrType-94621-94220").val()=="")){
				dosageerr=-1;
			}
		}
	})
	if(dosageerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'剂量错误'，请填写内容！");	
		return false;
	}
	//错误类型 剂型错误
	var dosageformerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94622']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94622-94223").val()=="")||($("#DrugUseErrType-94622-94224").val()=="")){
				dosageformerr=-1;
			}
		}
	})
	if(dosageformerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'剂型错误'，请填写内容！");	
		return false;
	}
	//错误类型 药物错误
	var drugerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94623']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94623-94227").val()=="")||($("#DrugUseErrType-94623-94228").val()=="")){
				drugerr=-1;
			}
		}
	})
	if(drugerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'药物错误'，请填写内容！");	
		return false;
	}
	//错误类型 其它
	var otherr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94625']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94152'][class='lable-input']").val()=="")){
				otherr=-1; 
			}
		}
	})
	if(otherr==-1){
		$.messager.alert("提示:","【错误类型】勾选'其它'，请填写内容！");	
		return false;
	}

	//缺陷引起的后果
	var DefectResultoth=0;
	$("input[type=radio][id^='DrugUseDefectResult-label']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94158'][class='lable-input']").val()=="")){
				DefectResultoth=-1; 
			}
		}
	})
	if(DefectResultoth==-1){
		$.messager.alert("提示:","【缺陷引起的后果】勾选'其它'，请填写内容！");	
		return false;
	}
	
	return true;
}

//页面关联设置
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		//给药时间错误
		if(id=="DrugUseErrType-94617"){
			$('#DrugUseErrType-94617-94204').attr("readonly",false);//医嘱给药时间
			$('#DrugUseErrType-94617-94205').attr("readonly",false);//错误给药时间
		}
		//给药途径错误
		if(id=="DrugUseErrType-94618"){
			$('#DrugUseErrType-94618-94208').attr("readonly",false);//医嘱给药途径
			$('#DrugUseErrType-94618-94209').attr("readonly",false);//错误给药途径
		}
		
	}else{
		///给药时间错误
		if(id=="DrugUseErrType-94617"){
			$('#DrugUseErrType-94617-94204').val("");
			$('#DrugUseErrType-94617-94204').attr("readonly","readonly"); //医嘱给药时间
			$('#DrugUseErrType-94617-94205').val("");
			$('#DrugUseErrType-94617-94205').attr("readonly","readonly"); //错误给药时间
		}
		//给药途径错误
		if(id=="DrugUseErrType-94618"){
			$('#DrugUseErrType-94618-94208').val("");
			$('#DrugUseErrType-94618-94208').attr("readonly","readonly"); //医嘱给药途径
			$('#DrugUseErrType-94618-94209').val("");
			$('#DrugUseErrType-94618-94209').attr("readonly","readonly"); //错误给药途径
		} 
	}
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//给药时间错误
	if($('#DrugUseErrType-94617').is(':checked')){
		$('#DrugUseErrType-94617-94204').attr("readonly",false);//医嘱给药时间
		$('#DrugUseErrType-94617-94205').attr("readonly",false);//错误给药时间
	}else{
		$('#DrugUseErrType-94617-94204').val("");
		$('#DrugUseErrType-94617-94204').attr("readonly","readonly"); //医嘱给药时间
		$('#DrugUseErrType-94617-94205').val("");
		$('#DrugUseErrType-94617-94205').attr("readonly","readonly"); //错误给药时间
	}
	//给药途径错误
	if($('#DrugUseErrType-94618').is(':checked')){
		$('#DrugUseErrType-94618-94208').attr("readonly",false);//医嘱给药途径
		$('#DrugUseErrType-94618-94209').attr("readonly",false);//错误给药途径
	}else{
		$('#DrugUseErrType-94618-94208').val("");
		$('#DrugUseErrType-94618-94208').attr("readonly","readonly"); //医嘱给药途径
		$('#DrugUseErrType-94618-94209').val("");
		$('#DrugUseErrType-94618-94209').attr("readonly","readonly"); //错误给药途径
	}
	//遗漏给药
	if($('#DrugUseErrType-94619').is(':checked')){
		$('#DrugUseErrType-94619-94212').attr("readonly",false);//遗漏次数
		$('#DrugUseErrType-94619-94213').attr("readonly",false);//医嘱给药时间
	}else{
		$('#DrugUseErrType-94619-94212').val("");
		$('#DrugUseErrType-94619-94212').attr("readonly","readonly"); //遗漏次数
		$('#DrugUseErrType-94619-94213').val("");
		$('#DrugUseErrType-94619-94213').attr("readonly","readonly"); //医嘱给药时间
	}
	//输液速度错误 
	if($('#DrugUseErrType-94620').is(':checked')){
		$('#DrugUseErrType-94620-94215').attr("readonly",false);//药物名称
		$('#DrugUseErrType-94620-94216').attr("readonly",false);//错误给药速度
	}else{
		$('#DrugUseErrType-94620-94215').val("");
		$('#DrugUseErrType-94620-94215').attr("readonly","readonly"); //药物名称
		$('#DrugUseErrType-94620-94216').val("");
		$('#DrugUseErrType-94620-94216').attr("readonly","readonly"); //错误给药速度
	}
	//剂量错误  
	if($('#DrugUseErrType-94621').is(':checked')){
		$('#DrugUseErrType-94621-94219').attr("readonly",false);//医嘱给药剂量
		$('#DrugUseErrType-94621-94220').attr("readonly",false);//错误给药剂量
	}else{
		$('#DrugUseErrType-94621-94219').val("");
		$('#DrugUseErrType-94621-94219').attr("readonly","readonly"); //医嘱给药剂量
		$('#DrugUseErrType-94621-94220').val("");
		$('#DrugUseErrType-94621-94220').attr("readonly","readonly"); //错误给药剂量
	}
	//剂型错误 
	if($('#DrugUseErrType-94622').is(':checked')){
		$('#DrugUseErrType-94622-94223').attr("readonly",false);//医嘱给药剂型
		$('#DrugUseErrType-94622-94224').attr("readonly",false);//错误给药剂型
	}else{
		$('#DrugUseErrType-94622-94223').val("");
		$('#DrugUseErrType-94622-94223').attr("readonly","readonly"); //医嘱给药剂型
		$('#DrugUseErrType-94622-94224').val("");
		$('#DrugUseErrType-94622-94224').attr("readonly","readonly"); //错误给药剂型
	}
	//药物错误 
	if($('#DrugUseErrType-94623').is(':checked')){
		$('#DrugUseErrType-94623-94227').attr("readonly",false);//医嘱给药名称
		$('#DrugUseErrType-94623-94228').attr("readonly",false);//错误给药名称
	}else{
		$('#DrugUseErrType-94623-94227').val("");
		$('#DrugUseErrType-94623-94227').attr("readonly","readonly"); //医嘱给药名称
		$('#DrugUseErrType-94623-94228').val("");
		$('#DrugUseErrType-94623-94228').attr("readonly","readonly"); //错误给药名称
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
//根据科室1查询科室2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //必须设置这个属性
	});   

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

