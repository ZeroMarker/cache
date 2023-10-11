//名称	dhcpe/ct/dhcperoomitem.hisui.js
//功能	诊室项目维护
//创建	2021.08.07
//创建人  sxt

var lastIndex = "";
var EditIndex = -1;

var tableName = "DHC_PE_Area";
var RoomtableName = "DHC_PE_Room";
var RoomIPtableName = "DHC_PE_RoomIP";
var roomSpecialRoomtableName = "DHC_PE_RoomSpecialRoom";
var RoomRoomPlaceptableName = "DHCPERoomRoomPlace";
var RoomSpecimentableName = "DHC_PE_RoomSpecimen";
var RoomPlaceptableName = "DHC_PE_RoomSpecimen";  /// 新增诊室位置字典表
var RoomItemtableName = "DHC_PE_RoomItem";  /// 新增诊室项目字典表

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		

	
	InitCombobox();
	
	Init();
	 
	InitRoomSpecimenGrid();

     //清屏
    $('#BClear').click(function(e){
    	BClear_click();
    });
     
    //新增
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //修改
    $('#update_btn').click(function(e){
    	UpdData();
    });
    
    //删除
    $('#del_btn ').click(function(){
    	DelData();
    });
    
  
})


function Init(){
	
	
	if (RoomType=="IP"){
		$("#Specimen").next(".combo").hide();//combobox隐藏
		$("#CSpecimen").css('display','none');
		
	}else if(RoomType=="RP")
	{
		$("#IP").css('display','none');
		$("#CIP").css('display','none');
		if(RoomType=="RP") {document.getElementById('CSpecimen').innerHTML="诊室位置";}
	}else{
		$("#IP").css('display','none');
		$("#CIP").css('display','none');
		if(RoomType=="SR") {document.getElementById('CSpecimen').innerHTML="前面诊室";}
	}
	
}

//删除
function DelData(){

	if (RoomType=="SP"){
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
	}else{
		var Specimen=$("#IP").val();
	}
	
	var ID=$("#RowId").val();
	if (ID=="")
	{
		$.messager.alert("提示","请选择待删除记录","info");
		return false;
	}
	
	$.messager.confirm("确认", "确定要删除吗？", function(r){
    	if(r){ 
    		
			var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","DeleteSpecimen",ID,RoomType);
			if (rtn.split("^")[0]=="-1"){
				$.messager.alert('提示',"删除失败"+rtn.split("^")[1],"error");
			}else{
				$.messager.popover({msg: '删除成功',type:'success',timeout: 1000});
				BClear_click();
			}
          }
	})
}

//清屏
function BClear_click(){
		$("#RowId,#IP,#ItemTime").val("");
		$("#ItemDesc").combogrid('setValue',"");
		$("#RoomItemGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.RoomManager",
			QueryName:"FindRoomSpecimen",
			Parref:selectrow, 
			Type:RoomType,
			LocID:DefLoc
		});	
	
}
//新增
function AddData(){
	Update("0");
}


//更新
function UpdData(){
	Update("1");
}

function Update(Type){
	var ID=$("#RowId").val();
	if(Type=="1"){
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	debugger; //2
	var TableName="";
	if(Type=="0"){
	    if(ID!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
	}
    if (RoomType=="IP"){
	    TableName=RoomIPtableName;
		var Specimen=$("#IP").val();
		if(Specimen==""){
			$.messager.alert("提示","电脑IP不能为空","info");
			return false;
		}
		
	}else if(RoomType=="SP")
	{
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
  		/*
  		var roomSpecialRoomtableName = "DHC_PE_RoomSpecialRoom";
		var RoomRoomPlaceptableName = "DHCPERoomRoomPlace";
		var RoomSpecimentableName = "DHC_PE_RoomSpecimen";
		*/
  		TableName=RoomSpecimentableName;
		if(Specimen==""){
			$.messager.alert("提示","标本类型不能为空","info");
			return false;
		}
	}else if(RoomType=="RP")
	{
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
  		TableName=RoomRoomPlaceptableName;
  		
		if(Specimen==""){
			$.messager.alert("提示","诊室位置不能为空","info");
			return false;
		}
	}else if(RoomType=="SR")
	{
		TableName=roomSpecialRoomtableName;
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
		if(Specimen==""){
			$.messager.alert("提示","前面诊室不能为空","info");
			return false;
		}
	}else if(RoomType=="RI")
	{
		TableName=RoomItemtableName;
		var Item=$("#ItemDesc").combobox('getValue');
  		if (($("#ItemDesc").combobox('getValue')==undefined)||($("#ItemDesc").combobox('getValue')=="")){var Item="";}
		if(Item==""){
			$.messager.alert("提示","诊室项目不能为空","info");
			return false;
		}
	}
	
    var Parref=selectrow;
  	var Time=$("#ItemTime").val();
    var Str=Parref+"^"+Item+"^"+Time;
   
    
	var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","UpdateSpecimen",ID,Str,RoomType);
	
	if (rtn.split("^")[0]=="-1"){
		if(Type=="1"){$.messager.alert('提示',"更新失败:"+rtn.split("^")[1],"error");}
		if(Type=="0"){$.messager.alert('提示',"新增失败:"+rtn.split("^")[1],"error");}
		
	}else{
		if(Type=="1"){$.messager.popover({msg: '更新成功',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '新增成功',type:'success',timeout: 1000});}
		BClear_click();
		
	}

}

var columns =[[
			{field:'TID',title:'ID',hidden: true},
		    {field:'TSpecimenDR',title:'SpecimenDR',hidden: true},
			{field:'TSpecimen',width:300,title:title},
			{field:'TExInfo',width:100,title:"时间"},
						 
		]];
		
function InitRoomSpecimenGrid(){
	
	$HUI.datagrid("#RoomItemGrid",{
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
			ClassName:"web.DHCPE.CT.RoomManager",
			QueryName:"FindRoomSpecimen",
			Parref:selectrow, 
			Type:RoomType,
			LocID:DefLoc
		    
		},
		columns:columns,
		onSelect: function (rowIndex, rowData) {
			 
				$("#RowId").val(rowData.TID);
				if(RoomType=="IP"){
					
				$("#IP").val(rowData.TSpecimenDR);
				}
				else if(RoomType=="RI"){
					
					$("#ItemDesc").combogrid('setValue',rowData.TSpecimenDR);
					$("#Specimen").combogrid('setText',rowData.TSpecimen);
					$("#ItemTime").val(rowData.TExInfo);
					}
				else
				{
				$("#Specimen").combobox('setValue',rowData.TSpecimenDR);
				}
								
		}
		
			
	})
}


function InitCombobox(){
   
   
    var LocID=session['LOGON.CTLOCID']
	
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	 
	 
	//医嘱名称
	var ArcItemObj = $HUI.combogrid("#ItemDesc",{
		panelWidth:500,
		url:$URL+"?ClassName=web.DHCPE.CT.StationOrder&QueryName=FindLocAllOrder",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'TARCIMDR',
		textField:'TARCIMDesc',
		onBeforeLoad:function(param){
	  			
				param.ARCIMDesc= param.q;
				param.Type="B";
				param.LocID=LocID;
				param.hospId =hospId;
				param.tableName="DHC_PE_StationOrder"

		},
		columns:[[
		    {field:'TOrderID',title:'OrderID',hidden: true},
		    {field:'TARCIMDR',title:'ID',width:100},
			{field:'TARCIMDesc',title:'医嘱名称',width:200},
			{field:'TARCIMCode',title:'医嘱编码',width:150},
			
				
		]]
	});
   
	
			
}