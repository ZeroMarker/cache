//日期格式校验
function CheckDate(str){
	if(str==""){return true;}
	if(dateformat==4){
		var RegStr=/^((((0[1-9]|[12][0-9]|3[01])\/(0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|((0[1-9]|[1][0-9]|2[0-8])\/02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
	}else if(dateformat==1){
		var RegStr=/^((((0[13578]|1[02])\/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)\/(0[1-9]|[12][0-9]|30))|(02\/(0[1-9]|[1][0-9]|2[0-8])))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
	}else{
		var RegStr=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
	}
	if (str.match(RegStr)==null){
		return false;
	}else{
		return true;
	}
}
//去除html标签
var replaceHtml=function(str){
	 return str.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
}

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
var UpdateMsg=function(ContentId,index){
	//console.log(ContentId+" update");
	
	$('#tDHCMessageContent').datagrid('selectRow',index);
	var msgHtml=$('#tDHCMessageContent').datagrid('getSelected').CText;
	editor.setData(beforeSetData(msgHtml),{
		callback: function(){
			this.checkDirty();
		}
	});	
	$.ajaxRunServerMethod({
		ClassName:"websys.DHCMessageContentMgr",MethodName:"IsAbleToChange",
		MsgContentId:ContentId
		},
		function(data,textStatus){		
			if(data>0){
				editingContentId=ContentId;
				$('#mydialog').dialog('open');
			}else{
				$.messager.alert('失败','消息内容不可修改');
			}			
		}
	);
}
var CancelMsg=function(ContentId){
	//console.log(ContentId+" cancel");
	$.ajaxRunServerMethod({
		ClassName:"websys.DHCMessageContentMgr",MethodName:"CancelMsg",
		MsgContentId:ContentId
		},
		function(data,textStatus){		
			if(data>0){
				$.messager.alert('成功','成功撤回一条消息!');
			}else{
				$.messager.alert('失败','撤回失败');
			}
			$('#FindBtn').click();
		}
	);
	
}
var editor=null;
var editingContentId="";

$(function(){
	var preViewObj=$('#preView');
	$('#DateEnd').datebox('setValue',now);
	$('#DateStart').datebox('setValue',now);
	var findTableHeight=parseInt($("#PageContent>table").css('height'));
	var dheight=500;
	var dsize=15;
	var trheight=27;   //datagrid一行的高度
	var winHeight = $(document).height();
	dheight=winHeight-findTableHeight-35;
	dsize=parseInt((dheight-35)/trheight)-1;
	
	/*if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
		var winHeight = document.documentElement.clientHeight;
		var winWidth = document.documentElement.clientWidth;
		dheight=winHeight-findTableHeight-35;
		dsize=parseInt((dheight-35)/trheight)-1;
	}*/
	$('#tDHCMessageContent').datagrid({
		queryParams: { DateStart : now, DateEnd : now, ToUser : "", FromUser : session['LOGON.USERID'], PatName : "", ActionType : ""},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageContentMgr&QueryName=FindByDateIndex',
		idField:'ContentId' ,
		height:dheight,
		singleSelect:true,
		pageSize:dsize,
		rownumbers: true,
		pagination: true,
		pageList: [dsize,30,50],  
		striped: true ,			
		columns:[[
			{field:'ContentId',title:'消息内容ID',hidden:true} ,
			{field:'CActionTypeDesc',title:'消息类型'} ,
			{field:'CText',title:'消息内容',width:500,formatter: function(value,row,index){
				//console.log(value);
				//console.log(replaceHtml(value));
				//return "<span class='msgText' msg='"+value+"'>"+replaceHtml(value)+"</span>";
				return "<span class='msgText' index='"+index+"'>"+replaceHtml(value)+"</span>";
			}} ,
			{field:'CSendDate',title:'发送日期'} ,
			{field:'CSendTime',title:'发送时间'} ,
			{field:'Edit',title:'修改',width:50,align:'center',formatter: function(value,row,index){
				if(row.CStatus=="C") return "";
				var str='  <a href="#" onclick="UpdateMsg(\''+row.ContentId+'\' , \''+index+'\')"><img src="../images/uiimages/pencil.png"></a>  ';
				return str;
			}} ,
			{field:'Cancel',title:'撤回',width:50,align:'center',formatter: function(value,row,index){
				if(row.CStatus=="C") return "已撤回";
				var str='  <a href="#" onclick="CancelMsg(\''+row.ContentId+'\')"><img src="../images/uiimages/undo.png"></a>  ';
				return str;
			}} 			
		]],
		onLoadSuccess:function(data){
			$('.msgText').hover(
				function(e){
					//var msgHtml=$(this).attr('msg');
					var index=parseInt($(this).attr('index'));
					var msgHtml=$('#tDHCMessageContent').datagrid('getRows')[index].CText;
					preViewObj.append(msgHtml);
					if((winHeight-e.pageY)>200){
						preViewObj.css({"left":e.pageX+"px","top":e.pageY+"px"});
					}else{
						preViewObj.css({"left":e.pageX+"px","top":(e.pageY-220)+"px"});
					}
					preViewObj.show();
				},function(){
					preViewObj.empty();
					preViewObj.hide();
				}
			);
		}

	});
	
	
	$('#FindBtn').click(function(){
		$('#tDHCMessageContent').datagrid('unselectAll');    //查询时取消选择的行
		var datestart=$('#DateStart').datebox('getValue');
		if(!CheckDate(datestart)){
			$.messager.alert('失败','开始日期格式不正确!');
			return false;
		}
		var dateend=$('#DateEnd').datebox('getValue');
		if(!CheckDate(dateend)){
			$.messager.alert('失败','结束日期格式不正确!');
			return false;
		}
		
		if (dateend==""){                                  //结束日期为空，取当天   
			dateend=now;
			$('#DateEnd').datebox('setValue',dateend);
		}
		if(datestart==""||$.fn.datebox.defaults.parser(datestart)>$.fn.datebox.defaults.parser(dateend)){             //开始日期为空，或者开始日期大于结束日期  取结束日期那一天
			datestart=dateend;
			$('#DateStart').datebox('setValue',datestart);
		}
		$('#tDHCMessageContent').datagrid('load',{ DateStart : datestart, DateEnd : dateend, ToUser : "", FromUser : session['LOGON.USERID'], PatName : "", ActionType : ""});
		
	});
	

	editor=CKEDITOR.replace( 'editor1' ,{
			height:408,
			toolbar:[
			['Save','Preview'],
			['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
			['TextColor','BGColor'],
			['Styles','Format','Font','FontSize'],
			['Link','Unlink'],
			'/',
			['HorizontalRule','Smiley','SpecialChar','-','Outdent','Indent'],
			['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
			['Maximize']
			]
	});
	
	editor.on("instanceReady", function (evt) {

		var saveBtn = editor.toolbar[0].items[0];
		
		editor.on("change",function(){
			saveBtn.setState(2)
		});

		editor.addCommand("save",{ 
			modes: { wysiwyg: 1, source: 1 }, 
			exec: function (editor) {
				//console.log(editor.getData());
				$.messager.confirm('提示信息' , "确定修改消息内容么" , function(r){
					if(r){
						$.ajaxRunServerMethod({
							_headers:{'X-Accept-Tag':1},
							ClassName:"websys.DHCMessageContentMgr",
							MethodName:"UpdateMsgContext",
							MsgContentId:editingContentId,
							msgText:beforeSave(editor.getData())
							},
							function(data,textStatus){
								if(data>0){
									$.messager.alert('成功','消息内容修改成功!','',function(){
										$('#mydialog').dialog('close');
										$('#FindBtn').click();
									});
									
								}else{
									$.messager.alert('失败','修改失败!');
								}
							}
						);
					} 
				});
			}  
		}); 
	})
	

})
	
	

