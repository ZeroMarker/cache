   
 		
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
			{"code":"MENU","desc":"�˵�"},
			{"code":"BUTTON","desc":"��ť"},
			{"code":"COLUMN","desc":"�ɼ�����"}
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
		    	$.messager.alert("����","��ȷ����ȫ������Ͳ�Ϊ��!","warning");
				$(this).combobox('setValue','');
		    }
	    }
	});
	var CaptionList=[
       		{'code':'AppOper','desc':'��������','type':'MENU'},
			{'code':'AppOperClinics','desc':'������������','type':'MENU'},
			{'code':'AppIntervent','desc':'��������(����)','type':'MENU'}, 
			{'code':'AlterDayOper','desc':'���ռ������޸�','type':'MENU'},	
			{'code':'AlterOper','desc':'�޸���������','type':'MENU'},
			{'code':'ConfirmDayOper','desc':'���ռ�����ȷ��','type':'MENU'},
			{'code':'UpdateOperClinics','desc':'�޸�������������','type':'MENU'}, 
			{'code':'UpdateOpIntervent','desc':'�޸���������(����)','type':'MENU'}, 	
			{'code':'ArrOper','desc':'��������','type':'MENU'},
			{'code':'ANAuditDayOper','desc':'���ռ�������ǰ����','type':'MENU'},
			{'code':'ANPostDayOperAcess','desc':'�ռ�����ָ�����','type':'MENU'},
			{'code':'ANDayOutAcess','desc':'�ռ��Ժ����','type':'MENU'},
			{'code':'ArrOperClinics','desc':'��������(����)','type':'MENU'},
			{'code':'ArrOperIntervent','desc':'��������(����)','type':'MENU'}, 
			{'code':'DHCANOPNurseRecord','desc':'����������ӵ�','type':'MENU'},
			{'code':'RefuseOper','desc':'����ֹͣ','type':'MENU'},
			{'code':'CancelRef','desc':'����ֹͣ','type':'MENU'},
			{'code':'ArrAn','desc':'������','type':'MENU'},
			{'code':'AnConsent','desc':'����֪��ͬ����','type':'MENU'},
			{'code':'PreOpAssessment','desc':'��ǰ����','type':'MENU'},
			{'code':'MonAn','desc':'�������','type':'MENU'},
			{'code':'AnRecord','desc':'�����¼��ϸ','type':'MENU'},
			{'code':'PACURecord','desc':'����ָ���','type':'MENU'},
			{'code':'PostOpRecord','desc':'�������','type':'MENU'},
			{'code':'ANOPCount','desc':'�������','type':'MENU'},
			{'code':'RegOper','desc':'����Ǽ�','type':'MENU'},
			{'code':'NotAppRegOper','desc':'��ԤԼ�����Ǽ�','type':'MENU'},
			{'code':'AlterNotAppRegOper','desc':'��ԤԼ�����Ǽ��޸�','type':'MENU'},
			{'code':'RegOperClinics','desc':'����Ǽ�(����)','type':'MENU'},
			{'code':'PrintSQD','desc':'����������ӡ','type':'MENU'},
			{'code':'PrintSSD','desc':'�Ű���ӡ','type':'MENU'},
			{'code':'PrintMZD','desc':'������ӡ','type':'MENU'},
			{'code':'PrintSSYYDBNZ','desc':'������(������)','type':'MENU'},
			{'code':'PrintSSYYDTY','desc':'������(�ۿ�ͨ��)','type':'MENU'},
			{'code':'PrintMZSSYYD','desc':'����ԤԼ����ӡ','type':'MENU'},
			{'code':'AduitAccredit','desc':'��������Ȩ','type':'MENU'},
			{'code':'MaterialListTotal','desc':'�����嵥ͳ��','type':'MENU'},//���������嵥20191029+dyl
			{'code':'btnAnDocOrdered','desc':'��¼����ҽ��','type':'BUTTON'},
			{'code':'btnClearRoom','desc':'���������','type':'BUTTON'},
			{'code':'btnDirAudit','desc':'���������','type':'BUTTON'},
			{'code':'btnReOperAudit','desc':'�������','type':'BUTTON'},
			{'code':'ChangeOperPlanAudit','desc':'��������������','type':'BUTTON'},
			{'code':'CheckRiskAssessment','desc':'������������','type':'BUTTON'},
			{'code':'CheckSafetyInfo','desc':'������ȫ�˲�','type':'BUTTON'},
			{'code':'OPControlledCost','desc':'�ɿسɱ�','type':'BUTTON'},
			{'code':'btnCancelOper','desc':'ȡ������','type':'BUTTON'},//20161214+dyl
			{'code':'btnOPNurseOrdered','desc':'�����Ʒ�','type':'BUTTON'},//20161214+dyl
			{'code':'btnArrAnDocAuto','desc':'ͬ������ҽʦ','type':'BUTTON'},//20181214+dyl
			{'code':'btnArrNurseAuto','desc':'ͬ����еѲ��','type':'BUTTON'},	//20190125+dyl
			{'code':'InRoomCheck','desc':'���Һ˲�','type':'BUTTON'},
			{'code':'OutRoomCheck','desc':'���Һ˲�','type':'BUTTON'},
			{'code':'OperAssess','desc':'��������','type':'BUTTON'},
			{'code':'RegMaterialList','desc':'�������ϵǼ�','type':'BUTTON'},//���������嵥20191028+dyl
			{'code':'oproom','desc':'����','type':'COLUMN'},
			{'code':'opordno','desc':'̨��','type':'COLUMN'},
			{'code':'scrubnurse','desc':'��е��ʿ','type':'COLUMN'},
			{'code':'circulnurse','desc':'Ѳ�ػ�ʿ','type':'COLUMN'},
			{'code':'tNurseNote','desc':'��ʿ��ע','type':'COLUMN'},
			{'code':'andoc','desc':'����ҽ��','type':'COLUMN'},
			{'code':'tPacuBed','desc':'�ָ��Ҵ�λ','type':'COLUMN'},
			{'code':'anmethod','desc':'������','type':'COLUMN'}	
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
				$.messager.alert('��ʾ','����ѡ��ȫ�飡','info');
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
        	{ field: "rowId", title: "˳���", width: 120 },
        	{ field: "groupDesc", title: "��ȫ��", width: 120 },
        	{ field: "type", title: "����", width: 120 },
        	{ field: "name", title: "����", width: 120 },
        	{ field: "caption", title: "����", width: 120 }
       	]
       	],
       	toolbar:[
            {
                iconCls:'icon-add',
                text:'����',
                handler:function(){
                    saveGroupCaptionHandler()
                }
            },
            {
                iconCls:'icon-write-order',
                text:'�޸�',
                handler:function(){
                    var selectRow=$("#GroupCaptionBox").datagrid('getSelected');
                    if(selectRow)
                    {
	                    saveGroupCaptionHandler(selectRow)
	                }else{
		             	$.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵ��У�','warning')
		             }
                }
            },
            {
                iconCls:'icon-cancel',
                text:'ɾ��',
                handler:function(){
                    var selectRow=$("#GroupCaptionBox").datagrid('getSelected');
                    if(selectRow)
                    {
	                    $.messager.confirm("ȷ��","ȷ��ɾ����ȫ�飺"+selectRow.groupDesc+"��"+selectRow.caption,function(r)
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
					             
									$.messager.alert('��ʾ','��Ϣɾ���ɹ�','info');
		 							$("#Group").combobox('setValue',"");
		 							$("#Type").combobox('setValue',"");
		 							$("#GroupCaptionBox").datagrid('reload');
					            }else{
						            $.messager.alert('����','��Ϣɾ��ʧ�ܣ�','warning');
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
	var titleName="������ȫ������";
	if(selectRow)
	{
		titleName="�޸İ�ȫ������";
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
				text:'����',
				handler:function(){
                    saveGroupCaption();
                }
            },
            {
				text:'�ر�',
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
		$.messager.alert('��ʾ','��ѡ��ȫ�飡','warning');
		return;
	}
	if(typeCode=="")
	{
		$.messager.alert('��ʾ','��ѡ��Ԫ�����ͣ�','warning');
		return;
	}
	if(rowId=="")
	{
		$.messager.alert('��ʾ','��ѡ��Ԫ��˳��','warning');
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
			$.messager.alert('����',ret,'warning');
			return ;
		}
		 $("#CaptionDialog").dialog('close');
		 $("#Group").combobox('setValue',"");
		 $("#Type").combobox('setValue',"");
		 $("#GroupCaptionBox").datagrid('reload');
	
}
//���ҵ�ǰֵ���������index
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
//ɾ�������е�Ԫ��
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
			console.error("ɾ������:",e) 
		}
	 return newArray;
} 