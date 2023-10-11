//页面Gui
var objScreen = new Object();
function InitDMReportList(){
	var obj = objScreen;		  
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"DTH");
	//医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","E|EM","","",HospID);
	    }
    });
	var nowDate = new Date();
	nowDate.setMonth(nowDate.getMonth()-1);
	obj.txtStartDate = $('#txtStartDate').datebox('setValue', Common_GetDate(nowDate)); // 日期初始赋值
	obj.txtEndDate = $('#txtEndDate').datebox('setValue', Common_GetDate(new Date()));
	//报告状态
	$HUI.combobox("#cboRepStatus",{
		onLoadSuccess:function(){
			var data=$(this).combobox('getData');
			if (data.length>0){
				//默认选中第一个状态：待审
				$(this).combobox('select',data[0]['DicRowId']);
				obj.gridDeathReportLoad()  //刷新当前页
			}
		}
	})
	obj.cboRepStatus = Common_ComboToDic("cboRepStatus","DTHRunningState","1");

   obj.gridDeathReport = $HUI.datagrid("#gridDeath",{
		fit: true,
		title:'死亡报告查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'RowID',title:'操作',width:45,align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var ReportID = row["RowID"];
					var EpisodeID = row["EpisodeID"];
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) {
						var btn = '<a href="#" class="icon icon-paper" onclick="objScreen.OpenDeathReport(\'' + EpisodeID + '\',\'' + ReportID + '\')"></a>';
					} else {
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenDeathReport(\'' + EpisodeID + '\',\'' + ReportID + '\')"></a>';
					}
					return btn;
				}
			}, 
			{field:'link',title:'病历浏览',width:80,align:'center',
			  	formatter: function(value,row,index){
					if(row["OldRepFlag"]==1){
						return;
					}else{
						return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenEMR(\"" + row.EpisodeID + "\",\"" + row.PatientID + "\");'>病历浏览</a>";
					}
			  	}
			},	
			{field:'expander2',title:'修改日志',width:90,align:'center',
				formatter: function(value,row,index){
					return '<a href="#" onclick="objScreen.OpenLog(\'' + row["RowID"] + '\')">查看</a>';
				}
			},
			{field:'PapmiNo',title:'登记号',width:'100'},
			{field:'MrNo',title:'病案号',width:'100'},
			{field:'PatName',title:'姓名',width:'100'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'Age',title:'年龄',width:'50'},
			{field:'EncryptLevel',title:'密级',width:'80',hidden:(IsSecret==1 ? true:'')},
			{field:'PatLevel',title:'级别',width:'80',hidden:(IsSecret==1 ? true:'')}, 
			{field:'RepStatusDesc',title:'报告状态',width:'120'},
			{field:'RepUser',title:'上报人',width:'100'},
			{field:'RepLoc',title:'上报科室',width:'120'},				
			{field:'RepDateTime',title:'上报时间',width:'180'},	
			{field:'CheckTwoDate',title:'打印明细',width:'70',
				formatter: function(value,row,index){
					var ReportID = row["RowID"];
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) {
						var btn = '<a href="#" class="icon icon-search" onclick="objScreen.OpenPrintReason(\'' + ReportID + '\')"></a>';
					} else {
						var btn = '<a href="#" class="btn_search" onclick="objScreen.OpenPrintReason(\'' + ReportID + '\')"></a>';
					}
					return btn;
				}
			},
			{field:'PrintReason',title:'重复打印原因',width:'200'}		
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {
				obj.gridDeathReport_click(row);
			}
		}
	});
	// 死亡报告操作日志
	obj.gridDTHLogInfo = $HUI.datagrid("#gridDTHLogInfo",{
		fit: true,
		bodyCls:'panel-body-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{title: '操作类型', width: 80, field: 'StatusDesc',align:'center'},
			{title: '操作人', width: 90, field: 'UserName'},
			{title: '修改内容', width: 400, field: 'DTHEditContent',
				formatter: function(value,row,index){
					if (value) {
						var Content = ""
						for (var i=0; i<value.split('<br>').length; i++) {
							var item = value.split('<br>')[i]
							var ContentIndex=item.indexOf(':');
							if (ContentIndex > -1) {
								 Content += '<span style="color: red;">'+item.split(':')[0]+"</span>" + '：' + item.substring(ContentIndex+1) + '<br>';
							} else {
								Content += item + '<br>';
							}
						}
						return Content
					}
			  	}
			},
			{title: '操作日期', width: 100, field: 'DTHDate'},
			{title: '操作时间', width: 80, field: 'DTHTime'},
			{title: '登录科室', width: 120, field: 'LocDesc'}
		]]
	});
	InitDMReportListEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


