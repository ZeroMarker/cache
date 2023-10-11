//����	dhcpeexpertdiagnosis.hisui.js
//����	ר�ҽ���	
//����	2019.04.26
//������  yupeng
var UserId=session['LOGON.USERID']
var editIndex=undefined;
var RelateditIndex=undefined;
var ConditioneditIndex=undefined;
var PCeditIndex=undefined;

function PCClickRow(index){
		if (PCeditIndex!=index) {
			if (PCendEditing()){
				$('#PCExpertDiagnosisGrid').datagrid('selectRow',index).datagrid('beginEdit',index);
				PCeditIndex = index;
			} else {
				$('#PCExpertDiagnosisGrid').datagrid('selectRow',PCeditIndex);
			}
		}
}

function PCendEditing(){
			if (PCeditIndex == undefined){return true}
			if ($('#PCExpertDiagnosisGrid').datagrid('validateRow', PCeditIndex)){
				
				$('#PCExpertDiagnosisGrid').datagrid('endEdit', PCeditIndex);
				
				PCeditIndex = undefined;
				return true;
			} else {
				return false;
			}
}

function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#DHCPEEDAlias').datagrid('validateRow', editIndex)){
				
				$('#DHCPEEDAlias').datagrid('endEdit', editIndex);
				
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
}
function RelatedendEditing(){
			if (RelateditIndex == undefined){return true}
			if ($('#DHCPEIDRelate').datagrid('validateRow', RelateditIndex)){
				
				$('#DHCPEIDRelate').datagrid('endEdit', RelateditIndex);
				
				RelateditIndex = undefined;
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


function AliasClickRow(index){
		if (editIndex!=index) {
			if (endEditing()){
				$('#DHCPEEDAlias').datagrid('selectRow',index).datagrid('beginEdit',index);
				editIndex = index;
			} else {
				$('#DHCPEEDAlias').datagrid('selectRow',editIndex);
			}
		}
}

function RelateClickRow(index){
		if (RelateditIndex!=index) {
			if (RelatedendEditing()){
				$('#DHCPEIDRelate').datagrid('selectRow',index).datagrid('beginEdit',index);
				RelateditIndex = index;
			} else {
				$('#DHCPEIDRelate').datagrid('selectRow',RelateditIndex);
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
		
	$("#Find").click(function() {	
		Find_click();		
    });
	
		//Ĭ��"����"��ѡ
	$("#ActiveFlag").checkbox('setValue',true); 

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
			{field:'STL_Desc',title:'��������',width:140}
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
		    {field:'TPreBracket',title:'ǰ������',
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
		    {field:'TItemID',title:'��Ŀ',width:130,
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
							{field:'OD_Desc',title:'����',width:120},
							{field:'OD_Code',title:'����',width:100}
			
						]]
						
						
						
					}
		    }*/
		    },
		    {field:'TOperator',title:'�����',width:70,
		    
		    formatter:function(value,row){
						return row.TOperatorname;
					},
		    editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'>',text:'����'},{id:'>=',text:'���ڵ���'},{id:'<',text:'С��'},{id:'<=',text:'С�ڵ���'},{id:'[',text:'����'},{id:"'[",text:'������'},{id:'=',text:'����'},{id:"'=",text:'������'}
						]
						
					}
				}
		    },
			{field:'TReference',title:'�ο�ֵ',
			editor:'text'
			
			},
			{field:'TSex',title:'�Ա�',width:70,
			 formatter:function(value,row){
						return row.TSexname;
					},
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'N',text:'����'},{id:'M',text:'��'},{id:'F',text:'Ů'}
						]
						
					}
				}
			},
			{field:'TNoBloodFlag',title:'��Ѫ',
			editor:{type:'icheckbox',options:{on:'Y',off:'N'}}
			
			},
			{field:'TAgeRange',title:'����',
			editor:'text'
			},
			{field:'TAfterBracket',title:'����',
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
			{field:'TRelation',title:'��ϵ',width:70,
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'||',text:'����'},{id:'&&',text:'����'}
						]
						
					}
				}
			},
			{field:'TAdd',title:'����һ��',width:90,
			editor:{type:'linkbutton',options:{text:'����һ��',handler:function(){
				
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
						TAdd:"����һ��",
						TDelete:"ɾ��һ��"
						}
					});
				$('#DHCPEEDCondition').datagrid('selectRow',NewConditioneditIndex).datagrid('beginEdit',NewConditioneditIndex);
				ConditioneditIndex = NewConditioneditIndex;
				
				}}}
			
			},
			{field:'TDelete',title:'ɾ��һ��',width:90,
			editor:{type:'linkbutton',options:{text:'ɾ��һ��',handler:function(){
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
		
		
		
		
		
	$HUI.datagrid("#DHCPEIDRelate",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		singleSelect: true,
		selectOnCheck: false,
		onClickRow: RelateClickRow,
		queryParams:{
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"EDCondition",
			ParrefRowId:"",
			EDID:""
		},
		columns:[[
		    {field:'TRowID',hidden: true},	
		    {field:'TEDID',hidden: true},
		    {field:'TILLNessID',title:'��������',width:250,
		    		formatter:function(value,row){
						return row.TILLNessDesc;
					},
		    		editor:{
					type:'combobox',
					options:{
						valueField:'HIDDEN',
						textField:'Detail',
						method:'get',
						url:$URL+"?ClassName=web.DHCPE.IllnessStandard&QueryName=GetEDiagnosisByAlias&ResultSetType=array",
						onBeforeLoad:function(param){
							
							
							}
						
					}
				}
			},
			{field:'TEDDesc',title:'��������',width:170},
			{field:'TEDCode',title:'�������'}
			
		]],
		onAfterEdit:function(rowIndex,rowData,changes){
			
			
			var RowID=rowData.TRowID
			var EDID=rowData.TEDID
			var IllID=rowData.TILLNessID
			var InString=RowID+"^"+EDID+"^"+IllID;
			(InString)
			var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","UpdateIDR",InString,0);
			if (flag==0)
			{
				$("#DHCPEIDRelate").datagrid("load",{ClassName:"web.DHCPE.IllnessStandard",QueryName:"EDCondition",ParrefRowId:"",EDID:rowData.TEDID}); 
			
			}
		
			
		},
		toolbar:[{
			iconCls:'icon-add',
			text:'����',
			handler: function(){

				RelatedendEditing();
				if(RelateditIndex != undefined)
				{
					$.messager.alert("��ʾ","����δ��������ݣ������޸�!","info");	
					return
					
				}
				else
				{
				$('#DHCPEIDRelate').datagrid('insertRow',{
					index: 0,
					row: {
						TRowID: '',
						TEDID: getValueById("ParrefRowId"),
						TILLNessID: ''
						}
				});
				RelateClickRow(0);
				}
			}
		},{
			iconCls:'icon-write-order',
			text:'�޸�',
			handler: function(){
				
				RelatedendEditing();
				
				
			}
		},{
			iconCls:'icon-cancel',
			text:'ɾ��',
			handler: function(){
				
				
				var InString=getValueById("RelateID")
				var EDID=getValueById("ParrefRowId")
				if(InString=="")
				{
					$.messager.alert("��ʾ","��ѡ��ɾ������!","info");	
					return
				}
				var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","UpdateIDR",InString,1);
				if (flag==0)
				{
					$("#DHCPEIDRelate").datagrid("load",{ClassName:"web.DHCPE.IllnessStandard",QueryName:"EDCondition",ParrefRowId:"",EDID:EDID}); 
			
				}
				RelatedendEditing();
				
			}
		}
		],
		onSelect: function (rowIndex, rowData) {
			
			
			setValueById("RelateID",rowData.TRowID)
		}
			
	});
		
		
		
		
		
	$HUI.datagrid("#PCExpertDiagnosisGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		singleSelect: true,
		selectOnCheck: false,
		onClickRow: PCClickRow,
		
		queryParams:{
			ClassName:"web.DHCPE.EDBlackBall",
			QueryName:"QueryAll",
			Parref:""
				
		},
		columns:[[
		    {field:'TID',hidden: true},
		    {field:'TEDID',title:'����',width:170,
		    
		    formatter:function(value,row){
						return row.TDesc;
					},
		    editor:{
					type:'combogrid',
					options:{
						
						panelWidth:300,
						panelHeight:250,
						url:$URL+"?ClassName=web.DHCPE.DHCPEExpertDiagnosis&QueryName=GetEDiagnosisByAlias",
						mode:'remote',
						delay:200,
						idField:'ID',
						textField:'Detail',
						pagination:true,
						pageSize:5,
						pageList:[5,10],
						displayMsg:"",
						onBeforeLoad:function(param){
							param.AddDiagnosis = param.q;
						},
		
						columns:[[
							{field:'ID',hidden:true},
							{field:'Detail',title:'����',width:180},
							{field:'Code',title:'����',width:100}
			
						]]
						
						
						
					}
		    }
		    
		    },	
		    {field:'TCode',title:'����',width:100},
			{field:'TDetail',title:'����',width:200}
			
			
		]],
		toolbar:[{
			iconCls:'icon-add',
			text:'����',
			handler: function(){
				
				
				
				if(PCeditIndex != undefined)
				{
					$.messager.alert("��ʾ","����δ��������ݣ������޸�!","info");	
					return
					
				}
				else
				{
				var rows = $("#PCExpertDiagnosisGrid").datagrid("getRows");
				$('#PCExpertDiagnosisGrid').datagrid('insertRow',{
					index: 0,
					row: {
						TID: '',
						TEDID: '',
						TCode: '',
						TDetail: ''
						}
				});
				
				PCClickRow(0);
				
				}
			}
		},{
			iconCls:'icon-write-order',
			text:'�޸�',
			handler: function(){
				PCendEditing();
			}
		},{
			iconCls:'icon-cancel',
			text:'ɾ��',
			handler: function(){
				
				var ID=getValueById("PCRowId")
				var Parref=getValueById("ParrefRowId")
				if(ID=="")
				{
					$.messager.alert("��ʾ","��ѡ��ɾ������!","info");	
					return
				}
				var flag=tkMakeServerCall("web.DHCPE.EDBlackBall","DeleteBlackBall",ID);
				if (flag==0)
				{
					$("#PCExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.EDBlackBall",QueryName:"QueryAll",Parref:Parref}); 

					PCeditIndex=undefined;
				}
				
				
			}
		}
		],
		onAfterEdit:function(rowIndex,rowData,changes){
			
			var ID=rowData.TID
			var Parref=getValueById("ParrefRowId")
			var EDID=rowData.TEDID
			
			var flag=tkMakeServerCall("web.DHCPE.EDBlackBall","UpdateBlackBall",ID,Parref,EDID);
			if (flag==0)
			{
				$("#PCExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.EDBlackBall",QueryName:"QueryAll",Parref:Parref}); 

			}
			else 
			{
				$.messager.alert("��ʾ",flag,"info");	
				$("#PCExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.EDBlackBall",QueryName:"QueryAll",Parref:Parref}); 

			}
			
		},
		onSelect: function (rowIndex, rowData) {
			setValueById("PCRowId",rowData.TID)
			
		}
			
	});
		
		
		
		
		$HUI.datagrid("#DHCPEEDAlias",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		singleSelect: true,
		selectOnCheck: false,
		onClickRow: AliasClickRow,
		queryParams:{
			ClassName:"web.DHCPE.DHCPEExpertDiagnosis",
			QueryName:"EDAliasList",
			EDId:""
				
		},
		columns:[[
		    {field:'EDA_RowId',hidden: true},	
		    {field:'EDA_ED_DR',hidden: true},	
		    {field:'EDA_Text',title:'����',width:260,editor:'text'}
			
			
			
		]],
		onAfterEdit:function(rowIndex,rowData,changes){
			
			var RowId=rowData.EDA_RowId
			var EDId=rowData.EDA_ED_DR
			var Alias=rowData.EDA_Text
			if(Alias=="")
			{
				$.messager.alert("��ʾ","��������Ϊ��!","info");	
					return
				
			}
			var DataStr=RowId+"^"+EDId+"^"+Alias
			var flag=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","UpdateAlias",DataStr,0);
			if (flag==0)
			{
				$("#DHCPEEDAlias").datagrid("load",{ClassName:"web.DHCPE.DHCPEExpertDiagnosis",QueryName:"EDAliasList",EDId:EDId}); 
			}
			
		},
		toolbar:[{
			iconCls:'icon-add',
			text:'����',
			handler: function(){
				
				$('#DHCPEEDAlias').datagrid('insertRow',{
					index: 0,
					row: {
						EDA_RowId: '',
						EDA_ED_DR: getValueById("ParrefRowId"),
						EDA_Text: ''
						}
				});
				AliasClickRow(0);
			}
		},{
			iconCls:'icon-write-order',
			text:'�޸�',
			handler: function(){
				endEditing();
				
			}
		},{
			iconCls:'icon-cancel',
			text:'ɾ��',
			handler: function(){
				
				var EDARowId=getValueById("EDARowId")
				var EDId=getValueById("ParrefRowId")
				if(EDARowId=="")
				{
					$.messager.alert("��ʾ","��ѡ��ɾ������!","info");	
					return
				}
				var flag=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","UpdateAlias",EDARowId,1);
				if (flag==0)
				{
					$("#DHCPEEDAlias").datagrid("load",{ClassName:"web.DHCPE.DHCPEExpertDiagnosis",QueryName:"EDAliasList",EDId:EDId}); 
				}
				
			}
		}
		],
		onSelect: function (rowIndex, rowData) {
			
			setValueById("EDARowId",rowData.EDA_RowId)
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
		queryParams:{
			ClassName:"web.DHCPE.DHCPEExpertDiagnosis",
			QueryName:"QueryED",
			Code:"",
			DiagnoseConclusion:"",
			Alias:"",
			StationID:"", 
			ChartID:"",
			HighRisk:"",
			ActiveFlag:$HUI.checkbox("#ActiveFlag").getValue() ? "Y" : "",
			StationName:""
				
		},
		columns:[[
		    {field:'ED_RowId',hidden: true},	
		    {field:'ED_DiagnoseConclusion',title:'����'},
			{field:'ED_Detail',title:'����'},
			{field:'TStationName',title:'վ������'},
			{field:'TActive',title:'����'},
			{field:'TLevel',title:'����ȼ�'},
			{field:'TSex',title:'�Ա�'},
			{field:'THighRisk',title:'��Σ'},
			{field:'TYGFlag',title:'�Ҹ�'}
		]],
		
		toolbar:[{
			iconCls:'icon-add',
			text:'����',
			handler: function(){
				addExpertDiagnosis();
				
			}
		},{
			iconCls:'icon-write-order',
			text:'�޸�',
			handler: function(){
				updateExpertDiagnosis();
				
			}
		},{
			iconCls:'icon-paper-blue-line',
			text:'�ų�',
			handler: function(){
				
				PCExpertDiagnosis();
				
			}
		}],
		onSelect: function (rowIndex, rowData) {
			
			
			setValueById("ParrefRowId",rowData.ED_RowId)
			$("#DHCPEEDAlias").datagrid("load",{ClassName:"web.DHCPE.DHCPEExpertDiagnosis",QueryName:"EDAliasList",EDId:rowData.ED_RowId}); 
			$("#DHCPEIDRelate").datagrid("load",{ClassName:"web.DHCPE.IllnessStandard",QueryName:"EDCondition",ParrefRowId:"",EDID:rowData.ED_RowId}); 
			$("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:rowData.ED_RowId,Type:""}); 
			var obj=document.getElementById("NorInfo");
			if (obj) obj.value="";
			ConditionendEditing();
			endEditing();
			RelatedendEditing();
		},
		onLoadSuccess:function(data){
			
			setValueById("ParrefRowId","")
			$("#DHCPEEDAlias").datagrid("load",{ClassName:"web.DHCPE.DHCPEExpertDiagnosis",QueryName:"EDAliasList",EDId:""}); 
			$("#DHCPEIDRelate").datagrid("load",{ClassName:"web.DHCPE.IllnessStandard",QueryName:"EDCondition",ParrefRowId:"",EDID:""}); 
			$("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:"",Type:""}); 
			var obj=document.getElementById("NorInfo");
			if (obj) obj.value="";
			ConditionendEditing();
			endEditing();
			RelatedendEditing();
			
		}
			
	});
        
})
var addExpertDiagnosis = function(){
	
	$HUI.window("#ExpertDiagnosis",{
		title:"ά��ר�ҽ���",
		iconCls:'icon-w-add',
		collapsible:false,
		minimizable:false,
		modal:true
	});
	
	$("#ExpertDiagnosis").datagrid('clearSelections'); //ȡ��ѡ��״̬
	var ret=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","InitED","")
	
	var EDList=ret.split("^");
	setValueById("NCode",EDList[5]);
	setValueById("ParrefRowId","");
	setValueById("NStationID","");
	setValueById("NDiagnoseConclusion","");
	setValueById("NSort","");
	setValueById("EDCRID","");
	setValueById("NStationLoc","");
	setValueById("NDetail","");
	setValueById("NDiagnosisLevel","");
	setValueById("NSex","");
	setValueById("NAlias","");
	$('#NAlias').attr("disabled",false);
	$("#NHighRisk").checkbox('setValue',false);
	$("#NActiveFlag").checkbox('setValue',false);
	$("#NYGFlag").checkbox('setValue',false);
}
var updateExpertDiagnosis = function(){
	
	
	var ParrefRowId=getValueById("ParrefRowId")
	
	if(ParrefRowId=="") 
	{
		$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵļ�¼!","info");
		return
	}
	
	$HUI.window("#ExpertDiagnosis",{
		title:"ά��ר�ҽ���",
		iconCls:'icon-w-edit',
		collapsible:false,
		minimizable:false,
		modal:true
	});
	
	
	var ret=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","InitED",ParrefRowId)
	
	var EDList=ret.split("^");
	setValueById("NCode",EDList[5]);
	setValueById("NDiagnoseConclusion",EDList[0]);
	setValueById("NStationID",EDList[6]);
	setValueById("NAlias","");
	$('#NAlias').attr("disabled",true);
	
	if(EDList[7]=="Y") $("#NHighRisk").checkbox('setValue',true);
	else $("#NHighRisk").checkbox('setValue',false);
	setValueById("NSort",EDList[8]);
	setValueById("EDCRID",EDList[14]);
	
	//setValueById("NStationLoc",EDList[16]);
	setValueById("NStationLocID",EDList[9]);
	$("#NStationLoc").combogrid('setValue',EDList[16]);

	setValueById("NDetail",EDList[10]);
	setValueById("NDiagnosisLevel",EDList[13]);
	
	setValueById("NSex",EDList[15]);
	
	if(EDList[12]=="Y") $("#NActiveFlag").checkbox('setValue',true);
	else $("#NActiveFlag").checkbox('setValue',false);
	
	if(EDList[17]=="Y") $("#NYGFlag").checkbox('setValue',true);
	else $("#NYGFlag").checkbox('setValue',false);
}


var PCExpertDiagnosis = function(){
	
	
	var ParrefRowId=getValueById("ParrefRowId")
	
	if(ParrefRowId=="") 
	{
		$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵļ�¼!","info");
		return
	}
	
	$HUI.window("#PCExpertDiagnosis",{
		title:"�ų⽨��ά��",
		collapsible:false,
		minimizable:false,
		iconCls:'icon-w-paper',
		modal:true
	});
	
	$("#PCExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.EDBlackBall",QueryName:"QueryAll",Parref:ParrefRowId}); 
	PCeditIndex=undefined;
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
				$.messager.alert("��ʾ","�������䷶Χ��ʽ����ȷ,ӦΪ10-20!","info");
				return false;
			}
			var AgeMin=AgeRange.split("-")[0];
			var AgeMax=AgeRange.split("-")[1];
			if((isNaN(AgeMin))||(isNaN(AgeMax)))
			{
				$.messager.alert("��ʾ","�������䲻������!","info");
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
	
	var iType="ED";
	var ParrefRowId=getValueById("ParrefRowId")
	var ret=tkMakeServerCall("web.DHCPE.ExcuteExpress","SaveNewExpress",iType,ParrefRowId,Express);
		
	if (ret==0){
			
		$("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:ParrefRowId,Type:""}); 
		ConditioneditIndex = undefined;
		return true;	
	}
	
	
}



function NSave_click() {
  	var DiagnoseConclusion=getValueById("NDiagnoseConclusion");
	if (""==DiagnoseConclusion){
        $.messager.alert("��ʾ","����д����!","info");
		return false
  	} 
  	
  	var EDRowIdAA=getValueById("ParrefRowId");
  	var EDAlias=getValueById("NAlias");
	if ((""==EDAlias)&&(EDRowIdAA=="")) {
		$.messager.alert("��ʾ","������д����!","info");
		return false
  	}
  	
  	var StationID=getValueById("NStationID");
	if (""==StationID){
		$.messager.alert("��ʾ","����ѡ��վ��!","info");
		return false;
  	}
  	
  	var Detail="";
  	var obj=document.getElementById("NDetail");
    if (obj) { Detail=obj.value; }
	if (""==Detail) {
		$.messager.alert("��ʾ","����д����!","info");
		return false;
  	}
  	
	var RelateFlag="N";
  	var obj=document.getElementById("GetRelateFlag");
  	if (obj) { RelateFlag=obj.value; }
  	
  	var IllRowID="";
  	var obj=document.getElementById("IllRowID");
	if (obj) { IllRowID=obj.value; }
	
  	if ((RelateFlag=="Y")&&(IllRowID=="")) {
	  	$.messager.alert("��ʾ","�����������!","info");
		return false
	}
  	
	var Code=getValueById("NCode");
  	
  	var Illness="N", CommonIllness="N", Active="N";
 	
 	var obj=$("#NActiveFlag").checkbox('getValue');
  	if (obj) Active="Y";
 	
 	var LevelID=getValueById("NDiagnosisLevel");
  	
  	var InsertType="";
	var obj=document.getElementById("InsertType");
	if (obj) { InsertType=obj.value; }
	
	var HighRisk="N";
	var obj=$("#NHighRisk").checkbox('getValue');
  	if (obj) HighRisk="Y";
  	
	var YGFlag="N";
	var obj=$("#NYGFlag").checkbox('getValue');
  	if (obj) YGFlag="Y";
	  
	var Sort=$("#NSort").val();
	  	
	var StationLocID=$("#NStationLoc").combogrid('getValue');
	if (($('#NStationLoc').combogrid('getValue')==undefined)||($('#NStationLoc').combogrid('getValue')=="")) { StationLocID=""; }
	if (StationLocID.split("||").length < 2) { StationLocID=$("#NStationLocID").val(); }

		
	var SexDR=$("#NSex").combobox('getValue');
	if (($('#NSex').combobox('getValue')==undefined)||($('#NSex').combobox('getValue')=="")){var SexDR="";}
  		

    var InString=Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+CommonIllness+"^"+UserId+"^"+InsertType+"^"+EDAlias+"^"+StationID+"^"+Active+"^"+LevelID+"^"+IllRowID+"^"+HighRisk+"^"+Sort+"^"+StationLocID+"^"+SexDR+"^"+YGFlag;
    	
    var EDCRID=getValueById("EDCRID");
    
    if(EDRowIdAA=="") {
    	var value=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","InsertED",InString);
    } else {
    	var ExpStr=HighRisk+"^"+Sort+"^"+StationLocID+"^"+YGFlag;
        var value=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","UpdateED",EDRowIdAA,Code,DiagnoseConclusion,Detail,Illness,CommonIllness,UserId,StationID,Active,LevelID,EDCRID,SexDR,ExpStr);
    }
    
    values=value.split("^");
	flag=values[0];
	if ('0'==flag) {
		if (InsertType!="User") {  
			$.messager.alert("��ʾ","�����ɹ�!","info");
			$('#ExpertDiagnosis').window('close'); 
			$("#ExpertDiagnosisGrid").datagrid('reload');
		}
	} else {
		$.messager.alert("��ʾ","Update error.ErrNo="+flag,"info");
	}	
}


function Find_click()
{
	
	var HighRisk="";
	var obj=$("#HighRisk").checkbox('getValue');
  	if (obj) HighRisk="Y";
  	var ActiveFlag="N";
  	var obj=$("#ActiveFlag").checkbox('getValue');
  	if (obj) ActiveFlag="Y";

	$("#ExpertDiagnosisGrid").datagrid("load",{ClassName:"web.DHCPE.DHCPEExpertDiagnosis",QueryName:"QueryED",Code:getValueById("Code"),
			DiagnoseConclusion:getValueById("DiagnoseConclusion"),
			Alias:getValueById("Alias"),
			StationID:$("#StationID").combobox("getValue"),
			ChartID:"",
			HighRisk:HighRisk,
			ActiveFlag:ActiveFlag,
			StationName:""}); 
	
}