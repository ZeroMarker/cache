
/*
 * FileName: dhcpe/ct/stationlocordersort.js
 * Author: xy
 * Date: 2021-08-11
 * Description: 站点分类对应项目维护
 */
var SOSlastIndex = "";
var SOSEditIndex = -1;

var lastIndex = "";
var EditIndex = -1;

var tableName = "DHC_PE_StationOrdCatSort"; //科室站点分类序号表
 
var SOStableName = "DHC_PE_StationOrderSort"; //科室站点项目序号表

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

 $(function(){	
	
	//获取科室下拉列表
	GetLocComp(SessionStr)
	
	//科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){    
	     BFind_click();	
	     $("#StationID").val('');
	     $("#SOCSID").val('');
	     InitStationLocDetailGrid();
	     InitStationLocGrid();  
	 
       }
		
	});
	 
	InitCombobox();
	
	//初始化站点Grid 
	InitStationGrid();
	 
	//初始化分类序号Grid 
	InitStationLocGrid(); 
	
	//初始化分类对应项目Grid 
	InitStationLocDetailGrid()
	
	//查询（站点）
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
      //新增(分类序号)
     $('#BAdd').click(function(e){
    	BAdd_click();
    });
    
    //修改(分类序号)
     $('#BUpdate').click(function(){
    	BUpdate_click();
    });
    
      //保存(分类序号）
     $('#BSave').click(function(){
    	BSave_click();
    });
    
     //数据关联科室（分类序号）
	$("#BRelateLoc").click(function() {	
		BRelateLoc_click();		
        });
        
    //新增(分类对应项目)
     $('#BSOSAdd').click(function(e){
    	BSOSAdd_click();
    });
    
    //修改(分类对应项目)
     $('#BSOSUpdate').click(function(){
    	BSOSUpdate_click();
    });
    
     //保存(分类对应项目）
     $('#BSOSSave').click(function(){
    	BSOSSave_click();
    });
    
     //数据关联科室（分类对应项目）
	$("#BSOSRelateLoc").click(function() {	
		BSOSRelateLoc_click();		
        });
          
	
 })
 
 /*******************************分类对应项目 start*****************************************/

//数据关联科室（分类对应项目）
function BSOSRelateLoc_click()
{
	var SOSID=$("#SOSID").val()
	if (SOSID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}
  
   var LocID=$("#LocList").combobox('getValue')
   //alert(SOStableName+"^"+SOSID+"^"+SessionStr+"^"+LocID)
   OpenLocWin(SOStableName,SOSID,SessionStr,LocID,InitStationLocDetailGrid)
}
      
 //新增(分类对应项目)
function BSOSAdd_click()
 {
	  var SOCSID=$("#SOCSID").val();
	 if(SOCSID==""){
		 $.messager.alert('提示', "请选择分类序号", 'info');
		return;
	 }

	SOSlastIndex = $('#StationLocDetailGrid').datagrid('getRows').length - 1;
	$('#StationLocDetailGrid').datagrid('selectRow', SOSlastIndex);
	var selected = $('#StationLocDetailGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TSOSID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((SOSEditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#StationLocDetailGrid').datagrid('appendRow', {	
		TSOSID:'',
		TSOSOrderDR:'',
		TARCIMDesc:'',
		TSOSSort:''
		
		});
	SOSlastIndex = $('#StationLocDetailGrid').datagrid('getRows').length - 1;
	$('#StationLocDetailGrid').datagrid('selectRow', SOSlastIndex);
	$('#StationLocDetailGrid').datagrid('beginEdit', SOSlastIndex);
	SOSEditIndex = SOSlastIndex;
 }
 
 //修改(分类序号)
 function BSOSUpdate_click()
 {
	var selected = $('#StationLocDetailGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#StationLocDetailGrid').datagrid('getRowIndex', selected);
		if ((SOSEditIndex != -1) && (SOSEditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#StationLocDetailGrid').datagrid('beginEdit', thisIndex);
		$('#StationLocDetailGrid').datagrid('selectRow', thisIndex);
		SOSEditIndex = thisIndex;
		var selected = $('#StationLocDetailGrid').datagrid('getSelected');

		var thisEd = $('#StationLocDetailGrid').datagrid('getEditor', {
				index: SOSSEditIndex,
				field: 'TSOSSort'  
			});
		
		var thisEd = $('#StationLocDetailGrid').datagrid('getEditor', {
				index: OSEditIndex,
				field: 'TARCIMDesc'  
				
			});	
		$(thisEd.target).combobox('select', selected.TSOSOrderDR);  
				
		
	}
 }

//保存
function BSOSSave_click()
{
	var SOCSID=$("#SOCSID").val();
	var OrderID=$("#OrderID").val();
	$('#StationLocDetailGrid').datagrid('acceptChanges');
	var selected = $('#StationLocDetailGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TSOSID == "") {
			if ((selected.TARCIMDesc == "undefined") || (selected.TSOSSort == "undefined") ||(selected.TARCIMDesc=="")||(selected.TSOSSort == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				$("#StationLocDetailGrid").datagrid('reload');
				return;
			}
			var OrderDR=selected.TARCIMDesc;
			if((OrderDR != "") && (OrderDR.split("||").length < 2)) {
				$.messager.alert("提示","请选择项目","info");
				return false;
			}
			var SOSSort=selected.TSOSSort; 
			var tableName=SOStableName;
			var LocID=$("#LocList").combobox('getValue');
			var UserID=session['LOGON.USERID'];
			var Empower=selected.TEmpower;
			
			var flag = tkMakeServerCall("web.DHCPE.CT.StationLoc","IsExsistSort",SOCSID,"",LocID,tableName,SOSSort);
			if(flag==1){
				$.messager.alert("提示","顺序号重复！","info");
				return false;
			}
			
			var InputStr=""+"^"+SOCSID+"^"+OrderDR+"^"+SOSSort+"^"+tableName+"^"+LocID+"^"+UserID+"^"+Empower;
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "SaveStatOrderSort",
				InputStr:InputStr			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');
					
				}else{
					$.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
				}
				
				$("#StationLocDetailGrid").datagrid('reload');
			});
		} else {
			$('#StationLocDetailGrid').datagrid('selectRow', SOSEditIndex);
			var selected = $('#StationLocDetailGrid').datagrid('getSelected');
			if ((selected.TSOSSort == "undefined") || (selected.TARCIMDesc == "undefined") ||(selected.TSOSSort=="")||(selected.TARCIMDesc == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				$("#StationLocDetailGrid").datagrid('reload');
				return;
			}
			var ID=selected.TSOSID;
			var OrderDR=OrderID;
			//var OrderDR=selected.TARCIMDesc;
			if((OrderDR != "") && (OrderDR.split("||").length < 2)) {
				$.messager.alert("提示","请选择项目","info");
				return false;
			}
			var SOSSort=selected.TSOSSort; 
			
			
			var tableName=SOStableName;
			var LocID=$("#LocList").combobox('getValue');
			var UserID=session['LOGON.USERID'];
			var Empower=selected.TEmpower;
			
			var flag = tkMakeServerCall("web.DHCPE.CT.StationLoc","IsExsistSort",SOCSID,ID,LocID,tableName,SOSSort);
			if(flag==1){
				$.messager.alert("提示","顺序号重复！","info");
				return false;
			}
			var InputStr=ID+"^"+SOCSID+"^"+OrderDR+"^"+SOSSort+"^"+tableName+"^"+LocID+"^"+UserID+"^"+Empower;
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "SaveStatOrderSort",
				InputStr:InputStr	
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('修改失败:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '修改成功',type:'success',timeout: 1000});
				}
			
				$("#StationLocDetailGrid").datagrid('reload');
			});
		}
	}
}

	
var StationLocDetailColumns = [[
	{
		field:'TSOSID',
		title:'SOSID',
		hidden:true
	},{
		field:'TSOSOrderDR',
		title:'TSOSOrderDR',
		hidden:true
	},{
		field:'TSOSSort',
		width: '60',
		title:'顺序号',
		editor: 'text',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox'
		}
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
                valueField:'TOrderID',
                textField:'TARCIMDesc',
                method:'get',
                url:$URL+"?ClassName=web.DHCPE.CT.StationOrder&QueryName=FindStationOrder&ResultSetType=array",
                onBeforeLoad:function(param){   
			       	param.ARCIMDesc = param.q;
			       	param.StationID=$("#StationID").val();
					param.Type="B";
					param.LocID=session['LOGON.CTLOCID'];
					param.hospId = session['LOGON.HOSPID']; 
					param.tableName="DHC_PE_StationOrder"              
                  }
                        
               }
         }
	},{
		field:'TARCIMDR',
		title:'TARCIMDR',
		hidden:true
	},{
		field: 'TEmpower',
		width: '70',
		title: '单独授权',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
				on:'Y',
				off:'N'
			}
						
		},
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}

	},{ field:'TEffPowerFlag',
		width:100,
		align:'center',
		title:'当前科室授权',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	}
]];

//初始化分类对应项目Grid  
function InitStationLocDetailGrid(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	$('#StationLocDetailGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: StationLocDetailColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationLoc",
			QueryName:"FindStatOrderSort",
			SOCSID:$("#SOCSID").val(),
			tableName:SOStableName,
			LocID:locId
		},
		onSelect: function (rowIndex, rowData) {
			if(rowIndex!="-1"){
			if(rowData.TEmpower=="Y"){		
				$("#BSOSRelateLoc").linkbutton('enable');
			}else{
				$("#BSOSRelateLoc").linkbutton('disable');
			}
	
			$("#SOSID").val(rowData.TSOSID);
			$("#OrderID").val(rowData.TSOSOrderDR);
			}

		},
		onLoadSuccess: function (data) {
			SOSEditIndex = -1;
		}
	});
	
	
}

function LoadStationLocDetailGrid(SOCSID)
{
	 
	$("#StationLocDetailGrid").datagrid('load',{
	ClassName:"web.DHCPE.CT.StationLoc",
			QueryName:"FindStatOrderSort",
			SOCSID:SOCSID,
			tableName:SOStableName,
			LocID:$("#LocList").combobox('getValue')
		
	});	
	
}


 /*******************************分类对应项目 end*****************************************/
 
 /*******************************分类序号 start*****************************************/
 //数据关联科室
function BRelateLoc_click()
{
	var SOCSID=$("#SOCSID").val()
	if (SOCSID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}
  
   var LocID=$("#LocList").combobox('getValue')
  
    OpenLocWin(tableName,SOCSID,SessionStr,LocID,InitStationLocGrid)
}


//新增(分类序号)
function BAdd_click()
 {
	var StationID=$("#StationID").val();
	if(StationID==""){
		$.messager.alert('提示', "请选择待维护的站点", 'info');
		return;
	}

	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	var selected = $('#StationLocGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TSOCSID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#StationLocGrid').datagrid('appendRow', {
		TSOCSID:'',
		TOrdCatDR:'',
		TSOCSDesc:'',
		TSOCSSort:''
		
		
			});
	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	$('#StationLocGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //修改(分类序号)
 function BUpdate_click()
 {
	var selected = $('#StationLocGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#StationLocGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#StationLocGrid').datagrid('beginEdit', thisIndex);
		$('#StationLocGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#StationLocGrid').datagrid('getSelected');

		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TSOCSSort'  
			});
		
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TSOCSDesc'  
				
			});	
		$(thisEd.target).combobox('select', selected.TOrdCatDR);  
				
		
	}
 }

//保存
function BSave_click()
{
	$('#StationLocGrid').datagrid('acceptChanges');
	var selected = $('#StationLocGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TSOCSID == "") {
			if ((selected.TSOCSDesc == "undefined") || (selected.TSOCSSort == "undefined") ||(selected.TSOCSDesc=="")||(selected.TSOCSSort == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				$("#StationLocGrid").datagrid('reload');
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "SaveStationOrdCatSort",
				OrdCatID:selected.TSOCSDesc, 
				LocSort:selected.TSOCSSort, 
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'), 
				UserID:session['LOGON.USERID'], 
				Empower:selected.TEmpower
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');	
				}else{
					$.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
				}
				$("#StationLocGrid").datagrid('reload');
			});
		} else {
			$('#StationLocGrid').datagrid('selectRow', EditIndex);
			var selected = $('#StationLocGrid').datagrid('getSelected');
		if ((selected.TSOCSDesc == "undefined") || (selected.TSOCSSort == "undefined") ||(selected.TSOCSDesc=="")||(selected.TSOCSSort == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				$("#StationLocGrid").datagrid('reload');
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "SaveStationOrdCatSort",
				ID:selected.TSOCSID,
				OrdCatID:selected.TSOCSDesc, 
				LocSort:selected.TSOCSSort, 
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'), 
				UserID:session['LOGON.USERID'], 
				Empower:selected.TEmpower
				
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('修改失败:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '修改成功',type:'success',timeout: 1000});
				}
			
				$("#StationLocGrid").datagrid('reload');
			});
		}
	}
}

	
var StationLocColumns = [[
	{
		field:'TSOCSID',
		title:'SOCSID',
		hidden:true
	},{
		field:'TSOCSSort',
		width: '60',
		title:'顺序号',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox'
		}
	},{
		field:'TSOCSDesc',
		title:'分类描述',
		width:120,
		formatter:function(value,row){
            return row.TSOCSDesc;
         },
		editor:{
           type:'combobox',
           required: true,
           options:{
	           required: true,
                valueField:'TSLID',
                textField:'TSLDesc',
                method:'get',
                url:$URL+"?ClassName=web.DHCPE.CT.StationLoc&QueryName=FindStationLoc&ResultSetType=array",
                onBeforeLoad:function(param){   
			       	param.Desc = param.q;
					param.StationID=$("#StationID").val();
					param.LocID=$("#LocList").combobox('getValue')
					          
                  }
                        
               }
         }
	},{
		field:'TOrdCatDR',
		title:'TOrdCatDR',
		hidden:true
	},{
		field: 'TEmpower',
		width: '70',
		title: '单独授权',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
				on:'Y',
				off:'N'
			}
						
		},
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}

	},{ field:'TEffPowerFlag',
		width:100,
		align:'center',
		title:'当前科室授权',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	}
]];
	
	
//初始化分类序号Grid 
function InitStationLocGrid(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	$('#StationLocGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: StationLocColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationLoc",
			QueryName:"FindStatOrdCat",
			StationID:$("#StationID").val(),
			tableName:tableName,
			LocID:locId 
		},
		onSelect: function (rowIndex, rowData) {
			if(rowData!=undefined){
				if(rowData.TEmpower=="Y"){		
					$("#BRelateLoc").linkbutton('enable');
				}else{
					$("#BRelateLoc").linkbutton('disable');
				}
		    
				$("#SOCSID").val(rowData.TSOCSID);
				LoadStationLocDetailGrid(rowData.TSOCSID)
			}

		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
	
}


function LoadStationLocGrid(StationID)
{ 
	$("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StationLoc",
		QueryName:"FindStatOrdCat",
		StationID:StationID,
		tableName:tableName,
		LocID:$("#LocList").combobox('getValue')
		
	});	
	
}
 /*******************************分类序号 end*****************************************/
 
 /*******************************站点 start*****************************************/

// 初始化站点维护DataGrid
function InitStationGrid()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

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
			LocID:locId,
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			LoadStationLocGrid(rowData.TStationID);
			$("#BRelateLoc").linkbutton('disable');
			$("#StationLocDetailGrid").datagrid('reload');
		
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
		STActive:"Y",
		
	});	
	
}
/*******************************站点 end*************************************/

 function InitCombobox(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; } 
	
	 //站点分类
	var LocDescObj = $HUI.combobox("#LocDesc",{
		url:$URL+"?ClassName=web.DHCPE.CT.StationLoc&QueryName=FindStationLoc&ResultSetType=array&LocID="+LocID,
		valueField:'TSLID',
		textField:'TSLDesc',
	});
 }
 
 
 function isInteger(num) {
    if (!isNaN(num) && num % 1 === 0) {
       return true;
    } else {
      return false;
   }
}
