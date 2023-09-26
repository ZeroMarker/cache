   
 		
$(function(){
	$("#Group,#dlgGroup").combobox({
		url:$URL+"?ClassName=web.DHCANOPArrange&QueryName=SSGROUP&ResultSetType=array",
        valueField:"ID",
        textField:"Group",
        onBeforeLoad:function(param)
        {
	        param.desc=param.q
	    }
	})
	$("#Type,#dlgType").combobox({
        valueField:"code",
        textField:"desc",
        panelHeight:"auto",
        data:[
			{"code":"MENU","desc":"菜单"},
			{"code":"BUTTON","desc":"按钮"},
			{"code":"COLUMN","desc":"可激活列"}
		]
	})
	var SeqList=[
        	{'code':'1','desc':'1'},
			{'code':'2','desc':'2'},
			{'code':'3','desc':'3'},
			{'code':'4','desc':'4'},
			{'code':'5','desc':'5'},
			{'code':'6','desc':'6'},
			{'code':'7','desc':'7'},
			{'code':'8','desc':'8'},
			{'code':'9','desc':'9'},
			{'code':'10','desc':'10'},
			{'code':'11','desc':'11'},
			{'code':'12','desc':'12'},
			{'code':'13','desc':'13'},
			{'code':'14','desc':'14'},
			{'code':'15','desc':'15'},
			{'code':'16','desc':'16'}
        ]; 
	$("#dlgSeq").combobox({
		valueField:"code",
        textField:"desc",
        data:SeqList,
        onSelect:function(record){   
	    	if(($("#dlgGroup").combobox('getValue')=="")||($("#dlgType").combobox('getValue')==""))
	    	{
		    	$.messager.alert("警告","请确保安全组和类型不为空!","warning");
				$(this).combobox('setValue','');
		    }
	    }
	});
	var CaptionList=[
       		{'code':'AppOper','desc':'手术申请','type':'MENU'},
			{'code':'AppOperClinics','desc':'门诊手术申请','type':'MENU'},
			{'code':'AppIntervent','desc':'手术申请(介入)','type':'MENU'}, 
			{'code':'AlterDayOper','desc':'拟日间手术修改','type':'MENU'},	
			{'code':'AlterOper','desc':'修改手术申请','type':'MENU'},
			{'code':'ConfirmDayOper','desc':'拟日间申请确认','type':'MENU'},
			{'code':'UpdateOperClinics','desc':'修改门诊手术申请','type':'MENU'}, 
			{'code':'UpdateOpIntervent','desc':'修改手术申请(介入)','type':'MENU'}, 	
			{'code':'ArrOper','desc':'手术安排','type':'MENU'},
			{'code':'ANAuditDayOper','desc':'拟日间麻醉术前评估','type':'MENU'},
			{'code':'ANPostDayOperAcess','desc':'日间麻醉恢复评估','type':'MENU'},
			{'code':'ANDayOutAcess','desc':'日间出院评估','type':'MENU'},
			{'code':'ArrOperClinics','desc':'手术安排(门诊)','type':'MENU'},
			{'code':'ArrOperIntervent','desc':'手术安排(介入)','type':'MENU'}, 
			{'code':'DHCANOPNurseRecord','desc':'手术护理访视单','type':'MENU'},
			{'code':'RefuseOper','desc':'手术停止','type':'MENU'},
			{'code':'CancelRef','desc':'撤销停止','type':'MENU'},
			{'code':'ArrAn','desc':'麻醉安排','type':'MENU'},
			{'code':'AnConsent','desc':'麻醉知情同意书','type':'MENU'},
			{'code':'PreOpAssessment','desc':'术前访视','type':'MENU'},
			{'code':'MonAn','desc':'麻醉管理','type':'MENU'},
			{'code':'AnRecord','desc':'麻醉记录明细','type':'MENU'},
			{'code':'PACURecord','desc':'麻醉恢复室','type':'MENU'},
			{'code':'PostOpRecord','desc':'术后随访','type':'MENU'},
			{'code':'ANOPCount','desc':'手术清点','type':'MENU'},
			{'code':'RegOper','desc':'术后登记','type':'MENU'},
			{'code':'NotAppRegOper','desc':'非预约手术登记','type':'MENU'},
			{'code':'AlterNotAppRegOper','desc':'非预约手术登记修改','type':'MENU'},
			{'code':'RegOperClinics','desc':'术后登记(门诊)','type':'MENU'},
			{'code':'PrintSQD','desc':'手术申请表打印','type':'MENU'},
			{'code':'PrintSSD','desc':'排班表打印','type':'MENU'},
			{'code':'PrintMZD','desc':'麻醉单打印','type':'MENU'},
			{'code':'PrintSSYYDBNZ','desc':'手术条(白内障)','type':'MENU'},
			{'code':'PrintSSYYDTY','desc':'手术条(眼科通用)','type':'MENU'},
			{'code':'PrintMZSSYYD','desc':'门诊预约单打印','type':'MENU'},
			{'code':'AduitAccredit','desc':'科主任授权','type':'MENU'},
			{'code':'MaterialListTotal','desc':'材料清单统计','type':'MENU'},//手术材料清单20191029+dyl
			{'code':'btnAnDocOrdered','desc':'已录麻醉医嘱','type':'BUTTON'},
			{'code':'btnClearRoom','desc':'清空手术间','type':'BUTTON'},
			{'code':'btnDirAudit','desc':'科主任审核','type':'BUTTON'},
			{'code':'btnReOperAudit','desc':'二次审核','type':'BUTTON'},
			{'code':'ChangeOperPlanAudit','desc':'手术方案变更审核','type':'BUTTON'},
			{'code':'CheckRiskAssessment','desc':'手术风险评估','type':'BUTTON'},
			{'code':'CheckSafetyInfo','desc':'手术安全核查','type':'BUTTON'},
			{'code':'OPControlledCost','desc':'可控成本','type':'BUTTON'},
			{'code':'btnCancelOper','desc':'取消手术','type':'BUTTON'},//20161214+dyl
			{'code':'btnOPNurseOrdered','desc':'手术计费','type':'BUTTON'},//20161214+dyl
			{'code':'btnArrAnDocAuto','desc':'同步麻醉医师','type':'BUTTON'},//20181214+dyl
			{'code':'btnArrNurseAuto','desc':'同步器械巡回','type':'BUTTON'},	//20190125+dyl
			{'code':'InRoomCheck','desc':'入室核查','type':'BUTTON'},
			{'code':'OutRoomCheck','desc':'离室核查','type':'BUTTON'},
			{'code':'OperAssess','desc':'麻醉评分','type':'BUTTON'},
			{'code':'RegMaterialList','desc':'手术材料登记','type':'BUTTON'},//手术材料清单20191028+dyl
			{'code':'oproom','desc':'术间','type':'COLUMN'},
			{'code':'opordno','desc':'台次','type':'COLUMN'},
			{'code':'scrubnurse','desc':'器械护士','type':'COLUMN'},
			{'code':'circulnurse','desc':'巡回护士','type':'COLUMN'},
			{'code':'tNurseNote','desc':'护士备注','type':'COLUMN'},
			{'code':'andoc','desc':'麻醉医生','type':'COLUMN'},
			{'code':'tPacuBed','desc':'恢复室床位','type':'COLUMN'},
			{'code':'anmethod','desc':'麻醉方法','type':'COLUMN'}	
       	];
	$("#dlgCaption").combobox({
		valueField:"code",
        textField:"desc",
        data:CaptionList,
       	onSelect:function(record){
	    	$("#dlgName").val(record.code);
       	}
	})
	$("#dlgType").combobox({
		onChange:function(newValue,oldValue){
			if(newValue!=oldValue)
			{
				$("#dlgSeq").combobox('loadData',[]);
				$("#dlgCaption").combobox('loadData',[]);
				$("#dlgSeq").combobox('loadData',SeqList);
				$("#dlgCaption").combobox('loadData',CaptionList);
			}
			
		},
		onSelect:function(){
			if($("#dlgGroup").combobox('getValue')=="")
			{
				$.messager.alert('提示','请先选择安全组！','info');
				$("#dlgType").combobox('setValue','');
			}
			$("#dlgSeq").combobox('setValue','');
			$("#dlgCaption").combobox('setValue','');
			$("#dlgName").val("");
			
			var typeCode=$("#dlgType").combobox('getValue');
			var newCaptionList=[];
			$.each(CaptionList,function(i,row){
				if(row.type==typeCode){
					newCaptionList.push(row);
				}
			})
			$("#dlgCaption").combobox('loadData',newCaptionList);
	
			$.cm({
				ClassName:"web.DHCANOPArrange",
				QueryName:"GetGroupConfig",
				typeCode:$("#dlgType").combobox('getValue'),
            	groupId:$("#dlgGroup").combobox('getValue')
			},function(data){
				for(var n=0;n<data.total;n++)
				{
					var record=data.rows[n];
					var rowId=record.rowId;
					var name=record.name;
					var captions=$("#dlgCaption").combobox('getData');
					var r1=findIndexDatas(captions,'code',name);
					if(r1!=-1)
					{
						captions.splice(r1,1); 
						$("#dlgCaption").combobox('loadData',captions);
					}
					var seqs=$("#dlgSeq").combobox('getData');
					var r2=findIndexDatas(seqs,'code',rowId);
					if(r2!=-1)
					{
						var newSeqs=deleteElementbyIndex(seqs,r2);
						$("#dlgSeq").combobox('loadData',newSeqs);
					}
				}
				
			})
			
		}
		,mode:'remote'
	})
	$("#GroupCaptionBox").datagrid({
		fit: true,
        fitColumns:true,
        singleSelect: true,
        nowrap: false,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
		border:false,			 
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANOPArrange",
            QueryName:"GetGroupConfig"
        },
        onBeforeLoad:function(param){
	    	param.typeCode=$("#Type").combobox('getValue');
            param.groupId=$("#Group").combobox('getValue');
	    },
        columns:[
        [
        	{ field: "rowId", title: "顺序号", width: 120 },
        	{ field: "groupDesc", title: "安全组", width: 120 },
        	{ field: "type", title: "类型", width: 120 },
        	{ field: "name", title: "名称", width: 120 },
        	{ field: "caption", title: "标题", width: 120 }
       	]
       	],
       	toolbar:[
            {
                iconCls:'icon-add',
                text:'新增',
                handler:function(){
                    saveGroupCaptionHandler()
                }
            },
            {
                iconCls:'icon-write-order',
                text:'修改',
                handler:function(){
                    var selectRow=$("#GroupCaptionBox").datagrid('getSelected');
                    if(selectRow)
                    {
	                    saveGroupCaptionHandler(selectRow)
	                }else{
		             	$.messager.alert('提示','请选择要修改的行！','warning')
		             }
                }
            },
            {
                iconCls:'icon-cancel',
                text:'删除',
                handler:function(){
                    var selectRow=$("#GroupCaptionBox").datagrid('getSelected');
                    if(selectRow)
                    {
	                    $.messager.confirm("确认","确认删除安全组："+selectRow.groupDesc+"的"+selectRow.caption,function(r)
	                    {
		                    if(r)
		                    {
			                    var result=$.m({
				                	ClassName:"web.DHCANOPArrange",
				                	MethodName:"DeleteGroupConfig",
				                	groupId:selectRow.groupId, 
				                	typeCode:selectRow.typeCode, 
				                	rowId:selectRow.rowId
				                },false);
				                if(result=='0')
				                {
					             
									$.messager.alert('提示','信息删除成功','info');
		 							$("#Group").combobox('setValue',"");
		 							$("#Type").combobox('setValue',"");
		 							$("#GroupCaptionBox").datagrid('reload');
					            }else{
						            $.messager.alert('错误','信息删除失败！','warning');
						            return;
						        }
			                }
		                });
	                }
                }
            }
        ]
        
	});
	$("#btnSearch").click(function(){
		$("#GroupCaptionBox").datagrid('reload');
	})
})

function saveGroupCaptionHandler(selectRow){
	var titleName="新增安全组配置";
	if(selectRow)
	{
		titleName="修改安全组配置";
		$("#dlgRowId").val(selectRow.rowId);
		$("#dlgGroup").combobox('setValue',selectRow.groupId);
		$("#dlgType").combobox('setValue',selectRow.typeCode);
		$("#dlgSeq").combobox('setValue',selectRow.rowId);
		$("#dlgCaption").combobox('setValue',selectRow.name);
		$("#dlgCaption").combobox('setText',selectRow.caption);
		$("#dlgName").val(selectRow.name);
	}					
	$("#CaptionDialog").show();
	$("#CaptionDialog").dialog({
        iconCls:'icon-w-save',
        title:titleName,
        resizable:true,
        modal:true,
        buttons:[
            {
				text:'保存',
				handler:function(){
                    saveGroupCaption();
                }
            },
            {
				text:'关闭',
				handler:function(){
					
                    $("#CaptionDialog").dialog('close');
                }
            }
        ],
        onBeforeClose:function(){
	       	$("#conditionForm").form('clear');
	    },
	    onBeforeOpen:function(){
			$('#dlgGroup').combobox("reload");
			$('#dlgType').combobox("reload");
			$('#dlgSeq').combobox("reload");
			$('#dlgCaption').combobox("reload");
		}
    })
    $('#CaptionDialog').window('center')
}

function saveGroupCaption(){
	var winRowId=$("#dlgRowId").val();
	var groupId=$("#dlgGroup").combobox('getValue');
	var typeCode=$("#dlgType").combobox('getValue');
	var rowId=$("#dlgSeq").combobox('getValue');
	var caption=$("#dlgCaption").combobox('getText');
	var name=$("#dlgName").val();
	var str=name+"^"+caption;
	if(groupId=="")
	{
		$.messager.alert('提示','请选择安全组！','warning');
		return;
	}
	if(typeCode=="")
	{
		$.messager.alert('提示','请选择元素类型！','warning');
		return;
	}
	if(rowId=="")
	{
		$.messager.alert('提示','请选择元素顺序！','warning');
		return;
	}
	var result=0;
	if(winRowId=="")
	{
		result=$.m({
			ClassName:"web.DHCANOPArrange",
			MethodName:"InsertGroupConfig",
			groupId:groupId,
			typeCode:typeCode, 
			rowId:rowId,
			str:str
		},false);
		
	}else{
		result=$.m({
			ClassName:"web.DHCANOPArrange",
			MethodName:"UpdateGroupConfig",
			groupId:groupId,
			typeCode:typeCode, 
			oriRowId:winRowId,
			rowId:rowId,
			str:str
		},false);
	}
	if(result!=0)
		{
			$.messager.alert('错误',ret,'warning');
			return ;
		}
		 $("#CaptionDialog").dialog('close');
		 $("#Group").combobox('setValue',"");
		 $("#Type").combobox('setValue',"");
		 $("#GroupCaptionBox").datagrid('reload');
	
}
//查找当前值所在数组的index
function findIndexDatas(datas,code,value)
{
	var index=-1;
	for(var i=0;i<datas.length;i++)
	{
		for(var key in datas[i])
		{
			if(key==code)
			{
				if(datas[i][key]==value)
				{
					index=i;
					break;
				}
			}
		}
		if(index!=-1) break;
	}
	return index;
}
//删除数组中的元素
function deleteElementbyIndex(tArray,index)
{
	 try{
			var newArray=[],index=index-0;
			for(var i=0;i<tArray.length;i++){
				if(i!=index){
					newArray.push(tArray[i]);
				}else{
					continue;
				}
			
			}
		}catch(e){
			console.error("删除错误:",e) 
		}
	 return newArray;
} 