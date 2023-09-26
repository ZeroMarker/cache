//insudivdesubqry.js
var GV={
      HOSPID:session["LOGON.HOSPID"]
	};
//界面入口
$(function(){
	initDocument();

});
function initDocument(){
			//回车事件
			key_enter();
			
			//加载项目分类
			init_XMFL();
			
	        //数据面板
	        var rowindex,rowData=""
			$HUI.datagrid("#DivSubInfoItem",{	
           	 	nowrap: true,
            	striped: true,	
				pagination:true,
				singleSelect:true,
				fit:true,
				//pagesize:100,
				//collapsible:true,
				//height:400,
				
				columns:[[
					{title:'序号',field:'ind',width:70,hidden:true},
					{title:'INDISRowid',field:'INDISRowid',width:70,hidden:true},
					{title:'医保结算表Dr',field:'DivideDr',width:70,hidden:true},
					{title:'医嘱项Dr',field:'ArcimDr',width:70,hidden:true},
					{title:'收费项Dr',field:'TarItmDr',width:70,hidden:true},
					{title:'医保项目Dr',field:'INSUItmDr',width:70,hidden:true},
					{title:'医嘱明细Dr',field:'OEORIDr',width:70,hidden:true},
					{title:'账单Dr',field:'PBDr',width:70,hidden:true},
					{title:'账单明细Dr',field:'PBDDr',width:70,hidden:true},
					{title:'医保编码',field:'INSUCode',width:90},
					{title:'医保名称',field:'INSUDesc',width:150},
					{title:'医保等级',field:'INSUXMLB',width:80},
					{title:'数量',field:'Qty',width:60},
					{title:'价格',field:'Price',width:60},
					{title:'金额',field:'Amount',width:90},
					{title:'住院分类',field:'TarCate',width:90},
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
					//dividesub表新增字段
					{title:'执行记录DR',field:'INDISExecDr',width:90},
					{title:'实际上传数量(医保)',field:'INDISUpQty ',width:90},
					{title:'退费数量',field:'INDISReQty',width:90},
					{title:'中心交易流水号',field:'INDISInsuRetSeqNo',width:90},
					{title:'正记录dr$数量',field:'INDISPlusLinkNeg',width:90},
					{title:'单价(医保)',field:'INDISInsuPrice',width:90},
					{title:'数量(医保)',field:'INDISInsuQty',width:90},
					{title:'金额(医保)',field:'INDISInsuAmount',width:90},
					{title:'医保返回所有字段',field:'INDISInsuRetStr',width:90}
				]]
				
				,
				data:[]
				
				
			});
			$("#Find").click=RunQuery;
	}
///回车事件
function key_enter(){
			$('#PBRowId').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			$('#TarCode').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			$('#InsuTarCode').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			$('#DisFlag').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();
				}
			});
			$('#TarDesc').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			$('InsuTarDesc').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			
			$('#PAPMINo').keyup(function(event){
				if(event.keyCode ==13){
					QueryPBRowid();		
				}
			});
}

//加载项目分类下拉框
function init_XMFL(){

$(function(){
	var cbox = $HUI.combobox("#InsuXMFLQry",{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[
			{id:'1',text:'全部项目'}
			,{id:'2',text:'自费项目'}
			,{id:'3',text:'超出治疗方案项目'}
			,{id:'4',text:'超限价自付项目'}
		],
		defaultFilter:4
	});
});
}


//查询
function RunQuery(){
	  
		var PBRowId=$('#PBRowId').val();
		var TarCode=$('#TarCode').val();
		var InsuTarCode=$('#InsuTarCode').val();
		var DisFlag=$('#DisFlag').val();
		var TarDesc=$('#TarDesc').val();
		var InsuTarDesc=$('#InsuTarDesc').val();
		var InsuXMFLQryobj=$HUI.combogrid("#InsuXMFLQry")
		var InsuXMFLQry=InsuXMFLQryobj.getValue();
		//调用后台query输出数据
		$HUI.datagrid('#DivSubInfoItem',{
			 	idField:'ind', 
			 	url:$URL,  
			 	queryParams:{
					ClassName:"web.DHCINSUDivQue",
					QueryName:"findDivideSubByPBRowId",
					PBRowId:PBRowId,
					TarCode:TarCode,
					InsuTarCode:InsuTarCode,
					DisFlag:DisFlag,
					TarDesc:TarDesc,
					InsuTarDesc:InsuTarDesc,
					InsuXMFLQry:InsuXMFLQry
				}, 
			 	singleSelect: true,   //
			 	//fitColumns:true,   //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
			 	selectOnCheck:true,
			 	pagesize:100,
			 	autoRowHeight:true,
			 	cache:false,
			 	loadMsg:'Loading',
			 	rownumbers:true,
			 	scrollbarSize:20,
			 	striped:true,
			 	pagination: true,  //分页
			 	
			},false);
}


//根据登记号查出相关住院账单信息
function QueryPBRowid(){
	TmpPAPMINo=tkMakeServerCall("web.UDHCJFBaseCommon","regnocon",$('#PAPMINo').val())	//Zhan 20160725,登记号补全
		$("#PAPMINo").val(TmpPAPMINo);
	$HUI.combogrid("#AdmLoc",{
			url:$URL+"?ClassName=web.DHCINSUDivQue&QueryName=searchAdm&RegNO="+$('#PAPMINo').val()+"&HospDr="+GV.HOSPID,
			idField:"TadmLoc",
			textField:"TadmLoc",
			singleSelect:true,
			panelWidth:500,
			columns:[[
				{title:'就诊科室',field:'TadmLoc',width:100},
				{title:'就诊病区',field:'TadmWard',width:150},
				{title:'就诊时间',field:'TadmDate',width:150},
				{title:'出院时间',field:'TdisDate',width:150},
				{title:'就诊ID',field:'TadmId',width:50},
				{title:'账单号',field:'PBRowID',width:50}
					]],
		onClickRow:function(rowIndex, rowData)
		{
			  setValueById('PBRowId',rowData.PBRowID);
			  
		},
		
		
		})
		
	}


//清屏
function clear_click() {
	window.location.reload();
}

