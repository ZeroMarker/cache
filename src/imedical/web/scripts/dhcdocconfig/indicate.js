$(function(){
    InitList();
});
function InitList()
{
    $("#tabIndicateList").singleGrid({
	    useBaseToolbar:true,
	    fitColumns:false,
		clsName:'CF.DOC.Indicate',
		idField:'ID',
		border:false,
		queryParams:{ClassName : "DHCDoc.DHCDocConfig.Indicate",QueryName : "QueryIndicate"},
		columns :[[
			{field:'ID',hidden:true},
			{field:'Code',title:'代码',width:150,editor:{type:'text',options:{}}},
			{field:'Text',title:'名称',width:150,editor:{type:'text',options:{}}},
			{field:'Active',title:'激活',width:50,align:'center',
				editor:{
					type: 'icheckbox',
					options:{
						on:'1',
						off:'0'
					}
				},
                styler: function(value,row,index){
                    return value==1?'color:#21ba45;':'color:#f16e57;';
                },
                formatter:function(value,record){
                    return value==1?'是':'否';
                }
            },
			{field:'ChartType',title:'类型',width:80,align:'center',
                editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        data:ServerObj.ChartTypeData
                    }
                },
                formatter:function(value,record){
                    var text="";
                    $.each(ServerObj.ChartTypeData,function(index,row){
                        if(row.id==value){
                            text=row.text;
                            return false;
                        }
                    });
                    return text;
                }
            },
			{field:'ClassName',title:'Class',width:200,editor:{type:'text',options:{}}},
			{field:'QueryName',title:'Query',width:150,editor:{type:'text',options:{}}},
			{field:'MethodName',title:'Method',width:150,editor:{type:'text',options:{}}},
			{field:'Params',title:'参数(JSON格式)',width:200,editor:{type:'text',options:{}}},
			{field:'refreshSecond',title:'刷新间隔(秒)',width:100,align:'center',editor:{type:'numberbox',options:{min:0}}},
			{field:'showTitle',title:'显示标题',width:80,align:'center',
				editor:{
					type: 'icheckbox',
					options:{
						on:'1',
						off:'0'
					}
				},
                styler: function(value,row,index){
                    return value==1?'color:#21ba45;':'color:#f16e57;';
                },
                formatter:function(value,record){
                    return value==1?'是':'否';
                }
			},
			{field:'xAxisField',title:'X轴节点',width:80,align:'center',editor:{type:'text',options:{}}},
			{field:'yAxisField',title:'Y轴节点',width:80,align:'center',editor:{type:'text',options:{}}},
			{field:'dimensionField',title:'维度节点',width:80,align:'center',editor:{type:'text',options:{}}},
			{field:'dimensionColor',title:'维度颜色',width:200,editor:{type:'text',options:{}}},
			{field:'valueFormat',title:'格式化{value}',width:100,align:'center',editor:{type:'text',options:{}}},
			{field:'smooth',title:'平滑折线',width:100,align:'center',editor:{type:'numberbox',options:{min:0,max:1}}},
			{field:'tooltipTrigger',title:'悬浮提示类型',width:80,align:'center',
                editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        data:ServerObj.TooltipTriggerData
                    }
                },
                formatter:function(value,record){
                    var text="";
                    $.each(ServerObj.TooltipTriggerData,function(index,row){
                        if(row.id==value){
                            text=row.text;
                            return false;
                        }
                    });
                    return text;
                }
            },
            {field:'showMonthChange',title:'显示月份',width:50,align:'center',
				editor:{
					type: 'icheckbox',
					options:{
						on:'1',
						off:'0'
					}
				},
                styler: function(value,row,index){
                    return value==1?'color:#21ba45;':'color:#f16e57;';
                },
                formatter:function(value,record){
                    return value==1?'是':'否';
                }
            },
			{field:'imgSrc',title:'图标路径',width:200,editor:{type:'text',options:{}}},
			{field:'linkUrl',title:'跳转链接',width:350,editor:{type:'text',options:{}}}
		]],
		getInitRow:function(){
			return {Active:1,ChartType:'bar'};
		},
		checkSaveRows:function(rows){
			for(var i=rows.length-1;i>=0;i--){
				if((rows[i].Code=='')||(rows[i].Text=='')){
					if(rows[i].ID){
						$.messager.popover({msg:"按钮栏代码与名称不能为空",type:'alert'});
						return false;
					}
					rows.splice(i,1); 
				}
			}
			return rows;
		},
		onBeginEdit:function(index,row){
			var ed = $(this).datagrid('getEditor', {index:index,field:'Code'});
			$(ed.target).select();
		}
	});
}