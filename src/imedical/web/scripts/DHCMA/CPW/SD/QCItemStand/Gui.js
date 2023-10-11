//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.SourceID=""
	obj.DicID=""
	//阻止反选全部：选择标准字典清除缓存选中医嘱时，需要清空所有选择项。此变量全局实现只反选,不保存。
	obj.PreventUnAC=0
    $.parser.parse(); // 解析整个页面 
    $('#DicMatch-tb').tabs({
	  onSelect: function(title,index){
		var tab = $('#DicMatch-tb').tabs('getTab',index);
		var tabID=tab[0].id
		$.parser.parse("#"+tabID); 
	  }
	});
	$('#winStandAlias').dialog({
		title: '标准字典别名维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true,
		onClose:function(){
			obj.gridQCStandDic.reload();
			obj.DicID=""
			obj.LoadStandDicMatch('',"") ;	
			$("#btnEdit").linkbutton("disable");
			
			$("#btnDelete").linkbutton("disable");
		}
		
	});
    $HUI.combobox('#source',
	{
		url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=SDSource',
		valueField:'BTID',
		textField:'BTDesc',	
		selectOnNavigation:false,
		panelWidth:"200",
		panelHeight:"400",
		onSelect:function(rd){
			var SourceDesc=rd.BTDesc
			if (SourceDesc.indexOf("基础")>-1) {
				$('#DicMatch-tb').tabs('select',4);
			}else if ((SourceDesc.indexOf("常用")>-1)||(SourceDesc.indexOf("既往")>-1)||(SourceDesc.indexOf("症状")>-1)) {
				$('#DicMatch-tb').tabs('select',5);
			}else {
				$('#DicMatch-tb').tabs('select',1);
			}
			obj.SourceID=rd.BTID;
			obj.DicID=""
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$HUI.combobox('#standDic',
			{
				url:$URL+'?ClassName=DHCMA.CPW.SD.StandSrv.DicSrv&QueryName=QryStandDic&ResultSetType=Array&aSourceID='+rd.BTID,
				valueField:'RowID',
				textField:'Desc',	
				panelWidth:"200",
				panelHeight:"400",
				selectOnNavigation:false,
				onSelect:function(dicrd){
					obj.DicID='';
					$("#btnAdd").linkbutton("enable");
					$("#btnEdit").linkbutton("disable");
					$("#btnDelete").linkbutton("disable");
					obj.gridQCStandDic.reload({
						ClassName:"DHCMA.CPW.SD.StandSrv.DicSrv",
						QueryName:"QryDicList",
						aSourceID:obj.SourceID,
						aDicID:dicrd.RowID,
						rows:999
					});
					obj.LoadStandDicMatch();
				},
				onChange:function(e){
					if (e==""){
						obj.gridQCStandDic.reload({
						ClassName:"DHCMA.CPW.SD.StandSrv.DicSrv",
						QueryName:"QryDicList",
						aSourceID:obj.SourceID,
						aDicID:"",
						rows:999
					});
					obj.gridQCStandDicMatch.loadData([]);
					}
				} 		    
			})
			Common_SetValue('standDic','');
			obj.gridQCStandDic.reload({
						ClassName:"DHCMA.CPW.SD.StandSrv.DicSrv",
						QueryName:"QryDicList",
						aSourceID:obj.SourceID,
						aDicID:obj.DicID,
						rows:999
			});
			obj.LoadStandDicMatch();
		} 		    
	})
	$('#OrderKey').searchbox({
	    searcher:function(value){
		    obj.LoadStandDicMatch()
	    },
	    prompt:'医嘱关键字'
	});
	obj.gridQCStandDic = $HUI.datagrid("#gridQCStandDic",{
		fit:true,
		title: "项目相关字典",
		toolbar:'#standtb',
		iconCls:"icon-apply-check",
		headerCls:'panel-header-gray',
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:true,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
		nowrap:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SD.StandSrv.DicSrv",
			QueryName:"QryDicList",
			aSourceID:obj.SourceID,
			aDicID:obj.DicID,
			rows:999
	    },
		columns:[[	
			
			{field:'Desc',title:'描述',width:'200',sortable:true,		
				styler: function(value,row,index){
					var Connectinfo=row.ConnectInfo
					if (Connectinfo.indexOf("1")>-1) {
						return 'color:#39ac73;';
					}
				}
			},
			
			{field:'Alias',title:'别名',width:'70',sortable:true,
				formatter: function(value,row,index){
						if (value!="") {
							return '<a href="#" class="hisui-linkbutton" onclick=objScreen.ShowAlias("'+row.RowID+'")><img src="../scripts/DHCMA/img/search.png"/></a>';
						}else{
							return '<a href="#" class="hisui-linkbutton" onclick=objScreen.ShowAlias("'+row.RowID+'")><img src="../scripts/DHCMA/img/add.png"/></a>';
						}
					}
			},
			{field:'Resume',title:'备注',width:'100',align:'center'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {		
				obj.gridQCStandDic_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){	
			obj.layer(rowData);
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.gridQCStandDicMatch = $HUI.datagrid("#gridQCStandDicMatch",{
		fit:true,
		singleSelect: false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:true,
		striped:true,
		rownumbers:true, 
		checkOnSelect:true, 
		selectOnCheck:true, 
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 10,
		pageList : [10,50],
		loadMsg:'数据加载中...',
	    url:$URL,
	    bodyCls:'no-border',
	    idField :'RowID',
	    queryParams:{
		    ClassName:"DHCMA.CPW.SD.StandSrv.OrderSrv",
			QueryName:"QryHisOrder",
			aSourceID:''
	    },
		columns:[[	
			{field:'checked',checkbox:'true',align:'center',width:30,auto:false},
			{field:'Desc',title:'医嘱项',width:300,sortable:true},
			{field:'CatDesc',title:'分类',width:100,align:'center'},
			{field:'IsActive',title:'是否有效',width:100,align:'center',
				formatter: function(value,row,index){
						if (value=="1") {
							return '是';
						}else{
							return '否';
						}
				}
			}
		]],
		onCheck:function(rindex,rowData){
			if (rowData.checked!=1) obj.btnMatch_click();
		},
		onCheckAll:function(rindex,rowData){
			obj.btnMatch_click();
		},
		onUncheck:function(rindex,rowData){
			if (rowData.checked==1) 
			{
				obj.btnMatch_click();
			}
		},
		onUncheckAll:function(rindex,rowData){
			if (obj.PreventUnAC==0){
				obj.btnMatch_click();
			}else{
				obj.PreventUnAC=0;
			}
		},
		onLoadSuccess:function(data){
			var rowData = data.rows;
            $.each(rowData,function(idx,val){//遍历JSON
                  if(val.checked==1){
                    $('#gridQCStandDicMatch').datagrid("selectRow", idx);//如果数据行为已选中则选中改行
                  }else{
	                $('#gridQCStandDicMatch').datagrid("unselectRow", idx); 
	              }
            });
		}
	});
	/*HIS医嘱项对照End*/
	/*检验项目对照*/
	obj.gridLisItemMatch = $HUI.datagrid("#gridLisItemMatch",{
		fit:true,
		singleSelect: false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		//fitColumns:true,
		striped:true,
		rownumbers:true, 
		checkOnSelect:true, 
		selectOnCheck:true, 
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 10,
		pageList : [10,50],
		loadMsg:'数据加载中...',
	    url:$URL,
	    bodyCls:'no-border',
	    idField:'RowID',
	    queryParams:{
		    ClassName:"DHCMA.CPW.SD.StandSrv.LabStandSrv",
			QueryName:"QryLisItem",
			aDicID:''
	    },
		columns:[[	
			{field:'checked',checkbox:'true',align:'center',width:'30',auto:false},
			{field:'Code',title:'项目代码',width:'70',sortable:true},
			{field:'Desc',title:'项目描述',width:'200'},
			{field:'ArcDesc',title:'医嘱',width:'210'}
			
		]],
		onCheck:function(rindex,rowData){
			if (rowData.checked!=1) obj.btnLisSave_click(rowData)
		},
		onUncheck:function(rindex,rowData){
			if (rowData.checked==1) obj.btnLisSave_click(rowData)
		},
		onLoadSuccess:function(data){
			var rowData = data.rows;
            $.each(rowData,function(idx,val){//遍历JSON
                  if(val.checked==1){
                    $('#gridLisItemMatch').datagrid("selectRow", idx);//如果数据行为已选中则选中改行
                  }else{
	                $('#gridLisItemMatch').datagrid("unselectRow", idx); 
	              }
            });
		}
	});
	/*检查项目对照*/
	obj.gridRisItemMatch = $HUI.datagrid("#gridRisItemMatch",{
		fit:true,
		singleSelect: false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:false,
		striped:true,
		rownumbers:true, 
		checkOnSelect:true, 
		selectOnCheck:true, 
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		loadMsg:'数据加载中...',
	    url:$URL,
	    bodyCls:'no-border',
	    queryParams:{
		    ClassName:"DHCMA.CPW.SD.StandSrv.RisInfoSrv",
			QueryName:"QryRisItem",
			aSourceID:''
	    },
		columns:[[	
			{field:'checked',checkbox:'true',align:'center',width:'30',auto:false},
			{field:'Code',title:'检查代码',width:'100',sortable:true},
			{field:'Desc',title:'检查医嘱',width:'300'}
		]],
		onCheck:function(rindex,rowData){
			obj.btnRisSave_click();
		},
		onCheckAll:function(rindex,rowData){
			obj.btnRisSave_click();
		},
		onUncheck:function(rindex,rowData){
			obj.btnRisSave_click();
		},
		onUncheckAll:function(rindex,rowData){
			obj.btnRisSave_click();
		},
		onLoadSuccess:function(data){
			var rowData = data.rows;
            $.each(rowData,function(idx,val){//遍历JSON
                  if(val.checked){
	                  
                    $('#gridRisItemMatch').datagrid("selectRow", idx);//如果数据行为已选中则选中改行
                  }else{
	                $('#gridRisItemMatch').datagrid("unselectRow", idx); 
	              }
            });
		}
	});
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}

