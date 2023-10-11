var editIndex=undefined;
var modifyBeforeRow = {};
var Columns=getCurColumnsInfo('EM.G.EquipAttributeList','','','')
var SourceType=getElementValue("SourceType");
var SourceID=getElementValue("SourceID");
var ItemDR=getElementValue("ItemDR");
//getElementValue("ParentListData");
$(function(){
	initDocument();
}
);

function initDocument()
{
	initUserInfo();
    initMessage("InStock"); //获取所有业务消息
	defindTitleStyle(); 
    initButton(); //按钮初始化
    initButtonWidth();
   	setEnabled(); //按钮控制	Mozy003018	1279498	2020-04-27
		$HUI.datagrid("#DHCEQEquipAttributeList",{
			url:$URL,
			queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSEquipAttribute",
	        	QueryName:"GetEquipAttributeListData",
				SourceType:SourceType,
				SourceID:SourceID,
			},
			//add by lmm 2020-06-02
			toolbar:[{
						iconCls: 'icon-save',
		            	text:'保存',
		            	id:'update',	// MZY0060	1568774		2020-11-3
		            	handler: function(){
		                	BSave_Clicked();
		            }}], 
         	border:false,
			fit:true,
			striped : true,
	    	cache: false,
			columns:Columns,
			fitColumns:true,   //add by lmm 2020-06-02
			singleSelect:false,
			pagination:false,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
		});
		
	//add by lmm 2020-04-28 begin 1282948
	
	var TEALFlag=$("#DHCEQEquipAttributeList").datagrid('getColumnOption','EALFlag');	
	TEALFlag.formatter=	function(value,row,index){
				var EditFlag=tkMakeServerCall("web.DHCEQ.Plat.CTGroupEquipAttribute","EquipAttributeIsEdit","",row.EALEquipAttributeDR);
				if((EditFlag=="N")&&(row.EALCode=="11")) {var disable="disabled"}
				else {var disable=""}
				var html=""
				html=checkBox(row.EALFlag,"checkboxFlagChange","EALFlag",index,disable)   //modify by lmm 2020-06-24
				return html;
		}	
		
	// MZY0060	1568774		2020-11-3	调整按钮无效处理
	if (getElementValue("ReadOnly")=="1")
	{
		disableElement("update",true);
	}
	// MZY0157	3220824		2023-03-29
	if ((typeof(HISUIStyleCode)!="undefined")&&(HISUIStyleCode=="lite"))
	{
		jQuery("#DivPanel").attr("style","border-color: #e2e2e2");
	}
}


//按钮可用控制
function setEnabled()
{
	
}

//保存按钮操作
function BSave_Clicked()
{
	//modify by lmm 2020-05-09 1312706
	if (editIndex != undefined){ $('#DHCEQEquipAttributeList').datagrid('endEdit', editIndex);}
	var dataList=""
	var rows = $('#DHCEQEquipAttributeList').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.RLEquip=="")
		{
			messageShow("alert","error","错误提示","第"+(i+1)+"行数据不正确!");
			return "-1"
		}
		//add by wl 2020-03-17 WL0064
		if(oneRow.EALSubInfoDesc=="") 
		{
			oneRow.EALSubInfo=""
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+"&"+RowData
		}
	}


	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","SaveEquipAttribute",SourceType,SourceID,dataList);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    window.location.reload();
	}	
	else
    {
		messageShow("alert","error","错误提示","保存失败,错误信息:"+jsonData.Data);
		return
    }

}

//
function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#DHCEQEquipAttributeList').datagrid('validateRow', editIndex)){
			$('#DHCEQEquipAttributeList').datagrid('endEdit', editIndex);
    		var rows = $("#DHCEQEquipAttributeList").datagrid('getRows');
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}


function getReturnReason(index,data)
{
	var rowData = $('#DHCEQEquipAttributeList').datagrid('getSelected');
	rowData.RLReturnReasonDR=data.TRowID
	var objGrid = $("#DHCEQEquipAttributeList"); 
	var ReturnReasonEditor = objGrid.datagrid('getEditor', {index:editIndex,field:'RLReturnReason'});
	$(ReturnReasonEditor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQEquipAttributeList').datagrid('endEdit',editIndex);
	$('#DHCEQEquipAttributeList').datagrid('beginEdit',editIndex);
}
//新建公用组件取参数方法。
function getParam(ID)
{
	if (ID=="FromLocDR"){return getElementValue("RReturnLocDR")}
	else if (ID=="EquipTypeDR"){return getElementValue("REquipTypeDR")}
	else if (ID=="StatCatDR"){return getElementValue("RStatCatDR")}
	else if (ID=="ProviderDR"){return getElementValue("RProviderDR")}
}

function checkboxFlagChange(EALFlag,rowIndex)
{
	var row = $('#DHCEQEquipAttributeList').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (EALFlag==key)
			{
				if (((val=="N")||val=="")) row.EALFlag="Y"
				else row.EALFlag="N"
			}
		})
	}
}
function fillData()
{
	var strs= new Array();
	strs=parent.ObjSources.split("&"); 
	for (var i = 0; i <strs.length ; i++) 
	{
		var obj = eval('(' + strs[i] + ')');
		//strs[i].parseJSON();
		var rows = $('#DHCEQEquipAttributeList').datagrid('getRows');
		if (rows[i])
		{
			if(rows[i].EALEquipAttributeDR=obj.EALEquipAttributeDR)
			{
				rows[i].EALFlag=obj.EALFlag
				$('#DHCEQEquipAttributeList').datagrid('refreshRow',i);
			}
		}
	}
}
//Mpdify by zx BUG ZX0077
function onClickRow(index)
{
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			//add by lmm 2020-04-30 begin
			var rowDataNew = $('#DHCEQEquipAttributeList').datagrid('getSelected');
			var EditFlag=""
			var EditFlag=tkMakeServerCall("web.DHCEQ.Plat.CTGroupEquipAttribute","EquipAttributeIsEdit","",rowDataNew.EALEquipAttributeDR);
	    	if ((EditFlag=="N")&&(rowDataNew.EALCode=="11"))
	    	{
		    	messageShow('alert','error','错误提示','计量信息,不可编辑.');
		    	jQuery('#DHCEQEquipAttributeList').datagrid('unselectAll')
		    	return;
		    }			
			//add by lmm 2020-04-30 end
			$('#DHCEQEquipAttributeList').datagrid('selectRow', index).datagrid('beginEdit', index);
		
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQEquipAttributeList').datagrid('getRows')[editIndex]);
		} else {
			$('#DHCEQEquipAttributeList').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

//Mpdify by zx BUG ZX0077
//modify by wl 2020-03-17 WL0064 修改字段名
function getAttributeListCat(index,data)
{
	var rowData = $('#DHCEQEquipAttributeList').datagrid('getRows')[editIndex];
	rowData.EALSubInfo=data.TRowID;
	var subInfoDescEdt = $('#DHCEQEquipAttributeList').datagrid('getEditor', {index:editIndex,field:'EALSubInfoDesc'});
	$(subInfoDescEdt.target).combogrid("setValue",data.TName);
	$('#DHCEQEquipAttributeList').datagrid('endEdit',editIndex);
}

//Mpdify by zx BUG ZX0077
//modify by wl 2020-06-12 WL0067 删除判断
function getParam(ID)
{
	if (ID=="TypeStr")
	{
		if (editIndex == undefined) return "";
		var rowData = $('#DHCEQEquipAttributeList').datagrid('getRows')[editIndex];
		var typeStr= rowData.EALCode
		return typeStr==null?'':typeStr;
	}
}
