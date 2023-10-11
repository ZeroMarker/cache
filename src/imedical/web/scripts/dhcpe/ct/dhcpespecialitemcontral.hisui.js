
//名称	dhcpe/ct/dhcpespecialitemcontral.hisui.js
//功能	体检特殊项目权限管理
//创建	2021.11.04
//创建人  xueying

var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_SpecialContral";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	GetLocComp(SessionStr)
	
	InitCombobox();
	
	//初始化Grid
	InitSpecItemContDataGrid();
    
    //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
        
     //修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        }); 
         
    //删除
	$("#BDelete").click(function() {	
		Delete_Click();		
        });
        
    //保存
	$("#BSave").click(function() {	
		BSave_Click();		
        });
        
    //清屏
    $("#BClear").click(function() {	
		BClear_Click();		
        });
        
      
     //科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
	       
	        	var LocID=$("#LocList").combobox('getValue');
		   		if(LocID==undefined) LocID=session['LOGON.CTLOCID'];
		   		var hospId=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		   		
			    
			    
			    /*****************用户重新加载(combobox)*****************/
			    //$('#UserName').combogrid('grid').datagrid('reload'); //重加载
			    $HUI.combogrid("#UserName",{
					onBeforeLoad:function(param){
							param.Desc = param.q;
							param.Type="B";
							param.LocID=LocID;
							param.hospId=hospId;

					}
		       });
		    
	           $('#UserName').combogrid('grid').datagrid('reload'); 
			   /*****************用户重新加载(combobox)*****************/
			    
			   /*****************特殊项目重新加载(combobox)*****************/
		   	    var url= $URL+"?ClassName=web.DHCPE.CT.SpecialItemContral&QueryName=SearchSpecialItem&ResultSetType=array&LocID="+LocID;
			    $('#SpecialItem').combobox('reload',url);
			    /*****************特殊项目重新加载(combobox)*****************/
			    
		   		$("#SpecialItemContralTab").datagrid('load',{
					ClassName:"web.DHCPE.CT.SpecialItemContral",
					QueryName:"SearchSpecialItemContral",
					LocID:LocID
				});
			
		}
	})
	  
   })
   



//清屏
function BClear_Click(){
	
	$('#LocList').combobox('setValue',session['LOGON.CTLOCID']);
	
	$("#UserName").combogrid('enable');	
	$("#UserName").combogrid('setValue',"");
		
	$('#SpecialItem').combobox('setValue',"");
	
	$('#ID').val("");
	$("#UserID").val("");
	
	$("#SpecialItemContralTab").datagrid('load',{
		ClassName:"web.DHCPE.CT.SpecialItemContral",
		QueryName:"SearchSpecialItemContral",
		LocID:$("#LocList").combobox("getValue")
	});
}

//修改
function BUpdate_click(){
	Save(1);
}

//新增
function BAdd_click()
{
	Save(0);
}

function Save(Type){
	
	var ID=$("#ID").val();
	
	if(Type=="1")
	{
		if(ID==""){
			$.messager.alert("提示","请选择待修改的数据","info");
			return false;
		}	
	}else{
		if(ID!=""){
			
			$.messager.alert("提示","新增数据不能选中记录,需先清屏再新增","info");
			return false;
		}
		
	}
	//用户
	var UserID=$("#UserName").combogrid('getValue')
	 if (($("#UserName").combogrid('getValue')==undefined)||($("#UserName").combogrid('getValue')=="")){var UserID="";}
   
	if (UserID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",UserID);
			if(ret=="0"){
				$.messager.alert("提示","请选择用户","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#UserName", {
				required: true,
	    	});
			$.messager.alert("提示","用户不能为空","info");
			return false;
	}
	
	 //科室
	 var LocID=$("#LocList").combobox("getValue");
	 
	 var ExsistFlag=tkMakeServerCall("web.DHCPE.CT.SpecialItemContral","IsExsistSpeItemContral",UserID,LocID)
	 if((ExsistFlag=="1")&&(ID=="")){
		 $.messager.alert("提示","该用户已经维护特殊项目，无需新增，请修改！","info");
			return false;
	 }
	 

	 //操作人员
	 var SessionUser=session['LOGON.USERID'];
	 
	 //特殊项目
    var SpecialItem=$("#SpecialItem").combobox("getValues");
    if(SpecialItem==""){
	    	$.messager.alert("提示","特殊项目不能为空","info");
			return false;
    }
    
    var SpecialItemStr=SpecialItem.join("^");
     //alert(SpecialItemStr)
	var ret=tkMakeServerCall("web.DHCPE.CT.SpecialItemContral","SaveSpecialItemContral",UserID,LocID,SpecialItemStr,SessionUser);
	var retone=ret.split("^");
	if(retone[0]=="0"){
		$.messager.popover({msg: retone[1],type:'success',timeout: 1000});
		BClear_Click();
	}else{
		$.messager.alert("提示",retone[1],"error")	
	}

	
}

//删除
function Delete_Click()
 {
    var SessionUserID=session['LOGON.USERID'];
	var ID=$("#ID").val();
	if (""==ID) {
		$.messager.alert("提示","请先选择待删除的记录","info");	
		return false;
	 }
	var UserID=$("#UserID").val();
    var LocID=$("#LocList").combobox("getValue");
	var ret="";
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.CT.SpecialItemContral", MethodName:"DelSpecialItemContral",UserID:UserID,LocID:LocID,SessionUserID:SessionUserID},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("提示",ReturnValue.split("^")[1],"error");  
				}else{
					$.messager.popover({msg: ReturnValue.split("^")[1],type:'success',timeout: 1000});
					BClear_Click();	
     
				}
			});	
		}
	});
	
	
 }

 
 
function InitCombobox()
{
  
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	  
	//特殊项目
    var SpecialItemObj = $HUI.combobox("#SpecialItem",{
        url:$URL+"?ClassName=web.DHCPE.CT.SpecialItemContral&QueryName=SearchSpecialItem&ResultSetType=array&LocID="+LocID,
        valueField:'id',
        rowStyle:'checkbox',
        textField:'desc',
        multiple:true,
        selectOnNavigation:false,
        panelHeight:300,
        editable:false
    });
	
    //操作员
	var OPNameObj = $HUI.combogrid("#UserName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXTNew",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 20,
		pageList: [20,50,100],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=LocID;
			param.hospId=hospId;

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'姓名',width:200},
			{field:'Initials',title:'工号',width:190}	
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		},

		});	 
		
	
	
	
} 

function InitSpecItemContDataGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$HUI.datagrid("#SpecialItemContralTab",{
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
			ClassName:"web.DHCPE.CT.SpecialItemContral",
			QueryName:"SearchSpecialItemContral",
			LocID:LocID
		},
		columns:[[
	        {field:'ID',hidden: true},
		    {field:'UserID',hidden: true},
		    {field:'ItemIDStr',hidden: true},
			{field:'UserCode',width:'150',title:'工号'},
			{field:'UserName',width:'150',title:'医生'},
			{field:'ArcDescStr',width:'900',title:'特殊项目'}
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			  $("#ID").val(rowData.ID);
			  $("#UserID").val(rowData.UserID);
			  var UserName=rowData.UserName;
			  $('#UserName').combogrid('grid').datagrid('reload',{'q':UserName});
			  $("#UserName").combogrid('setValue',rowData.UserID);
			  $("#UserName").combogrid('disable');
			  GetSpecialItem(rowData.ItemIDStr);
			
		}
		
			
	})

}


function GetSpecialItem(ItemIDStr){
	
	//检查站点
    var str=ItemIDStr.split("^")
    var retarray=new Array();
    for(var i=0;i<str.length;i++)
    {
        retarray.push(str[i]);
        //var checkid=str[i];
        var checkid=str[i].split("||")[0];
        $("#"+checkid).attr("checked",true);
    }
    
    $("#SpecialItem").combobox("setValues",retarray);
}


