//名称	DHCPEIllNessCondition.hisui.js
//功能	疾病条件	
//创建	2022.06.08
//创建人  sxt
var UserId=session['LOGON.USERID']
var editIndex=undefined;
var RelateditIndex=undefined;
var ConditioneditIndex=undefined;
var PCeditIndex=undefined;
$(function(){
	
	$("#BSave").click(function() {	
		BSave_click();		
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
			ParrefRowId:ParrefRowId,
			Type:"ILLGREPORT"
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
					
			/*		
		    editor:{
					type:'combogrid',
					options:{
						
						
						panelWidth:235,
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
							{field:'OD_Desc',title:'名称',width:120},
							{field:'OD_Code',title:'编码',width:100}
			
						]]
						
						
						
					}
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
			{field:'TAdd',title:'插入一行',width:90,
			editor:{type:'linkbutton',options:{text:'插入一行',handler:function(){
				
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
						TAdd:"增加一行",
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
		
	
})
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
	
	var iType="ILLGREPORT";
	//var ParrefRowId=getValueById("ParrefRowId")
	var ret=tkMakeServerCall("web.DHCPE.ExcuteExpress","SaveNewExpress",iType,ParrefRowId,Express);
		
	if (ret==0){
			
		$("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:ParrefRowId,Type:iType}); 
		ConditioneditIndex = undefined;
		return true;	
	}
	
	
}