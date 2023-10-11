
//名称	DHCPERoomPlace.hisui.js
//功能	诊室位置维护
//创建	2019.07.31
//创建人  xy
$(function(){
		
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
    
     
    
})

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
	 var CurLoc=session['LOGON.CTLOCID'];
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
    var flags=tkMakeServerCall("web.DHCPE.RoomManagerEx","IsExistRoomPlace",Code,Desc,CurLoc)
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
	
	var iNoPrintBlood=0;
	var NoPrintBlood=$("#NoPrintBlood").checkbox('getValue');
	if(NoPrintBlood){iNoPrintBlood="1";}
	
	
    var rtn=tkMakeServerCall("web.DHCPE.RoomManagerEx","SaveRoomPlace",ID,Str,iNoPrintBlood);
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
	$(".hisui-checkbox").checkbox('setValue',false);
	$(".hisui-combobox").combobox('setValue','');
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	$("#RoomPlaceGrid").datagrid('load',{
			ClassName:"web.DHCPE.RoomManagerEx",
			QueryName:"RoomPlace",
		});	
}

function InitCombobox(){
	
	
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
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
			ClassName:"web.DHCPE.RoomManagerEx",
			QueryName:"RoomPlace",
		},
		columns:[[
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:150,title:'代码'},
			{field:'TDesc',width:300,title:'描述'},
			{field:'TVIPLevelID',title:'ID',hidden: true},
			{field:'TVIPLevelDesc',width:100,title:'VIP等级'},
			{field:'TGIType',title:'TGIType',hidden: true},
			{field:'TGITypeDesc',width:80,title:'是否团体'},
			{field:'TNoPrintBlood',width:200,align:'center',title:'前台不打印采血条码',
				formatter: function (value, rec, rowIndex) {
					
						if(value=="1"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#RowId").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#VIPLevel").combobox('setValue',rowData.TVIPLevelID);
				$("#GIType").combobox('setValue',rowData.TGIType);
				if(rowData.TNoPrintBlood=="1"){
					$("#NoPrintBlood").checkbox('setValue',true);
				}else{
					$("#NoPrintBlood").checkbox('setValue',false);
				}			
						
			
								
					
		}

			
	})
}
