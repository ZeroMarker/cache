
//名称	DHCPEInPatientToHP.RecLoc.hisui.js
//功能	会诊费接收科室设置
//创建	2019.05.06
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitIPToHPRecLocDataGrid();
      
    //会诊费人员
	$("#BSaveGenConUser").click(function() {	
		BSaveGenConUser_click();		
        });
    
    //接收科室
	$("#BSaveRecLoc").click(function() {	
		BSaveRecLoc_click();		
        });
        
   
})

//会诊费人员
function BSaveGenConUser_click()
{
	var LocID=session['LOGON.CTLOCID'];
	var UserID=$("#GenConUser").combogrid('getValue');
	if (($("#GenConUser").combogrid('getValue')==undefined)||($("#GenConUser").combogrid('getValue')=="")){var UserID="";}
	var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(UserID)))&&(UserID!="")){var UserID=$("#GenConUserID").val();}

	if ( UserID==""){
		//$.messager.alert("提示","请选择总检会诊费人员","info");
		//return false;
	}
	var ret=tkMakeServerCall("web.DHCPE.OtherPatientToHPBaseSet","SetGenConUser",LocID,UserID);
	$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
		});
		$.messager.alert("提示","总检会诊费人员设置成功","success");
	
	
}

//接收科室
function BSaveRecLoc_click()
{
	
	
	var LocID=session['LOGON.CTLOCID'];
	var StationID=$("#ID").val();
	if (StationID==""){
		$.messager.alert("提示","请选择站点，然后保存数据","info");
		return false;
	}
	var RecLocID=$("#RecLocDesc").combogrid('getValue');
	//alert(RecLocID)
	if (($("#RecLocDesc").combogrid('getValue')==undefined)||($("#RecLocDesc").combogrid('getValue')=="")){var RecLocID="";}

	var DefaultDocID=$("#DefaultDoc").combogrid('getValue');
	if (($("#DefaultDoc").combogrid('getValue')==undefined)||($("#DefaultDoc").combogrid('getValue')=="")){var DefaultDocID="";}
      
     var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(RecLocID)))&&(RecLocID!="")){var RecLocID=$("#RecLocID").val();}
    if((!(reg.test(DefaultDocID)))&&(DefaultDocID!="")){var DefaultDocID=$("#DefaultDocID").val();}
	//alert(RecLocID+"^"+DefaultDocID)


	var ret=tkMakeServerCall("web.DHCPE.OtherPatientToHPBaseSet","SetStationConRecLoc",LocID,StationID,RecLocID+"^"+DefaultDocID);
	$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
		});
		$.messager.alert("提示","接收科室设置成功","success");	
}
 
 


function InitCombobox()
{
	  //默认总检会诊费
	   var OPNameObj = $HUI.combogrid("#GenConUser",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
		    {field:'Initials',title:'工号',width:200},
			{field:'DocName',title:'姓名',width:200},	
				
		]]
		});
		
		 //默认医生
	   var OPNameObj = $HUI.combogrid("#DefaultDoc",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
		    {field:'Initials',title:'工号',width:200},
			{field:'DocName',title:'姓名',width:200},
				
		]]
		});
		 //接收科室
	   var OPNameObj = $HUI.combogrid("#RecLocDesc",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc= param.q;
		},
		columns:[[
		    {field:'CTLOCID',title:'ID',width:40},
		    {field:'Desc',title:'名称',width:200},
			{field:'CTLOCCODE',title:'编码',width:200},
				
		]]
		});
		
}

function InitIPToHPRecLocDataGrid()
{
	$HUI.datagrid("#IPToHPRecLocQueryTab",{
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
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
		},
		columns:[[
	
		    {field:'StationID',title:'StationID',hidden: true},
			{field:'ReclocID',title:'StationID',hidden: true},
		    {field:'UserID',title:'StationID',hidden: true},
			{field:'StationDesc',width:'250',title:'站点名称'},
			{field:'RecLocDesc',width:'250',title:'接收科室'},
			{field:'DefaultDoc',width:'250',title:'默认医生'},
			{field:'GenConUserDesc',width:'250',title:'总检会诊费人员'},
			
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ID").val(rowData.StationID);
				$("#DefaultDocID").val(rowData.ReclocID);
				$("#RecLocID").val(rowData.UserID);
				$("#StationDesc").val(rowData.StationDesc);
				$("#RecLocDesc").combogrid('setValue',rowData.RecLocDesc);
				$("#DefaultDoc").combogrid('setValue',rowData.DefaultDoc);
				$("#GenConUser").combogrid('setValue',rowData.GenConUserDesc); 
				$("#GenConUserID").val(rowData.GenConUserID);

					
		}
		
			
	})

}


