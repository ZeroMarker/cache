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
	var obj={
		BPCRIRowId:$("#tRowId"),
		BPCRICode:$("#tBPCRICode"),
		BPCRIDesc:$("#tBPCRIDesc"),
		BPCRIMultiValueDesc:$("#tBPCRIMultiValueDesc"),
		BPCRIOptions:$("#tBPCRIOptions"),
		BPCRISortNo:$("#tBPCRISortNo"),
		BPCRIMin:$("#tBPCRIMin"),
		BPCRIMax:$("#tBPCRIMax"),
		BPCRIImpossibleMin:$("#tBPCRIImpossibleMin"),
		BPCRIImpossibleMax:$("#tBPCRIImpossibleMax"),
		BPCRIMainRecordItemDr:$("#tBPCRIMainRecordItem"),
		BPCRIBPCRecordCatDr:$("#tBPCRIBPCRecordCat"),
		BPCRIArcimDr:$("#tBPCRIArcim"),
		BPCRIUomDr:$("#tBPCRIUom"),
		BPCRIType:$("#tBPCRIType"),
		BPCRIDataType:$("#tBPCRIDataType")
	}
	function setDialogValue(BPCRIRowId,BPCRICode,BPCRIDesc,BPCRIMultiValueDesc,BPCRIOptions,BPCRISortNo,BPCRIMin,
		BPCRIMax,BPCRIImpossibleMin,BPCRIImpossibleMax,BPCRIMainRecordItemDr,BPCRIBPCRecordCatDr,BPCRIArcimDr,BPCRIUomDr,BPCRIType,BPCRIDataType){
		obj.BPCRIRowId.val(BPCRIRowId);
		obj.BPCRICode.val(BPCRICode);
		obj.BPCRIDesc.val(BPCRIDesc);
		obj.BPCRIMultiValueDesc.val(BPCRIMultiValueDesc);
		obj.BPCRIOptions.val(BPCRIOptions);
		obj.BPCRISortNo.val(BPCRISortNo);
		obj.BPCRIMin.val(BPCRIMin);
		obj.BPCRIMax.val(BPCRIMax);
		obj.BPCRIImpossibleMin.val(BPCRIImpossibleMin);
		obj.BPCRIImpossibleMax.val(BPCRIImpossibleMax);
		obj.BPCRIMainRecordItemDr.combobox("setValue",BPCRIMainRecordItemDr);
		obj.BPCRIBPCRecordCatDr.combobox("setValue",BPCRIBPCRecordCatDr);
		obj.BPCRIArcimDr.combobox("setValue",BPCRIArcimDr);
		obj.BPCRIUomDr.combobox("setValue",BPCRIUomDr);
		obj.BPCRIType.combobox("setValue",BPCRIType);
		obj.BPCRIDataType.combobox("setValue",BPCRIDataType);
	}
	var InsertHandler=function(){
		$("#recordItemDialog").show();
		var recordItemDlgObj=$HUI.dialog("#recordItemDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'������¼��Ŀ',
			buttons:[{
				text:"����",
				handler:function(){
					var BPCRICode=$("#tBPCRICode").val();
					var BPCRIDesc=$("#tBPCRIDesc").val();
					if(BPCRICode==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if(BPCRIDesc==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
						return;
					}
					if($("#tBPCRIBPCRecordCat").combobox('getValue')==""){
						$.messager.alert("��ʾ","�໤���಻��Ϊ��","error");
						return;
					}
					

					
					var BPCRIBPCRecordCatDr=obj.BPCRIBPCRecordCatDr.combobox("getValue");
					var BPCRIType=obj.BPCRIType.combobox("getValue");
					var BPCRIArcimDr=obj.BPCRIArcimDr.combobox("getValue");
					var BPCRIUomDr=obj.BPCRIUomDr.combobox("getValue");
					var BPCRIOptions=obj.BPCRIOptions.val();
					var BPCRIDataType=obj.BPCRIDataType.combobox("getValue");
					var BPCRIMultiValueDesc=obj.BPCRIMultiValueDesc.val();
					var BPCRISortNo=obj.BPCRISortNo.val();
					var BPCRIMin=obj.BPCRIMin.val();
					var BPCRIMax=obj.BPCRIMax.val();
					var BPCRIImpossibleMin=obj.BPCRIImpossibleMin.val();
					var BPCRIImpossibleMax=obj.BPCRIImpossibleMax.val();
					var BPCRIMainRecordItemDr=obj.BPCRIMainRecordItemDr.combobox("getValue");
					
					var data=$.m({
								ClassName:"web.DHCBPCRecordItem",
								MethodName:"InsertBPCReItem",
								Code: BPCRICode,
								Desc: BPCRIDesc,
								BPCRIBPCRecordCatDr: BPCRIBPCRecordCatDr,
								BPCRIType: BPCRIType,
								BPCRIArcimDr: BPCRIArcimDr,
								BPCRIUomDr: BPCRIUomDr,
								BPCRIOptions: BPCRIOptions,
								BPCRIDataType: BPCRIDataType,
								BPCRIMultiValueDesc: BPCRIMultiValueDesc,
								BPCRISortNo: BPCRISortNo,
								BPCRIMin: BPCRIMin,
								BPCRIMax: BPCRIMax,
								BPCRIImpossibleMin: BPCRIImpossibleMin,
								BPCRIImpossibleMax: BPCRIImpossibleMax,
								BPCRIMainRecordItemDr:BPCRIMainRecordItemDr 
							},function(success){
								if(success==0)
								{
									$.messager.alert("��ʾ","�����ɹ�");
									recordItemDlgObj.close();
									setDialogValue("","","","","","","","","","","","","","","","");
									recordItemObj.load();
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
					recordItemDlgObj.close();
					
				}
			}],
			onClose:function(){  
                setDialogValue("","","","","","","","","","","","","","","","");
            }  
		
		})
	}

	var UpdateHandler=function(row)
	{

		setDialogValue(row.tRowId,row.tBPCRICode,row.tBPCRIDesc,row.tBPCRIMultiValueDesc,row.tBPCRIOptions,row.tBPCRISortNo,row.tBPCRIMin,row.tBPCRIMax,
			row.tBPCRIImpossibleMin,row.tBPCRIImpossibleMax,row.tBPCRIMainRecordItemDr,row.tBPCRIBPCRecordCatDr,row.tBPCRIArcimDr,row.tBPCRIUomDr,row.tBPCRITypeDr,row.tBPCRIDataTypeDr)
		$("#recordItemDialog").show();
		var recordItemDlgObj=$HUI.dialog("#recordItemDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'�޸ļ�¼��Ŀ',
			buttons:[{
				text:"����",
				handler:function(){
					var BPCRICode=$("#tBPCRICode").val();
					var BPCRIDesc=$("#tBPCRIDesc").val();
					var BPCRIBPCRecordCatDr=obj.BPCRIBPCRecordCatDr.combobox("getValue");
					var BPCRIType=obj.BPCRIType.combobox("getValue");
					var BPCRIArcimDr=obj.BPCRIArcimDr.combobox("getValue");
					var BPCRIUomDr=obj.BPCRIUomDr.combobox("getValue");
					var BPCRIOptions=obj.BPCRIOptions.val();
					var BPCRIDataType=obj.BPCRIDataType.combobox("getValue");
					var BPCRIMultiValueDesc=obj.BPCRIMultiValueDesc.val();
					var BPCRISortNo=obj.BPCRISortNo.val();
					var BPCRIMin=obj.BPCRIMin.val();
					var BPCRIMax=obj.BPCRIMax.val();
					var BPCRIImpossibleMin=obj.BPCRIImpossibleMin.val();
					var BPCRIImpossibleMax=obj.BPCRIImpossibleMax.val();
					var BPCRIMainRecordItemDr=obj.BPCRIMainRecordItemDr.combobox("getValue");
					var BPCRIRowId=obj.BPCRIRowId.val();
					var data=$.m({
							ClassName:"web.DHCBPCRecordItem",
							MethodName:"UpdateBPCReItem",
							BPCRIRowId:BPCRIRowId,
								Code: BPCRICode,
								Desc: BPCRIDesc,
								BPCRIBPCRecordCatDr: BPCRIBPCRecordCatDr,
								BPCRIType: BPCRIType,
								BPCRIArcimDr: BPCRIArcimDr,
								BPCRIUomDr: BPCRIUomDr,
								BPCRIOptions: BPCRIOptions,
								BPCRIDataType: BPCRIDataType,
								BPCRIMultiValueDesc: BPCRIMultiValueDesc,
								BPCRISortNo: BPCRISortNo,
								BPCRIMin: BPCRIMin,
								BPCRIMax: BPCRIMax,
								BPCRIImpossibleMin: BPCRIImpossibleMin,
								BPCRIImpossibleMax: BPCRIImpossibleMax,
								BPCRIMainRecordItemDr:BPCRIMainRecordItemDr
						},function(success){
							if(success==0)
							{
								$.messager.alert("��ʾ","��¼��Ŀ���³ɹ���");
								
								recordItemDlgObj.close();
								setDialogValue("","","","","","","","","","","","","","","","");
								recordItemObj.load();
							}else{
								$.messager.alert("��ʾ","��¼��Ŀ����ʧ�ܣ�"+success);
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					recordItemDlgObj.close();
					
				}
			}],
			onClose:function(){  
                setDialogValue("","","","","","","","","","","","","","","","");
            }  
		})
	}
	
	
	var recordItemObj=$HUI.datagrid("#recordItemBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCRecordItem",
			QueryName:"FindBPCReItem"
		},
        columns:[[
			
            {title: '���', width: 60, field: 'tRowId'}
			,{title: '�໤����', width: 150, field: 'tBPCRICode'}
			,{title: '�໤����', width: 150, field: 'tBPCRIDesc'}
			,{title: '�໤����', width: 100, field: 'tBPCRIBPCRecordCat'}	
			,{title: '�໤����', width: 100, field: 'tBPCRIType'}	
			,{title: 'ҽ������', width: 100, field: 'tBPCRIArcim'}
			,{title: '��λ', width: 100, field: 'tBPCRIUom'}
			,{title: 'ѡ��ָ��', width: 100, field: 'tBPCRIOptions'}
			,{title: '��ֵ����', width: 100, field: 'tBPCRIDataType'}
			,{title: '����ֵ���봮', width: 100, field: 'tBPCRIMultiValueDesc'}
			,{title: '�����', width: 150, field: 'tBPCRISortNo'}
			,{title: '������Сֵ', width: 100, field: 'tBPCRIMin'}
			,{title: '�������ֵ', width: 100, field: 'tBPCRIMax'}
			,{title: '��������Сֵ', width: 100, field: 'tBPCRIImpossibleMin'}	
			,{title: '���������ֵ', width: 100, field: 'tBPCRIImpossibleMax'}
			,{title: '����¼', width: 100, field: 'tBPCRIMainRecordItem'}	
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
				var row=recordItemObj.getSelected();
				if(row)
				{
					UpdateHandler(row);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=recordItemObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCRecordItem",
								MethodName:"DeleteBPCReItem",
								BPCRIRowId:row.tRowId
							},function(success)
							{
								if(success==0)
								{
									recordItemObj.load();
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
		
	$HUI.combobox("#tBPCRIBPCRecordCat",{
			url:$URL+"?ClassName=web.DHCBPCRecordItem&QueryName=FindBPCReCat&ResultSetType=array",
			valueField:"BPCRCId",
			textField:"BPCRCDesc",
			panelHeight:"auto",
			onHidePanel: function () {
               OnHidePanel("#tBPCRIBPCRecordCat");
        	},
		})
		
	$HUI.combobox("#tBPCRIType",{
			url:$URL+"?ClassName=web.DHCBPCRecordItem&QueryName=FindBPCRIType&ResultSetType=array",
			valueField:"RowId",
			textField:"Desc",
			panelHeight:"auto",
			onHidePanel: function () {
               OnHidePanel("#tBPCRIType");
        	},
		})		
		
	$HUI.combobox("#tBPCRIArcim",{
			url:$URL+"?ClassName=web.DHCBPOrder&QueryName=GetArcimList&ResultSetType=array",
			valueField:"Id",
			textField:"Desc",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {
               OnHidePanel2("#tBPCRIArcim");
        	},				
			onBeforeLoad:function(param)
        	{            	
            	param.needItemCatId="";
            	param.needArcimDesc=param.q;
            	param.arcimIdStr=""

        	},
        	mode:"remote"        			
		});		
		
	$HUI.combobox("#tBPCRIUom",{
			url:$URL+"?ClassName=web.DHCANCCommonOrd&QueryName=FindUom&ResultSetType=array",
			valueField:"UomRowId",
			textField:"UomDesc",
			onHidePanel: function () {
               OnHidePanel("#tBPCRIUom");
        	},
		})
	$HUI.combobox("#tBPCRIDataType",{
			url:$URL+"?ClassName=web.DHCBPCRecordItem&QueryName=BPCRIDataType&ResultSetType=array",
			valueField:"RowId",
			textField:"Desc",
			panelHeight:"auto",
			onHidePanel: function () {
               OnHidePanel("#tBPCRIDataType");
        	},
		})	
	$HUI.combobox("#tBPCRIMainRecordItem",{
			url:$URL+"?ClassName=web.DHCBPCRecordItem&QueryName=FindBPCRecordItem&ResultSetType=array",
			valueField:"BPCRIRowId",
			textField:"BPCRIDesc",
			onHidePanel: function () {
               OnHidePanel("#tBPCRIMainRecordItem");
        	},
	})
})