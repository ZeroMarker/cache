//20181219+dyl
var reg=/^[0-9]+.?[0-9]*$/; 
var SPARowID="";
var selectOperIndex;

$(function(){
	InitForm();
	InitDataGrid();
	
});
function InitForm()
{
		$("#SBodySite").combobox({
		url:$URL+"?ClassName=web.DHCANCSiteProphyAntibiotics&QueryName=FindBodySite&ResultSetType=array",
        valueField:"BodySiteRowId",
        textField:"BodySiteDesc",
        onBeforeLoad:function(param)
        {
	    }
	    
	})
	$("#BodySite").combobox({
		url:$URL+"?ClassName=web.DHCANCSiteProphyAntibiotics&QueryName=FindBodySite&ResultSetType=array",
        valueField:"BodySiteRowId",
        textField:"BodySiteDesc",
        onBeforeLoad:function(param)
        {
	    }, 
	    onHidePanel: function () {
               OnHidePanel("#BodySite");
            }
	})
	$("#Arcim").combobox({
		url:$URL+"?ClassName=web.DHCANCSiteProphyAntibiotics&QueryName=GetMasterItem&ResultSetType=array",
        valueField:"arcimId",
        textField:"arcimDesc",
        onBeforeLoad:function(param)
        {
	      param.needItemCatId =""
	      param.ArcimDesc =$("#Arcim").combobox("getText");
	    },
	    mode:'remote'
	    
	})
	    var yesno=$HUI.combobox("#IsActive",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"是",'typecode':"Y"},{'typedesc':"否",'typecode':"N"}]
    }) 
    $("#btnAdd").linkbutton({
        onClick: addDrug
    });

    $("#btnDel").linkbutton({
        onClick: removeDrug
    });
}
function InitDataGrid()
{
	var siteDrugObj=$HUI.datagrid("#SiteDrugListData",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCANCSiteProphyAntibiotics",
			QueryName:"FindANCSPA"	
		},
		onBeforeLoad:function(param)
        {
	        param.OecBodySiteDesc=$("#SBodySite").combobox('getText')
        },
        columns:[[
			{ field: "SPABodySite", title: "身体部位", width: 120 },
            { field: "SPAArcim", title: "医嘱", width: 340 },
            { field: "SPAArcimID", title: "医嘱ID", width: 120 },
            { field: "ANCSPAActiveDesc", title: "是否激活", width: 80 },
            { field: "SPAActive", title: "激活代码", width: 80 },
            { field: "ANCSPABodySiteID", title: "身体部位ID", hidden:true},
            { field: "SPARowID", title: "SPARowID", width: 80 }
        ]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyui取消单击行选中状态
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		toolbar:[{
			iconCls: 'icon-add',
		    text:'新增',
		    handler: function(){
				InsertData();
			}
	        },{
	        iconCls: 'icon-write-order',
	        text:'修改',
		    handler: function(){
				
					UpdateData();
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				DeleteData();
			}
		}],
		onSelect:function(rowIndex, rowData){
	        selectOperIndex=rowIndex;
	        SPARowID=rowData.SPARowID;
        }
	})
	//修改页面加载药品医嘱信息
	    var drugList=$HUI.datagrid("#drugList",{
        height:120,
        fit:true,
        singleSelect:true,
        rownumbers:true,
        showHeader:false,
        headerCls:'panel-header-gray',
        columns: [
            [
                { field: "DrugID", title: "ID",   width: 80 },
                { field: "DrugDesc", title: "名称", width: 240 }
            ]
        ]
    })
	$("#btnSearch").click(function(){
        $HUI.datagrid("#SiteDrugListData").reload();
    });
}

	function setDialogValue()
	{	
		$("#BodySite").combobox('setValue',"")
		$("#IsActive").combobox('setValue',"")
		$("#Arcim").combobox('setValue',"")
		$("#drugList").datagrid("loadData", { total: 0, rows: [] });
	}
	function InsertData()
	{
		$HUI.dialog("#SiteDrugDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增手术部位预防用药',
			modal:true,
			onClose:function(){  
                	setDialogValue();
            }
		})
		setDialogValue();
		$("#SiteDrugDialog").dialog("open");
	}
	UpdateData=function()
	{
		
		var siteDrugDialogObj=$HUI.dialog("#SiteDrugDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'修改手术部位预防用药',
			modal:true,
			onClose:function(){  
                	setDialogValue();
            }
		})
		var row=$("#SiteDrugListData").datagrid("getSelected");
		if(!row) 
		{
			$.messager.alert("提示", "请先选择要修改的记录！", 'warning');
			return;
		}
		SPARowID=row.SPARowID;
		//row.SPARowID,row.SPABodySite,row.SPAArcimID,SPAActive
		$("#BodySite").combobox('setValue',row.ANCSPABodySiteID)
		$("#IsActive").combobox('setValue',row.SPAActive)
		$("#EditOperation").val("Y");
		InitDrugList(row.SPAArcimID);
		$("#SiteDrugDialog").dialog("open");
	}
	DeleteData=function()
	{
		var row=$("#SiteDrugListData").datagrid("getSelected");
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCANCSiteProphyAntibiotics",
								MethodName:"DeleteSiteProphy",
								siteProId:row.SPARowID
							},function(success)
							{
								if(success==0)
								{
									$.messager.alert("提示","删除成功！","info");
									$("#SiteDrugListData").datagrid("reload");
								}else{
									$.messager.alert("提示","删除失败！错误代码："+success,"error");
								}
							})
						}
						
					})
				}
				else
				{
					$.messager.alert("提示","请选择一行","warning");
					}
	}
//添加一条药品
function addDrug(){
    var drugID = $("#Arcim").combobox("getValue");
    var drugDesc = $HUI.combobox("#Arcim").getText();
    if(drugID==drugDesc)
    {
	    $.messager.alert("提示","请从下拉框中选择医嘱!","error");
		  return; 
    }
      //20180828+dyl
     var rows = $("#drugList").datagrid("getRows"),
      result = "";
      var exsitflag=0
    if (rows && rows.length > 0) {
        $.each(rows, function(index, row) {
	        if(drugID==row.DrugID)
	        {
		        $.messager.alert("提示","该医嘱已存在!","error");
                    exsitflag=1;
                    return;
	        }
        });
    }
    if(exsitflag==1)return;
    if (drugDesc && drugDesc != "") {
        $HUI.datagrid("#drugList").appendRow({
            DrugID: drugID,
            DrugDesc: drugDesc
        });
        $HUI.combobox("#Arcim").clear();
        setDrugList();
        
    }
   
}
//删除一条药品
function removeDrug(){
    var selectRow=$HUI.datagrid("#drugList").getSelected(),
        selectRowIndex=$HUI.datagrid("#drugList").getRowIndex(selectRow);
    if(selectRow)
    {
        $HUI.datagrid("#drugList").deleteRow(selectRowIndex);
        setDrugList();
    }else{
        $.messager.alert("提示","请选择要删除的医嘱","warning");
        return;
    }
}

function InitDrugList(arcimDrStr)
{
	 var arcimStr=$.m({
            ClassName:"web.DHCANCSiteProphyAntibiotics",
            MethodName:"GetSPAArcimInfo",
            ANCSPAArcimIDStr:arcimDrStr
        },false);
	setDefaultArcim(arcimStr)
}
function setDefaultArcim(arcimStr)
{
    var datas=[];
    if(arcimStr!="")
    {
        var arcimStrList=arcimStr.split(",");
        if(arcimStrList.length>0)
        {
            for(var i=0;i<arcimStrList.length;i++)
            {
                var item=arcimStrList[i].split("!");
                if(item[0]==""&&item[1]=="") continue;
                var data={DrugID:item[0],DrugDesc:item[1]};
                datas.push(data);
            }
        }
    }
    $("#drugList").datagrid('loadData',datas);
    setDrugList();
}
function setDrugList() {
    var rows = $("#drugList").datagrid("getRows"),
        result = "";
    if (rows && rows.length > 0) {
        $.each(rows, function(index, row) {
            if (result != "") {
                result += ",";
            }
            var drugID = row.DrugID ? row.DrugID : "";
            result += drugID;
        });
    }
}

function saveSiteProphy()
{
 	 	var bodySiteDr=$("#BodySite").combobox('getValue');
 	 	 if(!reg.test(bodySiteDr))
 	 	 {
	 	 	 $.messager.alert("提示","手术部位请从下拉框选择","error");
        	return;
 	 	 }
		var bodySite=$("#BodySite").combobox('getText');
        var IsActive=$("#IsActive").combobox('getValue');
        var IsActiveDes=$("#IsActive").combobox('getText');
       var datas=$("#drugList").datagrid('getData')
        drugInfoStr="",drugDescInfoStr="";
    if(datas.total>0) 
    {
	    for(var i=0;i<datas.total;i++)
	    {
	        var ANCDRowId=datas.rows[i].DrugID;
	        if(drugInfoStr!="")
	        {
		        drugInfoStr=drugInfoStr+"~"+ANCDRowId
	        }
	        else
	        {
		        drugInfoStr=ANCDRowId
	        }
	        var dataDesc=datas.rows[i].DrugDesc;
	        if(drugDescInfoStr!="")
	        {
		        drugDescInfoStr=drugDescInfoStr+";"+dataDesc
	        }
	        else
	        {
		        drugDescInfoStr=dataDesc
	        }
	    }
    }
      var rowdata={
         SPABodySite:bodySite,
         SPAArcim:drugDescInfoStr,
         SPAArcimID:drugInfoStr,
         ANCSPAActiveDesc:IsActiveDes,
      	 SPAActive:IsActive,
         ANCSPABodySiteID:bodySiteDr
    }
     if( $("#EditOperation").val()=="Y")
    {
	    
    	var datas=$.m({
        ClassName:"web.DHCANCSiteProphyAntibiotics",
        MethodName:"UpdateSiteProphy",
        clclogId:SPARowID,
        ANCSPABodySite:bodySiteDr,
         ANCSPAArcim:drugInfoStr,
      	 ANCSPAActive:IsActive
    	},false);
       //$HUI.datagrid("#SiteDrugListData").updateRow({index:selectOperIndex,row:rowdata});
		$("#SiteDrugListData").datagrid("reload");
		$.messager.alert("提示", "修改成功！", 'info');
    }
    else
    {
    	var datas=$.m({
        ClassName:"web.DHCANCSiteProphyAntibiotics",
        MethodName:"AddSiteProphy",
         OecBodySite:bodySiteDr,
        needArcim:drugInfoStr,
        isActive:IsActive        
    	},false);
    	//$HUI.datagrid("#SiteDrugListData").appendRow(rowdata);
    	if(datas==0)
    	{
    	$("#SiteDrugListData").datagrid("reload");
    	$.messager.alert("提示", "添加成功！", 'info');
    	}
    	else
    	{
	    	$.messager.alert("提示", "添加失败！"+datas, 'error');
    	}
    }
     
	$HUI.dialog("#SiteDrugDialog").close();

}