
//名称	dhcperoomplace.hisui.js
//功能	诊室位置维护
//创建	2021.08.08
//创建人  sxt
var RoomPlaceptableName = "DHC_PE_RoomPlace";  /// 新增诊室位置字典表
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	GetLocComp(SessionStr);
	
	InitCombobox();
	  
    InitRoomPlaceGrid();
    
         
     //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
    
      //修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
    // 查询
	$("#BFind").click(function() {	
		BFind_click();		
        }); 
     
    
})

/// 查询
function BFind_click()
{
	$("#RoomPlaceGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.RoomManagerEx",
			QueryName:"RoomPlace",
			CurLoc:$("#LocList").combobox('getValue')
		});
	
	}

  //新增
function BAdd_click(){
	BSave_click("0");
}

  //修改
function BUpdate_click(){
	BSave_click("1");
}
 
 function BSave_click(Type)
 {
	 
	 var CurLoc=$("#LocList").combobox('getValue');
	 
	var UserID=session['LOGON.USERID'];
	 var ID=$("#RowId").val();
	 if(Type=="1"){
		
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if(ID!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
	}
	
	var Code=$("#Code").val();
	if(Code==""){
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("提示","代码不能为空","info");
		return false;
		
	}

	var Desc=$("#Desc").val();
	if(Desc==""){
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("提示","描述不能为空","info");
		return false;
		
	}
if(Type=="0"){
    var flags=tkMakeServerCall("web.DHCPE.CT.RoomManagerEx","IsExistRoomPlace",Code,Desc,CurLoc)
    if(flags.split("^")[0]=="1"){
	    $.messager.alert("提示","描述不能重复","info");
		return false;
    }
    if(flags.split("^")[1]=="1"){
	    $.messager.alert("提示","代码不能重复","info");
		return false;
    }
    
  }

	var PEType=$("#VIPLevel").combobox('getValue');
	var GIType=$("#GIType").combobox('getValue');
	var Str=Code+"^"+Desc+"^"+PEType+"^"+GIType;
	
	var iNoPrintBlood="N";
	var NoPrintBlood=$("#NoPrintBlood").checkbox('getValue');
	if(NoPrintBlood){iNoPrintBlood="Y";}
	
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active){iActive="Y";}
	
	
    var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManagerEx","SaveRoomPlace",ID,Str,iNoPrintBlood,iActive,CurLoc,UserID);
	debugger; // 
	if (rtn.split("^")[0]=="-1"){
		if(Type=="1"){$.messager.alert("提示","修改失败"+Arr[1],"error");}
		if(Type=="0"){$.messager.alert("提示","新增失败"+Arr[1],"error");}	
	}else{
		BClear_click();
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}	
	}
 }
 
 
 //清屏
function BClear_click(){
	$("#RowId,#Code,#Desc").val("");
	var OldLoc=$("#LocList").combobox('getValue')
	$(".hisui-checkbox").checkbox('setValue',false);
	$(".hisui-combobox").combobox('setValue','');
	$("#LocList").combobox('setValue',OldLoc);
	debugger;
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	$("#RoomPlaceGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.RoomManagerEx",
			QueryName:"RoomPlace",
			CurLoc:OldLoc
			
		});	
}

function InitCombobox(){
	
	
	$("#LocList").combobox({
		onSelect: function(rowData)
		{
			$("#RoomPlaceGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.RoomManagerEx",
			QueryName:"RoomPlace",
			CurLoc:$("#LocList").combobox('getValue')
		});	
		},
		onLoadSuccess: function(){
			$("#LocList").combobox('select',session['LOGON.CTLOCID']);
			$("#RoomPlaceGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.RoomManagerEx",
			QueryName:"RoomPlace",
			CurLoc:session['LOGON.CTLOCID']
		});	
			
			}
		
	})
	
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		});
		
	//是否团体
	var DietObj = $HUI.combobox("#GIType",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'N',text:'不限'},
            {id:'I',text:'个人'},
            {id:'G',text:'团体'},
           
        ]

	});
}


function InitRoomPlaceGrid(){
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

	$HUI.datagrid("#RoomPlaceGrid",{
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
			ClassName:"web.DHCPE.CT.RoomManagerEx",
			QueryName:"RoomPlace",
			CurLoc:LocID
		},
		columns:[[
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:150,title:'代码'},
			{field:'TDesc',width:250,title:'描述'},
			{field:'TVIPLevelID',title:'ID',hidden: true},
			{field:'TVIPLevelDesc',width:120,title:'VIP等级'},
			{field:'TGIType',title:'TGIType',hidden: true},
			{field:'TGITypeDesc',width:100,title:'是否团体'},
			{field:'TNoPrintBlood',width:140,align:'center',title:'前台不打印采血条码',
				formatter: function (value, rec, rowIndex) {
					
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			{field:'TActive',align:'center',title:'激活',
				formatter: function (value, rec, rowIndex) {
					
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			}
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#RowId").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#VIPLevel").combobox('setValue',rowData.TVIPLevelID);
				$("#GIType").combobox('setValue',rowData.TGIType);
				if(rowData.TNoPrintBlood=="Y"){
					$("#NoPrintBlood").checkbox('setValue',true);
				}else{
					$("#NoPrintBlood").checkbox('setValue',false);
				}
				
				if(rowData.TActive=="Y"){
					$("#Active").checkbox('setValue',true);
				}else{
					$("#Active").checkbox('setValue',false);
				}			
						
			
								
					
		}

			
	})
}
