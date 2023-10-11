
/*
 * FileName: dhcpe/ct/orderdetail.js
 * Author: xy
 * Date: 2021-08-13
 * Description: 细项维护
 */
var lastIndex = "";
var EditIndex = -1;
var odstableName = "DHC_PE_OrderDetailSet"; //细项扩展表
var tableName = "DHC_PE_OrderDetail"; //细项表
var Public_gridsearch1 = [];
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];

$(function(){	
	
	//获取科室下拉列表
	GetLocComp(SessionStr)
	
	//科室下拉列表change
	$("#LocList").combobox({
 	 	onSelect:function(){
	 	 	
	  		BFind_click();
	  		
	  		var LocID=session['LOGON.CTLOCID']
			var LocListID=$("#LocList").combobox('getValue');
			if(LocListID!=""){var LocID=LocListID; }
		    var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		     /********************项目重新加载****************************/
		   /* $("#ItemDesc").combogrid('setValue',"");
	  		$HUI.combogrid("#ItemDesc",{
				onBeforeLoad:function(param){
					param.ARCIMDesc= param.q;
					param.Type="B";
					param.LocID=LocID;
					param.hospId =hospId;
					param.tableName="DHC_PE_StationOrder" 

				}
		    });
		    
	       $('#ItemDesc').combogrid('grid').datagrid('reload'); 
	       /********************项目重新加载****************************/
	  			 
  		}
	})
	
	InitCombobox();
	
	//初始化 站点Grid 
	InitStationGrid();
	 
	 //查询（站点）
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
      
	$("#Desc").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});

     
	//初始化 细项Grid 
	InitOrderDetailGrid();
	
	 //查询（细项）
	$("#BODFind").click(function() {	
		BODFind_click();		
     });
     
      
	$("#OrdDetailDesc").keydown(function(e) {	
		if(e.keyCode==13){
			BODFind_click();
		}
	});

     //新增（细项）
	$("#BAdd").click(function() {	
		BAdd_click();		
     });
        
    //修改（细项）
	$("#BUpdate").click(function() {	
		BUpdate_click();		
     });
         
      //保存（细项）
     $('#BSave').click(function(){
    	BSave_click();
    });
    
     //数据关联科室（细项）
	$("#BRelateLoc").click(function() {	
		BRelateLoc_click();		
     });
        
	//初始化 细项详情Grid 
	InitOrderDetailSetGrid();
	     
     //新增（细项详情）
	$("#BODSAdd").click(function() {	
		BODSAdd_click();		
     });
        
    //修改（细项详情）
	$("#BODSUpdate").click(function() {	
		BODSUpdate_click();		
     });
             
	// 标准化对照
    $("#RelateStandard").click(function() {  
        RelateStandard_click();     
    });
	
	// 撤销对照
    $("#RelateCancel").click(function() {
        RelateCancel_click();
    });
	
	// 标准化对照 搜索框
	$('#gridBTExamItemDetail_search').searchbox({
		searcher:function(value,name){
			//Public_gridsearch1 = searchText($("#gridBTExamItemDetail"),value,Public_gridsearch1);
			
			$('#gridBTExamItemDetail').datagrid('load',{
	                ClassName:"web.DHCPE.KBA.MappingService",
					QueryName:"QryExamItemDtl",
					aLocID:$("#LocList").combobox('getValue'),
					aAlias:value
	                });
		}
	});
})

//撤销对照操作
function RelateCancel_click(){
    var DateID=$("#OrdDetailID").val()
    if (DateID==""){
        $.messager.alert("提示","请选择需要对照的记录","info"); 
        return false;
    }  
    $.messager.confirm("确认", "确定要撤销对照记录吗？", function(r){
        if (r){
                $.m({
                    ClassName: "web.DHCPE.CT.StatOrderDetail",
                    MethodName: "UpdateOrderDetailEx",
                    ID:DateID,
                    Code: "",
                    Desc: ""
                }, 
                function (rtn) {
                    var rtnArr=rtn.split("^");
                    if(rtnArr[0]=="-1"){    
                        $.messager.alert('提示', $g('撤销对照失败:')+ rtnArr[1], 'error');    
                    }else{  
                        $.messager.alert('提示', '撤销对照成功', 'success');      
                    }
                    
                    $("#OrderDetailGrid").datagrid('reload');
                });
        }
    })
}

/*******************************细项详情 start**********************************/
//新增（细项详情）
function BODSAdd_click()
{
	
  var iStationID=$("#StationID").val();
	if(iStationID=="")
	{
		$.messager.alert('提示','请选择站点',"info");
		return;		
	}
	var iOrdDetailID=$("#OrdDetailID").val();
	if(iOrdDetailID=="")
	{
		$.messager.alert('提示','请选择细项',"info");
		return;		
	}
	
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
					SaveForm("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		
		$('#form-save').form("clear");
		
		$("#ODStaionDesc").val($("#StaionDesc").val());
		$("#ODSDetailDesc").val($("#DetailDesc").val());
	   	
		//默认选中
		$HUI.checkbox("#Summary").setValue(true);
		$HUI.checkbox("#NoPrint").setValue(false);	
	    

}

SaveForm=function(id)
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

	var iStationID=$("#StationID").val();
	if(iStationID=="")
	{
		$.messager.alert('提示','请选择站点',"info");
		return;		
	}
	var iOrdDetailID=$("#OrdDetailID").val();
	if(iOrdDetailID=="")
	{
		$.messager.alert('提示','请选择细项',"info");
		return;		
	}
	
	var iSummary="N";
	var Summary=$("#Summary").checkbox('getValue');
	if(Summary) {iSummary="Y";}
	
	var iNoPrint="N";
	var NoPrint=$("#NoPrint").checkbox('getValue');
	if(NoPrint) {iNoPrint="Y";}
	
	var iHistoryFlag="N";
	var HistoryFlag=$("#HistoryFlag").checkbox('getValue');
	if(HistoryFlag) {iHistoryFlag="Y";}

	var iMarried=$('#Married_DR_Name').combobox('getValue');
	if (($('#Married_DR_Name').combobox('getValue')==undefined)||($('#Married_DR_Name').combobox('getValue')=="")){var iMarried="";}
	
	var iZhToEng=$.trim($("#ZhToEng").val());
	
	var iSpecialNature=$.trim($("#SpecialNature").val());
	
	var Instring = iStationID
				+"^"+iOrdDetailID
				+"^"+iSummary
				+"^"+iNoPrint  
				+"^"+iZhToEng
				+"^"+iSpecialNature
				+"^"+iMarried
				+"^"+iHistoryFlag
				;
	 
	 
	var rtn=tkMakeServerCall("web.DHCPE.CT.StatOrderDetail","SaveOrderDetailSet",id,Instring,odstableName,session['LOGON.USERID'],LocID);
	var rtnArr=rtn.split("^");
	if(rtnArr[0]=="-1"){	
		$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');				
	}else{	
		$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		
		$("#OrderDetailSetGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.StatOrderDetail",
			QueryName:"FindOrderDetailSet",
			OrdDetailID:$("#OrdDetailID").val(),	
			LocID:LocID,
			tableName:odstableName
			
		}); 
			   
	   $('#myWin').dialog('close'); 				
	}

	
		
}


//修改（细项详情）
function BODSUpdate_click()
{

	var ID=$("#OrdDetailSetID").val();
	if(ID==""){
		$.messager.alert('提示',"请选择待修改的记录","info");
		return
	}
	
	$("#ODStaionDesc").val($("#StaionDesc").val());
	$("#ODSDetailDesc").val($("#DetailDesc").val());
	
	if(ID!="")
	{	
	      var OrdDetailSetStr=tkMakeServerCall("web.DHCPE.CT.StatOrderDetail","GetOrdDetailSetByID",ID);
	      
		   var OrdDetailSet=OrdDetailSetStr.split("^");
		  //ODSSummary_"^"_ODSZhToEn_"^"_ODSHistoryFlag_"^"_ODSRange_"^"_ODSMarriedDR_"^"_ODSNoPrint
		   if(OrdDetailSet[0]=="Y"){
			    $("#Summary").checkbox('setValue',true);
		   }else{
			   $("#Summary").checkbox('setValue',false);
		   } 
		 
		    $('#ZhToEng').val(OrdDetailSet[1]);
		    $('#SpecialNature').val(OrdDetailSet[3]);
		    $('#Married_DR_Name').combobox('setValue',OrdDetailSet[4]);
		    if(OrdDetailSet[5]=="Y"){
			    $("#NoPrint").checkbox('setValue',true);
		   }else{
			   $("#NoPrint").checkbox('setValue',false);
		   }
		    if(OrdDetailSet[2]=="Y"){
			    $("#HistoryFlag").checkbox('setValue',true);
		   }else{
			   $("#HistoryFlag").checkbox('setValue',false);
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
					}
				}]
			});	
								
	}	
}	


//初始化 细项详情Grid 
function LoadOrderDetailSetGrid(OrdDetailID){
	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; };
	
	$("#OrderDetailSetGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StatOrderDetail",
		QueryName:"FindOrderDetailSet",
		OrdDetailID:OrdDetailID,	
		LocID:LocID,
		tableName:odstableName
	});	
}

function InitOrderDetailSetGrid()
{
	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; };
	
	$HUI.datagrid("#OrderDetailSetGrid",{
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
			ClassName:"web.DHCPE.CT.StatOrderDetail",
			QueryName:"FindOrderDetailSet",
			OrdDetailID:$("#OrdDetailID").val(),	
			LocID:LocID,
			tableName:odstableName
			
		},
		frozenColumns:[[
			{field:'TODDesc',width:150,title:'细项描述'},
		]],
		columns:[[
		
		    {field:'TODSID',title:'ODSID',hidden: true},
			{field:'TODSSequence',title:'ODSSequence',hidden: true},
			{field:'TODSLabtrakCode',title:'ODSLabtrakCode',hidden: true},
			{field:'TODSMarriedDesc',width:90,title:'婚姻'},
			{field:'TODSSummary',width:80,title:'进入小结',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TODSAdvice',width:100,hidden: true},
			{field:'TODSNoPrint',width:70,title:'不打印',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TODSRange',width:150,title:'特殊范围'},
			{field:'TODSZhToEn',width:120,title:'英文对照'},
			{field:'TODSExplain',hidden: true},
			{field:'TODSHistoryFlag',width:100,title:'报告中对比',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
	
			},
			{field:'TODSUpdateDate',width:120,title:'更新日期'},
			{field:'TODSUpdateTime',width:120,title:'更新时间'},
			{field:'TODSUpdateUser',width:120,title:'更新人'}		
			     
		]],
		onSelect: function(rowIndex, rowData) {
			$("#OrdDetailSetID").val(rowData.TODSID)	
					
		}		
	})
	
}


/*******************************细项详情 end**********************************/


/*******************************细项 start**********************************/
//数据关联科室
function BRelateLoc_click()
{
	
	var DateID=$("#OrdDetailID").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}
   
   var LocID=$("#LocList").combobox('getValue');
   //alert("LocID:"+LocID)
   OpenLocWin(tableName,DateID,SessionStr,LocID,function(){})
   
   $("#OrderDetailGrid").datagrid('reload');
   
}

//查询  细项
function BODFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');

	$("#OrderDetailGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StatOrderDetail",
		QueryName:"FindOrderDetailNew",
		StationID:$("#StationID").val(),
		Desc:$("#OrdDetailDesc").val(),
		LocID:LocID,
		tableName:tableName
	});	
}

//新增
function BAdd_click()
 {
	if($("#StationID").val()==""){
		$.messager.alert('提示', "请选择站点!", 'info');
		return;
		
	}
	
	$('#OrderDetailGrid').datagrid('getRows').length
	//lastIndex = $('#OrderDetailGrid').datagrid('getRows').length - 1;
	//$('#OrderDetailGrid').datagrid('selectRow', lastIndex);
	$("#OrderDetailGrid").datagrid('clearSelections');
	var selected = $('#OrderDetailGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TODID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#OrderDetailGrid').datagrid('appendRow', {
		TODID: '',
		TODCode: '',
		TODDesc: '',
		TODType: '',
		TODTypeDR: '',
		TODExpression: '',
		TODUnit: '',
		TODSex: '',
		TODSexDR: '',
		TODLabtrakCode: '',
		TODExplain:''
	});
	
	lastIndex = $('#OrderDetailGrid').datagrid('getRows').length - 1;
	$('#OrderDetailGrid').datagrid('selectRow',lastIndex);
	$('#OrderDetailGrid').datagrid('beginEdit',lastIndex);
	EditIndex = lastIndex;
 }
 
 //修改
 function BUpdate_click()
 {
	 if($("#StationID").val()==""){
		$.messager.alert('提示', "请选择站点!", 'info');
		return;
		
	}
	var selected = $('#OrderDetailGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#OrderDetailGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#OrderDetailGrid').datagrid('beginEdit', thisIndex);
		$('#OrderDetailGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#OrderDetailGrid').datagrid('getSelected');

		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODType'  
		});
		$(thisEd.target).combobox('select', selected.TODTypeDR);  
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODCode'  
		});
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODDesc'  
		});
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODExpression'  
		});
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODUnit'  
		});
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODSex'  
		});
		$(thisEd.target).combobox('select', selected.TODSexDR);  
			
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODLabtrakCode'  
		});
		
	}
 }

//保存
function BSave_click()
{ 
  if($("#StationID").val()==""){
		$.messager.alert('提示', "请选择站点!", 'info');
		return;
		
	}
	$('#OrderDetailGrid').datagrid('acceptChanges');
	
	var selected = $('#OrderDetailGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('提示', "没有需要保存的数据", 'info');
		return;
	}
	if (selected) {
		
		if (selected.TODID == "") {
			
			if ((selected.TODCode == "undefined")||(selected.TODCode == "")||(selected.TODDesc == "undefined")||(selected.TODDesc == "")||(selected.TODType == "undefined")||(selected.TODType == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				$("#OrderDetailGrid").datagrid('reload');
				return;
			}
			var InString=$("#StationID").val()+"^"+selected.TODCode+"^"+selected.TODDesc+"^"+selected.TODType+"^"+selected.TODExpression+"^"+selected.TODUnit+"^"+selected.TODExplain+"^"+selected.TODSex+"^"+selected.TODLabtrakCode
				
			$.m({
				ClassName: "web.DHCPE.CT.StatOrderDetail",
				MethodName: "SaveOrderDetail",
				ID:'', 
			    InString:InString,
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'),
				UserID:session['LOGON.USERID'],
				Empower:selected.TEmpower
			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				}

				$("#OrderDetailGrid").datagrid('reload');
			});
		} else {
			$('#OrderDetailGrid').datagrid('selectRow', EditIndex);
			var selected = $('#OrderDetailGrid').datagrid('getSelected');
			if ((selected.TODCode == "undefined")||(selected.TODCode == "")||(selected.TODDesc == "undefined")||(selected.TODDesc == "")||(selected.TODType == "undefined")||(selected.TODType == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				$("#OrderDetailGrid").datagrid('reload');
				return;
			}
			var InString=$("#StationID").val()+"^"+selected.TODCode+"^"+selected.TODDesc+"^"+selected.TODType+"^"+selected.TODExpression+"^"+selected.TODUnit+"^"+selected.TODExplain+"^"+selected.TODSex+"^"+selected.TODLabtrakCode
				
			$.m({
				ClassName: "web.DHCPE.CT.StatOrderDetail",
				MethodName: "SaveOrderDetail",
				ID:selected.TODID, 
			    InString:InString,
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'),
				UserID:session['LOGON.USERID'],
				Empower:selected.TEmpower
				
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('修改失败:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
					  EditIndex = -1;
					
				}
			   $("#OrderDetailGrid").datagrid('reload');
			});
		}
	}
}

//初始化 细项Grid 
function InitOrderDetailGrid(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$('#OrderDetailGrid').datagrid({
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
		columns:OrderDetailColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StatOrderDetail",
			QueryName:"FindOrderDetailNew",
			StationID:$("#StationID").val(),
			Desc:"",
			LocID:LocID,
			tableName:tableName
			
		},
		onSelect: function (rowIndex,rowData) {
			if(rowIndex!="-1"){
				$("#RelateStandard").linkbutton('enable');
				if(rowData.TEmpower=="Y"){		
					$("#BRelateLoc").linkbutton('enable');
				}else{
					$("#BRelateLoc").linkbutton('disable');
				}
				$("#OrdDetailID").val(rowData.TODID);
				$("#DetailDesc").val(rowData.TODDesc);
				
				LoadOrderDetailSetGrid(rowData.TODID);
			}
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;		
		}
	});
	
}
//类型  下拉列表值
var ODTypeData = [ 
	{id:'T',text:$g('说明型')},
    {id:'N',text:$g('数值型')},
    {id:'C',text:$g('计算型')},
    {id:'S',text:$g('选择型')},
    {id:'A',text:$g('多行文本')}
];


//性别  下拉列表值
var ODSexData = [
 	{id:'M',text:$g('男')},
    {id:'F',text:$g('女')},
    {id:'N',text:$g('不限')},
];
	

	
var OrderDetailColumns = [[
	{
		field:'TODID', 
		title:'TODID',
		hidden:true
	},{
		field:'TStationName',
		title:'站点',
		width: 100
	},{
		field:'TODCode',
		width: 80,
		title:'编码',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TODDesc',
		width: 120,
		title:'描述',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'ItemDtlDesc',
		title:'知识库细项描述',
		width: 120
	},{
		field:'TODType',
		title:'类型',
		width:80,
		//sortable:true,
		//resizable:true,
		editor: {
			type:'combobox',
			options: {	
				valueField: 'id',
				textField: 'text',
				data: ODTypeData,
				required: true
			}
		}
	},{
		field:'TODSex',
		title:'性别',
		width:70,
		//sortable:true,
		//resizable:true,
		editor: {
			type:'combobox',
			options: {	
				valueField: 'id',
				textField: 'text',
				data: ODSexData
				
			}
		}
   },{
		field:'TODExpression',  
		width: 120,
		title:'表达式',
		editor: 'text'
	},{
		field:'TODUnit',
		width: 60,
		title:'单位',
		editor: 'text'
		
	},{
		field:'TODLabtrakCode',
		width: 120,
		title:'检验项目编码',
		editor: 'text',
		
	},{
		field:'TODExplain',
		width: 100,
		title:'说明',
		editor: 'text',
		
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
		field:'TUpdateDate',
		title:'更新日期', 
		width: 120
	},{
		field:'TUpdateTime',
		title:'更新时间',
		width: 120
	},{
		field:'TUpdateUser',
		title:'更新人',
		width: 100
	}
			
]];



function LoadOrderDetailGrid(StationID){
	var LocID=$("#LocList").combobox('getValue')
	$("#OrderDetailGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StatOrderDetail",
		QueryName:"FindOrderDetailNew",
		StationID:StationID,
		LocID:LocID,
		tableName:tableName
	});	
}

/*******************************细项 end**********************************/




/*******************************站点 start**********************************/

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
			$("#StaionDesc").val(rowData.TStationDesc);
			LoadOrderDetailGrid(rowData.TStationID);
			$("#OrdDetailID").val('');
		
			
			//清空站点项目、项目详情的所有选中
			$("#OrderDetailGrid").datagrid('clearSelections');
			//$("#OrderDetailSetGrid").datagrid('clearSelections');
			 lastIndex = "";
		     EditIndex = -1;
		
		},
		onLoadSuccess: function (data) {
			 //lastIndex = "";
			 //EditIndex = -1;
			
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

/*******************************站点 end**********************************/
function InitCombobox()
{
	
	//婚姻状况 
	var MarriedObj = $HUI.combobox("#Married_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married',
		panelHeight:'95',
	});

}



function RelateStandard_click()
{
	var LocID=$("#LocList").combobox('getValue');
	
    var DateID=$("#OrdDetailID").val()
    if (DateID==""){
        $.messager.alert("提示","请选择需要对照的记录","info"); 
        return false;
    }  
    $("#StandardWin").show();
	$("#gridBTExamItemDetail_search").searchbox("setValue",'');
    var StandardWin = $HUI.dialog("#StandardWin", {
        width: 750,
        modal: true,
        height: 450,
        iconCls: '',
        title: '标准化对照',
        resizable: true,
        buttonAlign: 'center',
        buttons: [{
            iconCls: 'icon-w-save',
            text: '对照',
            id: 'save_btn',
            handler: function() {
                var selected = $('#gridBTExamItemDetail').datagrid('getSelected');
                if (selected==null){
                    $.messager.alert("提示", "请选择标准细项！", "info");
                    return false;
                }
                $.m({
					ClassName: "web.DHCPE.CT.StatOrderDetail",
					MethodName: "UpdateOrderDetailEx",
					ID:DateID,
					Code: selected.Code,
					Desc: selected.Desc
                },
				function (rtn) {
					var rtnArr=rtn.split("^");
					if(rtnArr[0]=="-1"){    
						$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');    
					}else{  
						$.messager.alert('提示', '保存成功', 'success');      
					}
					
					$("#OrderDetailGrid").datagrid('reload');
					$HUI.dialog("#StandardWin").close();
				});
            }
        }, {
            iconCls: 'icon-w-close',
            text: '关闭',
            handler: function() {
                $HUI.dialog("#StandardWin").close()

            }
        }],
        onOpen: function() {
			// 初始化DataGrid
			$('#gridBTExamItemDetail').datagrid({
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
				columns: [[
					{ field:'ID', title:'ID', hidden:true }
					,{ field:'Code', width: 100, title:'细项代码', sortable: true, resizable: true }
					,{ field:'Desc', width: 200, title:'细项名称', sortable: true, resizable: true }
					,{ field:'ItemCatDesc', width: 100, title:'项目分类', sortable: true, resizable: true }
					,{ field:'DataFormat', hidden:true, title:'数据格式', sortable: true, resizable: true }
					,{ field:'DataFormatDesc', width: 80, title:'数据格式', sortable: true, resizable: true }
					//,{ field:'Express', width: 200, title:'表达式', sortable: true, resizable: true }
					,{ field:'Unit', width: 100, title:'单位', sortable: true, resizable: true }
					,{ field:'Explain', width: 300, title:'说明', sortable: true, resizable: true }
				]],
				queryParams:{
					ClassName:"web.DHCPE.KBA.MappingService",
					QueryName:"QryExamItemDtl",
					aLocID:LocID,
					aAlias:""
				},
				onLoadSuccess: function (data) {
					//Public_gridsearch1 = [];
				}
			});
        }
    });
}
