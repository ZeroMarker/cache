///combobox����ѡ����������ʾ
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //��ǰcombobox��ֵ
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
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
	    	$.messager.alert("��ʾ","���������ѡ��","error");
	    	return;
	    }
	}
}
///combogrid����ѡ�񣬶�ѡ��������ʾ
function OnHidePanel3(item)
{
	var idField = $(item).combogrid("options").idField;
	var vals = $(item).combogrid("getValues");  //��ǰcombobox��ֵ
	var txt = $(item).combogrid("getText");
	var allData = $(item).combogrid("grid").datagrid('getSelections');   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
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
	    	$.messager.alert("��ʾ","���������ѡ��","error");
	    	return;
	    }
	}
}
$(function(){
	//20181219+dyl
	//�Ƿ���ʾ
	$HUI.combobox("#drugConcentration,#totalAmount,#FirstAmount,#drugDosage,#note,#drugFrequency,#bpCADDuration,#bpCADIntervalMinute",{
        valueField:"id",
        textField:"desc",
        panelHeight:'auto',
        data:[{'id':"-1",'desc':"����ʾ"}],
        onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
    })
    //����
    $HUI.combobox("#bpCADCat",{
        valueField:"desc",
        textField:"id",
        data:[
        {'id':"��1",'desc':"1"},
        {'id':"��2",'desc':"2"},
        {'id':"��3",'desc':"3"},
        {'id':"��4",'desc':"4"},
        {'id':"��5",'desc':"5"},
        {'id':"��6",'desc':"6"},
        {'id':"��7",'desc':"7"},
        {'id':"��8",'desc':"8"},
        {'id':"��9",'desc':"9"},
        {'id':"��10",'desc':"10"},
        ],
        onHidePanel: function () {	        
        	OnHidePanel("#bpCADCat");
        },
    })
    //����
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
    //��λ
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
	//�ٶ�
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
	//������ʽ
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
			{field:"tBPCAMDesc",title:"������ʽ"}
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
			title:'��������ҩ���뿹����ʽ',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){

						if($("#drugCode").val()==""){
							$.messager.alert("��ʾ","���벻��Ϊ��!", "error");
							return;
						}
						if($("#drugName").val()==""){
							$.messager.alert("��ʾ","���Ʋ���Ϊ��!", "error");
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
								$.messager.alert("��ʾ","����ҩ���뿹����ʽ���ʧ�ܣ�"+success, "error");
							}
						})			
				}
			},{
				text:"�ر�",
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
			title:'�޸Ŀ���ҩ���뿹����ʽ',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
						if($("#drugCode").val()==""){
							$.messager.alert("��ʾ","���벻��Ϊ��!", "error");
							return;
						}
						if($("#drugName").val()==""){
							$.messager.alert("��ʾ","���Ʋ���Ϊ��!", "error");
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
								$.messager.alert("��ʾ","����ҩ���뿹����ʽ����ʧ�ܣ�"+success, "error");
						}
						
					})
				}
			},{
				text:"�ر�",
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
        	{ field: "tID", title: "���", width: 70 },
            { field: "tBPCADCode", title: "����", width: 180 },
            { field: "tBPCADDesc", title: "����", width: 180 },
            { field: "tBPCADUomDr", title: "tBPCADUomDr", width: 90 ,hidden:true},
			{ field: "tBPCADUomDesc", title: "��λ", width: 90 },
			{ field: "tBPCADConcentration", title: "tBPCADConcentration", width: 90 ,hidden:true},
			{ field: "tBPCADConcentrationDesc", title: "Ũ��", width: 90 },
			{ field: "tBPCADAmount", title: "tBPCADAmount", width: 90 ,hidden:true},
			{ field: "tBPCADAmountDesc", title: "����", width: 90 },
			{ field: "tBPCADFirstAmount", title: "tBPCADFirstAmount", width: 90 ,hidden:true},
            { field: "tBPCADFirstAmountDesc", title: "������", width: 90 },
            { field: "tBPCADDose", title: "tBPCADDose", width: 90 ,hidden:true},
			{ field: "tBPCADDoseDesc", title: "����", width: 90 },
			{ field: "tBPCADFrequency", title: "tBPCADFrequency", width: 90 ,hidden:true},
			{ field: "tBPCADFrequencyDesc", title: "Ƶ��", width: 90 },			
            { field: "tBPCAMIdList", title: "tBPCAMIdList", width: 90 ,hidden:true},
			{ field: "tBPCAMDescList", title: "������ʽ", width: 90 },
			{ field: "tBPCADNote", title: "tBPCADNote", width: 90 ,hidden:true},
            { field: "tBPCADNoteDesc", title: "��ע", width: 90 },
            { field: "tBPCDeptId", title: "tBPCDeptId", width: 90 ,hidden:true},
            { field: "tBPCDept", title: "����", width: 90 },            
            { field: "tBPCADrSUDr", title: "�ٶ�", width: 90 ,hidden:true},
			{ field: "tBPCADrSUDesc", title: "�ٶ�", width: 90 },
			{ field: "tBPCADDuration", title: "tBPCADDuration", width: 90 ,hidden:true},
			{ field: "tBPCADDurationDesc", title: "����ʱ��", width: 90 },
			{ field: "tBPCADIntervalMinute", title: "tBPCADIntervalMinute", width: 90 ,hidden:true},
			{ field: "tBPCADIntervalMinuteDesc", title: "�������", width: 90 },
			{ field: "tBPCADCatDr", title: "tBPCADCatDr", width: 90 ,hidden:true},
			{ field: "tBPCADCatDesc", title: "����", width: 90 },
			
        ]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		//rows:20,
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyuiȡ��������ѡ��״̬
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		toolbar:[{
			iconCls: 'icon-add',
		    text:'����',
		    handler: function(){
				InsertHandler();
			}
		},{
	        iconCls: 'icon-write-order',
	        text:'�޸�',
		    handler: function(){
				var row=anticoagulantDrugBoxObj.getSelected();
				if(row)
				{
					UpdateHandler(row);
				}
			}
        },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=anticoagulantDrugBoxObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
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
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success);
								}
							})
						}
					})
				}
		}
		}]
	})
});