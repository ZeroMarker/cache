var editFlag="undefined";
var GlobalObj = {
	SourceType : "",
	SourceID : "",
	ReadOnly : "",
	CurRole : "",
	Status : "",
	toolbar : "",
	ElementID : "",
	TemplateID : "",
	IsFunction : "",
	GetData : function()
	{
		this.SourceType = getElementValue("#SourceType");
		this.SourceID = getElementValue("#SourceID");
		this.ReadOnly = getElementValue("#ReadOnly");
		this.CurRole = getElementValue("#CurRole");
		this.Status = getElementValue("#Status");
		this.ElementID = getElementValue("#ElementID");
		this.TemplateID = getElementValue("#TemplateID");
		this.IsFunction = getElementValue("#IsFunction");
		if (this.ReadOnly==0)
		{
			this.toolbar=[
			{
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddBillItemData();}
			},
			{
				iconCls:'icon-save',
				text:'保存',
				handler:function(){SaveBillItemData();}
			},
			{
				iconCls:'icon-cut',
				text:'删除',
				handler:function(){DeleteBillItemData();}
			}
			]
			
		}
	}
}
jQuery(document).ready(function()
{
	initDocument();
})

function initDocument()
{
	GlobalObj.GetData();
	alertShow("aaa")
	initBillItem()
	if (GlobalObj.ReadOnly=="1")
	{
		jQuery('#BSvae').hide();
		jQuery('#BDelete').hide();
	}
	else
	{
		$('#BSvae').show();
		$('#BDelete').show();
	}
}

function initBillItem()
{
	$HUI.datagrid("#tDHCEQBillItem",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQBillItem",
	        	QueryName:"GetBillItem",
				InStockID:GlobalObj.SourceType,
				InStockID:GlobalObj.SourceID,
				InStockID:GlobalObj.IsFunction,
		},
		fit:true,
		border:'true',
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		toolbar:GlobalObj.toolbar,
		columns:[[
				{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
				{field:'TCode',title:'代码',width:100,align:'center',editor:texteditor,hidden:true},
				{field:'TDesc',title:'诊疗项目名称',width:100,align:'center',editor:texteditor},
				{field:'TSourceType',title:'来源类型',width:100,align:'center',hidden:true},
				{field:'TSourceID',title:'来源',width:100,align:'center',hidden:true},
				{field:'TPrice',title:'收费标准',width:100,align:'center',editor:texteditor},
				{field:'TWorkLoadNum',title:'预计工作量',width:100,align:'center',editor:texteditor},
				{field:'TTotalFee',title:'预计收入',width:100,align:'center'}

				
			]],
			pageSize:20,  // 每页显示的记录条数
			pageList:[20],   // 可以设置每页记录条数的列表
	        singleSelect:true,
			loadMsg: '正在加载信息...',
			pagination:true,
		    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQBillItem').datagrid('endEdit', editFlag);
	                if((rowData.TPrice!="")&&(rowData.TWorkLoadNum!=""))
             		{
		             	var TotalFee=parseFloat(rowData.TPrice)*parseFloat(rowData.TWorkLoadNum) 
		             	alertShow(TotalFee)
		             	alertShow(TotalFee.toFixed(2))
		             	rowData.TTotalFee = TotalFee.toFixed(2)
	        			$('#tDHCEQBillItem').datagrid('refreshRow',editFlag)
	       			 }
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQBillItem').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        }
	});
}
// 保存编辑行
function SaveBillItemData()
{
	if(editFlag>="0"){
		$('#tDHCEQBillItem').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQBillItem').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	var flag=0
	for(var i=0;i<rows.length;i++)
	{
		if ((rows[i].TDesc=="")||(rows[i].TPrice=="")||(rows[i].TWorkLoadNum==""))   flag=flag+1;
		var tmp=rows[i].TRowID+"^"+rows[i].TCode+"^"+rows[i].TDesc+"^"+GlobalObj.SourceType+"^"+GlobalObj.SourceID+"^"+rows[i].TPrice+"^"+rows[i].TCost+"^"+rows[i].TWorkLoadNum+"^^^"+GlobalObj.IsFunction;
		dataList.push(tmp);
	}
	if (flag>0)
	{
		jQuery.messager.alert("提示","有"+flag+"行诊疗项目信息填写不全！");
		return;
	}
	var CombineData=dataList.join("&");
	var AllInFee=0
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		async:false,
		data:{
			ClassName:'web.DHCEQBillItem',
			MethodName:'SaveBillItem',
			Arg1:CombineData,
			Arg2:GlobalObj.ElementID,
			Arg3:GlobalObj.TemplateID,
			Arg4:GlobalObj.SourceType,
			Arg5:GlobalObj.SourceID,
			ArgCnt:5
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			alertShow(XMLHttpRequest.status);
			alertShow(XMLHttpRequest.readyState);
			alertShow(textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			$.messager.progress('close');
			if(list[0]==0)
			{
				alertShow(list[1]);
				AllInFee=list[1]
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#tDHCEQBillItem').datagrid('reload');
				
			}
			else
				$.messager.alert('保存失败！','错误代码:'+data, 'warning');
		}
	});
	opener.document.getElementById("24").value=AllInFee
	window.opener.AllOutFee()
}
// 插入新行
function AddBillItemData()
{
	var SourceType=$("#SourceType").val();
	var SourceID=$("#SourceID").val();
	if(editFlag>="0"){
		$('#tDHCEQBillItem').datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	//在指定行添加数据，appendRow是在最后一行添加数据
	$('#tDHCEQBillItem').datagrid('appendRow', 
	{
		TRowID: '',
		TCode:'',
		TDesc: '',
		TPrice:'',
		TCost:'',
		TWorkLoadNum:''
	});
	editFlag=0;
}
//******************************************/
// 删除选中行
// 修改人：JYP
// 修改时间：2016-9-1
// 修改描述：添加了判断，使其可以删除空行
//******************************************/
function DeleteBillItemData()
{
	var rows = $('#tDHCEQBillItem').datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQBillItem',
							MethodName:'DeleteBillItem',
							Arg1:rows[0].TRowID,
							ArgCnt:1
						},
						beforeSend:function(){$.messager.progress({text:'正在删除中'})},
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alertShow(XMLHttpRequest.status);
							alertShow(XMLHttpRequest.readyState);
							alertShow(textStatus);
						},
						success:function(data,response,status)
						{
							$.messager.progress('close');
							data=data.replace(/\ +/g,"")	//去掉空格
							data=data.replace(/[\r\n]/g,"")	//去掉回车换行
							if(data==0)
							{
								$.messager.show({title: '提示',msg: '删除成功'});
								$('#tDHCEQBillItem').datagrid('reload');
							}
							else
								$.messager.alert('删除失败！','错误代码:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQBillItem').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQBillItem').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
