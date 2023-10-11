//名称	dhcpe/ct/dhcperoomspecimen.hisui.js
//功能	诊室标本维护
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

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']



$(function(){
		
	//GetLocComp(SessionStr);
	
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
	
	var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","DeleteSpecimen",ID,RoomType);
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert('提示',"删除失败"+rtn.split("^")[1],"error");
	}else{
		$.messager.alert('提示',"删除成功","success");
		BClear_click();
	}
}

//清屏
function BClear_click(){
		$("#RowId,#IP").val("");
		$("#Specimen").combobox('setValue',"");
		$("#RoomSpecimenGrid").datagrid('load',{
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
	}
	
    var Parref=selectrow;
  	if (Parref==Specimen){
		$.messager.alert("提示","当前诊室和设置诊室不能相同","info");
		return false;
	}
    var Str=Parref+"^"+Specimen;
    //alert(Str)
    
    //var LocID=$("#LocList").combobox('getValue');
	//var UserID=session['LOGON.USERID'];
    
	var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","UpdateSpecimen",ID,Str,RoomType);
	//debugger; // rtn
	if (rtn.split("^")[0]=="-1"){
		if(Type=="1"){$.messager.alert('提示',"更新失败:"+rtn.split("^")[1],"error");}
		if(Type=="0"){$.messager.alert('提示',"新增失败:"+rtn.split("^")[1],"error");}
		
	}else{
		if(Type=="1"){$.messager.alert('提示',"更新成功","success");}
		if(Type=="0"){$.messager.alert('提示',"新增成功","success");}
		BClear_click();
		
	}

}

var columns =[[
			{field:'TID',title:'ID',hidden: true},
		    {field:'TSpecimenDR',title:'SpecimenDR',hidden: true},
			{field:'TSpecimen',width:640,title:title},
						 
		]];
		
function InitRoomSpecimenGrid(){
	
	$HUI.datagrid("#RoomSpecimenGrid",{
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
				else
				{
				$("#Specimen").combobox('setValue',rowData.TSpecimenDR);
				}
								
		}
		
			
	})
}


function InitCombobox(){
   
	if(RoomType=="SP"){
		//标本类型
		var SpecimenObj = $HUI.combobox("#Specimen",{
			url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=GetSpecimen&ResultSetType=array&LocID="+DefLoc,
			valueField:'id',
			textField:'desc'
			})
	}else if(RoomType=="RP"){
		//诊室位置
		//debugger; //	
		//alert(DefLoc)
		
		var SpecimenObj = $HUI.combobox("#Specimen",{
			url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=GetRoomPlace&ResultSetType=array&LocID="+DefLoc,
			valueField:'id',
			textField:'desc'
			})
	}else if(RoomType=="SR"){
		//前面诊室
		var SpecimenObj = $HUI.combobox("#Specimen",{
			url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=GetRoom&ResultSetType=array",
			valueField:'id',
			textField:'desc'
			})
	}
			
}