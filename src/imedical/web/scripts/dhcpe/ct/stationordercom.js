/*
 * FileName: dhcpe/ct/stationordercom.js
 * Author: xy
 * Date: 2021-08-10
 * Description: 站点和项目组合
 */
var lastIndex = "";

var EditIndex = -1;

var ostableName = "DHC_PE_StationOrderSet"; //科室项目扩展表

var tableName = "DHC_PE_StationOrder"; //站点项目组合表

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){	
	
	//获取下拉列表
	GetLocComp(SessionStr)
	
	InitCombobox();
	
	//初始化站点Grid 
	InitStationGrid();
	 
	//初始化项目Grid 
	InitLocOrderGrid();
	
	//初始化科室项目详情Grid 
	InitLocOrderSetGrid();
	
	 //科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
 
	        var LocID=session['LOGON.CTLOCID']
			var LocListID=$("#LocList").combobox('getValue');
			if(LocListID!=""){var LocID=LocListID; }
			var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
			
			//导诊单类别-重新加载
	     	var PatItemUrl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindPatItem&ResultSetType=array&LocID="+LocID;
            $('#PatItemName').combobox('reload',PatItemUrl);
            //导诊单类别-重新加载

			//VIP等级--重新加载
	     	var VIPUrl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+LocID;
		    $('#VIPLevel').combobox('reload',VIPUrl);
		    //VIP等级--重新加载
			
			//病理标本--重新加载
		    var PISCodeUrl=$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPISCodeNew&ResultSetType=array&hospId="+hospId;
			$('#PISCode').combobox('reload',PISCodeUrl);
			//病理标本--重新加载

	    	BFind_click();//查询

	   	$("#LocOrderGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrderNew",
			StationID:$("#StationID").val(),
			ARCIMDesc:$("#ARCIMDesc").val(),
			Type:"B",
			LocID:LocID,
			hospId: hospId,
			tableName:tableName
		});
		
			//清空站点项目、项目详情的所有选中
			$("#LocOrderGrid").datagrid('clearSelections');
			$("#LocOrderSetGrid").datagrid('clearSelections');
			 lastIndex = "";
		     EditIndex = -1;
	 
       }
		
	});
	
	//查询（站点）
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
     //查询（项目）
	$("#BLFind").click(function() {	
		BLFind_click();		
     });
     //新增（项目）
	$("#BAdd").click(function() {	
		BAdd_click();		
     });
        
    //修改（项目）
	$("#BUpdate").click(function() {	
		BUpdate_click();		
     });
         
      //保存（项目）
     $('#BSave').click(function(){
    	BSave_click();
    });
    
     //数据关联科室（项目）
	$("#BRelateLoc").click(function() {	
		BRelateLoc_click();		
        });
        
      //新增（科室项目详情）
	$("#BOSAdd").click(function() {	
		BOSAdd_click();		
     });
        
    //修改（科室项目详情）
	$("#BOSUpdate").click(function() {	
		BOSUpdate_click();		
     });
         
      
	
})

 
/*******************************科室项目详情 start**********************************/

function InitDrugInfo(OrderID) {
	
	var Info=tkMakeServerCall("web.DHCPE.CT.StationOrder","GetInfoByOrderID",OrderID)
	var InfoArr=Info.split("^");
	var Id=InfoArr[0];
	//alert(Id)
	// 剂量单位
	$HUI.combobox("#UOM", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDoseUOM&ARCIMRowid=" + Id + "&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	
	// 频次
	$HUI.combobox("#Frequence", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemFreq&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	
	// 用法
	$HUI.combobox("#Instruction", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemInstruction&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	
	// 疗程
	$HUI.combobox("#Duration", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDuration&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	
}

function InitDrugDisable(OrderID){

	var Info=tkMakeServerCall("web.DHCPE.CT.StationOrder","GetInfoByOrderID",OrderID)
	var InfoArr=Info.split("^");
	var ItemRowid=InfoArr[0];
	
	var OrderType=tkMakeServerCall("web.DHCPE.CT.StationOrder","GetArcItemCat",ItemRowid);
	
	if (OrderType != "R") {
		
		$("#UOM,#Frequence,#Duration,#Instruction").combobox('disable');
		$("#DoseQty").attr('disabled',true);
		
		
	}else{
		$("#UOM,#Frequence,#Duration,#Instruction").combobox('enable');
		$("#DoseQty").attr('disabled',false);
	}
}


//新增
function BOSAdd_click() {
	if ($("#OrderID").val() == "") {
		$.messager.alert('操作提示',"请选择项目","info");
		return 
	}

	$("#myWin").show();

    InitDrugInfo($("#OrderID").val());     //初始化药品的信息
    InitDrugDisable($("#OrderID").val());  

	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-w-add',
		resizable:true,
		title:'新增',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			id:'save_btn',
			handler:function(){
				SaveForm("");
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
				$("#LocOrderSetGrid").datagrid('load',{
		    		ClassName:"web.DHCPE.CT.StationOrder",
					QueryName:"FindStationOrderSet",			
					OrderID:$("#OrderID").val(),
					LocID:$("#LocList").combobox('getValue')
				}); 


			}
		}]
	});
	
	$('#form-save').form("clear");
	
	InitLocOrderSet();
	
}

function InitLocOrderSet()
{
	$("#OrdARCIMDesc").val($("#ARCIMName").val());
	$("#OrdStaionDesc").val($("#StaionName").val());
	$("#IFReprotPrint").checkbox('setValue',true);
	$("#IFPrint").checkbox('setValue',true);

	
	
}

SaveForm = function(id) {
	var Minute = "", iReportItemName = "";
	
	var iOrderID = $("#OrderID").val();
	if (iOrderID == "") {
		$.messager.alert('提示','请选择项目',"info");
		return;
	}
	
	//预约限额
	var iPreNum = "";
	//var iPreNum = $.trim($("#PreNum").val());
	
	//报告格式
	var iReportFormat = $("#ReportFormat").combobox('getValue');
	if (iReportFormat == "") {	
		var valbox = $HUI.combogrid("#ReportFormat", { required: true });
		$.messager.alert('提示','报告格式不能为空',"info");
		return;
	}

	//就餐标志
	var iDiet = "N";
	var iDiet = $("#Diet").combobox('getValue');
	if (($('#Diet').combobox('getValue') == undefined) || ($('#Diet').combobox('getValue') == "")) { var iDiet = "N"; }
	
	// 注意事项
	var iNotice = $.trim($("#Notice").val());
	
	//特殊检查
	var iSignItem = "N";
	var SignItem = $("#SignItem").checkbox('getValue');
	if (SignItem) { iSignItem = "Y"; }
	
	//乙肝项目
	var iYGCheck = "N";
	var YGCheck = $("#YGItem").checkbox('getValue');
	if (YGCheck) { iYGCheck = "Y"; }
	
	//是否有片子
	var iPhoto = "N";
	var PhotoItem = $("#PhotoItem").checkbox('getValue');
	if (PhotoItem) { iPhoto = "Y"; }	
	
	//导诊单类别
	var iPatItemName = $("#PatItemName").combobox('getValue')
	if (($('#PatItemName').combobox('getValue') == undefined) || ($('#PatItemName').combobox('getValue') == "")) { var iPatItemName = ""; }
	if (iPatItemName == "") {
		var valbox = $HUI.combobox("#PatItemName", {
			required: true,
	    });
		$.messager.alert('提示','导检单类别不能为空',"info");
		return false;
	}
	
	//自动回传
	var iAutoReturn = "N";
	var AutoReturn = $("#AutoReturn").checkbox('getValue');
	if (AutoReturn) { iAutoReturn = "Y"; }
	
	//继承
	var iExtend = "N";
	//var ExtendItem = $("#ExtendItem").checkbox('getValue');
	//if (ExtendItem) { iExtend = "Y"; }
	
	//禁用
	var iShowOrHide = "N";
	var ShowOrHide = $("#ShowOrHide").checkbox('getValue');
	if (ShowOrHide) { iShowOrHide="Y"; }
	
	///是否打印(导诊单)
	var iIFPrint = "N";
	var IFPrint = $("#IFPrint").checkbox('getValue');
	if (IFPrint) { iIFPrint = "Y";}
	
	///打印名称(导诊单)
	var iPrintName = $("#PrintName").val();

	//基本信息条码
	var iBaseInfoBar="N"
	var PrintBaseBar=$("#PrintBaseBar").checkbox('getValue');
	if(PrintBaseBar) {iBaseInfoBar="Y";}
	
	//费用类别
	var iPatFeeType=$("#PatFeeType_DR_Name").combobox('getValue');	
	if (($('#PatFeeType_DR_Name').combobox('getValue')==undefined)||($('#PatFeeType_DR_Name').combobox('getValue')=="")){var iPatFeeType="";}
	
	//性别
	var iSex=$("#Sex_DR_Name").combobox('getValue');
	if (($('#Sex_DR_Name').combobox('getValue')==undefined)||($('#Sex_DR_Name').combobox('getValue')=="")){var iSex="";}
	
	//模板名称(检查申请单)
	var iTempName=$.trim($("#TempName").val());
	
	//VIP等级
	var iVIPLevel=$("#VIPLevel").combobox('getValue');
	if (($('#VIPLevel').combobox('getValue')==undefined)||($('#VIPLevel').combobox('getValue')=="")){var iVIPLevel="";}
	
	//医生顺序
	var iSort=$("#Sort").val();
    
    //PIs标本类型
	var iPISCode = $("#PISCode").combobox('getValue');
	if (($('#PISCode').combobox('getValue')==undefined)||($('#PISCode').combobox('getValue')=="")){var iPISCode="";}
	
	//允许重复
	var iAlowAddFlag="N"
	var AlowAddFlag=$("#AlowAddFlag").checkbox('getValue');
	if(AlowAddFlag) {iAlowAddFlag="Y";}
	
	
	//年龄上下限
	var iAgeMax=$.trim($("#AgeMax").val());
	if (iAgeMax!=""){
		if (!isNumber(iAgeMax))
		{ 
		 	$.messager.alert("提示","年龄上限格式不对,请输入正整数","error");
        	return false;
		}
	}

	var iAgeMin=$.trim($("#AgeMin").val());
	if(iAgeMin!=""){
		if (!isNumber(iAgeMin)) { 
		 	$.messager.alert("提示","年龄下限格式不对,请输入正整数","error");
        	return false;
		}
	}
	if(parseInt(iAgeMax)<parseInt(iAgeMin)){
		$.messager.alert("提示","年龄下限大于年龄上限","error");
        return false;
	}
	
	//婚姻
	var iMarriedDR = $('#Married_DR_Name').combobox('getValue');
	if (($('#Married_DR_Name').combobox('getValue')==undefined)||($('#Married_DR_Name').combobox('getValue')=="")) {var iMarriedDR = "";}
	
	//条码数量
	var iBarPrintNum=$("#BarPrintNum").val();
    if(iBarPrintNum!=""){
	    if(!isPositiveInteger(iBarPrintNum)){
		    $.messager.alert("提示","条码数量格式不对,请输入整数","info");
		    return false
	    }
	   if((iBaseInfoBar=="0")&&(iReportFormat.indexOf("LIS")<0)){
		    $.messager.alert("提示","请勾选基本信息条码","info");
		    return false;
		    }

    }
    
    if(iBaseInfoBar=="Y"){
	    if(iBarPrintNum==""){var iBarPrintNum=1;}
    }else{
	    var iBarPrintNum="";
    }

	// 导检单上医嘱顺序
	//var iPatPrintOrder=$.trim($("#PatPrintOrder").val());
	var iPatPrintOrder="";

	//顺序(导)
	var iSort=$("#PrintSort").val();
    
    //打印（报告）
    var iIFReprotPrint="N"
	var IFReprotPrint=$("#IFReprotPrint").checkbox('getValue');
	if(IFReprotPrint) {iIFReprotPrint="Y";}
	
    var LocID=$("#LocList").combobox('getValue');
    var UserID=session['LOGON.USERID'];
    
	//不打折
    var iNoDiscount="N"
	var NoDiscount=$("#NoDiscount").checkbox('getValue');
	if(NoDiscount) {iNoDiscount="Y";}

	//合并打印
	var iPrintType="N"
	var PrintType=$("#PrintType").checkbox('getValue');
	if(PrintType) {iPrintType="Y";}
	
	if((iTempName=="")&&(iPrintType=="Y")){
		
		$.messager.alert("提示","检查申请单为空，不需要设置合并打印！","info");	
		return false;	
		
	}
	
	 //剂量
	var iDoseQty=$("#DoseQty").val();
	
	//剂量单位
	var iUOM=$("#UOM").combobox('getValue');
	
	//频次
	var iFrequence=$("#Frequence").combobox('getValue');
	
	//疗程
	var iDuration=$("#Duration").combobox('getValue');
	
	//用法
	var iInstruction=$("#Instruction").combobox('getValue');

	// 检查目的
	var iPurpose = $.trim($("#Purpose").val());
	
	
	//网络预约
	var iNetPre = "N";
	var NetPre = $("#NetPreFlag").checkbox('getValue');
	if (NetPre) { iNetPre = "Y"; }
	
	var Instring=iOrderID+"^"+LocID+"^"+iDiet+"^"+iReportFormat+"^"+iNotice		
				+"^"+iAutoReturn+"^"+iSignItem+"^"+iPhoto+"^"+iTempName+"^"+iPatItemName+"^"+iExtend+"^"+iShowOrHide
    			+"^"+iYGCheck+"^"+iPatFeeType+"^"+iSex+"^"+iReportItemName+"^"+iSort+"^"+iBaseInfoBar
				+"^"+iPatPrintOrder+"^"+iIFPrint+"^"+iVIPLevel+"^"+iPreNum+"^"+iPISCode+"^"+iAlowAddFlag+"^"+iAgeMax
				+"^"+iAgeMin+"^"+iMarriedDR+"^"+iPrintName+"^"+iBarPrintNum+"^"+iSort+"^"+iIFReprotPrint+"^"+UserID+"^"+iNoDiscount
				+"^"+iPrintType+"^"+iDoseQty+"^"+iUOM+"^"+iFrequence+"^"+iDuration+"^"+iInstruction+"^"+iPurpose+"^"+iNetPre;
				
	//alert(Instring)
	
	var ret = tkMakeServerCall("web.DHCPE.CT.StationOrder","SaveStationOrderSet",id,Instring,ostableName);
    
    var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		$.messager.alert("提示",Arr[1],"error");		
	}else{
		$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		$('#myWin').dialog('close'); 
		$("#LocOrderSetGrid").datagrid('load',{
		    ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrderSet",			
			OrderID:$("#OrderID").val(),
			LocID:$("#LocList").combobox('getValue')
		}); 

			
	} 	
		
}

//修改	
function BOSUpdate_click() {
	var ID=$("#OrderSetID").val();
	
	if(ID==""){
		$.messager.alert('操作提示',"请选择待修改的记录","info");
		return
	}

	InitLocOrderSet();
	InitDrugInfo($("#OrderID").val());  //初始化药品信息
    InitDrugDisable($("#OrderID").val());

	if(ID!="") {	
		var StationOrdeSetrStr=tkMakeServerCall("web.DHCPE.CT.StationOrder","GetStionOrderSetByID",ID);
		//alert(StationOrdeSetrStr)
		var StationOrderSet=StationOrdeSetrStr.split("^");
	
		$("#Diet").combobox('setValue',StationOrderSet[0]);

		$("#ReportFormat").combobox('setValue',StationOrderSet[1]);

	
		$("#Notice").val(StationOrderSet[2]);
		
		if(StationOrderSet[3]=="Y"){
			$("#AutoReturn").checkbox('setValue',true);
		}else{
			$("#AutoReturn").checkbox('setValue',false);
		}
		
		
		$("#Sort").val(StationOrderSet[4]);
		
		$("#Sex_DR_Name").combobox('setValue',StationOrderSet[5]);
		
		$("#Married_DR_Name").combobox('setValue',StationOrderSet[6]);
		
		$("#AgeMax").val(StationOrderSet[7]);
		
		$("#AgeMin").val(StationOrderSet[8]);
		
		$("#VIPLevel").combobox('setValue',StationOrderSet[9]); 
		 if(StationOrderSet[10]=="Y"){
			$("#PrintBaseBar").checkbox('setValue',true);
		}else{
			$("#PrintBaseBar").checkbox('setValue',false);
		}
		if(StationOrderSet[11]=="Y"){
			$("#AlowAddFlag").checkbox('setValue',true);
		}else{
			$("#AlowAddFlag").checkbox('setValue',false);
		}
		$("#PISCode").combobox('setValue',StationOrderSet[12]);
		
		//$("#PreNum").val(StationOrderSet[13]);

		$("#TempName").val(StationOrderSet[14]);
		
		if (StationOrderSet[15] == "Y") {
			$("#YGItem").checkbox('setValue',true);
		} else {
			$("#YGItem").checkbox('setValue',false);
		}
		if(StationOrderSet[16]=="Y"){
			$("#SignItem").checkbox('setValue',true);
		}else{
			$("#SignItem").checkbox('setValue',false);
		}
		
	
		if(StationOrderSet[17]=="Y"){
			$("#ShowOrHide").checkbox('setValue',true);
		}else{
			$("#ShowOrHide").checkbox('setValue',false);
		}
		/*
		if(StationOrderSet[18]=="Y"){
			$("#ExtendItem").checkbox('setValue',true);
		}else{
			$("#ExtendItem").checkbox('setValue',false);
		}
		*/
		
		if(StationOrderSet[19]=="Y"){
			$("#PhotoItem").checkbox('setValue',true);
		}else{
			$("#PhotoItem").checkbox('setValue',false);
		}
		
		if(StationOrderSet[20]=="Y"){
			$("#IFReprotPrint").checkbox('setValue',true);
		}else{
			$("#IFReprotPrint").checkbox('setValue',false);
		}
		
		$("#BarPrintNum").val(StationOrderSet[21]);
		
		//alert(StationOrderSet[22])
		$("#PatItemName").combobox('setValue',StationOrderSet[22]);
		
		$("#PrintSort").val(StationOrderSet[23]);
		
		if (StationOrderSet[24] == "Y") {
			$("#IFPrint").checkbox('setValue',true);
		} else {
			$("#IFPrint").checkbox('setValue',false);
		}
		
		$("#PrintName").val(StationOrderSet[25]);

		$("#PatFeeType_DR_Name").combobox('setValue',StationOrderSet[26]);
		
			
		if(StationOrderSet[27]=="Y"){
			$("#NoDiscount").checkbox('setValue',true);
		}else{
			$("#NoDiscount").checkbox('setValue',false);
		}

        $("#DoseQty").val(StationOrderSet[28]);
        $("#UOM").combobox('setValue',StationOrderSet[29]);
        $("#Frequence").combobox('setValue',StationOrderSet[30]);
        $("#Duration").combobox('setValue',StationOrderSet[31]);
        $("#Instruction").combobox('setValue',StationOrderSet[32]);
        if (StationOrderSet[33] == "Y") {
			$("#PrintType").checkbox('setValue',true);
		} else {
			$("#PrintType").checkbox('setValue',false);
		}
		$("#Purpose").val(StationOrderSet[34]);
		if (StationOrderSet[35] == "Y") {
			$("#NetPreFlag").checkbox('setValue',true);
		} else {
			$("#NetPreFlag").checkbox('setValue',false);
		}
		$("#myWin").show();
		
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'修改',
			modal:true,
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveForm(ID)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
					//alert($("#OrderID").val()+"^"+$("#LocList").combobox('getValue'))
					$("#LocOrderSetGrid").datagrid('load',{
		    			ClassName:"web.DHCPE.CT.StationOrder",
						QueryName:"FindStationOrderSet",
						
						OrderID:$("#OrderID").val(),
						LocID:$("#LocList").combobox('getValue')
					}); 
					$("#OrderSetID").val("");

				}
			}]
		});	
							
	}	
}






var LocOrderSetColumns = [[
	{field:'TOrderSetID',title:'OrderSetID',hidden:true},
	{field:'TStationName',width:'80',title:'站点名称'},
	{field:'TARCIMDesc',width:'80',title:'医嘱名称'},
	{field:'TDiet',width:'60',title:'就餐'},
	{field:'TReportFormat',width:'80',title:'报告格式'},
	{field:'TPatItemName',width:'150',title:'导诊单类别'},
	{field:'TAlowAddFlag',width:'100',title:'允许重复加项',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TPatFeeType',width:'90',title:'费用类别'},
	{field:'TSex',width:'60',title:'性别'},
	{field:'TAgeMax',width:'80',title:'年龄上限'},
	{field:'TAgeMin',width:'80',title:'年龄下限'},
	{field:'TMarryDesc',width:'80',title:'婚姻'},
	{field:'TVIPLevel',width:'80',title:'VIP等级'},
	{field:'TAutoReturn',width:'80',title:'自动回传',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},	
	{field:'TSignItem',width:'70',title:'特殊检查',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
     },
	{field:'TPhoto',width:'80',title:'是否有片子',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TTempName',width:'120',title:'模板名称'},
	{field:'TExtend',width:'60',title:'继承',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TShowOrHide',width:'60',title:'禁用',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
    },
	//{field:'TPreNum',width:'100',title:'预约数量'},
	{field:'TBaseInfoBar',width:'120',title:'基本信息条码',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TBarPrintNum',width:'80',title:'条码数量'},
	{field:'TPISCode',width:'150',title:'标本类型'},
	{field:'TYGFlag',width:'70',title:'乙肝项目',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TIFReprotPrint',width:'120',title:'打印(报告)',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
     },
	  {field:'TNoDiscount',width:'120',title:'不打折',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
     },
	{field:'TUsherSort',width:'120',title:'顺序(导)'},
	{field:'TUsherPrtName',width:'120',title:'打印名称(导)'},
	{field:'TUsherIsPrint',width:'80',title:'打印(导)',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TDoseQty',width:'80',title:'剂量'},
	{field:'TUOM',width:'100',title:'剂量单位'},
	{field:'TFrequence',width:'80',title:'频次'},
	{field:'TDuration',width:'80',title:'疗程'},
	{field:'TInstruction',width:'80',title:'用法'},
	{field:'TPrintType',width:'100',title:'合并打印',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TNetPreFlag',width:'100',title:'网络预约',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TNoticeInfo',width:'120',title:'注意事项'},
	{field:'TUpdateDate',width:'100',title:'更新日期'},
	{field:'TUpdateTime',width:'120',title:'更新时间'},
	{field:'TUpdateUser',width:'100',title:'更新人'}

			
]];
 



//初始化科室项目详情Grid 
function InitLocOrderSetGrid()
{
	$('#LocOrderSetGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200],  
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: LocOrderSetColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrderSet",
			
		},
		onSelect: function (rowIndex, rowData) {
			$("#OrderSetID").val(rowData.TOrderSetID)
			
	
		},
		onLoadSuccess: function (data) {
			
		}
	});
	
	
}
 
 function LoadLocOrderSetGrid(OrderID){
	 $("#LocOrderSetGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StationOrder",
		QueryName:"FindStationOrderSet",
		OrderID:OrderID,
		LocID:$("#LocList").combobox('getValue')
	});	
 }	
/*******************************科室项目详情 end************************************/

/*******************************项目 start******************************************/


//数据关联科室
function BRelateLoc_click()
{
	
	var DateID=$("#OrderID").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}
   
   var LocID=$("#LocList").combobox('getValue');
   //alert("LocID:"+LocID)
   OpenLocWin(tableName,DateID,SessionStr,LocID,function(){})
   
   $("#LocOrderGrid").datagrid('reload');
   
}


//新增
function BAdd_click()
 {
	 var StationID=$("#StationID").val();
	 if(StationID==""){
		$.messager.alert('提示',"请选择需要维护的站点",'info');
		return;
	 }
	 
	$('#LocOrderGrid').datagrid('getRows').length
	lastIndex = $('#LocOrderGrid').datagrid('getRows').length - 1;
	$('#LocOrderGrid').datagrid('selectRow', lastIndex);
	$("#LocOrderGrid").datagrid('clearSelections');
	
	var selected = $('#LocOrderGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TOrderID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#LocOrderGrid').datagrid('appendRow', {
		TOrderID: '',
		TARCIMDR:'',
		TARCIMDesc:'',
		TNoActive:'Y'
	});
	
	lastIndex = $('#LocOrderGrid').datagrid('getRows').length - 1;
	$('#LocOrderGrid').datagrid('selectRow',lastIndex);
	$('#LocOrderGrid').datagrid('beginEdit',lastIndex);
	EditIndex = lastIndex;
 }
 
 //修改
 function BUpdate_click()
 {
	var selected = $('#LocOrderGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#LocOrderGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#LocOrderGrid').datagrid('beginEdit', thisIndex);
		$('#LocOrderGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#LocOrderGrid').datagrid('getSelected');

		var thisEd = $('#LocOrderGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TARCIMDesc'  
		});
		$(thisEd.target).combobox('select', selected.TARCIMDR);  
		
	}
 }

//保存
function BSave_click()
{ 
	$('#LocOrderGrid').datagrid('acceptChanges');
	var selected = $('#LocOrderGrid').datagrid('getSelected');
	if(selected ==null){
		$.messager.alert('提示', "请选择待保存的数据", 'info');
		return;
	}

	if (selected) {
		
		if (selected.TOrderID == "") {
			if ((selected.TARCIMDesc == "undefined")||(selected.TARCIMDesc == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				$("#LocOrderGrid").datagrid('reload');
				return;
			}
			var StationID=$("#StationID").val();
			var iActive=selected.TNoActive;
			var iARCIMID=selected.TARCIMDesc;	
			var LocID=$("#LocList").combobox('getValue');
			var UserID=session['LOGON.USERID'];
			var Empower=selected.TEmpower;
			var ID=""
			var InputStr=StationID+"^"+ID+"^"+iARCIMID+"^"+iActive+"^"+tableName+"^"+LocID+"^"+UserID+"^"+Empower;
			$.m({
				ClassName: "web.DHCPE.CT.StationOrder",
				MethodName: "Insert",
				InputStr:InputStr
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});	
				}

				$("#LocOrderGrid").datagrid('reload');
			});
		} else {
			$('#LocOrderGrid').datagrid('selectRow', EditIndex);
			var selected = $('#LocOrderGrid').datagrid('getSelected');
			if ((selected.TARCIMDesc == "undefined")||(selected.TARCIMDesc == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				$("#LocOrderGrid").datagrid('reload');
				return;
			}
			var iActive=selected.TNoActive;
			var iARCIMID=selected.TARCIMDesc;	
			if((iARCIMID != "") && (iARCIMID.split("||").length < 2)) {
				$.messager.alert("提示","请选择项目名称","info");
				return false;
			}
	
			if (iARCIMID != "") {
				var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",iARCIMID);
				if (ret == "0") {
					$.messager.alert("提示","请选择项目名称","info");
					return false;
				}
			}
			var LocID=$("#LocList").combobox('getValue');
			var UserID=session['LOGON.USERID'];
			var Empower=selected.TEmpower;
			var ID=selected.TOrderID;
			var InputStr=""+"^"+ID+"^"+iARCIMID+"^"+iActive+"^"+tableName+"^"+LocID+"^"+UserID+"^"+Empower;

			$.m({
				ClassName: "web.DHCPE.CT.StationOrder",
				MethodName: "Update",
				InputStr:InputStr	
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('修改失败:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});	
				}
			   $("#LocOrderGrid").datagrid('reload');
			});
		}
	}
}



var LocOrderColumns = [[
	{
		field:'TOrderID',
		title:'TOrderID',
		hidden:true
	},{
		field:'TStationName',
		title:'站点',
		width: 100
	},{
		field:'TARCIMDR',
		title:'TARCIMDR',
		hidden:true
	},{
		field:'TARCIMCode',
		title:'医嘱编码',
		width: 100
	},{
		field: 'TARCIMDesc',
		title: '项目',
		width: 230,
		formatter:function(value,row){
            return row.TARCIMDesc;
         },
		editor:{
           type:'combobox',
           options:{
	           required: true,
                valueField:'STORD_ARCIM_DR',
                textField:'STORD_ARCIM_Desc',
                 mode:'remote', 
          		/*onShowPanel: function () { // 只有在下拉层显示时,才去关联url拉取数据,提高首屏速度
					var url = $(this).combobox('options').url;
					if (!url){
						//$(this).combobox('options').mode = 'remote';
						var url = $URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList&ResultSetType=array";
						$(this).combobox('reload',url);		
						}
					},*/

                url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList&ResultSetType=array",
                onBeforeLoad:function(param){   
			       	param.Desc = param.q;
					param.Type="B";
					param.LocID=$('#LocList').combobox('getValue');
					param.hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$('#LocList').combobox('getValue'));         
                  }
                        
               }
         }
	},{
		field: 'TNoActive',
		width: 60,
		title: '激活',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
				on:'Y',
				off:'N'
			}
						
		}
	},{
		field: 'TEmpower',
		width: 80,
		title: '单独授权',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
					on:'Y',
				off:'N'
			}
						
		}
	},{ field:'TEffPowerFlag',width:100,align:'center',title:'当前科室授权',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	},{
		field: 'TUpdateDate',
		width: '120',
		title: '更新日期'
	}, {
		field: 'TUpdateTime',
		width: '120',
		title: '更新时间'
	}, {
		field: 'TUserName',
		width: '120',
		title: '更新人'
	}
			
]];


//初始化项目Grid 
function InitLocOrderGrid(){
	
	var iActive = "N";
	var Active = $("#Active").checkbox('getValue');
	if (Active) { iActive = "Y"; }

    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

	$('#LocOrderGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		//displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:LocOrderColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrderNew",
			ARCIMDesc:"",
			Active:iActive,
			Type:"B",
			LocID:LocID,
			hospId:hospId,
			tableName:tableName
			
		},
		onSelect: function (rowIndex,rowData) {
			
		if(rowIndex!="-1"){

			if(rowData.TEmpower=="Y"){		
				$("#BRelateLoc").linkbutton('enable');
			}else{
				$("#BRelateLoc").linkbutton('disable');
			}
				
			$("#OrderID").val(rowData.TOrderID);
			$("#StaionName").val(rowData.TStationName);
			$("#ARCIMName").val(rowData.TARCIMDesc);
			LoadLocOrderSetGrid(rowData.TOrderID);
			$("#OrderSetID").val('');
		}

		},
		onLoadSuccess: function (data) {
			EditIndex = -1;	
		}
	});
}

//查询
function BLFind_click(){
	
var iActive = "N";
var Active = $("#Active").checkbox('getValue');
if (Active) { iActive = "Y"; }

var LocID=$("#LocList").combobox('getValue');
var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

$("#LocOrderGrid").datagrid('load', {
	ClassName:"web.DHCPE.CT.StationOrder",
	QueryName:"FindStationOrderNew",
	StationID:$("#StationID").val(),
	ARCIMDesc:$("#ARCIMDesc").val(),
	Active:iActive,
	Type:"B",
	LocID:LocID,
	hospId:hospId,
	tableName:tableName
});
}

function LoadLocOrderGrid(StationID){
	
var iActive = "N";
var Active = $("#Active").checkbox('getValue');
if (Active) { iActive = "Y"; }

var LocID=$("#LocList").combobox('getValue');
var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

$("#LocOrderGrid").datagrid('load', {

	ClassName:"web.DHCPE.CT.StationOrder",
	QueryName:"FindStationOrderNew",
	StationID:StationID,
	ARCIMDesc:"",
	Active:iActive,
	Type:"B",
	LocID:LocID,
	hospId:hospId,
	tableName:tableName

});
	
}
/*******************************项目 end*******************************************/



/*******************************站点 start*****************************************/

// 初始化站点维护DataGrid
function InitStationGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$('#StaionGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
		
		    {field:'TStationID',title:'ID',hidden: true},
			{field:'TStationCode',title:'代码',width: 70},
			{field:'TStationDesc',title:'描述',width: 180},
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationSet",
			LocID:LocID,
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			LoadLocOrderGrid(rowData.TStationID);
			LoadLocOrderSetGrid("");
			$("#OrderID").val('');
			$("#OrdARCIMDesc").val('');
			$("#OrdStaionDesc").val('');
			$("#OrderSetID").val('');
			//清空站点项目、项目详情的所有选中
			$("#LocOrderGrid").datagrid('clearSelections');
			$("#LocOrderSetGrid").datagrid('clearSelections');
			 lastIndex = "";
		     EditIndex = -1;
		
		},
		onLoadSuccess: function (data) {
			
		}
	});
	
}



//查询（站点）
function BFind_click(){
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		LocID:$("#LocList").combobox('getValue'),
		Desc:$("#Desc").val(),
		STActive:"Y"
	});	
	
}
/*******************************站点 end*************************************/

var ReportFormatData = [{
		id: 'RF_CAT',
		text: $g('打印格式 多层')
	}, {
		id: 'RF_LIS',
		text: $g('打印格式 检验')
	}, {
		id: 'RF_NOR',
		text: $g('打印格式 默认')
	}, {
		id: 'RF_RIS',
		text: $g('打印格式 检查')
	}, {
		id: 'RF_EKG',
		text: $g('打印格式 心电')
	}, {
		id: 'RF_PIS',
		text: $g('打印格式 病理')
}];

function InitCombobox(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

	//报告格式
	$HUI.combobox("#ReportFormat", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:ReportFormatData
	});
		
	//导诊单类别
	var PatItemObj = $HUI.combobox("#PatItemName",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindPatItem&ResultSetType=array&LocID="+LocID,
		valueField:'id',
		textField:'desc',
	});
		
	//体检费别
	var PatFeeObj = $HUI.combobox("#PatFeeType_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'70',
	});
			
	//性别
	var SexObj = $HUI.combobox("#Sex_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex',
		panelHeight:'130',
	});
	
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+LocID,
		valueField:'id',
		textField:'desc',
	});
		
	//婚姻状况	
	var MarriedObj = $HUI.combobox("#Married_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married'
	});
		
	//就餐
	var DietObj = $HUI.combobox("#Diet",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'PRE',text:$g('餐前')},
            {id:'POST',text:$g('餐后')},
            {id:'N',text:$g('不限')},
           
        ]

	});	
	
	
	//病理标本类型
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	if (flag == 1) {
		var PISObj = $HUI.combobox("#PISCode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPISCodeNew&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){ 
			param.hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		}

		});
	} else {
		var PISObj = $HUI.combobox("#PISCode",{
			valueField:'id',
			textField:'text',
			panelHeight:'100',
			data:[
	            {id:'20',text:'细胞'},
	            {id:'23',text:'TCT'},
        	]

		});	
	}

    
}


//是否为正整数
function isPositiveInteger(s){

     var re =/^\+?[1-9][0-9]*$/ ;

     return re.test(s)

 }

//判断输入的字符串是否为非负整数
function isNumber(elem){
 var pattern= /^\d+$/;
 if(pattern.test(elem)){
  return true;
 }else{
  return false;
 }
}