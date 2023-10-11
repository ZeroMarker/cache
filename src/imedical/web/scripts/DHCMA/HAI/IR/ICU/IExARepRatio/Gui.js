//页面Gui
var obj = new Object();
function InitIExARatioWin(){
	$.parser.parse();
	//医院
	Common_ComboToMSHosp("cboHospital",$.LOGON.HOSPID);
	$HUI.combobox("#cboHospital",{
		onChange:function(newValue,oldValue){  //给医院增加onChange事件，更新科室列表
			var HospIDs=$('#cboHospital').combobox('getValues').join('|');
			var Alias   = "";
			var LocCate = "I";
			var LocType = Common_CheckboxValue('chkStatunit');
			//科室病区
			Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);
		}
	});

	// 日期赋初始值
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var MonthList = $cm ({									//初始化月+季度+全年
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth"
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);
	
	//筛选条件
	obj.cboConditions = Common_ComboDicCode("cboQryCon","StatScreenCondition");
	$('#cboQryCon').combobox('setValue',1);
	$('#cboQryCon').combobox('setText',"显示全部病区(科室)");
	
	$HUI.radio("[name='chkStatunit']",{
        onChecked:function(e,value){
	        var Statunit = $(e.target).val();   //当前选中的值
			var HospIDs =  $("#cboHospital").combobox('getValues').join('|');
			var Alias   = "";
			var LocCate = "I";
			var LocType = Statunit;
	        setTimeout(function(){
				ShowStatDimens("cboShowType",LocType);
		      	//科室病区
				Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);
			 }, 200);
        }
    });
	
	$HUI.radio("#chkStatunit-Ward").setValue(true);
	var unitConfig = $m({
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "StatV2ScreenuUnit"
	},false);

	if (unitConfig) {
		if (unitConfig == 'E') {
			$HUI.radio("#chkStatunit-Loc").setValue(true);
		}
	}
	
	//展示维度	
	ShowStatDimens("cboShowType",Common_CheckboxValue('chkStatunit'));
	$HUI.combobox("#cboShowType",{
		onSelect:function(row,index){
			if ((row.Code.indexOf(Common_CheckboxValue('chkStatunit'))<0)) {
				$('#cboLoc').combobox('clear');
				$('#cboLoc').combobox('disable');
			}else {
				$('#cboLoc').combobox('enable');
			}
		}
	});
	
	//初始化科室
	Common_ComboToMSLoc("cboLoc",$('#cboHospital').combobox('getValues').join('|'),"","I",Common_CheckboxValue('chkStatunit'));
	
	var IsCheckFlag=false;
	var date=new Date()
	date.setDate(1);

	//三管感染核心防控措施执行率统计列表
	 obj.gridIExARepRatio = $HUI.datagrid("#gridIExARepRatio",{
		fit: true,
		title: "",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortName:'ind',  //将"全部"放在第一行
		sortOrder:'asc',
		remoteSort:false,
		pageSize: 30,
		pageList : [30,60,100,200],
		columns: [[ {field: 'ind',  title: '',width: 70, rowspan: 2,  align: 'center' ,sorter:Sort_int, hidden:true },	
            	{field: 'xDimensKey', title: '维度', width: 70, rowspan: 2, align: 'center' , hidden:true },
            	{field: 'DimensDesc', title: '单位', width: 200 ,rowspan: 2,formatter: function(value,row,index) {
						var StaType  = row.xDimensKey.split("-")[3];
						if ((StaType=="W")||(StaType=="E")){
							return '<span style="padding-left:30px">'+value+'</span>';
						} else {
							return value;
						}
					} },
                {field: 'InCount', title: '住院人数', width: 70, rowspan: 2, align: 'center', 
					formatter:function(value,row,index){
						var HospID 	= $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "ALL";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubePatDtl(\""+HospID+"\", \""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					} 
				},
                {field: 'InDays', title: '住院天数', width: 70, rowspan: 2 , align: 'center'},
                { title: '血管导管', align: 'center', colspan: 13 },
                { title: '呼吸机', align: 'center', colspan: 13 },
                { title: '导尿管', align: 'center', colspan: 13 }
            ], [
	            { field: 'PICCCount', title: $g('插管<br>人数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var aHospIDs = $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "PICC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');		
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubeDayDtl(\""+aHospIDs+"\",\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					}
	            },
	            { field: 'PICCDays', title: $g('插管<br>总天数'), width: 60, align: 'center'},
	            { field: 'PICCRatio', title: $g('使用率'), width: 70 , align: 'center'},
	            { field: 'PICCInfectPat', title: $g('感染<br>人数'), width: 60, align: 'center' ,
					formatter:function(value,row,index){
						var aHospIDs = $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "PICC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');		
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubeInfDtl(\""+aHospIDs+"\",\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					}
				},
	            { field: 'PICCINFCount', title: $g('感染<br>例次数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var aHospIDs = $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "PICC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');		
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubeInfDtl(\""+aHospIDs+"\",\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					}
				},
	            { field: 'PICCINFRatio', title: $g('感染<br>发病率'), width: 80 , align: 'center'},
	            { field: 'PICCReps', title: $g('督查<br>表总数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "PICC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						var IsExe=0;
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenDtlInfo(\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\",\""+IsExe+"\");'>" +value+ "</a>";
					} 
				},
	            { field: 'PICCRepExes', title: $g('执行督<br>查表数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "PICC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						var IsExe=1;
						return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.OpenDtlInfo(\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\",\""+IsExe+"\");'>" +value+ "</a>";
					} 
				},
	            { field: 'PICCRepNExes', title: $g('未执行<br>督查表数'), width: 70 , align: 'center',
					formatter:function(value,row,index){
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "PICC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						var IsExe=2;
						return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.OpenDtlInfo(\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\",\""+IsExe+"\");'>" +value+ "</a>";
					} 
				},
	            { field: 'PICCRepRatio', title: $g('执行率'), width: 75 , align: 'center'},
	            { field: 'PICCRepExeDays', title: $g('需执行<br>总天数'), width: 60 , align: 'center'},
	            { field: 'PICCRepRealExeDays', title: $g('实际执<br>行天数'), width: 60 , align: 'center'},
	            { field: 'PICCRepRealExeDaysRatio', title: $g('天数执<br>行率'), width: 70 , align: 'center'},
	            
	            { field: 'VAPCount', title: $g('插管<br>人数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var aHospIDs = $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "VAP";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');		
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubeDayDtl(\""+aHospIDs+"\",\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					}
				},
	            { field: 'VAPDays', title: $g('插管<br>总天数'), width: 60, align: 'center'},
	            { field: 'VAPRatio', title: $g('使用率'), width: 70 , align: 'center'},
	            { field: 'VAPInfectPat', title: $g('感染<br>人数'), width: 60, align: 'center' ,
					formatter:function(value,row,index){
						var aHospIDs = $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "VAP";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');		
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubeInfDtl(\""+aHospIDs+"\",\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					}
				},
	            { field: 'VAPINFCount', title: $g('感染<br>例次数'), width: 60 , align: 'center' ,
					formatter:function(value,row,index){
						var aHospIDs = $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "VAP";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');		
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubeInfDtl(\""+aHospIDs+"\",\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					}
				},
	            { field: 'VAPINFRatio', title: $g('感染<br>发病率'), width: 80 , align: 'center'},
	            { field: 'VAPReps', title: $g('督查<br>表总数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "VAP";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						var IsExe=0;
						return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.OpenDtlInfo(\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\",\""+IsExe+"\");');'>" +value+ "</a>";
					} 
				},
	            { field: 'VAPRepExes', title: $g('执行督<br>查表数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "VAP";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						var IsExe=1;
						return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.OpenDtlInfo(\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\",\""+IsExe+"\");');'>" +value+ "</a>";
					} 
				},
	            { field: 'VAPRepNExes', title: $g('未执行<br>督查表数'), width: 70 , align: 'center',
					formatter:function(value,row,index){
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "VAP";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						var IsExe=2;
						return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.OpenDtlInfo(\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\",\""+IsExe+"\");');'>" +value+ "</a>";
					} 
				}, 
	            { field: 'VAPRepRatio', title: $g('执行率'), width: 75 , align: 'center'},
	            { field: 'VAPRepExeDays', title: $g('需执行<br>总天数'), width: 60 , align: 'center'},
	            { field: 'VAPRepRealExeDays', title: $g('实际执<br>行天数'), width: 60 , align: 'center'},
	            { field: 'VAPRepRealExeDaysRatio', title: $g('天数执<br>行率'), width: 70 , align: 'center'},
	            
	            { field: 'UCCount', title: $g('插管<br>人数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var aHospIDs = $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "UC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');		
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubeDayDtl(\""+aHospIDs+"\",\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					}
				},
	            { field: 'UCDays', title: $g('插管<br>总人数'), width: 60, align: 'center'},
	            { field: 'UCRatio', title: $g('使用率'), width: 70 , align: 'center'},
	            { field: 'UCInfectPat', title: $g('感染<br>人数'), width: 60, align: 'center'  ,
					formatter:function(value,row,index){
						var aHospIDs = $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "UC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');		
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubeInfDtl(\""+aHospIDs+"\",\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					}
				},
	            { field: 'UCINFCount', title: $g('感染<br>例次数'), width: 60 , align: 'center' ,
					formatter:function(value,row,index){
						var aHospIDs = $('#cboHospital').combobox('getValues').join('|');
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "UC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');		
						return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenTubeInfDtl(\""+aHospIDs+"\",\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\");'>" +value+ "</a>";
					}
				},
	            { field: 'UCINFRatio', title: $g('感染<br>发病率'), width: 80 , align: 'center'},
	            { field: 'UCReps', title: $g('督查<br>表总数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "UC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						var IsExe=0;
						return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.OpenDtlInfo(\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\",\""+IsExe+"\");'>" +value+ "</a>";
					} 
				},
	            { field: 'UCRepExes', title: $g('执行督<br>查表数'), width: 60 , align: 'center',
					formatter:function(value,row,index){
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "UC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						var IsExe=1;
						return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.OpenDtlInfo(\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\",\""+IsExe+"\");'>" +value+ "</a>";
					} 
				},
	            { field: 'UCRepNExes', title: $g('未执行<br>督查表数'), width: 70 , align: 'center',
					formatter:function(value,row,index){
						var DateFrom = $('#dtDateFrom').datebox('getValue');
						var DateTo= $('#dtDateTo').datebox('getValue');
						var xDimensKey=row.xDimensKey;
						var StaType = Common_CheckboxValue('chkStatunit');
						var TubeType = "UC";
						var ICULocID =$('#cboLoc').combobox('getValues').join(',');
						var IsExe=2;
						return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.OpenDtlInfo(\""+DateFrom+"\", \""+DateTo+"\", \""+xDimensKey+"\", \""+StaType+"\", \""+TubeType+"\", \""+ICULocID+"\",\""+IsExe+"\");'>" +value+ "</a>";
					} 
				},
	            { field: 'UCRepRatio', title: $g('执行率'), width: 75 , align: 'center'},
	            { field: 'UCRepExeDays', title: $g('需执行<br>总天数'), width: 60 , align: 'center'},
	            { field: 'UCRepRealExeDays', title: $g('实际执<br>行天数'), width: 60 , align: 'center'},
	            { field: 'UCRepRealExeDaysRatio', title: $g('天数执<br>行率'), width: 70 , align: 'center'}
	        ]
	    ],
		onSelect:function(rowIndex,rowData){
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridIExARepRatio').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	
	//三管感染核心防控措施执行率统计明细表
	obj.gridIExARatiolDtl= $HUI.datagrid("#gridIExARatiolDtl",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap: false, 	//换行(false为自动换行)
		//fitColumns: true,	
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		columns:[[
			{field:'PapmiNo',title:'登记号',width:110,align:'center',sortable: true },
			{field:'PatName',title:'姓名',width:80,align:'center',sortable: true,
				formatter:function(value,row,index){
					 return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.btnAbstractMsg_Click(\"" + row.EpisodeID + "\");'>" +row.PatName+ "</a>";
				}
			},
			{field:'Sex',title:'性别',width:60,align:'center',sortable:true},
			{field:'Age',title:'年龄',width:60,align:'center',sortable:true,sorter:Sort_Age},
		
			{field:'AdmDateTime',title:'入院时间',width:170,align:'center',sortable: true},
			{field:'AdmLocDesc',title:'就诊科室',width:120,align:'center',sortable: true},
			{field:'DischDateTime',title:'出院时间',width:170,align:'center',sortable: true},
			{field:'DischLocDesc',title:'出院科室',width:120,align:'center',sortable: true},
			{field:'TubeType',title:'督查表类型',width:120,align:'center',sortable: true,
				formatter:function(value,row,index){
					if (value == "PICC"){
					 	return "血管导管督查表";
					}
					else if (value == "VAP"){
						return "呼吸机督查表";
					}
					else if (value == "UC"){
						return "导尿管督查表";
					}
				}
			},
			{field:'IAIntuDate',title:'督查开始日期',width:100,align:'center',sortable: true},
			{field:'IAExtuDate',title:'督查结束日期',width:100,align:'center',sortable: true},
			{field:'xIExAID',title:'督察表ID',width:70,align:'center',sortable: true,sorter:Sort_int},
			{field:'IADays',title:'需执行总天数',width:110,align:'center',sortable: true},
			{field:'IAEexDays',title:'实际执行天数',width:110,align:'center',sortable: true},
			{field:'IANExeDays',title:'未执行天数',width:110,align:'center',sortable: true},
			{field:'IATypeDesc',title:'督察表',width:110,align:'center',sortable: true,
				formatter:function(value,row,index){
					var str = row.IATypeDesc + " " + row.IAIntuDate;
					return "<a href='#' style='white-space:normal; color:Blue' onclick='obj.OpenIExARep(\"" + row.xIExAID + "\");'>" +str+ "</a>";
				}
			}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	
	//住院患者明细表
	obj.gridTubePatDtl= $HUI.datagrid("#gridTubePatDtl",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap: false, 	//换行(false为自动换行)
		//fitColumns: true,	
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortName:'EpisodeID',
		sortOrder:'asc',
		remoteSort:false,
		columns:[[
			{field:'DimensDesc',title:'统计单位',width:140,align:'center',sortable: true },
			{field:'EpisodeID',title:'患者ID',width:80,align:'center',sortable: true,sorter:Sort_int },
			{field:'PapmiNo',title:'登记号',width:100,align:'center',sortable: true },
			{field:'MrNo',title:'病案号',width:100,align:'center',sortable: true },
			{field:'PatName',title:'姓名',width:80,align:'center',sortable: true,
				formatter:function(value,row,index){
					 return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.btnAbstractMsg_Click(\"" + row.EpisodeID + "\");'>" +row.PatName+ "</a>";
				}
			},
			{field:'Sex',title:'性别',width:60,align:'center',sortable: true },
			{field:'Age',title:'年龄',width:60,align:'center',sortable: true },
			{field:'AdmBed',title:'床号',width:60,align:'center',sortable: true },
			{field:'AdmTimes',title:'住院次数',width:100,align:'center',sortable: true },
			{field:'AdmDateTime',title:'入院时间',width:170,align:'center',sortable: true},
			{field:'AdmLocDesc',title:'入院科室',width:100,align:'center',sortable: true},
			{field:'DischDateTime',title:'出院时间',width:170,align:'center',sortable: true},
			{field:'DischLocDesc',title:'出院科室',width:120,align:'center',sortable: true},
			{field:'TubeDays',title:'插管天数',width:100,align:'center',sortable: true},
			{field:'TranLocDesc',title:'入住病区',width:120,align:'center',sortable: true },
			{field:'TransDateTime',title:'入病区时间',width:170,align:'center',sortable: true},
			{field:'OutLocDateTime',title:'出病区时间',width:170,align:'center',sortable: true}
		]],
		
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
		
	});


	//（PICC,UC,VAP）使用明细表-插管人数
	obj.gridTubeDayDtl= $HUI.datagrid("#gridTubeDayDtl",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap: false, 	//换行(false为自动换行)
		//fitColumns: true,	
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortName:'EpisodeID',
		sortOrder:'asc',
		remoteSort:false,
		columns:[[
			{field:'DimensDesc',title:'统计单位',width:140,align:'center',sortable: true },
			{field:'EpisodeID',title:'患者ID',width:80,align:'center',sortable: true,sorter:Sort_int },
			{field:'PapmiNo',title:'登记号',width:100,align:'center',sortable: true },
			{field:'MrNo',title:'病案号',width:90,align:'center',sortable: true },
			{field:'PatName',title:'姓名',width:80,align:'center',sortable: true,
				formatter:function(value,row,index){
					 return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.btnAbstractMsg_Click(\"" + row.EpisodeID + "\");'>" +row.PatName+ "</a>";
				}
			},
			{field:'Sex',title:'性别',width:60,align:'center',sortable:true},
			{field:'Age',title:'年龄',width:60,align:'center',sortable:true,sorter:Sort_Age},
			{field:'AdmBed',title:'床号',width:60,align:'center',sortable:true},
			{field:'AdmTimes',title:'住院次数',width:100,align:'center',sortable:true},
			{field:'AdmDateTime',title:'入院时间',width:170,align:'center',sortable: true},
			{field:'AdmLocDesc',title:'入院科室',width:120,align:'center',sortable: true},
			{field:'DischDateTime',title:'出院时间',width:170,align:'center',sortable: true},
			{field:'DischLocDesc',title:'出院科室',width:120,align:'center',sortable: true},
			{field:'TubeDays',title:'插管天数',width:100,align:'center',sortable: true},
			{field:'TranLocDesc',title:'入住病区',width:120,align:'center',sortable: true },
			{field:'TransDateTime',title:'入病区时间',width:170,align:'center',sortable: true},
			{field:'OutLocDateTime',title:'出病区时间',width:170,align:'center',sortable: true},
			{field:'OrdItemID',title:'医嘱号',width:90,align:'center',sortable: true},
			{field:'OEItmMast',title:'侵害性操作名称',width:170,align:'center',sortable: true},
			{field:'SttDateTime',title:'使用开始时间',width:170,align:'center',sortable: true },
			{field:'EndDateTime',title:'使用结束时间',width:170,align:'center',sortable: true },
			{field:'OrdDateTime',title:'开医嘱时间',width:170,align:'center',sortable: true },
			{field:'OrdLocDesc',title:'开医嘱科室',width:100,align:'center',sortable: true },
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	//（PICC,UC,VAP）新发生明细表-感染人数
	obj.gridTubeInfDtl= $HUI.datagrid("#gridTubeInfDtl",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap: false, 	//换行(false为自动换行)
		//fitColumns: true,	
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortName:'EpisodeID',
		sortOrder:'asc',
		remoteSort:false,
		columns:[[
			{field:'DimensDesc',title:'统计单位',width:120,align:'center',sortable: true },
			{field:'EpisodeID',title:'患者ID',width:80,align:'center',sortable: true,sorter:Sort_int },
			{field:'PapmiNo',title:'登记号',width:100,align:'center',sortable: true },
			{field:'MrNo',title:'病案号',width:90,align:'center',sortable: true },
			{field:'PatName',title:'姓名',width:80,align:'center',sortable: true,
				formatter:function(value,row,index){
					 return "<a href='#'  style='white-space:normal; color:blue' onclick='obj.btnAbstractMsg_Click(\"" + row.EpisodeID + "\");'>" +row.PatName+ "</a>";
				}
			},
			{field:'Sex',title:'性别',width:60,align:'center',sortable:true},
			{field:'Age',title:'年龄',width:60,align:'center',sortable:true,sorter:Sort_Age},
			{field:'AdmBed',title:'床号',width:60,align:'center',sortable: true},
			{field:'AdmTimes',title:'住院次数',width:100,align:'center',sortable: true},
			{field:'AdmDateTime',title:'入院时间',width:170,align:'center',sortable: true},
			{field:'AdmLocDesc',title:'入院科室',width:120,align:'center',sortable: true},
			{field:'DischDateTime',title:'出院时间',width:170,align:'center',sortable: true},
			{field:'DischLocDesc',title:'出院科室',width:120,align:'center',sortable: true},
			{field:'TubeDays',title:'插管天数',width:120,align:'center',sortable: true},
			{field:'TranLocDesc',title:'入住病区',width:100,align:'center',sortable: true },
			{field:'TransDateTime',title:'入病区时间',width:170,align:'center',sortable: true},
			{field:'OutLocDateTime',title:'出病区时间',width:170,align:'center',sortable: true},
			{field:'OrdItemID',title:'医嘱号',width:90,align:'center',sortable: true},
			{field:'OEItmMast',title:'侵害性操作名称',width:170,align:'center',sortable: true},
			{field:'SttDateTime',title:'使用开始时间',width:170,align:'center',sortable: true},
			{field:'EndDateTime',title:'使用结束时间',width:170,align:'center',sortable: true},
			{field:'OrdDateTime',title:'开医嘱时间',width:170,align:'center',sortable: true},
			{field:'OrdLocDesc',title:'开医嘱科室',width:100,align:'center',sortable: true},
			{field:'InfPosDesc',title:'感染部位',width:170,align:'center',sortable: true},
			{field:'InfDate',title:'感染日期',width:170,align:'center',sortable: true},
			{field:'InfType',title:'感染类型',width:170,align:'center',sortable: true},
			{field:'EffectDesc',title:'转归情况',width:170,align:'center',sortable: true},
			{field:'InfXDate',title:'转归日期',width:170,align:'center',sortable: true},
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
		
	});
	
	InitIExARatioWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitIExARatioWin();
});
