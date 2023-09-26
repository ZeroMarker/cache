
var editFlag="undefined";	//判断当前编辑行
var PreSelectedRowID = "";	//取当前选中的组件设备记录ID
var t=[]
t[-9201]="不能为空"	//add by csj 20190416

var GlobalObj = {
	
	ComponentDR : "",
	SysSetFlag : "" , //DHC_EQCComponent Hold1 字段存是否是系统设置
	ComponentSetColumns : getCurColumnsInfo('PLAT.G.Config.ComponentSet',"","",""),
	ComponentSetItemColumns :getCurColumnsInfo('PLAT.G.Config.ComponentSetItem',"","",""),
	ClearData : function(vElementID)
	{
		if (vElementID=="Component") {this.ComponentDR = "";}
	},
	ClearAll : function()
	{
		this.ComponentDR = "";
		this.SysSetFlag = "";
	}
}
$(document).ready(function (){
	initDocument();	
	defindTitleStyle();
	initLookUp();
		$HUI.datagrid("#ComponentSet",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQCComponentSet",
	        QueryName:"GetComponentSet",
	        SourceType:$("#SourceType").combobox("getValue"),
	        SourceID:getElementValue("SourceIDDR"),  //modify by lmm 2020-02-28
	        ComponentID:'',
	    },
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
    	columns:GlobalObj.ComponentSetColumns, 
    	toolbar:[
    		{
	    		id:"Delete",
				iconCls:'icon-cancel', 
				text:'删除',
				handler:function(){DeleteGridData();}
			} 
		], 
		onLoadSuccess:function(data)
		{
			
		},
		onClickRow:function(rowIndex, rowData)
		{
			fillData_OnClickRow(rowIndex, rowData);
		},
		//pageSize:20,
    	//pageNumber:1,
		detailFormatter:function(rowIndex, rowData){
			
			}
		});


	$("#SourceType").combobox({
		onChange: function(SourceType,TSourceType){
			if($("#SourceType").combobox("getValue")==0)
			{
	    		disableElement("SourceID",true)
				$("#SourceID").lookup();
				setElement("SourceID",0)
				setElement("SourceIDDR","0")    //add by lmm 2020-02-27 LMM0060
				singlelookup("Component","PLAT.L.Component","","")     //add by lmm 2019-04-19 871125
			}

			else if($("#SourceType").combobox("getValue")==1)
			{
	    		disableElement("SourceID",false)
	    		setElement("SourceID","")
				singlelookup("SourceID","PLAT.L.Hospital","","")  
				singlelookup("Component","PLAT.L.Component","","")     //add by lmm 2019-04-19 871125 
	
			}
			else if($("#SourceType").combobox("getValue")==2)
			{
	    		disableElement("SourceID",false)
	    		setElement("SourceID","")
				singlelookup("SourceID","PLAT.L.Group","",setGroupValue)  //modify by lmm 2019-11-19 LMM0049
				singlelookup("Component","PLAT.L.Component","","")     //add by lmm 2019-04-19 871125 
				
			}
			else if($("#SourceType").combobox("getValue")==3)
			{
	    		disableElement("SourceID",false)
	    		setElement("SourceID","")
				singlelookup("SourceID","PLAT.L.EQUser","","")
				singlelookup("Component","PLAT.L.Component","","")     //add by lmm 2019-04-19 871125 
	
			}
		}
	});
});

function initDocument()
{
	GlobalObj.ClearAll();
//	setItemRequire("Component",true)
	setRequiredElements("SourceType^SourceID^Component")	//add by csj 20190415
	//initComponentPanel()
	//initComponentData()
	jQuery("#BAddComponent").linkbutton({iconCls: 'icon-w-edit'});
	jQuery("#BAddComponent").click(function(){AddComponent()});
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").click(function(){findGridData()});
	jQuery("#BSvae").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BSvae").click(function(){SavegridData()});
	//jQuery("#BDelete").click(function(){DeleteGridData()});
}
//modify by lmm 2018-10-23 删减弹窗参数，修改宽高
function AddComponent()
{
	var url="dhceq.plat.ctcomponent.csp?&ComponentID="+GlobalObj.ComponentDR;
	var title="组件定义"
	var width="1300"
	var height="600"
	var icon="icon-w-edit"
	var showtype="modal"   //add by lmm 2018-11-02
	showWindow(url,title,width,height,icon,showtype,"","","large"); //modify by lmm 2020-06-05 UI
}

function setSelectValue(vElementID,item)
{
	if (vElementID=="Component") 
	{
		GlobalObj.ComponentDR = item.TRowID;
		setElement("ComponentDR",item.TRowID);	//add by csj 20190416
	}
	//add by lmm 2019-11-19 LMM0049 begin
	if (vElementID=="SourceID") 
	{
		setElement("SourceIDDR",item.TRowID);
	}
	
	//add by lmm 2019-11-19 LMM0049 end
}
//add by lmm 2019-11-19 LMM0049
function setGroupValue(item)
{
	setElement("SourceID",item.TGroupName);
	setElement("SourceIDDR",item.TGroupID);
	
}

//GAI
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{
		setElement("ComponentDR",rowData.TComponentID);
		GlobalObj.ComponentDR=rowData.TComponentID
		GlobalObj.SysSetFlag=rowData.THold1
		setElement("Component",rowData.TComponentName);
		setElement("Layout",rowData.TLayout);
		setElement("SourceType",rowData.TSourceType);
		setElement("SourceIDDR",rowData.TSourceID); //modify by lmm 2019-11-19 LMM0049
		setElement("SourceID",rowData.TSource); //modify by lmm 2019-11-19 LMM0049
		setElement("ComponentDesc",rowData.TComponentDesc);
		PreSelectedRowID=rowData.TRowID
		if (GlobalObj.SysSetFlag=="Y")
		{
			disableElement("BSvae",true)
			disableElement("Delete",true)
		}
		else
		{
			disableElement("BSvae",false)
			disableElement("Delete",false)
		}
	}
	else
	{
		Clear();
		if (GlobalObj.SysSetFlag=="Y")
		{
			$('#BSvae').show();
		}
		PreSelectedRowID=""
		$('#ComponentSet').datagrid('unselectAll');  
	}
	
	$HUI.datagrid("#ComponentSetItem",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQCComponentSet",
	        QueryName:"GetComponentSetItem",
	        ComponentSetID:PreSelectedRowID,
	    },
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
    	columns:GlobalObj.ComponentSetItemColumns, 
    	toolbar:[
    		{
				iconCls:'icon-save', 
				text:'保存',
				handler:function(){SaveItemgridData();}
			}   
		], 
	    onSelect: function (rowIndex, rowData) {//单击行取消编辑
	    	if (editFlag!="undefined") 
	    	{
                jQuery("#ComponentSetItem").datagrid('endEdit', editFlag); 
            }
        },
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    	if (editFlag!="undefined")
	    	{
                jQuery("#ComponentSetItem").datagrid('endEdit', editFlag); 
            }
            
            jQuery("#ComponentSetItem").datagrid('beginEdit', rowIndex);
            editFlag =rowIndex;
        },
		});
	
}

function SavegridData(){
	if (checkMustItemNull()) return;	//add by csj 20190416
//	if (CheckData()==false) return false;
	var val=""
	val=PreSelectedRowID;
	val=val+"^"+getElementValue("SourceType");
	val=val+"^"+getElementValue("SourceIDDR"); //modify by lmm 2019-11-19 LMM0049
	val=val+"^"+GlobalObj.ComponentDR;
	val=val+"^";	//Layout
	val=val+"^";	//Hold1
	val=val+"^";	//Hold2
	val=val+"^";	//Hold3
	val=val+"^";	//Hold4
	val=val+"^";	//Hold5	
	
	//modify by lmm 2018-11-28 begin
	var data=tkMakeServerCall("web.DHCEQCComponentSet","SaveComponentSetNew",val,"0");
	data=data.replace(/\ +/g,"")	//去掉空格
	data=data.replace(/[\r\n]/g,"")	//去掉回车换行
	if (data ==0) 
	{
		$.messager.show({title: '提示',msg: '保存成功'});
		$('#ComponentSet').datagrid('reload');
		Clear();
	}
	else
	{
   		$.messager.alert('添加失败！',"保存失败", 'warning')
   		return;
    }
	//modify by lmm 2018-11-28 end
    
}

function DeleteGridData(){
    if (PreSelectedRowID==""){
            $.messager.alert("错误", "请选中一行！", 'error') /// Modfied by zc 2015-07-27 ZC0026
            return false;
    }else
    {
	    $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) {
	        if (b==false)
	        {
	             return;
	        }
	        else
	        {
				//modify by lmm 2018-11-28 begin
				var data=tkMakeServerCall("web.DHCEQCComponentSet","SaveComponentSetNew",PreSelectedRowID,"1");
        		if (data ==0) 
        		{
					$.messager.show({title: '提示',msg: '删除成功!'});
					$('#ComponentSetItem').datagrid({   
					    url:'dhceq.jquery.csp', 
					    queryParams:{
					        ClassName:"web.DHCEQCComponentSet",
					        QueryName:"GetComponentSetItem",
					        Arg1:0,
					        ArgCnt:1
					    }
					})
					$('#ComponentSet').datagrid('reload');
           		}
            	else
            	{
               		$.messager.alert('删除失败！',data, 'warning')
               		return;
                }
				//modify by lmm 2018-11-28 end
	        }         
        })
		    
	}
}
function findGridData()
{
		$HUI.datagrid("#ComponentSet",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQCComponentSet",
	        QueryName:"GetComponentSet",
	        SourceType:$("#SourceType").combobox("getValue"),
	        SourceID:getElementValue("SourceIDDR"),  //modify by lmm 2020-02-27 SourceID
	        ComponentID:GlobalObj.ComponentDR,   //add by lmm 2018-10-25
	    }
		});
	
}
function SaveItemgridData()
{
	var ListData=""
	if(editFlag>="0"){
		jQuery("#ComponentSetItem").datagrid('endEdit', editFlag);
	}
	var rows = jQuery("#ComponentSetItem").datagrid('getRows');
	if(rows.length<=0){
		return ListData;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].TCSIRowID=="")&&(rows[i].TNeedFlag=='N')){
			//messageShow("","","",rows[i].TNeedFlag+"&&"+rows[i].TCSIRowID)
			}
		else
		{
			var tmp=""
			tmp=rows[i].TNeedFlag
			tmp=tmp+"^"+rows[i].TCSIRowID
			tmp=tmp+"^"+rows[i].TRowID
			tmp=tmp+"^"+rows[i].TCaption
			tmp=tmp+"^"+rows[i].TCaptionStyle
			tmp=tmp+"^"+rows[i].TDisabled
			tmp=tmp+"^"+rows[i].TDisplayOnly
			tmp=tmp+"^"+rows[i].THidden
			tmp=tmp+"^"+rows[i].TStyle
			tmp=tmp+"^"+rows[i].TReadOnly
			tmp=tmp+"^"+rows[i].TSort
			tmp=tmp+"^"	//+rows[i].THold1
			tmp=tmp+"^"	//+rows[i].THold2
			tmp=tmp+"^"	//+rows[i].THold3
			tmp=tmp+"^"	//+rows[i].THold4
			tmp=tmp+"^"	//+rows[i].THold5
			dataList.push(tmp);
		}
	}
	var ListData=dataList.join("&");
	//modify by lmm 2018-11-28 begin
	var data=tkMakeServerCall("web.DHCEQCComponentSet","SaveComponentItem",PreSelectedRowID,ListData);
	if (data ==0) 
	{
		$.messager.show({title: '提示',msg: '保存成功'});
		$('#ComponentSetItem').datagrid('reload');
	}
	else
	{
   		$.messager.alert('添加失败！',data, 'warning')
   		return;
    }
	//modify by lmm 2018-11-28 end
}

//数据有效检测 Add JDL 20151020
function CheckData()
{
    if ($('#SourceType').combobox('getValue')==""){
            $.messager.alert("错误", "来源类型为空！", 'error')
            return false;
    }
    //$('#SourceID').val('setValue','0')
    if (getElementValue("SourceID")==""){
            $.messager.alert("错误", "来源为空！", 'error')
            return false;
    }
    if (GlobalObj.ComponentDR==""){
            $.messager.alert("错误", "组件为空！", 'error')
            return false;
    }
	return true;
}
function Clear()
{
	setElement("SourceType","")
	//modify by lmm 2019-11-19 LMM0049
	setElement("SourceID","")
	setElement("SourceIDDR","")
	GlobalObj.ComponentDR=""
	GlobalObj.SysSetFlag=""
	setElement("Component","")
}

function checkboxDisabledChange(TDisabled,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TDisabled==key)
			{
				if (((val=="N")||val=="")) row.TDisabled="Y"
				else row.TDisabled="N"
			}
		})
	}
}


function checkboxDisplayOnlyChange(TDisplayOnly,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TDisplayOnly==key)
			{
				if (((val=="N")||val=="")) row.TDisplayOnly="Y"
				else row.TDisplayOnly="N"
			}
		})
	}
}

function checkboxHiddenChange(THidden,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (THidden==key)
			{
				if (((val=="N")||val=="")) row.THidden="Y"   //modify by lmm 2019-04-19 870946
				else row.THidden="N"
			}
		})
	}
}

function checkboxReadOnlyChange(TReadOnly,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TReadOnly==key)
			{
				if (((val=="N")||val=="")) row.TReadOnly="Y"
				else row.TReadOnly="N"
			}
		})
	}
}

function checkboxNeedFlagChange(TNeedFlag,rowIndex)
{
	var row = jQuery('#ComponentSetItem').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TNeedFlag==key)
			{
				if ((val=="N")||(val=="")) row.TNeedFlag="Y"     //modify by lmm 2019-04-19 870946
				else row.TNeedFlag="N"
			}
		})
	}
}
///add by lmm 2019-04-19 下拉框dr值清空
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

