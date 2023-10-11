var GV={DIC:{}};
var init=function(){
	var dgSelectOnChange=function(){
		var rows=dg.datagrid('getSelections');
		if(rows && rows.length>0 && rows[0].TEventAuditFlag=='N'){
			$('#t-tb-audit').linkbutton('enable');
		}else{
			$('#t-tb-audit').linkbutton('disable');
		}
	}
	var debounced_dgSelectOnChange=SMP_COMM.debounce(dgSelectOnChange,200);
	var dgButtons=[{
			text:'���',
			id:'t-tb-audit',
			iconCls:'icon-select-grant'	,
			handler:function(){
				showAuditWin();	
			}
	}]
	if (window.SYS_OUT && SYS_OUT.isDevMode=='1') {
		dgButtons.push({
			text:'����',
			id:'t-tb-export',
			iconCls:'icon-excel'	,
			handler:function(){
				var title = $('#EventType').combobox('getText')+'�¼�����' + (new Date()).format('-yyyyMMdd-HHmmss');
				var m = $.messager.prompt('����', '������excel�ļ�����', function (r) {
					if (r) {
						$.messager.progress({ //��xlsx����ʱһ��ܿ죬����һ������    ��MSExcel,�����̣���������û��
							title: '���ڵ���',
							msg: '���ڵ�������,���Ժ�...'
						});
						grid2excel($('#t'), {
							IE11IsLowIE: false,
							filename: r,
							allPage: true,
							showHidden:true,
							callback: function (success, data) {
								if (success) {
									SMP_COMM.alert('�ɹ�', '�����ɹ� ' + (data || ''), 'success');

								} else {
									SMP_COMM.alert('ʧ��', '����ʧ�� ' + (data || ''), 'error');
								}
								$.messager.progress('close');
							}
						});


					} else {
						SMP_COMM.alert('��ʾ', '��ѡ����ȡ�����ļ���Ϊ��', 'alert');
					}
				}).find('.messager-input').val(title); //����Ĭ��excel��
			}
	})
	}
	var dg=$('#t').datagrid({
		url:$URL,
		fit:true,
		queryParams:{
			ClassName:'BSP.SMP.BL.Event',
			QueryName:'Find'
		},
		singleSelect:false,
		pagination:true,
		idField:'TId',
		rownumbers:true,
		bodyCls:'panel-header-gray',
		fitColumns:true,
		nowrap:false,
		pageList:[10,30,50,100,200,500,1000],
		//TId,TEventDay,TEventTiming,TEventSrcDataRef,TEventType,TEventTypeDesc,TEventSummary,TEventCollectDay,TEventCollectTiming,
		//TEventAuditDr,TEventAuditFlag,TAuditDay,TAuditTiming,TAuditUser,TAuditResult,TAuditResultDesc,TAuditNote,TAuditExecNote
		columns:[[
			{field:'ck',checkbox:true,width:50},
			{field:'TEventDay',title:'�¼�����ʱ��',width:160,formatter:function(val,row){return val+' '+row['TEventTiming'];}},
			{field:'TEventTypeDesc',title:'�¼�����',width:160},
			{field:'TEventSummary',title:'�¼���������',width:400,formatter:function(val,row){
				if (row.TSameCount>1) {
					return val+'<span class="badge" style="background-color:red;position:absolute;">'+row.TSameCount+'</span>'
				}else{
					return val;	
				}
			}},
			{field:'TAuditResultDesc',title:'��˽��',width:80},
			{field:'TAuditUser',title:'�����',width:80},
			{field:'TAuditDay',title:'���ʱ��',width:160,formatter:function(val,row){return val+' '+row['TAuditTiming'];}},
			{field:'TAuditNote',title:'��˱�ע',width:160},
			{field:'TAuditExecNote',title:'���ñ�ע',width:160}
			,{field:'TEventDatabase',title:'���ݿ�',width:0,hidden:true}
			,{field:'TEventGlobalName',title:'Global',width:0,hidden:true}
		]],toolbar:dgButtons,
		onLoadSuccess:function(){
			debounced_dgSelectOnChange();
		},onSelect:debounced_dgSelectOnChange
		,onUnselect:debounced_dgSelectOnChange
		,onSelectAll:debounced_dgSelectOnChange
		,onUnselectAll:debounced_dgSelectOnChange
	})
	
	var showAuditWin=function(){
		var rows=dg.datagrid('getSelections');
		if (rows && rows.length>0){
			var $aduitWin=$('#audit-win');
			if ($aduitWin.length==0){
				$aduitWin=$('<div id="audit-win" style="padding:10px 10px 0 10px;"><table class="form-table" style="width:100%;">\
							<tr><td class="r-label">��˽��</td><td><input id="AuditResult" class="textbox" style="width:200px;" /></td></tr>\
							<tr><td class="r-label">��˱�ע</td><td><textarea id="AuditNote" class="textbox" style="width:200px;"></textarea></td></tr>\
							<tr id="AuditExecMth-tr"><td class="r-label">���÷�ʽ</td><td><input id="AuditExecMth" class="textbox" style="width:200px;" /></td></tr>\
							<tr id="GlobalType-tr"><td class="r-label">Global����</td><td><input id="GlobalType" class="textbox" style="width:200px;" /></td></tr>\
							<tr id="PRDGroup-tr"><td class="r-label">��Ʒ��</td><td><input id="PRDGroup" class="textbox" style="width:200px;" /></td></tr>\
							<tr><td class="r-label">���ñ�ע</td><td><textarea id="AuditExecNote" class="textbox" style="width:200px;"></textarea></tr>\
							</table></div>').appendTo('body');
				$aduitWin.dialog({
					title:'���',
					modal:true,
					iconCls:'icon-w-paper',
					width:400,
					height:400,
					buttons:[{text:'����',handler:function(){
						//alert(rows.length);
						var AuditResult=$('#AuditResult').combobox('getValue');
						if (!AuditResult) {
							SMP_COMM.alert('��ʾ','��ѡ����˽��','error');
							return;
						}
						
						var arr=[];
						$.each(rows,function(){
							arr.push(this.TId);
						})	
						var idStr=arr.join(',');
						
						var AuditExecMth='';
						var EventType=$('#EventType').combobox('getValue');
						if (EventType=='UnexpectedGlobal'){ //�ǰ�����Global
						
							var AuditExecMth=$('#AuditExecMth').combobox('getValue');
							if(!AuditExecMth) {
								SMP_COMM.alert('��ʾ','��ѡ���÷�ʽ','error');
								return;
							}
							
							var PRDGroup='',GlobalType=''
							if (AuditExecMth=='AddToWhite') {
								PRDGroup=$('#PRDGroup').combobox('getValue');
								GlobalType=	$('#GlobalType').combobox('getValue');
								if (!GlobalType) {
									SMP_COMM.alert('��ʾ','��ѡ��Global����','error');
									return;
								}
							}
							
							
							$.m({ClassName:'BSP.SMP.BL.EventAudit',MethodName:'BeforeAudit',
								EventIds:idStr,
								ExecMth:AuditExecMth
							},function(ret){
								var retArr=ret.split('$$$');
								var tipMsg=retArr[1].split('^').join('<br>');
								$.messager.confirm('ȷ��','<div style="max-height:400px;">'+tipMsg+'</div>',function(r){
									if(r){
										$.m({ClassName:'BSP.SMP.BL.EventAudit',MethodName:'Audit',
											EventIds:idStr,
											AuditResult:AuditResult,
											AuditNote:$('#AuditNote').val(),
											AuditExecNote:$('#AuditExecNote').val()
											,AuditExecMth:AuditExecMth
											,OtherInfo:GlobalType+'^'+PRDGroup
										},function(ret){
											if(ret>0) {
												SMP_COMM.alert('��ʾ','����ɹ�','success');
												$aduitWin.dialog('close');
												dg.datagrid('reload');
												dg.datagrid('clearSelections'); //��ѯǰ ���ѡ����
											}else{
												SMP_COMM.alert('��ʾ','����ʧ��'+ret.split('^')[1]||ret,'error');
											}
										})
										
									}else{
										
									}
								})
								
							})
							
							
						}else{ //��ͨ��ֱ�ӱ�����˼�¼

							
							$.m({ClassName:'BSP.SMP.BL.EventAudit',MethodName:'Audit',
								EventIds:idStr,
								AuditResult:AuditResult,
								AuditNote:$('#AuditNote').val(),
								AuditExecNote:$('#AuditExecNote').val()
							},function(ret){
								if(ret>0) {
									SMP_COMM.alert('��ʾ','����ɹ�','success');
									$aduitWin.dialog('close');
									dg.datagrid('reload');
									dg.datagrid('clearSelections'); //��ѯǰ ���ѡ����
								}else{
									SMP_COMM.alert('��ʾ','����ʧ��'+ret.split('^')[1]||ret,'error');
								}
							})
							
						}


						
						
						
					}},{text:'�ر�',handler:function(){
						$aduitWin.dialog('close');
					}}],
					onClose:function(){
						$('#AuditResult,#AuditExecMth,#PRDGroup,#GlobalType').combobox('setValue','');
						$('#AuditNote,#AuditExecNote').val('');
					}
				}).dialog('open').dialog('center');
				$('#AuditResult').combobox({
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
						param.ResultSetType='array';
						param.rows=9999;
						param.ClassName='CT.BSP.SMP.Comm';
						param.QueryName='Find';
						param.q='';
						param.Type='EventAuditResult';
						param.IsPar=0;
						param.Active=1;

					}
					,editable:false
					,valueField:'TCode'
					,textField:'TDescription'
					,width:200
					,required:true
					,panelHeight:'auto'
				})
				$('#AuditExecMth').combobox({
					data:[{text:'��ӵ�������',value:'AddToWhite'},{text:'��ӵ�������',value:'AddToBlack'},{text:'��ӵ�������',value:'AddToGray'}]
					,width:200
					,required:true
					,panelHeight:'auto'
					,onChange:function(){
						setTimeout(function(){
							$('#AuditExecNote').val( $('#AuditExecMth').combobox('getText') );
							if ($('#AuditExecMth').combobox('getValue')=='AddToWhite') {
								$('#PRDGroup,#GlobalType').combobox('enable');
							}else{
								$('#PRDGroup,#GlobalType').combobox('disable');
							}
							
							
						},200)
						
					}
				})
				
				$('#PRDGroup').combobox({
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
						param.ResultSetType='array';
						param.rows=9999;
						param.ClassName='CT.BSP.SMP.Comm';
						param.QueryName='Find';
						param.q='';
						param.Type='PRDGroup';
						param.IsPar=0;
						param.Active=1;

					}
					,editable:false
					,valueField:'TCode'
					,textField:'TDescription'
					,width:200
					,required:false
					,panelHeight:'150'
				})
				
				$('#GlobalType').combobox({
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
						param.ResultSetType='array';
						param.rows=9999;
						param.ClassName='CT.BSP.SMP.Comm';
						param.QueryName='Find';
						param.q='';
						param.Type='GlobalType';
						param.IsPar=0;
						param.Active=1;

					}
					,editable:false
					,valueField:'TCode'
					,textField:'TDescription'
					,width:200
					,required:true
					,panelHeight:'auto'
				})
				
				$('#AuditNote,#AuditExecNote').outerWidth(200);
			}else{
				$aduitWin.dialog('open').dialog('center');
			}
			
			//��ȡ��ǰѡ����¼�����
			var EventType=$('#EventType').combobox('getValue');
			if (EventType=='UnexpectedGlobal'){
				$('#AuditExecMth-tr,#PRDGroup-tr,#GlobalType-tr').show();
			}else{
				$('#AuditExecMth-tr,#PRDGroup-tr,#GlobalType-tr').hide();
			}
			
			

		}else{
			SMP_COMM.alert('��ʾ','��ѡ��������','alert');
		}
	}
	
	var findEventList=function(){
		var EventType=$('#EventType').combobox('getValue');
		var AuditFlag=$('#AuditFlagY').radio('getValue')?'Y':'N';
		var DateStart=$('#EventDateStart').datebox('getValue');
		var DateEnd=$('#EventDateEnd').datebox('getValue');
		var Database=$('#EventDatabase').combobox('getValue');
		
		var newQueryParams={
			ClassName:'BSP.SMP.BL.Event',
			QueryName:'Find',
			EventType:EventType,
			AuditFlag:AuditFlag,
			DateStart:DateStart,
			DateEnd:DateEnd
			,EventDatabase:Database
		}
		dg.datagrid('clearSelections'); //��ѯǰ ���ѡ����
		var opts=dg.datagrid('options');
		var oldQueryParams=opts.queryParams;
		if (oldQueryParams.AuditFlag!=AuditFlag){
			if (AuditFlag=='N'){
				var columns=[[
					{field:'ck',checkbox:true,width:50},
					{field:'TEventDay',title:'�¼�����ʱ��',width:160,formatter:function(val,row){return val+' '+row['TEventTiming'];}},
					{field:'TEventTypeDesc',title:'�¼�����',width:160},
					{field:'TEventSummary',title:'�¼���������',width:800,formatter:function(val,row){
						if (row.TSameCount>1) {
							return val+'<span class="badge" style="background-color:red;position:absolute;">'+row.TSameCount+'</span>'
						}else{
							return val;	
						}
					}}
					,{field:'TEventDatabase',title:'���ݿ�',width:0,hidden:true}
					,{field:'TEventGlobalName',title:'Global',width:0,hidden:true}
				]]
			}else{
				var columns=[[
					{field:'ck',checkbox:true,width:50},
					{field:'TEventDay',title:'�¼�����ʱ��',width:160,formatter:function(val,row){return val+' '+row['TEventTiming'];}},
					{field:'TEventTypeDesc',title:'�¼�����',width:160},
					{field:'TEventSummary',title:'�¼���������',width:400,formatter:function(val,row){
						if (row.TSameCount>1) {
							return val+'<span class="badge" style="background-color:red;position:absolute;">'+row.TSameCount+'</span>'
						}else{
							return val;	
						}
					}},
					{field:'TAuditResultDesc',title:'��˽��',width:80},
					{field:'TAuditUser',title:'�����',width:80},
					{field:'TAuditDay',title:'���ʱ��',width:160,formatter:function(val,row){return val+' '+row['TAuditTiming'];}},
					{field:'TAuditNote',title:'��˱�ע',width:160},
					{field:'TAuditExecNote',title:'���ñ�ע',width:160}
					,{field:'TEventDatabase',title:'���ݿ�',width:0,hidden:true}
					,{field:'TEventGlobalName',title:'Global',width:0,hidden:true}
				]]
				
			}
			dg.datagrid({columns:columns,queryParams:newQueryParams,pageNumber:1});
		}else{
			dg.datagrid('load',newQueryParams);
		}
		
		
	}
	var debounced_findEventList=SMP_COMM.debounce(findEventList,200);
	
	//d ##class(%ResultSet).RunQuery("CT.BSP.SMP.Comm","Find","","EventType",0,1)
	$('#EventType').combobox({
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			param.ResultSetType='array';
			param.rows=9999;
			param.ClassName='CT.BSP.SMP.Comm';
			param.QueryName='Find';
			param.q='';
			param.Type='EventType';
			param.IsPar=0;
			param.Active=1;

		}
		,editable:false
		,valueField:'TCode'
		,textField:'TDescription'
		,width:200
		,required:true
		,onLoadSuccess:function(){
			$('#EventType').combobox('setValue',rEventType);
			$('#EventType').combobox('options').onLoadSuccess=function(){};
			$('#EventSearchBtn').click();
			$('#EventType').combobox('options').onSelect=debounced_findEventList;
		}
	})
	rAuditFlag=rAuditFlag||'N';
	$('#AuditFlag'+rAuditFlag).radio('setValue',true);
	$('#AuditFlagY,#AuditFlagN').each(function(){
		$(this).radio('options').onCheckChange=debounced_findEventList;
	})
	
	$('#EventDatabase').combobox({
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			param.ResultSetType='array';
			param.rows=9999;
			param.ClassName='CT.BSP.SMP.Comm';
			param.QueryName='Find';
			param.Type='Database';
			param.IsPar=0;
			param.Active=1;

		}
		,editable:true
		,valueField:'TCode'
		,textField:'TDescription'
		,width:160
		,onSelect:debounced_findEventList
	})
	
	$('#EventSearchBtn').click(function(){
		findEventList();
	})
	

	
}
$(init);