
//名称	dhcpe/ct/inpatienttohp.recloc.hisui.js
//功能	会诊费接收科室设置 -多院区
//创建	2021.08.11
//创建人  sxt
var lastIndex = "";
var EditIndex = -1;
var tableName = "DHC_PE_OthPatToHPBase";
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	GetLocComp(SessionStr);
	
	InitCombobox();
	
	InitIPToHPRecLocDataGrid();
    
    //清屏
    $("#BClear").click(function() {	
		BClear_click();		
        }); 
    
    //接收科室
	$("#BSaveRecLoc").click(function() {	
		BSaveRecLoc_click();		
        });
        
	$("#LocList").combobox({
		onSelect: function(rowData)
		{
			$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
			curLoc:$("#LocList").combobox('getValue')
		});	
		}
		
	})
   
   
})

//清屏
function BClear_click(){
	$("#ID,#HPBID,#StationDesc").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$(".hisui-combogrid").combogrid('setValue',"");
	$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
			curLoc: $("#LocList").combobox("getValue")
			
	});	
}

//接收科室
function BSaveRecLoc_click()
{
	var LocID=$("#LocList").combobox('getValue'); //session['LOGON.CTLOCID'];
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

	var StationHPBID=$("#HPBID").val();
	
	var EmpowerFlag="N";
	if($("#Empower").checkbox('getValue')) EmpowerFlag="Y";
	
	var ActiveFlag="N";
	if($("#Active").checkbox('getValue')) ActiveFlag="Y";
	
	var ret=tkMakeServerCall("web.DHCPE.CT.OtherPatientToHPBaseSet","SetStationConRecLoc",LocID,StationID,RecLocID,StationHPBID,DefaultDocID,ActiveFlag);
	
	var arr=ret.split("^");
	if(arr[0]!="-1"){
	$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
			curLoc:$("#LocList").combobox('getValue')
		});
		$.messager.popover({msg: '接收科室设置成功',type:'success',timeout: 1000});
	}else{
		$.messager.alert("提示",+arr[1],"error");	
	}
}
 
 
function InitCombobox()
{
	  
	 //默认医生
	 var OPNameObj = $HUI.combogrid("#DefaultDoc",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号 
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'姓名',width:200},
			{field:'Initials',title:'工号',width:190} 
				
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
			param.hospId = session['LOGON.HOSPID'];
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
	//alert(212)
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
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
			curLoc:session['LOGON.CTLOCID']
		},
		columns:[[
	
		    {field:'StationID',title:'StationID',hidden: true},
			{field:'ReclocID',title:'StationID',hidden: true},
		    {field:'UserID',title:'StationID',hidden: true},
			{field:'StationDesc',width:'300',title:'站点名称'},
			{field:'RecLocDesc',width:'400',title:'接收科室'},
			{field:'DefaultDoc',width:'300',title:'默认医生'},
			{field:'TActiveFlag',width:'150',title:'是否有效',align:'center',
				formatter: function (value, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                  }
			}	
		
		]],
		onSelect: function (rowIndex, rowData) {
			    //debugger; 
			    //alert(2)
				$("#ID").val(rowData.StationID);
				//$("#RecLocID").val(rowData.ReclocID);
				$("#StationDesc").val(rowData.StationDesc);
				$("#RecLocDesc").combogrid("grid").datagrid("reload",{"q":rowData.RecLocDesc});
				$("#RecLocDesc").combogrid('setValue',rowData.ReclocID);
				$("#DefaultDoc").combogrid("grid").datagrid("reload",{"q":rowData.DefaultDoc});
				$("#DefaultDoc").combogrid('setValue',rowData.UserID);
				//$("#GenConUser").combogrid('setValue',rowData.GenConUserDesc); 
				
				$("#HPBID").val(rowData.HPBID); //科室会诊费
				if(rowData.TActiveFlag=="Y"){
					$("#Active").checkbox('setValue',true);
				}
				else{
					$("#Active").checkbox('setValue',false);
					}
					
		}
		
			
	})

}


