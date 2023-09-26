//页面gui
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
	var obj = objScreen;
	obj.editIndex=undefined;
    $.parser.parse(); // 解析整个页面
	var jsonstr = $m({
		ClassName:"DHCMA.CPW.SDMatchSrv.AntiCatSrv",
		MethodName:"GetCatJsonTree"
	},false);
	if (jsonData=="") return;
	var jsonData=eval('(' + jsonstr + ')');
	$('#mytt').tree({
		data: [jsonData],
		formatter:function(node){
				return node.text;
		},
		onClick: function (node) {
			if(node.id.length<5) {
				$('#mytt').tree('toggle', node.target); //简单单吉展开关闭
			}else{
				obj.gridAntiItem.load({
					ClassName:"DHCMA.CPW.SDMatchSrv.AntiItemSrv",
					QueryName:"QryAntiItem",
					aAntiCat:node.id
				});
				obj.gridAntiItemDicMatch.loadData([]);
			}
		}
	})
    obj.gridAntiItem = $HUI.datagrid("#gridAntiItem",{
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		striped:true,
		fitColumns:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    nowrap:false,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDMatchSrv.AntiItemSrv",
			QueryName:"QryAntiItem",
			aAntiCat:""
	    },
		columns:[[	
			{field:'BTCode',title:'代码',width:'100',sortable:true},
			{field:'BTDesc',title:'描述',width:'250',sortable:true},		
			{field:'EName',title:'英文名',width:'180'},
			{field:'IsActive',title:'是否<br>有效',width:'50',align:'center'},
			{field:'Resume',title:'备注',width:'100'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {		
				obj.gridAntiItem_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){	
		},
		onLoadSuccess:function(data){
		}
	});
	obj.gridAntiItemDicMatch = $HUI.datagrid("#gridAntiItemDicMatch",{
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:false,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDMatchSrv.AntiItemMatchSrv",
			QueryName:"QryAntiItemMatch",
			aAntiItemDr:obj.AntiItemDr
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
								{id:'2',text:'按通用名'}
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
										var rowData = obj.gridAntiItemDicMatch.getSelected();
										Input=rowData.OMArcimDesc
										Input=Input.split('[')[0]
										Input=Input.split('(')[0]
									}
				                 	if (Input.length<2) return;				                 	
									param.ClassName = 'DHCMA.CPW.SDMatchSrv.AntiItemMatchSrv';
									param.QueryName = 'QryArcimByAlias';
									param.ResultSetType = 'array';
									param.q = Input;
									param.aHospID = session['DHCMA.HOSPID'];
								}
							}
						}
			},
			{field:'OMPHCGeneric',title:'通用名',width:'150',align:'center',
				editor:{type:'text'}}
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
			if ($('#gridAntiItemDicMatch').datagrid('validateRow', editIndex)){
				var ed = $('#gridAntiItemDicMatch').datagrid('getEditor', {index:editIndex,field:'OMArcimID'});
				var OMArcimDesc = $(ed.target).combobox('getText');
				$('#gridAntiItemDicMatch').datagrid('getRows')[editIndex]['OMArcimDesc'] = OMArcimDesc;
				var ed = $('#gridAntiItemDicMatch').datagrid('getEditor', {index:editIndex,field:'OMType'});
				var OMTypeDesc = $(ed.target).combobox('getText');
				$('#gridAntiItemDicMatch').datagrid('getRows')[editIndex]['OMTypeDesc'] = OMTypeDesc;
				$('#gridAntiItemDicMatch').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
	function onClickRow(index){
				if (editIndex!=index) {
					if (obj.endEditing()){
						$('#gridAntiItemDicMatch').datagrid('selectRow', index)
								.datagrid('beginEdit', index);
						editIndex = index;
					} else {
						$('#gridAntiItemDicMatch').datagrid('selectRow', editIndex);
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
	           $('#gridAntiItemDicMatch').datagrid('updateColumn',{index:editIndex,row:{OMPHCGeneric:PHCGeneDesc}})   
			})
		}
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}