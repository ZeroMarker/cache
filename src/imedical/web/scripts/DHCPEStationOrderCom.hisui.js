//名称	DHCPEStationOrderCom.hisui.js
//功能	站点和项目组合
//创建	2019.05.22
//创建人  xy

var WIDTH = $(document).width();
$("#SationOrderComDiv").css("width", WIDTH*0.75);

$(function() {
	
	InitCombobox();
			
	InitStationDataGrid();
	
	InitSationOrderComDataGrid();
	
	iniForm();
	
	//查询
    $('#BFind').click(function(e){
    	BFind_click();
    });
	     
    //新增
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //修改
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //删除
    $('#del_btn').click(function(e){
    	DelData();
    });

      //可用科室
    $('#Loc_btn').click(function(e){
    	LocData();
    });
    
    //新增科室
    $('#AddLoc').click(function(e){
    	AddLoc();
    });
    
	 //修改科室
    $('#UpdateLoc').click(function(e){
    	UpdateLoc();
    });
      
     //清屏科室
    $('#ClearLoc').click(function(e){
    	ClearLoc();
    });
    //删除科室
    $('#DelLoc').click(function(e){
    	DelLoc();
    });

	$("#ARCIMDesc").keydown(function(e) {
		if(e.keyCode==13){
			BFind_click();
		}
	});
})

function iniForm() {
	var Desc = $('#StaionDesc').val();
	if (Desc.indexOf("病理") >= 0) {
		$("#CPISCode").css('display','block');//显示
	 	$("#PISCode").next(".combo").show();//显示
	} else {
		$("#CPISCode").css('display','none');//隐藏
		$("#PISCode").next(".combo").hide();//隐藏
	}
	
	if (Desc.indexOf("检验") >= 0) {
		$("#CYGItem").css('display','block');//显示
	 	$("#YGItem").next(".checkbox").show();//显示
		$('#BarPrintNum').val("1");
	} else {
		$("#CYGItem").css('display','none');//隐藏
		$("#YGItem").next(".checkbox").hide();//隐藏
		$('#BarPrintNum').val("");
	}
	$("#IFPrint").checkbox('setValue',true)
	$("#IFReprotPrint").checkbox('setValue',true)
}

//查询
function BFind_click() {
	$("#SationOrderComTab").datagrid('load', {
		ClassName:"web.DHCPE.StationOrder",
		QueryName:"QueryAll",
		ParRef:$('#ParRef').val(),
		ARCIMDesc:$("#ARCIMDesc").val(), 
		Type:"B",
		LocID:session['LOGON.CTLOCID'],
		hospId:session['LOGON.HOSPID']

	});
}

//新增
function AddData() {
	if ($("#StaionDesc").val() == "") {
		$.messager.alert('操作提示',"请选择站点","info");
		return 
	}
	$("#OrdARCIMDesc").combogrid('enable');
	$("#myWin").show();

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
					$("#ID,#ChildSub").val("")
					$("#SationOrderComTab").datagrid('load',{
		   	 		ClassName:"web.DHCPE.StationOrder",
					QueryName:"QueryAll",
					ParRef:$("#ParRef").val(),
					Type:"B",
					LocID:session['LOGON.CTLOCID'],
					hospId:session['LOGON.HOSPID']
				}); 


			}
		}]
	});
	
	$('#form-save').form("clear");
	iniForm();
	var StaionDesc=$("#StaionDesc").val();
	$("#OrdStaionDesc").val(StaionDesc);
}

SaveForm = function(id) {
	var Minute = "", iReportItemName = "";
	
	var iParRef = $.trim($("#ParRef").val());
	if (iParRef == "") {
		$.messager.alert('提示','请选择站点',"info");
		return;
	}
	
	//预约限额
	var iPreNum = $.trim($("#PreNum").val());

	//记录编码 
	var iChildSub = $.trim($("#ChildSub").val());
	
	//项目名称
    var iARCIMDR = $("#OrdARCIMDesc").combogrid('getValue');
	if (($("#OrdARCIMDesc").combogrid('getValue') == undefined) || ($("#OrdARCIMDesc").combogrid('getValue') == "")) { var iARCIMDR = ""; }
	if(iARCIMDR == "") {	
		var valbox = $HUI.combogrid("#OrdARCIMDesc", { required: true });
		$.messager.alert('提示','项目名称不能为空',"info");
		return;
	}
	if (id == "") {
		if((iARCIMDR != "") && (iARCIMDR.split("||").length < 2)) {
			$.messager.alert("提示","请选择项目名称","info");
			return false;
		}
	
		if (iARCIMDR != "") {
			var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",iARCIMDR);
			if (ret == "0") {
				$.messager.alert("提示","请选择项目名称","info");
				return false;
			}
		}
	} else {
		iARCIMDR = $("#OrdARCIMID").val();
	}

	//医嘱套
	var iARCOSDR = "";
	/*
    var iARCOSDR=$("#ARCOS_DR_Name").combogrid('getValue');
	if (($("#ARCOS_DR_Name").combogrid('getValue')==undefined)||($("#ARCOS_DR_Name").combogrid('getValue')=="")){var iARCOSDR="";}
	*/
	
	//报告格式
	var iReportFormat = $("#ReportFormat").combogrid('getValue');
	if (($("#ReportFormat").combogrid('getValue') == undefined) || ($("#ReportFormat").combogrid('getValue') == "")) { var iReportFormat = ""; }
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
	var ExtendItem = $("#ExtendItem").checkbox('getValue');
	if (ExtendItem) { iExtend = "Y"; }
	
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
	var iBaseInfoBar="0"
	var PrintBaseBar=$("#PrintBaseBar").checkbox('getValue');
	if(PrintBaseBar) {iBaseInfoBar="1";}
	
	//费用类别
	var iPatFeeType=$("#PatFeeType_DR_Name").combobox('getValue');	
	if (($('#PatFeeType_DR_Name').combobox('getValue')==undefined)||($('#PatFeeType_DR_Name').combobox('getValue')=="")){var iPatFeeType="";}
	
	//性别
	var iSex=$("#Sex_DR_Name").combobox('getValue');
	if (($('#Sex_DR_Name').combobox('getValue')==undefined)||($('#Sex_DR_Name').combobox('getValue')=="")){var iSex="";}
	
	//模板名称
	var TempName=$.trim($("#TempName").val());
	
	// 导检单上医嘱顺序
	var iPatPrintOrder=$.trim($("#PatPrintOrder").val());
	
	
	//VIP等级
	var iVIPLevel=$("#VIPLevel").combobox('getValue');
	if (($('#VIPLevel').combobox('getValue')==undefined)||($('#VIPLevel').combobox('getValue')=="")){var iVIPLevel="";}
	
	//医生顺序
	var iSort=$("#Sort").val();
    
    //PIs标本类型
	var iPISCode = $("#PISCode").combobox('getValue');
	if (($('#PISCode').combobox('getValue')==undefined)||($('#PISCode').combobox('getValue')=="")){var iPISCode="";}
	
	//允许重复
	var iAlowAddFlag="0"
	var AlowAddFlag=$("#AlowAddFlag").checkbox('getValue');
	if(AlowAddFlag) {iAlowAddFlag="1";}
	
	
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
    if(iBaseInfoBar=="1"){
	    if(iBarPrintNum==""){var iBarPrintNum=1;}
    }else{
	    var iBarPrintNum="";
    }

  ///是否打印(报告)
	var iIFReprotPrint = "N";
	var IFReprotPrint = $("#IFReprotPrint").checkbox('getValue');
	if (IFReprotPrint) { iIFReprotPrint = "Y";}

	var Instring=iParRef+"^"+""+"^"+iChildSub+"^"+iARCIMDR+"^"+iDiet+"^"+iARCOSDR+"^"+iReportFormat+"^"+iNotice		
				+"^"+iAutoReturn+"^"+iSignItem+"^"+iPhoto+"^"+TempName+"^"+iPatItemName+"^"+iExtend+"^"+iShowOrHide
    			+"^"+iYGCheck+"^"+iPatFeeType+"^"+Minute+"^"+iSex+"^"+iReportItemName+"^"+iSort+"^"+iBaseInfoBar
				+"^"+iPatPrintOrder+"^"+iIFPrint+"^"+iVIPLevel+"^"+iPreNum+"^"+iPISCode+"^"+iAlowAddFlag+"^"+iAgeMax
				+"^"+iAgeMin+"^"+iMarriedDR+"^"+iPrintName+"^"+iBarPrintNum+"^"+iIFReprotPrint;
				;
	//alert(Instring)
	
	var flag = tkMakeServerCall("web.DHCPE.StationOrder","Save",'','',Instring);
    
	if (flag=="0") {
		$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		$("#SationOrderComTab").datagrid('load',{
		    ClassName:"web.DHCPE.StationOrder",
			QueryName:"QueryAll",
			ParRef:iParRef,
			Type:"B",
			LocID:session['LOGON.CTLOCID'],
			hospId:session['LOGON.HOSPID']
		}); 
		//$("#ID,#ChildSub").val("");
			   
		//$('#myWin').dialog('close'); 
	} else if ('-119' == flag || '-120' == flag) {
		$.messager.alert('操作提示',"保存失败:此项目已被使用","error");
	} else {
		$.messager.alert('操作提示',"保存失败:"+flag,"error");	
	}	
}

//修改	
function UpdateData() {
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('操作提示',"请选择待修改的记录","info");
		return
	}
	iniForm();
	var StaionDesc=$("#StaionDesc").val();
	$("#OrdStaionDesc").val(StaionDesc);
	$("#OrdARCIMDesc").combogrid('disable');
	if(ID!="") {	
		var StationOrderStr=tkMakeServerCall("web.DHCPE.StationOrder","GetStionOrderByID",ID);
		//alert(StationOrderStr)
		var StationOrder=StationOrderStr.split("^");
		$("#ID").val(StationOrder[0]);
		$("#OrdARCIMDesc").combogrid('setValue',StationOrder[28]);
		$("#OrdARCIMID").val(StationOrder[1]);

		$("#Diet").combobox('setValue',StationOrder[2]);
		//$("#ARCOS_DR_Name").combogrid('setValue',StationOrder[3]);
		$("#ReportFormat").combogrid('setValue',StationOrder[4]);
		
		if(StationOrder[6]=="Y"){
			$("#AutoReturn").checkbox('setValue',true);
		}else{
			$("#AutoReturn").checkbox('setValue',false);
		}
		
		$("#Sort").val(StationOrder[7]);
		
		$("#TempName").val(StationOrder[8]);
		
		if(StationOrder[9]=="Y"){
			$("#ExtendItem").checkbox('setValue',true);
		}else{
			$("#ExtendItem").checkbox('setValue',false);
		}
		
		if(StationOrder[11]=="Y"){
			$("#ShowOrHide").checkbox('setValue',true);
		}else{
			$("#ShowOrHide").checkbox('setValue',false);
		}
		
		if(StationOrder[12]=="Y"){
			$("#SignItem").checkbox('setValue',true);
		}else{
			$("#SignItem").checkbox('setValue',false);
		}
		
		$("#Sex_DR_Name").combobox('setValue',StationOrder[13]);
		
		if(StationOrder[14]=="Y"){
			$("#PhotoItem").checkbox('setValue',true);
		}else{
			$("#PhotoItem").checkbox('setValue',false);
		}
		
		if(StationOrder[15]=="Y"){
			$("#SignItem").checkbox('setValue',true);
		}else{
			$("#SignItem").checkbox('setValue',false);
		}
		
		$("#PreNum").val(StationOrder[16])

		 if(StationOrder[17]=="1"){
			$("#PrintBaseBar").checkbox('setValue',true);
		}else{
			$("#PrintBaseBar").checkbox('setValue',false);
		}

		
		$("#VIPLevel").combobox('setValue',StationOrder[18]); 
		
		if(StationOrder[20]=="1"){
			$("#AlowAddFlag").checkbox('setValue',true);
		}else{
			$("#AlowAddFlag").checkbox('setValue',false);
		}
		
		if (StationOrder[27] == "Y") {
			$("#YGItem").checkbox('setValue',true);
		} else {
			$("#YGItem").checkbox('setValue',false);
		}
		
		$("#Notice").val(StationOrder[10]);
		$("#AgeMax").val(StationOrder[22]);
		$("#AgeMin").val(StationOrder[21]);
		
		$("#Married_DR_Name").combobox('setValue',StationOrder[23]);
		
		$("#PatItemName").combobox('setValue',StationOrder[25]);
		
		$("#PatPrintOrder").val(StationOrder[26]);
		
		$("#PISCode").combobox('setValue',StationOrder[24]);

		$("#PrintName").val(StationOrder[30])

		if (StationOrder[29] == "Y") {
			$("#IFPrint").checkbox('setValue',true);
		} else {
			$("#IFPrint").checkbox('setValue',false);
		}
		
		$("#BarPrintNum").val(StationOrder[31]);

		if (StationOrder[32] == "Y") {
			$("#IFReprotPrint").checkbox('setValue',true);
		} else {
			$("#IFReprotPrint").checkbox('setValue',false);
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
					$("#ID,#ChildSub").val("")
					$("#SationOrderComTab").datagrid('load',{
		   	 		ClassName:"web.DHCPE.StationOrder",
					QueryName:"QueryAll",
					ParRef:$("#ParRef").val(),
					Type:"B",
					LocID:session['LOGON.CTLOCID'],
					hospId:session['LOGON.HOSPID']
				}); 


				}
			}]
		});	
							
	}	
}

//删除
function DelData()
{

	var ID=$("#ID").val();
	var iChildSub=$("#ChildSub").val();
	var iParRef=$("#ParRef").val();
	if(ID==""){
		$.messager.alert('操作提示',"请选择待删除的记录","info");
		return
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.StationOrder", MethodName:"Delete", itmjs:'',itmjsex:'',ParRef:iParRef,ChildSub:iChildSub},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$("#ID,#ChildSub").val(""); 
					$("#SationOrderComTab").datagrid('load',{
						ClassName:"web.DHCPE.StationOrder",
						QueryName:"QueryAll",
						ParRef:$('#ParRef').val(),
						Type:"B",
						LocID:session['LOGON.CTLOCID'],
						hospId:session['LOGON.HOSPID']
					});	
	
			        $('#myWin').dialog('close'); 
				}
			});	
		}
	});
}


//修改科室
function UpdateLoc()
{
	var iOrderLocID=$("#OrderLocID").val();
	if(iOrderLocID==""){
		$.messager.alert('提示',"请选择待修改的记录","info");
		return
	}
	AddLoc();
	
}

//清屏科室
function ClearLoc()
{
	$("#Loc").combobox('setValue',"");
	$("#OrderLocID").val("")
	$("#LocTable").datagrid('reload'); 
	$("#AddLoc").linkbutton('enable');
}

//新增科室
function AddLoc(){
	
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('提示',"请选择待维护科室的医嘱","info");
		return
	}
	//科室
	var ilocid = $("#Loc").combobox('getValue');
	if (($('#Loc').combobox('getValue') == undefined) || ($('#Loc').combobox('getValue') == "")) { var ilocid = ""; }
    if(ilocid=="")
    {
	    $.messager.alert('提示',"科室不能为空","info");
	    return false;
    }

   var iOrderLocID=$("#OrderLocID").val();
   var iNoPrint="N"	
    
   var ExistFlag=tkMakeServerCall("web.DHCPE.SelectLoc","IsExistLoc",$.trim(ilocid),$.trim(ID));
    if(ExistFlag=="1"){
	      $.messager.alert('提示',"该科室已存在，无需新增","info");
	    return false;
    }

    var Instring=$.trim(ilocid)+"^"+$.trim(ID)+"^"+$.trim(iNoPrint)+"^"+$.trim(iOrderLocID);
    //alert(Instring)
    var flag=tkMakeServerCall("web.DHCPE.SelectLoc","Save",Instring);
    if(flag=="0"){
	    if(iOrderLocID==""){  $.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});}
	    else{ $.messager.popover({msg: '修改完成！',type:'success',timeout: 1000});}
	    ClearLoc();
    }
   
}

//删除科室
function DelLoc(){
	var OrderLocID=$("#OrderLocID").val();
	if(OrderLocID==""){
		$.messager.alert('提示',"请选择待删除的数据","info");
		return false;
	}
	var LocID=$("#LocID").val();
	var Instring=$.trim(LocID)+"^"+""+"^"+$.trim(OrderLocID);
            
     var flag=tkMakeServerCall("web.DHCPE.SelectLoc","Delete",Instring);
    if(flag=="0"){
	  
	    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
	     ClearLoc();
	    
    }
	
}
//可用科室维护
function LocData(){
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('操作提示',"请选择待维护科室的记录","info");
		return false;
	}
	$("OrderLocWin").show();

	var myWin = $HUI.dialog("#OrderLocWin",{
		title:'可用科室维护',
		minimizable:false,
		collapsible:false,
		modal:true,
		width:710,
		height:390
		
	});
	var LocLisObj = $HUI.datagrid("#LocTable",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		rownumbers : true, 
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.SelectLoc",
			QueryName:"Search",
			RowId:ID,
		},
		
		columns:[[
			{field:'TRowId',title:'ID',hidden: true},
			{field:'TLocId',title:'ID',hidden: true},
			{field:'TSelectLoc',width:'400',title:'科室'}, 
		]],
	onSelect: function (rowIndex, rowData) { 
				$("#OrderLocID").val(rowData.TRowId);
				$("#LocID").val(rowData.TLocId); 
				$("#AddLoc").linkbutton('disable');
		}
		
		})
	
}



function InitCombobox() {
	//医嘱名称
	var ARCIMDObj = $HUI.combogrid("#OrdARCIMDesc",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'STORD_ARCIM_DR',title:'ID',width:40},
			{field:'STORD_ARCIM_Desc',title:'医嘱名称',width:200},
			{field:'STORD_ARCIM_Code',title:'医嘱编码',width:150},			
		]],
		onLoadSuccess:function(){
			//$("#OrdARCIMDesc").combogrid('setValue',"")
			
		},
	});
		
	/*
	//医嘱套
	var OPNameObj = $HUI.combogrid("#ARCOS_DR_Name",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ARCOrdSetList",
		mode:'remote',
		delay:200,
		idField:'ARCOS_RowId',
		textField:'ARCOS_Desc',
		onBeforeLoad:function(param){
			param.ARCIMDR = param.q;
		},
		columns:[[
		    {field:'ARCOS_RowId',title:'ID',width:40},
			{field:'ARCOS_Desc',title:'名称',width:200},
			{field:'ARCOS_Code',title:'编码',width:150},			
		]],
		onLoadSuccess:function(){
			$("#ARCOS_DR_Name").combogrid('setValue',"")
			
		},
	});
	*/

	
	//报告格式
	var ReportFormatObj  = $HUI.combogrid("#ReportFormat",{
		panelWidth:200,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=SearchReportFormat",
		mode:'remote',
		delay:200,
		idField:'ReportFormat',
		textField:'ReportFormat_desc',
		onBeforeLoad:function(param){
		
		},
		columns:[[
			{field:'ReportFormat',title:'格式',width:65},
			{field:'ReportFormat_desc',title:'描述',width:110},			
		]],
		onLoadSuccess:function(){
			$("#ReportFormat").combogrid('setValue',"")
			
		},
	});
		
	//导诊单类别
	var PatItemObj = $HUI.combobox("#PatItemName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatItem&ResultSetType=array",
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
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
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
            {id:'PRE',text:'餐前'},
            {id:'POST',text:'餐后'},
            {id:'N',text:'不限'},
           
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
			param.hospId = session['LOGON.HOSPID']; 
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


	// 可用科室 
	$HUI.combobox("#Loc", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=QueryLoc&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//defaultFilter:4,
		onBeforeLoad:function(param){
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID']; 
		}

		
	});

}


//项目组合信息
function InitSationOrderComDataGrid()
{
	$HUI.datagrid("#SationOrderComTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"QueryAll",
			ParRef:"",
			Desc:"",
			Code:"",
			Type:"B",
			LocID:session['LOGON.CTLOCID'],
			hospId:session['LOGON.HOSPID']
		},
		frozenColumns:[[
			{field:'STORD_ARCIM_Code',width:'100',title:'项目编码'},
			{field:'STORD_ARCIM_Desc',width:'150',title:'项目名称'},
		]],
		columns:[[
		    {field:'STORD_ParRef',title:'STID',hidden: true},
		    {field:'STORD_RowId',title:'OrdID',hidden: true},
		    {field:'STORD_Childsub',title:'OrdSID',hidden: true},
		    {field:'STORD_ARCIM_DR',title:'ARCIMID',hidden: true},
			{field:'STORD_Diet',width:'60',title:'就餐'},
			{field:'STORD_ReportFormat',width:'80',title:'报告格式'},
			{field:'TPatItemName',width:'150',title:'导诊单类别'},
			{field:'TAlowAddFlag',width:'100',title:'允许重复加项'},
			{field:'TSex',width:'60',title:'性别'},
			{field:'TAgeMax',width:'80',title:'年龄上限'},
			{field:'TAgeMin',width:'80',title:'年龄下限'},
			{field:'TMarryDesc',width:'80',title:'婚姻'},
			{field:'TVIPLevel',width:'80',title:'VIP等级'},
			{field:'TAutoReturn',width:'80',title:'自动回传'},	
			{field:'TSignItem',width:'70',title:'特殊检查'},
			{field:'TPhotoItem',width:'80',title:'是否有片子'},
			{field:'TTempName',width:'120',title:'模板名称'},
			{field:'TExtendItem',width:'60',title:'继承'},
			{field:'TShowOrHide',width:'60',title:'禁用'},
			{field:'TPatPrintOrder',width:'120',title:'导诊单打印顺序'},
			{field:'TPreNum',width:'100',title:'预约数量'},
			{field:'TBaseBar',width:'120',title:'基本信息条码'},
			{field:'TBarPrintNum',width:'80',title:'条码数量'},
			{field:'STORD_Notice',width:'150',title:'注意事项'},
			{field:'TPISCode',width:'150',title:'标本类型'},
			{field:'TYGFlag',width:'70',title:'乙肝项目'},
			{field:'STORD_ARCOS_DR_Name',width:'100',title:'医嘱套'},
			{field:'TPrintName',width:'120',title:'打印名称(导)'},
			{field:'TIFPrint',width:'80',title:'打印(导)'},
			{field:'TIFReprotPrint',width:'80',title:'打印(报)'}
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			$("#ID").val(rowData.STORD_RowId)
			$("#ChildSub").val(rowData.STORD_Childsub)
			
			  									
		}
		
			
	})
}

function LoadSationOrderComlist(rowData)
{
	
	$('#ParRef').val(rowData.ST_RowId);
	$('#StaionDesc').val(rowData.ST_Desc);
	$("#ID,ChildSub").val("");
	$('#SationOrderComTab').datagrid('load', {
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"QueryAll",
			ParRef:$('#ParRef').val(),
			ARCIMDesc:"",
			Type:"B",
			LocID:session['LOGON.CTLOCID'],
			hospId:session['LOGON.HOSPID']
	});
	
	
}


//站点列表
function InitStationDataGrid()
{
	
	$HUI.datagrid("#StationTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [],//表头和表格之间的间隙2px
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"StationList",
		},
		columns:[[

		    {field:'ST_RowId',title:'ID',hidden: true},
		    {field:'ST_Code',title:'编码',hidden: true},
			{field:'ST_Desc',width:240,title:'站点名称'}, 	
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#SationOrderComTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadSationOrderComlist(rowData);
					
		}
		
			
	});

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
