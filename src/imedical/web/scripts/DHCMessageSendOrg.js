var normalCode="2000";
var importantCode="2008";

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

$(function(){
	$('#sendBtn>span>span').css({"padding":"0 0 0 20px",
		"background":"url('../images/uiimages/msgsend.png') no-repeat left center"
	});
	$('#PageContent>table table tr').css('height','30px');
	$('#PageContent>table table tr>td:nth-child(1)').css('width','70px');
	$('#EffectiveDays').numberbox({min:0 });

	var edtheight=400;
	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
		var winHeight = document.documentElement.clientHeight;
		var winWidth = document.documentElement.clientWidth;
		edtheight=winHeight-205;
	}
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
					sendMessage();
				}
				
			}  
		}); 
	})
	function sendMessage(){
		var toorgid=$('#ReceiveOrg').combogrid("getValue");     //组织ID
		if(toorgid==""){
			$.messager.alert('失败','请选择接收消息的人!');
			return false;
		}
		var context=editor.getData();                           //消息内容
		if(isEmptyHtml(context)){
			$.messager.alert('失败','消息内容不能为空!');
			return;
		}
		context=beforeSave(context);                
		var effdays=$('#EffectiveDays').val();                  //有效天数
		var typeCode=normalCode;                                //消息紧急程度  对应俩消息类型
		if($("#Important").attr("checked")){
			typeCode=importantCode;	
		}
		var logonid=session['LOGON.USERID'];          //发送人
		if(!(logonid>0)){
			$.messager.alert('失败','未获取到您的用户ID，请确认是否已登录!');
			return;
		}
		$.messager.progress({ 
			title:'请稍后', 
			msg:'正在发送消息，请稍后...',
			text:'Sending...'
		});
		
		$.ajaxRunServerMethod({
			ClassName:"websys.DHCMessageOrgMgr",MethodName:"Send2",
			Context:context,
			ActionTypeCode:typeCode,
			FromUserRowId:logonid,
			ToOrgId:toorgid,
			EffectiveDays:effdays
			},
			function(data,textStatus){
				$.messager.progress('close');
				if(data>0){
					$.messager.alert('成功','消息发送成功!');
					clearData();
				}else{
					$.messager.alert('失败','发送失败了!');
				}
				
			}
		);

	}
	function clearData(){
		editor.toolbar[0].items[0].setState(0);
		$('#ReceiveOrg').combogrid('clear');
		$("#Important").attr("checked",false);
		$('#EffectiveDays').val("");     
		editor.setData("");
	}
	$('#ReceiveOrg').combogrid({
		width:500,
		disabled:false,		
		delay: 500,
		panelWidth:500,
		panelHeight:310,
		mode: 'remote',
		queryParams:{ClassName:'websys.DHCMessageOrgMgr',QueryName: 'Find',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'OrgId',
		textField: 'ODesc',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'ODesc',title:'Desc',width:150},{field:'OCode',title:'Code',align:'left',width:150},{field:'ONote',title:'Note',align:'left',width:180},{field:'OrgId',title:'HIDDEN',align:'right',hidden:true,width:0}]],
		pagination: true , 
		pageSize: 10 
	});

	//点击发送按钮，先校验，然后取值，最后调用后台方法
	$('#sendBtn').click(function(){    
		sendMessage();
	})

});

