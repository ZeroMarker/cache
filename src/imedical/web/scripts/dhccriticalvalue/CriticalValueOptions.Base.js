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
	//����
	{id:"Base||ShowEditEmrO",type:"checkbox"},
	{id:"Base||RequireEditEmrO",type:"checkbox"},
	{id:"Base||TipEditEmrO",type:"checkbox"},
	{id:"Base||PopupEmrOnExecO",type:"checkbox"},
	//������ˮ
	{id:"Base||ShowEditEmrEO",type:"checkbox"},
	{id:"Base||RequireEditEmrEO",type:"checkbox"},
	{id:"Base||TipEditEmrEO",type:"checkbox"},
	{id:"Base||PopupEmrOnExecEO",type:"checkbox"},
	//��������
	{id:"Base||ShowEditEmrEI",type:"checkbox"},
	{id:"Base||RequireEditEmrEI",type:"checkbox"},
	{id:"Base||TipEditEmrEI",type:"checkbox"},
	{id:"Base||PopupEmrOnExecEI",type:"checkbox"},
	//סԺ
	{id:"Base||ShowEditEmrI",type:"checkbox"},
	{id:"Base||RequireEditEmrI",type:"checkbox"},
	{id:"Base||TipEditEmrI",type:"checkbox"},
	{id:"Base||PopupEmrOnExecI",type:"checkbox"},
	//���
	{id:"Base||ShowEditEmrH",type:"checkbox"},
	{id:"Base||RequireEditEmrH",type:"checkbox"},
	{id:"Base||TipEditEmrH",type:"checkbox"},
	{id:"Base||PopupEmrOnExecH",type:"checkbox"},
	
	{id:"Base||AllowEditEmrInOtherLoc",type:"checkbox"},
		
	"Base||OrderEditLink",
	//"Base||OrderEditLinkO","Base||OrderEditLinkEO","Base||OrderEditLinkEI","Base||OrderEditLinkI","Base||OrderEditLinkH",
	"Base||CYOrderEditLink",
	//"Base||CYOrderEditLinkO","Base||CYOrderEditLinkEO","Base||CYOrderEditLinkEI","Base||CYOrderEditLinkI","Base||CYOrderEditLinkH",
	//����
	{id:"Base||ShowEditOrderO",type:"checkbox"},
	{id:"Base||RequireEditOrderO",type:"checkbox"},
	{id:"Base||TipEditOrderO",type:"checkbox"},
	//������ˮ
	{id:"Base||ShowEditOrderEO",type:"checkbox"},
	{id:"Base||RequireEditOrderEO",type:"checkbox"},
	{id:"Base||TipEditOrderEO",type:"checkbox"},
	//��������
	{id:"Base||ShowEditOrderEI",type:"checkbox"},
	{id:"Base||RequireEditOrderEI",type:"checkbox"},
	{id:"Base||TipEditOrderEI",type:"checkbox"},
	///סԺ
	{id:"Base||ShowEditOrderI",type:"checkbox"},
	{id:"Base||RequireEditOrderI",type:"checkbox"},
	{id:"Base||TipEditOrderI",type:"checkbox"},
	///���
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
			text:'����',
			handler:GV.save
		},{
			text:'�ر�',
			handler:function(){
				$('#win').dialog('close');
			}
		}]
	})
	
	/*$('.emr-popover-trigger').popover({
		trigger:'hover',
		content:'����֧��{key}����ռλ��<br>�������ǰ�key����ƥ�����,<br>֧�ֵ�key:<br>EpisodeID,UserCode,UserID,<br>GroupID,CTLocID,AntCVID,<br>InstanceID,PatientID,mradm'
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
			{field:'label',title:'������',width:150},
			{field:'ov',title:'ԭֵ',width:350,styler:function(){
				return 'word-break: break-all;'
			},formatter:function(val,row){
				var cf=$.hisui.getArrayItem(GV.arr,'id',row['id']);
				if (cf && typeof cf=="object" && (cf.type=="checkbox" || cf.type=="radio" )) {
					return val=="1"?'��':'��';
				}
				return val;
			}},
			{field:'nv',title:'��ֵ',width:350,styler:function(){
				return 'word-break: break-all;'
			},formatter:function(val,row){
				var cf=$.hisui.getArrayItem(GV.arr,'id',row['id']);
				if (cf && typeof cf=="object" && (cf.type=="checkbox" || cf.type=="radio" )) {
					return val=="1"?'��':'��';
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
			GV.alert("�ɹ�","����ɹ�","success");
			GV.load();
		}else{
			GV.alert("ʧ��","����ʧ��"+(rtn.split("^")[1]||""),"error");
		}
	})
};

GV.confirm=function(){ //ȷ���޸�
	var admTypes={O:'����',EO:'������ˮ',EI:'��������',I:'סԺ',H:'���'};
	//��������ֵ��js��ȫ�ֱ����Ա�
	GV.toSubmitData={};
	var html=""
	var domData=common.getData(GV.arr);
	var rows=[];
	for(var i in domData){
		if (domData[i]!=GV.options[i]) {
			GV.toSubmitData[i]=domData[i];
			if (i.indexOf("Base||EmrEditLink")>-1){
				var label="������д����"+'��'+(admTypes[i.split('Base||EmrEditLink')[1]||'']||'')+'��';
			}else if (i.indexOf("Base||ShowEditEmr")>-1){
				var label="��ʾ��д��������ť"+'��'+(admTypes[i.split('Base||ShowEditEmr')[1]||'']||'')+'��';
			}else if (i.indexOf("Base||TipEditEmr")>-1){
				var label="��ʾд����"+'��'+(admTypes[i.split('Base||TipEditEmr')[1]||'']||'')+'��';
			}else if (i.indexOf("Base||RequireEditEmr")>-1){
				var label="����д����"+'��'+(admTypes[i.split('Base||RequireEditEmr')[1]||'']||'')+'��';
			}else if (i.indexOf("Base||PopupEmrOnExec")>-1){
				var label="����󵯳�д����"+'��'+(admTypes[i.split('Base||PopupEmrOnExec')[1]||'']||'')+'��';
			}else if (i=="Base||ShowNurEmr"){
				var label="��ʾ������������ť";
			}else if (i.indexOf("Base||OrderEditLink")>-1){
				var label="ҽ��¼������"+'��'+(admTypes[i.split('Base||OrderEditLink')[1]||'']||'')+'��';
			}else if (i.indexOf("Base||CYOrderEditLink")>-1){
				var label="��ҩҽ������"+'��'+(admTypes[i.split('Base||CYOrderEditLink')[1]||'']||'')+'��';
			}else if (i.indexOf("Base||ShowEditOrder")>-1){
				var label="��ʾ��ҽ��¼�롿��ť"+'��'+(admTypes[i.split('Base||ShowEditOrder')[1]||'']||'')+'��';
			}else if (i.indexOf("Base||TipEditOrder")>-1){
				var label="��ʾ��ҽ��"+'��'+(admTypes[i.split('Base||TipEditOrder')[1]||'']||'')+'��';
			}else if (i.indexOf("Base||RequireEditOrder")>-1){
				var label="���뿪ҽ��"+'��'+(admTypes[i.split('Base||RequireEditOrder')[1]||'']||'')+'��';
			}else if (i=="Base||ReceiveMode"){
				var label="Σ��ֵ����";
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
		$.messager.alert("��ʾ","û�н����޸�")	;
	}
}

$(init);