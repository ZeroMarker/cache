/*
 * FileName: dhcpe/ct/orderdetailrelatecom.js
 * Author: xy
 * Date: 2021-08-14
 * Description: 大项和细项对照关系维护
 */
 
var odrtableName = "DHC_PE_OrderDetailRelate"; //大项和细项对照关系
var tableName ="DHC_PE_StationOrder";  //站点和项目组合表
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	//获取科室下拉列表
	GetLocComp(SessionStr)

	//科室下拉列表change
	$("#LocList").combobox({
	 onSelect:function(){
		 BFind_click();
		 $("#OrderID,#ARCIMDesc").val('');
		 BAFind_click();
		BClear_click();
	       	    		 
	 }
	})

	InitCombobox();
		
	//初始化 站点Grid 
	InitStationGrid()
	 
	//查询（站点）
	$("#BFind").click(function() {	
		BFind_click()		
	})
 
	$("#Desc").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click()
		}
	})
  
	//初始化项目Grid 
	InitLocOrderGrid()

	//查询（项目）
	$("#BAFind").click(function() {	
		BAFind_click()	
	})
 
	$("#ARCDesc").keydown(function(e) {	
		if(e.keyCode==13){
			BAFind_click()
		}
	})

	//初始化细项组合Grid 
	InitODRelateComDataGrid()

	//清屏
	$("#BClear").click(function(e){
		BClear_click();
	});
	     
	//新增
	$("#BAdd").click(function(e){
		BAdd_click();
	});
    
	//修改
	$("#BUpdate").click(function(){
	BUpdate_click();
	});
    
	//删除
	$("#BDelete").click(function(e){
		BDelete_click();
	}); 
 
	$('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			LoadODRelateComDatalist();
			
		}
			
	});  

	//导入LIS项目
	$("#BImport").click(function(e){
	 BImport_click();
	 }); 
    
	iniForm(); 

	//授权科室
	$("#BRelateLoc").click(function(){
		BRelateLoc_click();
	})
	
})

function iniForm(){
	
	var StationID=$("#StationID").val();
	
	var globalLoc = $("#LocList").combobox("getValue");
	var LocID= globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	var StationType = tkMakeServerCall("web.DHCPE.CT.HISUICommon","GetStationTypeByID",StationID,LocID);
	
    if(StationType=="LIS"){
        $("#BImport").linkbutton('enable');
    }else{
        $("#BImport").linkbutton('disable');
    }
	
}

//导入
function BImport_click()
{
	var UserID=session['LOGON.USERID'];
	
    var globalLoc = $("#LocList").combobox("getValue");
	var LocID= globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	var StationID=$("#StationID").val();
	
	var ARCIMDr=$("#ARCIMDR").val(); 
	if(ARCIMDr==""){
		$.messager.alert("提示","请选择医嘱项！","info");
		return false;	
	 }
	
	var OrderDR=$("#OrderID").val();
	
	var LocGrpID=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetLocGrpByLocID",LocID);
	if(LocGrpID.split("^")[0]=="-1"){
		$.messager.alert("提示","该科室没有维护对应的默认科室！","info");
		return false;
		
	}
	var LocStr=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetLocIDByLocGrp",LocGrpID);
	if(LocStr.split("^")[0]=="-1"){
		$.messager.alert("提示","科室组下没有对应的科室ID！","info");
		return false;
		
	}
    
	var flag=tkMakeServerCall("web.DHCPE.TransOrderDetail","MainNew",ARCIMDr,StationID,OrderDR,LocID,UserID,LocStr);
	
	BClear_click();
	
}
/**********************细项组合 start************************************/
/*
//单独授权/取消授权
function BPower_click(){
	var DateID=$("#ODRRowId").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要单独授权的记录","info"); 
		return false;
	}
	var selected = $('#ODRelateComGrid').datagrid('getSelected');
	if(selected){
	
		//单独授权 
		var iEmpower="N";
		var Empower=$("#Empower").checkbox('getValue');
		if(Empower) iEmpower="Y";
		var LocID=$("#LocList").combobox('getValue');
		var UserID=session['LOGON.USERID'];
	    var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",odrtableName,DateID,LocID,UserID,iEmpower)
		var rtnArr=rtn.split("^");
		if(rtnArr[0]=="-1"){
			$.messager.alert("提示","授权失败","error");
		}else{
			$.messager.alert("提示","授权成功","success");
			 $("#ODRelateComGrid").datagrid('reload');
		}		
	}	
}
    
*/

//授权科室
function BRelateLoc_click()
{
	var DateID=$("#ODRRowId").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}
   var LocID=$("#LocList").combobox('getValue');
   //alert("LocID:"+LocID)
   OpenLocWin(odrtableName,DateID,SessionStr,LocID,InitODRelateComDataGrid);
   
}


//新增
function BAdd_click(){
	BSave_click("0");
} 

//修改
function BUpdate_click(){
	BSave_click("1");
}

function BSave_click(Type){
	
	if(Type=="1"){
		var ID=$("#ODRRowId").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
		if($("#OrderID").val()==""){
		    	$.messager.alert("提示","请先选择项目","info");
		    	return false;
		    }
	    if($("#ODRRowId").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
		var ID="";
	}
	
	 var iRowId=$("#ODRRowId").val(); 
	 
	var iARCIMDR=$("#ARCIMDR").val();  

   //细项名称
	var iODDR=$("#ODDRName").combogrid('getValue');
	if (($("#ODDRName").combogrid('getValue')==undefined)||($("#ODDRName").combogrid('getValue')=="")){var iODDR="";}
	if (""==iODDR) {
		$("#ODDRName").focus();
		var valbox = $HUI.combogrid("#ODDRName", {
			required: true,
	    });
		$.messager.alert("提示","请选择细项名称,细项名称不能为空","info");
		return false;
	}
	
	 if(iRowId!=""){var iODDR=$("#ODRowId").val();}
	 if(iODDR!="")
	 {
		 var flag=tkMakeServerCall("web.DHCPE.OrderDetailRelate","IsOrderDetailFlag",iODDR);
		 if(flag=="0"){
			 $.messager.alert("提示","请下拉选择细项","info");
			return false;
		 }
	 }

	
	
	//顺序号
	var iSequence=$("#Sequence").val(); 
	if (""==iSequence) {
		$("#Sequence").focus();
		var valbox = $HUI.validatebox("#Sequence", {
			required: true,
	    });
		$.messager.alert("提示","顺序号不能为空","info");
		return false;
	}
	if((!(isInteger(iSequence)))||(iSequence<=0)) 
		   {
			   $.messager.alert("提示","顺序号只能是正整数","info");
			    return false; 
		   }


	//是否必填项
	var iRequired="N";
	var Required=$("#Required").checkbox('getValue');
	if(Required) iRequired="Y";
		
	// 父项
	var iParentDR=$("#Parent_DR_Name").combogrid('getValue');
	if (($("#Parent_DR_Name").combogrid('getValue')==undefined)||($("#Parent_DR_Name").combogrid('getValue')=="")){var iParentDR="";}
	 
	// 层次
	var iCascade=$("#Cascade").val();
	if ("1"==iCascade) { iParentDR=""; }

	if((iCascade!="1")&&(iCascade!="")&&(iParentDR=="")){
		$.messager.alert("提示","请选择父项","info");
		return false;
		
	}
	
	// 报告中比对
	/*
	var iHistory="N";
	var HistoryFlag=$("#HistoryFlag").checkbox('getValue');
	if(HistoryFlag) iHistory="Y";
	*/
	
	//激活
	var iNoActive="N";
	var NoActive=$("#NoActive").checkbox('getValue');
	if(NoActive) iNoActive="Y";
	
	var OrderID=$("#OrderID").val();
	
	//单独授权 
	var iEmpower="N";
	var Empower=$("#Empower").checkbox('getValue');
	if(Empower) iEmpower="Y";
		
	var Instring=$.trim(iRowId)	         //大项和细项目对照数据ID		
				+"^"+$.trim(iARCIMDR)	 //医嘱项ID	
				+"^"+$.trim(iODDR)	     //细项ID	
				+"^"+$.trim(iSequence)	
				+"^"+$.trim(iRequired)	
				+"^"+$.trim(iParentDR)	
				+"^"+$.trim(iCascade)
				+"^"+iNoActive	
				+"^"+OrderID	          //站点和项目组合ID
				+"^"+iEmpower			
				;
	
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	
	//alert(Instring)
	 /*****************************判断项目是否已对照细项 start ****************************************************/
	 var ret=tkMakeServerCall("web.DHCPE.CT.OrderDetailRelate","GetODRelateInfo",iRowId);
	 var Info=ret.split("^");
	 var ODRODDR=Info[1]; //细项ID
	 if(ODRODDR==undefined){var ODRODDR="";}
     if(ODRODDR!=iODDR){
		var IsExsistFlag=tkMakeServerCall("web.DHCPE.CT.OrderDetailRelate","IsExsistODRelate",OrderID,iODDR,LocID);
		if(IsExsistFlag=="1"){
			$.messager.alert('提示', '项目已对照该细项，请不要重复对照！' ,'info');
			return false;	
		}
	}
	/*****************************判断项目是否已对照细项 end ****************************************************/
	

	var rtn=tkMakeServerCall("web.DHCPE.CT.OrderDetailRelate","SaveOrderDetailRelate",Instring,odrtableName,UserID,LocID);
	var rtnArr=rtn.split("^");
	if(rtnArr[0]=="-1"){
		$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');	
	}else{
		if(Type=="1"){$.messager.alert("操作提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("操作提示","新增成功","success");}
		BClear_click();
	}
	
}

//删除
function BDelete_click(){
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	var ID=$("#ODRRowId").val();
	
	if(ID==""){
			$.messager.alert("提示","请选择待删除的记录","info");
			return false;
		}
			
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.CT.OrderDetailRelate", MethodName:"DeleteODRelate",RowID:ID,UserID:UserID,LocID:LocID},function(ReturnValue){
				var rtnArr=ReturnValue.split("^");
				if (rtnArr[0]=='-1') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					BClear_click();
				
				}
			});	
		}
	});
}


//清屏
function BClear_click(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	$("#ODRRowId,#ODRowId,#Sequence,#Cascade").val("");
	$("#ODDRName").combogrid('setValue',"");
	$("#Parent_DR_Name").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#NoActive").checkbox('setValue',true);
	
	var valbox = $HUI.combogrid("#ODDRName", {
			required: false,
	    });
	var valbox = $HUI.validatebox("#Sequence", {
			required: false,
	    });

	$("#ODRelateComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.OrderDetailRelate",
			QueryName:"FindOrderDetailRelate",
			ODROrderDR:$("#OrderID").val(),
			tableName:odrtableName, 
			LocID:locId
		
	});
}

function InitODRelateComDataGrid()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	$HUI.datagrid("#ODRelateComGrid",{
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
			ClassName:"web.DHCPE.CT.OrderDetailRelate",
			QueryName:"FindOrderDetailRelate",
			ODROrderDR:$("#OrderID").val(),
			tableName:odrtableName, 
			LocID:locId
		},
		frozenColumns:[[
			{field:'ODR_OD_DR_Name',width:'150',title:'细项名称'},
		    {field:'ODR_OD_DR_Code',width:'100',title:'细项编码'},
			 
		]],
		columns:[[
		    {field:'ODR_RowId',title:'ODRRowId',hidden: true},
		    {field:'ODR_ARCIM_DR',title:'ARCIMDR',hidden: true},
		    {field:'ODR_OD_DR',title:'ODRowId',hidden: true},
		    {field:'ODR_ARCIM_DR_Name',title:'ARCIMDesc',hidden: true},
			{field:'ODR_Sequence',width:'80',title:'顺序号'},
			{field:'ODR_Required',width:'120',title:'是否必填项',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			//{field:'THistoryFlag',width:'120',title:'报告中比对'},
			{field:'ODR_Cascade',width:'80',title:'层次'},
			{field:'ODR_Parent_DR_Name',width:'100',title:'父项'},
			{field:'TNoActive',width:80,title:'激活',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TEmpower',width:80,title:'单独授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
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
			},
			{field:'TUpdateDate',width:120,title:'更新日期'},	
			{field:'TUpdateTime',width:120,title:'更新时间'},	
			{field:'TUserName',width:120,title:'更新人'}
			
		]],
		onSelect: function (rowIndex, rowData) {
			
			if(rowData.TEmpower=="Y"){
				
				$("#BRelateLoc").linkbutton('enable');
				$("#Empower").checkbox('setValue',true);
				$("#BPower").linkbutton({text:$g('取消授权')});
			}else{
				if(rowData.TNoActive=="Y")	{
					$("#BRelateLoc").linkbutton('disable');
					$("#BPower").linkbutton('enable');
					$("#Empower").checkbox('setValue',false);
					$("#BPower").linkbutton({text:$g('单独授权')})
					
				}else{
					$("#BRelateLoc").linkbutton('disable');
					$("#BPower").linkbutton('disable');	
					
				}
			}
			$("#ODRRowId").val(rowData.ODR_RowId);
			$("#ARCIMDR").val(rowData.ODR_ARCIM_DR);
			$("#ODRowId").val(rowData.ODR_OD_DR);
			$("#ODDRName").combogrid('setValue',rowData.ODR_OD_DR_Name);
			$("#Sequence").val(rowData.ODR_Sequence);
			$("#Cascade").val(rowData.ODR_Cascade);
			$("#Parent_DR_Name").combogrid('setValue',rowData.ODR_Parent_DR_Name);
			
			if(rowData.ODR_Required=="Y"){
				$("#Required").checkbox('setValue',true);
			}else{
				$("#Required").checkbox('setValue',false);
			}
			
			if(rowData.TNoActive=="Y"){
				$("#NoActive").checkbox('setValue',true);
			}else{
				$("#NoActive").checkbox('setValue',false);
			}
			if(rowData.ODR_Cascade=="1"){
			$("#Parent_DR_Name").combogrid("disable");
			}else{
			$("#Parent_DR_Name").combogrid("enable");
			}
		
		}
		
			
	})
}


function LoadODRelateComDatalist()
{	
    var LocID=$("#LocList").combobox('getValue');
    
	$("#ODRelateComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.OrderDetailRelate",
			QueryName:"FindOrderDetailRelate",
			ODROrderDR:$("#OrderID").val(),
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			tableName:odrtableName,
			LocID:LocID
			
				
	});	
	
}
/**********************细项组合 end************************************/



/**********************项目 start************************************/

//初始化项目Grid 
function InitLocOrderGrid(){
	
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
		columns:[[
			{field:'TOrderID',title:'TOrderID',hidden: true},
		 	{field:'TARCIMDR',title:'TARCIMDR',hidden: true},
		 	{field:'TARCIMDesc',width:190,title:'项目名称'},
		 	{field:'TARCIMCode',width:130,title:'编码'}	    
		 	
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrder",
			ARCIMDesc:"",
			Type:"B",
			LocID:LocID,
			hospId:hospId,
			tableName:tableName
			
		},
		onSelect: function (rowIndex,rowData) {
	
		$("#OrderID").val(rowData.TOrderID);
		$("#ARCIMDR").val(rowData.TARCIMDR);
		
		$("#ARCIMDesc").val(rowData.TARCIMDesc);
		$('#ODRelateComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
		LoadODRelateComDatalist(rowData);
		 
		},
		onLoadSuccess: function (data) {
			
		}
	})
}


//查询(项目)
function BAFind_click(){
	
var LocID=$("#LocList").combobox('getValue');
var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

$("#LocOrderGrid").datagrid('load', {
	ClassName:"web.DHCPE.CT.StationOrder",
	QueryName:"FindStationOrder",
	StationID:$("#StationID").val(),
	ARCIMDesc:$("#ARCDesc").val(),
	Type:"B",
	LocID:LocID,
	hospId:hospId,
	tableName:tableName
})
}

/**********************项目  end************************************/


/**********************站点 start************************************/
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
			$("#OrderID,#ARCIMDesc").val('');
			 BAFind_click();
			 BClear_click();
			 iniForm();
			/*$("#ODDesc").val('');
		
		
			$('#OrderDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			
			BODFind_click();
			$("#ODRowID,#ODSDesc,#ODType").val('');
			BClear_click();
			$('#ODStandardComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			*/
		
		},
		onLoadSuccess: function (data) {		 
			
		}
	});
	
}

//查询（站点）
function BFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');
	
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		LocID:LocID,
		Desc:$("#Desc").val(),
		STActive:"Y"
	});	
	
}

/**********************站点 end************************************/

function InitCombobox()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	//var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	
	//细项名称
	var ODObj = $HUI.combogrid("#ODDRName",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.CT.StatOrderDetail&QueryName=FindOrderDetail",
		mode:'remote',
		delay:200,
		idField:'TODID',
		textField:'TODDesc',
		onBeforeLoad:function(param){
			param.StationID = $("#StationID").val();
			param.Desc = param.q;
			param.LocID=LocID;
			param.tableName="DHC_PE_OrderDetail";
		},
		onShowPanel:function()
		{
			$('#ODDRName').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'TODID',title:'ID',hidden: true},
		    {field:'TODDesc',title:'描述',width:150},
		    {field:'TODCode',title:'编码',width:100},  	    	
					
		]],
		onLoadSuccess:function(){
			
			
		},

		});
		
	//父项
	var OrdObj = $HUI.combogrid("#Parent_DR_Name",{
		panelWidth:249,
		url:$URL+"?ClassName=web.DHCPE.OrderDetailRelate&QueryName=SearchParentOrderDetailRelate",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ARCIMDR = $("#ARCIMDR").val();
			param.Desc = param.q;
		},
		onShowPanel:function()
		{
			$('#Parent_DR_Name').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'ID',title:'ID',width:80},
		    {field:'Desc',title:'名称',width:140}, 
		
					
		]]
		});
	
}



 function isInteger(num) {
      if (!isNaN(num) && num % 1 === 0) {
        return true;
      } else {
        return false;
      }
}
