/*
	whb 2021.05.10 
	注: 1.需要添加公共变量的，在EPRservice.Quality.Ajax.QualityInfoShow.cls里
		  GetEmrQualityQty方法的do JsonObj.%Push(JsonData,"")前
		  加do JsonData.%Set("变量名",变量值_"")
		  然后在此js里用以下方法获取 
		  var EmrQualityQtyJson=eval("("+ServerObj.EmrQualityQtyJson+")");
		  var score = EmrQualityQtyJson[0].变量名;
		2.不能改变 RelaodEmrQualityDataGrid(),Inittabemrquality(),QCBtnClickHandler(),xhrRefresh()这四个方法的方法名称		
*/
var opl=ipdoc.lib.ns("ipdoc.patemrquality");
opl.view=(function(){
	var EmrQualityDataGrid;
	var toolbar=[{
		text: '处理',
		iconCls: 'icon-exe-order',
		handler: function() {
			ExeEmrQuality(1);
		}
	}];
	var toolbarD=[{
		text: '处理',
		iconCls: 'icon-exe-order',
		handler: function() {
			ExeEmrQuality(2);
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
			{field:'MessageBody',title:'消息内容',width:250,align:'left'},
			{field:'CreateDate',title:'质控日期',width:100,align:'left'},
			{field:'CreateTime',title:'质控时间',width:100,align:'left'},
			{field:'CreateUserDesc',title:'质控医师',width:100,align:'left'},
			{field:'ExecuteStatus',title:'状态',width:100,align:'left'},
			{field:'ExecuteDate',title:'处理日期',width:100,align:'left'},
			{field:'ExecuteTime',title:'处理时间',width:100,align:'left'},
		]];
		var EmrQualityColumnsType2=[[ 
			
			{field:'Check',title:'选择',checkbox:'true',align:'center',width:70},
			{field:'RowID',hidden:true},
			{field:'MessageTitle',title:'消息类型',width:150,align:'left'},
			{field:'MessageBody',title:'消息内容',width:250,align:'left'},
			{field:'CreateDate',title:'质控日期',width:100,align:'left'},
			{field:'CreateTime',title:'质控时间',width:100,align:'left'},
			{field:'CreateUserDesc',title:'质控医师',width:100,align:'left'},
			{field:$g('ExecuteStatus'),title:'状态',width:100,align:'left'},
			{field:'ExecuteDate',title:'处理日期',width:100,align:'left'},
			{field:'ExecuteTime',title:'处理时间',width:100,align:'left'},
		]];
		var EmrQualityColumnsType3=[[ 
		    /*时效性*/
 			/*{field:'ChronergyeName',title:'缺陷名称',width:350,hidden:true},
 			{field:'ChronergyeScore',title:'分值',width:50,hidden:true}*/
 			{field:'Record',title:'病历',
	 			formatter:function(v,r,i){
		 			return '<div title="创建病历" ><span class="icon-add">&nbsp;&nbsp;&nbsp;&nbsp;</span></div>'
		 		}
		 	},
 			{field:'StructName',title:'病历文书',width:300,align:'left'},
 			{field:'StrDate',title:'起始时间',width:100,align:'left'},
 			{field:'EndDate',title:'截止时间',width:100,align:'left'},
 			{field:'Hours',title:'剩余时间',width:100,align:'left',
	 			formatter:function(Hours,rec){
		 			if (typeof Hours =="undefined"){Hours="";}
		 			//if (Hours!="") Hours=Hours.toFixed(2);  //$j(Hours,2,2)  //未超时的剩余时间
					if (Hours.indexOf("-")>=0) Hours = Hours.replace("-","超");// 超时时间
					return Hours;
		 		}
	 		},
 			{field:'FinishDate',title:'完成时间',width:100,align:'left'},
 			{field:'OverFlag',title:'是否超时',width:100,align:'left'}
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
			striped : false,
			singleSelect : false,
			//fitColumns : true,		//列宽自适应
			autoRowHeight : false,
			nowrap: false,
			loadMsg : '加载中..', 
			pagination : false,  //
			rownumbers : true,  //
			//pageSize: 10,
			//pageList : [10,100,200],
			idField:'RowID',
			toolbar:toolbar,
			columns :EmrQualityColumnsType1,
			/*onCheck:function(rowIndex,rowData){
				if (rowData.ExecuteStatus=="已处理"){
					EmrQualityDataGrid.datagrid('uncheckRow',rowIndex);
					return false;
				}
			},*/
			rowStyler: function(index,row){
				var tab = $('#emr-tabs').tabs('getSelected');
				var TabIndex = $('#emr-tabs').tabs('getTabIndex',tab);
				if (TabIndex=="3"){
					if ((row.OverFlag=="是")&&(row.FinishDate=="")){
						return 'color:red;';
					}
				}
			},
			onCheckAll:function(rows){
				for (var i=0; i<rows.length; i++) {
					if (rows[i]['ExecuteStatus']=="已处理") {
						$(this).datagrid('unselectRow',i);
					}else{
						$(this).datagrid('selectRow',i);
					}
			   }
			   $($("#emr-tabs").next().find("input")[0]).prop("checked", true);
			},
			onBeforeCheck:function(index, row){
				if (row['ExecuteStatus']=="已处理") {
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
			$.q({
				ClassName:"EPRservice.Quality.DataAccess.BOQualityMessage",
				QueryName:"GetMessagesByEpisodeID",
				AEpisodeID:ServerObj.EpisodeID,
				AMsgStatus:"",
				AAction:"A",
				rows:999 //Pagerows:EmrQualityDataGrid.datagrid("options").pageSize
			},function(GridData){
				//EmrQualityDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
				$HUI.datagrid('#tabEmrQuality',{
				    data:GridData
				});
			});
		}else if (index=="2"){
			var Type="DQC";
			var Param="";
			$HUI.datagrid('#tabEmrQuality',{columns:EmrQualityColumnsType2,toolbar:toolbarD});	
			$.q({
				ClassName:"EPRservice.Quality.DataAccess.BOQualityMessage",
				QueryName:"GetMessagesByEpisodeID",
				AEpisodeID:ServerObj.EpisodeID,
				AMsgStatus:"",
				AAction:"D",
				rows:999 //Pagerows:EmrQualityDataGrid.datagrid("options").pageSize
			},function(GridData){
				//EmrQualityDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
				$HUI.datagrid('#tabEmrQuality',{
				    data:GridData
				});
			});
		}else if (index=="3"){
			var Type="Chronergye";
			var Param="2_"+session['LOGON.GROUPID']+"_"+session['LOGON.CTLOCID'];
			$HUI.datagrid('#tabEmrQuality',{columns:EmrQualityColumnsType3,toolbar:[],
			onClickCell: function(rowIndex, field, value) {
			  var rows = $('#tabEmrQuality').datagrid('getRows');
			  var row = rows[rowIndex];
			  var DocId = row.DocId;
			  
			  if(field =='Record'){
				var url="emr.interface.ip.main.csp?EpisodeID=" + ServerObj.EpisodeID+"&DocID="+DocId+"&FromType=EMR&DisplayType=Nav&RecordShowType=Doc"
				
				window.open (url,'newwindow','top=0,left=0,width='+window.screen.width+',height='+window.screen.height+',toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ') 
			  }
			},
			});		
			$.q({
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
			});
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
		var EmrQualityQtyJson=typeof ServerObj.EmrQualityQtyJson=="object"?ServerObj.EmrQualityQtyJson:eval("("+ServerObj.EmrQualityQtyJson+")");
		var QCCount=EmrQualityQtyJson[0].QCCount;
		var DQCCount=EmrQualityQtyJson[0].DQCCount;
		var ChronergyeCount=EmrQualityQtyJson[0].ChronergyeCount;
		if (Type=="QC"){
			QCCount=QCCount-1;
			EmrQualityQtyJson[0].QCCount=QCCount;
			ServerObj.EmrQualityQtyJson=JSON.stringify(EmrQualityQtyJson);
		}
		if (Type=="DQC"){
			DQCCount=DQCCount-1;
			EmrQualityQtyJson[0].DQCCount=DQCCount;
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
				title: $g('终末质控缺陷')+'('+DQCCount+")"
			}
		}).tabs('update', {
			tab: $("#emr-tabs").tabs('getTab',3),
			options: {
				title: $g('时效性缺陷')+'('+ChronergyeCount+")"
			}
		});
	}
	function ExeEmrQuality(Type){
	   var SelRowRowData=EmrQualityDataGrid.datagrid('getSelections');
	   var AMessageIDS="";
	   for (i=0;i<SelRowRowData.length;i++){
		   if (SelRowRowData[i].ExecuteStatus=="未处理") {
				if (AMessageIDS=="") AMessageIDS=SelRowRowData[i].RowID;
				else AMessageIDS=AMessageIDS+"^"+SelRowRowData[i].RowID;
		   }
	   }
	   if (AMessageIDS==""){
		   $.messager.alert("提示","请选择未处理的消息记录操作!");
		   return false;
	   }
	   $.m({
		    ClassName:"web.eprajax.AjaxEPRMessage",
		    MethodName:"DoneMessage",
		    AMessageIDS:AMessageIDS,
		    AExecuteUserID:session['LOGON.USERID']
		},function(val){
			if (val=="1"){
				RelaodEmrQualityDataGrid(Type);
			}else{
				$.messager.alert("提示","处理失败!");
		   		return false;
			}
		})
	}
	function xhrRefresh(){
		var tab = $('#emr-tabs').tabs('getSelected');
		var index = $('#emr-tabs').tabs('getTabIndex',tab);
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
