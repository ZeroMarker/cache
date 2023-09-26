/**
 * 门诊异常错误原因分析JS
 * FileName:scripts/hisui/insutarpageconf.js
 * Huang SF 2018-03-16
 * 版本：V1.0
 * hisui版本:0.1.0
 */
 
 //全局变量
 var accIdArr=[];
 var fieldSorTemp="";
 var fieldHidTemp="";
 
 //界面入口
$(function(){
	initData();
	initPanel();
	loadDataGridFun();
	loadChangeLoc();
});

function initData(){
	accIdArr[0]="colWidth";
	accIdArr[1]="colLocation";
	accIdArr[2]="colSort";
	accIdArr[3]="colHidden";
	
	
}
function initPanel(){
	loadData("colWidth");
	loadData("colSort");
	loadData("colHidden");
	
	$HUI.accordion("#accId",{
		onSelect:function(title,index){
			//alert("title:"+title+",index:"+index);
			//异步调用
			$.cm({
				ClassName:"web.INSUTarContrastCom",
				QueryName:"DhcTarQuery",
				sKeyWord:"葡萄糖氯化钠注射液",
				Class:"3",
				Type:"BJ",
				ConType:"Y",
				TarCate:"1",
				ActDate:"",
				ExpStr:""
			},function(jsonData){
				if(index!=1){
					$HUI.datagrid('#'+accIdArr[index]).loadData(jsonData);
				}
			});
		}
	});
}

function loadData(id){
	//初始化对照的grid
	$HUI.datagrid("#"+id,{
		rownumbers:true,
		height: 330,
		striped:true,
		//fitColumns: true,
		singleSelect: true,
		columns:[[
			{field:'TarId',title:'TarId',width:60,hidden:true},
			{field:'HisCode',title:'收费代码',width:150},
			{field:'HisDesc',title:'医院收费项名称',width:300},
			{field:'DW',title:'单位',width:65},
			{field:'Cate',title:'大类',width:50},
			{field:'Price',title:'单价',width:50},
			{field:'ConId',title:'ConId',width:10,hidden:true},
			{field:'InsuId',title:'InsuId',width:10,hidden:true},
			{field:'InsuCode',title:'医保编码',width:80},
			{field:'InsuDesc',title:'医保描述',width:150},
			{field:'InsuGG',title:'医保规格',width:55},
			{field:'InsuDW',title:'医保单位',width:55},
			{field:'InsuSeltPer',title:'自付比例',width:55},
			{field:'factory',title:'厂家',width:150},
			{field:'PZWH',title:'批准文号',width:150},
			{field:'InsuCate',title:'医保大类',width:55},
			{field:'InsuClass',title:'项目等级',width:55},
			{field:'conActDate',title:'生效日期',width:55},
			{field:'index',title:'序号',width:55},
			{field:'LimitFlag',title:'外部代码',width:55},
			{field:'HISPutInTime',title:'HIS录入时间',width:75},
			{field:'SubCate',title:'子类',width:50},
			{field:'Demo',title:'收费项备注',width:100},
			{field:'UserDr',title:'对照人',width:55},
			{field:'ConDate',title:'对照日期',width:65},
			{field:'ConTime',title:'对照时间',width:65},
			{field:'EndDate',title:'结束日期',width:65},
			{field:'ConQty',title:'对照数量',width:55}
		]],
		pagination:false
	});
}

//加载列位置的datagrid
function loadChangeLoc(){
	var gridJosn=$.cm({
		ClassName:"web.INSUTarContrastCom",
		QueryName:"DhcTarQuery",
		sKeyWord:"葡萄糖氯化钠注射液",
		Class:"3",
		Type:"BJ",
		ConType:"Y",
		TarCate:"1",
		ActDate:"",
		ExpStr:""
	},false);
	
	$HUI.datagrid("#colLocation",{
		rownumbers:true,
		height: 330,
		striped:true,
		//fitColumns: true,
		singleSelect: true,
		data:gridJosn.rows,
		columns:[[
			{field:'TarId',title:'TarId',width:60,hidden:true},
			{field:'HisCode',title:'收费代码',width:150},
			{field:'HisDesc',title:'医院收费项名称'},
			{field:'DW',title:'单位',width:65},
			{field:'Cate',title:'大类',width:50},
			{field:'Price',title:'单价',width:50},
			{field:'ConId',title:'ConId',width:10,hidden:true},
			{field:'InsuId',title:'InsuId',width:10,hidden:true},
			{field:'InsuCode',title:'医保编码',width:80},
			{field:'InsuDesc',title:'医保描述',width:150},
			{field:'InsuGG',title:'医保规格',width:55},
			{field:'InsuDW',title:'医保单位',width:55},
			{field:'InsuSeltPer',title:'自付比例',width:55},
			{field:'factory',title:'厂家',width:150},
			{field:'PZWH',title:'批准文号',width:150},
			{field:'InsuCate',title:'医保大类',width:55},
			{field:'InsuClass',title:'项目等级',width:55},
			{field:'conActDate',title:'生效日期',width:55},
			{field:'index',title:'序号',width:55},
			{field:'LimitFlag',title:'外部代码',width:55},
			{field:'HISPutInTime',title:'HIS录入时间',width:75},
			{field:'SubCate',title:'子类',width:50},
			{field:'Demo',title:'收费项备注',width:100},
			{field:'UserDr',title:'对照人',width:55},
			{field:'ConDate',title:'对照日期',width:65},
			{field:'ConTime',title:'对照时间',width:65},
			{field:'EndDate',title:'结束日期',width:65},
			{field:'ConQty',title:'对照数量',width:55}
		]],
		pagination:false
	});
	$("#colLocation").datagrid("columnMoving");
}

//加载列事件
function loadDataGridFun(){
	//列排序配置
	$HUI.datagrid('#colSort',{
		rowStyler: function(index,row){
			return 'background-color:#ffffff;color:#000000;'; // return inline style
			// the function can return predefined css class and inline style
			// return {class:'r1', style:{'color:#fff'}};	
		}
	}); 
	$HUI.datagrid("#colSort",{
		onClickCell:function(rowIndex,field,value){
			$("#colSortDiv td").css("background-color", "")
			var testJq=$("#colSortDiv td[field='"+field+"']");
			testJq.css("background-color", "#509de1");//509de1   96b8ff
			console.log(field);//列field的值字符串 "HisDesc"
			fieldSorTemp=field;
		}
	});
	
	//列隐藏配置
	$HUI.datagrid('#colHidden',{
		rowStyler: function(index,row){
			return 'background-color:#ffffff;color:#000000;';
		}
	}); 
	
	$HUI.datagrid("#colHidden",{
		onClickCell:function(rowIndex,field,value){
			$("#colHiddenDiv td").css("background-color", "")
			var testJq=$("#colHiddenDiv td[field='"+field+"']");
			testJq.css("background-color", "#509de1");//509de1   96b8ff
			console.log(field);//列field的值字符串 "HisDesc"
			fieldHidTemp=field;
		}
	});
}

//保存列宽度
function savColWid(){
	var colOpts=$HUI.datagrid('#colWidth').getColumnOption("HisDesc");
	console.log(colOpts);//field对象
	console.log(colOpts.width);
}

//保存列位置
function savColLoc(){
	var opts = $HUI.datagrid('#colLocation').getColumnFields();
	console.log(opts);//列field的数组["TarId","HisCode","HisDesc","DW"]
	//
}
//保存排序配置
function savColSor(){
	console.log(fieldSorTemp);
}

//保存隐藏配置
function savColHid(){
	console.log(fieldHidTemp);
}