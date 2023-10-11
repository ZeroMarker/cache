//页面Gui
var obj = new Object();
function InitHISUIWin(){	
	$.parser.parse();
	
	//合并症路径
	obj.pathList = $HUI.datagrid("#gridCompl",{
		url:$URL,
		fit:true,
		title:$g("合并症路径列表"),
		loadMsg:$g('数据加载中...'),
		iconCls:'icon-resort',
		headerCls:'panel-header-gray',
		singleSelect:false,
		checkOnSelect:false,
		autoRowHeight: false,
		pagination:true,
		pageSize: 20,
		pageList : [10,20,50,100,200],
		queryParams:{
			ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
			QueryName:"QryComplPathMast",
			aPathwayID:PathwayID,
			aKeyWord:"",
			aHospID:session['DHCMA.HOSPID'],
			aAdmType:"I"
		},		
		columns:[[
			{field:'Operation',title:'操作',align:'center',width:'80',formatter: function(value,row,index){
				if (parseInt(row.isChked)==0) {
					return '<span class="imgRef icon-ref" title='+$g("点击关联")+' onclick="obj.CheckComplRec(\''+ index +'\',1)" style="cursor:pointer;margin:0 10px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>';
				}
				else if (parseInt(row.isChked)==1) {
					return '<span class="imgCancelRef icon-cancel-ref" title='+$g("点击取消")+' onclick="obj.CheckComplRec(\''+ index +'\',0)" style="cursor:pointer;margin:0 10px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>';
				}else return "";
			}},		
			{field:'BTDesc',width:'430',title:'合并症路径',align:'center'},
			{field:'ComplFormVer',width:'50',title:'版本',align:'center'},
			{field:'ViewForm',width:'80',title:'表单预览',align:'center',formatter:function(v,r,i){
				return '<span class="paper-info icon-paper-info" title='+$g("预览")+' onclick="obj.ViewForm('+r.ComplFormID+')" style="cursor:pointer;margin:0 10px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>';
			}},
			{field:'RefDate',width:'120',title:'关联日期',align:'center'},	
			{field:'RefTime',width:'80',title:'关联时间',align:'center'},
			{field:'ActUserName',width:'80',title:'执行人',align:'center'}
		]],
		rowStyler: function(index,row){
			if (parseInt(row.isChked)>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		}
	});
	
	//搜索框定义
	$('#txtSearch').searchbox({ 
		searcher:function(value,name){
			$cm ({
			 	ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
				QueryName:"QryComplPathMast",
				aPathwayID:PathwayID,
				aKeyWord:value,
				aHospID:session['DHCMA.HOSPID'],
				aAdmType:"I"
			},function(rs){
				$('#gridCompl').datagrid('loadData', rs);
							
			});
		}, 
		prompt:$g('请输入值') 
	}); 
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
