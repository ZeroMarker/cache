//页面Gui
function InitVAEScreeningWin(){
	var obj = new Object();
	obj.tatal = '';
	obj.ShowType = 1;
	var HsopID = $.LOGON.HOSPID;
	var UserID = $.LOGON.USERID;
	var User = $.LOGON.USERDESC;
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",HsopID);
	
	//医院表格联动
	$HUI.combobox('#cboHospital',{
		onSelect:function(data){
			setTimeout(function(){
				//加载感染科室疑似筛查汇总  
				obj.gridLocVAE();
				obj.gridLocVAELoad();
			},1000);
		}
	});
	
	//感染科室疑似筛查汇总
	obj.gridLocVAE = function() {
		$HUI.datagrid("#gridLocVAE",{   
			fit:true,
			//nowrap:false,
			fitColumns:true,
			singleSelect:true,
			pagination:false,
			remoteSort:false,   //本地数据排序必须设置为false
			sortName:'LocDesc',
			sortOrder:'desc',
			loadMsg:'数据加载中...',
			columns:[[ 
				{field:'LocDesc',title:'科室名称',width:240,hidden:true},
				{field:'ScreeningCnt',title:'待处理',width:100,align:'center',hidden:true},
				{field:'DealTodayCnt',title:'今日处理',width:120,align:'center',hidden:true},			
				{field:'ScreenActCnt',title:'已处理',width:100,align:'center',hidden:true}, 
				{field:'InPatientCnt',title:'在科人数',width:100,align:'center',hidden:true}
			]],
			view: detailview,
			autoUpdateDetail:false,   //合计行放在最上方时，这个属性必须设置为false，否则更新行内容后无法展示明细数据
			detailFormatter:function(index, rowData){	
				//科室患者明细
				//合计行在上方第一行
				var rows = $('#gridLocVAE').datagrid('getRows');
				var total = rows.length;
				if (total>1) {
					if (!rowData.LocID) {
						return '<div style="padding:5px 5px 5px 0px;"><table id=gridAdmInfo'+index+'></table></div>';	
					}else {
						return '<div style="padding:5px 5px 5px 0px;"><table id=gridAdmInfo'+(index+1)+'></table></div>';	
					}
				}
				if (total==1) {
					//只有一行不加合计行
					return '<div style="padding:5px 5px 5px 0px;"><table id=gridAdmInfo'+index+'></table></div>';
				}
				//合计行在下方最后一行
				//return '<div style="padding:5px 5px 5px 0px;"><table id=gridAdmInfo'+index+'></table></div>';	
			}, 
			onExpandRow: function(pindex, rowData){
				/*
				//if (pindex>=obj.tatal) {  //合计行在下方最后一行不展开数据			
				if (pindex==0) { //合计行在上方第一行不允许操作
					$('#gridLocVAE').datagrid('collapseRow',pindex);
					$("#gridLocVAE").datagrid('clearSelections');  //取消选中
				}
				*/
				var rows = $('#gridLocVAE').datagrid('getRows');
				$.each(rows,function(i,k){
					//获取当前所有展开的子网格
					var expander = $('#gridLocVAE').datagrid('getExpander',i);
					if(expander.length && expander.hasClass('datagrid-row-collapse')){
						if(k.LocID != rowData.LocID){
							//折叠上一次展开的子网格
							$('#gridLocVAE').datagrid('collapseRow',i);
						}
					}
				});
				
				obj.gridLocAdmInfo = $HUI.datagrid('#gridAdmInfo'+pindex,{   //科室患者明细
				    idField:'EpisodeID',
					pageSize: 10,
					pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
					showPageList:false,  //不显示页面尺寸的选择列表		
					singleSelect: true,
					autoRowHeight: true,
					fitColumns: true,
					loadMsg:'数据加载中...',
					url:$URL,
					queryParams:{
						ClassName:'DHCHAI.IRS.VAEScreeningSrv',
						QueryName:'QrySuRulePatList',
						aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
						aDateFrom:$('#aDateFrom').datebox('getValue'), 
						aDateTo:$('#aDateTo').datebox('getValue'), 
						aLocID:rowData.LocID,
						aShowType:obj.ShowType,
						aHospIDs:$('#cboHospital').combobox('getValue'),
						aViewFlag:2				
					},
					columns:[[
						{field:'PapmiNo',title:'登记号',width:120},	 
						{field:'PatName',title:'姓名',width:80}, 
						{field:'Sex',title:'性别',width:50}, 
						{field:'CurrBed',title:'床号',width:60,align:'center'},
						{field:'zy',title:'处置状态',width:80,
							formatter: function(value,row,rindex){
								var StatusStr="";
								if (row.ActStatusCode==1) {
									StatusStr="<img src='../scripts/DHCMA/HAI/img/确.png'>";
								}else if(row.ActStatusCode==2){
									StatusStr= "<img src='../scripts/DHCMA/HAI/img/排.png'>";	
								}
								return  StatusStr;
							}	
						}
					]]
					,rowStyler: function(index,row){
						if(obj.ShowType==9){
							if (row.ActItemFlag==1) {  //VAE标志 
								return 'color:#B22222'; 
							}else{
								return 'color:gray';
							}
						}else{
							if (row.PendingFlag==1) {  //待处理 
								return 'color:red'; 
							}else if(row.ActStatusCode==1){
								return 'color:black';
							}else{
								return 'color:gray';
							}
						}
					},
					onResize: function () {
						$('#gridLocVAE').datagrid('fixDetailRowHeight', pindex);
					},
					onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
						if (rindex>-1) {
							var rData = $('#gridAdmInfo'+pindex).datagrid('getRows')[rindex];
							obj.gridAdmInfo_onSelect(pindex,rindex,rData);
						}	
					},
					onLoadSuccess: function (data) {
						setTimeout(function () {
							$('#gridLocVAE').datagrid('fixDetailRowHeight', pindex);
						}, 0);
					}				
				});
			}
			,onClickCell: function(rindex,field,value){  //展开时onSelect 执行两遍，换成onClickCell
			    //if (rindex>=obj.tatal) return;  //合计行在下方最后一行不允许操作
				if ((rindex==0)&&(obj.tatal>1)) return;  //合计行在上方第一行不允许操作
				if ( field=="_expander") return;
				if (rindex>-1) {
					var rowData = $('#gridLocVAE').datagrid('getRows')[rindex];
					obj.gridLocVAE_onSelect(rindex,'',rowData);
				}	
			},onLoadSuccess:function(data) {
				//显示列				
				window.setTimeout(function () {	
					$("#gridLocVAE").datagrid("showColumn", "LocDesc");
					if (obj.ShowType==1) {
						 $("#gridLocVAE").datagrid("showColumn", "ScreeningCnt");					
						 if(Common_RadioValue('radAdmStatus')==1) {
						 	$("#gridLocVAE").datagrid("showColumn", "DealTodayCnt");
						 }else {
							 $("#gridLocVAE").datagrid("hideColumn", "DealTodayCnt");
						 }
					}else if (obj.ShowType==2) { //已处理
						 $("#gridLocVAE").datagrid("showColumn", "ScreenActCnt");
						 $("#gridLocVAE").datagrid("showColumn", "InPatientCnt");						 						 
					}else{  //全院所有默认不传参数
						 $("#gridLocVAE").datagrid("showColumn", "InPatientCnt");
					}				
				}, 200); 
					
				obj.tatal = data.total;   //获取原始数据行总数
				if (data.total>1) {	
					//合计行在上方第一行
					$('#gridLocVAE').datagrid('insertRow',{
						index: 0,   // 索引从0开始
						row: {
							LocDesc:'<span class="subtotal">合计</span>',
							InPatientCnt:'<span class="subtotal">'+compute("InPatientCnt")+'</span>',
							DealTodayCnt:'<span class="subtotal">'+compute("DealTodayCnt")+'</span>',
							ScreeningCnt:'<span class="subtotal">'+compute("ScreeningCnt")+'</span>',
							ScreenActCnt:'<span class="subtotal">'+compute("ScreenActCnt")+'</span>'
						}
					});
				}
			}
		});
		$('.datagrid-sort-icon').css("display", "none");
	}
	
	//指定列求和
	function compute(colName) {
		var rows = $('#gridLocVAE').datagrid('getRows');
		
		var total = 0;
		for (var i = 0;i<rows.length;i++) {
			total +=parseFloat(rows[i][colName]);
		}
		return total;
	}
	
	InitPatDtl(obj);
	InitVAEScreeningWinEvent(obj);	
	obj.LoadEvent(arguments);
	window.setTimeout(function (){
		$("#ToolBarInf").parent().css("border-top-width","0px");
	}, 1000);
	
	return obj;
}


