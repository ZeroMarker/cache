var obj = new Object();   
function InitPatScreen(){
	
	if (HideBtn==1) {   //隐藏按钮
		$('#btnCollect').hide();
		$('#btnSingin').hide();
	}else {
		$('#btnCollect').show();
		$('#btnSingin').show();
	}
	if (Status==1) $('#btnCollect').linkbutton("disable");
	if (Status==2) $('#btnSingin').linkbutton("disable");
	
	var EpisodeDrs="";
	obj.LocPatients = $HUI.datagrid("#LocPatients",{
		fit: true,
		title: "预警患者明细",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		url:$URL,
        queryParams:{
        	ClassName:"DHCHAI.IRS.CCWarningNewSrv",
			QueryName:"QryWarnPatList",
			aLocID:WarnLocID,
			aWarnDate:WarnDate,
			aWarnItems:WarnItems, 
			aSelItem:SelItem
		},
		columns:[[
			{field:'RegNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:100},
			{field:'MrNo',title:'病案号',width:100},
			{field:'Sex',title:'性别',width:50,align:'center'},
			{field:'Age',title:'年龄',width:60},
			{field:'WarnLocDesc',title:'预警科室',width:150},
			{field:'WarnBedDesc',title:'预警<br>床位',width:80,align:'center'},
			{field:'link',title:'摘要',width:50,align:'center',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.OperSummer_Click('+row.EpisodeDr+')>摘要</a>';
				}
			},
			{field:'InfInfo',title:'感染信息',width:200,showTip:true},
			{field:'AdmDate',title:'入院日期',width:100},
			{field:'AdmWard',title:'当前病区',width:150},
			{field:'AdmBed',title:'当前<br>床位',width:80,align:'center'},
			{field:'expander',title:'三管信息',width:80,align:'center',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.OperIntubate_Click('+row.EpisodeDr+')>三管信息</a>';
				}
			},
			{field:'BacteriaStr',title:'检出菌',width:200,showTip:true},
			{field:'DischDate',title:'出院日期',width:100}
		]],
		onLoadSuccess:function(data) {
			var total = data.total;
			var page = data.curPage; //当前页
			var pageSize =$('#LocPatients').data('datagrid').options.pageSize;
			var remainder  = total%pageSize;  //取余
			var count = parseInt(total/pageSize);  //取整
			var len = total ;  
			if (total>pageSize) {
				len = ((page>count) ? remainder : pageSize) ;//每次只加载当前页
			}
			for(var i=0;i<len;i++){
				if (!EpisodeDrs) {
					EpisodeDrs=data.rows[i].EpisodeDr;
				}else {
					EpisodeDrs = EpisodeDrs+","+data.rows[i].EpisodeDr;
				}
		  	}	
		  	LabSenListLoad(EpisodeDrs);
		}
	});
		
	function LabSenListLoad(aEpisodeIDs) {
		var Columns = [
			{field:'PatName',title:'姓名',width:100},
			{field:'WarnBedDesc',title:'床位',width:80,align:'center'},
			{field:'LabOrdDesc',title:'医嘱',width:200},
			{field:'Specimen',title:'标本',width:80},
			{field:'Bacteria',title:'细菌',width:150},
			{field:'MRBDesc',title:'多耐分类',width:200},
			{field:'ActDateTime',title:'送检时间',width:160},
			{field:'RepDateTime',title:'报告时间',width:160},
			{field:'AntSenList',title:'报告时间',width:500,hidden:true}
		];
		var Bact="",MRB="";
		if (ShowType==1) Bact=SelItem;
		if (ShowType==2) MRB=SelItem;
		
		var PatLabList=$cm ({
			ClassName:"DHCHAI.IRS.CCWarningNewSrv",
			QueryName:"QryWarnPatLab",
			aLocID:WarnLocID,
			aDateFrom:(WarnDate-WarnDays),
			aDateTo:WarnDate,
			aFlg:IsWarn24Hour, 
			aBact:Bact,
			aMRB:MRB,
			aEpisodeIDs:aEpisodeIDs,
			page:1,      //可选项，页码，默认1			
			rows:999    //可选项，获取多少条数据，默认50
		},false);
		var PatLabData = PatLabList.rows;
		var ListLen=PatLabList.total;

		var rs =[];rows="";
		if (ListLen>0) {
			AntSenStr = PatLabData[0].AntSenList;
			if (AntSenStr) {
				arrAntSen = AntSenStr.split(",");
				var len=arrAntSen.length;
				for (var i=0;i<len;i++) {
					var arrData=arrAntSen[i].split(":");
					var AntDesc=arrData[0].replace(/\//g, "-").replace(/\(/g, "-").replace(/\)/g, "");  //包含特殊字符的抗生素转义
					var SenDesc=arrData[1];
					var menuItem = {
	                    field: AntDesc,
	                    title: AntDesc,
	                    align: 'center',
	                    width: 100,
						styler: function(value,row,index){
							if ((value=="耐药")||(value=="+")) {
								return 'background-color:#FFA54A';	
							}else if (value=="中介") {
								return 'background-color:#00C1FF';	
							}else if ((value=="敏感")||(value=="-"))  {
								return 'background-color:#58EB8E';	
							}  
						}	
	                };
	               	Columns.push(menuItem);
				}
			}
			for (var j=0;j<ListLen;j++) {
				LabAntSenStr = PatLabData[j].AntSenList;			
				if (LabAntSenStr) {
					var arrLabAntSen = LabAntSenStr.split(",");
					var SenLen=arrLabAntSen.length;
					for (var k=0;k<SenLen;k++) {
						var arrData=arrLabAntSen[k].split(":");
						var AntDesc=arrData[0].replace(/\//g, "-").replace(/\(/g, "-").replace(/\)/g, "");  //包含特殊字符的抗生素转义
						var SenDesc=arrData[1];
		               	PatLabData[j][AntDesc]=SenDesc;
					}
				}
				
			}
		}		

		$HUI.datagrid("#LabSenList",{
			fit: true,
			title: "细菌耐药谱",
			iconCls:"icon-drug-eye",
			headerCls:'panel-header-gray',
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: false, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			pageSize: 20,
			pageList : [10,20,50,100],
			columns:[Columns]
		});
		$('#LabSenList').datagrid('loadData',PatLabData);	
	}
	obj.IntubateTable = $HUI.datagrid("#IntubateTable",{
		fit: true,
		title: "",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		nowrap:true,
		fitColumns: true,
		url:$URL,
        queryParams:{
        	ClassName:"DHCHAI.IRS.ICULogSrv",
			QueryName:"QryICUAdmOeItem"
		},
		columns:[[
			{field:'OeItemType',title:'三管类型',width:100},
			{field:'OeItemDesc',title:'医嘱名称',width:250},
			{field:'StartDt',title:'开嘱时间',width:200},
			{field:'EndDt',title:'停嘱时间',width:200}
		]]
	});
	
	InitPatScreenEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
$(function () {
	InitPatScreen();
});