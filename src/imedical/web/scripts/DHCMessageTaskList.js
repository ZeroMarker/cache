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
var StatusList=[{text:'正常',value:'N'},{text:'已完成',value:'F'},{text:'已终止',value:'S'}];
var StatusMap={};
for (var i=0;i<StatusList.length;i++){StatusMap[StatusList[i].value]=StatusList[i].text;}





var UpdateTask=function(taskid,index){
	//console.log(ContentId+" update");
	
	$('#taskList').datagrid('selectRow',index);
	var msgHtml=$('#taskList').datagrid('getSelected').Content;
	editor.setData(beforeSetData(msgHtml),{
		callback: function(){
			this.checkDirty();
		}
	});	
	$('#mydialog').dialog('open');
	editingTaskId=taskid;

}
var StopTask=function(taskid){
	$.messager.confirm('提示信息' , "确定要终止此任务么" , function(r){
		if(r){
			$.m({ClassName:'BSP.MSG.BL.Task',MethodName:'StopTask',id:taskid,user:session['LOGON.USERID']},function(data,textStatus){
				if(data>0){
					$.messager.alert('成功','终止成功!','success',function(){
						$('#taskList').datagrid('reload');
					});
					
				}else{
					$.messager.alert('失败',data.split('^')[1]||data,'error');
				}
			})
		}
	})

}
var editor=null;
var editingTaskId="";

function timeSecond2Alias(seconds){
	var itv=parseInt(seconds)||0;
	var day=Math.floor( itv/86400 );
	itv=itv-day*86400;
	var hour=Math.floor( itv/3600 );
	itv=itv-hour*3600;
	var minute=Math.floor( itv/60 );
	itv=itv-minute*60;
	
	var ret='';
	if (day>0) ret+=day+'天';
	if(hour>0 || day>0) ret+=hour+'小时';
	if(minute>0 || day>0 ||hour>0) ret+=minute+'分钟';
	return ret;
	
}
function getScheduleText(str){
	var strText='',arr=str.split('^');
	if (arr[0]) strText+='从'+arr[0]+'起，';
	if (arr[3]){ strText+='在【'+arr[3]+'】发送';}
	else if (arr[4]) {strText+='每隔【'+timeSecond2Alias(arr[4])+'】发送';}
	else if (arr[5]) {strText+='以Cron表达式【'+arr[5]+'】发送';}
	if (arr[1]) strText+='，直至'+arr[1]+'';
	if (arr[2]) strText+='，最多发送'+arr[2]+'次';	
	return strText;
}

$(function(){
	var nowDate=$.fn.datebox.defaults.formatter(new Date());
	var preViewObj=$('#preView');
	var winHeight = $(window).height();
	$('#taskList').datagrid({
		bodyCls:'panel-header-gray',
		url:$URL+"?ClassName=BSP.MSG.BL.Task&QueryName=QryMsgTask",
		fit:true,
		border:false,
		idField:'id',
		//id,CreateDT,CreateUserName,Status,LastFireDT,NextFireDT,AlreadyFireTimes,Content,ActionTypeDesc	
		columns:[[
			{title:'创建时间',field:'CreateDT',width:160},
			{title:'任务计划',field:'ScheduleStr',width:250,tipWidth:250,showTip:true,formatter: function(value,row,index){
				return getScheduleText(value);
			}},
			{title:'消息类型',field:'ActionTypeDesc',width:80},
			{title:'消息内容',field:'Content',width:350,formatter: function(value,row,index){
				return "<span class='msgText' data-index='"+index+"'>"+replaceHtml(value)+"</span>";
			}},
			{title:'状态',field:'Status',width:60,formatter:function(value,row,ind){
				return StatusMap[value]||value;
			}},
			{title:'修改或终止时间',field:'UpdateDT',width:160},
			
			{title:'已发送次数',field:'AlreadyFireTimes',width:80},
			{title:'上次触发时间',field:'LastFireDT',width:160},
			{title:'下次触发时间',field:'NextFireDT',width:160},
			{field:'Edit',title:'修改',width:50,align:'center',formatter: function(value,row,index){
				if(row.Status!=="N") return "";
				var str='  <a href="javascript:void(0);" onclick="UpdateTask(\''+row.id+'\' , \''+index+'\')"><img src="../images/uiimages/pencil.png"></a>  ';
				return str;
			}} ,
			{field:'Stop',title:'终止',width:50,align:'center',formatter: function(value,row,index){
				if(row.Status!=="N") return "";
				var str='  <a href="javascript:void(0);" onclick="StopTask(\''+row.id+'\')"><img src="../images/uiimages/undo.png"></a>  ';
				return str;
			}} 
			
			
		]],
		queryParams:{
	        DateFrom: nowDate,
	        DateTo : nowDate, 
	        pCreateUser:session['LOGON.USERID']
		},
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		rownumbers:true,
		striped:true,
		singleSelect:true,
		onLoadSuccess:function(data){
			$('.msgText').hover(
				function(e){
					//var msgHtml=$(this).attr('msg');
					var index=parseInt($(this).data('index'));
					var msgHtml=$('#taskList').datagrid('getRows')[index].Content;
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
	})
	
	
	$('#DateFrom').datebox('setValue',nowDate);
	
	$('#DateTo').datebox('setValue',nowDate);
	
	$('#btnFind').click(function(){
		var DateFrom=$('#DateFrom').datebox('getValue');
		var DateTo=$('#DateTo').datebox('getValue');
		
		$('#taskList').datagrid('load',{
			DateFrom: DateFrom,
	        DateTo : DateTo, 
	        pCreateUser:session['LOGON.USERID']
	    })
	})
	
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
							ClassName:"BSP.MSG.BL.Task",
							MethodName:"UpdateMsgTaskContent",
							id:editingTaskId,
							content:beforeSave(editor.getData()),
							user:session['LOGON.USERID']
							},
							function(data,textStatus){
								if(data>0){
									$.messager.alert('成功','消息内容修改成功!','success',function(){
										$('#mydialog').dialog('close');
										$('#taskList').datagrid('reload');
									});
									
								}else{
									$.messager.alert('失败',data.split('^')[1]||data,'error');
								}
							}
						);
					} 
				});
			}  
		}); 
	})
	
})