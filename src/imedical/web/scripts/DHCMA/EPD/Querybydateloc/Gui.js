//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;	
    $.parser.parse(); // 解析整个页面
	//极简风格
	if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) {
		$('#btnQuery').css('width','86px')
	}
    var nowdate = new Date();
    nowdate.setMonth(nowdate.getMonth()-1);
    var y = nowdate.getFullYear();
    var m = nowdate.getMonth()+1;
    var d = nowdate.getDate();
    var formatwdate = y+'-'+m+'-'+d;
    //$("#fdate").datebox("setValue",formatwdate);
	obj.DateFrom = $('#DateFrom').datebox('setValue', formatwdate);    // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	//初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"EPD");  
    
    //医院科室联动
	$HUI.combobox('#cboSSHosp',{	
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","",HospID);
	    }
    });
    
	//状态checkbox
	obj.chkStatus = function() {
		var strDicList =$m({
			ClassName:"DHCMed.EPDService.CommonSrv",
			MethodName:"GetDicList",
			aTypeCode:"EpidemicReportStatus",
			aIsActive:1
	 	},false);
	 	
	 	var dicList = strDicList.split(CHR_1);
		for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
			var dicSubList = dicList[dicIndex].split(CHR_2);
			var Status=dicSubList[0];
			if (Status==4) continue;   //被订不显示
			$("#chkStatusList").append(
				 "<div style='float:left;margin-right:20px;'><input id="+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name='chkStatus' value="+dicSubList[0]+"></div>"
			);
		}
		$.parser.parse("#chkStatusList");  //解析checkbox
	}
	obj.GetStatus = function() {
	    var Status = "";
		$("input[name='chkStatus']:checked").each(function(){
		      Status = Status + $(this).val()+ "*"; 
		});
		if (Status!="") { 
			Status = Status.substring(0, Status.length-1);
		}
		Status = "*"+Status+"*";
		return Status;
	}
	//上报位置下拉框
	obj.cboRepPlace = Common_ComboDicCode('cboRepPlace','RepPlace');
	//是否上报CDC下拉框
	obj.cboCDCStatus = Common_ComboDicCode('cboCDCStatus','EpdRepUploadStatus');
	//传染病类型下拉框
	obj.cboMIFKind = Common_ComboDicCode('cboMIFKind','EpdemicType');
	
	obj.gridEpdQuery =$HUI.datagrid("#gridEpdQuery",{
		fit: true,
		title: "传染病报告查询",
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'expander',title:'操作',width:45,align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var ReportID = row["RowID"];
					var PatientID = row["PatientID"];
					var EpisodeID = row["Paadm"];
					if(row["MIFAppendix"]){
						var RepHeight = "90%";
					}else{
						var RepHeight = "625";
					}
					if(row["OldRepFlag"]==1){
						var btn = '';
					}else{
						if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) {
							var btn = '<a href="#" class="icon icon-paper" onclick="objScreen.OpenEPDReport(\'' + ReportID + '\',\'' + PatientID + '\',\'' + EpisodeID + '\',\'' + RepHeight + '\')"></a>';
						} else {
							var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenEPDReport(\'' + ReportID + '\',\'' + PatientID + '\',\'' + EpisodeID + '\',\'' + RepHeight + '\')"></a>';
						}
					}
					return btn;
				}
			}, 
			{field:'IsUpload',title:'是否上报CDC',width:'100'},
			{field:'link',title:'病历浏览',width:80,align:'center',
			  	formatter: function(value,row,index){
					if(row["OldRepFlag"]==1){
						return;
					}else{
						return " <a href='#' onclick='objScreen.OpenEMR(\"" + row.Paadm + "\",\"" + row.PatientID + "\");'>病历浏览</a>";
					}
			  	}
			},	
			{field:'Status',title:'报告状态',width:70,
				styler: function(value,row,index){
					var retStr = "", tmpStatusCode = row["StatusCode"];
					if (tmpStatusCode==1) {
						retStr =  'color:red;';
					} else if (tmpStatusCode==2) {
						retStr = 'color:green;';
					}else if (tmpStatusCode==3) {
						retStr = 'color:orange;';
					} else if (tmpStatusCode==4) {
						retStr = 'color:olive;';
					} else if (tmpStatusCode==5) {
						retStr = 'color:black;';
					}else if (tmpStatusCode==6) {
						retStr = 'color:blue;';
					} else if (tmpStatusCode==7) {
						retStr = 'color:gray;';
					} else if (tmpStatusCode==8) {
						retStr = 'color:black;';
					}
					return retStr;
			}},
			{field:'IsPrint',title:'是否打印',width:70,align:'center',
				formatter: function(value,row,index){
					return (value==1) ? '是' : '否';
				}
			},
			{field:'expander2',title:'修改日志',width:90,align:'center',
				formatter: function(value,row,index){
					return '<a href="#" onclick="objScreen.OpenLog(\'' + row["RowID"] + '\')">查看</a>';
				}
			},
			{field:'expander1',title:'被订报告',width:80,align:'center',
				formatter: function(value,row,index){		
					var ReportID = row["MepdDR"];
					if (ReportID=="") return "";
					var PatientID = row["PatientID"];
					var EpisodeID = row["Paadm"];
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) {
						var btn = '<a href="#" class="icon icon-paper" onclick="objScreen.OpenRevised(\'' + ReportID + '\',\'' + PatientID + '\',\'' + EpisodeID + '\')">&nbsp;&nbsp;&nbsp;&nbsp;</a>';
					} else {
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenRevised(\'' + ReportID + '\',\'' + PatientID + '\',\'' + EpisodeID + '\')">&nbsp;&nbsp;&nbsp;&nbsp;</a>';
					}
					
					return btn;
				}
			}, 
			{field:'RegNo',title:'登记号',width:'110'},
			{field:'PatientName',title:'患者姓名',width:'120'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'Age',title:'年龄',width:'50'},
			{field:'EncryptLevel',title:'病人密级',width:'70',hidden:true},
			{field:'PatLevel',title:'病人级别',width:'150',hidden:true},
			{field:'Address',title:'现住址',width:'250'},
			{field:'MREPDDiag',title:'临床诊断',width:'250'},
			{field:'SeverityDesc',title:'临床严重程度',width:'100'},
			{field:'DiseaseName',title:'诊断名称',width:'250'},
			{field:'HistoryRep',title:'历史已报',width:'100'},
			{field:'RepKind',title:'疾病类别',width:'100'},
			{field:'TelPhone',title:'联系电话',width:'150'},
			{field:'RepUserName',title:'报告人',width:'100'},
			{field:'ReportDep',title:'报告科室',width:'150'},
			{field:'RepPlace',title:'上报位置',width:'100'},
			{field:'RepNo',title:'卡片编号',width:'150'},
			{field:'FamName',title:'家长姓名',width:'110'},
			{field:'CardNo',title:'有效证件号',width:'180'},
			{field:'Occupation',title:'职业',width:'150'},
			{field:'Company',title:'工作单位',width:'150'},
			{field:'RepRank',title:'疾病等级',width:'150'},
			{field:'SickDate',title:'发病日期',width:'100'},
			{field:'DiagDate',title:'诊断日期',width:'100'},
			{field:'DiagDateTime',title:'诊断时间',width:'80',
				formatter: function(value,row,index){
					if (value) {
						return value.split(' ')[1];
					}
					return '';
				}
			},
			{field:'DeathDate',title:'死亡日期',width:'100'},
			{field:'RepUserCode',title:'报告人工号',width:'100'},
			{field:'RepDate',title:'报告日期',width:'100'},
			{field:'RepTime',title:'报告时间',width:'80'},
			{field:'CheckUserName',title:'审核人',width:'150'},
			{field:'CheckUserCode',title:'审核人工号',width:'150'},
			{field:'CheckDate',title:'审核日期',width:'120'},
			{field:'CheckTime',title:'审核时间',width:'90'},
			{field:'DelReason',title:'退回/作废原因',width:'150'},
			{field:'DischDate',title:'出院日期',width:'150'},
			{field:'DischTime',title:'出院时间',width:'150'},
			{field:'DemoInfo',title:'备注',width:'150'}
		]],
		rowStyler : function(index, record) {
            if(record.OldRepFlag==1){
                 return 'background-color:#CCCCCC';
            }
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowData.OldRepFlag==1){
				$.messager.popover({msg: '历史报告不能打开！',type:'error',timeout: 2000});
				return;
			}else{
				obj.openHandler(rowData);
			}
		},onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	//传染病操作日志
	obj.gridEPDLogInfo = $HUI.datagrid("#gridEPDLogInfo",{
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
			{title: '修改内容', width: 400, field: 'EPDEditContent',
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
			{title: '操作日期', width: 100, field: 'EPDDate'},
			{title: '操作时间', width: 80, field: 'EPDTime'},
			{title: '登录科室', width: 120, field: 'LocDesc'}
		]],
 		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
			}
		}
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}