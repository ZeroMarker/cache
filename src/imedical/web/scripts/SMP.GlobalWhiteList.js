var GV={DIC:{}};
var init=function(){
	SYS_OUT.PageGWL.OriginMaxID=parseInt(SYS_OUT.PageGWL.OriginMaxID)||50000;
	
	var dgtoolbar=['add','edit','undo','save','delete','export'];
	if (SYS_OUT.PageGWL.AllowImport=='1') dgtoolbar.push('import');
	dgtoolbar=dgtoolbar.concat([{
				id:'tb-btn-change-type',
				iconCls:'icon-edit',
				text:'修改Global类型',
				handler:function(){
					multiEditOneField('GlobalType');
				}
			},{
				id:'tb-btn-change-group',
				iconCls:'icon-edit',
				text:'修改产品组',
				handler:function(){
					multiEditOneField('OwnerGroup');
				}
			}
	])
	
	
	var dg=SMP_COMM.createSimpleEditGrid({
		id:'t',
		title:'Global白名单',
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
				callback(false,"-1^没有数据");
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
			{field:"TOwnerDatabase",title:"数据库",align:"left",width:150,editor:{type:'combobox',options:{
					data:GV.DIC.Database,valueField:'TCode',textField:'TDescription',defaultFilter:4
				}},formatter:function(val,row,ind){
					return row.TOwnerDatabaseDesc;
				}
			,sortable:true},
			{field:"TGlobalType",title:"Global类型",align:"left",width:100,sortable:true,editor:{type:'combobox',options:{
					data:GV.DIC.GlobalType,valueField:'TCode',textField:'TDescription',defaultFilter:4
				}},formatter:function(val,row,ind){
					return row.TGlobalTypeDesc;
				}
			,sortable:true},
			{field:"TGlobalName",title:"Global名称",align:"left",width:200,editor:{
				type:'validatebox',
				options:{required:true,validType:['length[1,32]','globalname["fuzzyleft"]']}
				
			},sortable:true},
			{field:"TOwnerGroup",title:"产品组",align:"left",width:150,editor:{type:'combobox',options:{
					data:GV.DIC.PRDGroup,valueField:'TCode',textField:'TDescription',defaultFilter:4
				}},formatter:function(val,row,ind){
					return row.TOwnerGroupDesc;
				}
			,sortable:true},
			{field:"TDescription",title:"备注",align:"left",width:150,editor:'text'},
			{field:"TIsDelete",title:"使用状态",align:"left",width:80,editor:{type:'combobox',options:{data:[{text:'有效',value:'0'},{text:'停用',value:'1'}],panelHeight:'auto'}},formatter:function(val){
				return val==1?'<span style="color:red;">停用</span>':'<span style="">有效</span>';
			}},
			{field:"TOperator",title:"操作人",align:"left",width:100},
			{field:"TModifyDate",title:"操作时间",align:"left",width:150,formatter:function(val,row,ind){
				return val+' '+row['TModiftTime']||'';	
			}}
		]],
		data:{total:0,rows:[]},
		codeField:'TGlobalName', //导入数据时用的idField
		rowParser:function(newrow){ //导入数据时 数据解析
			//newrow['TActive']=newrow['TActive']=='是'?1:0
			newrow['TOwnerDatabaseDesc']=newrow['TOwnerDatabase'];
			newrow['TGlobalTypeDesc']=newrow['TGlobalType'];
			newrow['TOwnerGroupDesc']=newrow['TOwnerGroup'];
			newrow['TModiftTime']=(newrow['TModifyDate']||'').split(' ')[1]||'';
			newrow['TModifyDate']=(newrow['TModifyDate']||'').split(' ')[0]||'';
			newrow['TIsDelete']=newrow['TIsDelete']=='停用'?1:0;
			//newrow['TIsModified']=(newrow['TIsModified'] && newrow['TIsModified'].indexOf('是')>-1)?1:0;
		},
		grid2excelOpts:{showHidden:true,appendColumns:[{field:"TIsModified",title:"是否修改",formatter:function(val){return '';}},{field:"TNewAdd",title:"是否新增",formatter:function(val){return '';}}]},
		allowOverwrite:(SYS_OUT.PageGWL.AllowOverWriteImport=='1'),  //是否允许覆盖导入
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
			if ((row['是否修改']=='是' || row['是否新增']=='是')) {
				return true;	
			}	
		}
		
	})
	
	var multiEditOneField =function(field){
		if ($('#multi-edit-one-field-win').length==0) {
			$('<div id="multi-edit-one-field-win" style="padding:20px 20px 10px;"><div><input id="multi-edit-one-field-input"/></div></div>').appendTo('body');
			
			$('#multi-edit-one-field-win').dialog({
				title:'请选择',	
				iconCls:'icon-w-paper',
				width:240,
				height:150,
				buttons:[{text:'确定',handler:function(){
					var val=$('#multi-edit-one-field-input').combobox('getValue');
					
					var opts=$('#multi-edit-one-field-input').combobox('options');
					
					if ($.hisui.indexOfArray(opts.data,opts.valueField,val)>-1){
						var Field=$('#multi-edit-one-field-win').data('field');
						$.messager.confirm('确定','确定修改吗？',function(r){
							if(r) {
								var param={ClassName:'BSP.SMP.BL.GlobalWhiteList',MethodName:'MultiUpdateField',Field:Field,FieldValue:val};
								var rows=dg.datagrid('getSelections'),idArr=[];
								$.each(rows,function(){idArr.push(this.TId)});
								param.Ids=idArr.join('^');
								console.log(param);
								
								$.ajaxRunServerMethod(param,function(rtn){
									if (rtn.split('^')[0]>0){
										SMP_COMM.alert("成功", "修改成功", 'success');
										$('#multi-edit-one-field-win').dialog('close');
										dg.datagrid('reload');
									}else{
										SMP_COMM.alert("失败", rtn.split('^')[1], 'error');
									}
								})	
								
								
							}
						})
						
					}else{
						SMP_COMM.alert("提示", "请选择数据", 'alert');
					}
					
				}},{text:'取消',handler:function(){
					$('#multi-edit-one-field-win').dialog('close');
				}}],onClose:function(){
					$('#multi-edit-one-field-input').combobox('clear');
				}
			})
		}	
		
		$('#multi-edit-one-field-win').data('field',field);
		if(field=='GlobalType') {
			
			$('#multi-edit-one-field-win').dialog('setTitle','请选择Global类型')
				
			$('#multi-edit-one-field-input').combobox({
				data:GV.DIC.GlobalType,valueField:'TCode',textField:'TDescription',defaultFilter:4,width:200
			})
			
		}else if(field=='OwnerGroup') {
			$('#multi-edit-one-field-win').dialog('setTitle','请选择产品组');
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
		data:[{text:'全部',value:''},{text:'有效',value:'0'},{text:'停用',value:'1'}],valueField:'value',textField:'text',editable:false,panelHeight:'auto'
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
			title:'Global灰->黑名单',
			url:'smp.globallist.csp'
		}
		SMP_COMM.showBread(opts);
	})
	
	
	var $dbLabel=$('#Database-filter').closest('td').prev();
	var dbLabelClick5=function(){
		console.log('dbLabelClick5');
		$.messager.prompt('切换删除模式','请输入密码',function(r){
		    if(r) {
				$.ajaxRunServerMethod({ClassName:'BSP.SMP.COM.Conversions',MethodName:'ToggleSessDeleteMode',pwd:r},function(rtn){
					$.messager.popover({msg:rtn,type:'info'})	
				})
				
				   
			}else{
				$.messager.popover({msg:'请输入密码',type:'alert'})	
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
		console.log('数据库字典数据加载成功');
	},'json')
	,
	$.post($URL,{ClassName:'CT.BSP.SMP.Comm',QueryName:'Find',q:'',ResultSetType:'array',rows:9999,Type:'GlobalType',IsPar:0,Active:1},function(rows){
		GV.DIC.GlobalType=rows;
		console.log('Global类型字典数据加载成功');
	},'json')
	,
	$.post($URL,{ClassName:'CT.BSP.SMP.Comm',QueryName:'Find',q:'',ResultSetType:'array',rows:9999,Type:'PRDGroup',IsPar:0,Active:1},function(rows){
		GV.DIC.PRDGroup=rows;
		console.log('产品组字典数据加载成功');
	},'json')
).done(function(){
	if (GV.DIC.Database && GV.DIC.GlobalType && GV.DIC.PRDGroup) init();
}));