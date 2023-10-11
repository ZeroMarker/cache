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
			columns=[[{field:'Description',title:'组织描述',width:150},{field:'Code',title:'组织代码',align:'left',width:150},{field:'Note',title:'组织说明',align:'left',width:176},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		case "G":
			pwidth=500;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpGroup";
			columns=[[{field:'Description',title:'安全组',width:480},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		case "L":
			pwidth=564;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpLoc";
			columns=[[{field:'Description',title:'科室',width:180},{field:'Code',title:'代码',width:180},{field:'HospDesc',title:'院区',width:180},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		case "LA":
			pwidth=564;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpLoc";
			columns=[[{field:'Description',title:'科室',width:180},{field:'Code',title:'代码',width:180},{field:'HospDesc',title:'院区',width:180},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		default :
			pwidth=500;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpUser";
			columns=[[{field:'Description',title:'姓名',width:240},{field:'Code',title:'工号',width:237},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
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
	$('#cRecObject').html("接收"+RecTypeJson[0].Desc);
	$('#RecType').combobox({
		data:RecTypeJson,
		value:RecTypeJson[0].Code,
		valueField:'Code',
		textField:"Desc",
		width:180,
		panelHeight:120,
		editable:false,
		onSelect:function(record) {
			$('#cRecObject').html( $g("接收") + record.Desc );
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
		var val=$('#RecType').combobox('getValue');   //接收者类型
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
			modal=easyModal('发送时间安排',url,870,670);
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
			callback(false,'没有指定文件路径')
		}
		return false;
	}
	if (!files || !files[0]) {
		if (typeof callback=='function'){
			callback(false,'没有选择文件')
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
		if (ret.fileFullName){ //上传成功
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
			callback(false,'文件上传失败')
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
					$.messager.confirm('确认','此文件已上传，是否重新上传？',function(r){
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
			$.messager.popover({msg:'请选择接收对象',type:'error'})	;
			return GV.enableSend();
		}
		var context=GV.getContext();
		if(isEmptyHtml(context)){
			$.messager.popover({msg:'消息内容不能为空!',type:'error'});
			return GV.enableSend();
		}
		context=beforeSave(context);                
		var effdays=$('#EffectiveDays').val();                  //有效天数
//		var typeCode=GV.normalCode;                                //消息紧急程度  对应俩消息类型
//		if($("#Important").checkbox("getValue")){
//			typeCode=GV.importantCode;	
//		}
		
		var typeCode=GV.getActionType()
		if(!typeCode) {
			$.messager.popover({msg:'请选择消息类型',type:'error'});
			return GV.enableSend();
		}

		var logonid=session['LOGON.USERID'];          //发送人
		if(!(logonid>0)){
			$.messager.popover({msg:'未获取到您的用户ID，请确认是否已登录!',type:'error'});
			return GV.enableSend();
		}
		$.messager.progress({ 
			title:'请稍后', 
			msg:'正在发送消息，请稍后...',
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
					$.messager.alert('成功','消息发送成功!','success',function(){
						if(!$('#IsStoreCB').checkbox('getValue')) {
							GV.clear()
						}
					});
					
					
					
				}else{
					$.messager.popover({msg:'发送失败：'+data.split('^')[1]||data,type:'error'});
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

	
	////初始化模板选择下拉框
	initTemplateSelector('TemplateSel',function(tmpl){
		var context=GV.getContext();                           //消息内容
		if(!isEmptyHtml(context)){
			$.messager.confirm('确认','当前消息内容区域内容不为空，是否将模板数据覆盖到消息内容',function(r){
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
		var context=GV.getContext();                          //消息内容
		if(!isEmptyHtml(context)){
			content_saveAs_template(context)
			
		}else{
			$.messager.alert('失败','消息内容不能为空!');
			
		}
		
	})
	

	$('#TemplateMgr').click(function(){
		
		easyModal('模板管理','dhcmessage.contenttemplate.csp','90%','90%')
		
	})
	

	
}

var initActionType=function(){
	
//	if(!(GV.noticeActionTypeJson && GV.noticeActionTypeJson.length>0)){
//		
//		GV.noticeActionTypeJson=[{value:'2000',text:$g('普通通知')},{value:'2008',text:'紧急通知'}];
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