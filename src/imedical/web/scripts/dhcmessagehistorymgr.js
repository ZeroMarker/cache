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

//ȥ��html��ǩ
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
		columns:[[{field:'Desc',title:'����',width:200},{field:'Code',title:'����',width:200}]],
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
		columns:[[{field:'Desc',title:'����',width:200},{field:'Code',title:'����',width:200}]],
		pagination:true
	});
	
	$('#ExecFlag').combobox({
		data:[{text:'ȫ��',value:''},{text:'δ����',value:'N'},{text:'�Ѵ���',value:'Y'},{text:'���账��',value:'O'}],
		panelHeight:'auto',editable:false
	})
	$('#SendMode').combobox({
		data:[{id:'',text:'ȫ��'}].concat(SendModeJson),
		valueField:'id',textField:'text',editable:false,panelHeight:'auto'
	})
	
	$('#BizObjId').on('keyup',function(e){
		if(e.keyCode==13){
			$('#FindBtn').click();
		}	
	})
	

	$('#FindBtn').click(function(){
		$('#tDHCMessageContent').datagrid('clearSelections');
		
		$('#tDHCMessageContent').datagrid('unselectAll');    //��ѯʱȡ��ѡ�����
		var datestart=$('#DateStart').datebox('getValue');
		var dateend=$('#DateEnd').datebox('getValue');
		if (dateend==""){                                  //��������Ϊ�գ�ȡ����   
			dateend=now;
			$('#DateEnd').datebox('setValue',dateend);
		}
		if(datestart==""||$.fn.datebox.defaults.parser(datestart)>$.fn.datebox.defaults.parser(dateend)){             //��ʼ����Ϊ�գ����߿�ʼ���ڴ��ڽ�������  ȡ����������һ��
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
			{field:'CActionTypeDesc',title:'��Ϣ����'} ,
			{field:'CText',title:'��Ϣ����',width:500,formatter: function(value,row,index){
				value=replaceHtml(value);
				return value;
			},showTip:true,tipWidth:500,showTipFormatter:function(row,rowIndex){
					return row.CText;
				}
			} ,
			{field:'CSendDate',title:'����ʱ��',width:160,formatter: function(value,row,index){
				return value+" "+row['CSendTime'];
			}} ,
			{field:'CFromUserName',title:'�����û�',width:100} ,
			{field:'CExecFlag',title:'����״̬',width:100,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>�Ѵ���</span>";
				}else if (value=="O"){
					return "<span>���账��</span>";
				}else{
					return "<span>δ����</span>";
				}
				
			}},
			{field:'CExecUser',title:'������',width:50},
			{field:'CExecDateTime',title:'����ʱ��',width:160},
			{field:'CStatus',title:'��ע',width:160,formatter: function(value,row,index){
				if (value=="R") {
					return "������Ϣ�����账��";
				}else if (value=="E"){
					return "ҵ����������";
				}else if (value=="D"){
					return "���˳�Ժ�Զ�����";
				}else if (value=="EP"){
					return "��Ϣ����,�Զ�����";
				}else if (value=="C"){
					return "��Ϣ�ѳ���";
				}else if (value=="F"){
					return "ǿ�ƴ���";
				}else{
					return "";
				}
				
			}},
			{field:'CViewLoc',width:160,title:'�鿴����',formatter: function(value,row,index){
				return "<span title='���û���¼���¿��ҲŻ���ʾ����Ϣ\n"+value+"'>"+value+"</span>";	
			}},
			{field:'CSendMode',width:160,title:'���ͷ�ʽ',formatter:function(value,row,ind){
				var arr=value.split(','),htmlArr=[];
				for (var i=0,len=arr.length;i<len;i++){
					
					htmlArr.push( '<a href="javascript:void(0);" data-ind="'+ind+'" onclick="modeClick(\''+arr[i]+'\',\''+ind+'\')">'+GV.getSendModeDesc(arr[i]) +'</a>' )
					
				}
				return htmlArr.join('&nbsp;&nbsp;');
			}},
			{field:'CReplyFlag',width:80,title:'�ظ���Ϣ',formatter:function(value,row,ind){
				 return value=='Y'?'<a href="javascript:void(0);" data-ind="'+ind+'" onclick="viewReply(\''+row.ContentId+'\')">�鿴�ظ�</a>':'';
			}},
			{field:'ContentId',title:'��ϢID',formatter:function(value,row,ind){
				return '<a href="javascript:void(0);" data-ind="'+ind+'" onclick="viewProps(\''+value+'\')">'+value+'</a>';
			}}
		]],
		onDblClickRow: function (rowIndex, rowData) {  //˫���д�Details��ͬʱ����Content�Ĳ�ѯ���� ����״̬�ͽ����û� ��Ϊ��һ�δ�Details�ĵĲ�ѯ����
			GV.showContentDetail(rowData);
		}
		,toolbar:[{
			text:'����',
			iconCls:'icon-paper-ok',
			handler:function(){
				execContentSelections();
			}	
		},{
			text:'����',
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
			$.messager.popover({msg:'����ѡ��һ������!',type:'alert'});
			return false;
		}
		$.messager.confirm('ȷ��','ȷ��Ҫ������ѡ�е�'+rows.length+'����Ϣ��',function(r){
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
							$.messager.popover({msg:'����ɹ�!',type:'success'});
						}else{
							$.messager.popover({msg:'����ʧ��!'+(data.split('^')[1]||data),type:'error'});
						}
					}
				);
				
			}	
		})
	}
	var cancelContentSelections=function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'����ѡ��һ������!',type:'alert'});
			return false;
		}
		$.messager.confirm('ȷ��','ȷ��Ҫ������ѡ�е�'+rows.length+'����Ϣ��',function(r){
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
							$.messager.popover({msg:'�����ɹ�!',type:'success'});
						}else{
							$.messager.popover({msg:'����ʧ��!'+(data.split('^')[1]||data),type:'error'});
						}
					}
				);
				
			}	
		})
	}
	initContentSearch();
}

var initDetails=function(){
	
	//Detailsҳ�� datagrid
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
			{field:'UserName',title:'�����û�',width:80} ,
			{field:'DReadFlag',title:'�Ķ�״̬',width:80,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>�Ѷ�</span>";
				}else{
					return "<span>δ��</span>";
				}
			}},
			{field:'DReadDateTime',title:'�Ķ�ʱ��',width:160} ,
			{field:'DExecFlag',title:'����״̬',width:80,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>�Ѵ���</span>";
				}else{
					return "<span>δ����</span>";
				}
			}},
			{field:'DExecUser',title:'�����û�',width:80},
			{field:'DExecDateTime',title:'����ʱ��',width:160} ,
			{field:'DNewReplyFlag',title:'�Ƿ����»ظ�',width:80,formatter:function(val){return val=='Y'?'��':'��';}} ,
			{field:'DTargetRole',title:'��ɫ',width:160,formatter:function(val){
				return '<span title="'+val+'">'+val+'</span>'
			}} 
			,{field:'DetailsId',title:'��Ϣ��ϸID',width:80} 
		]]
		,toolbar:[{
				text:'����ѡ��',
				iconCls:'icon-paper-ok',
				handler:function(){
					execDetailsSelections();
				}
			},{
				text:'��������',
				iconCls:'icon-paper-ok',
				handler:function(){
					execDetailsByContent();
				}
			}
		]
	});
	$('#DToUser').combogrid({      //�������ڵ��û�combobox
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
		columns:[[{field:'Desc',title:'����',width:200},{field:'Code',title:'����',width:200}]],
		pagination:true
	});
	
	$('#DExecFlag').combobox({
		data:[{text:'ȫ��',value:''},{text:'δ����',value:'N'},{text:'�Ѵ���',value:'Y'}],
		panelHeight:'auto',editable:false
	})
	
	$('#DNewReplyFlag').combobox({
		data:[{text:'ȫ��',value:''},{text:'���»ظ�',value:'N'},{text:'���»ظ�',value:'Y'}],
		panelHeight:'auto',editable:false
	})
	
	
	$('#DFindBtn').click(function(){
		$('#tDHCMessageDetails').datagrid('clearSelections');    //��ѯʱȡ��ѡ�����
		var dtouser=$('#DToUser').combogrid('getValue');
		var dexecflag=$('#DExecFlag').combobox('getValue');
		var contentid=$('#DetailsContentId').val();
		var dnewreplyflag=$('#DNewReplyFlag').combobox('getValue');
		$('#tDHCMessageDetails').datagrid('load',{ ContentId : contentid, ToUser : dtouser, ExecFlag : dexecflag,NewReplyFlag:dnewreplyflag});
		
	});
	
	///����ѡ����
	var execDetailsSelections=function(){
		var rows=$('#tDHCMessageDetails').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'����ѡ��һ������!',type:'alert'});
			return false;
		}
		$.messager.confirm('ȷ��','ȷ��Ҫ������ѡ�е�'+rows.length+'����Ϣ��ϸ��',function(r){
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
							$.messager.alert('�ɹ�','����ɹ�!');
							$('#DFindBtn').click();
						}else{
							$.messager.alert('�ɹ�','����ʧ��!');
						}
					}
				);
			}
		})
				

		
	}
	
	//Detailsҳ�洦������,ֱ�Ӹ���ContentId����Ӧ�ü���
	var execDetailsByContent=function(){
		
		$.messager.confirm('ȷ��','ȷ��Ҫ����������Ϣ��������ϸ��¼��',function(r){
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
							$.messager.alert('�ɹ�','����ɹ�!');
							$('#DFindBtn').click();
						}else{
							$.messager.alert('�ɹ�','����ʧ��!');
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
//		var contentInfo=rowData.CActionTypeDesc+"&nbsp;&nbsp;&nbsp;&nbsp;"+rowData.CText.split("<br>")[0].substring(0,15)+""+(rowData.CText.length>15 ? "..." :"") +"&nbsp;&nbsp;&nbsp;&nbsp;  "+rowData.CFromUserName+"��"+rowData.CSendDate+"����"
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

		
	//Detailsҳ�� datagrid
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
			{field:'DKeyName',title:'������',width:120} ,
			{field:'DKey',title:'������Ψһֵ',width:120} ,
			{field:'DDate',title:'����ʱ��',width:160,formatter: function(val,row,index){
				return row.DDate+' '+row.DTime;
			}},
			{field:'DIvkDate',title:'����ʱ��',width:160,formatter: function(val,row,index){
				return row.DIvkDate+' '+row.DIvkTime;
			}},
			{field:'DIvkStatus',title:'����״̬',width:200,formatter: function(val,row,index){
				if (val=='1') return '�ɹ�';
				if (val=='0') return 'δ����';
				if (val=='-1') return 'ʧ�ܣ�'+row.DIvkMsg;
			}}
			
			,{field:'id',title:'��ϸID',width:100} 
		]]
	});
	$('#DFindBtn2').click(function(){
		$('#tDHCMessageDetails2').datagrid('clearSelections');    //��ѯʱȡ��ѡ�����
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
//			var contentInfo=rowData.CActionTypeDesc+"&nbsp;&nbsp;&nbsp;&nbsp;"+ctext.split("<br>")[0].substring(0,15)+""+(ctext>15 ? "..." :"") +"&nbsp;&nbsp;&nbsp;&nbsp;  "+rowData.CFromUserName+"��"+rowData.CSendDate+"����"
//			$('#ContentInfo2').html(contentInfo);
//			$('#ContentInfo2').attr('title',ctext)
		})
		$('#mydialog2').dialog('open');
		$('#mydialog2').dialog('setTitle','��ϸ����-'+modeDesc);
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
			{field:'replyUserName',title:'�ظ���',width:120} ,
			{field:'replyDate',title:'�ظ�ʱ��',width:160,formatter: function(val,row,index){
				return row.replyDate+' '+row.replyTime;
			}},
			{field:'replyType',title:'�ظ�����',width:80,formatter: function(val,row,index){
				return val=='A'?'�����':'��������'
			}},
			{field:'replyContent',title:'�ظ�����',width:400}
			
			,{field:'replyId',title:'�ظ���¼ID',width:100} 
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
			{field:'prop',title:'������',width:220} ,
			{field:'val',title:'����ֵ',width:580,formatter:function(val){
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