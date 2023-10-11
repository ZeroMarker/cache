//页面Gui
var objScreen = new Object();
function InitViewport(){
	var obj = objScreen;		  	
    
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"CD");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","E","","",HospID);
	    }
    });
	var nowDate = new Date();
	nowDate.setMonth(nowDate.getMonth()-1);
	obj.txtFromDate = $('#txtFromDate').datebox('setValue', Common_GetDate(nowDate));// 日期初始赋值
    obj.txtToDate = $('#txtToDate').datebox('setValue', Common_GetDate(new Date()));
  	
	//报告状态
	obj.chkStatusList = Common_CheckboxToDic("chkStatusList","CRReportStatus",5);
	var DicInfo = $m({                   
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicByDesc",
		argType:"CRReportStatus",
		argDesc:"上报",
		argIsActive:"1"
	},false);
	$('#chkStatusList'+DicInfo.split("^")[0]).checkbox('setValue', (DicInfo.split("^")[0]!="" ? true:false));  
	
	obj.gridRepInfo = $HUI.datagrid("#gridRepInfo",{
		fit: true,
		title:'高血压报告查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{title:'操作',width:45,field:'expander',align:'center',
				formatter: function(value,row,index){
					var ReportID = row["ReportID"];
					var EpisodeID = row["EpisodeID"];
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")){
						var btn = '<a href="#" class="icon icon-paper" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}else{
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}
					return btn;
				}
			}, 
			{title: '报告状态', width: 120, field: 'expander1',
				formatter: function(value,row,index){
					return  row["RepStatusDesc"];
				}
			}, 
			{title: '卡片编号', width: 100, field: 'expander2',
				formatter: function(value,row,index){
					return  row["KPBH"];
				}
			},        
			{title: '登记号', width: 100, field: 'expander3',
				formatter: function(value,row,index){
					return  row["PapmiNo"];
				}
			},       
			{title: '患者姓名', width: 120, field: 'PatName'},      
			{title: '性别', width: 50, field: 'PatSex'},      
			{title: '出生日期', width: 160, field: 'Birthday'}, 
			{title: '身份证件类型', width: 160, field: 'CaraType'}, 
			{title: '身份证件号码', width: 220, field: 'CaraNo'}, 
			{title: '民族', width: 160, field: 'Nation'}, 
			{title: '国籍', width: 120, field: 'Country',hidden:true,exportHidden:false}, 
			{title: '学历', width: 160, field: 'Education',hidden:true,exportHidden:false}, 
			{title: '婚姻状况', width: 160, field: 'Marriage',hidden:true,exportHidden:false}, 
			{title: '职业类型', width: 160, field: 'Occupation',hidden:true,exportHidden:false}, 
			{title: '工作单位', width: 160, field: 'Company',hidden:true,exportHidden:false}, 
			{title: '联系人', width: 160, field: 'RelateMan',hidden:true,exportHidden:false}, 
			{title: '联系人/监护人与本人关系', width: 160, field: 'Relationship',hidden:true,exportHidden:false}, 
			{title: '联系电话(手机)', width: 160, field: 'RelationTelOne',hidden:true,exportHidden:false}, 
			{title: '联系电话(座机)', width: 160, field: 'RelationTelTwo',hidden:true,exportHidden:false}, 
			{title: '现住址(类型)', width: 160, field: 'CurrAddType',hidden:true,exportHidden:false}, 
			{title: '现住址(编码)', width: 160, field: 'CurrAddCode',hidden:true,exportHidden:false}, 
			{title: '现住详细地址', width: 160, field: 'CurrAddInfo'}, 
			{title: '本县区居住6个月以上', width: 160, field: 'IsLiveSixInfo',hidden:true,exportHidden:false}, 
			{title: '户籍地址(类型)', width: 160, field: 'RegAddType',hidden:true,exportHidden:false}, 
			{title: '户籍地址(编码)', width: 160, field: 'RegAddCode',hidden:true,exportHidden:false}, 
			{title: '户籍详细地址', width: 160, field: 'RegAddInfo',hidden:true,exportHidden:false}, 
			{title: '疾病icd', width: 160, field: 'DiagICD',hidden:true,exportHidden:false}, 
			{title: '首次诊断日期', width: 160, field: 'FirstDiagDate',hidden:true,exportHidden:false}, 
			{title: '确诊日期', width: 160, field: 'DiagDate',hidden:true,exportHidden:false}, 
			{title: '家族史', width: 160, field: 'FamilyHistory'}, 
			{title: '与患者关系', width: 160, field: 'PatRelationship'},    
			{title: '住院号', width: 120, field: 'MrNo',hidden:true,exportHidden:false},    
			{title: '门诊号', width: 120, field: 'OPNo',hidden:true,exportHidden:false}, 
			{title: '收缩压', width: 180, field: 'SSY'},            
			{title: '舒张压', width: 120, field: 'SZY'},          
			{title: '病情转归', width: 120, field: 'Reversion',hidden:true,exportHidden:false},
			{title: '死亡日期', width: 160, field: 'DeathDate',hidden:true,exportHidden:false}, 
			{title: '死亡原因', width: 160, field: 'DeathReason',hidden:true,exportHidden:false}, 
			{title: '具体死亡原因', width: 160, field: 'DeathReasonInfo',hidden:true,exportHidden:false}, 
			{title: '最告诊断单位', width: 120, field: 'MostUnit',hidden:true,exportHidden:false},
			{title: '症状', width: 220, field: 'SymptomList',showTip:true},   
			{title: '诊断地区(编码)', width: 120, field: 'DiagPlaceCode',hidden:true,exportHidden:false},
			{title: '诊断机构(编码)', width: 120, field: 'DiagUnitCode',hidden:true,exportHidden:false}, 
			{title: '治疗日期', width: 160, field: 'TreatDate',hidden:true,exportHidden:false},    
			{title: '开始治疗日期', width: 160, field: 'StartTreatDate',hidden:true,exportHidden:false}, 
			{title: '治疗类型', width: 160, field: 'TreatType',hidden:true,exportHidden:false},     
			{title: '不良反应出现日期', width: 160, field: 'ADRsAppearDate',hidden:true,exportHidden:false}, 
			{title: '不良反应确诊日期', width: 160, field: 'ADRsDiagDate',hidden:true,exportHidden:false}, 
			{title: '不良反应诊断', width: 160, field: 'ADRsDiag',hidden:true,exportHidden:false},       
			{title: '不良反应发生药物', width: 160, field: 'ADRsDrug',hidden:true,exportHidden:false},  
			{title: '停止治疗日期', width: 160, field: 'EndTreatDate',hidden:true,exportHidden:false},  
			{title: '停止治疗原因', width: 160, field: 'EndTreatReason',hidden:true,exportHidden:false},  
			{title: '预约来院检查时间', width: 160, field: 'AppointmentDate',hidden:true,exportHidden:false},  
			{title: '实际来院检查时间', width: 160, field: 'ActualDate',hidden:true,exportHidden:false},  
			{title: '治疗地区(编码)', width: 160, field: 'TreatPlaceCode',hidden:true,exportHidden:false},   
			{title: '治疗机构(编码)', width: 160, field: 'TreatUnitCode',hidden:true,exportHidden:false},   
			{title: '报告医师', width: 160, field: 'ReportUser'}   
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {
				obj.gridRepInfo_click();
			}
		},onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});

	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


