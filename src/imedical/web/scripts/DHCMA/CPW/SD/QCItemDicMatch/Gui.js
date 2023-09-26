//页面Gui
var objScreen = new Object();
 $.extend($.fn.datagrid.methods, {  
	 updateColumn: function(datagrid,data) {  
	     datagrid.each(function(){  
	         //获取缓存中的配置数据  
	         var gridObj=$.data(this,"datagrid");  
	         var opts=gridObj.options;  
	         //获取行数据  
	         var row=opts.finder.getRow(this,data.index);  
	         data.row=data.row||{};  
	         var update=false;  
	         //判断是否需要更新  
	         for(var updateColumn in data.row){  
	             if(data.row[updateColumn]!==row[updateColumn]){  
	                 update=true;  
	                 break;  
	             }  
	         }  
	         if(update){  
	             var tr=opts.finder.getTr(this,data.index);  
	             var view=opts.view.renderRow.call(opts.view,this,["attr1"],true,data.index,data.row);  
	             if(tr.hasClass("datagrid-row-editing")){  
	                 //找到所有需要更新值的列  
	                 tr.find('div').each(function(i){  
	                     if(data.row[$(this).parent().attr('field')]!=undefined){  
	                         if($(this).attr('class').indexOf('datagrid-editable')!=-1){  
	                             var ed=$.data(this,"datagrid.editor");  
	                             if(ed!=undefined){  
	                                 ed.actions.setValue(ed.target,data.row[$(this).parent().attr('field')]);  
	                             }else{  
	                                 $(this).html(data.row[$(this).attr('field')]);  
	                             }                                             
	                         }else{  
	                             $(this).html(data.row[$(this).attr('field')]);  
	                             $(this).addClass("datagrid-editable"); 
	                         }  
	                     }  
	                 });  
	             }  
	         }  
	     });  
	 }  
});
function InitviewScreen(){
	var obj = new Object();
	obj.optionID=""
    $.parser.parse(); // 解析整个页面 
    $('#ItemOptions').tree({
		url:$URL+"?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryQCItemTree&aActvie=1&ResultSetType=array"	
		,onLoadSuccess:function(node,data)
		{
			//回调
		},
		onExpand:function(node)
			{
				obj.refreshNode(node);			
			},
		lines:true
	})
 	//监听事件
	$('#ItemOptions').tree({
			onClick:function(node){	
				obj.gridQCItemDic.load({
					ClassName:"DHCMA.CPW.SDS.DictionarySrv",
					QueryName:"QryDictByType",
					aTypeCode:node.code
					});
				$('#gridQCItemDicMatch').datagrid("loadData", { total: 0, rows: [] }); 
				$("#btnAdd").linkbutton('disable');
				$("#btnSave").linkbutton('disable');
				$("#btnDelete").linkbutton('disable');
			}
			
	})
	
	$('#AntiKey').searchbox({
	    searcher:function(value,name){
		    obj.LoadAntiTree(value,$('#AntiChecked').checkbox('getValue'))
	    },
	    prompt:'请输入关键字'
	});
	$('#AntiChecked').checkbox({
		onCheckChange:function(){
			obj.LoadAntiTree($('#AntiKey').val(),$('#AntiChecked').checkbox('getValue'))
			}
		})
	obj.gridQCItemDic = $HUI.datagrid("#gridQCItemDic",{
		fit:true,
		title: "项目值域",
		iconCls:"icon-apply-check",
		headerCls:'panel-header-gray',
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:true,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCItemOptionsSrv",
			QueryName:"QryQCItemOptions",
			aItemDr:""
	    },
		columns:[[	
			{field:'BTCode',title:'代码',width:'100',sortable:true},
			{field:'BTDesc',title:'描述',width:'250',sortable:true},
			{field:'BTIsActive',title:'是否<br>有效',width:'50',align:'center',
				formatter:function(v,r,i){
				  if (r.BTIsActive=="1") {
					  	return "是";
					}else{
						return "否";
						}
				}
			},
			{field:'BTActDate',title:'操作日期',width:'100',align:'center'},
			{field:'BTActTime',title:'操作时间',width:'100',align:'center'},
			{field:'BTActUserID',title:'操作人ID',align:'center',width:'80',sortable:true},
			{field:'BTIndNo',title:'排序',align:'center',width:'60',sortable:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {		
				obj.gridQCItemDic_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){	
		},
		onLoadSuccess:function(data){
			obj.optionID="";
			$('#AntiTree').tree({
				data: []
			})
		}
	});
	/*HIS医嘱项对照*/
	obj.OMType = $HUI.combobox("#OMType",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1',text:'按医嘱'},
			{id:'2',text:'按药品通用名'},
			{id:'3',text:'按药品分类'}
		]
	});
	obj.gridQCItemDicMatch = $HUI.datagrid("#gridQCItemDicMatch",{
		fit:true,
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:false,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    bodyCls:'no-border',
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCOptionMatchSrv",
			QueryName:"QryQCItemOptionMatch",
			aOptionDr:obj.optionID
	    },
	    idField:'OMArcimID',
		columns:[[	
			{field:'OMType',title:'对照类型',width:'100',sortable:true,
				formatter:function(v,r){					
						return r.OMTypeDesc
						},
				editor:{
		                type:'combobox',
						options:{
							valueField:'id',
							textField:'text',
							selectOnNavigation:true,
							panelHeight:"auto",
							editable:false,
							data:[
								{id:'1',text:'按医嘱'},
								{id:'2',text:'按药品通用名'},
								{id:'3',text:'按药品分类'}
							]
						}
			}
			},
			{field:'OMArcimID',title:'医嘱项',width:'450',sortable:true,
						formatter:function(v,r){					
							return r.OMArcimDesc
						},
						editor:{
							type:'combobox',
							options:{
								mode:'remote',
								url:$URL,
								selectOnNavigation:true,
								valueField:'ArcimID',
								textField:'ArcimDesc',
								onSelect:function(rd){
									autoLoadArcMsg(rd);
								},
								onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作									
									var Input=$(this).combobox('getText');
									if (Input=="") {
										var rowData = obj.gridQCItemDicMatch.getSelected();
										Input=rowData.OMArcimDesc
										Input=Input.split('[')[0]
										Input=Input.split('(')[0]
									}
				                 	if (Input.length<2) return;				                 	
									param.ClassName = 'DHCMA.CPW.BTS.LinkArcimSrv';
									param.QueryName = 'QryArcimByAlias';
									param.ResultSetType = 'array';
									param.q = Input;
								}
							}
						}
			},
			{field:'OMPHCGeneric',title:'通用名',width:'150',align:'center',
				editor:{type:'text'}},
			{field:'OMCategory',title:'药品分类',width:'150',align:'center',
				editor:{type:'text'}},,
		]],
		onSelect:function(rindex,rowData){

		},
		onDblClickRow:function(rowIndex,rowData){	
		},
		onBeginEdit: function () {    //在编辑之前触发
		},
		onClickRow:onClickRow,
		onLoadSuccess:function(data){
			
		}
	});
	obj.endEditing=function(){
			if (editIndex == undefined){return true}
			if ($('#gridQCItemDicMatch').datagrid('validateRow', editIndex)){
				var ed = $('#gridQCItemDicMatch').datagrid('getEditor', {index:editIndex,field:'OMArcimID'});
				var OMArcimDesc = $(ed.target).combobox('getText');
				$('#gridQCItemDicMatch').datagrid('getRows')[editIndex]['OMArcimDesc'] = OMArcimDesc;
				var ed = $('#gridQCItemDicMatch').datagrid('getEditor', {index:editIndex,field:'OMType'});
				var OMTypeDesc = $(ed.target).combobox('getText');
				$('#gridQCItemDicMatch').datagrid('getRows')[editIndex]['OMTypeDesc'] = OMTypeDesc;
				$('#gridQCItemDicMatch').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
	function onClickRow(index){
				if (editIndex!=index) {
					if (obj.endEditing()){
						$('#gridQCItemDicMatch').datagrid('selectRow', index)
								.datagrid('beginEdit', index);
						editIndex = index;
					} else {
						$('#gridQCItemDicMatch').datagrid('selectRow', editIndex);
					}
				}else{
					obj.endEditing();
					}
			}
	function autoLoadArcMsg(arc) {
		$m({
			ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",
			MethodName:"GetArcimInfoById",
			aArcimID:arc.ArcimID
			},function(retData){
				var retArr = retData.split("^");	
				var PHCGeneDesc=retArr[15];
				var PHCCatDesc=retArr[16];
	           $('#gridQCItemDicMatch').datagrid('updateColumn',{index:editIndex,row:{OMPHCGeneric:PHCGeneDesc,OMCategory:PHCCatDesc}})   
			})
		}
	/*HIS医嘱项对照End*/

	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}

