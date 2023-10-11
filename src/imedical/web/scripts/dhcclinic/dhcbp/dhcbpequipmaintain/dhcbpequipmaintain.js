var bpcERowId="1";
var selectBpIndex;

var equipAbbre=""
var bpCEqDesc="";

$(function(){
	InitFormItem();
	InitGroupData();
});
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //��ǰcombobox��ֵ
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
	    if (val==undefined) $(item).combobox('setValue',"");
	    $.messager.alert("��ʾ","���������ѡ��","error");
	    return;
	}

}
function InitFormItem()
{
	$HUI.datebox("#buyDate",{
	})
	$HUI.datebox("#buyDateDlg",{
	})
	$HUI.datebox("#winMaintainDate",{
	})
		//ά������
	$HUI.combobox("#winMainDesc",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:'auto',
        data:[{'Code':"C",'Desc':"����"}
        ,{'Code':"M",'Desc':"����"}
        ,{'Code':"R",'Desc':"ά��"}],
        onHidePanel: function () {
               OnHidePanel("#winMainDesc");
        },
    })
    //�豸״̬
	$HUI.combobox("#equipStatus",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:'auto',
        data:[{'Code':"US",'Desc':"����"}
        ,{'Code':"SP",'Desc':"����"}
        ,{'Code':"SC",'Desc':"����"}],
        onHidePanel: function () {
               OnHidePanel("#equipStatus");
        },
    })
	$("#equipType").combobox({
		url:$URL+"?ClassName=web.DHCBPCEquipModel&QueryName=FindEModel&ResultSetType=array",
		valueField:'tID',
		textField:'tBPCEMDesc',
		panelHeight:'auto',
		onHidePanel: function () {
               OnHidePanel("#equipType");
        },
	})
	$("#btnSearch").click(function(){
		$('#equipmaintainBox').datagrid({
			url:$URL,
	        queryParams:{
			ClassName:"web.DHCBPCEquip",
			QueryName:"FindEquip",
			BPCEBPCEquipModelDr:$("#equipType").combobox('getValue'),
			PurchaseDate:$("#buyDate").datebox('getValue'),
			BPCECode:$("#equipHosNo").val(),
			BPCENo:$("#equipSeqNo").val()
			}
		});
	})
	var manufactNameObj=$HUI.combobox("#manufactName",{
			url:$URL+"?ClassName=web.DHCBPCManufacturer&QueryName=FindEManufacturer&ResultSetType=array",
			valueField:'tRowId',
			textField:'BPCMDesc',
			panelHeight:'auto',
			onHidePanel: function () {
               OnHidePanel("#manufactName");
        	},
	})
	var equipTypeDlgObj=$HUI.combobox("#equipTypeDlg",{
			url:$URL+"?ClassName=web.DHCBPCEquipModel&QueryName=FindEModel&ResultSetType=array",
			valueField:'tID',
			textField:'tBPCEMDesc',
			panelHeight:'auto',
			onHidePanel: function () {
               OnHidePanel("#equipTypeDlg");
        	},
	})
	var logonCtlocId=session['LOGON.CTLOCID'];	
	var installPersonInObj=$HUI.combogrid("#installPersonIn,#takeCarePerson,#winPersonMIn",{
			idField:'Id',
    		textField:'Name',    		
			mode:"remote",
			multiple:true,
            url:$URL,
            //panelHeight:'auto',
   		 	queryParams:{
   				ClassName:"web.DHCClinicCom",
        		QueryName:"FindUserByLoc",
        		locId:logonCtlocId
   				},
            columns:[[
				{ field: "Id", checkbox:true,width:0},
    			{ field: "Name", title: "����",width:120}
            ]],
            onHidePanel: function() {  //�жϴ�������ѡ��
            	var valueField = $(this).combobox("options").valueField;
            	var val = $(this).combobox("getValue");  //��ǰcombobox��ֵ
            	var allData = $(this).combobox("getData");   //��ȡcombobox��������
            	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
            	if (val=="") result=false;
            	for (var i = 0; i < allData.length; i++) {
                	if (val == allData[i][valueField]) {
                    	result = false;
                    	break;
                	}
            	}
            	if (result) {
                	$(this).combobox("clear");
                	$.messager.alert("��ʾ","�����Ա���������ѡ��","error");
                	return;
            	}
        },
	})			
	var bedNoObj=$HUI.combobox("#bedNo",{
			url:$URL+"?ClassName=web.DHCBPCBed&QueryName=FindBPCBed&ResultSetType=array",
			valueField:'tRowId',
			textField:'tBPCBDesc',
			onHidePanel: function () {
               OnHidePanel("#bedNo");
        	},
	})
}
$("#btnSearch").click(function(){
        $HUI.datagrid("#equipmaintainBox").reload();
    });
function InitGroupData()
{	
	var equipmaintainBoxObj=$("#equipmaintainBox").datagrid({
		url:$URL,
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
        iconCls:'icon-paper',
        rownumbers: true,        
        title:'�豸����',
        queryParams:{
			ClassName:"web.DHCBPCEquip",
			QueryName:"FindEquip",
        },
        onBeforeLoad: function(param) {
	        param.BPCEBPCEquipModelDr=$("#equipType").combobox('getValue'),
			param.PurchaseDate=$("#buyDate").datebox('getValue'),
			param.BPCECode=$("#equipHosNo").val(),
			param.BPCENo=$("#equipSeqNo").val()
        },
		columns:[[
		{field:"tBPCERowId",title:"ϵͳ��",width:50},
		{field:"tBPBEBed",title:"��λ",width:50},
		{field:"tBPCEBPCEquipMFDesc",title:"��������",width:100},
		{field:"tBPCEBPCEquipModel",title:"�豸�ͺ�",width:110},
		{field:"tBPCENo",title:"�豸���к�",width:110},
		{field:"tBPCECode",title:"�豸Ժ�ڱ��",width:120},
		{field:"tBPCEPurchaseDate",title:"��������",width:110},
		{field:"tBPCEStatusD",title:"�豸״̬",width:80},
		{field:"tBPCEMType",title:"�豸����",width:80},
		{field:"tBPCEPurchaseAmount",title:"������(��)",width:80},
		{field:"tBPCEWarrantyYear",title:"��������(��)",width:80},
		{field:"installPerNameLtIn",title:"��װ��Ա(Ժ��)",width:100},
		{field:"installPersonOut",title:"��װ��Ա(Ժ��)",width:100},
		{field:"keepPerNameList",title:"������Ա",width:100},
		{field:"tBPCENote",title:"��ע",width:100},
		{field:"tBPCEBPCEquipMFDr",hidden:true},
		{field:"tBPCEBPCEquipModelDr",hidden:true},
		{field:"tBPCEStatus",hidden:true},
		{field:"installPerIdLtIn",hidden:true},
		{field:"keepPerIdList",hidden:true},		
		{field:"tBPBEBedDr",hidden:true},
		{field:"tBPCEDesc",hidden:true}, //�豸����
		{field:"tBPCEBPCEAbbre",hidden:true} //�豸�ͺ���д
		]],
		onSelect:function(rowIndex,rowData){
			var r=$("#equipmaintainBox").datagrid("getSelected");
			if(r)
			{
				equipAbbre=r.tBPCEBPCEAbbre;
				bpcERowId=r.tBPCERowId;
				$("#RowId").val(r.tBPCERowId+"^"+r.tBPBEBed+"^"+r.tBPCENo+"^"+r.tBPCEBPCEquipModel+"^"+r.tBPCEStatusD);
				bpCEqDesc=r.tBPCEDesc;
				selectBpIndex=rowIndex;
			}
			$HUI.datagrid("#winMaintainBox").reload();
			//winMaintainBoxObj.load();
		},
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'����',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'�޸�',
			    handler: function(){
                    editRow();
                }
            },            
            {
			iconCls:"icon-print",
			text:"����",
			handler:function(){
				var row=$("#equipmaintainBox").datagrid("getSelected");
				if(row)
				{printHandler(row);}else{
					$.messager.alert("��ʾ","��ѡ��һ�У�", "error")
				}
				}
			
			}
        ]
        
    })	

	var winMaintainBoxObj=$("#winMaintainBox").datagrid({
		url:$URL,
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
        iconCls:'icon-paper',
        rownumbers: true,        
        title:'������Ϣά��',
        queryParams:{
			ClassName:"web.DHCBPEquipMaintain",
			QueryName:"FindBPEquipMaintain",
        },
        onBeforeLoad:function(param){			
			//var bpcERow=equipmaintainBoxObj.getSelected();
			//if(bpcERow)
			//{
				//bpcERowId=bpcERow.tBPCERowId;
			//}
			//alert(bpcERowId);
			param.Equipid=bpcERowId,
			param.EquipModelId=""
		},
		columns:[[
		{field:"tRowId",title:"ϵͳ��",width:50},
		{field:"StartDate",title:"ά��ʱ��",width:100},
		{field:"tDBPEquipPartDesc",title:"��������",width:100},		
		{field:"tBPEMTypeDesc",title:"ά������",width:100},
		{field:"tBPEMExpense",title:"ά������",width:100},			
		{field:"userNameList",title:"�μ���(Ժ��)",width:100},
		{field:"userNameOut",title:"�μ���(Ժ��)",width:100},
		{field:"Note",title:"��ע",width:100},
		{field:"userIdList",title:"userIdList",width:100,hidden:true},	
		{field:"tBPEMType",title:"tBPEMType",width:100,hidden:true},
		{field:"tDBPCEquipDr",title:"tDBPCEquipDr",width:100,hidden:true}
		]],
		toolbar:[
		{
			iconCls:"icon-add",
			text:"����",
			handler:function(){
				InsertWinMaintain();
				//insertWinHandler(bpcERowId);
				}
			},		
			{
			iconCls:"icon-print",
			text:"����",
			handler:function(){
				winprintHandler($("#RowId").val());
				
				
				}
			
			}
		],
    })
}
	
function InitBEDiag()
{
	$("#manufactName").combobox('setValue',"");
	$("#equipHosNoDlg").val("");
	$("#equipSeqNoDlg").val("");	
	$("#equipStatus").combobox('setValue',"");
	$("#note").val("");	
	$("#equipTypeDlg").combobox('setValue',"");	
	$("#buyDateDlg").datebox('setValue',"");
	$("#buyMoney").val("");
	$("#guarYears").val("");	
	$("#installPersonIn").combobox('setValue',"");
	$("#installPersonOut").val("");
	$("#takeCarePerson").combobox('setValue',"");	
	$("#bedNo").combobox('setValue',"");
}
//����
function appendRow()
{
	    $("#equipmaintainDlg").dialog({
        title: "�����豸����ά��",
        iconCls: "icon-w-add"
    });
    InitBEDiag();
    $("#equipmaintainDlg").dialog("open");

}

function saveEquipmaintain()
{
	if($("#equipStatus").combobox('getValue')=="US"){			
			equipAbbre=bpCEqDesc
	}	
	var bpcEHosNo=$("#equipHosNoDlg").val();
	var bpcEDesc=equipAbbre;
    var bpcENo=$("#equipSeqNoDlg").val();
	var bpcEFromDate="";
	var bpcEToDate="";
	var	bpcEStatus=$("#equipStatus").combobox('getValue');
	var	bpcEStatusD=$("#equipStatus").combobox('getText');
	var	bpcENote=$("#note").val();
	var	bpcEBPCEquipModelDr=$("#equipTypeDlg").combobox('getValue');
	var	bpcEBPCEquipModel=$("#equipTypeDlg").combobox('getText');
	var	bpcESoftwareVersion="";
	var	bpcEPart="";
	var	bpcEInstallDate="";
	var	bpcETotalWorkingHour="";
	var	bpcEPurchaseDate=$("#buyDateDlg").datebox('getValue');
	var	bpcEPurchaseAmount=$("#buyMoney").val();
	var	bpcEWarrantyYear=$("#guarYears").val();
	var	installPIn=$("#installPersonIn").combogrid('getValue');
	var	installPInD=$("#installPersonIn").combogrid('getText');
	var	installPOut=$("#installPersonOut").val();
	var	takeCarePerson=$("#takeCarePerson").combogrid('getValue');
	var	takeCarePersonD=$("#takeCarePerson").combogrid('getText');
	var	bedNo=$("#bedNo").combobox('getValue');
						
    var rowdata={
	    tBPBEBed:bedNo,
	    tBPCEBPCEquipMFDesc:"",
	    tBPCEBPCEquipModelDr:bpcEBPCEquipModelDr,
	    tBPCEBPCEquipModel:bpcEBPCEquipModel,
	    tBPCENo:bpcENo,
	    tBPCECode:bpcEHosNo,
	    tBPCEPurchaseDate:bpcEPurchaseDate,
	    tBPCEStatus:bpcEStatus,
	    tBPCEStatusD:bpcEStatusD,
	    tBPCEPurchaseAmount:bpcEPurchaseAmount,
	    tBPCEWarrantyYear:bpcEWarrantyYear,
	    installPerIdLtIn:installPIn,
	    installPerNameLtIn:installPInD,
	    installPersonOut:installPOut,
	    keepPerIdList:takeCarePerson,
	    keepPerNameList:takeCarePersonD,
	    tBPCENote:bpcENote,
	    tBPCEDesc:bpcEDesc,
    } 
    	    	
    if($("#EditEquipmaintain").val()=="Y")
    {
	    
    	var datas=$.m({
        ClassName:"web.DHCBPCEquip",
		MethodName:"UpdateEquip",
		bpcEId:bpcERowId,
		bpcECode:$("#equipHosNoDlg").val(),
		bpcEDesc:bpcEDesc,
		bpcENo:$("#equipSeqNoDlg").val(),
		bpcEFromDate:"",
		bpcEToDate:"",
		bpcEStatus:$("#equipStatus").combobox('getValue'),
		bpcENote:$("#note").val(),
		bpcEBPCEquipModelDr:$("#equipTypeDlg").combobox('getValue'),
		bpcESoftwareVersion:"",
		bpcEPart:"",
		bpcEInstallDate:"",
		bpcETotalWorkingHour:"",
		bpcEPurchaseDate:$("#buyDateDlg").datebox('getValue'),
		bpcEPurchaseAmount:$("#buyMoney").val(),
		bpcEWarrantyYear:$("#guarYears").val(),
		installPersonIn:$("#installPersonIn").combogrid('getValue'),
		installPersonOut:$("#installPersonOut").val(),
		takeCarePerson:$("#takeCarePerson").combogrid('getValue'),
		bedNo:$("#bedNo").combobox('getValue')
    	},false);
    	if (datas==0)
    	{
    		$HUI.datagrid("#equipmaintainBox").updateRow({index:selectBpIndex,row:rowdata});
    		$.messager.alert("��ʾ", "�޸ĳɹ���", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("��ʾ", datas, 'error');
        	return;
	    }
    }
    else
    {
    	var datas=$.m({
        ClassName:"web.DHCBPCEquip",
        MethodName:"InsertEquip",
        bpcECode:$("#equipHosNoDlg").val(),
		bpcEDesc:bpcEDesc,
		bpcENo:$("#equipSeqNoDlg").val(),
		bpcEFromDate:"",
		bpcEToDate:"",
		bpcEStatus:$("#equipStatus").combobox('getValue'),
		bpcENote:$("#note").val(),
		bpcEBPCEquipModelDr:$("#equipTypeDlg").combobox('getValue'),
		bpcESoftwareVersion:"",
		bpcEPart:"",
		bpcEInstallDate:"",
		bpcETotalWorkingHour:"",
		bpcEPurchaseDate:$("#buyDateDlg").datebox('getValue'),
		bpcEPurchaseAmount:$("#buyMoney").val(),
		bpcEWarrantyYear:$("#guarYears").val(),
		installPersonIn:$("#installPersonIn").combogrid('getValue'),
		installPersonOut:$("#installPersonOut").val(),
		takeCarePerson:$("#takeCarePerson").combogrid('getValue'),
		bedNo:$("#bedNo").combobox('getValue')
    	},false);
    	if (datas==0)
    	{
    		$HUI.datagrid("#equipmaintainBox").appendRow(rowdata);
    		$.messager.alert("��ʾ", "�����ɹ���", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("��ʾ", datas, 'error');
        	return;
	    }
    }
     $("#equipmaintainBox").datagrid("reload");
	$HUI.dialog("#equipmaintainDlg").close();	
}
function editRow()
{
	var selectRow=$("#equipmaintainBox").datagrid("getSelected");
    if(selectRow)
    {
        $("#equipmaintainDlg").dialog({
            title: "�޸��豸������Ϣ",
            iconCls: "icon-w-edit"
        });
        $("#manufactName").combobox("setValue",selectRow.tBPCEBPCEquipMFDr);
		$("#equipTypeDlg").combobox('setValue',selectRow.tBPCEBPCEquipModelDr);
		$("#equipSeqNoDlg").val(selectRow.tBPCENo);
		$("#equipHosNoDlg").val(selectRow.tBPCECode);
		$("#buyDateDlg").datebox('setValue',selectRow.tBPCEPurchaseDate);
		$("#equipStatus").combobox('setValue',selectRow.tBPCEStatus);
		$("#equipName").val(selectRow.tBPCEMType);
		$("#buyMoney").val(selectRow.tBPCEPurchaseAmount);
		$("#guarYears").val(selectRow.tBPCEWarrantyYear);
		$("#installPersonIn").combogrid('setValue',selectRow.installPerIdLtIn);
		$("#installPersonOut").val(selectRow.installPersonOut);
		$("#takeCarePerson").combogrid('setValue',selectRow.keepPerIdList);
		$("#note").val(selectRow.tBPCENote);
		$("#bedNo").combobox('setValue',selectRow.tBPBEBedDr);   
        
        $("#equipmaintainDlg").window("open");
        $("#EditEquipmaintain").val("Y");
        
    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'error');
        return;
    }

	
}
//����
function InsertWinMaintain()
{
	    $("#winMaintainDlg").dialog({
        title: "����������Ϣ",
        iconCls: "icon-w-add"
    });
    InitWinMaintainDiag();
    $("#winMaintainDlg").dialog("open");

}
function InitWinMaintainDiag()
{
	$("#winMaintainDate").datebox('setValue',"");
	$("#winEquipReplace").val("");		
	$("#winMainDesc").combobox('setValue',"");
	$("#winMaintainMoney").val("");	
	$("#winPersonMIn").combogrid('setValue',"");	
	$("#winPersonMOut").val("");
	$("#winNote").val("");
}
function saveWinMaintain()
{
	var	winMainDate=$("#winMaintainDate").datebox('getValue');	
	var	winEquipReplace=$("#winEquipReplace").val();
	var	winMain=$("#winMainDesc").combobox('getValue');	
	var	winMainD=$("#winMainDesc").combobox('getText');
	var	winMaintainMoney=$("#winMaintainMoney").val();
	var	winPersonMIn=$("#winPersonMIn").combogrid('getValue');	
	var	winPersonMInD=$("#winPersonMIn").combogrid('getText');
	var	winPersonMOut=$("#winPersonMOut").val();
	var	winNote=$("#winNote").val();
	if((winMain=="")||(winMain=="undefined")){
		$.messager.alert("��ʾ","ά�����ݲ���Ϊ��","error");
		return;
	}		
    var rowdata={
	    StartDate:winMainDate,
	    tDBPEquipPartDesc:winEquipReplace,
	    tBPEMType:winMain,
	    tBPEMTypeDesc:winMainD,
	    tBPEMExpense:winMaintainMoney,
	    userIdList:winPersonMIn,
	    userNameList:winPersonMInD,
	    userNameOut:winPersonMOut,
	    Note:winNote,
    }
    
    var datas=$.m({
        ClassName:"web.DHCBPEquipMaintain",
		MethodName:"InsertBPEquipMaintain",
        BPEquipMaintainInfo:bpcERowId+"^"+winEquipReplace+"^"+winMain+"^^"+winMainDate+"^^^^"+winNote+"^"+winMaintainMoney+"^"+""+"^"+winPersonMIn+"^"+winPersonMOut,
    	},false);
    	if (datas==0)
    	{
    		$HUI.datagrid("#winMaintainBox").appendRow(rowdata);
    		$.messager.alert("��ʾ", "�����ɹ���", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("��ʾ", datas, 'error');
        	return;
	    }
    
     $("#winMaintainBox").datagrid("reload");
	$HUI.dialog("#winMaintainDlg").close();	
}
		
function GetFilePath()
	{
		var path=$.m({
        ClassName:"web.DHCClinicCom",
        MethodName:"GetPath"
    },false);
    return path;
}
var winprintHandler=function(r){
		LODOP=getLodop();
		var equipinfo=r.split("^")
		var bedDesc=""	
		if(equipinfo[4]=="����"){
			bedDesc="��λ:"+equipinfo[1];				
		}				
		var htmlStr="<div>"

	
		htmlStr+="<table border='1' cellpadding='0' cellspacing='0' bordercolor='#000000' style='border-collapse:collapse;'>"
		
		htmlStr+="<thead>"
		
	    htmlStr+="<tr>"
		htmlStr+="<td width='1000' height='40' align='center' colspan='8' style='border:solid 0px'><b><font size='5'>"+"�豸ά�޼�¼"+"</b></td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='300' colspan='2' style='border:solid 0px'>"+"�豸�ͺ�:"+equipinfo[3]+"</td>"
		htmlStr+="<td width='300' colspan='2' style='border:solid 0px'>"+"�豸���к�:"+equipinfo[2]+"</td>"
		htmlStr+="<td width='300' colspan='2' style='border:solid 0px'>"+"�豸״̬:"+equipinfo[4]+"</td>"
		htmlStr+="<td width='300' colspan='2' style='border:solid 0px'>"+bedDesc+"</td>"
		htmlStr+="</tr>"
		
		htmlStr+="<tr>"
		htmlStr+="<th width='90' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>���</font></th>"
		htmlStr+="<th width='150' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>ά��ʱ��</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>��������</font></th>"
		htmlStr+="<th width='150' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>ά������</font></th>"
		htmlStr+="<th width='150' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>ά������</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>�μ���(Ժ��)</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>�μ���(Ժ��)</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>��ע</font></th>"		
		htmlStr+="</tr>"
		htmlStr+="</thead>"	
		htmlStr+="<tbody>"		
		var rows=$("#winMaintainBox").datagrid("getRows");
		for(var i=0;i<rows.length;i++){
			htmlStr+="<tr>"
			htmlStr+="<td style='border:solid 1px'>"+i+1+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].StartDate+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].tDBPEquipPartDesc+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].tBPEMTypeDesc+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].tBPEMExpense+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].userNameList+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].userNameOut+"</td>"
			htmlStr+="<td style='border:solid 1px'>"+rows[i].Note+"</td>"
			htmlStr+="</tr>"
		}
		htmlStr+="</tbody>"		
		htmlStr+="</table>" 
		htmlStr+="</div>"
		LODOP.PRINT_INIT("ά����¼")
		LODOP.SET_SAVE_MODE("Orientation",2) //Excel�ļ���ҳ�����ã������ӡ   1-����,2-����;
		LODOP.SET_SAVE_MODE("PaperSize",9)  //Excel�ļ���ҳ�����ã�ֽ�Ŵ�С   9-��ӦA4
		LODOP.ADD_PRINT_TABLE(1,1,1000,300,htmlStr)
		LODOP.SAVE_TO_FILE("ά����¼.xls")
}	
var winprintHandlerBak=function(r){
		var excel
		var workBook
		var sheet
		var equipinfo=r.split("^")
		try{
			excel=new ActiveXObject("Excel.Application");
			
		}catch(e){
			
			$.messager.alert("����","�����δ��װExcel���ӱ�����Ȱ�װ��","error")
			
		}
		var filepath=GetFilePath();
		var fileName=filepath.replace(/[\r\n]/g,"").replace(/\ +/g,"")+"DHCBPEquipMaintain.xls";
		try{
			workBook=excel.WorkBooks.open(fileName);
			sheet=workBook.Worksheets(1);
			
			var rows=$("#winMaintainBox").datagrid("getRows");
			//var rows=winMaintainBoxObj.getRows();
			sheet.Range("A2").Value="�豸�ͺ�:"+equipinfo[3];
			sheet.Range("C2").Value="�豸���к�:"+equipinfo[2];
			sheet.Range("F2").Value="�豸״̬:"+equipinfo[4];
			if(equipinfo[4]=="����"){
				sheet.Range("G2").Value="��λ:"+equipinfo[1];
				
			}
			var row=3
			for(var i=0;i<rows.length;i++){
				
				sheet.Range("A"+row).Value=i+1;
				sheet.Range("B"+row).Value=rows[i].StartDate;
				sheet.Range("C"+row).Value=rows[i].tDBPEquipPartDesc;
				sheet.Range("D"+row).Value=rows[i].tBPEMTypeDesc;
				sheet.Range("E"+row).Value=rows[i].tBPEMExpense;
				sheet.Range("F"+row).Value=rows[i].userNameList;
				sheet.Range("G"+row).Value=rows[i].userNameOut;
				sheet.Range("H"+row).Value=rows[i].Note;
				row++;
			}
			excel.Visible = true;
			//var savefilename="D:\\ά����¼.xls";
			//sheet.SaveAs(savefilename);
			//alert("�ļ��ѵ���"+savefilename);
			//sheet=null;
			//workBook.Close(savechanges=false);
			//workBook=null;
		}catch(e){
			$.messager.alert("����","δ�ҵ���ӡģ�壬��ȷ�ϴ�ӡģ���·���Ƿ���ȷ��","error")
			
		}
		//excel.Quit();
		//excel=null;
	}	
	
function getExcelFileName() {   
		var d = new Date();   
		var curYear = d.getYear();   
		var curMonth = "" + (d.getMonth() + 1);   
		var curDate = "" + d.getDate();   
	    var curHour = "" + d.getHours();   
	    var curMinute = "" + d.getMinutes();   
	    var curSecond = "" + d.getSeconds();   
	    if (curMonth.length == 1) {   
	       curMonth = "0" + curMonth;   
	    }   
	    if (curDate.length == 1) {   
	       curDate = "0" + curDate;   
	    }   
	    if (curHour.length == 1) {   
	        curHour = "0" + curHour;   
	   }   
	    if (curMinute.length == 1) {   
	        curMinute = "0" + curMinute;   
	    }   
	    if (curSecond.length == 1) {   
	        curSecond = "0" + curSecond;   
	    }   
	    var fileName = "�豸������Ϣ" + "_" + curYear + curMonth + curDate + "_"   
	            + curHour + curMinute + curSecond + ".csv";   
	    //alert(fileName);   
	    return fileName;   
	}
var printHandler=function(r){
		var equipinfo=r;
		LODOP=getLodop();
				
		var htmlStr="<div>"		
		htmlStr+="<table border='1' cellpadding='0' cellspacing='0' bordercolor='#000000' style='border-collapse:collapse;'>"
		htmlStr+="<tbody>"
		htmlStr+="<tr>"
		htmlStr+="<td width='500' height='40' align='center' colspan='2' style='border:solid 0px'><b><font size='5'>"+"�豸����"+"</b></td>"
		htmlStr+="</tr>"		
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"��������"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEBPCEquipMFDesc+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"�豸�ͺ�"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEBPCEquipModel+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"�豸���к�"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCENo+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"�豸Ժ�ڱ��"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCECode+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"��������"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEPurchaseDate+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"������(��)"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEPurchaseAmount+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"��װ��"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.installPerNameLtIn+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"������"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.keepPerNameList+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"��������"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEWarrantyYear+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"��ע"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCENote+"</td>"
		htmlStr+="</tr>"
		htmlStr+="</tbody>"		
		htmlStr+="</table>" 
		htmlStr+="</div>"
		LODOP.PRINT_INIT("�豸����")
		LODOP.SET_SAVE_MODE("Orientation",2) //Excel�ļ���ҳ�����ã������ӡ   1-����,2-����;
		LODOP.SET_SAVE_MODE("PaperSize",9)  //Excel�ļ���ҳ�����ã�ֽ�Ŵ�С   9-��ӦA4
		LODOP.ADD_PRINT_TABLE(1,1,1000,300,htmlStr)
		//LODOP.SET_SAVE_MODE("Zoom",90);       //Excel�ļ���ҳ�����ã����ű���
		//LODOP.SET_SAVE_MODE("CenterHorizontally",true);//Excel�ļ���ҳ�����ã�ҳ��ˮƽ����
		//LODOP.SET_SAVE_MODE("CenterVertically",true); //Excel�ļ���ҳ�����ã�ҳ�洹ֱ����
		//LODOP.SET_SAVE_MODE("QUICK_SAVE",true);//�������ɣ��ޱ����ʽ,�������ϴ�ʱ�����õ��� 
		LODOP.SAVE_TO_FILE("�豸����.xls")
}
var printHandlerBak=function(r){
		var excel
		var workBook
		var sheet
		var equipinfo=r;
		try{
			excel=new ActiveXObject("Excel.Application");
			
		}catch(e){
			
			$.messager.alert("����","�����δ��װExcel���ӱ�����Ȱ�װ��","error")
			
		}
		var filepath=GetFilePath();
		//var fileName=filepath.replace(/[\r\n]/g,"").replace(/\ +/g,"")+"DHCBPEquip.xls";
		var fileName=filepath.replace(/[\r\n]/g,"").replace(/\ +/g,"")+"DHCBPEquipManage.xls";
		
		try{
			workBook=excel.WorkBooks.open(fileName);
			sheet=workBook.Worksheets(1);
			sheet.Range("A3").Value=equipinfo.tBPCERowId;
			sheet.Range("B3").Value=equipinfo.tBPBEBed
			sheet.Range("C3").Value=equipinfo.tBPCEBPCEquipMFDesc;
			sheet.Range("D3").Value=equipinfo.tBPCEBPCEquipModel;
			sheet.Range("E3").Value=equipinfo.tBPCENo;
			sheet.Range("F3").Value=equipinfo.tBPCECode;
			sheet.Range("G3").Value=equipinfo.tBPCEPurchaseDate;
			sheet.Range("H3").Value=equipinfo.tBPCEStatusD;
			sheet.Range("I3").Value=equipinfo.tBPCEMType;
			sheet.Range("J3").Value=equipinfo.tBPCEPurchaseAmount;
			sheet.Range("K3").Value=equipinfo.tBPCEWarrantyYear;
			sheet.Range("L3").Value=equipinfo.installPerNameLtIn;
			sheet.Range("M3").Value=equipinfo.installPersonOut;
			sheet.Range("N3").Value=equipinfo.keepPerNameList;
			sheet.Range("O3").Value=equipinfo.tBPCENote;			
			excel.Visible = true;			
			//var savefilename="D:\\"+getExcelFileName()+".xls";
			//sheet.SaveAs(savefilename);
			//alert("�ļ��ѵ���"+savefilename);
			//sheet=null;
			//workBook.Close(savechanges=false);
			//workBook=null;
		}catch(e){
			$.messager.alert("����","δ�ҵ���ӡģ�壬��ȷ�ϴ�ӡģ���·���Ƿ���ȷ��","error")
			
		}
		//excel.Quit();
		//excel=null;
	}