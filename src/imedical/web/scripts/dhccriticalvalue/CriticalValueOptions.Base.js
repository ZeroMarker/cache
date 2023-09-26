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
	
]
var init=function(){
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
					return val=="1"?'是':'否';
				}
				return val;
			}},
			{field:'nv',title:'新值',width:350,styler:function(){
				return 'word-break: break-all;'
			},formatter:function(val,row){
				var cf=$.hisui.getArrayItem(GV.arr,'id',row['id']);
				if (cf && typeof cf=="object" && (cf.type=="checkbox" || cf.type=="radio" )) {
					return val=="1"?'是':'否';
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
			}else if (i.indexOf("Base||TipEditOrder")>-1){
				var label="提示开医嘱"+'【'+(admTypes[i.split('Base||TipEditOrder')[1]||'']||'')+'】';
			}else if (i.indexOf("Base||RequireEditOrder")>-1){
				var label="必须开医嘱"+'【'+(admTypes[i.split('Base||RequireEditOrder')[1]||'']||'')+'】';
			}else if (i=="Base||ReceiveMode"){
				var label="危急值接收";
			}else{
				var label=$("#"+i.escapeJquery()).closest('.opts-editor').parent().find('.opts-label').text();
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

$(init);