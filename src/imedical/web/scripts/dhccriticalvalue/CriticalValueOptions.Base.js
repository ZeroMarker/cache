var GV={};
GV.alert=function(title,msg,type){
	if (typeof $.messager.popover=="function"){
		$.messager.popover({msg:msg,type:type,timeout: 1000})
	}else{
		$.messager.alert(title,msg)
	}
}
if (typeof $URL=="undefined") var $URL='jquery.easyui.querydatatrans.csp';

GV.arr=[
	//"Base||EmrEditLink",
	"Base||EmrEditLinkO","Base||EmrEditLinkEO","Base||EmrEditLinkEI","Base||EmrEditLinkI","Base||EmrEditLinkH",
	"Base||EmrViewLink",
	//门诊
	{id:"Base||ShowEditEmrO",type:"checkbox"},
	{id:"Base||RequireEditEmrO",type:"checkbox"},
	{id:"Base||TipEditEmrO",type:"checkbox"},
	{id:"Base||PopupEmrOnExecO",type:"checkbox"},
	//急诊流水
	{id:"Base||ShowEditEmrEO",type:"checkbox"},
	{id:"Base||RequireEditEmrEO",type:"checkbox"},
	{id:"Base||TipEditEmrEO",type:"checkbox"},
	{id:"Base||PopupEmrOnExecEO",type:"checkbox"},
	//急诊留观
	{id:"Base||ShowEditEmrEI",type:"checkbox"},
	{id:"Base||RequireEditEmrEI",type:"checkbox"},
	{id:"Base||TipEditEmrEI",type:"checkbox"},
	{id:"Base||PopupEmrOnExecEI",type:"checkbox"},
	//住院
	{id:"Base||ShowEditEmrI",type:"checkbox"},
	{id:"Base||RequireEditEmrI",type:"checkbox"},
	{id:"Base||TipEditEmrI",type:"checkbox"},
	{id:"Base||PopupEmrOnExecI",type:"checkbox"},
	//体检
	{id:"Base||ShowEditEmrH",type:"checkbox"},
	{id:"Base||RequireEditEmrH",type:"checkbox"},
	{id:"Base||TipEditEmrH",type:"checkbox"},
	{id:"Base||PopupEmrOnExecH",type:"checkbox"},
	
	{id:"Base||AllowEditEmrInOtherLoc",type:"checkbox"},
		
	"Base||OrderEditLink",
	//"Base||OrderEditLinkO","Base||OrderEditLinkEO","Base||OrderEditLinkEI","Base||OrderEditLinkI","Base||OrderEditLinkH",
	"Base||CYOrderEditLink",
	//"Base||CYOrderEditLinkO","Base||CYOrderEditLinkEO","Base||CYOrderEditLinkEI","Base||CYOrderEditLinkI","Base||CYOrderEditLinkH",
	//门诊
	{id:"Base||ShowEditOrderO",type:"checkbox"},
	{id:"Base||RequireEditOrderO",type:"checkbox"},
	{id:"Base||TipEditOrderO",type:"checkbox"},
	//急诊流水
	{id:"Base||ShowEditOrderEO",type:"checkbox"},
	{id:"Base||RequireEditOrderEO",type:"checkbox"},
	{id:"Base||TipEditOrderEO",type:"checkbox"},
	//急诊留观
	{id:"Base||ShowEditOrderEI",type:"checkbox"},
	{id:"Base||RequireEditOrderEI",type:"checkbox"},
	{id:"Base||TipEditOrderEI",type:"checkbox"},
	///住院
	{id:"Base||ShowEditOrderI",type:"checkbox"},
	{id:"Base||RequireEditOrderI",type:"checkbox"},
	{id:"Base||TipEditOrderI",type:"checkbox"},
	///体检
	{id:"Base||ShowEditOrderH",type:"checkbox"},
	{id:"Base||RequireEditOrderH",type:"checkbox"},
	{id:"Base||TipEditOrderH",type:"checkbox"}
	,{id:"Base||AllowEditOrderInOtherLoc",type:"checkbox"}
	
	,{id:"Base||ShowTransAdvice",type:"checkbox"}
	//,"Base||NurEmrLink",
	//,{id:"Base||ShowNurEmr",type:"checkbox"}
	
	,{id:"Base||ReceiveMode",type:"radio"}
	,{id:"Base||AllowFwDoc",type:"checkbox"}
	,'Base||ExecTimeUsedData'
	
	//手动关联医嘱
	,{id:"Base||ShowLinkOrderO",type:"checkbox"}
	,{id:"Base||ShowLinkOrderEO",type:"checkbox"}
	,{id:"Base||ShowLinkOrderEI",type:"checkbox"}
	,{id:"Base||ShowLinkOrderI",type:"checkbox"}
	,{id:"Base||ShowLinkOrderH",type:"checkbox"}
	
	//会诊
	,"Base||ConsultationLink"
	,{id:"Base||ShowConsultationO",type:"checkbox"}
	,{id:"Base||ShowConsultationEO",type:"checkbox"}
	,{id:"Base||ShowConsultationEI",type:"checkbox"}
	,{id:"Base||ShowConsultationI",type:"checkbox"}
	,{id:"Base||ShowConsultationH",type:"checkbox"}
	
	,{id:"Base||ReceiveContact",type:"radio"}
	,{id:"Base||ExecNurMsgOnReceive",type:"checkbox"}
	,{id:"Base||AllowNurExec",type:"checkbox"}
	//,{id:"Base||InvMTSTimePoint",type:"radio"}  //8.5 处理时调用平台接口 不用控制内部接口了
	,{id:"Base||PINOnReceive",type:"checkbox"}
	,{id:"Base||PINOnExec",type:"checkbox"}
	,{id:"Base||PINOnForward",type:"checkbox"}
	,{id:"Base||ReceiveContactTel",type:"radio"}
	,{id:"Base||AllowNoTelOnReceive",type:"checkbox"}
	,"Base||RecTimeLimit","Base||ExecTimeLimit"
	
	,{id:"Base||FwDocMustSameAdmType",type:"checkbox"}
	
	,{id:"Base||HideExecContactInfoO",type:"checkbox"}
	,{id:"Base||HideExecContactInfoEO",type:"checkbox"}
	,{id:"Base||HideExecContactInfoEI",type:"checkbox"}
	,{id:"Base||HideExecContactInfoI",type:"checkbox"}
	,{id:"Base||HideExecContactInfoH",type:"checkbox"}
	
	,{id:"Base||ExecRequireContactO",type:"checkbox"}
	,{id:"Base||ExecRequireContactEO",type:"checkbox"}
	,{id:"Base||ExecRequireContactEI",type:"checkbox"}
	,{id:"Base||ExecRequireContactI",type:"checkbox"}
	,{id:"Base||ExecRequireContactH",type:"checkbox"}
	
	,{id:"Base||ExecRequireContactTelO",type:"checkbox"}
	,{id:"Base||ExecRequireContactTelEO",type:"checkbox"}
	,{id:"Base||ExecRequireContactTelEI",type:"checkbox"}
	,{id:"Base||ExecRequireContactTelI",type:"checkbox"}
	,{id:"Base||ExecRequireContactTelH",type:"checkbox"}
	
	,{id:"Base||ExecRequireContactResultO",type:"checkbox"}
	,{id:"Base||ExecRequireContactResultEO",type:"checkbox"}
	,{id:"Base||ExecRequireContactResultEI",type:"checkbox"}
	,{id:"Base||ExecRequireContactResultI",type:"checkbox"}
	,{id:"Base||ExecRequireContactResultH",type:"checkbox"}
	,{id:"Base||ContactResultDefValue",type:"combobox"}
	
	,{id:"Base||ExecRequireTransAdviceO",type:"checkbox"}
	,{id:"Base||ExecRequireTransAdviceEO",type:"checkbox"}
	,{id:"Base||ExecRequireTransAdviceEI",type:"checkbox"}
	,{id:"Base||ExecRequireTransAdviceI",type:"checkbox"}
	,{id:"Base||ExecRequireTransAdviceH",type:"checkbox"}
	///接收时解锁消息
	,{id:"Base||ConfirmMgsOnReceiveO",type:"checkbox"}
	,{id:"Base||ConfirmMgsOnReceiveEO",type:"checkbox"}
	,{id:"Base||ConfirmMgsOnReceiveEI",type:"checkbox"}
	,{id:"Base||ConfirmMgsOnReceiveI",type:"checkbox"}
	,{id:"Base||ConfirmMgsOnReceiveH",type:"checkbox"}
	
	,{id:"Base||ExecContactDefaultO",type:"radio"}
	,{id:"Base||ExecContactDefaultEO",type:"radio"}
	,{id:"Base||ExecContactDefaultEI",type:"radio"}
	,{id:"Base||ExecContactDefaultI",type:"radio"}
	,{id:"Base||ExecContactDefaultH",type:"radio"}
	,{id:"Base||ExecContactUserTelDefault",type:"radio"}
	
	,{id:"Base||NurRecDefContact",type:"radio"}
	,{id:"Base||AllowNurRecFwDoc",type:"checkbox"}
	
]
var init=function(){
	var conResultData=[{value:'',text:'空'},{value:'F',text:'已通知'},{value:'C',text:'未联系到'}];
	if(GV.dicConResultExec) {
		conResultData=[{value:'',text:'空'}];
		$.each(GV.dicConResultExec,function(){
			conResultData.push({value:this.TCode,text:this.TDesc})
		})
	}
	$('#Base\\|\\|ContactResultDefValue').combobox({data:conResultData});
	
	
	
	
	GV.load();
	$('#win').dialog({
		buttons:[{
			text:'保存',
			handler:GV.save
		},{
			text:'关闭',
			handler:function(){
				$('#win').dialog('close');
			}
		}]
	})
	
	/*$('.emr-popover-trigger').popover({
		trigger:'hover',
		content:'链接支持{key}进行占位，<br>打开链接是按key进行匹配变量,<br>支持的key:<br>EpisodeID,UserCode,UserID,<br>GroupID,CTLocID,AntCVID,<br>InstanceID,PatientID,mradm'
	})*/
	
	$('#confirm-table').datagrid({
		idField:'id',
		rownumbers:true,
		singleSelect:true,
		striped:true,
		nowrap:false,
		bodyCls:'panel-header-gray',
		fit:true,
		fitColumns:true,
		columns:[[
			{field:'label',title:'配置项',width:150},
			{field:'ov',title:'原值',width:350,styler:function(){
				return 'word-break: break-all;'
			},formatter:function(val,row){
				var cf=$.hisui.getArrayItem(GV.arr,'id',row['id']);
				if (cf && typeof cf=="object" && (cf.type=="checkbox" || cf.type=="radio" )) {
					if (cf.type=="radio") { //radio 拿label
						var $JO=$("input[name='"+cf.id+"'][value='"+val+"']");
						if($JO.length>0){
							return ($JO.radio('options')||{label:''}).label
						}else{
							return '';	
						}
					}else{
						return val=="1"?'是':'否';
					}
					
				}else if(cf && typeof cf=="object" && cf.type=="combobox" ){
					var cbOpts=$('#'+row.id.escapeJquery()).combobox('options');
					var dataItem=$.hisui.getArrayItem(cbOpts.data,cbOpts.valueField,val);
					if (dataItem) {
						return dataItem[cbOpts.textField];
					}else{
						return val;	
					}
					
				}
				return val;
			}},
			{field:'nv',title:'新值',width:350,styler:function(){
				return 'word-break: break-all;'
			},formatter:function(val,row){
				var cf=$.hisui.getArrayItem(GV.arr,'id',row['id']);
				if (cf && typeof cf=="object" && (cf.type=="checkbox" || cf.type=="radio" )) {
					if (cf.type=="radio") { //radio 拿label
						var $JO=$("input[name='"+cf.id+"'][value='"+val+"']");
						if($JO.length>0){
							return ($JO.radio('options')||{label:''}).label
						}else{
							return '';	
						}
					}else{
						return val=="1"?'是':'否';
					}
				}else if(cf && typeof cf=="object" && cf.type=="combobox" ){
					var cbOpts=$('#'+row.id.escapeJquery()).combobox('options');
					var dataItem=$.hisui.getArrayItem(cbOpts.data,cbOpts.valueField,val);
					if (dataItem) {
						return dataItem[cbOpts.textField];
					}else{
						return val;	
					}
					
				}
				return val;
			}}
		]],
		data:[]
	})
	initMutexCheckbox(['Base||RequireEditOrderO','Base||TipEditOrderO']);
	initMutexCheckbox(['Base||RequireEditOrderEO','Base||TipEditOrderEO']);
	initMutexCheckbox(['Base||RequireEditOrderEI','Base||TipEditOrderEI']);
	initMutexCheckbox(['Base||RequireEditOrderI','Base||TipEditOrderI']);
	initMutexCheckbox(['Base||RequireEditOrderH','Base||TipEditOrderH']);
	
	initMutexCheckbox(['Base||RequireEditEmrO','Base||TipEditEmrO','Base||PopupEmrOnExecO']);
	initMutexCheckbox(['Base||RequireEditEmrEO','Base||TipEditEmrEO','Base||PopupEmrOnExecEO']);
	initMutexCheckbox(['Base||RequireEditEmrEI','Base||TipEditEmrEI','Base||PopupEmrOnExecEI']);
	initMutexCheckbox(['Base||RequireEditEmrI','Base||TipEditEmrI','Base||PopupEmrOnExecI']);
	initMutexCheckbox(['Base||RequireEditEmrH','Base||TipEditEmrH','Base||PopupEmrOnExecH']);
	function initMutexCheckbox(arr){
		for (var i=0;i<arr.length;i++){
			arr[i]='#'+arr[i].escapeJquery();
		}
		var selectors=arr.join(',');
		
		for (var i=0;i<arr.length;i++){
			$(arr[i]).checkbox('options').onChecked=function(){
				//$(selectors).not(arr[i]).checkbox('setValue',false);
				$(selectors).not(this).checkbox('setValue',false);
			}
		}
	}
	
	LoadCombo2Css(30);
	initJsonArrBox('Base\\|\\|ExecTimeUsedData',{keyTitle:'时间段值',valueTitle:'时间段描述'});

}

function initJsonArrBox(id,myopts){
	myopts=myopts||{};
	var target=$('#'+id)[0];
	initKeyValueBox(target,$.extend({
		panelWidth:650,
		panelHeight:250,
		parseValue:parseValue,
		formatValue:formatValue
		,descEditor:'text'
	},myopts));
	function formatValue(o){
		var arr=[];
		$.each(o,function(){
			if(this.key!=""){
				arr.push({key:this.key,value:this.value,desc:this.desc})	;
			} 
		})
		return JSON.stringify(arr);
	}
	function parseValue(str){
		try{
			var arr=$.parseJSON(str);
		}catch(e){
			var arr=[];	
		}
		var all=[];
		$.each(arr,function(){
			all.push({key:this.key,value:this.value,desc:this.desc,custom:true})
		})
		if (all.length==0) all.push({key:'',desc:'',value:'',custom:true});
		all.push({key:'',desc:'',value:'',custom:true});
		return all;
	}
}



GV.load=function(){
	$.post($URL,{ClassName:"web.DHCAntCVOptions",QueryName:"Find",OptsType:"Base",ResultSetType:'array',rows:999}).done(function(r){
		var rows=$.parseJSON(r);
		GV.options={};
		$.each(rows,function(){
			GV.options[this.TId]=this.TDesc
		})
		GV.show();
	})	
}
GV.show=function(){
	common.setDataByRow(GV.arr,GV.options);
}
GV.save=function(){
	
	$.post($URL+'?ClassName=web.DHCAntCVOptions&MethodName=SaveBaseOptByRequest',GV.toSubmitData).done(function(rtn){
		if(rtn>0) {
			$('#win').dialog('close');
			GV.alert("成功","保存成功","success");
			GV.load();
		}else{
			GV.alert("失败","保存失败"+(rtn.split("^")[1]||""),"error");
		}
	})
};

GV.confirm=function(){ //确认修改
	var admTypes={O:'门诊',EO:'急诊流水',EI:'急诊留观',I:'住院',H:'体检'};
	//将输入框的值和js中全局变量对比
	GV.toSubmitData={};
	var html=""
	var domData=common.getData(GV.arr);
	var rows=[];
	for(var i in domData){
		if (domData[i]!=GV.options[i]) {
			GV.toSubmitData[i]=domData[i];
			if (i.indexOf("Base||EmrEditLink")>-1){
				var label="病历填写链接"+'【'+(admTypes[i.split('Base||EmrEditLink')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ShowEditEmr")>-1){
				var label="显示【写病历】按钮"+'【'+(admTypes[i.split('Base||ShowEditEmr')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||TipEditEmr")>-1){
				var label="提示写病历"+'【'+(admTypes[i.split('Base||TipEditEmr')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||RequireEditEmr")>-1){
				var label="必须写病历"+'【'+(admTypes[i.split('Base||RequireEditEmr')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||PopupEmrOnExec")>-1){
				var label="处理后弹出写病历"+'【'+(admTypes[i.split('Base||PopupEmrOnExec')[1]||'']||'')+'】';
			}else if (i=="Base||ShowNurEmr"){
				var label="显示【护理病历】按钮";
			}else if (i.indexOf("Base||OrderEditLink")>-1){
				var label="医嘱录入链接"+'【'+(admTypes[i.split('Base||OrderEditLink')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||CYOrderEditLink")>-1){
				var label="草药医嘱链接"+'【'+(admTypes[i.split('Base||CYOrderEditLink')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ShowEditOrder")>-1){
				var label="显示【医嘱录入】按钮"+'【'+(admTypes[i.split('Base||ShowEditOrder')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ShowLinkOrder")>-1){
				var label="显示【已开医嘱】按钮"+'【'+(admTypes[i.split('Base||ShowLinkOrder')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ShowConsultation")>-1){
				var label="显示【会诊申请】按钮"+'【'+(admTypes[i.split('Base||ShowConsultation')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||TipEditOrder")>-1){
				var label="提示要评估处理"+'【'+(admTypes[i.split('Base||TipEditOrder')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||RequireEditOrder")>-1){
				var label="必须评估处理"+'【'+(admTypes[i.split('Base||RequireEditOrder')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||HideExecContactInfo")>-1){
				var label="处理时不显示“通知信息”"+'【'+(admTypes[i.split('Base||HideExecContactInfo')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ExecRequireContactTel")>-1){
				var label="处理时“联系电话”必填"+'【'+(admTypes[i.split('Base||ExecRequireContactTel')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ExecRequireContactResult")>-1){
				var label="处理时“联系结果”必填"+'【'+(admTypes[i.split('Base||ExecRequireContactResult')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ExecRequireContact")>-1){
				var label="处理时“联系人”必填"+'【'+(admTypes[i.split('Base||ExecRequireContact')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ExecRequireTransAdvice")>-1){
				var label="处理时“意见措施”必填"+'【'+(admTypes[i.split('Base||ExecRequireTransAdvice')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ConfirmMgsOnReceive")>-1){
				var label="接收时解锁消息"+'【'+(admTypes[i.split('Base||ConfirmMgsOnReceive')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||ExecContactDefault")>-1){
				var label="处理时默认“联系人”"+'【'+(admTypes[i.split('Base||ExecContactDefault')[1]||'']||'')+'】';
			}else if (i=="Base||ExecContactUserTelDefault"){
				var label="处理时默认联系人为系统用户时默认电话";
			}else if (i=="Base||ReceiveMode"){
				var label="危急值接收";
			}else{
				if ($("#"+i.escapeJquery()).length>0) {
					var label=$("#"+i.escapeJquery()).closest('.opts-editor').parent().find('.opts-label').text();
				}else{
					var label=$("input[name="+i.escapeJquery()+"]").closest('.opts-editor').parent().find('.opts-label').text();	
				}
				
			}
			rows.push({id:i,label:label,ov:GV.options[i],nv:domData[i]});
		}
	}
	
	
	if (rows.length>0){
		$('#win').dialog('open');
		$('#confirm-table').datagrid('loadData',rows);
		
	}else{
		$.messager.alert("提示","没有进行修改")	;
	}
}

$(function(){
	$.cm({ClassName:'web.DHCAntCVOptions',QueryName:'Find',OptsType:'ConResultExec',rows:999},function(data){
		if (data&& data.rows) {
			GV.dicConResultExec=data.rows;	
			init();	
		}
		
	})

	
});