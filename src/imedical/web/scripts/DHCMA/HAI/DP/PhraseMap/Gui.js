//页面Gui
objScreen=new Object();
function InitPhraseMapWin(){
	var obj = objScreen;
	obj.RecRowID= "";
    
	obj.gridPhraseMap = $HUI.datagrid("#gridPhraseMap",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.DPS.PhraseMapSrv",
			QueryName:"QryPhraseMapByType"
		},
		columns:[[
			{field:'ID',title:'ID',width:70,sortable:true},
			{field:'Code',title:'代码',width:200,sortable:true},
			{field:'Desc',title:'名称',width:240}, 
			{field:'PhraseTypeDesc',title:'分类名称',width:240},
			{field:'MapDicDesc',title:'标准名称',width:240},
			{field:'SCode',title:'子系统代码',width:120},
			{field:'IsActive',title:'有效标志',width:70,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPhraseMap_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPhraseMap_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.qryPhraseMap=function(aTypeId){
		var PhraseTypeId=aTypeId;
		obj.gridPhraseMap.load({
			ClassName:"DHCHAI.DPS.PhraseMapSrv",
			QueryName:"QryPhraseMapByType",
			aTypeID:aTypeId
		});
		// 字典分类
		obj.cboMapDic = $HUI.combobox("#cboMapDic", {
			url:$URL+'?ClassName=DHCHAI.DPS.PhraseMapSrv&QueryName=QryDicByPhraseTypeID&ResultSetType=array&aPTypeID='+PhraseTypeId,
			valueField: 'ID',
			textField: 'DicDesc',
		})
	}
    //常用短语列表
	var runQuery =$cm({
		ClassName:'DHCHAI.DPS.PhraseTypeSrv',
		QueryName:'QryPhraseType'
	},false);
	if(runQuery){
		var arrMap = runQuery.rows;
		var strHtml=" <ul>"
		for (var indMap = 0; indMap < arrMap.length; indMap++){
			var rd = arrMap[indMap];
			if (!rd) continue;
			if (indMap=="0"){
				obj.qryPhraseMap(rd["ID"]);
				strHtml+="<li class='active' id=\""+rd["ID"]+"\"><a href='javascript:void(0);' onclick='objScreen.qryPhraseMap(\""+rd["ID"]+"\");' class='api-navi-tab'>"+rd["Desc"]+"</a></li>";
				continue;
			}
			strHtml+="<li id=\""+rd["ID"]+"\"><a href='javascript:void(0);' onclick='objScreen.qryPhraseMap(\""+rd["ID"]+"\");' class='api-navi-tab'>"+rd["Desc"]+"</a></li>";
		}
		strHtml+=" </ul>"
		$('#ulPhraseType').html(strHtml); 
		$.parser.parse('#ulPhraseType');
	}
	$('.api-navi-tab').on('click',function(){
            $(".hisui-accordion ul>li.active").removeClass('active'); 
            $(this).closest("li").addClass('active');
	})
	
	
	
	InitPhraseMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;

}
$(InitPhraseMapWin);
