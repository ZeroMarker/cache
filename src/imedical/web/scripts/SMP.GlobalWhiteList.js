var GV={DIC:{}};
var init=function(){
	SYS_OUT.PageGWL.OriginMaxID=parseInt(SYS_OUT.PageGWL.OriginMaxID)||50000;
	
	var dgtoolbar=['add','edit','undo','save','delete','export'];
	if (SYS_OUT.PageGWL.AllowImport=='1') dgtoolbar.push('import');
	dgtoolbar=dgtoolbar.concat([{
				id:'tb-btn-change-type',
				iconCls:'icon-edit',
				text:'�޸�Global����',
				handler:function(){
					multiEditOneField('GlobalType');
				}
			},{
				id:'tb-btn-change-group',
				iconCls:'icon-edit',
				text:'�޸Ĳ�Ʒ��',
				handler:function(){
					multiEditOneField('OwnerGroup');
				}
			}
	])
	
	
	var dg=SMP_COMM.createSimpleEditGrid({
		id:'t',
		title:'Global������',
		idField:'TId',
		toolbar:dgtoolbar,
		deleteFun:function(ind,row,callback,rows){
			
			if (rows && rows.length>0) {
				var idArr=[];
				$.each(rows,function(){idArr.push(this.TId)});
				
				$.ajaxRunServerMethod({ClassName:'BSP.SMP.BL.GlobalWhiteList',MethodName:'MultiDelete',Ids:idArr.join('^')},function(rtn){
					if (rtn.split('^')[0]>0){
						callback(true,rtn,rtn.split('^')[1]);
					}else{
						callback(false,rtn.split("^")[1]||rtn);
					}
				})
				
			}else{
				callback(false,"-1^û������");
			}
			

		},
		validateFun:function(ind,row,callback){
			callback(true,1)
		},
		saveFun:function(ind,row,callback){
			var param={ClassName:'BSP.SMP.BL.GlobalWhiteList',MethodName:'Save'};
			$.each(row,function(ind,value){
				if (ind.charAt('0')=="T"){
					param[ind.substr(1)]=value;
				}
			})
			console.log(param);
			param.AutoAudit='1';
			$.ajaxRunServerMethod(param,function(rtn){
				if (rtn.indexOf('-1')==0){
					callback(false,rtn.split("^")[1]||rtn);
				}else{
					$.post($URL,{ClassName:'BSP.SMP.BL.GlobalWhiteList',QueryName:'Find',Id:rtn},function(data){
						if (data && data.rows && data.rows instanceof Array ){
							callback(true,rtn, data.rows[0]);
						}
					},'json').fail(function(){callback(true,rtn)})
					
				}
			})
		},
		newRowGetter:function(){
			//TId:%String,TDatabaseDirectory:%String,TDescription:%String,TGlobalName:%String,TGlobalType:%String,TModiftTime:%String,TModifyDate:%String,TOperator:%String,TOwnerDatabase:%String,TOwnerGroup:%String,TGlobalTypeDesc,TOwnerDatabaseDesc,TOwnerGroupDesc
			return {
					TId:'',TDatabaseDirectory:'',TDescription:'',TGlobalName:'',TGlobalType:'',TModiftTime:'',TModifyDate:'',TOperator:'',TOwnerDatabase:'',TOwnerGroup:'',TGlobalTypeDesc:'',TOwnerDatabaseDesc:'',TOwnerGroupDesc:''
				}
		},
		pageSize:30,
		pageList:[10,20,30,50,100,300,500,1000],
		singleSelect:false,
		queryParams:{ClassName:'BSP.SMP.BL.GlobalWhiteList',QueryName:'Find'},
		//TId:%String,TDatabaseDirectory:%String,TDescription:%String,TGlobalName:%String,TGlobalType:%String,TModiftTime:%String,TModifyDate:%String,TOperator:%String,TOwnerDatabase:%String,TOwnerGroup:%String
		columns:[[
			{field:"ck",checkbox:true},
			{field:"TOwnerDatabase",title:"���ݿ�",align:"left",width:150,editor:{type:'combobox',options:{
					data:GV.DIC.Database,valueField:'TCode',textField:'TDescription',defaultFilter:4
				}},formatter:function(val,row,ind){
					return row.TOwnerDatabaseDesc;
				}
			,sortable:true},
			{field:"TGlobalType",title:"Global����",align:"left",width:100,sortable:true,editor:{type:'combobox',options:{
					data:GV.DIC.GlobalType,valueField:'TCode',textField:'TDescription',defaultFilter:4
				}},formatter:function(val,row,ind){
					return row.TGlobalTypeDesc;
				}
			,sortable:true},
			{field:"TGlobalName",title:"Global����",align:"left",width:200,editor:{
				type:'validatebox',
				options:{required:true,validType:['length[1,32]','globalname["fuzzyleft"]']}
				
			},sortable:true},
			{field:"TOwnerGroup",title:"��Ʒ��",align:"left",width:150,editor:{type:'combobox',options:{
					data:GV.DIC.PRDGroup,valueField:'TCode',textField:'TDescription',defaultFilter:4
				}},formatter:function(val,row,ind){
					return row.TOwnerGroupDesc;
				}
			,sortable:true},
			{field:"TDescription",title:"��ע",align:"left",width:150,editor:'text'},
			{field:"TIsDelete",title:"ʹ��״̬",align:"left",width:80,editor:{type:'combobox',options:{data:[{text:'��Ч',value:'0'},{text:'ͣ��',value:'1'}],panelHeight:'auto'}},formatter:function(val){
				return val==1?'<span style="color:red;">ͣ��</span>':'<span style="">��Ч</span>';
			}},
			{field:"TOperator",title:"������",align:"left",width:100},
			{field:"TModifyDate",title:"����ʱ��",align:"left",width:150,formatter:function(val,row,ind){
				return val+' '+row['TModiftTime']||'';	
			}}
		]],
		data:{total:0,rows:[]},
		codeField:'TGlobalName', //��������ʱ�õ�idField
		rowParser:function(newrow){ //��������ʱ ���ݽ���
			//newrow['TActive']=newrow['TActive']=='��'?1:0
			newrow['TOwnerDatabaseDesc']=newrow['TOwnerDatabase'];
			newrow['TGlobalTypeDesc']=newrow['TGlobalType'];
			newrow['TOwnerGroupDesc']=newrow['TOwnerGroup'];
			newrow['TModiftTime']=(newrow['TModifyDate']||'').split(' ')[1]||'';
			newrow['TModifyDate']=(newrow['TModifyDate']||'').split(' ')[0]||'';
			newrow['TIsDelete']=newrow['TIsDelete']=='ͣ��'?1:0;
			//newrow['TIsModified']=(newrow['TIsModified'] && newrow['TIsModified'].indexOf('��')>-1)?1:0;
		},
		grid2excelOpts:{showHidden:true,appendColumns:[{field:"TIsModified",title:"�Ƿ��޸�",formatter:function(val){return '';}},{field:"TNewAdd",title:"�Ƿ�����",formatter:function(val){return '';}}]},
		allowOverwrite:(SYS_OUT.PageGWL.AllowOverWriteImport=='1'),  //�Ƿ������ǵ���
		importFun:function(row,callback,importOpts){
			var param={ClassName:'BSP.SMP.BL.GlobalWhiteList',MethodName:'ImportHanler'};
			param.overwrite=importOpts.overwrite?'1':'0';
			$.each(row,function(ind,ele){
				if(typeof ind=="string" && ind.charAt(0)=="T"){
					param[ind.substr(1)]=ele
				} 
			})
			$.m(param,function(ret){
				callback(ret,ret>0);	
			})

		},onSelectChange:function(){
			if (dg.datagrid('getSelected')) $('#tb-btn-change-type,#tb-btn-change-group').linkbutton('enable');
			else $('#tb-btn-change-type,#tb-btn-change-group').linkbutton('disable');
		},isDisableddField:function(ind,row,field){
			if((field=='TOwnerDatabase'||field=='TGlobalName')&& parseInt(row.TId)<SYS_OUT.PageGWL.OriginMaxID) {
				return true;
			}
			return false;
		},onBeforeSelect:function(ind,row){
			if(row.TGlobalType=='SYS'){
				return false;	
			}else{
				return true;	
			}
		},excelFilter:function(ind,row){
			if ((row['�Ƿ��޸�']=='��' || row['�Ƿ�����']=='��')) {
				return true;	
			}	
		}
		
	})
	
	var multiEditOneField =function(field){
		if ($('#multi-edit-one-field-win').length==0) {
			$('<div id="multi-edit-one-field-win" style="padding:20px 20px 10px;"><div><input id="multi-edit-one-field-input"/></div></div>').appendTo('body');
			
			$('#multi-edit-one-field-win').dialog({
				title:'��ѡ��',	
				iconCls:'icon-w-paper',
				width:240,
				height:150,
				buttons:[{text:'ȷ��',handler:function(){
					var val=$('#multi-edit-one-field-input').combobox('getValue');
					
					var opts=$('#multi-edit-one-field-input').combobox('options');
					
					if ($.hisui.indexOfArray(opts.data,opts.valueField,val)>-1){
						var Field=$('#multi-edit-one-field-win').data('field');
						$.messager.confirm('ȷ��','ȷ���޸���',function(r){
							if(r) {
								var param={ClassName:'BSP.SMP.BL.GlobalWhiteList',MethodName:'MultiUpdateField',Field:Field,FieldValue:val};
								var rows=dg.datagrid('getSelections'),idArr=[];
								$.each(rows,function(){idArr.push(this.TId)});
								param.Ids=idArr.join('^');
								console.log(param);
								
								$.ajaxRunServerMethod(param,function(rtn){
									if (rtn.split('^')[0]>0){
										SMP_COMM.alert("�ɹ�", "�޸ĳɹ�", 'success');
										$('#multi-edit-one-field-win').dialog('close');
										dg.datagrid('reload');
									}else{
										SMP_COMM.alert("ʧ��", rtn.split('^')[1], 'error');
									}
								})	
								
								
							}
						})
						
					}else{
						SMP_COMM.alert("��ʾ", "��ѡ������", 'alert');
					}
					
				}},{text:'ȡ��',handler:function(){
					$('#multi-edit-one-field-win').dialog('close');
				}}],onClose:function(){
					$('#multi-edit-one-field-input').combobox('clear');
				}
			})
		}	
		
		$('#multi-edit-one-field-win').data('field',field);
		if(field=='GlobalType') {
			
			$('#multi-edit-one-field-win').dialog('setTitle','��ѡ��Global����')
				
			$('#multi-edit-one-field-input').combobox({
				data:GV.DIC.GlobalType,valueField:'TCode',textField:'TDescription',defaultFilter:4,width:200
			})
			
		}else if(field=='OwnerGroup') {
			$('#multi-edit-one-field-win').dialog('setTitle','��ѡ���Ʒ��');
			$('#multi-edit-one-field-input').combobox({
				data:GV.DIC.PRDGroup,valueField:'TCode',textField:'TDescription',defaultFilter:4,width:200
			})
		}else{
			return;	
		}
		$('#multi-edit-one-field-win').dialog('open');
	}
	
	
	
	
	function loadDg(){
		var Database=$('#Database-filter').combobox('getValue');
		var GlobalType=$('#GlobalType-filter').combobox('getValue');
		var PRDGroup=$('#PRDGroup-filter').combobox('getValue');
		var IsDelete=$('#IsDelete-filter').combobox('getValue');
		
		var q=$('#filter').searchbox('getValue');
		var param={Database:Database,GlobalType:GlobalType,PRDGroup:PRDGroup,q:q,IsDelete:IsDelete}
		dg.datagrid('load2',param);
	}
	var debounced_loadDg=SMP_COMM.debounce(loadDg,200);
	$('#Database-filter,#GlobalType-filter,#PRDGroup-filter').each(function(){
		var t=$(this),key=t.attr('id').split('-')[0];
		t.combobox({
			data:GV.DIC[key],valueField:'TCode',textField:'TDescription',defaultFilter:4,
			onChange:function(){
				debounced_loadDg();
			}
		})
	})
	
	$('#IsDelete-filter').combobox({
		data:[{text:'ȫ��',value:''},{text:'��Ч',value:'0'},{text:'ͣ��',value:'1'}],valueField:'value',textField:'text',editable:false,panelHeight:'auto'
		,onChange:function(){
			debounced_loadDg();
		}
	})
	
	$('#filter').searchbox({
		searcher:function(){
			debounced_loadDg();
		}	
	})
	
	$('#to-black-gray-list').click(function(){
		var opts={
			id:'GlobalList',
			title:'Global��->������',
			url:'smp.globallist.csp'
		}
		SMP_COMM.showBread(opts);
	})
	
	
	var $dbLabel=$('#Database-filter').closest('td').prev();
	var dbLabelClick5=function(){
		console.log('dbLabelClick5');
		$.messager.prompt('�л�ɾ��ģʽ','����������',function(r){
		    if(r) {
				$.ajaxRunServerMethod({ClassName:'BSP.SMP.COM.Conversions',MethodName:'ToggleSessDeleteMode',pwd:r},function(rtn){
					$.messager.popover({msg:rtn,type:'info'})	
				})
				
				   
			}else{
				$.messager.popover({msg:'����������',type:'alert'})	
			}
		})
		$('.messager-window').last().find('.messager-input').attr('type','password').focus()
			
		
		
			
	}
	var debounced_dbLabelClick5=SMP_COMM.debounce(dbLabelClick5,300)
	if (SYS_OUT.isDevMode=='1') {
		SMP_COMM.bindRepeatEvent($dbLabel,'click',debounced_dbLabelClick5,200,5);
	}

};
$($.when(
	$.post($URL,{ClassName:'CT.BSP.SMP.Comm',QueryName:'Find',q:'',ResultSetType:'array',rows:9999,Type:'Database',IsPar:0,Active:1},function(rows){
		GV.DIC.Database=rows;
		console.log('���ݿ��ֵ����ݼ��سɹ�');
	},'json')
	,
	$.post($URL,{ClassName:'CT.BSP.SMP.Comm',QueryName:'Find',q:'',ResultSetType:'array',rows:9999,Type:'GlobalType',IsPar:0,Active:1},function(rows){
		GV.DIC.GlobalType=rows;
		console.log('Global�����ֵ����ݼ��سɹ�');
	},'json')
	,
	$.post($URL,{ClassName:'CT.BSP.SMP.Comm',QueryName:'Find',q:'',ResultSetType:'array',rows:9999,Type:'PRDGroup',IsPar:0,Active:1},function(rows){
		GV.DIC.PRDGroup=rows;
		console.log('��Ʒ���ֵ����ݼ��سɹ�');
	},'json')
).done(function(){
	if (GV.DIC.Database && GV.DIC.GlobalType && GV.DIC.PRDGroup) init();
}));