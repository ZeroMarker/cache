;(function ($) {
	$.fn.combogrid.methods.setRemoteValue=function (jq,param) {
    	return jq.each(function(){
	    	if (typeof param=="string"){
		    	$(this).combogrid('setValue',param);
		    }else{
			    var val=param['value']||'';
			    var text=param['text']||'';
			    $(this).combogrid('options').keyHandler.query.call(this,text);
				$(this).combogrid('setValue',val).combogrid('setText',text);
			}
	    })
    }
})(jQuery);

if(typeof GV=='undefined') var GV={};

//去除html标签
var replaceHtml=function(str){
	 return str.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
}
GV.escapeHTML= function(sHtml) {
        return sHtml.replace(/[<>&"]/g,function(c){return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];});
};





var contentFlag="N";

var initContentSearch=function(){
	var SendModeJson=$.cm({ClassName:'websys.DHCMessageActionTypeMgr',MethodName:'OutSendModeJSON'},false);
	GV.getSendModeDesc=(function(){
		var codeMap={}
		return function	(code){
			if (codeMap[code]) return codeMap[code];
			var ret='';
			$.each(SendModeJson,function(){
				if(this.id==code){
					ret=this.text;
					return false;	
				}
			})
			if (ret=='') {
				ret=code;	
			}
			codeMap[code]=ret;
			return ret;
		}
	})();
	$('#DateEnd').datebox('setValue',now);
	$('#DateStart').datebox('setValue',now);
	
	$('#FindBtn').click(function(){
		$('#tDHCMessageContent').datagrid('clearSelections');
		
		$('#tDHCMessageContent').datagrid('unselectAll');    //查询时取消选择的行
		$('#tb-edit,#tb-cancel,#tb-reply').linkbutton('disable');
		var datestart=$('#DateStart').datebox('getValue');
		var dateend=$('#DateEnd').datebox('getValue');
		if (dateend==""){                                  //结束日期为空，取当天   
			dateend=now;
			$('#DateEnd').datebox('setValue',dateend);
		}
		if(datestart==""||$.fn.datebox.defaults.parser(datestart)>$.fn.datebox.defaults.parser(dateend)){             //开始日期为空，或者开始日期大于结束日期  取结束日期那一天
			datestart=dateend;
			$('#DateStart').datebox('setValue',datestart);
		}
		var touser='';
		var fromuser=GV.SessUserId;
		var actiontype=$('#ActionType').combobox('getValue');
		if (actiontype=='') actiontype=GV.ActionTypeCodes;
		var patname='';
		var execflag='';
		var sendmode='';  //仅支持I模式的 即信息系统发送模式的 
		var bizobjid='';
		
		
		$('#tDHCMessageContent').datagrid('load',{ DateStart : datestart, DateEnd : dateend, ToUser : touser, FromUser : fromuser, PatName : patname, ActionType : actiontype,ExecFlag:execflag,SendMode:sendmode,BizObjId:bizobjid});
		
	});
		
}

var initContent=function(){

	$('#tDHCMessageContent').datagrid({
		queryParams: { DateStart : now, DateEnd : now, ToUser : "", FromUser : GV.SessUserId, PatName : "", ActionType : ""},
		url:$URL+'?ClassName=websys.DHCMessageContentMgr&QueryName=FindByDateIndex',
		idField:'ContentId' ,
		fit:true,
		border:false,
		singleSelect:true,
		pageSize:20,
		rownumbers: true,
		pagination: true,
		pageList: [20,30,50,100,500,1000],  
		striped: true ,			
		columns:[[
			//{ field: 'ck', checkbox: true ,width:50},
			{field:'CActionTypeDesc',title:'消息类型',width:100} ,
			{field:'CText',title:'消息内容',width:500,formatter: function(value,row,index){
				value=replaceHtml(value);
				return value;
			},showTip:true,tipWidth:500,showTipFormatter:function(row,rowIndex){
					return row.CText;
				}
			} ,
			{field:'CSendDate',title:'发送时间',width:160,formatter: function(value,row,index){
				return value+" "+row['CSendTime'];
			}} ,
			{field:'CFromUserName',title:'发送用户',width:100} ,
			{field:'CExecFlag',title:'处理状态',width:100,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>已处理</span>";
				}else if (value=="O"){
					return "<span>无需处理</span>";
				}else{
					return "<span>未处理</span>";
				}
				
			}},
			{field:'CExecUser',title:'处理人',width:50},
			{field:'CExecDateTime',title:'处理时间',width:160},
			{field:'CStatus',title:'备注',width:160,formatter: function(value,row,index){
				if (value=="R") {
					return "独立消息，无需处理";
				}else if (value=="E"){
					return "业务正常处理";
				}else if (value=="D"){
					return "病人出院自动处理";
				}else if (value=="EP"){
					return "消息超期,自动处理";
				}else if (value=="C"){
					return "消息已撤回";
				}else if (value=="F"){
					return "强制处理";
				}else{
					return "";
				}
				
			}}
			,{field:'CSendMode',width:160,title:'发送方式',formatter:function(value,row,ind){
				var arr=value.split(','),htmlArr=[];
				for (var i=0,len=arr.length;i<len;i++){
					
					htmlArr.push( '<a href="javascript:void(0);" data-ind="'+ind+'" onclick="modeClick(\''+arr[i]+'\',\''+ind+'\')">'+GV.getSendModeDesc(arr[i]) +'</a>' )
					
				}
				return htmlArr.join('&nbsp;&nbsp;');
			}}
		]],
		onDblClickRow: function (rowIndex, rowData) {  //双击行打开Details表，同时将在Content的查询条件 处理状态和接收用户 作为第一次打开Details的的查询条件
			GV.showContentDetail(rowData);
		}
		,toolbar:[{
			id:'tb-edit',
			disabled:true,
			text:'修改内容',
			iconCls:'icon-write-order',
			handler:function(){
				updateContentSelections();
			}
		},{
			id:'tb-cancel',
			disabled:true,
			text:'撤销',
			iconCls:'icon-red-cancel-paper',
			handler:function(){
				cancelContentSelections();
			}	
		},{
			id:'tb-reply',
			disabled:true,
			text:'回复',
			iconCls:'icon-send-msg',
			handler:function(){ //回复消息
				replyContentSelections();
			}	
		}]
		,onSelect:function(ind,row){
			var hasSendModeI=false;
			if ((','+row.CSendMode+',').indexOf(',I,')>-1) hasSendModeI=true;
			
			var canUp=false;
			if((row.CStatus=='N'|| row.CStatus=='' ||row.CStatus=='R' )&&(row.CActionTypeCode=='2000'||row.CActionTypeCode=='2008')&&(hasSendModeI)){
				canUp=true;
			}
			if(canUp) { 
				$('#tb-edit,#tb-cancel').linkbutton('enable');
				
			}else{
				$('#tb-edit,#tb-cancel').linkbutton('disable');	
			}
			
			var canReply=false;
			if(hasSendModeI && (row.CStatus!='C')&&(row.CAllowReply!='N')) {
				canReply=true;
			}
			if(canReply){
				$('#tb-reply').linkbutton('enable');
			}else{
				$('#tb-reply').linkbutton('disable');
			}
			
			
		}
	});

	window.modeClick=function(mode,ind){
		
		var rowData=$('#tDHCMessageContent').datagrid('getRows')[ind]
		if (mode=='I') {
			GV.showContentDetail(rowData);
		}else{
			GV.showContentDetail2(rowData,mode)	;
		}
	}
	

	
	///修改消息内容
	var updateContentSelections=function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'至少选择一条数据!',type:'alert'});
			return false;
		}
		var row=rows[0];
		
		GV.openContentEditor(row);
		
		
	}
	var cancelContentSelections=function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'至少选择一条数据!',type:'alert'});
			return false;
		}
		$.messager.confirm('确定','确定要撤销您选中的消息吗？',function(r){
			if(r) {
				var row=rows[0];
				$.m({
					ClassName:"websys.DHCMessageContentMgr",MethodName:"CancelMsg",
					MsgContentId:row.ContentId
					},
					function(data,textStatus){		
						if(data>0){
							$.messager.popover({msg:'撤销成功!',type:'success'});
							$('#tDHCMessageContent').datagrid('reload');
						}else{
							if(data=='0') {
								$.messager.popover({msg:'此消息已有人阅读或处理过，不能撤销',type:'error'});
							}else{
									$.messager.popover({msg:'撤销失败!'+(data.split('^')[1]||data),type:'error'});
							}
						
						}
						
					}
				);
			}	
		})
	}
	
	///回复消息
	var replyContentSelections=function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'请选择一条数据!',type:'alert'});
			return false;
		}
		//
		var row=rows[0];
		easyModal('消息回复','dhc.message.one.csp?MsgContentId='+row.ContentId,850,610);
		
	}
	initContentSearch();
}

var initDetails=function(){
	
	//Details页面 datagrid
	$('#tDHCMessageDetails').datagrid({
		queryParams: { ContentId : "", ToUser : "", ExecFlag : "N",UseType:'CreateUserSearch'},
		url:$URL+'?ClassName=websys.DHCMessageDetailsMgr&QueryName=FindByContent',
		idField:'DetailsId' ,
		border:false,
		fit:true,
		fitColumns:false,
		singleSelect:false,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10,20,30,50,100,200,500,1000],  
		striped: true ,		
		columns:[[
			//{ field: 'ck', checkbox: true },
			{field:'UserName',title:'接收用户',width:80} ,
			{field:'DReadFlag',title:'阅读状态',width:80,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>已读</span>";
				}else{
					return "<span>未读</span>";
				}
			}},
			{field:'DReadDateTime',title:'阅读时间',width:160} ,
			{field:'DExecFlag',title:'处理状态',width:80,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>已处理</span>";
				}else{
					return "<span>未处理</span>";
				}
			}},
			{field:'DExecUser',title:'处理用户',width:80},
			{field:'DExecDateTime',title:'处理时间',width:160} ,
			{field:'DNewReplyFlag',title:'是否有新回复',width:80,formatter:function(val){return val=='Y'?'是':'否';}} //,
//			{field:'DTargetRole',title:'角色',width:160,formatter:function(val){
//				return '<span title="'+val+'">'+val+'</span>'
//			}} 
			//,{field:'DetailsId',title:'消息明细ID',width:80} 
		]]
//		,toolbar:[{
//				text:'处理选中',
//				iconCls:'icon-paper-ok',
//				handler:function(){
//					execDetailsSelections();
//				}
//			},{
//				text:'处理所有',
//				iconCls:'icon-paper-ok',
//				handler:function(){
//					execDetailsByContent();
//				}
//			}
//		]
	});
	$('#DToUser').combogrid({      //弹窗窗口的用户combobox
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.rectype='U'
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Desc',title:'姓名',width:200},{field:'Code',title:'工号',width:200}]],
		pagination:true
	});
	
	$('#DExecFlag').combobox({
		data:[{text:'全部',value:''},{text:'未处理',value:'N'},{text:'已处理',value:'Y'}],
		panelHeight:'auto',editable:false
	})
	
	
	
	$('#DFindBtn').click(function(){
		$('#tDHCMessageDetails').datagrid('clearSelections');    //查询时取消选择的行
		var dtouser=$('#DToUser').combogrid('getValue');
		var dexecflag=$('#DExecFlag').combobox('getValue');
		var contentid=$('#DetailsContentId').val();
		var dnewreplyflag='';//$('#DNewReplyFlag').combobox('getValue');
		$('#tDHCMessageDetails').datagrid('load',{ ContentId : contentid, ToUser : dtouser, ExecFlag : dexecflag,NewReplyFlag:dnewreplyflag,UseType:'CreateUserSearch'});
		
	});
	
	
	$('#DClearBtn').click(function(){
		$('#DExecFlag').combobox('setValue','');
		$('#DToUser').combogrid('setRemoteValue',{value:'',text:''});
		$('#DNewReplyFlag').combobox('setValue','');
		$('#DFindBtn').click();
	})
	function showContentDetail(rowData){
//		var contentInfo=rowData.CActionTypeDesc+"&nbsp;&nbsp;&nbsp;&nbsp;"+rowData.CText.split("<br>")[0].substring(0,15)+""+(rowData.CText.length>15 ? "..." :"") +"&nbsp;&nbsp;&nbsp;&nbsp;  "+rowData.CFromUserName+"于"+rowData.CSendDate+"发送"
//		$('#ContentInfo').html(contentInfo);
//		$('#ContentInfo').attr('title',rowData.CText)
		$('#mydialog').dialog('open').dialog('center');
		$('#DetailsContentId').val(rowData.ContentId);
		
		$('#DExecFlag').combobox('setValue',"");
		$('#DNewReplyFlag').combobox('setValue',"");
		
//		if ($('#ToUser').combogrid('getValue')>0) {
//			$('#DToUser').combogrid('setRemoteValue',{value:$('#ToUser').combogrid('getValue'),text:$('#ToUser').combogrid('getText')})
//		}
		$('#DFindBtn').click();
	}
	GV.showContentDetail=showContentDetail;
	
}

var initDetails2=function(){

		
	//Details页面 datagrid
	$('#tDHCMessageDetails2').datagrid({
		queryParams: { ContentId : "", SendMode : "", q : ""},
		url:$URL+'?ClassName=BSP.MSG.BL.TPSDetails&QueryName=QryDet',
		idField:'id' ,
		border:false,
		fit:true,
		fitColumns:false,
		singleSelect:false,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10,20,30,50,100,200,500,1000],  
		striped: true ,		
		columns:[[
			//{ field: 'ck', checkbox: true,width:50 },
			{field:'DKeyName',title:'接收者',width:120} ,
			{field:'DKey',title:'接收者唯一值',width:120} ,
			{field:'DDate',title:'发送时间',width:160,formatter: function(val,row,index){
				return row.DDate+' '+row.DTime;
			}},
			{field:'DIvkDate',title:'调用时间',width:160,formatter: function(val,row,index){
				return row.DIvkDate+' '+row.DIvkTime;
			}},
			{field:'DIvkStatus',title:'调用状态',width:200,formatter: function(val,row,index){
				if (val=='1') return '成功';
				if (val=='0') return '未调用';
				if (val=='-1') return '失败：'+row.DIvkMsg;
			}}
			
			//	,{field:'id',title:'明细ID',width:100} 
		]]
	});
	$('#DFindBtn2').click(function(){
		$('#tDHCMessageDetails2').datagrid('clearSelections');    //查询时取消选择的行
		var q=$('#DKeyName').val();
		var id2=$('#DetailsContentId2').val();
		var contentid=id2.split('^')[0],sendMode=id2.split('^')[1]
		$('#tDHCMessageDetails2').datagrid('load',{ ContentId : contentid, SendMode : sendMode, q : q});
		
	});
	function showContentDetail2(rowData,sendMode){
		var modeDesc=GV.getSendModeDesc(sendMode);
		$.m({ClassName:'BSP.MSG.BL.TPSContent',MethodName:'GetContext',ContentId:rowData.ContentId,SendMode:sendMode},function(ctext){
			
			$('#tpscontent').text(ctext);
			$('#tpscontent').attr('title',ctext)
//			var contentInfo=rowData.CActionTypeDesc+"&nbsp;&nbsp;&nbsp;&nbsp;"+ctext.split("<br>")[0].substring(0,15)+""+(ctext>15 ? "..." :"") +"&nbsp;&nbsp;&nbsp;&nbsp;  "+rowData.CFromUserName+"于"+rowData.CSendDate+"发送"
//			$('#ContentInfo2').html(contentInfo);
//			$('#ContentInfo2').attr('title',ctext)
		})
		$('#mydialog2').dialog('open');
		$('#mydialog2').dialog('setTitle','明细管理-'+modeDesc);
		$('#DetailsContentId2').val(rowData.ContentId+'^'+sendMode);
		$('#DKeyName').val('');
		$('#DFindBtn2').click();
	}
	GV.showContentDetail2=showContentDetail2;
	$('#DKeyName').on('keyup',function(e){
		if(e.keyCode=='13'){
			$('#DFindBtn2').click();
		}	
	})
}

var initContentEditor=function(){
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

	var editingContentId=-1;
	var editor=CKEDITOR.replace( 'editor1' ,{
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
									$('#mydialog-editor').dialog('close');
									$.messager.popover({msg:'修改成功!',type:'success'});
									$('#tDHCMessageContent').datagrid('reload');
								}else{
									$.messager.popover({msg:'修改失败!'+(data.split('^')[1]||data),type:'error'});
								}
							}
						);
					} 
				});
			}  
		}); 
	})
	
	
	
	GV.openContentEditor=function(row){
		var msgHtml=row.CText;
		editor.setData(beforeSetData(msgHtml),{
			callback: function(){
				this.checkDirty();
			}
		});	
		$.ajaxRunServerMethod({
			ClassName:"websys.DHCMessageContentMgr",MethodName:"IsAbleToChange",
			MsgContentId:row.ContentId
			},
			function(data,textStatus){		
				if(data>0){
					editingContentId=row.ContentId;
					$('#mydialog-editor').dialog('open');
				}else{
					$.messager.popover({msg:'此消息已有人阅读或处理过，不能修改内容',type:'error'});
				}			
			}
		);
	}
}

$(function(){
	initContent();
	initDetails();
	initDetails2();
	initContentEditor();

})