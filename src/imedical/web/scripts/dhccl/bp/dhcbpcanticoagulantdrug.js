///combobox不是选择，下拉框提示
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
		$(item).combobox("clear");	    
	    $(item).combobox("reload");
	    if ((val==undefined)&&(txt!=""))
	    {
		    $(item).combobox('setValue',"");
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
///combogrid不是选择，多选下拉框提示
function OnHidePanel3(item)
{
	var idField = $(item).combogrid("options").idField;
	var vals = $(item).combogrid("getValues");  //当前combobox的值
	var txt = $(item).combogrid("getText");
	var allData = $(item).combogrid("grid").datagrid('getSelections');   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	for (var i = 0; i < allData.length; i++) {
		for (var j = 0; j < vals.length; j++) 
		{
			if (vals[j] == allData[i][idField]) {
	    		result = false;
	    		break;
	    	}
		}
	}
	if (result) {
	    if ((vals.length==0)&&(txt!=""))
	    {
		    $(item).combobox("clear");	    
	    	$(item).combobox("reload");
		    $(item).combobox('setValue',"");
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
$(function(){
	//20181219+dyl
	//是否显示
	$HUI.combobox("#drugConcentration,#totalAmount,#FirstAmount,#drugDosage,#note,#drugFrequency,#bpCADDuration,#bpCADIntervalMinute",{
        valueField:"id",
        textField:"desc",
        panelHeight:'auto',
        data:[{'id':"-1",'desc':"不显示"}],
        onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
    })
    //分类
    $HUI.combobox("#bpCADCat",{
        valueField:"desc",
        textField:"id",
        data:[
        {'id':"组1",'desc':"1"},
        {'id':"组2",'desc':"2"},
        {'id':"组3",'desc':"3"},
        {'id':"组4",'desc':"4"},
        {'id':"组5",'desc':"5"},
        {'id':"组6",'desc':"6"},
        {'id':"组7",'desc':"7"},
        {'id':"组8",'desc':"8"},
        {'id':"组9",'desc':"9"},
        {'id':"组10",'desc':"10"},
        ],
        onHidePanel: function () {	        
        	OnHidePanel("#bpCADCat");
        },
    })
    //科室
    $HUI.combobox("#ctlocdesc",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=ctloclookup&ResultSetType=array",
			textField:"oprCtLoc",
			valueField:"oprLocId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				},
			onHidePanel: function () {	        
        		OnHidePanel("#ctlocdesc");
        	},
			})
    //单位
    $HUI.combobox("#drugUnit",{
		url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindUomList&ResultSetType=array",
		textField:"Desc",
		valueField:"Id",
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
		},
		onHidePanel: function () {	        
        	OnHidePanel("#drugUnit");
        },
	})
	//速度
    $HUI.combobox("#bpCADrSU",{
		url:$URL+"?ClassName=web.DHCBPCom&QueryName=FindSUnitList&ResultSetType=array",
		textField:"Desc",
		valueField:"Id",
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
		},
		onHidePanel: function () {	        
        	OnHidePanel("#bpCADrSU");
        },
	})
	//抗凝方式
	$HUI.combogrid("#AnticoagulantMode",{
			idField:"tBPCAMRowId",
			textField:"tBPCAMDesc",
			mode:"remote",
			multiple:true,
			url:$URL,  //"dhcclinic.jquery.csp",
			queryParams:{
				ClassName:"web.DHCBPCAnticoagulantMode",
				QueryName:"FindAntMode",
				ctlocId:""
				
				},
			columns:[[
			{filed:"ck",checkbox:true,width:0},
			//{field:"tBPCBPMRowId",title:"Id",width:60},
			{field:"tBPCAMDesc",title:"抗凝方式"}
			]],
			onHidePanel: function () {	        
        		OnHidePanel3("#AnticoagulantMode");
        	},
			
			
	})
	function setDialogValue()
	{	
		$("#drugCode").val("");
		$("#drugName").val("");
		$("#totalAmount").combobox('setValue',"")		
		$("#drugConcentration").combobox('setValue',"")
		$("#drugUnit").combobox('setValue',"")
		$("#FirstAmount").combobox('setValue',"")		
		$("#drugDosage").combobox('setValue',"")
		$("#drugFrequency").combobox('setValue',"")
		$("#note").combobox('setValue',"")		
		$("#AnticoagulantMode").combobox('setValue',"")
		$("#ctlocdesc").combobox('setValue',"");
		$("#bpCADrSU").combobox('setValue',"")
		$("#bpCADDuration").combobox('setValue',"")		
		$("#bpCADIntervalMinute").combobox('setValue',"")
		$("#bpCADCat").combobox('setValue',"")
	}
	var InsertHandler=function(){
		$("#anticoagulantdrugDlg").show();
		var anticoagulantdrugDlgObj=$HUI.dialog("#anticoagulantdrugDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增抗凝药物与抗凝方式',
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){

						if($("#drugCode").val()==""){
							$.messager.alert("提示","代码不能为空!", "error");
							return;
						}
						if($("#drugName").val()==""){
							$.messager.alert("提示","名称不能为空!", "error");
							return;
						}
						var drugCode=$("#drugCode").val();
						var drugName=$("#drugName").val();
						var totalAmount=$("#totalAmount").combobox('getValue');
						var drugConcentration=$("#drugConcentration").combobox('getValue');
						var drugUnit=$("#drugUnit").combobox('getValue');
						if(($("#drugUnit").combobox('getText')=="")||($("#drugUnit").combobox('getValue')==undefined)) var drugUnit="";
						var FirstAmount=$("#FirstAmount").combobox('getValue');
						var drugDosage=$("#drugDosage").combobox('getValue');
						var drugFrequency=$("#drugFrequency").combobox('getValue');
						var note=$("#note").combobox('getValue');
						//var AnticoagulantMode=$("#AnticoagulantMode").combobox('getValue');
						var AnticoagulantMode=$("#AnticoagulantMode").combogrid('grid').datagrid('getSelections')
						var r=""
						if (AnticoagulantMode.length>0)
						{
							var r=AnticoagulantMode[0].tBPCAMRowId;					
							for(var i=1;i<AnticoagulantMode.length;i++)
							{
								r=r+","+AnticoagulantMode[i].tBPCAMRowId
							}
						}
						var AnticoagulantMode=r;
						var ctloc=$("#ctlocdesc").combobox('getValue');
						if(($("#ctlocdesc").combobox('getText')=="")||($("#ctlocdesc").combobox('getValue')==undefined)) var ctloc="";
						var bpCADrSU=$("#bpCADrSU").combobox('getValue');
						if(($("#bpCADrSU").combobox('getText')=="")||($("#bpCADrSU").combobox('getValue')==undefined)) var bpCADrSU="";
						var bpCADDuration=$("#bpCADDuration").combobox('getValue');
						var bpCADIntervalMinute=$("#bpCADIntervalMinute").combobox('getValue');
						var bpCADCat=$("#bpCADCat").combobox('getValue');
						if(($("#bpCADCat").combobox('getText')=="")||($("#bpCADCat").combobox('getValue')==undefined)) var bpCADCat="";
						var paraStr=drugCode+"^"+drugName+"^"+totalAmount+"^"+drugConcentration+"^"+drugUnit+"^"+FirstAmount+"^"+drugDosage+"^"+drugFrequency+"^"+note+"^"+AnticoagulantMode+"^"+ctloc+"^"+bpCADrSU+"^"+bpCADDuration+"^"+bpCADIntervalMinute+"^"+bpCADCat
						$.m({
							ClassName:"web.DHCBPCAnticoagulantDrug",
							MethodName:"InsertAnticoagulantDrug",
							bpcADInfoList:paraStr,
							hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								anticoagulantdrugDlgObj.close();
								anticoagulantDrugBoxObj.load();
							}else
							{
								$.messager.alert("提示","抗凝药物与抗凝方式添加失败！"+success, "error");
							}
						})			
				}
			},{
				text:"关闭",
				handler:function(){
					anticoagulantdrugDlgObj.close();
				}
			}]
		})
	}
	var UpdateHandler=function(row)
	{
		var Mode=[]
		Mode=row.tBPCAMIdList.split(",")
		$("#drugCode").val(row.tBPCADCode);
		$("#drugName").val(row.tBPCADDesc);
		$("#totalAmount").combobox('setValue',row.tBPCADAmount)		
		$("#drugConcentration").combobox('setValue',row.tBPCADConcentration)
		$("#drugUnit").combobox('setValue',row.tBPCADUomDr)
		$("#FirstAmount").combobox('setValue',row.tBPCADFirstAmount)		
		$("#drugDosage").combobox('setValue',row.tBPCADDose)
		$("#drugFrequency").combobox('setValue',row.tBPCADFrequency)
		$("#note").combobox('setValue',row.tBPCADNote)		
		$("#AnticoagulantMode").combogrid('setValues',Mode)		
		$("#ctlocdesc").combobox('setValue',row.tBPCDeptId);
		$("#bpCADrSU").combobox('setValue',row.tBPCADrSUDr)
		$("#bpCADDuration").combobox('setValue',row.tBPCADDuration)		
		$("#bpCADIntervalMinute").combobox('setValue',row.tBPCADIntervalMinute)
		$("#bpCADCat").combobox('setValue',row.tBPCADCatDr)


		
		$("#anticoagulantdrugDlg").show();
		var anticoagulantdrugDlgObj=$HUI.dialog("#anticoagulantdrugDlg",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'修改抗凝药物与抗凝方式',
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){
						if($("#drugCode").val()==""){
							$.messager.alert("提示","代码不能为空!", "error");
							return;
						}
						if($("#drugName").val()==""){
							$.messager.alert("提示","名称不能为空!", "error");
							return;
						}
						var drugCode=$("#drugCode").val();
						var drugName=$("#drugName").val();
						var totalAmount=$("#totalAmount").combobox('getValue');
						if(($("#totalAmount").combobox('getText')=="")||($("#totalAmount").combobox('getValue')==undefined)) var totalAmount="";
						var drugConcentration=$("#drugConcentration").combobox('getValue');
						if(($("#drugConcentration").combobox('getText')=="")||($("#drugConcentration").combobox('getValue')==undefined)) var drugConcentration="";
						var drugUnit=$("#drugUnit").combobox('getValue');						
						if(($("#drugUnit").combobox('getText')=="")||($("#drugUnit").combobox('getValue')==undefined)) var drugUnit="";
						var FirstAmount=$("#FirstAmount").combobox('getValue');
						if(($("#FirstAmount").combobox('getText')=="")||($("#FirstAmount").combobox('getValue')==undefined)) var FirstAmount="";
						var drugDosage=$("#drugDosage").combobox('getValue');
						if(($("#drugDosage").combobox('getText')=="")||($("#drugDosage").combobox('getValue')==undefined)) var drugDosage="";
						var drugFrequency=$("#drugFrequency").combobox('getValue');
						if(($("#drugFrequency").combobox('getText')=="")||($("#drugFrequency").combobox('getValue')==undefined)) var drugFrequency="";
						var note=$("#note").combobox('getValue');
						if(($("#note").combobox('getText')=="")||($("#note").combobox('getValue')==undefined)) var note="";
						//var AnticoagulantMode=$("#AnticoagulantMode").combobox('getValue');
						var AnticoagulantMode=$("#AnticoagulantMode").combogrid('grid').datagrid('getSelections')
						var r="";
						if(AnticoagulantMode.length>0)
						{
							r=AnticoagulantMode[0].tBPCAMRowId;					
							for(var i=1;i<AnticoagulantMode.length;i++)
							{
								r=r+","+AnticoagulantMode[i].tBPCAMRowId
							}
						}
						var AnticoagulantMode=r;
						var ctloc=$("#ctlocdesc").combobox('getValue');
						if(($("#ctlocdesc").combobox('getText')=="")||($("#ctlocdesc").combobox('getValue')==undefined)) var ctloc="";											
						var bpCADrSU=$("#bpCADrSU").combobox('getValue');
						if(($("#bpCADrSU").combobox('getText')=="")||($("#bpCADrSU").combobox('getValue')==undefined)) var bpCADrSU="";
						var bpCADDuration=$("#bpCADDuration").combobox('getValue');
						if(($("#bpCADDuration").combobox('getText')=="")||($("#bpCADDuration").combobox('getValue')==undefined)) var bpCADDuration="";
						var bpCADIntervalMinute=$("#bpCADIntervalMinute").combobox('getValue');
						if(($("#bpCADIntervalMinute").combobox('getText')=="")||($("#bpCADIntervalMinute").combobox('getValue')==undefined)) var bpCADIntervalMinute="";
						var bpCADCat=$("#bpCADCat").combobox('getValue');
						if(($("#bpCADCat").combobox('getText')=="")||($("#bpCADCat").combobox('getValue')==undefined)) var bpCADCat="";
					var paraStr=row.tID+"^"+drugCode+"^"+drugName+"^"+totalAmount+"^"+drugConcentration+"^"+drugUnit+"^"+FirstAmount+"^"+drugDosage+"^"+drugFrequency+"^"+note+"^"+AnticoagulantMode+"^"+ctloc+"^"+bpCADrSU+"^"+bpCADDuration+"^"+bpCADIntervalMinute+"^"+bpCADCat
					var data=$.m({
							ClassName:"web.DHCBPCAnticoagulantDrug",
							MethodName:"UpdateAnticoagulantDrug",
							bpcADInfoList:paraStr,
							hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								anticoagulantdrugDlgObj.close();
								anticoagulantDrugBoxObj.load();
							}else{
								$.messager.alert("提示","抗凝药物与抗凝方式更新失败！"+success, "error");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					anticoagulantdrugDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            } 
		})
	}
	var anticoagulantDrugBoxObj=$HUI.datagrid("#anticoagulantDrugBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCAnticoagulantDrug",
			QueryName:"FindAnticoagulantDrug",
			hospId:session['LOGON.HOSPID']
		},
        columns:[[
        	{ field: "tID", title: "编号", width: 70 },
            { field: "tBPCADCode", title: "代码", width: 180 },
            { field: "tBPCADDesc", title: "名称", width: 180 },
            { field: "tBPCADUomDr", title: "tBPCADUomDr", width: 90 ,hidden:true},
			{ field: "tBPCADUomDesc", title: "单位", width: 90 },
			{ field: "tBPCADConcentration", title: "tBPCADConcentration", width: 90 ,hidden:true},
			{ field: "tBPCADConcentrationDesc", title: "浓度", width: 90 },
			{ field: "tBPCADAmount", title: "tBPCADAmount", width: 90 ,hidden:true},
			{ field: "tBPCADAmountDesc", title: "总量", width: 90 },
			{ field: "tBPCADFirstAmount", title: "tBPCADFirstAmount", width: 90 ,hidden:true},
            { field: "tBPCADFirstAmountDesc", title: "首推量", width: 90 },
            { field: "tBPCADDose", title: "tBPCADDose", width: 90 ,hidden:true},
			{ field: "tBPCADDoseDesc", title: "剂量", width: 90 },
			{ field: "tBPCADFrequency", title: "tBPCADFrequency", width: 90 ,hidden:true},
			{ field: "tBPCADFrequencyDesc", title: "频率", width: 90 },			
            { field: "tBPCAMIdList", title: "tBPCAMIdList", width: 90 ,hidden:true},
			{ field: "tBPCAMDescList", title: "抗凝方式", width: 90 },
			{ field: "tBPCADNote", title: "tBPCADNote", width: 90 ,hidden:true},
            { field: "tBPCADNoteDesc", title: "备注", width: 90 },
            { field: "tBPCDeptId", title: "tBPCDeptId", width: 90 ,hidden:true},
            { field: "tBPCDept", title: "科室", width: 90 },            
            { field: "tBPCADrSUDr", title: "速度", width: 90 ,hidden:true},
			{ field: "tBPCADrSUDesc", title: "速度", width: 90 },
			{ field: "tBPCADDuration", title: "tBPCADDuration", width: 90 ,hidden:true},
			{ field: "tBPCADDurationDesc", title: "持续时间", width: 90 },
			{ field: "tBPCADIntervalMinute", title: "tBPCADIntervalMinute", width: 90 ,hidden:true},
			{ field: "tBPCADIntervalMinuteDesc", title: "间隔分钟", width: 90 },
			{ field: "tBPCADCatDr", title: "tBPCADCatDr", width: 90 ,hidden:true},
			{ field: "tBPCADCatDesc", title: "分类", width: 90 },
			
        ]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		//rows:20,
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyui取消单击行选中状态
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		toolbar:[{
			iconCls: 'icon-add',
		    text:'新增',
		    handler: function(){
				InsertHandler();
			}
		},{
	        iconCls: 'icon-write-order',
	        text:'修改',
		    handler: function(){
				var row=anticoagulantDrugBoxObj.getSelected();
				if(row)
				{
					UpdateHandler(row);
				}
			}
        },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=anticoagulantDrugBoxObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确认删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCAnticoagulantDrug",
								MethodName:"DeleteAnticoagulantDrug",
								bpcADId:row.tID
							},function(success)
							{
								if(success==0)
								{
									anticoagulantDrugBoxObj.load();
								}else{
									$.messager.alert("提示","删除失败，错误代码："+success);
								}
							})
						}
					})
				}
		}
		}]
	})
});