var GV={DIC:{}};
var init=function(){
	
	var dg=SMP_COMM.createSimpleEditGrid({
		id:'t',
		title:'Global�ڻ�����',
		idField:'TId',
		toolbar:['add','edit','undo','save','delete'
			,'export','import'
		],
		deleteFun:function(ind,row,callback){
			$.ajaxRunServerMethod({ClassName:'BSP.SMP.BL.GlobalList',MethodName:'Delete',Id:row.TId},function(rtn){
				if (rtn>0){
					callback(true,rtn);
				}else{
					callback(false,rtn.split("^")[1]||rtn);
				}
			})
		},
		validateFun:function(ind,row,callback){
			callback(true,1)
		},
		saveFun:function(ind,row,callback){
			var param={ClassName:'BSP.SMP.BL.GlobalList',MethodName:'Save'};
			$.each(row,function(ind,value){
				if (ind.charAt('0')=="T"){
					param[ind.substr(1)]=value;
				}
			})
			param.AutoAudit='1';
			console.log(param);
			$.ajaxRunServerMethod(param,function(rtn){
				if (rtn.indexOf('-1')==0){
					callback(false,rtn.split("^")[1]||rtn);
				}else{
					$.post($URL,{ClassName:'BSP.SMP.BL.GlobalList',QueryName:'Find',Id:rtn},function(data){
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
					TId:'',TDescription:'',TGlobalName:'',TModiftTime:'',TModifyDate:'',TOperator:'',TOwnerDatabase:'',TOwnerDatabaseDesc:'',TColor:'',TColorDesc:''
				}
		},
		pageSize:30,
		queryParams:{ClassName:'BSP.SMP.BL.GlobalList',QueryName:'Find'},
		//TId:%String,TDatabaseDirectory:%String,TDescription:%String,TGlobalName:%String,TGlobalType:%String,TModiftTime:%String,TModifyDate:%String,TOperator:%String,TOwnerDatabase:%String,TOwnerGroup:%String
		columns:[[
			{field:"TOwnerDatabase",title:"���ݿ�",align:"left",width:150,editor:{type:'combobox',options:{
					data:GV.DIC.Database,valueField:'TCode',textField:'TDescription',defaultFilter:4
				}},formatter:function(val,row,ind){
					return row.TOwnerDatabaseDesc;
				}
			},
			{field:"TGlobalName",title:"Global����",align:"left",width:150,editor:{
				type:'validatebox',
				options:{required:true,validType:['length[1,32]','globalname[""]']}
				
			}},
			{field:"TColor",title:"��������",align:"left",width:150,editor:{type:'combobox',options:{
					data:GV.DIC.GlobalColor,valueField:'TCode',textField:'TDescription',defaultFilter:4
				}},formatter:function(val,row,ind){
					return row.TColorDesc;
				}
			},
			{field:"TDescription",title:"��ע",align:"left",width:150,editor:'text'},
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
			newrow['TColorDesc']=newrow['TColor'];
			newrow['TModiftTime']=(newrow['TModifyDate']||'').split(' ')[1]||'';
			newrow['TModifyDate']=(newrow['TModifyDate']||'').split(' ')[0]||'';
		},
		importFun:function(row,callback){
			var param={ClassName:'BSP.SMP.BL.GlobalList',MethodName:'ImportHanler'};
			$.each(row,function(ind,ele){
				if(typeof ind=="string" && ind.charAt(0)=="T"){
					param[ind.substr(1)]=ele
				} 
			})
			$.m(param,function(ret){
				callback(ret,ret>0);	
			})

		}
		
	})
	function loadDg(){
		var Database=$('#Database-filter').combobox('getValue');
		var Color=$('#GlobalColor-filter').combobox('getValue');
		var q=$('#filter').searchbox('getValue');
		var param={Database:Database,Color:Color,q:q}
		dg.datagrid('load2',param);
	}
	var debounced_loadDg=SMP_COMM.debounce(loadDg,200);
	$('#Database-filter,#GlobalColor-filter').each(function(){
		var t=$(this),key=t.attr('id').split('-')[0];
		t.combobox({
			data:GV.DIC[key],valueField:'TCode',textField:'TDescription',defaultFilter:4,
			onChange:function(){
				debounced_loadDg();
			}
		})
	})
	$('#filter').searchbox({
		searcher:function(){
			debounced_loadDg();
		}	
	})
	

};
$($.when(
	$.post($URL,{ClassName:'CT.BSP.SMP.Comm',QueryName:'Find',q:'',ResultSetType:'array',rows:9999,Type:'Database',IsPar:0,Active:1},function(rows){
		rows=$.grep(rows,function(item){ //�ڻ��������� ������ѡ��UNSPECIFIC���ݿ�
			return item.TCode!='UNSPECIFIC';
		})
		GV.DIC.Database=rows;
		console.log('���ݿ��ֵ����ݼ��سɹ�');
	},'json')
	,
	$.post($URL,{ClassName:'CT.BSP.SMP.Comm',QueryName:'Find',q:'',ResultSetType:'array',rows:9999,Type:'GlobalColor',IsPar:0,Active:1},function(rows){
		GV.DIC.GlobalColor=rows;
		console.log('Global���������ֵ����ݼ��سɹ�');
	},'json')

).done(function(){
	if (GV.DIC.Database && GV.DIC.GlobalColor) init();
}));