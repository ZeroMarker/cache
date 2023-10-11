var PageLogicObj={
	m_DHCOPForceCancelRegDataGrid:"",
};
$(document).ready(function(){ 
	Init();
	InitEvent();
	DHCOPForceCancelRegDataGridLoad();
});
function Init(){
	PageLogicObj.m_DHCOPForceCancelRegDataGrid=InitDHCOPForceCancelRegDataGrid();
	InitGroup();
	InitCache();
};
function InitEvent(){
	$('#BFind').click(DHCOPForceCancelRegDataGridLoad);
	$(document.body).bind("keydown",BodykeydownHandler);
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitDHCOPForceCancelRegDataGrid(){
	var toobar=[{
        text: '保存',
        iconCls: 'icon-add',
        handler: function() { AddClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() { DeleteClickHandle();}
    }];
	var LocColumns=[[ 
		{ field: 'TSSGroup', title: '安全组', width: 100, sortable: true},
		{ field: 'TForceReturn', title: '强制退号权限', width: 100, sortable: true},
		{ field: 'TGroupID', title: 'ID', width: 10, sortable: true,hidden:true}
	]];
	var DHCOPForceCancelRegDataGrid=$('#DHCOPForceCancelRegTab').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"TGroupID",
		pageSize : 20,
		pageList : [20,50,100],
		columns :LocColumns,
		toolbar :toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_DHCOPForceCancelRegDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_DHCOPForceCancelRegDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_DHCOPForceCancelRegDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	});
	return DHCOPForceCancelRegDataGrid;	
}

function SetSelRowData(row){
	$("#GroupRowId").val(row["TGroupID"])
	$("#SSUserGroup").val(row["TSSGroup"])
	var ForceReturnFlag=row["TForceReturn"]
	var o=$HUI.checkbox("#ForceReturn");
	if (ForceReturnFlag=="是"){
		o.setValue(true);
	}else{
		o.setValue(false);
	}
}

function ClearData(){
	$("#GroupRowId").val("")
	$("#SSUserGroup").val("")
	
	var o=$HUI.checkbox("#ForceReturn");
	o.setValue(false);
}

function AddClickHandle(){
	var GroupDesc=document.getElementById('SSUserGroup').value;
    GroupDesc=cTrim(GroupDesc,0)
    if (GroupDesc=="") {
		$.messager.alert("提示","安全组不能为空！");
		return;
		}
	var RowID=document.getElementById('GroupRowId').value;	
	RowID=cTrim(RowID,0)
	if(RowID=="")
	{
		$.messager.alert("提示","安全组不能为空！");
		return;
	}
   
    if(eval(DHCWebD_GetObjValue("ForceReturn"))){
	    myForceReturn = "Y";
   	}else{
	    myForceReturn = "N";
	}
	var InString=RowID+"^"+myForceReturn;
	
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"SaveForceRetGro",
		InStr:InString, 
		dataType:"text",
	},function(rtn){
		if (rtn==0){
			$.messager.show({title:"提示",msg:"保存成功"});
			PageLogicObj.m_DHCOPForceCancelRegDataGrid.datagrid('uncheckAll');
			ClearData();
			DHCOPForceCancelRegDataGridLoad();
		}else{
			var msg="";
			msg=rtn
			$.messager.alert("提示","保存失败!"+msg,"error");
		}
	});	
}

//去除数组中的空值
function trimSpace(array){
	 for(var i = 0 ;i<array.length;i++)
	 {
         if(array[i] == "" || typeof(array[i]) == "undefined")
         {
                  array.splice(i,1);
                  i= i-1;
         }
	 }
	 return array;
}

function DeleteClickHandle(){
	var Rowid="";
	var row=PageLogicObj.m_DHCOPForceCancelRegDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的记录!","info");
		return false;
	}
	Rowid=row.TGroupID;	
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"DeleteForceRetGro",
		InStr:Rowid,
	},function(rtn){
		if (rtn==0){
			$.messager.show({title:"提示",msg:"删除成功"});
			PageLogicObj.m_DHCOPForceCancelRegDataGrid.datagrid('uncheckAll');
			ClearData();
			DHCOPForceCancelRegDataGridLoad();
		}else{
			$.messager.alert("提示","删除失败!错误代码:"+rtn,"error");
			return false;
		}
	});		
}

function DHCOPForceCancelRegDataGridLoad()
{ 
	var GroupRowId=DHCWebD_GetObjValue("GroupRowId");	
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		QueryName:"GetForceRetGroup",
		'GroupID':GroupRowId,
		'HospRowId':ServerObj.HospID,
		Pagerows:PageLogicObj.m_DHCOPForceCancelRegDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_DHCOPForceCancelRegDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
};

function InitGroup(){
	$("#SSUserGroup").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'GroupRowID',
        textField:'GroupDesc',
        columns:[[  
            {field:'GroupRowID',title:'GroupRowID'},
			{field:'GroupDesc',title:'名称',width:300}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCOPRegConfig',QueryName: 'GetGroupAll',HospID:ServerObj.HospID},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{Desc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					$("#GroupRowId").val(rec["GroupRowID"])
					$("#SSUserGroup").blur();
				}
			});
		}
    });
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        //e.preventDefault(); 
        return false;  
    }  
}
function CheckComboxSelData(id,selId){
	var Find=0;
	var Data=$("#"+id).combobox('getData');
	for(var i=0;i<Data.length;i++){
		if ((id=="AppLoc")||(id=="RegLoc")){
			var CombValue=Data[i].CTCode;
			var CombDesc=Data[i].CTDesc;
			if(selId==CombValue){
				selId=CombValue;
				Find=1;
				break;
			}
		}else if (id=="AppMark"){
			var CombValue=Data[i].value  
			var CombDesc=Data[i].desc
			if((','+selId.join(",")+",").indexOf(","+CombValue+",")>-1){
				//selId=CombValue;
				Find=1;
				break;
			}
		}

	}
	if (Find=="1") return selId
	return "";
}

function cTrim(sInputString,iType)
{
  var sTmpStr = ' '
  var i = -1

  if(iType == 0 || iType == 1)
  {
     while(sTmpStr == ' ')
     {
       ++i
       sTmpStr = sInputString.substr(i,1)
     }
     sInputString = sInputString.substring(i)
  }

  if(iType == 0 || iType == 2)
  {
    sTmpStr = ' '
    i = sInputString.length
    while(sTmpStr == ' ')
    {
       --i
       sTmpStr = sInputString.substr(i,1)
    }
    sInputString = sInputString.substring(0,i+1)
  }
  return sInputString
}