
/*
 * FileName: dhcpe/ct/odstandardcom.js
 * Author: xy
 * Date: 2021-08-14
 * Description: 细项选择维护
 */
 
var odstableName = "DHC_PE_ODStandard"; //站点细项选择表

var tableName ="DHC_PE_OrderDetail";  //细项表

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	
$(function(){
	
	//获取科室下拉列表
	GetLocComp(SessionStr)
	
	 //科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
	       BFind_click();
	       BODFind_click();
	       $("#StationID,#ODRowID,#ODSDesc,#ODType").val('');
	       BClear_click();
		   $('#ODStandardComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
	    		 
       }
		
	});
	
	
  	InitCombobox();
			
	//初始化 站点Grid 
	InitStationGrid();
	 
	//查询（站点）
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
	$("#Desc").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});
	
	//初始化 细项Grid 
	InitOrderDetailDataGrid();
	
	//查询(细项)
	$("#BODFind").click(function(e){
    	BODFind_click();
    });
    
    
	$("#ODDesc").keydown(function(e) {	
		if(e.keyCode==13){
			BODFind_click();
		}
	});

	
	//初始化 细项选择Grid 
	InitODStandardComDataGrid();
	
	//清屏
    $("#BClear").click(function(e){
    	BClear_click();
    });
	     
    //新增
    $("#BAdd").click(function(e){
    	BAdd_click();
    });
    
    //修改
    $("#BUpdate").click(function(){
    	BUpdate_click();
    });
    
    //查询
    $("#BODSFind").click(function(){
    	BODSFind_click();
    });
    
	 //默认性别为"不限"
	$("#Sex").combobox('setValue',"N"); 
   /*
	$('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			LocID:session['LOGON.CTLOCID']
		});		
	   }			
    }); 
    */
	/*
    //单独授权
     $("#BPower").click(function(){
    	BPower_click();
    });
    */
    
    //授权科室
     $("#BRelateLoc").click(function(){
    	BRelateLoc_click();
    });
    
})



//查询（细项）
 function BODFind_click()
{
	$("#OrderDetailTab").datagrid('load', {
		ClassName:"web.DHCPE.CT.StatOrderDetail",
		QueryName:"FindOrderDetail",
		StationID:$("#StationID").val(),
		Desc:$("#ODDesc").val(),
		LocID:$("#LocList").combobox('getValue'),
		tableName:tableName
		
	});	

}

//初始化 细项Grid 
function InitOrderDetailDataGrid()
{
	
	$HUI.datagrid("#OrderDetailTab",{
		url:$URL,
		fit : true,
		border: false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [],
		queryParams:{
			ClassName:"web.DHCPE.CT.StatOrderDetail",
			QueryName:"FindOrderDetail",
			StationID:$("#StationID").val(),
			Desc:"",
			LocID:session['LOGON.CTLOCID'],
			tableName:tableName
		},
		columns:[[

		    {field:'TODID',title:'ODID',hidden: true},
		    {field:'TODType',title:'ODType',hidden: true},
		    {field:'TStationName',width:150,title:'站点'},
		    {field:'TODDesc',width:150,title:'名称'},
					
		]],
		
		onSelect: function (rowIndex, rowData) {

			  		
			$('#ODStandardComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadODStandardComDatalist(rowData);
					
		}
		
			
	})
}


/**********************细项 end************************************/

/**********************细项选择 start************************************/

//查询（细项选择）
function BODSFind_click(){
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

	$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			LocID:locId
	});	
}

//单独授权/取消授权
function BPower_click(){
	var DateID=$("#ODSRowID").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要单独授权的记录","info"); 
		return false;
	}
	var selected = $('#ODStandardComGrid').datagrid('getSelected');
	if(selected){
	
		//单独授权 
		var iEmpower="N";
		var Empower=$("#Empower").checkbox('getValue');
		if(Empower) iEmpower="Y";
		var LocID=$("#LocList").combobox('getValue');
		var UserID=session['LOGON.USERID'];
	    var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",odstableName,DateID,LocID,UserID,iEmpower)
		var rtnArr=rtn.split("^");
		if(rtnArr[0]=="-1"){
			$.messager.alert("提示","授权失败","error");
		}else{
			$.messager.alert("提示","授权成功","success");
			 $("#ODStandardComGrid").datagrid('reload');
		}		
	}	
}
    

//授权科室
function BRelateLoc_click()
{
	var DateID=$("#ODSRowID").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}
   var LocID=$("#LocList").combobox('getValue');
   //alert("LocID:"+LocID)
    OpenLocWin(odstableName,DateID,SessionStr,LocID,InitODStandardComDataGrid);
}

function LoadODStandardComDatalist(rowData)
{
	$("#ODRowID").val(rowData.TODID);
	$("#ODSDesc").val(rowData.TODDesc);
	$("#ODType").val(rowData.TODTypeDR);
	BClear_click();

	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

	$("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			LocID:locId		
		
	});
		
}




//初始化 细项选择Grid 
function InitODStandardComDataGrid()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

	$HUI.datagrid("#ODStandardComGrid",{
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
		//displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			LocID:locId,	
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N"
		},
		frozenColumns:[[
			{field:'TSort',width:60,title:'顺序号',sortable:true},
			{field:'TTextVal',width:120,title:'文本值'},
			{field:'TNatureValue',width:60,title:'正常值',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TNoActive',width:80,title:'激活',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			}
					
		]],
		columns:[[
		    {field:'ODS_ParRef',title:'ParRef',hidden: true},
		    {field:'ODS_RowId',title:'RowId',hidden: true},
		    {field:'ODS_ChildSub',title:'ChildSub',hidden: true},
		    {field:'TSex',title:'Sex',hidden: true},
		    {field:'TSexDesc',width:60,title:'性别'},
		
			{field:'THDValue',width:60,title:'荒诞值',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TNoPrint',width:60,title:'不打印',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TSummary',width:80,title:'进入小结',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TAgeMin',width:80,title:'年龄下限'},
			{field:'TAgeMax',width:80,title:'年龄上限'},
			{field:'TMin',width:60,title:'下限'},
			{field:'TMax',width:60,title:'上限'},
			{field:'TUnit',width:60,title:'单位'},
			{field:'TEyeSee',width:100,title:'所见'},
			{field:'TDefault',width:80,title:'默认',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			
			
			{field:'TUpdateDate',width:120,title:'更新日期'},	
			{field:'TUpdateTime',width:120,title:'更新时间'},	
			{field:'TUserName',width:120,title:'更新人'}
            /*
			{field:'TEmpower',width:80,title:'是否单独授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       				}
			},{ field:'TEffPowerFlag',width:100,align:'center',title:'当前科室授权',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}
			*/
						
		]],
		onSelect: function (rowIndex, rowData) {
		
			if((rowData.TEmpower=="Y")){		
				$("#BRelateLoc").linkbutton('enable');
				$("#Empower").checkbox('setValue',true);
				//$("#BPower").linkbutton({text:'取消授权'});
			}else{
				if(rowData.TNoActive=="Y")	{
					$("#BRelateLoc").linkbutton('disable');
					//$("#BPower").linkbutton('enable');
					$("#Empower").checkbox('setValue',false);
					//$("#BPower").linkbutton({text:'单独授权'})
					
				}else{
					$("#BRelateLoc").linkbutton('disable');
					//$("#BPower").linkbutton('disable');			
				}
			}
			$("#ODSRowID").val(rowData.ODS_RowId);
			$("#ChildSub").val(rowData.ODS_ChildSub);
			$("#Sex").combobox('setValue',rowData.TSex);
			$("#Sort").val(rowData.TSort);
			if(rowData.TNatureValue=="Y"){
				$("#NatureValue").checkbox('setValue',true);
			}else{
				$("#NatureValue").checkbox('setValue',false);
			}
			if(rowData.TSummary=="Y"){
				$("#Summary").checkbox('setValue',true);
			}else{
				$("#Summary").checkbox('setValue',false);
			}
			if(rowData.THDValue=="Y"){
				$("#HDValue").checkbox('setValue',true);
			}else{
				$("#HDValue").checkbox('setValue',false);
			}
			if(rowData.TNatureValue=="Y"){
				$("#NatureValue").checkbox('setValue',true);
			}else{
				$("#NatureValue").checkbox('setValue',false);
			}
			$("#EyeSee").val(rowData.TEyeSee);
			$("#Unit").val(rowData.TUnit);
			$("#ReferenceMin").val(rowData.TMin);
			$("#ReferenceMax").val(rowData.TMax);
			$("#AgeMin").val(rowData.TAgeMin);
			$("#AgeMax").val(rowData.TAgeMax); 
			$("#TextVal").val(rowData.TTextVal); 
			$("#CurNatureValue").val(rowData.TNatureValue); 
			
			if(rowData.TDefault=="Y"){
				$("#Default").checkbox('setValue',true);
			}else{
				$("#Default").checkbox('setValue',false);
			}
					
			if(rowData.TNoPrint=="Y"){
				$("#NoPrint").checkbox('setValue',true);
			}else{
				$("#NoPrint").checkbox('setValue',false);
			}
			if(rowData.TNoActive=="Y"){
				$("#NoActive").checkbox('setValue',true);
			}else{
				$("#NoActive").checkbox('setValue',false);
			}
				
				
				
				
					
		
		}
		
			
	})
}


function InitCombobox()
{
	//性别
	var SexObj = $HUI.combobox("#Sex",{
		valueField:'id',
		textField:'text',
		panelHeight:'95',
		data:[
            {id:'M',text:$g('男')},
            {id:'F',text:$g('女')},
            {id:'N',text:$g('不限')},
           
        ]

	});
}


 //新增
function BAdd_click()
{
	BSave_click("0");
}

 //修改
function BUpdate_click()
{
	BSave_click("1");
}

function BSave_click(Type)
{
	if(Type=="1"){
		var ID=$("#ODSRowID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
		if($("#ODRowID").val()==""){
		    	$.messager.alert("提示","请先选择细项","info");
		    	return false;
		    }
	    if($("#ODSRowID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
		var ID="";
	}
	
	var OrderDetailType=$("#ODType").val();
	var iParRef=$("#ODRowID").val();
	var iChildSub=$("#ChildSub").val();
	var iRowId="";
		
	//性别
	var iSex=$("#Sex").combobox('getValue');
	if (($("#Sex").combobox('getValue')==undefined)||($("#Sex").combobox('getValue')=="")) {var iSex = "";}
	if(iSex==""){
		$.messager.alert("提示","性别不能为空","info"); 
			return false;
	}

	//年龄下限
	var iAgeMin=$("#AgeMin").val();
	if (IsValidAge(iAgeMin)){}
		else { 
			$.messager.alert("提示","年龄下限错误","info");		
			return false;
		}
			

	//年龄上限
	var iAgeMax=$("#AgeMax").val();
	if (IsValidAge(iAgeMax)){}
		else {
			$.messager.alert("提示","年龄上限错误","info");		
			return false;
		}
	
	if(iAgeMin>iAgeMax){
		$.messager.alert("提示","年龄下限不能大于年龄上限","info");
		return false;
	}
	
	//文本值
	var iTextVal=$.trim($("#TextVal").val());

	//单位
	var iUnit=$("#Unit").val();
	
	//下限
	var iMin=$("#ReferenceMin").val();
	if (!(IsFloat(iMin))) {
		$.messager.alert("提示","参考值下限错误","info");
		return false;
	}
	
	//上限
	var iMax=$("#ReferenceMax").val();
	if (!(IsFloat(iMax))) {
		$.messager.alert("提示","参考值上限错误","info");
		return false;
	}
	
	if (("T"==OrderDetailType)||("S"==OrderDetailType)){
	    //输入数据验证
		if (""==iTextVal) {
			$.messager.alert("提示","文本值不能为空","info");
			return false;
	 	}
	}
	else{
		
		if ((""==iMax)&&(""==iMin)&&(""==iUnit)) {
			$.messager.alert("提示","参考范围一栏不能为空","info");
			return false;
		}	
	}


	//序号
	var iSort=$("#Sort").val();
	
	//所见
	var iEyeSee=$("#EyeSee").val();
	
	//是否正常值 
	var iNatureValue="N";
	var NatureValue=$("#NatureValue").checkbox('getValue');
	if(NatureValue) iNatureValue="Y";
	
	
	//默认
	var iDefault="N";
	var Default=$("#Default").checkbox('getValue');
	if(Default) iDefault="Y";
    

	//是否进入小结 
	var iSummary="N";
	var Summary=$("#Summary").checkbox('getValue');
	if(Summary) iSummary="Y";
	
	
	//荒诞值
	var iHDValue="N";
	var HDValue=$("#HDValue").checkbox('getValue');
	if(HDValue) iHDValue="Y";
	
	if((iHDValue=="Y")&&(iNatureValue=="Y")){
		$.messager.alert("提示","正常值和荒诞值不能同时设置","info");
	    return false;
	}

	//不打印
	var iNoPrint="N";
	var NoPrint=$("#NoPrint").checkbox('getValue');
	if(NoPrint) iNoPrint="Y";
	
	var iHighRiskFlag="N";
	
	
	var CurNatureValue=$("#CurNatureValue").val();
	var ret=tkMakeServerCall("web.DHCPE.ODStandard","GetODSNatureValue",iParRef,iRowId);
	if((CurNatureValue=="否")&&(iNatureValue=="Y")&&(ret=="1"))
	 {
	   $.messager.alert("提示","正常值已设置,不能重复设置","info");
	    return false;
    
	}
	
	//激活
	var iNoActive="N";
	var NoActive=$("#NoActive").checkbox('getValue');
	if(NoActive) iNoActive="Y";

	var iEmpower="N";
	var Empower=$("#Empower").checkbox('getValue');
	if(Empower) iEmpower="Y";
	
	var Instring = iParRef	
				+"^"+iRowId		
				+"^"+iChildSub
				+"^"+$.trim(iTextVal)		
				+"^"+$.trim(iUnit)		
				+"^"+$.trim(iSex)			
				+"^"+$.trim(iMin)		
				+"^"+$.trim(iMax)					
				+"^"+""					
				+"^"+iNatureValue
				+"^"+$.trim(iAgeMin)		
				+"^"+$.trim(iAgeMax)		
				+"^"+$.trim(iSort)	
	      		+"^"+iSummary
				+"^"+iNoPrint
	      		+"^"+""
	      		+"^"+iHighRiskFlag   
	      		+"^"+$.trim(iEyeSee)
	      		+"^"+iHDValue
	      		+"^"+iDefault
	      		+"^"+iNoActive
				+"^"+iEmpower
		;
	//alert(Instring)
 	var rtn=tkMakeServerCall("web.DHCPE.CT.ODStandard","SaveODStandard",Instring,odstableName,session['LOGON.USERID'],session['LOGON.CTLOCID']);
	var rtnArr=rtn.split("^");
	if(rtnArr[0]=="-1"){
		$.messager.alert('提示', '保存失败:'+ rtnArr[1], 'error');				
	}else{
		BClear_click();
		if(Type=="1"){$.messager.popover({msg: '修改成功',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '新增成功',type:'success',timeout: 1000});}		
	} 	
}

//清屏
function BClear_click()
{
	$("#ODSRowID,#ChildSub,#TextVal,#EyeSee,#Sort,#Unit,#ReferenceMax,#ReferenceMin,#AgeMin,#AgeMax,#CurNatureValue,#Default").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#NoActive").checkbox('setValue',true);
	//默认进入小结 
	$("#Summary").checkbox('setValue',true);	
	//默认性别为"不限"
	$("#Sex").combobox('setValue',"N");
    //$("#BPower").linkbutton({text:'单独授权'});
    $("#BRelateLoc").linkbutton('enable');
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

	 $("#ODStandardComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ODStandard",
			QueryName:"FindODStandard",
			ParRef:$("#ODRowID").val(),
			tableName:odstableName,
			LocID:locId
			
		
	});
	
}

/**********************细项选择 end************************************/

/**********************站点 start************************************/
// 初始化站点维护DataGrid
function InitStationGrid()
{
	$('#StaionGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
		
		    {field:'TStationID',title:'ID',hidden: true},
			{field:'TStationCode',title:'代码',width: 70},
			{field:'TStationDesc',title:'描述',width: 180},
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationSet",
			LocID:session['LOGON.CTLOCID'],
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			$("#ODDesc").val('');
		
			$('#OrderDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			
			BODFind_click();
			$("#ODRowID,#ODSDesc,#ODType").val('');
			BClear_click();
			$('#ODStandardComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
		
		},
		onLoadSuccess: function (data) {		 
			
		}
	});
	
}

	

//查询（站点）
function BFind_click(){
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		LocID:$("#LocList").combobox('getValue'),
		Desc:$("#Desc").val(),
		STActive:"Y"
	});	
	
}

/**********************站点 end************************************/


//验证是否为正确年龄
function IsValidAge(Value) {
	
	if(""==$.trim(Value) || "0"==Value) { 
		//允许为空
		return true; 	
	}
	if (!(IsFloat(Value))) { return false; }
	
	if ((Value>0)&&(Value<120)) {
		return true; 
	}
}

//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==$.trim(Value)) { 
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

