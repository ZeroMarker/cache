/**
 * welcome 首页
 * 
 * CREATED BY liyi 2020-05-26
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_arrLateLoc:[]
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	//InitEvent();
})

function Init(){
	LoadNoticeData();
	InitVolLate1();
	InitDischDigest();
	$m({
		ClassName:"MA.IPMR.SSService.WelcomeSrv",
		MethodName:"ProcessData"
	},function(txtData){
	});
}

function LoadNoticeData () {
	// 超期未归还
	$m({
		ClassName  : "MA.IPMR.SSService.VolLendQry",
		MethodName : "GetNotRetrunCount"
	},function(txtData){
		var cnt = txtData;
		$("#NotRetrunCount").html(cnt);
	});
	
	// 借阅待审批
	$m({
		ClassName  : "MA.IPMR.SSService.VolLendRequestSrv",
		MethodName : "GetToAuditCount",
		aLendTypeID:'',
		aDateFrom:'',
		aDateTo:'',
		aStatusID:ServerObj.auditBorrowStatusID,
		aHospID:Logon.HospID,
		aUserID:'', 
		aLocID:''
	},function(txtData){
		var cnt = txtData;
		$("#AuditBorrowCount").html(cnt);
	});
	// 召回待审批
	$m({
		ClassName  : "MA.IPMR.SSService.VolReCallSrv",
		MethodName : "GetToCheckCount",
		aHospID:Logon.HospID,
		aMrTypeID:Logon.MrTypeID,   //7
		aDiscLocID:'',
		aStatusCode:ServerObj.auditReCallStatus
	},function(txtData){
		var cnt = txtData;
		$("#AuditReCallCount").html(cnt);
	});
}

function btnUnReturn_Click(){
	var strUrl = "./ma.ipmr.ss.vollendqry.csp?&MrClass=I&2=2"
	/*websys_showModal({
		url:strUrl,
		title:'超期未归还',
		iconCls:'icon-w-epr',  
		originWindow:window,
		width:1340,
		height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
	});*/
	window.parent.addTab({
		url:strUrl,
		title:'超期未归还'
	});
}

function toAuditBorrow_Click(){
	/*websys_showModal({
		url:ServerObj.auditBorrowUrl,
		title:'病案借阅审批',
		iconCls:'icon-w-epr',  
		originWindow:window,
		width:1340,
		height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
	});*/
	window.parent.addTab({
		url:ServerObj.auditBorrowUrl,
		title:'病案借阅审批'
	});
}

function toAuditReCall_Click(){
	/*websys_showModal({
		url:ServerObj.auditReCallUrl,
		title:'病案召回审批',
		iconCls:'icon-w-epr',  
		originWindow:window,
		width:1340,
		height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
	});*/
	window.parent.addTab({
		url:ServerObj.auditReCallUrl,
		title:'病案召回审批'
	});
}

// 
function InitVolLate1() {
	$cm({
    	ClassName:"MA.IPMR.SSService.WelcomeSrv",
    	QueryName:"QryVolLateStatis",
		aHospID:Logon.HospID,
		aMrTypeID:Logon.MrTypeID,   //7
		aDateFrom:Common_GetDate(-30,""),		// Common_GetDate("","FIRST")
		aDateTo:Common_GetDate(0,""),
    	page:1,
    	rows:100
    },function(rs){
    	var arrLocDesc = new Array();
		var arrLateVolSum1 = new Array();
		var arrLateVolSum2 = new Array();
		var arrLateVolSum3 = new Array();
		var arrLateVolSum7 = new Array();
		
		for (var indRd = 0; indRd < rs.rows.length; indRd++){
			var rd =rs.rows[indRd];
			arrLocDesc.push(rd.StatLocDesc);
			/*arrLateVolSum1.push(rd.Dis1DLateCnt);
			arrLateVolSum2.push(rd.Dis2DLateCnt);
			arrLateVolSum3.push(rd.Dis3DLateCnt);
			arrLateVolSum7.push(rd.Dis7DLateCnt);*/
			
			var dataInfo1 = myData(rd.Dis1DLateCnt, rd.StatLocDesc, rd.StatLocID);
			var dataInfo2 = myData(rd.Dis2DLateCnt, rd.StatLocDesc, rd.StatLocID);
			var dataInfo3 = myData(rd.Dis3DLateCnt, rd.StatLocDesc, rd.StatLocID);
			var dataInfo7 = myData(rd.Dis7DLateCnt, rd.StatLocDesc, rd.StatLocID);
			arrLateVolSum1[indRd] = dataInfo1;
			arrLateVolSum2[indRd] = dataInfo2;
			arrLateVolSum3[indRd] = dataInfo3;
			arrLateVolSum7[indRd] = dataInfo7;
			
			globalObj.m_arrLateLoc[indRd]=rd.StatLocID;
		}
		// 1日迟归
		var VolLate1Chart = echarts.init(document.getElementById('divVolLate1'));
		var option = {
			grid:{
				x:52,
				y:40,
				x2:30,
				y2:60
			},
			tooltip : {
				trigger: 'axis'
			},
			calculable : true,
			xAxis : [
				{
					type : 'category',
					data : arrLocDesc,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
							if(value.length>6 && value.length<11){
								return value.substr(0,5)+'\n'+value.substr(5,5);
							}else if(value.length>10){
								return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
							}else{
								return value;
							}
						}
					},	           
					splitLine:{
								show:false
							}
				}
			],
			yAxis : [
				{
					type : 'value',
					splitLine:{
								show:true,
								lineStyle:{
									color:'#cccccc'
								}
							}
				}
			],
			series : [
				{
					name:$g('病历数') ,
					type:'bar',
					data:arrLateVolSum1,
					barWidth: 30,
					markPoint : {
						data : [
							{type : 'max', name: '最大值'},
							{type : 'min', name: '最小值'}
						]
					}
				}
			]
		};
		VolLate1Chart.setOption(option);

		// 2日迟归
		var VolLate2Chart = echarts.init(document.getElementById('divVolLate2'));
		var option = {
			grid:{
				x:52,
				y:40,
				x2:30,
				y2:60
			},
			tooltip : {
				trigger: 'axis'
			},
			calculable : true,
			xAxis : [
				{
					type : 'category',
					data : arrLocDesc,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
							if(value.length>6 && value.length<11){
								return value.substr(0,5)+'\n'+value.substr(5,5);
							}else if(value.length>10){
								return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
							}else{
								return value;
							}
						}
					},	           
					splitLine:{
								show:false
							}
				}
			],
			yAxis : [
				{
					type : 'value',
					splitLine:{
								show:true,
								lineStyle:{
									color:'#cccccc'
								}
							}
				}
			],
			series : [
				{
					name:$g('病历数'),
					type:'bar',
					data:arrLateVolSum2,
					barWidth: 30,
					markPoint : {
						data : [
							{type : 'max', name: '最大值'},
							{type : 'min', name: '最小值'}
						]
					}
				}
			]
		};
		VolLate2Chart.setOption(option);
		
		// 3日迟归
		var VolLate3Chart = echarts.init(document.getElementById('divVolLate3'));
		var option = {
			grid:{
				x:52,
				y:40,
				x2:30,
				y2:60
			},
			tooltip : {
				trigger: 'axis'
			},
			calculable : true,
			xAxis : [
				{
					type : 'category',
					data : arrLocDesc,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
							if(value.length>6 && value.length<11){
								return value.substr(0,5)+'\n'+value.substr(5,5);
							}else if(value.length>10){
								return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
							}else{
								return value;
							}
						}
					},	           
					splitLine:{
								show:false
							}
				}
			],
			yAxis : [
				{
					type : 'value',
					splitLine:{
								show:true,
								lineStyle:{
									color:'#cccccc'
								}
							}
				}
			],
			series : [
				{
					name:$g('病历数'),
					type:'bar',
					data:arrLateVolSum3,
					barWidth: 30,
					markPoint : {
						data : [
							{type : 'max', name: '最大值'},
							{type : 'min', name: '最小值'}
						]
					}
				}
			]
		};
		VolLate3Chart.setOption(option);

		// 7日迟归
		var VolLate7Chart = echarts.init(document.getElementById('divVolLate7'));
		var option = {
			grid:{
				x:52,
				y:40,
				x2:30,
				y2:60
			},
			tooltip : {
				trigger: 'axis'
			},
			calculable : true,
			xAxis : [
				{
					type : 'category',
					data : arrLocDesc,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
							if(value.length>6 && value.length<11){
								return value.substr(0,5)+'\n'+value.substr(5,5);
							}else if(value.length>10){
								return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
							}else{
								return value;
							}
						}
					},	           
					splitLine:{
								show:false
							}
				}
			],
			yAxis : [
				{
					type : 'value',
					splitLine:{
								show:true,
								lineStyle:{
									color:'#cccccc'
								}
							}
				}
			],
			series : [
				{
					name:$g('病历数'),
					type:'bar',
					data:arrLateVolSum7,
					barWidth: 30,
					markPoint : {
						data : [
							{type : 'max', name: '最大值'},
							{type : 'min', name: '最小值'}
						]
					}
				}
			]
		};
		VolLate7Chart.setOption(option);
		
		//点击事件
		VolLate1Chart.on('click', function(params) {
			openLateWin(params);
		});
		VolLate2Chart.on('click', function(params) {
			openLateWin(params);
		});
		VolLate3Chart.on('click', function(params) {
			openLateWin(params);
		});
		VolLate7Chart.on('click', function(params) {
			openLateWin(params);
		});
		// end
    });
}

function myData(value, name,aLocID) {
    var o = new Object();
    o.value = value;
    o.name = name;
    o.aLocID = aLocID;
    return o;
}

function openLateWin(params){
	var aLocID	= params.data.aLocID;
	
	// update for 点击最大/小数字,弹出查询页面科室为undefined
	if (typeof(aLocID)=='undefined') {
		var tId	= params.data.coord[0];
		aLocID	= globalObj.m_arrLateLoc[tId]
	}
	if (typeof(aLocID)=='undefined'){aLocID=''}
	// end
	
    var strUrl = "./ma.ipmr.ss.vollateqry.csp?"+
    			 "&aHospID="+Logon.HospID+
    			 //"&aMrTypeID=7"+  
    			 "&aMrTypeID="+Logon.MrTypeID+
    			 "&aDateFrom="+Common_GetDate(-30,"")+		// Common_GetDate("","FIRST")
    			 "&aDateTo="+Common_GetDate(0,"")+
    			 "&aLocGrpID="+
    			 "&aLocID="+aLocID+
    			 "&aWelcomeFlg="+1+
    			 "&2=2"
	/*websys_showModal({
		url:strUrl,
		title:'迟归查询',
		iconCls:'icon-w-epr',  
		originWindow:window,
		width:1340,
		height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
	});*/
	window.parent.addTab({
		url:strUrl,
		title:'迟归查询'
	});
}

// 出院病历概述
function InitDischDigest(){
	var DateFrom	= Common_GetDate(-30,"")
	var DateTo		= Common_GetDate(0,"")
	
	var columns = [[
		{field:'LocDesc',title:'科室',width:180,align:'left'},
		{field:'EDischCount',title:'医生医疗结算',width:100,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 1;	// 医疗结算详情
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'NurseDischCount',title:'护士最终结算',width:100,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 2;	// 护士最终结算详情
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'NoNurseDischCount',title:'待最终结算',width:80,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 3;	// 待护士最终结算详情
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'EMRCompleteCount',title:'医生点送病案室',width:110,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 4;	// 医生点送病案室详情
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'NoEMRCompleteCount',title:'医生未点送病案室',width:120,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 5;	// 医生未点送病案室详情
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'PDFCount',title:'生成PDF',width:70,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 6;	// 生成PDF
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'NoPDFCount',title:'未生成PDF',width:80,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 7;	// 未生成PDF
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'BackCount',title:'已回收',width:60,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 8;	// 已回收
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'waitBackCount',title:'待回收',width:60,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 9;	// 待回收
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'CodeCount',title:'已编目',width:60,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 10;	// 已编目
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		},
		{field:'waitCodeCount',title:'待编目',width:60,align:'left'
			,formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tLocID	= row['LocID'];
					var tTitle	= this.title;
					var tLocDesc= row['LocDesc'];
					var QryFlg	= 11;	// 待编目
					
					var btn='<a href="#" onclick="InitDetails(\'' + tLocID+'\',\''+ QryFlg + '\',\''+ tLocDesc + '\',\''+ tTitle + '\')">'+tValue+'</a>';
					return btn;
			}
		}
	]];
	
	var gridDischVol = $HUI.datagrid("#gridDischVol",{
		fit:true,
		title:"",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		singleSelect:true,
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList: [7,10,20],
		toolbar: [] ,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.VolDischQry",
			QueryName:"QryDischDigest",
			aHospID:Logon.HospID,
			aMrTypeID:Logon.MrTypeID,  //7
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aLocId:'',
			aQryFlg:'',
			rows:10000
		},
		columns :columns
	});
}

function InitDetails(aLocId,aQryFlg,aLocDesc,aTitle){
	
	var aTitle  = $g(aTitle);
	var _title = aLocDesc+"-"+aTitle,_icon="icon-w-list"
	var VolDtlDialog = $('#VolDtlDialog').dialog({
	    title: _title,
		iconCls:_icon,
	    width: 1200,
	    height: 480,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
	
	var DateFrom	= Common_GetDate(-30,"")
	var DateTo		= Common_GetDate(0,"")
	
	var dtlColumns = [[
		{field: 'PapmiNo', title: '登记号', width: 100, align: 'left'},
		{field: 'PatName', title: '姓名', width: 100, align: 'left'},
		{field: 'MrNo', title: '病案号', width: 100, align: 'left'},
		{field: 'Sex', title: '性别', width: 40, align: 'left'},
		{field: 'Age', title: '年龄', width: 50, align: 'left'},
		{field: 'DocName', title: '主管医生', width:70, align: 'left'},
		{field: 'HisDischLocDesc', title: 'HIS出院科室', width: 120, align: 'left'},
		{field: 'HisDischWardDesc', title: 'HIS出院病区', width:120, align: 'left'},
		{field: 'EDischDateTime', title: '医疗结算日期', width: 100, align: 'left'},
		{field: 'NurseDischDateTime', title: '最终结算日期',width:100 ,align: 'left'},
		{field: 'EMRComplete', title: '医生送病案室', width: 100, align: 'left'},
		{field: 'PDFComplete', title: '生成PDF', width: 70, align: 'left'},
		{field: 'BackDate', title: '回收日期', width: 100, align: 'left'},
		{field: 'CodingDateTime', title: '编目日期', width: 100, align: 'left'}
		//,{field: 'VolID', title: '卷号', width: 40, align: 'left'}
	]];
	
	var gridVolDtl= $HUI.datagrid("#gridVolDtl", {
		fit: true,
		iconCls : 'icon-write-order',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : false,
		url : $URL,
	    queryParams : {
		    ClassName:"MA.IPMR.SSService.VolDischQry",
		    QueryName:"QryDischDigest",
		    aHospID:Logon.HospID,
		    aMrTypeID:Logon.MrTypeID,  //7
		    aDateFrom:DateFrom,
		    aDateTo:DateTo,
			aLocId:aLocId,
			aQryFlg:aQryFlg,
		    rows:10000
	    },
	    columns : dtlColumns
	});
}

$('#dtl_export').click(function() {
	var _title=$('#VolDtlDialog').panel('options').title+"数据";
	
	var data = $('#gridVolDtl').datagrid('getData');
	if (data.rows.length==0)
	{
		$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
		return;
	}
	$('#gridVolDtl').datagrid('Export', {
		filename: _title,
		extension:'xls'
	});
});