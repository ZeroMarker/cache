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

var GV={};

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
	
	$('#FromUser').combogrid({
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
	$('#ToUser').combogrid({
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
	
	$('#ExecFlag').combobox({
		data:[{text:'全部',value:''},{text:'未处理',value:'N'},{text:'已处理',value:'Y'},{text:'无需处理',value:'O'}],
		panelHeight:'auto',editable:false
	})
	$('#SendMode').combobox({
		data:[{id:'',text:'全部'}].concat(SendModeJson),
		valueField:'id',textField:'text',editable:false,panelHeight:'auto'
	})
	
	$('#BizObjId').on('keyup',function(e){
		if(e.keyCode==13){
			$('#FindBtn').click();
		}	
	})
	

	$('#FindBtn').click(function(){
		$('#tDHCMessageContent').datagrid('clearSelections');
		
		$('#tDHCMessageContent').datagrid('unselectAll');    //查询时取消选择的行
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
		var touser=$('#ToUser').combogrid('getValue');
		var fromuser=$('#FromUser').combogrid('getValue');
		var actiontype=$('#ActionType').combobox('getValue');
		var patname=$('#PatName').val();
		var execflag=$('#ExecFlag').combobox('getValue');
		var sendmode=$('#SendMode').combobox('getValue');
		var bizobjid=$.trim( $('#BizObjId').val());
		
		
		$('#tDHCMessageContent').datagrid('load',{ DateStart : datestart, DateEnd : dateend, ToUser : touser, FromUser : fromuser, PatName : patname, ActionType : actiontype,ExecFlag:execflag,SendMode:sendmode,BizObjId:bizobjid});
		
	});
	
	
	$('#ClearBtn').click(function(){
		$('#ToUser').combogrid('clear').combogrid('setRemoteValue',{value:'',text:''});
		$('#FromUser').combogrid('clear').combogrid('setRemoteValue',{value:'',text:''});
		$('#DateEnd').datebox('setValue',now);
		$('#DateStart').datebox('setValue',now);
		$('#ActionType').combobox('setValue','');
		$('#ExecFlag').combobox('setValue','');
		$('#SendMode').combobox('setValue','');
		$('#PatName').val("");
		$('#BizObjId').val('');
		$('#FindBtn').click();
	})
	
}

var initContent=function(){

	$('#tDHCMessageContent').datagrid({
		queryParams: { DateStart : now, DateEnd : now, ToUser : "", FromUser : "", PatName : "", ActionType : ""},
		url:$URL+'?ClassName=websys.DHCMessageContentMgr&QueryName=FindByDateIndex',
		idField:'ContentId' ,
		fit:true,
		border:false,
		singleSelect:false,
		pageSize:20,
		rownumbers: true,
		pagination: true,
		pageList: [20,30,50,100,500,1000],  
		striped: true ,			
		columns:[[
			{ field: 'ck', checkbox: true ,width:50},
			{field:'CActionTypeDesc',title:'消息类型'} ,
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
				
			}},
			{field:'CViewLoc',width:160,title:'查看科室',formatter: function(value,row,index){
				return "<span title='当用户登录以下科室才会提示此消息\n"+value+"'>"+value+"</span>";	
			}},
			{field:'CSendMode',width:160,title:'发送方式',formatter:function(value,row,ind){
				var arr=value.split(','),htmlArr=[];
				for (var i=0,len=arr.length;i<len;i++){
					
					htmlArr.push( '<a href="javascript:void(0);" data-ind="'+ind+'" onclick="modeClick(\''+arr[i]+'\',\''+ind+'\')">'+GV.getSendModeDesc(arr[i]) +'</a>' )
					
				}
				return htmlArr.join('&nbsp;&nbsp;');
			}},
			{field:'CReplyFlag',width:80,title:'回复信息',formatter:function(value,row,ind){
				 return value=='Y'?'<a href="javascript:void(0);" data-ind="'+ind+'" onclick="viewReply(\''+row.ContentId+'\')">查看回复</a>':'';
			}},
			{field:'ContentId',title:'消息ID',formatter:function(value,row,ind){
				return '<a href="javascript:void(0);" data-ind="'+ind+'" onclick="viewProps(\''+value+'\')">'+value+'</a>';
			}}
		]],
		onDblClickRow: function (rowIndex, rowData) {  //双击行打开Details表，同时将在Content的查询条件 处理状态和接收用户 作为第一次打开Details的的查询条件
			GV.showContentDetail(rowData);
		}
		,toolbar:[{
			text:'处理',
			iconCls:'icon-paper-ok',
			handler:function(){
				execContentSelections();
			}	
		},{
			text:'撤销',
			iconCls:'icon-red-cancel-paper',
			handler:function(){
				cancelContentSelections();
			}	
		}]
	});

	window.modeClick=function(mode,ind){
		
		var rowData=$('#tDHCMessageContent').datagrid('getRows')[ind]
		if (mode=='I') {
			GV.showContentDetail(rowData);
		}else{
			GV.showContentDetail2(rowData,mode)	;
		}
	}
	
	window.viewReply=function(ContentId){
		GV.showContentReply(ContentId);
	}
	window.viewProps=function(ContentId){
		GV.showContentProps(ContentId);
	}
	
	var execContentSelections=function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'至少选择一条数据!',type:'alert'});
			return false;
		}
		$.messager.confirm('确定','确定要处理您选中的'+rows.length+'条消息吗？',function(r){
			if(r) {
				var ContentIds=[];
				for (var i=0;i<rows.length;i++) {
					ContentIds.push(rows[i].ContentId);
				}
				var ContentIdsStr=ContentIds.join("^");
				$.ajaxRunServerMethod({
					ClassName:"websys.DHCMessageInterface",
					MethodName:"ExecAllByContentIds",
					ContentIds:ContentIdsStr
					,FixReplyFlag:1
					},
					function(data,textStatus){
						if(data>0){
							$('#FindBtn').click();
							$.messager.popover({msg:'处理成功!',type:'success'});
						}else{
							$.messager.popover({msg:'处理失败!'+(data.split('^')[1]||data),type:'error'});
						}
					}
				);
				
			}	
		})
	}
	var cancelContentSelections=function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'至少选择一条数据!',type:'alert'});
			return false;
		}
		$.messager.confirm('确定','确定要撤销您选中的'+rows.length+'条消息吗？',function(r){
			if(r) {
				var ContentIds=[];
				for (var i=0;i<rows.length;i++) {
					ContentIds.push(rows[i].ContentId);
				}
				var ContentIdsStr=ContentIds.join("^");
				$.ajaxRunServerMethod({
					ClassName:"websys.DHCMessageInterface",
					MethodName:"ForceCancelByContentIds",
					ContentIds:ContentIdsStr
					,FixReplyFlag:1
					},
					function(data,textStatus){
						if(data>0){
							$('#FindBtn').click();
							$.messager.popover({msg:'撤销成功!',type:'success'});
						}else{
							$.messager.popover({msg:'撤销失败!'+(data.split('^')[1]||data),type:'error'});
						}
					}
				);
				
			}	
		})
	}
	initContentSearch();
}

var initDetails=function(){
	
	//Details页面 datagrid
	$('#tDHCMessageDetails').datagrid({
		queryParams: { ContentId : "", ToUser : "", ExecFlag : "N"},
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
			{ field: 'ck', checkbox: true },
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
			{field:'DNewReplyFlag',title:'是否有新回复',width:80,formatter:function(val){return val=='Y'?'是':'否';}} ,
			{field:'DTargetRole',title:'角色',width:160,formatter:function(val){
				return '<span title="'+val+'">'+val+'</span>'
			}} 
			,{field:'DetailsId',title:'消息明细ID',width:80} 
		]]
		,toolbar:[{
				text:'处理选中',
				iconCls:'icon-paper-ok',
				handler:function(){
					execDetailsSelections();
				}
			},{
				text:'处理所有',
				iconCls:'icon-paper-ok',
				handler:function(){
					execDetailsByContent();
				}
			}
		]
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
	
	$('#DNewReplyFlag').combobox({
		data:[{text:'全部',value:''},{text:'无新回复',value:'N'},{text:'有新回复',value:'Y'}],
		panelHeight:'auto',editable:false
	})
	
	
	$('#DFindBtn').click(function(){
		$('#tDHCMessageDetails').datagrid('clearSelections');    //查询时取消选择的行
		var dtouser=$('#DToUser').combogrid('getValue');
		var dexecflag=$('#DExecFlag').combobox('getValue');
		var contentid=$('#DetailsContentId').val();
		var dnewreplyflag=$('#DNewReplyFlag').combobox('getValue');
		$('#tDHCMessageDetails').datagrid('load',{ ContentId : contentid, ToUser : dtouser, ExecFlag : dexecflag,NewReplyFlag:dnewreplyflag});
		
	});
	
	///处理选中行
	var execDetailsSelections=function(){
		var rows=$('#tDHCMessageDetails').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'至少选择一条数据!',type:'alert'});
			return false;
		}
		$.messager.confirm('确定','确定要处理您选中的'+rows.length+'条消息明细吗？',function(r){
			if(r) {
				var DetailsIds=[];
				for (var i=0;i<rows.length;i++) {
					DetailsIds.push(rows[i].DetailsId);
				}
				var DetailsIdsStr=DetailsIds.join("^");
				$.ajaxRunServerMethod({
					ClassName:"websys.DHCMessageInterface",
					MethodName:"ExecOneByDetailsIds",
					DetailsIds:DetailsIdsStr
					,FixReplyFlag:1
					},
					function(data,textStatus){
						if(data>0){
							$.messager.alert('成功','处理成功!');
							$('#DFindBtn').click();
						}else{
							$.messager.alert('成功','处理失败!');
						}
					}
				);
			}
		})
				

		
	}
	
	//Details页面处理所有,直接根据ContentId处理应该即可
	var execDetailsByContent=function(){
		
		$.messager.confirm('确定','确定要处理这条消息的所有明细记录吗？',function(r){
			if(r) {
				var contentid=$('#DetailsContentId').val();
				
				$.ajaxRunServerMethod({
					ClassName:"websys.DHCMessageInterface",
					MethodName:"ExecAllByContentIds",
					ContentIds:contentid
					,FixReplyFlag:1
					},
					function(data,textStatus){
						if(data>0){
							$.messager.alert('成功','处理成功!');
							$('#DFindBtn').click();
						}else{
							$.messager.alert('成功','处理失败!');
						}
					}
				);
			}
		})
		

		
	}
	
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
		
		if ($('#ToUser').combogrid('getValue')>0) {
			$('#DToUser').combogrid('setRemoteValue',{value:$('#ToUser').combogrid('getValue'),text:$('#ToUser').combogrid('getText')})
		}
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
			{ field: 'ck', checkbox: true,width:50 },
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
			
			,{field:'id',title:'明细ID',width:100} 
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



var initReply=function(){
	$('#tDHCMessageReply').datagrid({
		queryParams: { ContentId : ""},
		url:$URL+'?ClassName=websys.DHCMessageInterface&QueryName=QryReplyList',
		idField:'replyId' ,
		border:false,
		fit:true,
		fitColumns:false,
		singleSelect:false,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10,20,30,50,100,200,500,1000],  
		striped: true ,		
		///replyUserName,replyDate,replyTime,replyContent,replyType,isSendUser,replyId,replyUserId")
		columns:[[
			{ field: 'ck', checkbox: true,width:50 },
			{field:'replyUserName',title:'回复人',width:120} ,
			{field:'replyDate',title:'回复时间',width:160,formatter: function(val,row,index){
				return row.replyDate+' '+row.replyTime;
			}},
			{field:'replyType',title:'回复类型',width:80,formatter: function(val,row,index){
				return val=='A'?'相关人':'仅接收人'
			}},
			{field:'replyContent',title:'回复内容',width:400}
			
			,{field:'replyId',title:'回复记录ID',width:100} 
		]]
	});
	
	

	function showContentReply(ContentId){
		$('#mydialog-reply').dialog('open');
		$('#tDHCMessageReply').datagrid('clearSelections');
		$('#tDHCMessageReply').datagrid('load',{ContentId:ContentId})
	}
	GV.showContentReply=showContentReply;

}


var initProps=function(){
	$('#tDHCMessageContentProps').datagrid({
		queryParams: { ContentId : ""},
		url:$URL+'?ClassName=websys.DHCMessageContentMgr&QueryName=GetContentProps',
		idField:'replyId' ,
		border:false,
		fit:true,
		fitColumns:false,
		singleSelect:false,
		pageSize:1000,
		rownumbers: true,
		pagination: false,
		pageList: [1000],  
		striped: true ,		
		nowrap:false,
		///replyUserName,replyDate,replyTime,replyContent,replyType,isSendUser,replyId,replyUserId")
		columns:[[
			{field:'prop',title:'属性名',width:220} ,
			{field:'val',title:'属性值',width:580,formatter:function(val){
				return GV.escapeHTML(val||'');	
			}} 
		]]
	});
	
	

	function showContentProps(ContentId){
		$('#mydialog-props').dialog('open');
		$('#tDHCMessageContentProps').datagrid('loadData',[]);
		
		$m({ClassName:'websys.DHCMessageContentMgr',MethodName:'GetContentProps',ContentId:ContentId},function(ret){
			var obj=$.parseJSON(ret);
			
			var arr=[]
			for(var key in obj) {
				arr.push({prop:key,val:""+obj[key]})	
				
			}
			
			$('#tDHCMessageContentProps').datagrid('loadData',arr);
			
			
		})
		
	}
	GV.showContentProps=showContentProps;

}

$(function(){
	initContent();
	initDetails();
	initDetails2();
	initReply();
	initProps();

})