// insuopdivsubqry.js
/**
 *	filename：门诊医保报销明细查询JS
 *	功能：通过时间，登记号，查到his门诊医保发票基本信息，选中某行查出的数据，加载出医保明细信息
 * FileName:insuopdivsubqry.js
 * zyx 2018-03-26
 * 版本：V1.0
 * hisui版本:0.1.0
 */
 
 var TmpPAPMINo="";
 var StDate="";
 var EndDate="";
 var PAPMINo="";
//界面入口
$(function(){
	initDocument();

});
//初始化界面
function initDocument(){
	initHisInv();
	initIndis();
	//回车事件
	key_enter();
	RunQuery()
}
function initHisInv(){
    //数据面板
	$HUI.datagrid("#HisInv",{	
   	 	nowrap: true,
    	striped: true,	
		pagination:true,
		border:false,
		collapsible:true,
		height:400,
		checkOnSelect:false,
		singleSelect: true,   
	 	//fitColumns:true,   //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
	 	selectOnCheck:true,
	 	pagesize:100,
	 	autoRowHeight:true,
	 	cache:true,
	 	loadMsg:'Loading',
	 	rownumbers:true,
	 	scrollbarSize:20,
		toolbar:[],	
		columns:[[
			//初始化his门诊发票基本信息
			{title:'序号',field:'Ind',hidden:true},
			{title:'发票id',field:'PrtRowid',hidden:true},
			{title:'登记号',field:'PAPMINO',width:180},
			{title:'患者姓名',field:'PAPMIName',width:100},
			{title:'发票金额',field:'PrtAcount',width:100,},
			{title:'发票号码',field:'InvNo',width:120},
			{title:'发票日期',field:'PRTdate',width:120},
			{title:'发票状态',field:'InvFlag',width:738},
			{title:'就诊Dr',field:'PAADMDr',hidden:true},
			{title:'医保结算Dr',field:'PRTInsDivDR',hidden:true}			
		]]
		
	});
	//查询面板
	$HUI.panel("#QueryPanel",{
		collapsible:true,
		headerCls:'panel-header-big' 
	})
	//默认时间
	setDateBox();
	$("#Find").click=RunQuery;
}
function initIndis(){
	$HUI.datagrid("#InsuDivSub",{
		rownumbers:true,	
	 	nowrap: true,
		striped: true,	
		pagination:true,
		singleSelect:true,
		selectOnCheck:true,
		collapsible:true,
		height:400,
		border:false,
		toolbar:[],
		columns:[[
			//初始化医保结算明细表所有字段
			{title:'序号',field:'ind',hidden:true},
			{title:'INDISRowid',field:'INDISRowid',hidden:true},
			{title:'医保结算表Dr',field:'DivideDr',hidden:true},
			{title:'医嘱项Dr',field:'ArcimDr',hidden:true},
			{title:'收费项Dr',field:'TarItmDr',hidden:true},
			{title:'医保项目Dr',field:'INSUItmDr',hidden:true},
			{title:'医嘱明细Dr',field:'OEORIDr',hidden:true},
			{title:'账单Dr',field:'PBDr',hidden:true},
			{title:'账单明细Dr',field:'PBDDr',hidden:true},
			{title:'医保编码',field:'INSUCode',width:90},
			{title:'医保名称',field:'INSUDesc',width:90},
			{title:'医保等级',field:'INSUXMLB',width:90},
			{title:'数量',field:'Qty',width:90},
			{title:'价格',field:'Price',width:90},
			{title:'金额',field:'Amount',width:90},
			{title:'项目门诊大类',field:'TarCate',width:90},
			{title:'自付比例',field:'Scale',width:90},	
			{title:'统筹支付',field:'Fund',width:90},
			{title:'个人自付',field:'Self',width:90},
			{title:'上传标志',field:'Flag',width:90},
			{title:'明细序号1',field:'Sequence1',width:90},
			{title:'明细序号2',field:'Sequence2',width:90},
			{title:'上传日期',field:'Date',width:90},
			{title:'上传时间',field:'Time',width:90},
			{title:'操作员Dr',field:'UserDr',width:90},
			{title:'是否医保标志',field:'INSUFlag',width:90},
			{title:'医保限价',field:'INSUMaxPrice',width:90},
			{title:'预留字串1',field:'Demo1',width:90},
			{title:'预留字串2',field:'Demo2',width:90},
			{title:'预留字串3',field:'Demo3',width:90},
			{title:'预留字串4',field:'Demo4',width:90},
			{title:'预留字串5',field:'Demo5',width:90},
			{title:'收费项目编码',field:'TARICode',width:90},
			{title:'收费项目名称',field:'TARIDesc',width:90},
			{title:'执行记录DR',field:'INDISExecDr',width:90},
			{title:'实际上传数量(医保)',field:'INDISUpQty ',width:90},
			{title:'退费数量',field:'INDISReQty',width:90},
			{title:'中心交易流水号',field:'INDISInsuRetSeqNo',width:90},
			{title:'正记录dr$数量',field:'INDISPlusLinkNeg',width:90},
			{title:'单价(医保)',field:'INDISInsuPrice',width:90},
			{title:'数量(医保)',field:'INDISInsuQty',width:90},
			{title:'金额(医保)',field:'INDISInsuAmount',width:90},
			{title:'医保返回所有字段',field:'INDISInsuRetStr',width:90}
	 ]],
	 data:[]		
	});
}
///回车事件
function key_enter(){
	$('#PAPMINo').keyup(function(event){
		if(event.keyCode ==13){
			TmpPAPMINo=tkMakeServerCall("web.UDHCJFBaseCommon","regnocon",$('#PAPMINo').val())	//Zhan 20160725,登记号补全
			$("#PAPMINo").val(TmpPAPMINo)
			RunQuery();	
		}
	});	
}

//查询his发票基本信息
function RunQuery(){
	var StDate = getValueById('StDate');
	var EndDate = getValueById('EndDate');
	var PAPMINo = getValueById('PAPMINo'); 
	var rowindex,rowData=""
	//调用后台query输出数据his发票基本信息
	$HUI.datagrid('#HisInv',{
			url:$URL,  
		 	queryParams:{
				ClassName:"web.DHCINSUDivQue",
				QueryName:"findOPDivideSubByPAPMINo",
				StDate:StDate,
				EndDate:EndDate,
				PAPMINo:PAPMINo,
				HospId: session['LOGON.HOSPID']
			}, 
		 	onSelect : function(rowIndex, rowData) {
	    		loadInsDivSubData(rowIndex,rowData); 
	    	 }	
		},false);		
}

//查询出his发票信息，选中某一行查出对应发票的医保明细信息
function loadInsDivSubData(rowIndex,rowData){
	var PRTRowid=rowData.PrtRowid
	//alert("PRTRowid："+PRTRowid)
	$HUI.datagrid("#InsuDivSub",{
		idField:'Ind', 
			 	url:$URL,  
			 	queryParams:{
					ClassName:"web.DHCINSUDivQue",
					QueryName:"findDivideSubByPrtId",
					PRTRowid:PRTRowid,
				},	
			});
	}
//清屏
function clear_click() {
	window.location.reload();
}
//默认时间
function setDateBox() {
	setValueById('StDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0));
}


