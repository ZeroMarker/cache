var GV={
	isEditing:false,
	editingIndex:-1	
};
var init=function(){
	var dg=SMP_COMM.createSimpleEditGrid({
		id:'t-w',
		title:'�ֵ��б�',
		displayMsg:'{from}-{to}/{total}',
		idField:'TId',
		toolbar:['add','edit','undo','save','delete'],
		deleteFun:function(ind,row,callback){
			$.ajaxRunServerMethod({ClassName:'CT.BSP.SMP.Comm',MethodName:'Delete',Id:row.TId},function(rtn){
				if (rtn>0){
					callback(true,rtn);
				}else{
					callback(false,rtn.split("^")[1]||rtn);
				}
			})
		},
		validateFun:function(ind,row,callback){
			callback(true,1);
		},
		saveFun:function(ind,row,callback){
			$.ajaxRunServerMethod({ClassName:'CT.BSP.SMP.Comm',MethodName:'Save',
				Id:row.TId,
				Type:row.TType,
				Code:row.TCode,
				Description:row.TDescription,
				Note:row.TNote,
				Active:row.TActive
				,IsPar:1
			},function(rtn){
				if (rtn.indexOf('-1')==0){
					callback(false,rtn.split("^")[1]||rtn);
				}else{
					callback(true,rtn);
				}
			})
		},
		newRowGetter:function(){
			return {
					TId:'',
					TType:'',
					TCode:'',
					TDescription:'',
					TNote:''	
				}
		},
		columns:[[
			{field:"TType",title:"����",width:150,editor:{
				type:'validatebox',
				options:{required:true,validType:'length[1,50]'}
				
			}},
			{field:"TDescription",title:"����",align:"left",width:150,editor:{
				type:'validatebox',
				options:{required:true,validType:'length[1,50]'}
				
			}},
			{field:"TActive",title:"����",width:150,editor:{type:'icheckbox',options:{on:'1',off:'0'}},formatter:function(val){
				return val==1?'<span style="color:green;">��</span>':'<span style="color:gray;">��</span>';
			}}
		]],
		disabledEditFields:['TType'],
		queryParams:{ClassName:'CT.BSP.SMP.Comm',QueryName:'Find',IsPar:1}
		,onSelectChange:function(){
			debounced_onWestSelectChange();
			
		},deleteConfirmMsg:'ȷ��ɾ�����ֵ�ô���˲�����ɾ�����ֵ�����������'
		
	})
	
	function onWestSelectChange(){
		var row=dg.datagrid('getSelected');
		if(row && row.TId){
			GV.selectedDicCode=row.TType;
			GV.selectedDicDesc=row.TDescription;
		}else{
			GV.selectedDicCode='';
			GV.selectedDicDesc='';
		}
		if(dg2){
			var title=GV.selectedDicDesc==""?'�ֵ������б�':('�ֵ䡾'+GV.selectedDicDesc.split('�ֵ�')[0]+'�������б�')
			dg2.datagrid('getPanel').panel('setTitle',title);
			dg2.datagrid('load2',{Type:GV.selectedDicCode});
		}
	}
	
	var debounced_onWestSelectChange=SMP_COMM.debounce(onWestSelectChange,200);
	
	var dg2=SMP_COMM.createSimpleEditGrid({
		id:'t',
		title:'�ֵ������б�',
		idField:'TId',
		toolbar:['add','edit','undo','save','delete','filter','export','import'],
		filterFun:function(val){
			$(this).datagrid('load2',{q:val})
		},
		deleteFun:function(ind,row,callback){
			$.ajaxRunServerMethod({ClassName:'CT.BSP.SMP.Comm',MethodName:'Delete',Id:row.TId},function(rtn){
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
			$.ajaxRunServerMethod({ClassName:'CT.BSP.SMP.Comm',MethodName:'Save',
				Id:row.TId,
				Type:row.TType,
				Code:row.TCode,
				Description:row.TDescription,
				Note:row.TNote,
				Active:row.TActive
				,IsPar:0
				,Sort:row.TSort
			},function(rtn){
				if (rtn.indexOf('-1')==0){
					callback(false,rtn.split("^")[1]||rtn);
				}else{
					callback(true,rtn);
				}
			})
		},
		newRowGetter:function(){
			return {
					TId:'',
					TType:GV.selectedDicCode,
					TCode:'',
					TDescription:'',
					TNote:'',
					TSort:''
				}
		},
		pageSize:30,
		columns:[[
			{field:"TCode",title:"����",width:100,editor:{
				type:'validatebox',
				options:{required:true,validType:'length[1,50]'}
				
			}},
			{field:"TDescription",title:"����",width:100,editor:{
				type:'validatebox',
				options:{required:true,validType:'length[1,50]'}
				
			}},
			
			{field:"TActive",title:"����",width:100,editor:{type:'icheckbox',options:{on:'1',off:'0'}},formatter:function(val){
				return val==1?'<span style="color:green;">��</span>':'<span style="color:gray;">��</span>';
			}},
			{field:"TSort",title:"˳��",width:100,editor:'text'},
			{field:"TNote",title:"��ע",width:200,editor:'text'}
		]],
		disabledEditFields:['TCode'],
		queryParams:{ClassName:'CT.BSP.SMP.Comm',QueryName:'Find',IsPar:0},
		parentGrid:'#t-w',
		codeField:'TCode', //��������ʱ�õ�idField
		rowParser:function(newrow){ //��������ʱ ���ݽ���
			newrow['TActive']=newrow['TActive']=='��'?1:0
		},
		importFun:function(row,callback){
			var param={ClassName:'CT.BSP.SMP.Comm',MethodName:'Save',IsPar:0};
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

};
$(init);