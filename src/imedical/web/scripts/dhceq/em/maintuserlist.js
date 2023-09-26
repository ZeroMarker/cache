var editFlag="undefined";
var SelectRowID=""
var GlobalObj = {
	TypeValue : [{"value":"","text":""},{"value":"1","text":"临时"},{"value":"2",text:"正式"},{"value":"3","text":"指导"},{"value":"4","text":"其他"}],
	SourceType : "",
	SourceID : "",
	Action : "",
	toolbar : "",
	UserIDs : "",
	GetData : function()
	{
		this.SourceType = getElementValue("SourceType");
		this.SourceID = getElementValue("SourceID");
		this.Action = getElementValue("Action");
		if ((this.Action=="WX_Maint")||(this.Action=="WX_Finish"))
		{
			this.toolbar=[
			{
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddData();}
			},
			{
				iconCls:'icon-save',
				text:'保存',
				handler:function(){SaveData();}
			},
			{
				iconCls:'icon-remove',
				text:'删除',
				handler:function(){DeleteData();}
			}
			]
			
		}
	},
	SetUserIDs : function(UserID)
	{
		if (this.UserIDs=="")
		{
			this.UserIDs=UserID;
		}
		else
		{
			this.UserIDs=this.UserIDs+","+UserID;
		}
	},
	CheckUserIDs : function(UserID)
	{
		if (this.UserIDs == "") return -1;
		var tempStr =","+this.UserIDs+"," ; 
    	return tempStr.indexOf(","+UserID+","); //返回大于等于0的整数值，若不包含"Text"则返回"-1。
	}
}
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	defindTitleStyle();
	GlobalObj.GetData();
	initDHCEQMaintUserList();
}
function initDHCEQMaintUserList()
{
	$HUI.datagrid("#tDHCEQMaintUserList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQMaintUserList",
	        QueryName:"GetMaintUserList",
	        SourceType:getElementValue("SourceType"),
	        SourceID:getElementValue("SourceID"),
	    },
	    fit:true,
		singleSelect:true,
		toolbar:GlobalObj.toolbar,
		columns:[[
				{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true,editor:texteditor},
				{field:'TSourceType',title:'',width:50,align:'center',hidden:true},
				{field:'TSourceID',title:'',width:50,align:'center',hidden:true},
				{field:'TUserID',title:'工程师ID',width:100,align:'center',hidden:true,editor:texteditor},
				{field:'TUser',title:'工程师',width:100,align:'center',editor:comboboxeditor},
				{field:'TWorkHour',title:'工作时长',width:100,align:'center',editor:texteditor},
				{field:'THold1',title:'THold1',width:100,align:'center',hidden:true,editor:texteditor},
				{field:'TTypeDesc',title:'员工类型',width:100,align:'center',editor:{
				type: 'combobox',
				options: {
					data: GlobalObj.TypeValue,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: true,
					onSelect:function(option){
						var ed=jQuery("#tDHCEQMaintUserList").datagrid('getEditor',{index:editFlag,field:'THold1'});
						jQuery(ed.target).val(option.value);  //设置ID
						var ed=jQuery("#tDHCEQMaintUserList").datagrid('getEditor',{index:editFlag,field:'TTypeDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
						}
					}
				}},
				{field:'THold2',title:'',width:60,align:'center',hidden:true},
				{field:'THold3',title:'',width:60,align:'center',hidden:true},
				{field:'THold4',title:'',width:60,align:'center',hidden:true},
				{field:'THold5',title:'',width:60,align:'center',hidden:true},
				
			]],
			loadMsg: '正在加载信息...',
		    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQMaintUserList').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQMaintUserList').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        },
			onLoadSuccess:function(data){
				var rows = $("#tDHCEQMaintUserList").datagrid("getRows"); //这段代码是获取当前页的所有行。
				for(var i=0;i<rows.length;i++)
				{
					//给对象ObjCertInfo赋值
					GlobalObj.SetUserIDs(rows[i].TUserID);			
				}
			},
			onSelect:function(index,row){ 
				if (SelectRowID!=row.TRowID)
				{
					SelectRowID=row.TRowID
				}
				else
				{
					SelectRowID=""
				}
			},

});
}
// 保存编辑行
function SaveData()
{
	if(editFlag>="0"){
		$('#tDHCEQMaintUserList').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQMaintUserList').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^"+GlobalObj.SourceType+"^"+GlobalObj.SourceID+"^"+rows[i].TUserID+"^"+rows[i].TWorkHour+"^"+rows[i].THold1+"^^^^";
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	alertShow(CombineData)
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQMaintUserList',
			MethodName:'SaveData',
			Arg1:CombineData,
			ArgCnt:1
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
			$.messager.progress('close');
			if(data==0)
			{
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#tDHCEQMaintUserList').datagrid('reload');
			}
			else
				$.messager.alert('保存失败！','错误代码:'+data, 'warning');
		}
	});
}
// 插入新行
function AddData()
{
	var SourceType=GlobalObj.SourceType;
	var SourceID=GlobalObj.SourceID;
	if(editFlag>="0"){
		$('#tDHCEQMaintUserList').datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	//在指定行添加数据，appendRow是在最后一行添加数据
	$('#tDHCEQMaintUserList').datagrid('appendRow', 
	{
		TRowID: '',
		TUserID:'',
		TUser:'',
		TWorkHour:''
	});
	editFlag=0;
}
//******************************************/
// 删除选中行
// 修改人：JYP
// 修改时间：2016-9-1
// 修改描述：添加了判断，使其可以删除空行
//******************************************/
function DeleteData()
{
	var rows = $('#tDHCEQMaintUserList').datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		if(SelectRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQMaintUserList',
							MethodName:'DeleteData',
							Arg1:SelectRowID,
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
								$('#tDHCEQMaintUserList').datagrid('reload');
							}
							else
								$.messager.alert('删除失败！','错误代码:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQMaintUserList').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQMaintUserList').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}
///设置combobox编辑
var comboboxeditor={
	type: 'combobox',//设置编辑格式
	options: {
		valueField: "id", 
		textField: "text",
		panelHeight:"auto",  //设置容器高度自动增长
		required: true,
		url: 'dhceq.jquery.operationtype.csp?action=GetMaintUser',
		onSelect:function(option){
			var ed=jQuery("#tDHCEQMaintUserList").datagrid('getEditor',{index:editFlag,field:'TUserID'});
			if (GlobalObj.CheckUserIDs(option.id)>=0)
			{
				jQuery.messager.alert("提示","工程师人员不能重复!");
			}else
			{
				jQuery(ed.target).val(option.id);  //设置ID
				var ed=jQuery("#tDHCEQMaintUserList").datagrid('getEditor',{index:editFlag,field:'TUser'});
				jQuery(ed.target).combobox('setValue', option.text);  //设置科室Desc
			}
		}
	}
}
