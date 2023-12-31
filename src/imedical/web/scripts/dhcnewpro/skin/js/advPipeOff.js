/// Description: 管路滑脱报告单
/// Creator: congyue
/// CreateDate: 2017-12-15
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
		SavePipeReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SavePipeReport(1);
	})
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
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
	//脱管发现日期控制
	$('#PipeFindDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//置管日期控制
	$('#TubeDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});

	CheckTimeornum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	PatMedNoEnter();//病案号回车事件
	PatIDEnter();//登记号回车事件
	InitPipeReport(recordId);//加载页面信息
	
});
//加载报表信息
function InitPipeReport(recordId)
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
		$('#DisMedThingPatName').attr("readonly","readonly"); //病人姓名 
		$('#PatSexinput').attr("readonly","readonly"); //性别
		$('#PatAge').attr("readonly","readonly"); //年龄
		//$('#PatMedicalNo').attr("readonly","readonly");  //病案号
		$('#PatAdmDate').datebox({disabled:'true'});  //入院日期
		$('#PatDiag').attr("readonly","readonly"); //诊断
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
function SavePipeReport(flag)
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
      		InitCheckRadio();
		}
	})
}
//检查界面勾选其他，是否填写输入框
function checkother(){
	//患者来源
	var PatOriginoth=0;
	$("input[type=radio][id^='PatOrigin']").each(function(){
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
	//文化程度
	var DegreeEducateoth=0;
	$("input[type=radio][id^='DegreeEducate']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94120']").val()=="")){
				DegreeEducateoth=-1;
			}
		}
	})
	if(DegreeEducateoth==-1){
		$.messager.alert("提示:","【文化程度】勾选'其他'，请填写内容！");	
		return false;
	}
	//发现人
	var PipeDiscoverersoth=0;
	$("input[type=radio][id^='PipeDiscoverers']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93813']").val()=="")){
				PipeDiscoverersoth=-1;
			}
		}
	})
	if(PipeDiscoverersoth==-1){
		$.messager.alert("提示:","【发现人】勾选'其他人员'，请填写内容！");	
		return false;
	}
	//导管类型 
	var PipeTypeoth=0;
	$("input[type=checkbox][id^='PipeType']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93838'][class='lable-input']").val()=="")){
				PipeTypeoth=-1;
			}
		}
	})
	if(PipeTypeoth==-1){
		$.messager.alert("提示:","【导管类型】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//患者身体状况  精神状态
	var PipePSoth=0;
	$("input[type=radio][id^='PipePS-94474']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93504']").val()=="")){
				PipePSoth=-1;
			}
		}	
	})
	$("input[type=radio][id^='PipePS-94475']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93510']").val()=="")){
				PipePSoth=-2;
			}
		}	
	})
	if(PipePSoth==-1){
		$.messager.alert("提示:","【患者身体状况精神状态】勾选'其他'，请填写内容！");	
		return false;
	}
	if(PipePSoth==-2){
		$.messager.alert("提示:","【患者身体状况活动能力】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//脱管原因
	var PipeReasonoth=0;
	$("input[type=checkbox][id^='PipeReason']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93845'][class='lable-input']").val()=="")){
				PipeReasonoth=-1;
			}
		}	
	})
	if(PipeReasonoth==-1){
		$.messager.alert("提示:","【脱管原因】勾选'其他'，请填写内容！");	
		return false;
	}
	//固定方法
	var PipeFixedMethodoth=0;
	$("input[type=checkbox][id^='PipeFixedMethod']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93850'][class='lable-input']").val()=="")){
				PipeFixedMethodoth=-1;
			}
		}	
	})
	if(PipeFixedMethodoth==-1){
		$.messager.alert("提示:","【固定方法】勾选'其他'，请填写内容！");	
		return false;
	}
	//采取措施
	var PipeTakeStepsoth=0;
	$("input[type=checkbox][id^='PipeTakeSteps']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93859'][class='lable-input']").val()=="")){
				PipeTakeStepsoth=-1;
			}
			if((this.value=="诊断性检查")&&($("input[name$='.94258'][class='lable-input']").val()=="")){
				PipeTakeStepsoth=-2;
			}
		}	
	})
	if(PipeTakeStepsoth==-2){
		$.messager.alert("提示:","【采取措施】勾选'诊断性检查'，请填写内容！");	
		return false;
	}
	if(PipeTakeStepsoth==-1){
		$.messager.alert("提示:","【采取措施】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//并发症 
	var PipeComploth=0,PipeCompl="",PipeList="";
	$("input[type=radio][id='PipeComplication-94540']").each(function(){
		if ($(this).is(':checked')){
			PipeCompl=this.value;
		}
	})
	if(PipeCompl=="有"){
		$("input[type=checkbox][id^='PipeComplication-94540']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PipeList=this.value
			}
		})
		if (PipeList==""){
			$.messager.alert("提示:","【并发症】勾选'有'，请勾选相应内容！");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='PipeComplication-94540-94541']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93546'][class='lable-input']").val()=="")){
				PipeComploth=-1; //出血为空
			}
		}
	})
	
	if(PipeComploth==-1){
		$.messager.alert("提示:","【并发症】勾选'出血'，请填写内容！");	
		return false;
	}
	$("input[type=checkbox][id^='PipeComplication-94540-94548']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93553'][class='lable-input']").val()=="")){
				PipeComploth=-2; //其他内容为空
			}
		}	
	})
	if(PipeComploth==-2){
		$.messager.alert("提示:","【并发症】勾选'其他'，请填写内容！");	
		return false;
	}
	
	return true;
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//事件造成的结果   患者住院天数
	if($('#PipeTakeSteps-94536').is(':checked')){
		$("#PipeTakeSteps-94536-94258").attr("readonly",false);
	}else{
		$("#PipeTakeSteps-94536-94258").val("");
		$("#PipeTakeSteps-94536-94258").attr("readonly","readonly");
	}
	//患者来源
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if (id=="PatOrigin-label-94337"){
				$('#PatAdmADLScore').val(""); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#D4D0C8");
				$('#PatAdmADLScore').attr("readonly","readonly"); //入院时ADL得分
				$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
				$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //自我照顾能力
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //自我照顾能力
			}else{
				$('#PatAdmADLScore').attr("readonly",false); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //自我照顾能力
			}
		}
	})
	
}
//时间 数字校验
function CheckTimeornum(){
	//时间输入校验
	//脱管发现时间
	$('#PipeFindTime').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#PipeFindTime').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#PipeFindTime').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	
	//数字输入校验  
	//填报人工作年限(年)
	$('#RepUserWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//事件发生情况当班护士工作年限(年)
	$('#WallWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	
	//入院时ADL得分
	$('#PatAdmADLScore').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
		if((this.value>100)||(this.value=="")){
			$.messager.alert("提示:","【入院时ADL得分】输入1-100的整数！");	
			$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");
			this.value="";
		}else if((this.value>40)||(this.value<100)){
			$("input[type=radio][id^='PatSelfCareAbility-94346']").click();	
		}
		if(((this.value>0)||(this.value==0))&&((this.value<40)||(this.value==40))&&(this.value!="")){
			$("input[type=radio][id^='PatSelfCareAbility-94347']").click();	
		}
		if(this.value==100){
			$("input[type=radio][id^='PatSelfCareAbility-94345']").click();	
		}
	})
	//发生前ADL得分
	$('#OccurADLScore').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
		if((this.value>100)||(this.value=="")){
			$.messager.alert("提示:","【发生前ADL得分】输入1-100的整数！");	
			$("input[type=radio][id^='OccurPatSelfCareAbility-']").removeAttr("checked");
			this.value="";
		}else if((this.value>40)||(this.value<100)){
			$("input[type=radio][id^='OccurPatSelfCareAbility-94240']").click();	
		}
		if(((this.value>0)||(this.value==0))&&((this.value<40)||(this.value==40))&&(this.value!="")){
			$("input[type=radio][id^='OccurPatSelfCareAbility-94241']").click();	
		}
		if(this.value==100){
			$("input[type=radio][id^='OccurPatSelfCareAbility-94239']").click();	
		}
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
