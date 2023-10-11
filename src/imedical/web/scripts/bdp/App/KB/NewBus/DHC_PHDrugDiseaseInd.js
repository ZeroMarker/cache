/*
Creator:DingYanan
CreatDate:2018-09-05
Description:知识库编辑器-适应证
*/


//alert(GlPGenDr+","+GlPPointer+","+GlPPointerType)
var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer
//var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseINew&pClassMethod=OpenIndData";  //新版修改方法
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassMethod=SaveIndData&pEntityName=web.Entity.KB.DHCPHDrugDiseaseI";
var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassMethod=UpdateIndData&pEntityName=web.Entity.KB.DHCPHDrugDiseaseI";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassMethod=DeleteData";
var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";

var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassMethod=DeleteDiseaData";
var DELETE_Key_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHKeyWord&pClassMethod=DeleteKeyData";
var DELETE_Organism_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHBTOrganism&pClassMethod=DeleteOrganismData";
var DELETE_Genus_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHBtGenus&pClassMethod=DeleteGenusData";

var mode=""
///初始化主索引列表
function InitMyList()
{

	var gencolumns =[[  
				  {field:'PHINSTText',title:'描述',width:260},
				  {field:'PHINSTRowId',title:'PHINSTRowId',width:30,hidden:true}
				  ]];

	$('#mygrid').datagrid({ 
		width:'100%',
		height:'100%', 
		//toolbar:'#mytbar',
		//pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		scrollbarSize :0,
		showHeader:false, 
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		fitColumns: true,  //fitColumns	boolean	设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHDrugDiseaseI",
			QueryName:"GetList",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		},
		singleSelect:true,
		idField:'PHINSTRowId', 
		rownumbers:true,
		fixRowNumber:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:gencolumns,
		onDblClickRow: function() {

		},
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
		},
		onLoadError:function(){
		}
	});
}

 ///级别下拉框
function InitModeCmb()
{

	var modeCmb = $HUI.combobox("#PHINSTModeF",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'W',text:'警示'},
			{id:'C',text:'管控'},
			{id:'S',text:'统计'}			
		],
		onLoadSuccess:function(){
				//获取级别默认值
				$.m({
					ClassName:"web.DHCBL.KB.DHCPHInstLabel",
					MethodName:"GetManageMode",
					code:"Indic"
				},function(txtData){
					mode=txtData
					$('#PHINSTModeF').combobox('setValue', mode);	
				});
		}

	});
}
///年龄
function InitAgeCmb()
{
	$('#PDAAgeDrF').combobox({ 
		//url:Age_Dr_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHPatAgeList&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PDARowID',
		textField:'PDAAgeDesc',
		onSelect:function(record){
				var rowid=record.PDARowID
				$.ajax({
				url:AGE_ACTION_URL,  
				data:{"id":rowid},  
				type:"POST",   
				//dataType:"TEXT",  
				success: function(data){
						var data=eval('('+data+')'); 
						var PDAAgeMin=data.PDAAgeMin;
						$("#PDAMinValF").val(PDAAgeMin);
						var PDAAgeMax=data.PDAAgeMax;
						$("#PDAMaxValF").val(PDAAgeMax);
						var PDAUomDr=data.PDAUomDr;
						$('#PDAUomDrF').combobox('setValue', PDAUomDr);					
				}  
			})		
		}
	});
}

///年龄单位
function InitAgeUomCmb()
{
	$('#PDAUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHPatAgeList&QueryName=GetDataForCmbYMD&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}


///检验项目
function InitLabDrCmb()
{
	$('#LABILabDrF').combobox({ 
		//url:BindingGen+"&code=LAB",
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=LAB",
		valueField:'PHEGRowId',
		textField:'PHEGDesc',
		onSelect:function(record){
			var selVal=record.id
			if(selVal!=""){
				$("#LABIRelationF").combobox('enable'); 
				$("#LABIMinValF").attr("disabled",false); 
				$("#LABIMaxValF").attr("disabled",false); 
				$("#LABIUomDrF").combobox('enable'); 
						
			}else{
				 $("#LABIRelationF").combobox('disable'); 
				 $("#LABIMinValF").attr("disabled",true); 
				 $("#LABIMaxValF").attr("disabled",true); 
				 $("#LABIUomDrF").combobox('disable'); 

			}	
		}
	});
}
///逻辑
function InitRelationCmb()
{
	var relationCmb = $HUI.combobox("#LABIRelationF",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'>',text:'大于'},
			{id:'<',text:'小于'},
			{id:'=',text:'等于'},
			{id:'!>',text:'不大于'},
			{id:'!<',text:'不小于'},
			{id:'<>',text:'不等于'}			
		]
	});
}
///检验项目单位
function InitLabDrUomCmb()
{
	$('#LABIUomDrF').combobox({ 
		//url:BindingUom,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtUom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}

////**************************************************************病症多选列表初始化*****************************************************************/
///已选病症列表
function InitDiaList()
{
	var diacolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveDia('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'PHDISLDiseaDesc',title:'描述',width:220}, 
				  {field:'PHDISLDiseaCode',title:'代码',width:200}, 
				  {field:'PHDDRowId',title:'PHDDRowId',hidden:true},
				  {field:'PHDDDiseaDr',title:'PHDDDiseaDr',hidden:true}
				  ]];


	$('#diaGrid').datagrid({ 
		width:380,
		height:260, 
		pagination: false, 
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		//toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		//url:ACTION_URL_Disea,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHDrugDiseaseI",
			QueryName:"GetDiseaList",
			rows:1000
		},
		singleSelect:true,
		idField:'PHDDRowId', 
		rownumbers:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:diacolumns,
		//onClickRow: ClickProGrid,
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
			 $('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		},
		onLoadError:function(){
		}
	});
}
///未选病症列表
function InitUnDiaList()
{
	var diseaStr=getChoseDia();
	var unDiaColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'PHDISLDiseaDesc',title:'病症描述',width:280}, 
				  {field:'PHDISLDiseaCode',title:'病症代码',width:200,hidden:true}, 
				  {field:'PHDISLRowId',title:'PHDISLRowId',hidden:true}
				  ]];
		$('#unDiaGrid').datagrid({
			headerCls:'panel-header-gray',
			width:320,
			height:235, 
			pagination: true, 
		    pageSize:PageSizePop,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
			displayMsg:"",
			bodyCls:'panel-header-gray',
			toolbar:'#myunDiatbar',
			fitColumns: true,
			url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.KB.DHCPHDrugDiseaseI",
				QueryName:"GetUnSelDiseaList",
				diseaStr : diseaStr
			},
			idField:'PHDISLRowId', 
			columns:unDiaColumns
			
		});		  
				  
}
 


////**************************************************************病症多选列表初始化结束*****************************************************************/

////**************************************************************治疗手术列表多选初始化*****************************************************************/
///已选治疗手术列表
function InitOperaList()
{
	var Operacolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveOpera('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'KeyDesc',title:'描述',width:220}, 
				  {field:'KeyCode',title:'代码',width:200}, 
				  {field:'BusRowId',title:'BusRowId',hidden:true},
				  {field:'KeyDr',title:'KeyDr',hidden:true}
				  ]];


	$('#OperaGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		//toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		/*url:ACTION_URL_Key,
		queryParams:{
			type:"1"
		},*/
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHKeyWord",
			QueryName:"GetKeyList",
			type:"1",
			rows:1000
		},
		singleSelect:true,
		idField:'BusRowId', 
		rownumbers:true,
		fixRowNumber:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:Operacolumns,
		//onClickRow: ClickProGrid,
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
			 $('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		},
		onLoadError:function(){
		}
	});
}




///未选治疗手术列表
function InitUnOperaList()
{
	var KeyStr=getChoseOpera();

	var unOperaColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'KeyDesc',title:'描述',width:250}, 
				  {field:'KeyCode',title:'代码',width:200,hidden:true}, 
				  {field:'KeyRowId',title:'KeyRowId',hidden:true}
				  ]];


	$('#unOperaGrid').datagrid({ 
		headerCls:'panel-header-gray',
		width:320,
		height:235, 
		pagination: true, 
	    pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		bodyCls:'panel-header-gray',
		toolbar:'#myunOperatbar',
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHKeyWord",
			QueryName:"GetUnSelKeyList",
			KeyStr : KeyStr,
			type:"1"
		},
		idField:'KeyRowId', 
		columns:unOperaColumns
	});
}

////**************************************************************治疗手术列表多选初始化结束*****************************************************************/


////**************************************************************症状体征列表多选初始化*****************************************************************/
///已选症状体征列表
function InitSymList()
{
	var Symcolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveSym('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'KeyDesc',title:'描述',width:220}, 
				  {field:'KeyCode',title:'代码',width:200}, 
				  {field:'BusRowId',title:'BusRowId',hidden:true},
				  {field:'KeyDr',title:'KeyDr',hidden:true}
				  ]];


	$('#SymGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		//toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHKeyWord",
			QueryName:"GetKeyList",
			type:"0",
			rows:1000
		},
		singleSelect:true,
		idField:'BusRowId', 
		rownumbers:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:Symcolumns,
		//onClickRow: ClickProGrid,
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
			 $('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		},
		onLoadError:function(){
		}
	});
}




///未选症状体征列表
function InitUnSymList()
{
	var KeyStr=getChoseSym();
	var unSymColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'KeyDesc',title:'描述',width:250}, 
				  {field:'KeyCode',title:'代码',width:200,hidden:true}, 
				  {field:'KeyRowId',title:'KeyRowId',hidden:true}
				  ]];


	$('#unSymGrid').datagrid({ 
		headerCls:'panel-header-gray',
		width:320,
		height:235, 
		pagination: true, 
	    pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		bodyCls:'panel-header-gray',
		toolbar:'#myunSymtbar',
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHKeyWord",
			QueryName:"GetUnSelKeyList",
			KeyStr : KeyStr,
			type:"0"
		},
		idField:'KeyRowId',
		columns:unSymColumns
	});
}

////**************************************************************症状体征列表多选初始化结束*****************************************************************/

////**************************************************************细菌列表多选初始化*****************************************************************/
///已选细菌列表
function InitBtrList()
{
	var Btrcolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveBtr('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'BTODesc',title:'描述',width:220}, 
				  {field:'BTOCode',title:'代码',width:200}, 
				  {field:'PHORGRowId',title:'PHORGRowId',hidden:true},
				  {field:'PHORGOrgDr',title:'PHORGOrgDr',hidden:true}
				  ]];


	$('#BtrGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		//toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHBTOrganism",
			QueryName:"GetOrganism",
			rows:1000
		},
		singleSelect:true,
		idField:'PHORGRowId', 
		rownumbers:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:Btrcolumns,
		//onClickRow: ClickProGrid,
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
			 $('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		},
		onLoadError:function(){
		}
	});
}




///未选细菌列表
function InitUnBtrList()
{
	var OrganismStr=getChoseBtr();
	//alert(OrganismStr)
	//细菌
	var unBtrColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'BTODesc',title:'描述',width:250}, 
				  {field:'BTOCode',title:'代码',width:200,hidden:true}, 
				  {field:'BTORowId',title:'BTORowId',hidden:true}
				  ]];


	$('#unBtrGrid').datagrid({ 
		headerCls:'panel-header-gray',
		width:320,
		height:235, 
		pagination: true, 
	    pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		bodyCls:'panel-header-gray',
		toolbar:'#myunBtrtbar',
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHBTOrganism",
			QueryName:"GetUnSelOrganism",
			OrganismStr : OrganismStr
		},
		idField:'BTORowId', 
		columns:unBtrColumns
	});
}

////**************************************************************细菌列表多选初始化结束*****************************************************************/

////**************************************************************菌属列表多选初始化*****************************************************************/
///已选菌属列表
function InitGenusList()
{
	var Genuscolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveGenus('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'BTGEDesc',title:'描述',width:220}, 
				  {field:'BTGECode',title:'代码',width:200}, 
				  {field:'PHGENRowId',title:'PHGENRowId',hidden:true},
				  {field:'PHGENGenusDr',title:'PHGENGenusDr',hidden:true}
				  ]];


	$('#GenusGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		//toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		//url:ACTION_URL_Genus,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHBtGenus",
			QueryName:"GetGenus",
			rows:1000
		},
		singleSelect:true,
		idField:'PHGENRowId', 
		rownumbers:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:Genuscolumns,
		//onClickRow: ClickProGrid,
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
			 $('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		},
		onLoadError:function(){
		}
	});
}




///未选菌属列表
function InitUnGenusList()
{
	var GenusStr=getChoseGenus();
	//alert(GenusStr)
	//菌属
	var unGenusColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'BTGEDesc',title:'描述',width:250}, 
				  {field:'BTGECode',title:'代码',width:200,hidden:true}, 
				  {field:'BTGERowId',title:'BTGERowId',hidden:true}
				  ]];


	$('#unGenusGrid').datagrid({ 
		headerCls:'panel-header-gray',
		width:320,
		height:235, 
		pagination: true, 
	    pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		bodyCls:'panel-header-gray', 
		toolbar:'#myunGenustbar',
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHBtGenus",
			QueryName:"GetUnSelGenus",
			GenusStr : GenusStr
		},		
		idField:'BTGERowId', 
		columns:unGenusColumns
	});
}

////**************************************************************菌属列表多选初始化结束*****************************************************************/

///界面加载代码
function BodyLoadHandler()
{

	//主索引列表
    InitMyList();
    //级别下拉框
	InitModeCmb();

	//年龄下拉框
	InitAgeCmb();
	//年龄单位框
	InitAgeUomCmb();
	//检验项目下拉框
	InitLabDrCmb();
	//检验项目指标值范围下拉框
	InitLabDrUomCmb();
	//逻辑下拉框
	InitRelationCmb();	
	
	//主索引列表单击事件
	var opt=$("#mygrid").datagrid('options');
	opt.onClickRow=ClickMyGrid
	//新增
	$("#btnAdd").click(function (e) { 

			AddFunLib(1);

	 })
 
	//更新
	$("#btnUpd").click(function (e) { 

			AddFunLib(2);

	 })

	//删除
	$("#btnDel").click(function (e) { 

			DeleteFunLib();

	 })  
	//重置
	$("#btnRel").click(function (e) { 

			ClearFunLib();

	 }) 
	 
	////*****************************病症多选初始化*****************************************************************/
	//加载病症已选列表
	InitDiaList();
	
	//病症搜索按钮
	$('#btnDiaSearch').searchbox({ 
		searcher:function(value,name){ 
			DiaSearch(value)
			
		}
	}); 

	
	//病症重置按钮
	$("#btnDiaReset").click(function (e) { 
		DiaReset();
	}) 	
	//病症保存按钮
	$("#btnDiaSave").click(function (e) { 
		DiaSave();
	}) 
	
	////*****************************病症多选初始化结束*****************************************************************/
	
	////*****************************治疗手术多选初始化*****************************************************************/
    //加载治疗手术已选列表
	InitOperaList();
	
	//治疗手术搜索按钮
	$('#btnOperaSearch').searchbox({ 
		searcher:function(value,name){ 
			OperaSearch(value)
			
		}
	});
	//治疗手术重置按钮
	$("#btnOperaReset").click(function (e) { 
		OperaReset();
	}) 	
	//治疗手术保存按钮
	$("#btnOperaSave").click(function (e) { 
		OperaSave();
	}) 
   ////*****************************治疗手术多选初始化结束*****************************************************************/	

   	////*****************************症状体征多选初始化*****************************************************************/
    //加载症状体征已选列表
	InitSymList();
		
	//症状体征搜索按钮
	$('#btnSymSearch').searchbox({ 
		searcher:function(value,name){ 
			SymSearch(value)
		}
	});
	//症状体征重置按钮
	$("#btnSymReset").click(function (e) { 
		SymReset();
	}) 	
	//症状体征保存按钮
	$("#btnSymSave").click(function (e) { 
		SymSave();
	}) 
   ////*****************************症状体征初始化结束*****************************************************************/
   
  ////*****************************细菌多选初始化*****************************************************************/
    //加载细菌已选列表
	InitBtrList();
	
	//细菌搜索按钮 
	$('#btnBtrSearch').searchbox({ 
		searcher:function(value,name){ 
			BtrSearch(value)
					
		}
	});
	//细菌重置按钮
	$("#btnBtrReset").click(function (e) { 
		BtrReset();
	}) 	
	//细菌保存按钮
	$("#btnBtrSave").click(function (e) { 
		BtrSave();
	}) 
   ////*****************************细菌初始化结束*****************************************************************/
   
     ////*****************************菌属多选初始化*****************************************************************/
    //加载菌属已选列表
	InitGenusList();
		
	//菌属搜索按钮	
	$('#btnGenusSearch').searchbox({ 
		searcher:function(value,name){
			GenusSearch(value)
		}
	});
	//菌属重置按钮
	$("#btnGenusReset").click(function (e) { 
		GenusReset();
	}) 	
	//菌属保存按钮
	$("#btnGenusSave").click(function (e) { 
		GenusSave();
	}) 
   ////*****************************菌属初始化结束*****************************************************************/
}


///新增、更新
function AddFunLib(opflag)
{            
	if (opflag==2)
	{
		//更新
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PHINSTRowId;
		var saveURL=UPDATE_ACTION_URL
	}        		
	var code=$.trim($("#PHINSTTextF").val());


	/*var checkedRadioJObj = $("input[name='PHINSTSex']:checked");
	var sex=checkedRadioJObj.val()*/

	if (code=="")
	{
		$.messager.alert('错误提示','描述不能为空!',"error");
		return;
	}

	if (opflag==1)
	{
		//增加
		var rowid="";
		var saveURL=SAVE_ACTION_URL

	}
	
	//获取已选病症
	var DiaIds=getChoseDiaIds();
	//获取已选治疗手术
	var Key1Ids=getChoseOperaIds();
	
	//获取已选症状体征
	var Key0Ids=getChoseSymIds();
	
	//获取已选细菌
	var OrgIds=getChoseBtrIds();

	//获取已选菌属
	var GenusIds=getChoseGenusIds();
	
	$('#form-save').form('submit', { 
		url: saveURL, 
		onSubmit: function(param){
			param.PHDDInstDr = rowid,
			param.PHINSTOrderNum = "1",
			param.PHINSTGenDr = GenDr,
			param.PHINSTPointerDr = PointerDr,
			param.PHINSTPointerType = PointerType,
			param.PHINSTActiveFlag = "Y",
			param.PHINSTSysFlag = "Y",
			param.PHDDDiseaDr = DiaIds,
			param.PDCUKeyWordDr=Key1Ids,
			param.PSYMKeyWordDr=Key0Ids,
			param.PHORGOrgDr=OrgIds,
			param.PHGENGenusDr=GenusIds
		},
		success: function (data) { 
		  var data=eval('('+data+')'); 
		  if (data.success == 'true') {
			$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
			 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
			 ClearFunLib();
		  } 
		  else { 
			var errorMsg ="更新失败！"
			if (data.errorinfo) {
				errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
			}
			 $.messager.alert('操作提示',errorMsg,"error");

		}

		} 
	  }); 		



}

///删除
function DeleteFunLib()
{                  

	//更新
	var row = $("#mygrid").datagrid("getSelected"); 
	if (!(row))
	{	$.messager.alert('错误提示','请先选择一条记录!',"error");
		return;
	}
	var rowid=row.PHINSTRowId;
	$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
		if (r)
		{		
			$.ajax({
				url:DELETE_ACTION_URL,  
				data:{"id":rowid},  
				type:"POST",   
				//dataType:"TEXT",  
				success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
							 ClearFunLib()
							 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
						  } 
						  else { 
							var errorMsg ="删除失败！"
							if (data.info) {
								errorMsg =errorMsg+ '<br/>错误信息:' + data.info
							}
							 $.messager.alert('操作提示',errorMsg,"error");
		        
						}			
				}  
			})

		}
	});
	
}

///显示表单数据
function ClickMyGrid(rowIndex, rowData)
{
	//ClearFunLib();
	var record = $("#mygrid").datagrid("getSelected"); 
	if (record){
		var InstId = record.PHINSTRowId;
		
		//var check ="F"
		$.cm({
			ClassName:"web.DHCBL.KB.DHCBusMainNew",
			MethodName:"OpenIndData",
			id:InstId
		},function(jsonData){
			//console.log(jsonData.list)
			var check = jsonData.PHINSTSex; 
			$HUI.radio("#sex"+check).setValue(true)
			$('#form-save').form("load",jsonData);			
			//$("input[name='PHINSTSex'][value='" + check + "']").attr("checked", true);
			//$HUI.radio("#sexF").setValue(true);
			var selVal=jsonData.LABILabDr
			if(selVal!=""){
				$("#LABIRelationF").combobox('enable'); 
				$("#LABIMinValF").attr("disabled",false); 
				$("#LABIMaxValF").attr("disabled",false); 
				$("#LABIUomDrF").combobox('enable'); 
						
			}else{
				 $("#LABIRelationF").combobox('disable'); 
				 $("#LABIMinValF").attr("disabled",true); 
				 $("#LABIMaxValF").attr("disabled",true); 
				 $("#LABIUomDrF").combobox('disable'); 

			}
		});	
		
		
		//刷新已选病症列表
		/*$('#diaGrid').datagrid('load',  {  
			'InstId':InstId
		});
		
		//刷新已选治疗手术列表
		$('#OperaGrid').datagrid('load',  {  
			'InstId':InstId,
			'type':"1"
		});
		
		//刷新已选症状体征列表
		$('#SymGrid').datagrid('load',  {  
			'InstId':InstId,
			'type':"0"
		});
		
		//刷新已选细菌列表
		$('#BtrGrid').datagrid('load',  {  
			'InstId':InstId
		});
		
		//刷新已选菌属列表
		$('#GenusGrid').datagrid('load',  {  
			'InstId':InstId
		});*/
		
		//刷新已选病症列表
		$('#diaGrid').datagrid('load',  {
			ClassName:"web.DHCBL.KB.DHCPHDrugDiseaseI",
			QueryName:"GetDiseaList",			
			InstId:InstId,
			rows:1000
		});
		
		//刷新已选治疗手术列表
		$('#OperaGrid').datagrid('load',  {  
			ClassName:"web.DHCBL.KB.DHCPHKeyWord",
			QueryName:"GetKeyList",
			InstId:InstId,
			type:"1",
			rows:1000
		});
		
		//刷新已选症状体征列表
		$('#SymGrid').datagrid('load',  {
			ClassName:"web.DHCBL.KB.DHCPHKeyWord",
			QueryName:"GetKeyList",			
			InstId:InstId,
			type:"0",
			rows:1000
		});
		
		//刷新已选细菌列表
		$('#BtrGrid').datagrid('load',  {
			ClassName:"web.DHCBL.KB.DHCPHBTOrganism",
			QueryName:"GetOrganism",		
			InstId:InstId,
			rows:1000
		});
		
		//刷新已选菌属列表
		$('#GenusGrid').datagrid('load',  {  
			ClassName:"web.DHCBL.KB.DHCPHBtGenus",
			QueryName:"GetGenus",
			InstId:InstId,
			rows:1000
		});
	}

}
//重置
function ClearFunLib()
{
	//清空表单
	$('#form-save').form('clear');
	//性别赋值
	$HUI.radio("#sexA").setValue(true);
	//级别赋值
	$('#PHINSTModeF').combobox('setValue', mode);
	
	//逻辑、指标值范围不可用
	 $("#LABIRelationF").combobox('disable'); 
	 $("#LABIMinValF").attr("disabled",true); 
	 $("#LABIMaxValF").attr("disabled",true); 
	 $("#LABIUomDrF").combobox('disable');
	 
	//清空病症数据
	$('#diaGrid').datagrid('loadData', { total: 0, rows: [] });
	
	//清空治疗手术数据
	$('#OperaGrid').datagrid('loadData', { total: 0, rows: [] });
	
	//清空症状体征数据
	$('#SymGrid').datagrid('loadData', { total: 0, rows: [] });
	
	//清空细菌数据
	$('#BtrGrid').datagrid('loadData', { total: 0, rows: [] });
	
	//清空菌属数据
	$('#GenusGrid').datagrid('loadData', { total: 0, rows: [] });
}

////**************************************************************病症多选部分开始*****************************************************************/
///未选病症弹窗
$('#btnAddDia').popover({
		title:"病症",
		width:330,
		height:240,
		content:'<table id="unDiaGrid" ></table>',
		placement:'auto-right',
		closeable:true,
		trigger:'click',
		onShow:function(){
			InitUnDiaList()
			$('#btnDiaSearch').searchbox('setValue', '');
			
			}
	});
	
//病症检索方法
function DiaSearch(desc)
{
	var diseaStr=getChoseDia();
	$('#unDiaGrid').datagrid('load',  { 	
		ClassName:"web.DHCBL.KB.DHCPHDrugDiseaseI",
		QueryName:"GetUnSelDiseaList",
		diseaStr : diseaStr,
		desc: desc
	});
	$('#unDiaGrid').datagrid('unselectAll');

}
//病症重置方法
function DiaReset()
{
	var diseaStr=getChoseDia();	
	$('#btnDiaSearch').searchbox('setValue', '');
	/*$('#unDiaGrid').datagrid('load',  { 
		'desc': "",
		'diseaStr':diseaStr
	});*/
	$('#unDiaGrid').datagrid('load',  { 	
		ClassName:"web.DHCBL.KB.DHCPHDrugDiseaseI",
		QueryName:"GetUnSelDiseaList",
		diseaStr : diseaStr,
		desc: ""
	});
	$('#unDiaGrid').datagrid('unselectAll');
}

//病症保存方法
function DiaSave()
{
	var deleteRows = []; 
	var rows = $('#unDiaGrid').datagrid('getSelections');
	//已选列表插入选中数据
	for(var i=0; i<rows.length; i++){
		deleteRows.push(rows[i]);
		$("#diaGrid").datagrid("appendRow", {
			    opt:'',
				PHDDRowId:'',
				PHDDDiseaDr:rows[i].PHDISLRowId,
				PHDISLDiseaCode:rows[i].PHDISLDiseaCode,
				PHDISLDiseaDesc:rows[i].PHDISLDiseaDesc
			});
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
		//datatgrid删除行deleteRow的方法中，会去调opts.view.deleteRow.call(opts.view,_4d2,_4d3);刷新页面上的行的index，index会发生改变，原来rows的数据也会发生改变，所以下列方法只能删除一行。
	    //var index = $('#unDiaGrid').datagrid('getRowIndex',rows[i]);  
		//$("#unDiaGrid").datagrid("deleteRow", index);
	}
	
	//未选列表移除选中数据
	for(var i =0;i<deleteRows.length;i++){    
		var index = $('#unDiaGrid').datagrid('getRowIndex',deleteRows[i]);
		$('#unDiaGrid').datagrid('deleteRow',index); 
	}
}

//获取所有已选病症
function getChoseDia()
{
	var ids = [];
	var datas=$('#diaGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str="<"+datas[i].PHDISLDiseaCode+">"
		ids.push(str);
	}
	var diseaStr=ids.join('^')
	return diseaStr
}

//获取所有已选病症的ID
function getChoseDiaIds()
{
	var ids = [];
	var datas=$('#diaGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str=datas[i].PHDDDiseaDr
		ids.push(str);
	}
	var diseaStrIds=ids.join(',')
	return diseaStrIds
}

//移除已选病症
function RemoveDia(index)
{
	$('#diaGrid').datagrid('selectRow',index);// 关键在这里 
	var record = $("#diaGrid").datagrid("getSelected"); 
	if (record){
		var PHDDRowId = record.PHDDRowId;
		if(PHDDRowId==""){  //如果是新加的数据，还没保存，则只是移除
			$('#diaGrid').datagrid('deleteRow',index); 
			var rows = $('#diaGrid').datagrid("getRows");
			$('#diaGrid').datagrid("loadData", rows);
			if($('#unDiaWindow').is(":visible"))  //如果新增病症窗口打开了，则点删除后刷新未选病症列表
			{
				DiaReset();
			}			
		}else{   //如果是已保存的数据直接执行删除操作
			$.ajax({
			url:DELETE_Disea_URL,  
			data:{"id":PHDDRowId},  
			type:"POST",   
			//dataType:"TEXT",  
			success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						$('#diaGrid').datagrid('deleteRow',index);
						var rows = $('#diaGrid').datagrid("getRows");
						$('#diaGrid').datagrid("loadData", rows); // 重新载入当前页面数据  
						if($('#unDiaWindow').is(":visible"))  //如果新增病症窗口打开了，则点删除后刷新未选病症列表
						{
							DiaReset();
						}
					  } 
					  else { 
						var errorMsg ="删除失败！"
						if (data.info) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.info
						}
						$.messager.alert('操作提示',errorMsg,"error");
			
					}			
				}  
			})		
		}
		
	}

}


////**************************************************************病症多选部分结束*****************************************************************/


////**************************************************************治疗手术多选方法****************************************************************/
//点击添加治疗手术按钮
$('#btnAddOpera').popover({
		title:"治疗手术",
		width:330,
		height:240,
		content:'<table id="unOperaGrid" ></table>',
		placement:'auto-right',
		closeable:true,
		trigger:'click',
		onShow:function(){
			InitUnOperaList()
			$('#btnOperaSearch').searchbox('setValue', '');
			
			}
	});
//治疗手术检索方法
function OperaSearch(desc)
{
	var KeyStr=getChoseOpera();
	$('#unOperaGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCPHKeyWord",
		QueryName:"GetUnSelKeyList",
		desc: desc,
		KeyStr:KeyStr,
		type:"1"
	});
	$('#unOperaGrid').datagrid('unselectAll');
}	

//治疗手术重置方法
function OperaReset()
{
	var KeyStr=getChoseOpera();	
	$('#btnOperaSearch').searchbox('setValue', '');
	/*$('#unOperaGrid').datagrid('load',  { 
		'desc': "",
		'KeyStr':KeyStr,
		'type':"1"
	});*/
	$('#unOperaGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCPHKeyWord",
		QueryName:"GetUnSelKeyList",
		desc: "",
		KeyStr:KeyStr,
		type:"1"
	});
	$('#unOperaGrid').datagrid('unselectAll');
	
}

//治疗手术保存方法
function OperaSave()
{
	var deleteRows = []; 
	var rows = $('#unOperaGrid').datagrid('getSelections');
	
	//已选列表插入选中数据
	for(var i=0; i<rows.length; i++){
		deleteRows.push(rows[i]);
		$("#OperaGrid").datagrid("appendRow", {
			    opt:'',
				BusRowId:'',
				KeyDr:rows[i].KeyRowId,
				KeyCode:rows[i].KeyCode,
				KeyDesc:rows[i].KeyDesc
			});
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
		//datatgrid删除行deleteRow的方法中，会去调opts.view.deleteRow.call(opts.view,_4d2,_4d3);刷新页面上的行的index，index会发生改变，原来rows的数据也会发生改变，所以下列方法只能删除一行。
	    //var index = $('#unOperaGrid').datagrid('getRowIndex',rows[i]);  
		//$("#unOperaGrid").datagrid("deleteRow", index);
	}
	
	//未选列表移除选中数据
	for(var i =0;i<deleteRows.length;i++){    
		var index = $('#unOperaGrid').datagrid('getRowIndex',deleteRows[i]);
		$('#unOperaGrid').datagrid('deleteRow',index); 
	}
}

//获取所有已选治疗手术
function getChoseOpera()
{
	var ids = [];
	var datas=$('#OperaGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str="<"+datas[i].KeyDr+">"
		ids.push(str);
	}
	var KeyStr=ids.join('^')
	return KeyStr
}

//获取所有已选治疗手术的ID
function getChoseOperaIds()
{
	var ids = [];
	var datas=$('#OperaGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str=datas[i].KeyDr
		ids.push(str);
	}
	var KeyStrIds=ids.join(',')
	return KeyStrIds
}

//移除已选治疗手术
function RemoveOpera(index)
{
	$('#OperaGrid').datagrid('selectRow',index);// 关键在这里 
	var record = $("#OperaGrid").datagrid("getSelected"); 
	if (record){
		var BusRowId = record.BusRowId;
		if(BusRowId==""){  //如果是新加的数据，还没保存，则只是移除
			$('#OperaGrid').datagrid('deleteRow',index); 
			var rows = $('#OperaGrid').datagrid("getRows");
			$('#OperaGrid').datagrid("loadData", rows);			
			if($('#unOperaWindow').is(":visible"))  //如果新增治疗手术窗口打开了，则点删除后刷新未选治疗手术列表
			{
				OperaReset();
			}			
		}else{   //如果是已保存的数据直接执行删除操作
			$.ajax({
			url:DELETE_Key_URL,  
			data:{
				"id":BusRowId,
				'type':"1"
			},  
			type:"POST",   
			//dataType:"TEXT",  
			success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						$('#OperaGrid').datagrid('deleteRow',index); 
						var rows = $('#OperaGrid').datagrid("getRows");
						$('#OperaGrid').datagrid("loadData", rows);	 // 重新载入当前页面数据  
						if($('#unOperaWindow').is(":visible"))  //如果新增治疗手术窗口打开了，则点删除后刷新未选治疗手术列表
						{
							OperaReset();
						}
					  } 
					  else { 
						var errorMsg ="删除失败！"
						if (data.info) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.info
						}
						$.messager.alert('操作提示',errorMsg,"error");
			
					}			
				}  
			})		
		}
		
	}

}

////**************************************************************治疗手术多选方法结束****************************************************************/


////**************************************************************症状体征多选方法****************************************************************/
//点击添加症状体征按钮
$('#btnAddSym').popover({
		title:"症状体征",
		width:330,
		height:240,
		content:'<table id="unSymGrid" ></table>',
		placement:'auto-right',
		closeable:true,
		trigger:'click',
		onShow:function(){
			InitUnSymList()
			$('#btnSymSearch').searchbox('setValue', '');
			
			}
	});

//症状体征检索方法
function SymSearch(desc)
{
	var KeyStr=getChoseSym();
	/*$('#unSymGrid').datagrid('load',  { 
		'desc': desc,
		'KeyStr':KeyStr,
		'type':"0"
	});*/
	$('#unSymGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCPHKeyWord",
		QueryName:"GetUnSelKeyList",
		desc: desc,
		KeyStr:KeyStr,
		type:"0"
	});
	$('#unSymGrid').datagrid('unselectAll');
}

//症状体征重置方法
function SymReset()
{
	var KeyStr=getChoseSym();	
	$('#btnSymSearch').searchbox('setValue', '');
	/*$('#unSymGrid').datagrid('load',  { 
		'desc': "",
		'KeyStr':KeyStr,
		'type':"0"
	});*/
	$('#unSymGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCPHKeyWord",
		QueryName:"GetUnSelKeyList",
		desc: "",
		KeyStr:KeyStr,
		type:"0"
	});
	$('#unSymGrid').datagrid('unselectAll');
}

//症状体征保存方法
function SymSave()
{
	var deleteRows = []; 
	var rows = $('#unSymGrid').datagrid('getSelections');
	
	//已选列表插入选中数据
	for(var i=0; i<rows.length; i++){
		deleteRows.push(rows[i]);
		$("#SymGrid").datagrid("appendRow", {
			    opt:'',
				BusRowId:'',
				KeyDr:rows[i].KeyRowId,
				KeyCode:rows[i].KeyCode,
				KeyDesc:rows[i].KeyDesc
			});
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
		//datatgrid删除行deleteRow的方法中，会去调opts.view.deleteRow.call(opts.view,_4d2,_4d3);刷新页面上的行的index，index会发生改变，原来rows的数据也会发生改变，所以下列方法只能删除一行。
	    //var index = $('#unSymGrid').datagrid('getRowIndex',rows[i]);  
		//$("#unSymGrid").datagrid("deleteRow", index);
	}
	
	//未选列表移除选中数据
	for(var i =0;i<deleteRows.length;i++){    
		var index = $('#unSymGrid').datagrid('getRowIndex',deleteRows[i]);
		$('#unSymGrid').datagrid('deleteRow',index); 
	}
}

//获取所有已选症状体征
function getChoseSym()
{
	var ids = [];
	var datas=$('#SymGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str="<"+datas[i].KeyDr+">"
		ids.push(str);
	}
	var KeyStr=ids.join('^')
	return KeyStr
}

//获取所有已选症状体征的ID
function getChoseSymIds()
{
	var ids = [];
	var datas=$('#SymGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str=datas[i].KeyDr
		ids.push(str);
	}
	var KeyStrIds=ids.join(',')
	return KeyStrIds
}

//移除已选症状体征
function RemoveSym(index)
{
	$('#SymGrid').datagrid('selectRow',index);// 关键在这里 
	var record = $("#SymGrid").datagrid("getSelected"); 
	if (record){
		var BusRowId = record.BusRowId;
		if(BusRowId==""){  //如果是新加的数据，还没保存，则只是移除
			$('#SymGrid').datagrid('deleteRow',index); 
			var rows = $('#SymGrid').datagrid("getRows");
			$('#SymGrid').datagrid("loadData", rows);			
			if($('#unSymWindow').is(":visible"))  //如果新增症状体征窗口打开了，则点删除后刷新未选症状体征列表
			{
				SymReset();
			}
			
		}else{   //如果是已保存的数据直接执行删除操作
			$.ajax({
			url:DELETE_Key_URL,  
			data:{
				"id":BusRowId,
				'type':"0"
			},  
			type:"POST",   
			//dataType:"TEXT",  
			success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						$('#SymGrid').datagrid('deleteRow',index);
						var rows = $('#SymGrid').datagrid("getRows");
						$('#SymGrid').datagrid("loadData", rows);// 重新载入当前页面数据  
						if($('#unSymWindow').is(":visible"))  //如果新增症状体征窗口打开了，则点删除后刷新未选症状体征列表
						{
							SymReset();
						}
					  } 
					  else { 
						var errorMsg ="删除失败！"
						if (data.info) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.info
						}
						$.messager.alert('操作提示',errorMsg,"error");
			
					}			
				}  
			})		
		}
		
	}

}

////*************************************************************症状体征多选方法结束****************************************************************/


////**************************************************************细菌多选方法****************************************************************/
//点击添加细菌按钮
$('#btnAddBtr').popover({
		title:"细菌",
		width:330,
		height:240,
		content:'<table id="unBtrGrid" ></table>',
		placement:'auto-right',
		closeable:true,
		trigger:'click',
		onShow:function(){
			InitUnBtrList()
			$('#btnBtrSearch').searchbox('setValue', '');
			
			}
	});

//细菌检索方法
function BtrSearch(desc)
{
	var OrganismStr=getChoseBtr();
	$('#unBtrGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCPHBTOrganism",
		QueryName:"GetUnSelOrganism",
		desc: desc,
		OrganismStr:OrganismStr
	});
	$('#unBtrGrid').datagrid('unselectAll');
}

//细菌重置方法
function BtrReset()
{
	var OrganismStr=getChoseBtr();	
	$('#btnBtrSearch').searchbox('setValue', '');
	/*$('#unBtrGrid').datagrid('load',  { 
		'desc': "",
		'OrganismStr':OrganismStr
	});*/
	$('#unBtrGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCPHBTOrganism",
		QueryName:"GetUnSelOrganism",
		desc: "",
		OrganismStr:OrganismStr
	});	
	$('#unBtrGrid').datagrid('unselectAll');
}

//细菌保存方法
function BtrSave()
{
	var deleteRows = []; 
	var rows = $('#unBtrGrid').datagrid('getSelections');
	
	//已选列表插入选中数据
	for(var i=0; i<rows.length; i++){
		deleteRows.push(rows[i]);
		$("#BtrGrid").datagrid("appendRow", {
			    opt:'',
				PHORGRowId:'',
				PHORGOrgDr:rows[i].BTORowId,
				BTOCode:rows[i].BTOCode,
				BTODesc:rows[i].BTODesc
			});
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
		//datatgrid删除行deleteRow的方法中，会去调opts.view.deleteRow.call(opts.view,_4d2,_4d3);刷新页面上的行的index，index会发生改变，原来rows的数据也会发生改变，所以下列方法只能删除一行。
	    //var index = $('#unBtrGrid').datagrid('getRowIndex',rows[i]);  
		//$("#unBtrGrid").datagrid("deleteRow", index);
	}
	
	//未选列表移除选中数据
	for(var i =0;i<deleteRows.length;i++){    
		var index = $('#unBtrGrid').datagrid('getRowIndex',deleteRows[i]);
		$('#unBtrGrid').datagrid('deleteRow',index); 
	}
}

//获取所有已选细菌
function getChoseBtr()
{
	var ids = [];
	var datas=$('#BtrGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str="<"+datas[i].BTOCode+">"
		ids.push(str);
	}
	var OrganismStr=ids.join('^')
	return OrganismStr
}

//获取所有已选细菌的ID
function getChoseBtrIds()
{
	var ids = [];
	var datas=$('#BtrGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str=datas[i].PHORGOrgDr
		ids.push(str);
	}
	var OrganismStrIds=ids.join(',')
	return OrganismStrIds
}

//移除已选细菌
function RemoveBtr(index)
{
	$('#BtrGrid').datagrid('selectRow',index);// 关键在这里 
	var record = $("#BtrGrid").datagrid("getSelected"); 
	if (record){
		var PHORGRowId = record.PHORGRowId;
		if(PHORGRowId==""){  //如果是新加的数据，还没保存，则只是移除
			$('#BtrGrid').datagrid('deleteRow',index); 
			var rows = $('#BtrGrid').datagrid("getRows");
			$('#BtrGrid').datagrid("loadData", rows);			
			if($('#unBtrWindow').is(":visible"))  //如果新增细菌窗口打开了，则点删除后刷新未选细菌列表
			{
				BtrReset();
			}			
		}else{   //如果是已保存的数据直接执行删除操作
			$.ajax({
			url:DELETE_Organism_URL,  
			data:{
				"id":PHORGRowId
			},  
			type:"POST",   
			//dataType:"TEXT",  
			success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						$('#BtrGrid').datagrid('deleteRow',index); 
						var rows = $('#BtrGrid').datagrid("getRows");
						$('#BtrGrid').datagrid("loadData", rows);	 // 重新载入当前页面数据  
						if($('#unBtrWindow').is(":visible"))  //如果新增细菌窗口打开了，则点删除后刷新未选细菌列表
						{
							BtrReset();
						}
					  } 
					  else { 
						var errorMsg ="删除失败！"
						if (data.info) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.info
						}
						$.messager.alert('操作提示',errorMsg,"error");
			
					}			
				}  
			})		
		}
		
	}

}

////*************************************************************细菌多选方法结束****************************************************************/


////**************************************************************菌属多选方法****************************************************************/
//点击添加菌属按钮
$('#btnAddGenus').popover({
		title:"菌属",
		width:330,
		height:240,
		content:'<table id="unGenusGrid" ></table>',
		placement:'auto-right',
		closeable:true,
		trigger:'click',
		onShow:function(){
			InitUnGenusList()
			$('#btnGenusSearch').searchbox('setValue', '');
			
			}
	});

//菌属检索方法
function GenusSearch(desc)
{
	var GenusStr=getChoseGenus();
	$('#unGenusGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCPHBtGenus",
		QueryName:"GetUnSelGenus",
		desc: desc,
		GenusStr:GenusStr
	});
	$('#unGenusGrid').datagrid('unselectAll');
}

//菌属重置方法
function GenusReset()
{
	var GenusStr=getChoseGenus();	
	$('#btnGenusSearch').searchbox('setValue', '');
	/*$('#unGenusGrid').datagrid('load',  { 
		'desc': "",
		'GenusStr':GenusStr
	});*/
	$('#unGenusGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCPHBtGenus",
		QueryName:"GetUnSelGenus",
		desc: "",
		GenusStr:GenusStr
	});
	$('#unGenusGrid').datagrid('unselectAll');
}

//菌属保存方法
function GenusSave()
{
	var deleteRows = []; 
	var rows = $('#unGenusGrid').datagrid('getSelections');
	
	//已选列表插入选中数据
	for(var i=0; i<rows.length; i++){
		deleteRows.push(rows[i]);
		$("#GenusGrid").datagrid("appendRow", {
			    opt:'',
				PHGENRowId:'',
				PHGENGenusDr:rows[i].BTGERowId,
				BTGECode:rows[i].BTGECode,
				BTGEDesc:rows[i].BTGEDesc
			});
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
		//datatgrid删除行deleteRow的方法中，会去调opts.view.deleteRow.call(opts.view,_4d2,_4d3);刷新页面上的行的index，index会发生改变，原来rows的数据也会发生改变，所以下列方法只能删除一行。
	    //var index = $('#unGenusGrid').datagrid('getRowIndex',rows[i]);  
		//$("#unGenusGrid").datagrid("deleteRow", index);
	}
	
	//未选列表移除选中数据
	for(var i =0;i<deleteRows.length;i++){    
		var index = $('#unGenusGrid').datagrid('getRowIndex',deleteRows[i]);
		$('#unGenusGrid').datagrid('deleteRow',index); 
	}
}

//获取所有已选菌属
function getChoseGenus()
{
	var ids = [];
	var datas=$('#GenusGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str="<"+datas[i].BTGECode+">"
		ids.push(str);
	}
	var GenusStr=ids.join('^')
	return GenusStr
}

//获取所有已选菌属的ID
function getChoseGenusIds()
{
	var ids = [];
	var datas=$('#GenusGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str=datas[i].PHGENGenusDr
		ids.push(str);
	}
	var GenusStrIds=ids.join(',')
	return GenusStrIds
}

//移除已选菌属
function RemoveGenus(index)
{
	$('#GenusGrid').datagrid('selectRow',index);// 关键在这里 
	var record = $("#GenusGrid").datagrid("getSelected"); 
	if (record){
		var PHGENRowId = record.PHGENRowId;
		if(PHGENRowId==""){  //如果是新加的数据，还没保存，则只是移除
			$('#GenusGrid').datagrid('deleteRow',index); 
			var rows = $('#GenusGrid').datagrid("getRows");
			$('#GenusGrid').datagrid("loadData", rows);				
			if($('#unGenusWindow').is(":visible"))  //如果新增菌属窗口打开了，则点删除后刷新未选菌属列表
			{
				GenusReset();
			}			
		}else{   //如果是已保存的数据直接执行删除操作
			$.ajax({
			url:DELETE_Genus_URL,  
			data:{
				"id":PHGENRowId
			},  
			type:"POST",   
			//dataType:"TEXT",  
			success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						$('#GenusGrid').datagrid('deleteRow',index); 
						var rows = $('#GenusGrid').datagrid("getRows");
						$('#GenusGrid').datagrid("loadData", rows);	  // 重新载入当前页面数据  
						if($('#unGenusWindow').is(":visible"))  //如果新增菌属窗口打开了，则点删除后刷新未选菌属列表
						{
							GenusReset();
						}
					  } 
					  else { 
						var errorMsg ="删除失败！"
						if (data.info) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.info
						}
						$.messager.alert('操作提示',errorMsg,"error");
			
					}			
				}  
			})		
		}
		
	}

}

////*************************************************************菌属多选方法结束****************************************************************/