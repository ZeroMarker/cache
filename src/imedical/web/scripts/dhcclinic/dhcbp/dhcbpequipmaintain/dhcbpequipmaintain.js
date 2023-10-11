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
	var val = $(item).combobox("getValue");  //当前combobox的值
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
	    if (val==undefined) $(item).combobox('setValue',"");
	    $.messager.alert("提示","请从下拉框选择","error");
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
		//维护内容
	$HUI.combobox("#winMainDesc",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:'auto',
        data:[{'Code':"C",'Desc':"消毒"}
        ,{'Code':"M",'Desc':"保养"}
        ,{'Code':"R",'Desc':"维修"}],
        onHidePanel: function () {
               OnHidePanel("#winMainDesc");
        },
    })
    //设备状态
	$HUI.combobox("#equipStatus",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:'auto',
        data:[{'Code':"US",'Desc':"在用"}
        ,{'Code':"SP",'Desc':"备用"}
        ,{'Code':"SC",'Desc':"报废"}],
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
    			{ field: "Name", title: "姓名",width:120}
            ]],
            onHidePanel: function() {  //判断从下拉框选择
            	var valueField = $(this).combobox("options").valueField;
            	var val = $(this).combobox("getValue");  //当前combobox的值
            	var allData = $(this).combobox("getData");   //获取combobox所有数据
            	var result = true;      //为true说明输入的值在下拉框数据中不存在
            	if (val=="") result=false;
            	for (var i = 0; i < allData.length; i++) {
                	if (val == allData[i][valueField]) {
                    	result = false;
                    	break;
                	}
            	}
            	if (result) {
                	$(this).combobox("clear");
                	$.messager.alert("提示","相关人员请从下拉框选择","error");
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
        title:'设备档案',
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
		{field:"tBPCERowId",title:"系统号",width:50},
		{field:"tBPBEBed",title:"床位",width:50},
		{field:"tBPCEBPCEquipMFDesc",title:"厂家名称",width:100},
		{field:"tBPCEBPCEquipModel",title:"设备型号",width:110},
		{field:"tBPCENo",title:"设备序列号",width:110},
		{field:"tBPCECode",title:"设备院内编号",width:120},
		{field:"tBPCEPurchaseDate",title:"购买日期",width:110},
		{field:"tBPCEStatusD",title:"设备状态",width:80},
		{field:"tBPCEMType",title:"设备类型",width:80},
		{field:"tBPCEPurchaseAmount",title:"购买金额(万)",width:80},
		{field:"tBPCEWarrantyYear",title:"保修年限(年)",width:80},
		{field:"installPerNameLtIn",title:"安装人员(院内)",width:100},
		{field:"installPersonOut",title:"安装人员(院外)",width:100},
		{field:"keepPerNameList",title:"保管人员",width:100},
		{field:"tBPCENote",title:"备注",width:100},
		{field:"tBPCEBPCEquipMFDr",hidden:true},
		{field:"tBPCEBPCEquipModelDr",hidden:true},
		{field:"tBPCEStatus",hidden:true},
		{field:"installPerIdLtIn",hidden:true},
		{field:"keepPerIdList",hidden:true},		
		{field:"tBPBEBedDr",hidden:true},
		{field:"tBPCEDesc",hidden:true}, //设备名称
		{field:"tBPCEBPCEAbbre",hidden:true} //设备型号缩写
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
			    text:'新增',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'修改',
			    handler: function(){
                    editRow();
                }
            },            
            {
			iconCls:"icon-print",
			text:"导出",
			handler:function(){
				var row=$("#equipmaintainBox").datagrid("getSelected");
				if(row)
				{printHandler(row);}else{
					$.messager.alert("提示","请选中一行！", "error")
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
        title:'档案信息维护',
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
		{field:"tRowId",title:"系统号",width:50},
		{field:"StartDate",title:"维护时间",width:100},
		{field:"tDBPEquipPartDesc",title:"更换部件",width:100},		
		{field:"tBPEMTypeDesc",title:"维护内容",width:100},
		{field:"tBPEMExpense",title:"维护费用",width:100},			
		{field:"userNameList",title:"参加人(院内)",width:100},
		{field:"userNameOut",title:"参加人(院外)",width:100},
		{field:"Note",title:"备注",width:100},
		{field:"userIdList",title:"userIdList",width:100,hidden:true},	
		{field:"tBPEMType",title:"tBPEMType",width:100,hidden:true},
		{field:"tDBPCEquipDr",title:"tDBPCEquipDr",width:100,hidden:true}
		]],
		toolbar:[
		{
			iconCls:"icon-add",
			text:"新增",
			handler:function(){
				InsertWinMaintain();
				//insertWinHandler(bpcERowId);
				}
			},		
			{
			iconCls:"icon-print",
			text:"导出",
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
//新增
function appendRow()
{
	    $("#equipmaintainDlg").dialog({
        title: "新增设备档案维护",
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
    		$.messager.alert("提示", "修改成功！", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("提示", datas, 'error');
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
    		$.messager.alert("提示", "新增成功！", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("提示", datas, 'error');
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
            title: "修改设备档案信息",
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
        $.messager.alert("提示", "请先选择要修改的记录！", 'error');
        return;
    }

	
}
//新增
function InsertWinMaintain()
{
	    $("#winMaintainDlg").dialog({
        title: "新增档案信息",
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
		$.messager.alert("提示","维护内容不能为空","error");
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
    		$.messager.alert("提示", "新增成功！", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("提示", datas, 'error');
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
		if(equipinfo[4]=="在用"){
			bedDesc="床位:"+equipinfo[1];				
		}				
		var htmlStr="<div>"

	
		htmlStr+="<table border='1' cellpadding='0' cellspacing='0' bordercolor='#000000' style='border-collapse:collapse;'>"
		
		htmlStr+="<thead>"
		
	    htmlStr+="<tr>"
		htmlStr+="<td width='1000' height='40' align='center' colspan='8' style='border:solid 0px'><b><font size='5'>"+"设备维修记录"+"</b></td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='300' colspan='2' style='border:solid 0px'>"+"设备型号:"+equipinfo[3]+"</td>"
		htmlStr+="<td width='300' colspan='2' style='border:solid 0px'>"+"设备序列号:"+equipinfo[2]+"</td>"
		htmlStr+="<td width='300' colspan='2' style='border:solid 0px'>"+"设备状态:"+equipinfo[4]+"</td>"
		htmlStr+="<td width='300' colspan='2' style='border:solid 0px'>"+bedDesc+"</td>"
		htmlStr+="</tr>"
		
		htmlStr+="<tr>"
		htmlStr+="<th width='90' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>序号</font></th>"
		htmlStr+="<th width='150' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>维护时间</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>更换部件</font></th>"
		htmlStr+="<th width='150' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>维护内容</font></th>"
		htmlStr+="<th width='150' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>维护费用</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>参加人(院外)</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>参加人(院外)</font></th>"
		htmlStr+="<th width='180' height='40' bgcolor='#C0C0C0' style='border:solid 1px'><font>备注</font></th>"		
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
		LODOP.PRINT_INIT("维护记录")
		LODOP.SET_SAVE_MODE("Orientation",2) //Excel文件的页面设置：横向打印   1-纵向,2-横向;
		LODOP.SET_SAVE_MODE("PaperSize",9)  //Excel文件的页面设置：纸张大小   9-对应A4
		LODOP.ADD_PRINT_TABLE(1,1,1000,300,htmlStr)
		LODOP.SAVE_TO_FILE("维护记录.xls")
}	
var winprintHandlerBak=function(r){
		var excel
		var workBook
		var sheet
		var equipinfo=r.split("^")
		try{
			excel=new ActiveXObject("Excel.Application");
			
		}catch(e){
			
			$.messager.alert("错误","计算机未安装Excel电子表格，请先安装！","error")
			
		}
		var filepath=GetFilePath();
		var fileName=filepath.replace(/[\r\n]/g,"").replace(/\ +/g,"")+"DHCBPEquipMaintain.xls";
		try{
			workBook=excel.WorkBooks.open(fileName);
			sheet=workBook.Worksheets(1);
			
			var rows=$("#winMaintainBox").datagrid("getRows");
			//var rows=winMaintainBoxObj.getRows();
			sheet.Range("A2").Value="设备型号:"+equipinfo[3];
			sheet.Range("C2").Value="设备序列号:"+equipinfo[2];
			sheet.Range("F2").Value="设备状态:"+equipinfo[4];
			if(equipinfo[4]=="在用"){
				sheet.Range("G2").Value="床位:"+equipinfo[1];
				
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
			//var savefilename="D:\\维护记录.xls";
			//sheet.SaveAs(savefilename);
			//alert("文件已导入"+savefilename);
			//sheet=null;
			//workBook.Close(savechanges=false);
			//workBook=null;
		}catch(e){
			$.messager.alert("错误","未找到打印模板，请确认打印模板的路径是否正确！","error")
			
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
	    var fileName = "设备基本信息" + "_" + curYear + curMonth + curDate + "_"   
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
		htmlStr+="<td width='500' height='40' align='center' colspan='2' style='border:solid 0px'><b><font size='5'>"+"设备档案"+"</b></td>"
		htmlStr+="</tr>"		
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"厂家名称"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEBPCEquipMFDesc+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"设备型号"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEBPCEquipModel+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"设备序列号"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCENo+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"设备院内编号"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCECode+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"购买日期"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEPurchaseDate+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"购买金额(万)"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEPurchaseAmount+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"安装人"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.installPerNameLtIn+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"保管人"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.keepPerNameList+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"保修年限"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCEWarrantyYear+"</td>"
		htmlStr+="</tr>"
		htmlStr+="<tr>"
		htmlStr+="<td width='200' height='30' style='border:solid 1px'><b><font size='3'>"+"备注"+"</b></td>"
		htmlStr+="<td width='300' style='border:solid 1px'>"+equipinfo.tBPCENote+"</td>"
		htmlStr+="</tr>"
		htmlStr+="</tbody>"		
		htmlStr+="</table>" 
		htmlStr+="</div>"
		LODOP.PRINT_INIT("设备档案")
		LODOP.SET_SAVE_MODE("Orientation",2) //Excel文件的页面设置：横向打印   1-纵向,2-横向;
		LODOP.SET_SAVE_MODE("PaperSize",9)  //Excel文件的页面设置：纸张大小   9-对应A4
		LODOP.ADD_PRINT_TABLE(1,1,1000,300,htmlStr)
		//LODOP.SET_SAVE_MODE("Zoom",90);       //Excel文件的页面设置：缩放比例
		//LODOP.SET_SAVE_MODE("CenterHorizontally",true);//Excel文件的页面设置：页面水平居中
		//LODOP.SET_SAVE_MODE("CenterVertically",true); //Excel文件的页面设置：页面垂直居中
		//LODOP.SET_SAVE_MODE("QUICK_SAVE",true);//快速生成（无表格样式,数据量较大时或许用到） 
		LODOP.SAVE_TO_FILE("设备档案.xls")
}
var printHandlerBak=function(r){
		var excel
		var workBook
		var sheet
		var equipinfo=r;
		try{
			excel=new ActiveXObject("Excel.Application");
			
		}catch(e){
			
			$.messager.alert("错误","计算机未安装Excel电子表格，请先安装！","error")
			
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
			//alert("文件已导入"+savefilename);
			//sheet=null;
			//workBook.Close(savechanges=false);
			//workBook=null;
		}catch(e){
			$.messager.alert("错误","未找到打印模板，请确认打印模板的路径是否正确！","error")
			
		}
		//excel.Quit();
		//excel=null;
	}