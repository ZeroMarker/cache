var opl=ipdoc.lib.ns("ipdoc.patemrquality");
opl.view=(function(){
	var EmrQualityDataGrid;
	var toolbar=[{
		text: $g('执行'),
		iconCls: 'icon-exe-order',
		handler: function() {
			ExeEmrQuality();
		}
	}];
	var EmrQualityColumnsType1=[[ 
			/*质控*/
			/*{field:'Index',hidden:true},
			{field:'LinkQCBtn',title:'操作',width:50,
				formatter:function(value,rec){
	 				if (rec.QCRowID==""){
		 				return "";
		 			}
					var btn = '<a class="editcls" onclick="ipdoc.patemrquality.view.QCBtnClickHandler(\'' + rec.Index + '\')">操作</a>';
					return btn;
	            }
	        },
			{field:'QCMessageBody',title:'消息内容',width:180},
			{field:'QCCreateDate',title:'日期',width:140},
			{field:'QCCreateUserDesc',title:'医师',width:80},
			{field:'QCRowID',title:'消息id',hidden:true},*/
			{field:'Check',title:'选择',checkbox:'true',align:'center',width:70},
			{field:'RowID',hidden:true},
			{field:'MessageBody',title:'消息内容'},
			{field:'CreateDate',title:'质控日期'},
			{field:'CreateTime',title:'质控时间'},
			{field:'CreateUserDesc',title:'质控医师'},
			{field:'ExecuteStatus',title:'状态'},
			{field:'ExecuteDate',title:'执行日期'},
			{field:'ExecuteTime',title:'执行时间'},
		]];
		var EmrQualityColumnsType2=[[ 
		    /*时效性*/
 			/*{field:'ChronergyeName',title:'缺陷名称',width:350,hidden:true},
 			{field:'ChronergyeScore',title:'分值',width:50,hidden:true}*/
 			{field:'StructName',title:'病历文书'},
 			{field:'StrDate',title:'起始时间'},
 			{field:'EndDate',title:'截止时间'},
 			{field:'Hours',title:'剩余时间',
	 			formatter:function(Hours,rec){
		 			if (typeof Hours =="undefined"){Hours="";}
		 			//if (Hours!="") Hours=Hours.toFixed(2);  //$j(Hours,2,2)  //未超时的剩余时间
					if (Hours.indexOf("-")>=0) Hours = Hours.replace("-","超");// 超时时间
					return Hours;
		 		}
	 		},
 			{field:'FinishDate',title:'完成时间'},
 			{field:'OverFlag',title:'是否超时'}
		]]
	//初始化质控信息表格
	function Inittabemrquality(){
		$('#emr-tabs').tabs({
			onSelect: function(title,index){
				RelaodEmrQualityDataGrid(index);
			}
		});
		EmrQualityDataGrid=$("#tabEmrQuality").datagrid({ //$HUI.datagrid("#tabEmrQuality",{  
			fit : true,
			border : false,
			striped : true,
			singleSelect : false,
			fitColumns : false,		///列宽自适应
			autoRowHeight : false,
			nowrap: true,
			loadMsg : '加载中..', 
			pagination : false,  //
			rownumbers : true,  //
			//pageSize: 10,
			//pageList : [10,100,200],
			idField:'RowID',
			toolbar:toolbar,
			columns :EmrQualityColumnsType1,
			/*onCheck:function(rowIndex,rowData){
				if (rowData.ExecuteStatus=="已执行"){
					EmrQualityDataGrid.datagrid('uncheckRow',rowIndex);
					return false;
				}
			},*/
			rowStyler: function(index,row){
				var tab = $('#emr-tabs').tabs('getSelected');
				var TabIndex = $('#emr-tabs').tabs('getTabIndex',tab);
				if (TabIndex=="2"){
					if ((row.OverFlag=="是")&&(row.FinishDate=="")){
						return 'color:red;';
					}
				}
			},
			onCheckAll:function(rows){
				for (var i=0; i<rows.length; i++) {
					if (rows[i]['ExecuteStatus']==$g("已执行")) {
						$(this).datagrid('unselectRow',i);
					}else{
						$(this).datagrid('selectRow',i);
					}
			   }
			   $($("#emr-tabs").next().find("input")[0]).prop("checked", true);
			},
			onBeforeCheck:function(index, row){
				if (row['ExecuteStatus']==$g("已执行")) {
					$(this).datagrid('unselectRow',index);
					return false;
				}
			}
		});
		RelaodEmrQualityDataGrid(1);
		SetTabsTitle("");
	}
	function RelaodEmrQualityDataGrid(index){
		if (index=="1"){
			var Type="QC";
			var Param="";
			$HUI.datagrid('#tabEmrQuality',{columns:EmrQualityColumnsType1,toolbar:toolbar});	
			DocToolsHUI.MessageQueue.FireAjax("patemrquality.RelaodEmrQualityDataGrid");
	   		DocToolsHUI.MessageQueue.Add("patemrquality.RelaodEmrQualityDataGrid",$.q({
				ClassName:"EPRservice.Quality.DataAccess.BOQualityMessage",
				QueryName:"GetMessagesByEpisodeID",
				AEpisodeID:ServerObj.EpisodeID,
				AMsgStatus:"",
				rows:999 //Pagerows:EmrQualityDataGrid.datagrid("options").pageSize
			},function(GridData){
				//EmrQualityDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
				$HUI.datagrid('#tabEmrQuality',{
				    data:GridData
				});
			}));
		}else if (index=="2"){
			var Type="Chronergye";
			var Param="2_"+session['LOGON.GROUPID']+"_"+session['LOGON.CTLOCID'];
			$HUI.datagrid('#tabEmrQuality',{columns:EmrQualityColumnsType2,toolbar:""});	
			DocToolsHUI.MessageQueue.FireAjax("patemrquality.RelaodEmrQualityDataGrid");
	   		DocToolsHUI.MessageQueue.Add("patemrquality.RelaodEmrQualityDataGrid",$.q({
				ClassName:"EPRservice.Quality.BORunTimeQuality",
				QueryName:"GetQualityResultList",
				AEpisodeID:ServerObj.EpisodeID,
				AQualityRule:Param,
				rows:999
				//Param:Param //,
				//Pagerows:EmrQualityDataGrid.datagrid("options").pageSize,rows:99999
			},function(GridData){
				//EmrQualityDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
				$HUI.datagrid('#tabEmrQuality',{
				    data:GridData
				});
			}));
		}else{
			return
		}
	}
	function pagerFilter(data){
		if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
			data = {
				total: data.length,
				rows: data
			}
		}
		var dg = $(this);
		var opts = dg.datagrid('options');
		var pager = dg.datagrid('getPager');
		pager.pagination({
			showRefresh:false,
			onSelectPage:function(pageNum, pageSize){
				opts.pageNumber = pageNum;
				opts.pageSize = pageSize;
				pager.pagination('refresh',{
					pageNumber:pageNum,
					pageSize:pageSize
				});
				dg.datagrid('loadData',data);
				dg.datagrid('scrollTo',0); //滚动到指定的行        
			}
		});
		if (!data.originalRows){
			data.originalRows = (data.rows);
		}
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);
		data.rows = (data.originalRows.slice(start, end));
		return data;
	}
	function QCBtnClickHandler(Index){
		var RowIndex=$HUI.datagrid("#tabEmrQuality").getRowIndex(Index);
		var RowData=$HUI.datagrid("#tabEmrQuality").getData().rows[RowIndex];
		///web.eprajax.AjaxEPRMessage.cls?Action=readmessage&MessageIDS=" + messageIDS + "&UserID=" + userId,
		$.m({
			ClassName:"web.eprajax.AjaxEPRMessage",
			QueryName:"DoneMessage",
			AMessageIDS:RowData.QCRowID,
			AExecuteUserID:session['LOGON.USERID']
		},function(GridData){
			$HUI.datagrid('#tabEmrQuality').deleteRow(RowIndex);
			SetTabsTitle("QC");
		});
	}
	
	function SetTabsTitle(Type){
		var EmrQualityQtyJson=eval("("+ServerObj.EmrQualityQtyJson+")");
		var QCCount=EmrQualityQtyJson[0].QCCount;
		var ChronergyeCount=EmrQualityQtyJson[0].ChronergyeCount;
		if (Type=="QC"){
			QCCount=QCCount-1;
			EmrQualityQtyJson[0].QCCount=QCCount;
			ServerObj.EmrQualityQtyJson=JSON.stringify(EmrQualityQtyJson);
		}
		
		
		$("#emr-tabs").tabs('update', {
			tab: $("#emr-tabs").tabs('getTab',1),
			options: {
				title: $g('环节质控缺陷')+'('+QCCount+")"
			}
		}).tabs('update', {
			tab: $("#emr-tabs").tabs('getTab',2),
			options: {
				title: $g('时效性缺陷')+'('+ChronergyeCount+")"
			}
		});
	}
	function ExeEmrQuality(){
	   var SelRowRowData=EmrQualityDataGrid.datagrid('getSelections');
	   var AMessageIDS="";
	   for (i=0;i<SelRowRowData.length;i++){
		   if (SelRowRowData[i].ExecuteStatus==$g("未执行")) {
				if (AMessageIDS=="") AMessageIDS=SelRowRowData[i].RowID;
				else AMessageIDS=AMessageIDS+"^"+SelRowRowData[i].RowID;
		   }
	   }
	   if (AMessageIDS==""){
		   $.messager.alert("提示","请选择未执行的消息记录操作!");
		   return false;
	   }
	   $.m({
		    ClassName:"web.eprajax.AjaxEPRMessage",
		    MethodName:"DoneMessage",
		    AMessageIDS:AMessageIDS,
		    AExecuteUserID:session['LOGON.USERID']
		},function(val){
			if (val=="1"){
				RelaodEmrQualityDataGrid(1);
			}else{
				$.messager.alert("提示","执行失败!");
		   		return false;
			}
		})
	}
	function xhrRefresh(){
		var tab = $('#emr-tabs').tabs('getSelected');
		var index = $('#emr-tabs').tabs('getTabIndex',tab);
		$('#emr-tabs').siblings("div").css('width','100%');
		$('#emr-tabs .tabs-wrap').css('width','100%')
		EmrQualityDataGrid.datagrid("resize");
		RelaodEmrQualityDataGrid(index);
		SetTabsTitle("");
	}
	return {
		"RelaodEmrQualityDataGrid":RelaodEmrQualityDataGrid,
		"Inittabemrquality":Inittabemrquality,
		"QCBtnClickHandler":QCBtnClickHandler,
		"xhrRefresh":xhrRefresh
	}
   
})();
