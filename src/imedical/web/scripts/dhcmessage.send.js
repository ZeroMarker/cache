if(typeof $g=='undefined') var $g=function(a){return a;};
function beforeSave(html){
	html = html.replace(/(\r)|(\n)/g, "")
	return "<div class=\"msgDiv\">"+html+"</div><!--msgDiv-->";
}
function isEmptyHtml(html){
	html=html.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
	if($.trim(html)==""){
		return true;
	}else{
		return false;
	}
}
function beforeSetData(html){
	return html.replace(/(<div class="msgDiv">)|(<\/div><!--msgDiv-->)/g, "");  
}


function initRecObjectCombo(recType){
	var clsname="",QueryName="",columns="",pwidth;
	switch(recType){
		case "O":
			pwidth=500;
			clsname='websys.DHCMessageOrgMgr';
			QueryName='LookUpOrg';
			columns=[[{field:'Description',title:'��֯����',width:150},{field:'Code',title:'��֯����',align:'left',width:150},{field:'Note',title:'��֯˵��',align:'left',width:176},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		case "G":
			pwidth=500;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpGroup";
			columns=[[{field:'Description',title:'��ȫ��',width:480},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		case "L":
			pwidth=564;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpLoc";
			columns=[[{field:'Description',title:'����',width:180},{field:'Code',title:'����',width:180},{field:'HospDesc',title:'Ժ��',width:180},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		case "LA":
			pwidth=564;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpLoc";
			columns=[[{field:'Description',title:'����',width:180},{field:'Code',title:'����',width:180},{field:'HospDesc',title:'Ժ��',width:180},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		default :
			pwidth=500;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpUser";
			columns=[[{field:'Description',title:'����',width:240},{field:'Code',title:'����',width:237},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
	}

	$('#RecObject').combogrid({
		width:180,
		disabled:false,
		delay: 500,
		panelWidth:pwidth||450,
		panelHeight:340,
		mode: 'remote',
		url:$URL,
		queryParams:{ClassName:clsname,QueryName: QueryName,desc:""},
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: columns,
		pagination: true ,
		pageSize: 10
	});
}
function initRecTypeCombo(RecTypeJson){

	initRecObjectCombo(RecTypeJson[0].Code);
	$('#cRecObject').html("����"+RecTypeJson[0].Desc);
	$('#RecType').combobox({
		data:RecTypeJson,
		value:RecTypeJson[0].Code,
		valueField:'Code',
		textField:"Desc",
		width:180,
		panelHeight:120,
		editable:false,
		onSelect:function(record) {
			$('#cRecObject').html( $g("����") + record.Desc );
			initRecObjectCombo(record.Code);
			$('#RecObject').combogrid("clear");
		}
	});

}

function initReceivers(){
	var levelJson=$.parseJSON(GV.LevelJSONStr);
	initRecTypeCombo(levelJson);
	if(levelJson.length=='1'){
		$('#cRecType,#wRecType').hide();
		$('#wRecObject').attr('colspan','3').css('width',650)
		
	}
	
	GV.getRecType=function(){
		var val=$('#RecType').combobox('getValue');   //����������
		return val;
	}
	GV.getRecObject=function(){
		var val=$('#RecObject').combogrid("getValue");
		return val;
	}
	GV.clearReceivers=function(){
		$('#RecObject').combogrid('clear');
	}
	
		
}

function initTaskSchedule(){
	GV.exp='';
	$('#timeclear').linkbutton({}).click(function(){
		$('#TaskSchedule').triggerbox('setValue','');
		GV.exp='';
	})
	
	var modal;
	$('#TaskSchedule').triggerbox({
		width:180,
		handler:function(){
			var url='dhcmessage.schedule.csp?reqExp='+GV.exp+'&parJsFun=timeSelectCallback'
			modal=easyModal('����ʱ�䰲��',url,870,670);
		}	
	})
	window.timeSelectCallback=function(data){
		if (data.act=='ok'){
			
			$('#TaskSchedule').triggerbox('setValue',data.expText)
			GV.exp=data.exp;
			modal.dialog('close');	
		}else{
			modal.dialog('close');	
		}	
	}
	GV.clearTaskSchedule=function(){
		$('#timeclear').click();
	}
}

function bsp_sys_ajaxUploadFile(files,options,callback){
	var dir=options.dir;
	if (!dir) {
		if (typeof callback=='function'){
			callback(false,'û��ָ���ļ�·��')
		}
		return false;
	}
	if (!files || !files[0]) {
		if (typeof callback=='function'){
			callback(false,'û��ѡ���ļ�')
		}
		return false;
	}
	
	
	var formData = new FormData();
	formData.append('FileStream', files[0]);
	formData.append('dirname',dir);
	formData.append('act','upload');
	var a=$.ajax({
	    url: 'websys.file.utf8.csp',
	    type: 'POST',
	    cache: false,
	    dataType:'text',
	    data: formData,
	    processData: false,
	    contentType: false
	}).done(function(ret) {
		try{
			ret=$.parseJSON(ret);	
		}catch(e){
			ret={fileFullName:'',msg:e.message}
		}
		if (ret.fileFullName){ //�ϴ��ɹ�
			if (typeof callback=='function'){
				callback(true,ret.fileFullName)
			}
		}else{
			if (typeof callback=='function'){
				callback(false,ret.msg||'')
			}
		}
	}).fail(function(res) {
		//console.log(res);
		if (typeof callback=='function'){
			callback(false,'�ļ��ϴ�ʧ��')
		}
	});
	
	return a;
}



function initAtta(){
	var fileMap={}; 
	function initFileInput(){
		$('#file-atta').remove(); 
		$('body').append('<input type="file" id="file-atta" name="file-atta"  style="position:absolute;top:-1000px;" />');
		$('#file-atta').off('change').change(function(){
			var fileName=this.value;
			
			if (fileName.indexOf('\\')>-1) fileName=fileName.split('\\').pop();
			if (fileName.indexOf('/')>-1) fileName=fileName.split('/').pop();
			
			var files=this.files;
			if (files && files[0] && fileName){
				if( !fileMap[fileName]) {
					startUpload(files,fileName);
				}else{
					$.messager.confirm('ȷ��','���ļ����ϴ����Ƿ������ϴ���',function(r){
						if(r){
							startUpload(files,fileName);
						}else{
							initFileInput();
						}
					})
				}
			}
			
		})
	}
	initFileInput();
	$('#btn-atta').append('<label class="filebox-label" for="file-atta"></label>');

	
	
	function startUpload(files,fileName){
		$('#btn-atta').linkbutton('disable');
		$('#file-atta').attr('disable','disable');
		GV.disableSend();
		
		bsp_sys_ajaxUploadFile(files,{dir:GV.dir},function(succ,url){
			if(succ){
				fileMap[fileName]=url;
				var size=Math.ceil( files[0].size/1024 )
				var text=fileName+'('+size+'kb)';
				var attaItem=$('<a class="atta-item">'+text+'<span class="remove">x</span></a>').appendTo('#atta-tr');
				attaItem.data('attaUrl',url);
				attaItem.data('fileName',fileName);
				//console.log(files)
				
			}else{
				$.messager.popover({msg:url,type:'error'})
			}
			$('#btn-atta').linkbutton('enable');
			initFileInput();
			GV.enableSend();
			
		})
	}
	$('#atta-tr').on('click','.atta-item .remove',function(){
		var attaItem=$(this).parent();
		var fileName=attaItem.data('fileName')
		attaItem.remove();
		delete fileMap[fileName];
	})
	GV.getAtta=function(){
		var surlArr=[];
		$('.atta-item').each(function(ind,itm){
			surlArr.push($(this).data('attaUrl'));
		});
		var surl = surlArr.join(",");
		return surl;	
	}
	GV.clearAtta=function(){
		$('.atta-item').remove();
		fileMap={};
	}
}

function initEditor(){

	var edtheight=400;
	edtheight=$('#context').outerHeight();
	edtheight=edtheight-42-29-2;
	var editor=CKEDITOR.replace( 'context' ,{
			height:edtheight,
			toolbar:[
			['Save','Preview'],
			['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
			['TextColor','BGColor'],
			['Styles','Format','Font','FontSize'],
			['Link','Unlink'],
			['HorizontalRule','Smiley','SpecialChar','-','Outdent','Indent'],
			['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
			['Maximize']
			]
		});
	editor.on("instanceReady", function (evt) {
		var saveBtn = editor.toolbar[0].items[0];
		editor.on("change",function(){
			saveBtn.setState(2);
		});

		editor.addCommand("save",{ 
			modes: { wysiwyg: 1, source: 1 }, 
			exec: function (editor) {
				var state = saveBtn.getState();
				if (state==CKEDITOR.TRISTATE_OFF){
					GV.sendMessage();
				}
				
			}  
		}); 
	})
	
	GV.getContext=function(){
		return editor.getData();
	}
	GV.setContext=function(context){
		editor.toolbar[0].items[0].setState(2);
		editor.setData(context);	
	}
	GV.clearContext=function(){
		editor.toolbar[0].items[0].setState(0);
		editor.setData("");	
	}
}

function initSend(){
	$('#sendBtn').click(function(){
		GV.disableSend(); 
		
		var recType=GV.getRecType();
		var recObject=GV.getRecObject();
		if (!(recObject>0)){
			$.messager.popover({msg:'��ѡ����ն���',type:'error'})	;
			return GV.enableSend();
		}
		var context=GV.getContext();
		if(isEmptyHtml(context)){
			$.messager.popover({msg:'��Ϣ���ݲ���Ϊ��!',type:'error'});
			return GV.enableSend();
		}
		context=beforeSave(context);                
		var effdays=$('#EffectiveDays').val();                  //��Ч����
//		var typeCode=GV.normalCode;                                //��Ϣ�����̶�  ��Ӧ����Ϣ����
//		if($("#Important").checkbox("getValue")){
//			typeCode=GV.importantCode;	
//		}
		
		var typeCode=GV.getActionType()
		if(!typeCode) {
			$.messager.popover({msg:'��ѡ����Ϣ����',type:'error'});
			return GV.enableSend();
		}

		var logonid=session['LOGON.USERID'];          //������
		if(!(logonid>0)){
			$.messager.popover({msg:'δ��ȡ�������û�ID����ȷ���Ƿ��ѵ�¼!',type:'error'});
			return GV.enableSend();
		}
		$.messager.progress({ 
			title:'���Ժ�', 
			msg:'���ڷ�����Ϣ�����Ժ�...',
			text:'Sending...'
		});
		var surl = GV.getAtta();
		var otherJson="{\"attachmentUrl\":\""+surl.replace(/\\/g,"\\\\")+"\"}"   ;
		var data={
			ClassName:"websys.DHCMessageOrgMgr",MethodName:"Send",_headers:{'X-Accept-Tag':1},
			Context:context,
			ActionTypeCode:typeCode,
			FromUserRowId:logonid,
			RecType:recType,
			RecObject:recObject,
			EffectiveDays:effdays,
			OtherInfoJson:otherJson,
			TaskSchedule:GV.exp||''
		}
		
		
		$.m(data,function(data,textStatus){
				$.messager.progress('close');
				if(data>0){
					$.messager.alert('�ɹ�','��Ϣ���ͳɹ�!','success',function(){
						if(!$('#IsStoreCB').checkbox('getValue')) {
							GV.clear()
						}
					});
					
					
					
				}else{
					$.messager.popover({msg:'����ʧ�ܣ�'+data.split('^')[1]||data,type:'error'});
				}
				GV.enableSend();
			}
		);
		
	})
	GV.sendMessage=function(){
		$('#sendBtn').click();
	}
	GV.enableSend=function(){
		$('#sendBtn').linkbutton('enable');	
	}
	GV.disableSend=function(){
		$('#sendBtn').linkbutton('disable');	
	}
}

var initTemplate=function(){

	
	////��ʼ��ģ��ѡ��������
	initTemplateSelector('TemplateSel',function(tmpl){
		var context=GV.getContext();                           //��Ϣ����
		if(!isEmptyHtml(context)){
			$.messager.confirm('ȷ��','��ǰ��Ϣ�����������ݲ�Ϊ�գ��Ƿ�ģ�����ݸ��ǵ���Ϣ����',function(r){
				if(r){
					GV.setContext(tmpl);
					
				}
				
			});
			return;
		}else{
			GV.setContext(tmpl);
			
		}
		
		
	})
	$('#SaveTemplate').click(function(){
		var context=GV.getContext();                          //��Ϣ����
		if(!isEmptyHtml(context)){
			content_saveAs_template(context)
			
		}else{
			$.messager.alert('ʧ��','��Ϣ���ݲ���Ϊ��!');
			
		}
		
	})
	

	$('#TemplateMgr').click(function(){
		
		easyModal('ģ�����','dhcmessage.contenttemplate.csp','90%','90%')
		
	})
	

	
}

var initActionType=function(){
	
//	if(!(GV.noticeActionTypeJson && GV.noticeActionTypeJson.length>0)){
//		
//		GV.noticeActionTypeJson=[{value:'2000',text:$g('��֪ͨͨ')},{value:'2008',text:'����֪ͨ'}];
//		
//	}
	
	$('#ActionType').combobox({
		data:GV.noticeActionTypeJson,
		panelHeight:'auto',
		width:180,
		value:'' //GV.noticeActionTypeJson[0].value
		,defaultFilter:4
	})
	
	GV.getActionType=function(){
		return $('#ActionType').combobox('getValue')||'';
	}
	
	GV.clearActionType=function(){
		$('#ActionType').combobox('setValue', '' );
	}
	
}


var init=function(){
	GV.clearFuncs=[];
	initReceivers();
	
	$('#EffectiveDays').outerWidth(180);
	
	initTaskSchedule();
	initAtta();
	initEditor();
	initTemplate();
	initActionType();
	initSend();
	
	
	GV.clear=function(){
		GV.clearReceivers();
		GV.clearTaskSchedule();
		$('#EffectiveDays').val('');
		//$('#Important').checkbox('setValue',false);
		GV.clearActionType();
		
		GV.clearAtta();
		GV.clearContext();
	}
	
}
$(init);