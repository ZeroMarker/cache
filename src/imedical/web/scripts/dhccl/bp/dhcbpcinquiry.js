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
///combobox����ѡ��ҽ����������ʾ
function OnHidePanel2(item)
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
	    $(item).combobox('setValue',"");
	    $.messager.alert("��ʾ","���������ѡ��","error");
	    return;
	}
}
$(function(){ 
	var bpciRowid="1";  	
	//����
	var inquiryLocObj=$HUI.combobox("#SearchBPCICtloc,#BPCICtloc",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=ctloclookup&ResultSetType=array",
			textField:"oprCtLoc",
			valueField:"oprLocId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {	        
        		OnHidePanel($(this));
        	},
	})
	//״̬
	var inquiryStatusObj=$HUI.combobox("#BPCIStatus",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=Statuslookup&ResultSetType=array",
			textField:"StatusDesc",
			valueField:"StatusCode",
			panelHeight:"auto",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {	        
        		OnHidePanel($(this));
        	},
	})	
	//����
	$HUI.combobox("#BPCIType",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:"auto",
        data:[{'Code':"A",'Desc':"All"}
        ,{'Code':"L",'Desc':"Location"}
        ,{'Code':"U",'Desc':"User"}
        ,{'Code':"S",'Desc':"SelfDefine"}
        ,{'Code':"D",'Desc':"DataDefine"}],
        onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
    })
    //ͳ������
	$HUI.combobox("#BPCIDataType",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:"auto",
        data:[{'Code':"P",'Desc':"Patient"}
        ,{'Code':"M",'Desc':"MultiPatient"}
        ,{'Code':"L",'Desc':"Location"}
        ,{'Code':"S",'Desc':"Summary"}
        ,{'Code':"C",'Desc':"CRF"}],
        onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
    })   
	//��׼����ҽ��
	var ICUCIICodeObj=$HUI.combobox("#BPCIIRefBpriId",{
		url:$URL+"?ClassName=web.DHCBPCRecordItem&QueryName=FindBPCReItem&ResultSetType=array",
		valueField:'tRowId',
		textField:'tBPCRIDesc',
		onBeforeLoad:function(param){
			param.BPCRIDesc=param.q;
		},
		onHidePanel: function () {	        
        	OnHidePanel2($(this));
        },
		mode:'remote'  //�û������ֵ���ᱻ��Ϊ��Ϊ 'q' �� http ����������͵����������Ի�ȡ�µ����ݡ�
	})
	//����
	var ICUCIICodeObj=$HUI.combobox("#BPCIICode",{
		url:$URL+"?ClassName=web.DHCBPCRecordItem&QueryName=FindBPCReItem&ResultSetType=array",
		valueField:'tRowId',
		textField:'tBPCRICode',
		onBeforeLoad:function(param){
			param.BPCRIDesc=param.q;
		},
		mode:'remote'  //�û������ֵ���ᱻ��Ϊ��Ϊ 'q' �� http ����������͵����������Ի�ȡ�µ����ݡ�
	})
	//����
	var ICUCIITypeObj=$HUI.combobox("#BPCIIType",{
		url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=FindType&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
	})
	//�������ʾ���������
	var ICUCIIIsSearchObj=$HUI.combobox("#BPCIIIsSearch,#BPCIIIsDisplay,#BPCIIIsSingle",{
		url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=FindBoolen&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		panelHeight:"auto",
		onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
	})
	//����ͼ������
	$HUI.combobox("#BPCIISummaryChartType",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:"auto",
        data:[{'Code':"Z",'Desc':"��״ͼ"},{'Code':"S",'Desc':"��״ͼ"}],
        onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
    })
	$("#btnSearch").click(function(){
		$('#inquiryBox').datagrid({
			url:$URL,
	        queryParams:{
			ClassName:"web.DHCBPCInquiry",
			QueryName:"FindBPCInquiry",
			CtlocDr:$("#SearchBPCICtloc").combobox('getValue'),
			desc:$("#SearchBPCIDesc").val(),
			}
		});
	})
	function setDialogValue()
	{		
		$("#BPCIRowId").val("");		
		$("#BPCICode").val("");
		$("#BPCIDesc").val("");	
		$("#BPCICtloc").combobox('setValue',"")
		$("#BPCIType").combobox('setValue',"")
		$("#BPCIStatus").combobox('setValue',"")
		$("#BPCISearchLevel").val("");
		$("#BPCICount").val("");
		$("#BPCIResultCount").val("");	
		$("#BPCIDataType").combobox('setValue',"")
	}	
	var InsertHandler=function(){
		//initView();
		$("#inquiryDialog").show();
		var inquiryDigObj=$HUI.dialog("#inquiryDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'����ͳ������',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#BPCICode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#BPCIDesc").val()==""){
						$.messager.alert("��ʾ","��������Ϊ��","error");
						return;
					}
					if($("#BPCICtloc").combobox('getValue')==""){
						$.messager.alert("��ʾ","���Ҳ���Ϊ��","error");
						return;
					}
					var data=$.m({
								ClassName:"web.DHCBPCInquiry",
								MethodName:"InsertBPCInquiry",
								BPCICode:$("#BPCICode").val(),
								BPCIDesc:$("#BPCIDesc").val(),
								BPCICtlocDr:$("#BPCICtloc").combobox('getValue'),								
								BPCIStatus:$("#BPCIStatus").combobox('getValue'),
								BPCISearchLevel:$("#BPCISearchLevel").val(),
								BPCIBpaCount:$("#BPCICount").val(),
								BPCIResultCount:$("#BPCIResultCount").val(),
								BPCIType:$("#BPCIType").combobox('getValue'),
								BPCIUpdateUserDr:"0",
								BPCIDataType:$("#BPCIDataType").combobox('getValue')
					},function(success){
						if(success>=0)
						{
							inquiryDigObj.close();
							inquiryBoxObj.load();
						}else
						{
							$.messager.alert("��ʾ",success);
						}
					})
				}
			},
			{
				text:"�ر�",
				handler:function(){
					inquiryDigObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}

	var UpdateHandler=function(row)
	{		
		//initView();
		$("#BPCIRowId").val(row.TRowid);		
		$("#BPCICode").val(row.TBPCICode);
		$("#BPCIDesc").val(row.TBPCIDesc);
		$("#BPCICtloc").combobox('setValue',row.TBPCICtlocDr);
		//$("#BPCICtloc").combobox('setText',row.TBPCICtloc);
		$("#BPCIStatus").combobox('setValue',row.TBPCIStatusCode);
		//$("#BPCIStatus").combobox('setText',row.TBPCIStatus);
		$("#BPCISearchLevel").val(row.TBPCISearchLevel);
		$("#BPCICount").val(row.TBPCIBpaCount);
		$("#BPCIResultCount").val(row.TBPCIResultCount);
		$("#BPCIType").combobox('setText',row.TBPCIType);
		$("#BPCIDataType").combobox('setValue',row.TBPCIDataType);
		$("#inquiryDialog").show();		
		var inquiryDigObj=$HUI.dialog("#inquiryDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'�޸�ͳ������',
			buttons:[{
				text:"����",
				handler:function(){					
					var data=$.m({
							ClassName:"web.DHCBPCInquiry",
							MethodName:"UpdateBPCInquiry",
							RowID:$("#BPCIRowId").val(),
							BPCICode:$("#BPCICode").val(),
							BPCIDesc:$("#BPCIDesc").val(),							
							BPCICtlocDr:$("#BPCICtloc").combobox('getValue'),
							BPCIStatus:$("#BPCIStatus").combobox('getValue'),
							BPCISearchLevel:$("#BPCISearchLevel").val(),
							BPCIBpaCount:$("#BPCICount").val(),							
							BPCIResultCount:$("#BPCIResultCount").val(),		
							BPCIType:$("#BPCIType").combobox('getValue'),						
							BPCIDataType:$("#BPCIDataType").combobox('getValue')
							
						},function(success){
							if(success==0)
							{
								inquiryDigObj.close();
								inquiryBoxObj.load();
							}else{
								$.messager.alert("��ʾ",success);
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					inquiryDigObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
		
	var inquiryBoxObj=$HUI.datagrid("#inquiryBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCInquiry",
			QueryName:"FindBPCInquiry"
		},
		onBeforeLoad:function(param){			
			param.CtlocDr=$("#SearchBPCICtloc").combobox('getValue'),
			param.desc=$("#SearchBPCIDesc").val()
		},
		title:'ͳ������',
        columns:[[
			{ field: "TRowid", title: "ϵͳ��", width: 120 },
			{ field: "TBPCICode",title:"����",width:240},
            { field: "TBPCIDesc", title: "����", width: 240 },            
            { field: 'TBPCICtlocDr',title:'����ID',width:140,hidden:true},
            { field: 'TBPCICtloc',title:'����',width:140 },
            { field: 'TBPCIType',title:'����',width:140},   
            { field: 'TBPCIStatusCode',title:'״̬Code',width:140,hidden:true},
            { field: 'TBPCIStatus',title:'״̬',width:140},
            { field: 'TBPCISearchLevel',title:'��������',width:140,hidden:true},  
            { field: 'TBPCIBpaCount',title:'ͳ��',width:140}, 
            { field: 'TBPCIResultCount',title:'���ͳ��',width:140},  
            { field: 'TBPCIDataType',title:'ͳ������',width:140}, 
        ]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		//checkOnSelect:true,	///easyuiȡ��������ѡ��״̬
		//selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		onSelect:function(rowIndex,rowData){
			inquiryItemBoxObj.load();
		},
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
				var row=inquiryBoxObj.getSelected();
				if(row)
				{
					UpdateHandler(row);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=inquiryBoxObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCInquiry",
								MethodName:"DeleteBPCInquiry",
								RowID:row.TRowid
							},function(success)
							{
								if(success==0)
								{
									inquiryBoxObj.load();
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
	function setInquiryItemDialogValue()
	{		
		$("#InquiryRowId").val("");		
		$("#InquiryItemRowId").val("");	
		$("#BPCIICode").combobox('setValue',"")
		$("#BPCIICode").combobox('setText',"")
		$("#BPCIIDesc").val("");
		$("#BPCIIType").combobox('setValue',"")		
		$("#BPCIIIsSearch").combobox('setValue',"")	
		$("#BPCIIIsDisplay").combobox('setValue',"")		
		$("#BPCIIDataField").val("");		
		$("#BPCIIIsSingle").combobox('setValue',"")
		$("#BPCIIMinQty").val("");		
		$("#BPCIIMaxQty").val("");
		$("#BPCIINote").val("");
		$("#BPCIIMultiple").val("");
		$("#BPCIIStartDateTime").val("");
		$("#BPCIIDurationHour").val("");
		$("#BPCIIOeoriNote").val("");
		$("#BPCIIFromTime").val("");
		$("#BPCIIToTime").val("");
		$("#BPCIIExactTime").timespinner('setValue',"")		
		$("#BPCIIRefBpriId").combobox('setValue',"")			
		$("#BPCIIRefValue").val("");
		$("#BPCIISeqNo").val("");
		$("#BPCIILevel").val("");
		$("#BPCIISummaryType").val("");		
		$("#BPCIIColumnWidth").val("");
		$("#BPCIISummarySeqNo").val("");
		$("#BPCIISummaryChartType").combobox('setValue',"")
	}	
	var InsertInquiryItemHandler=function(){
		//initView();
		$("#inquiryItemDialog").show();
		var inquiryItemDigObj=$HUI.dialog("#inquiryItemDialog",{
			iconCls:'icon-add',
			resizable:true,
			modal:true,
			title:'����ͳ����Ŀ',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#BPCIICode").combobox('getText')==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#BPCIIDesc").val()==""){
						$.messager.alert("��ʾ","��������Ϊ��","error");
						return;
					}
					if($("#BPCIIType").combobox('getValue')==""){
						$.messager.alert("��ʾ","���Ͳ���Ϊ��","error");
						return;
					}
					
					var data=$.m({
								ClassName:"web.DHCBPCInquiry",
								MethodName:"InsertInquiryitem",
								BPCIRowid:bpciRowid, //$("#InquiryRowId").val(),
								BPCIICode:$("#BPCIICode").combobox('getText'),
								BPCIIDesc:$("#BPCIIDesc").val(),
								BPCIIType:$("#BPCIIType").combobox('getValue'), 
								BPCIIIsSearch:$("#BPCIIIsSearch").combobox('getValue'), 
								BPCIIIsDisplay:$("#BPCIIIsDisplay").combobox('getValue'), 
								BPCIIDataField:$("#BPCIIDataField").val(), 
								BPCIIIsSingle:$("#BPCIIIsSingle").combobox('getValue'),
								BPCIIMinQty:$("#BPCIIMinQty").val(),
								BPCIIMaxQty:$("#BPCIIMaxQty").val(), 
								BPCIINote:$("#BPCIINote").val(),
								BPCIIMultiple:$("#BPCIIMultiple").val(), 
								BPCIIStartDateTime:$("#BPCIIStartDateTime").val(), 
								BPCIIDurationHour:$("#BPCIIDurationHour").val(), 
								BPCIIOeoriNote:$("#BPCIIOeoriNote").val(),
								BPCIIFromTime:$("#BPCIIFromTime").val(), 
								BPCIIToTime:$("#BPCIIToTime").val(), 
								BPCIIExactTime:$("#BPCIIExactTime").timespinner('getValue'), 
								BPCIIRefBPriId:$("#BPCIIRefBpriId").combobox('getValue'), 
								BPCIIRefValue:$("#BPCIIRefValue").val(), 
								BPCIISeqNo:$("#BPCIISeqNo").val(),
								BPCIILevel:$("#BPCIILevel").val(),
								BPCIISummaryType:$("#BPCIISummaryType").val(),
								BPCIIColumnWidth:$("#BPCIIColumnWidth").val(),
								BPCIIMainBPCIIDr:$("#BPCIISummarySeqNo").val(),
								BPCIISummaryChartType:$("#BPCIISummaryChartType").combobox('getValue'), 
							
							},function(success){
								if(success==0)
								{
									inquiryItemDigObj.close();
									inquiryItemBoxObj.load();
								}else
								{
									$.messager.alert("��ʾ",success);
								}
							})
				}
			},
			{
				text:"�ر�",
				handler:function(){
					inquiryItemDigObj.close();
				}
			}],			
			onClose:function(){  
                setInquiryItemDialogValue();
            } 
		})

	}

	var UpdateInquiryItemHandler=function(row)
	{
		$("#InquiryRowId").val(row.TBPCIRowid);		
		$("#InquiryItemRowId").val(row.TRowid);	
		$("#BPCIICode").combobox('setText',row.TBPCIICode)
		$("#BPCIIDesc").val(row.TBPCIIDesc);
		$("#BPCIIType").combobox('setValue',row.TBPCIIType)		
		$("#BPCIIIsSearch").combobox('setValue',row.TBPCIIIsSearch)	
		$("#BPCIIIsDisplay").combobox('setValue',row.TBPCIIIsDisplay)		
		$("#BPCIIDataField").val(row.TBPCIIDataField);		
		$("#BPCIIIsSingle").combobox('setValue',row.TBPCIIIsSingle)
		$("#BPCIIMinQty").val(row.TBPCIIMinQty);		
		$("#BPCIIMaxQty").val(row.TBPCIIMaxQty);
		$("#BPCIINote").val(row.TBPCIINote);
		$("#BPCIIMultiple").val(row.TBPCIIMultiple);
		$("#BPCIIStartDateTime").val(row.TBPCIIStartDateTime);
		$("#BPCIIDurationHour").val(row.TBPCIIDurationHour);
		$("#BPCIIOeoriNote").val(row.TBPCIIOeoriNote);
		$("#BPCIIFromTime").val(row.TBPCIIFromTime);
		$("#BPCIIToTime").val(row.TBPCIIToTime);
		$("#BPCIIExactTime").timespinner('setValue',row.TBPCIIExactTime)		
		$("#BPCIIRefBpriId").combobox('setValue',row.TBPCIIRefIcuriId)			
		$("#BPCIIRefValue").val(row.TBPCIIRefValue);
		$("#BPCIISeqNo").val(row.TBPCIISeqNo);
		$("#BPCIILevel").val(row.TBPCIILevel);
		$("#BPCIISummaryType").val(row.TBPCIISummaryType);		
		$("#BPCIIColumnWidth").val(row.TBPCIIColumnWidth);
		$("#BPCIISummarySeqNo").val(row.TBPCIISummarySeqNo);
		$("#BPCIISummaryChartType").combobox('setValue',row.TBPCIISumChartType);
		
		$("#inquiryItemDialog").show();		
		var inquiryItemDigObj=$HUI.dialog("#inquiryItemDialog",{
			iconCls:'icon-edit',
			resizable:true,
			modal:true,
			title:'�޸�ͳ����Ŀ',
			buttons:[{
				text:"����",
				handler:function(){	
					//alert($("#BPCIICode").combobox('getValue'));			  
					var data=$.m({
							ClassName:"web.DHCBPCInquiry",
							MethodName:"UpdateInquiryitem",
								BPCIRowid:$("#InquiryRowId").val(),
								Rowid:$("#InquiryItemRowId").val(),	
								BPCIICode:$("#BPCIICode").combobox('getText'),
								BPCIIDesc:$("#BPCIIDesc").val(),
								BPCIIType:$("#BPCIIType").combobox('getValue'), 
								BPCIIIsSearch:$("#BPCIIIsSearch").combobox('getValue'), 
								BPCIIIsDisplay:$("#BPCIIIsDisplay").combobox('getValue'), 
								BPCIIDataField:$("#BPCIIDataField").val(), 
								BPCIIIsSingle:$("#BPCIIIsSingle").combobox('getValue'),
								BPCIIMinQty:$("#BPCIIMinQty").val(),
								BPCIIMaxQty:$("#BPCIIMaxQty").val(), 
								BPCIINote:$("#BPCIINote").val(),
								BPCIIMultiple:$("#BPCIIMultiple").val(), 
								BPCIIStartDateTime:$("#BPCIIStartDateTime").val(), 
								BPCIIDurationHour:$("#BPCIIDurationHour").val(), 
								BPCIIOeoriNote:$("#BPCIIOeoriNote").val(),
								BPCIIFromTime:$("#BPCIIFromTime").val(), 
								BPCIIToTime:$("#BPCIIToTime").val(), 
								BPCIIExactTime:$("#BPCIIExactTime").timespinner('getValue'), 
								BPCIIRefBPriId:$("#BPCIIRefBpriId").combobox('getValue'), 
								BPCIIRefValue:$("#BPCIIRefValue").val(), 
								BPCIISeqNo:$("#BPCIISeqNo").val(),
								BPCIILevel:$("#BPCIILevel").val(),
								BPCIIFromBPriId:"",
								BPCIIToBPriId:"",
								BPCIISummaryType:$("#BPCIISummaryType").val(),
								BPCIIDurationInterval:"",
								BPCIIColumnWidth:$("#BPCIIColumnWidth").val(),
								BPCIIMainBPCIIDr:$("#BPCIISummarySeqNo").val(),
								BPCIISummaryChartType:$("#BPCIISummaryChartType").combobox('getValue'),
						},function(success){
							if(success==0)
							{
								inquiryItemDigObj.close();
								inquiryItemBoxObj.load();
							}else{
								$.messager.alert("��ʾ","ѪҺ������ѯ����ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					inquiryItemDigObj.close();
				}
			}],			
			onClose:function(){  
                setInquiryItemDialogValue();
            } 
		})
	}
	//��֢��ѯ��Ŀ
	var inquiryItemBoxObj=$HUI.datagrid("#inquiryItemBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCInquiry",
			QueryName:"FindInquiryitem"
		},
		onBeforeLoad:function(param){			
			var inquiryRow=inquiryBoxObj.getSelected();
			if(inquiryRow)
			{
				bpciRowid=inquiryRow.TRowid;
			}
			param.BPCIRowid=bpciRowid;
		},
		title:'ͳ����Ŀ',
		columns:[[
			{ field: "TBPCIRowid", title: "����ID", width: 60, hidden:true},
			{ field: "TRowid", title: "���", width: 60 },
			{ field: "TBPCIICode", title: "����", width: 100 },
			{ field: "TBPCIIDesc", title: "����", width: 100 },
			{ field: "TBPCIIType", title: "����Code", width: 100, hidden:true },
			{ field: "TBPCIITypeD", title: "����", width: 100 },
			{ field: "TBPCIIIsSearch", title: "������Code", width: 100, hidden:true},
			{ field: "TBPCIIIsSearchD", title: "������", width: 100 },
			{ field: "TBPCIIIsDisplay", title: "��ʾ��Code", width: 100, hidden:true},
			{ field: "TBPCIIIsDisplayD", title: "��ʾ��", width: 100 },
			{ field: "TBPCIIDataField", title: "�ֶ�", width: 100 },
			{ field: "TBPCIIIsSingle", title: "���ص�������Code", width: 100, hidden:true},
			{ field: "TBPCIIIsSingleD", title: "���ص�������", width: 100 },
			{ field: "TBPCIIMinQty", title: "��Сֵ", width: 100 },
			{ field: "TBPCIIMaxQty", title: "���ֵ", width: 100 },
			{ field: "TBPCIINote", title: "˵��", width: 100 },
			{ field: "TBPCIIMultiple", title: "��ѡֵ", width: 100 },
			{ field: "TBPCIIStartDateTime", title: "��ʼʱ������", width: 100 },
			{ field: "TBPCIIDurationHour", title: "����Сʱ", width: 100 },
			{ field: "TBPCIIOeoriNote", title: "ҽ����ע", width: 100 },
			{ field: "TBPCIIFromTime", title: "��ʼ����", width: 100 },
			{ field: "TBPCIIToTime", title: "��ֹ����", width: 100 },
			{ field: "TBPCIIExactTime", title: "׼ȷʱ��", width: 100 },
			{ field: "TBPCIIRefIcuriId", title: "��׼����ҽ��Id", width: 100 , hidden:true},
			{ field: "TBPCIIRefIcuriDesc", title: "��׼����ҽ��", width: 100 },
			{ field: "TBPCIIRefValue", title: "��׼ֵ", width: 100 },
			{ field: "TBPCIISeqNo", title: "�����", width: 100 },
			{ field: "TBPCIILevel", title: "ɸѡֵ", width: 100 },
			{ field: "TBPCIISummaryType", title: "��������", width: 100 },
			{ field: "TBPCIIColumnWidth", title: "�п�", width: 100 },
			{ field: "TBPCIISummarySeqNo", title: "��������", width: 100 },
			{ field: "TBPCIISumChartType", title: "����ͼ������", width: 100 , hidden:true},
			{ field: "TBPCIISumChartTypeD", title: "����ͼ������", width: 100 }
		]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		fit:true,
		//fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyuiȡ��������ѡ��״̬
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){
					InsertInquiryItemHandler();
				}
			},
			{
				iconCls:'icon-write-order',
				text:'�޸�',
				handler:function(){
					var row=inquiryItemBoxObj.getSelected();
					if(row)
					{
						UpdateInquiryItemHandler(row);
					}else{
						$.messager.alert("��ʾ","��ѡ��Ҫ�޸ĵ��У�", "error");
					}
				}
			},
			{
				iconCls:'icon-cancel',
				text:'ɾ��',
				handler:function(){
					var row=inquiryItemBoxObj.getSelected();
					if(row)
					{
						$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
							if(r)
							{
								$.m({
									ClassName:"web.DHCBPCInquiry",
									MethodName:"DeleteInquiryitem",
									Rowid:row.TRowid,
								},function(result){
									if(result==0){
										inquiryItemBoxObj.load();
									}
									else{
										$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+result);
									}
								})
							}
						})
					}else{
						$.messager.alert("��ʾ","��ѡ��Ҫɾ�����У�", "error");
					}
				}
			}
		]
	});

	
})