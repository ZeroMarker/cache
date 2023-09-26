
var url="dhceq.jquery.operationtype.csp";
var editFlag="undefined";
var SelectRowID="";
var Columns=getCurColumnsInfo('EM.G.IFB.IFBListForLoc','','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
		
function initDocument()
{
	initUserInfo();
    initMessage("BuyRequest"); //获取所有业务消息
    //initLookUp();
	defindTitleStyle(); 
    //initButton();
    //initButtonWidth();
	$HUI.datagrid("#tDHCEQIFBList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSIFBList",
	        QueryName:"IFBListDetail",	        
	        SourceType:getElementValue("SourceType"),
	        SourceID:getElementValue("SourceID")
			},
			fit:true,
			//border:'true',	//modified zy ZY0215 2020-04-01
			fitColumns : true,    //add by lmm 2020-06-04
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			toolbar:[{
				iconCls:'icon-add',
				text:'新增',
				id:'add',
				handler:function(){insertRow();}
			},
			{
				iconCls:'icon-save',
				text:'保存',
				id:'save',
				handler:function(){SaveData();}
			},
			{
				iconCls:'icon-cut',
				text:'删除',
				id:'delete',
				handler:function(){DeleteData();}
			}],
			columns:Columns,
			pageSize:20,  // 每页显示的记录条数
			pageList:[20],   // 可以设置每页记录条数的列表
	        singleSelect:true,
			loadMsg: '正在加载信息...',
			pagination:true,
		    onClickRow: function (rowIndex, rowData) {//双击选择行编辑
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQIFBList').datagrid('endEdit', editFlag);
	                editFlag="undefined";
	            }
	            else
	            {
		            $('#tDHCEQIFBList').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        },
			onSelect:function(index,row){ 
				if (SelectRowID!=row.IFBLRowID)
				{
					SelectRowID=row.IFBLRowID
				}
				else
				{
					SelectRowID=""
				}
			}
	});
	if (getElementValue("ReadOnly")==1||getElementValue("Status")==1||getElementValue("Status")==2)	//modified by csj 2020-03-03 需求号：1211902
	{
		$("#add").linkbutton("disable");
		$("#save").linkbutton("disable");
		$("#delete").linkbutton("disable");
	}
}

// 插入新行
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQIFBList").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
    var rows = $("#tDHCEQIFBList").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var IFBLModel = (typeof rows[lastIndex].IFBLModel == 'undefined') ? "" : rows[lastIndex].IFBLModel;
    var IFBLManuFactory = (typeof rows[lastIndex].IFBLManuFactory == 'undefined') ? "" : rows[lastIndex].IFBLManuFactory;
    if ((IFBLModel=="")&&(IFBLManuFactory==""))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.');
	}
	else
	{
		$("#tDHCEQIFBList").datagrid('insertRow', {index:newIndex,row:{}});
		editFlag=0;
	}
}
// 保存编辑行
function SaveData()
{
	if(editFlag>="0"){
		$('#tDHCEQIFBList').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQIFBList').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList=""
	for (var i = 0; i < rows.length; i++) 
	{
		rows[i].IFBLSourceType=getElementValue("SourceType")
		rows[i].IFBLSourceID=getElementValue("SourceID")
		var oneRow=rows[i]
		if ((oneRow.IFBLModel=="")||(typeof(oneRow.IFBLModel)=="undefined"))
		{
			//modified by ZY0227 20200508
			messageShow("","","","第"+(i+1)+"行'型号'不能为空!");//add by wl 2019-11-25 WL0014 
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData;
		}
	}
	if (dataList=="")
	{
		alertShow("明细不能为空!");
		//return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","SaveData",dataList,"","");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var SourceType=getElementValue("SourceType");
		var SourceID=getElementValue("SourceID"); 
		var val="&SourceType="+SourceType+"&SourceID="+SourceID;
		url="dhceq.em.ifblistforloc.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth();
	}
	else
    {
		$.messager.popover({msg:"错误信息:"+jsonData,type:'error'});
		return
    }
}

//******************************************/
// 删除选中行
// 修改人：JYP
// 修改时间：2016-9-1
// 修改描述：添加了判断，使其可以删除空行
//******************************************/
function DeleteData()
{
	var rows = $('#tDHCEQIFBList').datagrid('getSelections'); //选中要删除的行
	if(rows.length<=0){
		jQuery.messager.alert("提示","请选择要删除的项");
		return;
	}
	if(SelectRowID=="")
	{
		jQuery.messager.alert('提示','请选择要删除的项','warning');
		return;
	}
	//提示是否删除
	jQuery.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {
		if (res)
		{
			//modofied by zy ZY0206 begin
			if(typeof(SelectRowID)=="undefined")
			{
				if(editFlag>="0"){
					$("#tDHCEQIFBList").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
				}
				removeCheckBoxedRow("tDHCEQIFBList")
				return
			}
			else
			{
				var RowData={"IFBLRowID":SelectRowID}; //add by zx 2019-09-12
				RowData = JSON.stringify(RowData);
				var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","SaveDataList",RowData,"1");
				//jsonData=JSON.parse(jsonData)
				//if (jsonData.SQLCODE==0)
				if (jsonData==0)
				{
					var SourceType=getElementValue("SourceType");
					var SourceID=getElementValue("SourceID"); 
					var val="&SourceType="+SourceType+"&SourceID="+SourceID;
					url="dhceq.em.ifblistforloc.csp?"+val
				    window.location.href= url;
				    //modified by ZY0222 2020-04-16
				    websys_showModal("options").mth();
				}
				else
			    {
					$.messager.popover({msg:"错误信息:"+jsonData,type:'error'});
					return
			    }
			}
			//modofied by zy ZY0206 end
		}
	});
}
/*
var brandcomboboxeditor={
	type: 'combobox',//设置编辑格式
	options: {
		valueField: "id", 
		textField: "text",
		panelHeight:"auto",  //设置容器高度自动增长
		url: url+'?action=GetBrand',
		filter: function(q,row){  //modify by JYP20160926
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q)>-1;
			},
		onSelect:function(option){
			var ed=$('#tDHCEQIFBList').datagrid('getEditor',{index:editFlag,field:'TBrandDR'});
			jQuery(ed.target).val(option.id);  //设置ID
			var ed=$('#tDHCEQIFBList').datagrid('getEditor',{index:editFlag,field:'TBrand'});
			jQuery(ed.target).combobox('setValue', option.text);  //设置Desc
		}
	}
}
var vendorcomboboxeditor={
	type: 'combobox',//设置编辑格式
	options: {
		valueField: "id", 
		textField: "text",
		panelHeight:"auto",  //设置容器高度自动增长
		url: url+'?action=GetVendor',
		filter: function(q,row){  //modify by JYP20160926
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q)>-1;
			},
		onSelect:function(option){
			var ed=$('#tDHCEQIFBList').datagrid('getEditor',{index:editFlag,field:'TVendorDR'});
			jQuery(ed.target).val(option.id);  //设置ID
			var ed=$('#tDHCEQIFBList').datagrid('getEditor',{index:editFlag,field:'TVendor'});
			jQuery(ed.target).combobox('setValue', option.text);  //设置Desc
		}
	}
}
*/
// add by zx 2019-09-12
// 供货商
function getVendor(index,data)
{
	var rowData = $('#tDHCEQIFBList').datagrid('getSelected');
	rowData.IFBLVendorDR=data.TRowID;
	var iFBLVendorEdt = $('#tDHCEQIFBList').datagrid('getEditor', {index:editFlag,field:'IFBLVendor'});
	$(iFBLVendorEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQIFBList').datagrid('endEdit',editFlag);
	$('#tDHCEQIFBList').datagrid('beginEdit',editFlag);
}

// add by zx 2019-09-12
// 生产厂商
function getManuFactory(index,data)
{
	var rowData = $('#tDHCEQIFBList').datagrid('getSelected');
	rowData.IFBLManuFactoryDR=data.TRowID;
	var iFBLManuFactoryEdt = $('#tDHCEQIFBList').datagrid('getEditor', {index:editFlag,field:'IFBLManuFactory'});
	$(iFBLManuFactoryEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQIFBList').datagrid('endEdit',editFlag);
	$('#tDHCEQIFBList').datagrid('beginEdit',editFlag);
}

// add by zx 2019-09-12
// 规格型号
function getModel(index,data)
{
	var rowData = $('#tDHCEQIFBList').datagrid('getSelected');
	rowData.IFBLModelDR=data.TRowID;
	var iFBLModelEdt = $('#tDHCEQIFBList').datagrid('getEditor', {index:editFlag,field:'IFBLModel'});
	$(iFBLModelEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQIFBList').datagrid('endEdit',editFlag);
	$('#tDHCEQIFBList').datagrid('beginEdit',editFlag);
}

// add by zx 2019-09-12
// 品牌
function getBrand(index,data)
{
	var rowData = $('#tDHCEQIFBList').datagrid('getSelected');
	rowData.IFBLBrandDR=data.TRowID;
	var iFBLBrandEdt = $('#tDHCEQIFBList').datagrid('getEditor', {index:editFlag,field:'IFBLBrand'});
	$(iFBLBrandEdt.target).combogrid("setValue",data.TDesc);
	$('#tDHCEQIFBList').datagrid('endEdit',editFlag);
	$('#tDHCEQIFBList').datagrid('beginEdit',editFlag);
}