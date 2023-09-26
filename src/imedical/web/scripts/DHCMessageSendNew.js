var GV={};
var normalCode="2000";
var importantCode="2008";
var LevelObj={U:"用户",L:"科室",G:"安全组",O:"组织"};
var OnlyRecType="";
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
function initPage(replyto,level){
	if(replyto>0){
		var replyname=$('#replytoName').val()
		$('#cPageTitle').html("回复"+replyname);
		OnlyRecType="U";
		$('#PageContent>table table tr>td:nth-child(1)').css('width','67px');
	}else{
		$('#cPageTitle').html("发送消息");
		var temp={};  //去重
		var RecTypeJson=[];
		var arr=level.split("");
		for(i=0;i<arr.length;i++){
			var code=arr[i];
			if("ULGO".indexOf(code)==-1){
				code="U";
			}
			if(!temp[code]){
				var item={Code:code,Desc:LevelObj[code]};
				RecTypeJson.push(item);
				temp[code]=true;
			}
		}
		if(RecTypeJson.length==1){   //U L G O
			OnlyRecType=RecTypeJson[0].Code;
			$('#PageContent>table table').prepend(getTrHtml(RecTypeJson[0].Desc));
			initRecObjectCombo(level);
			if(RecTypeJson[0].Desc.length==2){
				$('#PageContent>table table tr>td:nth-child(1)').css('width','67px');
			}
		}else{
			$('#PageContent>table table').prepend(getTrHtml(""));
			initRecTypeCombo(RecTypeJson);
		}
	}
	var AttaServerType = $("#AttaServerType").val();
	var nowday = $("#nowday").val();
	
	$("#uploadify").uploadify({
		buttonClass:"uploadify-button-a",
		buttonText:"上传附件",
		fileObjName:"FileStream",
		//formData:{dirname:"\\temp\\attacache\\"+nowday+"\\"},
		formData:{ServerType:AttaServerType,"CSPSESSIONID":$("#sessionid").val(),"act":"upload","CacheNoRedirect":"1","CacheUserName":"dhsyslogin","CachePassword":"1q2w3e4r%T6y7u8i9o0p"},
		removeCompleted:false,
        'swf': '../scripts_lib/jQuery/uploadify3.2.1/uploadify.swf',
        'uploader': "websys.file.utf8.csp?dirname=\\message\\temp\\attacache\\"+nowday+"\\", //'websys.file.utf8.csp',
        height:30,
        width:100,
        auto:true,
        'onUploadComplete' : function(file) {
	       $("#sendBtn").show();
        },
        'onUploadSuccess':function(file,data,res){
	        var o = $.parseJSON(data);
	    	if(o) $("#"+file.id).data("surl",o.fileFullName);
        },
        'onUploadStart' : function(file) {
           $("#sendBtn").hide();
        },
        'multi': true
    });
}
function getTrHtml(text){
	if(text==undefined){
		text="用户";
	}
	if(text!=""){
		var rtn='<TR style="height:30px;"><TD><P align=right><label>接收'+text+'</label></P></TD>'
			+'<TD><input id="RecObject" name="RecObject" style="" value="" /></TD>'
			+'<TD></TD><TD></TD><TD></TD></TR>';
	}else{
		var rtn='<TR style="height:30px;"><TD><P align=right><label>接收者类型</label></P></TD>'
			+'<TD><input id="RecType" name="RecType" style="" value="" /></TD>'
			+'<TD><P align=right><label id="cRecObject">接收对象</label></P></TD>'
			+'<TD><input id="RecObject" name="RecObject" style="" value="" /></TD>'
			+'</TR>';
	}
	return rtn;
}
function initRecObjectCombo(recType){
	var clsname="",QueryName="",columns="",pwidth;
	switch(recType){
		case "O":
			pwidth=500;
			clsname='websys.DHCMessageOrgMgr';
			QueryName='LookUpOrg';
			columns=[[{field:'Description',title:'组织描述',width:150},{field:'Code',title:'组织代码',align:'left',width:150},{field:'Note',title:'组织说明',align:'left',width:180},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		case "G":
			pwidth=310;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpGroup";
			columns=[[{field:'Description',title:'安全组',width:300},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		case "L":
			pwidth=410;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpLoc";
			columns=[[{field:'Description',title:'科室',width:220},{field:'Code',title:'代码',width:180},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
		default :
			pwidth=320;
			clsname="websys.DHCMessageOrgMgr";
			QueryName="LookUpUser";
			columns=[[{field:'Description',title:'姓名',width:180},{field:'Code',title:'工号',width:130},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
			break;
	}

	$('#RecObject').combogrid({
		width:200,
		disabled:false,
		delay: 500,
		panelWidth:pwidth||450,
		panelHeight:340,
		mode: 'remote',
		queryParams:{ClassName:clsname,QueryName: QueryName,desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
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
		width:200,
		panelHeight:120,
		editable:false,
		onSelect:function(record) {
			//$('#RecObject').combogrid("clear");
			//console.log(record);
			$('#cRecObject').html("接收"+record.Desc);
			initRecObjectCombo(record.Code);
			$('#RecObject').combogrid("clear");
		}
	});

}
//<TR><TD><P align=right><label id="cEffectiveDays">有效天数</label></P></TD><TD><input id="EffectiveDays" name="EffectiveDays" style="" value="" /></TD><TD><P align=right><label id="cImportant">紧急</label></P></TD><TD><input id="Important" name="Important" type="checkbox" /></TD><TD><P align=center><a id="sendBtn" name="sendBtn" class="easyui-linkbutton" data-options="disabled:false">发送</a></P></TD></TR>
function easyModal(title,url,width,height){
	var maxWidth=$(window).width(),maxHeight=$(window).height();
	width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
	height=''+height||'80%',height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
	var $easyModal=$('#easyModal');
	if ($easyModal.length==0){
		$easyModal=$('<div id="easyModal" style="overflow:hidden;" ><iframe name="easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe></div>').appendTo('body');
	}
	$easyModal.find('iframe').attr('src',url);
	$easyModal.dialog({
		iconCls:'icon-w-paper',
		modal:true,
		title:title,
		width:width,
		height:height
	}).dialog('open').dialog('center');
	return $easyModal;
	
}
$(function(){
	$.fn.pagination.defaults.showPageList=false;
	$.fn.pagination.defaults.showRefresh=false;
	$.fn.pagination.defaults.beforePageText='第';//页数文本框前显示的汉字
	$.fn.pagination.defaults.afterPageText='页,共{pages}页';
	$.fn.pagination.defaults.displayMsg = "共{total}记录";

	$('#sendBtn>span>span').css({"padding":"0 0 0 20px",
		"background":"url('../images/uiimages/msgsend.png') no-repeat left center"
	});
	$('#PageContent>table table tr').css('height','30px');
	$('#PageContent>table table tr>td:nth-child(1)').css('width','80px');
	$('#PageContent>table table tr>td:nth-child(2)').css('width','250px');
	$('#PageContent>table table tr>td:nth-child(3)').css('width','80px');
	$('#PageContent>table table tr>td:nth-child(4)').css('width','250px');
	$('#EffectiveDays').css("width","200px");
	$('#EffectiveDays').numberbox({min:0 });

	var replyto=$('#replyto').val();
	var level=$('#level').val();
	if(level==""){
		level=$('#grplevel').val();
	}
	level=level.toUpperCase();
	initPage(replyto,level);
	
	$('<tr><td style="text-align:right;padding-right:10px;">定时发送</td><td colspan=5>\
		<span id="timestr" style="border-bottom:1px solid #95B8E7;display:inline-block;padding:0 10px;height:30px;line-height:29px;min-width:180px;"></span>\
		<a id="timeclear" href="javascript:void(0);">清除时间</a>\
		<a id="timeselect" href="javascript:void(0);">选择时间</a>\
	</td></tr>').insertBefore($('#uploadify').closest('tr'));
	GV.exp='';
	$('#timeclear').linkbutton({}).click(function(){
		$('#timestr').text('');
		GV.exp='';
	})
	var modal;
	$('#timeselect').linkbutton({}).click(function(){
		var url='dhcmessage.schedule.csp?reqExp='+GV.exp+'&parJsFun=timeSelectCallback'
		modal=easyModal('发送时间安排',url,870,670);
	})
	window.timeSelectCallback=function(data){
		if (data.act=='ok'){
			$('#timestr').text(data.expText);
			GV.exp=data.exp;
			modal.dialog('close');	
		}else{
			modal.dialog('close');	
		}	
	}

	var edtheight=400;
	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
		var winHeight = document.documentElement.clientHeight;
		var winWidth = document.documentElement.clientWidth;
		edtheight=winHeight-245;
		if(replyto>0){
			edtheight=edtheight+30;
		}
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
		var recType=OnlyRecType;
		if(recType=="") {
			recType=$('#RecType').combobox('getValue');   //接收者类型
		}
		if(replyto>0){
			var recObject=replyto;
		}else {
			var row=$('#RecObject').combogrid("grid").datagrid("getSelected");
			if(row&&(row.HIDDEN>0)){
				var recObject=row.HIDDEN;
			}else{
				$.messager.alert('失败','请通过选择的方式选择接收'+LevelObj[recType]+'!');
				return false;
			}
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
		var surlArr=[];
		$(".uploadify-queue-item").each(function(ind,itm){
			surlArr.push($("#"+itm.id).data("surl"));
		});
		var surl = surlArr.join(",").replace(/\\/g,"\\\\");
		//var rtn = cspHttpServerMethod(enc,context,2000,logonid,"","",touserrowid,"{\"attachmentUrl\":\""+surl+"\"}");
		$.ajaxRunServerMethod({
			ClassName:"websys.DHCMessageOrgMgr",MethodName:"Send",
			Context:context,
			ActionTypeCode:typeCode,
			FromUserRowId:logonid,
			RecType:recType,
			RecObject:recObject,
			EffectiveDays:effdays,
			OtherInfoJson:"{\"attachmentUrl\":\""+surl+"\"}",
			TaskSchedule:GV.exp||'',
			_headers:{'X-Accept-Tag':1}
			},
			function(data,textStatus){
				$.messager.progress('close');
				if(data>0){
					$.messager.alert('成功','消息发送成功!');
					var isStoreCBObj = document.getElementById("IsStoreCB");
					if (isStoreCBObj&&!isStoreCBObj.checked){
						clearData();
						$(".uploadify-queue-item").each(function(ind,itm){
							$('#uploadify').uploadify('cancel',itm.id)
						});
					}
					if (!isStoreCBObj){ //兼容老版
						clearData();						
						$(".uploadify-queue-item").each(function(ind,itm){
							$('#uploadify').uploadify('cancel',itm.id)
						});
					}
				}else{
					$.messager.alert('失败','发送失败了!<br>'+data.split('^')[1]||data,'error');
				}
				
			}
		);

	}
	function clearData(){
		editor.toolbar[0].items[0].setState(0);
		$('#RecObject').combogrid('clear');
		$("#Important").attr("checked",false);
		$('#EffectiveDays').val("");     
		editor.setData("");
		$('#timeclear').click();
	}


	//点击发送按钮，先校验，然后取值，最后调用后台方法
	$('#sendBtn').click(function(){    
		sendMessage();
	})

});

