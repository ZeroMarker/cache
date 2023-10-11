//页面Gui
objScreen=new Object();
function InitPhraseMapWin(){
	var obj = objScreen;
	obj.RecRowID= "";
    
	obj.gridDictionary = $HUI.datagrid("#gridDictionary",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'DicCode',title:'代码',width:300,sortable:true},
			{field:'DicDesc',title:'名称',width:300}, 
			//{field:'TypeDesc',title:'分类名称',width:300},
			{field:'IndNo',title:'排序码',width:120},
			{field:'IsActDesc',title:'有效标志',width:50}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDictionary_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDictionary_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.qryDictionaryLoad=function(aTypeId){
		originalData["gridDictionary"]="";
		$cm({
			ClassName:"DHCHAI.BTS.DictionarySrv",
			QueryName:"QryDictionary",
			aTypeID:aTypeId,
			page:1,
			rows:9999
		},function(rs){
			$('#gridDictionary').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
		});
	}
	//字典类型列表
	obj.refreshDicType=function(aText){
		var runQuery =$cm({
			ClassName:'DHCHAI.BTS.DicTypeSrv',
			QueryName:'QrySortDicType',
			page:1,
			rows:9999
		},false);
		if(runQuery){
			var arrMap = runQuery.rows;
			tabsLength=arrMap.length;
			var strHtml=" <ul>"
			for (var indMap = 0; indMap < arrMap.length; indMap++){
				var rd = arrMap[indMap];
				if (!rd) continue;
				if((aText!="")&&(rd["Desc"].indexOf(aText)<0)) continue;	//过滤搜索内容
				if (indMap=="0"){
					obj.qryDictionaryLoad(rd["ID"]);
					strHtml+="<li class='active' id=\""+rd["ID"]+"\"><a href='javascript:void(0);' onclick='objScreen.qryDictionaryLoad(\""+rd["ID"]+"\");' class='api-navi-tab'>"+rd["Desc"]+"</a></li>";
					continue;
				}
				strHtml+="<li id=\""+rd["ID"]+"\" style='border-bottom: 1px solid #e2e2e2;'><a href='javascript:void(0);' onclick='objScreen.qryDictionaryLoad(\""+rd["ID"]+"\");' class='api-navi-tab'>"+rd["Desc"]+"</a></li>";
			}
			strHtml+=" </ul>"
			$('#ulDicType').html(strHtml); 
			$.parser.parse('#ulDicType');
		}
		$('.api-navi-tab').on('click',function(){
            $(".hisui-accordion ul>li.active").removeClass('active'); 
            $(this).closest("li").addClass('active');
            $('#searchbox').searchbox('setValue',"");
     	})
	}
	obj.refreshDicType("");
    //加载'字典类型搜索框'
    var strHtml	='<div class="hisui-panel" style="border-radius:0;border-top:0px;border-right:0px;border-left:0px">'
				+'	<div style="float:right;padding:10px 10px 10px 0px;">'
				+'		<span class="r-label" style="margin-left: -5px;">搜索</span><input class="hisui-searchbox" id="searchDicType" style="width:220px;padding-right:0px"/>'
				+'	</div>'
				+'</div>';
	$('#ulDicType').before(strHtml);
	$.parser.parse();
    
	InitPhraseMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;

}
$(InitPhraseMapWin);