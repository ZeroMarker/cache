
//名称    dhcpeillsalias.js
//功能    疾病别名维护-多院区
//创建    2021-08-14
//创建人  yupeng
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
var tableName = "DHC_PE_ILLSAlias";
var UserID=session['LOGON.USERID'];

$(function(){
     
        
    //获取下拉列表
    GetLocComp(SessionStr,SelectLocID)  
      
    $("#ILLSName").val(selectrowDesc);
    
    InitILLSAliasDataGrid();
      
    //新增
    $('#add_btn').click(function(e){
        AddData();
    });
    
    //修改
    $('#update_btn').click(function(){
        UpdateData();
    });
    
    //删除
    $('#del_btn ').click(function(){
        DelData();
    });
    
    //单独授权
	$("#BPower").click(function(){
    	BPower_click();
	})
	
    //数据关联科室
    $("#BRelateLoc").click(function() { 
        BRelateLoc_click();     
     }); 
     
    //科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
	     InitILLSAliasDataGrid();  
	    		 
       }
		
	});
     
})


//单独授权/取消授权
function BPower_click(){
	var DateID=$("#AliasRowId").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要单独授权的记录","info"); 
		return false;
	}
	var selected = $('#ILLSAliasGrid').datagrid('getSelected');
	if(selected){
	
		//单独授权 
	    var iEmpower=$.trim($("#BPower").text());
	    if(iEmpower==$g("单独授权")){var iEmpower="Y";}
	    else if(iEmpower==$g("取消授权")){var iEmpower="N";}
		var LocID=$("#LocList").combobox('getValue');
		var UserID=session['LOGON.USERID'];
		alert(tableName+"^"+DateID+"^"+LocID+"^"+UserID+"^"+iEmpower)
	    var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",tableName,DateID,LocID,UserID,iEmpower)
		var rtnArr=rtn.split("^");
		if(rtnArr[0]=="-1"){
			$.messager.alert("提示","授权失败","error");
		}else{
			$.messager.popover({msg:'授权成功',type:'success',timeout: 1000});
			 $("#ILLSAliasGrid").datagrid('reload');
		}		
	}	
}
    
    
    
//数据关联科室
function BRelateLoc_click()
{
    var DataID=$("#AliasRowId").val()
    if (DataID==""){
        $.messager.alert("提示","请选择需要授权的记录","info"); 
        return false;
    }
   //var UserID=session['LOGON.USERID'];

   var LocID=$("#LocList").combobox('getValue')
   
   OpenLocWin(tableName,DataID,SessionStr,LocID,InitILLSAliasDataGrid)
}

function LoadILLSAlias()
{
     $("#ILLSAliasGrid").datagrid('reload');
}


//新增
function AddData(){
    Update("0");
}

//修改
function UpdateData(){
    Update("2");
}

//删除
function DelData(){
    Update("1");
}

function Update(Type){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
    var ID=$("#AliasRowId").val();
    if((Type=="1")&&(ID=="")){
         $.messager.alert('提示','请选择待删除的记录',"info");
         return false;
    }
    if((Type=="2")&&(ID=="")){
         $.messager.alert('提示','请选择待修改的记录',"info");
         return false;
    }
    if(Type=="0"){var ID="";}
    var EDId=selectrow;
    var Alias=$("#Alias").val();
    if (Alias=="")
    {
        $.messager.alert('提示','别名不能为空',"info");
         return false;
    }
    
   var DataStr=ID+"^"+EDId+"^"+Alias;
   var flag=tkMakeServerCall("web.DHCPE.CT.IllnessStandard","UpdateAlias",DataStr,Type,tableName,UserID,$("#LocList").combobox('getValue'));
   if (flag==0)
    {
        if(Type=="2"){$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});}
        if(Type=="0"){$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});}
        if(Type=="1"){$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});}
        $("#AliasRowId,#Alias").val("");
        $("#ILLSAliasGrid").datagrid('load',{
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"FindIllAlias",
            ILLSRowID:selectrow,
            tableName:tableName, 
            LocID:locId   
        }); 
    }else{
        $.messager.alert('提示',"操作失败","error");
    } 

}

function InitILLSAliasDataGrid(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
    $HUI.datagrid("#ILLSAliasGrid",{
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
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"FindIllAlias",
            ILLSRowID:selectrow,
            tableName:tableName, 
            LocID:locId     
        },
        columns:[[
            {field:'id',title:'ID',hidden: true},
            {field:'desc',width:250,title:'别名'},
            {field:'TEmpower',width:150,title:'单独授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			
			},
			{ field:'TEffPowerFlag',width:150,align:'center',title:'当前科室授权',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
        
        ]],
        onSelect: function (rowIndex, rowData) {
               
                $("#AliasRowId").val(rowData.id);
                $("#Alias").val(rowData.desc); 
                if(rowData.TEmpower=="Y"){	
					$("#BRelateLoc").linkbutton('enable');
					$("#BPower").linkbutton({text:$g('取消授权')});
				}else{
					$("#BRelateLoc").linkbutton('disable');
					$("#BPower").linkbutton('enable');
					$("#BPower").linkbutton({text:$g('单独授权')})
				
				}          
        }   
            
    })
}