
/*
 * FileName: dhcpe/ct/stationset.js
 * Author: xy
 * Date: 2021-08-09
 * Description: 站点详情维护
 */

var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_StationSet";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	//获取科室下拉列表
	GetLocComp(SessionStr)
	
	//初始化站点Grid 
	InitStationGrid();
	 
	//初始化科室站点详情Grid 
	InitStationLocGrid();
	
	 //科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
	       
	        BClear_click();	 
       }
		
	});
	
	
	//查询(站点)
	$("#BFind").click(function() {	
		BFind_click();		
     });
    
     $("#Desc").keydown(function(e) {
		if(e.keyCode==13){
			BFind_click();
		}
			
       });    
   
     
     //新增（科室站点详情维护）
	$("#BLAdd").click(function() {	
		BLAdd_click();		
     });
        
    //修改（科室站点详情维护）
	$("#BLUpdate").click(function() {	
		BLUpdate_click();		
     });
         
      //保存（科室站点详情维护）
     $('#BLSave').click(function(){
    	BLSave_click();
    });
          
	//导入（科室站点详情维护）
     $('#BLImport').click(function(){
    	BLImport_click();
    });  
        
})


/*******************************站点start*************************************/
//查询(站点)
function BFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');
		
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindEffStation",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		LocID:LocID
		
	});	
}

//清屏(站点)
function BClear_click()
{
	$("#Code,#Desc,#StationID").val("");
	
	BFind_click();
	
	$("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
	
	});	
}



function LoadStaionGrid()
{
	 $("#StaionGrid").datagrid('reload');
}


var StationColumns = [[
	{
		field:'TID',
		title:'TID',
		hidden:true
	},{  
		field:'TCode',
		width: '100',
		title:'代码',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	 },{  
		field:'TDesc',
		width: '170',
		title:'描述',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			 }
		}
	 }
			
]];

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
		columns: StationColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindEffStation",
			LocID:LocID
			
		},
		onSelect: function (rowIndex,rowData) {
			
			if(rowIndex!="-1"){
				$("#StationID").val(rowData.TID);
				LoadStationLocGrid(rowData.TID);
				iniForm();
			}

		},
		onLoadSuccess: function (data) {
	        
	        //默认选中第一行
			$("#StaionGrid").datagrid("selectRow",0);
			var selectrow = $('#StaionGrid').datagrid('getSelected');
			$("#StationID").val(selectrow.TID);
			LoadStationLocGrid($("#StationID").val());
			
		}
	});
	
}


/*******************************站点end*************************************/

/*******************************科室站点详情start*************************************/


function LoadStationLocGrid(StaionID) {
	
	$("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		StaionID:StaionID, 
		LocID:$("#LocList").combobox('getValue')
	});	
}


//新增
function BLAdd_click()
 {
	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	var selected = $('#StationLocGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TSTLID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#StationLocGrid').datagrid('appendRow', {
		TSTSID:'',
		TPlace:'',
		TSequence:'',
		TAutoAudit:'',
		TLayoutTypeDR:'',
		TLayoutType:'',
		TButtonTypeDR:'',
		TButtonType:'',
		TReportSequence:'',
		TAllResultShow:'',
		TActive:'',
		
	});
	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	$('#StationLocGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //修改
 function BLUpdate_click()
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
				field: 'TLayoutType'  
			});
	    $(thisEd.target).combobox('select',selected.TLayoutTypeDR); 	
		
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TButtonType'  
			});
	    $(thisEd.target).combobox('select',selected.TButtonTypeDR); 
	    	
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPlace'  
			});
		
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TSequence'  
			});
			
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TReportSequence'  
			});
						
		
	}
}
 

//保存
function BLSave_click()
{
	
	
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	var StationID=$("#StationID").val();
	
	$('#StationLocGrid').datagrid('acceptChanges');
	var selected = $('#StationLocGrid').datagrid('getSelected');
	
	
	if (selected) {
		
		if (selected.TSTSID == "") {
			if((selected.TSequence == "undefined")||(selected.TReportSequence == "undefined")||(selected.TLayoutType == "undefined")||(selected.TButtonType == "undefined")||(selected.TSequence == "")||(selected.TReportSequence == "")||(selected.TLayoutType == "")||(selected.TButtonType == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				 $("#StationLocGrid").datagrid('reload');
				return;
			}
			
			$.m({
				ClassName: "web.DHCPE.CT.Station", 
				MethodName: "UpdateStationSet",
				ID:"",
			    InfoStr:selected.TPlace+"^"+selected.TSequence+"^"+selected.TAutoAudit+"^"+selected.TLayoutType+"^"+selected.TButtonType+"^"+selected.TReportSequence+"^"+selected.TAllResultShow+"^"+selected.TActive+"^"+LocID+"^"+UserID+"^"+StationID+"^"+tableName
				
			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('提示', '保存成功', 'success');
					
				}
			
				 $("#StationLocGrid").datagrid('reload');
			});
		} else {
			
			$('#StationLocGrid').datagrid('selectRow', EditIndex);
			var selected = $('#StationLocGrid').datagrid('getSelected');
			if((selected.TSequence == "undefined")||(selected.TReportSequence == "undefined")||(selected.TLayoutType == "undefined")||(selected.TButtonType == "undefined")||(selected.TSequence == "")||(selected.TReportSequence == "")||(selected.TLayoutType == "")||(selected.TButtonType == "")) {	
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				 $("#StationLocGrid").datagrid('reload');
				return;
			}
			
			$.m({
				ClassName: "web.DHCPE.CT.Station",
				MethodName: "UpdateStationSet",
				ID:selected.TSTSID,
				InfoStr:selected.TPlace+"^"+selected.TSequence+"^"+selected.TAutoAudit+"^"+selected.TLayoutType+"^"+selected.TButtonType+"^"+selected.TReportSequence+"^"+selected.TAllResultShow+"^"+selected.TActive+"^"+LocID+"^"+UserID+"^"+StationID+"^"+tableName
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('修改失败:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('提示', '修改成功', 'success');
					
				}
			
				 $("#StationLocGrid").datagrid('reload');
			});
		}
  }
}


//短信类型  下拉列表值
var LayoutTypeData = [ 
	{id:'1',text:$g('简化')},
    {id:'2',text:$g('详细')},
    {id:'3',text:$g('普通化验')},
    {id:'4',text:$g('接口化验')},
    {id:'5',text:$g('普通检查')},
    {id:'6',text:$g('接口检查')},
    {id:'7',text:$g('其它')},
    {id:'8',text:$g('药品')}
 ];
	
var ButtonTypeData = [
	{id:'1',text:$g('标准')},
	{id:'2',text:$g('妇科')},
	{id:'3',text:$g('超声')}
];	

var StationLocColumns = [[
	{
		field:'TSTSID', 
		title:'TSTSID',
		hidden:true
	}, {
		field: 'TActive',
		width: '60',
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
		field:'TSequence',
		width: '80',
		title:'总检顺序',
		editor: 'text',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	 },{  
		field:'TReportSequence',
		width: '80',
		title:'报告顺序',
		editor: 'text',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			 }
		}
	 },{
		field: 'TAllResultShow',
		width: '120',
		title: '总检显示所有结果',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		   }					
	   }
	 },{
		field: 'TAutoAudit',
		width: '120',
		title: '科室自动提交',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		   }					
	   }
	 },{
		field:'TLayoutTypeDR',
		title:'TLayoutTypeDR',
		hidden:true
	},{
		field:'TLayoutType',
		title:'界面类型',
		width:90,
		panelHeight:"auto",
		sortable:true,
		resizable:true,
		editor: {
			type:'combobox',
			options: {
				valueField: 'id',
				textField: 'text',
				data: LayoutTypeData,
				required: true
			}
		 }
	},{
		field:'TButtonTypeDR',
		title:'TButtonTypeDR',
		hidden:true
	},{
		field:'TButtonType',
		title:'按钮类型',
		width:90,
		panelHeight:"auto",
		sortable:true,
		resizable:true,
		editor: {
			type:'combobox',
			options: {
				valueField: 'id',
				textField: 'text',
				data: ButtonTypeData,
				required: true
			}
		 }
	},{
		field:'TPlace',
		width: '130',
		title:'站点位置',
		editor: 'text',
		sortable: false,
		resizable: true,
		editor: {
			type: 'textarea',
			options: {
				height:'60px'
						
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
		field: 'TUpdateUserName',
		width: '120',
		title: '更新人'
	}	
			
]];


// 初始化科室站点详情维护DataGrid
function InitStationLocGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
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
		pageList : [20,100,200],  
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		frozenColumns:[[
			{
			field: 'TStationDesc',
			width: '100',
			title: '站点'
			}
		]],
		columns: StationLocColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStaionSet",
			StaionID:$("#StationID").val(), 
		    LocID:LocID
			
		},
		onSelect: function (rowIndex, rowData) {
			

		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}
 
function iniForm(){
	
	var StationID=$("#StationID").val();
	
	var globalLoc = $("#LocList").combobox("getValue");
	var LocID= globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	var StationType = tkMakeServerCall("web.DHCPE.CT.HISUICommon","GetStationTypeByID",StationID,LocID);
	
    if(StationType=="LIS"){
	    $("#BLImport").show();
    }else{
        $("#BLImport").hide();
    }
	
}

//导入
function BLImport_click(){
	var UserID=session['LOGON.USERID'];
	
	var globalLoc = $("#LocList").combobox("getValue");
	var LocID= globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	if(LocID==""){
		$.messager.alert("提示","科室不能为空！","info");
		return false;
	}	
	
	var StationID=$("#StationID").val();
	if(StationID==""){
		$.messager.alert("提示","站点不能为空！","info");
		return false;
	}
		
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
    
	var rtn=tkMakeServerCall("web.DHCPE.CT.Station","ImportLISOD",StationID,LocID,UserID,LocStr);
	var rtnone=rtn.split("^");
	if(rtnone[0]=="0"){
		$.messager.alert("提示","导入完成！","success");		
	}else{
		$.messager.alert("提示",rtnone[1],"info");
	}
	
}
/*******************************科室站点详情end*************************************/
