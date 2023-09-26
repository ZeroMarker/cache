//名称	dhcpepositiverecord.hisui.js
//功能	阳性记录	
//创建	2019.04.26
//创建人  yupeng
var UserId=session['LOGON.USERID']
var editIndex=undefined;
var ConditioneditIndex=undefined;
function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#ExpertDiagnosisGrid').datagrid('validateRow', editIndex)){
				
				$('#ExpertDiagnosisGrid').datagrid('endEdit', editIndex);
				
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
}


function ConditionendEditing(){
			if (ConditioneditIndex == undefined){return true}
			if ($('#DHCPEEDCondition').datagrid('validateRow', ConditioneditIndex)){
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TItemID'});
				var name = $(ed.target).combobox('getText');
				
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TItem'] = name;
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TOperator'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TOperatorname'] = name;
				
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TSex'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TSexname'] = name;
				
				$('#DHCPEEDCondition').datagrid('endEdit', ConditioneditIndex);
				
				ConditioneditIndex = undefined;
				return true;
			} else {
				return false;
			}
}


function PositiveClickRow(index){
		if (editIndex!=index) {
			if (endEditing()){
				$('#ExpertDiagnosisGrid').datagrid('selectRow',index).datagrid('beginEdit',index);
				editIndex = index;
			} else {
				$('#ExpertDiagnosisGrid').datagrid('selectRow',editIndex);
			}
		}
}


function ConditionClickRow(index){
		if (ConditioneditIndex!=index) {
			if (ConditionendEditing()){
				$('#DHCPEEDCondition').datagrid('selectRow',index).datagrid('beginEdit',index);
				ConditioneditIndex = index;
			} else {
				$('#DHCPEEDCondition').datagrid('selectRow',ConditioneditIndex);
			}
		}
}

$(function(){
		
		
		$("#NSave").click(function() {	
		NSave_click();		
        });
		
		$("#BSave").click(function() {	
		BSave_click();		
        });
		
		$("#Add").click(function() {	
		Add_click();		
        });
		$("#Clear").click(function() {	
		Clear_click();		
        });
		$("#Update").click(function() {	
		Update_click();		
        });
		
		
		var NDiagnosisLevelObj = $HUI.combobox("#NDiagnosisLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=DiagnosisLevel&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})
		
		var NSexObj = $HUI.combobox("#NSex",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex'
		})
		
	    var StationIDObj = $HUI.combobox("#StationID",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		});
		
		var NStationIDObj = $HUI.combobox("#NStationID",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		});
	
	
		var NStationLocObj = $HUI.combogrid("#NStationLoc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.StationLoc&QueryName=SearchStationLoc",
		mode:'remote',
		delay:200,
		idField:'STL_RowId',
		textField:'STL_Desc',
		onBeforeLoad:function(param){
			
			var STId=$("#NStationID").combobox("getValue");
			param.ParRef = STId;
		},
		onShowPanel:function()
		{
			$('#NStationLoc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'STL_RowId',hidden:true},
			{field:'STL_Desc',title:'分组名称',width:140}
		]]
		});
	
		
		
		$HUI.datagrid("#DHCPEEDCondition",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		singleSelect: true,
		selectOnCheck: false,
		onClickRow: ConditionClickRow,
		queryParams:{
			ClassName:"web.DHCPE.ExcuteExpress",
			QueryName:"FindExpress",
			ParrefRowId:"",
			Type:""
		},
		columns:[[
		    {field:'TPreBracket',title:'前置括号',
		    editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'(',text:'('},{id:'((',text:'(('},{id:'(((',text:'((('},{id:'((((',text:'(((('},{id:'(((((',text:'((((('}
						]
						
					}
				}
		    
		    
		    
		    },	
		    {field:'TItemID',title:'项目',width:130,
		    formatter:function(value,row){
						return row.TItem;
					},
					
			editor:{
					type:'combobox',
					options:{
						valueField:'OD_RowId',
						textField:'OD_Desc',
						method:'get',
						//mode:'remote',
						url:$URL+"?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetailA&ResultSetType=array",
						onBeforeLoad:function(param){
							//param.Desc = param.q;
							
							}
						
					}
						
			}		
		    /*editor:{
					type:'combogrid',
					options:{
						
						panelWidth:300,
						url:$URL+"?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetail",
						mode:'remote',
						delay:200,
						idField:'OD_RowId',
						textField:'OD_Desc',
						onBeforeLoad:function(param){
							param.Desc = param.q;
						},
						onSelect: function (rowIndex, rowData) {
							var String="^"+rowData.OD_Code+"^"+rowData.OD_RowId
							
							var NorInfo=tkMakeServerCall("web.DHCPE.ODStandard","GetNorInfo",String);
							var obj=document.getElementById("NorInfo");
							if (obj) obj.value=NorInfo;
							
						},
			
						columns:[[
							{field:'OD_RowId',hidden:true},
							{field:'OD_Desc',title:'名称',width:100},
							{field:'OD_Code',title:'编码',width:100}
			
						]]
						
						
						
					}*/
		    
		    },
		    {field:'TOperator',title:'运算符',width:70,
		    formatter:function(value,row){
						return row.TOperatorname;
					},
		    editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'>',text:'大于'},{id:'>=',text:'大于等于'},{id:'<',text:'小于'},{id:'<=',text:'小于等于'},{id:'[',text:'包含'},{id:"'[",text:'不包含'},{id:'=',text:'等于'},{id:"'=",text:'不等于'}
						]
						
					}
				}
		    },
			{field:'TReference',title:'参考值',
			editor:'text'
			
			},
			{field:'TSex',title:'性别',width:70,
			 formatter:function(value,row){
						return row.TSexname;
					},
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'N',text:'不限'},{id:'M',text:'男'},{id:'F',text:'女'}
						]
						
					}
				}
			},
			{field:'TNoBloodFlag',title:'非血',
			editor:{type:'icheckbox',options:{on:'Y',off:'N'}}
			
			},
			{field:'TAgeRange',title:'年龄',
			editor:'text'
			},
			{field:'TAfterBracket',title:'括号',
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:')',text:')'},{id:'))',text:'))'},{id:')))',text:')))'},{id:'))))',text:'))))'},{id:')))))',text:')))))'}
						]
						
					}
				}},
			{field:'TRelation',title:'关系',width:70,
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'||',text:'或者'},{id:'&&',text:'并且'}
						]
						
					}
				}
			},
			{field:'TAdd',title:'新增一行',width:90,
			editor:{type:'linkbutton',options:{text:'新增一行',handler:function(){
				
				var NewConditioneditIndex=ConditioneditIndex+1;
				ConditionendEditing();
				$('#DHCPEEDCondition').datagrid('insertRow',{
					index: NewConditioneditIndex,
					row: {
						TPreBracket:"",
						TItemID:"",
						TOperator:"",
						TReference:"",
						TSex:"",
						TNoBloodFlag:"",
						TAgeRange:"",
						TAfterBracket:"",
						TRelation:"",
						TAdd:"新增一行",
						TDelete:"删除一行"
						}
					});	
					
				
				$('#DHCPEEDCondition').datagrid('selectRow',NewConditioneditIndex).datagrid('beginEdit',NewConditioneditIndex);
				ConditioneditIndex = NewConditioneditIndex;
				
				}}}
			
			},
			{field:'TDelete',title:'删除一行',width:90,
			editor:{type:'linkbutton',options:{text:'删除一行',handler:function(){
				$('#DHCPEEDCondition').datagrid('deleteRow',ConditioneditIndex);
				ConditioneditIndex = undefined;
				
				}}}
			
			}
		]],
		onAfterEdit:function(rowIndex,rowData,changes){
			
			
	
			
		},
		onSelect: function (rowIndex, rowData) {
			
		}
			
		});
		
		
		$HUI.datagrid("#ExpertDiagnosisGrid",{
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
		displayMsg:"",
		singleSelect: true,
		selectOnCheck: false,
		//onClickCell:PositiveClickRow,
		queryParams:{
			ClassName:"web.DHCPE.PositiveRecord",
			QueryName:"FindPositiveRecord",
			Type:""
				
		},
		columns:[[
		    {field:'ID',hidden: true},	
		    {field:'Code',title:'编码',editor:'text'},
			{field:'Name',title:'描述',editor:'text'},
			{field:'MSeq',title:'男性顺序',editor:'text'},
			{field:'FSeq',title:'女性顺序',editor:'text'},
			{field:'TUseRange',title:'全科',
			editor:{type:'icheckbox',options:{on:'S',off:'U'}}}
		
			
		]],
		/*
		toolbar:[{
			iconCls:'icon-add',
			text:'新增',
			handler: function(){
				
				if(getValueById("Code")=="")
				{
					$.messager.alert("提示","编号不能为空！","info");
					return false;
				}
				if(getValueById("Name")=="")
				{
					$.messager.alert("提示","描述不能为空！","info");
					return false;
				}
				
				$('#ExpertDiagnosisGrid').datagrid('insertRow',{
					index: 0,
					row: {
						ID: '',
						Code: getValueById("Code"),
						Name: getValueById("Name"),
						MSeq: getValueById("MSeq"),
						FSeq: getValueById("FSeq"),
						TUseRange:'U'
						}
				});
				
			}
		},{
			iconCls:'icon-write-order',
			text:'修改',
			handler: function(){
				endEditing();
				
			}
		}],
		*/
		onAfterEdit:function(rowIndex,rowData,changes){
			var iUserID=session['LOGON.USERID'];
			
			var Instring=rowData.ID
	            +"^"+rowData.Code		
				+"^"+rowData.Name
				+"^"+rowData.MSeq
				+"^"+rowData.FSeq
	 			+"^"+rowData.TUseRange
	 			+"^"+iUserID;
			var flag=tkMakeServerCall("web.DHCPE.PositiveRecord","Update",Instring,"P")
			
    		if (flag==0)  
			{  
				
				$("#ExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.PositiveRecord",QueryName:"FindPositiveRecord",Type:""}); 
	
				  	 
			}
		},
		
		onSelect: function (rowIndex, rowData) {
			
			
			setValueById("ParrefRowId",rowData.ID)
			setValueById("Code",rowData.Code);
			setValueById("Name",rowData.Name);
			setValueById("MSeq",rowData.MSeq);
			setValueById("FSeq",rowData.FSeq);
			if(rowData.TUseRange=="是")
			setValueById("UseRange",true);
			else 
			setValueById("UseRange",false);
			$("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:rowData.ID,Type:"PR"}); 
			var obj=document.getElementById("NorInfo");
			if (obj) obj.value="";
			
			ConditioneditIndex=undefined;
			
		}
			
	});
        
})

function Clear_click()
{
	
	setValueById("Code","");
	setValueById("Name","");
	setValueById("MSeq","");
	setValueById("FSeq","");
	setValueById("ParrefRowId","");
	setValueById("UseRange",false);
}
function Update_click()
{
	
				if(getValueById("ParrefRowId")=="")
				{
					$.messager.alert("提示","请选择需要修改的记录！","info");
					return false;
				}
	
				
				if(getValueById("Code")=="")
				{
					$.messager.alert("提示","编号不能为空！","info");
					return false;
				}
				if(getValueById("Name")=="")
				{
					$.messager.alert("提示","描述不能为空！","info");
					return false;
				}
				
				var iUserID=session['LOGON.USERID'];
			
				if(getValueById("UseRange"))
				var UseRange="S"
				else UseRange="U"
				var Instring=getValueById("ParrefRowId")
	            +"^"+getValueById("Code")		
				+"^"+getValueById("Name")
				+"^"+getValueById("MSeq")
				+"^"+getValueById("FSeq")
	 			+"^"+UseRange
	 			+"^"+iUserID;
	 			
				var flag=tkMakeServerCall("web.DHCPE.PositiveRecord","Update",Instring,"P")
				
				if (flag.split("^")[0]==0)  
				{  
				
				$("#ExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.PositiveRecord",QueryName:"FindPositiveRecord",Type:""}); 
	
				  	 
				}
	
}

function Add_click()
{
	
				if(getValueById("Code")=="")
				{
					$.messager.alert("提示","编号不能为空！","info");
					return false;
				}
				if(getValueById("Name")=="")
				{
					$.messager.alert("提示","描述不能为空！","info");
					return false;
				}
				
				var iUserID=session['LOGON.USERID'];
			
				var Instring=""
	            +"^"+getValueById("Code")		
				+"^"+getValueById("Name")
				+"^"+getValueById("MSeq")
				+"^"+getValueById("FSeq")
	 			+"^"+'U'
	 			+"^"+iUserID;
				var flag=tkMakeServerCall("web.DHCPE.PositiveRecord","Update",Instring,"P")
				
				if (flag.split("^")[0]==0)  
				{  
				
				$("#ExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.PositiveRecord",QueryName:"FindPositiveRecord",Type:""}); 
	
				  	 
				}
				else if (flag.split("^")[0]=="-119")
				{
					$.messager.alert("提示","编码不允许重复！","info");
					
				}
	
	
}

function BSave_click()
{
	
	ConditionendEditing();
	var Char_1=String.fromCharCode(1);
	var Express=""
	var rows = $("#DHCPEEDCondition").datagrid("getRows"); 
	
	for(var i=0;i<rows.length;i++){
		
		
		
		var OneRowInfo="",Select="N",PreBracket="",ItemID="",Operator="",ODStandardID="",Reference="",AfterBracket="",Relation="",Sex="N";
		
		ItemID=rows[i].TItemID
		
		if (ItemID=="") break;
		PreBracket=rows[i].TPreBracket
		AfterBracket=rows[i].TAfterBracket
		Relation=rows[i].TRelation
		Operator=rows[i].TOperator
		
		
		Reference=rows[i].TReference
		Sex=rows[i].TSex
		NoBloodFlag=rows[i].TNoBloodFlag
		
		ODStandardID=""
		AgeRange=rows[i].TAgeRange
		
		if(AgeRange!="") {
			if(AgeRange.indexOf("-")==-1)
			{
				$.messager.alert("提示","输入年龄范围格式不正确,应为10-20!","info");
				return false;
			}
			var AgeMin=AgeRange.split("-")[0];
			var AgeMax=AgeRange.split("-")[1];
			if((isNaN(AgeMin))||(isNaN(AgeMax)))
			{
				$.messager.alert("提示","输入年龄不是数字!","info");
				return false;
		
			}
			
		}
		OneRowInfo=PreBracket+"^"+ItemID+"^"+Operator+"^"+ODStandardID+"^"+Reference+"^"+Sex+"^"+AfterBracket+"^"+Relation+"^"+NoBloodFlag+"^"+AgeRange;
		
		if (Express!=""){
			Express=Express+Char_1+OneRowInfo;
		}else{
			Express=OneRowInfo;
		}
		

	}
	
	var iType="PR";
	var ParrefRowId=getValueById("ParrefRowId")
	var ret=tkMakeServerCall("web.DHCPE.ExcuteExpress","SaveNewExpress",iType,ParrefRowId,Express);
		
	if (ret==0){
			
		$("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:ParrefRowId,Type:"PR"}); 
			
	}
	
	
}



function NSave_click()
{
	
	
	var Code=getValueById("NCode")
  	
  
  	var Illness="N"
  	
  	var CommonIllness="N"
  	
 	var Active="N"
 	
 	var obj=$("#NActiveFlag").checkbox('getValue');
  	if (obj) Active="Y";
 	
  	
 	var LevelID=getValueById("NDiagnosisLevel");
  	
	
  	var DiagnoseConclusion=getValueById("NDiagnoseConclusion");
  

	if (""==DiagnoseConclusion){
        $.messager.alert("提示","请填写结论!","info");
		return false
  	} 
  	
  	var EDAlias=getValueById("NAlias");
  
	if (""==EDAlias){
		$.messager.alert("提示","必须填写别名!","info");
		return false
  	} 
  	var InsertType=""
	var obj=document.getElementById("InsertType");
	if (obj){InsertType=obj.value;}
  	
  	var Detail=""
  	var obj=document.getElementById("NDetail");
    if (obj){
		Detail=obj.value
	}
	if (""==Detail){
		$.messager.alert("提示","请填写建议!","info");
		return false
  	} 
  	else{
	  	
		var StationID=getValueById("NStationID");
		
		if (""==StationID){
			$.messager.alert("提示","必须选择站点!","info");
		
			return false
  		}
  	    var RelateFlag="N",IllRowID=""
  	 	var obj=document.getElementById("GetRelateFlag");
  	 	if (obj){RelateFlag=obj.value}
  	 	var obj=document.getElementById("IllRowID");
	    if (obj) {IllRowID=obj.value}
  	 	if ((RelateFlag=="Y")&&(IllRowID==""))
  	 	{	$.messager.alert("提示","必须关联疾病!","info");
		    return false
	  	}
	  	var HighRisk="N";
	  	var obj=$("#NHighRisk").checkbox('getValue');
  		if (obj) HighRisk="Y";
	  
		var Sort=$("#NSort").val();
	  	
		var StationLocID=$("#NStationLoc").combogrid('getValue');
		if (StationLocID==undefined) StationLocID=""
		
		var SexDR=getValueById("NSex")
  		
    	var InString=Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+CommonIllness+"^"+UserId+"^"+InsertType+"^"+EDAlias+"^"+StationID+"^"+Active+"^"+LevelID+"^"+IllRowID+"^"+HighRisk+"^"+Sort+"^"+StationLocID+"^"+SexDR;
    	
    	var EDCRID=getValueById("EDCRID")
    	var EDRowId=getValueById("ParrefRowId")
    	if(EDRowId=="")
    	{
        	var value=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","InsertED",InString);
    	}
    	else
    	{
    		var ExpStr=HighRisk+"^"+Sort+"^"+StationLocID
        	var value=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","UpdateED",EDRowId,Code,DiagnoseConclusion,Detail,Illness,CommonIllness,UserId,StationID,Active,LevelID,EDCRID,SexDR,ExpStr);
        	
    	}
        values=value.split("^");
        flag=values[0];
        if ('0'==flag) {
	        if (InsertType!="User")
	        {  
	        	$.messager.alert("提示","操作成功!","info");
	        	$('#ExpertDiagnosis').window('close'); 
	        	$("#ExpertDiagnosisGrid").datagrid('reload');
	        }
	    }
         else{
	         $.messager.alert("提示","Update error.ErrNo="+flag,"info");
     	}
     }
	
	
}


function Find_click()
{
	$("#ExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.PositiveRecord",QueryName:"FindPositiveRecord",Type:""}); 
	
}