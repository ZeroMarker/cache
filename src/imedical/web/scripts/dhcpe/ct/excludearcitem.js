/*
 * FileName: dhcpe/ct/excludearcitem.js
 * Author: xy
 * Date: 2021-08-16
 * Description: 排斥项目维护
 */
 
var lastIndex = "";
 
var EditIndex = -1;

var tableName ="DHC_PE_StationOrder";  //站点和项目组合表

var extableName ="DHC_PE_ExcludeArcItem";//排斥项目表

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
//获取科室下拉列表
GetLocComp(SessionStr)

//科室下拉列表change
$("#LocList").combobox({
  onSelect:function(){
	  
	  BFind_click();
	  
	  BAFind_click();
	  
	  $("#ARCIMRowID").val('');
	  
	  var LocID=session['LOGON.CTLOCID']
	  var LocListID=$("#LocList").combobox('getValue');
	  if(LocListID!=""){var LocID=LocListID; }
	 
	  $("#ExcludeArcItemGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:$("#ARCIMRowID").val(),
			LocID:LocID,
			tableName:extableName
		
	});
	       	    		 
  }
})

		
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

//初始化排斥项目Grid				
InitExcludeArcItemGrid();

//新增
$("#BAdd").click(function(e){
   BAdd_click();
 });
		
//修改
$("#BUpdate").click(function(e){
    BUpdate_click();
});
 
//保存
$("#BSave").click(function(e){
   BSave_click();
 });
	   
//删除
$("#BDelete").click(function(e){
    BDelete_click();
 });
      
//授权科室
$("#BRelateLoc").click(function(){
   BRelateLoc_click();
 })
	
})

/************************排斥项目 start****************/

//数据关联科室
function BRelateLoc_click()
{
	var DateID=$("#ID").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}
   
   var LocID=$("#LocList").combobox('getValue')
   //alert("LocID:"+LocID)
    OpenLocWin(extableName,DateID,SessionStr,LocID,LoadExcludeArcItemGrid)
   
   $("#ExcludeArcItemGrid").datagrid('reload');
   $("#BRelateLoc").linkbutton('disable');
   
}

//删除
function BDelete_click()
{
	var UserID=session['LOGON.USERID'];

	var RowId=$("#ID").val();
	
	if (RowId=="")
	{
		$.messager.alert("提示","请先选择待删除的记录","info");	
		return false;
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.CT.ExcludeArcItem", MethodName:"DeleteExcludeArcItem",ID:RowId,UserID:UserID},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$("#ExcludeArcItemGrid").datagrid('reload');
				}
			});	
		}
	});
	
		
}

//新增
function BAdd_click()
 {
	var ARCIMRowID=$("#ARCIMRowID").val();
	if(ARCIMRowID==""){
		$.messager.alert('提示', "请先选择待维护的项目", 'info');
		return;	
	}
	lastIndex = $('#ExcludeArcItemGrid').datagrid('getRows').length - 1;
	$('#ExcludeArcItemGrid').datagrid('selectRow', lastIndex);
	var selected = $('#ExcludeArcItemGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#ExcludeArcItemGrid').datagrid('appendRow', {
		TID: '',
		TExArcItemDesc:'',
		TUpdateDate:'',
		TUpdateTime:'',
		TUpdateUser:'',
		TEmpower:'',
		TEffPowerFlag:''
	});
	lastIndex = $('#ExcludeArcItemGrid').datagrid('getRows').length - 1;
	$('#ExcludeArcItemGrid').datagrid('selectRow', lastIndex);
	$('#ExcludeArcItemGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
	
 }
 
 //修改
 function BUpdate_click()
 {
	var selected = $('#ExcludeArcItemGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#ExcludeArcItemGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#ExcludeArcItemGrid').datagrid('beginEdit', thisIndex);
		$('#ExcludeArcItemGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#ExcludeArcItemGrid').datagrid('getSelected'); 
		 
		var thisEd = $('#ExcludeArcItemGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TExArcItemDesc'  
			});
		
		$(thisEd.target).combobox('select', selected.TExArcItemDR);
		
	}
 }

//保存
function BSave_click()
{
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	var ARCIMID=$("#ARCIMRowID").val();
	
	$('#ExcludeArcItemGrid').datagrid('acceptChanges');
	var selected = $('#ExcludeArcItemGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TID == "") {
			if ((selected.TExArcItemDesc == "undefined") || (selected.TExArcItemDesc == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				$("#ExcludeArcItemGrid").datagrid('reload');
				return;
			}
			var ID=selected.TID;
			var ExArcItemID=selected.TExArcItemDesc;
			var Empower=selected.TEmpower;
			var InfoStr=ID+"^"+ARCIMID+"^"+ExArcItemID+"^"+Empower+"^"+LocID+"^"+UserID;
			
			if(ARCIMID==ExArcItemID){
				$.messager.alert("提示","排斥的项目和维护项目不允许相同","info");
				$("#ExcludeArcItemGrid").datagrid('reload');
				return false;
			}

			var flag=tkMakeServerCall("web.DHCPE.CT.ExcludeArcItem","IsExcludeArcItem",ARCIMID,ExArcItemID,LocID);
			if(flag=="1"){
				$.messager.alert("提示","已存在该排斥项目","info");
				$("#ExcludeArcItemGrid").datagrid('reload');
				return false;
		
			}

			//alert(InfoStr)
			$.m({
				ClassName: "web.DHCPE.CT.ExcludeArcItem",
				MethodName: "SaveExcludeArcItem",
				InfoStr:InfoStr,
				tableName:extableName
			     
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){
					
					$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');
					
				}else{
					$.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
				}	
				$("#ExcludeArcItemGrid").datagrid('reload');
			});
		} else {
			$('#ExcludeArcItemGrid').datagrid('selectRow', EditIndex);
			var selected = $('#ExcludeArcItemGrid').datagrid('getSelected');
			if ((selected.TExArcItemDesc == "undefined") || (selected.TExArcItemDesc == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				$("#ExcludeArcItemGrid").datagrid('reload');
				return;
			}
			var ID=selected.TID;
			var ExArcItemID=selected.TExArcItemDesc;
			if((ExArcItemID != "") && (ExArcItemID.split("||").length < 2)) {
				$.messager.alert("提示","请选择排斥项目","info");
				return false;
			}
			if (ExArcItemID != "") {
				var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",ExArcItemID);
				if (ret == "0") {
					$.messager.alert("提示","请选择排斥项目","info");
					return false;
				}
			}
			if(ARCIMID==ExArcItemID){
				$.messager.alert("提示","排斥的项目和维护项目不允许相同","info");
				$("#ExcludeArcItemGrid").datagrid('reload');
				return false;
			}
           	
            if(selected.TExArcItemDR!=ExArcItemID){
				var flag=tkMakeServerCall("web.DHCPE.CT.ExcludeArcItem","IsExcludeArcItem",ARCIMID,ExArcItemID,LocID);
				if(flag=="1"){
					$.messager.alert("提示","已存在该排斥项目","info");
					$("#ExcludeArcItemGrid").datagrid('reload');
					return false;
		
				}
            }
			

			var Empower=selected.TEmpower;
			var InfoStr=ID+"^"+ARCIMID+"^"+ExArcItemID+"^"+Empower+"^"+LocID+"^"+UserID;
			//alert(InfoStr)

			$.m({
				ClassName: "web.DHCPE.CT.ExcludeArcItem",
				MethodName: "SaveExcludeArcItem",
				InfoStr:InfoStr,
				tableName:extableName
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('修改失败:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.popover({msg: '修改成功',type:'success',timeout: 1000});
					
				}
			
				$("#ExcludeArcItemGrid").datagrid('reload');
			});
		}
	}
}

function LoadExcludeArcItemGrid(rowData)
{
	if(rowData!=undefined){
		$("#ARCIMRowID").val(rowData.TARCIMDR);	
	}
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

	$("#ExcludeArcItemGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:$("#ARCIMRowID").val(),
			LocID:LocID,
			tableName:extableName
		
	});
	
}
//初始化排斥项目Grid
function InitExcludeArcItemGrid()
{	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID); 
				
	$('#ExcludeArcItemGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
		{
				field: 'TID',
				title: 'ID',
				hidden: true
			}, {
				field: 'TArcItemDR',
				title: 'ArcItemDR',  
				hidden: true
			},{
				field: 'TExArcItemDR',
				title: 'ExArcItemDR',
				hidden: true
			}, {
				field: 'TExArcItemDesc',
				title: '排斥项目',
				width: 230,
			    formatter:function(value,row){
                    return row.TExArcItemDesc;
                },
				 editor:{
                    type:'combobox',
                    options:{
	                    required: true,
                        valueField:'TARCIMDR',
                        textField:'TARCIMDesc',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCPE.CT.StationOrder&QueryName=FindLocAllOrder&ResultSetType=array",
                        onBeforeLoad:function(param){   
			                param.ARCIMDesc = param.q;
							param.Type="B";
							param.LocID=LocID;
							param.hospId = hospId;
							param.tableName=tableName
                            
                           }
                        
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
			}, {
				field: 'TUpdateDate',
				width: '120',
				title: '更新日期'
			}, {
				field: 'TUpdateTime',
				width: '120',
				title: '更新时间'
			}, {
				field: 'TUpdateUser',
				width: '120',
				title: '更新人'
			}
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:"",
			LocID:LocID,
			tableName:extableName

		},
		onSelect: function (rowIndex, rowData) {
			if(rowData!=undefined){
				$("#ID").val(rowData.TID);
				if(rowData.TEmpower=="Y"){		
					$("#BRelateLoc").linkbutton('enable');
				}else{
					$("#BRelateLoc").linkbutton('disable');
				}
			}
				
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}


/**********************排斥项目 end************************************/

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
		displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据" 
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

		   $('#ExcludeArcItemGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadExcludeArcItemGrid(rowData);
		 
		},
		onLoadSuccess: function (data) {
			
		}
	})
}


//查询(项目)
function BAFind_click(){

	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
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
			LocID:session['LOGON.CTLOCID'],
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			BAFind_click();
			$('#ExcludeArcItemGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});

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

/**********************站点 end************************************/
