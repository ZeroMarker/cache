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
			{field:'Code',title:'����',width:150,editor:{type:'text',options:{}}},
			{field:'Text',title:'����',width:150,editor:{type:'text',options:{}}},
			{field:'Active',title:'����',width:50,align:'center',
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
                    return value==1?'��':'��';
                }
            },
			{field:'ChartType',title:'����',width:80,align:'center',
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
			{field:'Params',title:'����(JSON��ʽ)',width:200,editor:{type:'text',options:{}}},
			{field:'refreshSecond',title:'ˢ�¼��(��)',width:100,align:'center',editor:{type:'numberbox',options:{min:0}}},
			{field:'showTitle',title:'��ʾ����',width:80,align:'center',
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
                    return value==1?'��':'��';
                }
			},
			{field:'xAxisField',title:'X��ڵ�',width:80,align:'center',editor:{type:'text',options:{}}},
			{field:'yAxisField',title:'Y��ڵ�',width:80,align:'center',editor:{type:'text',options:{}}},
			{field:'dimensionField',title:'ά�Ƚڵ�',width:80,align:'center',editor:{type:'text',options:{}}},
			{field:'dimensionColor',title:'ά����ɫ',width:200,editor:{type:'text',options:{}}},
			{field:'valueFormat',title:'��ʽ��{value}',width:100,align:'center',editor:{type:'text',options:{}}},
			{field:'smooth',title:'ƽ������',width:100,align:'center',editor:{type:'numberbox',options:{min:0,max:1}}},
			{field:'tooltipTrigger',title:'������ʾ����',width:80,align:'center',
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
            {field:'showMonthChange',title:'��ʾ�·�',width:50,align:'center',
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
                    return value==1?'��':'��';
                }
            },
			{field:'imgSrc',title:'ͼ��·��',width:200,editor:{type:'text',options:{}}},
			{field:'linkUrl',title:'��ת����',width:350,editor:{type:'text',options:{}}}
		]],
		getInitRow:function(){
			return {Active:1,ChartType:'bar'};
		},
		checkSaveRows:function(rows){
			for(var i=rows.length-1;i>=0;i--){
				if((rows[i].Code=='')||(rows[i].Text=='')){
					if(rows[i].ID){
						$.messager.popover({msg:"��ť�����������Ʋ���Ϊ��",type:'alert'});
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