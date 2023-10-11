
//名称	DHCPEExcludeArcItem.hisui.js
//功能	排斥项目维护
//创建	2021.03.18
//创建人  xy

$(function(){
	
	//初始化下拉列表
  	InitCombobox();
	
	//初始化站点Grid		
	InitStationDataGrid();
	
	//初始化项目Grid		
	InitOrderTabDataGrid();
	
	//初始化排斥项目Grid				
	InitExcludeArcItemGrid();
	
	//查询
	$("#BFind").click(function(e){
    	BFind_click();
    });
	
	$("#ARCIMDesc").keydown(function(e) {
			
		if(e.keyCode==13){
				BFind_click();
				}
		});

	
	
	//新增
	$("#BAdd").click(function(e){
    	BSave_click("0");
    });
	
	
	//修改
	$("#BUpdate").click(function(e){
    	BSave_click("1");
    });
    
	//删除
	$("#BDelete").click(function(e){
    	BDelete_click();
    });
    
    
    //清屏
	$("#BClear").click(function(e){
    	BClear_click();
    });

	info();
	
})


function info()
{
	var ID=$("#ID").val()
	if(ID==""){
		$("#BAdd").linkbutton('enable');
		$("#BUpdate").linkbutton('disable');
		$("#BDelete").linkbutton('disable');
	}else{
		$("#BAdd").linkbutton('disable');
		$("#BUpdate").linkbutton('enable');
		$("#BDelete").linkbutton('enable');
	}
	
}


/**********************排拆项目 start************************************/

//删除
function BDelete_click()
{
	var RowId=$("#ID").val();
	if (RowId=="")
	{
		$.messager.alert("提示","请先选择待删除的记录","info");	
		return false;
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.ExcludeArcItem", MethodName:"DeleteExcludeArcItem",ID:RowId},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					BClear_click()
				}
			});	
		}
	});
	
		
}

//保存
function BSave_click(Type){
	var ARCIMRowID=$("#ARCIMRowID").val();
	if(ARCIMRowID==""){
		$.messager.alert("提示","请选择待维护的项目","info");
		return false;
		
	}
	var ExcludeARCIMID=$("#ExcludeARCIMDesc").combogrid('getValue');
	if (($("#ExcludeARCIMDesc").combogrid('getValue')==undefined)||($("#ExcludeARCIMDesc").combogrid('getText')=="")){var ExcludeARCIMID="";}
	if(ExcludeARCIMID==""){
		$.messager.alert("提示","请选择待排斥的项目","info");
		return false;
		
	}

	if(ARCIMRowID==ExcludeARCIMID){
		$.messager.alert("提示","排斥的项目和维护项目不能相同","info");
		return false;
	}

	var flag=tkMakeServerCall("web.DHCPE.ExcludeArcItem","IsExcludeArcItem",ARCIMRowID,ExcludeARCIMID);
	if(flag=="1"){
		$.messager.alert("提示","已存在该排斥项目","info");
		return false;
		
	}
	
	var ID=$("#ID").val();
	var rtn=tkMakeServerCall("web.DHCPE.ExcludeArcItem","SaveExcludeArcItem",ID,ARCIMRowID,ExcludeARCIMID);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		
		if(Type=="0"){$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});}
		if(Type=="1"){$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});}
		BClear_click();
	}else{
		$.messager.alert("提示",Arr[1],"error");	
	} 	
	
}

//清屏
function BClear_click()
{
	$("#ID").val("");
	$("#ExcludeARCIMDesc").combogrid('setValue',"");
	 InitCombobox();
	$("#ExcludeArcItemGrid").datagrid('load',{
			ClassName:"web.DHCPE.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:$("#ARCIMRowID").val()
	});	
	
	info();
}	

function InitExcludeArcItemGrid()
{
	$HUI.datagrid("#ExcludeArcItemGrid",{
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
		queryParams:{
			ClassName:"web.DHCPE.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
		},
		columns:[[
		    {field:'id',title:'ID',hidden: true},
			{field:'ExArcItemDesc',width:270,title:'排斥项目'}		
		]],
		onSelect: function (rowIndex, rowData) {
			$("#ID").val(rowData.id)
			$("#BAdd").linkbutton('disable');
			$("#BUpdate").linkbutton('enable');
			$("#BDelete").linkbutton('enable');

			//$("#ExcludeARCIMDesc").combogrid('disable');			
		}	
			
	})

}
function LoadExcludeArcItemGrid(rowData)
{
	
	$("#ARCIMRowID").val(rowData.ODR_ARCIM_DR);
	
	$("#ExcludeArcItemGrid").datagrid('load', {
			ClassName:"web.DHCPE.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:$("#ARCIMRowID").val()
		
	});
	
}
/**********************排斥项目 end************************************/


/**********************项目界面 start************************************/
function LoadOrderTabTablist(rowData)
{
	
	$("#ParRef").val(rowData.ST_RowId);
	
	$("#OrderTab").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			hospId:session['LOGON.HOSPID']
		
	});

   $("#ARCIMRowID").val("");
   BClear_click();

	
	
}
function InitOrderTabDataGrid()
{
	
	$HUI.datagrid("#OrderTab",{
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
		toolbar: [],//配置项toolbar为空时,会在标题与列头产生间距"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			hospId:session['LOGON.HOSPID']
		},
		columns:[[

		    {field:'ODR_ARCIM_DR:',title:'ID',hidden: true},
		    {field:'ODR_ARCIM_DR_Name',width:'200',title:'项目名称'},
			{field:'ODR_ARCIM_Code',width:'70',title:'项目编码'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#ExcludeArcItemGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadExcludeArcItemGrid(rowData);
					
		}
		
			
	})
}

 function BFind_click()
{
	
	$("#OrderTab").datagrid('load',{
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			Desc:$("#ARCIMDesc").val(),
			hospId:session['LOGON.HOSPID']
		}); 

}  
/**********************项目界面 end************************************/


/**********************站点界面 start************************************/
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
		toolbar: [],//配置项toolbar为空时,会在标题与列头产生间距"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"StationList",
		},
		columns:[[

		    {field:'ST_RowId',title:'ID',hidden: true},
		    {field:'ST_Code',width:70,title:'站点编码'},
			{field:'ST_Desc',width:170,title:'站点名称'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#OrderTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadOrderTabTablist(rowData);
		
					
		}
		
			
	})

}

/**********************站点界面 end************************************/

function InitCombobox(){
	
		
		//医嘱名称
	var ARCIMDObj = $HUI.combogrid("#ExcludeARCIMDesc",{
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
			
		},
	});
	}