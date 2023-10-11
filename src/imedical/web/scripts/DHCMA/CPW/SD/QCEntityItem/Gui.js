//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.ParrefID="";
	obj.QCVerID="";  //病种选择版本
	obj.HisVerID="";  //对照历史版本
	obj.ItemID=""
    $.parser.parse(); // 解析整个页面
    $('#winQCEntityItem').dialog({
		title: '质控项目维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});	
	$('#winQCItemRule').dialog({
		title: '项目校验规则维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});
	$('#winQCItemDicDif').dialog({
		title: '对照项目值域差异列表',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true
	});
	$('#winQCItemMatch').dialog({
		title: '标准数据源配置',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true,
		onClose:function(){
			obj.gridQCEntityItemLoad()
		}
		
	});	 
    obj.gridQCEntity =$HUI.datagrid("#gridQCEntity",{
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCEntitySrv",
			QueryName:"QryQCEntity",
			rows:10000					//不传默认50，大坑！！		
	    },
		columns:[[
			{field:'BTDesc',title:'病种名称',width:'250',sortable:true},
			{field:'BTCode',title:'编码',width:'150',sortable:true},
			{field:'BTAbbrev',title:'缩写',width:'150',sortable:true},
			{field:'BTIsActive',title:'是否有效',width:'150',align:'center'},
			{field:'BTIndNo',title:'排序码',width:'150',sortable:true},
			{field:'BTPubdate',title:'发布时间',width:'150'}
			//{field:'BTID',title:'RowID',hidden:true}	
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridQCEntity_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){

		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	$HUI.combobox("#GetDataParam",{
					})
	obj.BTType=$HUI.combobox("#BTType",{
				url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=SDType',
				valueField:'BTID',
				textField:'BTDesc'
				})
	obj.BTExpress=$HUI.combobox("#BTExpress",{
				url:$URL+'?ClassName=DHCMA.CPW.SDS.QCExpressSrv&QueryName=QryQCExpress&ResultSetType=Array&aExpType=GetValue',
				valueField:'BTID',
				textField:'BTDesc',
				onSelect: function(r){
					$('#GetDataParam').combobox('clear');//清空选中项
					if (r.BTCode=="BaseInfo") {
						$HUI.combobox("#GetDataParam",{
							url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryClassProperty&ResultSetType=Array&aClassName=DHCMA.Util.EPx.Episode',
							valueField:'PropertyName',
							textField:'PropertyName',	
						})
					}else if (r.BTCode=="ORInfo") {
						$HUI.combobox("#GetDataParam",{
							url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryClassProperty&ResultSetType=Array&aClassName=DHCMA.CPW.SD.Data.Operation',
							valueField:'PropertyName',
							textField:'PropertyName',	
						})
					}else{
						$('#GetDataParam').combobox('loadData', {});
					}
				}
				})	
	obj.BTLinkItem=$HUI.combobox("#BTLinkItem",{
				url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryQCEntityItem&ResultSetType=Array',
				valueField:'BTID',
				textField:'BTDesc'
				})
	obj.BTUpType=$HUI.combobox("#BTUpType",{
				url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=SDUpType',
				valueField:'BTID',
				textField:'BTDesc'
				})	 
	obj.QCVersion=$HUI.combobox("#QCVersion",{
		url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityVersionSrv&QueryName=QryQCEntityVer&ResultSetType=Array',
		valueField:'BTID',
		textField:'BTCode',
		placeholder:'版本选择',
		onSelect:function(record){
			obj.QCVerID=record.BTID
			obj.gridQCEntityItemLoad();
			$("#ItemVersion").lookup({
				width:110,
				panelWidth:500,
				placeholder:'请选择版本',
				url:$URL,
				mode:'remote',
				idField:'BTID',
				textField:'BTCode',
				 queryParams:{
				    ClassName:"DHCMA.CPW.SDS.QCEntityVersionSrv",
					QueryName:"QryQCEntityVer",
					aQCID:obj.ParrefID,
					aVersion:obj.QCVersion.getValue()			
			    },
				columns:[[  
					{field:'BTCode',title:'版本',width:90},  
					{field:'BTDesc',title:'版本描述',width:200} ,
					{field:'SDate',title:'启用日期',width:100} ,
					{field:'SDate',title:'截止日期',width:100} 
				]],
				onSelect:function(index,rowData){
					obj.HisVerID=rowData.BTID
					obj.gridQCEntityItemVer.load({
					    ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
						QueryName:"QryQCEntityItem",
						aParRef:obj.ParrefID,
						aVersion:obj.HisVerID	
					}) ;
				}
			});
			$("#ItemVersion").lookup('reset');
			obj.gridQCEntityItemVer.loadData([]);
		}
	})
	obj.gridQCEntityItem = $HUI.datagrid("#gridQCEntityItem",{
		fit:true,
		title: "质控项目维护",
		iconCls:"icon-template",
		toolbar:'#custtb',
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:false,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,50],
	    nowrap:false,
		columns:[[	
			{field:'BTCode',title:'代码',width:'150',sortable:true},
			{field:'BTDesc',title:'描述',width:'180',sortable:true},
			{field:'StandConfig',title:'数据源配置',width:'120',sortable:true,
				formatter: function(value,row,index){
					if (value=="1") {
						return '<a href="#" class="hisui-linkbutton" onclick=objScreen.ShowItemStand("'+row.BTID+'")><span style="color:green;">编辑</span></a>';
					}else if (value=="2") {
						return '已自动匹配';
					}else{
						return '<a href="#" class="hisui-linkbutton" onclick=objScreen.ShowItemStand("'+row.BTID+'")>新建</a>';
					}
				}
			},
			{field:'BTTypeDesc',title:'类型',width:'80',align:'center'},
			{field:'BTUpTypeDesc',title:'上传类型',width:'80',align:'center'},
			{field:'BTIndNo',title:'序号',width:'50',sortable:true},
			{field:'BTItemCat',title:'项目大类',width:'180',align:'center'},
			{field:'BTItemSubCat',title:'项目子类',width:'180',align:'center'},
			{field:'BTIsActive',title:'是否<br>有效',align:'center',width:'60',sortable:true},
			{field:'BTIsNeeded',title:'是否<br>必填',align:'center',width:'60',sortable:true},
			{field:'BTExpressCode',title:'取值表达式',width:'120',sortable:true},
			{field:'GetDataParam',title:'取值参数',width:'100',sortable:true},
			{field:'ValiRule',title:'校验规则',width:'100',sortable:true,align:'center',
				formatter: function(value,row,index){
						if (value!="") {
							return '<a href="#" class="hisui-linkbutton" onclick=objScreen.ShowItemRule("'+row.BTID+'")><span style="color:green;">查看</span></a>';
						}else{
							return '<a href="#" class="hisui-linkbutton" onclick=objScreen.ShowItemRule("'+row.BTID+'")>添加</a>';
						}
				}
			},
			{field:'BTLinkedItemDesc',title:'关联项目',width:'150',sortable:true},			
			{field:'BTTriggerCondition',title:'关联触<br>发条件',width:'60',sortable:true},			
			{field:'BTResume',title:'备注',width:'60',sortable:true}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridQCEntityItem_onDbselect(rowData);
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridQCEntityItem_onSelect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	obj.gridQCEntityItemVer = $HUI.datagrid("#gridQCEntityItemVer",{
		fit:true,
		toolbar:'#Verttb',
		pagination: true,
		displayMsg:'共{total}条',
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:false,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    nowrap:false,
	    bodyCls:'no-border',
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
			QueryName:"QryQCEntityItem",
			aParRef:obj.ParrefID,
			aVersion:obj.HisVerID			
	    },
		columns:[[	
			{field:'BTCode',title:'代码',width:'150',sortable:true},
			{field:'BTDesc',title:'描述',width:'180',sortable:true},	
			{field:'MatchItemCode',title:'对照项目',width:'120',sortable:true},	
			{field:'MatchItemDesc',title:'描述',width:'120',sortable:true}
		]],
		onDblClickRow:function(rowIndex,rowData){

		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridQCEntityItemVer_onSelect(rowData);
			}
		},
		onLoadSuccess:function(data){
		}
	});
	//数据源组件

	//加载数据源和输出字段
	obj.GetField=$HUI.combobox("#GetField",{});
	obj.StandDic=$HUI.combobox("#StandDic",{});
	obj.StandDicSub=$HUI.combobox("#StandDicSub",{});
	obj.Source=$HUI.combobox("#Source",{
		url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=SDSource',
		valueField:'BTID',
		textField:'BTDesc',
		editable:false,
		onSelect:function(rd){
			obj.StandDic.setValue('');
			obj.StandDicSub.setValue('');
			obj.GetField.setValue('');	
			obj.GetField=$HUI.combobox("#GetField",{
				url:$URL+'?ClassName=DHCMA.CPW.SD.StandSrv.SourceSrv&QueryName=QrySourceOutput&ResultSetType=Array&aSourceID='+rd.BTID,
				valueField:'Code',
				textField:'Desc',
				editable:false
			})
			obj.StandDic=$HUI.combobox("#StandDic",{
				url:$URL+'?ClassName=DHCMA.CPW.SD.StandSrv.DicSrv&QueryName=QryStandDic&ResultSetType=Array&aSourceID='+rd.BTID,
				valueField:'RowID',
				textField:'Desc',
				editable:false,
				onSelect:function(rdDic){
					obj.StandDicSub=$HUI.combobox("#StandDicSub",{
						url:$URL+'?ClassName=DHCMA.CPW.SD.StandSrv.DicSrv&QueryName=QryDicList&ResultSetType=Array&aSourceID='+rd.BTID+"&aDicID="+Common_GetValue('StandDic'),
						valueField:'RowID',
						textField:'Desc',
						editable:false,
						onSelect:function(){
							obj.GetField=$HUI.combobox("#GetField",{
								url:$URL+'?ClassName=DHCMA.CPW.SD.StandSrv.SourceSrv&QueryName=QrySourceOutput&ResultSetType=Array&aSourceID='+Common_GetValue('Source')+'&aSubFlg='+(Common_GetValue('StandDicSub')?1:''),
								valueField:'Code',
								textField:'Desc',
								editable:false
							})	
						}
					})
					
				}
			})
			obj.StandDic.setValue('');
			obj.StandDicSub.setValue('');
			obj.GetField.setValue('');	
		}
		,onLoadSuccess:function(data){
		}
	})
	obj.GetTiming=$HUI.combobox("#GetTiming",{
		url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=SDItemGetValTime',
		valueField:'BTID',
		textField:'BTDesc',
		editable:false
	})
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


