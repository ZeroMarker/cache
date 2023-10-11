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
  	// LocFlag==0  代表医生站
    if(LocFlag=="0"){
	    $("#cboRepLoc").combobox('setValue',session['LOGON.CTLOCID']);
	    $("#cboRepLoc").combobox('setText',session['LOGON.CTLOCDESC']);
	    $("#cboRepLoc").combobox('disable');
  	}
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
		title:'心脑血管事件报告查询',
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
			{field:'link',title:'病历浏览',width:80,align:'center',
			  	formatter: function(value,row,index){
					if(row["OldRepFlag"]==1){
						return;
					}else{
						return " <a href='#' onclick='objScreen.OpenEMR(\"" + row.EpisodeID + "\",\"" + row.PatientID + "\");'>病历浏览</a>";
					}
			  	}
			},	
			{title: '报告状态', width: 80, field: 'expander1',align:"center",
				formatter: function(value,row,index){
					var RepStatusDesc = row["RepStatusDesc"];
					return RepStatusDesc;
			  	}
			},
			{title: '报卡省', width: 80, field: 'RepProvince',align:"center"},    
			{title: '报卡市', width: 80, field: 'RepCity',align:"center"},        
			{title: '报卡县', width: 80, field: 'RepCounty',align:"center"}, 
			{title: '门/急诊号', width: 100, field: 'MZH',align:"center"},       
			{title: '住院号', width: 100, field: 'MrNo',align:"center"},  
			{title: '姓名', width: 100, field: 'PatName',align:"center"}, 
			{title: '证件类型', width: 100, field: 'CardType',align:"center"},            
			{title: '身份证号', width: 180, field: 'IDCradNum',align:"center"},            
			{title: '其他证件号', width: 180, field: 'Certificate',align:"center"}, 
			{title: '性别', width: 50, field: 'PatSex',align:"center"},  
			{title: '出生日期', width: 120, field: 'Birthday'},  
			{title: '民族', width: 80, field: 'Nation'},  
			{title: '职业', width: 240, field: 'Occupation',showTip:true,align:"center"},   
			{title: '婚姻状况', width: 80, field: 'Marriage',align:"center"},  
			{title: '本人电话', width: 120, field: 'TelPhone',align:"center"},
			{title: '工作单位', width: 120, field: 'Company',align:"center"},
			{title: '联系人', width: 120, field: 'LXR',align:"center"},
			{title: '联系人电话', width: 120, field: 'TempNullData',align:"center"},
			{title: '户籍地址省', width: 120, field: 'RegProvince',align:"center"},    
			{title: '户籍地址市', width: 120, field: 'RegCity',align:"center"},        
			{title: '户籍地址县', width: 120, field: 'RegCounty',align:"center"},     
			{title: '户籍地址乡', width: 120, field: 'RegVillage',align:"center"},    
			{title: '户籍地址村', width: 120, field: 'RegRoad',align:"center"},  
			{title: '户籍地址号', width: 120, field: 'NullData14',align:"center"}, 
			{title: '现住地址省', width: 120, field: 'CurrProvince',align:"center"},    
			{title: '现住地址市', width: 120, field: 'CurrCity',align:"center"},        
			{title: '现住地址县', width: 120, field: 'CurrCounty',align:"center"},     
			{title: '现住地址乡', width: 120, field: 'CurrVillage',align:"center"},    
			{title: '现住地址村', width: 120, field: 'CurrRoad',align:"center"}, 
			{title: '现住地址号', width: 120, field: 'NullData13',align:"center"}, 
			{title: '在本辖区居住<br>六个月以上', width: 100, field: 'LiveSix',align:"center"},  
			{title: '发病日期', width: 100, field: 'FBRQ',align:"center"},  
			{title: '是否首次发病', width: 100, field: 'SFSCFB',align:"center"},  
			{title: '诊断日期', width: 100, field: 'QZRQ',align:"center"},  
			{title: '诊断', width: 120, field: 'ZDMC',align:"center"}, 
			{title: '心绞痛治疗方式', width: 140, field: 'CureMethod',align:"center"}, 
			{title: '脑卒中类型', width: 120, field: 'ApoplexyType',align:"center"},    
			{title: '心源性猝死依据', width: 120, field: 'SCD',align:"center"},   
			{title: '心源性猝死<br>推断类型', width: 180, field: 'Infer',showTip:true,align:"center"},   
			{title: '诊断ICD', width: 80, field: 'ZDICD',align:"center"},      
			{title: '诊断依据', width: 200, field: 'ZDYJs',showTip:true,align:"center"},  
			{title: '（病史说明）<br>临床症状体征', width: 120, field: 'NullData1',align:"center"}, 
			{title: '检查结果<br>（生化标志物）', width: 120, field: 'NullData2',align:"center"}, 
			{title: '检查结果<br>（心电图）', width: 120, field: 'NullData3',align:"center"}, 
			{title: '检查结果<br>（血管造影）', width: 120, field: 'NullData4',align:"center"}, 
			{title: '检查结果<br>（超声心动图）', width: 120, field: 'NullData5',align:"center"}, 
			{title: '检查结果<br>（CT/CTA/SPECT）', width: 140, field: 'NullData6',align:"center"}, 
			{title: '检查结果<br>（MRI）', width: 100, field: 'NullData7',align:"center"}, 
			{title: '检查结果<br>（腰穿）', width: 100, field: 'NullData8',align:"center"}, 
			{title: '检查结果<br>（手术）', width: 100, field: 'NullData9',align:"center"}, 
			{title: '检查结果<br>（尸检或病理）', width: 120, field: 'NullData10',align:"center"},
			{title: '补发类型', width: 100, field: 'Reissue',align:"center"},  
			{title: '补发补充说明', width: 120, field: 'NullData11',align:"center"}, 
			{title: '其他生化指标', width: 120, field: 'BiochemicalMark',align:"center"},  
			{title: '出院记录（小结）', width: 120, field: 'NullData12',align:"center"}, 
			{title: '诊断单位', width: 100, field: 'QZDW',align:"center"},  
			{title: '单位级别', width: 100, field: 'DWLevel',align:"center"},  
			{title: '转归', width: 80, field: 'OutCome',align:"center"}, 
			{title: '死亡日期', width: 120, field: 'SWRQ',align:"center"},
			{title: '根本死因', width: 120, field: 'SWYY',align:"center"},
			{title: '根本死因<br>编码ICD10', width: 150, field: 'SYID',align:"center"},
			{title: '报告单位', width: 240, field: 'ReportOrgan',align:"center"},  
			{title: '报告科室', width: 120, field: 'RepLocDesc',align:"center"},  
			{title: '报告医师', width: 120, field: 'ReportUser',align:"center"},   
			{title: '报告日期', width: 120, field: 'ReportDate',align:"center"},     
			{title: '退回原因', width: 120, field: 'DelReason'}  
			
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


