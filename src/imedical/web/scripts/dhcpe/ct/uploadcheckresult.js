/*
 * FileName: dhcpe/ct/uploadcheckresult.js
 * Author: ln
 * Date: 2022-06-15
 * Description: 设备维护配置
 */
 
var tableName = "DHC_PE_UpLoadResult";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

 $(function(){
	
	//获取科室下拉列表
	GetLocComp(SessionStr)
	       	
	InitCombobox();
	
	//初始化 设备维护Grid
	InitUpResultGrid();
	
	//初始化 设备维护详情Grid
	InitUpResultDetailGrid();
	
	//科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
	        var LocID=session['LOGON.CTLOCID']
			var LocListID=$("#LocList").combobox('getValue');
			if(LocListID!=""){var LocID=LocListID; }
			BClear_click();
			
			$("#UpResultGrid").datagrid('load',{
				ClassName:"web.DHCPE.CT.UpLoadCheckResult",
				QueryName:"FindUpLoadResult",
				Code:$("#Code").val(),
				Desc:$("#Desc").val(),
				NoActive:$("#URNoActive").checkbox('getValue') ? "Y" : "N",
				LocID:LocID
			})
		   
		}
		
	});
	
	
    
	//查询
     $('#BFind').click(function(){
    	BFind_click();
    });
    
	//清屏
     $('#BClear').click(function(){
    	BClear_click();
    });
    
    //新增
     $('#BAdd').click(function(){
    	BAdd_click();
    });
    
    //修改
     $('#BUpdate').click(function(){
    	BUpdate_click();
    });
    
    
	//清屏(设备详情维护)
     $('#BLClear').click(function(){
    	BLClear_click();
    });
    
    //新增(设备详情维护)
     $('#BLAdd').click(function(){
    	BLAdd_click();
    });
    
    //修改(设备详情维护)
     $('#BLUpdate').click(function(){
    	BLUpdate_click();
    });
    
    //保存(设备详情维护)
     $('#BLSave').click(function(){
    	BLSave_click();
    });
   
    //查询(设备详情维护)
     $('#BLFind').click(function(){
    	BLFind_click();
    });
 
})



/*******************************设备维护 start*************************************/
//查询
function BFind_click(){
	$("#UpResultGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.UpLoadCheckResult",
		QueryName:"FindUpLoadResult",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		NoActive:$("#URNoActive").checkbox('getValue') ? "Y" : "N",
		LocID:$("#LocList").combobox('getValue')
			
	});	
}

//清屏
function BClear_click(){
	$("#ID,#Code,#Desc").val("");
	$("#URNoActive").checkbox('setValue',true);
	BFind_click();
	BLFind_click();

}

//新增
function BAdd_click(){
	
	BSave_click("0");	
}

//修改
function BUpdate_click()
{
	BSave_click("1");
}

function BSave_click(Type){
	
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	if(Type=="0"){
		if($("#ID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
		var ID="";
	}
	var LocID=$("#LocList").combobox('getValue')
	if (""==LocID) {
		$("#LocList").focus();
		$.messager.alert("提示","科室不能为空","info");
		return false;
	}
	
	var Code=$("#Code").val();
	if (""==Code) {
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	   	});
		$.messager.alert("提示","代码不能为空","info");
		return false;
	}
	
	var Desc=$("#Desc").val();
	if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   	});
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	
	var iURNoActive="N";
	var URNoActive=$("#URNoActive").checkbox('getValue');
	if(URNoActive) iURNoActive="Y"
	
	var UserID=session['LOGON.USERID'];
	
	var InfoStr=LocID+"^"+Code+"^"+Desc+"^"+iURNoActive+"^"+UserID;
	
	//alert("InfoStr:"+InfoStr)
	
	var ret=tkMakeServerCall("web.DHCPE.CT.UpLoadCheckResult","UpdateUpLoadResult",ID,InfoStr);
	var Arr=ret.split("^");
	if (Arr[0]>0){
		if(Type=="1"){$.messager.popover({msg: '修改成功',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '新增成功',type:'success',timeout: 1000});}
		BClear_click();		
	}else{
		$.messager.alert("提示",Arr[1],"error");	
	} 	
	
}

function InitUpResultGrid()
{
	$HUI.datagrid("#UpResultGrid",{
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
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.CT.UpLoadCheckResult",
			QueryName:"FindUpLoadResult",
			NoActive:$("#URNoActive").checkbox('getValue') ? "Y" : "N"
			
		},
		frozenColumns:[[
			{field:'TCode',title:'代码',width: 60},
			{field:'TDesc',title:'描述',width: 150},
			
		]],
		columns:[[
	
		    {field:'id',title:'id',hidden: true},
			{field:'TNoActive',title:'激活',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
       		},
			{field:'TUpdateDate',title:'更新日期',width: 120},
			{field:'TUpdateTime',title:'更新时间',width: 120},
			{field:'TUserName',title:'更新人',width: 120}
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
			$("#ID").val(rowData.id);
			$("#Desc").val(rowData.TDesc);
			$("#Code").val(rowData.TCode);
			$('#UpResultDetailGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			BLClear_click();
		
		}
	});
}

/*******************************设备维护 end*************************************/


/*******************************设备维护详情 start*************************************/

 //查询(设备详情维护)
function BLFind_click(){
	
	$("#UpResultDetailGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.UpLoadCheckResult",
		QueryName:"FindLocUpLoadResult",
		LURID:$("#ID").val(),
		ARCIMDR:$("#ARCIMDesc").combogrid("getValue")
	})		
}


//清屏
function BLClear_click(){
	
	$("#LURID,#PENoSepB,#PENoSepA,#ImgPath,#JCSJSepB,#JCSJSepA,#ZDYJSepB,#ZDYJSepA").val("");
	$("#ARCIMDesc").combogrid('setValue',"");
	BLFind_click();
	
}
//新增
function BLAdd_click()
 {
	lastIndex = $('#UpResultDetailGrid').datagrid('getRows').length - 1;
	$('#UpResultDetailGrid').datagrid('selectRow', lastIndex);
	var selected = $('#UpResultDetailGrid').datagrid('getSelected');
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
	$('#UpResultDetailGrid').datagrid('appendRow', {
		TID: '',
		TCategory: '',
		TSort: '',
		TPlace: '',
		TDocSignName: '',
		TPatSignName: '',
		TNoActive: ''
		
			});
	lastIndex = $('#UpResultDetailGrid').datagrid('getRows').length - 1;
	$('#UpResultDetailGrid').datagrid('selectRow', lastIndex);
	$('#UpResultDetailGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //修改
 function BLUpdate_click()
 {
	var selected = $('#UpResultDetailGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#UpResultDetailGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#UpResultDetailGrid').datagrid('beginEdit', thisIndex);
		$('#UpResultDetailGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#UpResultDetailGrid').datagrid('getSelected');
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TARCIMDesc'  
			});
		
		$(thisEd.target).combobox('select', selected.TARCIM); 

		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TImgPath'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPENoSepB'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPENoSepA'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPENoSepB'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJCSJSepA'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJCSJSepA'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TZDYJSepB'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TZDYJSepA'  
			});
			
	}
 }

//TID,TARCIM,TARCIMDesc,TImgPath,TPENoSepB,TPENoSepA,TJCSJSepB,TJCSJSepA,TZDYJSepB,TZDYJSepA,TTextInfo,TUpdateDate,TUpdateTime,TUserName
//保存
function BLSave_click()
{
	var UserID=session['LOGON.USERID'];
	var URDR=$("#ID").val();
	if(URDR==""){
		$.messager.alert("提示","请选择设备","info");
		return false;
	}
	
	$('#UpResultDetailGrid').datagrid('acceptChanges');
	var selected = $('#UpResultDetailGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TID == "") {
			if ((selected.TARCIMDesc == "undefined") || (selected.TImgPath == "undefined")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				LoadUpResultDetailGrid();
				return;
			}

			var iARCIMID=selected.TARCIMDesc;	
			if((iARCIMID != "") && (iARCIMID.split("||").length < 2)) {
				$.messager.alert("提示","请选择医嘱项!","info");
				return false;
			}
	
			if (iARCIMID != "") {
				var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",iARCIMID);
				if (ret == "0") {
					$.messager.alert("提示","请选择医嘱项!","info");
					return false;
				}
			}

			var InfoStr=URDR+"^"+selected.TARCIMDesc+"^"+selected.TImgPath+"^"+selected.TPENoSepB+"^"+selected.TPENoSepA+"^"+selected.TJCSJSepB+"^"+selected.TJCSJSepA+"^"+selected.TZDYJSepB+"^"+selected.TZDYJSepA+"^"+selected.TTextInfo+"^"+UserID
			$.m({
				
				ClassName: "web.DHCPE.CT.UpLoadCheckResult",
				MethodName: "UpdateLocUpLoadResult",
				ID:selected.TID,
				InfoStr:InfoStr
						
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', '保存失败:'+ rtnArr[1], 'error');
					
				}else{
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});	
				}
			
				
				LoadUpResultDetailGrid();
			});
		} else {
			$('#UpResultDetailGrid').datagrid('selectRow', EditIndex);
			var selected = $('#UpResultDetailGrid').datagrid('getSelected');
			if ((selected.TARCIMDesc == "undefined") || (selected.TImgPath == "undefined")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				LoadUpResultDetailGrid();
				return;
			}

			var iARCIMID=selected.TARCIMDesc;	
			if((iARCIMID != "") && (iARCIMID.split("||").length < 2)) {
				$.messager.alert("提示","请选择医嘱项!","info");
				return false;
			}
	
			if (iARCIMID != "") {
				var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",iARCIMID);
				if (ret == "0") {
					$.messager.alert("提示","请选择医嘱项!","info");
					return false;
				}
			}

		   //var InfoStr=URDR+"^"+selected.TARCIMDesc+"^"+selected.TImgPath+"^"+selected.TPENoSepB+"^"+selected.TPENoSepA+"^"+selected.TJCSJSepB+"^"+selected.TJCSJSepA+"^"+selected.TZDYJSepB+"^"+selected.TZDYJSepA+"^"+selected.TTextInfo+"^"+UserID
			var InfoStr=URDR+"^"+iARCIMID+"^"+selected.TImgPath+"^"+selected.TPENoSepB+"^"+selected.TPENoSepA+"^"+selected.TJCSJSepB+"^"+selected.TJCSJSepA+"^"+selected.TZDYJSepB+"^"+selected.TZDYJSepA+"^"+selected.TTextInfo+"^"+UserID
		
			$.m({
				
				ClassName: "web.DHCPE.CT.UpLoadCheckResult",
				MethodName: "UpdateLocUpLoadResult",
				ID:selected.TID,
				InfoStr:InfoStr
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', '修改失败:'+ rtnArr[1], 'error');
					
				}else{	
					$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});	
				}
			
				LoadUpResultDetailGrid();
			});
		}
	}
}
function LoadUpResultDetailGrid()
{
	 $("#UpResultDetailGrid").datagrid('reload');
}



function InitUpResultDetailGrid()
{
	$HUI.datagrid("#UpResultDetailGrid",{
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
		columns: LocUpLoadResultColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.UpLoadCheckResult",
			QueryName:"FindLocUpLoadResult",
			LURID:$("#ID").val()
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}

//保存  
var LocUpLoadResultColumns = [[
	{
		field:'TID',
		title:'ID',
		hidden:true
	},{
		field:'TARCIM',
		title:'ARCIM',
		hidden:true
	},{
		field:'TARCIMDesc',
		width: '230',
		title:'医嘱项',
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
          		onShowPanel: function () { // 只有在下拉层显示时,才去关联url拉取数据,提高首屏速度
					var url = $(this).combobox('options').url;
					if (!url){
						//$(this).combobox('options').mode = 'remote';
						var url = $URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList&ResultSetType=array";
						$(this).combobox('reload',url);		
						}
					},

               // url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList&ResultSetType=array",
                onBeforeLoad:function(param){   
			       	param.Desc = param.q;
					param.Type="B";
					param.LocID=$('#LocList').combobox('getValue');
					param.hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$('#LocList').combobox('getValue'));         
                  }
                        
               }
         }
	},{
		field:'TImgPath',
		width: '200',
		title:'图片文件',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TPENoSepB',
		width: '150',
		title:'获取体检号分隔符前',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TPENoSepA',
		width: '150',
		title:'获取体检号分隔符后',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TJCSJSepB',
		width: '150',
		title:'获取检查所见分隔符前',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
		}
	},{
		field:'TJCSJSepA',
		width: '150',
		title:'获取检查所见分隔符后',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
		}
	},{
		field:'TZDYJSepB',
		width: '150',
		title:'获取诊断意见分隔符前',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
		}
	},{
		field:'TZDYJSepA',
		width: '150',
		title:'获取诊断意见分隔符后',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
		}
	},{
		field: 'TTextInfo',
		width: '90',
		title: '读取文本',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
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

/*******************************设备维护详情 end*************************************/
function InitCombobox()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID;}
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

    //医嘱项
    var InvDefaultFeeObj = $HUI.combogrid("#ARCIMDesc",{
        panelWidth:470,
        url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastListNew",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'STORD_ARCIM_DR',
        textField:'STORD_ARCIM_Desc',
        onBeforeLoad:function(param){
            param.Desc = param.q;
            param.Type="B";
            param.LocID=LocID;
            param.hospId = hospId;

        },
        columns:[[
            {field:'STORD_ARCIM_DR',hidden:true},
            {field:'STORD_ARCIM_Code',title:'医嘱编码',width:100},
            {field:'STORD_ARCIM_Desc',title:'医嘱名称',width:240}
            
            
            
        ]]
    });
	
}

