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
	
	$('#FindBtn').click(function(){
		$('#tDHCMessageContent').datagrid('clearSelections');
		
		$('#tDHCMessageContent').datagrid('unselectAll');    //��ѯʱȡ��ѡ�����
		$('#tb-edit,#tb-cancel,#tb-reply').linkbutton('disable');
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
		var touser='';
		var fromuser=GV.SessUserId;
		var actiontype=$('#ActionType').combobox('getValue');
		if (actiontype=='') actiontype=GV.ActionTypeCodes;
		var patname='';
		var execflag='';
		var sendmode='';  //��֧��Iģʽ�� ����Ϣϵͳ����ģʽ�� 
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
			{field:'CActionTypeDesc',title:'��Ϣ����',width:100} ,
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
				
			}}
			,{field:'CSendMode',width:160,title:'���ͷ�ʽ',formatter:function(value,row,ind){
				var arr=value.split(','),htmlArr=[];
				for (var i=0,len=arr.length;i<len;i++){
					
					htmlArr.push( '<a href="javascript:void(0);" data-ind="'+ind+'" onclick="modeClick(\''+arr[i]+'\',\''+ind+'\')">'+GV.getSendModeDesc(arr[i]) +'</a>' )
					
				}
				return htmlArr.join('&nbsp;&nbsp;');
			}}
		]],
		onDblClickRow: function (rowIndex, rowData) {  //˫���д�Details��ͬʱ����Content�Ĳ�ѯ���� ����״̬�ͽ����û� ��Ϊ��һ�δ�Details�ĵĲ�ѯ����
			GV.showContentDetail(rowData);
		}
		,toolbar:[{
			id:'tb-edit',
			disabled:true,
			text:'�޸�����',
			iconCls:'icon-write-order',
			handler:function(){
				updateContentSelections();
			}
		},{
			id:'tb-cancel',
			disabled:true,
			text:'����',
			iconCls:'icon-red-cancel-paper',
			handler:function(){
				cancelContentSelections();
			}	
		},{
			id:'tb-reply',
			disabled:true,
			text:'�ظ�',
			iconCls:'icon-send-msg',
			handler:function(){ //�ظ���Ϣ
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
	

	
	///�޸���Ϣ����
	var updateContentSelections=function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'����ѡ��һ������!',type:'alert'});
			return false;
		}
		var row=rows[0];
		
		GV.openContentEditor(row);
		
		
	}
	var cancelContentSelections=function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'����ѡ��һ������!',type:'alert'});
			return false;
		}
		$.messager.confirm('ȷ��','ȷ��Ҫ������ѡ�е���Ϣ��',function(r){
			if(r) {
				var row=rows[0];
				$.m({
					ClassName:"websys.DHCMessageContentMgr",MethodName:"CancelMsg",
					MsgContentId:row.ContentId
					},
					function(data,textStatus){		
						if(data>0){
							$.messager.popover({msg:'�����ɹ�!',type:'success'});
							$('#tDHCMessageContent').datagrid('reload');
						}else{
							if(data=='0') {
								$.messager.popover({msg:'����Ϣ�������Ķ�����������ܳ���',type:'error'});
							}else{
									$.messager.popover({msg:'����ʧ��!'+(data.split('^')[1]||data),type:'error'});
							}
						
						}
						
					}
				);
			}	
		})
	}
	
	///�ظ���Ϣ
	var replyContentSelections=function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.popover({msg:'��ѡ��һ������!',type:'alert'});
			return false;
		}
		//
		var row=rows[0];
		easyModal('��Ϣ�ظ�','dhc.message.one.csp?MsgContentId='+row.ContentId,850,610);
		
	}
	initContentSearch();
}

var initDetails=function(){
	
	//Detailsҳ�� datagrid
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
			{field:'DNewReplyFlag',title:'�Ƿ����»ظ�',width:80,formatter:function(val){return val=='Y'?'��':'��';}} //,
//			{field:'DTargetRole',title:'��ɫ',width:160,formatter:function(val){
//				return '<span title="'+val+'">'+val+'</span>'
//			}} 
			//,{field:'DetailsId',title:'��Ϣ��ϸID',width:80} 
		]]
//		,toolbar:[{
//				text:'����ѡ��',
//				iconCls:'icon-paper-ok',
//				handler:function(){
//					execDetailsSelections();
//				}
//			},{
//				text:'��������',
//				iconCls:'icon-paper-ok',
//				handler:function(){
//					execDetailsByContent();
//				}
//			}
//		]
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
	
	
	
	$('#DFindBtn').click(function(){
		$('#tDHCMessageDetails').datagrid('clearSelections');    //��ѯʱȡ��ѡ�����
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
//		var contentInfo=rowData.CActionTypeDesc+"&nbsp;&nbsp;&nbsp;&nbsp;"+rowData.CText.split("<br>")[0].substring(0,15)+""+(rowData.CText.length>15 ? "..." :"") +"&nbsp;&nbsp;&nbsp;&nbsp;  "+rowData.CFromUserName+"��"+rowData.CSendDate+"����"
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
			//{ field: 'ck', checkbox: true,width:50 },
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
			
			//	,{field:'id',title:'��ϸID',width:100} 
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
				$.messager.confirm('��ʾ��Ϣ' , "ȷ���޸���Ϣ����ô" , function(r){
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
									$.messager.popover({msg:'�޸ĳɹ�!',type:'success'});
									$('#tDHCMessageContent').datagrid('reload');
								}else{
									$.messager.popover({msg:'�޸�ʧ��!'+(data.split('^')[1]||data),type:'error'});
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
					$.messager.popover({msg:'����Ϣ�������Ķ�������������޸�����',type:'error'});
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